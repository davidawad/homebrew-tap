class BiomarkerCli < Formula
  desc "Track biomarkers (lab results) for any number of people, encrypted at rest"
  homepage "https://gitlab.com/davidawad/biomarker-cli"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/davidawad/biomarker-cli/releases/download/v0.3.0/biomarker-cli-v0.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "c699e3e653d9b119e121b38096f6f18d33bd349463869297a2333ec46aa8b329"
    end
    on_intel do
      url "https://github.com/davidawad/biomarker-cli/releases/download/v0.3.0/biomarker-cli-v0.3.0-x86_64-apple-darwin.tar.gz"
      sha256 "ba6ee70b4e7fcf1ef6749edbefd8a3bef0df582ab43d7e4e1353f38df528cec2"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/davidawad/biomarker-cli/releases/download/v0.3.0/biomarker-cli-v0.3.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1037abd317084de6ef6c91ac567d8341fdc6fc28cb48a3d40621a4d5d05c08e5"
    end
    on_intel do
      url "https://github.com/davidawad/biomarker-cli/releases/download/v0.3.0/biomarker-cli-v0.3.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "184548ad761b07d0069d7abb12ebda1a09384a3c9cb871ace3ed9dcb98e0db7f"
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
      Databases are encrypted at rest; the key lives in the OS keychain by default.
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
