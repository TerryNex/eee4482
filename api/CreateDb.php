<?php
$servername = "localhost";
$username   = "root";
$password   = "netlab123";
$dbname     = "elibrary";
try {
    $conn = new PDO("mysql:host=$servername", $username, $password);

    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $sql = "CREATE DATABASE $dbname";

    $conn->exec($sql);
    echo "<h1>(HE HUALIANG 230263367)</h1>";
    echo "Database HEHUALIANG_230263367 created successfully<br>";

    $conn = null;
} catch(PDOException $e) {
    echo $sql . "<br>" . $e->getMessage();

    $conn = null;
}
$conn = null;
?>
