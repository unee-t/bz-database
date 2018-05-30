# For any question about this script, ask Franck
#
###################################################################################
#
# WARNING! You HAVE TO use Amazon Aurora database engine for this version
#
###################################################################################
#
############################################
#
# Make sure to update the below variable(s)
#
############################################

#
# What are the version of the Unee-T BZ Database schema BEFORE and AFTER this update?
	SET @old_schema_version = 'v3.7.0';
	SET @new_schema_version = 'v3.7.1';
	SET @this_script = 'upgrade_unee-t_v3.7.0_to_v3.7.1.sql';
#
###############################
#
# We have everything we need
#
###############################
# This update 
#	- disable the call to the Lambda procedure in the Prod environment
#

# When are we doing this?
	SET @the_timestamp = NOW();

# Disable the trigger to call the lambda procedure each time a new notification is needed
# We are modifying the trigger that update the table 'ut_notification_messages_cases' to add the lambda call there

# We then create the trigger when a case is created

DROP TRIGGER IF EXISTS `ut_prepare_message_new_case`;

DELIMITER $$
CREATE TRIGGER `ut_prepare_message_new_case`
AFTER INSERT ON `bugs`
FOR EACH ROW
BEGIN
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
END;
$$
DELIMITER ;

# We then disable the trigger when a case is updated

DROP TRIGGER IF EXISTS `ut_prepare_message_case_activity`;

DELIMITER $$
CREATE TRIGGER `ut_prepare_message_case_activity`
AFTER INSERT ON `bugs_activity`
FOR EACH ROW
BEGIN
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
END;
$$
DELIMITER ;

# We then disable the trigger when a new message is added

DROP TRIGGER IF EXISTS `ut_prepare_message_new_comment`;

DELIMITER $$
CREATE TRIGGER `ut_prepare_message_new_comment`
AFTER INSERT ON `longdescs`
FOR EACH ROW
BEGIN
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