<?php
$servername = "localhost";
$username   = "root";
$password   = "netlab123";
$dbname     = "elibrary";
try {
    $conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
    // set the PDO error mode to exception
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    // sql to create table
    $sql = "CREATE TABLE users (
        user_id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        username VARCHAR(50) NOT NULL UNIQUE,
        password VARCHAR(50) NOT NULL,
        is_admin INT(6) NOT NULL DEFAULT 0
    )";
    // use exec() because no results are returned
    $conn->exec($sql);
    echo "<h1>(HE HUALIANG 230263367)</h1>";
    echo "Table users has been created successfully";
    // Close connection
    $conn = null;
} catch(PDOException $e) {
    echo $sql . "<br>" . $e->getMessage();
    // Close connection
    $conn = null;
}
$conn = null;
?>
