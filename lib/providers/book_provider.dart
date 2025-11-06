/// Book Provider
/// Manages all book-related operations with backend API integration and JWT authentication
/// Student: HE HUALIANG (230263367)

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';

/// Book Provider for managing books state and operations
class BookProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _books = [];
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _selectedBook;

  // Getters
  List<Map<String, dynamic>> get books => _books;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get selectedBook => _selectedBook;

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

  /// Fetch all books from the backend API
  Future<bool> getAllBooks() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final path = '/books/all';
      final uri = _buildUri(path);
      final response = await http
          .get(uri, headers: ApiConfig.getAuthorizationHeaders())
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          _books = List<Map<String, dynamic>>.from(data);
        } else {
          _books = [];
        }
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Failed to fetch books: ${response.statusCode}';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Error fetching books: $e';
      _isLoading = false;
      debugPrint('Get all books error: $e');
      notifyListeners();
      return false;
    }
  }

  /// Add a new book to the backend
  Future<bool> addBook(Map<String, dynamic> bookData) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final path = '/books/add';
      final uri = _buildUri(path);
      final response = await http
          .post(
            uri,
            headers: ApiConfig.getAuthorizationHeaders(),
            body: json.encode(bookData),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        _isLoading = false;
        // Refresh the book list
        await getAllBooks();
        return true;
      } else {
        final errorData = json.decode(response.body);
        _error = errorData['message'] ?? 'Failed to add book';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Error adding book: $e';
      _isLoading = false;
      debugPrint('Add book error: $e');
      notifyListeners();
      return false;
    }
  }

  /// Update an existing book
  Future<bool> updateBook(int bookId, Map<String, dynamic> bookData) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final path = '/books/update/$bookId';
      final uri = _buildUri(path);
      final response = await http
          .put(
            uri,
            headers: ApiConfig.getAuthorizationHeaders(),
            body: json.encode(bookData),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        _isLoading = false;
        // Refresh the book list
        await getAllBooks();
        return true;
      } else {
        final errorData = json.decode(response.body);
        _error = errorData['message'] ?? 'Failed to update book';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Error updating book: $e';
      _isLoading = false;
      debugPrint('Update book error: $e');
      notifyListeners();
      return false;
    }
  }

  /// Delete a book from the backend
  Future<bool> deleteBook(int bookId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final path = '/books/delete/$bookId';
      final uri = _buildUri(path);
      final response = await http
          .delete(uri, headers: ApiConfig.getAuthorizationHeaders())
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        _isLoading = false;
        // Refresh the book list
        await getAllBooks();
        return true;
      } else {
        final errorData = json.decode(response.body);
        _error = errorData['message'] ?? 'Failed to delete book';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Error deleting book: $e';
      _isLoading = false;
      debugPrint('Delete book error: $e');
      notifyListeners();
      return false;
    }
  }

  /// Select a book for viewing details
  void selectBook(Map<String, dynamic> book) {
    _selectedBook = book;
    notifyListeners();
  }

  /// Clear selected book
  void clearSelectedBook() {
    _selectedBook = null;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
