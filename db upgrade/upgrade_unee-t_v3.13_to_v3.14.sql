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
#		- line: 178
#		- line: 228
#		- line: 278
#		- line: 329
#
# Make sure to also update the below variable(s)
#
############################################
#
# What are the version of the Unee-T BZ Database schema BEFORE and AFTER this update?
	SET @old_schema_version = 'v3.13';
	SET @new_schema_version = 'v3.14';
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
#OK	- Alter the a table `ut_notification_case_assignee` add fields for
#		- reporter for the case
#		- new assignee for the case
#		- old assignee for the case
#		- new list of invited users
#		- old list of invited users
#OK	- Alter the a table `ut_notification_case_invited` add fields for
#		- reporter for the case
#		- new assignee for the case
#		- old assignee for the case
#		- new list of invited users
#		- old list of invited users
#OK	- Alter a table `ut_notification_case_new` renane fields for better clarity
#		- `user_id` to `reporter_user_id`
#		- `assignee_id` to `assignee_user_id`
#OK	- Alter the a table `ut_notification_case_updated` add fields for
#		- reporter for the case
#		- new assignee for the case
#		- old assignee for the case
#		- new list of invited users
#		- old list of invited users
#OK	- Alter a table `ut_notification_message_new`  add fields for
#		- reporter for the case
#		- new assignee for the case
#		- old assignee for the case
#		- new list of invited users
#		- old list of invited users
#	- Alters the Procedures 
#TEST NEEDED		- `lambda_notification_case_assignee_updated` add the following elements to the payload:
#				- reporter for the case
#				- new assignee for the case
#				- old assignee for the case
#TEST NEEDED		- `lambda_notification_case_invited` add the following elements to the payload:
#				- reporter for the case
#				- new assignee for the case
#				- old assignee for the case
#TEST NEEDED		- `lambda_notification_case_updated` add the following elements to the payload:
#				- reporter for the case
#				- new assignee for the case
#				- old assignee for the case
#TEST NEEDED		- `lambda_notification_message_new` add the following elements to the payload:
#				- reporter for the case
#				- new assignee for the case
#				- old assignee for the case
#	- Alters the triggers :
#TEST NEEDED		- `ut_prepare_message_case_activity` make sure we include the following elements in the DB and in the Lambda
#				- reporter for the case
#				- new assignee for the case
#				- old assignee for the case
#TEST NEEDED		- `ut_prepare_message_case_assigned_updated` make sure we include the following elements in the DB and in the Lambda
#				- reporter for the case
#				- new assignee for the case
#				- old assignee for the case
#TEST NEEDED		- `ut_prepare_message_case_invited` make sure we include the following elements in the DB and in the Lambda
#				- reporter for the case
#				- new assignee for the case
#				- old assignee for the case
#TEST NEEDED		- `ut_prepare_message_new_case` make sure we use the new name for the variables and fields
#				- change `user_id` to `reporter_user_id`
#				- change `assignee_id` to `assignee_user_id`
#TEST NEEDED		- `ut_prepare_message_new_comment` make sure we include the following elements in the DB and in the Lambda
#				- reporter for the case
#				- new assignee for the case
#				- old assignee for the case
#
#

# When are we doing this?
	SET @the_timestamp = NOW();

# Alter the a table `ut_notification_case_assignee` add the title of the case
	ALTER TABLE `ut_notification_case_assignee` 
		ADD COLUMN `case_reporter_user_id` mediumint(9)   NULL COMMENT 'User ID - BZ user id of the reporter for the case' after `assignee_user_id` , 
		ADD COLUMN `old_case_assignee_user_id` mediumint(9)   NULL COMMENT 'User ID - BZ user id of the assignee for the case before the change' after `case_reporter_user_id` , 
		ADD COLUMN `new_case_assignee_user_id` mediumint(9)   NULL COMMENT 'User ID - BZ user id of the assignee for the case after the change' after `old_case_assignee_user_id` , 
		ADD COLUMN `old_case_invitee_list_user_id` mediumtext  COLLATE utf8_unicode_ci NULL COMMENT 'comma separated list of user IDs - BZ user ids of the user in cc for this case/bug BEFORE the change' after `new_case_assignee_user_id` , 
		ADD COLUMN `new_case_invitee_list_user_id` mediumtext  COLLATE utf8_unicode_ci NULL COMMENT 'comma separated list of user IDs - BZ user ids of the user in cc for this case/bug AFTER the change' after `old_case_invitee_list_user_id` 
		;

# Alter the a table `ut_notification_case_invited` add the title of the case
	ALTER TABLE `ut_notification_case_invited` 
		ADD COLUMN `case_reporter_user_id` mediumint(9)   NULL COMMENT 'User ID - BZ user id of the reporter for the case' after `invitee_user_id` , 
		ADD COLUMN `old_case_assignee_user_id` mediumint(9)   NULL COMMENT 'User ID - BZ user id of the assignee for the case before the change' after `case_reporter_user_id` , 
		ADD COLUMN `new_case_assignee_user_id` mediumint(9)   NULL COMMENT 'User ID - BZ user id of the assignee for the case after the change' after `old_case_assignee_user_id` , 
		ADD COLUMN `old_case_invitee_list_user_id` mediumtext  COLLATE utf8_unicode_ci NULL COMMENT 'comma separated list of user IDs - BZ user ids of the user in cc for this case/bug BEFORE the change' after `new_case_assignee_user_id` , 
		ADD COLUMN `new_case_invitee_list_user_id` mediumtext  COLLATE utf8_unicode_ci NULL COMMENT 'comma separated list of user IDs - BZ user ids of the user in cc for this case/bug AFTER the change' after `old_case_invitee_list_user_id` 
		;

# Alter the a table `ut_notification_case_new`
	ALTER TABLE `ut_notification_case_new` 
		CHANGE COLUMN `user_id` `reporter_user_id` mediumint(9)
		, CHANGE COLUMN `assignee_id` `assignee_user_id` mediumint(9)
		;

# Alter the a table `ut_notification_case_updated` add the title of the case
	ALTER TABLE `ut_notification_case_updated` 
		ADD COLUMN `case_reporter_user_id` mediumint(9)   NULL COMMENT 'User ID - BZ user id of the reporter for the case' after `update_what` , 
		ADD COLUMN `old_case_assignee_user_id` mediumint(9)   NULL COMMENT 'User ID - BZ user id of the assignee for the case before the change' after `case_reporter_user_id` , 
		ADD COLUMN `new_case_assignee_user_id` mediumint(9)   NULL COMMENT 'User ID - BZ user id of the assignee for the case after the change' after `old_case_assignee_user_id` , 
		ADD COLUMN `old_case_invitee_list_user_id` mediumtext  COLLATE utf8_unicode_ci NULL COMMENT 'comma separated list of user IDs - BZ user ids of the user in cc for this case/bug BEFORE the change' after `new_case_assignee_user_id` , 
		ADD COLUMN `new_case_invitee_list_user_id` mediumtext  COLLATE utf8_unicode_ci NULL COMMENT 'comma separated list of user IDs - BZ user ids of the user in cc for this case/bug AFTER the change' after `old_case_invitee_list_user_id` 
		;
# Alter the a table `ut_notification_message_new`
	ALTER TABLE `ut_notification_message_new` 
		ADD COLUMN `case_reporter_user_id` mediumint(9)   NULL COMMENT 'User ID - BZ user id of the reporter for the case' after `message_truncated` , 
		ADD COLUMN `old_case_assignee_user_id` mediumint(9)   NULL COMMENT 'User ID - BZ user id of the assignee for the case before the change' after `case_reporter_user_id` , 
		ADD COLUMN `new_case_assignee_user_id` mediumint(9)   NULL COMMENT 'User ID - BZ user id of the assignee for the case after the change' after `old_case_assignee_user_id` , 
		ADD COLUMN `old_case_invitee_list_user_id` mediumtext  COLLATE utf8_unicode_ci NULL COMMENT 'comma separated list of user IDs - BZ user ids of the user in cc for this case/bug BEFORE the change' after `new_case_assignee_user_id` , 
		ADD COLUMN `new_case_invitee_list_user_id` mediumtext  COLLATE utf8_unicode_ci NULL COMMENT 'comma separated list of user IDs - BZ user ids of the user in cc for this case/bug AFTER the change' after `old_case_invitee_list_user_id` 
		;

# Alter the Procedure `lambda_notification_case_assignee_updated` add the following elements to the payload:
#	- reporter for the case
#	- new assignee for the case
#	- old assignee for the case
# IMPORTANT!! make sure that the variable for the Lambda is correct for each environement


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
	, IN case_reporter_user_id mediumint(9)
	, IN old_case_assignee_user_id mediumint(9)
	, IN new_case_assignee_user_id mediumint(9)
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
			, '", "case_reporter_user_id" : "', case_reporter_user_id
			, '", "old_case_assignee_user_id" : "', old_case_assignee_user_id
			, '", "new_case_assignee_user_id" : "', new_case_assignee_user_id
			, '"}'
			)
		)
		;
END $$
DELIMITER ;

# Alter the Procedure `lambda_notification_case_invited` add the following elements to the payload:
#	- reporter for the case
#	- new assignee for the case
#	- old assignee for the case
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
	, IN case_reporter_user_id mediumint(9)
	, IN old_case_assignee_user_id mediumint(9)
	, IN new_case_assignee_user_id mediumint(9)
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
			, '", "case_reporter_user_id" : "', case_reporter_user_id
			, '", "old_case_assignee_user_id" : "', old_case_assignee_user_id
			, '", "new_case_assignee_user_id" : "', new_case_assignee_user_id
			, '"}'
			)
		)
		;
END $$
DELIMITER ;

# Alter the Procedure `lambda_notification_case_updated` add the following elements to the payload:
#	- reporter for the case
#	- new assignee for the case
#	- old assignee for the case
# IMPORTANT!! make sure that the variable for the Lambda is correct for each environement

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
	, IN case_reporter_user_id mediumint(9)
	, IN old_case_assignee_user_id mediumint(9)
	, IN new_case_assignee_user_id mediumint(9)
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
			, '", "case_reporter_user_id" : "', case_reporter_user_id
			, '", "old_case_assignee_user_id" : "', old_case_assignee_user_id
			, '", "new_case_assignee_user_id" : "', new_case_assignee_user_id
			, '"}'
			)
		)
		;
END $$
DELIMITER ;

# Alter the Procedure `lambda_notification_message_new` add the following elements to the payload:
#				- reporter for the case
#				- new assignee for the case
#				- old assignee for the case
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
	, IN case_reporter_user_id mediumint(9)
	, IN old_case_assignee_user_id mediumint(9)
	, IN new_case_assignee_user_id mediumint(9)
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
			, '"}'
			)
		)
		;
END $$
DELIMITER ;

# Alter the trigger `ut_prepare_message_case_activity` make sure we include the following elements in the DB and in the Lambda
#				- reporter for the case
#				- new assignee for the case
#				- old assignee for the case

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
		SET @case_reporter_user_id = NULL;
		SET @old_case_assignee_user_id = NULL;
		SET @new_case_assignee_user_id = NULL;

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
		SET @case_reporter_user_id = (SELECT `reporter` FROM `bugs` WHERE `bug_id` = @case_id);
		SET @old_case_assignee_user_id = (SELECT `assigned_to` FROM `bugs` WHERE `bug_id` = @case_id);
		SET @new_case_assignee_user_id = (SELECT `assigned_to` FROM `bugs` WHERE `bug_id` = @case_id);
	
	# We insert the event in the relevant notification table
		INSERT INTO `ut_notification_case_updated`
			(notification_id
			, `created_datetime`
			, `unit_id`
			, `case_id`
			, `case_title`
			, `user_id`
			, `update_what`
			, `case_reporter_user_id`
			, `old_case_assignee_user_id`
			, `new_case_assignee_user_id`
			)
			VALUES
			(@notification_id
			, @created_datetime
			, @unit_id
			, @case_id
			, @case_title
			, @user_id
			, @update_what
			, @case_reporter_user_id
			, @old_case_assignee_user_id
			, @new_case_assignee_user_id
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
			, @case_reporter_user_id
			, @old_case_assignee_user_id
			, @new_case_assignee_user_id
			)
			;
END;
$$
DELIMITER ;

# Alter the trigger `ut_prepare_message_case_assigned_updated` make sure we include the following elements in the DB and in the Lambda
#				- reporter for the case
#				- new assignee for the case
#				- old assignee for the case

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
			SET @case_reporter_user_id = NULL;
			SET @old_case_assignee_user_id = NULL;
			SET @new_case_assignee_user_id = NULL;

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
			SET @case_reporter_user_id = (SELECT `reporter` FROM `bugs` WHERE `bug_id` = @case_id);
			SET @old_case_assignee_user_id = OLD.`assigned_to`;
			SET @new_case_assignee_user_id = NEW.`assigned_to`;
		
		# We insert the event in the relevant notification table
			INSERT INTO `ut_notification_case_assignee`
				(`notification_id`
				, `created_datetime`
				, `unit_id`
				, `case_id`
				, `case_title`
				, `invitor_user_id`
				, `assignee_user_id`
				, `case_reporter_user_id`
				, `old_case_assignee_user_id`
				, `new_case_assignee_user_id`
				)
				VALUES
				(@notification_id
				, @created_datetime
				, @unit_id
				, @case_id
				, @case_title
				, @invitor_user_id
				, @assignee_user_id
				, @case_reporter_user_id
				, @old_case_assignee_user_id
				, @new_case_assignee_user_id
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
				, @case_reporter_user_id
				, @old_case_assignee_user_id
				, @new_case_assignee_user_id
				)
				;
	END IF;
END;
$$
DELIMITER ;

# Alter the trigger `ut_prepare_message_case_invited` make sure we include the following elements in the DB and in the Lambda
#				- reporter for the case
#				- new assignee for the case
#				- old assignee for the case

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
		SET @case_reporter_user_id = NULL;
		SET @old_case_assignee_user_id = NULL;
		SET @new_case_assignee_user_id = NULL;

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
			)
			;
END;
$$
DELIMITER ;

# Alter the trigger `ut_prepare_message_new_case` make sure we use the new name for the variables and fields
#	- change `user_id` to `reporter_user_id`
#	- change `assignee_id` to `assignee_user_id`

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
		SET @reporter_user_id = NULL;
		SET @assignee_user_id = NULL;

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
	
	# We insert the event in the notification table
		INSERT INTO `ut_notification_case_new`
			(notification_id
			, `created_datetime`
			, `unit_id`
			, `case_id`
			, `case_title`
			, `reporter_user_id`
			, `assignee_user_id`
			)
			VALUES
			(@notification_id
			, NOW()
			, @unit_id
			, @case_id
			, @case_title
			, @reporter_user_id
			, @assignee_user_id
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
			)
			;
END;
$$
DELIMITER ;

# Alter the trigger `ut_prepare_message_new_comment` make sure we include the following elements in the DB and in the Lambda
#				- reporter for the case
#				- new assignee for the case
#				- old assignee for the case
#

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
		SET @case_reporter_user_id = NULL;
		SET @old_case_assignee_user_id = NULL;
		SET @new_case_assignee_user_id = NULL;

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
		SET @case_reporter_user_id = (SELECT `reporter` FROM `bugs` WHERE `bug_id` = @case_id);
		SET @old_case_assignee_user_id = (SELECT `assigned_to` FROM `bugs` WHERE `bug_id` = @case_id);
		SET @new_case_assignee_user_id = (SELECT `assigned_to` FROM `bugs` WHERE `bug_id` = @case_id);
		
	# We insert the event in the relevant notification table
		INSERT INTO `ut_notification_message_new`
			(notification_id
			, `created_datetime`
			, `unit_id`
			, `case_id`
			, `case_title`
			, `user_id`
			, `message_truncated`
			, `case_reporter_user_id`
			, `old_case_assignee_user_id`
			, `new_case_assignee_user_id`
			)
			VALUES
			(@notification_id
			, @created_datetime
			, @unit_id
			, @case_id
			, @case_title
			, @user_id
			, @message_truncated
			, @case_reporter_user_id
			, @old_case_assignee_user_id
			, @new_case_assignee_user_id
			)
			;

########
#
# WARNING! WE HAVE AN ISSUE THERE:
#	IF WE TRIGGER THIS TOGETHER WITH CASE CREATION 
#	THEN IT IS NOT POSSIBLE TO CREATE A CASE ...
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
#			, @case_reporter_user_id
#			, @old_case_assignee_user_id
#			, @new_case_assignee_user_id
#			)
#			;
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