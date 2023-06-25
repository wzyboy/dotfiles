#!/bin/bash -

# https://github.com/TheLocehiliosan/yadm/issues/93#issuecomment-886667802

yadm gitconfig core.sparseCheckout true
yadm sparse-checkout set '/*' '!README.md'
