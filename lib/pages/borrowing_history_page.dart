/// Borrowing History Page
/// Displays full borrowing history for the current user
/// Student: HE HUALIANG (230263367)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/borrowing_provider.dart';
import '../widgets/navigation_frame.dart';
import '../widgets/personal_info.dart';

class BorrowingHistoryPage extends StatefulWidget {
  const BorrowingHistoryPage({super.key});

  @override
  State<BorrowingHistoryPage> createState() => _BorrowingHistoryPageState();
}

class _BorrowingHistoryPageState extends State<BorrowingHistoryPage> {
  @override
  void initState() {
    super.initState();
    // Fetch borrowing history from API when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BorrowingProvider>().getBorrowingHistory();
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
                child: Consumer<BorrowingProvider>(
                  builder: (context, borrowingProvider, child) {
                    final borrowingHistory = borrowingProvider.borrowingHistory;

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
                              'Borrowing History',
                              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Loading state
                        if (borrowingProvider.isLoading)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(40),
                              child: CircularProgressIndicator(),
                            ),
                          )

                        // Error state
                        else if (borrowingProvider.error != null)
                          Center(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(40),
                                child: Column(
                                  children: [
                                    const Icon(Icons.error, size: 64, color: Colors.red),
                                    const SizedBox(height: 16),
                                    Text('Error: ${borrowingProvider.error}'),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () {
                                        borrowingProvider.getBorrowingHistory();
                                      },
                                      child: const Text('Retry'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )

                        // Empty state
                        else if (borrowingHistory.isEmpty)
                          Center(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(40),
                                child: Column(
                                  children: [
                                    const Icon(
                                      Icons.history,
                                      size: 64,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'No borrowing history yet',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Browse books and borrow some!',
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

                        // Borrowing history list
                        else
                          ...borrowingHistory.map((record) => _buildBorrowingCard(record)),
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

  Widget _buildBorrowingCard(Map<String, dynamic> record) {
    final isBorrowed = record['status'] == 'borrowed';
    final bookId = record['book_id'];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: () {
          // Navigate to book list or show book details
          Navigator.pushNamed(context, '/booklist');
        },
        leading: Icon(
          isBorrowed ? Icons.book : Icons.check_circle,
          color: isBorrowed ? Colors.blue : Colors.green,
          size: 40,
        ),
        title: Text(
          record['book_title'] ?? 'Unknown Book',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('by ${record['authors'] ?? 'Unknown'}'),
            const SizedBox(height: 4),
            Text(
              'Borrowed: ${record['borrowed_date'] ?? 'N/A'}',
              style: const TextStyle(fontSize: 12),
            ),
            if (isBorrowed)
              Text(
                'Due: ${record['due_date'] ?? 'N/A'}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              )
            else
              Text(
                'Returned: ${record['returned_date'] ?? 'N/A'}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green.shade700,
                ),
              ),
          ],
        ),
        trailing: isBorrowed && bookId != null
            ? ElevatedButton.icon(
                onPressed: () async {
                  // Show confirmation dialog
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Return Book'),
                      content: Text(
                        'Do you want to return "${record['book_title'] ?? 'this book'}"?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Return'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true && context.mounted) {
                    // Show loading
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );

                    // Call return API
                    final borrowingProvider = context.read<BorrowingProvider>();
                    final success = await borrowingProvider.returnBook(
                      int.parse(bookId.toString()),
                    );

                    // Close loading
                    if (context.mounted) {
                      Navigator.pop(context);
                    }

                    // Show result
                    if (context.mounted) {
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Book returned successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              borrowingProvider.error ?? 'Failed to return book',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                },
                icon: const Icon(Icons.keyboard_return, size: 16),
                label: const Text('Return', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              )
            : Chip(
                label: Text(
                  'Returned',
                  style: const TextStyle(fontSize: 12),
                ),
                backgroundColor: Colors.green.shade100,
              ),
      ),
    );
  }
}
