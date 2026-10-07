class FinancialCharts < Formula
  desc "Emacs library for market charts: text in a terminal, SVG in a GUI"
  homepage "https://github.com/davidawad/financial-charts.el"
  url "https://github.com/davidawad/financial-charts.el/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "d96dc92daf8e12a5326e62a779cf96551d6760b54094bc674cb23ffd422d4a01"
  license "MIT"
  head "https://github.com/davidawad/financial-charts.el.git", branch: "main"

  depends_on "eas"
  depends_on "emacs"

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
    loads = ["#{Formula["eas"].opt_share}/emacs/site-lisp/eas/src",
             *%w[src src/core src/indicators src/charts src/integrations].map { |d| "#{site}/#{d}" }]
    args = loads.flat_map { |d| ["-L", d] }
    out = shell_output("#{formula_opt_bin("emacs")}/emacs -Q --batch #{args.join(" ")} " \
                       "--eval '(require (quote financial-chart))' " \
                       "--eval '(princ (financial-chart-compose-render " \
                       "\"#{testpath}/chart.json\" :backend (quote text) :width 60 :height 16))'")
    assert_match "Brew test", out
    assert_path_exists site/"templates/ohlc.json"
  end
end
