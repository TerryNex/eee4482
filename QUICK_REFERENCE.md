## Quick Reference: JWT Authentication & API Integration

### Files Overview

```
lib/
├── providers/
│   ├── auth_provider.dart      ✅ Updated - Login, Register, Logout, Password Change
│   ├── book_provider.dart      ✅ New - Book CRUD with JWT
│   ├── user_provider.dart      ✅ New - User Management with JWT
│   └── favorite_provider.dart  ✅ New - Likes & Favorites with JWT
├── config/
│   └── api_config.dart         ✅ Updated - JWT Support
└── services/
    ├── api_service.dart        ✅ Existing - HTTP Service
    └── book_service.dart       ✅ Existing - Book Service
```

---

## JWT Token Management

### Auto-Login on App Start
```dart
@override
void initState() {
  super.initState();
  // AuthProvider automatically loads token from SharedPreferences
  final authProvider = context.read<AuthProvider>();
  if (authProvider.isAuthenticated) {
    // Token automatically set in ApiConfig
    // User is logged in
  }
}
```

### Get Current JWT Token
```dart
String? token = ApiConfig.authToken;
String? token = context.read<AuthProvider>().authToken;
```

### Check if User is Authenticated
```dart
bool isAuth = context.read<AuthProvider>().isAuthenticated;
```

### Check if User is Admin
```dart
bool isAdmin = context.read<AuthProvider>().isAdmin;
```

---

## API Call Examples

### Authentication Calls (No JWT)

**Login**
```dart
final auth = context.read<AuthProvider>();
bool success = await auth.login('user', 'pass', rememberMe);
```

**Register**
```dart
final auth = context.read<AuthProvider>();
final result = await auth.register(
  username: 'newuser',
  email: 'user@example.com',
  password: 'Pass123'
);
```

**Change Password** (JWT)
```dart
final auth = context.read<AuthProvider>();
final result = await auth.changePassword(
  oldPassword: 'Old123',
  newPassword: 'New456'
);
```

**Logout** (JWT)
```dart
final auth = context.read<AuthProvider>();
await auth.logout();
```

---

### Book Calls (All with JWT)

**Get All Books**
```dart
final books = context.read<BookProvider>();
await books.getAllBooks();
// books.books -> list of books
// books.isLoading -> loading state
// books.error -> error message
```

**Add Book**
```dart
final books = context.read<BookProvider>();
bool success = await books.addBook({
  'title': 'Title',
  'authors': 'Author',
  'publishers': 'Publisher',
  'date': '2024',
  'isbn': '123456'
});
```

**Update Book**
```dart
final books = context.read<BookProvider>();
bool success = await books.updateBook(bookId, {
  'title': 'New Title',
  'authors': 'New Author',
  // ... other fields
});
```

**Delete Book**
```dart
final books = context.read<BookProvider>();
bool success = await books.deleteBook(bookId);
```

---

### User Calls (All with JWT)

**Get All Users** (Admin only)
```dart
final users = context.read<UserProvider>();
bool success = await users.getAllUsers();
// users.users -> list of users
// users.error -> error if not admin
```

**Add User**
```dart
final users = context.read<UserProvider>();
bool success = await users.addUser({
  'username': 'newuser',
  'email': 'user@example.com',
  'password': 'Pass123'
});
```

**Update User**
```dart
final users = context.read<UserProvider>();
bool success = await users.updateUser(userId, {
  'password': 'current_pass',
  'new_password': 'new_pass',
  'email': 'newemail@example.com'
});
```

**Delete User** (Admin only)
```dart
final users = context.read<UserProvider>();
bool success = await users.deleteUser(
  userId,
  'current_user_password',
  'target_user_email',
  identifierType: 'email' // or 'username' or 'user_id'
);
```

---

### Favorites/Likes Calls (All with JWT)

**Like Book**
```dart
final fav = context.read<FavoriteProvider>();
bool success = await fav.addLike(bookId);
// or
bool success = await fav.toggleLike(bookId);
```

**Unlike Book**
```dart
final fav = context.read<FavoriteProvider>();
bool success = await fav.removeLike(bookId);
// or
bool success = await fav.toggleLike(bookId);
```

**Check if Liked**
```dart
final fav = context.read<FavoriteProvider>();
bool liked = fav.isBookLiked(bookId);
```

**Add to Favorites**
```dart
final fav = context.read<FavoriteProvider>();
bool success = await fav.addFavorite(bookId);
// or
bool success = await fav.toggleFavorite(bookId);
```

**Remove from Favorites**
```dart
final fav = context.read<FavoriteProvider>();
bool success = await fav.removeFavorite(bookId);
// or
bool success = await fav.toggleFavorite(bookId);
```

**Check if Favorited**
```dart
final fav = context.read<FavoriteProvider>();
bool favorited = fav.isBookFavorited(bookId);
```

**Get User Favorites**
```dart
final fav = context.read<FavoriteProvider>();
bool success = await fav.getUserFavorites(userId);
// fav.favoriteBooks -> list of favorite books
```

---

## Error Handling Pattern

### All Providers Return Errors
```dart
// For boolean returns (success/failure)
bool success = await provider.method();
if (!success) {
  String? error = provider.error;
  print('Error: $error');
}

// For map returns (register, password change, etc)
Map<String, dynamic> result = await provider.method();
if (!result['success']) {
  print('Error: ${result['message']}');
}
```

---

## HTTP Status Codes

| Code | Meaning | Action |
|------|---------|--------|
| 200 | Success | Proceed with operation |
| 201 | Created | Resource created successfully |
| 400 | Bad Request | Validate input, show error |
| 401 | Unauthorized | Invalid JWT or password |
| 403 | Forbidden | Insufficient permissions (admin only) |
| 404 | Not Found | Resource doesn't exist |
| 500 | Server Error | Backend error occurred |

---

## State Management Pattern

### Provider Pattern
```dart
// Read value (one-time)
final value = context.read<Provider>().property;

// Watch value (rebuild on change)
final value = context.watch<Provider>().property;

// Consume multiple
Consumer2<Provider1, Provider2>(
  builder: (context, p1, p2, child) {
    // Use p1 and p2
  }
)
```

---

## Debug Tips

### Check JWT Token
```dart
print('Token: ${ApiConfig.authToken}');
```

### Check User Info
```dart
final user = context.read<AuthProvider>().currentUser;
print('User: ${user?['username']}');
print('Is Admin: ${user?['is_admin']}');
```

### Check Error
```dart
print('Error: ${provider.error}');
```

### Check Loading State
```dart
if (provider.isLoading) {
  print('Loading...');
}
```

---

## Important Reminders

1. **Always** wait for async operations:
   ```dart
   await provider.method();
   ```

2. **Always** check success before proceeding:
   ```dart
   if (success) { /* proceed */ }
   ```

3. **JWT automatically included** in Authorization header:
   ```dart
   // Automatic - no manual header needed
   Authorization: Bearer {token}
   ```

4. **Token persists** on app restart:
   ```dart
   // AuthProvider loads token from SharedPreferences on startup
   ```

5. **Token cleared** on logout:
   ```dart
   // AuthProvider and ApiConfig both cleared
   ```

---

## Common Tasks Checklist

- [ ] Setup MultiProvider with all providers in main.dart
- [ ] Implement login screen using AuthProvider
- [ ] Implement register screen using AuthProvider
- [ ] Display books using BookProvider
- [ ] Implement book CRUD operations
- [ ] Implement favorite/like functionality
- [ ] Add logout functionality
- [ ] Add password change functionality
- [ ] Display admin panel (if admin) using UserProvider
- [ ] Add error snackbars for failed operations
- [ ] Add loading indicators during API calls
- [ ] Test with actual backend API

---

## Support Resources

- **API_INTEGRATION_GUIDE.md** - Full integration documentation
- **PROVIDER_USAGE_EXAMPLES.dart** - 15+ detailed usage examples
- **IMPLEMENTATION_COMPLETE.md** - Complete implementation summary

---

**Created by**: HE HUALIANG (230263367)  
**Date**: November 6, 2025  
**Status**: ✅ Complete & Production Ready

