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
	SET @old_schema_version = 'v4.31';
	SET @new_schema_version = 'v4.32';
#
# What is the name of this script?
	SET @this_script = CONCAT ('upgrade_unee-t_', @old_schema_version, '_to_', @new_schema_version);
#
###############################
#
# We have everything we need
#
###############################
# In this update
#
# WIP Update the lambda to add more information to the payload. See issue #115 (https://github.com/unee-t/bz-database/issues/115)
#   - Current Status for the case
#   - Current Resolution for the case
#   - In case of an update to the case: New value of the thing that has been changed in the case.
# In order to do this we need to:
#
#   - Do some housekeeping:
#       - the Table `ut_notification_messages_cases` should be dropped (obsolete since schema v3.13)
#
#   - Alter the following tables:
#       - `ut_notification_case_assignee`
#           add the information 
#           - 'current_status' VARCHAR(64)
#           - 'current_resolution' VARCHAR(64)
#           - 'current_severity' VARCHAR(64)
#       - `ut_notification_case_invited`
#           add the information 
#           - 'current_status'  VARCHAR(64)
#           - 'current_resolution' VARCHAR(64)
#           - 'current_severity' VARCHAR(64)
#       - `ut_notification_case_new`
#           add the information 
#           - 'current_status'  VARCHAR(64)
#           - 'current_resolution' VARCHAR(64)
#           - 'current_severity' VARCHAR(64)
#       - `ut_notification_case_updated`
#           add the information 
#           - 'current_status'  VARCHAR(64)
#           - 'current_resolution' VARCHAR(64)
#           - 'current_severity' VARCHAR(64)
#           - 'old_value' VARCHAR(255)
#           - 'new_value' VARCHAR(255)
#       - `ut_notification_message_new`
#           add the information 
#           - 'current_status'  VARCHAR(64)
#           - 'current_resolution' VARCHAR(64)
#           - 'current_severity' VARCHAR(64)
#
#   - Re-Create the procedures and add the additional payload
#       - `lambda_notification_case_assignee_updated` latest version introduced in v3.18
#       - `lambda_notification_case_updated` latest version introduced in v3.15
#       - `lambda_notification_case_invited` latest version introduced in v3.15
#       - `lambda_notification_case_new` latest version introduced in v3.13
#       - `lambda_notification_message_new_comment` latest version introduced in v3.16
#
#   - Re-Create the triggers to add the additional payload
#     These 5 procedures are associated with 6 triggers and 6 tables:
# OK      - `ut_prepare_message_case_assigned_updated` latest version introduced in v3.17
#            the log for this trigger is in the table `ut_notification_case_assignee`
# OK      - `ut_prepare_message_case_activity` latest version introduced in v3.17
#            the log for this trigger is in the table `ut_notification_case_updated`
# OK      - `ut_prepare_message_case_invited` latest version introduced in v3.17
#            the log for this trigger is in the table `ut_notification_case_invited`
# OK      - `ut_prepare_message_new_case` latest version introduced in v3.14
#            the log for this trigger is in the table `ut_notification_case_new`
# OK      - `ut_prepare_message_new_comment` latest version introduced i1-n v3.16
#            the log for this trigger is not needed as it is fired as a consequence `ut_notification_classify_messages`
# OK       - `ut_notification_classify_messages` latest version introduced in v3.17
#            the log for this trigger is in the table `ut_notification_message_new`
#
#
# WIP Fixes issue #114 (https://github.com/unee-t/bz-database/issues/114)
# Alter the procedure `remove_user_from_role`
# We need to make sure that the user that we are removing from a role in a unit:
#   - is NOT currently invited to a case for this unit
#   - is NOT currently assigned to a case for this unit.
#
# What we need to do:
#   - IF user is in CC for a case in this unit, 
#     THEN 
#       - un-invite this user to the cases for this unit
#       - Record a message in the case to explain what has been done.
#   - IF user is the current assignee for a case 
#     THEN 
#       - Reset the assignee for the case to the initial owner for this role/component
#       - Record a message in the case to explain what has been done.
#
#

#####################
#
# Do it!
#
#####################

# When are we doing this?
	SET @the_timestamp = NOW();

# WIP Update the lambda to add more information to the payload. See issue #115

    DROP TABLE IF EXISTS `ut_notification_messages_cases`;

    # Alter the tables we use to log what the trigger is doing

        /*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

        /* Alter table in target */
        ALTER TABLE `ut_notification_case_assignee` 
            ADD COLUMN `current_status` VARCHAR(64)  COLLATE utf8mb4_unicode_520_ci NULL COMMENT 'The current status of the case/bug' AFTER `current_list_of_invitees` , 
            ADD COLUMN `current_resolution` VARCHAR(64)  COLLATE utf8mb4_unicode_520_ci NULL COMMENT 'The current resolution of the case/bug' AFTER `current_status` , 
            ADD COLUMN `current_severity` VARCHAR(64)  COLLATE utf8mb4_unicode_520_ci NULL COMMENT 'The current severity of the case/bug' AFTER `current_resolution` ;

        /* Alter table in target */
        ALTER TABLE `ut_notification_case_invited` 
            ADD COLUMN `current_status` VARCHAR(64)  COLLATE utf8mb4_unicode_520_ci NULL COMMENT 'The current status of the case/bug' AFTER `current_list_of_invitees` , 
            ADD COLUMN `current_resolution` VARCHAR(64)  COLLATE utf8mb4_unicode_520_ci NULL COMMENT 'The current resolution of the case/bug' AFTER `current_status` , 
            ADD COLUMN `current_severity` VARCHAR(64)  COLLATE utf8mb4_unicode_520_ci NULL COMMENT 'The current severity of the case/bug' AFTER `current_resolution` ;

        /* Alter table in target */
        ALTER TABLE `ut_notification_case_new` 
            CHANGE `reporter_user_id` `reporter_user_id` MEDIUMINT(9)   NULL COMMENT 'The BZ profile Id of the reporter for the case' AFTER `case_title` , 
            CHANGE `assignee_user_id` `assignee_user_id` MEDIUMINT(9)   NULL COMMENT 'The BZ profile ID of the Assignee to the case' AFTER `reporter_user_id` , 
            ADD COLUMN `current_status` VARCHAR(64)  COLLATE utf8mb4_unicode_520_ci NULL COMMENT 'The current status of the case/bug' AFTER `assignee_user_id` , 
            ADD COLUMN `current_resolution` VARCHAR(64)  COLLATE utf8mb4_unicode_520_ci NULL COMMENT 'The current resolution of the case/bug' AFTER `current_status` , 
            ADD COLUMN `current_severity` VARCHAR(64)  COLLATE utf8mb4_unicode_520_ci NULL COMMENT 'The current severity of the case/bug' AFTER `current_resolution` ;

        /* Alter table in target */
        ALTER TABLE `ut_notification_case_updated` 
            ADD COLUMN `old_value` VARCHAR(255)  COLLATE utf8mb4_unicode_520_ci NULL COMMENT 'The value before it was updated' AFTER `update_what` , 
            ADD COLUMN `new_value` VARCHAR(255)  COLLATE utf8mb4_unicode_520_ci NULL COMMENT 'The value after it was updated' AFTER `old_value` , 
            CHANGE `case_reporter_user_id` `case_reporter_user_id` MEDIUMINT(9)   NULL COMMENT 'User ID - BZ user id of the reporter for the case' AFTER `new_value` , 
            ADD COLUMN `current_status` VARCHAR(64)  COLLATE utf8mb4_unicode_520_ci NULL COMMENT 'The current status of the case/bug' AFTER `current_list_of_invitees` , 
            ADD COLUMN `current_resolution` VARCHAR(64)  COLLATE utf8mb4_unicode_520_ci NULL COMMENT 'The current resolution of the case/bug' AFTER `current_status` , 
            ADD COLUMN `current_severity` VARCHAR(64)  COLLATE utf8mb4_unicode_520_ci NULL COMMENT 'The current severity of the case/bug' AFTER `current_resolution` ;

        /* Alter table in target */
        ALTER TABLE `ut_notification_message_new` 
            ADD COLUMN `current_status` VARCHAR(64)  COLLATE utf8mb4_unicode_520_ci NULL COMMENT 'The current status of the case/bug' AFTER `current_list_of_invitees` , 
            ADD COLUMN `current_resolution` VARCHAR(64)  COLLATE utf8mb4_unicode_520_ci NULL COMMENT 'The current resolution of the case/bug' AFTER `current_status` , 
            ADD COLUMN `current_severity` VARCHAR(64)  COLLATE utf8mb4_unicode_520_ci NULL COMMENT 'The current severity of the case/bug' AFTER `current_resolution` ;
        /*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;

    # Re-create the procedures

# `lambda_notification_case_assignee_updated` the latest version was introduced in schema v4.32
#

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
	, IN case_reporter_user_id mediumint(9)
	, IN old_case_assignee_user_id mediumint(9)
	, IN new_case_assignee_user_id mediumint(9)
	, IN current_list_of_invitees mediumtext
    , IN current_status varchar(64)
    , IN current_resolution varchar(64)
    , IN current_severity varchar(64)
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
			, '", "case_reporter_user_id" : "', case_reporter_user_id
			, '", "old_case_assignee_user_id" : "', old_case_assignee_user_id
			, '", "new_case_assignee_user_id" : "', new_case_assignee_user_id
			, '", "current_list_of_invitees" : "', current_list_of_invitees
            , '", "current_status" : "', current_status
            , '", "current_resolution" : "', current_resolution
            , '", "current_severity" : "', current_severity
			, '"}'
			)
		)
		;
END $$
DELIMITER ;

# `lambda_notification_case_updated` the latest version was introduced in schema v4.32

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
            , '", "old_value" : "', old_value
            , '", "new_value" : "', new_value
			, '", "case_reporter_user_id" : "', case_reporter_user_id
			, '", "old_case_assignee_user_id" : "', old_case_assignee_user_id
			, '", "new_case_assignee_user_id" : "', new_case_assignee_user_id
			, '", "current_list_of_invitees" : "', current_list_of_invitees
            , '", "current_status" : "', current_status
            , '", "current_resolution" : "', current_resolution
            , '", "current_severity" : "', current_severity
			, '"}'
			)
		)
		;
END $$
DELIMITER ;

# `lambda_notification_case_invited` the latest version was introduced in schema v4.32

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
	, IN current_list_of_invitees mediumtext
    , IN current_status varchar(64)
    , IN current_resolution varchar(64)
    , IN current_severity varchar(64)
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
			, '", "current_list_of_invitees" : "', current_list_of_invitees
            , '", "current_status" : "', current_status
            , '", "current_resolution" : "', current_resolution
            , '", "current_severity" : "', current_severity
			, '"}'
			)
		)
		;
END $$
DELIMITER ;

# `lambda_notification_case_new` the latest version was introduced in schema v4.32

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
    , IN current_status varchar(64)
    , IN current_resolution varchar(64)
    , IN current_severity varchar(64)
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
            , '", "current_status" : "', current_status
            , '", "current_resolution" : "', current_resolution
            , '", "current_severity" : "', current_severity
			, '"}'
			)
		)
		;
END $$
DELIMITER ;

# `lambda_notification_message_new_comment` the latest version was introduced in schema v4.32

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
    , IN current_status varchar(64)
    , IN current_resolution varchar(64)
    , IN current_severity varchar(64)
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
            , '", "current_status" : "', current_status
            , '", "current_resolution" : "', current_resolution
            , '", "current_severity" : "', current_severity
			, '"}'
			)
		)
		;
END $$
DELIMITER ;
#
# Code to create the triggers. Keep in mind that the triggers need:
#   - The tables where we record the logs
#   - The procedures
#
# `ut_prepare_message_case_activity` the latest version was introduced in schema v4.32

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

# `ut_prepare_message_case_activity` the latest version was introduced in schema v4.32

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

# `ut_prepare_message_case_invited` the latest version was introduced in schema v4.32
 
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

# `ut_prepare_message_new_case` the latest version was introduced in schema v4.32

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

# `ut_prepare_message_new_comment` the latest version was introduced in schema v4.32

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

# `ut_notification_classify_messages` the latest version was introduced in schema v4.32

DROP TRIGGER `ut_notification_classify_messages`;

DELIMITER $$

CREATE
    TRIGGER `ut_notification_classify_messages` 
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
		SET @message_sanitized_1 = REPLACE(@message,'\r\n',' ');
		SET @message_sanitized_2 = REPLACE(@message_sanitized_1,'\r',' ');
		SET @message_sanitized_3 = REPLACE(@message_sanitized_2,'\n',' ');
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
























# WIP Update the procedure `remove_user_from_role`
	
	DROP PROCEDURE IF EXISTS `remove_user_from_role`;

DELIMITER $$
CREATE PROCEDURE `remove_user_from_role`()
SQL SECURITY INVOKER
BEGIN
	# This procedure needs the following objects
	#	- Variables:
	#		- @remove_user_from_role
	#		- @component_id_this_role
	#		- @product_id
	#		- @bz_user_id
	#		- @bz_user_id_dummy_user_this_role
	#		- @id_role_type
	# 		- @this_script
	#		- @creator_bz_id
    #
    #   - Tables:
    #       - `ut_user_group_map_temp`

	# We only do this if this is needed:
	IF (@remove_user_from_role = 1)
	THEN
		# The script `invite_a_user_to_a_role_in_a_unit.sql` which call this procedure, already calls: 
		# 	- `table_to_list_dummy_user_by_environment`;
		# 	- `remove_user_from_default_cc`
		# There is no need to do this again
		#
		# The script also reset the permissions for this user for this role for this unit to the default permissions.
		# We need to 
        #   - remove ALL the permissions for this user.
        #   - check all the open cases in this unit and verify IF the user that we are removing from a role in a unit:
        #      - is NOT currently invited to a case for this unit
        #      - is NOT currently assigned to a case for this unit.
        #
        #      Then what we need to do:
        #       - IF user is in CC for a case in this unit, 
        #       THEN 
        #           - un-invite this user to the cases for this unit
        #           - Record a message in the case to explain what has been done.
        #       - IF user is the current assignee for a case 
        #       THEN 
        #           - Reset the assignee for the case to the initial owner for this role/component
        #           - Record a message in the case to explain what has been done.
        #	
			# Revoke all permissions for this user in this unit
				# This procedure needs the following objects:
				#	- Variables:
				#		- @product_id
				#		- @bz_user_id
				CALL `revoke_all_permission_for_this_user_in_this_unit`;
			
			# All the permission have been prepared, we can now update the permissions table
			#		- This NEEDS the table 'ut_user_group_map_temp'
				CALL `update_permissions_invited_user`;
######
#
# WIP
#
######
		# Who are the initial owner and initialqa contact for this role?
												
			# Get the old values so we can 
			#	- Check if these are default user for this environment
			#	- log those
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
		
		# We need to check if the user we are removing is the current default user for this role for this unit.
			SET @is_user_default_assignee = IF(@old_component_initialowner = @bz_user_id
				, '1'
				, '0'
				)
				;

		# We need to check if the user we are removing is the current qa user for this role for this unit.
			SET @is_user_qa = IF(@old_component_initialqacontact = @bz_user_id
				, '1'
				, '0'
				)
				;
										
		# We record the name of this procedure for future debugging and audit_log
			SET @script = 'PROCEDURE - remove_user_from_role';
			SET @timestamp = NOW();

		IF @is_user_default_assignee = 1
		THEN
		# We need to replace this with the default dummy user
		# The variables needed for this are
		#	- @bz_user_id_dummy_user_this_role
		# 	- @component_id_this_role
		#	- @id_role_type
		# 	- @this_script
		#	- @product_id
		#	- @creator_bz_id
		
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
										, 'line 170'
										)
									)
								)
							)
						)
					)
					;
					
			# We define the dummy user public name based on the variable @bz_user_id_dummy_user_this_role
				SET @dummy_user_pub_name = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_user_this_role);
			
			# Update the default assignee

                # Make sure we have the correct value for the name of this script so the `ut_audit_log_table` has the correct info
                    SET @script = 'PROCEDURE remove_user_from_role';

                # We can now do the update
                    UPDATE `components`
                    SET `initialowner` = @bz_user_id_dummy_user_this_role
                        ,`description` = @dummy_user_role_desc
                        WHERE 
                        `id` = @component_id_this_role
                        ;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('The component: '
					, (SELECT IFNULL(@component_id_this_role, 'component_id_this_role is NULL'))
					, ' (for the role_type_id #'
					, (SELECT IFNULL(@id_role_type, 'id_role_type is NULL'))
					, ') has been updated.'
					, '\r\The default user now associated to this role is the dummy bz user #'
					, (SELECT IFNULL(@bz_user_id_dummy_user_this_role, 'bz_user_id is NULL'))
					, ' (real name: '
					, (SELECT IFNULL(@dummy_user_pub_name, 'user_pub_name is NULL'))
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
				INSERT  INTO `audit_log`
					(`user_id`
					,`class`
					,`object_id`
					,`field`
					,`removed`
					,`added`
					,`at_time`
					) 
					VALUES 
					(@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'initialowner',@old_component_initialowner,@bz_user_id_dummy_user_this_role,@timestamp)
					, (@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'description',@old_component_description,@dummy_user_role_desc,@timestamp)
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
		END IF;

		IF @is_user_qa = 1
		THEN
		# IF the user is the current qa contact: We need to replace this with the default dummy user
		# The variables needed for this are
		#	- @bz_user_id_dummy_user_this_role
		# 	- @component_id_this_role
		#	- @id_role_type
		# 	- @this_script
		#	- @product_id
		#	- @creator_bz_id

			# We define the dummy user role description based on the variable @id_role_type
				SET @dummy_user_role_desc = IF(@id_role_type = 1
					, CONCAT('Generic '
						, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
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
								, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
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
										, 'line 298'
										)
									)
								)
							)
						)
					)
					;
					
			# We define the dummy user public name based on the variable @bz_user_id_dummy_user_this_role
				SET @dummy_user_pub_name = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_user_this_role);
		
			# Update the default assignee and qa contact

                # Make sure we have the correct value for the name of this script so the `ut_audit_log_table` has the correct info
                    SET @script = 'PROCEDURE remove_user_from_role';

                # We can now do the update
                    UPDATE `components`
                    SET 
                        `initialqacontact` = @bz_user_id_dummy_user_this_role
                        WHERE 
                        `id` = @component_id_this_role
                        ;	

			# Log the actions of the script.
				SET @script_log_message = CONCAT('The component: '
					, (SELECT IFNULL(@component_id_this_role, 'component_id_this_role is NULL'))
					, ' (for the role_type_id #'
					, (SELECT IFNULL(@id_role_type, 'id_role_type is NULL'))
					, ') has been updated.'
					, '\r\The QA contact now associated to this role is the dummy bz user #'
					, (SELECT IFNULL(@bz_user_id_dummy_user_this_role, 'bz_user_id is NULL'))
					, ' (real name: '
					, (SELECT IFNULL(@dummy_user_pub_name, 'user_pub_name is NULL'))
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
				INSERT  INTO `audit_log`
					(`user_id`
					,`class`
					,`object_id`
					,`field`
					,`removed`
					,`added`
					,`at_time`
					) 
					VALUES 
					(@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'initialqacontact',@old_component_initialqacontact,@bz_user_id_dummy_user_this_role,@timestamp)
					;
				 
				# Cleanup the variables for the log messages
					SET @script_log_message = NULL;
		END IF;
		
		# Clean up the variable for the script and timestamp
			SET @script = NULL;
			SET @timestamp = NULL;
	END IF;
END $$
DELIMITER ;







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