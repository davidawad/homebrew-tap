class Litgraph < Formula
  desc "Litigation procedure graph engine: solve, simulate, and explore legal procedure"
  homepage "https://github.com/davidawad/litgraph"
  version "0.4.0"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/davidawad/litgraph/releases/download/v0.4.0/litgraph-v0.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "a6eec2a21b6e6d72d8004ba9ab9b8d666fbc9c96832976e8cf00e79db477f60d"
    end
    on_intel do
      url "https://github.com/davidawad/litgraph/releases/download/v0.4.0/litgraph-v0.4.0-x86_64-apple-darwin.tar.gz"
      sha256 "d490d7916ed42bbaa16a5f6468083ea649bb120a44b4aa0112242c3cd37a2bd9"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/davidawad/litgraph/releases/download/v0.4.0/litgraph-v0.4.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "65a5a063302950283c5664ceff5330b8c0a601b5b84855ea58033650dc0f7e41"
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
