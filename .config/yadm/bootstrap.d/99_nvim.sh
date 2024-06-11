#!/bin/bash -

if [[ "$MSYSTEM" == "MINGW64" ]]; then
  plug_path=~/AppData/Local/nvim-data/site/autoload/plug.vim
else
  plug_path=~/.local/share/nvim/site/autoload/plug.vim
fi

[[ -f $plug_path ]] && exit 0

curl --create-dirs -Lo $plug_path \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

if [[ "$MSYSTEM" == "MINGW64" ]]; then
    cmd //c mklink //J $(cygpath -w ~/AppData/Local/nvim) $(cygpath -w ~/.config/nvim)
fi

nvim '+PlugInstall' '+qa!'
