/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

USE `bugs`; 

/* Foreign Keys must be dropped in the target to ensure that requires changes can be done*/

ALTER TABLE `attach_data` 
	DROP FOREIGN KEY `fk_attach_data_id_attachments_attach_id`  ;

ALTER TABLE `attachments` 
	DROP FOREIGN KEY `fk_attachments_bug_id_bugs_bug_id`  , 
	DROP FOREIGN KEY `fk_attachments_submitter_id_profiles_userid`  ;

ALTER TABLE `audit_log` 
	DROP FOREIGN KEY `fk_audit_log_user_id_profiles_userid`  ;

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
	CHANGE `id` `id` mediumint(9) unsigned   NOT NULL first , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `attachments` 
	CHANGE `attach_id` `attach_id` mediumint(9) unsigned   NOT NULL auto_increment first , 
	CHANGE `bug_id` `bug_id` mediumint(9) unsigned   NOT NULL after `attach_id` , 
	CHANGE `creation_ts` `creation_ts` datetime   NOT NULL after `bug_id` , 
	CHANGE `modification_time` `modification_time` datetime   NOT NULL after `creation_ts` , 
	CHANGE `description` `description` text  COLLATE utf8mb4_unicode_520_ci NOT NULL after `modification_time` , 
	CHANGE `mimetype` `mimetype` text  COLLATE utf8mb4_unicode_520_ci NOT NULL after `description` , 
	CHANGE `filename` `filename` varchar(255)  COLLATE utf8mb4_unicode_520_ci NOT NULL after `ispatch` , 
	CHANGE `submitter_id` `submitter_id` mediumint(9) unsigned   NOT NULL after `filename` , 
	DROP COLUMN `attach_size` , 
	DROP KEY `attachments_ispatch_idx` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `audit_log` 
	CHANGE `user_id` `user_id` mediumint(9) unsigned   NULL first , 
	CHANGE `object_id` `object_id` int(11) unsigned   NOT NULL after `class` , 
	CHANGE `removed` `removed` longtext  COLLATE utf8mb4_unicode_520_ci NULL after `field` , 
	CHANGE `added` `added` longtext  COLLATE utf8mb4_unicode_520_ci NULL after `removed` , 
	CHANGE `at_time` `at_time` datetime   NOT NULL after `added` , ROW_FORMAT = Dynamic ;

/* Create table in target */
CREATE TABLE `bug_cf_ipi_clust_3_roadbook_for`(
	`bug_id` mediumint(9) unsigned NOT NULL  , 
	`value` varchar(64) COLLATE utf8mb4_unicode_520_ci NOT NULL  , 
	UNIQUE KEY `bug_cf_ipi_clust_3_roadbook_for_bug_id_idx`(`bug_id`,`value`) , 
	KEY `fk_0da76aa50ea9cec77ea8e213c8655f99`(`value`) , 
	CONSTRAINT `fk_0da76aa50ea9cec77ea8e213c8655f99` 
	FOREIGN KEY (`value`) REFERENCES `cf_ipi_clust_3_roadbook_for` (`value`) ON UPDATE CASCADE , 
	CONSTRAINT `fk_bug_cf_ipi_clust_3_roadbook_for_bug_id_bugs_bug_id` 
	FOREIGN KEY (`bug_id`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Create table in target */
CREATE TABLE `bug_cf_ipi_clust_9_acct_action`(
	`bug_id` mediumint(9) unsigned NOT NULL  , 
	`value` varchar(64) COLLATE utf8mb4_unicode_520_ci NOT NULL  , 
	UNIQUE KEY `bug_cf_ipi_clust_9_acct_action_bug_id_idx`(`bug_id`,`value`) , 
	KEY `fk_e5fc7a4f159b990bfcdfcaf844d0728b`(`value`) , 
	CONSTRAINT `fk_bug_cf_ipi_clust_9_acct_action_bug_id_bugs_bug_id` 
	FOREIGN KEY (`bug_id`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE , 
	CONSTRAINT `fk_e5fc7a4f159b990bfcdfcaf844d0728b` 
	FOREIGN KEY (`value`) REFERENCES `cf_ipi_clust_9_acct_action` (`value`) ON UPDATE CASCADE 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Alter table in target */
ALTER TABLE `bug_group_map` 
	CHANGE `bug_id` `bug_id` mediumint(9) unsigned   NOT NULL first , 
	CHANGE `group_id` `group_id` mediumint(9) unsigned   NOT NULL after `bug_id` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `bug_see_also` 
	CHANGE `id` `id` mediumint(9) unsigned   NOT NULL auto_increment first , 
	CHANGE `bug_id` `bug_id` mediumint(9) unsigned   NOT NULL after `id` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `bug_severity` 
	CHANGE `id` `id` smallint(6) unsigned   NOT NULL auto_increment first , 
	CHANGE `sortkey` `sortkey` smallint(6) unsigned   NOT NULL DEFAULT 0 after `value` , 
	CHANGE `visibility_value_id` `visibility_value_id` smallint(6) unsigned   NULL after `isactive` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `bug_status` 
	CHANGE `id` `id` smallint(6) unsigned   NOT NULL auto_increment first , 
	CHANGE `sortkey` `sortkey` smallint(6) unsigned   NOT NULL DEFAULT 0 after `value` , 
	CHANGE `visibility_value_id` `visibility_value_id` smallint(6) unsigned   NULL after `isactive` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `bug_tag` 
	CHANGE `bug_id` `bug_id` mediumint(9) unsigned   NOT NULL first , 
	CHANGE `tag_id` `tag_id` mediumint(9) unsigned   NOT NULL after `bug_id` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `bug_user_last_visit` 
	CHANGE `id` `id` int(11) unsigned   NOT NULL auto_increment first , 
	CHANGE `user_id` `user_id` mediumint(9) unsigned   NOT NULL after `id` , 
	CHANGE `bug_id` `bug_id` mediumint(9) unsigned   NOT NULL after `user_id` , 
	CHANGE `last_visit_ts` `last_visit_ts` datetime   NOT NULL after `bug_id` ;

/* Alter table in target */
ALTER TABLE `bugs` 
	CHANGE `bug_id` `bug_id` mediumint(9) unsigned   NOT NULL auto_increment first , 
	CHANGE `assigned_to` `assigned_to` mediumint(9) unsigned   NOT NULL after `bug_id` , 
	CHANGE `bug_file_loc` `bug_file_loc` longtext  COLLATE utf8mb4_unicode_520_ci NOT NULL after `assigned_to` , 
	CHANGE `creation_ts` `creation_ts` datetime   NULL after `bug_status` , 
	CHANGE `delta_ts` `delta_ts` datetime   NOT NULL after `creation_ts` , 
	CHANGE `product_id` `product_id` mediumint(9) unsigned   NOT NULL after `priority` , 
	CHANGE `reporter` `reporter` mediumint(9) unsigned   NOT NULL after `rep_platform` , 
	CHANGE `component_id` `component_id` mediumint(9) unsigned   NOT NULL after `version` , 
	CHANGE `target_milestone` `target_milestone` varchar(64)  COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '---' after `resolution` , 
	CHANGE `qa_contact` `qa_contact` mediumint(9) unsigned   NULL after `target_milestone` , 
	CHANGE `status_whiteboard` `status_whiteboard` longtext  COLLATE utf8mb4_unicode_520_ci NOT NULL after `qa_contact` , 
	CHANGE `lastdiffed` `lastdiffed` datetime   NULL after `status_whiteboard` , 
	CHANGE `deadline` `deadline` datetime   NULL after `remaining_time` , 
	ADD COLUMN `cf_ipi_clust_4_status_in_progress` varchar(64)  COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '---' after `deadline` , 
	ADD COLUMN `cf_ipi_clust_4_status_standby` varchar(64)  COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '---' after `cf_ipi_clust_4_status_in_progress` , 
	ADD COLUMN `cf_ipi_clust_2_room` varchar(255)  COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '' after `cf_ipi_clust_4_status_standby` , 
	ADD COLUMN `cf_ipi_clust_6_claim_type` varchar(64)  COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '---' after `cf_ipi_clust_2_room` , 
	ADD COLUMN `cf_ipi_clust_1_solution` longtext  COLLATE utf8mb4_unicode_520_ci NOT NULL after `cf_ipi_clust_6_claim_type` , 
	ADD COLUMN `cf_ipi_clust_1_next_step` longtext  COLLATE utf8mb4_unicode_520_ci NOT NULL after `cf_ipi_clust_1_solution` , 
	ADD COLUMN `cf_ipi_clust_1_next_step_date` date   NULL after `cf_ipi_clust_1_next_step` , 
	ADD COLUMN `cf_ipi_clust_3_field_action` longtext  COLLATE utf8mb4_unicode_520_ci NOT NULL after `cf_ipi_clust_1_next_step_date` , 
	ADD COLUMN `cf_ipi_clust_3_field_action_from` datetime   NULL after `cf_ipi_clust_3_field_action` , 
	ADD COLUMN `cf_ipi_clust_3_field_action_until` datetime   NULL after `cf_ipi_clust_3_field_action_from` , 
	ADD COLUMN `cf_ipi_clust_3_action_type` varchar(64)  COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '---' after `cf_ipi_clust_3_field_action_until` , 
	ADD COLUMN `cf_ipi_clust_3_nber_field_visits` int(11) unsigned   NOT NULL DEFAULT 0 after `cf_ipi_clust_3_action_type` , 
	ADD COLUMN `cf_ipi_clust_5_approved_budget` varchar(255)  COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '' after `cf_ipi_clust_3_nber_field_visits` , 
	ADD COLUMN `cf_ipi_clust_5_budget` varchar(255)  COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '' after `cf_ipi_clust_5_approved_budget` , 
	ADD COLUMN `cf_ipi_clust_8_contract_id` varchar(255)  COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '' after `cf_ipi_clust_5_budget` , 
	ADD COLUMN `cf_ipi_clust_9_inv_ll` varchar(255)  COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '' after `cf_ipi_clust_8_contract_id` , 
	ADD COLUMN `cf_ipi_clust_9_inv_det_ll` varchar(255)  COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '' after `cf_ipi_clust_9_inv_ll` , 
	ADD COLUMN `cf_ipi_clust_9_inv_cust` longtext  COLLATE utf8mb4_unicode_520_ci NOT NULL after `cf_ipi_clust_9_inv_det_ll` , 
	ADD COLUMN `cf_ipi_clust_9_inv_det_cust` longtext  COLLATE utf8mb4_unicode_520_ci NOT NULL after `cf_ipi_clust_9_inv_cust` , 
	ADD COLUMN `cf_ipi_clust_5_spe_action_purchase_list` varchar(255)  COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '' after `cf_ipi_clust_9_inv_det_cust` , 
	ADD COLUMN `cf_ipi_clust_5_spe_approval_for` longtext  COLLATE utf8mb4_unicode_520_ci NOT NULL after `cf_ipi_clust_5_spe_action_purchase_list` , 
	ADD COLUMN `cf_ipi_clust_5_spe_approval_comment` longtext  COLLATE utf8mb4_unicode_520_ci NOT NULL after `cf_ipi_clust_5_spe_approval_for` , 
	ADD COLUMN `cf_ipi_clust_5_spe_contractor` longtext  COLLATE utf8mb4_unicode_520_ci NOT NULL after `cf_ipi_clust_5_spe_approval_comment` , 
	ADD COLUMN `cf_ipi_clust_5_spe_purchase_cost` varchar(255)  COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '' after `cf_ipi_clust_5_spe_contractor` , 
	ADD COLUMN `cf_ipi_clust_7_spe_bill_number` varchar(255)  COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '' after `cf_ipi_clust_5_spe_purchase_cost` , 
	ADD COLUMN `cf_ipi_clust_7_spe_payment_type` varchar(64)  COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '---' after `cf_ipi_clust_7_spe_bill_number` , 
	ADD COLUMN `cf_ipi_clust_7_spe_contractor_payment` longtext  COLLATE utf8mb4_unicode_520_ci NOT NULL after `cf_ipi_clust_7_spe_payment_type` , 
	ADD COLUMN `cf_ipi_clust_8_spe_customer` varchar(255)  COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '' after `cf_ipi_clust_7_spe_contractor_payment` , 
	ADD COLUMN `cf_specific_for` varchar(64)  COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '---' after `cf_ipi_clust_8_spe_customer` , 
	ADD COLUMN `cf_ut_org_specific_dd_1` varchar(64)  COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '---' after `cf_specific_for` , 
	DROP COLUMN `bug_type` , 
	DROP COLUMN `alias` , 
	DROP COLUMN `cf_last_resolved` , 
	DROP COLUMN `cf_crash_signature` , 
	DROP COLUMN `restrict_comments` , 
	DROP COLUMN `votes` , 
	DROP COLUMN `cf_rank` , 
	DROP COLUMN `cf_user_story` , 
	DROP KEY `bugs_alias_idx` , 
	DROP KEY `bugs_but_type_idx` , 
	DROP KEY `bugs_votes_idx` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `bugs_activity` 
	CHANGE `id` `id` int(11) unsigned   NOT NULL auto_increment first , 
	CHANGE `bug_id` `bug_id` mediumint(9) unsigned   NOT NULL after `id` , 
	CHANGE `attach_id` `attach_id` mediumint(9) unsigned   NULL after `bug_id` , 
	CHANGE `who` `who` mediumint(9) unsigned   NOT NULL after `attach_id` , 
	CHANGE `bug_when` `bug_when` datetime   NOT NULL after `who` , 
	CHANGE `fieldid` `fieldid` mediumint(9) unsigned   NOT NULL after `bug_when` , 
	CHANGE `comment_id` `comment_id` int(11) unsigned   NULL after `removed` , ROW_FORMAT = Dynamic ;

/* Create table in target */
CREATE TABLE `bugs_aliases`(
	`alias` varchar(40) COLLATE utf8mb4_unicode_520_ci NOT NULL  , 
	`bug_id` mediumint(9) unsigned NULL  , 
	UNIQUE KEY `bugs_aliases_alias_idx`(`alias`) , 
	KEY `bugs_aliases_bug_id_idx`(`bug_id`) , 
	CONSTRAINT `fk_bugs_aliases_bug_id_bugs_bug_id` 
	FOREIGN KEY (`bug_id`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Alter table in target */
ALTER TABLE `bugs_fulltext` 
	CHANGE `bug_id` `bug_id` mediumint(9) unsigned   NOT NULL first , 
	CHANGE `comments` `comments` longtext  COLLATE utf8mb4_unicode_520_ci NULL after `short_desc` , 
	CHANGE `comments_noprivate` `comments_noprivate` longtext  COLLATE utf8mb4_unicode_520_ci NULL after `comments` , 
	DROP FOREIGN KEY `fk_bugs_fulltext_bug_id_bugs_bug_id`  , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `bz_schema` ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `category_group_map` 
	CHANGE `category_id` `category_id` mediumint(9) unsigned   NOT NULL first , 
	CHANGE `group_id` `group_id` mediumint(9) unsigned   NOT NULL after `category_id` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `cc` 
	CHANGE `bug_id` `bug_id` mediumint(9) unsigned   NOT NULL first , 
	CHANGE `who` `who` mediumint(9) unsigned   NOT NULL after `bug_id` ;

/* Create table in target */
CREATE TABLE `cf_ipi_clust_3_action_type`(
	`id` smallint(6) unsigned NOT NULL  auto_increment , 
	`value` varchar(64) COLLATE utf8mb4_unicode_520_ci NOT NULL  , 
	`sortkey` smallint(6) unsigned NOT NULL  DEFAULT 0 , 
	`isactive` tinyint(4) NOT NULL  DEFAULT 1 , 
	`visibility_value_id` smallint(6) unsigned NULL  , 
	PRIMARY KEY (`id`) , 
	UNIQUE KEY `cf_ipi_clust_3_action_type_value_idx`(`value`) , 
	KEY `cf_ipi_clust_3_action_type_sortkey_idx`(`sortkey`,`value`) , 
	KEY `cf_ipi_clust_3_action_type_visibility_value_id_idx`(`visibility_value_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Create table in target */
CREATE TABLE `cf_ipi_clust_3_roadbook_for`(
	`id` smallint(6) unsigned NOT NULL  auto_increment , 
	`value` varchar(64) COLLATE utf8mb4_unicode_520_ci NOT NULL  , 
	`sortkey` smallint(6) unsigned NOT NULL  DEFAULT 0 , 
	`isactive` tinyint(4) NOT NULL  DEFAULT 1 , 
	`visibility_value_id` smallint(6) unsigned NULL  , 
	PRIMARY KEY (`id`) , 
	UNIQUE KEY `cf_ipi_clust_3_roadbook_for_value_idx`(`value`) , 
	KEY `cf_ipi_clust_3_roadbook_for_visibility_value_id_idx`(`visibility_value_id`) , 
	KEY `cf_ipi_clust_3_roadbook_for_sortkey_idx`(`sortkey`,`value`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Create table in target */
CREATE TABLE `cf_ipi_clust_4_status_in_progress`(
	`id` smallint(6) unsigned NOT NULL  auto_increment , 
	`value` varchar(64) COLLATE utf8mb4_unicode_520_ci NOT NULL  , 
	`sortkey` smallint(6) unsigned NOT NULL  DEFAULT 0 , 
	`isactive` tinyint(4) NOT NULL  DEFAULT 1 , 
	`visibility_value_id` smallint(6) unsigned NULL  , 
	PRIMARY KEY (`id`) , 
	UNIQUE KEY `cf_ipi_clust_4_status_in_progress_value_idx`(`value`) , 
	KEY `cf_ipi_clust_4_status_in_progress_visibility_value_id_idx`(`visibility_value_id`) , 
	KEY `cf_ipi_clust_4_status_in_progress_sortkey_idx`(`sortkey`,`value`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Create table in target */
CREATE TABLE `cf_ipi_clust_4_status_standby`(
	`id` smallint(6) unsigned NOT NULL  auto_increment , 
	`value` varchar(64) COLLATE utf8mb4_unicode_520_ci NOT NULL  , 
	`sortkey` smallint(6) unsigned NOT NULL  DEFAULT 0 , 
	`isactive` tinyint(4) NOT NULL  DEFAULT 1 , 
	`visibility_value_id` smallint(6) unsigned NULL  , 
	PRIMARY KEY (`id`) , 
	UNIQUE KEY `cf_ipi_clust_4_status_standby_value_idx`(`value`) , 
	KEY `cf_ipi_clust_4_status_standby_visibility_value_id_idx`(`visibility_value_id`) , 
	KEY `cf_ipi_clust_4_status_standby_sortkey_idx`(`sortkey`,`value`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Create table in target */
CREATE TABLE `cf_ipi_clust_6_claim_type`(
	`id` smallint(6) unsigned NOT NULL  auto_increment , 
	`value` varchar(64) COLLATE utf8mb4_unicode_520_ci NOT NULL  , 
	`sortkey` smallint(6) unsigned NOT NULL  DEFAULT 0 , 
	`isactive` tinyint(4) NOT NULL  DEFAULT 1 , 
	`visibility_value_id` smallint(6) unsigned NULL  , 
	PRIMARY KEY (`id`) , 
	UNIQUE KEY `cf_ipi_clust_6_claim_type_value_idx`(`value`) , 
	KEY `cf_ipi_clust_6_claim_type_sortkey_idx`(`sortkey`,`value`) , 
	KEY `cf_ipi_clust_6_claim_type_visibility_value_id_idx`(`visibility_value_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Create table in target */
CREATE TABLE `cf_ipi_clust_7_spe_payment_type`(
	`id` smallint(6) unsigned NOT NULL  auto_increment , 
	`value` varchar(64) COLLATE utf8mb4_unicode_520_ci NOT NULL  , 
	`sortkey` smallint(6) unsigned NOT NULL  DEFAULT 0 , 
	`isactive` tinyint(4) NOT NULL  DEFAULT 1 , 
	`visibility_value_id` smallint(6) unsigned NULL  , 
	PRIMARY KEY (`id`) , 
	UNIQUE KEY `cf_ipi_clust_7_spe_payment_type_value_idx`(`value`) , 
	KEY `cf_ipi_clust_7_spe_payment_type_visibility_value_id_idx`(`visibility_value_id`) , 
	KEY `cf_ipi_clust_7_spe_payment_type_sortkey_idx`(`sortkey`,`value`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Create table in target */
CREATE TABLE `cf_ipi_clust_9_acct_action`(
	`id` smallint(6) unsigned NOT NULL  auto_increment , 
	`value` varchar(64) COLLATE utf8mb4_unicode_520_ci NOT NULL  , 
	`sortkey` smallint(6) unsigned NOT NULL  DEFAULT 0 , 
	`isactive` tinyint(4) NOT NULL  DEFAULT 1 , 
	`visibility_value_id` smallint(6) unsigned NULL  , 
	PRIMARY KEY (`id`) , 
	UNIQUE KEY `cf_ipi_clust_9_acct_action_value_idx`(`value`) , 
	KEY `cf_ipi_clust_9_acct_action_visibility_value_id_idx`(`visibility_value_id`) , 
	KEY `cf_ipi_clust_9_acct_action_sortkey_idx`(`sortkey`,`value`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Create table in target */
CREATE TABLE `cf_specific_for`(
	`id` smallint(6) unsigned NOT NULL  auto_increment , 
	`value` varchar(64) COLLATE utf8mb4_unicode_520_ci NOT NULL  , 
	`sortkey` smallint(6) unsigned NOT NULL  DEFAULT 0 , 
	`isactive` tinyint(4) NOT NULL  DEFAULT 1 , 
	`visibility_value_id` smallint(6) unsigned NULL  , 
	PRIMARY KEY (`id`) , 
	UNIQUE KEY `cf_specific_for_value_idx`(`value`) , 
	KEY `cf_specific_for_sortkey_idx`(`sortkey`,`value`) , 
	KEY `cf_specific_for_visibility_value_id_idx`(`visibility_value_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Create table in target */
CREATE TABLE `cf_ut_org_specific_dd_1`(
	`id` smallint(6) NOT NULL  auto_increment , 
	`value` varchar(64) COLLATE utf8mb4_unicode_520_ci NOT NULL  , 
	`sortkey` smallint(6) NOT NULL  DEFAULT 0 , 
	`isactive` tinyint(4) NOT NULL  DEFAULT 1 , 
	`visibility_value_id` smallint(6) NULL  , 
	PRIMARY KEY (`id`) , 
	UNIQUE KEY `cf_ut_org_specific_dd_1_value_idx`(`value`) , 
	KEY `cf_ut_org_specific_dd_1_visibility_value_id_idx`(`visibility_value_id`) , 
	KEY `cf_ut_org_specific_dd_1_sortkey_idx`(`sortkey`,`value`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Alter table in target */
ALTER TABLE `classifications` 
	CHANGE `id` `id` mediumint(9) unsigned   NOT NULL auto_increment first , 
	CHANGE `description` `description` longtext  COLLATE utf8mb4_unicode_520_ci NULL after `name` , 
	CHANGE `sortkey` `sortkey` smallint(6) unsigned   NOT NULL DEFAULT 0 after `description` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `component_cc` 
	CHANGE `user_id` `user_id` mediumint(9) unsigned   NOT NULL first , 
	CHANGE `component_id` `component_id` mediumint(9) unsigned   NOT NULL after `user_id` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `components` 
	CHANGE `id` `id` mediumint(9) unsigned   NOT NULL auto_increment first , 
	CHANGE `product_id` `product_id` mediumint(9) unsigned   NOT NULL after `name` , 
	CHANGE `initialowner` `initialowner` mediumint(9) unsigned   NOT NULL after `product_id` , 
	CHANGE `initialqacontact` `initialqacontact` mediumint(9) unsigned   NULL after `initialowner` , 
	CHANGE `description` `description` longtext  COLLATE utf8mb4_unicode_520_ci NOT NULL after `initialqacontact` , 
	DROP COLUMN `default_bug_type` , 
	DROP COLUMN `triage_owner_id` , 
	DROP COLUMN `watch_user` , 
	DROP KEY `fk_components_triage_owner_id_profiles_userid` , 
	DROP KEY `fk_components_watch_user_profiles_userid` , 
	DROP FOREIGN KEY `fk_components_triage_owner_id_profiles_userid`  , 
	DROP FOREIGN KEY `fk_components_watch_user_profiles_userid`  , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `dependencies` 
	CHANGE `blocked` `blocked` mediumint(9) unsigned   NOT NULL first , 
	CHANGE `dependson` `dependson` mediumint(9) unsigned   NOT NULL after `blocked` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `duplicates` 
	CHANGE `dupe_of` `dupe_of` mediumint(9) unsigned   NOT NULL first , 
	CHANGE `dupe` `dupe` mediumint(9) unsigned   NOT NULL after `dupe_of` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `email_bug_ignore` 
	CHANGE `user_id` `user_id` mediumint(9) unsigned   NOT NULL first , 
	CHANGE `bug_id` `bug_id` mediumint(9) unsigned   NOT NULL after `user_id` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `email_setting` 
	CHANGE `user_id` `user_id` mediumint(9) unsigned   NOT NULL first , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `field_visibility` 
	CHANGE `field_id` `field_id` mediumint(9) unsigned   NULL first , 
	CHANGE `value_id` `value_id` smallint(6) unsigned   NOT NULL after `field_id` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `fielddefs` 
	CHANGE `id` `id` mediumint(9) unsigned   NOT NULL auto_increment first , 
	CHANGE `type` `type` smallint(6) unsigned   NOT NULL DEFAULT 0 after `name` , 
	CHANGE `description` `description` text  COLLATE utf8mb4_unicode_520_ci NOT NULL after `custom` , 
	ADD COLUMN `long_desc` varchar(255)  COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '' after `description` , 
	CHANGE `mailhead` `mailhead` tinyint(4)   NOT NULL DEFAULT 0 after `long_desc` , 
	CHANGE `sortkey` `sortkey` smallint(6) unsigned   NOT NULL after `mailhead` , 
	CHANGE `visibility_field_id` `visibility_field_id` mediumint(9) unsigned   NULL after `buglist` , 
	CHANGE `value_field_id` `value_field_id` mediumint(9) unsigned   NULL after `visibility_field_id` , 
	CHANGE `reverse_desc` `reverse_desc` text  COLLATE utf8mb4_unicode_520_ci NULL after `value_field_id` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `flagexclusions` 
	CHANGE `type_id` `type_id` mediumint(9) unsigned   NOT NULL first , 
	CHANGE `product_id` `product_id` mediumint(9) unsigned   NULL after `type_id` , 
	CHANGE `component_id` `component_id` mediumint(9) unsigned   NULL after `product_id` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `flaginclusions` 
	CHANGE `type_id` `type_id` mediumint(9) unsigned   NOT NULL first , 
	CHANGE `product_id` `product_id` mediumint(9) unsigned   NULL after `type_id` , 
	CHANGE `component_id` `component_id` mediumint(9) unsigned   NULL after `product_id` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `flags` 
	CHANGE `id` `id` mediumint(9) unsigned   NOT NULL auto_increment first , 
	CHANGE `type_id` `type_id` mediumint(9) unsigned   NOT NULL after `id` , 
	CHANGE `bug_id` `bug_id` mediumint(9) unsigned   NOT NULL after `status` , 
	CHANGE `attach_id` `attach_id` mediumint(9) unsigned   NULL after `bug_id` , 
	CHANGE `creation_date` `creation_date` datetime   NOT NULL after `attach_id` , 
	CHANGE `modification_date` `modification_date` datetime   NULL after `creation_date` , 
	CHANGE `setter_id` `setter_id` mediumint(9) unsigned   NOT NULL after `modification_date` , 
	CHANGE `requestee_id` `requestee_id` mediumint(9) unsigned   NULL after `setter_id` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `flagtypes` 
	CHANGE `id` `id` mediumint(9) unsigned   NOT NULL auto_increment first , 
	CHANGE `description` `description` longtext  COLLATE utf8mb4_unicode_520_ci NOT NULL after `name` , 
	CHANGE `sortkey` `sortkey` smallint(6) unsigned   NOT NULL DEFAULT 0 after `is_multiplicable` , 
	CHANGE `grant_group_id` `grant_group_id` mediumint(9) unsigned   NULL after `sortkey` , 
	CHANGE `request_group_id` `request_group_id` mediumint(9) unsigned   NULL after `grant_group_id` , 
	DROP COLUMN `default_requestee` , 
	DROP KEY `fk_flagtypes_default_requestee_profiles_userid` , 
	DROP FOREIGN KEY `fk_flagtypes_default_requestee_profiles_userid`  , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `group_control_map` 
	CHANGE `group_id` `group_id` mediumint(9) unsigned   NOT NULL first , 
	CHANGE `product_id` `product_id` mediumint(9) unsigned   NOT NULL after `group_id` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `group_group_map` 
	CHANGE `member_id` `member_id` mediumint(9) unsigned   NOT NULL first , 
	CHANGE `grantor_id` `grantor_id` mediumint(9) unsigned   NOT NULL after `member_id` , 
	ADD KEY `group_group_map_grantor_id_grant_type_idx`(`grantor_id`,`grant_type`) , 
	ADD KEY `group_group_map_member_id_grant_type_idx`(`member_id`,`grant_type`) , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `groups` 
	CHANGE `id` `id` mediumint(9) unsigned   NOT NULL auto_increment first , 
	CHANGE `description` `description` longtext  COLLATE utf8mb4_unicode_520_ci NOT NULL after `name` , 
	CHANGE `userregexp` `userregexp` text  COLLATE utf8mb4_unicode_520_ci NOT NULL after `isbuggroup` , 
	CHANGE `icon_url` `icon_url` text  COLLATE utf8mb4_unicode_520_ci NULL after `isactive` , 
	DROP COLUMN `secure_mail` , 
	DROP COLUMN `owner_user_id` , 
	DROP COLUMN `idle_member_removal` , 
	DROP KEY `fk_groups_owner_user_id_profiles_userid` , 
	DROP FOREIGN KEY `fk_groups_owner_user_id_profiles_userid`  , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `keyworddefs` 
	CHANGE `id` `id` smallint(6) unsigned   NOT NULL auto_increment first , 
	CHANGE `description` `description` longtext  COLLATE utf8mb4_unicode_520_ci NOT NULL after `name` , 
	DROP COLUMN `is_active` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `keywords` 
	CHANGE `bug_id` `bug_id` mediumint(9) unsigned   NOT NULL first , 
	CHANGE `keywordid` `keywordid` smallint(6) unsigned   NOT NULL after `bug_id` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `login_failure` 
	CHANGE `user_id` `user_id` mediumint(9) unsigned   NOT NULL first , 
	CHANGE `login_time` `login_time` datetime   NOT NULL after `user_id` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `logincookies` 
	CHANGE `cookie` `cookie` varchar(16)  COLLATE utf8mb4_unicode_520_ci NOT NULL first , 
	CHANGE `userid` `userid` mediumint(9) unsigned   NOT NULL after `cookie` , 
	CHANGE `lastused` `lastused` datetime   NOT NULL after `ipaddr` , 
	DROP COLUMN `id` , 
	DROP COLUMN `restrict_ipaddr` , 
	DROP KEY `logincookies_cookie_idx` , 
	DROP KEY `PRIMARY`, ADD PRIMARY KEY(`cookie`) ;

/* Alter table in target */
ALTER TABLE `longdescs` 
	CHANGE `comment_id` `comment_id` int(11) unsigned   NOT NULL auto_increment first , 
	CHANGE `bug_id` `bug_id` mediumint(9) unsigned   NOT NULL after `comment_id` , 
	CHANGE `who` `who` mediumint(9) unsigned   NOT NULL after `bug_id` , 
	CHANGE `bug_when` `bug_when` datetime   NOT NULL after `who` , 
	CHANGE `thetext` `thetext` longtext  COLLATE utf8mb4_unicode_520_ci NOT NULL after `work_time` , 
	CHANGE `type` `type` smallint(6) unsigned   NOT NULL DEFAULT 0 after `already_wrapped` , 
	DROP COLUMN `is_markdown` , 
	DROP COLUMN `edit_count` , 
	DROP KEY `longdescs_bug_id_idx`, ADD KEY `longdescs_bug_id_idx`(`bug_id`,`work_time`) , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `longdescs_tags` 
	CHANGE `id` `id` mediumint(9) unsigned   NOT NULL auto_increment first , 
	CHANGE `comment_id` `comment_id` int(11) unsigned   NULL after `id` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `longdescs_tags_activity` 
	CHANGE `id` `id` mediumint(9) unsigned   NOT NULL auto_increment first , 
	CHANGE `bug_id` `bug_id` mediumint(9) unsigned   NOT NULL after `id` , 
	CHANGE `comment_id` `comment_id` int(11) unsigned   NULL after `bug_id` , 
	CHANGE `who` `who` mediumint(9) unsigned   NOT NULL after `comment_id` , 
	CHANGE `bug_when` `bug_when` datetime   NOT NULL after `who` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `longdescs_tags_weights` 
	CHANGE `id` `id` mediumint(9) unsigned   NOT NULL auto_increment first , 
	CHANGE `weight` `weight` mediumint(9) unsigned   NOT NULL after `tag` , ROW_FORMAT = Dynamic ;

/* Create table in target */
CREATE TABLE `mail_staging`(
	`id` int(11) unsigned NOT NULL  auto_increment , 
	`message` longblob NOT NULL  , 
	PRIMARY KEY (`id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Create table in target */
CREATE TABLE `manually_created_units`(
	`pilot_user` varchar(255) COLLATE utf8_general_ci NULL  , 
	`pilotId` varchar(255) COLLATE utf8_general_ci NULL  , 
	`bzId` smallint(6) NOT NULL  auto_increment , 
	`bz_name` varchar(64) COLLATE utf8_general_ci NULL  , 
	`createdAt` datetime NULL  , 
	`ownerIds` json NULL  , 
	`ownerIds_dev` json NULL  , 
	`moreInfo` varchar(255) COLLATE utf8_general_ci NULL  , 
	`unitType` varchar(255) COLLATE utf8_general_ci NULL  , 
	`city` varchar(255) COLLATE utf8_general_ci NULL  , 
	`country` varchar(255) COLLATE utf8_general_ci NULL  , 
	`displayName` varchar(255) COLLATE utf8_general_ci NULL  , 
	`state` varchar(255) COLLATE utf8_general_ci NULL  , 
	`streetAddress` varchar(255) COLLATE utf8_general_ci NULL  , 
	`zipCode` varchar(255) COLLATE utf8_general_ci NULL  , 
	`comment` text COLLATE utf8_general_ci NULL  , 
	PRIMARY KEY (`bzId`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8' COLLATE='utf8_general_ci' ROW_FORMAT=Dynamic;


/* Alter table in target */
ALTER TABLE `milestones` 
	CHANGE `id` `id` mediumint(9) unsigned   NOT NULL auto_increment first , 
	CHANGE `product_id` `product_id` mediumint(9) unsigned   NOT NULL after `id` , 
	CHANGE `value` `value` varchar(64)  COLLATE utf8mb4_unicode_520_ci NOT NULL after `product_id` , 
	CHANGE `sortkey` `sortkey` smallint(6) unsigned   NOT NULL DEFAULT 0 after `value` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `namedqueries` 
	CHANGE `id` `id` mediumint(9) unsigned   NOT NULL auto_increment first , 
	CHANGE `userid` `userid` mediumint(9) unsigned   NOT NULL after `id` , 
	CHANGE `query` `query` longtext  COLLATE utf8mb4_unicode_520_ci NOT NULL after `name` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `namedqueries_link_in_footer` 
	CHANGE `namedquery_id` `namedquery_id` mediumint(9) unsigned   NOT NULL first , 
	CHANGE `user_id` `user_id` mediumint(9) unsigned   NOT NULL after `namedquery_id` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `namedquery_group_map` 
	CHANGE `namedquery_id` `namedquery_id` mediumint(9) unsigned   NOT NULL first , 
	CHANGE `group_id` `group_id` mediumint(9) unsigned   NOT NULL after `namedquery_id` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `op_sys` 
	CHANGE `id` `id` smallint(6) unsigned   NOT NULL auto_increment first , 
	CHANGE `sortkey` `sortkey` smallint(6) unsigned   NOT NULL DEFAULT 0 after `value` , 
	CHANGE `visibility_value_id` `visibility_value_id` smallint(6) unsigned   NULL after `isactive` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `priority` 
	CHANGE `id` `id` smallint(6) unsigned   NOT NULL auto_increment first , 
	CHANGE `sortkey` `sortkey` smallint(6) unsigned   NOT NULL DEFAULT 0 after `value` , 
	CHANGE `visibility_value_id` `visibility_value_id` smallint(6) unsigned   NULL after `isactive` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `products` 
	CHANGE `id` `id` mediumint(9) unsigned   NOT NULL auto_increment first , 
	CHANGE `classification_id` `classification_id` mediumint(9) unsigned   NOT NULL DEFAULT 1 after `name` , 
	CHANGE `description` `description` longtext  COLLATE utf8mb4_unicode_520_ci NOT NULL after `classification_id` , 
	CHANGE `defaultmilestone` `defaultmilestone` varchar(64)  COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '---' after `isactive` , 
	DROP COLUMN `nag_interval` , 
	DROP COLUMN `bug_description_template` , 
	DROP COLUMN `default_platform_id` , 
	DROP COLUMN `default_bug_type` , 
	DROP COLUMN `default_op_sys_id` , 
	DROP COLUMN `security_group_id` , 
	DROP COLUMN `reviewer_required` , 
	DROP COLUMN `votesperuser` , 
	DROP COLUMN `maxvotesperbug` , 
	DROP COLUMN `votestoconfirm` , 
	DROP KEY `fk_products_default_op_sys_id_op_sys_id` , 
	DROP KEY `fk_products_default_platform_id_rep_platform_id` , 
	DROP KEY `fk_products_security_group_id_groups_id` , 
	DROP FOREIGN KEY `fk_products_default_op_sys_id_op_sys_id`  , 
	DROP FOREIGN KEY `fk_products_default_platform_id_rep_platform_id`  , 
	DROP FOREIGN KEY `fk_products_security_group_id_groups_id`  , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `profile_search` 
	CHANGE `id` `id` int(11) unsigned   NOT NULL auto_increment first , 
	CHANGE `user_id` `user_id` mediumint(9) unsigned   NOT NULL after `id` , 
	CHANGE `bug_list` `bug_list` longtext  COLLATE utf8mb4_unicode_520_ci NOT NULL after `user_id` , 
	CHANGE `list_order` `list_order` longtext  COLLATE utf8mb4_unicode_520_ci NULL after `bug_list` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `profile_setting` 
	CHANGE `user_id` `user_id` mediumint(9) unsigned   NOT NULL first , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `profiles` 
	CHANGE `userid` `userid` mediumint(9) unsigned   NOT NULL auto_increment first , 
	CHANGE `disabledtext` `disabledtext` longtext  COLLATE utf8mb4_unicode_520_ci NOT NULL after `realname` , 
	CHANGE `last_seen_date` `last_seen_date` datetime   NULL after `is_enabled` , 
	DROP COLUMN `review_request_count` , 
	DROP COLUMN `creation_ts` , 
	DROP COLUMN `nickname` , 
	DROP COLUMN `mfa_required_date` , 
	DROP COLUMN `first_patch_reviewed_id` , 
	DROP COLUMN `password_change_required` , 
	DROP COLUMN `password_change_reason` , 
	DROP COLUMN `mfa` , 
	DROP COLUMN `feedback_request_count` , 
	DROP COLUMN `needinfo_request_count` , 
	DROP COLUMN `public_key` , 
	DROP COLUMN `comment_count` , 
	DROP COLUMN `first_patch_bug_id` , 
	DROP COLUMN `last_activity_ts` , 
	DROP COLUMN `last_statistics_ts` , 
	DROP KEY `profiles_nickname_idx` , 
	DROP KEY `profiles_realname_ft_idx` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `profiles_activity` 
	CHANGE `id` `id` mediumint(9) unsigned   NOT NULL auto_increment first , 
	CHANGE `userid` `userid` mediumint(9) unsigned   NOT NULL after `id` , 
	CHANGE `who` `who` mediumint(9) unsigned   NOT NULL after `userid` , 
	CHANGE `profiles_when` `profiles_when` datetime   NOT NULL after `who` , 
	CHANGE `fieldid` `fieldid` mediumint(9) unsigned   NOT NULL after `profiles_when` , 
	CHANGE `oldvalue` `oldvalue` text  COLLATE utf8mb4_unicode_520_ci NULL after `fieldid` , 
	CHANGE `newvalue` `newvalue` text  COLLATE utf8mb4_unicode_520_ci NULL after `oldvalue` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `quips` 
	CHANGE `quipid` `quipid` mediumint(9) unsigned   NOT NULL auto_increment first , 
	CHANGE `userid` `userid` mediumint(9) unsigned   NULL after `quipid` , 
	CHANGE `quip` `quip` varchar(512)  COLLATE utf8mb4_unicode_520_ci NOT NULL after `userid` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `rep_platform` 
	CHANGE `id` `id` smallint(6) unsigned   NOT NULL auto_increment first , 
	CHANGE `sortkey` `sortkey` smallint(6) unsigned   NOT NULL DEFAULT 0 after `value` , 
	CHANGE `visibility_value_id` `visibility_value_id` smallint(6) unsigned   NULL after `isactive` , ROW_FORMAT = Dynamic ;

/* Create table in target */
CREATE TABLE `reports`(
	`id` mediumint(9) unsigned NOT NULL  auto_increment , 
	`user_id` mediumint(9) unsigned NOT NULL  , 
	`name` varchar(64) COLLATE utf8mb4_unicode_520_ci NOT NULL  , 
	`query` longtext COLLATE utf8mb4_unicode_520_ci NOT NULL  , 
	PRIMARY KEY (`id`) , 
	UNIQUE KEY `reports_user_id_idx`(`user_id`,`name`) , 
	CONSTRAINT `fk_reports_user_id_profiles_userid` 
	FOREIGN KEY (`user_id`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Alter table in target */
ALTER TABLE `resolution` 
	CHANGE `id` `id` smallint(6) unsigned   NOT NULL auto_increment first , 
	CHANGE `sortkey` `sortkey` smallint(6) unsigned   NOT NULL DEFAULT 0 after `value` , 
	CHANGE `visibility_value_id` `visibility_value_id` smallint(6) unsigned   NULL after `isactive` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `series` 
	CHANGE `series_id` `series_id` mediumint(9) unsigned   NOT NULL auto_increment first , 
	CHANGE `creator` `creator` mediumint(9) unsigned   NULL after `series_id` , 
	CHANGE `category` `category` mediumint(9) unsigned   NOT NULL after `creator` , 
	CHANGE `subcategory` `subcategory` mediumint(9) unsigned   NOT NULL after `category` , 
	CHANGE `frequency` `frequency` smallint(6) unsigned   NOT NULL after `name` , 
	CHANGE `query` `query` longtext  COLLATE utf8mb4_unicode_520_ci NOT NULL after `frequency` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `series_categories` 
	CHANGE `id` `id` mediumint(9) unsigned   NOT NULL auto_increment first , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `series_data` 
	CHANGE `series_id` `series_id` mediumint(9) unsigned   NOT NULL first , 
	CHANGE `series_date` `series_date` datetime   NOT NULL after `series_id` , 
	CHANGE `series_value` `series_value` mediumint(9) unsigned   NOT NULL after `series_date` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `setting` 
	DROP COLUMN `category` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `setting_value` 
	CHANGE `sortindex` `sortindex` smallint(6) unsigned   NOT NULL after `value` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `status_workflow` 
	CHANGE `old_status` `old_status` smallint(6) unsigned   NULL first , 
	CHANGE `new_status` `new_status` smallint(6) unsigned   NOT NULL after `old_status` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `tag` 
	CHANGE `id` `id` mediumint(9) unsigned   NOT NULL auto_increment first , 
	CHANGE `user_id` `user_id` mediumint(9) unsigned   NOT NULL after `name` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `tokens` 
	CHANGE `userid` `userid` mediumint(9) unsigned   NULL first , 
	CHANGE `issuedate` `issuedate` datetime   NOT NULL after `userid` , 
	CHANGE `token` `token` varchar(16)  COLLATE utf8mb4_unicode_520_ci NOT NULL after `issuedate` , 
	CHANGE `eventdata` `eventdata` text  COLLATE utf8mb4_unicode_520_ci NULL after `tokentype` ;

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
	CHANGE `user_id` `user_id` mediumint(9) unsigned   NOT NULL after `id` , 
	CHANGE `last_used` `last_used` datetime   NULL after `revoked` , 
	DROP COLUMN `last_used_ip` , 
	DROP COLUMN `app_id` , 
	DROP COLUMN `sticky` , 
	DROP KEY `user_api_keys_user_id_app_id_idx` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `user_group_map` 
	CHANGE `user_id` `user_id` mediumint(9) unsigned   NOT NULL first , 
	CHANGE `group_id` `group_id` mediumint(9) unsigned   NOT NULL after `user_id` , ROW_FORMAT = Dynamic ;

/* Create table in target */
CREATE TABLE `ut_all_units`(
	`id_record` int(11) unsigned NOT NULL  auto_increment , 
	`product_id` mediumint(9) unsigned NOT NULL  COMMENT 'The id in the `products` table' , 
	PRIMARY KEY (`id_record`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Create table in target */
CREATE TABLE `ut_audit_log`(
	`id_ut_log` int(11) unsigned NOT NULL  auto_increment COMMENT 'The id of the record in this table' , 
	`datetime` datetime NULL  COMMENT 'When was this record created' , 
	`bzfe_table` varchar(256) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The name of the table that was altered' , 
	`bzfe_field` varchar(256) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The name of the field that was altered in the bzfe table' , 
	`previous_value` longtext COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The value of the field before the change' , 
	`new_value` longtext COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The value of the field after the change' , 
	`script` longtext COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The script that was used to create the record' , 
	`comment` mediumtext COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'More information about what we intended to do' , 
	PRIMARY KEY (`id_ut_log`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Create table in target */
CREATE TABLE `ut_contractor_types`(
	`id_contractor_type` smallint(6) unsigned NOT NULL  auto_increment COMMENT 'ID in this table' , 
	`created` datetime NULL  COMMENT 'creation ts' , 
	`contractor_type` varchar(255) COLLATE utf8mb4_unicode_520_ci NOT NULL  COMMENT 'A name for this contractor type' , 
	`bz_description` varchar(255) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'A short, generic description that we include each time we create a new BZ unit.' , 
	`description` mediumtext COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'Detailed description of this contractor type' , 
	PRIMARY KEY (`id_contractor_type`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Create table in target */
CREATE TABLE `ut_contractors`(
	`id_contractor` int(11) unsigned NOT NULL  auto_increment COMMENT 'ID in this table' , 
	`created` datetime NULL  COMMENT 'creation ts' , 
	`contractor_name` varchar(255) COLLATE utf8mb4_unicode_520_ci NOT NULL  COMMENT 'A name for this contractor' , 
	`contractor_description` varchar(255) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'A short, generic description that we include each time we create a new BZ contractor.' , 
	`contractor_details` mediumtext COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'Detailed description of this contractor - This can be built from a SQL Less table and/or the MEFE' , 
	PRIMARY KEY (`id_contractor`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Create table in target */
CREATE TABLE `ut_data_to_add_user_to_a_case`(
	`id` int(11) unsigned NOT NULL  auto_increment COMMENT 'The unique ID in this table' , 
	`mefe_invitation_id` varchar(256) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The unique Id for the invitation that was generated in MEFE to do the data import' , 
	`mefe_invitation_id_int_value` int(11) NULL  COMMENT 'The INT value for the invitation ID. We use this everywhere in the SELECT invocations.' , 
	`mefe_invitor_user_id` varchar(256) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The id of the creator of this unit in the MEFE database' , 
	`bzfe_invitor_user_id` mediumint(9) unsigned NOT NULL  COMMENT 'The BZFE user id who creates this unit. this is a FK to the BZ table \'profiles\'' , 
	`bz_user_id` mediumint(9) unsigned NOT NULL  COMMENT 'The userid for the user that will be rfeplcing the dummy user for this role for this unit. This is a FK to the BZ table \'profiles\'' , 
	`bz_case_id` mediumint(9) unsigned NOT NULL  COMMENT 'The case id that the user is invited to - This is a FK to the BZ table \'bugs\'' , 
	`bz_created_date` datetime NULL  COMMENT 'Date and time when this unit has been created in the BZ databae' , 
	`comment` mediumtext COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'Any comment' , 
	PRIMARY KEY (`id`) , 
	KEY `add_user_to_a_case_invitor_bz_id`(`bzfe_invitor_user_id`) , 
	KEY `add_user_to_a_case_invitee_bz_id`(`bz_user_id`) , 
	KEY `add_user_to_a_case_case_id`(`bz_case_id`) , 
	CONSTRAINT `add_user_to_a_case_case_id` 
	FOREIGN KEY (`bz_case_id`) REFERENCES `bugs` (`bug_id`) ON DELETE NO ACTION ON UPDATE CASCADE , 
	CONSTRAINT `add_user_to_a_case_invitee_bz_id` 
	FOREIGN KEY (`bz_user_id`) REFERENCES `profiles` (`userid`) ON DELETE NO ACTION ON UPDATE CASCADE , 
	CONSTRAINT `add_user_to_a_case_invitor_bz_id` 
	FOREIGN KEY (`bzfe_invitor_user_id`) REFERENCES `profiles` (`userid`) ON DELETE NO ACTION ON UPDATE CASCADE 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Create table in target */
CREATE TABLE `ut_data_to_add_user_to_a_role`(
	`id` int(11) unsigned NOT NULL  auto_increment COMMENT 'The unique ID in this table' , 
	`mefe_invitation_id` varchar(256) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The unique Id for the invitation that was generated in MEFE to do the data import' , 
	`mefe_invitation_id_int_value` int(11) NULL  COMMENT 'The INT value for the invitation ID. We use this everywhere in the SELECT invocations.' , 
	`mefe_invitor_user_id` varchar(256) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The id of the creator of this unit in the MEFE database' , 
	`bzfe_invitor_user_id` mediumint(9) unsigned NOT NULL  COMMENT 'The BZFE user id who creates this unit. this is a FK to the BZ table \'profiles\'' , 
	`bz_unit_id` mediumint(9) unsigned NOT NULL  COMMENT 'The product id in the BZ table \'products\'' , 
	`bz_user_id` mediumint(9) unsigned NOT NULL  COMMENT 'The userid for the user that will be rfeplcing the dummy user for this role for this unit. This is a FK to the BZ table \'profiles\'' , 
	`user_role_type_id` smallint(6) unsigned NOT NULL  COMMENT 'The id of the role type for the invited user. This is a FK to the table \'ut_role_types\'' , 
	`is_occupant` tinyint(1) NULL  DEFAULT 0 COMMENT '1 if TRUE, 0 if FALSE' , 
	`user_more` varchar(500) COLLATE utf8mb4_unicode_520_ci NULL  DEFAULT '' COMMENT 'A text to give more information about the user. This will be used in the BZ Component Description' , 
	`bz_created_date` datetime NULL  COMMENT 'Date and time when this unit has been created in the BZ databae' , 
	`comment` mediumtext COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'Any comment' , 
	PRIMARY KEY (`id`) , 
	KEY `add_user_to_a_role_bz_user_id`(`bz_user_id`) , 
	KEY `add_user_to_a_role_invitor_bz_id`(`bzfe_invitor_user_id`) , 
	KEY `add_user_to_a_role_role_type_id`(`user_role_type_id`) , 
	KEY `add_user_to_a_role_product_id`(`bz_unit_id`) , 
	CONSTRAINT `add_user_to_a_role_bz_user_id` 
	FOREIGN KEY (`bz_user_id`) REFERENCES `profiles` (`userid`) ON DELETE NO ACTION ON UPDATE CASCADE , 
	CONSTRAINT `add_user_to_a_role_invitor_bz_id` 
	FOREIGN KEY (`bzfe_invitor_user_id`) REFERENCES `profiles` (`userid`) ON DELETE NO ACTION ON UPDATE CASCADE , 
	CONSTRAINT `add_user_to_a_role_product_id` 
	FOREIGN KEY (`bz_unit_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE , 
	CONSTRAINT `add_user_to_a_role_role_type_id` 
	FOREIGN KEY (`user_role_type_id`) REFERENCES `ut_role_types` (`id_role_type`) ON DELETE NO ACTION ON UPDATE CASCADE 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Create table in target */
CREATE TABLE `ut_data_to_create_units`(
	`id_unit_to_create` int(11) unsigned NOT NULL  auto_increment COMMENT 'The unique ID in this table' , 
	`mefe_unit_id` varchar(256) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The id of this unit in the MEFE database' , 
	`mefe_unit_id_int_value` int(11) unsigned NULL  COMMENT 'The INT value for the mefe unit ID. We use this everfywhere in the SELECT invocations.' , 
	`mefe_creator_user_id` varchar(256) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The id of the creator of this unit in the MEFE database' , 
	`bzfe_creator_user_id` mediumint(9) unsigned NOT NULL  COMMENT 'The BZFE user id who creates this unit. this is a FK to the BZ table \'profiles\'' , 
	`classification_id` mediumint(9) unsigned NOT NULL  COMMENT 'The ID of the classification for this unit - a FK to the BZ table \'classifications\'' , 
	`unit_name` varchar(54) COLLATE utf8mb4_unicode_520_ci NOT NULL  DEFAULT '' COMMENT 'A name for the unit. We will append the product id and this will be inserted in the product name field of the BZ tabele product which has a max lenght of 64' , 
	`unit_description_details` varchar(500) COLLATE utf8mb4_unicode_520_ci NULL  DEFAULT '' COMMENT 'More information about the unit - this is a free text space' , 
	`bz_created_date` datetime NULL  COMMENT 'Date and time when this unit has been created in the BZ databae' , 
	`comment` mediumtext COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'Any comment' , 
	`product_id` mediumint(9) unsigned NULL  COMMENT 'The id of the product in the BZ table \'products\'. Because this is a record that we will keep even AFTER we deleted the record in the BZ table, this can NOT be a FK.' , 
	`deleted_datetime` datetime NULL  COMMENT 'Timestamp when this was deleted in the BZ db (together with all objects related to this product/unit).' , 
	`deletion_script` varchar(500) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The script used to delete this product and all objects related to this product in the BZ database' , 
	PRIMARY KEY (`id_unit_to_create`) , 
	UNIQUE KEY `unit_mefe_unit_id_must_be_unique`(`mefe_unit_id`) , 
	KEY `new_unit_classification_id_must_exist`(`classification_id`) , 
	KEY `new_unit_unit_creator_bz_id_must_exist`(`bzfe_creator_user_id`) , 
	KEY `unique_mefe_unit_id_int_value`(`mefe_unit_id_int_value`) , 
	CONSTRAINT `new_unit_classification_id_must_exist` 
	FOREIGN KEY (`classification_id`) REFERENCES `classifications` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE , 
	CONSTRAINT `new_unit_unit_creator_bz_id_must_exist` 
	FOREIGN KEY (`bzfe_creator_user_id`) REFERENCES `profiles` (`userid`) ON DELETE NO ACTION ON UPDATE CASCADE 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Create table in target */
CREATE TABLE `ut_data_to_create_units_legacy_before_3_3`(
	`id_unit_to_create` int(11) NOT NULL  auto_increment COMMENT 'The unique ID in this table' , 
	`mefe_id` varchar(256) COLLATE utf8_general_ci NULL  COMMENT 'The id of the object in the MEFE interface where these information are coming from' , 
	`mefe_creator_user_id` varchar(256) COLLATE utf8_general_ci NULL  COMMENT 'The id of the creator of this unit in the MEFE database' , 
	`mefe_unit_id` varchar(256) COLLATE utf8_general_ci NULL  COMMENT 'The id of this unit in the MEFE database' , 
	`bzfe_creator_user_id` mediumint(9) NOT NULL  COMMENT 'The BZFE user id who creates this unit. this is a FK to the BZ table \'profiles\'' , 
	`classification_id` smallint(6) NOT NULL  COMMENT 'The ID of the classification for this unit - a FK to the BZ table \'classifications\'' , 
	`unit_name` varchar(54) COLLATE utf8_general_ci NOT NULL  DEFAULT '' COMMENT 'A name for the unit. We will append the product id and this will be inserted in the product name field of the BZ tabele product which has a max lenght of 64' , 
	`unit_id` varchar(54) COLLATE utf8_general_ci NULL  DEFAULT '' COMMENT 'The id of the unit' , 
	`unit_condo` varchar(50) COLLATE utf8_general_ci NULL  DEFAULT '' COMMENT 'The name of the condo or buildig for the unit' , 
	`unit_surface` varchar(10) COLLATE utf8_general_ci NULL  DEFAULT '' COMMENT 'The surface of the unit - this is a number - it can be sqm or sqf' , 
	`unit_surface_measure` tinyint(1) NULL  COMMENT '1 is for square feet (sqf) - 2 is for square meters (sqm)' , 
	`unit_description_details` varchar(500) COLLATE utf8_general_ci NULL  DEFAULT '' COMMENT 'More information about the unit - this is a free text space' , 
	`unit_address` varchar(500) COLLATE utf8_general_ci NULL  DEFAULT '' COMMENT 'The address of the unit' , 
	`matterport_url` varchar(256) COLLATE utf8_general_ci NULL  DEFAULT '' COMMENT 'LMB specific - a the URL for the matterport visit for this unit' , 
	`bz_created_date` datetime NULL  COMMENT 'Date and time when this unit has been created in the BZ databae' , 
	`comment` text COLLATE utf8_general_ci NULL  COMMENT 'Any comment' , 
	`product_id` smallint(6) NULL  COMMENT 'The id of the product in the BZ table \'products\'. Because this is a record that we will keep even AFTER we deleted the record in the BZ table, this can NOT be a FK.' , 
	`deleted_datetime` datetime NULL  COMMENT 'Timestamp when this was deleted in the BZ db (together with all objects related to this product/unit).' , 
	`deletion_script` varchar(500) COLLATE utf8_general_ci NULL  COMMENT 'The script used to delete this product and all objects related to this product in the BZ database' , 
	PRIMARY KEY (`id_unit_to_create`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8' COLLATE='utf8_general_ci' ROW_FORMAT=Dynamic;


/* Create table in target */
CREATE TABLE `ut_data_to_replace_dummy_roles`(
	`id` int(11) unsigned NOT NULL  auto_increment COMMENT 'The unique ID in this table' , 
	`mefe_invitation_id` varchar(256) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The unique Id for the invitation that was generated in MEFE to do the data import' , 
	`mefe_invitation_id_int_value` int(11) unsigned NULL  COMMENT 'The INT value for the invitation ID. We use this everywhere in the SELECT invocations.' , 
	`mefe_invitor_user_id` varchar(256) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The id of the creator of this unit in the MEFE database' , 
	`bzfe_invitor_user_id` mediumint(9) unsigned NOT NULL  COMMENT 'The BZFE user id who creates this unit. this is a FK to the BZ table \'profiles\'' , 
	`bz_unit_id` mediumint(9) unsigned NOT NULL  COMMENT 'The product id in the BZ table \'products\'' , 
	`bz_user_id` mediumint(9) unsigned NOT NULL  COMMENT 'The userid for the user that will be rfeplcing the dummy user for this role for this unit. This is a FK to the BZ table \'profiles\'' , 
	`user_role_type_id` smallint(6) unsigned NOT NULL  COMMENT 'The id of the role type for the invited user. This is a FK to the table \'ut_role_types\'' , 
	`is_occupant` tinyint(1) NULL  DEFAULT 0 COMMENT '1 if TRUE, 0 if FALSE' , 
	`is_mefe_user_only` tinyint(1) NULL  DEFAULT 1 COMMENT '1 (default value) if TRUE - If a user is a MEFE user only we disable the claim mail in the BZFE' , 
	`user_more` varchar(500) COLLATE utf8mb4_unicode_520_ci NULL  DEFAULT '' COMMENT 'A text to give more information about the user. This will be used in the BZ Component Description' , 
	`bz_created_date` datetime NULL  COMMENT 'Date and time when this unit has been created in the BZ databae' , 
	`comment` mediumtext COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'Any comment' , 
	PRIMARY KEY (`id`) , 
	KEY `replace_dummy_role_role_type`(`user_role_type_id`) , 
	KEY `replace_dummy_role_bz_user_id`(`bz_user_id`) , 
	KEY `replace_dummy_role_invitor_bz_user_id`(`bzfe_invitor_user_id`) , 
	KEY `replace_dummy_product_id`(`bz_unit_id`) , 
	KEY `mefe_invitation_id_int_value_must_be_unique`(`mefe_invitation_id_int_value`) , 
	CONSTRAINT `replace_dummy_product_id` 
	FOREIGN KEY (`bz_unit_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE , 
	CONSTRAINT `replace_dummy_role_bz_user_id` 
	FOREIGN KEY (`bz_user_id`) REFERENCES `profiles` (`userid`) ON DELETE NO ACTION ON UPDATE CASCADE , 
	CONSTRAINT `replace_dummy_role_invitor_bz_user_id` 
	FOREIGN KEY (`bzfe_invitor_user_id`) REFERENCES `profiles` (`userid`) ON DELETE NO ACTION ON UPDATE CASCADE , 
	CONSTRAINT `replace_dummy_role_role_type` 
	FOREIGN KEY (`user_role_type_id`) REFERENCES `ut_role_types` (`id_role_type`) ON DELETE NO ACTION ON UPDATE CASCADE 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Create table in target */
CREATE TABLE `ut_db_schema_version`(
	`id` int(11) unsigned NOT NULL  auto_increment COMMENT 'Unique ID in this table' , 
	`schema_version` varchar(256) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The current version of the BZ DB schema for Unee-T' , 
	`update_datetime` datetime NULL  COMMENT 'Timestamp - when this version was implemented in THIS environment' , 
	`update_script` varchar(256) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The script which was used to do the db ugrade' , 
	`comment` mediumtext COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'Comment' , 
	PRIMARY KEY (`id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Create table in target */
CREATE TABLE `ut_flash_units_with_dummy_users`(
	`id` int(11) NOT NULL  auto_increment COMMENT 'id in this table' , 
	`created_datetime` datetime NULL  COMMENT 'The timestamp when this record was created' , 
	`updated_datetime` datetime NULL  COMMENT 'The timestamp when this record was updated. It is equal to the created_datetime if the record has never been updated' , 
	`unit_id` smallint(6) NULL  COMMENT 'The BZ Product_id for the unit with a dummy role a FK to the table \'products\'' , 
	`role_id` mediumint(9) NULL  COMMENT 'The BZ component_id - a FK to the table `components`' , 
	`role_type_id` smallint(6) NULL  COMMENT 'The Ut role type id - a FK to the table \'ut_role_types\'' , 
	PRIMARY KEY (`id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Create table in target */
CREATE TABLE `ut_group_types`(
	`id_group_type` mediumint(9) unsigned NOT NULL  auto_increment COMMENT 'ID in this table' , 
	`created` datetime NULL  COMMENT 'creation ts' , 
	`order` smallint(6) unsigned NULL  COMMENT 'Order in the list' , 
	`is_obsolete` tinyint(1) NOT NULL  DEFAULT 0 COMMENT 'This is an obsolete record' , 
	`groupe_type` varchar(255) COLLATE utf8mb4_unicode_520_ci NOT NULL  COMMENT 'A name for this group type' , 
	`bz_description` varchar(255) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'A short description for BZ which we use when we create the group' , 
	`description` mediumtext COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'Detailed description of this group type' , 
	PRIMARY KEY (`id_group_type`,`groupe_type`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Create table in target */
CREATE TABLE `ut_invitation_api_data`(
	`id` int(11) unsigned NOT NULL  auto_increment COMMENT 'The unique ID in this table' , 
	`mefe_invitation_id` varchar(256) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The unique Id for the invitation that was generated in MEFE to do the data import' , 
	`mefe_invitation_id_int_value` int(11) unsigned NULL  COMMENT 'The INT value for the invitation ID. We use this everywhere in the SELECT invocations.' , 
	`bzfe_invitor_user_id` mediumint(9) unsigned NOT NULL  COMMENT 'The BZFE user id who creates this unit. this is a FK to the BZ table \'profiles\'' , 
	`bz_user_id` mediumint(9) unsigned NOT NULL  COMMENT 'The userid for the user that will be rfeplcing the dummy user for this role for this unit. This is a FK to the BZ table \'profiles\'' , 
	`user_role_type_id` smallint(6) unsigned NOT NULL  COMMENT 'The id of the role type for the invited user. This is a FK to the table \'ut_role_types\'' , 
	`is_occupant` tinyint(1) NULL  DEFAULT 0 COMMENT '1 if TRUE, 0 if FALSE' , 
	`bz_case_id` mediumint(9) unsigned NULL  COMMENT 'The id of the bug in th table \'bugs\'' , 
	`bz_unit_id` mediumint(9) unsigned NOT NULL  COMMENT 'The product id in the BZ table \'products\'' , 
	`invitation_type` varchar(255) COLLATE utf8mb4_unicode_520_ci NOT NULL  COMMENT 'The type of the invitation (assigned or CC)' , 
	`is_mefe_only_user` tinyint(1) NULL  DEFAULT 1 COMMENT '1 if the user is a MEFE only user. In this scenario, we will DISABLE the claim mail in the BZFE for that user' , 
	`user_more` varchar(500) COLLATE utf8mb4_unicode_520_ci NULL  DEFAULT '' COMMENT 'A text to give more information about the user. This will be used in the BZ Component Description' , 
	`mefe_invitor_user_id` varchar(256) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The id of the creator of this unit in the MEFE database' , 
	`processed_datetime` datetime NULL  COMMENT 'The Timestamp when this invitation has been processed in the BZ database' , 
	`script` varchar(256) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The SQL script or procedure that was used to process this record' , 
	`api_post_datetime` datetime NULL  COMMENT 'Date and time when this invitation has been posted as porcessed via the Unee-T inviation API' , 
	PRIMARY KEY (`id`) , 
	UNIQUE KEY `mefe_invitation_id_must_be_unique`(`mefe_invitation_id`) , 
	KEY `invitation_bz_bug_must_exist`(`bz_case_id`) , 
	KEY `invitation_bz_invitee_must_exist`(`bz_user_id`) , 
	KEY `invitation_bz_invitor_must_exist`(`bzfe_invitor_user_id`) , 
	KEY `invitation_bz_product_must_exist`(`bz_unit_id`) , 
	KEY `invitation_invitation_type_must_exist`(`invitation_type`) , 
	KEY `mefe_invitation_id_int_value`(`mefe_invitation_id_int_value`) , 
	CONSTRAINT `invitation_bz_invitee_must_exist` 
	FOREIGN KEY (`bz_user_id`) REFERENCES `profiles` (`userid`) , 
	CONSTRAINT `invitation_bz_invitor_must_exist` 
	FOREIGN KEY (`bzfe_invitor_user_id`) REFERENCES `profiles` (`userid`) , 
	CONSTRAINT `invitation_bz_product_must_exist` 
	FOREIGN KEY (`bz_unit_id`) REFERENCES `products` (`id`) , 
	CONSTRAINT `invitation_invitation_type_must_exist` 
	FOREIGN KEY (`invitation_type`) REFERENCES `ut_invitation_types` (`invitation_type`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Create table in target */
CREATE TABLE `ut_invitation_types`(
	`id_invitation_type` smallint(6) unsigned NOT NULL  auto_increment COMMENT 'ID in this table' , 
	`created` datetime NULL  COMMENT 'creation ts' , 
	`order` smallint(6) unsigned NULL  COMMENT 'Order in the list' , 
	`is_active` tinyint(1) NULL  DEFAULT 0 COMMENT '1 if this is an active invitation: we have the scripts to process these' , 
	`invitation_type` varchar(255) COLLATE utf8mb4_unicode_520_ci NOT NULL  COMMENT 'A name for this invitation type' , 
	`detailed_description` mediumtext COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'Detailed description of this group type' , 
	PRIMARY KEY (`id_invitation_type`,`invitation_type`) , 
	UNIQUE KEY `invitation_type_is_unique`(`invitation_type`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Create table in target */
CREATE TABLE `ut_local_dev_lambda_calls`(
	`notification_type` varchar(255) COLLATE utf8_general_ci NOT NULL  , 
	`json_payload` text COLLATE utf8_general_ci NULL  , 
	KEY `notification_type_must_exist`(`notification_type`) , 
	CONSTRAINT `notification_type_must_exist` 
	FOREIGN KEY (`notification_type`) REFERENCES `ut_notification_types` (`notification_type`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8' COLLATE='utf8_general_ci' ROW_FORMAT=Dynamic;


/* Create table in target */
CREATE TABLE `ut_log_count_closed_cases`(
	`id_log_closed_case` int(11) unsigned NOT NULL  auto_increment COMMENT 'Unique id in this table' , 
	`timestamp` datetime NULL  COMMENT 'The timestamp when this record was created' , 
	`count_closed_cases` int(11) unsigned NOT NULL  COMMENT 'The number of closed case at this Datetime' , 
	`count_total_cases` int(11) unsigned NULL  COMMENT 'The total number of cases in Unee-T at this time' , 
	PRIMARY KEY (`id_log_closed_case`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Create table in target */
CREATE TABLE `ut_log_count_enabled_units`(
	`id_log_enabled_units` int(11) unsigned NOT NULL  auto_increment COMMENT 'Unique id in this table' , 
	`timestamp` datetime NULL  COMMENT 'The timestamp when this record was created' , 
	`count_enabled_units` int(11) unsigned NOT NULL  COMMENT 'The number of enabled products/units at this Datetime' , 
	`count_total_units` int(11) unsigned NOT NULL  COMMENT 'The total number of products/units at this Datetime' , 
	PRIMARY KEY (`id_log_enabled_units`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Create table in target */
CREATE TABLE `ut_map_contractor_to_type`(
	`contractor_id` int(11) unsigned NOT NULL  COMMENT 'id in the table `ut_contractors`' , 
	`contractor_type_id` mediumint(9) unsigned NOT NULL  COMMENT 'id in the table `ut_contractor_types`' , 
	`created` datetime NULL  COMMENT 'creation ts' 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Create table in target */
CREATE TABLE `ut_map_contractor_to_user`(
	`contractor_id` int(11) unsigned NOT NULL  COMMENT 'id in the table `ut_contractors`' , 
	`bz_user_id` mediumint(9) unsigned NOT NULL  COMMENT 'id in the table `profiles`' , 
	`created` datetime NULL  COMMENT 'creation ts' 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Create table in target */
CREATE TABLE `ut_map_invitation_type_to_permission_type`(
	`invitation_type_id` smallint(6) unsigned NOT NULL  COMMENT 'id of the invitation type in the table `ut_invitation_types`' , 
	`permission_type_id` smallint(6) unsigned NOT NULL  COMMENT 'id of the permission type in the table `ut_permission_types`' , 
	`created` datetime NULL  COMMENT 'creation ts' , 
	`record_created_by` mediumint(9) unsigned NULL  COMMENT 'id of the user who created this user in the bz `profiles` table' , 
	`is_obsolete` tinyint(1) NOT NULL  DEFAULT 0 COMMENT 'This is an obsolete record' , 
	`comment` mediumtext COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'Any comment' , 
	PRIMARY KEY (`invitation_type_id`,`permission_type_id`) , 
	KEY `map_invitation_to_permission_permission_type_id`(`permission_type_id`) , 
	CONSTRAINT `map_invitation_to_permission_invitation_type_id` 
	FOREIGN KEY (`invitation_type_id`) REFERENCES `ut_invitation_types` (`id_invitation_type`) , 
	CONSTRAINT `map_invitation_to_permission_permission_type_id` 
	FOREIGN KEY (`permission_type_id`) REFERENCES `ut_permission_types` (`id_permission_type`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Create table in target */
CREATE TABLE `ut_map_user_mefe_bzfe`(
	`created` datetime NULL  COMMENT 'creation ts' , 
	`record_created_by` mediumint(9) unsigned NULL  COMMENT 'id of the user who created this user in the bz `profiles` table' , 
	`is_obsolete` tinyint(1) NOT NULL  DEFAULT 0 COMMENT 'This is an obsolete record' , 
	`bzfe_update_needed` tinyint(1) NULL  DEFAULT 0 COMMENT 'Do we need to update this record in the BZFE - This is to keep track of the user that have been modified in the MEFE but NOT yet in the BZFE' , 
	`mefe_user_id` varchar(256) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'id of the user in the MEFE' , 
	`bz_profile_id` mediumint(6) NULL  COMMENT 'id of the user in the BZFE' , 
	`comment` mediumtext COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'Any comment' 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Create table in target */
CREATE TABLE `ut_map_user_unit_details`(
	`created` datetime NULL  COMMENT 'creation ts' , 
	`record_created_by` mediumint(9) unsigned NULL  COMMENT 'id of the user who created this user in the bz `profiles` table' , 
	`is_obsolete` tinyint(1) NOT NULL  DEFAULT 0 COMMENT 'This is an obsolete record' , 
	`user_id` int(11) unsigned NULL  COMMENT 'id of the user in the MEFE' , 
	`bz_profile_id` mediumint(6) NULL  COMMENT 'id of the user in the BZFE' , 
	`bz_unit_id` mediumint(9) unsigned NULL  COMMENT 'The id of the unit in the BZFE' , 
	`role_type_id` smallint(6) unsigned NULL  COMMENT 'An id in the table ut_role_types: the role of the user for this unit' , 
	`can_see_time_tracking` tinyint(1) NOT NULL  DEFAULT 1 COMMENT '1 (TRUE) if the user can see the timetracking information for a case' , 
	`can_create_shared_queries` tinyint(1) NOT NULL  DEFAULT 1 COMMENT '1 (TRUE) if the user can create shared queries' , 
	`can_tag_comment` tinyint(1) NOT NULL  DEFAULT 1 COMMENT '1 (TRUE) if the user can tag comments' , 
	`is_occupant` tinyint(1) NOT NULL  DEFAULT 0 COMMENT '1 (TRUE) if the user is an occupnt for this unit' , 
	`is_public_assignee` tinyint(1) NOT NULL  DEFAULT 1 COMMENT '1 (TRUE) if the user is one of the public assignee for this unit' , 
	`is_see_visible_assignee` tinyint(1) NOT NULL  DEFAULT 1 COMMENT '1 (TRUE) if the user can see the public assignee for this unit' , 
	`is_in_cc_for_role` tinyint(1) NOT NULL  DEFAULT 0 COMMENT '1 (TRUE if the user should be included in CC each time a new case is created for his/her role for this unit' , 
	`can_create_case` tinyint(1) NOT NULL  DEFAULT 1 COMMENT '1 (TRUE if the user can create new cases for this unit' , 
	`can_edit_case` tinyint(1) NOT NULL  DEFAULT 1 COMMENT '1 (TRUE) if the user can edit a case for this unit' , 
	`can_see_case` tinyint(1) NOT NULL  DEFAULT 1 COMMENT '1 (TRUE) if the user can the all the public cases for this unit' , 
	`can_edit_all_field_regardless_of_role` tinyint(1) NOT NULL  DEFAULT 0 COMMENT '1 (TRUE) if the user can edit all the fields in a case he/she has access to regardless of his or her role' , 
	`is_flag_requestee` tinyint(1) NOT NULL  DEFAULT 1 COMMENT '1 (TRUE) if the user can be asked to approve all flags' , 
	`is_flag_approver` tinyint(1) NOT NULL  DEFAULT 1 COMMENT '1 (TRUE) if the user can approve all flags' , 
	`can_create_any_sh` tinyint(1) NOT NULL  DEFAULT 1 COMMENT '1 (TRUE) if the user can create any type of stakeholder' , 
	`can_create_same_sh` tinyint(1) NOT NULL  DEFAULT 1 COMMENT '1 (TRUE) if the user can add user as similar stakeholder for that unit' , 
	`can_approve_user_for_flags` tinyint(1) NOT NULL  DEFAULT 1 COMMENT '1 (TRUE) if the user can decide if a user can be requested to approve all flags' , 
	`can_decide_if_user_visible` tinyint(1) NOT NULL  DEFAULT 1 COMMENT '1 (TRUE) if the user can decide if another user is visible' , 
	`can_decide_if_user_can_see_visible` tinyint(1) NOT NULL  DEFAULT 1 COMMENT '1 (TRUE) if the user can decide if another user can see the visible users' , 
	`public_name` varchar(255) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The user Public name' , 
	`more_info` mediumtext COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'More information about this user. We display this in the component/stakeholder description for the unit' , 
	`comment` mediumtext COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'Any comment' , 
	UNIQUE KEY `bz_profile_id_bz_product_id`(`bz_profile_id`,`bz_unit_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Create table in target */
CREATE TABLE `ut_notification_case_assignee`(
	`notification_id` int(11) unsigned NOT NULL  auto_increment COMMENT 'Id in this table' , 
	`created_datetime` datetime NULL  COMMENT 'Timestamp when this was created' , 
	`processed_datetime` datetime NULL  COMMENT 'Timestamp when this notification was processed' , 
	`unit_id` mediumint(9) unsigned NULL  COMMENT 'Unit ID - a FK to the BZ table \'products\'' , 
	`case_id` mediumint(9) unsigned NULL  COMMENT 'Case ID - a FK to the BZ table \'bugs\'' , 
	`case_title` varchar(255) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The title for the case - the is the field `short_desc` in the `bugs` table' , 
	`invitor_user_id` mediumint(9) unsigned NULL  COMMENT 'User ID - The user who inititated the change - a FK to the BZ table \'profiles\'' , 
	`case_reporter_user_id` mediumint(9) unsigned NULL  COMMENT 'User ID - BZ user id of the reporter for the case' , 
	`old_case_assignee_user_id` mediumint(9) unsigned NULL  COMMENT 'User ID - BZ user id of the assignee for the case before the change' , 
	`new_case_assignee_user_id` mediumint(9) unsigned NULL  COMMENT 'User ID - BZ user id of the assignee for the case after the change' , 
	`current_list_of_invitees` longtext COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'comma separated list of user IDs - BZ user ids of the user in cc for this case/bug AFTER the change' , 
	`current_status` varchar(64) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The current status of the case/bug' , 
	`current_resolution` varchar(64) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The current resolution of the case/bug' , 
	`current_severity` varchar(64) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The current severity of the case/bug' , 
	PRIMARY KEY (`notification_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Create table in target */
CREATE TABLE `ut_notification_case_invited`(
	`notification_id` int(11) unsigned NOT NULL  auto_increment COMMENT 'Id in this table' , 
	`created_datetime` datetime NULL  COMMENT 'Timestamp when this was created' , 
	`processed_datetime` datetime NULL  COMMENT 'Timestamp when this notification was processed' , 
	`unit_id` mediumint(9) unsigned NULL  COMMENT 'Unit ID - a FK to the BZ table \'products\'' , 
	`case_id` mediumint(9) unsigned NULL  COMMENT 'Case ID - a FK to the BZ table \'bugs\'' , 
	`case_title` varchar(255) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The title for the case - the is the field `short_desc` in the `bugs` table' , 
	`invitor_user_id` mediumint(9) unsigned NULL  COMMENT 'User ID - The user who inititated the change - a FK to the BZ table \'profiles\'' , 
	`invitee_user_id` mediumint(9) unsigned NULL  COMMENT 'User ID - The user who has been invited to the case a FK to the BZ table \'profiles\'' , 
	`case_reporter_user_id` mediumint(9) unsigned NULL  COMMENT 'User ID - BZ user id of the reporter for the case' , 
	`old_case_assignee_user_id` mediumint(9) unsigned NULL  COMMENT 'User ID - BZ user id of the assignee for the case before the change' , 
	`new_case_assignee_user_id` mediumint(9) unsigned NULL  COMMENT 'User ID - BZ user id of the assignee for the case after the change' , 
	`current_list_of_invitees` longtext COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'comma separated list of user IDs - BZ user ids of the user in cc for this case/bug AFTER the change' , 
	`current_status` varchar(64) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The current status of the case/bug' , 
	`current_resolution` varchar(64) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The current resolution of the case/bug' , 
	`current_severity` varchar(64) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The current severity of the case/bug' , 
	PRIMARY KEY (`notification_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Create table in target */
CREATE TABLE `ut_notification_case_new`(
	`notification_id` int(11) unsigned NOT NULL  auto_increment COMMENT 'Id in this table' , 
	`created_datetime` datetime NULL  COMMENT 'Timestamp when this was created' , 
	`processed_datetime` datetime NULL  COMMENT 'Timestamp when this notification was processed' , 
	`unit_id` mediumint(9) unsigned NULL  COMMENT 'Unit ID - a FK to the BZ table \'products\'' , 
	`case_id` mediumint(9) unsigned NULL  COMMENT 'Case ID - a FK to the BZ table \'bugs\'' , 
	`case_title` varchar(255) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The title for the case - the is the field `short_desc` in the `bugs` table' , 
	`reporter_user_id` mediumint(9) unsigned NULL  COMMENT 'The BZ profile Id of the reporter for the case' , 
	`assignee_user_id` mediumint(9) unsigned NULL  COMMENT 'The BZ profile ID of the Assignee to the case' , 
	`current_status` varchar(64) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The current status of the case/bug' , 
	`current_resolution` varchar(64) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The current resolution of the case/bug' , 
	`current_severity` varchar(64) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The current severity of the case/bug' , 
	PRIMARY KEY (`notification_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Create table in target */
CREATE TABLE `ut_notification_case_updated`(
	`notification_id` int(11) unsigned NOT NULL  auto_increment COMMENT 'Id in this table' , 
	`created_datetime` datetime NULL  COMMENT 'Timestamp when this was created' , 
	`processed_datetime` datetime NULL  COMMENT 'Timestamp when this notification was processed' , 
	`unit_id` mediumint(9) unsigned NULL  COMMENT 'Unit ID - a FK to the BZ table \'products\'' , 
	`case_id` mediumint(9) unsigned NULL  COMMENT 'Case ID - a FK to the BZ table \'bugs\'' , 
	`case_title` varchar(255) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The title for the case - the is the field `short_desc` in the `bugs` table' , 
	`user_id` mediumint(9) unsigned NULL  COMMENT 'User ID - The user who inititated the change - a FK to the BZ table \'profiles\'' , 
	`update_what` varchar(255) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The field that was updated' , 
	`old_value` varchar(255) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The value before it was updated' , 
	`new_value` varchar(255) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The value after it was updated' , 
	`case_reporter_user_id` mediumint(9) unsigned NULL  COMMENT 'User ID - BZ user id of the reporter for the case' , 
	`old_case_assignee_user_id` mediumint(9) unsigned NULL  COMMENT 'User ID - BZ user id of the assignee for the case before the change' , 
	`new_case_assignee_user_id` mediumint(9) unsigned NULL  COMMENT 'User ID - BZ user id of the assignee for the case after the change' , 
	`current_list_of_invitees` longtext COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'comma separated list of user IDs - BZ user ids of the user in cc for this case/bug AFTER the change' , 
	`current_status` varchar(64) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The current status of the case/bug' , 
	`current_resolution` varchar(64) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The current resolution of the case/bug' , 
	`current_severity` varchar(64) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The current severity of the case/bug' , 
	PRIMARY KEY (`notification_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Create table in target */
CREATE TABLE `ut_notification_message_new`(
	`notification_id` int(11) unsigned NOT NULL  auto_increment COMMENT 'Id in this table' , 
	`created_datetime` datetime NULL  COMMENT 'Timestamp when this was created' , 
	`processed_datetime` datetime NULL  COMMENT 'Timestamp when this notification was processed' , 
	`unit_id` mediumint(9) unsigned NULL  COMMENT 'Unit ID - a FK to the BZ table \'products\'' , 
	`case_id` mediumint(9) unsigned NULL  COMMENT 'Case ID - a FK to the BZ table \'bugs\'' , 
	`case_title` varchar(255) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The title for the case - the is the field `short_desc` in the `bugs` table' , 
	`user_id` mediumint(9) unsigned NULL  COMMENT 'User ID - The user who inititated the change - a FK to the BZ table \'profiles\'' , 
	`is_case_description` tinyint(1) NULL  COMMENT '1 if this is the FIRST message for a case (the case description)' , 
	`message_truncated` varchar(255) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The message, truncated to the first 255 characters' , 
	`case_reporter_user_id` mediumint(9) unsigned NULL  COMMENT 'User ID - BZ user id of the reporter for the case' , 
	`old_case_assignee_user_id` mediumint(9) unsigned NULL  COMMENT 'User ID - BZ user id of the assignee for the case before the change' , 
	`new_case_assignee_user_id` mediumint(9) unsigned NULL  COMMENT 'User ID - BZ user id of the assignee for the case after the change' , 
	`current_list_of_invitees` longtext COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'comma separated list of user IDs - BZ user ids of the user in cc for this case/bug AFTER the change' , 
	`current_status` varchar(64) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The current status of the case/bug' , 
	`current_resolution` varchar(64) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The current resolution of the case/bug' , 
	`current_severity` varchar(64) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The current severity of the case/bug' , 
	PRIMARY KEY (`notification_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Create table in target */
CREATE TABLE `ut_permission_types`(
	`id_permission_type` smallint(6) unsigned NOT NULL  auto_increment COMMENT 'ID in this table' , 
	`created` datetime NULL  COMMENT 'creation ts' , 
	`order` smallint(6) unsigned NULL  COMMENT 'Order in the list' , 
	`is_obsolete` tinyint(1) NULL  DEFAULT 0 COMMENT '1 if this is an obsolete value' , 
	`group_type_id` mediumint(9) unsigned NULL  COMMENT 'The id of the group that grant this permission - a FK to the table ut_group_types' , 
	`permission_type` varchar(255) COLLATE utf8mb4_unicode_520_ci NOT NULL  COMMENT 'A name for this role type' , 
	`permission_scope` varchar(255) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT '4 possible values: GLOBAL: for all units and roles, UNIT: permission for a specific unit, ROLE: permission for a specific role in a specific unit, SPECIAL: special permission (ex: occupant)' , 
	`permission_category` varchar(255) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'Possible values: ACCESS: group_control, GRANT FLAG: permissions to grant flags, ASK FOR APPROVAL: can ask a specific user to approve a flag, ROLE: a user is in a given role, ' , 
	`is_bless` tinyint(1) NULL  DEFAULT 0 COMMENT '1 if this is a permission to grant membership to a given group' , 
	`bless_id` mediumint(9) unsigned NULL  COMMENT 'IF this is a \'blessing\' permission - which permission can this grant' , 
	`description` varchar(255) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'A short, generic description that we include each time we create a new BZ unit.' , 
	`detailed_description` mediumtext COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'Detailed description of this group type' , 
	PRIMARY KEY (`id_permission_type`,`permission_type`) , 
	KEY `premission_groupe_type`(`group_type_id`) , 
	CONSTRAINT `premission_groupe_type` 
	FOREIGN KEY (`group_type_id`) REFERENCES `ut_group_types` (`id_group_type`) ON DELETE CASCADE ON UPDATE CASCADE 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Create table in target */
CREATE TABLE `ut_product_group`(
	`product_id` mediumint(9) unsigned NOT NULL  COMMENT 'id in the table products - to identify all the groups for a product/unit' , 
	`component_id` mediumint(9) unsigned NULL  COMMENT 'id in the table components - to identify all the groups for a given component/role' , 
	`group_id` mediumint(9) unsigned NOT NULL  COMMENT 'id in the table groups - to map the group to the list in the table `groups`' , 
	`group_type_id` mediumint(9) unsigned NOT NULL  COMMENT 'id in the table ut_group_types - to avoid re-creating the same group for the same product again' , 
	`role_type_id` smallint(6) unsigned NULL  COMMENT 'id in the table ut_role_types - to make sure all similar stakeholder in a unit are made a member of the same group' , 
	`created_by_id` mediumint(9) unsigned NULL  COMMENT 'id in the table ut_profiles' , 
	`created` datetime NULL  COMMENT 'creation ts' , 
	KEY `ut_product_group_product_id_group_id`(`product_id`,`group_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Create table in target */
CREATE TABLE `ut_role_types`(
	`id_role_type` smallint(6) unsigned NOT NULL  auto_increment COMMENT 'ID in this table' , 
	`created` datetime NULL  COMMENT 'creation ts' , 
	`role_type` varchar(255) COLLATE utf8mb4_unicode_520_ci NOT NULL  COMMENT 'A name for this role type' , 
	`bz_description` varchar(255) COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'A short, generic description that we include each time we create a new BZ unit.' , 
	`description` mediumtext COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'Detailed description of this group type' , 
	PRIMARY KEY (`id_role_type`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Create table in target */
CREATE TABLE `ut_script_log`(
	`id_ut_script_log` int(11) unsigned NOT NULL  auto_increment COMMENT 'The id of the record in this table' , 
	`datetime` datetime NULL  COMMENT 'When was this record created' , 
	`script` longtext COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'The script that was used to create the record' , 
	`log` mediumtext COLLATE utf8mb4_unicode_520_ci NULL  COMMENT 'More information about what we intended to do' , 
	PRIMARY KEY (`id_ut_script_log`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci' ROW_FORMAT=Dynamic;


/* Alter table in target */
ALTER TABLE `versions` 
	CHANGE `id` `id` mediumint(9) unsigned   NOT NULL auto_increment first , 
	CHANGE `product_id` `product_id` mediumint(9) unsigned   NOT NULL after `value` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `watch` 
	CHANGE `watcher` `watcher` mediumint(9) unsigned   NOT NULL first , 
	CHANGE `watched` `watched` mediumint(9) unsigned   NOT NULL after `watcher` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `whine_events` 
	CHANGE `id` `id` mediumint(9) unsigned   NOT NULL auto_increment first , 
	CHANGE `owner_userid` `owner_userid` mediumint(9) unsigned   NOT NULL after `id` , 
	CHANGE `body` `body` longtext  COLLATE utf8mb4_unicode_520_ci NULL after `subject` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `whine_queries` 
	CHANGE `id` `id` mediumint(9) unsigned   NOT NULL auto_increment first , 
	CHANGE `eventid` `eventid` mediumint(9) unsigned   NOT NULL after `id` , 
	CHANGE `sortkey` `sortkey` smallint(6) unsigned   NOT NULL DEFAULT 0 after `query_name` , ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `whine_schedules` 
	CHANGE `id` `id` mediumint(9) unsigned   NOT NULL auto_increment first , 
	CHANGE `eventid` `eventid` mediumint(9) unsigned   NOT NULL after `id` , 
	CHANGE `run_next` `run_next` datetime   NULL after `run_time` , 
	CHANGE `mailto` `mailto` mediumint(9) unsigned   NOT NULL after `run_next` , 
	CHANGE `mailto_type` `mailto_type` smallint(6) unsigned   NOT NULL DEFAULT 0 after `mailto` , ROW_FORMAT = Dynamic ;
/*Table structure for table `count_cases_per_users_per_month` */

/*!50001 DROP VIEW IF EXISTS `count_cases_per_users_per_month` */;
/*!50001 DROP TABLE IF EXISTS `count_cases_per_users_per_month` */;

/*!50001 CREATE TABLE  `count_cases_per_users_per_month`(
 `year` int(4) ,
 `month` int(2) ,
 `reporter` mediumint(9) unsigned ,
 `bugs_created` bigint(21) 
)*/;

/*Table structure for table `count_cases_per_users_per_week` */

/*!50001 DROP VIEW IF EXISTS `count_cases_per_users_per_week` */;
/*!50001 DROP TABLE IF EXISTS `count_cases_per_users_per_week` */;

/*!50001 CREATE TABLE  `count_cases_per_users_per_week`(
 `year` int(4) ,
 `month` int(2) ,
 `week` int(2) ,
 `reporter` mediumint(9) unsigned ,
 `bugs_created` bigint(21) 
)*/;

/*Table structure for table `count_cases_with_messages_per_month` */

/*!50001 DROP VIEW IF EXISTS `count_cases_with_messages_per_month` */;
/*!50001 DROP TABLE IF EXISTS `count_cases_with_messages_per_month` */;

/*!50001 CREATE TABLE  `count_cases_with_messages_per_month`(
 `year` int(4) ,
 `month` int(2) ,
 `count_cases_with_messages` bigint(21) 
)*/;

/*Table structure for table `count_cases_with_messages_per_week` */

/*!50001 DROP VIEW IF EXISTS `count_cases_with_messages_per_week` */;
/*!50001 DROP TABLE IF EXISTS `count_cases_with_messages_per_week` */;

/*!50001 CREATE TABLE  `count_cases_with_messages_per_week`(
 `year` int(4) ,
 `month` int(2) ,
 `week` int(2) ,
 `count_cases_with_messages` bigint(21) 
)*/;

/*Table structure for table `count_invitation_per_invitee_per_month` */

/*!50001 DROP VIEW IF EXISTS `count_invitation_per_invitee_per_month` */;
/*!50001 DROP TABLE IF EXISTS `count_invitation_per_invitee_per_month` */;

/*!50001 CREATE TABLE  `count_invitation_per_invitee_per_month`(
 `year` int(4) ,
 `month` int(2) ,
 `invitee_bz_user_id` mediumint(9) unsigned ,
 `invitation_sent` bigint(21) 
)*/;

/*Table structure for table `count_invitation_per_invitee_per_week` */

/*!50001 DROP VIEW IF EXISTS `count_invitation_per_invitee_per_week` */;
/*!50001 DROP TABLE IF EXISTS `count_invitation_per_invitee_per_week` */;

/*!50001 CREATE TABLE  `count_invitation_per_invitee_per_week`(
 `year` int(4) ,
 `month` int(2) ,
 `week` int(2) ,
 `invitee_bz_user_id` mediumint(9) unsigned ,
 `invitation_sent` bigint(21) 
)*/;

/*Table structure for table `count_invitation_per_invitor_per_month` */

/*!50001 DROP VIEW IF EXISTS `count_invitation_per_invitor_per_month` */;
/*!50001 DROP TABLE IF EXISTS `count_invitation_per_invitor_per_month` */;

/*!50001 CREATE TABLE  `count_invitation_per_invitor_per_month`(
 `year` int(4) ,
 `month` int(2) ,
 `invitor_bz_user_id` mediumint(9) unsigned ,
 `invitation_sent` bigint(21) 
)*/;

/*Table structure for table `count_invitation_per_invitor_per_week` */

/*!50001 DROP VIEW IF EXISTS `count_invitation_per_invitor_per_week` */;
/*!50001 DROP TABLE IF EXISTS `count_invitation_per_invitor_per_week` */;

/*!50001 CREATE TABLE  `count_invitation_per_invitor_per_week`(
 `year` int(4) ,
 `month` int(2) ,
 `week` int(2) ,
 `invitor_bz_user_id` mediumint(9) unsigned ,
 `invitation_sent` bigint(21) 
)*/;

/*Table structure for table `count_invitation_sent_per_month` */

/*!50001 DROP VIEW IF EXISTS `count_invitation_sent_per_month` */;
/*!50001 DROP TABLE IF EXISTS `count_invitation_sent_per_month` */;

/*!50001 CREATE TABLE  `count_invitation_sent_per_month`(
 `year` int(4) ,
 `month` int(2) ,
 `invitation_sent` bigint(21) 
)*/;

/*Table structure for table `count_invitation_sent_per_unit_per_month` */

/*!50001 DROP VIEW IF EXISTS `count_invitation_sent_per_unit_per_month` */;
/*!50001 DROP TABLE IF EXISTS `count_invitation_sent_per_unit_per_month` */;

/*!50001 CREATE TABLE  `count_invitation_sent_per_unit_per_month`(
 `year` int(4) ,
 `month` int(2) ,
 `bz_unit_id` mediumint(9) unsigned ,
 `invitation_sent` bigint(21) 
)*/;

/*Table structure for table `count_invitation_sent_per_unit_per_week` */

/*!50001 DROP VIEW IF EXISTS `count_invitation_sent_per_unit_per_week` */;
/*!50001 DROP TABLE IF EXISTS `count_invitation_sent_per_unit_per_week` */;

/*!50001 CREATE TABLE  `count_invitation_sent_per_unit_per_week`(
 `year` int(4) ,
 `month` int(2) ,
 `week` int(2) ,
 `bz_unit_id` mediumint(9) unsigned ,
 `invitation_sent` bigint(21) 
)*/;

/*Table structure for table `count_invitation_sent_per_week` */

/*!50001 DROP VIEW IF EXISTS `count_invitation_sent_per_week` */;
/*!50001 DROP TABLE IF EXISTS `count_invitation_sent_per_week` */;

/*!50001 CREATE TABLE  `count_invitation_sent_per_week`(
 `year` int(4) ,
 `month` int(2) ,
 `week` int(2) ,
 `invitation_sent` bigint(21) 
)*/;

/*Table structure for table `count_invites_per_month` */

/*!50001 DROP VIEW IF EXISTS `count_invites_per_month` */;
/*!50001 DROP TABLE IF EXISTS `count_invites_per_month` */;

/*!50001 CREATE TABLE  `count_invites_per_month`(
 `year` int(4) ,
 `month` int(2) ,
 `count_invites` bigint(21) 
)*/;

/*Table structure for table `count_invites_per_role_per_month` */

/*!50001 DROP VIEW IF EXISTS `count_invites_per_role_per_month` */;
/*!50001 DROP TABLE IF EXISTS `count_invites_per_role_per_month` */;

/*!50001 CREATE TABLE  `count_invites_per_role_per_month`(
 `year` int(4) ,
 `month` int(2) ,
 `user_role_type_id` smallint(6) unsigned ,
 `count_invites` bigint(21) 
)*/;

/*Table structure for table `count_invites_per_unit_per_month` */

/*!50001 DROP VIEW IF EXISTS `count_invites_per_unit_per_month` */;
/*!50001 DROP TABLE IF EXISTS `count_invites_per_unit_per_month` */;

/*!50001 CREATE TABLE  `count_invites_per_unit_per_month`(
 `year` int(4) ,
 `month` int(2) ,
 `bz_unit_id` mediumint(9) unsigned ,
 `count_invites` bigint(21) 
)*/;

/*Table structure for table `count_invites_per_unit_per_role_per_month` */

/*!50001 DROP VIEW IF EXISTS `count_invites_per_unit_per_role_per_month` */;
/*!50001 DROP TABLE IF EXISTS `count_invites_per_unit_per_role_per_month` */;

/*!50001 CREATE TABLE  `count_invites_per_unit_per_role_per_month`(
 `year` int(4) ,
 `month` int(2) ,
 `bz_unit_id` mediumint(9) unsigned ,
 `user_role_type_id` smallint(6) unsigned ,
 `invitation_sent` bigint(21) 
)*/;

/*Table structure for table `count_invites_per_user_per_month` */

/*!50001 DROP VIEW IF EXISTS `count_invites_per_user_per_month` */;
/*!50001 DROP TABLE IF EXISTS `count_invites_per_user_per_month` */;

/*!50001 CREATE TABLE  `count_invites_per_user_per_month`(
 `year` int(4) ,
 `month` int(2) ,
 `invitor` mediumint(9) unsigned ,
 `invitation_sent` bigint(21) 
)*/;

/*Table structure for table `count_invites_per_user_per_week` */

/*!50001 DROP VIEW IF EXISTS `count_invites_per_user_per_week` */;
/*!50001 DROP TABLE IF EXISTS `count_invites_per_user_per_week` */;

/*!50001 CREATE TABLE  `count_invites_per_user_per_week`(
 `year` int(4) ,
 `month` int(2) ,
 `week` int(2) ,
 `invitor` mediumint(9) unsigned ,
 `invitation_sent` bigint(21) 
)*/;

/*Table structure for table `count_messages_per_case_per_month` */

/*!50001 DROP VIEW IF EXISTS `count_messages_per_case_per_month` */;
/*!50001 DROP TABLE IF EXISTS `count_messages_per_case_per_month` */;

/*!50001 CREATE TABLE  `count_messages_per_case_per_month`(
 `year` int(4) ,
 `month` int(2) ,
 `case_id` mediumint(9) unsigned ,
 `count_messages` bigint(21) 
)*/;

/*Table structure for table `count_messages_per_case_per_week` */

/*!50001 DROP VIEW IF EXISTS `count_messages_per_case_per_week` */;
/*!50001 DROP TABLE IF EXISTS `count_messages_per_case_per_week` */;

/*!50001 CREATE TABLE  `count_messages_per_case_per_week`(
 `year` int(4) ,
 `month` int(2) ,
 `week` int(2) ,
 `case_id` mediumint(9) unsigned ,
 `count_messages` bigint(21) 
)*/;

/*Table structure for table `count_messages_per_unit_per_month` */

/*!50001 DROP VIEW IF EXISTS `count_messages_per_unit_per_month` */;
/*!50001 DROP TABLE IF EXISTS `count_messages_per_unit_per_month` */;

/*!50001 CREATE TABLE  `count_messages_per_unit_per_month`(
 `year` int(4) ,
 `month` int(2) ,
 `bz_unit_id` mediumint(9) unsigned ,
 `count_messages` bigint(21) 
)*/;

/*Table structure for table `count_messages_per_unit_per_quarter` */

/*!50001 DROP VIEW IF EXISTS `count_messages_per_unit_per_quarter` */;
/*!50001 DROP TABLE IF EXISTS `count_messages_per_unit_per_quarter` */;

/*!50001 CREATE TABLE  `count_messages_per_unit_per_quarter`(
 `year` int(4) ,
 `quarter` int(1) ,
 `bz_unit_id` mediumint(9) unsigned ,
 `count_messages` bigint(21) 
)*/;

/*Table structure for table `count_messages_per_unit_per_week` */

/*!50001 DROP VIEW IF EXISTS `count_messages_per_unit_per_week` */;
/*!50001 DROP TABLE IF EXISTS `count_messages_per_unit_per_week` */;

/*!50001 CREATE TABLE  `count_messages_per_unit_per_week`(
 `year` int(4) ,
 `month` int(2) ,
 `week` int(2) ,
 `bz_unit_id` mediumint(9) unsigned ,
 `count_messages` bigint(21) 
)*/;

/*Table structure for table `count_messages_per_users_per_month` */

/*!50001 DROP VIEW IF EXISTS `count_messages_per_users_per_month` */;
/*!50001 DROP TABLE IF EXISTS `count_messages_per_users_per_month` */;

/*!50001 CREATE TABLE  `count_messages_per_users_per_month`(
 `year` int(4) ,
 `month` int(2) ,
 `who` mediumint(9) unsigned ,
 `count_messages` bigint(21) 
)*/;

/*Table structure for table `count_messages_per_users_per_week` */

/*!50001 DROP VIEW IF EXISTS `count_messages_per_users_per_week` */;
/*!50001 DROP TABLE IF EXISTS `count_messages_per_users_per_week` */;

/*!50001 CREATE TABLE  `count_messages_per_users_per_week`(
 `year` int(4) ,
 `month` int(2) ,
 `week` int(2) ,
 `who` mediumint(9) unsigned ,
 `count_messages` bigint(21) 
)*/;

/*Table structure for table `count_new_cases_created_per_month` */

/*!50001 DROP VIEW IF EXISTS `count_new_cases_created_per_month` */;
/*!50001 DROP TABLE IF EXISTS `count_new_cases_created_per_month` */;

/*!50001 CREATE TABLE  `count_new_cases_created_per_month`(
 `year` int(4) ,
 `month` int(2) ,
 `count_cases` bigint(21) 
)*/;

/*Table structure for table `count_new_cases_created_per_week` */

/*!50001 DROP VIEW IF EXISTS `count_new_cases_created_per_week` */;
/*!50001 DROP TABLE IF EXISTS `count_new_cases_created_per_week` */;

/*!50001 CREATE TABLE  `count_new_cases_created_per_week`(
 `year` int(4) ,
 `month` int(2) ,
 `week` int(2) ,
 `count_cases_created` bigint(21) 
)*/;

/*Table structure for table `count_new_geographies_created_per_month` */

/*!50001 DROP VIEW IF EXISTS `count_new_geographies_created_per_month` */;
/*!50001 DROP TABLE IF EXISTS `count_new_geographies_created_per_month` */;

/*!50001 CREATE TABLE  `count_new_geographies_created_per_month`(
 `year` int(4) ,
 `month` int(2) ,
 `new_geography` bigint(21) 
)*/;

/*Table structure for table `count_new_messages_created_per_month` */

/*!50001 DROP VIEW IF EXISTS `count_new_messages_created_per_month` */;
/*!50001 DROP TABLE IF EXISTS `count_new_messages_created_per_month` */;

/*!50001 CREATE TABLE  `count_new_messages_created_per_month`(
 `year` int(4) ,
 `month` int(2) ,
 `count_messages_created` bigint(21) 
)*/;

/*Table structure for table `count_new_messages_created_per_week` */

/*!50001 DROP VIEW IF EXISTS `count_new_messages_created_per_week` */;
/*!50001 DROP TABLE IF EXISTS `count_new_messages_created_per_week` */;

/*!50001 CREATE TABLE  `count_new_messages_created_per_week`(
 `year` int(4) ,
 `month` int(2) ,
 `week` int(2) ,
 `count_messages_created` bigint(21) 
)*/;

/*Table structure for table `count_new_unit_created_per_month` */

/*!50001 DROP VIEW IF EXISTS `count_new_unit_created_per_month` */;
/*!50001 DROP TABLE IF EXISTS `count_new_unit_created_per_month` */;

/*!50001 CREATE TABLE  `count_new_unit_created_per_month`(
 `year` int(4) ,
 `month` int(2) ,
 `new_unit` bigint(21) 
)*/;

/*Table structure for table `count_new_unit_created_per_week` */

/*!50001 DROP VIEW IF EXISTS `count_new_unit_created_per_week` */;
/*!50001 DROP TABLE IF EXISTS `count_new_unit_created_per_week` */;

/*!50001 CREATE TABLE  `count_new_unit_created_per_week`(
 `year` int(4) ,
 `month` int(2) ,
 `week` int(2) ,
 `count_new_units` bigint(21) 
)*/;

/*Table structure for table `count_new_user_created_per_month` */

/*!50001 DROP VIEW IF EXISTS `count_new_user_created_per_month` */;
/*!50001 DROP TABLE IF EXISTS `count_new_user_created_per_month` */;

/*!50001 CREATE TABLE  `count_new_user_created_per_month`(
 `year` int(4) ,
 `month` int(2) ,
 `new_users` bigint(21) 
)*/;

/*Table structure for table `count_new_user_created_per_week` */

/*!50001 DROP VIEW IF EXISTS `count_new_user_created_per_week` */;
/*!50001 DROP TABLE IF EXISTS `count_new_user_created_per_week` */;

/*!50001 CREATE TABLE  `count_new_user_created_per_week`(
 `year` int(4) ,
 `month` int(2) ,
 `week` int(2) ,
 `new_users` bigint(21) 
)*/;

/*Table structure for table `count_unit_created_per_users_per_month` */

/*!50001 DROP VIEW IF EXISTS `count_unit_created_per_users_per_month` */;
/*!50001 DROP TABLE IF EXISTS `count_unit_created_per_users_per_month` */;

/*!50001 CREATE TABLE  `count_unit_created_per_users_per_month`(
 `year` int(4) ,
 `month` int(2) ,
 `user_id` mediumint(9) unsigned ,
 `count_new_units` bigint(21) 
)*/;

/*Table structure for table `count_unit_created_per_users_per_week` */

/*!50001 DROP VIEW IF EXISTS `count_unit_created_per_users_per_week` */;
/*!50001 DROP TABLE IF EXISTS `count_unit_created_per_users_per_week` */;

/*!50001 CREATE TABLE  `count_unit_created_per_users_per_week`(
 `year` int(4) ,
 `month` int(2) ,
 `week` int(2) ,
 `user_id` mediumint(9) unsigned ,
 `count_new_units` bigint(21) 
)*/;

/*Table structure for table `count_units_enabled_and_total_per_month` */

/*!50001 DROP VIEW IF EXISTS `count_units_enabled_and_total_per_month` */;
/*!50001 DROP TABLE IF EXISTS `count_units_enabled_and_total_per_month` */;

/*!50001 CREATE TABLE  `count_units_enabled_and_total_per_month`(
 `year` int(4) ,
 `month` int(2) ,
 `average_enabled_units` decimal(15,4) ,
 `average_total_units` decimal(15,4) 
)*/;

/*Table structure for table `count_units_enabled_and_total_per_week` */

/*!50001 DROP VIEW IF EXISTS `count_units_enabled_and_total_per_week` */;
/*!50001 DROP TABLE IF EXISTS `count_units_enabled_and_total_per_week` */;

/*!50001 CREATE TABLE  `count_units_enabled_and_total_per_week`(
 `year` int(4) ,
 `month` int(2) ,
 `week` int(2) ,
 `average_enabled_units` decimal(15,4) ,
 `average_total_units` decimal(15,4) 
)*/;

/*Table structure for table `count_units_with_invitation_sent_per_month` */

/*!50001 DROP VIEW IF EXISTS `count_units_with_invitation_sent_per_month` */;
/*!50001 DROP TABLE IF EXISTS `count_units_with_invitation_sent_per_month` */;

/*!50001 CREATE TABLE  `count_units_with_invitation_sent_per_month`(
 `year` int(4) ,
 `month` int(2) ,
 `count_units` bigint(21) 
)*/;

/*Table structure for table `count_units_with_invitation_sent_per_week` */

/*!50001 DROP VIEW IF EXISTS `count_units_with_invitation_sent_per_week` */;
/*!50001 DROP TABLE IF EXISTS `count_units_with_invitation_sent_per_week` */;

/*!50001 CREATE TABLE  `count_units_with_invitation_sent_per_week`(
 `year` int(4) ,
 `month` int(2) ,
 `week` int(2) ,
 `count_units` bigint(21) 
)*/;

/*Table structure for table `count_units_with_messages_per_month` */

/*!50001 DROP VIEW IF EXISTS `count_units_with_messages_per_month` */;
/*!50001 DROP TABLE IF EXISTS `count_units_with_messages_per_month` */;

/*!50001 CREATE TABLE  `count_units_with_messages_per_month`(
 `year` int(4) ,
 `month` int(2) ,
 `count_units_with_messages` bigint(21) 
)*/;

/*Table structure for table `count_units_with_messages_per_week` */

/*!50001 DROP VIEW IF EXISTS `count_units_with_messages_per_week` */;
/*!50001 DROP TABLE IF EXISTS `count_units_with_messages_per_week` */;

/*!50001 CREATE TABLE  `count_units_with_messages_per_week`(
 `year` int(4) ,
 `month` int(2) ,
 `week` int(2) ,
 `count_units_with_messages` bigint(21) 
)*/;

/*Table structure for table `count_users_who_create_case_per_month` */

/*!50001 DROP VIEW IF EXISTS `count_users_who_create_case_per_month` */;
/*!50001 DROP TABLE IF EXISTS `count_users_who_create_case_per_month` */;

/*!50001 CREATE TABLE  `count_users_who_create_case_per_month`(
 `year` int(4) ,
 `month` int(2) ,
 `count_users_who_create_case` bigint(21) 
)*/;

/*Table structure for table `count_users_who_create_case_per_week` */

/*!50001 DROP VIEW IF EXISTS `count_users_who_create_case_per_week` */;
/*!50001 DROP TABLE IF EXISTS `count_users_who_create_case_per_week` */;

/*!50001 CREATE TABLE  `count_users_who_create_case_per_week`(
 `year` int(4) ,
 `month` int(2) ,
 `week` int(2) ,
 `count_users_who_create_case` bigint(21) 
)*/;

/*Table structure for table `count_users_who_create_invites_per_month` */

/*!50001 DROP VIEW IF EXISTS `count_users_who_create_invites_per_month` */;
/*!50001 DROP TABLE IF EXISTS `count_users_who_create_invites_per_month` */;

/*!50001 CREATE TABLE  `count_users_who_create_invites_per_month`(
 `year` int(4) ,
 `month` int(2) ,
 `count_users_who_created_invites` bigint(21) 
)*/;

/*Table structure for table `count_users_who_create_invites_per_week` */

/*!50001 DROP VIEW IF EXISTS `count_users_who_create_invites_per_week` */;
/*!50001 DROP TABLE IF EXISTS `count_users_who_create_invites_per_week` */;

/*!50001 CREATE TABLE  `count_users_who_create_invites_per_week`(
 `year` int(4) ,
 `month` int(2) ,
 `week` int(2) ,
 `count_users_who_created_invites` bigint(21) 
)*/;

/*Table structure for table `count_users_who_create_units_per_month` */

/*!50001 DROP VIEW IF EXISTS `count_users_who_create_units_per_month` */;
/*!50001 DROP TABLE IF EXISTS `count_users_who_create_units_per_month` */;

/*!50001 CREATE TABLE  `count_users_who_create_units_per_month`(
 `year` int(4) ,
 `month` int(2) ,
 `count_users_who_created_units` bigint(21) 
)*/;

/*Table structure for table `count_users_who_create_units_per_week` */

/*!50001 DROP VIEW IF EXISTS `count_users_who_create_units_per_week` */;
/*!50001 DROP TABLE IF EXISTS `count_users_who_create_units_per_week` */;

/*!50001 CREATE TABLE  `count_users_who_create_units_per_week`(
 `year` int(4) ,
 `month` int(2) ,
 `week` int(2) ,
 `count_users_who_created_units` bigint(21) 
)*/;

/*Table structure for table `count_users_who_invited_someone_per_month` */

/*!50001 DROP VIEW IF EXISTS `count_users_who_invited_someone_per_month` */;
/*!50001 DROP TABLE IF EXISTS `count_users_who_invited_someone_per_month` */;

/*!50001 CREATE TABLE  `count_users_who_invited_someone_per_month`(
 `year` int(4) ,
 `month` int(2) ,
 `count_invitors` bigint(21) 
)*/;

/*Table structure for table `count_users_who_invited_someone_per_week` */

/*!50001 DROP VIEW IF EXISTS `count_users_who_invited_someone_per_week` */;
/*!50001 DROP TABLE IF EXISTS `count_users_who_invited_someone_per_week` */;

/*!50001 CREATE TABLE  `count_users_who_invited_someone_per_week`(
 `year` int(4) ,
 `month` int(2) ,
 `week` int(2) ,
 `count_invitors` bigint(21) 
)*/;

/*Table structure for table `count_users_who_sent_message_per_month` */

/*!50001 DROP VIEW IF EXISTS `count_users_who_sent_message_per_month` */;
/*!50001 DROP TABLE IF EXISTS `count_users_who_sent_message_per_month` */;

/*!50001 CREATE TABLE  `count_users_who_sent_message_per_month`(
 `year` int(4) ,
 `month` int(2) ,
 `count_users_who_sent_messages` bigint(21) 
)*/;

/*Table structure for table `count_users_who_sent_message_per_week` */

/*!50001 DROP VIEW IF EXISTS `count_users_who_sent_message_per_week` */;
/*!50001 DROP TABLE IF EXISTS `count_users_who_sent_message_per_week` */;

/*!50001 CREATE TABLE  `count_users_who_sent_message_per_week`(
 `year` int(4) ,
 `month` int(2) ,
 `week` int(2) ,
 `count_users_who_sent_messages` bigint(21) 
)*/;

/*Table structure for table `count_users_who_were_invited_per_month` */

/*!50001 DROP VIEW IF EXISTS `count_users_who_were_invited_per_month` */;
/*!50001 DROP TABLE IF EXISTS `count_users_who_were_invited_per_month` */;

/*!50001 CREATE TABLE  `count_users_who_were_invited_per_month`(
 `year` int(4) ,
 `month` int(2) ,
 `count_invitees` bigint(21) 
)*/;

/*Table structure for table `count_users_who_were_invited_per_week` */

/*!50001 DROP VIEW IF EXISTS `count_users_who_were_invited_per_week` */;
/*!50001 DROP TABLE IF EXISTS `count_users_who_were_invited_per_week` */;

/*!50001 CREATE TABLE  `count_users_who_were_invited_per_week`(
 `year` int(4) ,
 `month` int(2) ,
 `week` int(2) ,
 `count_invitees` bigint(21) 
)*/;

/*Table structure for table `flash_count_units_with_real_roles` */

/*!50001 DROP VIEW IF EXISTS `flash_count_units_with_real_roles` */;
/*!50001 DROP TABLE IF EXISTS `flash_count_units_with_real_roles` */;

/*!50001 CREATE TABLE  `flash_count_units_with_real_roles`(
 `role_type_id` smallint(6) unsigned ,
 `units_with_real_users` bigint(21) ,
 `isactive` tinyint(4) 
)*/;

/*Table structure for table `flash_count_user_per_role_per_unit` */

/*!50001 DROP VIEW IF EXISTS `flash_count_user_per_role_per_unit` */;
/*!50001 DROP TABLE IF EXISTS `flash_count_user_per_role_per_unit` */;

/*!50001 CREATE TABLE  `flash_count_user_per_role_per_unit`(
 `product_id` mediumint(9) unsigned ,
 `role_type_id` smallint(6) unsigned ,
 `count_users` bigint(21) 
)*/;

/*Table structure for table `list_all_changes_to_components_default_assignee_dummy_users` */

/*!50001 DROP VIEW IF EXISTS `list_all_changes_to_components_default_assignee_dummy_users` */;
/*!50001 DROP TABLE IF EXISTS `list_all_changes_to_components_default_assignee_dummy_users` */;

/*!50001 CREATE TABLE  `list_all_changes_to_components_default_assignee_dummy_users`(
 `class` varchar(255) ,
 `removed` longtext ,
 `action_remove` varchar(24) ,
 `added` longtext ,
 `action_add` varchar(20) ,
 `component_id` int(11) unsigned ,
 `at_time` datetime 
)*/;

/*Table structure for table `list_changes_new_assignee_is_real` */

/*!50001 DROP VIEW IF EXISTS `list_changes_new_assignee_is_real` */;
/*!50001 DROP TABLE IF EXISTS `list_changes_new_assignee_is_real` */;

/*!50001 CREATE TABLE  `list_changes_new_assignee_is_real`(
 `product_id` mediumint(9) unsigned ,
 `component_id` int(11) unsigned ,
 `removed` longtext ,
 `added` longtext ,
 `at_time` datetime ,
 `role_type_id` smallint(6) unsigned 
)*/;

/*Table structure for table `list_components_with_real_default_assignee` */

/*!50001 DROP VIEW IF EXISTS `list_components_with_real_default_assignee` */;
/*!50001 DROP TABLE IF EXISTS `list_components_with_real_default_assignee` */;

/*!50001 CREATE TABLE  `list_components_with_real_default_assignee`(
 `product_id` mediumint(9) unsigned ,
 `component_id` mediumint(9) unsigned ,
 `initialowner` mediumint(9) unsigned ,
 `role_type_id` smallint(6) unsigned ,
 `isactive` tinyint(4) 
)*/;

 DROP TABLE IF EXISTS `count_cases_per_users_per_month`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_cases_per_users_per_month` AS select year(`bugs`.`creation_ts`) AS `year`,month(`bugs`.`creation_ts`) AS `month`,`bugs`.`reporter` AS `reporter`,count(`bugs`.`bug_id`) AS `bugs_created` from `bugs` group by `bugs`.`reporter`,year(`bugs`.`creation_ts`),month(`bugs`.`creation_ts`) order by year(`bugs`.`creation_ts`) desc,month(`bugs`.`creation_ts`) desc,count(`bugs`.`bug_id`) desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_cases_per_users_per_week`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_cases_per_users_per_week` AS select year(`bugs`.`creation_ts`) AS `year`,month(`bugs`.`creation_ts`) AS `month`,week(`bugs`.`creation_ts`,0) AS `week`,`bugs`.`reporter` AS `reporter`,count(`bugs`.`bug_id`) AS `bugs_created` from `bugs` group by `bugs`.`reporter`,year(`bugs`.`creation_ts`),month(`bugs`.`creation_ts`),week(`bugs`.`creation_ts`,0) order by year(`bugs`.`creation_ts`) desc,month(`bugs`.`creation_ts`) desc,week(`bugs`.`creation_ts`,0) desc,count(`bugs`.`bug_id`) desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_cases_with_messages_per_month`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_cases_with_messages_per_month` AS select `count_messages_per_case_per_month`.`year` AS `year`,`count_messages_per_case_per_month`.`month` AS `month`,count(`count_messages_per_case_per_month`.`case_id`) AS `count_cases_with_messages` from `count_messages_per_case_per_month` group by `count_messages_per_case_per_month`.`month`,`count_messages_per_case_per_month`.`year` order by `count_messages_per_case_per_month`.`year` desc,`count_messages_per_case_per_month`.`month` desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_cases_with_messages_per_week`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_cases_with_messages_per_week` AS select `count_messages_per_case_per_week`.`year` AS `year`,`count_messages_per_case_per_week`.`month` AS `month`,`count_messages_per_case_per_week`.`week` AS `week`,count(`count_messages_per_case_per_week`.`case_id`) AS `count_cases_with_messages` from `count_messages_per_case_per_week` group by `count_messages_per_case_per_week`.`year`,`count_messages_per_case_per_week`.`month`,`count_messages_per_case_per_week`.`week` order by `count_messages_per_case_per_week`.`year` desc,`count_messages_per_case_per_week`.`week` desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_invitation_per_invitee_per_month`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_invitation_per_invitee_per_month` AS select year(`ut_invitation_api_data`.`processed_datetime`) AS `year`,month(`ut_invitation_api_data`.`processed_datetime`) AS `month`,`ut_invitation_api_data`.`bz_user_id` AS `invitee_bz_user_id`,count(`ut_invitation_api_data`.`id`) AS `invitation_sent` from `ut_invitation_api_data` group by `ut_invitation_api_data`.`bz_user_id`,month(`ut_invitation_api_data`.`processed_datetime`),year(`ut_invitation_api_data`.`processed_datetime`) order by year(`ut_invitation_api_data`.`processed_datetime`) desc,month(`ut_invitation_api_data`.`processed_datetime`) desc,count(`ut_invitation_api_data`.`id`) descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_invitation_per_invitee_per_month` AS select year(`ut_invitation_api_data`.`processed_datetime`) AS `year`,month(`ut_invitation_api_data`.`processed_datetime`) AS `month`,`ut_invitation_api_data`.`bz_user_id` AS `invitee_bz_user_id`,count(`ut_invitation_api_data`.`id`) AS `invitation_sent` from `ut_invitation_api_data` group by `ut_invitation_api_data`.`bz_user_id`,month(`ut_invitation_api_data`.`processed_datetime`),year(`ut_invitation_api_data`.`processed_datetime`) order by year(`ut_invitation_api_data`.`processed_datetime`) desc,month(`ut_invitation_api_data`.`processed_datetime`) desc,count(`ut_invitation_api_data`.`id`) desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_invitation_per_invitee_per_week`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_invitation_per_invitee_per_week` AS select year(`ut_invitation_api_data`.`processed_datetime`) AS `year`,month(`ut_invitation_api_data`.`processed_datetime`) AS `month`,week(`ut_invitation_api_data`.`processed_datetime`,0) AS `week`,`ut_invitation_api_data`.`bz_user_id` AS `invitee_bz_user_id`,count(`ut_invitation_api_data`.`id`) AS `invitation_sent` from `ut_invitation_api_data` group by `ut_invitation_api_data`.`bz_user_id`,year(`ut_invitation_api_data`.`processed_datetime`),month(`ut_invitation_api_data`.`processed_datetime`),week(`ut_invitation_api_data`.`processed_datetime`,0) order by year(`ut_invitation_api_data`.`processed_datetime`) desc,week(`ut_invitation_api_data`.`processed_datetime`,0) desc,count(`ut_invitation_api_data`.`id`) descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_invitation_per_invitee_per_week` AS select year(`ut_invitation_api_data`.`processed_datetime`) AS `year`,month(`ut_invitation_api_data`.`processed_datetime`) AS `month`,week(`ut_invitation_api_data`.`processed_datetime`,0) AS `week`,`ut_invitation_api_data`.`bz_user_id` AS `invitee_bz_user_id`,count(`ut_invitation_api_data`.`id`) AS `invitation_sent` from `ut_invitation_api_data` group by `ut_invitation_api_data`.`bz_user_id`,year(`ut_invitation_api_data`.`processed_datetime`),month(`ut_invitation_api_data`.`processed_datetime`),week(`ut_invitation_api_data`.`processed_datetime`,0) order by year(`ut_invitation_api_data`.`processed_datetime`) desc,week(`ut_invitation_api_data`.`processed_datetime`,0) desc,count(`ut_invitation_api_data`.`id`) desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_invitation_per_invitor_per_month`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_invitation_per_invitor_per_month` AS select year(`ut_invitation_api_data`.`processed_datetime`) AS `year`,month(`ut_invitation_api_data`.`processed_datetime`) AS `month`,`ut_invitation_api_data`.`bzfe_invitor_user_id` AS `invitor_bz_user_id`,count(`ut_invitation_api_data`.`id`) AS `invitation_sent` from `ut_invitation_api_data` group by `ut_invitation_api_data`.`bzfe_invitor_user_id`,month(`ut_invitation_api_data`.`processed_datetime`),year(`ut_invitation_api_data`.`processed_datetime`) order by year(`ut_invitation_api_data`.`processed_datetime`) desc,month(`ut_invitation_api_data`.`processed_datetime`) desc,count(`ut_invitation_api_data`.`id`) descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_invitation_per_invitor_per_month` AS select year(`ut_invitation_api_data`.`processed_datetime`) AS `year`,month(`ut_invitation_api_data`.`processed_datetime`) AS `month`,`ut_invitation_api_data`.`bzfe_invitor_user_id` AS `invitor_bz_user_id`,count(`ut_invitation_api_data`.`id`) AS `invitation_sent` from `ut_invitation_api_data` group by `ut_invitation_api_data`.`bzfe_invitor_user_id`,month(`ut_invitation_api_data`.`processed_datetime`),year(`ut_invitation_api_data`.`processed_datetime`) order by year(`ut_invitation_api_data`.`processed_datetime`) desc,month(`ut_invitation_api_data`.`processed_datetime`) desc,count(`ut_invitation_api_data`.`id`) desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_invitation_per_invitor_per_week`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_invitation_per_invitor_per_week` AS select year(`ut_invitation_api_data`.`processed_datetime`) AS `year`,month(`ut_invitation_api_data`.`processed_datetime`) AS `month`,week(`ut_invitation_api_data`.`processed_datetime`,0) AS `week`,`ut_invitation_api_data`.`bzfe_invitor_user_id` AS `invitor_bz_user_id`,count(`ut_invitation_api_data`.`id`) AS `invitation_sent` from `ut_invitation_api_data` group by `ut_invitation_api_data`.`bzfe_invitor_user_id`,year(`ut_invitation_api_data`.`processed_datetime`),month(`ut_invitation_api_data`.`processed_datetime`),week(`ut_invitation_api_data`.`processed_datetime`,0) order by year(`ut_invitation_api_data`.`processed_datetime`) desc,week(`ut_invitation_api_data`.`processed_datetime`,0) desc,count(`ut_invitation_api_data`.`id`) descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_invitation_per_invitor_per_week` AS select year(`ut_invitation_api_data`.`processed_datetime`) AS `year`,month(`ut_invitation_api_data`.`processed_datetime`) AS `month`,week(`ut_invitation_api_data`.`processed_datetime`,0) AS `week`,`ut_invitation_api_data`.`bzfe_invitor_user_id` AS `invitor_bz_user_id`,count(`ut_invitation_api_data`.`id`) AS `invitation_sent` from `ut_invitation_api_data` group by `ut_invitation_api_data`.`bzfe_invitor_user_id`,year(`ut_invitation_api_data`.`processed_datetime`),month(`ut_invitation_api_data`.`processed_datetime`),week(`ut_invitation_api_data`.`processed_datetime`,0) order by year(`ut_invitation_api_data`.`processed_datetime`) desc,week(`ut_invitation_api_data`.`processed_datetime`,0) desc,count(`ut_invitation_api_data`.`id`) desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_invitation_sent_per_month`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_invitation_sent_per_month` AS select year(`ut_invitation_api_data`.`processed_datetime`) AS `year`,month(`ut_invitation_api_data`.`processed_datetime`) AS `month`,count(`ut_invitation_api_data`.`id`) AS `invitation_sent` from `ut_invitation_api_data` group by year(`ut_invitation_api_data`.`processed_datetime`),month(`ut_invitation_api_data`.`processed_datetime`) order by year(`ut_invitation_api_data`.`processed_datetime`) desc,month(`ut_invitation_api_data`.`processed_datetime`) descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_invitation_sent_per_month` AS select year(`ut_invitation_api_data`.`processed_datetime`) AS `year`,month(`ut_invitation_api_data`.`processed_datetime`) AS `month`,count(`ut_invitation_api_data`.`id`) AS `invitation_sent` from `ut_invitation_api_data` group by year(`ut_invitation_api_data`.`processed_datetime`),month(`ut_invitation_api_data`.`processed_datetime`) order by year(`ut_invitation_api_data`.`processed_datetime`) desc,month(`ut_invitation_api_data`.`processed_datetime`) desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_invitation_sent_per_unit_per_month`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_invitation_sent_per_unit_per_month` AS select year(`ut_invitation_api_data`.`processed_datetime`) AS `year`,month(`ut_invitation_api_data`.`processed_datetime`) AS `month`,`ut_invitation_api_data`.`bz_unit_id` AS `bz_unit_id`,count(`ut_invitation_api_data`.`id`) AS `invitation_sent` from `ut_invitation_api_data` group by year(`ut_invitation_api_data`.`processed_datetime`),month(`ut_invitation_api_data`.`processed_datetime`),`ut_invitation_api_data`.`bz_unit_id` order by year(`ut_invitation_api_data`.`processed_datetime`) desc,month(`ut_invitation_api_data`.`processed_datetime`) desc,count(`ut_invitation_api_data`.`id`) descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_invitation_sent_per_unit_per_month` AS select year(`ut_invitation_api_data`.`processed_datetime`) AS `year`,month(`ut_invitation_api_data`.`processed_datetime`) AS `month`,`ut_invitation_api_data`.`bz_unit_id` AS `bz_unit_id`,count(`ut_invitation_api_data`.`id`) AS `invitation_sent` from `ut_invitation_api_data` group by year(`ut_invitation_api_data`.`processed_datetime`),month(`ut_invitation_api_data`.`processed_datetime`),`ut_invitation_api_data`.`bz_unit_id` order by year(`ut_invitation_api_data`.`processed_datetime`) desc,month(`ut_invitation_api_data`.`processed_datetime`) desc,count(`ut_invitation_api_data`.`id`) desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_invitation_sent_per_unit_per_week`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_invitation_sent_per_unit_per_week` AS select year(`ut_invitation_api_data`.`processed_datetime`) AS `year`,month(`ut_invitation_api_data`.`processed_datetime`) AS `month`,week(`ut_invitation_api_data`.`processed_datetime`,0) AS `week`,`ut_invitation_api_data`.`bz_unit_id` AS `bz_unit_id`,count(`ut_invitation_api_data`.`id`) AS `invitation_sent` from `ut_invitation_api_data` group by year(`ut_invitation_api_data`.`processed_datetime`),month(`ut_invitation_api_data`.`processed_datetime`),week(`ut_invitation_api_data`.`processed_datetime`,0),`ut_invitation_api_data`.`bz_unit_id` order by year(`ut_invitation_api_data`.`processed_datetime`) desc,month(`ut_invitation_api_data`.`processed_datetime`) desc,week(`ut_invitation_api_data`.`processed_datetime`,0) desc,count(`ut_invitation_api_data`.`id`) descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_invitation_sent_per_unit_per_week` AS select year(`ut_invitation_api_data`.`processed_datetime`) AS `year`,month(`ut_invitation_api_data`.`processed_datetime`) AS `month`,week(`ut_invitation_api_data`.`processed_datetime`,0) AS `week`,`ut_invitation_api_data`.`bz_unit_id` AS `bz_unit_id`,count(`ut_invitation_api_data`.`id`) AS `invitation_sent` from `ut_invitation_api_data` group by year(`ut_invitation_api_data`.`processed_datetime`),month(`ut_invitation_api_data`.`processed_datetime`),week(`ut_invitation_api_data`.`processed_datetime`,0),`ut_invitation_api_data`.`bz_unit_id` order by year(`ut_invitation_api_data`.`processed_datetime`) desc,month(`ut_invitation_api_data`.`processed_datetime`) desc,week(`ut_invitation_api_data`.`processed_datetime`,0) desc,count(`ut_invitation_api_data`.`id`) desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_invitation_sent_per_week`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_invitation_sent_per_week` AS select year(`ut_invitation_api_data`.`processed_datetime`) AS `year`,month(`ut_invitation_api_data`.`processed_datetime`) AS `month`,week(`ut_invitation_api_data`.`processed_datetime`,0) AS `week`,count(`ut_invitation_api_data`.`id`) AS `invitation_sent` from `ut_invitation_api_data` group by year(`ut_invitation_api_data`.`processed_datetime`),month(`ut_invitation_api_data`.`processed_datetime`) desc,week(`ut_invitation_api_data`.`processed_datetime`,0) order by year(`ut_invitation_api_data`.`processed_datetime`) desc,week(`ut_invitation_api_data`.`processed_datetime`,0) descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_invitation_sent_per_week` AS select year(`ut_invitation_api_data`.`processed_datetime`) AS `year`,month(`ut_invitation_api_data`.`processed_datetime`) AS `month`,week(`ut_invitation_api_data`.`processed_datetime`,0) AS `week`,count(`ut_invitation_api_data`.`id`) AS `invitation_sent` from `ut_invitation_api_data` group by year(`ut_invitation_api_data`.`processed_datetime`),month(`ut_invitation_api_data`.`processed_datetime`) desc,week(`ut_invitation_api_data`.`processed_datetime`,0) order by year(`ut_invitation_api_data`.`processed_datetime`) desc,week(`ut_invitation_api_data`.`processed_datetime`,0) desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_invites_per_month`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_invites_per_month` AS select `count_invites_per_unit_per_role_per_month`.`year` AS `year`,`count_invites_per_unit_per_role_per_month`.`month` AS `month`,count(`count_invites_per_unit_per_role_per_month`.`invitation_sent`) AS `count_invites` from `count_invites_per_unit_per_role_per_month` group by `count_invites_per_unit_per_role_per_month`.`month`,`count_invites_per_unit_per_role_per_month`.`year` order by `count_invites_per_unit_per_role_per_month`.`year` desc,`count_invites_per_unit_per_role_per_month`.`month` descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_invites_per_month` AS select `count_invites_per_unit_per_role_per_month`.`year` AS `year`,`count_invites_per_unit_per_role_per_month`.`month` AS `month`,count(`count_invites_per_unit_per_role_per_month`.`invitation_sent`) AS `count_invites` from `count_invites_per_unit_per_role_per_month` group by `count_invites_per_unit_per_role_per_month`.`month`,`count_invites_per_unit_per_role_per_month`.`year` order by `count_invites_per_unit_per_role_per_month`.`year` desc,`count_invites_per_unit_per_role_per_month`.`month` desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_invites_per_role_per_month`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_invites_per_role_per_month` AS select `count_invites_per_unit_per_role_per_month`.`year` AS `year`,`count_invites_per_unit_per_role_per_month`.`month` AS `month`,`count_invites_per_unit_per_role_per_month`.`user_role_type_id` AS `user_role_type_id`,count(`count_invites_per_unit_per_role_per_month`.`invitation_sent`) AS `count_invites` from `count_invites_per_unit_per_role_per_month` group by `count_invites_per_unit_per_role_per_month`.`month`,`count_invites_per_unit_per_role_per_month`.`year`,`count_invites_per_unit_per_role_per_month`.`user_role_type_id` order by `count_invites_per_unit_per_role_per_month`.`year` desc,`count_invites_per_unit_per_role_per_month`.`month` desc,`count_invites_per_unit_per_role_per_month`.`user_role_type_id`CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_invites_per_role_per_month` AS select `count_invites_per_unit_per_role_per_month`.`year` AS `year`,`count_invites_per_unit_per_role_per_month`.`month` AS `month`,`count_invites_per_unit_per_role_per_month`.`user_role_type_id` AS `user_role_type_id`,count(`count_invites_per_unit_per_role_per_month`.`invitation_sent`) AS `count_invites` from `count_invites_per_unit_per_role_per_month` group by `count_invites_per_unit_per_role_per_month`.`month`,`count_invites_per_unit_per_role_per_month`.`year`,`count_invites_per_unit_per_role_per_month`.`user_role_type_id` order by `count_invites_per_unit_per_role_per_month`.`year` desc,`count_invites_per_unit_per_role_per_month`.`month` desc,`count_invites_per_unit_per_role_per_month`.`user_role_type_id`$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_invites_per_unit_per_month`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_invites_per_unit_per_month` AS select `count_invites_per_unit_per_role_per_month`.`year` AS `year`,`count_invites_per_unit_per_role_per_month`.`month` AS `month`,`count_invites_per_unit_per_role_per_month`.`bz_unit_id` AS `bz_unit_id`,count(`count_invites_per_unit_per_role_per_month`.`invitation_sent`) AS `count_invites` from `count_invites_per_unit_per_role_per_month` group by `count_invites_per_unit_per_role_per_month`.`month`,`count_invites_per_unit_per_role_per_month`.`year`,`count_invites_per_unit_per_role_per_month`.`bz_unit_id` order by `count_invites_per_unit_per_role_per_month`.`year` desc,`count_invites_per_unit_per_role_per_month`.`month` desc,`count_invites_per_unit_per_role_per_month`.`bz_unit_id`CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_invites_per_unit_per_month` AS select `count_invites_per_unit_per_role_per_month`.`year` AS `year`,`count_invites_per_unit_per_role_per_month`.`month` AS `month`,`count_invites_per_unit_per_role_per_month`.`bz_unit_id` AS `bz_unit_id`,count(`count_invites_per_unit_per_role_per_month`.`invitation_sent`) AS `count_invites` from `count_invites_per_unit_per_role_per_month` group by `count_invites_per_unit_per_role_per_month`.`month`,`count_invites_per_unit_per_role_per_month`.`year`,`count_invites_per_unit_per_role_per_month`.`bz_unit_id` order by `count_invites_per_unit_per_role_per_month`.`year` desc,`count_invites_per_unit_per_role_per_month`.`month` desc,`count_invites_per_unit_per_role_per_month`.`bz_unit_id`$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_invites_per_unit_per_role_per_month`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_invites_per_unit_per_role_per_month` AS select year(`ut_invitation_api_data`.`processed_datetime`) AS `year`,month(`ut_invitation_api_data`.`processed_datetime`) AS `month`,`ut_invitation_api_data`.`bz_unit_id` AS `bz_unit_id`,`ut_invitation_api_data`.`user_role_type_id` AS `user_role_type_id`,count(`ut_invitation_api_data`.`id`) AS `invitation_sent` from `ut_invitation_api_data` group by `ut_invitation_api_data`.`bz_user_id`,month(`ut_invitation_api_data`.`processed_datetime`),year(`ut_invitation_api_data`.`processed_datetime`),`ut_invitation_api_data`.`bz_unit_id`,`ut_invitation_api_data`.`user_role_type_id` order by year(`ut_invitation_api_data`.`processed_datetime`) desc,month(`ut_invitation_api_data`.`processed_datetime`) desc,`ut_invitation_api_data`.`user_role_type_id`,`ut_invitation_api_data`.`bz_unit_id`,count(`ut_invitation_api_data`.`id`) descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_invites_per_unit_per_role_per_month` AS select year(`ut_invitation_api_data`.`processed_datetime`) AS `year`,month(`ut_invitation_api_data`.`processed_datetime`) AS `month`,`ut_invitation_api_data`.`bz_unit_id` AS `bz_unit_id`,`ut_invitation_api_data`.`user_role_type_id` AS `user_role_type_id`,count(`ut_invitation_api_data`.`id`) AS `invitation_sent` from `ut_invitation_api_data` group by `ut_invitation_api_data`.`bz_user_id`,month(`ut_invitation_api_data`.`processed_datetime`),year(`ut_invitation_api_data`.`processed_datetime`),`ut_invitation_api_data`.`bz_unit_id`,`ut_invitation_api_data`.`user_role_type_id` order by year(`ut_invitation_api_data`.`processed_datetime`) desc,month(`ut_invitation_api_data`.`processed_datetime`) desc,`ut_invitation_api_data`.`user_role_type_id`,`ut_invitation_api_data`.`bz_unit_id`,count(`ut_invitation_api_data`.`id`) desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_invites_per_user_per_month`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_invites_per_user_per_month` AS select year(`ut_invitation_api_data`.`processed_datetime`) AS `year`,month(`ut_invitation_api_data`.`processed_datetime`) AS `month`,`ut_invitation_api_data`.`bzfe_invitor_user_id` AS `invitor`,count(`ut_invitation_api_data`.`id`) AS `invitation_sent` from `ut_invitation_api_data` group by year(`ut_invitation_api_data`.`processed_datetime`),month(`ut_invitation_api_data`.`processed_datetime`),`ut_invitation_api_data`.`bzfe_invitor_user_id` order by year(`ut_invitation_api_data`.`processed_datetime`) desc,month(`ut_invitation_api_data`.`processed_datetime`) desc,count(`ut_invitation_api_data`.`id`) descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_invites_per_user_per_month` AS select year(`ut_invitation_api_data`.`processed_datetime`) AS `year`,month(`ut_invitation_api_data`.`processed_datetime`) AS `month`,`ut_invitation_api_data`.`bzfe_invitor_user_id` AS `invitor`,count(`ut_invitation_api_data`.`id`) AS `invitation_sent` from `ut_invitation_api_data` group by year(`ut_invitation_api_data`.`processed_datetime`),month(`ut_invitation_api_data`.`processed_datetime`),`ut_invitation_api_data`.`bzfe_invitor_user_id` order by year(`ut_invitation_api_data`.`processed_datetime`) desc,month(`ut_invitation_api_data`.`processed_datetime`) desc,count(`ut_invitation_api_data`.`id`) desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_invites_per_user_per_week`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_invites_per_user_per_week` AS select year(`ut_invitation_api_data`.`processed_datetime`) AS `year`,month(`ut_invitation_api_data`.`processed_datetime`) AS `month`,week(`ut_invitation_api_data`.`processed_datetime`,0) AS `week`,`ut_invitation_api_data`.`bzfe_invitor_user_id` AS `invitor`,count(`ut_invitation_api_data`.`id`) AS `invitation_sent` from `ut_invitation_api_data` group by year(`ut_invitation_api_data`.`processed_datetime`),month(`ut_invitation_api_data`.`processed_datetime`),week(`ut_invitation_api_data`.`processed_datetime`,0),`ut_invitation_api_data`.`bzfe_invitor_user_id` order by year(`ut_invitation_api_data`.`processed_datetime`) desc,month(`ut_invitation_api_data`.`processed_datetime`) desc,week(`ut_invitation_api_data`.`processed_datetime`,0) desc,count(`ut_invitation_api_data`.`id`) descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_invites_per_user_per_week` AS select year(`ut_invitation_api_data`.`processed_datetime`) AS `year`,month(`ut_invitation_api_data`.`processed_datetime`) AS `month`,week(`ut_invitation_api_data`.`processed_datetime`,0) AS `week`,`ut_invitation_api_data`.`bzfe_invitor_user_id` AS `invitor`,count(`ut_invitation_api_data`.`id`) AS `invitation_sent` from `ut_invitation_api_data` group by year(`ut_invitation_api_data`.`processed_datetime`),month(`ut_invitation_api_data`.`processed_datetime`),week(`ut_invitation_api_data`.`processed_datetime`,0),`ut_invitation_api_data`.`bzfe_invitor_user_id` order by year(`ut_invitation_api_data`.`processed_datetime`) desc,month(`ut_invitation_api_data`.`processed_datetime`) desc,week(`ut_invitation_api_data`.`processed_datetime`,0) desc,count(`ut_invitation_api_data`.`id`) desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_messages_per_case_per_month`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_messages_per_case_per_month` AS select year(`longdescs`.`bug_when`) AS `year`,month(`longdescs`.`bug_when`) AS `month`,`longdescs`.`bug_id` AS `case_id`,count(`longdescs`.`comment_id`) AS `count_messages` from `longdescs` group by year(`longdescs`.`bug_when`),month(`longdescs`.`bug_when`),`longdescs`.`bug_id` order by year(`longdescs`.`bug_when`) desc,month(`longdescs`.`bug_when`) desc,count(`longdescs`.`comment_id`) desc,`longdescs`.`bug_id` descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_messages_per_case_per_month` AS select year(`longdescs`.`bug_when`) AS `year`,month(`longdescs`.`bug_when`) AS `month`,`longdescs`.`bug_id` AS `case_id`,count(`longdescs`.`comment_id`) AS `count_messages` from `longdescs` group by year(`longdescs`.`bug_when`),month(`longdescs`.`bug_when`),`longdescs`.`bug_id` order by year(`longdescs`.`bug_when`) desc,month(`longdescs`.`bug_when`) desc,count(`longdescs`.`comment_id`) desc,`longdescs`.`bug_id` desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_messages_per_case_per_week`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_messages_per_case_per_week` AS select year(`longdescs`.`bug_when`) AS `year`,month(`longdescs`.`bug_when`) AS `month`,week(`longdescs`.`bug_when`,0) AS `week`,`longdescs`.`bug_id` AS `case_id`,count(`longdescs`.`comment_id`) AS `count_messages` from `longdescs` group by year(`longdescs`.`bug_when`),week(`longdescs`.`bug_when`,0),`longdescs`.`bug_id` order by year(`longdescs`.`bug_when`) desc,week(`longdescs`.`bug_when`,0) desc,count(`longdescs`.`comment_id`) desc,`longdescs`.`bug_id` descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_messages_per_case_per_week` AS select year(`longdescs`.`bug_when`) AS `year`,month(`longdescs`.`bug_when`) AS `month`,week(`longdescs`.`bug_when`,0) AS `week`,`longdescs`.`bug_id` AS `case_id`,count(`longdescs`.`comment_id`) AS `count_messages` from `longdescs` group by year(`longdescs`.`bug_when`),week(`longdescs`.`bug_when`,0),`longdescs`.`bug_id` order by year(`longdescs`.`bug_when`) desc,week(`longdescs`.`bug_when`,0) desc,count(`longdescs`.`comment_id`) desc,`longdescs`.`bug_id` desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_messages_per_unit_per_month`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_messages_per_unit_per_month` AS select year(`longdescs`.`bug_when`) AS `year`,month(`longdescs`.`bug_when`) AS `month`,`bugs`.`product_id` AS `bz_unit_id`,count(`longdescs`.`comment_id`) AS `count_messages` from (`longdescs` join `bugs` on((`longdescs`.`bug_id` = `bugs`.`bug_id`))) group by year(`longdescs`.`bug_when`),month(`longdescs`.`bug_when`),`bugs`.`product_id` order by year(`longdescs`.`bug_when`) desc,month(`longdescs`.`bug_when`) desc,count(`longdescs`.`comment_id`) desc,`bugs`.`product_id` descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_messages_per_unit_per_month` AS select year(`longdescs`.`bug_when`) AS `year`,month(`longdescs`.`bug_when`) AS `month`,`bugs`.`product_id` AS `bz_unit_id`,count(`longdescs`.`comment_id`) AS `count_messages` from (`longdescs` join `bugs` on((`longdescs`.`bug_id` = `bugs`.`bug_id`))) group by year(`longdescs`.`bug_when`),month(`longdescs`.`bug_when`),`bugs`.`product_id` order by year(`longdescs`.`bug_when`) desc,month(`longdescs`.`bug_when`) desc,count(`longdescs`.`comment_id`) desc,`bugs`.`product_id` desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_messages_per_unit_per_quarter`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_messages_per_unit_per_quarter` AS select year(`longdescs`.`bug_when`) AS `year`,quarter(`longdescs`.`bug_when`) AS `quarter`,`bugs`.`product_id` AS `bz_unit_id`,count(`longdescs`.`comment_id`) AS `count_messages` from (`longdescs` join `bugs` on((`longdescs`.`bug_id` = `bugs`.`bug_id`))) group by year(`longdescs`.`bug_when`),quarter(`longdescs`.`bug_when`),`bugs`.`product_id` order by year(`longdescs`.`bug_when`) desc,quarter(`longdescs`.`bug_when`) desc,count(`longdescs`.`comment_id`) desc,`bugs`.`product_id` descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_messages_per_unit_per_quarter` AS select year(`longdescs`.`bug_when`) AS `year`,quarter(`longdescs`.`bug_when`) AS `quarter`,`bugs`.`product_id` AS `bz_unit_id`,count(`longdescs`.`comment_id`) AS `count_messages` from (`longdescs` join `bugs` on((`longdescs`.`bug_id` = `bugs`.`bug_id`))) group by year(`longdescs`.`bug_when`),quarter(`longdescs`.`bug_when`),`bugs`.`product_id` order by year(`longdescs`.`bug_when`) desc,quarter(`longdescs`.`bug_when`) desc,count(`longdescs`.`comment_id`) desc,`bugs`.`product_id` desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_messages_per_unit_per_week`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_messages_per_unit_per_week` AS select year(`longdescs`.`bug_when`) AS `year`,month(`longdescs`.`bug_when`) AS `month`,week(`longdescs`.`bug_when`,0) AS `week`,`bugs`.`product_id` AS `bz_unit_id`,count(`longdescs`.`comment_id`) AS `count_messages` from (`longdescs` join `bugs` on((`longdescs`.`bug_id` = `bugs`.`bug_id`))) group by year(`longdescs`.`bug_when`),week(`longdescs`.`bug_when`,0),`bugs`.`product_id` order by year(`longdescs`.`bug_when`) desc,week(`longdescs`.`bug_when`,0) desc,count(`longdescs`.`comment_id`) desc,`bugs`.`product_id` descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_messages_per_unit_per_week` AS select year(`longdescs`.`bug_when`) AS `year`,month(`longdescs`.`bug_when`) AS `month`,week(`longdescs`.`bug_when`,0) AS `week`,`bugs`.`product_id` AS `bz_unit_id`,count(`longdescs`.`comment_id`) AS `count_messages` from (`longdescs` join `bugs` on((`longdescs`.`bug_id` = `bugs`.`bug_id`))) group by year(`longdescs`.`bug_when`),week(`longdescs`.`bug_when`,0),`bugs`.`product_id` order by year(`longdescs`.`bug_when`) desc,week(`longdescs`.`bug_when`,0) desc,count(`longdescs`.`comment_id`) desc,`bugs`.`product_id` desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_messages_per_users_per_month`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_messages_per_users_per_month` AS select year(`longdescs`.`bug_when`) AS `year`,month(`longdescs`.`bug_when`) AS `month`,`longdescs`.`who` AS `who`,count(`longdescs`.`comment_id`) AS `count_messages` from `longdescs` group by `longdescs`.`who`,year(`longdescs`.`bug_when`),month(`longdescs`.`bug_when`) order by year(`longdescs`.`bug_when`) desc,month(`longdescs`.`bug_when`) desc,count(`longdescs`.`comment_id`) descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_messages_per_users_per_month` AS select year(`longdescs`.`bug_when`) AS `year`,month(`longdescs`.`bug_when`) AS `month`,`longdescs`.`who` AS `who`,count(`longdescs`.`comment_id`) AS `count_messages` from `longdescs` group by `longdescs`.`who`,year(`longdescs`.`bug_when`),month(`longdescs`.`bug_when`) order by year(`longdescs`.`bug_when`) desc,month(`longdescs`.`bug_when`) desc,count(`longdescs`.`comment_id`) desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_messages_per_users_per_week`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_messages_per_users_per_week` AS select year(`longdescs`.`bug_when`) AS `year`,month(`longdescs`.`bug_when`) AS `month`,week(`longdescs`.`bug_when`,0) AS `week`,`longdescs`.`who` AS `who`,count(`longdescs`.`comment_id`) AS `count_messages` from `longdescs` group by `longdescs`.`who`,year(`longdescs`.`bug_when`),month(`longdescs`.`bug_when`),week(`longdescs`.`bug_when`,0) order by year(`longdescs`.`bug_when`) desc,month(`longdescs`.`bug_when`) desc,week(`longdescs`.`bug_when`,0) desc,count(`longdescs`.`comment_id`) descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_messages_per_users_per_week` AS select year(`longdescs`.`bug_when`) AS `year`,month(`longdescs`.`bug_when`) AS `month`,week(`longdescs`.`bug_when`,0) AS `week`,`longdescs`.`who` AS `who`,count(`longdescs`.`comment_id`) AS `count_messages` from `longdescs` group by `longdescs`.`who`,year(`longdescs`.`bug_when`),month(`longdescs`.`bug_when`),week(`longdescs`.`bug_when`,0) order by year(`longdescs`.`bug_when`) desc,month(`longdescs`.`bug_when`) desc,week(`longdescs`.`bug_when`,0) desc,count(`longdescs`.`comment_id`) desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_new_cases_created_per_month`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_new_cases_created_per_month` AS select year(`bugs`.`creation_ts`) AS `year`,month(`bugs`.`creation_ts`) AS `month`,count(`bugs`.`bug_id`) AS `count_cases` from `bugs` group by year(`bugs`.`creation_ts`),month(`bugs`.`creation_ts`) order by `bugs`.`creation_ts` desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_new_cases_created_per_week`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_new_cases_created_per_week` AS select year(`bugs`.`creation_ts`) AS `year`,month(`bugs`.`creation_ts`) AS `month`,week(`bugs`.`creation_ts`,0) AS `week`,count(`bugs`.`bug_id`) AS `count_cases_created` from `bugs` group by year(`bugs`.`creation_ts`),month(`bugs`.`creation_ts`),week(`bugs`.`creation_ts`,0) order by `bugs`.`creation_ts` desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_new_geographies_created_per_month`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_new_geographies_created_per_month` AS select year(`audit_log`.`at_time`) AS `year`,month(`audit_log`.`at_time`) AS `month`,count(`audit_log`.`object_id`) AS `new_geography` from `audit_log` where ((`audit_log`.`class` = 'Bugzilla::Classification') and (`audit_log`.`field` = '__create__')) group by year(`audit_log`.`at_time`),month(`audit_log`.`at_time`) order by `audit_log`.`at_time` descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_new_geographies_created_per_month` AS select year(`audit_log`.`at_time`) AS `year`,month(`audit_log`.`at_time`) AS `month`,count(`audit_log`.`object_id`) AS `new_geography` from `audit_log` where ((`audit_log`.`class` = 'Bugzilla::Classification') and (`audit_log`.`field` = '__create__')) group by year(`audit_log`.`at_time`),month(`audit_log`.`at_time`) order by `audit_log`.`at_time` desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_new_messages_created_per_month`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_new_messages_created_per_month` AS select year(`longdescs`.`bug_when`) AS `year`,month(`longdescs`.`bug_when`) AS `month`,count(`longdescs`.`comment_id`) AS `count_messages_created` from `longdescs` group by year(`longdescs`.`bug_when`),month(`longdescs`.`bug_when`) order by year(`longdescs`.`bug_when`) desc,month(`longdescs`.`bug_when`) descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_new_messages_created_per_month` AS select year(`longdescs`.`bug_when`) AS `year`,month(`longdescs`.`bug_when`) AS `month`,count(`longdescs`.`comment_id`) AS `count_messages_created` from `longdescs` group by year(`longdescs`.`bug_when`),month(`longdescs`.`bug_when`) order by year(`longdescs`.`bug_when`) desc,month(`longdescs`.`bug_when`) desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_new_messages_created_per_week`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_new_messages_created_per_week` AS select year(`longdescs`.`bug_when`) AS `year`,month(`longdescs`.`bug_when`) AS `month`,week(`longdescs`.`bug_when`,0) AS `week`,count(`longdescs`.`comment_id`) AS `count_messages_created` from `longdescs` group by year(`longdescs`.`bug_when`),month(`longdescs`.`bug_when`),week(`longdescs`.`bug_when`,0) order by year(`longdescs`.`bug_when`) desc,month(`longdescs`.`bug_when`) desc,week(`longdescs`.`bug_when`,0) descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_new_messages_created_per_week` AS select year(`longdescs`.`bug_when`) AS `year`,month(`longdescs`.`bug_when`) AS `month`,week(`longdescs`.`bug_when`,0) AS `week`,count(`longdescs`.`comment_id`) AS `count_messages_created` from `longdescs` group by year(`longdescs`.`bug_when`),month(`longdescs`.`bug_when`),week(`longdescs`.`bug_when`,0) order by year(`longdescs`.`bug_when`) desc,month(`longdescs`.`bug_when`) desc,week(`longdescs`.`bug_when`,0) desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_new_unit_created_per_month`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_new_unit_created_per_month` AS select year(`audit_log`.`at_time`) AS `year`,month(`audit_log`.`at_time`) AS `month`,count(`audit_log`.`object_id`) AS `new_unit` from `audit_log` where ((`audit_log`.`class` = 'Bugzilla::Product') and (`audit_log`.`field` = '__create__')) group by year(`audit_log`.`at_time`),month(`audit_log`.`at_time`) order by `audit_log`.`at_time` descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_new_unit_created_per_month` AS select year(`audit_log`.`at_time`) AS `year`,month(`audit_log`.`at_time`) AS `month`,count(`audit_log`.`object_id`) AS `new_unit` from `audit_log` where ((`audit_log`.`class` = 'Bugzilla::Product') and (`audit_log`.`field` = '__create__')) group by year(`audit_log`.`at_time`),month(`audit_log`.`at_time`) order by `audit_log`.`at_time` desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_new_unit_created_per_week`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_new_unit_created_per_week` AS select year(`audit_log`.`at_time`) AS `year`,month(`audit_log`.`at_time`) AS `month`,week(`audit_log`.`at_time`,0) AS `week`,count(`audit_log`.`object_id`) AS `count_new_units` from `audit_log` where ((`audit_log`.`class` = 'Bugzilla::Product') and (`audit_log`.`field` = '__create__')) group by year(`audit_log`.`at_time`),month(`audit_log`.`at_time`),week(`audit_log`.`at_time`,0) order by year(`audit_log`.`at_time`) desc,month(`audit_log`.`at_time`) desc,week(`audit_log`.`at_time`,0) desc,count(`audit_log`.`object_id`) descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_new_unit_created_per_week` AS select year(`audit_log`.`at_time`) AS `year`,month(`audit_log`.`at_time`) AS `month`,week(`audit_log`.`at_time`,0) AS `week`,count(`audit_log`.`object_id`) AS `count_new_units` from `audit_log` where ((`audit_log`.`class` = 'Bugzilla::Product') and (`audit_log`.`field` = '__create__')) group by year(`audit_log`.`at_time`),month(`audit_log`.`at_time`),week(`audit_log`.`at_time`,0) order by year(`audit_log`.`at_time`) desc,month(`audit_log`.`at_time`) desc,week(`audit_log`.`at_time`,0) desc,count(`audit_log`.`object_id`) desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_new_user_created_per_month`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_new_user_created_per_month` AS select year(`audit_log`.`at_time`) AS `year`,month(`audit_log`.`at_time`) AS `month`,count(`audit_log`.`object_id`) AS `new_users` from `audit_log` where ((`audit_log`.`class` = 'Bugzilla::User') and (`audit_log`.`field` = '__create__')) group by year(`audit_log`.`at_time`),month(`audit_log`.`at_time`) order by `audit_log`.`at_time` descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_new_user_created_per_month` AS select year(`audit_log`.`at_time`) AS `year`,month(`audit_log`.`at_time`) AS `month`,count(`audit_log`.`object_id`) AS `new_users` from `audit_log` where ((`audit_log`.`class` = 'Bugzilla::User') and (`audit_log`.`field` = '__create__')) group by year(`audit_log`.`at_time`),month(`audit_log`.`at_time`) order by `audit_log`.`at_time` desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_new_user_created_per_week`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_new_user_created_per_week` AS select year(`audit_log`.`at_time`) AS `year`,month(`audit_log`.`at_time`) AS `month`,week(`audit_log`.`at_time`,0) AS `week`,count(`audit_log`.`object_id`) AS `new_users` from `audit_log` where ((`audit_log`.`class` = 'Bugzilla::User') and (`audit_log`.`field` = '__create__')) group by year(`audit_log`.`at_time`),week(`audit_log`.`at_time`,0) order by year(`audit_log`.`at_time`) desc,month(`audit_log`.`at_time`) desc,week(`audit_log`.`at_time`,0) descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_new_user_created_per_week` AS select year(`audit_log`.`at_time`) AS `year`,month(`audit_log`.`at_time`) AS `month`,week(`audit_log`.`at_time`,0) AS `week`,count(`audit_log`.`object_id`) AS `new_users` from `audit_log` where ((`audit_log`.`class` = 'Bugzilla::User') and (`audit_log`.`field` = '__create__')) group by year(`audit_log`.`at_time`),week(`audit_log`.`at_time`,0) order by year(`audit_log`.`at_time`) desc,month(`audit_log`.`at_time`) desc,week(`audit_log`.`at_time`,0) desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_unit_created_per_users_per_month`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_unit_created_per_users_per_month` AS select year(`audit_log`.`at_time`) AS `year`,month(`audit_log`.`at_time`) AS `month`,`audit_log`.`user_id` AS `user_id`,count(`audit_log`.`object_id`) AS `count_new_units` from `audit_log` where ((`audit_log`.`class` = 'Bugzilla::Product') and (`audit_log`.`field` = '__create__')) group by `audit_log`.`user_id`,year(`audit_log`.`at_time`),month(`audit_log`.`at_time`) order by year(`audit_log`.`at_time`) desc,month(`audit_log`.`at_time`) desc,count(`audit_log`.`object_id`) descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_unit_created_per_users_per_month` AS select year(`audit_log`.`at_time`) AS `year`,month(`audit_log`.`at_time`) AS `month`,`audit_log`.`user_id` AS `user_id`,count(`audit_log`.`object_id`) AS `count_new_units` from `audit_log` where ((`audit_log`.`class` = 'Bugzilla::Product') and (`audit_log`.`field` = '__create__')) group by `audit_log`.`user_id`,year(`audit_log`.`at_time`),month(`audit_log`.`at_time`) order by year(`audit_log`.`at_time`) desc,month(`audit_log`.`at_time`) desc,count(`audit_log`.`object_id`) desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_unit_created_per_users_per_week`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_unit_created_per_users_per_week` AS select year(`audit_log`.`at_time`) AS `year`,month(`audit_log`.`at_time`) AS `month`,week(`audit_log`.`at_time`,0) AS `week`,`audit_log`.`user_id` AS `user_id`,count(`audit_log`.`object_id`) AS `count_new_units` from `audit_log` where ((`audit_log`.`class` = 'Bugzilla::Product') and (`audit_log`.`field` = '__create__')) group by `audit_log`.`user_id`,year(`audit_log`.`at_time`),month(`audit_log`.`at_time`),week(`audit_log`.`at_time`,0) order by year(`audit_log`.`at_time`) desc,month(`audit_log`.`at_time`) desc,week(`audit_log`.`at_time`,0) desc,count(`audit_log`.`object_id`) descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_unit_created_per_users_per_week` AS select year(`audit_log`.`at_time`) AS `year`,month(`audit_log`.`at_time`) AS `month`,week(`audit_log`.`at_time`,0) AS `week`,`audit_log`.`user_id` AS `user_id`,count(`audit_log`.`object_id`) AS `count_new_units` from `audit_log` where ((`audit_log`.`class` = 'Bugzilla::Product') and (`audit_log`.`field` = '__create__')) group by `audit_log`.`user_id`,year(`audit_log`.`at_time`),month(`audit_log`.`at_time`),week(`audit_log`.`at_time`,0) order by year(`audit_log`.`at_time`) desc,month(`audit_log`.`at_time`) desc,week(`audit_log`.`at_time`,0) desc,count(`audit_log`.`object_id`) desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_units_enabled_and_total_per_month`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_units_enabled_and_total_per_month` AS select year(`ut_log_count_enabled_units`.`timestamp`) AS `year`,month(`ut_log_count_enabled_units`.`timestamp`) AS `month`,avg(`ut_log_count_enabled_units`.`count_enabled_units`) AS `average_enabled_units`,avg(`ut_log_count_enabled_units`.`count_total_units`) AS `average_total_units` from `ut_log_count_enabled_units` group by year(`ut_log_count_enabled_units`.`timestamp`),month(`ut_log_count_enabled_units`.`timestamp`) order by year(`ut_log_count_enabled_units`.`timestamp`) desc,month(`ut_log_count_enabled_units`.`timestamp`) descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_units_enabled_and_total_per_month` AS select year(`ut_log_count_enabled_units`.`timestamp`) AS `year`,month(`ut_log_count_enabled_units`.`timestamp`) AS `month`,avg(`ut_log_count_enabled_units`.`count_enabled_units`) AS `average_enabled_units`,avg(`ut_log_count_enabled_units`.`count_total_units`) AS `average_total_units` from `ut_log_count_enabled_units` group by year(`ut_log_count_enabled_units`.`timestamp`),month(`ut_log_count_enabled_units`.`timestamp`) order by year(`ut_log_count_enabled_units`.`timestamp`) desc,month(`ut_log_count_enabled_units`.`timestamp`) desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_units_enabled_and_total_per_week`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_units_enabled_and_total_per_week` AS select year(`ut_log_count_enabled_units`.`timestamp`) AS `year`,month(`ut_log_count_enabled_units`.`timestamp`) AS `month`,week(`ut_log_count_enabled_units`.`timestamp`,0) AS `week`,avg(`ut_log_count_enabled_units`.`count_enabled_units`) AS `average_enabled_units`,avg(`ut_log_count_enabled_units`.`count_total_units`) AS `average_total_units` from `ut_log_count_enabled_units` group by year(`ut_log_count_enabled_units`.`timestamp`),month(`ut_log_count_enabled_units`.`timestamp`),week(`ut_log_count_enabled_units`.`timestamp`,0) order by year(`ut_log_count_enabled_units`.`timestamp`) desc,week(`ut_log_count_enabled_units`.`timestamp`,0) descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_units_enabled_and_total_per_week` AS select year(`ut_log_count_enabled_units`.`timestamp`) AS `year`,month(`ut_log_count_enabled_units`.`timestamp`) AS `month`,week(`ut_log_count_enabled_units`.`timestamp`,0) AS `week`,avg(`ut_log_count_enabled_units`.`count_enabled_units`) AS `average_enabled_units`,avg(`ut_log_count_enabled_units`.`count_total_units`) AS `average_total_units` from `ut_log_count_enabled_units` group by year(`ut_log_count_enabled_units`.`timestamp`),month(`ut_log_count_enabled_units`.`timestamp`),week(`ut_log_count_enabled_units`.`timestamp`,0) order by year(`ut_log_count_enabled_units`.`timestamp`) desc,week(`ut_log_count_enabled_units`.`timestamp`,0) desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_units_with_invitation_sent_per_month`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_units_with_invitation_sent_per_month` AS select `count_invitation_sent_per_unit_per_month`.`year` AS `year`,`count_invitation_sent_per_unit_per_month`.`month` AS `month`,count(`count_invitation_sent_per_unit_per_month`.`bz_unit_id`) AS `count_units` from `count_invitation_sent_per_unit_per_month` group by `count_invitation_sent_per_unit_per_month`.`month`,`count_invitation_sent_per_unit_per_month`.`year` order by `count_invitation_sent_per_unit_per_month`.`year` desc,`count_invitation_sent_per_unit_per_month`.`month` descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_units_with_invitation_sent_per_month` AS select `count_invitation_sent_per_unit_per_month`.`year` AS `year`,`count_invitation_sent_per_unit_per_month`.`month` AS `month`,count(`count_invitation_sent_per_unit_per_month`.`bz_unit_id`) AS `count_units` from `count_invitation_sent_per_unit_per_month` group by `count_invitation_sent_per_unit_per_month`.`month`,`count_invitation_sent_per_unit_per_month`.`year` order by `count_invitation_sent_per_unit_per_month`.`year` desc,`count_invitation_sent_per_unit_per_month`.`month` desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_units_with_invitation_sent_per_week`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_units_with_invitation_sent_per_week` AS select `count_invitation_sent_per_unit_per_week`.`year` AS `year`,`count_invitation_sent_per_unit_per_week`.`month` AS `month`,`count_invitation_sent_per_unit_per_week`.`week` AS `week`,count(`count_invitation_sent_per_unit_per_week`.`bz_unit_id`) AS `count_units` from `count_invitation_sent_per_unit_per_week` group by `count_invitation_sent_per_unit_per_week`.`year`,`count_invitation_sent_per_unit_per_week`.`month`,`count_invitation_sent_per_unit_per_week`.`week` order by `count_invitation_sent_per_unit_per_week`.`year` desc,`count_invitation_sent_per_unit_per_week`.`month` desc,`count_invitation_sent_per_unit_per_week`.`week` descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_units_with_invitation_sent_per_week` AS select `count_invitation_sent_per_unit_per_week`.`year` AS `year`,`count_invitation_sent_per_unit_per_week`.`month` AS `month`,`count_invitation_sent_per_unit_per_week`.`week` AS `week`,count(`count_invitation_sent_per_unit_per_week`.`bz_unit_id`) AS `count_units` from `count_invitation_sent_per_unit_per_week` group by `count_invitation_sent_per_unit_per_week`.`year`,`count_invitation_sent_per_unit_per_week`.`month`,`count_invitation_sent_per_unit_per_week`.`week` order by `count_invitation_sent_per_unit_per_week`.`year` desc,`count_invitation_sent_per_unit_per_week`.`month` desc,`count_invitation_sent_per_unit_per_week`.`week` desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_units_with_messages_per_month`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_units_with_messages_per_month` AS select `count_messages_per_unit_per_month`.`year` AS `year`,`count_messages_per_unit_per_month`.`month` AS `month`,count(`count_messages_per_unit_per_month`.`bz_unit_id`) AS `count_units_with_messages` from `count_messages_per_unit_per_month` group by `count_messages_per_unit_per_month`.`month`,`count_messages_per_unit_per_month`.`year` order by `count_messages_per_unit_per_month`.`year` desc,`count_messages_per_unit_per_month`.`month` descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_units_with_messages_per_month` AS select `count_messages_per_unit_per_month`.`year` AS `year`,`count_messages_per_unit_per_month`.`month` AS `month`,count(`count_messages_per_unit_per_month`.`bz_unit_id`) AS `count_units_with_messages` from `count_messages_per_unit_per_month` group by `count_messages_per_unit_per_month`.`month`,`count_messages_per_unit_per_month`.`year` order by `count_messages_per_unit_per_month`.`year` desc,`count_messages_per_unit_per_month`.`month` desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_units_with_messages_per_week`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_units_with_messages_per_week` AS select `count_messages_per_unit_per_week`.`year` AS `year`,`count_messages_per_unit_per_week`.`month` AS `month`,`count_messages_per_unit_per_week`.`week` AS `week`,count(`count_messages_per_unit_per_week`.`bz_unit_id`) AS `count_units_with_messages` from `count_messages_per_unit_per_week` group by `count_messages_per_unit_per_week`.`year`,`count_messages_per_unit_per_week`.`month`,`count_messages_per_unit_per_week`.`week` order by `count_messages_per_unit_per_week`.`year` desc,`count_messages_per_unit_per_week`.`week` descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_units_with_messages_per_week` AS select `count_messages_per_unit_per_week`.`year` AS `year`,`count_messages_per_unit_per_week`.`month` AS `month`,`count_messages_per_unit_per_week`.`week` AS `week`,count(`count_messages_per_unit_per_week`.`bz_unit_id`) AS `count_units_with_messages` from `count_messages_per_unit_per_week` group by `count_messages_per_unit_per_week`.`year`,`count_messages_per_unit_per_week`.`month`,`count_messages_per_unit_per_week`.`week` order by `count_messages_per_unit_per_week`.`year` desc,`count_messages_per_unit_per_week`.`week` desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_users_who_create_case_per_month`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_users_who_create_case_per_month` AS select `count_cases_per_users_per_month`.`year` AS `year`,`count_cases_per_users_per_month`.`month` AS `month`,count(`count_cases_per_users_per_month`.`reporter`) AS `count_users_who_create_case` from `count_cases_per_users_per_month` group by `count_cases_per_users_per_month`.`year`,`count_cases_per_users_per_month`.`month` order by `count_cases_per_users_per_month`.`year` desc,`count_cases_per_users_per_month`.`month` descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_users_who_create_case_per_month` AS select `count_cases_per_users_per_month`.`year` AS `year`,`count_cases_per_users_per_month`.`month` AS `month`,count(`count_cases_per_users_per_month`.`reporter`) AS `count_users_who_create_case` from `count_cases_per_users_per_month` group by `count_cases_per_users_per_month`.`year`,`count_cases_per_users_per_month`.`month` order by `count_cases_per_users_per_month`.`year` desc,`count_cases_per_users_per_month`.`month` desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_users_who_create_case_per_week`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_users_who_create_case_per_week` AS select `count_cases_per_users_per_week`.`year` AS `year`,`count_cases_per_users_per_week`.`month` AS `month`,`count_cases_per_users_per_week`.`week` AS `week`,count(`count_cases_per_users_per_week`.`reporter`) AS `count_users_who_create_case` from `count_cases_per_users_per_week` group by `count_cases_per_users_per_week`.`year`,`count_cases_per_users_per_week`.`month`,`count_cases_per_users_per_week`.`week` order by `count_cases_per_users_per_week`.`year` desc,`count_cases_per_users_per_week`.`week` descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_users_who_create_case_per_week` AS select `count_cases_per_users_per_week`.`year` AS `year`,`count_cases_per_users_per_week`.`month` AS `month`,`count_cases_per_users_per_week`.`week` AS `week`,count(`count_cases_per_users_per_week`.`reporter`) AS `count_users_who_create_case` from `count_cases_per_users_per_week` group by `count_cases_per_users_per_week`.`year`,`count_cases_per_users_per_week`.`month`,`count_cases_per_users_per_week`.`week` order by `count_cases_per_users_per_week`.`year` desc,`count_cases_per_users_per_week`.`week` desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_users_who_create_invites_per_month`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_users_who_create_invites_per_month` AS select `count_invites_per_user_per_week`.`year` AS `year`,`count_invites_per_user_per_week`.`month` AS `month`,count(`count_invites_per_user_per_week`.`invitor`) AS `count_users_who_created_invites` from `count_invites_per_user_per_week` group by `count_invites_per_user_per_week`.`year`,`count_invites_per_user_per_week`.`month` order by `count_invites_per_user_per_week`.`year` desc,`count_invites_per_user_per_week`.`month` descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_users_who_create_invites_per_month` AS select `count_invites_per_user_per_week`.`year` AS `year`,`count_invites_per_user_per_week`.`month` AS `month`,count(`count_invites_per_user_per_week`.`invitor`) AS `count_users_who_created_invites` from `count_invites_per_user_per_week` group by `count_invites_per_user_per_week`.`year`,`count_invites_per_user_per_week`.`month` order by `count_invites_per_user_per_week`.`year` desc,`count_invites_per_user_per_week`.`month` desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_users_who_create_invites_per_week`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_users_who_create_invites_per_week` AS select `count_invites_per_user_per_week`.`year` AS `year`,`count_invites_per_user_per_week`.`month` AS `month`,`count_invites_per_user_per_week`.`week` AS `week`,count(`count_invites_per_user_per_week`.`invitor`) AS `count_users_who_created_invites` from `count_invites_per_user_per_week` group by `count_invites_per_user_per_week`.`year`,`count_invites_per_user_per_week`.`month`,`count_invites_per_user_per_week`.`week` order by `count_invites_per_user_per_week`.`year` desc,`count_invites_per_user_per_week`.`week` descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_users_who_create_invites_per_week` AS select `count_invites_per_user_per_week`.`year` AS `year`,`count_invites_per_user_per_week`.`month` AS `month`,`count_invites_per_user_per_week`.`week` AS `week`,count(`count_invites_per_user_per_week`.`invitor`) AS `count_users_who_created_invites` from `count_invites_per_user_per_week` group by `count_invites_per_user_per_week`.`year`,`count_invites_per_user_per_week`.`month`,`count_invites_per_user_per_week`.`week` order by `count_invites_per_user_per_week`.`year` desc,`count_invites_per_user_per_week`.`week` desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_users_who_create_units_per_month`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_users_who_create_units_per_month` AS select `count_unit_created_per_users_per_month`.`year` AS `year`,`count_unit_created_per_users_per_month`.`month` AS `month`,count(`count_unit_created_per_users_per_month`.`user_id`) AS `count_users_who_created_units` from `count_unit_created_per_users_per_month` group by `count_unit_created_per_users_per_month`.`year`,`count_unit_created_per_users_per_month`.`month` order by `count_unit_created_per_users_per_month`.`year` desc,`count_unit_created_per_users_per_month`.`month` descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_users_who_create_units_per_month` AS select `count_unit_created_per_users_per_month`.`year` AS `year`,`count_unit_created_per_users_per_month`.`month` AS `month`,count(`count_unit_created_per_users_per_month`.`user_id`) AS `count_users_who_created_units` from `count_unit_created_per_users_per_month` group by `count_unit_created_per_users_per_month`.`year`,`count_unit_created_per_users_per_month`.`month` order by `count_unit_created_per_users_per_month`.`year` desc,`count_unit_created_per_users_per_month`.`month` desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_users_who_create_units_per_week`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_users_who_create_units_per_week` AS select `count_unit_created_per_users_per_week`.`year` AS `year`,`count_unit_created_per_users_per_week`.`month` AS `month`,`count_unit_created_per_users_per_week`.`week` AS `week`,count(`count_unit_created_per_users_per_week`.`user_id`) AS `count_users_who_created_units` from `count_unit_created_per_users_per_week` group by `count_unit_created_per_users_per_week`.`year`,`count_unit_created_per_users_per_week`.`month`,`count_unit_created_per_users_per_week`.`week` order by `count_unit_created_per_users_per_week`.`year` desc,`count_unit_created_per_users_per_week`.`week` descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_users_who_create_units_per_week` AS select `count_unit_created_per_users_per_week`.`year` AS `year`,`count_unit_created_per_users_per_week`.`month` AS `month`,`count_unit_created_per_users_per_week`.`week` AS `week`,count(`count_unit_created_per_users_per_week`.`user_id`) AS `count_users_who_created_units` from `count_unit_created_per_users_per_week` group by `count_unit_created_per_users_per_week`.`year`,`count_unit_created_per_users_per_week`.`month`,`count_unit_created_per_users_per_week`.`week` order by `count_unit_created_per_users_per_week`.`year` desc,`count_unit_created_per_users_per_week`.`week` desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_users_who_invited_someone_per_month`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_users_who_invited_someone_per_month` AS select `count_invitation_per_invitor_per_month`.`year` AS `year`,`count_invitation_per_invitor_per_month`.`month` AS `month`,count(`count_invitation_per_invitor_per_month`.`invitor_bz_user_id`) AS `count_invitors` from `count_invitation_per_invitor_per_month` group by `count_invitation_per_invitor_per_month`.`year`,`count_invitation_per_invitor_per_month`.`month` order by `count_invitation_per_invitor_per_month`.`year` desc,`count_invitation_per_invitor_per_month`.`month` descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_users_who_invited_someone_per_month` AS select `count_invitation_per_invitor_per_month`.`year` AS `year`,`count_invitation_per_invitor_per_month`.`month` AS `month`,count(`count_invitation_per_invitor_per_month`.`invitor_bz_user_id`) AS `count_invitors` from `count_invitation_per_invitor_per_month` group by `count_invitation_per_invitor_per_month`.`year`,`count_invitation_per_invitor_per_month`.`month` order by `count_invitation_per_invitor_per_month`.`year` desc,`count_invitation_per_invitor_per_month`.`month` desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_users_who_invited_someone_per_week`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_users_who_invited_someone_per_week` AS select `count_invitation_per_invitor_per_week`.`year` AS `year`,`count_invitation_per_invitor_per_week`.`month` AS `month`,`count_invitation_per_invitor_per_week`.`week` AS `week`,count(`count_invitation_per_invitor_per_week`.`invitor_bz_user_id`) AS `count_invitors` from `count_invitation_per_invitor_per_week` group by `count_invitation_per_invitor_per_week`.`year`,`count_invitation_per_invitor_per_week`.`month`,`count_invitation_per_invitor_per_week`.`week` order by `count_invitation_per_invitor_per_week`.`year` desc,`count_invitation_per_invitor_per_week`.`week` descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_users_who_invited_someone_per_week` AS select `count_invitation_per_invitor_per_week`.`year` AS `year`,`count_invitation_per_invitor_per_week`.`month` AS `month`,`count_invitation_per_invitor_per_week`.`week` AS `week`,count(`count_invitation_per_invitor_per_week`.`invitor_bz_user_id`) AS `count_invitors` from `count_invitation_per_invitor_per_week` group by `count_invitation_per_invitor_per_week`.`year`,`count_invitation_per_invitor_per_week`.`month`,`count_invitation_per_invitor_per_week`.`week` order by `count_invitation_per_invitor_per_week`.`year` desc,`count_invitation_per_invitor_per_week`.`week` desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_users_who_sent_message_per_month`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_users_who_sent_message_per_month` AS select `count_messages_per_users_per_month`.`year` AS `year`,`count_messages_per_users_per_month`.`month` AS `month`,count(`count_messages_per_users_per_month`.`who`) AS `count_users_who_sent_messages` from `count_messages_per_users_per_month` group by `count_messages_per_users_per_month`.`year`,`count_messages_per_users_per_month`.`month` order by `count_messages_per_users_per_month`.`year` desc,`count_messages_per_users_per_month`.`month` descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_users_who_sent_message_per_month` AS select `count_messages_per_users_per_month`.`year` AS `year`,`count_messages_per_users_per_month`.`month` AS `month`,count(`count_messages_per_users_per_month`.`who`) AS `count_users_who_sent_messages` from `count_messages_per_users_per_month` group by `count_messages_per_users_per_month`.`year`,`count_messages_per_users_per_month`.`month` order by `count_messages_per_users_per_month`.`year` desc,`count_messages_per_users_per_month`.`month` desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_users_who_sent_message_per_week`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_users_who_sent_message_per_week` AS select `count_messages_per_users_per_week`.`year` AS `year`,`count_messages_per_users_per_week`.`month` AS `month`,`count_messages_per_users_per_week`.`week` AS `week`,count(`count_messages_per_users_per_week`.`who`) AS `count_users_who_sent_messages` from `count_messages_per_users_per_week` group by `count_messages_per_users_per_week`.`year`,`count_messages_per_users_per_week`.`month`,`count_messages_per_users_per_week`.`week` order by `count_messages_per_users_per_week`.`year` desc,`count_messages_per_users_per_week`.`week` descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_users_who_sent_message_per_week` AS select `count_messages_per_users_per_week`.`year` AS `year`,`count_messages_per_users_per_week`.`month` AS `month`,`count_messages_per_users_per_week`.`week` AS `week`,count(`count_messages_per_users_per_week`.`who`) AS `count_users_who_sent_messages` from `count_messages_per_users_per_week` group by `count_messages_per_users_per_week`.`year`,`count_messages_per_users_per_week`.`month`,`count_messages_per_users_per_week`.`week` order by `count_messages_per_users_per_week`.`year` desc,`count_messages_per_users_per_week`.`week` desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_users_who_were_invited_per_month`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_users_who_were_invited_per_month` AS select `count_invitation_per_invitee_per_month`.`year` AS `year`,`count_invitation_per_invitee_per_month`.`month` AS `month`,count(`count_invitation_per_invitee_per_month`.`invitee_bz_user_id`) AS `count_invitees` from `count_invitation_per_invitee_per_month` group by `count_invitation_per_invitee_per_month`.`year`,`count_invitation_per_invitee_per_month`.`month` order by `count_invitation_per_invitee_per_month`.`year` desc,`count_invitation_per_invitee_per_month`.`month` descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_users_who_were_invited_per_month` AS select `count_invitation_per_invitee_per_month`.`year` AS `year`,`count_invitation_per_invitee_per_month`.`month` AS `month`,count(`count_invitation_per_invitee_per_month`.`invitee_bz_user_id`) AS `count_invitees` from `count_invitation_per_invitee_per_month` group by `count_invitation_per_invitee_per_month`.`year`,`count_invitation_per_invitee_per_month`.`month` order by `count_invitation_per_invitee_per_month`.`year` desc,`count_invitation_per_invitee_per_month`.`month` desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `count_users_who_were_invited_per_week`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_users_who_were_invited_per_week` AS select `count_invitation_per_invitee_per_week`.`year` AS `year`,`count_invitation_per_invitee_per_week`.`month` AS `month`,`count_invitation_per_invitee_per_week`.`week` AS `week`,count(`count_invitation_per_invitee_per_week`.`invitee_bz_user_id`) AS `count_invitees` from `count_invitation_per_invitee_per_week` group by `count_invitation_per_invitee_per_week`.`year`,`count_invitation_per_invitee_per_week`.`month`,`count_invitation_per_invitee_per_week`.`week` order by `count_invitation_per_invitee_per_week`.`year` desc,`count_invitation_per_invitee_per_week`.`week` descCREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `count_users_who_were_invited_per_week` AS select `count_invitation_per_invitee_per_week`.`year` AS `year`,`count_invitation_per_invitee_per_week`.`month` AS `month`,`count_invitation_per_invitee_per_week`.`week` AS `week`,count(`count_invitation_per_invitee_per_week`.`invitee_bz_user_id`) AS `count_invitees` from `count_invitation_per_invitee_per_week` group by `count_invitation_per_invitee_per_week`.`year`,`count_invitation_per_invitee_per_week`.`month`,`count_invitation_per_invitee_per_week`.`week` order by `count_invitation_per_invitee_per_week`.`year` desc,`count_invitation_per_invitee_per_week`.`week` desc$$
DELIMITER ;

 DROP TABLE IF EXISTS `flash_count_units_with_real_roles`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `flash_count_units_with_real_roles` AS select `list_components_with_real_default_assignee`.`role_type_id` AS `role_type_id`,count(`list_components_with_real_default_assignee`.`product_id`) AS `units_with_real_users`,`list_components_with_real_default_assignee`.`isactive` AS `isactive` from `list_components_with_real_default_assignee` group by `list_components_with_real_default_assignee`.`role_type_id`,`list_components_with_real_default_assignee`.`isactive` order by `list_components_with_real_default_assignee`.`isactive` desc,`list_components_with_real_default_assignee`.`role_type_id`$$
DELIMITER ;

 DROP TABLE IF EXISTS `flash_count_user_per_role_per_unit`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `flash_count_user_per_role_per_unit` AS select `ut_product_group`.`product_id` AS `product_id`,`ut_product_group`.`role_type_id` AS `role_type_id`,count(`profiles`.`userid`) AS `count_users` from ((`user_group_map` join `profiles` on((`user_group_map`.`user_id` = `profiles`.`userid`))) join `ut_product_group` on((`user_group_map`.`group_id` = `ut_product_group`.`group_id`))) where ((`ut_product_group`.`role_type_id` is not null) and (`ut_product_group`.`group_type_id` = 2) and (`user_group_map`.`isbless` = 0)) group by `ut_product_group`.`product_id`,`ut_product_group`.`role_type_id`,`user_group_map`.`group_id`$$
DELIMITER ;

 DROP TABLE IF EXISTS `list_all_changes_to_components_default_assignee_dummy_users`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `list_all_changes_to_components_default_assignee_dummy_users` AS select `audit_log`.`class` AS `class`,`audit_log`.`removed` AS `removed`,if((`audit_log`.`removed` = 93), 'replace_dummy_tenant',if((`audit_log`.`removed` = 91), 'replace_dummy_landlord',if((`audit_log`.`removed` = 90), 'replace_dummy_contractor',if((`audit_log`.`removed` = 92), 'replace_dummy_mgt_cny',if((`audit_log`.`removed` = 89), 'replace_dummy_agent', 'dummy_user_not_removed'))))) AS `action_remove`,`audit_log`.`added` AS `added`,if((`audit_log`.`added` = 92), 'use_dummy_tenant',if((`audit_log`.`added` = 91), 'use_dummy_landlord',if((`audit_log`.`added` = 90), 'use_dummy_contractor',if((`audit_log`.`added` = 92), 'use_dummy_mgt_cny',if((`audit_log`.`added` = 89), 'use_dummy_agent', 'dummy_user_not_added'))))) AS `action_add`,`audit_log`.`object_id` AS `component_id`,`audit_log`.`at_time` AS `at_time` from `audit_log` where (((`audit_log`.`class` = 'Bugzilla::Component') and (`audit_log`.`field` = 'initialowner') and (`audit_log`.`removed` = 92)) or ((`audit_log`.`class` = 'Bugzilla::Component') and (`audit_log`.`field` = 'initialowner') and (`audit_log`.`removed` = 91)) or ((`audit_log`.`class` = 'Bugzilla::Component') and (`audit_log`.`field` = 'initialowner') and (`audit_log`.`removed` = 90)) or ((`audit_log`.`class` = 'Bugzilla::Component') and (`audit_log`.`field` = 'initialowner') and (`audit_log`.`removed` = 92)) or ((`audit_log`.`class` = 'Bugzilla::Component') and (`audit_log`.`field` = 'initialowner') and (`audit_log`.`removed` = 89)) or ((`audit_log`.`class` = 'Bugzilla::Component') and (`audit_log`.`field` = 'initialowner') and (`audit_log`.`added` = 92)) or ((`audit_log`.`class` = 'Bugzilla::Component') and (`audit_log`.`field` = 'initialowner') and (`audit_log`.`added` = 91)) or ((`audit_log`.`class` = 'Bugzilla::Component') and (`audit_log`.`field` = 'initialowner') and (`audit_log`.`added` = 90)) or ((`audit_log`.`class` = 'Bugzilla::Component') and (`audit_log`.`field` = 'initialowner') and (`audit_log`.`added` = 92)) or ((`audit_log`.`class` = 'Bugzilla::Component') and (`audit_log`.`field` = 'initialowner') and (`audit_log`.`added` = 89)))CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `list_all_changes_to_components_default_assignee_dummy_users` AS select `audit_log`.`class` AS `class`,`audit_log`.`removed` AS `removed`,if((`audit_log`.`removed` = 93), 'replace_dummy_tenant',if((`audit_log`.`removed` = 91), 'replace_dummy_landlord',if((`audit_log`.`removed` = 90), 'replace_dummy_contractor',if((`audit_log`.`removed` = 92), 'replace_dummy_mgt_cny',if((`audit_log`.`removed` = 89), 'replace_dummy_agent', 'dummy_user_not_removed'))))) AS `action_remove`,`audit_log`.`added` AS `added`,if((`audit_log`.`added` = 92), 'use_dummy_tenant',if((`audit_log`.`added` = 91), 'use_dummy_landlord',if((`audit_log`.`added` = 90), 'use_dummy_contractor',if((`audit_log`.`added` = 92), 'use_dummy_mgt_cny',if((`audit_log`.`added` = 89), 'use_dummy_agent', 'dummy_user_not_added'))))) AS `action_add`,`audit_log`.`object_id` AS `component_id`,`audit_log`.`at_time` AS `at_time` from `audit_log` where (((`audit_log`.`class` = 'Bugzilla::Component') and (`audit_log`.`field` = 'initialowner') and (`audit_log`.`removed` = 92)) or ((`audit_log`.`class` = 'Bugzilla::Component') and (`audit_log`.`field` = 'initialowner') and (`audit_log`.`removed` = 91)) or ((`audit_log`.`class` = 'Bugzilla::Component') and (`audit_log`.`field` = 'initialowner') and (`audit_log`.`removed` = 90)) or ((`audit_log`.`class` = 'Bugzilla::Component') and (`audit_log`.`field` = 'initialowner') and (`audit_log`.`removed` = 92)) or ((`audit_log`.`class` = 'Bugzilla::Component') and (`audit_log`.`field` = 'initialowner') and (`audit_log`.`removed` = 89)) or ((`audit_log`.`class` = 'Bugzilla::Component') and (`audit_log`.`field` = 'initialowner') and (`audit_log`.`added` = 92)) or ((`audit_log`.`class` = 'Bugzilla::Component') and (`audit_log`.`field` = 'initialowner') and (`audit_log`.`added` = 91)) or ((`audit_log`.`class` = 'Bugzilla::Component') and (`audit_log`.`field` = 'initialowner') and (`audit_log`.`added` = 90)) or ((`audit_log`.`class` = 'Bugzilla::Component') and (`audit_log`.`field` = 'initialowner') and (`audit_log`.`added` = 92)) or ((`audit_log`.`class` = 'Bugzilla::Component') and (`audit_log`.`field` = 'initialowner') and (`audit_log`.`added` = 89)))$$
DELIMITER ;

 DROP TABLE IF EXISTS `list_changes_new_assignee_is_real`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `list_changes_new_assignee_is_real` AS select `ut_product_group`.`product_id` AS `product_id`,`audit_log`.`object_id` AS `component_id`,`audit_log`.`removed` AS `removed`,`audit_log`.`added` AS `added`,`audit_log`.`at_time` AS `at_time`,`ut_product_group`.`role_type_id` AS `role_type_id` from (`audit_log` join `ut_product_group` on((`audit_log`.`object_id` = `ut_product_group`.`component_id`))) where ((`audit_log`.`class` = 'Bugzilla::Component') and (`audit_log`.`field` = 'initialowner') and (`audit_log`.`added` <> 93) and (`audit_log`.`added` <> 91) and (`audit_log`.`added` <> 90) and (`audit_log`.`added` <> 92) and (`audit_log`.`added` <> 89)) group by `audit_log`.`object_id`,`ut_product_group`.`role_type_id` order by `audit_log`.`at_time` desc,`ut_product_group`.`product_id`,`audit_log`.`object_id`CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `list_changes_new_assignee_is_real` AS select `ut_product_group`.`product_id` AS `product_id`,`audit_log`.`object_id` AS `component_id`,`audit_log`.`removed` AS `removed`,`audit_log`.`added` AS `added`,`audit_log`.`at_time` AS `at_time`,`ut_product_group`.`role_type_id` AS `role_type_id` from (`audit_log` join `ut_product_group` on((`audit_log`.`object_id` = `ut_product_group`.`component_id`))) where ((`audit_log`.`class` = 'Bugzilla::Component') and (`audit_log`.`field` = 'initialowner') and (`audit_log`.`added` <> 93) and (`audit_log`.`added` <> 91) and (`audit_log`.`added` <> 90) and (`audit_log`.`added` <> 92) and (`audit_log`.`added` <> 89)) group by `audit_log`.`object_id`,`ut_product_group`.`role_type_id` order by `audit_log`.`at_time` desc,`ut_product_group`.`product_id`,`audit_log`.`object_id`$$
DELIMITER ;

 DROP TABLE IF EXISTS `list_components_with_real_default_assignee`;
/*  Create View in target  */

DELIMITER $$
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `list_components_with_real_default_assignee` AS select `ut_product_group`.`product_id` AS `product_id`,`components`.`id` AS `component_id`,`components`.`initialowner` AS `initialowner`,`ut_product_group`.`role_type_id` AS `role_type_id`,`products`.`isactive` AS `isactive` from ((`components` join `ut_product_group` on((`components`.`id` = `ut_product_group`.`component_id`))) join `products` on((`ut_product_group`.`product_id` = `products`.`id`))) where ((`components`.`initialowner` <> 93) and (`components`.`initialowner` <> 91) and (`components`.`initialowner` <> 90) and (`components`.`initialowner` <> 92) and (`components`.`initialowner` <> 89) and (`ut_product_group`.`role_type_id` is not null)) group by `ut_product_group`.`product_id`,`components`.`id`,`ut_product_group`.`role_type_id` order by `ut_product_group`.`product_id`,`components`.`id`CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `list_components_with_real_default_assignee` AS select `ut_product_group`.`product_id` AS `product_id`,`components`.`id` AS `component_id`,`components`.`initialowner` AS `initialowner`,`ut_product_group`.`role_type_id` AS `role_type_id`,`products`.`isactive` AS `isactive` from ((`components` join `ut_product_group` on((`components`.`id` = `ut_product_group`.`component_id`))) join `products` on((`ut_product_group`.`product_id` = `products`.`id`))) where ((`components`.`initialowner` <> 93) and (`components`.`initialowner` <> 91) and (`components`.`initialowner` <> 90) and (`components`.`initialowner` <> 92) and (`components`.`initialowner` <> 89) and (`ut_product_group`.`role_type_id` is not null)) group by `ut_product_group`.`product_id`,`components`.`id`,`ut_product_group`.`role_type_id` order by `ut_product_group`.`product_id`,`components`.`id`$$
DELIMITER ;

/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `add_invitee_in_cc`()
    SQL SECURITY INVOKER
BEGIN
	IF (@add_invitee_in_cc = 1)
	THEN

	# We make the user in CC for this case:
		INSERT INTO `cc`
			(`bug_id`
			,`who`
			) 
			VALUES 
			(@bz_case_id,@bz_user_id);

		# We record the name of this procedure for future debugging and audit_log
			SET @script = 'PROCEDURE - add_invitee_in_cc';
			SET @timestamp = NOW();			
			
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
										, @bz_user_id
										, ' is added as CC for the case #'
										, @bz_case_id
										)
										;
				
			INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;

	# Record the change in the Bug history
	# The old value for the audit will always be '' as this is the first time that this user
	# is involved in this case in that unit.
		# We need the invitee login name:
			SET @invitee_login_name = (SELECT `login_name` FROM `profiles` WHERE `userid` = @bz_user_id);
		
		# We can now update the bug activity
			INSERT INTO	`bugs_activity`
				(`bug_id` 
				, `who` 
				, `bug_when`
				, `fieldid`
				, `added`
				, `removed`
				)
				VALUES
				(@bz_case_id
				, @creator_bz_id
				, @timestamp
				, 22
				, @invitee_login_name
				, ''
				)
				;

		# Log the actions of the script.
			SET @script_log_message = CONCAT('the case histoy for case #'
										, @bz_case_id
										, ' has been updated. new user: '
										, @invitee_login_name
										, ' was added in CC to the case.'
										)
										;
				
			INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(@timestamp, @script, @script_log_message)
					;

		# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @script = NULL;
				SET @timestamp = NULL;
END IF ;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `add_user_to_role_in_unit`()
BEGIN

	# This procedure needs the following objects:
	#	- variables:
	#		- @mefe_invitation_id
	#		- @mefe_invitation_id_int_value
	#		- @environment : Which environment are you creating the unit in?
	#			- 1 is for the DEV/Staging
	#			- 2 is for the prod environment
	#		  	- 3 is for the Demo environment
	#	- tables
	#		- 'ut_user_group_map_temp'
	#
	#############################################
	#
	# IMPORTANT INFORMATION ABOUT THIS SCRIPT
	#
	#############################################
	#
	# Use this script only if the Unit EXIST in the BZFE 
	# It assumes that the unit has been created with all the necessary BZ objects and all the roles assigned to dummy users.
	#
	# Pre-requisite:
	#	- The table 'ut_invitation_api_data' has been updated 
	# 	- We know the MEFE Invitation id that we need to process.
	#	- We know the environment where this script is run
	# 
	# This script will:
	#	- Create a temp table to store the permissions we are creating
	#	- Reset things for this user for this unit:
	#		- Remove all the permissions for this user for this unit for ALL roles.
	# 	- Remove this user from the list of user in default CC for a case for this role in this unit.
	#	- Get the information needed from the table `ut_invitation_api_data`
	#		- BZ Invitor id
	#		- BZ unit id
	#		- The invited user:
	#			- BZ invited id
	#			- The role in this unit for the invited user
	#			- Is the invited user an occupant of the unit or not.
	#			- Is the user is a MEFE user only:
	#				- IF the user is a MEFE user only 
	#				  Then disable the mail sending functionality from the BZFE.
	#		- The type of invitation for this user
	#			- 'replace_default': Remove and Replace: 
	#				- Grant the permissions to the inviter user for this role for this unit
	#				and 
	#				- Remove the existing default user for this role
	#				and 
	#				- Replace the default user for this role 
	#			- 'default_cc_all': Keep existing assignee, Add invited and make invited default CC
	#				- Grant the permissions to the invited user for this role for this unit
	#				and
	#				- Keep the existing default user as default
	#				and
	#				- Make the invited user an automatic CC to all the new cases for this role for this unit
	#			- 'keep_default' Keep existing and Add invited
	#				- Grant the permissions to the inviter user for this role for this unit
	#				and 
	#				- Keep the existing default user as default
	#				and
	#				- Check if this new user is the first in this role for this unit.
	#					- If it IS the first in this role for this unit.
	#				 	  Then Replace the Default 'dummy user' for this specific role with the BZ user in CC for this role for this unit.
	#					- If it is NOT the first in this role for this unit.
	#					  Do Nothing
	#			- 'remove_user': Remove user from a role in a unit
	#				- Revoke the permissions to the user for this role for this unit
	#				and 
	#				- Check if this user is the default user for this role for this unit.
	#					- If it IS the Default user in this role for this unit.
	#				 	  Then Replace the Default user in this role for this unit with the 'dummy user' for this specific role.
	#					- If it is NOT the Default user in this role for this unit.
	#					  Do Nothing
	#			- Other or no information about the type of invitation
	#				- Grant the permissions to the inviter user for this role for this unit
	#				and
	#				- Check if this new user is the first in this role for this unit.
	#					- If it IS the first in this role for this unit.
	#				 	  Then Replace the Default 'dummy user' for this specific role with the BZ user in CC for this role for this unit.
	#					- If it is NOT the first in this role for this unit.
	#					  Do Nothing
	#	- Process the invitation accordingly.
	#	- Delete an re-create all the entries for the table `user_groups`
	#	- Log the action of the scripts that are run
	#	- Update the invitation once everything has been done
	#	- Exit with either:
	#		- an error message (there was a problem somewhere)
	#		or 
	#		- no error message (succcess)
	#
	# Limits of this script:
	#	- Unit must have all roles created with Dummy user roles.
	#
	#	
	
	#####################################################
	#					
	# We need to define all the variables we need
	#					
	#####################################################

	# We make sure that all the variable we user are set to NULL first
	# This is to avoid issue of a variable 'silently' using a value from a previous run
		SET @reference_for_update = NULL;
		SET @mefe_invitor_user_id = NULL;
		SET @product_id = NULL;
		SET @creator_bz_id = NULL;
		SET @creator_pub_name = NULL;
		SET @id_role_type = NULL;
		SET @bz_user_id = NULL;
		SET @role_user_g_description = NULL;
		SET @user_pub_name = NULL;
		SET @role_user_pub_info = NULL;
		SET @user_role_desc = NULL;
		SET @role_user_more = NULL;
		SET @user_role_type_description = NULL;
		SET @user_role_type_name = NULL;
		SET @component_id_this_role = NULL;
		SET @current_default_assignee_this_role = NULL;
		SET @bz_user_id_dummy_tenant = NULL;
		SET @bz_user_id_dummy_landlord = NULL;
		SET @bz_user_id_dummy_contractor = NULL;
		SET @bz_user_id_dummy_mgt_cny = NULL;
		SET @bz_user_id_dummy_agent = NULL;
		SET @bz_user_id_dummy_user_this_role = NULL;
		SET @is_occupant = NULL;
		SET @invitation_type = NULL;
		SET @is_mefe_only_user = NULL;
		SET @user_in_default_cc_for_cases = NULL;
		SET @replace_default_assignee = NULL;
		SET @remove_user_from_role = NULL;
		SET @can_see_time_tracking = NULL;
		SET @can_create_shared_queries = NULL;
		SET @can_tag_comment = NULL;
		SET @can_create_new_cases = NULL;
		SET @can_edit_a_case = NULL;
		SET @can_see_all_public_cases = NULL;
		SET @can_edit_all_field_in_a_case_regardless_of_role = NULL;
		SET @can_see_unit_in_search = NULL;
		SET @user_is_publicly_visible = NULL;
		SET @user_can_see_publicly_visible = NULL;
		SET @can_ask_to_approve_flags = NULL;
		SET @can_approve_all_flags = NULL;
		SET @is_current_assignee_this_role_a_dummy_user = NULL;
		SET @this_script = NULL;

	# Default values:
		
		#User Permissions in the unit:
			# Generic Permissions
				SET @can_see_time_tracking = 1;
				SET @can_create_shared_queries = 0;
				SET @can_tag_comment = 1;
			# Product/Unit specific permissions
				SET @can_create_new_cases = 1;
				SET @can_edit_a_case = 1;
				SET @can_see_all_public_cases = 1;
				SET @can_edit_all_field_in_a_case_regardless_of_role = 1;
				SET @can_see_unit_in_search = 1;
				SET @user_is_publicly_visible = 1;
				SET @user_can_see_publicly_visible = 1;
				SET @can_ask_to_approve_flags = 1;
				SET @can_approve_all_flags = 1;
		
		# Do we need to make the invitee a default CC for all new cases for this role in this unit?
			SET @user_in_default_cc_for_cases = 0;

	# Timestamp	
		SET @timestamp = NOW();

	# We define the name of this script for future reference:
		SET @this_script = 'PROCEDURE add_user_to_role_in_unit';
		
	# We create a temporary table to record the ids of the dummy users in each environments:
		CALL `table_to_list_dummy_user_by_environment`;
		
	# The reference of the record we want to update in the table `ut_invitation_api_data`
		SET @reference_for_update = (SELECT `id` FROM `ut_invitation_api_data` WHERE `mefe_invitation_id` = @mefe_invitation_id );	

	# The MEFE information:
		SET @mefe_invitor_user_id = (SELECT `mefe_invitor_user_id` FROM `ut_invitation_api_data` WHERE `id` = @reference_for_update);

	# The unit name and description
		SET @product_id = (SELECT `bz_unit_id` FROM `ut_invitation_api_data` WHERE `id` = @reference_for_update);

	# The Invitor - BZ user id of the user that has genereated the invitation.
		SET @creator_bz_id = (SELECT `bzfe_invitor_user_id` FROM `ut_invitation_api_data` WHERE `id` = @reference_for_update);

		# We populate the additional variables that we will need for this script to work:
			SET @creator_pub_name = (SELECT `realname` FROM `profiles` WHERE `userid` = @creator_bz_id);

	# Role in this unit for the invited user:
		#	- Tenant 1
		# 	- Landlord 2
		#	- Agent 5
		#	- Contractor 3
		#	- Management company 4
		SET @id_role_type = (SELECT `user_role_type_id` FROM `ut_invitation_api_data` WHERE `id` = @reference_for_update);
			
	# The user who you want to associate to this unit - BZ user id of the user that you want to associate/invite to the unit.
		SET @bz_user_id = (SELECT `bz_user_id` FROM `ut_invitation_api_data` WHERE `id` = @reference_for_update);

		# We populate the additional variables that we will need for this script to work:
			SET @role_user_g_description = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=@id_role_type);
			SET @user_pub_name = (SELECT (LEFT(`login_name`,INSTR(`login_name`,"@")-1)) FROM `profiles` WHERE `userid` = @bz_user_id);
			SET @role_user_more = (SELECT `user_more` FROM `ut_invitation_api_data` WHERE `id` = @reference_for_update);		
			SET @role_user_pub_info = CONCAT(@user_pub_name
									, IF (@role_user_more = '', '', ' - ')
									, IF (@role_user_more = '', '', @role_user_more)
									)
									;
			SET @user_role_desc = (CONCAT(@role_user_g_description, ' - ', @role_user_pub_info));
		
		SET @user_role_type_description = (SELECT `bz_description` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type);
		SET @user_role_type_name = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type);
		
		# We need to get the component_id for this role for this product/unit
		# We get that from the ut_product_group table.
			SET @component_id_this_role = (SELECT `component_id` 
										FROM `ut_product_group` 
										WHERE `product_id` = @product_id 
											AND `role_type_id` = @id_role_type
											AND `group_type_id` = 2)
											;
					
		# Is the current assignee for this role for this unit one of the dummy user in this environment?

			# What is the CURRENT default assignee for the role this user has been invited to?
				SET @current_default_assignee_this_role = (SELECT `initialowner` FROM `components` WHERE `id` = @component_id_this_role);

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

			# What is the BZ dummy user id for this role in this script?
				SET @bz_user_id_dummy_user_this_role = IF( @id_role_type = 1
												, @bz_user_id_dummy_tenant
												, IF (@id_role_type = 2
													, @bz_user_id_dummy_landlord
													, IF (@id_role_type = 3
														, @bz_user_id_dummy_contractor
														, IF (@id_role_type = 4
															, @bz_user_id_dummy_mgt_cny
															, IF (@id_role_type = 5
																, @bz_user_id_dummy_agent
																, 'Something is very wrong!! - error on line 484'
																)
															)
														)
													)
												)
												;

	# Is the invited user an occupant of the unit?
		SET @is_occupant = (SELECT `is_occupant` FROM `ut_invitation_api_data` WHERE `id` = @reference_for_update);
		
	# What type of invitation is this?
		SET @invitation_type = (SELECT `invitation_type` FROM `ut_invitation_api_data` WHERE `id` = @reference_for_update);
		
	# Do we need to disable the BZ email notification for this user?
		SET @is_mefe_only_user = (SELECT `is_mefe_only_user` 
								FROM `ut_invitation_api_data` 
								WHERE `id` = @reference_for_update)
								;
								
	# User permissions:
		# These will depend on :
		#	- The invitation type
		#	- The default values currently configured
		# We NEED to have defined the variable @invitation_type FIRST!

		# Things which depends on the invitation type:
		
			# Do we need to make the invitee a default CC for all new cases for this role in this unit?
			# This depends on the type of invitation that we are creating
			#	- 1 (YES) if the invitation type is
			#		- 'default_cc_all'
			#	- 0 (NO) if the invitation type is any other invitation type
			#
					SET @user_in_default_cc_for_cases = IF (@invitation_type = 'default_cc_all'
						, 1
						, 0
						)
						;

			# Do we need to replace the default assignee for this role in this unit?
			# This depends on the type of invitation that we are creating
			#	- 1 (YES) if the invitation type is
			#		- 'replace_default'
			#	- 0 (NO) if the invitation type is any other invitation type
			#
					SET @replace_default_assignee = IF (@invitation_type = 'replace_default'
						, 1
						, 0
						)
						;
						
			# Do we need to revoke the permission for this user for this unit?
			# This depends on the type of invitation that we are creating
			#	- 1 (YES) if the invitation type is
			#		- 'remove_user'
			#	- 0 (NO) if the invitation type is any other invitation type
			#
					SET @remove_user_from_role = IF (@invitation_type = 'remove_user'
						, 1
						, 0
						)
						;

	# Answer to the question "Is the current default assignee for this role one of the dummy users?"
		SET @is_current_assignee_this_role_a_dummy_user = IF( @replace_default_assignee = 1
			, 0
			, IF(@current_default_assignee_this_role = @bz_user_id_dummy_user_this_role
				, 1
				, 0
				)
			)
			;

	# We need to create the table to prepare the permissions for the users:
		CALL `create_temp_table_to_update_permissions`;
	
	#################################################################
	#
	# All the variables and tables have been set - we can call the procedures
	#
	#################################################################
		
	# RESET: We remove the user from the list of user in default CC for this role
	# This procedure needs the following objects:
	#	- variables:
	#		- @bz_user_id : 
	#		  the BZ user id of the user
	#		- @component_id_this_role: 
	#		  The id of the role in the bz table `components`
		CALL `remove_user_from_default_cc`;

	# We are recording this for KPI measurements
	#	- Number of user per role per unit.

		# We record the information about the users that we have just created
		# If this is the first time we record something for this user for this unit, we create a new record.
		# If there is already a record for THAT USER for THIS, then we are updating the information
			
			INSERT INTO `ut_map_user_unit_details`
				(`created`
				, `record_created_by`
				, `user_id`
				, `bz_profile_id`
				, `bz_unit_id`
				, `role_type_id`
				, `can_see_time_tracking`
				, `can_create_shared_queries`
				, `can_tag_comment`
				, `is_occupant`
				, `is_public_assignee`
				, `is_see_visible_assignee`
				, `is_in_cc_for_role`
				, `can_create_case`
				, `can_edit_case`
				, `can_see_case`
				, `can_edit_all_field_regardless_of_role`
				, `is_flag_requestee`
				, `is_flag_approver`
				, `can_create_any_sh`
				, `can_create_same_sh`
				, `can_approve_user_for_flags`
				, `can_decide_if_user_visible`
				, `can_decide_if_user_can_see_visible`
				, `public_name`
				, `more_info`
				, `comment`
				)
				VALUES
				(@timestamp
				, @creator_bz_id
				, @bz_user_id
				, @bz_user_id
				, @product_id
				, @id_role_type
				# Global permission for the whole installation
				, @can_see_time_tracking
				, @can_create_shared_queries
				, @can_tag_comment
				# Attributes of the user
				, @is_occupant
				# User visibility
				, @user_is_publicly_visible
				, @user_can_see_publicly_visible
				# Permissions for cases for this unit.
				, @user_in_default_cc_for_cases
				, @can_create_new_cases
				, @can_edit_a_case
				, @can_see_all_public_cases
				, @can_edit_all_field_in_a_case_regardless_of_role
				# For the flags
				, @can_ask_to_approve_flags
				, @can_approve_all_flags
				# Permissions to create or modify other users
				, 0
				, 0
				, 0
				, 0
				, 0
				, @user_pub_name
				, @role_user_more
				, CONCAT('On '
						, @timestamp
						, ': Created with the script - '
						, @this_script
						, '.\r\ '
						, `comment`)
				)
				ON DUPLICATE KEY UPDATE
				`created` = @timestamp
				, `record_created_by` = @creator_bz_id
				, `role_type_id` = @id_role_type
				# Global permission for the whole installation
				, `can_see_time_tracking` = @can_see_time_tracking
				, `can_create_shared_queries` = @can_create_shared_queries
				, `can_tag_comment` = @can_tag_comment
				# Attributes of the user
				, `is_occupant` = @is_occupant
				# User visibility
				, `is_public_assignee` = @user_is_publicly_visible
				, `is_see_visible_assignee` = @user_can_see_publicly_visible
				# Permissions for cases for this unit.
				, `is_in_cc_for_role` = @user_in_default_cc_for_cases
				, `can_create_case` = @can_create_new_cases
				, `can_edit_case` = @can_edit_a_case
				, `can_see_case` = @can_see_all_public_cases
				, `can_edit_all_field_regardless_of_role` = @can_edit_all_field_in_a_case_regardless_of_role
				# For the flags
				, `is_flag_requestee` = @can_ask_to_approve_flags
				, `is_flag_approver` = @can_approve_all_flags
				# Permissions to create or modify other users
				, `can_create_any_sh` = 0
				, `can_create_same_sh` = 0
				, `can_approve_user_for_flags` = 0
				, `can_decide_if_user_visible` = 0
				, `can_decide_if_user_can_see_visible` = 0
				, `public_name` = @user_pub_name
				, `more_info` = CONCAT('On: '
					, @timestamp
					, '.\r\Updated to '
					, @role_user_more
					, '. \r\ '
					, `more_info`
					)
				, `comment` = CONCAT('On '
					, @timestamp
					, '.\r\Updated with the script - '
					, @this_script
					, '.\r\ '
					, `comment`)
			;

	# We always reset the permissions to the default permissions first
		# Revoke all permissions for this user in this unit
			# This procedure needs the following objects:
			#	- Variables:
			#		- @product_id
			#		- @bz_user_id
			#	- table 
			#		- 'ut_user_group_map_temp'
			CALL `revoke_all_permission_for_this_user_in_this_unit`;
			
		# Prepare the permissions - configure these to default:
			# Generic Permissions
				# These need the following objects:
				#	- table 'ut_user_group_map_temp'
				#	- Variables:
				#		- @bz_user_id
					CALL `can_see_time_tracking`;
					CALL `can_create_shared_queries`;
					CALL `can_tag_comment`;
			# Product/Unit specific permissions
				# These need the following objects:
				#	- table 'ut_user_group_map_temp'
				#	- Variables:
				#		- @bz_user_id
				#		- @product_id
					CALL `can_create_new_cases`;
					CALL `can_edit_a_case`;
					CALL `can_see_all_public_cases`;
					CALL `can_edit_all_field_in_a_case_regardless_of_role`;
					CALL `can_see_unit_in_search`;
					
					CALL `user_is_publicly_visible`;
					CALL `user_can_see_publicly_visible`;
					
					CALL `can_ask_to_approve_flags`;
					CALL `can_approve_all_flags`;
			# Role/Component specific permissions
				# These need the following objects:
				#	- table 'ut_user_group_map_temp'
				#	- Variables:
				#		- @id_role_type
				#		- @bz_user_id
				#		- @product_id
				#		- @is_occupant
					CALL `show_to_tenant`;
					CALL `is_tenant`;
					CALL `default_tenant_can_see_tenant`;
					
					CALL `show_to_landlord`;
					CALL `are_users_landlord`;
					CALL `default_landlord_see_users_landlord`;
					
					CALL `show_to_contractor`;
					CALL `are_users_contractor`;
					CALL `default_contractor_see_users_contractor`;
					
					CALL `show_to_mgt_cny`;
					CALL `are_users_mgt_cny`;
					CALL `default_mgt_cny_see_users_mgt_cny`;
					
					CALL `show_to_agent`;
					CALL `are_users_agent`;
					CALL `default_agent_see_users_agent`;
					
					CALL `show_to_occupant`;
					CALL `is_occupant`;
					CALL `default_occupant_can_see_occupant`;
			
		# All the permission have been prepared, we can now update the permissions table
		#		- This NEEDS the table 'ut_user_group_map_temp'
			CALL `update_permissions_invited_user`;
		
	# Disable the BZ email notification engine if needed
	# This procedure needs the following objects:
	#	- variables:
	#		- @is_mefe_only_user
	#		- @creator_bz_id
	#		- @bz_user_id
		CALL `disable_bugmail`;
		
	# Replace the default dummy user for this role if needed
	# This procedure needs the following objects:
	#	- variables:
	#		- @is_current_assignee_this_role_a_dummy_user
	#		- @component_id_this_role
	#		- @bz_user_id
	#		- @user_role_desc
	#		- @id_role_type
	#		- @user_pub_name
	#		- @product_id
	#		- @creator_bz_id
	#		- @mefe_invitation_id
	#		- @mefe_invitation_id_int_value
	#		- @mefe_invitor_user_id
	#		- @is_occupant
	#		- @is_mefe_only_user
	#		- @role_user_more
		CALL `update_assignee_if_dummy_user`;

	# Make the invited user default CC for all cases in this unit if needed
	# This procedure needs the following objects:
	#	- variables:
	#		- @user_in_default_cc_for_cases
	#		- @bz_user_id
	#		- @product_id
	#		- @component_id
	#		- @role_user_g_description
		# Make sure the variable we need is correctly defined
			SET @component_id = @component_id_this_role;
		
		# Run the procedure
			CALL `user_in_default_cc_for_cases`;	

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

	# Remove this user from this role in this unit if needed:
	# This procedure needs the following objects
	#	- Variables:
	#		- @remove_user_from_role
	#		- @component_id_this_role
	#		- @product_id
	#		- @bz_user_id
	#		- @bz_user_id_dummy_user_this_role
	#		- @id_role_type
	#		- @user_role_desc
	#		- @user_pub_name
	#		- @creator_bz_id
		CALL `remove_user_from_role`;

	# Update the table 'ut_invitation_api_data' so we record what we have done

		# Timestamp	
			SET @timestamp = NOW();

		# Make sure we have the correct value for the name of this script
			SET @script = 'PROCEDURE add_user_to_role_in_unit';
			
		# We do the update to record that we have reached the end of the script...
			UPDATE `ut_invitation_api_data`
				SET `processed_datetime` = @timestamp
					, `script` = @this_script
				WHERE `mefe_invitation_id` = @mefe_invitation_id
				;

END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `are_users_agent`()
    SQL SECURITY INVOKER
BEGIN
	IF (@id_role_type = 5)
	THEN 
		# Get the information about the group which grant this permission
			SET @group_id_are_users_agent = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 22 
					AND `role_type_id` = 5)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_are_users_agent, 0, 0)
				;

		# We record the name of this procedure for future debugging and audit_log
			SET @script = 'PROCEDURE - are_users_agent';
			SET @timestamp = NOW();

		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' is an agent for the unit #'
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

		# We log what we have just done into the `ut_audit_log` table
				
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'is an agent.';

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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_are_users_agent, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `are_users_contractor`()
    SQL SECURITY INVOKER
BEGIN
	IF (@id_role_type = 3)
	THEN 
		# Get the information about the group which grant this permission
			SET @group_id_are_users_contractor = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 22 
					AND `role_type_id` = 3)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_are_users_contractor, 0, 0)
				;

		# We record the name of this procedure for future debugging and audit_log
			SET @script = 'PROCEDURE - are_users_contractor';
			SET @timestamp = NOW();

		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' is a contractor for the unit #'
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

		# We log what we have just done into the `ut_audit_log` table
				
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'is a contractor.';

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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_are_users_contractor, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @bzfe_table = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @permission_granted = NULL;
END IF ;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `are_users_landlord`()
    SQL SECURITY INVOKER
BEGIN
	IF (@id_role_type = 2)
	THEN 
		# Get the information about the group which grant this permission
			SET @group_id_are_users_landlord = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 22 
					AND `role_type_id` = 2)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_are_users_landlord, 0, 0)
				;

		# We record the name of this procedure for future debugging and audit_log
			SET @script = 'PROCEDURE - are_users_landlord';
			SET @timestamp = NOW();

		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' is a landlord for the unit #'
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

		# We log what we have just done into the `ut_audit_log` table
			
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'is an landlord.';
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
			 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
			 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_are_users_landlord, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
			 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
			 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
			;
 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `are_users_mgt_cny`()
    SQL SECURITY INVOKER
BEGIN
	IF (@id_role_type = 4)
	THEN 
		# Get the information about the group which grant this permission
			SET @group_id_are_users_mgt_cny = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 22 
					AND `role_type_id` = 4)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_are_users_mgt_cny, 0, 0)
				;

		# We record the name of this procedure for future debugging and audit_log
			SET @script = 'PROCEDURE - are_users_mgt_cny';
			SET @timestamp = NOW();

		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' is a Mgt Cny for the unit #'
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

		# We log what we have just done into the `ut_audit_log` table
				
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'is a Mgt Cny.';

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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_are_users_mgt_cny, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
			 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `can_approve_all_flags`()
    SQL SECURITY INVOKER
BEGIN
	IF (@can_approve_all_flags = 1)
	THEN 
		# Get the information about the group which grant this permission
			SET @all_g_flags_group_id = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 19)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES
				(@bz_user_id, @all_g_flags_group_id, 0, 0)
				;

		# We record the name of this procedure for future debugging and audit_log
			SET @script = 'PROCEDURE - can_approve_all_flags';
			SET @timestamp = NOW();

		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' CAN approve for all flags.'
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

		# We log what we have just done into the `ut_audit_log` table
			
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = ' CAN approve for all flags.';
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @all_g_flags_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `can_ask_to_approve_flags`()
    SQL SECURITY INVOKER
BEGIN
	IF (@can_ask_to_approve_flags = 1)
	THEN 
		# Get the information about the group which grant this permission
			SET @all_r_flags_group_id = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 18)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES
				(@bz_user_id, @all_r_flags_group_id, 0, 0)
				;

		# We record the name of this procedure for future debugging and audit_log
			SET @script = 'PROCEDURE - can_ask_to_approve_flags';
			SET @timestamp = NOW();

		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' CAN ask for approval for all flags.'
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

		# We log what we have just done into the `ut_audit_log` table
		
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = ' CAN ask for approval for all flags.';
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @all_r_flags_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;	
END IF ;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `can_create_new_cases`()
    SQL SECURITY INVOKER
BEGIN
	IF (@can_create_new_cases = 1)
	THEN 
		# Get the information about the group which grant this permission
			SET @create_case_group_id =	(SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 20)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				# There can be cases when a user is only allowed to see existing cases but NOT create new one.
				# This is an unlikely scenario, but this is technically possible...
				(@bz_user_id, @create_case_group_id, 0, 0)
				;

		# We record the name of this procedure for future debugging and audit_log
			SET @script = 'PROCEDURE - can_create_new_cases';
			SET @timestamp = NOW();

		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' CAN create new cases for unit '
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
			# We log what we have just done into the `ut_audit_log` table
			
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'create a new case.';
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `can_create_shared_queries`()
    SQL SECURITY INVOKER
BEGIN

	# This should not change, it was hard coded when we created Unee-T
		# Can create shared queries
		SET @can_create_shared_queries_group_id = 17;

	IF (@can_create_shared_queries = 1)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id,@can_create_shared_queries_group_id,0,0)
				;

		# We record the name of this procedure for future debugging and audit_log
				SET @script = 'PROCEDURE - can_create_shared_queries';
				SET @timestamp = NOW();
			
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' CAN create shared queries.'
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
					)
				VALUES
				(@timestamp, @script, @script_log_message)
				;
		# We log what we have just done into the `ut_audit_log` table
			SET @bzfe_table = 'ut_user_group_map_temp';
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to create shared queries')
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @can_create_shared_queries_group_id, @script, 'Add the BZ group id when we grant the permission to create shared queries')
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant create shared queries permission')
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group create shared queries')
				 ;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
END IF ;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `can_edit_a_case`()
    SQL SECURITY INVOKER
BEGIN
	IF (@can_edit_a_case = 1)
	THEN 
		# Get the information about the group which grant this permission
			SET @can_edit_case_group_id = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 25)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @can_edit_case_group_id, 0, 0)	
				;

		# We record the name of this procedure for future debugging and audit_log
			SET @script = 'PROCEDURE - can_edit_a_case';
			SET @timestamp = NOW();

		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' CAN edit a case for unit '
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
			# We log what we have just done into the `ut_audit_log` table
			
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'edit a case in this unit.';
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @can_edit_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `can_edit_all_field_in_a_case_regardless_of_role`()
    SQL SECURITY INVOKER
BEGIN
	IF (@can_edit_all_field_in_a_case_regardless_of_role = 1)
	THEN 
		# Get the information about the group which grant this permission
			SET @can_edit_all_field_case_group_id = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 26)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @can_edit_all_field_case_group_id, 0, 0)	
				;

		# We record the name of this procedure for future debugging and audit_log
			SET @script = 'PROCEDURE - can_edit_all_field_in_a_case_regardless_of_role';
			SET @timestamp = NOW();

		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' can edit all fields in the case regardless of his/her role for the unit#'
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
			# We log what we have just done into the `ut_audit_log` table
			
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'Can edit all fields in the case regardless of his/her role.';
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @can_edit_all_field_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `can_see_all_public_cases`()
    SQL SECURITY INVOKER
BEGIN
	# This allows a user to see the 'public' cases for a given unit.
	# A 'public' case can still only be seen by users in this group!
	# We might NOT want this for employees of a contractor that only need to see the cases IF the case is restricted to
	# the contractor role but NOT if the case is for anyone
	# This is an unlikely scenario, but this is technically possible (ex for technician for a contractor)...

	IF (@can_see_all_public_cases = 1)
	THEN 
		# Get the information about the group which grant this permission
			SET @can_see_cases_group_id = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 28)
				)
				;
				
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @can_see_cases_group_id, 0, 0)	
				;

		# We record the name of this procedure for future debugging and audit_log
			SET @script = 'PROCEDURE - can_see_all_public_cases';
			SET @timestamp = NOW();

		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' CAN see all public cases for unit '
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
			# We log what we have just done into the `ut_audit_log` table
			
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'see all public case in this unit.';
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_cases_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `can_see_time_tracking`()
    SQL SECURITY INVOKER
BEGIN

	# This should not change, it was hard coded when we created Unee-T
		# See time tracking
		SET @can_see_time_tracking_group_id = 16;

	IF (@can_see_time_tracking = 1)
	THEN INSERT	INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id,@can_see_time_tracking_group_id,0,0)
				;

		# We record the name of this procedure for future debugging and audit_log
			SET @script = 'PROCEDURE - can_see_time_tracking';
			SET @timestamp = NOW();
			
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' CAN See time tracking information.'
									);
		
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;
			# We log what we have just done into the `ut_audit_log` table
			
			SET @bzfe_table = 'ut_user_group_map_temp';
			
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to see time tracking')
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_time_tracking_group_id, @script, 'Add the BZ group id when we grant the permission to see time tracking')
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant see time tracking permission')
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group see time tracking')
				 ;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
END IF ;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `can_see_unit_in_search`()
    SQL SECURITY INVOKER
BEGIN
	IF (@can_see_unit_in_search = 1)
	THEN 
		# Get the information about the group which grant this permission
			SET @can_see_unit_in_search_group_id = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 38)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @can_see_unit_in_search_group_id, 0, 0)	
				;

		# We record the name of this procedure for future debugging and audit_log
			SET @script = 'PROCEDURE - can_see_unit_in_search';
			SET @timestamp = NOW();

		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' can see the unit#'
									, @product_id
									, ' in the search panel.'
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;

		# We log what we have just done into the `ut_audit_log` table
			
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'Can see the unit in the Search panel.';
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_unit_in_search_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `can_tag_comment`()
    SQL SECURITY INVOKER
BEGIN

	# This should not change, it was hard coded when we created Unee-T
		# Can tag comments
		SET @can_tag_comment_group_id = 18;		

	IF (@can_tag_comment = 1)
	THEN INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id,@can_tag_comment_group_id,0,0)
				;

		# We record the name of this procedure for future debugging and audit_log
			SET @script = 'PROCEDURE - can_tag_comment';
			SET @timestamp = NOW();
				
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' CAN tag comments.'
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;
			# We log what we have just done into the `ut_audit_log` table
			
			SET @bzfe_table = 'ut_user_group_map_temp';
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to tag comments')
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @can_tag_comment_group_id, @script, 'Add the BZ group id when we grant the permission to tag comments')
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant tag comments permission')
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group tag comments')
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
END IF ;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `capture_id_dummy_user`()
    SQL SECURITY INVOKER
BEGIN
	
	# What is the default dummy user id for this environment?
	# This procedure needs the following objects:
	#	- Table `ut_temp_dummy_users_for_roles`
	#	- @environment
	#
	# This procedure will return the following variables:
	#	- @bz_user_id_dummy_tenant
	#	- @bz_user_id_dummy_landlord
	#	- @bz_user_id_dummy_contractor
	#	- @bz_user_id_dummy_mgt_cny
	#	- @bz_user_id_dummy_agent
	
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

END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `change_case_assignee`()
    SQL SECURITY INVOKER
BEGIN
	IF (@change_case_assignee = 1)
	THEN 

	# We capture the current assignee for the case so that we can log what we did
		SET @current_assignee = (SELECT `assigned_to` FROM `bugs` WHERE `bug_id` = @bz_case_id);
		
	# We also need the login name for the previous assignee and the new assignee
		SET @current_assignee_username = (SELECT `login_name` FROM `profiles` WHERE `userid` = @current_assignee);
		
	# We need the login from the user we are inviting to the case
		SET @invitee_login_name = (SELECT `login_name` FROM `profiles` WHERE `userid` = @bz_user_id);

	# We record the name of this procedure for future debugging and audit_log
		SET @script = 'PROCEDURE - change_case_assignee';
		SET @timestamp = NOW();
		
	# We make the user the assignee for this case:
		UPDATE `bugs`
		SET 
			`assigned_to` = @bz_user_id
			, `delta_ts` = @timestamp
			, `lastdiffed` = @timestamp
		WHERE `bug_id` = @bz_case_id
		;

		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
										, @bz_user_id
										, ' is now the assignee for the case #'
										, @bz_case_id
										)
										;
				
			INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(@timestamp, @script, @script_log_message)
					;
		
	# Record the change in the Bug history
		INSERT INTO	`bugs_activity`
			(`bug_id` 
			, `who` 
			, `bug_when`
			, `fieldid`
			, `added`
			, `removed`
			)
			VALUES
			(@bz_case_id
			, @creator_bz_id
			, @timestamp
			, 16
			, @invitee_login_name
			, @current_assignee_username
			)
			;

		# Log the actions of the script.
			SET @script_log_message = CONCAT('the case histoy for case #'
										, @bz_case_id
										, ' has been updated: '
										, 'old assignee was: '
										, @current_assignee_username
										, 'new assignee is: '
										, @invitee_login_name
										)
										;
				
			INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(@timestamp, @script, @script_log_message)
					;
			
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @script = NULL;
				SET @timestamp = NULL;
END IF ;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `create_temp_table_to_update_group_permissions`()
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

END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `create_temp_table_to_update_permissions`()
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

END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `default_agent_see_users_agent`()
    SQL SECURITY INVOKER
BEGIN
	IF (@id_role_type = 5)
	THEN 
		# Get the information about the group which grant this permission
			SET @group_id_see_users_agent = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 37 
					AND `role_type_id` = 5)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_see_users_agent, 0, 0)
				;

		# We record the name of this procedure for future debugging and audit_log
			SET @script = 'PROCEDURE - default_agent_see_users_agent';
			SET @timestamp = NOW();

		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' can see agents for the unit '
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

		# We log what we have just done into the `ut_audit_log` table
				
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'can see agents for the unit.';

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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_see_users_agent, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
			 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `default_contractor_see_users_contractor`()
    SQL SECURITY INVOKER
BEGIN
	IF (@id_role_type = 3)
	THEN 
		# Get the information about the group which grant this permission
			SET @group_id_see_users_contractor = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 37 
					AND `role_type_id` = 3)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_see_users_contractor, 0, 0)
				;

		# We record the name of this procedure for future debugging and audit_log
			SET @script = 'PROCEDURE - default_contractor_see_users_contractor';
			SET @timestamp = NOW();

		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' can see employee of Contractor for the unit '
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

		# We log what we have just done into the `ut_audit_log` table
				
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'can see employee of Contractor for the unit.';

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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_see_users_contractor, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @bzfe_table = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @permission_granted = NULL;
END IF ;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `default_landlord_see_users_landlord`()
    SQL SECURITY INVOKER
BEGIN
	IF (@id_role_type = 2)
	THEN 
		# Get the information about the group which grant this permission
			SET @group_id_see_users_landlord = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 37 
					AND `role_type_id` = 2)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_see_users_landlord, 0, 0)
				;

		# We record the name of this procedure for future debugging and audit_log
			SET @script = 'PROCEDURE - default_landlord_see_users_landlord';
			SET @timestamp = NOW();
	
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' can see landlord in the unit '
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

		# We log what we have just done into the `ut_audit_log` table
			
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'can see landlord in the unit.';

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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_see_users_landlord, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `default_mgt_cny_see_users_mgt_cny`()
    SQL SECURITY INVOKER
BEGIN
	IF (@id_role_type = 4)
	THEN 
		# Get the information about the group which grant this permission
			SET @group_id_see_users_mgt_cny = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 37 
					AND `role_type_id` = 4)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_see_users_mgt_cny, 0, 0)
				;

		# We record the name of this procedure for future debugging and audit_log
			SET @script = 'PROCEDURE - default_mgt_cny_see_users_mgt_cny';
			SET @timestamp = NOW();

		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' can see Mgt Cny for the unit '
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

		# We log what we have just done into the `ut_audit_log` table
				
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'can see Mgt Cny for the unit.';
	
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_see_users_mgt_cny, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `default_occupant_can_see_occupant`()
    SQL SECURITY INVOKER
BEGIN
	IF (@is_occupant = 1)
	THEN 
		# Get the information about the group which grant this permission
			SET @group_id_see_users_occupant = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 36)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_see_users_occupant, 0, 0)
				;

		# We record the name of this procedure for future debugging and audit_log
			SET @script = 'PROCEDURE - default_occupant_can_see_occupant';
			SET @timestamp = NOW();

		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' can see occupant in the unit '
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

		# We log what we have just done into the `ut_audit_log` table
				
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'can see occupant in the unit.';

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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_see_users_occupant, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `default_tenant_can_see_tenant`()
    SQL SECURITY INVOKER
BEGIN
	IF (@id_role_type = 1)
	THEN 
		# Get the information about the group which grant this permission
			SET @group_id_see_users_tenant = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 37 
					AND `role_type_id` = 1)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_see_users_tenant, 0, 0)
				;

		# We record the name of this procedure for future debugging and audit_log
			SET @script = 'PROCEDURE - default_tenant_can_see_tenant';
			SET @timestamp = NOW();

		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
								, @bz_user_id
									, ' can see tenant in the unit '
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
			# We log what we have just done into the `ut_audit_log` table
			
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'can see tenant in the unit.';
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_see_users_tenant, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
	 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `disable_bugmail`()
    SQL SECURITY INVOKER
BEGIN
	IF (@is_mefe_only_user = 1)
	THEN UPDATE `profiles`
		SET 
			`disable_mail` = 1
		WHERE `userid` = @bz_user_id
		;

		# We record the name of this procedure for future debugging and audit_log
			SET @script = 'PROCEDURE - disable_bugmail';
			SET @timestamp = NOW();

		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' will NOT receive bugmail'
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;

		# We log what we have just done into the `ut_audit_log` table
			
			SET @bzfe_table = 'profiles';
			SET @permission_granted = ' will NOT receive bugmail.';

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
				 (@timestamp ,@bzfe_table, 'disable_mail', 'UNKNOWN', 1, @script, CONCAT('This BZ user id #', @bz_user_id, @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
	
		# Add this information to the BZ `audit_log` table
			INSERT INTO `audit_log`
				(`user_id`
				, `class`
				, `object_id`
				, `field`
				, `removed`
				, `added`
				, `at_time`
				)
				VALUES
				(@creator_bz_id
				, 'Bugzilla::User'
				, @bz_user_id
				, 'disable_mail'
				, '1'
				, '0'
				, @timestamp
				)
				;

		# Log the actions of the script.
			SET @script_log_message = CONCAT('Update profile activity for user #'
									, @bz_user_id
									);
				
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `finalize_invitation_to_a_case`()
    SQL SECURITY INVOKER
BEGIN
	
	# Add a comment to inform users that the invitation has been processed.
	# WARNING - This should happen AFTER the invitation is processed in the MEFE API.

	# We record the name of this procedure for future debugging and audit_log
		SET @script = 'PROCEDURE - finalize_invitation_to_a_case';
		SET @timestamp = NOW();
	
	# We add a new comment to the case.
		INSERT INTO `longdescs`
			(`bug_id`
			, `who`
			, `bug_when`
			, `thetext`
			)
			VALUES
			(@bz_case_id
			, @creator_bz_id
			, @timestamp
			, CONCAT ('An invitation to collaborate on this case has been sent to the '
				, @user_role_type_name 
				, ' for this unit'
				)
			)
			;
		# Log the actions of the script.
			SET @script_log_message = CONCAT('A message has been added to the case #'
										, @bz_case_id
										, ' to inform users that inviation has been sent'
										)
										;
				
			INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(@timestamp, @script, @script_log_message)
					;
			
			SET @script_log_message = NULL;

	# Update the table 'ut_data_to_add_user_to_a_case' so that we record what we have done
		INSERT INTO `ut_data_to_add_user_to_a_case`
			( `mefe_invitation_id`
			, `mefe_invitor_user_id`
			, `bzfe_invitor_user_id`
			, `bz_user_id`
			, `bz_case_id`
			, `bz_created_date`
			, `comment`
			)
		VALUES
			(@mefe_invitation_id
			, @mefe_invitor_user_id
			, @creator_bz_id
			, @bz_user_id
			, @bz_case_id
			, @timestamp
			, CONCAT ('inserted in BZ with the script \''
					, @script
					, '\'\r\ '
					, IFNULL(`comment`, '')
					)
			)
			;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `is_occupant`()
    SQL SECURITY INVOKER
BEGIN
	IF (@is_occupant = 1)
	THEN 
		# Get the information about the group which grant this permission
			SET @group_id_are_users_occupant = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 3)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_are_users_occupant, 0, 0)
				;

		# We record the name of this procedure for future debugging and audit_log
			SET @script = 'PROCEDURE - is_occupant';
			SET @timestamp = NOW();

		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' is an occupant in the unit #'
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

		# We log what we have just done into the `ut_audit_log` table
				
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'is an occupant.';

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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_are_users_occupant, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `is_tenant`()
    SQL SECURITY INVOKER
BEGIN
	IF (@id_role_type = 1)
	THEN 
		# Get the information about the group which grant this permission
			SET @group_id_are_users_tenant = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 22 
					AND `role_type_id` = 1)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_are_users_tenant, 0, 0)
				;

			# We record the name of this procedure for future debugging and audit_log
				SET @script = 'PROCEDURE - is_tenant';
				SET @timestamp = NOW();

			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user #'
										, @bz_user_id
										, ' is a tenant in the unit #'
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

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table = 'ut_user_group_map_temp';
				SET @permission_granted = 'is an tenant.';

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
					 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
					 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_are_users_tenant, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
					 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
					 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @script = NULL;
				SET @timestamp = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `lambda_notification_case_assignee_updated`(
	IN notification_type varchar(255)
	, IN bz_source_table varchar(240)
	, IN notification_id varchar(255)
	, IN created_datetime datetime
	, IN unit_id smallint(6)
	, IN case_id mediumint(9)
	, IN case_title varchar(255)
	, IN invitor_user_id mediumint(9)
	, IN case_reporter_user_id mediumint(9)
	, IN old_case_assignee_user_id mediumint(9)
	, IN new_case_assignee_user_id mediumint(9)
	, IN current_list_of_invitees mediumtext
	, IN current_status varchar(64)
	, IN current_resolution varchar(64)
	, IN current_severity varchar(64)
	)
    SQL SECURITY INVOKER
BEGIN
	# https://github.com/unee-t/lambda2sns/blob/master/tests/call-lambda-as-root.sh#L5
	#	- DEV/Staging: 812644853088
	#	- Prod: 192458993663
	#	- Demo: 915001051872
	CALL mysql.lambda_async(CONCAT('arn:aws:lambda:ap-southeast-1:915001051872:function:alambda_simple')
		, JSON_OBJECT ('notification_type' , notification_type
			, 'bz_source_table', bz_source_table
			, 'notification_id', notification_id
			, 'created_datetime', created_datetime
			, 'unit_id', unit_id
			, 'case_id', case_id
			, 'case_title', case_title
			, 'invitor_user_id', invitor_user_id
			, 'case_reporter_user_id', case_reporter_user_id
			, 'old_case_assignee_user_id', old_case_assignee_user_id
			, 'new_case_assignee_user_id', new_case_assignee_user_id
			, 'current_list_of_invitees', current_list_of_invitees
			, 'current_status', current_status
			, 'current_resolution', current_resolution
			, 'current_severity', current_severity
			)
		)
		;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `lambda_notification_case_invited`(
	IN notification_type varchar(255)
	, IN bz_source_table varchar(240)
	, IN notification_id varchar(255)
	, IN created_datetime datetime
	, IN unit_id smallint(6)
	, IN case_id mediumint(9)
	, IN case_title varchar(255)
	, IN invitee_user_id mediumint(9)
	, IN case_reporter_user_id mediumint(9)
	, IN old_case_assignee_user_id mediumint(9)
	, IN new_case_assignee_user_id mediumint(9)
	, IN current_list_of_invitees mediumtext
	, IN current_status varchar(64)
	, IN current_resolution varchar(64)
	, IN current_severity varchar(64)
	)
    SQL SECURITY INVOKER
BEGIN
	# https://github.com/unee-t/lambda2sns/blob/master/tests/call-lambda-as-root.sh#L5
	#	- DEV/Staging: 812644853088
	#	- Prod: 192458993663
	#	- Demo: 915001051872
	CALL mysql.lambda_async(CONCAT('arn:aws:lambda:ap-southeast-1:915001051872:function:alambda_simple')
		, JSON_OBJECT ('notification_type', notification_type
			, 'bz_source_table', bz_source_table
			, 'notification_id', notification_id
			, 'created_datetime', created_datetime
			, 'unit_id', unit_id
			, 'case_id', case_id
			, 'case_title', case_title
			, 'invitee_user_id', invitee_user_id
			, 'case_reporter_user_id', case_reporter_user_id
			, 'old_case_assignee_user_id', old_case_assignee_user_id
			, 'new_case_assignee_user_id', new_case_assignee_user_id
			, 'current_list_of_invitees', current_list_of_invitees
			, 'current_status', current_status
			, 'current_resolution', current_resolution
			, 'current_severity', current_severity
			)
		)
		;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `lambda_notification_case_new`(
	IN notification_type varchar(255)
	, IN bz_source_table varchar(240)
	, IN notification_id varchar(255)
	, IN created_datetime datetime
	, IN unit_id smallint(6)
	, IN case_id mediumint(9)
	, IN case_title varchar(255)
	, IN reporter_user_id mediumint(9)
	, IN assignee_user_id mediumint(9)
	, IN current_status varchar(64)
	, IN current_resolution varchar(64)
	, IN current_severity varchar(64)
	)
    SQL SECURITY INVOKER
BEGIN
	# https://github.com/unee-t/lambda2sns/blob/master/tests/call-lambda-as-root.sh#L5
	#	- DEV/Staging: 812644853088
	#	- Prod: 192458993663
	#	- Demo: 915001051872
	CALL mysql.lambda_async(CONCAT('arn:aws:lambda:ap-southeast-1:915001051872:function:alambda_simple')
		, JSON_OBJECT ('notification_type', notification_type
			, 'bz_source_table', bz_source_table
			, 'notification_id', notification_id
			, 'created_datetime', created_datetime
			, 'unit_id', unit_id
			, 'case_id', case_id
			, 'case_title', case_title
			, 'reporter_user_id', reporter_user_id
			, 'assignee_user_id', assignee_user_id
			, 'current_status', current_status
			, 'current_resolution', current_resolution
			, 'current_severity', current_severity
			)
		)
		;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `lambda_notification_case_updated`(
	IN notification_type varchar(255)
	, IN bz_source_table varchar(240)
	, IN notification_id varchar(255)
	, IN created_datetime datetime
	, IN unit_id smallint(6)
	, IN case_id mediumint(9)
	, IN case_title varchar(255)
	, IN user_id mediumint(9)
	, IN update_what varchar(255)
	, IN old_value varchar(255)
	, IN new_value varchar(255)
	, IN case_reporter_user_id mediumint(9)
	, IN old_case_assignee_user_id mediumint(9)
	, IN new_case_assignee_user_id mediumint(9)
	, IN current_list_of_invitees mediumtext
	, IN current_status varchar(64)
	, IN current_resolution varchar(64)
	, IN current_severity varchar(64)
	)
    SQL SECURITY INVOKER
BEGIN
	# https://github.com/unee-t/lambda2sns/blob/master/tests/call-lambda-as-root.sh#L5
	#	- DEV/Staging: 812644853088
	#	- Prod: 192458993663
	#	- Demo: 915001051872
	CALL mysql.lambda_async(CONCAT('arn:aws:lambda:ap-southeast-1:915001051872:function:alambda_simple')
		, JSON_OBJECT ('notification_type', notification_type
			, 'bz_source_table', bz_source_table
			, 'notification_id', notification_id
			, 'created_datetime', created_datetime
			, 'unit_id', unit_id
			, 'case_id', case_id
			, 'case_title', case_title
			, 'user_id', user_id
			, 'update_what', update_what
			, 'old_value', old_value
			, 'new_value', new_value
			, 'case_reporter_user_id', case_reporter_user_id
			, 'old_case_assignee_user_id', old_case_assignee_user_id
			, 'new_case_assignee_user_id', new_case_assignee_user_id
			, 'current_list_of_invitees', current_list_of_invitees
			, 'current_status', current_status
			, 'current_resolution', current_resolution
			, 'current_severity', current_severity
			)
		)
		;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `lambda_notification_message_new_comment`(
	IN notification_type varchar(255)
	, IN bz_source_table varchar(240)
	, IN notification_id varchar(255)
	, IN created_datetime datetime
	, IN unit_id smallint(6)
	, IN case_id mediumint(9)
	, IN case_title varchar(255)
	, IN created_by_user_id mediumint(9)
	, IN message_truncated varchar(255)
	, IN case_reporter_user_id mediumint(9)
	, IN old_case_assignee_user_id mediumint(9)
	, IN new_case_assignee_user_id mediumint(9)
	, IN current_list_of_invitees mediumtext
	, IN current_status varchar(64)
	, IN current_resolution varchar(64)
	, IN current_severity varchar(64)
	)
    SQL SECURITY INVOKER
BEGIN
	# https://github.com/unee-t/lambda2sns/blob/master/tests/call-lambda-as-root.sh#L5
	#	- DEV/Staging: 812644853088
	#	- Prod: 192458993663
	#	- Demo: 915001051872
	CALL mysql.lambda_async(CONCAT('arn:aws:lambda:ap-southeast-1:915001051872:function:alambda_simple')
		, JSON_OBJECT('notification_type', notification_type
			, 'bz_source_table', bz_source_table
			, 'notification_id', notification_id
			, 'created_datetime', created_datetime
			, 'unit_id', unit_id
			, 'case_id', case_id
			, 'case_title', case_title
			, 'created_by_user_id', created_by_user_id
			, 'message_truncated', message_truncated
			, 'case_reporter_user_id', case_reporter_user_id
			, 'old_case_assignee_user_id', old_case_assignee_user_id
			, 'new_case_assignee_user_id', new_case_assignee_user_id
			, 'current_list_of_invitees', current_list_of_invitees
			, 'current_status', current_status
			, 'current_resolution', current_resolution
			, 'current_severity', current_severity
			)
		)
		;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `remove_user_from_default_cc`()
    SQL SECURITY INVOKER
BEGIN
	# This procedure needs the following objects
	#	- Variables:
	#		- @bz_user_id : the BZ user id of the user
	#		- @component_id_this_role: The id of the role in the bz table `components`
	#
	# We delete the record in the table that store default CC information

	# Make sure we have the correct value for the name of this script so the `ut_audit_log_table` has the correct info
		SET @script = 'PROCEDURE remove_user_from_default_cc';

	# We can now do the deletion
		DELETE
		FROM `component_cc`
			WHERE `user_id` = @bz_user_id
				AND `component_id` = @component_id_this_role
		;

	# We get the product id so we can log this properly
		SET @product_id_for_this_procedure = (SELECT `product_id` FROM `components` WHERE `id` = @component_id_this_role);

	# We record the time when	this was done for future debugging and audit_log
			SET @timestamp = NOW();
				
	# Log the actions of the script.
		SET @script_log_message = CONCAT('the bz user #'
								, @bz_user_id
								, ' is NOT in Default CC for the component/role '
								, @component_id_this_role
								, ' for the product/unit '
								, @product_id_for_this_procedure
								);
				
		INSERT INTO `ut_script_log`
			(`datetime`
			, `script`
			, `log`
				)
			VALUES
			(@timestamp, @script, @script_log_message)
			;

	# Cleanup the variables for the log messages
		SET @script_log_message = NULL;
		SET @script = NULL;
		SET @product_id_for_this_procedure = NULL;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `remove_user_from_role`()
    SQL SECURITY INVOKER
BEGIN
	# This procedure needs the following objects
	# This procedure is called by the procedure `add_user_to_role_in_unit`
	#	- Variables:
	#		- @remove_user_from_role
	#		- @component_id_this_role
	#		- @product_id
	#		- @bz_user_id
	#		- @bz_user_id_dummy_user_this_role
	#		- @id_role_type
	#		- @this_script
	#		- @creator_bz_id
	#
	#	 - Tables:
	#		 - `ut_user_group_map_temp`

	# We only do this if this is needed:
	IF (@remove_user_from_role = 1)
	THEN
		# The script which call this procedure, should already calls: 
		# 	- `table_to_list_dummy_user_by_environment`;
		# 	- `remove_user_from_default_cc`
		# There is no need to do this again
		#
		# The script 
		#	- resets the permissions for this user for this role for this unit to the default permissions.
		#	 - removes ALL the permissions for this user.
		#	 - IF user is in CC for any case (open AND Closed) in this unit, 
		#	 THEN 
		#	 - un-invite this user to the cases for this unit
		#	 - Record a message in the case to explain what has been done.
		#	- IF user is the current Default assignee for his role for this unit: 
		#		- Option 1: IF there is another 'Real' user in default CC for this role in this unit, 
		#		 then replace the default assignee for this role with	with the oldest created 'real' user in default CC for this role for this unit.
		#		- Option 2: IF there is NO other 'Real' user in Default CC for this role in this unit BUT
		#			There is at least another 'Real' usser in this role for this unit,	
		#			THEN replace the default assignee for this role with	with the oldest created 'real' user in this role for this unit_id.
		#		- Option 3: IF there is NO other 'Real' user in Default CC for this role in this unit
		#			AND IF there are no other 'Real' usser in this role for this unit
		#			THEN replace the default assignee for this role with	with the dummy user for that unit.
		#	- IF the user is the current assignee to one of the cases in this unit
		#		THEN 
		#		- assigns the case to the newly identifed default assignee for the case.
		#	 	- Record a message in the case to explain what has been done.
		#
	 	
			# We record the name of this procedure for future debugging and audit_log
				SET @script = 'PROCEDURE - remove_user_from_role';
				SET @timestamp = NOW();

			# Revoke all permissions for this user in this unit
				# This procedure needs the following objects:
				#	- Variables:
				#		- @product_id
				#		- @bz_user_id
				CALL `revoke_all_permission_for_this_user_in_this_unit`;
			
			# All the permission have been prepared, we can now update the permissions table
			#		- This NEEDS the table 'ut_user_group_map_temp'
				CALL `update_permissions_invited_user`;

			# Make sure we have the correct value for the name of this script so the `ut_audit_log_table` has the correct info
				SET @script = 'PROCEDURE remove_user_from_role';

			# Add a comment to all the cases where:
			#	- the product/unit is the product/unit we are removing the user from
			#	- The user we are removing is in CC/invited to these bugs/cases
			# to let everyone knows what is happening.

				# Which role is this? (we need that to add meaningfull comments)

					SET @user_role_type_this_role = (SELECT `role_type_id` 
						FROM `ut_product_group`
						WHERE (`component_id` = @component_id_this_role)
							AND (`group_type_id` = 22)
						)
						;

					SET @user_role_type_name = (SELECT `role_type`
						FROM `ut_role_types`
						WHERE `id_role_type` = @user_role_type_this_role
						)
						;

				# Prepare the comment

					SET @comment_remove_user_from_case = (CONCAT ('We removed a user in the role '
						, @user_role_type_name 
						, '. This user was un-invited from the case since he has no more role in this unit.'
						)
					)
					;

				# Insert the comment in all the cases we are touching

					INSERT INTO `longdescs`
						(`bug_id`
						, `who`
						, `bug_when`
						, `thetext`
						)
						SELECT
							`cc`.`bug_id`
							, @creator_bz_id
							, @timestamp
							, @comment_remove_user_from_case
							FROM `bugs`
							INNER JOIN `cc` 
								ON (`cc`.`bug_id` = `bugs`.`bug_id`)
							WHERE (`bugs`.`product_id` = @product_id)	
								AND (`cc`.`who` = @bz_user_id)
							;

				# Record the change in the Bug history for all the cases where:
				#	- the product/unit is the product/unit we are removing the user from
				#	- The user we are removing is in CC/invited to these bugs/cases

					INSERT INTO	`bugs_activity`
						(`bug_id` 
						, `who` 
						, `bug_when`
						, `fieldid`
						, `added`
						, `removed`
						)
						SELECT
							`bugs`.`bug_id`
							, @creator_bz_id
							, @timestamp
							, 22
							, NULL
							, @bz_user_id
							FROM `bugs`
							INNER JOIN `cc` 
								ON (`cc`.`bug_id` = `bugs`.`bug_id`)
							WHERE (`bugs`.`product_id` = @product_id)	
								AND (`cc`.`who` = @bz_user_id)
						;

			# We have done what we needed to record the changes and inform users.
			# We can now remove the user invited to (i.e in CC for) any bugs/cases in the given product/unit.

				DELETE `cc`
				FROM
					`cc`
					LEFT JOIN `bugs` 
						ON (`cc`.`bug_id` = `bugs`.`bug_id`)
					WHERE (`bugs`.`product_id` = @product_id)
						AND (`cc`.`who` = @bz_user_id)
					;
		
		# We need to check if the user we are removing is the current default assignee for this role for this unit.

			# What is the current default assignee for this role/component?

				SET @old_component_initialowner = (SELECT `initialowner` 
					FROM `components` 
					WHERE `id` = @component_id_this_role
					)
					;

			# Is it the same as the current user?

				SET @is_user_default_assignee = IF(@old_component_initialowner = @bz_user_id
					, '1'
					, '0'
					)
					;

			# IF needed, then do the change of default assignee.

				IF @is_user_default_assignee = 1
				THEN
				# We need to 
				# 	- Option 1: IF there is another 'Real' user in default CC for this role in this unit, 
				#			then replace the default assignee for this role with	with the oldest created 'real' user in default CC for this role for this unit.
				# 	- Option 2: IF there is NO other 'Real' user in Default CC for this role in this unit BUT
				#			There is at least another 'Real' usser in this role for this unit,	
				#			THEN replace the default assignee for this role with	with the oldest created 'real' user in this role for this unit_id.
				# 	- Option 3: IF there is NO other 'Real' user in Default CC for this role in this unit
				#			AND IF there are no other 'Real' user in this role for this unit
				#			THEN replace the default assignee with the default dummy user for this role in this unit
				# The variables needed for this are
				#	- @bz_user_id_dummy_user_this_role
				# 	- @component_id_this_role
				#	- @id_role_type
				# 	- @this_script
				#	- @product_id
				#	- @creator_bz_id

					# Which scenario are we in?

						# Do we have at least another real user in default CC for the cases created in this role in this unit?

							SET @oldest_default_cc_this_role = (SELECT MIN(`user_id`)
							FROM `component_cc`
								WHERE `component_id` = @component_id_this_role
								)
								;

							SET @assignee_in_option_1 = IFNULL(@oldest_default_cc_this_role, 0);

							#	Are we going to do the change now?
							
								IF @assignee_in_option_1 !=0
								# yes, we can do the change
								THEN
									# We need to capture the old component description to update the bz_audit_log_table

										SET @old_component_description = (SELECT `description` 
											FROM `components` 
											WHERE `id` = @component_id_this_role
											)
											;

									# We use this user ID as the new default assignee for this component/role

										SET @assignee_in_option_1_name = (SELECT `realname` 
											FROM `profiles` 
											WHERE `userid` = @assignee_in_option_1
											)
											;

									# We can now update the default assignee for this component/role

										UPDATE `components`
											SET `initialowner` = @assignee_in_option_1
												,`description` = @assignee_in_option_1_name
											WHERE `id` = @component_id_this_role
											;

									# We remove this user ID from the list of users in Default CC for this role/component

										DELETE FROM `component_cc`
											WHERE `component_id` = @component_id_this_role
												AND `user_id` = @assignee_in_option_1
												;
										
									# We update the BZ logs
										INSERT	INTO `audit_log`
											(`user_id`
											,`class`
											,`object_id`
											,`field`
											,`removed`
											,`added`
											,`at_time`
											) 
											VALUES 
											(@creator_bz_id, 'Bugzilla::Component', @component_id_this_role, 'initialowner', @bz_user_id, @assignee_in_option_1, @timestamp)
											, (@creator_bz_id, 'Bugzilla::Component', @component_id_this_role, 'description', @old_component_description, @assignee_in_option_1_name, @timestamp)
											;

								END IF;

								IF @assignee_in_option_1 = 0
								# We know that we do NOT have any other user in default CC for this role
								# Do we have another 'Real' user in this role for this unit?
								THEN

									# First we need to find that user...
									# What is the group id for all the users in this role in this unit?

										SET @option_2_group_id_this_role = (SELECT `group_id`
											FROM `ut_product_group`
											WHERE `component_id` = @component_id_this_role
												AND `group_type_id` = 22
												)
											;

									# What is the oldest user in this group who is NOT a dummy user?

										SET @oldest_other_user_in_this_role = (SELECT MIN(`user_id`)
											FROM `user_group_map`
											WHERE `group_id` = @option_2_group_id_this_role
											)
											;

										SET @assignee_in_option_2 = IFNULL(@oldest_default_cc_this_role, 0);

									# Are we going to do the change now?

										IF @assignee_in_option_2 != 0
										# We know that we do NOT have any other user in default CC for this role
										# BUT We know we HAVE another user is this role for this unit.
										THEN

											# We need to capture the old component description to update the bz_audit_log_table

												SET @old_component_description = (SELECT `description` 
													FROM `components` 
													WHERE `id` = @component_id_this_role
													)
													;

											# We use this user ID as the new default assignee for this component/role.

												SET @assignee_in_option_2_name = (SELECT `realname` 
													FROM `profiles` 
													WHERE `userid` = @assignee_in_option_2
													)
													;

											# We can now update the default assignee for this component/role

												UPDATE `components`
													SET `initialowner` = @assignee_in_option_2
														,`description` = @assignee_in_option_2_name
													WHERE `id` = @component_id_this_role
													;
												
											# We update the BZ logs
												INSERT	INTO `audit_log`
													(`user_id`
													,`class`
													,`object_id`
													,`field`
													,`removed`
													,`added`
													,`at_time`
													) 
													VALUES 
													(@creator_bz_id, 'Bugzilla::Component', @component_id_this_role, 'initialowner', @bz_user_id, @assignee_in_option_2, @timestamp)
													, (@creator_bz_id, 'Bugzilla::Component', @component_id_this_role, 'description', @old_component_description, @assignee_in_option_2_name, @timestamp)
													;

										END IF;

										IF @assignee_in_option_2 = 0
										# We know that we do NOT have any other user in default CC for this role
										# We know we do NOT have another user is this role for this unit.
										# We need to use the Default dummy user for this role in this unit.
										THEN

											# We need to capture the old component description to update the bz_audit_log_table

												SET @old_component_description = (SELECT `description` 
													FROM `components` 
													WHERE `id` = @component_id_this_role
													)
													;

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
																		, 'line ... shit what is it again?'
																		)
																	)
																)
															)
														)
													)
													;

												# We can now do the update

													UPDATE `components`
													SET `initialowner` = @bz_user_id_dummy_user_this_role
														,`description` = @dummy_user_role_desc
														WHERE 
														`id` = @component_id_this_role
														;
															
												# We update the BZ logs
													INSERT	INTO `audit_log`
														(`user_id`
														,`class`
														,`object_id`
														,`field`
														,`removed`
														,`added`
														,`at_time`
														) 
														VALUES 
														(@creator_bz_id, 'Bugzilla::Component', @component_id_this_role, 'initialowner', @bz_user_id, @bz_user_id_dummy_user_this_role, @timestamp)
														, (@creator_bz_id, 'Bugzilla::Component', @component_id_this_role, 'description', @old_component_description, @dummy_user_role_desc, @timestamp)
														;
										END IF;
								END IF;
				END IF;

		# IF the user we removed from this unit is the assignee for a case (Open or Closed) in this unit. 
		# THEN make sure we reset the assignee to the default user for this role in this unit.

			# What is the current initial owner for this role in this unit

				SET @component_initialowner = (SELECT `initialowner`
					FROM `components` 
					WHERE `id` = @component_id_this_role
					)
					;

			# Add a comment to the case to let everyone know what is happening.

				# Which role is this? (we need that to add meaningfull comments)

					SET @user_role_type_this_role = (SELECT `role_type_id` 
						FROM `ut_product_group`
						WHERE (`component_id` = @component_id_this_role)
							AND (`group_type_id` = 22)
						)
						;

					SET @user_role_type_name = (SELECT `role_type`
						FROM `ut_role_types`
						WHERE `id_role_type` = @user_role_type_this_role
						)
						;

				# Prepare the comment:

					SET @comment_change_assignee_for_case = (CONCAT ('We removed a user in the role '
							, @user_role_type_name 
							, '. This user cannot be the assignee for this case anymore since he/she has no more role in this unit. We have assigned this case to the default assignee for this role in this unit'
							)
						)
						;

				# Insert the comment in all the cases we are touchingfor for all the cases where:
				#	- the product/unit is the product/unit we are removing the user from
				#	- The user we are removing is the current assignee for these bugs/cases

					INSERT INTO `longdescs`
						(`bug_id`
						, `who`
						, `bug_when`
						, `thetext`
						)
						SELECT
							`bugs`.`bug_id`
							, @creator_bz_id
							, @timestamp
							, @comment_change_assignee_for_case
							FROM `bugs`
							WHERE (`bugs`.`product_id` = @product_id)	
								AND (`bugs`.`assigned_to` = @bz_user_id)
							;

				# Record the change in the Bug history for all the cases where:
				#	- the product/unit is the product/unit we are removing the user from
				#	- The user we are removing is the current assignee for these bugs/cases

					INSERT INTO	`bugs_activity`
						(`bug_id` 
						, `who` 
						, `bug_when`
						, `fieldid`
						, `added`
						, `removed`
						)
						SELECT
							`bugs`.`bug_id`
							, @creator_bz_id
							, @timestamp
							, 16
							, @component_initialowner
							, @bz_user_id
							FROM `bugs`
							WHERE (`bugs`.`product_id` = @product_id)	
								AND (`bugs`.`assigned_to` = @bz_user_id)
						;

				# We can now update the assignee for all the cases 
				#	- in this unit for this PRODUCT/Unit
				#	- currently assigned to the user we are removing from this unit.

					UPDATE `bugs`
						SET `assigned_to` = @component_initialowner
						WHERE `product_id` = @product_id
							AND `assigned_to` = @bz_user_id
						;			

		# We also need to check if the user we are removing is the current qa user for this role for this unit.

			# Get the initial QA contact for this role/component for this product/unit

				SET @old_component_initialqacontact = (SELECT `initialqacontact` 
					FROM `components` 
					WHERE `id` = @component_id_this_role
					)
					;

			# Check if the current QA contact for all the cases in this product/unit is the user we are removing

 				SET @is_user_qa = IF(@old_component_initialqacontact = @bz_user_id
 					, '1'
					, '0'
					)
					;

 			#IF needed, then do the change of default QA contact.

				IF @is_user_qa = 1
				THEN
					# IF the user is the current qa contact
					# We need to 
					# 	- Option 1: IF there is another 'Real' user in default CC for this role in this unit, 
					#			then replace the default assignee for this role with	with the oldest created 'real' user in default CC for this role for this unit.
					# 	- Option 2: IF there is NO other 'Real' user in Default CC for this role in this unit BUT
					#			There is at least another 'Real' usser in this role for this unit,	
					#			THEN replace the default assignee for this role with	with the oldest created 'real' user in this role for this unit_id.
					# 	- Option 3: IF there is NO other 'Real' user in Default CC for this role in this unit
					#			AND IF there are no other 'Real' user in this role for this unit
					#			THEN replace the default assignee with the default dummy user for this role in this unit
					# The variables needed for this are
					#	- @bz_user_id_dummy_user_this_role
					# 	- @component_id_this_role
					#	- @id_role_type
					# 	- @this_script
					#	- @product_id
					#	- @creator_bz_id

					# Which scenario are we in?

						# Do we have at least another real user in default CC for the cases created in this role in this unit?

							SET @oldest_default_cc_this_role = (SELECT MIN(`user_id`)
								FROM `component_cc`
								WHERE `component_id` = @component_id_this_role
								)
								;

							SET @qa_in_option_1 = IFNULL(@oldest_default_cc_this_role, 0);

							#	Are we going to do the change now?
							
								IF @qa_in_option_1 !=0
								# yes, we can do the change
								THEN
									# We use this user ID as the new default assignee for this component/role

										SET @qa_in_option_1_name = (SELECT `realname` 
											FROM `profiles` 
											WHERE `userid` = @qa_in_option_1
											)
											;

										UPDATE `components`
											SET `initialqacontact` = @qa_in_option_1
											WHERE `id` = @component_id_this_role
											;

									# We log the change in the BZ native audit log
										
										INSERT	INTO `audit_log`
											(`user_id`
											,`class`
											,`object_id`
											,`field`
											,`removed`
											,`added`
											,`at_time`
											) 
											VALUES 
											(@creator_bz_id, 'Bugzilla::Component', @component_id_this_role, 'initialqacontact', @bz_user_id, @qa_in_option_1, @timestamp)
											;

								END IF;

								IF @qa_in_option_1 = 0
								# We know that we do NOT have any other user in default CC for this role
								# Do we have another 'Real' user in this role for this unit?
								THEN

									# First we need to find that user...
									# What is the group id for all the users in this role in this unit?

										SET @option_2_group_id_this_role = (SELECT `group_id`
											FROM `ut_product_group`
											WHERE (`component_id` = @component_id_this_role)
												AND (`group_type_id` = 22)
											)
											;

									# What is the oldest user in this group who is NOT a dummy user?

										SET @oldest_other_user_in_this_role = (SELECT MIN(`user_id`)
											FROM `user_group_map`
											WHERE `group_id` = @option_2_group_id_this_role
											)
											;

										SET @qa_in_option_2 = IFNULL(@oldest_default_cc_this_role, 0);

									# Are we going to do the change now?

										IF @qa_in_option_2 != 0
										# We know that we do NOT have any other user in default CC for this role
										# BUT We know we HAVE another user is this role for this unit.
										THEN

											# We use this user ID as the new default assignee for this component/role.

												SET @qa_in_option_2_name = (SELECT `realname` 
													FROM `profiles` 
													WHERE `userid` = @qa_in_option_2
													)
													;

											# We can now update the default assignee for this component/role

												UPDATE `components`
													SET `initialqacontact` = @qa_in_option_2
													WHERE `id` = @component_id_this_role
													;

											# We log the change in the BZ native audit log
											
												INSERT	INTO `audit_log`
													(`user_id`
													,`class`
													,`object_id`
													,`field`
													,`removed`
													,`added`
													,`at_time`
													) 
													VALUES 
													(@creator_bz_id, 'Bugzilla::Component', @component_id_this_role, 'initialqacontact', @bz_user_id, @qa_in_option_2, @timestamp)
													;

										END IF;

										IF @qa_in_option_2 = 0
										# We know that we do NOT have any other user in default CC for this role
										# We know we do NOT have another user is this role for this unit.
										# We need to use the Default dummy user for this role in this unit.
										THEN

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
																	, 'line ... shit what is it again?'
																	)
																)
															)
														)
													)
												)
												;

											# We can now do the update

												UPDATE `components`
												SET `initialqacontact` = @bz_user_id_dummy_user_this_role
													WHERE 
													`id` = @component_id_this_role
													;

											# We log the change in the BZ native audit log
											
												INSERT	INTO `audit_log`
													(`user_id`
													,`class`
													,`object_id`
													,`field`
													,`removed`
													,`added`
													,`at_time`
													) 
													VALUES 
													(@creator_bz_id, 'Bugzilla::Component', @component_id_this_role, 'initialqacontact', @bz_user_id, @bz_user_id_dummy_user_this_role, @timestamp)
													;

										END IF;
								END IF;
				END IF;

	# Housekeeping 
	# Clean up the variables we used specifically for this script

		SET @script = NULL;
		SET @timestamp = NULL;

	END IF;

END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `revoke_all_permission_for_this_user_in_this_unit`()
    SQL SECURITY INVOKER
BEGIN

	# this procedure needs the following variables:
	#	 - @product_id
	#	 - @bz_user_id

	# We record the name of this procedure for future debugging and audit_log
		SET @script = 'PROCEDURE - revoke_all_permission_for_this_user_in_this_unit';
		SET @timestamp = NOW();

	# We need to get the group_id for this unit

		SET @can_see_time_tracking_group_id = 16;
		SET @can_create_shared_queries_group_id = 17;
		SET @can_tag_comment_group_id = 18;	
	
		SET @create_case_group_id =	(SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 20));
		SET @can_edit_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 25));
		SET @can_see_cases_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 28));
	
		SET @can_edit_all_field_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 26));
		
		SET @can_see_unit_in_search_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 38));

		SET @list_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 4));
		SET @see_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 5));	

		SET @all_r_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 18));
		SET @all_g_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 19));

		SET @group_id_show_to_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 24));
		SET @group_id_are_users_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 3));
		SET @group_id_see_users_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 36));

		SET @group_id_show_to_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 1));
		SET @group_id_are_users_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 1));
		SET @group_id_see_users_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 1));

		SET @group_id_show_to_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 2));
		SET @group_id_are_users_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 2));
		SET @group_id_see_users_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 2));

		SET @group_id_show_to_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 5));
		SET @group_id_are_users_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 5));
		SET @group_id_see_users_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 5));

		SET @group_id_show_to_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 3));
		SET @group_id_are_users_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 3));
		SET @group_id_see_users_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 3));

		SET @group_id_show_to_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 4));
		SET @group_id_are_users_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 4));
		SET @group_id_see_users_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 4));

	# We can now remove all the permissions for this unit.

		DELETE FROM `user_group_map`
			WHERE (
				(`user_id` = @bz_user_id AND `group_id` = @can_see_time_tracking_group_id)
				OR (`user_id` = @bz_user_id AND `group_id` = @can_create_shared_queries_group_id)
				OR (`user_id` = @bz_user_id AND `group_id` = @can_tag_comment_group_id)
				OR (`user_id` = @bz_user_id AND `group_id` = @create_case_group_id)
				OR (`user_id` = @bz_user_id AND `group_id` = @can_edit_case_group_id)
				OR (`user_id` = @bz_user_id AND `group_id` = @can_see_cases_group_id)
				OR (`user_id` = @bz_user_id AND `group_id` = @can_edit_all_field_case_group_id)
				OR (`user_id` = @bz_user_id AND `group_id` = @can_see_unit_in_search_group_id)
				OR (`user_id` = @bz_user_id AND `group_id` = @list_visible_assignees_group_id)
				OR (`user_id` = @bz_user_id AND `group_id` = @see_visible_assignees_group_id)
				OR (`user_id` = @bz_user_id AND `group_id` = @all_r_flags_group_id)
				OR (`user_id` = @bz_user_id AND `group_id` = @all_g_flags_group_id)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_show_to_occupant)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_are_users_occupant)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_see_users_occupant)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_show_to_tenant)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_are_users_tenant)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_see_users_tenant)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_show_to_landlord)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_are_users_landlord)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_see_users_landlord)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_show_to_agent)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_are_users_agent)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_see_users_agent)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_show_to_contractor)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_are_users_contractor)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_see_users_contractor)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_show_to_mgt_cny)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_are_users_mgt_cny)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_see_users_mgt_cny)
				)
				;

		# We also delete from the table `ut_user_group_map_temp`
		# This is needed so we do not re-create the permissions when we invite a new user or create a new unit.

			DELETE FROM `ut_user_group_map_temp`
				WHERE (
					(`user_id` = @bz_user_id AND `group_id` = @can_see_time_tracking_group_id)
					OR (`user_id` = @bz_user_id AND `group_id` = @can_create_shared_queries_group_id)
					OR (`user_id` = @bz_user_id AND `group_id` = @can_tag_comment_group_id)
					OR (`user_id` = @bz_user_id AND `group_id` = @create_case_group_id)
					OR (`user_id` = @bz_user_id AND `group_id` = @can_edit_case_group_id)
					OR (`user_id` = @bz_user_id AND `group_id` = @can_see_cases_group_id)
					OR (`user_id` = @bz_user_id AND `group_id` = @can_edit_all_field_case_group_id)
					OR (`user_id` = @bz_user_id AND `group_id` = @can_see_unit_in_search_group_id)
					OR (`user_id` = @bz_user_id AND `group_id` = @list_visible_assignees_group_id)
					OR (`user_id` = @bz_user_id AND `group_id` = @see_visible_assignees_group_id)
					OR (`user_id` = @bz_user_id AND `group_id` = @all_r_flags_group_id)
					OR (`user_id` = @bz_user_id AND `group_id` = @all_g_flags_group_id)
					OR (`user_id` = @bz_user_id AND `group_id` = @group_id_show_to_occupant)
					OR (`user_id` = @bz_user_id AND `group_id` = @group_id_are_users_occupant)
					OR (`user_id` = @bz_user_id AND `group_id` = @group_id_see_users_occupant)
					OR (`user_id` = @bz_user_id AND `group_id` = @group_id_show_to_tenant)
					OR (`user_id` = @bz_user_id AND `group_id` = @group_id_are_users_tenant)
					OR (`user_id` = @bz_user_id AND `group_id` = @group_id_see_users_tenant)
					OR (`user_id` = @bz_user_id AND `group_id` = @group_id_show_to_landlord)
					OR (`user_id` = @bz_user_id AND `group_id` = @group_id_are_users_landlord)
					OR (`user_id` = @bz_user_id AND `group_id` = @group_id_see_users_landlord)
					OR (`user_id` = @bz_user_id AND `group_id` = @group_id_show_to_agent)
					OR (`user_id` = @bz_user_id AND `group_id` = @group_id_are_users_agent)
					OR (`user_id` = @bz_user_id AND `group_id` = @group_id_see_users_agent)
					OR (`user_id` = @bz_user_id AND `group_id` = @group_id_show_to_contractor)
					OR (`user_id` = @bz_user_id AND `group_id` = @group_id_are_users_contractor)
					OR (`user_id` = @bz_user_id AND `group_id` = @group_id_see_users_contractor)
					OR (`user_id` = @bz_user_id AND `group_id` = @group_id_show_to_mgt_cny)
					OR (`user_id` = @bz_user_id AND `group_id` = @group_id_are_users_mgt_cny)
					OR (`user_id` = @bz_user_id AND `group_id` = @group_id_see_users_mgt_cny)
					)
					;

			# Log the actions of the script.

				SET @script_log_message = CONCAT('We have revoked all the permissions for the bz user #'
										, @bz_user_id
										, '\r\- can_see_time_tracking: 0'
										, '\r\- can_create_shared_queries: 0'
										, '\r\- can_tag_comment: 0'
										, '\r\- can_create_case: 0'
										, '\r\- can_edit_a_case: 0'
										, '\r\- can_see_cases: 0'
										, '\r\- can_edit_all_field_in_a_case_regardless_of_role: 0'
										, '\r\- can_see_unit_in_search: 0'
										, '\r\- user_can_see_publicly_visible: 0'
										, '\r\- user_is_publicly_visible: 0'
										, '\r\- can_ask_to_approve: 0'
										, '\r\- can_approve: 0'
										, '\r\- show_to_occupant: 0'
										, '\r\- are_users_occupant: 0'
										, '\r\- see_users_occupant: 0'
										, '\r\- show_to_tenant: 0'
										, '\r\- are_users_tenant: 0'
										, '\r\- see_users_tenant: 0'
										, '\r\- show_to_landlord: 0'
										, '\r\- are_users_landlord: 0'
										, '\r\- see_users_landlord: 0'
										, '\r\- show_to_agent: 0'
										, '\r\- are_users_agent: 0'
										, '\r\- see_users_agent: 0'
										, '\r\- show_to_contractor: 0'
										, '\r\- are_users_contractor: 0'
										, '\r\- see_users_contractor: 0'
										, '\r\- show_to_mgt_cny: 0'
										, '\r\- are_users_mgt_cny: 0'
										, '\r\- see_users_mgt_cny: 0'
										, '\r\For the product #'
										, @product_id										
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

END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `show_to_agent`()
    SQL SECURITY INVOKER
BEGIN
	IF (@id_role_type = 5)
	THEN 
		# Get the information about the group which grant this permission
			SET @group_id_show_to_agent = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 2 
					AND `role_type_id` = 5)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_show_to_agent, 0, 0)
				;

		# We record the name of this procedure for future debugging and audit_log
			SET @script = 'PROCEDURE - show_to_agent';
			SET @timestamp = NOW();

		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' CAN see case that are limited to agents'
									, ' for the unit #'
									, @product_id
									, '.'
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;

		# We log what we have just done into the `ut_audit_log` table
			
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'CAN see case that are limited to agents.';

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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_show_to_agent, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
			 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `show_to_contractor`()
    SQL SECURITY INVOKER
BEGIN
	IF (@id_role_type = 3)
	THEN 
		# Get the information about the group which grant this permission
			SET @group_id_show_to_contractor = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 2 
					AND `role_type_id` = 3)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_show_to_contractor, 0, 0)
				;

		# We record the name of this procedure for future debugging and audit_log
			SET @script = 'PROCEDURE - show_to_contractor';
			SET @timestamp = NOW();

		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' CAN see case that are limited to contractors'
									, ' for the unit #'
									, @product_id
									, '.'
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;

		# We log what we have just done into the `ut_audit_log` table
				
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'CAN see case that are limited to contractors.';

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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_show_to_contractor, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `show_to_landlord`()
    SQL SECURITY INVOKER
BEGIN
	IF (@id_role_type = 2)
	THEN 
		# Get the information about the group which grant this permission
			SET @group_id_show_to_landlord = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 2 
					AND `role_type_id` = 2)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_show_to_landlord, 0, 0)
				;

		# We record the name of this procedure for future debugging and audit_log
			SET @script = 'PROCEDURE - show_to_landlord';
			SET @timestamp = NOW();

		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' CAN see case that are limited to landlords'
									, ' for the unit #'
									, @product_id
									, '.'
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;
			# We log what we have just done into the `ut_audit_log` table
			
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'CAN see case that are limited to landlords.';
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_show_to_landlord, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `show_to_mgt_cny`()
    SQL SECURITY INVOKER
BEGIN
	IF (@id_role_type = 4)
	THEN 
		# Get the information about the group which grant this permission
			SET @group_id_show_to_mgt_cny = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 2 
					AND `role_type_id` = 4)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_show_to_mgt_cny, 0, 0)
				;

		# We record the name of this procedure for future debugging and audit_log
			SET @script = 'PROCEDURE - show_to_mgt_cny';
			SET @timestamp = NOW();

		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' CAN see case that are limited to Mgt Cny'
									, ' for the unit #'
									, @product_id
									, '.'
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;

		# We log what we have just done into the `ut_audit_log` table
			
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'CAN see case that are limited to Mgt Cny.';

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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_show_to_mgt_cny, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `show_to_occupant`()
    SQL SECURITY INVOKER
BEGIN
	IF (@is_occupant = 1)
	THEN 
		# Get the information about the group which grant this permission
			SET @group_id_show_to_occupant = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
				AND `group_type_id` = 24)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_show_to_occupant, 0, 0)
				;

		# We record the name of this procedure for future debugging and audit_log
			SET @script = 'PROCEDURE - show_to_occupant';
			SET @timestamp = NOW();

		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' CAN see case that are limited to occupants'
									, ' for the unit #'
									, @product_id
									, '.'
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;

		# We log what we have just done into the `ut_audit_log` table
				
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'CAN see case that are limited to occupants.';

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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_show_to_occupant, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `show_to_tenant`()
    SQL SECURITY INVOKER
BEGIN
	IF (@id_role_type = 1)
	THEN 
		# Get the information about the group which grant this permission
			SET @group_id_show_to_tenant = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 2 
					AND `role_type_id` = 1)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @group_id_show_to_tenant, 0, 0)
				;

			# We record the name of this procedure for future debugging and audit_log
				SET @script = 'PROCEDURE - show_to_tenant';
				SET @timestamp = NOW();
				
			# Log the actions of the script.
				SET @script_log_message = CONCAT('the bz user #'
										, @bz_user_id
										, ' CAN see case that are limited to tenants'
										, ' for the unit #'
										, @product_id
										, '.'
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(@timestamp, @script, @script_log_message)
					;

			# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table = 'ut_user_group_map_temp';
				SET @permission_granted = 'CAN see case that are limited to tenants.';

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
					 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
					 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @group_id_show_to_tenant, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
					 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
					 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @script = NULL;
				SET @timestamp = NULL;
				SET @bzfe_table = NULL;
				SET @permission_granted = NULL;
END IF ;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `table_to_list_dummy_user_by_environment`()
    SQL SECURITY INVOKER
BEGIN

	# We create a temporary table to record the ids of the dummy users in each environments:
		/*Table structure for table `ut_temp_dummy_users_for_roles` */
			DROP TEMPORARY TABLE IF EXISTS `ut_temp_dummy_users_for_roles`;

			CREATE TEMPORARY TABLE `ut_temp_dummy_users_for_roles` (
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
			INSERT INTO `ut_temp_dummy_users_for_roles`(`environment_id`, `environment_name`, `tenant_id`, `landlord_id`, `contractor_id`, `mgt_cny_id`, `agent_id`) values 
				(1, 'DEV/Staging', 96, 94, 93, 95, 92),
				(2, 'Prod', 93, 91, 90, 92, 89),
				(3, 'demo/dev', 4, 3, 5, 6, 2);

END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `unit_create_with_dummy_users`()
    SQL SECURITY INVOKER
BEGIN
	# This procedure needs the following objects:
	#	- variables:
	#		- @mefe_unit_id
	#		- @mefe_unit_id_int_value
	#		- @environment
	#
	# This procedure needs the following info in the table `ut_data_to_create_units`
	#	- id_unit_to_create
	#	- mefe_unit_id
	#	- mefe_unit_id_int_value
	#	- mefe_creator_user_id
	#	- bzfe_creator_user_id
	#	- classification_id
	#	- unit_name
	#	- unit_description_details
	# 
	# This procedure will create
	#	- The unit
	#	- All the objects needed by the unit
	#		- Milestone
	#		- Version
	# 		- Groups
	#		- Flagtypes
	#		- All 5 roles/components with a dummy user for the relevant environment
	#			- Tenant
	#			- Landlord
	#			- Contractor
	#			- Management Company
	#			- Agent
	#		- Assign the permission so we can do what we need
	#		- Log the group_id that we have created so we can assign permissions later
	#
	# This procedure will update the following information:
	#	-  in the table `ut_data_to_create_units`
	#		- bz_created_date
	#		- comment
	#		- product_id	
	#	- the Unee-T script log
	#	- BZ db table `audit_log`
	#
	# This procedure depends on the following procedures:
	#	- `table_to_list_dummy_user_by_environment`
	
	# What is the record that we need to use to create the objects in BZ?
		SET @unit_reference_for_import = (SELECT `id_unit_to_create` FROM `ut_data_to_create_units` WHERE `mefe_unit_id` = @mefe_unit_id);
	
	# We record the name of this procedure for future debugging and audit_log
		SET @script = 'PROCEDURE - unit_create_with_dummy_users';
		SET @timestamp = NOW();

	# We create a temporary table to record the ids of the dummy users in each environments:

		CALL `table_to_list_dummy_user_by_environment`;

	# We create the temporary tables to update the group permissions
		CALL `create_temp_table_to_update_group_permissions`;
	
	# We create the temporary tables to update the user permissions
		CALL `create_temp_table_to_update_permissions`;
			
	# Get the BZ profile id of the dummy users based on the environment variable
		# Tenant 1
			SET @bz_user_id_dummy_tenant = (SELECT `tenant_id` FROM `ut_temp_dummy_users_for_roles` WHERE `environment_id` = @environment);
		
		# Landlord 2
			SET @bz_user_id_dummy_landlord = (SELECT `landlord_id` FROM `ut_temp_dummy_users_for_roles` WHERE `environment_id` = @environment);
			
		# Contractor 3
			SET @bz_user_id_dummy_contractor = (SELECT `contractor_id` FROM `ut_temp_dummy_users_for_roles` WHERE `environment_id` = @environment);
			
		# Management company 4
			SET @bz_user_id_dummy_mgt_cny = (SELECT `mgt_cny_id` FROM `ut_temp_dummy_users_for_roles` WHERE `environment_id` = @environment);
			
		# Agent 5
			SET @bz_user_id_dummy_agent = (SELECT `agent_id` FROM `ut_temp_dummy_users_for_roles` WHERE `environment_id` = @environment);

	# The unit:
		# BZ Classification id for the unit that you want to create (default is 2)
			SET @classification_id = (SELECT `classification_id` FROM `ut_data_to_create_units` WHERE `id_unit_to_create` = @unit_reference_for_import);
		
		# The name and description
			SET @unit_name = (SELECT `unit_name` FROM `ut_data_to_create_units` WHERE `id_unit_to_create` = @unit_reference_for_import);
			SET @unit_description_details = (SELECT `unit_description_details` FROM `ut_data_to_create_units` WHERE `id_unit_to_create` = @unit_reference_for_import);
			SET @unit_description = @unit_description_details;
		
	# The users associated to this unit.	
		# BZ user id of the user that is creating the unit (default is 1 - Administrator).
		# For LMB migration, we use 2 (support.nobody)
			SET @creator_bz_id = (SELECT `bzfe_creator_user_id` FROM `ut_data_to_create_units` WHERE `id_unit_to_create` = @unit_reference_for_import);
		
	# Other important information that should not change:
			SET @visibility_explanation_1 = 'Visible only to ';
			SET @visibility_explanation_2 = ' for this unit.';

	# The global permission for the application

	# This should not change, it was hard coded when we created Unee-T
		# Can tag comments
			SET @can_tag_comment_group_id = 18;	
		
	# We need to create the component for ALL the roles.
	# We do that using dummy users for all the roles different from the user role.	
	#		- agent -> temporary.agent.dev@unee-t.com
	#		- landlord  -> temporary.landlord.dev@unee-t.com
	#		- Tenant  -> temporary.tenant.dev@unee-t.com
	#		- Contractor  -> temporary.contractor.dev@unee-t.com
	# We populate the additional variables that we will need for this script to work
		# For the product
		
			# We are predicting the product id to avoid name duplicates
					SET @predicted_product_id = ((SELECT MAX(`id`) FROM `products`) + 1);

			# We need a unique unit name
				SET @unit_bz_name = CONCAT(@unit_name, '-', @predicted_product_id);

			# We need a default milestone for that unit
				SET @default_milestone = '---';

			# We need a default version for that unit
				SET @default_version = '---';
			
	# We now create the unit we need.

		# Make sure we have the correct value for the name of this script so the `ut_audit_log_table` has the correct info
			SET @script = 'PROCEDURE unit_create_with_dummy_users';

		# Insert the new product into the `products table`
			INSERT INTO `products`
				(`name`
				, `classification_id`
				, `description`
				, `isactive`
				, `defaultmilestone`
				, `allows_unconfirmed`
				)
				VALUES
				(@unit_bz_name, @classification_id, @unit_description, 1, @default_milestone, 1);
	
		# Get the actual id that was created for that unit
			SET @product_id = (SELECT LAST_INSERT_ID());

		# Log the actions of the script.
			SET @script_log_message = CONCAT('A new unit #'
									, (SELECT IFNULL(@product_id, 'product_id is NULL'))
									, ' with the predicted product_id # '
									, @predicted_product_id
									, ' ('
									, (SELECT IFNULL(@unit_bz_name, 'unit is NULL'))
									, ') '
									, ' has been created in the classification: '
									, (SELECT IFNULL(@classification_id, 'classification_id is NULL'))
									, '\r\The bz user #'
									, (SELECT IFNULL(@creator_bz_id, 'creator_bz_id is NULL'))
									, ' (real name: '
									, (SELECT IFNULL(@creator_pub_name, 'creator_pub_name is NULL'))
									, ') '
									, 'is the CREATOR of that unit.'
									)
									;
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(NOW(), @script, @script_log_message)
				;
			
			SET @script_log_message = NULL;

	# We can now get the real id of the unit

		SET @unit = CONCAT(@unit_bz_name, '-', @product_id);

	# We log this in the `audit_log` table
		
		INSERT INTO `audit_log` 
			(`user_id`
			, `class`
			, `object_id`
			, `field`
			, `removed`
			, `added`
			, `at_time`
			)
			VALUES
			(@creator_bz_id
			, 'Bugzilla::Product'
			, @product_id
			, '__create__'
			, NULL
			, @unit
			, @timestamp
			)
			;

	# We prepare all the names we will need

		SET @unit_for_query = REPLACE(@unit, ' ', '%');
		
		SET @unit_for_flag = REPLACE(@unit_for_query, '%', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '-', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '!', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '@', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '#', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '$', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '%', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '^', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '' , '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '&', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '*', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '(', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, ')', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '+', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '=', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '<', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '>', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, ':', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, ';', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '"', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, ', ', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '.', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '?', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '/', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '\\', '_');
		
		SET @unit_for_group = REPLACE(@unit_for_flag, '_', '-');
		SET @unit_for_group = REPLACE(@unit_for_group, '----', '-');
		SET @unit_for_group = REPLACE(@unit_for_group, '---', '-');
		SET @unit_for_group = REPLACE(@unit_for_group, '--', '-');

		# We need a version for this product

			# Make sure we have the correct value for the name of this script so the `ut_audit_log_table` has the correct info
				SET @script = 'PROCEDURE unit_create_with_dummy_users';
	
			# We can now insert the version there
				INSERT INTO `versions`
					(`value`
					, `product_id`
					, `isactive`
					)
					VALUES
					(@default_version, @product_id, 1)
					;

			# We get the id for the version 
				SET @version_id = (SELECT LAST_INSERT_ID());

			# We also log this in the `audit_log` table
					
						INSERT INTO `audit_log` 
							(`user_id`
							, `class`
							, `object_id`
							, `field`
							, `removed`
							, `added`
							, `at_time`
							)
							VALUES
							(@creator_bz_id
							, 'Bugzilla::Version'
							, @version_id
							, '__create__'
							, NULL
							, @default_version
							, @timestamp
							)
							;
					
		# We now create the milestone for this product.

			# Make sure we have the correct value for the name of this script so the `ut_audit_log_table` has the correct info
				SET @script = 'PROCEDURE unit_create_with_dummy_users';

			# We can now insert the milestone there
				INSERT INTO `milestones`
					(`product_id`
					, `value`
					, `sortkey`
					, `isactive`
					)
					VALUES
					(@product_id, @default_milestone, 0 , 1)
					;
				
			# We get the id for the milestone 
				SET @milestone_id = (SELECT LAST_INSERT_ID());

			# We also log this in the `audit_log` table
				INSERT INTO `audit_log` 
					(`user_id`
					, `class`
					, `object_id`
					, `field`
					, `removed`
					, `added`
					, `at_time`
					)
					VALUES
					(@creator_bz_id, 'Bugzilla::Milestone', @milestone_id, '__create__', NULL, @default_milestone, @timestamp)
					;

	#  We create all the components/roles we need
		# For the temporary users:
			# Tenant
				SET @role_user_g_description_tenant = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`= 1);
				SET @user_pub_name_tenant = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_tenant);
				SET @role_user_pub_info_tenant = CONCAT(@user_pub_name_tenant
													, ' - '
													, 'THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL '
													, @role_user_g_description_tenant
													, ' TO THIS UNIT'
													);
				SET @user_role_desc_tenant = @role_user_pub_info_tenant;

			# Landlord
				SET @role_user_g_description_landlord = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`= 2);
				SET @user_pub_name_landlord = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_landlord);
				SET @role_user_pub_info_landlord = CONCAT(@user_pub_name_landlord
													, ' - '
													, 'THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL '
													, @role_user_g_description_landlord
													, ' TO THIS UNIT'
													);
				SET @user_role_desc_landlord = @role_user_pub_info_landlord;
			
			# Agent
				SET @role_user_g_description_agent = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`= 5);
				SET @user_pub_name_agent = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_agent);
				SET @role_user_pub_info_agent = CONCAT(@user_pub_name_agent
													, ' - '
													, 'THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL '
													, @role_user_g_description_agent
													, ' TO THIS UNIT'
													);
				SET @user_role_desc_agent = @role_user_pub_info_agent;
			
			# Contractor
				SET @role_user_g_description_contractor = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`= 3);
				SET @user_pub_name_contractor = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_contractor);
				SET @role_user_pub_info_contractor = CONCAT(@user_pub_name_contractor
													, ' - '
													, 'THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL '
													, @role_user_g_description_contractor
													, ' TO THIS UNIT'
													);
				SET @user_role_desc_contractor = @role_user_pub_info_contractor;
			
			# Management Company
				SET @role_user_g_description_mgt_cny = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`= 4);
				SET @user_pub_name_mgt_cny = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_mgt_cny);
				SET @role_user_pub_info_mgt_cny = CONCAT(@user_pub_name_mgt_cny
													, ' - '
													, 'THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL '
													, @role_user_g_description_mgt_cny
													, ' TO THIS UNIT'
													);
				SET @user_role_desc_mgt_cny = @role_user_pub_info_mgt_cny;

		# We have eveything, we can create the components we need:
		# We insert the component 1 by 1 to get the id for each component easily

		# Make sure we have the correct value for the name of this script so the `ut_audit_log_table` has the correct info
			SET @script = 'PROCEDURE unit_create_with_dummy_users';

			# Tenant (component_id_tenant)
				INSERT INTO `components`
					(`name`
					, `product_id`
					, `initialowner`
					, `initialqacontact`
					, `description`
					, `isactive`
					) 
					VALUES
					(@role_user_g_description_tenant
					, @product_id
					, @bz_user_id_dummy_tenant
					, @bz_user_id_dummy_tenant
					, @user_role_desc_tenant
					, 1
					)
					;

				# We get the id for the component for the tenant 
					SET @component_id_tenant = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('The following component #'
											, @component_id_tenant
											, ' was created for the unit # '
											, @product_id
											, ' Temporary user #'
											, (SELECT IFNULL(@bz_user_id_dummy_tenant, 'bz_user_id is NULL'))
											, ' (real name: '
											, (SELECT IFNULL(@user_pub_name_tenant, 'user_pub_name is NULL'))
											, '. This user is the default assignee for this role for that unit).'
											, ' is the '
											, 'tenant:'
											, '\r\- '
											, (SELECT IFNULL(@role_user_g_description_tenant, 'role_user_g_description is NULL'))
											, ' (role_type_id #'
											, '1'
											, ') '
											)
											;
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;	

			# Landlord (component_id_landlord)
				INSERT INTO `components`
					(`name`
					, `product_id`
					, `initialowner`
					, `initialqacontact`
					, `description`
					, `isactive`
					) 
					VALUES
					(@role_user_g_description_landlord
					, @product_id
					, @bz_user_id_dummy_landlord
					, @bz_user_id_dummy_landlord
					, @user_role_desc_landlord
					, 1
					)
					;

				# We get the id for the component for the Landlord
					SET @component_id_landlord = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('The following component #'
											, @component_id_landlord
											, ' was created for the unit # '
											, @product_id
											, ' Temporary user #'
											, (SELECT IFNULL(@bz_user_id_dummy_landlord, 'bz_user_id is NULL'))
											, ' (real name: '
											, (SELECT IFNULL(@user_pub_name_landlord, 'user_pub_name is NULL'))
											, '. This user is the default assignee for this role for that unit).'
											, ' is the '
											, 'Landlord:'
											, '\r\- '
											, (SELECT IFNULL(@role_user_g_description_landlord, 'role_user_g_description is NULL'))
											, ' (role_type_id #'
											, '2'
											, ') '
											)
											;
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;	

			# Agent (component_id_agent)
				INSERT INTO `components`
					(`name`
					, `product_id`
					, `initialowner`
					, `initialqacontact`
					, `description`
					, `isactive`
					) 
					VALUES
					(@role_user_g_description_agent
					, @product_id
					, @bz_user_id_dummy_agent
					, @bz_user_id_dummy_agent
					, @user_role_desc_agent
					, 1
					)
					;
			
				# We get the id for the component for the Agent
					SET @component_id_agent = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('The following component #'
											, @component_id_agent
											, ' was created for the unit # '
											, @product_id
											, ' Temporary user #'
											, (SELECT IFNULL(@bz_user_id_dummy_agent, 'bz_user_id is NULL'))
											, ' (real name: '
											, (SELECT IFNULL(@user_pub_name_agent, 'user_pub_name is NULL'))
											, '. This user is the default assignee for this role for that unit).'
											, ' is the '
											, 'Agent:'
											, '\r\- '
											, (SELECT IFNULL(@role_user_g_description_agent, 'role_user_g_description is NULL'))
											, ' (role_type_id #'
											, '5'
											, ') '
											)
											;
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;	

			# Contractor (component_id_contractor)
				INSERT INTO `components`
					(`name`
					, `product_id`
					, `initialowner`
					, `initialqacontact`
					, `description`
					, `isactive`
					) 
					VALUES
					(@role_user_g_description_contractor
					, @product_id
					, @bz_user_id_dummy_contractor
					, @bz_user_id_dummy_contractor
					, @user_role_desc_contractor
					, 1
					)
					;
			
				# We get the id for the component for the Contractor
					SET @component_id_contractor = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('The following component #'
											, @component_id_contractor
											, ' was created for the unit # '
											, @product_id
											, ' Temporary user #'
											, (SELECT IFNULL(@bz_user_id_dummy_contractor, 'bz_user_id is NULL'))
											, ' (real name: '
											, (SELECT IFNULL(@user_pub_name_contractor, 'user_pub_name is NULL'))
											, '. This user is the default assignee for this role for that unit).'
											, ' is the '
											, 'Contractor:'
											, '\r\- '
											, (SELECT IFNULL(@role_user_g_description_contractor, 'role_user_g_description is NULL'))
											, ' (role_type_id #'
											, '3'
											, ') '
											)
											;
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;	
			
			# Management Company (component_id_mgt_cny)
				INSERT INTO `components`
					(`name`
					, `product_id`
					, `initialowner`
					, `initialqacontact`
					, `description`
					, `isactive`
					) 
					VALUES
					(@role_user_g_description_mgt_cny
					, @product_id
					, @bz_user_id_dummy_mgt_cny
					, @bz_user_id_dummy_mgt_cny
					, @user_role_desc_mgt_cny
					, 1
					)
					;
			
				# We get the id for the component for the Management Company 
					SET @component_id_mgt_cny = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('The following component #'
											, @component_id_mgt_cny
											, ' was created for the unit # '
											, @product_id
											, ' Temporary user #'
											, (SELECT IFNULL(@bz_user_id_dummy_mgt_cny, 'bz_user_id is NULL'))
											, ' (real name: '
											, (SELECT IFNULL(@user_pub_name_mgt_cny, 'user_pub_name is NULL'))
											, '. This user is the default assignee for this role for that unit).'
											, ' is the '
											, 'Management Company:'
											, '\r\- '
											, (SELECT IFNULL(@role_user_g_description_mgt_cny, 'role_user_g_description is NULL'))
											, ' (role_type_id #'
											, '4'
											, ') '
											)
											;
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;
					
			# We update the BZ logs
				INSERT INTO `audit_log`
					(`user_id`
					, `class`
					, `object_id`
					, `field`
					, `removed`
					, `added`
					, `at_time`
					) 
					VALUES 
					(@creator_bz_id, 'Bugzilla::Component', @component_id_tenant, '__create__', NULL, @role_user_g_description_tenant, @timestamp)
					, (@creator_bz_id, 'Bugzilla::Component', @component_id_landlord, '__create__', NULL, @role_user_g_description_landlord, @timestamp)
					, (@creator_bz_id, 'Bugzilla::Component', @component_id_agent, '__create__', NULL, @role_user_g_description_agent, @timestamp)
					, (@creator_bz_id, 'Bugzilla::Component', @component_id_contractor, '__create__', NULL, @role_user_g_description_contractor, @timestamp)
					, (@creator_bz_id, 'Bugzilla::Component', @component_id_mgt_cny, '__create__', NULL, @role_user_g_description_mgt_cny, @timestamp)
					;

	# We create the goups we need
		# For simplicity reason, it is better to create ALL the groups we need for all the possible roles and permissions
		# This will avoid a scenario where we need to grant permission to see occupants for instances but the group for occupants does not exist yet...
		
		# We prepare the information for each group that we will use to do that
		
			# Groups common to all components/roles for this unit
				# Allow user to create a case for this unit
					SET @group_name_create_case_group = (CONCAT(@unit_for_group, '-01-Can-Create-Cases'));
					SET @group_description_create_case_group = 'User can create cases for this unit.';
					
				# Allow user to create a case for this unit
					SET @group_name_can_edit_case_group = (CONCAT(@unit_for_group, '-01-Can-Edit-Cases'));
					SET @group_description_can_edit_case_group = 'User can edit a case they have access to';
					
				# Allow user to see the cases for this unit
					SET @group_name_can_see_cases_group = (CONCAT(@unit_for_group, '-02-Case-Is-Visible-To-All'));
					SET @group_description_can_see_cases_group = 'User can see the public cases for the unit';
					
				# Allow user to edit all fields in the case for this unit regardless of his/her role
					SET @group_name_can_edit_all_field_case_group = (CONCAT(@unit_for_group, '-03-Can-Always-Edit-all-Fields'));
					SET @group_description_can_edit_all_field_case_group = 'Triage - User can edit all fields in a case they have access to, regardless of role';
					
				# Allow user to edit all the fields in a case, regardless of user role for this unit
					SET @group_name_can_edit_component_group = (CONCAT(@unit_for_group, '-04-Can-Edit-Components'));
					SET @group_description_can_edit_component_group = 'User can edit components/roles for the unit';
					
				# Allow user to see the unit in the search
					SET @group_name_can_see_unit_in_search_group = (CONCAT(@unit_for_group, '-00-Can-See-Unit-In-Search'));
					SET @group_description_can_see_unit_in_search_group = 'User can see the unit in the search panel';
					
			# The groups related to Flags
				# Allow user to  for this unit
					SET @group_name_all_g_flags_group = (CONCAT(@unit_for_group, '-05-Can-Approve-All-Flags'));
					SET @group_description_all_g_flags_group = 'User can approve all flags';
					
				# Allow user to  for this unit
					SET @group_name_all_r_flags_group = (CONCAT(@unit_for_group, '-05-Can-Request-All-Flags'));
					SET @group_description_all_r_flags_group = 'User can request a Flag to be approved';
					
				
			# The Groups that control user visibility
				# Allow user to  for this unit
					SET @group_name_list_visible_assignees_group = (CONCAT(@unit_for_group, '-06-List-Public-Assignee'));
					SET @group_description_list_visible_assignees_group = 'User are visible assignee(s) for this unit';
					
				# Allow user to  for this unit
					SET @group_name_see_visible_assignees_group = (CONCAT(@unit_for_group, '-06-Can-See-Public-Assignee'));
					SET @group_description_see_visible_assignees_group = 'User can see all visible assignee(s) for this unit';
					
			# Other Misc Groups
				# Allow user to  for this unit
					SET @group_name_active_stakeholder_group = (CONCAT(@unit_for_group, '-07-Active-Stakeholder'));
					SET @group_description_active_stakeholder_group = 'Users who have a role in this unit as of today (WIP)';
					
				# Allow user to  for this unit
					SET @group_name_unit_creator_group = (CONCAT(@unit_for_group, '-07-Unit-Creator'));
					SET @group_description_unit_creator_group = 'User is considered to be the creator of the unit';
					
			# Groups associated to the components/roles
				# For the tenant
					# Visibility group
					SET @group_name_show_to_tenant = (CONCAT(@unit_for_group, '-02-Limit-to-Tenant'));
					SET @group_description_tenant = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 1), @visibility_explanation_2));
				
					# Is in tenant user Group
					SET @group_name_are_users_tenant = (CONCAT(@unit_for_group, '-06-List-Tenant'));
					SET @group_description_are_users_tenant = (CONCAT('list the tenant(s)', @unit));
					
					# Can See tenant user Group
					SET @group_name_see_users_tenant = (CONCAT(@unit_for_group, '-06-Can-see-Tenant'));
					SET @group_description_see_users_tenant = (CONCAT('See the list of tenant(s) for ', @unit));
			
				# For the Landlord
					# Visibility group 
					SET @group_name_show_to_landlord = (CONCAT(@unit_for_group, '-02-Limit-to-Landlord'));
					SET @group_description_show_to_landlord = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 2), @visibility_explanation_2));
					
					# Is in landlord user Group
					SET @group_name_are_users_landlord = (CONCAT(@unit_for_group, '-06-List-landlord'));
					SET @group_description_are_users_landlord = (CONCAT('list the landlord(s)', @unit));
					
					# Can See landlord user Group
					SET @group_name_see_users_landlord = (CONCAT(@unit_for_group, '-06-Can-see-lanldord'));
					SET @group_description_see_users_landlord = (CONCAT('See the list of lanldord(s) for ', @unit));
					
				# For the agent
					# Visibility group 
					SET @group_name_show_to_agent = (CONCAT(@unit_for_group, '-02-Limit-to-Agent'));
					SET @group_description_show_to_agent = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 5), @visibility_explanation_2));
					
					# Is in Agent user Group
					SET @group_name_are_users_agent = (CONCAT(@unit_for_group, '-06-List-agent'));
					SET @group_description_are_users_agent = (CONCAT('list the agent(s)', @unit));
					
					# Can See Agent user Group
					SET @group_name_see_users_agent = (CONCAT(@unit_for_group, '-06-Can-see-agent'));
					SET @group_description_see_users_agent = (CONCAT('See the list of agent(s) for ', @unit));
				
				# For the contractor
					# Visibility group 
					SET @group_name_show_to_contractor = (CONCAT(@unit_for_group, '-02-Limit-to-Contractor-Employee'));
					SET @group_description_show_to_contractor = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 3), @visibility_explanation_2));
					
					# Is in contractor user Group
					SET @group_name_are_users_contractor = (CONCAT(@unit_for_group, '-06-List-contractor-employee'));
					SET @group_description_are_users_contractor = (CONCAT('list the contractor employee(s)', @unit));
					
					# Can See contractor user Group
					SET @group_name_see_users_contractor = (CONCAT(@unit_for_group, '-06-Can-see-contractor-employee'));
					SET @group_description_see_users_contractor = (CONCAT('See the list of contractor employee(s) for ', @unit));
					
				# For the Mgt Cny
					# Visibility group
					SET @group_name_show_to_mgt_cny = (CONCAT(@unit_for_group, '-02-Limit-to-Mgt-Cny-Employee'));
					SET @group_description_show_to_mgt_cny = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 4), @visibility_explanation_2));
					
					# Is in mgt cny user Group
					SET @group_name_are_users_mgt_cny = (CONCAT(@unit_for_group, '-06-List-Mgt-Cny-Employee'));
					SET @group_description_are_users_mgt_cny = (CONCAT('list the Mgt Cny Employee(s)', @unit));
					
					# Can See mgt cny user Group
					SET @group_name_see_users_mgt_cny = (CONCAT(@unit_for_group, '-06-Can-see-Mgt-Cny-Employee'));
					SET @group_description_see_users_mgt_cny = (CONCAT('See the list of Mgt Cny Employee(s) for ', @unit));
				
				# For the occupant
					# Visibility group
					SET @group_name_show_to_occupant = (CONCAT(@unit_for_group, '-02-Limit-to-occupant'));
					SET @group_description_show_to_occupant = (CONCAT(@visibility_explanation_1, 'Occupants'));
					
					# Is in occupant user Group
					SET @group_name_are_users_occupant = (CONCAT(@unit_for_group, '-06-List-occupant'));
					SET @group_description_are_users_occupant = (CONCAT('list-the-occupant(s)-', @unit));
					
					# Can See occupant user Group
					SET @group_name_see_users_occupant = (CONCAT(@unit_for_group, '-06-Can-see-occupant'));
					SET @group_description_see_users_occupant = (CONCAT('See the list of occupant(s) for ', @unit));
					
				# For the people invited by this user:
					# Is in invited_by user Group
					SET @group_name_are_users_invited_by = (CONCAT(@unit_for_group, '-06-List-invited-by'));
					SET @group_description_are_users_invited_by = (CONCAT('list the invited_by(s)', @unit));
					
					# Can See users in invited_by user Group
					SET @group_name_see_users_invited_by = (CONCAT(@unit_for_group, '-06-Can-see-invited-by'));
					SET @group_description_see_users_invited_by = (CONCAT('See the list of invited_by(s) for ', @unit));

		# We can populate the 'groups' table now.
		# We insert the groups 1 by 1 so we can get the id for each of these groups.

			# Make sure we have the correct value for the name of this script so the `ut_audit_log_table` has the correct info
				SET @script = 'PROCEDURE unit_create_with_dummy_users';

			# create_case_group_id
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_create_case_group
					, @group_description_create_case_group
					, 1
					, ''
					, 1
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @create_case_group_id = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - To grant '
											, 'case creation'
											, ' privileges. Group_id: '
											, (SELECT IFNULL(@create_case_group_id, 'create_case_group_id is NULL'))
											);
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;		

			# can_edit_case_group_id
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_can_edit_case_group
					, @group_description_can_edit_case_group
					, 1
					, ''
					, 1
					, NULL
					)
					;			

				# Get the actual id that was created for that group
					SET @can_edit_case_group_id = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - To grant '
											, 'Edit case'
											, ' privileges. Group_id: '
											, (SELECT IFNULL(@can_edit_case_group_id, 'can_edit_case_group_id is NULL'))
											);
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;		

			# can_see_cases_group_id
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_can_see_cases_group
					, @group_description_can_see_cases_group
					, 1
					, ''
					, 1
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @can_see_cases_group_id = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - To grant '
											, 'See cases'
											, ' privileges. Group_id: '
											, (SELECT IFNULL(@can_see_cases_group_id, 'can_see_cases_group_id is NULL'))
											);
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;		

			# can_edit_all_field_case_group_id
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_can_edit_all_field_case_group
					, @group_description_can_edit_all_field_case_group
					, 1
					, ''
					, 1
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @can_edit_all_field_case_group_id = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - To grant '
											, 'Edit all field regardless of role'
											, ' privileges. Group_id: '
											, (SELECT IFNULL(@can_edit_all_field_case_group_id, 'can_edit_all_field_case_group_id is NULL'))
											);
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;		

			# can_edit_component_group_id
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_can_edit_component_group
					, @group_description_can_edit_component_group
					, 1
					, ''
					, 1
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @can_edit_component_group_id = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - To grant '
											, 'Edit Component/roles'
											, ' privileges. Group_id: '
											, (SELECT IFNULL(@can_edit_component_group_id, 'can_edit_component_group_id is NULL'))
											);
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;		

			# can_see_unit_in_search_group_id
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_can_see_unit_in_search_group
					, @group_description_can_see_unit_in_search_group
					, 1
					, ''
					, 1
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @can_see_unit_in_search_group_id = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - To grant '
											, 'See unit in the Search panel'
											, ' privileges. Group_id: '
											, (SELECT IFNULL(@can_see_unit_in_search_group_id, 'can_see_unit_in_search_group_id is NULL'))
											);
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;		

			# all_g_flags_group_id
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_all_g_flags_group
					, @group_description_all_g_flags_group
					, 1
					, ''
					, 0
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @all_g_flags_group_id = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - To grant '
											, 'Approve all flags'
											, ' privileges. Group_id: '
											, (SELECT IFNULL(@all_g_flags_group_id, 'all_g_flags_group_id is NULL'))
											);
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;		

			# all_r_flags_group_id
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_all_r_flags_group
					, @group_description_all_r_flags_group
					, 1
					, ''
					, 0
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @all_r_flags_group_id = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - To grant '
											, 'Request all flags'
											, ' privileges. Group_id: '
											, (SELECT IFNULL(@all_r_flags_group_id, 'all_r_flags_group_id is NULL'))
											);
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;		

			# list_visible_assignees_group_id
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_list_visible_assignees_group
					, @group_description_list_visible_assignees_group
					, 1
					, ''
					, 0
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @list_visible_assignees_group_id = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - To grant '
											, 'User is publicly visible'
											, ' privileges. Group_id: '
											, (SELECT IFNULL(@list_visible_assignees_group_id, 'list_visible_assignees_group_id is NULL'))
											);
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;		

			# see_visible_assignees_group_id
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_see_visible_assignees_group
					, @group_description_see_visible_assignees_group
					, 1
					, ''
					, 0
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @see_visible_assignees_group_id = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - To grant '
											, 'User can see publicly visible'
											, ' privileges. Group_id: '
											, (SELECT IFNULL(@see_visible_assignees_group_id, 'see_visible_assignees_group_id is NULL'))
											);
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;		

			# active_stakeholder_group_id
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_active_stakeholder_group
					, @group_description_active_stakeholder_group
					, 1
					, ''
					, 1
					, NULL
					)
					;
				
				# Get the actual id that was created for that group
					SET @active_stakeholder_group_id = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - To grant '
											, 'User is active Stakeholder'
											, ' privileges. Group_id: '
											, (SELECT IFNULL(@active_stakeholder_group_id, 'active_stakeholder_group_id is NULL'))
											);
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;		

			# unit_creator_group_id
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_unit_creator_group
					, @group_description_unit_creator_group
					, 1
					, ''
					, 0
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @unit_creator_group_id = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - To grant '
											, 'User is the unit creator'
											, ' privileges. Group_id: '
											, (SELECT IFNULL(@unit_creator_group_id, 'unit_creator_group_id is NULL'))
											);
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;		

			# group_id_show_to_tenant
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_show_to_tenant
					, @group_description_tenant
					, 1
					, ''
					, 1
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @group_id_show_to_tenant = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - Restrict permission to '
											, 'tenant'
											, ' only. Group_id: '
											, (SELECT IFNULL(@group_id_show_to_tenant, 'group_id_show_to_tenant is NULL'))
											);
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;		

			# group_id_are_users_tenant
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_are_users_tenant
					, @group_description_are_users_tenant
					, 1
					, ''
					, 0
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @group_id_are_users_tenant = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - Group for the '
											, 'tenant'
											, ' only. Group_id: '
											, (SELECT IFNULL(@group_id_are_users_tenant, 'group_id_are_users_tenant is NULL'))
											);
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;		

			# group_id_see_users_tenant
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_see_users_tenant
					, @group_description_see_users_tenant
					, 1
					, ''
					, 0
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @group_id_see_users_tenant = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - Group to see the users '
											, 'tenant'
											, '. Group_id: '
											, (SELECT IFNULL(@group_id_see_users_tenant, 'group_id_see_users_tenant is NULL'))
											);
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;		

			# group_id_show_to_landlord
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_show_to_landlord
					, @group_description_show_to_landlord
					, 1
					, ''
					, 1
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @group_id_show_to_landlord = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - Restrict permission to '
											, 'landlord'
											, ' only. Group_id: '
											, (SELECT IFNULL(@group_id_show_to_landlord, 'group_id_show_to_landlord is NULL'))
											);
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;		

			# group_id_are_users_landlord
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_are_users_landlord
					, @group_description_are_users_landlord
					, 1
					, ''
					, 0
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @group_id_are_users_landlord = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - Group for the '
											, 'landlord'
											, ' only. Group_id: '
											, (SELECT IFNULL(@group_id_are_users_landlord, 'group_id_are_users_landlord is NULL'))
											);
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;		

			# group_id_see_users_landlord
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_see_users_landlord
					, @group_description_see_users_landlord
					, 1
					, ''
					, 0
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @group_id_see_users_landlord = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - Group to see the users'
											, 'landlord'
											, '. Group_id: '
											, (SELECT IFNULL(@group_id_see_users_landlord, 'group_id_see_users_landlord is NULL'))
											);
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;		

			# group_id_show_to_agent
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_show_to_agent
					, @group_description_show_to_agent
					, 1
					, ''
					, 1
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @group_id_show_to_agent = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - Restrict permission to '
											, 'agent'
											, ' only. Group_id: '
											, (SELECT IFNULL(@group_id_show_to_agent, 'group_id_show_to_agent is NULL'))
											);
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;		

			# group_id_are_users_agent
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_are_users_agent
					, @group_description_are_users_agent
					, 1
					, ''
					, 0
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @group_id_are_users_agent = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - Group for the '
											, 'agent'
											, ' only. Group_id: '
											, (SELECT IFNULL(@group_id_are_users_agent, 'group_id_are_users_agent is NULL'))
											);
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;		

			# group_id_see_users_agent
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_see_users_agent
					, @group_description_see_users_agent
					, 1
					, ''
					, 0
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @group_id_see_users_agent = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - Group to see the users'
											, 'agent'
											, '. Group_id: '
											, (SELECT IFNULL(@group_id_see_users_agent, 'group_id_see_users_agent is NULL'))
											);
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;		

			# group_id_show_to_contractor
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_show_to_contractor
					, @group_description_show_to_contractor
					, 1
					, ''
					, 1
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @group_id_show_to_contractor = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - Restrict permission to '
											, 'Contractor'
											, ' only. Group_id: '
											, (SELECT IFNULL(@group_id_show_to_contractor, 'group_id_show_to_contractor is NULL'))
											);
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;		

			# group_id_are_users_contractor
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_are_users_contractor
					, @group_description_are_users_contractor
					, 1
					, ''
					, 0
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @group_id_are_users_contractor = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - Group for the '
											, 'Contractor'
											, ' only. Group_id: '
											, (SELECT IFNULL(@group_id_are_users_contractor, 'group_id_are_users_contractor is NULL'))
											);
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;		

			# group_id_see_users_contractor
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_see_users_contractor
					, @group_description_see_users_contractor
					, 1
					, ''
					, 0
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @group_id_see_users_contractor = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - Group to see the users'
											, 'Contractor'
											, '. Group_id: '
											, (SELECT IFNULL(@group_id_see_users_contractor, 'group_id_see_users_contractor is NULL'))
											);
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;		

			# group_id_show_to_mgt_cny
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_show_to_mgt_cny
					, @group_description_show_to_mgt_cny
					, 1
					, ''
					, 1
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @group_id_show_to_mgt_cny = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - Restrict permission to '
											, 'Management Company'
											, ' only. Group_id: '
											, (SELECT IFNULL(@group_id_show_to_mgt_cny, 'group_id_show_to_mgt_cny is NULL'))
											);
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;		

			# group_id_are_users_mgt_cny
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_are_users_mgt_cny
					, @group_description_are_users_mgt_cny
					, 1
					, ''
					, 0
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @group_id_are_users_mgt_cny = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - Group for the users in the '
											, 'Management Company'
											, ' only. Group_id: '
											, (SELECT IFNULL(@group_id_are_users_mgt_cny, 'group_id_are_users_mgt_cny is NULL'))
											);
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;		

			# group_id_see_users_mgt_cny
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_see_users_mgt_cny
					, @group_description_see_users_mgt_cny
					, 1
					, ''
					, 0
					, NULL
					)
					;		 

				# Get the actual id that was created for that group
					SET @group_id_see_users_mgt_cny = (SELECT LAST_INSERT_ID());	

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - Group to see the users in the '
											, 'Management Company'
											, '. Group_id: '
											, (SELECT IFNULL(@group_id_see_users_mgt_cny, 'group_id_see_users_mgt_cny is NULL'))
											);
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;		

			# group_id_show_to_occupant
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_show_to_occupant
					, @group_description_show_to_occupant
					, 1
					, ''
					, 1
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @group_id_show_to_occupant = (SELECT LAST_INSERT_ID());	

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - Restrict permission to '
											, 'occupant'
											, ' only. Group_id: '
											, (SELECT IFNULL(@group_id_show_to_occupant, 'group_id_show_to_occupant is NULL'))
											);
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;		

			# group_id_are_users_occupant
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_are_users_occupant
					, @group_description_are_users_occupant
					, 1
					, ''
					, 0
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @group_id_are_users_occupant = (SELECT LAST_INSERT_ID());  

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - Group for the '
											, 'occupant'
											, ' only. Group_id: '
											, (SELECT IFNULL(@group_id_are_users_occupant, 'group_id_are_users_occupant is NULL'))
											);
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;		

			# group_id_see_users_occupant
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_see_users_occupant
					, @group_description_see_users_occupant
					, 1
					, ''
					, 0
					, NULL
					)
					;
					
				# Get the actual id that was created for that group
					SET @group_id_see_users_occupant = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - Group to see the users '
											, 'occupant'
											, '. Group_id: '
											, (SELECT IFNULL(@group_id_see_users_occupant, 'group_id_see_users_occupant is NULL'))
											);
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;		

			# group_id_are_users_invited_by
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_are_users_invited_by
					, @group_description_are_users_invited_by
					, 1
					, ''
					, 0
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @group_id_are_users_invited_by = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - group of users invited by the same user'
											, ' . Group_id: '
											, (SELECT IFNULL(@group_id_are_users_invited_by, 'group_id_are_users_invited_by is NULL'))
											);
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;		

			# group_id_see_users_invited_by
				INSERT INTO `groups`
					(`name`
					, `description`
					, `isbuggroup`
					, `userregexp`
					, `isactive`
					, `icon_url`
					) 
					VALUES 
					(@group_name_see_users_invited_by
					, @group_description_see_users_invited_by
					, 1
					, ''
					, 0
					, NULL
					)
					;

				# Get the actual id that was created for that group
					SET @group_id_see_users_invited_by = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('Unit #'
											, @product_id
											, ' - Group to see the users '
											, 'invited by the same user'
											, '. Group_id: '
											, (SELECT IFNULL(@group_id_see_users_invited_by, 'group_id_see_users_invited_by is NULL'))
											);
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;		

		# We record the groups we have just created:
		#	We NEED the component_id for that

		# Make sure we have the correct value for the name of this script so the `ut_audit_log_table` has the correct info
			SET @script = 'PROCEDURE unit_create_with_dummy_users';

		# We can now insert in the table
			INSERT INTO `ut_product_group`
				(
				product_id
				,component_id
				,group_id
				,group_type_id
				,role_type_id
				,created_by_id
				,created
				)
				VALUES
				(@product_id, NULL, @create_case_group_id, 20, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @can_edit_case_group_id, 25, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @can_edit_all_field_case_group_id, 26, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @can_edit_component_group_id, 27, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @can_see_cases_group_id, 28, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @can_see_unit_in_search_group_id, 38, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @all_r_flags_group_id, 18, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @all_g_flags_group_id, 19, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @list_visible_assignees_group_id, 4, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @see_visible_assignees_group_id,5, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @active_stakeholder_group_id, 29, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @unit_creator_group_id, 1, NULL, @creator_bz_id, @timestamp)
				# Tenant (1)
				, (@product_id, @component_id_tenant, @group_id_show_to_tenant, 2, 1, @creator_bz_id, @timestamp)
				, (@product_id, @component_id_tenant, @group_id_are_users_tenant, 22, 1, @creator_bz_id, @timestamp)
				, (@product_id, @component_id_tenant, @group_id_see_users_tenant, 37, 1, @creator_bz_id, @timestamp)
				# Landlord (2)
				, (@product_id, @component_id_landlord, @group_id_show_to_landlord, 2, 2, @creator_bz_id, @timestamp)
				, (@product_id, @component_id_landlord, @group_id_are_users_landlord, 22, 2, @creator_bz_id, @timestamp)
				, (@product_id, @component_id_landlord, @group_id_see_users_landlord, 37, 2, @creator_bz_id, @timestamp)
				# Agent (5)
				, (@product_id, @component_id_agent, @group_id_show_to_agent, 2,5, @creator_bz_id, @timestamp)
				, (@product_id, @component_id_agent, @group_id_are_users_agent, 22,5, @creator_bz_id, @timestamp)
				, (@product_id, @component_id_agent, @group_id_see_users_agent, 37,5, @creator_bz_id, @timestamp)
				# contractor (3)
				, (@product_id, @component_id_contractor, @group_id_show_to_contractor, 2, 3, @creator_bz_id, @timestamp)
				, (@product_id, @component_id_contractor, @group_id_are_users_contractor, 22, 3, @creator_bz_id, @timestamp)
				, (@product_id, @component_id_contractor, @group_id_see_users_contractor, 37, 3, @creator_bz_id, @timestamp)
				# mgt_cny (4)
				, (@product_id, @component_id_mgt_cny, @group_id_show_to_mgt_cny, 2, 4, @creator_bz_id, @timestamp)
				, (@product_id, @component_id_mgt_cny, @group_id_are_users_mgt_cny, 22, 4, @creator_bz_id, @timestamp)
				, (@product_id, @component_id_mgt_cny, @group_id_see_users_mgt_cny, 37, 4, @creator_bz_id, @timestamp)
				# occupant (#)
				, (@product_id, NULL, @group_id_show_to_occupant, 24, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @group_id_are_users_occupant, 3, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @group_id_see_users_occupant, 36, NULL, @creator_bz_id, @timestamp)
				# invited_by
				, (@product_id, NULL, @group_id_are_users_invited_by, 31, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @group_id_see_users_invited_by, 32, NULL, @creator_bz_id, @timestamp)
				;
				
		# We update the BZ logs
			INSERT INTO `audit_log`
				(`user_id`
				, `class`
				, `object_id`
				, `field`
				, `removed`
				, `added`
				, `at_time`
				) 
				VALUES 
				(@creator_bz_id, 'Bugzilla::Group', @create_case_group_id, '__create__', NULL, @group_name_create_case_group, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @can_edit_case_group_id, '__create__', NULL, @group_name_can_edit_case_group, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @can_edit_all_field_case_group_id, '__create__', NULL, @group_name_can_edit_all_field_case_group, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @can_edit_component_group_id, '__create__', NULL, @group_name_can_edit_component_group, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @can_see_cases_group_id, '__create__', NULL, @group_name_can_see_cases_group, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @can_see_unit_in_search_group_id, '__create__', NULL, @group_name_can_see_unit_in_search_group, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @all_g_flags_group_id, '__create__', NULL, @group_name_all_g_flags_group, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @all_r_flags_group_id, '__create__', NULL, @group_name_all_r_flags_group, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @list_visible_assignees_group_id, '__create__', NULL, @group_name_list_visible_assignees_group, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @see_visible_assignees_group_id, '__create__', NULL, @group_name_see_visible_assignees_group, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @active_stakeholder_group_id, '__create__', NULL, @group_name_active_stakeholder_group, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @unit_creator_group_id, '__create__', NULL, @group_name_unit_creator_group, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_tenant, '__create__', NULL, @group_name_show_to_tenant, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_tenant, '__create__', NULL, @group_name_are_users_tenant, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_tenant, '__create__', NULL, @group_name_see_users_tenant, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_landlord, '__create__', NULL, @group_name_show_to_landlord, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_landlord, '__create__', NULL, @group_name_are_users_landlord, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_landlord, '__create__', NULL, @group_name_see_users_landlord, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_agent, '__create__', NULL, @group_name_show_to_agent, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_agent, '__create__', NULL, @group_name_are_users_agent, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_agent, '__create__', NULL, @group_name_see_users_agent, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_contractor, '__create__', NULL, @group_name_show_to_contractor, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_contractor, '__create__', NULL, @group_name_are_users_contractor, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_contractor, '__create__', NULL, @group_name_see_users_contractor, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_mgt_cny, '__create__', NULL, @group_name_show_to_mgt_cny, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_mgt_cny, '__create__', NULL, @group_name_are_users_mgt_cny, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_mgt_cny, '__create__', NULL, @group_name_see_users_mgt_cny, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_occupant, '__create__', NULL, @group_name_show_to_occupant, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_occupant, '__create__', NULL, @group_name_are_users_occupant, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_occupant, '__create__', NULL, @group_name_see_users_occupant, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_invited_by, '__create__', NULL, @group_name_are_users_invited_by, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_invited_by, '__create__', NULL, @group_name_see_users_invited_by, @timestamp)
				;
			
	# We now Create the flagtypes and flags for this new unit (we NEEDED the group ids for that!):
		
		# We need to define the data we need for each flag
			SET @flag_next_step_name = CONCAT('Next_Step_', @unit_for_flag);
			SET @flag_solution_name = CONCAT('Solution_', @unit_for_flag);
			SET @flag_budget_name = CONCAT('Budget_', @unit_for_flag);
			SET @flag_attachment_name = CONCAT('Attachment_', @unit_for_flag);
			SET @flag_ok_to_pay_name = CONCAT('OK_to_pay_', @unit_for_flag);
			SET @flag_is_paid_name = CONCAT('is_paid_', @unit_for_flag);
	
		# We insert the flagtypes 1 by 1 to get the id for each component easily

		# Make sure we have the correct value for the name of this script so the `ut_audit_log_table` has the correct info
			SET @script = 'PROCEDURE unit_create_with_dummy_users';

		# Flagtype for next_step
			INSERT INTO `flagtypes`
				(`name`
				, `description`
				, `cc_list`
				, `target_type`
				, `is_active`
				, `is_requestable`
				, `is_requesteeble`
				, `is_multiplicable`
				, `sortkey`
				, `grant_group_id`
				, `request_group_id`
				) 
				VALUES 
				(@flag_next_step_name 
				, 'Approval for the Next Step of the case.'
				, ''
				, 'b'
				, 1
				, 1
				, 1
				, 1
				, 10
				, @all_g_flags_group_id
				, @all_r_flags_group_id
				)
				;

				# We get the id for that flag
					SET @flag_next_step_id = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('The following flag Next Step (#'
										, (SELECT IFNULL(@flag_next_step_id, 'flag_next_step is NULL'))
										, ').'
										, ' was created for the unit #'
										, @product_id
										)
										;
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;	

		# We can now create the flagtypes for solution
			INSERT INTO `flagtypes`
				(`name`
				, `description`
				, `cc_list`
				, `target_type`
				, `is_active`
				, `is_requestable`
				, `is_requesteeble`
				, `is_multiplicable`
				, `sortkey`
				, `grant_group_id`
				, `request_group_id`
				) 
				VALUES 
				(@flag_solution_name 
				, 'Approval for the Solution of this case.'
				, ''
				, 'b'
				, 1
				, 1
				, 1
				, 1
				, 20
				, @all_g_flags_group_id
				, @all_r_flags_group_id
				)
				;

				# We get the id for that flag
					SET @flag_solution_id = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('The following flag Solution (#'
										, (SELECT IFNULL(@flag_solution_id, 'flag_solution is NULL'))
										, ').'
										, ' was created for the unit #'
										, @product_id
										)
										;
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;	

		# We can now create the flagtypes for budget
			INSERT INTO `flagtypes`
				(`name`
				, `description`
				, `cc_list`
				, `target_type`
				, `is_active`
				, `is_requestable`
				, `is_requesteeble`
				, `is_multiplicable`
				, `sortkey`
				, `grant_group_id`
				, `request_group_id`
				) 
				VALUES 
				(@flag_budget_name 
				, 'Approval for the Budget for this case.'
				, ''
				, 'b'
				, 1
				, 1
				, 1
				, 1
				, 30
				, @all_g_flags_group_id
				, @all_r_flags_group_id
				)
				;

				# We get the id for that flag
					SET @flag_budget_id = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('The following flag Budget (#'
										, (SELECT IFNULL(@flag_budget_id, 'flag_budget is NULL'))
										, ').'
										, ' was created for the unit #'
										, @product_id
										)
										;
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;	

		# We can now create the flagtypes for attachment
			INSERT INTO `flagtypes`
				(`name`
				, `description`
				, `cc_list`
				, `target_type`
				, `is_active`
				, `is_requestable`
				, `is_requesteeble`
				, `is_multiplicable`
				, `sortkey`
				, `grant_group_id`
				, `request_group_id`
				) 
				VALUES				 
				(@flag_attachment_name 
				, 'Approval for this Attachment.'
				, ''
				, 'a'
				, 1
				, 1
				, 1
				, 1
				, 10
				, @all_g_flags_group_id
				, @all_r_flags_group_id
				)
				;

				# We get the id for that flag
					SET @flag_attachment_id = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('The following flag Attachment (#'
										, (SELECT IFNULL(@flag_attachment_id, 'flag_attachment is NULL'))
										, ').'
										, ' was created for the unit #'
										, @product_id
										)
										;
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;	

		# We can now create the flagtypes for ok_to_pay
			INSERT INTO `flagtypes`
				(`name`
				, `description`
				, `cc_list`
				, `target_type`
				, `is_active`
				, `is_requestable`
				, `is_requesteeble`
				, `is_multiplicable`
				, `sortkey`
				, `grant_group_id`
				, `request_group_id`
				) 
				VALUES 
				(@flag_ok_to_pay_name 
				, 'Approval to pay this bill.'
				, ''
				, 'a'
				, 1
				, 1
				, 1
				, 1
				, 20
				, @all_g_flags_group_id
				, @all_r_flags_group_id
				)
				;

				# We get the id for that flag
					SET @flag_ok_to_pay_id = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('The following flag OK to pay (#'
										, (SELECT IFNULL(@flag_ok_to_pay_id, 'flag_ok_to_pay is NULL'))
										, ').'
										, ' was created for the unit #'
										, @product_id
										)
										;
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;	

		# We can now create the flagtypes for is_paid
			INSERT INTO `flagtypes`
				(`name`
				, `description`
				, `cc_list`
				, `target_type`
				, `is_active`
				, `is_requestable`
				, `is_requesteeble`
				, `is_multiplicable`
				, `sortkey`
				, `grant_group_id`
				, `request_group_id`
				) 
				VALUES 
				(@flag_is_paid_name
				, 'Confirm if this bill has been paid.'
				, ''
				, 'a'
				, 1
				, 1
				, 1
				, 1
				, 30
				, @all_g_flags_group_id
				, @all_r_flags_group_id
				)
				;

				# We get the id for that flag
					SET @flag_is_paid_id = (SELECT LAST_INSERT_ID());

				# Log the actions of the script.
					SET @script_log_message = CONCAT('The following flag Is paid (#'
										, (SELECT IFNULL(@flag_is_paid_id, 'flag_is_paid is NULL'))
										, ').'
										, ' was created for the unit #'
										, @product_id
										)
										;
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;
					
					SET @script_log_message = NULL;	

		# We also define the flag inclusion

		# Make sure we have the correct value for the name of this script so the `ut_audit_log_table` has the correct info
			SET @script = 'PROCEDURE unit_create_with_dummy_users';

		# We can now do the insert
			INSERT INTO `flaginclusions`
				(`type_id`
				, `product_id`
				, `component_id`
				) 
				VALUES
				(@flag_next_step_id, @product_id, NULL)
				, (@flag_solution_id, @product_id, NULL)
				, (@flag_budget_id, @product_id, NULL)
				, (@flag_attachment_id, @product_id, NULL)
				, (@flag_ok_to_pay_id, @product_id, NULL)
				, (@flag_is_paid_id, @product_id, NULL)
				;

		# We update the BZ logs
			INSERT INTO `audit_log`
				(`user_id`
				, `class`
				, `object_id`
				, `field`
				, `removed`
				, `added`
				, `at_time`
				) 
				VALUES 
				(@creator_bz_id, 'Bugzilla::FlagType', @flag_next_step_id, '__create__', NULL, @flag_next_step_name, @timestamp)
				, (@creator_bz_id, 'Bugzilla::FlagType', @flag_solution_id, '__create__', NULL, @flag_solution_name, @timestamp)
				, (@creator_bz_id, 'Bugzilla::FlagType', @flag_budget_id, '__create__', NULL, @flag_budget_name, @timestamp)
				, (@creator_bz_id, 'Bugzilla::FlagType', @flag_attachment_id, '__create__', NULL, @flag_attachment_name, @timestamp)
				, (@creator_bz_id, 'Bugzilla::FlagType', @flag_ok_to_pay_id, '__create__', NULL, @flag_ok_to_pay_name, @timestamp)
				, (@creator_bz_id, 'Bugzilla::FlagType', @flag_is_paid_id, '__create__', NULL, @flag_is_paid_name, @timestamp)
				;
			
	# We configure the group permissions:
		# Data for the table `group_group_map`
		# We first insert these in the table `ut_group_group_map_temp`
		# If you need to re-create the table `ut_group_group_map_temp`, use the procedure `create_temp_table_to_update_group_permissions`

			INSERT INTO `ut_group_group_map_temp`
				(`member_id`
				, `grantor_id`
				, `grant_type`
				) 
				##########################################################
				# Logic:
				# If you are a member of group_id XXX (ex: 1 / Admin) 
				# then you have the following permissions:
				# 	- 0: You are automatically a member of group ZZZ
				#	- 1: You can grant access to group ZZZ
				#	- 2: You can see users in group ZZZ
				##########################################################
				VALUES 
				# Admin group can grant membership to all
				(1, @create_case_group_id, 1)
				,(1, @can_edit_case_group_id, 1)
				,(1, @can_see_cases_group_id, 1)
				,(1, @can_edit_all_field_case_group_id, 1)
				,(1, @can_edit_component_group_id, 1)
				,(1, @can_see_unit_in_search_group_id, 1)
				,(1, @all_g_flags_group_id, 1)
				,(1, @all_r_flags_group_id, 1)
				,(1, @list_visible_assignees_group_id, 1)
				,(1, @see_visible_assignees_group_id, 1)
				,(1, @active_stakeholder_group_id, 1)
				,(1, @unit_creator_group_id, 1)
				,(1, @group_id_show_to_tenant, 1)
				,(1, @group_id_are_users_tenant, 1)
				,(1, @group_id_see_users_tenant, 1)
				,(1, @group_id_show_to_landlord, 1)
				,(1, @group_id_are_users_landlord, 1)
				,(1, @group_id_see_users_landlord, 1)
				,(1, @group_id_show_to_agent, 1)
				,(1, @group_id_are_users_agent, 1)
				,(1, @group_id_see_users_agent, 1)
				,(1, @group_id_show_to_contractor, 1)
				,(1, @group_id_are_users_contractor, 1)
				,(1, @group_id_see_users_contractor, 1)
				,(1, @group_id_show_to_mgt_cny, 1)
				,(1, @group_id_are_users_mgt_cny, 1)
				,(1, @group_id_see_users_mgt_cny, 1)
				,(1, @group_id_show_to_occupant, 1)
				,(1, @group_id_are_users_occupant, 1)
				,(1, @group_id_see_users_occupant, 1)
				,(1, @group_id_are_users_invited_by, 1)
				,(1, @group_id_see_users_invited_by, 1)
				
				# Admin MUST be a member of the mandatory group for this unit
				# If not it is impossible to see this product in the BZFE backend.
				,(1, @can_see_unit_in_search_group_id,0)
				# Visibility groups:
				, (@all_r_flags_group_id, @all_g_flags_group_id, 2)
				, (@see_visible_assignees_group_id, @list_visible_assignees_group_id, 2)
				, (@unit_creator_group_id, @unit_creator_group_id, 2)
				, (@group_id_see_users_tenant, @group_id_are_users_tenant, 2)
				, (@group_id_see_users_landlord, @group_id_are_users_landlord, 2)
				, (@group_id_see_users_agent, @group_id_are_users_contractor, 2)
				, (@group_id_see_users_mgt_cny, @group_id_are_users_mgt_cny, 2)
				, (@group_id_see_users_occupant, @group_id_are_users_occupant, 2)
				, (@group_id_see_users_invited_by, @group_id_are_users_invited_by, 2)
				;

	# We make sure that only user in certain groups can create, edit or see cases.

	# Make sure we have the correct value for the name of this script so the `ut_audit_log_table` has the correct info
		SET @script = 'PROCEDURE unit_create_with_dummy_users';

	# We can now do the insert
		INSERT INTO `group_control_map`
			(`group_id`
			, `product_id`
			, `entry`
			, `membercontrol`
			, `othercontrol`
			, `canedit`
			, `editcomponents`
			, `editbugs`
			, `canconfirm`
			) 
			VALUES 
			(@create_case_group_id, @product_id, 1, 0, 0, 0, 0, 0, 0)
			, (@can_edit_case_group_id, @product_id, 1, 0, 0, 1, 0, 0, 1)
			, (@can_edit_all_field_case_group_id, @product_id, 1, 0, 0, 1, 0, 1, 1)
			, (@can_edit_component_group_id, @product_id, 0, 0, 0, 0, 1, 0, 0)
			, (@can_see_cases_group_id, @product_id, 0, 2, 0, 0, 0, 0, 0)
			, (@can_see_unit_in_search_group_id, @product_id, 0, 3, 3, 0, 0, 0, 0)
			, (@group_id_show_to_tenant, @product_id, 0, 2, 0, 0, 0, 0, 0)
			, (@group_id_show_to_landlord, @product_id, 0, 2, 0, 0, 0, 0, 0)
			, (@group_id_show_to_agent, @product_id, 0, 2, 0, 0, 0, 0, 0)
			, (@group_id_show_to_contractor, @product_id, 0, 2, 0, 0, 0, 0, 0)
			, (@group_id_show_to_mgt_cny, @product_id, 0, 2, 0, 0, 0, 0, 0)
			, (@group_id_show_to_occupant, @product_id, 0, 2, 0, 0, 0, 0, 0)
			;

		# Log the actions of the script.
			SET @script_log_message = CONCAT('We have updated the group control permissions for the product# '
									, @product_id
									, ': '
									, '\r\ - Create Case (#'
									, (SELECT IFNULL(@create_case_group_id, 'create_case_group_id is NULL'))
									, ').'
									, '\r\ - Edit Case (#'
									, (SELECT IFNULL(@can_edit_case_group_id, 'can_edit_case_group_id is NULL'))
									, ').'
									, '\r\ - Edit All Field (#'
									, (SELECT IFNULL(@can_edit_all_field_case_group_id, 'can_edit_all_field_case_group_id is NULL'))
									, ').'
									, '\r\ - Edit Component (#'
									, (SELECT IFNULL(@can_edit_component_group_id, 'can_edit_component_group_id is NULL'))
									, ').'
									, '\r\ - Can see case (#'
									, (SELECT IFNULL(@can_see_cases_group_id, 'flag_ok_to_pay is NULL'))
									, ').'
									, '\r\ - Can See unit in Search (#'
									, (SELECT IFNULL(@group_id_show_to_tenant, 'group_id_show_to_tenant is NULL'))
									, ').'
									, '\r\ - Show case to Tenant (#'
									, (SELECT IFNULL(@group_id_show_to_landlord, 'group_id_show_to_landlord is NULL'))
									, ').'
									, '\r\ - Show case to Landlord (#'
									, (SELECT IFNULL(@group_id_show_to_landlord, 'group_id_show_to_landlord is NULL'))
									, ').'
									, '\r\ - Show case to Agent (#'
									, (SELECT IFNULL(@group_id_show_to_agent, 'group_id_show_to_agent is NULL'))
									, ').'
									, '\r\ - Show case to Contractor (#'
									, (SELECT IFNULL(@group_id_show_to_contractor, 'group_id_show_to_contractor is NULL'))
									, ').'
									, '\r\ - Show case to Management Company (#'
									, (SELECT IFNULL(@group_id_show_to_mgt_cny, 'group_id_show_to_mgt_cny is NULL'))
									, ').'
									, '\r\ - Show case to Occupant(s) (#'
									, (SELECT IFNULL(@group_id_show_to_occupant, 'group_id_show_to_occupant is NULL'))
									, ').'
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(NOW(), @script, @script_log_message)
				;
			
			SET @script_log_message = NULL;

		# We insert the series categories that BZ needs...
				
			# What are the name for the categories
				SET @series_category_product_name = @unit_for_group;
				SET @series_category_component_tenant_name = CONCAT('Tenant - ', @product_id, '_#', @component_id_tenant);
				SET @series_category_component_landlord_name = CONCAT('Landlord - ', @product_id, '_#', @component_id_landlord);
				SET @series_category_component_contractor_name = CONCAT('Contractor - ', @product_id, '_#', @component_id_contractor);
				SET @series_category_component_mgtcny_name = CONCAT('Mgt Cny - ', @product_id, '_#', @component_id_mgt_cny);
				SET @series_category_component_agent_name = CONCAT('Agent - ', @product_id, '_#', @component_id_agent);
				
			# What are the SQL queries for these series:
				
				# We need a sanitized unit name:
					SET @unit_name_for_serie_query = REPLACE(@unit, ' ', '%20');
				
				# Product
					SET @serie_search_unconfirmed = CONCAT('bug_status=UNCONFIRMED&product=', @unit_name_for_serie_query);
					SET @serie_search_confirmed = CONCAT('bug_status=CONFIRMED&product=', @unit_name_for_serie_query);
					SET @serie_search_in_progress = CONCAT('bug_status=IN_PROGRESS&product=', @unit_name_for_serie_query);
					SET @serie_search_reopened = CONCAT('bug_status=REOPENED&product=', @unit_name_for_serie_query);
					SET @serie_search_standby = CONCAT('bug_status=STAND%20BY&product=', @unit_name_for_serie_query);
					SET @serie_search_resolved = CONCAT('bug_status=RESOLVED&product=', @unit_name_for_serie_query);
					SET @serie_search_verified = CONCAT('bug_status=VERIFIED&product=', @unit_name_for_serie_query);
					SET @serie_search_closed = CONCAT('bug_status=CLOSED&product=', @unit_name_for_serie_query);
					SET @serie_search_fixed = CONCAT('resolution=FIXED&product=', @unit_name_for_serie_query);
					SET @serie_search_invalid = CONCAT('resolution=INVALID&product=', @unit_name_for_serie_query);
					SET @serie_search_wontfix = CONCAT('resolution=WONTFIX&product=', @unit_name_for_serie_query);
					SET @serie_search_duplicate = CONCAT('resolution=DUPLICATE&product=', @unit_name_for_serie_query);
					SET @serie_search_worksforme = CONCAT('resolution=WORKSFORME&product=', @unit_name_for_serie_query);
					SET @serie_search_all_open = CONCAT('bug_status=UNCONFIRMED&bug_status=CONFIRMED&bug_status=IN_PROGRESS&bug_status=REOPENED&bug_status=STAND%20BY&product=', @unit_name_for_serie_query);
					
				# Component
				
					# We need several variables to build this
						SET @serie_search_prefix_component_open = 'field0-0-0=resolution&type0-0-0=notregexp&value0-0-0=.&product='; 
						SET @serie_search_prefix_component_closed = 'field0-0-0=resolution&type0-0-0=regexp&value0-0-0=.&product=';
						SET @component_name_for_serie_tenant = REPLACE(@role_user_g_description_tenant, ' ', '%20');
						SET @component_name_for_serie_landlord = REPLACE(@role_user_g_description_landlord, ' ', '%20');
						SET @component_name_for_serie_contractor = REPLACE(@role_user_g_description_contractor, ' ', '%20');
						SET @component_name_for_serie_mgtcny = REPLACE(@role_user_g_description_mgt_cny, ' ', '%20');
						SET @component_name_for_serie_agent = REPLACE(@role_user_g_description_agent, ' ', '%20');
						
					# We can now derive the query needed to build these series
					
						SET @serie_search_all_open_tenant = (CONCAT (@serie_search_prefix_component_open
							, @unit_name_for_serie_query
							, '&component='
							, @component_name_for_serie_tenant)
							);
						SET @serie_search_all_closed_tenant = (CONCAT (@serie_search_prefix_component_closed
							, @unit_name_for_serie_query
							, '&component='
							, @component_name_for_serie_tenant)
							);
						SET @serie_search_all_open_landlord = (CONCAT (@serie_search_prefix_component_open
							, @unit_name_for_serie_query
							, '&component='
							, @component_name_for_serie_landlord)
							);
						SET @serie_search_all_closed_landlord = (CONCAT (@serie_search_prefix_component_closed
							, @unit_name_for_serie_query
							, '&component='
							, @component_name_for_serie_landlord)
							);
						SET @serie_search_all_open_contractor = (CONCAT (@serie_search_prefix_component_open
							, @unit_name_for_serie_query
							, '&component='
							, @component_name_for_serie_contractor)
							);
						SET @serie_search_all_closed_contractor = (CONCAT (@serie_search_prefix_component_closed
							, @unit_name_for_serie_query
							, '&component='
							, @component_name_for_serie_contractor)
							);
						SET @serie_search_all_open_mgtcny = (CONCAT (@serie_search_prefix_component_open
							, @unit_name_for_serie_query
							, '&component='
							, @component_name_for_serie_mgtcny)
							);
						SET @serie_search_all_closed_mgtcny = (CONCAT (@serie_search_prefix_component_closed
							, @unit_name_for_serie_query
							, '&component='
							, @component_name_for_serie_mgtcny)
							);
						SET @serie_search_all_open_agent = (CONCAT (@serie_search_prefix_component_open
							, @unit_name_for_serie_query
							, '&component='
							, @component_name_for_serie_agent)
							);
						SET @serie_search_all_closed_agent = (CONCAT (@serie_search_prefix_component_closed
							, @unit_name_for_serie_query
							, '&component='
							, @component_name_for_serie_agent)
							);

		# We have eveything, we can create the series_categories we need:
		# We insert the series_categories 1 by 1 to get the id for each series_categories easily

		# Make sure we have the correct value for the name of this script so the `ut_audit_log_table` has the correct info
			SET @script = 'PROCEDURE unit_create_with_dummy_users';

		# We can now insert the series category product
			INSERT INTO `series_categories`
				(`name`
				) 
				VALUES 
				(@series_category_product_name)
				;

			# We get the id for the series_category 
				SET @series_category_product = (SELECT LAST_INSERT_ID());

		# We can now insert the series category component_tenant
			INSERT INTO `series_categories`
				(`name`
				) 
				VALUES 
				(@series_category_component_tenant_name)
				;

			# We get the id for the series_category 
				SET @series_category_component_tenant = (SELECT LAST_INSERT_ID());

		# We can now insert the series category component_landlord
			INSERT INTO `series_categories`
				(`name`
				) 
				VALUES 
				(@series_category_component_landlord_name)
				;

			# We get the id for the series_category 
				SET @series_category_component_landlord = (SELECT LAST_INSERT_ID());

		# We can now insert the series category component_contractor
			INSERT INTO `series_categories`
				(`name`
				) 
				VALUES 
				(@series_category_component_contractor_name)
				;

			# We get the id for the series_category 
				SET @series_category_component_contractor = (SELECT LAST_INSERT_ID());

		# We can now insert the series category component_mgtcny
			INSERT INTO `series_categories`
				(`name`
				) 
				VALUES 
				(@series_category_component_mgtcny_name)
				;

			# We get the id for the series_category 
				SET @series_category_component_mgtcny = (SELECT LAST_INSERT_ID());

		# We can now insert the series category component_agent
			INSERT INTO `series_categories`
				(`name`
				) 
				VALUES 
				(@series_category_component_agent_name)
				;

			# We get the id for the series_category 
				SET @series_category_component_agent = (SELECT LAST_INSERT_ID());

		# We do not need the series_id - we can insert in bulk here

			# Make sure we have the correct value for the name of this script so the `ut_audit_log_table` has the correct info
				SET @script = 'PROCEDURE unit_create_with_dummy_users';

			# Insert the series related to the product/unit
				INSERT INTO `series`
					(`series_id`
					, `creator`
					, `category`
					, `subcategory`
					, `name`
					, `frequency`
					, `query`
					, `is_public`
					) 
					VALUES 
					(NULL, @creator_bz_id, @series_category_product, 2, 'UNCONFIRMED', 1, @serie_search_unconfirmed, 1)
					,(NULL, @creator_bz_id, @series_category_product, 2, 'CONFIRMED', 1, @serie_search_confirmed, 1)
					,(NULL, @creator_bz_id, @series_category_product, 2, 'IN_PROGRESS', 1, @serie_search_in_progress, 1)
					,(NULL, @creator_bz_id, @series_category_product, 2, 'REOPENED', 1, @serie_search_reopened, 1)
					,(NULL, @creator_bz_id, @series_category_product, 2, 'STAND BY', 1, @serie_search_standby, 1)
					,(NULL, @creator_bz_id, @series_category_product, 2, 'RESOLVED', 1, @serie_search_resolved, 1)
					,(NULL, @creator_bz_id, @series_category_product, 2, 'VERIFIED', 1, @serie_search_verified, 1)
					,(NULL, @creator_bz_id, @series_category_product, 2, 'CLOSED', 1, @serie_search_closed, 1)
					,(NULL, @creator_bz_id, @series_category_product, 2, 'FIXED', 1, @serie_search_fixed, 1)
					,(NULL, @creator_bz_id, @series_category_product, 2, 'INVALID', 1, @serie_search_invalid, 1)
					,(NULL, @creator_bz_id, @series_category_product, 2, 'WONTFIX', 1, @serie_search_wontfix, 1)
					,(NULL, @creator_bz_id, @series_category_product, 2, 'DUPLICATE', 1, @serie_search_duplicate, 1)
					,(NULL, @creator_bz_id, @series_category_product, 2, 'WORKSFORME', 1, @serie_search_worksforme, 1)
					,(NULL, @creator_bz_id, @series_category_product, 2, 'All Open', 1, @serie_search_all_open, 1)
					;
					
			# Insert the series related to the Components/roles
				INSERT INTO `series`
					(`series_id`
					, `creator`
					, `category`
					, `subcategory`
					, `name`
					, `frequency`
					, `query`
					, `is_public`
					) 
					VALUES
					# Tenant
					(NULL, @creator_bz_id, @series_category_product, @series_category_component_tenant, 'All Open', 1, @serie_search_all_open_tenant, 1)
					,(NULL, @creator_bz_id, @series_category_product, @series_category_component_tenant, 'All Closed' , 1, @serie_search_all_closed_tenant, 1)
					# Landlord
					,(NULL, @creator_bz_id, @series_category_product, @series_category_component_landlord, 'All Open', 1, @serie_search_all_open_landlord, 1)
					,(NULL, @creator_bz_id, @series_category_product, @series_category_component_landlord, 'All Closed', 1, @serie_search_all_closed_landlord, 1)
					# Contractor
					,(NULL, @creator_bz_id, @series_category_product, @series_category_component_contractor, 'All Open', 1, @serie_search_all_open_contractor, 1)
					,(NULL, @creator_bz_id, @series_category_product, @series_category_component_contractor, 'All Closed', 1, @serie_search_all_closed_contractor, 1)
					# Management Company
					,(NULL, @creator_bz_id, @series_category_product, @series_category_component_mgtcny, 'All Open', 1, @serie_search_all_open_mgtcny, 1)
					,(NULL, @creator_bz_id, @series_category_product, @series_category_component_mgtcny, 'All Closed', 1, @serie_search_all_closed_mgtcny, 1)
					# Agent
					,(NULL, @creator_bz_id, @series_category_product, @series_category_component_agent, 'All Open', 1, @serie_search_all_open_agent, 1)
					,(NULL, @creator_bz_id, @series_category_product, @series_category_component_agent, 'All Closed', 1, @serie_search_all_closed_agent, 1)
					;

	# We now assign the permissions to each of the dummy user associated to each role:
	#	- Tenant (1)
	#	 @bz_user_id_dummy_tenant
	#	- Landlord (2)
	#	 @bz_user_id_dummy_landlord
	#	- Contractor (3)
	#	 @bz_user_id_dummy_contractor
	#	- Management company (4)
	#	 @bz_user_id_dummy_mgt_cny
	#	- Agent (5)
	#	 @bz_user_id_dummy_agent
	#
	#
	# For each of the dummy users, we use the following parameters:
		SET @user_in_default_cc_for_cases = 1;
		SET @replace_default_assignee = 1;

		# Default permissions for dummy users:	
			#User Permissions in the unit:
				# Generic Permissions
					SET @can_see_time_tracking = 0;
					SET @can_create_shared_queries = 0;
					SET @can_tag_comment = 0;
				# Product/Unit specific permissions
					SET @can_create_new_cases = 1;
					SET @can_edit_a_case = 1;
					SET @can_see_all_public_cases = 0;
					SET @can_edit_all_field_in_a_case_regardless_of_role = 1;
					SET @can_see_unit_in_search = 0;
					SET @user_is_publicly_visible = 0;
					SET @user_can_see_publicly_visible = 0;
					SET @can_ask_to_approve_flags = 0;
					SET @can_approve_all_flags = 0;
 
	# We create the permissions for the dummy user to create a case for this unit.		
	#	- can tag comments: ALL user need that	
	#	- can_create_new_cases
	#	- can_edit_a_case
	# This is the only permission that the dummy user will have.
		# First the global permissions:
			# Can tag comments
				INSERT INTO `ut_user_group_map_temp`
					(`user_id`
					, `group_id`
					, `isbless`
					, `grant_type`
					) 
					VALUES 
					(@bz_user_id_dummy_tenant, @can_tag_comment_group_id, 0, 0)
					, (@bz_user_id_dummy_landlord, @can_tag_comment_group_id, 0, 0)
					, (@bz_user_id_dummy_agent, @can_tag_comment_group_id, 0, 0)
					, (@bz_user_id_dummy_contractor, @can_tag_comment_group_id, 0, 0)
					, (@bz_user_id_dummy_mgt_cny, @can_tag_comment_group_id, 0, 0)
					;
					
				# Log the actions of the script.
					SET @script_log_message = CONCAT('the dummy bz users for each component: '
											, '(#'
											, @bz_user_id_dummy_tenant
											, ', #'
											, @bz_user_id_dummy_landlord
											, ', #'
											, @bz_user_id_dummy_agent
											, ', #'
											, @bz_user_id_dummy_contractor
											, ', #'
											, @bz_user_id_dummy_mgt_cny
											, ')'
											, ' CAN tag comments.'
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
		
		# Then the permissions at the unit/product level:
					
			# User can create a case:
				INSERT INTO `ut_user_group_map_temp`
					(`user_id`
					, `group_id`
					, `isbless`
					, `grant_type`
					) 
					VALUES 
					(@bz_user_id_dummy_tenant, @create_case_group_id, 0, 0)
					, (@bz_user_id_dummy_landlord, @create_case_group_id, 0, 0)
					, (@bz_user_id_dummy_agent, @create_case_group_id, 0, 0)
					, (@bz_user_id_dummy_contractor, @create_case_group_id, 0, 0)
					, (@bz_user_id_dummy_mgt_cny, @create_case_group_id, 0, 0)
					;

				# Log the actions of the script.
					SET @script_log_message = CONCAT('the dummy bz users for each component: '
											, '(#'
											, @bz_user_id_dummy_tenant
											, ', #'
											, @bz_user_id_dummy_landlord
											, ', #'
											, @bz_user_id_dummy_agent
											, ', #'
											, @bz_user_id_dummy_contractor
											, ', #'
											, @bz_user_id_dummy_mgt_cny
											, ')'
											, ' CAN create new cases for unit '
											, @product_id
											)
											;
					
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

			# User can Edit a case and see this unit, this is needed so the API does not throw an error see issue #60:
				INSERT INTO `ut_user_group_map_temp`
					(`user_id`
					, `group_id`
					, `isbless`
					, `grant_type`
					) 
					VALUES 
					(@bz_user_id_dummy_tenant, @can_edit_case_group_id, 0, 0)
					, (@bz_user_id_dummy_landlord, @can_edit_case_group_id, 0, 0)
					, (@bz_user_id_dummy_agent, @can_edit_case_group_id, 0, 0)
					, (@bz_user_id_dummy_contractor, @can_edit_case_group_id, 0, 0)
					, (@bz_user_id_dummy_mgt_cny, @can_edit_case_group_id, 0, 0)
					, (@bz_user_id_dummy_tenant, @can_see_unit_in_search_group_id, 0, 0)
					, (@bz_user_id_dummy_landlord, @can_see_unit_in_search_group_id, 0, 0)
					, (@bz_user_id_dummy_agent, @can_see_unit_in_search_group_id, 0, 0)
					, (@bz_user_id_dummy_contractor, @can_see_unit_in_search_group_id, 0, 0)
					, (@bz_user_id_dummy_mgt_cny, @can_see_unit_in_search_group_id, 0, 0)
					;

				# Log the actions of the script.
					SET @script_log_message = CONCAT('the dummy bz users for each component: '
											, '(#'
											, @bz_user_id_dummy_tenant
											, ', #'
											, @bz_user_id_dummy_landlord
											, ', #'
											, @bz_user_id_dummy_agent
											, ', #'
											, @bz_user_id_dummy_contractor
											, ', #'
											, @bz_user_id_dummy_mgt_cny
											, ')'
											, ' CAN edit a cases and see the unit '
											, @product_id
											)
											;
					
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

	# We give the user the permission they need.

		# We update the `group_group_map` table first
		#	- Create an intermediary table to deduplicate the records in the table `ut_group_group_map_temp`
		#	- If the record does NOT exists in the table then INSERT new records in the table `group_group_map`
		#	- If the record DOES exist in the table then update the new records in the table `group_group_map`

			# We drop the deduplication table if it exists:
				DROP TEMPORARY TABLE IF EXISTS `ut_group_group_map_dedup`;

			# We create a table `ut_group_group_map_dedup` to prepare the data we need to insert
				CREATE TEMPORARY TABLE `ut_group_group_map_dedup` (
					`member_id` mediumint(9) NOT NULL
					, `grantor_id` mediumint(9) NOT NULL
					, `grant_type` tinyint(4) NOT NULL DEFAULT '0'
#					, UNIQUE KEY `ut_group_group_map_dedup_member_id_idx` (`member_id`, `grantor_id`, `grant_type`)
#					, KEY `fk_group_group_map_dedup_grantor_id_groups_id` (`grantor_id`)
#					, KEY `group_group_map_dedup_grantor_id_grant_type_idx` (`grantor_id`, `grant_type`)
#					, KEY `group_group_map_dedup_member_id_grant_type_idx` (`member_id`, `grant_type`)
					) 
				;
	
			# We insert the de-duplicated record in the table `ut_group_group_map_dedup`
				INSERT INTO `ut_group_group_map_dedup`
				SELECT `member_id`
					, `grantor_id`
					, `grant_type`
				FROM
					`ut_group_group_map_temp`
				GROUP BY `member_id`
					, `grantor_id`
					, `grant_type`
				ORDER BY `member_id` ASC
					, `grantor_id` ASC
				;

			# We insert the data we need in the `group_group_map` table

				# Make sure we have the correct value for the name of this script so the `ut_audit_log_table` has the correct info
					SET @script = 'PROCEDURE unit_create_with_dummy_users';

				# We can now do the insert
					INSERT INTO `group_group_map`
					SELECT `member_id`
						, `grantor_id`
						, `grant_type`
					FROM
						`ut_group_group_map_dedup`
					# The below code is overkill in this context: 
					# the Unique Key Constraint makes sure that all records are unique in the table `ut_group_group_map_dedup`
					ON DUPLICATE KEY UPDATE
						`member_id` = `ut_group_group_map_dedup`.`member_id`
						, `grantor_id` = `ut_group_group_map_dedup`.`grantor_id`
						, `grant_type` = `ut_group_group_map_dedup`.`grant_type`
					;

			# We drop the temp table as we do not need it anymore
				DROP TEMPORARY TABLE IF EXISTS `ut_group_group_map_dedup`;

		# We can now update the permissions table for the users
		# This NEEDS the table 'ut_user_group_map_temp'
			CALL `update_permissions_invited_user`;

	# Update the table 'ut_data_to_create_units' so that we record that the unit has been created

		# Make sure we have the correct value for the name of this script so the `ut_audit_log_table` has the correct info
			SET @script = 'PROCEDURE unit_create_with_dummy_users';

		# We can now do the uppdate
			UPDATE `ut_data_to_create_units`
			SET 
				`bz_created_date` = @timestamp
				, `comment` = CONCAT ('inserted in BZ with the script \''
						, @script
						, '\'\r\ '
						, IFNULL(`comment`, '')
						)
				, `product_id` = @product_id
			WHERE `id_unit_to_create` = @unit_reference_for_import;
		
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `unit_disable_existing`()
    SQL SECURITY INVOKER
BEGIN
	# This procedure needs the following variables:
	#	- @product_id
	# 	- @inactive_when
	#	 - @bz_user_id
	#
	# This procedure will
	#	- Disable an existing unit/BZ product
	#	- Record the action of the script in the ut_log tables.
	#	- Record the chenge in the BZ `audit_log` table
	
	# We record the name of this procedure for future debugging and audit_log
		SET @script = 'PROCEDURE - unit_disable_existing';
		SET @timestamp = NOW();


	# What is the current status of the unit?
		
		SET @current_unit_status = (SELECT `isactive` FROM `products` WHERE `id` = @product_id);

	# Make a unit inactive
		UPDATE `products`
			SET `isactive` = '0'
			WHERE `id` = @product_id
		;
	# Record the actions of this script in the ut_log
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the User #'
									, @bz_user_id
									, ' has made the Unit #'
									, @product_id
									, ' inactive. It is NOT possible to create new cases in this unit.'
									);
		
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;
			# We log what we have just done into the `ut_audit_log` table
			
			SET @bzfe_table = 'products';
			
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
				 (@timestamp ,@bzfe_table, 'isactive', @current_unit_status, '0', @script, @script_log_message)
				 ;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
	# When we mark a unit as inactive, we need to record this in the `audit_log` table
			INSERT INTO `audit_log`
			(`user_id`
			, `class`
			, `object_id`
			, `field`
			, `removed`
			, `added`
			, `at_time`
			)
			VALUES
			(@bz_user_id
			, 'Bugzilla::Product'
			, @product_id
			, 'isactive'
			, @current_unit_status
			, '0'
			, @inactive_when
			)
			;			
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `unit_enable_existing`()
    SQL SECURITY INVOKER
BEGIN
		# This procedure needs the following variables:
		#	- @product_id
		# 	- @active_when
		#	 - @bz_user_id
		#
		# This procedure will
		#	- Enable an existing unit/BZ product
		#	- Record the action of the script in the ut_log tables.
		#	- Record the chenge in the BZ `audit_log` table
		
		# We record the name of this procedure for future debugging and audit_log
			SET @script = 'PROCEDURE - unit_disable_existing';
			SET @timestamp = NOW();

		# What is the current status of the unit?
		
			SET @current_unit_status = (SELECT `isactive` FROM `products` WHERE `id` = @product_id);

		# Make the unit active
		
			UPDATE `products`
				SET `isactive` = '1'
				WHERE `id` = @product_id
			;
		# Record the actions of this script in the ut_log
			# Log the actions of the script.
				SET @script_log_message = CONCAT('the User #'
										, @bz_user_id
										, ' has made the Unit #'
										, @product_id
										, ' active. It IS possible to create new cases in this unit.'
										);
			
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(@timestamp, @script, @script_log_message)
					;
				# We log what we have just done into the `ut_audit_log` table
				
				SET @bzfe_table = 'products';
				
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
					(@timestamp ,@bzfe_table, 'isactive', @current_unit_status, '1', @script, @script_log_message)
					;
			
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @script = NULL;
				SET @timestamp = NULL;
				SET @bzfe_table = NULL;			
				
		# When we mark a unit as active, we need to record this in the `audit_log` table
				INSERT INTO `audit_log`
				(`user_id`
				, `class`
				, `object_id`
				, `field`
				, `removed`
				, `added`
				, `at_time`
				)
				VALUES
				(@bz_user_id
				, 'Bugzilla::Product'
				, @product_id
				, 'isactive'
				, @current_unit_status
				, '1'
				, @active_when
				)
				;			
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `update_assignee_if_dummy_user`()
    SQL SECURITY INVOKER
BEGIN
	# check if the user is the first in this role for this unit
	IF (@is_current_assignee_this_role_a_dummy_user = 1)
	# We update the component IF this user is the first in this role
	# IF the user is the first in this role for this unit
	# THEN change the initial owner and initialqa contact to the invited BZ user.

	THEN 
											
		# Get the old values so we can log those
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
	
		# Update the default assignee and qa contact
			UPDATE `components`
			SET 
				`initialowner` = @bz_user_id
				,`initialqacontact` = @bz_user_id
				,`description` = @user_role_desc
				WHERE 
				`id` = @component_id_this_role
				;

		# We record the name of this procedure for future debugging and audit_log
			SET @script = 'PROCEDURE - update_assignee_if_dummy_user';
			SET @timestamp = NOW();
				
		# Log the actions of the script.
			SET @script_log_message = CONCAT('The component: '
									, (SELECT IFNULL(@component_id_this_role, 'component_id_this_role is NULL'))
									, ' (for the role_type_id #'
									, (SELECT IFNULL(@id_role_type, 'id_role_type is NULL'))
									, ') has been updated.'
									, '\r\The default user now associated to this role is bz user #'
									, (SELECT IFNULL(@bz_user_id, 'bz_user_id is NULL'))
									, ' (real name: '
									, (SELECT IFNULL(@user_pub_name, 'user_pub_name is NULL'))
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
			INSERT	INTO `audit_log`
				(`user_id`
				,`class`
				,`object_id`
				,`field`
				,`removed`
				,`added`
				,`at_time`
				) 
				VALUES 
				(@creator_bz_id, 'Bugzilla::Component',@component_id_this_role, 'initialowner',@old_component_initialowner,@bz_user_id,@timestamp)
				, (@creator_bz_id, 'Bugzilla::Component',@component_id_this_role, 'initialqacontact',@old_component_initialqacontact,@bz_user_id,@timestamp)
				, (@creator_bz_id, 'Bugzilla::Component',@component_id_this_role, 'description',@old_component_description,@user_role_desc,@timestamp)
				;

		# Update the table 'ut_data_to_replace_dummy_roles' so that we record what we have done
			INSERT INTO `ut_data_to_replace_dummy_roles`
				(`mefe_invitation_id`
				, `mefe_invitor_user_id`
				, `bzfe_invitor_user_id`
				, `bz_unit_id`
				, `bz_user_id`
				, `user_role_type_id`
				, `is_occupant`
				, `is_mefe_user_only`
				, `user_more`
				, `bz_created_date`
				, `comment`
				)
			VALUES 
				(@mefe_invitation_id
				, @mefe_invitor_user_id
				, @creator_bz_id
				, @product_id
				, @bz_user_id
				, @id_role_type
				, @is_occupant
				, @is_mefe_only_user
				, @role_user_more
				, @timestamp
				, CONCAT ('inserted in BZ with the script \''
						, @script
						, '\'\r\ '
						, IFNULL(`comment`, '')
						)
				)
				;
					
		# Cleanup the variables for the log messages:
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
END IF ;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `update_audit_log`()
    SQL SECURITY INVOKER
BEGIN

	# This procedure need the following variables
	#	 - @bzfe_table: the table that was updated
	#	 - @bzfe_field: The fields that were updated
	#	 - @previous_value: The previouso value for the field
	#	 - @new_value: the values captured by the trigger when the new value is inserted.
	#	 - @script: the script that is calling this procedure
	#	 - @comment: a text to give some context ex: "this was created by a trigger xxx"
 
	# When are we doing this?
		SET @timestamp = NOW(); 

	# We update the audit_log table
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
			(@timestamp
			, @bzfe_table
			, @bzfe_field
			, @previous_value
			, @new_value
			, @script
			, @comment
			)
		;

END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `update_bz_fielddefs`()
    SQL SECURITY INVOKER
BEGIN

	# Update the name for the field `bug_id`
	UPDATE `fielddefs`
	SET `description` = 'Case #'
	WHERE `id` = 1;

	# Update the name for the field `classification`
	UPDATE `fielddefs`
	SET `description` = 'Unit Group'
	WHERE `id` = 3;

	# Update the name for the field `product`
	UPDATE `fielddefs`
	SET `description` = 'Unit'
	WHERE `id` = 4;

	# Update the name for the field `rep_platform`
	UPDATE `fielddefs`
	SET `description` = 'Case Category'
	WHERE `id` = 6;

	# Update the name for the field `component`
	UPDATE `fielddefs`
	SET `description` = 'Role'
	WHERE `id` = 15;

	# Update the name for the field `days_elapsed`
	UPDATE `fielddefs`
	SET `description` = 'Days since case changed'
	WHERE `id` = 59;

END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `update_list_changes_new_assignee_is_real`()
    SQL SECURITY INVOKER
BEGIN

# This procedure Needs the following objects:
#	- @environment
#
			
# Create the view to list all the changes from the audit log when we replaced the dummy tenant with a real user
# This version of the script uses the values for the PROD Environment (everything except 1 or 2 this is in case the environment variabel is omitted)
#
	DROP VIEW IF EXISTS `list_changes_new_assignee_is_real`;
	
	IF @environment = '1'
		THEN
		# We are in the DEV/Staging environment
		# Create the view to list all the changes from the audit log when we replaced the dummy tenant with a real user
		# We use the values for the DEV/Staging environment (1)		
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
						`audit_log`.`added` <> 92
						)
					GROUP BY `audit_log`.`object_id`
						, `ut_product_group`.`role_type_id`
					ORDER BY `audit_log`.`at_time` DESC
						, `ut_product_group`.`product_id` ASC
						, `audit_log`.`object_id` ASC
					;
		ELSEIF @environment = '2'
			THEN
			# We are in the Prod environment
			# Create the view to list all the changes from the audit log when we replaced the dummy tenant with a real user
			# We use the values for the Prod environment (2)
			#
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
							`audit_log`.`added` <> 93
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
		ELSEIF @environment = '3'
			THEN
			# We are in the DEMO environment
			# Create the view to list all the changes from the audit log when we replaced the dummy tenant with a real user
			# We use the values for the DEMO Environment (3)
			#
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
	END IF;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `update_log_count_closed_case`()
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
		
	# Flash Count the total number of ALL cases are the date of this query
	# Put this in a variable
		SET @count_total_cases = (SELECT
			 COUNT(`bug_id`)
		FROM
			`bugs`
			) 
			;

	# We have everything: insert in the log table
		INSERT INTO `ut_log_count_closed_cases`
			(`timestamp`
			, `count_closed_cases`
			, `count_total_cases`
			)
			VALUES
			(@timestamp
			, @count_closed_cases
			, @count_total_cases
			)
			;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `update_log_count_enabled_units`()
    SQL SECURITY INVOKER
BEGIN
 
	# When are we doing this?
		SET @timestamp = NOW();	

	# Flash Count the total number of Enabled unit at the date of this query
	# Put this in a variable
		SET @count_enabled_units = (SELECT
			 COUNT(`products`.`id`)
		FROM
			`products`
		WHERE `products`.`isactive` = 1)
		;
		
	# Flash Count the total number of ALL cases are the date of this query
	# Put this in a variable
		SET @count_total_units = (SELECT
			 COUNT(`products`.`id`)
		FROM
			`products`
			) 
			;

	# We have everything: insert in the log table
		INSERT INTO `ut_log_count_enabled_units`
			(`timestamp`
			, `count_enabled_units`
			, `count_total_units`
			)
			VALUES
			(@timestamp
			, @count_enabled_units
			, @count_total_units
			)
			;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `update_permissions_invited_user`()
    SQL SECURITY INVOKER
BEGIN

	# We update the `user_group_map` table
	#	 - Create an intermediary table to deduplicate the records in the table `ut_user_group_map_temp`
	#	 - If the record does NOT exists in the table then INSERT new records in the table `user_group_map`
	#	 - If the record DOES exist in the table then update the new records in the table `user_group_map`
	#
	# We NEED the table `ut_user_group_map_temp` BUT this table should already exist. DO NO re-create it here!!!

	# We drop the deduplication table if it exists:
		DROP TEMPORARY TABLE IF EXISTS `ut_user_group_map_dedup`;

	# We create a table `ut_user_group_map_dedup` to prepare the data we need to insert
		CREATE TEMPORARY TABLE `ut_user_group_map_dedup` (
			`user_id` MEDIUMINT(9) NOT NULL
			, `group_id` MEDIUMINT(9) NOT NULL
			, `isbless` TINYINT(4) NOT NULL DEFAULT '0'
			, `grant_type` TINYINT(4) NOT NULL DEFAULT '0'
#			UNIQUE KEY `user_group_map_dedup_user_id_idx` (`user_id`, `group_id`, `grant_type`, `isbless`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci
		;
		
	# We insert the de-duplicated record in the table `user_group_map_dedup`
		INSERT INTO `ut_user_group_map_dedup`
		SELECT `user_id`
			, `group_id`
			, `isbless`
			, `grant_type`
		FROM
			`ut_user_group_map_temp`
		GROUP BY `user_id`
			, `group_id`
			, `isbless`
			, `grant_type`
		ORDER BY `user_id` ASC
			, `group_id` ASC
		;
			
	# We insert the data we need in the `user_group_map` table
		INSERT INTO `user_group_map`
		SELECT `user_id`
			, `group_id`
			, `isbless`
			, `grant_type`
		FROM
			`ut_user_group_map_dedup`
		# The below code is overkill in this context: 
		# the Unique Key Constraint makes sure that all records are unique in the table `user_group_map`
		ON DUPLICATE KEY UPDATE
			`user_id` = `ut_user_group_map_dedup`.`user_id`
			, `group_id` = `ut_user_group_map_dedup`.`group_id`
			, `isbless` = `ut_user_group_map_dedup`.`isbless`
			, `grant_type` = `ut_user_group_map_dedup`.`grant_type`
		;

	# We drop the temp table as we do not need it anymore
		DROP TEMPORARY TABLE IF EXISTS `ut_user_group_map_dedup`;

END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `user_can_see_publicly_visible`()
    SQL SECURITY INVOKER
BEGIN
	IF (@user_can_see_publicly_visible = 1)
	# This is needed so the user can see all the other users regardless of the other users roles
	# We might hide the visible users to some other user (ex: housekeepers or field person do not need to see landlord or agent
	# They just need to see their manager)
	THEN 
		# Get the information about the group which grant this permission
			SET @see_visible_assignees_group_id = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 5)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @see_visible_assignees_group_id, 0, 0)
				;

		# We record the name of this procedure for future debugging and audit_log
			SET @script = 'PROCEDURE - user_can_see_publicly_visible';
			SET @timestamp = NOW();

		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' CAN see the publicly visible users for the case for this unit.'
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

		# We log what we have just done into the `ut_audit_log` table
			
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = ' CAN see the publicly visible users for the case for this unit.';
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @see_visible_assignees_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `user_in_default_cc_for_cases`()
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
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `user_is_default_assignee_for_cases`()
    SQL SECURITY INVOKER
BEGIN
	# This procedure needs the following objects
	#	- Variables:
	#		- @replace_default_assignee
	#		- @component_id_this_role
	#		- @bz_user_id
	#		- @user_role_desc
	#		- @id_role_type
	#		- @user_pub_name
	#		- @product_id
	#

	# We only do this if this is needed:
	IF (@replace_default_assignee = 1)
	
	THEN

	# We record the name of this procedure for future debugging and audit_log
		SET @script = 'PROCEDURE - user_is_default_assignee_for_cases';
		SET @timestamp = NOW();

	# change the initial owner and initialqa contact to the invited BZ user.
											
		# Get the old values so we can log those
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

		# Update the default assignee and qa contact
			UPDATE `components`
			SET 
				`initialowner` = @bz_user_id
				,`initialqacontact` = @bz_user_id
				,`description` = @user_role_desc
				WHERE 
				`id` = @component_id_this_role
				;
					
	# Log the actions of the script.
		SET @script_log_message = CONCAT('The component: '
			, (SELECT IFNULL(@component_id_this_role, 'component_id_this_role is NULL'))
			, ' (for the role_type_id #'
			, (SELECT IFNULL(@id_role_type, 'id_role_type is NULL'))
			, ') has been updated.'
			, '\r\The default user now associated to this role is bz user #'
			, (SELECT IFNULL(@bz_user_id, 'bz_user_id is NULL'))
			, ' (real name: '
			, (SELECT IFNULL(@user_pub_name, 'user_pub_name is NULL'))
			, ') for the unit #' 
			, @product_id
			)
			;
					
		INSERT INTO `ut_script_log`
			(`datetime`
			, `script`
			, `log`
			)
			VALUES
				(@timestamp, @script, @script_log_message)
			;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;

	# We update the BZ logs
		INSERT	INTO `audit_log`
			(`user_id`
			,`class`
			,`object_id`
			,`field`
			,`removed`
			,`added`
			,`at_time`
			) 
			VALUES 
			(@creator_bz_id, 'Bugzilla::Component',@component_id_this_role, 'initialowner',@old_component_initialowner,@bz_user_id,@timestamp)
			, (@creator_bz_id, 'Bugzilla::Component',@component_id_this_role, 'initialqacontact',@old_component_initialqacontact,@bz_user_id,@timestamp)
			, (@creator_bz_id, 'Bugzilla::Component',@component_id_this_role, 'description',@old_component_description,@user_role_desc,@timestamp)
			;

	END IF;
END$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `user_is_publicly_visible`()
    SQL SECURITY INVOKER
BEGIN
	IF (@user_is_publicly_visible = 1)
	THEN 
		# Get the information about the group which grant this permission
			SET @list_visible_assignees_group_id = (SELECT `group_id` 
				FROM `ut_product_group` 
				WHERE (`product_id` = @product_id 
					AND `group_type_id` = 4)
				)
				;
		
		# Grant the permission
			INSERT INTO `ut_user_group_map_temp`
				(`user_id`
				,`group_id`
				,`isbless`
				,`grant_type`
				) 
				VALUES 
				(@bz_user_id, @list_visible_assignees_group_id, 0, 0)
				;

		# We record the name of this procedure for future debugging and audit_log
			SET @script = 'PROCEDURE - user_is_publicly_visible';
			SET @timestamp = NOW();

		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' is one of the visible assignee for cases for this unit.'
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
		# We log what we have just done into the `ut_audit_log` table
			
			SET @bzfe_table = 'ut_user_group_map_temp';
			SET @permission_granted = 'is one of the visible assignee for cases for this unit.';
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
				 (@timestamp ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'group_id', 'UNKNOWN', @list_visible_assignees_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
				 , (@timestamp ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
				 , (@timestamp ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
				;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
			SET @permission_granted = NULL;
END IF ;
END$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_delete_record_component_cc` AFTER DELETE ON `component_cc` 
    FOR EACH ROW 
  BEGIN

	# We capture the old values of each fields in dedicated variables:
		SET @old_user_id := OLD.user_id;
		SET @old_component_id := OLD.component_id;
		
	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'component_cc';
		SET @bzfe_field = 'user_id, component_id';
		SET @previous_value = CONCAT (
				 @old_user_id
				, ', '
				, @old_component_id
			)
			;
		SET @new_value = NULL;

		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_delete_record_component_cc';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_delete_record_components` AFTER DELETE ON `components` 
    FOR EACH ROW 
  BEGIN

	# We capture the old values of each fields in dedicated variables:
		SET @old_id := OLD.id;
		SET @old_name := OLD.name;
		SET @old_product_id := OLD.product_id;
		SET @old_initialowner := OLD.initialowner;
		SET @old_initialqacontact := OLD.initialqacontact;
		SET @old_description := OLD.description;
		SET @old_isactive := OLD.isactive;

	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'components';
		SET @bzfe_field = 'id, name, product_id, initialowner, initialqacontact, description, isactive';
		SET @previous_value = CONCAT (
				@old_id
				, ', '
				, @old_name
				, ', '
				, @old_product_id
				, ', '
				, @old_initialowner
				, ', '
				, IFNULL(@old_initialqacontact, '(NULL)')
				, ', '
				, @old_description
				, ', '
				, @old_isactive
			)
			;
		SET @new_value = NULL;

		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_delete_record_components';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_delete_record_flaginclusions` AFTER DELETE ON `flaginclusions` 
    FOR EACH ROW 
  BEGIN

	# We capture the old values of each fields in dedicated variables:
		SET @old_type_id := OLD.type_id;
		SET @old_product_id := OLD.product_id;
		SET @old_component_id := OLD.component_id;

	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'flaginclusions';
		SET @bzfe_field = 'type_id, product_id, component_id';
		SET @previous_value = CONCAT (
				@old_type_id
				, ', '
				, IFNULL(@old_product_id, '(NULL)')
				, ', '
				, IFNULL(@old_component_id, '(NULL)') 
			)
			;
		SET @new_value = NULL;

		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_delete_record_flaginclusions';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_delete_record_flagtypes` AFTER DELETE ON `flagtypes` 
    FOR EACH ROW 
  BEGIN

	# We capture the old values of each fields in dedicated variables:
		SET @old_id := OLD.id;
		SET @old_name := OLD.name;
		SET @old_description := OLD.description;
		SET @old_cc_list := OLD.cc_list;
		SET @old_target_type := OLD.target_type;
		SET @old_is_active := OLD.is_active;
		SET @old_is_requestable := OLD.is_requestable;
		SET @old_is_requesteeble := OLD.is_requesteeble;
		SET @old_is_multiplicable := OLD.is_multiplicable;
		SET @old_sortkey := OLD.sortkey;
		SET @old_grant_group_id := OLD.grant_group_id;
		SET @old_request_group_id := OLD.request_group_id;

	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'flagtypes';
		SET @bzfe_field = 'id, name, description, cc_list, target_type, is_active, is_requestable, is_requesteeble, is_multiplicable, sortkey, grant_group_id, request_group_id';
		SET @previous_value = CONCAT (
				@old_id
				, ', '
				, @old_name
				, ', '
				, @old_description
				, ', '
				, IFNULL(@old_cc_list, '(NULL)')
				, ', '
				, @old_target_type
				, ', '
				, @old_is_active
				, ', '
				, @old_is_requestable
				, ', '
				, @old_is_requesteeble
				, ', '
				, @old_is_multiplicable
				, ', '
				, @old_sortkey
				, ', '
				, IFNULL(@old_grant_group_id, '(NULL)')
				, ', '
				, IFNULL(@old_request_group_id, '(NULL)')  
			)
			;
		SET @new_value = NULL;

		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_delete_record_flagtypes';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_delete_record_group_control_map` AFTER DELETE ON `group_control_map` 
    FOR EACH ROW 
  BEGIN

	# We capture the old values of each fields in dedicated variables:
		SET @old_group_id := OLD.group_id;
		SET @old_product_id := OLD.product_id;
		SET @old_entry := OLD.entry;
		SET @old_membercontrol := OLD.membercontrol;
		SET @old_othercontrol := OLD.othercontrol;
		SET @old_canedit := OLD.canedit;
		SET @old_editcomponents := OLD.editcomponents;
		SET @old_editbugs := OLD.editbugs;
		SET @old_canconfirm := OLD.canconfirm;

	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'group_control_map';
		SET @bzfe_field = 'group_id, product_id, entry, membercontrol, othercontrol, canedit, editcomponents, editbugs, canconfirm';
		SET @previous_value = CONCAT (
				@old_group_id
				, ', '
				, @old_product_id
				, ', '
				, @old_entry
				, ', '
				, @old_membercontrol
				, ', '
				, @old_othercontrol
				, ', '
				, @old_canedit
				, ', '
				, @old_editcomponents
				, ', '
				, @old_editbugs
				, ', '
				, @old_canconfirm
			)
			;
		SET @new_value = NULL;

		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_delete_record_group_control_map';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_delete_record_group_group_map` AFTER DELETE ON `group_group_map` 
    FOR EACH ROW 
  BEGIN

	# We capture the old values of each fields in dedicated variables:
		SET @old_member_id := OLD.member_id;
		SET @old_grantor_id := OLD.grantor_id;
		SET @old_grant_type := OLD.grant_type;
		
	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'group_group_map';
		SET @bzfe_field = 'member_id, grantor_id, grant_type';
		SET @previous_value = CONCAT (
				@old_member_id
				, ', '
				, @old_grantor_id
				, ', '
				, @old_grant_type 
			)
			;
		SET @new_value = NULL;

		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_delete_record_group_group_map';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_delete_record_groups` AFTER DELETE ON `groups` 
    FOR EACH ROW 
  BEGIN

	# We capture the old values of each fields in dedicated variables:
		SET @old_id := OLD.id;
		SET @old_name := OLD.name;
		SET @old_description := OLD.description;
		SET @old_isbuggroup := OLD.isbuggroup;
		SET @old_userregexp := OLD.userregexp;
		SET @old_isactive := OLD.isactive;
		SET @old_icon_url := OLD.icon_url;

	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'groups';
		SET @bzfe_field = 'id, name, description, isbuggroup, userregexp, isactive, icon_url';
		SET @previous_value = CONCAT (
				 @old_id
				, ', '
				, @old_name
				, ', '
				, @old_description
				, ', '
				, @old_isbuggroup
				, ', '
				, IFNULL(@old_userregexp, '(NULL)')
				, ', '
				, @old_isactive
				, ', '
				, IFNULL(@old_icon_url, '(NULL)')
			)
			;
		SET @new_value = NULL;

		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_delete_record_groups';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_delete_record_milestones` AFTER DELETE ON `milestones` 
    FOR EACH ROW 
  BEGIN

	# We capture the old values of each fields in dedicated variables:
		SET @old_id := OLD.id;
		SET @old_product_id := OLD.product_id;
		SET @old_value := OLD.value;
		SET @old_sortkey := OLD.sortkey;
		SET @old_isactive := OLD.isactive;

	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'milestones';
		SET @bzfe_field = 'id, product_id, value, sortkey, isactive';
		SET @previous_value = CONCAT (
				@old_id
				, ', '
				, @old_product_id
				, ', '
				, @old_value
				, ', '
				, @old_sortkey
				, ', '
				, @old_isactive
			)
			;
		SET @new_value = NULL;

		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_delete_record_milestones';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_delete_record_products` AFTER DELETE ON `products` 
    FOR EACH ROW 
  BEGIN

	# We capture the old values of each fields in dedicated variables:
		SET @old_name := OLD.name;
		SET @old_classification_id := OLD.classification_id;
		SET @old_description := OLD.description;
		SET @old_isactive := OLD.isactive;
		SET @old_defaultmilestone := OLD.defaultmilestone;
		SET @old_allows_unconfirmed := OLD.allows_unconfirmed;

	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'products';
		SET @bzfe_field = 'name, classification_id, description, isactive, defaultmilestone, allows_unconfirmed';
		SET @previous_value = CONCAT (
				@old_name
				, ', '
				, @old_classification_id
				, ', '
				, @old_description
				, ', '
				, @old_isactive
				, ', '
				, @old_defaultmilestone
				, ', '
				, @old_allows_unconfirmed
			)
			;
		SET @new_value = NULL;

		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_delete_record_products';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_delete_record_user_group_map` AFTER DELETE ON `user_group_map` 
    FOR EACH ROW 
  BEGIN

	# We capture the old values of each fields in dedicated variables:
		SET @old_user_id := OLD.user_id;
		SET @old_group_id := OLD.group_id;
		SET @old_isbless := OLD.isbless;
		SET @old_grant_type := OLD.grant_type;

	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'user_group_map';
		SET @bzfe_field = 'user_id, group_id, isbless, grant_type';
		SET @previous_value = CONCAT (
				@old_user_id
				, ', '
				, @old_group_id
				, ', '
				, @old_isbless
				, ', '
				, @old_grant_type
			);
		SET @new_value = NULL;

		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_delete_record_user_group_map';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_delete_record_ut_data_to_create_units` AFTER DELETE ON `ut_data_to_create_units` 
    FOR EACH ROW 
  BEGIN

	# We capture the old values of each fields in dedicated variables:
		SET @old_id_unit_to_create := OLD.id_unit_to_create;
		SET @old_mefe_unit_id := OLD.mefe_unit_id;
		SET @old_mefe_unit_id_int_value := old.mefe_unit_id_int_value;
		SET @old_mefe_creator_user_id := OLD.mefe_creator_user_id;
		SET @old_bzfe_creator_user_id := OLD.bzfe_creator_user_id;
		SET @old_classification_id := OLD.classification_id;
		SET @old_unit_name := OLD.unit_name;
		SET @old_unit_description_details := OLD.unit_description_details;
		SET @old_bz_created_date := OLD.bz_created_date;
		SET @old_comment := OLD.comment;
		SET @old_product_id := OLD.product_id;
		SET @old_deleted_datetime := OLD.deleted_datetime;
		SET @old_deletion_script := OLD.deletion_script;

	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'ut_data_to_create_units';
		SET @bzfe_field = 'id_unit_to_create, mefe_unit_id, mefe_unit_id_int_value, mefe_creator_user_id, bzfe_creator_user_id, classification_id, unit_name, unit_description_details, bz_created_date, comment, product_id, deleted_datetime, deletion_script';
		SET @previous_value = CONCAT (
				@old_id_unit_to_create
				, ', '
				, IFNULL(@old_mefe_unit_id, '(NULL)')
				, ', '
				, IFNULL(@old_mefe_unit_id_int_value, '(NULL)')
				, ', '
				, IFNULL(@old_mefe_creator_user_id, '(NULL)')
				, ', '
				, @old_bzfe_creator_user_id
				, ', '
				, @old_classification_id
				, ', '
				, @old_unit_name
				, ', '
				, IFNULL(@old_unit_description_details, '(NULL)')
				, ', '
				, IFNULL(@old_bz_created_date, '(NULL)')
				, ', '
				, IFNULL(@old_comment, '(NULL)')
				, ', '
				, IFNULL(@old_product_id, '(NULL)')
				, ', '
				, IFNULL(@old_deleted_datetime, '(NULL)')
				, ', '
				, IFNULL(@old_deletion_script, '(NULL)')
			)
			;
		SET @new_value = NULL;

		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_delete_record_ut_data_to_create_units';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_delete_record_ut_invitation_api_data` AFTER DELETE ON `ut_invitation_api_data` 
    FOR EACH ROW 
  BEGIN

	# We capture the old values of each fields in dedicated variables:
		SET @old_id := OLD.id;
		SET @old_mefe_invitation_id := OLD.mefe_invitation_id;
		SET @old_mefe_invitation_id_int_value := OLD.mefe_invitation_id_int_value;
		SET @old_bzfe_invitor_user_id := OLD.bzfe_invitor_user_id;
		SET @old_bz_user_id := OLD.bz_user_id;
		SET @old_user_role_type_id := OLD.user_role_type_id;
		SET @old_is_occupant := OLD.is_occupant;
		SET @old_bz_case_id := OLD.bz_case_id;
		SET @old_bz_unit_id := OLD.bz_unit_id;
		SET @old_invitation_type := OLD.invitation_type;
		SET @old_is_mefe_only_user := OLD.is_mefe_only_user;
		SET @old_user_more := OLD.user_more;
		SET @old_mefe_invitor_user_id := OLD.mefe_invitor_user_id;
		SET @old_processed_datetime := OLD.processed_datetime;
		SET @old_script := OLD.script;
		SET @old_api_post_datetime := OLD.api_post_datetime;

	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'ut_invitation_api_data';
		SET @bzfe_field = 'id, mefe_invitation_id, mefe_invitation_id_int_value, bzfe_invitor_user_id, bz_user_id, user_role_type_id, is_occupant, bz_case_id, bz_unit_id, invitation_type, is_mefe_only_user, user_more, mefe_invitor_user_id, processed_datetime, script, api_post_datetime';
		SET @previous_value = CONCAT (
				@old_id
				, ', '
				, IFNULL(@old_mefe_invitation_id, '(NULL)')
				, ', '
				, IFNULL(@mefe_invitation_id_int_value, '(NULL)')
				, ', '
				, @old_bzfe_invitor_user_id
				, ', '
				, @old_bz_user_id
				, ', '
				, @old_user_role_type_id
				, ', '
				, IFNULL(@old_is_occupant, '(NULL)')
				, ', '
				, IFNULL(@old_bz_case_id, '(NULL)')
				, ', '
				, @old_bz_unit_id
				, ', '
				, @old_invitation_type
				, ', '
				, IFNULL(@old_is_mefe_only_user, '(NULL)')
				, ', '
				, IFNULL(@old_user_more, '(NULL)')
				, ', '
				, IFNULL(@old_mefe_invitor_user_id, '(NULL)')
				, ', '
				, IFNULL(@old_processed_datetime, '(NULL)')
				, ', '
				, IFNULL(@old_script, '(NULL)')
				, ', '
				, IFNULL(@old_api_post_datetime, '(NULL)')
			)
			;
		SET @new_value = NULL;

		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_delete_record_ut_invitation_api_data';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_delete_record_ut_product_group` AFTER DELETE ON `ut_product_group` 
    FOR EACH ROW 
  BEGIN

	# We capture the old values of each fields in dedicated variables:
		SET @old_product_id := OLD.product_id;
		SET @old_component_id := OLD.component_id;
		SET @old_group_id := OLD.group_id;
		SET @old_group_type_id := OLD.group_type_id;
		SET @old_role_type_id := OLD.role_type_id;
		SET @old_created_by_id := OLD.created_by_id;
		SET @old_created := OLD.created;

	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'ut_product_group';
		SET @bzfe_field = 'product_id, component_id, group_id, group_type_id, role_type_id, created_by_id, created';
		SET @previous_value = CONCAT (
				@old_product_id
				, ', '
				, IFNULL(@old_component_id, '(NULL)')
				, ', '
				, @old_group_id
				, ', '
				, @old_group_type_id
				, ', '
				, IFNULL(@old_role_type_id, '(NULL)')
				, ', '
				, IFNULL(@old_created_by_id, '(NULL)')
				, ', '
				, IFNULL(@old_created, '(NULL)')
			)
			;
		SET @new_value = NULL;

		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_delete_record_ut_product_group';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_delete_record_versions` AFTER DELETE ON `versions` 
    FOR EACH ROW 
  BEGIN

	# We capture the old values of each fields in dedicated variables:
		SET @old_id := OLD.id;
		SET @old_value := OLD.value;
		SET @old_product_id := OLD.product_id;
		SET @old_isactive := OLD.isactive;

	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'versions';
		SET @bzfe_field = 'id, value, product_id, isactive';
		SET @previous_value = CONCAT (
				@old_id
				, ', '
				, @old_value
				, ', '
				, @old_product_id
				, ', '
				, @old_isactive
			)
			;
		SET @new_value = NULL;

		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_delete_record_versions';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_new_record_component_cc` AFTER INSERT ON `component_cc` 
    FOR EACH ROW 
  BEGIN

	# We capture the new values of each fields in dedicated variables:
		SET @new_user_id := NEW.user_id;
		SET @new_component_id := NEW.component_id;

	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'component_cc';
		SET @bzfe_field = 'user_id, component_id';
		SET @previous_value = NULL;
		SET @new_value = CONCAT (
				@new_user_id
				, ', '
				, @new_component_id
			)
			;
		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_new_record_component_cc';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_new_record_components` AFTER INSERT ON `components` 
    FOR EACH ROW 
  BEGIN

	# We capture the new values of each fields in dedicated variables:
		SET @new_id := NEW.id;
		SET @new_name := NEW.name;
		SET @new_product_id := NEW.product_id;
		SET @new_initialowner := NEW.initialowner;
		SET @new_initialqacontact := NEW.initialqacontact;
		SET @new_description := NEW.description;
		SET @new_isactive := NEW.isactive;

	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'components';
		SET @bzfe_field = 'id, name, product_id, initialowner, initialqacontact, description, isactive';
		SET @previous_value = NULL;
		SET @new_value = CONCAT (
				@new_id
				, ', '
				, @new_name
				, ', '
				, @new_product_id
				, ', '
				, @new_initialowner
				, ', '
				, IFNULL(@new_initialqacontact, '(NULL)')
				, ', '
				, @new_description
				, ', '
				, @new_isactive
			)
			;
		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_new_record_components';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_new_record_flaginclusions` AFTER INSERT ON `flaginclusions` 
    FOR EACH ROW 
  BEGIN

	# We capture the new values of each fields in dedicated variables:
		SET @new_type_id := NEW.type_id;
		SET @new_product_id := NEW.product_id;
		SET @new_component_id := NEW.component_id;

	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'flaginclusions';
		SET @bzfe_field = 'type_id, product_id, component_id';
		SET @previous_value = NULL;
		SET @new_value = CONCAT (
				@new_type_id
				, ', '
				, IFNULL(@new_product_id, '(NULL)')
				, ', '
				, IFNULL(@new_component_id, '(NULL)')  
			)
			;
		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_new_record_flaginclusions';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_new_record_flagtypes` AFTER INSERT ON `flagtypes` 
    FOR EACH ROW 
  BEGIN

	# We capture the new values of each fields in dedicated variables:
		SET @new_id := NEW.id;
		SET @new_name := NEW.name;
		SET @new_description := NEW.description;
		SET @new_cc_list := NEW.cc_list;
		SET @new_target_type := NEW.target_type;
		SET @new_is_active := NEW.is_active;
		SET @new_is_requestable := NEW.is_requestable;
		SET @new_is_requesteeble := NEW.is_requesteeble;
		SET @new_is_multiplicable := NEW.is_multiplicable;
		SET @new_sortkey := NEW.sortkey;
		SET @new_grant_group_id := NEW.grant_group_id;
		SET @new_request_group_id := NEW.request_group_id;

	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'flagtypes';
		SET @bzfe_field = 'id, name, description, cc_list, target_type, is_active, is_requestable, is_requesteeble, is_multiplicable, sortkey, grant_group_id, request_group_id';
		SET @previous_value = NULL;
		SET @new_value = CONCAT (
				@new_id
				, ', '
				, @new_name
				, ', '
				, @new_description
				, ', '
				, IFNULL(@new_cc_list, '(NULL)')
				, ', '
				, @new_target_type
				, ', '
				, @new_is_active
				, ', '
				, @new_is_requestable
				, ', '
				, @new_is_requesteeble
				, ', '
				, @new_is_multiplicable
				, ', '
				, @new_sortkey
				, ', '
				, IFNULL(@new_grant_group_id, '(NULL)')
				, ', '
				, IFNULL(@new_request_group_id, '(NULL)')	
			)
			;
		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_new_record_flagtypes';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_new_record_group_control_map` AFTER INSERT ON `group_control_map` 
    FOR EACH ROW 
  BEGIN

	# We capture the new values of each fields in dedicated variables:
		SET @new_group_id := NEW.group_id;
		SET @new_product_id := NEW.product_id;
		SET @new_entry := NEW.entry;
		SET @new_membercontrol := NEW.membercontrol;
		SET @new_othercontrol := NEW.othercontrol;
		SET @new_canedit := NEW.canedit;
		SET @new_editcomponents := NEW.editcomponents;
		SET @new_editbugs := NEW.editbugs;
		SET @new_canconfirm := NEW.canconfirm;

	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'group_control_map';
		SET @bzfe_field = 'group_id, product_id, entry, membercontrol, othercontrol, canedit, editcomponents, editbugs, canconfirm';
		SET @previous_value = NULL;
		SET @new_value = CONCAT (
				@new_group_id
				, ', '
				, @new_product_id
				, ', '
				, @new_entry
				, ', '
				, @new_membercontrol
				, ', '
				, @new_othercontrol
				, ', '
				, @new_canedit
				, ', '
				, @new_editcomponents
				, ', '
				, @new_editbugs
				, ', '
				, @new_canconfirm
			)
			;
		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_new_record_group_control_map';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_new_record_group_group_map` AFTER INSERT ON `group_group_map` 
    FOR EACH ROW 
  BEGIN

	# We capture the new values of each fields in dedicated variables:
		SET @new_member_id := NEW.member_id;
		SET @new_grantor_id := NEW.grantor_id;
		SET @new_grant_type := NEW.grant_type;

	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'group_group_map';
		SET @bzfe_field = 'member_id, grantor_id, grant_type';
		SET @previous_value = NULL;
		SET @new_value = CONCAT (
				@new_member_id
				, ', '
				, @new_grantor_id
				, ', '
				, @new_grant_type
			)
			;
		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_new_record_group_group_map';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_new_record_groups` AFTER INSERT ON `groups` 
    FOR EACH ROW 
  BEGIN

	# We capture the new values of each fields in dedicated variables:
		SET @new_id := NEW.id;
		SET @new_name := NEW.name;
		SET @new_description := NEW.description;
		SET @new_isbuggroup := NEW.isbuggroup;
		SET @new_userregexp := NEW.userregexp;
		SET @new_isactive := NEW.isactive;
		SET @new_icon_url := NEW.icon_url;

	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'groups';
		SET @bzfe_field = 'id, name, description, isbuggroup, userregexp, isactive, icon_url';
		SET @previous_value = NULL;
		SET @new_value = CONCAT (
				@new_id
				, ', '
				, @new_name
				, ', '
				, @new_description
				, ', '
				, @new_isbuggroup
				, ', '
				, IFNULL(@new_userregexp, '(NULL)')
				, ', '
				, @new_isactive
				, ', '
				, IFNULL(@new_icon_url, '(NULL)')
			)
			;
		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_new_record_groups';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_new_record_milestones` AFTER INSERT ON `milestones` 
    FOR EACH ROW 
  BEGIN

	# We capture the new values of each fields in dedicated variables:
		SET @new_id := NEW.id;
		SET @new_product_id := NEW.product_id;
		SET @new_value := NEW.value;
		SET @new_sortkey := NEW.sortkey;
		SET @new_isactive := NEW.isactive;

	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'milestones';
		SET @bzfe_field = 'id, product_id, value, sortkey, isactive';
		SET @previous_value = NULL;
		SET @new_value = CONCAT (
				@new_id
				, ', '
				, @new_product_id
				, ', '
				, @new_value
				, ', '
				, @new_sortkey
				, ', '
				, @new_isactive
			)
			;
		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_new_record_milestones';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_new_record_products` AFTER INSERT ON `products` 
    FOR EACH ROW 
  BEGIN

	# We capture the new values of each fields in dedicated variables:
		SET @new_name := NEW.name;
		SET @new_classification_id := NEW.classification_id;
		SET @new_description := NEW.description;
		SET @new_isactive := NEW.isactive;
		SET @new_defaultmilestone := NEW.defaultmilestone;
		SET @new_allows_unconfirmed := NEW.allows_unconfirmed;

	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'products';
		SET @bzfe_field = 'name, classification_id, description, isactive, defaultmilestone, allows_unconfirmed';
		SET @previous_value = NULL;
		SET @new_value = CONCAT (
				@new_name
				, ', '
				, @new_classification_id
				, ', '
				, @new_description
				, ', '
				, @new_isactive
				, ', '
				, @new_defaultmilestone
				, ', '
				, @new_allows_unconfirmed
			)
			;
		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_new_record_products';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_new_record_user_group_map` AFTER INSERT ON `user_group_map` 
    FOR EACH ROW 
  BEGIN

	# We capture the new values of each fields in dedicated variables:
		SET @new_user_id := NEW.user_id;
		SET @new_group_id := NEW.group_id;
		SET @new_isbless := NEW.isbless;
		SET @new_grant_type := NEW.grant_type;

	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'user_group_map';
		SET @bzfe_field = 'user_id, group_id, isbless, grant_type';
		SET @previous_value = NULL;
		SET @new_value = CONCAT (
				@new_user_id
				, ', '
				, @new_group_id
				, ', '
				, @new_isbless
				, ', '
				, @new_grant_type
			)
			;
		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_new_record_user_group_map';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_new_record_ut_data_to_create_units` AFTER INSERT ON `ut_data_to_create_units` 
    FOR EACH ROW 
  BEGIN

	# We capture the new values of each fields in dedicated variables:
		SET @new_id_unit_to_create := NEW.id_unit_to_create;
		SET @new_mefe_unit_id := NEW.mefe_unit_id;
		SET @new_mefe_unit_id_int_value := NEW.mefe_unit_id_int_value;
		SET @new_mefe_creator_user_id := NEW.mefe_creator_user_id;
		SET @new_bzfe_creator_user_id := NEW.bzfe_creator_user_id;
		SET @new_classification_id := NEW.classification_id;
		SET @new_unit_name := NEW.unit_name;
		SET @new_unit_description_details := NEW.unit_description_details;
		SET @new_bz_created_date := NEW.bz_created_date;
		SET @new_comment := NEW.comment;
		SET @new_product_id := NEW.product_id;
		SET @new_deleted_datetime := NEW.deleted_datetime;
		SET @new_deletion_script := NEW.deletion_script;

	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'ut_data_to_create_units';
		SET @bzfe_field = 'id_unit_to_create, mefe_unit_id, mefe_unit_id_int_value, mefe_creator_user_id, bzfe_creator_user_id, classification_id, unit_name, unit_description_details, bz_created_date, comment, product_id, deleted_datetime, deletion_script';
		SET @previous_value = NULL;
		SET @new_value = CONCAT (
				@new_id_unit_to_create
				, ', '
				, IFNULL(@new_mefe_unit_id, '(NULL)')
				, ', '
				, IFNULL(@new_mefe_unit_id_int_value, '(NULL)')
				, ', '
				, IFNULL(@new_mefe_creator_user_id, '(NULL)')
				, ', '
				, @new_bzfe_creator_user_id
				, ', '
				, @new_classification_id
				, ', '
				, @new_unit_name
				, ', '
				, IFNULL(@new_unit_description_details, '(NULL)')
				, ', '
				, IFNULL(@new_bz_created_date, '(NULL)')
				, ', '
				, IFNULL(@new_comment, '(NULL)')
				, ', '
				, IFNULL(@new_product_id, '(NULL)')
				, ', '
				, IFNULL(@new_deleted_datetime, '(NULL)')
				, ', '
				, IFNULL(@new_deletion_script, '(NULL)')
			)
			;
		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_new_record_ut_data_to_create_units';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_new_record_ut_invitation_api_data` AFTER INSERT ON `ut_invitation_api_data` 
    FOR EACH ROW 
  BEGIN

	# We capture the new values of each fields in dedicated variables:
		SET @new_id := NEW.id;
		SET @new_mefe_invitation_id := NEW.mefe_invitation_id ;
		SET @new_mefe_invitation_id_int_value := NEW.mefe_invitation_id_int_value ;
		SET @new_bzfe_invitor_user_id := NEW.bzfe_invitor_user_id ;
		SET @new_bz_user_id := NEW.bz_user_id;
		SET @new_user_role_type_id := NEW.user_role_type_id;
		SET @new_is_occupant := NEW.is_occupant;
		SET @new_bz_case_id := NEW.bz_case_id;
		SET @new_bz_unit_id := NEW.bz_unit_id;
		SET @new_invitation_type := NEW.invitation_type;
		SET @new_is_mefe_only_user := NEW.is_mefe_only_user;
		SET @new_user_more := NEW.user_more;
		SET @new_mefe_invitor_user_id := NEW.mefe_invitor_user_id;
		SET @new_processed_datetime := NEW.processed_datetime;
		SET @new_script := NEW.script;
		SET @new_api_post_datetime := NEW.api_post_datetime;

	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'ut_invitation_api_data';
		SET @bzfe_field = 'id, mefe_invitation_id, mefe_invitation_id_int_value, bzfe_invitor_user_id, bz_user_id, user_role_type_id, is_occupant, bz_case_id, bz_unit_id, invitation_type, is_mefe_only_user, user_more, mefe_invitor_user_id, processed_datetime, script, api_post_datetime';
		SET @previous_value = NULL;
		SET @new_value = CONCAT (
				@new_id
				, ', '
				, IFNULL(@new_mefe_invitation_id, '(NULL)')
				, ', '
				, IFNULL(@new_mefe_invitation_id_int_value, '(NULL)')
				, ', '
				, @new_bzfe_invitor_user_id
				, ', '
				, @new_bz_user_id
				, ', '
				, @new_user_role_type_id
				, ', '
				, IFNULL(@new_is_occupant, '(NULL)')
				, ', '
				, IFNULL(@new_bz_case_id, '(NULL)')
				, ', '
				, @new_bz_unit_id
				, ', '
				, @new_invitation_type
				, ', '
				, IFNULL(@new_is_mefe_only_user, '(NULL)')
				, ', '
				, IFNULL(@new_user_more, '(NULL)')
				, ', '
				, IFNULL(@new_mefe_invitor_user_id, '(NULL)')
				, ', '
				, IFNULL(@new_processed_datetime, '(NULL)')
				, ', '
				, IFNULL(@new_script, '(NULL)')
				, ', '
				, IFNULL(@new_api_post_datetime, '(NULL)')
			)
			;
		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_new_record_ut_invitation_api_data';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_new_record_ut_product_group` AFTER INSERT ON `ut_product_group` 
    FOR EACH ROW 
  BEGIN

	# We capture the new values of each fields in dedicated variables:
		SET @new_product_id := NEW.product_id;
		SET @new_component_id := NEW.component_id;
		SET @new_group_id := NEW.group_id;
		SET @new_group_type_id := NEW.group_type_id;
		SET @new_role_type_id := NEW.role_type_id;
		SET @new_created_by_id := NEW.created_by_id;
		SET @new_created := NEW.created;

	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'ut_product_group';
		SET @bzfe_field = 'product_id, component_id, group_id, group_type_id, role_type_id, created_by_id, created';
		SET @previous_value = NULL;
		SET @new_value = CONCAT (
				@new_product_id
				, ', '
				, IFNULL(@new_component_id, '(NULL)')
				, ', '
				, @new_group_id
				, ', '
				, @new_group_type_id
				, ', '
				, IFNULL(@new_role_type_id, '(NULL)')
				, ', '
				, IFNULL(@new_created_by_id, '(NULL)')
				, ', '
				, IFNULL(@new_created, '(NULL)')
			)
			;
		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_new_record_ut_product_group';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_new_record_versions` AFTER INSERT ON `versions` 
    FOR EACH ROW 
  BEGIN

	# We capture the new values of each fields in dedicated variables:
		SET @new_id := NEW.id;
		SET @new_value := NEW.value;
		SET @new_product_id := NEW.product_id;
		SET @new_isactive := NEW.isactive;

	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'versions';
		SET @bzfe_field = 'id, value, product_id, isactive';
		SET @previous_value = NULL;
		SET @new_value = CONCAT (
				@new_id
				, ', '
				, @new_value
				, ', '
				, @new_product_id
				, ', '
				, @new_isactive
			)
			;
		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_new_record_versions';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_update_record_component_cc` AFTER UPDATE ON `component_cc` 
    FOR EACH ROW 
  BEGIN

	# We capture the new values of each fields in dedicated variables:
		SET @new_user_id := NEW.user_id;
		SET @new_component_id := NEW.component_id;

	# We capture the old values of each fields in dedicated variables:
		SET @old_user_id := OLD.user_id;
		SET @old_component_id := OLD.component_id;

	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'component_cc';
		SET @bzfe_field = 'id, name, description, isbuggroup, userregexp, isactive, icon_url';
		SET @previous_value = CONCAT (
				@old_user_id
				, ', '
				, @old_component_id
			)
			;
		SET @new_value = CONCAT (
				@new_user_id
				, ', '
				, @new_component_id
			)
			;

		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_update_record_component_cc';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_update_record_components` AFTER UPDATE ON `components` 
    FOR EACH ROW 
  BEGIN

	# We capture the new values of each fields in dedicated variables:
		SET @new_id := NEW.id;
		SET @new_name := NEW.name;
		SET @new_product_id := NEW.product_id;
		SET @new_initialowner := NEW.initialowner;
		SET @new_initialqacontact := NEW.initialqacontact;
		SET @new_description := NEW.description;
		SET @new_isactive := NEW.isactive;

	# We capture the old values of each fields in dedicated variables:
		SET @old_id := OLD.id;
		SET @old_name := OLD.name;
		SET @old_product_id := OLD.product_id;
		SET @old_initialowner := OLD.initialowner;
		SET @old_initialqacontact := OLD.initialqacontact;
		SET @old_description := OLD.description;
		SET @old_isactive := OLD.isactive;

	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'components';
		SET @bzfe_field = 'id, name, product_id, initialowner, initialqacontact, description, isactive';
		SET @previous_value = CONCAT (
				@old_id
				, ', '
				, @old_name
				, ', '
				, @old_product_id
				, ', '
				, @old_initialowner
				, ', '
				, IFNULL(@old_initialqacontact, '(NULL)')
				, ', '
				, @old_description
				, ', '
				, @old_isactive
			)
			;
		SET @new_value = CONCAT (
				@new_id
				, ', '
				, @new_name
				, ', '
				, @new_product_id
				, ', '
				, @new_initialowner
				, ', '
				, IFNULL(@new_initialqacontact, '(NULL)')
				, ', '
				, @new_description
				, ', '
				, @new_isactive
			)
			;

		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_update_record_components';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_update_record_flaginclusions` AFTER UPDATE ON `flaginclusions` 
    FOR EACH ROW 
  BEGIN

	# We capture the new values of each fields in dedicated variables:
		SET @new_type_id := NEW.type_id;
		SET @new_product_id := NEW.product_id;
		SET @new_component_id := NEW.component_id;

	# We capture the old values of each fields in dedicated variables:
		SET @old_type_id := OLD.type_id;
		SET @old_product_id := OLD.product_id;
		SET @old_component_id := OLD.component_id;

	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'flaginclusions';
		SET @bzfe_field = 'type_id, product_id, component_id';
		SET @previous_value = CONCAT (
				@old_type_id
				, ', '
				, IFNULL(@old_product_id, '(NULL)')
				, ', '
				, IFNULL(@old_component_id, '(NULL)') 
			)
			;
		SET @new_value = CONCAT (
				@new_type_id
				, ', '
				, IFNULL(@new_product_id, '(NULL)')
				, ', '
				, IFNULL(@new_component_id, '(NULL)')	 
			)
			;

		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_update_record_flaginclusions';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_update_record_flagtypes` AFTER UPDATE ON `flagtypes` 
    FOR EACH ROW 
  BEGIN

	# We capture the new values of each fields in dedicated variables:
		SET @new_id := NEW.id;
		SET @new_name := NEW.name;
		SET @new_description := NEW.description;
		SET @new_cc_list := NEW.cc_list;
		SET @new_target_type := NEW.target_type;
		SET @new_is_active := NEW.is_active;
		SET @new_is_requestable := NEW.is_requestable;
		SET @new_is_requesteeble := NEW.is_requesteeble;
		SET @new_is_multiplicable := NEW.is_multiplicable;
		SET @new_sortkey := NEW.sortkey;
		SET @new_grant_group_id := NEW.grant_group_id;
		SET @new_request_group_id := NEW.request_group_id;

	# We capture the old values of each fields in dedicated variables:
		SET @old_id := OLD.id;
		SET @old_name := OLD.name;
		SET @old_description := OLD.description;
		SET @old_cc_list := OLD.cc_list;
		SET @old_target_type := OLD.target_type;
		SET @old_is_active := OLD.is_active;
		SET @old_is_requestable := OLD.is_requestable;
		SET @old_is_requesteeble := OLD.is_requesteeble;
		SET @old_is_multiplicable := OLD.is_multiplicable;
		SET @old_sortkey := OLD.sortkey;
		SET @old_grant_group_id := OLD.grant_group_id;
		SET @old_request_group_id := OLD.request_group_id;

	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'flagtypes';
		SET @bzfe_field = 'id, name, description, cc_list, target_type, is_active, is_requestable, is_requesteeble, is_multiplicable, sortkey, grant_group_id, request_group_id';
		SET @previous_value = CONCAT (
				@new_id
				, ', '
				, @new_name
				, ', '
				, @new_description
				, ', '
				, IFNULL(@new_cc_list, '(NULL)')
				, ', '
				, @new_target_type
				, ', '
				, @new_is_active
				, ', '
				, @new_is_requestable
				, ', '
				, @new_is_requesteeble
				, ', '
				, @new_is_multiplicable
				, ', '
				, @new_sortkey
				, ', '
				, IFNULL(@new_grant_group_id, '(NULL)')
				, ', '
				, IFNULL(@new_request_group_id, '(NULL)')	
			)
			;
		SET @new_value = CONCAT (
				@old_id
				, ', '
				, @old_name
				, ', '
				, @old_description
				, ', '
				, IFNULL(@old_cc_list, '(NULL)')
				, ', '
				, @old_target_type
				, ', '
				, @old_is_active
				, ', '
				, @old_is_requestable
				, ', '
				, @old_is_requesteeble
				, ', '
				, @old_is_multiplicable
				, ', '
				, @old_sortkey
				, ', '
				, IFNULL(@old_grant_group_id, '(NULL)')
				, ', '
				, IFNULL(@old_request_group_id, '(NULL)')	
			)
			;

		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_update_record_flagtypes';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_update_record_group_control_map` AFTER UPDATE ON `group_control_map` 
    FOR EACH ROW 
  BEGIN

	# We capture the new values of each fields in dedicated variables:
		SET @new_group_id := NEW.group_id;
		SET @new_product_id := NEW.product_id;
		SET @new_entry := NEW.entry;
		SET @new_membercontrol := NEW.membercontrol;
		SET @new_othercontrol := NEW.othercontrol;
		SET @new_canedit := NEW.canedit;
		SET @new_editcomponents := NEW.editcomponents;
		SET @new_editbugs := NEW.editbugs;
		SET @new_canconfirm := NEW.canconfirm;

	# We capture the old values of each fields in dedicated variables:
		SET @old_group_id := OLD.group_id;
		SET @old_product_id := OLD.product_id;
		SET @old_entry := OLD.entry;
		SET @old_membercontrol := OLD.membercontrol;
		SET @old_othercontrol := OLD.othercontrol;
		SET @old_canedit := OLD.canedit;
		SET @old_editcomponents := OLD.editcomponents;
		SET @old_editbugs := OLD.editbugs;
		SET @old_canconfirm := OLD.canconfirm;

	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'group_control_map';
		SET @bzfe_field = 'group_id, product_id, entry, membercontrol, othercontrol, canedit, editcomponents, editbugs, canconfirm';
		SET @previous_value = CONCAT (
				@old_group_id
				, ', '
				, @old_product_id
				, ', '
				, @old_entry
				, ', '
				, @old_membercontrol
				, ', '
				, @old_othercontrol
				, ', '
				, @old_canedit
				, ', '
				, @old_editcomponents
				, ', '
				, @old_editbugs
				, ', '
				, @old_canconfirm
			)
			;
		SET @new_value = CONCAT (
				@new_group_id
				, ', '
				, @new_product_id
				, ', '
				, @new_entry
				, ', '
				, @new_membercontrol
				, ', '
				, @new_othercontrol
				, ', '
				, @new_canedit
				, ', '
				, @new_editcomponents
				, ', '
				, @new_editbugs
				, ', '
				, @new_canconfirm
			)
			;

		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_update_record_group_control_map';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_update_record_group_group_map` AFTER UPDATE ON `group_group_map` 
    FOR EACH ROW 
  BEGIN

	# We capture the new values of each fields in dedicated variables:
		SET @new_member_id := NEW.member_id;
		SET @new_grantor_id := NEW.grantor_id;
		SET @new_grant_type := NEW.grant_type;
		
	# We capture the old values of each fields in dedicated variables:
		SET @old_member_id := OLD.member_id;
		SET @old_grantor_id := OLD.grantor_id;
		SET @old_grant_type := OLD.grant_type;
		
	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'group_group_map';
		SET @bzfe_field = 'member_id, grantor_id, grant_type';
		SET @previous_value = CONCAT (
				@old_member_id
				, ', '
				, @old_grantor_id
				, ', '
				, @old_grant_type
			)
			;
		SET @new_value = CONCAT (
				@new_member_id
				, ', '
				, @new_grantor_id
				, ', '
				, @new_grant_type
			)
			;

		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_update_record_group_group_map';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_update_record_groups` AFTER UPDATE ON `groups` 
    FOR EACH ROW 
  BEGIN

	# We capture the new values of each fields in dedicated variables:
		SET @new_id := NEW.id;
		SET @new_name := NEW.name;
		SET @new_description := NEW.description;
		SET @new_isbuggroup := NEW.isbuggroup;
		SET @new_userregexp := NEW.userregexp;
		SET @new_isactive := NEW.isactive;
		SET @new_icon_url := NEW.icon_url;

	# We capture the old values of each fields in dedicated variables:
		SET @old_id := OLD.id;
		SET @old_name := OLD.name;
		SET @old_description := OLD.description;
		SET @old_isbuggroup := OLD.isbuggroup;
		SET @old_userregexp := OLD.userregexp;
		SET @old_isactive := OLD.isactive;
		SET @old_icon_url := OLD.icon_url;

	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'groups';
		SET @bzfe_field = 'id, name, description, isbuggroup, userregexp, isactive, icon_url';
		SET @previous_value = CONCAT (
				@old_id
				, ', '
				, @old_name
				, ', '
				, @old_description
				, ', '
				, @old_isbuggroup
				, ', '
				, IFNULL(@old_userregexp, '(NULL)')
				, ', '
				, @old_isactive
				, ', '
				, IFNULL(@old_icon_url, '(NULL)')
			)
			;
		SET @new_value = CONCAT (
				 @new_id
				, ', '
				, @new_name
				, ', '
				, @new_description
				, ', '
				, @new_isbuggroup
				, ', '
				, IFNULL(@new_userregexp, '(NULL)')
				, ', '
				, @new_isactive
				, ', '
				, IFNULL(@new_icon_url, '(NULL)')
			)
			;

		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_update_record_groups';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_update_record_milestones` AFTER UPDATE ON `milestones` 
    FOR EACH ROW 
  BEGIN

	# We capture the new values of each fields in dedicated variables:
		SET @new_id := NEW.id;
		SET @new_product_id := NEW.product_id;
		SET @new_value := NEW.value;
		SET @new_sortkey := NEW.sortkey;
		SET @new_isactive := NEW.isactive;

	# We capture the old values of each fields in dedicated variables:
		SET @old_id := OLD.id;
		SET @old_product_id := OLD.product_id;
		SET @old_value := OLD.value;
		SET @old_sortkey := OLD.sortkey;
		SET @old_isactive := OLD.isactive;

	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'milestones';
		SET @bzfe_field = 'id, product_id, value, sortkey, isactive';
		SET @previous_value = CONCAT (
				@old_id
				, ', '
				, @old_product_id
				, ', '
				, @old_value
				, ', '
				, @old_sortkey
				, ', '
				, @old_isactive
			)
			;
		SET @new_value = CONCAT (
				@new_id
				, ', '
				, @new_product_id
				, ', '
				, @new_value
				, ', '
				, @new_sortkey
				, ', '
				, @new_isactive
			)
			;

		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_update_record_milestones';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_update_record_products` AFTER UPDATE ON `products` 
    FOR EACH ROW 
  BEGIN

	# We capture the new values of each fields in dedicated variables:
		SET @new_name := NEW.name;
		SET @new_classification_id := NEW.classification_id;
		SET @new_description := NEW.description;
		SET @new_isactive := NEW.isactive;
		SET @new_defaultmilestone := NEW.defaultmilestone;
		SET @new_allows_unconfirmed := NEW.allows_unconfirmed;

	# We capture the old values of each fields in dedicated variables:
		SET @old_name := OLD.name;
		SET @old_classification_id := OLD.classification_id;
		SET @old_description := OLD.description;
		SET @old_isactive := OLD.isactive;
		SET @old_defaultmilestone := OLD.defaultmilestone;
		SET @old_allows_unconfirmed := OLD.allows_unconfirmed;

	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'products';
		SET @bzfe_field = 'name, classification_id, description, isactive, defaultmilestone, allows_unconfirmed';
		SET @previous_value = CONCAT (
				@old_name
				, ', '
				, @old_classification_id
				, ', '
				, @old_description
				, ', '
				, @old_isactive
				, ', '
				, @old_defaultmilestone
				, ', '
				, @old_allows_unconfirmed
			)
			;
		SET @new_value = CONCAT (
				 @new_name
				, ', '
				, @new_classification_id
				, ', '
				, @new_description
				, ', '
				, @new_isactive
				, ', '
				, @new_defaultmilestone
				, ', '
				, @new_allows_unconfirmed
			)
			;

		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_update_record_products';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_update_record_user_group_map` AFTER UPDATE ON `user_group_map` 
    FOR EACH ROW 
  BEGIN

	# We capture the new values of each fields in dedicated variables:
		SET @new_user_id := NEW.user_id;
		SET @new_group_id := NEW.group_id;
		SET @new_isbless := NEW.isbless;
		SET @new_grant_type := NEW.grant_type;

	# We capture the old values of each fields in dedicated variables:
		SET @old_user_id := OLD.user_id;
		SET @old_group_id := OLD.group_id;
		SET @old_isbless := OLD.isbless;
		SET @old_grant_type := OLD.grant_type;

	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'user_group_map';
		SET @bzfe_field = 'user_id, group_id, isbless, grant_type';
		SET @previous_value = CONCAT (
				@old_user_id
				, ', '
				, @old_group_id
				, ', '
				, @old_isbless
				, ', '
				, @old_grant_type
				)
				;
		SET @new_value = CONCAT (
				@new_user_id
				, ', '
				, @new_group_id
				, ', '
				, @new_isbless
				, ', '
				, @new_grant_type
				)
				;

		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_update_record_user_group_map';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_update_record_ut_data_to_create_units` AFTER UPDATE ON `ut_data_to_create_units` 
    FOR EACH ROW 
  BEGIN

	# We capture the new values of each fields in dedicated variables:
		SET @new_id_unit_to_create := NEW.id_unit_to_create;
		SET @new_mefe_unit_id := NEW.mefe_unit_id;
		SET @new_mefe_unit_id_int_value := NEW.mefe_unit_id_int_value;
		SET @new_mefe_creator_user_id := NEW.mefe_creator_user_id;
		SET @new_bzfe_creator_user_id := NEW.bzfe_creator_user_id;
		SET @new_classification_id := NEW.classification_id;
		SET @new_unit_name := NEW.unit_name;
		SET @new_unit_description_details := NEW.unit_description_details;
		SET @new_bz_created_date := NEW.bz_created_date;
		SET @new_comment := NEW.comment;
		SET @new_product_id := NEW.product_id;
		SET @new_deleted_datetime := NEW.deleted_datetime;
		SET @new_deletion_script := NEW.deletion_script;
		
	# We capture the old values of each fields in dedicated variables:
		SET @old_id_unit_to_create := OLD.id_unit_to_create;
		SET @old_mefe_unit_id := OLD.mefe_unit_id;
		SET @old_mefe_unit_id_int_value := old.mefe_unit_id_int_value;
		SET @old_mefe_creator_user_id := OLD.mefe_creator_user_id;
		SET @old_bzfe_creator_user_id := OLD.bzfe_creator_user_id;
		SET @old_classification_id := OLD.classification_id;
		SET @old_unit_name := OLD.unit_name;
		SET @old_unit_description_details := OLD.unit_description_details;
		SET @old_bz_created_date := OLD.bz_created_date;
		SET @old_comment := OLD.comment;
		SET @old_product_id := OLD.product_id;
		SET @old_deleted_datetime := OLD.deleted_datetime;
		SET @old_deletion_script := OLD.deletion_script;
		
	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'ut_data_to_create_units';
		SET @bzfe_field = 'id_unit_to_create, mefe_unit_id, mefe_creator_user_id, bzfe_creator_user_id, classification_id, unit_name, unit_description_details, bz_created_date, comment, product_id, deleted_datetime, deletion_script';
		SET @previous_value = CONCAT (
				@old_id_unit_to_create
				, ', '
				, IFNULL(@old_mefe_unit_id, '(NULL)')
				, ', '
				, IFNULL(@old_mefe_unit_id_int_value, '(NULL)')
				, ', '
				, IFNULL(@old_mefe_creator_user_id, '(NULL)')
				, ', '
				, @old_bzfe_creator_user_id
				, ', '
				, @old_classification_id
				, ', '
				, @old_unit_name
				, ', '
				, IFNULL(@old_unit_description_details, '(NULL)')
				, ', '
				, IFNULL(@old_bz_created_date, '(NULL)')
				, ', '
				, IFNULL(@old_comment, '(NULL)')
				, ', '
				, IFNULL(@old_product_id, '(NULL)')
				, ', '
				, IFNULL(@old_deleted_datetime, '(NULL)')
				, ', '
				, IFNULL(@old_deletion_script, '(NULL)')
			)
			;
		SET @new_value = CONCAT (
				@new_id_unit_to_create
				, ', '
				, IFNULL(@new_mefe_unit_id, '(NULL)')
				, ', '
				, IFNULL(@new_mefe_unit_id_int_value, '(NULL)')
				, ', '
				, IFNULL(@new_mefe_creator_user_id, '(NULL)')
				, ', '
				, @new_bzfe_creator_user_id
				, ', '
				, @new_classification_id
				, ', '
				, @new_unit_name
				, ', '
				, IFNULL(@new_unit_description_details, '(NULL)')
				, ', '
				, IFNULL(@new_bz_created_date, '(NULL)')
				, ', '
				, IFNULL(@new_comment, '(NULL)')
				, ', '
				, IFNULL(@new_product_id, '(NULL)')
				, ', '
				, IFNULL(@new_deleted_datetime, '(NULL)')
				, ', '
				, IFNULL(@new_deletion_script, '(NULL)')
			)
			;

		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_update_record_ut_data_to_create_units';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_update_record_ut_invitation_api_data` AFTER UPDATE ON `ut_invitation_api_data` 
    FOR EACH ROW 
  BEGIN

	# We capture the new values of each fields in dedicated variables:
		SET @new_id := NEW.id;
		SET @new_mefe_invitation_id := NEW.mefe_invitation_id;
		SET @new_mefe_invitation_id_int_value := NEW.mefe_invitation_id_int_value;
		SET @new_bzfe_invitor_user_id := NEW.bzfe_invitor_user_id;
		SET @new_bz_user_id := NEW.bz_user_id;
		SET @new_user_role_type_id := NEW.user_role_type_id;
		SET @new_is_occupant := NEW.is_occupant;
		SET @new_bz_case_id := NEW.bz_case_id;
		SET @new_bz_unit_id := NEW.bz_unit_id;
		SET @new_invitation_type := NEW.invitation_type;
		SET @new_is_mefe_only_user := NEW.is_mefe_only_user;
		SET @new_user_more := NEW.user_more;
		SET @new_mefe_invitor_user_id := NEW.mefe_invitor_user_id;
		SET @new_processed_datetime := NEW.processed_datetime;
		SET @new_script := NEW.script;
		SET @new_api_post_datetime := NEW.api_post_datetime;
		
	# We capture the old values of each fields in dedicated variables:
		SET @old_id := OLD.id;
		SET @old_mefe_invitation_id := OLD.mefe_invitation_id;
		SET @old_mefe_invitation_id_int_value := OLD.mefe_invitation_id_int_value;
		SET @old_bzfe_invitor_user_id := OLD.bzfe_invitor_user_id;
		SET @old_bz_user_id := OLD.bz_user_id;
		SET @old_user_role_type_id := OLD.user_role_type_id;
		SET @old_is_occupant := OLD.is_occupant;
		SET @old_bz_case_id := OLD.bz_case_id;
		SET @old_bz_unit_id := OLD.bz_unit_id;
		SET @old_invitation_type := OLD.invitation_type;
		SET @old_is_mefe_only_user := OLD.is_mefe_only_user;
		SET @old_user_more := OLD.user_more;
		SET @old_mefe_invitor_user_id := OLD.mefe_invitor_user_id;
		SET @old_processed_datetime := OLD.processed_datetime;
		SET @old_script := OLD.script;
		SET @old_api_post_datetime := OLD.api_post_datetime;
				
	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'ut_invitation_api_data';
		SET @bzfe_field = 'id, mefe_invitation_id, mefe_invitation_id_int_value, bzfe_invitor_user_id, bz_user_id, user_role_type_id, is_occupant, bz_case_id, bz_unit_id, invitation_type, is_mefe_only_user, user_more, mefe_invitor_user_id, processed_datetime, script, api_post_datetime';
		SET @previous_value = CONCAT (
				@old_id
				, ', '
				, IFNULL(@old_mefe_invitation_id, '(NULL)')
				, ', '
				, IFNULL(@old_mefe_invitation_id_int_value, '(NULL)')
				, ', '
				, @old_bzfe_invitor_user_id
				, ', '
				, @old_bz_user_id
				, ', '
				, @old_user_role_type_id
				, ', '
				, IFNULL(@old_is_occupant, '(NULL)')
				, ', '
				, IFNULL(@old_bz_case_id, '(NULL)')
				, ', '
				, @old_bz_unit_id
				, ', '
				, @old_invitation_type
				, ', '
				, IFNULL(@old_is_mefe_only_user, '(NULL)')
				, ', '
				, IFNULL(@old_user_more, '(NULL)')
				, ', '
				, IFNULL(@old_mefe_invitor_user_id, '(NULL)')
				, ', '
				, IFNULL(@old_processed_datetime, '(NULL)')
				, ', '
				, IFNULL(@old_script, '(NULL)')
				, ', '
				, IFNULL(@old_api_post_datetime, '(NULL)')
			)
			;
		SET @new_value = CONCAT (
				@new_id
				, ', '
				, IFNULL(@new_mefe_invitation_id, '(NULL)')
				, ', '
				, IFNULL(@new_mefe_invitation_id_int_value, '(NULL)')
				, ', '
				, @new_bzfe_invitor_user_id
				, ', '
				, @new_bz_user_id
				, ', '
				, @new_user_role_type_id
				, ', '
				, IFNULL(@new_is_occupant, '(NULL)')
				, ', '
				, IFNULL(@new_bz_case_id, '(NULL)')
				, ', '
				, @new_bz_unit_id
				, ', '
				, @new_invitation_type
				, ', '
				, IFNULL(@new_is_mefe_only_user, '(NULL)')
				, ', '
				, IFNULL(@new_user_more, '(NULL)')
				, ', '
				, IFNULL(@new_mefe_invitor_user_id, '(NULL)')
				, ', '
				, IFNULL(@new_processed_datetime, '(NULL)')
				, ', '
				, IFNULL(@new_script, '(NULL)')
				, ', '
				, IFNULL(@new_api_post_datetime, '(NULL)')
			)
			;

		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_update_record_ut_invitation_api_data';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_update_record_ut_product_group` AFTER UPDATE ON `ut_product_group` 
    FOR EACH ROW 
  BEGIN

	# We capture the new values of each fields in dedicated variables:
		SET @new_product_id := NEW.product_id;
		SET @new_component_id := NEW.component_id;
		SET @new_group_id := NEW.group_id;
		SET @new_group_type_id := NEW.group_type_id;
		SET @new_role_type_id := NEW.role_type_id;
		SET @new_created_by_id := NEW.created_by_id;
		SET @new_created := NEW.created;
		
	# We capture the old values of each fields in dedicated variables:
		SET @old_product_id := OLD.product_id;
		SET @old_component_id := OLD.component_id;
		SET @old_group_id := OLD.group_id;
		SET @old_group_type_id := OLD.group_type_id;
		SET @old_role_type_id := OLD.role_type_id;
		SET @old_created_by_id := OLD.created_by_id;
		SET @old_created := OLD.created;
		
	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'ut_product_group';
		SET @bzfe_field = 'product_id, component_id, group_id, group_type_id, role_type_id, created_by_id, created';
		SET @previous_value = CONCAT (
				@old_product_id
				, ', '
				, IFNULL(@old_component_id, '(NULL)')
				, ', '
				, @old_group_id
				, ', '
				, @old_group_type_id
				, ', '
				, IFNULL(@old_role_type_id, '(NULL)')
				, ', '
				, IFNULL(@old_created_by_id, '(NULL)')
				, ', '
				, IFNULL(@old_created, '(NULL)')
			)
			;
		SET @new_value = CONCAT (
				@new_product_id
				, ', '
				, IFNULL(@new_component_id, '(NULL)')
				, ', '
				, @new_group_id
				, ', '
				, @new_group_type_id
				, ', '
				, IFNULL(@new_role_type_id, '(NULL)')
				, ', '
				, IFNULL(@new_created_by_id, '(NULL)')
				, ', '
				, IFNULL(@new_created, '(NULL)')
			)
			;

		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_update_record_ut_product_group';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `trig_update_audit_log_update_record_versions` AFTER UPDATE ON `versions` 
    FOR EACH ROW 
  BEGIN

	# We capture the new values of each fields in dedicated variables:
		SET @new_id := NEW.id;
		SET @new_value := NEW.value;
		SET @new_product_id := NEW.product_id;
		SET @new_isactive := NEW.isactive;

	# We capture the old values of each fields in dedicated variables:
		SET @old_id := OLD.id;
		SET @old_value := OLD.value;
		SET @old_product_id := OLD.product_id;
		SET @old_isactive := OLD.isactive;

	# We set the variable we need to update the log with relevant information:
		SET @bzfe_table = 'versions';
		SET @bzfe_field = 'id, value, product_id, isactive';
		SET @previous_value = CONCAT (
				@old_id
				, ', '
				, @old_value
				, ', '
				, @old_product_id
				, ', '
				, @old_isactive
			)
			;
		SET @new_value = CONCAT (
				@new_id
				, ', '
				, @new_value
				, ', '
				, @new_product_id
				, ', '
				, @new_isactive
			)
			;

		# The @script variable is defined by the highest level script we have - we do NOT change that
		SET @comment = 'called via the trigger trig_update_audit_log_update_record_versions';

	# We have all the variables:
		#	- @bzfe_table: the table that was updated
		#	- @bzfe_field: The fields that were updated
		#	- @previous_value: The previouso value for the field
		#	- @new_value: the values captured by the trigger when the new value is inserted.
		#	- @script: the script that is calling this procedure
		#	- @comment: a text to give some context ex: "this was created by a trigger xxx"

		CALL `update_audit_log`;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `update_the_log_of_closed_cases` AFTER UPDATE ON `bugs` 
    FOR EACH ROW 
  BEGIN
	IF NEW.`bug_status` <> OLD.`bug_status` 
		THEN
		# Capture the new bug status
			SET @new_bug_status := NEW.`bug_status`;
			SET @old_bug_status := OLD.`bug_status`;
		
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


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `update_the_log_of_enabled_units_when_unit_is_deleted` AFTER DELETE ON `products` 
    FOR EACH ROW 
  BEGIN
	CALL `update_log_count_enabled_units`;
END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `update_the_log_of_enabled_units_when_unit_is_updated` AFTER UPDATE ON `products` 
    FOR EACH ROW 
  BEGIN
	IF NEW.`isactive` <> OLD.`isactive` 
		THEN
		# If these are different, then we need to update the log of closed cases
			CALL `update_log_count_enabled_units`;
	END IF;
END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `ut_notification_classify_messages` AFTER INSERT ON `longdescs` 
    FOR EACH ROW 
BEGIN
	# Clean Slate: make sure all the variables we use are properly flushed first
		SET @notification_id = NULL;
		SET @created_datetime = NULL;
		SET @unit_id = NULL;
		SET @case_id = NULL;
		SET @case_title = NULL;
		SET @user_id = NULL;
		SET @count_comments = NULL;
		SET @is_case_description = NULL;
		SET @message = NULL;
		SET @message_sanitized_1 = NULL;
		SET @message_sanitized_2 = NULL;
		SET @message_sanitized_3 = NULL;
		SET @message_truncated = NULL;
		SET @case_reporter_user_id = NULL;
		SET @old_case_assignee_user_id = NULL;
		SET @new_case_assignee_user_id = NULL;
		SET @current_list_of_invitees_1 = NULL;
		SET @current_list_of_invitees = NULL;
		SET @current_status = NULL;
		SET @current_resolution = NULL;
		SET @current_severity = NULL;

	# We have a clean slate, define the variables now
		SET @notification_id = ((SELECT MAX(`notification_id`) FROM `ut_notification_message_new`) + 1);
		SET @created_datetime = NOW();
		SET @unit_id = (SELECT `product_id` FROM `bugs` WHERE `bug_id` = NEW.`bug_id`);
		SET @case_id = NEW.`bug_id`;
		SET @case_title = (SELECT `short_desc` FROM `bugs` WHERE `bug_id` = @case_id);
		SET @user_id = NEW.`who`;
		SET @count_comments = (SELECT COUNT(`comment_id`)
			FROM
				`longdescs`
				WHERE `bug_id` = @case_id
			GROUP BY `bug_id`)
			;
		SET @is_case_description = IF(@count_comments = 1 , 1, 0);
		SET @message = (CAST(NEW.`thetext` AS CHAR));
		SET @message_sanitized_1 = REPLACE(@message, '\r\n', ' ');
		SET @message_sanitized_2 = REPLACE(@message_sanitized_1, '\r', ' ');
		SET @message_sanitized_3 = REPLACE(@message_sanitized_2, '\n', ' ');
		SET @message_truncated = (SUBSTRING(@message_sanitized_3, 1, 255));
		SET @case_reporter_user_id = (SELECT `reporter` FROM `bugs` WHERE `bug_id` = @case_id);
		SET @old_case_assignee_user_id = (SELECT `assigned_to` FROM `bugs` WHERE `bug_id` = @case_id);
		SET @new_case_assignee_user_id = (SELECT `assigned_to` FROM `bugs` WHERE `bug_id` = @case_id);
		SET @current_list_of_invitees_1 = (SELECT GROUP_CONCAT(DISTINCT `who` ORDER BY `who` SEPARATOR ', ')
			FROM `cc`
			WHERE `bug_id` = @case_id
			GROUP BY `bug_id`)
			;
		SET @current_list_of_invitees = IFNULL(@current_list_of_invitees_1, 0);
		SET @current_status = (SELECT `bug_status` FROM `bugs` WHERE `bug_id` = @case_id);
		SET @current_resolution = (SELECT `resolution` FROM `bugs` WHERE `bug_id` = @case_id);
		SET @current_severity = (SELECT `bug_severity` FROM `bugs` WHERE `bug_id` = @case_id);
		
	# We insert the event in the relevant notification table
		INSERT INTO `ut_notification_message_new`
			(notification_id
			, `created_datetime`
			, `unit_id`
			, `case_id`
			, `case_title`
			, `user_id`
			, `is_case_description`
			, `message_truncated`
			, `case_reporter_user_id`
			, `old_case_assignee_user_id`
			, `new_case_assignee_user_id`
			, `current_list_of_invitees`
			, `current_status`
			, `current_resolution`
			, `current_severity`
			)
			VALUES
			(@notification_id
			, @created_datetime
			, @unit_id
			, @case_id
			, @case_title
			, @user_id
			, @is_case_description
			, @message_truncated
			, @case_reporter_user_id
			, @old_case_assignee_user_id
			, @new_case_assignee_user_id
			, @current_list_of_invitees
			, @current_status
			, @current_resolution
			, @current_severity
			)
			;

END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `ut_prepare_message_case_activity` AFTER INSERT ON `bugs_activity` 
    FOR EACH ROW 
BEGIN
	# Clean Slate: make sure all the variables we use are properly flushed first
		SET @notification_type = NULL;
		SET @bz_source_table = NULL;
		SET @notification_id = NULL;
		SET @unique_notification_id = NULL;
		SET @created_datetime = NULL;
		SET @unit_id = NULL;
		SET @case_id = NULL;
		SET @case_title = NULL;
		SET @user_id = NULL;
		SET @update_what = NULL;
		SET @old_value = NULL;
		SET @new_value = NULL;
		SET @case_reporter_user_id = NULL;
		SET @old_case_assignee_user_id = NULL;
		SET @new_case_assignee_user_id = NULL;
		SET @current_list_of_invitees_1 = NULL;
		SET @current_list_of_invitees = NULL;
		SET @current_status = NULL;
		SET @current_resolution = NULL;
		SET @current_severity = NULL;

	# We have a clean slate, define the variables now
		SET @notification_type = 'case_updated';
		SET @bz_source_table = 'ut_notification_case_updated';
		SET @notification_id = ((SELECT MAX(`notification_id`) FROM `ut_notification_case_updated`) + 1);
		SET @unique_notification_id = (CONCAT(@bz_source_table, '-', @notification_id));
		SET @created_datetime = NOW();
		SET @unit_id = (SELECT `product_id` FROM `bugs` WHERE `bug_id` = NEW.`bug_id`);
		SET @case_id = NEW.`bug_id`;
		SET @case_title = (SELECT `short_desc` FROM `bugs` WHERE `bug_id` = @case_id);
		SET @user_id = NEW.`who`;
		SET @update_what = (SELECT `description` FROM `fielddefs` WHERE `id` = NEW.`fieldid`);
		SET @old_value = NEW.`removed`;
		SET @new_value = NEW.`added`;
		SET @case_reporter_user_id = (SELECT `reporter` FROM `bugs` WHERE `bug_id` = @case_id);
		SET @old_case_assignee_user_id = (SELECT `assigned_to` FROM `bugs` WHERE `bug_id` = @case_id);
		SET @new_case_assignee_user_id = (SELECT `assigned_to` FROM `bugs` WHERE `bug_id` = @case_id);
		SET @current_list_of_invitees_1 = (SELECT GROUP_CONCAT(DISTINCT `who` ORDER BY `who` SEPARATOR ', ')
			FROM `cc`
			WHERE `bug_id` = @case_id
			GROUP BY `bug_id`)
			;
		SET @current_list_of_invitees = IFNULL(@current_list_of_invitees_1, 0);
		SET @current_status = (SELECT `bug_status` FROM `bugs` WHERE `bug_id` = @case_id);
		SET @current_resolution = (SELECT `resolution` FROM `bugs` WHERE `bug_id` = @case_id);
		SET @current_severity = (SELECT `bug_severity` FROM `bugs` WHERE `bug_id` = @case_id);
	
	# We insert the event in the relevant notification table
		INSERT INTO `ut_notification_case_updated`
			(notification_id
			, `created_datetime`
			, `unit_id`
			, `case_id`
			, `case_title`
			, `user_id`
			, `update_what`
			, `old_value`
			, `new_value`
			, `case_reporter_user_id`
			, `old_case_assignee_user_id`
			, `new_case_assignee_user_id`
			, `current_list_of_invitees`
			, `current_status`
			, `current_resolution`
			, `current_severity`
			)
			VALUES
			(@notification_id
			, @created_datetime
			, @unit_id
			, @case_id
			, @case_title
			, @user_id
			, @update_what
			, @old_value
			, @new_value
			, @case_reporter_user_id
			, @old_case_assignee_user_id
			, @new_case_assignee_user_id
			, @current_list_of_invitees
			, @current_status
			, @current_resolution
			, @current_severity
			)
			;
		
	# We call the Lambda procedure to notify of the change
		CALL `lambda_notification_case_updated`(@notification_type
			, @bz_source_table
			, @unique_notification_id
			, @created_datetime
			, @unit_id
			, @case_id
			, @case_title
			, @user_id
			, @update_what
			, @old_value
			, @new_value
			, @case_reporter_user_id
			, @old_case_assignee_user_id
			, @new_case_assignee_user_id
			, @current_list_of_invitees
			, @current_status
			, @current_resolution
			, @current_severity
			)
			;
END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `ut_prepare_message_case_assigned_updated` AFTER UPDATE ON `bugs` 
    FOR EACH ROW 
BEGIN
	# We only do that if the assignee has changed
	IF NEW.`assigned_to` != OLD.`assigned_to`
	THEN 
		# Clean Slate: make sure all the variables we use are properly flushed first
			SET @notification_type = NULL;
			SET @bz_source_table = NULL;
			SET @notification_id = NULL;
			SET @unique_notification_id = NULL;
			SET @created_datetime = NULL;
			SET @unit_id = NULL;
			SET @case_id = NULL;
			SET @case_title = NULL;
			SET @invitor_user_id = NULL;
			SET @case_reporter_user_id = NULL;
			SET @old_case_assignee_user_id = NULL;
			SET @new_case_assignee_user_id = NULL;
			SET @current_list_of_invitees_1 = NULL;
			SET @current_list_of_invitees = NULL;
			SET @current_status = NULL;
			SET @current_resolution = NULL;
			SET @current_severity = NULL;

		# We have a clean slate, define the variables now
			SET @notification_type = 'case_assignee_updated';
			SET @bz_source_table = 'ut_notification_case_assignee';
			SET @notification_id = ((SELECT MAX(`notification_id`) FROM `ut_notification_case_assignee`) + 1);
			SET @unique_notification_id = (CONCAT(@bz_source_table, '-', @notification_id));
			SET @created_datetime = NOW();
			SET @unit_id = NEW.`product_id`;
			SET @case_id = NEW.`bug_id`;
			SET @case_title = (SELECT `short_desc` FROM `bugs` WHERE `bug_id` = @case_id);
			SET @invitor_user_id = 0;
			SET @case_reporter_user_id = (SELECT `reporter` FROM `bugs` WHERE `bug_id` = @case_id);
			SET @old_case_assignee_user_id = OLD.`assigned_to`;
			SET @new_case_assignee_user_id = NEW.`assigned_to`;
			SET @current_list_of_invitees_1 = (SELECT GROUP_CONCAT(DISTINCT `who` ORDER BY `who` SEPARATOR ', ')
			FROM `cc`
			WHERE `bug_id` = @case_id
			GROUP BY `bug_id`)
			;
			SET @current_list_of_invitees = IFNULL(@current_list_of_invitees_1, 0);
			SET @current_status = (SELECT `bug_status` FROM `bugs` WHERE `bug_id` = @case_id);
			SET @current_resolution = (SELECT `resolution` FROM `bugs` WHERE `bug_id` = @case_id);
			SET @current_severity = (SELECT `bug_severity` FROM `bugs` WHERE `bug_id` = @case_id);
		
		# We insert the event in the relevant notification table
			INSERT INTO `ut_notification_case_assignee`
				(`notification_id`
				, `created_datetime`
				, `unit_id`
				, `case_id`
				, `case_title`
				, `invitor_user_id`
				, `case_reporter_user_id`
				, `old_case_assignee_user_id`
				, `new_case_assignee_user_id`
				, `current_list_of_invitees`
				, `current_status`
				, `current_resolution`
				, `current_severity`
				)
				VALUES
				(@notification_id
				, @created_datetime
				, @unit_id
				, @case_id
				, @case_title
				, @invitor_user_id
				, @case_reporter_user_id
				, @old_case_assignee_user_id
				, @new_case_assignee_user_id
				, @current_list_of_invitees
				, @current_status
				, @current_resolution
				, @current_severity
				)
				;
			
		# We call the Lambda procedure to notify of the change
			CALL `lambda_notification_case_assignee_updated`(@notification_type
				, @bz_source_table
				, @unique_notification_id
				, @created_datetime
				, @unit_id
				, @case_id
				, @case_title
				, @invitor_user_id
				, @case_reporter_user_id
				, @old_case_assignee_user_id
				, @new_case_assignee_user_id
				, @current_list_of_invitees
				, @current_status
				, @current_resolution
				, @current_severity
				)
				;
	END IF;
END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `ut_prepare_message_case_invited` AFTER INSERT ON `cc` 
    FOR EACH ROW 
BEGIN
	# Clean Slate: make sure all the variables we use are properly flushed first
		SET @notification_type = NULL;
		SET @bz_source_table = NULL;
		SET @notification_id = NULL;
		SET @unique_notification_id = NULL;
		SET @created_datetime = NULL;
		SET @unit_id = NULL;
		SET @case_id = NULL;
		SET @case_title = NULL;
		SET @invitee_user_id = NULL;
		SET @case_reporter_user_id = NULL;
		SET @old_case_assignee_user_id = NULL;
		SET @new_case_assignee_user_id = NULL;
		SET @current_list_of_invitees_1 = NULL;
		SET @current_list_of_invitees = NULL;
		SET @current_status = NULL;
		SET @current_resolution = NULL;
		SET @current_severity = NULL;

	# We have a clean slate, define the variables now
		SET @notification_type = 'case_user_invited';
		SET @bz_source_table = 'ut_notification_case_invited';
		SET @notification_id = ((SELECT MAX(`notification_id`) FROM `ut_notification_case_invited`) + 1);
		SET @unique_notification_id = (CONCAT(@bz_source_table, '-', @notification_id));
		SET @created_datetime = NOW();
		SET @case_id = NEW.`bug_id`;
		SET @case_title = (SELECT `short_desc` FROM `bugs` WHERE `bug_id` = @case_id);
		SET @unit_id = (SELECT `product_id` FROM `bugs` WHERE `bug_id` = @case_id);
		SET @invitee_user_id = NEW.`who`;
		SET @case_reporter_user_id = (SELECT `reporter` FROM `bugs` WHERE `bug_id` = @case_id);
		SET @old_case_assignee_user_id = (SELECT `assigned_to` FROM `bugs` WHERE `bug_id` = @case_id);
		SET @new_case_assignee_user_id = (SELECT `assigned_to` FROM `bugs` WHERE `bug_id` = @case_id);
		SET @current_list_of_invitees_1 = (SELECT GROUP_CONCAT(DISTINCT `who` ORDER BY `who` SEPARATOR ', ')
			FROM `cc`
			WHERE `bug_id` = @case_id
			GROUP BY `bug_id`)
			;
		SET @current_list_of_invitees = IFNULL(@current_list_of_invitees_1, 0);
		SET @current_status = (SELECT `bug_status` FROM `bugs` WHERE `bug_id` = @case_id);
		SET @current_resolution = (SELECT `resolution` FROM `bugs` WHERE `bug_id` = @case_id);
		SET @current_severity = (SELECT `bug_severity` FROM `bugs` WHERE `bug_id` = @case_id);

	# We insert the event in the relevant notification table		
		INSERT INTO `ut_notification_case_invited`
			(`notification_id`
			, `created_datetime`
			, `unit_id`
			, `case_id`
			, `case_title`
			, `invitee_user_id`
			, `case_reporter_user_id`
			, `old_case_assignee_user_id`
			, `new_case_assignee_user_id`
			, `current_list_of_invitees`
			, `current_status`
			, `current_resolution`
			, `current_severity`
			)
			VALUES
			(@notification_id
			, @created_datetime
			, @unit_id
			, @case_id
			, @case_title
			, @invitee_user_id
			, @case_reporter_user_id
			, @old_case_assignee_user_id
			, @new_case_assignee_user_id
			, @current_list_of_invitees
			, @current_status
			, @current_resolution
			, @current_severity
			)
			;
		
	# We call the Lambda procedure to notify of the change
		CALL `lambda_notification_case_invited`(@notification_type
			, @bz_source_table
			, @unique_notification_id
			, @created_datetime
			, @unit_id
			, @case_id
			, @case_title
			, @invitee_user_id
			, @case_reporter_user_id
			, @old_case_assignee_user_id
			, @new_case_assignee_user_id
			, @current_list_of_invitees
			, @current_status
			, @current_resolution
			, @current_severity
			)
			;
END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `ut_prepare_message_new_case` AFTER INSERT ON `bugs` 
    FOR EACH ROW 
BEGIN
	# Clean Slate: make sure all the variables we use are properly flushed first
		SET @notification_type = NULL;
		SET @bz_source_table = NULL;
		SET @notification_id = NULL;
		SET @unique_notification_id = NULL;
		SET @created_datetime = NULL;
		SET @unit_id = NULL;
		SET @case_id = NULL;
		SET @case_title = NULL;
		SET @reporter_user_id = NULL;
		SET @assignee_user_id = NULL;
		SET @current_status = NULL;
		SET @current_resolution = NULL;
		SET @current_severity = NULL;

	# We have a clean slate, define the variables now
		SET @notification_type = 'case_new';
		SET @bz_source_table = 'ut_notification_case_new';
		SET @notification_id = ((SELECT MAX(`notification_id`) FROM `ut_notification_case_new`) + 1);
		SET @unique_notification_id = (CONCAT(@bz_source_table, '-', @notification_id));
		SET @created_datetime = NOW();
		SET @unit_id = NEW.`product_id`;
		SET @case_id = NEW.`bug_id`;
		SET @case_title = NEW.`short_desc`;
		SET @reporter_user_id = NEW.`reporter`;
		SET @assignee_user_id = NEW.`assigned_to`;
		SET @current_status = NEW.`bug_status`;
		SET @current_resolution = NEW.`resolution`;
		SET @current_severity = NEW.`bug_severity`;
	
	# We insert the event in the notification table
		INSERT INTO `ut_notification_case_new`
			(notification_id
			, `created_datetime`
			, `unit_id`
			, `case_id`
			, `case_title`
			, `reporter_user_id`
			, `assignee_user_id`
			, `current_status`
			, `current_resolution`
			, `current_severity`
			)
			VALUES
			(@notification_id
			, NOW()
			, @unit_id
			, @case_id
			, @case_title
			, @reporter_user_id
			, @assignee_user_id
			, @current_status
			, @current_resolution
			, @current_severity
			)
			;
	
	# We call the Lambda procedure to notify of the change
		CALL `lambda_notification_case_new`(@notification_type
			, @bz_source_table
			, @unique_notification_id
			, @created_datetime
			, @unit_id
			, @case_id
			, @case_title
			, @reporter_user_id
			, @assignee_user_id
			, @current_status
			, @current_resolution
			, @current_severity
			)
			;
END;
$$
DELIMITER ;


/* Create Trigger in target */

DELIMITER $$
CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `ut_prepare_message_new_comment` AFTER INSERT ON `ut_notification_message_new` 
    FOR EACH ROW 
BEGIN
	# We only do this is this is a new comment, not if this is a description
	IF NEW.`is_case_description` != 1
	THEN
		# Clean Slate: make sure all the variables we use are properly flushed first
			SET @notification_type = NULL;
			SET @bz_source_table = NULL;
			SET @notification_id = NULL;
			SET @unique_notification_id = NULL;
			SET @created_datetime = NULL;
			SET @unit_id = NULL;
			SET @case_id = NULL;
			SET @case_title = NULL;
			SET @user_id = NULL;
			SET @message_truncated = NULL;
			SET @case_reporter_user_id = NULL;
			SET @old_case_assignee_user_id = NULL;
			SET @new_case_assignee_user_id = NULL;
			SET @current_list_of_invitees = NULL;
			SET @current_status = NULL;
			SET @current_resolution = NULL;
			SET @current_severity = NULL;

		# We have a clean slate, define the variables now
			SET @notification_type = 'case_new_message';
			SET @bz_source_table = 'ut_notification_message_new';
			SET @notification_id = NEW.`notification_id`;
			SET @unique_notification_id = (CONCAT(@bz_source_table, '-', @notification_id));
			SET @created_datetime = NEW.`created_datetime`;
			SET @unit_id = NEW.`unit_id`;
			SET @case_id = NEW.`case_id`;
			SET @case_title = NEW.`case_title`;
			SET @user_id = NEW.`user_id`;
			SET @message_truncated = NEW.`message_truncated`;
			SET @case_reporter_user_id = NEW.`case_reporter_user_id`;
			SET @old_case_assignee_user_id = NEW.`old_case_assignee_user_id`;
			SET @new_case_assignee_user_id = NEW.`new_case_assignee_user_id`;
			SET @current_list_of_invitees = NEW.`current_list_of_invitees`;
			SET @current_status = NEW.`current_status`;
			SET @current_resolution = NEW.`current_resolution`;
			SET @current_severity = NEW.`current_severity`;
			
		# We call the Lambda procedure to notify that there is a new comment
			CALL `lambda_notification_message_new_comment`(@notification_type
				, @bz_source_table
				, @unique_notification_id
				, @created_datetime
				, @unit_id
				, @case_id
				, @case_title
				, @user_id
				, @message_truncated
				, @case_reporter_user_id
				, @old_case_assignee_user_id
				, @new_case_assignee_user_id
				, @current_list_of_invitees
				, @current_status
				, @current_resolution
				, @current_severity
				)
				;
	END IF;
END;
$$
DELIMITER ;

 

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