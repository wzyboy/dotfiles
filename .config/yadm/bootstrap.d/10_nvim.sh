#!/bin/sh

curl --create-dirs -Lo ~/.local/share/nvim/site/autoload/plug.vim \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

nvim '+PlugInstall' '+qall'
