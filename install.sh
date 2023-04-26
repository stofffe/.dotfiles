#!/bin/bash

mkdir -p ~/.config

export XDG_CONFIG_HOME=$HOME/.config/

# Call all install scripts in config folders
for d in *; do
    install="${d}/install.sh"
	if [ -e $install ]; then
        ./$install
    fi
done

# Platform specific installation
if [[ $OSTYPE == "darwin"* ]]; then
    echo "Mac specific installation"
fi

if [[ $OSTYPE == "linux-gnu"* ]]; then
    echo "Linux specific installation"
fi
