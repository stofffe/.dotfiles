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

# grpc dart
# export PATH=$PATH:$HOME/.pub-cache/bin

