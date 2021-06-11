<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta http-equiv="x-ua-compatible" content="ie=edge">
  <title>Registro de pacientes</title>
  <link rel="icon" href="img/hospital.ico" type="image/x-icon">
  <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.11.2/css/all.css">
  <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700&display=swap">
  <link rel="stylesheet" href="css/bootstrap.min.css">
  <link rel="stylesheet" href="css/mdb.min.css">
  <link rel="stylesheet" href="css/style.css">
</head>
<body class="bg">
<?php
            require_once "../models/UserPacientes.php";
            require_once("funcs.php");
            $db = new Database;
            $user = new User($db);
            $users = $user->get();        
?>
  <div class="container mt-3">
    <h3 class="font-weight-bold">Registro de pacientes</h3>
    <br>
      <div class="row col-md-12">
      <a href="index.html" class="btn btn-default btn-md">Regresar</a>
      </div>
      <?php
                if( ! empty( $users ) ) {
      ?>
      <table class="table table-bordered table-light">
        <thead class="thead-dark">
          <tr>
            <th scope="col">ID</th>
            <th scope="col">Consultorio</th>
            <th scope="col">Nombre</th>
            <th scope="col">Telefono</th>
            <th scope="col">Edad</th>
            <th scope="col">Opciones</th>
          </tr>
        </thead>
        <tbody> 
        <?php foreach( $users as $user )
                    {
        ?>            
        <tr>
                            <td><?php echo $user->paciente_id ?></td>
                            <td><?php echo $user->consultorio_nombre ?></td>
                            <td><?php echo $user-> nombre?></td>
                            <td><?php echo $user->paciente_telefono ?></td>
                            <td><?php echo calculaedad($user->paciente_fecha_nacimiento) ?></td>
                            <td>
                                <a class="btn btn-outline-light-green btn-sm" href="<?php echo User::baseurl() ?>app/editPacientes.php?user=<?php echo $user->paciente_id ?>">Edit</a> 
                                <a class="btn btn-outline-danger btn-sm" href="<?php echo User::baseurl() ?>app/deletePacientes.php?user=<?php echo $user->paciente_id ?>">Delete</a>
                            </td>
                        </tr>
                    <?php
                    }
        ?>
        </tbody>
      </table>
      <?php
                }
                else
                {
                ?>
                <div class="alert alert-danger" style="margin-top: 100px">There are 0 registered users</div>
                <?php
                }
      ?>
      <div class="row col-md-12">
      <a href="index.html" class="btn btn-default btn-md">Regresar</a>
      <a href="<?php echo User::baseurl() ?>app/addPacientes.php" class="btn btn-default btn-md ml-auto">Registra un paciente</a>
      </div>
  </div>
  <script type="text/javascript" src="js/jquery.min.js"></script>
  <script type="text/javascript" src="js/popper.min.js"></script>
  <script type="text/javascript" src="js/bootstrap.min.js"></script>
  <script type="text/javascript" src="js/mdb.min.js"></script>
  <script type="text/javascript">
    function loadDynamicContentModal(modal){
  var options = {
      modal: true,
      height:300,
      width:600
    };
  $('#conte-modal').load('datosModalPaciente.php?my_modal='+modal, function() {
    $('#bootstrap-modal').modal({show:true});
    });    
}
  </script>
</body>
</html>
