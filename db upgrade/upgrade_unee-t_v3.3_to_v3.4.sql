# For any question about this script, ask Franck
#
###################################################################################
#
# WARNING! It is recommended to use Amazon Aurora database engine for this version
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
	SET @old_schema_version = 'v3.3';
	SET @new_schema_version = 'v3.4';
	SET @this_script = 'upgrade_unee-t_v3.3_to_v3.4.sql';
#
###############################
#
# We have everything we need
#
###############################
# This update 
#	- Move the records from the existing table `ut_data_to_create_units` into an archive `ut_data_to_create_units_legacy_before_3_3`
#	- Simplify the table `ut_data_to_create_units`. We only need
#		- the unit name
#		- the unit description 
#		Adding more information there would lead to:
#		- duplication of information that should only be in the MEFE
#		- additional complexity to secure some sensitive data
#	- facilitate the automated creation of a unit in Unee-T
#		- Alter the table `ut_data_to_create_units`
#			- Rename a constraint for easier error handling and debugging
#				- The invitor exists
#				- The Geography/category exists
#			- Make sure we are not creating duplicate record of the same MEFE unit
# 		- Create a procedures which we can call when there is a need to create a unit.
#	- Disable a unit if needed.
#
# We rename the constraints for each unit we want to create for easier error handling:
#
# We also simplify this table, in the BZ database / product object, we only need
#	- the unit name
#	- the unit description 
#
# Adding more information there leads to:
#	- duplication of information that should only be in the MEFE
#	- additional complexity to secure some sensitive data
#

	# We create a table to copy the data that exist in the table `ut_data_to_create_units`
	
	/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
	
		DROP TABLE IF EXISTS `ut_data_to_create_units_legacy_before_3_3`;

		CREATE TABLE `ut_data_to_create_units_legacy_before_3_3`(
			`id_unit_to_create` INT(11) NOT NULL  AUTO_INCREMENT COMMENT 'The unique ID in this table' , 
			`mefe_id` VARCHAR(256) COLLATE utf8_general_ci NULL  COMMENT 'The id of the object in the MEFE interface where these information are coming from' , 
			`mefe_creator_user_id` VARCHAR(256) COLLATE utf8_general_ci NULL  COMMENT 'The id of the creator of this unit in the MEFE database' , 
			`mefe_unit_id` VARCHAR(256) COLLATE utf8_general_ci NULL  COMMENT 'The id of this unit in the MEFE database' , 
			`bzfe_creator_user_id` MEDIUMINT(9) NOT NULL  COMMENT 'The BZFE user id who creates this unit. this is a FK to the BZ table \'profiles\'' , 
			`classification_id` SMALLINT(6) NOT NULL  COMMENT 'The ID of the classification for this unit - a FK to the BZ table \'classifications\'' , 
			`unit_name` VARCHAR(54) COLLATE utf8_general_ci NOT NULL  DEFAULT '' COMMENT 'A name for the unit. We will append the product id and this will be inserted in the product name field of the BZ tabele product which has a max lenght of 64' , 
			`unit_id` VARCHAR(54) COLLATE utf8_general_ci NULL  DEFAULT '' COMMENT 'The id of the unit' , 
			`unit_condo` VARCHAR(50) COLLATE utf8_general_ci NULL  DEFAULT '' COMMENT 'The name of the condo or buildig for the unit' , 
			`unit_surface` VARCHAR(10) COLLATE utf8_general_ci NULL  DEFAULT '' COMMENT 'The surface of the unit - this is a number - it can be sqm or sqf' , 
			`unit_surface_measure` TINYINT(1) NULL  COMMENT '1 is for square feet (sqf) - 2 is for square meters (sqm)' , 
			`unit_description_details` VARCHAR(500) COLLATE utf8_general_ci NULL  DEFAULT '' COMMENT 'More information about the unit - this is a free text space' , 
			`unit_address` VARCHAR(500) COLLATE utf8_general_ci NULL  DEFAULT '' COMMENT 'The address of the unit' , 
			`matterport_url` VARCHAR(256) COLLATE utf8_general_ci NULL  DEFAULT '' COMMENT 'LMB specific - a the URL for the matterport visit for this unit' , 
			`bz_created_date` DATETIME NULL  COMMENT 'Date and time when this unit has been created in the BZ databae' , 
			`comment` TEXT COLLATE utf8_general_ci NULL  COMMENT 'Any comment' , 
			`product_id` SMALLINT(6) NULL  COMMENT 'The id of the product in the BZ table \'products\'. Because this is a record that we will keep even AFTER we deleted the record in the BZ table, this can NOT be a FK.' , 
			`deleted_datetime` DATETIME NULL  COMMENT 'Timestamp when this was deleted in the BZ db (together with all objects related to this product/unit).' , 
			`deletion_script` VARCHAR(500) COLLATE utf8_general_ci NULL  COMMENT 'The script used to delete this product and all objects related to this product in the BZ database' , 
			PRIMARY KEY (`id_unit_to_create`)
		) ENGINE=INNODB DEFAULT CHARSET='utf8' COLLATE='utf8_general_ci' ROW_FORMAT=DYNAMIC
		;

		/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
		
	# We move the existing data there for future reference
	
		INSERT INTO `ut_data_to_create_units_legacy_before_3_3` SELECT * FROM `ut_data_to_create_units`;


	# We can now remove the unnecessary fields in the table `ut_data_to_create_units`

		/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
		
		ALTER TABLE `ut_data_to_create_units` 
			CHANGE `mefe_unit_id` `mefe_unit_id` VARCHAR(256)  COLLATE utf8_general_ci NULL COMMENT 'The id of this unit in the MEFE database' AFTER `id_unit_to_create` , 
			CHANGE `mefe_creator_user_id` `mefe_creator_user_id` VARCHAR(256)  COLLATE utf8_general_ci NULL COMMENT 'The id of the creator of this unit in the MEFE database' AFTER `mefe_unit_id` , 
			CHANGE `bzfe_creator_user_id` `bzfe_creator_user_id` MEDIUMINT(9)   NOT NULL COMMENT 'The BZFE user id who creates this unit. this is a FK to the BZ table \'profiles\'' AFTER `mefe_creator_user_id` , 
			CHANGE `unit_description_details` `unit_description_details` VARCHAR(500)  COLLATE utf8_general_ci NULL DEFAULT '' COMMENT 'More information about the unit - this is a free text space' AFTER `unit_name` , 
			CHANGE `bz_created_date` `bz_created_date` DATETIME   NULL COMMENT 'Date and time when this unit has been created in the BZ databae' AFTER `unit_description_details` , 
			DROP COLUMN `mefe_id` , 
			DROP COLUMN `matterport_url` , 
			DROP COLUMN `unit_id` , 
			DROP COLUMN `unit_condo` , 
			DROP COLUMN `unit_surface` , 
			DROP COLUMN `unit_surface_measure` , 
			DROP COLUMN `unit_address` , 
			DROP KEY `id_unit_classification_id` , 
			DROP KEY `id_unit_creator_id` , 
			ADD KEY `new_unit_classification_id_must_exist`(`classification_id`) , 
			ADD KEY `new_unit_unit_creator_bz_id_must_exist`(`bzfe_creator_user_id`) , 
			ADD UNIQUE KEY `new_unite_mefe_unit_id_must_be_unique`(`mefe_unit_id`) , 
			DROP FOREIGN KEY `id_unit_classification_id`  , 
			DROP FOREIGN KEY `id_unit_creator_id`  ;
			
	# We add several constraint to the table `ut_data_to_create_units`
	
		ALTER TABLE `ut_data_to_create_units`
			ADD CONSTRAINT `new_unit_classification_id_must_exist` 
			FOREIGN KEY (`classification_id`) REFERENCES `classifications` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE , 
			ADD CONSTRAINT `new_unit_unit_creator_bz_id_must_exist` 
			FOREIGN KEY (`bzfe_creator_user_id`) REFERENCES `profiles` (`userid`) ON DELETE NO ACTION ON UPDATE CASCADE ;


		/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
	
# We create the procedure that will create a unit
	
DROP PROCEDURE IF EXISTS unit_create_with_dummy_users;
DELIMITER $$
CREATE PROCEDURE unit_create_with_dummy_users()
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
				
	/*!40101 SET NAMES utf8 */;

	/*!40101 SET SQL_MODE=''*/;

	/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
	/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
	/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
	/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

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
			
	/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
	/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
	/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
	/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
	
END $$
DELIMITER ;

# We create a procedure to DISABLE an existing unit too
	
DROP PROCEDURE IF EXISTS unit_disable_existing;
DELIMITER $$
CREATE PROCEDURE unit_disable_existing()
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
		
	# Timestamp:
		SET @timestamp = NOW();
	
	# We record that the table has been updated to the new version.
	INSERT INTO `ut_db_schema_version`
		(`schema_version`
		, `update_datetime`
		, `update_script`
		, `comment`
		)
		VALUES
		(@new_schema_version
		, @timestamp
		, @this_script
		, @comment_update_schema_version
		)
		;