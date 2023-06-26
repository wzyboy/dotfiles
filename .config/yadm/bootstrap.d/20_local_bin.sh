#!/bin/bash -

mkdir -p ~/.local/bin
pushd ~/.local/bin

# diff-so-fancy
ln -svf ../diff-so-fancy/diff-so-fancy

# fzf
../fzf/install --bin
ln -svf ../fzf/bin/fzf

popd
