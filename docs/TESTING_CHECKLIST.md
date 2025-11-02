# Testing and Verification Checklist

**Student:** HE HUALIANG (230263367)  
**Course:** EEE 4482 - Server Installation and Programming  
**Version:** 1.1.0  
**Date:** 2025-11-02

---

## Overview

This document provides a comprehensive checklist for testing all features implemented in V1.1 of the e-Library application.

---

## Pre-Testing Setup

### 1. Install Dependencies

```bash
cd /path/to/eee4482
flutter pub get
```

**Expected Output:**
```
Running "flutter pub get" in eee4482...
✓ All dependencies installed successfully
```

### 2. Verify Installation

```bash
flutter doctor -v
```

**Check For:**
- ✅ Flutter (Channel stable, 3.24.0 or later)
- ✅ Dart SDK version
- ✅ No blocking issues

### 3. Analyze Code

```bash
flutter analyze
```

**Expected Output:**
```
Analyzing eee4482...
No issues found!
```

---

## Feature Testing

### 1. API Service Testing

#### 1.1 API Configuration

**Test Steps:**
1. Open `lib/config/api_config.dart`
2. Verify default configuration:
   - Base URL is set
   - Timeout is 30 seconds
   - Endpoints are defined

**Expected:**
- ✅ Configuration loads without errors
- ✅ All endpoints are properly defined

#### 1.2 API Service Methods

**Test Steps:**
1. Review `lib/services/api_service.dart`
2. Check that all HTTP methods are implemented:
   - GET
   - POST
   - PUT
   - DELETE
   - PATCH

**Expected:**
- ✅ All methods include timeout handling
- ✅ All methods include error handling
- ✅ Headers are properly set

#### 1.3 Error Handling

**Test Scenarios:**

| Scenario | Expected Behavior |
|----------|-------------------|
| Network error | ApiException with "Unable to connect" message |
| Timeout | ApiException with "Request timeout" message |
| 404 Error | ApiException with status code 404 |
| 500 Error | ApiException with server error message |
| Invalid JSON | ApiException with "Failed to parse" message |

**Test Code:**
```dart
try {
  await ApiService.get('/invalid-endpoint');
} on ApiException catch (e) {
  print('Error: ${e.message}');
  print('Status: ${e.statusCode}');
}
```

---

### 2. Proxy Support Testing

#### 2.1 Proxy Configuration

**Test Steps:**
1. Launch application
2. Navigate to Settings page
3. Enable "Use Proxy"
4. Enter:
   - Host: `localhost`
   - Port: `8080`
5. Click "Save Settings"

**Expected:**
- ✅ Settings save without error
- ✅ Success message appears
- ✅ Configuration persists after restart

#### 2.2 Proxy Functionality

**Test Steps:**
1. Set up a test proxy (e.g., mitmproxy, Charles Proxy)
2. Configure app to use proxy
3. Make an API call
4. Check proxy logs

**Expected:**
- ✅ Request goes through proxy
- ✅ Headers are preserved
- ✅ Response is received correctly

#### 2.3 Proxy Toggle

**Test Steps:**
1. Enable proxy
2. Make API call (should use proxy)
3. Disable proxy
4. Make API call (should bypass proxy)

**Expected:**
- ✅ Proxy can be enabled/disabled
- ✅ Changes take effect immediately
- ✅ State is saved

---

### 3. Input Validation Testing

#### 3.1 Book Title Validation

**Test Cases:**

| Input | Expected Result |
|-------|----------------|
| "" (empty) | ❌ "Title is required" |
| "A" | ✅ Valid |
| "A very long title..." (201 chars) | ❌ "Must not exceed 200 characters" |
| "Valid Title" | ✅ Valid |

**Test Steps:**
1. Navigate to Add Book page
2. Leave title empty, try to submit
3. Enter invalid data
4. Verify error messages

#### 3.2 Author Name Validation

**Test Cases:**

| Input | Expected Result |
|-------|----------------|
| "" (empty) | ❌ "Author is required" |
| "A" | ❌ "Must be at least 2 characters" |
| "John Doe" | ✅ Valid |
| (101 chars) | ❌ "Must not exceed 100 characters" |

#### 3.3 ISBN Validation

**Test Cases:**

| Input | Expected Result |
|-------|----------------|
| "" (empty) | ❌ "ISBN is required" |
| "123" | ❌ "ISBN must be 10 or 13 digits" |
| "978-3-16-148410-0" | ✅ Valid (ISBN-13) |
| "0-306-40615-2" | ✅ Valid (ISBN-10) |
| "invalid-isbn" | ❌ "Invalid ISBN format" |

#### 3.4 Date Validation

**Test Cases:**

| Input | Expected Result |
|-------|----------------|
| "" (empty) | ❌ "Publication date is required" |
| "2023-01-15" | ✅ Valid |
| "2030-01-01" | ❌ "Date cannot be in the future" |
| "01/15/2023" | ❌ "Invalid date format" |
| "invalid" | ❌ "Invalid date format" |

#### 3.5 Real-time Validation

**Test Steps:**
1. Open Add Book form
2. Type invalid ISBN
3. Tab out of field
4. Observe error message appears
5. Correct the ISBN
6. Observe error message disappears

**Expected:**
- ✅ Validation triggers on blur
- ✅ Error messages are clear
- ✅ Valid input clears errors

---

### 4. UI Themes Testing

#### 4.1 Theme Switching

**Test Steps for Each Theme:**

1. **Default Theme**
   - Go to Settings
   - Select "Default"
   - Verify warm gold colors appear
   - Check all pages (Home, Add Book, Book List, Settings)

2. **GitHub High Contrast**
   - Select "GitHub High Contrast"
   - Verify dark background (#0D1117)
   - Check blue accents (#0969DA)
   - Verify high contrast

3. **JetBrains IDE**
   - Select "JetBrains IDE"
   - Verify Darcula background (#2B2B2B)
   - Check blue/yellow accents
   - Verify IDE-like appearance

4. **Xcode**
   - Select "Xcode"
   - Verify white background
   - Check iOS blue (#007AFF)
   - Verify clean, minimal style

**Expected for All:**
- ✅ Theme applies immediately
- ✅ All UI elements update
- ✅ No visual glitches
- ✅ Text remains readable

#### 4.2 Theme Persistence

**Test Steps:**
1. Select "GitHub High Contrast"
2. Close application
3. Reopen application
4. Check theme

**Expected:**
- ✅ GitHub High Contrast is still active
- ✅ Theme persisted across restart

#### 4.3 Theme Consistency

**Test Steps:**
1. Select a theme
2. Navigate through all pages:
   - Home
   - Add Book
   - Book List
   - Settings

**Expected:**
- ✅ Theme is consistent across all pages
- ✅ No color mismatches
- ✅ All components styled correctly

---

### 5. Settings Page Testing

#### 5.1 API Configuration

**Test Steps:**
1. Go to Settings
2. Change API Base URL
3. Click "Save Settings"
4. Verify success message

**Expected:**
- ✅ URL can be changed
- ✅ Settings save successfully
- ✅ New URL is used for API calls

#### 5.2 Validation

**Test Cases:**

| Scenario | Expected Result |
|----------|----------------|
| Empty API URL | ❌ Error: "API URL cannot be empty" |
| Invalid proxy port (0) | ❌ Error: "Invalid proxy port" |
| Invalid proxy port (70000) | ❌ Error: "Invalid proxy port" |
| Proxy enabled but no host | ❌ Error: "Proxy host cannot be empty" |
| Valid inputs | ✅ Settings saved successfully |

#### 5.3 Reset to Defaults

**Test Steps:**
1. Change all settings:
   - API URL
   - Enable proxy
   - Change theme
2. Click "Reset to Defaults"
3. Confirm in dialog

**Expected:**
- ✅ Confirmation dialog appears
- ✅ All settings reset to defaults
- ✅ Success message appears
- ✅ UI reflects default settings

---

### 6. Book Form Testing

#### 6.1 Add Book

**Test Steps:**
1. Go to Add Book page
2. Fill in all fields:
   - Title: "Test Book"
   - Author: "John Doe"
   - Publisher: "Test Publisher"
   - Date: "2023-01-15"
   - ISBN: "978-3-16-148410-0"
3. Click "Add Book"

**Expected:**
- ✅ Loading indicator appears
- ✅ Success message: "Successfully added Test Book"
- ✅ Form clears after success
- ✅ No errors in console

#### 6.2 Validation Errors

**Test Steps:**
1. Leave all fields empty
2. Click "Add Book"

**Expected:**
- ✅ All fields show error messages
- ✅ Form doesn't submit
- ✅ First error field is focused

#### 6.3 Network Errors

**Test Scenarios:**

1. **No Network**
   - Disconnect network
   - Try to add book
   - Expected: "Unable to connect to server" error

2. **Timeout**
   - Simulate slow network
   - Expected: "Request timeout" error after 30s

3. **Server Error (500)**
   - Expected: Error message with status code

---

### 7. Navigation Testing

#### 7.1 Navigation Rail

**Test Steps:**
1. Click each navigation item:
   - Home
   - Add Book
   - Book List
   - Settings

**Expected:**
- ✅ Correct page loads
- ✅ Navigation rail shows active state
- ✅ Transition is smooth
- ✅ No errors

#### 7.2 Route Testing

**Test URLs (Web):**
```
/home
/add
/booklist
/settings
/
```

**Expected:**
- ✅ All routes load correctly
- ✅ Correct page displays
- ✅ URL updates in browser

---

### 8. State Management Testing

#### 8.1 Provider Integration

**Test Steps:**
1. Launch application
2. Check console for errors
3. Change theme
4. Change settings

**Expected:**
- ✅ No provider errors
- ✅ State updates propagate
- ✅ Widgets rebuild correctly

#### 8.2 Settings Persistence

**Test Steps:**
1. Change multiple settings
2. Close app
3. Reopen app
4. Verify settings

**Expected:**
- ✅ Theme persisted
- ✅ API URL persisted
- ✅ Proxy settings persisted

---

## Performance Testing

### 1. Theme Switching Performance

**Test:**
- Switch between themes rapidly
- Measure time for theme to apply

**Expected:**
- ✅ Theme switches in < 100ms
- ✅ No lag or freezing
- ✅ Smooth transition

### 2. API Call Performance

**Test:**
- Make multiple API calls
- Check response times

**Expected:**
- ✅ Responses within timeout
- ✅ No memory leaks
- ✅ Proper cleanup

### 3. Form Validation Performance

**Test:**
- Type rapidly in form fields
- Verify validation doesn't lag

**Expected:**
- ✅ Real-time validation is smooth
- ✅ No input delay
- ✅ Error messages appear promptly

---

## Cross-Platform Testing

### Web Testing

**Browsers to Test:**
- ✅ Chrome/Chromium
- ✅ Firefox
- ✅ Safari (macOS)
- ✅ Edge

**Test:**
1. Build: `flutter build web --release`
2. Serve: `cd build/web && python3 -m http.server 8000`
3. Open in each browser
4. Test all features

### Desktop Testing

**Platforms:**
- ✅ Linux (Ubuntu 20.04+)
- ✅ macOS (10.14+)
- ✅ Windows (10+)

**Test:**
1. Build for platform
2. Run executable
3. Test all features
4. Verify native look and feel

---

## Accessibility Testing

### 1. Keyboard Navigation

**Test Steps:**
1. Use Tab to navigate
2. Use Enter to activate buttons
3. Use Space to toggle switches

**Expected:**
- ✅ All interactive elements focusable
- ✅ Focus order is logical
- ✅ Focus indicator visible

### 2. Screen Reader Testing

**Test:**
1. Enable screen reader
2. Navigate application
3. Verify announcements

**Expected:**
- ✅ All text is announced
- ✅ Button labels are clear
- ✅ Error messages are announced

### 3. Color Contrast

**Test:**
1. Use contrast checker tool
2. Check all themes
3. Verify WCAG compliance

**Expected:**
- ✅ Text contrast ratio ≥ 4.5:1
- ✅ Interactive elements contrast ≥ 3:1
- ✅ GitHub High Contrast meets AAA

---

## Security Testing

### 1. Input Sanitization

**Test:**
- Try SQL injection in forms
- Try XSS in text fields
- Try path traversal

**Expected:**
- ✅ Inputs are sanitized
- ✅ No vulnerabilities
- ✅ Error handling prevents exploits

### 2. Authentication

**Test:**
- Set authentication token
- Make API calls
- Verify header

**Expected:**
- ✅ Token is included in requests
- ✅ Token format is correct
- ✅ Token is not logged

### 3. Data Storage

**Test:**
- Check stored preferences
- Verify no sensitive data

**Expected:**
- ✅ Only preferences stored
- ✅ No passwords or tokens stored
- ✅ Data is encrypted (if applicable)

---

## Bug Reporting Template

If you find an issue, report it using this template:

```markdown
### Bug Report

**Version:** V1.1  
**Platform:** [Web/Linux/macOS/Windows]  
**Browser:** [If Web]

**Description:**
Brief description of the issue

**Steps to Reproduce:**
1. Step 1
2. Step 2
3. Step 3

**Expected Behavior:**
What should happen

**Actual Behavior:**
What actually happens

**Screenshots:**
[If applicable]

**Console Errors:**
[Paste any errors]

**Additional Context:**
Any other relevant information
```

---

## Testing Summary Checklist

Use this checklist to track testing progress:

### Core Features
- [ ] API calls work correctly
- [ ] Error handling works
- [ ] Proxy configuration works
- [ ] Input validation works
- [ ] All themes display correctly
- [ ] Theme persistence works
- [ ] Settings page works
- [ ] Book form validation works
- [ ] Navigation works

### Quality Checks
- [ ] No console errors
- [ ] No memory leaks
- [ ] Performance is acceptable
- [ ] All documentation is accurate
- [ ] Code passes flutter analyze
- [ ] All dependencies installed

### Cross-Platform
- [ ] Web build works
- [ ] Linux build works (if tested)
- [ ] macOS build works (if tested)
- [ ] Windows build works (if tested)

### Accessibility
- [ ] Keyboard navigation works
- [ ] Screen reader compatible
- [ ] Color contrast acceptable

### Security
- [ ] No XSS vulnerabilities
- [ ] No SQL injection risks
- [ ] Authentication secure

---

## Conclusion

After completing this checklist:

1. Document any issues found
2. Verify all critical features work
3. Confirm app is ready for deployment
4. Update documentation if needed

---

**Testing Checklist Version:** 1.0  
**Last Updated:** 2025-11-02  
**Student:** HE HUALIANG (230263367)
