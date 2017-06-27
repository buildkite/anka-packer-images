#!/bin/bash
set -euo pipefail
source ~/.bash_profile

if [ -z "${XCODE_VERSION:-}" ] ; then
  echo "Must set \$XCODE_VERSION"
  exit 1
fi

gem install xcode-install cocoapods
rbenv rehash

ls -alR /Users/vmkite/Library/Caches
sudo chown -R vmkite: /Users/vmkite/Library/Caches

xcversion install "$XCODE_VERSION"
xcversion cleanup

export HOMEBREW_NO_AUTO_UPDATE=1
brew install carthage swiftlint