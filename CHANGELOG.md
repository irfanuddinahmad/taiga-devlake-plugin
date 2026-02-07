# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-02-07

### Added
- Initial release of Taiga DevLake plugin
- Project collection from Taiga API
- User story collection with optimized pagination
- Full REST API for connection management
- Scope (project) management endpoints
- Remote scope discovery
- Domain layer transformation for projects and user stories
- Comprehensive unit tests (90%+ coverage)
- Complete documentation and contribution guidelines

### Features
- **Connection Management**: Create, update, delete, and list Taiga connections
- **Scope Management**: Add, update, remove project scopes
- **Data Collection**: 
  - Projects: Collect project metadata
  - User Stories: Collect all user stories (optimized single-page fetch)
- **Data Transformation**: Convert tool-layer data to DevLake domain models
- **API Endpoints**: Full RESTful API for all operations
- **Test Coverage**: 90%+ unit test coverage

### Technical Details
- Built with Go 1.21+
- Compatible with Apache DevLake v0.21.0+
- Uses DevLake's plugin framework
- Follows DevLake data model conventions

### Known Limitations
- Currently supports Projects and User Stories only
- Tasks, Epics, and Sprints planned for future releases
- Requires Taiga API v1 (v6.0+ instances)

## [Unreleased]

### Planned
- Task collection and transformation
- Epic support
- Sprint/milestone support
- Webhook support for real-time updates
- Incremental collection optimization
- Custom field mapping
- Advanced filtering options

---

## Version History

### Version Naming

- **Major** (X.0.0): Breaking changes, major new features
- **Minor** (0.X.0): New features, backward compatible
- **Patch** (0.0.X): Bug fixes, minor improvements

### Upgrade Notes

#### From Alpha/Beta to 1.0.0
- First stable release
- No breaking changes (first release)
- All features are production-ready

---

For detailed changes, see the [commit history](https://github.com/yourusername/taiga-devlake-plugin/commits/).
