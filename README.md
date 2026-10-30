# dotfiles

A Mac as a Nix flake: nix-darwin for the system, home-manager for `~`.

## New Mac

```bash
curl -fsSL https://raw.githubusercontent.com/FrankPortman/dotfiles/master/bootstrap.sh | sh
```

It installs the Command Line Tools and Determinate Nix, clones this repo to `~/dotfiles`, and switches to `#laptop`. If the account isn't `fp` with home `/Users/frank`, it stops and asks you to edit `user` / `home` in `flake.nix` first. GUI apps (iTerm2, OrbStack, editors) are installed by hand.

## What you get

| | |
|---|---|
| Shell | zsh, autosuggestions, syntax highlighting; starship drawing your old bash prompt; `ls` keeps your LSCOLORS |
| History / jumping | atuin on ctrl-r, zoxide `z`, fzf on ctrl-t / alt-c |
| CLI | ripgrep, fd, sd, bat (also the man pager), eza, jq, yq, just, watchexec, hyperfine, tokei, dust, duf, btop, tldr |
| Git | tuned defaults (rebase pulls, zdiff3, histogram diffs, rerere), delta, lazygit, gh, jj |
| Runtimes | mise (node LTS, python 3.14, and whatever a repo pins), uv |
| Nix | direnv + nix-direnv, `, <cmd>` runs any package without installing |
| Editor | Helix as `$EDITOR` |
| AI | Claude Code (native installer, self-updating) |
| Terminal | iTerm2 loads all its settings from `iterm2/` (your old profile and colors, Monaco 12), plus Nerd Font for icon glyphs and Option as Alt |
| macOS | fast key repeat, no autocorrect, Finder list view + hidden files, autohiding Dock, tap to click, Touch ID for sudo |

## Day to day

- Apply changes: `sudo darwin-rebuild switch --flake ~/dotfiles#laptop`
- Update everything: `nix flake update` in this repo, then switch.
- Undo the last switch: `sudo darwin-rebuild switch --rollback`
- New files must be `git add`ed before switching; flakes only see tracked files.
- New project with a dev shell: `nix flake init -t ~/dotfiles && direnv allow`
- Format the Nix files: `nix fmt`
- iTerm2 settings live in `iterm2/com.googlecode.iterm2.plist`. To keep a change made in iTerm2's Settings, save it there (Settings > General > Settings).

The old, pre-Nix dotfiles are at the `pre-cleanup` tag.
