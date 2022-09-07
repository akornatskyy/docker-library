#!/bin/sh
set -e


cd "$(dirname "$(readlink -f "$0")")"
versions=$(ls -d */ | tr -d \/)
for version in ${versions} ; do
  for os in alpine ; do
    image=akorn/lua:${version}-${os}
    echo building $image ...

    platform=linux/amd64,linux/arm64

    docker buildx build -q \
      --tag ${image} \
      --platform ${platform} \
      --push \
      ${version}/${os}
    docker run --rm ${image} lua -v
  done
done
