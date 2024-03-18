# Hombrew
export PATH=$PATH:/opt/homebrew/bin/
export LIBRARY_PATH="$LIBRARY_PATH:$(brew --prefix)/lib"

# own binaries
export PATH=$PATH:$HOME/mybin
export PATH=$PATH:$HOME/.dotfiles/scripts

# Go
export GO111MODULE=on 
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export GOBIN=$GOPATH/bin

# Rust
export PATH=$PATH:$HOME/.cargo/bin

# -------------- 

# pnpm
export PNPM_HOME="/Users/christofferandersson/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

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

# grpc dart
# export PATH=$PATH:$HOME/.pub-cache/bin

