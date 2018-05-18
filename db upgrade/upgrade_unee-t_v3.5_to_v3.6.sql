# For any question about this script, ask Franck
#
###################################################################################
#
# WARNING! It is recommended to use Amazon Aurora database engine for this version
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
	SET @old_schema_version = 'v3.5';
	SET @new_schema_version = 'v3.6';
	SET @this_script = 'upgrade_unee-t_v3.5_to_v3.6.sql';
#
###############################
#
# We have everything we need
#
###############################
# This update 
#	- Creates several views to simplify the generation of KPIs and report
#		- Snapshot of the units with real user as default assignee for each `role_type_id`
#		- Flash count the number of units with real users by user type and enabled/disabled units (at the time the query is run).
#		- Flash count the number of user per role per unit (at the time the query is run).
#		- List all the changes to a component when we added or removed one of the dummy users
#		- Count the number of invitation sent per user per month
#		- Count the number of users who sent at least an invite per month
#		- Count the number of unit where at least 1 invite was sent per month
#		- Count the number of invitation sent per unit per month
#		- Count the number of unit where at least 1 invite was sent
#		- Count the number of invitation sent to an individual invitee per month
#		- Count the number of new invitee per month (an invitee appears only once if several invites have been sent to him)
#		- Count the number of invites per unit per role per month
#		- Count the number of invites per role per month
#		- Count the number of invites per unit per month
#		- Count the number of invites per month
#		- Count the number of new geographies/Classifications created each month
#		- Count the number of new units created each month
#		- Count the number of new user created each month
#		- Count the number of new cases created each month
#		- Create a table `update_log_count_closed_case` to record the number of closed cases. This table will be udated by a trigger each time 
#		  a case status is changed from Open to Closed
#		- Create a procedure to update the table 'update_log_count_closed_case'
#		- Create a trigger to do the procedure each time a status of a case is changed from open to close or vice versa
#

# When are we doing this?
	SET @the_timestamp = NOW();
	
# Snapshot of the units with real user as default assignee for each `role_type_id`
	DROP VIEW IF EXISTS `list_components_with_real_default_assignee`;

	CREATE VIEW `list_components_with_real_default_assignee`
	AS
		SELECT `ut_product_group`.`product_id`
			, `components`.`id` AS `component_id`
			, `initialowner`
			, `ut_product_group`.`role_type_id`
			, `products`.`isactive`
			FROM `components`
				INNER JOIN `ut_product_group` 
				ON (`components`.`id` = `ut_product_group`.`component_id`)
				INNER JOIN `products` 
				ON (`ut_product_group`.`product_id` = `products`.`id`)
			# If we add one of the BZ user who is NOT a dummy user, then it is a REAL user
			WHERE (# The new initial owner is NOT the dummy tenant?
				`components`.`initialowner` <> 93
				AND 
				# The new initial owner is NOT the dummy landlord?
				`components`.`initialowner` <> 91
				AND 				
				# The new initial owner is NOT the dummy contractor?
				`components`.`initialowner` <> 90
				AND 
				# The new initial owner is NOT the dummy Mgt Cny?
				`components`.`initialowner` <> 92
				AND 
				# The new initial owner is NOT the dummy agent?
				`components`.`initialowner` <> 89
				AND
				# the role type is not null
				`ut_product_group`.`role_type_id` IS NOT NULL
				)
			GROUP BY `ut_product_group`.`product_id`
				, `components`.`id`
				, `ut_product_group`.`role_type_id`
			ORDER BY `ut_product_group`.`product_id` ASC
				, `components`.`id` ASC
			;

# Create the view to count (flash) the number of units with real users by user type and enabled/disabled units
	CREATE VIEW `flash_count_units_with_real_roles` 
	AS
		SELECT
			`role_type_id`
			, COUNT(`product_id`) AS `units_with_real_users`
			, `isactive`
		FROM
			`list_components_with_real_default_assignee`
		GROUP BY `role_type_id`
			, `isactive`
		ORDER BY `isactive` DESC
			, `role_type_id` ASC
		;
		
# Flash count the number of user per role per unit (at the time the query is run).

	DROP VIEW IF EXISTS `flash_count_user_per_role_per_unit`;

	CREATE VIEW `flash_count_user_per_role_per_unit`
	AS
		SELECT
		    `ut_product_group`.`product_id`
		    , `ut_product_group`.`role_type_id`
		    , COUNT(`profiles`.`userid`) AS `count_users`
		FROM
		    `user_group_map`
		    INNER JOIN `profiles` 
			ON (`user_group_map`.`user_id` = `profiles`.`userid`)
		    INNER JOIN `ut_product_group` 
			ON (`user_group_map`.`group_id` = `ut_product_group`.`group_id`)
		WHERE `ut_product_group`.`role_type_id` IS NOT NULL
			AND `ut_product_group`.`group_type_id` = 2
			AND `user_group_map`.`isbless` = 0
		GROUP BY `ut_product_group`.`product_id`
			, `ut_product_group`.`role_type_id`
			, `user_group_map`.`group_id`
		;
			
# Create the view to list all the changes from the audit log when we replaced the dummy tenant with a real user
# This script uses the values for the PROD
#	- Tenant = 93
#	- Landlord = 91
#	- Contractor = 90
#	- Mgt Cny = 92
#	- Agent = 89
#
# The value for the DEV are:
#	- Tenant = 96
#	- Landlord = 94
#	- Contractor = 93
#	- Mgt Cny = 95
#	- Agent = 82
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
	
# We create the view to Count the number of invitation sent per user per month
	
	DROP VIEW IF EXISTS `count_invites_per_user_per_month`;
	
	CREATE VIEW `count_invites_per_user_per_month`
	AS
		SELECT
			YEAR(`api_post_datetime`) AS `year`
			, MONTH(`api_post_datetime`) AS `month`
			, `bzfe_invitor_user_id`
			, COUNT(`id`) AS `invitation_sent`
		FROM
			`ut_invitation_api_data`
		GROUP BY `bzfe_invitor_user_id`
			, MONTH(`api_post_datetime`)
			, YEAR(`api_post_datetime`)
		ORDER BY YEAR(`api_post_datetime`) DESC
			, MONTH(`api_post_datetime`) DESC
		;

# We Create the view to count the number of user who sent at least 1 invite per month
	
	DROP VIEW IF EXISTS `count_invitors_per_month`;

	CREATE VIEW `count_invitors_per_month`
	AS 
		SELECT 
			`year`
			, `month`
			, COUNT(`bzfe_invitor_user_id`) AS `count_invitors`
		FROM `count_invites_per_user_per_month`
		GROUP BY `month`
			, `year`
		ORDER BY `year` DESC
			, `month` DESC
		;

# We create the view to count the number of invitation sent per unit per month
	
	DROP VIEW IF EXISTS `count_invites_per_unit_per_month`;

	CREATE VIEW `count_invites_per_unit_per_month` 
	AS
		SELECT
			YEAR(`api_post_datetime`) AS `year`
			, MONTH(`api_post_datetime`) AS `month`
			, `bz_unit_id`
			, COUNT(`id`) AS `invitation_sent`
		FROM
			`ut_invitation_api_data`
		GROUP BY `bz_unit_id`
			, MONTH(`api_post_datetime`)
			, YEAR(`api_post_datetime`)
		ORDER BY YEAR(`api_post_datetime`) DESC
			, MONTH(`api_post_datetime`) DESC
		;

# We create the view to count the number of unit where at least 1 invite was sent
	
	DROP VIEW IF EXISTS `count_units_with_invitation_send`;

	CREATE VIEW `count_units_with_invitation_send`
	AS 
		SELECT 
			`year`
			, `month`
			, COUNT(bz_unit_id) AS `count_units`
		FROM `count_invites_per_unit_per_month`
		GROUP BY `month`
			, `year`
		ORDER BY `year` DESC
			, `month` DESC
		;

# We create the view to count the number of invitation sent to an individual invitee per month
	
	DROP VIEW IF EXISTS `count_invitation_per_invitee_per_month`;

	CREATE VIEW `count_invitation_per_invitee_per_month` 
	AS
		SELECT
			YEAR(`api_post_datetime`) AS `year`
			, MONTH(`api_post_datetime`) AS `month`
			, `bz_user_id`
			, COUNT(`id`) AS `invitation_sent`
		FROM
			`ut_invitation_api_data`
		GROUP BY `bz_user_id`
			, MONTH(`api_post_datetime`)
			, YEAR(`api_post_datetime`)
		ORDER BY YEAR(`api_post_datetime`) DESC
			, MONTH(`api_post_datetime`) DESC
			, COUNT(`id`) DESC
		;
		
# We create the view to count the number of new invitee per month 
# (an invitee appears only once if several invites have been sent to him)
	
	DROP VIEW IF EXISTS `count_invitees_per_month`;

	CREATE VIEW `count_invitees_per_month`
	AS 
		SELECT 
			`year`
			, `month`
			, COUNT(bz_user_id) AS `count_invitees`
		FROM `count_invitation_per_invitee_per_month`
		GROUP BY `month`
			, `year`
		ORDER BY `year` DESC
			, `month` DESC
		;

# We create the view to count the number of invites per unit per role per month
	
	DROP VIEW IF EXISTS `count_invites_per_unit_per_role_per_month`;

	CREATE VIEW `count_invites_per_unit_per_role_per_month` 
	AS
		SELECT
			YEAR(`api_post_datetime`) AS `year`
			, MONTH(`api_post_datetime`) AS `month`
			, `bz_unit_id`
			, `user_role_type_id`
			, COUNT(`id`) AS `invitation_sent`
		FROM
			`ut_invitation_api_data`
		GROUP BY `bz_user_id`
			, MONTH(`api_post_datetime`)
			, YEAR(`api_post_datetime`)
			, `bz_unit_id`
			, `user_role_type_id`
		ORDER BY YEAR(`api_post_datetime`) DESC
			, MONTH(`api_post_datetime`) DESC
			, `user_role_type_id` ASC
			, `bz_unit_id` ASC
			, COUNT(`id`) DESC
		;
		
# We create the view to count the number of new invites per role per month
	
	DROP VIEW IF EXISTS `count_invites_per_role_per_month`;

	CREATE VIEW `count_invites_per_role_per_month` 
	AS
		SELECT 
			`year`
			, `month`
			, `user_role_type_id`
			, COUNT(`invitation_sent`) AS `count_invites`
		FROM `count_invites_per_unit_per_role_per_month`
		GROUP BY `month`
			, `year`
			, `user_role_type_id`
		ORDER BY `year` DESC
			, `month` DESC
			, `user_role_type_id` ASC
		;
		
# We create the view to count the number of new invites per unit per month
	
	DROP VIEW IF EXISTS `count_invites_per_unit_per_month`;

	CREATE VIEW `count_invites_per_unit_per_month` 
	AS
		SELECT 
			`year`
			, `month`
			, `bz_unit_id`
			, COUNT(`invitation_sent`) AS `count_invites`
		FROM `count_invites_per_unit_per_role_per_month`
		GROUP BY `month`
			, `year`
			, `bz_unit_id`
		ORDER BY `year` DESC
			, `month` DESC
			, `bz_unit_id` ASC
		;
		
# We create the view to count the number of new invites per month
	
	DROP VIEW IF EXISTS `count_invites_per_month`;

	CREATE VIEW `count_invites_per_month` 
	AS
		SELECT 
			`year`
			, `month`
			, COUNT(`invitation_sent`) AS `count_invites`
		FROM `count_invites_per_unit_per_role_per_month`
		GROUP BY `month`
			, `year`
		ORDER BY `year` DESC
			, `month` DESC
		;
		
# We create the view to count the number of new geographies/Classifications created each month			

	DROP VIEW IF EXISTS `count_new_geographies_created_per_month`;

	CREATE VIEW `count_new_geographies_created_per_month`
	AS 
		SELECT
			YEAR (`at_time`) AS `year`
			, MONTH (`at_time`) AS `month`
			, COUNT(`object_id`) AS `new_geography`
		FROM
			`audit_log`
			WHERE `class` = 'Bugzilla::Classification' AND `field` = '__create__'
		GROUP BY YEAR(`at_time`)
			, MONTH(`at_time`)
		ORDER BY `at_time` DESC
		;
		
# We create the view to count the number of new units created each month			

	DROP VIEW IF EXISTS `count_new_unit_created_per_month`;

	CREATE VIEW `count_new_unit_created_per_month`
	AS 
		SELECT
		    YEAR(`at_time`) AS `year`
		    , MONTH(`at_time`) AS `month`
		    , COUNT(`object_id`) AS `new_geography`
		FROM
		    `audit_log`
			WHERE `class` = 'Bugzilla::Classification' AND `field` = '__create__'
		GROUP BY YEAR(`at_time`)
			, MONTH(`at_time`)
		ORDER BY `at_time` DESC
		;
			
# We create the view to count the number of new user created each month			

	DROP VIEW IF EXISTS `count_new_user_created_per_month`;

	CREATE VIEW `count_new_user_created_per_month`
	AS 
		SELECT
			YEAR (`at_time`) AS `year`
			, MONTH (`at_time`) AS `month`
			, COUNT(`object_id`) AS `new_users`
		FROM
			`audit_log`
			WHERE `class` = 'Bugzilla::User' AND `field` = '__create__'
		GROUP BY YEAR(`at_time`)
				, MONTH(`at_time`)
			ORDER BY `at_time` DESC
		;

# We create the view to count the number of new cases created each month			

	DROP VIEW IF EXISTS `count_new_cases_created_per_month`;

	CREATE VIEW `count_new_cases_created_per_month`
	AS 
		SELECT
			YEAR(`creation_ts`) AS `year`
			, MONTH(`creation_ts`) AS `month`
			, COUNT(`bug_id`) AS `count_cases`
		FROM
			`bugs`
		GROUP BY YEAR(`creation_ts`)
			, MONTH(`creation_ts`)
		ORDER BY `creation_ts` DESC
		;

# Create a table `ut_log_count_closed_cases` to record the number of closed cases.
# This table will be udated by a trigger each time 
#	- A case status is changed from Open to Closed

	DROP TABLE IF EXISTS `ut_log_count_closed_cases`;

	CREATE TABLE `ut_log_count_closed_cases` (
	  `id_log_closed_case` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique id in this table',
	  `timestamp` datetime DEFAULT NULL COMMENT 'The timestamp when this record was created',
	  `count_closed_cases` int(11) NOT NULL COMMENT 'The number of closed case at this Datetime',
	  PRIMARY KEY (`id_log_closed_case`)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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