#!/bin/bash

echo "--tmux--"

rm ~/.tmux.config
ln -s ~/.dotfiles/tmux/.tmux.config ~/.tmux.config

echo "--done--"
