# sh syntax looks much better than vim's zsh syntax highlighting. Appears to
# work well enough for it to be used on zsh scipts.
# vim: set syntax=sh:

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="gentoo"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=$HOME/.zsh_custom

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-syntax-highlighting)

# User configuration
export GOPATH="$HOME/src/go:$HOME/bin/google-cloud-sdk/platform/google_appengine/goroot"
export PATH="/usr/lib64/qt-3.3/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:$HOME/.local/bin:$HOME/bin:$HOME/bin/google-cloud-sdk/bin:$HOME/Android/Sdk/tools:$HOME/Android/Sdk/platform-tools:$HOME/src/go/bin:$HOME/bin/arduino-1.6.5:$HOME/bin/arduino-1.6.5/hardware/tools/avr/bin:/usr/bin/core_perl"
export JAVA_HOME="/usr/java/latest"
export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_NDK_ROOT="$HOME/Android/Ndk"
export EDITOR="vim"

# Load oh-my-zsh config.
source $ZSH/oh-my-zsh.sh

# Shell aliases
alias la="ls -a"

if type "nvim" > /dev/null; then
  # Got neovim, alias it out. Too lazy to type "n".
  alias vim="nvim"
else
  # Get X11 support in vim if neovim is not present. If vimx is not avaliable
  # either screw X11 support.
  if type "vimx" > /dev/null; then
    alias vim="vimx"
  fi
fi

# Program aliases.
alias vi="vim"

# Do not open emacs in X.
alias emacs="emacs -nw"

# AWS aliases.
alias s3="aws s3"
alias sqs="aws sqs"
alias sns="aws sns"

if [[ $DESKTOP_SESSION == "i3" ]]; then
  # Startup the gnome keyring daemon when in i3.

  export $(/usr/bin/gnome-keyring-daemon -s)
fi

if ! [ -z "$TMUX" ]; then
  # Allow tmux to use full 256 colors. Will only be exported if there is an
  # actual tmux session, otherwise the terminal emulator picks the term.

  export TERM=screen-256color
fi

if [ "$TERM" = "screen" ]; then
  # Assume GNU Screen supports 256 colors. WHAT YEAR IS IT?

  export TERM=screen-256color
fi

[ -s "$HOME/.dnx/dnvm/dnvm.sh" ] && . "$HOME/.dnx/dnvm/dnvm.sh" # Load dnvm

# Fix zsh syntax highlighting colors. Well by fix make them the way I like it.
# Since I like Arch I turn all the occurences of "green" to "cyan".
ZSH_HIGHLIGHT_STYLES[default]=none
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold
ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=yellow
ZSH_HIGHLIGHT_STYLES[alias]=fg=cyan
ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=cyan
ZSH_HIGHLIGHT_STYLES[builtin]=fg=cyan
ZSH_HIGHLIGHT_STYLES[function]=fg=cyan
ZSH_HIGHLIGHT_STYLES[command]=fg=cyan
ZSH_HIGHLIGHT_STYLES[precommand]=fg=cyan
ZSH_HIGHLIGHT_STYLES[commandseparator]=none
ZSH_HIGHLIGHT_STYLES[hashed-command]=fg=cyan
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none
ZSH_HIGHLIGHT_STYLES[path_approx]=fg=yellow
ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue
ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=none
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=none
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=green
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=green
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=green
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=cyan
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=cyan
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=cyan
ZSH_HIGHLIGHT_STYLES[assign]=none
ZSH_HIGHLIGHT_STYLES[redirection]=none

GCLOUD_PATH="$HOME/bin/google-cloud-sdk/path.zsh.inc"
GCLOUD_COMP="$HOME/bin/google-cloud-sdk/completion.zsh.inc"

# The next line updates PATH for the Google Cloud SDK.
[ -s $GCLOUD_PATH ] && source $GCLOUD_COMP

# The next line enables shell command completion for gcloud.
[ -s $GCLOUD_COMP ] && source $GCLOUD_COMP

# Load AWS completions if they exist, path may be different on Mac OSX/Darwin.
[ -s "/usr/bin/aws_zsh_completer.sh" ] && source "/usr/bin/aws_zsh_completer.sh"
