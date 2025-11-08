<?php

// allow cross-origin requests from anywhere
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
// request the permission
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

require_once __DIR__ . '/../vendor/autoload.php';
require_once __DIR__ . '/../src/JwtMiddleware.php';
$dotenv = Dotenv\Dotenv::createImmutable(__DIR__ . '/../');
$dotenv->load();
// var_dump(getenv('EEE4482JWT')); // false
// var_dump($_ENV['EEE4482JWT'] ?? null);
$app = Slim\Factory\AppFactory::create();
// handle json format
$app->addBodyParsingMiddleware();
// Add Slim routing middleware
$app->addRoutingMiddleware();
// Set the base path to run the app in a subdirectory. This path is used in urlFor().
$app->add(new Selective\BasePath\BasePathMiddleware($app));
$app->addErrorMiddleware(true, true, true);
// default route for testing
$app->get('/', function ($request, $response) {
    $response->getBody()->write('Hello, World!');
    return $response;
})->setName('root');
// require all service files
foreach (glob(__DIR__ . '/../src/services/*.php') as $filename) {
    require_once $filename;
}
// define API routes
$app->get('/books/all', 'App\Services\GetAllBooks');
$app->post('/books/add', 'App\Services\AddBook');
$app->put('/books/update/{book_id}', 'App\Services\UpdateBook');
$app->delete('/books/delete/{book_id}', 'App\Services\DeleteBook');
// for users
$app->get('/user/all', 'App\Services\GetAllUsers'); // admin only
$app->post('/user/add', 'App\Services\AddUser');
$app->put('/user/update/{user_id}', 'App\Services\UpdateUser');
// this parameter is optional.
$app->delete('/user/delete[/{user_id_delete}]', 'App\Services\DeleteUser')->add($jwtMiddleware);
// likes and favorites
$app->post('/user/like', 'App\Services\AddLike')->add($jwtMiddleware);;
$app->delete('/user/like', 'App\Services\DeleteLike')->add($jwtMiddleware);
$app->post('/user/favorite', 'App\Services\AddFavorite')->add($jwtMiddleware);
$app->delete('/user/favorite', 'App\Services\DeleteFavorite')->add($jwtMiddleware);
$app->get('/user/{user_id}/favorites', 'App\Services\GetUserFavorites')->add($jwtMiddleware);
// borrow
$app->get('/borrowing_history', 'App\Services\GetUserBorrowingHistory')->add($jwtMiddleware);
$app->post('/books/borrow', 'App\Services\BorrowBook')->add($jwtMiddleware);
$app->put('/books/return/{book_id}', 'App\Services\ReturnBook')->add($jwtMiddleware);

// user registration and login
$app->post('/auth/register', 'App\Services\UserRegistration');
$app->post('/auth/login', 'App\Services\UserLogin');
$app->post('/auth/logout', 'App\Services\UserLogout')->add($jwtMiddleware);
$app->post('/auth/forgot-password', 'App\Services\ForgotPassword');

$app->run();
?>
