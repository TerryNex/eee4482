-- =====================================================
-- EEE4482 e-Library Authentication Schema Extension
-- Student: HE HUALIANG (230263367)
-- Purpose: User authentication and authorization tables
-- Database: MariaDB / MySQL
-- =====================================================

USE elibrary;

-- =====================================================
-- Table: users
-- Purpose: Store user account information
-- =====================================================
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE COMMENT 'Username (≥6 chars, no special symbols)',
    email VARCHAR(255) NOT NULL UNIQUE COMMENT 'User email address',
    password_hash VARCHAR(255) NOT NULL COMMENT 'Hashed password',
    display_name VARCHAR(100) COMMENT 'Display name for the user',
    role ENUM('user', 'admin') DEFAULT 'user' COMMENT 'User role',
    is_active BOOLEAN DEFAULT FALSE COMMENT 'Whether account is activated',
    is_email_verified BOOLEAN DEFAULT FALSE COMMENT 'Whether email is verified',
    email_verification_token VARCHAR(255) DEFAULT NULL COMMENT 'Token for email verification',
    email_verification_expires TIMESTAMP NULL COMMENT 'Token expiration time',
    password_reset_token VARCHAR(255) DEFAULT NULL COMMENT 'Token for password reset',
    password_reset_expires TIMESTAMP NULL COMMENT 'Password reset token expiration',
    remember_token VARCHAR(255) DEFAULT NULL COMMENT 'Remember me token',
    last_login_at TIMESTAMP NULL COMMENT 'Last login timestamp',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Account creation time',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last update time',
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_role (role),
    INDEX idx_is_active (is_active),
    INDEX idx_email_verification_token (email_verification_token),
    INDEX idx_password_reset_token (password_reset_token)
) ENGINE=InnoDB COMMENT='User accounts and authentication';

-- =====================================================
-- Table: books
-- Purpose: Store book information
-- =====================================================
CREATE TABLE IF NOT EXISTS books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL COMMENT 'Book title',
    author VARCHAR(255) NOT NULL COMMENT 'Book author',
    publisher VARCHAR(255) COMMENT 'Publisher name',
    isbn VARCHAR(20) UNIQUE COMMENT 'ISBN number',
    publication_date DATE COMMENT 'Publication date',
    cover_image_url VARCHAR(512) COMMENT 'URL to cover image',
    description TEXT COMMENT 'Book description',
    total_copies INT DEFAULT 1 COMMENT 'Total number of copies',
    available_copies INT DEFAULT 1 COMMENT 'Number of available copies',
    category VARCHAR(100) COMMENT 'Book category/genre',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_title (title),
    INDEX idx_author (author),
    INDEX idx_isbn (isbn),
    INDEX idx_category (category),
    CONSTRAINT chk_copies CHECK (available_copies >= 0 AND available_copies <= total_copies)
) ENGINE=InnoDB COMMENT='Book catalog';

-- =====================================================
-- Table: book_borrowing
-- Purpose: Track book borrowing history
-- =====================================================
CREATE TABLE IF NOT EXISTS book_borrowing (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL COMMENT 'User who borrowed the book',
    book_id INT NOT NULL COMMENT 'Book that was borrowed',
    borrowed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'When book was borrowed',
    due_date TIMESTAMP NOT NULL COMMENT 'When book should be returned',
    returned_at TIMESTAMP NULL COMMENT 'When book was actually returned',
    status ENUM('borrowed', 'returned', 'overdue') DEFAULT 'borrowed' COMMENT 'Current status',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_book_id (book_id),
    INDEX idx_status (status),
    INDEX idx_borrowed_at (borrowed_at)
) ENGINE=InnoDB COMMENT='Book borrowing records';

-- =====================================================
-- Table: book_likes
-- Purpose: Track user likes/favorites for books
-- =====================================================
CREATE TABLE IF NOT EXISTS book_likes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL COMMENT 'User who liked the book',
    book_id INT NOT NULL COMMENT 'Book that was liked',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'When book was liked',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
    UNIQUE KEY uk_user_book (user_id, book_id),
    INDEX idx_user_id (user_id),
    INDEX idx_book_id (book_id)
) ENGINE=InnoDB COMMENT='User book likes/favorites';

-- =====================================================
-- Table: book_bookmarks
-- Purpose: Track user bookmarks for books
-- =====================================================
CREATE TABLE IF NOT EXISTS book_bookmarks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL COMMENT 'User who bookmarked the book',
    book_id INT NOT NULL COMMENT 'Book that was bookmarked',
    notes TEXT COMMENT 'User notes for this bookmark',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'When book was bookmarked',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
    UNIQUE KEY uk_user_book (user_id, book_id),
    INDEX idx_user_id (user_id),
    INDEX idx_book_id (book_id)
) ENGINE=InnoDB COMMENT='User book bookmarks';

-- =====================================================
-- Table: sessions
-- Purpose: Track active user sessions
-- =====================================================
CREATE TABLE IF NOT EXISTS sessions (
    id VARCHAR(255) PRIMARY KEY COMMENT 'Session ID',
    user_id INT NOT NULL COMMENT 'User ID for this session',
    ip_address VARCHAR(45) COMMENT 'IP address',
    user_agent TEXT COMMENT 'Browser user agent',
    payload TEXT NOT NULL COMMENT 'Session data',
    last_activity TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last activity timestamp',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_last_activity (last_activity)
) ENGINE=InnoDB COMMENT='Active user sessions';

-- =====================================================
-- Default Data: Create default admin user
-- =====================================================
-- Password: Admin@123 (hashed with bcrypt)
-- Note: In production, use proper password hashing
INSERT INTO users (username, email, password_hash, display_name, role, is_active, is_email_verified) VALUES
('admin', 'admin@elibrary.local', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Administrator', 'admin', TRUE, TRUE)
ON DUPLICATE KEY UPDATE updated_at = CURRENT_TIMESTAMP;

-- =====================================================
-- Views for convenient data access
-- =====================================================

-- View: user_borrow_summary
-- Purpose: Summary of user borrowing activity
CREATE OR REPLACE VIEW user_borrow_summary AS
SELECT 
    u.id AS user_id,
    u.username,
    u.email,
    COUNT(DISTINCT bb.id) AS total_borrowed,
    COUNT(DISTINCT CASE WHEN bb.status = 'borrowed' THEN bb.id END) AS currently_borrowed,
    COUNT(DISTINCT CASE WHEN bb.status = 'overdue' THEN bb.id END) AS overdue_count,
    COUNT(DISTINCT bl.id) AS liked_books_count,
    COUNT(DISTINCT bm.id) AS bookmarked_books_count
FROM users u
LEFT JOIN book_borrowing bb ON u.id = bb.user_id
LEFT JOIN book_likes bl ON u.id = bl.user_id
LEFT JOIN book_bookmarks bm ON u.id = bm.user_id
GROUP BY u.id, u.username, u.email;

-- View: book_availability
-- Purpose: Book availability status with borrowing info
CREATE OR REPLACE VIEW book_availability AS
SELECT 
    b.id,
    b.title,
    b.author,
    b.isbn,
    b.total_copies,
    b.available_copies,
    CASE 
        WHEN b.available_copies > 0 THEN 'available'
        ELSE 'borrowed'
    END AS status,
    COUNT(DISTINCT bb.id) AS total_borrows,
    COUNT(DISTINCT bl.id) AS total_likes
FROM books b
LEFT JOIN book_borrowing bb ON b.id = bb.book_id
LEFT JOIN book_likes bl ON b.id = bl.book_id
GROUP BY b.id, b.title, b.author, b.isbn, b.total_copies, b.available_copies;

-- =====================================================
-- Stored Procedures
-- =====================================================

DELIMITER $$

-- Procedure: register_user
-- Purpose: Register a new user
CREATE PROCEDURE IF NOT EXISTS register_user(
    IN p_username VARCHAR(50),
    IN p_email VARCHAR(255),
    IN p_password_hash VARCHAR(255),
    IN p_verification_token VARCHAR(255),
    OUT p_user_id INT
)
BEGIN
    INSERT INTO users (username, email, password_hash, email_verification_token, email_verification_expires)
    VALUES (p_username, p_email, p_password_hash, p_verification_token, DATE_ADD(NOW(), INTERVAL 24 HOUR));
    
    SET p_user_id = LAST_INSERT_ID();
END$$

-- Procedure: verify_email
-- Purpose: Verify user email with token
CREATE PROCEDURE IF NOT EXISTS verify_email(
    IN p_token VARCHAR(255),
    OUT p_success BOOLEAN
)
BEGIN
    DECLARE v_user_id INT;
    
    SELECT id INTO v_user_id
    FROM users
    WHERE email_verification_token = p_token
      AND email_verification_expires > NOW()
      AND is_email_verified = FALSE
    LIMIT 1;
    
    IF v_user_id IS NOT NULL THEN
        UPDATE users
        SET is_email_verified = TRUE,
            is_active = TRUE,
            email_verification_token = NULL,
            email_verification_expires = NULL
        WHERE id = v_user_id;
        
        SET p_success = TRUE;
    ELSE
        SET p_success = FALSE;
    END IF;
END$$

-- Procedure: borrow_book
-- Purpose: Borrow a book
CREATE PROCEDURE IF NOT EXISTS borrow_book(
    IN p_user_id INT,
    IN p_book_id INT,
    IN p_due_date TIMESTAMP,
    OUT p_success BOOLEAN,
    OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE v_available INT;
    
    -- Check availability
    SELECT available_copies INTO v_available
    FROM books
    WHERE id = p_book_id
    FOR UPDATE;
    
    IF v_available > 0 THEN
        -- Create borrowing record
        INSERT INTO book_borrowing (user_id, book_id, due_date)
        VALUES (p_user_id, p_book_id, p_due_date);
        
        -- Decrease available copies
        UPDATE books
        SET available_copies = available_copies - 1
        WHERE id = p_book_id;
        
        SET p_success = TRUE;
        SET p_message = 'Book borrowed successfully';
    ELSE
        SET p_success = FALSE;
        SET p_message = 'Book is not available';
    END IF;
END$$

-- Procedure: return_book
-- Purpose: Return a borrowed book
CREATE PROCEDURE IF NOT EXISTS return_book(
    IN p_borrowing_id INT,
    OUT p_success BOOLEAN,
    OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE v_book_id INT;
    DECLARE v_status VARCHAR(20);
    
    -- Get book ID and current status
    SELECT book_id, status INTO v_book_id, v_status
    FROM book_borrowing
    WHERE id = p_borrowing_id;
    
    IF v_book_id IS NOT NULL AND v_status = 'borrowed' THEN
        -- Update borrowing record
        UPDATE book_borrowing
        SET returned_at = NOW(),
            status = 'returned'
        WHERE id = p_borrowing_id;
        
        -- Increase available copies
        UPDATE books
        SET available_copies = available_copies + 1
        WHERE id = v_book_id;
        
        SET p_success = TRUE;
        SET p_message = 'Book returned successfully';
    ELSE
        SET p_success = FALSE;
        SET p_message = 'Invalid borrowing record or book already returned';
    END IF;
END$$

-- Procedure: like_book
-- Purpose: Like/unlike a book
CREATE PROCEDURE IF NOT EXISTS like_book(
    IN p_user_id INT,
    IN p_book_id INT,
    IN p_action VARCHAR(10),
    OUT p_success BOOLEAN
)
BEGIN
    IF p_action = 'like' THEN
        INSERT IGNORE INTO book_likes (user_id, book_id)
        VALUES (p_user_id, p_book_id);
        SET p_success = TRUE;
    ELSEIF p_action = 'unlike' THEN
        DELETE FROM book_likes
        WHERE user_id = p_user_id AND book_id = p_book_id;
        SET p_success = TRUE;
    ELSE
        SET p_success = FALSE;
    END IF;
END$$

-- Procedure: bookmark_book
-- Purpose: Bookmark/unbookmark a book
CREATE PROCEDURE IF NOT EXISTS bookmark_book(
    IN p_user_id INT,
    IN p_book_id INT,
    IN p_action VARCHAR(10),
    IN p_notes TEXT,
    OUT p_success BOOLEAN
)
BEGIN
    IF p_action = 'bookmark' THEN
        INSERT INTO book_bookmarks (user_id, book_id, notes)
        VALUES (p_user_id, p_book_id, p_notes)
        ON DUPLICATE KEY UPDATE notes = p_notes, updated_at = NOW();
        SET p_success = TRUE;
    ELSEIF p_action = 'unbookmark' THEN
        DELETE FROM book_bookmarks
        WHERE user_id = p_user_id AND book_id = p_book_id;
        SET p_success = TRUE;
    ELSE
        SET p_success = FALSE;
    END IF;
END$$

DELIMITER ;

-- =====================================================
-- Triggers
-- =====================================================

-- Trigger: Update overdue status
DELIMITER $$

CREATE TRIGGER IF NOT EXISTS update_overdue_status
BEFORE UPDATE ON book_borrowing
FOR EACH ROW
BEGIN
    IF NEW.status = 'borrowed' AND NEW.due_date < NOW() AND OLD.status != 'overdue' THEN
        SET NEW.status = 'overdue';
    END IF;
END$$

DELIMITER ;

-- =====================================================
-- End of Authentication Schema
-- =====================================================
