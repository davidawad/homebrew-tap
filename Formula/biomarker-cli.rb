class BiomarkerCli < Formula
  desc "Track biomarkers (lab results) for any number of people, encrypted at rest"
  homepage "https://github.com/davidawad/biomarker-cli"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/davidawad/biomarker-cli/releases/download/v0.8.1/biomarker-cli-v0.8.1-aarch64-apple-darwin.tar.gz"
      sha256 "af5dcda58f056411c7ae225f6195395a09f0b3876b163a99d5698b1646b9c9ed"
    end
    on_intel do
      url "https://github.com/davidawad/biomarker-cli/releases/download/v0.8.1/biomarker-cli-v0.8.1-x86_64-apple-darwin.tar.gz"
      sha256 "70e4cdb67b189ac143356b5127d70b61c46064439a31aa6b9fb5daa1b6a623b2"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/davidawad/biomarker-cli/releases/download/v0.8.1/biomarker-cli-v0.8.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "36f55635f3aa8e14c717697e82242d907f5ae4668addf1cc7c97b687c7bb20d4"
    end
    on_intel do
      url "https://github.com/davidawad/biomarker-cli/releases/download/v0.8.1/biomarker-cli-v0.8.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4996e432cf924f45c38d0fcb0f0510b3bcef0675889ca0eae6e1afc48eb2a470"
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
