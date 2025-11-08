<?php
$servername = "localhost";
$username   = "root";
$password   = "netlab123";
$dbname     = "elibrary";
try {
    $conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
    // set the PDO error mode to exception
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $sql = "CREATE TABLE borrowing_history (
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
    );";
    $conn->exec($sql);
    echo "Table borrowing_history has been created successfully";

    echo "<h1>(HE HUALIANG 230263367)</h1>";
    // Close connection
    $conn = null;
} catch(PDOException $e) {
    echo $sql . "<br>" . $e->getMessage();
    // Close connection
    $conn = null;
}
$conn = null;
?>
