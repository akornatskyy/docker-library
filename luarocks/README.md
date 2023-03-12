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

# install application and optional modules
RUN luarocks install copas \
 && luarocks install luasec

# collect cli-scripts; the ones that contain "LUAROCKS_SYSCONFDIR" are Lua ones
RUN mkdir /luarocksbin \
 && grep -rl LUAROCKS_SYSCONFDIR /usr/local/bin | \
    while IFS= read -r filename; do \
      cp "$filename" /luarocksbin/; \
    done



FROM akorn/lua:5.1-alpine
RUN apk add --no-cache \
    ca-certificates \
    openssl

# copy artifacts (luarocks tree and cli-scripts) over
COPY --from=build /luarocksbin/* /usr/local/bin/
COPY --from=build /usr/local/lib/lua /usr/local/lib/lua
COPY --from=build /usr/local/share/lua /usr/local/share/lua
COPY --from=build /usr/local/lib/luarocks /usr/local/lib/luarocks

CMD ["copas"]
```
