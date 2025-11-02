/// Home Page for EEE4482 e-Library Application
/// Displays welcome message with student information

import 'package:flutter/material.dart';
import '../widgets/navigation_frame.dart';

/// HomePage widget displays the landing page of the e-Library application
/// Shows the application title and student information
class HomePage extends StatefulWidget {
  HomePage({super.key});

  int selectedIndex = 0;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Student information - Update this with your details
  var username = "HE HUALIANG (230263367)";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NavigationFrame(
        selectedIndex: 0,
        child: Container(
          child: Text(
            'EEE4482 e-Library\nWelcome, ' + username,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
