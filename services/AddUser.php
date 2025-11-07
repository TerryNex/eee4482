<?php
namespace App\Services;
use \PDO;
use App\Db;
require_once __DIR__ . '/../Db.php';
function AddUser($request, $response, $args) {
    $data = $request->getParsedBody();
    $username      = $data['username'] ?? '';
    $password    = $data['password'] ?? '';
    $email    = $data['email'] ?? '';
    $hashedPassword = password_hash($password, PASSWORD_DEFAULT);


    if (empty($username) || empty($email) || empty($password)) {
        $response->getBody()->write(json_encode(["message" => "Username, email, and password are required"]));
        return $response->withHeader('content-type', 'application/json')->withStatus(400);
    }

    try {
        $db = new Db();
        $conn = $db->connect();
        // begin the transaction
        $conn->beginTransaction();
        // our SQL statements
        // $sql = "INSERT INTO users (username, password,email) VALUES ('$username', '$hashedPassword', '$email')";
        // $conn->exec($sql);


        // check if user or email exists
        $stmt = $conn->prepare('SELECT 1 FROM users WHERE username = :username');
        $stmt->bindParam(':username', $username, PDO::PARAM_STR);
        $stmt->execute();
        if ($stmt->fetch()) {
            $response->getBody()->write(json_encode(["message" => "Username already exists"]));
            return $response->withHeader('content-type', 'application/json')->withStatus(409);
        }
        $stmt = $conn->prepare('SELECT 1 FROM users WHERE email = :email');
        $stmt->bindParam(':email', $email, PDO::PARAM_STR);
        $stmt->execute();
        if ($stmt->fetch()) {
            $response->getBody()->write(json_encode( ["message" => "Email already exists"]));
            return $response->withHeader('content-type', 'application/json')->withStatus(409);
        }

        // use placeholder to prevent SQL injection
        $sql = "INSERT INTO users (username, password, email) VALUES (:username, :password, :email)";
        $stmt = $conn->prepare($sql);
        $stmt->bindParam(':username', $username);
        $stmt->bindParam(':password', $hashedPassword);
        $stmt->bindParam(':email', $email);
        $stmt->execute();
        $userId = $conn->lastInsertId();

        // commit the transaction
        $result = $conn->commit();
        $conn = null;
        $db = null;
        // $response->getBody()->write(json_encode(["success" => true]));
        // $response->getBody()->write(json_encode($result));
        $response->getBody()->write(json_encode(['success' => true, 'user_id' => $userId]));
        return $response->withHeader('content-type', 'application/json')->withStatus(200);
    } catch (PDOException $e) {
        echo "<h1>(HE HUALIANG 230263367)</h1>";
        $error = ["message" => $e->getMessage()];
        $response->getBody()->write(json_encode($error));
        return $response->withHeader('content-type', 'application/json')->withStatus(500);

    }
}
?>
