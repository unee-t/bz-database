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
	SET @old_schema_version = 'v3.28';
	SET @new_schema_version = 'v3.29';
#
# What is the name of this script?
	SET @this_script = 'upgrade_unee-t_v3.28_to_v3.29.sql';
#
###############################
#
# We have everything we need
#
###############################
# This update
#
#   - Adds an index to the table `ut_product_group` to improve performance when we invite a user to a unit
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

# Adds an index to the table `ut_product_group` to improve performance when we invite a user to a unit
    ALTER TABLE `ut_product_group` 
        ADD KEY `ut_product_group_product_id_group_id`(`product_id`,`group_id`) ;

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