# Quick Start Guide

Get up and running with the Taiga DevLake plugin in 5 minutes.

## 1. Installation

> ⚠️ **VERSION COMPATIBILITY**: Pre-built binaries are version-specific. If you get a version mismatch error, use Option B.

### Option A: Use Pre-built Binary (Fastest)

```bash
# Download from GitHub releases
wget https://github.com/irfanuddinahmad/taiga-devlake-plugin/releases/latest/download/taiga.so

# Copy to DevLake plugins directory
mkdir -p /path/to/devlake/backend/bin/plugins/taiga/
cp taiga.so /path/to/devlake/backend/bin/plugins/taiga/

# Restart DevLake
cd /path/to/devlake/backend
export DEVLAKE_PLUGINS=taiga
go run server/main.go
```

### Option B: Rebuild for Your DevLake Version

```bash
# Navigate to your DevLake installation
cd /path/to/devlake/backend

# Copy plugin source
cp -r /path/to/taiga-devlake-plugin/plugins/taiga plugins/

# Build against your DevLake version
go build -buildmode=plugin -o bin/plugins/taiga/taiga.so plugins/taiga/*.go

# Start DevLake
export DEVLAKE_PLUGINS=taiga
go run server/main.go
```

## 2. Configuration

### Create Connection

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

Save the returned `id` (e.g., 1)

### Add Project Scope

```bash
curl -X PUT http://localhost:8080/plugins/taiga/connections/1/scopes \
  -H "Content-Type: application/json" \
  -d '{
    "data": [{
      "connectionId": 1,
      "projectId": 123,
      "name": "My Project"
    }]
  }'
```

## 3. Collect Data

```bash
curl -X POST http://localhost:8080/pipelines \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Taiga Collection",
    "plan": [[{
      "plugin": "taiga",
      "options": {
        "connectionId": 1,
        "projectId": 123
      }
    }]]
  }'
```

## 4. Verify

```bash
# Check pipeline status
curl http://localhost:8080/pipelines/PIPELINE_ID

# View collected data
curl http://localhost:8080/api/domainlayer/user_stories?projectId=1:123
```

## Need Help?

- 📚 [Full Installation Guide](docs/INSTALLATION.md)
- 🔌 [API Reference](docs/API.md)
- 🤝 [Contributing Guide](CONTRIBUTING.md)
- 🐛 [Report Issues](https://github.com/irfanuddinahmad/taiga-devlake-plugin/issues)

## Development

```bash
# Run tests
make test

# Check coverage
make test-coverage

# Lint code
make lint

# Format code
make fmt
```

## What Gets Collected?

- ✅ **Projects**: Metadata, description, settings
- ✅ **User Stories**: Title, description, status, dates
- ⏳ **Tasks**: Coming soon
- ⏳ **Epics**: Coming soon
- ⏳ **Sprints**: Coming soon

## System Requirements

- Go 1.21+
- Apache DevLake 0.21.0+
- Taiga 6.0+
- MySQL/PostgreSQL database

---

**Ready in 5 minutes** | **90%+ Test Coverage** | **Production-Ready**
