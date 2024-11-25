#!/bin/bash -

mkdir -p ~/.local/bin
pushd ~/.local/bin

# binaries installed via git
ln -svf ../git-fire/git-fire

# fzf
../fzf/install --all

popd
