class Litgraph < Formula
  desc "Litigation procedure graph engine: solve, simulate, and explore legal procedure"
  homepage "https://github.com/davidawad/litgraph"
  version "0.3.0"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/davidawad/litgraph/releases/download/v0.3.0/litgraph-v0.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "300340e53da604db8aab751a8351f29155925b460a3a985cdd5b665ff85ff55e"
    end
    on_intel do
      url "https://github.com/davidawad/litgraph/releases/download/v0.3.0/litgraph-v0.3.0-x86_64-apple-darwin.tar.gz"
      sha256 "61165fe10b880d631adb547d11c94f4a585c2ce4e043867853911a9ab1e354a1"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/davidawad/litgraph/releases/download/v0.3.0/litgraph-v0.3.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "a6f593efa12fe08d61cf8479c6617f54d092846583b078bc666164fec3456c6c"
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
