/// API Service
/// Handles all API calls with robust error handling, timeout settings, and authentication
/// Student: HE HUALIANG (230263367)

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

/// Custom exception for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic error;

  ApiException({
    required this.message,
    this.statusCode,
    this.error,
  });

  @override
  String toString() {
    return 'ApiException: $message (Status: $statusCode)';
  }
}

/// API Service class with comprehensive error handling
class ApiService {
  /// HTTP Client with proxy support
  /// Note: Flutter's http package doesn't directly support proxy configuration.
  /// For production use with proxy, consider:
  /// 1. Using a custom HttpClient with proxy settings
  /// 2. Using dio package which has better proxy support
  /// 3. Configuring system-level proxy
  /// This implementation returns a standard client as proxy configuration
  /// would require platform-specific implementations.
  static http.Client _getClient() {
    // For future enhancement: implement platform-specific proxy support
    // Web: Proxy is handled by browser
    // Mobile: Use system proxy settings
    // Desktop: Configure HttpClient with proxy
    return http.Client();
  }

  /// Get common headers including authentication
  static Map<String, String> _getHeaders({Map<String, String>? additionalHeaders}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Add authentication token if available
    if (ApiConfig.authToken != null && ApiConfig.authToken!.isNotEmpty) {
      headers[ApiConfig.authHeader] = 'Bearer ${ApiConfig.authToken}';
    }

    // Add any additional headers
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return headers;
  }

  /// Handle HTTP response and errors
  static dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        if (response.body.isEmpty) {
          return {'success': true};
        }
        return json.decode(response.body);
      } catch (e) {
        throw ApiException(
          message: 'Failed to parse response',
          statusCode: response.statusCode,
          error: e,
        );
      }
    } else {
      String errorMessage = 'Request failed';
      try {
        final errorBody = json.decode(response.body);
        errorMessage = errorBody['message'] ?? errorMessage;
      } catch (e) {
        errorMessage = response.body.isNotEmpty 
            ? response.body 
            : 'Request failed with status ${response.statusCode}';
      }

      throw ApiException(
        message: errorMessage,
        statusCode: response.statusCode,
      );
    }
  }

  /// Handle common exceptions
  static ApiException _handleException(dynamic error) {
    if (error is ApiException) {
      return error;
    } else if (error is SocketException) {
      return ApiException(
        message: 'Network error: Unable to connect to server. Please check your internet connection.',
        error: error,
      );
    } else if (error is TimeoutException) {
      return ApiException(
        message: 'Request timeout: The server took too long to respond. Please try again.',
        error: error,
      );
    } else if (error is FormatException) {
      return ApiException(
        message: 'Invalid data format received from server.',
        error: error,
      );
    } else {
      return ApiException(
        message: 'Unexpected error: ${error.toString()}',
        error: error,
      );
    }
  }

  /// GET request
  static Future<dynamic> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final client = _getClient();
      var url = Uri.parse(ApiConfig.getFullUrl(endpoint));

      if (queryParameters != null && queryParameters.isNotEmpty) {
        url = url.replace(queryParameters: queryParameters.map(
          (key, value) => MapEntry(key, value.toString()),
        ));
      }

      final response = await client
          .get(url, headers: _getHeaders(additionalHeaders: headers))
          .timeout(
            Duration(seconds: ApiConfig.connectionTimeout),
            onTimeout: () {
              throw TimeoutException('Connection timeout');
            },
          );

      client.close();
      return _handleResponse(response);
    } catch (e) {
      throw _handleException(e);
    }
  }

  /// POST request
  static Future<dynamic> post(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    try {
      final client = _getClient();
      final url = Uri.parse(ApiConfig.getFullUrl(endpoint));

      final response = await client
          .post(
            url,
            headers: _getHeaders(additionalHeaders: headers),
            body: body != null ? json.encode(body) : null,
          )
          .timeout(
            Duration(seconds: ApiConfig.connectionTimeout),
            onTimeout: () {
              throw TimeoutException('Connection timeout');
            },
          );

      client.close();
      return _handleResponse(response);
    } catch (e) {
      throw _handleException(e);
    }
  }

  /// PUT request
  static Future<dynamic> put(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    try {
      final client = _getClient();
      final url = Uri.parse(ApiConfig.getFullUrl(endpoint));

      final response = await client
          .put(
            url,
            headers: _getHeaders(additionalHeaders: headers),
            body: body != null ? json.encode(body) : null,
          )
          .timeout(
            Duration(seconds: ApiConfig.connectionTimeout),
            onTimeout: () {
              throw TimeoutException('Connection timeout');
            },
          );

      client.close();
      return _handleResponse(response);
    } catch (e) {
      throw _handleException(e);
    }
  }

  /// DELETE request
  static Future<dynamic> delete(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    try {
      final client = _getClient();
      final url = Uri.parse(ApiConfig.getFullUrl(endpoint));

      final response = await client
          .delete(
            url,
            headers: _getHeaders(additionalHeaders: headers),
            body: body != null ? json.encode(body) : null,
          )
          .timeout(
            Duration(seconds: ApiConfig.connectionTimeout),
            onTimeout: () {
              throw TimeoutException('Connection timeout');
            },
          );

      client.close();
      return _handleResponse(response);
    } catch (e) {
      throw _handleException(e);
    }
  }

  /// PATCH request
  static Future<dynamic> patch(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    try {
      final client = _getClient();
      final url = Uri.parse(ApiConfig.getFullUrl(endpoint));

      final response = await client
          .patch(
            url,
            headers: _getHeaders(additionalHeaders: headers),
            body: body != null ? json.encode(body) : null,
          )
          .timeout(
            Duration(seconds: ApiConfig.connectionTimeout),
            onTimeout: () {
              throw TimeoutException('Connection timeout');
            },
          );

      client.close();
      return _handleResponse(response);
    } catch (e) {
      throw _handleException(e);
    }
  }
}
