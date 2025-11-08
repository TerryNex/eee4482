<?php
namespace App\Services;
use \PDO;
use App\Db;
require_once __DIR__ . '/../Db.php';
function GetAllBooks($request, $response) {
    $sql = "SELECT * FROM books";
    try {
        $db = new Db();
        $conn = $db->connect();
        $stmt = $conn->query($sql);
        $data = $stmt->fetchAll(PDO::FETCH_ASSOC);


        // type transform
        foreach ($data as &$row) {
            $row['book_id'] = intval($row['book_id']);
            $row['status'] = intval($row['status']);
            $row['borrowed_by'] = intval($row['borrowed_by']);
        }

        $conn = null;
        $db = null;
        $response->getBody()->write(json_encode($data));
        return $response->withHeader('content-type', 'application/json')->withStatus(200);
    } catch (PDOException $e) {
        echo "<h1>(HE HUALIANG 230263367)</h1>";

        $error = ["message" => $e->getMessage()];
        $response->getBody()->write(json_encode($error));
        return $response->withHeader('content-type', 'application/json')->withStatus(500);
    }
}
?>
