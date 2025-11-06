/// Settings Provider
/// Manages application settings including API and proxy configuration
/// Student: HE HUALIANG (230263367)

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

/// Settings provider for managing app configuration
class SettingsProvider extends ChangeNotifier {
  // API Settings
  String _apiBaseUrl = ApiConfig.baseUrl;

  // Proxy Settings
  bool _useProxy = ApiConfig.useProxy;
  String _proxyHost = ApiConfig.proxyHost;
  int _proxyPort = ApiConfig.proxyPort;

  // Keys for SharedPreferences
  static const String _apiBaseUrlKey = 'api_base_url';
  static const String _useProxyKey = 'use_proxy';
  static const String _proxyHostKey = 'proxy_host';
  static const String _proxyPortKey = 'proxy_port';

  SettingsProvider() {
    _loadSettings();
  }

  // Getters
  String get apiBaseUrl => _apiBaseUrl;
  bool get useProxy => _useProxy;
  String get proxyHost => _proxyHost;
  int get proxyPort => _proxyPort;

  /// Load settings from shared preferences
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      _apiBaseUrl = prefs.getString(_apiBaseUrlKey) ?? ApiConfig.baseUrl;
      _useProxy = prefs.getBool(_useProxyKey) ?? ApiConfig.useProxy;
      _proxyHost = prefs.getString(_proxyHostKey) ?? ApiConfig.proxyHost;
      _proxyPort = prefs.getInt(_proxyPortKey) ?? ApiConfig.proxyPort;

      // Update ApiConfig
      _updateApiConfig();

      notifyListeners();
    } catch (e) {
      // If loading fails, use defaults
    }
  }

  /// Update ApiConfig with current settings
  void _updateApiConfig() {
    // Note: Since ApiConfig uses static fields, we can't directly update baseUrl
    // In a production app, you might want to refactor ApiConfig to be injectable
    ApiConfig.setProxy(enabled: _useProxy, host: _proxyHost, port: _proxyPort);
  }

  /// Set API base URL
  Future<void> setApiBaseUrl(String url) async {
    if (_apiBaseUrl == url) return;

    _apiBaseUrl = url;
    _updateApiConfig();
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_apiBaseUrlKey, url);
    } catch (e) {
      // Handle error silently
    }
  }

  /// Set proxy configuration
  Future<void> setProxyConfig({
    required bool enabled,
    String? host,
    int? port,
  }) async {
    bool changed = false;

    if (_useProxy != enabled) {
      _useProxy = enabled;
      changed = true;
    }

    if (host != null && _proxyHost != host) {
      _proxyHost = host;
      changed = true;
    }

    if (port != null && _proxyPort != port) {
      _proxyPort = port;
      changed = true;
    }

    if (!changed) return;

    _updateApiConfig();
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_useProxyKey, _useProxy);
      if (host != null) {
        await prefs.setString(_proxyHostKey, _proxyHost);
      }
      if (port != null) {
        await prefs.setInt(_proxyPortKey, _proxyPort);
      }
    } catch (e) {
      // Handle error silently
    }
  }

  /// Reset to default settings
  Future<void> resetToDefaults() async {
    _apiBaseUrl = ApiConfig.baseUrl;
    _useProxy = false;
    _proxyHost = '';
    _proxyPort = 80;

    _updateApiConfig();
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_apiBaseUrlKey);
      await prefs.remove(_useProxyKey);
      await prefs.remove(_proxyHostKey);
      await prefs.remove(_proxyPortKey);
    } catch (e) {
      // Handle error silently
    }
  }
}
