# For any question about this script, ask Franck
#
# This update facilitate the automated creation of a unit in Unee-T
# It creates several procedures which we can call when there is a need to create a unit.
#
############################################
#
# Make sure to update the below variable(s)
#
############################################
#
# What are the version of the Unee-T BZ Database schema BEFORE and AFTER this update?
	SET @old_schema_version = 'v3.1';
	SET @new_schema_version = 'v3.2';
	SET @this_script = 'upgrade_unee-t_v3.1_to_v3.2.sql';
#
###############################
#
# We have everything we need
#
###############################
#
#
###################################################################################
#
# WARNING! It is recommended to use Amazon Aurora database engine for this version
#
###################################################################################

# We alter the table `ut_db_schema_version` to record information on the script which was used to to the update

	ALTER TABLE `ut_db_schema_version` 
		ADD COLUMN `update_script` varchar(256)  COLLATE utf8_general_ci NULL COMMENT 'The script which was used to do the db ugrade' after `update_datetime` , 
		CHANGE `comment` `comment` text  COLLATE utf8_general_ci NULL COMMENT 'Comment' after `update_script` 
		;

# We create a table to record the information each time a new user/profile is created



# We create a table to record the information each time a new geography/Classification is created



# We create a table to record the information each tima a new unit/Product is created



# We create a table to record the information each time a new component is created???



# We make sure that for each unit we want to create:
#	- The invitor exists
#	- The invitee exists
#	- The Geography/category exists


























	  
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