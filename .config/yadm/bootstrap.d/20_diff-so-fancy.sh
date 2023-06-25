#!/bin/bash -

mkdir -p ~/.local/bin
pushd ~/.local/bin
ln -svf ../diff-so-fancy/diff-so-fancy .
popd
