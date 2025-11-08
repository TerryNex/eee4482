<?php
namespace App\Services;
use \PDO;
use App\Db;
require_once __DIR__ . '/../Db.php';

// to be installed
// use PHPMailer\PHPMailer\PHPMailer;
// require 'PHPMailer/src/PHPMailer.php';
// require 'HPMailer/src/SMTP.php';

function ForgotPassword($request, $response, $args) {
    $data = $request->getParsedBody();
    $username_or_email = $data['username_or_email'] ?? null;
    // find the username or email in database, then to get the email
    // use regex to check if exist '@' and '.'
    // if not, assume it's a username
    $email_pattern = '/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/';
    $stmt = null;
    try {
        $db = new Db();
        $conn = $db->connect();
        $conn->beginTransaction();

        if (!preg_match($email_pattern, $username_or_email) && !empty($username_or_email)) {
            // name
            // search user in db
            $stmt = $conn->prepare('SELECT email FROM users WHERE username = :username');
            $stmt->bindParam(':username', $username_or_email);

        } else {
            // email
            $stmt = $conn->prepare('SELECT email FROM users WHERE email = :email');
            $stmt->bindParam(':email', $username_or_email);

        }
        $stmt->execute();
        $email = $stmt->fetchColumn();
        // if not find then return error
        if (!$email) {
            $response->getBody()->write(json_encode(['message'=>'User not found']));
            return $response->withHeader('content-type', 'application/json')->withStatus(404);
        }

        // current is in simulator
        // $mail = new PHPMailer();
        // $mail->isSMTP();
        // $mail->Host = 'smtp.example.com';  // smtp
        // $mail->SMTPAuth = true;
        // $mail->Username = 'your@email.com'; //
        // $mail->Password = 'yourpassword';   // password or authorization code
        // $mail->SMTPSecure = 'tls';
        // $mail->Port = 587;

        // $mail->setFrom('your@email.com', 'EEE4482 elibrary');
        // $mail->addAddress('to@example.com', 'Recipient Name');
        // $mail->Subject = 'Reset Password';
        // $mail->Body = 'This is a test email sent using PHPMailer.';
        // $mail->isHTML(false);


        // random true or false
        // if(!$mail->send()){
        if(rand(0,1)){
            $response->getBody()->write(json_encode(['message'=>'Email send error']));

        } else {
            $response->getBody()->write(json_encode(['message'=>'Email sent successfully']));
        }

        $db = null;
        $conn = null;
        return $response->withHeader('content-type', 'application/json')->withStatus(200);
    } catch (PDOException $e) {
        echo "<h1>(HE HUALIANG 230263367)</h1>";
        $error = ["message" => $e->getMessage()];
        $response->getBody()->write(json_encode($error));
        return $response->withHeader('content-type', 'application/json')->withStatus(500);
    }
}
?>
