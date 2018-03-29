# For any question about this script, ask Franck

#############################################
#											#
# IMPORTANT INFORMATION ABOUT THIS SCRIPT	#
#											#
#############################################
#
# Built for BZFE database v2.17 to v2.19
#
# This script adds an existing BZ user to an existing case which has already been created.
# We use this when:
#	- The user is invited to a role in a unit for a case that already been created
#
# When this happens we need to:
#	- Add the user to the list of user in that role for the unit
#	  This is done with the scripts
#		- 3_replace_dummy_role_with_genuine_user_as_default_in_unee-t_bzfe_v2.x.sql
#		OR
#		- 4_add_an_existing_bz_user_to_a_role_in_an_existing_unit_bzfe_v2.x.sql
#
#
# Use this script only if 
#	- the Unit/Product ALREADY EXISTS in the BZFE
#	- the BZ user ALREADY has an assigned role in that unit (does NOT need to be the default assignee for the role).
#	- The table 'ut_data_to_add_user_to_a_case' has been updated and we know the record that we need to use to do the update.
#
# Limits of this script:
#	- DO NOT USE if the unit DOES NOT exists in the BZ database.
#	- DO NOT USE if the role DOES NOT exists in the BZ database for that unit.
#	- DO NOT USE if the role created is assigned to a 'dummy' BZ user.
#	- DO NOT USE if the BZ User has NO role in that unit.
#
#################################################################
#																#
# UPDATE THE BELOW VARIABLES ACCORDING TO YOUR NEEDS			#
#																#
#################################################################

# The case: What is the id of the record that you want to use in the table 'ut_data_to_add_user_to_a_case'
	SET @reference_for_case_update = 1;
	
########################################################################
#
#	ALL THE VARIABLES WE NEED HAVE BEEN DEFINED, WE CAN RUN THE SCRIPT #
#
########################################################################

# Info about this script
	SET @script = '5_add_a_BZ_user_to_a_case_in_unee-t_bzfe_v2.19.sql';

# The case:
	SET @case_id = (SELECT `bz_case_id` FROM `ut_data_to_add_user_to_a_case` WHERE `id` = @reference_for_case_update);

# The creator (BZ user id that is inviting this person in this role)
	SET @creator_bz_id = (SELECT `bzfe_invitor_user_id` FROM `ut_data_to_add_user_to_a_case` WHERE `id` = @reference_for_case_update);
	
# The user that you want to associated to the case.	
# BZ user id of the additional BZ user that you want to associate to this role for that unit.
	SET @bz_user_id = (SELECT `bz_user_id` FROM `ut_data_to_add_user_to_a_case` WHERE `id` = @reference_for_case_update);

# Timestamp	
	SET @timestamp = NOW();
	
# We need the login from the we are inviting to the case
	SET @invitee_login_name = (SELECT `login_name` FROM `profiles` WHERE `userid` = @bz_user_id);
	
# We make the user in CC for this case:
	INSERT INTO `cc`
		(`bug_id`
		,`who`
		) 
		VALUES 
		(@case_id,@bz_user_id);

	# Log the actions of the script.
		SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' is added as copied for the case #'
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

# Log the change in the bug_activity table
# The old value for the audit will always be '' as this is the first time that this user
# is involved in this case in that unit.
	
	INSERT INTO `bugs_activity`
		(`bug_id`
		,`attach_id`
		,`who`
		,`bug_when`
		,`fieldid`
		,`added`
		,`removed`
		,`comment_id`
		)
		VALUES 
		(@case_id
		, NULL
		, @creator_bz_id
		, @timestamp
		, 22
		, @invitee_login_name
		, ''
		, NULL)
		;

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