.PHONY: build cluster test

default: build

build:
	go build -o bin/swarm    github.com/ptonchain/go-ptonchain/cmd/swarm
	go build -o bin/geth     github.com/ptonchain/go-ptonchain/cmd/geth
	go build -o bin/bootnode github.com/ptonchain/go-ptonchain/cmd/bootnode

cluster: build
	scripts/boot-cluster.sh

test:
	go test -v github.com/ptonchain/go-ptonchain/swarm/...
