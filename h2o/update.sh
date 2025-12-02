#!/bin/sh
set -e


image=akorn/h2o
build_date=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
h2o_version=$(
  git ls-remote https://github.com/h2o/h2o.git refs/heads/master |
  cut -c1-7
)
tag=$(date -u +"%Y.%m.%d")

cd "$(dirname "$(readlink -f "$0")")"

for debian_version in 12 13 ; do

  docker buildx build \
    --build-arg H2O_VERSION=${h2o_version} \
    --build-arg BUILD_DATE=${build_date} \
    --build-arg DEBIAN_VERSION=${debian_version} \
    --tag ${image} \
    --tag ${image}:distroless-debian${debian_version} \
    --tag ${image}:${tag}-distroless-debian${debian_version} \
    --platform linux/amd64,linux/arm64 \
    --push \
    .

  docker run --rm ${image} --version

done
