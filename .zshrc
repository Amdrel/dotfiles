# Path to your oh-my-zsh installation.
export ZSH=/home/walter/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="muse"

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
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-syntax-highlighting)

# User configuration
export GOPATH="$HOME/src/go:$HOME/bin/google-cloud-sdk/platform/google_appengine/goroot"
export PATH="/usr/lib64/qt-3.3/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:$HOME/.local/bin:$HOME/bin:$HOME/bin/google-cloud-sdk/bin:$HOME/Android/Sdk/tools:$HOME/Android/Sdk/platform-tools:$HOME/src/go/bin:$HOME/bin/arduino-1.6.5:$HOME/bin/arduino-1.6.5/hardware/tools/avr/bin"
export JAVA_HOME="/usr/java/latest"
export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_NDK_ROOT="$HOME/Android/Ndk"
export EDITOR="vimx"
# export MANPATH="/usr/local/man:$MANPATH"

# Load oh-my-zsh config.
source $ZSH/oh-my-zsh.sh

# Shell aliases
alias la='ls -a'

# Get X11 support in vim please.
alias vim='vimx'

# Program aliases.
alias vi='vim'

# Do not open emacs in X.
alias emacs='emacs -nw'

if [[ $DESKTOP_SESSION == "i3" ]]; then
  # Startup the gnome keyring daemon.
  export $(/usr/bin/gnome-keyring-daemon -s)
fi

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='vimx'
fi

if ! [ -z "$TMUX" ]; then
  # Allow tmux to use full 256 colors. Will only be exported if there is an
  # actual tmux session, otherwise the terminal emulator picks the term.

  export TERM=screen-256color
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

[ -s "/home/walter/.dnx/dnvm/dnvm.sh" ] && . "/home/walter/.dnx/dnvm/dnvm.sh" # Load dnvm
