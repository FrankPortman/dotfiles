{ pkgs, user, home, ... }:
{
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Determinate Nix owns the Nix install and daemon, so nix-darwin must not manage it.
  nix.enable = false;

  system.primaryUser = user;
  users.users.${user}.home = home;

  # Writes /etc/bashrc and /etc/zshrc so login shells see Nix-installed packages.
  programs.bash.enable = true;
  programs.zsh.enable = true;

  # A current bash to replace macOS's 3.2 as the login shell. After the first switch:
  #   chsh -s /run/current-system/sw/bin/bash
  environment.shells = [ pkgs.bashInteractive ];
  environment.systemPackages = [ pkgs.bashInteractive ];

  system.stateVersion = 6;
}
