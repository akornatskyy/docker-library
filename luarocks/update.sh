#!/bin/bash
set -eo pipefail


cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"
versions=( */ )
for version in "${versions[@]%/}" ; do
  for os in alpine ; do
    image=akorn/luarocks:${version}-${os}
    echo building $image ...
    docker build -q -t ${image} ${version}/${os}
    docker run --rm ${image} lua -v
  done
done