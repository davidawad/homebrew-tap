class BiomarkerCli < Formula
  desc "Track biomarkers (lab results) for any number of people, encrypted at rest"
  homepage "https://github.com/davidawad/biomarker-cli"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/davidawad/biomarker-cli/releases/download/v0.8.0/biomarker-cli-v0.8.0-aarch64-apple-darwin.tar.gz"
      sha256 "7f1046fcfad455db32c97a01ff0e7058cda7ce8d17335da0379ad1c23f67ba3d"
    end
    on_intel do
      url "https://github.com/davidawad/biomarker-cli/releases/download/v0.8.0/biomarker-cli-v0.8.0-x86_64-apple-darwin.tar.gz"
      sha256 "9c612bc9a0d94f8d8f915af3104e1a81f74d1f3d90e717036e0ff52a4a46d5e8"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/davidawad/biomarker-cli/releases/download/v0.8.0/biomarker-cli-v0.8.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "48c1e7183ef8b7c2d74937ed6788b32dc03732b676d28830d9dc4f2fa4164d53"
    end
    on_intel do
      url "https://github.com/davidawad/biomarker-cli/releases/download/v0.8.0/biomarker-cli-v0.8.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a483e08955baef1dddb1c21ebb8e40080fc41483c393efda2f47fb92bfb683c6"
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
