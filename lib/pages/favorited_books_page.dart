/// Favorited Books Page
/// Displays all books favorited by the current user
/// Student: HE HUALIANG (230263367)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/favorite_provider.dart';
import '../widgets/navigation_frame.dart';
import '../widgets/personal_info.dart';

class FavoritedBooksPage extends StatefulWidget {
  const FavoritedBooksPage({super.key});

  @override
  State<FavoritedBooksPage> createState() => _FavoritedBooksPageState();
}

class _FavoritedBooksPageState extends State<FavoritedBooksPage> {
  @override
  void initState() {
    super.initState();
    // Load user's favorite books when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      if (authProvider.isAuthenticated && authProvider.currentUser != null) {
        final userId = authProvider.currentUser!['id'] as int;
        context.read<FavoriteProvider>().getUserFavorites(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // Redirect if not authenticated
    if (!authProvider.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: NavigationFrame(
        selectedIndex: -1,
        child: Column(
          children: [
            PersonalInfoWidget(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Consumer<FavoriteProvider>(
                  builder: (context, favoriteProvider, child) {
                    final favoritedBooks = favoriteProvider.favoriteBooks;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const Text(
                              'My Favorited Books',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Chip(
                              label: Text('${favoritedBooks.length} books'),
                              avatar: const Icon(Icons.favorite, size: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Loading state
                        if (favoriteProvider.isLoading)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(40),
                              child: CircularProgressIndicator(),
                            ),
                          )

                        // Error state
                        else if (favoriteProvider.error != null)
                          Center(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(40),
                                child: Column(
                                  children: [
                                    Icon(Icons.error, size: 64, color: Colors.red),
                                    const SizedBox(height: 16),
                                    Text('Error: ${favoriteProvider.error}'),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () {
                                        final userId =
                                            authProvider.currentUser!['id'] as int;
                                        favoriteProvider.getUserFavorites(userId);
                                      },
                                      child: const Text('Retry'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )

                        // Empty state
                        else if (favoritedBooks.isEmpty)
                          Center(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(40),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.favorite_border,
                                      size: 64,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'No favorited books yet',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Browse books and add them to your favorites!',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/booklist');
                                      },
                                      icon: const Icon(Icons.book),
                                      label: const Text('Browse Books'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )

                        // Books grid
                        else
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              childAspectRatio: 0.7,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: favoritedBooks.length,
                            itemBuilder: (context, index) {
                              return _buildBookCard(favoritedBooks[index]);
                            },
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookCard(Map<String, dynamic> book) {
    // Get book status from API response (0 = available, not 0 = borrowed/reserved)
    final status = book['status'] ?? 0;
    final isAvailable =
        (status is int ? status : int.tryParse(status.toString())) == 0;
    final firstLetter = (book['title'] ?? 'U')[0].toUpperCase();

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Book cover or first letter
          Expanded(
            flex: 3,
            child: Container(
              color: Colors
                  .primaries[firstLetter.codeUnitAt(0) % Colors.primaries.length],
              child: book['coverUrl'] != null
                  ? Image.network(book['coverUrl'], fit: BoxFit.cover)
                  : Center(
                      child: Text(
                        firstLetter,
                        style: const TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
            ),
          ),

          // Book info
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book['title'] ?? 'Unknown',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book['authors'] ?? 'Unknown',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  // Status tag
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isAvailable
                          ? Colors.green.shade100
                          : Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      isAvailable ? 'Available' : 'Borrowed',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isAvailable
                            ? Colors.green.shade700
                            : Colors.orange.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
