CREATE DATABASE  IF NOT EXISTS `myguest` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_bin */;
USE `myguest`;
-- MySQL dump 10.13  Distrib 5.7.12, for linux-glibc2.5 (x86_64)
--
-- Host: localhost    Database: myguest
-- ------------------------------------------------------
-- Server version	5.5.5-10.1.22-MariaDB-

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `guest_book`
--

DROP TABLE IF EXISTS `guest_book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `guest_book` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `text` text COLLATE utf8_bin NOT NULL,
  `ctime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_guest_book_1_idx` (`user_id`),
  CONSTRAINT `fk_guest_book_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guest_book`
--

LOCK TABLES `guest_book` WRITE;
/*!40000 ALTER TABLE `guest_book` DISABLE KEYS */;
INSERT INTO `guest_book` VALUES (1,1,'qqq','2017-05-12 12:36:29'),(2,1,'fff','2017-05-12 12:36:38'),(3,1,'sdgdhrfhjtrj','2017-05-12 12:52:53'),(4,1,'qeqrwrw','2017-05-12 12:53:09'),(5,1,'fq3ft3','2017-05-12 12:53:13'),(6,1,'wqreqt3e','2017-05-12 12:53:16'),(7,1,'wqrqetet','2017-05-12 12:53:20'),(8,1,'rwqrwqt','2017-05-12 12:53:25'),(9,1,'     guestbook.com','2017-05-12 12:53:54');
/*!40000 ALTER TABLE `guest_book` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-05-12 16:12:22
