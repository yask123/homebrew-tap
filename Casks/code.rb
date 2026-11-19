cask "code" do
  version "1.1.0"
  sha256 "9d7f62442059c0a39e2c41d80259008053d1dd2e30abfd6be2e6b2747edcef6d"

  url "https://github.com/yask123/nvim-macos/archive/refs/tags/v#{version}.tar.gz"
  name "Code"
  desc "Quiet code editor built on Neovim"
  homepage "https://yask.dev/code"

  livecheck do
    url :url
    strategy :github_latest
  end

  # Code keeps itself up to date with `nvim-update`; a cask upgrade would
  # reinstall from scratch, so Homebrew leaves it alone unless asked.
  auto_updates true
  depends_on cask: %w[
    font-monaspice-nerd-font
    neovide-app
  ]
  depends_on formula: %w[
    fd
    fzf
    git
    lazygit
    lua
    neovim
    node
    python
    ripgrep
    tree-sitter-cli
  ]
  depends_on macos: :ventura

  # Installs the editor to ~/.config/nvim, restores the pinned plugins and
  # builds ~/Applications/Code.app. An earlier install (Code, or Dojo as the
  # app was first called) is upgraded in place; any other Neovim setup is
  # moved to a backup first.
  installer script: {
    executable: "nvim-macos-#{version}/install.sh",
    args:       ["--skip-brew", "--ref", "v#{version}"],
  }

  # Moves the Neovim config, plugins and state to a recoverable backup under
  # ~/.local/state/nvim-bootstrap/uninstalled/ and removes Code.app.
  uninstall script: {
    executable: "nvim-macos-#{version}/scripts/uninstall.sh",
  }

  caveats <<~EOS
    Open Code from Spotlight.
    An earlier install was upgraded in place (sessions and settings kept).
    Any other Neovim setup was moved to ~/.local/state/nvim-bootstrap/backups/.
    Update later with: nvim-update
  EOS
end
