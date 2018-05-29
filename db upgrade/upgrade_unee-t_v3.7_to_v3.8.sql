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
# What it is the current environment?
# Environment: Which environment are you creating the unit in?
#	- 1 is for the DEV/Staging
#	- 2 is for the prod environment
#	- 3 is for the Demo environment
	SET @environment = '1';
#
# What are the version of the Unee-T BZ Database schema BEFORE and AFTER this update?
	SET @old_schema_version = 'v3.7';
	SET @new_schema_version = 'v3.8';
	SET @this_script = 'upgrade_unee-t_v3.7_to_v3.8.sql';
#
###############################
#
# We have everything we need
#
###############################
# This update 
#WIP	- Moves script `db_v3.6+_adjustments_for_DEV_environment.sql` into a dedicated procedure which will be called
#		  EACH TIME an update script is called.
#WIP	- checks the database environment and update the procedure `` which is environment specific
#WIP	- Make sure that we have a table `ut_invitation_types` to record the invitation types which are authorized
#WIP	- Add a FK to this list of authorized invitation type in the table `ut_invitation_api_data`
#WIP	- Create a procedure to replace the default assignee for a role in unit
#
#

# When are we doing this?
	SET @the_timestamp = NOW();
	
###########
#
#	WIP
#
###########	



# Make the invited user the new default assignee for all cases in this role in this unit if needed
# This procedure needs the following objects:
#	- variables:
#		- @replace_default_assignee
#		- @bz_user_id
#		- @product_id
#		- @component_id
#		- @role_user_g_description
	# Make sure the variable we need is correctly defined
		SET @component_id = @component_id_this_role;
	
	# Run the procedure
		CALL `user_is_default_assignee_for_cases`;







# Create a procedure to create the dummy environment table

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
	
# Create a procedure to capture the id of the dummy user for each environment	
	
		# What is the default dummy user id for this environment?
		
			# Get the BZ profile id of the dummy users based on the environment variable
				# Tenant 1
					SET @bz_user_id_dummy_tenant = (SELECT `tenant_id` 
												FROM `ut_temp_dummy_users_for_roles` 
												WHERE `environment_id` = @environment)
												;

				# Landlord 2
					SET @bz_user_id_dummy_landlord = (SELECT `landlord_id` 
												FROM `ut_temp_dummy_users_for_roles` 
												WHERE `environment_id` = @environment)
												;
					
				# Contractor 3
					SET @bz_user_id_dummy_contractor = (SELECT `contractor_id` 
												FROM `ut_temp_dummy_users_for_roles` 
												WHERE `environment_id` = @environment)
												;
					
				# Management company 4
					SET @bz_user_id_dummy_mgt_cny = (SELECT `mgt_cny_id` 
												FROM `ut_temp_dummy_users_for_roles` 
												WHERE `environment_id` = @environment)
												;
					
				# Agent 5
					SET @bz_user_id_dummy_agent = (SELECT `agent_id` 
												FROM `ut_temp_dummy_users_for_roles` 
												WHERE `environment_id` = @environment)
												;
	
	
	
# Create the procedure which will udpdate the view `list_changes_new_assignee_is_real` depending on the environment variable
			
# Create the view to list all the changes from the audit log when we replaced the dummy tenant with a real user
# This version of the script uses the values for the PROD Environment (everything except 1 or 2 this is in case the environment variabel is omitted)
#
	DROP VIEW IF EXISTS `list_changes_new_assignee_is_real`;
	
	CREATE VIEW `list_changes_new_assignee_is_real`
	AS
		SELECT `ut_product_group`.`product_id`
			, `audit_log`.`object_id` AS `component_id`
			, `audit_log`.`removed`
			, `audit_log`.`added`
			, `audit_log`.`at_time`
			, `ut_product_group`.`role_type_id`
			FROM `audit_log`
				INNER JOIN `ut_product_group` 
				ON (`audit_log`.`object_id` = `ut_product_group`.`component_id`)
			# If we add one of the BZ user who is NOT a dummy user, then it is a REAL user
			WHERE (`class` = 'Bugzilla::Component'
				AND `field` = 'initialowner'
				AND 
				# The new initial owner is NOT the dummy tenant?
				`audit_log`.`added` <> 92
				AND 
				# The new initial owner is NOT the dummy landlord?
				`audit_log`.`added` <> 91
				AND 				
				# The new initial owner is NOT the dummy contractor?
				`audit_log`.`added` <> 90
				AND 
				# The new initial owner is NOT the dummy Mgt Cny?
				`audit_log`.`added` <> 92
				AND 
				# The new initial owner is NOT the dummy agent?
				`audit_log`.`added` <> 89
				)
			GROUP BY `audit_log`.`object_id`
				, `ut_product_group`.`role_type_id`
			ORDER BY `audit_log`.`at_time` DESC
				, `ut_product_group`.`product_id` ASC
				, `audit_log`.`object_id` ASC
			;
	

	
# Create the view to list all the changes from the audit log when we replaced the dummy tenant with a real user
# This script uses the values for the DEV environment (1)
#
	DROP VIEW IF EXISTS `list_changes_new_assignee_is_real`;
	
	CREATE VIEW `list_changes_new_assignee_is_real`
	AS
		SELECT `ut_product_group`.`product_id`
			, `audit_log`.`object_id` AS `component_id`
			, `audit_log`.`removed`
			, `audit_log`.`added`
			, `audit_log`.`at_time`
			, `ut_product_group`.`role_type_id`
			FROM `audit_log`
				INNER JOIN `ut_product_group` 
				ON (`audit_log`.`object_id` = `ut_product_group`.`component_id`)
			# If we add one of the BZ user who is NOT a dummy user, then it is a REAL user
			WHERE (`class` = 'Bugzilla::Component'
				AND `field` = 'initialowner'
				AND 
				# The new initial owner is NOT the dummy tenant?
				`audit_log`.`added` <> 96
				AND 
				# The new initial owner is NOT the dummy landlord?
				`audit_log`.`added` <> 94
				AND 				
				# The new initial owner is NOT the dummy contractor?
				`audit_log`.`added` <> 93
				AND 
				# The new initial owner is NOT the dummy Mgt Cny?
				`audit_log`.`added` <> 95
				AND 
				# The new initial owner is NOT the dummy agent?
				`audit_log`.`added` <> 82
				)
			GROUP BY `audit_log`.`object_id`
				, `ut_product_group`.`role_type_id`
			ORDER BY `audit_log`.`at_time` DESC
				, `ut_product_group`.`product_id` ASC
				, `audit_log`.`object_id` ASC
			;
	

	







# Create the view to list all the changes from the audit log when we replaced the dummy tenant with a real user
# This version of the script uses the values for the DEMO Environment (3)
#
	DROP VIEW IF EXISTS `list_changes_new_assignee_is_real`;
	
	CREATE VIEW `list_changes_new_assignee_is_real`
	AS
		SELECT `ut_product_group`.`product_id`
			, `audit_log`.`object_id` AS `component_id`
			, `audit_log`.`removed`
			, `audit_log`.`added`
			, `audit_log`.`at_time`
			, `ut_product_group`.`role_type_id`
			FROM `audit_log`
				INNER JOIN `ut_product_group` 
				ON (`audit_log`.`object_id` = `ut_product_group`.`component_id`)
			# If we add one of the BZ user who is NOT a dummy user, then it is a REAL user
			WHERE (`class` = 'Bugzilla::Component'
				AND `field` = 'initialowner'
				AND 
				# The new initial owner is NOT the dummy tenant?
				`audit_log`.`added` <> 4
				AND 
				# The new initial owner is NOT the dummy landlord?
				`audit_log`.`added` <> 3
				AND 				
				# The new initial owner is NOT the dummy contractor?
				`audit_log`.`added` <> 5
				AND 
				# The new initial owner is NOT the dummy Mgt Cny?
				`audit_log`.`added` <> 6
				AND 
				# The new initial owner is NOT the dummy agent?
				`audit_log`.`added` <> 2
				)
			GROUP BY `audit_log`.`object_id`
				, `ut_product_group`.`role_type_id`
			ORDER BY `audit_log`.`at_time` DESC
				, `ut_product_group`.`product_id` ASC
				, `audit_log`.`object_id` ASC
			;	
	
	
	
	
	
# Create a procedure to replace the default assignee for a role in unit
	
	
	

	
	
	
	
	
	
	
	
# Create the procedure to insert a record in the table `ut_log_count_closed_cases`
	
DROP PROCEDURE IF EXISTS update_log_count_closed_case;

DELIMITER $$
CREATE PROCEDURE update_log_count_closed_case()
SQL SECURITY INVOKER
BEGIN

	# When are we doing this?
		SET @timestamp = NOW();	

	# Flash Count the total number of CLOSED cases are the date of this query
	# Put this in a variable

		SET @count_closed_cases = (SELECT
			 COUNT(`bugs`.`bug_id`)
		FROM
			`bugs`
			INNER JOIN `bug_status`
				ON (`bugs`.`bug_status` = `bug_status`.`value`)
		WHERE `bug_status`.`is_open` = 0)
		;

	# We have everything: insert in the log table
		INSERT INTO `ut_log_count_closed_cases`
			(`timestamp`
			, `count_closed_cases`
			)
			VALUES
			(@timestamp
			, @count_closed_cases
			)
			;
END $$
DELIMITER ;

# Create the trigger to check if the case is has changed from open to closed or vice versa and update the log if needed

DROP TRIGGER IF EXISTS `update_the_log_of_closed_cases`;

DELIMITER $$
CREATE TRIGGER `update_the_log_of_closed_cases`
    AFTER UPDATE ON `bugs`
    FOR EACH ROW
  BEGIN
    IF NEW.`bug_status` <> OLD.`bug_status` 
		THEN
		# Capture the new bug status
			SET @new_bug_status = NEW.`bug_status`;
			SET @old_bug_status = OLD.`bug_status`;
		
		# Check if the new bug status is open
			SET @new_is_open = (SELECT `is_open` FROM `bug_status` WHERE `value` = @new_bug_status);
			
		# Check if the old bug status is open
			SET @old_is_open = (SELECT `is_open` FROM `bug_status` WHERE `value` = @old_bug_status);
			
		# If these are different, then we need to update the log of closed cases
			IF @new_is_open != @old_is_open
				THEN
				CALL `update_log_count_closed_case`;
			END IF;
    END IF;
END;
$$
DELIMITER ;






#Clean up
		
	# We Delete the temp table as we do not need it anymore
		DROP TABLE IF EXISTS `ut_temp_dummy_users_for_roles`;


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