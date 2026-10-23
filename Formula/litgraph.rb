class Litgraph < Formula
  desc "Litigation procedure graph engine: solve, simulate, and explore legal procedure"
  homepage "https://github.com/davidawad/litgraph"
  version "0.5.0"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/davidawad/litgraph/releases/download/v0.5.0/litgraph-v0.5.0-aarch64-apple-darwin.tar.gz"
      sha256 "193c21f7be8d1f99e0e58cda35d01980e05ae5bc6d529acfe5698d1a629adbe4"
    end
    on_intel do
      url "https://github.com/davidawad/litgraph/releases/download/v0.5.0/litgraph-v0.5.0-x86_64-apple-darwin.tar.gz"
      sha256 "9564d0440ba19c56001e21bba182f2ef01ff7df2eb16b7902e72f3844f5a10b0"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/davidawad/litgraph/releases/download/v0.5.0/litgraph-v0.5.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "6009968a30eb95630175cb7c3522aaa66ed71bd363f887baf5409447f1058796"
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
