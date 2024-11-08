#!/bin/sh
set -e


cd "$(dirname "$(readlink -f "$0")")"
for major in 20 22 23 ; do
  version=$(docker run --rm node:${major}-bookworm-slim --version)
  version=$(echo ${version} | cut -c2-)
  minor=$(echo ${version} | cut -d. -f2)

  image=akorn/node
  echo building ${version} ...

  docker buildx build \
    --build-arg NODE_VERSION=${version} \
    --tag ${image} \
    --tag ${image}:${major} \
    --tag ${image}:${major}.${minor} \
    --tag ${image}:${version} \
    --platform linux/amd64,linux/arm64 \
    --push \
    .

done
