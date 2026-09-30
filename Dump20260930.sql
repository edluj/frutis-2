CREATE DATABASE  IF NOT EXISTS `db_fruteria_erp` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `db_fruteria_erp`;
-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: db_fruteria_erp
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `caja_chica_presupuesto`
--

DROP TABLE IF EXISTS `caja_chica_presupuesto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `caja_chica_presupuesto` (
  `id_movimiento` int NOT NULL AUTO_INCREMENT,
  `tipo_movimiento` enum('INGRESO','EGRESO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `fecha_movimiento` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_movimiento`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `caja_chica_presupuesto`
--

LOCK TABLES `caja_chica_presupuesto` WRITE;
/*!40000 ALTER TABLE `caja_chica_presupuesto` DISABLE KEYS */;
INSERT INTO `caja_chica_presupuesto` VALUES (1,'INGRESO','Fondo fijo inicial de caja',2000.00,'2026-09-25 12:17:12'),(2,'EGRESO','Compra de garrafones de agua',150.00,'2026-09-25 12:17:12'),(3,'EGRESO','Pago de recolección de basura',300.00,'2026-09-25 12:17:12'),(4,'EGRESO','Compra de artículos de limpieza',450.00,'2026-09-25 12:17:12'),(5,'INGRESO','Reposición de caja por administración',1000.00,'2026-09-25 12:17:12');
/*!40000 ALTER TABLE `caja_chica_presupuesto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categorias_producto`
--

DROP TABLE IF EXISTS `categorias_producto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categorias_producto` (
  `id_categoria` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_categoria`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categorias_producto`
--

LOCK TABLES `categorias_producto` WRITE;
/*!40000 ALTER TABLE `categorias_producto` DISABLE KEYS */;
INSERT INTO `categorias_producto` VALUES (3,'Cítricos'),(6,'Especiales'),(1,'Frutas'),(5,'Hojas y Hierbas'),(4,'Raíces'),(2,'Verduras');
/*!40000 ALTER TABLE `categorias_producto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `id_cliente` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `telefono` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `correo` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `direccion` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_cliente`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (1,'Alejandro Garza','8112345678','alejandro@email.com','Av. Constitución 100'),(2,'Brenda Morales','8123456789','brenda@email.com','Calle Hidalgo 205'),(3,'Carlos Treviño','8134567890','carlos@email.com','Blvd. Madero 300'),(4,'Diana Elizondo','8145678901','diana@email.com','Paseo Leones 400'),(5,'Ernesto Garza','8156789012','ernesto@email.com','Av. San Jerónimo 500');
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `compras_proveedores`
--

DROP TABLE IF EXISTS `compras_proveedores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `compras_proveedores` (
  `id_compra` int NOT NULL AUTO_INCREMENT,
  `id_proveedor` int NOT NULL,
  `id_producto` int NOT NULL,
  `cantidad_surtida` decimal(10,2) NOT NULL,
  `costo_total_compra` decimal(10,2) NOT NULL,
  `fecha_recepcion` datetime DEFAULT CURRENT_TIMESTAMP,
  `lote` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_compra`),
  KEY `id_proveedor` (`id_proveedor`),
  KEY `id_producto` (`id_producto`),
  CONSTRAINT `compras_proveedores_ibfk_1` FOREIGN KEY (`id_proveedor`) REFERENCES `proveedores` (`id_proveedor`),
  CONSTRAINT `compras_proveedores_ibfk_2` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `compras_proveedores`
--

LOCK TABLES `compras_proveedores` WRITE;
/*!40000 ALTER TABLE `compras_proveedores` DISABLE KEYS */;
INSERT INTO `compras_proveedores` VALUES (1,1,1,50.00,1100.00,'2026-09-25 12:17:12','LOTE-A1'),(2,2,7,20.00,900.00,'2026-09-25 12:17:12','LOTE-B2'),(3,3,11,100.00,1000.00,'2026-09-25 12:17:12','LOTE-C3'),(4,4,8,50.00,800.00,'2026-09-25 12:17:12','LOTE-D4'),(5,5,20,10.00,550.00,'2026-09-25 12:17:12','LOTE-E5');
/*!40000 ALTER TABLE `compras_proveedores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cuentas_por_pagar`
--

DROP TABLE IF EXISTS `cuentas_por_pagar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cuentas_por_pagar` (
  `id_cuenta` int NOT NULL AUTO_INCREMENT,
  `id_proveedor` int NOT NULL,
  `monto_total` decimal(10,2) NOT NULL,
  `monto_pagado` decimal(10,2) DEFAULT '0.00',
  `saldo_pendiente` decimal(10,2) GENERATED ALWAYS AS ((`monto_total` - `monto_pagado`)) STORED,
  `fecha_limite` date DEFAULT NULL,
  `estado` enum('Pendiente','Parcial','Pagado') COLLATE utf8mb4_unicode_ci DEFAULT 'Pendiente',
  PRIMARY KEY (`id_cuenta`),
  KEY `id_proveedor` (`id_proveedor`),
  CONSTRAINT `cuentas_por_pagar_ibfk_1` FOREIGN KEY (`id_proveedor`) REFERENCES `proveedores` (`id_proveedor`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cuentas_por_pagar`
--

LOCK TABLES `cuentas_por_pagar` WRITE;
/*!40000 ALTER TABLE `cuentas_por_pagar` DISABLE KEYS */;
INSERT INTO `cuentas_por_pagar` (`id_cuenta`, `id_proveedor`, `monto_total`, `monto_pagado`, `fecha_limite`, `estado`) VALUES (1,1,5000.00,2500.00,'2026-10-15','Parcial'),(2,2,3500.00,3500.00,'2026-09-20','Pagado'),(3,3,8000.00,0.00,'2026-11-01','Pendiente'),(4,4,1200.00,600.00,'2026-10-10','Parcial'),(5,5,4500.00,0.00,'2026-11-15','Pendiente');
/*!40000 ALTER TABLE `cuentas_por_pagar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `detalle_pedidos`
--

DROP TABLE IF EXISTS `detalle_pedidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `detalle_pedidos` (
  `id_detalle` int NOT NULL AUTO_INCREMENT,
  `id_pedido` int NOT NULL,
  `id_producto` int NOT NULL,
  `cantidad` decimal(10,2) NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) GENERATED ALWAYS AS ((`cantidad` * `precio_unitario`)) STORED,
  PRIMARY KEY (`id_detalle`),
  KEY `id_pedido` (`id_pedido`),
  KEY `id_producto` (`id_producto`),
  CONSTRAINT `detalle_pedidos_ibfk_1` FOREIGN KEY (`id_pedido`) REFERENCES `pedidos` (`id_pedido`) ON DELETE CASCADE,
  CONSTRAINT `detalle_pedidos_ibfk_2` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`)
) ENGINE=InnoDB AUTO_INCREMENT=110 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detalle_pedidos`
--

LOCK TABLES `detalle_pedidos` WRITE;
/*!40000 ALTER TABLE `detalle_pedidos` DISABLE KEYS */;
INSERT INTO `detalle_pedidos` (`id_detalle`, `id_pedido`, `id_producto`, `cantidad`, `precio_unitario`) VALUES (1,1,1,4.00,35.00),(2,2,7,3.00,75.00),(3,3,18,1.50,50.00),(4,4,15,10.00,15.00),(5,4,10,10.00,18.00),(6,5,20,1.00,90.00),(7,6,7,2.00,75.00),(8,7,8,1.50,26.00),(9,10,1,2.00,75.00),(10,9,1,2.00,75.00),(11,11,1,2.00,75.00),(12,13,1,2.00,75.00),(13,8,1,2.00,75.00),(14,12,1,2.00,75.00),(15,14,1,2.00,75.00),(16,15,1,2.00,75.00),(17,16,1,2.00,75.00),(18,18,1,2.00,75.00),(19,17,1,2.00,75.00),(20,20,1,2.00,75.00),(21,21,1,2.00,75.00),(22,19,1,2.00,75.00),(23,23,1,2.00,75.00),(24,24,1,2.00,75.00),(25,30,1,2.00,75.00),(26,32,1,2.00,75.00),(27,51,1,2.00,75.00),(28,53,1,2.00,75.00),(29,35,1,2.00,75.00),(30,54,1,2.00,75.00),(31,25,1,2.00,75.00),(32,28,1,2.00,75.00),(33,27,1,2.00,75.00),(34,31,1,2.00,75.00),(35,29,1,2.00,75.00),(36,33,1,2.00,75.00),(37,48,1,2.00,75.00),(38,22,1,2.00,75.00),(39,34,1,2.00,75.00),(40,36,1,2.00,75.00),(41,44,1,2.00,75.00),(42,47,1,2.00,75.00),(43,50,1,2.00,75.00),(44,43,1,2.00,75.00),(45,46,1,2.00,75.00),(46,41,1,2.00,75.00),(47,49,1,2.00,75.00),(48,37,1,2.00,75.00),(49,40,1,2.00,75.00),(50,45,1,2.00,75.00),(51,26,1,2.00,75.00),(52,42,1,2.00,75.00),(53,52,1,2.00,75.00),(54,38,1,2.00,75.00),(55,39,1,2.00,75.00),(56,55,1,2.00,75.00),(57,56,1,2.00,75.00),(58,57,1,2.00,75.00),(59,58,1,2.00,75.00),(60,59,1,2.00,75.00),(61,60,1,2.00,75.00),(62,61,1,2.00,75.00),(63,63,1,2.00,75.00),(64,62,1,2.00,75.00),(65,64,1,2.00,75.00),(66,65,1,2.00,75.00),(67,66,1,2.00,75.00),(68,67,1,2.00,75.00),(69,68,1,2.00,75.00),(70,69,1,2.00,75.00),(71,70,1,2.00,75.00),(72,71,1,2.00,75.00),(73,72,1,2.00,75.00),(74,73,1,2.00,75.00),(75,74,1,2.00,75.00),(76,75,1,2.00,75.00),(77,76,1,2.00,75.00),(78,77,1,2.00,75.00),(79,78,1,2.00,75.00),(80,79,1,2.00,75.00),(81,80,1,2.00,75.00),(82,81,1,2.00,75.00),(83,82,1,2.00,75.00),(84,83,1,2.00,75.00),(85,84,1,2.00,75.00),(86,85,1,2.00,75.00),(87,86,1,2.00,75.00),(88,87,1,2.00,75.00),(89,88,1,2.00,75.00),(90,89,1,2.00,75.00),(91,90,1,2.00,75.00),(92,91,1,2.00,75.00),(93,92,1,2.00,75.00),(94,93,1,2.00,75.00),(95,94,1,2.00,75.00),(96,95,1,2.00,75.00),(97,96,1,2.00,75.00),(98,97,1,2.00,75.00),(99,98,1,2.00,75.00),(100,99,1,2.00,75.00),(101,100,1,2.00,75.00),(102,101,1,2.00,75.00),(103,102,1,2.00,75.00),(104,103,1,2.00,75.00),(105,104,1,2.00,75.00),(106,105,1,2.00,75.00),(107,106,1,2.00,75.00),(108,107,1,2.00,75.00),(109,108,20,2.00,90.00);
/*!40000 ALTER TABLE `detalle_pedidos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `factura`
--

DROP TABLE IF EXISTS `factura`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `factura` (
  `id_factura` int NOT NULL AUTO_INCREMENT,
  `id_pedido` int DEFAULT NULL,
  `numero` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `codigo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha` datetime DEFAULT CURRENT_TIMESTAMP,
  `importe` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id_factura`),
  UNIQUE KEY `codigo` (`codigo`),
  KEY `id_pedido` (`id_pedido`),
  CONSTRAINT `factura_ibfk_1` FOREIGN KEY (`id_pedido`) REFERENCES `pedidos` (`id_pedido`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `factura`
--

LOCK TABLES `factura` WRITE;
/*!40000 ALTER TABLE `factura` DISABLE KEYS */;
INSERT INTO `factura` VALUES (1,1,'F-001','UUID-1111-AAAA-0001','2026-09-25 12:17:16',140.00),(2,2,'F-002','UUID-2222-BBBB-0002','2026-09-25 12:17:16',225.00),(3,3,'F-003','UUID-3333-CCCC-0003','2026-09-25 12:17:16',75.00),(4,4,'F-004','UUID-4444-DDDD-0004','2026-09-25 12:17:16',330.00),(5,5,'F-005','UUID-5555-EEEE-0005','2026-09-25 12:17:16',90.00);
/*!40000 ALTER TABLE `factura` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `factura_detalle`
--

DROP TABLE IF EXISTS `factura_detalle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `factura_detalle` (
  `id_factura_detalle` int NOT NULL AUTO_INCREMENT,
  `id_factura` int NOT NULL,
  `tipo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `costo_asoc` decimal(10,2) NOT NULL,
  `iva` decimal(10,2) NOT NULL,
  `medio_de_pago` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `descripcion_pago` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_factura_detalle`),
  KEY `id_factura` (`id_factura`),
  CONSTRAINT `factura_detalle_ibfk_1` FOREIGN KEY (`id_factura`) REFERENCES `factura` (`id_factura`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `factura_detalle`
--

LOCK TABLES `factura_detalle` WRITE;
/*!40000 ALTER TABLE `factura_detalle` DISABLE KEYS */;
INSERT INTO `factura_detalle` VALUES (1,1,'Producto','Venta de Manzana Gala (4 kg)',120.69,19.31,'Efectivo','Pago en una sola exhibición'),(2,2,'Producto','Venta de Aguacate Hass (3 kg)',193.97,31.03,'Tarjeta de Débito','Aprobación: 456123'),(3,3,'Producto','Venta de Fresa (1.5 charolas)',64.66,10.34,'Efectivo','Pago exacto en ventanilla'),(4,4,'Producto','Venta de Sandía y Zanahoria',284.48,45.52,'Tarjeta de Crédito','Aprobación: 789456, a meses'),(5,5,'Producto','Venta de Ajo Blanco (1 kg)',77.59,12.41,'Transferencia SPEI','Clave rastreo: ABC123XYZ');
/*!40000 ALTER TABLE `factura_detalle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flujo_financiero`
--

DROP TABLE IF EXISTS `flujo_financiero`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flujo_financiero` (
  `id_movimiento` int NOT NULL AUTO_INCREMENT,
  `tipo` enum('INGRESO','EGRESO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `categoria` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `referencia_id` int DEFAULT NULL,
  `descripcion` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `saldo_acumulado` decimal(10,2) NOT NULL,
  `fecha` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_movimiento`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flujo_financiero`
--

LOCK TABLES `flujo_financiero` WRITE;
/*!40000 ALTER TABLE `flujo_financiero` DISABLE KEYS */;
INSERT INTO `flujo_financiero` VALUES (1,'INGRESO','Venta',6,'Venta de 2.0 kg Aguacate Hass',150.00,150.00,'2026-09-25 12:36:00'),(2,'INGRESO','Venta',7,'Venta de 1.5 kg Cebolla Blanca',39.00,189.00,'2026-09-25 12:37:33'),(3,'EGRESO','Merma',1,'Pérdida por se lo robaron XD  (Cilantro Fresco)',8.00,181.00,'2026-09-25 12:42:20'),(4,'INGRESO','Venta',108,'Venta de 2.0 kg Ajo Blanco',180.00,361.00,'2026-09-30 08:39:53');
/*!40000 ALTER TABLE `flujo_financiero` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mermas_inventario`
--

DROP TABLE IF EXISTS `mermas_inventario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mermas_inventario` (
  `id_merma` int NOT NULL AUTO_INCREMENT,
  `id_producto` int NOT NULL,
  `cantidad` decimal(10,2) NOT NULL,
  `motivo` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `costo_perdida` decimal(10,2) NOT NULL,
  `fecha` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_merma`),
  KEY `id_producto` (`id_producto`),
  CONSTRAINT `mermas_inventario_ibfk_1` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mermas_inventario`
--

LOCK TABLES `mermas_inventario` WRITE;
/*!40000 ALTER TABLE `mermas_inventario` DISABLE KEYS */;
INSERT INTO `mermas_inventario` VALUES (1,5,2.00,'se lo robaron XD ',8.00,'2026-09-25 12:42:20');
/*!40000 ALTER TABLE `mermas_inventario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidos`
--

DROP TABLE IF EXISTS `pedidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos` (
  `id_pedido` int NOT NULL AUTO_INCREMENT,
  `id_cliente` int DEFAULT NULL,
  `id_personal` int NOT NULL,
  `id_tipo_pago` int NOT NULL,
  `fecha_pedido` datetime DEFAULT CURRENT_TIMESTAMP,
  `total` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id_pedido`),
  KEY `id_cliente` (`id_cliente`),
  KEY `id_personal` (`id_personal`),
  KEY `id_tipo_pago` (`id_tipo_pago`),
  CONSTRAINT `pedidos_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`),
  CONSTRAINT `pedidos_ibfk_2` FOREIGN KEY (`id_personal`) REFERENCES `personal` (`id_personal`),
  CONSTRAINT `pedidos_ibfk_3` FOREIGN KEY (`id_tipo_pago`) REFERENCES `tipo_pago` (`id_tipo_pago`)
) ENGINE=InnoDB AUTO_INCREMENT=109 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos`
--

LOCK TABLES `pedidos` WRITE;
/*!40000 ALTER TABLE `pedidos` DISABLE KEYS */;
INSERT INTO `pedidos` VALUES (1,1,3,1,'2026-09-25 12:17:12',140.00),(2,2,4,2,'2026-09-25 12:17:12',225.00),(3,3,3,1,'2026-09-25 12:17:12',75.00),(4,4,5,3,'2026-09-25 12:17:12',330.00),(5,5,3,4,'2026-09-25 12:17:12',90.00),(6,NULL,2,1,'2026-09-25 12:36:00',150.00),(7,NULL,2,4,'2026-09-25 12:37:33',39.00),(8,NULL,1,1,'2026-09-29 09:47:05',150.00),(9,NULL,1,1,'2026-09-29 09:47:05',150.00),(10,NULL,1,1,'2026-09-29 09:47:05',150.00),(11,NULL,1,1,'2026-09-29 09:47:05',150.00),(12,NULL,1,1,'2026-09-29 09:47:05',150.00),(13,NULL,1,1,'2026-09-29 09:47:05',150.00),(14,NULL,1,1,'2026-09-29 09:47:05',150.00),(15,NULL,1,1,'2026-09-29 09:47:05',150.00),(16,NULL,1,1,'2026-09-29 09:47:05',150.00),(17,NULL,1,1,'2026-09-29 09:47:05',150.00),(18,NULL,1,1,'2026-09-29 09:47:05',150.00),(19,NULL,1,1,'2026-09-29 09:47:05',150.00),(20,NULL,1,1,'2026-09-29 09:47:05',150.00),(21,NULL,1,1,'2026-09-29 09:47:05',150.00),(22,NULL,1,1,'2026-09-29 09:47:05',150.00),(23,NULL,1,1,'2026-09-29 09:47:05',150.00),(24,NULL,1,1,'2026-09-29 09:47:05',150.00),(25,NULL,1,1,'2026-09-29 09:47:05',150.00),(26,NULL,1,1,'2026-09-29 09:47:05',150.00),(27,NULL,1,1,'2026-09-29 09:47:05',150.00),(28,NULL,1,1,'2026-09-29 09:47:05',150.00),(29,NULL,1,1,'2026-09-29 09:47:05',150.00),(30,NULL,1,1,'2026-09-29 09:47:05',150.00),(31,NULL,1,1,'2026-09-29 09:47:05',150.00),(32,NULL,1,1,'2026-09-29 09:47:05',150.00),(33,NULL,1,1,'2026-09-29 09:47:05',150.00),(34,NULL,1,1,'2026-09-29 09:47:05',150.00),(35,NULL,1,1,'2026-09-29 09:47:05',150.00),(36,NULL,1,1,'2026-09-29 09:47:05',150.00),(37,NULL,1,1,'2026-09-29 09:47:05',150.00),(38,NULL,1,1,'2026-09-29 09:47:05',150.00),(39,NULL,1,1,'2026-09-29 09:47:05',150.00),(40,NULL,1,1,'2026-09-29 09:47:05',150.00),(41,NULL,1,1,'2026-09-29 09:47:05',150.00),(42,NULL,1,1,'2026-09-29 09:47:05',150.00),(43,NULL,1,1,'2026-09-29 09:47:05',150.00),(44,NULL,1,1,'2026-09-29 09:47:05',150.00),(45,NULL,1,1,'2026-09-29 09:47:05',150.00),(46,NULL,1,1,'2026-09-29 09:47:05',150.00),(47,NULL,1,1,'2026-09-29 09:47:05',150.00),(48,NULL,1,1,'2026-09-29 09:47:05',150.00),(49,NULL,1,1,'2026-09-29 09:47:05',150.00),(50,NULL,1,1,'2026-09-29 09:47:05',150.00),(51,NULL,1,1,'2026-09-29 09:47:05',150.00),(52,NULL,1,1,'2026-09-29 09:47:05',150.00),(53,NULL,1,1,'2026-09-29 09:47:05',150.00),(54,NULL,1,1,'2026-09-29 09:47:05',150.00),(55,NULL,1,1,'2026-09-29 09:47:05',150.00),(56,NULL,1,1,'2026-09-29 09:47:05',150.00),(57,NULL,1,1,'2026-09-29 09:47:05',150.00),(58,NULL,1,1,'2026-09-29 09:47:05',150.00),(59,NULL,1,1,'2026-09-29 09:47:05',150.00),(60,NULL,1,1,'2026-09-29 09:47:05',150.00),(61,NULL,1,1,'2026-09-29 09:47:05',150.00),(62,NULL,1,1,'2026-09-29 09:47:05',150.00),(63,NULL,1,1,'2026-09-29 09:47:05',150.00),(64,NULL,1,1,'2026-09-29 09:47:06',150.00),(65,NULL,1,1,'2026-09-29 09:47:06',150.00),(66,NULL,1,1,'2026-09-29 09:47:06',150.00),(67,NULL,1,1,'2026-09-29 09:47:06',150.00),(68,NULL,1,1,'2026-09-29 09:47:06',150.00),(69,NULL,1,1,'2026-09-29 09:47:06',150.00),(70,NULL,1,1,'2026-09-29 09:47:06',150.00),(71,NULL,1,1,'2026-09-29 09:47:06',150.00),(72,NULL,1,1,'2026-09-29 09:47:06',150.00),(73,NULL,1,1,'2026-09-29 09:47:06',150.00),(74,NULL,1,1,'2026-09-29 09:47:06',150.00),(75,NULL,1,1,'2026-09-29 09:47:06',150.00),(76,NULL,1,1,'2026-09-29 09:47:06',150.00),(77,NULL,1,1,'2026-09-29 09:47:06',150.00),(78,NULL,1,1,'2026-09-29 09:47:06',150.00),(79,NULL,1,1,'2026-09-29 09:47:06',150.00),(80,NULL,1,1,'2026-09-29 09:47:06',150.00),(81,NULL,1,1,'2026-09-29 09:47:06',150.00),(82,NULL,1,1,'2026-09-29 09:47:06',150.00),(83,NULL,1,1,'2026-09-29 09:47:06',150.00),(84,NULL,1,1,'2026-09-29 09:47:06',150.00),(85,NULL,1,1,'2026-09-29 09:47:06',150.00),(86,NULL,1,1,'2026-09-29 09:47:06',150.00),(87,NULL,1,1,'2026-09-29 09:47:06',150.00),(88,NULL,1,1,'2026-09-29 09:47:06',150.00),(89,NULL,1,1,'2026-09-29 09:47:06',150.00),(90,NULL,1,1,'2026-09-29 09:47:06',150.00),(91,NULL,1,1,'2026-09-29 09:47:06',150.00),(92,NULL,1,1,'2026-09-29 09:47:06',150.00),(93,NULL,1,1,'2026-09-29 09:47:06',150.00),(94,NULL,1,1,'2026-09-29 09:47:06',150.00),(95,NULL,1,1,'2026-09-29 09:47:06',150.00),(96,NULL,1,1,'2026-09-29 09:47:06',150.00),(97,NULL,1,1,'2026-09-29 09:47:06',150.00),(98,NULL,1,1,'2026-09-29 09:47:06',150.00),(99,NULL,1,1,'2026-09-29 09:47:06',150.00),(100,NULL,1,1,'2026-09-29 09:47:06',150.00),(101,NULL,1,1,'2026-09-29 09:47:06',150.00),(102,NULL,1,1,'2026-09-29 09:47:06',150.00),(103,NULL,1,1,'2026-09-29 09:47:06',150.00),(104,NULL,1,1,'2026-09-29 09:47:06',150.00),(105,NULL,1,1,'2026-09-29 09:47:06',150.00),(106,NULL,1,1,'2026-09-29 09:47:06',150.00),(107,NULL,1,1,'2026-09-29 09:47:06',150.00),(108,NULL,2,1,'2026-09-30 08:39:53',180.00);
/*!40000 ALTER TABLE `pedidos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personal`
--

DROP TABLE IF EXISTS `personal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personal` (
  `id_personal` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `puesto` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telefono` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_contratacion` date DEFAULT NULL,
  `usuario` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rol` enum('administrador','caja','inventario','ayudante') COLLATE utf8mb4_unicode_ci DEFAULT 'caja',
  PRIMARY KEY (`id_personal`),
  UNIQUE KEY `usuario` (`usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personal`
--

LOCK TABLES `personal` WRITE;
/*!40000 ALTER TABLE `personal` DISABLE KEYS */;
INSERT INTO `personal` VALUES (1,'Juan Pérez Gómez','Cajero','8111112222',NULL,'jperez','1234','caja'),(2,'María López','Gerente','8111113333',NULL,'admin','admin','administrador'),(3,'Carlos Ramírez','Surtidor','8111114444',NULL,'cramirez','1234','caja'),(4,'Ana Torres','Cajera','8111115555',NULL,'atorres','1234','caja'),(5,'Luis González','Encargado Almacén','8111116666',NULL,'lgonzalez','1234','inventario'),(6,'Sofía Castillo','Atención','8111117777',NULL,'scastillo','1234','caja'),(7,'Pedro Morales','Repartidor','8111118888',NULL,'pmorales','1234','caja');
/*!40000 ALTER TABLE `personal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productos`
--

DROP TABLE IF EXISTS `productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `productos` (
  `id_producto` int NOT NULL AUTO_INCREMENT,
  `id_categoria` int DEFAULT NULL,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `unidad_medida` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'kg',
  `costo_compra` decimal(10,2) NOT NULL,
  `precio_venta` decimal(10,2) NOT NULL,
  `porcentaje_ganancia` decimal(10,2) GENERATED ALWAYS AS ((((`precio_venta` - `costo_compra`) / `costo_compra`) * 100)) STORED,
  `stock_actual` decimal(10,2) NOT NULL DEFAULT '0.00',
  `stock_minimo` decimal(10,2) NOT NULL,
  `stock_maximo` decimal(10,2) NOT NULL,
  `punto_reorden` decimal(10,2) NOT NULL,
  `ubicacion_almacen` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_producto`),
  KEY `id_categoria` (`id_categoria`),
  CONSTRAINT `productos_ibfk_1` FOREIGN KEY (`id_categoria`) REFERENCES `categorias_producto` (`id_categoria`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productos`
--

LOCK TABLES `productos` WRITE;
/*!40000 ALTER TABLE `productos` DISABLE KEYS */;
INSERT INTO `productos` (`id_producto`, `id_categoria`, `nombre`, `unidad_medida`, `costo_compra`, `precio_venta`, `stock_actual`, `stock_minimo`, `stock_maximo`, `punto_reorden`, `ubicacion_almacen`) VALUES (1,1,'Manzana Gala','kg',22.00,35.00,120.00,20.00,200.00,30.00,NULL),(2,1,'Plátano Tabasco','kg',12.00,22.00,150.00,30.00,250.00,40.00,NULL),(3,3,'Limón con Semilla','kg',18.00,28.00,130.00,25.00,220.00,35.00,NULL),(4,2,'Tomate Saladette','kg',14.00,24.00,140.00,30.00,250.00,40.00,NULL),(5,5,'Cilantro Fresco','manojo',4.00,8.00,90.00,20.00,150.00,25.00,NULL),(6,1,'Naranja Valencia','kg',10.00,18.00,200.00,40.00,300.00,50.00,NULL),(7,6,'Aguacate Hass','kg',45.00,75.00,58.00,15.00,100.00,20.00,NULL),(8,2,'Cebolla Blanca','kg',16.00,26.00,128.50,25.00,200.00,35.00,NULL),(9,4,'Papa Blanca','kg',18.00,28.00,160.00,30.00,250.00,40.00,NULL),(10,4,'Zanahoria','kg',10.00,18.00,140.00,25.00,220.00,35.00,NULL),(11,2,'Pepino Verde','kg',12.00,20.00,95.00,20.00,160.00,25.00,NULL),(12,5,'Lechuga Romana','pieza',10.00,18.00,60.00,12.00,100.00,18.00,NULL),(13,5,'Espinaca Fresca','manojo',8.00,15.00,50.00,10.00,80.00,15.00,NULL),(14,1,'Papaya Maradol','kg',18.00,30.00,75.00,15.00,130.00,22.00,NULL),(15,1,'Sandía Crimson','kg',8.00,15.00,180.00,40.00,300.00,50.00,NULL),(16,1,'Piña Miel','kg',16.00,28.00,70.00,15.00,120.00,20.00,NULL),(17,1,'Mango Ataulfo','kg',25.00,42.00,90.00,20.00,160.00,25.00,NULL),(18,1,'Fresa','charola',30.00,50.00,65.00,15.00,110.00,20.00,NULL),(19,2,'Chile Serrano','kg',25.00,40.00,70.00,15.00,120.00,20.00,NULL),(20,6,'Ajo Blanco','kg',55.00,90.00,38.00,10.00,70.00,15.00,NULL);
/*!40000 ALTER TABLE `productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proveedores`
--

DROP TABLE IF EXISTS `proveedores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proveedores` (
  `id_proveedor` int NOT NULL AUTO_INCREMENT,
  `nombre_empresa` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `contacto` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telefono` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_proveedor`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proveedores`
--

LOCK TABLES `proveedores` WRITE;
/*!40000 ALTER TABLE `proveedores` DISABLE KEYS */;
INSERT INTO `proveedores` VALUES (1,'Frutas y Hortalizas del Valle','Carlos Mendoza','555-0001'),(2,'AgroVerduras del Norte','María Pérez','555-0002'),(3,'Granjas Unidas S.A.','Juan Gómez','555-0003'),(4,'Distribuidora del Centro','Ana Torres','555-0004'),(5,'Huertos del Sur','Luis Ramírez','555-0005');
/*!40000 ALTER TABLE `proveedores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipo_pago`
--

DROP TABLE IF EXISTS `tipo_pago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipo_pago` (
  `id_tipo_pago` int NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_tipo_pago`),
  UNIQUE KEY `descripcion` (`descripcion`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipo_pago`
--

LOCK TABLES `tipo_pago` WRITE;
/*!40000 ALTER TABLE `tipo_pago` DISABLE KEYS */;
INSERT INTO `tipo_pago` VALUES (5,'Código QR CoDi'),(1,'Efectivo'),(3,'Tarjeta de Crédito'),(2,'Tarjeta de Débito'),(4,'Transferencia SPEI');
/*!40000 ALTER TABLE `tipo_pago` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-30  9:13:26
