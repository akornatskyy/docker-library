# Docker Library

[![lua](https://github.com/akornatskyy/docker-library/actions/workflows/lua.yml/badge.svg)](https://github.com/akornatskyy/docker-library/actions/workflows/lua.yml) [![node](https://github.com/akornatskyy/docker-library/actions/workflows/node.yml/badge.svg)](https://github.com/akornatskyy/docker-library/actions/workflows/node.yml)

## Images

[Alpine Linux](https://alpinelinux.org/) `linux/amd64` and `linux/arm64`
(except luajit 2.0 and nginx):

- [lua](https://hub.docker.com/r/akorn/lua/) 5.1, 5.2, 5.3, 5.4
- [luajit](https://hub.docker.com/r/akorn/luajit/) 2.0, 2.1, 2.1-edge, 2.1-openresty
- [luarocks](https://hub.docker.com/r/akorn/luarocks/) lua*, luajit*
- [nginx](https://hub.docker.com/r/akorn/nginx/) stable-lua*, stable-luajit*, mainline-lua*, mainline-luajit*

[Debian 12 (bookworm)](https://www.debian.org/) /
[distroless](https://github.com/GoogleContainerTools/distroless)
`linux/amd64` and `linux/arm64`:

- [node](https://nodejs.org/) lts, current

## Examples

```sh
docker run -it --rm akorn/lua:5.1-alpine
```

The LuaRocks images can be used as build containers, see [this example](luarocks/README.md).

The node image is configured to run script directly (the entrypoint is set to
*node*).

```sh
docker run -it --rm akorn/node:21 --version

docker run -it --rm -u nobody akorn/node index.js

docker run -it --rm akorn/node --enable-source-maps index.js
```

## Links

- [Best practices](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/) for writing Dockerfiles
