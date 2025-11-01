/// EEE4482 e-Library Application
/// Student: HE HUALIANG (230263367)
/// 
/// A Flutter-based e-library management system that provides
/// a user-friendly interface for browsing and managing books.
/// Supports multi-platform deployment (Web, Linux, macOS, Windows).

import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/add_book_page.dart';
import 'pages/booklist_page.dart';

/// Application entry point
void main() {
  runApp(const App());
}

/// Root application widget that configures the MaterialApp
/// with routes and theme settings
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EEE4482 e-Library',
      initialRoute: '/',
      // Define application routes for navigation
      routes: {
        '/': (context) => HomePage(),
        '/home': (context) => HomePage(),
        '/add': (context) => AddBookPage(),
        '/booklist': (context) => BooklistPage(),
      },
      // Material Design 3 theme with custom color scheme
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Color.fromARGB(255, 207, 183, 105),
      ),
    );
  }
}
