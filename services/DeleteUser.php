<?php
namespace App\Services;
use \PDO;
use App\Db;
require_once __DIR__ . '/../Db.php';
function DeleteUser($request, $response, $args) {
    $data = $request->getParsedBody();
    $user_id = $data['user_id'] ?? null;
    $password = $data['password'] ?? '';



    if (empty($password) || empty($user_id)) {
        $response->getBody()->write(json_encode(["error" => "Password and User ID required"]));
        return $response->withHeader('content-type', 'application/json')->withStatus(400);
    }



    try {
        $db = new Db();
        $conn = $db->connect();
        $conn->beginTransaction();

        $stmt = $conn->prepare("SELECT password, is_admin FROM users WHERE user_id = :user_id");
        $stmt->bindParam(':user_id', $user_id, PDO::PARAM_INT);
        $stmt->execute();
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$user) {
            $response->getBody()->write(json_encode(["error" => "User not found"]));
            return $response->withHeader('content-type', 'application/json')->withStatus(404);
        }

        if (!password_verify($password, $user['password'])) {
            $response->getBody()->write(json_encode(["error" => "Password is incorrect"]));
            return $response->withHeader('content-type', 'application/json')->withStatus(401);
        }

        // check if user is admin
        if ((int)$user['is_admin'] !== 1) {
            $response->getBody()->write(json_encode(["error" => "❌No permission!"]));
            return $response->withHeader('content-type', 'application/json')->withStatus(403);
        }




        // 'delete_user_id' is from the index.php
        $user_id_delete = $args['user_id_delete'] ?? $data['user_id_delete'] ?? null;
        $email = $data['email'] ?? '';
        $username = $data['username'] ?? '';
        $fields = [];
        $params = [];
        // delete user only need one field
        if (!empty($user_id_delete)) {
            $fields[] = "user_id = :user_id";
            $params[':user_id'] = $user_id_delete;
        }else{
            // if user_id is not provided, get user id from email or username
            if( !empty($email)) {
                // $fields[] = "email = :email";
                // $params[':email'] = $email;
                $stmt = $conn->prepare("SELECT user_id FROM users WHERE email = :email");
                $stmt->execute([':email' => $data['email']]);
                $user = $stmt->fetch(PDO::FETCH_ASSOC);
                if ($user) {
                    $fields[] = "user_id = :user_id";
                    $params[':user_id'] = $user['user_id'];
                }
            }elseif( !empty($username)) {
                // $fields[] = "username = :username";
                // $params[':username'] = $username ;
                $stmt = $conn->prepare("SELECT user_id FROM users WHERE username = :username");
                $stmt->execute([':username' => $data['username']]);
                $user = $stmt->fetch(PDO::FETCH_ASSOC);
                if ($user) {
                    $fields[] = "user_id = :user_id";
                    $params[':user_id'] = $user['user_id'];
                }
            }else{
                // if the three fields are empty
                $response->getBody()->write(json_encode(["error" => "Invalid request"]));
                return $response->withHeader('content-type', 'application/json')->withStatus(400);
            }

        }

        // above condition comfirm user_id is certain and valid
        // delete likes and favorites
        $stmt = $conn->prepare("DELETE FROM user_likes WHERE user_id = :delete_user_id");
        $stmt->bindParam(':delete_user_id', $params[':user_id'], PDO::PARAM_INT);
        $stmt->execute();
        $stmt = $conn->prepare("DELETE FROM user_favorites WHERE user_id = :delete_user_id");
        $stmt->bindParam(':delete_user_id', $params[':user_id'], PDO::PARAM_INT);
        $stmt->execute();

        $stmt = $conn->prepare("DELETE FROM users WHERE ". implode( $fields) );
        foreach ($params as $key => $val) {
            $stmt->bindValue($key, $val);
        }
        $stmt->execute();
        if ($stmt->rowCount() > 0) {
            $result = 1;
        }else{
            $result = 0;
        }

        $conn->commit();
        $conn = null;
        $db = null;

        $response->getBody()->write(json_encode(["success" => $result]));
        return $response->withHeader('content-type', 'application/json')->withStatus(200);

    } catch (PDOException $e) {
        echo "<h1>(HE HUALIANG 230263367)</h1>";
        $error = ["message" => $e->getMessage()];
        $response->getBody()->write(json_encode($error));
        return $response->withHeader('content-type', 'application/json')->withStatus(500);
    }
}
?>
