#!/bin/bash

echo "--zsh--"

rm ~/.zshrc
ln -s ~/.dotfiles/zsh/.zshrc ~/.zshrc

rm -rf powerlevel10k
git clone git@github.com:romkatv/powerlevel10k.git powerlevel10k

rm -rf plugins/zsh-autosuggestions
git clone git@github.com:zsh-users/zsh-autosuggestions.git plugins/zsh-autosuggestions

rm -rf plugins/zsh-syntax.highlighting
git clone git@github.com:zsh-users/zsh-syntax-highlighting.git plugins/zsh-syntax-highlighting

echo "--done--"
