FROM akorn/lua:5.1-alpine

MAINTAINER Andriy Kornatskyy <andriy.kornatskyy@live.com>

ENV LUAROCKS_VERSION=2.4.4

RUN set -ex \
    \
    && apk add --no-cache \
        ca-certificates \
        openssl \
        curl \
    \
    && apk add --no-cache --virtual .build-deps \
        make \
        gcc \
        libc-dev \
    \
    && wget -c https://github.com/luarocks/luarocks/archive/v${LUAROCKS_VERSION}.tar.gz \
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
