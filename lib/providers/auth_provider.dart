/// Authentication Provider
/// Manages user authentication state and operations
/// Student: HE HUALIANG (230263367)

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  /// Load authentication state from storage
  Future<void> _loadAuthState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      _rememberMe = prefs.getBool(_rememberMeKey) ?? false;
      
      if (_rememberMe) {
        _authToken = prefs.getString(_authTokenKey);
        final userData = prefs.getString(_userDataKey);
        
        if (_authToken != null && userData != null) {
          // TODO: Validate token with backend
          _isAuthenticated = true;
          // TODO: Parse user data from JSON
          _currentUser = {
            'username': 'demo_user',
            'email': 'demo@example.com',
            'role': 'user',
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
      // TODO: Call backend API for authentication
      // For now, simulate login
      await Future.delayed(const Duration(seconds: 1));
      
      // Simulate successful login
      _isAuthenticated = true;
      _rememberMe = rememberMe;
      _authToken = 'demo_token_${DateTime.now().millisecondsSinceEpoch}';
      _currentUser = {
        'id': 1,
        'username': username,
        'email': '$username@example.com',
        'role': username == 'admin' ? 'admin' : 'user',
        'displayName': username,
      };
      
      // Save to storage if remember me
      if (_rememberMe) {
        await _saveAuthState();
      }
      
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
      // For now, simulate registration
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
          'message': 'Username can only contain letters, numbers, and underscores',
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
        return {
          'success': false,
          'message': 'Invalid email format',
        };
      }
      
      // Simulate successful registration
      return {
        'success': true,
        'message': 'Registration successful. Please check your email to activate your account.',
        'requiresVerification': true,
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
      
      // Clear storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_authTokenKey);
      await prefs.remove(_userDataKey);
      // Keep remember me preference
      
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
      return {
        'success': true,
        'message': 'Password changed successfully',
      };
    } catch (e) {
      debugPrint('Change password error: $e');
      return {
        'success': false,
        'message': 'Failed to change password: ${e.toString()}',
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
        // TODO: Serialize user data to JSON
        await prefs.setString(_userDataKey, _currentUser.toString());
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
