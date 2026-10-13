class BiomarkerCli < Formula
  desc "Track biomarkers (lab results) for any number of people, encrypted at rest"
  homepage "https://github.com/davidawad/biomarker-cli"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/davidawad/biomarker-cli/releases/download/v0.7.2/biomarker-cli-v0.7.2-aarch64-apple-darwin.tar.gz"
      sha256 "aa33ea194ad4e0cfaae88318e51a5bf8b605f37b84070f6cda0f1b9f8f8dc993"
    end
    on_intel do
      url "https://github.com/davidawad/biomarker-cli/releases/download/v0.7.2/biomarker-cli-v0.7.2-x86_64-apple-darwin.tar.gz"
      sha256 "42d9bdf89ff4117f0aa8049bdefdcb0b4effb041f0cebb1fc7625628002fc9e9"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/davidawad/biomarker-cli/releases/download/v0.7.2/biomarker-cli-v0.7.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "57ffec8896ccc7996686ed8d71d59b4d0893e9701fab53eb4260f6b83a685a7b"
    end
    on_intel do
      url "https://github.com/davidawad/biomarker-cli/releases/download/v0.7.2/biomarker-cli-v0.7.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e844011b1a46ec732b5d0a3564ff2ff1bbb4acba9d2fcb70f846d3172c1ae142"
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
