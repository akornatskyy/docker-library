# Docker Library

[![Build Status](https://travis-ci.org/akornatskyy/docker-library.svg?branch=master)](https://travis-ci.org/akornatskyy/docker-library)

# Images

These images are based on the [Alpine Linux](https://alpinelinux.org/).
- [lua](https://hub.docker.com/r/akorn/lua/) 5.1, 5.2, 5.3
- [luajit](https://hub.docker.com/r/akorn/luajit/) 2.0, 2.1
- [luarocks](https://hub.docker.com/r/akorn/luarocks/) lua, luajit
- [nginx](https://hub.docker.com/r/akorn/nginx/) stable-lua5.1, stable-luajit2.0, stable-luajit2.1

# Examples

```
docker run -it --rm akorn/lua:5.1-alpine
```

# Setup

```
docker images --format "{{.Repository}}:{{.Tag}}" | awk '/akorn/ && !/none/' \
     | tac | xargs -I {} docker push {}
```

# Links

- [Best practices](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/) for writing Dockerfiles
