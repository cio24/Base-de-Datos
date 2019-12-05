--###############################################################################################################################
--EJERCICIO 1 ###################################################################################################################

--a)

ALTER TABLE alquiler_servicio
	ADD CONSTRAINT FK_alquiler_servicio_servicio
	FOREIGN KEY (tipo_serv,id_servicio)
	REFERENCES servicio (tipo_serv,id_servicio)
	ON DELETE RESTRICT
	ON UPDATE RESTRICT
;

ALTER TABLE alquiler_servicio
	ADD CONSTRAINT FK_alquiler_servicio_alquiler
	FOREIGN KEY (id_alquiler)
	REFERENCES alquiler (id_alquiler)
	ON DELETE CASCADE
	ON UPDATE CASCADE
;


--###############################################################################################################################
--EJERCICIO 6 ###################################################################################################################


CREATE ASSERTION AS_no_mas_5_servicio
CHECK NOT EXISTS(
	SELECT 1
	FROM alquiler a JOIN alquiler_servicio ac ON (a.id_alquiler = ac.id_alquiler)
	WHERE fecha_desde >= to_date('15/11/2019','dd/mm/yyyy')
	GROUP BY  a.id_alquiler
	HAVING count(*) > 5
);


/*
+==============================+=========================================+=========================================+=========================================+
|            Tablas            |                 Insert                  |                 Update                  |                 Delete                  |
+==============================+=========================================+=========================================+=========================================+
| alquiler                     |              xxxxxxxxxxxx               |               fecha_desde               |                xxxxxxxxxx               |
+------------------------------+-----------------------------------------+-----------------------------------------+-----------------------------------------+
| alquiler_servicio            |               ooooooooooo               |              id_alquiler                |               xxxxxxxxxxx               |
+------------------------------+-----------------------------------------+-----------------------------------------+-----------------------------------------+
*/




--###############################################################################################################################
--EJERCICIO 8 ###################################################################################################################

a) Construya una vista que contenga los identificadores de los usuarios que poseen antigüedad mayor a un año, junto con su direccion e importe total de los alquileres
   iniciados durante el corriente año correspondientes a servicios de más de 1 hora de duración.

CREATE VIEW usuarios_un_anio AS
	SELECT u.nro_doc,u.tipo_doc,direccion,sum(importe)
	FROM usuario u JOIN alquiler a ON (a.nro_doc = u.nro_doc) AND (a.tipo_doc = u.tipo_doc)
	WHERE fecha_ingreso < current_date - INTERVAL '1 year' AND fecha_desde >= current_date - INTERVAL '1 year'
	GROUP BY u.nro_doc, u.tipo_doc --no hace falta que ponga sum(importe) porque posgresql





--###############################################################################################################################
--EJERCICIO 10 ###################################################################################################################


Considere que se agrega a la tabla ALQUILER el atributo servicios_distintos, que registra la cantidad de servicios diferentes asociados a cada alquiler,
el cual se desea mantener automáticamente actualizado. 



/*
+==============================+=========================================+=========================================+=========================================+
|            Tablas            |                 Insert                  |                 Update                  |                 Delete                  |
+==============================+=========================================+=========================================+=========================================+
| alquiler                     |            oooooooooooo                 |            xxxxxxxxxxxxx                |        xxxxxxxxxxxxxxxxxxxx             |
+------------------------------+-----------------------------------------+-----------------------------------------+-----------------------------------------+
| alquiler_servicio            |          oooooooooooooo                 |         tipo_serv/id_alquiler           |          oooooooooooooooo               |
+------------------------------+-----------------------------------------+-----------------------------------------+-----------------------------------------+
*/


CREATE OR REPLACE FUNCTION FN_insert_update_alquiler_servicio() RETURNS TRIGGER AS
$BODY$
	BEGIN
		IF(
			NOT EXISTS (
				SELECT 0
				FROM alquiler_servicio
				WHERE id_alquier = NEW.id_alquiler AND tipo_ser = NEW.tipo_serv
			)
		
		)THEN
			UPDATE alquiler SET servicios_distintos = servicios_distintos + 1 WHERE id_alquiler = NEW.id_alquiler;
		END IF;
	
		IF(TG_OP = 'UPDATE') THEN
			IF(	(SELECT count(tipo_serv) FROM alquiler_servicio WHERE tipo_serv = OLD.tipo_serv AND id_alquiler = OLD.id_alquiler) = 1 )THEN
				UPDATE alquiler SET servicios_distintos = servicios_distintos - 1 WHERE id_alquiler = OLD.id_alquiler;
			END IF;
		END IF;
		RETURN NEW;
	END 
$BODY$
LANGUAGE 'plpgsql';

CREATE TRIGGER TR_insert_update_alquiler_servicio
	BEFORE INSERT OR UPDATE OF tipo_serv,id_alquiler
	ON alquiler_servicio
	FOR EACH ROW
	EXECUTE PROCEDURE FN_insert_update_alquiler_servicio();
	

CREATE OR REPLACE FUNCTION FN_insert_alquiler() RETURNS TRIGGER AS
$BODY$
	BEGIN
		NEW.servicios_distintos = 0;
		RETURN NEW;
	END 
$BODY$
LANGUAGE 'plpgsql';

CREATE TRIGGER TR_insert_alquiler
	BEFORE INSERT
	ON alquiler
	FOR EACH ROW
	EXECUTE PROCEDURE FN_insert_alquiler();

















--###############################################################################################################################
--EJERCICIO 4 ###################################################################################################################