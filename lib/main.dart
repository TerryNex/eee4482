/// EEE4482 e-Library Application
/// Student: HE HUALIANG (230263367)
/// 
/// A Flutter-based e-library management system that provides
/// a user-friendly interface for browsing and managing books.
/// Supports multi-platform deployment (Web, Linux, macOS, Windows).

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';
import 'pages/add_book_page.dart';
import 'pages/booklist_page.dart';
import 'pages/settings_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/change_password_page.dart';
import 'pages/user_dashboard_page.dart';
import 'themes/theme_provider.dart';
import 'config/settings_provider.dart';
import 'providers/auth_provider.dart';

/// Application entry point
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const App(),
    ),
  );
}

/// Root application widget that configures the MaterialApp
/// with routes and theme settings
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'EEE4482 e-Library',
          initialRoute: '/login',
          // Define application routes for navigation
          routes: {
            '/': (context) => const LoginPage(),
            '/login': (context) => const LoginPage(),
            '/register': (context) => const RegisterPage(),
            '/home': (context) => HomePage(),
            '/dashboard': (context) => const UserDashboardPage(),
            '/add': (context) => AddBookPage(),
            '/booklist': (context) => BooklistPage(),
            '/settings': (context) => const SettingsPage(),
            '/change-password': (context) => const ChangePasswordPage(),
          },
          // Use theme from provider
          theme: themeProvider.themeData,
        );
      },
    );
  }
}
