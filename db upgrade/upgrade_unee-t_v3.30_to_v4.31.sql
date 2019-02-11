####################################################################################
#
#
# This is a MAJOR upgrade. We MUST use at least Aurora MySQl 5.7+ if you want 
# to be able to use the Lambda function Unee-T depends on to work as intended
#
# Alternativey if you do NOT need to use the Lambda function, it is possible to use
#   - MySQL 5.7 +
#   - MariaDb 10.2+
#
#
####################################################################################

# For any question about this script, ask Franck
#
###################################################################################
#
# Make sure to also update the below variable(s)
#
###################################################################################
#
# What are the version of the Unee-T BZ Database schema BEFORE and AFTER this update?
	SET @old_schema_version = 'v3.30';
	SET @new_schema_version = 'v4.31';
#
# What is the name of this script?
	SET @this_script = 'upgrade_unee-t_v3.30_to_v4.31.sql';
#
###############################
#
# We have everything we need
#
###############################
# This update
#
# Alter the database, database table and All the fields in the database so we can 
# be fully  compatible with the utf8 norm
#
# Step 1: convert rows to dynamic
# The SQL query looks like:
# ALTER TABLE `table_name` ROW_FORMAT=DYNAMIC;
#
# Step 2: convert all to utf8mb4 and utf8mb4_unicode_ci
# The SQL query looks like:
# ALTER TABLE `table_name` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
#
# These queries are built with the following SQL:
# Step 1:
# SELECT CONCAT("ALTER TABLE `"
#	, TABLE_SCHEMA
#	, '`.`'
#	, TABLE_NAME
#	,"` ROW_FORMAT=DYNAMIC;") AS `the_sql_to_run`
# FROM INFORMATION_SCHEMA.TABLES
# WHERE TABLE_SCHEMA="my_database"
# AND TABLE_TYPE="BASE TABLE";
#
# Step 2:
# SELECT CONCAT("ALTER TABLE `"
#	, TABLE_SCHEMA
#	, '`.`'
#	, TABLE_NAME
#	,"` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode520_ci;") AS `the_sql_to_run`
# FROM INFORMATION_SCHEMA.TABLES
# WHERE TABLE_SCHEMA="my_database"
# AND TABLE_TYPE="BASE TABLE";
#

#####################
#
# Do it!
#
#####################

# When are we doing this?
	SET @the_timestamp = NOW();














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