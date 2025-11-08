<?php
$servername = "localhost";
$username   = "root";
$password   = "netlab123";
$dbname     = "elibrary";
try {
    $conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
    // set the PDO error mode to exception
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $sql = "CREATE TABLE jwt_blacklist (
        id INT(11) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        token VARCHAR(512) NOT NULL,
        expired_at INT(11) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )";
    $conn->exec($sql);
    echo "Table jwt_blacklist has been created successfully";

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
