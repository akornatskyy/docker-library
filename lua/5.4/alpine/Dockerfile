FROM alpine:3.15

LABEL maintainer="Andriy Kornatskyy <andriy.kornatskyy@live.com>"

ENV LUA_VERSION=5.4.6

RUN set -ex \
    \
    && apk -U upgrade \
    && apk add --no-cache \
        readline \
    \
    && apk add --no-cache --virtual .build-deps \
        ca-certificates \
        openssl \
        make \
        gcc \
        libc-dev \
        readline-dev \
        ncurses-dev \
    \
    && wget --no-check-certificate -c \
        https://www.lua.org/ftp/lua-${LUA_VERSION}.tar.gz \
        -O lua.tar.gz \
    && echo "83f41abf92620dd15f022e6f863807b07e318495  lua.tar.gz" | \
        sha1sum -c -s - \
    && tar xzf lua.tar.gz \
    \
    && cd lua-${LUA_VERSION} \
    && make -j"$(nproc)" linux \
    && make install \
    && cd .. \
    && rm -rf lua.tar.gz lua-${LUA_VERSION} \
    \
    && apk del .build-deps

CMD ["lua"]
