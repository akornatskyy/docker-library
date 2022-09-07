#!/bin/sh
set -e


cd "$(dirname "$(readlink -f "$0")")"
versions=$(ls -d */ | tr -d \/)
for version in ${versions} ; do
  for os in alpine ; do
    image=akorn/luarocks:${version}-${os}
    echo building $image ...

    platform=linux/amd64
    case "$version" in
      'luajit2.0') ;;
      *) platform=${platform},linux/arm64 ;;
    esac

    docker buildx build -q \
      --tag ${image} \
      --platform ${platform} \
      --push \
      ${version}/${os}
    docker run --rm ${image} lua -v
  done
done
