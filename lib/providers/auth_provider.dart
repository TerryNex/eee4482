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
  bool get isAdmin => _currentUser?['is_admin'] == true;

  Uri _buildUri(String path) {
    final base = ApiConfig.baseUrl.trim();
    if (base.isEmpty) {
      throw Exception('ApiConfig.baseUrl is empty');
    }
    final trimmedBase = base.replaceAll(RegExp(r'/+$'), '');
    final trimmedPath = path.replaceAll(RegExp(r'^/+'), '');
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
            'is_admin': parts[3] == 'admin',
            'displayName': parts.length > 4 ? parts[4] : parts[1],
          };
          // Important: Set the token in ApiConfig so API calls work after page refresh
          ApiConfig.setAuthToken(_authToken);
        }
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading auth state: $e');
    }
  }

  /// Login user
  Future<bool> login(String username, String password, bool rememberMe) async {
    try {
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

        if (token == null) {
          return false;
        }

        _isAuthenticated = true;
        _rememberMe = rememberMe;
        _authToken = token; // JWT token from backend

        _currentUser = {
          'id': data['user_id'] ?? 1,
          'username': data['username'] ?? username,
          'email': data['email'] ?? '$username@placeholder.com',
          'is_admin': data['is_admin'] == 1 || data['is_admin'] == true,
          'last_login': data['last_login'],
        };

        // Update API config with the token
        ApiConfig.setAuthToken(token);

        await _saveAuthState();
        notifyListeners();
        return true;
      } else {
        debugPrint('Login failed: ${response.statusCode} ${response.body}');
        return false;
      }
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
      if (!RegExp(r'^\w+[-.\w]*@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        return {'success': false, 'message': 'Invalid email format'};
      }

      // Call backend API for registration
      final path = '/auth/register';
      final uri = _buildUri(path);
      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'username': username,
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Registration successful. You can now login.',
          'requiresVerification': false,
        };
      } else if (response.statusCode == 500) {
        final data = json.decode(response.body);
        final message = data['message'] ?? 'Registration failed';
        return {'success': false, 'message': message};
      } else {
        return {
          'success': false,
          'message': 'Registration failed: ${response.statusCode}',
        };
      }
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
      final path = '/auth/verify-email';
      final uri = _buildUri(path);
      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'token': token}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return true;
      } else {
        debugPrint('Email verification failed: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('Email verification error: $e');
      return false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      // Call backend API to logout (requires JWT)
      if (_authToken != null) {
        final path = '/auth/logout';
        final uri = _buildUri(path);
        try {
          await http
              .post(
                uri,
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer $_authToken',
                },
              )
              .timeout(const Duration(seconds: 10));
        } catch (e) {
          debugPrint('Logout API call failed: $e');
        }
      }

      _isAuthenticated = false;
      _currentUser = null;
      _authToken = null;
      _rememberMe = false;

      // Clear API token
      ApiConfig.setAuthToken(null);

      // Clear storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_authTokenKey);
      await prefs.remove(_userDataKey);
      await prefs.setBool(_rememberMeKey, false);

      notifyListeners();
    } catch (e) {
      debugPrint('Logout error: $e');
      // Still clear local state even if API call fails
      _isAuthenticated = false;
      _currentUser = null;
      _authToken = null;
      _rememberMe = false;
      notifyListeners();
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

      // Call backend API to change password
      final userId = _currentUser?['id'] ?? 1;
      final path = '/user/update/$userId';
      final uri = _buildUri(path);
      final response = await http
          .put(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_authToken',
            },
            body: json.encode({
              'password': oldPassword,
              'new_password': newPassword,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Password changed successfully'};
      } else if (response.statusCode == 401) {
        return {'success': false, 'message': 'Current password is incorrect'};
      } else if (response.statusCode == 400) {
        final data = json.decode(response.body);
        return {
          'success': false,
          'message': data['error'] ?? 'Invalid password change request',
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to change password: ${response.statusCode}',
        };
      }
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
      // Validate input
      if (identifier.isEmpty) {
        return {'success': false, 'message': 'Please enter username or email'};
      }

      // Call backend API to request password reset
      final path = '/auth/forgot-password';
      final uri = _buildUri(path);
      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'username_or_email': identifier}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'message':
              'Password reset link has been sent to your email. '
              'Please check your inbox and follow the instructions to reset your password.',
          'email': data['email'] ?? identifier,
        };
      } else if (response.statusCode == 404) {
        return {
          'success': false,
          'message':
              'No account found with the username or email: "$identifier"',
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to request password reset: ${response.statusCode}',
        };
      }
    } catch (e) {
      debugPrint('Error requesting password reset: $e');
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
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
        final role = _currentUser!['is_admin'] == true ? 'admin' : 'user';
        final userData =
            '${_currentUser!['id']}|${_currentUser!['username']}|${_currentUser!['email']}|$role|${_currentUser!['displayName']}';
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
