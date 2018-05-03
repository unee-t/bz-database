# This update allows us to use lambda to automate certain processes
# - Receive information when an invitation is created
#
# This update also create several procedures and triggers to automate several tasks:
#	- Invite new users
#	- Record changes to a bug/case
#
##############################
#
#	WIP - Security issue - What should be the DEFINER for the procedures we create???
#
###############################
#
############################################
#
# Make sure to update the below variable(s)
#
############################################
#
# What is the version of the Unee-T BZ Database schema AFTER this update?
	SET @old_schema_version = 'v2.19';
	SET @new_schema_version = 'v3.0';
#
###############################
#
# We have everything we need
#
###############################
#
#
###################################################################################
#
# WARNING! It is recommended to use Amazon Aurora database engine for this version
#
###################################################################################

# We need to make the table InnoDB to be Aurora Compatible:
	ALTER TABLE `bugs_fulltext` ENGINE=InnoDB;

# We create a table to record the current version of the BZ DB schema for this environment:

	DROP TABLE IF EXISTS `ut_db_schema_version`;

	CREATE TABLE `ut_db_schema_version` (
	  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique ID in this table',
	  `schema_version` varchar(256) DEFAULT NULL COMMENT 'The current version of the BZ DB schema for Unee-T',
	  `update_datetime` datetime DEFAULT NULL COMMENT 'Timestamp - when this version was implemented in THIS environment',
	  `comment` text DEFAULT NULL COMMENT 'Comment'
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	
# We need to udpate the table 'ut_invitation_api_data' to make sure that the key 'mefe_invitation_id' is UNIQUE
	/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

	ALTER TABLE `ut_invitation_api_data` 
		ADD COLUMN `processed_datetime` datetime   NULL COMMENT 'The Timestamp when this invitation has been processed in the BZ database' after `mefe_invitor_user_id` , 
		ADD COLUMN `script` varchar(256)  COLLATE utf8_general_ci NULL COMMENT 'The SQL script or procedure that was used to process this record' after `processed_datetime` , 
		CHANGE `api_post_datetime` `api_post_datetime` datetime   NULL COMMENT 'Date and time when this invitation has been posted as porcessed via the Unee-T inviation API' after `script` , 
		ADD UNIQUE KEY `MEFE_INVITATION_ID`(`mefe_invitation_id`) ;

	/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;

# We create all the procedures we will need to process the invitations:
#
# Permissions
#	- create_temp_table_to_update_permissions
#	- can_see_time_tracking
#	- can_create_shared_queries
#	- can_tag_comment
#	- can_create_new_cases
#	- can_edit_a_case
#	- can_see_all_public_cases
#	- can_edit_all_field_in_a_case_regardless_of_role
#	- can_see_unit_in_search
#	- user_is_publicly_visible
#	- user_can_see_publicly_visible
#	- can_ask_to_approve_flags
#	- can_approve_all_flags
#	- show_to_tenant
#	- is_tenant
#	- default_tenant_can_see_tenant
#	- show_to_landlord
#	- are_users_landlord
#	- default_landlord_see_users_landlord
#	- show_to_contractor
#	- are_users_contractor
#	- default_contractor_see_users_contractor
#	- show_to_mgt_cny
#	- are_users_mgt_cny
#	- default_mgt_cny_see_users_mgt_cny
#	- show_to_agent
#	- are_users_agent
#	- default_agent_see_users_agent
#	- show_to_occupant
#	- is_occupant
#	- default_occupant_can_see_occupant
#	- update_permissions_invited_user
#
# Other operations
#	- update_assignee_if_dummy_user
#	- change_case_assignee
#	- disable_bugmail
#WIP	- user_in_cc_for_case
#WIP	- user_in_default_cc_for_cases
#
#	- finalize_invitation_to_a_case
#	- 
#	- 
#	- 



	# Permissions - Make sure we create the temp table we need to update permissions:
	
DROP PROCEDURE IF EXISTS create_temp_table_to_update_permissions;
DELIMITER $$
CREATE PROCEDURE create_temp_table_to_update_permissions()
SQL SECURITY INVOKER
BEGIN
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
END $$
DELIMITER ;

	# Global Permissions
	
		# User can see time tracking
DROP PROCEDURE IF EXISTS can_see_time_tracking;
DELIMITER $$
CREATE PROCEDURE can_see_time_tracking()
SQL SECURITY INVOKER
BEGIN

	# This should not change, it was hard coded when we created Unee-T
		# See time tracking
		SET @can_see_time_tracking_group_id = 16;

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

		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - can_see_time_tracking';
			SET @timestamp = NOW();
			
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
				(@timestamp, @script, @script_log_message)
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to see time tracking')
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_time_tracking_group_id, @script, 'Add the BZ group id when we grant the permission to see time tracking')
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant see time tracking permission')
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group see time tracking')
				 ;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
END IF ;
END $$
DELIMITER ;

		# User can create shared queries
		
DROP PROCEDURE IF EXISTS can_create_shared_queries;
DELIMITER $$
CREATE PROCEDURE can_create_shared_queries()
SQL SECURITY INVOKER
BEGIN

	# This should not change, it was hard coded when we created Unee-T
		# Can create shared queries
		SET @can_create_shared_queries_group_id = 17;

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

		# We record the name of this procedure for future debugging and audit_log`
				SET @script = 'PROCEDURE - can_create_shared_queries';
				SET @timestamp = NOW();
			
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
				(@timestamp, @script, @script_log_message)
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to create shared queries')
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @can_create_shared_queries_group_id, @script, 'Add the BZ group id when we grant the permission to create shared queries')
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant create shared queries permission')
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group create shared queries')
				 ;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
END IF ;
END $$
DELIMITER ;

		# User can tag comments
		
DROP PROCEDURE IF EXISTS can_tag_comment;
DELIMITER $$
CREATE PROCEDURE can_tag_comment()
SQL SECURITY INVOKER
BEGIN

	# This should not change, it was hard coded when we created Unee-T
		# Can tag comments
		SET @can_tag_comment_group_id = 18;		

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

		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - can_tag_comment';
			SET @timestamp = NOW();
				
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
				(@timestamp, @script, @script_log_message)
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to tag comments')
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @can_tag_comment_group_id, @script, 'Add the BZ group id when we grant the permission to tag comments')
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant tag comments permission')
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group tag comments')
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
END IF ;
END $$
DELIMITER ;

	# Permissions at the product/Unit level

		# User can create a case:

DROP PROCEDURE IF EXISTS can_create_new_cases;
DELIMITER $$
CREATE PROCEDURE can_create_new_cases()
SQL SECURITY INVOKER
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

		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - can_create_new_cases';
			SET @timestamp = NOW();

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
				(@timestamp, @script, @script_log_message)
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;	
	
		# User is allowed to edit cases
	
DROP PROCEDURE IF EXISTS can_edit_a_case;
DELIMITER $$
CREATE PROCEDURE can_edit_a_case()
SQL SECURITY INVOKER
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

		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - can_edit_a_case';
			SET @timestamp = NOW();

		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' CAN edit a case for unit '
									, @product_id
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @can_edit_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;		

		# User can see the case in the unit even if they are not for his role
		
DROP PROCEDURE IF EXISTS can_see_all_public_cases;
DELIMITER $$
CREATE PROCEDURE can_see_all_public_cases()
SQL SECURITY INVOKER
BEGIN
	# This allows a user to see the 'public' cases for a given unit.
	# A 'public' case can still only be seen by users in this group!
	# We might NOT want this for employees of a contractor that only need to see the cases IF the case is restricted to
	# the contractor role but NOT if the case is for anyone
	# This is an unlikely scenario, but this is technically possible (ex for technician for a contractor)...

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

		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - can_see_all_public_cases';
			SET @timestamp = NOW();

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
				(@timestamp, @script, @script_log_message)
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_cases_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;	

		# User can edit all fields in the case regardless of his/her role
			# This is needed so until the MEFE can handle permissions.

DROP PROCEDURE IF EXISTS can_edit_all_field_in_a_case_regardless_of_role;
DELIMITER $$
CREATE PROCEDURE can_edit_all_field_in_a_case_regardless_of_role()
SQL SECURITY INVOKER
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

		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - can_edit_all_field_in_a_case_regardless_of_role';
			SET @timestamp = NOW();

		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' can edit all fields in the case regardless of his/her role for the unit#'
									, @product_id
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;
			# We log what we have just done into the `ut_audit_log` table
			
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'Can edit all fields in the case regardless of his/her role.';
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @can_edit_all_field_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;

		# User Can see the unit in the Search panel

DROP PROCEDURE IF EXISTS can_see_unit_in_search;
DELIMITER $$
CREATE PROCEDURE can_see_unit_in_search()
SQL SECURITY INVOKER
BEGIN
	IF (@can_see_unit_in_search = 1)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @can_see_unit_in_search_group_id, 0, 0)	
				;

		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - can_see_unit_in_search';
			SET @timestamp = NOW();

		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' can see the unit#'
									, @product_id
									, ' in the search panel.'
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;

		# We log what we have just done into the `ut_audit_log` table
			
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'Can see the unit in the Search panel.';
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_unit_in_search_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;

	# Visibility of the user to other user:

		# User can be visible to other users regardless of the other users roles

DROP PROCEDURE IF EXISTS user_is_publicly_visible;
DELIMITER $$
CREATE PROCEDURE user_is_publicly_visible()
SQL SECURITY INVOKER
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

		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - user_is_publicly_visible';
			SET @timestamp = NOW();

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
				(@timestamp, @script, @script_log_message)
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @list_visible_assignees_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;	
	
		# User can see public users regardless of their roles.
		
DROP PROCEDURE IF EXISTS user_can_see_publicly_visible;
DELIMITER $$
CREATE PROCEDURE user_can_see_publicly_visible()
SQL SECURITY INVOKER
BEGIN
	IF (@user_can_see_publicly_visible = 1)
	# This is needed so the user can see all the other users regardless of the other users roles
	# We might hide the visible users to some other user (ex: housekeepers or field person do not need to see landlord or agent
	# They just need to see their manager)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @see_visible_assignees_group_id, 0, 0)
				;

		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - user_can_see_publicly_visible';
			SET @timestamp = NOW();

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
				(@timestamp, @script, @script_log_message)
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @see_visible_assignees_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;

	# Flags requests and flag approvals
	
		#user can create flags (approval requests)

DROP PROCEDURE IF EXISTS can_ask_to_approve_flags;
DELIMITER $$
CREATE PROCEDURE can_ask_to_approve_flags()
SQL SECURITY INVOKER
BEGIN
	IF (@can_ask_to_approve_flags = 1)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES
				(@bz_user_id, @all_r_flags_group_id, 0, 0)
				;

		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - can_ask_to_approve_flags';
			SET @timestamp = NOW();

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
				(@timestamp, @script, @script_log_message)
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @all_r_flags_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;	
END IF ;
END $$
DELIMITER ;	

		# user can approve all the flags

DROP PROCEDURE IF EXISTS can_approve_all_flags;
DELIMITER $$
CREATE PROCEDURE can_approve_all_flags()
SQL SECURITY INVOKER
BEGIN
	IF (@can_approve_all_flags = 1)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES
				(@bz_user_id, @all_g_flags_group_id, 0, 0)
				;

		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - can_approve_all_flags';
			SET @timestamp = NOW();

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
				(@timestamp, @script, @script_log_message)
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @all_g_flags_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;

	# Grant permissions to the user at the role level

		# User can see the cases for Tenants in the unit:
		
DROP PROCEDURE IF EXISTS show_to_tenant;
DELIMITER $$
CREATE PROCEDURE show_to_tenant()
SQL SECURITY INVOKER
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

			# We record the name of this procedure for future debugging and audit_log`
				SET @script = 'PROCEDURE - show_to_tenant';
				SET @timestamp = NOW();
				
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
					(@timestamp, @script, @script_log_message)
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
					 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
					 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_show_to_tenant, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
					 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
					 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @script = NULL;
				SET @timestamp = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;	
	
		# User is a tenant in the unit:
DROP PROCEDURE IF EXISTS is_tenant;
DELIMITER $$
CREATE PROCEDURE is_tenant()
SQL SECURITY INVOKER
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

			# We record the name of this procedure for future debugging and audit_log`
				SET @script = 'PROCEDURE - is_tenant';
				SET @timestamp = NOW();

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
					(@timestamp, @script, @script_log_message)
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
					 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
					 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_are_users_tenant, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
					 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
					 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @script = NULL;
				SET @timestamp = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;

		# User can see all the tenants in the unit:
DROP PROCEDURE IF EXISTS default_tenant_can_see_tenant;
DELIMITER $$
CREATE PROCEDURE default_tenant_can_see_tenant()
SQL SECURITY INVOKER
BEGIN
	IF (@id_role_type = 1)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_see_users_tenant, 0, 0)
				;

		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - default_tenant_can_see_tenant';
			SET @timestamp = NOW();

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
				(@timestamp, @script, @script_log_message)
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_see_users_tenant, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
	 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;
	
		# User can see the cases for Landlord in the unit:

DROP PROCEDURE IF EXISTS show_to_landlord;
DELIMITER $$
CREATE PROCEDURE show_to_landlord()
SQL SECURITY INVOKER
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

		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - show_to_landlord';
			SET @timestamp = NOW();

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
				(@timestamp, @script, @script_log_message)
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_show_to_landlord, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;	
	
		# User is a landlord for the unit:
DROP PROCEDURE IF EXISTS are_users_landlord;
DELIMITER $$
CREATE PROCEDURE are_users_landlord()
SQL SECURITY INVOKER
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

		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - are_users_landlord';
			SET @timestamp = NOW();

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
				(@timestamp, @script, @script_log_message)
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
			 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
			 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_are_users_landlord, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
			 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
			 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
			;
 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;

		# User can see all the Landlords in the unit:
DROP PROCEDURE IF EXISTS default_landlord_see_users_landlord;
DELIMITER $$
CREATE PROCEDURE default_landlord_see_users_landlord()
SQL SECURITY INVOKER
BEGIN
	IF (@id_role_type = 2)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_see_users_landlord, 0, 0)
				;

		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - default_landlord_see_users_landlord';
			SET @timestamp = NOW();
	
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
				(@timestamp, @script, @script_log_message)
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_see_users_landlord, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;

			# User can see the cases for contractor for the unit:
DROP PROCEDURE IF EXISTS show_to_contractor;
DELIMITER $$
CREATE PROCEDURE show_to_contractor()
SQL SECURITY INVOKER
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

		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - show_to_contractor';
			SET @timestamp = NOW();

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
				(@timestamp, @script, @script_log_message)
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_show_to_contractor, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;	
	
		# User is a contractor for the unit:

DROP PROCEDURE IF EXISTS are_users_contractor;
DELIMITER $$
CREATE PROCEDURE are_users_contractor()
SQL SECURITY INVOKER
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

		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - are_users_contractor';
			SET @timestamp = NOW();

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
				(@timestamp, @script, @script_log_message)
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_are_users_contractor, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @bzfe_table = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;

		# User can see all the contractors in the unit:

DROP PROCEDURE IF EXISTS default_contractor_see_users_contractor;
DELIMITER $$
CREATE PROCEDURE default_contractor_see_users_contractor()
SQL SECURITY INVOKER
BEGIN
	IF (@id_role_type = 3)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_see_users_contractor, 0, 0)
				;

		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - default_contractor_see_users_contractor';
			SET @timestamp = NOW();

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
				(@timestamp, @script, @script_log_message)
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_see_users_contractor, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @bzfe_table = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;

		# User can see the cases for Management Cny for the unit:

DROP PROCEDURE IF EXISTS show_to_mgt_cny;
DELIMITER $$
CREATE PROCEDURE show_to_mgt_cny()
SQL SECURITY INVOKER
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

		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - show_to_mgt_cny';
			SET @timestamp = NOW();

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
				(@timestamp, @script, @script_log_message)
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_show_to_mgt_cny, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;	
	
		# User is working at the Mgt Cny for the unit:

DROP PROCEDURE IF EXISTS are_users_mgt_cny;
DELIMITER $$
CREATE PROCEDURE are_users_mgt_cny()
SQL SECURITY INVOKER
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

		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - are_users_mgt_cny';
			SET @timestamp = NOW();

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
				(@timestamp, @script, @script_log_message)
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_are_users_mgt_cny, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
			 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;

		# User can see all the employee of the Mgt Cny for the unit:

DROP PROCEDURE IF EXISTS default_mgt_cny_see_users_mgt_cny;
DELIMITER $$
CREATE PROCEDURE default_mgt_cny_see_users_mgt_cny()
SQL SECURITY INVOKER
BEGIN
	IF (@id_role_type = 4)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_see_users_mgt_cny, 0, 0)
				;

		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - default_mgt_cny_see_users_mgt_cny';
			SET @timestamp = NOW();

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
				(@timestamp, @script, @script_log_message)
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_see_users_mgt_cny, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;

		# User can see the cases for agent in the unit:

DROP PROCEDURE IF EXISTS show_to_agent;
DELIMITER $$
CREATE PROCEDURE show_to_agent()
SQL SECURITY INVOKER
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

		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - show_to_agent';
			SET @timestamp = NOW();

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
				(@timestamp, @script, @script_log_message)
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_show_to_agent, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
			 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;	
	
		# User is an agent for the unit:
		
DROP PROCEDURE IF EXISTS are_users_agent;
DELIMITER $$
CREATE PROCEDURE are_users_agent()
SQL SECURITY INVOKER
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

		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - are_users_agent';
			SET @timestamp = NOW();

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
				(@timestamp, @script, @script_log_message)
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_are_users_agent, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;

		# User can see all the agents in the unit:
		
DROP PROCEDURE IF EXISTS default_agent_see_users_agent;
DELIMITER $$
CREATE PROCEDURE default_agent_see_users_agent()
SQL SECURITY INVOKER
BEGIN
	IF (@id_role_type = 5)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_see_users_agent, 0, 0)
				;

		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - default_agent_see_users_agent';
			SET @timestamp = NOW();

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
				(@timestamp, @script, @script_log_message)
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_see_users_agent, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
			 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;








		# User can see the cases for occupants in the unit:
		
DROP PROCEDURE IF EXISTS show_to_occupant;
DELIMITER $$
CREATE PROCEDURE show_to_occupant()
SQL SECURITY INVOKER
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

		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - show_to_occupant';
			SET @timestamp = NOW();

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
				(@timestamp, @script, @script_log_message)
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_show_to_occupant, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;	
	
		# User is an occupant in the unit:
		
DROP PROCEDURE IF EXISTS is_occupant;
DELIMITER $$
CREATE PROCEDURE is_occupant()
SQL SECURITY INVOKER
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

		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - is_occupant';
			SET @timestamp = NOW();

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
				(@timestamp, @script, @script_log_message)
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_are_users_occupant, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;

		# User can see all the occupants in the unit:
		
DROP PROCEDURE IF EXISTS default_occupant_can_see_occupant;
DELIMITER $$
CREATE PROCEDURE default_occupant_can_see_occupant()
SQL SECURITY INVOKER
BEGIN
	IF (@is_occupant = 1)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_see_users_occupant, 0, 0)
				;

		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - default_occupant_can_see_occupant';
			SET @timestamp = NOW();

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
				(@timestamp, @script, @script_log_message)
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_see_users_occupant, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;

	# We have all the permissions created
	# We now update the permissions for the invited users.

DROP PROCEDURE IF EXISTS update_permissions_invited_user;
DELIMITER $$
CREATE PROCEDURE update_permissions_invited_user()
SQL SECURITY INVOKER
BEGIN
	# We update the `user_group_map` table
	
	# First we disable the FK checks
		/*!40101 SET NAMES utf8 */;

		/*!40101 SET SQL_MODE=''*/;

		/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
		/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
		/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
		/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
		
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
		# We drop the temp table as we do not need it anymore
			DROP TABLE IF EXISTS `ut_user_group_map_temp`;
			
	# We implement the FK checks again		
		/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
		/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
		/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
		/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;	

END $$
DELIMITER ;

	# Update the default assignee and qa for this role if needed

DROP PROCEDURE IF EXISTS update_assignee_if_dummy_user;
DELIMITER $$
CREATE PROCEDURE update_assignee_if_dummy_user()
SQL SECURITY INVOKER
BEGIN
	# check if the user is the first in this role for this unit
	IF (@is_current_assignee_this_role_a_dummy_user = 1)
	# We update the component IF this user is the first in this role
	# IF the user is the first in this role for this unit
	# THEN change the initial owner and initialqa contact to the invited BZ user.

	THEN UPDATE `components`
		SET 
			`initialowner` = @bz_user_id
			,`initialqacontact` = @bz_user_id
			,`description` = @user_role_desc
			WHERE 
			`id` = @component_id_this_role
			;

		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - update_assignee_if_dummy_user';
			SET @timestamp = NOW();
				
		# Log the actions of the script.
			SET @script_log_message = CONCAT('The component: '
									, (SELECT IFNULL(@component_id_this_role, 'component_id_this_role is NULL'))
									, ' (for the role_type_id #'
									, (SELECT IFNULL(@id_role_type, 'id_role_type is NULL'))
									, ') has been updated.'
									, '\r\The default user now associated to this role is bz user #'
									, (SELECT IFNULL(@bz_user_id, 'bz_user_id is NULL'))
									, ' (real name: '
									, (SELECT IFNULL(@user_pub_name, 'user_pub_name is NULL'))
									, ') for the unit #' 
									, @product_id
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
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
				(@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'initialowner',@old_component_initialowner,@bz_user_id,@timestamp)
				, (@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'initialqacontact',@old_component_initialqacontact,@bz_user_id,@timestamp)
				, (@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'description',@old_component_description,@user_role_desc,@timestamp)
				;

		# Update the table 'ut_data_to_replace_dummy_roles' so that we record what we have done
			INSERT INTO `ut_data_to_replace_dummy_roles`
				(`mefe_invitation_id`
				, `mefe_invitor_user_id`
				, `bzfe_invitor_user_id`
				, `bz_unit_id`
				, `bz_user_id`
				, `user_role_type_id`
				, `is_occupant`
				, `is_mefe_user_only`
				, `user_more`
				, `bz_created_date`
				, `comment`
				)
			VALUES 
				(@mefe_invitation_id
				, @mefe_invitor_user_id
				, @creator_bz_id
				, @product_id
				, @bz_user_id
				, @id_role_type
				, @is_occupant
				, @is_mefe_only_user
				, @role_user_more
				, @timestamp
				, CONCAT ('inserted in BZ with the script \''
						, @script
						, '\'\r\ '
						, IFNULL(`comment`, '')
						)
				)
				;
					
		# Cleanup the variables for the log messages:
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
END IF ;
END $$
DELIMITER ;

	# We now check if we need to change the assignee
	
DROP PROCEDURE IF EXISTS change_case_assignee;
DELIMITER $$
CREATE PROCEDURE change_case_assignee()
SQL SECURITY INVOKER
BEGIN
	IF (@change_case_assignee = 1)
	THEN 

	# We capture the current assignee for the case so that we can log what we did
		SET @current_assignee = (SELECT `assigned_to` FROM `bugs` WHERE `bug_id` = @bz_case_id);
		
	# We also need the login name for the previous assignee and the new assignee
		SET @current_assignee_username = (SELECT `login_name` FROM `profiles` WHERE `userid` = @current_assignee);
		
	# We need the login from the user we are inviting to the case
		SET @invitee_login_name = (SELECT `login_name` FROM `profiles` WHERE `userid` = @bz_user_id);

	# We record the name of this procedure for future debugging and audit_log`
		SET @script = 'PROCEDURE - change_case_assignee';
		SET @timestamp = NOW();
		
	# We make the user the assignee for this case:
		UPDATE `bugs`
		SET 
			`assigned_to` = @bz_user_id
			, `delta_ts` = @timestamp
			, `lastdiffed` = @timestamp
		WHERE `bug_id` = @bz_case_id
		;

		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
										, @bz_user_id
										, ' is now the assignee for the case #'
										, @bz_case_id
										)
										;
				
			INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(@timestamp, @script, @script_log_message)
					;
		
	# Record the change in the Bug history
		INSERT INTO	`bugs_activity`
			(`bug_id` 
			, `who` 
			, `bug_when`
			, `fieldid`
			, `added`
			, `removed`
			)
			VALUES
			(@bz_case_id
			, @creator_bz_id
			, @timestamp
			, 16
			, @invitee_login_name
			, @current_assignee_username
			)
			;

		# Log the actions of the script.
			SET @script_log_message = CONCAT('the case histoy for case #'
										, @bz_case_id
										, ' has been updated: '
										, 'old assignee was: '
										, @current_assignee_username
										, 'new assignee is: '
										, @invitee_login_name
										)
										;
				
			INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(@timestamp, @script, @script_log_message)
					;
			
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @script = NULL;
				SET @timestamp = NULL;
END IF ;
END $$
DELIMITER ;

	# We now need to check if we want to disable bugmail for that user. 
	# We do this for ALL the users which are MEFE only!

DROP PROCEDURE IF EXISTS disable_bugmail;
DELIMITER $$
CREATE PROCEDURE disable_bugmail()
SQL SECURITY INVOKER
BEGIN
	IF (@is_mefe_only_user = 1)
	THEN UPDATE `profiles`
		SET 
			`disable_mail` = 1
		WHERE `userid` = @bz_user_id
		;

		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - disable_bugmail';
			SET @timestamp = NOW();

		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' will NOT receive bugmail'
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;

		# We log what we have just done into the `ut_audit_log` table
			
			SET @bzfe_table = 'profiles';
			SET @permission_granted = ' will NOT receive bugmail.';

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
				 (@timestamp ,@bzfe_table, 'disable_mail', 'UNKNOWN', 1, @script, CONCAT('This BZ user id #', @bz_user_id, @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
	
		# Add this information to the profile activity table
			INSERT INTO `profiles_activity`
				(`userid`
				, `who`
				, `profiles_when`
				, `fieldid`
				, `oldvalue`
				, `newvalue`
				)
				VALUES
				(@bz_user_id
				, @creator_bz_id
				, @timestamp
				, 33
				, (NULL)
				, @timestamp
				)
				;

		# Log the actions of the script.
			SET @script_log_message = CONCAT('Update profile activity for user #'
									, @bz_user_id
									);
				
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;

		# We log what we have just done into the `ut_audit_log` table
				
			SET @bzfe_table = 'profiles_activity';
			SET @permission_granted = 'New record added.';

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
				 (@timestamp ,@bzfe_table, 'ALL', 'UNKNOWN', 'N/A', @script, CONCAT(@permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END $$
DELIMITER ;



















	# We finalize the invitation:
	
DROP PROCEDURE IF EXISTS finalize_invitation_to_a_case;
DELIMITER $$
CREATE PROCEDURE finalize_invitation_to_a_case()
SQL SECURITY INVOKER
BEGIN
	
	# Add a comment to inform users that the invitation has been processed.
	# WARNING - This should happen AFTER the invitation is processed in the MEFE API.

	# We record the name of this procedure for future debugging and audit_log`
		SET @script = 'PROCEDURE - finalize_invitation_to_a_case';
		SET @timestamp = NOW();
	
	# We add a new comment to the case.
		INSERT INTO `longdescs`
			(`bug_id`
			, `who`
			, `bug_when`
			, `thetext`
			)
			VALUES
			(@bz_case_id
			, @creator_bz_id
			, @timestamp
			, CONCAT ('An invitation to collaborate on this case has been sent to the '
				, @user_role_type_name 
				, ' for this unit'
				)
			)
			;
		# Log the actions of the script.
			SET @script_log_message = CONCAT('A message has been added to the case #'
										, @bz_case_id
										, ' to inform users that inviation has been sent'
										)
										;
				
			INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(@timestamp, @script, @script_log_message)
					;
			
			SET @script_log_message = NULL;

	# Update the table 'ut_data_to_add_user_to_a_case' so that we record what we have done
		INSERT INTO `ut_data_to_add_user_to_a_case`
			( `mefe_invitation_id`
			, `mefe_invitor_user_id`
			, `bzfe_invitor_user_id`
			, `bz_user_id`
			, `bz_case_id`
			, `bz_created_date`
			, `comment`
			)
		VALUES
			(@mefe_invitation_id
			, @mefe_invitor_user_id
			, @creator_bz_id
			, @bz_user_id
			, @bz_case_id
			, @timestamp
			, CONCAT ('inserted in BZ with the script \''
					, @script
					, '\'\r\ '
					, IFNULL(`comment`, '')
					)
			)
			;
END $$
DELIMITER ;
























	



	
	
	
	
	
	






	
	
	
	
	
	
	
	
# The procedures we create require the following table(s) to be created
#	- ut_user_group_map_temp
#	
#	- create_temp_table_to_update_permissions
#
#	- can_see_time_tracking
#		- This NEEDS the table 'ut_user_group_map_temp'
#		- @can_see_time_tracking
#		- @bz_user_id
#
#	- can_create_shared_queries
#		- This NEEDS the table 'ut_user_group_map_temp'
#		- @can_create_shared_queries
#		- @bz_user_id
#
#	- can_tag_comment
#		- This NEEDS the table 'ut_user_group_map_temp'
#		- @can_tag_comment
#		- @bz_user_id
#
#	- can_create_new_cases
#		- This NEEDS the table 'ut_user_group_map_temp'
#		- @can_create_new_cases
#		- @bz_user_id
#		- @product_id
#		- @create_case_group_id
#
#	- can_edit_a_case
#		- This NEEDS the table 'ut_user_group_map_temp'
#		- @can_edit_a_case
#		- @bz_user_id
#		- @product_id
#		- @can_edit_case_group_id
#
#	- can_see_all_public_cases
#		- This NEEDS the table 'ut_user_group_map_temp'
#		- @can_see_all_public_cases
#		- @bz_user_id
#		- @product_id
#		- @can_see_cases_group_id
#
#	- can_edit_all_field_in_a_case_regardless_of_role
#		- This NEEDS the table 'ut_user_group_map_temp'
#		- @can_edit_all_field_in_a_case_regardless_of_role
#		- @bz_user_id
#		- @product_id
#		- @can_edit_all_field_case_group_id
#
#	- can_see_unit_in_search
#		- This NEEDS the table 'ut_user_group_map_temp'
#		- @can_see_unit_in_search
#		- @bz_user_id
#		- @product_id
#		- @can_see_unit_in_search_group_id
#
#	- user_is_publicly_visible
#		- This NEEDS the table 'ut_user_group_map_temp'
#		- @user_is_publicly_visible
#		- @bz_user_id
#		- @product_id
#		- @list_visible_assignees_group_id
#
#	- user_can_see_publicly_visible
#		- This NEEDS the table 'ut_user_group_map_temp'
#		- @user_can_see_publicly_visible
#		- @bz_user_id
#		- @product_id
#		- @see_visible_assignees_group_id
#
#	- can_ask_to_approve_flags
#		- This NEEDS the table 'ut_user_group_map_temp'
#		- @can_ask_to_approve_flags
#		- @bz_user_id
#		- @product_id
#		- @all_r_flags_group_id
#
#	- can_approve_all_flags
#		- This NEEDS the table 'ut_user_group_map_temp'
#		- @can_approve_all_flags
#		- @bz_user_id
#		- @product_id
#		- @all_g_flags_group_id
#
#	- show_to_tenant
#		- This NEEDS the table 'ut_user_group_map_temp'
#		- @id_role_type
#		- @bz_user_id
#		- @product_id
#		- @group_id_show_to_tenant
#
#	- is_tenant
#		- This NEEDS the table 'ut_user_group_map_temp'
#		- @id_role_type
#		- @bz_user_id
#		- @product_id
#		- @group_id_are_users_tenant
#
#	- default_tenant_can_see_tenant
#		- This NEEDS the table 'ut_user_group_map_temp'
#		- @id_role_type
#		- @bz_user_id
#		- @product_id
#		- @group_id_see_users_tenant
#
#	- show_to_landlord
#		- This NEEDS the table 'ut_user_group_map_temp'
#		- @id_role_type
#		- @bz_user_id
#		- @product_id
#		- @group_id_show_to_landlord
#
#	- are_users_landlord
#		- This NEEDS the table 'ut_user_group_map_temp'
#		- @id_role_type
#		- @bz_user_id
#		- @product_id
#		- @group_id_are_users_landlord
#
#	- default_landlord_see_users_landlord
#		- This NEEDS the table 'ut_user_group_map_temp'
#		- @id_role_type
#		- @bz_user_id
#		- @product_id
#		- @group_id_see_users_landlord
#
#	- show_to_contractor
#		- This NEEDS the table 'ut_user_group_map_temp'
#		- @id_role_type
#		- @bz_user_id
#		- @product_id
#		- @group_id_show_to_contractor
#
#	- are_users_contractor
#		- This NEEDS the table 'ut_user_group_map_temp'
#		- @id_role_type
#		- @bz_user_id
#		- @product_id
#		- @group_id_are_users_contractor
#
#	- default_contractor_see_users_contractor
#		- This NEEDS the table 'ut_user_group_map_temp'
#		- @id_role_type
#		- @bz_user_id
#		- @product_id
#		- @group_id_see_users_contractor
#
#	- show_to_mgt_cny
#		- This NEEDS the table 'ut_user_group_map_temp'
#		- @id_role_type
#		- @bz_user_id
#		- @product_id
#		- @group_id_show_to_mgt_cny
#
#	- are_users_mgt_cny
#		- This NEEDS the table 'ut_user_group_map_temp'
#		- @id_role_type
#		- @bz_user_id
#		- @product_id
#		- @group_id_are_users_mgt_cny
#
#	- default_mgt_cny_see_users_mgt_cny
#		- This NEEDS the table 'ut_user_group_map_temp'
#		- @id_role_type
#		- @bz_user_id
#		- @product_id
#		- @group_id_see_users_mgt_cny
#
#	- show_to_agent
#		- This NEEDS the table 'ut_user_group_map_temp'
#		- @id_role_type
#		- @bz_user_id
#		- @product_id
#		- @group_id_show_to_agent
#
#	- are_users_agent
#		- This NEEDS the table 'ut_user_group_map_temp'
#		- @id_role_type
#		- @bz_user_id
#		- @product_id
#		- @group_id_are_users_agent
#
#	- default_agent_see_users_agent
#		- This NEEDS the table 'ut_user_group_map_temp'
#		- @id_role_type
#		- @bz_user_id
#		- @product_id
#		- @group_id_see_users_agent
#
#	- show_to_occupant
#		- This NEEDS the table 'ut_user_group_map_temp'
#		- @is_occupant
#		- @bz_user_id
#		- @product_id
#		- @group_id_show_to_occupant
#
#	- is_occupant
#		- This NEEDS the table 'ut_user_group_map_temp'
#		- @is_occupant
#		- @bz_user_id
#		- @product_id
#		- @group_id_are_users_occupant
#
#	- default_occupant_can_see_occupant
#		- This NEEDS the table 'ut_user_group_map_temp'
#		- @is_occupant
#		- @bz_user_id
#		- @product_id
#		- @group_id_see_users_occupant
#
#	- update_permissions_invited_user
#		- This NEEDS the table 'ut_user_group_map_temp'
#
# The procedures we created REQUIRE the following variables to be defined BEFORE they can run
#	- update_assignee_if_dummy_user
#		- @is_current_assignee_this_role_a_dummy_user
#		- @bz_user_id
#		- @user_role_desc
#		- @component_id_this_role
#		- @id_role_type
#		- @user_pub_name
#		- @product_id
#		- @creator_bz_id
#		- @old_component_initialowner
#		- @old_component_initialqacontact
#		- @old_component_description
#		- @mefe_invitor_user_id
#		- @is_occupant
#		- @is_mefe_only_user
#		- @role_user_more
#
#	- change_case_assignee
#		- @change_case_assignee
#		- @bz_user_id
#		- @creator_bz_id
#		- @bz_case_id
#
#	- disable_bugmail
#		- @is_mefe_only_user
#		- @creator_bz_id
#		- @bz_user_id
#
#	- finalize_invitation_to_a_case
#		- @bz_case_id
#		- @bz_user_id
#		- @creator_bz_id
#		- @user_role_type_name
#		- @mefe_invitation_id
#		- @mefe_invitor_user_id
#		- @	
#		- @	
#		- @	
#
#	- 
#		- @id_role_type
#		- @bz_user_id
#		- @product_id
#		- @
#
#	- 
#		- @id_role_type
#		- @bz_user_id
#		- @product_id
#		- @	
	
	
	
	
	
	
	
	
	
	






	
# We create a new table 'ut_notification_messages_cases' which captures the notification information about cases.

	/*!40101 SET NAMES utf8 */;

	/*!40101 SET SQL_MODE=''*/;

	/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
	/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
	/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
	/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
	/*Table structure for table `ut_notification_messages_cases` */

	DROP TABLE IF EXISTS `ut_notification_messages_cases`;

	CREATE TABLE `ut_notification_messages_cases` (
	  `notification_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Id in this table',
	  `created_datetime` DATETIME DEFAULT NULL COMMENT 'Timestamp when this was created',
	  `processed_datetime` DATETIME DEFAULT NULL COMMENT 'Timestamp when this notification was processed',
	  `unit_id` SMALLINT(6) DEFAULT NULL COMMENT 'Unit ID - a FK to the BZ table ''products''',
	  `case_id` MEDIUMINT(9) DEFAULT NULL COMMENT 'Case ID - a FK to the BZ table ''bugs''',
	  `user_id` MEDIUMINT(9) DEFAULT NULL COMMENT 'User ID - The user who needs to be notified - a FK to the BZ table ''profiles''',
	  `update_what` VARCHAR(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'The field that was updated',
	  PRIMARY KEY (`notification_id`)
	) ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

	/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
	/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
	/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
	/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

# We create triggers which update the `ut_notification_messages_cases` table 
# each time a change is made to a case

# First we drop the triggers in case they already exist

DROP TRIGGER IF EXISTS `ut_prepare_message_new_case`;
DROP TRIGGER IF EXISTS `ut_prepare_message_case_activity`;
DROP TRIGGER IF EXISTS `ut_prepare_message_new_comment`;

# We then create the trigger when a case is created
DELIMITER $$
CREATE TRIGGER `ut_prepare_message_new_case`
AFTER INSERT ON `bugs`
FOR EACH ROW
BEGIN
	SET @unit_id = NEW.`product_id`;
	SET @case_id = NEW.`bug_id`;
	SET @user_id = NEW.`reporter`;
	SET @update_what = 'New Case';
	INSERT INTO `ut_notification_messages_cases`
		(`created_datetime`
		, `unit_id`
		, `case_id`
		, `user_id`
		, `update_what`
		)
		VALUES
		(NOW()
		, @unit_id
		, @case_id
		, @user_id
		, @update_what
		)
		;
END;
$$
DELIMITER ;

# We then create the trigger when a case is updated
DELIMITER $$
CREATE TRIGGER `ut_prepare_message_case_activity`
AFTER INSERT ON `bugs_activity`
FOR EACH ROW
BEGIN
	SET @unit_id = (SELECT `product_id` FROM `bugs` WHERE `bug_id` = NEW.`bug_id`);
	SET @case_id = NEW.`bug_id`;
	SET @user_id = NEW.`who`;
	SET @update_what = (SELECT `description` FROM `fielddefs` WHERE `id` = NEW.`fieldid`);
	INSERT INTO `ut_notification_messages_cases`
		(`created_datetime`
		, `unit_id`
		, `case_id`
		, `user_id`
		, `update_what`
		)
		VALUES
		(NOW()
		, @unit_id
		, @case_id
		, @user_id
		, @update_what
		)
		;
END;
$$
DELIMITER ;

# We then create the trigger when a new message is added
DELIMITER $$
CREATE TRIGGER `ut_prepare_message_new_comment`
AFTER INSERT ON `longdescs`
FOR EACH ROW
BEGIN
	SET @unit_id = (SELECT `product_id` FROM `bugs` WHERE `bug_id` = NEW.`bug_id`);
	SET @case_id = NEW.`bug_id`;
	SET @user_id = NEW.`who`;
	SET @update_what = 'New Message';
	INSERT INTO `ut_notification_messages_cases`
		(`created_datetime`
		, `unit_id`
		, `case_id`
		, `user_id`
		, `update_what`
		)
		VALUES
		(NOW()
		, @unit_id
		, @case_id
		, @user_id
		, @update_what
		)
		;
END;
$$
DELIMITER ;

# We add a call to Lambda function - This is a test at this stage
DROP PROCEDURE IF EXISTS `lambda_notification_change_in_case`;

DELIMITER $$
CREATE PROCEDURE `lambda_notification_change_in_case` (IN ItemID VARCHAR(255)
	, IN notification_id INT(11)
	, IN created_datetime DATETIME
	, IN processed_datetime DATETIME
	, IN unit_id SMALLINT(6)
	, IN case_id MEDIUMINT(9)
	, IN user_id MEDIUMINT(9)
	, IN update_what  VARCHAR(255)
        ) LANGUAGE SQL
SQL SECURITY INVOKER
BEGIN






END;
$$
DELIMITER ;





# We can now update the version of the database schema
	# A comment for the update
		SET @comment_update_schema_version = CONCAT (
			'Database updated from '
			, @old_schema_version
			, ' to '
			, @new_schema_version
		)
		;
		
	# Timestamp:
		SET @timestamp = NOW();
	
	# Do the update
	INSERT INTO `ut_db_schema_version`
		(`id`
		, `schema_version`
		, `update_datetime`
		, `comment`
		)
		VALUES
		( 1
		, @new_schema_version
		, @timestamp
		, @comment_update_schema_version
		)
		ON DUPLICATE KEY UPDATE
		`schema_version` = @new_schema_version
		, `update_datetime` = @timestamp
		, `comment` = @comment_update_schema_version
		;
