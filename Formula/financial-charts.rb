class FinancialCharts < Formula
  desc "Emacs library for market charts: text in a terminal, SVG in a GUI"
  homepage "https://github.com/davidawad/financial-charts.el"
  license "MIT"
  head "https://github.com/davidawad/financial-charts.el.git", branch: "main"

  # HEAD-only until a tagged release exists (the fc-uses-eas branch, which
  # makes this depend on eas, is not merged yet). bin/financial-chart is being
  # removed upstream and is deliberately not installed.

  depends_on "emacs"

  def install
    (share/"emacs/site-lisp/financial-charts").install Dir["financial-chart*.el"]
  end

  def caveats
    <<~EOS
      To use financial-chart from Emacs, add this to your init.el:

        (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp/financial-charts")
        (require 'financial-chart)
    EOS
  end

  test do
    site = share/"emacs/site-lisp/financial-charts"
    assert_match "loaded", shell_output("#{formula_opt_bin("emacs")}/emacs -Q --batch -L #{site} " \
                                        "--eval '(require (quote financial-chart))' " \
                                        "--eval '(princ \"loaded\")'")
  end
end
