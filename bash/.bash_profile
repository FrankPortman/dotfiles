export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"
source $HOME/.profile

brew analytics off 2>&1 >/dev/null
# ------------------------------------------------------------------------------
# Define the local path
# ------------------------------------------------------------------------------
export PATH="$HOME/bin:/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:$PATH"
# ------------------------------------------------------------------------------
if [ -f /usr/local/etc/bash_completion ]; then
  . /usr/local/etc/bash_completion
fi
# ------------------------------------------------------------------------------
export JAVA_HOME="$(find /Library/Java/JavaVirtualMachines/ -name 'Home' | head -n 1)"
export rvmsudo_secure_path=1
export EDITOR='emacs'
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export HISTTIMEFORMAT="%d/%m/%y %T "
export COMP_KNOWN_HOSTS_WITH_HOSTFILE=""
export HOMEBREW_GITHUB_API_TOKEN="GITHUB_TOKEN"
export FABRIC_OUTPUT_CONFIG=kitchen-sink
# ------------------------------------------------------------------------------
shopt -s histappend
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
function parse_git_branch () {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
# ------------------------------------------------------------------------------
NO_COLOUR="\[\033[0m\]"
RED="\[\033[00;31m\]"
GREEN="\[\033[00;32m\]"
YELLOW="\[\033[00;33m\]"
BLUE="\[\033[00;34m\]"
MAGENTA="\[\033[00;35m\]"
PURPLE="\[\033[00;35m\]"
CYAN="\[\033[00;36m\]"
LIGHTGRAY="\[\033[00;37m\]"
LRED="\[\033[01;31m\]"
LGREEN="\[\033[01;32m\]"
LYELLOW="\[\033[01;33m\]"
LBLUE="\[\033[01;34m\]"
LMAGENTA="\[\033[01;35m\]"
LPURPLE="\[\033[01;35m\]"
LCYAN="\[\033[01;36m\]"
WHITE="\[\033[01;37m\]"
# ------------------------------------------------------------------------------
export LANG=en_US.UTF-8
# ------------------------------------------------------------------------------
complete -C aws_completer aws
# ------------------------------------------------------------------------------
PS1="$LRED\t $LYELLOW$(scutil --get ComputerName)$NO_COLOUR/$GREEN\u $WHITE@\W$NO_COLOUR $YELLOW\$(parse_git_branch)$NO_COLOUR \\$ "
# ------------------------------------------------------------------------------
export PATH="/usr/local/opt/llvm/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="~/.local/bin:$PATH"
export PATH="~/go/bin:$PATH"
[ -s "/Users/frank/.scm_breeze/scm_breeze.sh" ] && source "/Users/frank/.scm_breeze/scm_breeze.sh"
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
brew analytics off 2>&1 >/dev/null
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

export JAVA_HOME="/opt/homebrew/opt/openjdk@17"

# Added by OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.bash 2>/dev/null || :

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/frank/Downloads/google-cloud-sdk/path.bash.inc' ]; then . '/Users/frank/Downloads/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/frank/Downloads/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/frank/Downloads/google-cloud-sdk/completion.bash.inc'; fi

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/frank/.lmstudio/bin"

# Python Env
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"

. "$HOME/.local/bin/env"
