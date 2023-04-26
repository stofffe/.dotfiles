#!/bin/bash

echo "--zsh--"

rm ~/.zshenv
ln -s ~/.dotfiles/zsh/.zshenv ~/.zshenv

mkdir -p ~/.config/zsh

rm -f ~/.zshrc
rm -f ~/.config/zsh/.zshrc
ln -s ~/.dotfiles/zsh/.zshrc ~/.config/zsh/.zshrc

mkdir -p ~/.dotfiles/zsh/plugins

rm -rf ~/.dotfiles/zsh/powerlevel10k
git clone git@github.com:romkatv/powerlevel10k.git ~/.dotfiles/zsh/powerlevel10k

rm -rf ~/.dotfiles/zsh/plugins/zsh-autosuggestions
git clone git@github.com:zsh-users/zsh-autosuggestions.git ~/.dotfiles/zsh/plugins/zsh-autosuggestions

rm -rf ~/.dotfiles/zsh/plugins/zsh-syntax.highlighting
git clone git@github.com:zsh-users/zsh-syntax-highlighting.git ~/.dotfiles/zsh/plugins/zsh-syntax-highlighting

echo "--done--"
