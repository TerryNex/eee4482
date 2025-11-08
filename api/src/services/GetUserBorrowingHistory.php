<?php
namespace App\Services;
use \PDO;
use App\Db;
require_once __DIR__ . '/../Db.php';
function GetUserBorrowingHistory($request, $response, $args) {
    // response format
    // [
    //   {
    //     "id": 1,
    //     "book_id": 123,
    //     "book_title": "Book Title",
    //     "authors": "Author Name",
    //     "borrowed_date": "2025-10-15",
    //     "due_date": "2025-11-15",
    //     "returned_date": null,
    //     "status": "borrowed"
    //   },
    //   {
    //     "id": 2,
    //     "book_id": 456,
    //     "book_title": "Another Book",
    //     "authors": "Another Author",
    //     "borrowed_date": "2025-10-01",
    //     "due_date": "2025-10-31",
    //     "returned_date": "2025-10-28",
    //     "status": "returned"
    //   }
    // ]


    $jwt = $request->getAttribute('jwt');
    if (!$jwt || empty($jwt->user_id)) {
        $response->getBody()->write(json_encode(["error" => "Unauthorized"]));
        return $response->withHeader('content-type', 'application/json')->withStatus(401);
    }
    $user_id = $jwt->user_id;


    if (empty($user_id)) {
        $response->getBody()->write(json_encode(["error" => "Missing User ID"]));
        return $response->withHeader('content-type', 'application/json')->withStatus(400);
    }

    try {
        $db = new Db();
        $conn = $db->connect();
        $conn->beginTransaction();
        $stmt = $conn->prepare('SELECT * FROM borrowing_history WHERE user_id = :user_id');
        $stmt->execute(['user_id' => $user_id]);
        $results = $stmt->fetchAll(PDO::FETCH_ASSOC);
        // // type transform
        foreach ($results as &$row) {
            $row['book_id'] = intval($row['book_id']);
            $row['id'] = intval($row['id']);
        }
        $conn = null;

        $response->getBody()->write(json_encode($results));
        return $response->withHeader('content-type', 'application/json')->withStatus(200);
    } catch (PDOException $e) {
        echo "<h1>(HE HUALIANG 230263367)</h1>";
        $error = ["message" => $e->getMessage()];
        $response->getBody()->write(json_encode($error));
        return $response->withHeader('content-type', 'application/json')->withStatus(500);
    }
}
?>
