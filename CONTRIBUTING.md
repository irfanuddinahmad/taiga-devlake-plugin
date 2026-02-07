# Contributing to Taiga DevLake Plugin

Thank you for your interest in contributing! This document provides guidelines for contributing to the Taiga DevLake plugin.

## Getting Started

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/irfanuddinahmad/taiga-devlake-plugin.git
   cd taiga-devlake-plugin
   ```
3. Add upstream remote:
   ```bash
   git remote add upstream https://github.com/originalowner/taiga-devlake-plugin.git
   ```

## Development Setup

### Prerequisites

- Go 1.21 or later
- Apache DevLake v0.21.0+ (for integration testing)
- Taiga instance (for integration testing)
- golangci-lint (for code quality checks)

### Building

```bash
make build
```

### Running Tests

```bash
# Run all tests
make test

# Run with coverage
make test-coverage

# Generate HTML coverage report
make coverage-html
```

## Code Style

We follow standard Go coding conventions:

- Use `gofmt` for formatting
- Follow [Effective Go](https://golang.org/doc/effective_go.html)
- Use meaningful variable and function names
- Add comments for exported functions and types

Before submitting, run:

```bash
make fmt
make lint
```

## Testing Requirements

- All new code must include unit tests
- Maintain test coverage above 90%
- Include both positive and negative test cases
- Mock external dependencies (API calls, database)

### Writing Tests

```go
func TestYourFeature(t *testing.T) {
    t.Run("SuccessCase", func(t *testing.T) {
        // Test happy path
        assert.NotNil(t, result)
    })

    t.Run("ErrorCase", func(t *testing.T) {
        // Test error handling
        assert.Error(t, err)
    })
}
```

## Pull Request Process

1. **Create a branch** for your feature or fix:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes** following the code style guidelines

3. **Add tests** for your changes

4. **Run verification**:
   ```bash
   make verify
   ```

5. **Commit your changes** with clear messages:
   ```bash
   git commit -m "Add feature: brief description"
   ```

6. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```

7. **Create a Pull Request** on GitHub

### PR Guidelines

- **Title**: Clear, concise description of the change
- **Description**: 
  - What problem does this solve?
  - How does it solve it?
  - Any breaking changes?
  - Screenshots (if UI changes)
- **Tests**: Ensure all tests pass
- **Documentation**: Update README/docs if needed

## Commit Message Format

Follow conventional commits:

```
type(scope): subject

body

footer
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `test`: Adding or updating tests
- `refactor`: Code refactoring
- `perf`: Performance improvements
- `chore`: Maintenance tasks

Examples:
```
feat(collector): add support for Taiga tasks
fix(api): handle 404 errors in pagination
docs(readme): update installation instructions
test(models): add tests for user story conversion
```

## Code Review Process

1. Maintainers will review your PR
2. Address any feedback or requested changes
3. Once approved, your PR will be merged

## Issue Guidelines

When creating an issue:

1. **Search first** to avoid duplicates
2. **Use templates** when available
3. **Provide details**:
   - Steps to reproduce (for bugs)
   - Expected vs actual behavior
   - Environment information
   - Relevant logs or error messages

## Architecture Overview

```
plugins/taiga/
├── plugin_main.go      # Plugin entry point
├── models/             # Data models
│   ├── connection.go   # Connection configuration
│   ├── project.go      # Project/scope models
│   └── user_story.go   # User story models
├── tasks/              # Collection & transformation
│   ├── project_collector.go
│   ├── user_story_collector.go
│   ├── extractors.go
│   └── converters.go
├── api/                # REST API handlers
│   ├── connection_api.go
│   ├── scope_api.go
│   └── remote_api.go
└── impl/               # Implementation
    └── impl.go
```

## Adding New Features

### Adding a New Collection Task

1. Create collector in `tasks/`:
   ```go
   func CollectNewData(taskCtx plugin.SubTaskContext) errors.Error {
       // Implementation
   }
   ```

2. Add subtask metadata:
   ```go
   var CollectNewDataMeta = plugin.SubTaskMeta{
       Name:             "collectNewData",
       EntryPoint:       CollectNewData,
       EnabledByDefault: true,
       Description:      "Collect new data from Taiga",
       DomainTypes:      []string{plugin.DOMAIN_TYPE_TICKET},
   }
   ```

3. Register in `impl/impl.go`:
   ```go
   tasks.CollectNewDataMeta,
   ```

4. Add tests in `tests/tasks_test.go`

### Adding a New API Endpoint

1. Create handler in `api/`:
   ```go
   func NewEndpoint(input *plugin.ApiResourceInput) (*plugin.ApiResourceOutput, errors.Error) {
       // Implementation
   }
   ```

2. Register in `impl/impl.go`:
   ```go
   "endpoint": {
       Post: api.NewEndpoint,
   },
   ```

3. Add tests in `tests/api_test.go`

## Documentation

- Update README.md for user-facing changes
- Add inline comments for complex logic
- Update CHANGELOG.md for all changes
- Include examples for new features

## Release Process

1. Update version in relevant files
2. Update CHANGELOG.md
3. Create a release tag
4. Build and upload binaries
5. Update documentation

## Questions?

- Open an issue for discussion
- Check existing issues and PRs
- Review the [DevLake documentation](https://devlake.apache.org/docs/)

## License

By contributing, you agree that your contributions will be licensed under the Apache License 2.0.

---

Thank you for contributing! 🎉
