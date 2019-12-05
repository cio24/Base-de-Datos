--##############################################################################################################
--B. ELABORACION DE RESTRICCIONES Y REGLAS DE NEGOCIO ##########################################################

--B1.2) Un movimiento de salida debe referenciar, en orden cronologico, al ultimo mivimiento interno, si los
--      tuviera, o al movimiento de entrada (respecto del mismo pallet).

--1) Escriba la restriccion de la manera que considere mas apropiada en SQL estandar declarativo.

ALTER TABLE G06_MOVIMIENTO ADD CONSTRAINT CK_G06_MOV_ANTERIOR_NO_CONSISTENTE
CHECK (NOT EXISTS (SELECT 0 --no queresmos que exista
					FROM G06_MOVIMsIENTO m --un movimiento
					WHERE tipo = 'S' --de salida
						AND (id_mov_ant <> (SELECT id_movimiento -- cuyo movimiento anterior no sea el más reciente
										    FROM G06_MOVIMIENTO
										    WHERE tipo <> 'S' AND cod_pallet = m.cod_pallet -- movimiento de entrada e interno del mismo pallet
										    ORDER BY fecha DESC --se los ordena decendientemente para que quede primero el mas reciente
										    LIMIT 1
										   )
							OR fecha <= (SELECT fecha --cuyo fecha no sea mayor a su ultimo movimiento
			 						  	 FROM G06_MOVIMIENTO
 				 					  	 WHERE id_movimiento = m.id_mov_ant
 				 					 	)
 				 		) -- END AND
 				 	) --END NOT EXISTS
		AND 
		NOT EXISTS (SELECT 0 -- ademas se comprueba que no haya mas de un movimiento de salida por pallet
					FROM G06_MOVIMIENTO
					WHERE tipo = 'S'
					GROUP BY cod_pallet
					HAVING count(*) > 1					   
					)
);


--2) implementacion de la restriccion en PostgreSQL

CREATE OR REPLACE FUNCTION FN_G06_MOV_ANTERIOR_NO_CONSISTENTE() RETURNS TRIGGER AS
$BODY$
DECLARE 
	_ultimo_mov record;
BEGIN
	--primero se verifica si el pallet ya tiene un movimiento de salida
	IF(TG_OP = 'INSERT' OR NEW.cod_pallet <> OLD.cod_pallet) THEN --esto se controla solo cuando se hace un insert o no se cambia de pallet
		IF(EXISTS (
				SELECT 0
				FROM G06_MOVIMIENTO
				WHERE cod_pallet = NEW.cod_pallet AND tipo = 'S'
			)
		) THEN
			RAISE EXCEPTION 'Ya existe un movimiento de salida para este pallet';
		END IF;
	END IF;
	
	--ahora obtenemos el ultimo movimiento del pallet
	SELECT * INTO _ultimo_mov
	FROM G06_MOVIMIENTO
	WHERE cod_pallet = NEW.cod_pallet
	ORDER BY fecha DESC
	LIMIT 1;
	
	--comparamos si el ultimo mivimiento coincide con el que se ingreso
	IF(_ultimo_mov.id_movimiento <> NEW.id_mov_ant) THEN
		RAISE EXCEPTION 'El movimiento anterior no es el mas reciente del pallet';
	END IF;
	--finalmente se comprueba que el ultimo de todos los movimiento (cronologicamente) sea el de salida
	IF (_ultimo_mov.fecha>=NEW.fecha) THEN
		RAISE EXCEPTION 'El ultimo movimiento (cronologicamente) debe ser de salida';
	END IF;

	
	RETURN NEW;
END 
$BODY$
LANGUAGE 'plpgsql';

CREATE TRIGGER TR_G06_INSERT_MOV_ANTERIOR_NO_CONSISTENTE
BEFORE INSERT ON G06_MOVIMIENTO
FOR EACH ROW
WHEN (NEW.tipo='S')
EXECUTE PROCEDURE FN_G06_MOV_ANTERIOR_NO_CONSISTENTE();

CREATE TRIGGER TR_G06_UPDATE_MOV_ANTERIOR_NO_CONSISTENTE
BEFORE UPDATE OF id_mov_ant,fecha,cod_pallet ON G06_MOVIMIENTO
FOR EACH ROW
WHEN (OLD.tipo='S')
EXECUTE PROCEDURE FN_G06_MOV_ANTERIOR_NO_CONSISTENTE();


--3) sentencias que promueven la activacion de la restriccion

--INSERCION DE VALORES CONSISTENTES PARA REALIZAR PRUEBAS

INSERT INTO G06_MOVIMIENTO VALUES
	--movimientos de un mismo pallet sin salida
	(1, to_timestamp('01/11/2019/00/00/00','DD/MM/YYYY/HH24/MI/SS'), 'E', NULL, 3, 'DNI', 3206411, '00739448'),
	(2, to_timestamp('02/11/2019/00/00/00','DD/MM/YYYY/HH24/MI/SS'), 'I', 1, 6, 'DNI', 3206411,'00739448'),
	(3, to_timestamp('03/11/2019/00/00/00','DD/MM/YYYY/HH24/MI/SS'), 'I', 2, 8, 'DNI', 3206411,'00739448'),
	(4, to_timestamp('04/11/2019/00/00/00','DD/MM/YYYY/HH24/MI/SS'), 'I', 3, 23, 'DNI', 3206411,'00739448'),
	--movimiento de un mismo pallet con salida
	(6, to_timestamp('06/11/2019/00/00/00','DD/MM/YYYY/HH24/MI/SS'), 'E', NULL, 26,'DNI',3206411, '02596499'),
	(7, to_timestamp('07/11/2019/00/00/00','DD/MM/YYYY/HH24/MI/SS'), 'I', 6, 35, 'DNI',3206411, '02596499'),
	(8, to_timestamp('08/11/2019/00/00/00','DD/MM/YYYY/HH24/MI/SS'), 'I', 7, 44, 'DNI',3206411, '02596499'),
	(9, to_timestamp('09/11/2019/00/00/00','DD/MM/YYYY/HH24/MI/SS'), 'S', 8, 47, 'DNI',3206411, '02596499')
;

--eliminacion de valores cargados
DELETE FROM G06_MOVIMIENTO WHERE id_movimiento BETWEEN 1 AND 9;

-- INSERTS Y UPDATES DE VALORES PARA REALIZAR PRUEBAS

--inserts
INSERT INTO G06_MOVIMIENTO VALUES -- un nuevo movimiento cuyo movimiento anterior no es el mas reciente
	(5, to_timestamp('05/11/2019/00/00/00','DD/MM/YYYY/HH24/MI/SS'), 'S', 3, 57, 'DNI', 3206411, '00739448');

INSERT INTO G06_MOVIMIENTO VALUES -- un nuevo movimiento de salida con fecha menor al movimiento anterior
	(5, to_timestamp('03/11/2019/00/00/00','DD/MM/YYYY/HH24/MI/SS'), 'S', 4, 57, 'DNI', 3206411, '00739448');

INSERT INTO G06_MOVIMIENTO VALUES -- un nuevo movimiento de salida para un pallet que ya tiene movimiento de salida
	(10, to_timestamp('10/11/2019/00/00/00','DD/MM/YYYY/HH24/MI/SS'), 'S', 8, 57, 'DNI', 3206411, '02596499');

INSERT INTO G06_MOVIMIENTO VALUES -- un nuevo movimiento de salida con datos que no generan inconsistencia
	(5, to_timestamp('05/11/2019/00/00/00','DD/MM/YYYY/HH24/MI/SS'), 'S', 4, 57, 'DNI', 3206411, '00739448');

--borrado de tuplas que se insertaron para las pruebas
DELETE FROM G06_MOVIMIENTO WHERE id_movimiento = 5 ;
DELETE FROM G06_MOVIMIENTO WHERE id_movimiento = 10 ;

--updates

--se cambia el movimiento anterior a uno que no es el mas reciente
UPDATE G06_MOVIMIENTO SET id_mov_ant = 7 WHERE id_movimiento = 9;
UPDATE G06_MOVIMIENTO SET id_mov_ant = 8 WHERE id_movimiento = 9; --se restaura 

--se cambia la fecha del movimiento de salida a una fecha previa a la del movimiento anterior
UPDATE G06_MOVIMIENTO SET fecha = to_timestamp('07/11/2019/00/00/00','DD/MM/YYYY/HH24/MI/SS') WHERE id_movimiento = 9;
UPDATE G06_MOVIMIENTO SET fecha = to_timestamp('09/11/2019/00/00/00','DD/MM/YYYY/HH24/MI/SS') WHERE id_movimiento = 9; --se restaura

--se cambia el pallet de un movimiento de salida por lo que el movimiento anterior no deberia ser el correcto
UPDATE G06_MOVIMIENTO SET cod_pallet = '00739448' WHERE id_movimiento = 9;
UPDATE G06_MOVIMIENTO SET cod_pallet = '02596499' WHERE id_movimiento = 9; --se restaura

--se cambia el pallet pero se agrega el movimiento anterior correspondiente (no se generan inconsistencias)
UPDATE G06_MOVIMIENTO SET cod_pallet = '00739448', id_mov_ant = 4 WHERE id_movimiento = 9;
UPDATE G06_MOVIMIENTO SET cod_pallet = '02596499', id_mov_ant = 8 WHERE id_movimiento = 9;

--QUERIES DEL CHECK PARA VERIFICAR EL CORRECTO FUNCIONAMIENTO DEL MISMO

SELECT * FROM g06_movimiento ORDER BY fecha;

--PRIMER NOT EXISTS
SELECT m.id_movimiento --no queresmos que exista
FROM G06_MOVIMIENTO m --un movimiento
WHERE tipo = 'S' --de salida
	AND (id_mov_ant <> (SELECT id_movimiento -- cuyo movimiento anterior no sea el más reciente
					   FROM G06_MOVIMIENTO
					   WHERE tipo <> 'S' AND cod_pallet = m.cod_pallet -- movimiento de entrada e interno del mismo pallet
					   ORDER BY fecha DESC --se los ordena decendientemente para que quede primero el mas reciente
					   LIMIT 1
					  )
		OR fecha <= (SELECT fecha --cuyo fecha no sea mayor a su ultimo movimiento
				  	 FROM G06_MOVIMIENTO
				  	 WHERE id_movimiento = m.id_mov_ant
				 	)
		)
;

--SEGUNDO NOT EXIST 
SELECT count(*) -- ademas se comprueba que no haya mas de un movimiento de salida por pallet
FROM G06_MOVIMIENTO
WHERE tipo = 'S'
GROUP BY cod_pallet
HAVING count(*) > 1	
;
