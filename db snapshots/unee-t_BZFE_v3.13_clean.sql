/*
SQLyog Ultimate v13.0.0 (64 bit)
MySQL - 5.7.12 : Database - unee_t_v3.13
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
  `ispatch` tinyint(4) NOT NULL DEFAULT '0',
  `filename` varchar(255) NOT NULL,
  `submitter_id` mediumint(9) NOT NULL,
  `isobsolete` tinyint(4) NOT NULL DEFAULT '0',
  `isprivate` tinyint(4) NOT NULL DEFAULT '0',
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
  `removed` mediumtext,
  `added` mediumtext,
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
  `sortkey` smallint(6) NOT NULL DEFAULT '0',
  `isactive` tinyint(4) NOT NULL DEFAULT '1',
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
  `sortkey` smallint(6) NOT NULL DEFAULT '0',
  `isactive` tinyint(4) NOT NULL DEFAULT '1',
  `visibility_value_id` smallint(6) DEFAULT NULL,
  `is_open` tinyint(4) NOT NULL DEFAULT '1',
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
  `bug_file_loc` mediumtext NOT NULL,
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
  `status_whiteboard` mediumtext NOT NULL,
  `lastdiffed` datetime DEFAULT NULL,
  `everconfirmed` tinyint(4) NOT NULL,
  `reporter_accessible` tinyint(4) NOT NULL DEFAULT '1',
  `cclist_accessible` tinyint(4) NOT NULL DEFAULT '1',
  `estimated_time` decimal(7,2) NOT NULL DEFAULT '0.00',
  `remaining_time` decimal(7,2) NOT NULL DEFAULT '0.00',
  `deadline` datetime DEFAULT NULL,
  `cf_ipi_clust_4_status_in_progress` varchar(64) NOT NULL DEFAULT '---',
  `cf_ipi_clust_4_status_standby` varchar(64) NOT NULL DEFAULT '---',
  `cf_ipi_clust_2_room` varchar(255) NOT NULL DEFAULT '',
  `cf_ipi_clust_6_claim_type` varchar(64) NOT NULL DEFAULT '---',
  `cf_ipi_clust_1_solution` mediumtext NOT NULL,
  `cf_ipi_clust_1_next_step` mediumtext NOT NULL,
  `cf_ipi_clust_1_next_step_date` date DEFAULT NULL,
  `cf_ipi_clust_3_field_action` mediumtext NOT NULL,
  `cf_ipi_clust_3_field_action_from` datetime DEFAULT NULL,
  `cf_ipi_clust_3_field_action_until` datetime DEFAULT NULL,
  `cf_ipi_clust_3_action_type` varchar(64) NOT NULL DEFAULT '---',
  `cf_ipi_clust_3_nber_field_visits` int(11) NOT NULL DEFAULT '0',
  `cf_ipi_clust_5_approved_budget` varchar(255) NOT NULL DEFAULT '',
  `cf_ipi_clust_5_budget` varchar(255) NOT NULL DEFAULT '',
  `cf_ipi_clust_8_contract_id` varchar(255) NOT NULL DEFAULT '',
  `cf_ipi_clust_9_inv_ll` varchar(255) NOT NULL DEFAULT '',
  `cf_ipi_clust_9_inv_det_ll` varchar(255) NOT NULL DEFAULT '',
  `cf_ipi_clust_9_inv_cust` mediumtext NOT NULL,
  `cf_ipi_clust_9_inv_det_cust` mediumtext NOT NULL,
  `cf_ipi_clust_5_spe_action_purchase_list` varchar(255) NOT NULL DEFAULT '',
  `cf_ipi_clust_5_spe_approval_for` mediumtext NOT NULL,
  `cf_ipi_clust_5_spe_approval_comment` mediumtext NOT NULL,
  `cf_ipi_clust_5_spe_contractor` mediumtext NOT NULL,
  `cf_ipi_clust_5_spe_purchase_cost` varchar(255) NOT NULL DEFAULT '',
  `cf_ipi_clust_7_spe_bill_number` varchar(255) NOT NULL DEFAULT '',
  `cf_ipi_clust_7_spe_payment_type` varchar(64) NOT NULL DEFAULT '---',
  `cf_ipi_clust_7_spe_contractor_payment` mediumtext NOT NULL,
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
  `comments` mediumtext,
  `comments_noprivate` mediumtext,
  PRIMARY KEY (`bug_id`),
  FULLTEXT KEY `bugs_fulltext_short_desc_idx` (`short_desc`),
  FULLTEXT KEY `bugs_fulltext_comments_idx` (`comments`),
  FULLTEXT KEY `bugs_fulltext_comments_noprivate_idx` (`comments_noprivate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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

/*Table structure for table `cf_ipi_clust_3_action_type` */

DROP TABLE IF EXISTS `cf_ipi_clust_3_action_type`;

CREATE TABLE `cf_ipi_clust_3_action_type` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `value` varchar(64) NOT NULL,
  `sortkey` smallint(6) NOT NULL DEFAULT '0',
  `isactive` tinyint(4) NOT NULL DEFAULT '1',
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
  `sortkey` smallint(6) NOT NULL DEFAULT '0',
  `isactive` tinyint(4) NOT NULL DEFAULT '1',
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
  `sortkey` smallint(6) NOT NULL DEFAULT '0',
  `isactive` tinyint(4) NOT NULL DEFAULT '1',
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
  `sortkey` smallint(6) NOT NULL DEFAULT '0',
  `isactive` tinyint(4) NOT NULL DEFAULT '1',
  `visibility_value_id` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cf_ipi_clust_4_status_standby_value_idx` (`value`),
  KEY `cf_ipi_clust_4_status_standby_visibility_value_id_idx` (`visibility_value_id`),
  KEY `cf_ipi_clust_4_status_standby_sortkey_idx` (`sortkey`,`value`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

/*Table structure for table `cf_ipi_clust_6_claim_type` */

DROP TABLE IF EXISTS `cf_ipi_clust_6_claim_type`;

CREATE TABLE `cf_ipi_clust_6_claim_type` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `value` varchar(64) NOT NULL,
  `sortkey` smallint(6) NOT NULL DEFAULT '0',
  `isactive` tinyint(4) NOT NULL DEFAULT '1',
  `visibility_value_id` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cf_ipi_clust_6_claim_type_value_idx` (`value`),
  KEY `cf_ipi_clust_6_claim_type_sortkey_idx` (`sortkey`,`value`),
  KEY `cf_ipi_clust_6_claim_type_visibility_value_id_idx` (`visibility_value_id`)
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8;

/*Table structure for table `cf_ipi_clust_7_spe_payment_type` */

DROP TABLE IF EXISTS `cf_ipi_clust_7_spe_payment_type`;

CREATE TABLE `cf_ipi_clust_7_spe_payment_type` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `value` varchar(64) NOT NULL,
  `sortkey` smallint(6) NOT NULL DEFAULT '0',
  `isactive` tinyint(4) NOT NULL DEFAULT '1',
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
  `sortkey` smallint(6) NOT NULL DEFAULT '0',
  `isactive` tinyint(4) NOT NULL DEFAULT '1',
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
  `sortkey` smallint(6) NOT NULL DEFAULT '0',
  `isactive` tinyint(4) NOT NULL DEFAULT '1',
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
  `description` mediumtext,
  `sortkey` smallint(6) NOT NULL DEFAULT '0',
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
  `isactive` tinyint(4) NOT NULL DEFAULT '1',
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
  `type` smallint(6) NOT NULL DEFAULT '0',
  `custom` tinyint(4) NOT NULL DEFAULT '0',
  `description` tinytext NOT NULL,
  `long_desc` varchar(255) NOT NULL DEFAULT '',
  `mailhead` tinyint(4) NOT NULL DEFAULT '0',
  `sortkey` smallint(6) NOT NULL,
  `obsolete` tinyint(4) NOT NULL DEFAULT '0',
  `enter_bug` tinyint(4) NOT NULL DEFAULT '0',
  `buglist` tinyint(4) NOT NULL DEFAULT '0',
  `visibility_field_id` mediumint(9) DEFAULT NULL,
  `value_field_id` mediumint(9) DEFAULT NULL,
  `reverse_desc` tinytext,
  `is_mandatory` tinyint(4) NOT NULL DEFAULT '0',
  `is_numeric` tinyint(4) NOT NULL DEFAULT '0',
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
  `is_active` tinyint(4) NOT NULL DEFAULT '1',
  `is_requestable` tinyint(4) NOT NULL DEFAULT '0',
  `is_requesteeble` tinyint(4) NOT NULL DEFAULT '0',
  `is_multiplicable` tinyint(4) NOT NULL DEFAULT '0',
  `sortkey` smallint(6) NOT NULL DEFAULT '0',
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
  `entry` tinyint(4) NOT NULL DEFAULT '0',
  `membercontrol` tinyint(4) NOT NULL DEFAULT '0',
  `othercontrol` tinyint(4) NOT NULL DEFAULT '0',
  `canedit` tinyint(4) NOT NULL DEFAULT '0',
  `editcomponents` tinyint(4) NOT NULL DEFAULT '0',
  `editbugs` tinyint(4) NOT NULL DEFAULT '0',
  `canconfirm` tinyint(4) NOT NULL DEFAULT '0',
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
  `grant_type` tinyint(4) NOT NULL DEFAULT '0',
  KEY `fk_group_group_map_grantor_id_groups_id` (`grantor_id`),
  KEY `group_group_map_grantor_id_grant_type_idx` (`grantor_id`,`grant_type`),
  KEY `group_group_map_member_id_grant_type_idx` (`member_id`,`grant_type`),
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
  `userregexp` tinytext NOT NULL,
  `isactive` tinyint(4) NOT NULL DEFAULT '1',
  `icon_url` tinytext,
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

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
  `work_time` decimal(7,2) NOT NULL DEFAULT '0.00',
  `thetext` mediumtext NOT NULL,
  `isprivate` tinyint(4) NOT NULL DEFAULT '0',
  `already_wrapped` tinyint(4) NOT NULL DEFAULT '0',
  `type` smallint(6) NOT NULL DEFAULT '0',
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
  `sortkey` smallint(6) NOT NULL DEFAULT '0',
  `isactive` tinyint(4) NOT NULL DEFAULT '1',
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
  `sortkey` smallint(6) NOT NULL DEFAULT '0',
  `isactive` tinyint(4) NOT NULL DEFAULT '1',
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
  `sortkey` smallint(6) NOT NULL DEFAULT '0',
  `isactive` tinyint(4) NOT NULL DEFAULT '1',
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
  `classification_id` smallint(6) NOT NULL DEFAULT '1',
  `description` mediumtext NOT NULL,
  `isactive` tinyint(4) NOT NULL DEFAULT '1',
  `defaultmilestone` varchar(64) NOT NULL DEFAULT '---',
  `allows_unconfirmed` tinyint(4) NOT NULL DEFAULT '1',
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
  `list_order` mediumtext,
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
  `disabledtext` mediumtext NOT NULL,
  `disable_mail` tinyint(4) NOT NULL DEFAULT '0',
  `mybugslink` tinyint(4) NOT NULL DEFAULT '1',
  `extern_id` varchar(64) DEFAULT NULL,
  `is_enabled` tinyint(4) NOT NULL DEFAULT '1',
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
  `oldvalue` tinytext,
  `newvalue` tinytext,
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
  `approved` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`quipid`),
  KEY `fk_quips_userid_profiles_userid` (`userid`),
  CONSTRAINT `fk_quips_userid_profiles_userid` FOREIGN KEY (`userid`) REFERENCES `profiles` (`userid`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `rep_platform` */

DROP TABLE IF EXISTS `rep_platform`;

CREATE TABLE `rep_platform` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `value` varchar(64) NOT NULL,
  `sortkey` smallint(6) NOT NULL DEFAULT '0',
  `isactive` tinyint(4) NOT NULL DEFAULT '1',
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
  `sortkey` smallint(6) NOT NULL DEFAULT '0',
  `isactive` tinyint(4) NOT NULL DEFAULT '1',
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
  `is_public` tinyint(4) NOT NULL DEFAULT '0',
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
  `is_enabled` tinyint(4) NOT NULL DEFAULT '1',
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
  `require_comment` tinyint(4) NOT NULL DEFAULT '0',
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
  `eventdata` tinytext,
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
  `funcid` int(11) NOT NULL DEFAULT '0',
  KEY `ts_error_funcid_idx` (`funcid`,`error_time`),
  KEY `ts_error_error_time_idx` (`error_time`),
  KEY `ts_error_jobid_idx` (`jobid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `ts_exitstatus` */

DROP TABLE IF EXISTS `ts_exitstatus`;

CREATE TABLE `ts_exitstatus` (
  `jobid` int(11) NOT NULL AUTO_INCREMENT,
  `funcid` int(11) NOT NULL DEFAULT '0',
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
  `arg` longblob,
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
  `value` longblob,
  UNIQUE KEY `ts_note_jobid_idx` (`jobid`,`notekey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `user_api_keys` */

DROP TABLE IF EXISTS `user_api_keys`;

CREATE TABLE `user_api_keys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` mediumint(9) NOT NULL,
  `api_key` varchar(40) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `revoked` tinyint(4) NOT NULL DEFAULT '0',
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
  `isbless` tinyint(4) NOT NULL DEFAULT '0',
  `grant_type` tinyint(4) NOT NULL DEFAULT '0',
  UNIQUE KEY `user_group_map_user_id_idx` (`user_id`,`group_id`,`grant_type`,`isbless`),
  KEY `fk_user_group_map_group_id_groups_id` (`group_id`),
  CONSTRAINT `fk_user_group_map_group_id_groups_id` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_user_group_map_user_id_profiles_userid` FOREIGN KEY (`user_id`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `ut_all_units` */

DROP TABLE IF EXISTS `ut_all_units`;

CREATE TABLE `ut_all_units` (
  `id_record` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` smallint(6) NOT NULL COMMENT 'The id in the `products` table',
  PRIMARY KEY (`id_record`)
) ENGINE=InnoDB AUTO_INCREMENT=512 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `ut_audit_log` */

DROP TABLE IF EXISTS `ut_audit_log`;

CREATE TABLE `ut_audit_log` (
  `id_ut_log` int(11) NOT NULL AUTO_INCREMENT COMMENT 'The id of the record in this table',
  `datetime` datetime DEFAULT NULL COMMENT 'When was this record created',
  `bzfe_table` varchar(256) DEFAULT NULL COMMENT 'The name of the table that was altered',
  `bzfe_field` varchar(256) DEFAULT NULL COMMENT 'The name of the field that was altered in the bzfe table',
  `previous_value` mediumtext COMMENT 'The value of the field before the change',
  `new_value` mediumtext COMMENT 'The value of the field after the change',
  `script` mediumtext COMMENT 'The script that was used to create the record',
  `comment` text COMMENT 'More information about what we intended to do',
  PRIMARY KEY (`id_ut_log`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `ut_contractor_types` */

DROP TABLE IF EXISTS `ut_contractor_types`;

CREATE TABLE `ut_contractor_types` (
  `id_contractor_type` smallint(6) NOT NULL AUTO_INCREMENT COMMENT 'ID in this table',
  `created` datetime DEFAULT NULL COMMENT 'creation ts',
  `contractor_type` varchar(255) NOT NULL COMMENT 'A name for this contractor type',
  `bz_description` varchar(255) DEFAULT NULL COMMENT 'A short, generic description that we include each time we create a new BZ unit.',
  `description` text COMMENT 'Detailed description of this contractor type',
  PRIMARY KEY (`id_contractor_type`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

/*Table structure for table `ut_contractors` */

DROP TABLE IF EXISTS `ut_contractors`;

CREATE TABLE `ut_contractors` (
  `id_contractor` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID in this table',
  `created` datetime DEFAULT NULL COMMENT 'creation ts',
  `contractor_name` varchar(255) NOT NULL COMMENT 'A name for this contractor',
  `contractor_description` varchar(255) DEFAULT NULL COMMENT 'A short, generic description that we include each time we create a new BZ contractor.',
  `contractor_details` text COMMENT 'Detailed description of this contractor - This can be built from a SQL Less table and/or the MEFE',
  PRIMARY KEY (`id_contractor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `ut_data_to_add_user_to_a_case` */

DROP TABLE IF EXISTS `ut_data_to_add_user_to_a_case`;

CREATE TABLE `ut_data_to_add_user_to_a_case` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'The unique ID in this table',
  `mefe_invitation_id` varchar(256) DEFAULT NULL COMMENT 'The unique Id for the invitation that was generated in MEFE to do the data import',
  `mefe_invitor_user_id` varchar(256) DEFAULT NULL COMMENT 'The id of the creator of this unit in the MEFE database',
  `bzfe_invitor_user_id` mediumint(9) NOT NULL COMMENT 'The BZFE user id who creates this unit. this is a FK to the BZ table ''profiles''',
  `bz_user_id` mediumint(9) NOT NULL COMMENT 'The userid for the user that will be rfeplcing the dummy user for this role for this unit. This is a FK to the BZ table ''profiles''',
  `bz_case_id` mediumint(9) NOT NULL COMMENT 'The case id that the user is invited to - This is a FK to the BZ table ''bugs''',
  `bz_created_date` datetime DEFAULT NULL COMMENT 'Date and time when this unit has been created in the BZ databae',
  `comment` text COMMENT 'Any comment',
  PRIMARY KEY (`id`),
  KEY `add_user_to_a_case_invitor_bz_id` (`bzfe_invitor_user_id`),
  KEY `add_user_to_a_case_invitee_bz_id` (`bz_user_id`),
  KEY `add_user_to_a_case_case_id` (`bz_case_id`),
  CONSTRAINT `add_user_to_a_case_case_id` FOREIGN KEY (`bz_case_id`) REFERENCES `bugs` (`bug_id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `add_user_to_a_case_invitee_bz_id` FOREIGN KEY (`bz_user_id`) REFERENCES `profiles` (`userid`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `add_user_to_a_case_invitor_bz_id` FOREIGN KEY (`bzfe_invitor_user_id`) REFERENCES `profiles` (`userid`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `ut_data_to_add_user_to_a_role` */

DROP TABLE IF EXISTS `ut_data_to_add_user_to_a_role`;

CREATE TABLE `ut_data_to_add_user_to_a_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'The unique ID in this table',
  `mefe_invitation_id` varchar(256) DEFAULT NULL COMMENT 'The unique Id for the invitation that was generated in MEFE to do the data import',
  `mefe_invitor_user_id` varchar(256) DEFAULT NULL COMMENT 'The id of the creator of this unit in the MEFE database',
  `bzfe_invitor_user_id` mediumint(9) NOT NULL COMMENT 'The BZFE user id who creates this unit. this is a FK to the BZ table ''profiles''',
  `bz_unit_id` smallint(6) NOT NULL COMMENT 'The product id in the BZ table ''products''',
  `bz_user_id` mediumint(9) NOT NULL COMMENT 'The userid for the user that will be rfeplcing the dummy user for this role for this unit. This is a FK to the BZ table ''profiles''',
  `user_role_type_id` smallint(6) NOT NULL COMMENT 'The id of the role type for the invited user. This is a FK to the table ''ut_role_types''',
  `is_occupant` tinyint(1) DEFAULT '0' COMMENT '1 if TRUE, 0 if FALSE',
  `user_more` varchar(500) DEFAULT '' COMMENT 'A text to give more information about the user. This will be used in the BZ Component Description',
  `bz_created_date` datetime DEFAULT NULL COMMENT 'Date and time when this unit has been created in the BZ databae',
  `comment` text COMMENT 'Any comment',
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
  `mefe_unit_id` varchar(256) DEFAULT NULL COMMENT 'The id of this unit in the MEFE database',
  `mefe_creator_user_id` varchar(256) DEFAULT NULL COMMENT 'The id of the creator of this unit in the MEFE database',
  `bzfe_creator_user_id` mediumint(9) NOT NULL COMMENT 'The BZFE user id who creates this unit. this is a FK to the BZ table ''profiles''',
  `classification_id` smallint(6) NOT NULL COMMENT 'The ID of the classification for this unit - a FK to the BZ table ''classifications''',
  `unit_name` varchar(54) NOT NULL DEFAULT '' COMMENT 'A name for the unit. We will append the product id and this will be inserted in the product name field of the BZ tabele product which has a max lenght of 64',
  `unit_description_details` varchar(500) DEFAULT '' COMMENT 'More information about the unit - this is a free text space',
  `bz_created_date` datetime DEFAULT NULL COMMENT 'Date and time when this unit has been created in the BZ databae',
  `comment` text COMMENT 'Any comment',
  `product_id` smallint(6) DEFAULT NULL COMMENT 'The id of the product in the BZ table ''products''. Because this is a record that we will keep even AFTER we deleted the record in the BZ table, this can NOT be a FK.',
  `deleted_datetime` datetime DEFAULT NULL COMMENT 'Timestamp when this was deleted in the BZ db (together with all objects related to this product/unit).',
  `deletion_script` varchar(500) DEFAULT NULL COMMENT 'The script used to delete this product and all objects related to this product in the BZ database',
  PRIMARY KEY (`id_unit_to_create`),
  UNIQUE KEY `new_unite_mefe_unit_id_must_be_unique` (`mefe_unit_id`),
  KEY `new_unit_classification_id_must_exist` (`classification_id`),
  KEY `new_unit_unit_creator_bz_id_must_exist` (`bzfe_creator_user_id`),
  CONSTRAINT `new_unit_classification_id_must_exist` FOREIGN KEY (`classification_id`) REFERENCES `classifications` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `new_unit_unit_creator_bz_id_must_exist` FOREIGN KEY (`bzfe_creator_user_id`) REFERENCES `profiles` (`userid`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `ut_data_to_create_units_legacy_before_3_3` */

DROP TABLE IF EXISTS `ut_data_to_create_units_legacy_before_3_3`;

CREATE TABLE `ut_data_to_create_units_legacy_before_3_3` (
  `id_unit_to_create` int(11) NOT NULL AUTO_INCREMENT COMMENT 'The unique ID in this table',
  `mefe_id` varchar(256) DEFAULT NULL COMMENT 'The id of the object in the MEFE interface where these information are coming from',
  `mefe_creator_user_id` varchar(256) DEFAULT NULL COMMENT 'The id of the creator of this unit in the MEFE database',
  `mefe_unit_id` varchar(256) DEFAULT NULL COMMENT 'The id of this unit in the MEFE database',
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
  `comment` text COMMENT 'Any comment',
  `product_id` smallint(6) DEFAULT NULL COMMENT 'The id of the product in the BZ table ''products''. Because this is a record that we will keep even AFTER we deleted the record in the BZ table, this can NOT be a FK.',
  `deleted_datetime` datetime DEFAULT NULL COMMENT 'Timestamp when this was deleted in the BZ db (together with all objects related to this product/unit).',
  `deletion_script` varchar(500) DEFAULT NULL COMMENT 'The script used to delete this product and all objects related to this product in the BZ database',
  PRIMARY KEY (`id_unit_to_create`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

/*Table structure for table `ut_data_to_replace_dummy_roles` */

DROP TABLE IF EXISTS `ut_data_to_replace_dummy_roles`;

CREATE TABLE `ut_data_to_replace_dummy_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'The unique ID in this table',
  `mefe_invitation_id` varchar(256) DEFAULT NULL COMMENT 'The unique Id for the invitation that was generated in MEFE to do the data import',
  `mefe_invitor_user_id` varchar(256) DEFAULT NULL COMMENT 'The id of the creator of this unit in the MEFE database',
  `bzfe_invitor_user_id` mediumint(9) NOT NULL COMMENT 'The BZFE user id who creates this unit. this is a FK to the BZ table ''profiles''',
  `bz_unit_id` smallint(6) NOT NULL COMMENT 'The product id in the BZ table ''products''',
  `bz_user_id` mediumint(9) NOT NULL COMMENT 'The userid for the user that will be rfeplcing the dummy user for this role for this unit. This is a FK to the BZ table ''profiles''',
  `user_role_type_id` smallint(6) NOT NULL COMMENT 'The id of the role type for the invited user. This is a FK to the table ''ut_role_types''',
  `is_occupant` tinyint(1) DEFAULT '0' COMMENT '1 if TRUE, 0 if FALSE',
  `is_mefe_user_only` tinyint(1) DEFAULT '1' COMMENT '1 (default value) if TRUE - If a user is a MEFE user only we disable the claim mail in the BZFE',
  `user_more` varchar(500) DEFAULT '' COMMENT 'A text to give more information about the user. This will be used in the BZ Component Description',
  `bz_created_date` datetime DEFAULT NULL COMMENT 'Date and time when this unit has been created in the BZ databae',
  `comment` text COMMENT 'Any comment',
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

/*Table structure for table `ut_db_schema_version` */

DROP TABLE IF EXISTS `ut_db_schema_version`;

CREATE TABLE `ut_db_schema_version` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique ID in this table',
  `schema_version` varchar(256) DEFAULT NULL COMMENT 'The current version of the BZ DB schema for Unee-T',
  `update_datetime` datetime DEFAULT NULL COMMENT 'Timestamp - when this version was implemented in THIS environment',
  `update_script` varchar(256) DEFAULT NULL COMMENT 'The script which was used to do the db ugrade',
  `comment` text COMMENT 'Comment',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

/*Table structure for table `ut_flash_units_with_dummy_users` */

DROP TABLE IF EXISTS `ut_flash_units_with_dummy_users`;

CREATE TABLE `ut_flash_units_with_dummy_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id in this table',
  `created_datetime` datetime DEFAULT NULL COMMENT 'The timestamp when this record was created',
  `updated_datetime` datetime DEFAULT NULL COMMENT 'The timestamp when this record was updated. It is equal to the created_datetime if the record has never been updated',
  `unit_id` smallint(6) DEFAULT NULL COMMENT 'The BZ Product_id for the unit with a dummy role a FK to the table ''products''',
  `role_id` mediumint(9) DEFAULT NULL COMMENT 'The BZ component_id - a FK to the table `components`',
  `role_type_id` smallint(6) DEFAULT NULL COMMENT 'The Ut role type id - a FK to the table ''ut_role_types''',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `ut_group_types` */

DROP TABLE IF EXISTS `ut_group_types`;

CREATE TABLE `ut_group_types` (
  `id_group_type` smallint(6) NOT NULL AUTO_INCREMENT COMMENT 'ID in this table',
  `created` datetime DEFAULT NULL COMMENT 'creation ts',
  `order` smallint(6) DEFAULT NULL COMMENT 'Order in the list',
  `is_obsolete` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'This is an obsolete record',
  `groupe_type` varchar(255) NOT NULL COMMENT 'A name for this group type',
  `bz_description` varchar(255) DEFAULT NULL COMMENT 'A short description for BZ which we use when we create the group',
  `description` text COMMENT 'Detailed description of this group type',
  PRIMARY KEY (`id_group_type`,`groupe_type`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8;

/*Table structure for table `ut_invitation_api_data` */

DROP TABLE IF EXISTS `ut_invitation_api_data`;

CREATE TABLE `ut_invitation_api_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'The unique ID in this table',
  `mefe_invitation_id` varchar(256) DEFAULT NULL COMMENT 'The unique Id for the invitation that was generated in MEFE to do the data import',
  `bzfe_invitor_user_id` mediumint(9) NOT NULL COMMENT 'The BZFE user id who creates this unit. this is a FK to the BZ table ''profiles''',
  `bz_user_id` mediumint(9) NOT NULL COMMENT 'The userid for the user that will be rfeplcing the dummy user for this role for this unit. This is a FK to the BZ table ''profiles''',
  `user_role_type_id` smallint(6) NOT NULL COMMENT 'The id of the role type for the invited user. This is a FK to the table ''ut_role_types''',
  `is_occupant` tinyint(1) DEFAULT '0' COMMENT '1 if TRUE, 0 if FALSE',
  `bz_case_id` mediumint(9) DEFAULT NULL COMMENT 'The id of the bug in th table ''bugs''',
  `bz_unit_id` smallint(6) NOT NULL COMMENT 'The product id in the BZ table ''products''',
  `invitation_type` varchar(255) NOT NULL COMMENT 'The type of the invitation (assigned or CC)',
  `is_mefe_only_user` tinyint(1) DEFAULT '1' COMMENT '1 if the user is a MEFE only user. In this scenario, we will DISABLE the claim mail in the BZFE for that user',
  `user_more` varchar(500) DEFAULT '' COMMENT 'A text to give more information about the user. This will be used in the BZ Component Description',
  `mefe_invitor_user_id` varchar(256) DEFAULT NULL COMMENT 'The id of the creator of this unit in the MEFE database',
  `processed_datetime` datetime DEFAULT NULL COMMENT 'The Timestamp when this invitation has been processed in the BZ database',
  `script` varchar(256) DEFAULT NULL COMMENT 'The SQL script or procedure that was used to process this record',
  `api_post_datetime` datetime DEFAULT NULL COMMENT 'Date and time when this invitation has been posted as porcessed via the Unee-T inviation API',
  PRIMARY KEY (`id`),
  UNIQUE KEY `MEFE_INVITATION_ID` (`mefe_invitation_id`),
  KEY `invitation_bz_bug_must_exist` (`bz_case_id`),
  KEY `invitation_bz_invitee_must_exist` (`bz_user_id`),
  KEY `invitation_bz_invitor_must_exist` (`bzfe_invitor_user_id`),
  KEY `invitation_bz_product_must_exist` (`bz_unit_id`),
  KEY `invitation_invitation_type_must_exist` (`invitation_type`),
  CONSTRAINT `invitation_bz_bug_must_exist` FOREIGN KEY (`bz_case_id`) REFERENCES `bugs` (`bug_id`),
  CONSTRAINT `invitation_bz_invitee_must_exist` FOREIGN KEY (`bz_user_id`) REFERENCES `profiles` (`userid`),
  CONSTRAINT `invitation_bz_invitor_must_exist` FOREIGN KEY (`bzfe_invitor_user_id`) REFERENCES `profiles` (`userid`),
  CONSTRAINT `invitation_bz_product_must_exist` FOREIGN KEY (`bz_unit_id`) REFERENCES `products` (`id`),
  CONSTRAINT `invitation_invitation_type_must_exist` FOREIGN KEY (`invitation_type`) REFERENCES `ut_invitation_types` (`invitation_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `ut_invitation_types` */

DROP TABLE IF EXISTS `ut_invitation_types`;

CREATE TABLE `ut_invitation_types` (
  `id_invitation_type` smallint(6) NOT NULL AUTO_INCREMENT COMMENT 'ID in this table',
  `created` datetime DEFAULT NULL COMMENT 'creation ts',
  `order` smallint(6) DEFAULT NULL COMMENT 'Order in the list',
  `is_active` tinyint(1) DEFAULT '0' COMMENT '1 if this is an active invitation: we have the scripts to process these',
  `invitation_type` varchar(255) NOT NULL COMMENT 'A name for this invitation type',
  `detailed_description` text COMMENT 'Detailed description of this group type',
  PRIMARY KEY (`id_invitation_type`,`invitation_type`),
  UNIQUE KEY `invitation_type_is_unique` (`invitation_type`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

/*Table structure for table `ut_log_count_closed_cases` */

DROP TABLE IF EXISTS `ut_log_count_closed_cases`;

CREATE TABLE `ut_log_count_closed_cases` (
  `id_log_closed_case` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique id in this table',
  `timestamp` datetime DEFAULT NULL COMMENT 'The timestamp when this record was created',
  `count_closed_cases` int(11) NOT NULL COMMENT 'The number of closed case at this Datetime',
  `count_total_cases` int(11) DEFAULT NULL COMMENT 'The total number of cases in Unee-T at this time',
  PRIMARY KEY (`id_log_closed_case`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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

/*Table structure for table `ut_map_invitation_type_to_permission_type` */

DROP TABLE IF EXISTS `ut_map_invitation_type_to_permission_type`;

CREATE TABLE `ut_map_invitation_type_to_permission_type` (
  `invitation_type_id` smallint(6) NOT NULL COMMENT 'id of the invitation type in the table `ut_invitation_types`',
  `permission_type_id` smallint(6) NOT NULL COMMENT 'id of the permission type in the table `ut_permission_types`',
  `created` datetime DEFAULT NULL COMMENT 'creation ts',
  `record_created_by` smallint(6) DEFAULT NULL COMMENT 'id of the user who created this user in the bz `profiles` table',
  `is_obsolete` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'This is an obsolete record',
  `comment` text COMMENT 'Any comment',
  PRIMARY KEY (`invitation_type_id`,`permission_type_id`),
  KEY `map_invitation_to_permission_permission_type_id` (`permission_type_id`),
  CONSTRAINT `map_invitation_to_permission_invitation_type_id` FOREIGN KEY (`invitation_type_id`) REFERENCES `ut_invitation_types` (`id_invitation_type`),
  CONSTRAINT `map_invitation_to_permission_permission_type_id` FOREIGN KEY (`permission_type_id`) REFERENCES `ut_permission_types` (`id_permission_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `ut_map_user_mefe_bzfe` */

DROP TABLE IF EXISTS `ut_map_user_mefe_bzfe`;

CREATE TABLE `ut_map_user_mefe_bzfe` (
  `created` datetime DEFAULT NULL COMMENT 'creation ts',
  `record_created_by` smallint(6) DEFAULT NULL COMMENT 'id of the user who created this user in the bz `profiles` table',
  `is_obsolete` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'This is an obsolete record',
  `bzfe_update_needed` tinyint(1) DEFAULT '0' COMMENT 'Do we need to update this record in the BZFE - This is to keep track of the user that have been modified in the MEFE but NOT yet in the BZFE',
  `mefe_user_id` varchar(256) DEFAULT NULL COMMENT 'id of the user in the MEFE',
  `bz_profile_id` mediumint(6) DEFAULT NULL COMMENT 'id of the user in the BZFE',
  `comment` text COMMENT 'Any comment'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `ut_map_user_unit_details` */

DROP TABLE IF EXISTS `ut_map_user_unit_details`;

CREATE TABLE `ut_map_user_unit_details` (
  `created` datetime DEFAULT NULL COMMENT 'creation ts',
  `record_created_by` smallint(6) DEFAULT NULL COMMENT 'id of the user who created this user in the bz `profiles` table',
  `is_obsolete` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'This is an obsolete record',
  `user_id` int(11) DEFAULT NULL COMMENT 'id of the user in the MEFE',
  `bz_profile_id` mediumint(6) DEFAULT NULL COMMENT 'id of the user in the BZFE',
  `bz_unit_id` smallint(6) DEFAULT NULL COMMENT 'The id of the unit in the BZFE',
  `role_type_id` smallint(6) DEFAULT NULL COMMENT 'An id in the table ut_role_types: the role of the user for this unit',
  `can_see_time_tracking` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 (TRUE) if the user can see the timetracking information for a case',
  `can_create_shared_queries` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 (TRUE) if the user can create shared queries',
  `can_tag_comment` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 (TRUE) if the user can tag comments',
  `is_occupant` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 (TRUE) if the user is an occupnt for this unit',
  `is_public_assignee` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 (TRUE) if the user is one of the public assignee for this unit',
  `is_see_visible_assignee` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 (TRUE) if the user can see the public assignee for this unit',
  `is_in_cc_for_role` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 (TRUE if the user should be included in CC each time a new case is created for his/her role for this unit',
  `can_create_case` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 (TRUE if the user can create new cases for this unit',
  `can_edit_case` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 (TRUE) if the user can edit a case for this unit',
  `can_see_case` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 (TRUE) if the user can the all the public cases for this unit',
  `can_edit_all_field_regardless_of_role` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 (TRUE) if the user can edit all the fields in a case he/she has access to regardless of his or her role',
  `is_flag_requestee` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 (TRUE) if the user can be asked to approve all flags',
  `is_flag_approver` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 (TRUE) if the user can approve all flags',
  `can_create_any_sh` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 (TRUE) if the user can create any type of stakeholder',
  `can_create_same_sh` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 (TRUE) if the user can add user as similar stakeholder for that unit',
  `can_approve_user_for_flags` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 (TRUE) if the user can decide if a user can be requested to approve all flags',
  `can_decide_if_user_visible` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 (TRUE) if the user can decide if another user is visible',
  `can_decide_if_user_can_see_visible` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 (TRUE) if the user can decide if another user can see the visible users',
  `public_name` varchar(255) DEFAULT NULL COMMENT 'The user Public name',
  `more_info` text COMMENT 'More information about this user. We display this in the component/stakeholder description for the unit',
  `comment` text COMMENT 'Any comment',
  UNIQUE KEY `bz_profile_id_bz_product_id` (`bz_profile_id`,`bz_unit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `ut_notification_case_assignee` */

DROP TABLE IF EXISTS `ut_notification_case_assignee`;

CREATE TABLE `ut_notification_case_assignee` (
  `notification_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Id in this table',
  `created_datetime` datetime DEFAULT NULL COMMENT 'Timestamp when this was created',
  `processed_datetime` datetime DEFAULT NULL COMMENT 'Timestamp when this notification was processed',
  `unit_id` smallint(6) DEFAULT NULL COMMENT 'Unit ID - a FK to the BZ table ''products''',
  `case_id` mediumint(9) DEFAULT NULL COMMENT 'Case ID - a FK to the BZ table ''bugs''',
  `case_title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'The title for the case - the is the field `short_desc` in the `bugs` table',
  `invitor_user_id` mediumint(9) DEFAULT NULL COMMENT 'User ID - The user who inititated the change - a FK to the BZ table ''profiles''',
  `assignee_user_id` mediumint(9) DEFAULT NULL COMMENT 'User ID - The user who has been assigned to the case a FK to the BZ table ''profiles''',
  PRIMARY KEY (`notification_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `ut_notification_case_invited` */

DROP TABLE IF EXISTS `ut_notification_case_invited`;

CREATE TABLE `ut_notification_case_invited` (
  `notification_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Id in this table',
  `created_datetime` datetime DEFAULT NULL COMMENT 'Timestamp when this was created',
  `processed_datetime` datetime DEFAULT NULL COMMENT 'Timestamp when this notification was processed',
  `unit_id` smallint(6) DEFAULT NULL COMMENT 'Unit ID - a FK to the BZ table ''products''',
  `case_id` mediumint(9) DEFAULT NULL COMMENT 'Case ID - a FK to the BZ table ''bugs''',
  `case_title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'The title for the case - the is the field `short_desc` in the `bugs` table',
  `invitor_user_id` mediumint(9) DEFAULT NULL COMMENT 'User ID - The user who inititated the change - a FK to the BZ table ''profiles''',
  `invitee_user_id` mediumint(9) DEFAULT NULL COMMENT 'User ID - The user who has been invited to the case a FK to the BZ table ''profiles''',
  PRIMARY KEY (`notification_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `ut_notification_case_new` */

DROP TABLE IF EXISTS `ut_notification_case_new`;

CREATE TABLE `ut_notification_case_new` (
  `notification_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Id in this table',
  `created_datetime` datetime DEFAULT NULL COMMENT 'Timestamp when this was created',
  `processed_datetime` datetime DEFAULT NULL COMMENT 'Timestamp when this notification was processed',
  `unit_id` smallint(6) DEFAULT NULL COMMENT 'Unit ID - a FK to the BZ table ''products''',
  `case_id` mediumint(9) DEFAULT NULL COMMENT 'Case ID - a FK to the BZ table ''bugs''',
  `case_title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'The title for the case - the is the field `short_desc` in the `bugs` table',
  `user_id` mediumint(9) DEFAULT NULL COMMENT 'User ID - The user who inititated the change - a FK to the BZ table ''profiles''',
  `assignee_id` mediumint(9) DEFAULT NULL COMMENT 'User ID - The user who is assigned to this case - a FK to the BZ table ''profiles''',
  PRIMARY KEY (`notification_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

/*Table structure for table `ut_notification_case_updated` */

DROP TABLE IF EXISTS `ut_notification_case_updated`;

CREATE TABLE `ut_notification_case_updated` (
  `notification_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Id in this table',
  `created_datetime` datetime DEFAULT NULL COMMENT 'Timestamp when this was created',
  `processed_datetime` datetime DEFAULT NULL COMMENT 'Timestamp when this notification was processed',
  `unit_id` smallint(6) DEFAULT NULL COMMENT 'Unit ID - a FK to the BZ table ''products''',
  `case_id` mediumint(9) DEFAULT NULL COMMENT 'Case ID - a FK to the BZ table ''bugs''',
  `case_title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'The title for the case - the is the field `short_desc` in the `bugs` table',
  `user_id` mediumint(9) DEFAULT NULL COMMENT 'User ID - The user who inititated the change - a FK to the BZ table ''profiles''',
  `update_what` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'The field that was updated',
  PRIMARY KEY (`notification_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `ut_notification_message_new` */

DROP TABLE IF EXISTS `ut_notification_message_new`;

CREATE TABLE `ut_notification_message_new` (
  `notification_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Id in this table',
  `created_datetime` datetime DEFAULT NULL COMMENT 'Timestamp when this was created',
  `processed_datetime` datetime DEFAULT NULL COMMENT 'Timestamp when this notification was processed',
  `unit_id` smallint(6) DEFAULT NULL COMMENT 'Unit ID - a FK to the BZ table ''products''',
  `case_id` mediumint(9) DEFAULT NULL COMMENT 'Case ID - a FK to the BZ table ''bugs''',
  `case_title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'The title for the case - the is the field `short_desc` in the `bugs` table',
  `user_id` mediumint(9) DEFAULT NULL COMMENT 'User ID - The user who inititated the change - a FK to the BZ table ''profiles''',
  `message_truncated` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'The message, truncated to the first 255 characters',
  PRIMARY KEY (`notification_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

/*Table structure for table `ut_notification_types` */

DROP TABLE IF EXISTS `ut_notification_types`;

CREATE TABLE `ut_notification_types` (
  `id_role_type` smallint(6) NOT NULL AUTO_INCREMENT COMMENT 'ID in this table',
  `created` datetime DEFAULT NULL COMMENT 'creation ts',
  `notification_type` varchar(255) NOT NULL COMMENT 'A name for this role type',
  `short_description` varchar(255) DEFAULT NULL COMMENT 'A short, generic description that we include each time we create a new BZ unit.',
  `long_description` text COMMENT 'Detailed description of this group type',
  PRIMARY KEY (`id_role_type`),
  UNIQUE KEY `unique_notification_type` (`notification_type`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

/*Table structure for table `ut_permission_types` */

DROP TABLE IF EXISTS `ut_permission_types`;

CREATE TABLE `ut_permission_types` (
  `id_permission_type` smallint(6) NOT NULL AUTO_INCREMENT COMMENT 'ID in this table',
  `created` datetime DEFAULT NULL COMMENT 'creation ts',
  `order` smallint(6) DEFAULT NULL COMMENT 'Order in the list',
  `is_obsolete` tinyint(1) DEFAULT '0' COMMENT '1 if this is an obsolete value',
  `group_type_id` smallint(6) DEFAULT NULL COMMENT 'The id of the group that grant this permission - a FK to the table ut_group_types',
  `permission_type` varchar(255) NOT NULL COMMENT 'A name for this role type',
  `permission_scope` varchar(255) DEFAULT NULL COMMENT '4 possible values: GLOBAL: for all units and roles, UNIT: permission for a specific unit, ROLE: permission for a specific role in a specific unit, SPECIAL: special permission (ex: occupant)',
  `permission_category` varchar(255) DEFAULT NULL COMMENT 'Possible values: ACCESS: group_control, GRANT FLAG: permissions to grant flags, ASK FOR APPROVAL: can ask a specific user to approve a flag, ROLE: a user is in a given role,',
  `is_bless` tinyint(1) DEFAULT '0' COMMENT '1 if this is a permission to grant membership to a given group',
  `bless_id` smallint(6) DEFAULT NULL COMMENT 'IF this is a ''blessing'' permission - which permission can this grant',
  `description` varchar(255) DEFAULT NULL COMMENT 'A short, generic description that we include each time we create a new BZ unit.',
  `detailed_description` text COMMENT 'Detailed description of this group type',
  PRIMARY KEY (`id_permission_type`,`permission_type`),
  KEY `premission_groupe_type` (`group_type_id`),
  CONSTRAINT `premission_groupe_type` FOREIGN KEY (`group_type_id`) REFERENCES `ut_group_types` (`id_group_type`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8;

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

/*Table structure for table `ut_role_types` */

DROP TABLE IF EXISTS `ut_role_types`;

CREATE TABLE `ut_role_types` (
  `id_role_type` smallint(6) NOT NULL AUTO_INCREMENT COMMENT 'ID in this table',
  `created` datetime DEFAULT NULL COMMENT 'creation ts',
  `role_type` varchar(255) NOT NULL COMMENT 'A name for this role type',
  `bz_description` varchar(255) DEFAULT NULL COMMENT 'A short, generic description that we include each time we create a new BZ unit.',
  `description` text COMMENT 'Detailed description of this group type',
  PRIMARY KEY (`id_role_type`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

/*Table structure for table `ut_script_log` */

DROP TABLE IF EXISTS `ut_script_log`;

CREATE TABLE `ut_script_log` (
  `id_ut_script_log` int(11) NOT NULL AUTO_INCREMENT COMMENT 'The id of the record in this table',
  `datetime` datetime DEFAULT NULL COMMENT 'When was this record created',
  `script` mediumtext COMMENT 'The script that was used to create the record',
  `log` text COMMENT 'More information about what we intended to do',
  PRIMARY KEY (`id_ut_script_log`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `versions` */

DROP TABLE IF EXISTS `versions`;

CREATE TABLE `versions` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `value` varchar(64) NOT NULL,
  `product_id` smallint(6) NOT NULL,
  `isactive` tinyint(4) NOT NULL DEFAULT '1',
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
  `body` mediumtext,
  `mailifnobugs` tinyint(4) NOT NULL DEFAULT '0',
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
  `sortkey` smallint(6) NOT NULL DEFAULT '0',
  `onemailperbug` tinyint(4) NOT NULL DEFAULT '0',
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
  `mailto_type` smallint(6) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `whine_schedules_run_next_idx` (`run_next`),
  KEY `whine_schedules_eventid_idx` (`eventid`),
  CONSTRAINT `fk_whine_schedules_eventid_whine_events_id` FOREIGN KEY (`eventid`) REFERENCES `whine_events` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* Trigger structure for table `bugs` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `ut_prepare_message_new_case` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `ut_prepare_message_new_case` AFTER INSERT ON `bugs` FOR EACH ROW 
BEGIN
	# Clean Slate: make sure all the variables we use are properly flushed first
		SET @notification_type = NULL;
		SET @bz_source_table = NULL;
		SET @notification_id = NULL;
		SET @unique_notification_id = NULL;
		SET @created_datetime = NULL;
		SET @unit_id = NULL;
		SET @case_id = NULL;
		SET @case_title = NULL;
		SET @user_id = NULL;
		SET @assignee_id = NULL;

	# We have a clean slate, define the variables now
		SET @notification_type = 'case_new';
		SET @bz_source_table = 'ut_notification_case_new';
		SET @notification_id = ((SELECT MAX(`notification_id`) FROM `ut_notification_case_new`) + 1);
		SET @unique_notification_id = (CONCAT(@bz_source_table, '-', @notification_id));
		SET @created_datetime = NOW();
		SET @unit_id = NEW.`product_id`;
		SET @case_id = NEW.`bug_id`;
		SET @case_title = NEW.`short_desc`;
		SET @user_id = NEW.`reporter`;
		SET @assignee_id = NEW.`assigned_to`;
	
	# We insert the event in the notification table
		INSERT INTO `ut_notification_case_new`
			(notification_id
			, `created_datetime`
			, `unit_id`
			, `case_id`
			, `case_title`
			, `user_id`
			, `assignee_id`
			)
			VALUES
			(@notification_id
			, NOW()
			, @unit_id
			, @case_id
			, @case_title
			, @user_id
			, @assignee_id
			)
			;
	
	# We call the Lambda procedure to notify of the change
		CALL `lambda_notification_case_new`(@notification_type
			, @bz_source_table
			, @unique_notification_id
			, @created_datetime
			, @unit_id
			, @case_id
			, @case_title
			, @user_id
			, @assignee_id
			)
			;
END */$$


DELIMITER ;

/* Trigger structure for table `bugs` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `update_the_log_of_closed_cases` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `update_the_log_of_closed_cases` AFTER UPDATE ON `bugs` FOR EACH ROW 
  BEGIN
    IF NEW.`bug_status` <> OLD.`bug_status` 
		THEN
		# Capture the new bug status
			SET @new_bug_status = NEW.`bug_status`;
			SET @old_bug_status = OLD.`bug_status`;
		
		# Check if the new bug status is open
			SET @new_is_open = (SELECT `is_open` FROM `bug_status` WHERE `value` = @new_bug_status);
			
		# Check if the old bug status is open
			SET @old_is_open = (SELECT `is_open` FROM `bug_status` WHERE `value` = @old_bug_status);
			
		# If these are different, then we need to update the log of closed cases
			IF @new_is_open != @old_is_open
				THEN
				CALL `update_log_count_closed_case`;
			END IF;
    END IF;
END */$$


DELIMITER ;

/* Trigger structure for table `bugs` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `ut_prepare_message_case_assigned_updated` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `ut_prepare_message_case_assigned_updated` AFTER UPDATE ON `bugs` FOR EACH ROW 
BEGIN
	# We only do that if the assignee has changed
	IF NEW.`assigned_to` != OLD.`assigned_to`
	THEN 
		# Clean Slate: make sure all the variables we use are properly flushed first
			SET @notification_type = NULL;
			SET @bz_source_table = NULL;
			SET @notification_id = NULL;
			SET @unique_notification_id = NULL;
			SET @created_datetime = NULL;
			SET @unit_id = NULL;
			SET @case_id = NULL;
			SET @case_title = NULL;
			SET @invitor_user_id = NULL;
			SET @assignee_user_id = NULL;

		# We have a clean slate, define the variables now
			SET @notification_type = 'case_assignee_updated';
			SET @bz_source_table = 'ut_notification_case_assignee';
			SET @notification_id = ((SELECT MAX(`notification_id`) FROM `ut_notification_case_assignee`) + 1);
			SET @unique_notification_id = (CONCAT(@bz_source_table, '-', @notification_id));
			SET @created_datetime = NOW();
			SET @unit_id = NEW.`product_id`;
			SET @case_id = NEW.`bug_id`;
			SET @case_title = (SELECT `short_desc` FROM `bugs` WHERE `bug_id` = @case_id);
			SET @invitor_user_id = 0;
			SET @assignee_user_id = NEW.`assigned_to`;
		
		# We insert the event in the relevant notification table
			INSERT INTO `ut_notification_case_assignee`
				(`notification_id`
				, `created_datetime`
				, `unit_id`
				, `case_id`
				, `case_title`
				, `invitor_user_id`
				, `assignee_user_id`
				)
				VALUES
				(@notification_id
				, @created_datetime
				, @unit_id
				, @case_id
				, @case_title
				, @invitor_user_id
				, @assignee_user_id
				)
				;
			
		# We call the Lambda procedure to notify of the change
			CALL `lambda_notification_case_assignee_updated`(@notification_type
				, @bz_source_table
				, @unique_notification_id
				, @created_datetime
				, @unit_id
				, @case_id
				, @case_title
				, @invitor_user_id
				, @assignee_user_id
				)
				;
	END IF;
END */$$


DELIMITER ;

/* Trigger structure for table `bugs_activity` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `ut_prepare_message_case_activity` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `ut_prepare_message_case_activity` AFTER INSERT ON `bugs_activity` FOR EACH ROW 
BEGIN
	# Clean Slate: make sure all the variables we use are properly flushed first
		SET @notification_type = NULL;
		SET @bz_source_table = NULL;
		SET @notification_id = NULL;
		SET @unique_notification_id = NULL;
		SET @created_datetime = NULL;
		SET @unit_id = NULL;
		SET @case_id = NULL;
		SET @case_title = NULL;
		SET @user_id = NULL;
		SET @update_what = NULL;

	# We have a clean slate, define the variables now
		SET @notification_type = 'case_updated';
		SET @bz_source_table = 'ut_notification_case_updated';
		SET @notification_id = ((SELECT MAX(`notification_id`) FROM `ut_notification_case_updated`) + 1);
		SET @unique_notification_id = (CONCAT(@bz_source_table, '-', @notification_id));
		SET @created_datetime = NOW();
		SET @unit_id = (SELECT `product_id` FROM `bugs` WHERE `bug_id` = NEW.`bug_id`);
		SET @case_id = NEW.`bug_id`;
		SET @case_title = (SELECT `short_desc` FROM `bugs` WHERE `bug_id` = @case_id);
		SET @user_id = NEW.`who`;
		SET @update_what = (SELECT `description` FROM `fielddefs` WHERE `id` = NEW.`fieldid`);
	
	# We insert the event in the relevant notification table
		INSERT INTO `ut_notification_case_updated`
			(notification_id
			, `created_datetime`
			, `unit_id`
			, `case_id`
			, `case_title`
			, `user_id`
			, `update_what`
			)
			VALUES
			(@notification_id
			, NOW()
			, @unit_id
			, @case_id
			, @case_title
			, @user_id
			, @update_what
			)
			;
		
	# We call the Lambda procedure to notify of the change
		CALL `lambda_notification_case_updated`(@notification_type
			, @bz_source_table
			, @unique_notification_id
			, @created_datetime
			, @unit_id
			, @case_id
			, @case_title
			, @user_id
			, @update_what
			)
			;
END */$$


DELIMITER ;

/* Trigger structure for table `cc` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `ut_prepare_message_case_invited` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `ut_prepare_message_case_invited` AFTER INSERT ON `cc` FOR EACH ROW 
BEGIN
	# Clean Slate: make sure all the variables we use are properly flushed first
		SET @notification_type = NULL;
		SET @bz_source_table = NULL;
		SET @notification_id = NULL;
		SET @unique_notification_id = NULL;
		SET @created_datetime = NULL;
		SET @unit_id = NULL;
		SET @case_id = NULL;
		SET @case_title = NULL;
		SET @invitee_user_id = NULL;

	# We have a clean slate, define the variables now
		SET @notification_type = 'case_user_invited';
		SET @bz_source_table = 'ut_notification_case_invited';
		SET @notification_id = ((SELECT MAX(`notification_id`) FROM `ut_notification_case_invited`) + 1);
		SET @unique_notification_id = (CONCAT(@bz_source_table, '-', @notification_id));
		SET @created_datetime = NOW();
		SET @case_id = NEW.`bug_id`;
		SET @case_title = (SELECT `short_desc` FROM `bugs` WHERE `bug_id` = @case_id);
		SET @unit_id = (SELECT `product_id` FROM `bugs` WHERE `bug_id` = @case_id);
		SET @invitee_user_id = NEW.`who`;

	# We insert the event in the relevant notification table		
		INSERT INTO `ut_notification_case_invited`
			(`notification_id`
			, `created_datetime`
			, `unit_id`
			, `case_id`
			, `case_title`
			, `invitee_user_id`
			)
			VALUES
			(@notification_id
			, @created_datetime
			, @unit_id
			, @case_id
			, @case_title
			, @invitee_user_id
			)
			;
		
	# We call the Lambda procedure to notify of the change
		CALL `lambda_notification_case_invited`(@notification_type
			, @bz_source_table
			, @unique_notification_id
			, @created_datetime
			, @unit_id
			, @case_id
			, @case_title
			, @invitee_user_id
			)
			;
END */$$


DELIMITER ;

/* Trigger structure for table `longdescs` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `ut_prepare_message_new_comment` */$$

/*!50003 CREATE */ /*!50003 TRIGGER `ut_prepare_message_new_comment` AFTER INSERT ON `longdescs` FOR EACH ROW 
BEGIN
	# Clean Slate: make sure all the variables we use are properly flushed first
		SET @notification_type = NULL;
		SET @bz_source_table = NULL;
		SET @notification_id = NULL;
		SET @unique_notification_id = NULL;
		SET @created_datetime = NULL;
		SET @unit_id = NULL;
		SET @case_id = NULL;
		SET @case_title = NULL;
		SET @user_id = NULL;
		SET @message_truncated = NULL;

	# We have a clean slate, define the variables now
		SET @notification_type = 'case_new_message';
		SET @bz_source_table = 'ut_notification_message_new';
		SET @notification_id = ((SELECT MAX(`notification_id`) FROM `ut_notification_message_new`) + 1);
		SET @unique_notification_id = (CONCAT(@bz_source_table, '-', @notification_id));
		SET @created_datetime = NOW();
		SET @unit_id = (SELECT `product_id` FROM `bugs` WHERE `bug_id` = NEW.`bug_id`);
		SET @case_id = NEW.`bug_id`;
		SET @case_title = (SELECT `short_desc` FROM `bugs` WHERE `bug_id` = @case_id);
		SET @user_id = NEW.`who`;
		SET @message_truncated = NEW.`thetext`;
		
	# We insert the event in the relevant notification table
		INSERT INTO `ut_notification_message_new`
			(notification_id
			, `created_datetime`
			, `unit_id`
			, `case_id`
			, `case_title`
			, `user_id`
			, `message_truncated`
			)
			VALUES
			(@notification_id
			, @created_datetime
			, @unit_id
			, @case_id
			, @case_title
			, @user_id
			, @message_truncated
			)
			;

########
#
# WARNING! WE HAVE AN ISSUE THERE IF WE TRIGGER THIS TOGETHER WITH CASE CREATION IT FAILS!...
#
#########
		
	# We call the Lambda procedure to notify of the change
#		CALL `lambda_notification_message_new`(@notification_type
#			, @bz_source_table
#			, @unique_notification_id
#			, @created_datetime
#			, @unit_id
#			, @case_id
#			, @case_title
#			, @user_id
#			, @message_truncated
#			)
#			;
END */$$


DELIMITER ;

/* Procedure structure for procedure `add_invitee_in_cc` */

/*!50003 DROP PROCEDURE IF EXISTS  `add_invitee_in_cc` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `add_invitee_in_cc`()
    SQL SECURITY INVOKER
BEGIN
	IF (@add_invitee_in_cc = 1)
	THEN
	# We make the user in CC for this case:
		INSERT INTO `cc`
			(`bug_id`
			,`who`
			) 
			VALUES 
			(@bz_case_id,@bz_user_id);
		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - add_invitee_in_cc';
			SET @timestamp = NOW();			
			
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
										, @bz_user_id
										, ' is added as CC for the case #'
										, @bz_case_id
										)
										;
				
			INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;
	# Record the change in the Bug history
	# The old value for the audit will always be '' as this is the first time that this user
	# is involved in this case in that unit.
		# We need the invitee login name:
			SET @invitee_login_name = (SELECT `login_name` FROM `profiles` WHERE `userid` = @bz_user_id);
		
		# We can now update the bug activity
			INSERT INTO	`bugs_activity`
				(`bug_id` 
				, `who` 
				, `bug_when`
				, `fieldid`
				, `added`
				, `removed`
				)
				VALUES
				(@bz_case_id
				, @creator_bz_id
				, @timestamp
				, 22
				, @invitee_login_name
				, ''
				)
				;
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the case histoy for case #'
										, @bz_case_id
										, ' has been updated. new user: '
										, @invitee_login_name
										, ' was added in CC to the case.'
										)
										;
				
			INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(@timestamp, @script, @script_log_message)
					;
		# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @script = NULL;
				SET @timestamp = NULL;
END IF ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `are_users_agent` */

/*!50003 DROP PROCEDURE IF EXISTS  `are_users_agent` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `are_users_agent`()
    SQL SECURITY INVOKER
BEGIN
	IF (@id_role_type = 5)
	THEN 
		# Get the information about the group which grant this permission
			SET @group_id_are_users_agent = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 22 
					AND `role_type_id` = 5)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_are_users_agent, 0, 0)
				;
		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - are_users_agent';
			SET @timestamp = NOW();
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' is an agent for the unit #'
									, @product_id
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;
		# We log what we have just done into the `ut_audit_log` table
				
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'is an agent.';
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_are_users_agent, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `are_users_contractor` */

/*!50003 DROP PROCEDURE IF EXISTS  `are_users_contractor` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `are_users_contractor`()
    SQL SECURITY INVOKER
BEGIN
	IF (@id_role_type = 3)
	THEN 
		# Get the information about the group which grant this permission
			SET @group_id_are_users_contractor = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 22 
					AND `role_type_id` = 3)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_are_users_contractor, 0, 0)
				;
		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - are_users_contractor';
			SET @timestamp = NOW();
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' is a contractor for the unit #'
									, @product_id
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;
		# We log what we have just done into the `ut_audit_log` table
				
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'is a contractor.';
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_are_users_contractor, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @bzfe_table = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @permission_granted = NULL;
END IF ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `are_users_landlord` */

/*!50003 DROP PROCEDURE IF EXISTS  `are_users_landlord` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `are_users_landlord`()
    SQL SECURITY INVOKER
BEGIN
	IF (@id_role_type = 2)
	THEN 
		# Get the information about the group which grant this permission
			SET @group_id_are_users_landlord = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 22 
					AND `role_type_id` = 2)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_are_users_landlord, 0, 0)
				;
		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - are_users_landlord';
			SET @timestamp = NOW();
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' is a landlord for the unit #'
									, @product_id
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;
		# We log what we have just done into the `ut_audit_log` table
			
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'is an landlord.';
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
			 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
			 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_are_users_landlord, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
			 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
			 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
			;
 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `are_users_mgt_cny` */

/*!50003 DROP PROCEDURE IF EXISTS  `are_users_mgt_cny` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `are_users_mgt_cny`()
    SQL SECURITY INVOKER
BEGIN
	IF (@id_role_type = 4)
	THEN 
		# Get the information about the group which grant this permission
			SET @group_id_are_users_mgt_cny = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 22 
					AND `role_type_id` = 4)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_are_users_mgt_cny, 0, 0)
				;
		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - are_users_mgt_cny';
			SET @timestamp = NOW();
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' is a Mgt Cny for the unit #'
									, @product_id
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;
		# We log what we have just done into the `ut_audit_log` table
				
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'is a Mgt Cny.';
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_are_users_mgt_cny, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
			 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `can_approve_all_flags` */

/*!50003 DROP PROCEDURE IF EXISTS  `can_approve_all_flags` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `can_approve_all_flags`()
    SQL SECURITY INVOKER
BEGIN
	IF (@can_approve_all_flags = 1)
	THEN 
		# Get the information about the group which grant this permission
			SET @all_g_flags_group_id = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 19)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES
				(@bz_user_id, @all_g_flags_group_id, 0, 0)
				;
		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - can_approve_all_flags';
			SET @timestamp = NOW();
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' CAN approve for all flags.'
									, @product_id
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;
		# We log what we have just done into the `ut_audit_log` table
			
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = ' CAN approve for all flags.';
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @all_g_flags_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `can_ask_to_approve_flags` */

/*!50003 DROP PROCEDURE IF EXISTS  `can_ask_to_approve_flags` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `can_ask_to_approve_flags`()
    SQL SECURITY INVOKER
BEGIN
	IF (@can_ask_to_approve_flags = 1)
	THEN 
		# Get the information about the group which grant this permission
			SET @all_r_flags_group_id = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 18)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES
				(@bz_user_id, @all_r_flags_group_id, 0, 0)
				;
		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - can_ask_to_approve_flags';
			SET @timestamp = NOW();
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' CAN ask for approval for all flags.'
									, @product_id
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;
		# We log what we have just done into the `ut_audit_log` table
		
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = ' CAN ask for approval for all flags.';
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @all_r_flags_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;	
END IF ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `can_create_new_cases` */

/*!50003 DROP PROCEDURE IF EXISTS  `can_create_new_cases` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `can_create_new_cases`()
    SQL SECURITY INVOKER
BEGIN
	IF (@can_create_new_cases = 1)
	THEN 
		# Get the information about the group which grant this permission
			SET @create_case_group_id =  (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 20)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				# There can be cases when a user is only allowed to see existing cases but NOT create new one.
				# This is an unlikely scenario, but this is technically possible...
				(@bz_user_id, @create_case_group_id, 0, 0)
				;
		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - can_create_new_cases';
			SET @timestamp = NOW();
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' CAN create new cases for unit '
									, @product_id
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;
			# We log what we have just done into the `ut_audit_log` table
			
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'create a new case.';
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `can_create_shared_queries` */

/*!50003 DROP PROCEDURE IF EXISTS  `can_create_shared_queries` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `can_create_shared_queries`()
    SQL SECURITY INVOKER
BEGIN
	# This should not change, it was hard coded when we created Unee-T
		# Can create shared queries
		SET @can_create_shared_queries_group_id = 17;
	IF (@can_create_shared_queries = 1)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id,@can_create_shared_queries_group_id,0,0)
				;
		# We record the name of this procedure for future debugging and audit_log`
				SET @script = 'PROCEDURE - can_create_shared_queries';
				SET @timestamp = NOW();
			
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' CAN create shared queries.'
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
					)
				VALUES
				(@timestamp, @script, @script_log_message)
				;
		# We log what we have just done into the `ut_audit_log` table
			SET @bzfe_table = 'ut_user_group_map_temp';
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to create shared queries')
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @can_create_shared_queries_group_id, @script, 'Add the BZ group id when we grant the permission to create shared queries')
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant create shared queries permission')
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group create shared queries')
				 ;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
END IF ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `can_edit_all_field_in_a_case_regardless_of_role` */

/*!50003 DROP PROCEDURE IF EXISTS  `can_edit_all_field_in_a_case_regardless_of_role` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `can_edit_all_field_in_a_case_regardless_of_role`()
    SQL SECURITY INVOKER
BEGIN
	IF (@can_edit_all_field_in_a_case_regardless_of_role = 1)
	THEN 
		# Get the information about the group which grant this permission
			SET @can_edit_all_field_case_group_id = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 26)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @can_edit_all_field_case_group_id, 0, 0)	
				;
		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - can_edit_all_field_in_a_case_regardless_of_role';
			SET @timestamp = NOW();
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' can edit all fields in the case regardless of his/her role for the unit#'
									, @product_id
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;
			# We log what we have just done into the `ut_audit_log` table
			
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'Can edit all fields in the case regardless of his/her role.';
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @can_edit_all_field_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `can_edit_a_case` */

/*!50003 DROP PROCEDURE IF EXISTS  `can_edit_a_case` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `can_edit_a_case`()
    SQL SECURITY INVOKER
BEGIN
	IF (@can_edit_a_case = 1)
	THEN 
		# Get the information about the group which grant this permission
			SET @can_edit_case_group_id = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 25)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @can_edit_case_group_id, 0, 0)	
				;
		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - can_edit_a_case';
			SET @timestamp = NOW();
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' CAN edit a case for unit '
									, @product_id
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;
			# We log what we have just done into the `ut_audit_log` table
			
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'edit a case in this unit.';
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @can_edit_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `can_see_all_public_cases` */

/*!50003 DROP PROCEDURE IF EXISTS  `can_see_all_public_cases` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `can_see_all_public_cases`()
    SQL SECURITY INVOKER
BEGIN
	# This allows a user to see the 'public' cases for a given unit.
	# A 'public' case can still only be seen by users in this group!
	# We might NOT want this for employees of a contractor that only need to see the cases IF the case is restricted to
	# the contractor role but NOT if the case is for anyone
	# This is an unlikely scenario, but this is technically possible (ex for technician for a contractor)...
	IF (@can_see_all_public_cases = 1)
	THEN 
		# Get the information about the group which grant this permission
			SET @can_see_cases_group_id = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 28)
				)
				;
				
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @can_see_cases_group_id, 0, 0)	
				;
		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - can_see_all_public_cases';
			SET @timestamp = NOW();
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' CAN see all public cases for unit '
									, @product_id
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;
			# We log what we have just done into the `ut_audit_log` table
			
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'see all public case in this unit.';
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_cases_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `can_see_time_tracking` */

/*!50003 DROP PROCEDURE IF EXISTS  `can_see_time_tracking` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `can_see_time_tracking`()
    SQL SECURITY INVOKER
BEGIN
	# This should not change, it was hard coded when we created Unee-T
		# See time tracking
		SET @can_see_time_tracking_group_id = 16;
	IF (@can_see_time_tracking = 1)
	THEN INSERT  INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id,@can_see_time_tracking_group_id,0,0)
				;
		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - can_see_time_tracking';
			SET @timestamp = NOW();
			
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' CAN See time tracking information.'
									);
		
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;
			# We log what we have just done into the `ut_audit_log` table
			
			SET @bzfe_table = 'ut_user_group_map_temp';
			
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to see time tracking')
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_time_tracking_group_id, @script, 'Add the BZ group id when we grant the permission to see time tracking')
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant see time tracking permission')
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group see time tracking')
				 ;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
END IF ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `can_see_unit_in_search` */

/*!50003 DROP PROCEDURE IF EXISTS  `can_see_unit_in_search` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `can_see_unit_in_search`()
    SQL SECURITY INVOKER
BEGIN
	IF (@can_see_unit_in_search = 1)
	THEN 
		# Get the information about the group which grant this permission
			SET @can_see_unit_in_search_group_id = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 38)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @can_see_unit_in_search_group_id, 0, 0)	
				;
		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - can_see_unit_in_search';
			SET @timestamp = NOW();
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' can see the unit#'
									, @product_id
									, ' in the search panel.'
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;
		# We log what we have just done into the `ut_audit_log` table
			
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'Can see the unit in the Search panel.';
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_unit_in_search_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `can_tag_comment` */

/*!50003 DROP PROCEDURE IF EXISTS  `can_tag_comment` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `can_tag_comment`()
    SQL SECURITY INVOKER
BEGIN
	# This should not change, it was hard coded when we created Unee-T
		# Can tag comments
		SET @can_tag_comment_group_id = 18;		
	IF (@can_tag_comment = 1)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id,@can_tag_comment_group_id,0,0)
				;
		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - can_tag_comment';
			SET @timestamp = NOW();
				
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' CAN tag comments.'
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;
			# We log what we have just done into the `ut_audit_log` table
			
			SET @bzfe_table = 'ut_user_group_map_temp';
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to tag comments')
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @can_tag_comment_group_id, @script, 'Add the BZ group id when we grant the permission to tag comments')
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant tag comments permission')
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group tag comments')
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
END IF ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `capture_id_dummy_user` */

/*!50003 DROP PROCEDURE IF EXISTS  `capture_id_dummy_user` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `capture_id_dummy_user`()
    SQL SECURITY INVOKER
BEGIN
	
	# What is the default dummy user id for this environment?
	# This procedure needs the following objects:
	#	- Table `ut_temp_dummy_users_for_roles`
	#	- @environment
	#
	# This procedure will return the following variables:
	#	- @bz_user_id_dummy_tenant
	#	- @bz_user_id_dummy_landlord
	#	- @bz_user_id_dummy_contractor
	#	- @bz_user_id_dummy_mgt_cny
	#	- @bz_user_id_dummy_agent
	
		# Get the BZ profile id of the dummy users based on the environment variable
			# Tenant 1
				SET @bz_user_id_dummy_tenant = (SELECT `tenant_id` 
											FROM `ut_temp_dummy_users_for_roles` 
											WHERE `environment_id` = @environment)
											;
				# Landlord 2
				SET @bz_user_id_dummy_landlord = (SELECT `landlord_id` 
											FROM `ut_temp_dummy_users_for_roles` 
											WHERE `environment_id` = @environment)
											;
				
			# Contractor 3
				SET @bz_user_id_dummy_contractor = (SELECT `contractor_id` 
											FROM `ut_temp_dummy_users_for_roles` 
											WHERE `environment_id` = @environment)
											;
				
			# Management company 4
				SET @bz_user_id_dummy_mgt_cny = (SELECT `mgt_cny_id` 
											FROM `ut_temp_dummy_users_for_roles` 
											WHERE `environment_id` = @environment)
											;
				
			# Agent 5
				SET @bz_user_id_dummy_agent = (SELECT `agent_id` 
											FROM `ut_temp_dummy_users_for_roles` 
											WHERE `environment_id` = @environment)
											;
END */$$
DELIMITER ;

/* Procedure structure for procedure `change_case_assignee` */

/*!50003 DROP PROCEDURE IF EXISTS  `change_case_assignee` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `change_case_assignee`()
    SQL SECURITY INVOKER
BEGIN
	IF (@change_case_assignee = 1)
	THEN 
	# We capture the current assignee for the case so that we can log what we did
		SET @current_assignee = (SELECT `assigned_to` FROM `bugs` WHERE `bug_id` = @bz_case_id);
		
	# We also need the login name for the previous assignee and the new assignee
		SET @current_assignee_username = (SELECT `login_name` FROM `profiles` WHERE `userid` = @current_assignee);
		
	# We need the login from the user we are inviting to the case
		SET @invitee_login_name = (SELECT `login_name` FROM `profiles` WHERE `userid` = @bz_user_id);
	# We record the name of this procedure for future debugging and audit_log`
		SET @script = 'PROCEDURE - change_case_assignee';
		SET @timestamp = NOW();
		
	# We make the user the assignee for this case:
		UPDATE `bugs`
		SET 
			`assigned_to` = @bz_user_id
			, `delta_ts` = @timestamp
			, `lastdiffed` = @timestamp
		WHERE `bug_id` = @bz_case_id
		;
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
										, @bz_user_id
										, ' is now the assignee for the case #'
										, @bz_case_id
										)
										;
				
			INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(@timestamp, @script, @script_log_message)
					;
		
	# Record the change in the Bug history
		INSERT INTO	`bugs_activity`
			(`bug_id` 
			, `who` 
			, `bug_when`
			, `fieldid`
			, `added`
			, `removed`
			)
			VALUES
			(@bz_case_id
			, @creator_bz_id
			, @timestamp
			, 16
			, @invitee_login_name
			, @current_assignee_username
			)
			;
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the case histoy for case #'
										, @bz_case_id
										, ' has been updated: '
										, 'old assignee was: '
										, @current_assignee_username
										, 'new assignee is: '
										, @invitee_login_name
										)
										;
				
			INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(@timestamp, @script, @script_log_message)
					;
			
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @script = NULL;
				SET @timestamp = NULL;
END IF ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `create_temp_table_to_update_permissions` */

/*!50003 DROP PROCEDURE IF EXISTS  `create_temp_table_to_update_permissions` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `create_temp_table_to_update_permissions`()
    SQL SECURITY INVOKER
BEGIN
	# We use a temporary table to make sure we do not have duplicates.
		
		# DELETE the temp table if it exists
		DROP TABLE IF EXISTS `ut_user_group_map_temp`;
		
		# Re-create the temp table
		CREATE TABLE `ut_user_group_map_temp` (
		  `user_id` MEDIUMINT(9) NOT NULL,
		  `group_id` MEDIUMINT(9) NOT NULL,
		  `isbless` TINYINT(4) NOT NULL DEFAULT '0',
		  `grant_type` TINYINT(4) NOT NULL DEFAULT '0'
		) ENGINE=INNODB DEFAULT CHARSET=utf8;
		# Add all the records that exists in the table user_group_map
		INSERT INTO `ut_user_group_map_temp`
			SELECT *
			FROM `user_group_map`;
END */$$
DELIMITER ;

/* Procedure structure for procedure `default_agent_see_users_agent` */

/*!50003 DROP PROCEDURE IF EXISTS  `default_agent_see_users_agent` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `default_agent_see_users_agent`()
    SQL SECURITY INVOKER
BEGIN
	IF (@id_role_type = 5)
	THEN 
		# Get the information about the group which grant this permission
			SET @group_id_see_users_agent = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 37 
					AND `role_type_id` = 5)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_see_users_agent, 0, 0)
				;
		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - default_agent_see_users_agent';
			SET @timestamp = NOW();
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' can see agents for the unit '
									, @product_id
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;
		# We log what we have just done into the `ut_audit_log` table
				
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'can see agents for the unit.';
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_see_users_agent, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
			 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `default_contractor_see_users_contractor` */

/*!50003 DROP PROCEDURE IF EXISTS  `default_contractor_see_users_contractor` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `default_contractor_see_users_contractor`()
    SQL SECURITY INVOKER
BEGIN
	IF (@id_role_type = 3)
	THEN 
		# Get the information about the group which grant this permission
			SET @group_id_see_users_contractor = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 37 
					AND `role_type_id` = 3)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_see_users_contractor, 0, 0)
				;
		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - default_contractor_see_users_contractor';
			SET @timestamp = NOW();
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' can see employee of Contractor for the unit '
									, @product_id
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;
		# We log what we have just done into the `ut_audit_log` table
				
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'can see employee of Contractor for the unit.';
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_see_users_contractor, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @bzfe_table = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @permission_granted = NULL;
END IF ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `default_landlord_see_users_landlord` */

/*!50003 DROP PROCEDURE IF EXISTS  `default_landlord_see_users_landlord` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `default_landlord_see_users_landlord`()
    SQL SECURITY INVOKER
BEGIN
	IF (@id_role_type = 2)
	THEN 
		# Get the information about the group which grant this permission
			SET @group_id_see_users_landlord = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 37 
					AND `role_type_id` = 2)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_see_users_landlord, 0, 0)
				;
		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - default_landlord_see_users_landlord';
			SET @timestamp = NOW();
	
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' can see landlord in the unit '
									, @product_id
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;
		# We log what we have just done into the `ut_audit_log` table
			
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'can see landlord in the unit.';
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_see_users_landlord, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `default_mgt_cny_see_users_mgt_cny` */

/*!50003 DROP PROCEDURE IF EXISTS  `default_mgt_cny_see_users_mgt_cny` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `default_mgt_cny_see_users_mgt_cny`()
    SQL SECURITY INVOKER
BEGIN
	IF (@id_role_type = 4)
	THEN 
		# Get the information about the group which grant this permission
			SET @group_id_see_users_mgt_cny = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 37 
					AND `role_type_id` = 4)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_see_users_mgt_cny, 0, 0)
				;
		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - default_mgt_cny_see_users_mgt_cny';
			SET @timestamp = NOW();
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' can see Mgt Cny for the unit '
									, @product_id
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;
		# We log what we have just done into the `ut_audit_log` table
				
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'can see Mgt Cny for the unit.';
	
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_see_users_mgt_cny, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `default_occupant_can_see_occupant` */

/*!50003 DROP PROCEDURE IF EXISTS  `default_occupant_can_see_occupant` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `default_occupant_can_see_occupant`()
    SQL SECURITY INVOKER
BEGIN
	IF (@is_occupant = 1)
	THEN 
		# Get the information about the group which grant this permission
			SET @group_id_see_users_occupant = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 36)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_see_users_occupant, 0, 0)
				;
		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - default_occupant_can_see_occupant';
			SET @timestamp = NOW();
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
				(@timestamp, @script, @script_log_message)
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_see_users_occupant, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `default_tenant_can_see_tenant` */

/*!50003 DROP PROCEDURE IF EXISTS  `default_tenant_can_see_tenant` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `default_tenant_can_see_tenant`()
    SQL SECURITY INVOKER
BEGIN
	IF (@id_role_type = 1)
	THEN 
		# Get the information about the group which grant this permission
			SET @group_id_see_users_tenant = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 37 
					AND `role_type_id` = 1)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_see_users_tenant, 0, 0)
				;
		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - default_tenant_can_see_tenant';
			SET @timestamp = NOW();
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
								, @bz_user_id
									, ' can see tenant in the unit '
									, @product_id
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;
			# We log what we have just done into the `ut_audit_log` table
			
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'can see tenant in the unit.';
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_see_users_tenant, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
	 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `disable_bugmail` */

/*!50003 DROP PROCEDURE IF EXISTS  `disable_bugmail` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `disable_bugmail`()
    SQL SECURITY INVOKER
BEGIN
	IF (@is_mefe_only_user = 1)
	THEN UPDATE `profiles`
		SET 
			`disable_mail` = 1
		WHERE `userid` = @bz_user_id
		;
		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - disable_bugmail';
			SET @timestamp = NOW();
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' will NOT receive bugmail'
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;
		# We log what we have just done into the `ut_audit_log` table
			
			SET @bzfe_table = 'profiles';
			SET @permission_granted = ' will NOT receive bugmail.';
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
				 (@timestamp ,@bzfe_table, 'disable_mail', 'UNKNOWN', 1, @script, CONCAT('This BZ user id #', @bz_user_id, @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
	
		# Add this information to the BZ `audit_log` table
			INSERT INTO `audit_log`
				(`user_id`
				, `class`
				, `object_id`
				, `field`
				, `removed`
				, `added`
				, `at_time`
				)
				VALUES
				(@creator_bz_id
				, 'Bugzilla::User'
				, @bz_user_id
				, 'disable_mail'
				, '1'
				, '0'
				, @timestamp
				)
				;
		# Log the actions of the script.
			SET @script_log_message = CONCAT('Update profile activity for user #'
									, @bz_user_id
									);
				
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `finalize_invitation_to_a_case` */

/*!50003 DROP PROCEDURE IF EXISTS  `finalize_invitation_to_a_case` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `finalize_invitation_to_a_case`()
    SQL SECURITY INVOKER
BEGIN
	
	# Add a comment to inform users that the invitation has been processed.
	# WARNING - This should happen AFTER the invitation is processed in the MEFE API.
	# We record the name of this procedure for future debugging and audit_log`
		SET @script = 'PROCEDURE - finalize_invitation_to_a_case';
		SET @timestamp = NOW();
	
	# We add a new comment to the case.
		INSERT INTO `longdescs`
			(`bug_id`
			, `who`
			, `bug_when`
			, `thetext`
			)
			VALUES
			(@bz_case_id
			, @creator_bz_id
			, @timestamp
			, CONCAT ('An invitation to collaborate on this case has been sent to the '
				, @user_role_type_name 
				, ' for this unit'
				)
			)
			;
		# Log the actions of the script.
			SET @script_log_message = CONCAT('A message has been added to the case #'
										, @bz_case_id
										, ' to inform users that inviation has been sent'
										)
										;
				
			INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(@timestamp, @script, @script_log_message)
					;
			
			SET @script_log_message = NULL;
	# Update the table 'ut_data_to_add_user_to_a_case' so that we record what we have done
		INSERT INTO `ut_data_to_add_user_to_a_case`
			( `mefe_invitation_id`
			, `mefe_invitor_user_id`
			, `bzfe_invitor_user_id`
			, `bz_user_id`
			, `bz_case_id`
			, `bz_created_date`
			, `comment`
			)
		VALUES
			(@mefe_invitation_id
			, @mefe_invitor_user_id
			, @creator_bz_id
			, @bz_user_id
			, @bz_case_id
			, @timestamp
			, CONCAT ('inserted in BZ with the script \''
					, @script
					, '\'\r\ '
					, IFNULL(`comment`, '')
					)
			)
			;
END */$$
DELIMITER ;

/* Procedure structure for procedure `is_occupant` */

/*!50003 DROP PROCEDURE IF EXISTS  `is_occupant` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `is_occupant`()
    SQL SECURITY INVOKER
BEGIN
	IF (@is_occupant = 1)
	THEN 
		# Get the information about the group which grant this permission
			SET @group_id_are_users_occupant = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 3)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_are_users_occupant, 0, 0)
				;
		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - is_occupant';
			SET @timestamp = NOW();
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' is an occupant in the unit #'
									, @product_id
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;
		# We log what we have just done into the `ut_audit_log` table
				
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'is an occupant.';
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_are_users_occupant, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `is_tenant` */

/*!50003 DROP PROCEDURE IF EXISTS  `is_tenant` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `is_tenant`()
    SQL SECURITY INVOKER
BEGIN
	IF (@id_role_type = 1)
	THEN 
		# Get the information about the group which grant this permission
			SET @group_id_are_users_tenant = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 22 
					AND `role_type_id` = 1)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_are_users_tenant, 0, 0)
				;
			# We record the name of this procedure for future debugging and audit_log`
				SET @script = 'PROCEDURE - is_tenant';
				SET @timestamp = NOW();
			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user #'
										, @bz_user_id
										, ' is a tenant in the unit #'
										, @product_id
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(@timestamp, @script, @script_log_message)
					;
			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table = 'ut_user_group_map_temp';
				SET @permission_granted = 'is an tenant.';
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
					 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
					 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_are_users_tenant, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
					 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
					 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @script = NULL;
				SET @timestamp = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `lambda_notification_case_assignee_updated` */

/*!50003 DROP PROCEDURE IF EXISTS  `lambda_notification_case_assignee_updated` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `lambda_notification_case_assignee_updated`(
	IN notification_type varchar(255)
	, IN bz_source_table varchar(240)
	, IN notification_id varchar(255)
	, IN created_datetime datetime
	, IN unit_id smallint(6)
	, IN case_id mediumint(9)
	, IN case_title varchar(255)
	, IN invitor_user_id mediumint(9)
	, IN assignee_user_id mediumint(9)
	)
    SQL SECURITY INVOKER
BEGIN
	# https://github.com/unee-t/lambda2sns/blob/master/tests/call-lambda-as-root.sh#L5
	#	- DEV/Staging: 812644853088
	#	- Prod: 192458993663
	#	- Demo: 915001051872
	CALL mysql.lambda_async(CONCAT('arn:aws:lambda:ap-southeast-1:915001051872:function:alambda_simple')
		, CONCAT ('{ '
			, '"notification_type": "', notification_type
			, '", "bz_source_table": "', bz_source_table
			, '", "notification_id": "', notification_id
			, '", "created_datetime" : "', created_datetime
			, '", "unit_id" : "', unit_id
			, '", "case_id" : "', case_id
			, '", "case_title" : "', case_title
			, '", "invitor_user_id" : "', invitor_user_id
			, '", "assignee_user_id" : "', assignee_user_id
			, '"}'
			)
		)
		;
END */$$
DELIMITER ;

/* Procedure structure for procedure `lambda_notification_case_invited` */

/*!50003 DROP PROCEDURE IF EXISTS  `lambda_notification_case_invited` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `lambda_notification_case_invited`(
	IN notification_type varchar(255)
	, IN bz_source_table varchar(240)
	, IN notification_id varchar(255)
	, IN created_datetime datetime
	, IN unit_id smallint(6)
	, IN case_id mediumint(9)
	, IN case_title varchar(255)
	, IN invitee_user_id mediumint(9)
	)
    SQL SECURITY INVOKER
BEGIN
	# https://github.com/unee-t/lambda2sns/blob/master/tests/call-lambda-as-root.sh#L5
	#	- DEV/Staging: 812644853088
	#	- Prod: 192458993663
	#	- Demo: 915001051872
	CALL mysql.lambda_async(CONCAT('arn:aws:lambda:ap-southeast-1:915001051872:function:alambda_simple')
		, CONCAT ('{ '
			, '"notification_type": "', notification_type
			, '", "bz_source_table": "', bz_source_table
			, '", "notification_id": "', notification_id
			, '", "created_datetime" : "', created_datetime
			, '", "unit_id" : "', unit_id
			, '", "case_id" : "', case_id
			, '", "case_title" : "', case_title
			, '", "invitee_user_id" : "', invitee_user_id
			, '"}'
			)
		)
		;
END */$$
DELIMITER ;

/* Procedure structure for procedure `lambda_notification_case_new` */

/*!50003 DROP PROCEDURE IF EXISTS  `lambda_notification_case_new` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `lambda_notification_case_new`(
	IN notification_type varchar(255)
	, IN bz_source_table varchar(240)
	, IN notification_id varchar(255)
	, IN created_datetime datetime
	, IN unit_id smallint(6)
	, IN case_id mediumint(9)
	, IN case_title varchar(255)
	, IN reporter_user_id mediumint(9)
	, IN assignee_user_id mediumint(9)
	)
    SQL SECURITY INVOKER
BEGIN
	# https://github.com/unee-t/lambda2sns/blob/master/tests/call-lambda-as-root.sh#L5
	#	- DEV/Staging: 812644853088
	#	- Prod: 192458993663
	#	- Demo: 915001051872
	CALL mysql.lambda_async(CONCAT('arn:aws:lambda:ap-southeast-1:915001051872:function:alambda_simple')
		, CONCAT ('{ '
			, '"notification_type": "', notification_type
			, '", "bz_source_table": "', bz_source_table
			, '", "notification_id": "', notification_id
			, '", "created_datetime" : "', created_datetime
			, '", "unit_id" : "', unit_id
			, '", "case_id" : "', case_id
			, '", "case_title" : "', case_title
			, '", "reporter_user_id" : "', reporter_user_id
			, '", "assignee_user_id" : "', assignee_user_id
			, '"}'
			)
		)
		;
END */$$
DELIMITER ;

/* Procedure structure for procedure `lambda_notification_case_updated` */

/*!50003 DROP PROCEDURE IF EXISTS  `lambda_notification_case_updated` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `lambda_notification_case_updated`(
	IN notification_type varchar(255)
	, IN bz_source_table varchar(240)
	, IN notification_id varchar(255)
	, IN created_datetime datetime
	, IN unit_id smallint(6)
	, IN case_id mediumint(9)
	, IN case_title varchar(255)
	, IN user_id mediumint(9)
	, IN update_what varchar(255)
	)
    SQL SECURITY INVOKER
BEGIN
	# https://github.com/unee-t/lambda2sns/blob/master/tests/call-lambda-as-root.sh#L5
	#	- DEV/Staging: 812644853088
	#	- Prod: 192458993663
	#	- Demo: 915001051872
	CALL mysql.lambda_async(CONCAT('arn:aws:lambda:ap-southeast-1:915001051872:function:alambda_simple')
		, CONCAT ('{ '
			, '"notification_type": "', notification_type
			, '", "bz_source_table": "', bz_source_table
			, '", "notification_id": "', notification_id
			, '", "created_datetime" : "', created_datetime
			, '", "unit_id" : "', unit_id
			, '", "case_id" : "', case_id
			, '", "case_title" : "', case_title
			, '", "user_id" : "', user_id
			, '", "update_what" : "', update_what
			, '"}'
			)
		)
		;
END */$$
DELIMITER ;

/* Procedure structure for procedure `lambda_notification_message_new` */

/*!50003 DROP PROCEDURE IF EXISTS  `lambda_notification_message_new` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `lambda_notification_message_new`(
	IN notification_type varchar(255)
	, IN bz_source_table varchar(240)
	, IN notification_id varchar(255)
	, IN created_datetime datetime
	, IN unit_id smallint(6)
	, IN case_id mediumint(9)
	, IN case_title varchar(255)
	, IN created_by_user_id mediumint(9)
	, IN message_truncated varchar(255)
	)
    SQL SECURITY INVOKER
BEGIN
	# https://github.com/unee-t/lambda2sns/blob/master/tests/call-lambda-as-root.sh#L5
	#	- DEV/Staging: 812644853088
	#	- Prod: 192458993663
	#	- Demo: 915001051872
	CALL mysql.lambda_async(CONCAT('arn:aws:lambda:ap-southeast-1:915001051872:function:alambda_simple')
		, CONCAT ('{ '
			, '"notification_type": "', notification_type
			, '", "bz_source_table": "', bz_source_table
			, '", "notification_id": "', notification_id
			, '", "created_datetime" : "', created_datetime
			, '", "unit_id" : "', unit_id
			, '", "case_id" : "', case_id
			, '", "case_title" : "', case_title
			, '", "created_by_user_id" : "', created_by_user_id
			, '", "message_truncated" : "', message_truncated
			, '"}'
			)
		)
		;
END */$$
DELIMITER ;

/* Procedure structure for procedure `remove_user_from_default_cc` */

/*!50003 DROP PROCEDURE IF EXISTS  `remove_user_from_default_cc` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `remove_user_from_default_cc`()
    SQL SECURITY INVOKER
BEGIN
	# This procedure needs the following objects
	#	- Variables:
	#		- @bz_user_id : the BZ user id of the user
	#		- @component_id_this_role: The id of the role in the bz table `components`
	#
	# We delete the record in the table that store default CC information
		DELETE
		FROM `component_cc`
			WHERE `user_id` = @bz_user_id
				AND `component_id` = @component_id_this_role
		;
	# We get the product id so we can log this properly
		SET @product_id_for_this_procedure = (SELECT `product_id` FROM `components` WHERE `id` = @component_id_this_role);
	# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - remove_user_from_default_cc';
			SET @timestamp = NOW();
				
	# Log the actions of the script.
		SET @script_log_message = CONCAT('the bz user #'
								, @bz_user_id
								, ' is NOT in Default CC for the component/role '
								, @component_id_this_role
								, ' for the product/unit '
								, @product_id_for_this_procedure
								);
				
		INSERT INTO `ut_script_log`
			(`datetime`
			, `script`
			, `log`
				)
			VALUES
			(@timestamp, @script, @script_log_message)
			;
	# We log what we have just done into the `ut_audit_log` table
		SET @bzfe_table = 'component_cc';
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
			 (@timestamp 
			,@bzfe_table
			, 'n/a'
			, CONCAT ('user_id: '
				, @bz_user_id
				, ' component_id: '
				,@component_id_this_role 
				)
			, 'n/a'
			, @script
			, 'Remove user from Default CC for this role')
			 ;
	 
	# Cleanup the variables for the log messages
		SET @script_log_message = NULL;
		SET @script = NULL;
		SET @timestamp = NULL;
		SET @bzfe_table = NULL;
		SET @product_id_for_this_procedure = NULL;
END */$$
DELIMITER ;

/* Procedure structure for procedure `remove_user_from_role` */

/*!50003 DROP PROCEDURE IF EXISTS  `remove_user_from_role` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `remove_user_from_role`()
    SQL SECURITY INVOKER
BEGIN
	# This procedure needs the following objects
	#	- Variables:
	#		- @remove_user_from_role
	#		- @component_id_this_role
	#		- @product_id
	#		- @bz_user_id
	#		- @bz_user_id_dummy_user_this_role
	#		- @id_role_type
	# 		- @this_script
	#		- @creator_bz_id
	# We only do this if this is needed:
	IF (@remove_user_from_role = 1)
	THEN
		# The script `invite_a_user_to_a_role_in_a_unit.sql` which call this procedure, already calls: 
		# 	- `table_to_list_dummy_user_by_environment`;
		# 	- `remove_user_from_default_cc`
		# There is no need to do this again
		#
		# The script also reset the permissions for this user for this role for this unit to the default permissions.
		# We need to remove ALL the permissions for this user.
		
			# Create the table to prepare the permissions
				CALL `create_temp_table_to_update_permissions`;
				
			# Revoke all permissions for this user in this unit
				# This procedure needs the following objects:
				#	- Variables:
				#		- @product_id
				#		- @bz_user_id
				CALL `revoke_all_permission_for_this_user_in_this_unit`;
			
			# All the permission have been prepared, we can now update the permissions table
			#		- This NEEDS the table 'ut_user_group_map_temp'
				CALL `update_permissions_invited_user`;
		# Who are the initial owner and initialqa contact for this role?
												
			# Get the old values so we can 
			#	- Check if these are default user for this environment
			#	- log those
				SET @old_component_initialowner = (SELECT `initialowner`
					FROM `components` 
					WHERE `id` = @component_id_this_role)
					;
					
				SET @old_component_initialqacontact = (SELECT `initialqacontact` 
					FROM `components` 
					WHERE `id` = @component_id_this_role)
					;
					
				SET @old_component_description = (SELECT `description` 
					FROM `components` 
					WHERE `id` = @component_id_this_role)
					;
		
		# We need to check if the user we are removing is the current default user for this role for this unit.
			SET @is_user_default_assignee = IF(@old_component_initialowner = @bz_user_id
				, '1'
				, '0'
				)
				;
		# We need to check if the user we are removing is the current qa user for this role for this unit.
			SET @is_user_qa = IF(@old_component_initialqacontact = @bz_user_id
				, '1'
				, '0'
				)
				;
										
		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - remove_user_from_role';
			SET @timestamp = NOW();
		IF @is_user_default_assignee = 1
		THEN
		# We need to replace this with the default dummy user
		# The variables needed for this are
		#	- @bz_user_id_dummy_user_this_role
		# 	- @component_id_this_role
		#	- @id_role_type
		# 	- @this_script
		#	- @product_id
		#	- @creator_bz_id
		
			# We define the dummy user role description based on the variable @id_role_type
				SET @dummy_user_role_desc = IF(@id_role_type = 1
					, CONCAT('Generic '
						, (SELECT`role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
						, ' - THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL'
						, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
						, ' TO THIS UNIT'
						)
					, IF(@id_role_type = 2
						, CONCAT('Generic '
							, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
							, ' - THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL'
							, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
							, ' TO THIS UNIT'
							)
						, IF(@id_role_type = 3
							, CONCAT('Generic '
								, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
								, ' - THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL'
								, (SELECT`role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
								, ' TO THIS UNIT'
								)
							, IF(@id_role_type = 4
								, CONCAT('Generic '
									, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
									, ' - THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL'
									, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
									, ' TO THIS UNIT'
									)
								, IF(@id_role_type = 5
									, CONCAT('Generic '
										, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
										, ' - THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL'
										, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
										, ' TO THIS UNIT'
										)
									, CONCAT('error in script'
										, @this_script
										, 'line 170'
										)
									)
								)
							)
						)
					)
					;
					
			# We define the dummy user public name based on the variable @bz_user_id_dummy_user_this_role
				SET @dummy_user_pub_name = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_user_this_role);
			
			# Update the default assignee
				UPDATE `components`
				SET `initialowner` = @bz_user_id_dummy_user_this_role
					,`description` = @dummy_user_role_desc
					WHERE 
					`id` = @component_id_this_role
					;
			# Log the actions of the script.
				SET @script_log_message = CONCAT('The component: '
					, (SELECT IFNULL(@component_id_this_role, 'component_id_this_role is NULL'))
					, ' (for the role_type_id #'
					, (SELECT IFNULL(@id_role_type, 'id_role_type is NULL'))
					, ') has been updated.'
					, '\r\The default user now associated to this role is the dummy bz user #'
					, (SELECT IFNULL(@bz_user_id_dummy_user_this_role, 'bz_user_id is NULL'))
					, ' (real name: '
					, (SELECT IFNULL(@dummy_user_pub_name, 'user_pub_name is NULL'))
					, ') for the unit #' 
					, @product_id
					);
					
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(@timestamp, @script, @script_log_message)
					;
						
			# We update the BZ logs
				INSERT  INTO `audit_log`
					(`user_id`
					,`class`
					,`object_id`
					,`field`
					,`removed`
					,`added`
					,`at_time`
					) 
					VALUES 
					(@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'initialowner',@old_component_initialowner,@bz_user_id_dummy_user_this_role,@timestamp)
					, (@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'description',@old_component_description,@dummy_user_role_desc,@timestamp)
					;
			# We log what we have just done into the `ut_audit_log` table
				SET @bzfe_table = 'components';
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
					(@timestamp ,@bzfe_table , 'initialowner' , @old_component_initialowner , @bz_user_id_dummy_user_this_role , @script , 'Replace user as default assignee for the role')
					, (@timestamp ,@bzfe_table , 'description' , @old_component_description , @dummy_user_role_desc , @script , 'Change the desription for the role')
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
		END IF;
		IF @is_user_qa = 1
		THEN
		# IF the user is the current qa contact: We need to replace this with the default dummy user
		# The variables needed for this are
		#	- @bz_user_id_dummy_user_this_role
		# 	- @component_id_this_role
		#	- @id_role_type
		# 	- @this_script
		#	- @product_id
		#	- @creator_bz_id
			# We define the dummy user role description based on the variable @id_role_type
				SET @dummy_user_role_desc = IF(@id_role_type = 1
					, CONCAT('Generic '
						, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
						, ' - THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL'
						, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
						, ' TO THIS UNIT'
						)
					, IF(@id_role_type = 2
						, CONCAT('Generic '
							, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
							, ' - THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL'
							, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
							, ' TO THIS UNIT'
							)
						, IF(@id_role_type = 3
							, CONCAT('Generic '
								, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
								, ' - THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL'
								, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
								, ' TO THIS UNIT'
								)
							, IF(@id_role_type = 4
								, CONCAT('Generic '
									, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
									, ' - THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL'
									, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
									, ' TO THIS UNIT'
									)
								, IF(@id_role_type = 5
									, CONCAT('Generic '
										, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
										, ' - THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL'
										, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
										, ' TO THIS UNIT'
										)
									, CONCAT('error in script'
										, @this_script
										, 'line 298'
										)
									)
								)
							)
						)
					)
					;
					
			# We define the dummy user public name based on the variable @bz_user_id_dummy_user_this_role
				SET @dummy_user_pub_name = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_user_this_role);
		
			# Update the default assignee and qa contact
				UPDATE `components`
				SET 
					`initialqacontact` = @bz_user_id_dummy_user_this_role
					WHERE 
					`id` = @component_id_this_role
					;	
			# Log the actions of the script.
				SET @script_log_message = CONCAT('The component: '
					, (SELECT IFNULL(@component_id_this_role, 'component_id_this_role is NULL'))
					, ' (for the role_type_id #'
					, (SELECT IFNULL(@id_role_type, 'id_role_type is NULL'))
					, ') has been updated.'
					, '\r\The QA contact now associated to this role is the dummy bz user #'
					, (SELECT IFNULL(@bz_user_id_dummy_user_this_role, 'bz_user_id is NULL'))
					, ' (real name: '
					, (SELECT IFNULL(@dummy_user_pub_name, 'user_pub_name is NULL'))
					, ') for the unit #' 
					, @product_id
					);
					
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
						)
					VALUES
					(@timestamp, @script, @script_log_message)
					;
						
			# We update the BZ logs
				INSERT  INTO `audit_log`
					(`user_id`
					,`class`
					,`object_id`
					,`field`
					,`removed`
					,`added`
					,`at_time`
					) 
					VALUES 
					(@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'initialqacontact',@old_component_initialqacontact,@bz_user_id_dummy_user_this_role,@timestamp)
					;
			# We log what we have just done into the `ut_audit_log` table
				SET @bzfe_table = 'components';
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
					 (@timestamp ,@bzfe_table , 'initialqacontact' , @old_component_initialqacontact , @bz_user_id_dummy_user_this_role , @script , 'Replace user as default QA for the role')
					 ;
				 
				# Cleanup the variables for the log messages
					SET @script_log_message = NULL;
					SET @bzfe_table = NULL;
		END IF;
		
		# Clean up the variable for the script and timestamp
			SET @script = NULL;
			SET @timestamp = NULL;
	END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `revoke_all_permission_for_this_user_in_this_unit` */

/*!50003 DROP PROCEDURE IF EXISTS  `revoke_all_permission_for_this_user_in_this_unit` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `revoke_all_permission_for_this_user_in_this_unit`()
    SQL SECURITY INVOKER
BEGIN
	# We record the name of this procedure for future debugging and audit_log`
		SET @script = 'PROCEDURE - revoke_all_permission_for_this_user_in_this_unit';
		SET @timestamp = NOW();
		
	# We need to get the group_id for this unit
		SET @can_see_time_tracking_group_id = 16;
		SET @can_create_shared_queries_group_id = 17;
		SET @can_tag_comment_group_id = 18;	
	
		SET @create_case_group_id =  (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 20));
		SET @can_edit_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 25));
		SET @can_see_cases_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 28));
		
		SET @can_edit_all_field_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 26));
		
		SET @can_see_unit_in_search_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 38));
		SET @list_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 4));
		SET @see_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 5));	
		SET @all_r_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 18));
		SET @all_g_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 19));
	
		SET @group_id_show_to_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 24));
		SET @group_id_are_users_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 3));
		SET @group_id_see_users_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 36));
		SET @group_id_show_to_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 1));
		SET @group_id_are_users_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 1));
		SET @group_id_see_users_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 1));
		SET @group_id_show_to_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 2));
		SET @group_id_are_users_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 2));
		SET @group_id_see_users_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 2));
		SET @group_id_show_to_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 5));
		SET @group_id_are_users_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 5));
		SET @group_id_see_users_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 5));
		SET @group_id_show_to_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 3));
		SET @group_id_are_users_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 3));
		SET @group_id_see_users_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 3));
		SET @group_id_show_to_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 4));
		SET @group_id_are_users_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 4));
		SET @group_id_see_users_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 4));
	
	# We can now remove all the permissions for this unit.
		DELETE FROM `ut_user_group_map_temp`
			WHERE (
				(`user_id` = @bz_user_id AND `group_id` = @can_see_time_tracking_group_id)
				OR (`user_id` = @bz_user_id AND `group_id` = @can_create_shared_queries_group_id)
				OR (`user_id` = @bz_user_id AND `group_id` = @can_tag_comment_group_id)
				OR (`user_id` = @bz_user_id AND `group_id` = @create_case_group_id)
				OR (`user_id` = @bz_user_id AND `group_id` = @can_edit_case_group_id)
				OR (`user_id` = @bz_user_id AND `group_id` = @can_see_cases_group_id)
				OR (`user_id` = @bz_user_id AND `group_id` = @can_edit_all_field_case_group_id)
				OR (`user_id` = @bz_user_id AND `group_id` = @can_see_unit_in_search_group_id)
				OR (`user_id` = @bz_user_id AND `group_id` = @list_visible_assignees_group_id)
				OR (`user_id` = @bz_user_id AND `group_id` = @see_visible_assignees_group_id)
				OR (`user_id` = @bz_user_id AND `group_id` = @all_r_flags_group_id)
				OR (`user_id` = @bz_user_id AND `group_id` = @all_g_flags_group_id)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_show_to_occupant)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_are_users_occupant)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_see_users_occupant)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_show_to_tenant)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_are_users_tenant)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_see_users_tenant)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_show_to_landlord)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_are_users_landlord)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_see_users_landlord)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_show_to_agent)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_are_users_agent)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_see_users_agent)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_show_to_contractor)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_are_users_contractor)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_see_users_contractor)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_show_to_mgt_cny)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_are_users_mgt_cny)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_see_users_mgt_cny)
				)
				;
						
			# Log the actions of the script.
				SET @script_log_message = CONCAT('We have revoked all the permissions for the bz user #'
										, @bz_user_id
										, '\r\- can_see_time_tracking: 0'
										, '\r\- can_create_shared_queries: 0'
										, '\r\- can_tag_comment: 0'
										, '\r\- can_create_case: 0'
										, '\r\- can_edit_a_case: 0'
										, '\r\- can_see_cases: 0'
										, '\r\- can_edit_all_field_in_a_case_regardless_of_role: 0'
										, '\r\- can_see_unit_in_search: 0'
										, '\r\- user_can_see_publicly_visible: 0'
										, '\r\- user_is_publicly_visible: 0'
										, '\r\- can_ask_to_approve: 0'
										, '\r\- can_approve: 0'
										, '\r\- show_to_occupant: 0'
										, '\r\- are_users_occupant: 0'
										, '\r\- see_users_occupant: 0'
										, '\r\- show_to_tenant: 0'
										, '\r\- are_users_tenant: 0'
										, '\r\- see_users_tenant: 0'
										, '\r\- show_to_landlord: 0'
										, '\r\- are_users_landlord: 0'
										, '\r\- see_users_landlord: 0'
										, '\r\- show_to_agent: 0'
										, '\r\- are_users_agent: 0'
										, '\r\- see_users_agent: 0'
										, '\r\- show_to_contractor: 0'
										, '\r\- are_users_contractor: 0'
										, '\r\- see_users_contractor: 0'
										, '\r\- show_to_mgt_cny: 0'
										, '\r\- are_users_mgt_cny: 0'
										, '\r\- see_users_mgt_cny: 0'
										, '\r\For the product #'
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
					 (NOW() 
						,@bzfe_table
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id
						, ' the group id = '
						, @can_see_time_tracking_group_id
						, '.')
						)
					 , (NOW() 
						,@bzfe_table
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id
						, ' the group id = '
						, @can_create_shared_queries_group_id
						, '.')
						)
					 , (NOW() 
						,@bzfe_table
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id
						, ' the group id = '
						, @can_tag_comment_group_id
						, '.')
						)
					 , (NOW() 
						,@bzfe_table
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id
						, ' the group id = '
						, (SELECT IFNULL(@create_case_group_id, 'create_case_group_id is NULL'))
						, '.')
						)
					 , (NOW() 
						,@bzfe_table
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id
						, ' the group id = '
						, (SELECT IFNULL(@can_edit_case_group_id, 'can_edit_case_group_id is NULL'))
						, '.')
						)
					 , (NOW() 
						,@bzfe_table
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id
						, ' the group id = '
						, (SELECT IFNULL(@can_see_cases_group_id, 'can_see_cases_group_id is NULL'))
						, '.')
						)
					 , (NOW() 
						,@bzfe_table
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id
						, ' the group id = '
						, (SELECT IFNULL(@can_edit_all_field_case_group_id, 'can_edit_all_field_case_group_id is NULL'))
						, '.')
						)
					 , (NOW() 
						,@bzfe_table
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id
						, ' the group id = '
						, (SELECT IFNULL(@can_see_unit_in_search_group_id, 'can_see_unit_in_search_group_id is NULL'))
						, '.')
						)
					 , (NOW() 
						,@bzfe_table
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id
						, ' the group id = '
						, (SELECT IFNULL(@list_visible_assignees_group_id, 'list_visible_assignees_group_id is NULL'))
						, '.')
						)
					 , (NOW() 
						,@bzfe_table
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id
						, ' the group id = '
						, (SELECT IFNULL(@see_visible_assignees_group_id, 'see_visible_assignees_group_id is NULL'))
						, '.')
						)
					, (NOW() 
						,@bzfe_table
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id
						, ' the group id = '
						, (SELECT IFNULL(@all_r_flags_group_id, 'all_r_flags_group_id is NULL'))
						, '.')
						)
					 , (NOW() 
						,@bzfe_table
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id
						, ' the group id = '
						, (SELECT IFNULL(@all_g_flags_group_id, 'all_g_flags_group_id is NULL'))
						, '.')
						)
					, (NOW() 
						,@bzfe_table
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id
						, ' the group id = '
						, (SELECT IFNULL(@group_id_show_to_occupant, 'group_id_show_to_occupant is NULL'))
						, '.')
						)
					 , (NOW() 
						,@bzfe_table
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id
						, ' the group id = '
						, (SELECT IFNULL(@group_id_are_users_occupant, 'group_id_are_users_occupant is NULL'))
						, '.')
						)
					, (NOW() 
						,@bzfe_table
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id
						, ' the group id = '
						, (SELECT IFNULL(@group_id_see_users_occupant, 'group_id_see_users_occupant is NULL'))
						, '.')
						)
					 , (NOW() 
						,@bzfe_table
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id
						, ' the group id = '
						, (SELECT IFNULL(@group_id_show_to_tenant, 'group_id_show_to_tenant is NULL'))
						, '.')
						)
					, (NOW() 
						,@bzfe_table
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id
						, ' the group id = '
						, (SELECT IFNULL(@group_id_are_users_tenant, 'group_id_are_users_tenant is NULL'))
						, '.')
						)
					 , (NOW() 
						,@bzfe_table
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id
						, ' the group id = '
						, (SELECT IFNULL(@group_id_see_users_tenant, 'group_id_see_users_tenant is NULL'))
						, '.')
						)
					, (NOW() 
						,@bzfe_table
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id
						, ' the group id = '
						, (SELECT IFNULL(@group_id_show_to_landlord, 'group_id_show_to_landlord is NULL'))
						, '.')
						)
					 , (NOW() 
						,@bzfe_table
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id
						, ' the group id = '
						, (SELECT IFNULL(@group_id_are_users_landlord, 'group_id_are_users_landlord is NULL'))
						, '.')
						)
					 , (NOW() 
						,@bzfe_table
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id
						, ' the group id = '
						, (SELECT IFNULL(@group_id_see_users_landlord, 'group_id_see_users_landlord is NULL'))
						, '.')
						)
					 , (NOW() 
						,@bzfe_table
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id
						, ' the group id = '
						, (SELECT IFNULL(@group_id_show_to_agent, 'group_id_show_to_agent is NULL'))
						, '.')
						)
					 , (NOW() 
						,@bzfe_table
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id
						, ' the group id = '
						, (SELECT IFNULL(@group_id_are_users_agent, 'group_id_are_users_agent is NULL'))
						, '.')
						)
					 , (NOW() 
						,@bzfe_table
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id
						, ' the group id = '
						, (SELECT IFNULL(@group_id_see_users_agent, 'group_id_see_users_agent is NULL'))
						, '.')
						)
					 , (NOW() 
						,@bzfe_table
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id
						, ' the group id = '
						, (SELECT IFNULL(@group_id_show_to_contractor, 'group_id_show_to_contractor is NULL'))
						, '.')
						)
					 , (NOW() 
						,@bzfe_table
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id
						, ' the group id = '
						, (SELECT IFNULL(@group_id_are_users_contractor, 'group_id_are_users_contractor is NULL'))
						, '.')
						)
					 , (NOW() 
						,@bzfe_table
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id
						, ' the group id = '
						, (SELECT IFNULL(@group_id_see_users_contractor, 'group_id_see_users_contractor is NULL'))
						, '.')
						)
					 , (NOW() 
						,@bzfe_table
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id
						, ' the group id = '
						, (SELECT IFNULL(@group_id_show_to_mgt_cny, 'group_id_show_to_mgt_cny is NULL'))
						, '.')
						)
					, (NOW() 
						,@bzfe_table
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id
						, ' the group id = '
						, (SELECT IFNULL(@group_id_are_users_mgt_cny, 'group_id_are_users_mgt_cny is NULL'))
						, '.')
						)
					, (NOW() 
						,@bzfe_table
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id
						, ' the group id = '
						, (SELECT IFNULL(@group_id_see_users_mgt_cny, 'group_id_see_users_mgt_cny is NULL'))
						, '.')
						)
					 ;
				 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @script = NULL;
				SET @timestamp = NULL;
				SET @bzfe_table = NULL;
END */$$
DELIMITER ;

/* Procedure structure for procedure `show_to_agent` */

/*!50003 DROP PROCEDURE IF EXISTS  `show_to_agent` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `show_to_agent`()
    SQL SECURITY INVOKER
BEGIN
	IF (@id_role_type = 5)
	THEN 
		# Get the information about the group which grant this permission
			SET @group_id_show_to_agent = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 2 
					AND `role_type_id` = 5)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_show_to_agent, 0, 0)
				;
		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - show_to_agent';
			SET @timestamp = NOW();
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' CAN see case that are limited to agents'
									, ' for the unit #'
									, @product_id
									, '.'
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;
		# We log what we have just done into the `ut_audit_log` table
			
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'CAN see case that are limited to agents.';
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_show_to_agent, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
			 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `show_to_contractor` */

/*!50003 DROP PROCEDURE IF EXISTS  `show_to_contractor` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `show_to_contractor`()
    SQL SECURITY INVOKER
BEGIN
	IF (@id_role_type = 3)
	THEN 
		# Get the information about the group which grant this permission
			SET @group_id_show_to_contractor = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 2 
					AND `role_type_id` = 3)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_show_to_contractor, 0, 0)
				;
		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - show_to_contractor';
			SET @timestamp = NOW();
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' CAN see case that are limited to contractors'
									, ' for the unit #'
									, @product_id
									, '.'
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;
		# We log what we have just done into the `ut_audit_log` table
				
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'CAN see case that are limited to contractors.';
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_show_to_contractor, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `show_to_landlord` */

/*!50003 DROP PROCEDURE IF EXISTS  `show_to_landlord` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `show_to_landlord`()
    SQL SECURITY INVOKER
BEGIN
	IF (@id_role_type = 2)
	THEN 
		# Get the information about the group which grant this permission
			SET @group_id_show_to_landlord = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 2 
					AND `role_type_id` = 2)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_show_to_landlord, 0, 0)
				;
		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - show_to_landlord';
			SET @timestamp = NOW();
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' CAN see case that are limited to landlords'
									, ' for the unit #'
									, @product_id
									, '.'
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;
			# We log what we have just done into the `ut_audit_log` table
			
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'CAN see case that are limited to landlords.';
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_show_to_landlord, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `show_to_mgt_cny` */

/*!50003 DROP PROCEDURE IF EXISTS  `show_to_mgt_cny` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `show_to_mgt_cny`()
    SQL SECURITY INVOKER
BEGIN
	IF (@id_role_type = 4)
	THEN 
		# Get the information about the group which grant this permission
			SET @group_id_show_to_mgt_cny = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 2 
					AND `role_type_id` = 4)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_show_to_mgt_cny, 0, 0)
				;
		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - show_to_mgt_cny';
			SET @timestamp = NOW();
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' CAN see case that are limited to Mgt Cny'
									, ' for the unit #'
									, @product_id
									, '.'
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;
		# We log what we have just done into the `ut_audit_log` table
			
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'CAN see case that are limited to Mgt Cny.';
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_show_to_mgt_cny, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `show_to_occupant` */

/*!50003 DROP PROCEDURE IF EXISTS  `show_to_occupant` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `show_to_occupant`()
    SQL SECURITY INVOKER
BEGIN
	IF (@is_occupant = 1)
	THEN 
		# Get the information about the group which grant this permission
			SET @group_id_show_to_occupant = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
				AND `group_type_id` = 24)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_show_to_occupant, 0, 0)
				;
		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - show_to_occupant';
			SET @timestamp = NOW();
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' CAN see case that are limited to occupants'
									, ' for the unit #'
									, @product_id
									, '.'
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;
		# We log what we have just done into the `ut_audit_log` table
				
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'CAN see case that are limited to occupants.';
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_show_to_occupant, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `show_to_tenant` */

/*!50003 DROP PROCEDURE IF EXISTS  `show_to_tenant` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `show_to_tenant`()
    SQL SECURITY INVOKER
BEGIN
	IF (@id_role_type = 1)
	THEN 
		# Get the information about the group which grant this permission
			SET @group_id_show_to_tenant = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 2 
					AND `role_type_id` = 1)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_show_to_tenant, 0, 0)
				;
			# We record the name of this procedure for future debugging and audit_log`
				SET @script = 'PROCEDURE - show_to_tenant';
				SET @timestamp = NOW();
				
			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user #'
										, @bz_user_id
										, ' CAN see case that are limited to tenants'
										, ' for the unit #'
										, @product_id
										, '.'
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(@timestamp, @script, @script_log_message)
					;
			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table = 'ut_user_group_map_temp';
				SET @permission_granted = 'CAN see case that are limited to tenants.';
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
					 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
					 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_show_to_tenant, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
					 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
					 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @script = NULL;
				SET @timestamp = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `table_to_list_dummy_user_by_environment` */

/*!50003 DROP PROCEDURE IF EXISTS  `table_to_list_dummy_user_by_environment` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `table_to_list_dummy_user_by_environment`()
    SQL SECURITY INVOKER
BEGIN
	# We create a temporary table to record the ids of the dummy users in each environments:
		/*Table structure for table `ut_temp_dummy_users_for_roles` */
			DROP TABLE IF EXISTS `ut_temp_dummy_users_for_roles`;
			CREATE TABLE `ut_temp_dummy_users_for_roles` (
			  `environment_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Id of the environment',
			  `environment_name` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
			  `tenant_id` int(11) NOT NULL,
			  `landlord_id` int(11) NOT NULL,
			  `contractor_id` int(11) NOT NULL,
			  `mgt_cny_id` int(11) NOT NULL,
			  `agent_id` int(11) DEFAULT NULL,
			  PRIMARY KEY (`environment_id`)
			) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
		/*Data for the table `ut_temp_dummy_users_for_roles` */
			INSERT INTO `ut_temp_dummy_users_for_roles`(`environment_id`,`environment_name`,`tenant_id`,`landlord_id`,`contractor_id`,`mgt_cny_id`,`agent_id`) values 
				(1,'DEV/Staging',96,94,93,95,92),
				(2,'Prod',93,91,90,92,89),
				(3,'demo/dev',4,3,5,6,2);
END */$$
DELIMITER ;

/* Procedure structure for procedure `unit_create_with_dummy_users` */

/*!50003 DROP PROCEDURE IF EXISTS  `unit_create_with_dummy_users` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `unit_create_with_dummy_users`()
    SQL SECURITY INVOKER
BEGIN
	# This procedure needs the following variables:
	#	- @mefe_unit_id
	#	- @environment
	#
	# This procedure will create
	#	- The unit
	#	- All the objects needed by the unit
	#		- Milestone
	#		- Version
	# 		- Groups
	#		- Flagtypes
	#		- All 5 roles/components with a dummy user for the relevant environment
	#			- Tenant
	#			- Landlord
	#			- Contractor
	#			- Management Company
	#			- Agent
	#		- Assign the permission so we can do what we need
	#		- Log the group_id that we have created so we can assign permissions later
	#	- Update the Unee-T script log`
	#	- Update the BZ db table `audit_log`
	
	# What is the record that we need to import?
		SET @unit_reference_for_import = (SELECT `id_unit_to_create` FROM `ut_data_to_create_units` WHERE `mefe_unit_id` = @mefe_unit_id);
	
	# We record the name of this procedure for future debugging and audit_log`
		SET @script = 'PROCEDURE - unit_create_with_dummy_users';
		SET @timestamp = NOW();
	# We create a temporary table to record the ids of the dummy users in each environments:
		/*Table structure for table `ut_temp_dummy_users_for_roles` */
			DROP TABLE IF EXISTS `ut_temp_dummy_users_for_roles`;
			CREATE TABLE `ut_temp_dummy_users_for_roles` (
			  `environment_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Id of the environment',
			  `environment_name` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
			  `tenant_id` int(11) NOT NULL,
			  `landlord_id` int(11) NOT NULL,
			  `contractor_id` int(11) NOT NULL,
			  `mgt_cny_id` int(11) NOT NULL,
			  `agent_id` int(11) DEFAULT NULL,
			  PRIMARY KEY (`environment_id`)
			) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
		/*Data for the table `ut_temp_dummy_users_for_roles` */
			INSERT INTO `ut_temp_dummy_users_for_roles`(`environment_id`,`environment_name`,`tenant_id`,`landlord_id`,`contractor_id`,`mgt_cny_id`,`agent_id`) values 
				(1,'DEV/Staging',96,94,93,95,92),
				(2,'Prod',93,91,90,92,89),
				(3,'demo/dev',4,3,5,6,2);
			
	# Get the BZ profile id of the dummy users based on the environment variable
		# Tenant 1
			SET @bz_user_id_dummy_tenant = (SELECT `tenant_id` FROM `ut_temp_dummy_users_for_roles` WHERE `environment_id` = @environment);
		# Landlord 2
			SET @bz_user_id_dummy_landlord = (SELECT `landlord_id` FROM `ut_temp_dummy_users_for_roles` WHERE `environment_id` = @environment);
			
		# Contractor 3
			SET @bz_user_id_dummy_contractor = (SELECT `contractor_id` FROM `ut_temp_dummy_users_for_roles` WHERE `environment_id` = @environment);
			
		# Management company 4
			SET @bz_user_id_dummy_mgt_cny = (SELECT `mgt_cny_id` FROM `ut_temp_dummy_users_for_roles` WHERE `environment_id` = @environment);
			
		# Agent 5
			SET @bz_user_id_dummy_agent = (SELECT `agent_id` FROM `ut_temp_dummy_users_for_roles` WHERE `environment_id` = @environment);
	# The unit:
		# BZ Classification id for the unit that you want to create (default is 2)
		SET @classification_id = (SELECT `classification_id` FROM `ut_data_to_create_units` WHERE `id_unit_to_create` = @unit_reference_for_import);
		# The name and description
		SET @unit_name = (SELECT `unit_name` FROM `ut_data_to_create_units` WHERE `id_unit_to_create` = @unit_reference_for_import);
		SET @unit_description_details = (SELECT `unit_description_details` FROM `ut_data_to_create_units` WHERE `id_unit_to_create` = @unit_reference_for_import);
		SET @unit_description = @unit_description_details;
		
	# The users associated to this unit.	
		# BZ user id of the user that is creating the unit (default is 1 - Administrator).
		# For LMB migration, we use 2 (support.nobody)
		SET @creator_bz_id = (SELECT `bzfe_creator_user_id` FROM `ut_data_to_create_units` WHERE `id_unit_to_create` = @unit_reference_for_import);
		
	# Other important information that should not change:
		SET @visibility_explanation_1 = 'Visible only to ';
		SET @visibility_explanation_2 = ' for this unit.';
	# The global permission for the application
	# This should not change, it was hard coded when we created Unee-T
		# Can tag comments
			SET @can_tag_comment_group_id = 18;	
		
	# We need to create the component for ALL the roles.
	# We do that using dummy users for all the roles different from the user role.	
	#		- agent -> temporary.agent.dev@unee-t.com
	#		- landlord  -> temporary.landlord.dev@unee-t.com
	#		- Tenant  -> temporary.tenant.dev@unee-t.com
	#		- Contractor  -> temporary.contractor.dev@unee-t.com
	# We populate the additional variables that we will need for this script to work
		# For the product
			SET @product_id = ((SELECT MAX(`id`) FROM `products`) + 1);
			
			SET @unit = CONCAT(@unit_name, '-', @product_id);
			
			SET @unit_for_query = REPLACE(@unit,' ','%');
			
			SET @unit_for_flag = REPLACE(@unit_for_query,'%','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'-','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'!','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'@','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'#','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'$','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'%','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'^','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'&','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'*','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'(','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,')','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'+','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'=','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'<','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'>','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,':','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,';','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'"','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,',','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'.','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'?','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'/','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'\\','_');
			
			SET @unit_for_group = REPLACE(@unit_for_flag,'_','-');
			SET @unit_for_group = REPLACE(@unit_for_group,'----','-');
			SET @unit_for_group = REPLACE(@unit_for_group,'---','-');
			SET @unit_for_group = REPLACE(@unit_for_group,'--','-');
			
			SET @default_milestone = '---';
			SET @default_version = '---';
			
	#  We will create all component_id for all the components/roles we need
		# For the temporary users:
			# Tenant
				SET @component_id_tenant = ((SELECT MAX(`id`) FROM `components`) + 1);
				SET @role_user_g_description_tenant = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`= 1);
				SET @user_pub_name_tenant = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_tenant);
				SET @role_user_pub_info_tenant = CONCAT(@user_pub_name_tenant
													,' - '
													, 'THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL '
													, @role_user_g_description_tenant
													, ' TO THIS UNIT'
													);
				SET @user_role_desc_tenant = @role_user_pub_info_tenant;
			# Landlord
				SET @component_id_landlord = (@component_id_tenant + 1);
				SET @role_user_g_description_landlord = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`= 2);
				SET @user_pub_name_landlord = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_landlord);
				SET @role_user_pub_info_landlord = CONCAT(@user_pub_name_landlord
													,' - '
													, 'THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL '
													, @role_user_g_description_landlord
													, ' TO THIS UNIT'
													);
				SET @user_role_desc_landlord = @role_user_pub_info_landlord;
			
			# Agent
				SET @component_id_agent = (@component_id_landlord + 1);
				SET @role_user_g_description_agent = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`= 5);
				SET @user_pub_name_agent = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_agent);
				SET @role_user_pub_info_agent = CONCAT(@user_pub_name_agent
													,' - '
													, 'THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL '
													, @role_user_g_description_agent
													, ' TO THIS UNIT'
													);
				SET @user_role_desc_agent = @role_user_pub_info_agent;
			
			# Contractor
				SET @component_id_contractor = (@component_id_agent + 1);
				SET @role_user_g_description_contractor = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`= 3);
				SET @user_pub_name_contractor = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_contractor);
				SET @role_user_pub_info_contractor = CONCAT(@user_pub_name_contractor
													,' - '
													, 'THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL '
													, @role_user_g_description_contractor
													, ' TO THIS UNIT'
													);
				SET @user_role_desc_contractor = @role_user_pub_info_contractor;
			
			# Management Company
				SET @component_id_mgt_cny = (@component_id_contractor + 1);
				SET @role_user_g_description_mgt_cny = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`= 4);
				SET @user_pub_name_mgt_cny = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_mgt_cny);
				SET @role_user_pub_info_mgt_cny = CONCAT(@user_pub_name_mgt_cny
													,' - '
													, 'THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL '
													, @role_user_g_description_mgt_cny
													, ' TO THIS UNIT'
													);
				SET @user_role_desc_mgt_cny = @role_user_pub_info_mgt_cny;
				
	 SET NAMES utf8 ;
	 SET SQL_MODE='' ;
	 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 ;
	 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 ;
	 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' ;
	 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 ;
	# We now create the unit we need.
		INSERT INTO `products`
			(`id`
			,`name`
			,`classification_id`
			,`description`
			,`isactive`
			,`defaultmilestone`
			,`allows_unconfirmed`
			)
			VALUES
			(@product_id,@unit,@classification_id,@unit_description,1,@default_milestone,1);
		# Log the actions of the script.
			SET @script_log_message = CONCAT('A new unit #'
									, (SELECT IFNULL(@product_id, 'product_id is NULL'))
									, ' ('
									, (SELECT IFNULL(@unit, 'unit is NULL'))
									, ') '
									, ' has been created in the classification: '
									, (SELECT IFNULL(@classification_id, 'classification_id is NULL'))
									, '\r\The bz user #'
									, (SELECT IFNULL(@creator_bz_id, 'creator_bz_id is NULL'))
									, ' (real name: '
									, (SELECT IFNULL(@creator_pub_name, 'creator_pub_name is NULL'))
									, ') '
									, 'is the CREATOR of that unit.'
									)
									;
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(NOW(), @script, @script_log_message)
				;
			
			SET @script_log_message = NULL;
		# We also log this in the `audit_log` table
		
			INSERT INTO `audit_log` 
				(`user_id`
				, `class`
				, `object_id`
				, `field`
				, `removed`
				, `added`
				, `at_time`
				)
				VALUES
				(@creator_bz_id
				, 'Bugzilla::Product'
				, @product_id
				, '__create__'
				, NULL
				, @unit
				, @timestamp
				)
				;
		# We need a version for this product
		
			# What is the next available version id:
				SET @version_id = ((SELECT MAX(`id`) FROM `versions`) + 1);
			
			# We can now insert the version there
				INSERT INTO `versions`
					(`id`
					,`value`
					,`product_id`
					,`isactive`
					)
					VALUES
					(@version_id,@default_version,@product_id,1)
					;
			# We also log this in the `audit_log` table
					
						INSERT INTO `audit_log` 
							(`user_id`
							, `class`
							, `object_id`
							, `field`
							, `removed`
							, `added`
							, `at_time`
							)
							VALUES
							(@creator_bz_id
							, 'Bugzilla::Version'
							, @version_id
							, '__create__'
							, NULL
							, @default_version
							, @timestamp
							)
							;
					
		# We now create the milestone for this product.
		
			# What is the next available milestone id:
				SET @milestone_id = ((SELECT MAX(`id`) FROM `versions`) + 1);
			
			# We can now insert the version there
			INSERT INTO `milestones`
				(`id`
				,`product_id`
				,`value`
				,`sortkey`
				,`isactive`
				)
				VALUES
				(@milestone_id,@product_id,@default_milestone,0,1)
				;			
		
			# We also log this in the `audit_log` table
			
				INSERT INTO `audit_log` 
					(`user_id`
					, `class`
					, `object_id`
					, `field`
					, `removed`
					, `added`
					, `at_time`
					)
					VALUES
					(@creator_bz_id, 'Bugzilla::Milestone', @milestone_id, '__create__', NULL, @default_milestone, @timestamp)
					;
				
	# We create the goups we need
		# For simplicity reason, it is better to create ALL the groups we need for all the possible roles and permissions
		# This will avoid a scenario where we need to grant permission to see occupants for instances but the group for occupants does not exist yet...
		
		# We get the group ids that we will use to do that
		
			# Groups common to all components/roles for this unit
				# Allow user to create a case for this unit
					SET @create_case_group_id = ((SELECT MAX(`id`) FROM `groups`) + 1);
					SET @group_name_create_case_group = (CONCAT(@unit_for_group,'-01-Can-Create-Cases'));
					SET @group_description_create_case_group = 'User can create cases for this unit.';
					
				# Allow user to create a case for this unit
					SET @can_edit_case_group_id = (@create_case_group_id + 1);
					SET @group_name_can_edit_case_group = (CONCAT(@unit_for_group,'-01-Can-Edit-Cases'));
					SET @group_description_can_edit_case_group = 'User can edit a case they have access to';
					
				# Allow user to see the cases for this unit
					SET @can_see_cases_group_id = (@can_edit_case_group_id + 1);
					SET @group_name_can_see_cases_group = (CONCAT(@unit_for_group,'-02-Case-Is-Visible-To-All'));
					SET @group_description_can_see_cases_group = 'User can see the public cases for the unit';
					
				# Allow user to edit all fields in the case for this unit regardless of his/her role
					SET @can_edit_all_field_case_group_id = (@can_see_cases_group_id + 1);
					SET @group_name_can_edit_all_field_case_group = (CONCAT(@unit_for_group,'-03-Can-Always-Edit-all-Fields'));
					SET @group_description_can_edit_all_field_case_group = 'Triage - User can edit all fields in a case they have access to, regardless of role';
					
				# Allow user to edit all the fields in a case, regardless of user role for this unit
					SET @can_edit_component_group_id = (@can_edit_all_field_case_group_id + 1);
					SET @group_name_can_edit_component_group = (CONCAT(@unit_for_group,'-04-Can-Edit-Components'));
					SET @group_description_can_edit_component_group = 'User can edit components/roles for the unit';
					
				# Allow user to see the unit in the search
					SET @can_see_unit_in_search_group_id = (@can_edit_component_group_id + 1);
					SET @group_name_can_see_unit_in_search_group = (CONCAT(@unit_for_group,'-00-Can-See-Unit-In-Search'));
					SET @group_description_can_see_unit_in_search_group = 'User can see the unit in the search panel';
					
			# The groups related to Flags
				# Allow user to  for this unit
					SET @all_g_flags_group_id = (@can_see_unit_in_search_group_id + 1);
					SET @group_name_all_g_flags_group = (CONCAT(@unit_for_group,'-05-Can-Approve-All-Flags'));
					SET @group_description_all_g_flags_group = 'User can approve all flags';
					
				# Allow user to  for this unit
					SET @all_r_flags_group_id = (@all_g_flags_group_id + 1);
					SET @group_name_all_r_flags_group = (CONCAT(@unit_for_group,'-05-Can-Request-All-Flags'));
					SET @group_description_all_r_flags_group = 'User can request a Flag to be approved';
					
				
			# The Groups that control user visibility
				# Allow user to  for this unit
					SET @list_visible_assignees_group_id = (@all_r_flags_group_id + 1);
					SET @group_name_list_visible_assignees_group = (CONCAT(@unit_for_group,'-06-List-Public-Assignee'));
					SET @group_description_list_visible_assignees_group = 'User are visible assignee(s) for this unit';
					
				# Allow user to  for this unit
					SET @see_visible_assignees_group_id = (@list_visible_assignees_group_id + 1);
					SET @group_name_see_visible_assignees_group = (CONCAT(@unit_for_group,'-06-Can-See-Public-Assignee'));
					SET @group_description_see_visible_assignees_group = 'User can see all visible assignee(s) for this unit';
					
			# Other Misc Groups
				# Allow user to  for this unit
					SET @active_stakeholder_group_id = (@see_visible_assignees_group_id + 1);
					SET @group_name_active_stakeholder_group = (CONCAT(@unit_for_group,'-07-Active-Stakeholder'));
					SET @group_description_active_stakeholder_group = 'Users who have a role in this unit as of today (WIP)';
					
				# Allow user to  for this unit
					SET @unit_creator_group_id = (@active_stakeholder_group_id + 1);
					SET @group_name_unit_creator_group = (CONCAT(@unit_for_group,'-07-Unit-Creator'));
					SET @group_description_unit_creator_group = 'User is considered to be the creator of the unit';
					
			# Groups associated to the components/roles
				# For the tenant
					# Visibility group
					SET @group_id_show_to_tenant = (@unit_creator_group_id + 1);
					SET @group_name_show_to_tenant = (CONCAT(@unit_for_group,'-02-Limit-to-Tenant'));
					SET @group_description_tenant = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 1),@visibility_explanation_2));
				
					# Is in tenant user Group
					SET @group_id_are_users_tenant = (@group_id_show_to_tenant + 1);
					SET @group_name_are_users_tenant = (CONCAT(@unit_for_group,'-06-List-Tenant'));
					SET @group_description_are_users_tenant = (CONCAT('list the tenant(s)', @unit));
					
					# Can See tenant user Group
					SET @group_id_see_users_tenant = (@group_id_are_users_tenant + 1);
					SET @group_name_see_users_tenant = (CONCAT(@unit_for_group,'-06-Can-see-Tenant'));
					SET @group_description_see_users_tenant = (CONCAT('See the list of tenant(s) for ', @unit));
			
				# For the Landlord
					# Visibility group 
					SET @group_id_show_to_landlord = (@group_id_see_users_tenant + 1);
					SET @group_name_show_to_landlord = (CONCAT(@unit_for_group,'-02-Limit-to-Landlord'));
					SET @group_description_show_to_landlord = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 2),@visibility_explanation_2));
					
					# Is in landlord user Group
					SET @group_id_are_users_landlord = (@group_id_show_to_landlord + 1);
					SET @group_name_are_users_landlord = (CONCAT(@unit_for_group,'-06-List-landlord'));
					SET @group_description_are_users_landlord = (CONCAT('list the landlord(s)', @unit));
					
					# Can See landlord user Group
					SET @group_id_see_users_landlord = (@group_id_are_users_landlord + 1);
					SET @group_name_see_users_landlord = (CONCAT(@unit_for_group,'-06-Can-see-lanldord'));
					SET @group_description_see_users_landlord = (CONCAT('See the list of lanldord(s) for ', @unit));
					
				# For the agent
					# Visibility group 
					SET @group_id_show_to_agent = (@group_id_see_users_landlord + 1);
					SET @group_name_show_to_agent = (CONCAT(@unit_for_group,'-02-Limit-to-Agent'));
					SET @group_description_show_to_agent = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 5),@visibility_explanation_2));
					
					# Is in Agent user Group
					SET @group_id_are_users_agent = (@group_id_show_to_agent + 1);
					SET @group_name_are_users_agent = (CONCAT(@unit_for_group,'-06-List-agent'));
					SET @group_description_are_users_agent = (CONCAT('list the agent(s)', @unit));
					
					# Can See Agent user Group
					SET @group_id_see_users_agent = (@group_id_are_users_agent + 1);
					SET @group_name_see_users_agent = (CONCAT(@unit_for_group,'-06-Can-see-agent'));
					SET @group_description_see_users_agent = (CONCAT('See the list of agent(s) for ', @unit));
				
				# For the contractor
					# Visibility group 
					SET @group_id_show_to_contractor = (@group_id_see_users_agent + 1);
					SET @group_name_show_to_contractor = (CONCAT(@unit_for_group,'-02-Limit-to-Contractor-Employee'));
					SET @group_description_show_to_contractor = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 3),@visibility_explanation_2));
					
					# Is in contractor user Group
					SET @group_id_are_users_contractor = (@group_id_show_to_contractor + 1);
					SET @group_name_are_users_contractor = (CONCAT(@unit_for_group,'-06-List-contractor-employee'));
					SET @group_description_are_users_contractor = (CONCAT('list the contractor employee(s)', @unit));
					
					# Can See contractor user Group
					SET @group_id_see_users_contractor = (@group_id_are_users_contractor + 1);
					SET @group_name_see_users_contractor = (CONCAT(@unit_for_group,'-06-Can-see-contractor-employee'));
					SET @group_description_see_users_contractor = (CONCAT('See the list of contractor employee(s) for ', @unit));
					
				# For the Mgt Cny
					# Visibility group
					SET @group_id_show_to_mgt_cny = (@group_id_see_users_contractor + 1);
					SET @group_name_show_to_mgt_cny = (CONCAT(@unit_for_group,'-02-Limit-to-Mgt-Cny-Employee'));
					SET @group_description_show_to_mgt_cny = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 4),@visibility_explanation_2));
					
					# Is in mgt cny user Group
					SET @group_id_are_users_mgt_cny = (@group_id_show_to_mgt_cny + 1);
					SET @group_name_are_users_mgt_cny = (CONCAT(@unit_for_group,'-06-List-Mgt-Cny-Employee'));
					SET @group_description_are_users_mgt_cny = (CONCAT('list the Mgt Cny Employee(s)', @unit));
					
					# Can See mgt cny user Group
					SET @group_id_see_users_mgt_cny = (@group_id_are_users_mgt_cny + 1);
					SET @group_name_see_users_mgt_cny = (CONCAT(@unit_for_group,'-06-Can-see-Mgt-Cny-Employee'));
					SET @group_description_see_users_mgt_cny = (CONCAT('See the list of Mgt Cny Employee(s) for ', @unit));
				
				# For the occupant
					# Visibility group
					SET @group_id_show_to_occupant = (@group_id_see_users_mgt_cny + 1);
					SET @group_name_show_to_occupant = (CONCAT(@unit_for_group,'-02-Limit-to-occupant'));
					SET @group_description_show_to_occupant = (CONCAT(@visibility_explanation_1,'Occupants'));
					
					# Is in occupant user Group
					SET @group_id_are_users_occupant = (@group_id_show_to_occupant + 1);
					SET @group_name_are_users_occupant = (CONCAT(@unit_for_group,'-06-List-occupant'));
					SET @group_description_are_users_occupant = (CONCAT('list-the-occupant(s)-', @unit));
					
					# Can See occupant user Group
					SET @group_id_see_users_occupant = (@group_id_are_users_occupant + 1);
					SET @group_name_see_users_occupant = (CONCAT(@unit_for_group,'-06-Can-see-occupant'));
					SET @group_description_see_users_occupant = (CONCAT('See the list of occupant(s) for ', @unit));
					
				# For the people invited by this user:
					# Is in invited_by user Group
					SET @group_id_are_users_invited_by = (@group_id_see_users_occupant + 1);
					SET @group_name_are_users_invited_by = (CONCAT(@unit_for_group,'-06-List-invited-by'));
					SET @group_description_are_users_invited_by = (CONCAT('list the invited_by(s)', @unit));
					
					# Can See users in invited_by user Group
					SET @group_id_see_users_invited_by = (@group_id_are_users_invited_by + 1);
					SET @group_name_see_users_invited_by = (CONCAT(@unit_for_group,'-06-Can-see-invited-by'));
					SET @group_description_see_users_invited_by = (CONCAT('See the list of invited_by(s) for ', @unit));
		# We can populate the 'groups' table now.
			INSERT INTO `groups`
				(`id`
				,`name`
				,`description`
				,`isbuggroup`
				,`userregexp`
				,`isactive`
				,`icon_url`
				) 
				VALUES 
					(@create_case_group_id,@group_name_create_case_group,@group_description_create_case_group,1,'',1,NULL)
					,(@can_edit_case_group_id,@group_name_can_edit_case_group,@group_description_can_edit_case_group,1,'',1,NULL)
					,(@can_see_cases_group_id,@group_name_can_see_cases_group,@group_description_can_see_cases_group,1,'',1,NULL)
					,(@can_edit_all_field_case_group_id,@group_name_can_edit_all_field_case_group,@group_description_can_edit_all_field_case_group,1,'',1,NULL)
					,(@can_edit_component_group_id,@group_name_can_edit_component_group,@group_description_can_edit_component_group,1,'',1,NULL)
					,(@can_see_unit_in_search_group_id,@group_name_can_see_unit_in_search_group,@group_description_can_see_unit_in_search_group,1,'',1,NULL)
					,(@all_g_flags_group_id,@group_name_all_g_flags_group,@group_description_all_g_flags_group,1,'',0,NULL)
					,(@all_r_flags_group_id,@group_name_all_r_flags_group,@group_description_all_r_flags_group,1,'',0,NULL)
					,(@list_visible_assignees_group_id,@group_name_list_visible_assignees_group,@group_description_list_visible_assignees_group,1,'',0,NULL)
					,(@see_visible_assignees_group_id,@group_name_see_visible_assignees_group,@group_description_see_visible_assignees_group,1,'',0,NULL)
					,(@active_stakeholder_group_id,@group_name_active_stakeholder_group,@group_description_active_stakeholder_group,1,'',1,NULL)
					,(@unit_creator_group_id,@group_name_unit_creator_group,@group_description_unit_creator_group,1,'',0,NULL)
					,(@group_id_show_to_tenant,@group_name_show_to_tenant,@group_description_tenant,1,'',1,NULL)
					,(@group_id_are_users_tenant,@group_name_are_users_tenant,@group_description_are_users_tenant,1,'',0,NULL)
					,(@group_id_see_users_tenant,@group_name_see_users_tenant,@group_description_see_users_tenant,1,'',0,NULL)
					,(@group_id_show_to_landlord,@group_name_show_to_landlord,@group_description_show_to_landlord,1,'',1,NULL)
					,(@group_id_are_users_landlord,@group_name_are_users_landlord,@group_description_are_users_landlord,1,'',0,NULL)
					,(@group_id_see_users_landlord,@group_name_see_users_landlord,@group_description_see_users_landlord,1,'',0,NULL)
					,(@group_id_show_to_agent,@group_name_show_to_agent,@group_description_show_to_agent,1,'',1,NULL)
					,(@group_id_are_users_agent,@group_name_are_users_agent,@group_description_are_users_agent,1,'',0,NULL)
					,(@group_id_see_users_agent,@group_name_see_users_agent,@group_description_see_users_agent,1,'',0,NULL)
					,(@group_id_show_to_contractor,@group_name_show_to_contractor,@group_description_show_to_contractor,1,'',1,NULL)
					,(@group_id_are_users_contractor,@group_name_are_users_contractor,@group_description_are_users_contractor,1,'',0,NULL)
					,(@group_id_see_users_contractor,@group_name_see_users_contractor,@group_description_see_users_contractor,1,'',0,NULL)
					,(@group_id_show_to_mgt_cny,@group_name_show_to_mgt_cny,@group_description_show_to_mgt_cny,1,'',1,NULL)
					,(@group_id_are_users_mgt_cny,@group_name_are_users_mgt_cny,@group_description_are_users_mgt_cny,1,'',0,NULL)
					,(@group_id_see_users_mgt_cny,@group_name_see_users_mgt_cny,@group_description_see_users_mgt_cny,1,'',0,NULL)
					,(@group_id_show_to_occupant,@group_name_show_to_occupant,@group_description_show_to_occupant,1,'',1,NULL)
					,(@group_id_are_users_occupant,@group_name_are_users_occupant,@group_description_are_users_occupant,1,'',0,NULL)
					,(@group_id_see_users_occupant,@group_name_see_users_occupant,@group_description_see_users_occupant,1,'',0,NULL)
					,(@group_id_are_users_invited_by,@group_name_are_users_invited_by,@group_description_are_users_invited_by,1,'',0,NULL)
					,(@group_id_see_users_invited_by,@group_name_see_users_invited_by,@group_description_see_users_invited_by,1,'',0,NULL)
					;
			# Log the actions of the script.
				SET @script_log_message = CONCAT('We have created the groups that we will need for that unit #'
										, @product_id
										, '\r\ - To grant '
										, 'case creation'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@create_case_group_id, 'create_case_group_id is NULL'))
										, '\r\ - To grant '
										, 'Edit case'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@can_edit_case_group_id, 'can_edit_case_group_id is NULL'))
										, '\r\ - To grant '
										, 'Edit all field regardless of role'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@can_edit_all_field_case_group_id, 'can_edit_all_field_case_group_id is NULL'))
										, '\r\ - To grant '
										, 'Edit Component/roles'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@can_edit_component_group_id, 'can_edit_component_group_id is NULL'))
										, '\r\ - To grant '
										, 'See unit in the Search panel'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@can_see_unit_in_search_group_id, 'can_see_unit_in_search_group_id is NULL'))
										, '\r\ - To grant '
										, 'See cases'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@can_see_cases_group_id, 'can_see_cases_group_id is NULL'))
										, '\r\ - To grant '
										, 'Request all flags'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@all_r_flags_group_id, 'all_r_flags_group_id is NULL'))
										, '\r\ - To grant '
										, 'Approve all flags'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@all_g_flags_group_id, 'all_g_flags_group_id is NULL'))
										, '\r\ - To grant '
										, 'User is publicly visible'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@list_visible_assignees_group_id, 'list_visible_assignees_group_id is NULL'))
										, '\r\ - To grant '
										, 'User can see publicly visible'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@see_visible_assignees_group_id, 'see_visible_assignees_group_id is NULL'))
										, '\r\ - To grant '
										, 'User is active Stakeholder'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@active_stakeholder_group_id, 'active_stakeholder_group_id is NULL'))
										, '\r\ - To grant '
										, 'User is the unit creator'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@unit_creator_group_id, 'unit_creator_group_id is NULL'))
										, '\r\ - Restrict permission to '
										, 'tenant'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_show_to_tenant, 'group_id_show_to_tenant is NULL'))
										, '\r\ - Group for the '
										, 'tenant'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_are_users_tenant, 'group_id_are_users_tenant is NULL'))
										, '\r\ - Group to see the users '
										, 'tenant'
										, '. Group_id: '
										, (SELECT IFNULL(@group_id_see_users_tenant, 'group_id_see_users_tenant is NULL'))
										
										, '\r\ - Restrict permission to '
										, 'landlord'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_show_to_landlord, 'group_id_show_to_landlord is NULL'))
										, '\r\ - Group for the '
										, 'landlord'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_are_users_landlord, 'group_id_are_users_landlord is NULL'))
										, '\r\ - Group to see the users'
										, 'landlord'
										, '. Group_id: '
										, (SELECT IFNULL(@group_id_see_users_landlord, 'group_id_see_users_landlord is NULL'))
										
										, '\r\ - Restrict permission to '
										, 'agent'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_show_to_agent, 'group_id_show_to_agent is NULL'))
										, '\r\ - Group for the '
										, 'agent'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_are_users_agent, 'group_id_are_users_agent is NULL'))
										, '\r\ - Group to see the users'
										, 'agent'
										, '. Group_id: '
										, (SELECT IFNULL(@group_id_see_users_agent, 'group_id_see_users_agent is NULL'))
										
										, '\r\ - Restrict permission to '
										, 'Contractor'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_show_to_contractor, 'group_id_show_to_contractor is NULL'))
										, '\r\ - Group for the '
										, 'Contractor'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_are_users_contractor, 'group_id_are_users_contractor is NULL'))
										, '\r\ - Group to see the users'
										, 'Contractor'
										, '. Group_id: '
										, (SELECT IFNULL(@group_id_see_users_contractor, 'group_id_see_users_contractor is NULL'))
										
										, '\r\ - Restrict permission to '
										, 'Management Company'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_show_to_mgt_cny, 'group_id_show_to_mgt_cny is NULL'))
										, '\r\ - Group for the users in the '
										, 'Management Company'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_are_users_mgt_cny, 'group_id_are_users_mgt_cny is NULL'))
										, '\r\ - Group to see the users in the '
										, 'Management Company'
										, '. Group_id: '
										, (SELECT IFNULL(@group_id_see_users_mgt_cny, 'group_id_see_users_mgt_cny is NULL'))
										
										, '\r\ - Restrict permission to '
										, 'occupant'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_show_to_occupant, 'group_id_show_to_occupant is NULL'))
										, '\r\ - Group for the '
										, 'occupant'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_are_users_occupant, 'group_id_are_users_occupant is NULL'))
										, '\r\ - Group to see the users '
										, 'occupant'
										, '. Group_id: '
										, (SELECT IFNULL(@group_id_see_users_occupant, 'group_id_see_users_occupant is NULL'))
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;
				
				SET @script_log_message = NULL;				
					
		# We record the groups we have just created:
		#	We NEED the component_id for that
			INSERT INTO `ut_product_group`
				(
				product_id
				,component_id
				,group_id
				,group_type_id
				,role_type_id
				,created_by_id
				,created
				)
				VALUES
				(@product_id,NULL,@create_case_group_id,20,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@can_edit_case_group_id,25,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@can_edit_all_field_case_group_id,26,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@can_edit_component_group_id,27,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@can_see_cases_group_id,28,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@can_see_unit_in_search_group_id,38,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@all_r_flags_group_id,18,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@all_g_flags_group_id,19,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@list_visible_assignees_group_id,4,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@see_visible_assignees_group_id,5,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@active_stakeholder_group_id,29,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@unit_creator_group_id,1,NULL,@creator_bz_id,@timestamp)
				# Tenant (1)
				,(@product_id,@component_id_tenant,@group_id_show_to_tenant,2,1,@creator_bz_id,@timestamp)
				,(@product_id,@component_id_tenant,@group_id_are_users_tenant,22,1,@creator_bz_id,@timestamp)
				,(@product_id,@component_id_tenant,@group_id_see_users_tenant,37,1,@creator_bz_id,@timestamp)
				# Landlord (2)
				,(@product_id,@component_id_landlord,@group_id_show_to_landlord,2,2,@creator_bz_id,@timestamp)
				,(@product_id,@component_id_landlord,@group_id_are_users_landlord,22,2,@creator_bz_id,@timestamp)
				,(@product_id,@component_id_landlord,@group_id_see_users_landlord,37,2,@creator_bz_id,@timestamp)
				# Agent (5)
				,(@product_id,@component_id_agent,@group_id_show_to_agent,2,5,@creator_bz_id,@timestamp)
				,(@product_id,@component_id_agent,@group_id_are_users_agent,22,5,@creator_bz_id,@timestamp)
				,(@product_id,@component_id_agent,@group_id_see_users_agent,37,5,@creator_bz_id,@timestamp)
				# contractor (3)
				,(@product_id,@component_id_contractor,@group_id_show_to_contractor,2,3,@creator_bz_id,@timestamp)
				,(@product_id,@component_id_contractor,@group_id_are_users_contractor,22,3,@creator_bz_id,@timestamp)
				,(@product_id,@component_id_contractor,@group_id_see_users_contractor,37,3,@creator_bz_id,@timestamp)
				# mgt_cny (4)
				,(@product_id,@component_id_mgt_cny,@group_id_show_to_mgt_cny,2,4,@creator_bz_id,@timestamp)
				,(@product_id,@component_id_mgt_cny,@group_id_are_users_mgt_cny,22,4,@creator_bz_id,@timestamp)
				,(@product_id,@component_id_mgt_cny,@group_id_see_users_mgt_cny,37,4,@creator_bz_id,@timestamp)
				# occupant (#)
				,(@product_id,NULL,@group_id_show_to_occupant,24,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@group_id_are_users_occupant,3,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@group_id_see_users_occupant,36,NULL,@creator_bz_id,@timestamp)
				# invited_by
				,(@product_id,NULL,@group_id_are_users_invited_by,31,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@group_id_see_users_invited_by,32,NULL,@creator_bz_id,@timestamp)
				;
				
		# We update the BZ logs
			INSERT INTO `audit_log`
				(`user_id`
				,`class`
				,`object_id`
				,`field`
				,`removed`
				,`added`
				,`at_time`
				) 
				VALUES 
				(@creator_bz_id, 'Bugzilla::Group', @create_case_group_id, '__create__', NULL, @group_name_create_case_group, @timestamp)
				,(@creator_bz_id, 'Bugzilla::Group', @can_edit_case_group_id, '__create__', NULL, @group_name_can_edit_case_group, @timestamp)
				,(@creator_bz_id, 'Bugzilla::Group', @can_edit_all_field_case_group_id, '__create__', NULL, @group_name_can_edit_all_field_case_group, @timestamp)
				,(@creator_bz_id, 'Bugzilla::Group', @can_edit_component_group_id, '__create__', NULL, @group_name_can_edit_component_group, @timestamp)
				,(@creator_bz_id, 'Bugzilla::Group', @can_see_cases_group_id, '__create__', NULL, @group_name_can_see_cases_group, @timestamp)
				,(@creator_bz_id, 'Bugzilla::Group', @can_see_unit_in_search_group_id, '__create__', NULL, @group_name_can_see_unit_in_search_group, @timestamp)
				,(@creator_bz_id, 'Bugzilla::Group', @all_g_flags_group_id, '__create__', NULL, @group_name_all_g_flags_group, @timestamp)
				,(@creator_bz_id, 'Bugzilla::Group', @all_r_flags_group_id, '__create__', NULL, @group_name_all_r_flags_group, @timestamp)
				,(@creator_bz_id, 'Bugzilla::Group', @list_visible_assignees_group_id, '__create__', NULL, @group_name_list_visible_assignees_group, @timestamp)
				,(@creator_bz_id, 'Bugzilla::Group', @see_visible_assignees_group_id, '__create__', NULL, @group_name_see_visible_assignees_group, @timestamp)
				,(@creator_bz_id, 'Bugzilla::Group', @active_stakeholder_group_id, '__create__', NULL, @group_name_active_stakeholder_group, @timestamp)
				,(@creator_bz_id, 'Bugzilla::Group', @unit_creator_group_id, '__create__', NULL, @group_name_unit_creator_group, @timestamp)
				,(@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_tenant, '__create__', NULL, @group_name_show_to_tenant, @timestamp)
				,(@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_tenant, '__create__', NULL, @group_name_are_users_tenant, @timestamp)
				,(@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_tenant, '__create__', NULL, @group_name_see_users_tenant, @timestamp)
				,(@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_landlord, '__create__', NULL, @group_name_show_to_landlord, @timestamp)
				,(@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_landlord, '__create__', NULL, @group_name_are_users_landlord, @timestamp)
				,(@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_landlord, '__create__', NULL, @group_name_see_users_landlord, @timestamp)
				,(@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_agent, '__create__', NULL, @group_name_show_to_agent, @timestamp)
				,(@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_agent, '__create__', NULL, @group_name_are_users_agent, @timestamp)
				,(@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_agent, '__create__', NULL, @group_name_see_users_agent, @timestamp)
				,(@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_contractor, '__create__', NULL, @group_name_show_to_contractor, @timestamp)
				,(@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_contractor, '__create__', NULL, @group_name_are_users_contractor, @timestamp)
				,(@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_contractor, '__create__', NULL, @group_name_see_users_contractor, @timestamp)
				,(@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_mgt_cny, '__create__', NULL, @group_name_show_to_mgt_cny, @timestamp)
				,(@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_mgt_cny, '__create__', NULL, @group_name_are_users_mgt_cny, @timestamp)
				,(@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_mgt_cny, '__create__', NULL, @group_name_see_users_mgt_cny, @timestamp)
				,(@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_occupant, '__create__', NULL, @group_name_show_to_occupant, @timestamp)
				,(@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_occupant, '__create__', NULL, @group_name_are_users_occupant, @timestamp)
				,(@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_occupant, '__create__', NULL, @group_name_see_users_occupant, @timestamp)
				,(@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_invited_by, '__create__', NULL, @group_name_are_users_invited_by, @timestamp)
				,(@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_invited_by, '__create__', NULL, @group_name_see_users_invited_by, @timestamp)
				;
			
	# We now Create the flagtypes and flags for this new unit (we NEEDED the group ids for that!):
		
		# We need to get the flatype id
			SET @flag_next_step = ((SELECT MAX(`id`) FROM `flagtypes`) + 1);
			SET @flag_solution = (@flag_next_step + 1);
			SET @flag_budget = (@flag_solution + 1);
			SET @flag_attachment = (@flag_budget + 1);
			SET @flag_ok_to_pay = (@flag_attachment + 1);
			SET @flag_is_paid = (@flag_ok_to_pay + 1);
		
		# We need to define the name for the flags
			SET @flag_next_step_name = CONCAT('Next_Step_',@unit_for_flag);
			SET @flag_solution_name = CONCAT('Solution_',@unit_for_flag);
			SET @flag_budget_name = CONCAT('Budget_',@unit_for_flag);
			SET @flag_attachment_name = CONCAT('Attachment_',@unit_for_flag);
			SET @flag_ok_to_pay_name = CONCAT('OK_to_pay_',@unit_for_flag);
			SET @flag_is_paid_name = CONCAT('is_paid_',@unit_for_flag);
		# We can now create the flagtypes
			INSERT INTO `flagtypes`
				(`id`
				,`name`
				,`description`
				,`cc_list`
				,`target_type`
				,`is_active`
				,`is_requestable`
				,`is_requesteeble`
				,`is_multiplicable`
				,`sortkey`
				,`grant_group_id`
				,`request_group_id`
				) 
				VALUES 
				(@flag_next_step,@flag_next_step_name ,'Approval for the Next Step of the case.','','b',1,1,1,1,10,@all_g_flags_group_id,@all_r_flags_group_id)
				,(@flag_solution,@flag_solution_name ,'Approval for the Solution of this case.','','b',1,1,1,1,20,@all_g_flags_group_id,@all_r_flags_group_id)
				,(@flag_budget,@flag_budget_name ,'Approval for the Budget for this case.','','b',1,1,1,1,30,@all_g_flags_group_id,@all_r_flags_group_id)
				,(@flag_attachment,@flag_attachment_name ,'Approval for this Attachment.','','a',1,1,1,1,10,@all_g_flags_group_id,@all_r_flags_group_id)
				,(@flag_ok_to_pay,@flag_ok_to_pay_name ,'Approval to pay this bill.','','a',1,1,1,1,20,@all_g_flags_group_id,@all_r_flags_group_id)
				,(@flag_is_paid,@flag_is_paid_name ,'Confirm if this bill has been paid.','','a',1,1,1,1,30,@all_g_flags_group_id,@all_r_flags_group_id)
				;
		# We also define the flag inclusion
			INSERT INTO `flaginclusions`
				(`type_id`
				,`product_id`
				,`component_id`
				) 
				VALUES
				(@flag_next_step,@product_id,NULL)
				,(@flag_solution,@product_id,NULL)
				,(@flag_budget,@product_id,NULL)
				,(@flag_attachment,@product_id,NULL)
				,(@flag_ok_to_pay,@product_id,NULL)
				,(@flag_is_paid,@product_id,NULL)
				;
		# Log the actions of the script.
			SET @script_log_message = CONCAT('We have created the following flags which are restricted to that unit: '
									, '\r\ - Next Step (#'
									, (SELECT IFNULL(@flag_next_step, 'flag_next_step is NULL'))
									, ').'
									, '\r\ - Solution (#'
									, (SELECT IFNULL(@flag_solution, 'flag_solution is NULL'))
									, ').'
									, '\r\ - Budget (#'
									, (SELECT IFNULL(@flag_budget, 'flag_budget is NULL'))
									, ').'
									, '\r\ - Attachment (#'
									, (SELECT IFNULL(@flag_attachment, 'flag_attachment is NULL'))
									, ').'
									, '\r\ - OK to pay (#'
									, (SELECT IFNULL(@flag_ok_to_pay, 'flag_ok_to_pay is NULL'))
									, ').'
									, '\r\ - Is paid (#'
									, (SELECT IFNULL(@flag_is_paid, 'flag_is_paid is NULL'))
									, ').'
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(NOW(), @script, @script_log_message)
				;
		# We update the BZ logs
			INSERT INTO `audit_log`
				(`user_id`
				,`class`
				,`object_id`
				,`field`
				,`removed`
				,`added`
				,`at_time`
				) 
				VALUES 
				(@creator_bz_id, 'Bugzilla::FlagType', @flag_next_step, '__create__', NULL, @flag_next_step_name, @timestamp)
				, (@creator_bz_id, 'Bugzilla::FlagType', @flag_solution, '__create__', NULL, @flag_solution_name, @timestamp)
				, (@creator_bz_id, 'Bugzilla::FlagType', @flag_budget, '__create__', NULL, @flag_budget_name, @timestamp)
				, (@creator_bz_id, 'Bugzilla::FlagType', @flag_attachment, '__create__', NULL, @flag_attachment_name, @timestamp)
				, (@creator_bz_id, 'Bugzilla::FlagType', @flag_ok_to_pay, '__create__', NULL, @flag_ok_to_pay_name, @timestamp)
				, (@creator_bz_id, 'Bugzilla::FlagType', @flag_is_paid, '__create__', NULL, @flag_is_paid_name, @timestamp)
				;
				
		# Cleanup:
			SET @script_log_message = NULL;
			
	# We configure the group permissions:
		# Data for the table `group_group_map`
		# We use a temporary table to do this, this is to avoid duplicate in the group_group_map table
		# DELETE the temp table if it exists
		DROP TABLE IF EXISTS `ut_group_group_map_temp`;
		
		# Re-create the temp table
		CREATE TABLE `ut_group_group_map_temp` (
		  `member_id` MEDIUMINT(9) NOT NULL,
		  `grantor_id` MEDIUMINT(9) NOT NULL,
		  `grant_type` TINYINT(4) NOT NULL DEFAULT 0
		) ENGINE=INNODB DEFAULT CHARSET=utf8;
		# Add the records that exist in the table group_group_map
		INSERT INTO `ut_group_group_map_temp`
			SELECT *
			FROM `group_group_map`;
		
		
		# Add the new records
		INSERT INTO `ut_group_group_map_temp`
			(`member_id`
			,`grantor_id`
			,`grant_type`
			) 
		##########################################################
		# Logic:
		# If you are a member of group_id XXX (ex: 1 / Admin) 
		# then you have the following permissions:
		# 	- 0: You are automatically a member of group ZZZ
		#	- 1: You can grant access to group ZZZ
		#	- 2: You can see users in group ZZZ
		##########################################################
			VALUES 
			# Admin group can grant membership to all
			(1,@create_case_group_id,1)
			,(1,@can_edit_case_group_id,1)
			,(1,@can_see_cases_group_id,1)
			,(1,@can_edit_all_field_case_group_id,1)
			,(1,@can_edit_component_group_id,1)
			,(1,@can_see_unit_in_search_group_id,1)
			,(1,@all_g_flags_group_id,1)
			,(1,@all_r_flags_group_id,1)
			,(1,@list_visible_assignees_group_id,1)
			,(1,@see_visible_assignees_group_id,1)
			,(1,@active_stakeholder_group_id,1)
			,(1,@unit_creator_group_id,1)
			,(1,@group_id_show_to_tenant,1)
			,(1,@group_id_are_users_tenant,1)
			,(1,@group_id_see_users_tenant,1)
			,(1,@group_id_show_to_landlord,1)
			,(1,@group_id_are_users_landlord,1)
			,(1,@group_id_see_users_landlord,1)
			,(1,@group_id_show_to_agent,1)
			,(1,@group_id_are_users_agent,1)
			,(1,@group_id_see_users_agent,1)
			,(1,@group_id_show_to_contractor,1)
			,(1,@group_id_are_users_contractor,1)
			,(1,@group_id_see_users_contractor,1)
			,(1,@group_id_show_to_mgt_cny,1)
			,(1,@group_id_are_users_mgt_cny,1)
			,(1,@group_id_see_users_mgt_cny,1)
			,(1,@group_id_show_to_occupant,1)
			,(1,@group_id_are_users_occupant,1)
			,(1,@group_id_see_users_occupant,1)
			,(1,@group_id_are_users_invited_by,1)
			,(1,@group_id_see_users_invited_by,1)
			
			# Admin MUST be a member of the mandatory group for this unit
			# If not it is impossible to see this product in the BZFE backend.
			,(1,@can_see_unit_in_search_group_id,0)
			# Visibility groups:
			,(@all_r_flags_group_id,@all_g_flags_group_id,2)
			,(@see_visible_assignees_group_id,@list_visible_assignees_group_id,2)
			,(@unit_creator_group_id,@unit_creator_group_id,2)
			,(@group_id_see_users_tenant,@group_id_are_users_tenant,2)
			,(@group_id_see_users_landlord,@group_id_are_users_landlord,2)
			,(@group_id_see_users_agent,@group_id_are_users_contractor,2)
			,(@group_id_see_users_mgt_cny,@group_id_are_users_mgt_cny,2)
			,(@group_id_see_users_occupant,@group_id_are_users_occupant,2)
			,(@group_id_see_users_invited_by,@group_id_are_users_invited_by,2)
			;
	# We make sure that only user in certain groups can create, edit or see cases.
		INSERT INTO `group_control_map`
			(`group_id`
			,`product_id`
			,`entry`
			,`membercontrol`
			,`othercontrol`
			,`canedit`
			,`editcomponents`
			,`editbugs`
			,`canconfirm`
			) 
			VALUES 
			(@create_case_group_id,@product_id,1,0,0,0,0,0,0)
			,(@can_edit_case_group_id,@product_id,1,0,0,1,0,0,1)
			,(@can_edit_all_field_case_group_id,@product_id,1,0,0,1,0,1,1)
			,(@can_edit_component_group_id,@product_id,0,0,0,0,1,0,0)
			,(@can_see_cases_group_id,@product_id,0,2,0,0,0,0,0)
			,(@can_see_unit_in_search_group_id,@product_id,0,3,3,0,0,0,0)
			,(@group_id_show_to_tenant,@product_id,0,2,0,0,0,0,0)
			,(@group_id_show_to_landlord,@product_id,0,2,0,0,0,0,0)
			,(@group_id_show_to_agent,@product_id,0,2,0,0,0,0,0)
			,(@group_id_show_to_contractor,@product_id,0,2,0,0,0,0,0)
			,(@group_id_show_to_mgt_cny,@product_id,0,2,0,0,0,0,0)
			,(@group_id_show_to_occupant,@product_id,0,2,0,0,0,0,0)
			;
		# Log the actions of the script.
			SET @script_log_message = CONCAT('We have updated the group control permissions for the product# '
									, @product_id
									, ': '
									, '\r\ - Create Case (#'
									, (SELECT IFNULL(@create_case_group_id, 'create_case_group_id is NULL'))
									, ').'
									, '\r\ - Edit Case (#'
									, (SELECT IFNULL(@can_edit_case_group_id, 'can_edit_case_group_id is NULL'))
									, ').'
									, '\r\ - Edit All Field (#'
									, (SELECT IFNULL(@can_edit_all_field_case_group_id, 'can_edit_all_field_case_group_id is NULL'))
									, ').'
									, '\r\ - Edit Component (#'
									, (SELECT IFNULL(@can_edit_component_group_id, 'can_edit_component_group_id is NULL'))
									, ').'
									, '\r\ - Can see case (#'
									, (SELECT IFNULL(@can_see_cases_group_id, 'flag_ok_to_pay is NULL'))
									, ').'
									, '\r\ - Can See unit in Search (#'
									, (SELECT IFNULL(@group_id_show_to_tenant, 'group_id_show_to_tenant is NULL'))
									, ').'
									, '\r\ - Show case to Tenant (#'
									, (SELECT IFNULL(@group_id_show_to_landlord, 'group_id_show_to_landlord is NULL'))
									, ').'
									, '\r\ - Show case to Landlord (#'
									, (SELECT IFNULL(@group_id_show_to_landlord, 'group_id_show_to_landlord is NULL'))
									, ').'
									, '\r\ - Show case to Agent (#'
									, (SELECT IFNULL(@group_id_show_to_agent, 'group_id_show_to_agent is NULL'))
									, ').'
									, '\r\ - Show case to Contractor (#'
									, (SELECT IFNULL(@group_id_show_to_contractor, 'group_id_show_to_contractor is NULL'))
									, ').'
									, '\r\ - Show case to Management Company (#'
									, (SELECT IFNULL(@group_id_show_to_mgt_cny, 'group_id_show_to_mgt_cny is NULL'))
									, ').'
									, '\r\ - Show case to Occupant(s) (#'
									, (SELECT IFNULL(@group_id_show_to_occupant, 'group_id_show_to_occupant is NULL'))
									, ').'
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(NOW(), @script, @script_log_message)
				;
			
			SET @script_log_message = NULL;
		# We have eveything, we can create the components we need:
			INSERT INTO `components`
			(`id`
			,`name`
			,`product_id`
			,`initialowner`
			,`initialqacontact`
			,`description`
			,`isactive`
			) 
			VALUES
			(@component_id_tenant,@role_user_g_description_tenant,@product_id,@bz_user_id_dummy_tenant,@bz_user_id_dummy_tenant,@user_role_desc_tenant,1)
			, (@component_id_landlord, @role_user_g_description_landlord, @product_id, @bz_user_id_dummy_landlord, @bz_user_id_dummy_landlord, @user_role_desc_landlord, 1)
			, (@component_id_agent, @role_user_g_description_agent, @product_id, @bz_user_id_dummy_agent, @bz_user_id_dummy_agent, @user_role_desc_agent, 1)
			, (@component_id_contractor, @role_user_g_description_contractor, @product_id, @bz_user_id_dummy_contractor, @bz_user_id_dummy_contractor, @user_role_desc_contractor, 1)
			, (@component_id_mgt_cny, @role_user_g_description_mgt_cny, @product_id, @bz_user_id_dummy_mgt_cny, @bz_user_id_dummy_mgt_cny, @user_role_desc_mgt_cny, 1)
			;
		# Log the actions of the script.
			SET @script_log_message = CONCAT('The role created for that unit with temporary users were:'
									, '\r\- '
									, (SELECT IFNULL(@role_user_g_description_tenant, 'role_user_g_description is NULL'))
									, ' (role_type_id #'
									, '1'
									, ') '
									, '\r\The user associated to this role was bz user #'
									, (SELECT IFNULL(@bz_user_id_dummy_tenant, 'bz_user_id is NULL'))
									, ' (real name: '
									, (SELECT IFNULL(@user_pub_name_tenant, 'user_pub_name is NULL'))
									, '. This user is the default assignee for this role for that unit).' 
									
									, '\r\- '
									, (SELECT IFNULL(@role_user_g_description_landlord, 'role_user_g_description is NULL'))
									, ' (role_type_id #'
									, '2'
									, ') '
									, '\r\The user associated to this role was bz user #'
									, (SELECT IFNULL(@bz_user_id_dummy_landlord, 'bz_user_id is NULL'))
									, ' (real name: '
									, (SELECT IFNULL(@user_pub_name_landlord, 'user_pub_name is NULL'))
									, '. This user is the default assignee for this role for that unit).'
									
									, '\r\- '
									, (SELECT IFNULL(@role_user_g_description_agent, 'role_user_g_description is NULL'))
									, ' (role_type_id #'
									, '5'
									, ') '
									, '\r\The user associated to this role was bz user #'
									, (SELECT IFNULL(@bz_user_id_dummy_agent, 'bz_user_id is NULL'))
									, ' (real name: '
									, (SELECT IFNULL(@user_pub_name_agent, 'user_pub_name is NULL'))
									, '. This user is the default assignee for this role for that unit).'
									
									, '\r\- '
									, (SELECT IFNULL(@role_user_g_description_contractor, 'role_user_g_description is NULL'))
									, ' (role_type_id #'
									, '3'
									, ') '
									, '\r\The user associated to this role was bz user #'
									, (SELECT IFNULL(@bz_user_id_dummy_contractor, 'bz_user_id is NULL'))
									, ' (real name: '
									, (SELECT IFNULL(@user_pub_name_contractor, 'user_pub_name is NULL'))
									, '. This user is the default assignee for this role for that unit).'
									, '\r\- '
									, (SELECT IFNULL(@role_user_g_description_mgt_cny, 'role_user_g_description is NULL'))
									, ' (role_type_id #'
									, '3'
									, ') '
									, '\r\The user associated to this role was bz user #'
									, (SELECT IFNULL(@bz_user_id_dummy_mgt_cny, 'bz_user_id is NULL'))
									, ' (real name: '
									, (SELECT IFNULL(@user_pub_name_mgt_cny, 'user_pub_name is NULL'))
									, '. This user is the default assignee for this role for that unit).'								
									)
									;
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(NOW(), @script, @script_log_message)
				;
			
			SET @script_log_message = NULL;	
				
		# We update the BZ logs
			INSERT INTO `audit_log`
				(`user_id`
				,`class`
				,`object_id`
				,`field`
				,`removed`
				,`added`
				,`at_time`
				) 
				VALUES 
				(@creator_bz_id, 'Bugzilla::Component', @component_id_tenant, '__create__', NULL, @role_user_g_description_tenant, @timestamp)
				,(@creator_bz_id, 'Bugzilla::Component', @component_id_landlord, '__create__', NULL, @role_user_g_description_landlord, @timestamp)
				,(@creator_bz_id, 'Bugzilla::Component', @component_id_agent, '__create__', NULL, @role_user_g_description_agent, @timestamp)
				,(@creator_bz_id, 'Bugzilla::Component', @component_id_contractor, '__create__', NULL, @role_user_g_description_contractor, @timestamp)
				,(@creator_bz_id, 'Bugzilla::Component', @component_id_mgt_cny, '__create__', NULL, @role_user_g_description_mgt_cny, @timestamp)
				;
		# We insert the series categories that BZ needs...
		
			# What is the next available id for the series category?
				SET @series_category_product = ((SELECT MAX(`id`) FROM `series_categories`) + 1);
				SET @series_category_component_tenant = @series_category_product + 1;
				SET @series_category_component_landlord = @series_category_component_tenant + 1;
				SET @series_category_component_contractor = @series_category_component_landlord + 1;
				SET @series_category_component_mgtcny = @series_category_component_contractor + 1;
				SET @series_category_component_agent = @series_category_component_mgtcny + 1;
				
			# What are the name for the categories
				SET @series_category_product_name = @unit_for_group;
				SET @series_category_component_tenant_name = CONCAT('Tenant - ', @product_id,'_#',@component_id_tenant);
				SET @series_category_component_landlord_name = CONCAT('Landlord - ', @product_id,'_#',@component_id_landlord);
				SET @series_category_component_contractor_name = CONCAT('Contractor - ', @product_id,'_#',@component_id_contractor);
				SET @series_category_component_mgtcny_name = CONCAT('Mgt Cny - ', @product_id,'_#',@component_id_mgt_cny);
				SET @series_category_component_agent_name = CONCAT('Agent - ', @product_id,'_#',@component_id_agent);
				
			# What are the SQL queries for these series:
				
				# We need a sanitized unit name:
					SET @unit_name_for_serie_query = REPLACE(@unit,' ','%20');
				
				# Product
					SET @serie_search_unconfirmed = CONCAT('bug_status=UNCONFIRMED&product=',@unit_name_for_serie_query);
					SET @serie_search_confirmed = CONCAT('bug_status=CONFIRMED&product=',@unit_name_for_serie_query);
					SET @serie_search_in_progress = CONCAT('bug_status=IN_PROGRESS&product=',@unit_name_for_serie_query);
					SET @serie_search_reopened = CONCAT('bug_status=REOPENED&product=',@unit_name_for_serie_query);
					SET @serie_search_standby = CONCAT('bug_status=STAND%20BY&product=',@unit_name_for_serie_query);
					SET @serie_search_resolved = CONCAT('bug_status=RESOLVED&product=',@unit_name_for_serie_query);
					SET @serie_search_verified = CONCAT('bug_status=VERIFIED&product=',@unit_name_for_serie_query);
					SET @serie_search_closed = CONCAT('bug_status=CLOSED&product=',@unit_name_for_serie_query);
					SET @serie_search_fixed = CONCAT('resolution=FIXED&product=',@unit_name_for_serie_query);
					SET @serie_search_invalid = CONCAT('resolution=INVALID&product=',@unit_name_for_serie_query);
					SET @serie_search_wontfix = CONCAT('resolution=WONTFIX&product=',@unit_name_for_serie_query);
					SET @serie_search_duplicate = CONCAT('resolution=DUPLICATE&product=',@unit_name_for_serie_query);
					SET @serie_search_worksforme = CONCAT('resolution=WORKSFORME&product=',@unit_name_for_serie_query);
					SET @serie_search_all_open = CONCAT('bug_status=UNCONFIRMED&bug_status=CONFIRMED&bug_status=IN_PROGRESS&bug_status=REOPENED&bug_status=STAND%20BY&product=',@unit_name_for_serie_query);
					
				# Component
				
					# We need several variables to build this
						SET @serie_search_prefix_component_open = 'field0-0-0=resolution&type0-0-0=notregexp&value0-0-0=.&product='; 
						SET @serie_search_prefix_component_closed = 'field0-0-0=resolution&type0-0-0=regexp&value0-0-0=.&product=';
					SET @component_name_for_serie_tenant = REPLACE(@role_user_g_description_tenant,' ','%20');
						SET @component_name_for_serie_landlord = REPLACE(@role_user_g_description_landlord,' ','%20');
						SET @component_name_for_serie_contractor = REPLACE(@role_user_g_description_contractor,' ','%20');
						SET @component_name_for_serie_mgtcny = REPLACE(@role_user_g_description_mgt_cny,' ','%20');
						SET @component_name_for_serie_agent = REPLACE(@role_user_g_description_agent,' ','%20');
						
					# We can now derive the query needed to build these series
					
						SET @serie_search_all_open_tenant = (CONCAT (@serie_search_prefix_component_open
							,@unit_name_for_serie_query
							,'&component='
							,@component_name_for_serie_tenant)
							);
						SET @serie_search_all_closed_tenant = (CONCAT (@serie_search_prefix_component_closed
							,@unit_name_for_serie_query
							,'&component='
							,@component_name_for_serie_tenant)
							);
						SET @serie_search_all_open_landlord = (CONCAT (@serie_search_prefix_component_open
							,@unit_name_for_serie_query
							,'&component='
							,@component_name_for_serie_landlord)
							);
						SET @serie_search_all_closed_landlord = (CONCAT (@serie_search_prefix_component_closed
							,@unit_name_for_serie_query
							,'&component='
							,@component_name_for_serie_landlord)
							);
						SET @serie_search_all_open_contractor = (CONCAT (@serie_search_prefix_component_open
							,@unit_name_for_serie_query
							,'&component='
							,@component_name_for_serie_contractor)
							);
						SET @serie_search_all_closed_contractor = (CONCAT (@serie_search_prefix_component_closed
							,@unit_name_for_serie_query
							,'&component='
							,@component_name_for_serie_contractor)
							);
						SET @serie_search_all_open_mgtcny = (CONCAT (@serie_search_prefix_component_open
							,@unit_name_for_serie_query
							,'&component='
							,@component_name_for_serie_mgtcny)
							);
						SET @serie_search_all_closed_mgtcny = (CONCAT (@serie_search_prefix_component_closed
							,@unit_name_for_serie_query
							,'&component='
							,@component_name_for_serie_mgtcny)
							);
						SET @serie_search_all_open_agent = (CONCAT (@serie_search_prefix_component_open
							,@unit_name_for_serie_query
							,'&component='
							,@component_name_for_serie_agent)
							);
						SET @serie_search_all_closed_agent = (CONCAT (@serie_search_prefix_component_closed
							,@unit_name_for_serie_query
							,'&component='
							,@component_name_for_serie_agent)
							);
		
		# We can now insert the series category
			INSERT INTO `series_categories`
				(`id`
				,`name`
				) 
				VALUES 
				(@series_category_product, @series_category_product_name)
				, (@series_category_component_tenant, @series_category_component_tenant_name)
				, (@series_category_component_landlord, @series_category_component_landlord_name)
				, (@series_category_component_contractor, @series_category_component_contractor_name)
				, (@series_category_component_mgtcny, @series_category_component_mgtcny_name)
				, (@series_category_component_agent, @series_category_component_agent_name)
				;
		# Insert the series related to the product/unit
			INSERT INTO `series`
				(`series_id`
				,`creator`
				,`category`
				,`subcategory`
				,`name`
				,`frequency`
				,`query`
				,`is_public`
				) 
				VALUES 
				(NULL,@creator_bz_id,@series_category_product,2,'UNCONFIRMED',1,@serie_search_unconfirmed,1)
				,(NULL,@creator_bz_id,@series_category_product,2,'CONFIRMED',1,@serie_search_confirmed,1)
				,(NULL,@creator_bz_id,@series_category_product,2,'IN_PROGRESS',1,@serie_search_in_progress,1)
				,(NULL,@creator_bz_id,@series_category_product,2,'REOPENED',1,@serie_search_reopened,1)
				,(NULL,@creator_bz_id,@series_category_product,2,'STAND BY',1,@serie_search_standby,1)
				,(NULL,@creator_bz_id,@series_category_product,2,'RESOLVED',1,@serie_search_resolved,1)
				,(NULL,@creator_bz_id,@series_category_product,2,'VERIFIED',1,@serie_search_verified,1)
				,(NULL,@creator_bz_id,@series_category_product,2,'CLOSED',1,@serie_search_closed,1)
				,(NULL,@creator_bz_id,@series_category_product,2,'FIXED',1,@serie_search_fixed,1)
				,(NULL,@creator_bz_id,@series_category_product,2,'INVALID',1,@serie_search_invalid,1)
				,(NULL,@creator_bz_id,@series_category_product,2,'WONTFIX',1,@serie_search_wontfix,1)
				,(NULL,@creator_bz_id,@series_category_product,2,'DUPLICATE',1,@serie_search_duplicate,1)
				,(NULL,@creator_bz_id,@series_category_product,2,'WORKSFORME',1,@serie_search_worksforme,1)
				,(NULL,@creator_bz_id,@series_category_product,2,'All Open',1,@serie_search_all_open,1)
				;
				
		# Insert the series related to the Components/roles
			INSERT INTO `series`
				(`series_id`
				,`creator`
				,`category`
				,`subcategory`
				,`name`
				,`frequency`
				,`query`
				,`is_public`
				) 
				VALUES
				# Tenant
				(NULL,@creator_bz_id,@series_category_product,@series_category_component_tenant,'All Open',1,@serie_search_all_open_tenant,1)
				,(NULL,@creator_bz_id,@series_category_product,@series_category_component_tenant,'All Closed',1,@serie_search_all_closed_tenant,1)
				# Landlord
				,(NULL,@creator_bz_id,@series_category_product,@series_category_component_landlord,'All Open',1,@serie_search_all_open_landlord,1)
				,(NULL,@creator_bz_id,@series_category_product,@series_category_component_landlord,'All Closed',1,@serie_search_all_closed_landlord,1)
				# Contractor
				,(NULL,@creator_bz_id,@series_category_product,@series_category_component_contractor,'All Open',1,@serie_search_all_open_contractor,1)
				,(NULL,@creator_bz_id,@series_category_product,@series_category_component_contractor,'All Closed',1,@serie_search_all_closed_contractor,1)
				# Management Company
				,(NULL,@creator_bz_id,@series_category_product,@series_category_component_mgtcny,'All Open',1,@serie_search_all_open_mgtcny,1)
				,(NULL,@creator_bz_id,@series_category_product,@series_category_component_mgtcny,'All Closed',1,@serie_search_all_closed_mgtcny,1)
				# Agent
				,(NULL,@creator_bz_id,@series_category_product,@series_category_component_agent,'All Open',1,@serie_search_all_open_agent,1)
				,(NULL,@creator_bz_id,@series_category_product,@series_category_component_agent,'All Closed',1,@serie_search_all_closed_agent,1)
				;
	# We now assign the permissions to the user associated to this role:		
		
		# We use a temporary table to make sure we do not have duplicates.
			
			# DELETE the temp table if it exists
			DROP TABLE IF EXISTS `ut_user_group_map_temp`;
			
			# Re-create the temp table
			CREATE TABLE `ut_user_group_map_temp` (
			  `user_id` MEDIUMINT(9) NOT NULL,
			  `group_id` MEDIUMINT(9) NOT NULL,
			  `isbless` TINYINT(4) NOT NULL DEFAULT '0',
			  `grant_type` TINYINT(4) NOT NULL DEFAULT '0'
			) ENGINE=INNODB DEFAULT CHARSET=utf8;
			# Add the records that exist in the table user_group_map
			INSERT INTO `ut_user_group_map_temp`
				SELECT *
				FROM `user_group_map`;
	# We create the permissions for the dummy user to create a case for this unit.		
	#	- can tag comments: ALL user need that	
	#	- can_create_new_cases
	#	- can_edit_a_case
	# This is the only permission that the dummy user will have.
		# First the global permissions:
			# Can tag comments
				INSERT INTO `ut_user_group_map_temp`
					(`user_id`
					,`group_id`
					,`isbless`
					,`grant_type`
					) 
					VALUES 
					(@bz_user_id_dummy_tenant,@can_tag_comment_group_id,0,0)
					, (@bz_user_id_dummy_landlord,@can_tag_comment_group_id,0,0)
					, (@bz_user_id_dummy_agent,@can_tag_comment_group_id,0,0)
					, (@bz_user_id_dummy_contractor,@can_tag_comment_group_id,0,0)
					, (@bz_user_id_dummy_mgt_cny,@can_tag_comment_group_id,0,0)
					;
					
				# Log the actions of the script.
					SET @script_log_message = CONCAT('the dummy bz users for each component: '
											, '(#'
											, @bz_user_id_dummy_tenant
											, ', #'
											, @bz_user_id_dummy_landlord
											, ', #'
											, @bz_user_id_dummy_agent
											, ', #'
											, @bz_user_id_dummy_contractor
											, ', #'
											, @bz_user_id_dummy_mgt_cny
											, ')'
											, ' CAN tag comments.'
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
						(NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_tenant, @script, 'Add the BZ user id when we grant the permission to tag comments')
						, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_tag_comment_group_id, @script, 'Add the BZ group id when we grant the permission to tag comments')
						, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant tag comments permission')
						, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group tag comments')
						, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_landlord, @script, 'Add the BZ user id when we grant the permission to tag comments')
						, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_tag_comment_group_id, @script, 'Add the BZ group id when we grant the permission to tag comments')
						, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant tag comments permission')
						, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group tag comments')
						, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_agent, @script, 'Add the BZ user id when we grant the permission to tag comments')
						, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_tag_comment_group_id, @script, 'Add the BZ group id when we grant the permission to tag comments')
						, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant tag comments permission')
						, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group tag comments')
						, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_contractor, @script, 'Add the BZ user id when we grant the permission to tag comments')
						, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_tag_comment_group_id, @script, 'Add the BZ group id when we grant the permission to tag comments')
						, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant tag comments permission')
						, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group tag comments')
						, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_mgt_cny, @script, 'Add the BZ user id when we grant the permission to tag comments')
						, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_tag_comment_group_id, @script, 'Add the BZ group id when we grant the permission to tag comments')
						, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant tag comments permission')
						, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group tag comments')
						;
				 
				# Cleanup the variables for the log messages
					SET @script_log_message = NULL;
					SET @bzfe_table = NULL;
		
		# Then the permissions at the unit/product level:
					
			# User can create a case:
				INSERT INTO `ut_user_group_map_temp`
					(`user_id`
					,`group_id`
					,`isbless`
					,`grant_type`
					) 
					VALUES 
					(@bz_user_id_dummy_tenant, @create_case_group_id, 0, 0)
					, (@bz_user_id_dummy_landlord, @create_case_group_id, 0, 0)
					, (@bz_user_id_dummy_agent, @create_case_group_id, 0, 0)
					, (@bz_user_id_dummy_contractor, @create_case_group_id, 0, 0)
					, (@bz_user_id_dummy_mgt_cny, @create_case_group_id, 0, 0)
					;
				# Log the actions of the script.
					SET @script_log_message = CONCAT('the dummy bz users for each component: '
											, '(#'
											, @bz_user_id_dummy_tenant
											, ', #'
											, @bz_user_id_dummy_landlord
											, ', #'
											, @bz_user_id_dummy_agent
											, ', #'
											, @bz_user_id_dummy_contractor
											, ', #'
											, @bz_user_id_dummy_mgt_cny
											, ')'
											, ' CAN create new cases for unit '
											, @product_id
											)
											;
					
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
					SET @permission_granted = 'create a new case.';
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
						(NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_tenant, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
						, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
						, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission', 'for the product #', @product_id))
						, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
						, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_landlord, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
						, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
						, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission', 'for the product #', @product_id))
						, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
						, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_agent, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
						, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
						, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission', 'for the product #', @product_id))
						, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
						, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_contractor, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
						, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
						, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, 'for the product #', @product_id))
						, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
						, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_mgt_cny, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
						, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
						, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, 'for the product #', @product_id))
						, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
						;
				 
				# Cleanup the variables for the log messages
					SET @script_log_message = NULL;
					SET @bzfe_table = NULL;
					SET @permission_granted = NULL;
			# User can Edit a case and see this unit, this is needed so the API does not thrown an error see issue #60:
				INSERT INTO `ut_user_group_map_temp`
					(`user_id`
					,`group_id`
					,`isbless`
					,`grant_type`
					) 
					VALUES 
					(@bz_user_id_dummy_tenant,@can_edit_case_group_id,0,0)
					, (@bz_user_id_dummy_landlord,@can_edit_case_group_id,0,0)
					, (@bz_user_id_dummy_agent,@can_edit_case_group_id,0,0)
					, (@bz_user_id_dummy_contractor,@can_edit_case_group_id,0,0)
					, (@bz_user_id_dummy_mgt_cny,@can_edit_case_group_id,0,0)
					, (@bz_user_id_dummy_tenant,@can_see_unit_in_search_group_id,0,0)
					, (@bz_user_id_dummy_landlord,@can_see_unit_in_search_group_id,0,0)
					, (@bz_user_id_dummy_agent,@can_see_unit_in_search_group_id,0,0)
					, (@bz_user_id_dummy_contractor,@can_see_unit_in_search_group_id,0,0)
					, (@bz_user_id_dummy_mgt_cny,@can_see_unit_in_search_group_id,0,0)
					;
				# Log the actions of the script.
					SET @script_log_message = CONCAT('the dummy bz users for each component: '
											, '(#'
											, @bz_user_id_dummy_tenant
											, ', #'
											, @bz_user_id_dummy_landlord
											, ', #'
											, @bz_user_id_dummy_agent
											, ', #'
											, @bz_user_id_dummy_contractor
											, ', #'
											, @bz_user_id_dummy_mgt_cny
											, ')'
											, ' CAN edit a cases and see the unit '
											, @product_id
											)
											;
					
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
					SET @permission_granted = 'edit a case and see this unit.';
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
						(NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_tenant, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
						, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
						, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission', 'for the product #', @product_id))
						, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
						, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_landlord, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
						, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
						, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission', 'for the product #', @product_id))
						, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
						, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_agent, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
						, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
						, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission', 'for the product #', @product_id))
						, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
						, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_contractor, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
						, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
						, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, 'for the product #', @product_id))
						, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
						, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_mgt_cny, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
						, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
						, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, 'for the product #', @product_id))
						, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
						;
				 
				# Cleanup the variables for the log messages
					SET @script_log_message = NULL;
					SET @bzfe_table = NULL;
					SET @permission_granted = NULL;
			
	# We give the user the permission they need.
			
		# First the `group_group_map` table
		
			# We truncate the table first (to avoid duplicates)
			TRUNCATE TABLE `group_group_map`;
			
			# We insert the data we need
			# Grouping like this makes sure that we have no dupes!
			INSERT INTO `group_group_map`
			SELECT `member_id`
				, `grantor_id`
				, `grant_type`
			FROM
				`ut_group_group_map_temp`
			GROUP BY `member_id`
				, `grantor_id`
				, `grant_type`
			;
		# Then we update the `user_group_map` table
			
			# We truncate the table first (to avoid duplicates)
				TRUNCATE TABLE `user_group_map`;
				
			# We insert the data we need
				INSERT INTO `user_group_map`
				SELECT `user_id`
					, `group_id`
					, `isbless`
					, `grant_type`
				FROM
					`ut_user_group_map_temp`
				GROUP BY `user_id`
					, `group_id`
					, `isbless`
					, `grant_type`
				;
	# Update the table 'ut_data_to_create_units' so that we record that the unit has been created
		UPDATE `ut_data_to_create_units`
		SET 
			`bz_created_date` = @timestamp
			, `comment` = CONCAT ('inserted in BZ with the script \''
					, @script
					, '\'\r\ '
					, IFNULL(`comment`, '')
					)
			, `product_id` = @product_id
		WHERE `id_unit_to_create` = @unit_reference_for_import;
	#Clean up
		# We Delete the temp table as we do not need it anymore
			DROP TABLE IF EXISTS `ut_group_group_map_temp`;
			DROP TABLE IF EXISTS `ut_temp_dummy_users_for_roles`;
			
		# We Delete the temp table as we do not need it anymore
			DROP TABLE IF EXISTS `ut_user_group_map_temp`;
	# We implement the FK checks again
			
	 SET SQL_MODE=@OLD_SQL_MODE ;
	 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS ;
	 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS ;
	 SET SQL_NOTES=@OLD_SQL_NOTES ;
	
END */$$
DELIMITER ;

/* Procedure structure for procedure `unit_disable_existing` */

/*!50003 DROP PROCEDURE IF EXISTS  `unit_disable_existing` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `unit_disable_existing`()
    SQL SECURITY INVOKER
BEGIN
	# This procedure needs the following variables:
	#	- @product_id
	# 	- @inactive_when
	#
	# This procedure will
	#	- Disable an existing unit/BZ product
	#	- Record the action of the script in the ut_log tables.
	#	- Record the chenge in the BZ `audit_log` table
	
	# We record the name of this procedure for future debugging and audit_log`
		SET @script = 'PROCEDURE - unit_disable_existing';
		SET @timestamp = NOW();
	# Make a unit inactive
		UPDATE `products`
			SET `isactive` = '0'
			WHERE `id` = @product_id
		;
	# Record the actions of this script in the ut_log
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the Unit #'
									, @product_id
									, ' is inactive. It is not possible to create new cases in this unit.'
									);
		
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;
			# We log what we have just done into the `ut_audit_log` table
			
			SET @bzfe_table = 'products';
			
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
				 (@timestamp ,@bzfe_table, 'isactive', '1', '0', @script, @script_log_message)
				 ;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
	# When we mark a unit as inactive, we need to record this in the `audit_log` table
			INSERT INTO `audit_log`
			(`user_id`
			, `class`
			, `object_id`
			, `field`
			, `removed`
			, `added`
			, `at_time`
			)
			VALUES
			(@creator_bz_id
			, 'Bugzilla::Product'
			, @product_id
			, 'isactive'
			, '1'
			, '0'
			, @inactive_when
			)
			;			
END */$$
DELIMITER ;

/* Procedure structure for procedure `update_assignee_if_dummy_user` */

/*!50003 DROP PROCEDURE IF EXISTS  `update_assignee_if_dummy_user` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `update_assignee_if_dummy_user`()
    SQL SECURITY INVOKER
BEGIN
	# check if the user is the first in this role for this unit
	IF (@is_current_assignee_this_role_a_dummy_user = 1)
	# We update the component IF this user is the first in this role
	# IF the user is the first in this role for this unit
	# THEN change the initial owner and initialqa contact to the invited BZ user.
	THEN 
											
		# Get the old values so we can log those
			SET @old_component_initialowner = (SELECT `initialowner` 
										FROM `components` 
										WHERE `id` = @component_id_this_role)
										;
			SET @old_component_initialqacontact = (SELECT `initialqacontact` 
										FROM `components` 
										WHERE `id` = @component_id_this_role)
										;
			SET @old_component_description = (SELECT `description` 
										FROM `components` 
										WHERE `id` = @component_id_this_role)
										;
	
		# Update the default assignee and qa contact
			UPDATE `components`
			SET 
				`initialowner` = @bz_user_id
				,`initialqacontact` = @bz_user_id
				,`description` = @user_role_desc
				WHERE 
				`id` = @component_id_this_role
				;
		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - update_assignee_if_dummy_user';
			SET @timestamp = NOW();
				
		# Log the actions of the script.
			SET @script_log_message = CONCAT('The component: '
									, (SELECT IFNULL(@component_id_this_role, 'component_id_this_role is NULL'))
									, ' (for the role_type_id #'
									, (SELECT IFNULL(@id_role_type, 'id_role_type is NULL'))
									, ') has been updated.'
									, '\r\The default user now associated to this role is bz user #'
									, (SELECT IFNULL(@bz_user_id, 'bz_user_id is NULL'))
									, ' (real name: '
									, (SELECT IFNULL(@user_pub_name, 'user_pub_name is NULL'))
									, ') for the unit #' 
									, @product_id
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;
				
		# We update the BZ logs
			INSERT  INTO `audit_log`
				(`user_id`
				,`class`
				,`object_id`
				,`field`
				,`removed`
				,`added`
				,`at_time`
				) 
				VALUES 
				(@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'initialowner',@old_component_initialowner,@bz_user_id,@timestamp)
				, (@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'initialqacontact',@old_component_initialqacontact,@bz_user_id,@timestamp)
				, (@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'description',@old_component_description,@user_role_desc,@timestamp)
				;
		# Update the table 'ut_data_to_replace_dummy_roles' so that we record what we have done
			INSERT INTO `ut_data_to_replace_dummy_roles`
				(`mefe_invitation_id`
				, `mefe_invitor_user_id`
				, `bzfe_invitor_user_id`
				, `bz_unit_id`
				, `bz_user_id`
				, `user_role_type_id`
				, `is_occupant`
				, `is_mefe_user_only`
				, `user_more`
				, `bz_created_date`
				, `comment`
				)
			VALUES 
				(@mefe_invitation_id
				, @mefe_invitor_user_id
				, @creator_bz_id
				, @product_id
				, @bz_user_id
				, @id_role_type
				, @is_occupant
				, @is_mefe_only_user
				, @role_user_more
				, @timestamp
				, CONCAT ('inserted in BZ with the script \''
						, @script
						, '\'\r\ '
						, IFNULL(`comment`, '')
						)
				)
				;
					
		# Cleanup the variables for the log messages:
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
END IF ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `update_list_changes_new_assignee_is_real` */

/*!50003 DROP PROCEDURE IF EXISTS  `update_list_changes_new_assignee_is_real` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `update_list_changes_new_assignee_is_real`()
    SQL SECURITY INVOKER
BEGIN
			
	DROP VIEW IF EXISTS `list_changes_new_assignee_is_real`;
	
	IF @environment = '1'
		THEN
		# We are in the DEV/Staging environment
		# Create the view to list all the changes from the audit log when we replaced the dummy tenant with a real user
		# We use the values for the DEV/Staging environment (1)		
		CREATE VIEW `list_changes_new_assignee_is_real`
			AS
				SELECT `ut_product_group`.`product_id`
					, `audit_log`.`object_id` AS `component_id`
					, `audit_log`.`removed`
					, `audit_log`.`added`
					, `audit_log`.`at_time`
					, `ut_product_group`.`role_type_id`
					FROM `audit_log`
						INNER JOIN `ut_product_group` 
						ON (`audit_log`.`object_id` = `ut_product_group`.`component_id`)
					# If we add one of the BZ user who is NOT a dummy user, then it is a REAL user
					WHERE (`class` = 'Bugzilla::Component'
						AND `field` = 'initialowner'
						AND 
						# The new initial owner is NOT the dummy tenant?
						`audit_log`.`added` <> 96
						AND 
						# The new initial owner is NOT the dummy landlord?
						`audit_log`.`added` <> 94
						AND 				
						# The new initial owner is NOT the dummy contractor?
						`audit_log`.`added` <> 93
						AND 
						# The new initial owner is NOT the dummy Mgt Cny?
						`audit_log`.`added` <> 95
						AND 
						# The new initial owner is NOT the dummy agent?
						`audit_log`.`added` <> 92
						)
					GROUP BY `audit_log`.`object_id`
						, `ut_product_group`.`role_type_id`
					ORDER BY `audit_log`.`at_time` DESC
						, `ut_product_group`.`product_id` ASC
						, `audit_log`.`object_id` ASC
					;
		ELSEIF @environment = '2'
			THEN
			# We are in the Prod environment
			# Create the view to list all the changes from the audit log when we replaced the dummy tenant with a real user
			# We use the values for the Prod environment (2)
			#
			CREATE VIEW `list_changes_new_assignee_is_real`
				AS
					SELECT `ut_product_group`.`product_id`
						, `audit_log`.`object_id` AS `component_id`
						, `audit_log`.`removed`
						, `audit_log`.`added`
						, `audit_log`.`at_time`
						, `ut_product_group`.`role_type_id`
						FROM `audit_log`
							INNER JOIN `ut_product_group` 
							ON (`audit_log`.`object_id` = `ut_product_group`.`component_id`)
						# If we add one of the BZ user who is NOT a dummy user, then it is a REAL user
						WHERE (`class` = 'Bugzilla::Component'
							AND `field` = 'initialowner'
							AND 
							# The new initial owner is NOT the dummy tenant?
							`audit_log`.`added` <> 93
							AND 
							# The new initial owner is NOT the dummy landlord?
							`audit_log`.`added` <> 91
							AND 				
							# The new initial owner is NOT the dummy contractor?
							`audit_log`.`added` <> 90
							AND 
							# The new initial owner is NOT the dummy Mgt Cny?
							`audit_log`.`added` <> 92
							AND 
							# The new initial owner is NOT the dummy agent?
							`audit_log`.`added` <> 89
							)
						GROUP BY `audit_log`.`object_id`
							, `ut_product_group`.`role_type_id`
						ORDER BY `audit_log`.`at_time` DESC
							, `ut_product_group`.`product_id` ASC
							, `audit_log`.`object_id` ASC
						;
		ELSEIF @environment = '3'
			THEN
			# We are in the DEMO environment
			# Create the view to list all the changes from the audit log when we replaced the dummy tenant with a real user
			# We use the values for the DEMO Environment (3)
			#
			CREATE VIEW `list_changes_new_assignee_is_real`
				AS
					SELECT `ut_product_group`.`product_id`
						, `audit_log`.`object_id` AS `component_id`
						, `audit_log`.`removed`
						, `audit_log`.`added`
						, `audit_log`.`at_time`
						, `ut_product_group`.`role_type_id`
						FROM `audit_log`
							INNER JOIN `ut_product_group` 
							ON (`audit_log`.`object_id` = `ut_product_group`.`component_id`)
						# If we add one of the BZ user who is NOT a dummy user, then it is a REAL user
						WHERE (`class` = 'Bugzilla::Component'
							AND `field` = 'initialowner'
							AND 
							# The new initial owner is NOT the dummy tenant?
							`audit_log`.`added` <> 4
							AND 
							# The new initial owner is NOT the dummy landlord?
							`audit_log`.`added` <> 3
							AND 				
							# The new initial owner is NOT the dummy contractor?
							`audit_log`.`added` <> 5
							AND 
							# The new initial owner is NOT the dummy Mgt Cny?
							`audit_log`.`added` <> 6
							AND 
							# The new initial owner is NOT the dummy agent?
							`audit_log`.`added` <> 2
							)
						GROUP BY `audit_log`.`object_id`
							, `ut_product_group`.`role_type_id`
						ORDER BY `audit_log`.`at_time` DESC
							, `ut_product_group`.`product_id` ASC
							, `audit_log`.`object_id` ASC
						;
    END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `update_log_count_closed_case` */

/*!50003 DROP PROCEDURE IF EXISTS  `update_log_count_closed_case` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `update_log_count_closed_case`()
    SQL SECURITY INVOKER
BEGIN
	# When are we doing this?
		SET @timestamp = NOW();	
	# Flash Count the total number of CLOSED cases are the date of this query
	# Put this in a variable
		SET @count_closed_cases = (SELECT
			 COUNT(`bugs`.`bug_id`)
		FROM
			`bugs`
			INNER JOIN `bug_status`
				ON (`bugs`.`bug_status` = `bug_status`.`value`)
		WHERE `bug_status`.`is_open` = 0)
		;
		
	# Flash Count the total number of ALL cases are the date of this query
	# Put this in a variable
		SET @count_total_cases = (SELECT
			 COUNT(`bug_id`)
		FROM
			`bugs`
			) 
			;
	# We have everything: insert in the log table
		INSERT INTO `ut_log_count_closed_cases`
			(`timestamp`
			, `count_closed_cases`
			, `count_total_cases`
			)
			VALUES
			(@timestamp
			, @count_closed_cases
			, @count_total_cases
			)
			;
END */$$
DELIMITER ;

/* Procedure structure for procedure `update_permissions_invited_user` */

/*!50003 DROP PROCEDURE IF EXISTS  `update_permissions_invited_user` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `update_permissions_invited_user`()
    SQL SECURITY INVOKER
BEGIN
	# We update the `user_group_map` table
	
	# First we disable the FK checks
		 SET NAMES utf8 ;
		 SET SQL_MODE='' ;
		 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 ;
		 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 ;
		 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' ;
		 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 ;
		
		# We truncate the table first (to avoid duplicates)
			TRUNCATE TABLE `user_group_map`;
			
		# We insert the data we need
			INSERT INTO `user_group_map`
			SELECT `user_id`
				, `group_id`
				, `isbless`
				, `grant_type`
			FROM
				`ut_user_group_map_temp`
			GROUP BY `user_id`
				, `group_id`
				, `isbless`
				, `grant_type`
			;
		# We drop the temp table as we do not need it anymore
			DROP TABLE IF EXISTS `ut_user_group_map_temp`;
			
	# We implement the FK checks again		
		 SET SQL_MODE=@OLD_SQL_MODE ;
		 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS ;
		 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS ;
		 SET SQL_NOTES=@OLD_SQL_NOTES ;	
END */$$
DELIMITER ;

/* Procedure structure for procedure `user_can_see_publicly_visible` */

/*!50003 DROP PROCEDURE IF EXISTS  `user_can_see_publicly_visible` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `user_can_see_publicly_visible`()
    SQL SECURITY INVOKER
BEGIN
	IF (@user_can_see_publicly_visible = 1)
	# This is needed so the user can see all the other users regardless of the other users roles
	# We might hide the visible users to some other user (ex: housekeepers or field person do not need to see landlord or agent
	# They just need to see their manager)
	THEN 
		# Get the information about the group which grant this permission
			SET @see_visible_assignees_group_id = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 5)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @see_visible_assignees_group_id, 0, 0)
				;
		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - user_can_see_publicly_visible';
			SET @timestamp = NOW();
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' CAN see the publicly visible users for the case for this unit.'
									, @product_id
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;
		# We log what we have just done into the `ut_audit_log` table
			
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = ' CAN see the publicly visible users for the case for this unit.';
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @see_visible_assignees_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `user_in_default_cc_for_cases` */

/*!50003 DROP PROCEDURE IF EXISTS  `user_in_default_cc_for_cases` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `user_in_default_cc_for_cases`()
BEGIN
	IF (@user_in_default_cc_for_cases = 1)
	THEN 
		# We use a temporary table to make sure we do not have duplicates.
		
		# DELETE the temp table if it exists
		DROP TABLE IF EXISTS `ut_component_cc_temp`;
		
		# Re-create the temp table
		CREATE TABLE `ut_component_cc_temp` (
		  `user_id` MEDIUMINT(9) NOT NULL
		  ,`component_id` MEDIUMINT(9) NOT NULL
		) ENGINE=INNODB DEFAULT CHARSET=utf8;
		# Add the records that exist in the table component_cc
		INSERT INTO `ut_component_cc_temp`
			SELECT *
			FROM `component_cc`;
		# Add the new user rights for the product
			INSERT INTO `ut_component_cc_temp`
				(user_id
				, component_id
				)
				VALUES
				(@bz_user_id, @component_id)
				;
		
		# Empty the table `component_cc`
			TRUNCATE TABLE `component_cc`;
		
		# Add all the records for `component_cc`
			INSERT INTO `component_cc`
			SELECT `user_id`
				, `component_id`
			FROM
				`ut_component_cc_temp`
			GROUP BY `user_id`
				, `component_id`
			;
		
		# We Delete the temp table as we do not need it anymore
			DROP TABLE IF EXISTS `ut_component_cc_temp`;
		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - user_in_default_cc_for_cases';
			SET @timestamp = NOW();
		
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' is one of the copied assignee for the unit #'
									, @product_id
									, ' when the role '
									, @role_user_g_description
									, ' (the component #'
									, @component_id
									, ')'
									, ' is chosen'
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
				
				SET @bzfe_table = 'component_cc';
				SET @permission_granted = ' is in CC when role is chosen.';
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
					 , (NOW() ,@bzfe_table, 'component_id', 'UNKNOWN', @component_id, @script, CONCAT('Make sure the user ', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @script = NULL;
				SET @timestamp = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;	
END IF ;
END */$$
DELIMITER ;

/* Procedure structure for procedure `user_is_default_assignee_for_cases` */

/*!50003 DROP PROCEDURE IF EXISTS  `user_is_default_assignee_for_cases` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `user_is_default_assignee_for_cases`()
    SQL SECURITY INVOKER
BEGIN
	# This procedure needs the following objects
	#	- Variables:
	#		- @replace_default_assignee
	#		- @component_id_this_role
	#		- @bz_user_id
	#		- @user_role_desc
	#		- @id_role_type
	#		- @user_pub_name
	#		- @product_id
	#
	# We only do this if this is needed:
	IF (@replace_default_assignee = 1)
	
	THEN
	# change the initial owner and initialqa contact to the invited BZ user.
											
		# Get the old values so we can log those
			SET @old_component_initialowner = (SELECT `initialowner` 
										FROM `components` 
										WHERE `id` = @component_id_this_role)
										;
			SET @old_component_initialqacontact = (SELECT `initialqacontact` 
										FROM `components` 
										WHERE `id` = @component_id_this_role)
										;
			SET @old_component_description = (SELECT `description` 
										FROM `components` 
										WHERE `id` = @component_id_this_role)
										;
		# Update the default assignee and qa contact
			UPDATE `components`
			SET 
				`initialowner` = @bz_user_id
				,`initialqacontact` = @bz_user_id
				,`description` = @user_role_desc
				WHERE 
				`id` = @component_id_this_role
				;	
		# We record the name of this procedure for future debugging and audit_log`
				SET @script = 'PROCEDURE - user_is_default_assignee_for_cases';
				SET @timestamp = NOW();
					
		# Log the actions of the script.
			SET @script_log_message = CONCAT('The component: '
									, (SELECT IFNULL(@component_id_this_role, 'component_id_this_role is NULL'))
									, ' (for the role_type_id #'
									, (SELECT IFNULL(@id_role_type, 'id_role_type is NULL'))
									, ') has been updated.'
									, '\r\The default user now associated to this role is bz user #'
									, (SELECT IFNULL(@bz_user_id, 'bz_user_id is NULL'))
									, ' (real name: '
									, (SELECT IFNULL(@user_pub_name, 'user_pub_name is NULL'))
									, ') for the unit #' 
									, @product_id
									);
					
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
					)
				VALUES
				(@timestamp, @script, @script_log_message)
				;
				
		# We update the BZ logs
			INSERT  INTO `audit_log`
				(`user_id`
				,`class`
				,`object_id`
				,`field`
				,`removed`
				,`added`
				,`at_time`
				) 
				VALUES 
				(@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'initialowner',@old_component_initialowner,@bz_user_id,@timestamp)
				, (@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'initialqacontact',@old_component_initialqacontact,@bz_user_id,@timestamp)
				, (@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'description',@old_component_description,@user_role_desc,@timestamp)
				;
		# We log what we have just done into the `ut_audit_log` table
			SET @bzfe_table = 'components';
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
				 (@timestamp ,@bzfe_table , 'initialowner' , @old_component_initialowner , @bz_user_id , @script , 'Add user as default assignee for the role')
				 , (@timestamp ,@bzfe_table , 'initialqacontact' , @old_component_initialqacontact , @bz_user_id , @script , 'Add user as default QA for the role')
				 , (@timestamp ,@bzfe_table , 'description' , @old_component_description , @user_role_desc , @script , 'Change the desription for the role')
				 ;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
	END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `user_is_publicly_visible` */

/*!50003 DROP PROCEDURE IF EXISTS  `user_is_publicly_visible` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `user_is_publicly_visible`()
    SQL SECURITY INVOKER
BEGIN
	IF (@user_is_publicly_visible = 1)
	THEN 
		# Get the information about the group which grant this permission
			SET @list_visible_assignees_group_id = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 4)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @list_visible_assignees_group_id, 0, 0)
				;
		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - user_is_publicly_visible';
			SET @timestamp = NOW();
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' is one of the visible assignee for cases for this unit.'
									, @product_id
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;
		# We log what we have just done into the `ut_audit_log` table
			
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'is one of the visible assignee for cases for this unit.';
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @list_visible_assignees_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END */$$
DELIMITER ;

/*Table structure for table `count_invitation_per_invitee_per_month` */

DROP TABLE IF EXISTS `count_invitation_per_invitee_per_month`;

/*!50001 DROP VIEW IF EXISTS `count_invitation_per_invitee_per_month` */;
/*!50001 DROP TABLE IF EXISTS `count_invitation_per_invitee_per_month` */;

/*!50001 CREATE TABLE  `count_invitation_per_invitee_per_month`(
 `year` int(4) ,
 `month` int(2) ,
 `bz_user_id` mediumint(9) ,
 `invitation_sent` bigint(21) 
)*/;

/*Table structure for table `count_invitees_per_month` */

DROP TABLE IF EXISTS `count_invitees_per_month`;

/*!50001 DROP VIEW IF EXISTS `count_invitees_per_month` */;
/*!50001 DROP TABLE IF EXISTS `count_invitees_per_month` */;

/*!50001 CREATE TABLE  `count_invitees_per_month`(
 `year` int(4) ,
 `month` int(2) ,
 `count_invitees` bigint(21) 
)*/;

/*Table structure for table `count_invites_per_month` */

DROP TABLE IF EXISTS `count_invites_per_month`;

/*!50001 DROP VIEW IF EXISTS `count_invites_per_month` */;
/*!50001 DROP TABLE IF EXISTS `count_invites_per_month` */;

/*!50001 CREATE TABLE  `count_invites_per_month`(
 `year` int(4) ,
 `month` int(2) ,
 `count_invites` bigint(21) 
)*/;

/*Table structure for table `count_invites_per_role_per_month` */

DROP TABLE IF EXISTS `count_invites_per_role_per_month`;

/*!50001 DROP VIEW IF EXISTS `count_invites_per_role_per_month` */;
/*!50001 DROP TABLE IF EXISTS `count_invites_per_role_per_month` */;

/*!50001 CREATE TABLE  `count_invites_per_role_per_month`(
 `year` int(4) ,
 `month` int(2) ,
 `user_role_type_id` smallint(6) ,
 `count_invites` bigint(21) 
)*/;

/*Table structure for table `count_invites_per_unit_per_month` */

DROP TABLE IF EXISTS `count_invites_per_unit_per_month`;

/*!50001 DROP VIEW IF EXISTS `count_invites_per_unit_per_month` */;
/*!50001 DROP TABLE IF EXISTS `count_invites_per_unit_per_month` */;

/*!50001 CREATE TABLE  `count_invites_per_unit_per_month`(
 `year` int(4) ,
 `month` int(2) ,
 `bz_unit_id` smallint(6) ,
 `count_invites` bigint(21) 
)*/;

/*Table structure for table `count_invites_per_unit_per_role_per_month` */

DROP TABLE IF EXISTS `count_invites_per_unit_per_role_per_month`;

/*!50001 DROP VIEW IF EXISTS `count_invites_per_unit_per_role_per_month` */;
/*!50001 DROP TABLE IF EXISTS `count_invites_per_unit_per_role_per_month` */;

/*!50001 CREATE TABLE  `count_invites_per_unit_per_role_per_month`(
 `year` int(4) ,
 `month` int(2) ,
 `bz_unit_id` smallint(6) ,
 `user_role_type_id` smallint(6) ,
 `invitation_sent` bigint(21) 
)*/;

/*Table structure for table `count_invites_per_user_per_month` */

DROP TABLE IF EXISTS `count_invites_per_user_per_month`;

/*!50001 DROP VIEW IF EXISTS `count_invites_per_user_per_month` */;
/*!50001 DROP TABLE IF EXISTS `count_invites_per_user_per_month` */;

/*!50001 CREATE TABLE  `count_invites_per_user_per_month`(
 `year` int(4) ,
 `month` int(2) ,
 `bzfe_invitor_user_id` mediumint(9) ,
 `invitation_sent` bigint(21) 
)*/;

/*Table structure for table `count_invitors_per_month` */

DROP TABLE IF EXISTS `count_invitors_per_month`;

/*!50001 DROP VIEW IF EXISTS `count_invitors_per_month` */;
/*!50001 DROP TABLE IF EXISTS `count_invitors_per_month` */;

/*!50001 CREATE TABLE  `count_invitors_per_month`(
 `year` int(4) ,
 `month` int(2) ,
 `count_invitors` bigint(21) 
)*/;

/*Table structure for table `count_new_cases_created_per_month` */

DROP TABLE IF EXISTS `count_new_cases_created_per_month`;

/*!50001 DROP VIEW IF EXISTS `count_new_cases_created_per_month` */;
/*!50001 DROP TABLE IF EXISTS `count_new_cases_created_per_month` */;

/*!50001 CREATE TABLE  `count_new_cases_created_per_month`(
 `year` int(4) ,
 `month` int(2) ,
 `count_cases` bigint(21) 
)*/;

/*Table structure for table `count_new_geographies_created_per_month` */

DROP TABLE IF EXISTS `count_new_geographies_created_per_month`;

/*!50001 DROP VIEW IF EXISTS `count_new_geographies_created_per_month` */;
/*!50001 DROP TABLE IF EXISTS `count_new_geographies_created_per_month` */;

/*!50001 CREATE TABLE  `count_new_geographies_created_per_month`(
 `year` int(4) ,
 `month` int(2) ,
 `new_geography` bigint(21) 
)*/;

/*Table structure for table `count_new_unit_created_per_month` */

DROP TABLE IF EXISTS `count_new_unit_created_per_month`;

/*!50001 DROP VIEW IF EXISTS `count_new_unit_created_per_month` */;
/*!50001 DROP TABLE IF EXISTS `count_new_unit_created_per_month` */;

/*!50001 CREATE TABLE  `count_new_unit_created_per_month`(
 `year` int(4) ,
 `month` int(2) ,
 `new_geography` bigint(21) 
)*/;

/*Table structure for table `count_new_user_created_per_month` */

DROP TABLE IF EXISTS `count_new_user_created_per_month`;

/*!50001 DROP VIEW IF EXISTS `count_new_user_created_per_month` */;
/*!50001 DROP TABLE IF EXISTS `count_new_user_created_per_month` */;

/*!50001 CREATE TABLE  `count_new_user_created_per_month`(
 `year` int(4) ,
 `month` int(2) ,
 `new_users` bigint(21) 
)*/;

/*Table structure for table `count_units_with_invitation_send` */

DROP TABLE IF EXISTS `count_units_with_invitation_send`;

/*!50001 DROP VIEW IF EXISTS `count_units_with_invitation_send` */;
/*!50001 DROP TABLE IF EXISTS `count_units_with_invitation_send` */;

/*!50001 CREATE TABLE  `count_units_with_invitation_send`(
 `year` int(4) ,
 `month` int(2) ,
 `count_units` bigint(21) 
)*/;

/*Table structure for table `flash_count_units_with_real_roles` */

DROP TABLE IF EXISTS `flash_count_units_with_real_roles`;

/*!50001 DROP VIEW IF EXISTS `flash_count_units_with_real_roles` */;
/*!50001 DROP TABLE IF EXISTS `flash_count_units_with_real_roles` */;

/*!50001 CREATE TABLE  `flash_count_units_with_real_roles`(
 `role_type_id` smallint(6) ,
 `units_with_real_users` bigint(21) ,
 `isactive` tinyint(4) 
)*/;

/*Table structure for table `flash_count_user_per_role_per_unit` */

DROP TABLE IF EXISTS `flash_count_user_per_role_per_unit`;

/*!50001 DROP VIEW IF EXISTS `flash_count_user_per_role_per_unit` */;
/*!50001 DROP TABLE IF EXISTS `flash_count_user_per_role_per_unit` */;

/*!50001 CREATE TABLE  `flash_count_user_per_role_per_unit`(
 `product_id` smallint(6) ,
 `role_type_id` smallint(6) ,
 `count_users` bigint(21) 
)*/;

/*Table structure for table `list_all_changes_to_components_default_assignee_dummy_users` */

DROP TABLE IF EXISTS `list_all_changes_to_components_default_assignee_dummy_users`;

/*!50001 DROP VIEW IF EXISTS `list_all_changes_to_components_default_assignee_dummy_users` */;
/*!50001 DROP TABLE IF EXISTS `list_all_changes_to_components_default_assignee_dummy_users` */;

/*!50001 CREATE TABLE  `list_all_changes_to_components_default_assignee_dummy_users`(
 `class` varchar(255) ,
 `removed` mediumtext ,
 `action_remove` varchar(24) ,
 `added` mediumtext ,
 `action_add` varchar(20) ,
 `component_id` int(11) ,
 `at_time` datetime 
)*/;

/*Table structure for table `list_changes_new_assignee_is_real` */

DROP TABLE IF EXISTS `list_changes_new_assignee_is_real`;

/*!50001 DROP VIEW IF EXISTS `list_changes_new_assignee_is_real` */;
/*!50001 DROP TABLE IF EXISTS `list_changes_new_assignee_is_real` */;

/*!50001 CREATE TABLE  `list_changes_new_assignee_is_real`(
 `product_id` smallint(6) ,
 `component_id` int(11) ,
 `removed` mediumtext ,
 `added` mediumtext ,
 `at_time` datetime ,
 `role_type_id` smallint(6) 
)*/;

/*Table structure for table `list_components_with_real_default_assignee` */

DROP TABLE IF EXISTS `list_components_with_real_default_assignee`;

/*!50001 DROP VIEW IF EXISTS `list_components_with_real_default_assignee` */;
/*!50001 DROP TABLE IF EXISTS `list_components_with_real_default_assignee` */;

/*!50001 CREATE TABLE  `list_components_with_real_default_assignee`(
 `product_id` smallint(6) ,
 `component_id` mediumint(9) ,
 `initialowner` mediumint(9) ,
 `role_type_id` smallint(6) ,
 `isactive` tinyint(4) 
)*/;

/*View structure for view count_invitation_per_invitee_per_month */

/*!50001 DROP TABLE IF EXISTS `count_invitation_per_invitee_per_month` */;
/*!50001 DROP VIEW IF EXISTS `count_invitation_per_invitee_per_month` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_invitation_per_invitee_per_month` AS select year(`ut_invitation_api_data`.`api_post_datetime`) AS `year`,month(`ut_invitation_api_data`.`api_post_datetime`) AS `month`,`ut_invitation_api_data`.`bz_user_id` AS `bz_user_id`,count(`ut_invitation_api_data`.`id`) AS `invitation_sent` from `ut_invitation_api_data` group by `ut_invitation_api_data`.`bz_user_id`,month(`ut_invitation_api_data`.`api_post_datetime`),year(`ut_invitation_api_data`.`api_post_datetime`) order by year(`ut_invitation_api_data`.`api_post_datetime`) desc,month(`ut_invitation_api_data`.`api_post_datetime`) desc,count(`ut_invitation_api_data`.`id`) desc */;

/*View structure for view count_invitees_per_month */

/*!50001 DROP TABLE IF EXISTS `count_invitees_per_month` */;
/*!50001 DROP VIEW IF EXISTS `count_invitees_per_month` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_invitees_per_month` AS select `count_invitation_per_invitee_per_month`.`year` AS `year`,`count_invitation_per_invitee_per_month`.`month` AS `month`,count(`count_invitation_per_invitee_per_month`.`bz_user_id`) AS `count_invitees` from `count_invitation_per_invitee_per_month` group by `count_invitation_per_invitee_per_month`.`month`,`count_invitation_per_invitee_per_month`.`year` order by `count_invitation_per_invitee_per_month`.`year` desc,`count_invitation_per_invitee_per_month`.`month` desc */;

/*View structure for view count_invites_per_month */

/*!50001 DROP TABLE IF EXISTS `count_invites_per_month` */;
/*!50001 DROP VIEW IF EXISTS `count_invites_per_month` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_invites_per_month` AS select `count_invites_per_unit_per_role_per_month`.`year` AS `year`,`count_invites_per_unit_per_role_per_month`.`month` AS `month`,count(`count_invites_per_unit_per_role_per_month`.`invitation_sent`) AS `count_invites` from `count_invites_per_unit_per_role_per_month` group by `count_invites_per_unit_per_role_per_month`.`month`,`count_invites_per_unit_per_role_per_month`.`year` order by `count_invites_per_unit_per_role_per_month`.`year` desc,`count_invites_per_unit_per_role_per_month`.`month` desc */;

/*View structure for view count_invites_per_role_per_month */

/*!50001 DROP TABLE IF EXISTS `count_invites_per_role_per_month` */;
/*!50001 DROP VIEW IF EXISTS `count_invites_per_role_per_month` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_invites_per_role_per_month` AS select `count_invites_per_unit_per_role_per_month`.`year` AS `year`,`count_invites_per_unit_per_role_per_month`.`month` AS `month`,`count_invites_per_unit_per_role_per_month`.`user_role_type_id` AS `user_role_type_id`,count(`count_invites_per_unit_per_role_per_month`.`invitation_sent`) AS `count_invites` from `count_invites_per_unit_per_role_per_month` group by `count_invites_per_unit_per_role_per_month`.`month`,`count_invites_per_unit_per_role_per_month`.`year`,`count_invites_per_unit_per_role_per_month`.`user_role_type_id` order by `count_invites_per_unit_per_role_per_month`.`year` desc,`count_invites_per_unit_per_role_per_month`.`month` desc,`count_invites_per_unit_per_role_per_month`.`user_role_type_id` */;

/*View structure for view count_invites_per_unit_per_month */

/*!50001 DROP TABLE IF EXISTS `count_invites_per_unit_per_month` */;
/*!50001 DROP VIEW IF EXISTS `count_invites_per_unit_per_month` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_invites_per_unit_per_month` AS select `count_invites_per_unit_per_role_per_month`.`year` AS `year`,`count_invites_per_unit_per_role_per_month`.`month` AS `month`,`count_invites_per_unit_per_role_per_month`.`bz_unit_id` AS `bz_unit_id`,count(`count_invites_per_unit_per_role_per_month`.`invitation_sent`) AS `count_invites` from `count_invites_per_unit_per_role_per_month` group by `count_invites_per_unit_per_role_per_month`.`month`,`count_invites_per_unit_per_role_per_month`.`year`,`count_invites_per_unit_per_role_per_month`.`bz_unit_id` order by `count_invites_per_unit_per_role_per_month`.`year` desc,`count_invites_per_unit_per_role_per_month`.`month` desc,`count_invites_per_unit_per_role_per_month`.`bz_unit_id` */;

/*View structure for view count_invites_per_unit_per_role_per_month */

/*!50001 DROP TABLE IF EXISTS `count_invites_per_unit_per_role_per_month` */;
/*!50001 DROP VIEW IF EXISTS `count_invites_per_unit_per_role_per_month` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_invites_per_unit_per_role_per_month` AS select year(`ut_invitation_api_data`.`api_post_datetime`) AS `year`,month(`ut_invitation_api_data`.`api_post_datetime`) AS `month`,`ut_invitation_api_data`.`bz_unit_id` AS `bz_unit_id`,`ut_invitation_api_data`.`user_role_type_id` AS `user_role_type_id`,count(`ut_invitation_api_data`.`id`) AS `invitation_sent` from `ut_invitation_api_data` group by `ut_invitation_api_data`.`bz_user_id`,month(`ut_invitation_api_data`.`api_post_datetime`),year(`ut_invitation_api_data`.`api_post_datetime`),`ut_invitation_api_data`.`bz_unit_id`,`ut_invitation_api_data`.`user_role_type_id` order by year(`ut_invitation_api_data`.`api_post_datetime`) desc,month(`ut_invitation_api_data`.`api_post_datetime`) desc,`ut_invitation_api_data`.`user_role_type_id`,`ut_invitation_api_data`.`bz_unit_id`,count(`ut_invitation_api_data`.`id`) desc */;

/*View structure for view count_invites_per_user_per_month */

/*!50001 DROP TABLE IF EXISTS `count_invites_per_user_per_month` */;
/*!50001 DROP VIEW IF EXISTS `count_invites_per_user_per_month` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_invites_per_user_per_month` AS select year(`ut_invitation_api_data`.`api_post_datetime`) AS `year`,month(`ut_invitation_api_data`.`api_post_datetime`) AS `month`,`ut_invitation_api_data`.`bzfe_invitor_user_id` AS `bzfe_invitor_user_id`,count(`ut_invitation_api_data`.`id`) AS `invitation_sent` from `ut_invitation_api_data` group by `ut_invitation_api_data`.`bzfe_invitor_user_id`,month(`ut_invitation_api_data`.`api_post_datetime`),year(`ut_invitation_api_data`.`api_post_datetime`) order by year(`ut_invitation_api_data`.`api_post_datetime`) desc,month(`ut_invitation_api_data`.`api_post_datetime`) desc */;

/*View structure for view count_invitors_per_month */

/*!50001 DROP TABLE IF EXISTS `count_invitors_per_month` */;
/*!50001 DROP VIEW IF EXISTS `count_invitors_per_month` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_invitors_per_month` AS select `count_invites_per_user_per_month`.`year` AS `year`,`count_invites_per_user_per_month`.`month` AS `month`,count(`count_invites_per_user_per_month`.`bzfe_invitor_user_id`) AS `count_invitors` from `count_invites_per_user_per_month` group by `count_invites_per_user_per_month`.`month`,`count_invites_per_user_per_month`.`year` order by `count_invites_per_user_per_month`.`year` desc,`count_invites_per_user_per_month`.`month` desc */;

/*View structure for view count_new_cases_created_per_month */

/*!50001 DROP TABLE IF EXISTS `count_new_cases_created_per_month` */;
/*!50001 DROP VIEW IF EXISTS `count_new_cases_created_per_month` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_new_cases_created_per_month` AS select year(`bugs`.`creation_ts`) AS `year`,month(`bugs`.`creation_ts`) AS `month`,count(`bugs`.`bug_id`) AS `count_cases` from `bugs` group by year(`bugs`.`creation_ts`),month(`bugs`.`creation_ts`) order by `bugs`.`creation_ts` desc */;

/*View structure for view count_new_geographies_created_per_month */

/*!50001 DROP TABLE IF EXISTS `count_new_geographies_created_per_month` */;
/*!50001 DROP VIEW IF EXISTS `count_new_geographies_created_per_month` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_new_geographies_created_per_month` AS select year(`audit_log`.`at_time`) AS `year`,month(`audit_log`.`at_time`) AS `month`,count(`audit_log`.`object_id`) AS `new_geography` from `audit_log` where ((`audit_log`.`class` = 'Bugzilla::Classification') and (`audit_log`.`field` = '__create__')) group by year(`audit_log`.`at_time`),month(`audit_log`.`at_time`) order by `audit_log`.`at_time` desc */;

/*View structure for view count_new_unit_created_per_month */

/*!50001 DROP TABLE IF EXISTS `count_new_unit_created_per_month` */;
/*!50001 DROP VIEW IF EXISTS `count_new_unit_created_per_month` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_new_unit_created_per_month` AS select year(`audit_log`.`at_time`) AS `year`,month(`audit_log`.`at_time`) AS `month`,count(`audit_log`.`object_id`) AS `new_geography` from `audit_log` where ((`audit_log`.`class` = 'Bugzilla::Classification') and (`audit_log`.`field` = '__create__')) group by year(`audit_log`.`at_time`),month(`audit_log`.`at_time`) order by `audit_log`.`at_time` desc */;

/*View structure for view count_new_user_created_per_month */

/*!50001 DROP TABLE IF EXISTS `count_new_user_created_per_month` */;
/*!50001 DROP VIEW IF EXISTS `count_new_user_created_per_month` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_new_user_created_per_month` AS select year(`audit_log`.`at_time`) AS `year`,month(`audit_log`.`at_time`) AS `month`,count(`audit_log`.`object_id`) AS `new_users` from `audit_log` where ((`audit_log`.`class` = 'Bugzilla::User') and (`audit_log`.`field` = '__create__')) group by year(`audit_log`.`at_time`),month(`audit_log`.`at_time`) order by `audit_log`.`at_time` desc */;

/*View structure for view count_units_with_invitation_send */

/*!50001 DROP TABLE IF EXISTS `count_units_with_invitation_send` */;
/*!50001 DROP VIEW IF EXISTS `count_units_with_invitation_send` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_units_with_invitation_send` AS select `count_invites_per_unit_per_month`.`year` AS `year`,`count_invites_per_unit_per_month`.`month` AS `month`,count(`count_invites_per_unit_per_month`.`bz_unit_id`) AS `count_units` from `count_invites_per_unit_per_month` group by `count_invites_per_unit_per_month`.`month`,`count_invites_per_unit_per_month`.`year` order by `count_invites_per_unit_per_month`.`year` desc,`count_invites_per_unit_per_month`.`month` desc */;

/*View structure for view flash_count_units_with_real_roles */

/*!50001 DROP TABLE IF EXISTS `flash_count_units_with_real_roles` */;
/*!50001 DROP VIEW IF EXISTS `flash_count_units_with_real_roles` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `flash_count_units_with_real_roles` AS select `list_components_with_real_default_assignee`.`role_type_id` AS `role_type_id`,count(`list_components_with_real_default_assignee`.`product_id`) AS `units_with_real_users`,`list_components_with_real_default_assignee`.`isactive` AS `isactive` from `list_components_with_real_default_assignee` group by `list_components_with_real_default_assignee`.`role_type_id`,`list_components_with_real_default_assignee`.`isactive` order by `list_components_with_real_default_assignee`.`isactive` desc,`list_components_with_real_default_assignee`.`role_type_id` */;

/*View structure for view flash_count_user_per_role_per_unit */

/*!50001 DROP TABLE IF EXISTS `flash_count_user_per_role_per_unit` */;
/*!50001 DROP VIEW IF EXISTS `flash_count_user_per_role_per_unit` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `flash_count_user_per_role_per_unit` AS select `ut_product_group`.`product_id` AS `product_id`,`ut_product_group`.`role_type_id` AS `role_type_id`,count(`profiles`.`userid`) AS `count_users` from ((`user_group_map` join `profiles` on((`user_group_map`.`user_id` = `profiles`.`userid`))) join `ut_product_group` on((`user_group_map`.`group_id` = `ut_product_group`.`group_id`))) where ((`ut_product_group`.`role_type_id` is not null) and (`ut_product_group`.`group_type_id` = 2) and (`user_group_map`.`isbless` = 0)) group by `ut_product_group`.`product_id`,`ut_product_group`.`role_type_id`,`user_group_map`.`group_id` */;

/*View structure for view list_all_changes_to_components_default_assignee_dummy_users */

/*!50001 DROP TABLE IF EXISTS `list_all_changes_to_components_default_assignee_dummy_users` */;
/*!50001 DROP VIEW IF EXISTS `list_all_changes_to_components_default_assignee_dummy_users` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `list_all_changes_to_components_default_assignee_dummy_users` AS select `audit_log`.`class` AS `class`,`audit_log`.`removed` AS `removed`,if((`audit_log`.`removed` = 93),'replace_dummy_tenant',if((`audit_log`.`removed` = 91),'replace_dummy_landlord',if((`audit_log`.`removed` = 90),'replace_dummy_contractor',if((`audit_log`.`removed` = 92),'replace_dummy_mgt_cny',if((`audit_log`.`removed` = 89),'replace_dummy_agent','dummy_user_not_removed'))))) AS `action_remove`,`audit_log`.`added` AS `added`,if((`audit_log`.`added` = 92),'use_dummy_tenant',if((`audit_log`.`added` = 91),'use_dummy_landlord',if((`audit_log`.`added` = 90),'use_dummy_contractor',if((`audit_log`.`added` = 92),'use_dummy_mgt_cny',if((`audit_log`.`added` = 89),'use_dummy_agent','dummy_user_not_added'))))) AS `action_add`,`audit_log`.`object_id` AS `component_id`,`audit_log`.`at_time` AS `at_time` from `audit_log` where (((`audit_log`.`class` = 'Bugzilla::Component') and (`audit_log`.`field` = 'initialowner') and (`audit_log`.`removed` = 92)) or ((`audit_log`.`class` = 'Bugzilla::Component') and (`audit_log`.`field` = 'initialowner') and (`audit_log`.`removed` = 91)) or ((`audit_log`.`class` = 'Bugzilla::Component') and (`audit_log`.`field` = 'initialowner') and (`audit_log`.`removed` = 90)) or ((`audit_log`.`class` = 'Bugzilla::Component') and (`audit_log`.`field` = 'initialowner') and (`audit_log`.`removed` = 92)) or ((`audit_log`.`class` = 'Bugzilla::Component') and (`audit_log`.`field` = 'initialowner') and (`audit_log`.`removed` = 89)) or ((`audit_log`.`class` = 'Bugzilla::Component') and (`audit_log`.`field` = 'initialowner') and (`audit_log`.`added` = 92)) or ((`audit_log`.`class` = 'Bugzilla::Component') and (`audit_log`.`field` = 'initialowner') and (`audit_log`.`added` = 91)) or ((`audit_log`.`class` = 'Bugzilla::Component') and (`audit_log`.`field` = 'initialowner') and (`audit_log`.`added` = 90)) or ((`audit_log`.`class` = 'Bugzilla::Component') and (`audit_log`.`field` = 'initialowner') and (`audit_log`.`added` = 92)) or ((`audit_log`.`class` = 'Bugzilla::Component') and (`audit_log`.`field` = 'initialowner') and (`audit_log`.`added` = 89))) */;

/*View structure for view list_changes_new_assignee_is_real */

/*!50001 DROP TABLE IF EXISTS `list_changes_new_assignee_is_real` */;
/*!50001 DROP VIEW IF EXISTS `list_changes_new_assignee_is_real` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `list_changes_new_assignee_is_real` AS select `ut_product_group`.`product_id` AS `product_id`,`audit_log`.`object_id` AS `component_id`,`audit_log`.`removed` AS `removed`,`audit_log`.`added` AS `added`,`audit_log`.`at_time` AS `at_time`,`ut_product_group`.`role_type_id` AS `role_type_id` from (`audit_log` join `ut_product_group` on((`audit_log`.`object_id` = `ut_product_group`.`component_id`))) where ((`audit_log`.`class` = 'Bugzilla::Component') and (`audit_log`.`field` = 'initialowner') and (`audit_log`.`added` <> 4) and (`audit_log`.`added` <> 3) and (`audit_log`.`added` <> 5) and (`audit_log`.`added` <> 6) and (`audit_log`.`added` <> 2)) group by `audit_log`.`object_id`,`ut_product_group`.`role_type_id` order by `audit_log`.`at_time` desc,`ut_product_group`.`product_id`,`audit_log`.`object_id` */;

/*View structure for view list_components_with_real_default_assignee */

/*!50001 DROP TABLE IF EXISTS `list_components_with_real_default_assignee` */;
/*!50001 DROP VIEW IF EXISTS `list_components_with_real_default_assignee` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `list_components_with_real_default_assignee` AS select `ut_product_group`.`product_id` AS `product_id`,`components`.`id` AS `component_id`,`components`.`initialowner` AS `initialowner`,`ut_product_group`.`role_type_id` AS `role_type_id`,`products`.`isactive` AS `isactive` from ((`components` join `ut_product_group` on((`components`.`id` = `ut_product_group`.`component_id`))) join `products` on((`ut_product_group`.`product_id` = `products`.`id`))) where ((`components`.`initialowner` <> 93) and (`components`.`initialowner` <> 91) and (`components`.`initialowner` <> 90) and (`components`.`initialowner` <> 92) and (`components`.`initialowner` <> 89) and (`ut_product_group`.`role_type_id` is not null)) group by `ut_product_group`.`product_id`,`components`.`id`,`ut_product_group`.`role_type_id` order by `ut_product_group`.`product_id`,`components`.`id` */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
