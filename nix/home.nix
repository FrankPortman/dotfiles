{
  lib,
  pkgs,
  user,
  home,
  ...
}:
let
  name = "Frank Portman";
  email = "frank1214@gmail.com";
  itermProfile = "DF2DFBFC-FDA2-4B25-83DA-447A49384DF4";
in
{
  home.username = user;
  home.homeDirectory = home;
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    ripgrep
    fd
    sd
    jq
    yq-go
    just
    watchexec
    hyperfine
    tokei
    dust
    duf
    uv
    nerd-fonts.jetbrains-mono # icon glyphs; the iTerm2 profile falls back to it
  ];

  home.sessionPath = [ "$HOME/.local/bin" ]; # uv tool install

  home.sessionVariables = {
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    MANROFFOPT = "-c";
    # Same ls colors as the old .bash_profile (`ls` stays /bin/ls).
    CLICOLOR = "1";
    LSCOLORS = "GxFxCxDxBxegedabagaced";
  };

  # Shell: zsh + starship prompt, atuin history (ctrl-r), zoxide (`z`), fzf (ctrl-t, alt-c).
  programs.zsh = {
    enable = true;
    autocd = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history = {
      size = 100000;
      save = 100000;
      share = true;
      ignoreAllDups = true;
    };
  };

  # The old bash PS1, same colors: `12:34:56 yikes/fp @dotfiles  (main) $ `
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$time $hostname/$username $directory $git_branch \\$ ";
      time = {
        disabled = false;
        time_format = "%T";
        format = "[$time]($style)";
        style = "bold red";
      };
      hostname = {
        ssh_only = false;
        format = "[$hostname]($style)";
        style = "bold yellow";
      };
      username = {
        show_always = true;
        format = "[$user]($style)";
        style_user = "green";
      };
      directory = {
        truncation_length = 1;
        truncate_to_repo = false;
        read_only = "";
        format = "[@$path]($style)";
        style = "bold white";
      };
      git_branch = {
        format = " [\\($branch\\)]($style)";
        style = "yellow";
      };
    };
  };

  programs.atuin = {
    enable = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      update_check = false;
      style = "compact";
    };
  };

  programs.zoxide.enable = true;
  programs.fzf.enable = true;
  programs.bat.enable = true;
  programs.btop.enable = true;
  programs.tealdeer.enable = true;

  programs.eza = {
    enable = true;
    enableZshIntegration = false; # no ls -> eza aliases
    git = true;
    icons = "auto";
  };

  # `, cowsay hi` runs any nixpkgs binary without installing it.
  programs.nix-index-database.comma.enable = true;

  # `use flake` in a repo's .envrc gives it a pinned dev shell.
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config.global.hide_env_diff = true;
  };

  # Language runtimes for repos that pin them (.nvmrc, .python-version, mise.toml).
  programs.mise = {
    enable = true;
    globalConfig = {
      tools = {
        node = "lts";
        python = "3.14";
      };
      settings.idiomatic_version_file_enable_tools = [
        "node"
        "python"
      ];
    };
  };

  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "tokyonight";
      editor = {
        line-number = "relative";
        cursor-shape.insert = "bar";
      };
    };
  };

  programs.git = {
    enable = true;
    ignores = [
      ".DS_Store"
      ".direnv"
    ];
    settings = {
      user = { inherit name email; };
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
      fetch.prune = true;
      rebase = {
        autoStash = true;
        autoSquash = true;
        updateRefs = true;
      };
      rerere.enabled = true;
      diff.algorithm = "histogram";
      merge.conflictStyle = "zdiff3";
      branch.sort = "-committerdate";
      commit.verbose = true;
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      line-numbers = true;
    };
  };

  programs.jujutsu = {
    enable = true;
    settings.user = { inherit name email; };
  };

  programs.gh.enable = true;
  programs.lazygit.enable = true;

  # iTerm2 itself is installed by hand. This adds your old Default profile (colors,
  # Monaco 12, all of it, from ../iterm2/profile.json) and makes it the default.
  home.file."Library/Application Support/iTerm2/DynamicProfiles/nix.json".text = builtins.toJSON {
    Profiles = [
      (
        lib.importJSON ../iterm2/profile.json
        // {
          Name = "Nix";
          Guid = itermProfile;
          "Use Separate Colors for Light and Dark Mode" = false; # use the colors above as-is
          "Use Non-ASCII Font" = true; # Nerd Font only for icon glyphs
          "Non Ascii Font" = "JetBrainsMonoNFM-Regular 12";
          "Option Key Sends" = 2; # left option acts as alt (Esc+): alt-c, alt-b/f
          "Unlimited Scrollback" = true;
        }
      )
    ];
  };
  targets.darwin.defaults."com.googlecode.iterm2"."Default Bookmark Guid" = itermProfile;
}
