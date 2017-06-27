#!/bin/bash

set -e
set -o pipefail
set -u

guestinfo() {
  local key="guestinfo.$1"
  local tool="/Library/Application Support/VMware Tools/vmware-tools-daemon"
  local value; value=$("$tool" --cmd "info-get $key")
  if [[ -n $value ]]; then
    echo "$value"
  else
    echo >&2 "Missing $key"
  fi
}

cleanup() {
  echo "--- Buildkite exited, shutting down machine"
  shutdown -h now
}

echo "--- Querying VMware guestinfo"
vmdk=$(guestinfo vmkite-vmdk)
name=$(guestinfo vmkite-name)
token=$(guestinfo vmkite-buildkite-agent-token)
debug=$(guestinfo vmkite-buildkite-debug)
autoshutdown=$(guestinfo vmkite-buildkite-auto-shutdown)

[[ -n $vmdk && -n $name && -n $token ]] || exit 10

if [[ -z $autoshutdown || $autoshutdown =~ (true|1) ]] ; then
  trap cleanup EXIT
fi

aws_access_key_id=$(guestinfo aws-access-key-id)
aws_secret_access_key=$(guestinfo aws-secret-access-key)

export AWS_ACCESS_KEY_ID="$aws_access_key_id"
export AWS_SECRET_ACCESS_KEY="$aws_secret_access_key"

echo "--- Starting buildkite-agent"
export BUILDKITE_AGENT_TOKEN="$token"
export BUILDKITE_AGENT_NAME="$name"
export BUILDKITE_AGENT_META_DATA="vmkite-vmdk=$vmdk,vmkite-guestid=darwin13_64Guest"
export BUILDKITE_AGENT_DEBUG="$debug"

su vmkite -c "/usr/local/bin/buildkite-agent start --disconnect-after-job"