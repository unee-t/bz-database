# For any question about this script, ask Franck

#############################################
#											#
# IMPORTANT INFORMATION ABOUT THIS SCRIPT	#
#											#
#############################################
#
# Built for BZFE database v2.13
#
# This script adds permissions for an existing BZ group of user to do certain things for a unit in a role which has already been created.
#
# Use this script only if 
#	- the Unit/Product ALREADY EXISTS in the BZFE
#	- the Role/component ALREADY EXISTS in the BZFE
#	- The Group of user already EXISTS in the BZFE
#
# This will guarantee that all the permissions groups that we need for that user already exist in the BZFE
#
# Limits of this script:
#	- DO NOT USE if the unit DOES NOT exists in the BZ database
#	  We will have a different script for that
#	- DO NOT USE if the role DOES NOT exists in the BZ database
#	  We will have a different script for that
#	- It gets MESSY if you do not realize that you are updating existing group permissions...
#
#################################################################
#																#
# UPDATE THE BELOW VARIABLES ACCORDING TO YOUR NEEDS			#
#																#
#################################################################

# The unit:

	# enter the BZ product id for the unit
	SET @product_id = 276;
	
# The BZ group that you want to associat to the unit.
	# BZ user groupid of the user that you want to associate to the unit.
	SET @bz_user_group_id = 47;

	# Is the BZ user group a group for the occupants of the unit?
	SET @group_is_occupant = 0;

	# Role of the user associated to this new unit:
	#	- Tenant 1
	# 	- Landlord 2
	#	- Agent 5
	#	- Contractor 3
	#	- Management company 4
	SET @id_role_type = 4;

#########
# WARNING - NOT IN THE PERMISSION TABLE YET			
	# Can the BZ user see the list of the occupants for the unit?
	SET @group_can_see_occupant = 0;		
	SET @group_can_see_tenant = 0;
	SET @group_can_see_landlord = 0;
	SET @group_can_see_agent = 0;
	SET @group_can_see_contractor = 0;
	SET @group_can_see_mgt_cny = 1;
#
#########

# Global permission for the user group:
	SET @group_can_see_time_tracking = 1;
	SET @group_can_create_shared_queries = 1;
	# The below permission is mandatory as this will allow us to add reactions (smileys)
	# or notifications to the comments by a user.
	SET @group_can_tag_comment = 1;
		
# Permissions for the group for this unit and this role
	# User permissions (for THIS PRODUCT ONLY):

		SET @group_can_create_new_cases = 1;
		SET @group_can_edit_a_case = 1;
		SET @group_can_see_all_public_cases = 1;
		# This is mandatory for triage users!
		SET @group_can_edit_all_field_in_a_case_regardless_of_role = 0;
		SET @user_group_is_publicly_visible = 0;
		SET @user_group_can_see_publicly_visible = 1;

		SET @user_in_cc_for_cases = 0;

		# WARNING: The below permission makes the show/hide user functionality less efficient...
		# A user who can directly ask to approve will automatically see all the approvers for the flags...
		
		# This should read: can_be_asked_to_approve_and_approve
		SET @group_can_ask_to_approve = 1;
		# This should read: can_request_to_approve
		SET @group_can_approve = 0;
	
	# Permission to create or alter other users:
	# (This is done by granting the user permission to grant membership to other users to certain groups)
	#
	# WARNING: The below permission is VERY powerful and the main reason why it is 
	# NOT a good idea to give users accesses to the BZFE as they could break a lot of things there...
	# This is absolutely necessary though if we want the user to be able to invite other users.	

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

		
/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

# Info about this script
	SET @script = '5_Insert_existing_group_of_bz_users_in_an_existing_unit_and_role_bzfe_v2.13.sql';

###############
#
# AT THIS POINT WE ARE NOT UPDATING THIS TABLE
#
/*
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
*/
#
#
##################

# The component/role that the user will have for this unit.
	# We get that information based on the information we have about the product and the role for the user.
		SET @component_id = (SELECT `component_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `role_type_id` = @id_role_type AND `group_type_id` = 2));
		
# The Groups to grant the various permissions for the user group
	
	# The global permission for the application
	# This should not change, it was hard coded when we created Unee-T
		# See time tracking
		SET @can_see_time_tracking_group_id = 16;
		# Can create shared queries
		SET @can_create_shared_queries_group_id = 17;
		# Can tag comments
		SET @can_tag_comment_group_id = 18;

	# Groups created when we created the product
	#	- create_case_group_id
	#	- can_edit_case_group_id
	#	- can_edit_all_field_case_group_id
	#	- can_edit_component_group_id
	#	- can_see_cases_group_id
	#	- all_g_flags_group_id
	#	- all_r_flags_group_id
	#	- list_visible_assignees_group_id
	#	- see_visible_assignees_group_id
###########
#
# Obsolete
#
	#	- active_stakeholder_group_id
#
###########
	#	- unit_creator_group_id
	# We need to ge these from the ut_product_table_based on the product_id!
		SET @create_case_group_id =  (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 20));
		SET @can_edit_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 25));
		SET @can_edit_all_field_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 26));
		SET @can_edit_component_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 27));
		SET @can_see_cases_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 28));
		SET @all_r_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 18));
		SET @all_g_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 19));
		SET @list_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 4));
		SET @see_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 5));
#		SET @active_stakeholder_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 29));
		SET @unit_creator_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 1));

	# Groups created when we created the Role for this product.
	#	- show_to_tenant
	#	- are_users_tenant
	#	- see_users_tenant
	#	- show_to_landlord
	#	- are_users_landlord
	#	- see_users_landlord
	#	- show_to_agent
	#	- are_users_agent
	#	- see_users_agent
	#	- show_to_contractor
	#	- are_users_contractor
	#	- see_users_contractor
	#	- show_to_mgt_cny
	#	- are_users_mgt_cny
	#	- see_users_mgt_cny
	#	- show_to_occupant
	#	- are_users_occupant
	#	- see_users_occupant

		SET @group_id_show_to_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 24));
		SET @group_id_are_users_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 3));
		SET @group_id_see_users_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 36));

		SET @group_id_show_to_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 1));
		SET @group_id_are_users_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 1));
		SET @group_id_see_users_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 5 AND `role_type_id` = 1));

		SET @group_id_show_to_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 2));
		SET @group_id_are_users_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 2));
		SET @group_id_see_users_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 5 AND `role_type_id` = 2));

		SET @group_id_show_to_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 5));
		SET @group_id_are_users_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 5));
		SET @group_id_see_users_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 5 AND `role_type_id` = 5));

		SET @group_id_show_to_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 3));
		SET @group_id_are_users_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 3));
		SET @group_id_see_users_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 5 AND `role_type_id` = 3));

		SET @group_id_show_to_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 4));
		SET @group_id_are_users_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 4));
		SET @group_id_see_users_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 5 AND `role_type_id` = 4));

	# We use a temporary table `ut_group_group_map_temp` to make sure we do not have duplicates.
		
		# DELETE the temp table if it exists
		DROP TABLE IF EXISTS `ut_group_group_map_temp`;
		
		# Re-create the temp table
		CREATE TABLE `ut_group_group_map_temp` (
		  `member_id` MEDIUMINT(9) NOT NULL,
		  `grantor_id` MEDIUMINT(9) NOT NULL,
		  `grant_type` TINYINT(4) NOT NULL DEFAULT 0
		) ENGINE=INNODB DEFAULT CHARSET=utf8;

		# Add the records that exist in the table group_group_map
		INSERT INTO `ut_group_group_map_temp`
			SELECT *
			FROM `group_group_map`;
			
		# We make sure that we remove all the permission that we had previously created for this group and for this product
		# This is to make sure that we are starting from a fresh start...
		DELETE FROM `ut_group_group_map_temp`
			WHERE (
				(`member_id` = @bz_user_group_id AND `grantor_id` = @can_see_time_tracking_group_id)
				OR (`member_id` = @bz_user_group_id AND `grantor_id` = @can_create_shared_queries_group_id)
				OR (`member_id` = @bz_user_group_id AND `grantor_id` = @can_tag_comment_group_id)
				OR (`member_id` = @bz_user_group_id AND `grantor_id` = @create_case_group_id)
				OR (`member_id` = @bz_user_group_id AND `grantor_id` = @can_edit_case_group_id)
				OR (`member_id` = @bz_user_group_id AND `grantor_id` = @can_edit_all_field_case_group_id)
				OR (`member_id` = @bz_user_group_id AND `grantor_id` = @can_edit_component_group_id)
				OR (`member_id` = @bz_user_group_id AND `grantor_id` = @can_see_cases_group_id)
				OR (`member_id` = @bz_user_group_id AND `grantor_id` = @all_r_flags_group_id)
				OR (`member_id` = @bz_user_group_id AND `grantor_id` = @all_g_flags_group_id)
				OR (`member_id` = @bz_user_group_id AND `grantor_id` = @list_visible_assignees_group_id)
				OR (`member_id` = @bz_user_group_id AND `grantor_id` = @see_visible_assignees_group_id)
				OR (`member_id` = @bz_user_group_id AND `grantor_id` = @active_stakeholder_group_id)
				OR (`member_id` = @bz_user_group_id AND `grantor_id` = @unit_creator_group_id)
				OR (`member_id` = @bz_user_group_id AND `grantor_id` = @group_id_show_to_occupant)
				OR (`member_id` = @bz_user_group_id AND `grantor_id` = @group_id_are_users_occupant)
				OR (`member_id` = @bz_user_group_id AND `grantor_id` = @group_id_see_users_occupant)
				OR (`member_id` = @bz_user_group_id AND `grantor_id` = @group_id_show_to_tenant)
				OR (`member_id` = @bz_user_group_id AND `grantor_id` = @group_id_are_users_tenant)
				OR (`member_id` = @bz_user_group_id AND `grantor_id` = @group_id_see_users_tenant)
				OR (`member_id` = @bz_user_group_id AND `grantor_id` = @group_id_show_to_landlord)
				OR (`member_id` = @bz_user_group_id AND `grantor_id` = @group_id_are_users_landlord)
				OR (`member_id` = @bz_user_group_id AND `grantor_id` = @group_id_see_users_landlord)
				OR (`member_id` = @bz_user_group_id AND `grantor_id` = @group_id_show_to_agent)
				OR (`member_id` = @bz_user_group_id AND `grantor_id` = @group_id_are_users_agent)
				OR (`member_id` = @bz_user_group_id AND `grantor_id` = @group_id_see_users_agent)
				OR (`member_id` = @bz_user_group_id AND `grantor_id` = @group_id_show_to_contractor)
				OR (`member_id` = @bz_user_group_id AND `grantor_id` = @group_id_are_users_contractor)
				OR (`member_id` = @bz_user_group_id AND `grantor_id` = @group_id_see_users_contractor)
				OR (`member_id` = @bz_user_group_id AND `grantor_id` = @group_id_show_to_mgt_cny)
				OR (`member_id` = @bz_user_group_id AND `grantor_id` = @group_id_are_users_mgt_cny)
				OR (`member_id` = @bz_user_group_id AND `grantor_id` = @group_id_see_users_mgt_cny)
				)
				;


# Add the new group rights for the product
# We need to create several procedures for each permissions
#	- time_tracking_permission
#	- can_create_shared_queries
#	- can_tag_comment
#
#	- show_to_occupant
#	- is_occupant
#	- group_can_see_occupant
#
#	- can_create_new_cases
#	- can_edit_a_case
#	- group_can_see_all_public_cases
#	- can_edit_all_field_in_a_case_regardless_of_role
#	- user_is_publicly_visible
#	- user_group_can_see_publicly_visible
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
#

#########
#
#	Below is WIP
#
#	- can_edit_component_group_id
#
#	- can_create_same_stakeholder
#	- can_create_any_stakeholder
#	- can_approve_user_for_flag
#	- can_decide_if_user_is_occupant
#	- can_decide_if_user_can_see_visible_occupant
#	- can_decide_if_user_is_visible
#	- can_decide_if_user_can_see_visible
#
#########

	# First the global permissions:
		# Can see timetracking
DROP PROCEDURE IF EXISTS group_time_tracking_permission;
DELIMITER $$
CREATE PROCEDURE group_time_tracking_permission()
BEGIN
	IF (@group_can_see_time_tracking = 1)
	THEN INSERT  INTO `ut_group_group_map_temp`
				(`member_id`
				,`grantor_id`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_group_id,@can_see_time_tracking_group_id, 0)
				;
				
			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user group #'
										, @bz_user_group_id
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
				
				SET @bzfe_table = 'ut_group_group_map_temp';
				
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
					 (NOW() ,@bzfe_table, 'member_id', 'UNKNOWN', @bz_user_group_id, @script, 'Add the bz user groupid when we grant the permission to see time tracking')
					 , (NOW() ,@bzfe_table, 'grantor_id', 'UNKNOWN', @can_see_time_tracking_group_id, @script, 'group does NOT grant see time tracking permission')
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'group is a member of the group see time tracking')
					 ;
				 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
END IF ;
END $$
DELIMITER ;
	
		# Can create shared queries
DROP PROCEDURE IF EXISTS group_can_create_shared_queries;
DELIMITER $$
CREATE PROCEDURE group_can_create_shared_queries()
BEGIN
	IF (@group_can_create_shared_queries = 1)
	THEN INSERT INTO `ut_group_group_map_temp`
				(`member_id`
				,`grantor_id`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_group_id,@can_create_shared_queries_group_id, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user group#'
										, @bz_user_group_id
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

				SET @bzfe_table = 'ut_group_group_map_temp';

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
						 (NOW() ,@bzfe_table, 'member_id', 'UNKNOWN', @bz_user_group_id, @script, 'Add the bz user groupid when we grant the permission to create shared queries')
						 , (NOW() ,@bzfe_table, 'grantor_id', 'UNKNOWN', @can_create_shared_queries_group_id, @script, 'group does NOT grant create shared queries permission')
						 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'group is a member of the group create shared queries')
						 ;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
END IF ;
END $$
DELIMITER ;

		# Can tag comments
DROP PROCEDURE IF EXISTS group_can_tag_comment;
DELIMITER $$
CREATE PROCEDURE group_can_tag_comment()
BEGIN
	IF (@group_can_tag_comment = 1)
	THEN INSERT INTO `ut_group_group_map_temp`
				(`member_id`
				,`grantor_id`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_group_id,@can_tag_comment_group_id, 0)
				;
				
			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user group#'
										, @bz_user_group_id
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
				
				SET @bzfe_table = 'ut_group_group_map_temp';

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
					 (NOW() ,@bzfe_table, 'member_id', 'UNKNOWN', @bz_user_group_id, @script, 'Add the bz user groupid when we grant the permission to tag comments')
					 , (NOW() ,@bzfe_table, 'grantor_id', 'UNKNOWN', @can_tag_comment_group_id, @script, 'group does NOT grant tag comments permission')
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'group is a member of the group tag comments')
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
END IF ;
END $$
DELIMITER ;
				
	# Then the permissions at the unit/product level:

		# User is an occupant in the unit:
DROP PROCEDURE IF EXISTS group_show_to_occupant;
DELIMITER $$
CREATE PROCEDURE group_show_to_occupant()
BEGIN
	IF (@group_is_occupant = 1)
	THEN INSERT INTO `ut_group_group_map_temp`
				(`member_id`
				,`grantor_id`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_group_id, @group_id_show_to_occupant, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user group#'
										, @bz_user_group_id
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
				
				SET @bzfe_table = 'ut_group_group_map_temp';
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
					 (NOW() ,@bzfe_table, 'member_id', 'UNKNOWN', @bz_user_group_id, @script, CONCAT('Add the bz user groupid when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'grantor_id', 'UNKNOWN', @group_id_show_to_occupant, @script, CONCAT('group does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('group is a member of the group ', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;	
	
	
		# User is an occupant in the unit:
DROP PROCEDURE IF EXISTS group_is_occupant;
DELIMITER $$
CREATE PROCEDURE group_is_occupant()
BEGIN
	IF (@group_is_occupant = 1)
	THEN INSERT INTO `ut_group_group_map_temp`
				(`member_id`
				,`grantor_id`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_group_id, @group_id_are_users_occupant, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user group#'
										, @bz_user_group_id
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
				
				SET @bzfe_table = 'ut_group_group_map_temp';
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
					 (NOW() ,@bzfe_table, 'member_id', 'UNKNOWN', @bz_user_group_id, @script, CONCAT('Add the bz user groupid when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'grantor_id', 'UNKNOWN', @group_id_are_users_occupant, @script, CONCAT('group does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('group is a member of the group ', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;

		# User can see all the occupants in the unit:
DROP PROCEDURE IF EXISTS group_can_see_occupant;
DELIMITER $$
CREATE PROCEDURE group_can_see_occupant()
BEGIN
	IF (@group_can_see_occupant = 1)
	THEN INSERT INTO `ut_group_group_map_temp`
				(`member_id`
				,`grantor_id`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_group_id, @group_id_see_users_occupant, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user group#'
										, @bz_user_group_id
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
				
				SET @bzfe_table = 'ut_group_group_map_temp';
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
					 (NOW() ,@bzfe_table, 'member_id', 'UNKNOWN', @bz_user_group_id, @script, CONCAT('Add the bz user groupid when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'grantor_id', 'UNKNOWN', @group_id_see_users_occupant, @script, CONCAT('group does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('group is a member of the group ', @permission_granted))
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
DROP PROCEDURE IF EXISTS group_can_create_new_cases;
DELIMITER $$
CREATE PROCEDURE group_can_create_new_cases()
BEGIN
	IF (@group_can_create_new_cases = 1)
	THEN INSERT INTO `ut_group_group_map_temp`
				(`member_id`
				,`grantor_id`
				,`grant_type`
				) 
				VALUES 
				# There can be cases when a user is only allowed to see existing cases but NOT create new one.
				# This is an unlikely scenario, but this is technically possible...
				(@bz_user_group_id, @create_case_group_id, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user group#'
										, @bz_user_group_id
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
				
				SET @bzfe_table = 'ut_group_group_map_temp';
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
					 (NOW() ,@bzfe_table, 'member_id', 'UNKNOWN', @bz_user_group_id, @script, CONCAT('Add the bz user groupid when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'grantor_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('group does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('group is a member of the group ', @permission_granted))
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
DROP PROCEDURE IF EXISTS group_can_edit_a_case;
DELIMITER $$
CREATE PROCEDURE group_can_edit_a_case()
BEGIN
	IF (@group_can_edit_a_case = 1)
	THEN INSERT INTO `ut_group_group_map_temp`
				(`member_id`
				,`grantor_id`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_group_id, @can_edit_case_group_id, 0)	
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user group#'
										, @bz_user_group_id
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
				
				SET @bzfe_table = 'ut_group_group_map_temp';
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
					 (NOW() ,@bzfe_table, 'member_id', 'UNKNOWN', @bz_user_group_id, @script, CONCAT('Add the bz user groupid when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'grantor_id', 'UNKNOWN', @can_edit_case_group_id, @script, CONCAT('group does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('group is a member of the group ', @permission_granted))
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
DROP PROCEDURE IF EXISTS group_can_see_all_public_cases;
DELIMITER $$
CREATE PROCEDURE group_can_see_all_public_cases()
BEGIN
	IF (@group_can_see_all_public_cases = 1)
	THEN INSERT INTO `ut_group_group_map_temp`
				(`member_id`
				,`grantor_id`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_group_id, @can_see_cases_group_id, 0)	
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user group#'
										, @bz_user_group_id
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
				
				SET @bzfe_table = 'ut_group_group_map_temp';
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
					 (NOW() ,@bzfe_table, 'member_id', 'UNKNOWN', @bz_user_group_id, @script, CONCAT('Add the bz user groupid when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'grantor_id', 'UNKNOWN', @can_see_cases_group_id, @script, CONCAT('group does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('group is a member of the group ', @permission_granted))
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
DROP PROCEDURE IF EXISTS group_can_edit_all_field_in_a_case_regardless_of_role;
DELIMITER $$
CREATE PROCEDURE group_can_edit_all_field_in_a_case_regardless_of_role()
BEGIN
	IF (@group_can_edit_all_field_in_a_case_regardless_of_role = 1)
	THEN INSERT INTO `ut_group_group_map_temp`
				(`member_id`
				,`grantor_id`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_group_id, @can_edit_all_field_case_group_id, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user group#'
										, @bz_user_group_id
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
				
				SET @bzfe_table = 'ut_group_group_map_temp';
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
					 (NOW() ,@bzfe_table, 'member_id', 'UNKNOWN', @bz_user_group_id, @script, CONCAT('Add the bz user groupid when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'grantor_id', 'UNKNOWN', @can_edit_all_field_case_group_id, @script, CONCAT('group does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('group is a member of the group ', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;				
END IF ;
END $$
DELIMITER ;
				
		# User can be visible to other users regardless of the other users roles
DROP PROCEDURE IF EXISTS user_group_is_publicly_visible;
DELIMITER $$
CREATE PROCEDURE user_group_is_publicly_visible()
BEGIN
	IF (@user_group_is_publicly_visible = 1)
	THEN INSERT INTO `ut_group_group_map_temp`
				(`member_id`
				,`grantor_id`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_group_id, @list_visible_assignees_group_id, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user group#'
										, @bz_user_group_id
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
				
				SET @bzfe_table = 'ut_group_group_map_temp';
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
					 (NOW() ,@bzfe_table, 'member_id', 'UNKNOWN', @bz_user_group_id, @script, CONCAT('Add the bz user groupid when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'grantor_id', 'UNKNOWN', @list_visible_assignees_group_id, @script, CONCAT('group does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('group is a member of the group ', @permission_granted))
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
DROP PROCEDURE IF EXISTS user_group_can_see_publicly_visible;
DELIMITER $$
CREATE PROCEDURE user_group_can_see_publicly_visible()
BEGIN
	IF (@user_group_can_see_publicly_visible = 1)
	THEN INSERT INTO `ut_group_group_map_temp`
				(`member_id`
				,`grantor_id`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_group_id, @see_visible_assignees_group_id, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user group#'
										, @bz_user_group_id
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
				
				SET @bzfe_table = 'ut_group_group_map_temp';
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
					 (NOW() ,@bzfe_table, 'member_id', 'UNKNOWN', @bz_user_group_id, @script, CONCAT('Add the bz user groupid when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'grantor_id', 'UNKNOWN', @see_visible_assignees_group_id, @script, CONCAT('group does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('group is a member of the group ', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;				
END IF ;
END $$
DELIMITER ;				

			#user can create flags (approval requests)				
				
DROP PROCEDURE IF EXISTS group_can_ask_to_approve;
DELIMITER $$
CREATE PROCEDURE group_can_ask_to_approve()
BEGIN
	IF (@group_can_ask_to_approve = 1)
	THEN INSERT INTO `ut_group_group_map_temp`
				(`member_id`
				,`grantor_id`
				,`grant_type`
				) 
				VALUES
				(@bz_user_group_id, @all_r_flags_group_id, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user group#'
										, @bz_user_group_id
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
				
				SET @bzfe_table = 'ut_group_group_map_temp';
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
					 (NOW() ,@bzfe_table, 'member_id', 'UNKNOWN', @bz_user_group_id, @script, CONCAT('Add the bz user groupid when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'grantor_id', 'UNKNOWN', @all_r_flags_group_id, @script, CONCAT('group does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('group is a member of the group ', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;	
				
END IF ;
END $$
DELIMITER ;			
				
			# user can approve all the flags
	
DROP PROCEDURE IF EXISTS group_can_approve;
DELIMITER $$
CREATE PROCEDURE group_can_approve()
BEGIN
	IF (@group_can_approve = 1)
	THEN INSERT INTO `ut_group_group_map_temp`
				(`member_id`
				,`grantor_id`
				,`grant_type`
				) 
				VALUES
				(@bz_user_group_id, @all_g_flags_group_id, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user group#'
										, @bz_user_group_id
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
				
				SET @bzfe_table = 'ut_group_group_map_temp';
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
					 (NOW() ,@bzfe_table, 'member_id', 'UNKNOWN', @bz_user_group_id, @script, CONCAT('Add the bz user groupid when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'grantor_id', 'UNKNOWN', @all_g_flags_group_id, @script, CONCAT('group does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('group is a member of the group ', @permission_granted))
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
DROP PROCEDURE IF EXISTS group_show_to_tenant;
DELIMITER $$
CREATE PROCEDURE group_show_to_tenant()
BEGIN
	IF (@id_role_type = 1)
	THEN INSERT INTO `ut_group_group_map_temp`
				(`member_id`
				,`grantor_id`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_group_id, @group_id_show_to_tenant, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user group#'
										, @bz_user_group_id
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
				
				SET @bzfe_table = 'ut_group_group_map_temp';
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
					 (NOW() ,@bzfe_table, 'member_id', 'UNKNOWN', @bz_user_group_id, @script, CONCAT('Add the bz user groupid when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'grantor_id', 'UNKNOWN', @group_id_show_to_tenant, @script, CONCAT('group does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('group is a member of the group ', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;	
	
	
		# User is a tenant in the unit:
DROP PROCEDURE IF EXISTS group_is_tenant;
DELIMITER $$
CREATE PROCEDURE group_is_tenant()
BEGIN
	IF (@id_role_type = 1)
	THEN INSERT INTO `ut_group_group_map_temp`
				(`member_id`
				,`grantor_id`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_group_id, @group_id_are_users_tenant, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user group#'
										, @bz_user_group_id
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
				
				SET @bzfe_table = 'ut_group_group_map_temp';
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
					 (NOW() ,@bzfe_table, 'member_id', 'UNKNOWN', @bz_user_group_id, @script, CONCAT('Add the bz user groupid when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'grantor_id', 'UNKNOWN', @group_id_are_users_tenant, @script, CONCAT('group does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('group is a member of the group ', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;

		# User can see all the tenant in the unit:
DROP PROCEDURE IF EXISTS group_can_see_tenant;
DELIMITER $$
CREATE PROCEDURE group_can_see_tenant()
BEGIN
	IF (@group_can_see_tenant = 1)
	THEN INSERT INTO `ut_group_group_map_temp`
				(`member_id`
				,`grantor_id`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_group_id, @group_id_see_users_tenant, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user group#'
										, @bz_user_group_id
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
				
				SET @bzfe_table = 'ut_group_group_map_temp';
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
					 (NOW() ,@bzfe_table, 'member_id', 'UNKNOWN', @bz_user_group_id, @script, CONCAT('Add the bz user groupid when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'grantor_id', 'UNKNOWN', @group_id_see_users_tenant, @script, CONCAT('group does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('group is a member of the group ', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;
		
			# User can see the cases for Landlord in the unit:
DROP PROCEDURE IF EXISTS group_show_to_landlord;
DELIMITER $$
CREATE PROCEDURE group_show_to_landlord()
BEGIN
	IF (@id_role_type = 2)
	THEN INSERT INTO `ut_group_group_map_temp`
				(`member_id`
				,`grantor_id`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_group_id, @group_id_show_to_landlord, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user group#'
										, @bz_user_group_id
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
				
				SET @bzfe_table = 'ut_group_group_map_temp';
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
					 (NOW() ,@bzfe_table, 'member_id', 'UNKNOWN', @bz_user_group_id, @script, CONCAT('Add the bz user groupid when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'grantor_id', 'UNKNOWN', @group_id_show_to_landlord, @script, CONCAT('group does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('group is a member of the group ', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;	
	
		# User is a landlord for the unit:
DROP PROCEDURE IF EXISTS group_are_users_landlord;
DELIMITER $$
CREATE PROCEDURE group_are_users_landlord()
BEGIN
	IF (@id_role_type = 1)
	THEN INSERT INTO `ut_group_group_map_temp`
				(`member_id`
				,`grantor_id`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_group_id, @group_id_are_users_landlord, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user group#'
										, @bz_user_group_id
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
				
				SET @bzfe_table = 'ut_group_group_map_temp';
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
					 (NOW() ,@bzfe_table, 'member_id', 'UNKNOWN', @bz_user_group_id, @script, CONCAT('Add the bz user groupid when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'grantor_id', 'UNKNOWN', @group_id_are_users_landlord, @script, CONCAT('group does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('group is a member of the group ', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;

		# User can see all the tenant in the unit:
DROP PROCEDURE IF EXISTS group_can_see_users_landlord;
DELIMITER $$
CREATE PROCEDURE group_can_see_users_landlord()
BEGIN
	IF (@group_can_see_landlord = 1)
	THEN INSERT INTO `ut_group_group_map_temp`
				(`member_id`
				,`grantor_id`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_group_id, @group_id_see_users_landlord, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user group#'
										, @bz_user_group_id
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
				
				SET @bzfe_table = 'ut_group_group_map_temp';
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
					 (NOW() ,@bzfe_table, 'member_id', 'UNKNOWN', @bz_user_group_id, @script, CONCAT('Add the bz user groupid when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'grantor_id', 'UNKNOWN', @group_id_see_users_landlord, @script, CONCAT('group does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('group is a member of the group ', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;

			# User can see the cases for agent in the unit:
DROP PROCEDURE IF EXISTS group_show_to_agent;
DELIMITER $$
CREATE PROCEDURE group_show_to_agent()
BEGIN
	IF (@id_role_type = 5)
	THEN INSERT INTO `ut_group_group_map_temp`
				(`member_id`
				,`grantor_id`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_group_id, @group_id_show_to_agent, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user group#'
										, @bz_user_group_id
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
				
				SET @bzfe_table = 'ut_group_group_map_temp';
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
					 (NOW() ,@bzfe_table, 'member_id', 'UNKNOWN', @bz_user_group_id, @script, CONCAT('Add the bz user groupid when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'grantor_id', 'UNKNOWN', @group_id_show_to_agent, @script, CONCAT('group does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('group is a member of the group ', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;	
	
		# User is an agent for the unit:
DROP PROCEDURE IF EXISTS group_are_users_agent;
DELIMITER $$
CREATE PROCEDURE group_are_users_agent()
BEGIN
	IF (@id_role_type = 5)
	THEN INSERT INTO `ut_group_group_map_temp`
				(`member_id`
				,`grantor_id`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_group_id, @group_id_are_users_agent, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user group#'
										, @bz_user_group_id
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
				
				SET @bzfe_table = 'ut_group_group_map_temp';
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
					 (NOW() ,@bzfe_table, 'member_id', 'UNKNOWN', @bz_user_group_id, @script, CONCAT('Add the bz user groupid when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'grantor_id', 'UNKNOWN', @group_id_are_users_agent, @script, CONCAT('group does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('group is a member of the group ', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;

		# User can see all the agents in the unit:
DROP PROCEDURE IF EXISTS group_can_see_users_agent;
DELIMITER $$
CREATE PROCEDURE group_can_see_users_agent()
BEGIN
	IF (@group_can_see_agent = 1)
	THEN INSERT INTO `ut_group_group_map_temp`
				(`member_id`
				,`grantor_id`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_group_id, @group_id_see_users_agent, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user group#'
										, @bz_user_group_id
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
				
				SET @bzfe_table = 'ut_group_group_map_temp';
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
					 (NOW() ,@bzfe_table, 'member_id', 'UNKNOWN', @bz_user_group_id, @script, CONCAT('Add the bz user groupid when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'grantor_id', 'UNKNOWN', @group_id_see_users_agent, @script, CONCAT('group does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('group is a member of the group ', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;

			# User can see the cases for contractor for the unit:
DROP PROCEDURE IF EXISTS group_show_to_contractor;
DELIMITER $$
CREATE PROCEDURE group_show_to_contractor()
BEGIN
	IF (@id_role_type = 3)
	THEN INSERT INTO `ut_group_group_map_temp`
				(`member_id`
				,`grantor_id`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_group_id, @group_id_show_to_contractor, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user group#'
										, @bz_user_group_id
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
				
				SET @bzfe_table = 'ut_group_group_map_temp';
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
					 (NOW() ,@bzfe_table, 'member_id', 'UNKNOWN', @bz_user_group_id, @script, CONCAT('Add the bz user groupid when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'grantor_id', 'UNKNOWN', @group_id_show_to_contractor, @script, CONCAT('group does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('group is a member of the group ', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;	
	
		# User is a contractor for the unit:
DROP PROCEDURE IF EXISTS group_are_users_contractor;
DELIMITER $$
CREATE PROCEDURE group_are_users_contractor()
BEGIN
	IF (@id_role_type = 3)
	THEN INSERT INTO `ut_group_group_map_temp`
				(`member_id`
				,`grantor_id`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_group_id, @group_id_are_users_contractor, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user group#'
										, @bz_user_group_id
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
				
				SET @bzfe_table = 'ut_group_group_map_temp';
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
					 (NOW() ,@bzfe_table, 'member_id', 'UNKNOWN', @bz_user_group_id, @script, CONCAT('Add the bz user groupid when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'grantor_id', 'UNKNOWN', @group_id_are_users_contractor, @script, CONCAT('group does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('group is a member of the group ', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;

		# User can see all the agents in the unit:
DROP PROCEDURE IF EXISTS group_can_see_users_contractor;
DELIMITER $$
CREATE PROCEDURE group_can_see_users_contractor()
BEGIN
	IF (@group_can_see_contractor = 1)
	THEN INSERT INTO `ut_group_group_map_temp`
				(`member_id`
				,`grantor_id`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_group_id, @group_id_see_users_contractor, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user group#'
										, @bz_user_group_id
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
				
				SET @bzfe_table = 'ut_group_group_map_temp';
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
					 (NOW() ,@bzfe_table, 'member_id', 'UNKNOWN', @bz_user_group_id, @script, CONCAT('Add the bz user groupid when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'grantor_id', 'UNKNOWN', @group_id_see_users_contractor, @script, CONCAT('group does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('group is a member of the group ', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;
		
		
		
		
		
			# User can see the cases for Management Cny for the unit:
DROP PROCEDURE IF EXISTS group_show_to_mgt_cny;
DELIMITER $$
CREATE PROCEDURE group_show_to_mgt_cny()
BEGIN
	IF (@id_role_type = 4)
	THEN INSERT INTO `ut_group_group_map_temp`
				(`member_id`
				,`grantor_id`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_group_id, @group_id_show_to_mgt_cny, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user group#'
										, @bz_user_group_id
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
				
				SET @bzfe_table = 'ut_group_group_map_temp';
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
					 (NOW() ,@bzfe_table, 'member_id', 'UNKNOWN', @bz_user_group_id, @script, CONCAT('Add the bz user groupid when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'grantor_id', 'UNKNOWN', @group_id_show_to_mgt_cny, @script, CONCAT('group does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('group is a member of the group ', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;	
	
		# User is a Mgt Cny for the unit:
DROP PROCEDURE IF EXISTS group_are_users_mgt_cny;
DELIMITER $$
CREATE PROCEDURE group_are_users_mgt_cny()
BEGIN
	IF (@id_role_type = 4)
	THEN INSERT INTO `ut_group_group_map_temp`
				(`member_id`
				,`grantor_id`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_group_id, @group_id_are_users_mgt_cny, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user group#'
										, @bz_user_group_id
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
				
				SET @bzfe_table = 'ut_group_group_map_temp';
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
					 (NOW() ,@bzfe_table, 'member_id', 'UNKNOWN', @bz_user_group_id, @script, CONCAT('Add the bz user groupid when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'grantor_id', 'UNKNOWN', @group_id_are_users_mgt_cny, @script, CONCAT('group does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('group is a member of the group ', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;

		# User can see all the employee of the Mgt Cny for the unit:
DROP PROCEDURE IF EXISTS group_can_see_users_mgt_cny;
DELIMITER $$
CREATE PROCEDURE group_can_see_users_mgt_cny()
BEGIN
	IF (@group_can_see_contractor = 1)
	THEN INSERT INTO `ut_group_group_map_temp`
				(`member_id`
				,`grantor_id`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_group_id, @group_id_see_users_mgt_cny, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user group#'
										, @bz_user_group_id
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
				
				SET @bzfe_table = 'ut_group_group_map_temp';
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
					 (NOW() ,@bzfe_table, 'member_id', 'UNKNOWN', @bz_user_group_id, @script, CONCAT('Add the bz user groupid when we grant the permission to ', @permission_granted))
					 , (NOW() ,@bzfe_table, 'grantor_id', 'UNKNOWN', @group_id_see_users_mgt_cny, @script, CONCAT('group does NOT grant ',@permission_granted, ' permission'))
					 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('group is a member of the group ', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;
			
#########
#
#	NOT READY YET THIS IS WIP
#
#
/*			


#################
#
# WIP
#
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

*/
#
#
#######

# We give the user the permission they need.
# We need to do that via an intermediary table to make sure that we dedup the permissions

# We CALL ALL the procedures that we have created TO CREATE the permissions we need:
CALL group_time_tracking_permission;
CALL group_can_create_shared_queries;
CALL group_can_tag_comment;
CALL group_show_to_occupant;
CALL group_is_occupant;
CALL group_can_see_occupant;
CALL group_can_create_new_cases;
CALL group_can_edit_a_case;
CALL group_can_see_all_public_cases;
CALL group_can_edit_all_field_in_a_case_regardless_of_role;
CALL user_group_is_publicly_visible;
CALL user_group_can_see_publicly_visible;
CALL group_can_ask_to_approve;
CALL group_can_approve;

CALL group_show_to_tenant;
CALL group_is_tenant;
CALL group_can_see_tenant;

CALL group_show_to_landlord;
CALL group_are_users_landlord;
CALL group_can_see_users_landlord;

CALL group_show_to_agent;
CALL group_are_users_agent;
CALL group_can_see_users_agent;

CALL group_show_to_contractor;
CALL group_are_users_contractor;
CALL group_can_see_users_contractor;

CALL group_show_to_mgt_cny;
CALL group_are_users_mgt_cny;
CALL group_can_see_users_mgt_cny;

#########
#
#	Below is WIP
#
#CALL can_edit_component;
#
#CALL can_create_same_stakeholder;
#CALL can_create_any_stakeholder;
#CALL can_approve_user_for_flag;
#CALL can_decide_if_user_is_occupant;
#CALL can_decide_if_user_can_see_visible_occupant;
#CALL can_decide_if_user_is_visible;
#CALL can_decide_if_user_can_see_visible;
#
#########
	
	# Then we update the `group_group_map` table
	
		# We truncate the table first (to avoid duplicates)
		TRUNCATE TABLE `group_group_map`;
		
		# We insert the data we need
		INSERT INTO `group_group_map`
		SELECT `member_id`
			, `grantor_id`
			, `grant_type`
		FROM
			`ut_group_group_map_temp`
		GROUP BY `member_id`
			, `grantor_id`
			, `grant_type`
		;

#Clean up
		
	# We Delete the temp table as we do not need it anymore
		DROP TABLE IF EXISTS `ut_group_group_map_temp`;
	
	# Delete the procedures that we do not need anymore:
		DROP PROCEDURE IF EXISTS insert_products;
		DROP PROCEDURE group_time_tracking_permission;
		DROP PROCEDURE group_can_create_shared_queries;
		DROP PROCEDURE group_can_tag_comment;
		DROP PROCEDURE group_show_to_occupant;
		DROP PROCEDURE group_is_occupant;
		DROP PROCEDURE group_can_see_occupant;
		DROP PROCEDURE group_can_create_new_cases;
		DROP PROCEDURE group_can_edit_a_case;
		DROP PROCEDURE group_can_see_all_public_cases;
		DROP PROCEDURE group_can_edit_all_field_in_a_case_regardless_of_role;
		DROP PROCEDURE user_group_is_publicly_visible;
		DROP PROCEDURE user_group_can_see_publicly_visible;
		DROP PROCEDURE group_can_ask_to_approve;
		DROP PROCEDURE group_can_approve;
		
		DROP PROCEDURE group_show_to_tenant;
		DROP PROCEDURE group_is_tenant;
		DROP PROCEDURE group_can_see_tenant;

		DROP PROCEDURE group_show_to_landlord;
		DROP PROCEDURE group_are_users_landlord;
		DROP PROCEDURE group_can_see_users_landlord;
		
		DROP PROCEDURE group_show_to_agent;
		DROP PROCEDURE group_are_users_agent;
		DROP PROCEDURE group_can_see_users_agent;
		
		DROP PROCEDURE group_show_to_contractor;
		DROP PROCEDURE group_are_users_contractor;
		DROP PROCEDURE group_can_see_users_contractor;
		
		DROP PROCEDURE group_show_to_mgt_cny;
		DROP PROCEDURE group_are_users_mgt_cny;
		DROP PROCEDURE group_can_see_users_mgt_cny;
		
		#########
		#
		#	Below is WIP
		#
		#DROP PROCEDURE can_edit_component;
		#
		#DROP PROCEDURE can_create_same_stakeholder;
		#DROP PROCEDURE can_create_any_stakeholder;
		#DROP PROCEDURE can_approve_user_for_flag;
		#DROP PROCEDURE can_decide_if_user_is_occupant;
		#DROP PROCEDURE can_decide_if_user_can_see_visible_occupant;
		#DROP PROCEDURE can_decide_if_user_is_visible;
		#DROP PROCEDURE can_decide_if_user_can_see_visible;
		#
		#########

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
