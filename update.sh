#!/bin/bash
set -eo pipefail


for c in lua luajit luarocks nginx; do
  bash $c/update.sh
done

docker images
