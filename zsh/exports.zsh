# Hombrew
export PATH=$PATH:/opt/homebrew/bin/
export LIBRARY_PATH="$LIBRARY_PATH:$(brew --prefix)/lib"

# own binaries
export PATH=$PATH:$HOME/mybin
export PATH=$PATH:$HOME/.dotfiles/scripts
export PATH=$PATH:$HOME/bin-from-source/bins

# Go
export GO111MODULE=on 
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export GOBIN=$GOPATH/bin

# Rust
export PATH=$PATH:$HOME/.cargo/bin

# Odin
export PATH=$PATH:$HOME/Odin

# pnpm
export PNPM_HOME="/Users/christofferandersson/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# bat
export BAT_THEME="TwoDark"

# aseprite
export PATH="$PATH:$HOME/Library/Application Support/Steam/steamapps/common/Aseprite/Aseprite.app/Contents/MacOS"
