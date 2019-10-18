CREATE TABLE proveedor (
	id_proveedor varchar(10),
	nombre varchar(30) NOT NULL,
	rubro varchar(15) NOT NULL,
	cuidad varchar(30) NOT NULL,
	CONSTRAINT PK_proveedor PRIMARY KEY (id_proveedor)
);

CREATE TABLE articulo (
	id_articulo varchar(10),
	descrip varchar(30) NOT NULL,
	peso numeric(5,2) NOT NULL,
	ciudad varchar(30) NOT NULL,
	CONSTRAINT PK_articulo PRIMARY KEY (id_articulo)
);

CREATE TABLE envio (
	id_proveedor varchar(10),
	id_articulo varchar(10),	
	cantidad numeric(5,0) NOT NULL,
	CONSTRAINT PK_envio PRIMARY KEY (id_proveedor,id_articulo)
);

ALTER TABLE envio
	ADD CONSTRAINT FK_envio_proveedor
	FOREIGN KEY (id_proveedor)
	REFERENCES proveedor (id_proveedor)
;

ALTER TABLE envio
	ADD CONSTRAINT FK_envio_articulo
	FOREIGN KEY (id_articulo)
	REFERENCES articulo (id_articulo)
;





