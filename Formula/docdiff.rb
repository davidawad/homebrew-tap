class Docdiff < Formula
  desc "Git-diff style plaintext compare for Word and other legal documents"
  homepage "https://gitlab.com/davidawad/docdiff"
  url "https://gitlab.com/davidawad/docdiff/-/archive/v0.1.0/docdiff-v0.1.0.tar.gz"
  sha256 "693e940ecc5326b7dacae2e130e6d834425c99c0926456f2997cdc8ff6c6df43"
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
