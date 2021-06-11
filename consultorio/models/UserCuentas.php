<?php
    require_once("../db/Database.php");
    require_once("../interfaces/IUser.php");

    class User implements IUser {
    	private $con;
        private $id;

        private $consultorio;
        private $nombre;
        private $apellido;
        private $telefono;
        private $nacimiento;

    	public function __construct(Database $db){
    		$this->con = new $db;
    	}

        public function setId($id){
            $this->id = $id;
        }

        public function setConsultorio($consultorio){
            $this->consultorio = $consultorio;
        }

        public function setNombre($nombre){
            $this->nombre = $nombre;
        }

        public function setApellido($apellido){
            $this->apellido = $apellido;
        }

        public function setTelefono($telefono){
            $this->telefono = $telefono;
        }

        public function setFechaNacimiento($nacimiento){
            $this->nacimiento = $nacimiento;
        }


    	//insertamos usuarios en una tabla con postgreSql
    	public function save() {
    		try{
    			$query = $this->con->prepare('INSERT INTO pacientes values (DEFAULT,?,?,?,?,?)');
                $query->bindParam(1, $this->consultorio, PDO::PARAM_STR);
    			$query->bindParam(2, $this->nombre, PDO::PARAM_STR);
                $query->bindParam(3, $this->apellido, PDO::PARAM_STR);
    			$query->bindParam(4, $this->telefono, PDO::PARAM_STR);
                $query->bindParam(5, $this->nacimiento, PDO::PARAM_STR);
    			$query->execute();
    			$this->con->close();
    		}
            catch(PDOException $e) {
    	        echo  $e->getMessage();
    	    }
    	}

        public function update(){
    		try{
    			$query = $this->con->prepare('UPDATE pacientes SET consultorio_id = ?, paciente_nombre = ?, paciente_apellido = ?,paciente_telefono = ?,paciente_fecha_nacimiento = ? WHERE paciente_id = ?');
    			$query->bindParam(1, $this->consultorio, PDO::PARAM_STR);
    			$query->bindParam(2, $this->nombre, PDO::PARAM_STR);
                $query->bindParam(3, $this->apellido, PDO::PARAM_STR);
    			$query->bindParam(4, $this->telefono, PDO::PARAM_STR);
                $query->bindParam(5, $this->nacimiento, PDO::PARAM_STR);
                $query->bindParam(6, $this->id, PDO::PARAM_INT);
    			$query->execute();
    			$this->con->close();
    		}
            catch(PDOException $e){
    	        echo  $e->getMessage();
    	    }
    	}

    	//obtenemos usuarios de una tabla con postgreSql
    	public function get(){
    		try{
                if(is_int($this->id)){
                    
                    $query = $this->con->prepare("SELECT * from cuentapacientes WHERE paciente_id = ?");
                    $query->bindParam(1, $this->id, PDO::PARAM_INT);
                    $query->execute();
        			$this->con->close();
        			return $query->fetch(PDO::FETCH_OBJ);
                }
                else{
                    
                    $query = $this->con->prepare("SELECT cuenta_id,CONCAT(paciente_nombre,' ',paciente_apellido) AS nombre, saldo from cuentapacientes c INNER JOIN pacientes p ON p.paciente_id=c.paciente_id ORDER BY p.paciente_id");
        			$query->execute();
        			$this->con->close();
                    
        			return $query->fetchAll(PDO::FETCH_OBJ);
                }
    		}
            catch(PDOException $e){
    	        echo  $e->getMessage();
    	    }
    	}

        public function selConsul(){
    		try{
                    $query = $this->con->prepare("SELECT consultorio_id,consultorio_nombre from consultorios");
        			$query->execute();
        			$this->con->close();
        			return $query->fetchAll(PDO::FETCH_OBJ);
    		}
            catch(PDOException $e){
    	        echo  $e->getMessage();
    	    }
    	}



        public function delete(){
            try{
                $query = $this->con->prepare('DELETE FROM pacientes WHERE paciente_id = ?');
                $query->bindParam(1, $this->id, PDO::PARAM_INT);
                $query->execute();
                $this->con->close();
                return true;
            }
            catch(PDOException $e){
                echo  $e->getMessage();
            }
        }

        public static function baseurl() {
             return stripos($_SERVER['SERVER_PROTOCOL'],'https') === true ? 'https://' : 'http://' . $_SERVER['HTTP_HOST'] . "/consultorio/";
        }

        public function checkUser($user) {
            if( ! $user ) {
                header("Location:" . User::baseurl() . "app/tablePacientes.php");
            }
        }
    }
?>