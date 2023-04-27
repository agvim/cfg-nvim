#!/bin/bash
# we need the init.vim files to be linked in order to avoid installing
# unnecessary stuff and installing custom stuff

# if the homeshick repo has an update, re-link cfg-nvim files before updating
# nvim
if [[ $1 == 1 ]]; then
	homeshick=$HOME/.homesick/repos/homeshick/bin/homeshick
	$homeshick link cfg-nvim
fi

nvim --headless "+Lazy! sync" +qa
