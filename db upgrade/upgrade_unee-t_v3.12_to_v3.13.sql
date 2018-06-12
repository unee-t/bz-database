# For any question about this script, ask Franck
#
###################################################################################
#
# WARNING! 
#	- It is MANDATORY to use Amazon Aurora database engine for this version
#	- Please make sure to use the correct Lambda function for each environment
#	  https://github.com/unee-t/lambda2sns/blob/master/tests/call-lambda-as-root.sh#L5
#		- DEV/Staging: 812644853088
#		- Prod: 192458993663
#		- Demo: 915001051872
#	  This MUST be done on the following lines for this script:
#		- line: 194
#		- line: 240
#		- line: 283
#		- line: 324
#		- line: 366
#
# Make sure to also update the below variable(s)
#
############################################
#
# What are the version of the Unee-T BZ Database schema BEFORE and AFTER this update?
	SET @old_schema_version = 'v3.12';
	SET @new_schema_version = 'v3.13';
#
# What is the name of this script?
	SET @this_script = 'upgrade_unee-t_v3.11_to_v3.12.sql';
#
###############################
#
# We have everything we need
#
###############################
# This update 
#OK	- Update the table `ut_notification_types` to add notification types for 
#		- new cases 
#		- new message in a case
#OK	- Alter the a table `ut_notification_messages_cases` add the title of the case
#OK	- Alter the a table `ut_notification_case_assignee` add the title of the case
#OK	- Alter the a table `ut_notification_case_invited` add the title of the case
#OK	- Rename the table `ut_notification_messages_cases` to `ut_notification_case_updated`.
#	  this INCLUDES the information when:
#		- A new message is added
#		- The assignee is changed
#		- A user is invited to the case
#OK	- Creates a table `ut_notification_case_new` to record the notification events A new case is created
#OK	- Creates a table `ut_notification_message_new` to record the notification event: a new message is added to a case
#	- Alters the Procedures 
#OK		- DROP the procedure`lambda_notification_case_event` 
#OK				- Recreate the procedure `lambda_notification_case_event` as `lambda_notification_case_updated`
#OK				- Make sure that we Add the case title to the payload
#OK		- `lambda_notification_case_invited` to make sure that we 
#			- Add the case title to the payload
#			- Create a unique notification_id
#OK		- DROP the procedure `lambda_notification_case_assignee` 
#OK				- Recreate the procedure as `lambda_notification_case_assignee_updated`
#OK				- Make sure that we Add the case title to the payload
#OK 	- Create a Lambda Procedure `lambda_notification_case_new` to send notification each time a new case is created.
#OK 	- Create a Lambda Procedure `lambda_notification_message_new` to send notification each time a new message is added to a case.
#	- Alters the triggers :
#OK		- `ut_prepare_message_new_case`
#				- do the update into the new table `ut_notification_case_new`
#				- Use a unique notification_id fo the JSON payload
#				- Make sure we use the correct lambda call `lambda_notification_case_new`
#				- Add the case title to the JSON payload
#OK		- `ut_prepare_message_case_activity` 
#				- do the update into the new table `ut_notification_case_updated`
#				- Use a unique notification_id fo the JSON payload
#				- Make sure we use the correct lambda call `lambda_notification_case_updated`
#				- Add the case title to the JSON payload
#PARTIAL- `ut_prepare_message_new_comment`
#				- do the update into the new table `ut_notification_case_updated`
#				- Use a unique notification_id fo the JSON payload
#				- Make sure we use the correct lambda call `lambda_notification_message_new`
#				- Add the case title to the JSON payload
#OK	- We DO NOT need the trigger `ut_prepare_message_case_assigned_new`: 
#	  this is covered with the trigger `ut_prepare_message_new_case`
#OK		- `ut_prepare_message_case_assigned_updated` 
#				- Use a unique notification_id fo the JSON payload
#				- Make sure we use the correct lambda `lambda_notification_case_assignee_updated`
#				- Add the case title to the INSERT statement
#				- Add the case title to the JSON payload
#OK		- `ut_prepare_message_case_invited` 
#				- Use a unique notification_id fo the JSON payload
#				- Add the case title to the INSERT statement
#				- Add the case title to the JSON payload
#
#

# When are we doing this?
	SET @the_timestamp = NOW();

# Create a table `ut_notification_types` to list and define all the notification types.

	DROP TABLE IF EXISTS `ut_notification_types`;

	CREATE TABLE `ut_notification_types` (
	  `id_role_type` SMALLINT(6) NOT NULL AUTO_INCREMENT COMMENT 'ID in this table',
	  `created` DATETIME DEFAULT NULL COMMENT 'creation ts',
	  `notification_type` VARCHAR(255) NOT NULL COMMENT 'A name for this role type',
	  `short_description` VARCHAR(255) DEFAULT NULL COMMENT 'A short, generic description that we include each time we create a new BZ unit.',
	  `long_description` TEXT COMMENT 'Detailed description of this group type',
	  PRIMARY KEY (`id_role_type`),
	  UNIQUE KEY `unique_notification_type` (`notification_type`)
	) ENGINE=INNODB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

	/*Data for the table `ut_notification_types` */

	INSERT  INTO `ut_notification_types`(`id_role_type`,`created`,`notification_type`,`short_description`,`long_description`) VALUES 
	(1,@the_timestamp,'case_new','A new case has been created','A case has been created.\r\nWe record the following information:\r\n- When was the case created?\r\n- The unit id\r\n- The case id\r\n- Who created the case\r\n- Which field was updated\r\n- What is the title of the case\r\n- Who is the assignee for that case')
	, (2,@the_timestamp,'case_updated','A case has been updated','A case has been updated.\r\nWe record the following information:\r\n- When was the case updated?\r\n- The unit id\r\n- The case id\r\n- Who did the update\r\n- Which field was updated\r\n- What is the title of the case')
	, (3,@the_timestamp,'case_assignee_updated','The user assigned to that case has changed','A new user has been assigned to a case.\r\nWe record the following information:\r\n- When did this happen?\r\n- Who made this change?\r\n- What is the unit id?\r\n- What is the case id?\r\n- Who is the new user assigned to that case?\r\n- What is the title of the case')
	, (4,@the_timestamp,'case_user_invited','A user is invited to a case','A new user has been invited to a case.\r\nThe information we store:\r\n- When has this been done\r\n- What is the unit number\r\n- What is the case number\r\n- Who is the newly invited user\r\n\r\nWe do NOT record who has invited the user as this information is not easily accessible from the trigger we use (insert into the table `cc`)\r\n- What is the title of the case')
	, (5,@the_timestamp,'case_new_message','A new message is added to a case','A new message has been added to a case.\r\nThe information we store:\r\n- When has this been done\r\n- What is the unit number\r\n- What is the case number\r\n- The first 255 characters of the newly added message\r\n\r\nwho has created the message\r\n- What is the title of the case')
	;

# Alter the a table `ut_notification_messages_cases` add the title of the case
	ALTER TABLE `ut_notification_case_assignee` 
		ADD COLUMN `case_title` varchar(255)  COLLATE utf8_unicode_ci NULL COMMENT 'The title for the case - the is the field `short_desc` in the `bugs` table' after `case_id` , 
		CHANGE `invitor_user_id` `invitor_user_id` mediumint(9)   NULL COMMENT 'User ID - The user who inititated the change - a FK to the BZ table \'profiles\'' after `case_title` 
		;

# Alter the a table `ut_notification_case_assignee` add the title of the case
	ALTER TABLE `ut_notification_case_invited` 
		ADD COLUMN `case_title` varchar(255)  COLLATE utf8_unicode_ci NULL COMMENT 'The title for the case - the is the field `short_desc` in the `bugs` table' after `case_id` , 
		CHANGE `invitor_user_id` `invitor_user_id` mediumint(9)   NULL COMMENT 'User ID - The user who inititated the change - a FK to the BZ table \'profiles\'' after `case_title` 
		;

# Alter the a table `ut_notification_case_invited` add the title of the case
	ALTER TABLE `ut_notification_messages_cases` 
		ADD COLUMN `case_title` varchar(255)  COLLATE utf8_unicode_ci NULL COMMENT 'The title for the case - the is the field `short_desc` in the `bugs` table' after `case_id` , 
		CHANGE `user_id` `user_id` mediumint(9)   NULL COMMENT 'User ID - The user who inititated the change - a FK to the BZ table \'profiles\'' after `case_title` 
		;
	
# Rename the table `ut_notification_messages_cases` to `ut_notification_case_updated` to record the notification events when a new case is updated.
#	  this INCLUDES the information when:
#		- A new message is added
#		- The assignee is changed	
	RENAME TABLE `ut_notification_messages_cases` TO `ut_notification_case_updated`;
	
# Creates a table `ut_notification_case_new` to record the notification events A new case is created
	DROP TABLE IF EXISTS `ut_notification_case_new`;

	CREATE TABLE `ut_notification_case_new` (
	  `notification_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Id in this table',
	  `created_datetime` DATETIME DEFAULT NULL COMMENT 'Timestamp when this was created',
	  `processed_datetime` DATETIME DEFAULT NULL COMMENT 'Timestamp when this notification was processed',
	  `unit_id` SMALLINT(6) DEFAULT NULL COMMENT 'Unit ID - a FK to the BZ table ''products''',
	  `case_id` MEDIUMINT(9) DEFAULT NULL COMMENT 'Case ID - a FK to the BZ table ''bugs''',
	  `case_title` VARCHAR(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'The title for the case - the is the field `short_desc` in the `bugs` table',
	  `user_id` MEDIUMINT(9) DEFAULT NULL COMMENT 'User ID - The user who inititated the change - a FK to the BZ table ''profiles''',
	  `assignee_id` MEDIUMINT(9) DEFAULT NULL COMMENT 'User ID - The user who is assigned to this case - a FK to the BZ table ''profiles''',
	  PRIMARY KEY (`notification_id`)
	) ENGINE=INNODB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

# Creates a table `ut_notification_message_new` to record the notification event: a new message is added to a case
	DROP TABLE IF EXISTS `ut_notification_message_new`;

	CREATE TABLE `ut_notification_message_new` (
	  `notification_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Id in this table',
	  `created_datetime` DATETIME DEFAULT NULL COMMENT 'Timestamp when this was created',
	  `processed_datetime` DATETIME DEFAULT NULL COMMENT 'Timestamp when this notification was processed',
	  `unit_id` SMALLINT(6) DEFAULT NULL COMMENT 'Unit ID - a FK to the BZ table ''products''',
	  `case_id` MEDIUMINT(9) DEFAULT NULL COMMENT 'Case ID - a FK to the BZ table ''bugs''',
	  `case_title` VARCHAR(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'The title for the case - the is the field `short_desc` in the `bugs` table',
	  `user_id` MEDIUMINT(9) DEFAULT NULL COMMENT 'User ID - The user who inititated the change - a FK to the BZ table ''profiles''',
	  `message_truncated` VARCHAR(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'The message, truncated to the first 255 characters',
	  PRIMARY KEY (`notification_id`)
	) ENGINE=INNODB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

# DROP the procedure`lambda_notification_case_event` 
#		- Recreate the procedure `lambda_notification_case_event` as `lambda_notification_case_updated`
#		- Make sure that we Add the case title to the payload
#		- Create a unique notification_id
# IMPORTANT!! make sure that the variable for the Lambda is correct for each environement

DROP PROCEDURE IF EXISTS `lambda_notification_case_event`;
DROP PROCEDURE IF EXISTS `lambda_notification_case_updated`;
	
DELIMITER $$
CREATE PROCEDURE `lambda_notification_case_updated`(
	IN notification_type varchar(255)
	, IN bz_source_table varchar(240)
	, IN notification_id varchar(255)
	, IN created_datetime datetime
	, IN unit_id smallint(6)
	, IN case_id mediumint(9)
	, IN case_title varchar(255)
	, IN user_id mediumint(9)
	, IN update_what varchar(255)
	)
	LANGUAGE SQL
SQL SECURITY INVOKER
BEGIN
	# https://github.com/unee-t/lambda2sns/blob/master/tests/call-lambda-as-root.sh#L5
	#	- DEV/Staging: 812644853088
	#	- Prod: 192458993663
	#	- Demo: 915001051872
	CALL mysql.lambda_async(CONCAT('arn:aws:lambda:ap-southeast-1:192458993663:function:alambda_simple')
		, CONCAT ('{ '
			, '"notification_type": "', notification_type
			, '", "bz_source_table": "', bz_source_table
			, '", "notification_id": "', notification_id
			, '", "created_datetime" : "', created_datetime
			, '", "unit_id" : "', unit_id
			, '", "case_id" : "', case_id
			, '", "case_title" : "', case_title
			, '", "user_id" : "', user_id
			, '", "update_what" : "', update_what
			, '"}'
			)
		)
		;
END $$
DELIMITER ;

# DROP the Procedure `lambda_notification_case_assignee` to send notification each time the assignee is changed.
# Recreate that procedure as `lambda_notification_case_assignee_updated`
#	- Add case title
#	- Create a unique notification_id
# IMPORTANT!! make sure that the variable for the Lambda is correct for each environement

DROP PROCEDURE IF EXISTS `lambda_notification_case_assignee`;
DROP PROCEDURE IF EXISTS `lambda_notification_case_assignee_updated`;
	
DELIMITER $$
CREATE PROCEDURE `lambda_notification_case_assignee_updated`(
	IN notification_type varchar(255)
	, IN bz_source_table varchar(240)
	, IN notification_id varchar(255)
	, IN created_datetime datetime
	, IN unit_id smallint(6)
	, IN case_id mediumint(9)
	, IN case_title varchar(255)
	, IN invitor_user_id mediumint(9)
	, IN assignee_user_id mediumint(9)
	)
	LANGUAGE SQL
SQL SECURITY INVOKER
BEGIN
	# https://github.com/unee-t/lambda2sns/blob/master/tests/call-lambda-as-root.sh#L5
	#	- DEV/Staging: 812644853088
	#	- Prod: 192458993663
	#	- Demo: 915001051872
	CALL mysql.lambda_async(CONCAT('arn:aws:lambda:ap-southeast-1:192458993663:function:alambda_simple')
		, CONCAT ('{ '
			, '"notification_type": "', notification_type
			, '", "bz_source_table": "', bz_source_table
			, '", "notification_id": "', notification_id
			, '", "created_datetime" : "', created_datetime
			, '", "unit_id" : "', unit_id
			, '", "case_id" : "', case_id
			, '", "case_title" : "', case_title
			, '", "invitor_user_id" : "', invitor_user_id
			, '", "assignee_user_id" : "', assignee_user_id
			, '"}'
			)
		)
		;
END $$
DELIMITER ;

# Alters the Procedure `lambda_notification_case_invited` to send notification each time a user is added in CC to a case.
#	- Add case title
#	- Create a unique notification_id
# IMPORTANT!! make sure that the variable for the Lambda is correct for each environement

DROP PROCEDURE IF EXISTS `lambda_notification_case_invited`;
	
DELIMITER $$
CREATE PROCEDURE `lambda_notification_case_invited`(
	IN notification_type varchar(255)
	, IN bz_source_table varchar(240)
	, IN notification_id varchar(255)
	, IN created_datetime datetime
	, IN unit_id smallint(6)
	, IN case_id mediumint(9)
	, IN case_title varchar(255)
	, IN invitee_user_id mediumint(9)
	)
	LANGUAGE SQL
SQL SECURITY INVOKER
BEGIN
	# https://github.com/unee-t/lambda2sns/blob/master/tests/call-lambda-as-root.sh#L5
	#	- DEV/Staging: 812644853088
	#	- Prod: 192458993663
	#	- Demo: 915001051872
	CALL mysql.lambda_async(CONCAT('arn:aws:lambda:ap-southeast-1:192458993663:function:alambda_simple')
		, CONCAT ('{ '
			, '"notification_type": "', notification_type
			, '", "bz_source_table": "', bz_source_table
			, '", "notification_id": "', notification_id
			, '", "created_datetime" : "', created_datetime
			, '", "unit_id" : "', unit_id
			, '", "case_id" : "', case_id
			, '", "case_title" : "', case_title
			, '", "invitee_user_id" : "', invitee_user_id
			, '"}'
			)
		)
		;
END $$
DELIMITER ;

# Create a Lambda Procedure `lambda_notification_case_new` to send notification each time a new case is created.
# IMPORTANT!! make sure that the variable for the Lambda is correct for each environement

DROP PROCEDURE IF EXISTS `lambda_notification_case_new`;
	
DELIMITER $$
CREATE PROCEDURE `lambda_notification_case_new`(
	IN notification_type varchar(255)
	, IN bz_source_table varchar(240)
	, IN notification_id varchar(255)
	, IN created_datetime datetime
	, IN unit_id smallint(6)
	, IN case_id mediumint(9)
	, IN case_title varchar(255)
	, IN reporter_user_id mediumint(9)
	, IN assignee_user_id mediumint(9)
	)
	LANGUAGE SQL
SQL SECURITY INVOKER
BEGIN
	# https://github.com/unee-t/lambda2sns/blob/master/tests/call-lambda-as-root.sh#L5
	#	- DEV/Staging: 812644853088
	#	- Prod: 192458993663
	#	- Demo: 915001051872
	CALL mysql.lambda_async(CONCAT('arn:aws:lambda:ap-southeast-1:192458993663:function:alambda_simple')
		, CONCAT ('{ '
			, '"notification_type": "', notification_type
			, '", "bz_source_table": "', bz_source_table
			, '", "notification_id": "', notification_id
			, '", "created_datetime" : "', created_datetime
			, '", "unit_id" : "', unit_id
			, '", "case_id" : "', case_id
			, '", "case_title" : "', case_title
			, '", "reporter_user_id" : "', reporter_user_id
			, '", "assignee_user_id" : "', assignee_user_id
			, '"}'
			)
		)
		;
END $$
DELIMITER ;

# Create a Lambda Procedure `lambda_notification_message_new` to send notification each time a new message is added to a case.
# IMPORTANT!! make sure that the variable for the Lambda is correct for each environement

DROP PROCEDURE IF EXISTS `lambda_notification_message_new`;
	
DELIMITER $$
CREATE PROCEDURE `lambda_notification_message_new`(
	IN notification_type varchar(255)
	, IN bz_source_table varchar(240)
	, IN notification_id varchar(255)
	, IN created_datetime datetime
	, IN unit_id smallint(6)
	, IN case_id mediumint(9)
	, IN case_title varchar(255)
	, IN created_by_user_id mediumint(9)
	, IN message_truncated varchar(255)
	)
	LANGUAGE SQL
SQL SECURITY INVOKER
BEGIN
	# https://github.com/unee-t/lambda2sns/blob/master/tests/call-lambda-as-root.sh#L5
	#	- DEV/Staging: 812644853088
	#	- Prod: 192458993663
	#	- Demo: 915001051872
	CALL mysql.lambda_async(CONCAT('arn:aws:lambda:ap-southeast-1:192458993663:function:alambda_simple')
		, CONCAT ('{ '
			, '"notification_type": "', notification_type
			, '", "bz_source_table": "', bz_source_table
			, '", "notification_id": "', notification_id
			, '", "created_datetime" : "', created_datetime
			, '", "unit_id" : "', unit_id
			, '", "case_id" : "', case_id
			, '", "case_title" : "', case_title
			, '", "created_by_user_id" : "', created_by_user_id
			, '", "message_truncated" : "', message_truncated
			, '"}'
			)
		)
		;
END $$
DELIMITER ;

# Update the trigger `ut_prepare_message_new_case` when a case is created
# 	- do the update into the new table `ut_notification_case_new`
#	- Use a unique notification_id fo the JSON payload
#	- Make sure we use the correct lambda call
#	- Add the case title to the JSON payload

DROP TRIGGER IF EXISTS `ut_prepare_message_new_case`;

DELIMITER $$
CREATE TRIGGER `ut_prepare_message_new_case`
AFTER INSERT ON `bugs`
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
		SET @assignee_id = NULL;

	# We have a clean slate, define the variables now
		SET @notification_type = 'case_new';
		SET @bz_source_table = 'ut_notification_case_new';
		SET @notification_id = ((SELECT MAX(`notification_id`) FROM `ut_notification_case_new`) + 1);
		SET @unique_notification_id = (CONCAT(@bz_source_table, '-', @notification_id));
		SET @created_datetime = NOW();
		SET @unit_id = NEW.`product_id`;
		SET @case_id = NEW.`bug_id`;
		SET @case_title = NEW.`short_desc`;
		SET @user_id = NEW.`reporter`;
		SET @assignee_id = NEW.`assigned_to`;
	
	# We insert the event in the notification table
		INSERT INTO `ut_notification_case_new`
			(notification_id
			, `created_datetime`
			, `unit_id`
			, `case_id`
			, `case_title`
			, `user_id`
			, `assignee_id`
			)
			VALUES
			(@notification_id
			, NOW()
			, @unit_id
			, @case_id
			, @case_title
			, @user_id
			, @assignee_id
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
			, @user_id
			, @assignee_id
			)
			;
END;
$$
DELIMITER ;

# We update the trigger `ut_prepare_message_case_activity` when a case is updated
#	- do the update into the new table `ut_notification_case_updated`
#	- Use a unique notification_id fo the JSON payload
#	- Make sure we use the correct lambda call `lambda_notification_case_updated`
#	- Add the case title to the JSON payload

DROP TRIGGER IF EXISTS `ut_prepare_message_case_activity`;

DELIMITER $$
CREATE TRIGGER `ut_prepare_message_case_activity`
AFTER INSERT ON `bugs_activity`
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
	
	# We insert the event in the relevant notification table
		INSERT INTO `ut_notification_case_updated`
			(notification_id
			, `created_datetime`
			, `unit_id`
			, `case_id`
			, `case_title`
			, `user_id`
			, `update_what`
			)
			VALUES
			(@notification_id
			, NOW()
			, @unit_id
			, @case_id
			, @case_title
			, @user_id
			, @update_what
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
			)
			;
END;
$$
DELIMITER ;

# We update the trigger `ut_prepare_message_new_comment` when a new message is added
#	- do the update into the new table `ut_notification_message_new`
#	- Use a unique notification_id fo the JSON payload
#	- Make sure we use the correct lambda call `lambda_notification_message_new`
#	- Add the case title to the JSON payload


DROP TRIGGER IF EXISTS `ut_prepare_message_new_comment`;

DELIMITER $$
CREATE TRIGGER `ut_prepare_message_new_comment`
AFTER INSERT ON `longdescs`
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
		SET @message_truncated = NULL;

	# We have a clean slate, define the variables now
		SET @notification_type = 'case_new_message';
		SET @bz_source_table = 'ut_notification_message_new';
		SET @notification_id = ((SELECT MAX(`notification_id`) FROM `ut_notification_message_new`) + 1);
		SET @unique_notification_id = (CONCAT(@bz_source_table, '-', @notification_id));
		SET @created_datetime = NOW();
		SET @unit_id = (SELECT `product_id` FROM `bugs` WHERE `bug_id` = NEW.`bug_id`);
		SET @case_id = NEW.`bug_id`;
		SET @case_title = (SELECT `short_desc` FROM `bugs` WHERE `bug_id` = @case_id);
		SET @user_id = NEW.`who`;
		SET @message_truncated = NEW.`thetext`;
		
	# We insert the event in the relevant notification table
		INSERT INTO `ut_notification_message_new`
			(notification_id
			, `created_datetime`
			, `unit_id`
			, `case_id`
			, `case_title`
			, `user_id`
			, `message_truncated`
			)
			VALUES
			(@notification_id
			, @created_datetime
			, @unit_id
			, @case_id
			, @case_title
			, @user_id
			, @message_truncated
			)
			;

########
#
# WARNING! WE HAVE AN ISSUE THERE IF WE TRIGGER THIS TOGETHER WITH CASE CREATION IT FAILS!...
#
#########
		
	# We call the Lambda procedure to notify of the change
#		CALL `lambda_notification_message_new`(@notification_type
#			, @bz_source_table
#			, @unique_notification_id
#			, @created_datetime
#			, @unit_id
#			, @case_id
#			, @case_title
#			, @user_id
#			, @message_truncated
#			)
#			;
END;
$$
DELIMITER ;

# We DO NOT need the trigger `ut_prepare_message_case_assigned_new` 
# This is covered with the trigger `ut_prepare_message_new_case`

DROP TRIGGER IF EXISTS `ut_prepare_message_case_assigned_new`;


# We Update the trigger when the assignee is updated
#	- Use a unique notification_id fo the JSON payload
#	- Make sure we use the correct lambda `lambda_notification_case_assignee_updated`
#	- Add the case title to the INSERT statement
#	- Add the case title to the JSON payload

DROP TRIGGER IF EXISTS `ut_prepare_message_case_assigned_updated`;

DELIMITER $$
CREATE TRIGGER `ut_prepare_message_case_assigned_updated`
AFTER UPDATE ON `bugs`
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
			SET @assignee_user_id = NULL;

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
			SET @assignee_user_id = NEW.`assigned_to`;
		
		# We insert the event in the relevant notification table
			INSERT INTO `ut_notification_case_assignee`
				(`notification_id`
				, `created_datetime`
				, `unit_id`
				, `case_id`
				, `case_title`
				, `invitor_user_id`
				, `assignee_user_id`
				)
				VALUES
				(@notification_id
				, @created_datetime
				, @unit_id
				, @case_id
				, @case_title
				, @invitor_user_id
				, @assignee_user_id
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
				, @assignee_user_id
				)
				;
	END IF;
END;
$$
DELIMITER ;

# We update the trigger when a user is invited to a case
#	- Use a unique notification_id fo the JSON payload
#	- Add the case title to the INSERT statement
#	- Add the case title to the JSON payload

DROP TRIGGER IF EXISTS `ut_prepare_message_case_invited`;

# We then create the trigger when a case is created
DELIMITER $$
CREATE TRIGGER `ut_prepare_message_case_invited`
AFTER INSERT ON `cc`
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

	# We insert the event in the relevant notification table		
		INSERT INTO `ut_notification_case_invited`
			(`notification_id`
			, `created_datetime`
			, `unit_id`
			, `case_id`
			, `case_title`
			, `invitee_user_id`
			)
			VALUES
			(@notification_id
			, @created_datetime
			, @unit_id
			, @case_id
			, @case_title
			, @invitee_user_id
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
			)
			;
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