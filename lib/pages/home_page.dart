import 'package:flutter/material.dart';
import '../widgets/navigation_frame.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  int selectedIndex = 0;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var username = "HE HUALIANG (230263367)";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Home Page')),
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
