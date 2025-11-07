<?php
namespace App\Services;
use \PDO;
use App\Db;
require_once __DIR__ . '/../Db.php';
function GetAllUsers($request, $response) {
    try {
        $db = new Db();
        $conn = $db->connect();
        $stmt = $conn->query("SELECT * FROM users");
        $data = $stmt->fetchAll(PDO::FETCH_ASSOC);

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
