#!/bin/bash

echo "--tmux begin--"

mkdir -p ~/.config/tmux

rm -f ~/.tmux.config
rm -f ~/.config/tmux/tmux.config
ln -s ~/.dotfiles/tmux/.tmux.config ~/.config/tmux/tmux.config

echo "--vim done--"
