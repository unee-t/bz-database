# This script 
#	- Checks if a user a dummy assigne for a given component in a given unit
#	- Updates the dummy user to a LIVE user

#################################################################
#																#
# UPDATE THE BELOW VARIABLES ACCORDING TO YOUR NEEDS			#
#																#
#################################################################
#
# The MEFE invitation id that we want to process:
	SET @mefe_invitation_id = '%s';
#
# Environment: Which environment are you creating the unit in?
#	- 1 is for the DEV/Staging
#	- 2 is for the prod environment
#	- 3 is for the Demo environment
	SET @environment = '2';
#
########################################################################
#
#	ALL THE VARIABLES WE NEED HAVE BEEN DEFINED, WE CAN RUN THE SCRIPT #
#
########################################################################
#
#
#############################################
#											#
# IMPORTANT INFORMATION ABOUT THIS SCRIPT	#
#											#
#############################################
#
# Built for BZFE database v3.0
#
# Use this script only if the Unit EXIST in the BZFE 
# It assumes that the unit has been created with all the necessary BZ objects and all the roles assigned to dummy users.
#
# Pre-requisite:
#	- The table 'ut_invitation_api_data' has been updated 
# 	- We know the MEFE Invitation id that we need to process.
#	- We know the environment where this script is run
# 
# This script depends on several SQL procedures:
#	- Check if this new user is the first in this role for this unit.
#		- If it IS the first in this role for this unit.
#		 	- Replace the Default 'dummy user' for a specific role with the BZ user in CC for this role for this unit.
#		- If it is NOT the first in this role for this unit.
#			- Do NOT replace the Default assignee for this component/role
#	- Reset the permissions for this unit for this user to the default permissions
#	- WIP Remove this user from the list of user in default CC for a case for this role in this unit.
#
#
#	- Add an existing BZ user as ASSIGNEE to an existing case which has already been created.
#	- Add a comment in the table 'longdesc' to the case to explain that the invitation has been sent to the invited user
#	- Record the change of assignee in the bug activity table so that we have history
#	- Does NOT update the bug_user_last_visit table as the user had no action in there.
#	- Check if the user is a MEFE user only and IF the user is a MEFE user only disable the mail sending functionality from the BZFE.
#
# Limits of this script:
#	- Unit must have all roles created with Dummy user roles.
#
#####################################################
#					
# First we need to define all the variables we need
#					
#####################################################

# Info about this script
	SET @this_script = 'update_assignee_if_dummy_user.sql';

# Timestamp	
	SET @timestamp = NOW();
	
# We create a temporary table to record the ids of the dummy users in each environments:
	/*Table structure for table `ut_temp_dummy_users_for_roles` */
		DROP TABLE IF EXISTS `ut_temp_dummy_users_for_roles`;

		CREATE TABLE `ut_temp_dummy_users_for_roles` (
		  `environment_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Id of the environment',
		  `environment_name` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
		  `tenant_id` int(11) NOT NULL,
		  `landlord_id` int(11) NOT NULL,
		  `contractor_id` int(11) NOT NULL,
		  `mgt_cny_id` int(11) NOT NULL,
		  `agent_id` int(11) DEFAULT NULL,
		  PRIMARY KEY (`environment_id`)
		) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

	/*Data for the table `ut_temp_dummy_users_for_roles` */
		INSERT INTO `ut_temp_dummy_users_for_roles`(`environment_id`,`environment_name`,`tenant_id`,`landlord_id`,`contractor_id`,`mgt_cny_id`,`agent_id`) values 
			(1,'DEV/Staging',96,94,93,95,92),
			(2,'Prod',93,91,90,92,89),
			(3,'demo/dev',4,3,5,6,2);
	
# The reference of the record we want to update in the table ''
	SET @reference_for_update = (SELECT `id` FROM `ut_invitation_api_data` WHERE `mefe_invitation_id` = @mefe_invitation_id);	

# The MEFE information:
	SET @mefe_invitor_user_id = (SELECT `mefe_invitor_user_id` FROM `ut_invitation_api_data` WHERE `id` = @reference_for_update);

# The unit name and description
	SET @product_id = (SELECT `bz_unit_id` FROM `ut_invitation_api_data` WHERE `id` = @reference_for_update);

# The Invitor - BZ user id of the user that has genereated the invitation.
	SET @creator_bz_id = (SELECT `bzfe_invitor_user_id` FROM `ut_invitation_api_data` WHERE `id` = @reference_for_update);

	# We populate the additional variables that we will need for this script to work:
		SET @creator_pub_name = (SELECT `realname` FROM `profiles` WHERE `userid` = @creator_bz_id);
	
# The user who you want to associate to this unit - BZ user id of the user that you want to associate/invite to the unit.
	SET @bz_user_id = (SELECT `bz_user_id` FROM `ut_invitation_api_data` WHERE `id` = @reference_for_update);

# What is the role for the user?
	SET @id_role_type = (SELECT `user_role_type_id` FROM `ut_invitation_api_data` WHERE `id` = @reference_for_update);	
	
	# We populate the additional variables that we will need for this script to work:
		SET @role_user_g_description = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=@id_role_type);
		SET @user_pub_name = (SELECT (LEFT(`login_name`,INSTR(`login_name`,"@")-1)) FROM `profiles` WHERE `userid` = @bz_user_id);
		SET @role_user_pub_info = CONCAT(@user_pub_name
								, IF (@role_user_more = '', '', ' - ')
								, IF (@role_user_more = '', '', @role_user_more)
								)
								;
		SET @user_role_desc = (CONCAT(@role_user_g_description, ' - ',@role_user_pub_info));
	
# Role in this unit for the invited user:
	#	- Tenant 1
	# 	- Landlord 2
	#	- Agent 5
	#	- Contractor 3
	#	- Management company 4
	SET @role_user_more = (SELECT `user_more` FROM `ut_invitation_api_data` WHERE `id` = @reference_for_update);
	SET @user_role_type_description = (SELECT `bz_description` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type);
	SET @user_role_type_name = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type);
	
	# We need to get the component_id for this role for this product/unit
	# We get that from the ut_product_group table.
		SET @component_id_this_role = (SELECT `component_id` 
									FROM `ut_product_group` 
									WHERE `product_id` = @product_id 
										AND `role_type_id` = @id_role_type
										AND `group_type_id` = 2)
										;
				
	# Is the current assignee for this role for this unit one of the dummy user in this environment?

		# What is the CURRENT default assignee for the role this user has been invited to?
			SET @current_default_assignee_this_role = (SELECT `initialowner` FROM `components` WHERE `id` = @component_id_this_role);

		# What is the default dummy user id for this environment?
		
			# Get the BZ profile id of the dummy users based on the environment variable
				# Tenant 1
					SET @bz_user_id_dummy_tenant = (SELECT `tenant_id` 
												FROM `ut_temp_dummy_users_for_roles` 
												WHERE `environment_id` = @environment)
												;

				# Landlord 2
					SET @bz_user_id_dummy_landlord = (SELECT `landlord_id` 
												FROM `ut_temp_dummy_users_for_roles` 
												WHERE `environment_id` = @environment)
												;
					
				# Contractor 3
					SET @bz_user_id_dummy_contractor = (SELECT `contractor_id` 
												FROM `ut_temp_dummy_users_for_roles` 
												WHERE `environment_id` = @environment)
												;
					
				# Management company 4
					SET @bz_user_id_dummy_mgt_cny = (SELECT `mgt_cny_id` 
												FROM `ut_temp_dummy_users_for_roles` 
												WHERE `environment_id` = @environment)
												;
					
				# Agent 5
					SET @bz_user_id_dummy_agent = (SELECT `agent_id` 
												FROM `ut_temp_dummy_users_for_roles` 
												WHERE `environment_id` = @environment)
												;

		# What is the BZ dummy user id for this role in this script?
			SET @bz_user_id_dummy_user_this_role = IF( @id_role_type = 1
											, @bz_user_id_dummy_tenant
											, IF (@id_role_type = 2
												, @bz_user_id_dummy_landlord
												, IF (@id_role_type = 3
													, @bz_user_id_dummy_contractor
													, IF (@id_role_type = 4
														, @bz_user_id_dummy_mgt_cny
														, IF (@id_role_type = 5
															, @bz_user_id_dummy_agent
															, 'Something is very wrong!!'
															)
														)
													)
												)
											)
											;

# Answer to the question "Is the current default assignee for this role one of the dummy users?"
	SET @is_current_assignee_this_role_a_dummy_user = IF (@current_default_assignee_this_role = @bz_user_id_dummy_user_this_role
		, 1
		, 0
		)
		;	
	
# Is the invited user an occupant of the unit?
	SET @is_occupant = (SELECT `is_occupant` FROM `ut_invitation_api_data` WHERE `id` = @reference_for_update);

# Do we need to disable the BZ email notification for this user?
	SET @is_mefe_only_user = (SELECT `is_mefe_only_user` 
		FROM `ut_invitation_api_data` 
		WHERE `id` = @reference_for_update)
		;
	
# Replace the default user for this role if needed
# This procedure needs the following objects:
#	- variables:
#		- @is_current_assignee_this_role_a_dummy_user
#		- @component_id_this_role
#		- @bz_user_id
#		- @user_role_desc
#		- @id_role_type
#		- @user_pub_name
#		- @product_id
#		- @creator_bz_id
#		- @mefe_invitation_id
#		- @mefe_invitor_user_id
#		- @is_occupant
#		- @is_mefe_only_user
#		- @role_user_more
	CALL `update_assignee_if_dummy_user`;

#Clean up
		
	# We Delete the temp table as we do not need it anymore
		DROP TABLE IF EXISTS `ut_temp_dummy_users_for_roles`;
	
