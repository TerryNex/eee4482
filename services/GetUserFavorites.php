<?php
namespace App\Services;
use \PDO;
use App\Db;
require_once __DIR__ . '/../Db.php';

// this function is for user to get their favorite books
function GetUserFavorites($request, $response, $args) {
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
