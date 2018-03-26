# This update facilitates and speed up the invitation process


# We create a new table 'ut_invitation_api_data' which captures the information from the Invitation API

	/*!40101 SET NAMES utf8 */;

	/*!40101 SET SQL_MODE=''*/;

	/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
	/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
	/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
	/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

	/*Table structure for table `ut_invitation_api_data` */

	DROP TABLE IF EXISTS `ut_invitation_api_data`;

	CREATE TABLE `ut_invitation_api_data` (
	  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'The unique ID in this table',
	  `mefe_invitation_id` varchar(256) DEFAULT NULL COMMENT 'The unique Id for the invitation that was generated in MEFE to do the data import',
	  `bzfe_invitor_user_id` mediumint(9) NOT NULL COMMENT 'The BZFE user id who creates this unit. this is a FK to the BZ table ''profiles''',
	  `bz_user_id` mediumint(9) NOT NULL COMMENT 'The userid for the user that will be rfeplcing the dummy user for this role for this unit. This is a FK to the BZ table ''profiles''',
	  `user_role_type_id` smallint(6) NOT NULL COMMENT 'The id of the role type for the invited user. This is a FK to the table ''ut_role_types''',
	  `is_occupant` tinyint(1) DEFAULT 0 COMMENT '1 if TRUE, 0 if FALSE',
	  `bz_case_id` mediumint(9) DEFAULT NULL COMMENT 'The id of the bug in th table ''bugs''',
	  `bz_unit_id` smallint(6) NOT NULL COMMENT 'The product id in the BZ table ''products''',
	  `invitation_type` varchar(100) DEFAULT NULL COMMENT 'The type of the invitation (assigned or CC)',
	  `is_mefe_only_user` tinyint(1) DEFAULT 1 COMMENT '1 if the user is a MEFE only user. In this scenario, we will DISABLE the claim mail in the BZFE for that user',
	  `user_more` varchar(500) DEFAULT '' COMMENT 'A text to give more information about the user. This will be used in the BZ Component Description',
	  `mefe_invitor_user_id` varchar(256) DEFAULT NULL COMMENT 'The id of the creator of this unit in the MEFE database',
	  `api_post_datetime` datetime DEFAULT NULL COMMENT 'Date and time when this invitation has been posted as porcessed via the Unee-T inviation API'
	  PRIMARY KEY (`id`)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;

	/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
	/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
	/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
	/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


	/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

# We alter the table when we replace a dummy user to verify if this 

/* Foreign Keys must be dropped in the target to ensure that requires changes can be done*/

	ALTER TABLE `ut_data_to_replace_dummy_roles` 
		DROP FOREIGN KEY `replace_dummy_product_id`  , 
		DROP FOREIGN KEY `replace_dummy_role_bz_user_id`  , 
		DROP FOREIGN KEY `replace_dummy_role_invitor_bz_user_id`  , 
		DROP FOREIGN KEY `replace_dummy_role_role_type`  ;


	/* Alter table in target */
	ALTER TABLE `ut_data_to_replace_dummy_roles` 
		ADD COLUMN `is_mefe_user_only` tinyint(1)   NULL DEFAULT 1 COMMENT '1 (default value) if TRUE - If a user is a MEFE user only we disable the claim mail in the BZFE' after `is_occupant` , 
		CHANGE `user_more` `user_more` varchar(500)  COLLATE utf8_general_ci NULL DEFAULT '' COMMENT 'A text to give more information about the user. This will be used in the BZ Component Description' after `is_mefe_user_only` ;

	/* The foreign keys that were dropped are now re-created*/

	ALTER TABLE `ut_data_to_replace_dummy_roles` 
		ADD CONSTRAINT `replace_dummy_product_id` 
		FOREIGN KEY (`bz_unit_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE , 
		ADD CONSTRAINT `replace_dummy_role_bz_user_id` 
		FOREIGN KEY (`bz_user_id`) REFERENCES `profiles` (`userid`) ON DELETE NO ACTION ON UPDATE CASCADE , 
		ADD CONSTRAINT `replace_dummy_role_invitor_bz_user_id` 
		FOREIGN KEY (`bzfe_invitor_user_id`) REFERENCES `profiles` (`userid`) ON DELETE NO ACTION ON UPDATE CASCADE , 
		ADD CONSTRAINT `replace_dummy_role_role_type` 
		FOREIGN KEY (`user_role_type_id`) REFERENCES `ut_role_types` (`id_role_type`) ON DELETE NO ACTION ON UPDATE CASCADE ;
