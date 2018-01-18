# For any question about this script, ask Franck

#############################################
#											#
# IMPORTANT INFORMATION ABOUT THIS SCRIPT	#
#											#
#############################################
#
# Built for BZFE database v2.13
#
# Use this script only if the Unit DOES NOT EXIST YET in the BZFE
#
# Pre-requisite:
#	- We know which classification we will use for this product/unit
#	- We know the BZ user id of the user that will be the default assignee for this unit
#	- We know the BZ user id of the user that creates this unit and first role.
# 
# This script will:
# 	- Create a New product/unit.
#	- Create all the flags associtated to this unit.
#	- Create all the component_id for all the roles we will need for that unit
#	- Create all the groups we need to grant the permissions we want for that unit
#	- Create the first role for this unit
#	- Log the group ids relevant so we can grant more permissions in the future
#	- Log the actions of this script for future audit and debugging.
#
# Limits of this script:
#	- DO NOT USE if the unit already exists in the BZ database
#	  We will have a different script for that
#
#################################################################
#																#
# UPDATE THE BELOW VARIABLES ACCORDING TO YOUR NEEDS			#
#																#
#################################################################

# The unit:

	# BZ Classification id for the unit that you want to create (default is 2)
	SET @classification_id = 3;
	
	# The name and description
	SET @unit_name = 'A Test Unit - SMBW 1';
	SET @unit_description = 'Description of the unit. lorem ipsum dolorem';

# The user associated to the first role in this unit.	

	# BZ user id of the user that is creating the unit (default is 1 - Administrator).
	# For LMB migration, we use 2 (support.nobody)
	SET @creator_bz_id = 2;

	# BZ user id of the user that you want to associate to the unit.
	SET @bz_user_id = 2;
	
	# More information about the user associated to this role in the unit:
	SET @role_user_more = 'LMB: the management Company';
	
	# Role of the user associated to this new unit:
	#	- Tenant 1
	# 	- Landlord 2
	#	- Agent 5
	#	- Contractor 3
	#	- Management company 4
	SET @id_role_type = 4;

	# Is the BZ user an occupant of the unit?
	SET @is_occupant = 0;

#########
# WARNING - NOT IN THE PERMISSION TABLE YET			
	# Can the BZ user see the list of the occupants for the unit?
	SET @can_see_occupant = 0;		
	SET @can_see_tenant = 0;
	SET @can_see_landlord = 0;
	SET @can_see_agent = 0;
	SET @can_see_contractor = 0;
	SET @can_see_mgt_cny = 1;
#
#########

# Global permission for the user:
	SET @can_see_time_tracking = 1;
	SET @can_create_shared_queries = 1;
	# The below permission is mandatory as this will allow us to add reactions (smileys)
	# or notifications to the comments by a user.
	SET @can_tag_comment = 1;
		
# Permissions for the user for this unit and this role
	# User permissions (for THIS PRODUCT ONLY):

		SET @can_create_new_cases = 1;
		SET @can_edit_a_case = 1;
		SET @can_see_all_public_cases = 1;
		SET @can_edit_all_field_in_a_case_regardless_of_role = 0;
		SET @user_is_publicly_visible = 1;
		SET @user_can_see_publicly_visible = 1;

		SET @user_in_cc_for_cases = 0;

		# WARNING: The below permission makes the show/hide user functionality less efficient...
		# A user who can directly ask to approve will automatically see all the approvers for the flags...
		SET @can_ask_to_approve = 1;
		SET @can_approve = 1;
	
	# Permission to create or alter other users:
	# (This is done by granting the user permission to grant membership to other users to certain groups)

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

	SET @visibility_explanation_1 = 'Visible only to ';
	SET @visibility_explanation_2 = ' for this unit.';
	
########################################################################
#
#	ALL THE VARIABLES WE NEED HAVE BEEN DEFINED, WE CAN RUN THE SCRIPT #
#
########################################################################

# Info about this script
	SET @script = '2_Insert_new_unit_and_role_in_unee-t_bzfe_v2.13.sql';

# Timestamp	
	SET @timestamp = NOW();

# The global permission for the application
# This should not change, it was hard coded when we created Unee-T
	# See time tracking
		SET @can_see_time_tracking_group_id = 16;
	# Can create shared queries
		SET @can_create_shared_queries_group_id = 17;
	# Can tag comments
		SET @can_tag_comment_group_id = 18;	
	
# We populate the additional variables that we will need for this script to work

	# For the product
		SET @product_id = ((SELECT MAX(`id`) FROM `products`) + 1);
		SET @unit = CONCAT(@unit_name, '-', @product_id);
		SET @unit_for_query = REPLACE(@unit,' ','%');
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
		SET @unit_for_group = REPLACE(@unit_for_flag,'_','-');
		SET @default_milestone = '---';
		SET @timestamp = NOW();
	
	# For the user
		SET @role_user_g_description = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=@id_role_type);
		SET @user_pub_name = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id);
		SET @role_user_pub_info = CONCAT(@user_pub_name,' - ', @role_user_more);
		SET @user_role_desc = (CONCAT(@role_user_g_description, ' - ',@role_user_pub_info));

	# For the creator
		SET @creator_pub_name = (SELECT `realname` FROM `profiles` WHERE `userid` = @creator_bz_id);

		
/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

# The user

	# We record the information about the users that we have just created
	# If this is the first time we record something for this user for this unit, we create a new record.
	# If there is already a record for THAT USER for THIS, then we are updating the information
		
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
			, CONCAT('On '
					, NOW()
					, ': Created with the script - '
					, @script
					, '.\r\ '
					, `comment`)
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

# We now create the unit we need.
	INSERT INTO `products`
		(`id`
		,`name`
		,`classification_id`
		,`description`
		,`isactive`
		,`defaultmilestone`
		,`allows_unconfirmed`
		)
		VALUES
		(@product_id,@unit,@classification_id,@unit_description,1,@default_milestone,1);

	# Log the actions of the script.
		SET @script_log_message = CONCAT('A new unit #'
								, (SELECT IFNULL(@product_id, 'product_id is NULL'))
								, ' ('
								, (SELECT IFNULL(@unit, 'unit is NULL'))
								, ') '
								, ' has been created in the classification: '
								, (SELECT IFNULL(@classification_id, 'classification_id is NULL'))
								, '\r\The bz user #'
								, (SELECT IFNULL(@creator_bz_id, 'creator_bz_id is NULL'))
								, ' (real name: '
								, (SELECT IFNULL(@creator_pub_name, 'creator_pub_name is NULL'))
								, ') '
								, 'is the CREATOR of that unit.'
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

	INSERT INTO `milestones`
		(`id`
		,`product_id`
		,`value`
		,`sortkey`
		,`isactive`
		)
		VALUES
		(NULL,@product_id,@default_milestone,0,1);
	
	INSERT INTO `versions`
		(`id`
		,`value`
		,`product_id`
		,`isactive`
		)
		VALUES
		(NULL,@default_milestone,@product_id,1);		
			
# We create the goups we need
	
	# Groups common to all components/roles for this unit
		SET @create_case_group_id = ((SELECT MAX(`id`) FROM `groups`) + 1);
		SET @can_edit_case_group_id = (@create_case_group_id + 1);
		SET @can_edit_all_field_case_group_id = (@can_edit_case_group_id + 1);
		SET @can_edit_component_group_id = (@can_edit_all_field_case_group_id + 1);
		SET @can_see_cases_group_id = (@can_edit_component_group_id + 1);
		SET @all_g_flags_group_id = (@can_see_cases_group_id + 1);
		SET @all_r_flags_group_id = (@all_g_flags_group_id + 1);
		SET @list_visible_assignees_group_id = (@all_r_flags_group_id + 1);
		SET @see_visible_assignees_group_id = (@list_visible_assignees_group_id + 1);
		SET @active_stakeholder_group_id = (@see_visible_assignees_group_id + 1);
		SET @unit_creator_group_id = (@active_stakeholder_group_id + 1);

	# We now create the groups we will need now and in the future for this unit...
	# For simplicity reason, it is better to create ALL the groups we need for all the possible roles and permissions
	# This will avoid a scenario where we need to grant permission to see occupants for instances but the group for occupants does not exist yet...
	
	# Groups associated to the components/roles
		# For the tenant
			# Visibility group
			SET @group_id_show_to_tenant = (@unit_creator_group_id + 1);
			SET @group_name_show_to_tenant = (CONCAT(@unit_for_group,'-limit-to-Tenant'));
			SET @group_description_tenant = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 1),@visibility_explanation_2));
		
			# Is in tenant user Group
			SET @group_id_are_users_tenant = (@group_id_show_to_tenant + 1);
			SET @group_name_are_users_tenant = (CONCAT(@unit_for_group,'-List-Tenant'));
			SET @group_description_are_users_tenant = (CONCAT('list the tenant(s)', @unit));
			
			# Can See tenant user Group
			SET @group_id_see_users_tenant = (@group_id_are_users_tenant + 1);
			SET @group_name_see_users_tenant = (CONCAT(@unit_for_group,'-Can-see-Tenant'));
			SET @group_description_see_users_tenant = (CONCAT('See the list of tenant(s) for ', @unit));
	
		# For the Landlord
			# Visibility group 
			SET @group_id_show_to_landlord = (@group_id_see_users_tenant + 1);
			SET @group_name_show_to_landlord = (CONCAT(@unit_for_group,'-Limit-to-Landlord'));
			SET @group_description_show_to_landlord = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 2),@visibility_explanation_2));
			
			# Is in landlord user Group
			SET @group_id_are_users_landlord = (@group_id_show_to_landlord + 1);
			SET @group_name_are_users_landlord = (CONCAT(@unit_for_group,'-List-landlord'));
			SET @group_description_are_users_landlord = (CONCAT('list the landlord(s)', @unit));
			
			# Can See landlord user Group
			SET @group_id_see_users_landlord = (@group_id_are_users_landlord + 1);
			SET @group_name_see_users_landlord = (CONCAT(@unit_for_group,'-Can-see-lanldord'));
			SET @group_description_see_users_landlord = (CONCAT('See the list of lanldord(s) for ', @unit));
			
		# For the agent
			# Visibility group 
			SET @group_id_show_to_agent = (@group_id_see_users_landlord + 1);
			SET @group_name_show_to_agent = (CONCAT(@unit_for_group,'-limit-to-Agent'));
			SET @group_description_show_to_agent = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 5),@visibility_explanation_2));
			
			# Is in Agent user Group
			SET @group_id_are_users_agent = (@group_id_show_to_agent + 1);
			SET @group_name_are_users_agent = (CONCAT(@unit_for_group,'-List-agent'));
			SET @group_description_are_users_agent = (CONCAT('list the agent(s)', @unit));
			
			# Can See Agent user Group
			SET @group_id_see_users_agent = (@group_id_are_users_agent + 1);
			SET @group_name_see_users_agent = (CONCAT(@unit_for_group,'-Can-see-agent'));
			SET @group_description_see_users_agent = (CONCAT('See the list of agent(s) for ', @unit));
		
		# For the contractor
			# Visibility group 
			SET @group_id_show_to_contractor = (@group_id_see_users_agent + 1);
			SET @group_name_show_to_contractor = (CONCAT(@unit_for_group,'-limit-to-Contractor-Employee'));
			SET @group_description_show_to_contractor = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 3),@visibility_explanation_2));
			
			# Is in contractor user Group
			SET @group_id_are_users_contractor = (@group_id_show_to_contractor + 1);
			SET @group_name_are_users_contractor = (CONCAT(@unit_for_group,'-List-contractor-employee'));
			SET @group_description_are_users_contractor = (CONCAT('list the contractor employee(s)', @unit));
			
			# Can See contractor user Group
			SET @group_id_see_users_contractor = (@group_id_are_users_contractor + 1);
			SET @group_name_see_users_contractor = (CONCAT(@unit_for_group,'-Can-see-contractor-employee'));
			SET @group_description_see_users_contractor = (CONCAT('See the list of contractor employee(s) for ', @unit));
			
		# For the Mgt Cny
			# Visibility group
			SET @group_id_show_to_mgt_cny = (@group_id_see_users_contractor + 1);
			SET @group_name_show_to_mgt_cny = (CONCAT(@unit_for_group,'-limit-to-Mgt-Cny-Employee'));
			SET @group_description_show_to_mgt_cny = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 4),@visibility_explanation_2));
			
			# Is in mgt cny user Group
			SET @group_id_are_users_mgt_cny = (@group_id_show_to_mgt_cny + 1);
			SET @group_name_are_users_mgt_cny = (CONCAT(@unit_for_group,'-List-Mgt-Cny-Employee'));
			SET @group_description_are_users_mgt_cny = (CONCAT('list the Mgt Cny Employee(s)', @unit));
			
			# Can See mgt cny user Group
			SET @group_id_see_users_mgt_cny = (@group_id_are_users_mgt_cny + 1);
			SET @group_name_see_users_mgt_cny = (CONCAT(@unit_for_group,'-Can-see-Mgt-Cny-Employee'));
			SET @group_description_see_users_mgt_cny = (CONCAT('See the list of Mgt Cny Employee(s) for ', @unit));
		
		# For the occupant
			# Visibility group
			SET @group_id_show_to_occupant = (@group_id_see_users_mgt_cny + 1);
			SET @group_name_show_to_occupant = (CONCAT(@unit_for_group,'-limit-to-occupant'));
			SET @group_description_show_to_occupant = (CONCAT(@visibility_explanation_1,'Occupants'));
			
			# Is in occupant user Group
			SET @group_id_are_users_occupant = (@group_id_show_to_occupant + 1);
			SET @group_name_are_users_occupant = (CONCAT(@unit_for_group,'-List-occupant'));
			SET @group_description_are_users_occupant = (CONCAT('list-the-occupant(s)-', @unit));
			
			# Can See occupant user Group
			SET @group_id_see_users_occupant = (@group_id_are_users_occupant + 1);
			SET @group_name_see_users_occupant = (CONCAT(@unit_for_group,'-Can-see-occupant'));
			SET @group_description_see_users_occupant = (CONCAT('See the list of occupant(s) for ', @unit));
			
		# For the people invited by this user:
			# Is in invited_by user Group
			SET @group_id_are_users_invited_by = (@group_id_see_users_occupant + 1);
			SET @group_name_are_users_invited_by = (CONCAT(@unit_for_group,'-List-invited-by'));
			SET @group_description_are_users_invited_by = (CONCAT('list the invited_by(s)', @unit));
			
			# Can See users in invited_by user Group
			SET @group_id_see_users_invited_by = (@group_id_are_users_invited_by + 1);
			SET @group_name_see_users_invited_by = (CONCAT(@unit_for_group,'-Can-see-invited-by'));
			SET @group_description_see_users_invited_by = (CONCAT('See the list of invited_by(s) for ', @unit));

	# We can populate the 'groups' table now.
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
			(@create_case_group_id,CONCAT(@unit_for_group,'-Can Create Cases'),'User can create cases for this unit.',1,'',1,NULL)
			,(@can_edit_case_group_id,CONCAT(@unit_for_group,'-Can edit'),'user in this can edit a case they have access to',1,'',1,NULL)
			,(@can_edit_all_field_case_group_id,CONCAT(@unit_for_group,'-Can edit all fields'),'user in this can edit all fields in a case they have access to, regardless of its role',1,'',1,NULL)
			,(@can_edit_component_group_id,CONCAT(@unit_for_group,'-Can edit components'),'user in this can edit components/stakholders and permission for the unit',1,'',1,NULL)
			,(@can_see_cases_group_id,CONCAT(@unit_for_group,'-Visible to all'),'All users in this unit can see this case for the unit',1,'',1,NULL)
			,(@all_g_flags_group_id,CONCAT(@unit_for_group,'-Can approve all flags'),'user in this group are allowed to approve all flags',1,'',0,NULL)
			,(@all_r_flags_group_id,CONCAT(@unit_for_group,'-Can be asked to approve all flags'),'user in this group are visible in the list of flag approver',1,'',0,NULL)
			,(@list_visible_assignees_group_id,CONCAT(@unit_for_group,'-List stakeholder'),'List all the users which are visible assignee(s) for this unit',1,'',0,NULL)
			,(@see_visible_assignees_group_id,CONCAT(@unit_for_group,'-See stakeholder'),'Can see all the users which are stakeholders for this unit',1,'',0,NULL)
			,(@active_stakeholder_group_id,CONCAT(@unit_for_group,'-Active stakeholder'),'For users who have a role in this unit as of today',1,'',1,NULL)
			,(@unit_creator_group_id,CONCAT(@unit_for_group,'-Unit Creators'),'This is the group for the unit creator',1,'',0,NULL)
			,(@group_id_show_to_tenant,@group_name_show_to_tenant,@group_description_tenant,1,'',1,NULL)
			,(@group_id_are_users_tenant,@group_name_are_users_tenant,@group_description_are_users_tenant,1,'',0,NULL)
			,(@group_id_see_users_tenant,@group_name_see_users_tenant,@group_description_see_users_tenant,1,'',0,NULL)
			,(@group_id_show_to_landlord,@group_name_show_to_landlord,@group_description_show_to_landlord,1,'',1,NULL)
			,(@group_id_are_users_landlord,@group_name_are_users_landlord,@group_description_are_users_landlord,1,'',0,NULL)
			,(@group_id_see_users_landlord,@group_name_see_users_landlord,@group_description_see_users_landlord,1,'',0,NULL)
			,(@group_id_show_to_agent,@group_name_show_to_agent,@group_description_show_to_agent,1,'',1,NULL)
			,(@group_id_are_users_agent,@group_name_are_users_agent,@group_description_are_users_agent,1,'',0,NULL)
			,(@group_id_see_users_agent,@group_name_see_users_agent,@group_description_see_users_agent,1,'',0,NULL)
			,(@group_id_show_to_contractor,@group_name_show_to_contractor,@group_description_show_to_contractor,1,'',1,NULL)
			,(@group_id_are_users_contractor,@group_name_are_users_contractor,@group_description_are_users_contractor,1,'',0,NULL)
			,(@group_id_see_users_contractor,@group_name_see_users_contractor,@group_description_see_users_contractor,1,'',0,NULL)
			,(@group_id_show_to_mgt_cny,@group_name_show_to_mgt_cny,@group_description_show_to_mgt_cny,1,'',1,NULL)
			,(@group_id_are_users_mgt_cny,@group_name_are_users_mgt_cny,@group_description_are_users_mgt_cny,1,'',0,NULL)
			,(@group_id_see_users_mgt_cny,@group_name_see_users_mgt_cny,@group_description_see_users_mgt_cny,1,'',0,NULL)
			,(@group_id_show_to_occupant,@group_name_show_to_occupant,@group_description_show_to_occupant,1,'',1,NULL)
			,(@group_id_are_users_occupant,@group_name_are_users_occupant,@group_description_are_users_occupant,1,'',0,NULL)
			,(@group_id_see_users_occupant,@group_name_see_users_occupant,@group_description_see_users_occupant,1,'',0,NULL)
			,(@group_id_are_users_invited_by,@group_name_are_users_invited_by,@group_description_are_users_invited_by,1,'',0,NULL)
			,(@group_id_see_users_invited_by,@group_name_see_users_invited_by,@group_description_see_users_invited_by,1,'',0,NULL)
			;

	# Log the actions of the script.
		SET @script_log_message = CONCAT('We have created the groups that we will need for that unit #'
								, @product_id
								, '\r\ -  To grant '
								, 'case creation'
								, ' privileges. Group_id: '
								, (SELECT IFNULL(@create_case_group_id, 'create_case_group_id is NULL'))
								, '\r\ -  To grant '
								, 'Edit case'
								, ' privileges. Group_id: '
								, (SELECT IFNULL(@can_edit_case_group_id, 'can_edit_case_group_id is NULL'))
								, '\r\ -  To grant '
								, 'Edit all field regardless of role'
								, ' privileges. Group_id: '
								, (SELECT IFNULL(@can_edit_all_field_case_group_id, 'can_edit_all_field_case_group_id is NULL'))
								, '\r\ -  To grant '
								, 'Edit Component/roles'
								, ' privileges. Group_id: '
								, (SELECT IFNULL(@can_edit_component_group_id, 'can_edit_component_group_id is NULL'))
								, '\r\ -  To grant '
								, 'See cases'
								, ' privileges. Group_id: '
								, (SELECT IFNULL(@can_see_cases_group_id, 'can_see_cases_group_id is NULL'))
								, '\r\ -  To grant '
								, 'Request all flags'
								, ' privileges. Group_id: '
								, (SELECT IFNULL(@all_r_flags_group_id, 'all_r_flags_group_id is NULL'))
								, '\r\ -  To grant '
								, 'Approve all flags'
								, ' privileges. Group_id: '
								, (SELECT IFNULL(@all_g_flags_group_id, 'all_g_flags_group_id is NULL'))
								, '\r\ -  To grant '
								, 'User is publicly visible'
								, ' privileges. Group_id: '
								, (SELECT IFNULL(@list_visible_assignees_group_id, 'list_visible_assignees_group_id is NULL'))
								, '\r\ -  To grant '
								, 'User can see publicly visible'
								, ' privileges. Group_id: '
								, (SELECT IFNULL(@see_visible_assignees_group_id, 'see_visible_assignees_group_id is NULL'))
								, '\r\ -  To grant '
								, 'User is active Stakeholder'
								, ' privileges. Group_id: '
								, (SELECT IFNULL(@active_stakeholder_group_id, 'active_stakeholder_group_id is NULL'))
								, '\r\ -  To grant '
								, 'User is the unit creator'
								, ' privileges. Group_id: '
								, (SELECT IFNULL(@unit_creator_group_id, 'unit_creator_group_id is NULL'))
								, '\r\ - Restrict permission to '
								, 'tenant'
								, ' only. Group_id: '
								, (SELECT IFNULL(@group_id_show_to_tenant, 'group_id_show_to_tenant is NULL'))
								, '\r\ - Group for the '
								, 'tenant'
								, ' only. Group_id: '
								, (SELECT IFNULL(@group_id_are_users_tenant, 'group_id_are_users_tenant is NULL'))
								, '\r\ - Group to see the users '
								, 'tenant'
								, '. Group_id: '
								, (SELECT IFNULL(@group_id_see_users_tenant, 'group_id_see_users_tenant is NULL'))
								
								, '\r\ - Restrict permission to '
								, 'landlord'
								, ' only. Group_id: '
								, (SELECT IFNULL(@group_id_show_to_landlord, 'group_id_show_to_landlord is NULL'))
								, '\r\ - Group for the '
								, 'landlord'
								, ' only. Group_id: '
								, (SELECT IFNULL(@group_id_are_users_landlord, 'group_id_are_users_landlord is NULL'))
								, '\r\ - Group to see the users'
								, 'landlord'
								, '. Group_id: '
								, (SELECT IFNULL(@group_id_see_users_landlord, 'group_id_see_users_landlord is NULL'))
								
								, '\r\ - Restrict permission to '
								, 'agent'
								, ' only. Group_id: '
								, (SELECT IFNULL(@group_id_show_to_agent, 'group_id_show_to_agent is NULL'))
								, '\r\ - Group for the '
								, 'agent'
								, ' only. Group_id: '
								, (SELECT IFNULL(@group_id_are_users_agent, 'group_id_are_users_agent is NULL'))
								, '\r\ - Group to see the users'
								, 'agent'
								, '. Group_id: '
								, (SELECT IFNULL(@group_id_see_users_agent, 'group_id_see_users_agent is NULL'))
								
								, '\r\ - Restrict permission to '
								, 'Contractor'
								, ' only. Group_id: '
								, (SELECT IFNULL(@group_id_show_to_contractor, 'group_id_show_to_contractor is NULL'))
								, '\r\ - Group for the '
								, 'Contractor'
								, ' only. Group_id: '
								, (SELECT IFNULL(@group_id_are_users_contractor, 'group_id_are_users_contractor is NULL'))
								, '\r\ - Group to see the users'
								, 'Contractor'
								, '. Group_id: '
								, (SELECT IFNULL(@group_id_see_users_contractor, 'group_id_see_users_contractor is NULL'))
								
								, '\r\ - Restrict permission to '
								, 'Management Company'
								, ' only. Group_id: '
								, (SELECT IFNULL(@group_id_show_to_mgt_cny, 'group_id_show_to_mgt_cny is NULL'))
								, '\r\ - Group for the users in the '
								, 'Management Company'
								, ' only. Group_id: '
								, (SELECT IFNULL(@group_id_are_users_mgt_cny, 'group_id_are_users_mgt_cny is NULL'))
								, '\r\ - Group to see the users in the '
								, 'Management Company'
								, '. Group_id: '
								, (SELECT IFNULL(@group_id_see_users_mgt_cny, 'group_id_see_users_mgt_cny is NULL'))
								
								, '\r\ - Restrict permission to '
								, 'occupant'
								, ' only. Group_id: '
								, (SELECT IFNULL(@group_id_show_to_occupant, 'group_id_show_to_occupant is NULL'))
								, '\r\ - Group for the '
								, 'occupant'
								, ' only. Group_id: '
								, (SELECT IFNULL(@group_id_are_users_occupant, 'group_id_are_users_occupant is NULL'))
								, '\r\ - Group to see the users '
								, 'occupant'
								, '. Group_id: '
								, (SELECT IFNULL(@group_id_see_users_occupant, 'group_id_see_users_occupant is NULL'))
								);
		
		INSERT INTO `ut_script_log`
			(`datetime`
			, `script`
			, `log`
			)
			VALUES
			(NOW(), @script, @script_log_message)
			;
		
		SET @script_log_message = NULL;				
			
# We record the groups we have just created:

	INSERT INTO `ut_product_group`
		(
		product_id
		,component_id
		,group_id
		,group_type_id
		,role_type_id
		,created_by_id
		,created
		)
		VALUES
		(@product_id,NULL,@create_case_group_id,20,NULL,@creator_bz_id,@timestamp)
		,(@product_id,NULL,@can_edit_case_group_id,25,NULL,@creator_bz_id,@timestamp)
		,(@product_id,NULL,@can_edit_all_field_case_group_id,26,NULL,@creator_bz_id,@timestamp)
		,(@product_id,NULL,@can_edit_component_group_id,27,NULL,@creator_bz_id,@timestamp)
		,(@product_id,NULL,@can_see_cases_group_id,28,NULL,@creator_bz_id,@timestamp)
		,(@product_id,NULL,@all_r_flags_group_id,18,NULL,@creator_bz_id,@timestamp)
		,(@product_id,NULL,@all_g_flags_group_id,19,NULL,@creator_bz_id,@timestamp)
		,(@product_id,NULL,@list_visible_assignees_group_id,4,NULL,@creator_bz_id,@timestamp)
		,(@product_id,NULL,@see_visible_assignees_group_id,5,NULL,@creator_bz_id,@timestamp)
		,(@product_id,NULL,@active_stakeholder_group_id,29,NULL,@creator_bz_id,@timestamp)
		,(@product_id,NULL,@unit_creator_group_id,1,NULL,@creator_bz_id,@timestamp)
		, # Tenant (1)
		(@product_id,@component_id_tenant,@group_id_show_to_tenant,2,1,@creator_bz_id,@timestamp)
		,(@product_id,@component_id_tenant,@group_id_are_users_tenant,22,1,@creator_bz_id,@timestamp)
		,(@product_id,@component_id_tenant,@group_id_see_users_tenant,37,1,@creator_bz_id,@timestamp)
		# Landlord (2)
		,(@product_id,@component_id_landlord,@group_id_show_to_landlord,2,2,@creator_bz_id,@timestamp)
		,(@product_id,@component_id_landlord,@group_id_are_users_landlord,22,2,@creator_bz_id,@timestamp)
		,(@product_id,@component_id_landlord,@group_id_see_users_landlord,37,2,@creator_bz_id,@timestamp)
		# Agent (5)
		,(@product_id,@component_id_agent,@group_id_show_to_agent,2,5,@creator_bz_id,@timestamp)
		,(@product_id,@component_id_agent,@group_id_are_users_agent,22,5,@creator_bz_id,@timestamp)
		,(@product_id,@component_id_agent,@group_id_see_users_agent,37,5,@creator_bz_id,@timestamp)
		# contractor (3)
		,(@product_id,@component_id_contractor,@group_id_show_to_contractor,2,3,@creator_bz_id,@timestamp)
		,(@product_id,@component_id_contractor,@group_id_are_users_contractor,22,3,@creator_bz_id,@timestamp)
		,(@product_id,@component_id_contractor,@group_id_see_users_contractor,37,3,@creator_bz_id,@timestamp)
		# mgt_cny (4)
		,(@product_id,@component_id_mgt_cny,@group_id_show_to_mgt_cny,2,4,@creator_bz_id,@timestamp)
		,(@product_id,@component_id_mgt_cny,@group_id_are_users_mgt_cny,22,4,@creator_bz_id,@timestamp)
		,(@product_id,@component_id_mgt_cny,@group_id_see_users_mgt_cny,37,4,@creator_bz_id,@timestamp)
		# occupant (#)
		,(@product_id,NULL,@group_id_show_to_occupant,24,NULL,@creator_bz_id,@timestamp)
		,(@product_id,NULL,@group_id_are_users_occupant,3,NULL,@creator_bz_id,@timestamp)
		,(@product_id,NULL,@group_id_see_users_occupant,36,NULL,@creator_bz_id,@timestamp)
		# invited_by
		,(@product_id,NULL,@group_id_are_users_invited_by,31,NULL,@creator_bz_id,@timestamp)
		,(@product_id,NULL,@group_id_see_users_invited_by,32,NULL,@creator_bz_id,@timestamp)
		;

# We now Create the flagtypes and flags for this new unit (we NEEDED the group ids:
	SET @flag_next_step = ((SELECT MAX(`id`) FROM `flagtypes`) + 1);
	SET @flag_solution = (@flag_next_step + 1);
	SET @flag_budget = (@flag_solution + 1);
	SET @flag_attachment = (@flag_budget + 1);
	SET @flag_ok_to_pay = (@flag_attachment + 1);
	SET @flag_is_paid = (@flag_ok_to_pay + 1);

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
		(@flag_next_step,CONCAT('Next_Step_',@unit_for_flag),'Approval for the Next Step of the case.','','b',1,1,1,1,10,@all_g_flags_group_id,@all_r_flags_group_id)
		,(@flag_solution,CONCAT('Solution_',@unit_for_flag),'Approval for the Solution of this case.','','b',1,1,1,1,20,@all_g_flags_group_id,@all_r_flags_group_id)
		,(@flag_budget,CONCAT('Budget_',@unit_for_flag),'Approval for the Budget for this case.','','b',1,1,1,1,30,@all_g_flags_group_id,@all_r_flags_group_id)
		,(@flag_attachment,CONCAT('Attachment_',@unit_for_flag),'Approval for this Attachment.','','a',1,1,1,1,10,@all_g_flags_group_id,@all_r_flags_group_id)
		,(@flag_ok_to_pay,CONCAT('OK_to_pay_',@unit_for_flag),'Approval to pay this bill.','','a',1,1,1,1,20,@all_g_flags_group_id,@all_r_flags_group_id)
		,(@flag_is_paid,CONCAT('is_paid_',@unit_for_flag),'Confirm if this bill has been paid.','','a',1,1,1,1,30,@all_g_flags_group_id,@all_r_flags_group_id)
		;
	
	INSERT INTO `flaginclusions`
		(`type_id`
		,`product_id`
		,`component_id`
		) 
		VALUES
		(@flag_next_step,@product_id,NULL)
		,(@flag_solution,@product_id,NULL)
		,(@flag_budget,@product_id,NULL)
		,(@flag_attachment,@product_id,NULL)
		,(@flag_ok_to_pay,@product_id,NULL)
		,(@flag_is_paid,@product_id,NULL)
		;

	# Log the actions of the script.
		SET @script_log_message = CONCAT('We have created the following flags which are restricted to that unit: '
								, '\r\ - Next Step (#'
								, (SELECT IFNULL(@flag_next_step, 'flag_next_step is NULL'))
								, ').'
								, '\r\ - Solution (#'
								, (SELECT IFNULL(@flag_solution, 'flag_solution is NULL'))
								, ').'
								, '\r\ - Budget (#'
								, (SELECT IFNULL(@flag_budget, 'flag_budget is NULL'))
								, ').'
								, '\r\ - Attachment (#'
								, (SELECT IFNULL(@flag_attachment, 'flag_attachment is NULL'))
								, ').'
								, '\r\ - OK to pay (#'
								, (SELECT IFNULL(@flag_ok_to_pay, 'flag_ok_to_pay is NULL'))
								, ').'
								, '\r\ - Is paid (#'
								, (SELECT IFNULL(@flag_is_paid, 'flag_is_paid is NULL'))
								, ').'
								);
		
		INSERT INTO `ut_script_log`
			(`datetime`
			, `script`
			, `log`
			)
			VALUES
			(NOW(), @script, @script_log_message)
			;
		
		SET @script_log_message = NULL;	
		
# We configure the group permissions:
	# Data for the table `group_group_map`
	# We use a temporary table to do this, this is to avoid duplicate in the group_group_map table

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
	
	
	# Add the new records
	INSERT  INTO `ut_group_group_map_temp`
		(`member_id`
		,`grantor_id`
		,`grant_type`
		) 
	##########################################################
	# Logic:
	# If you are a member of group_id XXX (ex: 1 / Admin) 
	# then you have the following permissions:
	# 	- 0: You are automatically a member of group ZZZ
	#	- 1: You can grant access to group ZZZ
	#	- 2: You can see users in group ZZZ
	##########################################################
		VALUES 
		# Admin group can grant membership to all
		(1,@create_case_group_id,1)
		,(1,@can_edit_case_group_id,1)
		,(1,@can_edit_all_field_case_group_id,1)
		,(1,@can_edit_component_group_id,1)
		,(1,@can_see_cases_group_id,1)
		,(1,@all_g_flags_group_id,1)
		,(1,@all_r_flags_group_id,1)
		,(1,@list_visible_assignees_group_id,1)
		,(1,@see_visible_assignees_group_id,1)
		,(1,@active_stakeholder_group_id,1)
		,(1,@unit_creator_group_id,1)
		,(1,@group_id_show_to_tenant,1)
		,(1,@group_id_are_users_tenant,1)
		,(1,@group_id_see_users_tenant,1)
		,(1,@group_id_show_to_landlord,1)
		,(1,@group_id_are_users_landlord,1)
		,(1,@group_id_see_users_landlord,1)
		,(1,@group_id_show_to_agent,1)
		,(1,@group_id_are_users_agent,1)
		,(1,@group_id_see_users_agent,1)
		,(1,@group_id_show_to_contractor,1)
		,(1,@group_id_are_users_contractor,1)
		,(1,@group_id_see_users_contractor,1)
		,(1,@group_id_show_to_mgt_cny,1)
		,(1,@group_id_are_users_mgt_cny,1)
		,(1,@group_id_see_users_mgt_cny,1)
		,(1,@group_id_show_to_occupant,1)
		,(1,@group_id_are_users_occupant,1)
		,(1,@group_id_see_users_occupant,1)
		,(1,@group_id_are_users_invited_by,1)
		,(1,@group_id_see_users_invited_by,1)

		# Visibility groups:
		,(@all_r_flags_group_id,@all_g_flags_group_id,2)
		,(@see_visible_assignees_group_id,@list_visible_assignees_group_id,2)
		,(@unit_creator_group_id,@unit_creator_group_id,2)
		,(@group_id_see_users_tenant,@group_id_are_users_tenant,2)
		,(@group_id_see_users_landlord,@group_id_are_users_landlord,2)
		,(@group_id_see_users_agent,@group_id_are_users_contractor,2)
		,(@group_id_see_users_mgt_cny,@group_id_are_users_mgt_cny,2)
		,(@group_id_see_users_occupant,@group_id_are_users_occupant,2)
		,(@group_id_see_users_invited_by,@group_id_are_users_invited_by,2)
		;

# We make sure that only user in certain groups can create, edit or see cases.
	INSERT  INTO `group_control_map`
		(`group_id`
		,`product_id`
		,`entry`
		,`membercontrol`
		,`othercontrol`
		,`canedit`
		,`editcomponents`
		,`editbugs`
		,`canconfirm`
		) 
		VALUES 
		(@create_case_group_id,@product_id,1,0,0,0,0,0,0)
		,(@can_edit_case_group_id,@product_id,1,0,0,1,0,0,1)
		,(@can_edit_all_field_case_group_id,@product_id,1,0,0,1,0,1,1)
		,(@can_edit_component_group_id,@product_id,0,0,0,0,1,0,0)
		,(@can_see_cases_group_id,@product_id,0,2,0,0,0,0,0)
		,(@group_id_show_to_tenant,@product_id,0,2,0,0,0,0,0)
		,(@group_id_show_to_landlord,@product_id,0,2,0,0,0,0,0)
		,(@group_id_show_to_agent,@product_id,0,2,0,0,0,0,0)
		,(@group_id_show_to_contractor,@product_id,0,2,0,0,0,0,0)
		,(@group_id_show_to_mgt_cny,@product_id,0,2,0,0,0,0,0)
		,(@group_id_show_to_occupant,@product_id,0,2,0,0,0,0,0)
		;
		
# Now we insert the component/roles
	
	# We will create all component_id for all the components/roles we need
	# We need to know the next available Id for the component:
		SET @component_id_tenant = ((SELECT MAX(`id`) FROM `components`) + 1);
		SET @component_id_landlord = (@component_id_tenant + 1);
		SET @component_id_agent = (@component_id_landlord + 1);
		SET @component_id_contractor = (@component_id_agent + 1);
		SET @component_id_mgt_cny = (@component_id_contractor + 1);
	
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
	
	# We have everything, we can now create the first component/role for the unit.
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
	# Log the actions of the script.
		SET @script_log_message = CONCAT('The first role created for that unit was: '
								, (SELECT IFNULL(@role_user_g_description, 'role_user_g_description is NULL'))
								, ' (role_type_id #'
								, (SELECT IFNULL(@id_role_type, 'id_role_type is NULL'))
								, ') '
								, '\r\The user associated to this role was bz user #'
								, (SELECT IFNULL(@bz_user_id, 'bz_user_id is NULL'))
								, ' (real name: '
								, (SELECT IFNULL(@user_pub_name, 'user_pub_name is NULL'))
								, '. This user is the default assignee for this role for that unit.' 
								);
		
		INSERT INTO `ut_script_log`
			(`datetime`
			, `script`
			, `log`
			)
			VALUES
			(NOW(), @script, @script_log_message)
			;
		
		SET @script_log_message = NULL;	
			
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
		(@bz_user_id,'Bugzilla::Group',@create_case_group_id,'__create__',NULL,CONCAT(@unit_for_group,'-Can Create Cases'),@timestamp)
		,(@bz_user_id,'Bugzilla::Group',@can_edit_case_group_id,'__create__',NULL,CONCAT(@unit_for_group,'-Can edit'),@timestamp)
		,(@bz_user_id,'Bugzilla::Group',@can_edit_all_field_case_group_id,'__create__',NULL,CONCAT(@unit_for_group,'-Can edit all fields'),@timestamp)
		,(@bz_user_id,'Bugzilla::Group',@can_edit_component_group_id,'__create__',NULL,CONCAT(@unit_for_group,'-Can edit components'),@timestamp)
		,(@bz_user_id,'Bugzilla::Group',@can_see_cases_group_id,'__create__',NULL,CONCAT(@unit_for_group,'-Visible to all'),@timestamp)
		,(@bz_user_id,'Bugzilla::Group',@all_g_flags_group_id,'__create__',NULL,CONCAT(@unit_for_group,'-Can approve all flags'),@timestamp)
		,(@bz_user_id,'Bugzilla::Group',@all_r_flags_group_id,'__create__',NULL,CONCAT(@unit_for_group,'-Can be asked to approve'),@timestamp)
		,(@bz_user_id,'Bugzilla::Group',@list_visible_assignees_group_id,'__create__',NULL,CONCAT(@unit_for_group,'-list stakeholder(s)'),@timestamp)
		,(@bz_user_id,'Bugzilla::Group',@see_visible_assignees_group_id,'__create__',NULL,CONCAT(@unit_for_group,'-see stakeholder(s)'),@timestamp)
		,(@bz_user_id,'Bugzilla::Group',@active_stakeholder_group_id,'__create__',NULL,CONCAT(@unit_for_group,'-Active stakeholder'),@timestamp)
		,(@bz_user_id,'Bugzilla::Group',@unit_creator_group_id,'__create__',NULL,CONCAT(@unit_for_group,'-Unit Creators'),@timestamp)
		,(@bz_user_id,'Bugzilla::Group',@group_id_show_to_tenant,'__create__',NULL,CONCAT(@unit_for_group,'-show case to tenant'),@timestamp)
		,(@bz_user_id,'Bugzilla::Group',@group_id_are_users_tenant,'__create__',NULL,CONCAT(@unit_for_group,'-user is a tenant'),@timestamp)
		,(@bz_user_id,'Bugzilla::Group',@group_id_see_users_tenant,'__create__',NULL,CONCAT(@unit_for_group,'-user can see user who are tenant'),@timestamp)
		,(@bz_user_id,'Bugzilla::Group',@group_id_show_to_landlord,'__create__',NULL,CONCAT(@unit_for_group,'-show case to Landlord'),@timestamp)
		,(@bz_user_id,'Bugzilla::Group',@group_id_are_users_landlord,'__create__',NULL,CONCAT(@unit_for_group,'-user is a Landlord'),@timestamp)
		,(@bz_user_id,'Bugzilla::Group',@group_id_see_users_landlord,'__create__',NULL,CONCAT(@unit_for_group,'-user can see user who are Landlord'),@timestamp)
		,(@bz_user_id,'Bugzilla::Group',@group_id_show_to_agent,'__create__',NULL,CONCAT(@unit_for_group,'-show case to agent'),@timestamp)
		,(@bz_user_id,'Bugzilla::Group',@group_id_are_users_agent,'__create__',NULL,CONCAT(@unit_for_group,'-user is an agent'),@timestamp)
		,(@bz_user_id,'Bugzilla::Group',@group_id_see_users_agent,'__create__',NULL,CONCAT(@unit_for_group,'-user can see user who are agent'),@timestamp)
		,(@bz_user_id,'Bugzilla::Group',@group_id_show_to_contractor,'__create__',NULL,CONCAT(@unit_for_group,'-show case to Contractor employee'),@timestamp)
		,(@bz_user_id,'Bugzilla::Group',@group_id_are_users_contractor,'__create__',NULL,CONCAT(@unit_for_group,'-user is a Contractor employee'),@timestamp)
		,(@bz_user_id,'Bugzilla::Group',@group_id_see_users_contractor,'__create__',NULL,CONCAT(@unit_for_group,'-user can see user who are Contractor employee'),@timestamp)
		,(@bz_user_id,'Bugzilla::Group',@group_id_show_to_mgt_cny,'__create__',NULL,CONCAT(@unit_for_group,'-show case to Mgt Company employee'),@timestamp)
		,(@bz_user_id,'Bugzilla::Group',@group_id_are_users_mgt_cny,'__create__',NULL,CONCAT(@unit_for_group,'-user is a Mgt Company employee'),@timestamp)
		,(@bz_user_id,'Bugzilla::Group',@group_id_see_users_mgt_cny,'__create__',NULL,CONCAT(@unit_for_group,'-user can see user who are Mgt Company employee'),@timestamp)
		,(@bz_user_id,'Bugzilla::Group',@group_id_show_to_occupant,'__create__',NULL,CONCAT(@unit_for_group,'-show case to occupant'),@timestamp)
		,(@bz_user_id,'Bugzilla::Group',@group_id_are_users_occupant,'__create__',NULL,CONCAT(@unit_for_group,'-user is an occupant'),@timestamp)
		,(@bz_user_id,'Bugzilla::Group',@group_id_see_users_occupant,'__create__',NULL,CONCAT(@unit_for_group,'-user can see user who are occupant'),@timestamp)
		,(@bz_user_id,'Bugzilla::Group',@group_id_are_users_invited_by,'__create__',NULL,CONCAT(@unit_for_group,'- invited by ', @creator_bz_id, ' (', @creator_pub_name, ')'),@timestamp)
		,(@bz_user_id,'Bugzilla::Group',@group_id_see_users_invited_by,'__create__',NULL,CONCAT(@unit_for_group,'- see invited by ', @creator_bz_id, ' (', @creator_pub_name, ')'),@timestamp)
		,(@bz_user_id,'Bugzilla::Component',@component_id_this_role,'__create__',NULL,@role_user_g_description,@timestamp)
		;

#############
#
#	WIP - THIS NEED TO BE REVISITED
#
# We insert the series categories that BZ needs...
/*
	INSERT  INTO `series_categories`
		(`id`
		,`name`
		) 
		VALUES 
		(NULL,CONCAT(@role_user_g_description,'_#',@product_id)),
		(NULL,CONCAT(@unit_for_group,'_#',@product_id));

	SET @series_2 = (SELECT `id` FROM `series_categories` WHERE `name` = '-All-');
	SET @series_1 = (SELECT `id` FROM `series_categories` WHERE `name` = CONCAT(@role_user_g_description,'_#',@product_id));
	SET @series_3 = (SELECT `id` FROM `series_categories` WHERE `name` = CONCAT(@unit_for_group,'_#',@product_id));

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
		(NULL,@bz_user_id,@series_1,@series_2,'INVALID',1,CONCAT('resolution=INVALID&product=',@unit_for_query),1),
		(NULL,@bz_user_id,@series_1,@series_2,'WONTFIX',1,CONCAT('resolution=WONTFIX&product=',@unit_for_query),1),
		(NULL,@bz_user_id,@series_1,@series_2,'DUPLICATE',1,CONCAT('resolution=DUPLICATE&product=',@unit_for_query),1),
		(NULL,@bz_user_id,@series_1,@series_2,'WORKSFORME',1,CONCAT('resolution=WORKSFORME&product=',@unit_for_query),1),
		(NULL,@bz_user_id,@series_1,@series_2,'All Open',1,CONCAT('bug_status=UNCONFIRMED&bug_status=CONFIRMED&bug_status=IN_PROGRESS&bug_status=REOPENED&bug_status=STAND%20BY&product=',@unit_for_query),1),
		(NULL,@bz_user_id,@series_1,@series_3,'All Open',1,CONCAT('field0-0-0=resolution&type0-0-0=notregexp&value0-0-0=.&product=',@unit_for_query,'&component=',@role_user_g_description),1),
		(NULL,@bz_user_id,@series_1,@series_3,'All Closed',1,CONCAT('field0-0-0=resolution&type0-0-0=regexp&value0-0-0=.&product=',@unit_for_query,'&component=',@role_user_g_description),1);
*/
#
#
#############		
# We now assign the permissions to the user associated to this role:		
	
	# We use a temporary table to make sure we do not have duplicates.
		
		# DELETE the temp table if it exists
		DROP TABLE IF EXISTS `ut_user_group_map_temp`;
		
		# Re-create the temp table
		CREATE TABLE `ut_user_group_map_temp` (
		  `user_id` MEDIUMINT(9) NOT NULL,
		  `group_id` MEDIUMINT(9) NOT NULL,
		  `isbless` TINYINT(4) NOT NULL DEFAULT '0',
		  `grant_type` TINYINT(4) NOT NULL DEFAULT '0'
		) ENGINE=INNODB DEFAULT CHARSET=utf8;

		# Add the records that exist in the table user_group_map
		INSERT INTO `ut_user_group_map_temp`
			SELECT *
			FROM `user_group_map`;

	# We need to get the id of these groups from the 'ut_product_group' table_based on the product_id
		# For the user - based on the user role:
			# Visibility group
			SET @group_id_show_to_user_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = @id_role_type));
		
			# Is in user Group for the role we just created
			SET @group_id_are_users_same_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = @id_role_type));
			
			# Can See other users in the same Group
			SET @group_id_see_users_same_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = @id_role_type));

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
		
# We give the user the permission they need.
		
	# First the `group_group_map` table
	
		# We truncate the table first (to avoid duplicates)
		TRUNCATE TABLE `group_group_map`;
		
		# We insert the data we need
		# Grouping like this makes sure that we have no dupes!
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

		# We Delete the temp table as we do not need it anymore
		DROP TABLE IF EXISTS `ut_group_group_map_temp`;

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

