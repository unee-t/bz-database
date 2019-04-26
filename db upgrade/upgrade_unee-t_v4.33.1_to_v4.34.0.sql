####################################################################################
#
# We MUST use at least Aurora MySQl 5.7.22+ if you want 
# to be able to use the Lambda function Unee-T depends on to work as intended
#
# Alternativey if you do NOT need to use the Lambda function, it is possible to use
#   - MySQL 5.7.22 +
#   - MariaDb 10.2.3 +
#
####################################################################################
#
# For any question about this script, ask Franck
#
###################################################################################
#
# Make sure to also update the below variable(s)
#
###################################################################################
#
# What are the version of the Unee-T BZ Database schema BEFORE and AFTER this update?
	SET @old_schema_version = 'v4.33.1';
	SET @new_schema_version = 'v4.34.0';
#
# What is the name of this script?
	SET @this_script = CONCAT ('upgrade_unee-t_', @old_schema_version, '_to_', @new_schema_version, '.sql');
#
###############################
#
# We have everything we need
#
###############################
# In this update
#
# We fix the collation issues we have:
#	- Default for the database should be `utf8_mb4` and `utf8_mb4_unicode_520_ci`
#
#####################
#
# Do it!
#
#####################

# When are we doing this?
	SET @the_timestamp = NOW();

# Make sure we use the correct default in the database.

	ALTER DATABASE `bugzilla` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;

# Re-create the Views (needed so that we use the correct default collation and character sets)















# We temporarily disable the auto counter for active units:

# Un-comment the below code to re-enable the trigger

/*
#DELIMITER $$
#CREATE TRIGGER `update_the_log_of_enabled_units_when_unit_is_created`
#    AFTER INSERT ON `products`
#    FOR EACH ROW
#  BEGIN
#    CALL `update_log_count_enabled_units`;
#END;
#$$
#DELIMITER ;
*/

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