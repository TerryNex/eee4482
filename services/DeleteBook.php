<?php
namespace App\Services;
use \PDO;
use App\Db;
require_once __DIR__ . '/../Db.php';
function DeleteBook($request, $response, $args) {
    $book_id = $args['book_id'];

    if (empty($book_id)) {
        $response->getBody()->write(json_encode(["message" => "Missing Book ID"]));
        return $response->withHeader('content-type', 'application/json')->withStatus(400);
    }

    try {
        $db = new Db();
        $conn = $db->connect();
        $conn->beginTransaction();

        // check if book exists
        $stmt = $conn->prepare('SELECT 1 FROM books WHERE book_id = :book_id');
        $stmt->bindParam(':book_id', $book_id, PDO::PARAM_INT);
        $stmt->execute();

        if (!$stmt->fetch()) {
            $response->getBody()->write(json_encode(["error" => "Book not found"]));
            return $response->withHeader('content-type', 'application/json')->withStatus(404);
        }

        // remove favorite and like of book first
        $stmt = $conn->prepare('DELETE FROM user_favorites WHERE book_id = :book_id');
        $stmt->bindParam(':book_id', $book_id, PDO::PARAM_INT);
        $stmt->execute();
        $stmt = $conn->prepare('DELETE FROM user_likes WHERE book_id = :book_id');
        $stmt->bindParam(':book_id', $book_id, PDO::PARAM_INT);
        $stmt->execute();



        // $sql = "DELETE FROM books WHERE book_id = $book_id";
        $stmt = $conn->prepare("DELETE FROM books WHERE book_id = :book_id");
        $stmt->bindParam(':book_id', $book_id, PDO::PARAM_INT);
        $stmt->execute();

        $conn->commit();
        $conn = null;
        $db = null;

        // $response->getBody()->write(json_encode($result));
        $response->getBody()->write(json_encode(['success' => true]));
        return $response->withHeader('content-type', 'application/json')->withStatus(200);
    } catch (PDOException $e) {
        echo "<h1>(HE HUALIANG 230263367)</h1>";
        $error = ["message" => $e->getMessage()];
        $response->getBody()->write(json_encode($error));
        return $response->withHeader('content-type', 'application/json')->withStatus(500);
    }
}
?>
