<?php
/**
 * PHP BACKEND API - QUICK REFERENCE GUIDE
 * Student: HE HUALIANG (230263367)
 * Date: November 6, 2025
 */

/**
 * ============================================================================
 * INSTALLATION & SETUP
 * ============================================================================
 */

// Ensure these are in your .env file:
// EEE4482JWT=your_jwt_secret_key_here
// DB_HOST=localhost
// DB_NAME=elibrary_db
// DB_USER=root
// DB_PASS=password

/**
 * ============================================================================
 * API BASE URL
 * ============================================================================
 */

// Base URL: http://192.168.50.9/api
// All endpoints are relative to this base

/**
 * ============================================================================
 * AUTHENTICATION ENDPOINTS
 * ============================================================================
 */

// LOGIN - Get JWT Token
POST /auth/login
{
    "username": "user@example.com",
    "password": "password123"
}
Response 200:
{
    "token": "jwt_token_here",
    "user_id": 1,
    "username": "user@example.com",
    "email": "user@example.com",
    "is_admin": 0,
    "last_login": "2024-11-06T10:30:45",
    "exp": 1730000000
}

// REGISTER - Create New Account
POST /auth/register
{
    "username": "newuser",
    "email": "newuser@example.com",
    "password": "SecurePass123"
}
Response 201:
{
    "user_id": 5
}

// LOGOUT - Invalidate Session
POST /auth/logout
Headers: Authorization: Bearer {jwt_token}
Response 200:
{
    "success": true,
    "message": "Logged out successfully"
}

/**
 * ============================================================================
 * BOOK ENDPOINTS
 * ============================================================================
 */

// GET ALL BOOKS (No auth required)
GET /books/all
Response 200:
[
    {
        "book_id": 1,
        "title": "Flutter Guide",
        "authors": "John Doe",
        "publishers": "Tech Publishing",
        "date": "2024",
        "isbn": "978-1234567890"
    }
]

// ADD BOOK (JWT required)
POST /books/add
Headers: Authorization: Bearer {jwt_token}
{
    "title": "New Book",
    "authors": "Author Name",
    "publishers": "Publisher",
    "date": "2024",
    "isbn": "978-0000000000"
}
Response 201:
{
    "success": true,
    "book_id": 15
}

// UPDATE BOOK (JWT required)
PUT /books/update/{book_id}
Headers: Authorization: Bearer {jwt_token}
{
    "title": "Updated Title",
    "authors": "Updated Author"
}
Response 200:
{
    "success": true
}

// DELETE BOOK (JWT required)
DELETE /books/delete/{book_id}
Headers: Authorization: Bearer {jwt_token}
Response 200:
{
    "success": true
}

/**
 * ============================================================================
 * USER ENDPOINTS
 * ============================================================================
 */

// GET ALL USERS (JWT required)
GET /user/all
Headers: Authorization: Bearer {jwt_token}
Response 200:
[
    {
        "user_id": 1,
        "username": "john_doe",
        "email": "john@example.com",
        "is_admin": 1,
        "last_login": "2024-11-06T10:30:45",
        "created_at": "2024-11-01T12:00:00"
    }
]

// ADD USER (JWT required)
POST /user/add
Headers: Authorization: Bearer {jwt_token}
{
    "username": "newuser",
    "email": "newuser@example.com",
    "password": "SecurePass123"
}
Response 201:
{
    "success": true,
    "user_id": 10
}

// UPDATE USER (JWT required)
PUT /user/update/{user_id}
Headers: Authorization: Bearer {jwt_token}
{
    "password": "current_password",
    "new_password": "NewPassword123",
    "email": "newemail@example.com"
}
Response 200:
{
    "success": true
}

// DELETE USER (Admin + JWT required)
DELETE /user/delete/{user_id}
Headers: Authorization: Bearer {jwt_token}
{
    "password": "admin_password",
    "user_id_delete": 5
}
// or delete by email:
{
    "password": "admin_password",
    "email": "user@example.com"
}
// or delete by username:
{
    "password": "admin_password",
    "username": "username_to_delete"
}
Response 200:
{
    "success": true
}

/**
 * ============================================================================
 * LIKE ENDPOINTS
 * ============================================================================
 */

// ADD LIKE (JWT required)
POST /user/like
Headers: Authorization: Bearer {jwt_token}
{
    "book_id": 1
}
Response 200:
{
    "success": true
}

// REMOVE LIKE (JWT required)
DELETE /user/like
Headers: Authorization: Bearer {jwt_token}
{
    "book_id": 1
}
Response 200:
{
    "success": true
}

/**
 * ============================================================================
 * FAVORITE ENDPOINTS
 * ============================================================================
 */

// ADD FAVORITE (JWT required)
POST /user/favorite
Headers: Authorization: Bearer {jwt_token}
{
    "book_id": 1
}
Response 200:
{
    "success": true
}

// REMOVE FAVORITE (JWT required)
DELETE /user/favorite
Headers: Authorization: Bearer {jwt_token}
{
    "book_id": 1
}
Response 200:
{
    "success": true
}

// GET USER FAVORITES (JWT required)
GET /user/{user_id}/favorites
Headers: Authorization: Bearer {jwt_token}
Response 200:
[
    {
        "book_id": 1,
        "title": "Favorite Book",
        "authors": "Author Name",
        "publishers": "Publisher",
        "date": "2024",
        "isbn": "978-1234567890"
    }
]

/**
 * ============================================================================
 * COMMON CURL EXAMPLES
 * ============================================================================
 */

// Login and get JWT
/*
curl -X POST http://192.168.50.9/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"user","password":"pass"}'
*/

// Add book with JWT
/*
curl -X POST http://192.168.50.9/api/books/add \
  -H "Authorization: Bearer {jwt_token}" \
  -H "Content-Type: application/json" \
  -d '{"title":"Book","authors":"Author","publishers":"Pub","date":"2024","isbn":"123"}'
*/

// Get user favorites with JWT
/*
curl -X GET http://192.168.50.9/api/user/1/favorites \
  -H "Authorization: Bearer {jwt_token}"
*/

/**
 * ============================================================================
 * ERROR RESPONSES
 * ============================================================================
 */

// 400 - Bad Request (Missing required fields)
{
    "message": "Title and authors are required"
}

// 401 - Unauthorized (Invalid JWT or password)
{
    "error": "Unauthorized"
}

// 403 - Forbidden (Admin-only operation)
{
    "error": "❌No permission! Only admins can delete users"
}

// 404 - Not Found
{
    "error": "Book not found"
}

// 409 - Conflict (Duplicate)
{
    "message": "Username already exists"
}

// 500 - Server Error
{
    "message": "Database error message"
}

/**
 * ============================================================================
 * IMPORTANT NOTES
 * ============================================================================
 */

// 1. JWT Token
//    - Obtain from /auth/login
//    - Include in header: Authorization: Bearer {token}
//    - Expires in 1 hour
//    - User ID extracted automatically from token

// 2. All Passwords
//    - Hashed with PASSWORD_DEFAULT (bcrypt)
//    - Minimum 8 characters recommended
//    - Mix of letters and numbers required

// 3. Admin Operations
//    - Only users with is_admin=1 can delete other users
//    - DeleteUser requires admin password verification

// 4. Cascading Deletes
//    - Deleting book removes related likes/favorites
//    - Deleting user removes related likes/favorites

// 5. Duplicate Prevention
//    - AddLike uses INSERT IGNORE
//    - AddFavorite uses INSERT IGNORE
//    - Prevents duplicate records

// 6. Transactions
//    - All database operations use transactions
//    - Automatic rollback on errors
//    - Ensures data consistency

/**
 * ============================================================================
 * STATUS CODES REFERENCE
 * ============================================================================
 */

/*
200 OK - Successful GET or operation
201 Created - Resource successfully created
400 Bad Request - Missing or invalid fields
401 Unauthorized - Invalid JWT or password
403 Forbidden - Insufficient permissions
404 Not Found - Resource doesn't exist
409 Conflict - Duplicate resource
500 Internal Server Error - Server-side error
*/

/**
 * ============================================================================
 * ENDPOINTS SUMMARY TABLE
 * ============================================================================
 */

/*
Method  | Endpoint                    | JWT | Status Code | Purpose
--------|-----------------------------|----|------------|--------
POST    | /auth/login                 | ❌  | 200/401    | Get JWT token
POST    | /auth/register              | ❌  | 201/500    | Create account
POST    | /auth/logout                | ✅  | 200/401    | Logout session
GET     | /books/all                  | ❌  | 200/500    | Get all books
POST    | /books/add                  | ✅  | 201/400    | Create book
PUT     | /books/update/{id}          | ✅  | 200/404    | Update book
DELETE  | /books/delete/{id}          | ✅  | 200/404    | Delete book
GET     | /user/all                   | ✅  | 200/401    | Get all users
POST    | /user/add                   | ✅  | 201/409    | Create user
PUT     | /user/update/{id}           | ✅  | 200/401    | Update user
DELETE  | /user/delete/{id}           | ✅  | 200/403    | Delete user
POST    | /user/like                  | ✅  | 200/401    | Like book
DELETE  | /user/like                  | ✅  | 200/401    | Unlike book
POST    | /user/favorite              | ✅  | 200/401    | Add favorite
DELETE  | /user/favorite              | ✅  | 200/401    | Remove favorite
GET     | /user/{id}/favorites        | ✅  | 200/401    | Get favorites
*/

?>

