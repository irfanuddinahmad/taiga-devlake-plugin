# Taiga Plugin for Apache DevLake

[![Go Report Card](https://goreportcard.com/badge/github.com/yourusername/taiga-devlake-plugin)](https://goreportcard.com/report/github.com/yourusername/taiga-devlake-plugin)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Coverage](https://img.shields.io/badge/coverage-90%25-brightgreen)](https://github.com/yourusername/taiga-devlake-plugin)

A DevLake plugin for collecting data from Taiga project management platform.

## Features

- 🎯 **Project Collection**: Retrieve project details from Taiga
- 📝 **User Story Collection**: Collect user stories with full pagination support
- 🔄 **Scope Management**: Full API support for managing project scopes
- 🔌 **Native Go Plugin**: Built as a DevLake-compatible plugin
- ✅ **High Test Coverage**: 90%+ unit test coverage

## Installation

### Using Pre-built Binary

1. Download the latest release binary (`taiga.so`) from the [releases page](https://github.com/yourusername/taiga-devlake-plugin/releases)
2. Copy to your DevLake plugins directory:
   ```bash
   cp taiga.so /path/to/devlake/backend/bin/plugins/taiga/
   ```
3. Restart DevLake server

### Building from Source

```bash
# Clone the repository
git clone https://github.com/yourusername/taiga-devlake-plugin.git
cd taiga-devlake-plugin

# Build the plugin
make build

# Copy to DevLake
cp bin/taiga.so /path/to/devlake/backend/bin/plugins/taiga/
```

## Configuration

### Prerequisites

- Apache DevLake v0.21.0 or later
- Taiga instance (v6.0+ recommended)
- Taiga API Bearer token

### Getting a Taiga Bearer Token

1. Log in to your Taiga instance
2. Navigate to User Settings → API Tokens
3. Generate a new token
4. Save it securely

### Creating a Connection

```bash
curl -X POST "http://localhost:8080/plugins/taiga/connections" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "MyTaiga",
    "endpoint": "https://your-taiga-instance.com",
    "token": "your-bearer-token-here",
    "rateLimitPerHour": 10000
  }'
```

### Adding a Scope (Project)

```bash
curl -X PUT "http://localhost:8080/plugins/taiga/connections/1/scopes" \
  -H "Content-Type: application/json" \
  -d '{
    "data": [{
      "projectId": 1,
      "name": "My Project",
      "connectionId": 1
    }]
  }'
```

### Running Data Collection

```bash
curl -X POST "http://localhost:8080/pipelines" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Taiga Collection",
    "plan": [[{
      "plugin": "taiga",
      "options": {
        "connectionId": 1,
        "projectId": 1
      }
    }]]
  }'
```

## Data Models

The plugin collects and transforms the following data:

### Tool Layer (Raw Data)
- `_tool_taiga_connections` - Connection configurations
- `_tool_taiga_projects` - Project metadata
- `_tool_taiga_user_stories` - User stories
- `_tool_taiga_scope_configs` - Scope configurations

### Domain Layer (Transformed Data)
- `projects` - Normalized project information
- `user_stories` - Normalized user story data

## API Endpoints

The plugin exposes the following REST endpoints:

- `GET /plugins/taiga/connections` - List all connections
- `POST /plugins/taiga/connections` - Create a new connection
- `GET /plugins/taiga/connections/:connectionId` - Get connection details
- `PATCH /plugins/taiga/connections/:connectionId` - Update connection
- `DELETE /plugins/taiga/connections/:connectionId` - Delete connection
- `POST /plugins/taiga/connections/:connectionId/test` - Test connection
- `GET /plugins/taiga/connections/:connectionId/remote-scopes` - List available projects
- `PUT /plugins/taiga/connections/:connectionId/scopes` - Add project scopes
- `GET /plugins/taiga/connections/:connectionId/scopes` - List configured scopes
- `GET /plugins/taiga/connections/:connectionId/scopes/:scopeId` - Get scope details
- `PATCH /plugins/taiga/connections/:connectionId/scopes/:scopeId` - Update scope
- `DELETE /plugins/taiga/connections/:connectionId/scopes/:scopeId` - Delete scope

## Development

### Prerequisites

- Go 1.21 or later
- Apache DevLake development environment

### Building from Source

```bash
# Build the plugin
make build

# The compiled plugin will be at bin/taiga.so
```

### Building

```bash
# Build plugin
make build

# Clean build artifacts
make clean
```

### Code Quality

```bash
# Run linter
make lint

# Format code
make fmt
```

## Architecture

```
plugins/taiga/
├── plugin_main.go      # Plugin entry point
├── models/             # Data models
│   ├── connection.go   # Connection model
│   ├── project.go      # Project model
│   └── user_story.go   # User story model
├── tasks/              # Data collection tasks
│   ├── project_collector.go
│   ├── user_story_collector.go
│   └── task_data.go
├── api/                # REST API handlers
│   ├── connection_api.go
│   ├── scope_api.go
│   └── remote_api.go
└── impl/               # Plugin implementation
    └── impl.go         # Plugin registration
```

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for release history.

## Support

- 📚 [Documentation](docs/)
- 🐛 [Issue Tracker](https://github.com/yourusername/taiga-devlake-plugin/issues)
- 💬 [Discussions](https://github.com/yourusername/taiga-devlake-plugin/discussions)

## Acknowledgments

- Apache DevLake Community
- Taiga Project Management Platform

---

Made with ❤️ by the DevLake community
