{ pkgs, user, home, ... }:
{
  home.username = user;
  home.homeDirectory = home;
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    gh
    ripgrep
    fd
    jq
    wget
    just
    ncdu
    coreutils-prefixed # GNU tools as gls, gdate, ... (like Homebrew's coreutils)
    bazelisk
    bazel-buildtools # buildifier, buildozer, unused_deps
    cmake
    go
    duckdb
    graphviz
    dive
    act
    awscli2
    emacs-nox
    uv
  ];

  home.sessionVariables = {
    EDITOR = "emacs";
    CLICOLOR = "1";
    LSCOLORS = "GxFxCxDxBxegedabagaced";
    LANG = "en_US.UTF-8";
  };

  home.sessionPath = [
    "$HOME/.local/bin" # uv tool install
    "$HOME/go/bin"
    "/Applications/Sublime Text.app/Contents/SharedSupport/bin"
  ];

  programs.git = {
    enable = true;
    settings = {
      user.name = "Frank Portman";
      user.email = "frank1214@gmail.com";
      push.autoSetupRemote = true;
    };
  };

  programs.java = {
    enable = true; # also sets JAVA_HOME
    package = pkgs.jdk17;
  };

  # Per-project runtimes; replaces nvm and pyenv. Globals match the old laptop's defaults.
  programs.mise = {
    enable = true;
    globalConfig = {
      tools = {
        node = "22";
        python = "3.12";
      };
      # Read coworkers' .nvmrc / .python-version files.
      settings.idiomatic_version_file_enable_tools = [ "node" "python" ];
    };
  };

  # `use flake` in a repo's .envrc gives it a pinned, per-repo dev shell.
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.zsh.enable = true;

  programs.bash = {
    enable = true;
    # Home Manager's defaults break macOS's bash 3.2 (the login shell until you chsh):
    # its option list includes globstar/checkjobs, and its completion block uses
    # [[ -v ]], a syntax error that stops the rest of .bashrc. The loader sourced in
    # initExtra skips itself on bash < 4.2.
    shellOptions = [ "histappend" ];
    enableCompletion = false;
    sessionVariables = {
      HISTTIMEFORMAT = "%d/%m/%y %T ";
      COMP_KNOWN_HOSTS_WITH_HOSTFILE = "";
    };
    profileExtra = ''
      # Homebrew as a fallback while migrating: appended, so Nix versions win.
      # Remove once nothing you need comes from brew.
      if [ -x /opt/homebrew/bin/brew ]; then
        export HOMEBREW_NO_ANALYTICS=1
        export PATH="$PATH:/opt/homebrew/bin:/opt/homebrew/sbin"
      fi

      source ~/.orbstack/shell/init.bash 2>/dev/null || :
    '';
    initExtra = ''
      . "${pkgs.bash-completion}/etc/profile.d/bash_completion.sh"

      function parse_git_branch () {
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
      }

      NO_COLOUR="\[\033[0m\]"
      GREEN="\[\033[00;32m\]"
      YELLOW="\[\033[00;33m\]"
      LRED="\[\033[01;31m\]"
      LYELLOW="\[\033[01;33m\]"
      WHITE="\[\033[01;37m\]"
      PS1="$LRED\t $LYELLOW$(scutil --get ComputerName)$NO_COLOUR/$GREEN\u $WHITE@\W$NO_COLOUR $YELLOW\$(parse_git_branch)$NO_COLOUR \\$ "

      complete -C aws_completer aws
    '';
  };
}
