#!/bin/bash
set -euo pipefail

export HOMEBREW_NO_AUTO_UPDATE=1
brew install rbenv ruby-build

# Install Ruby
eval "$(rbenv init -)"
rbenv install 2.4.0
rbenv global 2.4.0
rbenv versions
rbenv rehash
gem env
