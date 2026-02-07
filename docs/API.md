# API Reference

Complete API reference for the Taiga DevLake plugin.

## Base URL

All endpoints are prefixed with `/plugins/taiga/`

Example: `http://localhost:8080/plugins/taiga/connections`

## Authentication

DevLake API uses the configured authentication in your DevLake instance. The Taiga plugin itself uses Bearer token authentication to connect to Taiga.

## Connection Management

### List Connections

**Endpoint**: `GET /connections`

**Description**: Retrieve all Taiga connections

**Response**:
```json
[
  {
    "id": 1,
    "name": "My Taiga",
    "endpoint": "https://taiga.example.com",
    "proxy": "",
    "rateLimitPerHour": 10000,
    "createdAt": "2026-02-07T10:00:00Z",
    "updatedAt": "2026-02-07T10:00:00Z"
  }
]
```

### Get Connection

**Endpoint**: `GET /connections/:connectionId`

**Parameters**:
- `connectionId` (path) - Connection ID

**Response**:
```json
{
  "id": 1,
  "name": "My Taiga",
  "endpoint": "https://taiga.example.com",
  "token": "ey***",
  "proxy": "",
  "rateLimitPerHour": 10000,
  "createdAt": "2026-02-07T10:00:00Z",
  "updatedAt": "2026-02-07T10:00:00Z"
}
```

### Create Connection

**Endpoint**: `POST /connections`

**Request Body**:
```json
{
  "name": "My Taiga",
  "endpoint": "https://taiga.example.com",
  "token": "your-bearer-token",
  "proxy": "",
  "rateLimitPerHour": 10000
}
```

**Response**: Same as Get Connection

**Validation**:
- `name`: Required, non-empty string
- `endpoint`: Required, valid URL without trailing slash
- `token`: Required, non-empty string
- `rateLimitPerHour`: Optional, defaults to 10000

### Update Connection

**Endpoint**: `PATCH /connections/:connectionId`

**Parameters**:
- `connectionId` (path) - Connection ID

**Request Body**: (all fields optional)
```json
{
  "name": "Updated Name",
  "endpoint": "https://new-taiga.example.com",
  "token": "new-token",
  "rateLimitPerHour": 5000
}
```

**Response**: Updated connection object

### Delete Connection

**Endpoint**: `DELETE /connections/:connectionId`

**Parameters**:
- `connectionId` (path) - Connection ID

**Response**:
```json
{
  "success": true
}
```

### Test Connection

**Endpoint**: `POST /connections/:connectionId/test`

**Parameters**:
- `connectionId` (path) - Connection ID

**Response** (success):
```json
{
  "success": true,
  "message": "Connection test successful"
}
```

**Response** (failure):
```json
{
  "success": false,
  "message": "Failed to connect: <error details>"
}
```

## Scope Management

### List Remote Scopes

**Endpoint**: `GET /connections/:connectionId/remote-scopes`

**Parameters**:
- `connectionId` (path) - Connection ID
- `page` (query) - Page number (default: 1)
- `pageSize` (query) - Items per page (default: 100)

**Response**:
```json
{
  "page": 1,
  "pageSize": 100,
  "total": 5,
  "children": [
    {
      "id": "123",
      "name": "Project Alpha",
      "parentId": null,
      "type": "project"
    }
  ]
}
```

### Add Scopes

**Endpoint**: `PUT /connections/:connectionId/scopes`

**Parameters**:
- `connectionId` (path) - Connection ID

**Request Body**:
```json
{
  "data": [
    {
      "connectionId": 1,
      "projectId": 123,
      "name": "Project Alpha"
    }
  ]
}
```

**Response**: Array of created scope objects

### List Scopes

**Endpoint**: `GET /connections/:connectionId/scopes`

**Parameters**:
- `connectionId` (path) - Connection ID

**Response**:
```json
[
  {
    "connectionId": 1,
    "projectId": 123,
    "name": "Project Alpha",
    "slug": "project-alpha",
    "description": "Project description",
    "createdAt": "2026-02-07T10:00:00Z",
    "updatedAt": "2026-02-07T10:00:00Z"
  }
]
```

### Get Scope

**Endpoint**: `GET /connections/:connectionId/scopes/:scopeId`

**Parameters**:
- `connectionId` (path) - Connection ID
- `scopeId` (path) - Scope ID (format: "connectionId:projectId")

**Response**: Single scope object

### Update Scope

**Endpoint**: `PATCH /connections/:connectionId/scopes/:scopeId`

**Parameters**:
- `connectionId` (path) - Connection ID
- `scopeId` (path) - Scope ID

**Request Body**:
```json
{
  "name": "Updated Project Name",
  "description": "Updated description"
}
```

**Response**: Updated scope object

### Delete Scope

**Endpoint**: `DELETE /connections/:connectionId/scopes/:scopeId`

**Parameters**:
- `connectionId` (path) - Connection ID
- `scopeId` (path) - Scope ID

**Response**:
```json
{
  "success": true
}
```

## Scope Config Management

### List Scope Configs

**Endpoint**: `GET /connections/:connectionId/scope-configs`

**Response**:
```json
[
  {
    "id": 1,
    "connectionId": 1,
    "name": "Default Config",
    "createdAt": "2026-02-07T10:00:00Z",
    "updatedAt": "2026-02-07T10:00:00Z"
  }
]
```

### Create Scope Config

**Endpoint**: `POST /connections/:connectionId/scope-configs`

**Request Body**:
```json
{
  "connectionId": 1,
  "name": "Custom Config"
}
```

### Update Scope Config

**Endpoint**: `PATCH /connections/:connectionId/scope-configs/:scopeConfigId`

### Delete Scope Config

**Endpoint**: `DELETE /connections/:connectionId/scope-configs/:scopeConfigId`

## Data Models

### Connection

```typescript
interface TaigaConnection {
  id: number
  name: string
  endpoint: string
  token: string
  proxy: string
  rateLimitPerHour: number
  createdAt: string
  updatedAt: string
}
```

### Project (Scope)

```typescript
interface TaigaProject {
  connectionId: number
  projectId: number
  name: string
  slug: string
  description: string
  url: string
  isPrivate: boolean
  totalMilestones: number
  totalStoryPoints: number
  createdAt: string
  updatedAt: string
}
```

### User Story

```typescript
interface TaigaUserStory {
  connectionId: number
  projectId: number
  id: number
  ref: number
  version: number
  subject: string
  description: string
  status: string
  createdDate: string
  modifiedDate: string
  finishDate: string | null
}
```

## Error Codes

| Code | Message | Description |
|------|---------|-------------|
| 400 | Bad Request | Invalid request parameters |
| 401 | Unauthorized | Invalid or missing authentication |
| 404 | Not Found | Resource not found |
| 500 | Internal Server Error | Server error |

## Rate Limiting

The plugin respects the `rateLimitPerHour` setting for each connection. Default is 10,000 requests per hour.

When rate limit is exceeded:
```json
{
  "error": "Rate limit exceeded",
  "message": "Too many requests to Taiga API"
}
```

## Pagination

List endpoints support pagination:

**Query Parameters**:
- `page`: Page number (1-based)
- `pageSize`: Items per page (default: 100, max: 1000)

**Response** includes:
```json
{
  "page": 1,
  "pageSize": 100,
  "total": 250,
  "data": [...]
}
```

## Examples

### Complete Workflow

```bash
# 1. Create connection
CONN_ID=$(curl -X POST "http://localhost:8080/plugins/taiga/connections" \
  -H "Content-Type: application/json" \
  -d '{"name":"My Taiga","endpoint":"https://taiga.example.com","token":"TOKEN"}' \
  | jq -r '.id')

# 2. Test connection
curl -X POST "http://localhost:8080/plugins/taiga/connections/${CONN_ID}/test"

# 3. List available projects
curl "http://localhost:8080/plugins/taiga/connections/${CONN_ID}/remote-scopes?page=1&pageSize=10"

# 4. Add project scope
curl -X PUT "http://localhost:8080/plugins/taiga/connections/${CONN_ID}/scopes" \
  -H "Content-Type: application/json" \
  -d '{"data":[{"connectionId":'${CONN_ID}',"projectId":123,"name":"My Project"}]}'

# 5. Run collection
curl -X POST "http://localhost:8080/pipelines" \
  -H "Content-Type: application/json" \
  -d '{
    "name":"Taiga Collection",
    "plan":[[{
      "plugin":"taiga",
      "options":{"connectionId":'${CONN_ID}',"projectId":123}
    }]]
  }'
```
