/// Settings Page
/// Allows users to configure API settings, proxy settings, and themes
/// Student: HE HUALIANG (230263367)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/navigation_frame.dart';
import '../themes/theme_provider.dart';
import '../themes/app_themes.dart';
import '../config/settings_provider.dart';
import '../widgets/personal_info.dart';
import '../providers/auth_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _apiUrlController = TextEditingController();
  final TextEditingController _proxyHostController = TextEditingController();
  final TextEditingController _proxyPortController = TextEditingController();

  bool _useProxy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settingsProvider = Provider.of<SettingsProvider>(
        context,
        listen: false,
      );
      _apiUrlController.text = settingsProvider.apiBaseUrl;
      _useProxy = settingsProvider.useProxy;
      _proxyHostController.text = settingsProvider.proxyHost;
      _proxyPortController.text = settingsProvider.proxyPort.toString();
    });
  }

  @override
  void dispose() {
    _apiUrlController.dispose();
    _proxyHostController.dispose();
    _proxyPortController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Check if user is admin
        if (!authProvider.isAdmin) {
          // Redirect non-admin users
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/home');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Settings page is only accessible to administrators'),
                backgroundColor: Colors.red,
              ),
            );
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return NavigationFrame(
          selectedIndex: 5,
          child: Column(
            children: [
              PersonalInfoWidget(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildThemeSection(),
                        const SizedBox(height: 30),
                        _buildApiSection(),
                        const SizedBox(height: 30),
                        _buildProxySection(),
                        const SizedBox(height: 30),
                        _buildActionButtons(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Theme',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Choose your preferred UI theme',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: ThemeType.values.map((themeType) {
                    final isSelected = themeProvider.currentTheme == themeType;
                    return ChoiceChip(
                      label: Text(AppThemes.getThemeName(themeType)),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          themeProvider.setTheme(themeType);
                        }
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApiSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'API Configuration',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Configure the backend API endpoint. Settings are saved in browser localStorage.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 15),
            // Info box about config.json
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Server-side configuration available',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'You can also edit web/config.json on your server to change API URL without rebuilding. See API_CONFIGURATION_GUIDE.md for details.',
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Quick switch buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _apiUrlController.text = 'https://eee4482.chromahk.com/api';
                      });
                    },
                    icon: const Icon(Icons.cloud_done, size: 18),
                    label: const Text('Production API'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _apiUrlController.text = 'http://192.168.50.9/api';
                      });
                    },
                    icon: const Icon(Icons.developer_mode, size: 18),
                    label: const Text('Development API'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _apiUrlController,
              decoration: const InputDecoration(
                labelText: 'API Base URL',
                hintText: 'https://eee4482.chromahk.com/api',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.cloud),
                helperText: 'Example: https://yourdomain.com/api or http://192.168.1.100/api',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProxySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Proxy Configuration',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Configure proxy settings for network requests',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text('Use Proxy'),
              subtitle: const Text('Enable proxy for API requests'),
              value: _useProxy,
              onChanged: (value) {
                setState(() {
                  _useProxy = value;
                });
              },
            ),
            if (_useProxy) ...[
              const SizedBox(height: 10),
              TextField(
                controller: _proxyHostController,
                decoration: const InputDecoration(
                  labelText: 'Proxy Host',
                  hintText: 'localhost',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.dns),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _proxyPortController,
                decoration: const InputDecoration(
                  labelText: 'Proxy Port',
                  hintText: '8080',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.settings_input_component),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _saveSettings,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Save Settings'),
          ),
        ),
        const SizedBox(width: 10),
        OutlinedButton(
          onPressed: _resetSettings,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          ),
          child: const Text('Reset to Defaults'),
        ),
      ],
    );
  }

  void _saveSettings() async {
    final settingsProvider = Provider.of<SettingsProvider>(
      context,
      listen: false,
    );

    // Validate inputs
    if (_apiUrlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('API URL cannot be empty'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_useProxy) {
      if (_proxyHostController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Proxy host cannot be empty when proxy is enabled'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final port = int.tryParse(_proxyPortController.text);
      if (port == null || port < 1 || port > 65535) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid proxy port number'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    // Save settings
    await settingsProvider.setApiBaseUrl(_apiUrlController.text);
    await settingsProvider.setProxyConfig(
      enabled: _useProxy,
      host: _proxyHostController.text,
      port: int.tryParse(_proxyPortController.text) ?? 8080,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings saved successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _resetSettings() async {
    final settingsProvider = Provider.of<SettingsProvider>(
      context,
      listen: false,
    );
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text(
          'Are you sure you want to reset all settings to defaults?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await settingsProvider.resetToDefaults();
      await themeProvider.setTheme(ThemeType.defaultTheme);

      // Update form fields
      setState(() {
        _apiUrlController.text = settingsProvider.apiBaseUrl;
        _useProxy = settingsProvider.useProxy;
        _proxyHostController.text = settingsProvider.proxyHost;
        _proxyPortController.text = settingsProvider.proxyPort.toString();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings reset to defaults'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }
}
