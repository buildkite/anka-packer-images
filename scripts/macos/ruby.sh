#!/bin/bash
set -euo pipefail

export HOMEBREW_NO_AUTO_UPDATE=1
brew install rbenv ruby-build rbenv-communal-gems

# Add rbenv to bash so that it loads every time you open a terminal
echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.profile
source ~/.profile

# Install Ruby
rbenv install 2.4.0
rbenv global 2.4.0
rbenv communize --all
rbenv versions
rbenv rehash
gem env
