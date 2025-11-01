import 'package:flutter/material.dart';

class NavigationFrame extends StatefulWidget {
  Widget child;
  int selectedIndex = 0;

  NavigationFrame({
    required this.selectedIndex,
    super.key,
    required this.child,
  });
  @override
  State<NavigationFrame> createState() => _NavigationFrameState();
}

class _NavigationFrameState extends State<NavigationFrame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            backgroundColor: Colors.grey.shade100,
            selectedIndex: widget.selectedIndex,
            groupAlignment: -1.0,
            labelType: NavigationRailLabelType.all,

            onDestinationSelected: (int index) {
              setState(() {
                widget.selectedIndex = index;
                switch (index) {
                  case 0:
                    Navigator.pushNamed(context, '/home');
                    break;
                  case 1:
                    Navigator.pushNamed(context, '/add');
                    break;
                  case 2:
                    Navigator.pushNamed(context, '/booklist');
                    break;
                  default:
                    Navigator.pushNamed(context, '/');
                }
              });
            },
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.home_outlined),
                label: Text('Home'),
                selectedIcon: Icon(Icons.home),
              ),

              NavigationRailDestination(
                icon: Icon(Icons.my_library_add_outlined),
                label: Text('Add Book'),
                selectedIcon: Icon(Icons.my_library_add),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.library_books_outlined),
                label: Text('Book List'),
                selectedIcon: Icon(Icons.library_books),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.logout_outlined),
                label: Text('Logout'),
                selectedIcon: Icon(Icons.logout),
              ),
            ],
          ),
          Expanded(child: Center(child: widget.child)),
        ],
      ),
    );
  }
}
