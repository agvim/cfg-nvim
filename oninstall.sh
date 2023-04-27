#!/bin/sh
homeshick=$HOME/.homesick/repos/homeshick/bin/homeshick

$homeshick link cfg-nvim
nvim --headless "+Lazy! sync" +qa
