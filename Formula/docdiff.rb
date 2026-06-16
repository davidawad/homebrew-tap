class Docdiff < Formula
  desc "Git-diff style plaintext compare for Word and other legal documents"
  homepage "https://gitlab.com/davidawad/docdiff"
  url "https://gitlab.com/davidawad/docdiff/-/archive/v0.5.1/docdiff-v0.5.1.tar.gz"
  sha256 "d8ace33310c8efab3026ac5920194c74ff6347eab6a724ecaa32c41aa050b514"
  license "MIT"
  head "https://gitlab.com/davidawad/docdiff.git", branch: "main"

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  depends_on "antiword"
  depends_on "libgit2"
  depends_on "pandoc"
  depends_on "poppler" # provides pdftotext

  def install
    # Use brew's libgit2 instead of the vendored copy — the vendored build
    # fails on macOS 26+ due to CoreFoundation header path changes.
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "docdiff", shell_output("#{bin}/docdiff --help")
  end
end
