# Taiga Plugin for Apache DevLake v1.0.0

First public release! 🎉

## Installation

> ⚠️ **VERSION COMPATIBILITY**: The pre-built binary is built against a specific DevLake version. If you encounter a version mismatch error, you must rebuild the plugin from source (see Alternative Installation below).

Download and install the pre-built binary:

```bash
# Download the binary
wget https://github.com/irfanuddinahmad/taiga-devlake-plugin/releases/download/v1.0.0/taiga.so

# Verify checksum (optional)
wget https://github.com/irfanuddinahmad/taiga-devlake-plugin/releases/download/v1.0.0/taiga.so.sha256
shasum -a 256 -c taiga.so.sha256

# Install to DevLake
mkdir -p /path/to/devlake/backend/bin/plugins/taiga
cp taiga.so /path/to/devlake/backend/bin/plugins/taiga/

# Restart DevLake with the plugin enabled
cd /path/to/devlake/backend
DEVLAKE_PLUGINS=taiga go run server/main.go
```

### Alternative Installation (Rebuild from Source)

If you get a version mismatch error like:
```
plugin was built with a different version of package github.com/apache/incubator-devlake/core/config
```

You must rebuild the plugin against your DevLake version:

```bash
# Navigate to your DevLake installation
cd /path/to/your/devlake/backend

# Download and extract plugin source
wget https://github.com/irfanuddinahmad/taiga-devlake-plugin/archive/refs/tags/v1.0.0.tar.gz
tar -xzf v1.0.0.tar.gz

# Copy plugin source
cp -r taiga-devlake-plugin-1.0.0/plugins/taiga plugins/

# Build against your DevLake version
go build -buildmode=plugin -o bin/plugins/taiga/taiga.so plugins/taiga/*.go

# Start DevLake
DEVLAKE_PLUGINS=taiga go run server/main.go
```

## Features

- ✅ Complete Taiga API integration
- ✅ Project and User Story collection  
- ✅ Pagination support for large datasets
- ✅ DevLake domain layer transformation
- ✅ Full REST API for connection/scope management
- ✅ Tested and verified with live Taiga instance

## Compatibility

- Apache DevLake v0.21.0+
- Go 1.21+
- Taiga API v6+

## What's Included

- `taiga.so` - Pre-built plugin binary (38MB)
- `taiga.so.sha256` - SHA256 checksum for verification

## Documentation

- [README](https://github.com/irfanuddinahmad/taiga-devlake-plugin#readme)
- [Quick Start Guide](https://github.com/irfanuddinahmad/taiga-devlake-plugin/blob/main/QUICKSTART.md)  
- [Installation Guide](https://github.com/irfanuddinahmad/taiga-devlake-plugin/blob/main/docs/INSTALLATION.md)
- [API Documentation](https://github.com/irfanuddinahmad/taiga-devlake-plugin/blob/main/docs/API.md)
- [Plugin Status](https://github.com/irfanuddinahmad/taiga-devlake-plugin/blob/main/PLUGIN_STATUS.md)

## Quick Start

After installation, create a connection:

```bash
curl -X POST http://localhost:8080/plugins/taiga/connections \
  -H "Content-Type: application/json" \
  -d '{
    "name": "My Taiga",
    "endpoint": "https://your-taiga.com",
    "token": "your-bearer-token",
    "rateLimitPerHour": 10000
  }'
```

See the [Quick Start Guide](https://github.com/irfanuddinahmad/taiga-devlake-plugin/blob/main/QUICKSTART.md) for complete setup instructions.

## SHA256 Checksum

```
cf752cbed44d2d46cc3e8627a660f253620aca1a4d23d2a21b4adaaa0fffbf3b  taiga.so
```

## Support

- 🐛 [Report Issues](https://github.com/irfanuddinahmad/taiga-devlake-plugin/issues)
- 💬 [Discussions](https://github.com/irfanuddinahmad/taiga-devlake-plugin/discussions)
- 📚 [Documentation](https://github.com/irfanuddinahmad/taiga-devlake-plugin/tree/main/docs)
