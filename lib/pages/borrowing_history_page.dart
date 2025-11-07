/// Borrowing History Page
/// Displays full borrowing history for the current user
/// Student: HE HUALIANG (230263367)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/navigation_frame.dart';
import '../widgets/personal_info.dart';

class BorrowingHistoryPage extends StatefulWidget {
  const BorrowingHistoryPage({super.key});

  @override
  State<BorrowingHistoryPage> createState() => _BorrowingHistoryPageState();
}

class _BorrowingHistoryPageState extends State<BorrowingHistoryPage> {
  // Sample data - will be replaced with actual API call
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
    {
      'id': 3,
      'bookTitle': 'Flutter in Action',
      'author': 'Bob Johnson',
      'borrowedDate': '2025-09-15',
      'returnedDate': '2025-10-10',
      'status': 'returned',
    },
  ];

  @override
  void initState() {
    super.initState();
    // TODO: Fetch borrowing history from API when endpoint is available
    // Expected endpoint: GET /user/{user_id}/borrowing_history or /borrowing_history
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
                child: Column(
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

                    // Info message
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue.shade700),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'This page will display your complete borrowing history once the backend API endpoint is implemented. See BACKEND_CHANGE_REQUIREMENTS.md for details.',
                              style: TextStyle(color: Colors.blue.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Sample borrowing history
                    ..._borrowingHistory.map((record) => _buildBorrowingCard(record)),
                  ],
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
              'Borrowed: ${record['borrowedDate']}',
              style: const TextStyle(fontSize: 12),
            ),
            if (isBorrowed)
              Text(
                'Due: ${record['dueDate']}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              )
            else
              Text(
                'Returned: ${record['returnedDate']}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green.shade700,
                ),
              ),
          ],
        ),
        trailing: Chip(
          label: Text(
            isBorrowed ? 'Currently Borrowed' : 'Returned',
            style: const TextStyle(fontSize: 12),
          ),
          backgroundColor:
              isBorrowed ? Colors.orange.shade100 : Colors.green.shade100,
        ),
      ),
    );
  }
}
