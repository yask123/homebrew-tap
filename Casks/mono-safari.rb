cask "mono-safari" do
  version "0.2.1"
  sha256 "c2faebed84624cdf5a4ed732966974f79ee97d025ba52e58f6f9dc6e91162762"

  url "https://github.com/yask123/mono/releases/download/v#{version}/Mono.dmg"
  name "Mono"
  desc "Quiet, terminal-style reading view for X in Safari"
  homepage "https://yask.dev/mono"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sonoma

  app "Mono.app"

  uninstall quit: "com.yask.mono"

  zap trash: [
    "~/Library/Containers/com.yask.mono",
    "~/Library/Containers/com.yask.mono.Extension",
  ]

  caveats <<~EOS
    Safari asks you to switch the extension on yourself, once:
      1. Open Mono, then Safari > Settings > Extensions and tick Mono.
      2. On x.com, click the Mono toolbar button and choose
         "Always Allow on This Website".
  EOS
end
