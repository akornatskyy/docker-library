## Example build container

This docker file creates a Copas (asynchroneous scheduler) image. It shows how
to copy the LuaRocks installed Lua modules over to the final image.

```docker
FROM akorn/luarocks:lua5.1-alpine as build

RUN apk add \
    gcc \
    git \
    libc-dev \
    make \
    openssl-dev

# install application. LuaRocks will pull in other modules and build the binary
# dependencies
RUN luarocks install copas

# collect cli-scripts; the ones that contain "LUAROCKS_SYSCONFDIR" are Lua ones
RUN mkdir /luarocksbin \
 && grep -rl LUAROCKS_SYSCONFDIR /usr/local/bin | \
    while IFS= read -r filename; do \
      cp "$filename" /luarocksbin/; \
    done



FROM akorn/lua:5.1-alpine

# copy artifacts (luarocks tree and cli-scripts) over
COPY --from=build /luarocksbin/* /usr/local/bin/
COPY --from=build /usr/local/lib/lua /usr/local/lib/lua
COPY --from=build /usr/local/share/lua /usr/local/share/lua
COPY --from=build /usr/local/lib/luarocks /usr/local/lib/luarocks

CMD ["copas"]
```

## Example LuaRocks server

This example shows how to use the LuaRocks image to create a local LuaRocks
server. This can be used to serve private rocks, or only curated rocks.

```bash
#!/usr/bin/env bash

# Starts a LuaRocks server using nginx
# Usage: ./rockserver.sh
# The rocks directory is "./rocks" (manifest file will be generated here, so
# it only needs to contain the rock and rockspec files).
# The server will be available at http://localhost:8080
#
# Use LuaRocks with the following flag;
#   --server http://localhost:8080
#
# To ONLY use this server (a fully curated approach), use the following flag;
#   --only-server http://localhost:8080


# default rocks directory is "./rocks"
ROCKSDIR=$(pwd)/rocks
mkdir -p "$ROCKSDIR"

# generate a manifest file
docker run --rm -v "$ROCKSDIR":/rocks \
    akorn/luarocks:lua5.1-alpine \
    luarocks-admin make_manifest /rocks

# start nginx to serve rocks
docker run --rm --name luarocks-server \
    -v "$ROCKSDIR":/usr/share/nginx/html:ro \
    -p 8080:80 nginx
```