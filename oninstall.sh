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
ln -s ~/.config/vim/coc-settings.json ~/.config/nvim/coc-settings.json
