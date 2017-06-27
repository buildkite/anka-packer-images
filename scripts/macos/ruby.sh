#!/bin/bash
set -euo pipefail

export RBENV_ROOT="$HOME/.rbenv"
export RBENV_PLUGINS="$RBENV_ROOT/plugins"

git clone https://github.com/sstephenson/rbenv.git "$RBENV_ROOT"

echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
source ~/.bash_profile

cat << EOF > "$RBENV_ROOT/default-gems"
bundler
rake
EOF

mkdir -p "$RBENV_PLUGINS"
git clone https://github.com/sstephenson/ruby-build.git         "$RBENV_PLUGINS/ruby-build"
git clone https://github.com/sstephenson/rbenv-default-gems.git "$RBENV_PLUGINS/rbenv-default-gems"
git clone https://github.com/tpope/rbenv-communal-gems.git      "$RBENV_PLUGINS/rbenv-communal-gems"

export HOMEBREW_NO_AUTO_UPDATE=1
brew install openssl libyaml libffi

rbenv install 2.3.1
rbenv global 2.3.1
rbenv communize --all
rbenv versions
rbenv rehash
gem env