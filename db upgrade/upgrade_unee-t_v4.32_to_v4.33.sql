####################################################################################
#
# We MUST use at least Aurora MySQl 5.7.22+ if you want 
# to be able to use the Lambda function Unee-T depends on to work as intended
#
# Alternativey if you do NOT need to use the Lambda function, it is possible to use
#   - MySQL 5.7.22 +
#   - MariaDb 10.2.3 +
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
	SET @old_schema_version = 'v4.32';
	SET @new_schema_version = 'v4.33';
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
#
# We alter the tables to change:
#		- All the SMALLINT(6) to UNSIGNED = `true`
#		- All the MEDIUMINT(9) to UNSIGNED = `true`
#		- All the INT(11) to UNSIGNED = `true`
#		- Most of the keys from SMALLINT(6) to MEDIUMINT(9) Unsigned
#
#####################
#
# Do it!
#
#####################

# When are we doing this?
	SET @the_timestamp = NOW();

# Lock the tables to avoid data integrity issues:

/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

# We lock the table to avoid issue while the changes are made

	LOCK TABLES 
		`attach_data` WRITE
		, `attachments` WRITE
		, `audit_log` WRITE
		, `bug_cf_ipi_clust_3_roadbook_for` WRITE
		, `bug_cf_ipi_clust_9_acct_action` WRITE
		, `bug_group_map` WRITE
		, `bug_see_also` WRITE
		, `bug_severity` WRITE
		, `bug_status` WRITE
		, `bug_tag` WRITE
		, `bug_user_last_visit` WRITE
		, `bugs` WRITE
		, `bugs_activity` WRITE
		, `bugs_aliases` WRITE
		, `bugs_fulltext` WRITE
		, `category_group_map` WRITE
		, `cc` WRITE
		, `cf_ipi_clust_3_action_type` WRITE
		, `cf_ipi_clust_3_roadbook_for` WRITE
		, `cf_ipi_clust_4_status_in_progress` WRITE
		, `cf_ipi_clust_4_status_standby` WRITE
		, `cf_ipi_clust_6_claim_type` WRITE
		, `cf_ipi_clust_7_spe_payment_type` WRITE
		, `cf_ipi_clust_9_acct_action` WRITE
		, `cf_specific_for` WRITE
		, `classifications` WRITE
		, `component_cc` WRITE
		, `components` WRITE
		, `dependencies` WRITE
		, `duplicates` WRITE
		, `email_bug_ignore` WRITE
		, `email_setting` WRITE
		, `field_visibility` WRITE
		, `fielddefs` WRITE
		, `flagexclusions` WRITE
		, `flaginclusions` WRITE
		, `flags` WRITE
		, `flagtypes` WRITE
		, `group_control_map` WRITE
		, `group_group_map` WRITE
		, `groups` WRITE
		, `keyworddefs` WRITE
		, `keywords` WRITE
		, `login_failure` WRITE
		, `logincookies` WRITE
		, `longdescs` WRITE
		, `longdescs_tags` WRITE
		, `longdescs_tags_activity` WRITE
		, `longdescs_tags_weights` WRITE
		, `mail_staging` WRITE
		, `milestones` WRITE
		, `namedqueries` WRITE
		, `namedqueries_link_in_footer` WRITE
		, `namedquery_group_map` WRITE
		, `op_sys` WRITE
		, `priority` WRITE
		, `products` WRITE
		, `profile_search` WRITE
		, `profile_setting` WRITE
		, `profiles` WRITE
		, `profiles_activity` WRITE
		, `quips` WRITE
		, `rep_platform` WRITE
		, `reports` WRITE
		, `resolution` WRITE
		, `series` WRITE
		, `series_categories` WRITE
		, `series_data` WRITE
		, `setting_value` WRITE
		, `status_workflow` WRITE
		, `tag` WRITE
		, `tokens` WRITE
		, `ts_error` WRITE
		, `ts_exitstatus` WRITE
		, `ts_funcmap` WRITE
		, `ts_job` WRITE
		, `ts_note` WRITE
		, `user_api_keys` WRITE
		, `user_group_map` WRITE
		, `ut_all_units` WRITE
		, `ut_audit_log` WRITE
		, `ut_contractor_types` WRITE
		, `ut_contractors` WRITE
		, `ut_data_to_add_user_to_a_case` WRITE
		, `ut_data_to_add_user_to_a_role` WRITE
		, `ut_data_to_create_units` WRITE
		, `ut_data_to_replace_dummy_roles` WRITE
		, `ut_db_schema_version` WRITE
		, `ut_group_types` WRITE
		, `ut_invitation_api_data` WRITE
		, `ut_invitation_types` WRITE
		, `ut_log_count_closed_cases` WRITE
		, `ut_log_count_enabled_units` WRITE
		, `ut_map_contractor_to_type` WRITE
		, `ut_map_contractor_to_user` WRITE
		, `ut_map_invitation_type_to_permission_type` WRITE
		, `ut_map_user_mefe_bzfe` WRITE
		, `ut_map_user_unit_details` WRITE
		, `ut_notification_case_assignee` WRITE
		, `ut_notification_case_invited` WRITE
		, `ut_notification_case_new` WRITE
		, `ut_notification_case_updated` WRITE
		, `ut_notification_message_new` WRITE
		, `ut_notification_types` WRITE
		, `ut_permission_types` WRITE
		, `ut_product_group` WRITE
		, `ut_role_types` WRITE
		, `ut_script_log` WRITE
		, `versions` WRITE
		, `watch` WRITE
		, `whine_events` WRITE
		, `whine_queries` WRITE
		, `whine_schedules` WRITE
		;

# We alter the tables to change:
#		- All the SMALLINT(6) to UNSIGNED = `true`
#		- All the MEDIUMINT(9) to UNSIGNED = `true`
#		- All the INT(11) to UNSIGNED = `true`
#		- Most of the keys from SMALLINT(6) to MEDIUMINT(9) Unsigned

	/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

	/* Foreign Keys must be dropped in the target to ensure that requires changes can be done*/

	ALTER TABLE `attach_data` 
		DROP FOREIGN KEY `fk_attach_data_id_attachments_attach_id`  ;

	ALTER TABLE `attachments` 
		DROP FOREIGN KEY `fk_attachments_bug_id_bugs_bug_id`  , 
		DROP FOREIGN KEY `fk_attachments_submitter_id_profiles_userid`  ;

	ALTER TABLE `audit_log` 
		DROP FOREIGN KEY `fk_audit_log_user_id_profiles_userid`  ;

	ALTER TABLE `bug_cf_ipi_clust_3_roadbook_for` 
		DROP FOREIGN KEY `fk_0da76aa50ea9cec77ea8e213c8655f99`  , 
		DROP FOREIGN KEY `fk_bug_cf_ipi_clust_3_roadbook_for_bug_id_bugs_bug_id`  ;

	ALTER TABLE `bug_cf_ipi_clust_9_acct_action` 
		DROP FOREIGN KEY `fk_bug_cf_ipi_clust_9_acct_action_bug_id_bugs_bug_id`  , 
		DROP FOREIGN KEY `fk_e5fc7a4f159b990bfcdfcaf844d0728b`  ;

	ALTER TABLE `bug_group_map` 
		DROP FOREIGN KEY `fk_bug_group_map_bug_id_bugs_bug_id`  , 
		DROP FOREIGN KEY `fk_bug_group_map_group_id_groups_id`  ;

	ALTER TABLE `bug_see_also` 
		DROP FOREIGN KEY `fk_bug_see_also_bug_id_bugs_bug_id`  ;

	ALTER TABLE `bug_tag` 
		DROP FOREIGN KEY `fk_bug_tag_bug_id_bugs_bug_id`  , 
		DROP FOREIGN KEY `fk_bug_tag_tag_id_tag_id`  ;

	ALTER TABLE `bug_user_last_visit` 
		DROP FOREIGN KEY `fk_bug_user_last_visit_bug_id_bugs_bug_id`  , 
		DROP FOREIGN KEY `fk_bug_user_last_visit_user_id_profiles_userid`  ;

	ALTER TABLE `bugs` 
		DROP FOREIGN KEY `fk_bugs_assigned_to_profiles_userid`  , 
		DROP FOREIGN KEY `fk_bugs_component_id_components_id`  , 
		DROP FOREIGN KEY `fk_bugs_product_id_products_id`  , 
		DROP FOREIGN KEY `fk_bugs_qa_contact_profiles_userid`  , 
		DROP FOREIGN KEY `fk_bugs_reporter_profiles_userid`  ;

	ALTER TABLE `bugs_activity` 
		DROP FOREIGN KEY `fk_bugs_activity_attach_id_attachments_attach_id`  , 
		DROP FOREIGN KEY `fk_bugs_activity_bug_id_bugs_bug_id`  , 
		DROP FOREIGN KEY `fk_bugs_activity_comment_id_longdescs_comment_id`  , 
		DROP FOREIGN KEY `fk_bugs_activity_fieldid_fielddefs_id`  , 
		DROP FOREIGN KEY `fk_bugs_activity_who_profiles_userid`  ;

	ALTER TABLE `bugs_aliases` 
		DROP FOREIGN KEY `fk_bugs_aliases_bug_id_bugs_bug_id`  ;

	ALTER TABLE `category_group_map` 
		DROP FOREIGN KEY `fk_category_group_map_category_id_series_categories_id`  , 
		DROP FOREIGN KEY `fk_category_group_map_group_id_groups_id`  ;

	ALTER TABLE `cc` 
		DROP FOREIGN KEY `fk_cc_bug_id_bugs_bug_id`  , 
		DROP FOREIGN KEY `fk_cc_who_profiles_userid`  ;

	ALTER TABLE `component_cc` 
		DROP FOREIGN KEY `fk_component_cc_component_id_components_id`  , 
		DROP FOREIGN KEY `fk_component_cc_user_id_profiles_userid`  ;

	ALTER TABLE `components` 
		DROP FOREIGN KEY `fk_components_initialowner_profiles_userid`  , 
		DROP FOREIGN KEY `fk_components_initialqacontact_profiles_userid`  , 
		DROP FOREIGN KEY `fk_components_product_id_products_id`  ;

	ALTER TABLE `dependencies` 
		DROP FOREIGN KEY `fk_dependencies_blocked_bugs_bug_id`  , 
		DROP FOREIGN KEY `fk_dependencies_dependson_bugs_bug_id`  ;

	ALTER TABLE `duplicates` 
		DROP FOREIGN KEY `fk_duplicates_dupe_bugs_bug_id`  , 
		DROP FOREIGN KEY `fk_duplicates_dupe_of_bugs_bug_id`  ;

	ALTER TABLE `email_bug_ignore` 
		DROP FOREIGN KEY `fk_email_bug_ignore_bug_id_bugs_bug_id`  , 
		DROP FOREIGN KEY `fk_email_bug_ignore_user_id_profiles_userid`  ;

	ALTER TABLE `email_setting` 
		DROP FOREIGN KEY `fk_email_setting_user_id_profiles_userid`  ;

	ALTER TABLE `field_visibility` 
		DROP FOREIGN KEY `fk_field_visibility_field_id_fielddefs_id`  ;

	ALTER TABLE `fielddefs` 
		DROP FOREIGN KEY `fk_fielddefs_value_field_id_fielddefs_id`  , 
		DROP FOREIGN KEY `fk_fielddefs_visibility_field_id_fielddefs_id`  ;

	ALTER TABLE `flagexclusions` 
		DROP FOREIGN KEY `fk_flagexclusions_component_id_components_id`  , 
		DROP FOREIGN KEY `fk_flagexclusions_product_id_products_id`  , 
		DROP FOREIGN KEY `fk_flagexclusions_type_id_flagtypes_id`  ;

	ALTER TABLE `flaginclusions` 
		DROP FOREIGN KEY `fk_flaginclusions_component_id_components_id`  , 
		DROP FOREIGN KEY `fk_flaginclusions_product_id_products_id`  , 
		DROP FOREIGN KEY `fk_flaginclusions_type_id_flagtypes_id`  ;

	ALTER TABLE `flags` 
		DROP FOREIGN KEY `fk_flags_attach_id_attachments_attach_id`  , 
		DROP FOREIGN KEY `fk_flags_bug_id_bugs_bug_id`  , 
		DROP FOREIGN KEY `fk_flags_requestee_id_profiles_userid`  , 
		DROP FOREIGN KEY `fk_flags_setter_id_profiles_userid`  , 
		DROP FOREIGN KEY `fk_flags_type_id_flagtypes_id`  ;

	ALTER TABLE `flagtypes` 
		DROP FOREIGN KEY `fk_flagtypes_grant_group_id_groups_id`  , 
		DROP FOREIGN KEY `fk_flagtypes_request_group_id_groups_id`  ;

	ALTER TABLE `group_control_map` 
		DROP FOREIGN KEY `fk_group_control_map_group_id_groups_id`  , 
		DROP FOREIGN KEY `fk_group_control_map_product_id_products_id`  ;

	ALTER TABLE `group_group_map` 
		DROP FOREIGN KEY `fk_group_group_map_grantor_id_groups_id`  , 
		DROP FOREIGN KEY `fk_group_group_map_member_id_groups_id`  ;

	ALTER TABLE `keywords` 
		DROP FOREIGN KEY `fk_keywords_bug_id_bugs_bug_id`  , 
		DROP FOREIGN KEY `fk_keywords_keywordid_keyworddefs_id`  ;

	ALTER TABLE `login_failure` 
		DROP FOREIGN KEY `fk_login_failure_user_id_profiles_userid`  ;

	ALTER TABLE `logincookies` 
		DROP FOREIGN KEY `fk_logincookies_userid_profiles_userid`  ;

	ALTER TABLE `longdescs` 
		DROP FOREIGN KEY `fk_longdescs_bug_id_bugs_bug_id`  , 
		DROP FOREIGN KEY `fk_longdescs_who_profiles_userid`  ;

	ALTER TABLE `longdescs_tags` 
		DROP FOREIGN KEY `fk_longdescs_tags_comment_id_longdescs_comment_id`  ;

	ALTER TABLE `longdescs_tags_activity` 
		DROP FOREIGN KEY `fk_longdescs_tags_activity_bug_id_bugs_bug_id`  , 
		DROP FOREIGN KEY `fk_longdescs_tags_activity_comment_id_longdescs_comment_id`  , 
		DROP FOREIGN KEY `fk_longdescs_tags_activity_who_profiles_userid`  ;

	ALTER TABLE `milestones` 
		DROP FOREIGN KEY `fk_milestones_product_id_products_id`  ;

	ALTER TABLE `namedqueries` 
		DROP FOREIGN KEY `fk_namedqueries_userid_profiles_userid`  ;

	ALTER TABLE `namedqueries_link_in_footer` 
		DROP FOREIGN KEY `fk_namedqueries_link_in_footer_namedquery_id_namedqueries_id`  , 
		DROP FOREIGN KEY `fk_namedqueries_link_in_footer_user_id_profiles_userid`  ;

	ALTER TABLE `namedquery_group_map` 
		DROP FOREIGN KEY `fk_namedquery_group_map_group_id_groups_id`  , 
		DROP FOREIGN KEY `fk_namedquery_group_map_namedquery_id_namedqueries_id`  ;

	ALTER TABLE `products` 
		DROP FOREIGN KEY `fk_products_classification_id_classifications_id`  ;

	ALTER TABLE `profile_search` 
		DROP FOREIGN KEY `fk_profile_search_user_id_profiles_userid`  ;

	ALTER TABLE `profile_setting` 
		DROP FOREIGN KEY `fk_profile_setting_setting_name_setting_name`  , 
		DROP FOREIGN KEY `fk_profile_setting_user_id_profiles_userid`  ;

	ALTER TABLE `profiles_activity` 
		DROP FOREIGN KEY `fk_profiles_activity_fieldid_fielddefs_id`  , 
		DROP FOREIGN KEY `fk_profiles_activity_userid_profiles_userid`  , 
		DROP FOREIGN KEY `fk_profiles_activity_who_profiles_userid`  ;

	ALTER TABLE `quips` 
		DROP FOREIGN KEY `fk_quips_userid_profiles_userid`  ;

	ALTER TABLE `reports` 
		DROP FOREIGN KEY `fk_reports_user_id_profiles_userid`  ;

	ALTER TABLE `series` 
		DROP FOREIGN KEY `fk_series_category_series_categories_id`  , 
		DROP FOREIGN KEY `fk_series_creator_profiles_userid`  , 
		DROP FOREIGN KEY `fk_series_subcategory_series_categories_id`  ;

	ALTER TABLE `series_data` 
		DROP FOREIGN KEY `fk_series_data_series_id_series_series_id`  ;

	ALTER TABLE `setting_value` 
		DROP FOREIGN KEY `fk_setting_value_name_setting_name`  ;

	ALTER TABLE `status_workflow` 
		DROP FOREIGN KEY `fk_status_workflow_new_status_bug_status_id`  , 
		DROP FOREIGN KEY `fk_status_workflow_old_status_bug_status_id`  ;

	ALTER TABLE `tag` 
		DROP FOREIGN KEY `fk_tag_user_id_profiles_userid`  ;

	ALTER TABLE `tokens` 
		DROP FOREIGN KEY `fk_tokens_userid_profiles_userid`  ;

	ALTER TABLE `user_api_keys` 
		DROP FOREIGN KEY `fk_user_api_keys_user_id_profiles_userid`  ;

	ALTER TABLE `user_group_map` 
		DROP FOREIGN KEY `fk_user_group_map_group_id_groups_id`  , 
		DROP FOREIGN KEY `fk_user_group_map_user_id_profiles_userid`  ;

	ALTER TABLE `ut_data_to_add_user_to_a_case` 
		DROP FOREIGN KEY `add_user_to_a_case_case_id`  , 
		DROP FOREIGN KEY `add_user_to_a_case_invitee_bz_id`  , 
		DROP FOREIGN KEY `add_user_to_a_case_invitor_bz_id`  ;

	ALTER TABLE `ut_data_to_add_user_to_a_role` 
		DROP FOREIGN KEY `add_user_to_a_role_bz_user_id`  , 
		DROP FOREIGN KEY `add_user_to_a_role_invitor_bz_id`  , 
		DROP FOREIGN KEY `add_user_to_a_role_product_id`  , 
		DROP FOREIGN KEY `add_user_to_a_role_role_type_id`  ;

	ALTER TABLE `ut_data_to_create_units` 
		DROP FOREIGN KEY `new_unit_classification_id_must_exist`  , 
		DROP FOREIGN KEY `new_unit_unit_creator_bz_id_must_exist`  ;

	ALTER TABLE `ut_data_to_replace_dummy_roles` 
		DROP FOREIGN KEY `replace_dummy_product_id`  , 
		DROP FOREIGN KEY `replace_dummy_role_bz_user_id`  , 
		DROP FOREIGN KEY `replace_dummy_role_invitor_bz_user_id`  , 
		DROP FOREIGN KEY `replace_dummy_role_role_type`  ;

	ALTER TABLE `ut_invitation_api_data` 
		DROP FOREIGN KEY `invitation_bz_invitee_must_exist`  , 
		DROP FOREIGN KEY `invitation_bz_invitor_must_exist`  , 
		DROP FOREIGN KEY `invitation_bz_product_must_exist`  , 
		DROP FOREIGN KEY `invitation_invitation_type_must_exist`  ;

	ALTER TABLE `ut_map_invitation_type_to_permission_type` 
		DROP FOREIGN KEY `map_invitation_to_permission_invitation_type_id`  , 
		DROP FOREIGN KEY `map_invitation_to_permission_permission_type_id`  ;

	ALTER TABLE `ut_permission_types` 
		DROP FOREIGN KEY `premission_groupe_type`  ;

	ALTER TABLE `versions` 
		DROP FOREIGN KEY `fk_versions_product_id_products_id`  ;

	ALTER TABLE `watch` 
		DROP FOREIGN KEY `fk_watch_watched_profiles_userid`  , 
		DROP FOREIGN KEY `fk_watch_watcher_profiles_userid`  ;

	ALTER TABLE `whine_events` 
		DROP FOREIGN KEY `fk_whine_events_owner_userid_profiles_userid`  ;

	ALTER TABLE `whine_queries` 
		DROP FOREIGN KEY `fk_whine_queries_eventid_whine_events_id`  ;

	ALTER TABLE `whine_schedules` 
		DROP FOREIGN KEY `fk_whine_schedules_eventid_whine_events_id`  ;


	/* Alter table in target */
	ALTER TABLE `attach_data` 
		CHANGE `id` `id` mediumint(9) unsigned   NOT NULL first ;

	/* Alter table in target */
	ALTER TABLE `attachments` 
		CHANGE `attach_id` `attach_id` mediumint(9) unsigned   NOT NULL auto_increment first , 
		CHANGE `bug_id` `bug_id` mediumint(9) unsigned   NOT NULL after `attach_id` , 
		CHANGE `submitter_id` `submitter_id` mediumint(9) unsigned   NOT NULL after `filename` ;

	/* Alter table in target */
	ALTER TABLE `audit_log` 
		CHANGE `user_id` `user_id` mediumint(9) unsigned   NULL first , 
		CHANGE `object_id` `object_id` int(11) unsigned   NOT NULL after `class` ;

	/* Alter table in target */
	ALTER TABLE `bug_cf_ipi_clust_3_roadbook_for` 
		CHANGE `bug_id` `bug_id` mediumint(9) unsigned   NOT NULL first ;

	/* Alter table in target */
	ALTER TABLE `bug_cf_ipi_clust_9_acct_action` 
		CHANGE `bug_id` `bug_id` mediumint(9) unsigned   NOT NULL first ;

	/* Alter table in target */
	ALTER TABLE `bug_group_map` 
		CHANGE `bug_id` `bug_id` mediumint(9) unsigned   NOT NULL first , 
		CHANGE `group_id` `group_id` mediumint(9) unsigned   NOT NULL after `bug_id` ;

	/* Alter table in target */
	ALTER TABLE `bug_see_also` 
		CHANGE `id` `id` mediumint(9) unsigned   NOT NULL auto_increment first , 
		CHANGE `bug_id` `bug_id` mediumint(9) unsigned   NOT NULL after `id` ;

	/* Alter table in target */
	ALTER TABLE `bug_severity` 
		CHANGE `id` `id` smallint(6) unsigned   NOT NULL auto_increment first , 
		CHANGE `sortkey` `sortkey` smallint(6) unsigned   NOT NULL DEFAULT 0 after `value` , 
		CHANGE `visibility_value_id` `visibility_value_id` smallint(6) unsigned   NULL after `isactive` ;

	/* Alter table in target */
	ALTER TABLE `bug_status` 
		CHANGE `id` `id` smallint(6) unsigned   NOT NULL auto_increment first , 
		CHANGE `sortkey` `sortkey` smallint(6) unsigned   NOT NULL DEFAULT 0 after `value` , 
		CHANGE `visibility_value_id` `visibility_value_id` smallint(6) unsigned   NULL after `isactive` ;

	/* Alter table in target */
	ALTER TABLE `bug_tag` 
		CHANGE `bug_id` `bug_id` mediumint(9) unsigned   NOT NULL first , 
		CHANGE `tag_id` `tag_id` mediumint(9) unsigned   NOT NULL after `bug_id` ;

	/* Alter table in target */
	ALTER TABLE `bug_user_last_visit` 
		CHANGE `id` `id` int(11) unsigned   NOT NULL auto_increment first , 
		CHANGE `user_id` `user_id` mediumint(9) unsigned   NOT NULL after `id` , 
		CHANGE `bug_id` `bug_id` mediumint(9) unsigned   NOT NULL after `user_id` ;

	/* Alter table in target */
	ALTER TABLE `bugs` 
		CHANGE `bug_id` `bug_id` mediumint(9) unsigned   NOT NULL auto_increment first , 
		CHANGE `assigned_to` `assigned_to` mediumint(9) unsigned   NOT NULL after `bug_id` , 
		CHANGE `product_id` `product_id` mediumint(9) unsigned   NOT NULL after `priority` , 
		CHANGE `reporter` `reporter` mediumint(9) unsigned   NOT NULL after `rep_platform` , 
		CHANGE `component_id` `component_id` mediumint(9) unsigned   NOT NULL after `version` , 
		CHANGE `qa_contact` `qa_contact` mediumint(9) unsigned   NULL after `target_milestone` , 
		CHANGE `cf_ipi_clust_3_nber_field_visits` `cf_ipi_clust_3_nber_field_visits` int(11) unsigned   NOT NULL DEFAULT 0 after `cf_ipi_clust_3_action_type` ;

	/* Alter table in target */
	ALTER TABLE `bugs_activity` 
		CHANGE `id` `id` int(11) unsigned   NOT NULL auto_increment first , 
		CHANGE `bug_id` `bug_id` mediumint(9) unsigned   NOT NULL after `id` , 
		CHANGE `attach_id` `attach_id` mediumint(9) unsigned   NULL after `bug_id` , 
		CHANGE `who` `who` mediumint(9) unsigned   NOT NULL after `attach_id` , 
		CHANGE `fieldid` `fieldid` mediumint(9) unsigned   NOT NULL after `bug_when` , 
		CHANGE `comment_id` `comment_id` int(11) unsigned   NULL after `removed` ;

	/* Alter table in target */
	ALTER TABLE `bugs_aliases` 
		CHANGE `bug_id` `bug_id` mediumint(9) unsigned   NULL after `alias` ;

	/* Alter table in target */
	ALTER TABLE `bugs_fulltext` 
		CHANGE `bug_id` `bug_id` mediumint(9) unsigned   NOT NULL first ;

	/* Alter table in target */
	ALTER TABLE `category_group_map` 
		CHANGE `category_id` `category_id` mediumint(9) unsigned   NOT NULL first , 
		CHANGE `group_id` `group_id` mediumint(9) unsigned   NOT NULL after `category_id` ;

	/* Alter table in target */
	ALTER TABLE `cc` 
		CHANGE `bug_id` `bug_id` mediumint(9) unsigned   NOT NULL first , 
		CHANGE `who` `who` mediumint(9) unsigned   NOT NULL after `bug_id` ;

	/* Alter table in target */
	ALTER TABLE `cf_ipi_clust_3_action_type` 
		CHANGE `id` `id` smallint(6) unsigned   NOT NULL auto_increment first , 
		CHANGE `sortkey` `sortkey` smallint(6) unsigned   NOT NULL DEFAULT 0 after `value` , 
		CHANGE `visibility_value_id` `visibility_value_id` smallint(6) unsigned   NULL after `isactive` ;

	/* Alter table in target */
	ALTER TABLE `cf_ipi_clust_3_roadbook_for` 
		CHANGE `id` `id` smallint(6) unsigned   NOT NULL auto_increment first , 
		CHANGE `sortkey` `sortkey` smallint(6) unsigned   NOT NULL DEFAULT 0 after `value` , 
		CHANGE `visibility_value_id` `visibility_value_id` smallint(6) unsigned   NULL after `isactive` ;

	/* Alter table in target */
	ALTER TABLE `cf_ipi_clust_4_status_in_progress` 
		CHANGE `id` `id` smallint(6) unsigned   NOT NULL auto_increment first , 
		CHANGE `sortkey` `sortkey` smallint(6) unsigned   NOT NULL DEFAULT 0 after `value` , 
		CHANGE `visibility_value_id` `visibility_value_id` smallint(6) unsigned   NULL after `isactive` ;

	/* Alter table in target */
	ALTER TABLE `cf_ipi_clust_4_status_standby` 
		CHANGE `id` `id` smallint(6) unsigned   NOT NULL auto_increment first , 
		CHANGE `sortkey` `sortkey` smallint(6) unsigned   NOT NULL DEFAULT 0 after `value` , 
		CHANGE `visibility_value_id` `visibility_value_id` smallint(6) unsigned   NULL after `isactive` ;

	/* Alter table in target */
	ALTER TABLE `cf_ipi_clust_6_claim_type` 
		CHANGE `id` `id` smallint(6) unsigned   NOT NULL auto_increment first , 
		CHANGE `sortkey` `sortkey` smallint(6) unsigned   NOT NULL DEFAULT 0 after `value` , 
		CHANGE `visibility_value_id` `visibility_value_id` smallint(6) unsigned   NULL after `isactive` ;

	/* Alter table in target */
	ALTER TABLE `cf_ipi_clust_7_spe_payment_type` 
		CHANGE `id` `id` smallint(6) unsigned   NOT NULL auto_increment first , 
		CHANGE `sortkey` `sortkey` smallint(6) unsigned   NOT NULL DEFAULT 0 after `value` , 
		CHANGE `visibility_value_id` `visibility_value_id` smallint(6) unsigned   NULL after `isactive` ;

	/* Alter table in target */
	ALTER TABLE `cf_ipi_clust_9_acct_action` 
		CHANGE `id` `id` smallint(6) unsigned   NOT NULL auto_increment first , 
		CHANGE `sortkey` `sortkey` smallint(6) unsigned   NOT NULL DEFAULT 0 after `value` , 
		CHANGE `visibility_value_id` `visibility_value_id` smallint(6) unsigned   NULL after `isactive` ;

	/* Alter table in target */
	ALTER TABLE `cf_specific_for` 
		CHANGE `id` `id` smallint(6) unsigned   NOT NULL auto_increment first , 
		CHANGE `sortkey` `sortkey` smallint(6) unsigned   NOT NULL DEFAULT 0 after `value` , 
		CHANGE `visibility_value_id` `visibility_value_id` smallint(6) unsigned   NULL after `isactive` ;

	/* Alter table in target */
	ALTER TABLE `classifications` 
		CHANGE `id` `id` mediumint(9) unsigned   NOT NULL auto_increment first , 
		CHANGE `sortkey` `sortkey` smallint(6) unsigned   NOT NULL DEFAULT 0 after `description` ;

	/* Alter table in target */
	ALTER TABLE `component_cc` 
		CHANGE `user_id` `user_id` mediumint(9) unsigned   NOT NULL first , 
		CHANGE `component_id` `component_id` mediumint(9) unsigned   NOT NULL after `user_id` ;

	/* Alter table in target */
	ALTER TABLE `components` 
		CHANGE `id` `id` mediumint(9) unsigned   NOT NULL auto_increment first , 
		CHANGE `product_id` `product_id` mediumint(9) unsigned   NOT NULL after `name` , 
		CHANGE `initialowner` `initialowner` mediumint(9) unsigned   NOT NULL after `product_id` , 
		CHANGE `initialqacontact` `initialqacontact` mediumint(9) unsigned   NULL after `initialowner` ;

	/* Alter table in target */
	ALTER TABLE `dependencies` 
		CHANGE `blocked` `blocked` mediumint(9) unsigned   NOT NULL first , 
		CHANGE `dependson` `dependson` mediumint(9) unsigned   NOT NULL after `blocked` ;

	/* Alter table in target */
	ALTER TABLE `duplicates` 
		CHANGE `dupe_of` `dupe_of` mediumint(9) unsigned   NOT NULL first , 
		CHANGE `dupe` `dupe` mediumint(9) unsigned   NOT NULL after `dupe_of` ;

	/* Alter table in target */
	ALTER TABLE `email_bug_ignore` 
		CHANGE `user_id` `user_id` mediumint(9) unsigned   NOT NULL first , 
		CHANGE `bug_id` `bug_id` mediumint(9) unsigned   NOT NULL after `user_id` ;

	/* Alter table in target */
	ALTER TABLE `email_setting` 
		CHANGE `user_id` `user_id` mediumint(9) unsigned   NOT NULL first ;

	/* Alter table in target */
	ALTER TABLE `field_visibility` 
		CHANGE `field_id` `field_id` mediumint(9) unsigned   NULL first , 
		CHANGE `value_id` `value_id` smallint(6) unsigned   NOT NULL after `field_id` ;

	/* Alter table in target */
	ALTER TABLE `fielddefs` 
		CHANGE `id` `id` mediumint(9) unsigned   NOT NULL auto_increment first , 
		CHANGE `type` `type` smallint(6) unsigned   NOT NULL DEFAULT 0 after `name` , 
		CHANGE `sortkey` `sortkey` smallint(6) unsigned   NOT NULL after `mailhead` , 
		CHANGE `visibility_field_id` `visibility_field_id` mediumint(9) unsigned   NULL after `buglist` , 
		CHANGE `value_field_id` `value_field_id` mediumint(9) unsigned   NULL after `visibility_field_id` ;

	/* Alter table in target */
	ALTER TABLE `flagexclusions` 
		CHANGE `type_id` `type_id` mediumint(9) unsigned   NOT NULL first , 
		CHANGE `product_id` `product_id` mediumint(9) unsigned   NULL after `type_id` , 
		CHANGE `component_id` `component_id` mediumint(9) unsigned   NULL after `product_id` ;

	/* Alter table in target */
	ALTER TABLE `flaginclusions` 
		CHANGE `type_id` `type_id` mediumint(9) unsigned   NOT NULL first , 
		CHANGE `product_id` `product_id` mediumint(9) unsigned   NULL after `type_id` , 
		CHANGE `component_id` `component_id` mediumint(9) unsigned   NULL after `product_id` ;

	/* Alter table in target */
	ALTER TABLE `flags` 
		CHANGE `id` `id` mediumint(9) unsigned   NOT NULL auto_increment first , 
		CHANGE `type_id` `type_id` mediumint(9) unsigned   NOT NULL after `id` , 
		CHANGE `bug_id` `bug_id` mediumint(9) unsigned   NOT NULL after `status` , 
		CHANGE `attach_id` `attach_id` mediumint(9) unsigned   NULL after `bug_id` , 
		CHANGE `setter_id` `setter_id` mediumint(9) unsigned   NOT NULL after `modification_date` , 
		CHANGE `requestee_id` `requestee_id` mediumint(9) unsigned   NULL after `setter_id` ;

	/* Alter table in target */
	ALTER TABLE `flagtypes` 
		CHANGE `id` `id` mediumint(9) unsigned   NOT NULL auto_increment first , 
		CHANGE `sortkey` `sortkey` smallint(6) unsigned   NOT NULL DEFAULT 0 after `is_multiplicable` , 
		CHANGE `grant_group_id` `grant_group_id` mediumint(9) unsigned   NULL after `sortkey` , 
		CHANGE `request_group_id` `request_group_id` mediumint(9) unsigned   NULL after `grant_group_id` ;

	/* Alter table in target */
	ALTER TABLE `group_control_map` 
		CHANGE `group_id` `group_id` mediumint(9) unsigned   NOT NULL first , 
		CHANGE `product_id` `product_id` mediumint(9) unsigned   NOT NULL after `group_id` ;

	/* Alter table in target */
	ALTER TABLE `group_group_map` 
		CHANGE `member_id` `member_id` mediumint(9) unsigned   NOT NULL first , 
		CHANGE `grantor_id` `grantor_id` mediumint(9) unsigned   NOT NULL after `member_id` ;

	/* Alter table in target */
	ALTER TABLE `groups` 
		CHANGE `id` `id` mediumint(9) unsigned   NOT NULL auto_increment first ;

	/* Alter table in target */
	ALTER TABLE `keyworddefs` 
		CHANGE `id` `id` smallint(6) unsigned   NOT NULL auto_increment first ;

	/* Alter table in target */
	ALTER TABLE `keywords` 
		CHANGE `bug_id` `bug_id` mediumint(9) unsigned   NOT NULL first , 
		CHANGE `keywordid` `keywordid` smallint(6) unsigned   NOT NULL after `bug_id` ;

	/* Alter table in target */
	ALTER TABLE `login_failure` 
		CHANGE `user_id` `user_id` mediumint(9) unsigned   NOT NULL first ;

	/* Alter table in target */
	ALTER TABLE `logincookies` 
		CHANGE `userid` `userid` mediumint(9) unsigned   NOT NULL after `cookie` ;

	/* Alter table in target */
	ALTER TABLE `longdescs` 
		CHANGE `comment_id` `comment_id` int(11) unsigned   NOT NULL auto_increment first , 
		CHANGE `bug_id` `bug_id` mediumint(9) unsigned   NOT NULL after `comment_id` , 
		CHANGE `who` `who` mediumint(9) unsigned   NOT NULL after `bug_id` , 
		CHANGE `type` `type` smallint(6) unsigned   NOT NULL DEFAULT 0 after `already_wrapped` ;

	/* Alter table in target */
	ALTER TABLE `longdescs_tags` 
		CHANGE `id` `id` mediumint(9) unsigned   NOT NULL auto_increment first , 
		CHANGE `comment_id` `comment_id` int(11) unsigned   NULL after `id` ;

	/* Alter table in target */
	ALTER TABLE `longdescs_tags_activity` 
		CHANGE `id` `id` mediumint(9) unsigned   NOT NULL auto_increment first , 
		CHANGE `bug_id` `bug_id` mediumint(9) unsigned   NOT NULL after `id` , 
		CHANGE `comment_id` `comment_id` int(11) unsigned   NULL after `bug_id` , 
		CHANGE `who` `who` mediumint(9) unsigned   NOT NULL after `comment_id` ;

	/* Alter table in target */
	ALTER TABLE `longdescs_tags_weights` 
		CHANGE `id` `id` mediumint(9) unsigned   NOT NULL auto_increment first , 
		CHANGE `weight` `weight` mediumint(9) unsigned   NOT NULL after `tag` ;

	/* Alter table in target */
	ALTER TABLE `mail_staging` 
		CHANGE `id` `id` int(11) unsigned   NOT NULL auto_increment first ;

	/* Alter table in target */
	ALTER TABLE `milestones` 
		CHANGE `id` `id` mediumint(9) unsigned   NOT NULL auto_increment first , 
		CHANGE `product_id` `product_id` mediumint(9) unsigned   NOT NULL after `id` , 
		CHANGE `sortkey` `sortkey` smallint(6) unsigned   NOT NULL DEFAULT 0 after `value` ;

	/* Alter table in target */
	ALTER TABLE `namedqueries` 
		CHANGE `id` `id` mediumint(9) unsigned   NOT NULL auto_increment first , 
		CHANGE `userid` `userid` mediumint(9) unsigned   NOT NULL after `id` ;

	/* Alter table in target */
	ALTER TABLE `namedqueries_link_in_footer` 
		CHANGE `namedquery_id` `namedquery_id` mediumint(9) unsigned   NOT NULL first , 
		CHANGE `user_id` `user_id` mediumint(9) unsigned   NOT NULL after `namedquery_id` ;

	/* Alter table in target */
	ALTER TABLE `namedquery_group_map` 
		CHANGE `namedquery_id` `namedquery_id` mediumint(9) unsigned   NOT NULL first , 
		CHANGE `group_id` `group_id` mediumint(9) unsigned   NOT NULL after `namedquery_id` ;

	/* Alter table in target */
	ALTER TABLE `op_sys` 
		CHANGE `id` `id` smallint(6) unsigned   NOT NULL auto_increment first , 
		CHANGE `sortkey` `sortkey` smallint(6) unsigned   NOT NULL DEFAULT 0 after `value` , 
		CHANGE `visibility_value_id` `visibility_value_id` smallint(6) unsigned   NULL after `isactive` ;

	/* Alter table in target */
	ALTER TABLE `priority` 
		CHANGE `id` `id` smallint(6) unsigned   NOT NULL auto_increment first , 
		CHANGE `sortkey` `sortkey` smallint(6) unsigned   NOT NULL DEFAULT 0 after `value` , 
		CHANGE `visibility_value_id` `visibility_value_id` smallint(6) unsigned   NULL after `isactive` ;

	/* Alter table in target */
	ALTER TABLE `products` 
		CHANGE `id` `id` mediumint(9) unsigned   NOT NULL auto_increment first , 
		CHANGE `classification_id` `classification_id` mediumint(9) unsigned   NOT NULL DEFAULT 1 after `name` ;

	/* Alter table in target */
	ALTER TABLE `profile_search` 
		CHANGE `id` `id` int(11) unsigned   NOT NULL auto_increment first , 
		CHANGE `user_id` `user_id` mediumint(9) unsigned   NOT NULL after `id` ;

	/* Alter table in target */
	ALTER TABLE `profile_setting` 
		CHANGE `user_id` `user_id` mediumint(9) unsigned   NOT NULL first ;

	/* Alter table in target */
	ALTER TABLE `profiles` 
		CHANGE `userid` `userid` mediumint(9) unsigned   NOT NULL auto_increment first ;

	/* Alter table in target */
	ALTER TABLE `profiles_activity` 
		CHANGE `id` `id` mediumint(9) unsigned   NOT NULL auto_increment first , 
		CHANGE `userid` `userid` mediumint(9) unsigned   NOT NULL after `id` , 
		CHANGE `who` `who` mediumint(9) unsigned   NOT NULL after `userid` , 
		CHANGE `fieldid` `fieldid` mediumint(9) unsigned   NOT NULL after `profiles_when` ;

	/* Alter table in target */
	ALTER TABLE `quips` 
		CHANGE `quipid` `quipid` mediumint(9) unsigned   NOT NULL auto_increment first , 
		CHANGE `userid` `userid` mediumint(9) unsigned   NULL after `quipid` ;

	/* Alter table in target */
	ALTER TABLE `rep_platform` 
		CHANGE `id` `id` smallint(6) unsigned   NOT NULL auto_increment first , 
		CHANGE `sortkey` `sortkey` smallint(6) unsigned   NOT NULL DEFAULT 0 after `value` , 
		CHANGE `visibility_value_id` `visibility_value_id` smallint(6) unsigned   NULL after `isactive` ;

	/* Alter table in target */
	ALTER TABLE `reports` 
		CHANGE `id` `id` mediumint(9) unsigned   NOT NULL auto_increment first , 
		CHANGE `user_id` `user_id` mediumint(9) unsigned   NOT NULL after `id` ;

	/* Alter table in target */
	ALTER TABLE `resolution` 
		CHANGE `id` `id` smallint(6) unsigned   NOT NULL auto_increment first , 
		CHANGE `sortkey` `sortkey` smallint(6) unsigned   NOT NULL DEFAULT 0 after `value` , 
		CHANGE `visibility_value_id` `visibility_value_id` smallint(6) unsigned   NULL after `isactive` ;

	/* Alter table in target */
	ALTER TABLE `series` 
		CHANGE `series_id` `series_id` mediumint(9) unsigned   NOT NULL auto_increment first , 
		CHANGE `creator` `creator` mediumint(9) unsigned   NULL after `series_id` , 
		CHANGE `category` `category` mediumint(9) unsigned   NOT NULL after `creator` , 
		CHANGE `subcategory` `subcategory` mediumint(9) unsigned   NOT NULL after `category` , 
		CHANGE `frequency` `frequency` smallint(6) unsigned   NOT NULL after `name` ;

	/* Alter table in target */
	ALTER TABLE `series_categories` 
		CHANGE `id` `id` mediumint(9) unsigned   NOT NULL auto_increment first ;

	/* Alter table in target */
	ALTER TABLE `series_data` 
		CHANGE `series_id` `series_id` mediumint(9) unsigned   NOT NULL first , 
		CHANGE `series_value` `series_value` mediumint(9) unsigned   NOT NULL after `series_date` ;

	/* Alter table in target */
	ALTER TABLE `setting_value` 
		CHANGE `sortindex` `sortindex` smallint(6) unsigned   NOT NULL after `value` ;

	/* Alter table in target */
	ALTER TABLE `status_workflow` 
		CHANGE `old_status` `old_status` smallint(6) unsigned   NULL first , 
		CHANGE `new_status` `new_status` smallint(6) unsigned   NOT NULL after `old_status` ;

	/* Alter table in target */
	ALTER TABLE `tag` 
		CHANGE `id` `id` mediumint(9) unsigned   NOT NULL auto_increment first , 
		CHANGE `user_id` `user_id` mediumint(9) unsigned   NOT NULL after `name` ;

	/* Alter table in target */
	ALTER TABLE `tokens` 
		CHANGE `userid` `userid` mediumint(9) unsigned   NULL first ;

	/* Alter table in target */
	ALTER TABLE `ts_error` 
		CHANGE `error_time` `error_time` int(11) unsigned   NOT NULL first , 
		CHANGE `jobid` `jobid` int(11) unsigned   NOT NULL after `error_time` , 
		CHANGE `funcid` `funcid` int(11) unsigned   NOT NULL DEFAULT 0 after `message` ;

	/* Alter table in target */
	ALTER TABLE `ts_exitstatus` 
		CHANGE `jobid` `jobid` int(11) unsigned   NOT NULL auto_increment first , 
		CHANGE `funcid` `funcid` int(11) unsigned   NOT NULL DEFAULT 0 after `jobid` , 
		CHANGE `status` `status` smallint(6) unsigned   NULL after `funcid` , 
		CHANGE `completion_time` `completion_time` int(11) unsigned   NULL after `status` , 
		CHANGE `delete_after` `delete_after` int(11) unsigned   NULL after `completion_time` ;

	/* Alter table in target */
	ALTER TABLE `ts_funcmap` 
		CHANGE `funcid` `funcid` int(11) unsigned   NOT NULL auto_increment first ;

	/* Alter table in target */
	ALTER TABLE `ts_job` 
		CHANGE `jobid` `jobid` int(11) unsigned   NOT NULL auto_increment first , 
		CHANGE `funcid` `funcid` int(11) unsigned   NOT NULL after `jobid` , 
		CHANGE `insert_time` `insert_time` int(11) unsigned   NULL after `uniqkey` , 
		CHANGE `run_after` `run_after` int(11) unsigned   NOT NULL after `insert_time` , 
		CHANGE `grabbed_until` `grabbed_until` int(11) unsigned   NOT NULL after `run_after` , 
		CHANGE `priority` `priority` smallint(6) unsigned   NULL after `grabbed_until` ;

	/* Alter table in target */
	ALTER TABLE `ts_note` 
		CHANGE `jobid` `jobid` int(11) unsigned   NOT NULL first ;

	/* Alter table in target */
	ALTER TABLE `user_api_keys` 
		CHANGE `id` `id` int(11) unsigned   NOT NULL auto_increment first , 
		CHANGE `user_id` `user_id` mediumint(9) unsigned   NOT NULL after `id` ;

	/* Alter table in target */
	ALTER TABLE `user_group_map` 
		CHANGE `user_id` `user_id` mediumint(9) unsigned   NOT NULL first , 
		CHANGE `group_id` `group_id` mediumint(9) unsigned   NOT NULL after `user_id` ;

	/* Alter table in target */
	ALTER TABLE `ut_all_units` 
		CHANGE `id_record` `id_record` int(11) unsigned   NOT NULL auto_increment first , 
		CHANGE `product_id` `product_id` mediumint(9) unsigned   NOT NULL COMMENT 'The id in the `products` table' after `id_record` ;

	/* Alter table in target */
	ALTER TABLE `ut_audit_log` 
		CHANGE `id_ut_log` `id_ut_log` int(11) unsigned   NOT NULL auto_increment COMMENT 'The id of the record in this table' first ;

	/* Alter table in target */
	ALTER TABLE `ut_contractor_types` 
		CHANGE `id_contractor_type` `id_contractor_type` smallint(6) unsigned   NOT NULL auto_increment COMMENT 'ID in this table' first ;

	/* Alter table in target */
	ALTER TABLE `ut_contractors` 
		CHANGE `id_contractor` `id_contractor` int(11) unsigned   NOT NULL auto_increment COMMENT 'ID in this table' first ;

	/* Alter table in target */
	ALTER TABLE `ut_data_to_add_user_to_a_case` 
		CHANGE `id` `id` int(11) unsigned   NOT NULL auto_increment COMMENT 'The unique ID in this table' first , 
		CHANGE `bzfe_invitor_user_id` `bzfe_invitor_user_id` mediumint(9) unsigned   NOT NULL COMMENT 'The BZFE user id who creates this unit. this is a FK to the BZ table \'profiles\'' after `mefe_invitor_user_id` , 
		CHANGE `bz_user_id` `bz_user_id` mediumint(9) unsigned   NOT NULL COMMENT 'The userid for the user that will be rfeplcing the dummy user for this role for this unit. This is a FK to the BZ table \'profiles\'' after `bzfe_invitor_user_id` , 
		CHANGE `bz_case_id` `bz_case_id` mediumint(9) unsigned   NOT NULL COMMENT 'The case id that the user is invited to - This is a FK to the BZ table \'bugs\'' after `bz_user_id` ;

	/* Alter table in target */
	ALTER TABLE `ut_data_to_add_user_to_a_role` 
		CHANGE `id` `id` int(11) unsigned   NOT NULL auto_increment COMMENT 'The unique ID in this table' first , 
		CHANGE `bzfe_invitor_user_id` `bzfe_invitor_user_id` mediumint(9) unsigned   NOT NULL COMMENT 'The BZFE user id who creates this unit. this is a FK to the BZ table \'profiles\'' after `mefe_invitor_user_id` , 
		CHANGE `bz_unit_id` `bz_unit_id` mediumint(9) unsigned   NOT NULL COMMENT 'The product id in the BZ table \'products\'' after `bzfe_invitor_user_id` , 
		CHANGE `bz_user_id` `bz_user_id` mediumint(9) unsigned   NOT NULL COMMENT 'The userid for the user that will be rfeplcing the dummy user for this role for this unit. This is a FK to the BZ table \'profiles\'' after `bz_unit_id` , 
		CHANGE `user_role_type_id` `user_role_type_id` smallint(6) unsigned   NOT NULL COMMENT 'The id of the role type for the invited user. This is a FK to the table \'ut_role_types\'' after `bz_user_id` ;

	/* Alter table in target */
	ALTER TABLE `ut_data_to_create_units` 
		CHANGE `id_unit_to_create` `id_unit_to_create` int(11) unsigned   NOT NULL auto_increment COMMENT 'The unique ID in this table' first , 
		CHANGE `bzfe_creator_user_id` `bzfe_creator_user_id` mediumint(9) unsigned   NOT NULL COMMENT 'The BZFE user id who creates this unit. this is a FK to the BZ table \'profiles\'' after `mefe_creator_user_id` , 
		CHANGE `classification_id` `classification_id` mediumint(9) unsigned   NOT NULL COMMENT 'The ID of the classification for this unit - a FK to the BZ table \'classifications\'' after `bzfe_creator_user_id` , 
		CHANGE `product_id` `product_id` mediumint(9) unsigned   NULL COMMENT 'The id of the product in the BZ table \'products\'. Because this is a record that we will keep even AFTER we deleted the record in the BZ table, this can NOT be a FK.' after `comment` ;

	/* Alter table in target */
	ALTER TABLE `ut_data_to_replace_dummy_roles` 
		CHANGE `id` `id` int(11) unsigned   NOT NULL auto_increment COMMENT 'The unique ID in this table' first , 
		CHANGE `bzfe_invitor_user_id` `bzfe_invitor_user_id` mediumint(9) unsigned   NOT NULL COMMENT 'The BZFE user id who creates this unit. this is a FK to the BZ table \'profiles\'' after `mefe_invitor_user_id` , 
		CHANGE `bz_unit_id` `bz_unit_id` mediumint(9) unsigned   NOT NULL COMMENT 'The product id in the BZ table \'products\'' after `bzfe_invitor_user_id` , 
		CHANGE `bz_user_id` `bz_user_id` mediumint(9) unsigned   NOT NULL COMMENT 'The userid for the user that will be rfeplcing the dummy user for this role for this unit. This is a FK to the BZ table \'profiles\'' after `bz_unit_id` , 
		CHANGE `user_role_type_id` `user_role_type_id` smallint(6) unsigned   NOT NULL COMMENT 'The id of the role type for the invited user. This is a FK to the table \'ut_role_types\'' after `bz_user_id` ;

	/* Alter table in target */
	ALTER TABLE `ut_db_schema_version` 
		CHANGE `id` `id` int(11) unsigned   NOT NULL auto_increment COMMENT 'Unique ID in this table' first ;

	/* Alter table in target */
	ALTER TABLE `ut_group_types` 
		CHANGE `id_group_type` `id_group_type` mediumint(9) unsigned   NOT NULL auto_increment COMMENT 'ID in this table' first , 
		CHANGE `order` `order` smallint(6) unsigned   NULL COMMENT 'Order in the list' after `created` ;

	/* Alter table in target */
	ALTER TABLE `ut_invitation_api_data` 
		CHANGE `id` `id` int(11) unsigned   NOT NULL auto_increment COMMENT 'The unique ID in this table' first , 
		CHANGE `bzfe_invitor_user_id` `bzfe_invitor_user_id` mediumint(9) unsigned   NOT NULL COMMENT 'The BZFE user id who creates this unit. this is a FK to the BZ table \'profiles\'' after `mefe_invitation_id` , 
		CHANGE `bz_user_id` `bz_user_id` mediumint(9) unsigned   NOT NULL COMMENT 'The userid for the user that will be rfeplcing the dummy user for this role for this unit. This is a FK to the BZ table \'profiles\'' after `bzfe_invitor_user_id` , 
		CHANGE `user_role_type_id` `user_role_type_id` smallint(6) unsigned   NOT NULL COMMENT 'The id of the role type for the invited user. This is a FK to the table \'ut_role_types\'' after `bz_user_id` , 
		CHANGE `bz_case_id` `bz_case_id` mediumint(9) unsigned   NULL COMMENT 'The id of the bug in th table \'bugs\'' after `is_occupant` , 
		CHANGE `bz_unit_id` `bz_unit_id` mediumint(9) unsigned   NOT NULL COMMENT 'The product id in the BZ table \'products\'' after `bz_case_id` ;

	/* Alter table in target */
	ALTER TABLE `ut_invitation_types` 
		CHANGE `id_invitation_type` `id_invitation_type` smallint(6) unsigned   NOT NULL auto_increment COMMENT 'ID in this table' first , 
		CHANGE `order` `order` smallint(6) unsigned   NULL COMMENT 'Order in the list' after `created` ;

	/* Alter table in target */
	ALTER TABLE `ut_log_count_closed_cases` 
		CHANGE `id_log_closed_case` `id_log_closed_case` int(11) unsigned   NOT NULL auto_increment COMMENT 'Unique id in this table' first , 
		CHANGE `count_closed_cases` `count_closed_cases` int(11) unsigned   NOT NULL COMMENT 'The number of closed case at this Datetime' after `timestamp` , 
		CHANGE `count_total_cases` `count_total_cases` int(11) unsigned   NULL COMMENT 'The total number of cases in Unee-T at this time' after `count_closed_cases` ;

	/* Alter table in target */
	ALTER TABLE `ut_log_count_enabled_units` 
		CHANGE `id_log_enabled_units` `id_log_enabled_units` int(11) unsigned   NOT NULL auto_increment COMMENT 'Unique id in this table' first , 
		CHANGE `count_enabled_units` `count_enabled_units` int(11) unsigned   NOT NULL COMMENT 'The number of enabled products/units at this Datetime' after `timestamp` , 
		CHANGE `count_total_units` `count_total_units` int(11) unsigned   NOT NULL COMMENT 'The total number of products/units at this Datetime' after `count_enabled_units` ;

	/* Alter table in target */
	ALTER TABLE `ut_map_contractor_to_type` 
		CHANGE `contractor_id` `contractor_id` int(11) unsigned   NOT NULL COMMENT 'id in the table `ut_contractors`' first , 
		CHANGE `contractor_type_id` `contractor_type_id` mediumint(9) unsigned   NOT NULL COMMENT 'id in the table `ut_contractor_types`' after `contractor_id` ;

	/* Alter table in target */
	ALTER TABLE `ut_map_contractor_to_user` 
		CHANGE `contractor_id` `contractor_id` int(11) unsigned   NOT NULL COMMENT 'id in the table `ut_contractors`' first , 
		CHANGE `bz_user_id` `bz_user_id` mediumint(9) unsigned   NOT NULL COMMENT 'id in the table `profiles`' after `contractor_id` ;

	/* Alter table in target */
	ALTER TABLE `ut_map_invitation_type_to_permission_type` 
		CHANGE `invitation_type_id` `invitation_type_id` smallint(6) unsigned   NOT NULL COMMENT 'id of the invitation type in the table `ut_invitation_types`' first , 
		CHANGE `permission_type_id` `permission_type_id` smallint(6) unsigned   NOT NULL COMMENT 'id of the permission type in the table `ut_permission_types`' after `invitation_type_id` , 
		CHANGE `record_created_by` `record_created_by` mediumint(9) unsigned   NULL COMMENT 'id of the user who created this user in the bz `profiles` table' after `created` ;

	/* Alter table in target */
	ALTER TABLE `ut_map_user_mefe_bzfe` 
		CHANGE `record_created_by` `record_created_by` mediumint(9) unsigned   NULL COMMENT 'id of the user who created this user in the bz `profiles` table' after `created` ;

	/* Alter table in target */
	ALTER TABLE `ut_map_user_unit_details` 
		CHANGE `record_created_by` `record_created_by` mediumint(9) unsigned   NULL COMMENT 'id of the user who created this user in the bz `profiles` table' after `created` , 
		CHANGE `user_id` `user_id` int(11) unsigned   NULL COMMENT 'id of the user in the MEFE' after `is_obsolete` , 
		CHANGE `bz_unit_id` `bz_unit_id` mediumint(9) unsigned   NULL COMMENT 'The id of the unit in the BZFE' after `bz_profile_id` , 
		CHANGE `role_type_id` `role_type_id` smallint(6) unsigned   NULL COMMENT 'An id in the table ut_role_types: the role of the user for this unit' after `bz_unit_id` ;

	/* Alter table in target */
	ALTER TABLE `ut_notification_case_assignee` 
		CHANGE `notification_id` `notification_id` int(11) unsigned   NOT NULL auto_increment COMMENT 'Id in this table' first , 
		CHANGE `unit_id` `unit_id` mediumint(9) unsigned   NULL COMMENT 'Unit ID - a FK to the BZ table \'products\'' after `processed_datetime` , 
		CHANGE `case_id` `case_id` mediumint(9) unsigned   NULL COMMENT 'Case ID - a FK to the BZ table \'bugs\'' after `unit_id` , 
		CHANGE `invitor_user_id` `invitor_user_id` mediumint(9) unsigned   NULL COMMENT 'User ID - The user who inititated the change - a FK to the BZ table \'profiles\'' after `case_title` , 
		CHANGE `case_reporter_user_id` `case_reporter_user_id` mediumint(9) unsigned   NULL COMMENT 'User ID - BZ user id of the reporter for the case' after `invitor_user_id` , 
		CHANGE `old_case_assignee_user_id` `old_case_assignee_user_id` mediumint(9) unsigned   NULL COMMENT 'User ID - BZ user id of the assignee for the case before the change' after `case_reporter_user_id` , 
		CHANGE `new_case_assignee_user_id` `new_case_assignee_user_id` mediumint(9) unsigned   NULL COMMENT 'User ID - BZ user id of the assignee for the case after the change' after `old_case_assignee_user_id` ;

	/* Alter table in target */
	ALTER TABLE `ut_notification_case_invited` 
		CHANGE `notification_id` `notification_id` int(11) unsigned   NOT NULL auto_increment COMMENT 'Id in this table' first , 
		CHANGE `unit_id` `unit_id` mediumint(9) unsigned   NULL COMMENT 'Unit ID - a FK to the BZ table \'products\'' after `processed_datetime` , 
		CHANGE `case_id` `case_id` mediumint(9) unsigned   NULL COMMENT 'Case ID - a FK to the BZ table \'bugs\'' after `unit_id` , 
		CHANGE `invitor_user_id` `invitor_user_id` mediumint(9) unsigned   NULL COMMENT 'User ID - The user who inititated the change - a FK to the BZ table \'profiles\'' after `case_title` , 
		CHANGE `invitee_user_id` `invitee_user_id` mediumint(9) unsigned   NULL COMMENT 'User ID - The user who has been invited to the case a FK to the BZ table \'profiles\'' after `invitor_user_id` , 
		CHANGE `case_reporter_user_id` `case_reporter_user_id` mediumint(9) unsigned   NULL COMMENT 'User ID - BZ user id of the reporter for the case' after `invitee_user_id` , 
		CHANGE `old_case_assignee_user_id` `old_case_assignee_user_id` mediumint(9) unsigned   NULL COMMENT 'User ID - BZ user id of the assignee for the case before the change' after `case_reporter_user_id` , 
		CHANGE `new_case_assignee_user_id` `new_case_assignee_user_id` mediumint(9) unsigned   NULL COMMENT 'User ID - BZ user id of the assignee for the case after the change' after `old_case_assignee_user_id` ;

	/* Alter table in target */
	ALTER TABLE `ut_notification_case_new` 
		CHANGE `notification_id` `notification_id` int(11) unsigned   NOT NULL auto_increment COMMENT 'Id in this table' first , 
		CHANGE `unit_id` `unit_id` mediumint(9) unsigned   NULL COMMENT 'Unit ID - a FK to the BZ table \'products\'' after `processed_datetime` , 
		CHANGE `case_id` `case_id` mediumint(9) unsigned   NULL COMMENT 'Case ID - a FK to the BZ table \'bugs\'' after `unit_id` , 
		CHANGE `reporter_user_id` `reporter_user_id` mediumint(9) unsigned   NULL COMMENT 'The BZ profile Id of the reporter for the case' after `case_title` , 
		CHANGE `assignee_user_id` `assignee_user_id` mediumint(9) unsigned   NULL COMMENT 'The BZ profile ID of the Assignee to the case' after `reporter_user_id` ;

	/* Alter table in target */
	ALTER TABLE `ut_notification_case_updated` 
		CHANGE `notification_id` `notification_id` int(11) unsigned   NOT NULL auto_increment COMMENT 'Id in this table' first , 
		CHANGE `unit_id` `unit_id` mediumint(9) unsigned   NULL COMMENT 'Unit ID - a FK to the BZ table \'products\'' after `processed_datetime` , 
		CHANGE `case_id` `case_id` mediumint(9) unsigned   NULL COMMENT 'Case ID - a FK to the BZ table \'bugs\'' after `unit_id` , 
		CHANGE `user_id` `user_id` mediumint(9) unsigned   NULL COMMENT 'User ID - The user who inititated the change - a FK to the BZ table \'profiles\'' after `case_title` , 
		CHANGE `case_reporter_user_id` `case_reporter_user_id` mediumint(9) unsigned   NULL COMMENT 'User ID - BZ user id of the reporter for the case' after `new_value` , 
		CHANGE `old_case_assignee_user_id` `old_case_assignee_user_id` mediumint(9) unsigned   NULL COMMENT 'User ID - BZ user id of the assignee for the case before the change' after `case_reporter_user_id` , 
		CHANGE `new_case_assignee_user_id` `new_case_assignee_user_id` mediumint(9) unsigned   NULL COMMENT 'User ID - BZ user id of the assignee for the case after the change' after `old_case_assignee_user_id` ;

	/* Alter table in target */
	ALTER TABLE `ut_notification_message_new` 
		CHANGE `notification_id` `notification_id` int(11) unsigned   NOT NULL auto_increment COMMENT 'Id in this table' first , 
		CHANGE `unit_id` `unit_id` mediumint(9) unsigned   NULL COMMENT 'Unit ID - a FK to the BZ table \'products\'' after `processed_datetime` , 
		CHANGE `case_id` `case_id` mediumint(9) unsigned   NULL COMMENT 'Case ID - a FK to the BZ table \'bugs\'' after `unit_id` , 
		CHANGE `user_id` `user_id` mediumint(9) unsigned   NULL COMMENT 'User ID - The user who inititated the change - a FK to the BZ table \'profiles\'' after `case_title` , 
		CHANGE `case_reporter_user_id` `case_reporter_user_id` mediumint(9) unsigned   NULL COMMENT 'User ID - BZ user id of the reporter for the case' after `message_truncated` , 
		CHANGE `old_case_assignee_user_id` `old_case_assignee_user_id` mediumint(9) unsigned   NULL COMMENT 'User ID - BZ user id of the assignee for the case before the change' after `case_reporter_user_id` , 
		CHANGE `new_case_assignee_user_id` `new_case_assignee_user_id` mediumint(9) unsigned   NULL COMMENT 'User ID - BZ user id of the assignee for the case after the change' after `old_case_assignee_user_id` ;

	/* Alter table in target */
	ALTER TABLE `ut_notification_types` 
		CHANGE `id_role_type` `id_role_type` smallint(6) unsigned   NOT NULL auto_increment COMMENT 'ID in this table' first ;

	/* Alter table in target */
	ALTER TABLE `ut_permission_types` 
		CHANGE `id_permission_type` `id_permission_type` smallint(6) unsigned   NOT NULL auto_increment COMMENT 'ID in this table' first , 
		CHANGE `order` `order` smallint(6) unsigned   NULL COMMENT 'Order in the list' after `created` , 
		CHANGE `group_type_id` `group_type_id` mediumint(9) unsigned   NULL COMMENT 'The id of the group that grant this permission - a FK to the table ut_group_types' after `is_obsolete` , 
		CHANGE `bless_id` `bless_id` mediumint(9) unsigned   NULL COMMENT 'IF this is a \'blessing\' permission - which permission can this grant' after `is_bless` ;

	/* Alter table in target */
	ALTER TABLE `ut_product_group` 
		CHANGE `product_id` `product_id` mediumint(9) unsigned   NOT NULL COMMENT 'id in the table products - to identify all the groups for a product/unit' first , 
		CHANGE `component_id` `component_id` mediumint(9) unsigned   NULL COMMENT 'id in the table components - to identify all the groups for a given component/role' after `product_id` , 
		CHANGE `group_id` `group_id` mediumint(9) unsigned   NOT NULL COMMENT 'id in the table groups - to map the group to the list in the table `groups`' after `component_id` , 
		CHANGE `group_type_id` `group_type_id` mediumint(9) unsigned   NOT NULL COMMENT 'id in the table ut_group_types - to avoid re-creating the same group for the same product again' after `group_id` , 
		CHANGE `role_type_id` `role_type_id` smallint(6) unsigned   NULL COMMENT 'id in the table ut_role_types - to make sure all similar stakeholder in a unit are made a member of the same group' after `group_type_id` , 
		CHANGE `created_by_id` `created_by_id` mediumint(9) unsigned   NULL COMMENT 'id in the table ut_profiles' after `role_type_id` ;

	/* Alter table in target */
	ALTER TABLE `ut_role_types` 
		CHANGE `id_role_type` `id_role_type` smallint(6) unsigned   NOT NULL auto_increment COMMENT 'ID in this table' first ;

	/* Alter table in target */
	ALTER TABLE `ut_script_log` 
		CHANGE `id_ut_script_log` `id_ut_script_log` int(11) unsigned   NOT NULL auto_increment COMMENT 'The id of the record in this table' first ;

	/* Alter table in target */
	ALTER TABLE `versions` 
		CHANGE `id` `id` mediumint(9) unsigned   NOT NULL auto_increment first , 
		CHANGE `product_id` `product_id` mediumint(9) unsigned   NOT NULL after `value` ;

	/* Alter table in target */
	ALTER TABLE `watch` 
		CHANGE `watcher` `watcher` mediumint(9) unsigned   NOT NULL first , 
		CHANGE `watched` `watched` mediumint(9) unsigned   NOT NULL after `watcher` ;

	/* Alter table in target */
	ALTER TABLE `whine_events` 
		CHANGE `id` `id` mediumint(9) unsigned   NOT NULL auto_increment first , 
		CHANGE `owner_userid` `owner_userid` mediumint(9) unsigned   NOT NULL after `id` ;

	/* Alter table in target */
	ALTER TABLE `whine_queries` 
		CHANGE `id` `id` mediumint(9) unsigned   NOT NULL auto_increment first , 
		CHANGE `eventid` `eventid` mediumint(9) unsigned   NOT NULL after `id` , 
		CHANGE `sortkey` `sortkey` smallint(6) unsigned   NOT NULL DEFAULT 0 after `query_name` ;

	/* Alter table in target */
	ALTER TABLE `whine_schedules` 
		CHANGE `id` `id` mediumint(9) unsigned   NOT NULL auto_increment first , 
		CHANGE `eventid` `eventid` mediumint(9) unsigned   NOT NULL after `id` , 
		CHANGE `mailto` `mailto` mediumint(9) unsigned   NOT NULL after `run_next` , 
		CHANGE `mailto_type` `mailto_type` smallint(6) unsigned   NOT NULL DEFAULT 0 after `mailto` ; 

	/* The foreign keys that were dropped are now re-created*/

	ALTER TABLE `attach_data` 
		ADD CONSTRAINT `fk_attach_data_id_attachments_attach_id` 
		FOREIGN KEY (`id`) REFERENCES `attachments` (`attach_id`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `attachments` 
		ADD CONSTRAINT `fk_attachments_bug_id_bugs_bug_id` 
		FOREIGN KEY (`bug_id`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_attachments_submitter_id_profiles_userid` 
		FOREIGN KEY (`submitter_id`) REFERENCES `profiles` (`userid`) ON UPDATE CASCADE ;

	ALTER TABLE `audit_log` 
		ADD CONSTRAINT `fk_audit_log_user_id_profiles_userid` 
		FOREIGN KEY (`user_id`) REFERENCES `profiles` (`userid`) ON DELETE SET NULL ON UPDATE CASCADE ;

	ALTER TABLE `bug_cf_ipi_clust_3_roadbook_for` 
		ADD CONSTRAINT `fk_0da76aa50ea9cec77ea8e213c8655f99` 
		FOREIGN KEY (`value`) REFERENCES `cf_ipi_clust_3_roadbook_for` (`value`) ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_bug_cf_ipi_clust_3_roadbook_for_bug_id_bugs_bug_id` 
		FOREIGN KEY (`bug_id`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `bug_cf_ipi_clust_9_acct_action` 
		ADD CONSTRAINT `fk_bug_cf_ipi_clust_9_acct_action_bug_id_bugs_bug_id` 
		FOREIGN KEY (`bug_id`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_e5fc7a4f159b990bfcdfcaf844d0728b` 
		FOREIGN KEY (`value`) REFERENCES `cf_ipi_clust_9_acct_action` (`value`) ON UPDATE CASCADE ;

	ALTER TABLE `bug_group_map` 
		ADD CONSTRAINT `fk_bug_group_map_bug_id_bugs_bug_id` 
		FOREIGN KEY (`bug_id`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_bug_group_map_group_id_groups_id` 
		FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `bug_see_also` 
		ADD CONSTRAINT `fk_bug_see_also_bug_id_bugs_bug_id` 
		FOREIGN KEY (`bug_id`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `bug_tag` 
		ADD CONSTRAINT `fk_bug_tag_bug_id_bugs_bug_id` 
		FOREIGN KEY (`bug_id`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_bug_tag_tag_id_tag_id` 
		FOREIGN KEY (`tag_id`) REFERENCES `tag` (`id`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `bug_user_last_visit` 
		ADD CONSTRAINT `fk_bug_user_last_visit_bug_id_bugs_bug_id` 
		FOREIGN KEY (`bug_id`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_bug_user_last_visit_user_id_profiles_userid` 
		FOREIGN KEY (`user_id`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `bugs` 
		ADD CONSTRAINT `fk_bugs_assigned_to_profiles_userid` 
		FOREIGN KEY (`assigned_to`) REFERENCES `profiles` (`userid`) ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_bugs_component_id_components_id` 
		FOREIGN KEY (`component_id`) REFERENCES `components` (`id`) ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_bugs_product_id_products_id` 
		FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_bugs_qa_contact_profiles_userid` 
		FOREIGN KEY (`qa_contact`) REFERENCES `profiles` (`userid`) ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_bugs_reporter_profiles_userid` 
		FOREIGN KEY (`reporter`) REFERENCES `profiles` (`userid`) ON UPDATE CASCADE ;

	ALTER TABLE `bugs_activity` 
		ADD CONSTRAINT `fk_bugs_activity_attach_id_attachments_attach_id` 
		FOREIGN KEY (`attach_id`) REFERENCES `attachments` (`attach_id`) ON DELETE CASCADE ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_bugs_activity_bug_id_bugs_bug_id` 
		FOREIGN KEY (`bug_id`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_bugs_activity_comment_id_longdescs_comment_id` 
		FOREIGN KEY (`comment_id`) REFERENCES `longdescs` (`comment_id`) ON DELETE CASCADE ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_bugs_activity_fieldid_fielddefs_id` 
		FOREIGN KEY (`fieldid`) REFERENCES `fielddefs` (`id`) ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_bugs_activity_who_profiles_userid` 
		FOREIGN KEY (`who`) REFERENCES `profiles` (`userid`) ON UPDATE CASCADE ;

	ALTER TABLE `bugs_aliases` 
		ADD CONSTRAINT `fk_bugs_aliases_bug_id_bugs_bug_id` 
		FOREIGN KEY (`bug_id`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `category_group_map` 
		ADD CONSTRAINT `fk_category_group_map_category_id_series_categories_id` 
		FOREIGN KEY (`category_id`) REFERENCES `series_categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_category_group_map_group_id_groups_id` 
		FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `cc` 
		ADD CONSTRAINT `fk_cc_bug_id_bugs_bug_id` 
		FOREIGN KEY (`bug_id`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_cc_who_profiles_userid` 
		FOREIGN KEY (`who`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `component_cc` 
		ADD CONSTRAINT `fk_component_cc_component_id_components_id` 
		FOREIGN KEY (`component_id`) REFERENCES `components` (`id`) ON DELETE CASCADE ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_component_cc_user_id_profiles_userid` 
		FOREIGN KEY (`user_id`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `components` 
		ADD CONSTRAINT `fk_components_initialowner_profiles_userid` 
		FOREIGN KEY (`initialowner`) REFERENCES `profiles` (`userid`) ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_components_initialqacontact_profiles_userid` 
		FOREIGN KEY (`initialqacontact`) REFERENCES `profiles` (`userid`) ON DELETE SET NULL ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_components_product_id_products_id` 
		FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `dependencies` 
		ADD CONSTRAINT `fk_dependencies_blocked_bugs_bug_id` 
		FOREIGN KEY (`blocked`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_dependencies_dependson_bugs_bug_id` 
		FOREIGN KEY (`dependson`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `duplicates` 
		ADD CONSTRAINT `fk_duplicates_dupe_bugs_bug_id` 
		FOREIGN KEY (`dupe`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_duplicates_dupe_of_bugs_bug_id` 
		FOREIGN KEY (`dupe_of`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `email_bug_ignore` 
		ADD CONSTRAINT `fk_email_bug_ignore_bug_id_bugs_bug_id` 
		FOREIGN KEY (`bug_id`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_email_bug_ignore_user_id_profiles_userid` 
		FOREIGN KEY (`user_id`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `email_setting` 
		ADD CONSTRAINT `fk_email_setting_user_id_profiles_userid` 
		FOREIGN KEY (`user_id`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `field_visibility` 
		ADD CONSTRAINT `fk_field_visibility_field_id_fielddefs_id` 
		FOREIGN KEY (`field_id`) REFERENCES `fielddefs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `fielddefs` 
		ADD CONSTRAINT `fk_fielddefs_value_field_id_fielddefs_id` 
		FOREIGN KEY (`value_field_id`) REFERENCES `fielddefs` (`id`) ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_fielddefs_visibility_field_id_fielddefs_id` 
		FOREIGN KEY (`visibility_field_id`) REFERENCES `fielddefs` (`id`) ON UPDATE CASCADE ;

	ALTER TABLE `flagexclusions` 
		ADD CONSTRAINT `fk_flagexclusions_component_id_components_id` 
		FOREIGN KEY (`component_id`) REFERENCES `components` (`id`) ON DELETE CASCADE ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_flagexclusions_product_id_products_id` 
		FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_flagexclusions_type_id_flagtypes_id` 
		FOREIGN KEY (`type_id`) REFERENCES `flagtypes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `flaginclusions` 
		ADD CONSTRAINT `fk_flaginclusions_component_id_components_id` 
		FOREIGN KEY (`component_id`) REFERENCES `components` (`id`) ON DELETE CASCADE ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_flaginclusions_product_id_products_id` 
		FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_flaginclusions_type_id_flagtypes_id` 
		FOREIGN KEY (`type_id`) REFERENCES `flagtypes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `flags` 
		ADD CONSTRAINT `fk_flags_attach_id_attachments_attach_id` 
		FOREIGN KEY (`attach_id`) REFERENCES `attachments` (`attach_id`) ON DELETE CASCADE ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_flags_bug_id_bugs_bug_id` 
		FOREIGN KEY (`bug_id`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_flags_requestee_id_profiles_userid` 
		FOREIGN KEY (`requestee_id`) REFERENCES `profiles` (`userid`) ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_flags_setter_id_profiles_userid` 
		FOREIGN KEY (`setter_id`) REFERENCES `profiles` (`userid`) ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_flags_type_id_flagtypes_id` 
		FOREIGN KEY (`type_id`) REFERENCES `flagtypes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `flagtypes` 
		ADD CONSTRAINT `fk_flagtypes_grant_group_id_groups_id` 
		FOREIGN KEY (`grant_group_id`) REFERENCES `groups` (`id`) ON DELETE SET NULL ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_flagtypes_request_group_id_groups_id` 
		FOREIGN KEY (`request_group_id`) REFERENCES `groups` (`id`) ON DELETE SET NULL ON UPDATE CASCADE ;

	ALTER TABLE `group_control_map` 
		ADD CONSTRAINT `fk_group_control_map_group_id_groups_id` 
		FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_group_control_map_product_id_products_id` 
		FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `group_group_map` 
		ADD CONSTRAINT `fk_group_group_map_grantor_id_groups_id` 
		FOREIGN KEY (`grantor_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_group_group_map_member_id_groups_id` 
		FOREIGN KEY (`member_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `keywords` 
		ADD CONSTRAINT `fk_keywords_bug_id_bugs_bug_id` 
		FOREIGN KEY (`bug_id`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_keywords_keywordid_keyworddefs_id` 
		FOREIGN KEY (`keywordid`) REFERENCES `keyworddefs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `login_failure` 
		ADD CONSTRAINT `fk_login_failure_user_id_profiles_userid` 
		FOREIGN KEY (`user_id`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `logincookies` 
		ADD CONSTRAINT `fk_logincookies_userid_profiles_userid` 
		FOREIGN KEY (`userid`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `longdescs` 
		ADD CONSTRAINT `fk_longdescs_bug_id_bugs_bug_id` 
		FOREIGN KEY (`bug_id`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_longdescs_who_profiles_userid` 
		FOREIGN KEY (`who`) REFERENCES `profiles` (`userid`) ON UPDATE CASCADE ;

	ALTER TABLE `longdescs_tags` 
		ADD CONSTRAINT `fk_longdescs_tags_comment_id_longdescs_comment_id` 
		FOREIGN KEY (`comment_id`) REFERENCES `longdescs` (`comment_id`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `longdescs_tags_activity` 
		ADD CONSTRAINT `fk_longdescs_tags_activity_bug_id_bugs_bug_id` 
		FOREIGN KEY (`bug_id`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_longdescs_tags_activity_comment_id_longdescs_comment_id` 
		FOREIGN KEY (`comment_id`) REFERENCES `longdescs` (`comment_id`) ON DELETE CASCADE ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_longdescs_tags_activity_who_profiles_userid` 
		FOREIGN KEY (`who`) REFERENCES `profiles` (`userid`) ON UPDATE CASCADE ;

	ALTER TABLE `milestones` 
		ADD CONSTRAINT `fk_milestones_product_id_products_id` 
		FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `namedqueries` 
		ADD CONSTRAINT `fk_namedqueries_userid_profiles_userid` 
		FOREIGN KEY (`userid`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `namedqueries_link_in_footer` 
		ADD CONSTRAINT `fk_namedqueries_link_in_footer_namedquery_id_namedqueries_id` 
		FOREIGN KEY (`namedquery_id`) REFERENCES `namedqueries` (`id`) ON DELETE CASCADE ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_namedqueries_link_in_footer_user_id_profiles_userid` 
		FOREIGN KEY (`user_id`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `namedquery_group_map` 
		ADD CONSTRAINT `fk_namedquery_group_map_group_id_groups_id` 
		FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_namedquery_group_map_namedquery_id_namedqueries_id` 
		FOREIGN KEY (`namedquery_id`) REFERENCES `namedqueries` (`id`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `products` 
		ADD CONSTRAINT `fk_products_classification_id_classifications_id` 
		FOREIGN KEY (`classification_id`) REFERENCES `classifications` (`id`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `profile_search` 
		ADD CONSTRAINT `fk_profile_search_user_id_profiles_userid` 
		FOREIGN KEY (`user_id`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `profile_setting` 
		ADD CONSTRAINT `fk_profile_setting_setting_name_setting_name` 
		FOREIGN KEY (`setting_name`) REFERENCES `setting` (`name`) ON DELETE CASCADE ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_profile_setting_user_id_profiles_userid` 
		FOREIGN KEY (`user_id`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `profiles_activity` 
		ADD CONSTRAINT `fk_profiles_activity_fieldid_fielddefs_id` 
		FOREIGN KEY (`fieldid`) REFERENCES `fielddefs` (`id`) ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_profiles_activity_userid_profiles_userid` 
		FOREIGN KEY (`userid`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_profiles_activity_who_profiles_userid` 
		FOREIGN KEY (`who`) REFERENCES `profiles` (`userid`) ON UPDATE CASCADE ;

	ALTER TABLE `quips` 
		ADD CONSTRAINT `fk_quips_userid_profiles_userid` 
		FOREIGN KEY (`userid`) REFERENCES `profiles` (`userid`) ON DELETE SET NULL ON UPDATE CASCADE ;

	ALTER TABLE `reports` 
		ADD CONSTRAINT `fk_reports_user_id_profiles_userid` 
		FOREIGN KEY (`user_id`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `series` 
		ADD CONSTRAINT `fk_series_category_series_categories_id` 
		FOREIGN KEY (`category`) REFERENCES `series_categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_series_creator_profiles_userid` 
		FOREIGN KEY (`creator`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_series_subcategory_series_categories_id` 
		FOREIGN KEY (`subcategory`) REFERENCES `series_categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `series_data` 
		ADD CONSTRAINT `fk_series_data_series_id_series_series_id` 
		FOREIGN KEY (`series_id`) REFERENCES `series` (`series_id`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `setting_value` 
		ADD CONSTRAINT `fk_setting_value_name_setting_name` 
		FOREIGN KEY (`name`) REFERENCES `setting` (`name`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `status_workflow` 
		ADD CONSTRAINT `fk_status_workflow_new_status_bug_status_id` 
		FOREIGN KEY (`new_status`) REFERENCES `bug_status` (`id`) ON DELETE CASCADE ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_status_workflow_old_status_bug_status_id` 
		FOREIGN KEY (`old_status`) REFERENCES `bug_status` (`id`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `tag` 
		ADD CONSTRAINT `fk_tag_user_id_profiles_userid` 
		FOREIGN KEY (`user_id`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `tokens` 
		ADD CONSTRAINT `fk_tokens_userid_profiles_userid` 
		FOREIGN KEY (`userid`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `user_api_keys` 
		ADD CONSTRAINT `fk_user_api_keys_user_id_profiles_userid` 
		FOREIGN KEY (`user_id`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `user_group_map` 
		ADD CONSTRAINT `fk_user_group_map_group_id_groups_id` 
		FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_user_group_map_user_id_profiles_userid` 
		FOREIGN KEY (`user_id`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `ut_data_to_add_user_to_a_case` 
		ADD CONSTRAINT `add_user_to_a_case_case_id` 
		FOREIGN KEY (`bz_case_id`) REFERENCES `bugs` (`bug_id`) ON DELETE NO ACTION ON UPDATE CASCADE , 
		ADD CONSTRAINT `add_user_to_a_case_invitee_bz_id` 
		FOREIGN KEY (`bz_user_id`) REFERENCES `profiles` (`userid`) ON DELETE NO ACTION ON UPDATE CASCADE , 
		ADD CONSTRAINT `add_user_to_a_case_invitor_bz_id` 
		FOREIGN KEY (`bzfe_invitor_user_id`) REFERENCES `profiles` (`userid`) ON DELETE NO ACTION ON UPDATE CASCADE ;

	ALTER TABLE `ut_data_to_add_user_to_a_role` 
		ADD CONSTRAINT `add_user_to_a_role_bz_user_id` 
		FOREIGN KEY (`bz_user_id`) REFERENCES `profiles` (`userid`) ON DELETE NO ACTION ON UPDATE CASCADE , 
		ADD CONSTRAINT `add_user_to_a_role_invitor_bz_id` 
		FOREIGN KEY (`bzfe_invitor_user_id`) REFERENCES `profiles` (`userid`) ON DELETE NO ACTION ON UPDATE CASCADE , 
		ADD CONSTRAINT `add_user_to_a_role_product_id` 
		FOREIGN KEY (`bz_unit_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE , 
		ADD CONSTRAINT `add_user_to_a_role_role_type_id` 
		FOREIGN KEY (`user_role_type_id`) REFERENCES `ut_role_types` (`id_role_type`) ON DELETE NO ACTION ON UPDATE CASCADE ;

	ALTER TABLE `ut_data_to_create_units` 
		ADD CONSTRAINT `new_unit_classification_id_must_exist` 
		FOREIGN KEY (`classification_id`) REFERENCES `classifications` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE , 
		ADD CONSTRAINT `new_unit_unit_creator_bz_id_must_exist` 
		FOREIGN KEY (`bzfe_creator_user_id`) REFERENCES `profiles` (`userid`) ON DELETE NO ACTION ON UPDATE CASCADE ;

	ALTER TABLE `ut_data_to_replace_dummy_roles` 
		ADD CONSTRAINT `replace_dummy_product_id` 
		FOREIGN KEY (`bz_unit_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE , 
		ADD CONSTRAINT `replace_dummy_role_bz_user_id` 
		FOREIGN KEY (`bz_user_id`) REFERENCES `profiles` (`userid`) ON DELETE NO ACTION ON UPDATE CASCADE , 
		ADD CONSTRAINT `replace_dummy_role_invitor_bz_user_id` 
		FOREIGN KEY (`bzfe_invitor_user_id`) REFERENCES `profiles` (`userid`) ON DELETE NO ACTION ON UPDATE CASCADE , 
		ADD CONSTRAINT `replace_dummy_role_role_type` 
		FOREIGN KEY (`user_role_type_id`) REFERENCES `ut_role_types` (`id_role_type`) ON DELETE NO ACTION ON UPDATE CASCADE ;

	ALTER TABLE `ut_invitation_api_data` 
		ADD CONSTRAINT `invitation_bz_invitee_must_exist` 
		FOREIGN KEY (`bz_user_id`) REFERENCES `profiles` (`userid`) , 
		ADD CONSTRAINT `invitation_bz_invitor_must_exist` 
		FOREIGN KEY (`bzfe_invitor_user_id`) REFERENCES `profiles` (`userid`) , 
		ADD CONSTRAINT `invitation_bz_product_must_exist` 
		FOREIGN KEY (`bz_unit_id`) REFERENCES `products` (`id`) , 
		ADD CONSTRAINT `invitation_invitation_type_must_exist` 
		FOREIGN KEY (`invitation_type`) REFERENCES `ut_invitation_types` (`invitation_type`) ;

	ALTER TABLE `ut_map_invitation_type_to_permission_type` 
		ADD CONSTRAINT `map_invitation_to_permission_invitation_type_id` 
		FOREIGN KEY (`invitation_type_id`) REFERENCES `ut_invitation_types` (`id_invitation_type`) , 
		ADD CONSTRAINT `map_invitation_to_permission_permission_type_id` 
		FOREIGN KEY (`permission_type_id`) REFERENCES `ut_permission_types` (`id_permission_type`) ;

	ALTER TABLE `ut_permission_types` 
		ADD CONSTRAINT `premission_groupe_type` 
		FOREIGN KEY (`group_type_id`) REFERENCES `ut_group_types` (`id_group_type`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `versions` 
		ADD CONSTRAINT `fk_versions_product_id_products_id` 
		FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `watch` 
		ADD CONSTRAINT `fk_watch_watched_profiles_userid` 
		FOREIGN KEY (`watched`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE , 
		ADD CONSTRAINT `fk_watch_watcher_profiles_userid` 
		FOREIGN KEY (`watcher`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `whine_events` 
		ADD CONSTRAINT `fk_whine_events_owner_userid_profiles_userid` 
		FOREIGN KEY (`owner_userid`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `whine_queries` 
		ADD CONSTRAINT `fk_whine_queries_eventid_whine_events_id` 
		FOREIGN KEY (`eventid`) REFERENCES `whine_events` (`id`) ON DELETE CASCADE ON UPDATE CASCADE ;

	ALTER TABLE `whine_schedules` 
		ADD CONSTRAINT `fk_whine_schedules_eventid_whine_events_id` 
		FOREIGN KEY (`eventid`) REFERENCES `whine_events` (`id`) ON DELETE CASCADE ON UPDATE CASCADE ;

	/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;

# We can now unlock the tables

	UNLOCK TABLES;

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