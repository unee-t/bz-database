####################################################################################
#
# We MUST use at least Aurora MySQl 5.7.22+ if you want 
# to be able to use the Lambda function Unee-T depends on to work as intended
#
# Alternativey if you do NOT need to use the Lambda function, it is possible to use
#	- MySQL 5.7.22 +
#	- MariaDb 10.2.3 +
#
####################################################################################
#
# For any question about this script, ask Franck
#
###################################################################################
#
# Make sure to also update the below variable(s)
#
###################################################################################
#
# What are the version of the Unee-T BZ Database schema BEFORE and AFTER this update?
	SET @old_schema_version = 'v4.35.0';
	SET @new_schema_version = 'v4.36.0';
#
# What is the name of this script?
	SET @this_script = CONCAT ('upgrade_unee-t_', @old_schema_version, '_to_', @new_schema_version, '.sql');
#
###############################
#
# We have everything we need
#
###############################
# In this update
# Try to speed up user creation and invitation procedures: Add indexes to the temporary tables:
#
# To do that, we need to alter the following procedures:
#	- `create_temp_table_to_update_group_permissions`
#	  for the tables:
#		- `ut_group_group_map_temp`
#	- `create_temp_table_to_update_permissions`
#	  for the tables:
#		- `ut_user_group_map_temp`
#	- `user_in_default_cc_for_cases`
#	  for the tables:
#		- `ut_temp_component_cc`
#		- `ut_temp_component_cc_dedup`
#
#####################
#
# Do it!
#
#####################

# When are we doing this?
	SET @the_timestamp = NOW();


/* Procedure structure for procedure `create_temp_table_to_update_group_permissions` */

DROP PROCEDURE IF EXISTS `create_temp_table_to_update_group_permissions` ;

DELIMITER $$

CREATE PROCEDURE `create_temp_table_to_update_group_permissions`()
	SQL SECURITY INVOKER
BEGIN

	# DELETE the temp table if it exists
		DROP TEMPORARY TABLE IF EXISTS `ut_group_group_map_temp`;

	# Re-create the temp table
		CREATE TEMPORARY TABLE `ut_group_group_map_temp` (
		`member_id` MEDIUMINT(9) NOT NULL
		, `grantor_id` MEDIUMINT(9) NOT NULL
		, `grant_type` TINYINT(4) NOT NULL DEFAULT 0,
		KEY `search_member_id` (`member_id`),
		KEY `search_grantor_id` (`grantor_id`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci
		;

END $$
DELIMITER ;

/* Procedure structure for procedure `create_temp_table_to_update_permissions` */

DROP PROCEDURE IF EXISTS `create_temp_table_to_update_permissions` ;

DELIMITER $$

CREATE PROCEDURE `create_temp_table_to_update_permissions`()
	SQL SECURITY INVOKER
BEGIN
	# We use a temporary table to make sure we do not have duplicates.
		
		# DELETE the temp table if it exists
		DROP TEMPORARY TABLE IF EXISTS `ut_user_group_map_temp`;
		
		# Re-create the temp table
		CREATE TEMPORARY TABLE `ut_user_group_map_temp` (
			`user_id` MEDIUMINT(9) NOT NULL
			, `group_id` MEDIUMINT(9) NOT NULL
			, `isbless` TINYINT(4) NOT NULL DEFAULT 0
			, `grant_type` TINYINT(4) NOT NULL DEFAULT 0,
			KEY `search_user_id` (`user_id`, `group_id`),
			KEY `search_group_id` (`group_id`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci
		;

END $$
DELIMITER ;

/* Procedure structure for procedure `user_in_default_cc_for_cases` */

DROP PROCEDURE IF EXISTS `user_in_default_cc_for_cases` ;

DELIMITER $$

CREATE PROCEDURE `user_in_default_cc_for_cases`()
BEGIN
	IF (@user_in_default_cc_for_cases = 1)
	THEN 

		# We record the name of this procedure for future debugging and audit_log
			SET @script = 'PROCEDURE - user_in_default_cc_for_cases';
			SET @timestamp = NOW();

		# We use a temporary table to make sure we do not have duplicates.
		
		# DELETE the temp table if it exists
			DROP TEMPORARY TABLE IF EXISTS `ut_temp_component_cc`;
		
		# Re-create the temp table
			CREATE TEMPORARY TABLE `ut_temp_component_cc` (
				`user_id` MEDIUMINT(9) NOT NULL
				, `component_id` MEDIUMINT(9) NOT NULL,
				KEY `search_user_id` (`user_id`, `component_id`),
				KEY `search_component_id` (`component_id`)
				) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci
				;

		# Add the records that exist in the table component_cc
			INSERT INTO `ut_temp_component_cc`
				SELECT *
				FROM `component_cc`;

		# Add the new user rights for the product
			INSERT INTO `ut_temp_component_cc`
				(user_id
				, component_id
				)
				VALUES
				(@bz_user_id, @component_id)
				;

		# We drop the deduplication table if it exists:
			DROP TEMPORARY TABLE IF EXISTS `ut_temp_component_cc_dedup`;

		# We create a table `ut_user_group_map_dedup` to prepare the data we need to insert
			CREATE TEMPORARY TABLE `ut_temp_component_cc_dedup` (
				`user_id` MEDIUMINT(9) NOT NULL
				, `component_id` MEDIUMINT(9) NOT NULL
				, UNIQUE KEY `ut_temp_component_cc_dedup_userid_componentid` (`user_id`, `component_id`)
				) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci
			;
			
		# We insert the de-duplicated record in the table `ut_temp_component_cc_dedup`
			INSERT INTO `ut_temp_component_cc_dedup`
			SELECT `user_id`
				, `component_id`
			FROM
				`ut_temp_component_cc`
			GROUP BY `user_id`
				, `component_id`
			;

		# We insert the new records in the table `component_cc`
			INSERT INTO `component_cc`
			SELECT `user_id`
				, `component_id`
			FROM
				`ut_temp_component_cc_dedup`
			GROUP BY `user_id`
				, `component_id`
			# The below code is overkill in this context: 
			# the Unique Key Constraint makes sure that all records are unique in the table `user_group_map`
			ON DUPLICATE KEY UPDATE
				`user_id` = `ut_temp_component_cc_dedup`.`user_id`
				, `component_id` = `ut_temp_component_cc_dedup`.`component_id`
			;

		# Clean up:
			# We drop the deduplication table if it exists:
				DROP TEMPORARY TABLE IF EXISTS `ut_temp_component_cc_dedup`;
			
			# We Delete the temp table as we do not need it anymore
				DROP TEMPORARY TABLE IF EXISTS `ut_temp_component_cc`;
		
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' is one of the copied assignee for the unit #'
									, @product_id
									, ' when the role '
									, @role_user_g_description
									, ' (the component #'
									, @component_id
									, ')'
									, ' is chosen'
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(NOW(), @script, @script_log_message)
				;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @script = NULL;
	END IF ;
END $$
DELIMITER ;

# We temporarily disable the auto counter for active units:

# Un-comment the below code to re-enable the trigger

/*
#DELIMITER $$
#CREATE TRIGGER `update_the_log_of_enabled_units_when_unit_is_created`
#	AFTER INSERT ON `products`
#	FOR EACH ROW
#  BEGIN
#	CALL `update_log_count_enabled_units`;
#END;
#$$
#DELIMITER ;
*/

# We also make sure that we use the correct definition for the Unee-T fields:

	CALL `update_bz_fielddefs`; 

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