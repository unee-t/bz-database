# For any question about this script, ask Franck

#############################################
#											#
# IMPORTANT INFORMATION ABOUT THIS SCRIPT	#
#											#
#############################################
#
# Built for BZFE database v2.13
#
# Use this script only if:
#	- The unit ALREADY EXISTS in the BZFE
#	- The BZ user already exist in the BZFE
#	- The Role DOES NOT EXIST YET in the BZFE
#	- You HAVE used the script '2_Insert_new_unit_and_role_in_unee-t_bzfe_v2.13' to create the product and the 1st role for this unit.
# 
# This script will use:
# 	- The component_id we created when we created the product with the script '2_Insert_new_unit_and_role_in_unee-t_bzfe_v2.13' (this has been stored in the 'ut_product_group' table).
#	- The group_id we created when we created the product with the script '2_Insert_new_unit_and_role_in_unee-t_bzfe_v2.13'.
#
# This script will create
#	- A new component/role for this unit
#	- Assign the default user to this component
#
# The user will be made a member of the groups that allows the following rights
#	- See all the time tracking information (group id 16)
#	- Create Shared queries (group id 17)
#	- tag comments (group id 18)
#
# See the below parameters for the appropriate permissions for the user.
#
# Limits of this script:
#	- DO NOT USE if the role already exists for this unit
#	  In this scenario, use the script '4_Insert_existing_bz_user_in_an_existing_unit_and_role_bzfe_v2.13.sql'
#
#
#################################################################
#																#
# UPDATE THE BELOW VARIABLES ACCORDING TO YOUR NEEDS			#
#																#
#################################################################

# The unit:

	# BZ product_id for the unit you are altering
	SET @product_id = 14;

# The user associated to the unit.	

	# BZ user id of the user that is creating the unit (default is 1 - Administrator).
	# For LMB migration, we use 2 (support.nobody)
	SET @creator_bz_id = 2;

	# BZ user id of the user that you want to associate to this role for this unit.
	SET @bz_user_id = 4;

	# Role of the user associated to this new unit:
	#	- Tenant 1
	# 	- Landlord 2
	#	- Agent 5
	#	- Contractor 3
	#	- Management company 4
	SET @id_role_type = 2;
	
	# Is the new user an occupant for the unit?
	SET @is_occupant = 0;

	# More information about the user associated to the unit:
	SET @role_user_more = 'The Landlord for this unit';

# Global permission for the user:
	SET @can_see_time_tracking = 1;
	SET @can_create_shared_queries = 1;
	# The below permission is mandatory as this will allow us to add reactions (smileys)
	# or notifications to the comments by a user.
	SET @can_tag_comment = 1;

# User visibility permissions	
	# Can the BZ user see certain list of users for the unit?
	# Usually a user can see the list of occupants in the same role he is into!
	# At the moment this is NOT true for the role 'contractor': we do not want the electrician to see the plumber...
	# User in a 'contractor' role should be publicly visible.

	SET @can_see_occupant = 0;		
	SET @can_see_tenant = 0;
	SET @can_see_landlord = 0;
	SET @can_see_agent = 0;
	SET @can_see_contractor = 0;
	SET @can_see_mgt_cny = 1;

# User permissions (for THIS PRODUCT ONLY):

	SET @can_create_new_cases = 1;
	SET @can_edit_a_case = 1;
	SET @can_see_all_public_cases = 1;
	SET @can_edit_all_field_in_a_case_regardless_of_role = 0;
	SET @user_is_publicly_visible = 1;
	SET @user_can_see_publicly_visible = 1;
	# We need to keep this = 0 as this is the first user in this role!
	SET @user_in_cc_for_cases = 0;
	
# Flags

	# WARNING: The below permission makes the show/hide user functionality less efficient...
	# A user who can directly ask to approve will automatically see all the approvers for the flags...
	SET @can_ask_to_approve = 1;
	SET @can_approve = 1;

################
#
# This is NOT implemented at this point: this script does
# NOT grant a user permission to grant membership to any group
# This is OK for now as user creation will be manual initially...
#
		SET @can_create_same_stakeholder = 0;
		SET @can_create_any_stakeholder = 0;
		SET @can_approve_user_for_flag = 0;
		SET @can_decide_if_user_is_occupant = 0;
		SET @can_decide_if_user_can_see_visible_occupant = 0;
		SET @can_decide_if_user_is_visible = 0;
		SET @can_decide_if_user_can_see_visible = 0;
#
#
#################

########################################################################
#
#	ALL THE VARIABLES WE NEED HAVE BEEN DEFINED, WE CAN RUN THE SCRIPT #
#
########################################################################

# Disable the FK checks
		
/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;



# Info about this script
	SET @script = '3_Insert_new_role_in_an_existing_unit_unee-t_bzfe_v2.13.sql';
	
# Info about the user
	# For the default user for this new role:
		SET @role_user_g_description = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=@id_role_type);
		SET @user_pub_name = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id);
		SET @role_user_pub_info = CONCAT(@user_pub_name,' - ', @role_user_more);
		SET @user_role_desc = (CONCAT(@role_user_g_description, ' - ',@role_user_pub_info));

	# For the creator
		SET @creator_pub_name = (SELECT `realname` FROM `profiles` WHERE `userid` = @creator_bz_id);

##############################
#
#	WIP - WE NEED TO RECORD PERMISSION MORE EFFICIENTLY
#
# The user
	# We get the information that we need about the user:
		SET @user_pub_name = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id);
	
	
	# We record the information about the users that we have just updated
	# If this is the first time we record something for this user for this unit, we create a new record.
	# If there is already a record for that user for this unit, then we are updating the information
		
		INSERT INTO `ut_map_user_unit_details`
			(`created`
			, `record_created_by`
			, `user_id`
			, `bz_profile_id`
			, `bz_unit_id`
			, `role_type_id`
			, `can_see_time_tracking`
			, `can_create_shared_queries`
			, `can_tag_comment`
			, `is_occupant`
			, `is_public_assignee`
			, `is_see_visible_assignee`
			, `is_in_cc_for_role`
			, `can_create_case`
			, `can_edit_case`
			, `can_see_case`
			, `can_edit_all_field_regardless_of_role`
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
			(NOW()
			, @creator_bz_id
			, @bz_user_id
			, @bz_user_id
			, @product_id
			, @id_role_type
			# Global permission for the whole installation
			, @can_see_time_tracking
			, @can_create_shared_queries
			, @can_tag_comment
			# Attributes of the user
			, @is_occupant
			# User visibility
			, @user_is_publicly_visible
			, @user_can_see_publicly_visible
			# Permissions for cases for this unit.
			, @user_in_cc_for_cases
			, @can_create_new_cases
			, @can_edit_a_case
			, @can_see_all_public_cases
			, @can_edit_all_field_in_a_case_regardless_of_role
			# For the flags
			, @can_ask_to_approve
			, @can_approve
			# Permissions to create or modify other users
			, @can_create_any_stakeholder
			, @can_create_same_stakeholder
			, @can_approve_user_for_flag
			, @can_decide_if_user_is_visible
			, @can_decide_if_user_can_see_visible
			, @user_pub_name
			, @role_user_more
			, CONCAT('On ', NOW(), ': Created with the script - ', @script, '.\r\ ', `comment`)
			)
			ON DUPLICATE KEY UPDATE
			`created` = NOW()
			, `record_created_by` = @creator_bz_id
			, `role_type_id` = @id_role_type
			, `can_see_time_tracking` = @can_see_time_tracking
			, `can_create_shared_queries` = @can_create_shared_queries
			, `can_tag_comment` = @can_tag_comment
			, `is_occupant` = @is_occupant
			, `is_public_assignee` = @user_is_publicly_visible
			, `is_see_visible_assignee` = @user_can_see_publicly_visible
			, `is_in_cc_for_role` = @user_in_cc_for_cases
			, `can_create_case` = @can_create_new_cases
			, `can_edit_case` = @can_edit_a_case
			, `can_see_case` = @can_see_all_public_cases
			, `can_edit_all_field_regardless_of_role` = @can_edit_all_field_in_a_case_regardless_of_role
			, `is_flag_requestee` = @can_ask_to_approve
			, `is_flag_approver` = @can_approve
			, `can_create_any_sh` = @can_create_any_stakeholder
			, `can_create_same_sh` = @can_create_same_stakeholder
			, `can_approve_user_for_flags` = @can_approve_user_for_flag
			, `can_decide_if_user_visible` = @can_decide_if_user_is_visible
			, `can_decide_if_user_can_see_visible` = @can_decide_if_user_can_see_visible
			, `public_name` = @user_pub_name
			, `more_info` = CONCAT('On: ', NOW(), '.\r\Updated to ', @role_user_more, '. \r\ ', `more_info`)
			, `comment` = CONCAT('On ', NOW(), '.\r\Updated with the script - ', @script, '.\r\ ', `comment`)
		;
#
#
##############################
	
	# What is the component_id for this role?
		SET @component_id_this_role = (SELECT `component_id` 
											FROM `ut_product_group` 
											WHERE 
											(`product_id` = @product_id 
											AND 
											`group_type_id` = 2
											AND
											`role_type_id` = @role_type_id
											)
											);
	
	# We have everything, we can now create the new component/role for the unit.
		INSERT INTO `components`
			(`id`
			,`name`
			,`product_id`
			,`initialowner`
			,`initialqacontact`
			,`description`
			,`isactive`
			) 
			VALUES
			(@component_id_this_role,@role_user_g_description,@product_id,@bz_user_id,@bz_user_id,@user_role_desc,1)
			;
			
	# We now assign the user permission for the first user we have assigned to this role.
	
# Which are the Groups to grant the various permissions to a user in that unit?
	
		# The global permission for the application
		# This should not change, it was hard coded when we created Unee-T
			# See time tracking
			SET @can_see_time_tracking_group_id = 16;
			# Can create shared queries
			SET @can_create_shared_queries_group_id = 17;
			# Can tag comments
			SET @can_tag_comment_group_id = 18;
	
		# We need to get the id of these groups from the 'ut_product_group' table_based on the product_id
		# Groups created when we create the product
			SET @create_case_group_id =  (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 20));
			SET @can_edit_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 25));
			SET @can_edit_all_field_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 26));
			SET @can_edit_component_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 27));
			SET @can_see_cases_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 28));
			SET @all_r_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 18));
			SET @all_g_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 19));
			SET @list_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 4));
			SET @see_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 5));
#			SET @active_stakeholder_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 29));

		# For the user - based on the user role:
			# Visibility group
			SET @group_id_show_to_user_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = @id_role_type));
		
			# Is in user Group for the role we just created
			SET @group_id_are_users_same_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = @id_role_type));
			
			# Can See other users in the same Group
			SET @group_id_see_users_same_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = @id_role_type));

#######################
#
#	THIS IS PROBABLY INCORRECT - NEED TO REVISIT THAT!
#			
		# For the people invited by the user who invited the user in this role for that unit:
			# Is in invited_by user Group
			SET @group_id_are_users_invited_by = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 31));
			
			# Can See users in invited_by user Group
			SET @group_id_see_users_invited_by = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 32));
#
#
#######################


# We create the procedures that will grant the permissions based on the variables from this script.			
#
# We need to create several procedures for each permissions
#	- time_tracking_permission
#	- can_create_shared_queries
#	- can_tag_comment
#
#	- show_to_occupant
#	- is_occupant
#	- can_see_occupant
#
#	- can_create_new_cases
#	- can_edit_a_case
#	- can_see_all_public_cases
#	- can_edit_all_field_in_a_case_regardless_of_role
#	- user_is_publicly_visible
#	- user_can_see_publicly_visible
#	- can_ask_to_approve (all_r_flags_group_id)
#	- can_approve (all_g_flags_group_id)
#
#	- user_in_cc_for_cases
#
#	- show_to_tenant
#	- is_tenant
#	- can_see_tenant
#
#	- show_to_landlord
#	- are_users_landlord
#	- see_users_landlord
#
#	- show_to_agent
#	- are_users_agent
#	- see_users_agent
#
#	- show_to_contractor
#	- are_users_contractor
#	- see_users_contractor
#
#	- show_to_mgt_cny
#	- are_users_mgt_cny
#	- see_users_mgt_cny

	# First the global permissions:
		# Can see timetracking
DROP PROCEDURE IF EXISTS time_tracking_permission;
DELIMITER $$
CREATE PROCEDURE time_tracking_permission()
BEGIN
	IF (@can_see_time_tracking = 1)
	THEN INSERT  INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id,@can_see_time_tracking_group_id,0,0)
				;
				
			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user #'
										, @bz_user_id
										, ' CAN See time tracking information.'
										);
			
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table = 'ut_user_group_map_temp';
				
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
					 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to see time tracking')
					 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_time_tracking_group_id, @script, 'Add the BZ group id when we grant the permission to see time tracking')
					 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant see time tracking permission')
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group see time tracking')
					 ;
				 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
END IF ;
END $$
DELIMITER ;
	
		# Can create shared queries
DROP PROCEDURE IF EXISTS can_create_shared_queries;
DELIMITER $$
CREATE PROCEDURE can_create_shared_queries()
BEGIN
	IF (@can_create_shared_queries = 1)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id,@can_create_shared_queries_group_id,0,0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user #'
										, @bz_user_id
										, ' CAN create shared queries.'
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table

				SET @bzfe_table = 'ut_user_group_map_temp';

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
						 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to create shared queries')
						 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_create_shared_queries_group_id, @script, 'Add the BZ group id when we grant the permission to create shared queries')
						 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant create shared queries permission')
						 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group create shared queries')
						 ;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
END IF ;
END $$
DELIMITER ;

		# Can tag comments
DROP PROCEDURE IF EXISTS can_tag_comment;
DELIMITER $$
CREATE PROCEDURE can_tag_comment()
BEGIN
	IF (@can_tag_comment = 1)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id,@can_tag_comment_group_id,0,0)
				;
				
			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user #'
										, @bz_user_id
										, ' CAN tag comments.'
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table = 'ut_user_group_map_temp';

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
					 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to tag comments')
					 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_tag_comment_group_id, @script, 'Add the BZ group id when we grant the permission to tag comments')
					 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant tag comments permission')
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group tag comments')
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
END IF ;
END $$
DELIMITER ;
				
	# Then the permissions at the unit/product level:

		# User is an occupant in the unit:
DROP PROCEDURE IF EXISTS show_to_occupant;
DELIMITER $$
CREATE PROCEDURE show_to_occupant()
BEGIN
	IF (@is_occupant = 1)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_show_to_occupant, 0, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user #'
										, @bz_user_id
										, ' CAN see case that are limited to occupants'
										, ' for the unit #'
										, @product_id
										, '.'
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table = 'ut_user_group_map_temp';
				SET @permission_granted = 'CAN see case that are limited to occupants.';

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
					 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_show_to_occupant, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;	
	
		# User is an occupant in the unit:
DROP PROCEDURE IF EXISTS is_occupant;
DELIMITER $$
CREATE PROCEDURE is_occupant()
BEGIN
	IF (@is_occupant = 1)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_are_users_occupant, 0, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user #'
										, @bz_user_id
										, ' is an occupant in the unit #'
										, @product_id
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table = 'ut_user_group_map_temp';
				SET @permission_granted = 'is an occupant.';

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
					 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_are_users_occupant, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;

		# User can see all the occupants in the unit:
DROP PROCEDURE IF EXISTS can_see_occupant;
DELIMITER $$
CREATE PROCEDURE can_see_occupant()
BEGIN
	IF (@can_see_occupant = 1)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_see_users_occupant, 0, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user #'
										, @bz_user_id
										, ' can see occupant in the unit '
										, @product_id
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table = 'ut_user_group_map_temp';
				SET @permission_granted = 'can see occupant in the unit.';

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
					 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_see_users_occupant, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;
				
		# User can create a case:
			# There can be cases when a user is only allowed to see existing cases but NOT create a new one.
			# This is an unlikely scenario, but this is technically possible (ex for technician for a contractor)...
DROP PROCEDURE IF EXISTS can_create_new_cases;
DELIMITER $$
CREATE PROCEDURE can_create_new_cases()
BEGIN
	IF (@can_create_new_cases = 1)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				# There can be cases when a user is only allowed to see existing cases but NOT create new one.
				# This is an unlikely scenario, but this is technically possible...
				(@bz_user_id, @create_case_group_id, 0, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user #'
										, @bz_user_id
										, ' CAN create new cases for unit '
										, @product_id
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table = 'ut_user_group_map_temp';
				SET @permission_granted = 'create a new case.';

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
					 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;
				
		# User is just allowed to edit cases (not create new ones)
			# This is an unlikely scenario, but this is technically possible (ex for technician for a contractor)...
DROP PROCEDURE IF EXISTS can_edit_a_case;
DELIMITER $$
CREATE PROCEDURE can_edit_a_case()
BEGIN
	IF (@can_edit_a_case = 1)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @can_edit_case_group_id, 0, 0)	
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user #'
										, @bz_user_id
										, ' CAN edit a cases for unit '
										, @product_id
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table = 'ut_user_group_map_temp';
				SET @permission_granted = 'edit a case in this unit.';

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
					 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_edit_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;
				
		# User can see the case in the unit even if they are not for his role
			# This allows a user to see the 'public' cases for a given unit.
			# A 'public' case can still only be seen by users in this group!
			# We might NOT want this for employees of a contractor that only need to see the cases IF the case is restricted to
			# the contractor role but NOT if the case is for anyone
			# This is an unlikely scenario, but this is technically possible (ex for technician for a contractor)...
DROP PROCEDURE IF EXISTS can_see_all_public_cases;
DELIMITER $$
CREATE PROCEDURE can_see_all_public_cases()
BEGIN
	IF (@can_see_all_public_cases = 1)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @can_see_cases_group_id, 0, 0)	
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user #'
										, @bz_user_id
										, ' CAN see all public cases for unit '
										, @product_id
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table = 'ut_user_group_map_temp';
				SET @permission_granted = 'see all public case in this unit.';

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
					 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_cases_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;
				
		# User can modify all fields in a case, regardless of his role in the cases
			# This is needed for users that will do triage for instance.
DROP PROCEDURE IF EXISTS can_edit_all_field_in_a_case_regardless_of_role;
DELIMITER $$
CREATE PROCEDURE can_edit_all_field_in_a_case_regardless_of_role()
BEGIN
	IF (@can_edit_all_field_in_a_case_regardless_of_role = 1)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @can_edit_all_field_case_group_id, 0, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user #'
										, @bz_user_id
										, ' CAN edit a cases for unit regardless of the user role in the case'
										, @product_id
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table = 'ut_user_group_map_temp';
				SET @permission_granted = 'edit a case in this unit regardless of the user role in the case.';

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
					 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_edit_all_field_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;				
END IF ;
END $$
DELIMITER ;
				
		# User can be visible to other users regardless of the other users roles
DROP PROCEDURE IF EXISTS user_is_publicly_visible;
DELIMITER $$
CREATE PROCEDURE user_is_publicly_visible()
BEGIN
	IF (@user_is_publicly_visible = 1)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @list_visible_assignees_group_id, 0, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user #'
										, @bz_user_id
										, ' is one of the visible assignee for cases for this unit.'
										, @product_id
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table = 'ut_user_group_map_temp';
				SET @permission_granted = 'is one of the visible assignee for cases for this unit.';

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
					 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @list_visible_assignees_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;				
END IF ;
END $$
DELIMITER ;

		# User can be visible to other users regardless of the other users roles
			# The below membership is needed so the user can see all the other users regardless of the other users roles
			# We might hide the visible users to some other user (ex: housekeepers or field person do not need to see lanlord or agent
			# They just need to see their manager)
DROP PROCEDURE IF EXISTS user_can_see_publicly_visible;
DELIMITER $$
CREATE PROCEDURE user_can_see_publicly_visible()
BEGIN
	IF (@user_can_see_publicly_visible = 1)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @see_visible_assignees_group_id, 0, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user #'
										, @bz_user_id
										, ' CAN see the publicly visible users for the case for this unit.'
										, @product_id
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table = 'ut_user_group_map_temp';
				SET @permission_granted = ' CAN see the publicly visible users for the case for this unit.';

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
					 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @see_visible_assignees_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;				
END IF ;
END $$
DELIMITER ;				

			#user can create flags (approval requests)				
				
DROP PROCEDURE IF EXISTS can_ask_to_approve;
DELIMITER $$
CREATE PROCEDURE can_ask_to_approve()
BEGIN
	IF (@can_ask_to_approve = 1)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES
				(@bz_user_id, @all_r_flags_group_id, 0, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user #'
										, @bz_user_id
										, ' CAN ask for approval for all flags.'
										, @product_id
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table = 'ut_user_group_map_temp';
				SET @permission_granted = ' CAN ask for approval for all flags.';

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
					 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @all_r_flags_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;	
				
END IF ;
END $$
DELIMITER ;			
				
			# user can approve all the flags
	
DROP PROCEDURE IF EXISTS can_approve;
DELIMITER $$
CREATE PROCEDURE can_approve()
BEGIN
	IF (@can_approve = 1)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES
				(@bz_user_id, @all_g_flags_group_id, 0, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user #'
										, @bz_user_id
										, ' CAN approve for all flags.'
										, @product_id
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table = 'ut_user_group_map_temp';
				SET @permission_granted = ' CAN approve for all flags.';

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
					 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @all_g_flags_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;	
				
END IF ;
END $$
DELIMITER ;
				
	# Then the permissions that are relevant to the component/role
					
		# User can see the cases for Tenants in the unit:
DROP PROCEDURE IF EXISTS show_to_tenant;
DELIMITER $$
CREATE PROCEDURE show_to_tenant()
BEGIN
	IF (@id_role_type = 1)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_show_to_tenant, 0, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user #'
										, @bz_user_id
										, ' CAN see case that are limited to tenants'
										, ' for the unit #'
										, @product_id
										, '.'
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table = 'ut_user_group_map_temp';
				SET @permission_granted = 'CAN see case that are limited to tenants.';

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
					 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_show_to_tenant, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;	
	
	
		# User is a tenant in the unit:
DROP PROCEDURE IF EXISTS is_tenant;
DELIMITER $$
CREATE PROCEDURE is_tenant()
BEGIN
	IF (@id_role_type = 1)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_are_users_tenant, 0, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user #'
										, @bz_user_id
										, ' is a tenant in the unit #'
										, @product_id
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table = 'ut_user_group_map_temp';
				SET @permission_granted = 'is an tenant.';

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
					 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_are_users_tenant, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;

		# User can see all the tenant in the unit:
DROP PROCEDURE IF EXISTS can_see_tenant;
DELIMITER $$
CREATE PROCEDURE can_see_tenant()
BEGIN
	IF (@can_see_tenant = 1)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_see_users_tenant, 0, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user #'
										, @bz_user_id
										, ' can see tenant in the unit '
										, @product_id
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table = 'ut_user_group_map_temp';
				SET @permission_granted = 'can see tenant in the unit.';

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
					 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_see_users_tenant, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;
		
			# User can see the cases for Landlord in the unit:
DROP PROCEDURE IF EXISTS show_to_landlord;
DELIMITER $$
CREATE PROCEDURE show_to_landlord()
BEGIN
	IF (@id_role_type = 2)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_show_to_landlord, 0, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user #'
										, @bz_user_id
										, ' CAN see case that are limited to landlords'
										, ' for the unit #'
										, @product_id
										, '.'
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table = 'ut_user_group_map_temp';
				SET @permission_granted = 'CAN see case that are limited to landlords.';

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
					 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_show_to_landlord, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;	
	
		# User is a landlord for the unit:
DROP PROCEDURE IF EXISTS are_users_landlord;
DELIMITER $$
CREATE PROCEDURE are_users_landlord()
BEGIN
	IF (@id_role_type = 2)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_are_users_landlord, 0, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user #'
										, @bz_user_id
										, ' is a landlord for the unit #'
										, @product_id
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table = 'ut_user_group_map_temp';
				SET @permission_granted = 'is an landlord.';

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
					 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_are_users_landlord, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;

		# User can see all the tenant in the unit:
DROP PROCEDURE IF EXISTS see_users_landlord;
DELIMITER $$
CREATE PROCEDURE see_users_landlord()
BEGIN
	IF (@can_see_landlord = 1)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_see_users_landlord, 0, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user #'
										, @bz_user_id
										, ' can see tenant in the unit '
										, @product_id
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table = 'ut_user_group_map_temp';
				SET @permission_granted = 'can see tenant in the unit.';

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
					 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_see_users_landlord, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;

			# User can see the cases for agent in the unit:
DROP PROCEDURE IF EXISTS show_to_agent;
DELIMITER $$
CREATE PROCEDURE show_to_agent()
BEGIN
	IF (@id_role_type = 5)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_show_to_agent, 0, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user #'
										, @bz_user_id
										, ' CAN see case that are limited to agents'
										, ' for the unit #'
										, @product_id
										, '.'
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table = 'ut_user_group_map_temp';
				SET @permission_granted = 'CAN see case that are limited to agents.';

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
					 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_show_to_agent, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;	
	
		# User is an agent for the unit:
DROP PROCEDURE IF EXISTS are_users_agent;
DELIMITER $$
CREATE PROCEDURE are_users_agent()
BEGIN
	IF (@id_role_type = 5)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_are_users_agent, 0, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user #'
										, @bz_user_id
										, ' is an agent for the unit #'
										, @product_id
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table = 'ut_user_group_map_temp';
				SET @permission_granted = 'is an agent.';

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
					 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_are_users_agent, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;

		# User can see all the agents in the unit:
DROP PROCEDURE IF EXISTS see_users_agent;
DELIMITER $$
CREATE PROCEDURE see_users_agent()
BEGIN
	IF (@can_see_agent = 1)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_see_users_agent, 0, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user #'
										, @bz_user_id
										, ' can see agents for the unit '
										, @product_id
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table = 'ut_user_group_map_temp';
				SET @permission_granted = 'can see agents for the unit.';

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
					 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_see_users_agent, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;

			# User can see the cases for contractor for the unit:
DROP PROCEDURE IF EXISTS show_to_contractor;
DELIMITER $$
CREATE PROCEDURE show_to_contractor()
BEGIN
	IF (@id_role_type = 3)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_show_to_contractor, 0, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user #'
										, @bz_user_id
										, ' CAN see case that are limited to contractors'
										, ' for the unit #'
										, @product_id
										, '.'
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table = 'ut_user_group_map_temp';
				SET @permission_granted = 'CAN see case that are limited to contractors.';

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
					 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_show_to_contractor, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;	
	
		# User is a contractor for the unit:
DROP PROCEDURE IF EXISTS are_users_contractor;
DELIMITER $$
CREATE PROCEDURE are_users_contractor()
BEGIN
	IF (@id_role_type = 3)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_are_users_contractor, 0, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user #'
										, @bz_user_id
										, ' is a contractor for the unit #'
										, @product_id
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table = 'ut_user_group_map_temp';
				SET @permission_granted = 'is a contractor.';

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
					 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_are_users_contractor, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;

		# User can see all the agents in the unit:
DROP PROCEDURE IF EXISTS see_users_contractor;
DELIMITER $$
CREATE PROCEDURE see_users_contractor()
BEGIN
	IF (@can_see_contractor = 1)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_see_users_contractor, 0, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user #'
										, @bz_user_id
										, ' can see employee of Contractor for the unit '
										, @product_id
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table = 'ut_user_group_map_temp';
				SET @permission_granted = 'can see employee of Contractor for the unit.';

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
					 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_see_users_contractor, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;
		
			# User can see the cases for Management Cny for the unit:
DROP PROCEDURE IF EXISTS show_to_mgt_cny;
DELIMITER $$
CREATE PROCEDURE show_to_mgt_cny()
BEGIN
	IF (@id_role_type = 4)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_show_to_mgt_cny, 0, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user #'
										, @bz_user_id
										, ' CAN see case that are limited to Mgt Cny'
										, ' for the unit #'
										, @product_id
										, '.'
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table = 'ut_user_group_map_temp';
				SET @permission_granted = 'CAN see case that are limited to Mgt Cny.';

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
					 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_show_to_mgt_cny, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;	
	
		# User is a Mgt Cny for the unit:
DROP PROCEDURE IF EXISTS are_users_mgt_cny;
DELIMITER $$
CREATE PROCEDURE are_users_mgt_cny()
BEGIN
	IF (@id_role_type = 4)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_are_users_mgt_cny, 0, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user #'
										, @bz_user_id
										, ' is a Mgt Cny for the unit #'
										, @product_id
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table = 'ut_user_group_map_temp';
				SET @permission_granted = 'is a Mgt Cny.';

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
					 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_are_users_mgt_cny, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;

		# User can see all the employee of the Mgt Cny for the unit:
DROP PROCEDURE IF EXISTS see_users_mgt_cny;
DELIMITER $$
CREATE PROCEDURE see_users_mgt_cny()
BEGIN
	IF (@can_see_mgt_cny = 1)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_see_users_mgt_cny, 0, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user #'
										, @bz_user_id
										, ' can see Mgt Cny for the unit '
										, @product_id
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table = 'ut_user_group_map_temp';
				SET @permission_granted = 'can see Mgt Cny for the unit.';

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
					 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_see_users_mgt_cny, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;

		# We add the user to the list of user that will be in CC when there in a new case for this unit and role type:

DROP PROCEDURE IF EXISTS user_in_cc_for_cases;
DELIMITER $$
CREATE PROCEDURE user_in_cc_for_cases()
BEGIN
	IF (@user_in_cc_for_cases = 1)
	THEN 
		# We use a temporary table to make sure we do not have duplicates.
		
		# DELETE the temp table if it exists
		DROP TABLE IF EXISTS `component_cc_temp`;
		
		# Re-create the temp table
		CREATE TABLE `component_cc_temp` (
		  `user_id` MEDIUMINT(9) NOT NULL
		  ,`component_id` MEDIUMINT(9) NOT NULL
		) ENGINE=INNODB DEFAULT CHARSET=utf8;

		# Add the records that exist in the table component_cc
		INSERT INTO `component_cc_temp`
			SELECT *
			FROM `component_cc`;

		# Add the new user rights for the product
			INSERT INTO `component_cc_temp`
				(user_id
				, component_id
				)
				VALUES
				(@bz_user_id, @component_id)
				;
		
		# Empty the table `component_cc`
			TRUNCATE TABLE `component_cc`;
		
		# Add all the records for `component_cc`
			INSERT INTO `component_cc`
			SELECT `user_id`
				, `component_id`
			FROM
				`component_cc_temp`
			GROUP BY `user_id`
				, `component_id`
			;
		
		# We Delete the temp table as we do not need it anymore
			DROP TABLE IF EXISTS `component_cc_temp`;
				
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' is one of the copied assignee for the unit #'
									, @product_id
									, ' when the role '
									, @role_user_g_description
									, ' (the component #'
									, @component_id
									, ')'
									, ' is chosen'
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(NOW(), @script, @script_log_message)
				;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table = 'component_cc';
				SET @permission_granted = ' is in CC when role is chosen.';

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
					 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'component_id', 'UNKNOWN', @component_id, @script, CONCAT('Make sure the user ', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;	

END IF ;
END $$
DELIMITER ;			

# We give the user the permission they need.
# We need to do that via an intermediary table to make sure that we dedup the permissions
		
	# DELETE the temp table if it exists
		DROP TABLE IF EXISTS `ut_user_group_map_temp`;
	
	# Re-create the temp table
		CREATE TABLE `ut_user_group_map_temp` (
		`user_id` MEDIUMINT(9) NOT NULL,
		`group_id` MEDIUMINT(9) NOT NULL,
		`isbless` TINYINT(4) NOT NULL DEFAULT '0',
		`grant_type` TINYINT(4) NOT NULL DEFAULT '0'
		) ENGINE=INNODB DEFAULT CHARSET=utf8;

	# Add ALL the records that exist in the table user_group_map
		INSERT INTO `ut_user_group_map_temp`
			SELECT *
			FROM `user_group_map`;

# We CALL ALL the procedures that we have created TO CREATE the permissions we need:
	CALL time_tracking_permission;
	CALL can_create_shared_queries;
	CALL can_tag_comment;
	CALL show_to_occupant;
	CALL is_occupant;
	CALL can_see_occupant;
	CALL can_create_new_cases;
	CALL can_edit_a_case;
	CALL can_see_all_public_cases;
	CALL can_edit_all_field_in_a_case_regardless_of_role;
	CALL user_is_publicly_visible;
	CALL user_can_see_publicly_visible;
	CALL can_ask_to_approve;
	CALL can_approve;

	CALL show_to_tenant;
	CALL is_tenant;
	CALL can_see_tenant;

	CALL show_to_landlord;
	CALL are_users_landlord;
	CALL see_users_landlord;

	CALL show_to_agent;
	CALL are_users_agent;
	CALL see_users_agent;

	CALL show_to_contractor;
	CALL are_users_contractor;
	CALL see_users_contractor;

	CALL show_to_mgt_cny;
	CALL are_users_mgt_cny;
	CALL see_users_mgt_cny;

	CALL user_in_cc_for_cases;

# Then we update the `user_group_map` table
	
	# We truncate the table first (to avoid duplicates)
		TRUNCATE TABLE `user_group_map`;
		
	# We insert the data we need
		INSERT INTO `user_group_map`
		SELECT `user_id`
			, `group_id`
			, `isbless`
			, `grant_type`
		FROM
			`ut_user_group_map_temp`
		GROUP BY `user_id`
			, `group_id`
			, `isbless`
			, `grant_type`
		;

#Clean up
		
	# We Delete the temp table as we do not need it anymore
		DROP TABLE IF EXISTS `ut_user_group_map_temp`;
	
	# Delete the procedures that we do not need anymore:
		DROP PROCEDURE IF EXISTS insert_products;
		DROP PROCEDURE IF EXISTS time_tracking_permission;
		DROP PROCEDURE IF EXISTS can_create_shared_queries;
		DROP PROCEDURE IF EXISTS can_tag_comment;
		DROP PROCEDURE IF EXISTS show_to_occupant;
		DROP PROCEDURE IF EXISTS is_occupant;
		DROP PROCEDURE IF EXISTS can_see_occupant;
		DROP PROCEDURE IF EXISTS can_create_new_cases;
		DROP PROCEDURE IF EXISTS can_edit_a_case;
		DROP PROCEDURE IF EXISTS can_see_all_public_cases;
		DROP PROCEDURE IF EXISTS can_edit_all_field_in_a_case_regardless_of_role;
		DROP PROCEDURE IF EXISTS user_is_publicly_visible;
		DROP PROCEDURE IF EXISTS user_can_see_publicly_visible;
		DROP PROCEDURE IF EXISTS can_ask_to_approve;
		DROP PROCEDURE IF EXISTS can_approve;
		
		DROP PROCEDURE IF EXISTS show_to_tenant;
		DROP PROCEDURE IF EXISTS is_tenant;
		DROP PROCEDURE IF EXISTS can_see_tenant;

		DROP PROCEDURE IF EXISTS show_to_landlord;
		DROP PROCEDURE IF EXISTS are_users_landlord;
		DROP PROCEDURE IF EXISTS see_users_landlord;
		
		DROP PROCEDURE IF EXISTS show_to_agent;
		DROP PROCEDURE IF EXISTS are_users_agent;
		DROP PROCEDURE IF EXISTS see_users_agent;
		
		DROP PROCEDURE IF EXISTS show_to_contractor;
		DROP PROCEDURE IF EXISTS are_users_contractor;
		DROP PROCEDURE IF EXISTS see_users_contractor;
		
		DROP PROCEDURE IF EXISTS show_to_mgt_cny;
		DROP PROCEDURE IF EXISTS are_users_mgt_cny;
		DROP PROCEDURE IF EXISTS see_users_mgt_cny;
				
		DROP PROCEDURE IF EXISTS user_in_cc_for_cases;


# We implement the FK checks again
		
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;		
	

# The user
	
	# We record the information about the users that we have just created

#####################
#
#	WIP we are not doing this yet, the current version of this script creates dupes...
#
/*	
		INSERT INTO `ut_map_user_unit_details`
		(`created`
		,`record_created_by`
		,`user_id`
		,`bz_profile_id`
		,`public_name`
		,`comment`
		)
		VALUES
		(NOW(), @creator_bz_id, @bz_user_id, @bz_user_id, @user_pub_name, 'Created with the script -Insert_new_unit_and_role_in_unee-t_bzfe_v2.11-')
		;
*/
#
#
#####################

# We update the table 'ut_map_user_unit_details' so we can track the permissions given to the creator.

#####################
#
#	WIP we are not doing this yet, the current version of this script creates dupes...
#
/*	
	UPDATE `ut_map_user_unit_details`
		SET
		`bz_unit_id` = @product_id
		,`can_decide_if_user_visible` = 1
		,`can_decide_if_user_can_see_visible` = 1
		,`can_create_any_sh` = 1
		,`can_approve_user_for_flags` = 1
		,`is_public_assignee` = 1
		,`is_see_visible_assignee` = 1
		,`is_flag_requestee` = 1
		,`is_flag_approver` = 1
		, `comment` = CONCAT(`comment`, '\r\n The user is a creator for the unit-', @product_id)
		WHERE `bz_profile_id` = @creator_bz_id
		;
*/
#
#
#####################


#####################
#
#	WIP we are not doing this yet, the current version of this script creates dupes...
#
/*	
	# We update the table 'ut_map_user_unit_details'
		INSERT INTO `ut_map_user_unit_details`
			(`created`
			,`record_created_by`
			,`user_id`
			,`bz_profile_id`
			,`bz_unit_id`
			,`role_type_id`
			,`public_name`
			,`comment`
			)
			VALUES
			(NOW(), @creator_bz_id, @bz_user_id, @bz_user_id, @product_id, @id_role_type, @user_pub_name, 'Created with Insert_new_unit_and_role_in_unee-t_bzfe_v2.11.sql')
			;		
*/
#
#
#####################

#################
#
# WIP
#
#	INSERT  INTO `ut_series_categories`
#		(`id`
#		,`name`
#		) 
#		VALUES 
#		(NULL,CONCAT(@stakeholder,'_#',@product_id)),
#		(NULL,CONCAT(@unit,'_#',@product_id));
#
#	SET @series_2 = (SELECT `id` FROM `ut_series_categories` WHERE `name` = '-All-');
#	SET @series_1 = (SELECT `id` FROM `ut_series_categories` WHERE `name` = CONCAT(@stakeholder,'_#',@product_id));
#	SET @series_3 = (SELECT `id` FROM `ut_series_categories` WHERE `name` = CONCAT(@unit,'_#',@product_id));
#
#	INSERT  INTO `ut_series`
#		(`series_id`
#		,`creator`
#		,`category`
#		,`subcategory`
#		,`name`
#		,`frequency`
#		,`query`
#		,`is_public`
#		) 
#		VALUES 
#		(NULL,@bz_user_id,@series_1,@series_2,'UNCONFIRMED',1,CONCAT('bug_status=UNCONFIRMED&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_2,'CONFIRMED',1,CONCAT('bug_status=CONFIRMED&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_2,'IN_PROGRESS',1,CONCAT('bug_status=IN_PROGRESS&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_2,'REOPENED',1,CONCAT('bug_status=REOPENED&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_2,'STAND BY',1,CONCAT('bug_status=STAND%20BY&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_2,'RESOLVED',1,CONCAT('bug_status=RESOLVED&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_2,'VERIFIED',1,CONCAT('bug_status=VERIFIED&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_2,'CLOSED',1,CONCAT('bug_status=CLOSED&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_2,'FIXED',1,CONCAT('resolution=FIXED&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_2,'INVAL`status_workflow`ID',1,CONCAT('resolution=INVAL%60status_workflow%60ID&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_2,'WONTFIX',1,CONCAT('resolution=WONTFIX&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_2,'DUPLICATE',1,CONCAT('resolution=DUPLICATE&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_2,'WORKSFORME',1,CONCAT('resolution=WORKSFORME&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_2,'All Open',1,CONCAT('bug_status=UNCONFIRMED&bug_status=CONFIRMED&bug_status=IN_PROGRESS&bug_status=REOPENED&bug_status=STAND%20BY&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_3,'All Open',1,CONCAT('field0-0-0=resolution&type0-0-0=notregexp&value0-0-0=.&product=',@unit_for_query,'&component=',@stakeholder),1),
#		(NULL,@bz_user_id,@series_1,@series_3,'All Closed',1,CONCAT('field0-0-0=resolution&type0-0-0=regexp&value0-0-0=.&product=',@unit_for_query,'&component=',@stakeholder),1);
#
#	INSERT  INTO `ut_audit_log`
#		(`user_id`
#		,`class`
#		,`object_id`
#		,`field`
#		,`removed`
#		,`added`
#		,`at_time`
#		) 
#		VALUES 
#		(@bz_user_id,'Bugzilla::Component',@component_id,'__create__',NULL,@stakeholder,@timestamp),
#		(@bz_user_id,'Bugzilla::Group',@show_to_stakeholder_4_group_id,'__create__',NULL,CONCAT(@unit,' #',@product_id,'-',(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 4)),@timestamp),
#		(@bz_user_id,'Bugzilla::Group',@are_users_stakeholder_4_group_id,'__create__',NULL,CONCAT(@unit,' #',@product_id,'-List users-',(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 4)),@timestamp),
#		(@bz_user_id,'Bugzilla::Group',@see_users_stakeholder_4_group_id,'__create__',NULL,CONCAT(@unit,' #',@product_id,'-Can see who are stakeholder for comp #',@component_id),@timestamp),
#		(@bz_user_id,'Bugzilla::Group',@invited_by_group_id,'__create__',NULL,CONCAT(@unit,' #',@product_id,'-invited by user ',@creator_pub_name),@timestamp),
#		(@bz_user_id,'Bugzilla::Group',@see_invited_by_group_id,'__create__',NULL,CONCAT(@unit,' #',@product_id,'-Can see user invited by ',@creator_pub_name),@timestamp);
#
#
#####################

