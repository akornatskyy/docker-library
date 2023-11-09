ARG NODE_VERSION

FROM node:${NODE_VERSION}-bookworm-slim as b

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
    && mkdir -p lib/${ARCH}-linux-gnu usr/local/bin \
    \
    && cp -a /usr/local/bin/node usr/local/bin \
    && cp -a /lib/${ARCH}-linux-gnu/libstdc++.so* lib/${ARCH}-linux-gnu \
    && cp -a /lib/${ARCH}-linux-gnu/libgcc_s.so* lib/${ARCH}-linux-gnu

FROM gcr.io/distroless/base-debian12

ARG NODE_VERSION
LABEL nodejs/version=${NODE_VERSION}

COPY --from=b /opt/rootfs /

CMD []
ENTRYPOINT [ "/usr/local/bin/node" ]
