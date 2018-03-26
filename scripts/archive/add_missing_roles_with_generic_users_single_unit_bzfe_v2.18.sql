# For any question about this script - Ask Franck
#
#############################################
#											#
# IMPORTANT INFORMATION ABOUT THIS SCRIPT	#
#											#
#############################################
#
# Built for BZFE database v2.18
#
# Use this script only if:
#	- You are running this script as a User who can create and call procedures in the database.
#	- The unit ALREADY EXISTS in the BZFE
#	- 
# 
# This script will use:
# 	- The product id
#	- Data in the table 'ut_product_group'
#
# This script will
#	- Create components for each roles except the Mgt Company role for a given product
#	- Create the groups we need to manage user permissions
#	- Update the BZ log
#	- Update the list of groups in the 'ut_product_group' table
#	- Define the group control for these groups
#	- Make sure admin can manage the groups
#	- Make sure that LMB privileged user can
#		- Approve flags
#		- Do triage and edit all fields in a case
#	- Log what has been done
#
# Limits of this script:
#	- DO NOT RUN THIS SCRIPT MORE THAN ONCE!
#
# The logic for this script is:
# If there is no group_type:
#	- ??
#	- ?? 
# for this product, then create the group with the dummy user for this group.
#
#################################################################
#																#
# UPDATE THE BELOW VARIABLES ACCORDING TO YOUR NEEDS			#
#																#
#################################################################

# BZ product_id for the unit
	SET @product_id = 2;

# Environment: Which environment are you creatin the unit in?
#	- 1 is for the DEV/Staging
#	- 2 is for the PROD environment
	SET @environment = 1;
		
########################################################################
#
#	ALL THE VARIABLES WE NEED HAVE BEEN DEFINED, WE CAN RUN THE SCRIPT #
#
########################################################################

# Info about this script
	SET @script = 'add_missing_roles_with_generic_users_single_unit_bzfe_v2.18.sql';

# Timestamp	
	SET @timestamp = NOW();

# BZ user id of the user that is creating the unit 
	#	 For LMB units, we use 2 (support.nobody)
	SET @creator_bz_id = 2;

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
	
# Get the BZ profile id of the dummy users based on the environment variable
	# Tenant 1
		SET @bz_user_id_dummy_tenant = (SELECT `tenant_id` FROM `ut_temp_dummy_users_for_roles` WHERE `environment_id` = @environment);

	# Landlord 2
		SET @bz_user_id_dummy_landlord = (SELECT `landlord_id` FROM `ut_temp_dummy_users_for_roles` WHERE `environment_id` = @environment);
		
	# Contractor 3
		SET @bz_user_id_dummy_contractor = (SELECT `contractor_id` FROM `ut_temp_dummy_users_for_roles` WHERE `environment_id` = @environment);
		
	# Management company 4
		SET @bz_user_id_dummy_mgt_cny = (SELECT `mgt_cny_id` FROM `ut_temp_dummy_users_for_roles` WHERE `environment_id` = @environment);
		
	# Agent 5
		SET @bz_user_id_dummy_agent = (SELECT `agent_id` FROM `ut_temp_dummy_users_for_roles` WHERE `environment_id` = @environment);
	
# We create a temporary table to record the ids of the LMB roles we need in each environments:
	/*Table structure for table `ut_temp_lmb_groups` */

		DROP TABLE IF EXISTS `ut_temp_lmb_groups`;

		CREATE TABLE `ut_temp_lmb_groups` (
		  `environment_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Id of the environment',
		  `environment_name` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
		  `role_all_units` int(11) NOT NULL,
		  `role_triage` int(11) NOT NULL,
		  `role_flag_approver` int(11) NOT NULL,
		  PRIMARY KEY (`environment_id`)
		) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

	/*Data for the table `ut_temp_lmb_groups` */

		INSERT INTO `ut_temp_lmb_groups`(`environment_id`,`environment_name`,`role_all_units`,`role_triage`,`role_flag_approver`) values 
		(1,'DEV/Staging',47,5377,5378),
		(2,'PROD',47,4303,4302);

# Which are the groups that are granting the permissions we need to the LMB users:
	# Group to Access all LMB units
		SET @all_lmb_units_group_id = (SELECT `role_all_units` FROM `ut_temp_lmb_groups` WHERE `environment_id` = @environment);
	
	# Group to do triage for LMB units
		SET @role_triage_lmb = (SELECT `role_triage` FROM `ut_temp_lmb_groups` WHERE `environment_id` = @environment);
	
	# Group to grant all flag approval to LMB users
		SET @role_flag_approver_lmb = (SELECT `role_flag_approver` FROM `ut_temp_lmb_groups` WHERE `environment_id` = @environment);
	
# Other variables we need:
	SET @visibility_explanation_1 = 'Visible only to ';
	SET @visibility_explanation_2 = ' for this unit.';

# Update the table 'ut_product_group' to use the latest group_type_id
	# The correct group type_id 5 where there is a component_id is 37 instead of 5		
		UPDATE `ut_product_group`
			SET `group_type_id` = 37
			, `role_type_id` = 4
			WHERE `component_id` = @product_id
				AND `group_type_id` = 5
				AND `product_id` = @product_id
		;
	
# We Prepare the temporary tables we need to make sure we do not have duplicates.
	
	# user_group_map temp table
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

	# group_group_map temp table

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
		
#######
#
# THIS IS WHERE THE LOOP SHOULD START 
#

	
# Common info for the Group names:
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
		
		SET @unit_for_group = REPLACE(@unit_for_flag,'_','-');
		SET @unit_for_group = REPLACE(@unit_for_group,'----','-');
		SET @unit_for_group = REPLACE(@unit_for_group,'---','-');
		SET @unit_for_group = REPLACE(@unit_for_group,'--','-');
		SET @unit_for_group = REPLACE(@unit_for_group,'-#','-');
	
# Component related variables

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
	
# Groups that do NOT exist yet, they were NOT created as part of the migration
	
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
			# Visibility group - The group exists, we just need to update the name and description.
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

	# Find the id of the other groups we need 
		# The Group to Show cases to the management company (to update its description)
			SET @group_id_for_show_case_to_mgt_cny = (SELECT `group_id`
												FROM `ut_product_group`
												WHERE `product_id` = @product_id
													AND `role_type_id` = 4
													AND `group_type_id` = 37
												);
		# We need these to update the permissions:
		#	- Role LMB triage
		#	- Role LMB flag Approver
		#	- List of Management Company Users
			SET @can_edit_all_field_case_group_id = (SELECT `group_id` 
												FROM `ut_product_group` 
												WHERE (`product_id` = @product_id 
												AND `group_type_id` = 26)
												);
			SET @all_g_flags_group_id = (SELECT `group_id` 
										FROM `ut_product_group` 
										WHERE (`product_id` = @product_id 
										AND `group_type_id` = 19)
										);
			
			SET @group_id_are_users_mgt_cny = (SELECT `group_id`
											FROM `ut_product_group`
											WHERE `product_id` = @product_id
												AND `role_type_id` = 4
												AND `group_type_id` = 22
											);
											
		# For the Dummy users
			# Can tag comments
				SET @can_tag_comment_group_id = 18;
				
			# Can create a case for this product
				SET @create_case_group_id =  (SELECT `group_id` 
											FROM `ut_product_group` 
											WHERE (`product_id` = @product_id 
											AND `group_type_id` = 20)
											);
			
			# Can edit a case for this product
				SET @can_edit_case_group_id = (SELECT `group_id` 
											FROM `ut_product_group` 
											WHERE (`product_id` = @product_id 
											AND `group_type_id` = 25)
											);








			
# Do the changes we need:

	# Disable the FK check for the moment
				
	/*!40101 SET NAMES utf8 */;

	/*!40101 SET SQL_MODE=''*/;

	/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
	/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
	/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
	/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

	# Correct the description of the group to show/hide case from Mgt Cny
		UPDATE `groups`
		SET 
			`name` = @group_name_show_to_mgt_cny
			, `description` = @group_description_show_to_mgt_cny
		WHERE `id` = @group_id_for_show_case_to_mgt_cny;

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
			# Tenant
				(@group_id_show_to_tenant,@group_name_show_to_tenant,@group_description_tenant,1,'',1,NULL)
				,(@group_id_are_users_tenant,@group_name_are_users_tenant,@group_description_are_users_tenant,1,'',0,NULL)
				,(@group_id_see_users_tenant,@group_name_see_users_tenant,@group_description_see_users_tenant,1,'',0,NULL)
			# Landlord
				,(@group_id_show_to_landlord,@group_name_show_to_landlord,@group_description_show_to_landlord,1,'',1,NULL)
				,(@group_id_are_users_landlord,@group_name_are_users_landlord,@group_description_are_users_landlord,1,'',0,NULL)
				,(@group_id_see_users_landlord,@group_name_see_users_landlord,@group_description_see_users_landlord,1,'',0,NULL)
			# Agent
				,(@group_id_show_to_agent,@group_name_show_to_agent,@group_description_show_to_agent,1,'',1,NULL)
				,(@group_id_are_users_agent,@group_name_are_users_agent,@group_description_are_users_agent,1,'',0,NULL)
				,(@group_id_see_users_agent,@group_name_see_users_agent,@group_description_see_users_agent,1,'',0,NULL)
			# Contractor
				,(@group_id_show_to_contractor,@group_name_show_to_contractor,@group_description_show_to_contractor,1,'',1,NULL)
				,(@group_id_are_users_contractor,@group_name_are_users_contractor,@group_description_are_users_contractor,1,'',0,NULL)
				,(@group_id_see_users_contractor,@group_name_see_users_contractor,@group_description_see_users_contractor,1,'',0,NULL)
			# Occupant
				,(@group_id_show_to_occupant,@group_name_show_to_occupant,@group_description_show_to_occupant,1,'',1,NULL)
				,(@group_id_are_users_occupant,@group_name_are_users_occupant,@group_description_are_users_occupant,1,'',0,NULL)
				,(@group_id_see_users_occupant,@group_name_see_users_occupant,@group_description_see_users_occupant,1,'',0,NULL)
			# New Group for Mgt Cny
				,(@group_id_see_users_mgt_cny,@group_name_see_users_mgt_cny,@group_description_see_users_mgt_cny,1,'',0,NULL)
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

	# Make sure that only user in certain groups can create, edit or see cases.
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

		# Log the actions of the script.
			SET @script_log_message = CONCAT('We have added the group control permissions for that unit #'
									, @product_id
									, '\r\ - Show/hide case to '
									, 'Tenant'
									, ' only. Group_id: '
									, (SELECT IFNULL(@group_id_show_to_tenant, 'group_id_show_to_tenant is NULL'))
									, '\r\ - Show/hide case to '
									, 'Landlord'
									, ' only. Group_id: '
									, (SELECT IFNULL(@group_id_show_to_landlord, 'group_id_show_to_landlord is NULL'))
									, '\r\ - Show/hide case to '
									, 'Agent'
									, ' only. Group_id: '
									, (SELECT IFNULL(@group_id_show_to_agent, 'group_id_show_to_agent is NULL'))
									, '\r\ - Show/hide case to '
									, 'Contractor'
									, ' only. Group_id: '
									, (SELECT IFNULL(@group_id_show_to_contractor, 'group_id_show_to_contractor is NULL'))
									, '\r\ - Show/hide case to '
									, 'occupant'
									, ' only. Group_id: '
									, (SELECT IFNULL(@group_id_show_to_occupant, 'group_id_show_to_occupant is NULL'))
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
		
	# Configure the group permissions:
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
				# Tenant
					(1,@group_id_show_to_tenant,1)
					,(1,@group_id_are_users_tenant,1)
					,(1,@group_id_see_users_tenant,1)
				# Landlord
					,(1,@group_id_show_to_landlord,1)
					,(1,@group_id_are_users_landlord,1)
					,(1,@group_id_see_users_landlord,1)
				# Agent
					,(1,@group_id_show_to_agent,1)
					,(1,@group_id_are_users_agent,1)
					,(1,@group_id_see_users_agent,1)
				# Contractor
					,(1,@group_id_show_to_contractor,1)
					,(1,@group_id_are_users_contractor,1)
					,(1,@group_id_see_users_contractor,1)
				# Occupants
					,(1,@group_id_show_to_occupant,1)
					,(1,@group_id_are_users_occupant,1)
					,(1,@group_id_see_users_occupant,1)
				# New groups for Mgt Cny:
					,(1,@group_id_see_users_mgt_cny,1)

				# LMB Group Membership:																		
			
					# If you are in the group for LMB users, you can see the LMB employees
					,(@all_lmb_units_group_id, @group_id_see_users_mgt_cny, 0)
					# If you are in the group for LMB users, you are in the group for management company employees for this unit
					,(@all_lmb_units_group_id, @group_id_are_users_mgt_cny, 0)
					
					# If you are allowed to approve flags for LMB then you can approve these
					,(@role_flag_approver_lmb, @all_g_flags_group_id, 0) 
					# If you are responsible for triage, then you can edit all fields
					,(@role_triage_lmb, @can_edit_all_field_case_group_id, 0)
				
				# Visibility groups:
				,(@group_id_see_users_tenant,@group_id_are_users_tenant,2)
				,(@group_id_see_users_landlord,@group_id_are_users_landlord,2)
				,(@group_id_see_users_agent,@group_id_are_users_contractor,2)
				,(@group_id_see_users_occupant,@group_id_are_users_occupant,2)
				
				,(@group_id_see_users_mgt_cny,@group_id_are_users_mgt_cny,2)
				;

		# Log the actions of the script.
			SET @script_log_message = CONCAT('We have added the groups that can access the groups in that Unit #'
									, @product_id
									, '\r\Users in the Admin group can grant permissions to the following groups: '
									, '\r\ - Restrict permission to '
									, '\r\   - tenant '
									, ' only. Group_id: '
									, (SELECT IFNULL(@group_id_show_to_tenant, 'group_id_show_to_tenant is NULL'))
									, '\r\   - Users are '
									, 'tenant'
									, ' Group_id: '
									, (SELECT IFNULL(@group_id_are_users_tenant, 'group_id_are_users_tenant is NULL'))
									, '\r\   - Group to see the users '
									, 'tenant'
									, '. Group_id: '
									, (SELECT IFNULL(@group_id_see_users_tenant, 'group_id_see_users_tenant is NULL'))
									
									, '\r\ - Restrict permission to '
									, '\r\   - landlord'
									, ' only. Group_id: '
									, (SELECT IFNULL(@group_id_show_to_landlord, 'group_id_show_to_landlord is NULL'))
									, '\r\   - Users are '
									, 'landlord'
									, ' Group_id: '
									, (SELECT IFNULL(@group_id_are_users_landlord, 'group_id_are_users_landlord is NULL'))
									, '\r\   - Group to see the users'
									, 'landlord'
									, '. Group_id: '
									, (SELECT IFNULL(@group_id_see_users_landlord, 'group_id_see_users_landlord is NULL'))
									
									, '\r\ - Restrict permission to '
									, '\r\   - agent'
									, ' only. Group_id: '
									, (SELECT IFNULL(@group_id_show_to_agent, 'group_id_show_to_agent is NULL'))
									, '\r\   - Users are '
									, 'agent'
									, ' only. Group_id: '
									, (SELECT IFNULL(@group_id_are_users_agent, 'group_id_are_users_agent is NULL'))
									, '\r\   - Group to see the users'
									, 'agent'
									, '. Group_id: '
									, (SELECT IFNULL(@group_id_see_users_agent, 'group_id_see_users_agent is NULL'))
									
									, '\r\ - Restrict permission to '
									, '\r\   - Contractor'
									, ' only. Group_id: '
									, (SELECT IFNULL(@group_id_show_to_contractor, 'group_id_show_to_contractor is NULL'))
									, '\r\   - Users are '
									, 'Contractor'
									, ' Group_id: '
									, (SELECT IFNULL(@group_id_are_users_contractor, 'group_id_are_users_contractor is NULL'))
									, '\r\   - Group to see the users'
									, 'Contractor'
									, '. Group_id: '
									, (SELECT IFNULL(@group_id_see_users_contractor, 'group_id_see_users_contractor is NULL'))
									
									, '\r\ - Restrict permission to '
									, '\r\   - occupant'
									, ' only. Group_id: '
									, (SELECT IFNULL(@group_id_show_to_occupant, 'group_id_show_to_occupant is NULL'))
									, '\r\   - Users are '
									, 'occupant'
									, ' Group_id: '
									, (SELECT IFNULL(@group_id_are_users_occupant, 'group_id_are_users_occupant is NULL'))
									, '\r\   - Group to see the users '
									, 'occupant'
									, '. Group_id: '
									, (SELECT IFNULL(@group_id_see_users_occupant, 'group_id_see_users_occupant is NULL'))
									
									, '\r\The rest of what this step does will be finished at a later stage...'
									, '\r\The other groups we used were'
									, '\r\ - Can Tag a comment: '
									, @can_tag_comment_group_id
									, '\r\ - LMB Role Triage: '
									, @role_triage_lmb
									, '\r\ - LMB Role Flag Approver'
									, @role_flag_approver_lmb
									, '\r\ - LMB Role Can see all LMB units: '
									, @all_lmb_units_group_id
									, '\r\ - Can edit all fields (triage): '
									, @can_edit_all_field_case_group_id
									, '\r\ - Can create a Case: '
									, @create_case_group_id
									, '\r\ - Can edit a Case: '
									, @can_edit_case_group_id
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
		SET @script_log_message = CONCAT('The additional role created for that unit #'
								, @product_id
								, ' were:'
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

# We now assign the permissions to the dummy users associated to this role:		

# We create the permissions for the dummy user to create a case for this unit.		
#	- can tag comments: ALL user need that	
#	- can_create_new_cases
#	- can_edit_a_case
# This is the only permission that the dummy user will have.

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
		

#
# This is where we should close the loop
#
###############

# We give the user in the groups we identified the permission they need to access the cases and units.
		
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
		DROP TABLE IF EXISTS `ut_user_group_map_temp`;
		DROP TABLE IF EXISTS `ut_temp_dummy_users_for_roles`;
		DROP TABLE IF EXISTS `ut_temp_lmb_groups`;

# We implement the FK checks again
		
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;