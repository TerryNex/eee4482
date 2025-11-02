import 'package:flutter/material.dart';
import '../widgets/input_box.dart';
import '../utils/validators.dart';
import '../services/book_service.dart';
import '../services/api_service.dart';

class BookForm extends StatefulWidget {
  final int mode; // 0: Add, 1: Edit
  final int bookId;
  final Map<String, dynamic>? initialData;
  final VoidCallback? onSuccess;
  
  const BookForm({
    super.key,
    required this.mode,
    this.bookId = -1,
    this.initialData,
    this.onSuccess,
  });

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

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _populateForm(widget.initialData!);
    }
  }

  void _populateForm(Map<String, dynamic> data) {
    _titleController.text = data['title'] ?? '';
    _authorController.text = data['author'] ?? '';
    _publishersController.text = data['publishers'] ?? '';
    _dateController.text = data['date'] ?? '';
    _isbnController.text = data['isbn'] ?? '';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _publishersController.dispose();
    _dateController.dispose();
    _isbnController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    // Validate all fields
    if (!_validateAllFields()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final bookData = {
        'title': _titleController.text.trim(),
        'author': _authorController.text.trim(),
        'publishers': _publishersController.text.trim(),
        'date': _dateController.text.trim(),
        'isbn': _isbnController.text.trim(),
      };

      if (widget.mode == 0) {
        // Add new book
        await BookService.addBook(bookData);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Successfully added "${_titleController.text}"'),
              backgroundColor: Colors.green,
            ),
          );
          _clearForm();
          if (widget.onSuccess != null) {
            widget.onSuccess!();
          }
        }
      } else {
        // Update existing book
        await BookService.updateBook(widget.bookId, bookData);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Successfully updated "${_titleController.text}"'),
              backgroundColor: Colors.green,
            ),
          );
          if (widget.onSuccess != null) {
            widget.onSuccess!();
          }
        }
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.message;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'An unexpected error occurred';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An unexpected error occurred: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  bool _validateAllFields() {
    return _formKey.currentState?.validate() ?? false;
  }

  void _clearForm() {
    _titleController.clear();
    _authorController.clear();
    _publishersController.clear();
    _dateController.clear();
    _isbnController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_errorMessage != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          InputBox(
            name: 'Title',
            hint: 'Enter book title',
            controller: _titleController,
            validator: Validators.bookTitle,
            enabled: !_isLoading,
          ),
          InputBox(
            name: 'Author',
            hint: 'Enter author name',
            controller: _authorController,
            validator: Validators.authorName,
            enabled: !_isLoading,
          ),
          InputBox(
            name: 'Publisher',
            hint: 'Enter publisher name',
            controller: _publishersController,
            validator: Validators.publisherName,
            enabled: !_isLoading,
          ),
          InputBox(
            name: 'Publication Date',
            hint: 'YYYY-MM-DD (e.g., 1996-06-26)',
            controller: _dateController,
            validator: Validators.publicationDate,
            keyboardType: TextInputType.datetime,
            enabled: !_isLoading,
          ),
          InputBox(
            name: 'ISBN',
            hint: 'e.g., 978-3-16-148410-0',
            controller: _isbnController,
            validator: Validators.isbnRequired,
            enabled: !_isLoading,
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 20),
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                textStyle: const TextStyle(fontSize: 14),
              ),
              onPressed: _isLoading ? null : _handleSubmit,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(widget.mode == 0 ? 'Add Book' : 'Update Book'),
            ),
          ),
        ],
      ),
    );
  }
}

