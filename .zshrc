# vim: set shiftwidth=2
# vim: set tabstop=2
# vim: set expandtab

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="gitster"

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
ENABLE_CORRECTION="true"

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
plugins=(git tmux docker ng zsh-syntax-highlighting colored-man-pages)

# Search for custom zsh completions stored in the home directory.
if [ -d ~/.zsh ]; then
  fpath=(~/.zsh/*.completions $fpath)
fi

#
# User configuration and environment variables.
#

# Non-default gopath under src.
export GOPATH="$HOME/src/go"

# The prettiest path of them all.
export PATH="$HOME/.local/bin:$HOME/.pyenv/bin:$HOME/.yarn/bin:$HOME/src/go/bin:$HOME/.cargo/bin:$PATH"

# Load oh-my-zsh config.
source $ZSH/oh-my-zsh.sh

# Run autoload for loading completions only after sourcing oh-my-zsh so it
# doesn't squash our prefs.
autoload -Uz compinit && compinit

# Shell and program aliases.
alias la="ls -a"
alias ll="ls -alh"
alias vi="vim"
alias nn=pnpm
alias tmux="tmux -u"

# Custom keybinds.

# Control + backspace
bindkey '^H' backward-kill-word

# Control + arrows
bindkey ";5C" forward-word
bindkey ";5D" backward-word

# Utility commands.

rebuild_gems() {
  gem pristine 2> >(grep -o "gem pristine.*") | zsh
}

# Use neovim as the default editor if availabe, if not default back to vim as
# it's usually available on most systems.
if type "nvim" > /dev/null; then
  alias vim="nvim"
  export EDITOR="nvim"
else
  export EDITOR="vim"
fi

# Adds 'clog' alias which can be used for writing daily logs concerning
# day-to-day activities.
#export LOG_DIR=$HOME/Log
#mkdir -p $LOG_DIR
#alias clog="$EDITOR $LOG_DIR/$(date "+%Y-%m-%d").md"

# Allow tmux to use full 256 colors. Will only be exported if there is an
# actual tmux session, otherwise the terminal emulator picks the term.
if ! [ -z "$TMUX" ]; then
  export TERM=screen-256color
fi

# Assume GNU Screen supports 256 colors.
if [ "$TERM" = "screen" ]; then
  export TERM=screen-256color
fi

# Prepend the ruby gems path if ruby and rubygems is installed. Gem error
# output is silenced as it will complain about /mnt/c being writable when
# used in WSL. Windows permissions are still enforced on this 9P mount and
# this actually isn't an issue.
if which ruby > /dev/null 2>&1 && which gem >/dev/null 2>&1; then
  alias gem='gem 2>/dev/null'
  PATH="$(gem environment | grep 'EXECUTABLE DIRECTORY' | cut -d: -f2 | sed 's/^\s//g'):$PATH"
  unalias gem
  PATH="$(ruby -e 'puts Gem.user_dir')/bin:$PATH"
fi

# Use iTerm2 shell integration on Darwin if available and only if not logged in
# over ssh to prevent prompt corruption.
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  # Logged in over ssh.
else
  test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh
fi

export NVM_DIR="$HOME/.nvm"
export NVM_SYMLINK_CURRENT=true
export PATH="$HOME/.nvm/current/bin:$PATH"

# Lazy load nvm only when invoked to prevent long startup times. Since
# NVM_SYMLINK_CURRENT is present the "current" symlink can be used until nvm is
# invoked and replaces it with the explicit path.
nvm() {
  if [ -s "$NVM_DIR/nvm.sh" ]; then
    source "$NVM_DIR/nvm.sh"
    if [ -s "$NVM_DIR/bash_completion" ]; then
      source "$NVM_DIR/bash_completion"
    fi

    nvm "$@"
  else
    echo "nvm is not installed"
  fi
}

# Aliases for node cli packages that I use on a regular basis. I don't like
# using global packages when I can help it and prefer to run local versions
# through npx.

ng() {
  npx ng "$@"
}

nx() {
  npx nx "$@"
}

# Load env variables from .env files into the current shell environment.
senv() {
  export $(cat .env | xargs)
}

# Useful function that tells me how far ahead of main that I am so I don't have
# to count when doing certain edits to the history.
gbase() {
  if git rev-parse --git-dir > /dev/null 2>&1; then
    echo "HEAD is $(git rev-list --count HEAD ^main) commit(s) ahead of main\n"
    git log -n1 $(git merge-base HEAD main)
  else
    echo "Not in a git repository"
  fi
}

# Add pyenv to the path so multiple python versions can be accessed.
export PATH="$HOME/.pyenv/shims:$PATH"

if which pyenv >/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# Load out-of-tree zsh scripts that I don't want to expose to the internet.
if [ -d $HOME/.private-zshrc.d ]; then
  for file in $HOME/.private-zshrc.d/*.zsh; do
    source $file
  done
fi

true
