#!/bin/bash
set -euxo pipefail

version="$1"
tar_file="$2"
app_dir="/Applications/Xcode-${version}.app"

if [ ! -d "$app_dir" ] ; then
  xcversion install "$version"
fi

if [ ! -f "$tar_file" ] ; then
  mkdir -p "$(dirname "$tar_file")"
  tar cf "$tar_file" "$app_dir"
fi

ls -alh "$tar_file"