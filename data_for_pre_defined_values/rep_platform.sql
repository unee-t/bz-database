/*
SQLyog Ultimate v13.1.2 (64 bit)
MySQL - 5.7.12-log : Database - bugzilla
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
/*Data for the table `rep_platform` */

insert  into `rep_platform`(`id`,`value`,`sortkey`,`isactive`,`visibility_value_id`) values 
(1,'---',0,1,NULL),
(2,'Repair',9999,0,NULL),
(3,'Maintenance',9999,0,NULL),
(4,'Housekeeping',40,1,NULL),
(5,'Devices',9999,0,NULL),
(6,'Renovation',9999,0,NULL),
(7,'Projects',50,1,NULL),
(8,'Extra Service',45,1,NULL),
(9,'Utilities',60,1,NULL),
(10,'Other',55,1,NULL),
(11,'Furnitures/Fixtures',5,1,NULL),
(12,'Appliances/Equipment',10,1,NULL),
(13,'Electrical',15,1,NULL),
(14,'Plumbing',20,1,NULL),
(15,'Aircon/Heating',25,1,NULL),
(16,'Structural',30,1,NULL),
(17,'Landscape',35,1,NULL);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
