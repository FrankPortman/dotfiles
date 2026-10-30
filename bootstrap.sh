#!/bin/sh
# New Mac, from zero:
#   curl -fsSL https://raw.githubusercontent.com/FrankPortman/dotfiles/master/bootstrap.sh | sh
# Safe to rerun; later runs just switch to the current config.
set -eu

repo=https://github.com/FrankPortman/dotfiles.git
dir="$HOME/dotfiles"
me=$(id -un)

# git comes with the Command Line Tools.
if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install
  echo "Finish installing the Command Line Tools, then rerun this script."
  exit 1
fi

if [ ! -x /nix/var/nix/profiles/default/bin/nix ]; then
  curl -fsSL https://install.determinate.systems/nix | sh -s -- install --no-confirm
fi
nix=/nix/var/nix/profiles/default/bin/nix

[ -d "$dir" ] || git clone "$repo" "$dir"

flake_user=$(sed -n 's/^ *user = "\(.*\)";/\1/p' "$dir/flake.nix")
if [ "$flake_user" != "$me" ]; then
  echo "flake.nix has user = \"$flake_user\" but you are \"$me\"."
  echo "Set user and home in $dir/flake.nix, then rerun."
  exit 1
fi

if [ -x /run/current-system/sw/bin/darwin-rebuild ]; then
  sudo /run/current-system/sw/bin/darwin-rebuild switch --flake "$dir#laptop"
else
  sudo "$nix" run github:nix-darwin/nix-darwin/nix-darwin-26.05#darwin-rebuild -- \
    switch --flake "$dir#laptop"
fi

"/etc/profiles/per-user/$me/bin/mise" install

# Claude Code via its native installer (into ~/.local/bin), so it can update itself.
[ -x "$HOME/.local/bin/claude" ] || curl -fsSL https://claude.ai/install.sh | bash

echo
echo "Done. Next:"
if [ "$(dscl . -read "/Users/$me" UserShell | awk '{print $2}')" != /bin/zsh ]; then
  echo "  chsh -s /bin/zsh"
fi
echo "  Install iTerm2 (https://iterm2.com), or quit and reopen it if it's running"
echo "  gh auth login"
