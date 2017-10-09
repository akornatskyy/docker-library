FROM akorn/luarocks:luajit2.0-alpine

MAINTAINER Andriy Kornatskyy <andriy.kornatskyy@live.com>

ENV NGINX_VERSION=1.12.2
ENV NGINX_LUA_MODULE_VERSION=0.10.10

RUN set -ex \
    \
    && apk add --no-cache --virtual .build-deps \
        make \
        gcc \
        libc-dev \
        zlib-dev \
    \
    && wget -c https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
        -O - | tar xzf - \
    && wget -c https://github.com/openresty/lua-nginx-module/archive/v${NGINX_LUA_MODULE_VERSION}.tar.gz \
        -O - | tar xzf - \
    \
    && cd nginx-${NGINX_VERSION} \
    && ./configure --without-http_rewrite_module --without-pcre \
        --add-module=../lua-nginx-module-${NGINX_LUA_MODULE_VERSION} \
    && make -j"$(nproc)" \
    && make install \
    && ln -s /usr/local/nginx/sbin/nginx /usr/local/bin/nginx \
    && cd .. \
    && rm -rf nginx-* lua-nginx-module-* \
    \
    && apk del .build-deps

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
