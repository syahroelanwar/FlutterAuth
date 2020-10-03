<?php 

require "config/config.php";

if($_SERVER['REQUEST_METHOD']=="POST"){
	$response = array();
	$username = $_POST['username'];
	$password = md5($_POST['password']);
	$name = $_POST['name'];

	$check = "SELECT * FROM users WHERE username='$username'";
	$result = mysqli_fetch_array(mysqli_query($conn, $check));

	if(isset($result)){
		$response['value']=2;
		$response['message']="Username already axists";
		echo json_encode($response);
	}else{
		$save = "INSERT INTO users VALUE(NULL,'$username','$password','$name','1','1',NOW())";
		if(mysqli_query($conn, $save)){
			$response['value']=1;
			$response['message']="Registration Success";
			echo json_encode($response);		
		}else{
			$response['value']=0;
			$response['message']="Registration Failed";
			echo json_encode($response);
		}
	}
}

?>