# Backend & Database Change Requirements

Based on the front-end implementation and requirements, the following backend/database changes are needed:

## 1. Borrowing History API Endpoint

**Status**: Missing - needs to be implemented

**Required Endpoint**: `/user/{user_id}/borrowing_history` or `/borrowing_history`

**Method**: GET

**Authentication**: Requires JWT token

**Response Format**:
```json
[
  {
    "id": 1,
    "book_id": 123,
    "book_title": "Book Title",
    "authors": "Author Name",
    "borrowed_date": "2025-10-15",
    "due_date": "2025-11-15",
    "returned_date": null,
    "status": "borrowed"
  },
  {
    "id": 2,
    "book_id": 456,
    "book_title": "Another Book",
    "authors": "Another Author",
    "borrowed_date": "2025-10-01",
    "due_date": "2025-10-31",
    "returned_date": "2025-10-28",
    "status": "returned"
  }
]
```

**Database Table**: `borrowing_history` (if not exists, needs to be created)

**Suggested Schema**:
```sql
CREATE TABLE borrowing_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT(6) UNSIGNED NOT NULL,
    book_id INT(6) UNSIGNED NOT NULL,
    borrowed_date DATE NOT NULL,
    due_date DATE NOT NULL,
    returned_date DATE NULL,
    status ENUM('borrowed', 'returned', 'overdue') NOT NULL DEFAULT 'borrowed',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);
```

## 2. Borrow Book API Endpoint

**Status**: Missing - needs to be implemented for front-end borrow functionality

**Required Endpoint**: `/books/borrow`

**Method**: POST

**Authentication**: Requires JWT token

**Request Body**:
```json
{
  "book_id": 123,
  "due_date": "2025-11-15"
}
```

**Response Format**:
```json
{
  "success": true,
  "message": "Book borrowed successfully",
  "borrow_record": {
    "id": 1,
    "book_id": 123,
    "user_id": 1,
    "borrowed_date": "2025-10-15",
    "due_date": "2025-11-15"
  }
}
```

**Action**: 
- Create record in `borrowing_history` table
- Update `books.status` to 1 (borrowed)
- Update `books.borrowed_by` to current user_id

## 3. Return Book API Endpoint

**Status**: Missing - needs to be implemented

**Required Endpoint**: `/books/return/{book_id}` or `/borrowing_history/{id}/return`

**Method**: PUT or POST

**Authentication**: Requires JWT token

**Response Format**:
```json
{
  "success": true,
  "message": "Book returned successfully"
}
```

**Action**:
- Update `borrowing_history.returned_date` to current date
- Update `borrowing_history.status` to 'returned'
- Update `books.status` to 0 (available)
- Update `books.borrowed_by` to -1

## 4. Book Status Field Validation

**Status**: Partially complete - needs verification

**Current Implementation**: The `books` table has a `status` field (INT(6), default 0)

**Front-end Expectation**:
- Status value `0` = Available
- Status value `1` = Borrowed
- Other values may indicate reserved, maintenance, etc.

**Verification Needed**:
- Ensure all book API endpoints (`/books/all`, `/books/add`, etc.) include the `status` field in their responses
- Ensure the status is updated correctly when books are borrowed/returned

## 5. User Favorites API Enhancement

**Status**: Implemented but needs verification

**Current Endpoint**: `/user/{user_id}/favorites`

**Required Response**: The API should return full book details for each favorited book, not just IDs

**Expected Response Format**:
```json
[
  {
    "book_id": 1,
    "title": "Book Title",
    "authors": "Author Name",
    "publishers": "Publisher Name",
    "date": "2024-01-01",
    "isbn": "978-1234567890",
    "status": 0,
    "favorited_at": "2025-10-15T10:30:00Z"
  }
]
```

**Note**: Current implementation in `favorite_provider.dart` expects full book objects with all fields.

## 6. Book Field Names Consistency

**Current Database Schema** (from `database structures.md`):
- `book_id` ✓
- `title` ✓
- `authors` ✓ (note: plural form)
- `publishers` ✓ (note: plural form)
- `date` ✓
- `isbn` ✓
- `status` ✓
- `borrowed_by` ✓
- `last_updated` ✓

**Front-end Expectation**: The front-end code has been updated to use `authors` (plural) and `publishers` (plural) to match the database schema shown in PROVIDER_USAGE_EXAMPLES.dart

**Action Required**: Verify all API responses use `authors` and `publishers` (not `author` and `publisher`)

## Summary of Missing Implementations

1. **Borrowing History Endpoint** - High Priority
   - Endpoint: `/user/{user_id}/borrowing_history` or `/borrowing_history`
   - Table: `borrowing_history` (create if not exists)

2. **Borrow Book Endpoint** - High Priority
   - Endpoint: `/books/borrow`
   - Updates: `borrowing_history` table, `books.status`, `books.borrowed_by`

3. **Return Book Endpoint** - High Priority
   - Endpoint: `/books/return/{book_id}`
   - Updates: `borrowing_history` record, `books.status`, `books.borrowed_by`

## Implementation Order Recommendation

1. Create `borrowing_history` table (if not exists)
2. Implement `/books/borrow` endpoint
3. Implement `/books/return/{book_id}` endpoint
4. Implement `/user/{user_id}/borrowing_history` or `/borrowing_history` endpoint
5. Verify all existing endpoints return complete book data with proper field names

Please refer to `database structures.md` before making these changes.
