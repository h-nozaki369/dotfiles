#!/usr/bin/sh
ln -sf ~/dotfiles/vimrc ~/.vimrc
if [ ! -d ~/.config ]; then
    mkdir ~/.config
fi
if [ ! -d ~/.config/nvim ]; then
    mkdir ~/.config/nvim
fi
ln -sf ~/dotfiles/vimrc ~/.config/nvim/init.vim
ln -sf ~/dotfiles/coc-settings.json ~/.config/nvim/coc-settings.json
