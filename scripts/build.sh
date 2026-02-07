#!/bin/bash

# Build script for Taiga DevLake Plugin

set -e

PLUGIN_NAME="taiga"
BUILD_DIR="bin"
PLUGINS_DIR="plugins/taiga"

echo "==> Building Taiga DevLake Plugin"

# Clean previous builds
echo "==> Cleaning previous builds..."
rm -rf ${BUILD_DIR}
mkdir -p ${BUILD_DIR}

# Build the plugin
echo "==> Compiling plugin..."
cd ${PLUGINS_DIR}
go build -v -buildmode=plugin -ldflags="-s -w" -o ../../${BUILD_DIR}/${PLUGIN_NAME}.so .
cd ../..

# Get file size
SIZE=$(du -h ${BUILD_DIR}/${PLUGIN_NAME}.so | cut -f1)

echo ""
echo "✅ Build complete!"
echo "   Output: ${BUILD_DIR}/${PLUGIN_NAME}.so"
echo "   Size: ${SIZE}"
