<?php
	require_once "../models/UserPacientes.php";
	

	$args = array(
		'consultorio'  => FILTER_SANITIZE_STRING,
	    'paciente_nombre'  => FILTER_SANITIZE_STRING,
	    'paciente_apellido'  => FILTER_SANITIZE_STRING,
		'paciente_telefono'  => FILTER_SANITIZE_STRING,
	    'paciente_fecha_nacimiento'  => FILTER_SANITIZE_STRING,
	);

	$post = (object)filter_input_array(INPUT_POST, $args);

	$db = new Database;
	$user = new User($db);
	$user->setNombre($post->paciente_nombre);
	$user->setConsultorio($post->consultorio);
	$user->setApellido($post->paciente_apellido);
	$user->setTelefono($post->paciente_telefono);
	$user->setFechaNacimiento($post->paciente_fecha_nacimiento);
	$user->save();
	header("Location:" . User::baseurl() . "app/tablePacientes.php");

?>