<?php
namespace App\Services;
use \PDO;
use App\Db;
require_once __DIR__ . '/../Db.php';
function DeleteLike($request, $response, $args) {
    $data = $request->getParsedBody();
    // $user_id = $data['user_id'] ?? '';
    // $password = $data['password'] ?? '';
    $book_id = $data['book_id'] ?? '';

    $jwt = $request->getAttribute('jwt');
    if (!$jwt || empty($jwt->user_id)) {
        $response->getBody()->write(json_encode(["error" => "Unauthorized"]));
        return $response->withHeader('content-type', 'application/json')->withStatus(401);
    }

    $user_id = $jwt->user_id;

    if (empty($book_id)) {
        $response->getBody()->write(json_encode(["error" => "Missing Book ID"]));
        return $response->withHeader('content-type', 'application/json')->withStatus(400);
    }

    try {
        $db = new Db();
        $conn = $db->connect();
        $conn->beginTransaction();

        // $stmt = $conn->prepare("SELECT password FROM users WHERE user_id = :user_id");
        // $stmt->bindParam(':user_id', $user_id, PDO::PARAM_INT);
        // $stmt->execute();
        // $user = $stmt->fetch(PDO::FETCH_ASSOC);

        // // if user logged in, the password should be correct, if not, assume it is guest
        // if (!$user || !password_verify($password, $user['password'])) {
        //     $conn = null;
        //     $db = null;
        //     $response->getBody()->write(json_encode(["error" => "Please login"]));
        //     return $response->withHeader('content-type', 'application/json')->withStatus(401);
        // }

        // insert data, prevent duplicate
        // $stmt = $conn->prepare("INSERT IGNORE INTO user_likes (user_id, book_id) VALUES (:user_id, :book_id)");

        // cancel like
        $stmt = $conn->prepare("DELETE FROM user_likes WHERE user_id = :user_id AND book_id = :book_id");
        $stmt->bindParam(':user_id', $user_id, PDO::PARAM_INT);
        $stmt->bindParam(':book_id', $book_id, PDO::PARAM_INT);
        $stmt->execute();

        $conn->commit();
        $conn = null;
        $db = null;

        $response->getBody()->write(json_encode(["success" => true]));
        return $response->withHeader('content-type', 'application/json')->withStatus(200);
    } catch (PDOException $e) {
        echo "<h1>(HE HUALIANG 230263367)</h1>";
        $error = ["error" => $e->getMessage()];
        $response->getBody()->write(json_encode($error));
        return $response->withHeader('content-type', 'application/json')->withStatus(500);
    }
}

?>
