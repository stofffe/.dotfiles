#!/bin/bash

echo "--lf--"

mkdir -p ~/.config/lf

rm -rf ~/.config/lf
ln -s ~/.dotfiles/lf ~/.config/lf

echo "--done--"
