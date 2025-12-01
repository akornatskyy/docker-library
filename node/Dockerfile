ARG DEBIAN_CODENAME=trixie
ARG DEBIAN_VERSION=13
ARG NODE_VERSION=24

FROM node:${NODE_VERSION}-${DEBIAN_CODENAME}-slim AS b

RUN set -ex \
    \
    && apt-get -yq update \
    && apt-get -yq upgrade \
    \
    && apt-get -yq install binutils \
    \
    && strip -sXx /usr/local/bin/node \
    \
    && mkdir -p /opt/rootfs \
    && cd /opt/rootfs \
    \
    && ARCH=$(dpkg --print-architecture) \
    && case "${ARCH}" in \
       amd64) ARCH='x86_64' ;; \
       arm64) ARCH='aarch64' ;; \
    esac \
    && mkdir -p usr/lib/${ARCH}-linux-gnu usr/local/bin \
    \
    && cp -a /usr/local/bin/node usr/local/bin \
    && if [ $(echo "${NODE_VERSION}" | cut -d. -f1) -ge 25 ]; then \
      cp -a /usr/lib/${ARCH}-linux-gnu/libatomic.so* \
        usr/lib/${ARCH}-linux-gnu ; \
    fi \
    && cp -a /usr/lib/${ARCH}-linux-gnu/libstdc++.so* \
      /usr/lib/${ARCH}-linux-gnu/libgcc_s.so* usr/lib/${ARCH}-linux-gnu

FROM gcr.io/distroless/base-debian${DEBIAN_VERSION}

ARG NODE_VERSION BUILD_DATE

LABEL org.nodejs.created=${BUILD_DATE} \
      org.nodejs.version=${NODE_VERSION} \
      org.opencontainers.image.created=${BUILD_DATE} \
      org.opencontainers.image.source="https://github.com/akornatskyy/docker-library" \
      org.opencontainers.image.title="node" \
      org.opencontainers.image.version=${NODE_VERSION}

COPY --from=b /opt/rootfs /

CMD []
ENTRYPOINT [ "/usr/local/bin/node" ]
