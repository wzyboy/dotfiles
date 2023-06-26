#!/bin/bash -

plug_path=~/.local/share/nvim/site/autoload/plug.vim

[[ -f $plug_path ]] && exit 0

curl --create-dirs -Lo $plug_path \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

nvim '+PlugInstall' '+qa!'
