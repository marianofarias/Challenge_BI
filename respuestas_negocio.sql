-- 1. Cantidad de usuarios donde su apellido comience con la letra ‘M’.

SELECT
	COUNT(*)
FROM
	challenge_bi.tbl_customer
WHERE
	last_name like 'M%';

-- 2. Listado de los usuarios que cumplan años en el día de la fecha (hoy).

SELECT
	CONCAT(first_name,' ',last_name) as Usuario,
	birth_date as FechaNacimiento
FROM
	challenge_bi.tbl_customer
WHERE
	Month(birth_date)= Month(CURRENT_DATE()) and
	Day(birth_date)= Day(CURRENT_DATE());

-- 3. Por día se necesita, cantidad de ventas realizadas, cantidad de productos vendidos y monto total transaccionado para el mes de Enero del 2020.

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
	status_id_fk = 1 
 GROUP BY order_date;

-- 4. Por cada mes del 2019, se solicita el top 5 de usuarios que más vendieron ($) en la categoría Celulares. Se requiere el mes y año de análisis, nombre y apellido del vendedor, la cantidad vendida y el monto total transaccionado.

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

/*5. Se solicita poblar una tabla con el precio y estado de los Items a fin del día (se puede resolver a través de StoredProcedure).
-- 		a Vale resaltar que en la tabla Item, vamos a tener únicamente el último estado informado por la PK definida.
--		b Esta información nos va a permitir realizar análisis para entender el comportamiento de los diferentes Items (por ejemplo evolución de Precios, cantidad de Items activos).
*/
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_CreateTable`()
BEGIN
	DECLARE fin INTEGER DEFAULT 0;
	DECLARE _item_id  		INT(11);
	DECLARE _precio  		decimal(10,2);
	DECLARE _estadoItem  	varchar(100);

	DECLARE cursor1 CURSOR FOR
	SELECT 
		Item.item_id as c_item, Item.unit_price as c_precio, PublishStatus.name as c_estadoItem
	FROM 
		tbl_item as Item
		LEFT JOIN tbl_publish_status as PublishStatus on PublishStatus.publish_status_id= Item.publish_status_fk;
	  DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin=1;

	IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tbl_resumen_diario') THEN
		CREATE TABLE `challenge_bi`.`tbl_resumen_diario` (
			`resumen_id` 	INT(11) NOT NULL AUTO_INCREMENT,
			`fecha` 		date NOT NULL,
			`id_item` 		INT(11) NOT NULL,
			`precio_item` 	decimal(10,2) NOT NULL,
			`estado_item` 	VARCHAR(100) NOT NULL,
			PRIMARY KEY (`resumen_id`));
	END IF;


	OPEN cursor1;
     get_item: LOOP
		FETCH cursor1 INTO _item_id, _precio, _estadoItem;
        IF fin = 1 THEN
			LEAVE get_item;
		END IF;	
		IF _item_id IS NOT NULL THEN
			INSERT INTO `challenge_bi`.`tbl_resumen_diario` (`fecha`, `id_item`, `precio_item`, `estado_item`) 
				 VALUES ( CURRENT_DATE(  ), _item_id, _precio, _estadoItem);
		END IF;
        END LOOP get_item;
	CLOSE cursor1;
END$$
DELIMITER ;
-- 6. Desde IT nos comentan que la tabla de Categorías tiene un issue ya que cuando generan modificaciones de una categoría se genera un nuevo registro con la misma PK en vez de actualizar el ya existente. Teniendo en cuenta que tenemos una columna de Fecha de LastUpdated, se solicita crear una nueva tabla y poblar la misma sin ningún tipo de duplicados garantizando la calidad y consistencia de los datos.

-- Para poder correr el STORE PROCEDURE debemos eliminar la relacion de ITEM y CATEGORY. Y ademas dejar a la CATEGORY sin PK.alter
ALTER TABLE `challenge_bi`.`tbl_item`  DROP FOREIGN KEY `fk_tbl_item_tbl_category`;
ALTER TABLE `challenge_bi`.`tbl_item` DROP INDEX `fk_tbl_item_tbl_category` ;
ALTER TABLE `challenge_bi`.`tbl_category` DROP PRIMARY KEY; 


-- si usamos el set de datos que envie, dejemos un registro con una pk duplicads
UPDATE `challenge_bi`.`tbl_category` SET `category_id` = '1' WHERE (`category_id` = '2');


DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_migrarCategory`()
BEGIN
	DECLARE fin INTEGER DEFAULT 0;
	DECLARE _category_id 			int(11);
	DECLARE _name 					varchar(100);
	DECLARE _pather_category_id 	int(11);
	DECLARE _is_pather 				int(1);
	DECLARE _permalink 				varchar(100);
	DECLARE _tags 					varchar(100);
	DECLARE _description 			varchar(100);
	DECLARE _path 					varchar(100);
	DECLARE _last_updated 			datetime;
	DECLARE _date_created 			datetime;

DECLARE cursor1 CURSOR FOR
	SELECT TableA.* FROM 
	(
		SELECT category_id, Max(last_updated) as Maxlast_updated 
		FROM challenge_bi.tbl_category as state_id
		GROUP BY category_id
		HAVING Count(*)>1
	) TableB
	INNER JOIN challenge_bi.tbl_category as TableA
	ON TableA.category_id=TableB.category_id AND TableA.last_updated=TableB.Maxlast_updated;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin=1;


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
	
OPEN cursor1;
  get_category: LOOP
		FETCH cursor1 INTO _category_id, _name, _pather_category_id, _is_pather, _permalink, _tags, _description, _path, _last_updated, _date_created;
		IF fin = 1 THEN
			LEAVE get_category;
		END IF;	
			IF _category_id IS NOT NULL THEN
				INSERT INTO `challenge_bi`.`tbl_category_temp` 		(`category_id`,`name`,`pather_category_id`,`is_pather`,`permalink`,`tags`,`description`,`path`,`last_updated`,`date_created`) 
												VALUES 	(_category_id, _name, _pather_category_id, _is_pather, _permalink, _tags, _description, _path, _last_updated, _date_created) ;
			END IF;
         END LOOP get_category;

	CLOSE cursor1;
	
    DROP TABLE `challenge_bi`.`tbl_category`;    
    ALTER TABLE `challenge_bi`.`tbl_category_temp` 
	RENAME TO  `challenge_bi`.`tbl_category` ;
        
    
END$$
DELIMITER ;