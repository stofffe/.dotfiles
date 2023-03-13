#!/bin/bash

echo "--nvim--"

rm ~/.config/nvim
ln -s ~/.dotfiles/nvim ~/.config/nvim

git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

echo "--done--"
