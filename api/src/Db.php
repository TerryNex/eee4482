<?php
namespace App;
use \PDO;
class Db
{
    private $host = 'localhost';
    private $user = 'root';
    private $pass = 'netlab123';
    private $dbname = 'elibrary';
    public function connect()
    {
        $conn_str = "mysql:host={$this->host};dbname={$this->dbname}";
        $conn = new PDO($conn_str, $this->user, $this->pass);
        $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        return $conn;
    }
}
?>
