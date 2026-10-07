class HealthCharts < Formula
  desc "Emacs library for medical and health charts: text in a terminal, SVG in a GUI"
  homepage "https://github.com/davidawad/health-charts.el"
  url "https://github.com/davidawad/health-charts.el/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "da30786034a952765acc5d2b53821a6bcaf85fb8740686149deb0928814cd5e5"
  license "MIT"
  head "https://github.com/davidawad/health-charts.el.git", branch: "main"

  depends_on "eas"
  depends_on "emacs"

  def install
    # Keep the repository layout: health-chart finds templates/ and examples/
    # relative to src/, so they stay siblings.
    site = share/"emacs/site-lisp/health-charts"
    site.install "src", "templates", "examples"
  end

  def caveats
    prefix = "#{HOMEBREW_PREFIX}/share/emacs/site-lisp"
    <<~EOS
      To use health-chart from Emacs, add this to your init.el:

        (add-to-list 'load-path "#{prefix}/eas/src")
        (add-to-list 'load-path "#{prefix}/health-charts/src")
        (require 'health-chart)
    EOS
  end

  test do
    site = share/"emacs/site-lisp/health-charts"
    args = ["-L", "#{Formula["eas"].opt_share}/emacs/site-lisp/eas/src", "-L", "#{site}/src"]
    out = shell_output("#{formula_opt_bin("emacs")}/emacs -Q --batch #{args.join(" ")} " \
                       "--eval '(require (quote health-chart))' " \
                       "--eval '(princ (health-chart-render \"vitals-trend\" " \
                       "(health-chart-example \"vitals-trend\") :backend (quote text)))'")
    assert_match "─", out
    assert_path_exists site/"templates/vitals-trend.json"
  end
end
