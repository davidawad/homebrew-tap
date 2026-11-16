# Homebrew cask for Oats Meetings. Filled by ci/make-cask.sh; lives in the tap as Casks/oats-meetings.rb.
cask "oats-meetings" do
  version "0.1.0"
  sha256 "7e69636584111581fb1bdd3e3a9de159f5833adba8e4e5b972c92ed6dcc8504f"

  url "https://github.com/davidawad/oats-meetings-rs/releases/download/v#{version}/Oats-Meetings-#{version}-arm64.zip"
  name "Oats Meetings"
  desc "Local meeting recorder and transcriber"
  homepage "https://github.com/davidawad/oats-meetings-rs"

  depends_on arch: :arm64
  depends_on macos: ">= :ventura"

  app "Oats Meetings.app"
  binary "#{appdir}/Oats Meetings.app/Contents/MacOS/oats-meetings-rs", target: "oats"

  # The app is ad-hoc signed, not notarized: without this macOS quarantines a downloaded copy.
  # Remove once releases are notarized with a Developer ID.
  postflight do
    system_command "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "#{appdir}/Oats Meetings.app"]
  end

  zap trash: [
    "~/Library/Application Support/oats-meetings-rs",
    "~/.config/oats-meetings-rs",
  ]
end
