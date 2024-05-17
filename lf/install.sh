#!/bin/bash

echo "--lf begin--"

mkdir -p ~/.config/lf

rm -rf ~/.config/lf
ln -s ~/.dotfiles/lf ~/.config/lf

echo "--lf done--"
