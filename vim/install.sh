#!/bin/bash

echo "--vim--"

mkdir -p ~/.config/vim

rm -f ~/.vimrc
rm -f ~/.config/vim/.vimrc
ln -s ~/.dotfiles/vim/.vimrc ~/.vimrc

echo "--done--"
