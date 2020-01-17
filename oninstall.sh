#!/bin/sh
# homeshick config cfg-vim should be installed
homeshick=$HOME/.homesick/repos/homeshick/bin/homeshick
if [ ! -d $HOME/.homesick/repos/cfg-vim ]
then
    $homeshick clone https://github.com/agvim/cfg-vim
fi

# neovim compatibility from vim
mkdir -p ~/.local/share/nvim/site/autoload/
ln -s ~/.vim/autoload/plug.vim ~/.local/share/nvim/site/autoload/plug.vim
mkdir -p ~/.config/nvim/
ln -s ~/.vimrc ~/.config/nvim/init.vim
CFG_NVIM_DIR="$(dirname "$BASH_SOURCE")"
# TODO XXX FIXME:the icon did not work with xseticon inside the castle
cp "$CFG_NVIM_DIR/neovim-icon.png" "$HOME/Pictures/"
cp "$CFG_NVIM_DIR/neovim-icon.png" "$HOME/.local/share/icons/neovim.png"
# link the gnvim wrapper to bin
ln -s "$CFG_NVIM_DIR/gnvim.sh" "$HOME/bin/gnvim"
