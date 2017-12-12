/*
SQLyog Ultimate v12.4.3 (64 bit)
MySQL - 10.2.9-MariaDB-10.2.9+maria~jessie : Database - bugzilla
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`bugzilla` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `bugzilla`;

/*Table structure for table `attach_data` */

DROP TABLE IF EXISTS `attach_data`;

CREATE TABLE `attach_data` (
  `id` mediumint(9) NOT NULL,
  `thedata` longblob NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_attach_data_id_attachments_attach_id` FOREIGN KEY (`id`) REFERENCES `attachments` (`attach_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 MAX_ROWS=100000 AVG_ROW_LENGTH=1000000;

/*Data for the table `attach_data` */

/*Table structure for table `attachments` */

DROP TABLE IF EXISTS `attachments`;

CREATE TABLE `attachments` (
  `attach_id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `bug_id` mediumint(9) NOT NULL,
  `creation_ts` datetime NOT NULL,
  `modification_time` datetime NOT NULL,
  `description` tinytext NOT NULL,
  `mimetype` tinytext NOT NULL,
  `ispatch` tinyint(4) NOT NULL DEFAULT 0,
  `filename` varchar(255) NOT NULL,
  `submitter_id` mediumint(9) NOT NULL,
  `isobsolete` tinyint(4) NOT NULL DEFAULT 0,
  `isprivate` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`attach_id`),
  KEY `attachments_bug_id_idx` (`bug_id`),
  KEY `attachments_creation_ts_idx` (`creation_ts`),
  KEY `attachments_modification_time_idx` (`modification_time`),
  KEY `attachments_submitter_id_idx` (`submitter_id`,`bug_id`),
  CONSTRAINT `fk_attachments_bug_id_bugs_bug_id` FOREIGN KEY (`bug_id`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_attachments_submitter_id_profiles_userid` FOREIGN KEY (`submitter_id`) REFERENCES `profiles` (`userid`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `attachments` */

/*Table structure for table `audit_log` */

DROP TABLE IF EXISTS `audit_log`;

CREATE TABLE `audit_log` (
  `user_id` mediumint(9) DEFAULT NULL,
  `class` varchar(255) NOT NULL,
  `object_id` int(11) NOT NULL,
  `field` varchar(64) NOT NULL,
  `removed` mediumtext DEFAULT NULL,
  `added` mediumtext DEFAULT NULL,
  `at_time` datetime NOT NULL,
  KEY `audit_log_class_idx` (`class`,`at_time`),
  KEY `fk_audit_log_user_id_profiles_userid` (`user_id`),
  CONSTRAINT `fk_audit_log_user_id_profiles_userid` FOREIGN KEY (`user_id`) REFERENCES `profiles` (`userid`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `audit_log` */

insert  into `audit_log`(`user_id`,`class`,`object_id`,`field`,`removed`,`added`,`at_time`) values 
(NULL,'Bugzilla::Field',1,'__create__',NULL,'bug_id','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',2,'__create__',NULL,'short_desc','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',3,'__create__',NULL,'classification','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',4,'__create__',NULL,'product','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',5,'__create__',NULL,'version','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',6,'__create__',NULL,'rep_platform','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',7,'__create__',NULL,'bug_file_loc','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',8,'__create__',NULL,'op_sys','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',9,'__create__',NULL,'bug_status','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',10,'__create__',NULL,'status_whiteboard','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',11,'__create__',NULL,'keywords','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',12,'__create__',NULL,'resolution','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',13,'__create__',NULL,'bug_severity','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',14,'__create__',NULL,'priority','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',15,'__create__',NULL,'component','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',16,'__create__',NULL,'assigned_to','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',17,'__create__',NULL,'reporter','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',18,'__create__',NULL,'qa_contact','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',19,'__create__',NULL,'assigned_to_realname','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',20,'__create__',NULL,'reporter_realname','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',21,'__create__',NULL,'qa_contact_realname','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',22,'__create__',NULL,'cc','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',23,'__create__',NULL,'dependson','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',24,'__create__',NULL,'blocked','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',25,'__create__',NULL,'attachments.description','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',26,'__create__',NULL,'attachments.filename','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',27,'__create__',NULL,'attachments.mimetype','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',28,'__create__',NULL,'attachments.ispatch','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',29,'__create__',NULL,'attachments.isobsolete','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',30,'__create__',NULL,'attachments.isprivate','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',31,'__create__',NULL,'attachments.submitter','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',32,'__create__',NULL,'target_milestone','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',33,'__create__',NULL,'creation_ts','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',34,'__create__',NULL,'delta_ts','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',35,'__create__',NULL,'longdesc','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',36,'__create__',NULL,'longdescs.isprivate','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',37,'__create__',NULL,'longdescs.count','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',38,'__create__',NULL,'alias','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',39,'__create__',NULL,'everconfirmed','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',40,'__create__',NULL,'reporter_accessible','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',41,'__create__',NULL,'cclist_accessible','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',42,'__create__',NULL,'bug_group','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',43,'__create__',NULL,'estimated_time','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',44,'__create__',NULL,'remaining_time','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',45,'__create__',NULL,'deadline','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',46,'__create__',NULL,'commenter','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',47,'__create__',NULL,'flagtypes.name','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',48,'__create__',NULL,'requestees.login_name','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',49,'__create__',NULL,'setters.login_name','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',50,'__create__',NULL,'work_time','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',51,'__create__',NULL,'percentage_complete','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',52,'__create__',NULL,'content','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',53,'__create__',NULL,'attach_data.thedata','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',54,'__create__',NULL,'owner_idle_time','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',55,'__create__',NULL,'see_also','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',56,'__create__',NULL,'tag','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',57,'__create__',NULL,'last_visit_ts','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',58,'__create__',NULL,'comment_tag','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Field',59,'__create__',NULL,'days_elapsed','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Classification',1,'__create__',NULL,'Unclassified','2017-10-26 04:29:45'),
(NULL,'Bugzilla::Group',1,'__create__',NULL,'admin','2017-10-26 04:29:48'),
(NULL,'Bugzilla::Group',2,'__create__',NULL,'tweakparams','2017-10-26 04:29:48'),
(NULL,'Bugzilla::Group',3,'__create__',NULL,'editusers','2017-10-26 04:29:48'),
(NULL,'Bugzilla::Group',4,'__create__',NULL,'creategroups','2017-10-26 04:29:48'),
(NULL,'Bugzilla::Group',5,'__create__',NULL,'editclassifications','2017-10-26 04:29:48'),
(NULL,'Bugzilla::Group',6,'__create__',NULL,'editcomponents','2017-10-26 04:29:48'),
(NULL,'Bugzilla::Group',7,'__create__',NULL,'editkeywords','2017-10-26 04:29:48'),
(NULL,'Bugzilla::Group',8,'__create__',NULL,'editbugs','2017-10-26 04:29:48'),
(NULL,'Bugzilla::Group',9,'__create__',NULL,'canconfirm','2017-10-26 04:29:48'),
(NULL,'Bugzilla::Group',10,'__create__',NULL,'bz_canusewhineatothers','2017-10-26 04:29:48'),
(NULL,'Bugzilla::Group',11,'__create__',NULL,'bz_canusewhines','2017-10-26 04:29:48'),
(NULL,'Bugzilla::Group',12,'__create__',NULL,'bz_sudoers','2017-10-26 04:29:48'),
(NULL,'Bugzilla::Group',13,'__create__',NULL,'bz_sudo_protect','2017-10-26 04:29:48'),
(NULL,'Bugzilla::Group',14,'__create__',NULL,'bz_quip_moderators','2017-10-26 04:29:48'),
(NULL,'Bugzilla::User',1,'__create__',NULL,'contributor@example.com','2017-10-26 04:29:48'),
(NULL,'Bugzilla::Product',1,'__create__',NULL,'TestProduct','2017-10-26 04:29:48'),
(NULL,'Bugzilla::Version',1,'__create__',NULL,'unspecified','2017-10-26 04:29:48'),
(NULL,'Bugzilla::Milestone',1,'__create__',NULL,'---','2017-10-26 04:29:48'),
(NULL,'Bugzilla::Component',1,'__create__',NULL,'TestComponent','2017-10-26 04:29:48'),
(1,'Bugzilla::Field',60,'__create__',NULL,'cf_ipi_clust_4_status_in_progress','2017-10-26 07:38:52'),
(1,'Bugzilla::Field',61,'__create__',NULL,'cf_ipi_clust_4_status_standby','2017-10-26 07:39:41'),
(1,'Bugzilla::Field',62,'__create__',NULL,'cf_ipi_clust_2_room','2017-10-26 07:40:37'),
(1,'Bugzilla::Field',63,'__create__',NULL,'cf_ipi_clust_6_claim_type','2017-10-26 07:42:07'),
(1,'Bugzilla::Field',64,'__create__',NULL,'cf_ipi_clust_1_solution','2017-10-26 07:46:20'),
(1,'Bugzilla::Field',65,'__create__',NULL,'cf_ipi_clust_1_next_step','2017-10-26 07:47:01'),
(1,'Bugzilla::Field',66,'__create__',NULL,'cf_ipi_clust_1_next_step_date','2017-10-26 07:48:15'),
(1,'Bugzilla::Field',67,'__create__',NULL,'cf_ipi_clust_3_field_action','2017-10-26 07:51:11'),
(1,'Bugzilla::Field',68,'__create__',NULL,'cf_ipi_clust_3_field_action_from','2017-10-26 07:52:16'),
(1,'Bugzilla::Field',68,'sortkey','3227','3250','2017-10-26 07:52:30'),
(1,'Bugzilla::Field',69,'__create__',NULL,'cf_ipi_clust_3_field_action_until','2017-10-26 07:53:11'),
(1,'Bugzilla::Field',70,'__create__',NULL,'cf_ipi_clust_3_action_type','2017-10-26 07:55:10'),
(1,'Bugzilla::Field',71,'__create__',NULL,'cf_ipi_clust_3_nber_field_visits','2017-10-26 07:58:57'),
(1,'Bugzilla::Field',72,'__create__',NULL,'cf_ipi_clust_3_roadbook_for','2017-10-26 11:55:25'),
(1,'Bugzilla::Field',73,'__create__',NULL,'cf_ipi_clust_5_approved_budget','2017-10-26 12:04:03'),
(1,'Bugzilla::Field',74,'__create__',NULL,'cf_ipi_clust_5_budget','2017-10-26 12:05:49'),
(1,'Bugzilla::Field',74,'sortkey','3255','3260','2017-10-26 12:06:30'),
(1,'Bugzilla::Field',74,'sortkey','3260','3265','2017-10-26 12:06:37'),
(1,'Bugzilla::Field',75,'__create__',NULL,'cf_ipi_clust_8_contract_id','2017-10-26 12:12:07'),
(1,'Bugzilla::Field',75,'description','Contract ID','Customer ID','2017-10-26 12:13:32'),
(1,'Bugzilla::Field',76,'__create__',NULL,'cf_ipi_clust_9_acct_action','2017-10-26 12:18:07'),
(1,'Bugzilla::Field',77,'__create__',NULL,'cf_ipi_clust_9_inv_ll','2017-10-26 12:19:44'),
(1,'Bugzilla::Field',76,'sortkey','3325','3300','2017-10-26 12:20:16'),
(1,'Bugzilla::Field',78,'__create__',NULL,'cf_ipi_clust_9_inv_det_ll','2017-10-26 12:20:51'),
(1,'Bugzilla::Field',79,'__create__',NULL,'cf_ipi_clust_9_inv_cust','2017-10-26 12:21:36'),
(1,'Bugzilla::Field',80,'__create__',NULL,'cf_ipi_clust_9_inv_det_cust','2017-10-26 12:22:07'),
(1,'Bugzilla::Field',81,'__create__',NULL,'cf_ipi_clust_5_spe_action_purchase_list','2017-10-26 12:26:20'),
(1,'Bugzilla::Field',81,'sortkey','3245','9900','2017-10-26 12:26:46'),
(1,'Bugzilla::Field',82,'__create__',NULL,'cf_ipi_clust_5_approval_for','2017-10-26 12:28:50'),
(1,'Bugzilla::Field',82,'obsolete','0','1','2017-10-26 12:29:20'),
(1,'Bugzilla::Field',82,'__remove__','cf_ipi_clust_5_approval_for',NULL,'2017-10-26 12:29:31'),
(1,'Bugzilla::Field',83,'__create__',NULL,'cf_ipi_clust_5_spe_approval_for','2017-10-26 12:30:51'),
(1,'Bugzilla::Field',84,'__create__',NULL,'cf_ipi_clust_5_spe_approval_comment','2017-10-26 12:32:07'),
(1,'Bugzilla::Field',85,'__create__',NULL,'cf_ipi_clust_5_spe_contractor','2017-10-26 12:34:34'),
(1,'Bugzilla::Field',86,'__create__',NULL,'cf_ipi_clust_5_contractor','2017-10-26 20:57:34'),
(1,'Bugzilla::Field',86,'obsolete','0','1','2017-10-26 20:58:21'),
(1,'Bugzilla::Field',86,'__remove__','cf_ipi_clust_5_contractor',NULL,'2017-10-26 20:58:26'),
(1,'Bugzilla::Field',87,'__create__',NULL,'cf_ipi_clust_5_spe_purchase_cost','2017-10-26 21:04:48'),
(1,'Bugzilla::Field',88,'__create__',NULL,'cf_ipi_clust_7_spe_bill_number','2017-10-26 21:07:01'),
(1,'Bugzilla::Field',89,'__create__',NULL,'cf_ipi_clust_7_spe_payment_type','2017-10-26 21:08:17'),
(1,'Bugzilla::Field',90,'__create__',NULL,'cf_ipi_clust_7_spe_contractor_payment','2017-10-26 21:09:57'),
(1,'Bugzilla::Field',91,'__create__',NULL,'cf_ipi_clust_8_spe_customer','2017-10-26 21:11:41'),
(1,'Bugzilla::Field',1,'description','Case #','Bug #','2017-10-26 22:36:07'),
(1,'Bugzilla::Field',4,'description','Unit','Product','2017-10-26 22:36:07'),
(1,'Bugzilla::Field',6,'description','Case Category','Platform','2017-10-26 22:36:07'),
(1,'Bugzilla::Field',8,'description','Source','OS/Version','2017-10-26 22:36:07'),
(1,'Bugzilla::Field',15,'description','Role','Component','2017-10-26 22:36:07'),
(1,'Bugzilla::Field',63,'value_field_id',NULL,'6','2017-10-26 22:44:02'),
(1,'Bugzilla::Field',61,'visibility_field_id',NULL,'9','2017-10-26 22:50:09'),
(1,'Bugzilla::Field',92,'__create__',NULL,'cf_specific_for','2017-10-26 23:00:34'),
(1,'Bugzilla::Field::Choice::cf_specific_for',2,'__create__',NULL,'LMB - #1','2017-10-26 23:01:14'),
(1,'Bugzilla::Field',81,'sortkey','9900','9905','2017-10-26 23:02:03'),
(1,'Bugzilla::Field',81,'visibility_field_id',NULL,'92','2017-10-26 23:02:03'),
(1,'Bugzilla::Field',83,'visibility_field_id',NULL,'92','2017-10-26 23:03:49'),
(1,'Bugzilla::Field',84,'visibility_field_id',NULL,'92','2017-10-26 23:04:05'),
(1,'Bugzilla::Field',85,'visibility_field_id',NULL,'92','2017-10-26 23:04:37'),
(1,'Bugzilla::Field',87,'visibility_field_id',NULL,'92','2017-10-26 23:04:46'),
(1,'Bugzilla::Field',88,'visibility_field_id',NULL,'92','2017-10-26 23:04:54'),
(1,'Bugzilla::Field',89,'visibility_field_id',NULL,'92','2017-10-26 23:05:05'),
(1,'Bugzilla::Field',90,'visibility_field_id',NULL,'92','2017-10-26 23:05:14'),
(1,'Bugzilla::Field',91,'visibility_field_id',NULL,'92','2017-10-26 23:05:42'),
(1,'Bugzilla::Field',76,'visibility_field_id',NULL,'92','2017-10-26 23:06:17'),
(1,'Bugzilla::Field',77,'visibility_field_id',NULL,'92','2017-10-26 23:06:27'),
(1,'Bugzilla::Field',78,'visibility_field_id',NULL,'92','2017-10-26 23:06:37'),
(1,'Bugzilla::Field',79,'visibility_field_id',NULL,'92','2017-10-26 23:06:45'),
(1,'Bugzilla::Field',80,'visibility_field_id',NULL,'92','2017-10-26 23:06:52'),
(NULL,'Bugzilla::Field',1,'description','Case #','Bug #','2017-10-27 00:34:42'),
(NULL,'Bugzilla::Field',3,'description','Unit Group','Classification','2017-10-27 00:34:42'),
(NULL,'Bugzilla::Field',4,'description','Unit','Product','2017-10-27 00:34:42'),
(NULL,'Bugzilla::Field',6,'description','Case Category','Platform','2017-10-27 00:34:42'),
(NULL,'Bugzilla::Field',8,'description','Source','OS/Version','2017-10-27 00:34:42'),
(NULL,'Bugzilla::Field',15,'description','Role','Component','2017-10-27 00:34:42');

/*Table structure for table `bug_cf_ipi_clust_3_roadbook_for` */

DROP TABLE IF EXISTS `bug_cf_ipi_clust_3_roadbook_for`;

CREATE TABLE `bug_cf_ipi_clust_3_roadbook_for` (
  `bug_id` mediumint(9) NOT NULL,
  `value` varchar(64) NOT NULL,
  UNIQUE KEY `bug_cf_ipi_clust_3_roadbook_for_bug_id_idx` (`bug_id`,`value`),
  KEY `fk_0da76aa50ea9cec77ea8e213c8655f99` (`value`),
  CONSTRAINT `fk_0da76aa50ea9cec77ea8e213c8655f99` FOREIGN KEY (`value`) REFERENCES `cf_ipi_clust_3_roadbook_for` (`value`) ON UPDATE CASCADE,
  CONSTRAINT `fk_bug_cf_ipi_clust_3_roadbook_for_bug_id_bugs_bug_id` FOREIGN KEY (`bug_id`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `bug_cf_ipi_clust_3_roadbook_for` */

/*Table structure for table `bug_cf_ipi_clust_9_acct_action` */

DROP TABLE IF EXISTS `bug_cf_ipi_clust_9_acct_action`;

CREATE TABLE `bug_cf_ipi_clust_9_acct_action` (
  `bug_id` mediumint(9) NOT NULL,
  `value` varchar(64) NOT NULL,
  UNIQUE KEY `bug_cf_ipi_clust_9_acct_action_bug_id_idx` (`bug_id`,`value`),
  KEY `fk_e5fc7a4f159b990bfcdfcaf844d0728b` (`value`),
  CONSTRAINT `fk_bug_cf_ipi_clust_9_acct_action_bug_id_bugs_bug_id` FOREIGN KEY (`bug_id`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_e5fc7a4f159b990bfcdfcaf844d0728b` FOREIGN KEY (`value`) REFERENCES `cf_ipi_clust_9_acct_action` (`value`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `bug_cf_ipi_clust_9_acct_action` */

/*Table structure for table `bug_group_map` */

DROP TABLE IF EXISTS `bug_group_map`;

CREATE TABLE `bug_group_map` (
  `bug_id` mediumint(9) NOT NULL,
  `group_id` mediumint(9) NOT NULL,
  UNIQUE KEY `bug_group_map_bug_id_idx` (`bug_id`,`group_id`),
  KEY `bug_group_map_group_id_idx` (`group_id`),
  CONSTRAINT `fk_bug_group_map_bug_id_bugs_bug_id` FOREIGN KEY (`bug_id`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_bug_group_map_group_id_groups_id` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `bug_group_map` */

/*Table structure for table `bug_see_also` */

DROP TABLE IF EXISTS `bug_see_also`;

CREATE TABLE `bug_see_also` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `bug_id` mediumint(9) NOT NULL,
  `value` varchar(255) NOT NULL,
  `class` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `bug_see_also_bug_id_idx` (`bug_id`,`value`),
  CONSTRAINT `fk_bug_see_also_bug_id_bugs_bug_id` FOREIGN KEY (`bug_id`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `bug_see_also` */

/*Table structure for table `bug_severity` */

DROP TABLE IF EXISTS `bug_severity`;

CREATE TABLE `bug_severity` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `value` varchar(64) NOT NULL,
  `sortkey` smallint(6) NOT NULL DEFAULT 0,
  `isactive` tinyint(4) NOT NULL DEFAULT 1,
  `visibility_value_id` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `bug_severity_value_idx` (`value`),
  KEY `bug_severity_sortkey_idx` (`sortkey`,`value`),
  KEY `bug_severity_visibility_value_id_idx` (`visibility_value_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

/*Data for the table `bug_severity` */

insert  into `bug_severity`(`id`,`value`,`sortkey`,`isactive`,`visibility_value_id`) values 
(1,'DEAL BREAKER!',100,1,NULL),
(2,'critical',200,1,NULL),
(3,'major',300,1,NULL),
(4,'normal',400,1,NULL),
(5,'minor',500,1,NULL);

/*Table structure for table `bug_status` */

DROP TABLE IF EXISTS `bug_status`;

CREATE TABLE `bug_status` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `value` varchar(64) NOT NULL,
  `sortkey` smallint(6) NOT NULL DEFAULT 0,
  `isactive` tinyint(4) NOT NULL DEFAULT 1,
  `visibility_value_id` smallint(6) DEFAULT NULL,
  `is_open` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `bug_status_value_idx` (`value`),
  KEY `bug_status_sortkey_idx` (`sortkey`,`value`),
  KEY `bug_status_visibility_value_id_idx` (`visibility_value_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

/*Data for the table `bug_status` */

insert  into `bug_status`(`id`,`value`,`sortkey`,`isactive`,`visibility_value_id`,`is_open`) values 
(1,'UNCONFIRMED',10,1,NULL,1),
(2,'CONFIRMED',20,1,NULL,1),
(3,'IN_PROGRESS',30,1,NULL,1),
(4,'RESOLVED',60,1,NULL,0),
(5,'VERIFIED',70,1,NULL,0),
(6,'REOPENED',40,1,NULL,1),
(7,'STAND BY',50,1,NULL,1),
(8,'CLOSED',80,1,NULL,0);

/*Table structure for table `bug_tag` */

DROP TABLE IF EXISTS `bug_tag`;

CREATE TABLE `bug_tag` (
  `bug_id` mediumint(9) NOT NULL,
  `tag_id` mediumint(9) NOT NULL,
  UNIQUE KEY `bug_tag_bug_id_idx` (`bug_id`,`tag_id`),
  KEY `fk_bug_tag_tag_id_tag_id` (`tag_id`),
  CONSTRAINT `fk_bug_tag_bug_id_bugs_bug_id` FOREIGN KEY (`bug_id`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_bug_tag_tag_id_tag_id` FOREIGN KEY (`tag_id`) REFERENCES `tag` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `bug_tag` */

/*Table structure for table `bug_user_last_visit` */

DROP TABLE IF EXISTS `bug_user_last_visit`;

CREATE TABLE `bug_user_last_visit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` mediumint(9) NOT NULL,
  `bug_id` mediumint(9) NOT NULL,
  `last_visit_ts` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `bug_user_last_visit_idx` (`user_id`,`bug_id`),
  KEY `bug_user_last_visit_last_visit_ts_idx` (`last_visit_ts`),
  KEY `fk_bug_user_last_visit_bug_id_bugs_bug_id` (`bug_id`),
  CONSTRAINT `fk_bug_user_last_visit_bug_id_bugs_bug_id` FOREIGN KEY (`bug_id`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_bug_user_last_visit_user_id_profiles_userid` FOREIGN KEY (`user_id`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `bug_user_last_visit` */

/*Table structure for table `bugs` */

DROP TABLE IF EXISTS `bugs`;

CREATE TABLE `bugs` (
  `bug_id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `assigned_to` mediumint(9) NOT NULL,
  `bug_file_loc` mediumtext NOT NULL DEFAULT '',
  `bug_severity` varchar(64) NOT NULL,
  `bug_status` varchar(64) NOT NULL,
  `creation_ts` datetime DEFAULT NULL,
  `delta_ts` datetime NOT NULL,
  `short_desc` varchar(255) NOT NULL,
  `op_sys` varchar(64) NOT NULL,
  `priority` varchar(64) NOT NULL,
  `product_id` smallint(6) NOT NULL,
  `rep_platform` varchar(64) NOT NULL,
  `reporter` mediumint(9) NOT NULL,
  `version` varchar(64) NOT NULL,
  `component_id` mediumint(9) NOT NULL,
  `resolution` varchar(64) NOT NULL DEFAULT '',
  `target_milestone` varchar(64) NOT NULL DEFAULT '---',
  `qa_contact` mediumint(9) DEFAULT NULL,
  `status_whiteboard` mediumtext NOT NULL DEFAULT '',
  `lastdiffed` datetime DEFAULT NULL,
  `everconfirmed` tinyint(4) NOT NULL,
  `reporter_accessible` tinyint(4) NOT NULL DEFAULT 1,
  `cclist_accessible` tinyint(4) NOT NULL DEFAULT 1,
  `estimated_time` decimal(7,2) NOT NULL DEFAULT 0.00,
  `remaining_time` decimal(7,2) NOT NULL DEFAULT 0.00,
  `deadline` datetime DEFAULT NULL,
  `cf_ipi_clust_4_status_in_progress` varchar(64) NOT NULL DEFAULT '---',
  `cf_ipi_clust_4_status_standby` varchar(64) NOT NULL DEFAULT '---',
  `cf_ipi_clust_2_room` varchar(255) NOT NULL DEFAULT '',
  `cf_ipi_clust_6_claim_type` varchar(64) NOT NULL DEFAULT '---',
  `cf_ipi_clust_1_solution` mediumtext NOT NULL DEFAULT '',
  `cf_ipi_clust_1_next_step` mediumtext NOT NULL DEFAULT '',
  `cf_ipi_clust_1_next_step_date` date DEFAULT NULL,
  `cf_ipi_clust_3_field_action` mediumtext NOT NULL DEFAULT '',
  `cf_ipi_clust_3_field_action_from` datetime DEFAULT NULL,
  `cf_ipi_clust_3_field_action_until` datetime DEFAULT NULL,
  `cf_ipi_clust_3_action_type` varchar(64) NOT NULL DEFAULT '---',
  `cf_ipi_clust_3_nber_field_visits` int(11) NOT NULL DEFAULT 0,
  `cf_ipi_clust_5_approved_budget` varchar(255) NOT NULL DEFAULT '',
  `cf_ipi_clust_5_budget` varchar(255) NOT NULL DEFAULT '',
  `cf_ipi_clust_8_contract_id` varchar(255) NOT NULL DEFAULT '',
  `cf_ipi_clust_9_inv_ll` varchar(255) NOT NULL DEFAULT '',
  `cf_ipi_clust_9_inv_det_ll` varchar(255) NOT NULL DEFAULT '',
  `cf_ipi_clust_9_inv_cust` mediumtext NOT NULL DEFAULT '',
  `cf_ipi_clust_9_inv_det_cust` mediumtext NOT NULL DEFAULT '',
  `cf_ipi_clust_5_spe_action_purchase_list` varchar(255) NOT NULL DEFAULT '',
  `cf_ipi_clust_5_spe_approval_for` mediumtext NOT NULL DEFAULT '',
  `cf_ipi_clust_5_spe_approval_comment` mediumtext NOT NULL DEFAULT '',
  `cf_ipi_clust_5_spe_contractor` mediumtext NOT NULL DEFAULT '',
  `cf_ipi_clust_5_spe_purchase_cost` varchar(255) NOT NULL DEFAULT '',
  `cf_ipi_clust_7_spe_bill_number` varchar(255) NOT NULL DEFAULT '',
  `cf_ipi_clust_7_spe_payment_type` varchar(64) NOT NULL DEFAULT '---',
  `cf_ipi_clust_7_spe_contractor_payment` mediumtext NOT NULL DEFAULT '',
  `cf_ipi_clust_8_spe_customer` varchar(255) NOT NULL DEFAULT '',
  `cf_specific_for` varchar(64) NOT NULL DEFAULT '---',
  PRIMARY KEY (`bug_id`),
  KEY `bugs_assigned_to_idx` (`assigned_to`),
  KEY `bugs_creation_ts_idx` (`creation_ts`),
  KEY `bugs_delta_ts_idx` (`delta_ts`),
  KEY `bugs_bug_severity_idx` (`bug_severity`),
  KEY `bugs_bug_status_idx` (`bug_status`),
  KEY `bugs_op_sys_idx` (`op_sys`),
  KEY `bugs_priority_idx` (`priority`),
  KEY `bugs_product_id_idx` (`product_id`),
  KEY `bugs_reporter_idx` (`reporter`),
  KEY `bugs_version_idx` (`version`),
  KEY `bugs_component_id_idx` (`component_id`),
  KEY `bugs_resolution_idx` (`resolution`),
  KEY `bugs_target_milestone_idx` (`target_milestone`),
  KEY `bugs_qa_contact_idx` (`qa_contact`),
  CONSTRAINT `fk_bugs_assigned_to_profiles_userid` FOREIGN KEY (`assigned_to`) REFERENCES `profiles` (`userid`) ON UPDATE CASCADE,
  CONSTRAINT `fk_bugs_component_id_components_id` FOREIGN KEY (`component_id`) REFERENCES `components` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_bugs_product_id_products_id` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_bugs_qa_contact_profiles_userid` FOREIGN KEY (`qa_contact`) REFERENCES `profiles` (`userid`) ON UPDATE CASCADE,
  CONSTRAINT `fk_bugs_reporter_profiles_userid` FOREIGN KEY (`reporter`) REFERENCES `profiles` (`userid`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `bugs` */

/*Table structure for table `bugs_activity` */

DROP TABLE IF EXISTS `bugs_activity`;

CREATE TABLE `bugs_activity` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bug_id` mediumint(9) NOT NULL,
  `attach_id` mediumint(9) DEFAULT NULL,
  `who` mediumint(9) NOT NULL,
  `bug_when` datetime NOT NULL,
  `fieldid` mediumint(9) NOT NULL,
  `added` varchar(255) DEFAULT NULL,
  `removed` varchar(255) DEFAULT NULL,
  `comment_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `bugs_activity_bug_id_idx` (`bug_id`),
  KEY `bugs_activity_who_idx` (`who`),
  KEY `bugs_activity_bug_when_idx` (`bug_when`),
  KEY `bugs_activity_fieldid_idx` (`fieldid`),
  KEY `bugs_activity_added_idx` (`added`),
  KEY `bugs_activity_removed_idx` (`removed`),
  KEY `fk_bugs_activity_comment_id_longdescs_comment_id` (`comment_id`),
  KEY `fk_bugs_activity_attach_id_attachments_attach_id` (`attach_id`),
  CONSTRAINT `fk_bugs_activity_attach_id_attachments_attach_id` FOREIGN KEY (`attach_id`) REFERENCES `attachments` (`attach_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_bugs_activity_bug_id_bugs_bug_id` FOREIGN KEY (`bug_id`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_bugs_activity_comment_id_longdescs_comment_id` FOREIGN KEY (`comment_id`) REFERENCES `longdescs` (`comment_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_bugs_activity_fieldid_fielddefs_id` FOREIGN KEY (`fieldid`) REFERENCES `fielddefs` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_bugs_activity_who_profiles_userid` FOREIGN KEY (`who`) REFERENCES `profiles` (`userid`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `bugs_activity` */

/*Table structure for table `bugs_aliases` */

DROP TABLE IF EXISTS `bugs_aliases`;

CREATE TABLE `bugs_aliases` (
  `alias` varchar(40) NOT NULL,
  `bug_id` mediumint(9) DEFAULT NULL,
  UNIQUE KEY `bugs_aliases_alias_idx` (`alias`),
  KEY `bugs_aliases_bug_id_idx` (`bug_id`),
  CONSTRAINT `fk_bugs_aliases_bug_id_bugs_bug_id` FOREIGN KEY (`bug_id`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `bugs_aliases` */

/*Table structure for table `bugs_fulltext` */

DROP TABLE IF EXISTS `bugs_fulltext`;

CREATE TABLE `bugs_fulltext` (
  `bug_id` mediumint(9) NOT NULL,
  `short_desc` varchar(255) NOT NULL,
  `comments` mediumtext DEFAULT NULL,
  `comments_noprivate` mediumtext DEFAULT NULL,
  PRIMARY KEY (`bug_id`),
  FULLTEXT KEY `bugs_fulltext_short_desc_idx` (`short_desc`),
  FULLTEXT KEY `bugs_fulltext_comments_idx` (`comments`),
  FULLTEXT KEY `bugs_fulltext_comments_noprivate_idx` (`comments_noprivate`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `bugs_fulltext` */

/*Table structure for table `bz_schema` */

DROP TABLE IF EXISTS `bz_schema`;

CREATE TABLE `bz_schema` (
  `schema_data` longblob NOT NULL,
  `version` decimal(3,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `bz_schema` */

insert  into `bz_schema`(`schema_data`,`version`) values 
('$VAR1 = {\n          \'attach_data\' => {\n                             \'FIELDS\' => [\n                                           \'id\',\n                                           {\n                                             \'NOTNULL\' => 1,\n                                             \'PRIMARYKEY\' => 1,\n                                             \'REFERENCES\' => {\n                                                               \'COLUMN\' => \'attach_id\',\n                                                               \'DELETE\' => \'CASCADE\',\n                                                               \'TABLE\' => \'attachments\',\n                                                               \'created\' => 1\n                                                             },\n                                             \'TYPE\' => \'INT3\'\n                                           },\n                                           \'thedata\',\n                                           {\n                                             \'NOTNULL\' => 1,\n                                             \'TYPE\' => \'LONGBLOB\'\n                                           }\n                                         ]\n                           },\n          \'attachments\' => {\n                             \'FIELDS\' => [\n                                           \'attach_id\',\n                                           {\n                                             \'NOTNULL\' => 1,\n                                             \'PRIMARYKEY\' => 1,\n                                             \'TYPE\' => \'MEDIUMSERIAL\'\n                                           },\n                                           \'bug_id\',\n                                           {\n                                             \'NOTNULL\' => 1,\n                                             \'REFERENCES\' => {\n                                                               \'COLUMN\' => \'bug_id\',\n                                                               \'DELETE\' => \'CASCADE\',\n                                                               \'TABLE\' => \'bugs\',\n                                                               \'created\' => 1\n                                                             },\n                                             \'TYPE\' => \'INT3\'\n                                           },\n                                           \'creation_ts\',\n                                           {\n                                             \'NOTNULL\' => 1,\n                                             \'TYPE\' => \'DATETIME\'\n                                           },\n                                           \'modification_time\',\n                                           {\n                                             \'NOTNULL\' => 1,\n                                             \'TYPE\' => \'DATETIME\'\n                                           },\n                                           \'description\',\n                                           {\n                                             \'NOTNULL\' => 1,\n                                             \'TYPE\' => \'TINYTEXT\'\n                                           },\n                                           \'mimetype\',\n                                           {\n                                             \'NOTNULL\' => 1,\n                                             \'TYPE\' => \'TINYTEXT\'\n                                           },\n                                           \'ispatch\',\n                                           {\n                                             \'DEFAULT\' => \'FALSE\',\n                                             \'NOTNULL\' => 1,\n                                             \'TYPE\' => \'BOOLEAN\'\n                                           },\n                                           \'filename\',\n                                           {\n                                             \'NOTNULL\' => 1,\n                                             \'TYPE\' => \'varchar(255)\'\n                                           },\n                                           \'submitter_id\',\n                                           {\n                                             \'NOTNULL\' => 1,\n                                             \'REFERENCES\' => {\n                                                               \'COLUMN\' => \'userid\',\n                                                               \'TABLE\' => \'profiles\',\n                                                               \'created\' => 1\n                                                             },\n                                             \'TYPE\' => \'INT3\'\n                                           },\n                                           \'isobsolete\',\n                                           {\n                                             \'DEFAULT\' => \'FALSE\',\n                                             \'NOTNULL\' => 1,\n                                             \'TYPE\' => \'BOOLEAN\'\n                                           },\n                                           \'isprivate\',\n                                           {\n                                             \'DEFAULT\' => \'FALSE\',\n                                             \'NOTNULL\' => 1,\n                                             \'TYPE\' => \'BOOLEAN\'\n                                           }\n                                         ],\n                             \'INDEXES\' => [\n                                            \'attachments_bug_id_idx\',\n                                            [\n                                              \'bug_id\'\n                                            ],\n                                            \'attachments_creation_ts_idx\',\n                                            [\n                                              \'creation_ts\'\n                                            ],\n                                            \'attachments_modification_time_idx\',\n                                            [\n                                              \'modification_time\'\n                                            ],\n                                            \'attachments_submitter_id_idx\',\n                                            [\n                                              \'submitter_id\',\n                                              \'bug_id\'\n                                            ]\n                                          ]\n                           },\n          \'audit_log\' => {\n                           \'FIELDS\' => [\n                                         \'user_id\',\n                                         {\n                                           \'REFERENCES\' => {\n                                                             \'COLUMN\' => \'userid\',\n                                                             \'DELETE\' => \'SET NULL\',\n                                                             \'TABLE\' => \'profiles\',\n                                                             \'created\' => 1\n                                                           },\n                                           \'TYPE\' => \'INT3\'\n                                         },\n                                         \'class\',\n                                         {\n                                           \'NOTNULL\' => 1,\n                                           \'TYPE\' => \'varchar(255)\'\n                                         },\n                                         \'object_id\',\n                                         {\n                                           \'NOTNULL\' => 1,\n                                           \'TYPE\' => \'INT4\'\n                                         },\n                                         \'field\',\n                                         {\n                                           \'NOTNULL\' => 1,\n                                           \'TYPE\' => \'varchar(64)\'\n                                         },\n                                         \'removed\',\n                                         {\n                                           \'TYPE\' => \'MEDIUMTEXT\'\n                                         },\n                                         \'added\',\n                                         {\n                                           \'TYPE\' => \'MEDIUMTEXT\'\n                                         },\n                                         \'at_time\',\n                                         {\n                                           \'NOTNULL\' => 1,\n                                           \'TYPE\' => \'DATETIME\'\n                                         }\n                                       ],\n                           \'INDEXES\' => [\n                                          \'audit_log_class_idx\',\n                                          [\n                                            \'class\',\n                                            \'at_time\'\n                                          ]\n                                        ]\n                         },\n          \'bug_cf_ipi_clust_3_roadbook_for\' => {\n                                                 \'FIELDS\' => [\n                                                               \'bug_id\',\n                                                               {\n                                                                 \'NOTNULL\' => 1,\n                                                                 \'REFERENCES\' => {\n                                                                                   \'COLUMN\' => \'bug_id\',\n                                                                                   \'DELETE\' => \'CASCADE\',\n                                                                                   \'TABLE\' => \'bugs\',\n                                                                                   \'created\' => 1\n                                                                                 },\n                                                                 \'TYPE\' => \'INT3\'\n                                                               },\n                                                               \'value\',\n                                                               {\n                                                                 \'NOTNULL\' => 1,\n                                                                 \'REFERENCES\' => {\n                                                                                   \'COLUMN\' => \'value\',\n                                                                                   \'TABLE\' => \'cf_ipi_clust_3_roadbook_for\',\n                                                                                   \'created\' => 1\n                                                                                 },\n                                                                 \'TYPE\' => \'varchar(64)\'\n                                                               }\n                                                             ],\n                                                 \'INDEXES\' => [\n                                                                \'bug_cf_ipi_clust_3_roadbook_for_bug_id_idx\',\n                                                                {\n                                                                  \'FIELDS\' => [\n                                                                                \'bug_id\',\n                                                                                \'value\'\n                                                                              ],\n                                                                  \'TYPE\' => \'UNIQUE\'\n                                                                }\n                                                              ]\n                                               },\n          \'bug_cf_ipi_clust_9_acct_action\' => {\n                                                \'FIELDS\' => [\n                                                              \'bug_id\',\n                                                              {\n                                                                \'NOTNULL\' => 1,\n                                                                \'REFERENCES\' => {\n                                                                                  \'COLUMN\' => \'bug_id\',\n                                                                                  \'DELETE\' => \'CASCADE\',\n                                                                                  \'TABLE\' => \'bugs\',\n                                                                                  \'created\' => 1\n                                                                                },\n                                                                \'TYPE\' => \'INT3\'\n                                                              },\n                                                              \'value\',\n                                                              {\n                                                                \'NOTNULL\' => 1,\n                                                                \'REFERENCES\' => {\n                                                                                  \'COLUMN\' => \'value\',\n                                                                                  \'TABLE\' => \'cf_ipi_clust_9_acct_action\',\n                                                                                  \'created\' => 1\n                                                                                },\n                                                                \'TYPE\' => \'varchar(64)\'\n                                                              }\n                                                            ],\n                                                \'INDEXES\' => [\n                                                               \'bug_cf_ipi_clust_9_acct_action_bug_id_idx\',\n                                                               {\n                                                                 \'FIELDS\' => [\n                                                                               \'bug_id\',\n                                                                               \'value\'\n                                                                             ],\n                                                                 \'TYPE\' => \'UNIQUE\'\n                                                               }\n                                                             ]\n                                              },\n          \'bug_group_map\' => {\n                               \'FIELDS\' => [\n                                             \'bug_id\',\n                                             {\n                                               \'NOTNULL\' => 1,\n                                               \'REFERENCES\' => {\n                                                                 \'COLUMN\' => \'bug_id\',\n                                                                 \'DELETE\' => \'CASCADE\',\n                                                                 \'TABLE\' => \'bugs\',\n                                                                 \'created\' => 1\n                                                               },\n                                               \'TYPE\' => \'INT3\'\n                                             },\n                                             \'group_id\',\n                                             {\n                                               \'NOTNULL\' => 1,\n                                               \'REFERENCES\' => {\n                                                                 \'COLUMN\' => \'id\',\n                                                                 \'DELETE\' => \'CASCADE\',\n                                                                 \'TABLE\' => \'groups\',\n                                                                 \'created\' => 1\n                                                               },\n                                               \'TYPE\' => \'INT3\'\n                                             }\n                                           ],\n                               \'INDEXES\' => [\n                                              \'bug_group_map_bug_id_idx\',\n                                              {\n                                                \'FIELDS\' => [\n                                                              \'bug_id\',\n                                                              \'group_id\'\n                                                            ],\n                                                \'TYPE\' => \'UNIQUE\'\n                                              },\n                                              \'bug_group_map_group_id_idx\',\n                                              [\n                                                \'group_id\'\n                                              ]\n                                            ]\n                             },\n          \'bug_see_also\' => {\n                              \'FIELDS\' => [\n                                            \'id\',\n                                            {\n                                              \'NOTNULL\' => 1,\n                                              \'PRIMARYKEY\' => 1,\n                                              \'TYPE\' => \'MEDIUMSERIAL\'\n                                            },\n                                            \'bug_id\',\n                                            {\n                                              \'NOTNULL\' => 1,\n                                              \'REFERENCES\' => {\n                                                                \'COLUMN\' => \'bug_id\',\n                                                                \'DELETE\' => \'CASCADE\',\n                                                                \'TABLE\' => \'bugs\',\n                                                                \'created\' => 1\n                                                              },\n                                              \'TYPE\' => \'INT3\'\n                                            },\n                                            \'value\',\n                                            {\n                                              \'NOTNULL\' => 1,\n                                              \'TYPE\' => \'varchar(255)\'\n                                            },\n                                            \'class\',\n                                            {\n                                              \'DEFAULT\' => \'\\\'\\\'\',\n                                              \'NOTNULL\' => 1,\n                                              \'TYPE\' => \'varchar(255)\'\n                                            }\n                                          ],\n                              \'INDEXES\' => [\n                                             \'bug_see_also_bug_id_idx\',\n                                             {\n                                               \'FIELDS\' => [\n                                                             \'bug_id\',\n                                                             \'value\'\n                                                           ],\n                                               \'TYPE\' => \'UNIQUE\'\n                                             }\n                                           ]\n                            },\n          \'bug_severity\' => {\n                              \'FIELDS\' => [\n                                            \'id\',\n                                            {\n                                              \'NOTNULL\' => 1,\n                                              \'PRIMARYKEY\' => 1,\n                                              \'TYPE\' => \'SMALLSERIAL\'\n                                            },\n                                            \'value\',\n                                            {\n                                              \'NOTNULL\' => 1,\n                                              \'TYPE\' => \'varchar(64)\'\n                                            },\n                                            \'sortkey\',\n                                            {\n                                              \'DEFAULT\' => 0,\n                                              \'NOTNULL\' => 1,\n                                              \'TYPE\' => \'INT2\'\n                                            },\n                                            \'isactive\',\n                                            {\n                                              \'DEFAULT\' => \'TRUE\',\n                                              \'NOTNULL\' => 1,\n                                              \'TYPE\' => \'BOOLEAN\'\n                                            },\n                                            \'visibility_value_id\',\n                                            {\n                                              \'TYPE\' => \'INT2\'\n                                            }\n                                          ],\n                              \'INDEXES\' => [\n                                             \'bug_severity_value_idx\',\n                                             {\n                                               \'FIELDS\' => [\n                                                             \'value\'\n                                                           ],\n                                               \'TYPE\' => \'UNIQUE\'\n                                             },\n                                             \'bug_severity_sortkey_idx\',\n                                             [\n                                               \'sortkey\',\n                                               \'value\'\n                                             ],\n                                             \'bug_severity_visibility_value_id_idx\',\n                                             [\n                                               \'visibility_value_id\'\n                                             ]\n                                           ]\n                            },\n          \'bug_status\' => {\n                            \'FIELDS\' => [\n                                          \'id\',\n                                          {\n                                            \'NOTNULL\' => 1,\n                                            \'PRIMARYKEY\' => 1,\n                                            \'TYPE\' => \'SMALLSERIAL\'\n                                          },\n                                          \'value\',\n                                          {\n                                            \'NOTNULL\' => 1,\n                                            \'TYPE\' => \'varchar(64)\'\n                                          },\n                                          \'sortkey\',\n                                          {\n                                            \'DEFAULT\' => 0,\n                                            \'NOTNULL\' => 1,\n                                            \'TYPE\' => \'INT2\'\n                                          },\n                                          \'isactive\',\n                                          {\n                                            \'DEFAULT\' => \'TRUE\',\n                                            \'NOTNULL\' => 1,\n                                            \'TYPE\' => \'BOOLEAN\'\n                                          },\n                                          \'visibility_value_id\',\n                                          {\n                                            \'TYPE\' => \'INT2\'\n                                          },\n                                          \'is_open\',\n                                          {\n                                            \'DEFAULT\' => \'TRUE\',\n                                            \'NOTNULL\' => 1,\n                                            \'TYPE\' => \'BOOLEAN\'\n                                          }\n                                        ],\n                            \'INDEXES\' => [\n                                           \'bug_status_value_idx\',\n                                           {\n                                             \'FIELDS\' => [\n                                                           \'value\'\n                                                         ],\n                                             \'TYPE\' => \'UNIQUE\'\n                                           },\n                                           \'bug_status_sortkey_idx\',\n                                           [\n                                             \'sortkey\',\n                                             \'value\'\n                                           ],\n                                           \'bug_status_visibility_value_id_idx\',\n                                           [\n                                             \'visibility_value_id\'\n                                           ]\n                                         ]\n                          },\n          \'bug_tag\' => {\n                         \'FIELDS\' => [\n                                       \'bug_id\',\n                                       {\n                                         \'NOTNULL\' => 1,\n                                         \'REFERENCES\' => {\n                                                           \'COLUMN\' => \'bug_id\',\n                                                           \'DELETE\' => \'CASCADE\',\n                                                           \'TABLE\' => \'bugs\',\n                                                           \'created\' => 1\n                                                         },\n                                         \'TYPE\' => \'INT3\'\n                                       },\n                                       \'tag_id\',\n                                       {\n                                         \'NOTNULL\' => 1,\n                                         \'REFERENCES\' => {\n                                                           \'COLUMN\' => \'id\',\n                                                           \'DELETE\' => \'CASCADE\',\n                                                           \'TABLE\' => \'tag\',\n                                                           \'created\' => 1\n                                                         },\n                                         \'TYPE\' => \'INT3\'\n                                       }\n                                     ],\n                         \'INDEXES\' => [\n                                        \'bug_tag_bug_id_idx\',\n                                        {\n                                          \'FIELDS\' => [\n                                                        \'bug_id\',\n                                                        \'tag_id\'\n                                                      ],\n                                          \'TYPE\' => \'UNIQUE\'\n                                        }\n                                      ]\n                       },\n          \'bug_user_last_visit\' => {\n                                     \'FIELDS\' => [\n                                                   \'id\',\n                                                   {\n                                                     \'NOTNULL\' => 1,\n                                                     \'PRIMARYKEY\' => 1,\n                                                     \'TYPE\' => \'INTSERIAL\'\n                                                   },\n                                                   \'user_id\',\n                                                   {\n                                                     \'NOTNULL\' => 1,\n                                                     \'REFERENCES\' => {\n                                                                       \'COLUMN\' => \'userid\',\n                                                                       \'DELETE\' => \'CASCADE\',\n                                                                       \'TABLE\' => \'profiles\',\n                                                                       \'created\' => 1\n                                                                     },\n                                                     \'TYPE\' => \'INT3\'\n                                                   },\n                                                   \'bug_id\',\n                                                   {\n                                                     \'NOTNULL\' => 1,\n                                                     \'REFERENCES\' => {\n                                                                       \'COLUMN\' => \'bug_id\',\n                                                                       \'DELETE\' => \'CASCADE\',\n                                                                       \'TABLE\' => \'bugs\',\n                                                                       \'created\' => 1\n                                                                     },\n                                                     \'TYPE\' => \'INT3\'\n                                                   },\n                                                   \'last_visit_ts\',\n                                                   {\n                                                     \'NOTNULL\' => 1,\n                                                     \'TYPE\' => \'DATETIME\'\n                                                   }\n                                                 ],\n                                     \'INDEXES\' => [\n                                                    \'bug_user_last_visit_idx\',\n                                                    {\n                                                      \'FIELDS\' => [\n                                                                    \'user_id\',\n                                                                    \'bug_id\'\n                                                                  ],\n                                                      \'TYPE\' => \'UNIQUE\'\n                                                    },\n                                                    \'bug_user_last_visit_last_visit_ts_idx\',\n                                                    [\n                                                      \'last_visit_ts\'\n                                                    ]\n                                                  ]\n                                   },\n          \'bugs\' => {\n                      \'FIELDS\' => [\n                                    \'bug_id\',\n                                    {\n                                      \'NOTNULL\' => 1,\n                                      \'PRIMARYKEY\' => 1,\n                                      \'TYPE\' => \'MEDIUMSERIAL\'\n                                    },\n                                    \'assigned_to\',\n                                    {\n                                      \'NOTNULL\' => 1,\n                                      \'REFERENCES\' => {\n                                                        \'COLUMN\' => \'userid\',\n                                                        \'TABLE\' => \'profiles\',\n                                                        \'created\' => 1\n                                                      },\n                                      \'TYPE\' => \'INT3\'\n                                    },\n                                    \'bug_file_loc\',\n                                    {\n                                      \'DEFAULT\' => \'\\\'\\\'\',\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'MEDIUMTEXT\'\n                                    },\n                                    \'bug_severity\',\n                                    {\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'varchar(64)\'\n                                    },\n                                    \'bug_status\',\n                                    {\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'varchar(64)\'\n                                    },\n                                    \'creation_ts\',\n                                    {\n                                      \'TYPE\' => \'DATETIME\'\n                                    },\n                                    \'delta_ts\',\n                                    {\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'DATETIME\'\n                                    },\n                                    \'short_desc\',\n                                    {\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'varchar(255)\'\n                                    },\n                                    \'op_sys\',\n                                    {\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'varchar(64)\'\n                                    },\n                                    \'priority\',\n                                    {\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'varchar(64)\'\n                                    },\n                                    \'product_id\',\n                                    {\n                                      \'NOTNULL\' => 1,\n                                      \'REFERENCES\' => {\n                                                        \'COLUMN\' => \'id\',\n                                                        \'TABLE\' => \'products\',\n                                                        \'created\' => 1\n                                                      },\n                                      \'TYPE\' => \'INT2\'\n                                    },\n                                    \'rep_platform\',\n                                    {\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'varchar(64)\'\n                                    },\n                                    \'reporter\',\n                                    {\n                                      \'NOTNULL\' => 1,\n                                      \'REFERENCES\' => {\n                                                        \'COLUMN\' => \'userid\',\n                                                        \'TABLE\' => \'profiles\',\n                                                        \'created\' => 1\n                                                      },\n                                      \'TYPE\' => \'INT3\'\n                                    },\n                                    \'version\',\n                                    {\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'varchar(64)\'\n                                    },\n                                    \'component_id\',\n                                    {\n                                      \'NOTNULL\' => 1,\n                                      \'REFERENCES\' => {\n                                                        \'COLUMN\' => \'id\',\n                                                        \'TABLE\' => \'components\',\n                                                        \'created\' => 1\n                                                      },\n                                      \'TYPE\' => \'INT3\'\n                                    },\n                                    \'resolution\',\n                                    {\n                                      \'DEFAULT\' => \'\\\'\\\'\',\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'varchar(64)\'\n                                    },\n                                    \'target_milestone\',\n                                    {\n                                      \'DEFAULT\' => \'\\\'---\\\'\',\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'varchar(64)\'\n                                    },\n                                    \'qa_contact\',\n                                    {\n                                      \'REFERENCES\' => {\n                                                        \'COLUMN\' => \'userid\',\n                                                        \'TABLE\' => \'profiles\',\n                                                        \'created\' => 1\n                                                      },\n                                      \'TYPE\' => \'INT3\'\n                                    },\n                                    \'status_whiteboard\',\n                                    {\n                                      \'DEFAULT\' => \'\\\'\\\'\',\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'MEDIUMTEXT\'\n                                    },\n                                    \'lastdiffed\',\n                                    {\n                                      \'TYPE\' => \'DATETIME\'\n                                    },\n                                    \'everconfirmed\',\n                                    {\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'BOOLEAN\'\n                                    },\n                                    \'reporter_accessible\',\n                                    {\n                                      \'DEFAULT\' => \'TRUE\',\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'BOOLEAN\'\n                                    },\n                                    \'cclist_accessible\',\n                                    {\n                                      \'DEFAULT\' => \'TRUE\',\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'BOOLEAN\'\n                                    },\n                                    \'estimated_time\',\n                                    {\n                                      \'DEFAULT\' => \'0\',\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'decimal(7,2)\'\n                                    },\n                                    \'remaining_time\',\n                                    {\n                                      \'DEFAULT\' => \'0\',\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'decimal(7,2)\'\n                                    },\n                                    \'deadline\',\n                                    {\n                                      \'TYPE\' => \'DATETIME\'\n                                    },\n                                    \'cf_ipi_clust_4_status_in_progress\',\n                                    {\n                                      \'DEFAULT\' => \'\\\'---\\\'\',\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'varchar(64)\'\n                                    },\n                                    \'cf_ipi_clust_4_status_standby\',\n                                    {\n                                      \'DEFAULT\' => \'\\\'---\\\'\',\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'varchar(64)\'\n                                    },\n                                    \'cf_ipi_clust_2_room\',\n                                    {\n                                      \'DEFAULT\' => \'\\\'\\\'\',\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'varchar(255)\'\n                                    },\n                                    \'cf_ipi_clust_6_claim_type\',\n                                    {\n                                      \'DEFAULT\' => \'\\\'---\\\'\',\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'varchar(64)\'\n                                    },\n                                    \'cf_ipi_clust_1_solution\',\n                                    {\n                                      \'DEFAULT\' => \'\\\'\\\'\',\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'MEDIUMTEXT\'\n                                    },\n                                    \'cf_ipi_clust_1_next_step\',\n                                    {\n                                      \'DEFAULT\' => \'\\\'\\\'\',\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'MEDIUMTEXT\'\n                                    },\n                                    \'cf_ipi_clust_1_next_step_date\',\n                                    {\n                                      \'TYPE\' => \'DATE\'\n                                    },\n                                    \'cf_ipi_clust_3_field_action\',\n                                    {\n                                      \'DEFAULT\' => \'\\\'\\\'\',\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'MEDIUMTEXT\'\n                                    },\n                                    \'cf_ipi_clust_3_field_action_from\',\n                                    {\n                                      \'TYPE\' => \'DATETIME\'\n                                    },\n                                    \'cf_ipi_clust_3_field_action_until\',\n                                    {\n                                      \'TYPE\' => \'DATETIME\'\n                                    },\n                                    \'cf_ipi_clust_3_action_type\',\n                                    {\n                                      \'DEFAULT\' => \'\\\'---\\\'\',\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'varchar(64)\'\n                                    },\n                                    \'cf_ipi_clust_3_nber_field_visits\',\n                                    {\n                                      \'DEFAULT\' => 0,\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'INT4\'\n                                    },\n                                    \'cf_ipi_clust_5_approved_budget\',\n                                    {\n                                      \'DEFAULT\' => \'\\\'\\\'\',\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'varchar(255)\'\n                                    },\n                                    \'cf_ipi_clust_5_budget\',\n                                    {\n                                      \'DEFAULT\' => \'\\\'\\\'\',\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'varchar(255)\'\n                                    },\n                                    \'cf_ipi_clust_8_contract_id\',\n                                    {\n                                      \'DEFAULT\' => \'\\\'\\\'\',\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'varchar(255)\'\n                                    },\n                                    \'cf_ipi_clust_9_inv_ll\',\n                                    {\n                                      \'DEFAULT\' => \'\\\'\\\'\',\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'varchar(255)\'\n                                    },\n                                    \'cf_ipi_clust_9_inv_det_ll\',\n                                    {\n                                      \'DEFAULT\' => \'\\\'\\\'\',\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'varchar(255)\'\n                                    },\n                                    \'cf_ipi_clust_9_inv_cust\',\n                                    {\n                                      \'DEFAULT\' => \'\\\'\\\'\',\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'MEDIUMTEXT\'\n                                    },\n                                    \'cf_ipi_clust_9_inv_det_cust\',\n                                    {\n                                      \'DEFAULT\' => \'\\\'\\\'\',\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'MEDIUMTEXT\'\n                                    },\n                                    \'cf_ipi_clust_5_spe_action_purchase_list\',\n                                    {\n                                      \'DEFAULT\' => \'\\\'\\\'\',\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'varchar(255)\'\n                                    },\n                                    \'cf_ipi_clust_5_spe_approval_for\',\n                                    {\n                                      \'DEFAULT\' => \'\\\'\\\'\',\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'MEDIUMTEXT\'\n                                    },\n                                    \'cf_ipi_clust_5_spe_approval_comment\',\n                                    {\n                                      \'DEFAULT\' => \'\\\'\\\'\',\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'MEDIUMTEXT\'\n                                    },\n                                    \'cf_ipi_clust_5_spe_contractor\',\n                                    {\n                                      \'DEFAULT\' => \'\\\'\\\'\',\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'MEDIUMTEXT\'\n                                    },\n                                    \'cf_ipi_clust_5_spe_purchase_cost\',\n                                    {\n                                      \'DEFAULT\' => \'\\\'\\\'\',\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'varchar(255)\'\n                                    },\n                                    \'cf_ipi_clust_7_spe_bill_number\',\n                                    {\n                                      \'DEFAULT\' => \'\\\'\\\'\',\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'varchar(255)\'\n                                    },\n                                    \'cf_ipi_clust_7_spe_payment_type\',\n                                    {\n                                      \'DEFAULT\' => \'\\\'---\\\'\',\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'varchar(64)\'\n                                    },\n                                    \'cf_ipi_clust_7_spe_contractor_payment\',\n                                    {\n                                      \'DEFAULT\' => \'\\\'\\\'\',\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'MEDIUMTEXT\'\n                                    },\n                                    \'cf_ipi_clust_8_spe_customer\',\n                                    {\n                                      \'DEFAULT\' => \'\\\'\\\'\',\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'varchar(255)\'\n                                    },\n                                    \'cf_specific_for\',\n                                    {\n                                      \'DEFAULT\' => \'\\\'---\\\'\',\n                                      \'NOTNULL\' => 1,\n                                      \'TYPE\' => \'varchar(64)\'\n                                    }\n                                  ],\n                      \'INDEXES\' => [\n                                     \'bugs_assigned_to_idx\',\n                                     [\n                                       \'assigned_to\'\n                                     ],\n                                     \'bugs_creation_ts_idx\',\n                                     [\n                                       \'creation_ts\'\n                                     ],\n                                     \'bugs_delta_ts_idx\',\n                                     [\n                                       \'delta_ts\'\n                                     ],\n                                     \'bugs_bug_severity_idx\',\n                                     [\n                                       \'bug_severity\'\n                                     ],\n                                     \'bugs_bug_status_idx\',\n                                     [\n                                       \'bug_status\'\n                                     ],\n                                     \'bugs_op_sys_idx\',\n                                     [\n                                       \'op_sys\'\n                                     ],\n                                     \'bugs_priority_idx\',\n                                     [\n                                       \'priority\'\n                                     ],\n                                     \'bugs_product_id_idx\',\n                                     [\n                                       \'product_id\'\n                                     ],\n                                     \'bugs_reporter_idx\',\n                                     [\n                                       \'reporter\'\n                                     ],\n                                     \'bugs_version_idx\',\n                                     [\n                                       \'version\'\n                                     ],\n                                     \'bugs_component_id_idx\',\n                                     [\n                                       \'component_id\'\n                                     ],\n                                     \'bugs_resolution_idx\',\n                                     [\n                                       \'resolution\'\n                                     ],\n                                     \'bugs_target_milestone_idx\',\n                                     [\n                                       \'target_milestone\'\n                                     ],\n                                     \'bugs_qa_contact_idx\',\n                                     [\n                                       \'qa_contact\'\n                                     ]\n                                   ]\n                    },\n          \'bugs_activity\' => {\n                               \'FIELDS\' => [\n                                             \'id\',\n                                             {\n                                               \'NOTNULL\' => 1,\n                                               \'PRIMARYKEY\' => 1,\n                                               \'TYPE\' => \'INTSERIAL\'\n                                             },\n                                             \'bug_id\',\n                                             {\n                                               \'NOTNULL\' => 1,\n                                               \'REFERENCES\' => {\n                                                                 \'COLUMN\' => \'bug_id\',\n                                                                 \'DELETE\' => \'CASCADE\',\n                                                                 \'TABLE\' => \'bugs\',\n                                                                 \'created\' => 1\n                                                               },\n                                               \'TYPE\' => \'INT3\'\n                                             },\n                                             \'attach_id\',\n                                             {\n                                               \'REFERENCES\' => {\n                                                                 \'COLUMN\' => \'attach_id\',\n                                                                 \'DELETE\' => \'CASCADE\',\n                                                                 \'TABLE\' => \'attachments\',\n                                                                 \'created\' => 1\n                                                               },\n                                               \'TYPE\' => \'INT3\'\n                                             },\n                                             \'who\',\n                                             {\n                                               \'NOTNULL\' => 1,\n                                               \'REFERENCES\' => {\n                                                                 \'COLUMN\' => \'userid\',\n                                                                 \'TABLE\' => \'profiles\',\n                                                                 \'created\' => 1\n                                                               },\n                                               \'TYPE\' => \'INT3\'\n                                             },\n                                             \'bug_when\',\n                                             {\n                                               \'NOTNULL\' => 1,\n                                               \'TYPE\' => \'DATETIME\'\n                                             },\n                                             \'fieldid\',\n                                             {\n                                               \'NOTNULL\' => 1,\n                                               \'REFERENCES\' => {\n                                                                 \'COLUMN\' => \'id\',\n                                                                 \'TABLE\' => \'fielddefs\',\n                                                                 \'created\' => 1\n                                                               },\n                                               \'TYPE\' => \'INT3\'\n                                             },\n                                             \'added\',\n                                             {\n                                               \'TYPE\' => \'varchar(255)\'\n                                             },\n                                             \'removed\',\n                                             {\n                                               \'TYPE\' => \'varchar(255)\'\n                                             },\n                                             \'comment_id\',\n                                             {\n                                               \'REFERENCES\' => {\n                                                                 \'COLUMN\' => \'comment_id\',\n                                                                 \'DELETE\' => \'CASCADE\',\n                                                                 \'TABLE\' => \'longdescs\',\n                                                                 \'created\' => 1\n                                                               },\n                                               \'TYPE\' => \'INT4\'\n                                             }\n                                           ],\n                               \'INDEXES\' => [\n                                              \'bugs_activity_bug_id_idx\',\n                                              [\n                                                \'bug_id\'\n                                              ],\n                                              \'bugs_activity_who_idx\',\n                                              [\n                                                \'who\'\n                                              ],\n                                              \'bugs_activity_bug_when_idx\',\n                                              [\n                                                \'bug_when\'\n                                              ],\n                                              \'bugs_activity_fieldid_idx\',\n                                              [\n                                                \'fieldid\'\n                                              ],\n                                              \'bugs_activity_added_idx\',\n                                              [\n                                                \'added\'\n                                              ],\n                                              \'bugs_activity_removed_idx\',\n                                              [\n                                                \'removed\'\n                                              ]\n                                            ]\n                             },\n          \'bugs_aliases\' => {\n                              \'FIELDS\' => [\n                                            \'alias\',\n                                            {\n                                              \'NOTNULL\' => 1,\n                                              \'TYPE\' => \'varchar(40)\'\n                                            },\n                                            \'bug_id\',\n                                            {\n                                              \'REFERENCES\' => {\n                                                                \'COLUMN\' => \'bug_id\',\n                                                                \'DELETE\' => \'CASCADE\',\n                                                                \'TABLE\' => \'bugs\',\n                                                                \'created\' => 1\n                                                              },\n                                              \'TYPE\' => \'INT3\'\n                                            }\n                                          ],\n                              \'INDEXES\' => [\n                                             \'bugs_aliases_bug_id_idx\',\n                                             [\n                                               \'bug_id\'\n                                             ],\n                                             \'bugs_aliases_alias_idx\',\n                                             {\n                                               \'FIELDS\' => [\n                                                             \'alias\'\n                                                           ],\n                                               \'TYPE\' => \'UNIQUE\'\n                                             }\n                                           ]\n                            },\n          \'bugs_fulltext\' => {\n                               \'FIELDS\' => [\n                                             \'bug_id\',\n                                             {\n                                               \'NOTNULL\' => 1,\n                                               \'PRIMARYKEY\' => 1,\n                                               \'REFERENCES\' => {\n                                                                 \'COLUMN\' => \'bug_id\',\n                                                                 \'DELETE\' => \'CASCADE\',\n                                                                 \'TABLE\' => \'bugs\',\n                                                                 \'created\' => 1\n                                                               },\n                                               \'TYPE\' => \'INT3\'\n                                             },\n                                             \'short_desc\',\n                                             {\n                                               \'NOTNULL\' => 1,\n                                               \'TYPE\' => \'varchar(255)\'\n                                             },\n                                             \'comments\',\n                                             {\n                                               \'TYPE\' => \'LONGTEXT\'\n                                             },\n                                             \'comments_noprivate\',\n                                             {\n                                               \'TYPE\' => \'LONGTEXT\'\n                                             }\n                                           ],\n                               \'INDEXES\' => [\n                                              \'bugs_fulltext_short_desc_idx\',\n                                              {\n                                                \'FIELDS\' => [\n                                                              \'short_desc\'\n                                                            ],\n                                                \'TYPE\' => \'FULLTEXT\'\n                                              },\n                                              \'bugs_fulltext_comments_idx\',\n                                              {\n                                                \'FIELDS\' => [\n                                                              \'comments\'\n                                                            ],\n                                                \'TYPE\' => \'FULLTEXT\'\n                                              },\n                                              \'bugs_fulltext_comments_noprivate_idx\',\n                                              {\n                                                \'FIELDS\' => [\n                                                              \'comments_noprivate\'\n                                                            ],\n                                                \'TYPE\' => \'FULLTEXT\'\n                                              }\n                                            ]\n                             },\n          \'bz_schema\' => {\n                           \'FIELDS\' => [\n                                         \'schema_data\',\n                                         {\n                                           \'NOTNULL\' => 1,\n                                           \'TYPE\' => \'LONGBLOB\'\n                                         },\n                                         \'version\',\n                                         {\n                                           \'NOTNULL\' => 1,\n                                           \'TYPE\' => \'decimal(3,2)\'\n                                         }\n                                       ]\n                         },\n          \'category_group_map\' => {\n                                    \'FIELDS\' => [\n                                                  \'category_id\',\n                                                  {\n                                                    \'NOTNULL\' => 1,\n                                                    \'REFERENCES\' => {\n                                                                      \'COLUMN\' => \'id\',\n                                                                      \'DELETE\' => \'CASCADE\',\n                                                                      \'TABLE\' => \'series_categories\',\n                                                                      \'created\' => 1\n                                                                    },\n                                                    \'TYPE\' => \'INT2\'\n                                                  },\n                                                  \'group_id\',\n                                                  {\n                                                    \'NOTNULL\' => 1,\n                                                    \'REFERENCES\' => {\n                                                                      \'COLUMN\' => \'id\',\n                                                                      \'DELETE\' => \'CASCADE\',\n                                                                      \'TABLE\' => \'groups\',\n                                                                      \'created\' => 1\n                                                                    },\n                                                    \'TYPE\' => \'INT3\'\n                                                  }\n                                                ],\n                                    \'INDEXES\' => [\n                                                   \'category_group_map_category_id_idx\',\n                                                   {\n                                                     \'FIELDS\' => [\n                                                                   \'category_id\',\n                                                                   \'group_id\'\n                                                                 ],\n                                                     \'TYPE\' => \'UNIQUE\'\n                                                   }\n                                                 ]\n                                  },\n          \'cc\' => {\n                    \'FIELDS\' => [\n                                  \'bug_id\',\n                                  {\n                                    \'NOTNULL\' => 1,\n                                    \'REFERENCES\' => {\n                                                      \'COLUMN\' => \'bug_id\',\n                                                      \'DELETE\' => \'CASCADE\',\n                                                      \'TABLE\' => \'bugs\',\n                                                      \'created\' => 1\n                                                    },\n                                    \'TYPE\' => \'INT3\'\n                                  },\n                                  \'who\',\n                                  {\n                                    \'NOTNULL\' => 1,\n                                    \'REFERENCES\' => {\n                                                      \'COLUMN\' => \'userid\',\n                                                      \'DELETE\' => \'CASCADE\',\n                                                      \'TABLE\' => \'profiles\',\n                                                      \'created\' => 1\n                                                    },\n                                    \'TYPE\' => \'INT3\'\n                                  }\n                                ],\n                    \'INDEXES\' => [\n                                   \'cc_bug_id_idx\',\n                                   {\n                                     \'FIELDS\' => [\n                                                   \'bug_id\',\n                                                   \'who\'\n                                                 ],\n                                     \'TYPE\' => \'UNIQUE\'\n                                   },\n                                   \'cc_who_idx\',\n                                   [\n                                     \'who\'\n                                   ]\n                                 ]\n                  },\n          \'cf_ipi_clust_3_action_type\' => {\n                                            \'FIELDS\' => [\n                                                          \'id\',\n                                                          {\n                                                            \'NOTNULL\' => 1,\n                                                            \'PRIMARYKEY\' => 1,\n                                                            \'TYPE\' => \'SMALLSERIAL\'\n                                                          },\n                                                          \'value\',\n                                                          {\n                                                            \'NOTNULL\' => 1,\n                                                            \'TYPE\' => \'varchar(64)\'\n                                                          },\n                                                          \'sortkey\',\n                                                          {\n                                                            \'DEFAULT\' => 0,\n                                                            \'NOTNULL\' => 1,\n                                                            \'TYPE\' => \'INT2\'\n                                                          },\n                                                          \'isactive\',\n                                                          {\n                                                            \'DEFAULT\' => \'TRUE\',\n                                                            \'NOTNULL\' => 1,\n                                                            \'TYPE\' => \'BOOLEAN\'\n                                                          },\n                                                          \'visibility_value_id\',\n                                                          {\n                                                            \'TYPE\' => \'INT2\'\n                                                          }\n                                                        ],\n                                            \'INDEXES\' => [\n                                                           \'cf_ipi_clust_3_action_type_sortkey_idx\',\n                                                           [\n                                                             \'sortkey\',\n                                                             \'value\'\n                                                           ],\n                                                           \'cf_ipi_clust_3_action_type_value_idx\',\n                                                           {\n                                                             \'FIELDS\' => [\n                                                                           \'value\'\n                                                                         ],\n                                                             \'TYPE\' => \'UNIQUE\'\n                                                           },\n                                                           \'cf_ipi_clust_3_action_type_visibility_value_id_idx\',\n                                                           [\n                                                             \'visibility_value_id\'\n                                                           ]\n                                                         ]\n                                          },\n          \'cf_ipi_clust_3_roadbook_for\' => {\n                                             \'FIELDS\' => [\n                                                           \'id\',\n                                                           {\n                                                             \'NOTNULL\' => 1,\n                                                             \'PRIMARYKEY\' => 1,\n                                                             \'TYPE\' => \'SMALLSERIAL\'\n                                                           },\n                                                           \'value\',\n                                                           {\n                                                             \'NOTNULL\' => 1,\n                                                             \'TYPE\' => \'varchar(64)\'\n                                                           },\n                                                           \'sortkey\',\n                                                           {\n                                                             \'DEFAULT\' => 0,\n                                                             \'NOTNULL\' => 1,\n                                                             \'TYPE\' => \'INT2\'\n                                                           },\n                                                           \'isactive\',\n                                                           {\n                                                             \'DEFAULT\' => \'TRUE\',\n                                                             \'NOTNULL\' => 1,\n                                                             \'TYPE\' => \'BOOLEAN\'\n                                                           },\n                                                           \'visibility_value_id\',\n                                                           {\n                                                             \'TYPE\' => \'INT2\'\n                                                           }\n                                                         ],\n                                             \'INDEXES\' => [\n                                                            \'cf_ipi_clust_3_roadbook_for_value_idx\',\n                                                            {\n                                                              \'FIELDS\' => [\n                                                                            \'value\'\n                                                                          ],\n                                                              \'TYPE\' => \'UNIQUE\'\n                                                            },\n                                                            \'cf_ipi_clust_3_roadbook_for_visibility_value_id_idx\',\n                                                            [\n                                                              \'visibility_value_id\'\n                                                            ],\n                                                            \'cf_ipi_clust_3_roadbook_for_sortkey_idx\',\n                                                            [\n                                                              \'sortkey\',\n                                                              \'value\'\n                                                            ]\n                                                          ]\n                                           },\n          \'cf_ipi_clust_4_status_in_progress\' => {\n                                                   \'FIELDS\' => [\n                                                                 \'id\',\n                                                                 {\n                                                                   \'NOTNULL\' => 1,\n                                                                   \'PRIMARYKEY\' => 1,\n                                                                   \'TYPE\' => \'SMALLSERIAL\'\n                                                                 },\n                                                                 \'value\',\n                                                                 {\n                                                                   \'NOTNULL\' => 1,\n                                                                   \'TYPE\' => \'varchar(64)\'\n                                                                 },\n                                                                 \'sortkey\',\n                                                                 {\n                                                                   \'DEFAULT\' => 0,\n                                                                   \'NOTNULL\' => 1,\n                                                                   \'TYPE\' => \'INT2\'\n                                                                 },\n                                                                 \'isactive\',\n                                                                 {\n                                                                   \'DEFAULT\' => \'TRUE\',\n                                                                   \'NOTNULL\' => 1,\n                                                                   \'TYPE\' => \'BOOLEAN\'\n                                                                 },\n                                                                 \'visibility_value_id\',\n                                                                 {\n                                                                   \'TYPE\' => \'INT2\'\n                                                                 }\n                                                               ],\n                                                   \'INDEXES\' => [\n                                                                  \'cf_ipi_clust_4_status_in_progress_visibility_value_id_idx\',\n                                                                  [\n                                                                    \'visibility_value_id\'\n                                                                  ],\n                                                                  \'cf_ipi_clust_4_status_in_progress_value_idx\',\n                                                                  {\n                                                                    \'FIELDS\' => [\n                                                                                  \'value\'\n                                                                                ],\n                                                                    \'TYPE\' => \'UNIQUE\'\n                                                                  },\n                                                                  \'cf_ipi_clust_4_status_in_progress_sortkey_idx\',\n                                                                  [\n                                                                    \'sortkey\',\n                                                                    \'value\'\n                                                                  ]\n                                                                ]\n                                                 },\n          \'cf_ipi_clust_4_status_standby\' => {\n                                               \'FIELDS\' => [\n                                                             \'id\',\n                                                             {\n                                                               \'NOTNULL\' => 1,\n                                                               \'PRIMARYKEY\' => 1,\n                                                               \'TYPE\' => \'SMALLSERIAL\'\n                                                             },\n                                                             \'value\',\n                                                             {\n                                                               \'NOTNULL\' => 1,\n                                                               \'TYPE\' => \'varchar(64)\'\n                                                             },\n                                                             \'sortkey\',\n                                                             {\n                                                               \'DEFAULT\' => 0,\n                                                               \'NOTNULL\' => 1,\n                                                               \'TYPE\' => \'INT2\'\n                                                             },\n                                                             \'isactive\',\n                                                             {\n                                                               \'DEFAULT\' => \'TRUE\',\n                                                               \'NOTNULL\' => 1,\n                                                               \'TYPE\' => \'BOOLEAN\'\n                                                             },\n                                                             \'visibility_value_id\',\n                                                             {\n                                                               \'TYPE\' => \'INT2\'\n                                                             }\n                                                           ],\n                                               \'INDEXES\' => [\n                                                              \'cf_ipi_clust_4_status_standby_value_idx\',\n                                                              {\n                                                                \'FIELDS\' => [\n                                                                              \'value\'\n                                                                            ],\n                                                                \'TYPE\' => \'UNIQUE\'\n                                                              },\n                                                              \'cf_ipi_clust_4_status_standby_visibility_value_id_idx\',\n                                                              [\n                                                                \'visibility_value_id\'\n                                                              ],\n                                                              \'cf_ipi_clust_4_status_standby_sortkey_idx\',\n                                                              [\n                                                                \'sortkey\',\n                                                                \'value\'\n                                                              ]\n                                                            ]\n                                             },\n          \'cf_ipi_clust_6_claim_type\' => {\n                                           \'FIELDS\' => [\n                                                         \'id\',\n                                                         {\n                                                           \'NOTNULL\' => 1,\n                                                           \'PRIMARYKEY\' => 1,\n                                                           \'TYPE\' => \'SMALLSERIAL\'\n                                                         },\n                                                         \'value\',\n                                                         {\n                                                           \'NOTNULL\' => 1,\n                                                           \'TYPE\' => \'varchar(64)\'\n                                                         },\n                                                         \'sortkey\',\n                                                         {\n                                                           \'DEFAULT\' => 0,\n                                                           \'NOTNULL\' => 1,\n                                                           \'TYPE\' => \'INT2\'\n                                                         },\n                                                         \'isactive\',\n                                                         {\n                                                           \'DEFAULT\' => \'TRUE\',\n                                                           \'NOTNULL\' => 1,\n                                                           \'TYPE\' => \'BOOLEAN\'\n                                                         },\n                                                         \'visibility_value_id\',\n                                                         {\n                                                           \'TYPE\' => \'INT2\'\n                                                         }\n                                                       ],\n                                           \'INDEXES\' => [\n                                                          \'cf_ipi_clust_6_claim_type_value_idx\',\n                                                          {\n                                                            \'FIELDS\' => [\n                                                                          \'value\'\n                                                                        ],\n                                                            \'TYPE\' => \'UNIQUE\'\n                                                          },\n                                                          \'cf_ipi_clust_6_claim_type_sortkey_idx\',\n                                                          [\n                                                            \'sortkey\',\n                                                            \'value\'\n                                                          ],\n                                                          \'cf_ipi_clust_6_claim_type_visibility_value_id_idx\',\n                                                          [\n                                                            \'visibility_value_id\'\n                                                          ]\n                                                        ]\n                                         },\n          \'cf_ipi_clust_7_spe_payment_type\' => {\n                                                 \'FIELDS\' => [\n                                                               \'id\',\n                                                               {\n                                                                 \'NOTNULL\' => 1,\n                                                                 \'PRIMARYKEY\' => 1,\n                                                                 \'TYPE\' => \'SMALLSERIAL\'\n                                                               },\n                                                               \'value\',\n                                                               {\n                                                                 \'NOTNULL\' => 1,\n                                                                 \'TYPE\' => \'varchar(64)\'\n                                                               },\n                                                               \'sortkey\',\n                                                               {\n                                                                 \'DEFAULT\' => 0,\n                                                                 \'NOTNULL\' => 1,\n                                                                 \'TYPE\' => \'INT2\'\n                                                               },\n                                                               \'isactive\',\n                                                               {\n                                                                 \'DEFAULT\' => \'TRUE\',\n                                                                 \'NOTNULL\' => 1,\n                                                                 \'TYPE\' => \'BOOLEAN\'\n                                                               },\n                                                               \'visibility_value_id\',\n                                                               {\n                                                                 \'TYPE\' => \'INT2\'\n                                                               }\n                                                             ],\n                                                 \'INDEXES\' => [\n                                                                \'cf_ipi_clust_7_spe_payment_type_visibility_value_id_idx\',\n                                                                [\n                                                                  \'visibility_value_id\'\n                                                                ],\n                                                                \'cf_ipi_clust_7_spe_payment_type_sortkey_idx\',\n                                                                [\n                                                                  \'sortkey\',\n                                                                  \'value\'\n                                                                ],\n                                                                \'cf_ipi_clust_7_spe_payment_type_value_idx\',\n                                                                {\n                                                                  \'FIELDS\' => [\n                                                                                \'value\'\n                                                                              ],\n                                                                  \'TYPE\' => \'UNIQUE\'\n                                                                }\n                                                              ]\n                                               },\n          \'cf_ipi_clust_9_acct_action\' => {\n                                            \'FIELDS\' => [\n                                                          \'id\',\n                                                          {\n                                                            \'NOTNULL\' => 1,\n                                                            \'PRIMARYKEY\' => 1,\n                                                            \'TYPE\' => \'SMALLSERIAL\'\n                                                          },\n                                                          \'value\',\n                                                          {\n                                                            \'NOTNULL\' => 1,\n                                                            \'TYPE\' => \'varchar(64)\'\n                                                          },\n                                                          \'sortkey\',\n                                                          {\n                                                            \'DEFAULT\' => 0,\n                                                            \'NOTNULL\' => 1,\n                                                            \'TYPE\' => \'INT2\'\n                                                          },\n                                                          \'isactive\',\n                                                          {\n                                                            \'DEFAULT\' => \'TRUE\',\n                                                            \'NOTNULL\' => 1,\n                                                            \'TYPE\' => \'BOOLEAN\'\n                                                          },\n                                                          \'visibility_value_id\',\n                                                          {\n                                                            \'TYPE\' => \'INT2\'\n                                                          }\n                                                        ],\n                                            \'INDEXES\' => [\n                                                           \'cf_ipi_clust_9_acct_action_visibility_value_id_idx\',\n                                                           [\n                                                             \'visibility_value_id\'\n                                                           ],\n                                                           \'cf_ipi_clust_9_acct_action_sortkey_idx\',\n                                                           [\n                                                             \'sortkey\',\n                                                             \'value\'\n                                                           ],\n                                                           \'cf_ipi_clust_9_acct_action_value_idx\',\n                                                           {\n                                                             \'FIELDS\' => [\n                                                                           \'value\'\n                                                                         ],\n                                                             \'TYPE\' => \'UNIQUE\'\n                                                           }\n                                                         ]\n                                          },\n          \'cf_specific_for\' => {\n                                 \'FIELDS\' => [\n                                               \'id\',\n                                               {\n                                                 \'NOTNULL\' => 1,\n                                                 \'PRIMARYKEY\' => 1,\n                                                 \'TYPE\' => \'SMALLSERIAL\'\n                                               },\n                                               \'value\',\n                                               {\n                                                 \'NOTNULL\' => 1,\n                                                 \'TYPE\' => \'varchar(64)\'\n                                               },\n                                               \'sortkey\',\n                                               {\n                                                 \'DEFAULT\' => 0,\n                                                 \'NOTNULL\' => 1,\n                                                 \'TYPE\' => \'INT2\'\n                                               },\n                                               \'isactive\',\n                                               {\n                                                 \'DEFAULT\' => \'TRUE\',\n                                                 \'NOTNULL\' => 1,\n                                                 \'TYPE\' => \'BOOLEAN\'\n                                               },\n                                               \'visibility_value_id\',\n                                               {\n                                                 \'TYPE\' => \'INT2\'\n                                               }\n                                             ],\n                                 \'INDEXES\' => [\n                                                \'cf_specific_for_sortkey_idx\',\n                                                [\n                                                  \'sortkey\',\n                                                  \'value\'\n                                                ],\n                                                \'cf_specific_for_value_idx\',\n                                                {\n                                                  \'FIELDS\' => [\n                                                                \'value\'\n                                                              ],\n                                                  \'TYPE\' => \'UNIQUE\'\n                                                },\n                                                \'cf_specific_for_visibility_value_id_idx\',\n                                                [\n                                                  \'visibility_value_id\'\n                                                ]\n                                              ]\n                               },\n          \'classifications\' => {\n                                 \'FIELDS\' => [\n                                               \'id\',\n                                               {\n                                                 \'NOTNULL\' => 1,\n                                                 \'PRIMARYKEY\' => 1,\n                                                 \'TYPE\' => \'SMALLSERIAL\'\n                                               },\n                                               \'name\',\n                                               {\n                                                 \'NOTNULL\' => 1,\n                                                 \'TYPE\' => \'varchar(64)\'\n                                               },\n                                               \'description\',\n                                               {\n                                                 \'TYPE\' => \'MEDIUMTEXT\'\n                                               },\n                                               \'sortkey\',\n                                               {\n                                                 \'DEFAULT\' => \'0\',\n                                                 \'NOTNULL\' => 1,\n                                                 \'TYPE\' => \'INT2\'\n                                               }\n                                             ],\n                                 \'INDEXES\' => [\n                                                \'classifications_name_idx\',\n                                                {\n                                                  \'FIELDS\' => [\n                                                                \'name\'\n                                                              ],\n                                                  \'TYPE\' => \'UNIQUE\'\n                                                }\n                                              ]\n                               },\n          \'component_cc\' => {\n                              \'FIELDS\' => [\n                                            \'user_id\',\n                                            {\n                                              \'NOTNULL\' => 1,\n                                              \'REFERENCES\' => {\n                                                                \'COLUMN\' => \'userid\',\n                                                                \'DELETE\' => \'CASCADE\',\n                                                                \'TABLE\' => \'profiles\',\n                                                                \'created\' => 1\n                                                              },\n                                              \'TYPE\' => \'INT3\'\n                                            },\n                                            \'component_id\',\n                                            {\n                                              \'NOTNULL\' => 1,\n                                              \'REFERENCES\' => {\n                                                                \'COLUMN\' => \'id\',\n                                                                \'DELETE\' => \'CASCADE\',\n                                                                \'TABLE\' => \'components\',\n                                                                \'created\' => 1\n                                                              },\n                                              \'TYPE\' => \'INT3\'\n                                            }\n                                          ],\n                              \'INDEXES\' => [\n                                             \'component_cc_user_id_idx\',\n                                             {\n                                               \'FIELDS\' => [\n                                                             \'component_id\',\n                                                             \'user_id\'\n                                                           ],\n                                               \'TYPE\' => \'UNIQUE\'\n                                             }\n                                           ]\n                            },\n          \'components\' => {\n                            \'FIELDS\' => [\n                                          \'id\',\n                                          {\n                                            \'NOTNULL\' => 1,\n                                            \'PRIMARYKEY\' => 1,\n                                            \'TYPE\' => \'MEDIUMSERIAL\'\n                                          },\n                                          \'name\',\n                                          {\n                                            \'NOTNULL\' => 1,\n                                            \'TYPE\' => \'varchar(64)\'\n                                          },\n                                          \'product_id\',\n                                          {\n                                            \'NOTNULL\' => 1,\n                                            \'REFERENCES\' => {\n                                                              \'COLUMN\' => \'id\',\n                                                              \'DELETE\' => \'CASCADE\',\n                                                              \'TABLE\' => \'products\',\n                                                              \'created\' => 1\n                                                            },\n                                            \'TYPE\' => \'INT2\'\n                                          },\n                                          \'initialowner\',\n                                          {\n                                            \'NOTNULL\' => 1,\n                                            \'REFERENCES\' => {\n                                                              \'COLUMN\' => \'userid\',\n                                                              \'TABLE\' => \'profiles\',\n                                                              \'created\' => 1\n                                                            },\n                                            \'TYPE\' => \'INT3\'\n                                          },\n                                          \'initialqacontact\',\n                                          {\n                                            \'REFERENCES\' => {\n                                                              \'COLUMN\' => \'userid\',\n                                                              \'DELETE\' => \'SET NULL\',\n                                                              \'TABLE\' => \'profiles\',\n                                                              \'created\' => 1\n                                                            },\n                                            \'TYPE\' => \'INT3\'\n                                          },\n                                          \'description\',\n                                          {\n                                            \'NOTNULL\' => 1,\n                                            \'TYPE\' => \'MEDIUMTEXT\'\n                                          },\n                                          \'isactive\',\n                                          {\n                                            \'DEFAULT\' => \'TRUE\',\n                                            \'NOTNULL\' => 1,\n                                            \'TYPE\' => \'BOOLEAN\'\n                                          }\n                                        ],\n                            \'INDEXES\' => [\n                                           \'components_product_id_idx\',\n                                           {\n                                             \'FIELDS\' => [\n                                                           \'product_id\',\n                                                           \'name\'\n                                                         ],\n                                             \'TYPE\' => \'UNIQUE\'\n                                           },\n                                           \'components_name_idx\',\n                                           [\n                                             \'name\'\n                                           ]\n                                         ]\n                          },\n          \'dependencies\' => {\n                              \'FIELDS\' => [\n                                            \'blocked\',\n                                            {\n                                              \'NOTNULL\' => 1,\n                                              \'REFERENCES\' => {\n                                                                \'COLUMN\' => \'bug_id\',\n                                                                \'DELETE\' => \'CASCADE\',\n                                                                \'TABLE\' => \'bugs\',\n                                                                \'created\' => 1\n                                                              },\n                                              \'TYPE\' => \'INT3\'\n                                            },\n                                            \'dependson\',\n                                            {\n                                              \'NOTNULL\' => 1,\n                                              \'REFERENCES\' => {\n                                                                \'COLUMN\' => \'bug_id\',\n                                                                \'DELETE\' => \'CASCADE\',\n                                                                \'TABLE\' => \'bugs\',\n                                                                \'created\' => 1\n                                                              },\n                                              \'TYPE\' => \'INT3\'\n                                            }\n                                          ],\n                              \'INDEXES\' => [\n                                             \'dependencies_blocked_idx\',\n                                             {\n                                               \'FIELDS\' => [\n                                                             \'blocked\',\n                                                             \'dependson\'\n                                                           ],\n                                               \'TYPE\' => \'UNIQUE\'\n                                             },\n                                             \'dependencies_dependson_idx\',\n                                             [\n                                               \'dependson\'\n                                             ]\n                                           ]\n                            },\n          \'duplicates\' => {\n                            \'FIELDS\' => [\n                                          \'dupe_of\',\n                                          {\n                                            \'NOTNULL\' => 1,\n                                            \'REFERENCES\' => {\n                                                              \'COLUMN\' => \'bug_id\',\n                                                              \'DELETE\' => \'CASCADE\',\n                                                              \'TABLE\' => \'bugs\',\n                                                              \'created\' => 1\n                                                            },\n                                            \'TYPE\' => \'INT3\'\n                                          },\n                                          \'dupe\',\n                                          {\n                                            \'NOTNULL\' => 1,\n                                            \'PRIMARYKEY\' => 1,\n                                            \'REFERENCES\' => {\n                                                              \'COLUMN\' => \'bug_id\',\n                                                              \'DELETE\' => \'CASCADE\',\n                                                              \'TABLE\' => \'bugs\',\n                                                              \'created\' => 1\n                                                            },\n                                            \'TYPE\' => \'INT3\'\n                                          }\n                                        ]\n                          },\n          \'email_bug_ignore\' => {\n                                  \'FIELDS\' => [\n                                                \'user_id\',\n                                                {\n                                                  \'NOTNULL\' => 1,\n                                                  \'REFERENCES\' => {\n                                                                    \'COLUMN\' => \'userid\',\n                                                                    \'DELETE\' => \'CASCADE\',\n                                                                    \'TABLE\' => \'profiles\',\n                                                                    \'created\' => 1\n                                                                  },\n                                                  \'TYPE\' => \'INT3\'\n                                                },\n                                                \'bug_id\',\n                                                {\n                                                  \'NOTNULL\' => 1,\n                                                  \'REFERENCES\' => {\n                                                                    \'COLUMN\' => \'bug_id\',\n                                                                    \'DELETE\' => \'CASCADE\',\n                                                                    \'TABLE\' => \'bugs\',\n                                                                    \'created\' => 1\n                                                                  },\n                                                  \'TYPE\' => \'INT3\'\n                                                }\n                                              ],\n                                  \'INDEXES\' => [\n                                                 \'email_bug_ignore_user_id_idx\',\n                                                 {\n                                                   \'FIELDS\' => [\n                                                                 \'user_id\',\n                                                                 \'bug_id\'\n                                                               ],\n                                                   \'TYPE\' => \'UNIQUE\'\n                                                 }\n                                               ]\n                                },\n          \'email_setting\' => {\n                               \'FIELDS\' => [\n                                             \'user_id\',\n                                             {\n                                               \'NOTNULL\' => 1,\n                                               \'REFERENCES\' => {\n                                                                 \'COLUMN\' => \'userid\',\n                                                                 \'DELETE\' => \'CASCADE\',\n                                                                 \'TABLE\' => \'profiles\',\n                                                                 \'created\' => 1\n                                                               },\n                                               \'TYPE\' => \'INT3\'\n                                             },\n                                             \'relationship\',\n                                             {\n                                               \'NOTNULL\' => 1,\n                                               \'TYPE\' => \'INT1\'\n                                             },\n                                             \'event\',\n                                             {\n                                               \'NOTNULL\' => 1,\n                                               \'TYPE\' => \'INT1\'\n                                             }\n                                           ],\n                               \'INDEXES\' => [\n                                              \'email_setting_user_id_idx\',\n                                              {\n                                                \'FIELDS\' => [\n                                                              \'user_id\',\n                                                              \'relationship\',\n                                                              \'event\'\n                                                            ],\n                                                \'TYPE\' => \'UNIQUE\'\n                                              }\n                                            ]\n                             },\n          \'field_visibility\' => {\n                                  \'FIELDS\' => [\n                                                \'field_id\',\n                                                {\n                                                  \'REFERENCES\' => {\n                                                                    \'COLUMN\' => \'id\',\n                                                                    \'DELETE\' => \'CASCADE\',\n                                                                    \'TABLE\' => \'fielddefs\',\n                                                                    \'created\' => 1\n                                                                  },\n                                                  \'TYPE\' => \'INT3\'\n                                                },\n                                                \'value_id\',\n                                                {\n                                                  \'NOTNULL\' => 1,\n                                                  \'TYPE\' => \'INT2\'\n                                                }\n                                              ],\n                                  \'INDEXES\' => [\n                                                 \'field_visibility_field_id_idx\',\n                                                 {\n                                                   \'FIELDS\' => [\n                                                                 \'field_id\',\n                                                                 \'value_id\'\n                                                               ],\n                                                   \'TYPE\' => \'UNIQUE\'\n                                                 }\n                                               ]\n                                },\n          \'fielddefs\' => {\n                           \'FIELDS\' => [\n                                         \'id\',\n                                         {\n                                           \'NOTNULL\' => 1,\n                                           \'PRIMARYKEY\' => 1,\n                                           \'TYPE\' => \'MEDIUMSERIAL\'\n                                         },\n                                         \'name\',\n                                         {\n                                           \'NOTNULL\' => 1,\n                                           \'TYPE\' => \'varchar(64)\'\n                                         },\n                                         \'type\',\n                                         {\n                                           \'DEFAULT\' => 0,\n                                           \'NOTNULL\' => 1,\n                                           \'TYPE\' => \'INT2\'\n                                         },\n                                         \'custom\',\n                                         {\n                                           \'DEFAULT\' => \'FALSE\',\n                                           \'NOTNULL\' => 1,\n                                           \'TYPE\' => \'BOOLEAN\'\n                                         },\n                                         \'description\',\n                                         {\n                                           \'NOTNULL\' => 1,\n                                           \'TYPE\' => \'TINYTEXT\'\n                                         },\n                                         \'long_desc\',\n                                         {\n                                           \'DEFAULT\' => \'\\\'\\\'\',\n                                           \'NOTNULL\' => 1,\n                                           \'TYPE\' => \'varchar(255)\'\n                                         },\n                                         \'mailhead\',\n                                         {\n                                           \'DEFAULT\' => \'FALSE\',\n                                           \'NOTNULL\' => 1,\n                                           \'TYPE\' => \'BOOLEAN\'\n                                         },\n                                         \'sortkey\',\n                                         {\n                                           \'NOTNULL\' => 1,\n                                           \'TYPE\' => \'INT2\'\n                                         },\n                                         \'obsolete\',\n                                         {\n                                           \'DEFAULT\' => \'FALSE\',\n                                           \'NOTNULL\' => 1,\n                                           \'TYPE\' => \'BOOLEAN\'\n                                         },\n                                         \'enter_bug\',\n                                         {\n                                           \'DEFAULT\' => \'FALSE\',\n                                           \'NOTNULL\' => 1,\n                                           \'TYPE\' => \'BOOLEAN\'\n                                         },\n                                         \'buglist\',\n                                         {\n                                           \'DEFAULT\' => \'FALSE\',\n                                           \'NOTNULL\' => 1,\n                                           \'TYPE\' => \'BOOLEAN\'\n                                         },\n                                         \'visibility_field_id\',\n                                         {\n                                           \'REFERENCES\' => {\n                                                             \'COLUMN\' => \'id\',\n                                                             \'TABLE\' => \'fielddefs\',\n                                                             \'created\' => 1\n                                                           },\n                                           \'TYPE\' => \'INT3\'\n                                         },\n                                         \'value_field_id\',\n                                         {\n                                           \'REFERENCES\' => {\n                                                             \'COLUMN\' => \'id\',\n                                                             \'TABLE\' => \'fielddefs\',\n                                                             \'created\' => 1\n                                                           },\n                                           \'TYPE\' => \'INT3\'\n                                         },\n                                         \'reverse_desc\',\n                                         {\n                                           \'TYPE\' => \'TINYTEXT\'\n                                         },\n                                         \'is_mandatory\',\n                                         {\n                                           \'DEFAULT\' => \'FALSE\',\n                                           \'NOTNULL\' => 1,\n                                           \'TYPE\' => \'BOOLEAN\'\n                                         },\n                                         \'is_numeric\',\n                                         {\n                                           \'DEFAULT\' => \'FALSE\',\n                                           \'NOTNULL\' => 1,\n                                           \'TYPE\' => \'BOOLEAN\'\n                                         }\n                                       ],\n                           \'INDEXES\' => [\n                                          \'fielddefs_name_idx\',\n                                          {\n                                            \'FIELDS\' => [\n                                                          \'name\'\n                                                        ],\n                                            \'TYPE\' => \'UNIQUE\'\n                                          },\n                                          \'fielddefs_sortkey_idx\',\n                                          [\n                                            \'sortkey\'\n                                          ],\n                                          \'fielddefs_value_field_id_idx\',\n                                          [\n                                            \'value_field_id\'\n                                          ],\n                                          \'fielddefs_is_mandatory_idx\',\n                                          [\n                                            \'is_mandatory\'\n                                          ]\n                                        ]\n                         },\n          \'flagexclusions\' => {\n                                \'FIELDS\' => [\n                                              \'type_id\',\n                                              {\n                                                \'NOTNULL\' => 1,\n                                                \'REFERENCES\' => {\n                                                                  \'COLUMN\' => \'id\',\n                                                                  \'DELETE\' => \'CASCADE\',\n                                                                  \'TABLE\' => \'flagtypes\',\n                                                                  \'created\' => 1\n                                                                },\n                                                \'TYPE\' => \'INT2\'\n                                              },\n                                              \'product_id\',\n                                              {\n                                                \'REFERENCES\' => {\n                                                                  \'COLUMN\' => \'id\',\n                                                                  \'DELETE\' => \'CASCADE\',\n                                                                  \'TABLE\' => \'products\',\n                                                                  \'created\' => 1\n                                                                },\n                                                \'TYPE\' => \'INT2\'\n                                              },\n                                              \'component_id\',\n                                              {\n                                                \'REFERENCES\' => {\n                                                                  \'COLUMN\' => \'id\',\n                                                                  \'DELETE\' => \'CASCADE\',\n                                                                  \'TABLE\' => \'components\',\n                                                                  \'created\' => 1\n                                                                },\n                                                \'TYPE\' => \'INT3\'\n                                              }\n                                            ],\n                                \'INDEXES\' => [\n                                               \'flagexclusions_type_id_idx\',\n                                               {\n                                                 \'FIELDS\' => [\n                                                               \'type_id\',\n                                                               \'product_id\',\n                                                               \'component_id\'\n                                                             ],\n                                                 \'TYPE\' => \'UNIQUE\'\n                                               }\n                                             ]\n                              },\n          \'flaginclusions\' => {\n                                \'FIELDS\' => [\n                                              \'type_id\',\n                                              {\n                                                \'NOTNULL\' => 1,\n                                                \'REFERENCES\' => {\n                                                                  \'COLUMN\' => \'id\',\n                                                                  \'DELETE\' => \'CASCADE\',\n                                                                  \'TABLE\' => \'flagtypes\',\n                                                                  \'created\' => 1\n                                                                },\n                                                \'TYPE\' => \'INT2\'\n                                              },\n                                              \'product_id\',\n                                              {\n                                                \'REFERENCES\' => {\n                                                                  \'COLUMN\' => \'id\',\n                                                                  \'DELETE\' => \'CASCADE\',\n                                                                  \'TABLE\' => \'products\',\n                                                                  \'created\' => 1\n                                                                },\n                                                \'TYPE\' => \'INT2\'\n                                              },\n                                              \'component_id\',\n                                              {\n                                                \'REFERENCES\' => {\n                                                                  \'COLUMN\' => \'id\',\n                                                                  \'DELETE\' => \'CASCADE\',\n                                                                  \'TABLE\' => \'components\',\n                                                                  \'created\' => 1\n                                                                },\n                                                \'TYPE\' => \'INT3\'\n                                              }\n                                            ],\n                                \'INDEXES\' => [\n                                               \'flaginclusions_type_id_idx\',\n                                               {\n                                                 \'FIELDS\' => [\n                                                               \'type_id\',\n                                                               \'product_id\',\n                                                               \'component_id\'\n                                                             ],\n                                                 \'TYPE\' => \'UNIQUE\'\n                                               }\n                                             ]\n                              },\n          \'flags\' => {\n                       \'FIELDS\' => [\n                                     \'id\',\n                                     {\n                                       \'NOTNULL\' => 1,\n                                       \'PRIMARYKEY\' => 1,\n                                       \'TYPE\' => \'MEDIUMSERIAL\'\n                                     },\n                                     \'type_id\',\n                                     {\n                                       \'NOTNULL\' => 1,\n                                       \'REFERENCES\' => {\n                                                         \'COLUMN\' => \'id\',\n                                                         \'DELETE\' => \'CASCADE\',\n                                                         \'TABLE\' => \'flagtypes\',\n                                                         \'created\' => 1\n                                                       },\n                                       \'TYPE\' => \'INT2\'\n                                     },\n                                     \'status\',\n                                     {\n                                       \'NOTNULL\' => 1,\n                                       \'TYPE\' => \'char(1)\'\n                                     },\n                                     \'bug_id\',\n                                     {\n                                       \'NOTNULL\' => 1,\n                                       \'REFERENCES\' => {\n                                                         \'COLUMN\' => \'bug_id\',\n                                                         \'DELETE\' => \'CASCADE\',\n                                                         \'TABLE\' => \'bugs\',\n                                                         \'created\' => 1\n                                                       },\n                                       \'TYPE\' => \'INT3\'\n                                     },\n                                     \'attach_id\',\n                                     {\n                                       \'REFERENCES\' => {\n                                                         \'COLUMN\' => \'attach_id\',\n                                                         \'DELETE\' => \'CASCADE\',\n                                                         \'TABLE\' => \'attachments\',\n                                                         \'created\' => 1\n                                                       },\n                                       \'TYPE\' => \'INT3\'\n                                     },\n                                     \'creation_date\',\n                                     {\n                                       \'NOTNULL\' => 1,\n                                       \'TYPE\' => \'DATETIME\'\n                                     },\n                                     \'modification_date\',\n                                     {\n                                       \'TYPE\' => \'DATETIME\'\n                                     },\n                                     \'setter_id\',\n                                     {\n                                       \'NOTNULL\' => 1,\n                                       \'REFERENCES\' => {\n                                                         \'COLUMN\' => \'userid\',\n                                                         \'TABLE\' => \'profiles\',\n                                                         \'created\' => 1\n                                                       },\n                                       \'TYPE\' => \'INT3\'\n                                     },\n                                     \'requestee_id\',\n                                     {\n                                       \'REFERENCES\' => {\n                                                         \'COLUMN\' => \'userid\',\n                                                         \'TABLE\' => \'profiles\',\n                                                         \'created\' => 1\n                                                       },\n                                       \'TYPE\' => \'INT3\'\n                                     }\n                                   ],\n                       \'INDEXES\' => [\n                                      \'flags_bug_id_idx\',\n                                      [\n                                        \'bug_id\',\n                                        \'attach_id\'\n                                      ],\n                                      \'flags_setter_id_idx\',\n                                      [\n                                        \'setter_id\'\n                                      ],\n                                      \'flags_requestee_id_idx\',\n                                      [\n                                        \'requestee_id\'\n                                      ],\n                                      \'flags_type_id_idx\',\n                                      [\n                                        \'type_id\'\n                                      ]\n                                    ]\n                     },\n          \'flagtypes\' => {\n                           \'FIELDS\' => [\n                                         \'id\',\n                                         {\n                                           \'NOTNULL\' => 1,\n                                           \'PRIMARYKEY\' => 1,\n                                           \'TYPE\' => \'SMALLSERIAL\'\n                                         },\n                                         \'name\',\n                                         {\n                                           \'NOTNULL\' => 1,\n                                           \'TYPE\' => \'varchar(50)\'\n                                         },\n                                         \'description\',\n                                         {\n                                           \'NOTNULL\' => 1,\n                                           \'TYPE\' => \'MEDIUMTEXT\'\n                                         },\n                                         \'cc_list\',\n                                         {\n                                           \'TYPE\' => \'varchar(200)\'\n                                         },\n                                         \'target_type\',\n                                         {\n                                           \'DEFAULT\' => \'\\\'b\\\'\',\n                                           \'NOTNULL\' => 1,\n                                           \'TYPE\' => \'char(1)\'\n                                         },\n                                         \'is_active\',\n                                         {\n                                           \'DEFAULT\' => \'TRUE\',\n                                           \'NOTNULL\' => 1,\n                                           \'TYPE\' => \'BOOLEAN\'\n                                         },\n                                         \'is_requestable\',\n                                         {\n                                           \'DEFAULT\' => \'FALSE\',\n                                           \'NOTNULL\' => 1,\n                                           \'TYPE\' => \'BOOLEAN\'\n                                         },\n                                         \'is_requesteeble\',\n                                         {\n                                           \'DEFAULT\' => \'FALSE\',\n                                           \'NOTNULL\' => 1,\n                                           \'TYPE\' => \'BOOLEAN\'\n                                         },\n                                         \'is_multiplicable\',\n                                         {\n                                           \'DEFAULT\' => \'FALSE\',\n                                           \'NOTNULL\' => 1,\n                                           \'TYPE\' => \'BOOLEAN\'\n                                         },\n                                         \'sortkey\',\n                                         {\n                                           \'DEFAULT\' => \'0\',\n                                           \'NOTNULL\' => 1,\n                                           \'TYPE\' => \'INT2\'\n                                         },\n                                         \'grant_group_id\',\n                                         {\n                                           \'REFERENCES\' => {\n                                                             \'COLUMN\' => \'id\',\n                                                             \'DELETE\' => \'SET NULL\',\n                                                             \'TABLE\' => \'groups\',\n                                                             \'created\' => 1\n                                                           },\n                                           \'TYPE\' => \'INT3\'\n                                         },\n                                         \'request_group_id\',\n                                         {\n                                           \'REFERENCES\' => {\n                                                             \'COLUMN\' => \'id\',\n                                                             \'DELETE\' => \'SET NULL\',\n                                                             \'TABLE\' => \'groups\',\n                                                             \'created\' => 1\n                                                           },\n                                           \'TYPE\' => \'INT3\'\n                                         }\n                                       ]\n                         },\n          \'group_control_map\' => {\n                                   \'FIELDS\' => [\n                                                 \'group_id\',\n                                                 {\n                                                   \'NOTNULL\' => 1,\n                                                   \'REFERENCES\' => {\n                                                                     \'COLUMN\' => \'id\',\n                                                                     \'DELETE\' => \'CASCADE\',\n                                                                     \'TABLE\' => \'groups\',\n                                                                     \'created\' => 1\n                                                                   },\n                                                   \'TYPE\' => \'INT3\'\n                                                 },\n                                                 \'product_id\',\n                                                 {\n                                                   \'NOTNULL\' => 1,\n                                                   \'REFERENCES\' => {\n                                                                     \'COLUMN\' => \'id\',\n                                                                     \'DELETE\' => \'CASCADE\',\n                                                                     \'TABLE\' => \'products\',\n                                                                     \'created\' => 1\n                                                                   },\n                                                   \'TYPE\' => \'INT2\'\n                                                 },\n                                                 \'entry\',\n                                                 {\n                                                   \'DEFAULT\' => \'FALSE\',\n                                                   \'NOTNULL\' => 1,\n                                                   \'TYPE\' => \'BOOLEAN\'\n                                                 },\n                                                 \'membercontrol\',\n                                                 {\n                                                   \'DEFAULT\' => \'0\',\n                                                   \'NOTNULL\' => 1,\n                                                   \'TYPE\' => \'INT1\'\n                                                 },\n                                                 \'othercontrol\',\n                                                 {\n                                                   \'DEFAULT\' => \'0\',\n                                                   \'NOTNULL\' => 1,\n                                                   \'TYPE\' => \'INT1\'\n                                                 },\n                                                 \'canedit\',\n                                                 {\n                                                   \'DEFAULT\' => \'FALSE\',\n                                                   \'NOTNULL\' => 1,\n                                                   \'TYPE\' => \'BOOLEAN\'\n                                                 },\n                                                 \'editcomponents\',\n                                                 {\n                                                   \'DEFAULT\' => \'FALSE\',\n                                                   \'NOTNULL\' => 1,\n                                                   \'TYPE\' => \'BOOLEAN\'\n                                                 },\n                                                 \'editbugs\',\n                                                 {\n                                                   \'DEFAULT\' => \'FALSE\',\n                                                   \'NOTNULL\' => 1,\n                                                   \'TYPE\' => \'BOOLEAN\'\n                                                 },\n                                                 \'canconfirm\',\n                                                 {\n                                                   \'DEFAULT\' => \'FALSE\',\n                                                   \'NOTNULL\' => 1,\n                                                   \'TYPE\' => \'BOOLEAN\'\n                                                 }\n                                               ],\n                                   \'INDEXES\' => [\n                                                  \'group_control_map_product_id_idx\',\n                                                  {\n                                                    \'FIELDS\' => [\n                                                                  \'product_id\',\n                                                                  \'group_id\'\n                                                                ],\n                                                    \'TYPE\' => \'UNIQUE\'\n                                                  },\n                                                  \'group_control_map_group_id_idx\',\n                                                  [\n                                                    \'group_id\'\n                                                  ]\n                                                ]\n                                 },\n          \'group_group_map\' => {\n                                 \'FIELDS\' => [\n                                               \'member_id\',\n                                               {\n                                                 \'NOTNULL\' => 1,\n                                                 \'REFERENCES\' => {\n                                                                   \'COLUMN\' => \'id\',\n                                                                   \'DELETE\' => \'CASCADE\',\n                                                                   \'TABLE\' => \'groups\',\n                                                                   \'created\' => 1\n                                                                 },\n                                                 \'TYPE\' => \'INT3\'\n                                               },\n                                               \'grantor_id\',\n                                               {\n                                                 \'NOTNULL\' => 1,\n                                                 \'REFERENCES\' => {\n                                                                   \'COLUMN\' => \'id\',\n                                                                   \'DELETE\' => \'CASCADE\',\n                                                                   \'TABLE\' => \'groups\',\n                                                                   \'created\' => 1\n                                                                 },\n                                                 \'TYPE\' => \'INT3\'\n                                               },\n                                               \'grant_type\',\n                                               {\n                                                 \'DEFAULT\' => \'0\',\n                                                 \'NOTNULL\' => 1,\n                                                 \'TYPE\' => \'INT1\'\n                                               }\n                                             ],\n                                 \'INDEXES\' => [\n                                                \'group_group_map_member_id_idx\',\n                                                {\n                                                  \'FIELDS\' => [\n                                                                \'member_id\',\n                                                                \'grantor_id\',\n                                                                \'grant_type\'\n                                                              ],\n                                                  \'TYPE\' => \'UNIQUE\'\n                                                }\n                                              ]\n                               },\n          \'groups\' => {\n                        \'FIELDS\' => [\n                                      \'id\',\n                                      {\n                                        \'NOTNULL\' => 1,\n                                        \'PRIMARYKEY\' => 1,\n                                        \'TYPE\' => \'MEDIUMSERIAL\'\n                                      },\n                                      \'name\',\n                                      {\n                                        \'NOTNULL\' => 1,\n                                        \'TYPE\' => \'varchar(255)\'\n                                      },\n                                      \'description\',\n                                      {\n                                        \'NOTNULL\' => 1,\n                                        \'TYPE\' => \'MEDIUMTEXT\'\n                                      },\n                                      \'isbuggroup\',\n                                      {\n                                        \'NOTNULL\' => 1,\n                                        \'TYPE\' => \'BOOLEAN\'\n                                      },\n                                      \'userregexp\',\n                                      {\n                                        \'DEFAULT\' => \'\\\'\\\'\',\n                                        \'NOTNULL\' => 1,\n                                        \'TYPE\' => \'TINYTEXT\'\n                                      },\n                                      \'isactive\',\n                                      {\n                                        \'DEFAULT\' => \'TRUE\',\n                                        \'NOTNULL\' => 1,\n                                        \'TYPE\' => \'BOOLEAN\'\n                                      },\n                                      \'icon_url\',\n                                      {\n                                        \'TYPE\' => \'TINYTEXT\'\n                                      }\n                                    ],\n                        \'INDEXES\' => [\n                                       \'groups_name_idx\',\n                                       {\n                                         \'FIELDS\' => [\n                                                       \'name\'\n                                                     ],\n                                         \'TYPE\' => \'UNIQUE\'\n                                       }\n                                     ]\n                      },\n          \'keyworddefs\' => {\n                             \'FIELDS\' => [\n                                           \'id\',\n                                           {\n                                             \'NOTNULL\' => 1,\n                                             \'PRIMARYKEY\' => 1,\n                                             \'TYPE\' => \'SMALLSERIAL\'\n                                           },\n                                           \'name\',\n                                           {\n                                             \'NOTNULL\' => 1,\n                                             \'TYPE\' => \'varchar(64)\'\n                                           },\n                                           \'description\',\n                                           {\n                                             \'NOTNULL\' => 1,\n                                             \'TYPE\' => \'MEDIUMTEXT\'\n                                           }\n                                         ],\n                             \'INDEXES\' => [\n                                            \'keyworddefs_name_idx\',\n                                            {\n                                              \'FIELDS\' => [\n                                                            \'name\'\n                                                          ],\n                                              \'TYPE\' => \'UNIQUE\'\n                                            }\n                                          ]\n                           },\n          \'keywords\' => {\n                          \'FIELDS\' => [\n                                        \'bug_id\',\n                                        {\n                                          \'NOTNULL\' => 1,\n                                          \'REFERENCES\' => {\n                                                            \'COLUMN\' => \'bug_id\',\n                                                            \'DELETE\' => \'CASCADE\',\n                                                            \'TABLE\' => \'bugs\',\n                                                            \'created\' => 1\n                                                          },\n                                          \'TYPE\' => \'INT3\'\n                                        },\n                                        \'keywordid\',\n                                        {\n                                          \'NOTNULL\' => 1,\n                                          \'REFERENCES\' => {\n                                                            \'COLUMN\' => \'id\',\n                                                            \'DELETE\' => \'CASCADE\',\n                                                            \'TABLE\' => \'keyworddefs\',\n                                                            \'created\' => 1\n                                                          },\n                                          \'TYPE\' => \'INT2\'\n                                        }\n                                      ],\n                          \'INDEXES\' => [\n                                         \'keywords_bug_id_idx\',\n                                         {\n                                           \'FIELDS\' => [\n                                                         \'bug_id\',\n                                                         \'keywordid\'\n                                                       ],\n                                           \'TYPE\' => \'UNIQUE\'\n                                         },\n                                         \'keywords_keywordid_idx\',\n                                         [\n                                           \'keywordid\'\n                                         ]\n                                       ]\n                        },\n          \'login_failure\' => {\n                               \'FIELDS\' => [\n                                             \'user_id\',\n                                             {\n                                               \'NOTNULL\' => 1,\n                                               \'REFERENCES\' => {\n                                                                 \'COLUMN\' => \'userid\',\n                                                                 \'DELETE\' => \'CASCADE\',\n                                                                 \'TABLE\' => \'profiles\',\n                                                                 \'created\' => 1\n                                                               },\n                                               \'TYPE\' => \'INT3\'\n                                             },\n                                             \'login_time\',\n                                             {\n                                               \'NOTNULL\' => 1,\n                                               \'TYPE\' => \'DATETIME\'\n                                             },\n                                             \'ip_addr\',\n                                             {\n                                               \'NOTNULL\' => 1,\n                                               \'TYPE\' => \'varchar(40)\'\n                                             }\n                                           ],\n                               \'INDEXES\' => [\n                                              \'login_failure_user_id_idx\',\n                                              [\n                                                \'user_id\'\n                                              ]\n                                            ]\n                             },\n          \'logincookies\' => {\n                              \'FIELDS\' => [\n                                            \'cookie\',\n                                            {\n                                              \'NOTNULL\' => 1,\n                                              \'PRIMARYKEY\' => 1,\n                                              \'TYPE\' => \'varchar(16)\'\n                                            },\n                                            \'userid\',\n                                            {\n                                              \'NOTNULL\' => 1,\n                                              \'REFERENCES\' => {\n                                                                \'COLUMN\' => \'userid\',\n                                                                \'DELETE\' => \'CASCADE\',\n                                                                \'TABLE\' => \'profiles\',\n                                                                \'created\' => 1\n                                                              },\n                                              \'TYPE\' => \'INT3\'\n                                            },\n                                            \'ipaddr\',\n                                            {\n                                              \'TYPE\' => \'varchar(40)\'\n                                            },\n                                            \'lastused\',\n                                            {\n                                              \'NOTNULL\' => 1,\n                                              \'TYPE\' => \'DATETIME\'\n                                            }\n                                          ],\n                              \'INDEXES\' => [\n                                             \'logincookies_lastused_idx\',\n                                             [\n                                               \'lastused\'\n                                             ]\n                                           ]\n                            },\n          \'longdescs\' => {\n                           \'FIELDS\' => [\n                                         \'comment_id\',\n                                         {\n                                           \'NOTNULL\' => 1,\n                                           \'PRIMARYKEY\' => 1,\n                                           \'TYPE\' => \'INTSERIAL\'\n                                         },\n                                         \'bug_id\',\n                                         {\n                                           \'NOTNULL\' => 1,\n                                           \'REFERENCES\' => {\n                                                             \'COLUMN\' => \'bug_id\',\n                                                             \'DELETE\' => \'CASCADE\',\n                                                             \'TABLE\' => \'bugs\',\n                                                             \'created\' => 1\n                                                           },\n                                           \'TYPE\' => \'INT3\'\n                                         },\n                                         \'who\',\n                                         {\n                                           \'NOTNULL\' => 1,\n                                           \'REFERENCES\' => {\n                                                             \'COLUMN\' => \'userid\',\n                                                             \'TABLE\' => \'profiles\',\n                                                             \'created\' => 1\n                                                           },\n                                           \'TYPE\' => \'INT3\'\n                                         },\n                                         \'bug_when\',\n                                         {\n                                           \'NOTNULL\' => 1,\n                                           \'TYPE\' => \'DATETIME\'\n                                         },\n                                         \'work_time\',\n                                         {\n                                           \'DEFAULT\' => \'0\',\n                                           \'NOTNULL\' => 1,\n                                           \'TYPE\' => \'decimal(7,2)\'\n                                         },\n                                         \'thetext\',\n                                         {\n                                           \'NOTNULL\' => 1,\n                                           \'TYPE\' => \'LONGTEXT\'\n                                         },\n                                         \'isprivate\',\n                                         {\n                                           \'DEFAULT\' => \'FALSE\',\n                                           \'NOTNULL\' => 1,\n                                           \'TYPE\' => \'BOOLEAN\'\n                                         },\n                                         \'already_wrapped\',\n                                         {\n                                           \'DEFAULT\' => \'FALSE\',\n                                           \'NOTNULL\' => 1,\n                                           \'TYPE\' => \'BOOLEAN\'\n                                         },\n                                         \'type\',\n                                         {\n                                           \'DEFAULT\' => \'0\',\n                                           \'NOTNULL\' => 1,\n                                           \'TYPE\' => \'INT2\'\n                                         },\n                                         \'extra_data\',\n                                         {\n                                           \'TYPE\' => \'varchar(255)\'\n                                         }\n                                       ],\n                           \'INDEXES\' => [\n                                          \'longdescs_bug_id_idx\',\n                                          [\n                                            \'bug_id\',\n                                            \'work_time\'\n                                          ],\n                                          \'longdescs_who_idx\',\n                                          [\n                                            \'who\',\n                                            \'bug_id\'\n                                          ],\n                                          \'longdescs_bug_when_idx\',\n                                          [\n                                            \'bug_when\'\n                                          ]\n                                        ]\n                         },\n          \'longdescs_tags\' => {\n                                \'FIELDS\' => [\n                                              \'id\',\n                                              {\n                                                \'NOTNULL\' => 1,\n                                                \'PRIMARYKEY\' => 1,\n                                                \'TYPE\' => \'MEDIUMSERIAL\'\n                                              },\n                                              \'comment_id\',\n                                              {\n                                                \'REFERENCES\' => {\n                                                                  \'COLUMN\' => \'comment_id\',\n                                                                  \'DELETE\' => \'CASCADE\',\n                                                                  \'TABLE\' => \'longdescs\',\n                                                                  \'created\' => 1\n                                                                },\n                                                \'TYPE\' => \'INT4\'\n                                              },\n                                              \'tag\',\n                                              {\n                                                \'NOTNULL\' => 1,\n                                                \'TYPE\' => \'varchar(24)\'\n                                              }\n                                            ],\n                                \'INDEXES\' => [\n                                               \'longdescs_tags_idx\',\n                                               {\n                                                 \'FIELDS\' => [\n                                                               \'comment_id\',\n                                                               \'tag\'\n                                                             ],\n                                                 \'TYPE\' => \'UNIQUE\'\n                                               }\n                                             ]\n                              },\n          \'longdescs_tags_activity\' => {\n                                         \'FIELDS\' => [\n                                                       \'id\',\n                                                       {\n                                                         \'NOTNULL\' => 1,\n                                                         \'PRIMARYKEY\' => 1,\n                                                         \'TYPE\' => \'MEDIUMSERIAL\'\n                                                       },\n                                                       \'bug_id\',\n                                                       {\n                                                         \'NOTNULL\' => 1,\n                                                         \'REFERENCES\' => {\n                                                                           \'COLUMN\' => \'bug_id\',\n                                                                           \'DELETE\' => \'CASCADE\',\n                                                                           \'TABLE\' => \'bugs\',\n                                                                           \'created\' => 1\n                                                                         },\n                                                         \'TYPE\' => \'INT3\'\n                                                       },\n                                                       \'comment_id\',\n                                                       {\n                                                         \'REFERENCES\' => {\n                                                                           \'COLUMN\' => \'comment_id\',\n                                                                           \'DELETE\' => \'CASCADE\',\n                                                                           \'TABLE\' => \'longdescs\',\n                                                                           \'created\' => 1\n                                                                         },\n                                                         \'TYPE\' => \'INT4\'\n                                                       },\n                                                       \'who\',\n                                                       {\n                                                         \'NOTNULL\' => 1,\n                                                         \'REFERENCES\' => {\n                                                                           \'COLUMN\' => \'userid\',\n                                                                           \'TABLE\' => \'profiles\',\n                                                                           \'created\' => 1\n                                                                         },\n                                                         \'TYPE\' => \'INT3\'\n                                                       },\n                                                       \'bug_when\',\n                                                       {\n                                                         \'NOTNULL\' => 1,\n                                                         \'TYPE\' => \'DATETIME\'\n                                                       },\n                                                       \'added\',\n                                                       {\n                                                         \'TYPE\' => \'varchar(24)\'\n                                                       },\n                                                       \'removed\',\n                                                       {\n                                                         \'TYPE\' => \'varchar(24)\'\n                                                       }\n                                                     ],\n                                         \'INDEXES\' => [\n                                                        \'longdescs_tags_activity_bug_id_idx\',\n                                                        [\n                                                          \'bug_id\'\n                                                        ]\n                                                      ]\n                                       },\n          \'longdescs_tags_weights\' => {\n                                        \'FIELDS\' => [\n                                                      \'id\',\n                                                      {\n                                                        \'NOTNULL\' => 1,\n                                                        \'PRIMARYKEY\' => 1,\n                                                        \'TYPE\' => \'MEDIUMSERIAL\'\n                                                      },\n                                                      \'tag\',\n                                                      {\n                                                        \'NOTNULL\' => 1,\n                                                        \'TYPE\' => \'varchar(24)\'\n                                                      },\n                                                      \'weight\',\n                                                      {\n                                                        \'NOTNULL\' => 1,\n                                                        \'TYPE\' => \'INT3\'\n                                                      }\n                                                    ],\n                                        \'INDEXES\' => [\n                                                       \'longdescs_tags_weights_tag_idx\',\n                                                       {\n                                                         \'FIELDS\' => [\n                                                                       \'tag\'\n                                                                     ],\n                                                         \'TYPE\' => \'UNIQUE\'\n                                                       }\n                                                     ]\n                                      },\n          \'mail_staging\' => {\n                              \'FIELDS\' => [\n                                            \'id\',\n                                            {\n                                              \'NOTNULL\' => 1,\n                                              \'PRIMARYKEY\' => 1,\n                                              \'TYPE\' => \'INTSERIAL\'\n                                            },\n                                            \'message\',\n                                            {\n                                              \'NOTNULL\' => 1,\n                                              \'TYPE\' => \'LONGBLOB\'\n                                            }\n                                          ]\n                            },\n          \'milestones\' => {\n                            \'FIELDS\' => [\n                                          \'id\',\n                                          {\n                                            \'NOTNULL\' => 1,\n                                            \'PRIMARYKEY\' => 1,\n                                            \'TYPE\' => \'MEDIUMSERIAL\'\n                                          },\n                                          \'product_id\',\n                                          {\n                                            \'NOTNULL\' => 1,\n                                            \'REFERENCES\' => {\n                                                              \'COLUMN\' => \'id\',\n                                                              \'DELETE\' => \'CASCADE\',\n                                                              \'TABLE\' => \'products\',\n                                                              \'created\' => 1\n                                                            },\n                                            \'TYPE\' => \'INT2\'\n                                          },\n                                          \'value\',\n                                          {\n                                            \'NOTNULL\' => 1,\n                                            \'TYPE\' => \'varchar(64)\'\n                                          },\n                                          \'sortkey\',\n                                          {\n                                            \'DEFAULT\' => 0,\n                                            \'NOTNULL\' => 1,\n                                            \'TYPE\' => \'INT2\'\n                                          },\n                                          \'isactive\',\n                                          {\n                                            \'DEFAULT\' => \'TRUE\',\n                                            \'NOTNULL\' => 1,\n                                            \'TYPE\' => \'BOOLEAN\'\n                                          }\n                                        ],\n                            \'INDEXES\' => [\n                                           \'milestones_product_id_idx\',\n                                           {\n                                             \'FIELDS\' => [\n                                                           \'product_id\',\n                                                           \'value\'\n                                                         ],\n                                             \'TYPE\' => \'UNIQUE\'\n                                           }\n                                         ]\n                          },\n          \'namedqueries\' => {\n                              \'FIELDS\' => [\n                                            \'id\',\n                                            {\n                                              \'NOTNULL\' => 1,\n                                              \'PRIMARYKEY\' => 1,\n                                              \'TYPE\' => \'MEDIUMSERIAL\'\n                                            },\n                                            \'userid\',\n                                            {\n                                              \'NOTNULL\' => 1,\n                                              \'REFERENCES\' => {\n                                                                \'COLUMN\' => \'userid\',\n                                                                \'DELETE\' => \'CASCADE\',\n                                                                \'TABLE\' => \'profiles\',\n                                                                \'created\' => 1\n                                                              },\n                                              \'TYPE\' => \'INT3\'\n                                            },\n                                            \'name\',\n                                            {\n                                              \'NOTNULL\' => 1,\n                                              \'TYPE\' => \'varchar(64)\'\n                                            },\n                                            \'query\',\n                                            {\n                                              \'NOTNULL\' => 1,\n                                              \'TYPE\' => \'LONGTEXT\'\n                                            }\n                                          ],\n                              \'INDEXES\' => [\n                                             \'namedqueries_userid_idx\',\n                                             {\n                                               \'FIELDS\' => [\n                                                             \'userid\',\n                                                             \'name\'\n                                                           ],\n                                               \'TYPE\' => \'UNIQUE\'\n                                             }\n                                           ]\n                            },\n          \'namedqueries_link_in_footer\' => {\n                                             \'FIELDS\' => [\n                                                           \'namedquery_id\',\n                                                           {\n                                                             \'NOTNULL\' => 1,\n                                                             \'REFERENCES\' => {\n                                                                               \'COLUMN\' => \'id\',\n                                                                               \'DELETE\' => \'CASCADE\',\n                                                                               \'TABLE\' => \'namedqueries\',\n                                                                               \'created\' => 1\n                                                                             },\n                                                             \'TYPE\' => \'INT3\'\n                                                           },\n                                                           \'user_id\',\n                                                           {\n                                                             \'NOTNULL\' => 1,\n                                                             \'REFERENCES\' => {\n                                                                               \'COLUMN\' => \'userid\',\n                                                                               \'DELETE\' => \'CASCADE\',\n                                                                               \'TABLE\' => \'profiles\',\n                                                                               \'created\' => 1\n                                                                             },\n                                                             \'TYPE\' => \'INT3\'\n                                                           }\n                                                         ],\n                                             \'INDEXES\' => [\n                                                            \'namedqueries_link_in_footer_id_idx\',\n                                                            {\n                                                              \'FIELDS\' => [\n                                                                            \'namedquery_id\',\n                                                                            \'user_id\'\n                                                                          ],\n                                                              \'TYPE\' => \'UNIQUE\'\n                                                            },\n                                                            \'namedqueries_link_in_footer_userid_idx\',\n                                                            [\n                                                              \'user_id\'\n                                                            ]\n                                                          ]\n                                           },\n          \'namedquery_group_map\' => {\n                                      \'FIELDS\' => [\n                                                    \'namedquery_id\',\n                                                    {\n                                                      \'NOTNULL\' => 1,\n                                                      \'REFERENCES\' => {\n                                                                        \'COLUMN\' => \'id\',\n                                                                        \'DELETE\' => \'CASCADE\',\n                                                                        \'TABLE\' => \'namedqueries\',\n                                                                        \'created\' => 1\n                                                                      },\n                                                      \'TYPE\' => \'INT3\'\n                                                    },\n                                                    \'group_id\',\n                                                    {\n                                                      \'NOTNULL\' => 1,\n                                                      \'REFERENCES\' => {\n                                                                        \'COLUMN\' => \'id\',\n                                                                        \'DELETE\' => \'CASCADE\',\n                                                                        \'TABLE\' => \'groups\',\n                                                                        \'created\' => 1\n                                                                      },\n                                                      \'TYPE\' => \'INT3\'\n                                                    }\n                                                  ],\n                                      \'INDEXES\' => [\n                                                     \'namedquery_group_map_namedquery_id_idx\',\n                                                     {\n                                                       \'FIELDS\' => [\n                                                                     \'namedquery_id\'\n                                                                   ],\n                                                       \'TYPE\' => \'UNIQUE\'\n                                                     },\n                                                     \'namedquery_group_map_group_id_idx\',\n                                                     [\n                                                       \'group_id\'\n                                                     ]\n                                                   ]\n                                    },\n          \'op_sys\' => {\n                        \'FIELDS\' => [\n                                      \'id\',\n                                      {\n                                        \'NOTNULL\' => 1,\n                                        \'PRIMARYKEY\' => 1,\n                                        \'TYPE\' => \'SMALLSERIAL\'\n                                      },\n                                      \'value\',\n                                      {\n                                        \'NOTNULL\' => 1,\n                                        \'TYPE\' => \'varchar(64)\'\n                                      },\n                                      \'sortkey\',\n                                      {\n                                        \'DEFAULT\' => 0,\n                                        \'NOTNULL\' => 1,\n                                        \'TYPE\' => \'INT2\'\n                                      },\n                                      \'isactive\',\n                                      {\n                                        \'DEFAULT\' => \'TRUE\',\n                                        \'NOTNULL\' => 1,\n                                        \'TYPE\' => \'BOOLEAN\'\n                                      },\n                                      \'visibility_value_id\',\n                                      {\n                                        \'TYPE\' => \'INT2\'\n                                      }\n                                    ],\n                        \'INDEXES\' => [\n                                       \'op_sys_value_idx\',\n                                       {\n                                         \'FIELDS\' => [\n                                                       \'value\'\n                                                     ],\n                                         \'TYPE\' => \'UNIQUE\'\n                                       },\n                                       \'op_sys_sortkey_idx\',\n                                       [\n                                         \'sortkey\',\n                                         \'value\'\n                                       ],\n                                       \'op_sys_visibility_value_id_idx\',\n                                       [\n                                         \'visibility_value_id\'\n                                       ]\n                                     ]\n                      },\n          \'priority\' => {\n                          \'FIELDS\' => [\n                                        \'id\',\n                                        {\n                                          \'NOTNULL\' => 1,\n                                          \'PRIMARYKEY\' => 1,\n                                          \'TYPE\' => \'SMALLSERIAL\'\n                                        },\n                                        \'value\',\n                                        {\n                                          \'NOTNULL\' => 1,\n                                          \'TYPE\' => \'varchar(64)\'\n                                        },\n                                        \'sortkey\',\n                                        {\n                                          \'DEFAULT\' => 0,\n                                          \'NOTNULL\' => 1,\n                                          \'TYPE\' => \'INT2\'\n                                        },\n                                        \'isactive\',\n                                        {\n                                          \'DEFAULT\' => \'TRUE\',\n                                          \'NOTNULL\' => 1,\n                                          \'TYPE\' => \'BOOLEAN\'\n                                        },\n                                        \'visibility_value_id\',\n                                        {\n                                          \'TYPE\' => \'INT2\'\n                                        }\n                                      ],\n                          \'INDEXES\' => [\n                                         \'priority_value_idx\',\n                                         {\n                                           \'FIELDS\' => [\n                                                         \'value\'\n                                                       ],\n                                           \'TYPE\' => \'UNIQUE\'\n                                         },\n                                         \'priority_sortkey_idx\',\n                                         [\n                                           \'sortkey\',\n                                           \'value\'\n                                         ],\n                                         \'priority_visibility_value_id_idx\',\n                                         [\n                                           \'visibility_value_id\'\n                                         ]\n                                       ]\n                        },\n          \'products\' => {\n                          \'FIELDS\' => [\n                                        \'id\',\n                                        {\n                                          \'NOTNULL\' => 1,\n                                          \'PRIMARYKEY\' => 1,\n                                          \'TYPE\' => \'SMALLSERIAL\'\n                                        },\n                                        \'name\',\n                                        {\n                                          \'NOTNULL\' => 1,\n                                          \'TYPE\' => \'varchar(64)\'\n                                        },\n                                        \'classification_id\',\n                                        {\n                                          \'DEFAULT\' => \'1\',\n                                          \'NOTNULL\' => 1,\n                                          \'REFERENCES\' => {\n                                                            \'COLUMN\' => \'id\',\n                                                            \'DELETE\' => \'CASCADE\',\n                                                            \'TABLE\' => \'classifications\',\n                                                            \'created\' => 1\n                                                          },\n                                          \'TYPE\' => \'INT2\'\n                                        },\n                                        \'description\',\n                                        {\n                                          \'NOTNULL\' => 1,\n                                          \'TYPE\' => \'MEDIUMTEXT\'\n                                        },\n                                        \'isactive\',\n                                        {\n                                          \'DEFAULT\' => 1,\n                                          \'NOTNULL\' => 1,\n                                          \'TYPE\' => \'BOOLEAN\'\n                                        },\n                                        \'defaultmilestone\',\n                                        {\n                                          \'DEFAULT\' => \'\\\'---\\\'\',\n                                          \'NOTNULL\' => 1,\n                                          \'TYPE\' => \'varchar(64)\'\n                                        },\n                                        \'allows_unconfirmed\',\n                                        {\n                                          \'DEFAULT\' => \'TRUE\',\n                                          \'NOTNULL\' => 1,\n                                          \'TYPE\' => \'BOOLEAN\'\n                                        }\n                                      ],\n                          \'INDEXES\' => [\n                                         \'products_name_idx\',\n                                         {\n                                           \'FIELDS\' => [\n                                                         \'name\'\n                                                       ],\n                                           \'TYPE\' => \'UNIQUE\'\n                                         }\n                                       ]\n                        },\n          \'profile_search\' => {\n                                \'FIELDS\' => [\n                                              \'id\',\n                                              {\n                                                \'NOTNULL\' => 1,\n                                                \'PRIMARYKEY\' => 1,\n                                                \'TYPE\' => \'INTSERIAL\'\n                                              },\n                                              \'user_id\',\n                                              {\n                                                \'NOTNULL\' => 1,\n                                                \'REFERENCES\' => {\n                                                                  \'COLUMN\' => \'userid\',\n                                                                  \'DELETE\' => \'CASCADE\',\n                                                                  \'TABLE\' => \'profiles\',\n                                                                  \'created\' => 1\n                                                                },\n                                                \'TYPE\' => \'INT3\'\n                                              },\n                                              \'bug_list\',\n                                              {\n                                                \'NOTNULL\' => 1,\n                                                \'TYPE\' => \'MEDIUMTEXT\'\n                                              },\n                                              \'list_order\',\n                                              {\n                                                \'TYPE\' => \'MEDIUMTEXT\'\n                                              }\n                                            ],\n                                \'INDEXES\' => [\n                                               \'profile_search_user_id_idx\',\n                                               [\n                                                 \'user_id\'\n                                               ]\n                                             ]\n                              },\n          \'profile_setting\' => {\n                                 \'FIELDS\' => [\n                                               \'user_id\',\n                                               {\n                                                 \'NOTNULL\' => 1,\n                                                 \'REFERENCES\' => {\n                                                                   \'COLUMN\' => \'userid\',\n                                                                   \'DELETE\' => \'CASCADE\',\n                                                                   \'TABLE\' => \'profiles\',\n                                                                   \'created\' => 1\n                                                                 },\n                                                 \'TYPE\' => \'INT3\'\n                                               },\n                                               \'setting_name\',\n                                               {\n                                                 \'NOTNULL\' => 1,\n                                                 \'REFERENCES\' => {\n                                                                   \'COLUMN\' => \'name\',\n                                                                   \'DELETE\' => \'CASCADE\',\n                                                                   \'TABLE\' => \'setting\',\n                                                                   \'created\' => 1\n                                                                 },\n                                                 \'TYPE\' => \'varchar(32)\'\n                                               },\n                                               \'setting_value\',\n                                               {\n                                                 \'NOTNULL\' => 1,\n                                                 \'TYPE\' => \'varchar(32)\'\n                                               }\n                                             ],\n                                 \'INDEXES\' => [\n                                                \'profile_setting_value_unique_idx\',\n                                                {\n                                                  \'FIELDS\' => [\n                                                                \'user_id\',\n                                                                \'setting_name\'\n                                                              ],\n                                                  \'TYPE\' => \'UNIQUE\'\n                                                }\n                                              ]\n                               },\n          \'profiles\' => {\n                          \'FIELDS\' => [\n                                        \'userid\',\n                                        {\n                                          \'NOTNULL\' => 1,\n                                          \'PRIMARYKEY\' => 1,\n                                          \'TYPE\' => \'MEDIUMSERIAL\'\n                                        },\n                                        \'login_name\',\n                                        {\n                                          \'NOTNULL\' => 1,\n                                          \'TYPE\' => \'varchar(255)\'\n                                        },\n                                        \'cryptpassword\',\n                                        {\n                                          \'TYPE\' => \'varchar(128)\'\n                                        },\n                                        \'realname\',\n                                        {\n                                          \'DEFAULT\' => \'\\\'\\\'\',\n                                          \'NOTNULL\' => 1,\n                                          \'TYPE\' => \'varchar(255)\'\n                                        },\n                                        \'disabledtext\',\n                                        {\n                                          \'DEFAULT\' => \'\\\'\\\'\',\n                                          \'NOTNULL\' => 1,\n                                          \'TYPE\' => \'MEDIUMTEXT\'\n                                        },\n                                        \'disable_mail\',\n                                        {\n                                          \'DEFAULT\' => \'FALSE\',\n                                          \'NOTNULL\' => 1,\n                                          \'TYPE\' => \'BOOLEAN\'\n                                        },\n                                        \'mybugslink\',\n                                        {\n                                          \'DEFAULT\' => \'TRUE\',\n                                          \'NOTNULL\' => 1,\n                                          \'TYPE\' => \'BOOLEAN\'\n                                        },\n                                        \'extern_id\',\n                                        {\n                                          \'TYPE\' => \'varchar(64)\'\n                                        },\n                                        \'is_enabled\',\n                                        {\n                                          \'DEFAULT\' => \'TRUE\',\n                                          \'NOTNULL\' => 1,\n                                          \'TYPE\' => \'BOOLEAN\'\n                                        },\n                                        \'last_seen_date\',\n                                        {\n                                          \'TYPE\' => \'DATETIME\'\n                                        }\n                                      ],\n                          \'INDEXES\' => [\n                                         \'profiles_login_name_idx\',\n                                         {\n                                           \'FIELDS\' => [\n                                                         \'login_name\'\n                                                       ],\n                                           \'TYPE\' => \'UNIQUE\'\n                                         },\n                                         \'profiles_extern_id_idx\',\n                                         {\n                                           \'FIELDS\' => [\n                                                         \'extern_id\'\n                                                       ],\n                                           \'TYPE\' => \'UNIQUE\'\n                                         }\n                                       ]\n                        },\n          \'profiles_activity\' => {\n                                   \'FIELDS\' => [\n                                                 \'id\',\n                                                 {\n                                                   \'NOTNULL\' => 1,\n                                                   \'PRIMARYKEY\' => 1,\n                                                   \'TYPE\' => \'MEDIUMSERIAL\'\n                                                 },\n                                                 \'userid\',\n                                                 {\n                                                   \'NOTNULL\' => 1,\n                                                   \'REFERENCES\' => {\n                                                                     \'COLUMN\' => \'userid\',\n                                                                     \'DELETE\' => \'CASCADE\',\n                                                                     \'TABLE\' => \'profiles\',\n                                                                     \'created\' => 1\n                                                                   },\n                                                   \'TYPE\' => \'INT3\'\n                                                 },\n                                                 \'who\',\n                                                 {\n                                                   \'NOTNULL\' => 1,\n                                                   \'REFERENCES\' => {\n                                                                     \'COLUMN\' => \'userid\',\n                                                                     \'TABLE\' => \'profiles\',\n                                                                     \'created\' => 1\n                                                                   },\n                                                   \'TYPE\' => \'INT3\'\n                                                 },\n                                                 \'profiles_when\',\n                                                 {\n                                                   \'NOTNULL\' => 1,\n                                                   \'TYPE\' => \'DATETIME\'\n                                                 },\n                                                 \'fieldid\',\n                                                 {\n                                                   \'NOTNULL\' => 1,\n                                                   \'REFERENCES\' => {\n                                                                     \'COLUMN\' => \'id\',\n                                                                     \'TABLE\' => \'fielddefs\',\n                                                                     \'created\' => 1\n                                                                   },\n                                                   \'TYPE\' => \'INT3\'\n                                                 },\n                                                 \'oldvalue\',\n                                                 {\n                                                   \'TYPE\' => \'TINYTEXT\'\n                                                 },\n                                                 \'newvalue\',\n                                                 {\n                                                   \'TYPE\' => \'TINYTEXT\'\n                                                 }\n                                               ],\n                                   \'INDEXES\' => [\n                                                  \'profiles_activity_userid_idx\',\n                                                  [\n                                                    \'userid\'\n                                                  ],\n                                                  \'profiles_activity_profiles_when_idx\',\n                                                  [\n                                                    \'profiles_when\'\n                                                  ],\n                                                  \'profiles_activity_fieldid_idx\',\n                                                  [\n                                                    \'fieldid\'\n                                                  ]\n                                                ]\n                                 },\n          \'quips\' => {\n                       \'FIELDS\' => [\n                                     \'quipid\',\n                                     {\n                                       \'NOTNULL\' => 1,\n                                       \'PRIMARYKEY\' => 1,\n                                       \'TYPE\' => \'MEDIUMSERIAL\'\n                                     },\n                                     \'userid\',\n                                     {\n                                       \'REFERENCES\' => {\n                                                         \'COLUMN\' => \'userid\',\n                                                         \'DELETE\' => \'SET NULL\',\n                                                         \'TABLE\' => \'profiles\',\n                                                         \'created\' => 1\n                                                       },\n                                       \'TYPE\' => \'INT3\'\n                                     },\n                                     \'quip\',\n                                     {\n                                       \'NOTNULL\' => 1,\n                                       \'TYPE\' => \'varchar(512)\'\n                                     },\n                                     \'approved\',\n                                     {\n                                       \'DEFAULT\' => \'TRUE\',\n                                       \'NOTNULL\' => 1,\n                                       \'TYPE\' => \'BOOLEAN\'\n                                     }\n                                   ]\n                     },\n          \'rep_platform\' => {\n                              \'FIELDS\' => [\n                                            \'id\',\n                                            {\n                                              \'NOTNULL\' => 1,\n                                              \'PRIMARYKEY\' => 1,\n                                              \'TYPE\' => \'SMALLSERIAL\'\n                                            },\n                                            \'value\',\n                                            {\n                                              \'NOTNULL\' => 1,\n                                              \'TYPE\' => \'varchar(64)\'\n                                            },\n                                            \'sortkey\',\n                                            {\n                                              \'DEFAULT\' => 0,\n                                              \'NOTNULL\' => 1,\n                                              \'TYPE\' => \'INT2\'\n                                            },\n                                            \'isactive\',\n                                            {\n                                              \'DEFAULT\' => \'TRUE\',\n                                              \'NOTNULL\' => 1,\n                                              \'TYPE\' => \'BOOLEAN\'\n                                            },\n                                            \'visibility_value_id\',\n                                            {\n                                              \'TYPE\' => \'INT2\'\n                                            }\n                                          ],\n                              \'INDEXES\' => [\n                                             \'rep_platform_value_idx\',\n                                             {\n                                               \'FIELDS\' => [\n                                                             \'value\'\n                                                           ],\n                                               \'TYPE\' => \'UNIQUE\'\n                                             },\n                                             \'rep_platform_sortkey_idx\',\n                                             [\n                                               \'sortkey\',\n                                               \'value\'\n                                             ],\n                                             \'rep_platform_visibility_value_id_idx\',\n                                             [\n                                               \'visibility_value_id\'\n                                             ]\n                                           ]\n                            },\n          \'reports\' => {\n                         \'FIELDS\' => [\n                                       \'id\',\n                                       {\n                                         \'NOTNULL\' => 1,\n                                         \'PRIMARYKEY\' => 1,\n                                         \'TYPE\' => \'MEDIUMSERIAL\'\n                                       },\n                                       \'user_id\',\n                                       {\n                                         \'NOTNULL\' => 1,\n                                         \'REFERENCES\' => {\n                                                           \'COLUMN\' => \'userid\',\n                                                           \'DELETE\' => \'CASCADE\',\n                                                           \'TABLE\' => \'profiles\',\n                                                           \'created\' => 1\n                                                         },\n                                         \'TYPE\' => \'INT3\'\n                                       },\n                                       \'name\',\n                                       {\n                                         \'NOTNULL\' => 1,\n                                         \'TYPE\' => \'varchar(64)\'\n                                       },\n                                       \'query\',\n                                       {\n                                         \'NOTNULL\' => 1,\n                                         \'TYPE\' => \'LONGTEXT\'\n                                       }\n                                     ],\n                         \'INDEXES\' => [\n                                        \'reports_user_id_idx\',\n                                        {\n                                          \'FIELDS\' => [\n                                                        \'user_id\',\n                                                        \'name\'\n                                                      ],\n                                          \'TYPE\' => \'UNIQUE\'\n                                        }\n                                      ]\n                       },\n          \'resolution\' => {\n                            \'FIELDS\' => [\n                                          \'id\',\n                                          {\n                                            \'NOTNULL\' => 1,\n                                            \'PRIMARYKEY\' => 1,\n                                            \'TYPE\' => \'SMALLSERIAL\'\n                                          },\n                                          \'value\',\n                                          {\n                                            \'NOTNULL\' => 1,\n                                            \'TYPE\' => \'varchar(64)\'\n                                          },\n                                          \'sortkey\',\n                                          {\n                                            \'DEFAULT\' => 0,\n                                            \'NOTNULL\' => 1,\n                                            \'TYPE\' => \'INT2\'\n                                          },\n                                          \'isactive\',\n                                          {\n                                            \'DEFAULT\' => \'TRUE\',\n                                            \'NOTNULL\' => 1,\n                                            \'TYPE\' => \'BOOLEAN\'\n                                          },\n                                          \'visibility_value_id\',\n                                          {\n                                            \'TYPE\' => \'INT2\'\n                                          }\n                                        ],\n                            \'INDEXES\' => [\n                                           \'resolution_value_idx\',\n                                           {\n                                             \'FIELDS\' => [\n                                                           \'value\'\n                                                         ],\n                                             \'TYPE\' => \'UNIQUE\'\n                                           },\n                                           \'resolution_sortkey_idx\',\n                                           [\n                                             \'sortkey\',\n                                             \'value\'\n                                           ],\n                                           \'resolution_visibility_value_id_idx\',\n                                           [\n                                             \'visibility_value_id\'\n                                           ]\n                                         ]\n                          },\n          \'series\' => {\n                        \'FIELDS\' => [\n                                      \'series_id\',\n                                      {\n                                        \'NOTNULL\' => 1,\n                                        \'PRIMARYKEY\' => 1,\n                                        \'TYPE\' => \'MEDIUMSERIAL\'\n                                      },\n                                      \'creator\',\n                                      {\n                                        \'REFERENCES\' => {\n                                                          \'COLUMN\' => \'userid\',\n                                                          \'DELETE\' => \'CASCADE\',\n                                                          \'TABLE\' => \'profiles\',\n                                                          \'created\' => 1\n                                                        },\n                                        \'TYPE\' => \'INT3\'\n                                      },\n                                      \'category\',\n                                      {\n                                        \'NOTNULL\' => 1,\n                                        \'REFERENCES\' => {\n                                                          \'COLUMN\' => \'id\',\n                                                          \'DELETE\' => \'CASCADE\',\n                                                          \'TABLE\' => \'series_categories\',\n                                                          \'created\' => 1\n                                                        },\n                                        \'TYPE\' => \'INT2\'\n                                      },\n                                      \'subcategory\',\n                                      {\n                                        \'NOTNULL\' => 1,\n                                        \'REFERENCES\' => {\n                                                          \'COLUMN\' => \'id\',\n                                                          \'DELETE\' => \'CASCADE\',\n                                                          \'TABLE\' => \'series_categories\',\n                                                          \'created\' => 1\n                                                        },\n                                        \'TYPE\' => \'INT2\'\n                                      },\n                                      \'name\',\n                                      {\n                                        \'NOTNULL\' => 1,\n                                        \'TYPE\' => \'varchar(64)\'\n                                      },\n                                      \'frequency\',\n                                      {\n                                        \'NOTNULL\' => 1,\n                                        \'TYPE\' => \'INT2\'\n                                      },\n                                      \'query\',\n                                      {\n                                        \'NOTNULL\' => 1,\n                                        \'TYPE\' => \'MEDIUMTEXT\'\n                                      },\n                                      \'is_public\',\n                                      {\n                                        \'DEFAULT\' => \'FALSE\',\n                                        \'NOTNULL\' => 1,\n                                        \'TYPE\' => \'BOOLEAN\'\n                                      }\n                                    ],\n                        \'INDEXES\' => [\n                                       \'series_creator_idx\',\n                                       [\n                                         \'creator\'\n                                       ],\n                                       \'series_category_idx\',\n                                       {\n                                         \'FIELDS\' => [\n                                                       \'category\',\n                                                       \'subcategory\',\n                                                       \'name\'\n                                                     ],\n                                         \'TYPE\' => \'UNIQUE\'\n                                       }\n                                     ]\n                      },\n          \'series_categories\' => {\n                                   \'FIELDS\' => [\n                                                 \'id\',\n                                                 {\n                                                   \'NOTNULL\' => 1,\n                                                   \'PRIMARYKEY\' => 1,\n                                                   \'TYPE\' => \'SMALLSERIAL\'\n                                                 },\n                                                 \'name\',\n                                                 {\n                                                   \'NOTNULL\' => 1,\n                                                   \'TYPE\' => \'varchar(64)\'\n                                                 }\n                                               ],\n                                   \'INDEXES\' => [\n                                                  \'series_categories_name_idx\',\n                                                  {\n                                                    \'FIELDS\' => [\n                                                                  \'name\'\n                                                                ],\n                                                    \'TYPE\' => \'UNIQUE\'\n                                                  }\n                                                ]\n                                 },\n          \'series_data\' => {\n                             \'FIELDS\' => [\n                                           \'series_id\',\n                                           {\n                                             \'NOTNULL\' => 1,\n                                             \'REFERENCES\' => {\n                                                               \'COLUMN\' => \'series_id\',\n                                                               \'DELETE\' => \'CASCADE\',\n                                                               \'TABLE\' => \'series\',\n                                                               \'created\' => 1\n                                                             },\n                                             \'TYPE\' => \'INT3\'\n                                           },\n                                           \'series_date\',\n                                           {\n                                             \'NOTNULL\' => 1,\n                                             \'TYPE\' => \'DATETIME\'\n                                           },\n                                           \'series_value\',\n                                           {\n                                             \'NOTNULL\' => 1,\n                                             \'TYPE\' => \'INT3\'\n                                           }\n                                         ],\n                             \'INDEXES\' => [\n                                            \'series_data_series_id_idx\',\n                                            {\n                                              \'FIELDS\' => [\n                                                            \'series_id\',\n                                                            \'series_date\'\n                                                          ],\n                                              \'TYPE\' => \'UNIQUE\'\n                                            }\n                                          ]\n                           },\n          \'setting\' => {\n                         \'FIELDS\' => [\n                                       \'name\',\n                                       {\n                                         \'NOTNULL\' => 1,\n                                         \'PRIMARYKEY\' => 1,\n                                         \'TYPE\' => \'varchar(32)\'\n                                       },\n                                       \'default_value\',\n                                       {\n                                         \'NOTNULL\' => 1,\n                                         \'TYPE\' => \'varchar(32)\'\n                                       },\n                                       \'is_enabled\',\n                                       {\n                                         \'DEFAULT\' => \'TRUE\',\n                                         \'NOTNULL\' => 1,\n                                         \'TYPE\' => \'BOOLEAN\'\n                                       },\n                                       \'subclass\',\n                                       {\n                                         \'TYPE\' => \'varchar(32)\'\n                                       }\n                                     ]\n                       },\n          \'setting_value\' => {\n                               \'FIELDS\' => [\n                                             \'name\',\n                                             {\n                                               \'NOTNULL\' => 1,\n                                               \'REFERENCES\' => {\n                                                                 \'COLUMN\' => \'name\',\n                                                                 \'DELETE\' => \'CASCADE\',\n                                                                 \'TABLE\' => \'setting\',\n                                                                 \'created\' => 1\n                                                               },\n                                               \'TYPE\' => \'varchar(32)\'\n                                             },\n                                             \'value\',\n                                             {\n                                               \'NOTNULL\' => 1,\n                                               \'TYPE\' => \'varchar(32)\'\n                                             },\n                                             \'sortindex\',\n                                             {\n                                               \'NOTNULL\' => 1,\n                                               \'TYPE\' => \'INT2\'\n                                             }\n                                           ],\n                               \'INDEXES\' => [\n                                              \'setting_value_nv_unique_idx\',\n                                              {\n                                                \'FIELDS\' => [\n                                                              \'name\',\n                                                              \'value\'\n                                                            ],\n                                                \'TYPE\' => \'UNIQUE\'\n                                              },\n                                              \'setting_value_ns_unique_idx\',\n                                              {\n                                                \'FIELDS\' => [\n                                                              \'name\',\n                                                              \'sortindex\'\n                                                            ],\n                                                \'TYPE\' => \'UNIQUE\'\n                                              }\n                                            ]\n                             },\n          \'status_workflow\' => {\n                                 \'FIELDS\' => [\n                                               \'old_status\',\n                                               {\n                                                 \'REFERENCES\' => {\n                                                                   \'COLUMN\' => \'id\',\n                                                                   \'DELETE\' => \'CASCADE\',\n                                                                   \'TABLE\' => \'bug_status\',\n                                                                   \'created\' => 1\n                                                                 },\n                                                 \'TYPE\' => \'INT2\'\n                                               },\n                                               \'new_status\',\n                                               {\n                                                 \'NOTNULL\' => 1,\n                                                 \'REFERENCES\' => {\n                                                                   \'COLUMN\' => \'id\',\n                                                                   \'DELETE\' => \'CASCADE\',\n                                                                   \'TABLE\' => \'bug_status\',\n                                                                   \'created\' => 1\n                                                                 },\n                                                 \'TYPE\' => \'INT2\'\n                                               },\n                                               \'require_comment\',\n                                               {\n                                                 \'DEFAULT\' => 0,\n                                                 \'NOTNULL\' => 1,\n                                                 \'TYPE\' => \'INT1\'\n                                               }\n                                             ],\n                                 \'INDEXES\' => [\n                                                \'status_workflow_idx\',\n                                                {\n                                                  \'FIELDS\' => [\n                                                                \'old_status\',\n                                                                \'new_status\'\n                                                              ],\n                                                  \'TYPE\' => \'UNIQUE\'\n                                                }\n                                              ]\n                               },\n          \'tag\' => {\n                     \'FIELDS\' => [\n                                   \'id\',\n                                   {\n                                     \'NOTNULL\' => 1,\n                                     \'PRIMARYKEY\' => 1,\n                                     \'TYPE\' => \'MEDIUMSERIAL\'\n                                   },\n                                   \'name\',\n                                   {\n                                     \'NOTNULL\' => 1,\n                                     \'TYPE\' => \'varchar(64)\'\n                                   },\n                                   \'user_id\',\n                                   {\n                                     \'NOTNULL\' => 1,\n                                     \'REFERENCES\' => {\n                                                       \'COLUMN\' => \'userid\',\n                                                       \'DELETE\' => \'CASCADE\',\n                                                       \'TABLE\' => \'profiles\',\n                                                       \'created\' => 1\n                                                     },\n                                     \'TYPE\' => \'INT3\'\n                                   }\n                                 ],\n                     \'INDEXES\' => [\n                                    \'tag_user_id_idx\',\n                                    {\n                                      \'FIELDS\' => [\n                                                    \'user_id\',\n                                                    \'name\'\n                                                  ],\n                                      \'TYPE\' => \'UNIQUE\'\n                                    }\n                                  ]\n                   },\n          \'tokens\' => {\n                        \'FIELDS\' => [\n                                      \'userid\',\n                                      {\n                                        \'REFERENCES\' => {\n                                                          \'COLUMN\' => \'userid\',\n                                                          \'DELETE\' => \'CASCADE\',\n                                                          \'TABLE\' => \'profiles\',\n                                                          \'created\' => 1\n                                                        },\n                                        \'TYPE\' => \'INT3\'\n                                      },\n                                      \'issuedate\',\n                                      {\n                                        \'NOTNULL\' => 1,\n                                        \'TYPE\' => \'DATETIME\'\n                                      },\n                                      \'token\',\n                                      {\n                                        \'NOTNULL\' => 1,\n                                        \'PRIMARYKEY\' => 1,\n                                        \'TYPE\' => \'varchar(16)\'\n                                      },\n                                      \'tokentype\',\n                                      {\n                                        \'NOTNULL\' => 1,\n                                        \'TYPE\' => \'varchar(16)\'\n                                      },\n                                      \'eventdata\',\n                                      {\n                                        \'TYPE\' => \'TINYTEXT\'\n                                      }\n                                    ],\n                        \'INDEXES\' => [\n                                       \'tokens_userid_idx\',\n                                       [\n                                         \'userid\'\n                                       ]\n                                     ]\n                      },\n          \'ts_error\' => {\n                          \'FIELDS\' => [\n                                        \'error_time\',\n                                        {\n                                          \'NOTNULL\' => 1,\n                                          \'TYPE\' => \'INT4\'\n                                        },\n                                        \'jobid\',\n                                        {\n                                          \'NOTNULL\' => 1,\n                                          \'TYPE\' => \'INT4\'\n                                        },\n                                        \'message\',\n                                        {\n                                          \'NOTNULL\' => 1,\n                                          \'TYPE\' => \'varchar(255)\'\n                                        },\n                                        \'funcid\',\n                                        {\n                                          \'DEFAULT\' => 0,\n                                          \'NOTNULL\' => 1,\n                                          \'TYPE\' => \'INT4\'\n                                        }\n                                      ],\n                          \'INDEXES\' => [\n                                         \'ts_error_funcid_idx\',\n                                         [\n                                           \'funcid\',\n                                           \'error_time\'\n                                         ],\n                                         \'ts_error_error_time_idx\',\n                                         [\n                                           \'error_time\'\n                                         ],\n                                         \'ts_error_jobid_idx\',\n                                         [\n                                           \'jobid\'\n                                         ]\n                                       ]\n                        },\n          \'ts_exitstatus\' => {\n                               \'FIELDS\' => [\n                                             \'jobid\',\n                                             {\n                                               \'NOTNULL\' => 1,\n                                               \'PRIMARYKEY\' => 1,\n                                               \'TYPE\' => \'INTSERIAL\'\n                                             },\n                                             \'funcid\',\n                                             {\n                                               \'DEFAULT\' => 0,\n                                               \'NOTNULL\' => 1,\n                                               \'TYPE\' => \'INT4\'\n                                             },\n                                             \'status\',\n                                             {\n                                               \'TYPE\' => \'INT2\'\n                                             },\n                                             \'completion_time\',\n                                             {\n                                               \'TYPE\' => \'INT4\'\n                                             },\n                                             \'delete_after\',\n                                             {\n                                               \'TYPE\' => \'INT4\'\n                                             }\n                                           ],\n                               \'INDEXES\' => [\n                                              \'ts_exitstatus_funcid_idx\',\n                                              [\n                                                \'funcid\'\n                                              ],\n                                              \'ts_exitstatus_delete_after_idx\',\n                                              [\n                                                \'delete_after\'\n                                              ]\n                                            ]\n                             },\n          \'ts_funcmap\' => {\n                            \'FIELDS\' => [\n                                          \'funcid\',\n                                          {\n                                            \'NOTNULL\' => 1,\n                                            \'PRIMARYKEY\' => 1,\n                                            \'TYPE\' => \'INTSERIAL\'\n                                          },\n                                          \'funcname\',\n                                          {\n                                            \'NOTNULL\' => 1,\n                                            \'TYPE\' => \'varchar(255)\'\n                                          }\n                                        ],\n                            \'INDEXES\' => [\n                                           \'ts_funcmap_funcname_idx\',\n                                           {\n                                             \'FIELDS\' => [\n                                                           \'funcname\'\n                                                         ],\n                                             \'TYPE\' => \'UNIQUE\'\n                                           }\n                                         ]\n                          },\n          \'ts_job\' => {\n                        \'FIELDS\' => [\n                                      \'jobid\',\n                                      {\n                                        \'NOTNULL\' => 1,\n                                        \'PRIMARYKEY\' => 1,\n                                        \'TYPE\' => \'INTSERIAL\'\n                                      },\n                                      \'funcid\',\n                                      {\n                                        \'NOTNULL\' => 1,\n                                        \'TYPE\' => \'INT4\'\n                                      },\n                                      \'arg\',\n                                      {\n                                        \'TYPE\' => \'LONGBLOB\'\n                                      },\n                                      \'uniqkey\',\n                                      {\n                                        \'TYPE\' => \'varchar(255)\'\n                                      },\n                                      \'insert_time\',\n                                      {\n                                        \'TYPE\' => \'INT4\'\n                                      },\n                                      \'run_after\',\n                                      {\n                                        \'NOTNULL\' => 1,\n                                        \'TYPE\' => \'INT4\'\n                                      },\n                                      \'grabbed_until\',\n                                      {\n                                        \'NOTNULL\' => 1,\n                                        \'TYPE\' => \'INT4\'\n                                      },\n                                      \'priority\',\n                                      {\n                                        \'TYPE\' => \'INT2\'\n                                      },\n                                      \'coalesce\',\n                                      {\n                                        \'TYPE\' => \'varchar(255)\'\n                                      }\n                                    ],\n                        \'INDEXES\' => [\n                                       \'ts_job_funcid_idx\',\n                                       {\n                                         \'FIELDS\' => [\n                                                       \'funcid\',\n                                                       \'uniqkey\'\n                                                     ],\n                                         \'TYPE\' => \'UNIQUE\'\n                                       },\n                                       \'ts_job_run_after_idx\',\n                                       [\n                                         \'run_after\',\n                                         \'funcid\'\n                                       ],\n                                       \'ts_job_coalesce_idx\',\n                                       [\n                                         \'coalesce\',\n                                         \'funcid\'\n                                       ]\n                                     ]\n                      },\n          \'ts_note\' => {\n                         \'FIELDS\' => [\n                                       \'jobid\',\n                                       {\n                                         \'NOTNULL\' => 1,\n                                         \'TYPE\' => \'INT4\'\n                                       },\n                                       \'notekey\',\n                                       {\n                                         \'TYPE\' => \'varchar(255)\'\n                                       },\n                                       \'value\',\n                                       {\n                                         \'TYPE\' => \'LONGBLOB\'\n                                       }\n                                     ],\n                         \'INDEXES\' => [\n                                        \'ts_note_jobid_idx\',\n                                        {\n                                          \'FIELDS\' => [\n                                                        \'jobid\',\n                                                        \'notekey\'\n                                                      ],\n                                          \'TYPE\' => \'UNIQUE\'\n                                        }\n                                      ]\n                       },\n          \'user_api_keys\' => {\n                               \'FIELDS\' => [\n                                             \'id\',\n                                             {\n                                               \'NOTNULL\' => 1,\n                                               \'PRIMARYKEY\' => 1,\n                                               \'TYPE\' => \'INTSERIAL\'\n                                             },\n                                             \'user_id\',\n                                             {\n                                               \'NOTNULL\' => 1,\n                                               \'REFERENCES\' => {\n                                                                 \'COLUMN\' => \'userid\',\n                                                                 \'DELETE\' => \'CASCADE\',\n                                                                 \'TABLE\' => \'profiles\',\n                                                                 \'created\' => 1\n                                                               },\n                                               \'TYPE\' => \'INT3\'\n                                             },\n                                             \'api_key\',\n                                             {\n                                               \'NOTNULL\' => 1,\n                                               \'TYPE\' => \'VARCHAR(40)\'\n                                             },\n                                             \'description\',\n                                             {\n                                               \'TYPE\' => \'VARCHAR(255)\'\n                                             },\n                                             \'revoked\',\n                                             {\n                                               \'DEFAULT\' => \'FALSE\',\n                                               \'NOTNULL\' => 1,\n                                               \'TYPE\' => \'BOOLEAN\'\n                                             },\n                                             \'last_used\',\n                                             {\n                                               \'TYPE\' => \'DATETIME\'\n                                             }\n                                           ],\n                               \'INDEXES\' => [\n                                              \'user_api_keys_api_key_idx\',\n                                              {\n                                                \'FIELDS\' => [\n                                                              \'api_key\'\n                                                            ],\n                                                \'TYPE\' => \'UNIQUE\'\n                                              },\n                                              \'user_api_keys_user_id_idx\',\n                                              [\n                                                \'user_id\'\n                                              ]\n                                            ]\n                             },\n          \'user_group_map\' => {\n                                \'FIELDS\' => [\n                                              \'user_id\',\n                                              {\n                                                \'NOTNULL\' => 1,\n                                                \'REFERENCES\' => {\n                                                                  \'COLUMN\' => \'userid\',\n                                                                  \'DELETE\' => \'CASCADE\',\n                                                                  \'TABLE\' => \'profiles\',\n                                                                  \'created\' => 1\n                                                                },\n                                                \'TYPE\' => \'INT3\'\n                                              },\n                                              \'group_id\',\n                                              {\n                                                \'NOTNULL\' => 1,\n                                                \'REFERENCES\' => {\n                                                                  \'COLUMN\' => \'id\',\n                                                                  \'DELETE\' => \'CASCADE\',\n                                                                  \'TABLE\' => \'groups\',\n                                                                  \'created\' => 1\n                                                                },\n                                                \'TYPE\' => \'INT3\'\n                                              },\n                                              \'isbless\',\n                                              {\n                                                \'DEFAULT\' => \'FALSE\',\n                                                \'NOTNULL\' => 1,\n                                                \'TYPE\' => \'BOOLEAN\'\n                                              },\n                                              \'grant_type\',\n                                              {\n                                                \'DEFAULT\' => 0,\n                                                \'NOTNULL\' => 1,\n                                                \'TYPE\' => \'INT1\'\n                                              }\n                                            ],\n                                \'INDEXES\' => [\n                                               \'user_group_map_user_id_idx\',\n                                               {\n                                                 \'FIELDS\' => [\n                                                               \'user_id\',\n                                                               \'group_id\',\n                                                               \'grant_type\',\n                                                               \'isbless\'\n                                                             ],\n                                                 \'TYPE\' => \'UNIQUE\'\n                                               }\n                                             ]\n                              },\n          \'versions\' => {\n                          \'FIELDS\' => [\n                                        \'id\',\n                                        {\n                                          \'NOTNULL\' => 1,\n                                          \'PRIMARYKEY\' => 1,\n                                          \'TYPE\' => \'MEDIUMSERIAL\'\n                                        },\n                                        \'value\',\n                                        {\n                                          \'NOTNULL\' => 1,\n                                          \'TYPE\' => \'varchar(64)\'\n                                        },\n                                        \'product_id\',\n                                        {\n                                          \'NOTNULL\' => 1,\n                                          \'REFERENCES\' => {\n                                                            \'COLUMN\' => \'id\',\n                                                            \'DELETE\' => \'CASCADE\',\n                                                            \'TABLE\' => \'products\',\n                                                            \'created\' => 1\n                                                          },\n                                          \'TYPE\' => \'INT2\'\n                                        },\n                                        \'isactive\',\n                                        {\n                                          \'DEFAULT\' => \'TRUE\',\n                                          \'NOTNULL\' => 1,\n                                          \'TYPE\' => \'BOOLEAN\'\n                                        }\n                                      ],\n                          \'INDEXES\' => [\n                                         \'versions_product_id_idx\',\n                                         {\n                                           \'FIELDS\' => [\n                                                         \'product_id\',\n                                                         \'value\'\n                                                       ],\n                                           \'TYPE\' => \'UNIQUE\'\n                                         }\n                                       ]\n                        },\n          \'watch\' => {\n                       \'FIELDS\' => [\n                                     \'watcher\',\n                                     {\n                                       \'NOTNULL\' => 1,\n                                       \'REFERENCES\' => {\n                                                         \'COLUMN\' => \'userid\',\n                                                         \'DELETE\' => \'CASCADE\',\n                                                         \'TABLE\' => \'profiles\',\n                                                         \'created\' => 1\n                                                       },\n                                       \'TYPE\' => \'INT3\'\n                                     },\n                                     \'watched\',\n                                     {\n                                       \'NOTNULL\' => 1,\n                                       \'REFERENCES\' => {\n                                                         \'COLUMN\' => \'userid\',\n                                                         \'DELETE\' => \'CASCADE\',\n                                                         \'TABLE\' => \'profiles\',\n                                                         \'created\' => 1\n                                                       },\n                                       \'TYPE\' => \'INT3\'\n                                     }\n                                   ],\n                       \'INDEXES\' => [\n                                      \'watch_watcher_idx\',\n                                      {\n                                        \'FIELDS\' => [\n                                                      \'watcher\',\n                                                      \'watched\'\n                                                    ],\n                                        \'TYPE\' => \'UNIQUE\'\n                                      },\n                                      \'watch_watched_idx\',\n                                      [\n                                        \'watched\'\n                                      ]\n                                    ]\n                     },\n          \'whine_events\' => {\n                              \'FIELDS\' => [\n                                            \'id\',\n                                            {\n                                              \'NOTNULL\' => 1,\n                                              \'PRIMARYKEY\' => 1,\n                                              \'TYPE\' => \'MEDIUMSERIAL\'\n                                            },\n                                            \'owner_userid\',\n                                            {\n                                              \'NOTNULL\' => 1,\n                                              \'REFERENCES\' => {\n                                                                \'COLUMN\' => \'userid\',\n                                                                \'DELETE\' => \'CASCADE\',\n                                                                \'TABLE\' => \'profiles\',\n                                                                \'created\' => 1\n                                                              },\n                                              \'TYPE\' => \'INT3\'\n                                            },\n                                            \'subject\',\n                                            {\n                                              \'TYPE\' => \'varchar(128)\'\n                                            },\n                                            \'body\',\n                                            {\n                                              \'TYPE\' => \'MEDIUMTEXT\'\n                                            },\n                                            \'mailifnobugs\',\n                                            {\n                                              \'DEFAULT\' => \'FALSE\',\n                                              \'NOTNULL\' => 1,\n                                              \'TYPE\' => \'BOOLEAN\'\n                                            }\n                                          ]\n                            },\n          \'whine_queries\' => {\n                               \'FIELDS\' => [\n                                             \'id\',\n                                             {\n                                               \'NOTNULL\' => 1,\n                                               \'PRIMARYKEY\' => 1,\n                                               \'TYPE\' => \'MEDIUMSERIAL\'\n                                             },\n                                             \'eventid\',\n                                             {\n                                               \'NOTNULL\' => 1,\n                                               \'REFERENCES\' => {\n                                                                 \'COLUMN\' => \'id\',\n                                                                 \'DELETE\' => \'CASCADE\',\n                                                                 \'TABLE\' => \'whine_events\',\n                                                                 \'created\' => 1\n                                                               },\n                                               \'TYPE\' => \'INT3\'\n                                             },\n                                             \'query_name\',\n                                             {\n                                               \'DEFAULT\' => \'\\\'\\\'\',\n                                               \'NOTNULL\' => 1,\n                                               \'TYPE\' => \'varchar(64)\'\n                                             },\n                                             \'sortkey\',\n                                             {\n                                               \'DEFAULT\' => \'0\',\n                                               \'NOTNULL\' => 1,\n                                               \'TYPE\' => \'INT2\'\n                                             },\n                                             \'onemailperbug\',\n                                             {\n                                               \'DEFAULT\' => \'FALSE\',\n                                               \'NOTNULL\' => 1,\n                                               \'TYPE\' => \'BOOLEAN\'\n                                             },\n                                             \'title\',\n                                             {\n                                               \'DEFAULT\' => \'\\\'\\\'\',\n                                               \'NOTNULL\' => 1,\n                                               \'TYPE\' => \'varchar(128)\'\n                                             }\n                                           ],\n                               \'INDEXES\' => [\n                                              \'whine_queries_eventid_idx\',\n                                              [\n                                                \'eventid\'\n                                              ]\n                                            ]\n                             },\n          \'whine_schedules\' => {\n                                 \'FIELDS\' => [\n                                               \'id\',\n                                               {\n                                                 \'NOTNULL\' => 1,\n                                                 \'PRIMARYKEY\' => 1,\n                                                 \'TYPE\' => \'MEDIUMSERIAL\'\n                                               },\n                                               \'eventid\',\n                                               {\n                                                 \'NOTNULL\' => 1,\n                                                 \'REFERENCES\' => {\n                                                                   \'COLUMN\' => \'id\',\n                                                                   \'DELETE\' => \'CASCADE\',\n                                                                   \'TABLE\' => \'whine_events\',\n                                                                   \'created\' => 1\n                                                                 },\n                                                 \'TYPE\' => \'INT3\'\n                                               },\n                                               \'run_day\',\n                                               {\n                                                 \'TYPE\' => \'varchar(32)\'\n                                               },\n                                               \'run_time\',\n                                               {\n                                                 \'TYPE\' => \'varchar(32)\'\n                                               },\n                                               \'run_next\',\n                                               {\n                                                 \'TYPE\' => \'DATETIME\'\n                                               },\n                                               \'mailto\',\n                                               {\n                                                 \'NOTNULL\' => 1,\n                                                 \'TYPE\' => \'INT3\'\n                                               },\n                                               \'mailto_type\',\n                                               {\n                                                 \'DEFAULT\' => \'0\',\n                                                 \'NOTNULL\' => 1,\n                                                 \'TYPE\' => \'INT2\'\n                                               }\n                                             ],\n                                 \'INDEXES\' => [\n                                                \'whine_schedules_run_next_idx\',\n                                                [\n                                                  \'run_next\'\n                                                ],\n                                                \'whine_schedules_eventid_idx\',\n                                                [\n                                                  \'eventid\'\n                                                ]\n                                              ]\n                               }\n        };\n',3.00);

/*Table structure for table `category_group_map` */

DROP TABLE IF EXISTS `category_group_map`;

CREATE TABLE `category_group_map` (
  `category_id` smallint(6) NOT NULL,
  `group_id` mediumint(9) NOT NULL,
  UNIQUE KEY `category_group_map_category_id_idx` (`category_id`,`group_id`),
  KEY `fk_category_group_map_group_id_groups_id` (`group_id`),
  CONSTRAINT `fk_category_group_map_category_id_series_categories_id` FOREIGN KEY (`category_id`) REFERENCES `series_categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_category_group_map_group_id_groups_id` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `category_group_map` */

/*Table structure for table `cc` */

DROP TABLE IF EXISTS `cc`;

CREATE TABLE `cc` (
  `bug_id` mediumint(9) NOT NULL,
  `who` mediumint(9) NOT NULL,
  UNIQUE KEY `cc_bug_id_idx` (`bug_id`,`who`),
  KEY `cc_who_idx` (`who`),
  CONSTRAINT `fk_cc_bug_id_bugs_bug_id` FOREIGN KEY (`bug_id`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cc_who_profiles_userid` FOREIGN KEY (`who`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `cc` */

/*Table structure for table `cf_ipi_clust_3_action_type` */

DROP TABLE IF EXISTS `cf_ipi_clust_3_action_type`;

CREATE TABLE `cf_ipi_clust_3_action_type` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `value` varchar(64) NOT NULL,
  `sortkey` smallint(6) NOT NULL DEFAULT 0,
  `isactive` tinyint(4) NOT NULL DEFAULT 1,
  `visibility_value_id` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cf_ipi_clust_3_action_type_value_idx` (`value`),
  KEY `cf_ipi_clust_3_action_type_sortkey_idx` (`sortkey`,`value`),
  KEY `cf_ipi_clust_3_action_type_visibility_value_id_idx` (`visibility_value_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

/*Data for the table `cf_ipi_clust_3_action_type` */

insert  into `cf_ipi_clust_3_action_type`(`id`,`value`,`sortkey`,`isactive`,`visibility_value_id`) values 
(1,'---',0,1,NULL),
(2,'Diagnose',10,1,NULL),
(3,'Fix',15,1,NULL),
(4,'Diagnose and Fix',20,1,NULL),
(5,'Supervise',25,1,NULL),
(6,'Deliver',30,1,NULL),
(7,'Collect',35,1,NULL),
(8,'Purchase',40,1,NULL),
(9,'Install',45,1,NULL),
(10,'Check',50,1,NULL),
(11,'Other',55,1,NULL);

/*Table structure for table `cf_ipi_clust_3_roadbook_for` */

DROP TABLE IF EXISTS `cf_ipi_clust_3_roadbook_for`;

CREATE TABLE `cf_ipi_clust_3_roadbook_for` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `value` varchar(64) NOT NULL,
  `sortkey` smallint(6) NOT NULL DEFAULT 0,
  `isactive` tinyint(4) NOT NULL DEFAULT 1,
  `visibility_value_id` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cf_ipi_clust_3_roadbook_for_value_idx` (`value`),
  KEY `cf_ipi_clust_3_roadbook_for_visibility_value_id_idx` (`visibility_value_id`),
  KEY `cf_ipi_clust_3_roadbook_for_sortkey_idx` (`sortkey`,`value`)
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=utf8;

/*Data for the table `cf_ipi_clust_3_roadbook_for` */

insert  into `cf_ipi_clust_3_roadbook_for`(`id`,`value`,`sortkey`,`isactive`,`visibility_value_id`) values 
(1,'Firdauz (Left 04 Sep 2014)',10000,0,NULL),
(2,'Zayar (left 06/08/10)',10000,0,NULL),
(3,'Joel (left 13/06/11)',10000,0,NULL),
(4,'Hussin',5,1,NULL),
(5,'Nath',15,1,NULL),
(6,'Abigael (left 15/04/11)',10000,0,NULL),
(7,'Hasfa (left 28/02/11)',10000,0,NULL),
(8,'Marivick (Left)',10000,0,NULL),
(9,'Suzana (Left 31/01/2013)',10000,0,NULL),
(10,'Anne',1000,0,NULL),
(11,'Ellen (Left 06/09/11)',10000,0,NULL),
(12,'Mohamed (left 31/05/11)',10000,0,NULL),
(13,'Housekeepers',20,1,NULL),
(14,'Mahendran (left 29/07/11)',10000,0,NULL),
(15,'Vijay (left 19/10/11)',10000,0,NULL),
(16,'Stephane (left 09/09/11)',10000,0,NULL),
(17,'Ahmad (Left 19/09/11)',10000,0,NULL),
(18,'Helene (left 22/04/2013)',10000,0,NULL),
(19,'Gayatri',10,1,NULL),
(20,'Huzir (Left 25/10/11)',10000,0,NULL),
(21,'Sahrin (left 09/11/11)',10000,0,NULL),
(22,'Accounting',20,1,NULL),
(23,'Admin Assistant',20,1,NULL),
(24,'Sales',20,1,NULL),
(25,'Management',25,1,NULL),
(26,'Franck',1000,0,NULL),
(27,'Fauzi (left 02/10/12)',10000,0,NULL),
(28,'Lawrence (left 04/01/12)',10000,0,NULL),
(29,'Alan (left 30/03/2012)',10000,0,NULL),
(30,'Anand (left 31/12/11)',10000,0,NULL),
(31,'Shahbudi (Left 27/12/13)',10000,0,NULL),
(32,'Yazed (left 30/10/12)',10000,0,NULL),
(33,'William (left 04/05/12)',10000,0,NULL),
(34,'Nast',15,1,NULL),
(35,'Uzali (left 13/08/12)',10000,0,NULL),
(36,'Kwok (left 30/06/12)',10000,0,NULL),
(37,'Zad (left 30/06/12)',10000,0,NULL),
(38,'Marc (Left 10/07/2015)',10000,0,NULL),
(39,'Choo (left 22/02/2013)',10000,0,NULL),
(40,'Krishnan (Left 06/11/2016)',10000,0,NULL),
(41,'Julianto (left 30/08/12',10000,0,NULL),
(42,'Peter TAY (left 30/11/12)',10000,0,NULL),
(43,'Tan (Left 31/01/2013)',10000,0,NULL),
(44,'Jhonson',5,1,NULL),
(45,'Lau (Left 30/11/2013)',10000,0,NULL),
(46,'Richard (Left 04/03/2014)',10000,0,NULL),
(47,'Jimmy (Left 26/11/13)',10000,0,NULL),
(64,'Jerry (Left 30/04/15)',10000,0,NULL),
(65,'Leng (Left 24/04/2014)',10000,0,NULL),
(66,'Salim',5,1,NULL),
(67,'Derrick',5,1,NULL),
(68,'Charlene (Left 09/09/2014)',10000,0,NULL),
(69,'Suhaily (LEFT)',10000,0,NULL),
(70,'Nonie (Left 08/07/2016)',10000,0,NULL),
(71,'Ken (Left 04/12/2014)',10000,0,NULL),
(72,'Jasline (Left 12/06/2015)',10000,0,NULL),
(73,'Khairul',5,1,NULL),
(74,'Kamal (Left 30/01/2016)',10000,0,NULL),
(75,'Nurul (Left)',10000,0,NULL),
(76,'Alisa',10,1,NULL);

/*Table structure for table `cf_ipi_clust_4_status_in_progress` */

DROP TABLE IF EXISTS `cf_ipi_clust_4_status_in_progress`;

CREATE TABLE `cf_ipi_clust_4_status_in_progress` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `value` varchar(64) NOT NULL,
  `sortkey` smallint(6) NOT NULL DEFAULT 0,
  `isactive` tinyint(4) NOT NULL DEFAULT 1,
  `visibility_value_id` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cf_ipi_clust_4_status_in_progress_value_idx` (`value`),
  KEY `cf_ipi_clust_4_status_in_progress_visibility_value_id_idx` (`visibility_value_id`),
  KEY `cf_ipi_clust_4_status_in_progress_sortkey_idx` (`sortkey`,`value`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

/*Data for the table `cf_ipi_clust_4_status_in_progress` */

insert  into `cf_ipi_clust_4_status_in_progress`(`id`,`value`,`sortkey`,`isactive`,`visibility_value_id`) values 
(1,'---',0,1,NULL),
(2,'SCHEDULED',10,1,NULL),
(3,'AP NEEDED',20,1,NULL),
(4,'AP GRANTED',30,1,NULL),
(5,'FIELD ACTION',40,1,NULL);

/*Table structure for table `cf_ipi_clust_4_status_standby` */

DROP TABLE IF EXISTS `cf_ipi_clust_4_status_standby`;

CREATE TABLE `cf_ipi_clust_4_status_standby` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `value` varchar(64) NOT NULL,
  `sortkey` smallint(6) NOT NULL DEFAULT 0,
  `isactive` tinyint(4) NOT NULL DEFAULT 1,
  `visibility_value_id` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cf_ipi_clust_4_status_standby_value_idx` (`value`),
  KEY `cf_ipi_clust_4_status_standby_visibility_value_id_idx` (`visibility_value_id`),
  KEY `cf_ipi_clust_4_status_standby_sortkey_idx` (`sortkey`,`value`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

/*Data for the table `cf_ipi_clust_4_status_standby` */

insert  into `cf_ipi_clust_4_status_standby`(`id`,`value`,`sortkey`,`isactive`,`visibility_value_id`) values 
(1,'---',0,1,NULL),
(2,'PENDING PMT',10,1,NULL),
(3,'OTHER',20,1,NULL);

/*Table structure for table `cf_ipi_clust_6_claim_type` */

DROP TABLE IF EXISTS `cf_ipi_clust_6_claim_type`;

CREATE TABLE `cf_ipi_clust_6_claim_type` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `value` varchar(64) NOT NULL,
  `sortkey` smallint(6) NOT NULL DEFAULT 0,
  `isactive` tinyint(4) NOT NULL DEFAULT 1,
  `visibility_value_id` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cf_ipi_clust_6_claim_type_value_idx` (`value`),
  KEY `cf_ipi_clust_6_claim_type_sortkey_idx` (`sortkey`,`value`),
  KEY `cf_ipi_clust_6_claim_type_visibility_value_id_idx` (`visibility_value_id`)
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8;

/*Data for the table `cf_ipi_clust_6_claim_type` */

insert  into `cf_ipi_clust_6_claim_type`(`id`,`value`,`sortkey`,`isactive`,`visibility_value_id`) values 
(1,'---',500,1,NULL),
(2,'Electrical',1005,1,NULL),
(3,'Plumbing Rep',1010,1,NULL),
(4,'Aircon Rep',1015,1,NULL),
(5,'Furniture Rep',1020,1,NULL),
(6,'Carpentry Rep',1025,1,NULL),
(7,'Internet Rep',1030,1,NULL),
(8,'Cable TV Rep',1035,1,NULL),
(9,'Other Rep',1090,1,NULL),
(10,'Aircon M',1505,1,NULL),
(11,'Equipment M',1510,1,NULL),
(12,'Plumbing M',1515,1,NULL),
(13,'Battery repl.',1520,1,NULL),
(14,'Other M',1525,1,NULL),
(15,'Linens',2005,1,NULL),
(16,'Textile',2010,1,NULL),
(17,'Curtains',2015,1,NULL),
(18,'Cleaning',2020,1,NULL),
(19,'Other H',2025,1,NULL),
(20,'Key',2505,1,NULL),
(21,'Resident Card',2510,1,NULL),
(22,'Car Transponder',2515,1,NULL),
(23,'Kitchen Utensils',2520,1,NULL),
(24,'Furniture D',2525,1,NULL),
(25,'Safe box',2530,1,NULL),
(26,'Equipment D',2535,1,NULL),
(27,'Other D',2540,1,NULL),
(28,'Structural Defect',3005,1,NULL),
(29,'Carpentry Ren',3010,1,NULL),
(30,'Parquet Polishing',3015,1,NULL),
(31,'Painting',3020,1,NULL),
(32,'Other Ren',3025,1,NULL),
(33,'Flat Set Up',3505,1,NULL),
(34,'Light Renovation',3510,1,NULL),
(35,'Flat Refurbishing',3515,1,NULL),
(36,'Hand Over',3520,1,NULL),
(37,'Basic Check',3525,1,NULL),
(38,'Store room Clearance',3530,1,NULL),
(39,'Other CP',3535,1,NULL),
(40,'Laundry',4005,1,NULL),
(41,'Ironing',4010,1,NULL),
(42,'Housekeeping',4015,1,NULL),
(43,'Cable Channel',4020,1,NULL),
(44,'Internet Upgrade',4025,1,NULL),
(45,'Beds',4030,1,NULL),
(46,'Baby Cot',4035,1,NULL),
(47,'Airport Transportation',4040,1,NULL),
(48,'Welcome Basket',4045,1,NULL),
(49,'Dish Washing',4050,1,NULL),
(50,'Other ES',4090,1,NULL),
(51,'NOT SPECIFIED',4095,1,NULL),
(52,'SP Services',4505,1,NULL),
(53,'Gas',4510,1,NULL),
(54,'Meter Reading',4515,1,NULL),
(55,'Other U',4520,1,NULL),
(56,'Internet O',5005,1,NULL),
(57,'Cable TV O',5010,1,NULL),
(58,'Viewing',5015,1,NULL),
(59,'Other',5020,1,NULL),
(60,'Late Check IN/OUT',4055,1,NULL),
(61,'Early Check IN/OUT',4060,1,NULL),
(62,'High Chair',4065,1,NULL),
(63,'Equipment',1040,1,NULL);

/*Table structure for table `cf_ipi_clust_7_spe_payment_type` */

DROP TABLE IF EXISTS `cf_ipi_clust_7_spe_payment_type`;

CREATE TABLE `cf_ipi_clust_7_spe_payment_type` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `value` varchar(64) NOT NULL,
  `sortkey` smallint(6) NOT NULL DEFAULT 0,
  `isactive` tinyint(4) NOT NULL DEFAULT 1,
  `visibility_value_id` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cf_ipi_clust_7_spe_payment_type_value_idx` (`value`),
  KEY `cf_ipi_clust_7_spe_payment_type_visibility_value_id_idx` (`visibility_value_id`),
  KEY `cf_ipi_clust_7_spe_payment_type_sortkey_idx` (`sortkey`,`value`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

/*Data for the table `cf_ipi_clust_7_spe_payment_type` */

insert  into `cf_ipi_clust_7_spe_payment_type`(`id`,`value`,`sortkey`,`isactive`,`visibility_value_id`) values 
(1,'---',0,1,NULL),
(2,'Invoice (Wire)',50,1,NULL),
(3,'Cheque on delivery',20,1,NULL),
(4,'Cash',30,1,NULL),
(5,'Invoice (cheque)',40,1,NULL),
(6,'Invoice (unspecif.)',35,1,NULL);

/*Table structure for table `cf_ipi_clust_9_acct_action` */

DROP TABLE IF EXISTS `cf_ipi_clust_9_acct_action`;

CREATE TABLE `cf_ipi_clust_9_acct_action` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `value` varchar(64) NOT NULL,
  `sortkey` smallint(6) NOT NULL DEFAULT 0,
  `isactive` tinyint(4) NOT NULL DEFAULT 1,
  `visibility_value_id` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cf_ipi_clust_9_acct_action_value_idx` (`value`),
  KEY `cf_ipi_clust_9_acct_action_visibility_value_id_idx` (`visibility_value_id`),
  KEY `cf_ipi_clust_9_acct_action_sortkey_idx` (`sortkey`,`value`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

/*Data for the table `cf_ipi_clust_9_acct_action` */

insert  into `cf_ipi_clust_9_acct_action`(`id`,`value`,`sortkey`,`isactive`,`visibility_value_id`) values 
(1,'INVOICE LANDLORD',100,1,NULL),
(2,'INVOICE CUSTOMER',200,1,NULL),
(3,'PAY CONTRACTOR',300,1,NULL),
(4,'---',50,1,NULL);

/*Table structure for table `cf_specific_for` */

DROP TABLE IF EXISTS `cf_specific_for`;

CREATE TABLE `cf_specific_for` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `value` varchar(64) NOT NULL,
  `sortkey` smallint(6) NOT NULL DEFAULT 0,
  `isactive` tinyint(4) NOT NULL DEFAULT 1,
  `visibility_value_id` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cf_specific_for_value_idx` (`value`),
  KEY `cf_specific_for_sortkey_idx` (`sortkey`,`value`),
  KEY `cf_specific_for_visibility_value_id_idx` (`visibility_value_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

/*Data for the table `cf_specific_for` */

insert  into `cf_specific_for`(`id`,`value`,`sortkey`,`isactive`,`visibility_value_id`) values 
(1,'---',0,1,NULL),
(2,'LMB - #1',1,1,NULL);

/*Table structure for table `classifications` */

DROP TABLE IF EXISTS `classifications`;

CREATE TABLE `classifications` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `description` mediumtext DEFAULT NULL,
  `sortkey` smallint(6) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `classifications_name_idx` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

/*Data for the table `classifications` */

insert  into `classifications`(`id`,`name`,`description`,`sortkey`) values 
(1,'Test Units','These are TEST units that you have created or where I have been invited',0),
(2,'My Units','These are the units that you have created or where I have been invited',0);

/*Table structure for table `component_cc` */

DROP TABLE IF EXISTS `component_cc`;

CREATE TABLE `component_cc` (
  `user_id` mediumint(9) NOT NULL,
  `component_id` mediumint(9) NOT NULL,
  UNIQUE KEY `component_cc_user_id_idx` (`component_id`,`user_id`),
  KEY `fk_component_cc_user_id_profiles_userid` (`user_id`),
  CONSTRAINT `fk_component_cc_component_id_components_id` FOREIGN KEY (`component_id`) REFERENCES `components` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_component_cc_user_id_profiles_userid` FOREIGN KEY (`user_id`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `component_cc` */

/*Table structure for table `components` */

DROP TABLE IF EXISTS `components`;

CREATE TABLE `components` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `product_id` smallint(6) NOT NULL,
  `initialowner` mediumint(9) NOT NULL,
  `initialqacontact` mediumint(9) DEFAULT NULL,
  `description` mediumtext NOT NULL,
  `isactive` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `components_product_id_idx` (`product_id`,`name`),
  KEY `components_name_idx` (`name`),
  KEY `fk_components_initialowner_profiles_userid` (`initialowner`),
  KEY `fk_components_initialqacontact_profiles_userid` (`initialqacontact`),
  CONSTRAINT `fk_components_initialowner_profiles_userid` FOREIGN KEY (`initialowner`) REFERENCES `profiles` (`userid`) ON UPDATE CASCADE,
  CONSTRAINT `fk_components_initialqacontact_profiles_userid` FOREIGN KEY (`initialqacontact`) REFERENCES `profiles` (`userid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_components_product_id_products_id` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Data for the table `components` */

insert  into `components`(`id`,`name`,`product_id`,`initialowner`,`initialqacontact`,`description`,`isactive`) values 
(1,'Test stakeholder 1',1,1,NULL,'Stakholder 1 (ex: landlord), contact details, comments about how to contact the person for that unit.',1);

/*Table structure for table `dependencies` */

DROP TABLE IF EXISTS `dependencies`;

CREATE TABLE `dependencies` (
  `blocked` mediumint(9) NOT NULL,
  `dependson` mediumint(9) NOT NULL,
  UNIQUE KEY `dependencies_blocked_idx` (`blocked`,`dependson`),
  KEY `dependencies_dependson_idx` (`dependson`),
  CONSTRAINT `fk_dependencies_blocked_bugs_bug_id` FOREIGN KEY (`blocked`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_dependencies_dependson_bugs_bug_id` FOREIGN KEY (`dependson`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `dependencies` */

/*Table structure for table `duplicates` */

DROP TABLE IF EXISTS `duplicates`;

CREATE TABLE `duplicates` (
  `dupe_of` mediumint(9) NOT NULL,
  `dupe` mediumint(9) NOT NULL,
  PRIMARY KEY (`dupe`),
  KEY `fk_duplicates_dupe_of_bugs_bug_id` (`dupe_of`),
  CONSTRAINT `fk_duplicates_dupe_bugs_bug_id` FOREIGN KEY (`dupe`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_duplicates_dupe_of_bugs_bug_id` FOREIGN KEY (`dupe_of`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `duplicates` */

/*Table structure for table `email_bug_ignore` */

DROP TABLE IF EXISTS `email_bug_ignore`;

CREATE TABLE `email_bug_ignore` (
  `user_id` mediumint(9) NOT NULL,
  `bug_id` mediumint(9) NOT NULL,
  UNIQUE KEY `email_bug_ignore_user_id_idx` (`user_id`,`bug_id`),
  KEY `fk_email_bug_ignore_bug_id_bugs_bug_id` (`bug_id`),
  CONSTRAINT `fk_email_bug_ignore_bug_id_bugs_bug_id` FOREIGN KEY (`bug_id`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_email_bug_ignore_user_id_profiles_userid` FOREIGN KEY (`user_id`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `email_bug_ignore` */

/*Table structure for table `email_setting` */

DROP TABLE IF EXISTS `email_setting`;

CREATE TABLE `email_setting` (
  `user_id` mediumint(9) NOT NULL,
  `relationship` tinyint(4) NOT NULL,
  `event` tinyint(4) NOT NULL,
  UNIQUE KEY `email_setting_user_id_idx` (`user_id`,`relationship`,`event`),
  CONSTRAINT `fk_email_setting_user_id_profiles_userid` FOREIGN KEY (`user_id`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `email_setting` */

insert  into `email_setting`(`user_id`,`relationship`,`event`) values 
(1,0,0),
(1,0,1),
(1,0,2),
(1,0,3),
(1,0,4),
(1,0,5),
(1,0,6),
(1,0,7),
(1,0,9),
(1,0,10),
(1,0,11),
(1,0,50),
(1,1,0),
(1,1,1),
(1,1,2),
(1,1,3),
(1,1,4),
(1,1,5),
(1,1,6),
(1,1,7),
(1,1,9),
(1,1,10),
(1,1,11),
(1,1,50),
(1,2,0),
(1,2,1),
(1,2,2),
(1,2,3),
(1,2,4),
(1,2,5),
(1,2,6),
(1,2,7),
(1,2,8),
(1,2,9),
(1,2,10),
(1,2,11),
(1,2,50),
(1,3,0),
(1,3,1),
(1,3,2),
(1,3,3),
(1,3,4),
(1,3,5),
(1,3,6),
(1,3,7),
(1,3,9),
(1,3,10),
(1,3,11),
(1,3,50),
(1,5,0),
(1,5,1),
(1,5,2),
(1,5,3),
(1,5,4),
(1,5,5),
(1,5,6),
(1,5,7),
(1,5,9),
(1,5,10),
(1,5,11),
(1,5,50),
(1,100,100),
(1,100,101);

/*Table structure for table `field_visibility` */

DROP TABLE IF EXISTS `field_visibility`;

CREATE TABLE `field_visibility` (
  `field_id` mediumint(9) DEFAULT NULL,
  `value_id` smallint(6) NOT NULL,
  UNIQUE KEY `field_visibility_field_id_idx` (`field_id`,`value_id`),
  CONSTRAINT `fk_field_visibility_field_id_fielddefs_id` FOREIGN KEY (`field_id`) REFERENCES `fielddefs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `field_visibility` */

insert  into `field_visibility`(`field_id`,`value_id`) values 
(60,3),
(61,7),
(76,2),
(77,2),
(78,2),
(79,2),
(80,2),
(81,2),
(83,2),
(84,2),
(85,2),
(87,2),
(88,2),
(89,2),
(90,2),
(91,2);

/*Table structure for table `fielddefs` */

DROP TABLE IF EXISTS `fielddefs`;

CREATE TABLE `fielddefs` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `type` smallint(6) NOT NULL DEFAULT 0,
  `custom` tinyint(4) NOT NULL DEFAULT 0,
  `description` tinytext NOT NULL,
  `long_desc` varchar(255) NOT NULL DEFAULT '',
  `mailhead` tinyint(4) NOT NULL DEFAULT 0,
  `sortkey` smallint(6) NOT NULL,
  `obsolete` tinyint(4) NOT NULL DEFAULT 0,
  `enter_bug` tinyint(4) NOT NULL DEFAULT 0,
  `buglist` tinyint(4) NOT NULL DEFAULT 0,
  `visibility_field_id` mediumint(9) DEFAULT NULL,
  `value_field_id` mediumint(9) DEFAULT NULL,
  `reverse_desc` tinytext DEFAULT NULL,
  `is_mandatory` tinyint(4) NOT NULL DEFAULT 0,
  `is_numeric` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fielddefs_name_idx` (`name`),
  KEY `fielddefs_sortkey_idx` (`sortkey`),
  KEY `fielddefs_value_field_id_idx` (`value_field_id`),
  KEY `fielddefs_is_mandatory_idx` (`is_mandatory`),
  KEY `fk_fielddefs_visibility_field_id_fielddefs_id` (`visibility_field_id`),
  CONSTRAINT `fk_fielddefs_value_field_id_fielddefs_id` FOREIGN KEY (`value_field_id`) REFERENCES `fielddefs` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_fielddefs_visibility_field_id_fielddefs_id` FOREIGN KEY (`visibility_field_id`) REFERENCES `fielddefs` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=93 DEFAULT CHARSET=utf8;

/*Data for the table `fielddefs` */

insert  into `fielddefs`(`id`,`name`,`type`,`custom`,`description`,`long_desc`,`mailhead`,`sortkey`,`obsolete`,`enter_bug`,`buglist`,`visibility_field_id`,`value_field_id`,`reverse_desc`,`is_mandatory`,`is_numeric`) values 
(1,'bug_id',0,0,'Bug #','',1,100,0,0,1,NULL,NULL,NULL,0,1),
(2,'short_desc',0,0,'Summary','',1,200,0,0,1,NULL,NULL,NULL,1,0),
(3,'classification',2,0,'Classification','',1,300,0,0,1,NULL,NULL,NULL,0,0),
(4,'product',2,0,'Product','',1,400,0,0,1,NULL,NULL,NULL,1,0),
(5,'version',0,0,'Version','',1,500,0,0,1,NULL,NULL,NULL,1,0),
(6,'rep_platform',2,0,'Platform','',1,600,0,0,1,NULL,NULL,NULL,0,0),
(7,'bug_file_loc',0,0,'URL','',1,700,0,0,1,NULL,NULL,NULL,0,0),
(8,'op_sys',2,0,'OS/Version','',1,800,0,0,1,NULL,NULL,NULL,0,0),
(9,'bug_status',2,0,'Status','',1,900,0,0,1,NULL,NULL,NULL,0,0),
(10,'status_whiteboard',0,0,'Status Whiteboard','',1,1000,0,0,1,NULL,NULL,NULL,0,0),
(11,'keywords',8,0,'Keywords','',1,1100,0,0,1,NULL,NULL,NULL,0,0),
(12,'resolution',2,0,'Resolution','',0,1200,0,0,1,NULL,NULL,NULL,0,0),
(13,'bug_severity',2,0,'Severity','',1,1300,0,0,1,NULL,NULL,NULL,0,0),
(14,'priority',2,0,'Priority','',1,1400,0,0,1,NULL,NULL,NULL,0,0),
(15,'component',2,0,'Component','',1,1500,0,0,1,NULL,NULL,NULL,1,0),
(16,'assigned_to',0,0,'AssignedTo','',1,1600,0,0,1,NULL,NULL,NULL,0,0),
(17,'reporter',0,0,'ReportedBy','',1,1700,0,0,1,NULL,NULL,NULL,0,0),
(18,'qa_contact',0,0,'QAContact','',1,1800,0,0,1,NULL,NULL,NULL,0,0),
(19,'assigned_to_realname',0,0,'AssignedToName','',0,1900,0,0,1,NULL,NULL,NULL,0,0),
(20,'reporter_realname',0,0,'ReportedByName','',0,2000,0,0,1,NULL,NULL,NULL,0,0),
(21,'qa_contact_realname',0,0,'QAContactName','',0,2100,0,0,1,NULL,NULL,NULL,0,0),
(22,'cc',0,0,'CC','',1,2200,0,0,0,NULL,NULL,NULL,0,0),
(23,'dependson',0,0,'Depends on','',1,2300,0,0,1,NULL,NULL,NULL,0,1),
(24,'blocked',0,0,'Blocks','',1,2400,0,0,1,NULL,NULL,NULL,0,1),
(25,'attachments.description',0,0,'Attachment description','',0,2500,0,0,0,NULL,NULL,NULL,0,0),
(26,'attachments.filename',0,0,'Attachment filename','',0,2600,0,0,0,NULL,NULL,NULL,0,0),
(27,'attachments.mimetype',0,0,'Attachment mime type','',0,2700,0,0,0,NULL,NULL,NULL,0,0),
(28,'attachments.ispatch',0,0,'Attachment is patch','',0,2800,0,0,0,NULL,NULL,NULL,0,1),
(29,'attachments.isobsolete',0,0,'Attachment is obsolete','',0,2900,0,0,0,NULL,NULL,NULL,0,1),
(30,'attachments.isprivate',0,0,'Attachment is private','',0,3000,0,0,0,NULL,NULL,NULL,0,1),
(31,'attachments.submitter',0,0,'Attachment creator','',0,3100,0,0,0,NULL,NULL,NULL,0,0),
(32,'target_milestone',0,0,'Target Milestone','',1,3200,0,0,1,NULL,NULL,NULL,0,0),
(33,'creation_ts',0,0,'Creation date','',0,3300,0,0,1,NULL,NULL,NULL,0,0),
(34,'delta_ts',0,0,'Last changed date','',0,3400,0,0,1,NULL,NULL,NULL,0,0),
(35,'longdesc',0,0,'Comment','',0,3500,0,0,0,NULL,NULL,NULL,0,0),
(36,'longdescs.isprivate',0,0,'Comment is private','',0,3600,0,0,0,NULL,NULL,NULL,0,1),
(37,'longdescs.count',0,0,'Number of Comments','',0,3700,0,0,1,NULL,NULL,NULL,0,1),
(38,'alias',0,0,'Alias','',0,3800,0,0,1,NULL,NULL,NULL,0,0),
(39,'everconfirmed',0,0,'Ever Confirmed','',0,3900,0,0,0,NULL,NULL,NULL,0,1),
(40,'reporter_accessible',0,0,'Reporter Accessible','',0,4000,0,0,0,NULL,NULL,NULL,0,1),
(41,'cclist_accessible',0,0,'CC Accessible','',0,4100,0,0,0,NULL,NULL,NULL,0,1),
(42,'bug_group',0,0,'Group','',1,4200,0,0,0,NULL,NULL,NULL,0,0),
(43,'estimated_time',0,0,'Estimated Hours','',1,4300,0,0,1,NULL,NULL,NULL,0,1),
(44,'remaining_time',0,0,'Remaining Hours','',0,4400,0,0,1,NULL,NULL,NULL,0,1),
(45,'deadline',5,0,'Deadline','',1,4500,0,0,1,NULL,NULL,NULL,0,0),
(46,'commenter',0,0,'Commenter','',0,4600,0,0,0,NULL,NULL,NULL,0,0),
(47,'flagtypes.name',0,0,'Flags','',0,4700,0,0,1,NULL,NULL,NULL,0,0),
(48,'requestees.login_name',0,0,'Flag Requestee','',0,4800,0,0,0,NULL,NULL,NULL,0,0),
(49,'setters.login_name',0,0,'Flag Setter','',0,4900,0,0,0,NULL,NULL,NULL,0,0),
(50,'work_time',0,0,'Hours Worked','',0,5000,0,0,1,NULL,NULL,NULL,0,1),
(51,'percentage_complete',0,0,'Percentage Complete','',0,5100,0,0,1,NULL,NULL,NULL,0,1),
(52,'content',0,0,'Content','',0,5200,0,0,0,NULL,NULL,NULL,0,0),
(53,'attach_data.thedata',0,0,'Attachment data','',0,5300,0,0,0,NULL,NULL,NULL,0,0),
(54,'owner_idle_time',0,0,'Time Since Assignee Touched','',0,5400,0,0,0,NULL,NULL,NULL,0,0),
(55,'see_also',7,0,'See Also','',0,5500,0,0,0,NULL,NULL,NULL,0,0),
(56,'tag',8,0,'Personal Tags','',0,5600,0,0,1,NULL,NULL,NULL,0,0),
(57,'last_visit_ts',5,0,'Last Visit','',0,5700,0,0,1,NULL,NULL,NULL,0,0),
(58,'comment_tag',0,0,'Comment Tag','',0,5800,0,0,0,NULL,NULL,NULL,0,0),
(59,'days_elapsed',0,0,'Days since bug changed','',0,5900,0,0,0,NULL,NULL,NULL,0,0),
(60,'cf_ipi_clust_4_status_in_progress',2,1,'Progression','More information about the case when the status is \"IN PROGRESS\".',0,10,0,1,1,9,NULL,NULL,0,0),
(61,'cf_ipi_clust_4_status_standby',2,1,'Stand By Cause','More information about the case when the status is \"STAND BY\"',0,20,0,0,1,9,NULL,NULL,0,0),
(62,'cf_ipi_clust_2_room',1,1,'Room(s)','Information about the room(s) where the case is located',0,600,0,1,1,NULL,NULL,NULL,0,0),
(63,'cf_ipi_clust_6_claim_type',2,1,'Case Type','The Case Type allows us to better organize Cases. It depends on the Case Category.',0,600,0,1,1,NULL,6,NULL,0,0),
(64,'cf_ipi_clust_1_solution',4,1,'Solution','The CURRENT solution that we have to solve this. This could (and in many occasion WILL) change over time. It can also be empty if we don\'t know what the solution is yet. It is different from the NEXT STEP field.',0,3215,0,1,1,NULL,NULL,NULL,0,0),
(65,'cf_ipi_clust_1_next_step',4,1,'Next Step','Detailed description of the next step for the Case ASSIGNEE. This is different from the solution and from the field action.',0,3220,0,0,1,NULL,NULL,NULL,0,0),
(66,'cf_ipi_clust_1_next_step_date',9,1,'Next Step Date','The date when the Next Step needs to happen.',0,3225,0,0,1,NULL,NULL,NULL,0,0),
(67,'cf_ipi_clust_3_field_action',4,1,'Action Details','Describe in details what needs to be done. This text will appear in the roadbook.',0,3245,0,0,1,NULL,NULL,NULL,0,0),
(68,'cf_ipi_clust_3_field_action_from',5,1,'Scheduled From','The Start date for the action on the field. It is also possible to add a start time.',0,3250,0,0,1,NULL,NULL,NULL,0,0),
(69,'cf_ipi_clust_3_field_action_until',5,1,'Scheduled Until','The End date for the action on the field. It is also possible to add an end time.',0,3255,0,0,1,NULL,NULL,NULL,0,0),
(70,'cf_ipi_clust_3_action_type',2,1,'Action Type','What type of action do we need to do on the field?',0,3260,0,0,1,NULL,NULL,NULL,0,0),
(71,'cf_ipi_clust_3_nber_field_visits',10,1,'Field Visits','Number of visits or trips done to diagnose and solve this case. DO NOT include the visits by the supervisors/managers for Quality Control purposes. Increases Each time there is a new visit SCHEDULED. Decrease during debrief if cancelled.',0,3205,0,0,1,NULL,NULL,NULL,0,0),
(72,'cf_ipi_clust_3_roadbook_for',3,1,'Action For','In whose roadbook shall Field Action appear? This can change over time. It is possible to choose more than 1 person if needed.',0,3235,0,0,1,NULL,NULL,NULL,0,0),
(73,'cf_ipi_clust_5_approved_budget',1,1,'Approved Budget','What is the budget that has been APPROVED to solve this. This can be different from the actual cost of the purchase or total cost for solving the case. This allows us to monitor how good we are when we have to estimate a budget.',0,3275,0,0,1,NULL,NULL,NULL,0,0),
(74,'cf_ipi_clust_5_budget',1,1,'Estimated Budget','The LATEST estimate for the budget we need to fix the problem. This can change with time and might be different than the approved budget as we gather more information.',0,3265,0,0,1,NULL,NULL,NULL,0,0),
(75,'cf_ipi_clust_8_contract_id',1,1,'Customer ID','The internal ID for the contract with the customer.',0,3270,0,0,1,NULL,NULL,NULL,0,0),
(76,'cf_ipi_clust_9_acct_action',3,1,'Accounting Action','Detailed description of the expected action from ACCOUNTING. This is different from the solution, from the field action or the next step.',0,3300,0,0,1,92,NULL,NULL,0,0),
(77,'cf_ipi_clust_9_inv_ll',1,1,'Invoice Amount (LL)','What is the amount of the invoice that we need to generate to the LANDLORD for this claim?',0,3305,0,0,1,92,NULL,NULL,0,0),
(78,'cf_ipi_clust_9_inv_det_ll',1,1,'Invoice Details (LL)','Use this if there are has specific requirement on our invoice to the Landlord. Accounting will use this to prepare the invoice and explain to the Lanldord why we have invoiced/paid him that way...',0,3310,0,0,1,92,NULL,NULL,0,0),
(79,'cf_ipi_clust_9_inv_cust',4,1,'Invoice Amount (Cust)','What is the amount of the invoice that we need to generate to the CUSTOMER for this claim?',0,3315,0,0,1,92,NULL,NULL,0,0),
(80,'cf_ipi_clust_9_inv_det_cust',4,1,'Invoice Details (Cust)','Details about the invoice: what do we need to know about this invoice? What is the information/message that we need to send to the customer together with this invoice?',0,3320,0,0,1,92,NULL,NULL,0,0),
(81,'cf_ipi_clust_5_spe_action_purchase_list',1,1,'Purchase List','Enter the list of things that we need to purchase. If the list is too long, attach a file to the claim with the detailed list and only summarize what we need to purchase here. IN Unee-T IT\'S EASIER TO USE APPROVED ATTACHMENTS TO DO THIS',0,9905,0,0,1,92,NULL,NULL,0,0),
(83,'cf_ipi_clust_5_spe_approval_for',4,1,'Approval For','Explain why you require an approval. The approver will use this information to better understand the whole situtation. IN Unee-T IT\'S BETTER TO DO THIS WHEN YOU APPROVE AN ATTACHMENT',0,9910,0,0,1,92,NULL,NULL,0,0),
(84,'cf_ipi_clust_5_spe_approval_comment',4,1,'Approval Comment','This is to explain/comment about the approval/rejection of what was requested. IN Unee-T IT\'S BETTER TO DO THIS WHEN WE APPROVE AN ATTACHMENT.',0,9915,0,0,1,92,NULL,NULL,0,0),
(85,'cf_ipi_clust_5_spe_contractor',4,1,'Contractor ID','The name of the contractor that has been assigned to work on this case. IN Unee-T THIS HAS BEEN MOVED. THE CONTRACTOR IS A STAKEHOLDER.',0,9920,0,0,1,92,NULL,NULL,0,0),
(87,'cf_ipi_clust_5_spe_purchase_cost',1,1,'Purchase Cost','What was the ACTUAL purchase cost for the purchase we did. This can be (and usually is) slightly different from the approved budget (but NOT higher than the approved budget).',0,9925,0,0,1,92,NULL,NULL,0,0),
(88,'cf_ipi_clust_7_spe_bill_number',1,1,'Bill Nber','The Supplier\'s invoice number. This is so that accounting can easily find explanations about a supplier invoice if this is needed. IN Unee-T THIS HAS BEEN MOVED TO ATTACHMENTS',0,9930,0,0,1,92,NULL,NULL,0,0),
(89,'cf_ipi_clust_7_spe_payment_type',2,1,'Payment Type','How will we pay the contractor? This is important information so that accounting can prepare the payment accordingly. This will ensure we pay our supplier as fast as possible and minimize the risk of misunderstandings.',0,9935,0,0,1,92,NULL,NULL,0,0),
(90,'cf_ipi_clust_7_spe_contractor_payment',4,1,'Contractor Payment','Use this if the supplier has specific requirement about the payment. Accounting will use this to explain to the supplier why we have invoiced/paid him that way...',0,9940,0,0,1,92,NULL,NULL,0,0),
(91,'cf_ipi_clust_8_spe_customer',1,1,'Customer','The name of the customer. IN Unee-T WE USE THE CUSTOMER ID INSTEAD',0,9945,0,0,1,92,NULL,NULL,0,0),
(92,'cf_specific_for',2,1,'Field For','The name and id of the Unee-T customer that can see these fields',0,9900,0,0,1,NULL,NULL,NULL,0,0);

/*Table structure for table `flagexclusions` */

DROP TABLE IF EXISTS `flagexclusions`;

CREATE TABLE `flagexclusions` (
  `type_id` smallint(6) NOT NULL,
  `product_id` smallint(6) DEFAULT NULL,
  `component_id` mediumint(9) DEFAULT NULL,
  UNIQUE KEY `flagexclusions_type_id_idx` (`type_id`,`product_id`,`component_id`),
  KEY `fk_flagexclusions_product_id_products_id` (`product_id`),
  KEY `fk_flagexclusions_component_id_components_id` (`component_id`),
  CONSTRAINT `fk_flagexclusions_component_id_components_id` FOREIGN KEY (`component_id`) REFERENCES `components` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_flagexclusions_product_id_products_id` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_flagexclusions_type_id_flagtypes_id` FOREIGN KEY (`type_id`) REFERENCES `flagtypes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `flagexclusions` */

/*Table structure for table `flaginclusions` */

DROP TABLE IF EXISTS `flaginclusions`;

CREATE TABLE `flaginclusions` (
  `type_id` smallint(6) NOT NULL,
  `product_id` smallint(6) DEFAULT NULL,
  `component_id` mediumint(9) DEFAULT NULL,
  UNIQUE KEY `flaginclusions_type_id_idx` (`type_id`,`product_id`,`component_id`),
  KEY `fk_flaginclusions_product_id_products_id` (`product_id`),
  KEY `fk_flaginclusions_component_id_components_id` (`component_id`),
  CONSTRAINT `fk_flaginclusions_component_id_components_id` FOREIGN KEY (`component_id`) REFERENCES `components` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_flaginclusions_product_id_products_id` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_flaginclusions_type_id_flagtypes_id` FOREIGN KEY (`type_id`) REFERENCES `flagtypes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `flaginclusions` */

insert  into `flaginclusions`(`type_id`,`product_id`,`component_id`) values 
(1,1,NULL),
(2,1,NULL),
(3,1,NULL),
(4,1,NULL),
(5,1,NULL),
(6,1,NULL);

/*Table structure for table `flags` */

DROP TABLE IF EXISTS `flags`;

CREATE TABLE `flags` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `type_id` smallint(6) NOT NULL,
  `status` char(1) NOT NULL,
  `bug_id` mediumint(9) NOT NULL,
  `attach_id` mediumint(9) DEFAULT NULL,
  `creation_date` datetime NOT NULL,
  `modification_date` datetime DEFAULT NULL,
  `setter_id` mediumint(9) NOT NULL,
  `requestee_id` mediumint(9) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `flags_bug_id_idx` (`bug_id`,`attach_id`),
  KEY `flags_setter_id_idx` (`setter_id`),
  KEY `flags_requestee_id_idx` (`requestee_id`),
  KEY `flags_type_id_idx` (`type_id`),
  KEY `fk_flags_attach_id_attachments_attach_id` (`attach_id`),
  CONSTRAINT `fk_flags_attach_id_attachments_attach_id` FOREIGN KEY (`attach_id`) REFERENCES `attachments` (`attach_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_flags_bug_id_bugs_bug_id` FOREIGN KEY (`bug_id`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_flags_requestee_id_profiles_userid` FOREIGN KEY (`requestee_id`) REFERENCES `profiles` (`userid`) ON UPDATE CASCADE,
  CONSTRAINT `fk_flags_setter_id_profiles_userid` FOREIGN KEY (`setter_id`) REFERENCES `profiles` (`userid`) ON UPDATE CASCADE,
  CONSTRAINT `fk_flags_type_id_flagtypes_id` FOREIGN KEY (`type_id`) REFERENCES `flagtypes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `flags` */

/*Table structure for table `flagtypes` */

DROP TABLE IF EXISTS `flagtypes`;

CREATE TABLE `flagtypes` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `description` mediumtext NOT NULL,
  `cc_list` varchar(200) DEFAULT NULL,
  `target_type` char(1) NOT NULL DEFAULT 'b',
  `is_active` tinyint(4) NOT NULL DEFAULT 1,
  `is_requestable` tinyint(4) NOT NULL DEFAULT 0,
  `is_requesteeble` tinyint(4) NOT NULL DEFAULT 0,
  `is_multiplicable` tinyint(4) NOT NULL DEFAULT 0,
  `sortkey` smallint(6) NOT NULL DEFAULT 0,
  `grant_group_id` mediumint(9) DEFAULT NULL,
  `request_group_id` mediumint(9) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_flagtypes_grant_group_id_groups_id` (`grant_group_id`),
  KEY `fk_flagtypes_request_group_id_groups_id` (`request_group_id`),
  CONSTRAINT `fk_flagtypes_grant_group_id_groups_id` FOREIGN KEY (`grant_group_id`) REFERENCES `groups` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_flagtypes_request_group_id_groups_id` FOREIGN KEY (`request_group_id`) REFERENCES `groups` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

/*Data for the table `flagtypes` */

insert  into `flagtypes`(`id`,`name`,`description`,`cc_list`,`target_type`,`is_active`,`is_requestable`,`is_requesteeble`,`is_multiplicable`,`sortkey`,`grant_group_id`,`request_group_id`) values 
(1,'Test_Unit_1_A_P1_Next_Step','Approval for the Next Step of the case.','','b',1,1,1,1,10,20,19),
(2,'Test_Unit_1_A_P1_Solution','Approval for the Solution of this case.','','b',1,1,1,1,20,22,21),
(3,'Test_Unit_1_A_P1_Budget','Approval for the Budget for this case.','','b',1,1,1,1,30,23,24),
(4,'Test_Unit_1_A_P1_Attachment','Approval for this Attachment.','','a',1,1,1,1,10,26,25),
(5,'Test_Unit_1_A_P1_OK_to_pay','Approval to pay this bill.','','a',1,1,1,1,20,27,28),
(6,'Test_Unit_1_A_P1_is_paid','Confirm if this bill has been paid.','','a',1,1,1,1,30,29,30);

/*Table structure for table `group_control_map` */

DROP TABLE IF EXISTS `group_control_map`;

CREATE TABLE `group_control_map` (
  `group_id` mediumint(9) NOT NULL,
  `product_id` smallint(6) NOT NULL,
  `entry` tinyint(4) NOT NULL DEFAULT 0,
  `membercontrol` tinyint(4) NOT NULL DEFAULT 0,
  `othercontrol` tinyint(4) NOT NULL DEFAULT 0,
  `canedit` tinyint(4) NOT NULL DEFAULT 0,
  `editcomponents` tinyint(4) NOT NULL DEFAULT 0,
  `editbugs` tinyint(4) NOT NULL DEFAULT 0,
  `canconfirm` tinyint(4) NOT NULL DEFAULT 0,
  UNIQUE KEY `group_control_map_product_id_idx` (`product_id`,`group_id`),
  KEY `group_control_map_group_id_idx` (`group_id`),
  CONSTRAINT `fk_group_control_map_group_id_groups_id` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_group_control_map_product_id_products_id` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `group_control_map` */

/*Table structure for table `group_group_map` */

DROP TABLE IF EXISTS `group_group_map`;

CREATE TABLE `group_group_map` (
  `member_id` mediumint(9) NOT NULL,
  `grantor_id` mediumint(9) NOT NULL,
  `grant_type` tinyint(4) NOT NULL DEFAULT 0,
  UNIQUE KEY `group_group_map_member_id_idx` (`member_id`,`grantor_id`,`grant_type`),
  KEY `fk_group_group_map_grantor_id_groups_id` (`grantor_id`),
  CONSTRAINT `fk_group_group_map_grantor_id_groups_id` FOREIGN KEY (`grantor_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_group_group_map_member_id_groups_id` FOREIGN KEY (`member_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `group_group_map` */

insert  into `group_group_map`(`member_id`,`grantor_id`,`grant_type`) values 
(1,1,0),
(1,1,1),
(1,1,2),
(1,2,0),
(1,2,1),
(1,2,2),
(1,3,0),
(1,3,1),
(1,3,2),
(1,4,0),
(1,4,1),
(1,4,2),
(1,5,0),
(1,5,1),
(1,5,2),
(1,6,0),
(1,6,1),
(1,6,2),
(1,7,0),
(1,7,1),
(1,7,2),
(1,8,0),
(1,8,1),
(1,8,2),
(1,9,0),
(1,9,1),
(1,9,2),
(1,10,0),
(1,10,1),
(1,10,2),
(1,11,0),
(1,11,1),
(1,11,2),
(1,12,0),
(1,12,1),
(1,12,2),
(1,13,0),
(1,13,1),
(1,13,2),
(1,14,0),
(1,14,1),
(1,14,2),
(1,15,0),
(1,15,1),
(1,15,2),
(1,16,0),
(1,16,1),
(1,16,2),
(1,17,0),
(1,17,1),
(1,17,2),
(1,18,0),
(1,18,1),
(1,18,2),
(1,19,0),
(1,19,1),
(1,19,2),
(1,20,1),
(1,20,2),
(1,21,0),
(1,21,1),
(1,21,2),
(1,22,1),
(1,22,2),
(1,23,1),
(1,23,2),
(1,24,1),
(1,24,2),
(1,25,1),
(1,25,2),
(1,26,0),
(1,26,1),
(1,26,2),
(1,27,1),
(1,27,2),
(1,28,1),
(1,28,2),
(1,29,0),
(1,29,1),
(1,29,2),
(1,30,0),
(1,30,1),
(1,30,2),
(1,31,1),
(1,31,2),
(31,16,0),
(31,17,0),
(31,18,0),
(31,19,0),
(31,20,0),
(31,21,0),
(31,22,0),
(31,23,0),
(31,24,0),
(31,25,0),
(31,26,0),
(31,27,0),
(31,28,0),
(31,29,0),
(31,30,0);

/*Table structure for table `groups` */

DROP TABLE IF EXISTS `groups`;

CREATE TABLE `groups` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` mediumtext NOT NULL,
  `isbuggroup` tinyint(4) NOT NULL,
  `userregexp` tinytext NOT NULL DEFAULT '',
  `isactive` tinyint(4) NOT NULL DEFAULT 1,
  `icon_url` tinytext DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `groups_name_idx` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8;

/*Data for the table `groups` */

insert  into `groups`(`id`,`name`,`description`,`isbuggroup`,`userregexp`,`isactive`,`icon_url`) values 
(1,'admin','Administrators',0,'',1,NULL),
(2,'tweakparams','Can change Parameters',0,'',1,NULL),
(3,'editusers','Can edit or disable users',0,'',1,NULL),
(4,'creategroups','Can create and destroy groups',0,'',1,NULL),
(5,'editclassifications','Can create, destroy, and edit classifications',0,'',1,NULL),
(6,'editcomponents','Can create, destroy, and edit components',0,'',1,NULL),
(7,'editkeywords','Can create, destroy, and edit keywords',0,'',1,NULL),
(8,'editbugs','Can edit all bug fields',0,'',1,NULL),
(9,'canconfirm','Can confirm a bug or mark it a duplicate',0,'',1,NULL),
(10,'bz_canusewhineatothers','Can configure whine reports for other users',0,'',1,NULL),
(11,'bz_canusewhines','User can configure whine reports for self',0,'',1,NULL),
(12,'bz_sudoers','Can perform actions as other users',0,'',1,NULL),
(13,'bz_sudo_protect','Can not be impersonated by other users',0,'',1,NULL),
(14,'bz_quip_moderators','Can moderate quips',0,'',1,NULL),
(15,'syst_private_comment','A group to allow user to see the private comments in ALL the activities they are allowed to see. This is for Employees vs external users.',1,'',0,NULL),
(16,'syst_see_timetracking','A group to allow users to see the time tracking information in ALL the activities they are allowed to see.',1,'',0,NULL),
(17,'syst_create_shared_queries','A group for users who can create, save and share search queries.',1,'',0,NULL),
(18,'syst_tag_comments','A group to allow users to tag comments in ALL the activities they are allowed to see.',1,'',0,NULL),
(19,'Test Unit 1 A #1 - RA Next Step','Request approval for the Next step in a case',1,'',0,NULL),
(20,'Test Unit 1 A #1 - GA Next Step','Grant approval for the Next step in a case',1,'',0,NULL),
(21,'Test Unit 1 A #1 - RA Solution','Request approval for the Solution in a case',1,'',0,NULL),
(22,'Test Unit 1 A #1 - GA Solution','Grant approval for the Solution in a case',1,'',0,NULL),
(23,'Test Unit 1 A #1 - GA Budget','Request approval for the Budget in a case',1,'',0,NULL),
(24,'Test Unit 1 A #1 - RA Budget','Request approval for the Budget in a case',1,'',0,NULL),
(25,'Test Unit 1 A #1 - RA Attachment','Request approval for an Attachment in a case',1,'',0,NULL),
(26,'Test Unit 1 A #1 - GA Attachment','Grant approval for an Attachment in a case',1,'',0,NULL),
(27,'Test Unit 1 A #1 - GA OK to Pay','Grant approval to pay (for a bill/attachment)',1,'',0,NULL),
(28,'Test Unit 1 A #1 - RA OK to Pay','Request approval to pay (for a bill/attachment)',1,'',0,NULL),
(29,'Test Unit 1 A #1 - GA is Paid','Confirm that it\'s paid (for a bill/attachment)',1,'',0,NULL),
(30,'Test Unit 1 A #1 - RA is Paid','Ask if it\'s paid (for a bill/attachment)',1,'',0,NULL),
(31,'Test Unit 1 A #1 - All permissions','Access to All the groups a stakeholder needs for this unit',1,'',0,NULL);

/*Table structure for table `keyworddefs` */

DROP TABLE IF EXISTS `keyworddefs`;

CREATE TABLE `keyworddefs` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `description` mediumtext NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `keyworddefs_name_idx` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `keyworddefs` */

/*Table structure for table `keywords` */

DROP TABLE IF EXISTS `keywords`;

CREATE TABLE `keywords` (
  `bug_id` mediumint(9) NOT NULL,
  `keywordid` smallint(6) NOT NULL,
  UNIQUE KEY `keywords_bug_id_idx` (`bug_id`,`keywordid`),
  KEY `keywords_keywordid_idx` (`keywordid`),
  CONSTRAINT `fk_keywords_bug_id_bugs_bug_id` FOREIGN KEY (`bug_id`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_keywords_keywordid_keyworddefs_id` FOREIGN KEY (`keywordid`) REFERENCES `keyworddefs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `keywords` */

/*Table structure for table `login_failure` */

DROP TABLE IF EXISTS `login_failure`;

CREATE TABLE `login_failure` (
  `user_id` mediumint(9) NOT NULL,
  `login_time` datetime NOT NULL,
  `ip_addr` varchar(40) NOT NULL,
  KEY `login_failure_user_id_idx` (`user_id`),
  CONSTRAINT `fk_login_failure_user_id_profiles_userid` FOREIGN KEY (`user_id`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `login_failure` */

/*Table structure for table `logincookies` */

DROP TABLE IF EXISTS `logincookies`;

CREATE TABLE `logincookies` (
  `cookie` varchar(16) NOT NULL,
  `userid` mediumint(9) NOT NULL,
  `ipaddr` varchar(40) DEFAULT NULL,
  `lastused` datetime NOT NULL,
  PRIMARY KEY (`cookie`),
  KEY `logincookies_lastused_idx` (`lastused`),
  KEY `fk_logincookies_userid_profiles_userid` (`userid`),
  CONSTRAINT `fk_logincookies_userid_profiles_userid` FOREIGN KEY (`userid`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `logincookies` */

insert  into `logincookies`(`cookie`,`userid`,`ipaddr`,`lastused`) values 
('rp0pTd2N6d',1,NULL,'2017-10-27 00:40:49'),
('xeQ7lgGNQj',1,NULL,'2017-10-26 07:58:57'),
('zwvmICyGAU',1,NULL,'2017-10-26 23:06:52');

/*Table structure for table `longdescs` */

DROP TABLE IF EXISTS `longdescs`;

CREATE TABLE `longdescs` (
  `comment_id` int(11) NOT NULL AUTO_INCREMENT,
  `bug_id` mediumint(9) NOT NULL,
  `who` mediumint(9) NOT NULL,
  `bug_when` datetime NOT NULL,
  `work_time` decimal(7,2) NOT NULL DEFAULT 0.00,
  `thetext` mediumtext NOT NULL,
  `isprivate` tinyint(4) NOT NULL DEFAULT 0,
  `already_wrapped` tinyint(4) NOT NULL DEFAULT 0,
  `type` smallint(6) NOT NULL DEFAULT 0,
  `extra_data` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`comment_id`),
  KEY `longdescs_bug_id_idx` (`bug_id`,`work_time`),
  KEY `longdescs_who_idx` (`who`,`bug_id`),
  KEY `longdescs_bug_when_idx` (`bug_when`),
  CONSTRAINT `fk_longdescs_bug_id_bugs_bug_id` FOREIGN KEY (`bug_id`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_longdescs_who_profiles_userid` FOREIGN KEY (`who`) REFERENCES `profiles` (`userid`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `longdescs` */

/*Table structure for table `longdescs_tags` */

DROP TABLE IF EXISTS `longdescs_tags`;

CREATE TABLE `longdescs_tags` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `comment_id` int(11) DEFAULT NULL,
  `tag` varchar(24) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `longdescs_tags_idx` (`comment_id`,`tag`),
  CONSTRAINT `fk_longdescs_tags_comment_id_longdescs_comment_id` FOREIGN KEY (`comment_id`) REFERENCES `longdescs` (`comment_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `longdescs_tags` */

/*Table structure for table `longdescs_tags_activity` */

DROP TABLE IF EXISTS `longdescs_tags_activity`;

CREATE TABLE `longdescs_tags_activity` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `bug_id` mediumint(9) NOT NULL,
  `comment_id` int(11) DEFAULT NULL,
  `who` mediumint(9) NOT NULL,
  `bug_when` datetime NOT NULL,
  `added` varchar(24) DEFAULT NULL,
  `removed` varchar(24) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `longdescs_tags_activity_bug_id_idx` (`bug_id`),
  KEY `fk_longdescs_tags_activity_comment_id_longdescs_comment_id` (`comment_id`),
  KEY `fk_longdescs_tags_activity_who_profiles_userid` (`who`),
  CONSTRAINT `fk_longdescs_tags_activity_bug_id_bugs_bug_id` FOREIGN KEY (`bug_id`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_longdescs_tags_activity_comment_id_longdescs_comment_id` FOREIGN KEY (`comment_id`) REFERENCES `longdescs` (`comment_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_longdescs_tags_activity_who_profiles_userid` FOREIGN KEY (`who`) REFERENCES `profiles` (`userid`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `longdescs_tags_activity` */

/*Table structure for table `longdescs_tags_weights` */

DROP TABLE IF EXISTS `longdescs_tags_weights`;

CREATE TABLE `longdescs_tags_weights` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `tag` varchar(24) NOT NULL,
  `weight` mediumint(9) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `longdescs_tags_weights_tag_idx` (`tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `longdescs_tags_weights` */

/*Table structure for table `mail_staging` */

DROP TABLE IF EXISTS `mail_staging`;

CREATE TABLE `mail_staging` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message` longblob NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `mail_staging` */

/*Table structure for table `milestones` */

DROP TABLE IF EXISTS `milestones`;

CREATE TABLE `milestones` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `product_id` smallint(6) NOT NULL,
  `value` varchar(64) NOT NULL,
  `sortkey` smallint(6) NOT NULL DEFAULT 0,
  `isactive` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `milestones_product_id_idx` (`product_id`,`value`),
  CONSTRAINT `fk_milestones_product_id_products_id` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Data for the table `milestones` */

insert  into `milestones`(`id`,`product_id`,`value`,`sortkey`,`isactive`) values 
(1,1,'---',0,1);

/*Table structure for table `namedqueries` */

DROP TABLE IF EXISTS `namedqueries`;

CREATE TABLE `namedqueries` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `userid` mediumint(9) NOT NULL,
  `name` varchar(64) NOT NULL,
  `query` mediumtext NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `namedqueries_userid_idx` (`userid`,`name`),
  CONSTRAINT `fk_namedqueries_userid_profiles_userid` FOREIGN KEY (`userid`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `namedqueries` */

/*Table structure for table `namedqueries_link_in_footer` */

DROP TABLE IF EXISTS `namedqueries_link_in_footer`;

CREATE TABLE `namedqueries_link_in_footer` (
  `namedquery_id` mediumint(9) NOT NULL,
  `user_id` mediumint(9) NOT NULL,
  UNIQUE KEY `namedqueries_link_in_footer_id_idx` (`namedquery_id`,`user_id`),
  KEY `namedqueries_link_in_footer_userid_idx` (`user_id`),
  CONSTRAINT `fk_namedqueries_link_in_footer_namedquery_id_namedqueries_id` FOREIGN KEY (`namedquery_id`) REFERENCES `namedqueries` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_namedqueries_link_in_footer_user_id_profiles_userid` FOREIGN KEY (`user_id`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `namedqueries_link_in_footer` */

/*Table structure for table `namedquery_group_map` */

DROP TABLE IF EXISTS `namedquery_group_map`;

CREATE TABLE `namedquery_group_map` (
  `namedquery_id` mediumint(9) NOT NULL,
  `group_id` mediumint(9) NOT NULL,
  UNIQUE KEY `namedquery_group_map_namedquery_id_idx` (`namedquery_id`),
  KEY `namedquery_group_map_group_id_idx` (`group_id`),
  CONSTRAINT `fk_namedquery_group_map_group_id_groups_id` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_namedquery_group_map_namedquery_id_namedqueries_id` FOREIGN KEY (`namedquery_id`) REFERENCES `namedqueries` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `namedquery_group_map` */

/*Table structure for table `op_sys` */

DROP TABLE IF EXISTS `op_sys`;

CREATE TABLE `op_sys` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `value` varchar(64) NOT NULL,
  `sortkey` smallint(6) NOT NULL DEFAULT 0,
  `isactive` tinyint(4) NOT NULL DEFAULT 1,
  `visibility_value_id` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `op_sys_value_idx` (`value`),
  KEY `op_sys_sortkey_idx` (`sortkey`,`value`),
  KEY `op_sys_visibility_value_id_idx` (`visibility_value_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

/*Data for the table `op_sys` */

insert  into `op_sys`(`id`,`value`,`sortkey`,`isactive`,`visibility_value_id`) values 
(1,'Customer/Occupant',100,1,NULL),
(2,'Sales Team',200,1,NULL),
(3,'Field Technician',300,1,NULL),
(4,'Sourcing',400,1,NULL),
(5,'Other',10000,1,NULL),
(6,'House Keeper',500,1,NULL),
(7,'Accounting',5000,1,NULL),
(8,'Unspecified',50,1,NULL),
(9,'Management',5000,1,NULL),
(10,'Landlord',600,1,NULL),
(11,'LL Agent',700,1,NULL),
(12,'Mgt Office',550,1,NULL),
(13,'Customer Service',250,1,NULL);

/*Table structure for table `priority` */

DROP TABLE IF EXISTS `priority`;

CREATE TABLE `priority` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `value` varchar(64) NOT NULL,
  `sortkey` smallint(6) NOT NULL DEFAULT 0,
  `isactive` tinyint(4) NOT NULL DEFAULT 1,
  `visibility_value_id` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `priority_value_idx` (`value`),
  KEY `priority_sortkey_idx` (`sortkey`,`value`),
  KEY `priority_visibility_value_id_idx` (`visibility_value_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

/*Data for the table `priority` */

insert  into `priority`(`id`,`value`,`sortkey`,`isactive`,`visibility_value_id`) values 
(1,'P1',100,1,NULL),
(2,'P2',200,1,NULL),
(3,'P3',300,1,NULL);

/*Table structure for table `products` */

DROP TABLE IF EXISTS `products`;

CREATE TABLE `products` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `classification_id` smallint(6) NOT NULL DEFAULT 1,
  `description` mediumtext NOT NULL,
  `isactive` tinyint(4) NOT NULL DEFAULT 1,
  `defaultmilestone` varchar(64) NOT NULL DEFAULT '---',
  `allows_unconfirmed` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `products_name_idx` (`name`),
  KEY `fk_products_classification_id_classifications_id` (`classification_id`),
  CONSTRAINT `fk_products_classification_id_classifications_id` FOREIGN KEY (`classification_id`) REFERENCES `classifications` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Data for the table `products` */

insert  into `products`(`id`,`name`,`classification_id`,`description`,`isactive`,`defaultmilestone`,`allows_unconfirmed`) values 
(1,'Test Unit 1 A',1,'Demo unit 1.\r\nThis unit is located at:\r\nProperty A address. \r\nWe can add a few comment about the unit if needed.',1,'---',1);

/*Table structure for table `profile_search` */

DROP TABLE IF EXISTS `profile_search`;

CREATE TABLE `profile_search` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` mediumint(9) NOT NULL,
  `bug_list` mediumtext NOT NULL,
  `list_order` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `profile_search_user_id_idx` (`user_id`),
  CONSTRAINT `fk_profile_search_user_id_profiles_userid` FOREIGN KEY (`user_id`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `profile_search` */

/*Table structure for table `profile_setting` */

DROP TABLE IF EXISTS `profile_setting`;

CREATE TABLE `profile_setting` (
  `user_id` mediumint(9) NOT NULL,
  `setting_name` varchar(32) NOT NULL,
  `setting_value` varchar(32) NOT NULL,
  UNIQUE KEY `profile_setting_value_unique_idx` (`user_id`,`setting_name`),
  KEY `fk_profile_setting_setting_name_setting_name` (`setting_name`),
  CONSTRAINT `fk_profile_setting_setting_name_setting_name` FOREIGN KEY (`setting_name`) REFERENCES `setting` (`name`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_profile_setting_user_id_profiles_userid` FOREIGN KEY (`user_id`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `profile_setting` */

/*Table structure for table `profiles` */

DROP TABLE IF EXISTS `profiles`;

CREATE TABLE `profiles` (
  `userid` mediumint(9) NOT NULL AUTO_INCREMENT,
  `login_name` varchar(255) NOT NULL,
  `cryptpassword` varchar(128) DEFAULT NULL,
  `realname` varchar(255) NOT NULL DEFAULT '',
  `disabledtext` mediumtext NOT NULL DEFAULT '',
  `disable_mail` tinyint(4) NOT NULL DEFAULT 0,
  `mybugslink` tinyint(4) NOT NULL DEFAULT 1,
  `extern_id` varchar(64) DEFAULT NULL,
  `is_enabled` tinyint(4) NOT NULL DEFAULT 1,
  `last_seen_date` datetime DEFAULT NULL,
  PRIMARY KEY (`userid`),
  UNIQUE KEY `profiles_login_name_idx` (`login_name`),
  UNIQUE KEY `profiles_extern_id_idx` (`extern_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Data for the table `profiles` */

insert  into `profiles`(`userid`,`login_name`,`cryptpassword`,`realname`,`disabledtext`,`disable_mail`,`mybugslink`,`extern_id`,`is_enabled`,`last_seen_date`) values 
(1,'administrator@example.com','B8AgzURt,NDrX2Bt8stpgXPKsNRYaHmm0V2K1+qhfnt76oLAvN+Q{SHA-256}','Administrator','',0,1,NULL,1,'2017-10-27 00:00:00');

/*Table structure for table `profiles_activity` */

DROP TABLE IF EXISTS `profiles_activity`;

CREATE TABLE `profiles_activity` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `userid` mediumint(9) NOT NULL,
  `who` mediumint(9) NOT NULL,
  `profiles_when` datetime NOT NULL,
  `fieldid` mediumint(9) NOT NULL,
  `oldvalue` tinytext DEFAULT NULL,
  `newvalue` tinytext DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `profiles_activity_userid_idx` (`userid`),
  KEY `profiles_activity_profiles_when_idx` (`profiles_when`),
  KEY `profiles_activity_fieldid_idx` (`fieldid`),
  KEY `fk_profiles_activity_who_profiles_userid` (`who`),
  CONSTRAINT `fk_profiles_activity_fieldid_fielddefs_id` FOREIGN KEY (`fieldid`) REFERENCES `fielddefs` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_profiles_activity_userid_profiles_userid` FOREIGN KEY (`userid`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_profiles_activity_who_profiles_userid` FOREIGN KEY (`who`) REFERENCES `profiles` (`userid`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Data for the table `profiles_activity` */

insert  into `profiles_activity`(`id`,`userid`,`who`,`profiles_when`,`fieldid`,`oldvalue`,`newvalue`) values 
(1,1,1,'2017-10-26 04:29:48',33,NULL,'2017-10-26 04:29:48');

/*Table structure for table `quips` */

DROP TABLE IF EXISTS `quips`;

CREATE TABLE `quips` (
  `quipid` mediumint(9) NOT NULL AUTO_INCREMENT,
  `userid` mediumint(9) DEFAULT NULL,
  `quip` varchar(512) NOT NULL,
  `approved` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`quipid`),
  KEY `fk_quips_userid_profiles_userid` (`userid`),
  CONSTRAINT `fk_quips_userid_profiles_userid` FOREIGN KEY (`userid`) REFERENCES `profiles` (`userid`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `quips` */

/*Table structure for table `rep_platform` */

DROP TABLE IF EXISTS `rep_platform`;

CREATE TABLE `rep_platform` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `value` varchar(64) NOT NULL,
  `sortkey` smallint(6) NOT NULL DEFAULT 0,
  `isactive` tinyint(4) NOT NULL DEFAULT 1,
  `visibility_value_id` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `rep_platform_value_idx` (`value`),
  KEY `rep_platform_sortkey_idx` (`sortkey`,`value`),
  KEY `rep_platform_visibility_value_id_idx` (`visibility_value_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

/*Data for the table `rep_platform` */

insert  into `rep_platform`(`id`,`value`,`sortkey`,`isactive`,`visibility_value_id`) values 
(1,'---',5,1,NULL),
(2,'Repair',10,1,NULL),
(3,'Maintenance',15,1,NULL),
(4,'Housekeeping',20,1,NULL),
(5,'Devices',25,1,NULL),
(6,'Renovation',30,1,NULL),
(7,'Complex Project',35,1,NULL),
(8,'Extra Service',40,1,NULL),
(9,'Utilities',45,1,NULL),
(10,'Other',50,1,NULL);

/*Table structure for table `reports` */

DROP TABLE IF EXISTS `reports`;

CREATE TABLE `reports` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `user_id` mediumint(9) NOT NULL,
  `name` varchar(64) NOT NULL,
  `query` mediumtext NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `reports_user_id_idx` (`user_id`,`name`),
  CONSTRAINT `fk_reports_user_id_profiles_userid` FOREIGN KEY (`user_id`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `reports` */

/*Table structure for table `resolution` */

DROP TABLE IF EXISTS `resolution`;

CREATE TABLE `resolution` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `value` varchar(64) NOT NULL,
  `sortkey` smallint(6) NOT NULL DEFAULT 0,
  `isactive` tinyint(4) NOT NULL DEFAULT 1,
  `visibility_value_id` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `resolution_value_idx` (`value`),
  KEY `resolution_sortkey_idx` (`sortkey`,`value`),
  KEY `resolution_visibility_value_id_idx` (`visibility_value_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

/*Data for the table `resolution` */

insert  into `resolution`(`id`,`value`,`sortkey`,`isactive`,`visibility_value_id`) values 
(1,'',100,1,NULL),
(2,'FIXED',200,1,NULL),
(3,'INVALID',300,1,NULL),
(4,'WONTFIX',400,1,NULL),
(5,'DUPLICATE',500,1,NULL),
(6,'WORKSFORME',600,1,NULL);

/*Table structure for table `series` */

DROP TABLE IF EXISTS `series`;

CREATE TABLE `series` (
  `series_id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `creator` mediumint(9) DEFAULT NULL,
  `category` smallint(6) NOT NULL,
  `subcategory` smallint(6) NOT NULL,
  `name` varchar(64) NOT NULL,
  `frequency` smallint(6) NOT NULL,
  `query` mediumtext NOT NULL,
  `is_public` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`series_id`),
  UNIQUE KEY `series_category_idx` (`category`,`subcategory`,`name`),
  KEY `series_creator_idx` (`creator`),
  KEY `fk_series_subcategory_series_categories_id` (`subcategory`),
  CONSTRAINT `fk_series_category_series_categories_id` FOREIGN KEY (`category`) REFERENCES `series_categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_series_creator_profiles_userid` FOREIGN KEY (`creator`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_series_subcategory_series_categories_id` FOREIGN KEY (`subcategory`) REFERENCES `series_categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `series` */

/*Table structure for table `series_categories` */

DROP TABLE IF EXISTS `series_categories`;

CREATE TABLE `series_categories` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `series_categories_name_idx` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

/*Data for the table `series_categories` */

insert  into `series_categories`(`id`,`name`) values 
(2,'-All-'),
(3,'Test_stakeholder_1'),
(1,'Test_Unit_1_A');

/*Table structure for table `series_data` */

DROP TABLE IF EXISTS `series_data`;

CREATE TABLE `series_data` (
  `series_id` mediumint(9) NOT NULL,
  `series_date` datetime NOT NULL,
  `series_value` mediumint(9) NOT NULL,
  UNIQUE KEY `series_data_series_id_idx` (`series_id`,`series_date`),
  CONSTRAINT `fk_series_data_series_id_series_series_id` FOREIGN KEY (`series_id`) REFERENCES `series` (`series_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `series_data` */

/*Table structure for table `setting` */

DROP TABLE IF EXISTS `setting`;

CREATE TABLE `setting` (
  `name` varchar(32) NOT NULL,
  `default_value` varchar(32) NOT NULL,
  `is_enabled` tinyint(4) NOT NULL DEFAULT 1,
  `subclass` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `setting` */

insert  into `setting`(`name`,`default_value`,`is_enabled`,`subclass`) values 
('bugmail_new_prefix','on',1,NULL),
('comment_box_position','after_comments',1,NULL),
('comment_sort_order','oldest_to_newest',1,NULL),
('csv_colsepchar',',',1,NULL),
('display_quips','off',0,NULL),
('email_format','html',1,NULL),
('lang','en',1,'Lang'),
('possible_duplicates','on',1,NULL),
('post_bug_submit_action','same_bug',1,NULL),
('quicksearch_fulltext','on',1,NULL),
('quote_replies','quoted_reply',1,NULL),
('requestee_cc','on',1,NULL),
('skin','skin',0,'Skin'),
('state_addselfcc','cc_unless_role',1,NULL),
('timezone','local',1,'Timezone'),
('zoom_textareas','on',1,NULL);

/*Table structure for table `setting_value` */

DROP TABLE IF EXISTS `setting_value`;

CREATE TABLE `setting_value` (
  `name` varchar(32) NOT NULL,
  `value` varchar(32) NOT NULL,
  `sortindex` smallint(6) NOT NULL,
  UNIQUE KEY `setting_value_nv_unique_idx` (`name`,`value`),
  UNIQUE KEY `setting_value_ns_unique_idx` (`name`,`sortindex`),
  CONSTRAINT `fk_setting_value_name_setting_name` FOREIGN KEY (`name`) REFERENCES `setting` (`name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `setting_value` */

insert  into `setting_value`(`name`,`value`,`sortindex`) values 
('bugmail_new_prefix','on',5),
('bugmail_new_prefix','off',10),
('comment_box_position','before_comments',5),
('comment_box_position','after_comments',10),
('comment_sort_order','oldest_to_newest',5),
('comment_sort_order','newest_to_oldest',10),
('comment_sort_order','newest_to_oldest_desc_first',15),
('csv_colsepchar',',',5),
('csv_colsepchar',';',10),
('display_quips','on',5),
('display_quips','off',10),
('email_format','html',5),
('email_format','text_only',10),
('possible_duplicates','on',5),
('possible_duplicates','off',10),
('post_bug_submit_action','next_bug',5),
('post_bug_submit_action','same_bug',10),
('post_bug_submit_action','nothing',15),
('quicksearch_fulltext','on',5),
('quicksearch_fulltext','off',10),
('quote_replies','quoted_reply',5),
('quote_replies','simple_reply',10),
('quote_replies','off',15),
('requestee_cc','on',5),
('requestee_cc','off',10),
('state_addselfcc','always',5),
('state_addselfcc','never',10),
('state_addselfcc','cc_unless_role',15),
('zoom_textareas','on',5),
('zoom_textareas','off',10);

/*Table structure for table `status_workflow` */

DROP TABLE IF EXISTS `status_workflow`;

CREATE TABLE `status_workflow` (
  `old_status` smallint(6) DEFAULT NULL,
  `new_status` smallint(6) NOT NULL,
  `require_comment` tinyint(4) NOT NULL DEFAULT 0,
  UNIQUE KEY `status_workflow_idx` (`old_status`,`new_status`),
  KEY `fk_status_workflow_new_status_bug_status_id` (`new_status`),
  CONSTRAINT `fk_status_workflow_new_status_bug_status_id` FOREIGN KEY (`new_status`) REFERENCES `bug_status` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_status_workflow_old_status_bug_status_id` FOREIGN KEY (`old_status`) REFERENCES `bug_status` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `status_workflow` */

insert  into `status_workflow`(`old_status`,`new_status`,`require_comment`) values 
(NULL,1,0),
(NULL,2,0),
(NULL,3,0),
(1,2,0),
(1,3,0),
(1,4,0),
(2,3,0),
(2,4,0),
(3,2,0),
(3,4,0),
(4,5,0),
(5,4,0),
(6,4,0),
(7,4,0),
(8,4,0),
(1,7,0),
(2,7,0),
(3,7,0),
(6,3,0),
(6,7,0),
(7,3,0),
(4,6,0),
(4,7,0),
(5,6,0),
(5,8,0),
(8,6,0),
(NULL,7,0);

/*Table structure for table `tag` */

DROP TABLE IF EXISTS `tag`;

CREATE TABLE `tag` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `user_id` mediumint(9) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tag_user_id_idx` (`user_id`,`name`),
  CONSTRAINT `fk_tag_user_id_profiles_userid` FOREIGN KEY (`user_id`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `tag` */

/*Table structure for table `tokens` */

DROP TABLE IF EXISTS `tokens`;

CREATE TABLE `tokens` (
  `userid` mediumint(9) DEFAULT NULL,
  `issuedate` datetime NOT NULL,
  `token` varchar(16) NOT NULL,
  `tokentype` varchar(16) NOT NULL,
  `eventdata` tinytext DEFAULT NULL,
  PRIMARY KEY (`token`),
  KEY `tokens_userid_idx` (`userid`),
  CONSTRAINT `fk_tokens_userid_profiles_userid` FOREIGN KEY (`userid`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `tokens` */

insert  into `tokens`(`userid`,`issuedate`,`token`,`tokentype`,`eventdata`) values 
(1,'2017-10-27 00:37:01','0yA1OaD2wY','session','edit_parameters'),
(1,'2017-10-26 22:38:11','2AdHa3bSxm','session','edit_parameters'),
(1,'2017-10-26 23:02:32','6DQp7jyZ9y','session','edit_field'),
(1,'2017-10-27 00:36:53','6U8yA8nvzc','session','edit_parameters'),
(1,'2017-10-27 00:37:16','7BPtjwNEWU','session','edit_parameters'),
(1,'2017-10-26 22:40:43','7qTMEFrl06','session','edit_parameters'),
(1,'2017-10-26 04:39:24','8zO7PwJRay','session','edit_parameters'),
(1,'2017-10-26 04:34:47','AfRcqr5eDN','session','edit_settings'),
(1,'2017-10-27 00:39:10','BCq3QpZ3Wf','session','edit_parameters'),
(1,'2017-10-27 00:39:40','Br2kK7jQl8','session','edit_parameters'),
(1,'2017-10-26 04:40:28','BU71QWLaA1','session','edit_parameters'),
(1,'2017-10-26 22:40:09','Bv8Nhid9ev','session','edit_parameters'),
(1,'2017-10-26 22:38:31','cSjmpfvHj7','session','edit_parameters'),
(1,'2017-10-26 04:35:05','CWVCubGVUZ','session','edit_parameters'),
(1,'2017-10-26 22:53:01','DFHWciCjAo','session','edit_field'),
(1,'2017-10-27 00:37:18','DUHQx2Z5Gw','session','edit_parameters'),
(1,'2017-10-26 22:41:12','EBxfcCQp4W','session','edit_field'),
(1,'2017-10-26 12:04:12','eh9aegKmDa','session','add_field'),
(1,'2017-10-27 00:39:57','EJdlhyV405','session','edit_parameters'),
(1,'2017-10-26 22:39:31','gECBQ9FDuR','session','edit_parameters'),
(1,'2017-10-26 04:34:12','GERwYPUmEY','session','edit_parameters'),
(1,'2017-10-26 22:39:01','gKUpK6cuta','session','edit_parameters'),
(1,'2017-10-26 22:40:30','GXnDebNgvd','session','edit_parameters'),
(1,'2017-10-27 00:38:36','Gy4N07vSUe','session','edit_field_value'),
(1,'2017-10-26 21:01:57','H3aWeMKTe5','session','edit_field'),
(1,'2017-10-26 22:43:10','HSVkdGBabU','session','edit_field'),
(1,'2017-10-26 04:39:24','IsClRggUvO','session','edit_parameters'),
(1,'2017-10-26 07:48:54','kEjuUr69G0','session','edit_field'),
(1,'2017-10-27 00:39:07','LCCT9yTkcQ','session','edit_parameters'),
(1,'2017-10-26 11:56:55','lgappyL1k5','session','add_field'),
(1,'2017-10-26 12:02:08','NxOFCJ0FX3','session','add_field'),
(1,'2017-10-26 04:41:06','oDd91uEibO','session','edit_parameters'),
(1,'2017-10-26 22:41:11','oSEksE1bFz','session','edit_field'),
(1,'2017-10-26 22:38:01','PUkSrAvamm','session','edit_parameters'),
(1,'2017-10-26 22:55:23','PUtJzD1RVz','session','edit_field'),
(1,'2017-10-26 04:39:57','pXZaZgZGkY','session','edit_parameters'),
(1,'2017-10-26 07:42:12','QhN0260tnr','session','edit_field'),
(1,'2017-10-26 04:33:46','qJP8EyHgrp','session','edit_parameters'),
(1,'2017-10-26 22:39:43','RIqwcRZgxj','session','edit_parameters'),
(1,'2017-10-26 23:00:54','S1cmDey2lg','session','edit_field'),
(1,'2017-10-26 04:40:53','S5a9oJvaKA','session','edit_parameters'),
(1,'2017-10-26 21:02:11','szYY0DaAsc','session','edit_field'),
(1,'2017-10-27 00:36:46','t2nSlMG8zd','session','edit_parameters'),
(1,'2017-10-26 04:40:31','tJA0wxH2Hs','session','edit_parameters'),
(1,'2017-10-26 04:39:43','vnfeMQwWOv','session','edit_parameters'),
(1,'2017-10-26 12:06:00','VsKwByebdg','session','add_field'),
(1,'2017-10-26 04:35:22','w0G5gKBkNE','session','edit_parameters'),
(1,'2017-10-26 22:37:55','wbya9TxiNT','session','edit_parameters'),
(1,'2017-10-26 22:58:51','WD0JyzSrAm','session','edit_field'),
(1,'2017-10-26 22:38:42','WrsYb9HeXP','session','edit_parameters'),
(1,'2017-10-26 20:58:29','xZIfbRBCHS','session','add_field'),
(1,'2017-10-27 00:37:40','yeoBaYKhmn','session','edit_parameters'),
(1,'2017-10-27 00:40:04','Zb6MGsCLy5','session','edit_parameters'),
(1,'2017-10-26 22:57:39','zdHvXiklpp','session','edit_field');

/*Table structure for table `ts_error` */

DROP TABLE IF EXISTS `ts_error`;

CREATE TABLE `ts_error` (
  `error_time` int(11) NOT NULL,
  `jobid` int(11) NOT NULL,
  `message` varchar(255) NOT NULL,
  `funcid` int(11) NOT NULL DEFAULT 0,
  KEY `ts_error_funcid_idx` (`funcid`,`error_time`),
  KEY `ts_error_error_time_idx` (`error_time`),
  KEY `ts_error_jobid_idx` (`jobid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `ts_error` */

/*Table structure for table `ts_exitstatus` */

DROP TABLE IF EXISTS `ts_exitstatus`;

CREATE TABLE `ts_exitstatus` (
  `jobid` int(11) NOT NULL AUTO_INCREMENT,
  `funcid` int(11) NOT NULL DEFAULT 0,
  `status` smallint(6) DEFAULT NULL,
  `completion_time` int(11) DEFAULT NULL,
  `delete_after` int(11) DEFAULT NULL,
  PRIMARY KEY (`jobid`),
  KEY `ts_exitstatus_funcid_idx` (`funcid`),
  KEY `ts_exitstatus_delete_after_idx` (`delete_after`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `ts_exitstatus` */

/*Table structure for table `ts_funcmap` */

DROP TABLE IF EXISTS `ts_funcmap`;

CREATE TABLE `ts_funcmap` (
  `funcid` int(11) NOT NULL AUTO_INCREMENT,
  `funcname` varchar(255) NOT NULL,
  PRIMARY KEY (`funcid`),
  UNIQUE KEY `ts_funcmap_funcname_idx` (`funcname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `ts_funcmap` */

/*Table structure for table `ts_job` */

DROP TABLE IF EXISTS `ts_job`;

CREATE TABLE `ts_job` (
  `jobid` int(11) NOT NULL AUTO_INCREMENT,
  `funcid` int(11) NOT NULL,
  `arg` longblob DEFAULT NULL,
  `uniqkey` varchar(255) DEFAULT NULL,
  `insert_time` int(11) DEFAULT NULL,
  `run_after` int(11) NOT NULL,
  `grabbed_until` int(11) NOT NULL,
  `priority` smallint(6) DEFAULT NULL,
  `coalesce` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`jobid`),
  UNIQUE KEY `ts_job_funcid_idx` (`funcid`,`uniqkey`),
  KEY `ts_job_run_after_idx` (`run_after`,`funcid`),
  KEY `ts_job_coalesce_idx` (`coalesce`,`funcid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `ts_job` */

/*Table structure for table `ts_note` */

DROP TABLE IF EXISTS `ts_note`;

CREATE TABLE `ts_note` (
  `jobid` int(11) NOT NULL,
  `notekey` varchar(255) DEFAULT NULL,
  `value` longblob DEFAULT NULL,
  UNIQUE KEY `ts_note_jobid_idx` (`jobid`,`notekey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `ts_note` */

/*Table structure for table `user_api_keys` */

DROP TABLE IF EXISTS `user_api_keys`;

CREATE TABLE `user_api_keys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` mediumint(9) NOT NULL,
  `api_key` varchar(40) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `revoked` tinyint(4) NOT NULL DEFAULT 0,
  `last_used` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_api_keys_api_key_idx` (`api_key`),
  KEY `user_api_keys_user_id_idx` (`user_id`),
  CONSTRAINT `fk_user_api_keys_user_id_profiles_userid` FOREIGN KEY (`user_id`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `user_api_keys` */

/*Table structure for table `user_group_map` */

DROP TABLE IF EXISTS `user_group_map`;

CREATE TABLE `user_group_map` (
  `user_id` mediumint(9) NOT NULL,
  `group_id` mediumint(9) NOT NULL,
  `isbless` tinyint(4) NOT NULL DEFAULT 0,
  `grant_type` tinyint(4) NOT NULL DEFAULT 0,
  UNIQUE KEY `user_group_map_user_id_idx` (`user_id`,`group_id`,`grant_type`,`isbless`),
  KEY `fk_user_group_map_group_id_groups_id` (`group_id`),
  CONSTRAINT `fk_user_group_map_group_id_groups_id` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_user_group_map_user_id_profiles_userid` FOREIGN KEY (`user_id`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `user_group_map` */

insert  into `user_group_map`(`user_id`,`group_id`,`isbless`,`grant_type`) values 
(1,1,0,0);

/*Table structure for table `ut_contractor_types` */

DROP TABLE IF EXISTS `ut_contractor_types`;

CREATE TABLE `ut_contractor_types` (
  `id_contractor_type` smallint(6) NOT NULL AUTO_INCREMENT COMMENT 'ID in this table',
  `created` datetime DEFAULT NULL COMMENT 'creation ts',
  `contractor_type` varchar(255) NOT NULL COMMENT 'A name for this contractor type',
  `bz_description` varchar(255) DEFAULT NULL COMMENT 'A short, generic description that we include each time we create a new BZ unit.',
  `description` text DEFAULT NULL COMMENT 'Detailed description of this contractor type',
  PRIMARY KEY (`id_contractor_type`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

/*Data for the table `ut_contractor_types` */

insert  into `ut_contractor_types`(`id_contractor_type`,`created`,`contractor_type`,`bz_description`,`description`) values 
(1,'2017-10-26 22:35:58','---','Not Applicable','This is not a contractor.'),
(2,'2017-10-26 22:35:58','Unknown','Unknown','We have no information about the contractor type.'),
(3,'2017-10-26 22:35:58','Other','Other','A type of contractor which is not in the list.'),
(4,'2017-10-26 22:35:58','Electricty','Electrician','Can do electrical work.'),
(5,'2017-10-26 22:35:58','Plumbing','Plumber','Can do plumbin.'),
(6,'2017-10-26 22:35:58','General','General Repair','General Contractor.'),
(7,'2017-10-26 22:35:58','Aircon','Aircon','Aircon repair and maintenance.');

/*Table structure for table `ut_contractors` */

DROP TABLE IF EXISTS `ut_contractors`;

CREATE TABLE `ut_contractors` (
  `id_contractor` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID in this table',
  `created` datetime DEFAULT NULL COMMENT 'creation ts',
  `contractor_name` varchar(255) NOT NULL COMMENT 'A name for this contractor',
  `contractor_description` varchar(255) DEFAULT NULL COMMENT 'A short, generic description that we include each time we create a new BZ contractor.',
  `contractor_details` text DEFAULT NULL COMMENT 'Detailed description of this contractor - This can be built from a SQL Less table and/or the MEFE',
  PRIMARY KEY (`id_contractor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `ut_contractors` */

/*Table structure for table `ut_group_types` */

DROP TABLE IF EXISTS `ut_group_types`;

CREATE TABLE `ut_group_types` (
  `id_group_type` smallint(6) NOT NULL AUTO_INCREMENT COMMENT 'ID in this table',
  `created` datetime DEFAULT NULL COMMENT 'creation ts',
  `order` smallint(6) DEFAULT NULL COMMENT 'Order in the list',
  `is_obsolete` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'This is an obsolete record',
  `groupe_type` varchar(255) NOT NULL COMMENT 'A name for this group type',
  `bz_description` varchar(255) DEFAULT NULL COMMENT 'A short description for BZ which we use when we create the group',
  `description` text DEFAULT NULL COMMENT 'Detailed description of this group type',
  PRIMARY KEY (`id_group_type`,`groupe_type`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;

/*Data for the table `ut_group_types` */

insert  into `ut_group_types`(`id_group_type`,`created`,`order`,`is_obsolete`,`groupe_type`,`bz_description`,`description`) values 
(1,'2017-10-26 22:35:58',10,0,'creator','User has created the unit or has full delegation','The group for the user who has created the unit first and/or his representatives (agent or employee).'),
(2,'2017-10-26 22:35:58',40,0,'hide_case_from_role','Untick to hide this case from these users','These are product/unit and bug/case visibility groups. \r\nThese groups are in the table bug_group_map.'),
(3,'2017-10-26 22:35:58',50,0,'list_occupants','User is an occupant of the unit','These are also bug visibility groups but based on a different information: is the user an occupant of the unit or not?\r\nA Tenant can also be an occupant (or not)\r\nAn Owner/Landlord can also be an occupant (or not).'),
(4,'2017-10-26 22:35:58',70,0,'list_visible_stakeholder','List all the users who have a role in this unit','This is a user visibility group (step 1).\r\nAll the users in this group have a role in this unit.'),
(5,'2017-10-26 22:35:58',80,0,'see_visible_stakeholder','See all the stakeholders','This is a user visibility group (step 2).\r\nIf you are member of this group, you can see all the user in the list_stakeholder group for this unit.'),
(6,'2017-10-26 22:35:58',500,0,'r_a_case_next_step','Requestee to approve the Next Step of a case','This is a group for the list of Requestee. It is specific to each unit so we do not ask user to grant approval on a case they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to request approval for the Next Step for a case in this unit.'),
(7,'2017-10-26 22:35:58',600,0,'g_a_case_next_step','Grant approval for the Next Step of a case','This is a group for the list of Grantor. It is specific to each unit so we do not ask user to grant approval on a case they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to grant approval for the Next Step for a case in this unit.'),
(8,'2017-10-26 22:35:58',510,0,'r_a_case_solution','Requestee to approve the Solution of a case','This is a group for the list of Requestee. It is specific to each unit so we do not ask user to grant approval on a case they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to request approval for the Solution for a case in this unit.'),
(9,'2017-10-26 22:35:58',610,0,'g_a_case_solution','Grant approval for the Solution of a case','This is a group for the list of Grantor. It is specific to each unit so we do not ask user to grant approval on a case they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to grant approval for the Solution for a case in this unit.'),
(10,'2017-10-26 22:35:58',520,0,'r_a_case_budget','Requestee to approve the Budget for a case','This is a group for the list of Requestee. It is specific to each unit so we do not ask user to grant approval on a case they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to request approval for the Budget for a case in this unit.'),
(11,'2017-10-26 22:35:58',620,0,'g_a_case_budget','Grant approval for the Budget for a case','This is a group for the list of Grantor. It is specific to each unit so we do not ask user to grant approval on a case they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to grant approval for the Budget for a case in this unit.'),
(12,'2017-10-26 22:35:58',700,0,'r_a_attachment_approve','Requestee to approve the Attachment','This is a group for the list of Requestee. It is specific to each unit so we do not ask user to grant approval on an Attachment they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to request approval for an Attachment in this unit.'),
(13,'2017-10-26 22:35:58',800,0,'g_a_attachment_approve','Grant approval for the Attachment','This is a group for the list of Grantor. It is specific to each unit so we do not ask user to grant approval on an Attachment they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to grant approval for an Attachment in this unit.'),
(14,'2017-10-26 22:35:58',710,0,'r_a_attachment_ok_to_pay','Requestee to approve pay a bill','This is a group for the list of Requestee. It is specific to each unit so we do not ask user to grant approval on an Attachment they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to request approval to pay a specific bill in this unit.'),
(15,'2017-10-26 22:35:58',810,0,'g_a_attachment_ok_to_pay','Grant approval to pay a bill','This is a group for the list of Grantor. It is specific to each unit so we do not ask user to grant approval on an Attachment they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to grant approval to pay a specific bill in this unit.'),
(16,'2017-10-26 22:35:58',720,0,'r_a_attachment_is_paid','Requestee to confirm if a bill has been paid','This is a group for the list of Requestee. It is specific to each unit so we do not ask user to grant approval on an Attachment they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to confirm if a specific bill has been paid in this unit.'),
(17,'2017-10-26 22:35:58',820,0,'g_a_attachment_is_paid','Confirms if a bill has been paid','This is a group for the list of Grantor. It is specific to each unit so we do not ask user to grant approval on an Attachment they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit confirm if a specific bill has been paid in this unit.'),
(18,'2017-10-26 22:35:58',999,0,'all_r_flags','Grant approval for all flags','This is a group for the list of Requestee. It is specific to each unit so we do not ask user to grant approval on an Attachment they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit confirm if a specific bill has been paid in this unit.'),
(19,'2017-10-26 22:35:58',999,0,'all_g_all_flags','Confirms if a bill has been paid','This is a group for the list of Grantor. It is specific to each unit so we do not ask user to grant approval on an Attachment they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit confirm if a specific bill has been paid in this unit.'),
(20,'2017-10-26 22:35:58',20,0,'access_a_unit','Group to be able to create cases in a unit','This is a group that helps us grant all shared accessed and permission in bulk to a user.\r\nIf you are member of this group, you can access, grant, request and be requested to approve all the Flags for a specific unit.'),
(21,'2017-10-26 22:35:58',10000,0,'user_aggregation','Facilitate user management','This is to group user together (users working in the same company for example) so we can give them all the same permissions.'),
(22,'2017-10-29 15:53:04',30,0,'list_users_in_role','List all user in a role','All the users in the same role/component for a given unit'),
(24,'2017-10-29 16:23:29',60,0,'hide_case_from_occupant','Untick to hide a case from the occupants of the unit',NULL);

/*Table structure for table `ut_map_contractor_to_type` */

DROP TABLE IF EXISTS `ut_map_contractor_to_type`;

CREATE TABLE `ut_map_contractor_to_type` (
  `contractor_id` int(11) NOT NULL COMMENT 'id in the table `ut_contractors`',
  `contractor_type_id` mediumint(9) NOT NULL COMMENT 'id in the table `ut_contractor_types`',
  `created` datetime DEFAULT NULL COMMENT 'creation ts'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `ut_map_contractor_to_type` */

/*Table structure for table `ut_map_contractor_to_user` */

DROP TABLE IF EXISTS `ut_map_contractor_to_user`;

CREATE TABLE `ut_map_contractor_to_user` (
  `contractor_id` int(11) NOT NULL COMMENT 'id in the table `ut_contractors`',
  `bz_user_id` mediumint(9) NOT NULL COMMENT 'id in the table `profiles`',
  `created` datetime DEFAULT NULL COMMENT 'creation ts'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `ut_map_contractor_to_user` */

/*Table structure for table `ut_map_user_unit_details` */

DROP TABLE IF EXISTS `ut_map_user_unit_details`;

CREATE TABLE `ut_map_user_unit_details` (
  `id_user_unit` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID in this table',
  `created` datetime DEFAULT NULL COMMENT 'creation ts',
  `record_created_by` smallint(6) DEFAULT NULL COMMENT 'id of the user who created this user in the bz `profiles` table',
  `is_obsolete` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'This is an obsolete record',
  `user_id` int(11) DEFAULT NULL COMMENT 'id of the user in the MEFE',
  `bz_profile_id` mediumint(6) DEFAULT NULL COMMENT 'id of the user in the BZFE',
  `bz_unit_id` smallint(6) DEFAULT NULL COMMENT 'The id of the unit in the BZFE',
  `role_type_id` smallint(6) DEFAULT NULL COMMENT 'An id in the table ut_role_types: the role of the user for this unit',
  `is_occupant` tinyint(1) NOT NULL DEFAULT 0 COMMENT '1 (TRUE) if the user is an occupnt for this unit',
  `is_public_assignee` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 (TRUE) if the user is one of the public assignee for this unit',
  `is_see_visible_assignee` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 (TRUE) if the user can see the public assignee for this unit',
  `is_flag_requestee` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 (TRUE) if the user can be asked to approve all flags',
  `is_flag_approver` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 (TRUE) if the user can approve all flags',
  `can_create_any_sh` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 (TRUE) if the user can create any type of stakeholder',
  `can_create_same_sh` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 (TRUE) if the user can add user as similar stakeholder for that unit',
  `can_approve_user_for_flags` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 (TRUE) if the user can decide if a user can be requested to approve all flags',
  `can_decide_if_user_visible` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 (TRUE) if the user can decide if another user is visible',
  `can_decide_if_user_can_see_visible` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 (TRUE) if the user can decide if another user can see the visible users',
  `public_name` varchar(255) DEFAULT NULL COMMENT 'The user Public name',
  `more_info` text DEFAULT NULL COMMENT 'More information about this user. We display this in the component/stakeholder description for the unit',
  `comment` text DEFAULT NULL COMMENT 'Any comment',
  PRIMARY KEY (`id_user_unit`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `ut_map_user_unit_details` */

/*Table structure for table `ut_product_group` */

DROP TABLE IF EXISTS `ut_product_group`;

CREATE TABLE `ut_product_group` (
  `product_id` smallint(6) NOT NULL COMMENT 'id in the table products - to identify all the groups for a product',
  `group_id` mediumint(9) NOT NULL COMMENT 'id in the table groups - to map the group to the list in the table `groups`',
  `group_type_id` smallint(6) NOT NULL COMMENT 'id in the table ut_group_types - to avoid re-creating the same group for the same product again',
  `role_type_id` smallint(6) DEFAULT NULL COMMENT 'id in the table ut_role_types - to make sure all similar stakeholder in a unit are made a member of the same group',
  `created` datetime DEFAULT NULL COMMENT 'creation ts'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `ut_product_group` */

/*Table structure for table `ut_role_types` */

DROP TABLE IF EXISTS `ut_role_types`;

CREATE TABLE `ut_role_types` (
  `id_role_type` smallint(6) NOT NULL AUTO_INCREMENT COMMENT 'ID in this table',
  `created` datetime DEFAULT NULL COMMENT 'creation ts',
  `role_type` varchar(255) NOT NULL COMMENT 'A name for this role type',
  `bz_description` varchar(255) DEFAULT NULL COMMENT 'A short, generic description that we include each time we create a new BZ unit.',
  `description` text DEFAULT NULL COMMENT 'Detailed description of this group type',
  PRIMARY KEY (`id_role_type`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

/*Data for the table `ut_role_types` */

insert  into `ut_role_types`(`id_role_type`,`created`,`role_type`,`bz_description`,`description`) values 
(1,'2017-10-26 22:35:58','Tenant','The Tenant','The person or entity who signed the tenancy agreement.'),
(2,'2017-10-26 22:35:58','Owner/Landlord','The Landlord','The person(s) or entity that are the registered owner of the property.'),
(3,'2017-10-26 22:35:58','Contractor','A contractor','A company or a person that can or will do work in the unit (electricity, plumbing, Aircon Maintenance, Housekeeping, etc...).'),
(4,'2017-10-26 22:35:58','Management Company','The management Company','Is in charge of day to day operations and responsible to fix things if something happens in a unit.'),
(5,'2017-10-26 22:35:58','Agent','An agent','The user who act as either the representative for the Tenant or for the Landlord. It is possible to have 2 agents attached to the same unit.');

/*Table structure for table `versions` */

DROP TABLE IF EXISTS `versions`;

CREATE TABLE `versions` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `value` varchar(64) NOT NULL,
  `product_id` smallint(6) NOT NULL,
  `isactive` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `versions_product_id_idx` (`product_id`,`value`),
  CONSTRAINT `fk_versions_product_id_products_id` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Data for the table `versions` */

insert  into `versions`(`id`,`value`,`product_id`,`isactive`) values 
(1,'---',1,1);

/*Table structure for table `watch` */

DROP TABLE IF EXISTS `watch`;

CREATE TABLE `watch` (
  `watcher` mediumint(9) NOT NULL,
  `watched` mediumint(9) NOT NULL,
  UNIQUE KEY `watch_watcher_idx` (`watcher`,`watched`),
  KEY `watch_watched_idx` (`watched`),
  CONSTRAINT `fk_watch_watched_profiles_userid` FOREIGN KEY (`watched`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_watch_watcher_profiles_userid` FOREIGN KEY (`watcher`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `watch` */

/*Table structure for table `whine_events` */

DROP TABLE IF EXISTS `whine_events`;

CREATE TABLE `whine_events` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `owner_userid` mediumint(9) NOT NULL,
  `subject` varchar(128) DEFAULT NULL,
  `body` mediumtext DEFAULT NULL,
  `mailifnobugs` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `fk_whine_events_owner_userid_profiles_userid` (`owner_userid`),
  CONSTRAINT `fk_whine_events_owner_userid_profiles_userid` FOREIGN KEY (`owner_userid`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `whine_events` */

/*Table structure for table `whine_queries` */

DROP TABLE IF EXISTS `whine_queries`;

CREATE TABLE `whine_queries` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `eventid` mediumint(9) NOT NULL,
  `query_name` varchar(64) NOT NULL DEFAULT '',
  `sortkey` smallint(6) NOT NULL DEFAULT 0,
  `onemailperbug` tinyint(4) NOT NULL DEFAULT 0,
  `title` varchar(128) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `whine_queries_eventid_idx` (`eventid`),
  CONSTRAINT `fk_whine_queries_eventid_whine_events_id` FOREIGN KEY (`eventid`) REFERENCES `whine_events` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `whine_queries` */

/*Table structure for table `whine_schedules` */

DROP TABLE IF EXISTS `whine_schedules`;

CREATE TABLE `whine_schedules` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `eventid` mediumint(9) NOT NULL,
  `run_day` varchar(32) DEFAULT NULL,
  `run_time` varchar(32) DEFAULT NULL,
  `run_next` datetime DEFAULT NULL,
  `mailto` mediumint(9) NOT NULL,
  `mailto_type` smallint(6) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `whine_schedules_run_next_idx` (`run_next`),
  KEY `whine_schedules_eventid_idx` (`eventid`),
  CONSTRAINT `fk_whine_schedules_eventid_whine_events_id` FOREIGN KEY (`eventid`) REFERENCES `whine_events` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `whine_schedules` */

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
