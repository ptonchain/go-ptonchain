FROM ubuntu:xenial

ENV PATH=/usr/lib/go-1.9/bin:$PATH

RUN \
  apt-get update && apt-get upgrade -q -y && \
  apt-get install -y --no-install-recommends golang-1.9 git make gcc libc-dev ca-certificates && \
  git clone --depth 1 --branch release/1.8 https://github.com/ptonchain/go-ptonchain && \
  (cd go-ptonchain && make gpton) && \
  cp go-ptonchain/build/bin/gpton /gpton && \
  apt-get remove -y golang-1.9 git make gcc libc-dev && apt autoremove -y && apt-get clean && \
  rm -rf /go-ptonchain

EXPOSE 7234
EXPOSE 33990

ENTRYPOINT ["/geth"]
