# Contact Franck for any question about this script
# 
# This Script creates a Unee-T product/unit from scratch in the BZ Back end
#
#  TEST : create a new product with this routine
# 	Expected results:
#	 	- Product, component, etc are all created
#		- Variables are working
#		- groups are created
#		- Initial permission for the creator are created
#			- Access to product
#			- List of the stakeholders
#			- see the stakeholder
#		- The user is made a member of all the relevant groups.
#		- We update the unee-t specific tables that we will need later
#		- We use LAST_INSERT_ID to get the values of the things we have just created.
#		- The series are OK
#		- We grant permission to the flags for this unit
# 	Limits:
#		- The group 'Admin' is a member of the creator group for all units.
#		  We might want to revisit this at some point...
# 		- DOES NOT add the group and permission to be able to limit the visibility to occupants
#		  This is done in the NEXT step with another script
#	Result: This is working as intended!!
#
# This script: 
#  - creates the product @unit
#  - for the stakeholder/component: @stakeholder
#  - in the classification: 2 (My Units)
#  - Create a default value for Milestone: '---' for the product/unit
#  - Create a default value for Version: '---' for the product/unit
#  - Create all the groups we need based on the role of the user
#  - Grant user membership to the relevant groups
#  - Define the permissions (based on groups and group memberships) and based on the role of the user.
# 
# This script makes sure that we have all the groups we need to 
#  - Restrict/manage accesses to the product/unit
#  - Limit who can see users and stakeholders for the unit
#  
# This script requires several variables: see below



# These are the variables we need from a user input (Eventually from the MEFE) to describe the unit and the user role in the unit.
	# WARNING We need to make sure that the unit variable is not too long!
	# this is a varchar(64) in the BZ database!
	# BUT since we are also creating flags based on this unit name we are adding a max of 11 characters to create flag names
	# Flag name are varchar(50)
	# LT solution is to alter the field `name` in the table `flagtypes` to varchar(100) for the BZFE instances to avoid this issue
	#
	# We need a name for the unit
	SET @unit = 'UN-1 - CAUN-A';
	# We also need a public description, This is typically an address and any information that need to be shared with all other people.
	SET @unit_pub_description = 'Unit 1 - Canonical Unit A';
	# We as the user to give himself a public name
	# This is in case the user is willing to hide his email address (the default public name is the email address).
	# When we will use the MEFE to create this unit, we can easily include the information that the MEFE User will have deemed public.
	SET @creator_pub_name = 'Public Name';
	# User public information: the information the user is ready to share with the world
	SET @stakeholder_pub_info = CONCAT(@creator_pub_name,' - Phone number: 123 456 7891. For a faster response, please message me directly in Unee-T for this unit');
	# User role: this is an id in the table `ut_role_types` for easier manipulation, update and maintenance
	SET @role_type_id = 5;

# We Need the BZ user information too
	SET @login_name = 'leonel@example.com';
	SET @bz_user_id = 2;
	
# By default we will create this unit in the group/classification 'My Units' which is created in each BZFE instances.
# In case we have created a dedicated classification/Unit group for this unit (ex: for a corporate client) we need to update this
	SET @unit_group = 2;

# We have everything - Let's create the first unit for that user!

	# Get the additional variables that we need
	
	# We will need to use the unit name in queries, queries can't have space
	# We need to check and test wich other special characters are replaced in a query too...
				#######
				# WIP #
				#######	
	SET @unit_for_query = REPLACE(@unit,' ','%');
	# We will need to use the unit name in tag name, 
	#tag name can't have space or special characters in then
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
	SET @timestamp = NOW();
	# We get the Stakeholder designation from the `ut_role_types` table
	# this makes it easy to maintain
	SET @stakeholder = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=@role_type_id);
	# We get the Stakeholder Generic description for the BZFE from the `ut_role_types` table
	# this makes it easy to maintain
	SET @stakeholder_g_description = (SELECT `bz_description` FROM `ut_role_types` WHERE `id_role_type`=@role_type_id);

# We create a variable @visibility_explanation to facilitate development
# This variable store the text displayed next to the 'visibility' tick in a case
SET @visibility_explanation = CONCAT('Tick to HIDE this case if the user is the ',@stakeholder,' for this unit. Untick to Show this case');

	# First we disable the FK check
	SET FOREIGN_KEY_CHECKS = 0;

	/*Data for the table `products` */
	INSERT  INTO `products`(
		`id`
		,`name`
		,`classification_id`
		,`description`
		,`isactive`
		,`defaultmilestone`
		,`allows_unconfirmed`
		) 
		VALUES 
		(NULL,@unit,@unit_group,@unit_pub_description,1,'---',1);

	# In order to create the component, we need to get the newly created product_id
	# There might be a most robust way to do this: 
	# We hope that there will be no freak scenario where something else is creating a new record
	# Just after the script above finishes AND just before this variable is set...
	SET @product_id = LAST_INSERT_ID();


	/*Data for the table `milestones` */
	# we need to insert these AFTER the product has been created!
	# This BZ default field is mandatory but not used in our BZFE
	INSERT  INTO `milestones`
		(`id`
		,`product_id`
		,`value`
		,`sortkey`
		,`isactive`
		) 
		VALUES 
		(NULL,@product_id,'---',0,1);

	# In order to create the records in the audit table, we need to get the newly created milestone_id
	SET @milestone_id = LAST_INSERT_ID();

	/*Data for the table `versions` */
	# This BZ default field is mandatory but not used in our BZFE
	INSERT  INTO `versions`
		(`id`
		,`value`
		,`product_id`
		,`isactive`
		) 
		VALUES 
		(NULL,'---',@product_id,1);

	# In order to create the records in the audit table, we need to get the newly created version_id
	SET @version_id = LAST_INSERT_ID();

	/*Data for the table `components` */
	# we need to insert these AFTER the product has been created!
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

# We also need to create a few groups too...

	/*Data for the table `groups` */
	# We create the first group that we need to control access and visibility to this product/unit and the bugs/cases in this products/unit
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
		(NULL,CONCAT (@unit,' #',@product_id,' - Creator'), CONCAT('Unit creator (or it\'s agent) for ', @unit),1,'',1,NULL);

	# We need to get the newly created group_id
	# based on this, we derive the other new group_id too.
		# group for the unit creator (first group we created)
		SET @creator_group_id = LAST_INSERT_ID();
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
		# a Group of groups to facilitate user management all the user in this unit belong there.
		SET @default_privilege_group_id = (@r_group_is_paid+1);
	
	/*We can now create the other groups that we need */
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
		(@default_privilege_group_id,CONCAT(@unit,' #',@product_id,' - Stakeholder'),'Access to All the groups a stakeholder needs for this unit',1,'',0,NULL);

	
	# THIS IS NOT A BZ INITIATED ACTION!
	
	
# WIP we need to replace with variables
# We need to add the information about the flag groups too.
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
		(@product_id,@default_privilege_group_id,18,@role_type_id,@timestamp);


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
		(@bz_user_id,@default_privilege_group_id,0,0),
		# user is the creator of the unit
		(@bz_user_id,@creator_group_id,0,0),
		# user is a member of the specific `stakholder` group for his role
		(@bz_user_id,@visibility_case_group_id,0,0),
		#user is visible in the list of stakeholder for this unit
		(@bz_user_id,@list_user_group_id,0,0),
		# user can see the users in the list of stakeholder for this unit
		(@bz_user_id,@see_user_group_id,0,0);

	/*Data for the table `group_group_map` */
	INSERT  INTO `group_group_map`
		(`member_id`
		,`grantor_id`
		,`grant_type`
		) 
		VALUES 
		# WIP - we only keep that for testing
		#
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
			@default_privilege_group_id
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
					#(1,@default_privilege_group_id,0),
				
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
					(1,@default_privilege_group_id,1),

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
					(1,@default_privilege_group_id,2),
		
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
					#(@creator_group_id,@default_privilege_group_id,0),
				
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
					(@creator_group_id,@default_privilege_group_id,1),

			# Privilege #2: 
			# All the users in the Group @creator_group_id can see the users in the group YYY
			# The group @creator_group_id has Permission #2 to:
				# See all the users that are creators
					(@creator_group_id,@creator_group_id,2),
				# See all user that have the same role in the unit
					(@creator_group_id,@visibility_case_group_id,2),
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
					#(@creator_group_id,@default_privilege_group_id,2),

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
					(@visibility_case_group_id,@default_privilege_group_id,1),

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
					#(@visibility_case_group_id,@default_privilege_group_id,2),
				
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

		# We then look at the group @default_privilege_group_id
		# This is a group to 
		#	- Give access to all the group that a user needs for this unit
		#
				
			# Privilege #0:
			# All the users in the Group @default_privilege_group_id are automatically a member of group YYY
			# The group has privilege #0 for the groups:
				# This is the only reason why this group exists
					# syst_see_timetracking 
					(@default_privilege_group_id,16,0),
					# syst_create_shared_quotes
					(@default_privilege_group_id,17,0),
					#syst_tag_comments
					(@default_privilege_group_id,18,0),
					# all the Flags group for this product		
					(@default_privilege_group_id,@r_group_next_step,0),
					(@default_privilege_group_id,@g_group_next_step,0),
					(@default_privilege_group_id,@r_group_solution,0),
					(@default_privilege_group_id,@g_group_solution,0),
					(@default_privilege_group_id,@r_group_budget,0),
					(@default_privilege_group_id,@g_group_budget,0),
					(@default_privilege_group_id,@r_group_attachment,0),
					(@default_privilege_group_id,@g_group_attachment,0),
					(@default_privilege_group_id,@r_group_OK_to_pay,0),
					(@default_privilege_group_id,@g_group_OK_to_pay,0),
					(@default_privilege_group_id,@r_group_is_paid,0),
					(@default_privilege_group_id,@g_group_is_paid,0);
				
			# Privilege #1:
			# All the users in the Group XXX can grant access so that a user can be put in group YYY
			# The group @default_privilege_group_id has Permission #1 for:
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

# We create and configure the generic flags we need (This is still WIP).

	/*Data for the table `flagtypes` */
	# We insert the first flagtype
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
			(NULL,CONCAT(@unit_for_flag,'_Next_Step'),'Approval for the Next Step of the case.','','b',1,1,1,1,10,@g_group_next_step,@r_group_next_step);
	
	# get the id for the rest of the flagtypes we need
		SET @flag_next_step = LAST_INSERT_ID();
		SET @flag_solution = (@flag_next_step+1);
		SET @flag_budget = (@flag_solution+1);
		SET @flag_attachment = (@flag_budget+1);
		SET @flag_ok_to_pay = (@flag_attachment+1);
		SET @flag_is_paid = (@flag_ok_to_pay+1);

	# We insert the rest of the flagtypes
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
	INSERT  INTO `series_categories`
		(`id`
		,`name`
		) 
		VALUES 
		(NULL,CONCAT(@stakeholder,'_#',@product_id)),
		(NULL,CONCAT(@unit,'_#',@product_id));

	# We need to know the value of the other series category we need.
	SET @series_2 = (SELECT `id` FROM `series_categories` WHERE `name` = '-All-');
	SET @series_1 = (SELECT `id` FROM `series_categories` WHERE `name` = CONCAT(@stakeholder,'_#',@product_id));
	SET @series_3 = (SELECT `id` FROM `series_categories` WHERE `name` = CONCAT(@unit,'_#',@product_id));

	/*Data for the table `series` */
	# This is so that we can see historical data and how a case is evolving
	# This can only be done after the series categories have been created

/*WARNING - THIS IS WIP!
WE NEED TO FIND A WAY TO MAKE SURE THAT spaces ARE REPLACED WITH % in the queries!!!
We have a way: use the variable @unit_for_query there
*/	
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
		(@bz_user_id,'Bugzilla::Product',@product_id,'__create__',NULL,@unit,@timestamp),
		(@bz_user_id,'Bugzilla::Version',@version_id,'__create__',NULL,'---',@timestamp),
		(@bz_user_id,'Bugzilla::Milestone',@milestone_id,'__create__',NULL,'---',@timestamp),
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
SET @default_privilege_group_id = NULL;
SET @series_2 = NULL;
SET @series_1 = NULL;
SET @series_3 = NULL;