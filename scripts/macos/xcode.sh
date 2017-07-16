#!/bin/bash
set -euo pipefail

if [ -z "${XCODE_VERSION:-}" ] ; then
  echo "Must set \$XCODE_VERSION"
  exit 1
fi

# sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist
eval "$(rbenv init -)"
gem install xcode-install
rbenv rehash

# ls -alR /Users/vmkite/Library/Caches
# sudo chown -R vmkite: /Users/vmkite/Library/Caches

set -x
xcversion install "$XCODE_VERSION"
xcversion cleanup

export HOMEBREW_NO_AUTO_UPDATE=1
brew install carthage swiftlint cocoapods
