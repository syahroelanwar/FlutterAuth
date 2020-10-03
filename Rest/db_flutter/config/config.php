<?php  

define('Host', 'localhost');
define('User', 'root');
define('Pass', '');
define('DB', 'db_flutter');

$conn = mysqli_connect(Host,User,Pass,DB) or die('Error, Unable to Connect');

?>