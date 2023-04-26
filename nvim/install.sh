#!/bin/bash

echo "--nvim--"

mkdir -p ~/.config/nvim

rm -rf ~/.config/nvim
ln -s ~/.dotfiles/nvim ~/.config/nvim

git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

echo "--done--"
