<?php
	require_once "../models/UserPacientes.php";
	

	$args = array(
		'valor'  => FILTER_SANITIZE_STRING,
	);

	$post = (object)filter_input_array(INPUT_POST, $args);

	$db = new Database;
	$user = new User($db);
	$user->setId($post->id);
	$user->calTime();
	header("Location:" . User::baseurl() . "app/tableCal.php");

?>