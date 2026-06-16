class Docdiff < Formula
  desc "Git-diff style plaintext compare for Word and other legal documents"
  homepage "https://gitlab.com/davidawad/docdiff"
  url "https://gitlab.com/davidawad/docdiff/-/archive/v0.4.1/docdiff-v0.4.1.tar.gz"
  sha256 "703f6506a6f46b22f2a40a0ad0fa35397c66436f6ab76008f7d7d29bc7999302"
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
