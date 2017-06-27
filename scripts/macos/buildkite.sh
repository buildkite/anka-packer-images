#!/bin/bash
set -eux

PROVISION_DIR="$HOME"
export HOMEBREW_NO_AUTO_UPDATE=1
export PATH=/usr/local/bin:$PATH

install_buildkite() {
  echo "Installing buildkite-agent"
  brew tap buildkite/buildkite
  brew install --devel buildkite-agent
  cp /tmp/buildkite-hooks/* /usr/local/etc/buildkite-agent/hooks/
  rm -rf /tmp/buildkite-hooks
}

install_launchd_daemon() {
  local script="vmkite-buildkite-agent.sh"
  local plist="com.macstadium.vmkite-buildkite-agent.plist"
  echo "Installing launchd service"
  sudo cp "${PROVISION_DIR}/$script" "/usr/local/bin/$script"
  sudo cp "${PROVISION_DIR}/$plist" "/Library/LaunchDaemons/$plist"
  sudo chmod 0755 "/usr/local/bin/$script"
  sudo launchctl load "/Library/LaunchDaemons/$plist"
}

install_utils() {
  brew install awscli jq git-lfs
  git lfs install
}

install_utils
install_buildkite
install_launchd_daemon

# Write a version file so we can track which build this refers to
sudo tee /etc/vmkite-info << EOF
BUILDKITE_VERSION=$(buildkite-agent --version)
BUILDKITE_BUILD_NUMBER=$BUILDKITE_BUILD_NUMBER
BUILDKITE_BRANCH=$BUILDKITE_BRANCH
BUILDKITE_COMMIT=$BUILDKITE_COMMIT
EOF
