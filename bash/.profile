# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

# Added by OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.bash 2>/dev/null || :

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/frank/.lmstudio/bin"

. "$HOME/.local/bin/env"
