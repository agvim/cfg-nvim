#!/bin/sh
mkdir -p $1/.local/share/nvim/site/autoload/
cp -P ~/.local/share/nvim/site/autoload/plug.vim "$1/.local/share/nvim/site/autoload/"
CFG_NVIM_DIR="$(dirname "$(readlink -f $0)")"
