# CHALLENGE BI

En el presente repositorio se entrega la resolución del challenge planteado para la validar aptitudes técnicas relacionadas con el manejo de SQL.

Se uso **MySQL**, que es una base de datos relacional con licencia gratuita. En un momento quería usar PosgresSQL pero no tiene Stored Procedures, sino que en su lugar se usan funciones que actúan de la misma forma, pero no me pareció una buena elección.

#### Entregables:

- [DER](https://github.com/marianofarias/Challenge_BI/blob/main/DER.png)

- [create_tables](https://github.com/marianofarias/Challenge_BI/blob/main/create_tables.sql)

- [datos_ejemplo](https://github.com/marianofarias/Challenge_BI/blob/main/datos_ejemplo.sql)

- [respuestas_negocio](https://github.com/marianofarias/Challenge_BI/blob/main/respuestas_negocio.sql)

## DER

La primera parte del entregable es la creación de un DER que va a servir para poder responder a preguntas, sobre diferentes casos en el negocio, que fueron enunciadas.
Use la herramienta MySql Workbrench ya que es gratuita y me parece bastante completa.

## CREATE TABLES

El archivo que se entrega, contiene todas las instrucciones para que se creen las tablas que forman parte del modelo.

## DATOS DE EJEMPLO

Envío un lote de datos de ejemplo como para validar el próximo punto.

## PREGUNTAS A RESOLVER

1. Cantidad de usuarios donde su apellido comience con la letra ‘M’.
```
SELECT
	COUNT(*)
FROM
	challenge_bi.tbl_customer
WHERE
	last_name like 'M%';
```
2. Listado de los usuarios que cumplan años en el día de la fecha (hoy).
```
SELECT
	CONCAT(first_name,' ',last_name) as Usuario,
	birth_date as FechaNacimiento
FROM
	challenge_bi.tbl_customer
WHERE
	Month(birth_date)= Month(CURRENT_DATE()) and
	Day(birth_date)= Day(CURRENT_DATE());
```
3. Por día se necesita, cantidad de ventas realizadas, cantidad de productos vendidos
y monto total transaccionado para el mes de Enero del 2020.
```
SELECT
	COUNT(order_id) as CantidadVentas,
	COUNT(item_id) as ProductosVendidos,
	SUM(total_price) as MontoTotal,
	order_date as FechaVenta
FROM
	challenge_bi.tbl_order 
    LEFT JOIN challenge_bi.tbl_item on tbl_item.order_id_fk=tbl_order.order_id
Where
	Month(order_date)= 1 and
	Year(order_date)= 2020 and
	status_id_fk = 1 -- ESTADO DE ORDER "Confirmed".
 GROUP BY order_date;
 ```
4. Por cada mes del 2019, se solicita el top 5 de usuarios que más vendieron ($) en la
categoría Celulares. Se requiere el mes y año de análisis, nombre y apellido del
vendedor, la cantidad vendida y el monto total transaccionado.
```
SELECT 
	SUM(t_order.total_price) as Venta,
	COUNT(t_order.order_id) as CantidadVentas,
	Customer.first_name as NombreUsuario,
	Customer.last_name as ApellidoUsuario,
	Month(t_order.order_date) as Mes,
	Year(t_order.order_date) as Año
FROM
	challenge_bi.tbl_order as t_order
	LEFT JOIN challenge_bi.tbl_item as Item on Item.order_id_fk=t_order.order_id
	LEFT JOIN challenge_bi.tbl_category as Category on Category.category_id=Item.category_id_fk
	LEFT JOIN challenge_bi.tbl_customer as Customer on t_order.buyer_customer_id_fk=Customer.customer_id
WHERE
	Year(t_order.order_date)= '2019' and
	Category.name = 'Celulares'
GROUP BY
	Customer.first_name,Customer.last_name,t_order.order_date
Order by Venta DESC
LIMIT 5;
```

5. Se solicita poblar una tabla con el precio y estado de los Items a fin del día (se
puede resolver a través de StoredProcedure).
  - Vale resaltar que en la tabla Item, vamos a tener únicamente el último estado
informado por la PK definida
  - Esta información nos va a permitir realizar análisis para entender el
comportamiento de los diferentes Items (por ejemplo evolución de Precios,
cantidad de Items activos).

#### Resolución:

Este Store Procedure, crea (si aún no existe) y llena la tabla tbl_resumen_diario, donde van a estar los campos necesarios para hacer un evolutivo del precio y del estado de los items.

Está desarrollado para que se ejecute con algún gestor de tareas al finalizar el día para obtener los datos diarios.

O si se quiere, se puede poner a correr a primera hora del día siguiente, pero habría que incluir en la sentencia del WHERE del cursor1 "WHERE date_created = SUBDATE(CURDATE(),1)" para traer los items que fueron creados en el día de ayer. En la parte del insert a la tabla resumen tambien deberia modificar y donde dice "CURRENT_DATE(  )" deberiamos poner "SUBDATE(CURDATE(),1)".

Para ejecutarlo:
```
CALL `challenge_bi`.`SP_CreateTable`();
```
Codigo:
```
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_CreateTable`()
BEGIN
-- DECLARO VARIABLES
	DECLARE fin INTEGER DEFAULT 0;
	DECLARE _item_id  		INT(11);
	DECLARE _precio  		decimal(10,2);
	DECLARE _estadoItem  		varchar(100);
	
	-- CREO EL CURSOR CON LOS CAMPOS QUE VAMOS A NECESITAR
	DECLARE cursor1 CURSOR FOR
		SELECT 
			Item.item_id as c_item, Item.unit_price as c_precio, PublishStatus.name as c_estadoItem
		FROM 
			tbl_item as Item
			LEFT JOIN tbl_publish_status as PublishStatus on PublishStatus.publish_status_id= Item.publish_status_fk;
			
	  DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin=1;
	
	-- SI LA TABLA tbl_resumen_diario, NO EXISTE, LA CREO.
	IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tbl_resumen_diario') THEN
		CREATE TABLE `challenge_bi`.`tbl_resumen_diario` (
			`resumen_id` 	INT(11) NOT NULL AUTO_INCREMENT,
			`fecha` 		date NOT NULL,
			`id_item` 		INT(11) NOT NULL,
			`precio_item` 	decimal(10,2) NOT NULL,
			`estado_item` 	VARCHAR(100) NOT NULL,
			PRIMARY KEY (`resumen_id`));
	END IF;

	-- RECORRO EL CURSOR E INSERTO LOS REGISTROS EN LA NUEVA TABLA
	OPEN cursor1;
     		get_item: LOOP
			-- RECUPERO EL CURSOR EN LAS VARIABLES DEFINIDAS
			FETCH cursor1 INTO _item_id, _precio, _estadoItem;
			
			-- SI LLEGO AL FIN SALGO DEL LOOP
			IF fin = 1 THEN
				LEAVE get_item;
			END IF;	
			
			-- SI EL ID NO ES NULO
			IF _item_id IS NOT NULL THEN
				-- INSERTO EN LA TABLA
				INSERT INTO `challenge_bi`.`tbl_resumen_diario` (`fecha`, `id_item`, `precio_item`, `estado_item`) 
					 VALUES ( CURRENT_DATE(  ), _item_id, _precio, _estadoItem);
			END IF;
        	END LOOP get_item;
	CLOSE cursor1;
END$$
DELIMITER ;
```


6. Desde IT nos comentan que la tabla de Categorías tiene un issue ya que cuando
generan modificaciones de una categoría se genera un nuevo registro con la misma
PK en vez de actualizar el ya existente. Teniendo en cuenta que tenemos una
columna de Fecha de LastUpdated, se solicita crear una nueva tabla y poblar la
misma sin ningún tipo de duplicados garantizando la calidad y consistencia de los
datos.

#### Resolución:

Para poder validar el funcionamiento de este Store Procedure, debemos obligar y romper la integridad del modelo de datos, ya que necesitamos que la tabla tbl_category tenga 2 registros con la misma PK.

Entonces:
- Primero debemos eliminar la relación de ITEM y CATEGORY. Y además dejar a la CATEGORY sin PK.
```
ALTER TABLE `challenge_bi`.`tbl_item`  DROP FOREIGN KEY `fk_tbl_item_tbl_category`;
ALTER TABLE `challenge_bi`.`tbl_item` DROP INDEX `fk_tbl_item_tbl_category` ;
ALTER TABLE `challenge_bi`.`tbl_category` DROP PRIMARY KEY; 
```
 - Si usamos el set de datos que envie, dejemos un registro con una pk duplicada.
 ```
UPDATE `challenge_bi`.`tbl_category` SET `category_id` = '1' WHERE (`category_id` = '2');
```

Ahora si podemos utilizar el SP.

Para ejecutarlo:
```
CALL `challenge_bi`.`SP_migrarCategory`();
```
Codigo:
```
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_migrarCategory`()
BEGIN
-- DECLARACION DE VARIABLES
	DECLARE fin 				INTEGER DEFAULT 0;
	DECLARE _category_id 			int(11);
	DECLARE _name 				varchar(100);
	DECLARE _pather_category_id 		int(11);
	DECLARE _is_pather 			int(1);
	DECLARE _permalink 			varchar(100);
	DECLARE _tags 				varchar(100);
	DECLARE _description 			varchar(100);
	DECLARE _path 				varchar(100);
	DECLARE _last_updated 			datetime;
	DECLARE _date_created 			datetime;
	
	-- CREO UN CURSOR CON LOS REGISTROS DUPLICADOS, TOMANDO EL QUE TIENE MAXIMA FECHA DE ACTUALIZACION
	DECLARE cursor_id_duplicadas CURSOR FOR
		SELECT TableA.* FROM 
		(
			SELECT category_id, Max(last_updated) as Maxlast_updated 
			FROM challenge_bi.tbl_category as state_id
			GROUP BY category_id
			HAVING Count(*)>1
		) TableB
		INNER JOIN challenge_bi.tbl_category as TableA
		ON TableA.category_id=TableB.category_id AND TableA.last_updated=TableB.Maxlast_updated;
		
	-- CREO UN CURSOR CON LOS REGISTROS QUE NO ESTAN DUPLICADOS.
	DECLARE cursor_id_No_duplicadas CURSOR FOR
		SELECT TableA.* FROM 
		(
			SELECT category_id, Max(last_updated) as Maxlast_updated 
			FROM challenge_bi.tbl_category as state_id
			GROUP BY category_id
			HAVING Count(*)=1
		) TableB
		INNER JOIN challenge_bi.tbl_category as TableA
		ON TableA.category_id=TableB.category_id AND TableA.last_updated=TableB.Maxlast_updated;
		
	 DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin=1;

-- CREO UNA TABLA TEMPORAL. SI EXISTE, PRIMERO LA BORRO.
-- ESTA TABLA TEMPORAL YA VA A TENER UNA PK, POR LO TANTO NO VA A PERMITIR DUPLICIDAD EN EL ID
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tbl_category_temp') THEN
	DROP TABLE `challenge_bi`.`tbl_category_temp`;
END IF;
	DROP TABLE IF EXISTS `tbl_category_temp`;
	CREATE TABLE `tbl_category_temp` (
	  `category_id` 		int(11) NOT NULL,
	  `name` 				varchar(100) DEFAULT NULL,
	  `pather_category_id` 	int(11) NOT NULL,
	  `is_pather` 			int(1) NOT NULL,
	  `permalink` 			varchar(100) DEFAULT NULL,
	  `tags` 				varchar(100) DEFAULT NULL,
	  `description` 		varchar(100) DEFAULT NULL,
	  `path` 				varchar(100) DEFAULT NULL,
	  `last_updated` 		datetime NOT NULL,
	  `date_created` 		datetime DEFAULT NULL
	) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
	ALTER TABLE `tbl_category_temp`
		ADD PRIMARY KEY (`category_id`);
		
-- RECORRO EL CURSOR DE DUPLICADOS E INSERTO LOS REGISTROS YA LIMPIOS EN LA TABLA TEMPORAL
OPEN cursor_id_duplicadas;
	get_category: LOOP
		-- RECUPERO EL CURSOR EN LAS VARIABLES DECLARADAS.
		FETCH cursor_id_duplicadas INTO _category_id, _name, _pather_category_id, _is_pather, _permalink, _tags, _description, _path, _last_updated, _date_created;
		
		-- SI LLEGO AL FIN SALGO DEL LOOP
		IF fin = 1 THEN
			LEAVE get_category;
		END IF;	
		
		-- SI EL ID DE LA CATEGORIA NO ES NULL
		IF _category_id IS NOT NULL THEN
				-- INSERTO EL REGISTRO QUE TRAIGO DEL CURSOR
				INSERT INTO `challenge_bi`.`tbl_category_temp`
				(`category_id`,`name`,`pather_category_id`,`is_pather`,`permalink`,`tags`,`description`,`path`,`last_updated`,`date_created`) 
				VALUES 	(_category_id, _name, _pather_category_id, _is_pather, _permalink, _tags, _description, _path, _last_updated, _date_created) ;
			END IF;
         END LOOP get_category;
CLOSE cursor_id_duplicadas;
	
-- VUELVO A PONER EN 0 EL CONTADOR PARA EL LOOP
set fin:=0;

-- RECORRO EL CURSOR DE LOS NO DUPLICADOS E INSERTO LOS REGISTROS YA LIMPIOS EN LA TABLA TEMPORAL
OPEN cursor_id_No_duplicadas;
	get2_category: LOOP
		-- RECUPERO EL CURSOR EN LAS VARIABLES DECLARADAS.
		FETCH cursor_id_No_duplicadas INTO _category_id, _name, _pather_category_id, _is_pather, _permalink, _tags, _description, _path, _last_updated, _date_created;
		
		-- SI LLEGO AL FIN SALGO DEL LOOP
		IF fin = 1 THEN
			LEAVE get2_category;
		END IF;	
		
		-- SI EL ID DE LA CATEGORIA NO ES NULL		
		IF _category_id IS NOT NULL THEN
			-- INSERTO EL REGISTRO QUE TRAIGO DEL CURSOR
			INSERT INTO `challenge_bi`.`tbl_category_temp` 
				(`category_id`,`name`,`pather_category_id`,`is_pather`,`permalink`,`tags`,`description`,`path`,`last_updated`,`date_created`) 
				VALUES 	(_category_id, _name, _pather_category_id, _is_pather, _permalink, _tags, _description, _path, _last_updated, _date_created) ;
			END IF;
	END LOOP get2_category;
CLOSE cursor_id_No_duplicadas;
	
	-- ELIMINO LA TABLA ORIGINAL
    DROP TABLE `challenge_bi`.`tbl_category`;  
	-- RENOMBRO LA ORIGINAL
    ALTER TABLE `challenge_bi`.`tbl_category_temp` 
	RENAME TO  `challenge_bi`.`tbl_category` ;
        
    
END$$
DELIMITER ;
```

