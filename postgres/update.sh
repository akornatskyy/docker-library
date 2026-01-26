#!/bin/sh
set -ex

export MSYS_NO_PATHCONV=1

cd "$(dirname "$(readlink -f "$0")")"

# image=localhost:5000/akorn/postgres
image=akorn/postgres
versions="17 18"
platforms=linux/amd64,linux/arm64
build_date=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
mint_version=1.41.8

prepare() {
  docker run --privileged --rm tonistiigi/binfmt --install arm64
  # docker buildx create --use --name b --driver-opt network=host
}

build_mint() {
  docker buildx build -t mint --load -f - . <<EOF
FROM debian AS b
RUN set -ex \
    \
    && apt-get -yq update \
    && DEBIAN_FRONTEND=noninteractive apt-get -yq install wget \
    \
    && ARCH=\$(dpkg --print-architecture) \
    && case "\${ARCH}" in \
      amd64) f=dist_linux.tar.gz ;; \
      arm64) f=dist_linux_arm64.tar.gz ;; \
    esac \
    && wget -qO mint.tar.gz \
      https://github.com/mintoolkit/mint/releases/download/${mint_version}/\${f} \
    \
    && mkdir mint \
    && tar xf mint.tar.gz --strip-components=1 -C mint
FROM scratch
COPY --from=b mint /bin
ENTRYPOINT [ "/bin/mint" ]
EOF
}

build_arch_image() {
  major=${1}
  arch=$(echo ${DOCKER_DEFAULT_PLATFORM} | cut -d'/' -f2)

  docker rmi postgres:${major} || true
  docker pull postgres:${major}
  docker ps -a
  docker images
  docker inspect postgres:${major}

  docker run --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    mint build \
    --target postgres:${major} \
    --tag localhost:5000/postgres:${major}-slim-${arch} \
    --show-clogs=true \
    --env POSTGRES_HOST_AUTH_METHOD=trust \
    --http-probe=false \
    --include-path=/usr/bin/chown \
    --include-path=/usr/share/zoneinfo \
    --exec='set -ex
    sleep 5
    i=1
    while [ $i -le 10 ]; do
      gosu postgres pgbench -i -s 10 postgres && break || sleep 5
      i=$((i+1))
    done
    gosu postgres pg_isready
    gosu postgres pg_ctl -w stop
    rm -rf $PGDATA/*'

  docker run --name pg --rm -d \
    --env POSTGRES_HOST_AUTH_METHOD=trust \
    localhost:5000/postgres:${major}-slim-${arch}

  for i in $(seq 1 10); do
    if docker exec -u postgres pg pg_isready; then
      if docker exec -u postgres pg pg_ctl -W stop; then
        break
      fi
    fi
    sleep 2
  done
}

start_local_registry() {
  docker ps -a --filter "name=registry" | grep registry &&
    docker start registry ||
    docker run --name registry --rm -p 5000:5000 -d registry:3
}

push_to_local_registry() {
  docker push -a localhost:5000/postgres
}

build_multiarch_image() {
  major=${1}
  version=$(
    docker run --rm --entrypoint postgres \
      postgres:${major} -V | cut -d' ' -f3
  )
  docker buildx build \
    -t ${image}:${major}-scratch \
    -t ${image}:${version}-scratch \
    --platform ${platforms} --push -f - . <<EOF
FROM localhost:5000/postgres:${major}-slim-\$TARGETARCH AS b
FROM scratch
COPY --from=b / /
ENV LANG=en_US.utf8 \
  PATH=\$PATH:/usr/lib/postgresql/${major}/bin \
  PG_MAJOR=${major} \
  PGDATA=/var/lib/postgresql/data
LABEL org.postgresql.created=${build_date} \
  org.postgresql.version=${major} \
  org.opencontainers.image.created=${build_date} \
  org.opencontainers.image.source="https://github.com/akornatskyy/docker-library" \
  org.opencontainers.image.title="postgres" \
  org.opencontainers.image.version=${major}
VOLUME /var/lib/postgresql/data
ENTRYPOINT [ "docker-entrypoint.sh" ]
STOPSIGNAL SIGINT
EXPOSE 5432
CMD [ "postgres" ]
EOF
}

cleanup() {
  docker stop registry
  docker image prune -af
}

main() {
  # prepare
  start_local_registry
  for platform in $(echo "${platforms}" | tr ',' ' '); do
    export DOCKER_DEFAULT_PLATFORM=${platform}
    build_mint

    for major in ${versions} ; do
      build_arch_image ${major}
    done
  done

  push_to_local_registry
  for major in ${versions} ; do
    build_multiarch_image ${major}
  done
  # cleanup
}

main
