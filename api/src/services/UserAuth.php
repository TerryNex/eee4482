<?php
namespace App\Services;
use \PDO;
use App\Db;
require_once __DIR__ . '/../Db.php';
use Firebase\JWT\JWT;
use Firebase\JWT\Key;


function UserLogin($request, $response, $args) {
    $data = $request->getParsedBody();
    $username = $data['username'] ?? '';
    $password = $data['password'] ?? '';

    try {
        $db = new Db();
        $conn = $db->connect();
        $conn->beginTransaction();

        $stmt = $conn->prepare('SELECT * FROM users WHERE username = :username LIMIT 1');

        $stmt->bindParam(':username', $username, PDO::PARAM_STR);
        $stmt->execute();
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($user && isset($user['password']) && password_verify($password, $user['password'])) {
            $result = [
                'exp' => time() + 3600,  // jwt expiration time
                'user_id' => $user['user_id'],
                'username' => $user['username'],
                'email' => $user['email'],
                'is_admin' => $user['is_admin'],
                'last_login' => $user['last_login'],
            ];

            // update user last_login
            $stmt = $conn->prepare('UPDATE users SET last_login = NOW() WHERE user_id = :user_id');
            $stmt->bindParam(':user_id', $user['user_id'], PDO::PARAM_INT);
            $stmt->execute();

            $secretKey = $_ENV['EEE4482JWT'] ;

            $jwt = JWT::encode($result, $secretKey, 'HS256');
            $result['token'] = $jwt;

            $conn->commit();
            $conn = null;
            $db = null;

            $response->getBody()->write(json_encode($result));
            return $response->withHeader('Content-Type', 'application/json')->withStatus(200);
        } else {
            $response->getBody()->write(json_encode(['error' => 'Invalid username or password']));
            return $response->withHeader('Content-Type', 'application/json')->withStatus(401);
        }
      } catch (PDOException $e) {
          echo "<h1>(HE HUALIANG 230263367)</h1>";

          $response->getBody()->write(json_encode(['error' => $e->getMessage()]));
          return $response->withHeader('Content-Type', 'application/json')->withStatus(500);
      }
}

 function UserRegistration($request, $response, $args) {
     $data = $request->getParsedBody();
     $email      = $data['email'] ?? '';
     $username = $data['username'] ?? '';
     $password = $data['password'] ?? '';
     $hashedPassword = password_hash($password, PASSWORD_DEFAULT);

    try{
        $db = new Db();
        $conn = $db->connect();
        $conn->beginTransaction();

        // check email does not exist
        $stmt = $conn->prepare('SELECT 1 FROM users WHERE email = :email');
        // $stmt->execute(['email' => $email]);
        $stmt->bindParam(':email', $email, PDO::PARAM_STR);
        $stmt->execute();
        if ($stmt->fetch()) {
            // email already exist
            $response->getBody()->write(json_encode(["message" => "Email already exists"]));
            return $response->withHeader('content-type', 'application/json')->withStatus(500);
        }

        // check username
        $stmt = $conn->prepare('SELECT 1 FROM users WHERE username = :username');
        // $stmt->execute(['username' => $username]);
        $stmt->bindParam(':username', $username, PDO::PARAM_STR);
        $stmt->execute();
        if ($stmt->fetch()) {
            // user already exist
            $error = ["message" => "Username already exists"];
            $response->getBody()->write(json_encode($error));
            return $response->withHeader('content-type', 'application/json')->withStatus(500);
        }


        $stmt = $conn->prepare('INSERT INTO users (username, email, password) VALUES (:username, :email, :password)');
        // $stmt->execute([
        //     'username' => $username,
        //     'email' => $email,
        //     'password' => password_hash($password, PASSWORD_DEFAULT),
        // ]);
        $stmt->bindParam(':username', $username);
        $stmt->bindParam(':password', $hashedPassword);
        $stmt->bindParam(':email', $email);
        $stmt->execute();

        $userId = $conn->lastInsertId();

        $conn->commit();
        $conn = null;
        $db = null;

        $response->getBody()->write(json_encode(['user_id' => $userId]));
        return $response->withHeader('content-type', 'application/json')->withStatus(201);
    } catch (PDOException $e) {
        echo "<h1>(HE HUALIANG 230263367)</h1>";
        $error = ["message" => $e->getMessage()];
        $response->getBody()->write(json_encode($error));
        return $response->withHeader('content-type', 'application/json')->withStatus(500);
    }
}


function UserLogout($request, $response, $args) {
    $jwt = $request->getAttribute('jwt');
    $token = $request->getHeaderLine('Authorization');
    $token = str_replace('Bearer ', '', $token);
    if (!$jwt || empty($jwt->user_id)) {
        $response->getBody()->write(json_encode(["error" => "Unauthorized"]));
        return $response->withHeader('content-type', 'application/json')->withStatus(401);
    }

    try {
        // add token to blacklist
        $db = new Db();
        $conn = $db->connect();
        $stmt = $conn->prepare('INSERT INTO jwt_blacklist (token, expired_at) VALUES (:token, :expired_at)');
        $stmt->bindParam(':token', $token);
        $stmt->bindParam(':expired_at', $jwt->exp);
        $stmt->execute();

        $conn->commit();
        $conn = null;
        $db = null;

        $response->getBody()->write(json_encode(['success' => true, 'message' => 'Logged out successfully']));
        return $response->withHeader('content-type', 'application/json')->withStatus(200);
    } catch (Exception $e) {
        echo "<h1>(HE HUALIANG 230263367)</h1>";
        $error = ["message" => $e->getMessage()];
        $response->getBody()->write(json_encode($error));
        return $response->withHeader('content-type', 'application/json')->withStatus(500);
    }
}
