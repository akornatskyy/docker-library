# h2o

[h2o](https://github.com/h2o/h2o) is a fast, modern, and extensible open-source web server with a focus on HTTP/2 and performance.

Config file `h2o.conf`:

```yaml
file.send-compressed: ON
http2-reprioritize-blocking-assets: ON
send-server-name: OFF

hosts:
  localhost:
    listen:
      port: 8080
    listen: &listen_ssl
      port: 4443
      ssl:
        certificate-file: /server.crt
        key-file: /server.key
        ocsp-update-interval: 0
    listen:
      <<: *listen_ssl
      type: quic
    paths:
      /: &base
        file.dir: /public
        header.unset: "accept-ranges"
        header.unset: "last-modified"
        header.set: "cache-control: max-age=1800"
      /css:
        <<: *base
        file.dir: /public/css
        header.set: "cache-control: max-age=7200, immutable"
      /js:
        <<: *base
        file.dir: /public/js
        header.set: "cache-control: max-age=7200, immutable"
```

Run:

```sh
docker run --name test -it --rm -p 8080:8080 -p 4443:4443 \
  -v ./h2o.conf:/usr/local/etc/h2o.conf \
  -v ./config/server.key:/server.key \
  -v ./config/server.crt:/server.crt \
  -v ./public:/public \
  akorn/h2o
```
