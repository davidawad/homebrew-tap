class Docdiff < Formula
  desc "Git-diff style plaintext compare for Word and other legal documents"
  homepage "https://gitlab.com/davidawad/docdiff"
  url "https://gitlab.com/davidawad/docdiff/-/archive/v0.4.0/docdiff-v0.4.0.tar.gz"
  sha256 "2717d77c3234d728cc728325e9af1cf652c5b7105b02356442f5b157f50386de"
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
