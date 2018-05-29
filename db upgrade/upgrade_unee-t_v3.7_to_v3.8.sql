# For any question about this script, ask Franck
#
###################################################################################
#
# WARNING! It is recommended to use Amazon Aurora database engine for this version
#
#	- for the DEV/Staging environment, make sure to run the script `db_v3.6+_adjustments_for_DEV_environment.sql` AFTER this one
#	  This is needed to make sure the values for the dummy user (bz user id)  are correct for the DEV/Staging envo
#
###################################################################################
#
############################################
#
# Make sure to update the below variable(s)
#
############################################
#
# What are the version of the Unee-T BZ Database schema BEFORE and AFTER this update?
	SET @old_schema_version = 'v3.7';
	SET @new_schema_version = 'v3.8';
#
# What is the name of this script?
	SET @this_script = 'upgrade_unee-t_v3.7_to_v3.8.sql';
#
###############################
#
# We have everything we need
#
###############################
# This update 
#	- corrects a typo in a field name for the table `ut_permission_types`
#	- Create a table `ut_invitation_types` to list and define the type of invites that we need to process
#		- type_cc
#		- type_assignee
#		- etc...
#	- Modify the table `ut_invitation_api_data` to add a FK to the list of invitation types.
#WIP	- Create a table `ut_map_invitation_type_permission_type` to map the invitation types and the permission types
#
#
#
#
#

# When are we doing this?
	SET @the_timestamp = NOW();

# Corrects a typo in a field name for the table `ut_permission_types`

	/* Foreign Keys must be dropped in the target to ensure that requires changes can be done*/

	ALTER TABLE `ut_permission_types` 
		DROP FOREIGN KEY `premission_groupe_type`;


	/* Alter table in target */
	ALTER TABLE `ut_permission_types` 
		ADD COLUMN `id_permission_type` smallint(6)   NOT NULL auto_increment COMMENT 'ID in this table' first , 
		CHANGE `created` `created` datetime   NULL COMMENT 'creation ts' after `id_permission_type` , 
		DROP COLUMN `id_permissin_type` , 
		DROP KEY `PRIMARY`, ADD PRIMARY KEY(`id_permission_type`,`permission_type`) 
		;
		
	/* The foreign keys that were dropped are now re-created*/

	ALTER TABLE `ut_permission_types` 
		ADD CONSTRAINT `premission_groupe_type` 
		FOREIGN KEY (`group_type_id`) REFERENCES `ut_group_types` (`id_group_type`) ON DELETE CASCADE ON UPDATE CASCADE ;
		
# Create a table `ut_invitation_types` to list and define the type of invites that we need to process

	# Create the table
		
		DROP TABLE IF EXISTS `ut_invitation_types`;

		CREATE TABLE `ut_invitation_types`(
			`id_invitation_type` smallint(6) NOT NULL  auto_increment COMMENT 'ID in this table' , 
			`created` datetime NULL  COMMENT 'creation ts' , 
			`order` smallint(6) NULL  COMMENT 'Order in the list' , 
			`is_active` tinyint(1) NULL  DEFAULT 0 COMMENT '1 if this is an active invitation: we have the scripts to process these' , 
			`invitation_type` varchar(255) COLLATE utf8_general_ci NOT NULL  COMMENT 'A name for this invitation type' , 
			`detailed_description` text COLLATE utf8_general_ci NULL  COMMENT 'Detailed description of this group type' , 
			PRIMARY KEY (`id_invitation_type`,`invitation_type`) , 
			UNIQUE KEY `invitation_type_is_unique`(`invitation_type`) 
		) ENGINE=InnoDB DEFAULT CHARSET='utf8' COLLATE='utf8_general_ci' ROW_FORMAT=Dynamic;

	# Add the values we need in this table:

		INSERT  INTO `ut_invitation_types`(`id_invitation_type`,`created`,`order`,`is_active`,`invitation_type`,`detailed_description`) VALUES 
		(1,'2018-05-30 00:36:17',10,1,'type_assigned',NULL),
		(2,'2018-05-30 00:37:02',20,1,'type_cc',NULL),
		(3,'2018-05-30 00:38:46',30,0,'replace_default','- Grant the permissions to the invited user for this role for this unit\r\nand \r\n- Remove the existing default user for this role\r\nand \r\n- Replace the default user for this role '),
		(4,'2018-05-30 00:39:57',40,0,'default_cc_all','- Grant the permissions to the invited user for this role for this unit\r\nand\r\n- Keep the existing default user as default\r\nand\r\n- Make the invited user an automatic CC to all the new cases for this role for this unit'),
		(5,'2018-05-30 00:40:33',50,0,'keep_default','- Grant the permissions to the inviter user for this role for this unit\r\nand \r\n- Keep the existing default user as default\r\nand\r\n- Check if this new user is the first in this role for this unit.\r\n	- If it IS the first in this role for this unit.\r\n	  Then Replace the Default \'dummy user\' for this specific role with the BZ user in CC for this role for this unit.\r\n	- If it is NOT the first in this role for this unit.\r\n	  Do Nothing');	
		
# Modify the table `ut_invitation_api_data` to add a FK to the list of invitation types.
		
	/* Foreign Keys must be dropped in the target to ensure that requires changes can be done*/

	ALTER TABLE `ut_invitation_api_data` 
		DROP FOREIGN KEY `invitation_bz_bug_must_exist`  , 
		DROP FOREIGN KEY `invitation_bz_invitee_must_exist`  , 
		DROP FOREIGN KEY `invitation_bz_invitor_must_exist`  , 
		DROP FOREIGN KEY `invitation_bz_product_must_exist`  ;

	/* Alter table in target */
	ALTER TABLE `ut_invitation_api_data` 
		CHANGE `invitation_type` `invitation_type` varchar(255)  COLLATE utf8_general_ci NULL COMMENT 'The type of the invitation (assigned or CC)' after `bz_unit_id` , 
		ADD KEY `invitation_invitation_type_must_exist`(`invitation_type`) ;
	ALTER TABLE `ut_invitation_api_data`
		ADD CONSTRAINT `invitation_invitation_type_must_exist` 
		FOREIGN KEY (`invitation_type`) REFERENCES `ut_invitation_types` (`invitation_type`) ;

	/* The foreign keys that were dropped are now re-created*/

	ALTER TABLE `ut_invitation_api_data` 
		ADD CONSTRAINT `invitation_bz_bug_must_exist` 
		FOREIGN KEY (`bz_case_id`) REFERENCES `bugs` (`bug_id`) , 
		ADD CONSTRAINT `invitation_bz_invitee_must_exist` 
		FOREIGN KEY (`bz_user_id`) REFERENCES `profiles` (`userid`) , 
		ADD CONSTRAINT `invitation_bz_invitor_must_exist` 
		FOREIGN KEY (`bzfe_invitor_user_id`) REFERENCES `profiles` (`userid`) , 
		ADD CONSTRAINT `invitation_bz_product_must_exist` 
		FOREIGN KEY (`bz_unit_id`) REFERENCES `products` (`id`) ;		
		
# Create a table `ut_map_invitation_type_permission_type` to map the invitation types and the permission types

###########
#
#	WIP
#
###########
	











	
	
# Create the procedure to insert a record in the table `ut_log_count_closed_cases`
	
DROP PROCEDURE IF EXISTS update_log_count_closed_case;

DELIMITER $$
CREATE PROCEDURE update_log_count_closed_case()
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

	# We have everything: insert in the log table
		INSERT INTO `ut_log_count_closed_cases`
			(`timestamp`
			, `count_closed_cases`
			)
			VALUES
			(@timestamp
			, @count_closed_cases
			)
			;
END $$
DELIMITER ;








# We can now update the version of the database schema
	# A comment for the update
		SET @comment_update_schema_version = CONCAT (
			'Database updated from '
			, @old_schema_version
			, ' to '
			, @new_schema_version
		)
		;
	
	# We record that the table has been updated to the new version.
	INSERT INTO `ut_db_schema_version`
		(`schema_version`
		, `update_datetime`
		, `update_script`
		, `comment`
		)
		VALUES
		(@new_schema_version
		, @the_timestamp
		, @this_script
		, @comment_update_schema_version
		)
		;