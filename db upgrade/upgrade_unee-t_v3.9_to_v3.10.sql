# For any question about this script, ask Franck
#
###################################################################################
#
# WARNING! It is recommended to use Amazon Aurora database engine for this version
#
#	- for the DEV/Staging environment, make sure to run the script `db_v3.6+_adjustments_for_DEV_environment.sql` AFTER this one
#	  This is needed to make sure the values for the dummy user (bz user id)  are correct for the DEV/Staging envo
#
###################################################################################
#
############################################
#
# Make sure to update the below variable(s)
#
############################################
#
# What are the version of the Unee-T BZ Database schema BEFORE and AFTER this update?
	SET @old_schema_version = 'v3.9';
	SET @new_schema_version = 'v3.10';
#
# What is the name of this script?
	SET @this_script = 'upgrade_unee-t_v3.9_to_v3.10.sql';
#
###############################
#
# We have everything we need
#
###############################
# This update 
#	- Add an invitation type `remove_user` to the table `ut_invitation_types`
#TEST NEEDED	- Create the procedure `remove_user_from_role` so we can remove a user from a role in a unit.
#

# When are we doing this?
	SET @the_timestamp = NOW();

# Add an invitation type `remove_user` to the table `ut_invitation_types`
	/*!40101 SET NAMES utf8 */;

	/*!40101 SET SQL_MODE=''*/;

	/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
	/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
	/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
	/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
	/*Table structure for table `ut_invitation_types` */

	DROP TABLE IF EXISTS `ut_invitation_types`;

	CREATE TABLE `ut_invitation_types` (
	  `id_invitation_type` SMALLINT(6) NOT NULL AUTO_INCREMENT COMMENT 'ID in this table',
	  `created` DATETIME DEFAULT NULL COMMENT 'creation ts',
	  `order` SMALLINT(6) DEFAULT NULL COMMENT 'Order in the list',
	  `is_active` TINYINT(1) DEFAULT '0' COMMENT '1 if this is an active invitation: we have the scripts to process these',
	  `invitation_type` VARCHAR(255) NOT NULL COMMENT 'A name for this invitation type',
	  `detailed_description` TEXT COMMENT 'Detailed description of this group type',
	  PRIMARY KEY (`id_invitation_type`,`invitation_type`),
	  UNIQUE KEY `invitation_type_is_unique` (`invitation_type`)
	) ENGINE=INNODB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

	/*Data for the table `ut_invitation_types` */

	INSERT  INTO `ut_invitation_types`(`id_invitation_type`,`created`,`order`,`is_active`,`invitation_type`,`detailed_description`) VALUES 
	(1,'2018-05-30 00:36:17',10,1,'type_assigned',NULL),
	(2,'2018-05-30 00:37:02',20,1,'type_cc',NULL),
	(3,'2018-05-30 00:38:46',30,1,'replace_default','- Grant the permissions to the invited user for this role for this unit\r\nand \r\n- Remove the existing default user for this role\r\nand \r\n- Replace the default user for this role '),
	(4,'2018-05-30 00:39:57',40,1,'default_cc_all','- Grant the permissions to the invited user for this role for this unit\r\nand\r\n- Keep the existing default user as default\r\nand\r\n- Make the invited user an automatic CC to all the new cases for this role for this unit'),
	(5,'2018-05-30 00:40:33',50,1,'keep_default','- Grant the permissions to the inviter user for this role for this unit\r\nand \r\n- Keep the existing default user as default\r\nand\r\n- Check if this new user is the first in this role for this unit.\r\n	- If it IS the first in this role for this unit.\r\n	  Then Replace the Default \'dummy user\' for this specific role with the BZ user in CC for this role for this unit.\r\n	- If it is NOT the first in this role for this unit.\r\n	  Do Nothing'),
	(6,'2018-06-02 10:06:42',100,1,'remove_user','- Revoke the permissions to the user for this role for this unit\r\nand \r\n- Check if this user is the default user for this role for this unit.\r\n	- If it IS the Default user in this role for this unit.\r\n	  Then Replace the Default user in this role for this unit with the \'dummy user\' for this specific role.\r\n	- If it is NOT the Default user in this role for this unit.\r\n	  Do Nothing');

	/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
	/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
	/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
	/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;	

# Create a procedure `remove_user_from_role`
	
	DROP PROCEDURE IF EXISTS `remove_user_from_role`;

DELIMITER $$
CREATE PROCEDURE `remove_user_from_role`()
SQL SECURITY INVOKER
BEGIN
	# This procedure needs the following objects
	#	- Variables:
	#		- @remove_user_from_role
	#		- @component_id_this_role
	#		- @product_id
	#		- @bz_user_id
	#		- @bz_user_id_dummy_user_this_role
	#		- @id_role_type
	# 		- @this_script
	#		- @creator_bz_id

	# We only do this if this is needed:
	IF (@remove_user_from_role = 1)
	THEN
		# The script `invite_a_user_to_a_role_in_a_unit.sql` which call this procedure, already calls: 
		# 	- `table_to_list_dummy_user_by_environment`;
		# 	- `remove_user_from_default_cc`
		# There is no need to do this again
		#
		# The script also reset the permissions for this user for this role for this unit to the default permissions.
		# We need to remove ALL the permissions for this user.
		
			# Create the table to prepare the permissions
				CALL `create_temp_table_to_update_permissions`;
				
			# Revoke all permissions for this user in this unit
				# This procedure needs the following objects:
				#	- Variables:
				#		- @product_id
				#		- @bz_user_id
				CALL `revoke_all_permission_for_this_user_in_this_unit`;
			
			# All the permission have been prepared, we can now update the permissions table
			#		- This NEEDS the table 'ut_user_group_map_temp'
				CALL `update_permissions_invited_user`;

		# Who are the initial owner and initialqa contact for this role?
												
			# Get the old values so we can 
			#	- Check if these are default user for this environment
			#	- log those
				SET @old_component_initialowner = (SELECT `initialowner`
					FROM `components` 
					WHERE `id` = @component_id_this_role)
					;
					
				SET @old_component_initialqacontact = (SELECT `initialqacontact` 
					FROM `components` 
					WHERE `id` = @component_id_this_role)
					;
					
				SET @old_component_description = (SELECT `description` 
					FROM `components` 
					WHERE `id` = @component_id_this_role)
					;
		
		# We need to check if the user we are removing is the current default user for this role for this unit.
			SET @is_user_default_assignee = IF(@old_component_initialowner = @bz_user_id
				, '1'
				, '0'
				)
				;

		# We need to check if the user we are removing is the current qa user for this role for this unit.
			SET @is_user_qa = IF(@old_component_initialqacontact = @bz_user_id
				, '1'
				, '0'
				)
				;
										
		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - remove_user_from_role';
			SET @timestamp = NOW();

		IF @is_user_default_assignee = 1
		THEN
		# We need to replace this with the default dummy user
		# The variables needed for this are
		#	- @bz_user_id_dummy_user_this_role
		# 	- @component_id_this_role
		#	- @id_role_type
		# 	- @this_script
		#	- @product_id
		#	- @creator_bz_id
		
			# We define the dummy user role description based on the variable @id_role_type
				SET @dummy_user_role_desc = IF(@id_role_type = 1
					, CONCAT('Generic '
						, (SELECT`role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
						, ' - THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL'
						, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
						, ' TO THIS UNIT'
						)
					, IF(@id_role_type = 2
						, CONCAT('Generic '
							, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
							, ' - THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL'
							, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
							, ' TO THIS UNIT'
							)
						, IF(@id_role_type = 3
							, CONCAT('Generic '
								, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
								, ' - THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL'
								, (SELECT`role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
								, ' TO THIS UNIT'
								)
							, IF(@id_role_type = 4
								, CONCAT('Generic '
									, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
									, ' - THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL'
									, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
									, ' TO THIS UNIT'
									)
								, IF(@id_role_type = 5
									, CONCAT('Generic '
										, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
										, ' - THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL'
										, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
										, ' TO THIS UNIT'
										)
									, CONCAT('error in script'
										, @this_script
										, 'line 170'
										)
									)
								)
							)
						)
					)
					;
					
			# We define the dummy user public name based on the variable @bz_user_id_dummy_user_this_role
				SET @dummy_user_pub_name = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_user_this_role);
			
			# Update the default assignee
				UPDATE `components`
				SET `initialowner` = @bz_user_id_dummy_user_this_role
					,`description` = @dummy_user_role_desc
					WHERE 
					`id` = @component_id_this_role
					;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('The component: '
					, (SELECT IFNULL(@component_id_this_role, 'component_id_this_role is NULL'))
					, ' (for the role_type_id #'
					, (SELECT IFNULL(@id_role_type, 'id_role_type is NULL'))
					, ') has been updated.'
					, '\r\The default user now associated to this role is the dummy bz user #'
					, (SELECT IFNULL(@bz_user_id_dummy_user_this_role, 'bz_user_id is NULL'))
					, ' (real name: '
					, (SELECT IFNULL(@dummy_user_pub_name, 'user_pub_name is NULL'))
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
					(@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'initialowner',@old_component_initialowner,@bz_user_id_dummy_user_this_role,@timestamp)
					, (@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'description',@old_component_description,@dummy_user_role_desc,@timestamp)
					;

			# We log what we have just done into the `ut_audit_log` table
				SET @bzfe_table = 'components';
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
					(@timestamp ,@bzfe_table , 'initialowner' , @old_component_initialowner , @bz_user_id_dummy_user_this_role , @script , 'Replace user as default assignee for the role')
					, (@timestamp ,@bzfe_table , 'description' , @old_component_description , @dummy_user_role_desc , @script , 'Change the desription for the role')
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @bzfe_table = NULL;
		END IF;

		IF @is_user_qa = 1
		THEN
		# IF the user is the current qa contact: We need to replace this with the default dummy user
		# The variables needed for this are
		#	- @bz_user_id_dummy_user_this_role
		# 	- @component_id_this_role
		#	- @id_role_type
		# 	- @this_script
		#	- @product_id
		#	- @creator_bz_id

			# We define the dummy user role description based on the variable @id_role_type
				SET @dummy_user_role_desc = IF(@id_role_type = 1
					, CONCAT('Generic '
						, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
						, ' - THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL'
						, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
						, ' TO THIS UNIT'
						)
					, IF(@id_role_type = 2
						, CONCAT('Generic '
							, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
							, ' - THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL'
							, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
							, ' TO THIS UNIT'
							)
						, IF(@id_role_type = 3
							, CONCAT('Generic '
								, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
								, ' - THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL'
								, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
								, ' TO THIS UNIT'
								)
							, IF(@id_role_type = 4
								, CONCAT('Generic '
									, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
									, ' - THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL'
									, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
									, ' TO THIS UNIT'
									)
								, IF(@id_role_type = 5
									, CONCAT('Generic '
										, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
										, ' - THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL'
										, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
										, ' TO THIS UNIT'
										)
									, CONCAT('error in script'
										, @this_script
										, 'line 298'
										)
									)
								)
							)
						)
					)
					;
					
			# We define the dummy user public name based on the variable @bz_user_id_dummy_user_this_role
				SET @dummy_user_pub_name = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_user_this_role);
		
			# Update the default assignee and qa contact
				UPDATE `components`
				SET 
					`initialqacontact` = @bz_user_id_dummy_user_this_role
					WHERE 
					`id` = @component_id_this_role
					;	

			# Log the actions of the script.
				SET @script_log_message = CONCAT('The component: '
					, (SELECT IFNULL(@component_id_this_role, 'component_id_this_role is NULL'))
					, ' (for the role_type_id #'
					, (SELECT IFNULL(@id_role_type, 'id_role_type is NULL'))
					, ') has been updated.'
					, '\r\The QA contact now associated to this role is the dummy bz user #'
					, (SELECT IFNULL(@bz_user_id_dummy_user_this_role, 'bz_user_id is NULL'))
					, ' (real name: '
					, (SELECT IFNULL(@dummy_user_pub_name, 'user_pub_name is NULL'))
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
					(@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'initialqacontact',@old_component_initialqacontact,@bz_user_id_dummy_user_this_role,@timestamp)
					;
			# We log what we have just done into the `ut_audit_log` table
				SET @bzfe_table = 'components';
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
					 (@timestamp ,@bzfe_table , 'initialqacontact' , @old_component_initialqacontact , @bz_user_id_dummy_user_this_role , @script , 'Replace user as default QA for the role')
					 ;
				 
				# Cleanup the variables for the log messages
					SET @script_log_message = NULL;
					SET @bzfe_table = NULL;
		END IF;
		
		# Clean up the variable for the script and timestamp
			SET @script = NULL;
			SET @timestamp = NULL;
	END IF;
END $$
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
	
	# We record that the table has been updated to the new version.
	INSERT INTO `ut_db_schema_version`
		(`schema_version`
		, `update_datetime`
		, `update_script`
		, `comment`
		)
		VALUES
		(@new_schema_version
		, @the_timestamp
		, @this_script
		, @comment_update_schema_version
		)
		;