# Correct some typos in the field names and FK in the table 'ut_permission_types'

	/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

	/* Alter table in target */
	ALTER TABLE `ut_permission_types` 
		ADD COLUMN `id_permission_type` SMALLINT(6)   NOT NULL AUTO_INCREMENT COMMENT 'ID in this table' FIRST , 
		CHANGE `created` `created` DATETIME   NULL COMMENT 'creation ts' AFTER `id_permission_type` , 
		DROP COLUMN `id_permissin_type` , 
		ADD KEY `permission_groupe_type`(`group_type_id`) , 
		DROP KEY `premission_groupe_type` , 
		DROP KEY `PRIMARY`, ADD PRIMARY KEY(`id_permission_type`,`permission_type`) , 
		DROP FOREIGN KEY `premission_groupe_type`  ;
	ALTER TABLE `ut_permission_types`
		ADD CONSTRAINT `permission_groupe_type` 
		FOREIGN KEY (`group_type_id`) REFERENCES `ut_group_types` (`id_group_type`) ON DELETE CASCADE ON UPDATE CASCADE ;

	/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
	
# Create a table to do bulk import of units 

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

	/*Table structure for table `ut_data_to_create_units` */

	DROP TABLE IF EXISTS `ut_data_to_create_units`;

	CREATE TABLE `ut_data_to_create_units` (
	  `id_unit_to_create` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'The unique ID in this table',
	  `mefe_id` INT(11) DEFAULT NULL COMMENT 'The id of the object in the MEFE interface where these information are coming from',
	  `mefe_creator_user_id` INT(11) DEFAULT NULL COMMENT 'The id of the creator of this unit in the MEFE database',
	  `mefe_unit_id` INT(11) DEFAULT NULL COMMENT 'The id of this unit in the MEFE database',
	  `bzfe_creator_user_id` MEDIUMINT(9) NOT NULL COMMENT 'The BZFE user id who creates this unit. this is a FK to the BZ table ''profiles''',
	  `classification_id` SMALLINT(6) NOT NULL COMMENT 'The ID of the classification for this unit - a FK to the BZ table ''classifications''',
	  `unit_name` VARCHAR(54) NOT NULL DEFAULT '' COMMENT 'A name for the unit. We will append the product id and this will be inserted in the product name field of the BZ tabele product which has a max lenght of 64',
	  `unit_id` VARCHAR(54) DEFAULT '' COMMENT 'The id of the unit',
	  `unit_condo` VARCHAR(50) DEFAULT '' COMMENT 'The name of the condo or buildig for the unit',
	  `unit_surface` VARCHAR(10) DEFAULT '' COMMENT 'The surface of the unit - this is a number - it can be sqm or sqf',
	  `unit_surface_measure` TINYINT(1) DEFAULT NULL COMMENT '1 is for square feet (sqf) - 2 is for square meters (sqm)',
	  `unit_description_details` VARCHAR(500) DEFAULT '' COMMENT 'More information about the unit - this is a free text space',
	  `unit_address` VARCHAR(500) DEFAULT '' COMMENT 'The address of the unit',
	  `matterport_url` VARCHAR(256) DEFAULT '' COMMENT 'LMB specific - a the URL for the matterport visit for this unit',
	  `bz_created_date` DATETIME DEFAULT NULL COMMENT 'Date and time when this unit has been created in the BZ databae',
	  `comment` TEXT DEFAULT NULL COMMENT 'Any comment',
	  PRIMARY KEY (`id_unit_to_create`),
	  KEY `id_unit_creator_id` (`bzfe_creator_user_id`),
	  KEY `id_unit_classification_id` (`classification_id`),
	  CONSTRAINT `id_unit_classification_id` FOREIGN KEY (`classification_id`) REFERENCES `classifications` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	  CONSTRAINT `id_unit_creator_id` FOREIGN KEY (`bzfe_creator_user_id`) REFERENCES `profiles` (`userid`) ON DELETE NO ACTION ON UPDATE CASCADE
	) ENGINE=INNODB DEFAULT CHARSET=utf8;


# Create a table to do bulk import of user in 'real' role for several units

	/*Table structure for table `ut_data_to_replace_dummy_roles` */

	DROP TABLE IF EXISTS `ut_data_to_replace_dummy_roles`;

	CREATE TABLE `ut_data_to_replace_dummy_roles` (
	  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'The unique ID in this table',
	  `mefe_invitation_id` INT(11) DEFAULT NULL COMMENT 'The unique Id for the invitation that was generated in MEFE to do the data import',
	  `mefe_invitor_user_id` INT(11) DEFAULT NULL COMMENT 'The id of the creator of this unit in the MEFE database',
	  `bzfe_invitor_user_id` MEDIUMINT(9) NOT NULL COMMENT 'The BZFE user id who creates this unit. this is a FK to the BZ table ''profiles''',
	  `bz_unit_id` SMALLINT(6) NOT NULL COMMENT 'The product id in the BZ table ''products''',
	  `bz_user_id` MEDIUMINT(9) NOT NULL COMMENT 'The userid for the user that will be rfeplcing the dummy user for this role for this unit. This is a FK to the BZ table ''profiles''',
	  `user_role_type_id` SMALLINT(6) NOT NULL COMMENT 'The id of the role type for the invited user. This is a FK to the table ''ut_role_types''',
	  `is_occupant` TINYINT(1) DEFAULT 0 COMMENT '1 if TRUE, 0 if FALSE',
	  `user_more` VARCHAR(500) DEFAULT '' COMMENT 'A text to give more information about the user. This will be used in the BZ Component Description',
	  `bz_created_date` DATETIME DEFAULT NULL COMMENT 'Date and time when this unit has been created in the BZ databae',
	  `comment` TEXT DEFAULT NULL COMMENT 'Any comment',
	  PRIMARY KEY (`id`),
	  KEY `replace_dummy_role_role_type` (`user_role_type_id`),
	  KEY `replace_dummy_role_bz_user_id` (`bz_user_id`),
	  KEY `replace_dummy_role_invitor_bz_user_id` (`bzfe_invitor_user_id`),
	  KEY `replace_dummy_product_id` (`bz_unit_id`),
	  CONSTRAINT `replace_dummy_product_id` FOREIGN KEY (`bz_unit_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
	  CONSTRAINT `replace_dummy_role_bz_user_id` FOREIGN KEY (`bz_user_id`) REFERENCES `profiles` (`userid`) ON DELETE NO ACTION ON UPDATE CASCADE,
	  CONSTRAINT `replace_dummy_role_invitor_bz_user_id` FOREIGN KEY (`bzfe_invitor_user_id`) REFERENCES `profiles` (`userid`) ON DELETE NO ACTION ON UPDATE CASCADE,
	  CONSTRAINT `replace_dummy_role_role_type` FOREIGN KEY (`user_role_type_id`) REFERENCES `ut_role_types` (`id_role_type`) ON DELETE NO ACTION ON UPDATE CASCADE
	) ENGINE=INNODB DEFAULT CHARSET=utf8;

# Create a table to do bulk import of additional users in role for units

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

	
	
# Create a table to map BZFE and MEFE users.

	DROP TABLE IF EXISTS `ut_map_user_mefe_bzfe`;
	
	CREATE TABLE `ut_map_user_mefe_bzfe`(
		`created` DATETIME NULL  COMMENT 'creation ts' , 
		`record_created_by` SMALLINT(6) NULL  COMMENT 'id of the user who created this user in the bz `profiles` table' , 
		`is_obsolete` TINYINT(1) NOT NULL  DEFAULT 0 COMMENT 'This is an obsolete record' , 
		`bzfe_update_needed` TINYINT(1) NULL  DEFAULT 0 COMMENT 'Do we need to update this record in the BZFE - This is to keep track of the user that have been modified in the MEFE but NOT yet in the BZFE' , 
		`user_id` INT(11) NULL  COMMENT 'id of the user in the MEFE' , 
		`bz_profile_id` MEDIUMINT(6) NULL  COMMENT 'id of the user in the BZFE' , 
		`comment` TEXT COLLATE utf8_general_ci NULL  COMMENT 'Any comment' 
	) ENGINE=INNODB DEFAULT CHARSET='utf8' COLLATE='utf8_general_ci';

	
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;