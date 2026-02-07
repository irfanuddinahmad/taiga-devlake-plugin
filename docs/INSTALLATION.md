# Installation Guide

This guide walks you through installing the Taiga plugin for Apache DevLake.

## Prerequisites

Before installing, ensure you have:

- ✅ Apache DevLake v0.21.0 or later
- ✅ Taiga instance (v6.0+) with API access
- ✅ Taiga API Bearer token
- ✅ MySQL or PostgreSQL database (for DevLake)

## Installation Methods

### Method 1: Pre-built Binary (Recommended)

1. **Download the binary**:
   ```bash
   wget https://github.com/yourusername/taiga-devlake-plugin/releases/download/v1.0.0/taiga.so
   ```

2. **Copy to DevLake plugins directory**:
   ```bash
   mkdir -p /path/to/devlake/backend/bin/plugins/taiga
   cp taiga.so /path/to/devlake/backend/bin/plugins/taiga/
   ```

3. **Restart DevLake**:
   ```bash
   # If running with Docker
   docker-compose restart

   # If running directly
   cd /path/to/devlake/backend
   ./stop_devlake.sh
   ./start_devlake.sh
   ```

4. **Verify installation**:
   ```bash
   curl http://localhost:8080/plugins | jq '.[] | select(.name == "taiga")'
   ```

### Method 2: Build from Source

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/taiga-devlake-plugin.git
   cd taiga-devlake-plugin
   ```

2. **Build the plugin**:
   ```bash
   make build
   ```

3. **Install to DevLake**:
   ```bash
   export DEVLAKE_DIR=/path/to/devlake/backend
   make install
   ```

4. **Restart DevLake** (see Method 1, step 3)

## Configuration

### 1. Get Taiga API Token

#### Option A: Via Web UI
1. Log in to your Taiga instance
2. Click on your profile → Settings
3. Navigate to "API Tokens" section
4. Click "Generate Token"
5. Copy and save the token securely

#### Option B: Via API
```bash
curl -X POST "https://your-taiga-instance.com/api/v1/auth" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "your-username",
    "password": "your-password",
    "type": "normal"
  }'
```

### 2. Create Connection in DevLake

```bash
curl -X POST "http://localhost:8080/plugins/taiga/connections" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "My Taiga Instance",
    "endpoint": "https://your-taiga-instance.com",
    "token": "YOUR_BEARER_TOKEN_HERE",
    "proxy": "",
    "rateLimitPerHour": 10000
  }'
```

**Response**:
```json
{
  "id": 1,
  "name": "My Taiga Instance",
  "endpoint": "https://your-taiga-instance.com",
  "createdAt": "2026-02-07T10:00:00Z",
  ...
}
```

### 3. Test Connection

```bash
curl -X POST "http://localhost:8080/plugins/taiga/connections/1/test"
```

**Success response**:
```json
{
  "success": true,
  "message": "Connection test successful"
}
```

### 4. List Available Projects

```bash
curl "http://localhost:8080/plugins/taiga/connections/1/remote-scopes?groupId=&page=1&pageSize=100"
```

### 5. Add Project Scope

```bash
curl -X PUT "http://localhost:8080/plugins/taiga/connections/1/scopes" \
  -H "Content-Type: application/json" \
  -d '{
    "data": [{
      "connectionId": 1,
      "projectId": 123,
      "name": "My Project"
    }]
  }'
```

## Running Your First Collection

### Create a Pipeline

```bash
curl -X POST "http://localhost:8080/pipelines" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Taiga Initial Collection",
    "plan": [[{
      "plugin": "taiga",
      "options": {
        "connectionId": 1,
        "projectId": 123
      }
    }]]
  }'
```

### Monitor Pipeline Progress

```bash
# Get pipeline status
curl "http://localhost:8080/pipelines/PIPELINE_ID"

# Watch pipeline logs (if using Docker)
docker logs -f devlake
```

### Verify Data Collection

```bash
# Check collected user stories
curl "http://localhost:8080/api/domainlayer/user_stories?projectId=1:123"
```

## Troubleshooting

### Plugin Not Loading

**Symptom**: Plugin doesn't appear in `/plugins` endpoint

**Solutions**:
1. Check plugin file location:
   ```bash
   ls -lh /path/to/devlake/backend/bin/plugins/taiga/taiga.so
   ```

2. Verify file permissions:
   ```bash
   chmod 644 /path/to/devlake/backend/bin/plugins/taiga/taiga.so
   ```

3. Check DevLake logs:
   ```bash
   docker logs devlake | grep taiga
   ```

4. Ensure Go version compatibility:
   ```bash
   go version  # Should be 1.21+
   ```

### Connection Test Fails

**Symptom**: `/test` endpoint returns error

**Solutions**:
1. Verify Taiga endpoint is accessible:
   ```bash
   curl https://your-taiga-instance.com/api/v1/
   ```

2. Check Bearer token validity:
   ```bash
   curl -H "Authorization: Bearer YOUR_TOKEN" \
     https://your-taiga-instance.com/api/v1/users/me
   ```

3. Verify endpoint format (no trailing slash):
   ```json
   {
     "endpoint": "https://taiga.example.com"  ✅
     "endpoint": "https://taiga.example.com/" ❌
   }
   ```

### Pipeline Fails

**Symptom**: Pipeline status shows `TASK_FAILED`

**Solutions**:
1. Check pipeline error message:
   ```bash
   curl "http://localhost:8080/pipelines/PIPELINE_ID" | jq '.message'
   ```

2. Verify project ID exists in Taiga:
   ```bash
   curl -H "Authorization: Bearer YOUR_TOKEN" \
     "https://your-taiga-instance.com/api/v1/projects/PROJECT_ID"
   ```

3. Check DevLake database connectivity:
   ```bash
   # Check DB connection in environment
   echo $DB_URL
   ```

### No Data Collected

**Symptom**: Pipeline succeeds but no data in database

**Solutions**:
1. Verify scope is configured:
   ```bash
   curl "http://localhost:8080/plugins/taiga/connections/1/scopes"
   ```

2. Check if project has user stories in Taiga

3. Verify extraction and conversion ran:
   ```bash
   # Check raw data tables
   SELECT COUNT(*) FROM _raw_taiga_api_user_stories;
   SELECT COUNT(*) FROM _tool_taiga_user_stories;
   SELECT COUNT(*) FROM user_stories;
   ```

## Upgrading

### From Source Build

```bash
cd taiga-devlake-plugin
git pull origin main
make build
make install
# Restart DevLake
```

### Using Pre-built Binary

1. Download new version
2. Stop DevLake
3. Replace binary
4. Start DevLake

## Uninstallation

```bash
# Stop DevLake
cd /path/to/devlake/backend
./stop_devlake.sh

# Remove plugin
rm -rf bin/plugins/taiga/

# (Optional) Remove plugin data from database
mysql -h 127.0.0.1 -u root -p lake << EOF
DROP TABLE IF EXISTS _tool_taiga_connections;
DROP TABLE IF EXISTS _tool_taiga_projects;
DROP TABLE IF EXISTS _tool_taiga_user_stories;
DROP TABLE IF EXISTS _tool_taiga_scope_configs;
DROP TABLE IF EXISTS _tool_taiga_transformation_rules;
DROP TABLE IF EXISTS _raw_taiga_api_projects;
DROP TABLE IF EXISTS _raw_taiga_api_user_stories;
EOF

# Start DevLake
./start_devlake.sh
```

## Next Steps

- ✅ [Configure additional projects](docs/configuration.md)
- ✅ [Set up automated collection](docs/automation.md)
- ✅ [Integrate with dashboards](docs/dashboards.md)
- ✅ [Explore API endpoints](README.md#api-endpoints)

## Support

- 📚 [Documentation](docs/)
- 🐛 [Report Issues](https://github.com/yourusername/taiga-devlake-plugin/issues)
- 💬 [Discussions](https://github.com/yourusername/taiga-devlake-plugin/discussions)
