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
              return Center(child: CircularProgressIndicator());
            }

            if (bookProvider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, size: 64, color: Colors.red),
                    SizedBox(height: 16),
                    Text('Error: ${bookProvider.error}'),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => bookProvider.getAllBooks(),
                      child: Text('Retry'),
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
    final isAvailable = (status is int ? status : int.tryParse(status.toString())) == 0;
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
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reserve Book'),
          content: Container(
            height: 150,
            child: Column(
              children: [
                Text('Do you want to reserve the book with following details?'),
                Container(height: 30),
                Container(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Date:" + now.toString()),
                      Text("Title: " + book['title']),
                      Text("Publishers: " + book['publishers']),
                      Text("ISBN: " + book['isbn']),
                      Text("Borrower: " + "HE HUALIANG (230263367)"),
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
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Borrowed "' + book['title'] + '".')),
                );
              },
              child: Text('Yes'),
            ),
          ],
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
            child: SingleChildScrollView(child: BookForm(mode: 1)),
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
          title: Text('Delete Book'),
          content: Text(
            'Do you really want to delete "' + (book['title'] ?? 'Unknown') + '"?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                if (bookId != null) {
                  final success = await context.read<BookProvider>().deleteBook(bookId);
                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Deleted "' + (book['title'] ?? 'Unknown') + '".')),
                    );
                  } else if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to delete book'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}
