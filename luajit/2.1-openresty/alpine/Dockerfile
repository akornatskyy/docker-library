FROM alpine:3.13

LABEL maintainer="Andriy Kornatskyy <andriy.kornatskyy@live.com>"

ENV LUAJIT_VERSION=2.1-20210510

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
    && wget -c https://github.com/openresty/luajit2/archive/v${LUAJIT_VERSION}.tar.gz \
        -O - | tar xzf - \
    \
    && cd luajit2-${LUAJIT_VERSION} \
    && make -j"$(nproc)" \
    && make install INSTALL_INC=/usr/local/include \
    && cd .. \
    && rm -rf luajit2-${LUAJIT_VERSION} \
    && cd /usr/local/bin \
    && ln -sf luajit lua \
    \
    && apk del .build-deps

CMD ["lua"]
