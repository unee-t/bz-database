# For any question about this script, ask Franck

#############################################
#											#
# IMPORTANT INFORMATION ABOUT THIS SCRIPT	#
#											#
#############################################
#
# Built for BZFE database v2.18
#
# Use this script only if the Unit EXIST in the BZFE 
# It assumes that the unit has been created with the script '2_Insert_new_unit_with_dummy_roles_in_unee-t_bzfe_v2.18'
# it makes sure that the dummy users have permissions to create cases.
#
# This is a FIX script: it should be run only once to grant the permission needed.
#	- in the DEV environment
#	- in the PROD environment
#
# Pre-requisite:
#	- We know which is the product/unit
#	- We know the BZ user id of the user that will be the default assignee for the role for this unit
#	- We know the BZ user id of the user that creates this first role.
#	- The table 'ut_data_to_replace_dummy_roles' has been updated and we know the record that we need to update.
# 
# This script will:
#	- Go through the list of all the product/units
# 	- Make each dummy user a member of the group 'can_see_unit_in_search' (group_type_id = 38) for all the units.
#
# Limits of this script:
#	- Dummy user must exist.
#	- It can only be run by a DB user who has privileges to drop, create and call procedures
#
#################################################################
#																#
# UPDATE THE BELOW VARIABLES ACCORDING TO YOUR NEEDS			#
#																#
#################################################################

# Environment: Which environment are you creatin the unit in?
#	- 1 is for the DEV/Staging
#	- 2 is for the prod environment
#	- 3 is for the Demo environment
	SET @environment = 1;	
	
########################################################################
#
#	ALL THE VARIABLES WE NEED HAVE BEEN DEFINED, WE CAN RUN THE SCRIPT #
#
########################################################################

# Info about this script
	SET @script = 'fix_make_sure_dummy_user_can_create_cases_in_unee-t_bzfe_v2.18.sql';
	
# Timestamp	
	SET @timestamp = NOW();

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
				
# We create a temporary table to record the products we need to update.

	/*Table structure for table `ut_all_units` */
	DROP TABLE IF EXISTS `ut_all_units`;

	CREATE TABLE `ut_all_units` (
	  `id_record` INT(11) NOT NULL AUTO_INCREMENT,
	  `product_id` SMALLINT(6) NOT NULL COMMENT 'The id in the `products` table',
	  PRIMARY KEY (`id_record`)
	) ENGINE=INNODB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
	
	# We insert all the product_id that are matching our ctiteria
	INSERT INTO `ut_all_units`
		(`product_id`)
		SELECT `id` FROM `products` 
		;

# How many records do we need to process?
	SET @max_loops = (SELECT MAX(`id_record`) FROM `ut_all_units`);

# Disable the FK checks
			
/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

			
##################
#
#	Beginning of the loop
#
##################		

DELIMITER $$
DROP PROCEDURE IF EXISTS add_missing_group_to_dummy_user$$
CREATE PROCEDURE add_missing_group_to_dummy_user()
BEGIN
DECLARE what_loop INT DEFAULT 1;
	WHILE what_loop < (@max_loops +1) DO

	# BZ product_id for the unit
		SET @product_id = (SELECT `product_id` FROM `ut_all_units` WHERE `id_record` = what_loop);
	
	# The group the allow the user to see unit in the search (group_type_id = 38)
		SET @can_see_unit_in_search_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 38));

		
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
				
	# We add the permissions for the dummy user to create a case for this unit.		
	#	- can_see_unit	

				INSERT INTO `ut_user_group_map_temp`
					(`user_id`
					,`group_id`
					,`isbless`
					,`grant_type`
					) 
					VALUES 
					(@bz_user_id_dummy_tenant,@can_see_unit_in_search_group_id,0,0)
					, (@bz_user_id_dummy_landlord,@can_see_unit_in_search_group_id,0,0)
					, (@bz_user_id_dummy_agent,@can_see_unit_in_search_group_id,0,0)
					, (@bz_user_id_dummy_contractor,@can_see_unit_in_search_group_id,0,0)
					, (@bz_user_id_dummy_mgt_cny,@can_see_unit_in_search_group_id,0,0)
					;

				# Log the actions of the script.
					SET @script_log_message = CONCAT('For the unit #'
											, @product_id
											, ', the dummy bz users for each role: '
											, '(#'
											, @bz_user_id_dummy_tenant
											, 'Tenant , #'
											, @bz_user_id_dummy_landlord
											, 'Landlord , #'
											, @bz_user_id_dummy_agent
											, ' Agent, #'
											, @bz_user_id_dummy_contractor
											, ' Contractor, #'
											, @bz_user_id_dummy_mgt_cny
											, ' Management Company)'
											, ' CAN see the unit.'
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
					SET @permission_granted = 'can see this unit.';

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
						, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_mgt_cny, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
						, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
						, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, 'for the product #', @product_id))
						, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
						;
				 
				# Cleanup the variables for the log messages
					SET @script_log_message = NULL;
					SET @bzfe_table = NULL;
					SET @permission_granted = NULL;

	# We give the user the permission they need.
			
		# update the `user_group_map` table
			
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

	# Increment the number of loops
			SET what_loop = (what_loop + 1);
		END WHILE;
	END$$
DELIMITER ;
			
##################
#
#	END of the loop
#
##################			

# Call the procedure to do the fix
	CALL add_missing_group_to_dummy_user;	
	
#Clean up
	
	# We Delete the temp table as we do not need it anymore
		DROP TABLE IF EXISTS `ut_user_group_map_temp`;
		DROP TABLE IF EXISTS `ut_temp_dummy_users_for_roles`;

	# We delete the procedure
		DROP PROCEDURE IF EXISTS add_missing_group_to_dummy_user;		
		
# We implement the FK checks again
		
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;