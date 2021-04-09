#!/bin/bash
set -eo pipefail


cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

for version in stable mainline ; do
  cd $version
  modules=( */ )
  for module in "${modules[@]%/}" ; do
    for os in alpine ; do
      image=akorn/nginx:${version}-${module}-${os}
      echo building $image ...
      docker build -q -t ${image} ${module}/${os}
      docker run --rm ${image} nginx -v
    done
  done
  cd ..
done
