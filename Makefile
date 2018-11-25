# This Makefile is meant to be used by people that do not usually work
# with Go source code. If you know what GOPATH is then you probably
# don't need to bother with make.

.PHONY: gpton android ios gpton-cross swarm evm all test clean
.PHONY: gpton-linux gpton-linux-386 gpton-linux-amd64 gpton-linux-mips64 gpton-linux-mips64le
.PHONY: gpton-linux-arm gpton-linux-arm-5 gpton-linux-arm-6 gpton-linux-arm-7 gpton-linux-arm64
.PHONY: gpton-darwin gpton-darwin-386 gpton-darwin-amd64
.PHONY: gpton-windows gpton-windows-386 gpton-windows-amd64

GOBIN = $(shell pwd)/build/bin
GO ?= latest

gpton:
	build/env.sh go run build/ci.go install ./cmd/gpton
	@echo "Done building."
	@echo "Run \"$(GOBIN)/gpton\" to launch gpton."

swarm:
	build/env.sh go run build/ci.go install ./cmd/swarm
	@echo "Done building."
	@echo "Run \"$(GOBIN)/swarm\" to launch swarm."

all:
	build/env.sh go run build/ci.go install

android:
	build/env.sh go run build/ci.go aar --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/gpton.aar\" to use the library."

ios:
	build/env.sh go run build/ci.go xcode --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/Gpton.framework\" to use the library."

test: all
	build/env.sh go run build/ci.go test

lint: ## Run linters.
	build/env.sh go run build/ci.go lint

clean:
	./build/clean_go_build_cache.sh
	rm -fr build/_workspace/pkg/ $(GOBIN)/*

# The devtools target installs tools required for 'go generate'.
# You need to put $GOBIN (or $GOPATH/bin) in your PATH to use 'go generate'.

devtools:
	env GOBIN= go get -u golang.org/x/tools/cmd/stringer
	env GOBIN= go get -u github.com/kevinburke/go-bindata/go-bindata
	env GOBIN= go get -u github.com/fjl/gencodec
	env GOBIN= go get -u github.com/golang/protobuf/protoc-gen-go
	env GOBIN= go install ./cmd/abigen
	@type "npm" 2> /dev/null || echo 'Please install node.js and npm'
	@type "solc" 2> /dev/null || echo 'Please install solc'
	@type "protoc" 2> /dev/null || echo 'Please install protoc'

# Cross Compilation Targets (xgo)

gpton-cross: gpton-linux gpton-darwin gpton-windows gpton-android gpton-ios
	@echo "Full cross compilation done:"
	@ls -ld $(GOBIN)/gpton-*

gpton-linux: gpton-linux-386 gpton-linux-amd64 gpton-linux-arm gpton-linux-mips64 gpton-linux-mips64le
	@echo "Linux cross compilation done:"
	@ls -ld $(GOBIN)/gpton-linux-*

gpton-linux-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/386 -v ./cmd/gpton
	@echo "Linux 386 cross compilation done:"
	@ls -ld $(GOBIN)/gpton-linux-* | grep 386

gpton-linux-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/gpton
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/gpton-linux-* | grep amd64

gpton-linux-arm: gpton-linux-arm-5 gpton-linux-arm-6 gpton-linux-arm-7 gpton-linux-arm64
	@echo "Linux ARM cross compilation done:"
	@ls -ld $(GOBIN)/gpton-linux-* | grep arm

gpton-linux-arm-5:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-5 -v ./cmd/gpton
	@echo "Linux ARMv5 cross compilation done:"
	@ls -ld $(GOBIN)/gpton-linux-* | grep arm-5

gpton-linux-arm-6:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-6 -v ./cmd/gpton
	@echo "Linux ARMv6 cross compilation done:"
	@ls -ld $(GOBIN)/gpton-linux-* | grep arm-6

gpton-linux-arm-7:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-7 -v ./cmd/gpton
	@echo "Linux ARMv7 cross compilation done:"
	@ls -ld $(GOBIN)/gpton-linux-* | grep arm-7

gpton-linux-arm64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm64 -v ./cmd/gpton
	@echo "Linux ARM64 cross compilation done:"
	@ls -ld $(GOBIN)/gpton-linux-* | grep arm64

gpton-linux-mips:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips --ldflags '-extldflags "-static"' -v ./cmd/gpton
	@echo "Linux MIPS cross compilation done:"
	@ls -ld $(GOBIN)/gpton-linux-* | grep mips

gpton-linux-mipsle:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mipsle --ldflags '-extldflags "-static"' -v ./cmd/gpton
	@echo "Linux MIPSle cross compilation done:"
	@ls -ld $(GOBIN)/gpton-linux-* | grep mipsle

gpton-linux-mips64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64 --ldflags '-extldflags "-static"' -v ./cmd/gpton
	@echo "Linux MIPS64 cross compilation done:"
	@ls -ld $(GOBIN)/gpton-linux-* | grep mips64

gpton-linux-mips64le:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64le --ldflags '-extldflags "-static"' -v ./cmd/gpton
	@echo "Linux MIPS64le cross compilation done:"
	@ls -ld $(GOBIN)/gpton-linux-* | grep mips64le

gpton-darwin: gpton-darwin-386 gpton-darwin-amd64
	@echo "Darwin cross compilation done:"
	@ls -ld $(GOBIN)/gpton-darwin-*

gpton-darwin-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/386 -v ./cmd/gpton
	@echo "Darwin 386 cross compilation done:"
	@ls -ld $(GOBIN)/gpton-darwin-* | grep 386

gpton-darwin-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/amd64 -v ./cmd/gpton
	@echo "Darwin amd64 cross compilation done:"
	@ls -ld $(GOBIN)/gpton-darwin-* | grep amd64

gpton-windows: gpton-windows-386 gpton-windows-amd64
	@echo "Windows cross compilation done:"
	@ls -ld $(GOBIN)/gpton-windows-*

gpton-windows-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/386 -v ./cmd/gpton
	@echo "Windows 386 cross compilation done:"
	@ls -ld $(GOBIN)/gpton-windows-* | grep 386

gpton-windows-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/amd64 -v ./cmd/gpton
	@echo "Windows amd64 cross compilation done:"
	@ls -ld $(GOBIN)/gpton-windows-* | grep amd64
