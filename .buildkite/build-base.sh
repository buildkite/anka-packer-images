#!/bin/bash
set -euo pipefail

function upload_install_log() {
  buildkite-agent artifact upload /var/log/install.log
  buildkite-agent artifact upload SystemVersion.plist
}

echo "--- Checking system details"
anka_version=$(anka version)

echo "Anka version: ${anka_version}"

echo "--- Checking installer details"
./.buildkite/get-macos-version.sh > SystemVersion.plist

product_version=$(/usr/libexec/PlistBuddy -c "Print :ProductVersion" SystemVersion.plist)
product_build_version=$(/usr/libexec/PlistBuddy -c "Print :ProductBuildVersion" SystemVersion.plist)

echo "Product Version: ${product_version}"
echo "Product Version: ${product_build_version}"

echo "--- Checking for changed files"

files_hash=$(find ./*.json scripts/ -type f -print0 \
  | xargs -0 sha1sum \
  | awk '{print $1}' \
  | sort \
  | sha1sum \
  | awk '{print $1}')

cache_key=$(echo "${files_hash} ${anka_version} ${product_version} ${product_build_version}" \
  | sha1sum \
  | awk '{print $1}')

vm_name="macos-base-${product_version}-${product_build_version}-${cache_key:0:8}"

echo "--- Checking for VM ${vm_name}"

if anka show "${vm_name}" ; then
  echo "Already exists!"
  exit 0
fi

echo "--- Calculating installer checksums"
echo "Compare to https://github.com/notpeter/apple-installer-checksums"
shasum /Applications/Install*OS*.app/Contents/SharedSupport/InstallESD.dmg

echo "--- Installing error trap for install.log"
trap upload_install_log ERR

echo "--- Building ${vm_name}"
make macos-10.12 "packer_log=${PACKER_LOG:-}" "vm_name=${vm_name}"
