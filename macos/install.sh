# Exit if not on mac
if [[ $OSTYPE != "darwin"* ]]; then
    exit 0
fi

echo "--mac begin--"

# Homebrew

curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh

brew install nvim
brew install tmux
brew install fd
brew install fzf
brew install ripgrep

echo "--mac done--"
