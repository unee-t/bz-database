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
	SET @old_schema_version = 'v3.26';
	SET @new_schema_version = 'v3.27';
#
# What is the name of this script?
	SET @this_script = 'upgrade_unee-t_v3.26_to_v3.27.sql';
#
###############################
#
# We have everything we need
#
###############################
# This update
#
#   - Add a unique key constraint to the table `group_group_map`
#     This is to facilitate updates of this table
#
#   - Create the table `ut_user_group_map_temp` once.
#
#   - Create a procedure `create_temp_table_to_update_group_permissions` to create the table `ut_group_group_map_temp`
#
#   - Call the procedure `create_temp_table_to_update_group_permissions` to create the table `ut_group_group_map_temp`
#
#   - When we revoke permissions, make sure we do this also in the table `ut_user_group_map_temp`
#         Update the procedure `revoke_all_permission_for_this_user_in_this_unit`
#
#   - Make sure we never call `create_temp_table_to_update_permissions` as part of another procedure.
#     This could create a race condition where the table is deleted at the wrong time.
#     We need to update the procedures:
#       - `add_user_to_role_in_unit`
#           - BEFORE: the table `ut_user_group_map_temp` was recreated each time
#           - AFTER:  the table `ut_user_group_map_temp` is not re-created
#
#   - When we update the permissions, make sure we do not delete the table `ut_user_group_map_temp`
#     We update the procedure
#       - `update_permissions_invited_user`
#           - BEFORE: we deleted the table `ut_user_group_map_temp`
#           - AFTER: we do NOT delete the table `ut_user_group_map_temp`
#
#   - Update the procedure `unit_create_with_dummy_users` to
#       - make sure we do not truncate table `user_group_map`
#       - use standardized procedures where needed:
#           - `table_to_list_dummy_user_by_environment` 
#             a procedure to create a temporary table to record the ids of the dummy users in each environments
#
#        - Minimizes the risk of race condition for components:
#         for each component we need to:
#           - check latest available id
#           - insert the component in the `components` table
#           - move to the next component
#
#       - Minimizes the risk of race condition for flagtypes:
#         for each flagtypes we need to:
#           - check latest available id
#           - insert the flagtypes in the `flagtypes` table
#           - move to the next flagtype
#
#       - Minimizes the risk of race condition for groups:
#         for each group we need to:
#           - check latest available id
#           - insert the group in the `groups` table
#           - move to the next group
#
#####################
#
# Do it!
#
#####################

# When are we doing this?
	SET @the_timestamp = NOW();

# Add a unique key constraint to the table `group_group_map`

    ALTER TABLE `group_group_map` 
    	ADD UNIQUE KEY `group_group_map_member_id_idx`(`member_id`,`grantor_id`,`grant_type`) 
    ;

# We create the table `ut_user_group_map_temp`
    CALL `create_temp_table_to_update_permissions`;

# Create a procedure `create_temp_table_to_update_group_permissions` to create the table `ut_group_group_map_temp`

    # First we drop the procedure if it exists

        DROP PROCEDURE IF EXISTS create_temp_table_to_update_group_permissions;

    # We then re-create the procedure `create_temp_table_to_update_group_permissions`

DELIMITER $$
CREATE PROCEDURE create_temp_table_to_update_group_permissions()
SQL SECURITY INVOKER
BEGIN

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

END $$
DELIMITER ;

# Call the procedure `create_temp_table_to_update_group_permissions` to create the table `ut_group_group_map_temp`

    CALL `create_temp_table_to_update_group_permissions`;

# Update the procedure to revoke the permission for a given user
# make sure we revoke permissions also in the table `ut_user_group_map_temp`

	DROP PROCEDURE IF EXISTS `revoke_all_permission_for_this_user_in_this_unit`;

DELIMITER $$
CREATE PROCEDURE `revoke_all_permission_for_this_user_in_this_unit`()
SQL SECURITY INVOKER
BEGIN

    # this procedure needs the following variables:
    #   - @product_id
    #   - @bz_user_id

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

        # We also delete from the table `ut_user_group_map_temp`
        # This is needed so we do not re-create the permissions when we invite a new user or create a new unit.

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

# Update the procedure `update_permissions_invited_user`
# When we update the permissions, make sure we do not delete the table `ut_user_group_map_temp`

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
		DROP TABLE IF EXISTS `user_group_map_dedup`;

END $$
DELIMITER ;

# Update the procedure to create a unit with dummy users

    DROP PROCEDURE IF EXISTS `unit_create_with_dummy_users`;

DELIMITER $$
CREATE PROCEDURE `unit_create_with_dummy_users`()
SQL SECURITY INVOKER
BEGIN
	# This procedure needs the following variables:
	#	- @mefe_unit_id
	#	- @environment
    #
    # This procedure needs the table `ut_user_group_map_temp`
    #
    # This procedure needs the following info in the table `ut_data_to_create_units`
    #   - id_unit_to_create
    #   - mefe_unit_id
    #   - mefe_creator_user_id
    #   - bzfe_creator_user_id
    #   - classification_id
    #   - unit_name
    #   - unit_description_details
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
    #   -  in the table `ut_data_to_create_units`
    #       - bz_created_date
    #       - comment
    #       - product_id    
	#	- the Unee-T script log
	#	- BZ db table `audit_log`
    #
    # This procedure depends on the following procedures:
    #   - `table_to_list_dummy_user_by_environment`
    
	
	# What is the record that we need to use to create the objects in BZ?
		SET @unit_reference_for_import = (SELECT `id_unit_to_create` FROM `ut_data_to_create_units` WHERE `mefe_unit_id` = @mefe_unit_id);
	
	# We record the name of this procedure for future debugging and audit_log
		SET @script = 'PROCEDURE - unit_create_with_dummy_users';
		SET @timestamp = NOW();

	# We create a temporary table to record the ids of the dummy users in each environments:

        CALL `table_to_list_dummy_user_by_environment`;
			
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
			
			# We can now insert the milestone there
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
        # We insert the component 1 by 1 to minimize the risks of a race condition

			# Tenant (component_id_tenant)
                SET @component_id_tenant = ((SELECT MAX(`id`) FROM `components`) + 1);

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
                    ;

            # Landlord (component_id_landlord)
                SET @component_id_landlord = ((SELECT MAX(`id`) FROM `components`) + 1);

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
                    (@component_id_landlord, @role_user_g_description_landlord, @product_id, @bz_user_id_dummy_landlord, @bz_user_id_dummy_landlord, @user_role_desc_landlord, 1)
                    ;

            # Agent (component_id_agent)
                SET @component_id_agent = ((SELECT MAX(`id`) FROM `components`) + 1);

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
                    (@component_id_agent, @role_user_g_description_agent, @product_id, @bz_user_id_dummy_agent, @bz_user_id_dummy_agent, @user_role_desc_agent, 1)
                    ;

            # Contractor (component_id_contractor)
                SET @component_id_contractor = ((SELECT MAX(`id`) FROM `components`) + 1);

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
                    (@component_id_contractor, @role_user_g_description_contractor, @product_id, @bz_user_id_dummy_contractor, @bz_user_id_dummy_contractor, @user_role_desc_contractor, 1)
                    ;
            
            # Management Company (component_id_mgt_cny)
				SET @component_id_mgt_cny = ((SELECT MAX(`id`) FROM `components`) + 1);

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
                    (@component_id_mgt_cny, @role_user_g_description_mgt_cny, @product_id, @bz_user_id_dummy_mgt_cny, @bz_user_id_dummy_mgt_cny, @user_role_desc_mgt_cny, 1)
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
					SET @group_description_tenant = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 1),@visibility_explanation_2));
				
					# Is in tenant user Group
					SET @group_name_are_users_tenant = (CONCAT(@unit_for_group,'-06-List-Tenant'));
					SET @group_description_are_users_tenant = (CONCAT('list the tenant(s)', @unit));
					
					# Can See tenant user Group
					SET @group_name_see_users_tenant = (CONCAT(@unit_for_group,'-06-Can-see-Tenant'));
					SET @group_description_see_users_tenant = (CONCAT('See the list of tenant(s) for ', @unit));
			
				# For the Landlord
					# Visibility group 
					SET @group_name_show_to_landlord = (CONCAT(@unit_for_group,'-02-Limit-to-Landlord'));
					SET @group_description_show_to_landlord = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 2),@visibility_explanation_2));
					
					# Is in landlord user Group
					SET @group_name_are_users_landlord = (CONCAT(@unit_for_group,'-06-List-landlord'));
					SET @group_description_are_users_landlord = (CONCAT('list the landlord(s)', @unit));
					
					# Can See landlord user Group
					SET @group_name_see_users_landlord = (CONCAT(@unit_for_group,'-06-Can-see-lanldord'));
					SET @group_description_see_users_landlord = (CONCAT('See the list of lanldord(s) for ', @unit));
					
				# For the agent
					# Visibility group 
					SET @group_name_show_to_agent = (CONCAT(@unit_for_group,'-02-Limit-to-Agent'));
					SET @group_description_show_to_agent = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 5),@visibility_explanation_2));
					
					# Is in Agent user Group
					SET @group_name_are_users_agent = (CONCAT(@unit_for_group,'-06-List-agent'));
					SET @group_description_are_users_agent = (CONCAT('list the agent(s)', @unit));
					
					# Can See Agent user Group
					SET @group_name_see_users_agent = (CONCAT(@unit_for_group,'-06-Can-see-agent'));
					SET @group_description_see_users_agent = (CONCAT('See the list of agent(s) for ', @unit));
				
				# For the contractor
					# Visibility group 
					SET @group_name_show_to_contractor = (CONCAT(@unit_for_group,'-02-Limit-to-Contractor-Employee'));
					SET @group_description_show_to_contractor = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 3),@visibility_explanation_2));
					
					# Is in contractor user Group
					SET @group_name_are_users_contractor = (CONCAT(@unit_for_group,'-06-List-contractor-employee'));
					SET @group_description_are_users_contractor = (CONCAT('list the contractor employee(s)', @unit));
					
					# Can See contractor user Group
					SET @group_name_see_users_contractor = (CONCAT(@unit_for_group,'-06-Can-see-contractor-employee'));
					SET @group_description_see_users_contractor = (CONCAT('See the list of contractor employee(s) for ', @unit));
					
				# For the Mgt Cny
					# Visibility group
					SET @group_name_show_to_mgt_cny = (CONCAT(@unit_for_group,'-02-Limit-to-Mgt-Cny-Employee'));
					SET @group_description_show_to_mgt_cny = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 4),@visibility_explanation_2));
					
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
        # We insert the groups 1 by 1 to minimize the risk of a race conditions when we get the group_id

            # create_case_group_id
				SET @create_case_group_id = ((SELECT MAX(`id`) FROM `groups`) + 1);

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
                    ;

            # can_edit_case_group_id
                SET @can_edit_case_group_id = ((SELECT MAX(`id`) FROM `groups`) + 1);

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
                    (@can_edit_case_group_id,@group_name_can_edit_case_group,@group_description_can_edit_case_group,1,'',1,NULL)
                    ;            

            # can_see_cases_group_id
                SET @can_see_cases_group_id = ((SELECT MAX(`id`) FROM `groups`) + 1);

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
                    (@can_see_cases_group_id,@group_name_can_see_cases_group,@group_description_can_see_cases_group,1,'',1,NULL)
                    ;

            # can_edit_all_field_case_group_id
                SET @can_edit_all_field_case_group_id = ((SELECT MAX(`id`) FROM `groups`) + 1);

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
                    (@can_edit_all_field_case_group_id,@group_name_can_edit_all_field_case_group,@group_description_can_edit_all_field_case_group,1,'',1,NULL)
                    ;

            # can_edit_component_group_id
                SET @can_edit_component_group_id = ((SELECT MAX(`id`) FROM `groups`) + 1);

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
                    (@can_edit_component_group_id,@group_name_can_edit_component_group,@group_description_can_edit_component_group,1,'',1,NULL)
                    ;

            # can_see_unit_in_search_group_id
                SET @can_see_unit_in_search_group_id = ((SELECT MAX(`id`) FROM `groups`) + 1);

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
                    (@can_see_unit_in_search_group_id,@group_name_can_see_unit_in_search_group,@group_description_can_see_unit_in_search_group,1,'',1,NULL)
                    ;

            # all_g_flags_group_id
                SET @all_g_flags_group_id = ((SELECT MAX(`id`) FROM `groups`) + 1);

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
                    (@all_g_flags_group_id,@group_name_all_g_flags_group,@group_description_all_g_flags_group,1,'',0,NULL)
                    ;

            # all_r_flags_group_id
                SET @all_r_flags_group_id = ((SELECT MAX(`id`) FROM `groups`) + 1);

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
                    (@all_r_flags_group_id,@group_name_all_r_flags_group,@group_description_all_r_flags_group,1,'',0,NULL)
                    ;

            # list_visible_assignees_group_id
                SET @list_visible_assignees_group_id = ((SELECT MAX(`id`) FROM `groups`) + 1);

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
                    (@list_visible_assignees_group_id,@group_name_list_visible_assignees_group,@group_description_list_visible_assignees_group,1,'',0,NULL)
                    ;

            # see_visible_assignees_group_id
                SET @see_visible_assignees_group_id = ((SELECT MAX(`id`) FROM `groups`) + 1);

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
                    (@see_visible_assignees_group_id,@group_name_see_visible_assignees_group,@group_description_see_visible_assignees_group,1,'',0,NULL)
                    ;

            # active_stakeholder_group_id
                SET @active_stakeholder_group_id = ((SELECT MAX(`id`) FROM `groups`) + 1);

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
                    (@active_stakeholder_group_id,@group_name_active_stakeholder_group,@group_description_active_stakeholder_group,1,'',1,NULL)
                    ;

            # unit_creator_group_id
                SET @unit_creator_group_id = ((SELECT MAX(`id`) FROM `groups`) + 1);

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
                    (@unit_creator_group_id,@group_name_unit_creator_group,@group_description_unit_creator_group,1,'',0,NULL)
                    ;

            # group_id_show_to_tenant
                SET @group_id_show_to_tenant = ((SELECT MAX(`id`) FROM `groups`) + 1);

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
                    (@group_id_show_to_tenant,@group_name_show_to_tenant,@group_description_tenant,1,'',1,NULL)
                    ;

            # group_id_are_users_tenant
                SET @group_id_are_users_tenant = ((SELECT MAX(`id`) FROM `groups`) + 1);

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
                    (@group_id_are_users_tenant,@group_name_are_users_tenant,@group_description_are_users_tenant,1,'',0,NULL)
                    ;

            # group_id_see_users_tenant
                SET @group_id_see_users_tenant = ((SELECT MAX(`id`) FROM `groups`) + 1);

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
                    (@group_id_see_users_tenant,@group_name_see_users_tenant,@group_description_see_users_tenant,1,'',0,NULL)
                    ;

            # group_id_show_to_landlord
                SET @group_id_show_to_landlord = ((SELECT MAX(`id`) FROM `groups`) + 1);

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
                    (@group_id_show_to_landlord,@group_name_show_to_landlord,@group_description_show_to_landlord,1,'',1,NULL)
                    ;

            # group_id_are_users_landlord
                SET @group_id_are_users_landlord = ((SELECT MAX(`id`) FROM `groups`) + 1);

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
                    (@group_id_are_users_landlord,@group_name_are_users_landlord,@group_description_are_users_landlord,1,'',0,NULL)
                    ;

            # group_id_see_users_landlord
                SET @group_id_see_users_landlord = ((SELECT MAX(`id`) FROM `groups`) + 1);

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
                    (@group_id_see_users_landlord,@group_name_see_users_landlord,@group_description_see_users_landlord,1,'',0,NULL)
                    ;

            # group_id_show_to_agent
                SET @group_id_show_to_agent = ((SELECT MAX(`id`) FROM `groups`) + 1);

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
                    (@group_id_show_to_agent,@group_name_show_to_agent,@group_description_show_to_agent,1,'',1,NULL)
                    ;

            # group_id_are_users_agent
                SET @group_id_are_users_agent = ((SELECT MAX(`id`) FROM `groups`) + 1);

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
                    (@group_id_are_users_agent,@group_name_are_users_agent,@group_description_are_users_agent,1,'',0,NULL)
                    ;

            # group_id_see_users_agent
                SET @group_id_see_users_agent = ((SELECT MAX(`id`) FROM `groups`) + 1);

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
                    (@group_id_see_users_agent,@group_name_see_users_agent,@group_description_see_users_agent,1,'',0,NULL)
                    ;

            # group_id_show_to_contractor
                SET @group_id_show_to_contractor = ((SELECT MAX(`id`) FROM `groups`) + 1);

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
                    (@group_id_show_to_contractor,@group_name_show_to_contractor,@group_description_show_to_contractor,1,'',1,NULL)
                    ;

            # group_id_are_users_contractor
                SET @group_id_are_users_contractor = ((SELECT MAX(`id`) FROM `groups`) + 1);

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
                    (@group_id_are_users_contractor,@group_name_are_users_contractor,@group_description_are_users_contractor,1,'',0,NULL)
                    ;

            # group_id_see_users_contractor
                SET @group_id_see_users_contractor = ((SELECT MAX(`id`) FROM `groups`) + 1);

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
                    (@group_id_see_users_contractor,@group_name_see_users_contractor,@group_description_see_users_contractor,1,'',0,NULL)
                    ;

            # group_id_show_to_mgt_cny
                SET @group_id_show_to_mgt_cny = ((SELECT MAX(`id`) FROM `groups`) + 1);

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
                    (@group_id_show_to_mgt_cny,@group_name_show_to_mgt_cny,@group_description_show_to_mgt_cny,1,'',1,NULL)
                    ;

            # group_id_are_users_mgt_cny
                SET @group_id_are_users_mgt_cny = ((SELECT MAX(`id`) FROM `groups`) + 1);

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
                    (@group_id_are_users_mgt_cny,@group_name_are_users_mgt_cny,@group_description_are_users_mgt_cny,1,'',0,NULL)
                    ;

            # group_id_see_users_mgt_cny
                SET @group_id_see_users_mgt_cny = ((SELECT MAX(`id`) FROM `groups`) + 1);

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
                    (@group_id_see_users_mgt_cny,@group_name_see_users_mgt_cny,@group_description_see_users_mgt_cny,1,'',0,NULL)
                    ;            

            # group_id_show_to_occupant
                SET @group_id_show_to_occupant = ((SELECT MAX(`id`) FROM `groups`) + 1);

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
                    (@group_id_show_to_occupant,@group_name_show_to_occupant,@group_description_show_to_occupant,1,'',1,NULL)
                    ;            

            # group_id_are_users_occupant
                SET @group_id_are_users_occupant = ((SELECT MAX(`id`) FROM `groups`) + 1);

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
                    (@group_id_are_users_occupant,@group_name_are_users_occupant,@group_description_are_users_occupant,1,'',0,NULL)
                    ;            

            # group_id_see_users_occupant
                SET @group_id_see_users_occupant = ((SELECT MAX(`id`) FROM `groups`) + 1);
           
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
                    (@group_id_see_users_occupant,@group_name_see_users_occupant,@group_description_see_users_occupant,1,'',0,NULL)
                    ;            

            # group_id_are_users_invited_by
                SET @group_id_are_users_invited_by = ((SELECT MAX(`id`) FROM `groups`) + 1);

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
                    (@group_id_are_users_invited_by,@group_name_are_users_invited_by,@group_description_are_users_invited_by,1,'',0,NULL)
                    ;

            # group_id_see_users_invited_by
                SET @group_id_see_users_invited_by = ((SELECT MAX(`id`) FROM `groups`) + 1);

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
                    (@group_id_see_users_invited_by,@group_name_see_users_invited_by,@group_description_see_users_invited_by,1,'',0,NULL)
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
		
		# We need to define the data we need for each flag
			SET @flag_next_step_name = CONCAT('Next_Step_',@unit_for_flag);
			SET @flag_solution_name = CONCAT('Solution_',@unit_for_flag);
			SET @flag_budget_name = CONCAT('Budget_',@unit_for_flag);
			SET @flag_attachment_name = CONCAT('Attachment_',@unit_for_flag);
			SET @flag_ok_to_pay_name = CONCAT('OK_to_pay_',@unit_for_flag);
			SET @flag_is_paid_name = CONCAT('is_paid_',@unit_for_flag);
	
        # We insert the flagtypes 1 by 1 to minimize the risk of a race condition

		# We need to get the flagype id for next_step
			SET @flag_next_step_id = ((SELECT MAX(`id`) FROM `flagtypes`) + 1);

		# We can now create the flagtypes for next_step
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
				(@flag_next_step_id,@flag_next_step_name ,'Approval for the Next Step of the case.','','b',1,1,1,1,10,@all_g_flags_group_id,@all_r_flags_group_id)
                ;

		# We need to get the flagype id for solution
			SET @flag_solution_id = ((SELECT MAX(`id`) FROM `flagtypes`) + 1);

		# We can now create the flagtypes for solution
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
				(@flag_solution_id,@flag_solution_name ,'Approval for the Solution of this case.','','b',1,1,1,1,20,@all_g_flags_group_id,@all_r_flags_group_id)
                ;

		# We need to get the flagype id for budget
			SET @flag_budget_id = ((SELECT MAX(`id`) FROM `flagtypes`) + 1);

		# We can now create the flagtypes for budget
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
				(@flag_budget_id,@flag_budget_name ,'Approval for the Budget for this case.','','b',1,1,1,1,30,@all_g_flags_group_id,@all_r_flags_group_id)
                ;

		# We need to get the flagype id for attachment
			SET @flag_attachment_id = ((SELECT MAX(`id`) FROM `flagtypes`) + 1);

		# We can now create the flagtypes for attachment
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
                (@flag_attachment_id,@flag_attachment_name ,'Approval for this Attachment.','','a',1,1,1,1,10,@all_g_flags_group_id,@all_r_flags_group_id)
                ;

		# We need to get the flagype id for ok_to_pay
			SET @flag_ok_to_pay_id = ((SELECT MAX(`id`) FROM `flagtypes`) + 1);

		# We can now create the flagtypes for ok_to_pay
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
                (@flag_ok_to_pay_id,@flag_ok_to_pay_name ,'Approval to pay this bill.','','a',1,1,1,1,20,@all_g_flags_group_id,@all_r_flags_group_id)
                ;

		# We need to get the flagype id for is_paid
			SET @flag_is_paid_id = ((SELECT MAX(`id`) FROM `flagtypes`) + 1);

		# We can now create the flagtypes for is_paid
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
                (@flag_is_paid_id,@flag_is_paid_name ,'Confirm if this bill has been paid.','','a',1,1,1,1,30,@all_g_flags_group_id,@all_r_flags_group_id)
                ;

		# We also define the flag inclusion
			INSERT INTO `flaginclusions`
				(`type_id`
				,`product_id`
				,`component_id`
				) 
				VALUES
				(@flag_next_step_id,@product_id,NULL)
				,(@flag_solution_id,@product_id,NULL)
				,(@flag_budget_id,@product_id,NULL)
				,(@flag_attachment_id,@product_id,NULL)
				,(@flag_ok_to_pay_id,@product_id,NULL)
				,(@flag_is_paid_id,@product_id,NULL)
				;

		# Log the actions of the script.
			SET @script_log_message = CONCAT('We have created the following flags which are restricted to that unit: '
									, '\r\ - Next Step (#'
									, (SELECT IFNULL(@flag_next_step_id, 'flag_next_step is NULL'))
									, ').'
									, '\r\ - Solution (#'
									, (SELECT IFNULL(@flag_solution_id, 'flag_solution is NULL'))
									, ').'
									, '\r\ - Budget (#'
									, (SELECT IFNULL(@flag_budget_id, 'flag_budget is NULL'))
									, ').'
									, '\r\ - Attachment (#'
									, (SELECT IFNULL(@flag_attachment_id, 'flag_attachment is NULL'))
									, ').'
									, '\r\ - OK to pay (#'
									, (SELECT IFNULL(@flag_ok_to_pay_id, 'flag_ok_to_pay is NULL'))
									, ').'
									, '\r\ - Is paid (#'
									, (SELECT IFNULL(@flag_is_paid_id, 'flag_is_paid is NULL'))
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
				(@creator_bz_id, 'Bugzilla::FlagType', @flag_next_step_id, '__create__', NULL, @flag_next_step_name, @timestamp)
				, (@creator_bz_id, 'Bugzilla::FlagType', @flag_solution_id, '__create__', NULL, @flag_solution_name, @timestamp)
				, (@creator_bz_id, 'Bugzilla::FlagType', @flag_budget_id, '__create__', NULL, @flag_budget_name, @timestamp)
				, (@creator_bz_id, 'Bugzilla::FlagType', @flag_attachment_id, '__create__', NULL, @flag_attachment_name, @timestamp)
				, (@creator_bz_id, 'Bugzilla::FlagType', @flag_ok_to_pay_id, '__create__', NULL, @flag_ok_to_pay_name, @timestamp)
				, (@creator_bz_id, 'Bugzilla::FlagType', @flag_is_paid_id, '__create__', NULL, @flag_is_paid_name, @timestamp)
				;
				
		# Cleanup:
			SET @script_log_message = NULL;
			
	# We configure the group permissions:
		# Data for the table `group_group_map`
        # We first insert these in the table `ut_group_group_map_temp`

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

	# We now assign the permissions to each of the dummy user associated to each role:
    #   - Tenant (1)
    #     @bz_user_id_dummy_tenant
    #   - Landlord (2)
    #     @bz_user_id_dummy_landlord
    #   - Contractor (3)
    #     @bz_user_id_dummy_contractor
    #   - Management company (4)
    #     @bz_user_id_dummy_mgt_cny
    #   - Agent (5)
    #     @bz_user_id_dummy_agent
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

			# User can Edit a case and see this unit, this is needed so the API does not throw an error see issue #60:
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

        # We update the `group_group_map` table first
        #   - Create an intermediary table to deduplicate the records in the table `ut_user_group_map_temp`
        #   - If the record does NOT exists in the table then INSERT new records in the table `user_group_map`
        #   - If the record DOES exist in the table then update the new records in the table `user_group_map`

            # We drop the deduplication table if it exists:
                DROP TABLE IF EXISTS `ut_group_group_map_dedup`;

            # We create a table `ut_group_group_map_dedup` to prepare the data we need to insert

                CREATE TABLE `ut_group_group_map_dedup` (
                    `member_id` mediumint(9) NOT NULL,
                    `grantor_id` mediumint(9) NOT NULL,
                    `grant_type` tinyint(4) NOT NULL DEFAULT '0',
                    UNIQUE KEY `ut_group_group_map_dedup_member_id_idx` (`member_id`,`grantor_id`,`grant_type`),
                    KEY `fk_group_group_map_dedup_grantor_id_groups_id` (`grantor_id`),
                    KEY `group_group_map_dedup_grantor_id_grant_type_idx` (`grantor_id`,`grant_type`),
                    KEY `group_group_map_dedup_member_id_grant_type_idx` (`member_id`,`grant_type`),
                    CONSTRAINT `fk_group_group_map_dedup_grantor_id_groups_id` FOREIGN KEY (`grantor_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
                    CONSTRAINT `fk_group_group_map_dedup_member_id_groups_id` FOREIGN KEY (`member_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
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
                ;
                    
            # We insert the data we need in the `group_group_map` table
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
                DROP TABLE IF EXISTS `user_group_map_dedup`;

        # We can now update the permissions table for the users
        # This NEEDS the table 'ut_user_group_map_temp'
            CALL `update_permissions_invited_user`;

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

	# Clean up
		# We Delete the temp table as we do not need it anymore
			DROP TABLE IF EXISTS `ut_temp_dummy_users_for_roles`;
	
END 
$$
DELIMITER ;

# Update the procedure to invite a user to a role in a unit
# This procedure needs the following variables:
#   - mefe_invitation_id
#   - environment

    DROP PROCEDURE IF EXISTS `add_user_to_role_in_unit`;

DELIMITER $$
CREATE PROCEDURE add_user_to_role_in_unit()
SQL SECURITY INVOKER
BEGIN

    # This procedure needs the following variables:
    #   - `mefe_invitation_id`
    #   - `environment`: Which environment are you creating the unit in?
    #   	- 1 is for the DEV/Staging
    #	    - 2 is for the prod environment
    #   	- 3 is for the Demo environment
    #
    #############################################
    #
    # IMPORTANT INFORMATION ABOUT THIS SCRIPT
    #
    #############################################
    #
    # Use this script only if the Unit EXIST in the BZFE 
    # It assumes that the unit has been created with all the necessary BZ objects and all the roles assigned to dummy users.
    #
    # Pre-requisite:
    #	- The table 'ut_invitation_api_data' has been updated 
    # 	- We know the MEFE Invitation id that we need to process.
    #	- We know the environment where this script is run
    # 
    # This script will:
    #	- Create a temp table to store the permissions we are creating
    #	- Reset things for this user for this unit:
    #		- Remove all the permissions for this user for this unit for ALL roles.
    # 	- Remove this user from the list of user in default CC for a case for this role in this unit.
    #	- Get the information needed from the table `ut_invitation_api_data`
    #		- BZ Invitor id
    #		- BZ unit id
    #		- The invited user:
    #			- BZ invited id
    #			- The role in this unit for the invited user
    #			- Is the invited user an occupant of the unit or not.
    #			- Is the user is a MEFE user only:
    #				- IF the user is a MEFE user only 
    #				  Then disable the mail sending functionality from the BZFE.
    #		- The type of invitation for this user
    #			- 'replace_default': Remove and Replace: 
    #				- Grant the permissions to the inviter user for this role for this unit
    #				and 
    #				- Remove the existing default user for this role
    #				and 
    #				- Replace the default user for this role 
    #			- 'default_cc_all': Keep existing assignee, Add invited and make invited default CC
    #				- Grant the permissions to the invited user for this role for this unit
    #				and
    #				- Keep the existing default user as default
    #				and
    #				- Make the invited user an automatic CC to all the new cases for this role for this unit
    #			- 'keep_default' Keep existing and Add invited
    #				- Grant the permissions to the inviter user for this role for this unit
    #				and 
    #				- Keep the existing default user as default
    #				and
    #				- Check if this new user is the first in this role for this unit.
    #					- If it IS the first in this role for this unit.
    #				 	  Then Replace the Default 'dummy user' for this specific role with the BZ user in CC for this role for this unit.
    #					- If it is NOT the first in this role for this unit.
    #					  Do Nothing
    #			- 'remove_user': Remove user from a role in a unit
    #				- Revoke the permissions to the user for this role for this unit
    #				and 
    #				- Check if this user is the default user for this role for this unit.
    #					- If it IS the Default user in this role for this unit.
    #				 	  Then Replace the Default user in this role for this unit with the 'dummy user' for this specific role.
    #					- If it is NOT the Default user in this role for this unit.
    #					  Do Nothing
    #			- Other or no information about the type of invitation
    #				- Grant the permissions to the inviter user for this role for this unit
    #				and
    #				- Check if this new user is the first in this role for this unit.
    #					- If it IS the first in this role for this unit.
    #				 	  Then Replace the Default 'dummy user' for this specific role with the BZ user in CC for this role for this unit.
    #					- If it is NOT the first in this role for this unit.
    #					  Do Nothing
    #	- Process the invitation accordingly.
    #	- Delete an re-create all the entries for the table `user_groups`
    #	- Log the action of the scripts that are run
    #	- Update the invitation once everything has been done
    #	- Exit with either:
    #		- an error message (there was a problem somewhere)
    #		or 
    #		- no error message (succcess)
    #
    # Limits of this script:
    #	- Unit must have all roles created with Dummy user roles.
    #
    #####################################################
    #					
    # First we need to define all the variables we need
    #					
    #####################################################

    # We make sure that all the variable we user are set to NULL first
    # This is to avoid issue of a variable 'silently' using a value from a previous run
        SET @reference_for_update = NULL;
        SET @mefe_invitor_user_id = NULL;
        SET @product_id = NULL;
        SET @creator_bz_id = NULL;
        SET @creator_pub_name = NULL;
        SET @id_role_type = NULL;
        SET @bz_user_id = NULL;
        SET @role_user_g_description = NULL;
        SET @user_pub_name = NULL;
        SET @role_user_pub_info = NULL;
        SET @user_role_desc = NULL;
        SET @role_user_more = NULL;
        SET @user_role_type_description = NULL;
        SET @user_role_type_name = NULL;
        SET @component_id_this_role = NULL;
        SET @current_default_assignee_this_role = NULL;
        SET @bz_user_id_dummy_tenant = NULL;
        SET @bz_user_id_dummy_landlord = NULL;
        SET @bz_user_id_dummy_contractor = NULL;
        SET @bz_user_id_dummy_mgt_cny = NULL;
        SET @bz_user_id_dummy_agent = NULL;
        SET @bz_user_id_dummy_user_this_role = NULL;
        SET @is_occupant = NULL;
        SET @invitation_type = NULL;
        SET @is_mefe_only_user = NULL;
        SET @user_in_default_cc_for_cases = NULL;
        SET @replace_default_assignee = NULL;
        SET @remove_user_from_role = NULL;
        SET @can_see_time_tracking = NULL;
        SET @can_create_shared_queries = NULL;
        SET @can_tag_comment = NULL;
        SET @can_create_new_cases = NULL;
        SET @can_edit_a_case = NULL;
        SET @can_see_all_public_cases = NULL;
        SET @can_edit_all_field_in_a_case_regardless_of_role = NULL;
        SET @can_see_unit_in_search = NULL;
        SET @user_is_publicly_visible = NULL;
        SET @user_can_see_publicly_visible = NULL;
        SET @can_ask_to_approve_flags = NULL;
        SET @can_approve_all_flags = NULL;
        SET @is_current_assignee_this_role_a_dummy_user = NULL;
        SET @this_script = NULL;

    # Default values:
        
        #User Permissions in the unit:
            SET @can_see_time_tracking = 1;
            SET @can_create_shared_queries = 0;
            SET @can_tag_comment = 1;
            SET @can_create_new_cases = 1;
            SET @can_edit_a_case = 1;
            SET @can_see_all_public_cases = 1;
            SET @can_edit_all_field_in_a_case_regardless_of_role = 1;
            SET @can_see_unit_in_search = 1;
            SET @user_is_publicly_visible = 1;
            SET @user_can_see_publicly_visible = 1;
            SET @can_ask_to_approve_flags = 1;
            SET @can_approve_all_flags = 1;
        
        # Do we need to make the invitee a default CC for all new cases for this role in this unit?
            SET @user_in_default_cc_for_cases = 0;

    # Timestamp	
        SET @timestamp = NOW();

    # We define the name of this script for future reference:
        SET @this_script = 'PROCEDURE add_user_to_role_in_unit';
        
    # We create a temporary table to record the ids of the dummy users in each environments:
        CALL `table_to_list_dummy_user_by_environment`;
        
    # The reference of the record we want to update in the table `ut_invitation_api_data`
        SET @reference_for_update = (SELECT `id` FROM `ut_invitation_api_data` WHERE `mefe_invitation_id` = @mefe_invitation_id);	

    # The MEFE information:
        SET @mefe_invitor_user_id = (SELECT `mefe_invitor_user_id` FROM `ut_invitation_api_data` WHERE `id` = @reference_for_update);

    # The unit name and description
        SET @product_id = (SELECT `bz_unit_id` FROM `ut_invitation_api_data` WHERE `id` = @reference_for_update);

    # The Invitor - BZ user id of the user that has genereated the invitation.
        SET @creator_bz_id = (SELECT `bzfe_invitor_user_id` FROM `ut_invitation_api_data` WHERE `id` = @reference_for_update);

        # We populate the additional variables that we will need for this script to work:
            SET @creator_pub_name = (SELECT `realname` FROM `profiles` WHERE `userid` = @creator_bz_id);

    # Role in this unit for the invited user:
        #	- Tenant 1
        # 	- Landlord 2
        #	- Agent 5
        #	- Contractor 3
        #	- Management company 4
        SET @id_role_type = (SELECT `user_role_type_id` FROM `ut_invitation_api_data` WHERE `id` = @reference_for_update);
            
    # The user who you want to associate to this unit - BZ user id of the user that you want to associate/invite to the unit.
        SET @bz_user_id = (SELECT `bz_user_id` FROM `ut_invitation_api_data` WHERE `id` = @reference_for_update);

        # We populate the additional variables that we will need for this script to work:
            SET @role_user_g_description = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=@id_role_type);
            SET @user_pub_name = (SELECT (LEFT(`login_name`,INSTR(`login_name`,"@")-1)) FROM `profiles` WHERE `userid` = @bz_user_id);
            SET @role_user_more = (SELECT `user_more` FROM `ut_invitation_api_data` WHERE `id` = @reference_for_update);		
            SET @role_user_pub_info = CONCAT(@user_pub_name
                                    , IF (@role_user_more = '', '', ' - ')
                                    , IF (@role_user_more = '', '', @role_user_more)
                                    )
                                    ;
            SET @user_role_desc = (CONCAT(@role_user_g_description, ' - ',@role_user_pub_info));
        
        SET @user_role_type_description = (SELECT `bz_description` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type);
        SET @user_role_type_name = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type);
        
        # We need to get the component_id for this role for this product/unit
        # We get that from the ut_product_group table.
            SET @component_id_this_role = (SELECT `component_id` 
                                        FROM `ut_product_group` 
                                        WHERE `product_id` = @product_id 
                                            AND `role_type_id` = @id_role_type
                                            AND `group_type_id` = 2)
                                            ;
                    
        # Is the current assignee for this role for this unit one of the dummy user in this environment?

            # What is the CURRENT default assignee for the role this user has been invited to?
                SET @current_default_assignee_this_role = (SELECT `initialowner` FROM `components` WHERE `id` = @component_id_this_role);

            # What is the default dummy user id for this environment?
            
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

            # What is the BZ dummy user id for this role in this script?
                SET @bz_user_id_dummy_user_this_role = IF( @id_role_type = 1
                                                , @bz_user_id_dummy_tenant
                                                , IF (@id_role_type = 2
                                                    , @bz_user_id_dummy_landlord
                                                    , IF (@id_role_type = 3
                                                        , @bz_user_id_dummy_contractor
                                                        , IF (@id_role_type = 4
                                                            , @bz_user_id_dummy_mgt_cny
                                                            , IF (@id_role_type = 5
                                                                , @bz_user_id_dummy_agent
                                                                , 'Something is very wrong!!'
                                                                )
                                                            )
                                                        )
                                                    )
                                                )
                                                ;

    # Is the invited user an occupant of the unit?
        SET @is_occupant = (SELECT `is_occupant` FROM `ut_invitation_api_data` WHERE `id` = @reference_for_update);
        
    # What type of invitation is this?
        SET @invitation_type = (SELECT `invitation_type` FROM `ut_invitation_api_data` WHERE `id` = @reference_for_update);
        
    # Do we need to disable the BZ email notification for this user?
        SET @is_mefe_only_user = (SELECT `is_mefe_only_user` 
                                FROM `ut_invitation_api_data` 
                                WHERE `id` = @reference_for_update)
                                ;
                                
    # User permissions:
        # These will depend on :
        #	- The invitation type
        #	- The default values currently configured
        # We NEED to have defined the variable @invitation_type FIRST!

        # Things which depends on the invitation type:
        
            # Do we need to make the invitee a default CC for all new cases for this role in this unit?
            # This depends on the type of invitation that we are creating
            #	- 1 (YES) if the invitation type is
            #		- 'default_cc_all'
            #	- 0 (NO) if the invitation type is any other invitation type
            #
                    SET @user_in_default_cc_for_cases = IF (@invitation_type = 'default_cc_all'
                        , '1'
                        , '0'
                        )
                        ;

            # Do we need to replace the default assignee for this role in this unit?
            # This depends on the type of invitation that we are creating
            #	- 1 (YES) if the invitation type is
            #		- 'replace_default'
            #	- 0 (NO) if the invitation type is any other invitation type
            #
                    SET @replace_default_assignee = IF (@invitation_type = 'replace_default'
                        , '1'
                        , '0'
                        )
                        ;
                        
            # Do we need to revoke the permission for this user for this unit?
            # This depends on the type of invitation that we are creating
            #	- 1 (YES) if the invitation type is
            #		- 'remove_user'
            #	- 0 (NO) if the invitation type is any other invitation type
            #
                    SET @remove_user_from_role = IF (@invitation_type = 'remove_user'
                        , '1'
                        , '0'
                        )
                        ;
        
        # Default permissions:	
            #User Permissions in the unit:
                # Generic Permissions
                    SET @can_see_time_tracking = 1;
                    SET @can_create_shared_queries = 0;
                    SET @can_tag_comment = 1;
                # Product/Unit specific permissions
                    SET @can_create_new_cases = 1;
                    SET @can_edit_a_case = 1;
                    SET @can_see_all_public_cases = 1;
                    SET @can_edit_all_field_in_a_case_regardless_of_role = 1;
                    SET @can_see_unit_in_search = 1;
                    SET @user_is_publicly_visible = 1;
                    SET @user_can_see_publicly_visible = 1;
                    SET @can_ask_to_approve_flags = 1;
                    SET @can_approve_all_flags = 1;
                # Role/Component specific permissions
                    # These are defined based on the invited user attributes:
                    # 	- role_type_id 
                    # 	- is_occupant

    # Answer to the question "Is the current default assignee for this role one of the dummy users?"
        SET @is_current_assignee_this_role_a_dummy_user = IF( @replace_default_assignee = '1'
            , '0'
            , IF(@current_default_assignee_this_role = @bz_user_id_dummy_user_this_role
                , '1'
                , '0'
                )
            )
            ;
                                    
    #################################################################
    #
    # All the variables have been set - we can call the procedures
    #
    #################################################################
        
    # RESET: We remove the user from the list of user in default CC for this role
    # This procedure needs the following objects:
    #	- variables:
    #		- @bz_user_id : 
    #		  the BZ user id of the user
    #		- @component_id_this_role: 
    #		  The id of the role in the bz table `components`
        CALL `remove_user_from_default_cc`;

    # We are recording this for KPI measurements
    #	- Number of user per role per unit.

        # We record the information about the users that we have just created
        # If this is the first time we record something for this user for this unit, we create a new record.
        # If there is already a record for THAT USER for THIS, then we are updating the information
            
            INSERT INTO `ut_map_user_unit_details`
                (`created`
                , `record_created_by`
                , `user_id`
                , `bz_profile_id`
                , `bz_unit_id`
                , `role_type_id`
                , `can_see_time_tracking`
                , `can_create_shared_queries`
                , `can_tag_comment`
                , `is_occupant`
                , `is_public_assignee`
                , `is_see_visible_assignee`
                , `is_in_cc_for_role`
                , `can_create_case`
                , `can_edit_case`
                , `can_see_case`
                , `can_edit_all_field_regardless_of_role`
                , `is_flag_requestee`
                , `is_flag_approver`
                , `can_create_any_sh`
                , `can_create_same_sh`
                , `can_approve_user_for_flags`
                , `can_decide_if_user_visible`
                , `can_decide_if_user_can_see_visible`
                , `public_name`
                , `more_info`
                , `comment`
                )
                VALUES
                (@timestamp
                , @creator_bz_id
                , @bz_user_id
                , @bz_user_id
                , @product_id
                , @id_role_type
                # Global permission for the whole installation
                , @can_see_time_tracking
                , @can_create_shared_queries
                , @can_tag_comment
                # Attributes of the user
                , @is_occupant
                # User visibility
                , @user_is_publicly_visible
                , @user_can_see_publicly_visible
                # Permissions for cases for this unit.
                , @user_in_default_cc_for_cases
                , @can_create_new_cases
                , @can_edit_a_case
                , @can_see_all_public_cases
                , @can_edit_all_field_in_a_case_regardless_of_role
                # For the flags
                , @can_ask_to_approve_flags
                , @can_approve_all_flags
                # Permissions to create or modify other users
                , 0
                , 0
                , 0
                , 0
                , 0
                , @user_pub_name
                , @role_user_more
                , CONCAT('On '
                        , @timestamp
                        , ': Created with the script - '
                        , @this_script
                        , '.\r\ '
                        , `comment`)
                )
                ON DUPLICATE KEY UPDATE
                `created` = @timestamp
                , `record_created_by` = @creator_bz_id
                , `role_type_id` = @id_role_type
                # Global permission for the whole installation
                , `can_see_time_tracking` = @can_see_time_tracking
                , `can_create_shared_queries` = @can_create_shared_queries
                , `can_tag_comment` = @can_tag_comment
                # Attributes of the user
                , `is_occupant` = @is_occupant
                # User visibility
                , `is_public_assignee` = @user_is_publicly_visible
                , `is_see_visible_assignee` = @user_can_see_publicly_visible
                # Permissions for cases for this unit.
                , `is_in_cc_for_role` = @user_in_default_cc_for_cases
                , `can_create_case` = @can_create_new_cases
                , `can_edit_case` = @can_edit_a_case
                , `can_see_case` = @can_see_all_public_cases
                , `can_edit_all_field_regardless_of_role` = @can_edit_all_field_in_a_case_regardless_of_role
                # For the flags
                , `is_flag_requestee` = @can_ask_to_approve_flags
                , `is_flag_approver` = @can_approve_all_flags
                # Permissions to create or modify other users
                , `can_create_any_sh` = 0
                , `can_create_same_sh` = 0
                , `can_approve_user_for_flags` = 0
                , `can_decide_if_user_visible` = 0
                , `can_decide_if_user_can_see_visible` = 0
                , `public_name` = @user_pub_name
                , `more_info` = CONCAT('On: '
                    , @timestamp
                    , '.\r\Updated to '
                    , @role_user_more
                    , '. \r\ '
                    , `more_info`
                    )
                , `comment` = CONCAT('On '
                    , @timestamp
                    , '.\r\Updated with the script - '
                    , @this_script
                    , '.\r\ '
                    , `comment`)
            ;

    # We always reset the permissions to the default permissions first
        # Revoke all permissions for this user in this unit
            # This procedure needs the following objects:
            #	- Variables:
            #		- @product_id
            #		- @bz_user_id
            CALL `revoke_all_permission_for_this_user_in_this_unit`;
            
        # Prepare the permissions - configure these to default:
            # Generic Permissions
                # These need the following objects:
                #	- table 'ut_user_group_map_temp'
                #	- Variables:
                #		- @bz_user_id
                    CALL `can_see_time_tracking`;
                    CALL `can_create_shared_queries`;
                    CALL `can_tag_comment`;
            # Product/Unit specific permissions
                # These need the following objects:
                #	- table 'ut_user_group_map_temp'
                #	- Variables:
                #		- @bz_user_id
                #		- @product_id
                    CALL `can_create_new_cases`;
                    CALL `can_edit_a_case`;
                    CALL `can_see_all_public_cases`;
                    CALL `can_edit_all_field_in_a_case_regardless_of_role`;
                    CALL `can_see_unit_in_search`;
                    
                    CALL `user_is_publicly_visible`;
                    CALL `user_can_see_publicly_visible`;
                    
                    CALL `can_ask_to_approve_flags`;
                    CALL `can_approve_all_flags`;
            # Role/Component specific permissions
                # These need the following objects:
                #	- table 'ut_user_group_map_temp'
                #	- Variables:
                #		- @id_role_type
                #		- @bz_user_id
                #		- @product_id
                #		- @is_occupant
                    CALL `show_to_tenant`;
                    CALL `is_tenant`;
                    CALL `default_tenant_can_see_tenant`;
                    
                    CALL `show_to_landlord`;
                    CALL `are_users_landlord`;
                    CALL `default_landlord_see_users_landlord`;
                    
                    CALL `show_to_contractor`;
                    CALL `are_users_contractor`;
                    CALL `default_contractor_see_users_contractor`;
                    
                    CALL `show_to_mgt_cny`;
                    CALL `are_users_mgt_cny`;
                    CALL `default_mgt_cny_see_users_mgt_cny`;
                    
                    CALL `show_to_agent`;
                    CALL `are_users_agent`;
                    CALL `default_agent_see_users_agent`;
                    
                    CALL `show_to_occupant`;
                    CALL `is_occupant`;
                    CALL `default_occupant_can_see_occupant`;
            
        # All the permission have been prepared, we can now update the permissions table
        #		- This NEEDS the table 'ut_user_group_map_temp'
            CALL `update_permissions_invited_user`;
        
    # Disable the BZ email notification engine if needed
    # This procedure needs the following objects:
    #	- variables:
    #		- @is_mefe_only_user
    #		- @creator_bz_id
    #		- @bz_user_id
        CALL `disable_bugmail`;
        
    # Replace the default dummy user for this role if needed
    # This procedure needs the following objects:
    #	- variables:
    #		- @is_current_assignee_this_role_a_dummy_user
    #		- @component_id_this_role
    #		- @bz_user_id
    #		- @user_role_desc
    #		- @id_role_type
    #		- @user_pub_name
    #		- @product_id
    #		- @creator_bz_id
    #		- @mefe_invitation_id
    #		- @mefe_invitor_user_id
    #		- @is_occupant
    #		- @is_mefe_only_user
    #		- @role_user_more
        CALL `update_assignee_if_dummy_user`;

    # Make the invited user default CC for all cases in this unit if needed
    # This procedure needs the following objects:
    #	- variables:
    #		- @user_in_default_cc_for_cases
    #		- @bz_user_id
    #		- @product_id
    #		- @component_id
    #		- @role_user_g_description
        # Make sure the variable we need is correctly defined
            SET @component_id = @component_id_this_role;
        
        # Run the procedure
            CALL `user_in_default_cc_for_cases`;	

    # Make the invited user the new default assignee for all cases in this role in this unit if needed
    # This procedure needs the following objects:
    #	- variables:
    #		- @replace_default_assignee
    #		- @bz_user_id
    #		- @product_id
    #		- @component_id
    #		- @role_user_g_description
        # Make sure the variable we need is correctly defined
            SET @component_id = @component_id_this_role;
        
        # Run the procedure
            CALL `user_is_default_assignee_for_cases`;

    # Remove this user from this role in this unit if needed:
    # This procedure needs the following objects
    #	- Variables:
    #		- @remove_user_from_role
    #		- @component_id_this_role
    #		- @product_id
    #		- @bz_user_id
    #		- @bz_user_id_dummy_user_this_role
    #		- @id_role_type
    #		- @user_role_desc
    #		- @user_pub_name
    #		- @creator_bz_id
        CALL `remove_user_from_role`;

    # Update the table 'ut_invitation_api_data' so we record what we have done

        # Timestamp	
            SET @timestamp = NOW();
            
        # We do the update to record that we have reached the end of the script...
            UPDATE `ut_invitation_api_data`
                SET `processed_datetime` = @timestamp
                    , `script` = @this_script
                WHERE `mefe_invitation_id` = @mefe_invitation_id
                ;
                
    #Clean up
            
        # We Delete the temp table as we do not need it anymore
            DROP TABLE IF EXISTS `ut_temp_dummy_users_for_roles`;

END
$$
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