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
    switch (routeName) {
      case '/home':
        return 0;
      case '/dashboard':
        return 1;
      case '/add':
        return 2;
      case '/booklist':
        return 3;
      case '/settings':
        return 4;
      default:
        return 0;
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
                    switch (index) {
                      case 0:
                        Navigator.pushNamed(context, '/home');
                        break;
                      case 1:
                        Navigator.pushNamed(context, '/dashboard');
                        break;
                      case 2:
                        Navigator.pushNamed(context, '/add');
                        break;
                      case 3:
                        Navigator.pushNamed(context, '/booklist');
                        break;
                      case 4:
                        Navigator.pushNamed(context, '/settings');
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
                    icon: Icon(Icons.dashboard_outlined),
                    label: Text('Dashboard'),
                    selectedIcon: Icon(Icons.dashboard),
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
                    icon: Icon(Icons.settings_outlined),
                    label: Text('Settings'),
                    selectedIcon: Icon(Icons.settings),
                  ),
                ],
              ),
              Expanded(child: Center(child: widget.child)),
            ],
          ),
        );
      },
    );
  }
}
