# For any question about this script, ask Franck
#
###################################################################################
#
# WARNING! It is recommended to use Amazon Aurora database engine for this version
#
#	- for the DEV/Staging environment, make sure to run the script `db_v3.6+_adjustments_for_DEV_environment.sql` AFTER this one
#	  This is needed to make sure the values for the dummy user (bz user id)  are correct for the DEV/Staging envo
#
###################################################################################
#
############################################
#
# Make sure to update the below variable(s)
#
############################################
#
# What are the version of the Unee-T BZ Database schema BEFORE and AFTER this update?
	SET @old_schema_version = 'v3.8';
	SET @new_schema_version = 'v3.9';
#
# What is the name of this script?
	SET @this_script = 'upgrade_unee-t_v3.8_to_v3.9.sql';
#
###############################
#
# We have everything we need
#
###############################
# This update 
#	- Create the procedure `user_is_default_assignee_for_cases` so we can invite a user to a role in a unit.
#

# When are we doing this?
	SET @the_timestamp = NOW();

# Create a procedure `user_is_default_assignee_for_cases`
	
	DROP PROCEDURE IF EXISTS `user_is_default_assignee_for_cases`;

DELIMITER $$
CREATE PROCEDURE `user_is_default_assignee_for_cases`()
SQL SECURITY INVOKER
BEGIN
	# This procedure needs the following objects
	#	- Variables:
	#		- @replace_default_assignee
	#		- @component_id_this_role
	#		- @bz_user_id
	#		- @user_role_desc
	#		- @id_role_type
	#		- @user_pub_name
	#		- @product_id
	#

	# We only do this if this is needed:
	IF (@replace_default_assignee = 1)
	
	THEN
	# change the initial owner and initialqa contact to the invited BZ user.
											
		# Get the old values so we can log those
			SET @old_component_initialowner = (SELECT `initialowner` 
										FROM `components` 
										WHERE `id` = @component_id_this_role)
										;
			SET @old_component_initialqacontact = (SELECT `initialqacontact` 
										FROM `components` 
										WHERE `id` = @component_id_this_role)
										;
			SET @old_component_description = (SELECT `description` 
										FROM `components` 
										WHERE `id` = @component_id_this_role)
										;

		# Update the default assignee and qa contact
			UPDATE `components`
			SET 
				`initialowner` = @bz_user_id
				,`initialqacontact` = @bz_user_id
				,`description` = @user_role_desc
				WHERE 
				`id` = @component_id_this_role
				;	

		# We record the name of this procedure for future debugging and audit_log`
				SET @script = 'PROCEDURE - user_is_default_assignee_for_cases';
				SET @timestamp = NOW();
					
		# Log the actions of the script.
			SET @script_log_message = CONCAT('The component: '
									, (SELECT IFNULL(@component_id_this_role, 'component_id_this_role is NULL'))
									, ' (for the role_type_id #'
									, (SELECT IFNULL(@id_role_type, 'id_role_type is NULL'))
									, ') has been updated.'
									, '\r\The default user now associated to this role is bz user #'
									, (SELECT IFNULL(@bz_user_id, 'bz_user_id is NULL'))
									, ' (real name: '
									, (SELECT IFNULL(@user_pub_name, 'user_pub_name is NULL'))
									, ') for the unit #' 
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
				
		# We update the BZ logs
			INSERT  INTO `audit_log`
				(`user_id`
				,`class`
				,`object_id`
				,`field`
				,`removed`
				,`added`
				,`at_time`
				) 
				VALUES 
				(@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'initialowner',@old_component_initialowner,@bz_user_id,@timestamp)
				, (@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'initialqacontact',@old_component_initialqacontact,@bz_user_id,@timestamp)
				, (@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'description',@old_component_description,@user_role_desc,@timestamp)
				;

		# We log what we have just done into the `ut_audit_log` table
			SET @bzfe_table = 'components';
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
				 (@timestamp ,@bzfe_table , 'initialowner' , @old_component_initialowner , @bz_user_id , @script , 'Add user as default assignee for the role')
				 , (@timestamp ,@bzfe_table , 'initialqacontact' , @old_component_initialqacontact , @bz_user_id , @script , 'Add user as default QA for the role')
				 , (@timestamp ,@bzfe_table , 'description' , @old_component_description , @user_role_desc , @script , 'Change the desription for the role')
				 ;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
	END IF;
END $$
DELIMITER ;

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