/// User Provider
/// Manages user-related operations with backend API integration and JWT authentication
/// Student: HE HUALIANG (230263367)

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';

/// User Provider for managing users state and operations
class UserProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Map<String, dynamic>> get users => _users;
  bool get isLoading => _isLoading;
  String? get error => _error;

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

  /// Fetch all users from the backend API (admin only)
  Future<bool> getAllUsers() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      Future.delayed(const Duration(seconds: 5), () {
        if (_isLoading) {
          _isLoading = false;
          notifyListeners();
        }
      });

      final path = '/user/all';
      final uri = _buildUri(path);
      final response = await http
          .get(uri, headers: ApiConfig.getAuthorizationHeaders())
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          _users = List<Map<String, dynamic>>.from(data);
        } else {
          _users = [];
        }
        _isLoading = false;
        notifyListeners();
        return true;
      } else if (response.statusCode == 403) {
        _error = 'You do not have permission to view users';
        _isLoading = false;
        notifyListeners();
        return false;
      } else {
        _error = 'Failed to fetch users: ${response.statusCode}';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Error fetching users: $e';
      _isLoading = false;
      debugPrint('Get all users error: $e');
      notifyListeners();
      return false;
    }
  }

  /// Add a new user (registration or admin add)
  Future<bool> addUser(Map<String, dynamic> userData) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      Future.delayed(const Duration(seconds: 5), () {
        if (_isLoading) {
          _isLoading = false;
          notifyListeners();
        }
      });

      final path = '/user/add';
      final uri = _buildUri(path);
      final response = await http
          .post(
            uri,
            headers: ApiConfig.getAuthorizationHeaders(),
            body: json.encode(userData),
          )
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        _isLoading = false;
        notifyListeners();
        await getAllUsers();
        return true;
      } else {
        final errorData = json.decode(response.body);
        _error = errorData['message'] ?? 'Failed to add user';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Error adding user: $e';
      _isLoading = false;
      debugPrint('Add user error: $e');
      notifyListeners();
      return false;
    }
  }

  /// Update user profile
  Future<bool> updateUser(int userId, Map<String, dynamic> userData) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      Future.delayed(const Duration(seconds: 5), () {
        if (_isLoading) {
          _isLoading = false;
          notifyListeners();
        }
      });
      final path = '/user/update/$userId';
      final uri = _buildUri(path);
      final response = await http
          .put(
            uri,
            headers: ApiConfig.getAuthorizationHeaders(),
            body: json.encode(userData),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        _isLoading = false;
        notifyListeners();
        await getAllUsers();
        return true;
      } else if (response.statusCode == 401) {
        _error = 'Password is incorrect';
        _isLoading = false;
        notifyListeners();
        return false;
      } else if (response.statusCode == 404) {
        _error = 'User not found';
        _isLoading = false;
        notifyListeners();
        return false;
      } else {
        final errorData = json.decode(response.body);
        _error = errorData['error'] ?? 'Failed to update user';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Error updating user: $e';
      _isLoading = false;
      debugPrint('Update user error: $e');
      notifyListeners();
      return false;
    }
  }

  /// Delete a user (admin only)
  Future<bool> deleteUser(
    int userId,
    String currentPassword,
    String targetUserIdentifier, {
    String identifierType = 'user_id', // 'user_id', 'email', or 'username'
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      Future.delayed(const Duration(seconds: 5), () {
        if (_isLoading) {
          _isLoading = false;
          notifyListeners();
        }
      });
      // final path = '/user/delete/$userId';
      final path = '/user/delete/$targetUserIdentifier';
      final uri = _buildUri(path);

      final body = <String, dynamic>{'password': currentPassword};

      if (identifierType == 'email') {
        body['email'] = targetUserIdentifier;
      } else if (identifierType == 'username') {
        body['username'] = targetUserIdentifier;
      } else {
        body['user_id_delete'] = targetUserIdentifier;
      }

      final response = await http
          .delete(
            uri,
            headers: ApiConfig.getAuthorizationHeaders(),
            body: json.encode(body),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        _isLoading = false;
        notifyListeners();
        await getAllUsers();
        return true;
      } else if (response.statusCode == 401) {
        _error = 'Password is incorrect';
        _isLoading = false;
        notifyListeners();
        return false;
      } else if (response.statusCode == 403) {
        _error = 'You do not have permission to delete users';
        _isLoading = false;
        notifyListeners();
        return false;
      } else if (response.statusCode == 404) {
        _error = 'User not found';
        _isLoading = false;
        notifyListeners();
        return false;
      } else {
        final errorData = json.decode(response.body);
        _error = errorData['message'] ?? 'Failed to delete user';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Error deleting user: $e';
      _isLoading = false;
      debugPrint('Delete user error: $e');
      notifyListeners();
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
