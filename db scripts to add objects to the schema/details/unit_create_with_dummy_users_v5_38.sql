# Procedure structure for procedure `unit_create_with_dummy_users`

	DROP PROCEDURE IF EXISTS `unit_create_with_dummy_users` ;

DELIMITER $$

CREATE PROCEDURE `unit_create_with_dummy_users`()
	SQL SECURITY INVOKER
BEGIN
	# This procedure needs the following objects:
	#	- variables:
	#		- @mefe_unit_id
	#		- @mefe_unit_id_int_value
	#		- @environment
	#
	# This procedure needs the following info in the table `ut_data_to_create_units`
	#	- id_unit_to_create
	#	- mefe_unit_id
	#	- mefe_unit_id_int_value
	#	- mefe_creator_user_id
	#	- bzfe_creator_user_id
	#	- classification_id
	#	- unit_name
	#	- unit_description_details
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
	#
	# This procedure will update the following information:
	#	-  in the table `ut_data_to_create_units`
	#		- bz_created_date
	#		- comment
	#		- product_id	
	#	- the Unee-T script log
	#	- BZ db table `audit_log`
	#
	# This procedure depends on the following procedures:
	#	- `table_to_list_dummy_user_by_environment`
	
	# What is the record that we need to use to create the objects in BZ?
		SET @unit_reference_for_import = (SELECT `id_unit_to_create` FROM `ut_data_to_create_units` WHERE `mefe_unit_id` = @mefe_unit_id);
	
	# We record the name of this procedure for future debugging and audit_log
		SET @script = 'PROCEDURE - unit_create_with_dummy_users';
		SET @timestamp = NOW();

	# We create a temporary table to record the ids of the dummy users in each environments:

		CALL `table_to_list_dummy_user_by_environment`;

	# We create the temporary tables to update the group permissions
		CALL `create_temp_table_to_update_group_permissions`;
	
	# We create the temporary tables to update the user permissions
		CALL `create_temp_table_to_update_permissions`;
			
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
		
			# We are predicting the product id to avoid name duplicates
					SET @predicted_product_id = ((SELECT MAX(`id`) FROM `products`) + 1);

			# We need a unique unit name
				SET @unit_bz_name = CONCAT(@unit_name, '-', @predicted_product_id);

			# We need a default milestone for that unit
				SET @default_milestone = '---';

			# We need a default version for that unit
				SET @default_version = '---';
			
	# We now create the unit we need.

		# Make sure we have the correct value for the name of this script so the `ut_audit_log_table` has the correct info
			SET @script = 'PROCEDURE unit_create_with_dummy_users';

		# Insert the new product into the `products table`
			INSERT INTO `products`
				(`name`
				, `classification_id`
				, `description`
				, `isactive`
				, `defaultmilestone`
				, `allows_unconfirmed`
				)
				VALUES
				(@unit_bz_name, @classification_id, @unit_description, 1, @default_milestone, 1);
	
		# Get the actual id that was created for that unit
			SET @product_id = (SELECT LAST_INSERT_ID());

		# Log the actions of the script.
			SET @script_log_message = CONCAT('A new unit #'
									, (SELECT IFNULL(@product_id, 'product_id is NULL'))
									, ' with the predicted product_id # '
									, @predicted_product_id
									, ' ('
									, (SELECT IFNULL(@unit_bz_name, 'unit is NULL'))
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

	# We can now get the real id of the unit

		SET @unit = CONCAT(@unit_bz_name, '-', @product_id);

	# We log this in the `audit_log` table
		
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

	# We prepare all the names we will need

		SET @unit_for_query = REPLACE(@unit, ' ', '%');
		
		SET @unit_for_flag = REPLACE(@unit_for_query, '%', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '-', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '!', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '@', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '#', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '$', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '%', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '^', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '' , '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '&', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '*', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '(', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, ')', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '+', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '=', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '<', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '>', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, ':', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, ';', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '"', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, ',', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '.', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '?', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '/', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '\\','_');
		
		SET @unit_for_group = REPLACE(@unit_for_flag, '_', '-');
		SET @unit_for_group = REPLACE(@unit_for_group, '----', '-');
		SET @unit_for_group = REPLACE(@unit_for_group, '---', '-');
		SET @unit_for_group = REPLACE(@unit_for_group, '--', '-');

		# We need a version for this product

			# Make sure we have the correct value for the name of this script so the `ut_audit_log_table` has the correct info
				SET @script = 'PROCEDURE unit_create_with_dummy_users';
	
			# We can now insert the version there
				INSERT INTO `versions`
					(`value`
					, `product_id`
					, `isactive`
					)
					VALUES
					(@default_version, @product_id, 1)
					;

			# We get the id for the version 
				SET @version_id = (SELECT LAST_INSERT_ID());

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

			# Make sure we have the correct value for the name of this script so the `ut_audit_log_table` has the correct info
				SET @script = 'PROCEDURE unit_create_with_dummy_users';

			# We can now insert the milestone there
				INSERT INTO `milestones`
					(`product_id`
					, `value`
					, `sortkey`
					, `isactive`
					)
					VALUES
					(@product_id, @default_milestone, 0 , 1)
					;
				
			# We get the id for the milestone 
				SET @milestone_id = (SELECT LAST_INSERT_ID());

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

	#  We create all the components/roles we need
		# For the temporary users:
			# Tenant
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
				SET @role_user_g_description_mgt_cny = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`= 4);
				SET @user_pub_name_mgt_cny = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_mgt_cny);
				SET @role_user_pub_info_mgt_cny = CONCAT(@user_pub_name_mgt_cny
													,' - '
													, 'THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL '
													, @role_user_g_description_mgt_cny
													, ' TO THIS UNIT'
													);
				SET @user_role_desc_mgt_cny = @role_user_pub_info_mgt_cny;

		# We have eveything, we can create the components we need:
		# We insert the component 1 by 1 to get the id for each component easily

		# Make sure we have the correct value for the name of this script so the `ut_audit_log_table` has the correct info
			SET @script = 'PROCEDURE unit_create_with_dummy_users';

			# Tenant (component_id_tenant)
				INSERT INTO `components`
					(`name`
					, `product_id`
					, `initialowner`
					, `initialqacontact`
					, `description`
					, `isactive`
					) 
					VALUES
					(@role_user_g_description_tenant
					, @product_id
					, @bz_user_id_dummy_tenant
					, @bz_user_id_dummy_tenant
					, @user_role_desc_tenant
					, 1
					)
					;

				# We get the id for the component for the tenant 
					SET @component_id_tenant = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('The following component #'
											, @component_id_tenant
											, ' was created for the unit # '
											, @product_id
											, ' Temporary user #'
											, (SELECT IFNULL(@bz_user_id_dummy_tenant, 'bz_user_id is NULL'))
											, ' (real name: '
											, (SELECT IFNULL(@user_pub_name_tenant, 'user_pub_name is NULL'))
											, '. This user is the default assignee for this role for that unit).'
											, ' is the '
											, 'tenant:'
											, '\r\- '
											, (SELECT IFNULL(@role_user_g_description_tenant, 'role_user_g_description is NULL'))
											, ' (role_type_id #'
											, '1'
											, ') '
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

			# Landlord (component_id_landlord)
				INSERT INTO `components`
					(`name`
					, `product_id`
					, `initialowner`
					, `initialqacontact`
					, `description`
					, `isactive`
					) 
					VALUES
					(@role_user_g_description_landlord
					, @product_id
					, @bz_user_id_dummy_landlord
					, @bz_user_id_dummy_landlord
					, @user_role_desc_landlord
					, 1
					)
					;

				# We get the id for the component for the Landlord
					SET @component_id_landlord = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('The following component #'
											, @component_id_landlord
											, ' was created for the unit # '
											, @product_id
											, ' Temporary user #'
											, (SELECT IFNULL(@bz_user_id_dummy_landlord, 'bz_user_id is NULL'))
											, ' (real name: '
											, (SELECT IFNULL(@user_pub_name_landlord, 'user_pub_name is NULL'))
											, '. This user is the default assignee for this role for that unit).'
											, ' is the '
											, 'Landlord:'
											, '\r\- '
											, (SELECT IFNULL(@role_user_g_description_landlord, 'role_user_g_description is NULL'))
											, ' (role_type_id #'
											, '2'
											, ') '
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

			# Agent (component_id_agent)
				INSERT INTO `components`
					(`name`
					, `product_id`
					, `initialowner`
					, `initialqacontact`
					, `description`
					, `isactive`
					) 
					VALUES
					(@role_user_g_description_agent
					, @product_id
					, @bz_user_id_dummy_agent
					, @bz_user_id_dummy_agent
					, @user_role_desc_agent
					, 1
					)
					;
			
				# We get the id for the component for the Agent
					SET @component_id_agent = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('The following component #'
											, @component_id_agent
											, ' was created for the unit # '
											, @product_id
											, ' Temporary user #'
											, (SELECT IFNULL(@bz_user_id_dummy_agent, 'bz_user_id is NULL'))
											, ' (real name: '
											, (SELECT IFNULL(@user_pub_name_agent, 'user_pub_name is NULL'))
											, '. This user is the default assignee for this role for that unit).'
											, ' is the '
											, 'Agent:'
											, '\r\- '
											, (SELECT IFNULL(@role_user_g_description_agent, 'role_user_g_description is NULL'))
											, ' (role_type_id #'
											, '5'
											, ') '
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

			# Contractor (component_id_contractor)
				INSERT INTO `components`
					(`name`
					, `product_id`
					, `initialowner`
					, `initialqacontact`
					, `description`
					, `isactive`
					) 
					VALUES
					(@role_user_g_description_contractor
					, @product_id
					, @bz_user_id_dummy_contractor
					, @bz_user_id_dummy_contractor
					, @user_role_desc_contractor
					, 1
					)
					;
			
				# We get the id for the component for the Contractor
					SET @component_id_contractor = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('The following component #'
											, @component_id_contractor
											, ' was created for the unit # '
											, @product_id
											, ' Temporary user #'
											, (SELECT IFNULL(@bz_user_id_dummy_contractor, 'bz_user_id is NULL'))
											, ' (real name: '
											, (SELECT IFNULL(@user_pub_name_contractor, 'user_pub_name is NULL'))
											, '. This user is the default assignee for this role for that unit).'
											, ' is the '
											, 'Contractor:'
											, '\r\- '
											, (SELECT IFNULL(@role_user_g_description_contractor, 'role_user_g_description is NULL'))
											, ' (role_type_id #'
											, '3'
											, ') '
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
			
			# Management Company (component_id_mgt_cny)
				INSERT INTO `components`
					(`name`
					, `product_id`
					, `initialowner`
					, `initialqacontact`
					, `description`
					, `isactive`
					) 
					VALUES
					(@role_user_g_description_mgt_cny
					, @product_id
					, @bz_user_id_dummy_mgt_cny
					, @bz_user_id_dummy_mgt_cny
					, @user_role_desc_mgt_cny
					, 1
					)
					;
			
				# We get the id for the component for the Management Company 
					SET @component_id_mgt_cny = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('The following component #'
											, @component_id_mgt_cny
											, ' was created for the unit # '
											, @product_id
											, ' Temporary user #'
											, (SELECT IFNULL(@bz_user_id_dummy_mgt_cny, 'bz_user_id is NULL'))
											, ' (real name: '
											, (SELECT IFNULL(@user_pub_name_mgt_cny, 'user_pub_name is NULL'))
											, '. This user is the default assignee for this role for that unit).'
											, ' is the '
											, 'Management Company:'
											, '\r\- '
											, (SELECT IFNULL(@role_user_g_description_mgt_cny, 'role_user_g_description is NULL'))
											, ' (role_type_id #'
											, '4'
											, ') '
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
					, `class`
					, `object_id`
					, `field`
					, `removed`
					, `added`
					, `at_time`
					) 
					VALUES 
					(@creator_bz_id, 'Bugzilla::Component', @component_id_tenant, '__create__', NULL, @role_user_g_description_tenant, @timestamp)
					, (@creator_bz_id, 'Bugzilla::Component', @component_id_landlord, '__create__', NULL, @role_user_g_description_landlord, @timestamp)
					, (@creator_bz_id, 'Bugzilla::Component', @component_id_agent, '__create__', NULL, @role_user_g_description_agent, @timestamp)
					, (@creator_bz_id, 'Bugzilla::Component', @component_id_contractor, '__create__', NULL, @role_user_g_description_contractor, @timestamp)
					, (@creator_bz_id, 'Bugzilla::Component', @component_id_mgt_cny, '__create__', NULL, @role_user_g_description_mgt_cny, @timestamp)
					;

	# We create the goups we need
		# For simplicity reason, it is better to create ALL the groups we need for all the possible roles and permissions
		# This will avoid a scenario where we need to grant permission to see occupants for instances but the group for occupants does not exist yet...
		
		# We prepare the information for each group that we will use to do that
		
			# Groups common to all components/roles for this unit
				# Allow user to create a case for this unit
					SET @group_name_create_case_group = (CONCAT(@unit_for_group,'-01-Can-Create-Cases'));
					SET @group_description_create_case_group = 'User can create cases for this unit.';
					
				# Allow user to create a case for this unit
					SET @group_name_can_edit_case_group = (CONCAT(@unit_for_group,'-01-Can-Edit-Cases'));
					SET @group_description_can_edit_case_group = 'User can edit a case they have access to';
					
				# Allow user to see the cases for this unit
					SET @group_name_can_see_cases_group = (CONCAT(@unit_for_group,'-02-Case-Is-Visible-To-All'));
					SET @group_description_can_see_cases_group = 'User can see the public cases for the unit';
					
				# Allow user to edit all fields in the case for this unit regardless of his/her role
					SET @group_name_can_edit_all_field_case_group = (CONCAT(@unit_for_group,'-03-Can-Always-Edit-all-Fields'));
					SET @group_description_can_edit_all_field_case_group = 'Triage - User can edit all fields in a case they have access to, regardless of role';
					
				# Allow user to edit all the fields in a case, regardless of user role for this unit
					SET @group_name_can_edit_component_group = (CONCAT(@unit_for_group,'-04-Can-Edit-Components'));
					SET @group_description_can_edit_component_group = 'User can edit components/roles for the unit';
					
				# Allow user to see the unit in the search
					SET @group_name_can_see_unit_in_search_group = (CONCAT(@unit_for_group,'-00-Can-See-Unit-In-Search'));
					SET @group_description_can_see_unit_in_search_group = 'User can see the unit in the search panel';
					
			# The groups related to Flags
				# Allow user to  for this unit
					SET @group_name_all_g_flags_group = (CONCAT(@unit_for_group,'-05-Can-Approve-All-Flags'));
					SET @group_description_all_g_flags_group = 'User can approve all flags';
					
				# Allow user to  for this unit
					SET @group_name_all_r_flags_group = (CONCAT(@unit_for_group,'-05-Can-Request-All-Flags'));
					SET @group_description_all_r_flags_group = 'User can request a Flag to be approved';
					
				
			# The Groups that control user visibility
				# Allow user to  for this unit
					SET @group_name_list_visible_assignees_group = (CONCAT(@unit_for_group,'-06-List-Public-Assignee'));
					SET @group_description_list_visible_assignees_group = 'User are visible assignee(s) for this unit';
					
				# Allow user to  for this unit
					SET @group_name_see_visible_assignees_group = (CONCAT(@unit_for_group,'-06-Can-See-Public-Assignee'));
					SET @group_description_see_visible_assignees_group = 'User can see all visible assignee(s) for this unit';
					
			# Other Misc Groups
				# Allow user to  for this unit
					SET @group_name_active_stakeholder_group = (CONCAT(@unit_for_group,'-07-Active-Stakeholder'));
					SET @group_description_active_stakeholder_group = 'Users who have a role in this unit as of today (WIP)';
					
				# Allow user to  for this unit
					SET @group_name_unit_creator_group = (CONCAT(@unit_for_group,'-07-Unit-Creator'));
					SET @group_description_unit_creator_group = 'User is considered to be the creator of the unit';
					
			# Groups associated to the components/roles
				# For the tenant
					# Visibility group
					SET @group_name_show_to_tenant = (CONCAT(@unit_for_group,'-02-Limit-to-Tenant'));
					SET @group_description_tenant = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 1), @visibility_explanation_2));
				
					# Is in tenant user Group
					SET @group_name_are_users_tenant = (CONCAT(@unit_for_group,'-06-List-Tenant'));
					SET @group_description_are_users_tenant = (CONCAT('list the tenant(s)', @unit));
					
					# Can See tenant user Group
					SET @group_name_see_users_tenant = (CONCAT(@unit_for_group,'-06-Can-see-Tenant'));
					SET @group_description_see_users_tenant = (CONCAT('See the list of tenant(s) for ', @unit));
			
				# For the Landlord
					# Visibility group 
					SET @group_name_show_to_landlord = (CONCAT(@unit_for_group,'-02-Limit-to-Landlord'));
					SET @group_description_show_to_landlord = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 2), @visibility_explanation_2));
					
					# Is in landlord user Group
					SET @group_name_are_users_landlord = (CONCAT(@unit_for_group,'-06-List-landlord'));
					SET @group_description_are_users_landlord = (CONCAT('list the landlord(s)', @unit));
					
					# Can See landlord user Group
					SET @group_name_see_users_landlord = (CONCAT(@unit_for_group,'-06-Can-see-lanldord'));
					SET @group_description_see_users_landlord = (CONCAT('See the list of lanldord(s) for ', @unit));
					
				# For the agent
					# Visibility group 
					SET @group_name_show_to_agent = (CONCAT(@unit_for_group,'-02-Limit-to-Agent'));
					SET @group_description_show_to_agent = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 5), @visibility_explanation_2));
					
					# Is in Agent user Group
					SET @group_name_are_users_agent = (CONCAT(@unit_for_group,'-06-List-agent'));
					SET @group_description_are_users_agent = (CONCAT('list the agent(s)', @unit));
					
					# Can See Agent user Group
					SET @group_name_see_users_agent = (CONCAT(@unit_for_group,'-06-Can-see-agent'));
					SET @group_description_see_users_agent = (CONCAT('See the list of agent(s) for ', @unit));
				
				# For the contractor
					# Visibility group 
					SET @group_name_show_to_contractor = (CONCAT(@unit_for_group,'-02-Limit-to-Contractor-Employee'));
					SET @group_description_show_to_contractor = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 3), @visibility_explanation_2));
					
					# Is in contractor user Group
					SET @group_name_are_users_contractor = (CONCAT(@unit_for_group,'-06-List-contractor-employee'));
					SET @group_description_are_users_contractor = (CONCAT('list the contractor employee(s)', @unit));
					
					# Can See contractor user Group
					SET @group_name_see_users_contractor = (CONCAT(@unit_for_group,'-06-Can-see-contractor-employee'));
					SET @group_description_see_users_contractor = (CONCAT('See the list of contractor employee(s) for ', @unit));
					
				# For the Mgt Cny
					# Visibility group
					SET @group_name_show_to_mgt_cny = (CONCAT(@unit_for_group,'-02-Limit-to-Mgt-Cny-Employee'));
					SET @group_description_show_to_mgt_cny = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 4), @visibility_explanation_2));
					
					# Is in mgt cny user Group
					SET @group_name_are_users_mgt_cny = (CONCAT(@unit_for_group,'-06-List-Mgt-Cny-Employee'));
					SET @group_description_are_users_mgt_cny = (CONCAT('list the Mgt Cny Employee(s)', @unit));
					
					# Can See mgt cny user Group
					SET @group_name_see_users_mgt_cny = (CONCAT(@unit_for_group,'-06-Can-see-Mgt-Cny-Employee'));
					SET @group_description_see_users_mgt_cny = (CONCAT('See the list of Mgt Cny Employee(s) for ', @unit));
				
				# For the occupant
					# Visibility group
					SET @group_name_show_to_occupant = (CONCAT(@unit_for_group,'-02-Limit-to-occupant'));
					SET @group_description_show_to_occupant = (CONCAT(@visibility_explanation_1,'Occupants'));
					
					# Is in occupant user Group
					SET @group_name_are_users_occupant = (CONCAT(@unit_for_group,'-06-List-occupant'));
					SET @group_description_are_users_occupant = (CONCAT('list-the-occupant(s)-', @unit));
					
					# Can See occupant user Group
					SET @group_name_see_users_occupant = (CONCAT(@unit_for_group,'-06-Can-see-occupant'));
					SET @group_description_see_users_occupant = (CONCAT('See the list of occupant(s) for ', @unit));
					
				# For the people invited by this user:
					# Is in invited_by user Group
					SET @group_name_are_users_invited_by = (CONCAT(@unit_for_group,'-06-List-invited-by'));
					SET @group_description_are_users_invited_by = (CONCAT('list the invited_by(s)', @unit));
					
					# Can See users in invited_by user Group
					SET @group_name_see_users_invited_by = (CONCAT(@unit_for_group,'-06-Can-see-invited-by'));
					SET @group_description_see_users_invited_by = (CONCAT('See the list of invited_by(s) for ', @unit));

		# We can populate the 'groups' table now.
		# We insert the groups 1 by 1 so we can get the id for each of these groups.

			# Make sure we have the correct value for the name of this script so the `ut_audit_log_table` has the correct info
				SET @script = 'PROCEDURE unit_create_with_dummy_users';

			# create_case_group_id
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_create_case_group
					, @group_description_create_case_group
					, 1
					, ''
					, 1
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @create_case_group_id = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - To grant '
											, 'case creation'
											, ' privileges. Group_id: '
											, (SELECT IFNULL(@create_case_group_id, 'create_case_group_id is NULL'))
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

			# can_edit_case_group_id
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_can_edit_case_group
					, @group_description_can_edit_case_group
					, 1
					, ''
					, 1
					, NULL
					)
					;			

				# Get the actual id that was created for that group
					SET @can_edit_case_group_id = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - To grant '
											, 'Edit case'
											, ' privileges. Group_id: '
											, (SELECT IFNULL(@can_edit_case_group_id, 'can_edit_case_group_id is NULL'))
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

			# can_see_cases_group_id
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_can_see_cases_group
					, @group_description_can_see_cases_group
					, 1
					, ''
					, 1
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @can_see_cases_group_id = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - To grant '
											, 'See cases'
											, ' privileges. Group_id: '
											, (SELECT IFNULL(@can_see_cases_group_id, 'can_see_cases_group_id is NULL'))
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

			# can_edit_all_field_case_group_id
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_can_edit_all_field_case_group
					, @group_description_can_edit_all_field_case_group
					, 1
					, ''
					, 1
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @can_edit_all_field_case_group_id = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - To grant '
											, 'Edit all field regardless of role'
											, ' privileges. Group_id: '
											, (SELECT IFNULL(@can_edit_all_field_case_group_id, 'can_edit_all_field_case_group_id is NULL'))
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

			# can_edit_component_group_id
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_can_edit_component_group
					, @group_description_can_edit_component_group
					, 1
					, ''
					, 1
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @can_edit_component_group_id = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - To grant '
											, 'Edit Component/roles'
											, ' privileges. Group_id: '
											, (SELECT IFNULL(@can_edit_component_group_id, 'can_edit_component_group_id is NULL'))
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

			# can_see_unit_in_search_group_id
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_can_see_unit_in_search_group
					, @group_description_can_see_unit_in_search_group
					, 1
					, ''
					, 1
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @can_see_unit_in_search_group_id = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - To grant '
											, 'See unit in the Search panel'
											, ' privileges. Group_id: '
											, (SELECT IFNULL(@can_see_unit_in_search_group_id, 'can_see_unit_in_search_group_id is NULL'))
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

			# all_g_flags_group_id
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_all_g_flags_group
					, @group_description_all_g_flags_group
					, 1
					, ''
					, 0
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @all_g_flags_group_id = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - To grant '
											, 'Approve all flags'
											, ' privileges. Group_id: '
											, (SELECT IFNULL(@all_g_flags_group_id, 'all_g_flags_group_id is NULL'))
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

			# all_r_flags_group_id
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_all_r_flags_group
					, @group_description_all_r_flags_group
					, 1
					, ''
					, 0
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @all_r_flags_group_id = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - To grant '
											, 'Request all flags'
											, ' privileges. Group_id: '
											, (SELECT IFNULL(@all_r_flags_group_id, 'all_r_flags_group_id is NULL'))
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

			# list_visible_assignees_group_id
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_list_visible_assignees_group
					, @group_description_list_visible_assignees_group
					, 1
					, ''
					, 0
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @list_visible_assignees_group_id = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - To grant '
											, 'User is publicly visible'
											, ' privileges. Group_id: '
											, (SELECT IFNULL(@list_visible_assignees_group_id, 'list_visible_assignees_group_id is NULL'))
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

			# see_visible_assignees_group_id
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_see_visible_assignees_group
					, @group_description_see_visible_assignees_group
					, 1
					, ''
					, 0
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @see_visible_assignees_group_id = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - To grant '
											, 'User can see publicly visible'
											, ' privileges. Group_id: '
											, (SELECT IFNULL(@see_visible_assignees_group_id, 'see_visible_assignees_group_id is NULL'))
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

			# active_stakeholder_group_id
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_active_stakeholder_group
					, @group_description_active_stakeholder_group
					, 1
					, ''
					, 1
					, NULL
					)
					;
				
				# Get the actual id that was created for that group
					SET @active_stakeholder_group_id = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - To grant '
											, 'User is active Stakeholder'
											, ' privileges. Group_id: '
											, (SELECT IFNULL(@active_stakeholder_group_id, 'active_stakeholder_group_id is NULL'))
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

			# unit_creator_group_id
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_unit_creator_group
					, @group_description_unit_creator_group
					, 1
					, ''
					, 0
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @unit_creator_group_id = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - To grant '
											, 'User is the unit creator'
											, ' privileges. Group_id: '
											, (SELECT IFNULL(@unit_creator_group_id, 'unit_creator_group_id is NULL'))
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

			# group_id_show_to_tenant
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_show_to_tenant
					, @group_description_tenant
					, 1
					, ''
					, 1
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @group_id_show_to_tenant = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - Restrict permission to '
											, 'tenant'
											, ' only. Group_id: '
											, (SELECT IFNULL(@group_id_show_to_tenant, 'group_id_show_to_tenant is NULL'))
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

			# group_id_are_users_tenant
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_are_users_tenant
					, @group_description_are_users_tenant
					, 1
					, ''
					, 0
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @group_id_are_users_tenant = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - Group for the '
											, 'tenant'
											, ' only. Group_id: '
											, (SELECT IFNULL(@group_id_are_users_tenant, 'group_id_are_users_tenant is NULL'))
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

			# group_id_see_users_tenant
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_see_users_tenant
					, @group_description_see_users_tenant
					, 1
					, ''
					, 0
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @group_id_see_users_tenant = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - Group to see the users '
											, 'tenant'
											, '. Group_id: '
											, (SELECT IFNULL(@group_id_see_users_tenant, 'group_id_see_users_tenant is NULL'))
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

			# group_id_show_to_landlord
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_show_to_landlord
					, @group_description_show_to_landlord
					, 1
					, ''
					, 1
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @group_id_show_to_landlord = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - Restrict permission to '
											, 'landlord'
											, ' only. Group_id: '
											, (SELECT IFNULL(@group_id_show_to_landlord, 'group_id_show_to_landlord is NULL'))
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

			# group_id_are_users_landlord
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_are_users_landlord
					, @group_description_are_users_landlord
					, 1
					, ''
					, 0
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @group_id_are_users_landlord = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - Group for the '
											, 'landlord'
											, ' only. Group_id: '
											, (SELECT IFNULL(@group_id_are_users_landlord, 'group_id_are_users_landlord is NULL'))
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

			# group_id_see_users_landlord
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_see_users_landlord
					, @group_description_see_users_landlord
					, 1
					, ''
					, 0
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @group_id_see_users_landlord = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - Group to see the users'
											, 'landlord'
											, '. Group_id: '
											, (SELECT IFNULL(@group_id_see_users_landlord, 'group_id_see_users_landlord is NULL'))
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

			# group_id_show_to_agent
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_show_to_agent
					, @group_description_show_to_agent
					, 1
					, ''
					, 1
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @group_id_show_to_agent = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - Restrict permission to '
											, 'agent'
											, ' only. Group_id: '
											, (SELECT IFNULL(@group_id_show_to_agent, 'group_id_show_to_agent is NULL'))
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

			# group_id_are_users_agent
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_are_users_agent
					, @group_description_are_users_agent
					, 1
					, ''
					, 0
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @group_id_are_users_agent = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - Group for the '
											, 'agent'
											, ' only. Group_id: '
											, (SELECT IFNULL(@group_id_are_users_agent, 'group_id_are_users_agent is NULL'))
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

			# group_id_see_users_agent
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_see_users_agent
					, @group_description_see_users_agent
					, 1
					, ''
					, 0
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @group_id_see_users_agent = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - Group to see the users'
											, 'agent'
											, '. Group_id: '
											, (SELECT IFNULL(@group_id_see_users_agent, 'group_id_see_users_agent is NULL'))
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

			# group_id_show_to_contractor
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_show_to_contractor
					, @group_description_show_to_contractor
					, 1
					, ''
					, 1
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @group_id_show_to_contractor = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - Restrict permission to '
											, 'Contractor'
											, ' only. Group_id: '
											, (SELECT IFNULL(@group_id_show_to_contractor, 'group_id_show_to_contractor is NULL'))
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

			# group_id_are_users_contractor
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_are_users_contractor
					, @group_description_are_users_contractor
					, 1
					, ''
					, 0
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @group_id_are_users_contractor = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - Group for the '
											, 'Contractor'
											, ' only. Group_id: '
											, (SELECT IFNULL(@group_id_are_users_contractor, 'group_id_are_users_contractor is NULL'))
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

			# group_id_see_users_contractor
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_see_users_contractor
					, @group_description_see_users_contractor
					, 1
					, ''
					, 0
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @group_id_see_users_contractor = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - Group to see the users'
											, 'Contractor'
											, '. Group_id: '
											, (SELECT IFNULL(@group_id_see_users_contractor, 'group_id_see_users_contractor is NULL'))
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

			# group_id_show_to_mgt_cny
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_show_to_mgt_cny
					, @group_description_show_to_mgt_cny
					, 1
					, ''
					, 1
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @group_id_show_to_mgt_cny = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - Restrict permission to '
											, 'Management Company'
											, ' only. Group_id: '
											, (SELECT IFNULL(@group_id_show_to_mgt_cny, 'group_id_show_to_mgt_cny is NULL'))
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

			# group_id_are_users_mgt_cny
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_are_users_mgt_cny
					, @group_description_are_users_mgt_cny
					, 1
					, ''
					, 0
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @group_id_are_users_mgt_cny = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - Group for the users in the '
											, 'Management Company'
											, ' only. Group_id: '
											, (SELECT IFNULL(@group_id_are_users_mgt_cny, 'group_id_are_users_mgt_cny is NULL'))
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

			# group_id_see_users_mgt_cny
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_see_users_mgt_cny
					, @group_description_see_users_mgt_cny
					, 1
					, ''
					, 0
					, NULL
					)
					;		 

				# Get the actual id that was created for that group
					SET @group_id_see_users_mgt_cny = (SELECT LAST_INSERT_ID());	

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - Group to see the users in the '
											, 'Management Company'
											, '. Group_id: '
											, (SELECT IFNULL(@group_id_see_users_mgt_cny, 'group_id_see_users_mgt_cny is NULL'))
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

			# group_id_show_to_occupant
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_show_to_occupant
					, @group_description_show_to_occupant
					, 1
					, ''
					, 1
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @group_id_show_to_occupant = (SELECT LAST_INSERT_ID());	

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - Restrict permission to '
											, 'occupant'
											, ' only. Group_id: '
											, (SELECT IFNULL(@group_id_show_to_occupant, 'group_id_show_to_occupant is NULL'))
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

			# group_id_are_users_occupant
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_are_users_occupant
					, @group_description_are_users_occupant
					, 1
					, ''
					, 0
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @group_id_are_users_occupant = (SELECT LAST_INSERT_ID());  

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - Group for the '
											, 'occupant'
											, ' only. Group_id: '
											, (SELECT IFNULL(@group_id_are_users_occupant, 'group_id_are_users_occupant is NULL'))
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

			# group_id_see_users_occupant
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_see_users_occupant
					, @group_description_see_users_occupant
					, 1
					, ''
					, 0
					, NULL
					)
					;
					
				# Get the actual id that was created for that group
					SET @group_id_see_users_occupant = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - Group to see the users '
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

			# group_id_are_users_invited_by
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_are_users_invited_by
					, @group_description_are_users_invited_by
					, 1
					, ''
					, 0
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @group_id_are_users_invited_by = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - group of users invited by the same user'
											, ' . Group_id: '
											, (SELECT IFNULL(@group_id_are_users_invited_by, 'group_id_are_users_invited_by is NULL'))
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

			# group_id_see_users_invited_by
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_see_users_invited_by
					, @group_description_see_users_invited_by
					, 1
					, ''
					, 0
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @group_id_see_users_invited_by = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - Group to see the users '
											, 'invited by the same user'
											, '. Group_id: '
											, (SELECT IFNULL(@group_id_see_users_invited_by, 'group_id_see_users_invited_by is NULL'))
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

		# Make sure we have the correct value for the name of this script so the `ut_audit_log_table` has the correct info
			SET @script = 'PROCEDURE unit_create_with_dummy_users';

		# We can now insert in the table
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
				(@product_id, NULL, @create_case_group_id, 20, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @can_edit_case_group_id, 25, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @can_edit_all_field_case_group_id, 26, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @can_edit_component_group_id, 27, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @can_see_cases_group_id, 28, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @can_see_unit_in_search_group_id, 38, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @all_r_flags_group_id, 18, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @all_g_flags_group_id, 19, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @list_visible_assignees_group_id, 4, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @see_visible_assignees_group_id,5, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @active_stakeholder_group_id, 29, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @unit_creator_group_id, 1, NULL, @creator_bz_id, @timestamp)
				# Tenant (1)
				, (@product_id, @component_id_tenant, @group_id_show_to_tenant, 2, 1, @creator_bz_id, @timestamp)
				, (@product_id, @component_id_tenant, @group_id_are_users_tenant, 22, 1, @creator_bz_id, @timestamp)
				, (@product_id, @component_id_tenant, @group_id_see_users_tenant, 37, 1, @creator_bz_id, @timestamp)
				# Landlord (2)
				, (@product_id, @component_id_landlord, @group_id_show_to_landlord, 2, 2, @creator_bz_id, @timestamp)
				, (@product_id, @component_id_landlord, @group_id_are_users_landlord, 22, 2, @creator_bz_id, @timestamp)
				, (@product_id, @component_id_landlord, @group_id_see_users_landlord, 37, 2, @creator_bz_id, @timestamp)
				# Agent (5)
				, (@product_id, @component_id_agent, @group_id_show_to_agent, 2,5, @creator_bz_id, @timestamp)
				, (@product_id, @component_id_agent, @group_id_are_users_agent, 22,5, @creator_bz_id, @timestamp)
				, (@product_id, @component_id_agent, @group_id_see_users_agent, 37,5, @creator_bz_id, @timestamp)
				# contractor (3)
				, (@product_id, @component_id_contractor, @group_id_show_to_contractor, 2, 3, @creator_bz_id, @timestamp)
				, (@product_id, @component_id_contractor, @group_id_are_users_contractor, 22, 3, @creator_bz_id, @timestamp)
				, (@product_id, @component_id_contractor, @group_id_see_users_contractor, 37, 3, @creator_bz_id, @timestamp)
				# mgt_cny (4)
				, (@product_id, @component_id_mgt_cny, @group_id_show_to_mgt_cny, 2, 4, @creator_bz_id, @timestamp)
				, (@product_id, @component_id_mgt_cny, @group_id_are_users_mgt_cny, 22, 4, @creator_bz_id, @timestamp)
				, (@product_id, @component_id_mgt_cny, @group_id_see_users_mgt_cny, 37, 4, @creator_bz_id, @timestamp)
				# occupant (#)
				, (@product_id, NULL, @group_id_show_to_occupant, 24, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @group_id_are_users_occupant, 3, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @group_id_see_users_occupant, 36, NULL, @creator_bz_id, @timestamp)
				# invited_by
				, (@product_id, NULL, @group_id_are_users_invited_by, 31, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @group_id_see_users_invited_by, 32, NULL, @creator_bz_id, @timestamp)
				;
				
		# We update the BZ logs
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
				(@creator_bz_id, 'Bugzilla::Group', @create_case_group_id, '__create__', NULL, @group_name_create_case_group, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @can_edit_case_group_id, '__create__', NULL, @group_name_can_edit_case_group, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @can_edit_all_field_case_group_id, '__create__', NULL, @group_name_can_edit_all_field_case_group, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @can_edit_component_group_id, '__create__', NULL, @group_name_can_edit_component_group, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @can_see_cases_group_id, '__create__', NULL, @group_name_can_see_cases_group, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @can_see_unit_in_search_group_id, '__create__', NULL, @group_name_can_see_unit_in_search_group, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @all_g_flags_group_id, '__create__', NULL, @group_name_all_g_flags_group, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @all_r_flags_group_id, '__create__', NULL, @group_name_all_r_flags_group, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @list_visible_assignees_group_id, '__create__', NULL, @group_name_list_visible_assignees_group, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @see_visible_assignees_group_id, '__create__', NULL, @group_name_see_visible_assignees_group, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @active_stakeholder_group_id, '__create__', NULL, @group_name_active_stakeholder_group, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @unit_creator_group_id, '__create__', NULL, @group_name_unit_creator_group, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_tenant, '__create__', NULL, @group_name_show_to_tenant, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_tenant, '__create__', NULL, @group_name_are_users_tenant, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_tenant, '__create__', NULL, @group_name_see_users_tenant, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_landlord, '__create__', NULL, @group_name_show_to_landlord, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_landlord, '__create__', NULL, @group_name_are_users_landlord, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_landlord, '__create__', NULL, @group_name_see_users_landlord, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_agent, '__create__', NULL, @group_name_show_to_agent, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_agent, '__create__', NULL, @group_name_are_users_agent, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_agent, '__create__', NULL, @group_name_see_users_agent, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_contractor, '__create__', NULL, @group_name_show_to_contractor, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_contractor, '__create__', NULL, @group_name_are_users_contractor, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_contractor, '__create__', NULL, @group_name_see_users_contractor, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_mgt_cny, '__create__', NULL, @group_name_show_to_mgt_cny, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_mgt_cny, '__create__', NULL, @group_name_are_users_mgt_cny, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_mgt_cny, '__create__', NULL, @group_name_see_users_mgt_cny, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_occupant, '__create__', NULL, @group_name_show_to_occupant, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_occupant, '__create__', NULL, @group_name_are_users_occupant, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_occupant, '__create__', NULL, @group_name_see_users_occupant, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_invited_by, '__create__', NULL, @group_name_are_users_invited_by, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_invited_by, '__create__', NULL, @group_name_see_users_invited_by, @timestamp)
				;
			
	# We now Create the flagtypes and flags for this new unit (we NEEDED the group ids for that!):
		
		# We need to define the data we need for each flag
			SET @flag_next_step_name = CONCAT('Next_Step_', @unit_for_flag);
			SET @flag_solution_name = CONCAT('Solution_', @unit_for_flag);
			SET @flag_budget_name = CONCAT('Budget_', @unit_for_flag);
			SET @flag_attachment_name = CONCAT('Attachment_', @unit_for_flag);
			SET @flag_ok_to_pay_name = CONCAT('OK_to_pay_', @unit_for_flag);
			SET @flag_is_paid_name = CONCAT('is_paid_', @unit_for_flag);
	
		# We insert the flagtypes 1 by 1 to get the id for each component easily

		# Make sure we have the correct value for the name of this script so the `ut_audit_log_table` has the correct info
			SET @script = 'PROCEDURE unit_create_with_dummy_users';

		# Flagtype for next_step
			INSERT INTO `flagtypes`
				(`name`
				, `description`
				, `cc_list`
				, `target_type`
				, `is_active`
				, `is_requestable`
				, `is_requesteeble`
				, `is_multiplicable`
				, `sortkey`
				, `grant_group_id`
				, `request_group_id`
				) 
				VALUES 
				(@flag_next_step_name 
				, 'Approval for the Next Step of the case.'
				, ''
				, 'b'
				, 1
				, 1
				, 1
				, 1
				, 10
				, @all_g_flags_group_id
				, @all_r_flags_group_id
				)
				;

				# We get the id for that flag
					SET @flag_next_step_id = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('The following flag Next Step (#'
										, (SELECT IFNULL(@flag_next_step_id, 'flag_next_step is NULL'))
										, ').'
										, ' was created for the unit #'
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
					
					SET @script_log_message = NULL;	

		# We can now create the flagtypes for solution
			INSERT INTO `flagtypes`
				(`name`
				, `description`
				, `cc_list`
				, `target_type`
				, `is_active`
				, `is_requestable`
				, `is_requesteeble`
				, `is_multiplicable`
				, `sortkey`
				, `grant_group_id`
				, `request_group_id`
				) 
				VALUES 
				(@flag_solution_name 
				, 'Approval for the Solution of this case.'
				, ''
				, 'b'
				, 1
				, 1
				, 1
				, 1
				, 20
				, @all_g_flags_group_id
				, @all_r_flags_group_id
				)
				;

				# We get the id for that flag
					SET @flag_solution_id = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('The following flag Solution (#'
										, (SELECT IFNULL(@flag_solution_id, 'flag_solution is NULL'))
										, ').'
										, ' was created for the unit #'
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
					
					SET @script_log_message = NULL;	

		# We can now create the flagtypes for budget
			INSERT INTO `flagtypes`
				(`name`
				, `description`
				, `cc_list`
				, `target_type`
				, `is_active`
				, `is_requestable`
				, `is_requesteeble`
				, `is_multiplicable`
				, `sortkey`
				, `grant_group_id`
				, `request_group_id`
				) 
				VALUES 
				(@flag_budget_name 
				, 'Approval for the Budget for this case.'
				, ''
				, 'b'
				, 1
				, 1
				, 1
				, 1
				, 30
				, @all_g_flags_group_id
				, @all_r_flags_group_id
				)
				;

				# We get the id for that flag
					SET @flag_budget_id = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('The following flag Budget (#'
										, (SELECT IFNULL(@flag_budget_id, 'flag_budget is NULL'))
										, ').'
										, ' was created for the unit #'
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
					
					SET @script_log_message = NULL;	

		# We can now create the flagtypes for attachment
			INSERT INTO `flagtypes`
				(`name`
				, `description`
				, `cc_list`
				, `target_type`
				, `is_active`
				, `is_requestable`
				, `is_requesteeble`
				, `is_multiplicable`
				, `sortkey`
				, `grant_group_id`
				, `request_group_id`
				) 
				VALUES				 
				(@flag_attachment_name 
				, 'Approval for this Attachment.'
				, ''
				, 'a'
				, 1
				, 1
				, 1
				, 1
				, 10
				, @all_g_flags_group_id
				, @all_r_flags_group_id
				)
				;

				# We get the id for that flag
					SET @flag_attachment_id = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('The following flag Attachment (#'
										, (SELECT IFNULL(@flag_attachment_id, 'flag_attachment is NULL'))
										, ').'
										, ' was created for the unit #'
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
					
					SET @script_log_message = NULL;	

		# We can now create the flagtypes for ok_to_pay
			INSERT INTO `flagtypes`
				(`name`
				, `description`
				, `cc_list`
				, `target_type`
				, `is_active`
				, `is_requestable`
				, `is_requesteeble`
				, `is_multiplicable`
				, `sortkey`
				, `grant_group_id`
				, `request_group_id`
				) 
				VALUES 
				(@flag_ok_to_pay_name 
				, 'Approval to pay this bill.'
				, ''
				, 'a'
				, 1
				, 1
				, 1
				, 1
				, 20
				, @all_g_flags_group_id
				, @all_r_flags_group_id
				)
				;

				# We get the id for that flag
					SET @flag_ok_to_pay_id = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('The following flag OK to pay (#'
										, (SELECT IFNULL(@flag_ok_to_pay_id, 'flag_ok_to_pay is NULL'))
										, ').'
										, ' was created for the unit #'
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
					
					SET @script_log_message = NULL;	

		# We can now create the flagtypes for is_paid
			INSERT INTO `flagtypes`
				(`name`
				, `description`
				, `cc_list`
				, `target_type`
				, `is_active`
				, `is_requestable`
				, `is_requesteeble`
				, `is_multiplicable`
				, `sortkey`
				, `grant_group_id`
				, `request_group_id`
				) 
				VALUES 
				(@flag_is_paid_name
				, 'Confirm if this bill has been paid.'
				, ''
				, 'a'
				, 1
				, 1
				, 1
				, 1
				, 30
				, @all_g_flags_group_id
				, @all_r_flags_group_id
				)
				;

				# We get the id for that flag
					SET @flag_is_paid_id = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('The following flag Is paid (#'
										, (SELECT IFNULL(@flag_is_paid_id, 'flag_is_paid is NULL'))
										, ').'
										, ' was created for the unit #'
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
					
					SET @script_log_message = NULL;	

		# We also define the flag inclusion

		# Make sure we have the correct value for the name of this script so the `ut_audit_log_table` has the correct info
			SET @script = 'PROCEDURE unit_create_with_dummy_users';

		# We can now do the insert
			INSERT INTO `flaginclusions`
				(`type_id`
				, `product_id`
				, `component_id`
				) 
				VALUES
				(@flag_next_step_id, @product_id, NULL)
				, (@flag_solution_id, @product_id, NULL)
				, (@flag_budget_id, @product_id, NULL)
				, (@flag_attachment_id, @product_id, NULL)
				, (@flag_ok_to_pay_id, @product_id, NULL)
				, (@flag_is_paid_id, @product_id, NULL)
				;

		# We update the BZ logs
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
				(@creator_bz_id, 'Bugzilla::FlagType', @flag_next_step_id, '__create__', NULL, @flag_next_step_name, @timestamp)
				, (@creator_bz_id, 'Bugzilla::FlagType', @flag_solution_id, '__create__', NULL, @flag_solution_name, @timestamp)
				, (@creator_bz_id, 'Bugzilla::FlagType', @flag_budget_id, '__create__', NULL, @flag_budget_name, @timestamp)
				, (@creator_bz_id, 'Bugzilla::FlagType', @flag_attachment_id, '__create__', NULL, @flag_attachment_name, @timestamp)
				, (@creator_bz_id, 'Bugzilla::FlagType', @flag_ok_to_pay_id, '__create__', NULL, @flag_ok_to_pay_name, @timestamp)
				, (@creator_bz_id, 'Bugzilla::FlagType', @flag_is_paid_id, '__create__', NULL, @flag_is_paid_name, @timestamp)
				;
			
	# We configure the group permissions:
		# Data for the table `group_group_map`
		# We first insert these in the table `ut_group_group_map_temp`
		# If you need to re-create the table `ut_group_group_map_temp`, use the procedure `create_temp_table_to_update_group_permissions`

			INSERT INTO `ut_group_group_map_temp`
				(`member_id`
				, `grantor_id`
				, `grant_type`
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
				(1, @create_case_group_id, 1)
				,(1, @can_edit_case_group_id, 1)
				,(1, @can_see_cases_group_id, 1)
				,(1, @can_edit_all_field_case_group_id, 1)
				,(1, @can_edit_component_group_id, 1)
				,(1, @can_see_unit_in_search_group_id, 1)
				,(1, @all_g_flags_group_id, 1)
				,(1, @all_r_flags_group_id, 1)
				,(1, @list_visible_assignees_group_id, 1)
				,(1, @see_visible_assignees_group_id, 1)
				,(1, @active_stakeholder_group_id, 1)
				,(1, @unit_creator_group_id, 1)
				,(1, @group_id_show_to_tenant, 1)
				,(1, @group_id_are_users_tenant, 1)
				,(1, @group_id_see_users_tenant, 1)
				,(1, @group_id_show_to_landlord, 1)
				,(1, @group_id_are_users_landlord, 1)
				,(1, @group_id_see_users_landlord, 1)
				,(1, @group_id_show_to_agent, 1)
				,(1, @group_id_are_users_agent, 1)
				,(1, @group_id_see_users_agent, 1)
				,(1, @group_id_show_to_contractor, 1)
				,(1, @group_id_are_users_contractor, 1)
				,(1, @group_id_see_users_contractor, 1)
				,(1, @group_id_show_to_mgt_cny, 1)
				,(1, @group_id_are_users_mgt_cny, 1)
				,(1, @group_id_see_users_mgt_cny, 1)
				,(1, @group_id_show_to_occupant, 1)
				,(1, @group_id_are_users_occupant, 1)
				,(1, @group_id_see_users_occupant, 1)
				,(1, @group_id_are_users_invited_by, 1)
				,(1, @group_id_see_users_invited_by, 1)
				
				# Admin MUST be a member of the mandatory group for this unit
				# If not it is impossible to see this product in the BZFE backend.
				,(1, @can_see_unit_in_search_group_id,0)
				# Visibility groups:
				, (@all_r_flags_group_id, @all_g_flags_group_id, 2)
				, (@see_visible_assignees_group_id, @list_visible_assignees_group_id, 2)
				, (@unit_creator_group_id, @unit_creator_group_id, 2)
				, (@group_id_see_users_tenant, @group_id_are_users_tenant, 2)
				, (@group_id_see_users_landlord, @group_id_are_users_landlord, 2)
				, (@group_id_see_users_agent, @group_id_are_users_contractor, 2)
				, (@group_id_see_users_mgt_cny, @group_id_are_users_mgt_cny, 2)
				, (@group_id_see_users_occupant, @group_id_are_users_occupant, 2)
				, (@group_id_see_users_invited_by, @group_id_are_users_invited_by, 2)
				;

	# We make sure that only user in certain groups can create, edit or see cases.

	# Make sure we have the correct value for the name of this script so the `ut_audit_log_table` has the correct info
		SET @script = 'PROCEDURE unit_create_with_dummy_users';

	# We can now do the insert
		INSERT INTO `group_control_map`
			(`group_id`
			, `product_id`
			, `entry`
			, `membercontrol`
			, `othercontrol`
			, `canedit`
			, `editcomponents`
			, `editbugs`
			, `canconfirm`
			) 
			VALUES 
			(@create_case_group_id, @product_id, 1, 0, 0, 0, 0, 0, 0)
			, (@can_edit_case_group_id, @product_id, 1, 0, 0, 1, 0, 0, 1)
			, (@can_edit_all_field_case_group_id, @product_id, 1, 0, 0, 1, 0, 1, 1)
			, (@can_edit_component_group_id, @product_id, 0, 0, 0, 0, 1, 0, 0)
			, (@can_see_cases_group_id, @product_id, 0, 2, 0, 0, 0, 0, 0)
			, (@can_see_unit_in_search_group_id, @product_id, 0, 3, 3, 0, 0, 0, 0)
			, (@group_id_show_to_tenant, @product_id, 0, 2, 0, 0, 0, 0, 0)
			, (@group_id_show_to_landlord, @product_id, 0, 2, 0, 0, 0, 0, 0)
			, (@group_id_show_to_agent, @product_id, 0, 2, 0, 0, 0, 0, 0)
			, (@group_id_show_to_contractor, @product_id, 0, 2, 0, 0, 0, 0, 0)
			, (@group_id_show_to_mgt_cny, @product_id, 0, 2, 0, 0, 0, 0, 0)
			, (@group_id_show_to_occupant, @product_id, 0, 2, 0, 0, 0, 0, 0)
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

		# We insert the series categories that BZ needs...
				
			# What are the name for the categories
				SET @series_category_product_name = @unit_for_group;
				SET @series_category_component_tenant_name = CONCAT('Tenant - ', @product_id,'_#', @component_id_tenant);
				SET @series_category_component_landlord_name = CONCAT('Landlord - ', @product_id,'_#', @component_id_landlord);
				SET @series_category_component_contractor_name = CONCAT('Contractor - ', @product_id,'_#', @component_id_contractor);
				SET @series_category_component_mgtcny_name = CONCAT('Mgt Cny - ', @product_id,'_#', @component_id_mgt_cny);
				SET @series_category_component_agent_name = CONCAT('Agent - ', @product_id,'_#', @component_id_agent);
				
			# What are the SQL queries for these series:
				
				# We need a sanitized unit name:
					SET @unit_name_for_serie_query = REPLACE(@unit, ' ', '%20');
				
				# Product
					SET @serie_search_unconfirmed = CONCAT('bug_status=UNCONFIRMED&product=', @unit_name_for_serie_query);
					SET @serie_search_confirmed = CONCAT('bug_status=CONFIRMED&product=', @unit_name_for_serie_query);
					SET @serie_search_in_progress = CONCAT('bug_status=IN_PROGRESS&product=', @unit_name_for_serie_query);
					SET @serie_search_reopened = CONCAT('bug_status=REOPENED&product=', @unit_name_for_serie_query);
					SET @serie_search_standby = CONCAT('bug_status=STAND%20BY&product=', @unit_name_for_serie_query);
					SET @serie_search_resolved = CONCAT('bug_status=RESOLVED&product=', @unit_name_for_serie_query);
					SET @serie_search_verified = CONCAT('bug_status=VERIFIED&product=', @unit_name_for_serie_query);
					SET @serie_search_closed = CONCAT('bug_status=CLOSED&product=', @unit_name_for_serie_query);
					SET @serie_search_fixed = CONCAT('resolution=FIXED&product=', @unit_name_for_serie_query);
					SET @serie_search_invalid = CONCAT('resolution=INVALID&product=', @unit_name_for_serie_query);
					SET @serie_search_wontfix = CONCAT('resolution=WONTFIX&product=', @unit_name_for_serie_query);
					SET @serie_search_duplicate = CONCAT('resolution=DUPLICATE&product=', @unit_name_for_serie_query);
					SET @serie_search_worksforme = CONCAT('resolution=WORKSFORME&product=', @unit_name_for_serie_query);
					SET @serie_search_all_open = CONCAT('bug_status=UNCONFIRMED&bug_status=CONFIRMED&bug_status=IN_PROGRESS&bug_status=REOPENED&bug_status=STAND%20BY&product=', @unit_name_for_serie_query);
					
				# Component
				
					# We need several variables to build this
						SET @serie_search_prefix_component_open = 'field0-0-0=resolution&type0-0-0=notregexp&value0-0-0=.&product='; 
						SET @serie_search_prefix_component_closed = 'field0-0-0=resolution&type0-0-0=regexp&value0-0-0=.&product=';
						SET @component_name_for_serie_tenant = REPLACE(@role_user_g_description_tenant, ' ', '%20');
						SET @component_name_for_serie_landlord = REPLACE(@role_user_g_description_landlord, ' ', '%20');
						SET @component_name_for_serie_contractor = REPLACE(@role_user_g_description_contractor, ' ', '%20');
						SET @component_name_for_serie_mgtcny = REPLACE(@role_user_g_description_mgt_cny, ' ', '%20');
						SET @component_name_for_serie_agent = REPLACE(@role_user_g_description_agent, ' ', '%20');
						
					# We can now derive the query needed to build these series
					
						SET @serie_search_all_open_tenant = (CONCAT (@serie_search_prefix_component_open
							, @unit_name_for_serie_query
							, '&component='
							, @component_name_for_serie_tenant)
							);
						SET @serie_search_all_closed_tenant = (CONCAT (@serie_search_prefix_component_closed
							, @unit_name_for_serie_query
							, '&component='
							, @component_name_for_serie_tenant)
							);
						SET @serie_search_all_open_landlord = (CONCAT (@serie_search_prefix_component_open
							, @unit_name_for_serie_query
							, '&component='
							, @component_name_for_serie_landlord)
							);
						SET @serie_search_all_closed_landlord = (CONCAT (@serie_search_prefix_component_closed
							, @unit_name_for_serie_query
							, '&component='
							, @component_name_for_serie_landlord)
							);
						SET @serie_search_all_open_contractor = (CONCAT (@serie_search_prefix_component_open
							, @unit_name_for_serie_query
							, '&component='
							, @component_name_for_serie_contractor)
							);
						SET @serie_search_all_closed_contractor = (CONCAT (@serie_search_prefix_component_closed
							, @unit_name_for_serie_query
							, '&component='
							, @component_name_for_serie_contractor)
							);
						SET @serie_search_all_open_mgtcny = (CONCAT (@serie_search_prefix_component_open
							, @unit_name_for_serie_query
							, '&component='
							, @component_name_for_serie_mgtcny)
							);
						SET @serie_search_all_closed_mgtcny = (CONCAT (@serie_search_prefix_component_closed
							, @unit_name_for_serie_query
							, '&component='
							, @component_name_for_serie_mgtcny)
							);
						SET @serie_search_all_open_agent = (CONCAT (@serie_search_prefix_component_open
							, @unit_name_for_serie_query
							, '&component='
							, @component_name_for_serie_agent)
							);
						SET @serie_search_all_closed_agent = (CONCAT (@serie_search_prefix_component_closed
							, @unit_name_for_serie_query
							, '&component='
							, @component_name_for_serie_agent)
							);

		# We have eveything, we can create the series_categories we need:
		# We insert the series_categories 1 by 1 to get the id for each series_categories easily

		# Make sure we have the correct value for the name of this script so the `ut_audit_log_table` has the correct info
			SET @script = 'PROCEDURE unit_create_with_dummy_users';

		# We can now insert the series category product
			INSERT INTO `series_categories`
				(`name`
				) 
				VALUES 
				(@series_category_product_name)
				;

			# We get the id for the series_category 
				SET @series_category_product = (SELECT LAST_INSERT_ID());

		# We can now insert the series category component_tenant
			INSERT INTO `series_categories`
				(`name`
				) 
				VALUES 
				(@series_category_component_tenant_name)
				;

			# We get the id for the series_category 
				SET @series_category_component_tenant = (SELECT LAST_INSERT_ID());

		# We can now insert the series category component_landlord
			INSERT INTO `series_categories`
				(`name`
				) 
				VALUES 
				(@series_category_component_landlord_name)
				;

			# We get the id for the series_category 
				SET @series_category_component_landlord = (SELECT LAST_INSERT_ID());

		# We can now insert the series category component_contractor
			INSERT INTO `series_categories`
				(`name`
				) 
				VALUES 
				(@series_category_component_contractor_name)
				;

			# We get the id for the series_category 
				SET @series_category_component_contractor = (SELECT LAST_INSERT_ID());

		# We can now insert the series category component_mgtcny
			INSERT INTO `series_categories`
				(`name`
				) 
				VALUES 
				(@series_category_component_mgtcny_name)
				;

			# We get the id for the series_category 
				SET @series_category_component_mgtcny = (SELECT LAST_INSERT_ID());

		# We can now insert the series category component_agent
			INSERT INTO `series_categories`
				(`name`
				) 
				VALUES 
				(@series_category_component_agent_name)
				;

			# We get the id for the series_category 
				SET @series_category_component_agent = (SELECT LAST_INSERT_ID());

		# We do not need the series_id - we can insert in bulk here

			# Make sure we have the correct value for the name of this script so the `ut_audit_log_table` has the correct info
				SET @script = 'PROCEDURE unit_create_with_dummy_users';

			# Insert the series related to the product/unit
				INSERT INTO `series`
					(`series_id`
					, `creator`
					, `category`
					, `subcategory`
					, `name`
					, `frequency`
					, `query`
					, `is_public`
					) 
					VALUES 
					(NULL, @creator_bz_id, @series_category_product, 2, 'UNCONFIRMED', 1, @serie_search_unconfirmed, 1)
					,(NULL, @creator_bz_id, @series_category_product, 2, 'CONFIRMED', 1, @serie_search_confirmed, 1)
					,(NULL, @creator_bz_id, @series_category_product, 2, 'IN_PROGRESS', 1, @serie_search_in_progress, 1)
					,(NULL, @creator_bz_id, @series_category_product, 2, 'REOPENED', 1, @serie_search_reopened, 1)
					,(NULL, @creator_bz_id, @series_category_product, 2, 'STAND BY', 1, @serie_search_standby, 1)
					,(NULL, @creator_bz_id, @series_category_product, 2, 'RESOLVED', 1, @serie_search_resolved, 1)
					,(NULL, @creator_bz_id, @series_category_product, 2, 'VERIFIED', 1, @serie_search_verified, 1)
					,(NULL, @creator_bz_id, @series_category_product, 2, 'CLOSED', 1, @serie_search_closed, 1)
					,(NULL, @creator_bz_id, @series_category_product, 2, 'FIXED', 1, @serie_search_fixed, 1)
					,(NULL, @creator_bz_id, @series_category_product, 2, 'INVALID', 1, @serie_search_invalid, 1)
					,(NULL, @creator_bz_id, @series_category_product, 2, 'WONTFIX', 1, @serie_search_wontfix, 1)
					,(NULL, @creator_bz_id, @series_category_product, 2, 'DUPLICATE', 1, @serie_search_duplicate, 1)
					,(NULL, @creator_bz_id, @series_category_product, 2, 'WORKSFORME', 1, @serie_search_worksforme, 1)
					,(NULL, @creator_bz_id, @series_category_product, 2, 'All Open', 1, @serie_search_all_open, 1)
					;
					
			# Insert the series related to the Components/roles
				INSERT INTO `series`
					(`series_id`
					, `creator`
					, `category`
					, `subcategory`
					, `name`
					, `frequency`
					, `query`
					, `is_public`
					) 
					VALUES
					# Tenant
					(NULL, @creator_bz_id, @series_category_product, @series_category_component_tenant, 'All Open', 1, @serie_search_all_open_tenant, 1)
					,(NULL, @creator_bz_id, @series_category_product, @series_category_component_tenant, 'All Closed' , 1, @serie_search_all_closed_tenant, 1)
					# Landlord
					,(NULL, @creator_bz_id, @series_category_product, @series_category_component_landlord, 'All Open', 1, @serie_search_all_open_landlord, 1)
					,(NULL, @creator_bz_id, @series_category_product, @series_category_component_landlord, 'All Closed', 1, @serie_search_all_closed_landlord, 1)
					# Contractor
					,(NULL, @creator_bz_id, @series_category_product, @series_category_component_contractor, 'All Open', 1, @serie_search_all_open_contractor, 1)
					,(NULL, @creator_bz_id, @series_category_product, @series_category_component_contractor, 'All Closed', 1, @serie_search_all_closed_contractor, 1)
					# Management Company
					,(NULL, @creator_bz_id, @series_category_product, @series_category_component_mgtcny, 'All Open', 1, @serie_search_all_open_mgtcny, 1)
					,(NULL, @creator_bz_id, @series_category_product, @series_category_component_mgtcny, 'All Closed', 1, @serie_search_all_closed_mgtcny, 1)
					# Agent
					,(NULL, @creator_bz_id, @series_category_product, @series_category_component_agent, 'All Open', 1, @serie_search_all_open_agent, 1)
					,(NULL, @creator_bz_id, @series_category_product, @series_category_component_agent, 'All Closed', 1, @serie_search_all_closed_agent, 1)
					;

	# We now assign the permissions to each of the dummy user associated to each role:
	#	- Tenant (1)
	#	 @bz_user_id_dummy_tenant
	#	- Landlord (2)
	#	 @bz_user_id_dummy_landlord
	#	- Contractor (3)
	#	 @bz_user_id_dummy_contractor
	#	- Management company (4)
	#	 @bz_user_id_dummy_mgt_cny
	#	- Agent (5)
	#	 @bz_user_id_dummy_agent
	#
	#
	# For each of the dummy users, we use the following parameters:
		SET @user_in_default_cc_for_cases = 1;
		SET @replace_default_assignee = 1;

		# Default permissions for dummy users:	
			#User Permissions in the unit:
				# Generic Permissions
					SET @can_see_time_tracking = 0;
					SET @can_create_shared_queries = 0;
					SET @can_tag_comment = 0;
				# Product/Unit specific permissions
					SET @can_create_new_cases = 1;
					SET @can_edit_a_case = 1;
					SET @can_see_all_public_cases = 0;
					SET @can_edit_all_field_in_a_case_regardless_of_role = 1;
					SET @can_see_unit_in_search = 0;
					SET @user_is_publicly_visible = 0;
					SET @user_can_see_publicly_visible = 0;
					SET @can_ask_to_approve_flags = 0;
					SET @can_approve_all_flags = 0;
 
	# We create the permissions for the dummy user to create a case for this unit.		
	#	- can tag comments: ALL user need that	
	#	- can_create_new_cases
	#	- can_edit_a_case
	# This is the only permission that the dummy user will have.
		# First the global permissions:
			# Can tag comments
				INSERT INTO `ut_user_group_map_temp`
					(`user_id`
					, `group_id`
					, `isbless`
					, `grant_type`
					) 
					VALUES 
					(@bz_user_id_dummy_tenant, @can_tag_comment_group_id, 0, 0)
					, (@bz_user_id_dummy_landlord, @can_tag_comment_group_id, 0, 0)
					, (@bz_user_id_dummy_agent, @can_tag_comment_group_id, 0, 0)
					, (@bz_user_id_dummy_contractor, @can_tag_comment_group_id, 0, 0)
					, (@bz_user_id_dummy_mgt_cny, @can_tag_comment_group_id, 0, 0)
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
		 
				# Cleanup the variables for the log messages
					SET @script_log_message = NULL;
		
		# Then the permissions at the unit/product level:
					
			# User can create a case:
				INSERT INTO `ut_user_group_map_temp`
					(`user_id`
					, `group_id`
					, `isbless`
					, `grant_type`
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
 
				# Cleanup the variables for the log messages
					SET @script_log_message = NULL;

			# User can Edit a case and see this unit, this is needed so the API does not throw an error see issue #60:
				INSERT INTO `ut_user_group_map_temp`
					(`user_id`
					, `group_id`
					, `isbless`
					, `grant_type`
					) 
					VALUES 
					(@bz_user_id_dummy_tenant, @can_edit_case_group_id, 0, 0)
					, (@bz_user_id_dummy_landlord, @can_edit_case_group_id, 0, 0)
					, (@bz_user_id_dummy_agent, @can_edit_case_group_id, 0, 0)
					, (@bz_user_id_dummy_contractor, @can_edit_case_group_id, 0, 0)
					, (@bz_user_id_dummy_mgt_cny, @can_edit_case_group_id, 0, 0)
					, (@bz_user_id_dummy_tenant, @can_see_unit_in_search_group_id, 0, 0)
					, (@bz_user_id_dummy_landlord, @can_see_unit_in_search_group_id, 0, 0)
					, (@bz_user_id_dummy_agent, @can_see_unit_in_search_group_id, 0, 0)
					, (@bz_user_id_dummy_contractor, @can_see_unit_in_search_group_id, 0, 0)
					, (@bz_user_id_dummy_mgt_cny, @can_see_unit_in_search_group_id, 0, 0)
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
				 
				# Cleanup the variables for the log messages
					SET @script_log_message = NULL;

	# We give the user the permission they need.

		# We update the `group_group_map` table first
		#	- Create an intermediary table to deduplicate the records in the table `ut_group_group_map_temp`
		#	- If the record does NOT exists in the table then INSERT new records in the table `group_group_map`
		#	- If the record DOES exist in the table then update the new records in the table `group_group_map`

			# We drop the deduplication table if it exists:
				DROP TEMPORARY TABLE IF EXISTS `ut_group_group_map_dedup`;

			# We create a table `ut_group_group_map_dedup` to prepare the data we need to insert
				CREATE TEMPORARY TABLE `ut_group_group_map_dedup` (
					`member_id` mediumint(9) NOT NULL
					, `grantor_id` mediumint(9) NOT NULL
					, `grant_type` tinyint(4) NOT NULL DEFAULT '0'
#					, UNIQUE KEY `ut_group_group_map_dedup_member_id_idx` (`member_id`, `grantor_id`, `grant_type`)
#					, KEY `fk_group_group_map_dedup_grantor_id_groups_id` (`grantor_id`)
#					, KEY `group_group_map_dedup_grantor_id_grant_type_idx` (`grantor_id`, `grant_type`)
#					, KEY `group_group_map_dedup_member_id_grant_type_idx` (`member_id`, `grant_type`)
					) 
				;
	
			# We insert the de-duplicated record in the table `ut_group_group_map_dedup`
				INSERT INTO `ut_group_group_map_dedup`
				SELECT `member_id`
					, `grantor_id`
					, `grant_type`
				FROM
					`ut_group_group_map_temp`
				GROUP BY `member_id`
					, `grantor_id`
					, `grant_type`
				ORDER BY `member_id` ASC
					, `grantor_id` ASC
				;

			# We insert the data we need in the `group_group_map` table

				# Make sure we have the correct value for the name of this script so the `ut_audit_log_table` has the correct info
					SET @script = 'PROCEDURE unit_create_with_dummy_users';

				# We can now do the insert
					INSERT INTO `group_group_map`
					SELECT `member_id`
						, `grantor_id`
						, `grant_type`
					FROM
						`ut_group_group_map_dedup`
					# The below code is overkill in this context: 
					# the Unique Key Constraint makes sure that all records are unique in the table `ut_group_group_map_dedup`
					ON DUPLICATE KEY UPDATE
						`member_id` = `ut_group_group_map_dedup`.`member_id`
						, `grantor_id` = `ut_group_group_map_dedup`.`grantor_id`
						, `grant_type` = `ut_group_group_map_dedup`.`grant_type`
					;

			# We drop the temp table as we do not need it anymore
				DROP TEMPORARY TABLE IF EXISTS `ut_group_group_map_dedup`;

		# We can now update the permissions table for the users
		# This NEEDS the table 'ut_user_group_map_temp'
			CALL `update_permissions_invited_user`;

	# Update the table 'ut_data_to_create_units' so that we record that the unit has been created

		# Make sure we have the correct value for the name of this script so the `ut_audit_log_table` has the correct info
			SET @script = 'PROCEDURE unit_create_with_dummy_users';

		# We can now do the uppdate
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
		
END $$
DELIMITER ;
