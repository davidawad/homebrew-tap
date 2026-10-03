class BiomarkerCli < Formula
  desc "Track biomarkers (lab results) for any number of people in a local database"
  homepage "https://gitlab.com/davidawad/biomarker-cli"
  url "https://gitlab.com/davidawad/biomarker-cli/-/archive/v0.1.0/biomarker-cli-v0.1.0.tar.gz"
  sha256 "cfa5ddc26dd2263c6739f13d5843c6a9ca5f3c507d913b0ccde7d9b8515ec600"
  license "MIT"
  head "https://gitlab.com/davidawad/biomarker-cli.git", branch: "main"

  # fsqlite 0.4 needs nightly Rust on x86_64; on aarch64 it builds on stable.
  depends_on arch: :arm64
  depends_on "rust" => :build

  def install
    # The repo pins nightly for x86_64 rustup users; brew's stable rust is enough here.
    rm "rust-toolchain.toml"
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"biomarker", "completions")
    system bin/"biomarker", "man", "--dir", man1
  end

  test do
    db = testpath/"test.db"
    system bin/"biomarker", "--db", db, "db", "init"
    system bin/"biomarker", "--db", db, "person", "add", "alex"
    system bin/"biomarker", "--db", db, "add", "ldl", "96", "--person", "alex", "--date", "2024-03-05"
    assert_match "\"schema\": \"biomarker/v1\"",
                 shell_output("#{bin}/biomarker --db #{db} latest --person alex --format json")
  end
end
