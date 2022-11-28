#!/bin/sh
mkdir -p $1/.local/share/nvim/site/autoload/
cp -Pr ~/.local/share/nvim/site/pack/packer/start/packer.nvim "$1/.local/share/nvim/site/pack/packer/start"
CFG_NVIM_DIR="$(dirname "$(readlink -f $0)")"
