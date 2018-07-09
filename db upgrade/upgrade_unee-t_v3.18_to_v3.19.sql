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
	SET @old_schema_version = 'v3.18';
	SET @new_schema_version = 'v3.19';
#
# What is the name of this script?
	SET @this_script = 'upgrade_unee-t_v3.18_to_v3.19.sql';
#

###############################
#
# We have everything we need
#
###############################
# This update
#
#   - Creates several new views so we can have more usage metrics:
#       - Messages
#OK         - 'Number of messages per user' per year, month
#OK         - 'Number of users who sent at least 1 message' per month
#OK         - 'Number of messages per user' per year, month, week
#OK         - 'Number of users who sent at least 1 message' per week
#       - Cases
#OK         - 'Number of cases created per user' per year, month
#OK         - 'Number of user who created at least 1 case' per month
#OK         - 'Number of cases created per user' per year, month, week
#OK         - 'Number of user who created at least 1 case' per week
#       - Units
#OK         - 'Number of new units per user' per year, month
#OK         - 'Number of users who created at least 1 unit' per month
#OK         - 'Number of new units per user' per year, month, week
#OK         - 'Number of users who created at least 1 unit' per week
#           - Number of new units created per week
#       - Invitations
#OK         - 'Number of new invitations per user' per year, month
#OK         - 'Number of users who send at least 1 invitation' per month
#OK         - 'Number of new invitations per user' per year, month, week
#OK         - 'Number of users who send at least 1 invitation' per week
#
#OK   - Remove the view `count_invitors_per_month` 
#     ---> replaced with `count_users_who_create_invites_per_month`
#OK   - We change the view `count_invites_per_unit_per_role_per_month`
#     We use the creation timestamp instead of the API timestamp ---> More reliable
#OK   - Fix issue with view `count_new_unit_created_per_month`
#     We use the correct filter.
#
				
# When are we doing this?
	SET @the_timestamp = NOW();

# 'Number of messages per user' per year, month
    DROP VIEW IF EXISTS `count_messages_per_users_per_month`;

    CREATE VIEW `count_messages_per_users_per_month`
    AS
    SELECT
        YEAR(`bug_when`) AS `year`
        , MONTH(`bug_when`) AS `month`
        , `who`
        , COUNT(`comment_id`) AS `count_messages`    
    FROM
        `longdescs`
    GROUP BY `who`
        , YEAR(`bug_when`)
        , MONTH(`bug_when`)
    ORDER BY  YEAR(`bug_when`) DESC
        , MONTH(`bug_when`) DESC
        , COUNT(`comment_id`) DESC
    ;

# 'Number of users who sent at least 1 message' per month

    DROP VIEW IF EXISTS `count_users_who_sent_message_per_month`;

    CREATE VIEW `count_users_who_sent_message_per_month`
    AS
    SELECT
        `year`
        , `month`
        , COUNT(`who`) AS `count_users_who_sent_messages`
    FROM
        `count_messages_per_users_per_month`
    GROUP BY `year`
        , `month`
    ORDER BY `year` DESC
        , `month` DESC
    ;

# 'Number of messages per user' per year, month, week
    DROP VIEW IF EXISTS `count_messages_per_users_per_week`;

    CREATE VIEW `count_messages_per_users_per_week`
    AS
    SELECT
        YEAR(`bug_when`) AS `year`
        , MONTH(`bug_when`) AS `month`
        , WEEK(`bug_when`) AS `week`
        , `who`
        , COUNT(`comment_id`) AS `count_messages`    
    FROM
        `longdescs`
    GROUP BY `who`
        , YEAR(`bug_when`)
        , MONTH(`bug_when`)
        , WEEK(`bug_when`)
    ORDER BY  YEAR(`bug_when`) DESC
        , MONTH(`bug_when`) DESC
        , WEEK(`bug_when`) DESC
        , COUNT(`comment_id`) DESC
    ;

# 'Number of users who sent at least 1 message' per week

    DROP VIEW IF EXISTS `count_users_who_sent_message_per_week`;

    CREATE VIEW `count_users_who_sent_message_per_week`
    AS
    SELECT
        `year`
        , `month`
        , `week`
        , COUNT(`who`) AS `count_users_who_sent_messages`
    FROM
        `count_messages_per_users_per_week`
    GROUP BY `year`
        , `month`
        , `week`
    ORDER BY `year` DESC
        , `week` DESC
    ;

# 'Number of cases created per user' per year, month

    DROP VIEW IF EXISTS `count_cases_per_users_per_month`;

    CREATE VIEW `count_cases_per_users_per_month`
    AS
    SELECT
        YEAR(`creation_ts`) AS `year`
        , MONTH(`creation_ts`) AS `month`
        , `reporter`
        , COUNT(`bug_id`) AS `bugs_created`
    FROM
        `bugs`
    GROUP BY `reporter`
        , YEAR(`creation_ts`)
        , MONTH(`creation_ts`)
    ORDER BY  YEAR(`creation_ts`) DESC
        , MONTH(`creation_ts`) DESC
        , COUNT(`bug_id`) DESC
    ;

# 'Number of users who create at least 1 case' per month

    DROP VIEW IF EXISTS `count_users_who_create_case_per_month`;

    CREATE VIEW `count_users_who_create_case_per_month`
    AS
    SELECT
        `year`
        , `month`
        , COUNT(`reporter`) AS `count_users_who_create_case`
    FROM
        `count_cases_per_users_per_month`
    GROUP BY `year`
        , `month`
    ORDER BY `year` DESC
        , `month` DESC
    ;

# 'Number of cases created per user' per year, month, week

    DROP VIEW IF EXISTS `count_cases_per_users_per_week`;

    CREATE VIEW `count_cases_per_users_per_week`
    AS
    SELECT
        YEAR(`creation_ts`) AS `year`
        , MONTH(`creation_ts`) AS `month`
        , WEEK(`creation_ts`) AS `week`
        , `reporter`
        , COUNT(`bug_id`) AS `bugs_created`
    FROM
        `bugs`
    GROUP BY `reporter`
        , YEAR(`creation_ts`)
        , MONTH(`creation_ts`)
        , WEEK(`creation_ts`)
    ORDER BY  YEAR(`creation_ts`) DESC
        , MONTH(`creation_ts`) DESC
        , WEEK(`creation_ts`) DESC
        , COUNT(`bug_id`) DESC
    ;

# 'Number of users who create at least 1 case' per week

    DROP VIEW IF EXISTS `count_users_who_create_case_per_week`;

    CREATE VIEW `count_users_who_create_case_per_week`
    AS
    SELECT
        `year`
        , `month`
        , `week`
        , COUNT(`reporter`) AS `count_users_who_create_case`
    FROM
        `count_cases_per_users_per_week`
    GROUP BY `year`
        , `month`
        , `week`
    ORDER BY `year` DESC
        , `week` DESC
    ;

# 'Number of unit created per user' per year, month

    DROP VIEW IF EXISTS `count_unit_created_per_users_per_month`;

    CREATE VIEW `count_unit_created_per_users_per_month`
    AS
    SELECT
        YEAR(`at_time`) AS `year`
        , MONTH(`at_time`) AS `month`
        , `user_id`
        , COUNT(`object_id`) AS `count_new_units`
    FROM `audit_log`
    WHERE ((`audit_log`.`class` = 'Bugzilla::Product')
        AND (`audit_log`.`field` = '__create__'))
    GROUP BY `user_id`
        , YEAR(`at_time`)
        , MONTH(`at_time`)
    ORDER BY  YEAR(`at_time`) DESC
        , MONTH(`at_time`) DESC
        , COUNT(`object_id`) DESC
    ;

# 'Number of users who create at least 1 unit' per month

    DROP VIEW IF EXISTS `count_users_who_create_units_per_month`;

    CREATE VIEW `count_users_who_create_units_per_month`
    AS
    SELECT
        `year`
        , `month`
        , COUNT(`user_id`) AS `count_users_who_created_units`
    FROM
        `count_unit_created_per_users_per_month`
    GROUP BY `year`
        , `month`
    ORDER BY `year` DESC
        , `month` DESC
    ;

# 'Number of unit created per user' per year, month, week

    DROP VIEW IF EXISTS `count_unit_created_per_users_per_week`;

    CREATE VIEW `count_unit_created_per_users_per_week`
    AS
    SELECT
        YEAR(`at_time`) AS `year`
        , MONTH(`at_time`) AS `month`
        , WEEK(`at_time`) AS `week`
        , `user_id`
        , COUNT(`object_id`) AS `count_new_units`
    FROM `audit_log`
    WHERE ((`audit_log`.`class` = 'Bugzilla::Product')
        AND (`audit_log`.`field` = '__create__'))
    GROUP BY `user_id`
        , YEAR(`at_time`)
        , MONTH(`at_time`)
        , WEEK(`at_time`)
    ORDER BY  YEAR(`at_time`) DESC
        , MONTH(`at_time`) DESC
        , WEEK(`at_time`) DESC
        , COUNT(`object_id`) DESC
    ;

# 'Number of users who create at least 1 unit' per week

    DROP VIEW IF EXISTS `count_users_who_create_units_per_week`;

    CREATE VIEW `count_users_who_create_units_per_week`
    AS
    SELECT
        `year`
        , `month`
        , `week`
        , COUNT(`user_id`) AS `count_users_who_created_units`
    FROM
        `count_unit_created_per_users_per_week`
    GROUP BY `year`
        , `month`
        , `week`
    ORDER BY `year` DESC
        , `week` DESC
    ;

# Number of new units created per week

    DROP VIEW IF EXISTS `count_new_unit_created_per_week`;

    CREATE VIEW `count_new_unit_created_per_week`
    AS
    SELECT
        YEAR(`at_time`) AS `year`
        , MONTH(`at_time`) AS `month`
        , WEEK(`at_time`) AS `week`
        , COUNT(`object_id`) AS `count_new_units`
    FROM `audit_log`
    WHERE ((`audit_log`.`class` = 'Bugzilla::Product')
        AND (`audit_log`.`field` = '__create__'))
    GROUP BY YEAR(`at_time`)
        , MONTH(`at_time`)
        , WEEK(`at_time`)
    ORDER BY  YEAR(`at_time`) DESC
        , MONTH(`at_time`) DESC
        , WEEK(`at_time`) DESC
        , COUNT(`object_id`) DESC
    ;


# Count the number of invitations sent per user per year, month, week

    DROP VIEW IF EXISTS `count_invites_per_user_per_week`;

	CREATE VIEW `count_invites_per_user_per_week` 
	AS
    SELECT
		YEAR(`processed_datetime`) AS `year`
		, MONTH(`processed_datetime`) AS `month`
        , WEEK(`processed_datetime`) AS `week`
		, `bzfe_invitor_user_id` AS `invitor`
		, COUNT(`id`) AS `invitation_sent`
	FROM
		`ut_invitation_api_data`
	GROUP BY YEAR(`processed_datetime`)
		, MONTH(`processed_datetime`)
        , WEEK(`processed_datetime`)
		, `bzfe_invitor_user_id`
	ORDER BY YEAR(`processed_datetime`) DESC
		, MONTH(`processed_datetime`) DESC
        , WEEK(`processed_datetime`) DESC
		, COUNT(`id`) DESC
    ;

# 'Number of users who create at least 1 invitation' per week

    DROP VIEW IF EXISTS `count_users_who_create_invites_per_week`;

	CREATE VIEW `count_users_who_create_invites_per_week` 
	AS
    SELECT
        `year`
        , `month`
        , `week`
        , COUNT(`invitor`) AS `count_users_who_created_invites`
    FROM
        `count_invites_per_user_per_week`
    GROUP BY `year`
        , `month`
        , `week`
    ORDER BY `year` DESC
        , `week` DESC
    ;

# Count the number of invitations sent per user per year, month

    DROP VIEW IF EXISTS `count_invites_per_user_per_month`;

	CREATE VIEW `count_invites_per_user_per_month` 
	AS
    SELECT
		YEAR(`processed_datetime`) AS `year`
		, MONTH(`processed_datetime`) AS `month`
		, `bzfe_invitor_user_id` AS `invitor`
		, COUNT(`id`) AS `invitation_sent`
	FROM
		`ut_invitation_api_data`
	GROUP BY YEAR(`processed_datetime`)
		, MONTH(`processed_datetime`)
		, `bzfe_invitor_user_id`
	ORDER BY YEAR(`processed_datetime`) DESC
		, MONTH(`processed_datetime`) DESC
		, COUNT(`id`) DESC
    ;

# 'Number of users who create at least 1 invitation' per month

    DROP VIEW IF EXISTS `count_users_who_create_invites_per_month`;

	CREATE VIEW `count_users_who_create_invites_per_month` 
	AS
    SELECT
        `year`
        , `month`
        , COUNT(`invitor`) AS `count_users_who_created_invites`
    FROM
        `count_invites_per_user_per_week`
    GROUP BY `year`
        , `month`
    ORDER BY `year` DESC
        , `month` DESC
    ;

# Remove the view `count_invitors_per_month` ---> replaced with `count_users_who_create_invites_per_month`

	DROP VIEW IF EXISTS `count_invitors_per_month`;

# We change the view `count_invites_per_unit_per_role_per_month`
# We use the creation timestamp instead of the API timestamp ---> More reliable

    # First we make sure that we do not have 'NULL' value for the `processed_datetime`
        UPDATE `ut_invitation_api_data`
            SET `processed_datetime` = `api_post_datetime`
            WHERE `processed_datetime` IS NULL
        ;

    # We can now alter the view

	DROP VIEW IF EXISTS `count_invites_per_unit_per_role_per_month`;

	CREATE VIEW `count_invites_per_unit_per_role_per_month` 
	AS
		SELECT
			YEAR(`processed_datetime`) AS `year`
			, MONTH(`processed_datetime`) AS `month`
			, `bz_unit_id`
			, `user_role_type_id`
			, COUNT(`id`) AS `invitation_sent`
		FROM
			`ut_invitation_api_data`
		GROUP BY `bz_user_id`
			, MONTH(`processed_datetime`)
			, YEAR(`processed_datetime`)
			, `bz_unit_id`
			, `user_role_type_id`
		ORDER BY YEAR(`processed_datetime`) DESC
			, MONTH(`processed_datetime`) DESC
			, `user_role_type_id` ASC
			, `bz_unit_id` ASC
			, COUNT(`id`) DESC
    ;

# Fix issue with View `count_new_unit_created_per_month`

    DROP VIEW IF EXISTS `count_new_unit_created_per_month`;

    CREATE VIEW `count_new_unit_created_per_month`
    AS
    SELECT 
        year(`audit_log`.`at_time`) AS `year`,
        month(`audit_log`.`at_time`) AS `month`,
        count(`audit_log`.`object_id`) AS `new_unit`
    FROM `audit_log`
    WHERE ((`audit_log`.`class` = 'Bugzilla::Product')
        AND (`audit_log`.`field` = '__create__'))
    GROUP BY year(`audit_log`.`at_time`)
        ,month(`audit_log`.`at_time`)
    ORDER BY 
        `audit_log`.`at_time` DESC
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