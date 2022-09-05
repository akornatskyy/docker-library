#!/bin/sh
set -eo pipefail


for c in lua luajit luarocks nginx; do
  sh $c/update.sh
done

docker images
