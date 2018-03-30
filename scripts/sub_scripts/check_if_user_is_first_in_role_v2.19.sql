# For any information about this script, ask Franck

# This script will check if a role for a unit is assigned to 1 of the dummy users.
# we do this by comparing the actual default user in a role/component for a product/unit is one of the dummy user


#################################################################
#																#
# UPDATE THE BELOW VARIABLES ACCORDING TO YOUR NEEDS			#
#																#
#################################################################
#
# The variables we need:
	SET @product_id = 1;
	SET @user_role_type_id = 1;

# Environment: Which environment are you creating the unit in?
#	- 1 is for the DEV/Staging
#	- 2 is for the prod environment
#	- 3 is for the Demo environment
	SET @environment = 1;


# Info about this script
	SET @script = 'check_if_user_is_first_in_role_v2.19.sql';

# Timestamp	
	SET @timestamp = NOW();

# We create a temporary table to record the ids of the dummy users in each environments:
	/*Table structure for table `ut_temp_dummy_users_for_roles` */
		DROP TABLE IF EXISTS `ut_temp_dummy_users_for_roles`;

		CREATE TABLE `ut_temp_dummy_users_for_roles` (
		  `environment_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Id of the environment',
		  `environment_name` VARCHAR(256) COLLATE utf8_unicode_ci NOT NULL,
		  `tenant_id` INT(11) NOT NULL,
		  `landlord_id` INT(11) NOT NULL,
		  `contractor_id` INT(11) NOT NULL,
		  `mgt_cny_id` INT(11) NOT NULL,
		  `agent_id` INT(11) DEFAULT NULL,
		  PRIMARY KEY (`environment_id`)
		) ENGINE=INNODB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

	/*Data for the table `ut_temp_dummy_users_for_roles` */
		INSERT INTO `ut_temp_dummy_users_for_roles`(`environment_id`,`environment_name`,`tenant_id`,`landlord_id`,`contractor_id`,`mgt_cny_id`,`agent_id`) VALUES 
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

# What is the BZ dummy user id for this role in this script?
	SET @bz_user_id_dummy_user_this_role = IF( @user_role_type_id = 1
									, @bz_user_id_dummy_tenant
									, IF (@user_role_type_id = 2
										, @bz_user_id_dummy_landlord
										, IF (@user_role_type_id = 3
											, @bz_user_id_dummy_contractor
											, IF (@user_role_type_id = 4
												, @bz_user_id_dummy_mgt_cny
												, IF (@user_role_type_id = 5
													, @bz_user_id_dummy_agent
													, 'Something is very wrong!!'
													)
												)
											)
										)
									)
									;
		
		
# We get the information about the component/roles that were created for this product:
	# We get that from the ut_product_group table.
		SET @component_id_this_role = (SELECT `component_id` 
									FROM `ut_product_group` 
									WHERE `product_id` = @product_id 
										AND `role_type_id` = @user_role_type_id
										AND `group_type_id` = 2)
										;

	# Component for the Tenant 1
		SET @component_id_tenant = (SELECT `component_id` 
									FROM `ut_product_group` 
									WHERE `product_id` = @product_id 
										AND `role_type_id` = 1
										AND `group_type_id` = 2)
										;

	# Component for the Landlord 2
		SET @component_id_landlord = (SELECT `component_id` 
									FROM `ut_product_group` 
									WHERE `product_id` = @product_id 
										AND `role_type_id` = 2
										AND `group_type_id` = 2)
										;
		
	# Component for the Contractor 3
		SET @component_id_contractor = (SELECT `component_id` 
									FROM `ut_product_group` 
									WHERE `product_id` = @product_id 
										AND `role_type_id` = 3
										AND `group_type_id` = 2)
										;
		
	# Component for the Management company 4
		SET @component_id_mgt_cny = (SELECT `component_id` 
									FROM `ut_product_group` 
									WHERE `product_id` = @product_id 
										AND `role_type_id` = 4
										AND `group_type_id` = 2)
										;
		
	# Component for the Agent 5
		SET @component_id_agent = (SELECT `component_id` 
									FROM `ut_product_group` 
									WHERE `product_id` = @product_id 
										AND `role_type_id` = 5
										AND `group_type_id` = 2)
										;

# What is the CURRENT default assignee for these component?

	# for the role defined as a variable for this script
		SET @current_default_assignee_this_role = (SELECT `initialowner` FROM `components` WHERE `id` = @component_id_this_role);
	
	# Tenant 1
		SET @current_default_assignee_tenant = (SELECT `initialowner` FROM `components` WHERE `id` = @component_id_tenant);

	# Landlord 2
		SET @current_default_assignee_landlord = (SELECT `initialowner` FROM `components` WHERE `id` = @component_id_landlord);
		
	# Contractor 3
		SET @current_default_assignee_contractor = (SELECT `initialowner` FROM `components` WHERE `id` = @component_id_contractor);
		
	# Management company 4
		SET @current_default_assignee_mgt_cny = (SELECT `initialowner` FROM `components` WHERE `id` = @component_id_mgt_cny);
		
	# Agent 5
		SET @current_default_assignee_agent = (SELECT `initialowner` FROM `components` WHERE `id` = @component_id_agent);

# IS the current default assignee one of the dummy users?

	# For the role defined as a variable for this script
		SET @is_current_assignee_this_role_a_dummy_user = IF ( @current_default_assignee_this_role = @bz_user_id_dummy_user_this_role
											, 1
											, 0
											)
											;	
	
	# Tenant 1
		SET @is_current_agent_dummy_user = IF ( @current_default_assignee_tenant = @bz_user_id_dummy_tenant
											, 1
											, 0
											)
											;

	# Landlord 2
		SET @is_current_landlord_dummy_user = IF ( @current_default_assignee_landlord = @bz_user_id_dummy_landlord
											, 1
											, 0
											)
											;
		
	# Contractor 3
		SET @is_current_contractor_dummy_user = IF ( @current_default_assignee_contractor = @bz_user_id_dummy_contractor
											, 1
											, 0
											)
											;
		
	# Management company 4
		SET @is_current_mgt_cny_dummy_user = IF ( @current_default_assignee_mgt_cny = @bz_user_id_dummy_mgt_cny
											, 1
											, 0
											)
											;
		
	# Agent 5
		SET @is_current_agent_dummy_user = IF ( @current_default_assignee_agent = @bz_user_id_dummy_agent
											, 1
											, 0
											)
											;
		
# Cleanup
	# We Delete the temp table as we do not need it anymore
		DROP TABLE IF EXISTS `ut_temp_dummy_users_for_roles`;
										