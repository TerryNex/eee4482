<?php
namespace App\Services;
use \PDO;
use App\Db;
require_once __DIR__ . '/../Db.php';

// this function is for user to get their favorite books
function GetUserFavorites($request, $response, $args) {
    // response format
    // [
    //   {
    //     "book_id": 1,
    //     "title": "Book Title",
    //     "authors": "Author Name",
    //     "publishers": "Publisher Name",
    //     "date": "2024-01-01",
    //     "isbn": "978-1234567890",
    //     "status": 0,
    //     "favorited_at": "2025-10-15T10:30:00Z"
    //   }
    // ]
    $user_id = $args['user_id'] ?? null;

    $jwt = $request->getAttribute('jwt');
    if (!$jwt || empty($jwt->user_id)) {
        $response->getBody()->write(json_encode(["error" => "Unauthorized"]));
        return $response->withHeader('content-type', 'application/json')->withStatus(401);
    }

    if (empty($user_id)) {
        $response->getBody()->write(json_encode(["error" => "User ID is required"]));
        return $response->withHeader('content-type', 'application/json')->withStatus(400);
    }


    try {
        $db = new Db();
        $conn = $db->connect();
        // b is the alias
        $stmt = $conn->prepare("SELECT b.* FROM books b JOIN user_favorites uf ON b.book_id = uf.book_id WHERE uf.user_id = :user_id");
        $stmt->bindParam(':user_id', $user_id, PDO::PARAM_INT);
        $stmt->execute();
        $favorite_books = $stmt->fetchAll(PDO::FETCH_ASSOC);


        // // type transform
        foreach ($favorite_books as &$row) {
            $row['book_id'] = intval($row['book_id']);
            $row['status'] = intval($row['status']);
        }

        $conn = null;
        $db = null;

        $response->getBody()->write(json_encode($favorite_books));
        return $response->withHeader('content-type', 'application/json')->withStatus(200);
    } catch (PDOException $e) {
        echo "<h1>(HE HUALIANG 230263367)</h1>";

        $error = ["error" => $e->getMessage()];
        $response->getBody()->write(json_encode($error));
        return $response->withHeader('content-type', 'application/json')->withStatus(500);
    }
}

?>
