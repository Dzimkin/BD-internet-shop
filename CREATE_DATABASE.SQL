DROP DATABASE IF EXISTS `интернет_магазин`;
CREATE DATABASE `интернет_магазин`;
USE `интернет_магазин`;

DROP TABLE IF EXISTS `торговые_марки`;
CREATE TABLE `торговые_марки` (
  `id_марки` SERIAL PRIMARY KEY, 
  `название` varchar(100) NOT NULL,
  `адрес` varchar(100) DEFAULT NULL,
  `телефон` varchar(20) DEFAULT NULL,
  UNIQUE KEY `название` (`название`)
);

DROP TABLE IF EXISTS `категории_товаров`;
CREATE TABLE `категории_товаров` (
  `id_категории` SERIAL PRIMARY KEY,
  `название` varchar(70) NOT NULL,
  `описание` varchar(255),
  UNIQUE KEY `название` (`название`)
);

DROP TABLE IF EXISTS `товары`;
CREATE TABLE `товары` (
  `id_товара` SERIAL PRIMARY KEY,
  `id_категории` BIGINT UNSIGNED NOT NULL,
  `id_марки` BIGINT UNSIGNED DEFAULT NULL,
  `название` varchar(255) NOT NULL,
  `описание` varchar(255),
  `цена` decimal(10,2) NOT NULL,
  `количество_на_складе` BIGINT UNSIGNED NOT NULL DEFAULT 0,
  FOREIGN KEY (`id_категории`) REFERENCES `категории_товаров` (`id_категории`),
  FOREIGN KEY (`id_марки`) REFERENCES `торговые_марки` (`id_марки`)
);

DROP TABLE IF EXISTS `магазины`;
CREATE TABLE `магазины` (
  `id_магазина` SERIAL PRIMARY KEY,
  `название` varchar(100) NOT NULL,
  `город` varchar(100) NOT NULL,
  `адрес` varchar(255) NOT NULL,
  `телефон` varchar(20) NOT NULL,
  `email` varchar(100) DEFAULT NULL
);

DROP TABLE IF EXISTS `пункты_выдачи`;
CREATE TABLE `пункты_выдачи` (
  `id_пункта` SERIAL PRIMARY KEY,
  `id_магазина` BIGINT UNSIGNED NOT NULL,
  `город` varchar(100) NOT NULL,
  `адрес` varchar(255) NOT NULL,
  `телефон` varchar(20) NOT NULL,
  `часы_работы` varchar(100) DEFAULT NULL, 
  FOREIGN KEY (`id_магазина`) REFERENCES `магазины` (`id_магазина`)
);

DROP TABLE IF EXISTS `поставки`;
CREATE TABLE `поставки` (
  `id_поставки` SERIAL PRIMARY KEY,
  `id_магазина` bigint UNSIGNED NOT NULL,
  `дата_отправки` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `дата_получения` datetime DEFAULT NULL,
  `статус` enum('ожидается','в_пути','доставлено','отменено') NOT NULL DEFAULT 'ожидается',
  `примечания` varchar(255),  
  FOREIGN KEY (`id_магазина`) REFERENCES `магазины` (`id_магазина`)
);

DROP TABLE IF EXISTS `товары_в_поставке`;
CREATE TABLE `товары_в_поставке` (
  `id_записи` SERIAL PRIMARY KEY,
  `id_поставки` BIGINT UNSIGNED NOT NULL,
  `id_товара` BIGINT UNSIGNED NOT NULL,
  `количество` BIGINT UNSIGNED NOT NULL,
  `полученное_количество` BIGINT UNSIGNED DEFAULT NULL,
  FOREIGN KEY (`id_поставки`) REFERENCES `поставки` (`id_поставки`),
  FOREIGN KEY (`id_товара`) REFERENCES `товары` (`id_товара`)
);

DROP TABLE IF EXISTS `пользователи`;
CREATE TABLE `пользователи` (
  `id_пользователя` SERIAL PRIMARY KEY,
  `имя` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `телефон` varchar(20) DEFAULT NULL,
  `адрес` varchar(255) NOT NULL,
  `пароль` varchar(255) NOT NULL,
  `дата_регистрации` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY `email` (`email`)
);

DROP TABLE IF EXISTS `заказы`;
CREATE TABLE `заказы` (
  `id_заказа` SERIAL PRIMARY KEY,
  `id_пользователя` BIGINT UNSIGNED NOT NULL,
  `id_магазина` BIGINT UNSIGNED NOT NULL,
  `id_пункта` BIGINT UNSIGNED DEFAULT NULL,
  `дата_заказа` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `статус` enum('новый','в_обработке','отправлен','доставлен','отменен') NOT NULL DEFAULT 'новый',
  `способ_оплаты` varchar(50) DEFAULT NULL,
  `примечания` varchar(255),
  FOREIGN KEY (`id_пользователя`) REFERENCES `пользователи` (`id_пользователя`),
  FOREIGN KEY (`id_магазина`) REFERENCES `магазины` (`id_магазина`),
  FOREIGN KEY (`id_пункта`) REFERENCES `пункты_выдачи` (`id_пункта`)
);

DROP TABLE IF EXISTS `позиции_заказа`;
CREATE TABLE `позиции_заказа` (
  `id_позиции` SERIAL PRIMARY KEY,
  `id_заказа` BIGINT UNSIGNED NOT NULL,
  `id_товара` BIGINT UNSIGNED NOT NULL,
  `количество` BIGINT UNSIGNED NOT NULL,
  FOREIGN KEY (`id_заказа`) REFERENCES `заказы` (`id_заказа`),
  FOREIGN KEY (`id_товара`) REFERENCES `товары` (`id_товара`)
  
) ;
