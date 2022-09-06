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
      docker build -q -t ${image} ${module}/${os}
      docker run --rm ${image} nginx -v
    done
  done
  cd ..
done
