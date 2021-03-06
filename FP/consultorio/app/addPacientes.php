<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta http-equiv="x-ua-compatible" content="ie=edge">
  <title>Registro de Paciente</title>
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
            $db = new Database;
            $user = new User($db);
            $users = $user->selConsul();        
?>
  <div class="d-flex justify-content-center align-items-center text-brown">
    <form class="mt-3 needs-validation" action="<?php echo User::baseurl() ?>app/savePacientes.php" method="POST" novalidate>
      <h3 class="font-weight-bold">Registra un nuevo paciente</h3>
      <div class="mt-4">
      <div class="form-row">
        <div class="form-group col-md-12">
          <div class="md-form">
            <input type="text" id="paciente_nombre" name="paciente_nombre" class="form-control" required>
            <label for="paciente_nombre">Nombre del paciente</label>
          </div>
        </div>
      </div>
      <div class="form-row">
        <div class="form-group col-md-6">
          <div class="md-form">
            <input type="text" id="paciente_apellido" name="paciente_apellido" class="form-control" required>
            <label for="paciente_apellido">Apellido</label>
          </div>
        </div>
        </div>
        <div class="form-row">
        <div class="form-group col-md-6">
          <div class="md-form">
            <label for="telefono">Numero de telefono (10 digitos)</label>
            <input type="tel" class="form-control" id="paciente_telefono" name="paciente_telefono" pattern="[0-9]{10}" required>
          </div>
        </div>
      </div>
      <div class="form-row">
        <div class="form-group col-md-6">
          <div class="md-form">
            <label for="fechaNacimiento">Fecha de Nacimiento</label>
            <input type="date" id="paciente_fecha_nacimiento" name="paciente_fecha_nacimiento" class="form-control" required>
          </div>
        </div>
      </div>
      <div class="form-row">
        <div class="form-group col-md-6">
          <div class="md-form">
            <select class="browser-default custom-select" name="consultorio" id="consultorio" required>
              <option selected value="">Elige un consultorio</option>
              <?php foreach( $users as $user )
                    {
            ?>
                        <option value=<?php echo "$user->consultorio_id" ?>> <?php echo $user->consultorio_nombre ?></option>

                        <?php
                    }
        ?>
            </select>
              </select>
          </div>
        </div>
      </div>
       <div class="form-row col-md-12">
        <a href="tablePacientes.php" class="btn btn-default btn-md">Regresar</a>
        <button type="submit" class="btn btn-primary btn-md ml-auto">Registrar</button>
       </div>
       </div>
     </form>
  </div>
  <script type="text/javascript" src="js/jquery.min.js"></script>
  <script type="text/javascript" src="js/popper.min.js"></script>
  <script type="text/javascript" src="js/bootstrap.min.js"></script>
  <script type="text/javascript" src="js/mdb.min.js"></script>
  <script type="text/javascript">
    (function() {
        'use strict';
        window.addEventListener('load', function() {
        // Fetch all the forms we want to apply custom Bootstrap validation styles to
        var forms = document.getElementsByClassName('needs-validation');
        // Loop over them and prevent submission
        var validation = Array.prototype.filter.call(forms, function(form) {
        form.addEventListener('submit', function(event) {
        if (form.checkValidity() === false) {
        event.preventDefault();
        event.stopPropagation();
        }
        form.classList.add('was-validated');
        }, false);
        });
        }, false);
})();
  </script>
</body>
</html>
