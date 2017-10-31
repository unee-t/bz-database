# Contact Franck for any question about this script
# 
# This script inserts the demo users in unee-t v2.x
# Pre-Requisite: you have a clean blank unee-t v2.x installation
# 
# This script also give permissions and accesses to these users.
# 
# We want to give these users dummy roles and profile so that people can play with the tool in DEMO/DEV/TEST
# All these users are Stakeholders in Test Unit 1 A
#   - Leonel is the Agent for the Lanldord (Marley) She is the one who created the unit initially 
#     His `id_role_type` in the table `ut_role_types` = 5
#   - Marley is the Landlord
#     His `id_role_type` in the table `ut_role_types` = 2
#   - Michael is one of the a 2 Tenants living in this unit.
#     His `id_role_type` in the table `ut_role_types` = 1
#   - Sabrina is the other Tenant living in this unit.
#     Her `id_role_type` in the table `ut_role_types` = 1
#   - Celeste works for the Management Company Management Co, in charge of this unit.
#     Her `id_role_type` in the table `ut_role_types` = 4
#   - Jocelyn also works for the Management Company Management Co, in charge of this unit.
#     Her `id_role_type` in the table `ut_role_types` = 4
#   - Marina is the Manager of Celeste and Jocelyn at the Management Company Management Co, in charge of this unit.
#     Her `id_role_type` in the table `ut_role_types` = 4
#   - Regina is the Agent for Marley and Michael (the co-tenants).
#     Her `id_role_type` in the table `ut_role_types` = 5
#   - Marvin is a Contractor (an electrician).
#     His `id_role_type` in the table `ut_role_types` = 3
#   - Lawrence is another Contractor (Aircon Repair and Maintenance).
#     His `id_role_type` in the table `ut_role_types` = 3
#   - Anabelle has no link to this unit, she is an 'unattached' Unee-T user.
#
# We have also created a generic email address for the management company Management Co
# When a case is created for Management Co the alerts are set to management.co@example.com
#
# This script: 
#  - Uses the product_id = 1 that was created as part of the blank install
#  - Create all the groups we need based on the role of the users we created
#  - Grant user membership to the relevant groups
#  - Define the permissions (based on groups and group memberships) and based on the role of the user.
# 
# This script makes sure that we have all the groups we need to 
#  - Restrict/manage accesses to the product/unit
#  - Limit who can see users and stakeholders for the unit
#  
# This script requires several variables: see below

# 
# This script does NOT Create
#   - Any New product/unit - it uses the Test unit already created
# 	The product id_for the unit = 1
#

# We need to disable the FK check first:
	SET FOREIGN_KEY_CHECKS = 0;

	
# We need to answer several questions:
	# MANDATORY questions: we can not create the product and/or user if we miss these
	# are identified with * in the list below
	#
	#	- The product/unit:
	# *		- What the unit/product that this user is associated to?
	#
	# 	- The user we are creating
	# *		- What is the BZ user id for the user we are creating?
	# 		- What is the public username for this new user?
	#			Default value is the user id.
	#
	#	- The Role for this new user:
	# *		- What is the role of the user we are creating?
	#			We use an id in a dedicated table `ut_role_types` to make it easier
	# 		- What is the information that we want to include next to the role?
	#  			 This is typically generic information about the person, management company or contractor
	# 		- Regardless of the fact that the user was asked for approval, can this user 
	#		   approve flags? The scenario is a management company or contractor: you ask to a 
	#		   "generic" user but these are individual who need to approve (1 requestee, several approvers)
	#
	#	- New user visibility and permissions
	#		- Is this new user visible to stakholders/roles other than the users which are 
	#		   in the same stakeholder/role as himself for this unit?
	#			Default value is YES
	#				No is also an acceptable answer
	#		 - Is the new user we are creating allowed to be asked directly for approval?
	#			Default value is YES
	#				No is also an acceptable answer
	# 
	# 	- The user who is creating this new product/unit or user or role/stakeholder
	# *		- What is the BZ user id for the user who is creating this user?
	# 		- What is the public username for the user who is creating this new user?
	#			Default value is user id (an email address).
	#
	#	- If the user is from a management company or a contractor:
	#		- What is the Management Company id?
	#		  We use a dedicated table in the database to maintain the list of Companies and contractors
	#			Default value is 1 (unknown)
	#		- What are the company areas of expertise (multiple select)?
	#		  We use a dedicated table in the database to maintain the list of expertise
	#		- What is the mapping between the company and the expertise?
	#		  We use a dedicated table in the database to maintain this mapping
	#			Default value is 1 (unknown)	
	#
	# - We need to record the following information for future reference:
	#		- mapping product_id/user_role_id/bz_group_id
	#			To make sure that we are creating a new user with this same role_id
	#			we do NOT re-create the group but just make this new user a member of the
	#			existing group that was created before.
	#		- Mapping product_id/creator_user_id/created_user_id
	#			This is for audit purpose and will be usefull to display a list of visible user
	#			in some additional scenario
	#
	#
	#


	
# Get the variables that we need:
		# We know that the unit is product_id = 1 
			SET @product_id = 1;

		# We create a variable @visibility_explanation_1 and 2 to facilitate development
		# 	This variable store the text displayed next to the 'visibility' tick in a case
		# 	We do this that way so we can re-use @visibility_explanation in the script to create several demo users.
			SET @visibility_explanation_1 = 'Visible only to ';
			SET @visibility_explanation_2 = ' for this unit.';
			
		# Get the additional data we need
			SET @unit = (SELECT `name` FROM `products` WHERE `id`=@product_id);

		# We will need to use the unit name in queries, queries cannot have space
		# We need to check and test wich other special characters are replaced in a query too...
				###################################################################################################
				# WIP We need to check and test wich other special characters we need to replace in a query too...#
				###################################################################################################
			SET @unit_for_query = REPLACE(@unit,' ','%');
		# We will need to use the unit name in tag name, 
		#tag name cannot have space or special characters in then
			SET @unit_for_flag = REPLACE(@unit_for_query,'%','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'-','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'!','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'@','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'#','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'$','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'%','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'^','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'&','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'*','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'(','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,')','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'+','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'=','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'<','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'>','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,':','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,';','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'"','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,',','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'.','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'?','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'/','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'\\','_');

# Insert the demo users
	
	/*We Remove all the existing users in the installation */
		TRUNCATE `profiles`;
		
	/*Data for the table `profiles` */
		INSERT  INTO `profiles`
			(`userid`
			,`login_name`
			,`cryptpassword`
			,`realname`
			,`disabledtext`
			,`disable_mail`
			,`mybugslink`
			,`extern_id`
			,`is_enabled`
			,`last_seen_date`
			) 
			VALUES 
			(1,'administrator@example.com','B8AgzURt,NDrX2Bt8stpgXPKsNRYaHmm0V2K1+qhfnt76oLAvN+Q{SHA-256}','Administrator','',0,1,NULL,1,NULL),
			(2,'leonel@example.com','uVkp9Jte,ts7kZpZuOcTkMAh1c4iX4IcEZTxpq0Sfr7XraiZoL+g{SHA-256}','Leonel','',0,1,NULL,1,NULL),
			(3,'marley@example.com','AMOb0L00,NlJF4wyZVyT+xWuUr3RYgDIYxMhfBJCZxvkSh5cRSVs{SHA-256}','Marley','',0,1,NULL,1,NULL),
			(4,'michael@example.com','Tp0jDQnd,kD+mf67/v/ck68nOyRTR4j7JNVpo1XzzDFSIR6U7Lps{SHA-256}','Michael','',0,1,NULL,1,NULL),
			(5,'sabrina@example.com','fjeiOOVC,vUkDbdxcfk9snn9J5Vh4r/cujX2FfOKEcBZBAOcMw3k{SHA-256}','Sabrina','',0,1,NULL,1,NULL),
			(6,'celeste@example.com','ZAU7m97y,kw6J1Bf2Hw21qELelxM3BbK+4avsmJytG/WzssHMbXE{SHA-256}','Celeste','',0,1,NULL,1,NULL),
			(7,'jocelyn@example.com','0ZprH6RJ,zXa/xkkETvkPZ988xpyQQocYYfLAIWdCLCk1wE4QXNA{SHA-256}','Jocelyn','',0,1,NULL,1,NULL),
			(8,'marina@example.com','8c2ofNwd,VpZbBAByL89ZKCI3xT7zFjZBb/X7JHW6KjtA9yY8KYo{SHA-256}','Marina','',0,1,NULL,1,NULL),
			(9,'regina@example.com','HuM6hVYF,Ev6TBPrrOm4pSu5chsr1Q6Hi6q2Tmm98IbLh7ONqtYs{SHA-256}','Regina','',0,1,NULL,1,NULL),
			(10,'marvin@example.com','6kTmgSt9,FI+tK4vrJQa8lInrRGKxmQ0JW2WpVImRk+ylhcMYGKM{SHA-256}','Marvin','',0,1,NULL,1,NULL),
			(11,'lawrence@example.com','JqPmW7RA,tJopvIAj1kbeRJ61pZUqjce1dZrGoBpnHMzycgTuTqE{SHA-256}','Lawrence','',0,1,NULL,1,NULL),
			(12,'anabelle@example.com','9bgiCNi8,32d10yq/btaTsj/awDksNPjdUDLIrGfkK+vRKWfYbQo{SHA-256}','Anabelle','',0,1,NULL,1,NULL),
			(13,'management.co@example.com','C162r0Mo,/V0m+v2cmZqU0JOjQBR8X5Q26xSgKTBs/f/Wke51oSI{SHA-256}','Management Co','',0,1,NULL,1,NULL);
			

# First we Create the Privileges for Leonel (the creator of the Unit)
#   - Leonel is the Agent for the Lanldord (Marley) he is the one who created the unit initially 
#     His `id_role_type` in the table `ut_role_types` = 5

	# We do NOT need to create the unit here.
	# BUT We need to Make sure that the the component for this Unit is correct
	# We also want to show the publicly visible information for Leonel.
		# His public name
			SET @creator_pub_name = 'Leonel';
		# More details
			SET @creator_more = 'My Real Estate Agency - Phone number: 123 456 7891. For a faster response, please message me directly in Unee-T for this unit';
		# Se we can create the public info too
			SET @creator_pub_info = CONCAT(@creator_pub_name,' - ', @creator_more);

			# Housekeeping:
			# The Creator is also a stakeholder so we define the values for the stakholder information:
			# His public name
				SET @stakeholder_pub_name = @creator_pub_name;
			# More details
				SET @stakeholder_more = @creator_more;
			# Se we can create the public info too
				SET @stakeholder_pub_info = @creator_pub_info;
			# The creator is also the user creator in this case.
				 SET @user_creator_pub_name = @creator_pub_name;
			# More details
				SET @user_creator_more = @creator_more;
			# Se we can create the public info too
				SET @user_creator_pub_info = @creator_pub_info;

	# User role: this is an id in the table `ut_role_types` for easier manipulation, update and maintenance
		SET @role_type_id = 5;

	# Is this user an occupant of the unit?
	#	- 1 = TRUE
	#	- 0 = FALSE
		SET @is_occupant = 0;

	# We Need the BZ user information for Leonel too
		SET @bz_user_id = 2;

	# We Need the BZ user information for the creator of the new user too (Leonel)
		SET @user_creator_bz_user_id = 2;
		
	# OPTIONAL INFORMATION:
	#
	# We need to know if this user is 
	#	- visible to all other user (1) 
	#		In this case this user will be a member of the group `@list_visible_assignees_group_id`
	#		for this product/unit.
	#	- visible only to people in the same role/stakeholder group. (0)
	# 		Else this user will NOT be a member of the group `@list_visible_assignees_group_id`
	#		for this product/unit.
	# By Default, the user is visible to all other user.
		SET @user_is_public = 1;
	#
	# We need to know if this user is 
	#	- visible to all other user (1) 
	#		In this case this user will be a member of the group `@see_visible_assignees_group_id`
	#		for this product/unit.
	#	- visible only to people in the same role/stakeholder group. (1)
	# 		Else this user will NOT be a member of the group `@see_visible_assignees_group_id`
	#		for this product/unit.
	# By Default, the user is visible to all other user.
		SET @user_can_see_public = 1; 
	#	
	# By default the creator is can be asked to approve all flags but we want flexibility there 
	# We know this might not be always true for all BZ user we create
		SET @can_be_asked_to_approve = 1;
	#
	# By default the creator can approve all flags but we want flexibility there 
	# We know this might not be always true for all BZ user we create
		SET @can_approve = 1;
	#
	# Is the user allowed to create new users?
		# only in the same group of stakholders
			SET @can_create_same_stakeholder = 1;
		
		# in ANY group of stakeholders
			SET @can_create_any_stakeholder = 1;
	
	# Is this user allowed to decided who can be requestee and grant Flags?
		SET @can_approve_user_for_flag = 1;
		
	# Is this user is allowed to decided who is visible in the list of assignee?
		SET @can_decide_if_user_is_visible = 1;
		
	# Is this user is allowed to decided if a new user can see visible assignees?
		SET @can_decide_if_user_can_see_visible = 1;

	# We have everything - Avanti!
	
		# Get the additional variable that we need
			# When is this happening?
				SET @timestamp = NOW();

			# We get the login name from the user_id
				SET @login_name = (SELECT `login_name` FROM `profiles` WHERE `userid`=@bz_user_id);

			# We get the Stakeholder designation from the `ut_role_types` table
			# this makes it easy to maintain
				SET @stakeholder = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=@role_type_id);

			# We get the Stakeholder Generic description for the BZFE from the `ut_role_types` table
			# this makes it easy to maintain
				SET @stakeholder_g_description = (SELECT `bz_description` FROM `ut_role_types` WHERE `id_role_type`=@role_type_id);

			# The 'visibility' explanation
				SET @visibility_explanation = CONCAT(@visibility_explanation_1,@stakeholder,@visibility_explanation_2);
		
		/*Data for the table `ut_map_user_unit_details` */
		# Update the Unee-T table that records information about the user:
			INSERT INTO `ut_map_user_unit_details`
							(`id_user_unit`
							, `created`
							, `record_created_by`
							, `is_obsolete`
							, `user_id`
							, `bz_profile_id`
							, `bz_unit_id`
							, `role_type_id`
							, `is_occupant`
							, `is_public_assignee`
							, `is_see_visible_assignee`
							, `is_flag_requestee`
							, `is_flag_approver`
							, `can_create_any_sh`
							, `can_create_same_sh`
							, `can_approve_user_for_flags`
							, `can_decide_if_user_visible`
							, `can_decide_if_user_can_see_visible`
							, `public_name`
							, `more_info`
							, `comment`
							)
							VALUES
							(NULL,@timestamp,@user_creator_bz_user_id,0,NULL,@bz_user_id,@product_id,@role_type_id,@is_occupant,@user_is_public,@user_can_see_public,@can_be_asked_to_approve,@can_approve,@can_create_any_stakeholder,@can_create_same_stakeholder,@can_approve_user_for_flag,@can_decide_if_user_is_visible,@can_decide_if_user_can_see_visible
							,@stakeholder_pub_name,@stakeholder_more,'');
		
		# We need to delete the component created in the BZ blank install
			DELETE FROM `components` WHERE `id`=1;

		/*Data for the table `components` */
		# We insert the correct values for the component/stakeholder.
			INSERT  INTO `components`
				(`id`
				,`name`
				,`product_id`
				,`initialowner`
				,`initialqacontact`
				,`description`
				,`isactive`
				) 
				VALUES 
				(NULL,@stakeholder,@product_id,@bz_user_id,@bz_user_id,CONCAT(@stakeholder_g_description, ' \r\ ', @stakeholder_pub_info),1);

		# In order to populate other table (flags, audit table,...) we need to get the newly created component_id
			SET @component_id = LAST_INSERT_ID();


		# We need to delete the groups that we have created as part of the default BZFE install so we can recreate these
		
#############################################################################################################
# DANGER because of this, the script will break if the list of groups we create in a blank BZFE changes...  #
#############################################################################################################
			DELETE FROM `groups` WHERE `id` >18 AND `id` <40;
		# We know the last 'system' group created by the BZFE creation script is 18
		# 	based on this, we derive the other new group_id too.
		# group for the unit creator (first new group we create)
			SET @unit_creator_group_id = 19;

		# We need a group that will allow all users to create cases.
			SET @create_case_group_id = (@unit_creator_group_id+1);

		# group to hide cases to this type of role/stakeholder (1)
			SET @show_to_stakeholder_1_group_id = (@create_case_group_id+1);
		# group to list all the user that are from the same stakeholder type  (1)
			SET @are_users_stakeholder_1_group_id = (@show_to_stakeholder_1_group_id+1);
		# group to hide cases to this type of role/stakeholder (2)
			SET @show_to_stakeholder_2_group_id = (@are_users_stakeholder_1_group_id+1);
		# group to list all the user that are from the same stakeholder type (2)
			SET @are_users_stakeholder_2_group_id = (@show_to_stakeholder_2_group_id+1);
		# group to hide cases to this type of role/stakeholder (3)
			SET @show_to_stakeholder_3_group_id = (@are_users_stakeholder_2_group_id+1);
		# group to list all the user that are from the same stakeholder type (3)
			SET @are_users_stakeholder_3_group_id = (@show_to_stakeholder_3_group_id+1);
		# group to hide cases to this type of role/stakeholder (4)
			SET @show_to_stakeholder_4_group_id = (@are_users_stakeholder_3_group_id+1);
		# group to list all the user that are from the same stakeholder type (4)
			SET @are_users_stakeholder_4_group_id = (@show_to_stakeholder_4_group_id+1);
		# group to hide cases to this type of role/stakeholder (5)
			SET @show_to_stakeholder_5_group_id = (@are_users_stakeholder_4_group_id+1);
		# group to list all the user that are from the same stakeholder type (5)
			SET @are_users_stakeholder_5_group_id = (@show_to_stakeholder_5_group_id+1);

		# group to hide cases to occupants
			SET @show_to_occupants_group_id = (@are_users_stakeholder_5_group_id+1);
		# group to list all the user that are from the same stakeholder type
			SET @are_occupants_group_id = (@show_to_occupants_group_id+1);

		# List all the user that are visible in the drop down list for assignees
			SET @list_visible_assignees_group_id = (@are_occupants_group_id+1);
		# Group to see the list of visible users for this unit in the assignee and cc lists
			SET @see_visible_assignees_group_id = (@list_visible_assignees_group_id+1);

		# get the id for the rest of the groups we need 
		# These are the groups to grant/request flags for this product/unit
			SET @g_group_next_step = (@see_visible_assignees_group_id+1);
			SET @r_group_next_step = (@g_group_next_step+1);
			SET @g_group_solution = (@r_group_next_step+1);
			SET @r_group_solution = (@g_group_solution+1);
			SET @g_group_budget = (@r_group_solution+1);
			SET @r_group_budget = (@g_group_budget+1);
			SET @g_group_attachment = (@r_group_budget+1);
			SET @r_group_attachment = (@g_group_attachment+1);
			SET @g_group_OK_to_pay = (@r_group_attachment+1);
			SET @r_group_OK_to_pay = (@g_group_OK_to_pay+1);
			SET @g_group_is_paid = (@r_group_OK_to_pay+1);
			SET @r_group_is_paid = (@g_group_is_paid+1);
		# Next is a group of groups for all the USERS who can approve/reject a flag
			SET @all_g_flags_group_id = (@r_group_is_paid+1);
		# Next is a group of groups for all the USERS who are allowed to be asked for flag approval
		# this allows us to display the correct list of users in the drop down list next to a flag
			SET @all_r_flags_group_id = (@all_g_flags_group_id+1);
			
		# Advanced permission groups:
			SET @can_edit_case_group_id = (@all_r_flags_group_id+1);
			SET @can_edit_all_field_case_group_id = (@can_edit_case_group_id+1);
			SET @can_edit_component_group_id = (@can_edit_all_field_case_group_id+1);
			SET @can_see_cases_group_id = (@can_edit_component_group_id+1);
	
		/*We can now create the groups that we need */
		# We need several groups so we can do what we want.
		# We are creating most of these groups when we create the product/unit.
		# This is the best way to do it
		#
		#
		
		INSERT  INTO `groups`
			(`id`
			,`name`
			,`description`
			,`isbuggroup`
			,`userregexp`
			,`isactive`
			,`icon_url`
			) 
			VALUES 
			# We need to add the product_id here as the group names must be unique.
			# We do not have to worry too much about the length of group names: type is varchar(255)
			# 
			# group for the creator of this unit
				(@unit_creator_group_id,CONCAT(@unit,' #',@product_id,' Unit Creators - Created by: ',@creator_pub_name),'This is the group for the unit creator',0,'',1,NULL),
			#
			# group to allow user to create cases for this unit
				(@create_case_group_id,CONCAT(@unit,' #',@product_id,' - Can Create Cases'),'User can create cases for this unit.',1,'',1,NULL),
			# group to hide cases to stakehodler 1
				(@show_to_stakeholder_1_group_id,CONCAT(@unit,' #',@product_id,' - ',(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 1)),CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 1),@visibility_explanation_2),1,'',1,NULL),
			# group to list all the user that are from the same stakeholder type  (1)
				(@are_users_stakeholder_1_group_id,CONCAT(@unit,' #',@product_id,' - List users - ',(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 1)),CONCAT('User is: ',(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 1)),0,'',1,NULL),
			# group to hide cases to stakehodler 2
				(@show_to_stakeholder_2_group_id,CONCAT(@unit,' #',@product_id,' - ',(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 2)),CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 2),@visibility_explanation_2),1,'',1,NULL),
			# group to list all the user that are from the same stakeholder type  (2)
				(@are_users_stakeholder_2_group_id,CONCAT(@unit,' #',@product_id,' - List users - ',(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 2)),CONCAT('User is: ',(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 2)),0,'',1,NULL),
			# group to hide cases to stakehodler 3
				(@show_to_stakeholder_3_group_id,CONCAT(@unit,' #',@product_id,' - ',(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 3)),CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 3),@visibility_explanation_2),1,'',1,NULL),
			# group to list all the user that are from the same stakeholder type  (3)
				(@are_users_stakeholder_3_group_id,CONCAT(@unit,' #',@product_id,' - List users - ',(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 3)),CONCAT('User is: ',(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 3)),0,'',1,NULL),
			# group to hide cases to stakehodler 4
				(@show_to_stakeholder_4_group_id,CONCAT(@unit,' #',@product_id,' - ',(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 4)),CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 4),@visibility_explanation_2),1,'',1,NULL),
			# group to list all the user that are from the same stakeholder type  (4)
				(@are_users_stakeholder_4_group_id,CONCAT(@unit,' #',@product_id,' - List users - ',(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 4)),CONCAT('User is: ',(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 4)),0,'',1,NULL),
			# group to hide cases to stakehodler 5
				(@show_to_stakeholder_5_group_id,CONCAT(@unit,' #',@product_id,' - ',(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 5)),CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 5),@visibility_explanation_2),1,'',1,NULL),
			# group to list all the user that are from the same stakeholder type  (5)
				(@are_users_stakeholder_5_group_id,CONCAT(@unit,' #',@product_id,' - List users - ',(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 5)),CONCAT('User is: ',(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 5)),0,'',1,NULL),
			# group to hide cases to occupants
				(@show_to_occupants_group_id,CONCAT(@unit,' #',@product_id,' - Occupant(s) - Created by: ',@creator_pub_name),CONCAT(@visibility_explanation_1,'Occupant(s)',@visibility_explanation_2),1,'',1,NULL),
			# group to list all the user that are occupants
				(@are_occupants_group_id,CONCAT(@unit,' #',@product_id,' - List Occupants - Created by: ',@creator_pub_name),'User is an occupant',0,'',1,NULL),
			# group to list the users who are VISIBLE stakeholders in this unit
			# We can hide user from the list of possible assignees by EXCLUDING the user from this list
				(@list_visible_assignees_group_id,CONCAT(@unit,' #',@product_id,' - List stakeholder'),'List all the users which are visible assignee(s) for this unit',0,'',1,NULL),
			# group to see the users who are stakeholders in this unit
				(@see_visible_assignees_group_id,CONCAT(@unit,' #',@product_id,' - See stakeholder'),'Can see all the users which are stakeholders for this unit',0,'',1,NULL),
			# We now need to create the groups that grant permissions for the flags for this unit
				(@g_group_next_step,CONCAT(@unit,' #',@product_id,' - GA Next Step'),'Grant approval for the Next step in a case',0,'',1,NULL),
				(@r_group_next_step,CONCAT(@unit,' #',@product_id,' - RA Next Step'),'Request approval for the Next step in a case',0,'',1,NULL),
				(@g_group_solution,CONCAT(@unit,' #',@product_id,' - GA Solution'),'Grant approval for the Solution in a case',0,'',1,NULL),
				(@r_group_solution,CONCAT(@unit,' #',@product_id,' - RA Solution'),'Request approval for the Solution in a case',0,'',1,NULL),
				(@g_group_budget,CONCAT(@unit,' #',@product_id,' - GA Budget'),'Grant approval for the Budget in a case',0,'',1,NULL),
				(@r_group_budget,CONCAT(@unit,' #',@product_id,' - RA Budget'),'Request approval for the Budget in a case',0,'',1,NULL),
				(@g_group_attachment,CONCAT(@unit,' #',@product_id,' - GA Attachment'),'Grant approval for an Attachment in a case',0,'',1,NULL),
				(@r_group_attachment,CONCAT(@unit,' #',@product_id,' - RA Attachment'),'Request approval for an Attachment in a case',0,'',1,NULL),
				(@g_group_OK_to_pay,CONCAT(@unit,' #',@product_id,' - GA OK to Pay'),'Grant approval to pay (for a bill/attachment)',0,'',1,NULL),
				(@r_group_OK_to_pay,CONCAT(@unit,' #',@product_id,' - RA OK to Pay'),'Request approval to pay (for a bill/attachment)',0,'',1,NULL),
				(@g_group_is_paid,CONCAT(@unit,' #',@product_id,' - GA is Paid'),'Confirm that it\'s paid (for a bill/attachment)',0,'',1,NULL),
				(@r_group_is_paid,CONCAT(@unit,' #',@product_id,' - RA is Paid'),'Ask if it\'s paid (for a bill/attachment)',0,'',1,NULL),
			# Next is a group for all the USERS who can approve/reject a flag
			# This is
			# 	- a group for all the users that can Gran approval to all the flags
			# 	- a group of GROUPS to group all the "grant flag" groups: all the '*_g_*' flags groups will be in this group
				(@all_g_flags_group_id,CONCAT(@unit,' #',@product_id,' - Can approve all flags'),'user in this group are allowed to approve all flags',0,'',1,NULL),
			# Next is a group:
			# 	- for all the USERS who are allowed to be asked for flag approval (requestee)
			#	  These users are the only one visible in the request for approval list.
			# 	- to group all the "request flag" groups: all the '*_r_*' flags groups will be in this group
				(@all_r_flags_group_id,CONCAT(@unit,' #',@product_id,' - Can be asked to approve all flags'),'user in this group are visible in the list of flag approver',0,'',1,NULL),
				
			# Advanced permission groups:	
				(@can_edit_case_group_id,CONCAT(@unit,' #',@product_id,' - Can edit'),'user in this can edit a case they have access to',1,'',1,NULL),
				(@can_edit_all_field_case_group_id,CONCAT(@unit,' #',@product_id,' - Can edit all fields'),'user in this can edit all fields in a case they have access to, regardless og its role',1,'',1,NULL),
				(@can_edit_component_group_id,CONCAT(@unit,' #',@product_id,' - Can edit components'),'user in this can edit components/stakholders and permission for the unit',1,'',1,NULL),
				(@can_see_cases_group_id,CONCAT(@unit,' #',@product_id,' - Visible to all'),'All users in this unit can see this case for the unit',1,'',1,NULL);


	# THIS IS NOT A BZ INITIATED ACTION!
	# 	To make sure Unee-T works as intended, we need to capture what we just did!
	# 	We insert information into the table which maps groups to products/component
	# 	This is so that it is easy in the future to identify all the groups that have
	# 	already been created for a given product.
	# 	We will need this as in some scenario when we add a user to a role in an existing product/unit
	# 	we do NOT need to re-create the group, just grant the new user access to the group.

#########################################################################################
#	
#	WE NEED MORE GROUP TYPES SO WE CAN RECORD
#		- @can_edit_case_group_id
#		- @can_edit_all_field_case_group_id
#		- @can_edit_component_group_id
#
#########################################################################################
	
		INSERT INTO `ut_product_group`
			(
			product_id
			,group_id
			,group_type_id
			,role_type_id
			,created
			)
			VALUES
			# This is the initial creation for this product/unit. We know that the group_type_id for this group is
			# 1 = Creator of the product/unit
				(@product_id,@unit_creator_group_id,1,@role_type_id,@timestamp),
				
			# 20 = Access to a product/unit
				(@product_id,@create_case_group_id,20,@role_type_id,@timestamp),
				
			# 22 = List users in a role
				(@product_id,@are_users_stakeholder_1_group_id,22,1,@timestamp),
				(@product_id,@are_users_stakeholder_2_group_id,22,2,@timestamp),
				(@product_id,@are_users_stakeholder_3_group_id,22,3,@timestamp),
				(@product_id,@are_users_stakeholder_4_group_id,22,4,@timestamp),
				(@product_id,@are_users_stakeholder_5_group_id,22,5,@timestamp),
				
			# 2 = hide cases from a role
				(@product_id,@show_to_stakeholder_1_group_id,22,1,@timestamp),
				(@product_id,@show_to_stakeholder_2_group_id,22,2,@timestamp),
				(@product_id,@show_to_stakeholder_3_group_id,22,3,@timestamp),
				(@product_id,@show_to_stakeholder_4_group_id,22,4,@timestamp),
				(@product_id,@show_to_stakeholder_5_group_id,22,5,@timestamp),
				
			# 3 = list occupants
				(@product_id,@are_occupants_group_id,3,NULL,@timestamp),
			
			# 24 = hide cases from occupants
				(@product_id,@show_to_occupants_group_id,22,NULL,@timestamp),
				
				
			# 4 = list visible users (possible assignee for a unit)
				(@product_id,@list_visible_assignees_group_id,4,NULL,@timestamp),
				
			# 5 = see visible users
				(@product_id,@see_visible_assignees_group_id,5,NULL,@timestamp),

			# Groups specific to flags
				# Can be a Requetee on flags for a case
					# 6 = r_a_case_next_step
						(@product_id,@r_group_next_step,6,@role_type_id,@timestamp),
					# 8 = r_a_case_solution
						(@product_id,@r_group_solution,8,@role_type_id,@timestamp),
					# 10 = r_a_case_budget
						(@product_id,@r_group_budget,10,@role_type_id,@timestamp),
						
				# Can be a Requetee on flags for an attachment
					# 12 = r_a_attachment_approve
						(@product_id,@r_group_attachment,12,@role_type_id,@timestamp),
					# 14 = r_a_attachment_ok_to_pay
						(@product_id,@r_group_OK_to_pay,14,@role_type_id,@timestamp),
					# 16 = r_a_attachment_is_paid
						(@product_id,@r_group_is_paid,16,@role_type_id,@timestamp),

				# Can approve a flag for a case
					# 7 = g_group_next_step
						(@product_id,@g_group_next_step,7,@role_type_id,@timestamp),
					# 9 = g_group_solution
						(@product_id,@g_group_solution,9,@role_type_id,@timestamp),
					# 11 = g_group_budget
						(@product_id,@g_group_budget,11,@role_type_id,@timestamp),
						
				# Can approve a flag for an attachment
					# 13 = g_group_attachment
						(@product_id,@g_group_attachment,13,@role_type_id,@timestamp),
					# 15 = g_group_OK_to_pay
						(@product_id,@g_group_OK_to_pay,15,@role_type_id,@timestamp),
					# 17 = g_group_is_paid	
						(@product_id,@g_group_is_paid,17,@role_type_id,@timestamp),					
				
				# Can be a Requestee for all flags
					# 18 = all_r_flags
						(@product_id,@all_r_flags_group_id,18,@role_type_id,@timestamp),
				
				# Can approve all flags
					# 19 = all_g_flags
						(@product_id,@all_g_flags_group_id,19,@role_type_id,@timestamp);

				# Can edit a case
					# 25 = Can edit a case
						(@product_id,@can_edit_case_group_id,25,@role_type_id,@timestamp),

				# Can Edit all field in the case, regardless of its role (for unit creator)
					# 26 = Can edit all fields in a case regardless of role
						(@product_id,@can_edit_all_field_case_group_id,26,@role_type_id,@timestamp),

				# Can Edit component/create new stakeholders
					# 27 = Can edit stakeholder/components for the product/unit
						(@product_id,@can_edit_component_group_id,27,@role_type_id,@timestamp),

				# Case is visible to all
					# 28 = Can edit stakeholder/components for the product/unit
						(@product_id,@can_see_cases_group_id,28,@role_type_id,@timestamp);


	/* Data for the table `group_group_map` */
		
	# First we need to delete all the records that where created as part of the BZFE blank installation
		DELETE FROM `group_group_map` WHERE `member_id` =1 AND `grantor_id` =19;
		DELETE FROM `group_group_map` WHERE `member_id` =1 AND `grantor_id` =20;
		DELETE FROM `group_group_map` WHERE `member_id` =1 AND `grantor_id` =21;
		DELETE FROM `group_group_map` WHERE `member_id` =1 AND `grantor_id` =22;
		DELETE FROM `group_group_map` WHERE `member_id` =1 AND `grantor_id` =23;
		DELETE FROM `group_group_map` WHERE `member_id` =1 AND `grantor_id` =24;
		DELETE FROM `group_group_map` WHERE `member_id` =1 AND `grantor_id` =25;
		DELETE FROM `group_group_map` WHERE `member_id` =1 AND `grantor_id` =26;
		DELETE FROM `group_group_map` WHERE `member_id` =1 AND `grantor_id` =27;
		DELETE FROM `group_group_map` WHERE `member_id` =1 AND `grantor_id` =28;
		DELETE FROM `group_group_map` WHERE `member_id` =1 AND `grantor_id` =29;
		DELETE FROM `group_group_map` WHERE `member_id` =1 AND `grantor_id` =30;
		DELETE FROM `group_group_map` WHERE `member_id` =1 AND `grantor_id` =31;
		DELETE FROM `group_group_map` WHERE `member_id` =31 AND `grantor_id` =16;
		DELETE FROM `group_group_map` WHERE `member_id` =31 AND `grantor_id` =17;
		DELETE FROM `group_group_map` WHERE `member_id` =31 AND `grantor_id` =18;
		DELETE FROM `group_group_map` WHERE `member_id` =31 AND `grantor_id` =19;
		DELETE FROM `group_group_map` WHERE `member_id` =31 AND `grantor_id` =20;
		DELETE FROM `group_group_map` WHERE `member_id` =31 AND `grantor_id` =21;
		DELETE FROM `group_group_map` WHERE `member_id` =31 AND `grantor_id` =22;
		DELETE FROM `group_group_map` WHERE `member_id` =31 AND `grantor_id` =23;
		DELETE FROM `group_group_map` WHERE `member_id` =31 AND `grantor_id` =24;
		DELETE FROM `group_group_map` WHERE `member_id` =31 AND `grantor_id` =25;
		DELETE FROM `group_group_map` WHERE `member_id` =31 AND `grantor_id` =26;
		DELETE FROM `group_group_map` WHERE `member_id` =31 AND `grantor_id` =27;
		DELETE FROM `group_group_map` WHERE `member_id` =31 AND `grantor_id` =28;
		DELETE FROM `group_group_map` WHERE `member_id` =31 AND `grantor_id` =29;
		DELETE FROM `group_group_map` WHERE `member_id` =31 AND `grantor_id` =30;
	
	# We can then create all the things we need! 
	# This is where we grant SOME (and DEFINITELY not all) of the privileges in the BZFE
	# These privileges are 
	# If you are a member of group_id XXX (ex: 1 / Admin) 
	# then you have the following permissions:
	# 	- 0: You are automatically a member of group ZZZ
	#	- 1: You can grant access to group ZZZ
	#	- 2: You can see users in group ZZZ
	#  
		INSERT  INTO `group_group_map`
			(`member_id`
			,`grantor_id`
			,`grant_type`
			) 
			VALUES 
			# There is A LOT of comment here as the permission logic is complex
			# this is because it is super flexible (a very good thing!!!)
			# Methodology:
			# We list all the possible options here and comment these out if they are not needed
			# this will make it MUCH easier to debug and we can expose the reasoning behind each entry...

			# First we look at the admin group

				# Privilege #0:
				# All the users in the Group XXX are automatically a member of group YYY
				# The group 1 `Admin` has privilege #0 for the group:
					# The Creator Group it can do everyting in all products
# This is NOT needed once we are in production
						#(1,@unit_creator_group_id,0),
					# Permission to create/see a case in the unit
						(1,@create_case_group_id,0),
					# Groups to hide different roles
# This is NOT needed once we are in production
						#(1,@show_to_stakeholder_1_group_id,0),
						#(1,@show_to_stakeholder_2_group_id,0),
						#(1,@show_to_stakeholder_3_group_id,0),
						#(1,@show_to_stakeholder_4_group_id,0),
						#(1,@show_to_stakeholder_5_group_id,0),
						#(1,@show_to_occupants_group_id,0),
					# Groups to make user visible to other
# This is NOT needed once we are in production
						#(1,@are_users_stakeholder_1_group_id,0),
						#(1,@are_users_stakeholder_2_group_id,0),
						#(1,@are_users_stakeholder_3_group_id,0),
						#(1,@are_users_stakeholder_4_group_id,0),
						#(1,@are_users_stakeholder_5_group_id,0),
						#(1,@are_occupants_group_id,0),

					# Is in the list of all the user that are visible in the drop down list for this product
# This is NOT needed once we are in production
						#(1,@list_visible_assignees_group_id,0),
					# You can see all the users visible for this product (not the hidden one).
# This is NOT needed once we are in production
						(1,@see_visible_assignees_group_id,0),
					# All the Flags groups for this product
					# Admin do NOT need to be in these groups:
					# This will make user in the Admin group visible in the list of flag approvers!
					# This is tricky as we are bunching up all the users in these group in the Stakeholder group anyway:
					# As of today no user is directly a member of any of these groups
# This is NOT needed once we are in production
#						(1,@r_group_next_step,0),
#						(1,@g_group_next_step,0),
#						(1,@g_group_solution,0),
#						(1,@r_group_budget,0),
#						(1,@g_group_budget,0),
#						(1,@r_group_attachment,0),
#						(1,@g_group_attachment,0),
#						(1,@r_group_OK_to_pay,0),
#						(1,@g_group_OK_to_pay,0),
#						(1,@r_group_is_paid,0),
#						(1,@g_group_is_paid,0),
					# Next is a group for all the USERS who can approve/reject a flag 
# This is NOT needed once we are in production
#						(1,@all_g_flags_group_id,0),
					# Next is a group for all the USERS who are allowed to be asked for flag approval
					# this allows us to display the correct list of users in the drop down list next to a flag
# This is NOT needed once we are in production
#						(1,@all_r_flags_group_id,0),
#
#					# Advanced permission groups
#						(1,@can_edit_case_group_id,0),
#						(1,@can_edit_all_field_case_group_id,0),
#						(1,@can_edit_component_group_id,0),
#						(1,@can_see_cases_group_id,0),
					
				# Privilege #1:
				# All the users in the Group XXX can grant access so that a user can be put in group YYY
				# The group 1 `Admin` has Permission #1 for all the groups:
					# Can decided if a user is a creator of a unit
#						(1,@unit_creator_group_id,1),
					# Decides if a user is a member of a specific role or not.
#						(1,@create_case_group_id,1),

					# Groups to hide different roles
#						(1,@show_to_stakeholder_1_group_id,1),
#						(1,@show_to_stakeholder_2_group_id,1),
#						(1,@show_to_stakeholder_3_group_id,1),
#						(1,@show_to_stakeholder_4_group_id,1),
#						(1,@show_to_stakeholder_5_group_id,1),
#						(1,@show_to_occupants_group_id,1),
					# Groups to make user visible to other
#						(1,@are_users_stakeholder_1_group_id,1),
#						(1,@are_users_stakeholder_2_group_id,1),
#						(1,@are_users_stakeholder_3_group_id,1),
#						(1,@are_users_stakeholder_4_group_id,1),
#						(1,@are_users_stakeholder_5_group_id,1),
#						(1,@are_occupants_group_id,1),

					# Decide if a user is visible in the drop down list for this product
#						(1,@list_visible_assignees_group_id,1),
						
					# Decide if users can see the list of visible users(not the hidden one) or not.
#						(1,@see_visible_assignees_group_id,1),
						
					# Decide if a user can set Flags or not for this product
					# This is tricky as we are bunching up all the users in these group in the Stakeholder group anyway:
					# As of today no user is directly a member of any of these groups
					# We keep this anyway for Admin just in case...
#						(1,@r_group_next_step,1),
#						(1,@g_group_next_step,1),
#						(1,@r_group_solution,1),
#						(1,@g_group_solution,1),
#						(1,@r_group_budget,1),
#						(1,@g_group_budget,1),
#						(1,@r_group_attachment,1),
#						(1,@g_group_attachment,1),
#						(1,@r_group_OK_to_pay,1),
#						(1,@g_group_OK_to_pay,1),
#						(1,@r_group_is_paid,1),
#						(1,@g_group_is_paid,1),
					# Decide if a user can approve all the flags
#						(1,@all_g_flags_group_id,1),
					# Decide if a user can be asked for approval for all flags
#						(1,@all_r_flags_group_id,1),
#
#					# Advanced permission groups
#						(1,@can_edit_case_group_id,1),
#						(1,@can_edit_all_field_case_group_id,1),
#						(1,@can_edit_component_group_id,1),
#						(1,@can_see_cases_group_id,1),

				# Privilege #2: 
				# All the users in the Group XXX can see the users in the group YYY
				# The group 1 `Admin` has Permission #2 to:
					# See all the users that are creators
# This is NOT needed once we are in production
					# N/A this is not the biggest list.
#						(1,@unit_creator_group_id,2),
					# See all user that have the role @stakeholder in the unit
						# This is the biggest list of users: it should list ALL users with a role on this unit.
# This is NOT needed once we are in production
#						(1,@create_case_group_id,2),

					# Groups to hide different roles
# This is NOT needed once we are in production
#						(1,@show_to_stakeholder_1_group_id,2),
#						(1,@show_to_stakeholder_2_group_id,2),
#						(1,@show_to_stakeholder_3_group_id,2),
#						(1,@show_to_stakeholder_4_group_id,2),
#						(1,@show_to_stakeholder_5_group_id,2),
#						(1,@show_to_occupants_group_id,2),
					# Groups to make user visible to other
# This is NOT needed once we are in production
#						(1,@are_users_stakeholder_1_group_id,2),
#						(1,@are_users_stakeholder_2_group_id,2),
#						(1,@are_users_stakeholder_3_group_id,2),
#						(1,@are_users_stakeholder_4_group_id,2),
#						(1,@are_users_stakeholder_5_group_id,2),
#						(1,@are_occupants_group_id,2),

						
					# See all the users that are visible in the drop down list for this product
# This is NOT needed once we are in production
#						(1,@list_visible_assignees_group_id,2),
					# See the list of user that can see the list of visible users for this product (not the hidden one).
# This is NOT needed once we are in production
#						#(1,@see_visible_assignees_group_id,2),

					# See all the users related to flags for this product
# This is NOT needed once we are in production
						# List of requestee
							# The individual flags
#								(1,@r_group_next_step,2),
#								(1,@r_group_solution,2),
#								(1,@r_group_budget,2),
#								(1,@r_group_attachment,2),
#								(1,@r_group_OK_to_pay,2),
#								(1,@r_group_is_paid,2),
							# The aggregated flags (this is technically overkill: we have granted the same jus with individual flags anyway...)
#								(1,@all_r_flags_group_id,2),
								
						# List of grantor
# This is NOT needed once we are in production
						# Not needed
							# The individual flags
#								(1,@g_group_next_step,2),
#								(1,@g_group_solution,2),
#								(1,@g_group_budget,2),
#								(1,@g_group_attachment,2),
#								(1,@g_group_OK_to_pay,2),
#								(1,@g_group_is_paid,2),
							# The aggregated flags (this is technically overkill: we have granted the same jus with individual flags anyway...)
#								(1,@all_g_flags_group_id,2),
#
#					# Advanced permission groups
#						(1,@can_edit_case_group_id,2),
#						(1,@can_edit_all_field_case_group_id,2),
#						(1,@can_edit_component_group_id,2),
#						(1,@can_see_cases_group_id,2),

			# We then look at the group @unit_creator_group_id
					
				# Privilege #0:
				# All the users in the Group XXX are automatically a member of group YYY
					# The group has privilege #0 for the NONE of the groups:
					# Irrelevant - we do this at the user level - doing this at the group level is dangerous
					
				# Privilege #1:
				# All the users in the Group unit_creator_group_id can grant access so that a user can be put in group YYY
				# The group @unit_creator_group_id has Permission #1 for:
					# Irrelevant - we do this at the user level - doing this at the group level is dangerous

				# Privilege #2: 
				# All the users in the Group @unit_creator_group_id can see the users in the group YYY
				# The group @unit_creator_group_id has Permission #2 to:
					# See all the users that are in this group creators
						# creators can see themselves.
						# this is the only privilege for this group.
						# we do the rest at the user level in the table `user_group_map`
							(@unit_creator_group_id,@unit_creator_group_id,2),

			# We then look at the group @create_case_group_id
			# This is a group to 
			#	- allow access to a product/unit

				# Privilege #0:
				# All the users in the Group @create_case_group_id are automatically a member of group YYY
				# The group has privilege #0 for the NONE of the groups:
					# Irrelevant - we do this at the user level - doing this at the group level is dangerous

				# Privilege #1:
				# All the users in the Group XXX can grant access so that a user can be put in group YYY
				# The group @create_case_group_id has Permission #1 for:
					# Irrelevant - we do this at the user level - doing this at the group level is dangerous

				# Privilege #2: 
				# All the users in the Group @create_case_group_id can see the users in the group YYY
				# The group @create_case_group_id has Permission #2 to see the list of people that you can
				# request approval for a flag from (requestees):
					(@create_case_group_id,@r_group_next_step,2),
					(@create_case_group_id,@r_group_solution,2),
					(@create_case_group_id,@r_group_budget,2),
					(@create_case_group_id,@r_group_attachment,2),
					(@create_case_group_id,@r_group_OK_to_pay,2),
					(@create_case_group_id,@r_group_is_paid,2),		

			# We then look at the group @can_edit_case_group_id
			# This is a group to 
			#	- allow access to a product/unit

				# Privilege #0:
				# All the users in the Group @can_edit_case_group_id are automatically a member of group YYY
				# The group has privilege #0 for the NONE of the groups:
					# Irrelevant - we do this at the user level - doing this at the group level is dangerous

				# Privilege #1:
				# All the users in the Group XXX can grant access so that a user can be put in group YYY
				# The group @can_edit_case_group_id has Permission #1 for:
					# Irrelevant - we do this at the user level - doing this at the group level is dangerous

				# Privilege #2: 
				# All the users in the Group @can_edit_case_group_id can see the users in the group YYY
				# The group @can_edit_case_group_id has Permission #2 to see the list of people that you can
				# request approval for a flag from (requestees):
					(@can_edit_case_group_id,@r_group_next_step,2),
					(@can_edit_case_group_id,@r_group_solution,2),
					(@can_edit_case_group_id,@r_group_budget,2),
					(@can_edit_case_group_id,@r_group_attachment,2),
					(@can_edit_case_group_id,@r_group_OK_to_pay,2),
					(@can_edit_case_group_id,@r_group_is_paid,2),		
					
			# We then look at the group @can_edit_all_field_case_group_id
			# This is a group to 
			#	- allow access to a product/unit

				# Privilege #0:
				# All the users in the Group @can_edit_all_field_case_group_id are automatically a member of group YYY
				# The group has privilege #0 for the NONE of the groups:
					# Irrelevant - we do this at the user level - doing this at the group level is dangerous

				# Privilege #1:
				# All the users in the Group XXX can grant access so that a user can be put in group YYY
				# The group @can_edit_all_field_case_group_id has Permission #1 for:
					# Irrelevant - we do this at the user level - doing this at the group level is dangerous

				# Privilege #2: 
				# All the users in the Group @can_edit_all_field_case_group_id can see the users in the group YYY
				# The group @can_edit_all_field_case_group_id has Permission #2 to see the list of people that you can
				# request approval for a flag from (requestees):
					(@can_edit_all_field_case_group_id,@r_group_next_step,2),
					(@can_edit_all_field_case_group_id,@r_group_solution,2),
					(@can_edit_all_field_case_group_id,@r_group_budget,2),
					(@can_edit_all_field_case_group_id,@r_group_attachment,2),
					(@can_edit_all_field_case_group_id,@r_group_OK_to_pay,2),
					(@can_edit_all_field_case_group_id,@r_group_is_paid,2),				
					
			# We then look at the group @can_edit_component_group_id
			# This is a group to 
			#	- allow access to a product/unit

				# Privilege #0:
				# All the users in the Group @can_edit_component_group_id are automatically a member of group YYY
				# The group has privilege #0 for the NONE of the groups:
					# Irrelevant - we do this at the user level - doing this at the group level is dangerous

				# Privilege #1:
				# All the users in the Group XXX can grant access so that a user can be put in group YYY
				# The group @can_edit_component_group_id has Permission #1 for:
					# Irrelevant - we do this at the user level - doing this at the group level is dangerous

				# Privilege #2: 
				# All the users in the Group @can_edit_component_group_id can see the users in the group YYY
				# The group @can_edit_component_group_id has Permission #2 to:
					# Irrelevant - we do this at the user level - doing this at the group level is dangerous
					
			# We then look at the group @can_see_cases_group_id
			# This is a group to 
			#	- allow access to an individual case in a product/unit

				# Privilege #0:
				# All the users in the Group @can_edit_component_group_id are automatically a member of group YYY
				# The group has privilege #0 for the NONE of the groups:
					# Irrelevant - we do this at the user level - doing this at the group level is dangerous

				# Privilege #1:
				# All the users in the Group XXX can grant access so that a user can be put in group YYY
				# The group @can_edit_component_group_id has Permission #1 for:
					# Irrelevant - we do this at the user level - doing this at the group level is dangerous

				# Privilege #2: 
				# All the users in the Group @can_edit_component_group_id can see the users in the group YYY
				# The group @can_edit_component_group_id has Permission #2 to:
					# Irrelevant - we do this at the user level - doing this at the group level is dangerous

			# We then look at the groups @are_users_stakeholder_n_group_id (and occupants)
				# Privilege #0:
				# All the users in the Group @are_users_stakeholder_n_group_id are automatically a member of group YYY
				# The group has privilege #0 for the NONE of the groups:
					# Irrelevant - we do this at the user level - doing this at the group level is dangerous

				# Privilege #1:
				# All the users in the Group XXX can grant access so that a user can be put in group YYY
				# The group @are_users_stakeholder_n_group_id has Permission #1 for:
					# Irrelevant - we do this at the user level - doing this at the group level is dangerous

				# Privilege #2: 
				# All the users in the Group @are_users_stakeholder_n_group_id can see the users in the group YYY
				# The group @are_users_stakeholder_n_group_id has Permission #2 to:
						# this is the only privilege for this group.
						# we do the rest at the user level in the table `user_group_map`
						(@are_users_stakeholder_1_group_id,@are_users_stakeholder_1_group_id,2),
						(@are_users_stakeholder_2_group_id,@are_users_stakeholder_2_group_id,2),
						(@are_users_stakeholder_3_group_id,@are_users_stakeholder_3_group_id,2),
						(@are_users_stakeholder_4_group_id,@are_users_stakeholder_4_group_id,2),
						(@are_users_stakeholder_5_group_id,@are_users_stakeholder_5_group_id,2),
						(@are_occupants_group_id,@are_occupants_group_id,2),
			
			# We then look at the groups @show_to_stakeholder_n_group_id (and occupants)
				# Privilege #0:
				# All the users in the Group @show_to_stakeholder_n_group_id are automatically a member of group YYY
				# The group has privilege #0 for the NONE of the groups:
					# Irrelevant - we do this at the user level - doing this at the group level is dangerous

				# Privilege #1:
				# All the users in the Group XXX can grant access so that a user can be put in group YYY
				# The group @show_to_stakeholder_n_group_id has Permission #1 for:
					# Irrelevant - we do this at the user level - doing this at the group level is dangerous

				# Privilege #2: 
				# All the users in the Group @show_to_stakeholder_n_group_id can see the users in the group YYY
				# The group @show_to_stakeholder_n_group_id has Permission #2 to:
					# Irrelevant - we do this at the user level - doing this at the group level is dangerous
						# we do the rest at the user level in the table `user_group_map`
						#(@show_to_stakeholder_1_group_id,@are_users_stakeholder_1_group_id,2),
						#(@show_to_stakeholder_2_group_id,@are_users_stakeholder_2_group_id,2),
						#(@show_to_stakeholder_3_group_id,@are_users_stakeholder_3_group_id,2),
						#(@show_to_stakeholder_4_group_id,@are_users_stakeholder_4_group_id,2),
						#(@show_to_stakeholder_5_group_id,@are_users_stakeholder_5_group_id,2),
						#(@show_to_occupants_group_id,@show_to_occupants_group_id,2),

			# We then look at the group @list_visible_assignees_group_id
				# Privilege #0:
				# All the users in the Group @show_to_stakeholder_n_group_id are automatically a member of group YYY
				# The group has privilege #0 for the NONE of the groups:
					# Irrelevant - we do this at the user level - doing this at the group level is dangerous

				# Privilege #1:
				# All the users in the Group XXX can grant access so that a user can be put in group YYY
				# The group @show_to_stakeholder_n_group_id has Permission #1 for:
					# Irrelevant - we do this at the user level - doing this at the group level is dangerous

				# Privilege #2: 
				# All the users in the Group @list_visible_assignees_group_id can see the users in the group YYY
				# The group @list_visible_assignees_group_id has Permission #2 to:
					# Irrelevant - we do this at the user level - doing this at the group level is dangerous
						
			# We then look at the group @see_visible_assignees_group_id
				# Privilege #0:
				# All the users in the Group @show_to_stakeholder_n_group_id are automatically a member of group YYY
				# The group has privilege #0 for the NONE of the groups:
					# Irrelevant - we do this at the user level - doing this at the group level is dangerous

				# Privilege #1:
				# All the users in the Group XXX can grant access so that a user can be put in group YYY
				# The group @show_to_stakeholder_n_group_id has Permission #1 for:
					# Irrelevant - we do this at the user level - doing this at the group level is dangerous

				# Privilege #2: 
				# All the users in the Group @see_visible_assignees_group_id can see the users in the group YYY
				# The group @see_visible_assignees_group_id has Permission #2 to:
				# 	See all the users in the list of visible user for this product
				# 	This is is the ONLY reason why this group exists...
				# 		user in this group will be able to
				#  		1- see list of visible user
				#  		2- still be hidden from other users (scenario with generic users)
					(@see_visible_assignees_group_id,@list_visible_assignees_group_id,2),

			# We move to the flags group:
				# Privilege #0:
				# All the users in the Group XXX are automatically a member of group YYY
				# The group has privilege #0 for the NONE of the groups:
					# This is only relevant for the following groups 
					# All the g flags
						(@all_g_flags_group_id,@g_group_next_step,0),
						(@all_g_flags_group_id,@g_group_solution,0),
						(@all_g_flags_group_id,@g_group_budget,0),
						(@all_g_flags_group_id,@g_group_attachment,0),
						(@all_g_flags_group_id,@g_group_OK_to_pay,0),
						(@all_g_flags_group_id,@g_group_is_paid,0),


					#	All the r flags
						(@all_r_flags_group_id,@r_group_next_step,0),
						(@all_r_flags_group_id,@r_group_solution,0),
						(@all_r_flags_group_id,@r_group_budget,0),
						(@all_r_flags_group_id,@r_group_attachment,0),
						(@all_r_flags_group_id,@r_group_OK_to_pay,0),
						(@all_r_flags_group_id,@r_group_is_paid,0),

				# Privilege #1:
				# All the users in the Group XXX can grant access so that a user can be put in group YYY
				# The following flag groups have Permission #1 for:
					# This is only relevant for the following groups 
					# @all_g_flags_group_id
						(@all_g_flags_group_id,@g_group_next_step,1),
						(@all_g_flags_group_id,@g_group_solution,1),
						(@all_g_flags_group_id,@g_group_budget,1),
						(@all_g_flags_group_id,@g_group_attachment,1),
						(@all_g_flags_group_id,@g_group_OK_to_pay,1),
						(@all_g_flags_group_id,@g_group_is_paid,1),


					#	@all_r_flags_group_id
						(@all_r_flags_group_id,@r_group_next_step,1),
						(@all_r_flags_group_id,@r_group_solution,1),
						(@all_r_flags_group_id,@r_group_budget,1),
						(@all_r_flags_group_id,@r_group_attachment,1),
						(@all_r_flags_group_id,@r_group_OK_to_pay,1),
						(@all_r_flags_group_id,@r_group_is_paid,1);

				# Privilege #2: 
				# All the users in the Group XXX can see the users in the group YYY
				# The group XXX has Permission #2 to:
					# NO GROUPS
					# We do this at the user level in the table `user_group_map` - doing this at the group level is dangerous
					# Permissions to be in these group are granted to other groups:
					# Pemission to see these groups are granted to other groups:
					# 		i.e groups that allow to add or modify creators or stakeholders.
					


		/*Data for the table `group_control_map` */
			# This is where we decide who can access which products or see which list of users.
			INSERT  INTO `group_control_map`
				(`group_id`
				,`product_id`
				,`entry`
				# Next is Membercontrol 
				# it refers to the access rights and permissions for a product/unit...
				# 0 is NA
				# 1 is SHOWN
				# 2 is DEFAULT
				# 3 is MANDATORY
				,`membercontrol`
				# Next is othercontrol 
				# it refers to the access rights and permission  for a product/unittoo...
				# 0 is NA
				# 1 is SHOWN
				# 2 is DEFAULT
				# 3 is MANDATORY
				,`othercontrol`
				,`canedit`
				,`editcomponents`
				,`editbugs`
				,`canconfirm`
				) 
				VALUES 
######################################
# NEED TO TEST IN THE BZ BACK END
# NEED TO TEST WITH API TOO
######################################
				#
				# the permission we can use are
				# 0, 0: Cases in this product are never associated with this group. 
				#	Irrelevant for us...
				#
				# We do NOT want 1,0:
				#		- Does NOT Create a record in the bug_group_map each time a bug/case is created
				#		- By default SHOW all the bugs UNLESS specifically requested to hide.
				#			This is a pb because a search would display bug/cases for a stakholder 
				#			that have NOT been specifically authorized to be shown..
				#		- Allow member of the correct groups to HIDE a case if needed
				# 1, 0: Cases in this product are permitted to be restricted to this group. 
				#		Users who are members of this group will be able to place cases in this group. 
				#	- This does NOT create a new record in the table `bug_group_map` each time a bug is created
				# 	- This SHOWS the 'Visibility' tick boxes in the BZ interface!
				#	- By Default the 'Visibility' tick boxes in the BZ interface is set to 0 (FALSE)!
				# 	- the 'Visibility' tick boxes in the BZ interface CAN be changed by user ONLY if the user IS in this group
				#
				# We do NOT want 1, 1:
				#	This would create a scenario where a user would exclude himself from this groups
				#	and hence prevent himself to see this case ever again.
				# 1, 1: Cases in this product can be placed in this group by anyone with permission to edit the case 
				#		even if they are not a member of this group.
				#	- This does NOT create a new record in the table `bug_group_map` each time a bug is created
				# 	- This SHOWS the 'Visibility' tick boxes in the BZ interface!
				#	- By Default the 'Visibility' tick boxes in the BZ interface is set to 0 (FALSE)!
				#	- the 'Visibility' tick boxes in the BZ interface CAN be changed by user even if user is NOT in this group
				#
				# We do NOT want 1, 2 :
				# 	This would be similar to 1, 1: a user could exclude himself from this groups
				#	and hence prevent himself to see this case ever again.
				#1, 2: Cases in this product can be placed in this group by anyone with permission to edit the case 
				#		even if they are not a member of this group. 
				#		Non-members place cases in this group by default.
				#	- This DOES CREATE a new record in the table `bug_group_map` each time a bug is created
				# 	- This SHOWS the 'Visibility' tick boxes in the BZ interface!
				#	- By Default the 'Visibility' tick boxes in the BZ interface is set to 1 (TRUE)
				#	- the 'Visibility' tick boxes in the BZ interface CAN be changed by user even if user is NOT in this group
				#
				# We do NOT WANT 1, 3 :
				# 	This would be similar to 1, 0 BUT this would 
				#		- Create a record in the bug_group_map each time a bug/case is created
				#		- By default Shows all the bugs UNLESS specifically requested to hide.
				#			This is necessary or else a search would display bug/cases that have NOT been specifically authorized to be shown
				#		- Allow member of the correct groups to SHOW a case if needed
				# 1, 3: Cases in this product are permitted to be restricted to this group. 
				#		Users who are members of this group will be able to place cases in this group. 
				#		Non-members will be forced to restrict cases to this group when they initially enter a case in this product. 
				#	- This DOES CREATE a new record in the table `bug_group_map` each time a bug is created
				# 	- This SHOWS the 'Visibility' tick boxes in the BZ interface!
				#	- By Default the 'Visibility' tick boxes in the BZ interface is set to 0 (FALSE)
				#	- the 'Visibility' tick boxes in the BZ interface can NOT be changed unless you are in this group
				#
				# We do NOT want 2, 0 :
				# 	This would be similar to 1, 0 BUT this would 
				#		- Create a record in the bug_group_map each time a bug/case is created
				#		- By default HIDE all the bugs UNLESS specifically requested to show.
				# 2, 0: Cases in this product are permitted to be restricted to this group 
				#		Cases are placed in this group by default. 
				#		Users who are members of this group will be able to place cases in this group. 
				#	- This DOES CREATE a new record in the table `bug_group_map` each time a bug is created
				# 	- This SHOWS the 'Visibility' tick boxes in the BZ interface!
				#	- By Default the 'Visibility' tick boxes in the BZ interface is set to 1 (TRUE)
				# 	- the 'Visibility' tick boxes in the BZ interface can NOT be changed unless you are in this group
				#
				# We do NOT want 2, 1 :
				# 	This would
				#		- Create a record in the bug_group_map each time a bug/case is created
				#		- By default HIDE all the bugs UNLESS specifically requested to show.
				#		- Create a sceario where a user could exclude himself from this groups
				#			and hence prevent himself to see this case ever again.
				# 2, 1 : Cases in this product are permitted to be restricted to this group
				#		 Cases are placed in this group by default. 
				#		Users who are members of this group will be able to place cases in this group. 
				#		Non-members will be able to restrict cases to this group on entry and will do so by default. 
				#	- This DOES CREATE a new record in the table `bug_group_map` each time a bug is created
				# 	- This SHOWS the 'Visibility' tick boxes in the BZ interface!
				#	- By Default the 'Visibility' tick boxes in the BZ interface is set to 1 (TRUE)
				# 	- the 'Visibility' tick boxes in the BZ interface CAN be changed by user even if user is NOT in this group
				#
#######################################
#
# This still does NOT work as intended if we use 3,3 for create_case_group_id:
# This still does NOT work as intended if we use 2,3 for create_case_group_id:
#	Test:
#		1- Create a case as administrator
#			Make sure agent is not the assignee
#		2- Untick visibility for Agent
#		3- Impersonate Leonel (Agent)
#		4- Check if this bug is visible for Leonel 
#			RESULT: FAIL: Leonel can still see this bug
#
#######################################
				
				# 2, 3 : Cases in this product are permitted to be restricted to this group 
				#		Cases are placed in this group by default. 
				#		Users who are members of this group will be able to place cases in this group. 
				#		Non-members will be forced to place cases in this group on entry. 
				#	- This DOES CREATE a new record in the table `bug_group_map` each time a bug is created
				# 	- This SHOWS the 'Visibility' tick boxes in the BZ interface!
				#	- By Default the 'Visibility' tick boxes in the BZ interface is set to 1 (TRUE)
				# 	- the 'Visibility' tick boxes in the BZ interface can NOT be changed unless you are in this group
				#
				# We do NOT want 3, 3 :
				#	This will make the case always visible to everyone...
				# 3, 3 : Cases in this product are required to be restricted to this group. 
				#		Users are not given any option.
				#	- This DOES CREATE a new record in the table `bug_group_map` each time a bug is created
				#	- By Default the 'Visibility' tick boxes in the BZ interface is set to 1 (TRUE)
				# 	- This HIDES the 'Visibility' tick boxes in the BZ interface!
				#
				# This table is relevant ONLY for the groups that are active for bugs/cases:
				#	- @create_case_group_id
				#	- @show_to_stakeholder_1_group_id
				#	- @show_to_stakeholder_2_group_id
				#	- @show_to_stakeholder_3_group_id
				#	- @show_to_stakeholder_4_group_id
				#	- @show_to_stakeholder_5_group_id
				#	- @show_to_occupants_group_id
				
				# The group that allow a user to create cases for a product/unit
				# Editbugs is necessary so we can do what we need.
					(@create_case_group_id,@product_id,1,0,0,0,0,0,0),
					(@can_edit_case_group_id,@product_id,1,0,0,1,0,0,1),
					(@can_edit_all_field_case_group_id,@product_id,1,0,0,1,0,1,1),
					(@can_edit_component_group_id,@product_id,0,0,0,0,1,0,0),

				# The group to hide cases from some stakeholders
				
				# editcomponents is needed so that the user can create add new users in this product
					(@can_see_cases_group_id,@product_id,0,2,0,0,0,0,0),
					(@show_to_stakeholder_1_group_id,@product_id,0,1,1,0,0,0,0),
					(@show_to_stakeholder_2_group_id,@product_id,0,1,1,0,0,0,0),
					(@show_to_stakeholder_3_group_id,@product_id,0,1,1,0,0,0,0),
					(@show_to_stakeholder_4_group_id,@product_id,0,1,1,0,0,0,0),
					(@show_to_stakeholder_5_group_id,@product_id,0,1,1,0,0,0,0),
					(@show_to_occupants_group_id,@product_id,0,1,1,0,0,0,0);
				#											
				
	/*Data for the table `user_group_map` */
	# The groups have been defined, we can now tell which group the BZ users needs access to.

	
##################################################################################
# WE NEED TO MAKE THIS A CONDITIONAL THING TO MAKE THIS SCRIPT MORE VERSATILE
#	- Is the user the creator of the unit?
#	- What is the role_type_id for that user?
#	- Is the user an occupant?
#	- Is this user publicly visible?
#	- Can this user see the publicly visible users?
#	- Can this user be asked to approved flags?
#	- Can this user approve flags?
#	- Is the user allowed to create more users?
#		- In the same group of Stakholder
#		- In ANY group of stakeholder
#		- Can decide who can be requestee and grant Flags
#		- Can decided who is visible in the list of assignee
#		- Can decided if a new user can see visible assignees
#		- 
#
# The consequences of the answers to these questions are:
#	- If user is the creator of the unit, we make him a member of:
#		- @unit_creator_group_id
#	- If user is in the role [n] then we make him a member of THE groups
#		- @are_users_stakeholder_[n]_group_id
#		- @show_to_stakeholder_[all but n]_group_id
# 	- If the user is an occupant then make him a member of
#		- @are_occupants_group_id
# 	- If the user is NOT an occupant then make him a member of
#		- @show_to_occupants_group_id
#	- If the user is publicly visible then make him a member of
#		- @list_visible_assignees_group_id
#	- If the user can see the publicly visible users then make him a member of
#		- @see_visible_assignees_group_id
#	- If the user can be asked to approved flags then make him a member of
#		- @r_group_next_step
#		- @r_group_solution
#		- @r_group_budget
#		- @r_group_attachment
#		- @r_group_OK_to_pay
#		- @r_group_is_paid
#		- @all_r_flags_group_id
#	- If the user is allowed to approve flags then make him a member of
#		- @g_group_next_step
#		- @g_group_solution
#		- @g_group_budget
#		- @g_group_attachment
#		- @g_group_OK_to_pay
#		- @g_group_is_paid
#		- @all_g_flags_group_id
#
# Creation of new users:
#	- If the user is allowed to create more users in ANY group of stakeholder 
#		then he is granted permissions to add users to
#		- @create_case_group_id
#		- @are_users_stakeholder_1_group_id
#		- @are_users_stakeholder_2_group_id
#		- @are_users_stakeholder_3_group_id
#		- @are_users_stakeholder_4_group_id
#		- @are_users_stakeholder_5_group_id
#		- @show_to_stakeholder_1_group_id
#		- @show_to_stakeholder_2_group_id
#		- @show_to_stakeholder_3_group_id
#		- @show_to_stakeholder_4_group_id
#		- @show_to_stakeholder_5_group_id
#		- @are_occupants_group_id
#		- @show_to_occupants_group_id
#
#	- If the user is allowed to create more users only in the same group of stakeholder [n] 
#		then he is granted permissions to add users to
#		- @create_case_group_id
#		- @are_users_stakeholder_[n]_group_id
#		- @show_to_stakeholder_[all but n]_group_id
#		- @are_occupants_group_id
#		- @show_to_occupants_group_id
#
#	- If the user can decided who is visible in the list of assignee
#		- @list_visible_assignees_group_id
#
#	- If the user can decided if a new user can see visible assignees
#		- @see_visible_assignees_group_id
#
#	- If the user can decide who can be requestee and grant Flags
#		- @r_group_next_step
#		- @r_group_solution
#		- @r_group_budget
#		- @r_group_attachment
#		- @r_group_OK_to_pay
#		- @r_group_is_paid
#		- @g_group_next_step
#		- @g_group_solution
#		- @g_group_budget
#		- @g_group_attachment
#		- @g_group_OK_to_pay
#		- @g_group_is_paid
#		- @all_r_flags_group_id
#		- @all_g_flags_group_id
#
##################################################################################

		INSERT  INTO `user_group_map`
			(`user_id`
			,`group_id`
			,`isbless`
			,`grant_type`
			) 
			VALUES 
			# The Administrator user can grant permission to all the groups!
				(1,@unit_creator_group_id,1,0),
				(1,@create_case_group_id,1,0),
				(1,@are_users_stakeholder_1_group_id,1,0),
				(1,@are_users_stakeholder_2_group_id,1,0),
				(1,@are_users_stakeholder_3_group_id,1,0),
				(1,@are_users_stakeholder_4_group_id,1,0),
				(1,@are_users_stakeholder_5_group_id,1,0),
				(1,@show_to_stakeholder_1_group_id,1,0),
				(1,@show_to_stakeholder_2_group_id,1,0),
				(1,@show_to_stakeholder_3_group_id,1,0),
				(1,@show_to_stakeholder_4_group_id,1,0),
				(1,@show_to_stakeholder_5_group_id,1,0),
				(1,@are_occupants_group_id,1,0),
				(1,@show_to_occupants_group_id,1,0),
				(1,@list_visible_assignees_group_id,1,0),
				(1,@see_visible_assignees_group_id,1,0),
				(1,@r_group_next_step,1,0),
				(1,@r_group_solution,1,0),
				(1,@r_group_budget,1,0),
				(1,@r_group_attachment,1,0),
				(1,@r_group_OK_to_pay,1,0),
				(1,@r_group_is_paid,1,0),
				(1,@g_group_next_step,1,0),
				(1,@g_group_solution,1,0),
				(1,@g_group_budget,1,0),
				(1,@g_group_attachment,1,0),
				(1,@g_group_OK_to_pay,1,0),
				(1,@g_group_is_paid,1,0),
				(1,@all_r_flags_group_id,1,0),
				(1,@all_g_flags_group_id,1,0),
				(1,@can_edit_case_group_id,1,0),
				(1,@can_edit_all_field_case_group_id,1,0),
				(1,@can_edit_component_group_id,1,0),
				(1,@can_see_cases_group_id,1,0),
			
			# Permission for the user we created:
				# Permission to GRANT Membership to the following groups
					# A user is the creator: this is true so he can add more users and stakholders there
						#(@bz_user_id,@unit_creator_group_id,1,0),
						
					# A user can create a case for this unit? This is true so he can add more users and stakholders there
					# For Leonel, we know he is allowed to
						(@bz_user_id,@create_case_group_id,1,0),
					
					# A user can see cases in the product.
					# For Leonel, we know he is allowed to
						(@bz_user_id,@can_see_cases_group_id,1,0),
					
					# A user can edit a case for that unit
					# For Leonel, we know he is allowed to
						(@bz_user_id,@can_edit_case_group_id,1,0),
					
					# A user can edit all filed in a case, regardless of its role
					# For Leonel, we know he is allowed to
					# This is because he is he unit creator
						(@bz_user_id,@can_edit_all_field_case_group_id,1,0),
					
					# A user can edit stakholder/component in the product.
					# For Leonel, we know he is allowed to
						(@bz_user_id,@can_edit_component_group_id,1,0),
						
					# A user is a stakeholder: This is true so he can add more users and stakholders there
					# For Leonel, we know he is allowed to
						(@bz_user_id,@are_users_stakeholder_1_group_id,1,0),
						(@bz_user_id,@are_users_stakeholder_2_group_id,1,0),
						(@bz_user_id,@are_users_stakeholder_3_group_id,1,0),
						(@bz_user_id,@are_users_stakeholder_4_group_id,1,0),
						(@bz_user_id,@are_users_stakeholder_5_group_id,1,0),
						(@bz_user_id,@show_to_stakeholder_1_group_id,1,0),
						(@bz_user_id,@show_to_stakeholder_2_group_id,1,0),
						(@bz_user_id,@show_to_stakeholder_3_group_id,1,0),
						(@bz_user_id,@show_to_stakeholder_4_group_id,1,0),
						(@bz_user_id,@show_to_stakeholder_5_group_id,1,0),
					
					# A user is an occupant: This is true so he can add more users and stakholders there
					# For Leonel, we know he is allowed to
						(@bz_user_id,@are_occupants_group_id,1,0),
						(@bz_user_id,@show_to_occupants_group_id,1,0),
					
					# A user is a visible assignee: This is true so he can add more users and stakholders there
					# For Leonel, we know he is allowed to
						(@bz_user_id,@list_visible_assignees_group_id,1,0),
						
					# A user can see visible assignees: This is true so he can add more users and stakholders there
					# For Leonel, we know he is allowed to
						(@bz_user_id,@see_visible_assignees_group_id,1,0),
					
					# A user can be asked to approve flags: This is true so he can add more users and stakholders there
					# For Leonel, we know he is allowed to
						(@bz_user_id,@r_group_next_step,1,0),
						(@bz_user_id,@r_group_solution,1,0),
						(@bz_user_id,@r_group_budget,1,0),
						(@bz_user_id,@r_group_attachment,1,0),
						(@bz_user_id,@r_group_OK_to_pay,1,0),
						(@bz_user_id,@r_group_is_paid,1,0),
						(@bz_user_id,@all_r_flags_group_id,1,0),
					
					# A user can approve flags: This is true so he can add more users and stakholders there
					# For Leonel, we know he is allowed to
						(@bz_user_id,@g_group_next_step,1,0),
						(@bz_user_id,@g_group_solution,1,0),
						(@bz_user_id,@g_group_budget,1,0),
						(@bz_user_id,@g_group_attachment,1,0),
						(@bz_user_id,@g_group_OK_to_pay,1,0),
						(@bz_user_id,@g_group_is_paid,1,0),
						(@bz_user_id,@all_g_flags_group_id,1,0),

				# User is a member of the following groups

					# Can he create a case for this unit?
					# All the new user can create...
						(@bz_user_id,@create_case_group_id,0,0),
					
					# User can see any case in the product.
					# By default, all users for this product/unit have this too
						(@bz_user_id,@can_see_cases_group_id,0,0),
						
					# User can edit a case for that unit
					# For Leonel, we know he is allowed to
						(@bz_user_id,@can_edit_case_group_id,0,0),
					
					# User can edit all filed in a case, regardless of its role
					# For Leonel, we know he is allowed to
					# This is because he is he unit creator
						(@bz_user_id,@can_edit_all_field_case_group_id,0,0),
					
					# User can edit stakholder/component in the product.
					# For Leonel, we know he is allowed to
						(@bz_user_id,@can_edit_component_group_id,0,0),
					
					# Is the user a creator of the unit?
					# For Leonel, we know he is
						(@bz_user_id,@unit_creator_group_id,0,0),
					
					# Group to show/hide cases to some stakeholders:
					# For Leonel, we know he is stakeholder 5
						(@bz_user_id,@are_users_stakeholder_1_group_id,0,0),
						#(@bz_user_id,@are_users_stakeholder_2_group_id,0,0),
						#(@bz_user_id,@are_users_stakeholder_3_group_id,0,0),
						#(@bz_user_id,@are_users_stakeholder_4_group_id,0,0),
						#(@bz_user_id,@are_users_stakeholder_5_group_id,0,0),
						
					# Group to show/hide cases to some stakeholders:
					# For Leonel, we know he is stakeholder 5
					# 
# This comment is most likely incorrect # But as the creator, he should be able to see all options
####
#	WE NEED TO REVIEW THIS AND USE THE GROUP UNIT CREATOR TO DO THAT...
###
						#(@bz_user_id,@show_to_stakeholder_1_group_id,0,0),
						#(@bz_user_id,@show_to_stakeholder_2_group_id,0,0),
						#(@bz_user_id,@show_to_stakeholder_3_group_id,0,0),
						#(@bz_user_id,@show_to_stakeholder_4_group_id,0,0),
						(@bz_user_id,@show_to_stakeholder_5_group_id,0,0),
					
					# Is he an occupant?
					# For Leonel, the answer is NO
						#(@bz_user_id,@are_occupants_group_id,0,0),
						
						#(@bz_user_id,@show_to_occupants_group_id,0,0),
					
					# Is he visible in the list of possible assignees?
					# For Leonel, the answer is YES
						(@bz_user_id,@list_visible_assignees_group_id,0,0),
						
					# Can he see all the other visible assigneed?
					# For Leonel, the answer is YES
						(@bz_user_id,@see_visible_assignees_group_id,0,0),
					
					# Flags: can he be asked to request?
					# For Leonel, the answer is YES
						(@bz_user_id,@r_group_next_step,0,0),
						(@bz_user_id,@r_group_solution,0,0),
						(@bz_user_id,@r_group_budget,0,0),
						(@bz_user_id,@r_group_attachment,0,0),
						(@bz_user_id,@r_group_OK_to_pay,0,0),
						(@bz_user_id,@r_group_is_paid,0,0),
						(@bz_user_id,@all_r_flags_group_id,0,0),

					# Flags: can he approve?
					# For Leonel, the answer is YES
						(@bz_user_id,@g_group_next_step,0,0),
						(@bz_user_id,@g_group_solution,0,0),
						(@bz_user_id,@g_group_budget,0,0),
						(@bz_user_id,@g_group_attachment,0,0),
						(@bz_user_id,@g_group_OK_to_pay,0,0),
						(@bz_user_id,@g_group_is_paid,0,0),
						(@bz_user_id,@all_g_flags_group_id,0,0);

	# We create and configure the generic flags we need.
		# First we remove the flags which have been created as part of the blank install
#################################################################################################################################
# DANGER because we use a hard coded value 7, the script will break if the list of groups we create in a blank BZFE changes...  #
#################################################################################################################################

		DELETE FROM `flagtypes` WHERE `id`<7;

		# get the id for the flagtypes we need
			SET @flag_next_step = 1;
			SET @flag_solution = (@flag_next_step+1);
			SET @flag_budget = (@flag_solution+1);
			SET @flag_attachment = (@flag_budget+1);
			SET @flag_ok_to_pay = (@flag_attachment+1);
			SET @flag_is_paid = (@flag_ok_to_pay+1);
	
		/*Data for the table `flagtypes` */
		# We re-create the flags we need.

			INSERT INTO `flagtypes`
				(`id`
				,`name`
				,`description`
				,`cc_list`
				,`target_type`
				,`is_active`
				,`is_requestable`
				,`is_requesteeble`
				,`is_multiplicable`
				,`sortkey`
				,`grant_group_id`
				,`request_group_id`
				) 
				VALUES 
				(@flag_next_step,CONCAT(@unit,'_#',@product_id,'_Next_Step'),'Approval for the Next Step of the case.','','b',1,1,1,1,10,@g_group_next_step,@r_group_next_step),
				(@flag_solution,CONCAT(@unit,'_#',@product_id,'_Solution'),'Approval for the Solution of this case.','','b',1,1,1,1,20,@g_group_solution,@r_group_solution),
				(@flag_budget,CONCAT(@unit,'_#',@product_id,'_Budget'),'Approval for the Budget for this case.','','b',1,1,1,1,30,@g_group_budget,@r_group_budget),
				(@flag_attachment,CONCAT(@unit,'_#',@product_id,'_Attachment'),'Approval for this Attachment.','','a',1,1,1,1,10,@g_group_attachment,@r_group_attachment),
				(@flag_ok_to_pay,CONCAT(@unit,'_#',@product_id,'_OK_to_pay'),'Approval to pay this bill.','','a',1,1,1,1,20,@g_group_OK_to_pay,@r_group_OK_to_pay),
				(@flag_is_paid,CONCAT(@unit,'_#',@product_id,'is_paid'),'Confirm if this bill has been paid.','','a',1,1,1,1,30,@g_group_is_paid,@r_group_is_paid);
		
		/*Data for the table `flaginclusions` */
		
		DELETE FROM `flaginclusions` WHERE `product_id` = @product_id;

		INSERT INTO `flaginclusions`
			(`type_id`
			,`product_id`
			,`component_id`
			) 
			VALUES
			(@flag_next_step,@product_id,NULL),
			(@flag_solution,@product_id,NULL),
			(@flag_budget,@product_id,NULL),
			(@flag_attachment,@product_id,NULL),
			(@flag_ok_to_pay,@product_id,NULL),
			(@flag_is_paid,@product_id,NULL);		

		/*Data for the table `series_categories` */
		# We need to truncate this table first
		TRUNCATE `series_categories`;
		INSERT  INTO `series_categories`
			(`id`
			,`name`
			) 
			VALUES 
			(1,CONCAT(@stakeholder,'_#',@product_id)),
			(2,'-All-'),
			(3,CONCAT(@unit,'_#',@product_id,'_U',@bz_user_id));

		# We need to know the value of the other series category we just created.
			SET @series_2 = 2;
			SET @series_1 = 1;
			SET @series_3 = 3;

		/*Data for the table `series` */
		# This is so that we can see historical data and how a case is evolving
		# This can only be done after the series categories have been created
	
		INSERT  INTO `series`
			(`series_id`
			,`creator`
			,`category`
			,`subcategory`
			,`name`
			,`frequency`
			,`query`
			,`is_public`
			) 
			VALUES 
			(NULL,@bz_user_id,@series_1,@series_2,'UNCONFIRMED',1,CONCAT('bug_status=UNCONFIRMED&product=',@unit_for_query),1),
			(NULL,@bz_user_id,@series_1,@series_2,'CONFIRMED',1,CONCAT('bug_status=CONFIRMED&product=',@unit_for_query),1),
			(NULL,@bz_user_id,@series_1,@series_2,'IN_PROGRESS',1,CONCAT('bug_status=IN_PROGRESS&product=',@unit_for_query),1),
			(NULL,@bz_user_id,@series_1,@series_2,'REOPENED',1,CONCAT('bug_status=REOPENED&product=',@unit_for_query),1),
			(NULL,@bz_user_id,@series_1,@series_2,'STAND BY',1,CONCAT('bug_status=STAND%20BY&product=',@unit_for_query),1),
			(NULL,@bz_user_id,@series_1,@series_2,'RESOLVED',1,CONCAT('bug_status=RESOLVED&product=',@unit_for_query),1),
			(NULL,@bz_user_id,@series_1,@series_2,'VERIFIED',1,CONCAT('bug_status=VERIFIED&product=',@unit_for_query),1),
			(NULL,@bz_user_id,@series_1,@series_2,'CLOSED',1,CONCAT('bug_status=CLOSED&product=',@unit_for_query),1),
			(NULL,@bz_user_id,@series_1,@series_2,'FIXED',1,CONCAT('resolution=FIXED&product=',@unit_for_query),1),
			(NULL,@bz_user_id,@series_1,@series_2,'INVAL`status_workflow`ID',1,CONCAT('resolution=INVAL%60status_workflow%60ID&product=',@unit_for_query),1),
			(NULL,@bz_user_id,@series_1,@series_2,'WONTFIX',1,CONCAT('resolution=WONTFIX&product=',@unit_for_query),1),
			(NULL,@bz_user_id,@series_1,@series_2,'DUPLICATE',1,CONCAT('resolution=DUPLICATE&product=',@unit_for_query),1),
			(NULL,@bz_user_id,@series_1,@series_2,'WORKSFORME',1,CONCAT('resolution=WORKSFORME&product=',@unit_for_query),1),
			(NULL,@bz_user_id,@series_1,@series_2,'All Open',1,CONCAT('bug_status=UNCONFIRMED&bug_status=CONFIRMED&bug_status=IN_PROGRESS&bug_status=REOPENED&bug_status=STAND%20BY&product=',@unit_for_query),1),
			(NULL,@bz_user_id,@series_1,@series_3,'All Open',1,CONCAT('field0-0-0=resolution&type0-0-0=notregexp&value0-0-0=.&product=',@unit_for_query,'&component=',@stakeholder),1),
			(NULL,@bz_user_id,@series_1,@series_3,'All Closed',1,CONCAT('field0-0-0=resolution&type0-0-0=regexp&value0-0-0=.&product=',@unit_for_query,'&component=',@stakeholder),1);

		/*Data for the table `audit_log` */
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
		(@bz_user_id,'Bugzilla::Group',@create_case_group_id,'__create__',NULL,CONCAT(@unit,' #',@product_id,' - ', @stakeholder),@timestamp);
		
	# We enable the FK check back
	SET FOREIGN_KEY_CHECKS = 1;


# We Create the Privileges for Marley
#   - Marley is the Landlord
#     His `id_role_type` in the table `ut_role_types` = 2

	# We do NOT need to create the unit here.
	# BUT We need to Make sure that the the component for this Unit is correct
	
	# We also want to show the publicly visible information for Marley.
		# His public name
			SET @stakeholder_pub_name = 'Marley';
		# More details
			SET @stakeholder_more = '647 456 7892';
		# Se we can create the public info too
			SET @stakeholder_pub_info = CONCAT(@stakeholder_pub_name,' - ', @stakeholder_more);
		
	# We Need the BZ user information for Marley
		SET @bz_user_id = 3;

	# User role: this is an id in the table `ut_role_types` for easier manipulation, update and maintenance
		SET @role_type_id = 2;

	# Is this user an occupant of the unit?
	#	- 1 = TRUE
	#	- 0 = FALSE
		SET @is_occupant = 0;

	# We Need the BZ user information for the creator of the new user too (Leonel)
		SET @user_creator_bz_user_id = 2;
			
		# His public name 
		# We have this as a variable in this script.
		# this should be stored somewhere in the MEFE
		# we do not need to recreate this in the context of the script to create DEMO users.
			# SET @user_creator_pub_name = 'GET creator_public_name FROM THE MEFE';
		# More details
			#SET @user_creator_more ='GET creator_more FROM THE MEFE';
		# Se we can create the public info too
			#SET @user_creator_pub_info = CONCAT(@user_creator_pub_name,' - ', @user_creator_more);

	# OPTIONAL INFORMATION:
	#
	# We need to know if this user can 
	#	- see all other user (1) 
	#		In this case this user will be a member of the group `@list_visible_assignees_group_id`
	#		for this product/unit.
	#	- see only the people in the same role/stakeholder group. (0)
	# 		Else this user will NOT be a member of the group `@list_visible_assignees_group_id`
	#		for this product/unit.
	# By Default, the user is visible to all other user.
		SET @user_is_public = 1; 
	#
	# We need to know if this user is 
	#	- visible to all other user (1) 
	#		In this case this user will be a member of the group `@see_visible_assignees_group_id`
	#		for this product/unit.
	#	- visible only to people in the same role/stakeholder group. (1)
	# 		Else this user will NOT be a member of the group `@see_visible_assignees_group_id`
	#		for this product/unit.
	# By Default, the user is visible to all other user.
		SET @user_can_see_public = 1; 

	#
	# By default the new user can approve all flags but we want flexibility there 
	# We know this might not be always true for all BZ user we create
		SET @can_be_asked_to_approve = 1;

	# By default the new user can approve all flags but we want flexibility there 
	# We know this might not be always true for all BZ user we create
		SET @can_approve = 1;
	#
	# Is the user allowed to create new users?
		# only in the same group of stakholders
			SET @can_create_same_stakeholder = 1;
		
		# in ANY group of stakeholders
			SET @can_create_any_stakeholder = 0;
	
	# Is this user allowed to decided who can be requestee and grant Flags?
		SET @can_approve_user_for_flag = 1;
		
	# Is this user is allowed to decided who is visible in the list of assignee?
		SET @can_decide_if_user_is_visible = 1;
		
	# Is this user is allowed to decided if a new user can see visible assignees?
		SET @can_decide_if_user_can_see_visible = 1;

	# We have everything - Onward for Marley!
	
		# We DISABLE the FK check
			SET FOREIGN_KEY_CHECKS = 0;
	
		# Get the additional variable that we need
			# When is this happening?
				SET @timestamp = NOW();

			# We get the login name from the user_id
				SET @login_name = (SELECT `login_name` FROM `profiles` WHERE `userid`=@bz_user_id);
				SET @user_creator_login_name = (SELECT `login_name` FROM `profiles` WHERE `userid`=@user_creator_bz_user_id);

			# We get the Stakeholder designation from the `ut_role_types` table
			# this makes it easy to maintain
				SET @stakeholder = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=@role_type_id);

			# We get the Stakeholder Generic description for the BZFE from the `ut_role_types` table
			# this makes it easy to maintain
				SET @stakeholder_g_description = (SELECT `bz_description` FROM `ut_role_types` WHERE `id_role_type`=@role_type_id);

			# The 'visibility' explanation
				SET @visibility_explanation = CONCAT(@visibility_explanation_1,@stakeholder,@visibility_explanation_2);

	# We need to know if this is the first time we have created a user with this role.
	#
	# If this was any other scenario, we will need to check if we already have a record in the table `ut_product_group`
	# The check is to test if we have a record in the table `ut_product_group` where
	# `product_id` = @product_id AND `role_type_id` = @role_type_id AND `group_type_id` = 2
	# `group_type_id` = 2 is the group to grant access to product/units and bugs/cases.
	# if we have one, no need to create a component/stakholder or any group
	# we just need 
	#	1- to grant membership in this group to the new user so that it can access this
	#		unit and the cases in this unit.
	#	2- Check the group_id that makes this user visible to other users for this product (also in the table `ut_product_group`)
	#	3- Check the group_id that makes this user see the other users for this product (also in the table `ut_product_group`)
	#	4- Check the group_id that allow users to be asked for flag approvals for this product (also in the table `ut_product_group`)
	#	5- Check the group_id that allow users to approve flag for this product (also in the table `ut_product_group`)
	#
	# This is for Demo, we know this is the first time we create a Landlord.
	# We need to:
	# We need to:
	#	- Create the component
	#	- Create the groups
	#	- Update the table `ut_product_group`
	#	- Make sure the groups are properly configured
	#	- Make sure that this new users is granted the membership in the group he needs

		/*Data for the table `ut_map_user_unit_details` */
		# Update the Unee-T table that records information about the user:
			INSERT INTO `ut_map_user_unit_details`
							(`id_user_unit`
							, `created`
							, `record_created_by`
							, `is_obsolete`
							, `user_id`
							, `bz_profile_id`
							, `bz_unit_id`
							, `role_type_id`
							, `is_occupant`
							, `is_public_assignee`
							, `is_see_visible_assignee`
							, `is_flag_requestee`
							, `is_flag_approver`
							, `can_create_any_sh`
							, `can_create_same_sh`
							, `can_approve_user_for_flags`
							, `can_decide_if_user_visible`
							, `can_decide_if_user_can_see_visible`
							, `public_name`
							, `more_info`
							, `comment`
							)
							VALUES
							(NULL,@timestamp,@user_creator_bz_user_id,0,NULL,@bz_user_id,@product_id,@role_type_id,@is_occupant,@user_is_public,@user_can_see_public,@can_be_asked_to_approve,@can_approve,@can_create_any_stakeholder,@can_create_same_stakeholder,@can_approve_user_for_flag,@can_decide_if_user_is_visible,@can_decide_if_user_can_see_visible
							,@stakeholder_pub_name,@stakeholder_more,'');
	
		/*Data for the table `components` */
		# We insert the correct values for the component/stakeholder.
		INSERT  INTO `components`
			(`id`
			,`name`
			,`product_id`
			,`initialowner`
			,`initialqacontact`
			,`description`
			,`isactive`
			) 
			VALUES 
			(NULL,@stakeholder,@product_id,@bz_user_id,@bz_user_id,CONCAT(@stakeholder_g_description, ' \r\ ', @stakeholder_pub_info),1);

		# In order to to populate other table (flags, audit table,...), we need to get the newly created component_id
			SET @component_id = LAST_INSERT_ID();

		/*Data for the table `component_cc` */
		# We have NOT added a new user as another stakeholder in stakeholder group that already has users.
		# Nothing to do here
			
		/*Data for the table `groups` */
		# We have created all the groups we needed when we created the unit
		# We have no need to re-create these groups.


		/*Data for the table `group_group_map` */
		# We have created all the groups we needed when we created the unit
		# Nothing to do here
		
		/*Data for the table `group_control_map` */
		# We have created all the groups we needed when we created the unit
		# Nothing to do here
	
		/*Data for the table `user_group_map` */
		# The groups have been defined, we can now tell which group the BZ users needs access to.

	
##################################################################################
# WE NEED TO MAKE THIS A CONDITIONAL THING TO MAKE THIS SCRIPT MORE VERSATILE
#	- Is the user the creator of the unit?
#	- What is the role_type_id for that user?
#	- Is the user an occupant?
#	- Is this user publicly visible?
#	- Can this user see the publicly visible users?
#	- Can this user be asked to approved flags?
#	- Can this user approve flags?
#	- Is the user allowed to create more users?
#		- In the same group of Stakholder
#		- In ANY group of stakeholder
#		- Can decide who can be requestee and grant Flags
#		- Can decided who is visible in the list of assignee
#		- Can decided if a new user can see visible assignees
#		- 
#
# The consequences of the answers to these questions are:
#	- If user is the creator of the unit, we make him a member of:
#		- @unit_creator_group_id
#	- If user is in the role [n] then we make him a member of THE groups
#		- @are_users_stakeholder_[n]_group_id
#		- @show_to_stakeholder_[all but n]_group_id
# 	- If the user is an occupant then make him a member of
#		- @are_occupants_group_id
# 	- If the user is NOT an occupant then make him a member of
#		- @show_to_occupants_group_id
#	- If the user is publicly visible then make him a member of
#		- @list_visible_assignees_group_id
#	- If the user can see the publicly visible users then make him a member of
#		- @see_visible_assignees_group_id
#	- If the user can be asked to approved flags then make him a member of
#		- @r_group_next_step
#		- @r_group_solution
#		- @r_group_budget
#		- @r_group_attachment
#		- @r_group_OK_to_pay
#		- @r_group_is_paid
#		- @all_r_flags_group_id
#	- If the user is allowed to approve flags then make him a member of
#		- @g_group_next_step
#		- @g_group_solution
#		- @g_group_budget
#		- @g_group_attachment
#		- @g_group_OK_to_pay
#		- @g_group_is_paid
#		- @all_g_flags_group_id
#
# Creation of new users:
#	- If the user is allowed to create more users in ANY group of stakeholder 
#		then he is granted permissions to add users to
#		- @create_case_group_id
#		- @are_users_stakeholder_1_group_id
#		- @are_users_stakeholder_2_group_id
#		- @are_users_stakeholder_3_group_id
#		- @are_users_stakeholder_4_group_id
#		- @are_users_stakeholder_5_group_id
#		- @show_to_stakeholder_1_group_id
#		- @show_to_stakeholder_2_group_id
#		- @show_to_stakeholder_3_group_id
#		- @show_to_stakeholder_4_group_id
#		- @show_to_stakeholder_5_group_id
#		- @are_occupants_group_id
#		- @show_to_occupants_group_id
#
#	- If the user is allowed to create more users only in the same group of stakeholder [n] 
#		then he is granted permissions to add users to
#		- @create_case_group_id
#		- @are_users_stakeholder_[n]_group_id
#		- @show_to_stakeholder_[all but n]_group_id
#		- @are_occupants_group_id
#		- @show_to_occupants_group_id
#
#	- If the user can decided who is visible in the list of assignee
#		- @list_visible_assignees_group_id
#
#	- If the user can decided if a new user can see visible assignees
#		- @see_visible_assignees_group_id
#
#	- If the user can decide who can be requestee and grant Flags
#		- @r_group_next_step
#		- @r_group_solution
#		- @r_group_budget
#		- @r_group_attachment
#		- @r_group_OK_to_pay
#		- @r_group_is_paid
#		- @g_group_next_step
#		- @g_group_solution
#		- @g_group_budget
#		- @g_group_attachment
#		- @g_group_OK_to_pay
#		- @g_group_is_paid
#		- @all_r_flags_group_id
#		- @all_g_flags_group_id
#
##################################################################################

		INSERT  INTO `user_group_map`
			(`user_id`
			,`group_id`
			,`isbless`
			,`grant_type`
			) 
			VALUES 
			# Permission for the user we created:
				# Permission to GRANT Membership to the following groups
					# A user is the creator: this is true so he can add more users and stakholders there
						#(@bz_user_id,@unit_creator_group_id,1,0),
						
					# A user can create a case for this unit? This is true so he can add more users and stakholders there
					# For Marley, we know he is allowed to
						(@bz_user_id,@create_case_group_id,1,0),
					
					# A user can see cases in the product.
					# For Marley, we know he is allowed to
						(@bz_user_id,@can_see_cases_group_id,1,0),
						
					# A user can edit a case for that unit
					# For Marley, we know he is allowed to
						(@bz_user_id,@can_edit_case_group_id,1,0),
					
					# A user can edit all filed in a case, regardless of its role
					# For Marley, we know he is NOT allowed to
					# This is because he is NOT the unit creator
						#(@bz_user_id,@can_edit_all_field_case_group_id,1,0),
					
					# A user can edit stakholder/component in the product.
					# For Marley, we know he is allowed to
						(@bz_user_id,@can_edit_component_group_id,1,0),
				
					# A user is a stakeholder: This is true so he can add more users and stakholders there
					# For Marley, we know he is allowed to ONLY create other Landlord (2)
						#(@bz_user_id,@are_users_stakeholder_1_group_id,1,0),
						(@bz_user_id,@are_users_stakeholder_2_group_id,1,0),
						#(@bz_user_id,@are_users_stakeholder_3_group_id,1,0),
						#(@bz_user_id,@are_users_stakeholder_4_group_id,1,0),
						#(@bz_user_id,@are_users_stakeholder_5_group_id,1,0),
						#(@bz_user_id,@show_to_stakeholder_1_group_id,1,0),
						(@bz_user_id,@show_to_stakeholder_2_group_id,1,0),
						#(@bz_user_id,@show_to_stakeholder_3_group_id,1,0),
						#(@bz_user_id,@show_to_stakeholder_4_group_id,1,0),
						#(@bz_user_id,@show_to_stakeholder_5_group_id,1,0),
					
					# A user is an occupant: This is true so he can add more users and stakholders there
					# For Marley, we know he is allowed to
						(@bz_user_id,@are_occupants_group_id,1,0),
						(@bz_user_id,@show_to_occupants_group_id,1,0),
					
					# A user is a visible assignee: This is true so he can add more users and stakholders there
					# For Marley, we know he is allowed to
						(@bz_user_id,@list_visible_assignees_group_id,1,0),
						
					# A user can see visible assignees: This is true so he can add more users and stakholders there
					# For Marley, we know he is allowed to
						(@bz_user_id,@see_visible_assignees_group_id,1,0),
					
					# A user can be asked to approve flags: This is true so he can add more users and stakholders there
					# For Marley, we know he is allowed to
						(@bz_user_id,@r_group_next_step,1,0),
						(@bz_user_id,@r_group_solution,1,0),
						(@bz_user_id,@r_group_budget,1,0),
						(@bz_user_id,@r_group_attachment,1,0),
						(@bz_user_id,@r_group_OK_to_pay,1,0),
						(@bz_user_id,@r_group_is_paid,1,0),
						(@bz_user_id,@all_r_flags_group_id,1,0),
					
					# A user can approve flags: This is true so he can add more users and stakholders there
					# For Marley, we know he is allowed to
						(@bz_user_id,@g_group_next_step,1,0),
						(@bz_user_id,@g_group_solution,1,0),
						(@bz_user_id,@g_group_budget,1,0),
						(@bz_user_id,@g_group_attachment,1,0),
						(@bz_user_id,@g_group_OK_to_pay,1,0),
						(@bz_user_id,@g_group_is_paid,1,0),
						(@bz_user_id,@all_g_flags_group_id,1,0),

				# Marley is a member of the following groups

					# Can he create a case for this unit?
					# All the new user can create...
						(@bz_user_id,@create_case_group_id,0,0),
					
					# User can see any case in the product.
					# By default, all users for this product/unit have this too
						(@bz_user_id,@can_see_cases_group_id,0,0),
					
					# User can edit a case for that unit
					# For Marley, we know he is allowed to
						(@bz_user_id,@can_edit_case_group_id,0,0),
					
					# User can edit all filed in a case, regardless of its role
					# For Marley, we know he is allowed to
					# This is because he is NOT the unit creator
						#(@bz_user_id,@can_edit_all_field_case_group_id,0,0),
					
					# User can edit stakholder/component in the product.
					# For Marley, we know he is allowed to
						(@bz_user_id,@can_edit_component_group_id,0,0),
	
					# Is the user a creator of the unit?
					# For Marley, we know he is NOT
						#(@bz_user_id,@unit_creator_group_id,0,0),
					
					# Group to show/hide cases to some stakeholders:
					# For Marley, we know he is stakeholder 2
						#(@bz_user_id,@are_users_stakeholder_1_group_id,0,0),
						(@bz_user_id,@are_users_stakeholder_2_group_id,0,0),
						#(@bz_user_id,@are_users_stakeholder_3_group_id,0,0),
						#(@bz_user_id,@are_users_stakeholder_4_group_id,0,0),
						#(@bz_user_id,@are_users_stakeholder_5_group_id,0,0),
						
					# Group to show/hide cases to some stakeholders:
					# For Marley, we know he is stakeholder 2
					#
						#(@bz_user_id,@show_to_stakeholder_1_group_id,0,0),
						(@bz_user_id,@show_to_stakeholder_2_group_id,0,0),
						#(@bz_user_id,@show_to_stakeholder_3_group_id,0,0),
						#(@bz_user_id,@show_to_stakeholder_4_group_id,0,0),
						#(@bz_user_id,@show_to_stakeholder_5_group_id,0,0),
					
					# Is he an occupant?
					# For Marley, the answer is NO
						#(@bz_user_id,@are_occupants_group_id,0,0),

						#(@bz_user_id,@show_to_occupants_group_id,0,0),
					
					# Is he visible in the list of possible assignees?
					# For Marley, the answer is YES
						(@bz_user_id,@list_visible_assignees_group_id,0,0),
						
					# Can he see all the other visible assigneed?
					# For Marley, the answer is YES
						(@bz_user_id,@see_visible_assignees_group_id,0,0),
					
					# Flags: can he be asked to request?
					# For Marley, the answer is YES
						(@bz_user_id,@r_group_next_step,0,0),
						(@bz_user_id,@r_group_solution,0,0),
						(@bz_user_id,@r_group_budget,0,0),
						(@bz_user_id,@r_group_attachment,0,0),
						(@bz_user_id,@r_group_OK_to_pay,0,0),
						(@bz_user_id,@r_group_is_paid,0,0),
						(@bz_user_id,@all_r_flags_group_id,0,0),

					# Flags: can he approve?
					# For Marley, the answer is YES
						(@bz_user_id,@g_group_next_step,0,0),
						(@bz_user_id,@g_group_solution,0,0),
						(@bz_user_id,@g_group_budget,0,0),
						(@bz_user_id,@g_group_attachment,0,0),
						(@bz_user_id,@g_group_OK_to_pay,0,0),
						(@bz_user_id,@g_group_is_paid,0,0),
						(@bz_user_id,@all_g_flags_group_id,0,0);

		/*Data for the table `series_categories` */
			INSERT  INTO `series_categories`
				(`id`
				,`name`
				) 
				VALUES 
				# We add user id so that there are no conflicts when we create several users which are identical stakeholer (ex: 2 tenants)
				(NULL,CONCAT(@stakeholder,'_P',@product_id,'_U',@bz_user_id));

			# We need to know the value of the other series category we need.
				# This is the command if the series has already been created
				# We do not use this option since we know the series has NOT been created yet
					#SET @series_3 = (SELECT `id` FROM `series_categories` WHERE `name` = CONCAT(@stakeholder,'_P',@product_id,'_U',@bz_user_id));
				
				# We know that this in is a new series, we increment the variable.
					SET @series_3 = (@series_3+1);
					
					
		/*Data for the table `series` */
		# This is so that we can see historical data and how a case is evolving
		# This can only be done after the series categories have been created
	
			INSERT  INTO `series`
				(`series_id`
				,`creator`
				,`category`
				,`subcategory`
				,`name`
				,`frequency`
				,`query`
				,`is_public`
				) 
				VALUES 
				(NULL,@bz_user_id,@series_1,@series_3,'All Open',1,CONCAT('field0-0-0=resolution&type0-0-0=notregexp&value0-0-0=.&product=Test%Unit%1%A&component=', @stakeholder),1),
				(NULL,@bz_user_id,@series_1,@series_3,'All Closed',1,CONCAT('field0-0-0=resolution&type0-0-0=regexp&value0-0-0=.&product=Test%Unit%1%A&component=', @stakeholder),1);

		/*Data for the table `audit_log` */
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
				(@user_creator_bz_user_id,'Bugzilla::Group',@create_case_group_id,'__create__',NULL,CONCAT(@unit,' #',@product_id,' - ', @stakeholder,' - Created by: ',@user_creator_pub_name),@timestamp),
				(@user_creator_bz_user_id,'Bugzilla::Component',@component_id,'__create__',NULL,@stakeholder,@timestamp);

# We Create the Privileges for Michael now
#     Michael is one of the a 2 Tenants living in this unit.
#     His `id_role_type` in the table `ut_role_types` = 1

	# We do NOT need to create the unit here.
	# BUT We need to Make sure that the the component for this Unit is correct
	
	# We also want to show the publicly visible information for Michael.
		# His public name
			SET @stakeholder_pub_name = 'Michael';
		# More details
			SET @stakeholder_more = '123 456 7892';
		# Se we can create the public info too
			SET @stakeholder_pub_info = CONCAT(@stakeholder_pub_name,' - ', @stakeholder_more);
		
	# We Need the BZ user information for Michael
		SET @bz_user_id = 4;

	# User role: this is an id in the table `ut_role_types` for easier manipulation, update and maintenance
		SET @role_type_id = 1;

	# Is this user an occupant of the unit?
	#	- 1 = TRUE
	#	- 0 = FALSE
		SET @is_occupant = 1;

	# We Need the BZ user information for the creator of the new user too (Leonel)
		SET @user_creator_bz_user_id = 2;
			
		# His public name 
		# We have this as a variable in this script.
		# this should be stored somewhere in the MEFE
		# we do not need to recreate this in the context of the script to create DEMO users.
			# SET @user_creator_pub_name = 'GET creator_public_name FROM THE MEFE';
		# More details
			#SET @user_creator_more ='GET creator_more FROM THE MEFE';
		# Se we can create the public info too
			#SET @user_creator_pub_info = CONCAT(@user_creator_pub_name,' - ', @user_creator_more);

	# OPTIONAL INFORMATION:
	#
	# We need to know if this user can 
	#	- see all other user (1) 
	#		In this case this user will be a member of the group `@list_visible_assignees_group_id`
	#		for this product/unit.
	#	- see only the people in the same role/stakeholder group. (0)
	# 		Else this user will NOT be a member of the group `@list_visible_assignees_group_id`
	#		for this product/unit.
	# By Default, the user is visible to all other user.
		SET @user_is_public = 1; 
	#
	# We need to know if this user is 
	#	- visible to all other user (1) 
	#		In this case this user will be a member of the group `@see_visible_assignees_group_id`
	#		for this product/unit.
	#	- visible only to people in the same role/stakeholder group. (1)
	# 		Else this user will NOT be a member of the group `@see_visible_assignees_group_id`
	#		for this product/unit.
	# By Default, the user is visible to all other user.
		SET @user_can_see_public = 1; 

	#
	# By default the new user can approve all flags but we want flexibility there 
	# We know this might not be always true for all BZ user we create
		SET @can_be_asked_to_approve = 1;

	# By default the new user can approve all flags but we want flexibility there 
	# We know this might not be always true for all BZ user we create
		SET @can_approve = 1;
	#
	# Is the user allowed to create new users?
		# only in the same group of stakholders
			SET @can_create_same_stakeholder = 1;
		
		# in ANY group of stakeholders
			SET @can_create_any_stakeholder = 0;
	
	# Is this user allowed to decided who can be requestee and grant Flags?
		SET @can_approve_user_for_flag = 1;
		
	# Is this user is allowed to decided who is visible in the list of assignee?
		SET @can_decide_if_user_is_visible = 1;
		
	# Is this user is allowed to decided if a new user can see visible assignees?
		SET @can_decide_if_user_can_see_visible = 1;

	# We have everything - Onward for Michael!
	
		# We DISABLE the FK check
			SET FOREIGN_KEY_CHECKS = 0;
	
		# Get the additional variable that we need
			# When is this happening?
				SET @timestamp = NOW();

			# We get the login name from the user_id
				SET @login_name = (SELECT `login_name` FROM `profiles` WHERE `userid`=@bz_user_id);
				SET @user_creator_login_name = (SELECT `login_name` FROM `profiles` WHERE `userid`=@user_creator_bz_user_id);

			# We get the Stakeholder designation from the `ut_role_types` table
			# this makes it easy to maintain
				SET @stakeholder = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=@role_type_id);

			# We get the Stakeholder Generic description for the BZFE from the `ut_role_types` table
			# this makes it easy to maintain
				SET @stakeholder_g_description = (SELECT `bz_description` FROM `ut_role_types` WHERE `id_role_type`=@role_type_id);

			# The 'visibility' explanation
				SET @visibility_explanation = CONCAT(@visibility_explanation_1,@stakeholder,@visibility_explanation_2);

	# We need to know if this is the first time we have created a user with this role.
	#
	# If this was any other scenario, we will need to check if we already have a record in the table `ut_product_group`
	# The check is to test if we have a record in the table `ut_product_group` where
	# `product_id` = @product_id AND `role_type_id` = @role_type_id AND `group_type_id` = 2
	# `group_type_id` = 2 is the group to grant access to product/units and bugs/cases.
	# if we have one, no need to create a component/stakholder or any group
	# we just need 
	#	1- to grant membership in this group to the new user so that it can access this
	#		unit and the cases in this unit.
	#	2- Check the group_id that makes this user visible to other users for this product (also in the table `ut_product_group`)
	#	3- Check the group_id that makes this user see the other users for this product (also in the table `ut_product_group`)
	#	4- Check the group_id that allow users to be asked for flag approvals for this product (also in the table `ut_product_group`)
	#	5- Check the group_id that allow users to approve flag for this product (also in the table `ut_product_group`)
	#
	# This is for Demo, we know this is the first time we create a Landlord.
	# We need to:
	# We need to:
	#	- Create the component
	#	- Create the groups
	#	- Update the table `ut_product_group`
	#	- Make sure the groups are properly configured
	#	- Make sure that this new users is granted the membership in the group he needs

		/*Data for the table `ut_map_user_unit_details` */
		# Update the Unee-T table that records information about the user:
			INSERT INTO `ut_map_user_unit_details`
							(`id_user_unit`
							, `created`
							, `record_created_by`
							, `is_obsolete`
							, `user_id`
							, `bz_profile_id`
							, `bz_unit_id`
							, `role_type_id`
							, `is_occupant`
							, `is_public_assignee`
							, `is_see_visible_assignee`
							, `is_flag_requestee`
							, `is_flag_approver`
							, `can_create_any_sh`
							, `can_create_same_sh`
							, `can_approve_user_for_flags`
							, `can_decide_if_user_visible`
							, `can_decide_if_user_can_see_visible`
							, `public_name`
							, `more_info`
							, `comment`
							)
							VALUES
							(NULL,@timestamp,@user_creator_bz_user_id,0,NULL,@bz_user_id,@product_id,@role_type_id,@is_occupant,@user_is_public,@user_can_see_public,@can_be_asked_to_approve,@can_approve,@can_create_any_stakeholder,@can_create_same_stakeholder,@can_approve_user_for_flag,@can_decide_if_user_is_visible,@can_decide_if_user_can_see_visible
							,@stakeholder_pub_name,@stakeholder_more,'');

		/*Data for the table `components` */
		# We insert the correct values for the component/stakeholder.
		INSERT  INTO `components`
			(`id`
			,`name`
			,`product_id`
			,`initialowner`
			,`initialqacontact`
			,`description`
			,`isactive`
			) 
			VALUES 
			(NULL,@stakeholder,@product_id,@bz_user_id,@bz_user_id,CONCAT(@stakeholder_g_description, ' \r\ ', @stakeholder_pub_info),1);

		# In order to to populate other table (flags, audit table,...), we need to get the newly created component_id
			SET @component_id = LAST_INSERT_ID();

		/*Data for the table `component_cc` */
		# We have NOT added a new user as another stakeholder in stakeholder group that already has users.
		# Nothing to do here
			
		/*Data for the table `groups` */
		# We have created all the groups we needed when we created the unit
		# We have no need to re-create these groups.


		/*Data for the table `group_group_map` */
		# We have created all the groups we needed when we created the unit
		# Nothing to do here
		
		/*Data for the table `group_control_map` */
		# We have created all the groups we needed when we created the unit
		# Nothing to do here
	
		/*Data for the table `user_group_map` */
		# The groups have been defined, we can now tell which group the BZ users needs access to.

	
##################################################################################
# WE NEED TO MAKE THIS A CONDITIONAL THING TO MAKE THIS SCRIPT MORE VERSATILE
#	- Is the user the creator of the unit?
#	- What is the role_type_id for that user?
#	- Is the user an occupant?
#	- Is this user publicly visible?
#	- Can this user see the publicly visible users?
#	- Can this user be asked to approved flags?
#	- Can this user approve flags?
#	- Is the user allowed to create more users?
#		- In the same group of Stakholder
#		- In ANY group of stakeholder
#		- Can decide who can be requestee and grant Flags
#		- Can decided who is visible in the list of assignee
#		- Can decided if a new user can see visible assignees
#		- 
#
# The consequences of the answers to these questions are:
#	- If user is the creator of the unit, we make him a member of:
#		- @unit_creator_group_id
#	- If user is in the role [n] then we make him a member of THE groups
#		- @are_users_stakeholder_[n]_group_id
#		- @show_to_stakeholder_[all but n]_group_id
# 	- If the user is an occupant then make him a member of
#		- @are_occupants_group_id
# 	- If the user is NOT an occupant then make him a member of
#		- @show_to_occupants_group_id
#	- If the user is publicly visible then make him a member of
#		- @list_visible_assignees_group_id
#	- If the user can see the publicly visible users then make him a member of
#		- @see_visible_assignees_group_id
#	- If the user can be asked to approved flags then make him a member of
#		- @r_group_next_step
#		- @r_group_solution
#		- @r_group_budget
#		- @r_group_attachment
#		- @r_group_OK_to_pay
#		- @r_group_is_paid
#		- @all_r_flags_group_id
#	- If the user is allowed to approve flags then make him a member of
#		- @g_group_next_step
#		- @g_group_solution
#		- @g_group_budget
#		- @g_group_attachment
#		- @g_group_OK_to_pay
#		- @g_group_is_paid
#		- @all_g_flags_group_id
#
# Creation of new users:
#	- If the user is allowed to create more users in ANY group of stakeholder 
#		then he is granted permissions to add users to
#		- @create_case_group_id
#		- @are_users_stakeholder_1_group_id
#		- @are_users_stakeholder_2_group_id
#		- @are_users_stakeholder_3_group_id
#		- @are_users_stakeholder_4_group_id
#		- @are_users_stakeholder_5_group_id
#		- @show_to_stakeholder_1_group_id
#		- @show_to_stakeholder_2_group_id
#		- @show_to_stakeholder_3_group_id
#		- @show_to_stakeholder_4_group_id
#		- @show_to_stakeholder_5_group_id
#		- @are_occupants_group_id
#		- @show_to_occupants_group_id
#
#	- If the user is allowed to create more users only in the same group of stakeholder [n] 
#		then he is granted permissions to add users to
#		- @create_case_group_id
#		- @are_users_stakeholder_[n]_group_id
#		- @show_to_stakeholder_[all but n]_group_id
#		- @are_occupants_group_id
#		- @show_to_occupants_group_id
#
#	- If the user can decided who is visible in the list of assignee
#		- @list_visible_assignees_group_id
#
#	- If the user can decided if a new user can see visible assignees
#		- @see_visible_assignees_group_id
#
#	- If the user can decide who can be requestee and grant Flags
#		- @r_group_next_step
#		- @r_group_solution
#		- @r_group_budget
#		- @r_group_attachment
#		- @r_group_OK_to_pay
#		- @r_group_is_paid
#		- @g_group_next_step
#		- @g_group_solution
#		- @g_group_budget
#		- @g_group_attachment
#		- @g_group_OK_to_pay
#		- @g_group_is_paid
#		- @all_r_flags_group_id
#		- @all_g_flags_group_id
#
##################################################################################

		INSERT  INTO `user_group_map`
			(`user_id`
			,`group_id`
			,`isbless`
			,`grant_type`
			) 
			VALUES 
			# Permission for the user we created:
				# Permission to GRANT Membership to the following groups
					# A user is the creator: this is true so he can add more users and stakholders there
						#(@bz_user_id,@unit_creator_group_id,1,0),
							
					# A user can create a case for this unit? This is true so he can add more users and stakholders there
					# For Michael, we know he is allowed to
						(@bz_user_id,@create_case_group_id,1,0),
					
					# A user can see cases in the product.
					# For Michael, we know he is allowed to
						(@bz_user_id,@can_see_cases_group_id,1,0),
					
					# User can edit a case for that unit
					# For Michael, we know he is allowed to
						(@bz_user_id,@can_edit_case_group_id,1,0),
					
					# A User can edit all filed in a case, regardless of its role
					# For Michael, we know he is allowed to
					# This is because he NOT is he unit creator
						#(@bz_user_id,@can_edit_all_field_case_group_id,1,0),
					
					# A User can edit stakholder/component in the product.
					# For Michael, we know he is allowed to
						(@bz_user_id,@can_edit_component_group_id,1,0),
						
					# A user is a stakeholder: This is true so he can add more users and stakholders there
					# For Michael, we know he is allowed to ONLY create other Tenants (1)
						(@bz_user_id,@are_users_stakeholder_1_group_id,1,0),
						#(@bz_user_id,@are_users_stakeholder_2_group_id,1,0),
						#(@bz_user_id,@are_users_stakeholder_3_group_id,1,0),
						#(@bz_user_id,@are_users_stakeholder_4_group_id,1,0),
						#(@bz_user_id,@are_users_stakeholder_5_group_id,1,0),
						(@bz_user_id,@show_to_stakeholder_1_group_id,1,0),
						#(@bz_user_id,@show_to_stakeholder_2_group_id,1,0),
						#(@bz_user_id,@show_to_stakeholder_3_group_id,1,0),
						#(@bz_user_id,@show_to_stakeholder_4_group_id,1,0),
						#(@bz_user_id,@show_to_stakeholder_5_group_id,1,0),
					
					# A user is an occupant: This is true so he can add more users and stakholders there
					# For Michael, we know he is allowed to
						(@bz_user_id,@are_occupants_group_id,1,0),
						(@bz_user_id,@show_to_occupants_group_id,1,0),
					
					# A user is a visible assignee: This is true so he can add more users and stakholders there
					# For Michael, we know he is allowed to
						(@bz_user_id,@list_visible_assignees_group_id,1,0),
						
					# A user can see visible assignees: This is true so he can add more users and stakholders there
					# For Michael, we know he is allowed to
						(@bz_user_id,@see_visible_assignees_group_id,1,0),
					
					# A user can be asked to approve flags: This is true so he can add more users and stakholders there
					# For Michael, we know he is allowed to
						(@bz_user_id,@r_group_next_step,1,0),
						(@bz_user_id,@r_group_solution,1,0),
						(@bz_user_id,@r_group_budget,1,0),
						(@bz_user_id,@r_group_attachment,1,0),
						(@bz_user_id,@r_group_OK_to_pay,1,0),
						(@bz_user_id,@r_group_is_paid,1,0),
						(@bz_user_id,@all_r_flags_group_id,1,0),
					
					# A user can approve flags: This is true so he can add more users and stakholders there
					# For Michael, we know he is allowed to
						(@bz_user_id,@g_group_next_step,1,0),
						(@bz_user_id,@g_group_solution,1,0),
						(@bz_user_id,@g_group_budget,1,0),
						(@bz_user_id,@g_group_attachment,1,0),
						(@bz_user_id,@g_group_OK_to_pay,1,0),
						(@bz_user_id,@g_group_is_paid,1,0),
						(@bz_user_id,@all_g_flags_group_id,1,0),

				# Michael is a member of the following groups

					# Can he create a case for this unit?
					# All the new user can create...
						(@bz_user_id,@create_case_group_id,0,0),
										
					# User can see any case in the product.
					# By default, all users for this product/unit have this too
						(@bz_user_id,@can_see_cases_group_id,0,0),

					# User can edit a case for that unit
					# For Michael, we know he is allowed to
						(@bz_user_id,@can_edit_case_group_id,0,0),
					
					# User can edit all filed in a case, regardless of its role
					# For Michael, we know he is allowed to
					# This is because he is NOT the unit creator
						#(@bz_user_id,@can_edit_all_field_case_group_id,0,0),
					
					# User can edit stakholder/component in the product.
					# For Michael, we know he is allowed to
						(@bz_user_id,@can_edit_component_group_id,0,0),
	
					# Is the user a creator of the unit?
					# For Michael, we know he is NOT
						#(@bz_user_id,@unit_creator_group_id,0,0),
					
					# Group to show/hide cases to some stakeholders:
					# For Michael, we know he is stakeholder 1
						(@bz_user_id,@are_users_stakeholder_1_group_id,0,0),
						#(@bz_user_id,@are_users_stakeholder_2_group_id,0,0),
						#(@bz_user_id,@are_users_stakeholder_3_group_id,0,0),
						#(@bz_user_id,@are_users_stakeholder_4_group_id,0,0),
						#(@bz_user_id,@are_users_stakeholder_5_group_id,0,0),
						
					# Group to show/hide cases to some stakeholders:
					# For Michael, we know he is stakeholder 1
					#
						(@bz_user_id,@show_to_stakeholder_1_group_id,0,0),
						#(@bz_user_id,@show_to_stakeholder_2_group_id,0,0),
						#(@bz_user_id,@show_to_stakeholder_3_group_id,0,0),
						#(@bz_user_id,@show_to_stakeholder_4_group_id,0,0),
						#(@bz_user_id,@show_to_stakeholder_5_group_id,0,0),
					
					# Is he an occupant?
					# For Michael, the answer is YES
						(@bz_user_id,@are_occupants_group_id,0,0),
						
						(@bz_user_id,@show_to_occupants_group_id,0,0),
					
					# Is he visible in the list of possible assignees?
					# For Michael, the answer is YES
						(@bz_user_id,@list_visible_assignees_group_id,0,0),
						
					# Can he see all the other visible assigneed?
					# For Michael, the answer is YES
						(@bz_user_id,@see_visible_assignees_group_id,0,0),
					
					# Flags: can he be asked to request?
					# For Michael, the answer is YES
						(@bz_user_id,@r_group_next_step,0,0),
						(@bz_user_id,@r_group_solution,0,0),
						(@bz_user_id,@r_group_budget,0,0),
						(@bz_user_id,@r_group_attachment,0,0),
						(@bz_user_id,@r_group_OK_to_pay,0,0),
						(@bz_user_id,@r_group_is_paid,0,0),
						(@bz_user_id,@all_r_flags_group_id,0,0),

					# Flags: can he approve?
					# For Michael, the answer is YES
						(@bz_user_id,@g_group_next_step,0,0),
						(@bz_user_id,@g_group_solution,0,0),
						(@bz_user_id,@g_group_budget,0,0),
						(@bz_user_id,@g_group_attachment,0,0),
						(@bz_user_id,@g_group_OK_to_pay,0,0),
						(@bz_user_id,@g_group_is_paid,0,0),
						(@bz_user_id,@all_g_flags_group_id,0,0);

		/*Data for the table `series_categories` */
			INSERT  INTO `series_categories`
				(`id`
				,`name`
				) 
				VALUES 
				# We add user id so that there are no conflicts when we create several users which are identical stakeholer (ex: 2 tenants)
				(NULL,CONCAT(@stakeholder,'_P',@product_id,'_U',@bz_user_id));

			# We need to know the value of the other series category we need.
				# This is the command if the series has already been created
				# We do not use this option since we know the series has NOT been created yet
					#SET @series_3 = (SELECT `id` FROM `series_categories` WHERE `name` = CONCAT(@stakeholder,'_P',@product_id,'_U',@bz_user_id));
				
				# We know that this in is a new series, we increment the variable.
					SET @series_3 = (@series_3+1);
					
					
		/*Data for the table `series` */
		# This is so that we can see historical data and how a case is evolving
		# This can only be done after the series categories have been created
	
			INSERT  INTO `series`
				(`series_id`
				,`creator`
				,`category`
				,`subcategory`
				,`name`
				,`frequency`
				,`query`
				,`is_public`
				) 
				VALUES 
				(NULL,@bz_user_id,@series_1,@series_3,'All Open',1,CONCAT('field0-0-0=resolution&type0-0-0=notregexp&value0-0-0=.&product=Test%Unit%1%A&component=', @stakeholder),1),
				(NULL,@bz_user_id,@series_1,@series_3,'All Closed',1,CONCAT('field0-0-0=resolution&type0-0-0=regexp&value0-0-0=.&product=Test%Unit%1%A&component=', @stakeholder),1);

		/*Data for the table `audit_log` */
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
				(@user_creator_bz_user_id,'Bugzilla::Group',@create_case_group_id,'__create__',NULL,CONCAT(@unit,' #',@product_id,' - ', @stakeholder,' - Created by: ',@user_creator_pub_name),@timestamp),
				(@user_creator_bz_user_id,'Bugzilla::Component',@component_id,'__create__',NULL,@stakeholder,@timestamp);


# We now Create the Privileges for Sabrina
#   - Sabrina is the other Tenant living in this unit.
# 	Her `id_role_type` in the table `ut_role_types` = 1
# 	She is also an occupant of the unit.

	# We do NOT need to create the unit here.
	# BUT We need to Make sure that the the component for this Unit is correct
	
	# We also want to show the publicly visible information for Sabrina.
		# His public name
			SET @stakeholder_pub_name = 'Sabrina';
		# More details
			SET @stakeholder_more = 'sabrina@example.com - 563 075 2334';
		# Se we can create the public info too
			SET @stakeholder_pub_info = CONCAT(@stakeholder_pub_name,' - ', @stakeholder_more);
		
	# We Need the BZ user information for Sabrina
		SET @bz_user_id = 5;

	# User role: this is an id in the table `ut_role_types` for easier manipulation, update and maintenance
		SET @role_type_id = 1;

	# Is this user an occupant of the unit?
	#	- 1 = TRUE
	#	- 0 = FALSE
		SET @is_occupant = 1;

	# We Need the BZ user information for the creator of the new user too (Leonel)
		SET @user_creator_bz_user_id = 4;
			
		# His public name 
		# We have this as a variable in this script.
		# this should be stored somewhere in the MEFE
		# we do not need to recreate this in the context of the script to create DEMO users.
			# SET @user_creator_pub_name = 'GET creator_public_name FROM THE MEFE';
		# More details
			#SET @user_creator_more ='GET creator_more FROM THE MEFE';
		# Se we can create the public info too
			#SET @user_creator_pub_info = CONCAT(@user_creator_pub_name,' - ', @user_creator_more);

	# OPTIONAL INFORMATION:
	#
	# We need to know if this user can 
	#	- see all other user (1) 
	#		In this case this user will be a member of the group `@list_visible_assignees_group_id`
	#		for this product/unit.
	#	- see only the people in the same role/stakeholder group. (0)
	# 		Else this user will NOT be a member of the group `@list_visible_assignees_group_id`
	#		for this product/unit.
	# By Default, the user is visible to all other user.
		SET @user_is_public = 1; 
	#
	# We need to know if this user is 
	#	- visible to all other user (1) 
	#		In this case this user will be a member of the group `@see_visible_assignees_group_id`
	#		for this product/unit.
	#	- visible only to people in the same role/stakeholder group. (1)
	# 		Else this user will NOT be a member of the group `@see_visible_assignees_group_id`
	#		for this product/unit.
	# By Default, the user is visible to all other user.
		SET @user_can_see_public = 1; 

	#
	# By default the new user can approve all flags but we want flexibility there 
	# We know this might not be always true for all BZ user we create
		SET @can_be_asked_to_approve = 1;

	# By default the new user can approve all flags but we want flexibility there 
	# We know this might not be always true for all BZ user we create
		SET @can_approve = 1;
	#
	# Is the user allowed to create new users?
		# only in the same group of stakholders
			SET @can_create_same_stakeholder = 1;
		
		# in ANY group of stakeholders
			SET @can_create_any_stakeholder = 0;
	
	# Is this user allowed to decided who can be requestee and grant Flags?
		SET @can_approve_user_for_flag = 1;
		
	# Is this user is allowed to decided who is visible in the list of assignee?
		SET @can_decide_if_user_is_visible = 1;
		
	# Is this user is allowed to decided if a new user can see visible assignees?
		SET @can_decide_if_user_can_see_visible = 1;

	# We have everything - Onward for Sabrina!
	
		# We DISABLE the FK check
			SET FOREIGN_KEY_CHECKS = 0;
	
		# Get the additional variable that we need
			# When is this happening?
				SET @timestamp = NOW();

			# We get the login name from the user_id
				SET @login_name = (SELECT `login_name` FROM `profiles` WHERE `userid`=@bz_user_id);
				SET @user_creator_login_name = (SELECT `login_name` FROM `profiles` WHERE `userid`=@user_creator_bz_user_id);

			# We get the Stakeholder designation from the `ut_role_types` table
			# this makes it easy to maintain
				SET @stakeholder = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=@role_type_id);

			# We get the Stakeholder Generic description for the BZFE from the `ut_role_types` table
			# this makes it easy to maintain
				SET @stakeholder_g_description = (SELECT `bz_description` FROM `ut_role_types` WHERE `id_role_type`=@role_type_id);

			# The 'visibility' explanation
				SET @visibility_explanation = CONCAT(@visibility_explanation_1,@stakeholder,@visibility_explanation_2);

	# We need to know if this is the first time we have created a user with this role.
	#
	# If this was any other scenario, we will need to check if we already have a record in the table `ut_product_group`
	# The check is to test if we have a record in the table `ut_product_group` where
	# `product_id` = @product_id AND `role_type_id` = @role_type_id AND `group_type_id` = 2
	# `group_type_id` = 2 is the group to grant access to product/units and bugs/cases.
	# if we have one, no need to create a component/stakholder or any group
	# we just need 
	#	1- to grant membership in this group to the new user so that it can access this
	#		unit and the cases in this unit.
	#	2- Check the group_id that makes this user visible to other users for this product (also in the table `ut_product_group`)
	#	3- Check the group_id that makes this user see the other users for this product (also in the table `ut_product_group`)
	#	4- Check the group_id that allow users to be asked for flag approvals for this product (also in the table `ut_product_group`)
	#	5- Check the group_id that allow users to approve flag for this product (also in the table `ut_product_group`)
	#
	# This is for Demo, we know this is the first time we create a Landlord.
	# We need to:
	# We need to:
	#	- Create the component
	#	- Create the groups
	#	- Update the table `ut_product_group`
	#	- Make sure the groups are properly configured
	#	- Make sure that this new users is granted the membership in the group he needs

		/*Data for the table `ut_map_user_unit_details` */
		# Update the Unee-T table that records information about the user:
			INSERT INTO `ut_map_user_unit_details`
							(`id_user_unit`
							, `created`
							, `record_created_by`
							, `is_obsolete`
							, `user_id`
							, `bz_profile_id`
							, `bz_unit_id`
							, `role_type_id`
							, `is_occupant`
							, `is_public_assignee`
							, `is_see_visible_assignee`
							, `is_flag_requestee`
							, `is_flag_approver`
							, `can_create_any_sh`
							, `can_create_same_sh`
							, `can_approve_user_for_flags`
							, `can_decide_if_user_visible`
							, `can_decide_if_user_can_see_visible`
							, `public_name`
							, `more_info`
							, `comment`
							)
							VALUES
							(NULL,@timestamp,@user_creator_bz_user_id,0,NULL,@bz_user_id,@product_id,@role_type_id,@is_occupant,@user_is_public,@user_can_see_public,@can_be_asked_to_approve,@can_approve,@can_create_any_stakeholder,@can_create_same_stakeholder,@can_approve_user_for_flag,@can_decide_if_user_is_visible,@can_decide_if_user_can_see_visible
							,@stakeholder_pub_name,@stakeholder_more,'');
	
		/*Data for the table `components` */
		# We insert the correct values for the component/stakeholder.
		# We DO NOT want to create a duplicate component here
		# Nothing to do here

		# In order to to populate other table (flags, audit table,...), we need to get the newly created component_id
			SET @component_id = LAST_INSERT_ID();

		/*Data for the table `component_cc` */
		# We HAVE added a new user as another stakeholder in stakeholder group that already has users.
		# We just need to add Sabrina in the CC list for the component we created for all tenants
		# We need to create a dedicated component for this user.
		# We can use the variable @component_id to do this: it still has the value of the component we
		# created for the first tenant.
			INSERT  INTO `component_cc`
				(`user_id`
				,`component_id`
				) 
				VALUES 
				(@bz_user_id,@component_id);
			
		/*Data for the table `groups` */
		# We have created all the groups we needed when we created the unit
		# We have no need to re-create these groups.


		/*Data for the table `group_group_map` */
		# We have created all the groups we needed when we created the unit
		# Nothing to do here
		
		/*Data for the table `group_control_map` */
		# We have created all the groups we needed when we created the unit
		# Nothing to do here
	
		/*Data for the table `user_group_map` */
		# The groups have been defined, we can now tell which group the BZ users needs access to.

	
##################################################################################
# WE NEED TO MAKE THIS A CONDITIONAL THING TO MAKE THIS SCRIPT MORE VERSATILE
#	- Is the user the creator of the unit?
#	- What is the role_type_id for that user?
#	- Is the user an occupant?
#	- Is this user publicly visible?
#	- Can this user see the publicly visible users?
#	- Can this user be asked to approved flags?
#	- Can this user approve flags?
#	- Is the user allowed to create more users?
#		- In the same group of Stakholder
#		- In ANY group of stakeholder
#		- Can decide who can be requestee and grant Flags
#		- Can decided who is visible in the list of assignee
#		- Can decided if a new user can see visible assignees
#		- 
#
# The consequences of the answers to these questions are:
#	- If user is the creator of the unit, we make him a member of:
#		- @unit_creator_group_id
#	- If user is in the role [n] then we make him a member of THE groups
#		- @are_users_stakeholder_[n]_group_id
#		- @show_to_stakeholder_[all but n]_group_id
# 	- If the user is an occupant then make him a member of
#		- @are_occupants_group_id
# 	- If the user is NOT an occupant then make him a member of
#		- @show_to_occupants_group_id
#	- If the user is publicly visible then make him a member of
#		- @list_visible_assignees_group_id
#	- If the user can see the publicly visible users then make him a member of
#		- @see_visible_assignees_group_id
#	- If the user can be asked to approved flags then make him a member of
#		- @r_group_next_step
#		- @r_group_solution
#		- @r_group_budget
#		- @r_group_attachment
#		- @r_group_OK_to_pay
#		- @r_group_is_paid
#		- @all_r_flags_group_id
#	- If the user is allowed to approve flags then make him a member of
#		- @g_group_next_step
#		- @g_group_solution
#		- @g_group_budget
#		- @g_group_attachment
#		- @g_group_OK_to_pay
#		- @g_group_is_paid
#		- @all_g_flags_group_id
#
# Creation of new users:
#	- If the user is allowed to create more users in ANY group of stakeholder 
#		then he is granted permissions to add users to
#		- @create_case_group_id
#		- @are_users_stakeholder_1_group_id
#		- @are_users_stakeholder_2_group_id
#		- @are_users_stakeholder_3_group_id
#		- @are_users_stakeholder_4_group_id
#		- @are_users_stakeholder_5_group_id
#		- @show_to_stakeholder_1_group_id
#		- @show_to_stakeholder_2_group_id
#		- @show_to_stakeholder_3_group_id
#		- @show_to_stakeholder_4_group_id
#		- @show_to_stakeholder_5_group_id
#		- @are_occupants_group_id
#		- @show_to_occupants_group_id
#
#	- If the user is allowed to create more users only in the same group of stakeholder [n] 
#		then he is granted permissions to add users to
#		- @create_case_group_id
#		- @are_users_stakeholder_[n]_group_id
#		- @show_to_stakeholder_[all but n]_group_id
#		- @are_occupants_group_id
#		- @show_to_occupants_group_id
#
#	- If the user can decided who is visible in the list of assignee
#		- @list_visible_assignees_group_id
#
#	- If the user can decided if a new user can see visible assignees
#		- @see_visible_assignees_group_id
#
#	- If the user can decide who can be requestee and grant Flags
#		- @r_group_next_step
#		- @r_group_solution
#		- @r_group_budget
#		- @r_group_attachment
#		- @r_group_OK_to_pay
#		- @r_group_is_paid
#		- @g_group_next_step
#		- @g_group_solution
#		- @g_group_budget
#		- @g_group_attachment
#		- @g_group_OK_to_pay
#		- @g_group_is_paid
#		- @all_r_flags_group_id
#		- @all_g_flags_group_id
#
##################################################################################

		INSERT  INTO `user_group_map`
			(`user_id`
			,`group_id`
			,`isbless`
			,`grant_type`
			) 
			VALUES 
			# Permission for the user we created:
				# Permission to GRANT Membership to the following groups
					# A user is the creator: this is true so he can add more users and stakholders there
						#(@bz_user_id,@unit_creator_group_id,1,0),
						
					# A user can create a case for this unit? This is true so he can add more users and stakholders there
					# For Sabrina, we know he is allowed to
						(@bz_user_id,@create_case_group_id,1,0),
					
					# A user can see cases in the product.
					# For Sabrina, we know she is allowed to
						(@bz_user_id,@can_see_cases_group_id,1,0),
					
					# A User can edit a case for that unit
					# For Sabrina, we know she is allowed to
						(@bz_user_id,@can_edit_case_group_id,1,0),
										
					# A User can edit all filed in a case, regardless of its role
					# For Sabrina, we know he is allowed to
					# This is because he NOT is he unit creator
						#(@bz_user_id,@can_edit_all_field_case_group_id,1,0),
					
					# A User can edit stakholder/component in the product.
					# For Sabrina, we know he is allowed to
						(@bz_user_id,@can_edit_component_group_id,1,0),
							
					# A user is a stakeholder: This is true so he can add more users and stakholders there
					# For Sabrina, we know he is allowed to ONLY create other Tenants (1)
						(@bz_user_id,@are_users_stakeholder_1_group_id,1,0),
						#(@bz_user_id,@are_users_stakeholder_2_group_id,1,0),
						#(@bz_user_id,@are_users_stakeholder_3_group_id,1,0),
						#(@bz_user_id,@are_users_stakeholder_4_group_id,1,0),
						#(@bz_user_id,@are_users_stakeholder_5_group_id,1,0),
						(@bz_user_id,@show_to_stakeholder_1_group_id,1,0),
						#(@bz_user_id,@show_to_stakeholder_2_group_id,1,0),
						#(@bz_user_id,@show_to_stakeholder_3_group_id,1,0),
						#(@bz_user_id,@show_to_stakeholder_4_group_id,1,0),
						#(@bz_user_id,@show_to_stakeholder_5_group_id,1,0),
					
					# A user is an occupant: This is true so he can add more users and stakholders there
					# For Sabrina, we know he is allowed to
						(@bz_user_id,@are_occupants_group_id,1,0),
						(@bz_user_id,@show_to_occupants_group_id,1,0),
					
					# A user is a visible assignee: This is true so he can add more users and stakholders there
					# For Sabrina, we know he is allowed to
						(@bz_user_id,@list_visible_assignees_group_id,1,0),
						
					# A user can see visible assignees: This is true so he can add more users and stakholders there
					# For Sabrina, we know he is allowed to
						(@bz_user_id,@see_visible_assignees_group_id,1,0),
					
					# A user can be asked to approve flags: This is true so he can add more users and stakholders there
					# For Sabrina, we know he is allowed to
						(@bz_user_id,@r_group_next_step,1,0),
						(@bz_user_id,@r_group_solution,1,0),
						(@bz_user_id,@r_group_budget,1,0),
						(@bz_user_id,@r_group_attachment,1,0),
						(@bz_user_id,@r_group_OK_to_pay,1,0),
						(@bz_user_id,@r_group_is_paid,1,0),
						(@bz_user_id,@all_r_flags_group_id,1,0),
					
					# A user can approve flags: This is true so he can add more users and stakholders there
					# For Sabrina, we know he is allowed to
						(@bz_user_id,@g_group_next_step,1,0),
						(@bz_user_id,@g_group_solution,1,0),
						(@bz_user_id,@g_group_budget,1,0),
						(@bz_user_id,@g_group_attachment,1,0),
						(@bz_user_id,@g_group_OK_to_pay,1,0),
						(@bz_user_id,@g_group_is_paid,1,0),
						(@bz_user_id,@all_g_flags_group_id,1,0),

				# Sabrina is a member of the following groups

					# Can he create a case for this unit?
					# All the new user can create...
						(@bz_user_id,@create_case_group_id,0,0),
					
					# User can see any case in the product.
					# By default, all users for this product/unit have this too
						(@bz_user_id,@can_see_cases_group_id,0,0),
						
					# User can edit a case for that unit
					# For Sabrina, we know she is allowed to
						(@bz_user_id,@can_edit_case_group_id,0,0),
					
					# User can edit all filed in a case, regardless of its role
					# For Sabrina, we know she is allowed to
					# This is because he is NOT the unit creator
						#(@bz_user_id,@can_edit_all_field_case_group_id,0,0),
					
					# User can edit stakholder/component in the product.
					# For Sabrina, we know she is allowed to
						(@bz_user_id,@can_edit_component_group_id,0,0),
	
					# Is the user a creator of the unit?
					# For Sabrina, we know she is NOT
						#(@bz_user_id,@unit_creator_group_id,0,0),
					
					# Group to show/hide cases to some stakeholders:
					# For Sabrina, we know she is stakeholder 1
						(@bz_user_id,@are_users_stakeholder_1_group_id,0,0),
						#(@bz_user_id,@are_users_stakeholder_2_group_id,0,0),
						#(@bz_user_id,@are_users_stakeholder_3_group_id,0,0),
						#(@bz_user_id,@are_users_stakeholder_4_group_id,0,0),
						#(@bz_user_id,@are_users_stakeholder_5_group_id,0,0),
						
					# Group to show/hide cases to some stakeholders:
					# For Sabrina, we know she is stakeholder 1
					#
						(@bz_user_id,@show_to_stakeholder_1_group_id,0,0),
						#(@bz_user_id,@show_to_stakeholder_2_group_id,0,0),
						#(@bz_user_id,@show_to_stakeholder_3_group_id,0,0),
						#(@bz_user_id,@show_to_stakeholder_4_group_id,0,0),
						#(@bz_user_id,@show_to_stakeholder_5_group_id,0,0),
					
					# Is he an occupant?
					# For Sabrina, the answer is YES
						(@bz_user_id,@are_occupants_group_id,0,0),
						
						(@bz_user_id,@show_to_occupants_group_id,0,0),
					
					# Is he visible in the list of possible assignees?
					# For Sabrina, the answer is YES
						(@bz_user_id,@list_visible_assignees_group_id,0,0),
						
					# Can he see all the other visible assigneed?
					# For Sabrina, the answer is YES
						(@bz_user_id,@see_visible_assignees_group_id,0,0),
					
					# Flags: can he be asked to request?
					# For Sabrina, the answer is YES
						(@bz_user_id,@r_group_next_step,0,0),
						(@bz_user_id,@r_group_solution,0,0),
						(@bz_user_id,@r_group_budget,0,0),
						(@bz_user_id,@r_group_attachment,0,0),
						(@bz_user_id,@r_group_OK_to_pay,0,0),
						(@bz_user_id,@r_group_is_paid,0,0),
						(@bz_user_id,@all_r_flags_group_id,0,0),

					# Flags: can he approve?
					# For Sabrina, the answer is YES
						(@bz_user_id,@g_group_next_step,0,0),
						(@bz_user_id,@g_group_solution,0,0),
						(@bz_user_id,@g_group_budget,0,0),
						(@bz_user_id,@g_group_attachment,0,0),
						(@bz_user_id,@g_group_OK_to_pay,0,0),
						(@bz_user_id,@g_group_is_paid,0,0),
						(@bz_user_id,@all_g_flags_group_id,0,0);

		/*Data for the table `series_categories` */
			INSERT  INTO `series_categories`
				(`id`
				,`name`
				) 
				VALUES 
				# We add user id so that there are no conflicts when we create several users which are identical stakeholer (ex: 2 tenants)
				(NULL,CONCAT(@stakeholder,'_P',@product_id,'_U',@bz_user_id));

			# We need to know the value of the other series category we need.
				# This is the command if the series has already been created
				# We do not use this option since we know the series has NOT been created yet
					#SET @series_3 = (SELECT `id` FROM `series_categories` WHERE `name` = CONCAT(@stakeholder,'_P',@product_id,'_U',@bz_user_id));
				
				# We know that this in is a new series, we increment the variable.
					SET @series_3 = (@series_3+1);
					
					
		/*Data for the table `series` */
		# This is so that we can see historical data and how a case is evolving
		# This can only be done after the series categories have been created
	
			INSERT  INTO `series`
				(`series_id`
				,`creator`
				,`category`
				,`subcategory`
				,`name`
				,`frequency`
				,`query`
				,`is_public`
				) 
				VALUES 
				(NULL,@bz_user_id,@series_1,@series_3,'All Open',1,CONCAT('field0-0-0=resolution&type0-0-0=notregexp&value0-0-0=.&product=Test%Unit%1%A&component=', @stakeholder),1),
				(NULL,@bz_user_id,@series_1,@series_3,'All Closed',1,CONCAT('field0-0-0=resolution&type0-0-0=regexp&value0-0-0=.&product=Test%Unit%1%A&component=', @stakeholder),1);

		/*Data for the table `audit_log` */
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
				(@user_creator_bz_user_id,'Bugzilla::Group',@create_case_group_id,'__create__',NULL,CONCAT(@unit,' #',@product_id,' - ', @stakeholder,' - Created by: ',@user_creator_pub_name),@timestamp),
				(@user_creator_bz_user_id,'Bugzilla::Component',@component_id,'__create__',NULL,@stakeholder,@timestamp);

# We now Create the different things for the Company Management Co (a property Management firm)
#
# Management Company is linked to several unee-t users:
# 	- The Generic user that is visible to all the other roles: BZ user_id = 13
# 	- Marina (BZ user_id = 8): A manager
# 	- Celeste (BZ user_id = 6): An employee in charge of product/unit 1 in Marina team 
# 	- Jocelyn (BZ user_id = 7): Another employee in Marina team.
#
# We first need to create the Generic objects (created by Marina)

	# We do NOT need to create the unit here.
	# BUT We need to Make sure that the the component for this Unit is correct
	
	# We also want to show the publicly visible information for Management Co.
		# His public name
			SET @stakeholder_pub_name = 'Management Co';
		# More details
			SET @stakeholder_more = 'management.co@example.com - We take best care of your unit';
		# Se we can create the public info too
			SET @stakeholder_pub_info = CONCAT(@stakeholder_pub_name,' - ', @stakeholder_more);
		
	# We Need the BZ user information for Management Co
		SET @bz_user_id = 13;

	# User role: this is an id in the table `ut_role_types` for easier manipulation, update and maintenance
		SET @role_type_id = 4;

	# Is this user an occupant of the unit?
	#	- 1 = TRUE
	#	- 0 = FALSE
		SET @is_occupant = 0;

	# We Need the BZ user information for the creator of the new user too (Marina)
		SET @user_creator_bz_user_id = 8;
			
		# His public name 
		# We have this as a variable in this script.
		# this should be stored somewhere in the MEFE
		# we do not need to recreate this in the context of the script to create DEMO users.
			# SET @user_creator_pub_name = 'Marina';
		# More details
			#SET @user_creator_more ='Team Lead';
		# Se we can create the public info too
			#SET @user_creator_pub_info = CONCAT(@user_creator_pub_name,' - ', @user_creator_more);

	# OPTIONAL INFORMATION:
	#
	# We need to know if this user can 
	#	- see all other user (1) 
	#		In this case this user will be a member of the group `@list_visible_assignees_group_id`
	#		for this product/unit.
	#	- see only the people in the same role/stakeholder group. (0)
	# 		Else this user will NOT be a member of the group `@list_visible_assignees_group_id`
	#		for this product/unit.
	# By Default, the user is visible to all other user.
		SET @user_is_public = 1; 
	#
	# We need to know if this user is 
	#	- visible to all other user (1) 
	#		In this case this user will be a member of the group `@see_visible_assignees_group_id`
	#		for this product/unit.
	#	- visible only to people in the same role/stakeholder group. (1)
	# 		Else this user will NOT be a member of the group `@see_visible_assignees_group_id`
	#		for this product/unit.
	# By Default, the user is visible to all other user.
		SET @user_can_see_public = 0; 

	#
	# By default the new user can approve all flags but we want flexibility there 
	# We know this might not be always true for all BZ user we create
		SET @can_be_asked_to_approve = 1;

	# By default the new user can approve all flags but we want flexibility there 
	# We know this might not be always true for all BZ user we create
		SET @can_approve = 0;
	#
	# Is the user allowed to create new users?
		# only in the same group of stakholders
			SET @can_create_same_stakeholder = 0;
		
		# in ANY group of stakeholders
			SET @can_create_any_stakeholder = 0;
	
	# Is this user allowed to decided who can be requestee and grant Flags?
		SET @can_approve_user_for_flag = 0;
		
	# Is this user is allowed to decided who is visible in the list of assignee?
		SET @can_decide_if_user_is_visible = 0;
		
	# Is this user is allowed to decided if a new user can see visible assignees?
		SET @can_decide_if_user_can_see_visible = 0;

	# We have everything - Onward for Management Co!
	
		# We DISABLE the FK check
			SET FOREIGN_KEY_CHECKS = 0;
	
		# Get the additional variable that we need
			# When is this happening?
				SET @timestamp = NOW();

			# We get the login name from the user_id
				SET @login_name = (SELECT `login_name` FROM `profiles` WHERE `userid`=@bz_user_id);
				SET @user_creator_login_name = (SELECT `login_name` FROM `profiles` WHERE `userid`=@user_creator_bz_user_id);

			# We get the Stakeholder designation from the `ut_role_types` table
			# this makes it easy to maintain
				SET @stakeholder = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=@role_type_id);

			# We get the Stakeholder Generic description for the BZFE from the `ut_role_types` table
			# this makes it easy to maintain
				SET @stakeholder_g_description = (SELECT `bz_description` FROM `ut_role_types` WHERE `id_role_type`=@role_type_id);

			# The 'visibility' explanation
				SET @visibility_explanation = CONCAT(@visibility_explanation_1,@stakeholder,@visibility_explanation_2);

	# We need to know if this is the first time we have created a user with this role.
	#
	# If this was any other scenario, we will need to check if we already have a record in the table `ut_product_group`
	# The check is to test if we have a record in the table `ut_product_group` where
	# `product_id` = @product_id AND `role_type_id` = @role_type_id AND `group_type_id` = 2
	# `group_type_id` = 2 is the group to grant access to product/units and bugs/cases.
	# if we have one, no need to create a component/stakholder or any group
	# we just need 
	#	1- to grant membership in this group to the new user so that it can access this
	#		unit and the cases in this unit.
	#	2- Check the group_id that makes this user visible to other users for this product (also in the table `ut_product_group`)
	#	3- Check the group_id that makes this user see the other users for this product (also in the table `ut_product_group`)
	#	4- Check the group_id that allow users to be asked for flag approvals for this product (also in the table `ut_product_group`)
	#	5- Check the group_id that allow users to approve flag for this product (also in the table `ut_product_group`)
	#
	# This is for Demo, we know this is the first time we create a Management Company.
	# We need to:
	# We need to:
	#	- Create the component
	#	- Create the groups
	#	- Update the table `ut_product_group`
	#	- Make sure the groups are properly configured
	#	- Make sure that this new users is granted the membership in the group he needs

		/*Data for the table `ut_map_user_unit_details` */
		# Update the Unee-T table that records information about the user:
			INSERT INTO `ut_map_user_unit_details`
							(`id_user_unit`
							, `created`
							, `record_created_by`
							, `is_obsolete`
							, `user_id`
							, `bz_profile_id`
							, `bz_unit_id`
							, `role_type_id`
							, `is_occupant`
							, `is_public_assignee`
							, `is_see_visible_assignee`
							, `is_flag_requestee`
							, `is_flag_approver`
							, `can_create_any_sh`
							, `can_create_same_sh`
							, `can_approve_user_for_flags`
							, `can_decide_if_user_visible`
							, `can_decide_if_user_can_see_visible`
							, `public_name`
							, `more_info`
							, `comment`
							)
							VALUES
							(NULL,@timestamp,@user_creator_bz_user_id,0,NULL,@bz_user_id,@product_id,@role_type_id,@is_occupant,@user_is_public,@user_can_see_public,@can_be_asked_to_approve,@can_approve,@can_create_any_stakeholder,@can_create_same_stakeholder,@can_approve_user_for_flag,@can_decide_if_user_is_visible,@can_decide_if_user_can_see_visible
							,@stakeholder_pub_name,@stakeholder_more,'');
	
		/*Data for the table `components` */
		# We insert the correct values for the component/stakeholder.
			INSERT  INTO `components`
				(`id`
				,`name`
				,`product_id`
				,`initialowner`
				,`initialqacontact`
				,`description`
				,`isactive`
				) 
				VALUES 
				(NULL,@stakeholder,@product_id,@bz_user_id,@bz_user_id,CONCAT(@stakeholder_g_description, ' \r\ ', @stakeholder_pub_info),1);

		# In order to to populate other table (flags, audit table,...), we need to get the newly created component_id
			SET @component_id = LAST_INSERT_ID();

		/*Data for the table `component_cc` */
		# We have NOT added a new user as another stakeholder in stakeholder group that already has users.
		# Nothing to do here
			
		/*Data for the table `groups` */
		# We have created all the groups we needed when we created the unit
		# We have no need to re-create these groups.


		/*Data for the table `group_group_map` */
		# We have created all the groups we needed when we created the unit
		# Nothing to do here
		
		/*Data for the table `group_control_map` */
		# We have created all the groups we needed when we created the unit
		# Nothing to do here
	
		/*Data for the table `user_group_map` */
		# The groups have been defined, we can now tell which group the BZ users needs access to.

	
##################################################################################
# WE NEED TO MAKE THIS A CONDITIONAL THING TO MAKE THIS SCRIPT MORE VERSATILE
#	- Is the user the creator of the unit?
#	- What is the role_type_id for that user?
#	- Is the user an occupant?
#	- Is this user publicly visible?
#	- Can this user see the publicly visible users?
#	- Can this user be asked to approved flags?
#	- Can this user approve flags?
#	- Is the user allowed to create more users?
#		- In the same group of Stakholder
#		- In ANY group of stakeholder
#		- Can decide who can be requestee and grant Flags
#		- Can decided who is visible in the list of assignee
#		- Can decided if a new user can see visible assignees
#		- 
#
# The consequences of the answers to these questions are:
#	- If user is the creator of the unit, we make him a member of:
#		- @unit_creator_group_id
#	- If user is in the role [n] then we make him a member of THE groups
#		- @are_users_stakeholder_[n]_group_id
#		- @show_to_stakeholder_[all but n]_group_id
# 	- If the user is an occupant then make him a member of
#		- @are_occupants_group_id
# 	- If the user is NOT an occupant then make him a member of
#		- @show_to_occupants_group_id
#	- If the user is publicly visible then make him a member of
#		- @list_visible_assignees_group_id
#	- If the user can see the publicly visible users then make him a member of
#		- @see_visible_assignees_group_id
#	- If the user can be asked to approved flags then make him a member of
#		- @r_group_next_step
#		- @r_group_solution
#		- @r_group_budget
#		- @r_group_attachment
#		- @r_group_OK_to_pay
#		- @r_group_is_paid
#		- @all_r_flags_group_id
#	- If the user is allowed to approve flags then make him a member of
#		- @g_group_next_step
#		- @g_group_solution
#		- @g_group_budget
#		- @g_group_attachment
#		- @g_group_OK_to_pay
#		- @g_group_is_paid
#		- @all_g_flags_group_id
#
# Creation of new users:
#	- If the user is allowed to create more users in ANY group of stakeholder 
#		then he is granted permissions to add users to
#		- @create_case_group_id
#		- @are_users_stakeholder_1_group_id
#		- @are_users_stakeholder_2_group_id
#		- @are_users_stakeholder_3_group_id
#		- @are_users_stakeholder_4_group_id
#		- @are_users_stakeholder_5_group_id
#		- @show_to_stakeholder_1_group_id
#		- @show_to_stakeholder_2_group_id
#		- @show_to_stakeholder_3_group_id
#		- @show_to_stakeholder_4_group_id
#		- @show_to_stakeholder_5_group_id
#		- @are_occupants_group_id
#		- @show_to_occupants_group_id
#
#	- If the user is allowed to create more users only in the same group of stakeholder [n] 
#		then he is granted permissions to add users to
#		- @create_case_group_id
#		- @are_users_stakeholder_[n]_group_id
#		- @show_to_stakeholder_[all but n]_group_id
#		- @are_occupants_group_id
#		- @show_to_occupants_group_id
#
#	- If the user can decided who is visible in the list of assignee
#		- @list_visible_assignees_group_id
#
#	- If the user can decided if a new user can see visible assignees
#		- @see_visible_assignees_group_id
#
#	- If the user can decide who can be requestee and grant Flags
#		- @r_group_next_step
#		- @r_group_solution
#		- @r_group_budget
#		- @r_group_attachment
#		- @r_group_OK_to_pay
#		- @r_group_is_paid
#		- @g_group_next_step
#		- @g_group_solution
#		- @g_group_budget
#		- @g_group_attachment
#		- @g_group_OK_to_pay
#		- @g_group_is_paid
#		- @all_r_flags_group_id
#		- @all_g_flags_group_id
#
##################################################################################

		INSERT  INTO `user_group_map`
			(`user_id`
			,`group_id`
			,`isbless`
			,`grant_type`
			) 
			VALUES 
			# Permission for the user we created:
				# Permission to GRANT Membership to the following groups
					# A user is the creator: this is true so he can add more users and stakholders there
						#(@bz_user_id,@unit_creator_group_id,1,0),
						
					# A user can create a case for this unit? This is true so he can add more users and stakholders there
					# For Generic user Management Co, we know he is NOT allowed to
						#(@bz_user_id,@create_case_group_id,1,0),
						
					# A user can create a case for this unit? This is true so he can add more users and stakholders there
					# For Generic user Management Co, we know he is NOT allowed to
						#(@bz_user_id,@create_case_group_id,1,0),
						
					# A User can edit all filed in a case, regardless of its role
					# For Generic user Management Co, we know he is allowed to
					# This is because he NOT is he unit creator
						#(@bz_user_id,@can_edit_all_field_case_group_id,1,0),
					
					# A User can edit stakholder/component in the product.
					# For Generic user Management Co, we know he is NOT allowed to
						#(@bz_user_id,@can_edit_component_group_id,1,0),
							
					# A user can create a case for this unit? This is true so he can add more users and stakholders there
					# For Generic user Management Co, we know he is NOT allowed to
						#(@bz_user_id,@create_case_group_id,1,0),
						
						
					# A user is a stakeholder: This is true so he can add more users and stakholders there
					# For Generic user Management Co, we know he is NOT allowed to create other users
						#(@bz_user_id,@are_users_stakeholder_1_group_id,1,0),
						#(@bz_user_id,@are_users_stakeholder_2_group_id,1,0),
						#(@bz_user_id,@are_users_stakeholder_3_group_id,1,0),
						#(@bz_user_id,@are_users_stakeholder_4_group_id,1,0),
						#(@bz_user_id,@are_users_stakeholder_5_group_id,1,0),
						#(@bz_user_id,@show_to_stakeholder_1_group_id,1,0),
						#(@bz_user_id,@show_to_stakeholder_2_group_id,1,0),
						#(@bz_user_id,@show_to_stakeholder_3_group_id,1,0),
						#(@bz_user_id,@show_to_stakeholder_4_group_id,1,0),
						#(@bz_user_id,@show_to_stakeholder_5_group_id,1,0),
					
					# A user is an occupant: This is true so he can add more users and stakholders there
					# For Generic user Management Co, we know he is NOT allowed to
						#(@bz_user_id,@are_occupants_group_id,1,0),
						#(@bz_user_id,@show_to_occupants_group_id,1,0),
					
					# A user is a visible assignee: This is true so he can add more users and stakholders there
					# For Generic user Management Co, we know he NOT is allowed to
						#(@bz_user_id,@list_visible_assignees_group_id,1,0),
						
					# A user can see visible assignees: This is true so he can add more users and stakholders there
					# For Generic user Management Co, we know he NOT is allowed to
						#(@bz_user_id,@see_visible_assignees_group_id,1,0),
					
					# A user can be asked to approve flags: This is true so he can add more users and stakholders there
					# For Generic user Management Co, we know he NOT is allowed to
						#(@bz_user_id,@r_group_next_step,1,0),
						#(@bz_user_id,@r_group_solution,1,0),
						#(@bz_user_id,@r_group_budget,1,0),
						#(@bz_user_id,@r_group_attachment,1,0),
						#(@bz_user_id,@r_group_OK_to_pay,1,0),
						#(@bz_user_id,@r_group_is_paid,1,0),
						#(@bz_user_id,@all_r_flags_group_id,1,0),
					
					# A user can approve flags: This is true so he can add more users and stakholders there
					# For Generic user Management Co, we know he NOT is allowed to
						#(@bz_user_id,@g_group_next_step,1,0),
						#(@bz_user_id,@g_group_solution,1,0),
						#(@bz_user_id,@g_group_budget,1,0),
						#(@bz_user_id,@g_group_attachment,1,0),
						#(@bz_user_id,@g_group_OK_to_pay,1,0),
						#(@bz_user_id,@g_group_is_paid,1,0),
						#(@bz_user_id,@all_g_flags_group_id,1,0),

				# Generic user Management Co is a member of the following groups

					# Can he create a case for this unit?
					# All the new user can create...
						(@bz_user_id,@create_case_group_id,0,0),
					
					# User can see any case in the product.
					# By default, all users for this product/unit have this too
						(@bz_user_id,@can_see_cases_group_id,0,0),
					
					# User can edit a case for that unit
					# For Generic user Management Co, we know she is allowed to
						#(@bz_user_id,@can_edit_case_group_id,0,0),
						
					# User can edit all filed in a case, regardless of its role
					# For Generic user Management Co, we know she is allowed to
					# This is because he is NOT the unit creator
						#(@bz_user_id,@can_edit_all_field_case_group_id,0,0),
					
					# User can edit stakholder/component in the product.
					# For Generic user Management Co, we know he NOT is allowed to
						#(@bz_user_id,@can_edit_component_group_id,0,0),
	
					# Is the user a creator of the unit?
					# For Generic user Management Co, we know he is NOT
						#(@bz_user_id,@unit_creator_group_id,0,0),

					# Is the user a creator of the unit?
					# For Generic user Management Co, we know he is NOT
						#(@bz_user_id,@unit_creator_group_id,0,0),
					
					# Group to show/hide cases to some stakeholders:
					# For Generic user Management Co, we know he is stakeholder 4
						#(@bz_user_id,@are_users_stakeholder_1_group_id,0,0),
						#(@bz_user_id,@are_users_stakeholder_2_group_id,0,0),
						#(@bz_user_id,@are_users_stakeholder_3_group_id,0,0),
						(@bz_user_id,@are_users_stakeholder_4_group_id,0,0),
						#(@bz_user_id,@are_users_stakeholder_5_group_id,0,0),
						
					# Group to show/hide cases to some stakeholders:
					# For Generic user Management Co, we know he is stakeholder 4
					#
						#(@bz_user_id,@show_to_stakeholder_1_group_id,0,0),
						#(@bz_user_id,@show_to_stakeholder_2_group_id,0,0),
						#(@bz_user_id,@show_to_stakeholder_3_group_id,0,0),
						(@bz_user_id,@show_to_stakeholder_4_group_id,0,0),
						#(@bz_user_id,@show_to_stakeholder_5_group_id,0,0),
					
					# Is he an occupant?
					# For Generic user Management Co, the answer is NO
						#(@bz_user_id,@are_occupants_group_id,0,0),
						
						#(@bz_user_id,@show_to_occupants_group_id,0,0),

					# Is he visible in the list of possible assignees?
					# For Generic user Management Co, the answer is YES
						(@bz_user_id,@list_visible_assignees_group_id,0,0),
						
					# Can he see all the other visible assigneed?
					# For Generic user Management Co, the answer is NO
						#(@bz_user_id,@see_visible_assignees_group_id,0,0),
					
					# Flags: can he be asked to request?
					# For Generic user Management Co, the answer is YES
						#(@bz_user_id,@r_group_next_step,0,0),
						#(@bz_user_id,@r_group_solution,0,0),
						#(@bz_user_id,@r_group_budget,0,0),
						#(@bz_user_id,@r_group_attachment,0,0),
						#(@bz_user_id,@r_group_OK_to_pay,0,0),
						#(@bz_user_id,@r_group_is_paid,0,0),
						#(@bz_user_id,@all_r_flags_group_id,0,0);

					# Flags: can he approve?
					# For Generic user Management Co, the answer is NO
						(@bz_user_id,@g_group_next_step,0,0),
						(@bz_user_id,@g_group_solution,0,0),
						(@bz_user_id,@g_group_budget,0,0),
						(@bz_user_id,@g_group_attachment,0,0),
						(@bz_user_id,@g_group_OK_to_pay,0,0),
						(@bz_user_id,@g_group_is_paid,0,0),
						(@bz_user_id,@all_g_flags_group_id,0,0);

		/*Data for the table `series_categories` */
			INSERT  INTO `series_categories`
				(`id`
				,`name`
				) 
				VALUES 
				# We add user id so that there are no conflicts when we create several users which are identical stakeholer (ex: 2 tenants)
				(NULL,CONCAT(@stakeholder,'_P',@product_id,'_U',@bz_user_id));

			# We need to know the value of the other series category we need.
				# This is the command if the series has already been created
				# We do not use this option since we know the series has NOT been created yet
					#SET @series_3 = (SELECT `id` FROM `series_categories` WHERE `name` = CONCAT(@stakeholder,'_P',@product_id,'_U',@bz_user_id));
				
				# We know that this in is a new series, we increment the variable.
					SET @series_3 = (@series_3+1);
					
					
		/*Data for the table `series` */
		# This is so that we can see historical data and how a case is evolving
		# This can only be done after the series categories have been created
	
			INSERT  INTO `series`
				(`series_id`
				,`creator`
				,`category`
				,`subcategory`
				,`name`
				,`frequency`
				,`query`
				,`is_public`
				) 
				VALUES 
				(NULL,@bz_user_id,@series_1,@series_3,'All Open',1,CONCAT('field0-0-0=resolution&type0-0-0=notregexp&value0-0-0=.&product=Test%Unit%1%A&component=', @stakeholder),1),
				(NULL,@bz_user_id,@series_1,@series_3,'All Closed',1,CONCAT('field0-0-0=resolution&type0-0-0=regexp&value0-0-0=.&product=Test%Unit%1%A&component=', @stakeholder),1);

		/*Data for the table `audit_log` */
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
				(@user_creator_bz_user_id,'Bugzilla::Group',@create_case_group_id,'__create__',NULL,CONCAT(@unit,' #',@product_id,' - ', @stakeholder,' - Created by: ',@user_creator_pub_name),@timestamp),
				(@user_creator_bz_user_id,'Bugzilla::Component',@component_id,'__create__',NULL,@stakeholder,@timestamp);

	# We now Create the Privileges for Marina
	#   - Marina is the team lead for Management Company
	# 	Her `id_role_type` in the table `ut_role_types` = 4
	# 	She is also an occupant of the unit.

	# We do NOT need to create the unit here.
	# We do NOT need to create a new component/stakholder
	# We do NOT need to create new groups
	# We 'Just' need to grant the correct group memberships to Marina for the correct product/unit and component/stakholder/role

		# We do NOT need to create the unit here.
	# BUT We need to Make sure that the the component for this Unit is correct
	
	# We also want to show the publicly visible information for Management Co.
		# His public name
			SET @stakeholder_pub_name = 'Marina';
		# More details
			SET @stakeholder_more = 'Team Lead';
		# Se we can create the public info too
			SET @stakeholder_pub_info = CONCAT(@stakeholder_pub_name,' - ', @stakeholder_more);
		
	# We Need the BZ user information for Marina
		SET @bz_user_id = 8;

	# User role: this is an id in the table `ut_role_types` for easier manipulation, update and maintenance
		SET @role_type_id = 4;

	# Is this user an occupant of the unit?
	#	- 1 = TRUE
	#	- 0 = FALSE
		SET @is_occupant = 0;

	# We Need the BZ user information for the creator of the new user too (Marina)
		SET @user_creator_bz_user_id = 8;
			
		# His public name 
		# We have this as a variable in this script.
		# this should be stored somewhere in the MEFE
		# we do not need to recreate this in the context of the script to create DEMO users.
			# SET @user_creator_pub_name = 'Marina';
		# More details
			#SET @user_creator_more ='Team Lead';
		# Se we can create the public info too
			#SET @user_creator_pub_info = CONCAT(@user_creator_pub_name,' - ', @user_creator_more);

	# OPTIONAL INFORMATION:
	#
	# We need to know if this user can 
	#	- see all other user (1) 
	#		In this case this user will be a member of the group `@list_visible_assignees_group_id`
	#		for this product/unit.
	#	- see only the people in the same role/stakeholder group. (0)
	# 		Else this user will NOT be a member of the group `@list_visible_assignees_group_id`
	#		for this product/unit.
	# By Default, the user is visible to all other user.
		SET @user_is_public = 0; 
	#
	# We need to know if this user is 
	#	- visible to all other user (1) 
	#		In this case this user will be a member of the group `@see_visible_assignees_group_id`
	#		for this product/unit.
	#	- visible only to people in the same role/stakeholder group. (1)
	# 		Else this user will NOT be a member of the group `@see_visible_assignees_group_id`
	#		for this product/unit.
	# By Default, the user is visible to all other user.
		SET @user_can_see_public = 1; 

	#
	# By default the new user can approve all flags but we want flexibility there 
	# We know this might not be always true for all BZ user we create
		SET @can_be_asked_to_approve = 0;

	# By default the new user can approve all flags but we want flexibility there 
	# We know this might not be always true for all BZ user we create
		SET @can_approve = 1;
	#
	# Is the user allowed to create new users?
		# only in the same group of stakholders
			SET @can_create_same_stakeholder = 1;
		
		# in ANY group of stakeholders
			SET @can_create_any_stakeholder = 0;
	
	# Is this user allowed to decided who can be requestee and grant Flags?
		SET @can_approve_user_for_flag = 1;
		
	# Is this user is allowed to decided who is visible in the list of assignee?
		SET @can_decide_if_user_is_visible = 1;
		
	# Is this user is allowed to decided if a new user can see visible assignees?
		SET @can_decide_if_user_can_see_visible = 1;

	# We have everything - Onward for Management Co!
	
		# We DISABLE the FK check
			SET FOREIGN_KEY_CHECKS = 0;
	
		# Get the additional variable that we need
			# When is this happening?
				SET @timestamp = NOW();

			# We get the login name from the user_id
				SET @login_name = (SELECT `login_name` FROM `profiles` WHERE `userid`=@bz_user_id);
				SET @user_creator_login_name = (SELECT `login_name` FROM `profiles` WHERE `userid`=@user_creator_bz_user_id);

			# We get the Stakeholder designation from the `ut_role_types` table
			# this makes it easy to maintain
				SET @stakeholder = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=@role_type_id);

			# We get the Stakeholder Generic description for the BZFE from the `ut_role_types` table
			# this makes it easy to maintain
				SET @stakeholder_g_description = (SELECT `bz_description` FROM `ut_role_types` WHERE `id_role_type`=@role_type_id);

			# The 'visibility' explanation
				SET @visibility_explanation = CONCAT(@visibility_explanation_1,@stakeholder,@visibility_explanation_2);

	# We need to know if this is the first time we have created a user with this role.
	#
	# If this was any other scenario, we will need to check if we already have a record in the table `ut_product_group`
	# The check is to test if we have a record in the table `ut_product_group` where
	# `product_id` = @product_id AND `role_type_id` = @role_type_id AND `group_type_id` = 2
	# `group_type_id` = 2 is the group to grant access to product/units and bugs/cases.
	# if we have one, no need to create a component/stakholder or any group
	# we just need 
	#	1- to grant membership in this group to the new user so that it can access this
	#		unit and the cases in this unit.
	#	2- Check the group_id that makes this user visible to other users for this product (also in the table `ut_product_group`)
	#	3- Check the group_id that makes this user see the other users for this product (also in the table `ut_product_group`)
	#	4- Check the group_id that allow users to be asked for flag approvals for this product (also in the table `ut_product_group`)
	#	5- Check the group_id that allow users to approve flag for this product (also in the table `ut_product_group`)
	#
	# This is for Demo, we know this is NOT the first time we create a Management Company.
	# We need to:
	# We need to:
	#	- Create the component
	#	- Create the groups
	#	- Update the table `ut_product_group`
	#	- Make sure the groups are properly configured
	#	- Make sure that this new users is granted the membership in the group he needs

		/*Data for the table `ut_map_user_unit_details` */
		# Update the Unee-T table that records information about the user:
			INSERT INTO `ut_map_user_unit_details`
							(`id_user_unit`
							, `created`
							, `record_created_by`
							, `is_obsolete`
							, `user_id`
							, `bz_profile_id`
							, `bz_unit_id`
							, `role_type_id`
							, `is_occupant`
							, `is_public_assignee`
							, `is_see_visible_assignee`
							, `is_flag_requestee`
							, `is_flag_approver`
							, `can_create_any_sh`
							, `can_create_same_sh`
							, `can_approve_user_for_flags`
							, `can_decide_if_user_visible`
							, `can_decide_if_user_can_see_visible`
							, `public_name`
							, `more_info`
							, `comment`
							)
							VALUES
							(NULL,@timestamp,@user_creator_bz_user_id,0,NULL,@bz_user_id,@product_id,@role_type_id,@is_occupant,@user_is_public,@user_can_see_public,@can_be_asked_to_approve,@can_approve,@can_create_any_stakeholder,@can_create_same_stakeholder,@can_approve_user_for_flag,@can_decide_if_user_is_visible,@can_decide_if_user_can_see_visible
							,@stakeholder_pub_name,@stakeholder_more,'');

		/*Data for the table `components` */
		# We insert the correct values for the component/stakeholder.
		# Nothing to do here

		# In order to to populate other table (flags, audit table,...), we need to get the newly created component_id
			SET @component_id = LAST_INSERT_ID();

		/*Data for the table `component_cc` */
		# We have NOT added a new user as another stakeholder in stakeholder group that already has users.
		#		We only do that for
		#			- Tenant
		#			- Landlord
		# Nothing to do here
			
		/*Data for the table `groups` */
		# We have created all the groups we needed when we created the unit
		# We have no need to re-create these groups.


		/*Data for the table `group_group_map` */
		# We have created all the groups we needed when we created the unit
		# Nothing to do here
		
		/*Data for the table `group_control_map` */
		# We have created all the groups we needed when we created the unit
		# Nothing to do here
	
		/*Data for the table `user_group_map` */
		# The groups have been defined, we can now tell which group the BZ users needs access to.

##################################################################################
# WE NEED TO MAKE THIS A CONDITIONAL THING TO MAKE THIS SCRIPT MORE VERSATILE
#	- Is the user the creator of the unit?
#	- What is the role_type_id for that user?
#	- Is the user an occupant?
#	- Is this user publicly visible?
#	- Can this user see the publicly visible users?
#	- Can this user be asked to approved flags?
#	- Can this user approve flags?
#	- Is the user allowed to create more users?
#		- In the same group of Stakholder
#		- In ANY group of stakeholder
#		- Can decide who can be requestee and grant Flags
#		- Can decided who is visible in the list of assignee
#		- Can decided if a new user can see visible assignees
#		- 
#
# The consequences of the answers to these questions are:
#	- If user is the creator of the unit, we make him a member of:
#		- @unit_creator_group_id
#	- If user is in the role [n] then we make him a member of THE groups
#		- @are_users_stakeholder_[n]_group_id
#		- @show_to_stakeholder_[all but n]_group_id
# 	- If the user is an occupant then make him a member of
#		- @are_occupants_group_id
# 	- If the user is NOT an occupant then make him a member of
#		- @show_to_occupants_group_id
#	- If the user is publicly visible then make him a member of
#		- @list_visible_assignees_group_id
#	- If the user can see the publicly visible users then make him a member of
#		- @see_visible_assignees_group_id
#	- If the user can be asked to approved flags then make him a member of
#		- @r_group_next_step
#		- @r_group_solution
#		- @r_group_budget
#		- @r_group_attachment
#		- @r_group_OK_to_pay
#		- @r_group_is_paid
#		- @all_r_flags_group_id
#	- If the user is allowed to approve flags then make him a member of
#		- @g_group_next_step
#		- @g_group_solution
#		- @g_group_budget
#		- @g_group_attachment
#		- @g_group_OK_to_pay
#		- @g_group_is_paid
#		- @all_g_flags_group_id
#
# Creation of new users:
#	- If the user is allowed to create more users in ANY group of stakeholder 
#		then he is granted permissions to add users to
#		- @create_case_group_id
#		- @are_users_stakeholder_1_group_id
#		- @are_users_stakeholder_2_group_id
#		- @are_users_stakeholder_3_group_id
#		- @are_users_stakeholder_4_group_id
#		- @are_users_stakeholder_5_group_id
#		- @show_to_stakeholder_1_group_id
#		- @show_to_stakeholder_2_group_id
#		- @show_to_stakeholder_3_group_id
#		- @show_to_stakeholder_4_group_id
#		- @show_to_stakeholder_5_group_id
#		- @are_occupants_group_id
#		- @show_to_occupants_group_id
#
#	- If the user is allowed to create more users only in the same group of stakeholder [n] 
#		then he is granted permissions to add users to
#		- @create_case_group_id
#		- @are_users_stakeholder_[n]_group_id
#		- @show_to_stakeholder_[all but n]_group_id
#		- @are_occupants_group_id
#		- @show_to_occupants_group_id
#
#	- If the user can decided who is visible in the list of assignee
#		- @list_visible_assignees_group_id
#
#	- If the user can decided if a new user can see visible assignees
#		- @see_visible_assignees_group_id
#
#	- If the user can decide who can be requestee and grant Flags
#		- @r_group_next_step
#		- @r_group_solution
#		- @r_group_budget
#		- @r_group_attachment
#		- @r_group_OK_to_pay
#		- @r_group_is_paid
#		- @g_group_next_step
#		- @g_group_solution
#		- @g_group_budget
#		- @g_group_attachment
#		- @g_group_OK_to_pay
#		- @g_group_is_paid
#		- @all_r_flags_group_id
#		- @all_g_flags_group_id
#
##################################################################################

		INSERT  INTO `user_group_map`
			(`user_id`
			,`group_id`
			,`isbless`
			,`grant_type`
			) 
			VALUES 
			# Permission for the user we created:
				# Permission to GRANT Membership to the following groups
					# A user is the creator: this is true so he can add more users and stakholders there
						#(@bz_user_id,@unit_creator_group_id,1,0),
						
					# A user can create a case for this unit? This is true so he can add more users and stakholders there
					# For Marina, we know she is allowed to
						(@bz_user_id,@create_case_group_id,1,0),
					
					# A user can see cases in the product.
					# For Marina, we know she is allowed to
						(@bz_user_id,@can_see_cases_group_id,1,0),
								
					# A user can edit a case for that unit
					# For Marina, we know she is allowed to
						(@bz_user_id,@can_edit_case_group_id,1,0),
					
					# A user can edit all filed in a case, regardless of its role
					# For Marina, we know she is NOT allowed to
					# This is because he is NOT the unit creator
						#(@bz_user_id,@can_edit_all_field_case_group_id,1,0),
					
					# A user can edit stakholder/component in the product.
					# For Marina, we know she is allowed to
						(@bz_user_id,@can_edit_component_group_id,1,0),
										
					# A user is a stakeholder: This is true so he can add more users and stakholders there
					# For Marina, we know she is allowed to create other users that are only management company
						#(@bz_user_id,@are_users_stakeholder_1_group_id,1,0),
						#(@bz_user_id,@are_users_stakeholder_2_group_id,1,0),
						#(@bz_user_id,@are_users_stakeholder_3_group_id,1,0),
						(@bz_user_id,@are_users_stakeholder_4_group_id,1,0),
						#(@bz_user_id,@are_users_stakeholder_5_group_id,1,0),
						#(@bz_user_id,@show_to_stakeholder_1_group_id,1,0),
						#(@bz_user_id,@show_to_stakeholder_2_group_id,1,0),
						#(@bz_user_id,@show_to_stakeholder_3_group_id,1,0),
						(@bz_user_id,@show_to_stakeholder_4_group_id,1,0),
						#(@bz_user_id,@show_to_stakeholder_5_group_id,1,0),
					
					# A user is an occupant: This is true so he can add more users and stakholders there
					# For Marina, we know she is NOT allowed to
						#(@bz_user_id,@are_occupants_group_id,1,0),
						#(@bz_user_id,@show_to_occupants_group_id,1,0),
					
					# A user is a visible assignee: This is true so he can add more users and stakholders there
					# For Marina, we know she is allowed to
						(@bz_user_id,@list_visible_assignees_group_id,1,0),
						
					# A user can see visible assignees: This is true so he can add more users and stakholders there
					# For Marina, we know she is allowed to
						(@bz_user_id,@see_visible_assignees_group_id,1,0),
					
					# A user can be asked to approve flags: This is true so he can add more users and stakholders there
					# For Marina, we know she is allowed to
						(@bz_user_id,@r_group_next_step,1,0),
						(@bz_user_id,@r_group_solution,1,0),
						(@bz_user_id,@r_group_budget,1,0),
						(@bz_user_id,@r_group_attachment,1,0),
						(@bz_user_id,@r_group_OK_to_pay,1,0),
						(@bz_user_id,@r_group_is_paid,1,0),
						(@bz_user_id,@all_r_flags_group_id,1,0),
					
					# A user can approve flags: This is true so he can add more users and stakholders there
					# For Marina, we know she is allowed to
						(@bz_user_id,@g_group_next_step,1,0),
						(@bz_user_id,@g_group_solution,1,0),
						(@bz_user_id,@g_group_budget,1,0),
						(@bz_user_id,@g_group_attachment,1,0),
						(@bz_user_id,@g_group_OK_to_pay,1,0),
						(@bz_user_id,@g_group_is_paid,1,0),
						(@bz_user_id,@all_g_flags_group_id,1,0),

				# Marina is a member of the following groups

					# Can he create a case for this unit?
					# All the new user can create...
						(@bz_user_id,@create_case_group_id,0,0),
					
					# User can see any case in the product.
					# By default, all users for this product/unit have this too
						(@bz_user_id,@can_see_cases_group_id,0,0),
					
					# User can edit a case for that unit
					# For Marina, we know she is allowed to
						(@bz_user_id,@can_edit_case_group_id,0,0),
					
					# User can edit all filed in a case, regardless of its role
					# For Marina, we know he is allowed to
					# This is because she is NOT the unit creator
						#(@bz_user_id,@can_edit_all_field_case_group_id,0,0),
					
					# User can edit stakholder/component in the product.
					# For Marina, we know she is allowed to
						(@bz_user_id,@can_edit_component_group_id,0,0),

					# Is the user a creator of the unit?
					# For Marina, we know he is NOT
						#(@bz_user_id,@unit_creator_group_id,0,0),
					
					# Group to show/hide cases to some stakeholders:
					# For Marina, we know he is stakeholder 4
						#(@bz_user_id,@are_users_stakeholder_1_group_id,0,0),
						#(@bz_user_id,@are_users_stakeholder_2_group_id,0,0),
						#(@bz_user_id,@are_users_stakeholder_3_group_id,0,0),
						(@bz_user_id,@are_users_stakeholder_4_group_id,0,0),
						#(@bz_user_id,@are_users_stakeholder_5_group_id,0,0),
						
					# Group to show/hide cases to some stakeholders:
					# For Marina, we know she is stakeholder 4
					#
						#(@bz_user_id,@show_to_stakeholder_1_group_id,0,0),
						#(@bz_user_id,@show_to_stakeholder_2_group_id,0,0),
						#(@bz_user_id,@show_to_stakeholder_3_group_id,0,0),
						(@bz_user_id,@show_to_stakeholder_4_group_id,0,0),
						#(@bz_user_id,@show_to_stakeholder_5_group_id,0,0),
					
					# Is he an occupant?
					# For Marina, the answer is NO
						#(@bz_user_id,@are_occupants_group_id,0,0),
						
						#(@bz_user_id,@show_to_occupants_group_id,0,0),
					
					# Is she visible in the list of possible assignees?
					# For Marina, the answer is NO
						#(@bz_user_id,@list_visible_assignees_group_id,0,0),
						
					# Can she see all the other visible assigneed?
					# For Marina, the answer is YES
						(@bz_user_id,@see_visible_assignees_group_id,0,0),
					
					# Flags: can she be asked to request?
					# For Marina, the answer is NO
						#(@bz_user_id,@r_group_next_step,0,0),
						#(@bz_user_id,@r_group_solution,0,0),
						#(@bz_user_id,@r_group_budget,0,0),
						#(@bz_user_id,@r_group_attachment,0,0),
						#(@bz_user_id,@r_group_OK_to_pay,0,0),
						#(@bz_user_id,@r_group_is_paid,0,0),
						#(@bz_user_id,@all_r_flags_group_id,0,0);

					# Flags: can she approve?
					# For Marina, the answer is YES
						(@bz_user_id,@g_group_next_step,0,0),
						(@bz_user_id,@g_group_solution,0,0),
						(@bz_user_id,@g_group_budget,0,0),
						(@bz_user_id,@g_group_attachment,0,0),
						(@bz_user_id,@g_group_OK_to_pay,0,0),
						(@bz_user_id,@g_group_is_paid,0,0),
						(@bz_user_id,@all_g_flags_group_id,0,0);

		/*Data for the table `series_categories` */
		# Nothing to do

		/*Data for the table `series_categories` */
		# Nothing to do
					
		/*Data for the table `series` */
		# Nothing to do

		/*Data for the table `audit_log` */
		# Nothing to do
		
	# We now Create the Privileges for Celeste
	#   - Celeste works for the Management Company Management Co, in charge of this unit.
	#     Her `id_role_type` in the table `ut_role_types` = 4

	# We do NOT need to create the unit here.
	# We do NOT need to create a new component/stakholder
	# We do NOT need to create new groups
	# We 'Just' need to grant the correct group memberships to Celeste for the correct product/unit and component/stakholder/role

		# We do NOT need to create the unit here.
	# BUT We need to Make sure that the the component for this Unit is correct
	
	# We also want to show the publicly visible information for Management Co.
		# His public name
			SET @stakeholder_pub_name = 'Celeste';
		# More details
			SET @stakeholder_more = 'Team Bravo';
		# Se we can create the public info too
			SET @stakeholder_pub_info = CONCAT(@stakeholder_pub_name,' - ', @stakeholder_more);
		
	# We Need the BZ user information for Celeste
		SET @bz_user_id = 6;

	# User role: this is an id in the table `ut_role_types` for easier manipulation, update and maintenance
		SET @role_type_id = 4;

	# Is this user an occupant of the unit?
	#	- 1 = TRUE
	#	- 0 = FALSE
		SET @is_occupant = 0;

	# We Need the BZ user information for the creator of the new user too (Marina)
		SET @user_creator_bz_user_id = 8;
			
		# His public name 
		# We have this as a variable in this script.
		# this should be stored somewhere in the MEFE
		# we do not need to recreate this in the context of the script to create DEMO users.
			# SET @user_creator_pub_name = 'Marina';
		# More details
			#SET @user_creator_more ='Team Lead';
		# Se we can create the public info too
			#SET @user_creator_pub_info = CONCAT(@user_creator_pub_name,' - ', @user_creator_more);

	# OPTIONAL INFORMATION:
	#
	# We need to know if this user can 
	#	- see all other user (1) 
	#		In this case this user will be a member of the group `@list_visible_assignees_group_id`
	#		for this product/unit.
	#	- see only the people in the same role/stakeholder group. (0)
	# 		Else this user will NOT be a member of the group `@list_visible_assignees_group_id`
	#		for this product/unit.
	# By Default, the user is visible to all other user.
		SET @user_is_public = 0; 
	#
	# We need to know if this user is 
	#	- visible to all other user (1) 
	#		In this case this user will be a member of the group `@see_visible_assignees_group_id`
	#		for this product/unit.
	#	- visible only to people in the same role/stakeholder group. (1)
	# 		Else this user will NOT be a member of the group `@see_visible_assignees_group_id`
	#		for this product/unit.
	# By Default, the user is visible to all other user.
		SET @user_can_see_public = 1; 

	#
	# By default the new user can approve all flags but we want flexibility there 
	# We know this might not be always true for all BZ user we create
		SET @can_be_asked_to_approve = 0;

	# By default the new user can approve all flags but we want flexibility there 
	# We know this might not be always true for all BZ user we create
		SET @can_approve = 1;
	#
	# Is the user allowed to create new users?
		# only in the same group of stakholders
			SET @can_create_same_stakeholder = 0;
		
		# in ANY group of stakeholders
			SET @can_create_any_stakeholder = 0;
	
	# Is this user allowed to decided who can be requestee and grant Flags?
		SET @can_approve_user_for_flag = 0;
		
	# Is this user is allowed to decided who is visible in the list of assignee?
		SET @can_decide_if_user_is_visible = 0;
		
	# Is this user is allowed to decided if a new user can see visible assignees?
		SET @can_decide_if_user_can_see_visible = 0;

	# We have everything - Onward for Management Co!
	
		# We DISABLE the FK check
			SET FOREIGN_KEY_CHECKS = 0;
	
		# Get the additional variable that we need
			# When is this happening?
				SET @timestamp = NOW();

			# We get the login name from the user_id
				SET @login_name = (SELECT `login_name` FROM `profiles` WHERE `userid`=@bz_user_id);
				SET @user_creator_login_name = (SELECT `login_name` FROM `profiles` WHERE `userid`=@user_creator_bz_user_id);

			# We get the Stakeholder designation from the `ut_role_types` table
			# this makes it easy to maintain
				SET @stakeholder = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=@role_type_id);

			# We get the Stakeholder Generic description for the BZFE from the `ut_role_types` table
			# this makes it easy to maintain
				SET @stakeholder_g_description = (SELECT `bz_description` FROM `ut_role_types` WHERE `id_role_type`=@role_type_id);

			# The 'visibility' explanation
				SET @visibility_explanation = CONCAT(@visibility_explanation_1,@stakeholder,@visibility_explanation_2);

	# We need to know if this is the first time we have created a user with this role.
	#
	# If this was any other scenario, we will need to check if we already have a record in the table `ut_product_group`
	# The check is to test if we have a record in the table `ut_product_group` where
	# `product_id` = @product_id AND `role_type_id` = @role_type_id AND `group_type_id` = 2
	# `group_type_id` = 2 is the group to grant access to product/units and bugs/cases.
	# if we have one, no need to create a component/stakholder or any group
	# we just need 
	#	1- to grant membership in this group to the new user so that it can access this
	#		unit and the cases in this unit.
	#	2- Check the group_id that makes this user visible to other users for this product (also in the table `ut_product_group`)
	#	3- Check the group_id that makes this user see the other users for this product (also in the table `ut_product_group`)
	#	4- Check the group_id that allow users to be asked for flag approvals for this product (also in the table `ut_product_group`)
	#	5- Check the group_id that allow users to approve flag for this product (also in the table `ut_product_group`)
	#
	# This is for Demo, we know this is NOT the first time we create a Management Company.
	# We need to:
	# We need to:
	#	- Create the component
	#	- Create the groups
	#	- Update the table `ut_product_group`
	#	- Make sure the groups are properly configured
	#	- Make sure that this new users is granted the membership in the group he needs

		/*Data for the table `ut_map_user_unit_details` */
		# Update the Unee-T table that records information about the user:
			INSERT INTO `ut_map_user_unit_details`
							(`id_user_unit`
							, `created`
							, `record_created_by`
							, `is_obsolete`
							, `user_id`
							, `bz_profile_id`
							, `bz_unit_id`
							, `role_type_id`
							, `is_occupant`
							, `is_public_assignee`
							, `is_see_visible_assignee`
							, `is_flag_requestee`
							, `is_flag_approver`
							, `can_create_any_sh`
							, `can_create_same_sh`
							, `can_approve_user_for_flags`
							, `can_decide_if_user_visible`
							, `can_decide_if_user_can_see_visible`
							, `public_name`
							, `more_info`
							, `comment`
							)
							VALUES
							(NULL,@timestamp,@user_creator_bz_user_id,0,NULL,@bz_user_id,@product_id,@role_type_id,@is_occupant,@user_is_public,@user_can_see_public,@can_be_asked_to_approve,@can_approve,@can_create_any_stakeholder,@can_create_same_stakeholder,@can_approve_user_for_flag,@can_decide_if_user_is_visible,@can_decide_if_user_can_see_visible
							,@stakeholder_pub_name,@stakeholder_more,'');
	
		/*Data for the table `components` */
		# We insert the correct values for the component/stakeholder.
		# Nothing to do here

		# In order to to populate other table (flags, audit table,...), we need to get the newly created component_id
			SET @component_id = LAST_INSERT_ID();

		/*Data for the table `component_cc` */
		# We have NOT added a new user as another stakeholder in stakeholder group that already has users.
		#		We only do that for
		#			- Tenant
		#			- Landlord
		# Nothing to do here
			
		/*Data for the table `groups` */
		# We have created all the groups we needed when we created the unit
		# We have no need to re-create these groups.


		/*Data for the table `group_group_map` */
		# We have created all the groups we needed when we created the unit
		# Nothing to do here
		
		/*Data for the table `group_control_map` */
		# We have created all the groups we needed when we created the unit
		# Nothing to do here
	
		/*Data for the table `user_group_map` */
		# The groups have been defined, we can now tell which group the BZ users needs access to.

##################################################################################
# WE NEED TO MAKE THIS A CONDITIONAL THING TO MAKE THIS SCRIPT MORE VERSATILE
#	- Is the user the creator of the unit?
#	- What is the role_type_id for that user?
#	- Is the user an occupant?
#	- Is this user publicly visible?
#	- Can this user see the publicly visible users?
#	- Can this user be asked to approved flags?
#	- Can this user approve flags?
#	- Is the user allowed to create more users?
#		- In the same group of Stakholder
#		- In ANY group of stakeholder
#		- Can decide who can be requestee and grant Flags
#		- Can decided who is visible in the list of assignee
#		- Can decided if a new user can see visible assignees
#		- 
#
# The consequences of the answers to these questions are:
#	- If user is the creator of the unit, we make him a member of:
#		- @unit_creator_group_id
#	- If user is in the role [n] then we make him a member of THE groups
#		- @are_users_stakeholder_[n]_group_id
#		- @show_to_stakeholder_[all but n]_group_id
# 	- If the user is an occupant then make him a member of
#		- @are_occupants_group_id
# 	- If the user is NOT an occupant then make him a member of
#		- @show_to_occupants_group_id
#	- If the user is publicly visible then make him a member of
#		- @list_visible_assignees_group_id
#	- If the user can see the publicly visible users then make him a member of
#		- @see_visible_assignees_group_id
#	- If the user can be asked to approved flags then make him a member of
#		- @r_group_next_step
#		- @r_group_solution
#		- @r_group_budget
#		- @r_group_attachment
#		- @r_group_OK_to_pay
#		- @r_group_is_paid
#		- @all_r_flags_group_id
#	- If the user is allowed to approve flags then make him a member of
#		- @g_group_next_step
#		- @g_group_solution
#		- @g_group_budget
#		- @g_group_attachment
#		- @g_group_OK_to_pay
#		- @g_group_is_paid
#		- @all_g_flags_group_id
#
# Creation of new users:
#	- If the user is allowed to create more users in ANY group of stakeholder 
#		then he is granted permissions to add users to
#		- @create_case_group_id
#		- @are_users_stakeholder_1_group_id
#		- @are_users_stakeholder_2_group_id
#		- @are_users_stakeholder_3_group_id
#		- @are_users_stakeholder_4_group_id
#		- @are_users_stakeholder_5_group_id
#		- @show_to_stakeholder_1_group_id
#		- @show_to_stakeholder_2_group_id
#		- @show_to_stakeholder_3_group_id
#		- @show_to_stakeholder_4_group_id
#		- @show_to_stakeholder_5_group_id
#		- @are_occupants_group_id
#		- @show_to_occupants_group_id
#
#	- If the user is allowed to create more users only in the same group of stakeholder [n] 
#		then he is granted permissions to add users to
#		- @create_case_group_id
#		- @are_users_stakeholder_[n]_group_id
#		- @show_to_stakeholder_[all but n]_group_id
#		- @are_occupants_group_id
#		- @show_to_occupants_group_id
#
#	- If the user can decided who is visible in the list of assignee
#		- @list_visible_assignees_group_id
#
#	- If the user can decided if a new user can see visible assignees
#		- @see_visible_assignees_group_id
#
#	- If the user can decide who can be requestee and grant Flags
#		- @r_group_next_step
#		- @r_group_solution
#		- @r_group_budget
#		- @r_group_attachment
#		- @r_group_OK_to_pay
#		- @r_group_is_paid
#		- @g_group_next_step
#		- @g_group_solution
#		- @g_group_budget
#		- @g_group_attachment
#		- @g_group_OK_to_pay
#		- @g_group_is_paid
#		- @all_r_flags_group_id
#		- @all_g_flags_group_id
#
##################################################################################

		INSERT  INTO `user_group_map`
			(`user_id`
			,`group_id`
			,`isbless`
			,`grant_type`
			) 
			VALUES 
			# Permission for the user we created:
				# Permission to GRANT Membership to the following groups
					# A user is the creator: this is true so he can add more users and stakholders there
						#(@bz_user_id,@unit_creator_group_id,1,0),
						
					# A user can create a case for this unit? This is true so he can add more users and stakholders there
					# For Celeste, we know she is NOT allowed to
						#(@bz_user_id,@create_case_group_id,1,0),
					
					# A user can see cases in the product.
					# For Celeste, we know she is NOT allowed to
						#(@bz_user_id,@can_see_cases_group_id,1,0),
									
					# A user can edit a case for that unit
					# For Celeste, we know she is NOT allowed to
						#(@bz_user_id,@can_edit_case_group_id,1,0),
					
					# A user can edit all filed in a case, regardless of its role
					# For Celeste, we know she is NOT allowed to
					# This is because he is NOT the unit creator
						#(@bz_user_id,@can_edit_all_field_case_group_id,1,0),
					
					# A user can edit stakholder/component in the product.
					# For Celeste, we know she is NOT allowed to
						#(@bz_user_id,@can_edit_component_group_id,1,0),
						
					# A user is a stakeholder: This is true so he can add more users and stakholders there
					# For Celeste, we know she is NOT allowed to create other users
						#(@bz_user_id,@are_users_stakeholder_1_group_id,1,0),
						#(@bz_user_id,@are_users_stakeholder_2_group_id,1,0),
						#(@bz_user_id,@are_users_stakeholder_3_group_id,1,0),
						#(@bz_user_id,@are_users_stakeholder_4_group_id,1,0),
						#(@bz_user_id,@are_users_stakeholder_5_group_id,1,0),
						#(@bz_user_id,@show_to_stakeholder_1_group_id,1,0),
						#(@bz_user_id,@show_to_stakeholder_2_group_id,1,0),
						#(@bz_user_id,@show_to_stakeholder_3_group_id,1,0),
						#(@bz_user_id,@show_to_stakeholder_4_group_id,1,0),
						#(@bz_user_id,@show_to_stakeholder_5_group_id,1,0),
					
					# A user is an occupant: This is true so he can add more users and stakholders there
					# For Celeste, we know she is NOT allowed to
						#(@bz_user_id,@are_occupants_group_id,1,0),
						#(@bz_user_id,@show_to_occupants_group_id,1,0),
					
					# A user is a visible assignee: This is true so he can add more users and stakholders there
					# For Celeste, we know she is NOT allowed to
						#(@bz_user_id,@list_visible_assignees_group_id,1,0),
						
					# A user can see visible assignees: This is true so he can add more users and stakholders there
					# For Celeste, we know she is NOT allowed to
						#(@bz_user_id,@see_visible_assignees_group_id,1,0),
					
					# A user can be asked to approve flags: This is true so he can add more users and stakholders there
					# For Celeste, we know she is NOT allowed to
						#(@bz_user_id,@r_group_next_step,1,0),
						#(@bz_user_id,@r_group_solution,1,0),
						#(@bz_user_id,@r_group_budget,1,0),
						#(@bz_user_id,@r_group_attachment,1,0),
						#(@bz_user_id,@r_group_OK_to_pay,1,0),
						#(@bz_user_id,@r_group_is_paid,1,0),
						#(@bz_user_id,@all_r_flags_group_id,1,0),
					
					# A user can approve flags: This is true so he can add more users and stakholders there
					# For Celeste, we know she is NOT allowed to
						#(@bz_user_id,@g_group_next_step,1,0),
						#(@bz_user_id,@g_group_solution,1,0),
						#(@bz_user_id,@g_group_budget,1,0),
						#(@bz_user_id,@g_group_attachment,1,0),
						#(@bz_user_id,@g_group_OK_to_pay,1,0),
						#(@bz_user_id,@g_group_is_paid,1,0),
						#(@bz_user_id,@all_g_flags_group_id,1,0),

				# Celeste is a member of the following groups

					# Can he create a case for this unit?
					# All the new user can create...
						(@bz_user_id,@create_case_group_id,0,0),
					
					# User can see any case in the product.
					# By default, all users for this product/unit have this too
						(@bz_user_id,@can_see_cases_group_id,0,0),
							
					# User can edit a case for that unit
					# For Celeste, we know she is allowed to
						(@bz_user_id,@can_edit_case_group_id,0,0),
					
					# User can edit all filed in a case, regardless of its role
					# For Celeste, we know he is allowed to
					# This is because she is NOT the unit creator
						#(@bz_user_id,@can_edit_all_field_case_group_id,0,0),
					
					# User can edit stakholder/component in the product.
					# For Celeste, we know she is NOT allowed to
						#(@bz_user_id,@can_edit_component_group_id,0,0),

					# Is the user a creator of the unit?
					# For Celeste, we know he is NOT
						#(@bz_user_id,@unit_creator_group_id,0,0),
					
					# Group to show/hide cases to some stakeholders:
					# For Celeste, we know he is stakeholder 4
						#(@bz_user_id,@are_users_stakeholder_1_group_id,0,0),
						#(@bz_user_id,@are_users_stakeholder_2_group_id,0,0),
						#(@bz_user_id,@are_users_stakeholder_3_group_id,0,0),
						(@bz_user_id,@are_users_stakeholder_4_group_id,0,0),
						#(@bz_user_id,@are_users_stakeholder_5_group_id,0,0),
						
					# Group to show/hide cases to some stakeholders:
					# For Celeste, we know he is stakeholder 4
					#
						#(@bz_user_id,@show_to_stakeholder_1_group_id,0,0),
						#(@bz_user_id,@show_to_stakeholder_2_group_id,0,0),
						#(@bz_user_id,@show_to_stakeholder_3_group_id,0,0),
						(@bz_user_id,@show_to_stakeholder_4_group_id,0,0),
						#(@bz_user_id,@show_to_stakeholder_5_group_id,0,0),
					
					# Is she an occupant?
					# For Celeste, the answer is NO
						#(@bz_user_id,@are_occupants_group_id,0,0),
						
						#(@bz_user_id,@show_to_occupants_group_id,0,0),
					
					# Is she visible in the list of possible assignees?
					# For Celeste, the answer is NO
						#(@bz_user_id,@list_visible_assignees_group_id,0,0),
						
					# Can she see all the other visible assigneed?
					# For Celeste, the answer is YES
						(@bz_user_id,@see_visible_assignees_group_id,0,0);
					
					# Flags: can she be asked to request?
					# For Celeste, the answer is NO
						#(@bz_user_id,@r_group_next_step,0,0),
						#(@bz_user_id,@r_group_solution,0,0),
						#(@bz_user_id,@r_group_budget,0,0),
						#(@bz_user_id,@r_group_attachment,0,0),
						#(@bz_user_id,@r_group_OK_to_pay,0,0),
						#(@bz_user_id,@r_group_is_paid,0,0),
						#(@bz_user_id,@all_r_flags_group_id,0,0);

					# Flags: can she approve?
					# For Celeste, the answer is YES
						#(@bz_user_id,@g_group_next_step,0,0),
						#(@bz_user_id,@g_group_solution,0,0),
						#(@bz_user_id,@g_group_budget,0,0),
						#(@bz_user_id,@g_group_attachment,0,0),
						#(@bz_user_id,@g_group_OK_to_pay,0,0),
						#(@bz_user_id,@g_group_is_paid,0,0),
						#(@bz_user_id,@all_g_flags_group_id,0,0);

		/*Data for the table `series_categories` */
		# Nothing to do

		/*Data for the table `series_categories` */
		# Nothing to do
					
		/*Data for the table `series` */
		# Nothing to do

		/*Data for the table `audit_log` */
		# Nothing to do

	# We now Create the Privileges for Jocelyn
	#   - Jocelyn works for the Management Company Management Co, in charge of this unit.
	#     Her `id_role_type` in the table `ut_role_types` = 4

	# We do NOT need to create the unit here.
	# We do NOT need to create a new component/stakholder
	# We do NOT need to create new groups
	# We 'Just' need to grant the correct group memberships to Jocelyn for the correct product/unit and component/stakholder/role

		# We do NOT need to create the unit here.
	# BUT We need to Make sure that the the component for this Unit is correct
	
	# We also want to show the publicly visible information for Management Co.
		# His public name
			SET @stakeholder_pub_name = 'Jocelyn';
		# More details
			SET @stakeholder_more = 'Team Bravo';
		# Se we can create the public info too
			SET @stakeholder_pub_info = CONCAT(@stakeholder_pub_name,' - ', @stakeholder_more);
		
	# We Need the BZ user information for Jocelyn
		SET @bz_user_id = 7;

	# User role: this is an id in the table `ut_role_types` for easier manipulation, update and maintenance
		SET @role_type_id = 4;

	# Is this user an occupant of the unit?
	#	- 1 = TRUE
	#	- 0 = FALSE
		SET @is_occupant = 0;

	# We Need the BZ user information for the creator of the new user too (Marina)
		SET @user_creator_bz_user_id = 8;
			
		# His public name 
		# We have this as a variable in this script.
		# this should be stored somewhere in the MEFE
		# we do not need to recreate this in the context of the script to create DEMO users.
			# SET @user_creator_pub_name = 'Marina';
		# More details
			#SET @user_creator_more ='Team Lead';
		# Se we can create the public info too
			#SET @user_creator_pub_info = CONCAT(@user_creator_pub_name,' - ', @user_creator_more);

	# OPTIONAL INFORMATION:
	#
	# We need to know if this user can 
	#	- see all other user (1) 
	#		In this case this user will be a member of the group `@list_visible_assignees_group_id`
	#		for this product/unit.
	#	- see only the people in the same role/stakeholder group. (0)
	# 		Else this user will NOT be a member of the group `@list_visible_assignees_group_id`
	#		for this product/unit.
	# By Default, the user is visible to all other user.
		SET @user_is_public = 0; 
	#
	# We need to know if this user is 
	#	- visible to all other user (1) 
	#		In this case this user will be a member of the group `@see_visible_assignees_group_id`
	#		for this product/unit.
	#	- visible only to people in the same role/stakeholder group. (1)
	# 		Else this user will NOT be a member of the group `@see_visible_assignees_group_id`
	#		for this product/unit.
	# By Default, the user is visible to all other user.
		SET @user_can_see_public = 1; 

	#
	# By default the new user can approve all flags but we want flexibility there 
	# We know this might not be always true for all BZ user we create
		SET @can_be_asked_to_approve = 0;

	# By default the new user can approve all flags but we want flexibility there 
	# We know this might not be always true for all BZ user we create
		SET @can_approve = 1;
	#
	# Is the user allowed to create new users?
		# only in the same group of stakholders
			SET @can_create_same_stakeholder = 0;
		
		# in ANY group of stakeholders
			SET @can_create_any_stakeholder = 0;
	
	# Is this user allowed to decided who can be requestee and grant Flags?
		SET @can_approve_user_for_flag = 0;
		
	# Is this user is allowed to decided who is visible in the list of assignee?
		SET @can_decide_if_user_is_visible = 0;
		
	# Is this user is allowed to decided if a new user can see visible assignees?
		SET @can_decide_if_user_can_see_visible = 0;

	# We have everything - Onward for Management Co!
	
		# We DISABLE the FK check
			SET FOREIGN_KEY_CHECKS = 0;
	
		# Get the additional variable that we need
			# When is this happening?
				SET @timestamp = NOW();

			# We get the login name from the user_id
				SET @login_name = (SELECT `login_name` FROM `profiles` WHERE `userid`=@bz_user_id);
				SET @user_creator_login_name = (SELECT `login_name` FROM `profiles` WHERE `userid`=@user_creator_bz_user_id);

			# We get the Stakeholder designation from the `ut_role_types` table
			# this makes it easy to maintain
				SET @stakeholder = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=@role_type_id);

			# We get the Stakeholder Generic description for the BZFE from the `ut_role_types` table
			# this makes it easy to maintain
				SET @stakeholder_g_description = (SELECT `bz_description` FROM `ut_role_types` WHERE `id_role_type`=@role_type_id);

			# The 'visibility' explanation
				SET @visibility_explanation = CONCAT(@visibility_explanation_1,@stakeholder,@visibility_explanation_2);

	# We need to know if this is the first time we have created a user with this role.
	#
	# If this was any other scenario, we will need to check if we already have a record in the table `ut_product_group`
	# The check is to test if we have a record in the table `ut_product_group` where
	# `product_id` = @product_id AND `role_type_id` = @role_type_id AND `group_type_id` = 2
	# `group_type_id` = 2 is the group to grant access to product/units and bugs/cases.
	# if we have one, no need to create a component/stakholder or any group
	# we just need 
	#	1- to grant membership in this group to the new user so that it can access this
	#		unit and the cases in this unit.
	#	2- Check the group_id that makes this user visible to other users for this product (also in the table `ut_product_group`)
	#	3- Check the group_id that makes this user see the other users for this product (also in the table `ut_product_group`)
	#	4- Check the group_id that allow users to be asked for flag approvals for this product (also in the table `ut_product_group`)
	#	5- Check the group_id that allow users to approve flag for this product (also in the table `ut_product_group`)
	#
	# This is for Demo, we know this is NOT the first time we create a Management Company.
	# We need to:
	# We need to:
	#	- Create the component
	#	- Create the groups
	#	- Update the table `ut_product_group`
	#	- Make sure the groups are properly configured
	#	- Make sure that this new users is granted the membership in the group he needs

		/*Data for the table `ut_map_user_unit_details` */
		# Update the Unee-T table that records information about the user:
			INSERT INTO `ut_map_user_unit_details`
							(`id_user_unit`
							, `created`
							, `record_created_by`
							, `is_obsolete`
							, `user_id`
							, `bz_profile_id`
							, `bz_unit_id`
							, `role_type_id`
							, `is_occupant`
							, `is_public_assignee`
							, `is_see_visible_assignee`
							, `is_flag_requestee`
							, `is_flag_approver`
							, `can_create_any_sh`
							, `can_create_same_sh`
							, `can_approve_user_for_flags`
							, `can_decide_if_user_visible`
							, `can_decide_if_user_can_see_visible`
							, `public_name`
							, `more_info`
							, `comment`
							)
							VALUES
							(NULL,@timestamp,@user_creator_bz_user_id,0,NULL,@bz_user_id,@product_id,@role_type_id,@is_occupant,@user_is_public,@user_can_see_public,@can_be_asked_to_approve,@can_approve,@can_create_any_stakeholder,@can_create_same_stakeholder,@can_approve_user_for_flag,@can_decide_if_user_is_visible,@can_decide_if_user_can_see_visible
							,@stakeholder_pub_name,@stakeholder_more,'');
	
		/*Data for the table `components` */
		# We insert the correct values for the component/stakeholder.
		# Nothing to do here

		# In order to to populate other table (flags, audit table,...), we need to get the newly created component_id
			SET @component_id = LAST_INSERT_ID();

		/*Data for the table `component_cc` */
		# We have NOT added a new user as another stakeholder in stakeholder group that already has users.
		#		We only do that for
		#			- Tenant
		#			- Landlord
		# Nothing to do here
			
		/*Data for the table `groups` */
		# We have created all the groups we needed when we created the unit
		# We have no need to re-create these groups.


		/*Data for the table `group_group_map` */
		# We have created all the groups we needed when we created the unit
		# Nothing to do here
		
		/*Data for the table `group_control_map` */
		# We have created all the groups we needed when we created the unit
		# Nothing to do here
	
		/*Data for the table `user_group_map` */
		# The groups have been defined, we can now tell which group the BZ users needs access to.

##################################################################################
# WE NEED TO MAKE THIS A CONDITIONAL THING TO MAKE THIS SCRIPT MORE VERSATILE
#	- Is the user the creator of the unit?
#	- What is the role_type_id for that user?
#	- Is the user an occupant?
#	- Is this user publicly visible?
#	- Can this user see the publicly visible users?
#	- Can this user be asked to approved flags?
#	- Can this user approve flags?
#	- Is the user allowed to create more users?
#		- In the same group of Stakholder
#		- In ANY group of stakeholder
#		- Can decide who can be requestee and grant Flags
#		- Can decided who is visible in the list of assignee
#		- Can decided if a new user can see visible assignees
#		- 
#
# The consequences of the answers to these questions are:
#	- If user is the creator of the unit, we make him a member of:
#		- @unit_creator_group_id
#	- If user is in the role [n] then we make him a member of THE groups
#		- @are_users_stakeholder_[n]_group_id
#		- @show_to_stakeholder_[all but n]_group_id
# 	- If the user is an occupant then make him a member of
#		- @are_occupants_group_id
# 	- If the user is NOT an occupant then make him a member of
#		- @show_to_occupants_group_id
#	- If the user is publicly visible then make him a member of
#		- @list_visible_assignees_group_id
#	- If the user can see the publicly visible users then make him a member of
#		- @see_visible_assignees_group_id
#	- If the user can be asked to approved flags then make him a member of
#		- @r_group_next_step
#		- @r_group_solution
#		- @r_group_budget
#		- @r_group_attachment
#		- @r_group_OK_to_pay
#		- @r_group_is_paid
#		- @all_r_flags_group_id
#	- If the user is allowed to approve flags then make him a member of
#		- @g_group_next_step
#		- @g_group_solution
#		- @g_group_budget
#		- @g_group_attachment
#		- @g_group_OK_to_pay
#		- @g_group_is_paid
#		- @all_g_flags_group_id
#
# Creation of new users:
#	- If the user is allowed to create more users in ANY group of stakeholder 
#		then he is granted permissions to add users to
#		- @create_case_group_id
#		- @are_users_stakeholder_1_group_id
#		- @are_users_stakeholder_2_group_id
#		- @are_users_stakeholder_3_group_id
#		- @are_users_stakeholder_4_group_id
#		- @are_users_stakeholder_5_group_id
#		- @show_to_stakeholder_1_group_id
#		- @show_to_stakeholder_2_group_id
#		- @show_to_stakeholder_3_group_id
#		- @show_to_stakeholder_4_group_id
#		- @show_to_stakeholder_5_group_id
#		- @are_occupants_group_id
#		- @show_to_occupants_group_id
#
#	- If the user is allowed to create more users only in the same group of stakeholder [n] 
#		then he is granted permissions to add users to
#		- @create_case_group_id
#		- @are_users_stakeholder_[n]_group_id
#		- @show_to_stakeholder_[all but n]_group_id
#		- @are_occupants_group_id
#		- @show_to_occupants_group_id
#
#	- If the user can decided who is visible in the list of assignee
#		- @list_visible_assignees_group_id
#
#	- If the user can decided if a new user can see visible assignees
#		- @see_visible_assignees_group_id
#
#	- If the user can decide who can be requestee and grant Flags
#		- @r_group_next_step
#		- @r_group_solution
#		- @r_group_budget
#		- @r_group_attachment
#		- @r_group_OK_to_pay
#		- @r_group_is_paid
#		- @g_group_next_step
#		- @g_group_solution
#		- @g_group_budget
#		- @g_group_attachment
#		- @g_group_OK_to_pay
#		- @g_group_is_paid
#		- @all_r_flags_group_id
#		- @all_g_flags_group_id
#
##################################################################################

		INSERT  INTO `user_group_map`
			(`user_id`
			,`group_id`
			,`isbless`
			,`grant_type`
			) 
			VALUES 
			# Permission for the user we created:
				# Permission to GRANT Membership to the following groups
					# A user is the creator: this is true so he can add more users and stakholders there
						#(@bz_user_id,@unit_creator_group_id,1,0),
						
					# A user can create a case for this unit? This is true so he can add more users and stakholders there
					# For Jocelyn, we know she is NOT allowed to
						(@bz_user_id,@create_case_group_id,1,0),
					
					# A user can see cases in the product.
					# For Jocelyn, we know she is NOT allowed to
						#(@bz_user_id,@can_see_cases_group_id,1,0),
								
					# A user can edit a case for that unit
					# For Jocelyn, we know she is NOT allowed to
						#(@bz_user_id,@can_edit_case_group_id,1,0),
					
					# A user can edit all filed in a case, regardless of its role
					# For Jocelyn, we know she is NOT allowed to
					# This is because he is NOT the unit creator
						#(@bz_user_id,@can_edit_all_field_case_group_id,1,0),
					
					# A user can edit stakholder/component in the product.
					# For Jocelyn, we know she is NOT allowed to
						#(@bz_user_id,@can_edit_component_group_id,1,0),
						
					# A user is a stakeholder: This is true so he can add more users and stakholders there
					# For Jocelyn, we know she NOT is allowed to create other users
						#(@bz_user_id,@are_users_stakeholder_1_group_id,1,0),
						#(@bz_user_id,@are_users_stakeholder_2_group_id,1,0),
						#(@bz_user_id,@are_users_stakeholder_3_group_id,1,0),
						#(@bz_user_id,@are_users_stakeholder_4_group_id,1,0),
						#(@bz_user_id,@are_users_stakeholder_5_group_id,1,0),
						#(@bz_user_id,@show_to_stakeholder_1_group_id,1,0),
						#(@bz_user_id,@show_to_stakeholder_2_group_id,1,0),
						#(@bz_user_id,@show_to_stakeholder_3_group_id,1,0),
						#(@bz_user_id,@show_to_stakeholder_4_group_id,1,0),
						#(@bz_user_id,@show_to_stakeholder_5_group_id,1,0),
					
					# A user is an occupant: This is true so he can add more users and stakholders there
					# For Jocelyn, we know she is NOT allowed to
						#(@bz_user_id,@are_occupants_group_id,1,0),
						#(@bz_user_id,@show_to_occupants_group_id,1,0),
					
					# A user is a visible assignee: This is true so he can add more users and stakholders there
					# For Jocelyn, we know she is NOT allowed to
						#(@bz_user_id,@list_visible_assignees_group_id,1,0),
						
					# A user can see visible assignees: This is true so he can add more users and stakholders there
					# For Jocelyn, we know she is NOT allowed to
						#(@bz_user_id,@see_visible_assignees_group_id,1,0),
					
					# A user can be asked to approve flags: This is true so he can add more users and stakholders there
					# For Jocelyn, we know she is NOT allowed to
						#(@bz_user_id,@r_group_next_step,1,0),
						#(@bz_user_id,@r_group_solution,1,0),
						#(@bz_user_id,@r_group_budget,1,0),
						#(@bz_user_id,@r_group_attachment,1,0),
						#(@bz_user_id,@r_group_OK_to_pay,1,0),
						#(@bz_user_id,@r_group_is_paid,1,0),
						#(@bz_user_id,@all_r_flags_group_id,1,0),
					
					# A user can approve flags: This is true so he can add more users and stakholders there
					# For Jocelyn, we know she is NOT allowed to
						#(@bz_user_id,@g_group_next_step,1,0),
						#(@bz_user_id,@g_group_solution,1,0),
						#(@bz_user_id,@g_group_budget,1,0),
						#(@bz_user_id,@g_group_attachment,1,0),
						#(@bz_user_id,@g_group_OK_to_pay,1,0),
						#(@bz_user_id,@g_group_is_paid,1,0),
						#(@bz_user_id,@all_g_flags_group_id,1,0),

				# Jocelyn is a member of the following groups

					# Can he create a case for this unit?
					# All the new user can create...
						(@bz_user_id,@create_case_group_id,0,0),
					
					# User can see any case in the product.
					# By default, all users for this product/unit have this too
						(@bz_user_id,@can_see_cases_group_id,0,0),
					
					# User can edit a case for that unit
					# For Jocelyn, we know she is allowed to
						(@bz_user_id,@can_edit_case_group_id,0,0),
					
					# User can edit all filed in a case, regardless of its role
					# For Jocelyn, we know he is allowed to
					# This is because she is NOT the unit creator
						#(@bz_user_id,@can_edit_all_field_case_group_id,0,0),
					
					# User can edit stakholder/component in the product.
					# For Jocelyn, we know she is NOT allowed to
						#(@bz_user_id,@can_edit_component_group_id,0,0),

					# Is the user a creator of the unit?
					# For Jocelyn, we know he is NOT
						#(@bz_user_id,@unit_creator_group_id,0,0),
					
					# Group to show/hide cases to some stakeholders:
					# For Jocelyn, we know he is stakeholder 4
						#(@bz_user_id,@are_users_stakeholder_1_group_id,0,0),
						#(@bz_user_id,@are_users_stakeholder_2_group_id,0,0),
						#(@bz_user_id,@are_users_stakeholder_3_group_id,0,0),
						(@bz_user_id,@are_users_stakeholder_4_group_id,0,0),
						#(@bz_user_id,@are_users_stakeholder_5_group_id,0,0),
						
					# Group to show/hide cases to some stakeholders:
					# For Jocelyn, we know he is stakeholder 4
					#
						#(@bz_user_id,@show_to_stakeholder_1_group_id,0,0),
						#(@bz_user_id,@show_to_stakeholder_2_group_id,0,0),
						#(@bz_user_id,@show_to_stakeholder_3_group_id,0,0),
						(@bz_user_id,@show_to_stakeholder_4_group_id,0,0),
						#(@bz_user_id,@show_to_stakeholder_5_group_id,0,0),
					
					# Is she an occupant?
					# For Jocelyn, the answer is NO
						#(@bz_user_id,@are_occupants_group_id,0,0),
						
						#(@bz_user_id,@show_to_occupants_group_id,0,0),
					
					# Is she visible in the list of possible assignees?
					# For Jocelyn, the answer is NO
						#(@bz_user_id,@list_visible_assignees_group_id,0,0),
						
					# Can she see all the other visible assigneed?
					# For Jocelyn, the answer is YES
						(@bz_user_id,@see_visible_assignees_group_id,0,0);
					
					# Flags: can she be asked to request?
					# For Jocelyn, the answer is NO
						#(@bz_user_id,@r_group_next_step,0,0),
						#(@bz_user_id,@r_group_solution,0,0),
						#(@bz_user_id,@r_group_budget,0,0),
						#(@bz_user_id,@r_group_attachment,0,0),
						#(@bz_user_id,@r_group_OK_to_pay,0,0),
						#(@bz_user_id,@r_group_is_paid,0,0),
						#(@bz_user_id,@all_r_flags_group_id,0,0);

					# Flags: can she approve?
					# For Jocelyn, the answer is YES
						#(@bz_user_id,@g_group_next_step,0,0),
						#(@bz_user_id,@g_group_solution,0,0),
						#(@bz_user_id,@g_group_budget,0,0),
						#(@bz_user_id,@g_group_attachment,0,0),
						#(@bz_user_id,@g_group_OK_to_pay,0,0),
						#(@bz_user_id,@g_group_is_paid,0,0),
						#(@bz_user_id,@all_g_flags_group_id,0,0);

		/*Data for the table `series_categories` */
		# Nothing to do

		/*Data for the table `series_categories` */
		# Nothing to do
					
		/*Data for the table `series` */
		# Nothing to do

		/*Data for the table `audit_log` */
		# Nothing to do

		# We enable the FK check back
		SET FOREIGN_KEY_CHECKS = 1;

# Cleanup after: flush the variables
SET @timestamp = NULL;
SET @unit_group = NULL;
SET @unit = NULL;
SET @unit_for_query = NULL;
SET @unit_for_flag = NULL;
SET @unit_pub_description = NULL;
SET @creator_pub_name = NULL;
SET @creator_more = NULL;
SET @creator_pub_info = NULL;
SET @stakeholder_pub_name = NULL;
SET @stakeholder_more = NULL;
SET @stakeholder_pub_info = NULL;
SET @user_creator_pub_name = NULL;
SET @can_be_asked_to_approve = NULL;
SET @can_approve = NULL;
SET @user_is_public = NULL;
SET @user_can_see_public = NULL;
SET @can_create_same_stakeholder = NULL;
SET @can_create_any_stakeholder = NULL;
SET @can_approve_user_for_flag = NULL;
SET @can_decide_if_user_is_visible = NULL;
SET @can_decide_if_user_can_see_visible = NULL;
SET @stakeholder = NULL;
SET @stakeholder_g_description = NULL;
SET @is_occupant = NULL;
SET @login_name = NULL;
SET @bz_user_id = NULL;
SET @can_be_asked_to_approve = NULL;
SET @bz_user_id_who_can_to_approve = NULL;
SET @product_id = NULL;
SET @milestone_id = NULL;
SET @version_id = NULL;
SET @component_id = NULL;
SET @unit_creator_group_id = NULL;
SET @create_case_group_id = NULL;
SET @are_users_stakeholder_group_id = NULL;
SET @list_visible_assignees_group_id = NULL;
SET @see_visible_assignees_group_id = NULL;
SET @flag_next_step = NULL;
SET @flag_solution = NULL;
SET @flag_budget = NULL;
SET @flag_attachment = NULL;
SET @flag_ok_to_pay = NULL;
SET @flag_is_paid = NULL;
SET @g_group_next_step = NULL;
SET @r_group_next_step = NULL;
SET @g_group_solution = NULL;
SET @r_group_solution = NULL;
SET @g_group_budget = NULL;
SET @r_group_budget = NULL;
SET @g_group_attachment = NULL;
SET @r_group_attachment = NULL;
SET @g_group_OK_to_pay = NULL;
SET @r_group_OK_to_pay = NULL;
SET @g_group_is_paid = NULL;
SET @r_group_is_paid = NULL;
SET @g_all_flags_group_id = NULL;
SET @r_all_flags_group_id = NULL;
SET @all_unit_privileges_group_id = NULL;
SET @can_edit_case_group_id = NULL;
SET @can_edit_all_field_case_group_id = NULL;
SET @can_edit_component_group_id = NULL;
SET @can_see_cases_group_id = NULL;
SET @all_g_tags = NULL;
SET @all_r_tags = NULL;
SET @series_2 = NULL;
SET @series_1 = NULL;
SET @series_3 = NULL;