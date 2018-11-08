# For any question about this script, ask Franck
#
###################################################################################
#
# WARNING! 
#	- It is MANDATORY to use Amazon Aurora database engine for this version
#
# Make sure to also update the below variable(s)
#
###################################################################################
#
# What are the version of the Unee-T BZ Database schema BEFORE and AFTER this update?
	SET @old_schema_version = 'v3.24';
	SET @new_schema_version = 'v3.25';
#
# What is the name of this script?
	SET @this_script = 'upgrade_unee-t_v3.24_to_v3.25.sql';
#
###############################
#
# We have everything we need
#
###############################
# This update
#
#   - Change the methodology to update user permissions:
#     We update the procedure `update_permissions_invited_user`
#       - BEFORE: truncate table and re-populate it
#       - AFTER: never truncate: insert or update if exists
#	  To do that we are creating and additional temporary table: `user_group_map_dedup`
#	- Change the procedure `revoke_all_permission_for_this_user_in_this_unit` 
#	  so that we delete the record in the table `user_group_map` directly
#
				
# When are we doing this?
	SET @the_timestamp = NOW();

# Change the methodology to update user permissions:
#       - BEFORE: truncate table and re-populate it
#       - AFTER: never truncate: insert or update if existsWe need a procedure `update_log_count_enabled_units` to update the table `ut_log_count_enabled_units`
	
	DROP PROCEDURE IF EXISTS `update_permissions_invited_user`;

DELIMITER $$
CREATE PROCEDURE `update_permissions_invited_user`()
SQL SECURITY INVOKER
BEGIN
	# We update the `user_group_map` table
    #   - Create an intermediary table to deduplicate the records in the table `ut_user_group_map_temp`
    #   - If the record does NOT exists in the table then INSERT new records in the table `user_group_map`
    #   - If the record DOES exist in the table then update the new records in the table `user_group_map`

	# We drop the deduplication table if it exists:
		DROP TABLE IF EXISTS `user_group_map_dedup`;

	# We create a table `user_group_map_dedup` to prepare the data we need to insert
		CREATE TABLE `user_group_map_dedup` (
			`user_id` MEDIUMINT(9) NOT NULL,
			`group_id` MEDIUMINT(9) NOT NULL,
			`isbless` TINYINT(4) NOT NULL DEFAULT '0',
			`grant_type` TINYINT(4) NOT NULL DEFAULT '0',
			UNIQUE KEY `user_group_map_dedup_user_id_idx` (`user_id`,`group_id`,`grant_type`,`isbless`),
			KEY `fk_user_group_map_dedup_group_id_groups_id` (`group_id`),
			CONSTRAINT `fk_user_group_map_dedup_group_id_groups_id` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
			CONSTRAINT `fk_user_group_map_dedup_user_id_profiles_userid` FOREIGN KEY (`user_id`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE
			)
		;
		
	# We insert the de-duplicated record in the table `user_group_map_dedup`

		INSERT INTO `user_group_map_dedup`
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
			
	# We insert the data we need in the `user_group_map` table
		INSERT INTO `user_group_map`
		SELECT `user_id`
			, `group_id`
			, `isbless`
			, `grant_type`
		FROM
			`user_group_map_dedup`
		# The below code is overkill in this context: 
		# the Unique Key Constraint makes sure that all records are unique in the table `user_group_map`
		ON DUPLICATE KEY UPDATE
			`user_id` = `user_group_map_dedup`.`user_id`
			, `group_id` = `user_group_map_dedup`.`group_id`
			, `isbless` = `user_group_map_dedup`.`isbless`
			, `grant_type` = `user_group_map_dedup`.`grant_type`
		;

	# We drop the temp table as we do not need it anymore
		DROP TABLE IF EXISTS `ut_user_group_map_temp`;
		DROP TABLE IF EXISTS `user_group_map_dedup`;

END $$
DELIMITER ;

	# We make sure that we can revoke the permission for a given user

	DROP PROCEDURE IF EXISTS `revoke_all_permission_for_this_user_in_this_unit`;

DELIMITER $$
CREATE PROCEDURE `revoke_all_permission_for_this_user_in_this_unit`()
    SQL SECURITY INVOKER
BEGIN

	# We record the name of this procedure for future debugging and audit_log
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

		DELETE FROM `user_group_map`
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
				
				SET @bzfe_table = 'user_group_map';
				
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
END $$
DELIMITER ;

# We also make sure that we use the correct definition for the Unee-T fields:

    CALL `update_bz_fielddefs`; 

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