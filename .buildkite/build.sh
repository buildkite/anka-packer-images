#!/bin/bash
set -euo pipefail

function upload_install_log() {
    buildkite-agent artifact upload /var/log/install.log
}

image="$1"

if [[ $image == "macos-10.12" ]] ; then
  echo "--- Installing error trap for install.log"
  trap upload_install_log ERR

  echo "--- Calculating installer checksums"
  echo "Compare to https://github.com/notpeter/apple-installer-checksums"
  shasum /Applications/Install*OS*.app/Contents/SharedSupport/InstallESD.dmg
fi

echo "--- Building $image"
make "$image"
