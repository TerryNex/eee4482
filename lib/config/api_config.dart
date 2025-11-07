/// API Configuration
/// Manages API endpoints, proxy settings, and authentication configuration
/// Student: HE HUALIANG (230263367)

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiConfig {
  // Base API URL - Mutable to allow runtime configuration
  // Can be loaded from config.json or changed via Settings page
  static String baseUrl = 'http://192.168.50.9/api';
  
  // Flag to track if config has been loaded from server
  static bool _configLoaded = false;

  // Proxy settings - mutable for runtime configuration
  // These are managed by SettingsProvider for persistence
  static bool useProxy = false;
  static String proxyHost = '';
  static int proxyPort = 80;

  // Timeout settings (in seconds)
  static const int connectionTimeout = 30;
  static const int receiveTimeout = 30;

  // Authentication settings
  static String? authToken;
  static const String authHeader = 'Authorization';

  // API Endpoints
  static const String getAllBooksEndpoint = '/books';
  static const String addBookEndpoint = '/books/add';
  static const String updateBookEndpoint = '/books/update';
  static const String deleteBookEndpoint = '/books/delete';

  /// Load configuration from server's config.json file
  /// This allows changing API URL after deployment without rebuilding
  static Future<void> loadConfigFromServer() async {
    if (_configLoaded) return; // Only load once per session
    
    try {
      final response = await http.get(
        Uri.parse('/config.json'),
        headers: {'Cache-Control': 'no-cache'},
      ).timeout(const Duration(seconds: 5));
      
      if (response.statusCode == 200) {
        final config = json.decode(response.body);
        
        if (config['apiBaseUrl'] != null && config['apiBaseUrl'].toString().isNotEmpty) {
          baseUrl = config['apiBaseUrl'].toString();
        }
        
        if (config['useProxy'] != null) {
          useProxy = config['useProxy'] as bool? ?? false;
        }
        
        if (config['proxyHost'] != null) {
          proxyHost = config['proxyHost'].toString();
        }
        
        if (config['proxyPort'] != null) {
          proxyPort = config['proxyPort'] as int? ?? 8080;
        }
        
        _configLoaded = true;
        print('✓ API Config loaded from server: $baseUrl');
      }
    } catch (e) {
      // If config.json doesn't exist or fails to load, use default values
      print('ℹ Using default API config: $baseUrl');
    }
  }
  
  /// Set base URL (used by Settings page)
  static void setBaseUrl(String url) {
    baseUrl = url;
  }
  
  /// Get full URL for an endpoint
  static String getFullUrl(String endpoint) {
    return '$baseUrl$endpoint';
  }

  /// Get authorization headers with JWT token
  static Map<String, String> getAuthorizationHeaders() {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (authToken != null && authToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $authToken';
    }
    return headers;
  }

  /// Set proxy configuration
  static void setProxy({
    required bool enabled,
    String host = '',
    int port = 80,
  }) {
    useProxy = enabled;
    proxyHost = host;
    proxyPort = port;
  }

  /// Set authentication token
  static void setAuthToken(String? token) {
    authToken = token;
  }

  /// Get proxy URL if enabled
  static String? getProxyUrl() {
    if (useProxy && proxyHost.isNotEmpty) {
      return 'http://$proxyHost:$proxyPort';
    }
    return null;
  }
}
