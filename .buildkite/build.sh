#!/bin/bash
set -euo pipefail

image="$1"

echo "--- Building $image"
make "$image"
