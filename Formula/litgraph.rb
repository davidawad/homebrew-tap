class Litgraph < Formula
  desc "Litigation procedure graph engine: solve, simulate, and explore legal procedure"
  homepage "https://github.com/davidawad/litgraph"
  version "0.2.1"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/davidawad/litgraph/releases/download/v0.2.1/litgraph-v0.2.1-aarch64-apple-darwin.tar.gz"
      sha256 "e658e7ef23faea8d4d258d32a789f6243718503d16777764a0df222aa065b5df"
    end
    on_intel do
      url "https://github.com/davidawad/litgraph/releases/download/v0.2.1/litgraph-v0.2.1-x86_64-apple-darwin.tar.gz"
      sha256 "10586faf2bbb718a9a767a786e2d4f98c4cee723576e5981f5a5ecd0f039a3b9"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/davidawad/litgraph/releases/download/v0.2.1/litgraph-v0.2.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "cc1e5399f36b752e9d8dbacccde1771aa1e7e8ba2b09281708f6a5cdf7e280bb"
    end
  end

  def install
    bin.install "litgraph"
    bin.install "litgraph-mcp"
    pkgshare.install "packs"
  end

  test do
    assert_match "\"ok\":true", shell_output("#{bin}/litgraph describe --compact")
  end
end
