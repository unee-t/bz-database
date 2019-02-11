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
	SET @old_schema_version = 'v3.30';
	SET @new_schema_version = 'v3.31';
#
# What is the name of this script?
	SET @this_script = 'upgrade_unee-t_v3.30_to_v3.31.sql';
#
###############################
#
# We have everything we need
#
###############################
# This update
#
#   - Speeds up the SQL routine to 
#       - User permissions: `user_in_default_cc_for_cases`
#       Before the change: we copy all the records from the tables
#           - `component_cc` to `ut_temp_component_cc`
#       After the change:
#           We do not copy these records anymore, we just add the records that need to be created or updated.
#
#   - Move the audit log function outside the scripts in dedicated trigger when we
#       - INSERT records in the tables
#WIP       - `series_categories`
#WIP       - `series`
#
#       - DELETE records in the tables
#WIP       - `series_categories`
#WIP       - `series`
#
#       - UPDATE records in the tables
#WIP       - `series_categories`
#WIP       - `series`
#
#WIP   - Update the procedure `default_contractor_see_users_contractor`
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure `default_agent_see_users_agent`
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure `are_users_agent`
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure `show_to_agent`
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure `are_users_contractor`
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure `show_to_contractor`
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure `default_landlord_see_users_landlord`
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure `are_users_landlord`
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure `show_to_landlord`
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure `default_mgt_cny_see_users_mgt_cny`
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure `are_users_mgt_cny`
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure `show_to_mgt_cny`
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure `default_tenant_see_users_tenant`
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure `are_users_tenant`
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure `show_to_tenant`
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure ``
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure ``
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure ``
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure ``
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure ``
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure ``
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure ``
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure ``
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure ``
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#

#####################
#
# Do it!
#
#####################

# When are we doing this?
	SET @the_timestamp = NOW();





        # Update the table `ut_audit_log`
            # We capture the new values of each fields in dedicated variables:
                SET @new_ = @;
                SET @new_ = @;

            # We set the variable we need to update the log with relevant information:
                SET @bzfe_table = '??';
                SET @bzfe_field = 'user_id, component_id';
                SET @previous_value = NULL;
                SET @new_value = CONCAT (
                        @new_
                        , ', '
                        , @new_
                    )
                ;
                
                # The @script variable is defined by the highest level script we have - we do NOT change that
                    SET @comment = CONCAT ('called via '
                        , @script
                        ;

            # We have all the variables:
                #   - @bzfe_table: the table that was updated
                #   - @bzfe_field: The fields that were updated
                #   - @previous_value: The previouso value for the field
                #   - @new_value: the values captured by the trigger when the new value is inserted.
                #   - @script: the script that is calling this procedure
                #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

                CALL `update_audit_log`;



        # Update the table `ut_audit_log`
            # We capture the new values of each fields in dedicated variables:
                SET @new_ = @;
                SET @new_ = @;

            # We set the variable we need to update the log with relevant information:
                SET @bzfe_table = '??';
                SET @bzfe_field = 'user_id, component_id';
                SET @previous_value = NULL;
                SET @new_value = CONCAT (
                        @new_
                        , ', '
                        , @new_
                    )
                ;
                
                # The @script variable is defined by the highest level script we have - we do NOT change that
                    SET @comment = CONCAT ('called via '
                        , @script
                        ;

            # We have all the variables:
                #   - @bzfe_table: the table that was updated
                #   - @bzfe_field: The fields that were updated
                #   - @previous_value: The previouso value for the field
                #   - @new_value: the values captured by the trigger when the new value is inserted.
                #   - @script: the script that is calling this procedure
                #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

                CALL `update_audit_log`;









# Update the procedure `user_in_default_cc_for_cases`
#       - Do not copy the records from the table `component_cc` to the table `ut_temp_component_cc`
#       - Write in the table `ut_audit_log` when something happens on the temporary table

    DROP PROCEDURE IF EXISTS `user_in_default_cc_for_cases`;

DELIMITER $$
CREATE PROCEDURE `user_in_default_cc_for_cases`()
BEGIN
	IF (@user_in_default_cc_for_cases = 1)
	THEN 

		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - user_in_default_cc_for_cases';
			SET @timestamp = NOW();

		# We use a temporary table to make sure we do not have duplicates.
		
		# DELETE the temp table if it exists
	    	DROP TEMPORARY TABLE IF EXISTS `ut_temp_component_cc`;
		
		# Re-create the temp table
            CREATE TEMPORARY TABLE `ut_temp_component_cc` (
                `user_id` MEDIUMINT(9) NOT NULL
                , `component_id` MEDIUMINT(9) NOT NULL
                )
                ;

		# Add the new user rights for the product
			INSERT INTO `ut_temp_component_cc`
				(user_id
				, component_id
				)
				VALUES
				(@bz_user_id, @component_id)
				;

        # Update the table `ut_audit_log`
            # We capture the new values of each fields in dedicated variables:
                SET @new_bz_user_id = @bz_user_id;
                SET @new_component_id = @component_id;

            # We set the variable we need to update the log with relevant information:
                SET @bzfe_table = 'ut_temp_component_cc';
                SET @bzfe_field = 'user_id, component_id';
                SET @previous_value = NULL;
                SET @new_value = CONCAT (
                        @new_bz_user_id
                        , ', '
                        , @new_component_id
                    )
                ;
                
                # The @script variable is defined by the highest level script we have - we do NOT change that
                    SET @comment = CONCAT ('called via '
                        , @script
                        ;

            # We have all the variables:
                #   - @bzfe_table: the table that was updated
                #   - @bzfe_field: The fields that were updated
                #   - @previous_value: The previouso value for the field
                #   - @new_value: the values captured by the trigger when the new value is inserted.
                #   - @script: the script that is calling this procedure
                #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

                CALL `update_audit_log`;

        # We drop the deduplication table if it exists:
            DROP TEMPORARY TABLE IF EXISTS `ut_temp_component_cc_dedup`;

        # We create a table `ut_user_group_map_dedup` to prepare the data we need to insert
            CREATE TEMPORARY TABLE `ut_temp_component_cc_dedup` (
                `user_id` MEDIUMINT(9) NOT NULL
                , `component_id` MEDIUMINT(9) NOT NULL
                , UNIQUE KEY `ut_temp_component_cc_dedup_userid_componentid` (`user_id`, `component_id`)
                )
            ;
            
        # We insert the de-duplicated record in the table `ut_temp_component_cc_dedup`
            INSERT INTO `ut_temp_component_cc_dedup`
            SELECT `user_id`
                , `component_id`
            FROM
                `ut_temp_component_cc`
            GROUP BY `user_id`
                , `component_id`
            ;

		# We insert the new records in the table `component_cc` if the record does not exist. If the record exists alredy we update it.
			INSERT INTO `component_cc`
			SELECT `user_id`
				, `component_id`
			FROM
				`ut_temp_component_cc_dedup`
			GROUP BY `user_id`
				, `component_id`
            ON DUPLICATE KEY UPDATE
                `user_id` = `ut_temp_component_cc_dedup`.`user_id`
				, `component_id` = `ut_temp_component_cc_dedup`.`component_id`
			;

        # Clean up:
            # We drop the deduplication table if it exists:
                DROP TEMPORARY TABLE IF EXISTS `ut_temp_component_cc_dedup`;
            
            # We Delete the temp table as we do not need it anymore
                DROP TEMPORARY TABLE IF EXISTS `ut_temp_component_cc`;
		
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' is one of the copied assignee for the unit #'
									, @product_id
									, ' when the role '
									, @role_user_g_description
									, ' (the component #'
									, @component_id
									, ')'
									, ' is chosen'
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
				SET @script = NULL;
    END IF ;
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