class BiomarkerCli < Formula
  desc "Track biomarkers (lab results) for any number of people, encrypted at rest"
  homepage "https://github.com/davidawad/biomarker-cli"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/davidawad/biomarker-cli/releases/download/v0.7.0/biomarker-cli-v0.7.0-aarch64-apple-darwin.tar.gz"
      sha256 "0918f2e30ed5ac0a4b14e0c1e5442f8bfd3291fd336ae93c8f2da79fb0bbe7de"
    end
    on_intel do
      url "https://github.com/davidawad/biomarker-cli/releases/download/v0.7.0/biomarker-cli-v0.7.0-x86_64-apple-darwin.tar.gz"
      sha256 "33950594d435843ebec6b38f11cc5ef08c3119dbabc850270aee174fb1c7629d"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/davidawad/biomarker-cli/releases/download/v0.7.0/biomarker-cli-v0.7.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a48bc1539fa84eb3c63fa9a75dba52193807440a750625fc010f1d8d0becea89"
    end
    on_intel do
      url "https://github.com/davidawad/biomarker-cli/releases/download/v0.7.0/biomarker-cli-v0.7.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "090c5834128271b767e85d39504c0801a733b5dd6c8d49bea105bc11e11d40ac"
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
