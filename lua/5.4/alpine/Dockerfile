FROM alpine:3.13

LABEL maintainer="Andriy Kornatskyy <andriy.kornatskyy@live.com>"

ENV LUA_VERSION=5.4.2

RUN set -ex \
    \
    && apk add --no-cache --virtual .build-deps \
        ca-certificates \
        openssl \
        make \
        gcc \
        libc-dev \
    \
    && wget -c https://www.lua.org/ftp/lua-${LUA_VERSION}.tar.gz \
        -O - | tar -xzf - \
    \
    && cd lua-${LUA_VERSION} \
    && make -j"$(nproc)" posix \
    && make install \
    && cd .. \
    && rm -rf lua-${LUA_VERSION} \
    \
    && apk del .build-deps

CMD ["lua"]
