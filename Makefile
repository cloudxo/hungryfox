VERSION := $(shell git describe --always --tags --abbrev=0 | tail -c +2)
RELEASE := $(shell git describe --always --tags | awk -F- '{ if ($$2) dot="."} END { printf "1%s%s%s%s\n",dot,$$2,dot,$$3}')
GOVERSION := $(shell go version | cut -d' ' -f3)

default: clean test build

clean:
	rm -rf build

test:
	go test ./...


prepare:
	go get "github.com/smartystreets/goconvey"

test_codecov: prepare
	go test -race -coverprofile="coverage.txt" ./...

build:
	mkdir -p build/usr/bin/
	go build -ldflags "-X main.version=${VERSION}-${RELEASE} -o build/usr/bin/hungryfox ./cmd/hungryfox

rpm:
	mkdir -p build/etc/hungryfox
	build/usr/bin/hungryfox -default-config > build/etc/hungryfox/config.yml
