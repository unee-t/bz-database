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
# This script will create:
# 	- a new product/unit.
#	- All the flags associtated to this unit.
#	- all the component_id for all the roles we will need for that unit
#	- all the groups we need to grant the permissions we want for that unit
#	- The first role for this unit
#
# The user will be made a member of the groups that allows the following rights
#	- See all the time tracking information (group id 16)
#	- Create Shared queries (group id 17)
#	- tag comments (group id 18)
#
# For the unit he/she will be able to:
#	- Create a case for this product
#	- Can edit a case for this product
#	- Can edit ALL the fields in a case that he/she has access to, regardless of the role he/she has
#
######################
#	WARNING: The below permission is VERY powerful and the main reason why it is 
#	NOT a good idea to give users accesses to the BZFE as they could break a lot of things there...
######################
#	- Can create any new role and also edit the product/unit and all the roles/components in the product
#
#	- Can see the cases that are made visible to all users.
#	- Can see the cases that are limited to his/her role.
#
######################
#	WARNING: The below permission makes the show/hide user functionality less efficient...
######################
#	- Can request any flag
#
#	- Can approve any flag (and hence is visible by all the users that can request flags)
#	- Can see all the visible assignee
#	- Is one of the publicly visible assignee for this product/unit.
#
#
# Limits of this script:
#	- DO NOT USE if the unit already exists in the BZ database
#	  We will have a different script for that
#	- DO NOT USE if the user is also an occupant of the unit
#	  We will have a different script for that
#
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
	SET @unit_name = 'A Test Unit - SMBW 4';
	SET @unit_description = 'Description of the unit. lorem ipsum dolorem';

# The user associated to the unit.	

	# BZ user id of the user that is creating the unit (default is 1 - Administrator).
	# For LMB migration, we use 2 (support.nobody)
	SET @creator_bz_id = 2;

	# BZ user id of the user that you want to associate to the unit.
	SET @bz_user_id = 2;

	# Role of the user associated to this new unit:
	#	- Tenant 1
	# 	- Landlord 2
	#	- Agent 5
	#	- Contractor 3
	#	- Management company 4
	SET @id_role_type = 4;

	# More information about the user associated to the unit:
	SET @role_user_more = 'LMB as a management Company';

########################################################################
#
#	ALL THE VARIABLES WE NEED HAVE BEEN DEFINED, WE CAN RUN THE SCRIPT #
#
########################################################################

# Info about this script
	SET @script = 'Insert_new_unit_and_role_in_unee-t_bzfe_v2.13.sql';


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
		
	# We make sure that the additional users  can:
	#	- See all the time tracking information (group id 16)
	#	- Create Shared queries (group id 17)
	#	- tag comments (group id 18)
	
	# We use a temporary table to make sure we do not have duplicates.
		
		# DELETE the temp table if it exists
		DROP TABLE IF EXISTS `user_group_map_temp`;
		
		# Re-create the temp table
		CREATE TABLE `user_group_map_temp` (
		  `user_id` MEDIUMINT(9) NOT NULL,
		  `group_id` MEDIUMINT(9) NOT NULL,
		  `isbless` TINYINT(4) NOT NULL DEFAULT '0',
		  `grant_type` TINYINT(4) NOT NULL DEFAULT '0'
		) ENGINE=INNODB DEFAULT CHARSET=utf8;

		# Add the records that exist in the table user_group_map
		INSERT INTO `user_group_map_temp`
			SELECT *
			FROM `user_group_map`;

	# Add the new user rights for the product
	INSERT  INTO `user_group_map_temp`
		(`user_id`
		,`group_id`
		,`isbless`
		,`grant_type`
		) 
		VALUES 
		(@bz_user_id,16,0,0)
		,(@bz_user_id,17,0,0)
		,(@bz_user_id,18,0,0)
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
		;

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
		(@product_id,NULL,@create_case_group_id,20,NULL,@creator_bz_id,@timestamp),
		(@product_id,NULL,@can_edit_case_group_id,25,NULL,@creator_bz_id,@timestamp),
		(@product_id,NULL,@can_edit_all_field_case_group_id,26,NULL,@creator_bz_id,@timestamp),
		(@product_id,NULL,@can_edit_component_group_id,27,NULL,@creator_bz_id,@timestamp),
		(@product_id,NULL,@can_see_cases_group_id,28,NULL,@creator_bz_id,@timestamp),
		(@product_id,NULL,@all_r_flags_group_id,18,NULL,@creator_bz_id,@timestamp),
		(@product_id,NULL,@all_g_flags_group_id,19,NULL,@creator_bz_id,@timestamp),
		(@product_id,NULL,@list_visible_assignees_group_id,4,NULL,@creator_bz_id,@timestamp),
		(@product_id,NULL,@see_visible_assignees_group_id,5,NULL,@creator_bz_id,@timestamp),
		(@product_id,NULL,@active_stakeholder_group_id,29,NULL,@creator_bz_id,@timestamp),
		(@product_id,NULL,@unit_creator_group_id,1,NULL,@creator_bz_id,@timestamp)
		;

# We configure the group permissions:
	# Data for the table `group_group_map`
	# We use a temporary table to do this, this is to avoid duplicate in the group_group_map table

	# DELETE the temp table if it exists
	DROP TABLE IF EXISTS `group_group_map_temp`;
	
	# Re-create the temp table
	CREATE TABLE `group_group_map_temp` (
	  `member_id` MEDIUMINT(9) NOT NULL,
	  `grantor_id` MEDIUMINT(9) NOT NULL,
	  `grant_type` TINYINT(4) NOT NULL DEFAULT 0
	) ENGINE=INNODB DEFAULT CHARSET=utf8;

	# Add the records that exist in the table group_group_map
	INSERT INTO `group_group_map_temp`
		SELECT *
		FROM `group_group_map`;
	
	
	# Add the new records
	INSERT  INTO `group_group_map_temp`
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

		# Visibility groups:
		,(@all_r_flags_group_id,@all_g_flags_group_id,2)
		,(@see_visible_assignees_group_id,@list_visible_assignees_group_id,2)
		,(@unit_creator_group_id,@unit_creator_group_id,2)
		;
					
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
		;

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

		
# We prepare the permission for the user
		
	INSERT  INTO `user_group_map_temp`
		(`user_id`
		,`group_id`
		,`isbless`
		,`grant_type`
		) 
		VALUES 
		# The Creator can grant privileges to all the groups that we created
			(@creator_bz_id,@create_case_group_id,1,0)
			,(@creator_bz_id,@can_edit_case_group_id,1,0)
			,(@creator_bz_id,@can_edit_all_field_case_group_id,1,0)
			,(@creator_bz_id,@can_edit_component_group_id,1,0)
			,(@creator_bz_id,@can_see_cases_group_id,1,0)
			,(@creator_bz_id,@all_g_flags_group_id,1,0)
			,(@creator_bz_id,@all_r_flags_group_id,1,0)
			,(@creator_bz_id,@list_visible_assignees_group_id,1,0)
			,(@creator_bz_id,@see_visible_assignees_group_id,1,0)
			,(@creator_bz_id,@active_stakeholder_group_id,1,0)
			,(@creator_bz_id,@unit_creator_group_id,1,0)

		# The Creator is a member of the following groups:
			,(@creator_bz_id,@create_case_group_id,0,0)
			,(@creator_bz_id,@can_edit_case_group_id,0,0)
			,(@creator_bz_id,@can_edit_all_field_case_group_id,0,0)
			,(@creator_bz_id,@can_edit_component_group_id,0,0)
			,(@creator_bz_id,@can_see_cases_group_id,0,0)
			,(@creator_bz_id,@all_g_flags_group_id,0,0)
			,(@creator_bz_id,@all_r_flags_group_id,0,0)
			,(@creator_bz_id,@list_visible_assignees_group_id,0,0)
			,(@creator_bz_id,@see_visible_assignees_group_id,0,0)
			,(@creator_bz_id,@active_stakeholder_group_id,0,0)
			,(@creator_bz_id,@unit_creator_group_id,0,0)
			;

# We now Create the flagtypes and flags for this new unit:
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
		(@flag_next_step,CONCAT('Next_Step_',@unit_for_flag),'Approval for the Next Step of the case.','','b',1,1,1,1,10,@g_group_next_step,@r_group_next_step)
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
		;

######################
#
# Now we insert the component/roles
#
######################
	
	# We will create all component_id for all the components/roles we need
	# We need to know the next available Id for the component:
		SET @component_id_tenant = ((SELECT MAX(`id`) FROM `components`) + 1);
		SET @component_id_landlord = (@component_id_tenant + 1);
		SET @component_id_agent = (@component_id_landlord + 1);
		SET @component_id_contractor = (@component_id_agent + 1);
		SET @component_id_mgt_cny = (@component_id_contractor + 1);
	
	SET @visibility_explanation_1 = 'Visible only to ';
	SET @visibility_explanation_2 = ' for this unit.';

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

	# We now create the groups we will need now and in the future for this unit...
	# For simplicity reason, it is better to create ALL the groups we need for all the possible roles and permissions
	# This will avoid a scenario where we need to grant permission to see occupants for instances but the group for occupants does not exist yet...
		SET @visibility_explanation_1 = 'Visible only to ';
		SET @visibility_explanation_2 = ' for this unit.';
		
		# For the tenant
			# Visibility group
			SET @group_id_show_to_tenant = ((SELECT MAX(`id`) FROM `groups`) + 1);
			SET @group_name_show_to_tenant = (CONCAT(@unit,'-limit-to-Tenant'));
			SET @group_description_tenant = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 1),@visibility_explanation_2));
		
			# Is in tenant user Group
			SET @group_id_are_users_tenant = (@group_id_show_to_tenant + 1);
			SET @group_name_are_users_tenant = (CONCAT(@unit,'-List-Tenant'));
			SET @group_description_are_users_tenant = (CONCAT('list the tenant(s)', @unit));
			
			# Can See tenant user Group
			SET @group_id_see_users_tenant = (@group_id_are_users_tenant + 1);
			SET @group_name_see_users_tenant = (CONCAT(@unit,'-Can-see-Tenant'));
			SET @group_description_see_users_tenant = (CONCAT('See the list of tenant(s) for ', @unit));
	
		# For the Landlord
			# Visibility group 
			SET @group_id_show_to_landlord = (@group_id_see_users_tenant + 1);
			SET @group_name_show_to_landlord = (CONCAT(@unit,'-Limit-to-Landlord'));
			SET @group_description_show_to_landlord = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 2),@visibility_explanation_2));
			
			# Is in landlord user Group
			SET @group_id_are_users_landlord = (@group_id_show_to_landlord + 1);
			SET @group_name_are_users_landlord = (CONCAT(@unit,'-List-landlord'));
			SET @group_description_are_users_landlord = (CONCAT('list the landlord(s)', @unit));
			
			# Can See landlord user Group
			SET @group_id_see_users_landlord = (@group_id_are_users_landlord + 1);
			SET @group_name_see_users_landlord = (CONCAT(@unit,'-Can-see-lanldord'));
			SET @group_description_see_users_landlord = (CONCAT('See the list of lanldord(s) for ', @unit));
			
		# For the agent
			# Visibility group 
			SET @group_id_show_to_agent = (@group_id_see_users_landlord + 1);
			SET @group_name_show_to_agent = (CONCAT(@unit,'-limit-to-Agent'));
			SET @group_description_show_to_agent = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 5),@visibility_explanation_2));
			
			# Is in Agent user Group
			SET @group_id_are_users_agent = (@group_id_show_to_agent + 1);
			SET @group_name_are_users_agent = (CONCAT(@unit,'-List-agent'));
			SET @group_description_are_users_agent = (CONCAT('list the agent(s)', @unit));
			
			# Can See Agent user Group
			SET @group_id_see_users_agent = (@group_id_are_users_agent + 1);
			SET @group_name_see_users_agent = (CONCAT(@unit,'-Can-see-agent'));
			SET @group_description_see_users_agent = (CONCAT('See the list of agent(s) for ', @unit));
		
		# For the contractor
			# Visibility group 
			SET @group_id_show_to_contractor = (@group_id_see_users_agent + 1);
			SET @group_name_show_to_contractor = (CONCAT(@unit,'-limit-to-Contractor-Employee'));
			SET @group_description_show_to_contractor = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 3),@visibility_explanation_2));
			
			# Is in contractor user Group
			SET @group_id_are_users_contractor = (@group_id_show_to_contractor + 1);
			SET @group_name_are_users_contractor = (CONCAT(@unit,'-List-contractor-employee'));
			SET @group_description_are_users_contractor = (CONCAT('list the contractor employee(s)', @unit));
			
			# Can See contractor user Group
			SET @group_id_see_users_contractor = (@group_id_are_users_contractor + 1);
			SET @group_name_see_users_contractor = (CONCAT(@unit,'-Can-see-contractor-employee'));
			SET @group_description_see_users_contractor = (CONCAT('See the list of contractor employee(s) for ', @unit));
			
		# For the Mgt Cny
			# Visibility group
			SET @group_id_show_to_mgt_cny = (@group_id_see_users_contractor + 1);
			SET @group_name_show_to_mgt_cny = (CONCAT(@unit,'-limit-to-Mgt-Cny-Employee'));
			SET @group_description_show_to_mgt_cny = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 4),@visibility_explanation_2));
			
			# Is in mgt cny user Group
			SET @group_id_are_users_mgt_cny = (@group_id_show_to_mgt_cny + 1);
			SET @group_name_are_users_mgt_cny = (CONCAT(@unit,'-List-Mgt-Cny-Employee'));
			SET @group_description_are_users_mgt_cny = (CONCAT('list the Mgt Cny Employee(s)', @unit));
			
			# Can See mgt cny user Group
			SET @group_id_see_users_mgt_cny = (@group_id_are_users_mgt_cny + 1);
			SET @group_name_see_users_mgt_cny = (CONCAT(@unit,'-Can-see-Mgt-Cny-Employee'));
			SET @group_description_see_users_mgt_cny = (CONCAT('See the list of Mgt Cny Employee(s) for ', @unit));
		
		# For the occupant
			# Visibility group
			SET @group_id_show_to_occupant = (@group_id_see_users_mgt_cny + 1);
			SET @group_name_show_to_occupant = (CONCAT(@unit,'limit-to-occupant'));
			SET @group_description_show_to_occupant = (CONCAT(@visibility_explanation_1,'Occupants'));
			
			# Is in occupant user Group
			SET @group_id_are_users_occupant = (@group_id_show_to_occupant + 1);
			SET @group_name_are_users_occupant = (CONCAT(@unit,'-List-occupant'));
			SET @group_description_are_users_occupant = (CONCAT('list-the-occupant(s)-', @unit));
			
			# Can See occupant user Group
			SET @group_id_see_users_occupant = (@group_id_are_users_occupant + 1);
			SET @group_name_see_users_occupant = (CONCAT(@unit,'-Can-see-occupant'));
			SET @group_description_see_users_occupant = (CONCAT('See the list of occupant(s) for ', @unit));
			
		# For the people invited by this user:
			# Is in invited_by user Group
			SET @group_id_are_users_invited_by = (@group_id_see_users_occupant + 1);
			SET @group_name_are_users_invited_by = (CONCAT(@unit,'-List-invited-by'));
			SET @group_description_are_users_invited_by = (CONCAT('list the invited_by(s)', @unit));
			
			# Can See users in invited_by user Group
			SET @group_id_see_users_invited_by = (@group_id_are_users_invited_by + 1);
			SET @group_name_see_users_invited_by = (CONCAT(@unit,'-Can-see-invited-by'));
			SET @group_description_see_users_invited_by = (CONCAT('See the list of invited_by(s) for ', @unit));

	# We have everything: we can create the groups we need!
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
			(@group_id_show_to_tenant,@group_name_show_to_tenant,@group_description_tenant,1,'',1,NULL)
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

	# we capture the groups and products that we have created for future reference.
	
		SET @timestamp = NOW();
	
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
		# Tenant (1)
		(@product_id,@component_id_tenant,@group_id_show_to_tenant,2,1,@creator_bz_id,@timestamp)
		,(@product_id,@component_id_tenant,@group_id_are_users_tenant,22,1,@creator_bz_id,@timestamp)
		,(@product_id,@component_id_tenant,@group_id_see_users_tenant,5,1,@creator_bz_id,@timestamp)
		# Landlord (2)
		,(@product_id,@component_id_landlord,@group_id_show_to_landlord,2,2,@creator_bz_id,@timestamp)
		,(@product_id,@component_id_landlord,@group_id_are_users_landlord,22,2,@creator_bz_id,@timestamp)
		,(@product_id,@component_id_landlord,@group_id_see_users_landlord,5,2,@creator_bz_id,@timestamp)
		# Agent (5)
		,(@product_id,@component_id_agent,@group_id_show_to_agent,2,5,@creator_bz_id,@timestamp)
		,(@product_id,@component_id_agent,@group_id_are_users_agent,22,5,@creator_bz_id,@timestamp)
		,(@product_id,@component_id_agent,@group_id_see_users_agent,5,5,@creator_bz_id,@timestamp)
		# contractor (3)
		,(@product_id,@component_id_contractor,@group_id_show_to_contractor,2,3,@creator_bz_id,@timestamp)
		,(@product_id,@component_id_contractor,@group_id_are_users_contractor,22,3,@creator_bz_id,@timestamp)
		,(@product_id,@component_id_contractor,@group_id_see_users_contractor,5,3,@creator_bz_id,@timestamp)
		# mgt_cny (4)
		,(@product_id,@component_id_mgt_cny,@group_id_show_to_mgt_cny,2,4,@creator_bz_id,@timestamp)
		,(@product_id,@component_id_mgt_cny,@group_id_are_users_mgt_cny,22,4,@creator_bz_id,@timestamp)
		,(@product_id,@component_id_mgt_cny,@group_id_see_users_mgt_cny,5,4,@creator_bz_id,@timestamp)
		# occupant (#)
		,(@product_id,NULL,@group_id_show_to_occupant,2,NULL,@creator_bz_id,@timestamp)
		,(@product_id,NULL,@group_id_are_users_occupant,22,NULL,@creator_bz_id,@timestamp)
		,(@product_id,NULL,@group_id_see_users_occupant,3,NULL,@creator_bz_id,@timestamp)
		# invited_by
		,(@product_id,NULL,@group_id_are_users_invited_by,31,NULL,@creator_bz_id,@timestamp)
		,(@product_id,NULL,@group_id_see_users_invited_by,32,NULL,@creator_bz_id,@timestamp)
		;
	
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
		(SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 20));

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
		
	# Data for the table `group_group_map`
	# We use a temporary table to do this, this is to avoid duplicate in the group_group_map table
		INSERT  INTO `group_group_map_temp`
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
			# group to grant membership
			# Admin can grant membership to all.
			(1,@group_id_show_to_tenant,1)
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
			
			# Visibility groups
			,(@group_id_see_users_tenant,@group_id_are_users_tenant,2)
			,(@group_id_see_users_landlord,@group_id_are_users_landlord,2)
			,(@group_id_see_users_agent,@group_id_are_users_contractor,2)
			,(@group_id_see_users_mgt_cny,@group_id_are_users_mgt_cny,2)
			,(@group_id_see_users_occupant,@group_id_are_users_occupant,2)
			,(@group_id_see_users_invited_by,@group_id_are_users_invited_by,2)
			;

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
		(@group_id_show_to_tenant,@product_id,0,2,0,0,0,0,0)
		,(@group_id_show_to_landlord,@product_id,0,2,0,0,0,0,0)
		,(@group_id_show_to_agent,@product_id,0,2,0,0,0,0,0)
		,(@group_id_show_to_contractor,@product_id,0,2,0,0,0,0,0)
		,(@group_id_show_to_mgt_cny,@product_id,0,2,0,0,0,0,0)
		,(@group_id_show_to_occupant,@product_id,0,2,0,0,0,0,0)
		;
	
	# We now assign the user permission for all the users we have created.
	# We need to get the id of these groups from the ut_product_table_based on the product_id!
		# Groups created when we create the product
			SET @create_case_group_id =  (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 20));
			SET @can_edit_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 25));
			SET @can_edit_all_field_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 26));
			SET @can_edit_component_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 27));
			SET @can_see_cases_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 28));
			SET @all_r_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 18));
			SET @all_g_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 19));
			SET @list_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 4));
			SET @see_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 5 AND `role_type_id` IS NULL));
			SET @active_stakeholder_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 29));

		# For the user - based on the user role:
			# Visibility group
			SET @group_id_show_to_user_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = @id_role_type));
		
			# Is in user Group for the role we just created
			SET @group_id_are_users_same_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = @id_role_type));
			
			# Can See other users in the same Group
			SET @group_id_see_users_same_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 5 AND `role_type_id` = @id_role_type));
		
		# For the people invited by this user:
			# Is in invited_by user Group
			SET @group_id_are_users_invited_by = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 31 AND `role_type_id` = NULL));
			
			# Can See users in invited_by user Group
			SET @group_id_see_users_invited_by = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 32 AND `role_type_id` = NULL));
		
	INSERT  INTO `user_group_map_temp`
		(`user_id`
		,`group_id`
		,`isbless`
		,`grant_type`
		) 
		VALUES 
		# Methodology: we list all the possible groups and comment out the groups we do not need.
			
		# The Creator:
			# Can grant membership to:

				# Groups created when we create the product
				# This has been done, we we created the product, nothing to do here!
#				(@creator_bz_id, @create_case_group_id, 1, 0)
#				,(@creator_bz_id, @can_edit_case_group_id, 1, 0)
#				,(@creator_bz_id, @can_edit_all_field_case_group_id, 1, 0)
#				,(@creator_bz_id, @can_edit_component_group_id, 1, 0)
#				,(@creator_bz_id, @can_see_cases_group_id, 1, 0)
#				,(@creator_bz_id, @all_g_flags_group_id, 1, 0)
#				,(@creator_bz_id, @all_r_flags_group_id, 1, 0)
#				,(@creator_bz_id, @list_visible_assignees_group_id, 1, 0)
#				,(@creator_bz_id, @see_visible_assignees_group_id, 1, 0)
#				,(@creator_bz_id, @active_stakeholder_group_id, 1, 0)
#				,(@creator_bz_id, @unit_creator_group_id, 1, 0)

				
				# Groups created when we create the components
				# The creator can not grant any group membership just because he is the creator...

#				,(@creator_bz_id, @group_id_show_to_user_role, 1, 0)
#				,(@creator_bz_id, @group_id_are_users_same_role, 1, 0)
#				,(@creator_bz_id, @group_id_see_users_same_role, 1, 0)
				(@creator_bz_id, @group_id_are_users_invited_by, 1, 0)
				,(@creator_bz_id, @group_id_see_users_invited_by, 1, 0)
	
			# Is a member of:
				# Groups created when we create the product
				# This has been done, we we created the product, nothing to do here!
#				,(@creator_bz_id, @create_case_group_id, 0, 0)
#				,(@creator_bz_id, @can_edit_case_group_id, 0, 0)
#				,(@creator_bz_id, @can_edit_all_field_case_group_id, 0, 0)
#				,(@creator_bz_id, @can_edit_component_group_id, 0, 0)
#				,(@creator_bz_id, @can_see_cases_group_id, 0, 0)
#				,(@creator_bz_id, @all_g_flags_group_id, 0, 0)
#				,(@creator_bz_id, @all_r_flags_group_id, 0, 0)
#				,(@creator_bz_id, @list_visible_assignees_group_id, 0, 0)
#				,(@creator_bz_id, @see_visible_assignees_group_id, 0, 0)
#				,(@creator_bz_id, @active_stakeholder_group_id, 0, 0)
#				,(@creator_bz_id, @unit_creator_group_id, 0, 0)
			
				# Groups created when we create the components
				# Nothing to do here.
#				,(@creator_bz_id, @group_id_show_to_user_role, 0, 0)
#				,(@creator_bz_id, @group_id_are_users_same_role, 0, 0)
#				,(@creator_bz_id, @group_id_see_users_same_role, 0, 0)
#				,(@creator_bz_id, @group_id_are_users_invited_by, 0, 0)
				,(@creator_bz_id, @group_id_see_users_invited_by, 0, 0)
		
		# The User we have just created
			# Can grant membership to 
			# this is so that this user can invite other stakeholder with the same role:
				# Groups created when we create the product
				,(@bz_user_id, @create_case_group_id, 1, 0)
				,(@bz_user_id, @can_edit_case_group_id, 1, 0)
				,(@bz_user_id, @can_edit_all_field_case_group_id, 1, 0)
				,(@bz_user_id, @can_edit_component_group_id, 1, 0)
				,(@bz_user_id, @can_see_cases_group_id, 1, 0)
				,(@bz_user_id, @all_g_flags_group_id, 1, 0)
				,(@bz_user_id, @all_r_flags_group_id, 1, 0)
				,(@bz_user_id, @list_visible_assignees_group_id, 1, 0)
				,(@bz_user_id, @see_visible_assignees_group_id, 1, 0)
				,(@bz_user_id, @active_stakeholder_group_id, 1, 0)
#				,(@bz_user_id, @unit_creator_group_id, 1, 0)
			
				# Groups created when we create the components
				,(@bz_user_id, @group_id_show_to_user_role, 1, 0)
				,(@bz_user_id, @group_id_are_users_same_role, 1, 0)
				,(@bz_user_id, @group_id_see_users_same_role, 1, 0)
#				,(@bz_user_id, @group_id_are_users_invited_by, 1, 0)
#				,(@bz_user_id, @group_id_see_users_invited_by, 1, 0)
	
			# Is a member of:
				# Groups created when we create the product
				,(@bz_user_id, @create_case_group_id, 0, 0)
				,(@bz_user_id, @can_edit_case_group_id, 0, 0)
#				,(@bz_user_id, @can_edit_all_field_case_group_id, 0, 0)
#				,(@bz_user_id, @can_edit_component_group_id, 0, 0)
				,(@bz_user_id, @can_see_cases_group_id, 0, 0)
				,(@bz_user_id, @all_g_flags_group_id, 0, 0)
				,(@bz_user_id, @all_r_flags_group_id, 0, 0)
				,(@bz_user_id, @list_visible_assignees_group_id, 0, 0)
				,(@bz_user_id, @see_visible_assignees_group_id, 0, 0)
				,(@bz_user_id, @active_stakeholder_group_id, 0, 0)
#				,(@bz_user_id, @unit_creator_group_id, 0, 0)
			
				# Groups created when we create the components
				,(@bz_user_id, @group_id_show_to_user_role, 0, 0)
				,(@bz_user_id, @group_id_are_users_same_role, 0, 0)
				,(@bz_user_id, @group_id_see_users_same_role, 0, 0)
				,(@bz_user_id, @group_id_are_users_invited_by, 0, 0)
#				,(@bz_user_id, @group_id_see_users_invited_by, 0, 0)
				;




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

# We give the user the permission they need.
# We need to do that via an intermediaary table to make sure that we dedup the permissions
	
	# First the `group_group_map` table
	
		# We truncate the table first (to avoid duplicates)
		TRUNCATE TABLE `group_group_map`;
		
		# We insert the data we need
		INSERT INTO `group_group_map`
		SELECT `member_id`
			, `grantor_id`
			, `grant_type`
		FROM
			`group_group_map_temp`
		GROUP BY `member_id`
			, `grantor_id`
			, `grant_type`
		;

		# We Delete the temp table as we do not need it anymore
		DROP TABLE IF EXISTS `group_group_map_temp`;
	
	# Then the `user_group_map` table
	
		# We truncate the table first (to avoid duplicates)
		TRUNCATE TABLE `user_group_map`;
		
		# We insert the data we need
		INSERT INTO `user_group_map`
		SELECT `user_id`
			, `group_id`
			, `isbless`
			, `grant_type`
		FROM
			`user_group_map_temp`
		GROUP BY `user_id`
			, `group_id`
			, `isbless`
			, `grant_type`
		;

		# We Delete the temp table as we do not need it anymore
		DROP TABLE IF EXISTS `user_group_map_temp`;
		
	# Log the actions of the script.
		SET @script_log_message = CONCAT('A new unit #'
								, (SELECT IFNULL(@product_id, 'product_id is NULL'))
								, ' ('
								, (SELECT IFNULL(@unit, 'unit is NULL'))
								, ') '
								, ' has been created in the classification: '
								, (SELECT IFNULL(@classification_id, 'classification_id is NULL'))
								, '\r\r\We have created the following flags which are restricted to that unit: '
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
								
								, '\r\r\We have attributed the component_id for that unit:'
								, '\r\ - Tenant'
								, ' role: component #'
								, (SELECT IFNULL(@component_id_tenant, 'component_id_tenant is NULL'))
								, '\r\ - Landlord'
								, ' role: component #'
								, (SELECT IFNULL(@component_id_landlord, 'component_id_landlord is NULL'))
								, '\r\ - Agent'
								, ' role: component #'
								, (SELECT IFNULL(@component_id_agent, 'component_id_agent is NULL'))
								, '\r\ - Contractor'
								, ' role: component #'
								, (SELECT IFNULL(@component_id_contractor, 'component_id_contractor is NULL'))
								, '\r\ - Management Company'
								, ' role: component #'
								, (SELECT IFNULL(@component_id_mgt_cny, 'component_id_mgt_cny is NULL'))
								
								, '\r\r\We have also created the groups that we will need for that unit:'
								
								
								
								, '\r\ - Restrict permission to '
								, 'tenant'
								, 'only. Group_id: '
								, (SELECT IFNULL(@group_id_show_to_tenant, 'group_id_show_to_tenant is NULL'))
								, '\r\ - Group for the '
								, 'tenant'
								, 'only. Group_id: '
								, (SELECT IFNULL(@group_id_are_users_tenant, 'group_id_are_users_tenant is NULL'))
								, '\r\ - Group to see the users'
								, 'tenant'
								, '. Group_id: '
								, (SELECT IFNULL(@group_id_see_users_tenant, 'group_id_see_users_tenant is NULL'))
								
								, '\r\ - Restrict permission to '
								, 'landlord'
								, 'only. Group_id: '
								, (SELECT IFNULL(@group_id_show_to_landlord, 'group_id_show_to_landlord is NULL'))
								, '\r\ - Group for the '
								, 'landlord'
								, 'only. Group_id: '
								, (SELECT IFNULL(@group_id_are_users_landlord, 'group_id_are_users_landlord is NULL'))
								, '\r\ - Group to see the users'
								, 'landlord'
								, '. Group_id: '
								, (SELECT IFNULL(@group_id_see_users_landlord, 'group_id_see_users_landlord is NULL'))
								
								, '\r\ - Restrict permission to '
								, 'agent'
								, 'only. Group_id: '
								, (SELECT IFNULL(@group_id_show_to_agent, 'group_id_show_to_agent is NULL'))
								, '\r\ - Group for the '
								, 'agent'
								, 'only. Group_id: '
								, (SELECT IFNULL(@group_id_are_users_agent, 'group_id_are_users_agent is NULL'))
								, '\r\ - Group to see the users'
								, 'agent'
								, '. Group_id: '
								, (SELECT IFNULL(@group_id_see_users_agent, 'group_id_see_users_agent is NULL'))
								
								, '\r\ - Restrict permission to '
								, 'Contractor'
								, 'only. Group_id: '
								, (SELECT IFNULL(@group_id_show_to_contractor, 'group_id_show_to_contractor is NULL'))
								, '\r\ - Group for the '
								, 'Contractor'
								, 'only. Group_id: '
								, (SELECT IFNULL(@group_id_are_users_contractor, 'group_id_are_users_contractor is NULL'))
								, '\r\ - Group to see the users'
								, 'Contractor'
								, '. Group_id: '
								, (SELECT IFNULL(@group_id_see_users_contractor, 'group_id_see_users_contractor is NULL'))
								
								, '\r\ - Restrict permission to '
								, 'Management Company'
								, 'only. Group_id: '
								, (SELECT IFNULL(@group_id_show_to_mgt_cny, 'group_id_show_to_mgt_cny is NULL'))
								, '\r\ - Group for the '
								, 'Management Company'
								, 'only. Group_id: '
								, (SELECT IFNULL(@group_id_are_users_mgt_cny, 'group_id_are_users_mgt_cny is NULL'))
								, '\r\ - Group to see the users'
								, 'Management Company'
								, '. Group_id: '
								, (SELECT IFNULL(@group_id_see_users_mgt_cny, 'group_id_see_users_mgt_cny is NULL'))
								
								, '\r\ - Restrict permission to '
								, 'occupant'
								, 'only. Group_id: '
								, (SELECT IFNULL(@group_id_show_to_occupant, 'group_id_show_to_occupant is NULL'))
								, '\r\ - Group for the '
								, 'occupant'
								, 'only. Group_id: '
								, (SELECT IFNULL(@group_id_are_users_occupant, 'group_id_are_users_occupant is NULL'))
								, '\r\ - Group to see the users'
								, 'occupant'
								, '. Group_id: '
								, (SELECT IFNULL(@group_id_see_users_occupant, 'group_id_see_users_occupant is NULL'))
								
								
								, '\r\r\The bz user #'
								, (SELECT IFNULL(@creator_bz_id, 'creator_bz_id is NULL'))
								, ' (real name: '
								, (SELECT IFNULL(@creator_pub_name, 'creator_pub_name is NULL'))
								, ') '
								, 'is the CREATOR of that unit.'
								
								, '\r\r\The first role created for that unit was: '
								, (SELECT IFNULL(@role_user_g_description, 'role_user_g_description is NULL'))
								, ' (role_type_id #'
								, (SELECT IFNULL(@id_role_type, 'id_role_type is NULL'))
								, ') '
								, '\r\The user associated to this role was bz user #'
								, (SELECT IFNULL(@bz_user_id, 'bz_user_id is NULL'))
								, ' (real name: '
								, (SELECT IFNULL(@user_pub_name, 'user_pub_name is NULL'))
								, '. This user is the default assignee for this role for that unit.' 
								, '\r\r\The permission granted to the CREATOR were: '
								, '\r\ - Permissions to invite other users:'
								, '\r\   - CAN grant privileges to create new cases for the unit. Group id #'
								, (SELECT IFNULL(@create_case_group_id, 'create_case_group_id is NULL'))
								, '\r\   - CAN grant privileges to edit existing cases for the unit. Group id #'
								, (SELECT IFNULL(@can_edit_case_group_id, 'can_edit_case_group_id is NULL'))
								, '\r\   - CAN grant privileges to edit all the fields in a case (regardless of the user role) for the unit. Group id #'
								, (SELECT IFNULL(@can_edit_all_field_case_group_id, 'can_edit_all_field_case_group_id is NULL'))
								, '\r\   - CAN grant privileges to edit and create any roles for the unit. Group id #'
								, (SELECT IFNULL(@can_edit_component_group_id, 'can_edit_component_group_id is NULL'))
								, '\r\   - CAN grant privileges to see the public cases for the unit. Group id #'
								, (SELECT IFNULL(@can_see_cases_group_id, 'can_see_cases_group_id is NULL'))
								, '\r\   - CAN grant privileges to grant approval for any flag for the unit. Group id #'
								, (SELECT IFNULL(@all_g_flags_group_id, 'all_g_flags_group_id is NULL'))
								, '\r\   - CAN grant privileges to ask for approval for any flag for the unit. Group id #'
								, (SELECT IFNULL(@all_r_flags_group_id, 'all_r_flags_group_id is NULL'))
								, '\r\   - CAN grant privileges to add a user to the list of user who are visible assignees for the unit. Group id #'
								, (SELECT IFNULL(@list_visible_assignees_group_id, 'list_visible_assignees_group_id is NULL'))
								, '\r\   - CAN grant privileges to add user to the list of visible assignee for the unit. Group id #'
								, (SELECT IFNULL(@see_visible_assignees_group_id, 'see_visible_assignees_group_id is NULL'))
								, '\r\   - CAN grant privileges to be a member of the stakeholders for the unit. Group id #'
								, (SELECT IFNULL(@active_stakeholder_group_id, 'active_stakeholder_group_id is NULL'))
								, '\r\   - Can grant privileges to be a member of the group for the unit creators for the unit. Group id #'
								, (SELECT IFNULL(@unit_creator_group_id, 'unit_creator_group_id is NULL'))
								, '\r\   - Can grant privileges to be a member of group for users who have been invited by the creator (him/herself). Group id #'
								, (SELECT IFNULL(@group_id_are_users_invited_by, 'group_id_are_users_invited_by is NULL'))
								, '\r\   - Can grant privileges to see the users who have been invited by the creator (him/herself). Group id #'
								, (SELECT IFNULL(@group_id_are_users_invited_by, 'group_id_are_users_invited_by is NULL'))

								
								, '\r\ - Permissions on units and cases for the CREATOR:'
								, '\r\   - CAN create new cases for the unit. Group id #'
								, (SELECT IFNULL(@create_case_group_id, 'create_case_group_id is NULL'))
								, '\r\   - CAN edit existing cases for the unit. Group id #'
								, (SELECT IFNULL(@can_edit_case_group_id, 'can_edit_case_group_id is NULL'))
								, '\r\   - CAN edit all the fields in a case (regardless of the user role) for the unit. Group id #'
								, (SELECT IFNULL(@can_edit_all_field_case_group_id, 'can_edit_all_field_case_group_id is NULL'))
								, '\r\   - CAN edit and create any roles for the unit. Group id #'
								, (SELECT IFNULL(@can_edit_component_group_id, 'can_edit_component_group_id is NULL'))
								, '\r\   - CAN see the public cases for the unit. Group id #'
								, (SELECT IFNULL(@can_see_cases_group_id, 'can_see_cases_group_id is NULL'))
								, '\r\   - CAN grant approval for any flag for the unit. Group id #'
								, (SELECT IFNULL(@all_g_flags_group_id, 'all_g_flags_group_id is NULL'))
								, '\r\   - CAN ask for approval for any flag for the unit. Group id #'
								, (SELECT IFNULL(@all_r_flags_group_id, 'all_r_flags_group_id is NULL'))
								, '\r\   - Is in the list of user who are visible assignees for the unit. Group id #'
								, (SELECT IFNULL(@list_visible_assignees_group_id, 'list_visible_assignees_group_id is NULL'))
								, '\r\   - CAN see th users in the list of visible assignee for the unit. Group id #'
								, (SELECT IFNULL(@see_visible_assignees_group_id, 'see_visible_assignees_group_id is NULL'))
								, '\r\   - Is a member of the stakeholders for the unit. Group id #'
								, (SELECT IFNULL(@active_stakeholder_group_id, 'active_stakeholder_group_id is NULL'))
								, '\r\   - Is a member of the group for the unit creators for the unit. Group id #'
								, (SELECT IFNULL(@unit_creator_group_id, 'unit_creator_group_id is NULL'))
								, '\r\   - Can see the users who have been invited by the creator (him/herself). Group id #'
								, (SELECT IFNULL(@group_id_are_users_invited_by, 'group_id_are_users_invited_by is NULL'))
								
								
								, '\r\r\We also created the following permissions for the INVITED user:'
								, '\r\ - Permissions to invite other users:'
								, '\r\   - CAN grant privileges to create new cases for the unit. Group id #'
								, (SELECT IFNULL(@create_case_group_id, 'create_case_group_id is NULL'))
								, '\r\   - CAN grant privileges to edit existing cases for the unit. Group id #'
								, (SELECT IFNULL(@can_edit_case_group_id, 'can_edit_case_group_id is NULL'))
								, '\r\   - CAN grant privileges to edit all the fields in a case (regardless of the user role) for the unit. Group id #'
								, (SELECT IFNULL(@can_edit_all_field_case_group_id, 'can_edit_all_field_case_group_id is NULL'))
								, '\r\   - CAN grant privileges to edit and create any roles for the unit. Group id #'
								, (SELECT IFNULL(@can_edit_component_group_id, 'can_edit_component_group_id is NULL'))
								, '\r\   - CAN grant privileges to see the public cases for the unit. Group id #'
								, (SELECT IFNULL(@can_see_cases_group_id, 'can_see_cases_group_id is NULL'))
								, '\r\   - CAN grant privileges to grant approval for any flag for the unit. Group id #'
								, (SELECT IFNULL(@all_g_flags_group_id, 'all_g_flags_group_id is NULL'))
								, '\r\   - CAN grant privileges to ask for approval for any flag for the unit. Group id #'
								, (SELECT IFNULL(@all_r_flags_group_id, 'all_r_flags_group_id is NULL'))
								, '\r\   - CAN grant privileges to add a user to the list of user who are visible assignees for the unit. Group id #'
								, (SELECT IFNULL(@list_visible_assignees_group_id, 'list_visible_assignees_group_id is NULL'))
								, '\r\   - CAN grant privileges to add user to the list of visible assignee for the unit. Group id #'
								, (SELECT IFNULL(@see_visible_assignees_group_id, 'see_visible_assignees_group_id is NULL'))
								, '\r\   - CAN grant privileges to be a member of the stakeholders for the unit. Group id #'
								, (SELECT IFNULL(@active_stakeholder_group_id, 'active_stakeholder_group_id is NULL'))
								, '\r\   - CAN NOT grant privileges to be a member of the group for the unit creators for the unit. Group id #'
								, (SELECT IFNULL(@unit_creator_group_id, 'unit_creator_group_id is NULL'))
								, '\r\   - CAN grant privileges to a see cases restricted to the role type: '
								, (SELECT IFNULL(@role_user_g_description, 'role_user_g_description is NULL'))
								, ' for this unit. This allow the invited user to invite other user to see the cases that are restricted to this group. Group id #'
								, (SELECT IFNULL(@group_id_show_to_user_role, 'group_id_show_to_user_role is NULL'))
								, '\r\   - CAN grant privileges to be a member of the group of the visible users in the role type: '
								, (SELECT IFNULL(@role_user_g_description, 'role_user_g_description is NULL'))
								, ' for this unit. Group id #'
								, (SELECT IFNULL(@group_id_are_users_same_role, 'group_id_are_users_same_role is NULL'))
								, '\r\   - CAN grant privileges to see the users that are member of the group of the visible users in the role type: '
								, (SELECT IFNULL(@role_user_g_description, 'role_user_g_description is NULL'))
								, ' for this unit. Group id #'
								, (SELECT IFNULL(@group_id_see_users_same_role, 'group_id_see_users_same_role is NULL'))


								, '\r\ - Permissions on units and cases for the INVITED user:'
								, '\r\   - CAN create new cases for the unit. Group id #'
								, (SELECT IFNULL(@create_case_group_id, 'create_case_group_id is NULL'))
								, '\r\   - CAN edit existing cases for the unit. Group id #'
								, (SELECT IFNULL(@can_edit_case_group_id, 'can_edit_case_group_id is NULL'))
								, '\r\   - can NOT edit all the fields in a case (regardless of the user role) for the unit. Group id #'
								, (SELECT IFNULL(@can_edit_all_field_case_group_id, 'can_edit_all_field_case_group_id is NULL'))
								, '\r\   - can NOT edit and create any roles for the unit (he can only invite to this role for that unit). Group id #'
								, (SELECT IFNULL(@can_edit_component_group_id, 'can_edit_component_group_id is NULL'))
								, '\r\   - CAN see the public cases for the unit. Group id #'
								, (SELECT IFNULL(@can_see_cases_group_id, 'can_see_cases_group_id is NULL'))
								, '\r\   - CAN grant approval for any flag for the unit. Group id #'
								, (SELECT IFNULL(@all_g_flags_group_id, 'all_g_flags_group_id is NULL'))
								, '\r\   - CAN ask for approval for any flag for the unit. Group id #'
								, (SELECT IFNULL(@all_r_flags_group_id, 'all_r_flags_group_id is NULL'))
								, '\r\   - Is in the list of user who are visible assignees for the unit. Group id #'
								, (SELECT IFNULL(@list_visible_assignees_group_id, 'list_visible_assignees_group_id is NULL'))
								, '\r\   - CAN see the users in the list of visible assignee for the unit. Group id #'
								, (SELECT IFNULL(@see_visible_assignees_group_id, 'see_visible_assignees_group_id is NULL'))
								, '\r\   - Is a member of the stakeholders for the unit. Group id #'
								, (SELECT IFNULL(@active_stakeholder_group_id, 'active_stakeholder_group_id is NULL'))
								, '\r\   - is NOT a member of the group for the unit creators for the unit. Group id #'
								, (SELECT IFNULL(@unit_creator_group_id, 'unit_creator_group_id is NULL'))
								, '\r\   - CAN see cases restricted to the role type: '
								, (SELECT IFNULL(@role_user_g_description, 'role_user_g_description is NULL'))
								, ' for this unit. Group id #'
								, (SELECT IFNULL(@group_id_show_to_user_role, 'group_id_show_to_user_role is NULL'))
								, '\r\   - Is a member of the group of the visible users in the role type: '
								, (SELECT IFNULL(@role_user_g_description, 'role_user_g_description is NULL'))
								, ' for this unit. Group id #'
								, (SELECT IFNULL(@group_id_are_users_same_role, 'group_id_are_users_same_role is NULL'))
								, '\r\   - CAN see the users that are member of the group of the visible users in the role type: '
								, (SELECT IFNULL(@role_user_g_description, 'role_user_g_description is NULL'))
								, ' for this unit. Group id #'
								, (SELECT IFNULL(@group_id_see_users_same_role, 'group_id_see_users_same_role is NULL'))
								, '\r\r\We also have recorded that the user #'
								, (SELECT IFNULL(@bz_user_id, 'bz_user_id is NULL'))
								, ' has been invited by the user #'
								, (SELECT IFNULL(@creator_bz_id, 'creator_bz_id is NULL'))
								, ' for the unit #'
								, (SELECT IFNULL(@product_id, 'product_id is NULL'))
								, ' and the role: '
								, (SELECT IFNULL(@role_user_g_description, 'role_user_g_description is NULL'))
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
		
		

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
