#!/bin/bash

mkdir -p ~/.config

for d in *; do
    install="${d}/install.sh"
	if [ -e $install ]; then
        ./$install
    fi
done
