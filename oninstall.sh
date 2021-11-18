#!/bin/sh
homeshick=$HOME/.homesick/repos/homeshick/bin/homeshick

# install the configured vim bundles
wget -O ~/.local/share/nvim/site/autoload/plug.vim -- https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
$homeshick link cfg-nvim
nvim "+PlugInstall" '+qa!'
