# API Calls, Proxy Support, and Input Validation Guide

**Student:** HE HUALIANG (230263367)  
**Course:** EEE 4482 - Server Installation and Programming  
**Version:** 1.1.0  
**Date:** 2025-11-02

---

## Table of Contents

1. [Overview](#overview)
2. [API Calls Implementation](#api-calls-implementation)
3. [Proxy Support](#proxy-support)
4. [Input Validation](#input-validation)
5. [UI Themes](#ui-themes)
6. [Configuration](#configuration)
7. [Best Practices](#best-practices)
8. [Troubleshooting](#troubleshooting)

---

## Overview

This guide provides comprehensive documentation for the enhanced e-Library application features including:

- **Robust API Call Logic**: Complete error handling, timeout settings, and authentication mechanisms
- **Proxy Support**: Dynamic proxy configuration for different network scenarios
- **Input Validation**: Comprehensive validation for all user-submitted data
- **Multiple UI Themes**: Support for GitHub High Contrast, JetBrains IDE, and Xcode themes

---

## API Calls Implementation

### Architecture

The application uses a layered architecture for API calls:

```
BookService → ApiService → HTTP Client
     ↓            ↓            ↓
  Business    Network    Transport
   Logic      Handling     Layer
```

### Key Components

#### 1. ApiConfig (`lib/config/api_config.dart`)

Manages API configuration including:
- Base URL
- Endpoints
- Timeout settings
- Authentication tokens
- Proxy configuration

```dart
// Example usage
ApiConfig.setAuthToken('your-token-here');
ApiConfig.setProxy(enabled: true, host: 'localhost', port: 8080);
```

#### 2. ApiService (`lib/services/api_service.dart`)

Provides low-level HTTP methods with comprehensive error handling:

**Features:**
- ✅ Timeout configuration (30 seconds default)
- ✅ Authentication header injection
- ✅ JSON request/response handling
- ✅ Comprehensive error handling
- ✅ Custom ApiException for error reporting

**Supported HTTP Methods:**
- `GET` - Retrieve data
- `POST` - Create new resources
- `PUT` - Update existing resources
- `DELETE` - Remove resources
- `PATCH` - Partial updates

**Error Handling:**
The service handles multiple error types:
- Network errors (no connection)
- Timeout errors
- HTTP status errors (4xx, 5xx)
- JSON parsing errors
- Server-side errors

```dart
// Example: Handling errors
try {
  final data = await ApiService.get('/books');
} on ApiException catch (e) {
  print('Error: ${e.message}');
  print('Status: ${e.statusCode}');
}
```

#### 3. BookService (`lib/services/book_service.dart`)

High-level service for book operations:

**Methods:**
- `getAllBooks()` - Fetch all books
- `getBookById(id)` - Get single book
- `addBook(data)` - Create new book
- `updateBook(id, data)` - Update book
- `deleteBook(id)` - Remove book
- `searchBooks(query)` - Search books

```dart
// Example usage
try {
  final books = await BookService.getAllBooks();
  print('Found ${books.length} books');
} on ApiException catch (e) {
  print('Failed to load books: ${e.message}');
}
```

### Authentication

The application supports Bearer token authentication:

```dart
// Set authentication token
ApiConfig.setAuthToken('your-jwt-token');

// All subsequent API calls will include:
// Authorization: Bearer your-jwt-token
```

### Timeout Configuration

Configurable timeout settings prevent hanging requests:

```dart
// Default: 30 seconds
// To modify, update ApiConfig.connectionTimeout
```

---

## Proxy Support

### Overview

The application supports proxy configuration for different network scenarios:

- **Development Proxy**: For CORS bypass during development
- **Corporate Proxy**: For enterprise networks requiring proxy
- **Dynamic Configuration**: Change proxy settings at runtime

**Important Note**: The current implementation provides proxy configuration UI and settings persistence. However, Flutter's standard `http` package has limited proxy support. For production use with proxy:
- **Web**: Proxy is automatically handled by the browser
- **Desktop/Mobile**: System-level proxy settings are used
- **Advanced scenarios**: Consider using packages like `dio` which have better proxy support

The proxy settings are stored and can be used by custom HTTP client implementations.

### Configuration

#### Via Settings UI

1. Navigate to Settings page (gear icon in navigation)
2. Enable "Use Proxy" toggle
3. Enter proxy host and port
4. Click "Save Settings"

#### Programmatically

```dart
ApiConfig.setProxy(
  enabled: true,
  host: 'localhost',
  port: 8080,
);
```

#### Via SettingsProvider

```dart
final settingsProvider = Provider.of<SettingsProvider>(context);
await settingsProvider.setProxyConfig(
  enabled: true,
  host: 'proxy.example.com',
  port: 3128,
);
```

### Use Cases

#### 1. Development CORS Proxy

When developing locally and the backend doesn't support CORS:

```dart
// Enable proxy
ApiConfig.setProxy(enabled: true, host: 'localhost', port: 8080);

// Run a CORS proxy server (e.g., cors-anywhere)
// node cors-proxy.js
```

#### 2. Corporate Network Proxy

For networks requiring HTTP proxy:

```dart
ApiConfig.setProxy(
  enabled: true,
  host: 'proxy.company.com',
  port: 8080,
);
```

#### 3. Testing Multiple Servers

Switch between different API servers:

```dart
// Development server
settingsProvider.setApiBaseUrl('http://localhost:3000/api');

// Staging server
settingsProvider.setApiBaseUrl('http://staging.example.com/api');

// Production server
settingsProvider.setApiBaseUrl('https://api.example.com');
```

### Persistence

Proxy settings are automatically saved to SharedPreferences and persist across app restarts.

---

## Input Validation

### Overview

Comprehensive validation ensures data integrity at both frontend and backend levels.

### Validation Utilities

Located in `lib/utils/validators.dart`, providing:

#### Basic Validators

- `required()` - Check if field is not empty
- `length()` - Validate string length (min/max)
- `email()` - Email format validation
- `number()` - Numeric validation
- `integer()` - Integer validation
- `range()` - Number range validation

#### Format Validators

- `isbn()` - ISBN-10 or ISBN-13 format
- `date()` - Date format (YYYY-MM-DD)
- `url()` - URL format
- `phone()` - Phone number format
- `alphabetic()` - Letters only
- `alphanumeric()` - Letters and numbers
- `pattern()` - Custom regex pattern

#### Composite Validators

Pre-configured validators for common use cases:

- `bookTitle()` - Title validation (required, 1-200 chars)
- `authorName()` - Author validation (required, 2-100 chars)
- `publisherName()` - Publisher validation (required, 2-100 chars)
- `publicationDate()` - Date validation (required, valid date)
- `isbnRequired()` - ISBN validation (required, valid format)

### Usage Examples

#### Single Validator

```dart
TextField(
  controller: titleController,
  decoration: InputDecoration(labelText: 'Title'),
  validator: Validators.bookTitle,
)
```

#### Multiple Validators

```dart
validator: (value) => Validators.combine(value, [
  (v) => Validators.required(v, fieldName: 'Email'),
  (v) => Validators.email(v),
])
```

#### Custom Validator

```dart
validator: (value) => Validators.pattern(
  value,
  RegExp(r'^[A-Z]{3}-\d{4}$'),
  errorMessage: 'Format must be ABC-1234',
)
```

### Validation Rules

#### Book Title
- **Required**: Yes
- **Min Length**: 1 character
- **Max Length**: 200 characters
- **Error Messages**: 
  - "Title is required"
  - "Title must be at least 1 characters"
  - "Title must not exceed 200 characters"

#### Author Name
- **Required**: Yes
- **Min Length**: 2 characters
- **Max Length**: 100 characters
- **Format**: Any characters allowed

#### Publisher Name
- **Required**: Yes
- **Min Length**: 2 characters
- **Max Length**: 100 characters

#### Publication Date
- **Required**: Yes
- **Format**: YYYY-MM-DD
- **Constraint**: Cannot be in the future
- **Examples**: 
  - Valid: "2023-01-15", "1996-06-26"
  - Invalid: "2030-01-01", "26/06/1996"

#### ISBN
- **Required**: Yes
- **Formats**: 
  - ISBN-10: 10 digits (last can be X)
  - ISBN-13: 13 digits
- **Examples**:
  - Valid: "978-3-16-148410-0", "0-306-40615-2"
  - Invalid: "123", "invalid-isbn"

### Real-time Validation

The InputBox widget provides real-time validation:

```dart
InputBox(
  name: 'Email',
  hint: 'Enter email address',
  controller: emailController,
  validator: Validators.email,
)
```

Validation triggers:
- ✅ On form submission
- ✅ On field blur (after first error)
- ✅ On text change (after first error)

---

## UI Themes

### Available Themes

The application supports four distinct UI themes:

#### 1. Default Theme
- **Style**: Material Design 3
- **Colors**: Warm gold/beige color scheme
- **Use Case**: General purpose, balanced aesthetics

#### 2. GitHub High Contrast Theme
- **Style**: Dark theme with high contrast
- **Colors**: 
  - Background: #0D1117 (GitHub dark)
  - Primary: #0969DA (GitHub blue)
  - Accent: #58A6FF
  - Success: #3FB950
- **Use Case**: Low-light environments, accessibility
- **Features**: High contrast for better readability

#### 3. JetBrains IDE Theme (IntelliJ)
- **Style**: Darcula theme
- **Colors**:
  - Background: #2B2B2B
  - Primary: #4B93E5 (IntelliJ blue)
  - Accent: #FFC66D (Yellow)
  - Success: #6A8759
- **Use Case**: Developers familiar with JetBrains IDEs
- **Features**: Professional developer aesthetic

#### 4. Xcode Theme
- **Style**: Light theme, macOS style
- **Colors**:
  - Background: #FFFFFF
  - Primary: #007AFF (iOS blue)
  - Accent: #5856D6 (Purple)
  - Success: #34C759
- **Use Case**: macOS developers, light environment
- **Features**: Clean, minimal Apple-style design

### Switching Themes

#### Via Settings Page

1. Navigate to Settings page
2. Find "Theme" section
3. Click desired theme chip
4. Theme applies immediately

#### Programmatically

```dart
final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
await themeProvider.setTheme(ThemeType.githubHighContrast);
```

### Theme Persistence

Selected theme is automatically saved and restored on app restart using SharedPreferences.

### Theme Components

Each theme customizes:
- ✅ Color scheme (primary, secondary, surface colors)
- ✅ Text colors and styles
- ✅ Input field appearance
- ✅ Button styles
- ✅ Card elevation and borders
- ✅ Navigation rail appearance
- ✅ Icon colors

---

## Configuration

### Application Settings

Settings are managed through the Settings page and persisted locally.

#### API Configuration

**Base URL**: The root URL for API endpoints
- Default: `http://192.168.1.100/api/public`
- Editable: Yes
- Location: Settings page

**Endpoints**: Defined in `ApiConfig`
- GET /books - List all books
- POST /books/add - Add new book
- PUT /books/update/:id - Update book
- DELETE /books/delete/:id - Delete book

#### Network Configuration

**Connection Timeout**: 30 seconds
**Receive Timeout**: 30 seconds

#### Proxy Configuration

**Enable/Disable**: Toggle in Settings
**Host**: Proxy server hostname or IP
**Port**: Proxy server port (1-65535)

### Environment-Specific Configuration

For different environments, update `ApiConfig`:

```dart
// Development
ApiConfig.baseUrl = 'http://localhost:3000/api';

// Staging
ApiConfig.baseUrl = 'http://staging.example.com/api';

// Production
ApiConfig.baseUrl = 'https://api.example.com';
```

---

## Best Practices

### API Calls

1. **Always Handle Errors**
   ```dart
   try {
     final data = await ApiService.get('/endpoint');
   } on ApiException catch (e) {
     // Handle API errors
   } catch (e) {
     // Handle unexpected errors
   }
   ```

2. **Use Loading States**
   ```dart
   setState(() { _isLoading = true; });
   try {
     await ApiService.post('/endpoint', body: data);
   } finally {
     setState(() { _isLoading = false; });
   }
   ```

3. **Provide User Feedback**
   ```dart
   ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(content: Text('Success!')),
   );
   ```

### Input Validation

1. **Validate Early**: Use real-time validation for better UX
2. **Clear Error Messages**: Be specific about what's wrong
3. **Frontend + Backend**: Always validate on both sides
4. **Sanitize Input**: Clean data before sending to API

### Proxy Usage

1. **Development Only**: Use CORS proxy only in development
2. **Secure Configuration**: Never commit proxy credentials
3. **Test Without Proxy**: Ensure app works without proxy
4. **Document Requirements**: Note when proxy is needed

### Theme Implementation

1. **Consistent Design**: Follow each theme's design language
2. **Accessibility**: Ensure adequate contrast ratios
3. **Test All Themes**: Verify UI works with all themes
4. **Respect User Choice**: Save and restore theme preference

---

## Troubleshooting

### API Connection Issues

**Problem**: "Network error: Unable to connect to server"

**Solutions**:
1. Check if API server is running
2. Verify base URL in Settings
3. Check network connectivity
4. Try disabling proxy if enabled
5. Check firewall settings

### CORS Errors (Web)

**Problem**: "CORS policy: No 'Access-Control-Allow-Origin' header"

**Solutions**:
1. Enable proxy in Settings
2. Configure backend CORS headers
3. Use same domain for frontend and backend
4. Run development proxy server

### Validation Not Working

**Problem**: Form submits with invalid data

**Solutions**:
1. Ensure Form widget wraps inputs
2. Check validator is assigned to field
3. Call `_formKey.currentState?.validate()`
4. Verify validators return String? (null for valid)

### Theme Not Persisting

**Problem**: Theme resets on app restart

**Solutions**:
1. Check SharedPreferences permissions
2. Verify ThemeProvider initialization
3. Check for errors in console
4. Try clearing app data and restarting

### Proxy Not Working

**Problem**: Requests still fail with proxy enabled

**Solutions**:
1. Verify proxy server is running
2. Check proxy host and port are correct
3. Test proxy with curl or Postman
4. Check proxy server supports HTTP/HTTPS
5. Review proxy server logs

---

## Code Examples

### Complete API Call Flow

```dart
import 'package:flutter/material.dart';
import '../services/book_service.dart';
import '../services/api_service.dart';

class BookListExample extends StatefulWidget {
  @override
  _BookListExampleState createState() => _BookListExampleState();
}

class _BookListExampleState extends State<BookListExample> {
  List<Map<String, dynamic>> _books = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final books = await BookService.getAllBooks();
      setState(() {
        _books = books;
        _isLoading = false;
      });
    } on ApiException catch (e) {
      setState(() {
        _error = e.message;
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_error'),
            ElevatedButton(
              onPressed: _loadBooks,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _books.length,
      itemBuilder: (context, index) {
        final book = _books[index];
        return ListTile(
          title: Text(book['title']),
          subtitle: Text(book['author']),
        );
      },
    );
  }
}
```

### Complete Form with Validation

```dart
import 'package:flutter/material.dart';
import '../widgets/input_box.dart';
import '../utils/validators.dart';
import '../services/book_service.dart';

class AddBookExample extends StatefulWidget {
  @override
  _AddBookExampleState createState() => _AddBookExampleState();
}

class _AddBookExampleState extends State<AddBookExample> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _isbnController = TextEditingController();
  
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() { _isLoading = true; });

    try {
      await BookService.addBook({
        'title': _titleController.text,
        'author': _authorController.text,
        'isbn': _isbnController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Book added successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear form
      _titleController.clear();
      _authorController.clear();
      _isbnController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          InputBox(
            name: 'Title',
            hint: 'Enter book title',
            controller: _titleController,
            validator: Validators.bookTitle,
          ),
          InputBox(
            name: 'Author',
            hint: 'Enter author name',
            controller: _authorController,
            validator: Validators.authorName,
          ),
          InputBox(
            name: 'ISBN',
            hint: 'Enter ISBN',
            controller: _isbnController,
            validator: Validators.isbnRequired,
          ),
          ElevatedButton(
            onPressed: _isLoading ? null : _submit,
            child: _isLoading
                ? CircularProgressIndicator()
                : Text('Add Book'),
          ),
        ],
      ),
    );
  }
}
```

---

## Additional Resources

### Documentation
- Flutter HTTP Package: https://pub.dev/packages/http
- Provider Package: https://pub.dev/packages/provider
- SharedPreferences: https://pub.dev/packages/shared_preferences

### Related Files
- `lib/config/api_config.dart` - API configuration
- `lib/services/api_service.dart` - HTTP service
- `lib/services/book_service.dart` - Book operations
- `lib/utils/validators.dart` - Input validation
- `lib/themes/app_themes.dart` - Theme definitions
- `lib/themes/theme_provider.dart` - Theme management

---

**Document Version:** 1.1.0  
**Last Updated:** 2025-11-02  
**Student:** HE HUALIANG (230263367)
