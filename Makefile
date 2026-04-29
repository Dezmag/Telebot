# ---------- CONFIG ----------
BINARY_NAME := tbot
MODULE := my-telegram-bot

# Версія з git тегів або fallback
VERSION := $(shell git describe --tags --abbrev=0 2>NUL || echo dev)

# ldflags
LDFLAGS := -X $(MODULE)/cmd.appVersion=$(VERSION)

# ---------- DEFAULT ----------
all: format build

# ---------- FORMAT ----------
format:
	gofmt -s -w .

# ---------- BUILD (CURRENT OS) ----------
build:
	go build -v -o $(BINARY_NAME) -ldflags "$(LDFLAGS)" ./cmd

# ---------- RUN ----------
run:
	go run ./cmd

# ---------- CLEAN ----------
clean:
	del $(BINARY_NAME).exe 2>NUL || rm -f $(BINARY_NAME)

# ---------- DEPS ----------
deps:
	go mod tidy

# ---------- CROSS BUILD ----------
build-linux:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o $(BINARY_NAME)-linux -ldflags "$(LDFLAGS)" ./cmd

build-windows:
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -o $(BINARY_NAME).exe -ldflags "$(LDFLAGS)" ./cmd

build-mac:
	CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -o $(BINARY_NAME)-mac -ldflags "$(LDFLAGS)" ./cmd