
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
#				, UNIQUE KEY `ut_temp_component_cc_dedup_userid_componentid` (`user_id`, `component_id`)
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
