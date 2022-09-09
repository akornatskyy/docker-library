# Docker Library

[![images](https://github.com/akornatskyy/docker-library/actions/workflows/images.yml/badge.svg)](https://github.com/akornatskyy/docker-library/actions/workflows/images.yml)

## Images

These images are based on the [Alpine Linux](https://alpinelinux.org/) and
built for `linux/amd64` and `linux/arm64` (except luajit 2.0 and nginx).

- [lua](https://hub.docker.com/r/akorn/lua/) 5.1, 5.2, 5.3, 5.4
- [luajit](https://hub.docker.com/r/akorn/luajit/) 2.0, 2.1, 2.1-edge, 2.1-openresty
- [luarocks](https://hub.docker.com/r/akorn/luarocks/) lua*, luajit*
- [nginx](https://hub.docker.com/r/akorn/nginx/) stable-lua*, stable-luajit*, mainline-lua*, mainline-luajit*

## Examples

```sh
docker run -it --rm akorn/lua:5.1-alpine
```

## Links

- [Best practices](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/) for writing Dockerfiles
