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

# Get the variables that we need:
		# We know that the unit is product_id = 1 
			SET @product_id = 1;

		# We create a variable @visibility_explanation_1 and 2 to facilitate development
		# 	This variable store the text displayed next to the 'visibility' tick in a case
		# 	We do this that way so we can re-use @visibility_explanation in the script to create several demo users.
			SET @visibility_explanation_1 = 'Tick to HIDE this case if the user is the ';
			SET @visibility_explanation_2 = ' for this unit. Untick to Show this case';
			
		# Get the additional data we need
			SET @unit = (SELECT `name` FROM `products` WHERE `id`=1);

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
			SET @creator_pub_name = 'Leonel - My Real Estate Agency';
			SET @stakeholder_pub_info = CONCAT(@creator_pub_name,' - Phone number: 123 456 7891. For a faster response, please message me directly in Unee-T for this unit');

		# User role: this is an id in the table `ut_role_types` for easier manipulation, update and maintenance
			SET @role_type_id = 5;

	# We Need the BZ user information for Leonel too
			SET @bz_user_id = 2;
		# By default the creator is can be asked to approve all flags but we want flexibility there 
		# We know this might not be always true for all BZ user we create
			SET @bz_user_id_who_can_be_asked_to_approve = @bz_user_id;
		# By default the creator can approve all flags but we want flexibility there 
		# We know this might not be always true for all BZ user we create
			SET @bz_user_id_who_can_approve = @bz_user_id;

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

		/*Data for the table `components` */
		# We first need to delete the component created in the BZ blank install
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
# WIP ... De we REALLY need 2 components here?
# it seems better to have this managed with <> premissions...
# We comment this out for now until further notice...
#			SET @creator_component_id = @component_id;

		# We need to delete the groups that we have created as part of the default BZFE install so we can recreate these
		DELETE FROM `groups` WHERE `id` >18 AND `id` <40;
#############################################################################################################
# DANGER because of this, the script will break if the list of groups we create in a blank BZFE changes...  #
#############################################################################################################

		# We know the last 'system' group created by the BZFE creation script is 18
		# based on this, we derive the other new group_id too.
		# group for the unit creator (first new group we create)
		SET @creator_group_id = 19;
		# group to grant visibility to this type of role/stakeholder
		SET @visibility_case_group_id = (@creator_group_id+1);
		# List all the user that are visible in the drop down list
		SET @list_user_group_id = (@visibility_case_group_id+1);
		# Group to see the list of visible users for this unit
		SET @see_user_group_id = (@list_user_group_id+1);
		# get the id for the rest of the groups we need 
		# These are the groups to grant/request flags for this product/unit
		SET @g_group_next_step = (@see_user_group_id+1);
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
		# Next is a group for all the USERS who can approve/reject a flag
		SET @all_g_flags_group_id = (@r_group_is_paid+1);
		# Next is a group for all the USERS who are allowed to be asked for flag approval
		# this allows us to display the correct list of users in the drop down list next to a flag
		SET @all_r_flags_group_id = (@all_g_flags_group_id+1);
		# Now we need a Group of groups to facilitate user management all the user in this unit belong there.
		SET @all_unit_privileges_group_id = (@all_r_flags_group_id+1);

		/*Data for the table `groups` */
		# We re-create the first groups that we need to control access and visibility to this product/unit and the bugs/cases in this products/unit
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
			# The group for the creator of the unit.
			(@creator_group_id,CONCAT (@unit,' #',@product_id,' - Creator'), CONCAT('Unit creator (or it\'s representative) for ', @unit),1,'',1,NULL),
			# group to list the users who are this type of stakeholder in this unit
			# we need to add the product_id here as the group names must be unique.
			# We don't have to worry too much about the length of group names: type is varchar(255)
			(@visibility_case_group_id,CONCAT(@unit,' #',@product_id,' - ', @stakeholder,' - Created by: ',@creator_pub_name),@visibility_explanation,1,'',1,NULL),
			# group to list the users who are stakeholders in this unit
			(@list_user_group_id,CONCAT(@unit,' #',@product_id,' - list stakeholder'),'List all the users which are stakeholders for this unit',1,'',0,NULL),
			# group to see the users who are stakeholders in this unit
			(@see_user_group_id,CONCAT(@unit,' #',@product_id,' - see stakeholder'),'Can see all the users which are stakeholders for this unit',1,'',0,NULL),
			# We now need to create the groups that grant permissions for the flags for this unit
			(@g_group_next_step,CONCAT(@unit,' #',@product_id,' - GA Next Step'),'Grant approval for the Next step in a case',1,'',0,NULL),
			(@r_group_next_step,CONCAT(@unit,' #',@product_id,' - RA Next Step'),'Request approval for the Next step in a case',1,'',0,NULL),
			(@g_group_solution,CONCAT(@unit,' #',@product_id,' - GA Solution'),'Grant approval for the Solution in a case',1,'',0,NULL),
			(@r_group_solution,CONCAT(@unit,' #',@product_id,' - RA Solution'),'Request approval for the Solution in a case',1,'',0,NULL),
			(@g_group_budget,CONCAT(@unit,' #',@product_id,' - GA Budget'),'Request approval for the Budget in a case',1,'',0,NULL),
			(@r_group_budget,CONCAT(@unit,' #',@product_id,' - RA Budget'),'Request approval for the Budget in a case',1,'',0,NULL),
			(@g_group_attachment,CONCAT(@unit,' #',@product_id,' - GA Attachment'),'Grant approval for an Attachment in a case',1,'',0,NULL),
			(@r_group_attachment,CONCAT(@unit,' #',@product_id,' - RA Attachment'),'Request approval for an Attachment in a case',1,'',0,NULL),
			(@g_group_OK_to_pay,CONCAT(@unit,' #',@product_id,' - GA OK to Pay'),'Grant approval to pay (for a bill/attachment)',1,'',0,NULL),
			(@r_group_OK_to_pay,CONCAT(@unit,' #',@product_id,' - RA OK to Pay'),'Request approval to pay (for a bill/attachment)',1,'',0,NULL),
			(@g_group_is_paid,CONCAT(@unit,' #',@product_id,' - GA is Paid'),'Confirm that it\'s paid (for a bill/attachment)',1,'',0,NULL),
			(@r_group_is_paid,CONCAT(@unit,' #',@product_id,' - RA is Paid'),'Ask if it\'s paid (for a bill/attachment)',1,'',0,NULL),
			# Last we create a group to group all the mandatory group when a user has a role in a unit
			(@all_unit_privileges_group_id,CONCAT(@unit,' #',@product_id,' - Stakeholder'),'Access to All the groups a stakeholder needs for this unit',1,'',0,NULL);

		# THIS IS NOT A BZ INITIATED ACTION!
		# We insert information into the table which maps groups to products/component
		# This is so that it is easy in the future to identify all the groups that have
		# already been created for a given product.
		# We will need this as in some scenario when we add a user to a role in an existing product/unit
		# we don't need to re-create the group, just grant the new user access to the group.
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
			# 1 = Creator
			(@product_id,@creator_group_id,1,@role_type_id,@timestamp),
			# 2 = Access to case
			(@product_id,@visibility_case_group_id,2,@role_type_id,@timestamp),
			# 4 = list_stakeholder
			(@product_id,@list_user_group_id,4,@role_type_id,@timestamp),
			# 5 = see_stakeholder
			(@product_id,@see_user_group_id,5,@role_type_id,@timestamp),
			# 6 = r_a_case_next_step
			(@product_id,@r_group_next_step,6,@role_type_id,@timestamp),
			# 7 = g_a_case_next_step
			(@product_id,@g_group_next_step,7,@role_type_id,@timestamp),
			# 8 = r_a_case_solution
			(@product_id,@r_group_solution,8,@role_type_id,@timestamp),
			# 9 = g_a_case_solution
			(@product_id,@g_group_solution,9,@role_type_id,@timestamp),
			# 10 = r_a_case_budget
			(@product_id,@r_group_budget,10,@role_type_id,@timestamp),
			# 11 = g_a_case_budget
			(@product_id,@g_group_budget,11,@role_type_id,@timestamp),
			# 12 = r_a_attachment_approve
			(@product_id,@r_group_attachment,12,@role_type_id,@timestamp),
			# 13 = g_a_attachment_approve
			(@product_id,@g_group_attachment,13,@role_type_id,@timestamp),
			# 14 = r_a_attachment_ok_to_pay
			(@product_id,@r_group_OK_to_pay,14,@role_type_id,@timestamp),
			# 15 = g_a_attachment_ok_to_pay
			(@product_id,@g_group_OK_to_pay,15,@role_type_id,@timestamp),
			# 16 = r_a_attachment_is_paid
			(@product_id,@r_group_is_paid,16,@role_type_id,@timestamp),
			# 17 = g_a_attachment_is_paid
			(@product_id,@g_group_is_paid,17,@role_type_id,@timestamp),
			# 18 = unit_specific
			(@product_id,@all_unit_privileges_group_id,18,@role_type_id,@timestamp);


		/*Data for the table `user_group_map` */
		# We add the BZ user to the groups we have just created
		INSERT  INTO `user_group_map`
			(`user_id`
			,`group_id`
			,`isbless`
			,`grant_type`
			) 
			VALUES 
			# we grant the User Access to all the default permission for the unit - This include the Flags
			(@bz_user_id,@all_unit_privileges_group_id,0,0),
			# user is the creator of the unit
			(@bz_user_id,@creator_group_id,0,0),
			# user is a member of the specific `stakholder` group for his role
			(@bz_user_id,@visibility_case_group_id,0,0),
			#user is visible in the list of stakeholder for this unit
			(@bz_user_id,@list_user_group_id,0,0),
			# user can see the users in the list of stakeholder for this unit
			(@bz_user_id,@see_user_group_id,0,0);

		/*Data for the table `group_group_map` */
		
		# We need to delete all the records where any of the group_id we have just created are present!

			# The Creator Group it can do everyting in all products
			# This is NOT needed once we are in production
				DELETE FROM `group_group_map` WHERE `member_id` =1 AND `grantor_id` =@creator_group_id;
			# This would be a llllllong list of users once we are in prod!!!
			# we will inactivate that when in production.
				DELETE FROM `group_group_map` WHERE `member_id` =1 AND `grantor_id` =@see_user_group_id;
			# Can decided if a user is a creator of a unit
				DELETE FROM `group_group_map` WHERE `member_id` =1 AND `grantor_id` =@creator_group_id;
			# Decides if a user is a member of a specific role or not.
				DELETE FROM `group_group_map` WHERE `member_id` =1 AND `grantor_id` =@visibility_case_group_id;
			# Decide if a user is visible in the drop down list for this product
				DELETE FROM `group_group_map` WHERE `member_id` =1 AND `grantor_id` =@list_user_group_id;
			# Decide if users can see the list of visible users(not the hidden one) or not.
				DELETE FROM `group_group_map` WHERE `member_id` =1 AND `grantor_id` =@see_user_group_id;
				DELETE FROM `group_group_map` WHERE `member_id` =1 AND `grantor_id` =@r_group_next_step;
				DELETE FROM `group_group_map` WHERE `member_id` =1 AND `grantor_id` =@g_group_next_step;
				DELETE FROM `group_group_map` WHERE `member_id` =1 AND `grantor_id` =@r_group_solution;
				DELETE FROM `group_group_map` WHERE `member_id` =1 AND `grantor_id` =@g_group_solution;
				DELETE FROM `group_group_map` WHERE `member_id` =1 AND `grantor_id` =@r_group_budget;
				DELETE FROM `group_group_map` WHERE `member_id` =1 AND `grantor_id` =@g_group_budget;
				DELETE FROM `group_group_map` WHERE `member_id` =1 AND `grantor_id` =@r_group_attachment;
				DELETE FROM `group_group_map` WHERE `member_id` =1 AND `grantor_id` =@g_group_attachment;
				DELETE FROM `group_group_map` WHERE `member_id` =1 AND `grantor_id` =@r_group_OK_to_pay;
				DELETE FROM `group_group_map` WHERE `member_id` =1 AND `grantor_id` =@g_group_OK_to_pay;
				DELETE FROM `group_group_map` WHERE `member_id` =1 AND `grantor_id` =@r_group_is_paid;
				DELETE FROM `group_group_map` WHERE `member_id` =1 AND `grantor_id` =@g_group_is_paid;
			# Decide if a user is a Stakeholder or has a role in a unit.
			# This is a group of group which grants membership to several other groups.
				DELETE FROM `group_group_map` WHERE `member_id` =1 AND `grantor_id` =@all_unit_privileges_group_id;
			# This is NOT needed once we are in production
				DELETE FROM `group_group_map` WHERE `member_id` =1 AND `grantor_id` =@creator_group_id;
			# This is NOT needed once we are in production
				DELETE FROM `group_group_map` WHERE `member_id` =1 AND `grantor_id` =@all_unit_privileges_group_id;
			# Can decided if a user is a creator of a unit
				DELETE FROM `group_group_map` WHERE `member_id` =@creator_group_id AND `grantor_id` =@creator_group_id;
			# This is necessary so that the creator can create other user with similar roles
				DELETE FROM `group_group_map` WHERE `member_id` =@creator_group_id AND `grantor_id` =@visibility_case_group_id;
			# This is necessary so that the creator can create other user.
				DELETE FROM `group_group_map` WHERE `member_id` =@creator_group_id AND `grantor_id` =@list_user_group_id;
			# This is necessary so that the creator can create other user.
				DELETE FROM `group_group_map` WHERE `member_id` =@creator_group_id AND `grantor_id` =@see_user_group_id;
			# This is necessary so that the creator can create other user.
				DELETE FROM `group_group_map` WHERE `member_id` =@creator_group_id AND `grantor_id` =@all_unit_privileges_group_id;
			# See all the users in the list of visible user for this product
			# This is needed
				DELETE FROM `group_group_map` WHERE `member_id` =@creator_group_id AND `grantor_id` =@list_user_group_id;
			# This is necessary so that the creator can create other user with similar roles
				DELETE FROM `group_group_map` WHERE `member_id` =@visibility_case_group_id AND `grantor_id` =@visibility_case_group_id;
			# This is necessary so that the creator can create other user.
				DELETE FROM `group_group_map` WHERE `member_id` =@visibility_case_group_id AND `grantor_id` =@list_user_group_id;
			# This is necessary so that the creator can create other user.
				DELETE FROM `group_group_map` WHERE `member_id` =@visibility_case_group_id AND `grantor_id` =@see_user_group_id;
			# This is necessary so that the user can create other user.
				DELETE FROM `group_group_map` WHERE `member_id` =@visibility_case_group_id AND `grantor_id` =@all_unit_privileges_group_id;
			# See all user that have the same role in the unit
				DELETE FROM `group_group_map` WHERE `member_id` =@visibility_case_group_id AND `grantor_id` =@visibility_case_group_id;
				DELETE FROM `group_group_map` WHERE `member_id` =@visibility_case_group_id AND `grantor_id` =@list_user_group_id;
			#  1- see list of visible user
			#  2- still be hidden from other users (scenario with generic users)
				DELETE FROM `group_group_map` WHERE `member_id` =@see_user_group_id AND `grantor_id` =@list_user_group_id;
			# syst_see_timetracking 
				DELETE FROM `group_group_map` WHERE `member_id` =@all_unit_privileges_group_id AND `grantor_id` =16;
			# syst_create_shared_quotes
				DELETE FROM `group_group_map` WHERE `member_id` =@all_unit_privileges_group_id AND `grantor_id` =17;
			#syst_tag_comments
				DELETE FROM `group_group_map` WHERE `member_id` =@all_unit_privileges_group_id AND `grantor_id` =18;
			# all the Flags group for this product		
				DELETE FROM `group_group_map` WHERE `member_id` =@all_unit_privileges_group_id AND `grantor_id` =@r_group_next_step;
				DELETE FROM `group_group_map` WHERE `member_id` =@all_unit_privileges_group_id AND `grantor_id` =@g_group_next_step;
				DELETE FROM `group_group_map` WHERE `member_id` =@all_unit_privileges_group_id AND `grantor_id` =@r_group_solution;
				DELETE FROM `group_group_map` WHERE `member_id` =@all_unit_privileges_group_id AND `grantor_id` =@g_group_solution;
				DELETE FROM `group_group_map` WHERE `member_id` =@all_unit_privileges_group_id AND `grantor_id` =@r_group_budget;
				DELETE FROM `group_group_map` WHERE `member_id` =@all_unit_privileges_group_id AND `grantor_id` =@g_group_budget;
				DELETE FROM `group_group_map` WHERE `member_id` =@all_unit_privileges_group_id AND `grantor_id` =@r_group_attachment;
				DELETE FROM `group_group_map` WHERE `member_id` =@all_unit_privileges_group_id AND `grantor_id` =@g_group_attachment;
				DELETE FROM `group_group_map` WHERE `member_id` =@all_unit_privileges_group_id AND `grantor_id` =@r_group_OK_to_pay;
				DELETE FROM `group_group_map` WHERE `member_id` =@all_unit_privileges_group_id AND `grantor_id` =@g_group_OK_to_pay;
				DELETE FROM `group_group_map` WHERE `member_id` =@all_unit_privileges_group_id AND `grantor_id` =@r_group_is_paid;
				DELETE FROM `group_group_map` WHERE `member_id` =@all_unit_privileges_group_id AND `grantor_id` =@g_group_is_paid;

		# We insert the group map information for this
		INSERT  INTO `group_group_map`
			(`member_id`
			,`grantor_id`
			,`grant_type`
			) 
			VALUES 
			# If you are a member of group_id 1 (Admin) 
			# then you have the following permissions:
			# 	- 0: You are automatically a member of
			#	- 1: You can grant access to
			#	- 2: You can see users in
			#  group ZZZ
			# 
			# Methodology:
			# We list all the possible options here and comment these out if they are not needed
	
			/* REMINDER		
			# We have created the following groups:
			# for the product creator
				@creator_group_id
			# group to grant visibility to this type of role/stakeholder
				@visibility_case_group_id
			# List all the user that are visible in the drop down list
				@list_user_group_id
			# Group to see the list of visible users for this unit
				@see_user_group_id
			# These are the groups to grant/request flags for this product/unit
				@g_group_next_step
				@r_group_next_step
				@g_group_solution
				@r_group_solution
				@g_group_budget
				@r_group_budget
				@g_group_attachment
				@r_group_attachment
				@g_group_OK_to_pay
				@r_group_OK_to_pay
				@g_group_is_paid
				@r_group_is_paid
			# a Group of groups to facilitate user management all the user in this unit belong there.
				@all_unit_privileges_group_id
			*/
			
			# First we look at the admin group
	
				# Privilege #0:
				# All the users in the Group XXX are automatically a member of group YYY
				# The group 1 `Admin` has privilege #0 for the group:
					# The Creator Group it can do everyting in all products
						# This is NOT needed once we are in production
						(1,@creator_group_id,0),
					# Permission to create/see a case in the unit
					# This is not needed, Admin is not in any role
						# (1,@visibility_case_group_id,0),
					# Is in the list of all the user that are visible in the drop down list for this product
					# This is not needed, Admin is not in any role
						# (1,@list_user_group_id,0),
					# You can see all the users visible for this product (not the hidden one).
						# This would be a llllllong list of users once we are in prod!!!
						# we will inactivate that when in production.
						(1,@see_user_group_id,0),
					# All the Flags groups for this product
					# Admin don't need to be in these groups:
					# This will make user in the Admin group visible in the list of flag approvers!
					# This is tricky as we are bunching up all the users in these group in the Stakeholder group anyway:
					# As of today no user is directly a member of any of these groups
						#(1,@r_group_next_step,0),
						#(1,@g_group_next_step,0),
						#(1,@r_group_solution,0),
						#(1,@g_group_solution,0),
						#(1,@r_group_budget,0),
						#(1,@g_group_budget,0),
						#(1,@r_group_attachment,0),
						#(1,@g_group_attachment,0),
						#(1,@r_group_OK_to_pay,0),
						#(1,@g_group_OK_to_pay,0),
						#(1,@r_group_is_paid,0),
						#(1,@g_group_is_paid,0),
					# A Group of groups to facilitate user management all the user in this unit belong there.
					# This is not needed as Admin don't need to be visible here either
						#(1,@all_unit_privileges_group_id,0),
					
				# Privilege #1:
				# All the users in the Group XXX can grant access so that a user can be put in group YYY
				# The group 1 `Admin` has Permission #1 for:
					# Can decided if a user is a creator of a unit
						(1,@creator_group_id,1),
					# Decides if a user is a member of a specific role or not.
						(1,@visibility_case_group_id,1),
					# Decide if a user is visible in the drop down list for this product
						(1,@list_user_group_id,1),
					# Decide if users can see the list of visible users(not the hidden one) or not.
						(1,@see_user_group_id,1),
					# Decide if a user can set Flags or not for this product
					# This is tricky as we are bunching up all the users in these group in the Stakeholder group anyway:
					# As of today no user is directly a member of any of these groups
					# Let's keep this anyway for Admin just in case...
						(1,@r_group_next_step,1),
						(1,@g_group_next_step,1),
						(1,@r_group_solution,1),
						(1,@g_group_solution,1),
						(1,@r_group_budget,1),
						(1,@g_group_budget,1),
						(1,@r_group_attachment,1),
						(1,@g_group_attachment,1),
						(1,@r_group_OK_to_pay,1),
						(1,@g_group_OK_to_pay,1),
						(1,@r_group_is_paid,1),
						(1,@g_group_is_paid,1),
					# Decide if a user is a Stakeholder or has a role in a unit.
					# This is a group of group which grants membership to several other groups.
						(1,@all_unit_privileges_group_id,1),
	
				# Privilege #2: 
				# All the users in the Group XXX can see the users in the group YYY
				# The group 1 `Admin` has Permission #2 to:
					# See all the users that are creators
						# This is NOT needed once we are in production
						(1,@creator_group_id,2),
					# See all user that have the same role in the unit
						# This is not needed, Admin is not in any role
						# (1,@visibility_case_group_id,2),
					# See all the users in the list of visible user for this product
						# This is not needed, Admin has other way to see these users
						# (1,@list_user_group_id,2),
					# See the list of user that can see the list of visible users for this product (not the hidden one).
						# This is not needed, Admin has other way to see these users
						#(1,@see_user_group_id,2),
	
					# See all the users that have been granted flag permission for this product
						# This is not needed, Admin has other way to see these users
						# This is tricky as we are bunching up all the users in these group in the Stakeholder group any way:
						# As of today no user is directly a member of any of these groups
						# This will make user in the Admin group visible in the list of flag approvers!	
						#(1,@r_group_next_step,2),
						#(1,@g_group_next_step,2),
						#(1,@r_group_solution,2),
						#(1,@g_group_solution,2),
						#(1,@r_group_budget,2),
						#(1,@g_group_budget,2),
						#(1,@r_group_attachment,2),
						#(1,@g_group_attachment,2),
						#(1,@r_group_OK_to_pay,2),
						#(1,@g_group_OK_to_pay,2),
						#(1,@r_group_is_paid,2),
						#(1,@g_group_is_paid,2),
	
					# See all the users in the Group of groups to facilitate user management all the user in this unit belong there.
					# these are ALL the users that have access to this product/unit.
						# This is NOT needed once we are in production
						(1,@all_unit_privileges_group_id,2),
			
			# We then look at the group @creator_group_id
					
				# Privilege #0:
				# All the users in the Group XXX are automatically a member of group YYY
				# The group has privilege #0 for the group:
					# Member of the Creator Group: it can do everyting in all products
						# Irrelevant - group is a member of itself anyway...
						#(@creator_group_id,@creator_group_id,0),
					# Member of the group Permission to create/see a case in the unit
						# Irrelevant - we do this at the user level - doing this at the group level is dangerous
						#(@creator_group_id,@visibility_case_group_id,0),
					# Member of the group that list of all the user that are visible in the drop down list for this product
						# Irrelevant - we do this at the user level - doing this at the group level is dangerous
						#(@creator_group_id,@list_user_group_id,0),
					# Member of the group that sees all the users visible for this product (not the hidden one).
						# Irrelevant - we do this at the user level - doing this at the group level is dangerous
						#(@creator_group_id,@see_user_group_id,0),
					# Member of all the Flags groups for this product
					# This is tricky as we are bunching up all the users in these group in the Stakeholder group anyway:
					# As of today no user is directly a member of any of these groups
						# Irrelevant - we do this at the user level - doing this at the group level is dangerous
						#(@creator_group_id,@r_group_next_step,0),
						#(@creator_group_id,@g_group_next_step,0),
						#(@creator_group_id,@r_group_solution,0),
						#(@creator_group_id,@g_group_solution,0),
						#(@creator_group_id,@r_group_budget,0),
						#(@creator_group_id,@g_group_budget,0),
						#(@creator_group_id,@r_group_attachment,0),
						#(@creator_group_id,@g_group_attachment,0),
						#(@creator_group_id,@r_group_OK_to_pay,0),
						#(@creator_group_id,@g_group_OK_to_pay,0),
						#(@creator_group_id,@r_group_is_paid,0),
						#(@creator_group_id,@g_group_is_paid,0),
					# Member of the group of groups that facilitate user management all the user in this unit belong there.
						# Irrelevant - we do this at the user level - doing this at the group level is dangerous
						#(@creator_group_id,@all_unit_privileges_group_id,0),
					
				# Privilege #1:
				# All the users in the Group XXX can grant access so that a user can be put in group YYY
				# The group 1 `Admin` has Permission #1 for:
					# Can decided if a user is a creator of a unit
						(@creator_group_id,@creator_group_id,1),
					# Decides if a user is a member of a specific role or not.
						# This is necessary so that the creator can create other user with similar roles
						(@creator_group_id,@visibility_case_group_id,1),
					# Decide if a user is visible in the drop down list for this product
						# This is necessary so that the creator can create other user.
						(@creator_group_id,@list_user_group_id,1),
					# Decide if users can see the list of visible users(not the hidden one) or not.
						# This is necessary so that the creator can create other user.
						(@creator_group_id,@see_user_group_id,1),
					# Decide if a user can set Flags or not for this product
					# This is tricky as we are bunching up all the users in these group in the Stakeholder group anyway:
					# As of today no user is directly a member of any of these groups
						# This is irrelevant
						#(@creator_group_id,@r_group_next_step,1),
						#(@creator_group_id,@g_group_next_step,1),
						#(@creator_group_id,@r_group_solution,1),
						#(@creator_group_id,@g_group_solution,1),
						#(@creator_group_id,@r_group_budget,1),
						#(@creator_group_id,@g_group_budget,1),
						#(@creator_group_id,@r_group_attachment,1),
						#(@creator_group_id,@g_group_attachment,1),
						#(@creator_group_id,@r_group_OK_to_pay,1),
						#(@creator_group_id,@g_group_OK_to_pay,1),
						#(@creator_group_id,@r_group_is_paid,1),
						#(@creator_group_id,@g_group_is_paid,1),
					# Decide if a user is a Stakeholder or has a role in a unit.
					# This is a group of group which grants membership to several other groups.
						# This is necessary so that the creator can create other user.
						(@creator_group_id,@all_unit_privileges_group_id,1),
	
				# Privilege #2: 
				# All the users in the Group @creator_group_id can see the users in the group YYY
				# The group @creator_group_id has Permission #2 to:
					# See all the users that are creators
						#(@creator_group_id,@creator_group_id,2),
					# See all user that have the same role in the unit
						#(@creator_group_id,@visibility_case_group_id,2),
					# See all the users in the list of visible user for this product
						# This is needed
						(@creator_group_id,@list_user_group_id,2),
					# See the list of user that can see the list of visible users for this product (not the hidden one).
						# This is not needed, we have another way to see these users (see right above)
						#(@creator_group_id,@see_user_group_id,2),
	
					# See all the users that have been granted flag permission for this product
						# This is NOT needed as this will make visible users that are NOT in the list of visible users...
						#(@creator_group_id,@r_group_next_step,2),
						#(@creator_group_id,@g_group_next_step,2),
						#(@creator_group_id,@r_group_solution,2),
						#(@creator_group_id,@g_group_solution,2),
						#(@creator_group_id,@r_group_budget,2),
						#(@creator_group_id,@g_group_budget,2),
						#(@creator_group_id,@r_group_attachment,2),
						#(@creator_group_id,@g_group_attachment,2),
						#(@creator_group_id,@r_group_OK_to_pay,2),
						#(@creator_group_id,@g_group_OK_to_pay,2),
						#(@creator_group_id,@r_group_is_paid,2),
						#(@creator_group_id,@g_group_is_paid,2),
	
					# See all the users in the Group of groups to facilitate user management all the user in this unit belong there.
					# these are ALL the users that have access to this product/unit.
						# This is NOT needed as this will make visible users that are NOT in the list of visible users...
						#(@creator_group_id,@all_unit_privileges_group_id,2),
	
			# We then look at the group @visibility_case_group_id
			# This is a group to 
			#	- allow access to a product/unit
			#	- Create new stakholdres that have the same role as the user creating them
			#	- Allow/restrict visibility on cases
					
				# Privilege #0:
				# All the users in the Group @visibility_case_group_id are automatically a member of group YYY
				# The group has privilege #0 for the groups:
					# NONE
					
				# Privilege #1:
				# All the users in the Group XXX can grant access so that a user can be put in group YYY
				# The group 1 `Admin` has Permission #1 for:
					# Can decided if a user is a creator of a unit
						#(@visibility_case_group_id,@creator_group_id,1),
					# Decides if a user is a member of a specific role or not.
						# This is necessary so that the creator can create other user with similar roles
						(@visibility_case_group_id,@visibility_case_group_id,1),
					# Decide if a user is visible in the drop down list for this product
						# This is necessary so that the creator can create other user.
						(@visibility_case_group_id,@list_user_group_id,1),
					# Decide if users can see the list of visible users(not the hidden one) or not.
						# This is necessary so that the creator can create other user.
						(@visibility_case_group_id,@see_user_group_id,1),
					# Decide if a user can set Flags or not for this product
					# This is tricky as we are bunching up all the users in these group in the Stakeholder group anyway:
					# As of today no user is directly a member of any of these groups
						# This is irrelevant - we do this at the user level
						#(@visibility_case_group_id,@r_group_next_step,1),
						#(@visibility_case_group_id,@g_group_next_step,1),
						#(@visibility_case_group_id,@r_group_solution,1),
						#(@visibility_case_group_id,@g_group_solution,1),
						#(@visibility_case_group_id,@r_group_budget,1),
						#(@visibility_case_group_id,@g_group_budget,1),
						#(@visibility_case_group_id,@r_group_attachment,1),
						#(@visibility_case_group_id,@g_group_attachment,1),
						#(@visibility_case_group_id,@r_group_OK_to_pay,1),
						#(@visibility_case_group_id,@g_group_OK_to_pay,1),
						#(@visibility_case_group_id,@r_group_is_paid,1),
						#(@visibility_case_group_id,@g_group_is_paid,1),
					# Decide if a user is a Stakeholder or has a role in a unit.
					# This is a group of group which grants membership to several other groups.
						# This is necessary so that the user can create other user.
						(@visibility_case_group_id,@all_unit_privileges_group_id,1),
	
				# Privilege #2: 
				# All the users in the Group @creator_group_id can see the users in the group YYY
				# The group @creator_group_id has Permission #2 to:
					# See all the users that are creators
						#(@visibility_case_group_id,@creator_group_id,2),
					# See all user that have the same role in the unit
						(@visibility_case_group_id,@visibility_case_group_id,2),
					# See all the users in the list of visible user for this product
						# This is needed
						(@visibility_case_group_id,@list_user_group_id,2),
					# See the list of user that can see the list of visible users for this product (not the hidden one).
						# This is not needed, we have another way to see these users (see right above)
						#(@visibility_case_group_id,@see_user_group_id,2),
	
					# See all the users that have been granted flag permission for this product
						# This is NOT needed as this will make visible users that are NOT in the list of visible users...
						#(@visibility_case_group_id,@r_group_next_step,2),
						#(@visibility_case_group_id,@g_group_next_step,2),
						#(@visibility_case_group_id,@r_group_solution,2),
						#(@visibility_case_group_id,@g_group_solution,2),
						#(@visibility_case_group_id,@r_group_budget,2),
						#(@visibility_case_group_id,@g_group_budget,2),
						#(@visibility_case_group_id,@r_group_attachment,2),
						#(@visibility_case_group_id,@g_group_attachment,2),
						#(@visibility_case_group_id,@r_group_OK_to_pay,2),
						#(@visibility_case_group_id,@g_group_OK_to_pay,2),
						#(@visibility_case_group_id,@r_group_is_paid,2),
						#(@visibility_case_group_id,@g_group_is_paid,2),
	
					# See all the users in the Group of groups to facilitate user management all the user in this unit belong there.
					# these are ALL the users that have access to this product/unit.
						# This is NOT needed as this will make visible users that are NOT in the list of visible users...
						#(@visibility_case_group_id,@all_unit_privileges_group_id,2),
					
			# We then look at the group @list_user_group_id
				# Nothing to do here - This group is only used for user, NOT for groups
				# Permissions to be in this group are granted other groups: The group that allow to add or modify stakeholders!
				
			# We then look at the group @see_user_group_id
					
				# Privilege #2: 
				# All the users in the Group @see_user_group_id can see the users in the group YYY
				# The group @see_user_group_id has Permission #2 to:
					# See all the users in the list of visible user for this product
					# This is is the ONLY reason why this group exists...
						#  1- see list of visible user
						#  2- still be hidden from other users (scenario with generic users)
						(@see_user_group_id,@list_user_group_id,2),
						
			# Ok let's move to the flags group:
				# 	@g_group_next_step
				#	@r_group_next_step
				#	@g_group_solution
				#	@r_group_solution
				#	@g_group_budget
				#	@r_group_budget
				#	@g_group_attachment
				#	@r_group_attachment
				#	@g_group_OK_to_pay
				#	@r_group_OK_to_pay
				#	@g_group_is_paid
				#	@r_group_is_paid
				#
				#
				# Nothing to do here - This group is only used for user, NOT for groups
				# Permissions to be in this group are granted to other groups: The group that allow to add or modify stakeholders!
	
			# We then look at the group @all_unit_privileges_group_id
			# This is a group to 
			#	- Give access to all the group that a user needs for this unit
			#
					
				# Privilege #0:
				# All the users in the Group @all_unit_privileges_group_id are automatically a member of group YYY
				# The group has privilege #0 for the groups:
					# This is the only reason why this group exists
						# syst_see_timetracking 
						(@all_unit_privileges_group_id,16,0),
						# syst_create_shared_quotes
						(@all_unit_privileges_group_id,17,0),
						#syst_tag_comments
						(@all_unit_privileges_group_id,18,0),
						# all the Flags group for this product		
						(@all_unit_privileges_group_id,@r_group_next_step,0),
						(@all_unit_privileges_group_id,@g_group_next_step,0),
						(@all_unit_privileges_group_id,@r_group_solution,0),
						(@all_unit_privileges_group_id,@g_group_solution,0),
						(@all_unit_privileges_group_id,@r_group_budget,0),
						(@all_unit_privileges_group_id,@g_group_budget,0),
						(@all_unit_privileges_group_id,@r_group_attachment,0),
						(@all_unit_privileges_group_id,@g_group_attachment,0),
						(@all_unit_privileges_group_id,@r_group_OK_to_pay,0),
						(@all_unit_privileges_group_id,@g_group_OK_to_pay,0),
						(@all_unit_privileges_group_id,@r_group_is_paid,0),
						(@all_unit_privileges_group_id,@g_group_is_paid,0);
					
				# Privilege #1:
				# All the users in the Group XXX can grant access so that a user can be put in group YYY
				# The group @all_unit_privileges_group_id has Permission #1 for:
					# NO OTHER GROUP - Users that are allow to grant this group membership are either creator or stakeholders.
	
				# Privilege #2: 
				# All the users in the Group @creator_group_id can see the users in the group YYY
				# The group @creator_group_id has Permission #2 to:
					# NONE - This is NOT a user visibility group


		/*Data for the table `group_control_map` */
		# This is where we decide who can access which products.
		INSERT  INTO `group_control_map`
			(`group_id`
			,`product_id`
			,`entry`
			# it is unclear which id this is: user_id? product_id? other?
			# in order to validate that we need to 
			#  1- re-create a 2nd product from scratch as the same user in the same classification
			#	if id is the same, this is NOT the product_id, it's something else
			#	DONE- membercontrol id is the SAME (2)
			#  2- re-create a 4th product from scratch as the same user in the same classification with a different default assignee.
			# 	if id is the same then this is not the default assignee, it's something else
			#	DONE- membercontrol id is the SAME (2)
			# Membercontrol refers to the access rights and permissions...
			# 0 is NA
			# 1 is SHOWN
			# 2 is DEFAULT
			# 3 is MANDATORY
			# We will revisit this once we zoom in on the permissions issues...
			,`membercontrol`
			# othercontrol refers to the access rights...
			# 0 is NA
			# 1 is SHOWN
			# 2 is DEFAULT
			# 3 is MANDATORY
			# We will revisit this once we zoom in on the permissions issues...
			,`othercontrol`
			,`canedit`
			,`editcomponents`
			,`editbugs`
			,`canconfirm`
			) 
			VALUES 
			# editcomponents is needed so that the creator can create new users in this product
			(@creator_group_id,@product_id,1,3,3,0,1,1,1),
	# NEED TO TEST WITH API
			# editcomponents might be needed so that the user can create add new users in this product
			(@visibility_case_group_id,@product_id,1,1,3,0,0,1,1);

	# We create and configure the generic flags we need.
		# First we remove the flags which have been created as part of the blank install
		DELETE FROM `flagtypes` WHERE `id`<7;

		# get the id for the flagtypes we need
			SET @flag_next_step = 1;
			SET @flag_solution = (@flag_next_step+1);
			SET @flag_budget = (@flag_solution+1);
			SET @flag_attachment = (@flag_budget+1);
			SET @flag_ok_to_pay = (@flag_attachment+1);
			SET @flag_is_paid = (@flag_ok_to_pay+1);
	
		/*Data for the table `flagtypes` */
		# We insert the flagtype for the initial unit again
			INSERT  INTO `flagtypes`
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
				(@flag_next_step,CONCAT(@unit_for_flag,'_Next_Step'),'Approval for the Next Step of the case.','','b',1,1,1,1,10,@g_group_next_step,@r_group_next_step),
				(@flag_solution,CONCAT(@unit_for_flag,'_Solution'),'Approval for the Solution of this case.','','b',1,1,1,1,20,@g_group_solution,@r_group_solution),
				(@flag_budget,CONCAT(@unit_for_flag,'_Budget'),'Approval for the Budget for this case.','','b',1,1,1,1,30,@g_group_budget,@r_group_budget),
				(@flag_attachment,CONCAT(@unit_for_flag,'_Attachment'),'Approval for this Attachment.','','a',1,1,1,1,10,@g_group_attachment,@r_group_attachment),
				(@flag_ok_to_pay,CONCAT(@unit_for_flag,'_OK_to_pay'),'Approval to pay this bill.','','a',1,1,1,1,20,@g_group_OK_to_pay,@r_group_OK_to_pay),
				(@flag_is_paid,CONCAT(@unit_for_flag,'_is_paid'),'Confirm if this bill has been paid.','','a',1,1,1,1,30,@g_group_is_paid,@r_group_is_paid);
	
		/*Data for the table `flaginclusions` */
		# This limits the flags to this product/unit: this is important so that only users with 
		# a role in that unit can request or grant approvals in that unit.
			INSERT  INTO `flaginclusions`
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
			(3,CONCAT(@unit,'_#',@product_id));

		# We need to know the value of the other series category we need.
		SET @series_2 = (SELECT `id` FROM `series_categories` WHERE `name` = '-All-');
		SET @series_1 = (SELECT `id` FROM `series_categories` WHERE `name` = CONCAT(@stakeholder,'_#',@product_id));
		SET @series_3 = (SELECT `id` FROM `series_categories` WHERE `name` = CONCAT(@unit,'_#',@product_id));

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
		(@bz_user_id,'Bugzilla::Component',@component_id,'__create__',NULL,@stakeholder,@timestamp),
		(@bz_user_id,'Bugzilla::Group',@creator_group_id,'__create__',NULL,CONCAT(@unit,' #',@product_id,' - Creator'),@timestamp),
		(@bz_user_id,'Bugzilla::Group',@visibility_case_group_id,'__create__',NULL,CONCAT(@unit,' #',@product_id,' - ', @stakeholder,' - Created by: ',@creator_pub_name),@timestamp),
		(@bz_user_id,'Bugzilla::Group',@list_user_group_id,'__create__',NULL,CONCAT(@unit,' #',@product_id,' - list stakeholder'),@timestamp),
		(@bz_user_id,'Bugzilla::Group',@see_user_group_id,'__create__',NULL,CONCAT(@unit,' #',@product_id,' - see stakeholders'),@timestamp),
		(@bz_user_id,'Bugzilla::Group',@g_group_next_step,'__create__',NULL,CONCAT(@unit,' #',@product_id,' - GA Next Step'),@timestamp),
		(@bz_user_id,'Bugzilla::Group',@r_group_next_step,'__create__',NULL,CONCAT(@unit,' #',@product_id,' - RA Next Step'),@timestamp),
		(@bz_user_id,'Bugzilla::Group',@g_group_solution,'__create__',NULL,CONCAT(@unit,' #',@product_id,' - GA Solution'),@timestamp),
		(@bz_user_id,'Bugzilla::Group',@r_group_solution,'__create__',NULL,CONCAT(@unit,' #',@product_id,' - RA Solution'),@timestamp),
		(@bz_user_id,'Bugzilla::Group',@g_group_budget,'__create__',NULL,CONCAT(@unit,' #',@product_id,' - GA Budget'),@timestamp),
		(@bz_user_id,'Bugzilla::Group',@r_group_budget,'__create__',NULL,CONCAT(@unit,' #',@product_id,' - RA Budget'),@timestamp),
		(@bz_user_id,'Bugzilla::Group',@g_group_attachment,'__create__',NULL,CONCAT(@unit,' #',@product_id,' - GA Attachment'),@timestamp),
		(@bz_user_id,'Bugzilla::Group',@r_group_attachment,'__create__',NULL,CONCAT(@unit,' #',@product_id,' - RA Attachment'),@timestamp),
		(@bz_user_id,'Bugzilla::Group',@g_group_OK_to_pay,'__create__',NULL,CONCAT(@unit,' #',@product_id,' - GA OK to Pay'),@timestamp),
		(@bz_user_id,'Bugzilla::Group',@r_group_OK_to_pay,'__create__',NULL,CONCAT(@unit,' #',@product_id,' - RA OK to Pay'),@timestamp),
		(@bz_user_id,'Bugzilla::Group',@g_group_is_paid,'__create__',NULL,CONCAT(@unit,' #',@product_id,' - GA is Paid'),@timestamp),
		(@bz_user_id,'Bugzilla::Group',@r_group_is_paid,'__create__',NULL,CONCAT(@unit,' #',@product_id,' - RA is Paid'),@timestamp);

	# We enable the FK check back
	SET FOREIGN_KEY_CHECKS = 1;


# Let's Create the Privileges for Marley
#   - Marley is the Landlord
#     His `id_role_type` in the table `ut_role_types` = 2

	# We don't need to create the unit here.
	# BUT We need to Make sure that the the component for this Unit is correct
	# We also want to show the publicly visible information for Leonel.

		SET @stakeholder_pub_info = 'Marley - Profile created by Leonel';

		# User role: this is an id in the table `ut_role_types` for easier manipulation, update and maintenance
		SET @role_type_id = 2;

	# We Need the BZ user information for Marley
		SET @login_name = 'marley@example.com';
		SET @bz_user_id = 3;

	# We Need the BZ user information for Leonel too
		SET @creator_login_name = 'leonel@example.com';
		SET @creator_bz_user_id = 2;

	# We have everything - Let's create the first unit for that user!
	
		# First we disable the FK check
		SET FOREIGN_KEY_CHECKS = 0;

		# Get the additional variable that we need
		SET @timestamp = NOW();
		SET @stakeholder = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=@role_type_id);
# We create a variable @visibility_explanation to facilitate development
# This variable store the text displayed next to the 'visibility' tick in a case
SET @visibility_explanation = CONCAT('Tick to HIDE this case if the user is the ',@stakeholder,' for this unit. Untick to Show this case');
		SET @stakeholder_g_description = (SELECT `bz_description` FROM `ut_role_types` WHERE `id_role_type`=@role_type_id);

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

		# In order to create the records in the audit table, we need to get the newly created component_id
		SET @component_id = LAST_INSERT_ID();

		/*Data for the table `groups` */
		# We need to do this AFTER we created the groups so we can get the creator_group_id
		# Group for 
		# 	- The unit creator and his agents DONE
		#	- To list the user who have a role in this unit DONE
		#	- To See the users who have a role in this unit DONE
		#	- To limit who can see a case or not on a bug/case by bug/case basis if the user is
		# 
		# We create the first group that we need to control access and visibility to this product/unit and the bugs/cases in this products/unit
		# This is NOT the group for the creator
		# this is a group to access a unit and create cases in a unit
		# It also allows empowered user to hide cases from users in this group
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
			(NULL,CONCAT(@unit,' #',@product_id,' - ', @stakeholder,' - Created by: ',@creator_pub_name), @visibility_explanation,1,'',1,NULL);
		SET @visibility_case_group_id = LAST_INSERT_ID();

		# We DO NOT need to create the Groups list and see other stakeholder
		# We just need to make sure the new user is added to the correct groups
		# Group id are:
		# 	- @list_user_group_id
		#	- @see_user_group_id
		# we just need to add this user to these group!
		# other groups that we need 
		# 
		
		# THIS IS NOT A BZ INITIATED ACTION!
		# We insert information into the table which maps groups to products/component
		INSERT INTO `ut_product_group`
			(
			product_id
			,group_id
			,group_type_id
			,role_type_id
			,created
			)
			VALUES
			# We know that the group_type_id for this group is
			# 2 = Access to product and cases
			(@product_id,@visibility_case_group_id,2,@role_type_id,@timestamp)
			,# 4 = list_stakeholder
			(@product_id,@see_user_group_id,4,@role_type_id,@timestamp)
			# 5 = see_stakeholder
			,(@product_id,@see_user_group_id,5,@role_type_id,@timestamp)
			;

		/*Data for the table `user_group_map` */
		# We add the BZ user to the groups we have just created
		INSERT  INTO `user_group_map`
			(`user_id`
			,`group_id`
			,`isbless`
			,`grant_type`
			) 
			VALUES 
			# we grant the User Access to all the default permission for the Test unit
			(@bz_user_id,@all_unit_privileges_group_id,0,0),
			# We also need this user to access the visibility group for these cases
			(@bz_user_id,@visibility_case_group_id,0,0),
			# Make the user a member of the list and see user for this unit.
			(@bz_user_id,@list_user_group_id,0,0),
			(@bz_user_id,@see_user_group_id,0,0);

		/*Data for the table `group_group_map` */
		# The only new group we have created is the group to allow/deny visibility of a case
		INSERT  INTO `group_group_map`
			(`member_id`
			,`grantor_id`
			,`grant_type`
			) 
			VALUES 
			# We keep that for testing
			# we We DO NOT WANT THE ADMINISTRATOR (user id = 1) TO SEE AND MANAGE ALL THESE GROUPS after testing is finished... 
			(1,@visibility_case_group_id,1),
			(1,@visibility_case_group_id,2),
			# END
			# Member_id is a group_id
			# grantor_id is a group_id
			# we probably want the initial group id to be able to do that
			# this is so that the BZ APIs work as intended
			(@creator_group_id,@visibility_case_group_id,0),
			(@creator_group_id,@visibility_case_group_id,1),
			(@creator_group_id,@visibility_case_group_id,2),
			# User in a group can always see the other people in this group
			(@visibility_case_group_id,@visibility_case_group_id,2);

		/*Data for the table `group_control_map` */
		# This is where we decide who can access which products.
		INSERT  INTO `group_control_map`
			(`group_id`
			,`product_id`
			,`entry`
			# it is unclear which id this is: user_id? product_id? other?
			# in order to validate that we need to 
			#  1- re-create a 2nd product from scratch as the same user in the same classification
			#	if id is the same, this is NOT the product_id, it's something else
			#	DONE- membercontrol id is the SAME (2)
			#  2- re-create a 4th product from scratch as the same user in the same classification with a different default assignee.
			# 	if id is the same then this is not the default assignee, it's something else
			#	DONE- membercontrol id is the SAME (2)
			# Membercontrol refers to the access rights and permissions...
			# 0 is NA
			# 1 is SHOWN
			# 2 is DEFAULT
			# 3 is MANDATORY
			# We will revisit this once we zoom in on the permissions issues...
			,`membercontrol`
			# othercontrol refers to the access rights...
			# 0 is NA
			# 1 is SHOWN
			# 2 is DEFAULT
			# 3 is MANDATORY
			# We will revisit this once we zoom in on the permissions issues...
			,`othercontrol`
			,`canedit`
			,`editcomponents`
			,`editbugs`
			,`canconfirm`
			) 
			VALUES 
			(@visibility_case_group_id,@product_id,1,1,3,0,0,1,1);

		/*Data for the table `series_categories` */
		# We need to truncate this table first
		INSERT  INTO `series_categories`
			(`id`
			,`name`
			) 
			VALUES 
			# We add user id so that there are no conflicts when we create several users which are identical stakeholer (ex: 2 tenants)
			(NULL,CONCAT(@stakeholder,'_P',@product_id,'_U',@bz_user_id));

		# We need to know the value of the other series category we need.
		SET @series_3 = (SELECT `id` FROM `series_categories` WHERE `name` = CONCAT(@stakeholder,'_P',@product_id,'_U',@bz_user_id));

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
			(@creator_bz_user_id,'Bugzilla::Group',@visibility_case_group_id,'__create__',NULL,CONCAT(@unit,' #',@product_id,' - ', @stakeholder,' - Created by: ',@creator_pub_name),@timestamp),
			(@creator_bz_user_id,'Bugzilla::Component',@component_id,'__create__',NULL,@stakeholder,@timestamp);


# Let's Create the Privileges for Michael
#     Michael is one of the a 2 Tenants living in this unit.
#     His `id_role_type` in the table `ut_role_types` = 1

	# We don't need to create the unit here.
	# BUT We need to Make sure that the the component for this Unit is correct
	# We also want to show the publicly visible information for Leonel.

		SET @stakeholder_pub_info = 'Michael - Profile created by Leonel';

		# User role: this is an id in the table `ut_role_types` for easier manipulation, update and maintenance
		SET @role_type_id = 1;
		
		# Michael is also an occupant!
		# we will have to create the relevant groups and permissions for him.

	# We Need the BZ user information for Marley
		SET @login_name = 'michael@example.com';
		SET @bz_user_id = 4;

	# We Need the BZ user information for Leonel too
		SET @creator_login_name = 'leonel@example.com';
		SET @creator_bz_user_id = 2;

	# We have everything - Let's create the first unit for that user!
	
		# First we disable the FK check
		SET FOREIGN_KEY_CHECKS = 0;

		# Get the additional variable that we need
		SET @timestamp = NOW();
		SET @stakeholder = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=@role_type_id);
# We create a variable @visibility_explanation to facilitate development
# This variable store the text displayed next to the 'visibility' tick in a case
SET @visibility_explanation = CONCAT('Tick to HIDE this case if the user is the ',@stakeholder,' for this unit. Untick to Show this case');
		SET @stakeholder_g_description = (SELECT `bz_description` FROM `ut_role_types` WHERE `id_role_type`=@role_type_id);

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

		# In order to create the records in the audit table, we need to get the newly created component_id
		SET @component_id = LAST_INSERT_ID();

		/*Data for the table `groups` */
		# We need to do this AFTER we created the groups so we can get the creator_group_id
		# Group for 
		# 	- The unit creator and his agents DONE
		#	- To list the user who have a role in this unit DONE
		#	- To See the users who have a role in this unit DONE
		#	- To limit who can see a case or not on a bug/case by bug/case basis if the user is
		# 
		# We create the first group that we need to control access and visibility to this product/unit and the bugs/cases in this products/unit
		# This is NOT the group for the creator
		# this is a group to access a unit and create cases in a unit
		# It also allows empowered user to hide cases from users in this group

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
			(NULL,CONCAT(@unit,' #',@product_id,' - ', @stakeholder,' - Created by: ',@creator_pub_name), @visibility_explanation,1,'',1,NULL);
		SET @visibility_case_group_id = LAST_INSERT_ID();
		SET @show_bug_to_occupant_group_id = (@visibility_case_group_id+1);

		# We create the group to grant visibility to occupants now
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
			(@show_bug_to_occupant_group_id,CONCAT(@unit,' #',@product_id,' - is occupant'),'Tick to HIDE this case if the user is the Occupant for this unit. Untick to Show this case',1,'',1,NULL);

		# We DO NOT need to create the Groups list and see other stakeholder
		# We just need to make sure the new user is added to the correct groups
		# Group id are:
		# 	- @list_user_group_id
		#	- @see_user_group_id
		# we just need to add this user to these group!
		# other groups that we need 
		# 
		
		# THIS IS NOT A BZ INITIATED ACTION!
		# We insert information into the table which maps groups to products/component
		INSERT INTO `ut_product_group`
			(
			product_id
			,group_id
			,group_type_id
			,role_type_id
			,created
			)
			VALUES
			# We know that the group_type_id for this group is
			# 2 = Access to cases
			(@product_id,@visibility_case_group_id,2,@role_type_id,@timestamp)
			,# 3 = is_occupant
			(@product_id,@show_bug_to_occupant_group_id,3,@role_type_id,@timestamp)
			,# 4 = list_stakeholder
			(@product_id,@see_user_group_id,4,@role_type_id,@timestamp)
			,# 5 = see_stakeholder
			(@product_id,@see_user_group_id,5,@role_type_id,@timestamp)
			;

		/*Data for the table `user_group_map` */
		# We add the BZ user to the groups we have just created
		INSERT  INTO `user_group_map`
			(`user_id`
			,`group_id`
			,`isbless`
			,`grant_type`
			) 
			VALUES 
			# we grant the User Access to all the default permission for the Test unit
			(@bz_user_id,@all_unit_privileges_group_id,0,0),
			# We also need this user to access the visibility group for these cases
			# As the tenant
			(@bz_user_id,@visibility_case_group_id,0,0),
			# As the occupant
			(@bz_user_id,@show_bug_to_occupant_group_id,0,0),
			# Make the user a member of the list and see user for this unit.
			(@bz_user_id,@list_user_group_id,0,0),
			(@bz_user_id,@see_user_group_id,0,0);

		/*Data for the table `group_group_map` */
		# The only new group we have created are:
		# 	- the group to allow/deny visibility of a case to stakholder Tenant
		# 	- the group to allow/deny visibility of a case to Occupant
		INSERT  INTO `group_group_map`
			(`member_id`
			,`grantor_id`
			,`grant_type`
			) 
			VALUES 
			# We keep that for testing
			# we We DO NOT WANT THE ADMINISTRATOR (user id = 1) TO SEE AND MANAGE ALL THESE GROUPS after testing is finished... 
			(1,@visibility_case_group_id,1),
			(1,@visibility_case_group_id,2),
			(1,@show_bug_to_occupant_group_id,1),
			(1,@show_bug_to_occupant_group_id,2),
			# END
			# Member_id is a group_id
			# grantor_id is a group_id
			# we probably want the initial group id to be able to do that
			# this is so that the BZ APIs work as intended
			(@creator_group_id,@visibility_case_group_id,0),
			(@creator_group_id,@visibility_case_group_id,1),
			(@creator_group_id,@visibility_case_group_id,2),
			(@creator_group_id,@show_bug_to_occupant_group_id,0),
			(@creator_group_id,@show_bug_to_occupant_group_id,1),
			(@creator_group_id,@show_bug_to_occupant_group_id,2),
			# User in a group can always see the other people in this group
			(@visibility_case_group_id,@visibility_case_group_id,2);

		/*Data for the table `group_control_map` */
		# This is where we decide who can access which products.
		INSERT  INTO `group_control_map`
			(`group_id`
			,`product_id`
			,`entry`
			# it is unclear which id this is: user_id? product_id? other?
			# in order to validate that we need to 
			#  1- re-create a 2nd product from scratch as the same user in the same classification
			#	if id is the same, this is NOT the product_id, it's something else
			#	DONE- membercontrol id is the SAME (2)
			#  2- re-create a 4th product from scratch as the same user in the same classification with a different default assignee.
			# 	if id is the same then this is not the default assignee, it's something else
			#	DONE- membercontrol id is the SAME (2)
			# Membercontrol refers to the access rights and permissions...
			# 0 is NA
			# 1 is SHOWN
			# 2 is DEFAULT
			# 3 is MANDATORY
			# We will revisit this once we zoom in on the permissions issues...
			,`membercontrol`
			# othercontrol refers to the access rights...
			# 0 is NA
			# 1 is SHOWN
			# 2 is DEFAULT
			# 3 is MANDATORY
			# We will revisit this once we zoom in on the permissions issues...
			,`othercontrol`
			,`canedit`
			,`editcomponents`
			,`editbugs`
			,`canconfirm`
			) 
			VALUES 
			# As the Tenant
			(@visibility_case_group_id,@product_id,1,1,3,0,0,1,1),
			# As the occupant
			(@show_bug_to_occupant_group_id,@product_id,1,1,3,0,0,1,1);

		/*Data for the table `series_categories` */
		# We need to truncate this table first
		INSERT  INTO `series_categories`
			(`id`
			,`name`
			) 
			VALUES 
			# We add user id so that there are no conflicts when we create several users which are identical stakeholer (ex: 2 tenants)
			(NULL,CONCAT(@stakeholder,'_P',@product_id,'_U',@bz_user_id));

		# We need to know the value of the other series category we need.
		SET @series_3 = (SELECT `id` FROM `series_categories` WHERE `name` = CONCAT(@stakeholder,'_P',@product_id,'_U',@bz_user_id));

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
			(@creator_bz_user_id,'Bugzilla::Group',@visibility_case_group_id,'__create__',NULL,CONCAT(@unit,' #',@product_id,' - ', @stakeholder,' - Created by: ',@creator_pub_name),@timestamp),
			(@creator_bz_user_id,'Bugzilla::Group',@show_bug_to_occupant_group_id,'__create__',NULL,CONCAT(@unit,' #',@product_id,' - Occupant - Created by: ',@creator_pub_name),@timestamp),
			(@creator_bz_user_id,'Bugzilla::Component',@component_id,'__create__',NULL,@stakeholder,@timestamp);


# Let's Create the Privileges for Sabrina
#   - Sabrina is the other Tenant living in this unit.
# 	Her `id_role_type` in the table `ut_role_types` = 1
# 	She is also an occupant of the unit.

	# We don't need to create the unit here.
	# BUT We need to Make sure that the the component for this Unit is correct
	# We also want to show the publicly visible information for Leonel.

		SET @stakeholder_pub_info = 'Sabrina - Profile created by Leonel';

		# User role: this is an id in the table `ut_role_types` for easier manipulation, update and maintenance
		SET @role_type_id = 1;
		# THIS IS ANOTHER TENANT IN THE SAME UNIT, WE DON'T NEED TO DO AS MUCH AS WHEN WE CREATE THE FIRST TENANT

	# We Need the BZ user information for Marley
		SET @login_name = 'sabrina@example.com';
		SET @bz_user_id = 5;

	# We Need the BZ user information for Leonel too
		SET @creator_login_name = 'leonel@example.com';
		SET @creator_bz_user_id = 2;

	# We have everything - Let's do this!
	
		# First we disable the FK check
		SET FOREIGN_KEY_CHECKS = 0;

		# Get the additional variable that we need
		SET @timestamp = NOW();
		SET @stakeholder = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=@role_type_id);
# We create a variable @visibility_explanation to facilitate development
# This variable store the text displayed next to the 'visibility' tick in a case
SET @visibility_explanation = CONCAT('Tick to HIDE this case if the user is the ',@stakeholder,' for this unit. Untick to Show this case');
		SET @stakeholder_g_description = (SELECT `bz_description` FROM `ut_role_types` WHERE `id_role_type`=@role_type_id);

		/*Data for the table `components` */
		# We insert the correct values for the component/stakeholder.
		# This is another tenant with NO generic email address
		# We DO NOT want to create a duplicate component here
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
		
		# We also want to update the description of the component, now that we have 2 users there
		# We get the current description
		SET @component_description = (SELECT `description` FROM `components` WHERE `id`=@component_id);
		# We udpdate the component description
		UPDATE `components`
			SET `description` = CONCAT(@component_description,' \r\ ',@stakeholder_pub_info)
			WHERE `id` = @component_id;

		/*Data for the table `groups` */
		# We need groups to to control access and visibility to this product/unit and the bugs/cases in this products/unit
		# This is NOT the group for the creator.
		#
		# It also allows empowered user to hide cases from users in this group
		# We DO NOT NEED to create the group(s) if it exist(s).
		#
		# Sabrina is 
		#	- A Tenant
		#	- An Occupant
		#	- A stakeholder and should be able to see and be seen by all stakeholders.
		# She should be a member of both groups for tenants and occupants in that unit.
		# 
		# We can check that these group exists in the table `ut_product_group`
		# There is already a record there for
		# 	- product_id = 1 (the test product)
		#	- group_type = 2 (access to case/unit)
		#	- role_type_id = 1 (tenant)
		#
		# There is already a record there for
		# 	- product_id = 1 (the test product)
		#	- group_type = 3 (Occupant)
		#	- role_type_id = 1 (tenant)
		#
		# We DO NOT need to create the Groups list and see other stakeholder
		# We just need to make sure the new user is added to the correct groups
		# Group id are:
		# 	- @list_user_group_id
		#	- @see_user_group_id
		# we just need to add this user to these group!
		# other groups that we need 
		# 

		/*Data for the table `user_group_map` */
		# We add the BZ user to the groups he/she needs access to.
		INSERT  INTO `user_group_map`
			(`user_id`
			,`group_id`
			,`isbless`
			,`grant_type`
			) 
			VALUES 
			# we grant the User Access to all the default permission for the Test unit
			(@bz_user_id,@all_unit_privileges_group_id,0,0),
			# We also need this user to access the visibility group for these cases
			# We also need this user to access the visibility group for these cases
			# As the tenant
			# Because the Latest value of the @visibility_case_group_id variable was for the 
			# group which grant visibility to the tenants, we can re-use this variable here.
			(@bz_user_id,@visibility_case_group_id,0,0),
			# As the occupant
			(@bz_user_id,@show_bug_to_occupant_group_id,0,0),
			# Make the user is a member of the list and see user for this unit.
			(@bz_user_id,@list_user_group_id,0,0),
			(@bz_user_id,@see_user_group_id,0,0);

		/*Data for the table `group_group_map` */
		# We have not created any new group there: this is not needed

		/*Data for the table `group_control_map` */
		# We have not created any new group there: this is not needed

		/*Data for the table `series_categories` */
		# There is no need for that - this is not a new stakeholder.

		/*Data for the table `series` */
		# There is no need for that - this is not a new stakeholder.

		/*Data for the table `audit_log` */
		# There is no need for that - what we have done is not recordable in the Audit table



# Let's Create the Privileges for Celeste
#   - Celeste works for the Management Company Management Co, in charge of this unit.
#     Her `id_role_type` in the table `ut_role_types` = 4

	# We don't need to create the unit here.
	# BUT We need to Make sure that the the component for this Unit is correct
	# We also want to show the publicly visible information for Celeste.
	# Celeste's user account has been created by her manager Marina
	# For this script we are assuming that Marina has the necessary permission to create Celeste
	# We might need to review the actual sequence as we'll need to use the BZ API for that.

		SET @stakeholder_pub_info = 'Management Co - We take best care of your unit! ';

		# User role: this is an id in the table `ut_role_types` for easier manipulation, update and maintenance
		SET @role_type_id = 4;

	# We Need the BZ user information for Marley
		SET @login_name = 'celeste@example.com';
		SET @bz_user_id = 6;

	# We Need the BZ user information for the Management Company too
	# We will NOT create the Component with default assignee as Celeste
	# We will declare the default assignee to be the generic user for the company
	# Management.co
		SET @generic_user_name = 'management.co@example.com';
		SET @generic_bz_user_id = 13;
	
		SET @creator_login_name = 'marina@example.com';
		SET @creator_pub_name = 'Team Bravo';
		SET @creator_bz_user_id = 8;

	# We have everything
	
		# First we disable the FK check
		SET FOREIGN_KEY_CHECKS = 0;

		# Get the additional variable that we need
		SET @timestamp = NOW();
		SET @stakeholder = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=@role_type_id);
# We create a variable @visibility_explanation to facilitate development
# This variable store the text displayed next to the 'visibility' tick in a case
SET @visibility_explanation = CONCAT('Tick to HIDE this case if the user is the ',@stakeholder,' for this unit. Untick to Show this case');
		SET @stakeholder_g_description = (SELECT `bz_description` FROM `ut_role_types` WHERE `id_role_type`=@role_type_id);

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
			(NULL,@stakeholder,@product_id,@generic_bz_user_id,@generic_bz_user_id,CONCAT(@stakeholder_g_description, ' \r\ ', @stakeholder_pub_info),1);

		# In order to create the records in the audit table, we need to get the newly created component_id
		SET @component_id = LAST_INSERT_ID();

		/*Data for the table `groups` */
		# We need to do this AFTER we created the groups so we can get the creator_group_id
		# Group for 
		# 	- The unit creator and his agents DONE
		#	- To list the user who have a role in this unit DONE
		#	- To See the users who have a role in this unit DONE
		#	- To limit who can see a case or not on a bug/case by bug/case basis if the user is
		# 
		# We create the first group that we need to control access and visibility to this product/unit and the bugs/cases in this products/unit
		# This is NOT the group for the creator
		# this is a group to access a unit and create cases in a unit
		# It also allows empowered user to hide cases from users in this group
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
			(NULL,CONCAT(@unit,' #',@product_id,' - ', @stakeholder,' - Created by: ',@creator_pub_name), @visibility_explanation,1,'',1,NULL);
		SET @visibility_case_group_id = LAST_INSERT_ID();

		# We DO NOT need to create the Groups list and see other stakeholder
		# We just need to make sure the new user is added to the correct groups
		# Group id are:
		# 	- @list_user_group_id
		#	- @see_user_group_id
		# we just need to add this user to these group!
		# other groups that we need 
		# 
		
		# THIS IS NOT A BZ INITIATED ACTION!
		# We insert information into the table which maps groups to products/component
		INSERT INTO `ut_product_group`
			(
			product_id
			,group_id
			,group_type_id
			,role_type_id
			,created
			)
			VALUES
			# We know that the group_type_id for this group is
			# 2 = Access to product and cases
			(@product_id,@visibility_case_group_id,2,@role_type_id,@timestamp)
			,# 4 = list_stakeholder
			(@product_id,@see_user_group_id,4,@role_type_id,@timestamp)
			# 5 = see_stakeholder
			,(@product_id,@see_user_group_id,5,@role_type_id,@timestamp)
			;

		/*Data for the table `user_group_map` */
		# We add the BZ user to the groups we have just created
		INSERT  INTO `user_group_map`
			(`user_id`
			,`group_id`
			,`isbless`
			,`grant_type`
			) 
			VALUES 
			# we grant the User Celeste Access to all the default permission for the Test unit
# THIS IS INCORRECT - IF WE DO THAT, CELESTE WILL APPEAR IN THE LIST OF FLAG REQUESTEE AND APPROVER AND WE DO NOT WANT THAT THIS SHOULD BE THE GENERIC USER
# We need to create 2 more groups and 2 more variable to know 
# 	- who is allowed to be asked to approved a flag (typicall the generic user)
#	- who is allowed to grant approval to a flag (different privileges...)
			(@bz_user_id,@all_unit_privileges_group_id,0,0),
			# We also need this user Celeste to access the visibility group for these cases
			(@bz_user_id,@visibility_case_group_id,0,0),
			# The individual users Celeste and Marina are NOT a member of the stakeholder list, only the generic user is.
# This comment is likely incorrect
			(@generic_bz_user_id,@list_user_group_id,0,0),
			(@generic_bz_user_id,@see_user_group_id,0,0),
			(@generic_bz_user_id,@visibility_case_group_id,0,0),
			# We also grant access to the product to Marina, Celeste's manager and the user who is creating this.
			# We grant the User Access to all the default permission for the Test unit
			(@creator_bz_user_id,@all_unit_privileges_group_id,0,0),
			# We also need this user (Marina) to access the visibility group for these cases
			(@creator_bz_user_id,@visibility_case_group_id,0,0);

		/*Data for the table `group_group_map` */
		# The only new group we have created is the group to allow/deny visibility of a case
		INSERT  INTO `group_group_map`
			(`member_id`
			,`grantor_id`
			,`grant_type`
			) 
			VALUES 
			# We keep that for testing
			# we We DO NOT WANT THE ADMINISTRATOR (user id = 1) TO SEE AND MANAGE ALL THESE GROUPS after testing is finished... 
			(1,@visibility_case_group_id,1),
			(1,@visibility_case_group_id,2),
			# END
			# Member_id is a group_id
			# grantor_id is a group_id
			# we probably want the initial group id to be able to do that
			# this is so that the BZ APIs work as intended
			(@creator_group_id,@visibility_case_group_id,0),
			(@creator_group_id,@visibility_case_group_id,1),
			(@creator_group_id,@visibility_case_group_id,2),
			# User in a group can always see the other people in this group
			(@visibility_case_group_id,@visibility_case_group_id,2);

		/*Data for the table `group_control_map` */
		# This is where we decide who can access which products.
		INSERT  INTO `group_control_map`
			(`group_id`
			,`product_id`
			,`entry`
			# it is unclear which id this is: user_id? product_id? other?
			# in order to validate that we need to 
			#  1- re-create a 2nd product from scratch as the same user in the same classification
			#	if id is the same, this is NOT the product_id, it's something else
			#	DONE- membercontrol id is the SAME (2)
			#  2- re-create a 4th product from scratch as the same user in the same classification with a different default assignee.
			# 	if id is the same then this is not the default assignee, it's something else
			#	DONE- membercontrol id is the SAME (2)
			# Membercontrol refers to the access rights and permissions...
			# 0 is NA
			# 1 is SHOWN
			# 2 is DEFAULT
			# 3 is MANDATORY
			# We will revisit this once we zoom in on the permissions issues...
			,`membercontrol`
			# othercontrol refers to the access rights...
			# 0 is NA
			# 1 is SHOWN
			# 2 is DEFAULT
			# 3 is MANDATORY
			# We will revisit this once we zoom in on the permissions issues...
			,`othercontrol`
			,`canedit`
			,`editcomponents`
			,`editbugs`
			,`canconfirm`
			) 
			VALUES 
			(@visibility_case_group_id,@product_id,1,1,3,0,0,1,1);

		/*Data for the table `series_categories` */
		# We need to truncate this table first
		INSERT  INTO `series_categories`
			(`id`
			,`name`
			) 
			VALUES 
			# We add user id so that there are no conflicts when we create several users which are identical stakeholer (ex: 2 tenants)
			# in this case, the user we choose is Marina, the manager.
			(NULL,CONCAT(@stakeholder,'_P',@product_id,'_U',@creator_bz_user_id));

		# We need to know the value of the other series category we need.
		SET @series_3 = (SELECT `id` FROM `series_categories` WHERE `name` = CONCAT(@stakeholder,'_P',@product_id,'_U',@creator_bz_user_id));

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
			(NULL,@creator_bz_user_id,@series_1,@series_3,'All Open',1,CONCAT('field0-0-0=resolution&type0-0-0=notregexp&value0-0-0=.&product=Test%Unit%1%A&component=', @stakeholder),1),
			(NULL,@creator_bz_user_id,@series_1,@series_3,'All Closed',1,CONCAT('field0-0-0=resolution&type0-0-0=regexp&value0-0-0=.&product=Test%Unit%1%A&component=', @stakeholder),1);

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
			(@creator_bz_user_id,'Bugzilla::Group',@visibility_case_group_id,'__create__',NULL,CONCAT(@unit,' #',@product_id,' - ', @stakeholder,' - Created by: ',@creator_pub_name),@timestamp),
			(@creator_bz_user_id,'Bugzilla::Component',@component_id,'__create__',NULL,@stakeholder,@timestamp);






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
SET @stakeholder = NULL;
SET @stakeholder_g_description = NULL;
SET @stakeholder_pub_info = NULL;
SET @login_name = NULL;
SET @bz_user_id = NULL;
SET @bz_user_id_who_can_be_asked_to_approve = NULL;
SET @bz_user_id_who_can_to_approve = NULL;
SET @product_id = NULL;
SET @milestone_id = NULL;
SET @version_id = NULL;
SET @component_id = NULL;
SET @creator_group_id = NULL;
SET @visibility_case_group_id = NULL;
SET @list_user_group_id = NULL;
SET @see_user_group_id = NULL;
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
SET @all_g_tags = NULL;
SET @all_r_tags = NULL;
SET @series_2 = NULL;
SET @series_1 = NULL;
SET @series_3 = NULL;