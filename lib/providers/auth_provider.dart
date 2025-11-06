/// Authentication Provider
/// Manages user authentication state and operations
/// Student: HE HUALIANG (230263367)

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';

/// Authentication state provider
class AuthProvider extends ChangeNotifier {
  // User state
  bool _isAuthenticated = false;
  Map<String, dynamic>? _currentUser;
  String? _authToken;
  bool _rememberMe = false;

  // Keys for SharedPreferences
  static const String _authTokenKey = 'auth_token';
  static const String _userDataKey = 'user_data';
  static const String _rememberMeKey = 'remember_me';

  AuthProvider() {
    _loadAuthState();
  }

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get currentUser => _currentUser;
  String? get authToken => _authToken;
  bool get rememberMe => _rememberMe;
  bool get isAdmin => _currentUser?['role'] == 'admin';

  Uri _buildUri(String path) {
    final base = ApiConfig.baseUrl?.trim() ?? '';
    if (base.isEmpty) {
      throw Exception('ApiConfig.baseUrl is empty. 请设置 ApiConfig.host');
    }
    final trimmedBase = base.replaceAll(RegExp(r'\/+$'), '');
    final trimmedPath = path.replaceAll(RegExp(r'^\/+'), '');
    final full = '$trimmedBase/$trimmedPath';
    return Uri.parse(full);
  }

  /// Load authentication state from storage
  Future<void> _loadAuthState() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      _rememberMe = prefs.getBool(_rememberMeKey) ?? false;
      _authToken = prefs.getString(_authTokenKey);
      final userDataStr = prefs.getString(_userDataKey);

      if (_authToken != null && userDataStr != null) {
        // Parse user data (simple format: username|email|role|displayName)
        final parts = userDataStr.split('|');
        if (parts.length >= 4) {
          _isAuthenticated = true;
          _currentUser = {
            'id': int.tryParse(parts[0]) ?? 1,
            'username': parts[1],
            'email': parts[2],
            'role': parts[3],
            'displayName': parts.length > 4 ? parts[4] : parts[1],
          };
        }
      }

      notifyListeners();
    } catch (e) {
      // Handle error silently
      debugPrint('Error loading auth state: $e');
    }
  }

  /// Login user
  Future<bool> login(String username, String password, bool rememberMe) async {
    try {
      // For now, simulate login with validation
      // await Future.delayed(const Duration(seconds: 1));
      // Call backend API
      final path = '/auth/login';
      final uri = _buildUri(path);
      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'username': username, 'password': password}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['token'] as String?;
        // final user = data['user'] as Map<String, dynamic>?;

        if (token == null) {
          // || user == null) {
          return false;
        }

        _isAuthenticated = true;
        _rememberMe = rememberMe;
        _authToken = token; //jwt is here
        final user = data;
        _currentUser = {
          'id': user['user_id'] ?? 1,
          'username': user['username'] ?? username,
          'email': user['email'] ?? '$username@placeholder.com',
          'is_admin': user['is_admin'] ?? false,
          'last_login': user['last_login'] ?? null,
        };

        await _saveAuthState();
        notifyListeners();
        return true;
      } else {
        // if not 200, login failed
        debugPrint('Login failed: ${response.statusCode} ${response.body}');
        return false;
      }

      // Below is the simulated login logic without backend API call will not execute

      // Simulate backend validation - check if user exists in "registered users"
      final prefs = await SharedPreferences.getInstance();
      final registeredUsers = prefs.getStringList('registered_users') ?? [];

      // Check if username exists and password matches (in real app, this is done by backend)
      bool userFound = false;
      String? userEmail;
      String? userRole;

      for (final userStr in registeredUsers) {
        final parts = userStr.split('|');
        if (parts.length >= 3 && parts[0] == username) {
          // Simple password check (in real app, use hashed passwords)
          if (parts[2] == password) {
            userFound = true;
            userEmail = parts[1];
            userRole = parts.length > 3 ? parts[3] : 'user';
            break;
          }
        }
      }

      // Also allow default admin login
      if (username == 'admin' && password == 'Admin@123') {
        userFound = true;
        userEmail = 'admin@elibrary.local';
        userRole = 'admin';
      }

      if (!userFound) {
        return false;
      }

      // Successful login
      _isAuthenticated = true;
      _rememberMe = rememberMe;
      _authToken = 'token_${DateTime.now().millisecondsSinceEpoch}';
      _currentUser = {
        'id': 1,
        'username': username,
        'email': userEmail ?? '$username@example.com',
        'role': userRole ?? 'user',
        'displayName': username,
      };

      // Always save to storage for session persistence
      await _saveAuthState();

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }

  /// Register new user
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      // TODO: Call backend API for registration
      // For now, simulate registration with local storage
      await Future.delayed(const Duration(seconds: 1));

      // Validate username
      if (username.length < 6) {
        return {
          'success': false,
          'message': 'Username must be at least 6 characters',
        };
      }

      // Check for special symbols (only alphanumeric and underscore allowed)
      if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username)) {
        return {
          'success': false,
          'message':
              'Username can only contain letters, numbers, and underscores',
        };
      }

      // Validate password
      if (password.length < 8) {
        return {
          'success': false,
          'message': 'Password must be at least 8 characters',
        };
      }

      // Check for mixed types (letters and numbers)
      if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(password)) {
        return {
          'success': false,
          'message': 'Password must contain both letters and numbers',
        };
      }

      // Validate email
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        return {'success': false, 'message': 'Invalid email format'};
      }

      // Check if username already exists
      final prefs = await SharedPreferences.getInstance();
      final registeredUsers = prefs.getStringList('registered_users') ?? [];

      for (final userStr in registeredUsers) {
        final parts = userStr.split('|');
        if (parts.isNotEmpty && parts[0] == username) {
          return {'success': false, 'message': 'Username already exists'};
        }
      }

      // Store user data (format: username|email|password|role)
      registeredUsers.add('$username|$email|$password|user');
      await prefs.setStringList('registered_users', registeredUsers);

      // Simulate successful registration
      return {
        'success': true,
        'message': 'Registration successful. You can now login.',
        'requiresVerification': false,
      };
    } catch (e) {
      debugPrint('Registration error: $e');
      return {
        'success': false,
        'message': 'Registration failed: ${e.toString()}',
      };
    }
  }

  /// Verify email with token
  Future<bool> verifyEmail(String token) async {
    try {
      // TODO: Call backend API for email verification
      await Future.delayed(const Duration(seconds: 1));

      // Simulate successful verification
      return true;
    } catch (e) {
      debugPrint('Email verification error: $e');
      return false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      _isAuthenticated = false;
      _currentUser = null;
      _authToken = null;
      _rememberMe = false;

      // Clear storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_authTokenKey);
      await prefs.remove(_userDataKey);
      await prefs.setBool(_rememberMeKey, false);

      notifyListeners();
    } catch (e) {
      debugPrint('Logout error: $e');
    }
  }

  /// Change password
  Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    if (!_isAuthenticated) {
      return {
        'success': false,
        'message': 'You must be logged in to change password',
      };
    }

    try {
      // Validate new password
      if (newPassword.length < 8) {
        return {
          'success': false,
          'message': 'Password must be at least 8 characters',
        };
      }

      if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(newPassword)) {
        return {
          'success': false,
          'message': 'Password must contain both letters and numbers',
        };
      }

      // TODO: Call backend API to change password
      await Future.delayed(const Duration(seconds: 1));

      // Simulate successful password change
      return {'success': true, 'message': 'Password changed successfully'};
    } catch (e) {
      debugPrint('Change password error: $e');
      return {
        'success': false,
        'message': 'Failed to change password: ${e.toString()}',
      };
    }
  }

  /// Request password reset by username or email
  /// Returns: {'success': bool, 'message': String}
  Future<Map<String, dynamic>> requestPasswordReset(String identifier) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Validate input
      if (identifier.isEmpty) {
        return {'success': false, 'message': 'Please enter username or email'};
      }

      // Get registered users from storage
      final prefs = await SharedPreferences.getInstance();
      final registeredUsers = prefs.getStringList('registered_users') ?? [];

      // Search for user by username or email
      String? foundUserEmail;
      String? foundUsername;
      for (final userStr in registeredUsers) {
        final parts = userStr.split('|');
        if (parts.length >= 2) {
          final username = parts[0];
          final email = parts[1];

          // Check if identifier matches username or email
          if (username.toLowerCase() == identifier.toLowerCase() ||
              email.toLowerCase() == identifier.toLowerCase()) {
            foundUserEmail = email;
            foundUsername = username;
            break;
          }
        }
      }

      // Also check for admin user
      if (foundUserEmail == null) {
        if (identifier.toLowerCase() == 'admin' ||
            identifier.toLowerCase() == 'admin@elibrary.local') {
          foundUserEmail = 'admin@elibrary.local';
          foundUsername = 'admin';
        }
      }

      // foundUserEmail = 'test';

      // User not found
      if (foundUserEmail == null) {
        return {
          'success': false,
          'message':
              'No account found with the username or email: "$identifier"',
        };
      }

      // TODO: Call backend API to send password reset email
      // Example API endpoint: POST /api/auth/forgot-password
      // Request body: { "username_or_email": identifier }
      // Response: { "success": true, "message": "Reset email sent" }

      // Simulate successful password reset request
      return {
        'success': true,
        'message':
            'Password reset link has been sent to $foundUserEmail. '
            'Please check your inbox and follow the instructions to reset your password.',
        'email': foundUserEmail,
        'username': foundUsername,
      };
    } catch (e) {
      debugPrint('Error requesting password reset: $e');
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  /// Helper method to find user by username or email
  Future<Map<String, dynamic>?> findUserByIdentifier(String identifier) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final registeredUsers = prefs.getStringList('registered_users') ?? [];

      for (final userStr in registeredUsers) {
        final parts = userStr.split('|');
        if (parts.length >= 2) {
          final username = parts[0];
          final email = parts[1];

          if (username.toLowerCase() == identifier.toLowerCase() ||
              email.toLowerCase() == identifier.toLowerCase()) {
            return {
              'id': registeredUsers.indexOf(userStr),
              'username': username,
              'email': email,
              'role': parts.length > 3 ? parts[3] : 'user',
            };
          }
        }
      }

      // Check admin user
      if (identifier.toLowerCase() == 'admin' ||
          identifier.toLowerCase() == 'admin@elibrary.local') {
        return {
          'id': 0,
          'username': 'admin',
          'email': 'admin@elibrary.local',
          'role': 'admin',
        };
      }

      return null;
    } catch (e) {
      debugPrint('Error finding user: $e');
      return null;
    }
  }

  /// Save authentication state to storage
  Future<void> _saveAuthState() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (_authToken != null) {
        await prefs.setString(_authTokenKey, _authToken!);
      }

      if (_currentUser != null) {
        // Serialize user data (simple format: id|username|email|role|displayName)
        final userData =
            '${_currentUser!['id']}|${_currentUser!['username']}|${_currentUser!['email']}|${_currentUser!['role']}|${_currentUser!['displayName']}';
        await prefs.setString(_userDataKey, userData);
      }

      await prefs.setBool(_rememberMeKey, _rememberMe);
    } catch (e) {
      debugPrint('Error saving auth state: $e');
    }
  }

  /// Update remember me preference
  Future<void> setRememberMe(bool value) async {
    _rememberMe = value;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_rememberMeKey, value);

      if (!value) {
        // Clear stored auth data if remember me is disabled
        await prefs.remove(_authTokenKey);
        await prefs.remove(_userDataKey);
      } else if (_isAuthenticated) {
        // Save current auth data if remember me is enabled
        await _saveAuthState();
      }
    } catch (e) {
      debugPrint('Error updating remember me: $e');
    }

    notifyListeners();
  }
}

extension on Uri {
  operator +(Uri other) {}
}
