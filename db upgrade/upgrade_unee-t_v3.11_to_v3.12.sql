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
#		- line: 151
#		- line: 191
#		- line: 230
#
# Make sure to also update the below variable(s)
#
############################################
#
# What are the version of the Unee-T BZ Database schema BEFORE and AFTER this update?
	SET @old_schema_version = 'v3.11';
	SET @new_schema_version = 'v3.12';
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
#OK	- Creates a table `ut_notification_types` to list and define all the notification types.
#OK	- Creates a table `ut_notification_case_assignee` to record the notification events: 
#		- bug created, assignee needs to be notified
#		- Bug updated, assignee changed, new assignee needs to be notified.
#OK	- Creates a table `ut_notification_case_invited` to record the notification event: a new user is invited (added in CC) to a case
#OK	- Alters the Procedure `lambda_notification_case_event` to make sure that we:
#		- Add the notification_type information
#		- Add the BZ source table (what is the source of the information)
#OK 	- Create a Lambda Procedure `lambda_notification_case_assigned` to send notification each time a user is assigned to a case.
#OK 	- Create a Lambda Procedure `lambda_notification_case_invited` to send notification each time a user is invited to a case.
#	- Alters the triggers :
#OK		- `ut_prepare_message_new_case` 
#OK		- `ut_prepare_message_case_activity` 
#OK		- `ut_prepare_message_new_comment` 		
#    	  this is to update the table `ut_notification_messages_cases`.
#		  we add variables for:
#			- notification_type
#			- bz_source_table
#OK	- Creates a trigger `ut_prepare_message_case_assigned_new` to update the table `ut_notification_case_assignee` each time a record is added there
#OK	- Creates a trigger `ut_prepare_message_case_assigned_updated` to update the table `ut_notification_case_assignee` each time the assignee is changed in a case
#OK	- Creates a trigger `ut_prepare_message_case_invited` to update the table `ut_notification_case_invited` each time a record is user is invited to a case.
#
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
	(1,@the_timestamp,'case_updated','A case has been updated','A case has been updated.\r\nWe record the following information:\r\n- When was the case updated?\r\n- The unit id\r\n- The case id\r\n- Who did the update\r\n- Which field was updated'),
	(2,@the_timestamp,'case_assignee_new','User is assigned to a new case','A new case has been created and this is the assigned user for this case.\r\nWe record the following information:\r\n- When did this happen?\r\n- Who created the case?\r\n- What is the unit id?\r\n- What is the case id?\r\n- Who is the user assigned to that case?'),
	(3,@the_timestamp,'case_assignee_updated','The user assigned to that case has changed','A new user has been assigned to a case.\r\nWe record the following information:\r\n- When did this happen?\r\n- Who made this change?\r\n- What is the unit id?\r\n- What is the case id?\r\n- Who is the new user assigned to that case?'),
	(4,@the_timestamp,'case_user_invited','A user is invited to a case','A new user has been invited to a case.\r\nThe information we store:\r\n- When has this been done\r\n- What is the unit number\r\n- What is the case number\r\n- Who is the newly invited user\r\n\r\nWe do NOT record who has invited the user as this information is not easily accessible from the trigger we use (insert into the table `cc`)');

# Create a table `ut_notification_case_assignee` to record the notification events: 
#	- bug created, assignee needs to be notified
#	- Bug updated, assignee changed, new assignee needs to be notified.

	DROP TABLE IF EXISTS `ut_notification_case_assignee`;

	CREATE TABLE `ut_notification_case_assignee` (
	  `notification_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Id in this table',
	  `created_datetime` DATETIME DEFAULT NULL COMMENT 'Timestamp when this was created',
	  `processed_datetime` DATETIME DEFAULT NULL COMMENT 'Timestamp when this notification was processed',
	  `unit_id` SMALLINT(6) DEFAULT NULL COMMENT 'Unit ID - a FK to the BZ table ''products''',
	  `case_id` MEDIUMINT(9) DEFAULT NULL COMMENT 'Case ID - a FK to the BZ table ''bugs''',
	  `invitor_user_id` MEDIUMINT(9) DEFAULT NULL COMMENT 'User ID - The user who needs to be notified - a FK to the BZ table ''profiles''',
	  `assignee_user_id` MEDIUMINT(9) DEFAULT NULL COMMENT 'User ID - The user who has been assigned to the case a FK to the BZ table ''profiles''',
	  PRIMARY KEY (`notification_id`)
	) ENGINE=INNODB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

# Create a table `ut_notification_case_invited` to record the notification event: a new user is invited (added in CC) to a case
#	WARNING - Because we use the data from the BZ table `cc` we will NOT include the invitor_id in the trigger to update this table
#	  We keep this field as a placeholder in case we can update this in future releases.

	DROP TABLE IF EXISTS `ut_notification_case_invited`;

	CREATE TABLE `ut_notification_case_invited` (
	  `notification_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Id in this table',
	  `created_datetime` DATETIME DEFAULT NULL COMMENT 'Timestamp when this was created',
	  `processed_datetime` DATETIME DEFAULT NULL COMMENT 'Timestamp when this notification was processed',
	  `unit_id` SMALLINT(6) DEFAULT NULL COMMENT 'Unit ID - a FK to the BZ table ''products''',
	  `case_id` MEDIUMINT(9) DEFAULT NULL COMMENT 'Case ID - a FK to the BZ table ''bugs''',
	  `invitor_user_id` MEDIUMINT(9) DEFAULT NULL COMMENT 'User ID - The user who needs to be notified - a FK to the BZ table ''profiles''',
	  `invitee_user_id` MEDIUMINT(9) DEFAULT NULL COMMENT 'User ID - The user who has been invited to the case a FK to the BZ table ''profiles''',
	  PRIMARY KEY (`notification_id`)
	) ENGINE=INNODB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

# Alter the Lambda Procedure `lambda_notification_case_event` to make sure that we:
#		- Add the notification_type information
#		- Add the BZ source table (what is the source of the information)
# IMPORTANT!! make sure that the variable for the Lambda is correct for each environement

DROP PROCEDURE IF EXISTS `lambda_notification_case_event`;
	
DELIMITER $$
CREATE PROCEDURE `lambda_notification_case_event`(
	IN notification_type varchar(255)
	, IN bz_source_table varchar(255)
	, IN notification_id int(11)
	, IN created_datetime datetime
	, IN unit_id smallint(6)
	, IN case_id mediumint(9)
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
			, '", "user_id" : "', user_id
			, '", "update_what" : "', update_what
			, '"}'
			)
		)
		;
END $$
DELIMITER ;

# Create the Lambda Procedure `lambda_notification_case_assigned` 
# IMPORTANT!! make sure that the variable for the Lambda is correct for each environement

DROP PROCEDURE IF EXISTS `lambda_notification_case_assignee`;
	
DELIMITER $$
CREATE PROCEDURE `lambda_notification_case_assignee`(
	IN notification_type varchar(255)
	, IN bz_source_table varchar(255)
	, IN notification_id int(11)
	, IN created_datetime datetime
	, IN unit_id smallint(6)
	, IN case_id mediumint(9)
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
			, '", "invitor_user_id" : "', invitor_user_id
			, '", "assignee_user_id" : "', assignee_user_id
			, '"}'
			)
		)
		;
END $$
DELIMITER ;

# Create the Lambda Procedure `lambda_notification_case_invited` 
# IMPORTANT!! make sure that the variable for the Lambda is correct for each environement

DROP PROCEDURE IF EXISTS `lambda_notification_case_invited`;
	
DELIMITER $$
CREATE PROCEDURE `lambda_notification_case_invited`(
	IN notification_type varchar(255)
	, IN bz_source_table varchar(255)
	, IN notification_id int(11)
	, IN created_datetime datetime
	, IN unit_id smallint(6)
	, IN case_id mediumint(9)
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
			, '", "invitee_user_id" : "', invitee_user_id
			, '"}'
			)
		)
		;
END $$
DELIMITER ;

# Update the trigger `ut_prepare_message_new_case` when a case is created

DROP TRIGGER IF EXISTS `ut_prepare_message_new_case`;

DELIMITER $$
CREATE TRIGGER `ut_prepare_message_new_case`
AFTER INSERT ON `bugs`
FOR EACH ROW
BEGIN
	SET @notification_type = 'case_updated';
	SET @bz_source_table = 'ut_notification_messages_cases';
	SET @notification_id = ((SELECT MAX(`notification_id`) FROM `ut_notification_messages_cases`) + 1);
	SET @created_datetime = NOW();
	SET @unit_id = NEW.`product_id`;
	SET @case_id = NEW.`bug_id`;
	SET @user_id = NEW.`reporter`;
	SET @update_what = 'New Case';
	
	# We insert the event in the notification table
	INSERT INTO `ut_notification_messages_cases`
		(notification_id
		, `created_datetime`
		, `unit_id`
		, `case_id`
		, `user_id`
		, `update_what`
		)
		VALUES
		(@notification_id
		, NOW()
		, @unit_id
		, @case_id
		, @user_id
		, @update_what
		)
		;
	
	# We call the Lambda procedure to notify of the change
	CALL `lambda_notification_case_event`(@notification_type
		, @bz_source_table
		, @notification_id
		, @created_datetime
		, @unit_id
		, @case_id
		, @user_id
		, @update_what
		)
		;
END;
$$
DELIMITER ;

# We update the trigger `ut_prepare_message_case_activity` when a case is updated

DROP TRIGGER IF EXISTS `ut_prepare_message_case_activity`;

DELIMITER $$
CREATE TRIGGER `ut_prepare_message_case_activity`
AFTER INSERT ON `bugs_activity`
FOR EACH ROW
BEGIN
	SET @notification_type = 'case_updated';
	SET @bz_source_table = 'ut_notification_messages_cases';
	SET @notification_id = ((SELECT MAX(`notification_id`) FROM `ut_notification_messages_cases`) + 1);
	SET @created_datetime = NOW();
	SET @unit_id = (SELECT `product_id` FROM `bugs` WHERE `bug_id` = NEW.`bug_id`);
	SET @case_id = NEW.`bug_id`;
	SET @user_id = NEW.`who`;
	SET @update_what = (SELECT `description` FROM `fielddefs` WHERE `id` = NEW.`fieldid`);
	INSERT INTO `ut_notification_messages_cases`
		(notification_id
		, `created_datetime`
		, `unit_id`
		, `case_id`
		, `user_id`
		, `update_what`
		)
		VALUES
		(@notification_id
		, NOW()
		, @unit_id
		, @case_id
		, @user_id
		, @update_what
		)
		;
		
	# We call the Lambda procedure to notify of the change
	CALL `lambda_notification_case_event`(@notification_type
		, @bz_source_table
		, @notification_id
		, @created_datetime
		, @unit_id
		, @case_id
		, @user_id
		, @update_what
		)
		;
END;
$$
DELIMITER ;

# We update the trigger `ut_prepare_message_new_comment` when a new message is added

DROP TRIGGER IF EXISTS `ut_prepare_message_new_comment`;

DELIMITER $$
CREATE TRIGGER `ut_prepare_message_new_comment`
AFTER INSERT ON `longdescs`
FOR EACH ROW
BEGIN
	SET @notification_type = 'case_updated';
	SET @bz_source_table = 'ut_notification_messages_cases';
	SET @notification_id = ((SELECT MAX(`notification_id`) FROM `ut_notification_messages_cases`) + 1);
	SET @created_datetime = NOW();
	SET @unit_id = (SELECT `product_id` FROM `bugs` WHERE `bug_id` = NEW.`bug_id`);
	SET @case_id = NEW.`bug_id`;
	SET @user_id = NEW.`who`;
	SET @update_what = 'New Message';
	INSERT INTO `ut_notification_messages_cases`
		(notification_id
		, `created_datetime`
		, `unit_id`
		, `case_id`
		, `user_id`
		, `update_what`
		)
		VALUES
		(@notification_id
		, NOW()
		, @unit_id
		, @case_id
		, @user_id
		, @update_what
		)
		;
		
	# We call the Lambda procedure to notify of the change
	CALL `lambda_notification_case_event`(@notification_type
		, @bz_source_table
		, @notification_id
		, @created_datetime
		, @unit_id
		, @case_id
		, @user_id
		, @update_what
		)
		;
END;
$$
DELIMITER ;

# We create a trigger when a new case is created to 
#	- Update the table `ut_notification_case_assignee`
#	- Send a lambda notification to the assignee

DROP TRIGGER IF EXISTS `ut_prepare_message_case_assigned_new`;

DELIMITER $$
CREATE TRIGGER `ut_prepare_message_case_assigned_new`
AFTER INSERT ON `bugs`
FOR EACH ROW
BEGIN
	SET @notification_type = 'case_assignee_new';
	SET @bz_source_table = 'ut_notification_case_assignee';
	SET @notification_id = ((SELECT MAX(`notification_id`) FROM `ut_notification_case_assignee`) + 1);
	SET @created_datetime = NOW();
	SET @unit_id = NEW.`product_id`;
	SET @case_id = NEW.`bug_id`;
	SET @invitor_user_id = NEW.`reporter`;
	SET @assignee_user_id = NEW.`assigned_to`;
	
	INSERT INTO `ut_notification_case_assignee`
		(`notification_id`
		, `created_datetime`
		, `unit_id`
		, `case_id`
		, `invitor_user_id`
		, `assignee_user_id`
		)
		VALUES
		(@notification_id
		, @created_datetime
		, @unit_id
		, @case_id
		, @invitor_user_id
		, @assignee_user_id
		)
		;
		
	# We call the Lambda procedure to notify of the change
	CALL `lambda_notification_case_assignee`(@notification_type
		, @bz_source_table
		, @notification_id
		, @created_datetime
		, @unit_id
		, @case_id
		, @invitor_user_id
		, @assignee_user_id
		)
		;		
END;
$$
DELIMITER ;

# We create a trigger when an existing case is updated to 
#	- Update the table `ut_notification_case_assignee`
#	- Send a lambda notification to the assignee

DROP TRIGGER IF EXISTS `ut_prepare_message_case_assigned_updated`;

DELIMITER $$
CREATE TRIGGER `ut_prepare_message_case_assigned_updated`
AFTER UPDATE ON `bugs`
FOR EACH ROW
BEGIN
	# We only do that if the assignee has changed
	IF NEW.`assigned_to` != OLD.`assigned_to`
	THEN 
		SET @notification_type = 'case_assignee_updated';
		SET @bz_source_table = 'ut_notification_case_assignee';
		SET @notification_id = ((SELECT MAX(`notification_id`) FROM `ut_notification_case_assignee`) + 1);
		SET @created_datetime = NOW();
		SET @unit_id = NEW.`product_id`;
		SET @case_id = NEW.`bug_id`;
		SET @invitor_user_id = 0;
		SET @assignee_user_id = NEW.`assigned_to`;
		
		INSERT INTO `ut_notification_case_assignee`
			(`notification_id`
			, `created_datetime`
			, `unit_id`
			, `case_id`
			, `invitor_user_id`
			, `assignee_user_id`
			)
			VALUES
			(@notification_id
			, @created_datetime
			, @unit_id
			, @case_id
			, @invitor_user_id
			, @assignee_user_id
			)
			;
			
		# We call the Lambda procedure to notify of the change
		CALL `lambda_notification_case_assignee`(@notification_type
			, @bz_source_table
			, @notification_id
			, @created_datetime
			, @unit_id
			, @case_id
			, @invitor_user_id
			, @assignee_user_id
			)
			;
	END IF;
END;
$$
DELIMITER ;

# We create a trigger when a user is invited to a case
#	- Update the table `ut_notification_case_invited`
#	- Send a lambda notification to the invited user

DROP TRIGGER IF EXISTS `ut_prepare_message_case_invited`;

# We then create the trigger when a case is created
DELIMITER $$
CREATE TRIGGER `ut_prepare_message_case_invited`
AFTER INSERT ON `cc`
FOR EACH ROW
BEGIN
	SET @notification_type = 'case_user_invited';
	SET @bz_source_table = 'ut_notification_case_invited';
	SET @notification_id = ((SELECT MAX(`notification_id`) FROM `ut_notification_case_invited`) + 1);
	SET @created_datetime = NOW();
	SET @case_id = NEW.`bug_id`;
	SET @unit_id = (SELECT `product_id` FROM `bugs` WHERE `bug_id` = @case_id);
	SET @invitee_user_id = NEW.`who`;
	
	INSERT INTO `ut_notification_case_invited`
		(`notification_id`
		, `created_datetime`
		, `unit_id`
		, `case_id`
		, `invitee_user_id`
		)
		VALUES
		(@notification_id
		, @created_datetime
		, @unit_id
		, @case_id
		, @invitee_user_id
		)
		;
		
	# We call the Lambda procedure to notify of the change
	CALL `lambda_notification_case_invited`(@notification_type
		, @bz_source_table
		, @notification_id
		, @created_datetime
		, @unit_id
		, @case_id
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