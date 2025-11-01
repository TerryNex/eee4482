import 'package:flutter/material.dart';
import '../widgets/navigation_frame.dart';
import '../widgets/book_form.dart';

class BooklistPage extends StatefulWidget {
  List<Map<String, dynamic>> bookList = [
    {
      'title': 'Book 1',
      'author': 'terry',
      'publishers': 'terry',
      'date': '1995-06-06',
      'isbn': '123-4-5678-90123-4',
      'status': '1',
    },
    {
      'title': 'Book 2',
      'author': 'alice',
      'publishers': 'alice',
      'date': '2000-01-01',
      'isbn': '987-6-5432-10987-6',
      'status': '0',
    },
    {
      'title': 'Book 3',
      'author': 'bob',
      'publishers': 'bob',
      'date': '2010-12-12',
      'isbn': '456-7-8901-23456-7',
      'status': '1',
    },
  ];

  BooklistPage({super.key});

  @override
  State<BooklistPage> createState() => _BooklistPageState();
}

class _BooklistPageState extends State<BooklistPage> {
  @override
  Widget build(BuildContext context) {
    return NavigationFrame(
      selectedIndex: 2,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: createBookLists(widget.bookList),
      ),
    );
  }

  Widget createBookLists(List<dynamic> books) {
    return ListView(
      children: [for (var book in books!) createSingleBookRecord(book)],
    );
  }

  Widget createSingleBookRecord(Map<String, dynamic> book) {
    return Card(
      child: ListTile(
        enabled: int.parse(book['status']) == 0 ? true : false,
        onTap: () {
          popupBorrowDialog(book);
        },
        leading: Icon(Icons.book, size: 48),
        title: Text(
          book['title'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Author: ' +
              book['author'] +
              '\nPublishers: ' +
              book['publishers'] +
              '\nDate: ' +
              book['date'] +
              '\nISBN: ' +
              book['isbn'],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                if (int.parse(book['status']) == 0) {
                  popupUpdateDialog(book);
                }
              },
              icon: Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {
                if (int.parse(book['status']) == 0) {
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
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Book'),
          content: Text(
            'Do you really want to delete "' + book['title'] + '"?',
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
                  SnackBar(content: Text('Deleted "' + book['title'] + '".')),
                );
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}
