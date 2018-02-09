/*
SQLyog Ultimate v12.5.1 (64 bit)
MySQL - 10.2.10-MariaDB-10.2.10+maria~jessie : Database - bugzilla
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
/*Table structure for table `attach_data` */

DROP TABLE IF EXISTS `attach_data`;

CREATE TABLE `attach_data` (
  `id` mediumint(9) NOT NULL,
  `thedata` longblob NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_attach_data_id_attachments_attach_id` FOREIGN KEY (`id`) REFERENCES `attachments` (`attach_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 MAX_ROWS=100000 AVG_ROW_LENGTH=1000000;

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

/*Table structure for table `bugs_aliases` */

DROP TABLE IF EXISTS `bugs_aliases`;

CREATE TABLE `bugs_aliases` (
  `alias` varchar(40) NOT NULL,
  `bug_id` mediumint(9) DEFAULT NULL,
  UNIQUE KEY `bugs_aliases_alias_idx` (`alias`),
  KEY `bugs_aliases_bug_id_idx` (`bug_id`),
  CONSTRAINT `fk_bugs_aliases_bug_id_bugs_bug_id` FOREIGN KEY (`bug_id`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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

/*Table structure for table `bz_schema` */

DROP TABLE IF EXISTS `bz_schema`;

CREATE TABLE `bz_schema` (
  `schema_data` longblob NOT NULL,
  `version` decimal(3,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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

/*Table structure for table `cf_claim_type` */

DROP TABLE IF EXISTS `cf_claim_type`;

CREATE TABLE `cf_claim_type` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `value` varchar(64) NOT NULL,
  `sortkey` smallint(6) NOT NULL DEFAULT 0,
  `isactive` tinyint(4) NOT NULL DEFAULT 1,
  `visibility_value_id` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cf_claim_type_value_idx` (`value`),
  KEY `cf_claim_type_sortkey_idx` (`sortkey`,`value`),
  KEY `cf_claim_type_visibility_value_id_idx` (`visibility_value_id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;

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

/*Table structure for table `cf_ipi_clust_5_budget_approver` */

DROP TABLE IF EXISTS `cf_ipi_clust_5_budget_approver`;

CREATE TABLE `cf_ipi_clust_5_budget_approver` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `value` varchar(64) NOT NULL,
  `sortkey` smallint(6) NOT NULL DEFAULT 0,
  `isactive` tinyint(4) NOT NULL DEFAULT 1,
  `visibility_value_id` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cf_ipi_budget_approver_value_idx` (`value`),
  KEY `cf_ipi_budget_approver_sortkey_idx` (`sortkey`,`value`),
  KEY `cf_ipi_budget_approver_visibility_value_id_idx` (`visibility_value_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

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

/*Table structure for table `cf_ipi_clust_7_payment_type` */

DROP TABLE IF EXISTS `cf_ipi_clust_7_payment_type`;

CREATE TABLE `cf_ipi_clust_7_payment_type` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `value` varchar(64) NOT NULL,
  `sortkey` smallint(6) NOT NULL DEFAULT 0,
  `isactive` tinyint(4) NOT NULL DEFAULT 1,
  `visibility_value_id` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cf_ipi_payment_type_value_idx` (`value`),
  KEY `cf_ipi_payment_type_visibility_value_id_idx` (`visibility_value_id`),
  KEY `cf_ipi_payment_type_sortkey_idx` (`sortkey`,`value`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

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

/*Table structure for table `email_setting` */

DROP TABLE IF EXISTS `email_setting`;

CREATE TABLE `email_setting` (
  `user_id` mediumint(9) NOT NULL,
  `relationship` tinyint(4) NOT NULL,
  `event` tinyint(4) NOT NULL,
  UNIQUE KEY `email_setting_user_id_idx` (`user_id`,`relationship`,`event`),
  CONSTRAINT `fk_email_setting_user_id_profiles_userid` FOREIGN KEY (`user_id`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `field_visibility` */

DROP TABLE IF EXISTS `field_visibility`;

CREATE TABLE `field_visibility` (
  `field_id` mediumint(9) DEFAULT NULL,
  `value_id` smallint(6) NOT NULL,
  UNIQUE KEY `field_visibility_field_id_idx` (`field_id`,`value_id`),
  CONSTRAINT `fk_field_visibility_field_id_fielddefs_id` FOREIGN KEY (`field_id`) REFERENCES `fielddefs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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

/*Table structure for table `group_group_map` */

DROP TABLE IF EXISTS `group_group_map`;

CREATE TABLE `group_group_map` (
  `member_id` mediumint(9) NOT NULL,
  `grantor_id` mediumint(9) NOT NULL,
  `grant_type` tinyint(4) NOT NULL DEFAULT 0,
  UNIQUE KEY `group_group_map_member_id_idx` (`member_id`,`grantor_id`,`grant_type`),
  KEY `fk_group_group_map_grantor_id_groups_id` (`grantor_id`),
  KEY `group_group_map_grant_type_member_id` (`member_id`,`grant_type`),
  CONSTRAINT `fk_group_group_map_grantor_id_groups_id` FOREIGN KEY (`grantor_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_group_group_map_member_id_groups_id` FOREIGN KEY (`member_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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

/*Table structure for table `keyworddefs` */

DROP TABLE IF EXISTS `keyworddefs`;

CREATE TABLE `keyworddefs` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `description` mediumtext NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `keyworddefs_name_idx` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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

/*Table structure for table `login_failure` */

DROP TABLE IF EXISTS `login_failure`;

CREATE TABLE `login_failure` (
  `user_id` mediumint(9) NOT NULL,
  `login_time` datetime NOT NULL,
  `ip_addr` varchar(40) NOT NULL,
  KEY `login_failure_user_id_idx` (`user_id`),
  CONSTRAINT `fk_login_failure_user_id_profiles_userid` FOREIGN KEY (`user_id`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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

/*Table structure for table `longdescs_tags_weights` */

DROP TABLE IF EXISTS `longdescs_tags_weights`;

CREATE TABLE `longdescs_tags_weights` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `tag` varchar(24) NOT NULL,
  `weight` mediumint(9) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `longdescs_tags_weights_tag_idx` (`tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `mail_staging` */

DROP TABLE IF EXISTS `mail_staging`;

CREATE TABLE `mail_staging` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message` longblob NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

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

/*Table structure for table `series_categories` */

DROP TABLE IF EXISTS `series_categories`;

CREATE TABLE `series_categories` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `series_categories_name_idx` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

/*Table structure for table `series_data` */

DROP TABLE IF EXISTS `series_data`;

CREATE TABLE `series_data` (
  `series_id` mediumint(9) NOT NULL,
  `series_date` datetime NOT NULL,
  `series_value` mediumint(9) NOT NULL,
  UNIQUE KEY `series_data_series_id_idx` (`series_id`,`series_date`),
  CONSTRAINT `fk_series_data_series_id_series_series_id` FOREIGN KEY (`series_id`) REFERENCES `series` (`series_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `setting` */

DROP TABLE IF EXISTS `setting`;

CREATE TABLE `setting` (
  `name` varchar(32) NOT NULL,
  `default_value` varchar(32) NOT NULL,
  `is_enabled` tinyint(4) NOT NULL DEFAULT 1,
  `subclass` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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

/*Table structure for table `ts_funcmap` */

DROP TABLE IF EXISTS `ts_funcmap`;

CREATE TABLE `ts_funcmap` (
  `funcid` int(11) NOT NULL AUTO_INCREMENT,
  `funcname` varchar(255) NOT NULL,
  PRIMARY KEY (`funcid`),
  UNIQUE KEY `ts_funcmap_funcname_idx` (`funcname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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

/*Table structure for table `ts_note` */

DROP TABLE IF EXISTS `ts_note`;

CREATE TABLE `ts_note` (
  `jobid` int(11) NOT NULL,
  `notekey` varchar(255) DEFAULT NULL,
  `value` longblob DEFAULT NULL,
  UNIQUE KEY `ts_note_jobid_idx` (`jobid`,`notekey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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

/*Table structure for table `ut_audit_log` */

DROP TABLE IF EXISTS `ut_audit_log`;

CREATE TABLE `ut_audit_log` (
  `id_ut_log` int(11) NOT NULL AUTO_INCREMENT COMMENT 'The id of the record in this table',
  `datetime` datetime DEFAULT NULL COMMENT 'When was this record created',
  `bzfe_table` varchar(256) DEFAULT NULL COMMENT 'The name of the table that was altered',
  `bzfe_field` varchar(256) DEFAULT NULL COMMENT 'The name of the field that was altered in the bzfe table',
  `previous_value` mediumtext DEFAULT NULL COMMENT 'The value of the field before the change',
  `new_value` mediumtext DEFAULT NULL COMMENT 'The value of the field after the change',
  `script` mediumtext DEFAULT NULL COMMENT 'The script that was used to create the record',
  `comment` text DEFAULT NULL COMMENT 'More information about what we intended to do',
  PRIMARY KEY (`id_ut_log`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `ut_bug_status` */

DROP TABLE IF EXISTS `ut_bug_status`;

CREATE TABLE `ut_bug_status` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `value` varchar(64) NOT NULL,
  `sortkey` smallint(6) NOT NULL DEFAULT 0,
  `isactive` tinyint(4) NOT NULL DEFAULT 1,
  `visibility_value_id` smallint(6) DEFAULT NULL,
  `is_open` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ut_bug_status_value_idx` (`value`),
  KEY `ut_bug_status_sortkey_idx` (`sortkey`,`value`),
  KEY `ut_bug_status_visibility_value_id_idx` (`visibility_value_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

/*Table structure for table `ut_cf_ipi_clust_3_action_type` */

DROP TABLE IF EXISTS `ut_cf_ipi_clust_3_action_type`;

CREATE TABLE `ut_cf_ipi_clust_3_action_type` (
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

/*Table structure for table `ut_data_to_add_user_to_a_role` */

DROP TABLE IF EXISTS `ut_data_to_add_user_to_a_role`;

CREATE TABLE `ut_data_to_add_user_to_a_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'The unique ID in this table',
  `mefe_invitation_id` int(11) DEFAULT NULL COMMENT 'The unique Id for the invitation that was generated in MEFE to do the data import',
  `mefe_invitor_user_id` int(11) DEFAULT NULL COMMENT 'The id of the creator of this unit in the MEFE database',
  `bzfe_invitor_user_id` mediumint(9) NOT NULL COMMENT 'The BZFE user id who creates this unit. this is a FK to the BZ table ''profiles''',
  `bz_unit_id` smallint(6) NOT NULL COMMENT 'The product id in the BZ table ''products''',
  `bz_user_id` mediumint(9) NOT NULL COMMENT 'The userid for the user that will be rfeplcing the dummy user for this role for this unit. This is a FK to the BZ table ''profiles''',
  `user_role_type_id` smallint(6) NOT NULL COMMENT 'The id of the role type for the invited user. This is a FK to the table ''ut_role_types''',
  `is_occupant` tinyint(1) DEFAULT 0 COMMENT '1 if TRUE, 0 if FALSE',
  `user_more` varchar(500) DEFAULT '' COMMENT 'A text to give more information about the user. This will be used in the BZ Component Description',
  `bz_created_date` datetime DEFAULT NULL COMMENT 'Date and time when this unit has been created in the BZ databae',
  `comment` text DEFAULT NULL COMMENT 'Any comment',
  PRIMARY KEY (`id`),
  KEY `add_user_to_a_role_bz_user_id` (`bz_user_id`),
  KEY `add_user_to_a_role_invitor_bz_id` (`bzfe_invitor_user_id`),
  KEY `add_user_to_a_role_role_type_id` (`user_role_type_id`),
  KEY `add_user_to_a_role_product_id` (`bz_unit_id`),
  CONSTRAINT `add_user_to_a_role_bz_user_id` FOREIGN KEY (`bz_user_id`) REFERENCES `profiles` (`userid`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `add_user_to_a_role_invitor_bz_id` FOREIGN KEY (`bzfe_invitor_user_id`) REFERENCES `profiles` (`userid`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `add_user_to_a_role_product_id` FOREIGN KEY (`bz_unit_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `add_user_to_a_role_role_type_id` FOREIGN KEY (`user_role_type_id`) REFERENCES `ut_role_types` (`id_role_type`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `ut_data_to_create_units` */

DROP TABLE IF EXISTS `ut_data_to_create_units`;

CREATE TABLE `ut_data_to_create_units` (
  `id_unit_to_create` int(11) NOT NULL AUTO_INCREMENT COMMENT 'The unique ID in this table',
  `mefe_id` int(11) DEFAULT NULL COMMENT 'The id of the object in the MEFE interface where these information are coming from',
  `mefe_creator_user_id` int(11) DEFAULT NULL COMMENT 'The id of the creator of this unit in the MEFE database',
  `mefe_unit_id` int(11) DEFAULT NULL COMMENT 'The id of this unit in the MEFE database',
  `bzfe_creator_user_id` mediumint(9) NOT NULL COMMENT 'The BZFE user id who creates this unit. this is a FK to the BZ table ''profiles''',
  `classification_id` smallint(6) NOT NULL COMMENT 'The ID of the classification for this unit - a FK to the BZ table ''classifications''',
  `unit_name` varchar(54) NOT NULL DEFAULT '' COMMENT 'A name for the unit. We will append the product id and this will be inserted in the product name field of the BZ tabele product which has a max lenght of 64',
  `unit_id` varchar(54) DEFAULT '' COMMENT 'The id of the unit',
  `unit_condo` varchar(50) DEFAULT '' COMMENT 'The name of the condo or buildig for the unit',
  `unit_surface` varchar(10) DEFAULT '' COMMENT 'The surface of the unit - this is a number - it can be sqm or sqf',
  `unit_surface_measure` tinyint(1) DEFAULT NULL COMMENT '1 is for square feet (sqf) - 2 is for square meters (sqm)',
  `unit_description_details` varchar(500) DEFAULT '' COMMENT 'More information about the unit - this is a free text space',
  `unit_address` varchar(500) DEFAULT '' COMMENT 'The address of the unit',
  `matterport_url` varchar(256) DEFAULT '' COMMENT 'LMB specific - a the URL for the matterport visit for this unit',
  `bz_created_date` datetime DEFAULT NULL COMMENT 'Date and time when this unit has been created in the BZ databae',
  `comment` text DEFAULT NULL COMMENT 'Any comment',
  PRIMARY KEY (`id_unit_to_create`),
  KEY `id_unit_creator_id` (`bzfe_creator_user_id`),
  KEY `id_unit_classification_id` (`classification_id`),
  CONSTRAINT `id_unit_classification_id` FOREIGN KEY (`classification_id`) REFERENCES `classifications` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `id_unit_creator_id` FOREIGN KEY (`bzfe_creator_user_id`) REFERENCES `profiles` (`userid`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `ut_data_to_replace_dummy_roles` */

DROP TABLE IF EXISTS `ut_data_to_replace_dummy_roles`;

CREATE TABLE `ut_data_to_replace_dummy_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'The unique ID in this table',
  `mefe_invitation_id` int(11) DEFAULT NULL COMMENT 'The unique Id for the invitation that was generated in MEFE to do the data import',
  `mefe_invitor_user_id` int(11) DEFAULT NULL COMMENT 'The id of the creator of this unit in the MEFE database',
  `bzfe_invitor_user_id` mediumint(9) NOT NULL COMMENT 'The BZFE user id who creates this unit. this is a FK to the BZ table ''profiles''',
  `bz_unit_id` smallint(6) NOT NULL COMMENT 'The product id in the BZ table ''products''',
  `bz_user_id` mediumint(9) NOT NULL COMMENT 'The userid for the user that will be rfeplcing the dummy user for this role for this unit. This is a FK to the BZ table ''profiles''',
  `user_role_type_id` smallint(6) NOT NULL COMMENT 'The id of the role type for the invited user. This is a FK to the table ''ut_role_types''',
  `is_occupant` tinyint(1) DEFAULT 0 COMMENT '1 if TRUE, 0 if FALSE',
  `user_more` varchar(500) DEFAULT '' COMMENT 'A text to give more information about the user. This will be used in the BZ Component Description',
  `bz_created_date` datetime DEFAULT NULL COMMENT 'Date and time when this unit has been created in the BZ databae',
  `comment` text DEFAULT NULL COMMENT 'Any comment',
  PRIMARY KEY (`id`),
  KEY `replace_dummy_role_role_type` (`user_role_type_id`),
  KEY `replace_dummy_role_bz_user_id` (`bz_user_id`),
  KEY `replace_dummy_role_invitor_bz_user_id` (`bzfe_invitor_user_id`),
  KEY `replace_dummy_product_id` (`bz_unit_id`),
  CONSTRAINT `replace_dummy_product_id` FOREIGN KEY (`bz_unit_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `replace_dummy_role_bz_user_id` FOREIGN KEY (`bz_user_id`) REFERENCES `profiles` (`userid`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `replace_dummy_role_invitor_bz_user_id` FOREIGN KEY (`bzfe_invitor_user_id`) REFERENCES `profiles` (`userid`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `replace_dummy_role_role_type` FOREIGN KEY (`user_role_type_id`) REFERENCES `ut_role_types` (`id_role_type`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `ut_fielddefs` */

DROP TABLE IF EXISTS `ut_fielddefs`;

CREATE TABLE `ut_fielddefs` (
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
  UNIQUE KEY `ut_fielddefs_name_idx` (`name`),
  KEY `ut_fielddefs_sortkey_idx` (`sortkey`),
  KEY `ut_fielddefs_value_field_id_idx` (`value_field_id`),
  KEY `ut_fielddefs_is_mandatory_idx` (`is_mandatory`),
  KEY `fk_ut_fielddefs_visibility_field_id_fielddefs_id` (`visibility_field_id`),
  CONSTRAINT `fk_ut_fielddefs_value_field_id_fielddefs_id` FOREIGN KEY (`value_field_id`) REFERENCES `fielddefs` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_ut_fielddefs_visibility_field_id_fielddefs_id` FOREIGN KEY (`visibility_field_id`) REFERENCES `fielddefs` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=93 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8;

/*Table structure for table `ut_map_contractor_to_type` */

DROP TABLE IF EXISTS `ut_map_contractor_to_type`;

CREATE TABLE `ut_map_contractor_to_type` (
  `contractor_id` int(11) NOT NULL COMMENT 'id in the table `ut_contractors`',
  `contractor_type_id` mediumint(9) NOT NULL COMMENT 'id in the table `ut_contractor_types`',
  `created` datetime DEFAULT NULL COMMENT 'creation ts'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `ut_map_contractor_to_user` */

DROP TABLE IF EXISTS `ut_map_contractor_to_user`;

CREATE TABLE `ut_map_contractor_to_user` (
  `contractor_id` int(11) NOT NULL COMMENT 'id in the table `ut_contractors`',
  `bz_user_id` mediumint(9) NOT NULL COMMENT 'id in the table `profiles`',
  `created` datetime DEFAULT NULL COMMENT 'creation ts'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `ut_map_user_mefe_bzfe` */

DROP TABLE IF EXISTS `ut_map_user_mefe_bzfe`;

CREATE TABLE `ut_map_user_mefe_bzfe` (
  `created` datetime DEFAULT NULL COMMENT 'creation ts',
  `record_created_by` smallint(6) DEFAULT NULL COMMENT 'id of the user who created this user in the bz `profiles` table',
  `is_obsolete` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'This is an obsolete record',
  `bzfe_update_needed` tinyint(1) DEFAULT 0 COMMENT 'Do we need to update this record in the BZFE - This is to keep track of the user that have been modified in the MEFE but NOT yet in the BZFE',
  `user_id` int(11) DEFAULT NULL COMMENT 'id of the user in the MEFE',
  `bz_profile_id` mediumint(6) DEFAULT NULL COMMENT 'id of the user in the BZFE',
  `comment` text DEFAULT NULL COMMENT 'Any comment'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `ut_map_user_unit_details` */

DROP TABLE IF EXISTS `ut_map_user_unit_details`;

CREATE TABLE `ut_map_user_unit_details` (
  `created` datetime DEFAULT NULL COMMENT 'creation ts',
  `record_created_by` smallint(6) DEFAULT NULL COMMENT 'id of the user who created this user in the bz `profiles` table',
  `is_obsolete` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'This is an obsolete record',
  `user_id` int(11) DEFAULT NULL COMMENT 'id of the user in the MEFE',
  `bz_profile_id` mediumint(6) DEFAULT NULL COMMENT 'id of the user in the BZFE',
  `bz_unit_id` smallint(6) DEFAULT NULL COMMENT 'The id of the unit in the BZFE',
  `role_type_id` smallint(6) DEFAULT NULL COMMENT 'An id in the table ut_role_types: the role of the user for this unit',
  `can_see_time_tracking` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 (TRUE) if the user can see the timetracking information for a case',
  `can_create_shared_queries` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 (TRUE) if the user can create shared queries',
  `can_tag_comment` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 (TRUE) if the user can tag comments',
  `is_occupant` tinyint(1) NOT NULL DEFAULT 0 COMMENT '1 (TRUE) if the user is an occupnt for this unit',
  `is_public_assignee` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 (TRUE) if the user is one of the public assignee for this unit',
  `is_see_visible_assignee` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 (TRUE) if the user can see the public assignee for this unit',
  `is_in_cc_for_role` tinyint(1) NOT NULL DEFAULT 0 COMMENT '1 (TRUE if the user should be included in CC each time a new case is created for his/her role for this unit',
  `can_create_case` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 (TRUE if the user can create new cases for this unit',
  `can_edit_case` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 (TRUE) if the user can edit a case for this unit',
  `can_see_case` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 (TRUE) if the user can the all the public cases for this unit',
  `can_edit_all_field_regardless_of_role` tinyint(1) NOT NULL DEFAULT 0 COMMENT '1 (TRUE) if the user can edit all the fields in a case he/she has access to regardless of his or her role',
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
  UNIQUE KEY `bz_profile_id_bz_product_id` (`bz_profile_id`,`bz_unit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `ut_permission_types` */

DROP TABLE IF EXISTS `ut_permission_types`;

CREATE TABLE `ut_permission_types` (
  `id_permission_type` smallint(6) NOT NULL AUTO_INCREMENT COMMENT 'ID in this table',
  `created` datetime DEFAULT NULL COMMENT 'creation ts',
  `order` smallint(6) DEFAULT NULL COMMENT 'Order in the list',
  `is_obsolete` tinyint(1) DEFAULT 0 COMMENT '1 if this is an obsolete value',
  `group_type_id` smallint(6) DEFAULT NULL COMMENT 'The id of the group that grant this permission - a FK to the table ut_group_types',
  `permission_type` varchar(255) NOT NULL COMMENT 'A name for this role type',
  `permission_scope` varchar(255) DEFAULT NULL COMMENT '4 possible values: GLOBAL: for all units and roles, UNIT: permission for a specific unit, ROLE: permission for a specific role in a specific unit, SPECIAL: special permission (ex: occupant)',
  `permission_category` varchar(255) DEFAULT NULL COMMENT 'Possible values: ACCESS: group_control, GRANT FLAG: permissions to grant flags, ASK FOR APPROVAL: can ask a specific user to approve a flag, ROLE: a user is in a given role,',
  `is_bless` tinyint(1) DEFAULT 0 COMMENT '1 if this is a permission to grant membership to a given group',
  `bless_id` smallint(6) DEFAULT NULL COMMENT 'IF this is a ''blessing'' permission - which permission can this grant',
  `description` varchar(255) DEFAULT NULL COMMENT 'A short, generic description that we include each time we create a new BZ unit.',
  `detailed_description` text DEFAULT NULL COMMENT 'Detailed description of this group type',
  PRIMARY KEY (`id_permission_type`,`permission_type`),
  KEY `permission_groupe_type` (`group_type_id`),
  CONSTRAINT `permission_groupe_type` FOREIGN KEY (`group_type_id`) REFERENCES `ut_group_types` (`id_group_type`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8;

/*Table structure for table `ut_product_group` */

DROP TABLE IF EXISTS `ut_product_group`;

CREATE TABLE `ut_product_group` (
  `product_id` smallint(6) NOT NULL COMMENT 'id in the table products - to identify all the groups for a product/unit',
  `component_id` mediumint(9) DEFAULT NULL COMMENT 'id in the table components - to identify all the groups for a given component/role',
  `group_id` mediumint(9) NOT NULL COMMENT 'id in the table groups - to map the group to the list in the table `groups`',
  `group_type_id` smallint(6) NOT NULL COMMENT 'id in the table ut_group_types - to avoid re-creating the same group for the same product again',
  `role_type_id` smallint(6) DEFAULT NULL COMMENT 'id in the table ut_role_types - to make sure all similar stakeholder in a unit are made a member of the same group',
  `created_by_id` mediumint(9) DEFAULT NULL COMMENT 'id in the table ut_profiles',
  `created` datetime DEFAULT NULL COMMENT 'creation ts'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `ut_rep_platform` */

DROP TABLE IF EXISTS `ut_rep_platform`;

CREATE TABLE `ut_rep_platform` (
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

/*Table structure for table `ut_script_log` */

DROP TABLE IF EXISTS `ut_script_log`;

CREATE TABLE `ut_script_log` (
  `id_ut_script_log` int(11) NOT NULL AUTO_INCREMENT COMMENT 'The id of the record in this table',
  `datetime` datetime DEFAULT NULL COMMENT 'When was this record created',
  `script` mediumtext DEFAULT NULL COMMENT 'The script that was used to create the record',
  `log` text DEFAULT NULL COMMENT 'More information about what we intended to do',
  PRIMARY KEY (`id_ut_script_log`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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

/* Procedure structure for procedure `default_occupant_can_see_occupant` */

/*!50003 DROP PROCEDURE IF EXISTS  `default_occupant_can_see_occupant` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`mysql`@`%` PROCEDURE `default_occupant_can_see_occupant`()
BEGIN
	IF (@is_occupant = 1)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_see_users_occupant, 0, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user #'
										, @bz_user_id
										, ' can see occupant in the unit '
										, @product_id
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table = 'ut_user_group_map_temp';
				SET @permission_granted = 'can see occupant in the unit.';

				INSERT INTO `ut_audit_log`
					 (`datetime`
					 , `bzfe_table`
					 , `bzfe_field`
					 , `previous_value`
					 , `new_value`
					 , `script`
					 , `comment`
					 )
					 VALUES
					 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_see_users_occupant, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END */$$
DELIMITER ;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
