#!/bin/bash

echo "--main begin--"

mkdir -p ~/.config

export XDG_CONFIG_HOME=$HOME/.config/

# Call all install scripts in config folders
for d in *; do
    install="${d}/install.sh"
	if [ -e $install ]; then
        ./$install
    fi
done

echo "--main done--"
