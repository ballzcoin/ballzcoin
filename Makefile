# This Makefile is meant to be used by people that do not usually work
# with Go source code. If you know what GOPATH is then you probably
# don't need to bother with make.

.PHONY: geth android ios ballzcoin-cross swarm evm all test clean
.PHONY: ballzcoin-linux ballzcoin-linux-386 ballzcoin-linux-amd64 ballzcoin-linux-mips64 ballzcoin-linux-mips64le
.PHONY: ballzcoin-linux-arm ballzcoin-linux-arm-5 ballzcoin-linux-arm-6 ballzcoin-linux-arm-7 ballzcoin-linux-arm64
.PHONY: ballzcoin-darwin ballzcoin-darwin-386 ballzcoin-darwin-amd64
.PHONY: ballzcoin-windows ballzcoin-windows-386 ballzcoin-windows-amd64

GOBIN = $(shell pwd)/build/bin
GO ?= latest

ballzcoin:
	build/env.sh go run build/ci.go install ./cmd/ballzcoin
	@echo "Done building."
	@echo "Run \"$(GOBIN)/ballzcoin\" to launch ballzcoin."

swarm:
	build/env.sh go run build/ci.go install ./cmd/swarm
	@echo "Done building."
	@echo "Run \"$(GOBIN)/swarm\" to launch swarm."

all:
	build/env.sh go run build/ci.go install

android:
	build/env.sh go run build/ci.go aar --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/ballzcoin.aar\" to use the library."

ios:
	build/env.sh go run build/ci.go xcode --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/Geth.framework\" to use the library."

test: all
	build/env.sh go run build/ci.go test

lint: ## Run linters.
	build/env.sh go run build/ci.go lint

clean:
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

ballzcoin-cross: ballzcoin-linux ballzcoin-darwin ballzcoin-windows ballzcoin-android ballzcoin-ios
	@echo "Full cross compilation done:"
	@ls -ld $(GOBIN)/ballzcoin-*

ballzcoin-linux: ballzcoin-linux-386 ballzcoin-linux-amd64 ballzcoin-linux-arm ballzcoin-linux-mips64 ballzcoin-linux-mips64le
	@echo "Linux cross compilation done:"
	@ls -ld $(GOBIN)/ballzcoin-linux-*

ballzcoin-linux-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/386 -v ./cmd/ballzcoin
	@echo "Linux 386 cross compilation done:"
	@ls -ld $(GOBIN)/ballzcoin-linux-* | grep 386

ballzcoin-linux-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/ballzcoin
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/ballzcoin-linux-* | grep amd64

ballzcoin-linux-arm: ballzcoin-linux-arm-5 ballzcoin-linux-arm-6 ballzcoin-linux-arm-7 ballzcoin-linux-arm64
	@echo "Linux ARM cross compilation done:"
	@ls -ld $(GOBIN)/ballzcoin-linux-* | grep arm

ballzcoin-linux-arm-5:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-5 -v ./cmd/ballzcoin
	@echo "Linux ARMv5 cross compilation done:"
	@ls -ld $(GOBIN)/ballzcoin-linux-* | grep arm-5

ballzcoin-linux-arm-6:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-6 -v ./cmd/ballzcoin
	@echo "Linux ARMv6 cross compilation done:"
	@ls -ld $(GOBIN)/ballzcoin-linux-* | grep arm-6

ballzcoin-linux-arm-7:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-7 -v ./cmd/ballzcoin
	@echo "Linux ARMv7 cross compilation done:"
	@ls -ld $(GOBIN)/ballzcoin-linux-* | grep arm-7

ballzcoin-linux-arm64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm64 -v ./cmd/ballzcoin
	@echo "Linux ARM64 cross compilation done:"
	@ls -ld $(GOBIN)/ballzcoin-linux-* | grep arm64

ballzcoin-linux-mips:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips --ldflags '-extldflags "-static"' -v ./cmd/ballzcoin
	@echo "Linux MIPS cross compilation done:"
	@ls -ld $(GOBIN)/ballzcoin-linux-* | grep mips

ballzcoin-linux-mipsle:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mipsle --ldflags '-extldflags "-static"' -v ./cmd/ballzcoin
	@echo "Linux MIPSle cross compilation done:"
	@ls -ld $(GOBIN)/ballzcoin-linux-* | grep mipsle

ballzcoin-linux-mips64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64 --ldflags '-extldflags "-static"' -v ./cmd/ballzcoin
	@echo "Linux MIPS64 cross compilation done:"
	@ls -ld $(GOBIN)/ballzcoin-linux-* | grep mips64

ballzcoin-linux-mips64le:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64le --ldflags '-extldflags "-static"' -v ./cmd/ballzcoin
	@echo "Linux MIPS64le cross compilation done:"
	@ls -ld $(GOBIN)/ballzcoin-linux-* | grep mips64le

ballzcoin-darwin: ballzcoin-darwin-386 ballzcoin-darwin-amd64
	@echo "Darwin cross compilation done:"
	@ls -ld $(GOBIN)/ballzcoin-darwin-*

ballzcoin-darwin-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/386 -v ./cmd/ballzcoin
	@echo "Darwin 386 cross compilation done:"
	@ls -ld $(GOBIN)/ballzcoin-darwin-* | grep 386

ballzcoin-darwin-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/amd64 -v ./cmd/ballzcoin
	@echo "Darwin amd64 cross compilation done:"
	@ls -ld $(GOBIN)/ballzcoin-darwin-* | grep amd64

ballzcoin-windows: ballzcoin-windows-386 ballzcoin-windows-amd64
	@echo "Windows cross compilation done:"
	@ls -ld $(GOBIN)/ballzcoin-windows-*

ballzcoin-windows-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/386 -v ./cmd/ballzcoin
	@echo "Windows 386 cross compilation done:"
	@ls -ld $(GOBIN)/ballzcoin-windows-* | grep 386

ballzcoin-windows-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/amd64 -v ./cmd/ballzcoin
	@echo "Windows amd64 cross compilation done:"
	@ls -ld $(GOBIN)/ballzcoin-windows-* | grep amd64
