/// User Dashboard Page
/// Displays personal info, borrowing history, and liked books
/// Student: HE HUALIANG (230263367)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/navigation_frame.dart';
import '../widgets/personal_info.dart';

class UserDashboardPage extends StatefulWidget {
  const UserDashboardPage({super.key});

  @override
  State<UserDashboardPage> createState() => _UserDashboardPageState();
}

class _UserDashboardPageState extends State<UserDashboardPage> {
  // Sample data (TODO: Replace with actual API calls)
  final List<Map<String, dynamic>> _borrowingHistory = [
    {
      'id': 1,
      'bookTitle': 'Introduction to Flutter',
      'author': 'John Doe',
      'borrowedDate': '2025-10-15',
      'dueDate': '2025-11-15',
      'status': 'borrowed',
    },
    {
      'id': 2,
      'bookTitle': 'Advanced Dart Programming',
      'author': 'Jane Smith',
      'borrowedDate': '2025-10-01',
      'returnedDate': '2025-10-28',
      'status': 'returned',
    },
  ];

  final List<Map<String, dynamic>> _likedBooks = [
    {
      'id': 1,
      'title': 'Clean Code',
      'author': 'Robert C. Martin',
      'coverUrl': null,
      'status': 'available',
    },
    {
      'id': 2,
      'title': 'Design Patterns',
      'author': 'Gang of Four',
      'coverUrl': null,
      'status': 'borrowed',
    },
    {
      'id': 3,
      'title': 'The Pragmatic Programmer',
      'author': 'Hunt & Thomas',
      'coverUrl': null,
      'status': 'available',
    },
  ];

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

    final user = authProvider.currentUser;

    return NavigationFrame(
      selectedIndex: -1, // Custom page, no nav item selected
      child: Column(
        children: [
          PersonalInfoWidget(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const Text(
                    'My Dashboard',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),

                  // Personal Information Card
                  _buildPersonalInfoCard(user),
                  const SizedBox(height: 20),

                  // Statistics Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Books Borrowed',
                          '${_borrowingHistory.where((b) => b['status'] == 'borrowed').length}',
                          Icons.book,
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          'Total Borrowed',
                          '${_borrowingHistory.length}',
                          Icons.history,
                          Colors.green,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          'Liked Books',
                          '${_likedBooks.length}',
                          Icons.favorite,
                          Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Borrowing History Section
                  _buildBorrowingHistorySection(),
                  const SizedBox(height: 30),

                  // Liked Books Section
                  _buildLikedBooksSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoCard(Map<String, dynamic>? user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text(
                (user?['username'] ?? 'U')[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?['displayName'] ?? user?['username'] ?? 'User',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?['email'] ?? '',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Chip(
                    label: Text(
                      user?['role'] == 'admin' ? 'Administrator' : 'Member',
                      style: const TextStyle(fontSize: 12),
                    ),
                    avatar: Icon(
                      user?['role'] == 'admin'
                          ? Icons.admin_panel_settings
                          : Icons.person,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBorrowingHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Borrowing History',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: () {
                // TODO: Navigate to full history
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_borrowingHistory.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Center(child: Text('No borrowing history yet')),
            ),
          )
        else
          ..._borrowingHistory.map((record) => _buildBorrowingCard(record)),
      ],
    );
  }

  Widget _buildBorrowingCard(Map<String, dynamic> record) {
    final isBorrowed = record['status'] == 'borrowed';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          isBorrowed ? Icons.book : Icons.check_circle,
          color: isBorrowed ? Colors.blue : Colors.green,
          size: 40,
        ),
        title: Text(
          record['bookTitle'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('by ${record['author']}'),
            const SizedBox(height: 4),
            Text(
              isBorrowed
                  ? 'Due: ${record['dueDate']}'
                  : 'Returned: ${record['returnedDate']}',
              style: TextStyle(
                fontSize: 12,
                color: isBorrowed ? Colors.orange : Colors.green,
              ),
            ),
          ],
        ),
        trailing: Chip(
          label: Text(
            isBorrowed ? 'Borrowed' : 'Returned',
            style: const TextStyle(fontSize: 12),
          ),
          backgroundColor: isBorrowed
              ? Colors.orange.shade100
              : Colors.green.shade100,
        ),
      ),
    );
  }

  Widget _buildLikedBooksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Liked Books',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: () {
                // TODO: Navigate to full liked books
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_likedBooks.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Center(child: Text('No liked books yet')),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _likedBooks.length,
            itemBuilder: (context, index) {
              return _buildBookCard(_likedBooks[index]);
            },
          ),
      ],
    );
  }

  Widget _buildBookCard(Map<String, dynamic> book) {
    final hasStatus = book['status'] == 'available';
    final firstLetter = book['title'][0].toUpperCase();

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Book cover or first letter
          Expanded(
            child: Container(
              color:
                  Colors.primaries[firstLetter.codeUnitAt(0) %
                      Colors.primaries.length],
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
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book['title'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  book['author'],
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Status tag
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: hasStatus
                        ? Colors.green.shade100
                        : Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    book['status'],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: hasStatus
                          ? Colors.green.shade700
                          : Colors.orange.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
