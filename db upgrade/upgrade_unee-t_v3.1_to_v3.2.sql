# For any question about this script, ask Franck
#
# This update 
#	- makes sure we record the script that was used to do the database upgrade
#	- fix a bug in the procedure 'disable_bugmail'
#	- fix a typo in the procedure 'default_landlord_see_users_landlord'
#	- facilitate the automated creation of a unit in Unee-T
# 		- It creates several procedures which we can call when there is a need to create a unit.
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

# fix a bug in the procedure 'disable_bugmail'
# This procedure is using the incorrect fielddef_id (33) and make it look like we created a record for the same user several times...

DROP PROCEDURE IF EXISTS disable_bugmail;
DELIMITER $$
CREATE PROCEDURE disable_bugmail()
SQL SECURITY INVOKER
BEGIN
	IF (@is_mefe_only_user = 1)
	THEN UPDATE `profiles`
		SET 
			`disable_mail` = 1
		WHERE `userid` = @bz_user_id
		;

		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - disable_bugmail';
			SET @timestamp = NOW();

		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' will NOT receive bugmail'
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
			
			SET @bzfe_table = 'profiles';
			SET @permission_granted = ' will NOT receive bugmail.';

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
				 (@timestamp ,@bzfe_table, 'disable_mail', 'UNKNOWN', 1, @script, CONCAT('This BZ user id #', @bz_user_id, @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
	
		# Add this information to the BZ `audit_log` table
			INSERT INTO `audit_log`
				(`userid`
				, `class`
				, `object_id`
				, `field`
				, `removed`
				, `added`
				, `at_time`
				)
				VALUES
				(@creator_bz_id
				, 'Bugzilla::User'
				, @bz_user_id
				, 'disable_mail'
				, '1'
				, '0'
				, @timestamp
				)
				;

		# Log the actions of the script.
			SET @script_log_message = CONCAT('Update profile activity for user #'
									, @bz_user_id
									);
				
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;

# Fix a typo in the log message for one of the procedures:

		# User can see all the Landlords in the unit:
DROP PROCEDURE IF EXISTS default_landlord_see_users_landlord;
DELIMITER $$
CREATE PROCEDURE default_landlord_see_users_landlord()
SQL SECURITY INVOKER
BEGIN
	IF (@id_role_type = 2)
	THEN 
		# Get the information about the group which grant this permission
			SET @group_id_see_users_landlord = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 37 
					AND `role_type_id` = 2)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_see_users_landlord, 0, 0)
				;

		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - default_landlord_see_users_landlord';
			SET @timestamp = NOW();
	
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' can see landlord in the unit '
									, @product_id
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
			
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'can see landlord in the unit.';

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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_see_users_landlord, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;


# We create a table to record the information each time a new geography/Classification is created



# We create a table to record the information each tima a new unit/Product is created



# We create a table to record the information each time a new component is created???



# We make sure that for each unit we want to create:
#	- The invitor exists
#	- The invitee exists
#	- The Geography/category exists



# When we create a unit, we need to record that the unit has been created in the `audit_log` table

# The variables we need:
#	- @creator_bz_id
#	- @product_id
#	- @unit_name

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
	, NULL()
	, @unit_name
	, @timestamp
	)
	;



























	  
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