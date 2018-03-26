# For any question about this script, ask Franck

#############################################
#											#
# IMPORTANT INFORMATION ABOUT THIS SCRIPT	#
#											#
#############################################
#
# Built for BZFE database v2.19
#
# This script is a part of what need to happen when a user is invited to a role in a unit for a case as the case is being created.
# BEFORE this script is run, we need to:
#	- Add the user to the list of user in that role for the unit
#	  Because we know this is the first user in this tole, it is done with the script
#		- 3_replace_dummy_role_with_genuine_user_as_default_in_unee-t_bzfe_v2.x.sql
#
# After that we can run this script which will:
#	- Adds an existing BZ user as ASSIGNEE to an existing case which has already been created.
#	- Adds a comment in the table 'longdesc' to the case to explain that the invitation has been sent to the invited user
#	- Record the change of assignee in the bug activity table so that we have history
#	- Does NOT update the bug_user_last_visit table as the user had no action in there.
#	- NOT IMPLEMENTED YET - Checks if the user is a MEFE user only and IF the user is a MEFE user only disable the mail sending functionality from the BZFE.
#
# Use this script only if 
#	- the Unit/Product ALREADY EXISTS in the BZFE
#	- the BZ user is the first 'real' person to be assigned to this role for this unit.
#	- The table 'ut_data_to_add_user_to_a_case' has been updated and we know the record that we need to use to do the update.
#
# Limits of this script:
#	- DO NOT USE if the unit DOES NOT exists in the BZ database.
#	- DO NOT USE if the role DOES NOT exists in the BZ database for that unit.
#	- DO NOT USE if the role created is assigned to a 'dummy' BZ user.
#	- DO NOT USE if the BZ User is NOT the first 'real' user in this role for that unit.
#
#################################################################
#																#
# UPDATE THE BELOW VARIABLES ACCORDING TO YOUR NEEDS			#
#																#
#################################################################
#
# The case: What is the id of the record that you want to use in the table 'ut_data_to_add_user_to_a_case'
	SET @reference_for_case_update = 1;
#
########################################################################
#
#	ALL THE VARIABLES WE NEED HAVE BEEN DEFINED, WE CAN RUN THE SCRIPT #
#
########################################################################

# Info about this script
	SET @script = '5_2_add_a_BZ_user_as_assignee_to_a_case_in_unee-t_bzfe_v2.19';

# The case:
	SET @case_id = (SELECT `bz_case_id` FROM `ut_data_to_add_user_to_a_case` WHERE `id` = @reference_for_case_update);
	
# The role for the invitee:
	# We need to do this in 2 steps
	SET @mefe_invitation_id = (SELECT `mefe_invitation_id` FROM `ut_data_to_add_user_to_a_case` WHERE `id` = @reference_for_case_update);
	SET @user_role_type_id = (SELECT `user_role_type_id` FROM `ut_data_to_replace_dummy_roles` WHERE `mefe_invitation_id` = @mefe_invitation_id);
	SET @user_role_type_description = (SELECT `bz_description` FROM `ut_role_types` WHERE `id_role_type` = @user_role_type_id);

# The creator (BZ user id that is inviting this person in this role)
	SET @creator_bz_id = (SELECT `bzfe_invitor_user_id` FROM `ut_data_to_add_user_to_a_case` WHERE `id` = @reference_for_case_update);
	
# The user that you want to associated to the case.	
# BZ user id of the additional BZ user that you want to associate to this role for that unit.
	SET @bz_user_id = (SELECT `bz_user_id` FROM `ut_data_to_add_user_to_a_case` WHERE `id` = @reference_for_case_update);

# Timestamp	
	SET @timestamp = NOW();
	
# We capture the current assignee for the case so that we can log what we did
	SET @current_assignee = (SELECT `assigned_to` FROM `bugs` WHERE `bug_id` = @case_id);
	
# We also need the login name for the previous assignee and the new assignee
	SET @current_assignee_username = (SELECT `login_name` FROM `profiles` WHERE `userid` = @current_assignee);
	
# We need the login from the user we are inviting to the case
	SET @invitee_login_name = (SELECT `login_name` FROM `profiles` WHERE `userid` = @bz_user_id);
	
# We make the user the assignee for this case:
	UPDATE `bugs`
	SET 
		`assigned_to` = @bz_user_id
		, `delta_ts` = @timestamp
		, `lastdiffed` = @timestamp
	WHERE `bug_id` = @case_id
	;

	# Log the actions of the script.
		SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' is now the assignee for the case #'
									, @case_id
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
	
# Record the change in the Bug history
	INSERT INTO	`bugs_activity`
		(`bug_id` 
		, `who` 
		, `bug_when`
		, `fieldid`
		, `added`
		, `removed`
		)
		VALUES
		(@case_id
		, @creator_bz_id
		, @timestamp
		, 16
		, @invitee_login_name
		, @current_assignee_username
		)
		;

	# Log the actions of the script.
		SET @script_log_message = CONCAT('the case histoy for case #'
									, @case_id
									, ' has been updated: '
									, 'old assignee was: '
									, @current_assignee_username
									, 'new assignee is: '
									, @invitee_login_name
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
		
# Add a comment to inform users that the invitation has been processed.
# WARNING - This is technically NOT true as the invitation STILL needs to be processed in the MEFE API too.
	INSERT INTO `longdescs`
		(`bug_id`
		, `who`
		, `bug_when`
		, `thetext`
		)
		VALUES
		(@case_id
		, @creator_bz_id
		, @timestamp
		, CONCAT ('An invitation to collaborate on this case has been sent to the '
			, @user_role_type_description 
			, ' for this unit'
			)
		)
		;
	# Log the actions of the script.
		SET @script_log_message = CONCAT('A message has been added to the case #'
									, @case_id
									, ' to inform users that inviation has been sent'
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

# Update the table 'ut_data_to_add_user_to_a_case' so that we record what we have done
	UPDATE `ut_data_to_add_user_to_a_case`
	SET 
		`bz_created_date` = @timestamp
		, `comment` = CONCAT ('inserted in BZ with the script \''
				, @script
				, '\'\r\ '
				, IFNULL(`comment`, '')
				)
	WHERE `id` = @reference_for_case_update;