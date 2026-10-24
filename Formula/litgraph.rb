class Litgraph < Formula
  desc "Litigation procedure graph engine: solve, simulate, and explore legal procedure"
  homepage "https://github.com/davidawad/litgraph"
  version "0.6.0"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/davidawad/litgraph/releases/download/v0.6.0/litgraph-v0.6.0-aarch64-apple-darwin.tar.gz"
      sha256 "80168bd3e59855d050549d64ed5f40f863ef7ee0efb7333f4c53df70093da447"
    end
    on_intel do
      url "https://github.com/davidawad/litgraph/releases/download/v0.6.0/litgraph-v0.6.0-x86_64-apple-darwin.tar.gz"
      sha256 "47739d21cb35f1449c457d3a90a703d85339d945775b13b1b47e67f5a7ee96cf"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/davidawad/litgraph/releases/download/v0.6.0/litgraph-v0.6.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "08bdb0470cb30ba44d24defea19764277855b4bb535ca7e9c86bd90ed6b9fc35"
    end
  end

  def install
    bin.install "litgraph"
    bin.install "litgraph-mcp"
    bin.install "litigate"
    bin.install "litigate-lsp"
    pkgshare.install "packs"
  end

  test do
    assert_match "\"ok\":true", shell_output("#{bin}/litgraph describe --compact")
    assert_match "litigate", shell_output("#{bin}/litigate --version")
  end
end
