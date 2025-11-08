<?php
namespace App\Services;
use \PDO;
use App\Db;
require_once __DIR__ . '/../Db.php';
function BorrowBook($request, $response, $args) {
    // Request Body:

    // {
    //   "book_id": 123,
    //   "due_date": "2025-11-15"
    // }
    // Response Format:

    // {
    //   "success": true,
    //   "message": "Book borrowed successfully",
    //   "borrow_record": {
    //     "id": 1,
    //     "book_id": 123,
    //     "user_id": 1,
    //     "borrowed_date": "2025-10-15",
    //     "due_date": "2025-11-15"
    //   }
    // }
    // Action:
    // Create record in borrowing_history table
    // Update books.status to 1 (borrowed)
    // Update books.borrowed_by to current user_id
    $data = $request->getParsedBody();
    $book_id = $data['book_id'] ?? null;
    $due_date = $data['due_date'] ?? null;

    if (!$book_id || !$due_date) {
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
        $stmt = $conn->prepare('SELECT * FROM books WHERE book_id = :book_id');
        $stmt->execute(['book_id' => $book_id]);
        $book = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$book || $book['status'] != 0) {
            $response->getBody()->write(json_encode(["error" => "Book not available"]));
            return $response->withHeader('content-type', 'application/json')->withStatus(400);
        }

        // insert borrow record
        $stmt = $conn->prepare('INSERT INTO borrowing_history (book_id, user_id, borrowed_date, due_date) VALUES (:book_id, :user_id, NOW(), :due_date)');
        $stmt->execute(['book_id' => $book_id, 'user_id' => $user_id, 'due_date' => $due_date]);

        // update book status
        $stmt = $conn->prepare('UPDATE books SET status = 1, borrowed_by = :user_id WHERE book_id = :book_id');
        $stmt->execute(['book_id' => $book_id, 'user_id' => $user_id]);
        $conn->commit();
        $conn = null;
        $db = null;

        $response->getBody()->write(json_encode(["success" => true, "message" => "Book borrowed successfully", "borrow_record" => [
            "book_id" => $book_id,
            "user_id" => $user_id,
            "borrowed_date" => date('Y-m-d'),
            "due_date" => $due_date
        ]]));

        return $response->withHeader('content-type', 'application/json')->withStatus(200);
    } catch (PDOException $e) {
        echo "<h1>(HE HUALIANG 230263367)</h1>";
        $error = ["message" => $e->getMessage()];
        $response->getBody()->write(json_encode($error));
        return $response->withHeader('content-type', 'application/json')->withStatus(500);
    }
}
?>
