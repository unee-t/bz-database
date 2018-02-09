# For any question about this script, ask Franck

#############################################
#											#
# IMPORTANT INFORMATION ABOUT THIS SCRIPT	#
#											#
#############################################
#
# Built for BZFE database v2.13
#
# This script adds an existing BZ user to an existing case which has already been created.
# We use this when:
#	- The user is invited to a role in a unit for a case that already been created
#
# When this happens we need to:
#	- Add the user to the list of user in that role for the unit
#	  This is done with the scripts
#		- 3_replace_dummy_role_with_genuine_user_as_default_in_unee-t_bzfe_v2.13.sql
#		OR
#		- 4_add_an_existing_bz_user_to_a_role_in_an_existing_unit_bzfe_v2.13.sql
#
#
# Use this script only if 
#	- the Unit/Product ALREADY EXISTS in the BZFE
#	- the BZ user ALREADY has an assigned role in that unit (does NOT need to be the default assignee for the role).
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

# The unit:

	# enter the case id
		SET @case_id = ??;

# The creator (BZ user id that is inviting this person in this role (default is 1 - Administrator).
	# For LMB migration, we use 2 (support.nobody)
		SET @creator_bz_id = 2;
	
# The user that you want to associated to the case.	
	# BZ user id of the additional BZ user that you want to associate to this role for that unit.
		SET @bz_user_id = 3;
		
########################################################################
#
#	ALL THE VARIABLES WE NEED HAVE BEEN DEFINED, WE CAN RUN THE SCRIPT #
#
########################################################################

# Info about this script
	SET @script = '5_add_a_BZ_user_to_a_case_in_unee-t_bzfe_v2.13.sql';

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