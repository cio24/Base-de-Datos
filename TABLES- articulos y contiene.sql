--Tablas ejercicio 3 practico 3 parte 1
CREATE TABLE articulo (
	id_articulo int,
	nacionalidad varchar(20) NOT NULL,
	CONSTRAINT PK_articulo PRIMARY KEY (id_articulo)
	);

CREATE TABLE contiene (
	id_articulo int,
	id_palabra int,
	CONSTRAINT PK_contiene PRIMARY KEY (id_articulo,id_palabra)
	);

ALTER TABLE contiene
	ADD CONSTRAINT FK_contiene_articulo
	FOREIGN KEY (id_articulo)
	REFERENCES articulo (id_articulo)
;

INSERT INTO articulo(id_articulo,nacionalidad) VALUES
	(1,'Chile')
;

UPDATE articulo
	SET nacionalidad = 'Chile'
	WHERE id_articulo = 1;

INSERT INTO contiene(id_articulo,id_palabra) VALUES
	(1,1),
	(1,2),
	(1,3),
	(1,4),
	(1,5),
	(1,6),
	(1,7),
	(1,8),
	(1,9),
	(1,10)
;


SELECT *
FROM articulo

SELECT *
FROM contiene

DROP TABLE contiene

DROP TABLE articulo


--Tablas ejercicio 4 practico 3 parte 1
CREATE TABLE provee (
	nro_prov int,
	cod_suc int,
	CONSTRAINT PK_provee PRIMARY KEY (nro_prov)
);

CREATE TABLE proveedor (
	nro_prov int,
	localidad varchar(20) NOT NULL,
	CONSTRAINT PK_proveedor PRIMARY KEY (nro_prov)
);

CREATE TABLE sucursal (
	cod_suc int,
	localidad varchar(20) NOT NULL,
	CONSTRAINT PK_sucursal PRIMARY KEY (cod_suc)
);


ALTER TABLE provee
	ADD CONSTRAINT FK_provee_proveedor
	FOREIGN KEY (nro_prov)
	REFERENCES proveedor (nro_prov)
;

ALTER TABLE provee
	ADD CONSTRAINT FK_provee_sucursal
	FOREIGN KEY (cod_suc)
	REFERENCES sucursal (cod_suc)
;


----------------------------------------------

--EJERCICIO 3 practico 3 parte 2
CREATE TABLE sueldos(
	id serial,
	sueldo float,
	CONSTRAINT pk PRIMARY KEY (id)
);

INSERT INTO sueldos(sueldo) VALUES
	(500)
;

SELECT * FROM sueldos

INSERT INTO sueldos(sueldo) VALUES
	(700),
	(300),
	(700)
;

CREATE OR REPLACE FUNCTION FN_sueldos() RETURNS trigger AS
$$	
	BEGIN
		UPDATE sueldos SET
			sueldo = sueldo - (SELECT min(sueldo)*0.05 FROM sueldos)
		;
		RETURN void;	
	END 
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER TR_sueldos
	BEFORE INSERT
	ON sueldos
	FOR EACH STATEMENT
	EXECUTE PROCEDURE FN_sueldos();



















