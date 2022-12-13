# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Enable colors
export CLICOLOR=1
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zstyle ':completion:*:default' list-colors "di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43" # Mine
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# LF
export EDITOR="nvim"
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '›' 'lfcd\n' # option + b

# own binaries
export PATH=$PATH:$HOME/mybin

# Go
export GO111MODULE=on 
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export GOBIN=$GOPATH/bin

# grpc dart
export PATH=$PATH:$HOME/.pub-cache/bin

# Aliases
alias repo='f() { open https://github.com/$1 };f'
alias nv=nvim
alias ll="ls -lah"
alias cl=clear
# alias example='f() { echo Your arg was $1. };f'

# TMUX aliases
alias tmn='f() { tmux new -s $1 };f'
alias tma='f() { tmux attach -t $1 };f'
alias tms='tmux source-file ~/.tmux.config'
alias tmls='tmux ls'
alias tmk='f() { tmux kill-session -t $1 };f'

# fzf
export FZF_DEFAULT_COMMAND='fd --type f --hidden'
alias ff='cd $(fd --type directory --hidden --search-path=$HOME/dev --search-path=$HOME/.dotfiles --search-path=$HOME/kth | fzf)'

# Source
source ~/.dotfiles/zsh/powerlevel10k/powerlevel10k.zsh-theme
source ~/.dotfiles/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.dotfiles/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# ### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
# export PATH="/Users/christofferandersson/.rd/bin:$PATH"
# ### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
# test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

