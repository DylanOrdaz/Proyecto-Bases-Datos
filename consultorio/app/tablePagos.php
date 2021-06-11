<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta http-equiv="x-ua-compatible" content="ie=edge">
  <title>Vista Pagos</title>
  <link rel="icon" href="img/hospital.ico" type="image/x-icon">
  <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.11.2/css/all.css">
  <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700&display=swap">
  <link rel="stylesheet" href="css/bootstrap.min.css">
  <link rel="stylesheet" href="css/mdb.min.css">
  <link rel="stylesheet" href="css/style.css">
</head>
<body class="bg">
<?php
            require_once "../models/UserPagos.php";
            require_once("funcs.php");
            $db = new Database;
            $user = new User($db);
            $users = $user->get();        
?>
  <div class="container mt-3">
    <h3 class="font-weight-bold">Vista Pagos</h3>
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
            <th scope="col">ID Pago</th>
            <th scope="col">ID Paciente</th>
            <th scope="col">Nombre</th>
            <th scope="col">Monto</th>
            <th scope="col">Fecha</th>
            <th scope="col">Metodo</th>
          </tr>
        </thead>
        <tbody> 
        <?php foreach( $users as $user )
                    {
        ?>            
        <tr>
                            <td><?php echo $user->pago_id ?></td>
                            <td><?php echo $user->paciente_id ?></td>
                            <td><?php echo $user-> nombre?></td>
                            <td><?php echo $user->monto ?></td>
                            <td><?php echo $user-> fecha_pago?></td>
                            <td><?php echo $user->metodo_pago ?></td>
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
                <div class="alert alert-danger" style="margin-top: 100px">No hay pagos registrados</div>
                <?php
                }
      ?>
      <div class="row col-md-12">
      <a href="index.html" class="btn btn-default btn-md">Regresar</a>
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
