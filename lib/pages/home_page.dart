/// Home Page for EEE4482 e-Library Application
/// Displays welcome message with student information and book carousel
/// Student: HE HUALIANG (230263367)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../widgets/navigation_frame.dart';
import '../widgets/personal_info.dart';
import '../widgets/book_carousel.dart';
import '../providers/book_provider.dart';
import '../providers/auth_provider.dart';

/// HomePage widget displays the landing page of the e-Library application
/// Shows the application title, student information, and a carousel of books
class HomePage extends StatefulWidget {
  HomePage({super.key});

  int selectedIndex = 0;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Fetch books when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookProvider>().getAllBooks();
    });
  }

  List<Map<String, dynamic>> _getRandomBooks(List<Map<String, dynamic>> allBooks, int count) {
    if (allBooks.isEmpty) return [];
    if (allBooks.length <= count) return allBooks;
    
    final random = Random();
    final shuffled = List<Map<String, dynamic>>.from(allBooks)..shuffle(random);
    return shuffled.take(count).toList();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final username = authProvider.currentUser?['username'] ?? 'Guest';

    return Scaffold(
      body: NavigationFrame(
        selectedIndex: 0,
        child: Column(
          children: [
            PersonalInfoWidget(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Welcome section
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        'EEE4482 e-Library\nWelcome, $username',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    
                    // Book carousel section
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          const Text(
                            'Featured Books',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Consumer<BookProvider>(
                            builder: (context, bookProvider, child) {
                              if (bookProvider.isLoading) {
                                return const SizedBox(
                                  height: 320,
                                  child: Center(child: CircularProgressIndicator()),
                                );
                              }

                              if (bookProvider.error != null) {
                                return SizedBox(
                                  height: 320,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.error, size: 48, color: Colors.red),
                                        const SizedBox(height: 16),
                                        Text('Error loading books: ${bookProvider.error}'),
                                        const SizedBox(height: 16),
                                        ElevatedButton(
                                          onPressed: () => bookProvider.getAllBooks(),
                                          child: const Text('Retry'),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              final randomBooks = _getRandomBooks(bookProvider.books, 10);
                              
                              if (randomBooks.isEmpty) {
                                return const SizedBox(
                                  height: 320,
                                  child: Center(
                                    child: Text('No books available'),
                                  ),
                                );
                              }

                              return BookCarousel(books: randomBooks);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
