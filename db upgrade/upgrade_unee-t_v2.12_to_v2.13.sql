# We cleanup unnecessary temporary table `ut_user_group_map_temp`
DROP TABLE IF EXISTS `ut_user_group_map_temp`;

# Add a table to log all the changes initiated by scripts in the BZFE
CREATE TABLE `ut_audit_log`(
	`id_ut_log` INT(11) NOT NULL  AUTO_INCREMENT COMMENT 'The id of the record in this table' , 
	`datetime` DATETIME NULL  COMMENT 'When was this record created' , 
	`bzfe_table` VARCHAR(256) COLLATE utf8_general_ci NULL  COMMENT 'The name of the table that was altered' , 
	`bzfe_field` VARCHAR(256) COLLATE utf8_general_ci NULL  COMMENT 'The name of the field that was altered in the bzfe table' , 
	`previous_value` MEDIUMTEXT COLLATE utf8_general_ci NULL  COMMENT 'The value of the field before the change' , 
	`new_value` MEDIUMTEXT COLLATE utf8_general_ci NULL  COMMENT 'The value of the field after the change' , 
	`script` MEDIUMTEXT COLLATE utf8_general_ci NULL  COMMENT 'The script that was used to create the record' , 
	`comment` TEXT COLLATE utf8_general_ci NULL  COMMENT 'More information about what we intended to do' , 
	PRIMARY KEY (`id_ut_log`) 
	) ENGINE=INNODB
	;



# We need to add more permissions in the `ut_map_user_unit_details`:
# We also create a unique key so that we only have ONE record for each bz_user_id and product_id
ALTER TABLE `ut_map_user_unit_details` 
	CHANGE `created` `created` DATETIME   NULL COMMENT 'creation ts' FIRST , 
	ADD COLUMN `can_see_time_tracking` TINYINT(1)   NOT NULL DEFAULT 1 COMMENT '1 (TRUE) if the user can see the timetracking information for a case' AFTER `role_type_id` , 
	ADD COLUMN `can_create_shared_queries` TINYINT(1)   NOT NULL DEFAULT 1 COMMENT '1 (TRUE) if the user can create shared queries' AFTER `can_see_time_tracking` , 
	ADD COLUMN `can_tag_comment` TINYINT(1)   NOT NULL DEFAULT 1 COMMENT '1 (TRUE) if the user can tag comments' AFTER `can_create_shared_queries` , 
	CHANGE `is_occupant` `is_occupant` TINYINT(1)   NOT NULL DEFAULT 0 COMMENT '1 (TRUE) if the user is an occupnt for this unit' AFTER `can_tag_comment` , 
	ADD COLUMN `is_in_cc_for_role` TINYINT(1)   NOT NULL DEFAULT 0 COMMENT '1 (TRUE if the user should be included in CC each time a new case is created for his/her role for this unit' AFTER `is_see_visible_assignee` , 
	ADD COLUMN `can_create_case` TINYINT(1)   NOT NULL DEFAULT 1 COMMENT '1 (TRUE if the user can create new cases for this unit' AFTER `is_in_cc_for_role` , 
	ADD COLUMN `can_edit_case` TINYINT(1)   NOT NULL DEFAULT 1 COMMENT '1 (TRUE) if the user can edit a case for this unit' AFTER `can_create_case` , 
	ADD COLUMN `can_see_case` TINYINT(1)   NOT NULL DEFAULT 1 COMMENT '1 (TRUE) if the user can the all the public cases for this unit' AFTER `can_edit_case` , 
	ADD COLUMN `can_edit_all_field_regardless_of_role` TINYINT(1)   NOT NULL DEFAULT 0 COMMENT '1 (TRUE) if the user can edit all the fields in a case he/she has access to regardless of his or her role' AFTER `can_see_case` , 
	CHANGE `is_flag_requestee` `is_flag_requestee` TINYINT(1)   NOT NULL DEFAULT 1 COMMENT '1 (TRUE) if the user can be asked to approve all flags' AFTER `can_edit_all_field_regardless_of_role` , 
	DROP COLUMN `id_user_unit` , 
	ADD UNIQUE KEY `bz_profile_id_bz_product_id`(`bz_profile_id`,`bz_unit_id`) , 
	DROP KEY `PRIMARY` ;