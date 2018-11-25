# Build Gpton in a stock Go builder container
FROM golang:1.10-alpine as builder

RUN apk add --no-cache make gcc git musl-dev linux-headers

ADD . /go-ptonchain
RUN cd /go-ptonchain && make gpton

# Pull Geth into a second stage deploy alpine container
FROM alpine:latest

RUN apk add --no-cache ca-certificates
COPY --from=builder /go-ptonchain/build/bin/gpton /usr/local/bin/

EXPOSE 7234 7234 33990/tcp 33990/udp
ENTRYPOINT ["gpton"]
