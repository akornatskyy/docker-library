FROM alpine:3.8

LABEL maintainer="Andriy Kornatskyy <andriy.kornatskyy@live.com>"

ENV LUAJIT_VERSION=2.1

RUN set -ex \
    \
    && apk -U upgrade \
    && apk add --no-cache \
        libgcc \
    \
    && apk add --no-cache --virtual .build-deps \
        ca-certificates \
        openssl \
        make \
        gcc \
        libc-dev \
    \
    && wget -c https://github.com/LuaJIT/LuaJIT/archive/v${LUAJIT_VERSION}.tar.gz \
        -O - | tar xzf - \
    \
    && cd LuaJIT-${LUAJIT_VERSION} \
    && make -j"$(nproc)" \
    && make install INSTALL_INC=/usr/local/include \
    && cd .. \
    && rm -rf LuaJIT-${LUAJIT_VERSION} \
    && cd /usr/local/bin \
    && ln -sf luajit-${LUAJIT_VERSION}* lua \
    && cd /usr/local/lib \
    && find libluajit*.so | xargs -I {} ln -sf {} {}.2 \
    \
    && apk del .build-deps

CMD ["lua"]
