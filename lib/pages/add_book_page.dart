import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/navigation_frame.dart';
import '../widgets/book_form.dart';
import '../widgets/personal_info.dart';
import '../providers/auth_provider.dart';

class AddBookPage extends StatefulWidget {
  AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Check if user is admin
        if (!authProvider.isAdmin) {
          // Redirect non-admin users
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/home');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Add Book page is only accessible to administrators'),
                backgroundColor: Colors.red,
              ),
            );
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return NavigationFrame(
          selectedIndex: 2,
          child: Column(
            children: [
              PersonalInfoWidget(),
              Expanded(child: Container(width: 600, child: BookForm(mode: 0))),
            ],
          ),
        );
      },
    );
  }
}
