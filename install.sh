#!/usr/bin/sh
if [ ! -d ~/.config/nvim ]; then
    mkdir -p ~/.config/nvim
fi
ln -sf ~/dotfiles/init.lua ~/.config/nvim/init.lua
