# Correct some typos in the field names and FK in the table 'ut_permission_types'

	/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

	/* Alter table in target */
	ALTER TABLE `ut_permission_types` 
		ADD COLUMN `id_permission_type` smallint(6)   NOT NULL auto_increment COMMENT 'ID in this table' first , 
		CHANGE `created` `created` datetime   NULL COMMENT 'creation ts' after `id_permission_type` , 
		DROP COLUMN `id_permissin_type` , 
		ADD KEY `permission_groupe_type`(`group_type_id`) , 
		DROP KEY `premission_groupe_type` , 
		DROP KEY `PRIMARY`, ADD PRIMARY KEY(`id_permission_type`,`permission_type`) , 
		DROP FOREIGN KEY `premission_groupe_type`  ;
	ALTER TABLE `ut_permission_types`
		ADD CONSTRAINT `permission_groupe_type` 
		FOREIGN KEY (`group_type_id`) REFERENCES `ut_group_types` (`id_group_type`) ON DELETE CASCADE ON UPDATE CASCADE ;

	/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
	
# Create a table to do bulk import of units in 

	/*!40101 SET NAMES utf8 */;

	/*!40101 SET SQL_MODE=''*/;

	/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
	/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
	/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
	/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
	/*Table structure for table `ut_data_to_create_units` */

	DROP TABLE IF EXISTS `ut_data_to_create_units`;

	CREATE TABLE `ut_data_to_create_units` (
	  `id_unit_to_create` int(11) NOT NULL AUTO_INCREMENT COMMENT 'The unique ID in this table',
	  `mefe_creator_user_id` int(11) DEFAULT NULL COMMENT 'The id of the creator of this unit in the MEFE database',
	  `mefe_id` int(11) DEFAULT NULL COMMENT 'The id of this unit in the MEFE database',
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
	) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

	/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
	/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
	/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
	/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

# Create a table to map BZFE and MEFE users.
	
	CREATE TABLE `ut_map_user_mefe_bzfe`(
		`created` datetime NULL  COMMENT 'creation ts' , 
		`record_created_by` smallint(6) NULL  COMMENT 'id of the user who created this user in the bz `profiles` table' , 
		`is_obsolete` tinyint(1) NOT NULL  DEFAULT 0 COMMENT 'This is an obsolete record' , 
		`bzfe_update_needed` tinyint(1) NULL  DEFAULT 0 COMMENT 'Do we need to update this record in the BZFE - This is to keep track of the user that have been modified in the MEFE but NOT yet in the BZFE' , 
		`user_id` int(11) NULL  COMMENT 'id of the user in the MEFE' , 
		`bz_profile_id` mediumint(6) NULL  COMMENT 'id of the user in the BZFE' , 
		`comment` text COLLATE utf8_general_ci NULL  COMMENT 'Any comment' 
	) ENGINE=InnoDB DEFAULT CHARSET='utf8' COLLATE='utf8_general_ci';

# Create a table to manage the invitations process
# This is needed to automated the following processes:
#	- Invite user to a unit in a given role
#	- Invite user to a unit in a given role AND invite the user to collaborate on a case.
#		- As Assignee
#		- As CC for the case.
	
# Create a table for all the permissions given to a user for a given unit

