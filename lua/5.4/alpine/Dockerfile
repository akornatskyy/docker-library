FROM alpine:3.24

LABEL maintainer="Andriy Kornatskyy <andriy.kornatskyy@live.com>"

ENV LUA_VERSION=5.4.9

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
    && wget -c https://www.lua.org/ftp/lua-${LUA_VERSION}.tar.gz \
        -O lua.tar.gz \
    && echo "7d1859d593e48b9f19fe72079e3d61c0fcef18f3  lua.tar.gz" | \
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
