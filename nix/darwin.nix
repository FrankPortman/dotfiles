{ user, home, ... }:
{
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Determinate Nix owns the Nix install and daemon, so nix-darwin must not manage it.
  nix.enable = false;

  system.primaryUser = user;
  users.users.${user}.home = home;

  # zsh is already macOS's login shell; this writes /etc/zshrc so it sees Nix packages.
  programs.zsh.enable = true;

  security.pam.services.sudo_local.touchIdAuth = true;

  system.defaults = {
    NSGlobalDomain = {
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
      ApplePressAndHoldEnabled = false; # key repeat instead of the accent popup
      AppleShowAllExtensions = true;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
    };
    finder = {
      AppleShowAllFiles = true;
      ShowPathbar = true;
      FXPreferredViewStyle = "Nlsv"; # list view
      _FXShowPosixPathInTitle = true;
    };
    dock = {
      autohide = true;
      show-recents = false;
      mru-spaces = false; # keep Spaces in a fixed order
    };
    trackpad.Clicking = true; # tap to click
  };

  system.stateVersion = 6;
}
