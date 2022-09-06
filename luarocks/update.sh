#!/bin/sh
set -e


cd "$(dirname "$(readlink -f "$0")")"
versions=$(ls -d */ | tr -d \/)
for version in ${versions} ; do
  for os in alpine ; do
    image=akorn/luarocks:${version}-${os}
    echo building $image ...
    docker build -q -t ${image} ${version}/${os}
    docker run --rm ${image} lua -v
  done
done
