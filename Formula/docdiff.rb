class Docdiff < Formula
  desc "Git-diff style plaintext compare for Word and other legal documents"
  homepage "https://gitlab.com/davidawad/docdiff"
  url "https://gitlab.com/davidawad/docdiff/-/archive/v0.4.2/docdiff-v0.4.2.tar.gz"
  sha256 "5bdf70680ac0b9175530fd085a9eee46e6cf9dedb7310f3d0e1ad2af5de20bb0"
  license "MIT"
  head "https://gitlab.com/davidawad/docdiff.git", branch: "main"

  depends_on "rust" => :build

  depends_on "antiword"
  depends_on "pandoc"
  depends_on "poppler" # provides pdftotext

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "docdiff", shell_output("#{bin}/docdiff --help")
  end
end
