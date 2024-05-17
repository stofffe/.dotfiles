# :))
alias nv=nvim
alias ll="ls -lah"
alias cl=clear

# tmux
alias tmn='f() { tmux new -s $1 };f'
alias tma='f() { tmux attach -t $1 };f'
alias tms='tmux source-file ~/.config/tmux/tmux.config'
alias tmls='tmux ls'
alias tmk='f() { tmux kill-session -t $1 };f'
alias tmc='tmux save-buffer - | pbcopy'

# fzf
# export FZF_DEFAULT_COMMAND='fd --type f --hidden'
alias ff='cd $(fd --type directory --hidden     \
    --search-path=$HOME/dev                     \
    --search-path=$HOME/.dotfiles               \
    --search-path=$HOME/kth                     \
    --search-path=$HOME/creekside               \
    | fzf)'

# Dap
alias lldbserver="while sleep 1; do ~/.local/share/nvim/mason/bin/codelldb --port 13000; done"
