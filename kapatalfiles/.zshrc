export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"
plugins=(git docker kubectl)

source $ZSH/oh-my-zsh.sh

# Aliases
alias ll='ls -lah'
alias gs='git status'

# Custom PATH
export PATH="$HOME/bin:$PATH"
