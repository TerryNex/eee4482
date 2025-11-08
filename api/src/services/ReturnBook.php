<?php
namespace App\Services;
use \PDO;
use App\Db;
require_once __DIR__ . '/../Db.php';
function ReturnBook($request, $response, $args) {

    // Response Format:
    // {
    //   "success": true,
    //   "message": "Book returned successfully"
    // }
    // Action:
    // Update borrowing_history.returned_date to current date
    // Update borrowing_history.status to 'returned'
    // Update books.status to 0 (available)
    // Update books.borrowed_by to -1

    $book_id = $args['book_id'];

    if (!$book_id) {
        return $response->withJson(['message'=>'Missing parameters'])->withStatus(400);
    }

    $jwt = $request->getAttribute('jwt');
    if (!$jwt || empty($jwt->user_id)) {
        $response->getBody()->write(json_encode(["error" => "Unauthorized"]));
        return $response->withHeader('content-type', 'application/json')->withStatus(401);
    }
    $user_id = $jwt->user_id;


    if (empty($user_id)) {
        $response->getBody()->write(json_encode(["error" => "User ID is required"]));
        return $response->withHeader('content-type', 'application/json')->withStatus(400);
    }




    try {
        $db = new Db();
        $conn = $db->connect();
        $conn->beginTransaction();

        // find the record
        $stmt = $conn->prepare('SELECT id FROM borrowing_history WHERE book_id=:book_id AND user_id=:user_id AND status="borrowed"');
        $stmt->execute(['book_id'=>$book_id, 'user_id'=>$user_id]);
        $history = $stmt->fetch();

        if (!$history) {
            $conn = null;
            $response->getBody()->write(json_encode(['message'=>'No borrowing record found']));
            return $response->withHeader('content-type', 'application/json')->withStatus(404);
        }

        // update record
        $stmt = $conn->prepare("UPDATE borrowing_history SET returned_date = NOW(), status = 'returned' WHERE book_id = :book_id AND user_id = :user_id");
        $stmt->bindParam(':book_id', $book_id);
        $stmt->bindParam(':user_id', $user_id);
        $stmt->execute();

        $stmt = $conn->prepare("UPDATE books SET status = 0, borrowed_by = -1 WHERE book_id = :book_id");
        $stmt->bindParam(':book_id', $book_id);
        $stmt->execute();

        $conn->commit();
        $conn = null;
        $db = null;
        $response->getBody()->write(json_encode(['success' => true, 'message' => 'Book returned successfully']));
        return $response->withHeader('content-type', 'application/json')->withStatus(200);
    } catch (PDOException $e) {
        echo "<h1>(HE HUALIANG 230263367)</h1>";
        $error = ["message" => $e->getMessage()];
        $response->getBody()->write(json_encode($error));
        return $response->withHeader('content-type', 'application/json')->withStatus(500);
    }
}
?>
