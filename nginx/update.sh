#!/bin/sh
set -e


cd "$(dirname "$(readlink -f "$0")")"
versions=$(ls -d */ | tr -d \/)
for version in ${versions} ; do
  cd $version
  modules=$(ls -d */ | tr -d \/)
  for module in ${modules} ; do
    for os in alpine ; do
      image=akorn/nginx:${version}-${module}-${os}
      echo building $image ...

      platform=linux/amd64
      case "$module" in
        'luajit2.0') ;;
        *) platform=${platform},linux/arm64 ;;
      esac

      docker buildx build -q \
        --tag ${image} \
        --platform ${platform} \
        --push \
        ${module}/${os}
      docker run --rm ${image} nginx -v
    done
  done
  cd ..
done
