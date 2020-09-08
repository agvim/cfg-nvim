#!/bin/sh
mkdir -p $1/.local/share/nvim/site/autoload/
cp -P ~/.local/share/nvim/site/autoload/plug.vim "$1/.local/share/nvim/site/autoload/"
mkdir -p $1/.config/nvim/
cp -P ~/.config/nvim/init.vim "$1/.config/nvim/"
CFG_NVIM_DIR="$(dirname "$(readlink -f $0)")"
# TODO XXX FIXME:the icon did not work with xseticon inside the castle
mkdir -p $1/Pictures
cp "$CFG_NVIM_DIR/neovim-icon.png" "$1/Pictures/"
mkdir -p $1/.local/share/icons
cp "$CFG_NVIM_DIR/neovim-icon.png" "$1/.local/share/icons/neovim.png"
