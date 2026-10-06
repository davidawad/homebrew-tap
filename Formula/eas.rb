class Eas < Formula
  desc "Interactive, agent-drivable charts from declarative JSON, in pure Emacs Lisp"
  homepage "https://github.com/davidawad/eas.el"
  url "https://github.com/davidawad/eas.el/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "1cbc1fac78f9811bf313afacfbbb69493d31861c4ca21e024fc23e29275a1a79"
  license "GPL-3.0-or-later"
  head "https://github.com/davidawad/eas.el.git", branch: "main"

  depends_on "emacs"

  def install
    # Keep the repository layout (src/, templates/, bin/): eas finds its
    # templates relative to its own src/ directory (eas-template--root).
    site = share/"emacs/site-lisp/eas"
    site.install "src", "templates", "examples"
    (site/"bin").install "bin/eas"

    (bin/"eas").write <<~EOS
      #!/bin/sh
      export EMACS="${EMACS:-#{formula_opt_bin("emacs")}/emacs}"
      exec "#{site}/bin/eas" "$@"
    EOS
  end

  def caveats
    <<~EOS
      To use eas from Emacs, add this to your init.el:

        (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp/eas/src")
        (require 'eas)

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
    out = shell_output("#{formula_opt_bin("emacs")}/emacs -Q --batch -L #{site}/src " \
                       "--eval '(require (quote eas))' --eval '(princ \"loaded\")'")
    assert_match "loaded", out
    assert_match "Brew test", shell_output("#{bin}/eas render line --data #{testpath}/data.json --raw")
  end
end
