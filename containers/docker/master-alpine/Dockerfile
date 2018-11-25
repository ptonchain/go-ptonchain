FROM alpine:3.7

RUN \
  apk add --update go git make gcc musl-dev linux-headers ca-certificates && \
  git clone --depth 1 --branch release/1.8 https://github.com/ptonchain/go-ptonchain && \
  (cd go-ptonchain && make gpton) && \
  cp go-ptonchain/build/bin/gpton /gpton && \
  apk del go git make gcc musl-dev linux-headers && \
  rm -rf /go-ptonchain && rm -rf /var/cache/apk/*

EXPOSE 7234
EXPOSE 33990

ENTRYPOINT ["/geth"]
