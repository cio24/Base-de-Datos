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

PARA EL EJERCICIO A Y B, PODRÍA DEJARLO PLANTEADO COMO DOMINIOS O SIMPLEMENTE CON HACER UN ALTER TABLE CHECK YA ESTARÍA?
--a)
CREATE DOMAIN nacionalidad_valida AS varchar(40) NOT NULL
CHECK (value LIKE 'Argentina' OR value LIKE 'Español' OR value LIKE 'Inglés' OR value LIKE 'Chilena' OR value LIKE 'Alemán');

--b)
CREATE DOMAIN fecha_valida AS date NOT NULL
CHECK (EXTRACT (YEAR FROM value) >= 2010));

ESTA BIEN PLANTEADA LA CONDICIÓN?
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
		raise exception 'Superó la cantidad de palabras claves:%',cantidad;
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

--d) como se verifica que no se cambie una localidad de sucursal y proveedor?? habría que agregar esta misma constraint???
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

--quería ver si se puede hacer algo de este estilo, como el inciso de arriba por ejemplo, cuando hace el check, solo chequea
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



--esta es la versión que creo que anda, pero que hace un select, por lo cual podría ser menos eficiente que el de arriba
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
				RAISE EXCEPTION 'Te pasaste de palabras claves wacho, no pueden ser más de %', counter;
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
					RAISE EXCEPTION 'Te pasaste de palabras claves wacho, no pueden ser más de %', counter;
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
--en el práctico

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

CREATE VIEW ENVIOS500 AS 
SELECT *
FROM envio
WHERE cantidad >= 500
--b) actualizable se utiliza el id de la tabla
-- es una sola tabla y no se utiliza distinct ni nada rarito
-- ni tampoco subconsultas en el select
CREATE VIEW ENVIOS500-999_ AS
SELECT *
FROM envios500
WHERE cantdad < 1000
--b) actualizable idem a la anterior


CREATE VIEW PRODUCTOS_MAS_PEDIDOS AS
SELECT id_articulo
FROM articulo
WHERE id_articulo IN (
	SELECT id_articulo
	FROM envios500
)
--b) idem a la anterior

CREATE VIEW ENVIOS_PROV AS 
SELECT id_proveedor, count(*)
FROM envio
GROUP BY id_proveedor
--b) no es actualizable xq se utiliza una función de agregación
-- además tampoco se utiliza la clave completa

--c)
--estas no importa si tienen un check o no, ya que son inserts
INSERT INTO envios500 VALUES ('P1','A1',500);
INSERT INTO ENVIOS500 VALUES ('P2', 'A2', 300);

--funciona de 10 si se realiza un check o no
UPDATE ENVIOS500 SET cantidad=1000 WHERE id_proveedor= 'P1';

--si no se hace un check funciona y si se hace un check no xq no cumple la condición
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
SELECT id_empleado
FROM empleado_dist_20
WHERE EXTRACT (YEAR FROM fecha_nacimiento) BETWEEN 1970 AND 1979

--4
CREATE VIEW peliculas_entregadas AS
SELECT codigo_pelicula, cantidad
FROM renglon_entrega

--5
CREATE VIEW distribuidoras_argentina AS 
SELECT d.id_distribuidor, nombre, direccion, telefono, tipo, nro_inscripcion, encargado
FROM unc_esq_peliculas.distribuidor d JOIN unc_esq_peliculas.nacional n ON (d.id_distribuidor = n.id_distribuidor) 

--6
CREATE VIEW distribuidoras_mas_2_emp AS
SELECT *
FROM distribuidoras_argentina
WHERE id_distribuidor IN (
	SELECT id_distribuidor
	FROM unc_esq_peliculas.departamento
	WHERE id_departamento IN (
		SELECT id_departamento
		FROM unc_esq_peliculas.empleado
		GROUP BY id_departamento
		HAVING count(*) > 2
	)
)




--END PRACTICO 5 #####################################################################################################
--####################################################################################################################



