<?php
require_once __DIR__ . '/../vendor/autoload.php';
require_once __DIR__ . '/../src/Jwt.php';

use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Server\RequestHandlerInterface as RequestHandler;
use Psr\Http\Message\ResponseInterface as Response;
$jwtMiddleware = function (Request $request, RequestHandler $handler): Response {
    $secretKey =$_ENV['EEE4482JWT'] ;
    return validateJWT($request, new \Slim\Psr7\Response(), $handler, $secretKey);
};
?>
