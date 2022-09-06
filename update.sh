#!/bin/sh
set -e


for c in lua luajit luarocks nginx; do
  sh $c/update.sh
done

docker images
