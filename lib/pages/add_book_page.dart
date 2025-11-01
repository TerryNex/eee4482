import 'package:flutter/material.dart';
import '../widgets/navigation_frame.dart';
import '../widgets/book_form.dart';

class AddBookPage extends StatefulWidget {
  AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  @override
  Widget build(BuildContext context) {
    return NavigationFrame(
      selectedIndex: 1,
      child: Container(width: 600, child: BookForm(mode: 0)),
    );
  }
}
