# Quick Start Guide

Get up and running with the Taiga DevLake plugin in 5 minutes.

## 1. Installation

### Option A: Use Pre-built Binary (Fastest)

```bash
# Copy pre-built binary to DevLake
cp bin/taiga.so /path/to/devlake/backend/bin/plugins/taiga/

# Restart DevLake
cd /path/to/devlake/backend
./stop_devlake.sh && ./start_devlake.sh
```

### Option B: Build from Source

```bash
# Build
make build

# Install
export DEVLAKE_DIR=/path/to/devlake/backend
make install
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
