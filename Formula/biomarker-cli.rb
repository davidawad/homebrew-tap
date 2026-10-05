class BiomarkerCli < Formula
  desc "Track biomarkers (lab results) for any number of people, encrypted at rest"
  homepage "https://gitlab.com/davidawad/biomarker-cli"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/davidawad/biomarker-cli/releases/download/v0.5.0/biomarker-cli-v0.5.0-aarch64-apple-darwin.tar.gz"
      sha256 "f64dc0749ae2fb4dcbb038789de5abccd16941731500282c8fc9db1873e879d2"
    end
    on_intel do
      url "https://github.com/davidawad/biomarker-cli/releases/download/v0.5.0/biomarker-cli-v0.5.0-x86_64-apple-darwin.tar.gz"
      sha256 "cabc09605674fa529cf9831dde3b856c1e2d1b76e86efd2b95e27a8f044898ae"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/davidawad/biomarker-cli/releases/download/v0.5.0/biomarker-cli-v0.5.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "aca55e2077f2bd62caf717d8c8943e9e8d745abb6f1c70fcd9ef85a0a192d67e"
    end
    on_intel do
      url "https://github.com/davidawad/biomarker-cli/releases/download/v0.5.0/biomarker-cli-v0.5.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d4ee548cc30715a118941df74ac8077591304608146d5fdfffb15dddab74c710"
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
