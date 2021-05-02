-- CHALLENGE BI 
--
-- Autor: Mariano GabrielFarias
-- mariano.g.farias@gmail.com
--
-- phpMyAdmin SQL Dump
-- version 5.1.0
-- Versión del servidor: 10.4.18-MariaDB
-- Versión de PHP: 7.3.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
--
-- Base de datos: `challenge_bi`
--
CREATE DATABASE IF NOT EXISTS `challenge_bi` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `challenge_bi`;

-- --------------------------------------------------------
-- TABLES
--
-- Estructura de tabla para la tabla `tbl_adress`
--

DROP TABLE IF EXISTS `tbl_adress`;
CREATE TABLE `tbl_adress` (
  `adress_ids` 				int(11) NOT NULL,
  `customer_id_fk` 			int(11) NOT NULL,
  `city_id_fk` 				int(11) NOT NULL,
  `state_id_fk` 			int(11) NOT NULL,
  `country_id_fk` 			int(11) NOT NULL,
  `geolocalitation_id_fk` 	int(11) NOT NULL,
  `zip_code` 				varchar(100) DEFAULT NULL,
  `floor` 					varchar(100) DEFAULT NULL,
  `adress_line` 			varchar(100) DEFAULT NULL,
  `aparment` 				varchar(100) DEFAULT NULL,
  `street_number` 			varchar(100) DEFAULT NULL,
  `street_name` 			varchar(100) DEFAULT NULL,
  `last_updated` 			datetime NOT NULL,
  `date_created` 			datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- RELACIONES PARA LA TABLA `tbl_adress`:
--   `geolocalitation_id_fk`
--       `tbl_geolocalitation` -> `geolocalitation_id`
--   `city_id_fk`
--       `tbl_city` -> `city_id`
--   `country_id_fk`
--       `tbl_coutry` -> `country_ids`
--   `customer_id_fk`
--       `tbl_customer` -> `customer_id`
--   `state_id_fk`
--       `tbl_state` -> `state_id`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_category`
--

DROP TABLE IF EXISTS `tbl_category`;
CREATE TABLE `tbl_category` (
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
 
-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_city`
--

DROP TABLE IF EXISTS `tbl_city`;
CREATE TABLE `tbl_city` (
  `city_id` 	int(11) NOT NULL,
  `name` 		varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_coutry`
--

DROP TABLE IF EXISTS `tbl_coutry`;
CREATE TABLE `tbl_coutry` (
  `country_ids` 	int(11) NOT NULL,
  `name` 			varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_curency`
--

DROP TABLE IF EXISTS `tbl_curency`;
CREATE TABLE `tbl_curency` (
  `curency_id` 	int(11) NOT NULL,
  `name` 		varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_customer`
--

DROP TABLE IF EXISTS `tbl_customer`;
CREATE TABLE `tbl_customer` (
  `customer_id` 	int(11) NOT NULL,
  `first_name` 		varchar(100) DEFAULT NULL,
  `last_name` 		varchar(100) DEFAULT NULL,
  `gender` 			varchar(100) DEFAULT NULL,
  `birth_date` 		date DEFAULT NULL,
  `phone` 			varchar(100) DEFAULT NULL,
  `email` 			varchar(100) DEFAULT NULL,
  `last_update` 	datetime NOT NULL,
  `document_type` 	varchar(100) DEFAULT NULL,
  `document_number` varchar(100) DEFAULT NULL,
  `date_created` 	datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_geolocalitation`
--

DROP TABLE IF EXISTS `tbl_geolocalitation`;
CREATE TABLE `tbl_geolocalitation` (
  `geolocalitation_id` 	int(11) NOT NULL,
  `latitude` 			varchar(100) DEFAULT NULL,
  `longitude` 			varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_item`
--

DROP TABLE IF EXISTS `tbl_item`;
CREATE TABLE `tbl_item` (
  `item_id` 				int(11) NOT NULL,
  `title` 					varchar(100) DEFAULT NULL,
  `category_id_fk` 			int(11) DEFAULT NULL,
  `order_id_fk` 			int(11) NOT NULL,  
  `seller_customer_id_fk` 	int(11) DEFAULT NULL,
  `curency_id_fk` 			int(11) DEFAULT NULL,
  `publish_status_fk` 		int(11) DEFAULT NULL,
  `unit_price` 				decimal(10,2) NOT NULL,
  `fecha_baja` 				DATE DEFAULT NULL,
  `unit_in_stock` 			int(11) DEFAULT NULL,
  `unit_in_order` 			int(11) DEFAULT NULL,
  `item_condition` 			varchar(100) DEFAULT NULL,
  `last_updated` 			datetime DEFAULT NULL,
  `date_created` 			datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


--
-- RELACIONES PARA LA TABLA `tbl_item`:
--   `category_id_fk`
--       `tbl_category` -> `category_id`
--   `curency_id_fk`
--       `tbl_curency` -> `curency_id`
--   `seller_customer_id_fk`
--       `tbl_customer` -> `customer_id`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_order`
--

DROP TABLE IF EXISTS `tbl_order`;
CREATE TABLE `tbl_order` (
  `order_id` 				int(11) NOT NULL,
  `status_id_fk` 			int(11) NOT NULL,
  `quantity`				int(11) NOT NULL,
  `order_date` 				DATE DEFAULT NULL,
  `date_closed`				DATE DEFAULT NULL,
  `total_amount`			decimal(10,2) NOT NULL,
  `curency_id_fk` 			int(11) DEFAULT NULL,
  `payments_id_fk`			int(11) NOT NULL,
  `shipping_id_fk`			int(11) NOT NULL,
  `taxes`					decimal(10,2) NOT NULL,
  `buyer_customer_id_fk` 	int(11) NOT NULL,
  `total_price` 			int(11) DEFAULT NULL,
  `last_updated` 			datetime DEFAULT NULL,
  `date_created` 			datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- RELACIONES PARA LA TABLA `tbl_order`:
--   `buyer_customer_id_fk`
--       `tbl_customer` -> `customer_id`
--   `item_id_fk`
--       `tbl_item` -> `item_id`
--   `status_id_fk`
--       `tbl_order_status` -> `order_status_id`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_order_status`
--

DROP TABLE IF EXISTS `tbl_order_status`;
CREATE TABLE `tbl_order_status` (
  `order_status_id` 	int(11) 		NOT NULL,
  `name` 				varchar(100) 	NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_publish_status`
--

DROP TABLE IF EXISTS `tbl_publish_status`;
CREATE TABLE `tbl_publish_status` (
  `publish_status_id` 	int(11) 		NOT NULL,
  `name` 				varchar(100) 	NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
--
-- Estructura de tabla para la tabla `tbl_state`
--

DROP TABLE IF EXISTS `tbl_state`;
CREATE TABLE `tbl_state` (
  `state_id` 	int(11) 		NOT NULL,
  `name` 		varchar(100) 	NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
 
--
-- Indices de la tabla `tbl_adress`
--
ALTER TABLE `tbl_adress`
  ADD PRIMARY KEY (`adress_ids`),
  ADD KEY `fk_tbl_adress_tbl_state` (`state_id_fk`),
  ADD KEY `fk_tbl_adress_tbl_city` (`city_id_fk`),
  ADD KEY `fk_tbl_adress_tbl_coutry` (`country_id_fk`),
  ADD KEY `fk_tbl_adress_tbl_customer` (`customer_id_fk`),
  ADD KEY `fk_tbl_adress` (`geolocalitation_id_fk`);

--
-- Indices de la tabla `tbl_city`
--
ALTER TABLE `tbl_city`
  ADD PRIMARY KEY (`city_id`);

--
-- Indices de la tabla `tbl_coutry`
--
ALTER TABLE `tbl_coutry`
  ADD PRIMARY KEY (`country_ids`);
  
--
-- Indices de la tabla `tbl_curency`
--
ALTER TABLE `tbl_curency`
  ADD PRIMARY KEY (`curency_id`);

--
-- Indices de la tabla `tbl_customer`
--
ALTER TABLE `tbl_customer` 
	ADD UNIQUE(`email`);
ALTER TABLE `tbl_customer` 
	ADD UNIQUE(`document_number`);
ALTER TABLE `tbl_customer`
  ADD PRIMARY KEY (`customer_id`);

--
-- Indices de la tabla `tbl_geolocalitation`
--
ALTER TABLE `tbl_geolocalitation`
  ADD PRIMARY KEY (`geolocalitation_id`);

--
-- Indices de la tabla `tbl_item`
--
ALTER TABLE `tbl_item`
  ADD PRIMARY KEY (`item_id`),
  ADD KEY `fk_tbl_item_tbl_category` (`category_id_fk`),
  ADD KEY `fk_tbl_item_tbl_customer` (`seller_customer_id_fk`),
  ADD KEY `fk_tbl_item_tbl_order` (`order_id_fk`),
  ADD KEY `fk_tbl_item_tbl_curency` (`curency_id_fk`);
  
  
--
-- Indices de la tabla `tbl_order_status`
--
ALTER TABLE `tbl_order_status`
  ADD PRIMARY KEY (`order_status_id`);

--
-- Indices de la tabla `tbl_order`
--
ALTER TABLE `tbl_order`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `fk_tbl_order_tbl_order_status` (`status_id_fk`),
  ADD KEY `fk_tbl_order_tbl_customer` (`buyer_customer_id_fk`);
 
--
-- Indices de la tabla `tbl_publish_status`
--
ALTER TABLE `tbl_publish_status`
  ADD PRIMARY KEY (`publish_status_id`);
  
  --
-- Indices de la tabla `tbl_publish_status`
--
ALTER TABLE `tbl_category`
  ADD PRIMARY KEY (`category_id`);

--
-- Indices de la tabla `tbl_state`
--
ALTER TABLE `tbl_state`
  ADD PRIMARY KEY (`state_id`);


-- --------------------------------------------------------


--
-- Filtros para la tabla `tbl_adress`
--
ALTER TABLE `tbl_adress`
  ADD CONSTRAINT `fk_tbl_adress` 				FOREIGN KEY (`geolocalitation_id_fk`) 	REFERENCES `tbl_geolocalitation` (`geolocalitation_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_tbl_adress_tbl_city` 		FOREIGN KEY (`city_id_fk`) 				REFERENCES `tbl_city` (`city_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_tbl_adress_tbl_coutry` 	FOREIGN KEY (`country_id_fk`) 			REFERENCES `tbl_coutry` (`country_ids`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_tbl_adress_tbl_customer` 	FOREIGN KEY (`customer_id_fk`) 			REFERENCES `tbl_customer` (`customer_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_tbl_adress_tbl_state` 		FOREIGN KEY (`state_id_fk`) 			REFERENCES `tbl_state` (`state_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
    
--
-- Filtros para la tabla `tbl_item`
--
ALTER TABLE `tbl_item`
  ADD CONSTRAINT `fk_tbl_item_tbl_curency` 		FOREIGN KEY (`curency_id_fk`) 				REFERENCES `tbl_curency` (`curency_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_tbl_item_tbl_order` 			FOREIGN KEY (`order_id_fk`) 				REFERENCES `tbl_order` (`order_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_tbl_item_tbl_customer` 		FOREIGN KEY (`seller_customer_id_fk`) 	REFERENCES `tbl_customer` (`customer_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_tbl_item_tbl_category` 		FOREIGN KEY (`category_id_fk`) 	REFERENCES `tbl_category` (`category_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_tbl_item_tbl_status` 		FOREIGN KEY (`publish_status_fk`) 	REFERENCES `tbl_publish_status` (`publish_status_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
  
--
-- Filtros para la tabla `tbl_order`
--
ALTER TABLE `tbl_order`
  ADD CONSTRAINT `fk_tbl_order_tbl_customer` 		FOREIGN KEY (`buyer_customer_id_fk`) 	REFERENCES `tbl_customer` (`customer_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_tbl_order_tbl_order_status` 	FOREIGN KEY (`status_id_fk`) 			REFERENCES `tbl_order_status` (`order_status_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_tbl_order_tbl_curency` 		FOREIGN KEY (`curency_id_fk`) 			REFERENCES `tbl_curency` (`curency_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- --------------------------------------------------------
 
COMMIT;
  
-- --------------------------------------------------------

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
