class BiomarkerCli < Formula
  desc "Track biomarkers (lab results) for any number of people, encrypted at rest"
  homepage "https://gitlab.com/davidawad/biomarker-cli"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/davidawad/biomarker-cli/releases/download/v0.4.0/biomarker-cli-v0.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "e3a0296aad28561e4a61663e883975fb4003d97e3c3fc4a76ceb0ccf20996ea7"
    end
    on_intel do
      url "https://github.com/davidawad/biomarker-cli/releases/download/v0.4.0/biomarker-cli-v0.4.0-x86_64-apple-darwin.tar.gz"
      sha256 "d4e0793099a566f288fb533b08cf32e5e6f7354933cc65e715fc76223486a4a3"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/davidawad/biomarker-cli/releases/download/v0.4.0/biomarker-cli-v0.4.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1e61bad17c137cdf991f4c9ac9736437073c49b7c7852b3e9dc7336ace8f9fb5"
    end
    on_intel do
      url "https://github.com/davidawad/biomarker-cli/releases/download/v0.4.0/biomarker-cli-v0.4.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2a34a3ff76ad93770d230db8b76829190781050f503c0d73fd2a43dd52e3ef3a"
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
