# This script creates a temporary table to aggregate case activities from the past

# We create a new table 'ut_temp_legacy_case_activity' which consolidates information to mesure activity.

	DROP TABLE IF EXISTS `ut_temp_legacy_case_activity`;

	CREATE TABLE `ut_temp_legacy_case_activity` (
	  `case_activity_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Id in this table',
	  `created_datetime` DATETIME DEFAULT NULL COMMENT 'Timestamp when this was created',
	  `processed_datetime` DATETIME DEFAULT NULL COMMENT 'Timestamp when this notification was processed',
	  `unit_id` SMALLINT(6) DEFAULT NULL COMMENT 'Unit ID - a FK to the BZ table ''products''',
	  `case_id` MEDIUMINT(9) DEFAULT NULL COMMENT 'Case ID - a FK to the BZ table ''bugs''',
	  `user_id` MEDIUMINT(9) DEFAULT NULL COMMENT 'User ID - The user who needs to be notified - a FK to the BZ table ''profiles''',
	  `update_what` VARCHAR(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'The field that was updated',
	  PRIMARY KEY (`case_activity_id`)
	) ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


# The new comments 
# the source table is `longdescs`
# a new row is created in this table
#	- each time a new comment is added
#	- each time a new bug/case is created

	INSERT INTO `ut_temp_legacy_case_activity`
		(`created_datetime`
		, `unit_id`
		, `case_id`
		, `user_id`
		, `update_what`
		)
		SELECT 
			`longdescs`.`bug_when`
			, `bugs`.`product_id`
			, `longdescs`.`bug_id`
			, `longdescs`.`who`
			, 'new comment on a case'
			FROM `longdescs`
		INNER JOIN `bugs` 
			ON (`longdescs`.`bug_id` = `bugs`.`bug_id`)
		ORDER BY `longdescs`.`bug_when` ASC
		;
		
		
# after initial creation: the case/bug is updated
# the source for this information is the table `bugs_activity`

	INSERT INTO `ut_temp_legacy_case_activity`
		(`created_datetime`
		, `unit_id`
		, `case_id`
		, `user_id`
		, `update_what`
		)
	SELECT
		`bugs_activity`.`bug_when`
		, `bugs`.`product_id`
		, `bugs_activity`.`bug_id`
		, `bugs_activity`.`who`
		, (SELECT `description` FROM `fielddefs` WHERE `id` = `bugs_activity`.`fieldid`)
	FROM
		`bugs_activity`
	INNER JOIN `bugs` 
			ON (`bugs_activity`.`bug_id` = `bugs`.`bug_id`)
		ORDER BY `bugs_activity`.`bug_when` ASC
	;