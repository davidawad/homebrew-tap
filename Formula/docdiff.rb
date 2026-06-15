class Docdiff < Formula
  desc "Git-diff style plaintext compare for Word and other legal documents"
  homepage "https://gitlab.com/davidawad/docdiff"
  url "https://gitlab.com/davidawad/docdiff/-/archive/v0.3.0/docdiff-v0.3.0.tar.gz"
  sha256 "f3ac00f56264a52783a047678c9bc4a12f72981d1fb88e813898ef70f92051a2"
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
