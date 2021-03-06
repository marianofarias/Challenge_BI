INSERT INTO `challenge_bi`.`tbl_state` (`state_id`, `name`) VALUES ('1', 'Buenos Aires');
INSERT INTO `challenge_bi`.`tbl_state` (`state_id`, `name`) VALUES ('2', 'Jujuy');
INSERT INTO `challenge_bi`.`tbl_publish_status` (`publish_status_id`, `name`) VALUES ('1', 'Activo');
INSERT INTO `challenge_bi`.`tbl_publish_status` (`publish_status_id`, `name`) VALUES ('2', 'Inactivo');
INSERT INTO `challenge_bi`.`tbl_order_status` (`order_status_id`, `name`) VALUES ('1', 'Confirmed');
INSERT INTO `challenge_bi`.`tbl_order_status` (`order_status_id`, `name`) VALUES ('2', 'Cancelled');
INSERT INTO `tbl_city` (`city_id`, `name`) VALUES(1, 'Cañuelas');
INSERT INTO `tbl_city` (`city_id`, `name`) VALUES(2, 'Junin');
INSERT INTO `tbl_coutry` (`country_ids`, `name`) VALUES(1, 'Argentina');
INSERT INTO `tbl_curency` (`curency_id`, `name`) VALUES(1, 'Pesos');
INSERT INTO `tbl_curency` (`curency_id`, `name`) VALUES(2, 'USD');
INSERT INTO `tbl_customer` (`customer_id`, `first_name`, `last_name`, `gender`, `birth_date`, `phone`, `email`, `last_update`, `date_created`) VALUES(1, 'Florencia', 'Depaula', 'F', '2021-04-29', '0800-', 'flor@gmail.com', '2021-04-29 17:33:38', '2021-04-29 17:33:38');
INSERT INTO `tbl_customer` (`customer_id`, `first_name`, `last_name`, `gender`, `birth_date`, `phone`, `email`, `last_update`, `date_created`) VALUES(2, 'Mariano', 'Martinez', 'M', '2021-04-28', '0800-marra', 'marra@gmail.com', '2021-04-29 17:33:38', '2021-04-29 17:33:38');
INSERT INTO `tbl_customer` (`customer_id`, `first_name`, `last_name`, `gender`, `birth_date`, `phone`, `email`, `last_update`, `date_created`) VALUES(3, 'Daniel', 'Galvan', 'M', '2021-05-01', '0800-daniel', 'daniel@gmail.com', '2021-04-29 17:33:38', '2021-04-29 17:33:38');
INSERT INTO `tbl_geolocalitation` (`geolocalitation_id`, `latitude`, `longitude`) VALUES(1, '656676576.576', '7657657,657');
INSERT INTO `challenge_bi`.`tbl_category` 	(`category_id`,`name`,`last_updated`,`date_created`) VALUES 	(1, 'Celulares Smartphone', '2021-04-29 17:33:38', '2021-04-29 17:33:38') ;
INSERT INTO `challenge_bi`.`tbl_category` 	(`category_id`,`name`,`last_updated`,`date_created`) VALUES 	(2, 'Celulares', '2021-04-27 17:33:38', '2021-04-27 17:33:38') ;
INSERT INTO `challenge_bi`.`tbl_category` 	(`category_id`,`name`,`last_updated`,`date_created`) VALUES 	(3, 'Pelotas de futbol', '2021-04-29 17:33:38', '2021-04-29 17:33:38') ;
INSERT INTO `challenge_bi`.`tbl_adress` (`adress_ids`, `customer_id_fk`, `city_id_fk`, `state_id_fk`, `country_id_fk`, `geolocalitation_id_fk`, `zip_code`, `adress_line`, `street_number`, `street_name`, `last_updated`, `date_created`) VALUES ('1', '1', '1', '1', '1', '1', '1814', 'Caseros 48', 'Caseros', '48', '2021-04-29 17:33:38', '2021-04-29 17:33:38');
INSERT INTO `challenge_bi`.`tbl_order` (`order_id`, `status_id_fk`, `quantity`, `order_date`, `total_amount`, `curency_id_fk`, `payments_id_fk`, `shipping_id_fk`, `buyer_customer_id_fk`, `total_price`, `last_updated`, `date_created`) VALUES ('1', '1', '1', '2020-01-02', '350', '1', '1', '1', '2', '350', '\'2021-04-29 17:33:38\'', '\'2021-04-29 17:33:38\'');
INSERT INTO `challenge_bi`.`tbl_order` (`order_id`, `status_id_fk`, `quantity`, `order_date`, `total_amount`, `curency_id_fk`, `payments_id_fk`, `shipping_id_fk`, `buyer_customer_id_fk`, `total_price`, `last_updated`, `date_created`) VALUES ('2', '1', '1', '2020-01-04', '100', '1', '1', '1', '2', '100', '2020-01-02', '2020-01-02');
INSERT INTO `challenge_bi`.`tbl_item` (`item_id`, `title`, `category_id_fk`, `order_id_fk`, `seller_customer_id_fk`, `curency_id_fk`, `publish_status_fk`, `unit_price`, `unit_in_stock`, `unit_in_order`, `item_condition`, `last_updated`, `date_created`) VALUES ('1', 'Samsung a51', '1', '1', '1', '1', '1', '100', '1', '1', 'NUEVO', '\'2021-04-29 17:33:38\'', '\'2021-04-29 17:33:38\'');
INSERT INTO `challenge_bi`.`tbl_item` (`item_id`, `title`, `category_id_fk`, `order_id_fk`, `seller_customer_id_fk`, `curency_id_fk`, `publish_status_fk`, `unit_price`, `unit_in_stock`, `unit_in_order`, `item_condition`, `last_updated`, `date_created`) VALUES ('2', 'Samsung a51', '1', '1', '1', '1', '1', '120', '1', '1', 'NUEVO', '\'2021-04-29 17:33:38\'', '\'2021-04-29 17:33:38\'');
INSERT INTO `challenge_bi`.`tbl_item` (`item_id`, `title`, `category_id_fk`, `order_id_fk`, `seller_customer_id_fk`, `curency_id_fk`, `publish_status_fk`, `unit_price`, `unit_in_stock`, `unit_in_order`, `item_condition`, `last_updated`, `date_created`) VALUES ('3', 'Samsung a51', '1', '2', '1', '1', '2', '150', '1', '1', 'NUEVO', '\'2021-04-29 17:33:38\'', '\'2021-04-29 17:33:38\'');
