--####################################################################################################################
--BEGIN PRACTICO 2 PARTE 1 ###########################################################################################

--1.1
select distinct id_tarea
from voluntario

--1.2
select distinct_ nro_voluntario, id_tarea, id_institucion
from historico
--order by nro_voluntario

--2.1
select apellido, nombre, e_mail
from voluntario
where horas_aportadas > 1000
order by apellido

--2.2
select apellido, telefono
from voluntario
where id_institucion = 20 or id_institucion = 30
order by apellido, nombre

--2.3
select apellido || nombre as "Apellido y nombre", e_mail as "Direccion de mail", telefono
from voluntario
where telefono like '+54%'

--2.4
select nombre, apellido, e_mail
from empleado
where e_mail like '%@gmail.com' and sueldo > 1000

--2.5
select apellido, id_tarea, horas_aportadas
from voluntario
where (id_tarea = 'SA_REP' or id_tarea = 'ST_CLERK') and (horas_aportadas <> 2.500 and horas_aportadas <> 3500 and horas_aportadas <> 7000)

--3.1
select nombre, apellido, id_empleado, porc_comision
from empleado
where porc_comision = 0.5 or porc_comision is null

--3.2
select *
from distribuidor
where tipo = 'I' and telefono is null

--3.3
select id_departamento, nombre	
from departamento
where jefe_departamento is null

--3.4
select *
from institucion
where id_director is not null

--3.5
select apellido, id_tarea
from voluntario
where id_coordinador is null

--3.6
select apellido, horas_aportadas, porcentaje
from voluntario
where horas_aportadas > 0 and horas_aportadas is not null
order by (horas_aportadas, porcentaje) desc

--4.1
select nombre, apellido, id_tarea, fecha_nacimiento
from voluntario
where extract (month from fecha_nacimiento) = 5 

--4.2
select nombre || ', ' || apellido as "Nombre y Apellido", fecha_nacimiento
from voluntario
order by (extract (month from fecha_nacimiento), extract (day from fecha_nacimiento)) desc

--5.1
select sum(sueldo)
from empleado

--5.2
select id_institucion, count(nro_voluntario)
from voluntario
group by id_institucion

--5.3
select min(fecha_nacimiento), max(fecha_nacimiento)
from voluntario

--5.4
select nro_voluntario, count(*)
from historico
group by nro_voluntario

--5.5
select min(horas_aportadas), max(horas_aportadas), avg(horas_aportadas)
from voluntario
where extract (year from age(fecha_nacimiento)) > 25

--5.6
select count(*)
from pelicula
group by idioma

--5.7
select id_departamento, count(*)
from empleado
group by id_departamento

--5.8
select id_coordinador
from voluntario
group by id_coordinador
having count(*) > 8

--5.9
select id_institucion, count(*)
from voluntario
group by 1
having count(*) > 10

--5.10
select codigo_pelicula
from renglon_entrega
group by codigo_pelicula
having count(*) between 3 and 5

--6.1
select *
from direccion
order by id_direccion
limit 10

--6.2
select *
from tarea
where nombre_tarea like 'O%' or nombre_tarea like 'A%' or nombre_tarea like 'C%'
limit 5
offset 11

--END PRACTICO 2 PARTE 1 #############################################################################################
--####################################################################################################################



--####################################################################################################################
--BEGIN PRACTICO 2 PARTE 2 ###########################################################################################
--1.1
select v.nro_voluntario, nombre, apellido, count(*)
from voluntario v join historico h on (v.nro_voluntario = h.nro_voluntario)
group by v.nro_voluntario, nombre, apellido

--1.2
select nombre, apellido, e_mail, telefono
from voluntario v 
	join tarea t on (v.id_tarea = t.id_tarea)
	join historico h on (t.id_tarea = h.id_tarea)
where max_horas - min_horas <= 5000 and fecha_fin < to_date('24/07/1998','dd,MM,YYYY')

--1.3
select distinct i.id_institucion, nombre_institucion, d.*
from institucion i
	join direccion d on (i.id_direccion = d.id_direccion)
where i.id_institucion not in (
	select id_institucion
	from voluntario v join tarea t on (v.id_tarea = t.id_tarea)
	where horas_aportadas >= max_horas
)

--1.4
select nombre_pais
from pais
where id_pais not in(
	select p.id_pais
	from pais p
	join direccion d on (p.id_pais = d.id_pais)
	join institucion i on (d.id_direccion = i.id_direccion)
	join historico h on (i.id_institucion = h.id_institucion)
)
order by nombre_pais

--5
select id_tarea 
from tarea
where id_tarea not in(
	select id_tarea
	from voluntario
)

SELECT t.id_tarea
FROM unc_esq_voluntario.tarea t
WHERE NOT EXISTS (
    SELECT v.nro_voluntario
    FROM unc_esq_voluntario.voluntario v
    WHERE v.id_tarea = t.id_tarea
    )

--6
select nombre_pais, count(nro_voluntario)
from pais p
	join direccion d on (p.id_pais = d.id_pais)
	join institucion i on (d.id_direccion = i.id_direccion)
	join voluntario v on (i.id_institucion = v.id_institucion)
where AGE(v.fecha_nacimiento) > '20 years' and i.id_institucion in (
	select id_institucion
	from voluntario
	group by id_institucion
	having max(horas_aportadas) - min(horas_aportadas) <= 5000 and count(*) > 4
)
group by nombre_pais

--7
select v.nro_voluntario, nombre, apellido
from voluntario v 
	join institucion i on (v.id_institucion = i.id_institucion)
	join direccion d on (i.id_direccion = d.id_direccion)
	join pais p on (d.id_pais = p.id_pais)
	join continente c on (p.id_continente = c.id_continente)
where v.nro_voluntario = i.id_director and nombre_continente = 'Europeo'
	
--8
select t.id_tarea, nombre_tarea, max_horas
from tarea t
	join voluntario v on (t.id_tarea = v.id_tarea)
	join institucion i on (v.id_institucion = i.id_institucion)
	join direccion d on (i.id_direccion = d.id_direccion)
where ciudad = 'Munich' and t.id_tarea in(
	select id_tarea
	from voluntario
	group by id_tarea
	having count(*) = 1
)
order by t.id_tarea

--9
select distinct d.*
from historico h 
	join institucion i on (h.id_institucion = i.id_institucion)
	join direccion d on (i.id_direccion = d.id_direccion)
where exists (
	select v.id_institucion
	from voluntario v
	where v.id_tarea = h.id_tarea and v.id_institucion <> h.id_institucion
) and i.id_director is not null

--10
select nombre, apellido
from voluntario v
	join institucion i on (v.id_institucion = i.id_institucion)
	join direccion d on (i.id_direccion = d.id_direccion)
where provincia = 'Washington' and id_director in (
	select nro_voluntario
	from historico
	group by nro_voluntario
	having count(*) >= 2
)

--11
select distinct v.id_institucion, nombre_institucion 
from voluntario v 
	join tarea t on (v.id_tarea = t.id_tarea)
	join institucion i on (v.id_institucion = i.id_institucion)
where max_horas <= 3500 or horas_aportadas <= 4000

--12	
select  v.nro_voluntario, nombre
from historico h
	join voluntario v on (h.nro_voluntario = v.nro_voluntario)
group by v.nro_voluntario
order by count(*) desc
limit 5

--13
select distinct t.*
from tarea t
	join voluntario v on (t.id_tarea = v.id_tarea)
	join institucion i on (v.id_institucion = i.id_institucion)
	join direccion d on (i.id_direccion = d.id_direccion)
	join pais p on (d.id_pais = p.id_pais)
where nombre_pais = 'Reino Unido'

--14
select i.*, count(*)
from institucion i 
	join voluntario v on (i.id_institucion = v.id_institucion)
	join tarea t on (v.id_tarea = t.id_tarea)
group by i.id_institucion, i.nombre_institucion, i.id_direccion, i.id_director
having count(*) > 0.2*(
	select count(id_tarea)
	from voluntario
	where id_tarea is not null
)

--END PRACTICO 2 PARTE 2 #############################################################################################
--####################################################################################################################



--####################################################################################################################
--BEGIN PRACTICO 3 PARTE 1 ###########################################################################################

--EJERCICIO 3--------------------

PARA EL EJERCICIO A Y B, PODRÃ�A DEJARLO PLANTEADO COMO DOMINIOS O SIMPLEMENTE CON HACER UN ALTER TABLE CHECK YA ESTARÃ�A?
--a)
CREATE DOMAIN nacionalidad_valida AS varchar(40) NOT NULL
CHECK (value LIKE 'Argentina' OR value LIKE 'EspaÃ±ol' OR value LIKE 'InglÃ©s' OR value LIKE 'Chilena' OR value LIKE 'AlemÃ¡n');

--b)
CREATE DOMAIN fecha_valida AS date NOT NULL
CHECK (EXTRACT (YEAR FROM value) >= 2010));

ESTA BIEN PLANTEADA LA CONDICIÃ“N?
--c)
ALTER TABLE articulo ADD CONSTRAINT ck_art_2017_arg
CHECK (
	EXTRACT ((YEAR FROM fecha_pub) = 2017 AND naciolalidad = 'Argentina') OR EXTRACT (YEAR FROM fecha_pub) <> 2017
);

--d)
ALTER TABLE contiene ADD CONSTRAINT ck_art_max_15_pal
CHECK (
	NOT EXISTS (
		SELECT 1
		FROM contiene
		GROUP BY id_articulo
		HAVING count(*) > 15
);

--e)
CREATE ASSERTION art_arg_max_10_pal
CHECK (
	NOT EXISTS(
		SELECT 1
		FROM contiene c JOIN articulo a ON (c.id_articulo = a.id_articulo)
		WHERE nacionalidad = 'Argentina'
		GROUP BY c.id_articulo
		HAVING count(*) > 10
	)
);


--EJERCICIO 4--------------------

--a) con triggers
create or replace function fn_maximo_pl_claves() returns trigger as $$
declare
	cant integer;
begin
	select count(*) into cant
	from contiene
	where id_articulo = new.id_articulo
	if(cant>2) then
		raise exception 'SuperÃ³ la cantidad de palabras claves:%',cantidad;
	end if;
	return new;
end $$
language 'plpgsql';

create trigger t_maximo_pl_claves
before insert or update of id_articulo
on contiene 
for each row execute procedure fn_maximo_pl_claves();

--a) declarativo
alter table provee add constraint max_20_prod
check not exists(
	select 1
	from provee
	group by nro_prov
	having count(*) > 20
);


--b)
alter table sucursal add constraint ck_control_cod
check (cod_suc like 'S%');

--c)
alter table producto add constraint ck_notDescNull
check(
	descripcion is not null or presentacion is not null
);

--d) como se verifica que no se cambie una localidad de sucursal y proveedor?? habrÃ­a que agregar esta misma constraint???
-- CAPAZ QUE ES XQ SI YO INTENTO CAMBIAR UNA LOCALIDAD ESTA CONSTRAINT NO ME DEJA...
CREATE ASSERTION prod_suc_mismaLoc
CHECK (
	not exists (
	select 1
	from provee pp
		join proveedor p on (pp.nro_prov = p.nro_prov)
		join sucursar s on (pp.cod_sucursal = s.cod_sucursal)
		where s.localidad <> p.localidad
	)
);

--EJERCICIO 5--------------------

--a)
alter table voluntario add constraint ck_not_greater_than_70
check (
	extract (year from age(fecha_nacimiento)) <= 70
);


--b)
--querÃ­a ver si se puede hacer algo de este estilo, como el inciso de arriba por ejemplo, cuando hace el check, solo chequea
-- que lo que se esta queriendo agregar tenga un campo fecha de nacimiento que cumpla con eso? no me queda claro como funciona
alter table voluntario add constraint ck_vol_moreHours_than_coor
check (
	horas_aportadas <= (select c.horas_aportadas
		from voluntario v join voluntario c on (v.id_coordinador = c.nro_voluntario)
		where id_coordinador = c.nro_voluntario
	)
);


CHECK NOT EXISTS (
	SELECT 1
	FROM voluntario v JOIN voluntario c ON (v.id_coordinador = c.nro_voluntario)
	WHERE v.horas_aportadas > c.horas_aportadas
)

IF (EXISTS (SELECT 1
	FROM voluntario v JOIN voluntario c ON (v.id_coordinador = c.nro_voluntario)
	
	WHERE v.horas_aportadas > c.horas_aportadas
	AND new.nro_nro volunatario = v.nro_voluntario) THEN RAISE exception ....



--esta es la versiÃ³n que creo que anda, pero que hace un select, por lo cual podrÃ­a ser menos eficiente que el de arriba
-- en el caso de que el de arriba sea valido obvio
alter table voluntario add constraint ck_vol_moreHours_than_coor
check (
	not exists(
		select 1
		from voluntario v join voluntario c on (v.id_coordinador = c.nro_voluntario)
		where v.horas_aportadas <= c.horas_aportadas
	)
);


--c)

CREATE ASSERTION ck_vol_hours_out_of_bounds
CHECK (
	NOT EXISTS (
		SELECT 1
		FROM voluntario v JOIN tarea t ON (v.id_tarea = t.id_tarea)
		WHERE horas_aportadas BETWEEN min_horas AND max_horas
	)
);

--d)
alter table voluntario add constraint ck_vol_sameTask_coor
check (
	not exists(
		select 1
		from voluntario v join voluntario c on (v.id_coordinador = c.nro_voluntario)
		where v.id_tarea <> c.id_tarea
	)
);

--e)
ALTER TABLE historico ADD CONSTRAINT ck_vol_lessThan3_inst
CHECK (
	NOT EXISTS (
		SELECT 1
		FROM (
			SELECT DISTINCT nro_voluntario, id_institucion
			FROM historico
		) AS subquery
		GROUP BY nro_voluntario
		HAVING count(*) >= 3
	)
);


--END PRACTICO 2 PARTE 2 #############################################################################################
--####################################################################################################################

--####################################################################################################################
--BEGIN PRACTICO 3 PARTE 1 ###########################################################################################


--EJERCICIO 1

--3.d)
CREATE OR REPLACE FUNCTION FN_art_max_15_pal() RETURNS trigger AS
$$
	DECLARE
		counter integer;
	BEGIN
		SELECT count(*) INTO counter  --don't forget to use the variable!!
		FROM contiene
		WHERE id_articulo = NEW.id_articulo;
		IF (counter >= 14) THEN
			RAISE EXCEPTION 'los articulos no pueden tener una cantidad de palabras claves mayor a %',counter;
		END IF;
		RETURN NEW;
	END
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER TR_art_max_15_pal_contiene
	BEFORE INSERT OR UPDATE OF id_articulo
	ON contiene
	FOR EACH ROW EXECUTE PROCEDURE FN_art_max_15_pal();

--3.e)
CREATE OR REPLACE FUNCTION FN_art_arg_max_10_pal() RETURNS trigger AS
$$
	DECLARE
		counter integer;
		v_nacionalidad articulo.nacionalidad%TYPE;
	BEGIN
		--tabla articulo
		IF(tg_table_name = 'articulo') THEN
			SELECT count(*) INTO counter
			FROM contiene
			WHERE id_articulo = NEW.id_articulo;
			IF(counter >= 9) THEN
				RAISE EXCEPTION 'Te pasaste de palabras claves wacho, no pueden ser mÃ¡s de %', counter;
			END IF;
		ELSE
			--tabla contiene
			SELECT nacionalidad INTO v_nacionalidad
			FROM articulo
			WHERE id_articulo = NEW.id_articulo;
			if(v_nacionalidad = 'Argentina') THEN
				SELECT count(*) INTO counter
				FROM contiene
				WHERE id_articulo = NEW.id_articulo;
				if(counter >= 10) THEN
					RAISE EXCEPTION 'Te pasaste de palabras claves wacho, no pueden ser mÃ¡s de %', counter;
				END IF;
			END IF;
		END IF;
		RETURN NEW;
	END 
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER TR_art_arg_max_10_pal_contiene
	BEFORE INSERT OR UPDATE of  id_articulo
	ON contiene
	FOR EACH ROW EXECUTE PROCEDURE FN_art_arg_max_10_pal();

CREATE TRIGGER TR_art_arg_max_10_pal_articulo
	BEFORE UPDATE OF nacionalidad
	ON articulo
	FOR EACH ROW 
	WHEN (NEW.nacionalidad = 'Argentina')
	EXECUTE PROCEDURE FN_art_arg_max_10_pal();

--4.a)
CREATE OR REPLACE FUNCTION FN_prov_max_prod_reach() RETURNS trigger AS
$$
	DECLARE
		counter integer;
	BEGIN
		SELECT count(*) INTO counter  --don't forget to use the variable!!
		FROM provee
		WHERE nro_prov = NEW.nro_prov;
		IF (counter > 20) THEN
				RAISE EXCEPTION 'los proveedores no puede proveer una cantidad de productos mayor a:%',counter;
		END IF;
		RETURN NEW;
	END 
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER TR_prov_max_prod_reach
	BEFORE INSERT OR UPDATE OF nro_prov OR 
	BEFORE INSERT OR UPDATE OF cod_producto 
	ON provee
	FOR EACH ROW
	EXECUTE PROCEDURE FN_prov_max_prod_reach();

--4.d)
CREATE OR REPLACE FUNCTION FN_prov_same_origin_prod() RETURNS trigger AS
$$
	DECLARE
		counter integer;
		p_localidad = proveedor.localidad%TYPE;
		s_localidad = sucursal.localidad%TYPE;
	BEGIN
		counter = 0; --se debe inicializar esto? que onda jaja
		if(tg_table_name == 'sucursal') THEN
		--if exists ();
			SELECT count(*) INTO counter --obtengo todos los proveedores que proveen para la sucursar actualizada y tienen una localidad diferente a la nueva! 
			FROM provee p JOIN proveedor pp ON (p.nro_prov = pp.nro_prov)
			WHERE cod_suc = NEW.cod_sucursal AND pp.localidad <> NEW.localidad
			if(counter > 0) THEN
				RAISE EXCEPTION 'un proveedor solo puede proveer productos a sucursales de su localidad!';
			END IF;
		ELSE
			if(tg_table_name == 'proveedor') THEN
				SELECT count(*) INTO counter --obtengo todas las localidades para las que provee el proveedor actualizado y tienen una localidad diferente a la de este! 
				FROM provee p JOIN sucursal s ON (p.cod_suc = s.cod_suc)
				WHERE nro_prov = NEW.nro_prov AND pp.localidad <> NEW.localidad
				if(counter > 0) THEN
					RAISE EXCEPTION 'un proveedor solo puede proveer productos a sucursales de su localidad!'
				END IF;
			ELSE
				SELECT localidad INTO s_localidad --obtengo la localidad en la que se encuentra la sucursal de la tupla
				FROM sucursal
				WHERE cod_suc = NEW.cod_suc;
			
				SELECT localidad INTO p_localidad --obtengo la localidad en la que se encuentra el proveedor de la tupla
				FROM proveedor
				WHERE nro_prov = NEW.nro_prov;
				IF(s_localidad <> p_localidad) THEN
					RAISE EXCEPTION 'un proveedor solo puede proveer productos a sucursales de su localidad!'
				END IF;
			END IF;
		END IF;
		RETURN NEW;
	END 
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER TR_prov_same_origin_prod_suc
	BEFORE UPDATE OF localidad
	ON sucursal
	FOR EACH ROW
	EXECUTE PROCEDURE FN_prov_same_origin_prod();

CREATE TRIGGER TR_prov_same_origin_prod_suc
	BEFORE UPDATE OF localidad
	ON proveedor
	FOR EACH ROW
	EXECUTE PROCEDURE FN_prov_same_origin_prod();

CREATE TRIGGER TR_prov_same_origin_prod_suc
	BEFORE INSERT OR UPDATE OF cod_suc, nro_prov
	ON sucursal
	FOR EACH ROW
	EXECUTE PROCEDURE FN_prov_same_origin_prod();


--5.b)
CREATE OR REPLACE FUNCTION FN_vol_hours_greater_than_his_coor() RETURNS trigger AS
$$
	DECLARE
		amount integer;
	BEGIN
		SELECT horas_aportadas INTO amount
		FROM voluntario
		WHERE nro_voluntario = NEW.id_coordinador;
		--QUE PASA SI LA CONSULTA ME DA NULL O NINGUNA FILA QUE CUMPLA NRO_VOLUNTARIO = NEW.ID_COORDINADOR????????
		IF (NEW.horas_aportadas > amount) THEN
			RAISE EXCEPTION 'las horas aportadas por los voluntarios no pueden ser mayor que la de sus coordinadores';
		END IF;
	
		IF(
			EXISTS(
				SELECT 1
				FROM voluntario
				WHERE id_coordinador = NEW.nro_voluntario AND horas_aportadas > NEW.horas_aportadas
			)
		) THEN
			RAISE EXCEPTION 'las horas aportadas por los voluntarios no pueden ser mayor que la de sus coordinadores';
		END IF;
		RETURN NEW;
	END 
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER TR_vol_hours_less_than_his_coor
	BEFORE INSERT OR UPDATE  OF horas_aportadas OR UPDATE OF id_coordinador
	ON voluntario
	FOR EACH ROW
	EXECUTE PROCEDURE FN_vol_hours_less_than_his_coor();

--5.c)

CREATE OR REPLACE FUNCTION FN_hours_vol_between_maxmin_hours_tarea() RETURNS trigger AS
$$
	DECLARE
		min integer;
		max integer;
	BEGIN
		IF(tg_table_name == 'voluntario') then
			SELECT min_horas INTO min  --don't forget to use the variable!!
			FROM tarea
			WHERE id_tarea = NEW.id_tarea;
			
			SELECT max_horas INTO max
			FROM tarea
			WHERE id_tarea = NEW.id_tarea
			IF (horas_aportadas < min or horas_aportadas > max ) THEN
					RAISE EXCEPTION 'Las horas aportadas deben estar entre el minimo y el maximo de las tareas!';
			END IF;
		ELSE
			SELECT count(*) INTO counter
			FROM voluntario
			WHERE id_tarea = NEW.id_tarea AND horas_aportadas NOT BETWEEN NEW.min_horas AND NEW.max_horas
			if(counter > 0) THEN
				RAISE EXCEPTION 'Las horas aportadas deben estar entre el minimo y el maximo de las tareas!'
			END IF;
		END IF;
		RETURN NEW;
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER TR_hours_vol_between_maxmin_hours_tarea
	BEFORE INSERT OR UPDATE OF horas_aportadas OR UPDATE id_tarea
	ON voluntario
	FOR EACH ROW
	EXECUTE PROCEDURE FN_hours_vol_between_maxmin_hours_tarea();

CREATE TRIGGER TR_hours_vol_between_maxmin_hours_tarea
	BEFORE UPDATE OF min_horas OR UPDATE max_horas
	ON tarea
	FOR EACH ROW
	EXECUTE PROCEDURE FN_hours_vol_between_maxmin_hours_tarea();

--5.d)        
CREATE OR REPLACE FUNCTION FN_vol_must_have_same_task_coord() RETURNS trigger AS
$$
	DECLARE
		tarea voluntario.id_tarea%TYPE;
		counter integer;
	BEGIN
		SELECT id_tarea INTO tarea  --don't forget to use the variable!!
		FROM voluntario
		WHERE nro_voluntario = NEW.id_coordinador;
		IF (tarea <> NEW.id_tarea) THEN
			RAISE EXCEPTION 'todos los voluntarios deben realizar la misma tarea que su coordinador:%',tarea;
		ELSE		
			SELECT count(*) int counter
			FROM voluntario
			WHERE id_coordinador = NEW.id_coodinador AND id_tarea <> NEW.id_tarea
			if(counter > 0) THEN
				RAISE EXCEPTION 'todos los voluntarios deben realizar la misma tarea que su coordinador:%',tarea;
			END IF;
		END IF;
		RETURN NEW;
	END 
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER TR_vol_must_have_same_task_coord
	BEFORE INSERT OR UPDATE OF id_tarea OR UPDATE id_coordinador
	ON voluntario
	FOR EACH ROW
	EXECUTE PROCEDURE FN_vol_must_have_same_task_coord();


--EJERCICIO 2

CREATE TABLE his_entrega (
	nro_registro serial,
	fecha date NOT NULL,
	operacion varchar(20) NOT NULL,
	cant_reg_afectados int NOT NULL,
	usuario varchar(20) NOT NULL
);

CREATE TABLE entrega (
	nro_entrega NUMERIC(10,0),
	fecha_entrega date,
	id_video numeric(5,0),
	id_distribuidor NUMERIC(5,0),
	CONSTRAINT PK_renglon PRIMARY KEY (nro_entrega)
);


CREATE TABLE renglon_entrega (
	nro_entrega NUMERIC(10,0),
	codigo_pelicula NUMERIC (5,0),
	cantidad NUMERIC(5,0),
	CONSTRAINT PK_renglon_entrega PRIMARY KEY (nro_entrega,codigo_pelicula)
);

ALTER TABLE renglon_entrega
	ADD CONSTRAINT FK_renglon_entrega_entrega
	FOREIGN KEY (nro_entrega)
	REFERENCES entrega (nro_entrega)
	ON DELETE CASCADE
;

INSERT INTO entrega
	SELECT *
	FROM unc_esq_peliculas.entrega
;

INSERT INTO renglon_entrega
	SELECT *
	FROM unc_esq_peliculas.renglon_entrega
;

SELECT * FROM his_entrega

SELECT count(*)
FROM entrega
WHERE id_video = 3582

DELETE
FROM entrega
WHERE id_video = 3582


--NO ES NECESARIO RETORNAR NADA VERDAD? TIPO UN RETURN VOID
CREATE OR REPLACE FUNCTION FN_his() RETURNS trigger AS
$$	
	DECLARE
		rows_changed integer;
	BEGIN
		GET DIAGNOSTICS rows_changed = ROW_COUNT;
		INSERT INTO his_entrega(fecha,operacion,cant_reg_afectados,usuario) VALUES
			(current_date,TG_OP,rows_changed,current_user)
		;
	RETURN NULL;
	END
$$
LANGUAGE 'plpgsql';


CREATE TRIGGER TR_his_entrega
	BEFORE INSERT OR UPDATE OR DELETE
	ON entrega
	FOR EACH STATEMENT
	EXECUTE PROCEDURE FN_his();

CREATE TRIGGER TR_his_renglon_entrega
	BEFORE INSERT OR UPDATE OR DELETE
	ON renglon_entrega
	FOR EACH STATEMENT
	EXECUTE PROCEDURE FN_his();


--EJERCICIO 5

--a)
CREATE OR REPLACE FUNCTION FN_0_horas_aportadas() RETURNS trigger AS
$$
	BEGIN
		UPDATE voluntario SET
		horas_aportadas = 0
		WHERE nro_voluntario = OLD.nro_voluntario
		RETURN OLD;
	END 
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER TR_0_horas_aportadas
	BEFORE UPDATE OF id_tarea
	ON unc_esq_voluntario
	FOR EACH ROW
	EXECUTE PROCEDURE FN_0_horas_aportadas();

--b)
CREATE OR REPLACE FUNCTION FN_horas_aportadas_less_than_before() RETURNS trigger AS
$$
	DECLARE
		horas integer;
	BEGIN
		SELECT horas_aportadas INTO horas
		FROM voluntario
		WHERE nro_voluntario = NEW.nro_voluntario
		IF(NEW.horas_aportas NOT BETWEEN horas*0.9 AND horas*1.1) THEN
			RAISE EXCEPTION 'c mamo, no puede tener esas horas aportadas!';
		END IF;
		RETURN NEW;
	END 
$$
LANGUAGE 'plpgsql';

--a)
CREATE OR REPLACE FUNCTION FN_cambio_tarea() RETURNS trigger AS
$$
	--DECLARE
	BEGIN
		NEW.horas_aportadas:= 0;
		RETURN NEW;
	END 
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER TR_cambio_tarea
	AFTER UPDATE OF id_tarea
	ON voluntario_voluntario
	FOR EACH ROW 
	--WHEN (Condition) i.e NEW.nombre_pais = 'Argentina'
	EXECUTE PROCEDURE FN_cambio_tarea();

--b)
CREATE OR REPLACE FUNCTION FN_horas_aportadas_10percento() RETURNS trigger AS
$$
	--DECLARE
	BEGIN
		--new.column := value;
		IF(NEW.horas_aportadas  NOT BETWEEN OLD.horas_aportadas*0.9 AND OLD.horas_aportadas*1.1) THEN 
			RAISE NOTICE '%',OLD.horas_aportadas;
			RAISE EXCEPTION 'NO SE PUEDE TENER HORAS MENOS NI MAS DEL 10%% DE LO ANTERIOR';
		END IF;
		RETURN NEW;
	END 
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER TR_horas_aportadas_10percento
	BEFORE UPDATE OF horas_aportadas
	ON voluntario_voluntario
	FOR EACH ROW 
	--WHEN (Condition) i.e NEW.nombre_pais = 'Argentina'
	EXECUTE PROCEDURE FN_horas_aportadas_10percento();

CREATE TRIGGER TR_horas_aportadas_less_than_before
	BEFORE UPDATE OF horas_aportadas
	ON voluntario
	FOR EACH ROW
	--WHEN (Another_condition) --i.e NEW.nombre_pais = 'Argentina'
	EXECUTE PROCEDURE FN_horas_aportadas_less_than_before();


--EJERCICIO 6

CREATE TABLE Textosporautor (
	autor varchar(20),
	cant_texto int NOT NULL,
	fecha_ultima_public date NOT NULL,
	CONSTRAINT PK_Textosporautor PRIMARY KEY (autor)
);

CREATE OR REPLACE FUNCTION FN_registro_autores() RETURNS trigger AS
$$
	--DECLARE
	BEGIN
		RETURN NEW_OLD_NULL;
	END 
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER TR_registro_autores
	BEFORE INSERT_OR_DELETE_OR_UPDATE OF Atributte
	ON Table
	FOR EACH ROW_OR_STATEMENT
	--WHEN (Condition) i.e NEW.nombre_pais = 'Argentina'
	EXECUTE PROCEDURE FN_registro_autores();


CREATE OR REPLACE PROCEDURE actualizarTablas()
LANGUAGE 'plpgsql' AS
$$
	BEGIN
		INSERT INTO textoporautor
			SELECT autor, count(*), max(fecha_pub)
			FROM id_articulo
			GROUP BY autor
			HAVING autor IS NOT NULL AND fecha_pub IS NOT NULL 
		;
		--don't use new or old
		-- to use it you must do call actualizarTablas
	END;
$$;

--END PRACTICO 3 PARTE 2 #############################################################################################
--####################################################################################################################







--####################################################################################################################
--BEGIN PRACTICO 4 ###################################################################################################

--EJERCICIO 2

--1)
SELECT id_institucion
FROM voluntario
WHERE id_institucion IS NOT null
GROUP BY id_institucion
HAVING count(*) = 1
EXCEPT
SELECT id_institucion
FROM historico

SELECT nro_voluntario
FROM voluntario
WHERE id_institucion IN (
	SELECT id_institucion
	FROM voluntario
	WHERE id_institucion IS NOT null
	GROUP BY id_institucion
	HAVING count(*) = 1
)
EXCEPT
SELECT nro_voluntario
FROM historico

--2)
SELECT c.nombre || ', ' || c.apellido AS "nombre"
FROM voluntario v JOIN voluntario c ON (v.id_coordinador = c.nro_voluntario)
WHERE v.horas_aportadas >= 5000
UNION
SELECT nombre_institucion
FROM voluntario v JOIN institucion i ON (v.id_institucion = i.id_institucion)
WHERE v.horas_aportadas >= 5000
ORDER BY 1

--3)
(SELECT nro_voluntario, nombre, apellido
FROM voluntario v 
	JOIN institucion i ON (v.id_institucion = i.id_institucion)
	JOIN direccion d ON (i.id_direccion = d.id_direccion)
	JOIN pais p ON (d.id_pais = p.id_pais)
	JOIN continente c ON (p.id_continente = c.id_continente)
WHERE nombre_continente = 'Europeo'
UNION
SELECT nro_voluntario, nombre, apellido
FROM voluntario v
WHERE id_coordinador IS NULL)
INTERSECT
SELECT nro_voluntario, nombre, apellido
FROM voluntario v JOIN institucion i ON (v.nro_voluntario = i.id_director)

--4)         N
SELECT nro_voluntario
FROM voluntario
EXCEPT
SELECT nro_voluntario
FROM voluntario v
	JOIN institucion i ON (v.id_institucion = i.id_institucion)
	JOIN direccion d ON (i.id_direccion = d.id_direccion)
	JOIN pais p ON (d.id_pais = p.id_pais)
	JOIN continente c ON (p.id_continente = c.id_continente)
WHERE nombre_continente = 'Europeo'

--5)
SELECT *
FROM voluntario v
WHERE NOT EXISTS (
	SELECT 1
	FROM institucion i
	WHERE NOT EXISTS (
		SELECT 1
		FROM historico h
		WHERE h.nro_voluntario = v.nro_voluntario AND h.id_institucion = i.id_institucion
	)
)

--6)
--en el prÃ¡ctico

--EJERCICIO 4

--a)
EXPLAIN SELECT p.titulo, e.nro_entrega
FROM pelicula p, renglon_entrega re, entrega e
WHERE p.codigo_pelicula = re.codigo_pelicula AND re.nro_entrega = e.nro_entrega AND genero = 'TERROR'


EXPLAIN SELECT p.titulo, e.nro_entrega
FROM pelicula p, renglon_entrega re, entrega e
WHERE 
	p.codigo_pelicula = re.codigo_pelicula AND
	re.nro_entrega = e.nro_entrega AND
	genero = 'TERROR';


--b)
EXPLAIN SELECT v.nombre, v.apellido, v.e_mail, v.telefono
FROM voluntario v
WHERE v.nro_voluntario IN (
	SELECT h.nro_voluntario
	FROM historico h
	WHERE h.fecha_fin < to_date('1998-07-24','yyyy-mm-dd') AND h.id_tarea IN (
		SELECT t.id_tarea
		FROM tarea t
		WHERE t.max_horas - t.min_horas <= 5000
	)
)

--EJERCICIO 6

CREATE TABLE empleado (
	id_empleado int,
	nombre varchar(50) NOT NULL,
	apellido varchar(50) NOT NULL,
	cargo varchar(80) NOT NULL,
	CONSTRAINT PK_empleado PRIMARY KEY (id_empleado)
);
 
CREATE TABLE proyecto (
	cod_proyecto int,
	nombre varchar(80) NOT NULL,
	fecha_desde date NOT NULL,
	fecha_hasta date NOT NULL,
	CONSTRAINT PK_proyecto PRIMARY KEY (cod_proyecto)
);

CREATE TABLE trabaja_en (
	id_empleado int,
	cod_proyecto int,
	cant_horas int NOT NULL,
	CONSTRAINT PK_trabaja_en PRIMARY KEY (id_empleado,cod_proyecto)
);

ALTER TABLE trabaja_en
	ADD CONSTRAINT FK_trabaja_en_empleado
	FOREIGN KEY (id_empleado)
	REFERENCES empleado (id_empleado)
;

ALTER TABLE trabaja_en
	ADD CONSTRAINT FK_trabaja_en_proyecto
	FOREIGN KEY (cod_proyecto)
	REFERENCES proyecto (cod_proyecto)
;

INSERT INTO empleado(id_empleado,nombre,apellido,cargo) VALUES
	(1,'Juan','Perez','investigador'),
	(2,'Rosa','Gomes','investigador'),
	(3,'Bruno','Fernandez','becario'),
	(4,'Ignacio','Rodriguez','becario'),
	(5,'Alejandro','Perez','investigador'),
	(6,'Sebastian','Solano','investigador')
;

INSERT INTO proyecto(cod_proyecto,nombre,fecha_desde,fecha_hasta) VALUES
	(1,'ROBOTICS','2018-01-01','2020-01-01'),
	(2,'AI','2017-01-01','2020-01-01'),
	(3,'IMAGE','2015-01-01','2017-01-01')
;

INSERT INTO trabaja_en(id_empleado,cod_proyecto,cant_horas) VALUES
	(1,1,40),
	(2,1,40),
	(3,1,20),
	(4,1,20),
	(5,1,40),
	(6,1,40),
	(1,2,40),
	(3,2,20),
	(6,2,20),
	(3,3,10),
	(6,3,10)
;

EXPLAIN ANALYZE SELECT DISTINCT e.*
FROM empleado e, trabaja_en t, proyecto p
WHERE e.id_empleado = t.id_empleado AND p.cod_proyecto = t.cod_proyecto AND e.cargo = 'investigador'

--END PRACTICO 4 #####################################################################################################
--####################################################################################################################



--####################################################################################################################
--BEGIN PRACTICO 5 ###################################################################################################

--EJERCICIO 1
--a)

SELECT *
FROM envio

CREATE VIEW ENVIOS500 AS
SELECT *
FROM envio
WHERE cantidad >= 500
WITH CASCADED CHECK OPTION

SELECT *
FROM envios500

--b) actualizable se utiliza el id de la tabla
-- es una sola tabla y no se utiliza distinct ni nada rarito
-- ni tampoco subconsultas en el select

CREATE VIEW ENVIOS500999 AS
SELECT *
FROM ENVIOS500
WHERE cantidad < 1000;

INSERT INTO envios500999 VALUES
	(1,2,400)
;

DROP VIEW envios500 CASCADE;
DROP VIEW envios500999 CASCADE;

--b) actualizable idem a la anterior

SELECT *
FROM envios500

CREATE VIEW PRODUCTOS_MAS_PEDIDOS AS
SELECT id_articulo
FROM articulo
WHERE id_articulo IN (
	SELECT id_articulo
	FROM envios500
)
--b) idem a la anterior

CREATE VIEW ENVIOS_PROV AS 
SELECT id_proveedor, sum(cantidad)
FROM envio
GROUP BY id_proveedor
--b) no es actualizable xq se utiliza una funciÃ³n de agregaciÃ³n
-- ademÃ¡s tampoco se utiliza la clave completa

--c)
--estas no importa si tienen un check o no, ya que son inserts
INSERT INTO envios500 VALUES ('P1','A1',500);
INSERT INTO ENVIOS500 VALUES ('P2', 'A2', 300);

--funciona de 10 si se realiza un check o no
UPDATE ENVIOS500 SET cantidad=1000 WHERE id_proveedor= 'P1';

--si no se hace un check funciona y si se hace un check no xq no cumple la condiciÃ³n
UPDATE ENVIOS500 SET cantidad=100 WHERE id_proveedor= 'P1';

--EJERCICIO 2
-- respondido en la carpeta

--EJERCICIO 3

--1
CREATE VIEW empleado_dist_20 AS
SELECT id_empleado, nombre, apellido, sueldo, fecha_nacimiento
FROM unc_esq_peliculas.empleado
WHERE id_distribuidor = 20

--2
CREATE VIEW empleado_dist_2000 AS
SELECT nombre, apellido, sueldo
FROM empleado_dist_20
WHERE sueldo > 2000

--3
CREATE VIEW empleado_20_70 AS
SELECT *
FROM empleado_dist_20
WHERE EXTRACT (YEAR FROM fecha_nacimiento) BETWEEN 1970 AND 1979

--4
CREATE VIEW peliculas_entregadas AS
SELECT codigo_pelicula, sum(cantidad)
FROM renglon_entrega
GROUP BY codigo_pelicula

--5
CREATE VIEW distribuidoras_argentina AS 
SELECT d.id_distribuidor, nombre, direccion, telefono, tipo, nro_inscripcion, encargado
FROM unc_esq_peliculas.distribuidor d JOIN unc_esq_peliculas.nacional n ON (d.id_distribuidor = n.id_distribuidor) 

--6
SELECT id_distribuidor
FROM distribuidoras_argentina d
WHERE NOT EXISTS (
	SELECT 1
	FROM empleado
	WHERE id_distribuidor = d.id_distribuidor
	GROUP BY id_departamento
	HAVING count(*) <= 2
) AND EXISTS (
	SELECT 1
	FROM empleado
	WHERE id_distribuidor = d.id_distribuidor
)

SELECT id_distribuidor, id_departamento, count(*)
FROM empleado
WHERE id_distribuidor IN (
	SELECT id_distribuidor
	FROM nacional
)
GROUP BY id_distribuidor, id_departamento
ORDER BY 1

--EJERCICIO 4

EMPLEADO_DIST_20:
con CHECK LOCAL o CASCADE a la hora de realizarse una actualizacion, esta NO se realiza si como resultado se migran tuplas de la vista, es decir
NO se cumple la condicion para que esten entre los resultados
en el caso de CASCADE NO importa xq NO esta utilizando otras vistas xD

EMPLEADO_DIST_2000:
con CHECK LOCAL es igual al caso anterior
con CHECK CASCADE se chequea tambien sobre la vista anterior
con CHECK LOCAL se verifica la condicion y si la vista anterior tiene algun CHECK tambien se verifica.

EMPLEADO_DIST_20_70:
igual al analisis anterior

-- EJERCICIO 5

--1.a) Ensamble mediante RIR, FK â‰¡ K (coincide con la clave)
--1.b) la clave preservada es la de distribuidor y los campos que pueden actualizarse son los de esa tabla.
--1.c)
CREATE VIEW nacional_kp_1 AS
SELECT N.Id_distribuidor, nro_inscripcion, id_distrib_mayorista, encargado, nombre, direccion, telefono, tipo
FROM peliculas_distribuidor D JOIN peliculas_nacional N ON (d.id_distribuidor = n.id_distribuidor);


CREATE OR REPLACE FUNCTION FN_nacional_kp_1() RETURNS trigger AS
$$
	--DECLARE
	BEGIN
		if(TG_OP = 'DELETE') THEN
			DELETE FROM pelicula_nacional WHERE id_distribuidor = OLD.id_distribuidor;
			DELETE FROM pelicula_distribuidor WHERE id_distribuidor = OLD.id_distribuidor;
			RETURN OLD ;-- NULL Y OLD TIENEN UNA DIFERENCIA PEQUE�A, GOOGLEAR
		END IF;
	
		IF(TG_OP = 'UPDATE') THEN
			UPDATE pelicula_distribuidor SET
				id_distribuidor = NEW.id_distribuidor,
				nombre = NEW.nombre,
				direccion = NEW.direccion,
				telefono = NEW.telefono,
				tipo = NEW.tipo
				WHERE id_distribuidor = NEW.id_distribuidor;
		ELSE --es un insert
			INSERT INTO pelicula_distribuidor VALUES (NEW.id_distribuidor,NEW.nombre,NEW.direccion,NEW.telefono,NEW.tipo);
		END IF;
	
		--si es un insert o un update de la vista se tiene que hacer la siguiente verificaciÃ³n
		IF(EXISTS(SELECT 1 FROM pelicula_nacional WHERE id_distribuidor = NEW.id_distribuidor)) THEN
			UPDATE pelicula_nacional SET 
				nro_inscripcion = NEW.nro_inscripcion,
				encargado = NEW.encargado,
				id_distrib_mayorista = NEW.id_distrib_mayorista
				WHERE id_distribuidor = NEW.id_distribuidor;
		ELSE
			INSERT INTO pelicula_nacional VALUES (NEW.id_distribuidor,NEW.nro_inscripcion,NEW.encargado,NEW.id_distrib_mayorista);
		END IF;
		RETURN NULL;
	END
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER TR_nacional_kp_1
	INSTEAD OF INSERT OR DELETE OR UPDATE
	ON nacional_kp_1
	FOR EACH ROW
	--WHEN (Condition) i.e NEW.nombre_pais = 'Argentina'
	EXECUTE PROCEDURE FN_nacional_kp_1();

DROP TRIGGER tr_nacional_kp_1 ON nacional_kp_1

UPDATE nacional_kp_1 SET nombre = 'Cio' WHERE id_distribuidor = 651;

SELECT N.Id_distribuidor, nro_inscripcion, id_distrib_mayorista, encargado, nombre, direccion, telefono, tipo
FROM pelicula_distribuidor D JOIN peliculas_nacional N ON (d.id_distribuidor = n.id_distribuidor;

INSERT INTO nacional_kp_1 VALUES
	(6666,666,NULL,'Cio','Cio','avenida 666',666,'N')
;

DELETE FROM nacional_kp_1 WHERE id_distribuidor = 6666;

SELECT * FROM nacional_kp_1
where id_distribuidor = 651

SELECT *
FROM nacional_kp_1 WHERE id_distribuidor = 6666

UPDATE nacional_kp_1 SET encargado ='OmegaCio' WHERE id_distribuidor = 6666;
UPDATE nacional_kp_1 SET telefono = '6cio' WHERE id_distribuidor = 6666;


--2.a) Caso (1): mÃ¡s intuitivoâ†’ Ensamble mediante RIR, FK= atrib. secundarios
--2.b) id_ciudad que proviene de la tabla ciudad, solo se pueden actualizar los campos de esta tabla (no se puede el nombre del pais)
--2.c)
CREATE VIEW CIUDAD_KP_2 AS 
SELECT id_ciudad, nombre_ciudad, C.id_pais, nombre_pais
FROM pelicula_ciudad C JOIN pelicula_pais P ON (c.id_pais = p.id_pais);

CREATE OR REPLACE FUNCTION FN_ciudad_kp_2() RETURNS trigger AS
$$
	--DECLARE
	BEGIN
		if(TG_OP = 'DELETE') THEN
			DELETE FROM pelicula_ciudad WHERE id_ciudad = OLD.id_ciudad;
			RETURN NULL;
		END IF;
		IF(TG_OP = 'UPDATE') THEN
			UPDATE pelicula_pais SET nombre_pais = NEW.nombre_pais WHERE id_pais = NEW.id_pais;
			IF(NEW.id_ciudad <> OLD.id_ciudad) THEN --actualizo xq ademÃ¡s del id_ciudad puede estar cambiando todo
				UPDATE pelicula_ciudad SET 
					id_ciudad = NEW.id_ciudad,
					nombre_ciudad = NEW.nombre_ciudad,
					id_pais = NEW.id_pais;
			ELSE  --no actualizo el id xq sino me tira error de que el id existe!
				UPDATE pelicula_ciudad SET
					nombre_ciudad = NEW.nombre_ciudad,
					id_pais = NEW.id_pais;
			END IF;
			RETURN NULL;
		ELSE --es un insert
			IF(NOT EXISTS(SELECT 1 FROM pelicula_pais WHERE id_pais = NEW.id_pais)) THEN
				INSERT INTO pelicula_pais VALUES (NEW.id_pais, NEW.nombre_pais);
			ELSE --estoy insertando una nueva tupla con un pais que ya existe pero capaz que le quiere cambiar el nombre jaja
				UPDATE pelicula_pais SET nombre_pais = NEW.nombre_pais WHERE id_pais = NEW.id_pais;
			END IF;
			--ahora que nos aseguramos de que el paÃ­s existe podemos agregar la ciudad
			INSERT INTO pelicula_ciudad VALUES (NEW.id_ciudad, NEW.nombre_ciudad, NEW.id_pais);
		END IF;
		RETURN NULL;
	END
$$
LANGUAGE 'plpgsql';

DROP TRIGGER tr_ciudad_kp_2 ON ciudad_kp_2

CREATE TRIGGER TR_ciudad_kp_2
	INSTEAD OF INSERT OR DELETE OR UPDATE
	ON ciudad_kp_2
	FOR EACH ROW
	EXECUTE PROCEDURE FN_ciudad_kp_2();

SELECT * FROM ciudad_kp_2 LIMIT 1

UPDATE ciudad_kp_2 SET nombre_ciudad = 'cioCiudad' WHERE id_ciudad = 683;

--3.a) Ensamble mediante RIR, FK âŠ‚  K (subconjunto de los atrib. clave)
--3.b) la clave es nro_entrega y re.codigo_pelicula y proviene de la tabla renglon_entrega, solo se pueden actualizar los datos de esta tabla.
-- el estandar de SQL dice que se pueden hacer actualizaciones sobre trabaja pero xq nose podrÃ­a actualizar los datos de las
-- otras tablas si se tienen los id's?
CREATE VIEW ENTREGAS_KP_3 AS
SELECT nro_entrega, RE.codigo_pelicula, cantidad, titulo
FROM pelicula_renglon_entrega RE JOIN pelicula_pelicula P ON (re.codigo_pelicula = p.codigo_pelicula);

CREATE OR REPLACE FUNCTION FN_entregas_kp_3() RETURNS trigger AS
$$
	--DECLARE
	BEGIN
		if(TG_OP = 'DELETE') THEN
			DELETE FROM pelicula_renglon_entrega WHERE nro_entrega = OLD.nro_entrega AND codigo_pelicula = OLD.codigo_pelicula;
			RETURN NULL;
		END IF;
		IF(TG_OP = 'UPDATE') THEN
			IF(NEW.nro_entrega <> OLD.nro_entrega) THEN
				UPDATE pelicula_renglon_entrega SET nro_entrega = NEW.nro_entrega WHERE nro_entrega = OLD.nro_entrega AND codigo_pelicula = OLD.codigo_pelicula;
				--no se si puedo usar el new.codigo_pelicula xq se puede haber actualizado!
				--tampoco el new.nro_entrega xq es el que estoy actualizando
			END IF;
			IF(NEW.codigo_pelicula <> OLD.codigo_pelicula) THEN
				UPDATE pelicula_renglon_entrega SET codigo_pelicula = NEW.codigo_pelicula WHERE nro_entrega = NEW.nro_entrega AND codigo_pelicula = OLD.codigo_pelicula;		
				--aca si puedo usar el new.nro_entrega verdad?
			END IF;
			--finalmente actualizo el resto de los campos
			UPDATE pelicula_renglon_entrega SET cantidad = NEW.cantidad WHERE nro_entrega = NEW.nro_entrega AND codigo_pelicula = NEW.codigo_pelicula;
			UPDATE pelicula_pelicula SET titulo = NEW.titulo WHERE codigo_pelicula = NEW.codigo_pelicula;
			RETURN NULL;
		ELSE --es un insert
			INSERT INTO pelicula_renglon_entrega VALUES (NEW.nro_entrega,NEW.codigo_pelicula,NEW.cantidad);
			--por si se pone un titulo diferente al que tiene la pelicula???
			UPDATE pelicula_pelicula SET titulo = NEW.titulo WHERE codigo_pelicula = NEW.codigo_pelicula;
		END IF;
		RETURN NULL;
	END
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER TR_entregas_kp_3
	INSTEAD OF INSERT OR DELETE OR UPDATE
	ON ciudad_kp_2
	FOR EACH ROW
	EXECUTE PROCEDURE FN_ciudad_kp_2();

--EJERCICIO 6
--1 no se inserta xq no cumple el primer check de que el id no tiene REP.
--2 no se inserta xq no cumple el check de las horas max xq son 5.5k
--3 se inserta xq cumple el check del rep y también el de las horas
--4 se inserta xq cumple el check de las horas.

--EJERCICIO 7
--1 no se inserta xq no cumple el check de las horas_aportadas
--2 se inserta xq cumple el check de la edad y tambi�n el check de las horas_aportadas
--3 no se inserta xq cumple el check de la edad pero no cumple el check de las horas.
--4 no se inserta xq no se cumple las horas_aportadas
--5 


--END PRACTICO 5 #####################################################################################################
--####################################################################################################################
		



-- PARCIAL 2014
CREATE TABLE PROBLEMA (
	id_problema int NOT NULL,
	id_sub_prod int NOT NULL,
	id_producto int NOT NULL,
	id_equ_reporta int NOT NULL,
	id_des_reporta int NOT NULL,
	id_equ_a_cargo int,
	id_des_a_cargo int,
	CONSTRAINT PK_PROBLEMA PRIMARY KEY (id_problema)
);

ALTER TABLE PROBLEMA ALTER COLUMN id_equ_reporta SET DEFAULT 4;
ALTER TABLE PROBLEMA ALTER COLUMN id_des_reporta SET DEFAULT 4;

CREATE TABLE DESARROLLADOR (
	id_equipo int NOT NULL,	
	id_desar int NOT NULL,
	CONSTRAINT PK_DESARROLLADOR PRIMARY KEY (id_equipo, id_desar)
);

CREATE TABLE PRODUCTO (
	id_producto int NOT NULL,
	CONSTRAINT PK_PRODUCTO PRIMARY KEY (id_producto)
);

CREATE TABLE SUB_PROD (
	id_sub_prod int NOT NULL,
	id_producto int NOT NULL,
	CONSTRAINT PK_SUB_PROD PRIMARY KEY (id_sub_prod,id_producto)
);

--FOREIGN KEYS

ALTER TABLE PROBLEMA
	ADD CONSTRAINT FK_PROBLEMA_DESARROLLADOR_REPORTA
	FOREIGN KEY (id_equ_reporta,id_des_reporta)
	REFERENCES DESARROLLADOR (id_equipo,id_desar)
	ON DELETE SET DEFAULT
	ON UPDATE RESTRICT
;

ALTER TABLE PROBLEMA
	ADD CONSTRAINT FK_PROBLEMA_DESARROLLADOR_A_CARGO
	FOREIGN KEY (id_equ_a_cargo,id_des_a_cargo)
	REFERENCES DESARROLLADOR (id_equipo,id_desar)
	ON DELETE SET NULL
	ON UPDATE RESTRICT
;

ALTER TABLE PROBLEMA
	ADD CONSTRAINT FK_PROBLEMA_SUB_PROD
	FOREIGN KEY (id_sub_prod,id_producto)
	REFERENCES SUB_PROD (id_sub_prod,id_producto)
	ON DELETE CASCADE
	ON UPDATE CASCADE
;

ALTER TABLE SUB_PROD
	ADD CONSTRAINT FK_SUB_PROD_PRODUCTO
	FOREIGN KEY (id_producto)
	REFERENCES PRODUCTO (id_producto)
	ON DELETE CASCADE
	ON UPDATE RESTRICT
;


--PARCIAL 2018
ALTER TABLE departamento ADD CONSTRAINT ck_no_mas_4
CHECK (
	NOT EXISTS (
		SELECT 1
		FROM departamento
		GROUP BY tipo_doc, nro_doc
		HAVING count(*) > 4
	)
);

CREATE ASSERTION control_depto
CHECK NOT EXISTS(
	SELECT 1
	FROM departamento d JOIN tipo_dpto t ON (d.id_tipo_depto = t.id_tipo_depto)
	WHERE t.cant_habitaciones = 1 AND (d.tipo_doc,d.nro_doc) IN (
																SELECT tipo_doc, nro_doc
																FROM departamento
																GROUP BY tipo_doc, nro_doc
																HAVING count(*) > 4
		)
);


SELECT tipo_doc,nro_doc
FROM departamento d JOIN tipo_dpto t ON (d.id_tipo_depto = t.id_tipo_depto)
WHERE t.cant_habitaciones = 1 AND (d.tipo_doc,d.nro_doc) IN (
SELECT tipo_doc, nro_doc
FROM departamento
GROUP BY tipo_doc, nro_doc
HAVING count(*) > 2);


SELECT tipo_doc,nro_doc
FROM departamento
GROUP BY tipo_doc, nro_doc
HAVING count(*) > 4

INTERSECT

SELECT tipo_doc,nro_doc
FROM departamento d JOIN habitacion h ON (d.id_dpto = h.id_dpto)
GROUP BY d.id_dpto
HAVING count(*) = 1


CREATE OR REPLACE FUNCTION FN_update_habitacion() RETURNS trigger AS
$$
	DECLARE
		prop record;
	BEGIN
		--OBTENGO EL ID DEL PROPIETARIO NUEVO DEL DEPTO
		SELECT tipo_doc,nro_doc INTO id_prop_viejo
		FROM departamento
		WHERE id_depto = NEW.id_depto
		
		IF(id_prop_viejo IS NOT NULL)THEN 
			--SI EL DEPARTAMENTO NUEVO NO TENIA HABITACIONES (AHORA PASARIA A TENER UNA)
			IF(	((SELECT count(*) FROM habitacion WHERE id_depto = NEW.id_depto) = 0) 
				AND --Y ADEMAS EL PROPIETARIO DEL NUEVO DEPARTAMENTO TIENE MAS DE 4 DEPTOS
				((SELECT count(*) FROM departamento WHERE tipo_doc = prop.tipo_doc AND nro_doc = prop.nro_doc) > 4) 
			THEN
				RAISE EXCEPTION 'nain nain nain';
			END IF;
		END IF;
		
		--OBTENGO EL ID DEL PROPIETARIO VIEJO DEL DEPTO
		SELECT tipo_doc,nro_doc INTO id_prop_viejo
		FROM departamento
		WHERE id_depto = OLD.id_depto
		
		IF(id_prop_viejo IS NOT NULL)THEN 
			--SI EL DEPARTAMENTO VIEJO TENIA SOLO 2 HABITACIONES (AHORA PASARIA A TENER UNA)
			IF(((SELECT count(*) FROM habitacion WHERE id_depto = OLD.id_depto) = 2) 
				AND --Y ADEMAS EL PROPIETARIO DEL VIEJO DEPARTAMENTO TIENE MAS DE 4 DEPTOS
				((SELECT count(*) FROM departamento WHERE tipo_doc = prop.tipo_doc AND nro_doc = prop.nro_doc) > 4) 
			THEN
				RAISE EXCEPTION 'nain nain nain';
			END IF;
		END IF;
		RETURN NEW;
	END 
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER TR_update_habitacion
	BEFORE UPDATE OF id_depto
	ON habitacion
	FOR EACH ROW
	EXECUTE PROCEDURE FN_update_habitacion();
	
CREATE OR REPLACE FUNCTION FN_update_departamento() RETURNS trigger AS
$$
	--DECLARE
	BEGIN --SI EL NUEVO PROPIETARIO TENIA 4 O M�S DEPTOS
		IF(((SELECT count(*) FROM departamento WHERE nro_doc = NEW.nro_doc AND tipo_doc = NEW.tipo_doc) >= 4))
			AND --Y DENTRO DE UNO DE ESOS DEPTOS TENIA UNO CON UNA SOLA HABITACION    O JUSTO EL DEPTO TIENE UNA SOLA
			((EXISTS(
				SELECT 1 
				FROM departamento d JOIN habitacion h ON (d.id_depto = h.id_depto)
				WHERE nro_doc = NEW.nro_doc AND tipo_doc = NEW.tipo_doc
				GROUP BY id_depto
				HAVING count(*) = 1
				)
			)
			OR --EFECTIVAMENTE EL DEPTO PUEDE TENER UNA SOLA HABITACION
			((SELECT count(*) FROM habitacion WHERE id_depto = OLD.id_depto) = 1)
			)) THEN
			RAISE EXCEPTION 'nain nain nain'; 
		END IF;
		RETURN NEW;
	END 
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER TR_update_departamento
	BEFORE UPDATE OF nro_doc,tipo_doc
	ON departamento
	FOR EACH ROW
	EXECUTE PROCEDURE FN_update_departamento();

--EJEERCICIO 7
--you can return integer or boolean too
CREATE OR REPLACE FUNCTION FN_servicio(inicio date,fin date) RETURNS  TABLE(nro_doc numeric(11,0), tipo_doc bpchar(3), dias int)  AS
$$
	BEGIN
		RETURN query
		SELECT r.nro_doc,r.tipo_doc,fecha_hasta - fecha_desde AS "dias de alquier"
		FROM unc_esq_dptos.reserva r 
			JOIN unc_esq_dptos.reserva_hab rh ON (r.id_reserva = rh.id_reserva)
			JOIN unc_esq_dptos.habitacion h ON (rh.id_habitacion = h.id_habitacion) AND (rh.id_dpto = h.id_dpto)
		WHERE (cocina = TRUE) AND (fecha_reserva BETWEEN inicio AND fin)
		ORDER BY fecha_reserva;
	END
$$
LANGUAGE 'plpgsql';

SELECT * FROM FN_servicio(to_date('2017-11-23','yyyy-mm-dd'),to_date('2017-12-04','yyyy-mm-dd'));
	
--EJERCICIO 8
CREATE VIEW EstadoResrva AS
SELECT r.id_reserva, cancelada
FROM unc_esq_dptos.reserva r JOIN unc_esq_dptos.pago p ON (r.id_reserva = p.id_reserva)
WHERE importe>1050




CREATE VIEW EstadoReserva AS
SELECT id_reserva, cancelada
FROM unc_esq_dptos.reserva r
WHERE r.id_reserva IN (
	SELECT id_reserva
	FROM unc_esq_dptos.pago
	WHERE importe >1050
	
--###############################################################################################################################
--PARCIAL 2016 ##################################################################################################################

--EJERCICIO 4
ALTER TABLE productoxorden ADD CONSTRAINT ck_no_mas_10
CHECK (
	NOT EXISTS (
		SELECT 1
		FROM productoxorden
		GROUP BY id_producto
		HAVING sum(cantidad) > 10
	)
);


--EJERCICIO 6
CREATE VIEW nro_libreta_ProductosNoOrdenados AS
SELECT *
FROM producto
WHERE precio_unitario < 1000 AND id_producto NOT IN (
	SELECT id_producto
	FROM productoxorden
	WHERE id_producto IS NOT NULL
)

--EJERCICIO 8
CREATE VIEW ClientesConOrdenes AS

SELECT c.*, count(*)
FROM unc_esq_producto.cliente c LEFT JOIN unc_esq_producto.orden o ON (c.id_cliente = o.id_cliente)
GROUP BY c.id_cliente
ORDER BY 2

SELECT id
FROM prueba
WHERE 1 IN (
				SELECT value
				FROM prueba
				WHERE value IS NOT null
)


SELECT*
FROM prueba

CREATE OR REPLACE PROCEDURE  PR_STOCK_MENSUAL()
LANGUAGE 'plpgsql' AS
$BODY$
	DECLARE 
		indice record;
	BEGIN
		FOR indice IN 
			SELECT id_producto, sum(cantidad) AS "vendido"
			FROM productoxorden p JOIN orden o ON (p.nro_orden = o.nro_orden)
			WHERE fecha >= current_date - INTERVAL '1 month'
			GROUP BY id_producto
		LOOP
			UPDATE stock 
			SET cantidad = cantidad - indice.vendido,
				fecha = current_date
			WHERE id_producto = indice.id_producto; 
		END LOOP;
	--don't use new or old
	-- to use it you must do call name
	END;
$BODY$;


CALL PRO_STOCK_MENSUAL();


CREATE TABLE producto (
	id_producto int,
	nombre varchar(40),
	CONSTRAINT PK_producto PRIMARY KEY (id_producto)
);

CREATE TABLE stock (
	fecha date,
	id_producto int,
	cantidad int NOT NULL,
	CONSTRAINT PK_stock PRIMARY KEY (fecha,id_producto)
);

CREATE TABLE productoxorden (
	id_producto int,
	nro_orden int,
	cantidad int NOT null,
	CONSTRAINT PK_productoxorder PRIMARY KEY (id_producto,nro_orden)
);

CREATE TABLE orden (
	nro_orden int,
	fecha date NOT null,
	CONSTRAINT PK_orden PRIMARY KEY (nro_orden)
);

ALTER TABLE productoxorden
	ADD CONSTRAINT FK_productoxorder_producto
	FOREIGN KEY (id_producto)
	REFERENCES producto (id_producto)
	--ON DELETE [CASCADE | SET DEFAULT | RESTRICT | SET NULL]
	--ON UPDATE [CASCADE | SET DEFAULT | RESTRICT | SET NULL]
;

ALTER TABLE productoxorden
	ADD CONSTRAINT FK_productoxorder_orden
	FOREIGN KEY (nro_orden)
	REFERENCES orden (nro_orden)
	--ON DELETE [CASCADE | SET DEFAULT | RESTRICT | SET NULL]
	--ON UPDATE [CASCADE | SET DEFAULT | RESTRICT | SET NULL]
;


ALTER TABLE stock
	ADD CONSTRAINT FK_stock_producto
	FOREIGN KEY (id_producto)
	REFERENCES producto (id_producto)
	--ON DELETE [CASCADE | SET DEFAULT | RESTRICT | SET NULL]
	--ON UPDATE [CASCADE | SET DEFAULT | RESTRICT | SET NULL]
;

INSERT INTO producto VALUES
	(1,'masitas'),
	(2,'papas'),
	(3,'pan'),
	(4,'lettuce'),
	(5,'tomato'),
	(6,'egg'),
	(7,'rain'),
	(8,'starfall'),
	(9,'crossover'),
	(10,'lemon')
;

INSERT INTO stock VALUES
	(current_date - INTERVAL '1 month',1,50),
	(current_date - INTERVAL '1 month',2,50),
	(current_date - INTERVAL '1 month',3,50),
	(current_date - INTERVAL '1 month',4,50),
	(current_date - INTERVAL '1 month',5,50),
	(current_date - INTERVAL '1 month',6,50),
	(current_date - INTERVAL '1 month',7,50),
	(current_date - INTERVAL '1 month',8,50),
	(current_date - INTERVAL '1 month',9,50),
	(current_date - INTERVAL '1 month',10,50)
;



INSERT INTO orden VALUES
	(1,current_date - INTERVAL '20 days'),
	(2,current_date - INTERVAL '15 days'),
	(3,current_date - INTERVAL '5 days')
;

INSERT INTO productoxorden VALUES
	(1,1,30),
	(2,1,10),
	(3,2,1),
	(4,2,50),
	(5,3,24),
	(6,3,15)
;

SELECT * FROM productoxorden;
SELECT * FROM producto;

SELECT * FROM stock
ORDER BY id_producto;
SELECT *FROM orden;

CALL PR_STOCK_MENSUAL();



--END PARCIAL 2016 ##############################################################################################################
--###############################################################################################################################



--###############################################################################################################################
--PARCIAL 2017 ##################################################################################################################

--EJERCICIO 4
ALTER TABLE equipo ADD CONSTRAINT ck_no_mas_500
CHECK (
	NOT EXISTS (
		SELECT 1
		FROM equipo
		GROUP BY id_servicio
		HAVING count(*) > 500
	)
);


CREATE OR REPLACE PROCEDURE  PR_STOCK_MENSUAL()
LANGUAGE 'plpgsql' AS
$BODY$
	DECLARE
		resultado record;
	BEGIN
		SELECT id_producto, cantidad INTO resultado
		FROM productoxorden p JOIN orden o ON (p.nro_orden = o.nro_orden)
		WHERE fecha > current_date - INTERVAL '1 month'		
	--don't use new or old
	-- to use it you must do call STOCK_MENSUAL
	END;
$BODY$;

SELECT id_producto, cantidad
FROM productoxorden p JOIN orden o ON (p.nro_orden = o.nro_orden)
WHERE fecha > current_date - INTERVAL '1 month'





/*
+==============================+=========================================+=========================================+=========================================+
|            Tablas            |                 Insert                  |                 Update                  |                 Delete                  |
+==============================+=========================================+=========================================+=========================================+
| equipo                       |                ooooo                    |               id_servicio               | xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx |
+------------------------------+-----------------------------------------+-----------------------------------------+-----------------------------------------+

*/

CREATE OR REPLACE FUNCTION FN_insert_update() RETURNS TRIGGER AS
$BODY$
	--DECLARE
	BEGIN
		IF((SELECT count(*) FROM equipo WHERE id_servicio = NEW.id_servicio) >= 500) THEN
			RAISE EXCEPTION 'nain nain nain';
		END IF;
		RETURN NEW;
	END 
$BODY$
LANGUAGE 'plpgsql';

CREATE TRIGGER TR_insert_update
	BEFORE INSERT OR UPDATE OF id_servicio
	ON equpo
	FOR EACH row
	EXECUTE PROCEDURE FN_insert_update();

--EJERCICIO 5 y 6 y 7

/*
+==============================+=========================================+=========================================+=========================================+
|            Tablas            |                 Insert                  |                 Update                  |                 Delete                  |
+==============================+=========================================+=========================================+=========================================+
|         turno                |        xxxxxxxxxxxxxxxxxxxx             |           id_personal                   |            xxxxxxxxxxxxxxxxxx           |
+------------------------------+-----------------------------------------+-----------------------------------------+-----------------------------------------+
|        comprobante           |        ooooooooooooooooooo              |           id_turno                      |            ooooooooooooooooo            |
+------------------------------+-----------------------------------------+-----------------------------------------+-----------------------------------------+
*/



CREATE ASSERTION no_mas_70
CHECK NOT EXISTS(
	SELECT 1
	FROM turno t JOIN comprobante c ON (c.id_turno = t.id_turno)
	GROUP BY id_personal
	HAVING count(*) > 0.7*(SELECT count(*) FROM comprobante)
	
);

--EJERCICIO 18
SELECT nombre, apellido
FROM comprobante c JOIN turno t ON (c.id_turno = t.id_turno) JOIN persona p ON (t.id_personal = p.id_persona)
WHERE id_tcomp <> 2 AND p.id_persona IN(
	SELECT t.id_personal
	FROM comprobante c JOIN turno t ON (c.id_turno = t.id_turno)
	WHERE fecha >= (to_date('4/11/2017','dd/mm/yyyy') - INTERVAL '7 years')
)
GROUP BY p.id_persona
ORDER BY sum(importe)
LIMIT 1
OFFSET 2
	
--END PARCIAL 2017 ##############################################################################################################
--###############################################################################################################################
	
SELECT 'aprobame '
FROM prueba WHERE value IS NULL


SELECT i.nombre_institucion, count(nro_voluntario)
FROM institucion i LEFT JOIN voluntario v ON (i.id_institucion = v.id_institucion)
GROUP BY i.id_institucion, nombre_institucion
ORDER BY 2


fundacion rural: 0
casa de la providencia: 1 la jenny




