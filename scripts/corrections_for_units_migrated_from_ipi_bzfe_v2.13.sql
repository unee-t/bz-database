# For any question about this script, ask Franck

#############################################
#											#
# IMPORTANT INFORMATION ABOUT THIS SCRIPT	#
#											#
#############################################
#
# Built for BZFE database v2.13
#
# Use this script only if the Unit DOES EXIST YET in the BZFE AND IS A UNIT THAT WAS MIGRATED FROM IPI
# Use this scrip ONLY for the first user in this role for the unit.
#
# When we migrated the LMB units we have ONLY created the role 'Management Company' when we migrated the units from IPI into Unee-T
# We need to create all the other roles now.
#	- we did NOT create all the group needed for all the roles - we need to do that for:
#		- Tenant  (all 3 groups)
#		- Landlord  (all 3 groups)
#		- Agent  (all 3 groups)
#		- Contractor (all 3 groups)
#		- Management company (group to see the users that are in Management Company)
#		- Occupants (all 3 groups)
#	- The Group type list was not the same, we created new group types since the migration:
#		- #37 to see the list of stakeholders for a certain role
#		- #36 to see the list of occupants
#		- #24 to hide/show cases from occupants
#	- we created a few groups that are now obsolete:
#		- 
#		-
#	- We need to make sure that the LMB groups are correctly configured for this unit too:
#		- #47 see all LMB units
#		- #4302 Grant all flag approval
#		- #4303 Role LMB Triage.
#
#	- Because of how the invitation mechanism is handled in Unee-T, we need to create ALL the components.
#	  Components that are NOT 'management Company' should be created too with a default user:
#		- agent -> temporary.agent.dev@unee-t.com
#			- in DEV, BZ id = 92
#			- in PROD,  BZ id = 89
#		- landlord  -> temporary.landlord.dev@unee-t.com
#			- in DEV, BZ id = 94
#			- in PROD,  BZ id = 91
#		- Tenant  -> temporary.tenant.dev@unee-t.com
#			- in DEV, BZ id = 96
#			- in PROD,  BZ id = 93
#		- Contractor  -> temporary.contractor.dev@unee-t.com
#			- in DEV, BZ id = 93
#			- in PROD,  BZ id = 90
#		- Management Company  -> temporary.mgt.cny.dev@unee-t.com
#			- in DEV, BZ id = 95
#			- in PROD,  BZ id = 92
#
#	- These temporary users should also be able to create a case for this unit too.
#
#	- We also need to make sure that we are recording properly the information about who invited who for this unit!
#
# This script rectifies that and makes sure that all units are created in a consistent manner.
#
# Pre-requisite:
#	- We know the BZ product_id of the product that we need to update.
#	- We know the BZ user id of the user that will be the default assignee for this unit
#	- We know the BZ user id of the user that creates this unit and first role.
# 
# This script will:
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

# The unit alredy exist:

	# BZ Classification id for the unit that you want to create (default is 2)
	SET @product_id = 253;

	SET @visibility_explanation_1 = 'Visible only to ';
	SET @visibility_explanation_2 = ' for this unit.';

	
# Enter the BZ user id for the dummy users.
# This is needed so that the invitation mechanism works as intended in the MEFE.
	#	- Tenant 1
		SET @bz_user_id_dummy_tenant = 93;
	# 	- Landlord 2
		SET @bz_user_id_dummy_landlord = 91;
	#	- Agent 5
		SET @bz_user_id_dummy_agent = 89;
	#	- Contractor 3
		SET @bz_user_id_dummy_contractor = 90;
	#	- Management company 4
		SET @bz_user_id_dummy_mgt_cny = 92;
	
########################################################################
#
#	ALL THE VARIABLES WE NEED HAVE BEEN DEFINED, WE CAN RUN THE SCRIPT #
#
########################################################################

# Info about this script
	SET @script = 'corrections_for_units_migrated_from_ipi_bzfe_v2.13.sql';

# Timestamp	
	SET @timestamp = NOW();

# This is an update, we know the creator was 2
	SET @creator_bz_id = 2;
	
# We populate the additional variables that we will need for this script to work

	# For the product
		SET @unit = (SELECT `name` FROM `products` WHERE `id` = @product_id);
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
		SET @unit_for_group = REPLACE(@unit_for_group,'----','-');
		SET @unit_for_group = REPLACE(@unit_for_group,'---','-');
		SET @unit_for_group = REPLACE(@unit_for_flag,'_','-');

	# For the creator
	# This is NOT needed: we are just updating things...
	#	SET @creator_pub_name = (SELECT `realname` FROM `profiles` WHERE `userid` = @creator_bz_id);
		
	# For the temporary users:
		# Tenant
			SET @component_id_tenant = ((SELECT MAX(`id`) FROM `components`) + 1);
			SET @role_user_g_description_tenant = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`= 1);
			SET @user_pub_name_tenant = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_tenant);
			SET @role_user_pub_info_tenant = CONCAT(@user_pub_name_tenant
												,' - '
												, 'THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL '
												, @role_user_g_description_tenant
												, ' TO THIS UNIT'
												);
			SET @user_role_desc_tenant = @role_user_pub_info_tenant;

		# Landlord
			SET @component_id_landlord = (@component_id_tenant + 1);
			SET @role_user_g_description_landlord = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`= 2);
			SET @user_pub_name_landlord = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_landlord);
			SET @role_user_pub_info_landlord = CONCAT(@user_pub_name_landlord
												,' - '
												, 'THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL '
												, @role_user_g_description_landlord
												, ' TO THIS UNIT'
												);
			SET @user_role_desc_landlord = @role_user_pub_info_landlord;
		
		# Agent
			SET @component_id_agent = (@component_id_landlord + 1);
			SET @role_user_g_description_agent = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`= 5);
			SET @user_pub_name_agent = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_agent);
			SET @role_user_pub_info_agent = CONCAT(@user_pub_name_agent
												,' - '
												, 'THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL '
												, @role_user_g_description_agent
												, ' TO THIS UNIT'
												);
			SET @user_role_desc_agent = @role_user_pub_info_agent;
		
		# Contractor
			SET @component_id_contractor = (@component_id_agent + 1);
			SET @role_user_g_description_contractor = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`= 3);
			SET @user_pub_name_contractor = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_contractor);
			SET @role_user_pub_info_contractor = CONCAT(@user_pub_name_contractor
												,' - '
												, 'THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL '
												, @role_user_g_description_contractor
												, ' TO THIS UNIT'
												);
			SET @user_role_desc_contractor = @role_user_pub_info_contractor;
			
/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Groups that do NOT exist yet, they were NOT created as part of the migration

	# For simplicity reason, it is better to create ALL the groups we need for all the possible roles and permissions
	# This will avoid a scenario where we need to grant permission to see occupants for instances but the group for occupants does not exist yet...
	
	# Groups associated to the components/roles
		# For the tenant
			# Visibility group
			SET @group_id_show_to_tenant = ((SELECT MAX(`id`) FROM `groups`) + 1);
			SET @group_name_show_to_tenant = (CONCAT(@unit_for_group,'-02-Limit-to-Tenant'));
			SET @group_description_tenant = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 1),@visibility_explanation_2));
		
			# Is in tenant user Group
			SET @group_id_are_users_tenant = (@group_id_show_to_tenant + 1);
			SET @group_name_are_users_tenant = (CONCAT(@unit_for_group,'-06-List-Tenant'));
			SET @group_description_are_users_tenant = (CONCAT('list the tenant(s)', @unit));
			
			# Can See tenant user Group
			SET @group_id_see_users_tenant = (@group_id_are_users_tenant + 1);
			SET @group_name_see_users_tenant = (CONCAT(@unit_for_group,'-06-Can-see-Tenant'));
			SET @group_description_see_users_tenant = (CONCAT('See the list of tenant(s) for ', @unit));
	
		# For the Landlord
			# Visibility group 
			SET @group_id_show_to_landlord = (@group_id_see_users_tenant + 1);
			SET @group_name_show_to_landlord = (CONCAT(@unit_for_group,'-02-Limit-to-Landlord'));
			SET @group_description_show_to_landlord = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 2),@visibility_explanation_2));
			
			# Is in landlord user Group
			SET @group_id_are_users_landlord = (@group_id_show_to_landlord + 1);
			SET @group_name_are_users_landlord = (CONCAT(@unit_for_group,'-06-List-landlord'));
			SET @group_description_are_users_landlord = (CONCAT('list the landlord(s)', @unit));
			
			# Can See landlord user Group
			SET @group_id_see_users_landlord = (@group_id_are_users_landlord + 1);
			SET @group_name_see_users_landlord = (CONCAT(@unit_for_group,'-06-Can-see-lanldord'));
			SET @group_description_see_users_landlord = (CONCAT('See the list of lanldord(s) for ', @unit));
			
		# For the agent
			# Visibility group 
			SET @group_id_show_to_agent = (@group_id_see_users_landlord + 1);
			SET @group_name_show_to_agent = (CONCAT(@unit_for_group,'-02-Limit-to-Agent'));
			SET @group_description_show_to_agent = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 5),@visibility_explanation_2));
			
			# Is in Agent user Group
			SET @group_id_are_users_agent = (@group_id_show_to_agent + 1);
			SET @group_name_are_users_agent = (CONCAT(@unit_for_group,'-06-List-agent'));
			SET @group_description_are_users_agent = (CONCAT('list the agent(s)', @unit));
			
			# Can See Agent user Group
			SET @group_id_see_users_agent = (@group_id_are_users_agent + 1);
			SET @group_name_see_users_agent = (CONCAT(@unit_for_group,'-06-Can-see-agent'));
			SET @group_description_see_users_agent = (CONCAT('See the list of agent(s) for ', @unit));
		
		# For the contractor
			# Visibility group 
			SET @group_id_show_to_contractor = (@group_id_see_users_agent + 1);
			SET @group_name_show_to_contractor = (CONCAT(@unit_for_group,'-02-Limit-to-Contractor-Employee'));
			SET @group_description_show_to_contractor = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 3),@visibility_explanation_2));
			
			# Is in contractor user Group
			SET @group_id_are_users_contractor = (@group_id_show_to_contractor + 1);
			SET @group_name_are_users_contractor = (CONCAT(@unit_for_group,'-06-List-contractor-employee'));
			SET @group_description_are_users_contractor = (CONCAT('list the contractor employee(s)', @unit));
			
			# Can See contractor user Group
			SET @group_id_see_users_contractor = (@group_id_are_users_contractor + 1);
			SET @group_name_see_users_contractor = (CONCAT(@unit_for_group,'-06-Can-see-contractor-employee'));
			SET @group_description_see_users_contractor = (CONCAT('See the list of contractor employee(s) for ', @unit));
			
		# For the Mgt Cny
			# Visibility group 
			SET @group_name_show_to_mgt_cny = (CONCAT(@unit_for_group,'-02-Limit-to-Mgt-Cny-Employee'));
			SET @group_description_show_to_mgt_cny = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 4),@visibility_explanation_2));
				
			# Can See mgt cny user Group
			SET @group_id_see_users_mgt_cny = (@group_id_see_users_contractor + 1);
			SET @group_name_see_users_mgt_cny = (CONCAT(@unit_for_group,'-06-Can-see-Mgt-Cny-Employee'));
			SET @group_description_see_users_mgt_cny = (CONCAT('See the list of Mgt Cny Employee(s) for ', @unit));
		
		# For the occupant
			# Visibility group
			SET @group_id_show_to_occupant = (@group_id_see_users_mgt_cny + 1);
			SET @group_name_show_to_occupant = (CONCAT(@unit_for_group,'-02-Limit-to-occupant'));
			SET @group_description_show_to_occupant = (CONCAT(@visibility_explanation_1,'Occupants'));
			
			# Is in occupant user Group
			SET @group_id_are_users_occupant = (@group_id_show_to_occupant + 1);
			SET @group_name_are_users_occupant = (CONCAT(@unit_for_group,'-06-List-occupant'));
			SET @group_description_are_users_occupant = (CONCAT('list-the-occupant(s)-', @unit));
			
			# Can See occupant user Group
			SET @group_id_see_users_occupant = (@group_id_are_users_occupant + 1);
			SET @group_name_see_users_occupant = (CONCAT(@unit_for_group,'-06-Can-see-occupant'));
			SET @group_description_see_users_occupant = (CONCAT('See the list of occupant(s) for ', @unit));

# We need to correct the information about certain groups to be consistent with the new group structure
	# Group to show/hide a case from Mgt Cny in the table 'ut_product_group' 
		UPDATE `ut_product_group`
		SET 
			`role_type_id` = 4
			, `group_type_id` = 37
		WHERE `product_id` = @product_id
			AND `component_id` = @product_id
			AND `group_type_id` = 5
		;
		
	# Description of the group to show/hide case from Mgt Cny
		# find the id of this group
		SET @group_id_for_show_case_to_mgt_cny = (SELECT `group_id`
												FROM `ut_product_group`
												WHERE `product_id` = @product_id
													AND `role_type_id` = 4
													AND `group_type_id` = 37
												);
		
		# Update the group description
		UPDATE `groups`
		SET 
			`name` = @group_name_show_to_mgt_cny
			, `description` = @group_description_show_to_mgt_cny
		WHERE `id` = @group_id_for_show_case_to_mgt_cny
		;
			
# We need several goups so this can work

	# We can populate the 'groups' table now with the new groups we need.
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
			,(@group_id_show_to_occupant,@group_name_show_to_occupant,@group_description_show_to_occupant,1,'',1,NULL)
			,(@group_id_are_users_occupant,@group_name_are_users_occupant,@group_description_are_users_occupant,1,'',0,NULL)
			,(@group_id_see_users_occupant,@group_name_see_users_occupant,@group_description_see_users_occupant,1,'',0,NULL)
			;

	# Log the actions of the script.
		SET @script_log_message = CONCAT('We have created the additional groups that we will need for that unit #'
								, @product_id
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
		# Tenant (1)
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
		# occupant (#)
		,(@product_id,NULL,@group_id_show_to_occupant,24,NULL,@creator_bz_id,@timestamp)
		,(@product_id,NULL,@group_id_are_users_occupant,3,NULL,@creator_bz_id,@timestamp)
		,(@product_id,NULL,@group_id_see_users_occupant,36,NULL,@creator_bz_id,@timestamp)
		;


# Groups that already exist and have been created before we need to retrieve the Group_id from the DB
		SET @create_case_group_id =  (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 20));
		SET @can_edit_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 25));
		SET @can_edit_all_field_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 26));
		SET @can_edit_component_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 27));
		SET @can_see_cases_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 28));
		SET @all_r_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 18));
		SET @all_g_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 19));
		SET @list_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 4));
		SET @see_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 5));
		
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
		,(1,@group_id_see_users_mgt_cny,1)
		,(1,@group_id_show_to_occupant,1)
		,(1,@group_id_are_users_occupant,1)
		,(1,@group_id_see_users_occupant,1)

		# LMB Group Membership:
		# If you are in the group for LMB users, you can see the LMB employees
		,(47, @group_id_see_users_mgt_cny, 0)
		# If you are in the group for LMB users, you are in the group for management company employees for this unit
		,(47, @group_id_are_users_mgt_cny, 0)
		# If you are allowed to approve flags for LMB then you can approve these
		,(4302, @all_g_flags_group_id, 0) 
		
		# Visibility groups:
		,(@group_id_see_users_tenant,@group_id_are_users_tenant,2)
		,(@group_id_see_users_landlord,@group_id_are_users_landlord,2)
		,(@group_id_see_users_agent,@group_id_are_users_contractor,2)
		,(@group_id_see_users_mgt_cny,@group_id_are_users_mgt_cny,2)
		,(@group_id_see_users_occupant,@group_id_are_users_occupant,2)
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
		(@group_id_show_to_tenant,@product_id,0,2,0,0,0,0,0)
		,(@group_id_show_to_landlord,@product_id,0,2,0,0,0,0,0)
		,(@group_id_show_to_agent,@product_id,0,2,0,0,0,0,0)
		,(@group_id_show_to_contractor,@product_id,0,2,0,0,0,0,0)
		,(@group_id_show_to_occupant,@product_id,0,2,0,0,0,0,0)
		;
		
# Now we insert the component/roles that we did not create during the migration
	
	# We have everything, we can now create the other component/role for the unit.
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
			(@component_id_tenant,@role_user_g_description_tenant,@product_id,@bz_user_id_dummy_tenant,@bz_user_id_dummy_tenant,@user_role_desc_tenant,1)
			, (@component_id_landlord, @role_user_g_description_landlord, @product_id, @bz_user_id_dummy_landlord, @bz_user_id_dummy_landlord, @user_role_desc_landlord, 1)
			, (@component_id_agent, @role_user_g_description_agent, @product_id, @bz_user_id_dummy_agent, @bz_user_id_dummy_agent, @user_role_desc_agent, 1)
			, (@component_id_contractor, @role_user_g_description_contractor, @product_id, @bz_user_id_dummy_contractor, @bz_user_id_dummy_contractor, @user_role_desc_contractor, 1)
			;
	# Log the actions of the script.
		SET @script_log_message = CONCAT('The additional role created for that unit were:'
								, '\r\- '
								, (SELECT IFNULL(@role_user_g_description_tenant, 'role_user_g_description is NULL'))
								, ' (role_type_id #'
								, '1'
								, ') '
								, '\r\The user associated to this role was bz user #'
								, (SELECT IFNULL(@bz_user_id_dummy_tenant, 'bz_user_id is NULL'))
								, ' (real name: '
								, (SELECT IFNULL(@user_pub_name_tenant, 'user_pub_name is NULL'))
								, '. This user is the default assignee for this role for that unit).' 
								, '\r\- '
								, (SELECT IFNULL(@role_user_g_description_landlord, 'role_user_g_description is NULL'))
								, ' (role_type_id #'
								, '2'
								, ') '
								, '\r\The user associated to this role was bz user #'
								, (SELECT IFNULL(@bz_user_id_dummy_landlord, 'bz_user_id is NULL'))
								, ' (real name: '
								, (SELECT IFNULL(@user_pub_name_landlord, 'user_pub_name is NULL'))
								, '. This user is the default assignee for this role for that unit).'
								, '\r\- '
								, (SELECT IFNULL(@role_user_g_description_agent, 'role_user_g_description is NULL'))
								, ' (role_type_id #'
								, '5'
								, ') '
								, '\r\The user associated to this role was bz user #'
								, (SELECT IFNULL(@bz_user_id_dummy_agent, 'bz_user_id is NULL'))
								, ' (real name: '
								, (SELECT IFNULL(@user_pub_name_agent, 'user_pub_name is NULL'))
								, '. This user is the default assignee for this role for that unit).'
								, '\r\- '
								, (SELECT IFNULL(@role_user_g_description_contractor, 'role_user_g_description is NULL'))
								, ' (role_type_id #'
								, '3'
								, ') '
								, '\r\The user associated to this role was bz user #'
								, (SELECT IFNULL(@bz_user_id_dummy_contractor, 'bz_user_id is NULL'))
								, ' (real name: '
								, (SELECT IFNULL(@user_pub_name_contractor, 'user_pub_name is NULL'))
								, '. This user is the default assignee for this role for that unit).'								
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
		(@creator_bz_id,'Bugzilla::Group',@group_id_show_to_tenant,'__create__',NULL, @group_name_show_to_tenant, @timestamp)
		,(@creator_bz_id,'Bugzilla::Group',@group_id_are_users_tenant,'__create__',NULL, @group_name_are_users_tenant, @timestamp)
		,(@creator_bz_id,'Bugzilla::Group',@group_id_see_users_tenant,'__create__',NULL, @group_name_see_users_tenant, @timestamp)
		,(@creator_bz_id,'Bugzilla::Group',@group_id_show_to_landlord,'__create__',NULL, @group_name_show_to_landlord, @timestamp)
		,(@creator_bz_id,'Bugzilla::Group',@group_id_are_users_landlord,'__create__',NULL, @group_name_are_users_landlord, @timestamp)
		,(@creator_bz_id,'Bugzilla::Group',@group_id_see_users_landlord,'__create__',NULL, @group_name_see_users_landlord, @timestamp)
		,(@creator_bz_id,'Bugzilla::Group',@group_id_show_to_agent,'__create__',NULL, @group_name_show_to_agent , @timestamp)
		,(@creator_bz_id,'Bugzilla::Group',@group_id_are_users_agent,'__create__',NULL, @group_name_are_users_agent, @timestamp)
		,(@creator_bz_id,'Bugzilla::Group',@group_id_see_users_agent,'__create__',NULL, @group_name_see_users_agent, @timestamp)
		,(@creator_bz_id,'Bugzilla::Group',@group_id_show_to_contractor,'__create__',NULL, @group_name_show_to_contractor, @timestamp)
		,(@creator_bz_id,'Bugzilla::Group',@group_id_are_users_contractor,'__create__',NULL, @group_name_are_users_contractor, @timestamp)
		,(@creator_bz_id,'Bugzilla::Group',@group_id_see_users_contractor,'__create__',NULL, @group_name_see_users_contractor, @timestamp)
		,(@creator_bz_id,'Bugzilla::Group',@group_id_show_to_occupant,'__create__',NULL, @group_name_show_to_occupant, @timestamp)
		,(@creator_bz_id,'Bugzilla::Group',@group_id_are_users_occupant,'__create__',NULL, @group_name_are_users_occupant, @timestamp)
		,(@creator_bz_id,'Bugzilla::Group',@group_id_see_users_occupant,'__create__',NULL, @group_name_see_users_occupant,@timestamp)
		,(@creator_bz_id,'Bugzilla::Component',@component_id_tenant,'__create__',NULL, @role_user_g_description_tenant, @timestamp)
		,(@creator_bz_id,'Bugzilla::Component',@component_id_landlord,'__create__',NULL, @role_user_g_description_landlord, @timestamp)
		,(@creator_bz_id,'Bugzilla::Component',@component_id_agent,'__create__',NULL, @role_user_g_description_agent, @timestamp)
		,(@creator_bz_id,'Bugzilla::Component',@component_id_contractor,'__create__',NULL, @role_user_g_description_contractor, @timestamp)
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

# We create the permissions for the dummy user to create a case for this unit.		
#	- can tag comments: ALL user need that	
#	- can_create_new_cases
#	- can_edit_a_case
# This is the only permission that the dummy user will have.

	# Can tag comments
		SET @can_tag_comment_group_id = 18;	

	# First the global permissions:
		# Can tag comments
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id_dummy_tenant,@can_tag_comment_group_id,0,0)
				, (@bz_user_id_dummy_landlord,@can_tag_comment_group_id,0,0)
				, (@bz_user_id_dummy_agent,@can_tag_comment_group_id,0,0)
				, (@bz_user_id_dummy_contractor,@can_tag_comment_group_id,0,0)
				;
				
			# Log the actions of the script.
				SET @script_log_message = CONCAT('the dummy bz users for each component: '
										, '(#'
										, @bz_user_id_dummy_tenant
										, ', #'
										, @bz_user_id_dummy_landlord
										, ', #'
										, @bz_user_id_dummy_agent
										, ', #'
										, @bz_user_id_dummy_contractor
										, ')'
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
					(NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_tenant, @script, 'Add the BZ user id when we grant the permission to tag comments')
					, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_tag_comment_group_id, @script, 'Add the BZ group id when we grant the permission to tag comments')
					, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant tag comments permission')
					, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group tag comments')
					, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_landlord, @script, 'Add the BZ user id when we grant the permission to tag comments')
					, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_tag_comment_group_id, @script, 'Add the BZ group id when we grant the permission to tag comments')
					, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant tag comments permission')
					, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group tag comments')
					, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_agent, @script, 'Add the BZ user id when we grant the permission to tag comments')
					, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_tag_comment_group_id, @script, 'Add the BZ group id when we grant the permission to tag comments')
					, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant tag comments permission')
					, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group tag comments')
					, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_contractor, @script, 'Add the BZ user id when we grant the permission to tag comments')
					, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_tag_comment_group_id, @script, 'Add the BZ group id when we grant the permission to tag comments')
					, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant tag comments permission')
					, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group tag comments')
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				
	# Then the permissions at the unit/product level:
				
		# User can create a case:
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id_dummy_tenant, @create_case_group_id, 0, 0)
				, (@bz_user_id_dummy_landlord, @create_case_group_id, 0, 0)
				, (@bz_user_id_dummy_agent, @create_case_group_id, 0, 0)
				, (@bz_user_id_dummy_contractor, @create_case_group_id, 0, 0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the dummy bz users for each component: '
										, '(#'
										, @bz_user_id_dummy_tenant
										, ', #'
										, @bz_user_id_dummy_landlord
										, ', #'
										, @bz_user_id_dummy_agent
										, ', #'
										, @bz_user_id_dummy_contractor
										, ')'
										, ' CAN create new cases for unit '
										, @product_id
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
					(NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_tenant, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
					, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
					, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission', 'for the product #', @product_id))
					, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
					, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_landlord, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
					, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
					, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission', 'for the product #', @product_id))
					, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
					, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_agent, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
					, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
					, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission', 'for the product #', @product_id))
					, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
					, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_contractor, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
					, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
					, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, 'for the product #', @product_id))
					, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;

		# User can Edit a case this is needed so the API does not thrown an error:

			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id_dummy_tenant,@can_edit_case_group_id,0,0)
				, (@bz_user_id_dummy_landlord,@can_edit_case_group_id,0,0)
				, (@bz_user_id_dummy_agent,@can_edit_case_group_id,0,0)
				, (@bz_user_id_dummy_contractor,@can_edit_case_group_id,0,0)
				;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the dummy bz users for each component: '
										, '(#'
										, @bz_user_id_dummy_tenant
										, ', #'
										, @bz_user_id_dummy_landlord
										, ', #'
										, @bz_user_id_dummy_agent
										, ', #'
										, @bz_user_id_dummy_contractor
										, ')'
										, ' CAN edit a cases for unit '
										, @product_id
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
					(NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_tenant, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
					, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
					, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission', 'for the product #', @product_id))
					, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
					, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_landlord, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
					, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
					, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission', 'for the product #', @product_id))
					, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
					, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_agent, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
					, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
					, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission', 'for the product #', @product_id))
					, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
					, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_contractor, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
					, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
					, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, 'for the product #', @product_id))
					, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;				
		
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
		DROP TABLE IF EXISTS `ut_group_group_map_temp`;
		
	# We Delete the temp table as we do not need it anymore
		DROP TABLE IF EXISTS `ut_user_group_map_temp`;


# We implement the FK checks again
		
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;		

