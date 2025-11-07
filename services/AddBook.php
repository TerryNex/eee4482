<?php
namespace App\Services;
use \PDO;
use App\Db;
require_once __DIR__ . '/../Db.php';
function AddBook($request, $response, $args) {
    $data = $request->getParsedBody();
    $title      = $data['title'] ?? '';
    $authors    = $data['authors'] ?? '';
    $publishers = $data['publishers'] ?? '';
    $date       = $data['date'] ?? '';
    $isbn       = $data['isbn'] ?? '';

    // Validate required fields, to prevent someone who is trying to add a book using other methods
    if (empty($title) || empty($authors)) {
        $response->getBody()->write(json_encode(["message" => "Title and authors are required"]));
        return $response->withHeader('content-type', 'application/json')->withStatus(400);
    }

    try {
        $db = new Db();
        $conn = $db->connect();
        // begin the transaction
        $conn->beginTransaction();
        // our SQL statements
        // $sql = "INSERT INTO books (title, authors, publishers, date, isbn) VALUES ('$title', '$authors', '$publishers', '$date', '$isbn')";
        // $conn->exec($sql);
        //

        // use prepared statements
        $sql = "INSERT INTO books (title, authors, publishers, date, isbn) VALUES (:title, :authors, :publishers, :date, :isbn)";
        $stmt = $conn->prepare($sql);

        $stmt->bindParam(':title', $title, PDO::PARAM_STR);
        $stmt->bindParam(':authors', $authors, PDO::PARAM_STR);
        $stmt->bindParam(':publishers', $publishers, PDO::PARAM_STR);
        $stmt->bindParam(':date', $date, PDO::PARAM_STR);
        $stmt->bindParam(':isbn', $isbn, PDO::PARAM_STR);

        $stmt->execute();
        $book_id = $conn->lastInsertId();

        // commit the transaction
        $result = $conn->commit();
        $conn = null;
        $db = null;
        // $response->getBody()->write(json_encode($result));  // this will return 'true'
        $response->getBody()->write(json_encode(['success' => true, 'book_id' => $book_id]));
        return $response->withHeader('content-type', 'application/json')->withStatus(200);
    } catch (PDOException $e) {
        $error = ["message" => $e->getMessage()];
        $response->getBody()->write(json_encode($error));
        return $response->withHeader('content-type', 'application/json')->withStatus(500);
    }
}
?>
