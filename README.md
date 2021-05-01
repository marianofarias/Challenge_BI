# CHALLENGE BI

En el presente repositorio se entrega la resolucion del challenge planteado para la validar aptitudes tecnicas relacionadas con el manejo de SQL.

Se uso **MySQL**, que es una base de datos relacional con licencia gratuita. En un momento queria usar PosgresSQL pero no tiene Stored Procedures, sino que en su lugar se usan funciones que actuan de la misma forma, pero no me parecio una buena eleccion.

#### Entregables:

- [DER](https://www.google.com/)

- [DDL](https://www.google.com/)

- [Querys](https://www.google.com/)

## DER

La primer parte del entregable es la creacion de un DER que va a servir para poder responder a preguntas, sobre diferentes casos en el negocio, que fueron enunciadas.
Use la herramienta MySql Workbrench ya que es gratuita y me parece muy completa.

### Cosas que me gustaria resaltar:
  - Agregue una constraint unique del campo "email" en Customer. 

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
3. Listado de los usuarios que cumplan años en el día de la fecha (hoy).
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
5. Por día se necesita, cantidad de ventas realizadas, cantidad de productos vendidos
y monto total transaccionado para el mes de Enero del 2020.
```
SELECT
	COUNT(order_id) as CantidadVentas,
	COUNT(item_id_fk) as ProductosVendidos,
	SUM(total_price) as MontoTotal,
	date_format(order_date,'Y% M% D%') as FechaVenta
FROM
	challenge_bi.tbl_order
Where
	Month(order_date)= 1 and
	Year(order_date)= 2020 and
	status_id_fk = 1 
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
	LEFT JOIN challenge_bi.tbl_item as Item on Item.item_id=t_order.item_id_fk
	LEFT JOIN challenge_bi.tbl_category as Category on Category.category_id=Item.category_id_fk
	LEFT JOIN challenge_bi.tbl_customer as Customer on t_order.buyer_customer_id_fk=Customer.customer_id
WHERE
	Year(t_order.order_date)= '2019' and
	Category.name = 'Celulares'
GROUP BY
	Customer.first_name,Customer.last_name,t_order.order_date
Order by Venta
LIMIT 5;
```

5. Se solicita poblar una tabla con el precio y estado de los Items a fin del día (se
puede resolver a través de StoredProcedure).
  - Vale resaltar que en la tabla Item, vamos a tener únicamente el último estado
informado por la PK definida
  - Esta información nos va a permitir realizar análisis para entender el
comportamiento de los diferentes Items (por ejemplo evolución de Precios,
cantidad de Items activos).
```
USE `challenge_bi`;
	DROP procedure IF EXISTS `SP_CreateTable`;

USE `challenge_bi`;
	DROP procedure IF EXISTS `challenge_bi`.`SP_CreateTable`;
;

DELIMITER $$
USE `challenge_bi`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_CreateTable`()
BEGIN
	DECLARE _item_id  INT(11);
	DECLARE _precio  INT(11);
	DECLARE _estadoItem  varchar(100);
	DECLARE cursor1 CURSOR FOR
	SELECT 
	Item.item_id as c_item, Item.price as c_precio, PublishStatus.name as c_estadoItem
	FROM tbl_item as Item
	LEFT JOIN tbl_publish_status as PublishStatus on PublishStatus.publish_status_id= Item.publish_status_fk;

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tbl_resumen_diario') THEN
	CREATE TABLE `challenge_bi`.`tbl_resumen_diario` (
		`resumen_id` INT NOT NULL,
		`fecha` date NOT NULL,
		`id_item` INT NOT NULL,
		`precio_item` INT NOT NULL,
		`estado_item` VARCHAR(45) NOT NULL,
		PRIMARY KEY (`resumen_id`)
	);
END IF;

OPEN cursor1;
	FETCH cursor1 INTO _item_id, _precio, _estadoItem;
	IF _item_id IS NOT NULL THEN
		INSERT INTO `challenge_bi`.`tbl_resumen_diario` 
			(`fecha`, `id_item`, `precio_item`, `estado_item`)
			VALUES ( CURRENT_DATE(), _item_id, _precio, _estadoItem);
	END IF;
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


