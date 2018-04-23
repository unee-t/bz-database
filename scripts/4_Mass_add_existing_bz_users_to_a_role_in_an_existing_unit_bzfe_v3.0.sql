# For any question about this script, ask Franck

#############################################
#											#
# IMPORTANT INFORMATION ABOUT THIS SCRIPT	#
#											#
#############################################
#
# Built for BZFE database v3.0
#
# This script adds an BZ user to an existing unit in a role which has already been created.
# It also 
#	- grants default permission to the a unit to that BZ user.
#	- makes the new user a CC for all the new cases created for that unit and this role.
#
# Use this script only if 
#	- the Unit/Product ALREADY EXISTS in the BZFE
#	- the Role/component ALREADY EXISTS in the BZFE
#
# This script assumes that
#	- the unit has been created with the script '2_Insert_new_unit_with_dummy_roles_in_unee-t_bzfe_v2.1x'
#	- the 'real' default user for this role for that unit has been created with the script '4_replace_dummy_role_with_genuine_user_as_default_in_unee-t_bzfe_vx.y.sql'
# 	OR with a method that creates a unit with all the necessary BZ objects and all the roles assigned to dummy users.
#	- The table 'ut_data_to_add_user_to_a_role' has been updated and we know the record that we need to use to do the update.
#
# Limits of this script:
#	- DO NOT USE if the unit DOES NOT exists in the BZ database.
#	- DO NOT USE if the role DOES NOT exists in the BZ database for that unit.
#	- DO NOT USE if the role created is assigned to a 'dummy' BZ user.
#
# IMPORTANT INFORMATION - THIS SCRIPT WILL MAKE THIS NEW USER A DEFAULT CC FOR ALL THE NEW CASES CREATED FOR THIS UNIT!
#

# Info about this script
	SET @script_mass_add_user_to_role = '4_Mass_add_existing_bz_users_to_a_role_in_an_existing_unit_bzfe_v3.0.sql';

# Timestamp	
	SET @timestamp_mass_add_user_to_role = NOW();

# We create the table which list the units we need to process:
	/*Table structure for table `ut_temp_data_to_add_user_to_a_role` */
		DROP TABLE IF EXISTS `ut_temp_data_to_add_user_to_a_role`;

		CREATE TABLE `ut_temp_data_to_add_user_to_a_role` (
		  `token_mass_add_user_to_role` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'token of the record to process',
		  `add_user_to_role_record_to_process_id` INT(11) NOT NULL COMMENT 'The ID in the table `ut_data_to_create_units`',
		  PRIMARY KEY (`token_mass_add_user_to_role`)
		) ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
		
	# We populate this table with the data where there are now information
		INSERT INTO `ut_temp_data_to_add_user_to_a_role`
			(`add_user_to_role_record_to_process_id`
			)

		SELECT `id`
		FROM `ut_data_to_add_user_to_a_role`
		WHERE `bz_created_date` IS NULL
		ORDER BY `id` ASC
		;

# How many records do we need to process?
	SET @max_loops_mass_add_user_to_role = (SELECT MAX(`token_mass_add_user_to_role`) FROM `ut_temp_data_to_add_user_to_a_role`);


# We create all the procedures we will need so that this script can work

	# Then the permissions that are relevant to the component/role
	# These are conditional as this depends on the role attributed to that user
					
		# User can see the cases for Tenants in the unit:
DROP PROCEDURE IF EXISTS show_to_tenant;
DELIMITER $$
CREATE PROCEDURE show_to_tenant()
BEGIN
	IF (@id_role_type_mass_add_user_to_role = 1)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id_mass_add_user_to_role, @group_id_show_to_tenant_mass_add_user_to_role, 0, 0)
				;

			# Log the actions of the script.
				SET @script_mass_add_user_to_role_log_message = CONCAT('the bz user #'
										, @bz_user_id_mass_add_user_to_role
										, ' CAN see case that are limited to tenants'
										, ' for the unit #'
										, @product_id_mass_add_user_to_role
										, '.'
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script_mass_add_user_to_role, @script_mass_add_user_to_role_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table_mass_add_user_to_role = 'ut_user_group_map_temp';
				SET @permission_granted_mass_add_user_to_role = 'CAN see case that are limited to tenants.';

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
					 (NOW() ,@bzfe_table_mass_add_user_to_role, 'user_id', 'UNKNOWN', @bz_user_id_mass_add_user_to_role, @script_mass_add_user_to_role, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'group_id', 'UNKNOWN', @group_id_show_to_tenant_mass_add_user_to_role, @script_mass_add_user_to_role, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'isbless', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user does NOT grant ',@permission_granted_mass_add_user_to_role, ' permission'))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'grant_type', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user is a member of the group', @permission_granted_mass_add_user_to_role))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_mass_add_user_to_role_log_message = NULL;
				SET @bzfe_table_mass_add_user_to_role = NULL;
				SET @permission_granted_mass_add_user_to_role = NULL;
END IF ;
END $$
DELIMITER ;	
	
	
		# User is a tenant in the unit:
DROP PROCEDURE IF EXISTS is_tenant;
DELIMITER $$
CREATE PROCEDURE is_tenant()
BEGIN
	IF (@id_role_type_mass_add_user_to_role = 1)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id_mass_add_user_to_role, @group_id_are_users_tenant_mass_add_user_to_role, 0, 0)
				;

			# Log the actions of the script.
				SET @script_mass_add_user_to_role_log_message = CONCAT('the bz user #'
										, @bz_user_id_mass_add_user_to_role
										, ' is a tenant in the unit #'
										, @product_id_mass_add_user_to_role
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script_mass_add_user_to_role, @script_mass_add_user_to_role_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table_mass_add_user_to_role = 'ut_user_group_map_temp';
				SET @permission_granted_mass_add_user_to_role = 'is an tenant.';

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
					 (NOW() ,@bzfe_table_mass_add_user_to_role, 'user_id', 'UNKNOWN', @bz_user_id_mass_add_user_to_role, @script_mass_add_user_to_role, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'group_id', 'UNKNOWN', @group_id_are_users_tenant_mass_add_user_to_role, @script_mass_add_user_to_role, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'isbless', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user does NOT grant ',@permission_granted_mass_add_user_to_role, ' permission'))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'grant_type', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user is a member of the group', @permission_granted_mass_add_user_to_role))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_mass_add_user_to_role_log_message = NULL;
				SET @bzfe_table_mass_add_user_to_role = NULL;
				SET @permission_granted_mass_add_user_to_role = NULL;
END IF ;
END $$
DELIMITER ;

		# User can see all the tenant in the unit:
DROP PROCEDURE IF EXISTS default_tenant_can_see_tenant;
DELIMITER $$
CREATE PROCEDURE default_tenant_can_see_tenant()
BEGIN
	IF (@id_role_type_mass_add_user_to_role = 1)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id_mass_add_user_to_role, @group_id_see_users_tenant, 0, 0)
				;

			# Log the actions of the script.
				SET @script_mass_add_user_to_role_log_message = CONCAT('the bz user #'
										, @bz_user_id_mass_add_user_to_role
										, ' can see tenant in the unit '
										, @product_id_mass_add_user_to_role
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script_mass_add_user_to_role, @script_mass_add_user_to_role_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table_mass_add_user_to_role = 'ut_user_group_map_temp';
				SET @permission_granted_mass_add_user_to_role = 'can see tenant in the unit.';

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
					 (NOW() ,@bzfe_table_mass_add_user_to_role, 'user_id', 'UNKNOWN', @bz_user_id_mass_add_user_to_role, @script_mass_add_user_to_role, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'group_id', 'UNKNOWN', @group_id_see_users_tenant, @script_mass_add_user_to_role, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'isbless', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user does NOT grant ',@permission_granted_mass_add_user_to_role, ' permission'))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'grant_type', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user is a member of the group', @permission_granted_mass_add_user_to_role))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_mass_add_user_to_role_log_message = NULL;
				SET @bzfe_table_mass_add_user_to_role = NULL;
				SET @permission_granted_mass_add_user_to_role = NULL;
END IF ;
END $$
DELIMITER ;
		
			# User can see the cases for Landlord in the unit:
DROP PROCEDURE IF EXISTS show_to_landlord;
DELIMITER $$
CREATE PROCEDURE show_to_landlord()
BEGIN
	IF (@id_role_type_mass_add_user_to_role = 2)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id_mass_add_user_to_role, @group_id_show_to_landlord_mass_add_user_to_role, 0, 0)
				;

			# Log the actions of the script.
				SET @script_mass_add_user_to_role_log_message = CONCAT('the bz user #'
										, @bz_user_id_mass_add_user_to_role
										, ' CAN see case that are limited to landlords'
										, ' for the unit #'
										, @product_id_mass_add_user_to_role
										, '.'
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script_mass_add_user_to_role, @script_mass_add_user_to_role_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table_mass_add_user_to_role = 'ut_user_group_map_temp';
				SET @permission_granted_mass_add_user_to_role = 'CAN see case that are limited to landlords.';

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
					 (NOW() ,@bzfe_table_mass_add_user_to_role, 'user_id', 'UNKNOWN', @bz_user_id_mass_add_user_to_role, @script_mass_add_user_to_role, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'group_id', 'UNKNOWN', @group_id_show_to_landlord_mass_add_user_to_role, @script_mass_add_user_to_role, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'isbless', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user does NOT grant ',@permission_granted_mass_add_user_to_role, ' permission'))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'grant_type', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user is a member of the group', @permission_granted_mass_add_user_to_role))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_mass_add_user_to_role_log_message = NULL;
				SET @bzfe_table_mass_add_user_to_role = NULL;
				SET @permission_granted_mass_add_user_to_role = NULL;
END IF ;
END $$
DELIMITER ;	
	
		# User is a landlord for the unit:
DROP PROCEDURE IF EXISTS are_users_landlord;
DELIMITER $$
CREATE PROCEDURE are_users_landlord()
BEGIN
	IF (@id_role_type_mass_add_user_to_role = 2)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id_mass_add_user_to_role, @group_id_are_users_landlord, 0, 0)
				;

			# Log the actions of the script.
				SET @script_mass_add_user_to_role_log_message = CONCAT('the bz user #'
										, @bz_user_id_mass_add_user_to_role
										, ' is a landlord for the unit #'
										, @product_id_mass_add_user_to_role
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script_mass_add_user_to_role, @script_mass_add_user_to_role_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table_mass_add_user_to_role = 'ut_user_group_map_temp';
				SET @permission_granted_mass_add_user_to_role = 'is an landlord.';

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
					 (NOW() ,@bzfe_table_mass_add_user_to_role, 'user_id', 'UNKNOWN', @bz_user_id_mass_add_user_to_role, @script_mass_add_user_to_role, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'group_id', 'UNKNOWN', @group_id_are_users_landlord, @script_mass_add_user_to_role, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'isbless', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user does NOT grant ',@permission_granted_mass_add_user_to_role, ' permission'))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'grant_type', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user is a member of the group', @permission_granted_mass_add_user_to_role))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_mass_add_user_to_role_log_message = NULL;
				SET @bzfe_table_mass_add_user_to_role = NULL;
				SET @permission_granted_mass_add_user_to_role = NULL;
END IF ;
END $$
DELIMITER ;

		# User can see all the tenant in the unit:
DROP PROCEDURE IF EXISTS default_landlord_see_users_landlord;
DELIMITER $$
CREATE PROCEDURE default_landlord_see_users_landlord()
BEGIN
	IF (@id_role_type_mass_add_user_to_role = 2)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id_mass_add_user_to_role, @group_id_see_users_landlord, 0, 0)
				;

			# Log the actions of the script.
				SET @script_mass_add_user_to_role_log_message = CONCAT('the bz user #'
										, @bz_user_id_mass_add_user_to_role
										, ' can see tenant in the unit '
										, @product_id_mass_add_user_to_role
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script_mass_add_user_to_role, @script_mass_add_user_to_role_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table_mass_add_user_to_role = 'ut_user_group_map_temp';
				SET @permission_granted_mass_add_user_to_role = 'can see tenant in the unit.';

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
					 (NOW() ,@bzfe_table_mass_add_user_to_role, 'user_id', 'UNKNOWN', @bz_user_id_mass_add_user_to_role, @script_mass_add_user_to_role, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'group_id', 'UNKNOWN', @group_id_see_users_landlord, @script_mass_add_user_to_role, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'isbless', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user does NOT grant ',@permission_granted_mass_add_user_to_role, ' permission'))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'grant_type', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user is a member of the group', @permission_granted_mass_add_user_to_role))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_mass_add_user_to_role_log_message = NULL;
				SET @bzfe_table_mass_add_user_to_role = NULL;
				SET @permission_granted_mass_add_user_to_role = NULL;
END IF ;
END $$
DELIMITER ;

			# User can see the cases for agent in the unit:
DROP PROCEDURE IF EXISTS show_to_agent;
DELIMITER $$
CREATE PROCEDURE show_to_agent()
BEGIN
	IF (@id_role_type_mass_add_user_to_role = 5)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id_mass_add_user_to_role, @group_id_show_to_agent, 0, 0)
				;

			# Log the actions of the script.
				SET @script_mass_add_user_to_role_log_message = CONCAT('the bz user #'
										, @bz_user_id_mass_add_user_to_role
										, ' CAN see case that are limited to agents'
										, ' for the unit #'
										, @product_id_mass_add_user_to_role
										, '.'
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script_mass_add_user_to_role, @script_mass_add_user_to_role_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table_mass_add_user_to_role = 'ut_user_group_map_temp';
				SET @permission_granted_mass_add_user_to_role = 'CAN see case that are limited to agents.';

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
					 (NOW() ,@bzfe_table_mass_add_user_to_role, 'user_id', 'UNKNOWN', @bz_user_id_mass_add_user_to_role, @script_mass_add_user_to_role, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'group_id', 'UNKNOWN', @group_id_show_to_agent, @script_mass_add_user_to_role, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'isbless', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user does NOT grant ',@permission_granted_mass_add_user_to_role, ' permission'))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'grant_type', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user is a member of the group', @permission_granted_mass_add_user_to_role))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_mass_add_user_to_role_log_message = NULL;
				SET @bzfe_table_mass_add_user_to_role = NULL;
				SET @permission_granted_mass_add_user_to_role = NULL;
END IF ;
END $$
DELIMITER ;	
	
		# User is an agent for the unit:
DROP PROCEDURE IF EXISTS are_users_agent;
DELIMITER $$
CREATE PROCEDURE are_users_agent()
BEGIN
	IF (@id_role_type_mass_add_user_to_role = 5)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id_mass_add_user_to_role, @group_id_are_users_agent, 0, 0)
				;

			# Log the actions of the script.
				SET @script_mass_add_user_to_role_log_message = CONCAT('the bz user #'
										, @bz_user_id_mass_add_user_to_role
										, ' is an agent for the unit #'
										, @product_id_mass_add_user_to_role
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script_mass_add_user_to_role, @script_mass_add_user_to_role_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table_mass_add_user_to_role = 'ut_user_group_map_temp';
				SET @permission_granted_mass_add_user_to_role = 'is an agent.';

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
					 (NOW() ,@bzfe_table_mass_add_user_to_role, 'user_id', 'UNKNOWN', @bz_user_id_mass_add_user_to_role, @script_mass_add_user_to_role, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'group_id', 'UNKNOWN', @group_id_are_users_agent, @script_mass_add_user_to_role, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'isbless', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user does NOT grant ',@permission_granted_mass_add_user_to_role, ' permission'))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'grant_type', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user is a member of the group', @permission_granted_mass_add_user_to_role))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_mass_add_user_to_role_log_message = NULL;
				SET @bzfe_table_mass_add_user_to_role = NULL;
				SET @permission_granted_mass_add_user_to_role = NULL;
END IF ;
END $$
DELIMITER ;

		# User can see all the agents in the unit:
DROP PROCEDURE IF EXISTS default_agent_see_users_agent;
DELIMITER $$
CREATE PROCEDURE default_agent_see_users_agent()
BEGIN
	IF (@id_role_type_mass_add_user_to_role = 5)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id_mass_add_user_to_role, @group_id_see_users_agent, 0, 0)
				;

			# Log the actions of the script.
				SET @script_mass_add_user_to_role_log_message = CONCAT('the bz user #'
										, @bz_user_id_mass_add_user_to_role
										, ' can see agents for the unit '
										, @product_id_mass_add_user_to_role
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script_mass_add_user_to_role, @script_mass_add_user_to_role_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table_mass_add_user_to_role = 'ut_user_group_map_temp';
				SET @permission_granted_mass_add_user_to_role = 'can see agents for the unit.';

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
					 (NOW() ,@bzfe_table_mass_add_user_to_role, 'user_id', 'UNKNOWN', @bz_user_id_mass_add_user_to_role, @script_mass_add_user_to_role, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'group_id', 'UNKNOWN', @group_id_see_users_agent, @script_mass_add_user_to_role, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'isbless', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user does NOT grant ',@permission_granted_mass_add_user_to_role, ' permission'))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'grant_type', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user is a member of the group', @permission_granted_mass_add_user_to_role))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_mass_add_user_to_role_log_message = NULL;
				SET @bzfe_table_mass_add_user_to_role = NULL;
				SET @permission_granted_mass_add_user_to_role = NULL;
END IF ;
END $$
DELIMITER ;

			# User can see the cases for contractor for the unit:
DROP PROCEDURE IF EXISTS show_to_contractor;
DELIMITER $$
CREATE PROCEDURE show_to_contractor()
BEGIN
	IF (@id_role_type_mass_add_user_to_role = 3)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id_mass_add_user_to_role, @group_id_show_to_contractor, 0, 0)
				;

			# Log the actions of the script.
				SET @script_mass_add_user_to_role_log_message = CONCAT('the bz user #'
										, @bz_user_id_mass_add_user_to_role
										, ' CAN see case that are limited to contractors'
										, ' for the unit #'
										, @product_id_mass_add_user_to_role
										, '.'
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script_mass_add_user_to_role, @script_mass_add_user_to_role_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table_mass_add_user_to_role = 'ut_user_group_map_temp';
				SET @permission_granted_mass_add_user_to_role = 'CAN see case that are limited to contractors.';

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
					 (NOW() ,@bzfe_table_mass_add_user_to_role, 'user_id', 'UNKNOWN', @bz_user_id_mass_add_user_to_role, @script_mass_add_user_to_role, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'group_id', 'UNKNOWN', @group_id_show_to_contractor, @script_mass_add_user_to_role, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'isbless', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user does NOT grant ',@permission_granted_mass_add_user_to_role, ' permission'))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'grant_type', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user is a member of the group', @permission_granted_mass_add_user_to_role))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_mass_add_user_to_role_log_message = NULL;
				SET @bzfe_table_mass_add_user_to_role = NULL;
				SET @permission_granted_mass_add_user_to_role = NULL;
END IF ;
END $$
DELIMITER ;	
	
		# User is a contractor for the unit:
DROP PROCEDURE IF EXISTS are_users_contractor;
DELIMITER $$
CREATE PROCEDURE are_users_contractor()
BEGIN
	IF (@id_role_type_mass_add_user_to_role = 3)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id_mass_add_user_to_role, @group_id_are_users_contractor, 0, 0)
				;

			# Log the actions of the script.
				SET @script_mass_add_user_to_role_log_message = CONCAT('the bz user #'
										, @bz_user_id_mass_add_user_to_role
										, ' is a contractor for the unit #'
										, @product_id_mass_add_user_to_role
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script_mass_add_user_to_role, @script_mass_add_user_to_role_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table_mass_add_user_to_role = 'ut_user_group_map_temp';
				SET @permission_granted_mass_add_user_to_role = 'is a contractor.';

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
					 (NOW() ,@bzfe_table_mass_add_user_to_role, 'user_id', 'UNKNOWN', @bz_user_id_mass_add_user_to_role, @script_mass_add_user_to_role, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'group_id', 'UNKNOWN', @group_id_are_users_contractor, @script_mass_add_user_to_role, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'isbless', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user does NOT grant ',@permission_granted_mass_add_user_to_role, ' permission'))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'grant_type', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user is a member of the group', @permission_granted_mass_add_user_to_role))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_mass_add_user_to_role_log_message = NULL;
				SET @bzfe_table_mass_add_user_to_role = NULL;
				SET @permission_granted_mass_add_user_to_role = NULL;
END IF ;
END $$
DELIMITER ;

		# User can see all the agents in the unit:
DROP PROCEDURE IF EXISTS default_contractor_see_users_contractor;
DELIMITER $$
CREATE PROCEDURE default_contractor_see_users_contractor()
BEGIN
	IF (@id_role_type_mass_add_user_to_role = 3)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id_mass_add_user_to_role, @group_id_see_users_contractor, 0, 0)
				;

			# Log the actions of the script.
				SET @script_mass_add_user_to_role_log_message = CONCAT('the bz user #'
										, @bz_user_id_mass_add_user_to_role
										, ' can see employee of Contractor for the unit '
										, @product_id_mass_add_user_to_role
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script_mass_add_user_to_role, @script_mass_add_user_to_role_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table_mass_add_user_to_role = 'ut_user_group_map_temp';
				SET @permission_granted_mass_add_user_to_role = 'can see employee of Contractor for the unit.';

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
					 (NOW() ,@bzfe_table_mass_add_user_to_role, 'user_id', 'UNKNOWN', @bz_user_id_mass_add_user_to_role, @script_mass_add_user_to_role, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'group_id', 'UNKNOWN', @group_id_see_users_contractor, @script_mass_add_user_to_role, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'isbless', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user does NOT grant ',@permission_granted_mass_add_user_to_role, ' permission'))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'grant_type', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user is a member of the group', @permission_granted_mass_add_user_to_role))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_mass_add_user_to_role_log_message = NULL;
				SET @bzfe_table_mass_add_user_to_role = NULL;
				SET @permission_granted_mass_add_user_to_role = NULL;
END IF ;
END $$
DELIMITER ;
		
			# User can see the cases for Management Cny for the unit:
DROP PROCEDURE IF EXISTS show_to_mgt_cny;
DELIMITER $$
CREATE PROCEDURE show_to_mgt_cny()
BEGIN
	IF (@id_role_type_mass_add_user_to_role = 4)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id_mass_add_user_to_role, @group_id_show_to_mgt_cny, 0, 0)
				;

			# Log the actions of the script.
				SET @script_mass_add_user_to_role_log_message = CONCAT('the bz user #'
										, @bz_user_id_mass_add_user_to_role
										, ' CAN see case that are limited to Mgt Cny'
										, ' for the unit #'
										, @product_id_mass_add_user_to_role
										, '.'
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script_mass_add_user_to_role, @script_mass_add_user_to_role_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table_mass_add_user_to_role = 'ut_user_group_map_temp';
				SET @permission_granted_mass_add_user_to_role = 'CAN see case that are limited to Mgt Cny.';

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
					 (NOW() ,@bzfe_table_mass_add_user_to_role, 'user_id', 'UNKNOWN', @bz_user_id_mass_add_user_to_role, @script_mass_add_user_to_role, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'group_id', 'UNKNOWN', @group_id_show_to_mgt_cny, @script_mass_add_user_to_role, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'isbless', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user does NOT grant ',@permission_granted_mass_add_user_to_role, ' permission'))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'grant_type', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user is a member of the group', @permission_granted_mass_add_user_to_role))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_mass_add_user_to_role_log_message = NULL;
				SET @bzfe_table_mass_add_user_to_role = NULL;
				SET @permission_granted_mass_add_user_to_role = NULL;
END IF ;
END $$
DELIMITER ;	
	
		# User is a Mgt Cny for the unit:
DROP PROCEDURE IF EXISTS are_users_mgt_cny;
DELIMITER $$
CREATE PROCEDURE are_users_mgt_cny()
BEGIN
	IF (@id_role_type_mass_add_user_to_role = 4)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id_mass_add_user_to_role, @group_id_are_users_mgt_cny, 0, 0)
				;

			# Log the actions of the script.
				SET @script_mass_add_user_to_role_log_message = CONCAT('the bz user #'
										, @bz_user_id_mass_add_user_to_role
										, ' is a Mgt Cny for the unit #'
										, @product_id_mass_add_user_to_role
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script_mass_add_user_to_role, @script_mass_add_user_to_role_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table_mass_add_user_to_role = 'ut_user_group_map_temp';
				SET @permission_granted_mass_add_user_to_role = 'is a Mgt Cny.';

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
					 (NOW() ,@bzfe_table_mass_add_user_to_role, 'user_id', 'UNKNOWN', @bz_user_id_mass_add_user_to_role, @script_mass_add_user_to_role, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'group_id', 'UNKNOWN', @group_id_are_users_mgt_cny, @script_mass_add_user_to_role, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'isbless', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user does NOT grant ',@permission_granted_mass_add_user_to_role, ' permission'))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'grant_type', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user is a member of the group', @permission_granted_mass_add_user_to_role))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_mass_add_user_to_role_log_message = NULL;
				SET @bzfe_table_mass_add_user_to_role = NULL;
				SET @permission_granted_mass_add_user_to_role = NULL;
END IF ;
END $$
DELIMITER ;

		# User can see all the employee of the Mgt Cny for the unit:
DROP PROCEDURE IF EXISTS default_mgt_cny_see_users_mgt_cny;
DELIMITER $$
CREATE PROCEDURE default_mgt_cny_see_users_mgt_cny()
BEGIN
	IF (@id_role_type_mass_add_user_to_role = 4)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id_mass_add_user_to_role, @group_id_see_users_mgt_cny, 0, 0)
				;

			# Log the actions of the script.
				SET @script_mass_add_user_to_role_log_message = CONCAT('the bz user #'
										, @bz_user_id_mass_add_user_to_role
										, ' can see Mgt Cny for the unit '
										, @product_id_mass_add_user_to_role
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script_mass_add_user_to_role, @script_mass_add_user_to_role_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table_mass_add_user_to_role = 'ut_user_group_map_temp';
				SET @permission_granted_mass_add_user_to_role = 'can see Mgt Cny for the unit.';

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
					 (NOW() ,@bzfe_table_mass_add_user_to_role, 'user_id', 'UNKNOWN', @bz_user_id_mass_add_user_to_role, @script_mass_add_user_to_role, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'group_id', 'UNKNOWN', @group_id_see_users_mgt_cny, @script_mass_add_user_to_role, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'isbless', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user does NOT grant ',@permission_granted_mass_add_user_to_role, ' permission'))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'grant_type', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user is a member of the group', @permission_granted_mass_add_user_to_role))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_mass_add_user_to_role_log_message = NULL;
				SET @bzfe_table_mass_add_user_to_role = NULL;
				SET @permission_granted_mass_add_user_to_role = NULL;
END IF ;
END $$
DELIMITER ;

		# User is an occupant in the unit:
DROP PROCEDURE IF EXISTS show_to_occupant;
DELIMITER $$
CREATE PROCEDURE show_to_occupant()
BEGIN
	IF (@is_occupant_mass_add_user_to_role = 1)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id_mass_add_user_to_role, @group_id_show_to_occupant, 0, 0)
				;

			# Log the actions of the script.
				SET @script_mass_add_user_to_role_log_message = CONCAT('the bz user #'
										, @bz_user_id_mass_add_user_to_role
										, ' CAN see case that are limited to occupants'
										, ' for the unit #'
										, @product_id_mass_add_user_to_role
										, '.'
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script_mass_add_user_to_role, @script_mass_add_user_to_role_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table_mass_add_user_to_role = 'ut_user_group_map_temp';
				SET @permission_granted_mass_add_user_to_role = 'CAN see case that are limited to occupants.';

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
					 (NOW() ,@bzfe_table_mass_add_user_to_role, 'user_id', 'UNKNOWN', @bz_user_id_mass_add_user_to_role, @script_mass_add_user_to_role, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'group_id', 'UNKNOWN', @group_id_show_to_occupant, @script_mass_add_user_to_role, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'isbless', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user does NOT grant ',@permission_granted_mass_add_user_to_role, ' permission'))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'grant_type', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user is a member of the group', @permission_granted_mass_add_user_to_role))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_mass_add_user_to_role_log_message = NULL;
				SET @bzfe_table_mass_add_user_to_role = NULL;
				SET @permission_granted_mass_add_user_to_role = NULL;
END IF ;
END $$
DELIMITER ;	
	
		# User is an occupant in the unit:
DROP PROCEDURE IF EXISTS is_occupant;
DELIMITER $$
CREATE PROCEDURE is_occupant()
BEGIN
	IF (@is_occupant_mass_add_user_to_role = 1)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id_mass_add_user_to_role, @group_id_are_users_occupant, 0, 0)
				;

			# Log the actions of the script.
				SET @script_mass_add_user_to_role_log_message = CONCAT('the bz user #'
										, @bz_user_id_mass_add_user_to_role
										, ' is an occupant in the unit #'
										, @product_id_mass_add_user_to_role
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script_mass_add_user_to_role, @script_mass_add_user_to_role_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table_mass_add_user_to_role = 'ut_user_group_map_temp';
				SET @permission_granted_mass_add_user_to_role = 'is an occupant.';

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
					 (NOW() ,@bzfe_table_mass_add_user_to_role, 'user_id', 'UNKNOWN', @bz_user_id_mass_add_user_to_role, @script_mass_add_user_to_role, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'group_id', 'UNKNOWN', @group_id_are_users_occupant, @script_mass_add_user_to_role, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'isbless', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user does NOT grant ',@permission_granted_mass_add_user_to_role, ' permission'))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'grant_type', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user is a member of the group', @permission_granted_mass_add_user_to_role))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_mass_add_user_to_role_log_message = NULL;
				SET @bzfe_table_mass_add_user_to_role = NULL;
				SET @permission_granted_mass_add_user_to_role = NULL;
END IF ;
END $$
DELIMITER ;

		# User can see all the occupants in the unit:
DROP PROCEDURE IF EXISTS default_occupant_can_see_occupant;
DELIMITER $$
CREATE PROCEDURE default_occupant_can_see_occupant()
BEGIN
	IF (@is_occupant_mass_add_user_to_role = 1)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id_mass_add_user_to_role, @group_id_see_users_occupant, 0, 0)
				;

			# Log the actions of the script.
				SET @script_mass_add_user_to_role_log_message = CONCAT('the bz user #'
										, @bz_user_id_mass_add_user_to_role
										, ' can see occupant in the unit '
										, @product_id_mass_add_user_to_role
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script_mass_add_user_to_role, @script_mass_add_user_to_role_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table_mass_add_user_to_role = 'ut_user_group_map_temp';
				SET @permission_granted_mass_add_user_to_role = 'can see occupant in the unit.';

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
					 (NOW() ,@bzfe_table_mass_add_user_to_role, 'user_id', 'UNKNOWN', @bz_user_id_mass_add_user_to_role, @script_mass_add_user_to_role, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'group_id', 'UNKNOWN', @group_id_see_users_occupant, @script_mass_add_user_to_role, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'isbless', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user does NOT grant ',@permission_granted_mass_add_user_to_role, ' permission'))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'grant_type', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user is a member of the group', @permission_granted_mass_add_user_to_role))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_mass_add_user_to_role_log_message = NULL;
				SET @bzfe_table_mass_add_user_to_role = NULL;
				SET @permission_granted_mass_add_user_to_role = NULL;
END IF ;
END $$
DELIMITER ;

# We have all the elements we need, we can create the procedure to loop around the records to process
	
/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

DELIMITER &&
DROP PROCEDURE IF EXISTS mass_add_user_to_role&&
CREATE PROCEDURE mass_add_user_to_role()
BEGIN
DECLARE number_of_loops INT DEFAULT 1;
WHILE number_of_loops < (@max_loops_mass_add_user_to_role +1) DO

# The record that we need to process in this loop
	SET @record_to_process_mass_add_user_to_role = (SELECT `add_user_to_role_record_to_process_id` FROM `ut_temp_data_to_add_user_to_a_role` WHERE `token_mass_add_user_to_role` = number_of_loops);

# Timestamp	
	SET @timestamp = NOW();

# The procedure to create the units which exist in the table 'ut_data_to_create_units'
	
# The unit:
	
	# The name and description
		SET @product_id_mass_add_user_to_role = (SELECT `bz_unit_id` FROM `ut_data_to_add_user_to_a_role` WHERE `id` = @record_to_process_mass_add_user_to_role);

# The user who you want to associate to the first role in this unit.	

	# BZ user id of the user that is creating the unit (default is 1 - Administrator).
		SET @creator_bz_id_mass_add_user_to_role = (SELECT `bzfe_invitor_user_id` FROM `ut_data_to_add_user_to_a_role` WHERE `id` = @record_to_process_mass_add_user_to_role);

	# BZ user id of the user that you want to associate to the unit.
		SET @bz_user_id_mass_add_user_to_role = (SELECT `bz_user_id` FROM `ut_data_to_add_user_to_a_role` WHERE `id` = @record_to_process_mass_add_user_to_role);
	
	# Role of the user associated to this new unit:
	#	- Tenant 1
	# 	- Landlord 2
	#	- Agent 5
	#	- Contractor 3
	#	- Management company 4
		SET @id_role_type_mass_add_user_to_role = (SELECT `user_role_type_id` FROM `ut_data_to_add_user_to_a_role` WHERE `id` = @record_to_process_mass_add_user_to_role);
		SET @role_user_more_mass_add_user_to_role = (SELECT `user_more` FROM `ut_data_to_add_user_to_a_role` WHERE `id` = @record_to_process_mass_add_user_to_role);

	# Is the BZ user an occupant of the unit?
		SET @is_occupant_mass_add_user_to_role = (SELECT `is_occupant` FROM `ut_data_to_add_user_to_a_role` WHERE `id` = @record_to_process_mass_add_user_to_role);

# The Groups to grant the global permissions for the user

	# This should not change, it was hard coded when we created Unee-T
		# See time tracking
		SET @can_see_time_tracking_group_id = 16;
		# Can create shared queries
		SET @can_create_shared_queries_group_id = 17;
		# Can tag comments
		SET @can_tag_comment_group_id = 18;	
		
# We populate the additional variables that we will need for this script to work
	
	# For the user
		SET @role_user_g_description = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=@id_role_type_mass_add_user_to_role);
		SET @user_pub_name = (SELECT (LEFT(`login_name`,INSTR(`login_name`,"@")-1)) FROM `profiles` WHERE `userid` = @bz_user_id_mass_add_user_to_role);
		SET @role_user_pub_info = CONCAT(@user_pub_name
								, IF (@role_user_more_mass_add_user_to_role = '', '', ' - ')
								, IF (@role_user_more_mass_add_user_to_role = '', '', @role_user_more_mass_add_user_to_role)
								)
								;
		SET @user_role_desc = (CONCAT(@role_user_g_description, ' - ',@role_user_pub_info));

	# For the creator
		SET @creator_pub_name = (SELECT `realname` FROM `profiles` WHERE `userid` = @creator_bz_id_mass_add_user_to_role);

# We get the information about the goups we need
	# We need to ge these from the ut_product_table_based on the product_id!
		SET @create_case_group_id =  (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id_mass_add_user_to_role AND `group_type_id` = 20));
		SET @can_edit_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id_mass_add_user_to_role AND `group_type_id` = 25));
		SET @can_see_cases_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id_mass_add_user_to_role AND `group_type_id` = 28));
		
		# This is needed until MEFE is able to handle more detailed permissions.
		SET @can_edit_all_field_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id_mass_add_user_to_role AND `group_type_id` = 26));
		
		# This is needed so that user can see the unit in the Search panel
		SET @can_see_unit_in_search_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id_mass_add_user_to_role AND `group_type_id` = 38));

		SET @list_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id_mass_add_user_to_role AND `group_type_id` = 4));
		SET @see_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id_mass_add_user_to_role AND `group_type_id` = 5));	

		SET @all_r_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id_mass_add_user_to_role AND `group_type_id` = 18));
		SET @all_g_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id_mass_add_user_to_role AND `group_type_id` = 19));
		
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

		SET @group_id_show_to_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id_mass_add_user_to_role AND `group_type_id` = 24));
		SET @group_id_are_users_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id_mass_add_user_to_role AND `group_type_id` = 3));
		SET @group_id_see_users_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id_mass_add_user_to_role AND `group_type_id` = 36));

		SET @group_id_show_to_tenant_mass_add_user_to_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id_mass_add_user_to_role AND `group_type_id` = 2 AND `role_type_id` = 1));
		SET @group_id_are_users_tenant_mass_add_user_to_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id_mass_add_user_to_role AND `group_type_id` = 22 AND `role_type_id` = 1));
		SET @group_id_see_users_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id_mass_add_user_to_role AND `group_type_id` = 37 AND `role_type_id` = 1));

		SET @group_id_show_to_landlord_mass_add_user_to_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id_mass_add_user_to_role AND `group_type_id` = 2 AND `role_type_id` = 2));
		SET @group_id_are_users_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id_mass_add_user_to_role AND `group_type_id` = 22 AND `role_type_id` = 2));
		SET @group_id_see_users_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id_mass_add_user_to_role AND `group_type_id` = 37 AND `role_type_id` = 2));

		SET @group_id_show_to_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id_mass_add_user_to_role AND `group_type_id` = 2 AND `role_type_id` = 5));
		SET @group_id_are_users_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id_mass_add_user_to_role AND `group_type_id` = 22 AND `role_type_id` = 5));
		SET @group_id_see_users_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id_mass_add_user_to_role AND `group_type_id` = 37 AND `role_type_id` = 5));

		SET @group_id_show_to_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id_mass_add_user_to_role AND `group_type_id` = 2 AND `role_type_id` = 3));
		SET @group_id_are_users_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id_mass_add_user_to_role AND `group_type_id` = 22 AND `role_type_id` = 3));
		SET @group_id_see_users_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id_mass_add_user_to_role AND `group_type_id` = 37 AND `role_type_id` = 3));

		SET @group_id_show_to_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id_mass_add_user_to_role AND `group_type_id` = 2 AND `role_type_id` = 4));
		SET @group_id_are_users_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id_mass_add_user_to_role AND `group_type_id` = 22 AND `role_type_id` = 4));
		SET @group_id_see_users_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id_mass_add_user_to_role AND `group_type_id` = 37 AND `role_type_id` = 4));

# We get the information about the component/roles that were created:
	
	# We get that from the ut_product_group table.
		SET @component_id_this_role = (SELECT `component_id` 
									FROM `ut_product_group` 
									WHERE `product_id` = @product_id_mass_add_user_to_role 
										AND `role_type_id` = @id_role_type_mass_add_user_to_role
										AND `group_type_id` = 2)
										;
		
# Variable needed to avoid script error - NEED TO REVISIT THAT
	SET @can_see_time_tracking = 1;
	SET @can_create_shared_queries = 1;
	SET @can_tag_comment = 1;
	SET @user_is_publicly_visible = 1;
	SET @user_can_see_publicly_visible = 1;
	SET @user_in_cc_for_cases = 0;
	SET @can_create_new_cases = 1;
	SET @can_edit_a_case = 1;
	SET @can_see_all_public_cases = 1;
	SET @can_edit_all_field_in_a_case_regardless_of_role = 1;
	SET @can_ask_to_approve = 1;
	SET @can_approve = 1;
	SET @can_create_any_stakeholder = 0;
	SET @can_create_same_stakeholder = 0;
	SET @can_approve_user_for_flag = 0;
	SET @can_decide_if_user_is_visible = 0;
	SET @can_decide_if_user_can_see_visible = 0;

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
			, @creator_bz_id_mass_add_user_to_role
			, @bz_user_id_mass_add_user_to_role
			, @bz_user_id_mass_add_user_to_role
			, @product_id_mass_add_user_to_role
			, @id_role_type_mass_add_user_to_role
			# Global permission for the whole installation
			, @can_see_time_tracking
			, @can_create_shared_queries
			, @can_tag_comment
			# Attributes of the user
			, @is_occupant_mass_add_user_to_role
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
			, @role_user_more_mass_add_user_to_role
			, CONCAT('On ', NOW(), ': Created with the script - ', @script_mass_add_user_to_role, '.\r\ ', `comment`)
			)
			ON DUPLICATE KEY UPDATE
			`created` = NOW()
			, `record_created_by` = @creator_bz_id_mass_add_user_to_role
			, `role_type_id` = @id_role_type_mass_add_user_to_role
			, `can_see_time_tracking` = @can_see_time_tracking
			, `can_create_shared_queries` = @can_create_shared_queries
			, `can_tag_comment` = @can_tag_comment
			, `is_occupant` = @is_occupant_mass_add_user_to_role
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
			, `more_info` = CONCAT('On: ', NOW(), '.\r\Updated to ', @role_user_more_mass_add_user_to_role, '. \r\ ', `more_info`)
			, `comment` = CONCAT('On ', NOW(), '.\r\Updated with the script - ', @script_mass_add_user_to_role, '.\r\ ', `comment`)
		;

# We add the user to the list of user that will be in CC when there in a new case for this unit and role type:
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
				(@bz_user_id_mass_add_user_to_role, @component_id_this_role)
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
			SET @script_mass_add_user_to_role_log_message = CONCAT('the bz user #'
									, @bz_user_id_mass_add_user_to_role
									, ' is one of the copied assignee for the unit #'
									, @product_id_mass_add_user_to_role
									, ' when the role '
									, @role_user_g_description
									, ' (the component #'
									, @component_id_this_role
									, ')'
									, ' is chosen'
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(NOW(), @script_mass_add_user_to_role, @script_mass_add_user_to_role_log_message)
				;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table_mass_add_user_to_role = 'component_cc';
				SET @permission_granted_mass_add_user_to_role = ' is in CC when role is chosen.';

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
					 (NOW() ,@bzfe_table_mass_add_user_to_role, 'user_id', 'UNKNOWN', @bz_user_id_mass_add_user_to_role, @script_mass_add_user_to_role, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'component_id', 'UNKNOWN', @component_id_this_role, @script_mass_add_user_to_role, CONCAT('Make sure the user ', @permission_granted_mass_add_user_to_role))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_mass_add_user_to_role_log_message = NULL;
				SET @bzfe_table_mass_add_user_to_role = NULL;
				SET @permission_granted_mass_add_user_to_role = NULL;	

# We update the BZ logs 
# NOT NEEDED - BZ DOES NOT LOG THESE EVENTS		
		
# We now assign the default permissions to the user we just associated to this role:		
	
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

		# Add all the records that exists in the table user_group_map
		INSERT INTO `ut_user_group_map_temp`
			SELECT *
			FROM `user_group_map`;

# The default permissions for a user assigned as default for a role are:
#
#	- time_tracking_permission
#	- can_create_shared_queries
#	- can_tag_comment
#
#	- can_create_new_cases
#	- can_edit_a_case
#	- can_edit_all_field_case
#	- can_see_unit_in_search
#	- can_see_all_public_cases
#	- user_is_publicly_visible
#	- user_can_see_publicly_visible
#	- can_ask_to_approve (all_r_flags_group_id)
#	- can_approve (all_g_flags_group_id)
#
# We create the procedures that will grant the permissions based on the variables from this script.	
#
#	- show_to_his_role
#	- is_one_of_his_role
#	- can_see_other_in_same_role
#
# If applicable
#	- show_to_occupant
#	- is_occupant
#	- can_see_occupant

	# We make sure that we remove all the permission that we had previously created for this user and for this product
	# This is to make sure that we are starting from a fresh start...
		DELETE FROM `ut_user_group_map_temp`
			WHERE (
				(`user_id` = @bz_user_id_mass_add_user_to_role AND `group_id` = @can_see_time_tracking_group_id)
				OR (`user_id` = @bz_user_id_mass_add_user_to_role AND `group_id` = @can_create_shared_queries_group_id)
				OR (`user_id` = @bz_user_id_mass_add_user_to_role AND `group_id` = @can_tag_comment_group_id)
				OR (`user_id` = @bz_user_id_mass_add_user_to_role AND `group_id` = @create_case_group_id)
				OR (`user_id` = @bz_user_id_mass_add_user_to_role AND `group_id` = @can_edit_case_group_id)
				OR (`user_id` = @bz_user_id_mass_add_user_to_role AND `group_id` = @can_edit_component_group_id)
				OR (`user_id` = @bz_user_id_mass_add_user_to_role AND `group_id` = @can_see_cases_group_id)
				OR (`user_id` = @bz_user_id_mass_add_user_to_role AND `group_id` = @can_edit_all_field_case_group_id)
				OR (`user_id` = @bz_user_id_mass_add_user_to_role AND `group_id` = @can_see_unit_in_search_group_id)
				OR (`user_id` = @bz_user_id_mass_add_user_to_role AND `group_id` = @all_r_flags_group_id)
				OR (`user_id` = @bz_user_id_mass_add_user_to_role AND `group_id` = @all_g_flags_group_id)
				OR (`user_id` = @bz_user_id_mass_add_user_to_role AND `group_id` = @list_visible_assignees_group_id)
				OR (`user_id` = @bz_user_id_mass_add_user_to_role AND `group_id` = @see_visible_assignees_group_id)
				OR (`user_id` = @bz_user_id_mass_add_user_to_role AND `group_id` = @group_id_show_to_occupant)
				OR (`user_id` = @bz_user_id_mass_add_user_to_role AND `group_id` = @group_id_are_users_occupant)
				OR (`user_id` = @bz_user_id_mass_add_user_to_role AND `group_id` = @group_id_see_users_occupant)
				OR (`user_id` = @bz_user_id_mass_add_user_to_role AND `group_id` = @group_id_show_to_tenant_mass_add_user_to_role)
				OR (`user_id` = @bz_user_id_mass_add_user_to_role AND `group_id` = @group_id_are_users_tenant_mass_add_user_to_role)
				OR (`user_id` = @bz_user_id_mass_add_user_to_role AND `group_id` = @group_id_see_users_tenant)
				OR (`user_id` = @bz_user_id_mass_add_user_to_role AND `group_id` = @group_id_show_to_landlord_mass_add_user_to_role)
				OR (`user_id` = @bz_user_id_mass_add_user_to_role AND `group_id` = @group_id_are_users_landlord)
				OR (`user_id` = @bz_user_id_mass_add_user_to_role AND `group_id` = @group_id_see_users_landlord)
				OR (`user_id` = @bz_user_id_mass_add_user_to_role AND `group_id` = @group_id_show_to_agent)
				OR (`user_id` = @bz_user_id_mass_add_user_to_role AND `group_id` = @group_id_are_users_agent)
				OR (`user_id` = @bz_user_id_mass_add_user_to_role AND `group_id` = @group_id_see_users_agent)
				OR (`user_id` = @bz_user_id_mass_add_user_to_role AND `group_id` = @group_id_show_to_contractor)
				OR (`user_id` = @bz_user_id_mass_add_user_to_role AND `group_id` = @group_id_are_users_contractor)
				OR (`user_id` = @bz_user_id_mass_add_user_to_role AND `group_id` = @group_id_see_users_contractor)
				OR (`user_id` = @bz_user_id_mass_add_user_to_role AND `group_id` = @group_id_show_to_mgt_cny)
				OR (`user_id` = @bz_user_id_mass_add_user_to_role AND `group_id` = @group_id_are_users_mgt_cny)
				OR (`user_id` = @bz_user_id_mass_add_user_to_role AND `group_id` = @group_id_see_users_mgt_cny)
				)
				;
						
			# Log the actions of the script.
				SET @script_mass_add_user_to_role_log_message = CONCAT('We have revoked all the permissions for the bz user #'
										, @bz_user_id_mass_add_user_to_role
										, '\r\- can_see_time_tracking: 0'
										, '\r\- can_create_shared_queries: 0'
										, '\r\- can_tag_comment: 0'
										, '\r\- can_create_case: 0'
										, '\r\- can_edit_a_case: 0'
										, '\r\- can_edit_component: 0'
										, '\r\- can_see_cases: 0'
										, '\r\- can_edit_all_field_in_a_case_regardless_of_role: 0'
										, '\r\- can_see_unit_in_search: 0'
										, '\r\- can_ask_to_approve: 0'
										, '\r\- can_approve: 0'
										, '\r\- user_can_see_publicly_visible: 0'
										, '\r\- user_is_publicly_visible: 0'
										, '\r\- show_to_occupant: 0'
										, '\r\- are_users_occupant: 0'
										, '\r\- see_users_occupant: 0'
										, '\r\- show_to_tenant: 0'
										, '\r\- are_users_tenant: 0'
										, '\r\- see_users_tenant: 0'
										, '\r\- show_to_landlord: 0'
										, '\r\- are_users_landlord: 0'
										, '\r\- see_users_landlord: 0'
										, '\r\- show_to_agent: 0'
										, '\r\- are_users_agent: 0'
										, '\r\- see_users_agent: 0'
										, '\r\- show_to_contractor: 0'
										, '\r\- are_users_contractor: 0'
										, '\r\- see_users_contractor: 0'
										, '\r\- show_to_mgt_cny: 0'
										, '\r\- are_users_mgt_cny: 0'
										, '\r\- see_users_mgt_cny: 0'
										, '\r\For the product #'
										, @product_id_mass_add_user_to_role										
										);
			
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script_mass_add_user_to_role, @script_mass_add_user_to_role_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table_mass_add_user_to_role = 'ut_user_group_map_temp';
				
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
					 (NOW() 
						,@bzfe_table_mass_add_user_to_role
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script_mass_add_user_to_role
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id_mass_add_user_to_role
						, ' the group id = '
						, @can_see_time_tracking_group_id
						, '.')
						)
					 , (NOW() 
						,@bzfe_table_mass_add_user_to_role
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script_mass_add_user_to_role
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id_mass_add_user_to_role
						, ' the group id = '
						, @can_create_shared_queries_group_id
						, '.')
						)
					 , (NOW() 
						,@bzfe_table_mass_add_user_to_role
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script_mass_add_user_to_role
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id_mass_add_user_to_role
						, ' the group id = '
						, @can_tag_comment_group_id
						, '.')
						)
					 , (NOW() 
						,@bzfe_table_mass_add_user_to_role
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script_mass_add_user_to_role
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id_mass_add_user_to_role
						, ' the group id = '
						, (SELECT IFNULL(@create_case_group_id, 'create_case_group_id is NULL'))
						, '.')
						)
					 , (NOW() 
						,@bzfe_table_mass_add_user_to_role
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script_mass_add_user_to_role
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id_mass_add_user_to_role
						, ' the group id = '
						, (SELECT IFNULL(@can_edit_case_group_id, 'can_edit_case_group_id is NULL'))
						, '.')
						)
					 , (NOW() 
						,@bzfe_table_mass_add_user_to_role
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script_mass_add_user_to_role
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id_mass_add_user_to_role
						, ' the group id = '
						, (SELECT IFNULL(@can_edit_component_group_id, 'can_edit_component_group_id is NULL'))
						, '.')
						)
					 , (NOW() 
						,@bzfe_table_mass_add_user_to_role
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script_mass_add_user_to_role
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id_mass_add_user_to_role
						, ' the group id = '
						, (SELECT IFNULL(@can_see_cases_group_id, 'can_see_cases_group_id is NULL'))
						, '.')
						)
					 , (NOW() 
						,@bzfe_table_mass_add_user_to_role
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script_mass_add_user_to_role
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id_mass_add_user_to_role
						, ' the group id = '
						, (SELECT IFNULL(@can_edit_all_field_case_group_id, 'can_edit_all_field_case_group_id is NULL'))
						, '.')
						)
					 , (NOW() 
						,@bzfe_table_mass_add_user_to_role
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script_mass_add_user_to_role
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id_mass_add_user_to_role
						, ' the group id = '
						, (SELECT IFNULL(@can_see_unit_in_search_group_id, 'can_see_unit_in_search_group_id is NULL'))
						, '.')
						)
					 , (NOW() 
						,@bzfe_table_mass_add_user_to_role
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script_mass_add_user_to_role
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id_mass_add_user_to_role
						, ' the group id = '
						, (SELECT IFNULL(@all_r_flags_group_id, 'all_r_flags_group_id is NULL'))
						, '.')
						)
					 , (NOW() 
						,@bzfe_table_mass_add_user_to_role
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script_mass_add_user_to_role
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id_mass_add_user_to_role
						, ' the group id = '
						, (SELECT IFNULL(@all_g_flags_group_id, 'all_g_flags_group_id is NULL'))
						, '.')
						)
					, (NOW() 
						,@bzfe_table_mass_add_user_to_role
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script_mass_add_user_to_role
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id_mass_add_user_to_role
						, ' the group id = '
						, (SELECT IFNULL(@list_visible_assignees_group_id, 'list_visible_assignees_group_id is NULL'))
						, '.')
						)
					 , (NOW() 
						,@bzfe_table_mass_add_user_to_role
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script_mass_add_user_to_role
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id_mass_add_user_to_role
						, ' the group id = '
						, (SELECT IFNULL(@see_visible_assignees_group_id, 'see_visible_assignees_group_id is NULL'))
						, '.')
						)
					, (NOW() 
						,@bzfe_table_mass_add_user_to_role
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script_mass_add_user_to_role
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id_mass_add_user_to_role
						, ' the group id = '
						, (SELECT IFNULL(@group_id_show_to_occupant, 'group_id_show_to_occupant is NULL'))
						, '.')
						)
					 , (NOW() 
						,@bzfe_table_mass_add_user_to_role
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script_mass_add_user_to_role
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id_mass_add_user_to_role
						, ' the group id = '
						, (SELECT IFNULL(@group_id_are_users_occupant, 'group_id_are_users_occupant is NULL'))
						, '.')
						)
					, (NOW() 
						,@bzfe_table_mass_add_user_to_role
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script_mass_add_user_to_role
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id_mass_add_user_to_role
						, ' the group id = '
						, (SELECT IFNULL(@group_id_see_users_occupant, 'group_id_see_users_occupant is NULL'))
						, '.')
						)
					 , (NOW() 
						,@bzfe_table_mass_add_user_to_role
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script_mass_add_user_to_role
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id_mass_add_user_to_role
						, ' the group id = '
						, (SELECT IFNULL(@group_id_show_to_tenant_mass_add_user_to_role, 'group_id_show_to_tenant is NULL'))
						, '.')
						)
					, (NOW() 
						,@bzfe_table_mass_add_user_to_role
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script_mass_add_user_to_role
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id_mass_add_user_to_role
						, ' the group id = '
						, (SELECT IFNULL(@group_id_are_users_tenant_mass_add_user_to_role, 'group_id_are_users_tenant is NULL'))
						, '.')
						)
					 , (NOW() 
						,@bzfe_table_mass_add_user_to_role
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script_mass_add_user_to_role
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id_mass_add_user_to_role
						, ' the group id = '
						, (SELECT IFNULL(@group_id_see_users_tenant, 'group_id_see_users_tenant is NULL'))
						, '.')
						)
					, (NOW() 
						,@bzfe_table_mass_add_user_to_role
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script_mass_add_user_to_role
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id_mass_add_user_to_role
						, ' the group id = '
						, (SELECT IFNULL(@group_id_show_to_landlord_mass_add_user_to_role, 'group_id_show_to_landlord is NULL'))
						, '.')
						)
					 , (NOW() 
						,@bzfe_table_mass_add_user_to_role
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script_mass_add_user_to_role
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id_mass_add_user_to_role
						, ' the group id = '
						, (SELECT IFNULL(@group_id_are_users_landlord, 'group_id_are_users_landlord is NULL'))
						, '.')
						)
					 , (NOW() 
						,@bzfe_table_mass_add_user_to_role
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script_mass_add_user_to_role
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id_mass_add_user_to_role
						, ' the group id = '
						, (SELECT IFNULL(@group_id_see_users_landlord, 'group_id_see_users_landlord is NULL'))
						, '.')
						)
					 , (NOW() 
						,@bzfe_table_mass_add_user_to_role
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script_mass_add_user_to_role
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id_mass_add_user_to_role
						, ' the group id = '
						, (SELECT IFNULL(@group_id_show_to_agent, 'group_id_show_to_agent is NULL'))
						, '.')
						)
					 , (NOW() 
						,@bzfe_table_mass_add_user_to_role
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script_mass_add_user_to_role
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id_mass_add_user_to_role
						, ' the group id = '
						, (SELECT IFNULL(@group_id_are_users_agent, 'group_id_are_users_agent is NULL'))
						, '.')
						)
					 , (NOW() 
						,@bzfe_table_mass_add_user_to_role
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script_mass_add_user_to_role
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id_mass_add_user_to_role
						, ' the group id = '
						, (SELECT IFNULL(@group_id_see_users_agent, 'group_id_see_users_agent is NULL'))
						, '.')
						)
					 , (NOW() 
						,@bzfe_table_mass_add_user_to_role
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script_mass_add_user_to_role
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id_mass_add_user_to_role
						, ' the group id = '
						, (SELECT IFNULL(@group_id_show_to_contractor, 'group_id_show_to_contractor is NULL'))
						, '.')
						)
					 , (NOW() 
						,@bzfe_table_mass_add_user_to_role
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script_mass_add_user_to_role
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id_mass_add_user_to_role
						, ' the group id = '
						, (SELECT IFNULL(@group_id_are_users_contractor, 'group_id_are_users_contractor is NULL'))
						, '.')
						)
					 , (NOW() 
						,@bzfe_table_mass_add_user_to_role
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script_mass_add_user_to_role
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id_mass_add_user_to_role
						, ' the group id = '
						, (SELECT IFNULL(@group_id_see_users_contractor, 'group_id_see_users_contractor is NULL'))
						, '.')
						)
					 , (NOW() 
						,@bzfe_table_mass_add_user_to_role
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script_mass_add_user_to_role
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id_mass_add_user_to_role
						, ' the group id = '
						, (SELECT IFNULL(@group_id_show_to_mgt_cny, 'group_id_show_to_mgt_cny is NULL'))
						, '.')
						)
					, (NOW() 
						,@bzfe_table_mass_add_user_to_role
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script_mass_add_user_to_role
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id_mass_add_user_to_role
						, ' the group id = '
						, (SELECT IFNULL(@group_id_are_users_mgt_cny, 'group_id_are_users_mgt_cny is NULL'))
						, '.')
						)
					, (NOW() 
						,@bzfe_table_mass_add_user_to_role
						, 'n/a'
						, 'n/a - we delete the record'
						, 'n/a - we delete the record'
						, @script_mass_add_user_to_role
						, CONCAT('Remove the record where BZ user id ='
						, @bz_user_id_mass_add_user_to_role
						, ' the group id = '
						, (SELECT IFNULL(@group_id_see_users_mgt_cny, 'group_id_see_users_mgt_cny is NULL'))
						, '.')
						)
					 ;
				 
			# Cleanup the variables for the log messages
				SET @script_mass_add_user_to_role_log_message = NULL;
				SET @bzfe_table_mass_add_user_to_role = NULL;

	# Now we assign all the default permissions for that user and for that unit
	# First the global permissions:
		# Can see timetracking
			INSERT  INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id_mass_add_user_to_role,@can_see_time_tracking_group_id,0,0)
				;
				
			# Log the actions of the script.
				SET @script_mass_add_user_to_role_log_message = CONCAT('the bz user #'
										, @bz_user_id_mass_add_user_to_role
										, ' CAN See time tracking information.'
										);
			
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script_mass_add_user_to_role, @script_mass_add_user_to_role_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table_mass_add_user_to_role = 'ut_user_group_map_temp';
				
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
					 (NOW() ,@bzfe_table_mass_add_user_to_role, 'user_id', 'UNKNOWN', @bz_user_id_mass_add_user_to_role, @script_mass_add_user_to_role, 'Add the BZ user id when we grant the permission to see time tracking')
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'group_id', 'UNKNOWN', @can_see_time_tracking_group_id, @script_mass_add_user_to_role, 'Add the BZ group id when we grant the permission to see time tracking')
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'isbless', 'UNKNOWN', 0, @script_mass_add_user_to_role, 'user does NOT grant see time tracking permission')
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'grant_type', 'UNKNOWN', 0, @script_mass_add_user_to_role, 'user is a member of the group see time tracking')
					 ;
				 
			# Cleanup the variables for the log messages
				SET @script_mass_add_user_to_role_log_message = NULL;
				SET @bzfe_table_mass_add_user_to_role = NULL;
	
		# Can create shared queries
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id_mass_add_user_to_role,@can_create_shared_queries_group_id,0,0)
				;

			# Log the actions of the script.
				SET @script_mass_add_user_to_role_log_message = CONCAT('the bz user #'
										, @bz_user_id_mass_add_user_to_role
										, ' CAN create shared queries.'
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script_mass_add_user_to_role, @script_mass_add_user_to_role_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table

				SET @bzfe_table_mass_add_user_to_role = 'ut_user_group_map_temp';

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
						 (NOW() ,@bzfe_table_mass_add_user_to_role, 'user_id', 'UNKNOWN', @bz_user_id_mass_add_user_to_role, @script_mass_add_user_to_role, 'Add the BZ user id when we grant the permission to create shared queries')
						 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'group_id', 'UNKNOWN', @can_create_shared_queries_group_id, @script_mass_add_user_to_role, 'Add the BZ group id when we grant the permission to create shared queries')
						 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'isbless', 'UNKNOWN', 0, @script_mass_add_user_to_role, 'user does NOT grant create shared queries permission')
						 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'grant_type', 'UNKNOWN', 0, @script_mass_add_user_to_role, 'user is a member of the group create shared queries')
						 ;
			 
			# Cleanup the variables for the log messages
				SET @script_mass_add_user_to_role_log_message = NULL;
				SET @bzfe_table_mass_add_user_to_role = NULL;

		# Can tag comments
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id_mass_add_user_to_role,@can_tag_comment_group_id,0,0)
				;
				
			# Log the actions of the script.
				SET @script_mass_add_user_to_role_log_message = CONCAT('the bz user #'
										, @bz_user_id_mass_add_user_to_role
										, ' CAN tag comments.'
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script_mass_add_user_to_role, @script_mass_add_user_to_role_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table_mass_add_user_to_role = 'ut_user_group_map_temp';

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
					 (NOW() ,@bzfe_table_mass_add_user_to_role, 'user_id', 'UNKNOWN', @bz_user_id_mass_add_user_to_role, @script_mass_add_user_to_role, 'Add the BZ user id when we grant the permission to tag comments')
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'group_id', 'UNKNOWN', @can_tag_comment_group_id, @script_mass_add_user_to_role, 'Add the BZ group id when we grant the permission to tag comments')
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'isbless', 'UNKNOWN', 0, @script_mass_add_user_to_role, 'user does NOT grant tag comments permission')
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'grant_type', 'UNKNOWN', 0, @script_mass_add_user_to_role, 'user is a member of the group tag comments')
					;
			 
			# Cleanup the variables for the log messages
				SET @script_mass_add_user_to_role_log_message = NULL;
				SET @bzfe_table_mass_add_user_to_role = NULL;
	
	# Then the permissions at the unit/product level:	
					
		# User can create a case:
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				# There can be cases when a user is only allowed to see existing cases but NOT create new one.
				# This is an unlikely scenario, but this is technically possible...
				(@bz_user_id_mass_add_user_to_role, @create_case_group_id, 0, 0)
				;

			# Log the actions of the script.
				SET @script_mass_add_user_to_role_log_message = CONCAT('the bz user #'
										, @bz_user_id_mass_add_user_to_role
										, ' CAN create new cases for unit '
										, @product_id_mass_add_user_to_role
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script_mass_add_user_to_role, @script_mass_add_user_to_role_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table_mass_add_user_to_role = 'ut_user_group_map_temp';
				SET @permission_granted_mass_add_user_to_role = 'create a new case.';

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
					 (NOW() ,@bzfe_table_mass_add_user_to_role, 'user_id', 'UNKNOWN', @bz_user_id_mass_add_user_to_role, @script_mass_add_user_to_role, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'group_id', 'UNKNOWN', @create_case_group_id, @script_mass_add_user_to_role, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'isbless', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user does NOT grant ',@permission_granted_mass_add_user_to_role, ' permission'))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'grant_type', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user is a member of the group', @permission_granted_mass_add_user_to_role))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_mass_add_user_to_role_log_message = NULL;
				SET @bzfe_table_mass_add_user_to_role = NULL;
				SET @permission_granted_mass_add_user_to_role = NULL;
				
		# User is allowed to edit cases
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id_mass_add_user_to_role, @can_edit_case_group_id, 0, 0)	
				;

			# Log the actions of the script.
				SET @script_mass_add_user_to_role_log_message = CONCAT('the bz user #'
										, @bz_user_id_mass_add_user_to_role
										, ' CAN edit a cases for unit '
										, @product_id_mass_add_user_to_role
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script_mass_add_user_to_role, @script_mass_add_user_to_role_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table_mass_add_user_to_role = 'ut_user_group_map_temp';
				SET @permission_granted_mass_add_user_to_role = 'edit a case in this unit.';

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
					 (NOW() ,@bzfe_table_mass_add_user_to_role, 'user_id', 'UNKNOWN', @bz_user_id_mass_add_user_to_role, @script_mass_add_user_to_role, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'group_id', 'UNKNOWN', @can_edit_case_group_id, @script_mass_add_user_to_role, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'isbless', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user does NOT grant ',@permission_granted_mass_add_user_to_role, ' permission'))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'grant_type', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user is a member of the group', @permission_granted_mass_add_user_to_role))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_mass_add_user_to_role_log_message = NULL;
				SET @bzfe_table_mass_add_user_to_role = NULL;
				SET @permission_granted_mass_add_user_to_role = NULL;
				
		# User can see the case in the unit even if they are not for his role
			# This allows a user to see the 'public' cases for a given unit.
			# A 'public' case can still only be seen by users in this group!
			# We might NOT want this for employees of a contractor that only need to see the cases IF the case is restricted to
			# the contractor role but NOT if the case is for anyone
			# This is an unlikely scenario, but this is technically possible (ex for technician for a contractor)...
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id_mass_add_user_to_role, @can_see_cases_group_id, 0, 0)	
				;

			# Log the actions of the script.
				SET @script_mass_add_user_to_role_log_message = CONCAT('the bz user #'
										, @bz_user_id_mass_add_user_to_role
										, ' CAN see all public cases for unit '
										, @product_id_mass_add_user_to_role
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script_mass_add_user_to_role, @script_mass_add_user_to_role_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table_mass_add_user_to_role = 'ut_user_group_map_temp';
				SET @permission_granted_mass_add_user_to_role = 'see all public case in this unit.';

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
					 (NOW() ,@bzfe_table_mass_add_user_to_role, 'user_id', 'UNKNOWN', @bz_user_id_mass_add_user_to_role, @script_mass_add_user_to_role, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'group_id', 'UNKNOWN', @can_see_cases_group_id, @script_mass_add_user_to_role, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'isbless', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user does NOT grant ',@permission_granted_mass_add_user_to_role, ' permission'))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'grant_type', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user is a member of the group', @permission_granted_mass_add_user_to_role))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_mass_add_user_to_role_log_message = NULL;
				SET @bzfe_table_mass_add_user_to_role = NULL;
				SET @permission_granted_mass_add_user_to_role = NULL;
				
		# User can edit all fields in the case regardless of his/her role
			# This is needed so until the MEFE can handle permissions.
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id_mass_add_user_to_role, @can_edit_all_field_case_group_id, 0, 0)	
				;

			# Log the actions of the script.
				SET @script_mass_add_user_to_role_log_message = CONCAT('the bz user #'
										, @bz_user_id_mass_add_user_to_role
										, ' can edit all fields in the case regardless of his/her role for the unit#'
										, @product_id_mass_add_user_to_role
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script_mass_add_user_to_role, @script_mass_add_user_to_role_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table_mass_add_user_to_role = 'ut_user_group_map_temp';
				SET @permission_granted_mass_add_user_to_role = 'Can edit all fields in the case regardless of his/her role.';

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
					 (NOW() ,@bzfe_table_mass_add_user_to_role, 'user_id', 'UNKNOWN', @bz_user_id_mass_add_user_to_role, @script_mass_add_user_to_role, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'group_id', 'UNKNOWN', @can_edit_all_field_case_group_id, @script_mass_add_user_to_role, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'isbless', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user does NOT grant ',@permission_granted_mass_add_user_to_role, ' permission'))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'grant_type', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user is a member of the group', @permission_granted_mass_add_user_to_role))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_mass_add_user_to_role_log_message = NULL;
				SET @bzfe_table_mass_add_user_to_role = NULL;
				SET @permission_granted_mass_add_user_to_role = NULL;

		# User Can see the unit in the Search panel
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id_mass_add_user_to_role, @can_see_unit_in_search_group_id, 0, 0)	
				;

			# Log the actions of the script.
				SET @script_mass_add_user_to_role_log_message = CONCAT('the bz user #'
										, @bz_user_id_mass_add_user_to_role
										, ' can see the unit#'
										, @product_id_mass_add_user_to_role
										, ' in the search panel.'
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script_mass_add_user_to_role, @script_mass_add_user_to_role_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table_mass_add_user_to_role = 'ut_user_group_map_temp';
				SET @permission_granted_mass_add_user_to_role = 'Can see the unit in the Search panel.';

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
					 (NOW() ,@bzfe_table_mass_add_user_to_role, 'user_id', 'UNKNOWN', @bz_user_id_mass_add_user_to_role, @script_mass_add_user_to_role, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'group_id', 'UNKNOWN', @can_see_unit_in_search_group_id, @script_mass_add_user_to_role, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'isbless', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user does NOT grant ',@permission_granted_mass_add_user_to_role, ' permission'))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'grant_type', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user is a member of the group', @permission_granted_mass_add_user_to_role))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_mass_add_user_to_role_log_message = NULL;
				SET @bzfe_table_mass_add_user_to_role = NULL;
				SET @permission_granted_mass_add_user_to_role = NULL;
				
		# User can be visible to other users regardless of the other users roles
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id_mass_add_user_to_role, @list_visible_assignees_group_id, 0, 0)
				;

			# Log the actions of the script.
				SET @script_mass_add_user_to_role_log_message = CONCAT('the bz user #'
										, @bz_user_id_mass_add_user_to_role
										, ' is one of the visible assignee for cases for this unit.'
										, @product_id_mass_add_user_to_role
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script_mass_add_user_to_role, @script_mass_add_user_to_role_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table_mass_add_user_to_role = 'ut_user_group_map_temp';
				SET @permission_granted_mass_add_user_to_role = 'is one of the visible assignee for cases for this unit.';

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
					 (NOW() ,@bzfe_table_mass_add_user_to_role, 'user_id', 'UNKNOWN', @bz_user_id_mass_add_user_to_role, @script_mass_add_user_to_role, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'group_id', 'UNKNOWN', @list_visible_assignees_group_id, @script_mass_add_user_to_role, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'isbless', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user does NOT grant ',@permission_granted_mass_add_user_to_role, ' permission'))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'grant_type', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user is a member of the group', @permission_granted_mass_add_user_to_role))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_mass_add_user_to_role_log_message = NULL;
				SET @bzfe_table_mass_add_user_to_role = NULL;
				SET @permission_granted_mass_add_user_to_role = NULL;

		# User can be visible to other users regardless of the other users roles
			# The below membership is needed so the user can see all the other users regardless of the other users roles
			# We might hide the visible users to some other user (ex: housekeepers or field person do not need to see lanlord or agent
			# They just need to see their manager)
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id_mass_add_user_to_role, @see_visible_assignees_group_id, 0, 0)
				;

			# Log the actions of the script.
				SET @script_mass_add_user_to_role_log_message = CONCAT('the bz user #'
										, @bz_user_id_mass_add_user_to_role
										, ' CAN see the publicly visible users for the case for this unit.'
										, @product_id_mass_add_user_to_role
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script_mass_add_user_to_role, @script_mass_add_user_to_role_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table_mass_add_user_to_role = 'ut_user_group_map_temp';
				SET @permission_granted_mass_add_user_to_role = ' CAN see the publicly visible users for the case for this unit.';

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
					 (NOW() ,@bzfe_table_mass_add_user_to_role, 'user_id', 'UNKNOWN', @bz_user_id_mass_add_user_to_role, @script_mass_add_user_to_role, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'group_id', 'UNKNOWN', @see_visible_assignees_group_id, @script_mass_add_user_to_role, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'isbless', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user does NOT grant ',@permission_granted_mass_add_user_to_role, ' permission'))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'grant_type', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user is a member of the group', @permission_granted_mass_add_user_to_role))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_mass_add_user_to_role_log_message = NULL;
				SET @bzfe_table_mass_add_user_to_role = NULL;
				SET @permission_granted_mass_add_user_to_role = NULL;				

		#user can create flags (approval requests)				
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES
				(@bz_user_id_mass_add_user_to_role, @all_r_flags_group_id, 0, 0)
				;

			# Log the actions of the script.
				SET @script_mass_add_user_to_role_log_message = CONCAT('the bz user #'
										, @bz_user_id_mass_add_user_to_role
										, ' CAN ask for approval for all flags.'
										, @product_id_mass_add_user_to_role
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script_mass_add_user_to_role, @script_mass_add_user_to_role_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table_mass_add_user_to_role = 'ut_user_group_map_temp';
				SET @permission_granted_mass_add_user_to_role = ' CAN ask for approval for all flags.';

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
					 (NOW() ,@bzfe_table_mass_add_user_to_role, 'user_id', 'UNKNOWN', @bz_user_id_mass_add_user_to_role, @script_mass_add_user_to_role, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'group_id', 'UNKNOWN', @all_r_flags_group_id, @script_mass_add_user_to_role, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'isbless', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user does NOT grant ',@permission_granted_mass_add_user_to_role, ' permission'))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'grant_type', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user is a member of the group', @permission_granted_mass_add_user_to_role))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_mass_add_user_to_role_log_message = NULL;
				SET @bzfe_table_mass_add_user_to_role = NULL;
				SET @permission_granted_mass_add_user_to_role = NULL;	
				
		# user can approve all the flags
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES
				(@bz_user_id_mass_add_user_to_role, @all_g_flags_group_id, 0, 0)
				;

			# Log the actions of the script.
				SET @script_mass_add_user_to_role_log_message = CONCAT('the bz user #'
										, @bz_user_id_mass_add_user_to_role
										, ' CAN approve for all flags.'
										, @product_id_mass_add_user_to_role
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script_mass_add_user_to_role, @script_mass_add_user_to_role_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table_mass_add_user_to_role = 'ut_user_group_map_temp';
				SET @permission_granted_mass_add_user_to_role = ' CAN approve for all flags.';

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
					 (NOW() ,@bzfe_table_mass_add_user_to_role, 'user_id', 'UNKNOWN', @bz_user_id_mass_add_user_to_role, @script_mass_add_user_to_role, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'group_id', 'UNKNOWN', @all_g_flags_group_id, @script_mass_add_user_to_role, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted_mass_add_user_to_role))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'isbless', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user does NOT grant ',@permission_granted_mass_add_user_to_role, ' permission'))
					 , (NOW() ,@bzfe_table_mass_add_user_to_role, 'grant_type', 'UNKNOWN', 0, @script_mass_add_user_to_role, CONCAT('user is a member of the group', @permission_granted_mass_add_user_to_role))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_mass_add_user_to_role_log_message = NULL;
				SET @bzfe_table_mass_add_user_to_role = NULL;
				SET @permission_granted_mass_add_user_to_role = NULL;
				

# We CALL ALL the procedures that we have created TO CREATE the permissions we need:
	CALL show_to_tenant;
	CALL is_tenant;
	CALL default_tenant_can_see_tenant;

	CALL show_to_landlord;
	CALL are_users_landlord;
	CALL default_landlord_see_users_landlord;

	CALL show_to_agent;
	CALL are_users_agent;
	CALL default_agent_see_users_agent;

	CALL show_to_contractor;
	CALL are_users_contractor;
	CALL default_contractor_see_users_contractor;

	CALL show_to_mgt_cny;
	CALL are_users_mgt_cny;
	CALL default_mgt_cny_see_users_mgt_cny;
	
	CALL show_to_occupant;
	CALL is_occupant;
	CALL default_occupant_can_see_occupant;
		
# We give the user the permission they need.

	# We update the `user_group_map` table
		
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

# Update the table 'ut_data_to_add_user_to_a_role' so that we record what we have done
	UPDATE `ut_data_to_add_user_to_a_role`
	SET 
		`bz_created_date` = @timestamp_mass_add_user_to_role
		, `comment` = CONCAT ('inserted in BZ with the script \''
				, @script_mass_add_user_to_role
				, '\'\r\ '
				, IFNULL(`comment`, '')
				)
	WHERE `id` = @record_to_process_mass_add_user_to_role;
			
#Clean up
		
	# We Delete the temp table as we do not need it anymore
		DROP TABLE IF EXISTS `ut_user_group_map_temp`;

	# Increment the number of loops
			SET number_of_loops = (number_of_loops + 1);
		END WHILE;
	END&&
DELIMITER ;

# We call the procedure to do the Update
CALL mass_add_user_to_role;
		
		
	# Delete the procedures that we do not need anymore:
		
		DROP PROCEDURE IF EXISTS show_to_tenant;
		DROP PROCEDURE IF EXISTS is_tenant;
		DROP PROCEDURE IF EXISTS default_tenant_can_see_tenant;

		DROP PROCEDURE IF EXISTS show_to_landlord;
		DROP PROCEDURE IF EXISTS are_users_landlord;
		DROP PROCEDURE IF EXISTS default_landlord_see_users_landlord;
		
		DROP PROCEDURE IF EXISTS show_to_agent;
		DROP PROCEDURE IF EXISTS are_users_agent;
		DROP PROCEDURE IF EXISTS default_agent_see_users_agent;
		
		DROP PROCEDURE IF EXISTS show_to_contractor;
		DROP PROCEDURE IF EXISTS are_users_contractor;
		DROP PROCEDURE IF EXISTS default_contractor_see_users_contractor;
		
		DROP PROCEDURE IF EXISTS show_to_mgt_cny;
		DROP PROCEDURE IF EXISTS are_users_mgt_cny;
		DROP PROCEDURE IF EXISTS default_mgt_cny_see_users_mgt_cny;
		
		DROP PROCEDURE IF EXISTS show_to_occupant;
		DROP PROCEDURE IF EXISTS is_occupant;
		DROP PROCEDURE IF EXISTS default_occupant_see_users_occupant;
		
		DROP PROCEDURE IF EXISTS mass_add_user_to_role;
		
	# Delete the table we do not need anymore
		DROP TABLE IF EXISTS `ut_temp_data_to_add_user_to_a_role`;

# We implement the FK checks again
		
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;		
