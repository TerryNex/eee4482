/// Favorite Provider
/// Manages user likes and favorites with backend API integration and JWT authentication
/// Student: HE HUALIANG (230263367)

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';

/// Favorite Provider for managing likes and favorites
class FavoriteProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _favoriteBooks = [];
  Set<int> _likedBookIds = {};
  Set<int> _favoriteBookIds = {};
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Map<String, dynamic>> get favoriteBooks => _favoriteBooks;
  Set<int> get likedBookIds => _likedBookIds;
  Set<int> get favoriteBookIds => _favoriteBookIds;
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

  /// Check if a book is liked by current user
  bool isBookLiked(int bookId) {
    return _likedBookIds.contains(bookId);
  }

  /// Check if a book is in favorites
  bool isBookFavorited(int bookId) {
    return _favoriteBookIds.contains(bookId);
  }

  /// Add a like to a book
  Future<bool> addLike(int bookId) async {
    try {
      _error = null;
      notifyListeners();

      final path = '/user/like';
      final uri = _buildUri(path);
      final response = await http
          .post(
            uri,
            headers: ApiConfig.getAuthorizationHeaders(),
            body: json.encode({'book_id': bookId}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        _likedBookIds.add(bookId);
        notifyListeners();
        return true;
      } else {
        final errorData = json.decode(response.body);
        _error = errorData['error'] ?? 'Failed to add like';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Error adding like: $e';
      debugPrint('Add like error: $e');
      notifyListeners();
      return false;
    }
  }

  /// Remove a like from a book
  Future<bool> removeLike(int bookId) async {
    try {
      _error = null;
      notifyListeners();

      final path = '/user/like';
      final uri = _buildUri(path);
      final response = await http
          .delete(
            uri,
            headers: ApiConfig.getAuthorizationHeaders(),
            body: json.encode({'book_id': bookId}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        _likedBookIds.remove(bookId);
        notifyListeners();
        return true;
      } else {
        final errorData = json.decode(response.body);
        _error = errorData['error'] ?? 'Failed to remove like';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Error removing like: $e';
      debugPrint('Remove like error: $e');
      notifyListeners();
      return false;
    }
  }

  /// Toggle like status for a book
  Future<bool> toggleLike(int bookId) async {
    if (isBookLiked(bookId)) {
      return removeLike(bookId);
    } else {
      return addLike(bookId);
    }
  }

  /// Add a book to favorites
  Future<bool> addFavorite(int bookId) async {
    try {
      _error = null;
      notifyListeners();

      final path = '/user/favorite';
      final uri = _buildUri(path);
      final response = await http
          .post(
            uri,
            headers: ApiConfig.getAuthorizationHeaders(),
            body: json.encode({'book_id': bookId}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        _favoriteBookIds.add(bookId);
        notifyListeners();
        return true;
      } else {
        final errorData = json.decode(response.body);
        _error = errorData['error'] ?? 'Failed to add to favorites';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Error adding to favorites: $e';
      debugPrint('Add favorite error: $e');
      notifyListeners();
      return false;
    }
  }

  /// Remove a book from favorites
  Future<bool> removeFavorite(int bookId) async {
    try {
      _error = null;
      notifyListeners();

      final path = '/user/favorite';
      final uri = _buildUri(path);
      final response = await http
          .delete(
            uri,
            headers: ApiConfig.getAuthorizationHeaders(),
            body: json.encode({'book_id': bookId}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        _favoriteBookIds.remove(bookId);
        notifyListeners();
        return true;
      } else {
        final errorData = json.decode(response.body);
        _error = errorData['error'] ?? 'Failed to remove from favorites';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Error removing from favorites: $e';
      debugPrint('Remove favorite error: $e');
      notifyListeners();
      return false;
    }
  }

  /// Toggle favorite status for a book
  Future<bool> toggleFavorite(int bookId) async {
    if (isBookFavorited(bookId)) {
      return removeFavorite(bookId);
    } else {
      return addFavorite(bookId);
    }
  }

  /// Get user's favorite books
  Future<bool> getUserFavorites(int userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final path = '/user/$userId/favorites';
      final uri = _buildUri(path);
      final response = await http
          .get(uri, headers: ApiConfig.getAuthorizationHeaders())
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          _favoriteBooks = List<Map<String, dynamic>>.from(data);
          // Update favorite IDs set
          _favoriteBookIds = _favoriteBooks
              .map((book) => book['book_id'] as int)
              .toSet();
        } else {
          _favoriteBooks = [];
          _favoriteBookIds = {};
        }
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Failed to fetch favorites: ${response.statusCode}';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Error fetching favorites: $e';
      _isLoading = false;
      debugPrint('Get user favorites error: $e');
      notifyListeners();
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Reset all data
  void reset() {
    _favoriteBooks = [];
    _likedBookIds = {};
    _favoriteBookIds = {};
    _error = null;
    notifyListeners();
  }
}
