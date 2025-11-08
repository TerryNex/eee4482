<?php
namespace App\Services;
use \PDO;
use App\Db;
require_once __DIR__ . '/../Db.php';
function UpdateBook($request, $response, $args){
    $book_id   = $args['book_id'];
    $data      = $request->getParsedBody();

    if (empty($book_id)) {
        $error = ["message" => "Missing Book ID"];
        $response->getBody()->write(json_encode($error));
        return $response->withHeader('content-type', 'application/json')->withStatus(400);
    }



    try {
        $db = new Db();
        $conn = $db->connect();
        // begin the transaction
        $conn->beginTransaction();


        $stmt = $conn->prepare('SELECT 1 FROM books WHERE book_id = :book_id');
        $stmt->bindParam(':book_id', $book_id, PDO::PARAM_INT);
        $stmt->execute();
        if (!$stmt->fetch()) {
            $response->getBody()->write(json_encode(["error" => "Book not found"]));
            return $response->withHeader('content-type', 'application/json')->withStatus(404);
        }

        $fields = [];
        $params = [':book_id' => $book_id];
        $title      = $data['title'] ?? '';
        $authors    = $data['authors'] ?? '';
        $publishers = $data['publishers'] ?? '';
        $date       = $data['date'] ?? '';
        $isbn       = $data['isbn'] ?? '';

        if (!empty($title)) {
            $fields[] = "title = :title";
            $params[':title'] = $title;
        }
        if (!empty($authors)) {
            $fields[] = "authors = :authors";
            $params[':authors'] = $authors;
        }
        if (!empty($publishers)) {
            $fields[] = "publishers = :publishers";
            $params[':publishers'] = $publishers;
        }
        if (!empty($date)) {
            $fields[] = "date = :date";
            $params[':date'] = $date;
        }
        if (!empty($isbn)) {
            $fields[] = "isbn = :isbn";
            $params[':isbn'] = $isbn;
        }

        if (empty($fields)) {
            $response->getBody()->write(json_encode(["message" => "Nothing changed"]));
            return $response->withHeader('content-type', 'application/json')->withStatus(400);
        }



        // our SQL statements
        $stmt = $conn->prepare("UPDATE books SET " . implode(", ", $fields) . " WHERE book_id = :book_id");
        foreach ($params as $key => $value) {
            $stmt->bindValue($key, $value);
        }
        // commit the transaction
        $stmt->execute();
        $conn->commit();
        if ($stmt->rowCount() > 0) {
            $response->getBody()->write(json_encode(["success" => "Book updated successfully"]));
        } else {
            $response->getBody()->write(json_encode(["message" => "Nothing changed"]));
        }
        $conn = null;
        $db = null;
        // $response->getBody()->write(json_encode($result));
        return $response->withHeader('content-type', 'application/json')->withStatus(200);
    } catch (PDOException $e) {
        echo "<h1>(HE HUALIANG 230263367)</h1>";
        $error = ["message" => $e->getMessage()];
        $response->getBody()->write(json_encode($error));
        return $response->withHeader('content-type', 'application/json')->withStatus(500);
    }
}
?>
