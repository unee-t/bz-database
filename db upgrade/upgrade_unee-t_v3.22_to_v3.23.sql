# For any question about this script, ask Franck
#
###################################################################################
#
# WARNING! 
#	- It is MANDATORY to use Amazon Aurora database engine for this version
#
# Make sure to also update the below variable(s)
#
###################################################################################
#
# What are the version of the Unee-T BZ Database schema BEFORE and AFTER this update?
	SET @old_schema_version = 'v3.22';
	SET @new_schema_version = 'v3.23';
#
# What is the name of this script?
	SET @this_script = 'upgrade_unee-t_v3.22_to_v3.23.sql';
#

###############################
#
# We have everything we need
#
###############################
# This update
#
#   - Creates several new views to record important metrics:
#		- `count_messages_per_case_per_month`
#		- `count_messages_per_case_per_week`
#		- `count_cases_with_messages_per_month`
#		- `count_cases_with_messages_per_week`

#
				
# When are we doing this?
	SET @the_timestamp = NOW();

	
# Create the view `count_messages_per_case_per_month`

	DROP VIEW IF EXISTS `count_messages_per_case_per_month`;

	CREATE VIEW `count_messages_per_case_per_month`
	AS
	SELECT
		YEAR(`longdescs`.`bug_when`) AS `year`
		, MONTH(`longdescs`.`bug_when`) AS `month`
		, `longdescs`.`bug_id` AS `case_id`
		, COUNT(`longdescs`.`comment_id`) AS `count_messages`
	FROM
		`longdescs`
	GROUP BY YEAR(`longdescs`.`bug_when`)
		, MONTH(`longdescs`.`bug_when`)
		, `longdescs`.`bug_id`
	ORDER BY YEAR(`longdescs`.`bug_when`)DESC
		, MONTH(`longdescs`.`bug_when`)DESC
		, COUNT(`longdescs`.`comment_id`) DESC
		, `longdescs`.`bug_id` DESC
	;
	
# Create the view `count_messages_per_case_per_week`

	DROP VIEW IF EXISTS `count_messages_per_case_per_week`;

	CREATE VIEW `count_messages_per_case_per_week`
	AS	
	SELECT
		YEAR(`longdescs`.`bug_when`) AS `year`
		, MONTH(`longdescs`.`bug_when`) AS `month`
		, WEEK(`longdescs`.`bug_when`) AS `week`
		, `longdescs`.`bug_id` AS `case_id`
		, COUNT(`longdescs`.`comment_id`) AS `count_messages`
	FROM
		`longdescs`
	GROUP BY YEAR(`longdescs`.`bug_when`)
		, WEEK(`longdescs`.`bug_when`,0)
		, `longdescs`.`bug_id`
	ORDER BY YEAR(`longdescs`.`bug_when`)DESC
		, WEEK(`longdescs`.`bug_when`,0) DESC
		, COUNT(`longdescs`.`comment_id`) DESC
		, `longdescs`.`bug_id` DESC
	;

# Create the view `count_cases_with_messages_per_month`

	DROP VIEW IF EXISTS `count_cases_with_messages_per_month`;

	CREATE VIEW `count_cases_with_messages_per_month`
	AS
	SELECT
	  `count_messages_per_case_per_month`.`year`
	  , `count_messages_per_case_per_month`.`month`
	  , COUNT(`count_messages_per_case_per_month`.`case_id`) AS `count_cases_with_messages`
	FROM `count_messages_per_case_per_month`
	GROUP BY `count_messages_per_case_per_month`.`month`
		, `count_messages_per_case_per_month`.`year`
	ORDER BY `count_messages_per_case_per_month`.`year` DESC
		, `count_messages_per_case_per_month`.`month` DESC
	;	
	
# Create the view `count_cases_with_messages_per_week`

	DROP VIEW IF EXISTS `count_cases_with_messages_per_week`;

	CREATE VIEW `count_cases_with_messages_per_week`
	AS	
	SELECT
	  `count_messages_per_case_per_week`.`year`
	  , `count_messages_per_case_per_week`.`month`
	  , `count_messages_per_case_per_week`.`week`
	  , COUNT(`count_messages_per_case_per_week`.`case_id`) AS `count_cases_with_messages`
	FROM `count_messages_per_case_per_week`
	GROUP BY `count_messages_per_case_per_week`.`year`
		, `count_messages_per_case_per_week`.`month`
		, `count_messages_per_case_per_week`.`week`
	ORDER BY `count_messages_per_case_per_week`.`year` DESC
		, `count_messages_per_case_per_week`.`week` DESC
	;
		
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