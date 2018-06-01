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
	SET @old_schema_version = 'v3.7.2';
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
#	- Creates a table `ut_invitation_types` to list and define the type of invites that we need to process
#		- type_cc
#		- type_assignee
#		- etc...
#	- Modifies the table `ut_invitation_api_data` to add a FK to the list of invitation types.
#	- Creates a table `ut_map_invitation_type_to_permission_type` to map the invitation types and the permission types
#	- Creates a procedure `remove_user_from_default_cc` to remove a user in Default CC from a given role
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
		
# Create a table `ut_map_invitation_type_to_permission_type` to map the invitation types and the permission types

	DROP TABLE IF EXISTS `ut_map_invitation_type_to_permission_type`;

	CREATE TABLE `ut_map_invitation_type_to_permission_type` (
	  `invitation_type_id` SMALLINT(6) NOT NULL COMMENT 'id of the invitation type in the table `ut_invitation_types`',
	  `permission_type_id` SMALLINT(6) NOT NULL COMMENT 'id of the permission type in the table `ut_permission_types`',
	  `created` DATETIME DEFAULT NULL COMMENT 'creation ts',
	  `record_created_by` SMALLINT(6) DEFAULT NULL COMMENT 'id of the user who created this user in the bz `profiles` table',
	  `is_obsolete` TINYINT(1) NOT NULL DEFAULT '0' COMMENT 'This is an obsolete record',
	  `comment` TEXT COMMENT 'Any comment',
	  PRIMARY KEY (`invitation_type_id`,`permission_type_id`),
	  KEY `map_invitation_to_permission_permission_type_id` (`permission_type_id`),
	  CONSTRAINT `map_invitation_to_permission_invitation_type_id` FOREIGN KEY (`invitation_type_id`) REFERENCES `ut_invitation_types` (`id_invitation_type`),
	  CONSTRAINT `map_invitation_to_permission_permission_type_id` FOREIGN KEY (`permission_type_id`) REFERENCES `ut_permission_types` (`id_permission_type`)
	) ENGINE=INNODB DEFAULT CHARSET=utf8;


# Create a procedure `remove_user_from_default_cc` to remove a user in Default CC from a given role
	
	DROP PROCEDURE IF EXISTS `remove_user_from_default_cc`;

DELIMITER $$
CREATE PROCEDURE `remove_user_from_default_cc`()
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