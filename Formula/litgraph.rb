class Litgraph < Formula
  desc "Litigation procedure graph engine: solve, simulate, and explore legal procedure"
  homepage "https://github.com/davidawad/litgraph"
  version "0.2.0"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/davidawad/litgraph/releases/download/v0.2.0/litgraph-v0.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "6c1c30dd2d4619eced316dc76f8ab50a97a191d0f2fe83310af58a922dfa5f85"
    end
    on_intel do
      url "https://github.com/davidawad/litgraph/releases/download/v0.2.0/litgraph-v0.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "305b8261c4221eaaf8a289eb44afc3a9856b795f339e713a04a95548bae41d16"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/davidawad/litgraph/releases/download/v0.2.0/litgraph-v0.2.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "eb0b0b6d2ef61f329464813209fab13aff919eed5c6f7bc0f29dcb928d144af8"
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
