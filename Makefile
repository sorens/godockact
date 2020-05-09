GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test -count=1
GOFORMAT=gofmt -s -w .
BINARY_NAME=hello
BUILD_DIR=build
LINUX_DIR=linux
MACOS_DIR=macos
WIN_DIR=windows

all: build 
build: mod pre-build cross
pre-build: pre-build-linux pre-build-macos pre-build-windows

pre-build-linux:
	@mkdir -p $(BUILD_DIR)/$(LINUX_DIR)

pre-build-macos:
	@mkdir -p $(BUILD_DIR)/$(MACOS_DIR)

pre-build-windows: 
	@mkdir -p $(BUILD_DIR)/$(WIN_DIR)

clean: 
	@echo cleaning
	@$(GOCLEAN) -r -cache -modcache -testcache
	@rm -f $(BUILD_DIR)/$(LINUX_DIR)/*
	@rm -f $(BUILD_DIR)/$(MACOS_DIR)/*
	@rm -f $(BUILD_DIR)/$(WIN_DIR)/*

mod:
	@echo tidying go code
	@$(GOFORMAT)

cross: pre-build build-macos build-linux build-windows

# Cross compilation
build-macos: pre-build-macos
	@echo building for macos
	@CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 $(GOBUILD) -o $(BUILD_DIR)/$(MACOS_DIR)/$(BINARY_NAME)

build-linux: pre-build-linux
	@echo building for linux
	@CGO_ENABLED=0 GOOS=linux GOARCH=amd64 $(GOBUILD) -o $(BUILD_DIR)/$(LINUX_DIR)/$(BINARY_NAME)

build-windows: pre-build-windows
	@echo "building for windows (separate binaries)"
