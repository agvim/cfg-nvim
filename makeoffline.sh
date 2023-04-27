#!/bin/sh
mkdir -p $1/.local/share
cp -Pr ~/.local/share/nvim "$1/.local/share/nvim
CFG_NVIM_DIR="$(dirname "$(readlink -f $0)")"
