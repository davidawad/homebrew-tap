class BiomarkerCli < Formula
  desc "Track biomarkers (lab results) for any number of people, encrypted at rest"
  homepage "https://github.com/davidawad/biomarker-cli"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/davidawad/biomarker-cli/releases/download/v0.7.1/biomarker-cli-v0.7.1-aarch64-apple-darwin.tar.gz"
      sha256 "2a3534d34c665bf8232b136c59ded448400a96c9484996d82cde67edc82fb443"
    end
    on_intel do
      url "https://github.com/davidawad/biomarker-cli/releases/download/v0.7.1/biomarker-cli-v0.7.1-x86_64-apple-darwin.tar.gz"
      sha256 "57706f0f2f69a1e1bf2eb23b05048769db1b980daa39ef21595d46742a7b4ca8"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/davidawad/biomarker-cli/releases/download/v0.7.1/biomarker-cli-v0.7.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c98682ad04d8217b242ba8a4b7b439046ae3bc320d47791adfbb64864ed2f484"
    end
    on_intel do
      url "https://github.com/davidawad/biomarker-cli/releases/download/v0.7.1/biomarker-cli-v0.7.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f120f4ff02431d618339684a2c356276541170914260af4afd0aed0449afab9f"
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
