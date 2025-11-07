<?php
/**
 * PHP Backend API - E-Library Management System
 * Student: HE HUALIANG (230263367)
 *
 * This file documents all the completed PHP backend services with JWT authentication
 */

/**
 * ============================================================================
 * AUTHENTICATION SERVICES
 * ============================================================================
 */

/**
 * UserLogin - POST /auth/login
 * Description: Authenticate user and generate JWT token
 *
 * Request Body:
 * {
 *     "username": "string",
 *     "password": "string"
 * }
 *
 * Success Response (200):
 * {
 *     "token": "jwt_token_here",
 *     "user_id": 1,
 *     "username": "john_doe",
 *     "email": "john@example.com",
 *     "is_admin": 0,
 *     "last_login": "2024-11-06 10:30:45",
 *     "exp": 1730000000
 * }
 *
 * Error Response (401):
 * {
 *     "error": "Invalid username or password"
 * }
 *
 * Features:
 * - Password verification using password_verify()
 * - JWT token generation with 1-hour expiration
 * - Updates last_login timestamp
 * - Returns complete user info with token
 */

/**
 * UserRegistration - POST /auth/register
 * Description: Register new user account
 *
 * Request Body:
 * {
 *     "username": "string",
 *     "email": "string",
 *     "password": "string"
 * }
 *
 * Success Response (201):
 * {
 *     "user_id": 5
 * }
 *
 * Error Response (500):
 * {
 *     "message": "Username already exists"
 * }
 * or
 * {
 *     "message": "Email already exists"
 * }
 *
 * Features:
 * - Checks for duplicate username
 * - Checks for duplicate email
 * - Hashes password using PASSWORD_DEFAULT
 * - Transaction support
 */

/**
 * UserLogout - POST /auth/logout
 * Description: Logout user (JWT required)
 *
 * Headers Required:
 * Authorization: Bearer {jwt_token}
 *
 * Success Response (200):
 * {
 *     "success": true,
 *     "message": "Logged out successfully"
 * }
 *
 * Error Response (401):
 * {
 *     "error": "Unauthorized"
 * }
 *
 * Features:
 * - Validates JWT token via middleware
 * - Frontend clears token on their end
 */

/**
 * ============================================================================
 * BOOK SERVICES
 * ============================================================================
 */

/**
 * GetAllBooks - GET /books/all
 * Description: Get all books from the system
 *
 * Success Response (200):
 * [
 *     {
 *         "book_id": 1,
 *         "title": "Flutter Guide",
 *         "authors": "John Doe",
 *         "publishers": "Tech Publishing",
 *         "date": "2024",
 *         "isbn": "978-1234567890"
 *     },
 *     ...
 * ]
 *
 * Features:
 * - No authentication required
 * - Returns all books with complete information
 * - JSON array format
 */

/**
 * AddBook - POST /books/add
 * Description: Add new book to system (JWT required)
 *
 * Headers Required:
 * Authorization: Bearer {jwt_token}
 *
 * Request Body:
 * {
 *     "title": "string",
 *     "authors": "string",
 *     "publishers": "string",
 *     "date": "string",
 *     "isbn": "string"
 * }
 *
 * Success Response (201):
 * {
 *     "success": true,
 *     "book_id": 15
 * }
 *
 * Error Response (400):
 * {
 *     "message": "Title and authors are required"
 * }
 *
 * Features:
 * - JWT authentication required via middleware
 * - Validates required fields (title, authors)
 * - Uses prepared statements (SQL injection prevention)
 * - Returns new book_id
 */

/**
 * UpdateBook - PUT /books/update/{book_id}
 * Description: Update book information (JWT required)
 *
 * Headers Required:
 * Authorization: Bearer {jwt_token}
 *
 * URL Parameters:
 * book_id - The ID of the book to update
 *
 * Request Body (optional fields):
 * {
 *     "title": "string",
 *     "authors": "string",
 *     "publishers": "string",
 *     "date": "string",
 *     "isbn": "string"
 * }
 *
 * Success Response (200):
 * {
 *     "success": true
 * }
 *
 * Error Response (404):
 * {
 *     "error": "Book not found"
 * }
 *
 * Features:
 * - JWT authentication required via middleware
 * - Dynamic query building (only updates provided fields)
 * - Checks if book exists before update
 */

/**
 * DeleteBook - DELETE /books/delete/{book_id}
 * Description: Delete book and related records (JWT required)
 *
 * Headers Required:
 * Authorization: Bearer {jwt_token}
 *
 * URL Parameters:
 * book_id - The ID of the book to delete
 *
 * Success Response (200):
 * {
 *     "success": true
 * }
 *
 * Error Response (404):
 * {
 *     "error": "Book not found"
 * }
 *
 * Features:
 * - JWT authentication required via middleware
 * - Deletes associated user_favorites records
 * - Deletes associated user_likes records
 * - Cascading delete pattern
 */

/**
 * ============================================================================
 * USER SERVICES
 * ============================================================================
 */

/**
 * GetAllUsers - GET /user/all
 * Description: Get all users (admin/JWT required)
 *
 * Headers Required:
 * Authorization: Bearer {jwt_token}
 *
 * Success Response (200):
 * [
 *     {
 *         "user_id": 1,
 *         "username": "john_doe",
 *         "email": "john@example.com",
 *         "is_admin": 1,
 *         "last_login": "2024-11-06 10:30:45",
 *         "created_at": "2024-11-01 12:00:00"
 *     },
 *     ...
 * ]
 *
 * Features:
 * - JWT authentication required
 * - Returns user information without passwords
 * - Admin-level data access
 */

/**
 * AddUser - POST /user/add
 * Description: Add new user to system (JWT required)
 *
 * Headers Required:
 * Authorization: Bearer {jwt_token}
 *
 * Request Body:
 * {
 *     "username": "string",
 *     "email": "string",
 *     "password": "string"
 * }
 *
 * Success Response (201):
 * {
 *     "success": true,
 *     "user_id": 10
 * }
 *
 * Error Response (409):
 * {
 *     "message": "Username already exists"
 * }
 * or
 * {
 *     "message": "Email already exists"
 * }
 *
 * Features:
 * - JWT authentication required
 * - Duplicate username check
 * - Duplicate email check
 * - Password hashing
 */

/**
 * UpdateUser - PUT /user/update/{user_id}
 * Description: Update user profile/password (JWT required)
 *
 * Headers Required:
 * Authorization: Bearer {jwt_token}
 *
 * URL Parameters:
 * user_id - The ID of the user to update
 *
 * Request Body:
 * {
 *     "password": "current_password",  // Required for verification
 *     "new_password": "string",        // Optional
 *     "email": "string"                // Optional
 * }
 *
 * Success Response (200):
 * {
 *     "success": true
 * }
 *
 * Error Response (401):
 * {
 *     "error": "Password is incorrect"
 * }
 *
 * Error Response (400):
 * {
 *     "error": "New password cannot be the same as old password"
 * }
 *
 * Features:
 * - JWT authentication required
 * - Verifies current password before update
 * - Validates new password is different
 * - Updates email or password individually
 */

/**
 * DeleteUser - DELETE /user/delete/{user_id}
 * Description: Delete user (Admin only, JWT required)
 *
 * Headers Required:
 * Authorization: Bearer {jwt_token}
 *
 * URL Parameters:
 * user_id - The ID of the admin user performing deletion
 *
 * Request Body:
 * {
 *     "password": "admin_password",     // Required for verification
 *     "user_id_delete": 5,             // Optional - target user ID
 *     "email": "target@example.com",   // Optional - target by email
 *     "username": "target_user"        // Optional - target by username
 * }
 *
 * Success Response (200):
 * {
 *     "success": true
 * }
 *
 * Error Response (401):
 * {
 *     "error": "Password is incorrect"
 * }
 *
 * Error Response (403):
 * {
 *     "error": "❌No permission! Only admins can delete users"
 * }
 *
 * Features:
 * - JWT authentication required
 * - Admin-only operation
 * - Verifies admin password
 * - Supports deletion by user_id, email, or username
 * - Cascading delete (removes likes and favorites)
 */

/**
 * ============================================================================
 * LIKE SERVICES
 * ============================================================================
 */

/**
 * AddLike - POST /user/like
 * Description: Add like to book (JWT required)
 *
 * Headers Required:
 * Authorization: Bearer {jwt_token}
 *
 * Request Body:
 * {
 *     "book_id": 1
 * }
 *
 * Success Response (200):
 * {
 *     "success": true
 * }
 *
 * Error Response (401):
 * {
 *     "error": "Unauthorized"
 * }
 *
 * Features:
 * - JWT authentication required via middleware
 * - User ID extracted from JWT token
 * - INSERT IGNORE prevents duplicate likes
 * - Transaction support
 */

/**
 * DeleteLike - DELETE /user/like
 * Description: Remove like from book (JWT required)
 *
 * Headers Required:
 * Authorization: Bearer {jwt_token}
 *
 * Request Body:
 * {
 *     "book_id": 1
 * }
 *
 * Success Response (200):
 * {
 *     "success": true
 * }
 *
 * Error Response (401):
 * {
 *     "error": "Unauthorized"
 * }
 *
 * Features:
 * - JWT authentication required via middleware
 * - User ID extracted from JWT token
 * - Deletes specific user-book like relationship
 */

/**
 * ============================================================================
 * FAVORITE SERVICES
 * ============================================================================
 */

/**
 * AddFavorite - POST /user/favorite
 * Description: Add book to favorites (JWT required)
 *
 * Headers Required:
 * Authorization: Bearer {jwt_token}
 *
 * Request Body:
 * {
 *     "book_id": 1
 * }
 *
 * Success Response (200):
 * {
 *     "success": true
 * }
 *
 * Error Response (401):
 * {
 *     "error": "Unauthorized"
 * }
 *
 * Features:
 * - JWT authentication required via middleware
 * - User ID extracted from JWT token
 * - INSERT IGNORE prevents duplicate favorites
 * - Transaction support
 */

/**
 * DeleteFavorite - DELETE /user/favorite
 * Description: Remove book from favorites (JWT required)
 *
 * Headers Required:
 * Authorization: Bearer {jwt_token}
 *
 * Request Body:
 * {
 *     "book_id": 1
 * }
 *
 * Success Response (200):
 * {
 *     "success": true
 * }
 *
 * Error Response (401):
 * {
 *     "error": "Unauthorized"
 * }
 *
 * Features:
 * - JWT authentication required via middleware
 * - User ID extracted from JWT token
 * - Deletes specific user-book favorite relationship
 */

/**
 * GetUserFavorites - GET /user/{user_id}/favorites
 * Description: Get user's favorite books (JWT required)
 *
 * Headers Required:
 * Authorization: Bearer {jwt_token}
 *
 * URL Parameters:
 * user_id - The ID of the user to get favorites for
 *
 * Success Response (200):
 * [
 *     {
 *         "book_id": 1,
 *         "title": "Flutter Guide",
 *         "authors": "John Doe",
 *         "publishers": "Tech Publishing",
 *         "date": "2024",
 *         "isbn": "978-1234567890"
 *     },
 *     ...
 * ]
 *
 * Error Response (401):
 * {
 *     "error": "Unauthorized"
 * }
 *
 * Features:
 * - JWT authentication required via middleware
 * - Joins books and user_favorites tables
 * - Returns book details for favorites
 * - Filtered by user_id
 */

/**
 * ============================================================================
 * KEY FEATURES OF ALL SERVICES
 * ============================================================================
 *
 * 1. JWT Authentication
 *    - All protected endpoints require valid JWT token in Authorization header
 *    - Token validated via JwtMiddleware before function execution
 *    - User ID extracted from decoded JWT payload
 *
 * 2. Error Handling
 *    - PDOException caught and logged
 *    - Meaningful error messages returned to client
 *    - Appropriate HTTP status codes (400, 401, 403, 404, 500)
 *
 * 3. Database Operations
 *    - Prepared statements prevent SQL injection
 *    - Transaction support with beginTransaction/commit
 *    - Proper resource cleanup (set $conn = null)
 *
 * 4. Data Validation
 *    - Required field checks
 *    - Duplicate detection (username, email)
 *    - Password verification where needed
 *
 * 5. Security
 *    - Passwords hashed with PASSWORD_DEFAULT
 *    - SQL injection prevention via prepared statements
 *    - Admin-only operations verified
 *    - Password verification before updates
 *
 * 6. Response Format
 *    - All responses are JSON
 *    - Consistent error response structure
 *    - Appropriate HTTP headers set
 *
 * ============================================================================
 */

?>

