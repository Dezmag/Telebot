VERSION := $(shell git describe --tags --abbrev=0 )-$(shell git rev-parse --short HEAD)

format:
	gofmt -s -w ./

build: format
	TARGETOS ?= windows
TARGETARCH ?= amd64
lint:
   golint
test:
   go test -v    

build: format
	CGO_ENABLED=0 GOOS=$(TARGETOS) GOARCH=$(TARGETARCH) go build -v -o tbot -ldflags "-X my-telegram-bot/cmd.appVersion=$(VERSION)"
clean:
    rm -rf tbot