# Changelog

All notable changes to the EEE4482 e-Library project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [V1.1] - 2025-11-02

### Added - API, Proxy, Validation & Themes
- 🌐 **API Service Layer**:
  - Robust HTTP client with comprehensive error handling
  - Timeout configuration (30 seconds default)
  - Bearer token authentication support
  - Custom ApiException for better error reporting
  - Support for GET, POST, PUT, DELETE, and PATCH methods
- 🔄 **Proxy Support**:
  - Dynamic proxy configuration
  - Settings persistence with SharedPreferences
  - Support for development and corporate proxies
  - Configurable proxy host and port
- ✅ **Input Validation**:
  - Comprehensive validation utilities
  - Real-time validation feedback
  - Custom validators for book data (title, author, ISBN, date, publisher)
  - Support for email, URL, phone, and custom patterns
  - Clear, actionable error messages
- 🎨 **Multiple UI Themes**:
  - GitHub High Contrast theme (dark, accessibility-focused)
  - JetBrains IDE theme (Darcula style)
  - Xcode theme (macOS developer tools style)
  - Theme persistence across sessions
  - Instant theme switching
- ⚙️ **Settings Page**:
  - API base URL configuration
  - Proxy configuration with enable/disable
  - Theme selection interface
  - Reset to defaults functionality
- 📚 **Enhanced Services**:
  - BookService for CRUD operations
  - API configuration management
  - Settings state management with Provider
- 📝 **Comprehensive Documentation**:
  - API_PROXY_VALIDATION_GUIDE.md with detailed examples
  - Code examples for all features
  - Best practices and troubleshooting
- 📦 **New Dependencies**:
  - http: ^1.2.0 for API calls
  - provider: ^6.1.1 for state management
  - shared_preferences: ^2.2.2 for settings persistence

### Changed
- 📖 Updated README.md to V1.1 with new features
- 🔧 Enhanced BookForm with validation and API integration
- 🎯 Updated InputBox widget to support validation
- 🧭 Updated NavigationFrame to include Settings page
- 🚀 Modified main.dart to integrate Provider and theme support
- 📁 Reorganized project structure with new directories (config, services, utils, themes)

### Enhanced
- 📋 Book form now includes full validation and error handling
- 🔄 API calls now have retry capability and better error messages
- 💾 All user preferences are now persisted locally
- 🎨 UI is now themeable with multiple professional options

## [V1.0] - 2025-11-01

### Added - Initial Release
- ✨ **GitHub Actions Workflow**: Manual build workflow for Web, Linux, macOS, and Windows platforms
- 📚 **Comprehensive Documentation**:
  - Complete README.md with setup, development, and deployment guides
  - QUICKSTART.md for fast onboarding (5-minute setup)
  - DEPLOYMENT.md with detailed deployment instructions
  - CONTRIBUTING.md with development guidelines
- 🛠️ **Setup Scripts**:
  - `scripts/setup.sh` for Linux/macOS automated setup
  - `scripts/setup.bat` for Windows automated setup
- 📝 **Code Documentation**:
  - Added detailed comments to main.dart
  - Added comments to home_page.dart
  - Documented student information in code
- 🎯 **Project Metadata**:
  - Updated pubspec.yaml with project description and student info
  - Created CHANGELOG.md for version tracking
- 🐛 **Issue Templates**:
  - Bug report template
  - Feature request template
- 📦 **Build Automation**:
  - Multi-platform build support via GitHub Actions
  - Artifact upload with 30-day retention
  - Platform-specific build configurations

### Changed
- 📖 README.md completely rewritten with comprehensive guides
- 💬 Added student information (HE HUALIANG - 230263367) throughout project

### Student Information
- **Name:** HE HUALIANG
- **Student ID:** 230263367
- **Course:** EEE 4482 - Server Installation and Programming

---

## Version History Summary

| Version | Date       | Description                                                    |
|---------|------------|----------------------------------------------------------------|
| V1.1    | 2025-11-02 | API calls, proxy support, validation, and multiple UI themes   |
| V1.0    | 2025-11-01 | Initial release with CI/CD and documentation                   |

---

## How to Update This Changelog

When making changes to the project:

1. Add an entry under the appropriate version section
2. Use categories: Added, Changed, Deprecated, Removed, Fixed, Security
3. Increment version number in README.md
4. Update the Version History Summary table
5. Commit with message: "Release vX.X - Brief description"

### Categories Explained

- **Added**: New features or functionality
- **Changed**: Changes to existing functionality
- **Deprecated**: Features that will be removed in future versions
- **Removed**: Features that have been removed
- **Fixed**: Bug fixes
- **Security**: Security vulnerability fixes

---

**Maintained by:** HE HUALIANG (230263367)  
**Last Updated:** 2025-11-02
