#!/bin/sh
set -e


image=akorn/node
build_date=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

cd "$(dirname "$(readlink -f "$0")")"
for os in bookworm,12 trixie,13 ; do
  debian_codename=${os%%,*}
  debian_version=${os##*,}

  for major in 22 24 25 ; do
    version=$(docker run --rm node:${major}-${debian_codename}-slim --version)
    version=$(echo ${version} | cut -c2-)
    minor=$(echo ${version} | cut -d. -f2)

    docker buildx build \
      --build-arg NODE_VERSION=${version} \
      --build-arg BUILD_DATE=${build_date} \
      --build-arg DEBIAN_CODENAME=${debian_codename} \
      --build-arg DEBIAN_VERSION=${debian_version} \
      --tag ${image} \
      --tag ${image}:${major} \
      --tag ${image}:${major}.${minor} \
      --tag ${image}:distroless-debian${debian_version} \
      --tag ${image}:${major}-distroless-debian${debian_version} \
      --tag ${image}:${major}.${minor}-distroless-debian${debian_version} \
      --platform linux/amd64,linux/arm64 \
      --push \
      .

    docker run --rm ${image} --version

  done
done
