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
#		- line: 96
#
# Make sure to also update the below variable(s)
#
############################################
#
# What are the version of the Unee-T BZ Database schema BEFORE and AFTER this update?
	SET @old_schema_version = 'v3.15';
	SET @new_schema_version = 'v3.16';
#
# What is the name of this script?
	SET @this_script = 'upgrade_unee-t_v3.15_to_v3.16.sql';
#
###############################
#
# We have everything we need
#
###############################
# This update
#
#OK	- Fixed the issue we have when we try to send a notification about new message at the time of case creation:
#		- Differenciate first message (description) from follow up messages
#		- create a new trigger `ut_notification_classify_messages`
#		- alter the existing trigger `ut_prepare_message_new_comment`
#		- If the message is a follow-up message then call the lambda to send the notification
#
#OK	- Alter a table `ut_notification_message_new`: 
#		- add a field `is_case_description` to record if this is the first message (notification) or not
#
#OK	- rename the procedure `lambda_notification_message_new` to `lambda_notification_message_new_comment`
#
#OK	- Creates a new trigger `ut_notification_classify_messages` 
#		- This is a modified version of the trigger `ut_prepare_message_new_comment`
#		- populates the table `ut_notification_message_new` each time a new record is added to the table ``
#		- remove the call to the lambda
# 		- add the information is_case_description` in the list of fields that need to be populated.
#
#OK	- Alters the triggers `ut_prepare_message_new_comment`:
#		- Trigger is based on an insert in the table `ut_notification_message_new`
#		- Trigger only if the field `is_case_description` is != 1
#		- This is where the lambda call is made
#				
# When are we doing this?
	SET @the_timestamp = NOW();

# Alter the a table `ut_notification_message_new` 
#	- add a field to record if this is the first message (notification) or not

	ALTER TABLE `ut_notification_message_new` 
		ADD COLUMN `is_case_description` tinyint(1)   NULL COMMENT '1 if this is the FIRST message for a case (the case description)' after `user_id` , 
		CHANGE `message_truncated` `message_truncated` varchar(255)  COLLATE utf8_unicode_ci NULL COMMENT 'The message, truncated to the first 255 characters' after `is_case_description` 
		;

# Rename the procedure `lambda_notification_message_new` to `lambda_notification_message_new_comment`
#
# IMPORTANT!! make sure that the variable for the Lambda is correct for each environement

	DROP PROCEDURE IF EXISTS `lambda_notification_message_new`;
	DROP PROCEDURE IF EXISTS `lambda_notification_message_new_comment`;
	
DELIMITER $$
CREATE PROCEDURE `lambda_notification_message_new_comment`(
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
			, '", "case_reporter_user_id" : "', case_reporter_user_id
			, '", "old_case_assignee_user_id" : "', old_case_assignee_user_id
			, '", "new_case_assignee_user_id" : "', new_case_assignee_user_id
			, '", "current_list_of_invitees" : "', current_list_of_invitees
			, '"}'
			)
		)
		;
END $$
DELIMITER ;

# Creates a new trigger `ut_notification_classify_messages` 
#			- This is a modified version of the trigger `ut_prepare_message_new_comment`
#			- populates the table `ut_notification_message_new` each time a new record is added to the table `longdescs`
#			- remove the call to the lambda
#			- Check if this is the first message for that case.
# 			- add the information `is_case_description` in the list of fields that need to be populated.
#

	DROP TRIGGER IF EXISTS `ut_notification_classify_messages`;

DELIMITER $$
CREATE TRIGGER `ut_notification_classify_messages`
AFTER INSERT ON `longdescs`
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
		SET @message_truncated = NULL;
		SET @case_reporter_user_id = NULL;
		SET @old_case_assignee_user_id = NULL;
		SET @new_case_assignee_user_id = NULL;
		SET @current_list_of_invitees = NULL;

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
		SET @message_truncated = NEW.`thetext`;
		SET @case_reporter_user_id = (SELECT `reporter` FROM `bugs` WHERE `bug_id` = @case_id);
		SET @old_case_assignee_user_id = (SELECT `assigned_to` FROM `bugs` WHERE `bug_id` = @case_id);
		SET @new_case_assignee_user_id = (SELECT `assigned_to` FROM `bugs` WHERE `bug_id` = @case_id);
		SET @current_list_of_invitees = (SELECT GROUP_CONCAT(DISTINCT `who` ORDER BY `who` SEPARATOR ', ')
			FROM `cc`
			WHERE `bug_id` = @case_id
			GROUP BY `bug_id`)
			;
		
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
			)
			;

END;
$$
DELIMITER ;

# Alter the trigger `ut_prepare_message_new_comment`
#	- Trigger is based on an insert in the table `ut_notification_message_new`
#	- Trigger only if the field `is_case_description` is != 1
#	- This is where the lambda call is made

	DROP TRIGGER IF EXISTS `ut_prepare_message_new_comment`;

DELIMITER $$
CREATE TRIGGER `ut_prepare_message_new_comment`
AFTER INSERT ON `ut_notification_message_new`
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
				)
				;
	END IF;
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