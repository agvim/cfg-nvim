#!/bin/sh
homeshick=$HOME/.homesick/repos/homeshick/bin/homeshick

# install the configured vim bundles
mkdir -p ~/.local/share/nvim/site/pack/packer/start
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
$homeshick link cfg-nvim
nvim "+PackerSync" '+qa!'
