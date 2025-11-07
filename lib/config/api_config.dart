/// API Configuration
/// Manages API endpoints, proxy settings, and authentication configuration
/// Student: HE HUALIANG (230263367)

class ApiConfig {
  // Base API URL - This should be configured via Settings page or environment variables
  // Default value is provided for initial setup only
  // TODO: Replace with your actual server IP or use environment variables
  static const String baseUrl = 'http://192.168.50.9/api';

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
