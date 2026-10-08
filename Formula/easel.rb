# frozen_string_literal: true

class Easel < Formula
  desc "Interactive, agent-drivable charts from declarative JSON, in pure Emacs Lisp"
  homepage "https://github.com/davidawad/eas.el"
  url "https://github.com/davidawad/eas.el/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "bb18d9729bad8fa9249c1ae03242e1d6ea1fcfd2ee4f99367eb34468a0242c4a"
  license "GPL-3.0-or-later"
  head "https://github.com/davidawad/eas.el.git", branch: "main"

  depends_on "rust" => :build

  # Use the Emacs already on PATH (emacs-plus, emacs-mac, Homebrew's emacs,
  # a distro Emacs) instead of depending on Homebrew's emacs: that keg cannot
  # link next to emacs-plus, and byte-compiling with one Emacs and loading
  # with another is fragile.  HOMEBREW_EMACS overrides the choice.
  def user_emacs
    emacs = ENV.fetch("HOMEBREW_EMACS", nil)
    emacs = which("emacs", ORIGINAL_PATHS + [HOMEBREW_PREFIX/"bin"])&.to_s if emacs.blank?
    odie "#{name} needs Emacs 30.1 or newer on PATH (brew install emacs, or emacs-plus)." if emacs.nil?
    major = Utils.safe_popen_read(emacs, "-Q", "--batch", "--eval", "(princ emacs-major-version)").to_i
    odie "#{name} needs Emacs 30.1 or newer; #{emacs} is Emacs #{major}." if major < 30
    emacs
  end

  def install
    emacs = user_emacs
    # The optional native geo module (map projections).  eas runs without it
    # (pure Elisp); building it here makes brew users get it by default.
    system "make", "module", "EMACS=#{emacs}"
    # Emacs on macOS may ask for .dylib or .so; dlopen accepts either, so
    # install the library under both names.
    if OS.mac?
      %w[.dylib .so].each do |suffix|
        other = buildpath/"lib/eas-geo-module#{suffix}"
        next if other.exist?

        built = Dir[buildpath/"lib/eas-geo-module.*"].first
        cp built, other if built
      end
    end

    # Byte-compile the library (as packaging/eas.rb.in's `make compile` did):
    # uncompiled Elisp makes every first render several times slower.
    # Tests are not installed (MELPA's recipe drops them too).
    rm Dir["src/*-test.el"]
    system emacs, "-Q", "--batch", "-L", "src",
           "-f", "batch-byte-compile", *Dir["src/*.el"]

    # Keep the repository layout (src/, templates/, lib/, bin/): eas finds its
    # templates and the module relative to its own src/ directory.
    site = share/"emacs/site-lisp/eas"
    site.install "src", "templates", "examples", "lib"
    (site/"bin").install "bin/eas"

    (bin/"eas").write <<~EOS
      #!/bin/sh
      export EMACS="${EMACS:-#{emacs}}"
      exec "#{site}/bin/eas" "$@"
    EOS
  end

  def caveats
    <<~EOS
      To use eas from Emacs, add this to your init.el:

        (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp/eas/src")
        (require 'eas)

      The optional Rust geo module is installed and used by default for map
      projections.  Check with M-: (eas-geo-backend-active), which returns
      native or lisp.  Set `eas-geo-backend' to lisp to never load it.

      The `eas` command-line tool is installed on your PATH (try `eas describe`).
    EOS
  end

  test do
    (testpath/"data.json").write <<~JSON
      {"title": "Brew test", "data": [
        {"date": "2026-03-02", "value": 1},
        {"date": "2026-03-03", "value": 3},
        {"date": "2026-03-04", "value": 2},
        {"date": "2026-03-05", "value": 5}
      ]}
    JSON
    site = share/"emacs/site-lisp/eas"
    out = shell_output("#{user_emacs} -Q --batch -L #{site}/src " \
                       "--eval '(require (quote eas))' --eval '(princ \"loaded\")'")
    assert_match "loaded", out
    active = shell_output("#{user_emacs} -Q --batch -L #{site}/src " \
                          "--eval '(require (quote eas))' --eval '(princ (eas-geo-backend-active))'")
    assert_equal "native", active.lines.last.strip
    assert_match "Brew test", shell_output("#{bin}/eas render line --data #{testpath}/data.json --raw")
    assert_path_exists site/"src/eas.elc"
    # The module must draw the same map as pure Elisp, byte for byte.
    world = "#{site}/examples/vega/projections.data.json"
    render = "render projections --data #{world} --backend svg --raw"
    native = shell_output("#{bin}/eas #{render}")
    lisp = shell_output("#{user_emacs} -Q --batch -L #{site}/src " \
                        "--eval '(setq eas-geo-backend (quote lisp))' -l eas-agent-cli " \
                        "-f eas-agent-cli-main -- #{render}")
    assert_match "<svg", native
    assert_equal native, lisp
  end
end
