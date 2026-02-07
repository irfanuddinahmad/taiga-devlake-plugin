.PHONY: build lint fmt clean install

# Build configuration
PLUGIN_NAME = taiga
BUILD_DIR = bin
PLUGINS_DIR = plugins/taiga
GO = go
GOFLAGS = -v
LDFLAGS = -s -w

# DevLake directory (override with DEVLAKE_DIR environment variable)
DEVLAKE_DIR ?= ../incubator-devlake/backend

all: fmt build

build:
	@echo "⚠️  WARNING: Building from this standalone repository will fail!"
	@echo "The plugin requires DevLake's internal packages that aren't available here."
	@echo ""
	@echo "Options:"
	@echo "  1. Use the pre-built binary from GitHub Releases"
	@echo "  2. Build from within the DevLake monorepo"
	@echo ""
	@echo "See README.md and PLUGIN_STATUS.md for details."
	@echo ""
	@read -p "Continue anyway? [y/N] " answer; \
	if [ "$$answer" != "y" ] && [ "$$answer" != "Y" ]; then \
		echo "Build cancelled."; \
		exit 1; \
	fi
	@echo "Building Taiga plugin..."
	@mkdir -p $(BUILD_DIR)
	cd $(PLUGINS_DIR) && $(GO) build $(GOFLAGS) -buildmode=plugin -ldflags="$(LDFLAGS)" -o ../../$(BUILD_DIR)/$(PLUGIN_NAME).so .
	@echo "Build complete: $(BUILD_DIR)/$(PLUGIN_NAME).so"

lint:
	@echo "Running linter..."
	@which golangci-lint > /dev/null || (echo "golangci-lint not installed. Run: brew install golangci-lint" && exit 1)
	golangci-lint run ./...

fmt:
	@echo "Formatting code..."
	$(GO) fmt ./...
	gofmt -s -w .

clean:
	@echo "Cleaning build artifacts..."
	rm -rf $(BUILD_DIR)
	find . -name "*.so" -delete

install: build
	@echo "Installing plugin to DevLake..."
	@if [ ! -d "$(DEVLAKE_DIR)" ]; then \
		echo "Error: DevLake directory not found at $(DEVLAKE_DIR)"; \
		echo "Set DEVLAKE_DIR environment variable to your DevLake backend directory"; \
		exit 1; \
	fi
	mkdir -p $(DEVLAKE_DIR)/bin/plugins/$(PLUGIN_NAME)
	cp $(BUILD_DIR)/$(PLUGIN_NAME).so $(DEVLAKE_DIR)/bin/plugins/$(PLUGIN_NAME)/
	@echo "Plugin installed to $(DEVLAKE_DIR)/bin/plugins/$(PLUGIN_NAME)/"

dev: fmt build install
	@echo "Development build complete!"

verify: fmt lint build
	@echo "All verification checks passed!"

help:
	@echo "Taiga DevLake Plugin - Makefile targets:"
	@echo "  make build           - Build the plugin"
	@echo "  make lint            - Run linter"
	@echo "  make fmt             - Format code"
	@echo "  make clean           - Clean build artifacts"
	@echo "  make install         - Install plugin to DevLake"
	@echo "  make dev             - Format, build, and install (development workflow)"
	@echo "  make verify          - Run all checks (fmt, lint, build)"
	@echo "  make help            - Show this help message"
