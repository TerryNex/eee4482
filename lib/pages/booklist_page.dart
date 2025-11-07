import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/navigation_frame.dart';
import '../widgets/book_form.dart';
import '../widgets/personal_info.dart';
import '../providers/book_provider.dart';
import '../providers/auth_provider.dart';

class BooklistPage extends StatefulWidget {
  BooklistPage({super.key});

  @override
  State<BooklistPage> createState() => _BooklistPageState();
}

class _BooklistPageState extends State<BooklistPage> {
  @override
  void initState() {
    super.initState();
    // Fetch books when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookProvider>().getAllBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return NavigationFrame(
      selectedIndex: 2,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Consumer<BookProvider>(
          builder: (context, bookProvider, child) {
            if (bookProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (bookProvider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error: ${bookProvider.error}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => bookProvider.getAllBooks(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return createBookLists(bookProvider.books);
          },
        ),
      ),
    );
  }

  Widget createBookLists(List<dynamic> books) {
    return Column(
      children: [
        PersonalInfoWidget(),
        Expanded(
          child: ListView(
            children: [for (var book in books!) createSingleBookRecord(book)],
          ),
        ),
      ],
    );
  }

  Widget createSingleBookRecord(Map<String, dynamic> book) {
    // Get status from API (0 = available, 1 = borrowed)
    final status = book['status'] ?? 0;
    final isAvailable =
        (status is int ? status : int.tryParse(status.toString())) == 0;
    final bookId = book['book_id'] as int?;

    return Card(
      child: ListTile(
        enabled: isAvailable,
        onTap: () {
          if (isAvailable) {
            popupBorrowDialog(book);
          }
        },
        leading: Icon(Icons.book, size: 48),
        title: Text(
          book['title'] ?? 'Unknown',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Author: ' +
              (book['authors'] ?? 'Unknown') +
              '\nPublishers: ' +
              (book['publishers'] ?? 'Unknown') +
              '\nDate: ' +
              (book['date']?.toString() ?? 'Unknown') +
              '\nISBN: ' +
              (book['isbn'] ?? 'Unknown') +
              '\nStatus: ' +
              (isAvailable ? 'Available' : 'Borrowed'),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                if (isAvailable && bookId != null) {
                  popupUpdateDialog(book);
                }
              },
              icon: Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {
                if (isAvailable && bookId != null) {
                  popupDeleteDialog(book);
                }
              },
              icon: Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }

  void popupBorrowDialog(Map<String, dynamic> book) {
    final now = DateTime.now();
    final authProvider = context.read<AuthProvider>();
    final username = authProvider.currentUser?['username'] ?? 'Unknown User';

    // Default due date: 30 days from now
    DateTime selectedDueDate = now.add(const Duration(days: 30));

    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Borrow Book'),
              content: Container(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Do you want to borrow this book?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Text("Title: ${book['title'] ?? 'Unknown'}"),
                    Text("Authors: ${book['authors'] ?? 'Unknown'}"),
                    Text("Publishers: ${book['publishers'] ?? 'Unknown'}"),
                    Text("ISBN: ${book['isbn'] ?? 'Unknown'}"),
                    const SizedBox(height: 20),
                    Text("Borrower: $username"),
                    Text("Borrowed Date: ${now.toString().split(' ')[0]}"),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Due Date: ${selectedDueDate.toString().split(' ')[0]}",
                        ),
                        TextButton.icon(
                          icon: const Icon(Icons.calendar_today),
                          label: const Text('Change'),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDueDate,
                              firstDate: now,
                              lastDate: now.add(const Duration(days: 365)),
                            );
                            if (picked != null) {
                              setState(() {
                                selectedDueDate = picked;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.orange.shade700,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Note: This will be implemented once the backend API endpoint is ready.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.orange.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // TODO: Implement actual API call when backend endpoint is ready
                    // Expected endpoint: POST /books/borrow
                    // Body: { book_id: book['book_id'], due_date: selectedDueDate }
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Borrow functionality will be available once the backend API endpoint is implemented. See BACKEND_CHANGE_REQUIREMENTS.md for details.',
                        ),
                        duration: Duration(seconds: 5),
                      ),
                    );
                  },
                  child: const Text('Borrow'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void popupUpdateDialog(Map<String, dynamic> book) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Book'),
          content: Container(
            width: 400,
            height: 400,
            child: SingleChildScrollView(
              child: BookForm(mode: 1, bookId: book['book_id'] ?? -1),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void popupDeleteDialog(Map<String, dynamic> book) {
    final bookId = book['book_id'] as int?;

    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Book'),
          content: Text(
            'Do you really want to delete "${book['title'] ?? 'Unknown'}"?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                if (bookId != null) {
                  final success = await context.read<BookProvider>().deleteBook(
                    bookId,
                  );
                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Deleted "${book['title'] ?? 'Unknown'}".',
                        ),
                      ),
                    );
                  } else if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to delete book'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}
