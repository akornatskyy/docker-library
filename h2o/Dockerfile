ARG DEBIAN_VERSION=12

FROM debian:${DEBIAN_VERSION}-slim AS b

ARG H2O_VERSION=master

RUN set -ex \
    \
    && apt-get -yq update \
    && apt-get -yq upgrade \
    \
    && apt-get -yq --no-install-recommends install \
      binutils \
      ca-certificates \
      clang \
      cmake \
      curl \
      libbrotli-dev \
      libcap-dev \
      libssl-dev \
      libuv1-dev \
      libz-dev \
      make \
      pkg-config \
    \
    && mkdir src \
    && cd src \
    && curl -LSs "https://github.com/h2o/h2o/archive/${H2O_VERSION}.tar.gz" | \
      tar --strip-components=1 -xz \
    \
    && ARCH=$(dpkg --print-architecture) \
    && case "${ARCH}" in \
       amd64) CMAKE_C_FLAGS='-march=x86-64-v3' ;; \
       arm64) CMAKE_C_FLAGS='-march=armv8-a' ;; \
    esac \
    \
    && cmake -B build \
      -DCMAKE_C_FLAGS="-flto=auto -mtune=generic ${CMAKE_C_FLAGS}" \
      -DBUILD_SHARED_LIBS=off \
      -DWITH_DTRACE=off \
      -DWITH_MRUBY=off \
      -DWITHOUT_LIBS=on \
      -S . \
    \
    && cmake --build build \
    \
    && strip -sXx build/h2o \
    \
    && mkdir -p /opt/rootfs \
    && cd /opt/rootfs \
    \
    && case "${ARCH}" in \
       amd64) ARCH='x86_64' ;; \
       arm64) ARCH='aarch64' ;; \
    esac \
    && mkdir -p usr/lib/${ARCH}-linux-gnu usr/local/bin usr/local/share/h2o \
    \
    && ln -s /etc/ssl/certs/ca-certificates.crt \
      usr/local/share/h2o/ca-bundle.crt \
    && cp -a /src/build/h2o usr/local/bin \
    && cp -a /usr/lib/${ARCH}-linux-gnu/libz.so* \
      /usr/lib/${ARCH}-linux-gnu/libcap.so* usr/lib/${ARCH}-linux-gnu


FROM gcr.io/distroless/base-debian${DEBIAN_VERSION}

ARG H2O_VERSION BUILD_DATE

LABEL org.h2o.created=${BUILD_DATE} \
      org.h2o.version=${H2O_VERSION} \
      org.opencontainers.image.created=${BUILD_DATE} \
      org.opencontainers.image.source="https://github.com/akornatskyy/docker-library" \
      org.opencontainers.image.title="h2o" \
      org.opencontainers.image.version=${H2O_VERSION}

COPY --from=b /opt/rootfs /

WORKDIR /

ENTRYPOINT [ "/usr/local/bin/h2o" ]
