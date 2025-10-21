#!/bin/bash -

# Hide non-dotfiles in the repo root
# https://github.com/TheLocehiliosan/yadm/issues/93#issuecomment-886667802
yadm gitconfig core.sparseCheckout true
yadm sparse-checkout set '/*' '!README.md'

# Because Git submodule commands cannot operate without a work tree, they must
# be run from within $HOME (assuming this is the root of your dotfiles)
cd "$HOME"

# curl needs this
touch ~/.netrc

yadm submodule update --init
