/// Book Service
/// Handles all book-related API operations
/// Student: HE HUALIANG (230263367)

import '../config/api_config.dart';
import 'api_service.dart';
import 'dart:convert';

/// Book Service class for managing book operations
class BookService {
  /// Fetch all books from the API
  /// Returns a list of book maps or throws ApiException
  static Future<List<Map<String, dynamic>>> getAllBooks() async {
    try {
      final response = await ApiService.get(ApiConfig.getAllBooksEndpoint);

      // Handle different response formats
      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      } else if (response is Map && response.containsKey('data')) {
        return List<Map<String, dynamic>>.from(response['data']);
      } else if (response is Map && response.containsKey('books')) {
        return List<Map<String, dynamic>>.from(response['books']);
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  /// Add a new book
  /// Takes a book map and returns the created book data
  static Future<Map<String, dynamic>> addBook(
    Map<String, dynamic> bookData,
  ) async {
    try {
      final response = await ApiService.post(
        ApiConfig.addBookEndpoint,
        body: bookData,
      );

      if (response is Map) {
        return Map<String, dynamic>.from(response);
      }

      return {'success': true, 'message': 'Book added successfully'};
    } catch (e) {
      rethrow;
    }
  }

  /// Update an existing book
  /// Takes book ID and updated data
  static Future<Map<String, dynamic>> updateBook(
    int bookId,
    Map<String, dynamic> bookData,
  ) async {
    try {
      final response = await ApiService.put(
        '${ApiConfig.updateBookEndpoint}/$bookId',
        body: bookData,
      );

      if (response is Map) {
        return Map<String, dynamic>.from(response);
      }
      final body = json.decode(response.body);
      final msg =
          body['message'] ?? body['error'] ?? 'Book updated successfully';

      return {'success': true, 'message': msg};
    } catch (e) {
      rethrow;
    }
  }

  /// Delete a book
  /// Takes book ID and deletes the book
  static Future<Map<String, dynamic>> deleteBook(int bookId) async {
    try {
      final response = await ApiService.delete(
        '${ApiConfig.deleteBookEndpoint}/$bookId',
      );

      if (response is Map) {
        return Map<String, dynamic>.from(response);
      }

      return {'success': true, 'message': 'Book deleted successfully'};
    } catch (e) {
      rethrow;
    }
  }

  /// Get a single book by ID
  static Future<Map<String, dynamic>?> getBookById(int bookId) async {
    try {
      final response = await ApiService.get(
        '${ApiConfig.getAllBooksEndpoint}/$bookId',
      );

      if (response is Map) {
        return Map<String, dynamic>.from(response);
      }

      return null;
    } catch (e) {
      rethrow;
    }
  }

  /// Search books by query
  static Future<List<Map<String, dynamic>>> searchBooks(String query) async {
    try {
      final response = await ApiService.get(
        ApiConfig.getAllBooksEndpoint,
        queryParameters: {'search': query},
      );

      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      } else if (response is Map && response.containsKey('data')) {
        return List<Map<String, dynamic>>.from(response['data']);
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }
}
