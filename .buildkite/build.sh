#!/bin/bash

image="$1"

echo "--- Building $image"
make "$image"
