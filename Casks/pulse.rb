cask "pulse" do
  version "1.0.0"
  sha256 "666adaaca38a2d3112670fcaca8d9eed1bf80fa65dbc5851600123399e9a70e1"

  url "https://github.com/yask123/pulse/releases/download/v#{version}/Pulse-#{version}.zip"
  name "Pulse"
  desc "Menu bar system monitor for Apple Silicon Macs"
  homepage "https://yask.dev/pulse"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :tahoe

  app "Pulse.app"

  # Pulse is ad-hoc signed, not notarized.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Pulse.app"]
  end

  uninstall quit: "com.yask.pulse"

  zap trash: "~/Library/Preferences/com.yask.pulse.plist"
end
