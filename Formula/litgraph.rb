class Litgraph < Formula
  desc "Litigation procedure graph engine: solve, simulate, and explore legal procedure"
  homepage "https://github.com/davidawad/litgraph"
  version "0.1.0"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/davidawad/litgraph/releases/download/v0.1.0/litgraph-v0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "8891f6919d90065ab64b0cc81aa87a1610c53f55b11f7bdb747e08c4fb026f65"
    end
    on_intel do
      url "https://github.com/davidawad/litgraph/releases/download/v0.1.0/litgraph-v0.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "8490dbbcf9d9f064894572cdb0492dbe42c8eb6c220f9b92d4eaedfcf7f4ed82"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/davidawad/litgraph/releases/download/v0.1.0/litgraph-v0.1.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "9f890e68ceda48ca796acff5fa8d16287b01354a5392eb46c303518df624f4df"
    end
  end

  def install
    bin.install "litgraph"
    bin.install "litgraph-mcp" if File.exist?("litgraph-mcp")
    pkgshare.install "packs"
  end

  test do
    assert_match "\"ok\":true", shell_output("#{bin}/litgraph describe --compact")
  end
end
