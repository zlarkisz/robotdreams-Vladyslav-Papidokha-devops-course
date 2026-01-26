-- MySQL dump 10.13  Distrib 8.0.45, for Linux (aarch64)
--
-- Host: localhost    Database: SchoolDB
-- ------------------------------------------------------
-- Server version	8.0.45

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Children`
--

DROP TABLE IF EXISTS `Children`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Children` (
  `child_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `birth_date` date NOT NULL,
  `year_of_entry` int NOT NULL,
  `age` int NOT NULL,
  `institution_id` int NOT NULL,
  `class_id` int NOT NULL,
  PRIMARY KEY (`child_id`),
  KEY `institution_id` (`institution_id`),
  KEY `class_id` (`class_id`),
  CONSTRAINT `Children_ibfk_1` FOREIGN KEY (`institution_id`) REFERENCES `Institutions` (`institution_id`),
  CONSTRAINT `Children_ibfk_2` FOREIGN KEY (`class_id`) REFERENCES `Classes` (`class_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Children`
--

LOCK TABLES `Children` WRITE;
/*!40000 ALTER TABLE `Children` DISABLE KEYS */;
INSERT INTO `Children` VALUES (1,'Ivan','Petrenko','2017-03-15',2023,7,1,1),(2,'Maria','Kovalenko','2012-07-22',2018,12,1,2),(3,'Oleksandr','Shevchenko','2014-01-10',2020,10,2,3),(4,'Anna','Bondarenko','2020-11-05',2024,4,3,4),(5,'Dmytro','Melnyk','2009-05-30',2015,15,4,5),(6,'Sofia','Kravchuk','2011-09-18',2017,13,4,6);
/*!40000 ALTER TABLE `Children` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Classes`
--

DROP TABLE IF EXISTS `Classes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Classes` (
  `class_id` int NOT NULL AUTO_INCREMENT,
  `class_name` varchar(50) NOT NULL,
  `institution_id` int NOT NULL,
  `direction` enum('Mathematics','Biology and Chemistry','Language Studies') NOT NULL,
  PRIMARY KEY (`class_id`),
  KEY `institution_id` (`institution_id`),
  CONSTRAINT `Classes_ibfk_1` FOREIGN KEY (`institution_id`) REFERENCES `Institutions` (`institution_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Classes`
--

LOCK TABLES `Classes` WRITE;
/*!40000 ALTER TABLE `Classes` DISABLE KEYS */;
INSERT INTO `Classes` VALUES (1,'1-A',1,'Mathematics'),(2,'5-B',1,'Language Studies'),(3,'3-C',2,'Biology and Chemistry'),(4,'Bunnies Group',3,'Language Studies'),(5,'10-A',4,'Mathematics'),(6,'7-B',4,'Biology and Chemistry');
/*!40000 ALTER TABLE `Classes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Institutions`
--

DROP TABLE IF EXISTS `Institutions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Institutions` (
  `institution_id` int NOT NULL AUTO_INCREMENT,
  `institution_name` varchar(100) NOT NULL,
  `institution_type` enum('School','Kindergarten') NOT NULL,
  `address` varchar(255) NOT NULL,
  PRIMARY KEY (`institution_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Institutions`
--

LOCK TABLES `Institutions` WRITE;
/*!40000 ALTER TABLE `Institutions` DISABLE KEYS */;
INSERT INTO `Institutions` VALUES (1,'School No.15','School','10 Main Street, Kyiv'),(2,'Intellect Lyceum','School','25 Science Ave, Lviv'),(3,'Sunshine Kindergarten','Kindergarten','5 Park Road, Odesa'),(4,'Gymnasium No.1','School','100 Victory Blvd, Kharkiv');
/*!40000 ALTER TABLE `Institutions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Parents`
--

DROP TABLE IF EXISTS `Parents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Parents` (
  `parent_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `child_id` int NOT NULL,
  `tuition_fee` decimal(10,2) NOT NULL,
  PRIMARY KEY (`parent_id`),
  KEY `child_id` (`child_id`),
  CONSTRAINT `Parents_ibfk_1` FOREIGN KEY (`child_id`) REFERENCES `Children` (`child_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Parents`
--

LOCK TABLES `Parents` WRITE;
/*!40000 ALTER TABLE `Parents` DISABLE KEYS */;
INSERT INTO `Parents` VALUES (1,'Petro','Petrenko',1,5000.00),(2,'Olena','Petrenko',1,5000.00),(3,'Viktor','Kovalenko',2,4500.00),(4,'Natalia','Shevchenko',3,6000.00),(5,'Andriy','Bondarenko',4,3500.00),(6,'Iryna','Melnyk',5,7000.00),(7,'Serhiy','Kravchuk',6,7000.00);
/*!40000 ALTER TABLE `Parents` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-01-26 16:50:48
