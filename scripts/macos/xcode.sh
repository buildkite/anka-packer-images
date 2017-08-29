#!/bin/bash
set -euo pipefail

# sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist
eval "$(rbenv init -)"

curl -sL -O https://github.com/neonichu/ruby-domain_name/releases/download/v0.5.99999999/domain_name-0.5.99999999.gem
gem install domain_name-0.5.99999999.gem
gem install --conservative xcode-install
rm -f domain_name-0.5.99999999.gem
rbenv rehash

xcversion install --verbose "$XCODE_VERSION"
xcversion cleanup

export HOMEBREW_NO_AUTO_UPDATE=1
brew install carthage swiftlint cocoapods
