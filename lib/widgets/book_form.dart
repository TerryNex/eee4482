import 'package:eee4482_flutter_app1/widgets/input_box.dart';
import 'package:flutter/material.dart';
import '../widgets/input_box.dart';

class BookForm extends StatefulWidget {
  final int mode; // 0: Add, 1: Edit
  final int bookId;
  const BookForm({super.key, required this.mode, this.bookId = -1});

  @override
  State<BookForm> createState() => _BookFormState();
}

class _BookFormState extends State<BookForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _publishersController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputBox(
          name: 'Title',
          hint: 'Enter book title',
          controller: _titleController,
        ),
        InputBox(
          name: 'Authors',
          hint: 'Enter author name',
          controller: _authorController,
        ),
        InputBox(
          name: 'Publishers',
          hint: 'Enter ....',
          controller: _publishersController,
        ),
        InputBox(
          name: 'Date',
          hint: 'e.g. 26 June 1996',
          controller: _dateController,
        ),
        InputBox(
          name: 'ISBN',
          hint: 'e.g. 123-0-1234-1234-0',
          controller: _isbnController,
        ),
        Container(
          margin: EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 20),
          alignment: Alignment.centerLeft,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              textStyle: const TextStyle(fontSize: 14),
            ),
            onPressed: () {
              if (widget.mode == 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added ' + _titleController.text + '.'),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Updated ' + _titleController.text + '.'),
                  ),
                );
              }
            },
            child: Text('Submit'),
          ),
        ),
      ],
    );
  }
}
