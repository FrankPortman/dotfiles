# dotfiles

macOS setup as a Nix flake: nix-darwin for the system, home-manager for `~`.

- `flake.nix` pins nixpkgs, nix-darwin and home-manager (all 26.05) and defines `#laptop`.
- `nix/darwin.nix` covers system settings; `nix/home.nix` covers packages, shell, git, mise and direnv.
- `bash/`, `zsh/`, `git/`, `fish/` are the plain pre-Nix files, kept for reference.

## New Mac

1. Install Determinate Nix:
   ```bash
   curl -fsSL https://install.determinate.systems/nix | sh -s -- install
   ```
2. Clone this repo to `~/dotfiles`. If the account name or home folder differ, edit `user` / `home` in `flake.nix`.
3. First switch (`darwin-rebuild` doesn't exist yet):
   ```bash
   sudo nix run nix-darwin/nix-darwin-26.05#darwin-rebuild -- switch --flake ~/dotfiles#laptop
   ```
   If it refuses because `/etc/bashrc` or `/etc/zshrc` has unrecognized content, rename that file with a `.before-nix-darwin` suffix and rerun.
4. Move the login shell off macOS's bash 3.2:
   ```bash
   chsh -s /run/current-system/sw/bin/bash
   ```
5. Open a new terminal and run `mise install` to fetch the global node and python.

Existing `~/.bashrc`, `~/.profile`, etc. are renamed to `*.before-nix` on the first switch.

## Day to day

- Apply changes: `sudo darwin-rebuild switch --flake ~/dotfiles#laptop`
- Update pinned inputs: `nix flake update` in this repo, then switch.
- Undo the last switch: `sudo darwin-rebuild switch --rollback`
- Flakes only see git-tracked files: `git add` new files before switching.
- Per-repo dev shell: put `use flake` in the repo's `.envrc`, then `direnv allow`.

GUI apps (OrbStack, Sublime Text, ...) are installed by hand.
