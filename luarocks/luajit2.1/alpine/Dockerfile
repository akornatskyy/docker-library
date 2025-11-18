FROM akorn/luajit:2.1-alpine

LABEL maintainer="Andriy Kornatskyy <andriy.kornatskyy@live.com>"

ENV LUAROCKS_VERSION=3.12.2

RUN set -ex \
    \
    && apk add --no-cache \
        ca-certificates \
        openssl \
        wget \
    \
    && apk add --no-cache --virtual .build-deps \
        make \
        gcc \
        libc-dev \
    \
    && wget https://luarocks.github.io/luarocks/releases/luarocks-${LUAROCKS_VERSION}.tar.gz \
        -O - | tar -xzf - \
    \
    && cd luarocks-${LUAROCKS_VERSION} \
    && ./configure --with-lua=/usr/local \
    && make build \
    && make install \
    && cd .. \
    && rm -rf luarocks-${LUAROCKS_VERSION} \
    \
    && apk del .build-deps

CMD ["luarocks"]
