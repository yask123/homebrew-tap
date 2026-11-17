class MonoChrome < Formula
  desc "Quiet, terminal-style reading view for X in Chrome, Arc, Brave and Edge"
  homepage "https://yask.dev/mono"
  url "https://github.com/yask123/mono/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "3c73ed1f9a61d55f5a38b6c074b65661a57222f421d153bacefccc15b1762ba4"
  license "MIT"

  def install
    pkgshare.install "extension"

    (bin/"mono-chrome").write <<~SH
      #!/bin/sh
      # Opens a browser's extensions page with Mono's folder path on the clipboard.
      dir="#{var}/mono/chrome"
      case "${1:-chrome}" in
        --path) echo "$dir"; exit 0 ;;
        chrome) app="Google Chrome"; page="chrome://extensions" ;;
        arc) app="Arc"; page="chrome://extensions" ;;
        brave) app="Brave Browser"; page="brave://extensions" ;;
        edge) app="Microsoft Edge"; page="edge://extensions" ;;
        *) echo "usage: mono-chrome [chrome|arc|brave|edge|--path]" >&2; exit 64 ;;
      esac
      if [ ! -f "$dir/manifest.json" ]; then
        echo "Mono's files are missing from $dir; run: brew postinstall mono-chrome" >&2
        exit 1
      fi
      printf %s "$dir" | /usr/bin/pbcopy
      /usr/bin/open -a "$app" "$page" || exit 1
      echo "Opened $page in $app. The folder path is on your clipboard:"
      echo "  $dir"
      echo
      echo "  1. Turn on Developer mode (top right)."
      echo "  2. Click Load unpacked, press Cmd-Shift-G, paste, press Return, then Open."
    SH
  end

  # The browser keeps the real path of an unpacked extension, and Cellar paths change
  # with every version, so the files live in a folder that outlives upgrades.
  post_install_steps do
    mkdir_p "mono", base: :var
    remove "mono/chrome", base: :var, recursive: true
    copy "extension", "mono/chrome", source_base: :pkgshare, target_base: :var, recursive: true
  end

  def caveats
    <<~EOS
      Chrome asks you to add the extension yourself, once. Run:
        mono-chrome
      It opens chrome://extensions with the folder path on your clipboard.
      For Arc, Brave or Edge: mono-chrome arc|brave|edge

      After `brew upgrade mono-chrome`, click the reload arrow on Mono in
      the extensions page.
    EOS
  end

  test do
    assert_path_exists pkgshare/"extension/manifest.json"
    assert_match "mono/chrome", shell_output("#{bin}/mono-chrome --path")
  end
end
