<?php 

require "config/config.php";

if($_SERVER['REQUEST_METHOD']=="POST"){
	$response = array();
	$username = $_POST['username'];
	$password = md5($_POST['password']);

	$check = "SELECT * FROM users WHERE username='$username' and password='$password'";
	$result = mysqli_fetch_array(mysqli_query($conn, $check));

	if(isset($result)){
		$response['value']=1;
		$response['message']="Login Success";
		$response['name']=$result['name'];
		$response['username']=$result['username'];
		echo json_encode($response);
	}else{
		$response['value']=0;
		$response['message']="Login Failed";
		echo json_encode($response);
	}
}

?>