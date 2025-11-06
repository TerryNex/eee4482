/// Example Usage Guide for Updated Providers with JWT Authentication
/// Student: HE HUALIANG (230263367)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'lib/providers/auth_provider.dart';
import 'lib/providers/book_provider.dart';
import 'lib/providers/user_provider.dart';
import 'lib/providers/favorite_provider.dart';
import 'lib/config/api_config.dart';

/// Example 1: User Login (generates JWT token)
class LoginExample {
  static Future<void> login(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();

    // Call login - returns JWT token from backend
    bool success = await authProvider.login(
      'testuser',
      'Password123',
      true, // Remember me
    );

    if (success) {
      // JWT token is automatically set in AuthProvider and ApiConfig
      print('Login successful!');
      print('JWT Token: ${ApiConfig.authToken}');
      print('User: ${authProvider.currentUser}');

      // Navigate to home screen
    } else {
      print('Login failed');
    }
  }
}

/// Example 2: User Registration
class RegisterExample {
  static Future<void> register(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();

    // Call register - calls backend API
    final result = await authProvider.register(
      username: 'newuser',
      email: 'newuser@example.com',
      password: 'Password123',
    );

    if (result['success']) {
      print('Registration successful!');
      print('${result['message']}');

      // Show login screen
    } else {
      print('Registration failed: ${result['message']}');
    }
  }
}

/// Example 3: Change Password (requires JWT)
class ChangePasswordExample {
  static Future<void> changePassword(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();

    // Requires JWT token (user must be logged in)
    final result = await authProvider.changePassword(
      oldPassword: 'OldPassword123',
      newPassword: 'NewPassword456',
    );

    if (result['success']) {
      print('Password changed successfully!');
    } else {
      print('Failed: ${result['message']}');
    }
  }
}

/// Example 4: Request Password Reset
class PasswordResetExample {
  static Future<void> requestReset(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();

    // Can use username or email
    final result = await authProvider.requestPasswordReset('user@example.com');

    if (result['success']) {
      print('Reset link sent to: ${result['email']}');
    } else {
      print('Failed: ${result['message']}');
    }
  }
}

/// Example 5: Get All Books (requires JWT if admin features enabled)
class GetBooksExample {
  static Future<void> getBooks(BuildContext context) async {
    final bookProvider = context.read<BookProvider>();

    // Fetch all books from backend
    bool success = await bookProvider.getAllBooks();

    if (success) {
      print('Books loaded: ${bookProvider.books.length}');

      // Display books in UI
      for (var book in bookProvider.books) {
        print('- ${book['title']} by ${book['authors']}');
      }
    } else {
      print('Error: ${bookProvider.error}');
    }
  }
}

/// Example 6: Add Book (requires JWT)
class AddBookExample {
  static Future<void> addBook(BuildContext context) async {
    final bookProvider = context.read<BookProvider>();

    // Create book data
    final newBook = {
      'title': 'Flutter Guide',
      'authors': 'John Doe',
      'publishers': 'Tech Publishing',
      'date': '2024',
      'isbn': '978-1234567890',
    };

    // Add book - requires JWT token
    bool success = await bookProvider.addBook(newBook);

    if (success) {
      print('Book added successfully!');
      print('Books now: ${bookProvider.books.length}');
    } else {
      print('Error: ${bookProvider.error}');
    }
  }
}

/// Example 7: Update Book (requires JWT)
class UpdateBookExample {
  static Future<void> updateBook(BuildContext context) async {
    final bookProvider = context.read<BookProvider>();

    final bookId = 1;
    final updatedData = {
      'title': 'Updated Title',
      'authors': 'Jane Doe',
      'publishers': 'Tech Publishing',
      'date': '2024',
      'isbn': '978-1234567890',
    };

    // Update book - requires JWT token
    bool success = await bookProvider.updateBook(bookId, updatedData);

    if (success) {
      print('Book updated successfully!');
    } else {
      print('Error: ${bookProvider.error}');
    }
  }
}

/// Example 8: Delete Book (requires JWT)
class DeleteBookExample {
  static Future<void> deleteBook(BuildContext context) async {
    final bookProvider = context.read<BookProvider>();

    final bookId = 1;

    // Delete book - requires JWT token
    bool success = await bookProvider.deleteBook(bookId);

    if (success) {
      print('Book deleted successfully!');
      print('Books now: ${bookProvider.books.length}');
    } else {
      print('Error: ${bookProvider.error}');
    }
  }
}

/// Example 9: Toggle Like (requires JWT)
class LikeBookExample {
  static Future<void> toggleLike(BuildContext context) async {
    final favoriteProvider = context.read<FavoriteProvider>();

    final bookId = 1;

    // Toggle like - sends JWT token
    bool success = await favoriteProvider.toggleLike(bookId);

    if (success) {
      if (favoriteProvider.isBookLiked(bookId)) {
        print('Book liked!');
      } else {
        print('Like removed!');
      }
    } else {
      print('Error: ${favoriteProvider.error}');
    }
  }
}

/// Example 10: Toggle Favorite (requires JWT)
class FavoriteBookExample {
  static Future<void> toggleFavorite(BuildContext context) async {
    final favoriteProvider = context.read<FavoriteProvider>();

    final bookId = 1;

    // Toggle favorite - sends JWT token
    bool success = await favoriteProvider.toggleFavorite(bookId);

    if (success) {
      if (favoriteProvider.isBookFavorited(bookId)) {
        print('Added to favorites!');
      } else {
        print('Removed from favorites!');
      }
    } else {
      print('Error: ${favoriteProvider.error}');
    }
  }
}

/// Example 11: Get User Favorites (requires JWT)
class GetFavoritesExample {
  static Future<void> getFavorites(BuildContext context) async {
    final favoriteProvider = context.read<FavoriteProvider>();

    final userId = 1;

    // Get user's favorite books - sends JWT token
    bool success = await favoriteProvider.getUserFavorites(userId);

    if (success) {
      print('Favorite books: ${favoriteProvider.favoriteBooks.length}');

      for (var book in favoriteProvider.favoriteBooks) {
        print('- ${book['title']}');
      }
    } else {
      print('Error: ${favoriteProvider.error}');
    }
  }
}

/// Example 12: Get All Users (admin only, requires JWT)
class GetUsersExample {
  static Future<void> getUsers(BuildContext context) async {
    final userProvider = context.read<UserProvider>();
    final authProvider = context.read<AuthProvider>();

    // Check if user is admin
    if (!authProvider.isAdmin) {
      print('Only admins can view all users');
      return;
    }

    // Get all users - requires JWT token and admin role
    bool success = await userProvider.getAllUsers();

    if (success) {
      print('Users: ${userProvider.users.length}');

      for (var user in userProvider.users) {
        print('- ${user['username']} (${user['email']})');
      }
    } else {
      print('Error: ${userProvider.error}');
    }
  }
}

/// Example 13: Delete User (admin only, requires JWT)
class DeleteUserExample {
  static Future<void> deleteUser(BuildContext context) async {
    final userProvider = context.read<UserProvider>();
    final authProvider = context.read<AuthProvider>();

    if (!authProvider.isAdmin) {
      print('Only admins can delete users');
      return;
    }

    final currentUserId = authProvider.currentUser?['id'] ?? 1;

    // Delete user by email - requires JWT token and admin role
    bool success = await userProvider.deleteUser(
      currentUserId,
      'AdminPassword123', // Current user's password
      'target@example.com',
      identifierType: 'email',
    );

    if (success) {
      print('User deleted successfully!');
    } else {
      print('Error: ${userProvider.error}');
    }
  }
}

/// Example 14: Logout (requires JWT)
class LogoutExample {
  static Future<void> logout(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();

    // Logout - sends JWT token to backend
    await authProvider.logout();

    print('Logged out successfully!');
    print('JWT Token cleared: ${ApiConfig.authToken}');

    // Navigate to login screen
  }
}

/// Example 15: Widget using Multiple Providers
class BookListWithFavoritesWidget extends StatefulWidget {
  @override
  State<BookListWithFavoritesWidget> createState() =>
      _BookListWithFavoritesWidgetState();
}

class _BookListWithFavoritesWidgetState
    extends State<BookListWithFavoritesWidget> {
  @override
  void initState() {
    super.initState();
    // Load books when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookProvider>().getAllBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Books'),
        actions: [
          // Logout button
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          ),
        ],
      ),
      body: Consumer2<BookProvider, FavoriteProvider>(
        builder: (context, bookProvider, favoriteProvider, child) {
          if (bookProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (bookProvider.error != null) {
            return Center(child: Text('Error: ${bookProvider.error}'));
          }

          return ListView.builder(
            itemCount: bookProvider.books.length,
            itemBuilder: (context, index) {
              final book = bookProvider.books[index];
              final bookId = book['book_id'] as int;
              final isLiked = favoriteProvider.isBookLiked(bookId);
              final isFavorited = favoriteProvider.isBookFavorited(bookId);

              return ListTile(
                title: Text(book['title'] ?? 'Unknown'),
                subtitle: Text(book['authors'] ?? 'Unknown'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Like button
                    IconButton(
                      icon: Icon(
                        isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                        color: isLiked ? Colors.blue : null,
                      ),
                      onPressed: () async {
                        await favoriteProvider.toggleLike(bookId);
                      },
                    ),
                    // Favorite button
                    IconButton(
                      icon: Icon(
                        isFavorited ? Icons.favorite : Icons.favorite_border,
                        color: isFavorited ? Colors.red : null,
                      ),
                      onPressed: () async {
                        await favoriteProvider.toggleFavorite(bookId);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// Main Setup in main.dart
void setupProviders() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => BookProvider()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => FavoriteProvider()),
    ],
    child: MyApp(),
  );
}

void main() => runApp(setupProviders());
