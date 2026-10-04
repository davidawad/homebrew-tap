class BiomarkerCli < Formula
  desc "Track biomarkers (lab results) for any number of people, encrypted at rest"
  homepage "https://gitlab.com/davidawad/biomarker-cli"
  url "https://gitlab.com/davidawad/biomarker-cli/-/archive/v0.2.0/biomarker-cli-v0.2.0.tar.gz"
  sha256 "e0446ed3f81b793d83132d019b7be7ae3ac4e80f36ffe400718084536c34a830"
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

  def caveats
    <<~EOS
      Databases are encrypted at rest; the key lives in the macOS Keychain by default.
      A database created by 0.1.0 is plaintext: run `biomarker db encrypt` once.
    EOS
  end

  test do
    ENV["BIOMARKER_DB"] = testpath/"test.db"
    ENV["BIOMARKER_KEY_SOURCE"] = "env"
    ENV["BIOMARKER_KEY"] = "brew-test-passphrase"
    ENV["BIOMARKER_NO_KEYCHAIN"] = "1"
    system bin/"biomarker", "db", "init"
    system bin/"biomarker", "person", "add", "alex"
    system bin/"biomarker", "add", "ldl", "96", "--person", "alex", "--date", "2024-03-05"
    assert_match "\"schema\": \"biomarker/v1\"",
                 shell_output("#{bin}/biomarker latest --person alex --format json")
    refute_match "biomarker/v1", (testpath/"test.db").binread
  end
end
