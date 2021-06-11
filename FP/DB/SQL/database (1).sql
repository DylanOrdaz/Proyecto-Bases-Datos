CREATE TABLE IF NOT EXISTS consultorios(
    -- consultorio_id SERIAL PRIMARY KEY,
    consultorio_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    consultorio_nombre VARCHAR(40),
    consultorio_calle VARCHAR(40),
    consultorio_ciudad VARCHAR(40),
    consultorio_estado VARCHAR(5),
    consultorio_cp VARCHAR(5),
    consultorio_telefono VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS metodosPagos(
    -- metodo_pago_id SERIAL PRIMARY KEY,
    metodo_pago_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    metodo_pago VARCHAR(10) NOT NULL
);

CREATE TABLE IF NOT EXISTS tratamientos(
    -- tratamiento_id SERIAL PRIMARY KEY,
    tratamiento_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    tratamiento_nombre VARCHAR(30) NOT NULL,
    costo DECIMAL(8,2) NOT NULL
);

CREATE TABLE IF NOT EXISTS dentistas(
    -- dentista_id SERIAL PRIMARY KEY,
    dentista_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    consultorio_id INT NOT NULL,
    dentista_nombre VARCHAR(30),
    dentista_apellido_paterno VARCHAR(30),
    dentista_telefono VARCHAR(10),
    dentista_correo VARCHAR(50),
    no_cuenta_bancaria VARCHAR(16),
    dentista_rfc VARCHAR(13),
    FOREIGN KEY (consultorio_id) REFERENCES consultorios(consultorio_id)
);

CREATE TABLE IF NOT EXISTS pacientes(
    -- paciente_id SERIAL PRIMARY KEY,
    paciente_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    consultorio_id INT NOT NULL,
    paciente_nombre VARCHAR(3go_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    metodo_pago_id INT NOT NULL,
    monto DECIMAL(8,2) NOT NULL CHECK (monto > 0),
    fecha_pago DATE,
    comentarios VARCHAR(250),
    FOREIGN KEY (paciente_id) REFERENCES pacientes(paciente_id),
    FOREIGN KEY (metodo_pago_id) REFERENCES metodosPagos(metodo_pago_id)
);0),
    paciente_apellido VARCHAR(30),
    paciente_telefono VARCHAR(10),
    paciente_fecha_nacimiento DATE,
    FOREIGN KEY (consultorio_id) REFERENCES consultorios(consultorio_id)
);

CREATE TABLE IF NOT EXISTS registroTratamientos(
    -- registro_tratamiento_id SERIAL PRIMARY KEY,
    registro_tratamiento_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    tratamiento_id INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_final DATE,
    FOREIGN KEY (paciente_id) REFERENCES pacientes(paciente_id),
    FOREIGN KEY (tratamiento_id) REFERENCES tratamientos(tratamiento_id)
);

CREATE TABLE IF NOT EXISTS cuentaPacientes(
    -- cuenta_id SERIAL PRIMARY KEY,
    cuenta_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    saldo DECIMAL(8,2),
    FOREIGN KEY (paciente_id) REFERENCES pacientes(paciente_id)
);

CREATE TABLE IF NOT EXISTS citas(
    -- cita_id SERIAL PRIMARY KEY,
    cita_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    dentista_id INT NOT NULL,
    consultorio_id INT NOT NULL,
    fecha_cita DATETIME NOT NULL,
    comentarios VARCHAR(250),
    FOREIGN KEY (paciente_id) REFERENCES pacientes(paciente_id),
    FOREIGN KEY (dentista_id) REFERENCES dentistas(dentista_id),
    FOREIGN KEY (consultorio_id) REFERENCES consultorios(consultorio_id)
);

CREATE TABLE IF NOT EXISTS pagos(
    -- pago_id SERIAL PRIMARY KEY,
    pago_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    metodo_pago_id INT NOT NULL,
    monto DECIMAL(8,2) NOT NULL,
    fecha_pago DATE,
    comentarios VARCHAR(250),
    CONSTRAINT monto_positivo CHECK (monto > 0),
    FOREIGN KEY (paciente_id) REFERENCES pacientes(paciente_id),
    FOREIGN KEY (metodo_pago_id) REFERENCES metodosPagos(metodo_pago_id)
);

INSERT INTO consultorios(consultorio_nombre, consultorio_calle, consultorio_ciudad, consultorio_estado, consultorio_cp, consultorio_telefono)
VALUES ('Dientes Felices', 'De la muela', 'Puebla', 'Pue', '72000', '0123456789'),
       ('Dental Care', 'Caries 24', 'Zapopan', 'Jal', '45000', '9876543210');

INSERT INTO dentistas(consultorio_id, dentista_nombre, dentista_apellido_paterno, dentista_telefono, dentista_correo, no_cuenta_bancaria, dentista_rfc)
VALUES (1, 'Aquiles', 'Brinco', '1478523690', 'correo_creible@gmail.com', '2131485217529931', 'GAJR6605319GT'),
       (2, 'Yoko', 'Momoko', '1478523690', 'correo_asombroso@gmail.com', '2131485217529931', 'KSOP3455319NM'),
       (1, 'Aquiles', 'Casas', '1478523690', 'correo_creible@yahoo.mx', '2131485217529931', 'YEWA3605319NC'),
       (2, 'Elvis', 'Tek', '1478523690', 'aburrido@gmail.com', '2131485217529931', 'KVHB8709319RE')

INSERT INTO tratamientos(tratamiento_nombre, costo)
VALUES ('limpieza', 500),
       ('brackets', 3000),
       ('endodoncia', 4000),
       ('super paquete', 9999);

INSERT INTO pacientes(paciente_id, consultorio_id, paciente_nombre,paciente_apellido,paciente_telefono,paciente_fecha_nacimiento)
VALUES (1,1,'Pedro','Lopez','1230987645','1996-06,06'),
(2,2,'Daniel','Zayas','2347012413','1997-05,05'),
(3,1,'Jorge','Juarez','1241245423','1998-02,02'),
(4,2,'Marco','Perez','1124124124','1999-10,01');

INSERT INTO cuentaPacientes(paciente_id, saldo)
VALUES (1, 600), (2, 1200), (3, 500), (4, 0);

INSERT INTO metodosPagos(metodo_pago) VALUES ('Efectivo'), ('Tarjeta'), ('Transferen');

INSERT INTO citas(paciente_id, dentista_id, consultorio_id, fecha_cita, comentarios)
VALUES  (1,1,1,'2021-03-01', 'Buen progreso'),
        (1,1,1,'2021-04-01', 'Buen progreso'),
        (1,1,1,'2021-05-01', 'Buen progreso'),
        (1,1,1,'2021-06-01', 'Buen progreso'),
        (1,1,1,'2021-07-01', 'Buen progreso'),
        (1,1,1,'2021-08-01', 'Buen progreso'),
        (2,2,2,'2021-06-01', 'Chequeo semanal'),
        (2,2,2,'2021-06-08', 'Chequeo semanal'),
        (2,2,2,'2021-06-15', 'Semanal'),
        (3,3,1,'2020-06-01', 'Limpieza Anual'),
        (3,3,1,'2021-06-01', 'Limpieza Anual'),
        (3,3,1,'2022-06-01', 'Limpieza Anual'),
        (4,4,2,current_date(), 'Introductoria');

INSERT INTO registroTratamientos(paciente_id, tratamiento_id, fecha_inicio)
VALUES  (1, 2, '2021-02-01'),
        (3, 1, '2019-06-01');

INSERT INTO pagos(paciente_id, metodo_pago_id, monto, fecha_pago)
VALUES (1,1, 500, '2021-03-01'),
       (1,1, 500, '2021-04-01'),
       (1,1, 500, '2021-05-01'),
       (1,1, 500, '2021-06-01'),
       (2,3, 1500, '2019-06-01'),
       (2,2, 1500, '2020-06-01'),
       (3,2, 800, '2020-06-01'),
       (4,2, 700, current_date());

DELIMITER //
CREATE TRIGGER before_citas_insert
BEFORE INSERT ON citas FOR EACH ROW
BEGIN
set @temp = (SELECT consultorio_id from dentistas where dentista_id = NEW.dentista_id);
  IF NEW.consultorio_id != @temp THEN
    SET NEW.consultorio_id = @temp;
  END IF;
END;//

DELIMITER ;

CREATE VIEW pagos_res AS
SELECT pagos.pago_id, pagos.paciente_id, CONCAT(pacientes.paciente_nombre, ' ', pacientes.paciente_apellido) as Nombre,
    pagos.monto, pagos.fecha_pago, metodosPagos.metodo_pago FROM pagos
  INNER JOIN pacientes ON pagos.paciente_id = pacientes.paciente_id
  INNER JOIN metodosPagos ON pagos.metodo_pago_id = metodosPagos.metodo_pago_id;

CREATE VIEW info_cita AS
SELECT CONCAT(pacientes.paciente_nombre, ' ', pacientes.paciente_apellido) AS Paciente, citas.fecha_cita,
  consultorios.consultorio_nombre, consultorios.consultorio_telefono, consultorios.consultorio_calle,
  CONCAT(dentistas.dentista_nombre, ' ', dentistas.dentista_apellido_paterno) as Dentista,
  dentistas.dentista_telefono, citas.comentarios FROM citas
  LEFT JOIN pacientes ON citas.paciente_id = pacientes.paciente_id
  LEFT JOIN dentistas ON citas.dentista_id = dentistas.dentista_id
  LEFT JOIN consultorios ON citas.consultorio_id = consultorios.consultorio_id;
  -- WHERE citas.paciente_id = idPaciente AND citas.cita_id = idCita;

DELIMITER $$

CREATE FUNCTION getTimeLeft(idCita int)
RETURNS datetime
DETERMINISTIC
BEGIN
DECLARE
  dt TIMESTAMP;
  SELECT fecha_cita INTO dt FROM citas WHERE cita_id = idCita;
  return timediff(dt, NOW());
END
$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE registraPago(IN idPaciente integer, IN metodoPagoId integer,IN amnt decimal(8,2))
BEGIN
START TRANSACTION;
IF amnt < 1 THEN
ROLLBACK;
END IF;
INSERT INTO pagos(paciente_id, metodo_pago_id, monto, fecha_pago, comentarios)
VALUES (idPaciente,
        metodoPagoId,
        amnt,
        (SELECT CURRENT_DATE),
        'Procedure'
      );

UPDATE cuentaPacientes
  SET saldo = (saldo - amnt)
  WHERE paciente_id = idPaciente;

COMMIT;
END $$

DELIMITER ;
