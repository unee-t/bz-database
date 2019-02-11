####################################################################################
#
#
# This is a MAJOR upgrade. We MUST use at least Aurora MySQl 5.7+ if you want 
# to be able to use the Lambda function Unee-T depends on to work as intended
#
# Alternativey if you do NOT need to use the Lambda function, it is possible to use
#   - MySQL 5.7 +
#   - MariaDb 10.2+
#
#
####################################################################################

# For any question about this script, ask Franck
#
###################################################################################
#
# Make sure to also update the below variable(s)
#
###################################################################################
#
# What are the version of the Unee-T BZ Database schema BEFORE and AFTER this update?
	SET @old_schema_version = 'v3.30';
	SET @new_schema_version = 'v4.31';
#
# What is the name of this script?
	SET @this_script = 'upgrade_unee-t_v3.30_to_v4.31.sql';
#
###############################
#
# We have everything we need
#
###############################
# This update
#
# Alter the database, database table and All the fields in the database so we can 
# be fully  compatible with the utf8 norm
#
# Check the database engine
# SELECT * FROM information_schema.INNODB_SYS_TABLESPACES
# WHERE `NAME` LIKE '%bugzilla%'
# ;
#
# Step 1: convert rows to dynamic ONLY IF `ROW FORMAT` is NOT 'Dynamic'
# The SQL query looks like:
# ALTER TABLE `table_name` ROW_FORMAT=DYNAMIC;
#
# Step 2: convert all to utf8mb4 and utf8mb4_unicode_520_ci the latest version of unicode
# The SQL query looks like:
# ALTER TABLE `table_name` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode520_ci;
#
# These queries are built with the following SQL:
# Step 1:
# SELECT CONCAT("ALTER TABLE `"
#	, TABLE_SCHEMA
#	, '`.`'
#	, TABLE_NAME
#	,"` ROW_FORMAT=DYNAMIC;") AS `the_sql_to_run`
# FROM INFORMATION_SCHEMA.TABLES
# WHERE TABLE_SCHEMA="my_database"
# AND TABLE_TYPE="BASE TABLE";
#
# Step 2:
# SELECT CONCAT("ALTER TABLE `"
#	, TABLE_SCHEMA
#	, '`.`'
#	, TABLE_NAME
#	,"` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;") AS `the_sql_to_run`
# FROM INFORMATION_SCHEMA.TABLES
# WHERE TABLE_SCHEMA="my_database"
# AND TABLE_TYPE="BASE TABLE";
#

#####################
#
# Do it!
#
#####################

# When are we doing this?
	SET @the_timestamp = NOW();

# convert all to utf8mb4 and utf8mb4_unicode_520_ci the latest version of unicode

	/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

	ALTER TABLE `attach_data` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `attachments` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `audit_log` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `bug_cf_ipi_clust_3_roadbook_for` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `bug_cf_ipi_clust_9_acct_action` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `bug_group_map` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `bug_see_also` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `bug_severity` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `bug_status` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `bug_tag` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `bug_user_last_visit` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `bugs` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `bugs_activity` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `bugs_aliases` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `bugs_fulltext` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `bz_schema` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `category_group_map` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `cc` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `cf_ipi_clust_3_action_type` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `cf_ipi_clust_3_roadbook_for` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `cf_ipi_clust_4_status_in_progress` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `cf_ipi_clust_4_status_standby` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `cf_ipi_clust_6_claim_type` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `cf_ipi_clust_7_spe_payment_type` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `cf_ipi_clust_9_acct_action` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `cf_specific_for` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `classifications` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `component_cc` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `components` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `dependencies` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `duplicates` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `email_bug_ignore` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `email_setting` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `field_visibility` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `fielddefs` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `flagexclusions` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `flaginclusions` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `flags` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `flagtypes` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `group_control_map` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `group_group_map` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `groups` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `keyworddefs` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `keywords` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `login_failure` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `logincookies` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `longdescs` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `longdescs_tags` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `longdescs_tags_activity` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `longdescs_tags_weights` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `mail_staging` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `milestones` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `namedqueries` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `namedqueries_link_in_footer` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `namedquery_group_map` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `op_sys` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `priority` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `products` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `profile_search` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `profile_setting` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `profiles` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `profiles_activity` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `quips` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `rep_platform` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `reports` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `resolution` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `series` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `series_categories` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `series_data` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `setting` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `setting_value` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `status_workflow` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `tag` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `tokens` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `ts_error` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `ts_exitstatus` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `ts_funcmap` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `ts_job` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `ts_note` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `user_api_keys` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `user_group_map` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `ut_all_units` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `ut_audit_log` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `ut_contractor_types` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `ut_contractors` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `ut_data_to_add_user_to_a_case` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `ut_data_to_add_user_to_a_role` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `ut_data_to_create_units` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `ut_data_to_replace_dummy_roles` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `ut_db_schema_version` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `ut_flash_units_with_dummy_users` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `ut_group_types` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `ut_invitation_api_data` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `ut_invitation_types` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `ut_log_count_closed_cases` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `ut_log_count_enabled_units` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `ut_map_contractor_to_type` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `ut_map_contractor_to_user` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `ut_map_invitation_type_to_permission_type` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `ut_map_user_mefe_bzfe` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `ut_map_user_unit_details` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `ut_notification_case_assignee` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `ut_notification_case_invited` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `ut_notification_case_new` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `ut_notification_case_updated` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `ut_notification_message_new` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `ut_notification_messages_cases` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `ut_notification_types` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `ut_permission_types` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `ut_product_group` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `ut_role_types` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `ut_script_log` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `versions` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `watch` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `whine_events` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `whine_queries` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;
	ALTER TABLE `whine_schedules` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;

    /*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;

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