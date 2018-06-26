# This script prepares the data we need to move the information 
# unitRoleData into Mongo DB.
# 
# We need to get:
#	- The default assignee for each Role in each unit (if it is a 'real' user)
#	- The list of MEFE users (members) who are in this role for this unit
#		- MEFE user id for that user
#		- is this user in default CC for each case created for this role for this unit?
#		- is this user a visible user in this role for this unit in the MEFE?
#		  ->all of the other users are able to see this user in the list of 
#				- possible invitees
#				- possible assignee
#
# How it's done:
#	- Pre-requisite in the BZ database for the relevant environment
#		- Copy the table `mongo_unitRolesData` exported from Mongo
#		- Copy the table `mongo_users` exported from Mongo
#	- Run this script in the BZ DB for your environment
#	- Import the table `mongo_unitRolesData_for_import` in the Mongo database collection `unitRoleDat`
#	
# AFTER the migration is done, make sure to run the script `cleanup_bz_db_after_import.sql`

# Get the information for the mongo `members` document

	# List the Group for user in a given role for a given unit:
	# 	- groupe_type_id = 22

			DROP TABLE IF EXISTS `ut_mongo_migrate_unitRoleData_list_groups_direct_role_granting`;
			
			CREATE TABLE `ut_mongo_migrate_unitRoleData_list_groups_direct_role_granting`
			AS
			SELECT `group_id` 
				, `product_id`
				, `component_id`
				, `role_type_id`
				, 1 AS `grants_direct_membership`
			FROM `ut_product_group` 
			WHERE `group_type_id` = 22
			ORDER BY
				`product_id` ASC
				, `role_type_id` ASC
			;

	# We need to identify the users who have direct group membership for each role in this unit

		# List users who are members of the groups which grant DIRECT membership to a role in a unit.

			DROP TABLE IF EXISTS `ut_mongo_migrate_unitRoleData_list_users_roles_direct`;

			CREATE TABLE `ut_mongo_migrate_unitRoleData_list_users_roles_direct`
			AS 
			SELECT
				`user_group_map`.`user_id`
				, `user_group_map`.`group_id`
				, `ut_mongo_migrate_unitRoleData_list_groups_direct_role_granting`.`product_id`
				, `ut_mongo_migrate_unitRoleData_list_groups_direct_role_granting`.`component_id`
				, `ut_mongo_migrate_unitRoleData_list_groups_direct_role_granting`.`role_type_id`
				, `ut_mongo_migrate_unitRoleData_list_groups_direct_role_granting`.`grants_direct_membership`
			FROM
				`user_group_map`
				INNER JOIN `ut_mongo_migrate_unitRoleData_list_groups_direct_role_granting` 
					ON (`user_group_map`.`group_id` = `ut_mongo_migrate_unitRoleData_list_groups_direct_role_granting`.`group_id`)
			WHERE (`user_group_map`.`isbless` = 0)
			ORDER BY 
				`ut_mongo_migrate_unitRoleData_list_groups_direct_role_granting`.`product_id` ASC
				, `ut_mongo_migrate_unitRoleData_list_groups_direct_role_granting`.`role_type_id` ASC
				, `user_group_map`.`user_id` ASC
			;

	# Identify the users who have indirect group membership for each groups

		# We need to populate that table with the information we need for the indirect groups:
		#	- get the `product_id` from the table `ut_product_group`
		#	- get the `component_id` from the table `ut_product_group`
		#	- get the `group_id` from the table `ut_product_group`

		# List groups which grant membership to a group which grants role membership in a unit.

			DROP TABLE IF EXISTS `ut_mongo_migrate_unitRoleData_list_groups_indirect_role_grant_L1`;
			
			CREATE TABLE `ut_mongo_migrate_unitRoleData_list_groups_indirect_role_grant_L1`
			AS
			SELECT
				`group_group_map`.`member_id`
				, `group_group_map`.`grantor_id`
				, `ut_mongo_migrate_unitRoleData_list_groups_direct_role_granting`.`product_id`
				, `ut_mongo_migrate_unitRoleData_list_groups_direct_role_granting`.`component_id`
				, `ut_mongo_migrate_unitRoleData_list_groups_direct_role_granting`.`role_type_id`
				, 0 AS `grants_direct_membership`
			FROM
				`group_group_map`
				INNER JOIN `ut_mongo_migrate_unitRoleData_list_groups_direct_role_granting` 
					ON (`group_group_map`.`grantor_id` = `ut_mongo_migrate_unitRoleData_list_groups_direct_role_granting`.`group_id`)
			WHERE (`group_group_map`.`grant_type` = 0)
			ORDER BY 
				`ut_mongo_migrate_unitRoleData_list_groups_direct_role_granting`.`product_id` ASC
				, `ut_mongo_migrate_unitRoleData_list_groups_direct_role_granting`.`role_type_id` ASC
				, `group_group_map`.`grantor_id` ASC
				, `group_group_map`.`member_id` ASC
			;

		# Level 1: 
		# A user X is a member of a group A which grants access to a group B which is a Group for user in a given role for a given unit

			DROP TABLE IF EXISTS `ut_mongo_migrate_unitRoleData_list_users_roles_indirect_level1`;
			
			CREATE TABLE `ut_mongo_migrate_unitRoleData_list_users_roles_indirect_level1`
			AS 
			SELECT
				`user_group_map`.`user_id`
				, `user_group_map`.`group_id`
				, `ut_mongo_migrate_unitRoleData_list_groups_indirect_role_grant_L1`.`product_id`
				, `ut_mongo_migrate_unitRoleData_list_groups_indirect_role_grant_L1`.`component_id`
				, `ut_mongo_migrate_unitRoleData_list_groups_indirect_role_grant_L1`.`role_type_id`
				, `ut_mongo_migrate_unitRoleData_list_groups_indirect_role_grant_L1`.`grants_direct_membership`
			FROM
				`user_group_map`
				INNER JOIN `ut_mongo_migrate_unitRoleData_list_groups_indirect_role_grant_L1` 
					ON (`user_group_map`.`group_id` = `ut_mongo_migrate_unitRoleData_list_groups_indirect_role_grant_L1`.`member_id`)
			WHERE (`user_group_map`.`isbless` = 0)
			ORDER BY 
				`ut_mongo_migrate_unitRoleData_list_groups_indirect_role_grant_L1`.`product_id` ASC
				, `ut_mongo_migrate_unitRoleData_list_groups_indirect_role_grant_L1`.`role_type_id` ASC
				, `user_group_map`.`user_id` ASC
			;

		# Level 2
		# A user X belongs to a group A.
		# Group A grants membership to group B
		# Gourp B grants membership to group C
		# Group C is a group to grant permission in a role in a unit.
		# ex: group like '%Role-LMB-%' (56, 57, 58, 59, 60, 61, 62) grant membership to group 47
		# Group 47 grant role 'management company' (4) to all the LMB units.

		# List groups which grant membership to a group which grants role membership Level 2 in a unit.

			DROP TABLE IF EXISTS `ut_mongo_migrate_unitRoleData_list_groups_indirect_role_grant_L2`;
			
			CREATE TABLE `ut_mongo_migrate_unitRoleData_list_groups_indirect_role_grant_L2`
			AS
			SELECT
				`group_group_map`.`member_id`
				, `group_group_map`.`grantor_id`
				, `ut_mongo_migrate_unitRoleData_list_users_roles_indirect_level1`.`product_id`
				, `ut_mongo_migrate_unitRoleData_list_users_roles_indirect_level1`.`component_id`
				, `ut_mongo_migrate_unitRoleData_list_users_roles_indirect_level1`.`role_type_id`
				, 0 AS `grants_direct_membership`
			FROM
				`group_group_map`
				INNER JOIN `ut_mongo_migrate_unitRoleData_list_users_roles_indirect_level1` 
					ON (`group_group_map`.`grantor_id` = `ut_mongo_migrate_unitRoleData_list_users_roles_indirect_level1`.`group_id`)
			ORDER BY 
				`ut_mongo_migrate_unitRoleData_list_users_roles_indirect_level1`.`product_id` ASC
				, `ut_mongo_migrate_unitRoleData_list_users_roles_indirect_level1`.`role_type_id` ASC
				, `group_group_map`.`grantor_id` ASC
				, `group_group_map`.`member_id` ASC
			;

		# We have the table which list the groups that are granting level 1 access to roles in units.
		# Who are the users who are members of these groups?

			DROP TABLE IF EXISTS `ut_mongo_migrate_unitRoleData_list_users_roles_indirect_level2`;

			CREATE TABLE `ut_mongo_migrate_unitRoleData_list_users_roles_indirect_level2`
			AS 
			SELECT
				`user_group_map`.`user_id`
				, `user_group_map`.`group_id`
				, `ut_mongo_migrate_unitRoleData_list_groups_indirect_role_grant_L2`.`product_id`
				, `ut_mongo_migrate_unitRoleData_list_groups_indirect_role_grant_L2`.`component_id`
				, `ut_mongo_migrate_unitRoleData_list_groups_indirect_role_grant_L2`.`role_type_id`
				, `ut_mongo_migrate_unitRoleData_list_groups_indirect_role_grant_L2`.`grants_direct_membership`
			FROM
				`user_group_map`
				INNER JOIN `ut_mongo_migrate_unitRoleData_list_groups_indirect_role_grant_L2` 
					ON (`user_group_map`.`group_id` = `ut_mongo_migrate_unitRoleData_list_groups_indirect_role_grant_L2`.`member_id`)
			WHERE (`user_group_map`.`isbless` = 0)
			ORDER BY 
				`ut_mongo_migrate_unitRoleData_list_groups_indirect_role_grant_L2`.`product_id` ASC
				, `ut_mongo_migrate_unitRoleData_list_groups_indirect_role_grant_L2`.`role_type_id` ASC
				, `user_group_map`.`user_id` ASC
			;

	# We have identified all the user which have a role in a unit
	#	- Directly - level 0
	#	- Indirectly - level 1
	#	- Indirectly - level 2

		# We create a table to record all the users with roles in units
		# We make sure we do NOT do the insert if the user already has any DIRECT role in the unit.

			DROP TABLE IF EXISTS `ut_mongo_migrate_unitRoleData_list_users`;

			CREATE TABLE `ut_mongo_migrate_unitRoleData_list_users`
			LIKE `ut_mongo_migrate_unitRoleData_list_users_roles_indirect_level1`
			;

		# Make sure that there can be only one role for a user for a unit.

			ALTER TABLE `ut_mongo_migrate_unitRoleData_list_users`
					ADD UNIQUE KEY `only_one_role_per_user_per_unit` (`user_id`,`product_id`)
					;

		# We insert the data from the table:
		# `ut_mongo_migrate_unitRoleData_list_users_roles_indirect_level2` 
		# in the table `ut_mongo_migrate_unitRoleData_list_users`

			INSERT INTO `ut_mongo_migrate_unitRoleData_list_users`
				SELECT * FROM `ut_mongo_migrate_unitRoleData_list_users_roles_indirect_level2`
				GROUP BY `user_id` 
					,`product_id`
					, `role_type_id`
					, `grants_direct_membership`
			;

		# `ut_mongo_migrate_unitRoleData_list_users_roles_indirect_level1` 
		# in the table `ut_mongo_migrate_unitRoleData_list_users`

			INSERT INTO `ut_mongo_migrate_unitRoleData_list_users`
				(`user_id`
				, `group_id`
				, `product_id`
				, `component_id`
				, `role_type_id`
				, `grants_direct_membership`
				)
				SELECT `user_id`
				, `group_id`
				, `product_id`
				, `component_id`
				, `role_type_id`
				, `grants_direct_membership`
				FROM `ut_mongo_migrate_unitRoleData_list_users_roles_indirect_level1`
			ON DUPLICATE KEY UPDATE
				`ut_mongo_migrate_unitRoleData_list_users`.`group_id` 
					= `ut_mongo_migrate_unitRoleData_list_users_roles_indirect_level1`.`group_id`
				,`ut_mongo_migrate_unitRoleData_list_users`.`grants_direct_membership` 
					= `ut_mongo_migrate_unitRoleData_list_users_roles_indirect_level1`.`grants_direct_membership`
			;

		# We insert the data from the table 
		# `ut_mongo_migrate_unitRoleData_list_users_roles_direct` 
		# on duplicate key, we update the group_id and the direct membership info

			INSERT INTO `ut_mongo_migrate_unitRoleData_list_users`
				(`user_id`
				, `group_id`
				, `product_id`
				, `component_id`
				, `role_type_id`
				, `grants_direct_membership`
				)
				SELECT `user_id`
				, `group_id`
				, `product_id`
				, `component_id`
				, `role_type_id`
				, `grants_direct_membership`
				FROM `ut_mongo_migrate_unitRoleData_list_users_roles_direct`
			ON DUPLICATE KEY UPDATE
				`ut_mongo_migrate_unitRoleData_list_users`.`group_id` 
					= `ut_mongo_migrate_unitRoleData_list_users_roles_direct`.`group_id`
				,`ut_mongo_migrate_unitRoleData_list_users`.`grants_direct_membership` 
					= `ut_mongo_migrate_unitRoleData_list_users_roles_direct`.`grants_direct_membership`
			;

	# We create a table to list all the existing mongo users and retreive which role they have

		DROP TABLE IF EXISTS `ut_mongo_migrate_unitRoleData_list_members_step1`;

		CREATE TABLE `ut_mongo_migrate_unitRoleData_list_members_step1`
			AS 
			SELECT
				`mongo_users`.`_id` AS `mefe_user_id`
				, `mongo_users`.`bugzillaCreds.id` AS `bz_user_id`
				, `mongo_users`.`bugzillaCreds.login` AS `bz_email_in_mongo`
				, `ut_mongo_migrate_unitRoleData_list_users`.`product_id`
				, `ut_mongo_migrate_unitRoleData_list_users`.`component_id`
				, `ut_mongo_migrate_unitRoleData_list_users`.`role_type_id`
				, `ut_role_types`.`role_type`
				, `ut_mongo_migrate_unitRoleData_list_users`.`grants_direct_membership` AS `is_visible`
			FROM
				`mongo_users`
				INNER JOIN `ut_mongo_migrate_unitRoleData_list_users` 
					ON (`mongo_users`.`bugzillaCreds.id` = `ut_mongo_migrate_unitRoleData_list_users`.`user_id`)
				INNER JOIN `ut_role_types` 
					ON (`ut_mongo_migrate_unitRoleData_list_users`.`role_type_id` = `ut_role_types`.`id_role_type`)
			ORDER BY `ut_mongo_migrate_unitRoleData_list_users`.`product_id` ASC
				, `ut_mongo_migrate_unitRoleData_list_users`.`role_type_id` ASC
				, `mongo_users`.`bugzillaCreds.id` ASC
			;

	# We need to add several columns to this table
	
		ALTER TABLE `ut_mongo_migrate_unitRoleData_list_members_step1`
			ADD COLUMN `id_list_members_step_1` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'unique id in this table' FIRST,
			CHANGE `bz_user_id` `bz_user_id` MEDIUMINT(9)   NOT NULL AFTER `id_list_members_step_1`,
			ADD COLUMN `is_occupant` TINYINT(1) DEFAULT '0' COMMENT '1 if this user is an occupant for this unit' AFTER `is_visible`,
			ADD COLUMN `is_default_invited` TINYINT(1) DEFAULT '0' COMMENT '0 if this user is invited by default to all cases in this unit and this role' AFTER `is_occupant`,
			ADD COLUMN `member_json` JSON DEFAULT NULL COMMENT 'the JSON payload needed for each user',
			ADD PRIMARY KEY(`id_list_members_step_1`)
			;
	
	# We update the table if the user is an occupant
	
		UPDATE `ut_mongo_migrate_unitRoleData_list_members_step1`
		    INNER JOIN `ut_invitation_api_data` 
			ON (`ut_mongo_migrate_unitRoleData_list_members_step1`.`product_id` = `ut_invitation_api_data`.`bz_unit_id`) 
				AND (`ut_mongo_migrate_unitRoleData_list_members_step1`.`bz_user_id` = `ut_invitation_api_data`.`bz_user_id`)
		    SET 
			`ut_mongo_migrate_unitRoleData_list_members_step1`.`is_occupant` = `ut_invitation_api_data`.`is_occupant`
		;

	# We update the table with the information about the users who are in default CC

		UPDATE `ut_mongo_migrate_unitRoleData_list_members_step1`
		   INNER JOIN `component_cc` 
			ON (`ut_mongo_migrate_unitRoleData_list_members_step1`.`bz_user_id` = `component_cc`.`user_id`) 
			AND (`ut_mongo_migrate_unitRoleData_list_members_step1`.`component_id` = `component_cc`.`component_id`)
		SET 
			`ut_mongo_migrate_unitRoleData_list_members_step1`.`is_default_invited` = '1'
		;

	# We create the JSON for each member record:
		UPDATE `ut_mongo_migrate_unitRoleData_list_members_step1`
		SET 
			`member_json` = CONCAT('{'
				, '"id": "', `mefe_user_id` , '", '
				, '"isOccupant": ', IF(`is_occupant`= 1, 'true', 'false') , ', '
				, '"isVisible": ', IF(`is_visible`= 1, 'true', 'false') , ', '
				, '"isDefaultInvited": ', IF(`is_default_invited` = 1, 'true', 'false') , ''
				, '}'
				)
		;

	# Create the `members` records in the format we will need

		# We need to alter the group_concat_max_len parameter for this session
		# This is so that the JSON is not truncated

			SET SESSION group_concat_max_len = 10240;

		# Prepare the information in the table `ut_mongo_migrate_unitRoleData_list_members_step2`

			DROP TABLE IF EXISTS `ut_mongo_migrate_unitRoleData_list_members_step2`;
			
			CREATE TABLE `ut_mongo_migrate_unitRoleData_list_members_step2` (
				`product_id` INT(11) DEFAULT NULL
				, `component_id` LONGTEXT NOT NULL COMMENT 'unique id in the Mongo Collection '
				, `role_type` LONGTEXT
				, `defaultAssigneeId` LONGTEXT NULL
				, `total_members` BIGINT(21) NOT NULL DEFAULT '0'
				, `members_id` JSON NOT NULL
				, `members` JSON NOT NULL
				) ENGINE=INNODB DEFAULT CHARSET=utf8
				;

			INSERT INTO `ut_mongo_migrate_unitRoleData_list_members_step2`
			SELECT
				`product_id`
				, `component_id`
				, `role_type`
				, NULL
				, COUNT(`bz_user_id`) AS `total_members`
				, CONCAT('['
				, GROUP_CONCAT(DISTINCT `bz_user_id` ORDER BY `bz_user_id` SEPARATOR ', ') 
				, ']'
				) AS `members_bz_id`
				, CONCAT('['
				, GROUP_CONCAT(DISTINCT `member_json` ORDER BY `bz_user_id` SEPARATOR ', ')
				, ']'
				) AS `members`
			FROM
				`ut_mongo_migrate_unitRoleData_list_members_step1`
			WHERE `component_id` IS NOT NULL
			GROUP BY `product_id`, `component_id`, `role_type`;


# Fetch the information about the Default assignee for each role type

	DROP TABLE IF EXISTS `ut_mongo_migrate_unitRoleData_step1`;
	
	CREATE TABLE `ut_mongo_migrate_unitRoleData_step1` 
		LIKE `mongo_unitRolesData`
	;

	# Make sure the `members` column as valid JSON

		ALTER TABLE `ut_mongo_migrate_unitRoleData_step1` 
			CHANGE `members` `members` JSON NOT NULL
		;

	# We insert the data from the table from Mongo
				
		INSERT INTO `ut_mongo_migrate_unitRoleData_step1`
			(`primary_key`
			, `_id`
			, `defaultAssigneeId`
			, `roleType`
			, `unitBzId`
			, `unitId`
			, `members`
			)
			SELECT 
			`primary_key`
			, `_id`
			, `defaultAssigneeId`
			, `roleType`
			, `unitBzId`
			, `unitId`
			, '[ ]'
			FROM `mongo_unitRolesData`
		;

	# We add the column we need
	
		ALTER TABLE `ut_mongo_migrate_unitRoleData_step1` 
				ADD COLUMN `role_type_id` LONGTEXT   NOT NULL COMMENT 'unique id in the Mongo Collection ' AFTER `unitBzId`,
				ADD COLUMN `component_id` LONGTEXT   NOT NULL COMMENT 'unique id in the Mongo Collection ' AFTER `role_type_id`,
				ADD COLUMN `initialowner` MEDIUMINT(9)   NULL COMMENT 'The Default assignee for this role' AFTER `component_id`,
				ADD COLUMN `initialowner_mefe_id` LONGTEXT   NULL COMMENT 'The MEFE user ID for the Default assignee for this role' AFTER `initialowner`
				;
	
	# We make sure that the MEFE defaultAssigneeId is in a text format
	
		ALTER TABLE `ut_mongo_migrate_unitRoleData_step1` CHANGE `defaultAssigneeId` `defaultAssigneeId` LONGTEXT NULL;
	
	# We need to Add the BZ ids for:
	#	- role_type_id
	
		UPDATE `ut_mongo_migrate_unitRoleData_step1`
		    INNER JOIN `ut_role_types` 
			ON (`ut_mongo_migrate_unitRoleData_step1`.`roleType` = `ut_role_types`.`role_type`) 
		SET 
			`ut_mongo_migrate_unitRoleData_step1`.`role_type_id` = `ut_role_types`.`id_role_type`
		;
		
	# We need to Add the component_id for each role
		
		UPDATE `ut_mongo_migrate_unitRoleData_step1`
		    INNER JOIN `ut_product_group` 
			ON (`ut_mongo_migrate_unitRoleData_step1`.`role_type_id` = `ut_product_group`.`role_type_id`)
				AND (`ut_mongo_migrate_unitRoleData_step1`.`unitBzId` = `ut_product_group`.`product_id`)
		SET 
			`ut_mongo_migrate_unitRoleData_step1`.`component_id` = `ut_product_group`.`component_id`
		WHERE `ut_product_group`.`group_type_id` = 22
			AND `ut_product_group`.`component_id` IS NOT NULL
		;
	
	# Who is the default assignee for this role for this unit?

		UPDATE `ut_mongo_migrate_unitRoleData_step1`
		    INNER JOIN `components` 
			ON (`ut_mongo_migrate_unitRoleData_step1`.`component_id` = `components`.`id`)
		SET 
			`ut_mongo_migrate_unitRoleData_step1`.`initialowner` = `components`.`initialowner`
		;

	# We need to Add the MEFE ids for:
	#	- The default assignee for this role
	
		UPDATE `ut_mongo_migrate_unitRoleData_step1`
		    INNER JOIN `mongo_users` 
			ON (`ut_mongo_migrate_unitRoleData_step1`.`initialowner` = `mongo_users`.`bugzillaCreds.id`)
		SET 
			`ut_mongo_migrate_unitRoleData_step1`.`defaultAssigneeId` = `mongo_users`.`_id`
			, `ut_mongo_migrate_unitRoleData_step1`.`initialowner_mefe_id` = `mongo_users`.`_id`
		;

# We can now add the information about the members for each unit

		UPDATE `ut_mongo_migrate_unitRoleData_step1`
		    INNER JOIN `ut_mongo_migrate_unitRoleData_list_members_step2` 
			ON (`ut_mongo_migrate_unitRoleData_step1`.`unitBzId` = `ut_mongo_migrate_unitRoleData_list_members_step2`.`product_id`)
				AND (`ut_mongo_migrate_unitRoleData_step1`.`component_id` = `ut_mongo_migrate_unitRoleData_list_members_step2`.`component_id`)
		SET 
			`ut_mongo_migrate_unitRoleData_step1`.`members` = `ut_mongo_migrate_unitRoleData_list_members_step2`.`members`
		;

# We prepare the table that we will use to import the data in Mongo:
		
		DROP TABLE IF EXISTS `mongo_unitRolesData_for_import`;
		
		CREATE TABLE `mongo_unitRolesData_for_import` 
		SELECT *
		FROM `mongo_unitRolesData`;

	# We make sure that the MEFE defaultAassigneeId is in a text format
	
		ALTER TABLE `mongo_unitRolesData_for_import` CHANGE `defaultAssigneeId` `defaultAssigneeId` LONGTEXT NULL;

	
	# Make sure we add the `members` column as valid JSON

		ALTER TABLE `mongo_unitRolesData_for_import` 
			CHANGE `members` `members` JSON NOT NULL
		;

	# We include what we need in the table for import:
		
		UPDATE `mongo_unitRolesData_for_import`
		INNER JOIN `ut_mongo_migrate_unitRoleData_step1` 
			ON (`ut_mongo_migrate_unitRoleData_step1`.`primary_key` = `mongo_unitRolesData_for_import`.`primary_key`) 
		SET
			`mongo_unitRolesData_for_import`.`defaultAssigneeId` = `ut_mongo_migrate_unitRoleData_step1`.`defaultAssigneeId`
			, `mongo_unitRolesData_for_import`.`members` = `ut_mongo_migrate_unitRoleData_step1`.`members`
		;
		
	# We make sure that we do not have unecessary columns there:
		
		ALTER TABLE `mongo_unitRolesData_for_import` DROP COLUMN `primary_key`;