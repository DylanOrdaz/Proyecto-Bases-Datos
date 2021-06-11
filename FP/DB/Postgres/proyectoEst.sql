*****************************INSTALAR FDW********************************

sudo apt-get install libmysqlclient-dev
sudo apt install postgresql-server-dev-12

locate pg_config
locate mysql_config

git clone https://github.com/EnterpriseDB/mysql_fdw.git
cd mysql_fdw

export PATH=/usr/lib/postgresql/12/bin/:/usr/bin/:$PATH make USE_PGXS=1
sudo PATH=/usr/lib/postgresql/12/bin/:/usr/bin/:$PATH make USE_PGXS=1 install


*******************************************INICIANDO******************************************************
///////////////////////////////////////////////////////////////////////////////////////////////MYSQL
CREATE DATABASE ConsultorioD;
CREATE USER 'Dental'@'localhost' IDENTIFIED BY 'Dental5512!';
GRANT ALL PRIVILEGES ON ConsultorioD.* TO 'Dental'@'localhost';
exit
mysql -u Dental -h localhost -p
///////////////////////////////////////////////////////////////////////////////////////////////POSTGRESQL

CREATE DATABASE ConsultorioD;
\c consultoriod

CREATE EXTENSION mysql_fdw;

CREATE SERVER mysql_svr 
FOREIGN DATA WRAPPER mysql_fdw 
OPTIONS (host '127.0.0.1', port '3306');

CREATE USER MAPPING FOR postgres
SERVER mysql_svr
OPTIONS (username 'Dental', password 'Dental5512!');


CREATE TABLE IF NOT EXISTS consultorios(
    consultorio_id SERIAL PRIMARY KEY,
    consultorio_nombre VARCHAR(40),
    consultorio_calle VARCHAR(40),
    consultorio_ciudad VARCHAR(40),
    consultorio_estado VARCHAR(20),
    consultorio_cp VARCHAR(5),
    consultorio_telefono VARCHAR(10)
);

INSERT INTO consultorios values(DEFAULT,'Cero Caries','Blv. Zaragoza 23','Puebla','Puebla','72000','2221190643');
INSERT INTO consultorios values(DEFAULT,'Dientes Sanos','Panama 6','Puebla','Puebla','72340','2228785412');

CREATE TABLE IF NOT EXISTS metodosPagos(
    metodo_pago_id SERIAL PRIMARY KEY,
    metodo_pago VARCHAR(10) NOT NULL
);

CREATE TABLE IF NOT EXISTS tratamientos(
    tratamiento_id SERIAL PRIMARY KEY,
    tratamiento_nombre VARCHAR(30) NOT NULL,
    costo DECIMAL(8,2) NOT NULL
);

**************************************************DENTISTAS********************************************************
////////////////////////////////////////////////////////////////////////////////////MYSQL
use ConsultorioD;
CREATE TABLE IF NOT EXISTS dentistas(
    dentista_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    no_cuenta_bancaria VARCHAR(16),
    dentista_rfc VARCHAR(13)
);
//////////////////////////////////////////////////////////////////////////////POSTGRESQL
CREATE TABLE IF NOT EXISTS dentistasA(
    dentista_id SERIAL PRIMARY KEY,
    consultorio_id INT NOT NULL,
    dentista_nombre VARCHAR(30),
    dentista_apellido_paterno VARCHAR(30),
    dentista_telefono VARCHAR(10),
    dentista_correo VARCHAR(50),
    FOREIGN KEY (consultorio_id) REFERENCES consultorios(consultorio_id) ON DELETE CASCADE
);

CREATE FOREIGN TABLE dentistasB (
    dentista_id SERIAL,
    no_cuenta_bancaria VARCHAR(16),
    dentista_rfc VARCHAR(13)
) SERVER mysql_svr
	OPTIONS (dbname 'ConsultorioD', table_name 'dentistas');


BEGIN;
INSERT INTO dentistasA values(DEFAULT,1,'Poncho','Jarin','2361109221','poncho@gmail.com');
INSERT INTO dentistasB values(DEFAULT,'2131485217529931','PEGM9007151HO');
COMMIT;

BEGIN;
INSERT INTO dentistasA values(DEFAULT,2,'Jaen','Jori','6327812665','jaen@gmail.com');
INSERT INTO dentistasB values(DEFAULT,'0087571597776431','GAGO7671211AE');
COMMIT;

BEGIN;
DELETE from dentistasA where dentista_id = 2;
DELETE from dentistasB where dentista_id = 2;
COMMIT;

BEGIN;
UPDATE dentistasA set dentista_id=3, dentista_nombre = 'Ximena', dentista_apellido_paterno='Saez', dentista_telefono='2521356432',dentista_correo='xime@gmail.com' where dentista_id=3;
UPDATE dentistasB set dentista_id=3, no_cuenta_bancaria='8947052683658975', dentista_rfc='XIMO4327621UE' where dentista_id=3;
COMMIT;

SELECT a.dentista_id, consultorio_nombre, CONCAT(dentista_nombre,' ',dentista_apellido_paterno) as Nombre,dentista_telefono,dentista_correo, no_cuenta_bancaria, dentista_rfc from dentistasA a INNER JOIN dentistasB b ON a.dentista_id = b.dentista_id INNER JOIN consultorios c ON a.consultorio_id = c.consultorio_id;

SELECT * from dentistasA;
SELECT * from dentistasB;



*********************************************************************************PACIENTES********************
/////////////////////////////////////////////////MYSQL
CREATE TABLE IF NOT EXISTS pacientes(
    paciente_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    consultorio_id INT NOT NULL,
    paciente_nombre VARCHAR(30),
    paciente_apellido VARCHAR(30),
    paciente_telefono VARCHAR(10),
    paciente_fecha_nacimiento DATE
);

////////////////////////////////////////POSTGRESQL
CREATE TABLE IF NOT EXISTS pacientes(
    paciente_id SERIAL PRIMARY KEY,
    consultorio_id INT NOT NULL,
    paciente_nombre VARCHAR(30),
    paciente_apellido VARCHAR(30),
    paciente_telefono VARCHAR(10),
    paciente_fecha_nacimiento DATE,
    FOREIGN KEY (consultorio_id) REFERENCES consultorios(consultorio_id) ON DELETE CASCADE
);

CREATE TABLE "pacientes-PSQL" (
  CHECK (
    consultorio_id = 1)
) INHERITS ("pacientes");

CREATE FOREIGN TABLE "pacientes-MYSQL" (
  CHECK (
    consultorio_id = 2)
) INHERITS ("pacientes") SERVER mysql_svr
	OPTIONS (dbname 'ConsultorioD', table_name 'pacientes');

CREATE OR REPLACE FUNCTION pacientes_insert_trigger()
RETURNS TRIGGER LANGUAGE PLPGSQL AS $$
BEGIN
IF (NEW.consultorio_id = 1) THEN
INSERT INTO "pacientes-PSQL" VALUES (NEW.*);
ELSIF (NEW.consultorio_id = 2) THEN
INSERT INTO "pacientes-MYSQL" VALUES (NEW.*);
ELSE
RAISE EXCEPTION 'Consultorio no contemplado. Revisa el trigger';
END IF;
RETURN NULL;
END;
$$;

CREATE TRIGGER pacientes_before_insert
  BEFORE INSERT
  ON pacientes
  FOR EACH ROW
  EXECUTE PROCEDURE pacientes_insert_trigger();

INSERT INTO pacientes values(DEFAULT,2,'Juan','Salmon','2219124367','1991-11-14');

SELECT paciente_id, consultorio_nombre, CONCAT(paciente_nombre,' ',paciente_apellido) AS Nombre,paciente_telefono,paciente_fecha_nacimiento from pacientes p INNER JOIN consultorios c ON p.consultorio_id = c.consultorio_id;
INSERT INTO pacientes;
DELETE FROM pacientes;



*********************************************************************CITAS*********************************************************************
/////////////////////////////////MYSQL
CREATE TABLE IF NOT EXISTS citas(
    cita_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    dentista_id INT NOT NULL,
    consultorio_id INT NOT NULL,
    fecha_cita timestamp NOT NULL,
    comentarios VARCHAR(250)
);
/////////////////////////////////////POSTGRESQL


CREATE TABLE IF NOT EXISTS citas(
    cita_id SERIAL PRIMARY KEY,
    paciente_id INT NOT NULL,
    dentista_id INT NOT NULL,
    consultorio_id INT NOT NULL,
    fecha_cita timestamp NOT NULL,
    comentarios VARCHAR(250),
    FOREIGN KEY (paciente_id) REFERENCES pacientes(paciente_id) ON DELETE CASCADE,
    FOREIGN KEY (dentista_id) REFERENCES dentistasA(dentista_id) ON DELETE CASCADE,
    FOREIGN KEY (consultorio_id) REFERENCES consultorios(consultorio_id) ON DELETE CASCADE
);

CREATE TABLE "citas-PSQL" (
  CHECK (
    consultorio_id = 1)
) INHERITS ("citas");

CREATE FOREIGN TABLE "citas-MYSQL" (
  CHECK (
    consultorio_id = 2)
) INHERITS ("citas") SERVER mysql_svr
	OPTIONS (dbname 'ConsultorioD', table_name 'citas');


CREATE OR REPLACE FUNCTION citas_insert_trigger()
RETURNS TRIGGER LANGUAGE PLPGSQL AS $$
BEGIN
IF (NEW.consultorio_id = 1) THEN
INSERT INTO "citas-PSQL" VALUES (NEW.*);
ELSIF (NEW.consultorio_id = 2) THEN
INSERT INTO "citas-MYSQL" VALUES (NEW.*);
ELSE
RAISE EXCEPTION 'Consultorio no contemplado. Revisa el trigger';
END IF;
RETURN NULL;
END;
$$;

CREATE TRIGGER citas_before_insert
  BEFORE INSERT
  ON citas
  FOR EACH ROW
  EXECUTE PROCEDURE citas_insert_trigger();


INSERT INTO citas values(DEFAULT,2,1,2,'10-04-19 12:00','Buen avance') ;
INSERT INTO citas values(DEFAULT,2,1,2,'10-04-22 12:00','Revision semanal') ;




*******************************************************************TERMINANDO**********************************************
////////////////////////////////////////////POSTGRESQL

CREATE TABLE IF NOT EXISTS cuentaPacientes(
    cuenta_id SERIAL PRIMARY KEY,
    paciente_id INT NOT NULL,
    saldo DECIMAL(8,2),
    FOREIGN KEY (paciente_id) REFERENCES pacientes(paciente_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS pagos(
    pago_id SERIAL PRIMARY KEY,
    paciente_id INT NOT NULL,
    metodo_pago_id INT NOT NULL,
    monto DECIMAL(8,2) NOT NULL CHECK (monto > 0),
    fecha_pago DATE,
    cuenta_id INT NOT NULL,
    cita_id INT NOT NULL,
    comentarios VARCHAR(250),
    FOREIGN KEY (paciente_id) REFERENCES pacientes(paciente_id) ON DELETE CASCADE,
    FOREIGN KEY (metodo_pago_id) REFERENCES metodosPagos(metodo_pago_id) ON DELETE CASCADE,
    FOREIGN KEY (cuenta_id) REFERENCES cuentaPacientes(cuenta_id) ON DELETE CASCADE,
    FOREIGN KEY (cita_id) REFERENCES citas(cita_id ) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS registroTratamientos(
    registro_tratamiento_id SERIAL PRIMARY KEY,
    paciente_id INT NOT NULL,
    tratamiento_id INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_final DATE,
    FOREIGN KEY (paciente_id) REFERENCES pacientes(paciente_id),
    FOREIGN KEY (tratamiento_id) REFERENCES tratamientos(tratamiento_id)
);

---------------------------------------------------------------------------------Vista--------------------------------------------
CREATE VIEW pagos_res AS
SELECT pago_id,p.paciente_id, CONCAT(paciente_nombre,' ',paciente_apellido) as Nombre, monto, fecha_pago, metodo_pago from pagos p INNER JOIN pacientes pa ON p.paciente_id = pa.paciente_id INNER JOIN metodosPagos m ON p.metodo_pago_id = m.metodo_pago_id;
------------------------------------------------------------------------------ function--------------------
create function getTimeLeft(idCita int)
returns interval
language plpgsql
as
$$
declare
   currentTime timestamp;
   date_time timestamp;
begin
   select fecha_cita
   into date_time
   from citas
   where cita_id=idCita;
   select now()
   into currentTime;
   return date_time-currentTime;
end;
$$;

SELECT getTimeLeft(2);




Implement one transaction: Check if the dentist is available at the proposed time every time in managing appointments 


Implement one trigger: When a patient registers to a new treatment, price is charged to the patient’s account.
Implement one stored procedure: You send the patient and the appointment and it returns the appointment information


