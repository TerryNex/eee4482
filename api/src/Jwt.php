<?php
require_once __DIR__ . '/../vendor/autoload.php';
use App\Db;
require_once __DIR__ . '/../src/Db.php';

use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Server\RequestHandlerInterface as RequestHandler;
use Firebase\JWT\JWT;
use Firebase\JWT\Key;

function validateJWT(Request $request, Response $response, RequestHandler $handler, string $secretKey): Response {
    $authHeader = $request->getHeaderLine('Authorization');
    if (!$authHeader) {
        $response->getBody()->write(json_encode(['error' => 'No token provided']));
        return $response->withHeader('Content-Type', 'application/json')->withStatus(401);
    }
    $token = str_replace('Bearer ', '', $authHeader);


    // new for user logout
    $db = new Db();
    $conn = $db->connect();
    $stmt = $conn->prepare('SELECT 1 FROM jwt_blacklist WHERE token = :token');
    $stmt->bindParam(':token', $token);
    $stmt->execute();
    if ($stmt->fetch()) {
        $response->getBody()->write(json_encode(['error' => 'Token is expired']));
        return $response->withHeader('Content-Type', 'application/json')->withStatus(401);
    }



    try {
        $decoded = JWT::decode($token, new Key($secretKey, 'HS256'));
        $request = $request->withAttribute('jwt', $decoded);
        // return $next($request, $response);
        return $handler->handle($request);
    } catch (Exception $e) {
        $response->getBody()->write(json_encode(['error' => 'Invalid token: ' . $e->getMessage()]));
        return $response->withHeader('Content-Type', 'application/json')->withStatus(401);
    }
}
?>
