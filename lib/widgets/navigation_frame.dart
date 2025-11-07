import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../main.dart';

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

class _NavigationFrameState extends State<NavigationFrame> with RouteAware {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final route = ModalRoute.of(context);
      if (route != null && route is PageRoute) {
        routeObserver.subscribe(this, route);
      }
    });
  }

  @override
  void didPopNext() {
    _updateIndexFromRoute();
  }

  @override
  void didPush() {
    _updateIndexFromRoute();
  }

  void _updateIndexFromRoute() {
    final routeName = ModalRoute.of(context)?.settings.name ?? '/';
    setState(() {
      _currentIndex = _getIndexFromRoute(routeName);
    });
  }

  int _getIndexFromRoute(String routeName) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isAdmin = authProvider.isAdmin;
    
    if (!isAdmin) {
      // For non-admin: Home(0), Dashboard(1), BookList(2)
      switch (routeName) {
        case '/home':
          return 0;
        case '/dashboard':
          return 1;
        case '/booklist':
          return 2;
        default:
          return 0;
      }
    } else {
      // For admin: Home(0), Dashboard(1), AddBook(2), BookList(3), Users(4), Settings(5)
      switch (routeName) {
        case '/home':
          return 0;
        case '/dashboard':
          return 1;
        case '/add':
          return 2;
        case '/booklist':
          return 3;
        case '/user-management':
          return 4;
        case '/settings':
          return 5;
        default:
          return 0;
      }
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  void _showUserMenu(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User info
              ListTile(
                leading: CircleAvatar(
                  child: Text(
                    (user?['username'] ?? 'U')[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  user?['displayName'] ?? user?['username'] ?? 'User',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(user?['email'] ?? ''),
              ),
              const Divider(),

              // Change password
              ListTile(
                leading: const Icon(Icons.lock_outline),
                title: const Text('Change Password'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/change-password');
                },
              ),

              // Logout
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  await authProvider.logout();
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final isAdmin = authProvider.isAdmin;
        
        // Build navigation destinations based on user role
        List<NavigationRailDestination> destinations = [
          const NavigationRailDestination(
            icon: Icon(Icons.home_outlined),
            label: Text('Home'),
            selectedIcon: Icon(Icons.home),
          ),
          const NavigationRailDestination(
            icon: Icon(Icons.dashboard_outlined),
            label: Text('Dashboard'),
            selectedIcon: Icon(Icons.dashboard),
          ),
        ];

        // Add Book is admin-only
        if (isAdmin) {
          destinations.add(
            const NavigationRailDestination(
              icon: Icon(Icons.my_library_add_outlined),
              label: Text('Add Book'),
              selectedIcon: Icon(Icons.my_library_add),
            ),
          );
        }

        destinations.add(
          const NavigationRailDestination(
            icon: Icon(Icons.library_books_outlined),
            label: Text('Book List'),
            selectedIcon: Icon(Icons.library_books),
          ),
        );

        // User Management is admin-only
        if (isAdmin) {
          destinations.add(
            const NavigationRailDestination(
              icon: Icon(Icons.people_outlined),
              label: Text('Users'),
              selectedIcon: Icon(Icons.people),
            ),
          );
        }

        // Settings is admin-only
        if (isAdmin) {
          destinations.add(
            const NavigationRailDestination(
              icon: Icon(Icons.settings_outlined),
              label: Text('Settings'),
              selectedIcon: Icon(Icons.settings),
            ),
          );
        }

        return Scaffold(
          body: Row(
            children: [
              NavigationRail(
                backgroundColor: Colors.grey.shade100,
                selectedIndex: _currentIndex,
                groupAlignment: -1.0,
                labelType: NavigationRailLabelType.all,
                leading: authProvider.isAuthenticated
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          icon: CircleAvatar(
                            child: Text(
                              (authProvider.currentUser?['username'] ?? 'U')[0]
                                  .toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          onPressed: () => _showUserMenu(context),
                          tooltip: 'User Menu',
                        ),
                      )
                    : null,
                onDestinationSelected: (int index) {
                  setState(() {
                    _currentIndex = index;
                    // Map index to routes based on visible destinations
                    String route = _getRouteForIndex(index, isAdmin);
                    Navigator.pushNamed(context, route);
                  });
                },
                destinations: destinations,
              ),
              Expanded(child: Center(child: widget.child)),
            ],
          ),
        );
      },
    );
  }

  String _getRouteForIndex(int index, bool isAdmin) {
    if (!isAdmin) {
      // For non-admin: Home(0), Dashboard(1), BookList(2)
      switch (index) {
        case 0:
          return '/home';
        case 1:
          return '/dashboard';
        case 2:
          return '/booklist';
        default:
          return '/home';
      }
    } else {
      // For admin: Home(0), Dashboard(1), AddBook(2), BookList(3), Users(4), Settings(5)
      switch (index) {
        case 0:
          return '/home';
        case 1:
          return '/dashboard';
        case 2:
          return '/add';
        case 3:
          return '/booklist';
        case 4:
          return '/user-management';
        case 5:
          return '/settings';
        default:
          return '/home';
      }
    }
  }
}
