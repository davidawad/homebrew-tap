# frozen_string_literal: true

class FinancialCharts < Formula
  desc "Emacs library for market charts: text in a terminal, SVG in a GUI"
  homepage "https://github.com/davidawad/financial-charts.el"
  url "https://github.com/davidawad/financial-charts.el/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "c93836dd2fcdf966857cb2bed078b5526e7e2e2748ec87970235e8818874eb67"
  license "MIT"
  head "https://github.com/davidawad/financial-charts.el.git", branch: "main"

  depends_on "easel"

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
    # Keep the repository layout (src/<group>/, templates/, examples/):
    # financial-chart-eas finds its templates relative to its own directory
    # (../../templates), so src/ and templates/ must stay siblings.
    site = share/"emacs/site-lisp/financial-charts"
    site.install "src", "templates", "examples"
  end

  def caveats
    prefix = "#{HOMEBREW_PREFIX}/share/emacs/site-lisp"
    <<~EOS
      To use financial-chart from Emacs, add this to your init.el:

        (add-to-list 'load-path "#{prefix}/eas/src")
        (dolist (dir '("src" "src/core" "src/indicators" "src/charts" "src/integrations"))
          (add-to-list 'load-path (expand-file-name dir "#{prefix}/financial-charts")))
        (require 'financial-chart)
    EOS
  end

  test do
    (testpath/"chart.json").write <<~JSON
      {"title": "Brew test", "bars": [
        {"time": "2026-03-02", "open": 100.0, "high": 102.0, "low": 99.0, "close": 101.5},
        {"time": "2026-03-03", "open": 101.5, "high": 103.0, "low": 100.5, "close": 102.5},
        {"time": "2026-03-04", "open": 102.5, "high": 103.5, "low": 100.0, "close": 100.5},
        {"time": "2026-03-05", "open": 100.5, "high": 101.5, "low": 98.5, "close": 99.0},
        {"time": "2026-03-06", "open": 99.0, "high": 102.0, "low": 98.0, "close": 101.0}
      ], "price": {"style": "candles"}}
    JSON

    site = share/"emacs/site-lisp/financial-charts"
    loads = ["#{Formula["easel"].opt_share}/emacs/site-lisp/eas/src",
             *%w[src src/core src/indicators src/charts src/integrations].map { |d| "#{site}/#{d}" }]
    args = loads.flat_map { |d| ["-L", d] }
    out = shell_output("#{user_emacs} -Q --batch #{args.join(" ")} " \
                       "--eval '(require (quote financial-chart))' " \
                       "--eval '(princ (financial-chart-compose-render " \
                       "\"#{testpath}/chart.json\" :backend (quote text) :width 60 :height 16))'")
    assert_match "Brew test", out
    assert_path_exists site/"templates/ohlc.json"
  end
end
