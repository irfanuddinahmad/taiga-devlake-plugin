#!/bin/bash

# Release script for Taiga DevLake Plugin
# Usage: ./scripts/release.sh <version>
# Example: ./scripts/release.sh v1.0.0

set -e

VERSION=${1:-}

if [ -z "$VERSION" ]; then
    echo "Error: Version is required"
    echo "Usage: ./scripts/release.sh <version>"
    echo "Example: ./scripts/release.sh v1.0.0"
    exit 1
fi

echo "==> Preparing release $VERSION"

# Verify we're on main branch
BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$BRANCH" != "main" ]; then
    echo "Error: You must be on main branch to release"
    exit 1
fi

# Check for uncommitted changes
if [ -n "$(git status --porcelain)" ]; then
    echo "Error: You have uncommitted changes"
    exit 1
fi

echo "==> Running tests..."
make test

echo "==> Running linter..."
make lint

echo "==> Building plugin..."
make build

echo "==> Creating checksum..."
cd bin
sha256sum taiga.so > taiga.so.sha256
cd ..

echo "==> Updating CHANGELOG.md..."
echo "Please update CHANGELOG.md with release notes for $VERSION"
read -p "Press enter when ready to continue..."

echo "==> Creating git tag..."
git tag -a "$VERSION" -m "Release $VERSION"

echo "==> Pushing tag to origin..."
git push origin "$VERSION"

echo ""
echo "✅ Release $VERSION created successfully!"
echo ""
echo "Next steps:"
echo "1. GitHub Actions will automatically create the release"
echo "2. Binaries will be uploaded to GitHub releases"
echo "3. Update documentation if needed"
echo "4. Announce the release"
echo ""
echo "Release artifacts:"
echo "  - bin/taiga.so"
echo "  - bin/taiga.so.sha256"
