# For any question about this script, ask Franck
#
###################################################################################
#
# WARNING! 
#	- It is MANDATORY to use Amazon Aurora database engine for this version
#
# Make sure to also update the below variable(s)
#
###################################################################################
#
# What are the version of the Unee-T BZ Database schema BEFORE and AFTER this update?
	SET @old_schema_version = 'v3.16';
	SET @new_schema_version = 'v3.17';
#
# What is the name of this script?
	SET @this_script = 'upgrade_unee-t_v3.16_to_v3.17.sql';
#
###############################
#
# We have everything we need
#
###############################
# This update
#
#	- Fix the issue we have when we try to process invitation to user in a role for a unit
#		- Remove the constraint that te BZ bug id must exist in the table `ut_invitation_api_data`.
#
#	- When there is no invited user, the messages are empty.
#	  Make sure that is the list of invitee is NULL then we include 0 in the payload
#
#	- When we send a notification of a new message, the message is properly truncated and has the right format
#
#	  Alters the triggers :
#		- `ut_prepare_message_case_activity` make sure `current_list_of_invitees` is not NULL
#		- `ut_prepare_message_case_assigned_updated` make sure `current_list_of_invitees` is not NULL
#		- `ut_prepare_message_case_invited` make sure `current_list_of_invitees` is not NULL
#		- `ut_notification_classify_messages` make sure `current_list_of_invitees` is not NULL
#			- The message is 
#				- converted to CHAR
#				- without all the return charriot/go to next line characters
#				- Properly truncated
#			- Make sure `current_list_of_invitees` is not NULL
				
# When are we doing this?
	SET @the_timestamp = NOW();

# Alter the a table `ut_invitation_api_data` 
#	- remove reference to the FK for the case number so that case number can be NULL or 0

	ALTER TABLE `ut_invitation_api_data` 
	DROP FOREIGN KEY `invitation_bz_bug_must_exist`  ;
			
# Alter the trigger `ut_prepare_message_case_activity`: make sure `current_list_of_invitees` is not NULL

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
		SET @current_list_of_invitees_1 = NULL;
		SET @current_list_of_invitees = NULL;

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
		SET @current_list_of_invitees_1 = (SELECT GROUP_CONCAT(DISTINCT `who` ORDER BY `who` SEPARATOR ', ')
			FROM `cc`
			WHERE `bug_id` = @case_id
			GROUP BY `bug_id`)
			;
		SET @current_list_of_invitees = IFNULL(@current_list_of_invitees_1, 0);
	
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
			, `current_list_of_invitees`
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
			, @current_list_of_invitees
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
			, @current_list_of_invitees
			)
			;
END;
$$
DELIMITER ;

# Alter the trigger `ut_prepare_message_case_assigned_updated`: make sure `current_list_of_invitees` is not NULL

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
			SET @current_list_of_invitees_1 = NULL;
			SET @current_list_of_invitees = NULL;

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
			SET @current_list_of_invitees_1 = (SELECT GROUP_CONCAT(DISTINCT `who` ORDER BY `who` SEPARATOR ', ')
			FROM `cc`
			WHERE `bug_id` = @case_id
			GROUP BY `bug_id`)
			;
			SET @current_list_of_invitees = IFNULL(@current_list_of_invitees_1, 0);
		
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
				, `current_list_of_invitees`
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
				, @current_list_of_invitees
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
				, @current_list_of_invitees
				)
				;
	END IF;
END;
$$
DELIMITER ;

# Alter the trigger `ut_prepare_message_case_invited`: make sure `current_list_of_invitees` is not NULL

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
			)
			;
END;
$$
DELIMITER ;		

# Change the trigger `ut_notification_classify_messages` so that we are sure this is
#	- The message is 
#		- converted to CHAR
#		- without all the return charriot/go to next line characters
#		- Properly truncated
#	- Make sure `current_list_of_invitees` is not NULL

	DROP TRIGGER `ut_notification_classify_messages`;

DELIMITER $$

CREATE
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