#!/bin/bash
set -euo pipefail

function upload_install_log() {
    buildkite-agent artifact upload /var/log/install.log
}

image="$1"

if [[ $image == "macos-10.12" ]] ; then
  echo "" > /var/log/install.log
  trap upload_install_log ERR
fi

echo "--- Building $image"
make "$image"
