# frozen_string_literal: true

class HealthCharts < Formula
  desc "Emacs library for medical and health charts: text in a terminal, SVG in a GUI"
  homepage "https://github.com/davidawad/health-charts.el"
  url "https://github.com/davidawad/health-charts.el/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "3111d88d15e4e4153f424c80db23ad592a209bd1d2702d11797a9930b0f3efc2"
  license "MIT"
  head "https://github.com/davidawad/health-charts.el.git", branch: "main"

  depends_on "easel"

  # Use the Emacs already on PATH (emacs-plus, emacs-mac, Homebrew's emacs,
  # a distro Emacs) instead of depending on Homebrew's emacs: that keg cannot
  # link next to emacs-plus, and byte-compiling with one Emacs and loading
  # with another is fragile.  HOMEBREW_EMACS overrides the choice.
  def user_emacs
    emacs = ENV.fetch("HOMEBREW_EMACS", nil)
    emacs = which("emacs", ENV.fetch("HOMEBREW_PATH", ENV.fetch("PATH", nil)))&.to_s if emacs.blank?
    odie "#{name} needs Emacs 30.1 or newer on PATH (brew install emacs, or emacs-plus)." if emacs.nil?
    major = Utils.safe_popen_read(emacs, "-Q", "--batch", "--eval", "(princ emacs-major-version)").to_i
    odie "#{name} needs Emacs 30.1 or newer; #{emacs} is Emacs #{major}." if major < 30
    emacs
  end

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
    args = ["-L", "#{Formula["easel"].opt_share}/emacs/site-lisp/eas/src", "-L", "#{site}/src"]
    out = shell_output("#{user_emacs} -Q --batch #{args.join(" ")} " \
                       "--eval '(require (quote health-chart))' " \
                       "--eval '(princ (health-chart-render \"vitals-trend\" " \
                       "(health-chart-example \"vitals-trend\") :backend (quote text)))'")
    assert_match "─", out
    assert_path_exists site/"templates/vitals-trend.json"
  end
end
