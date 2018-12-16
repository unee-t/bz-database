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
	SET @old_schema_version = 'v3.29';
	SET @new_schema_version = 'v3.30';
#
# What is the name of this script?
	SET @this_script = 'upgrade_unee-t_v3.29_to_v3.30.sql';
#
###############################
#
# We have everything we need
#
###############################
# This update
#
#   - Tries to speed up the SQL routine to 
#       - Invite a user to a unit
#       - Create a new unit
#       Before the change: we copy all the records from the tables
#           - `group_group_map` to `group_group_map_temp`
#           - `user_group_map` to `ut_user_group_map_temp`
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

# Update the procedure to create a temp table to assign user permissions
# No need to not copy the records from the table `user_group_map` into the table `ut_user_group_map_temp`.

    DROP PROCEDURE IF EXISTS `create_temp_table_to_update_permissions`;

DELIMITER $$
CREATE PROCEDURE `create_temp_table_to_update_permissions`()
SQL SECURITY INVOKER
BEGIN
    # We use a temporary table to make sure we do not have duplicates.
		
		# DELETE the temp table if it exists
		DROP TEMPORARY TABLE IF EXISTS `ut_user_group_map_temp`;
		
		# Re-create the temp table
		CREATE TEMPORARY TABLE `ut_user_group_map_temp` (
		  `user_id` MEDIUMINT(9) NOT NULL
		  , `group_id` MEDIUMINT(9) NOT NULL
		  , `isbless` TINYINT(4) NOT NULL DEFAULT 0
          , `grant_type` TINYINT(4) NOT NULL DEFAULT 0
		)
        ;

END
$$
DELIMITER ;

# Update the procedure to create a temp table to assign group permissions
# No need to not copy the records from the table `group_group_map` into the table `ut_group_group_map_temp`.

    DROP PROCEDURE IF EXISTS `create_temp_table_to_update_group_permissions`;

DELIMITER $$
CREATE PROCEDURE `create_temp_table_to_update_group_permissions`()
SQL SECURITY INVOKER
BEGIN

	# DELETE the temp table if it exists
	    DROP TEMPORARY TABLE IF EXISTS `ut_group_group_map_temp`;

	# Re-create the temp table
        CREATE TEMPORARY TABLE `ut_group_group_map_temp` (
        `member_id` MEDIUMINT(9) NOT NULL
        , `grantor_id` MEDIUMINT(9) NOT NULL
        , `grant_type` TINYINT(4) NOT NULL DEFAULT 0
        )
        ;

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