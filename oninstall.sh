#!/bin/sh
homeshick=$HOME/.homesick/repos/homeshick/bin/homeshick

# install the configured vim bundles
mkdir -p ~/.local/share/nvim/site/autoload/
wget -O ~/.local/share/nvim/site/autoload/plug.vim -- https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
$homeshick link cfg-nvim
nvim "+PlugInstall" '+qa!'
