/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

USE `bugs`; 

/* Foreign Keys must be dropped in the target to ensure that requires changes can be done*/

ALTER TABLE `attachments` 
	DROP FOREIGN KEY `fk_attachments_bug_id_bugs_bug_id`  , 
	DROP FOREIGN KEY `fk_attachments_submitter_id_profiles_userid`  ;

ALTER TABLE `audit_log` 
	DROP FOREIGN KEY `fk_audit_log_user_id_profiles_userid`  ;

ALTER TABLE `bug_see_also` 
	DROP FOREIGN KEY `fk_bug_see_also_bug_id_bugs_bug_id`  ;

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

ALTER TABLE `bugs_fulltext` 
	DROP FOREIGN KEY `fk_bugs_fulltext_bug_id_bugs_bug_id`  ;

ALTER TABLE `component_cc` 
	DROP FOREIGN KEY `fk_component_cc_component_id_components_id`  , 
	DROP FOREIGN KEY `fk_component_cc_user_id_profiles_userid`  ;

ALTER TABLE `components` 
	DROP FOREIGN KEY `fk_components_initialowner_profiles_userid`  , 
	DROP FOREIGN KEY `fk_components_initialqacontact_profiles_userid`  , 
	DROP FOREIGN KEY `fk_components_product_id_products_id`  ;

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

ALTER TABLE `tag` 
	DROP FOREIGN KEY `fk_tag_user_id_profiles_userid`  ;

ALTER TABLE `tokens` 
	DROP FOREIGN KEY `fk_tokens_userid_profiles_userid`  ;

ALTER TABLE `user_api_keys` 
	DROP FOREIGN KEY `fk_user_api_keys_user_id_profiles_userid`  ;

ALTER TABLE `versions` 
	DROP FOREIGN KEY `fk_versions_product_id_products_id`  ;

ALTER TABLE `whine_events` 
	DROP FOREIGN KEY `fk_whine_events_owner_userid_profiles_userid`  ;

ALTER TABLE `whine_queries` 
	DROP FOREIGN KEY `fk_whine_queries_eventid_whine_events_id`  ;

ALTER TABLE `whine_schedules` 
	DROP FOREIGN KEY `fk_whine_schedules_eventid_whine_events_id`  ;


/* Alter table in target */
ALTER TABLE `attach_data` DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `attachments` 
	CHANGE `creation_ts` `creation_ts` datetime   NOT NULL after `bug_id` , 
	CHANGE `modification_time` `modification_time` datetime   NOT NULL after `creation_ts` , 
	CHANGE `description` `description` tinytext  COLLATE utf8_general_ci NOT NULL after `modification_time` , 
	CHANGE `mimetype` `mimetype` tinytext  COLLATE utf8_general_ci NOT NULL after `description` , 
	CHANGE `filename` `filename` varchar(255)  COLLATE utf8_general_ci NOT NULL after `ispatch` , 
	DROP COLUMN `attach_size` , 
	DROP KEY `attachments_ispatch_idx` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `audit_log` 
	CHANGE `class` `class` varchar(255)  COLLATE utf8_general_ci NOT NULL after `user_id` , 
	CHANGE `field` `field` varchar(64)  COLLATE utf8_general_ci NOT NULL after `object_id` , 
	CHANGE `removed` `removed` mediumtext  COLLATE utf8_general_ci NULL after `field` , 
	CHANGE `added` `added` mediumtext  COLLATE utf8_general_ci NULL after `removed` , 
	CHANGE `at_time` `at_time` datetime   NOT NULL after `added` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `bug_group_map` DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `bug_see_also` 
	CHANGE `value` `value` varchar(255)  COLLATE utf8_general_ci NOT NULL after `bug_id` , 
	CHANGE `class` `class` varchar(255)  COLLATE utf8_general_ci NOT NULL DEFAULT '' after `value` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `bug_severity` 
	CHANGE `value` `value` varchar(64)  COLLATE utf8_general_ci NOT NULL after `id` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `bug_status` 
	CHANGE `value` `value` varchar(64)  COLLATE utf8_general_ci NOT NULL after `id` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `bug_tag` DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `bug_user_last_visit` 
	CHANGE `last_visit_ts` `last_visit_ts` datetime   NOT NULL after `bug_id` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci' ;

/* Alter table in target */
ALTER TABLE `bugs` 
	CHANGE `bug_file_loc` `bug_file_loc` mediumtext  COLLATE utf8_general_ci NOT NULL after `assigned_to` , 
	CHANGE `bug_severity` `bug_severity` varchar(64)  COLLATE utf8_general_ci NOT NULL after `bug_file_loc` , 
	CHANGE `bug_status` `bug_status` varchar(64)  COLLATE utf8_general_ci NOT NULL after `bug_severity` , 
	CHANGE `creation_ts` `creation_ts` datetime   NULL after `bug_status` , 
	CHANGE `delta_ts` `delta_ts` datetime   NOT NULL after `creation_ts` , 
	CHANGE `short_desc` `short_desc` varchar(255)  COLLATE utf8_general_ci NOT NULL after `delta_ts` , 
	CHANGE `op_sys` `op_sys` varchar(64)  COLLATE utf8_general_ci NOT NULL after `short_desc` , 
	CHANGE `priority` `priority` varchar(64)  COLLATE utf8_general_ci NOT NULL after `op_sys` , 
	CHANGE `rep_platform` `rep_platform` varchar(64)  COLLATE utf8_general_ci NOT NULL after `product_id` , 
	CHANGE `version` `version` varchar(64)  COLLATE utf8_general_ci NOT NULL after `reporter` , 
	CHANGE `component_id` `component_id` mediumint(9)   NOT NULL after `version` , 
	CHANGE `resolution` `resolution` varchar(64)  COLLATE utf8_general_ci NOT NULL DEFAULT '' after `component_id` , 
	CHANGE `target_milestone` `target_milestone` varchar(64)  COLLATE utf8_general_ci NOT NULL DEFAULT '---' after `resolution` , 
	CHANGE `status_whiteboard` `status_whiteboard` mediumtext  COLLATE utf8_general_ci NOT NULL after `qa_contact` , 
	CHANGE `lastdiffed` `lastdiffed` datetime   NULL after `status_whiteboard` , 
	CHANGE `deadline` `deadline` datetime   NULL after `remaining_time` , 
	DROP COLUMN `bug_type` , 
	DROP COLUMN `alias` , 
	DROP COLUMN `cf_rank` , 
	DROP COLUMN `cf_crash_signature` , 
	DROP COLUMN `cf_last_resolved` , 
	DROP COLUMN `restrict_comments` , 
	DROP COLUMN `cf_user_story` , 
	DROP COLUMN `votes` , 
	DROP KEY `bugs_alias_idx` , 
	DROP KEY `bugs_but_type_idx` , 
	DROP KEY `bugs_votes_idx` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `bugs_activity` 
	CHANGE `bug_when` `bug_when` datetime   NOT NULL after `who` , 
	CHANGE `added` `added` varchar(255)  COLLATE utf8_general_ci NULL after `fieldid` , 
	CHANGE `removed` `removed` varchar(255)  COLLATE utf8_general_ci NULL after `added` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Create table in target */
CREATE TABLE `bugs_aliases`(
	`alias` varchar(40) COLLATE utf8_general_ci NOT NULL  , 
	`bug_id` mediumint(9) NULL  , 
	UNIQUE KEY `bugs_aliases_alias_idx`(`alias`) , 
	KEY `bugs_aliases_bug_id_idx`(`bug_id`) , 
	CONSTRAINT `fk_bugs_aliases_bug_id_bugs_bug_id` 
	FOREIGN KEY (`bug_id`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE 
) ENGINE=InnoDB DEFAULT CHARSET='utf8' COLLATE='utf8_general_ci' ROW_FORMAT=Dynamic;


/* Alter table in target */
ALTER TABLE `bugs_fulltext` 
	CHANGE `short_desc` `short_desc` varchar(255)  COLLATE utf8_general_ci NOT NULL after `bug_id` , 
	CHANGE `comments` `comments` mediumtext  COLLATE utf8_general_ci NULL after `short_desc` , 
	CHANGE `comments_noprivate` `comments_noprivate` mediumtext  COLLATE utf8_general_ci NULL after `comments` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `bz_schema` DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `category_group_map` DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `cc` DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci' ;

/* Alter table in target */
ALTER TABLE `classifications` 
	CHANGE `name` `name` varchar(64)  COLLATE utf8_general_ci NOT NULL after `id` , 
	CHANGE `description` `description` mediumtext  COLLATE utf8_general_ci NULL after `name` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `component_cc` 
	CHANGE `component_id` `component_id` mediumint(9)   NOT NULL after `user_id` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `components` 
	CHANGE `id` `id` mediumint(9)   NOT NULL auto_increment first , 
	CHANGE `name` `name` varchar(64)  COLLATE utf8_general_ci NOT NULL after `id` , 
	CHANGE `description` `description` mediumtext  COLLATE utf8_general_ci NOT NULL after `initialqacontact` , 
	DROP COLUMN `default_bug_type` , 
	DROP COLUMN `triage_owner_id` , 
	DROP COLUMN `watch_user` , 
	DROP KEY `fk_components_triage_owner_id_profiles_userid` , 
	DROP KEY `fk_components_watch_user_profiles_userid` , 
	DROP FOREIGN KEY `fk_components_triage_owner_id_profiles_userid`  , 
	DROP FOREIGN KEY `fk_components_watch_user_profiles_userid`  , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `dependencies` DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `duplicates` DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `email_bug_ignore` DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `email_setting` DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `field_visibility` DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `fielddefs` 
	CHANGE `name` `name` varchar(64)  COLLATE utf8_general_ci NOT NULL after `id` , 
	CHANGE `description` `description` tinytext  COLLATE utf8_general_ci NOT NULL after `custom` , 
	ADD COLUMN `long_desc` varchar(255)  COLLATE utf8_general_ci NOT NULL DEFAULT '' after `description` , 
	CHANGE `mailhead` `mailhead` tinyint(4)   NOT NULL DEFAULT 0 after `long_desc` , 
	CHANGE `reverse_desc` `reverse_desc` tinytext  COLLATE utf8_general_ci NULL after `value_field_id` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `flagexclusions` 
	CHANGE `type_id` `type_id` mediumint(9)   NOT NULL first , 
	CHANGE `component_id` `component_id` mediumint(9)   NULL after `product_id` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `flaginclusions` 
	CHANGE `type_id` `type_id` mediumint(9)   NOT NULL first , 
	CHANGE `component_id` `component_id` mediumint(9)   NULL after `product_id` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `flags` 
	CHANGE `type_id` `type_id` mediumint(9)   NOT NULL after `id` , 
	CHANGE `status` `status` char(1)  COLLATE utf8_general_ci NOT NULL after `type_id` , 
	CHANGE `creation_date` `creation_date` datetime   NOT NULL after `attach_id` , 
	CHANGE `modification_date` `modification_date` datetime   NULL after `creation_date` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `flagtypes` 
	CHANGE `id` `id` mediumint(9)   NOT NULL auto_increment first , 
	CHANGE `name` `name` varchar(50)  COLLATE utf8_general_ci NOT NULL after `id` , 
	CHANGE `description` `description` mediumtext  COLLATE utf8_general_ci NOT NULL after `name` , 
	CHANGE `cc_list` `cc_list` varchar(200)  COLLATE utf8_general_ci NULL after `description` , 
	CHANGE `target_type` `target_type` char(1)  COLLATE utf8_general_ci NOT NULL DEFAULT 'b' after `cc_list` , 
	DROP COLUMN `default_requestee` , 
	DROP KEY `fk_flagtypes_default_requestee_profiles_userid` , 
	DROP FOREIGN KEY `fk_flagtypes_default_requestee_profiles_userid`  , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `group_control_map` DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `group_group_map` DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `groups` 
	CHANGE `name` `name` varchar(255)  COLLATE utf8_general_ci NOT NULL after `id` , 
	CHANGE `description` `description` mediumtext  COLLATE utf8_general_ci NOT NULL after `name` , 
	CHANGE `userregexp` `userregexp` tinytext  COLLATE utf8_general_ci NOT NULL after `isbuggroup` , 
	CHANGE `icon_url` `icon_url` tinytext  COLLATE utf8_general_ci NULL after `isactive` , 
	DROP COLUMN `secure_mail` , 
	DROP COLUMN `owner_user_id` , 
	DROP COLUMN `idle_member_removal` , 
	DROP KEY `fk_groups_owner_user_id_profiles_userid` , 
	DROP FOREIGN KEY `fk_groups_owner_user_id_profiles_userid`  , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `keyworddefs` 
	CHANGE `name` `name` varchar(64)  COLLATE utf8_general_ci NOT NULL after `id` , 
	CHANGE `description` `description` mediumtext  COLLATE utf8_general_ci NOT NULL after `name` , 
	DROP COLUMN `is_active` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `keywords` DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `login_failure` 
	CHANGE `login_time` `login_time` datetime   NOT NULL after `user_id` , 
	CHANGE `ip_addr` `ip_addr` varchar(40)  COLLATE utf8_general_ci NOT NULL after `login_time` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `logincookies` 
	CHANGE `cookie` `cookie` varchar(16)  COLLATE utf8_general_ci NOT NULL first , 
	CHANGE `ipaddr` `ipaddr` varchar(40)  COLLATE utf8_general_ci NULL after `userid` , 
	CHANGE `lastused` `lastused` datetime   NOT NULL after `ipaddr` , 
	DROP COLUMN `id` , 
	DROP COLUMN `restrict_ipaddr` , 
	DROP KEY `logincookies_cookie_idx` , 
	DROP KEY `PRIMARY`, ADD PRIMARY KEY(`cookie`) , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci' ;

/* Alter table in target */
ALTER TABLE `longdescs` 
	CHANGE `bug_when` `bug_when` datetime   NOT NULL after `who` , 
	CHANGE `thetext` `thetext` mediumtext  COLLATE utf8_general_ci NOT NULL after `work_time` , 
	CHANGE `extra_data` `extra_data` varchar(255)  COLLATE utf8_general_ci NULL after `type` , 
	DROP COLUMN `is_markdown` , 
	DROP COLUMN `edit_count` , 
	DROP KEY `longdescs_bug_id_idx`, ADD KEY `longdescs_bug_id_idx`(`bug_id`,`work_time`) , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `longdescs_tags` 
	CHANGE `tag` `tag` varchar(24)  COLLATE utf8_general_ci NOT NULL after `comment_id` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `longdescs_tags_activity` 
	CHANGE `bug_when` `bug_when` datetime   NOT NULL after `who` , 
	CHANGE `added` `added` varchar(24)  COLLATE utf8_general_ci NULL after `bug_when` , 
	CHANGE `removed` `removed` varchar(24)  COLLATE utf8_general_ci NULL after `added` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `longdescs_tags_weights` 
	CHANGE `tag` `tag` varchar(24)  COLLATE utf8_general_ci NOT NULL after `id` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Create table in target */
CREATE TABLE `mail_staging`(
	`id` int(11) NOT NULL  auto_increment , 
	`message` longblob NOT NULL  , 
	PRIMARY KEY (`id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8' COLLATE='utf8_general_ci' ROW_FORMAT=Dynamic;


/* Alter table in target */
ALTER TABLE `milestones` 
	CHANGE `value` `value` varchar(64)  COLLATE utf8_general_ci NOT NULL after `product_id` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `namedqueries` 
	CHANGE `name` `name` varchar(64)  COLLATE utf8_general_ci NOT NULL after `userid` , 
	CHANGE `query` `query` mediumtext  COLLATE utf8_general_ci NOT NULL after `name` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `namedqueries_link_in_footer` DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `namedquery_group_map` DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `op_sys` 
	CHANGE `value` `value` varchar(64)  COLLATE utf8_general_ci NOT NULL after `id` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `priority` 
	CHANGE `value` `value` varchar(64)  COLLATE utf8_general_ci NOT NULL after `id` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `products` 
	CHANGE `name` `name` varchar(64)  COLLATE utf8_general_ci NOT NULL after `id` , 
	CHANGE `description` `description` mediumtext  COLLATE utf8_general_ci NOT NULL after `classification_id` , 
	CHANGE `defaultmilestone` `defaultmilestone` varchar(64)  COLLATE utf8_general_ci NOT NULL DEFAULT '---' after `isactive` , 
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
	DROP FOREIGN KEY `fk_products_security_group_id_groups_id`  , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `profile_search` 
	CHANGE `bug_list` `bug_list` mediumtext  COLLATE utf8_general_ci NOT NULL after `user_id` , 
	CHANGE `list_order` `list_order` mediumtext  COLLATE utf8_general_ci NULL after `bug_list` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `profile_setting` 
	CHANGE `setting_name` `setting_name` varchar(32)  COLLATE utf8_general_ci NOT NULL after `user_id` , 
	CHANGE `setting_value` `setting_value` varchar(32)  COLLATE utf8_general_ci NOT NULL after `setting_name` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `profiles` 
	CHANGE `login_name` `login_name` varchar(255)  COLLATE utf8_general_ci NOT NULL after `userid` , 
	CHANGE `cryptpassword` `cryptpassword` varchar(128)  COLLATE utf8_general_ci NULL after `login_name` , 
	CHANGE `realname` `realname` varchar(255)  COLLATE utf8_general_ci NOT NULL DEFAULT '' after `cryptpassword` , 
	CHANGE `disabledtext` `disabledtext` mediumtext  COLLATE utf8_general_ci NOT NULL after `realname` , 
	CHANGE `extern_id` `extern_id` varchar(64)  COLLATE utf8_general_ci NULL after `mybugslink` , 
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
	DROP KEY `profiles_realname_ft_idx` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `profiles_activity` 
	CHANGE `profiles_when` `profiles_when` datetime   NOT NULL after `who` , 
	CHANGE `oldvalue` `oldvalue` tinytext  COLLATE utf8_general_ci NULL after `fieldid` , 
	CHANGE `newvalue` `newvalue` tinytext  COLLATE utf8_general_ci NULL after `oldvalue` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `quips` 
	CHANGE `quip` `quip` varchar(512)  COLLATE utf8_general_ci NOT NULL after `userid` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `rep_platform` 
	CHANGE `value` `value` varchar(64)  COLLATE utf8_general_ci NOT NULL after `id` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Create table in target */
CREATE TABLE `reports`(
	`id` mediumint(9) NOT NULL  auto_increment , 
	`user_id` mediumint(9) NOT NULL  , 
	`name` varchar(64) COLLATE utf8_general_ci NOT NULL  , 
	`query` mediumtext COLLATE utf8_general_ci NOT NULL  , 
	PRIMARY KEY (`id`) , 
	UNIQUE KEY `reports_user_id_idx`(`user_id`,`name`) , 
	CONSTRAINT `fk_reports_user_id_profiles_userid` 
	FOREIGN KEY (`user_id`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE 
) ENGINE=InnoDB DEFAULT CHARSET='utf8' COLLATE='utf8_general_ci' ROW_FORMAT=Dynamic;


/* Alter table in target */
ALTER TABLE `resolution` 
	CHANGE `value` `value` varchar(64)  COLLATE utf8_general_ci NOT NULL after `id` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `series` 
	CHANGE `name` `name` varchar(64)  COLLATE utf8_general_ci NOT NULL after `subcategory` , 
	CHANGE `query` `query` mediumtext  COLLATE utf8_general_ci NOT NULL after `frequency` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `series_categories` 
	CHANGE `name` `name` varchar(64)  COLLATE utf8_general_ci NOT NULL after `id` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `series_data` 
	CHANGE `series_date` `series_date` datetime   NOT NULL after `series_id` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `setting` 
	CHANGE `name` `name` varchar(32)  COLLATE utf8_general_ci NOT NULL first , 
	CHANGE `default_value` `default_value` varchar(32)  COLLATE utf8_general_ci NOT NULL after `name` , 
	CHANGE `subclass` `subclass` varchar(32)  COLLATE utf8_general_ci NULL after `is_enabled` , 
	DROP COLUMN `category` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `setting_value` 
	CHANGE `name` `name` varchar(32)  COLLATE utf8_general_ci NOT NULL first , 
	CHANGE `value` `value` varchar(32)  COLLATE utf8_general_ci NOT NULL after `name` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `status_workflow` DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `tag` 
	CHANGE `name` `name` varchar(64)  COLLATE utf8_general_ci NOT NULL after `id` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `tokens` 
	CHANGE `issuedate` `issuedate` datetime   NOT NULL after `userid` , 
	CHANGE `token` `token` varchar(16)  COLLATE utf8_general_ci NOT NULL after `issuedate` , 
	CHANGE `tokentype` `tokentype` varchar(16)  COLLATE utf8_general_ci NOT NULL after `token` , 
	CHANGE `eventdata` `eventdata` tinytext  COLLATE utf8_general_ci NULL after `tokentype` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci' ;

/* Alter table in target */
ALTER TABLE `ts_error` 
	CHANGE `message` `message` varchar(255)  COLLATE utf8_general_ci NOT NULL after `jobid` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci' ;

/* Alter table in target */
ALTER TABLE `ts_exitstatus` DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci' ;

/* Alter table in target */
ALTER TABLE `ts_funcmap` 
	CHANGE `funcname` `funcname` varchar(255)  COLLATE utf8_general_ci NOT NULL after `funcid` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci' ;

/* Alter table in target */
ALTER TABLE `ts_job` 
	CHANGE `uniqkey` `uniqkey` varchar(255)  COLLATE utf8_general_ci NULL after `arg` , 
	CHANGE `coalesce` `coalesce` varchar(255)  COLLATE utf8_general_ci NULL after `priority` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci' ;

/* Alter table in target */
ALTER TABLE `ts_note` 
	CHANGE `notekey` `notekey` varchar(255)  COLLATE utf8_general_ci NULL after `jobid` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci' ;

/* Alter table in target */
ALTER TABLE `user_api_keys` 
	CHANGE `api_key` `api_key` varchar(40)  COLLATE utf8_general_ci NOT NULL after `user_id` , 
	CHANGE `description` `description` varchar(255)  COLLATE utf8_general_ci NULL after `api_key` , 
	CHANGE `last_used` `last_used` datetime   NULL after `revoked` , 
	DROP COLUMN `last_used_ip` , 
	DROP COLUMN `app_id` , 
	DROP COLUMN `sticky` , 
	DROP KEY `user_api_keys_user_id_app_id_idx` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `user_group_map` DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `versions` 
	CHANGE `value` `value` varchar(64)  COLLATE utf8_general_ci NOT NULL after `id` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `watch` DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `whine_events` 
	CHANGE `subject` `subject` varchar(128)  COLLATE utf8_general_ci NULL after `owner_userid` , 
	CHANGE `body` `body` mediumtext  COLLATE utf8_general_ci NULL after `subject` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `whine_queries` 
	CHANGE `query_name` `query_name` varchar(64)  COLLATE utf8_general_ci NOT NULL DEFAULT '' after `eventid` , 
	CHANGE `title` `title` varchar(128)  COLLATE utf8_general_ci NOT NULL DEFAULT '' after `onemailperbug` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ;

/* Alter table in target */
ALTER TABLE `whine_schedules` 
	CHANGE `run_day` `run_day` varchar(32)  COLLATE utf8_general_ci NULL after `eventid` , 
	CHANGE `run_time` `run_time` varchar(32)  COLLATE utf8_general_ci NULL after `run_day` , 
	CHANGE `run_next` `run_next` datetime   NULL after `run_time` , DEFAULT CHARSET='utf8', COLLATE ='utf8_general_ci', ROW_FORMAT = Dynamic ; 

/* The foreign keys that were dropped are now re-created*/

ALTER TABLE `attachments` 
	ADD CONSTRAINT `fk_attachments_bug_id_bugs_bug_id` 
	FOREIGN KEY (`bug_id`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE , 
	ADD CONSTRAINT `fk_attachments_submitter_id_profiles_userid` 
	FOREIGN KEY (`submitter_id`) REFERENCES `profiles` (`userid`) ON UPDATE CASCADE ;

ALTER TABLE `audit_log` 
	ADD CONSTRAINT `fk_audit_log_user_id_profiles_userid` 
	FOREIGN KEY (`user_id`) REFERENCES `profiles` (`userid`) ON DELETE SET NULL ON UPDATE CASCADE ;

ALTER TABLE `bug_see_also` 
	ADD CONSTRAINT `fk_bug_see_also_bug_id_bugs_bug_id` 
	FOREIGN KEY (`bug_id`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE ;

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

ALTER TABLE `bugs_fulltext` 
	ADD CONSTRAINT `fk_bugs_fulltext_bug_id_bugs_bug_id` 
	FOREIGN KEY (`bug_id`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE ON UPDATE CASCADE ;

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

ALTER TABLE `tag` 
	ADD CONSTRAINT `fk_tag_user_id_profiles_userid` 
	FOREIGN KEY (`user_id`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE ;

ALTER TABLE `tokens` 
	ADD CONSTRAINT `fk_tokens_userid_profiles_userid` 
	FOREIGN KEY (`userid`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE ;

ALTER TABLE `user_api_keys` 
	ADD CONSTRAINT `fk_user_api_keys_user_id_profiles_userid` 
	FOREIGN KEY (`user_id`) REFERENCES `profiles` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE ;

ALTER TABLE `versions` 
	ADD CONSTRAINT `fk_versions_product_id_products_id` 
	FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE ;

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