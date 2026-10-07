class BiomarkerCli < Formula
  desc "Track biomarkers (lab results) for any number of people, encrypted at rest"
  homepage "https://github.com/davidawad/biomarker-cli"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/davidawad/biomarker-cli/releases/download/v0.6.0/biomarker-cli-v0.6.0-aarch64-apple-darwin.tar.gz"
      sha256 "f77992da3a0535df718d1177f9b39a7a73c1017df3f914b38051929e91f8ad08"
    end
    on_intel do
      url "https://github.com/davidawad/biomarker-cli/releases/download/v0.6.0/biomarker-cli-v0.6.0-x86_64-apple-darwin.tar.gz"
      sha256 "044701544a2d1fcce097f21a92bad56303b1876b66c88714a183b095c9205695"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/davidawad/biomarker-cli/releases/download/v0.6.0/biomarker-cli-v0.6.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3c6f33840f8f51e8b29133e0050a6eec87d5a7a7b8f3dc08f585d8f480208d7d"
    end
    on_intel do
      url "https://github.com/davidawad/biomarker-cli/releases/download/v0.6.0/biomarker-cli-v0.6.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7dd0009b4ddba84fe25acbcccd6e808520633c0f25ab0d45adca492bda5d054e"
    end
  end

  # Prebuilt release binaries: fsqlite 0.4 needs nightly Rust on x86_64,
  # which Homebrew does not ship, so building from source is left to `cargo`.
  def install
    bin.install "biomarker"
    generate_completions_from_executable(bin/"biomarker", "completions")
    system bin/"biomarker", "man", "--dir", man1
  end

  def caveats
    <<~EOS
      Databases are encrypted at rest with your SSH key (~/.ssh/id_ed25519) by default; see `biomarker key status`.
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
