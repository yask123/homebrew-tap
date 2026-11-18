cask "tracer" do
  version "0.9.2"
  sha256 "94eedafa6f9204cd0ca14c543039e80e1fa6c1183b03bfb566607ef2f0b41cdf"

  url "https://github.com/yask123/tracer/releases/download/v#{version}/Tracer.dmg"
  name "Tracer"
  desc "Draws a pull request as one line through the system it changes"
  homepage "https://yask.dev/tracer"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :tahoe

  app "Tracer.app"

  uninstall quit: "com.yask.tracer"

  zap trash: [
    "~/Library/Application Support/Tracer",
    "~/Library/Preferences/com.yask.tracer.plist",
    "~/Library/Saved Application State/com.yask.tracer.savedState",
  ]

  caveats <<~EOS
    Tracer runs on the GitHub CLI and Claude Code. Its first screen walks you
    through whichever is missing:
      brew install gh
      curl -fsSL https://claude.ai/install.sh | bash
  EOS
end
