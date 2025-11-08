/// Borrowing Provider
/// Manages book borrowing and returning operations with backend API integration
/// Student: HE HUALIANG (230263367)

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';

/// Borrowing Provider for managing book borrowing operations
class BorrowingProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _borrowingHistory = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Map<String, dynamic>> get borrowingHistory => _borrowingHistory;
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

  /// Borrow a book
  Future<bool> borrowBook(int bookId, String dueDate) async {
    try {
      _error = null;
      notifyListeners();

      final path = '/books/borrow';
      final uri = _buildUri(path);
      final response = await http
          .post(
            uri,
            headers: ApiConfig.getAuthorizationHeaders(),
            body: json.encode({'book_id': bookId, 'due_date': dueDate}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Refresh borrowing history
        // await getBorrowingHistory();
        return true;
      } else {
        final errorData = json.decode(response.body);
        _error =
            errorData['message'] ??
            errorData['error'] ??
            'Failed to borrow book';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Error borrowing book: $e';
      debugPrint('Borrow book error: $e');
      notifyListeners();
      return false;
    }
  }

  /// Return a book
  Future<bool> returnBook(int bookId) async {
    try {
      _error = null;
      notifyListeners();

      final path = '/books/return/$bookId';
      final uri = _buildUri(path);
      final response = await http
          .put(uri, headers: ApiConfig.getAuthorizationHeaders())
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // Refresh borrowing history
        await getBorrowingHistory();
        return true;
      } else {
        final errorData = json.decode(response.body);
        _error =
            errorData['message'] ??
            errorData['error'] ??
            'Failed to return book';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Error returning book: $e';
      debugPrint('Return book error: $e');
      notifyListeners();
      return false;
    }
  }

  /// Get borrowing history for current user
  Future<bool> getBorrowingHistory() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final path = '/borrowing_history';
      final uri = _buildUri(path);
      final response = await http
          .get(uri, headers: ApiConfig.getAuthorizationHeaders())
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Map<String, dynamic>> rawHistory = [];

        if (data is List) {
          rawHistory = List<Map<String, dynamic>>.from(data);
        } else if (data is Map && data.containsKey('data')) {
          rawHistory = List<Map<String, dynamic>>.from(data['data']);
        }

        // Fetch book details for each record
        _borrowingHistory = [];
        for (var record in rawHistory) {
          final bookId = record['book_id'];
          if (bookId != null) {
            try {
              // Fetch book details
              final bookPath = '/books/all';
              final bookUri = _buildUri(bookPath);
              final bookResponse = await http
                  .get(bookUri, headers: ApiConfig.getAuthorizationHeaders())
                  .timeout(const Duration(seconds: 10));

              if (bookResponse.statusCode == 200) {
                final books = json.decode(bookResponse.body);
                if (books is List) {
                  final book = books.firstWhere(
                    (b) => b['book_id'].toString() == bookId.toString(),
                    orElse: () => null,
                  );

                  if (book != null) {
                    // Merge book details with borrowing record
                    record['book_title'] = book['title'];
                    record['authors'] = book['authors'];
                    record['isbn'] = book['isbn'];
                  }
                }
              }
            } catch (e) {
              debugPrint('Error fetching book details for book_id $bookId: $e');
            }
          }
          _borrowingHistory.add(record);
        }

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Failed to fetch borrowing history: ${response.statusCode}';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Error fetching borrowing history: $e';
      _isLoading = false;
      debugPrint('Get borrowing history error: $e');
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
    _borrowingHistory = [];
    _error = null;
    notifyListeners();
  }
}
