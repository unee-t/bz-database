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
	SET @old_schema_version = 'v3.20';
	SET @new_schema_version = 'v3.21';
#
# What is the name of this script?
	SET @this_script = 'upgrade_unee-t_v3.20_to_v3.21.sql';
#

###############################
#
# We have everything we need
#
###############################
# This update
#
#	- Remove obsolete view `count_invitees_per_month`
#   - Creates several new views to record important metrics:
#		- `count_new_cases_created_per_week`
#		- `count_new_messages_created_per_month`
#		- `count_new_messages_created_per_week`
#		- `count_new_user_created_per_week`
#		- `count_invitation_sent_per_unit_per_month`
#		- `count_invitation_sent_per_unit_per_week`
#		- `count_units_with_invitation_sent_per_week`
#		- `count_invitation_per_invitee_per_week`
#		- `count_invitation_per_invitor_per_month`
#		- `count_invitation_per_invitor_per_week`
#		- `count_users_who_invited_someone_per_month`
#		- `count_users_who_invited_someone_per_week`
#		- `count_users_who_were_invited_per_month`
#		- `count_users_who_were_invited_per_week`
#	- Rename the view `count_units_with_invitation_send` to `count_units_with_invitation_sent_per_month`
#	- Make sure we use the correct timestamp for the view `count_invitation_per_invitee_per_month`
#
				
# When are we doing this?
	SET @the_timestamp = NOW();

	
# CRemove obsolete view `count_invitees_per_month`

	DROP VIEW IF EXISTS `count_invitees_per_month`;
	
# Create the view `count_new_cases_created_per_week`

	DROP VIEW IF EXISTS `count_new_cases_created_per_week`;

	CREATE VIEW `count_new_cases_created_per_week`
	AS
	SELECT
		YEAR(`bugs`.`creation_ts`) AS `year`,
		MONTH(`bugs`.`creation_ts`) AS `month`,
		WEEK(`bugs`.`creation_ts`) AS `week`,
		COUNT(`bugs`.`bug_id`) AS `count_cases_created`
	FROM `bugs`
	GROUP BY 
		YEAR(`bugs`.`creation_ts`)
		,MONTH(`bugs`.`creation_ts`)
		,WEEK(`bugs`.`creation_ts`)
	ORDER BY `bugs`.`creation_ts` DESC
	;
	
# Create the view `count_new_messages_created_per_month`

	DROP VIEW IF EXISTS `count_new_messages_created_per_month`;

	CREATE VIEW `count_new_messages_created_per_month`
	AS
	SELECT
	  YEAR(`longdescs`.`bug_when`) AS `year`,
	  MONTH(`longdescs`.`bug_when`) AS `month`,
	  COUNT(`longdescs`.`comment_id`) AS `count_messages_created`
	FROM `longdescs`
	GROUP BY YEAR(`longdescs`.`bug_when`)
		,MONTH(`longdescs`.`bug_when`)
	ORDER BY YEAR(`longdescs`.`bug_when`)DESC
		,MONTH(`longdescs`.`bug_when`)DESC
	;

# Create the view `count_new_messages_created_per_week`

	DROP VIEW IF EXISTS `count_new_messages_created_per_week`;

	CREATE VIEW `count_new_messages_created_per_week`
	AS
	SELECT
	  YEAR(`longdescs`.`bug_when`) AS `year`,
	  MONTH(`longdescs`.`bug_when`) AS `month`,
	  WEEK(`longdescs`.`bug_when`) AS `week`,
	  COUNT(`longdescs`.`comment_id`) AS `count_messages_created`
	FROM `longdescs`
	GROUP BY YEAR(`longdescs`.`bug_when`)
		,MONTH(`longdescs`.`bug_when`)
		,WEEK(`longdescs`.`bug_when`,0)
	ORDER BY YEAR(`longdescs`.`bug_when`)DESC
		,MONTH(`longdescs`.`bug_when`)DESC
		,WEEK(`longdescs`.`bug_when`)DESC
	;

# Create the view `count_new_user_created_per_week`
	
	DROP VIEW IF EXISTS `count_new_user_created_per_week`;

	CREATE VIEW `count_new_user_created_per_week` 
	AS 
	SELECT
	  YEAR(`audit_log`.`at_time`) AS `year`
	  , MONTH(`audit_log`.`at_time`) AS `month`
	  , WEEK(`audit_log`.`at_time`) AS `week`
	  , COUNT(`audit_log`.`object_id`) AS `new_users`
	FROM `audit_log`
	WHERE ((`audit_log`.`class` = 'Bugzilla::User')
		   and (`audit_log`.`field` = '__create__'))
	GROUP BY YEAR(`audit_log`.`at_time`)
			, WEEK(`audit_log`.`at_time`)
	ORDER BY YEAR(`audit_log`.`at_time`)DESC
		, MONTH(`audit_log`.`at_time`)DESC
		, WEEK(`audit_log`.`at_time`)DESC
	;

# Create the view `count_invitation_sent_per_unit_per_month`

	DROP VIEW IF EXISTS `count_invitation_sent_per_unit_per_month`;
	
	CREATE VIEW `count_invitation_sent_per_unit_per_month` 
	AS 
	SELECT
		YEAR(`ut_invitation_api_data`.`processed_datetime`) AS `year`
		, MONTH(`ut_invitation_api_data`.`processed_datetime`) AS `month`
		, `ut_invitation_api_data`.`bz_unit_id` AS `bz_unit_id`
		, COUNT(`ut_invitation_api_data`.`id`) AS `invitation_sent`
	FROM `ut_invitation_api_data`
	GROUP BY 
		YEAR(`ut_invitation_api_data`.`processed_datetime`)
		,MONTH(`ut_invitation_api_data`.`processed_datetime`)
		,`ut_invitation_api_data`.`bz_unit_id`
	ORDER BY 
		YEAR(`ut_invitation_api_data`.`processed_datetime`)DESC
		, MONTH(`ut_invitation_api_data`.`processed_datetime`)DESC
		, COUNT(`ut_invitation_api_data`.`id`)DESC
	;
	
# Create the view `count_invitation_sent_per_unit_per_week`

	DROP VIEW IF EXISTS `count_invitation_sent_per_unit_per_week`;
		
	CREATE VIEW `count_invitation_sent_per_unit_per_week` 
	AS 
	SELECT
		YEAR(`ut_invitation_api_data`.`processed_datetime`) AS `year`
		, MONTH(`ut_invitation_api_data`.`processed_datetime`) AS `month`
		, WEEK(`ut_invitation_api_data`.`processed_datetime`,0) AS `week`
		, `ut_invitation_api_data`.`bz_unit_id` AS `bz_unit_id`
		, COUNT(`ut_invitation_api_data`.`id`) AS `invitation_sent`
	FROM `ut_invitation_api_data`
	GROUP BY 
		YEAR(`ut_invitation_api_data`.`processed_datetime`)
		,MONTH(`ut_invitation_api_data`.`processed_datetime`)
		,WEEK(`ut_invitation_api_data`.`processed_datetime`,0)
		,`ut_invitation_api_data`.`bz_unit_id`
	ORDER BY 
		YEAR(`ut_invitation_api_data`.`processed_datetime`)DESC
		, MONTH(`ut_invitation_api_data`.`processed_datetime`)DESC
		, WEEK(`ut_invitation_api_data`.`processed_datetime`,0)DESC
		, COUNT(`ut_invitation_api_data`.`id`)DESC
	;

# Rename the view `count_units_with_invitation_send` to `count_units_with_invitation_sent_per_month`
# Use a different source to make this faster.
	
	DROP VIEW IF EXISTS `count_units_with_invitation_send`;
	DROP VIEW IF EXISTS `count_units_with_invitation_sent_per_month`;

	CREATE VIEW `count_units_with_invitation_sent_per_month` 
	AS 
	SELECT
	  `count_invitation_sent_per_unit_per_month`.`year`
	  , `count_invitation_sent_per_unit_per_month`.`month`
	  , COUNT(`count_invitation_sent_per_unit_per_month`.`bz_unit_id`) AS `count_units`
	FROM `count_invitation_sent_per_unit_per_month`
	GROUP BY `count_invitation_sent_per_unit_per_month`.`month`
		,`count_invitation_sent_per_unit_per_month`.`year`
	ORDER BY `count_invitation_sent_per_unit_per_month`.`year` DESC
		,`count_invitation_sent_per_unit_per_month`.`month` DESC
	;
	
# Create the view `count_units_with_invitation_sent_per_week`

	DROP VIEW IF EXISTS `count_units_with_invitation_sent_per_week`;

	CREATE VIEW `count_units_with_invitation_sent_per_week` 
	AS 
	SELECT
	  `count_invitation_sent_per_unit_per_week`.`year`
	  , `count_invitation_sent_per_unit_per_week`.`month`
	  , `count_invitation_sent_per_unit_per_week`.`week`
	  , COUNT(`count_invitation_sent_per_unit_per_week`.`bz_unit_id`) AS `count_units`
	FROM `count_invitation_sent_per_unit_per_week`
	GROUP BY `count_invitation_sent_per_unit_per_week`.`year`
		, `count_invitation_sent_per_unit_per_week`.`month`
		, `count_invitation_sent_per_unit_per_week`.`week`
	ORDER BY `count_invitation_sent_per_unit_per_week`.`year` DESC
		,`count_invitation_sent_per_unit_per_week`.`month` DESC
		, `count_invitation_sent_per_unit_per_week`.`week` DESC
	;

	# Make sure we use the correct timestamp information for the view `count_invitation_per_invitee_per_month`

		DROP VIEW IF EXISTS `count_invitation_per_invitee_per_month`;
		
		CREATE VIEW `count_invitation_per_invitee_per_month` 
		AS 
		SELECT
		  YEAR(`ut_invitation_api_data`.`processed_datetime`) AS `year`
		  , MONTH(`ut_invitation_api_data`.`processed_datetime`) AS `month`
		  , `ut_invitation_api_data`.`bz_user_id` AS `invitee_bz_user_id`
		  , COUNT(`ut_invitation_api_data`.`id`)  AS `invitation_sent`
		FROM `ut_invitation_api_data`
		GROUP BY 
			`ut_invitation_api_data`.`bz_user_id`
			, MONTH(`ut_invitation_api_data`.`processed_datetime`)
			, YEAR(`ut_invitation_api_data`.`processed_datetime`)
		ORDER BY 
			YEAR(`ut_invitation_api_data`.`processed_datetime`)DESC
			, MONTH(`ut_invitation_api_data`.`processed_datetime`)DESC
			, COUNT(`ut_invitation_api_data`.`id`)DESC
		;

	# Create the view `count_invitation_per_invitee_per_week`

		DROP VIEW IF EXISTS `count_invitation_per_invitee_per_week`;
		
		CREATE VIEW `count_invitation_per_invitee_per_week` 
		AS 
		SELECT
		  YEAR(`ut_invitation_api_data`.`processed_datetime`) AS `year`
		  , MONTH(`ut_invitation_api_data`.`processed_datetime`) AS `month`
		  , WEEK(`ut_invitation_api_data`.`processed_datetime`) AS `week`
		  , `ut_invitation_api_data`.`bz_user_id` AS `invitee_bz_user_id`
		  , COUNT(`ut_invitation_api_data`.`id`)  AS `invitation_sent`
		FROM `ut_invitation_api_data`
		GROUP BY 
			`ut_invitation_api_data`.`bz_user_id`
			, YEAR(`ut_invitation_api_data`.`processed_datetime`)
			, MONTH(`ut_invitation_api_data`.`processed_datetime`)
			, WEEK(`ut_invitation_api_data`.`processed_datetime`)
		ORDER BY 
			YEAR(`ut_invitation_api_data`.`processed_datetime`)DESC
			, WEEK(`ut_invitation_api_data`.`processed_datetime`)DESC
			, COUNT(`ut_invitation_api_data`.`id`)DESC
		;

# Create the view `count_invitation_per_invitor_per_month`

	DROP VIEW IF EXISTS `count_invitation_per_invitor_per_month`;
	
	CREATE VIEW `count_invitation_per_invitor_per_month` 
	AS 
	SELECT
	  YEAR(`ut_invitation_api_data`.`processed_datetime`) AS `year`
	  , MONTH(`ut_invitation_api_data`.`processed_datetime`) AS `month`
	  , `ut_invitation_api_data`.`bzfe_invitor_user_id` AS `invitor_bz_user_id`
	  , COUNT(`ut_invitation_api_data`.`id`)  AS `invitation_sent`
	FROM `ut_invitation_api_data`
	GROUP BY 
		`ut_invitation_api_data`.`bzfe_invitor_user_id`
		, MONTH(`ut_invitation_api_data`.`processed_datetime`)
		, YEAR(`ut_invitation_api_data`.`processed_datetime`)
	ORDER BY 
		YEAR(`ut_invitation_api_data`.`processed_datetime`)DESC
		, MONTH(`ut_invitation_api_data`.`processed_datetime`)DESC
		, COUNT(`ut_invitation_api_data`.`id`)DESC
	;

# Create the view `count_invitation_per_invitor_per_week`

	DROP VIEW IF EXISTS `count_invitation_per_invitor_per_week`;
	
	CREATE VIEW `count_invitation_per_invitor_per_week` 
	AS 
	SELECT
	  YEAR(`ut_invitation_api_data`.`processed_datetime`) AS `year`
	  , MONTH(`ut_invitation_api_data`.`processed_datetime`) AS `month`
	  , WEEK(`ut_invitation_api_data`.`processed_datetime`) AS `week`
	  , `ut_invitation_api_data`.`bzfe_invitor_user_id` AS `invitor_bz_user_id`
	  , COUNT(`ut_invitation_api_data`.`id`)  AS `invitation_sent`
	FROM `ut_invitation_api_data`
	GROUP BY 
		`ut_invitation_api_data`.`bzfe_invitor_user_id`
		, YEAR(`ut_invitation_api_data`.`processed_datetime`)
		, MONTH(`ut_invitation_api_data`.`processed_datetime`)
		, WEEK(`ut_invitation_api_data`.`processed_datetime`)
	ORDER BY 
		YEAR(`ut_invitation_api_data`.`processed_datetime`)DESC
		, WEEK(`ut_invitation_api_data`.`processed_datetime`)DESC
		, COUNT(`ut_invitation_api_data`.`id`)DESC
	;

# Create the view `count_users_who_invited_someone_per_month`		
		
	DROP VIEW IF EXISTS `count_users_who_invited_someone_per_month`;
		
	CREATE VIEW `count_users_who_invited_someone_per_month` 
	AS 
	SELECT
		`count_invitation_per_invitor_per_month`.`year`
		, `count_invitation_per_invitor_per_month`.`month`
		, COUNT(`count_invitation_per_invitor_per_month`.`invitor_bz_user_id`) AS `count_invitors`
	FROM `count_invitation_per_invitor_per_month`
	GROUP BY `count_invitation_per_invitor_per_month`.`year`
		, `count_invitation_per_invitor_per_month`.`month`
	ORDER BY `count_invitation_per_invitor_per_month`.`year`DESC
		, `count_invitation_per_invitor_per_month`.`month`DESC			
	;	
		
# Create the view `count_users_who_invited_someone_per_week`		
		
	DROP VIEW IF EXISTS `count_users_who_invited_someone_per_week`;
		
	CREATE VIEW `count_users_who_invited_someone_per_week` 
	AS 
	SELECT
		`count_invitation_per_invitor_per_week`.`year`
		, `count_invitation_per_invitor_per_week`.`month`
		, `count_invitation_per_invitor_per_week`.`week`
		, COUNT(`count_invitation_per_invitor_per_week`.`invitor_bz_user_id`) AS `count_invitors`
	FROM `count_invitation_per_invitor_per_week`
	GROUP BY `count_invitation_per_invitor_per_week`.`year`
		, `count_invitation_per_invitor_per_week`.`month`
		, `count_invitation_per_invitor_per_week`.`week`
	ORDER BY `count_invitation_per_invitor_per_week`.`year`DESC
		, `count_invitation_per_invitor_per_week`.`week`DESC			
	;			
		
# Create the view `count_users_who_were_invited_per_month`		
		
	DROP VIEW IF EXISTS `count_users_who_were_invited_per_month`;
		
	CREATE VIEW `count_users_who_were_invited_per_month` 
	AS 
	SELECT
		`count_invitation_per_invitee_per_month`.`year`
		, `count_invitation_per_invitee_per_month`.`month`
		, COUNT(`count_invitation_per_invitee_per_month`.`invitee_bz_user_id`) AS `count_invitees`
	FROM `count_invitation_per_invitee_per_month`
	GROUP BY `count_invitation_per_invitee_per_month`.`year`
		, `count_invitation_per_invitee_per_month`.`month`
	ORDER BY `count_invitation_per_invitee_per_month`.`year`DESC
		, `count_invitation_per_invitee_per_month`.`month`DESC			
	;		
	
# Create the view `count_users_who_were_invited_per_week`		
		
	DROP VIEW IF EXISTS `count_users_who_were_invited_per_week`;
		
	CREATE VIEW `count_users_who_were_invited_per_week` 
	AS 
	SELECT
		`count_invitation_per_invitee_per_week`.`year`
		, `count_invitation_per_invitee_per_week`.`month`
		, `count_invitation_per_invitee_per_week`.`week`
		, COUNT(`count_invitation_per_invitee_per_week`.`invitee_bz_user_id`) AS `count_invitees`
	FROM `count_invitation_per_invitee_per_week`
	GROUP BY `count_invitation_per_invitee_per_week`.`year`
		, `count_invitation_per_invitee_per_week`.`month`
		, `count_invitation_per_invitee_per_week`.`week`
	ORDER BY `count_invitation_per_invitee_per_week`.`year`DESC
		, `count_invitation_per_invitee_per_week`.`week`DESC			
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