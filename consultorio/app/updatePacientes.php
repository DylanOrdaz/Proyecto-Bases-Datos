<?php
	require_once "../models/UserPacientes.php";
	
	$args = array(
		'id'        => FILTER_VALIDATE_INT,
	    'consultorio'  => FILTER_SANITIZE_STRING,
	    'paciente_nombre'  => FILTER_SANITIZE_STRING,
	    'paciente_apellido'  => FILTER_SANITIZE_STRING,
		'paciente_telefono'  => FILTER_SANITIZE_STRING,
	    'paciente_fecha_nacimiento'  => FILTER_SANITIZE_STRING,
	);

	$post = (object)filter_input_array(INPUT_POST, $args);

	if( $post->id === false ){
	    header("Location:" . User::baseurl() . "app/index.html");
	}

	$db = new Database;
	$user = new User($db);
	$user->setId($post->id);
	$user->setNombre($post->paciente_nombre);
	$user->setConsultorio($post->consultorio);
	$user->setApellido($post->paciente_apellido);
	$user->setTelefono($post->paciente_telefono);
	$user->setFechaNacimiento($post->paciente_fecha_nacimiento);
	$user->update();
	header("Location:" . User::baseurl() . "app/tablePacientes.php");
?>