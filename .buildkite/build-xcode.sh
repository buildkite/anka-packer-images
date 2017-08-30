#!/bin/bash
set -euo pipefail

function upload_install_log() {
  buildkite-agent artifact upload /var/log/install.log
}

xcode_version="$1"
source_vm=$(buildkite-agent meta-data get vm_name)
vm_name="${source_vm/-base/}-xcode-${xcode_version}"

echo "--- Building ${vm_name}"
make macos-xcode-10.12 "packer_log=${PACKER_LOG:-}" "vm_name=${vm_name}" "source_vm=${source_vm}"
