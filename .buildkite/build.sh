#!/bin/bash
set -euo pipefail

image="$1"

echo "--- Building $image"
if ! make "$image" ; then
  buildkite-agent artifact upload /var/log/install.log
  echo "Failed to build $image"
  exit 1
fi
