# This update allows us to use lambda to automate certain processes
# - Receive information when an invitation is created
# - send notifications out to make sure other part of Unee-T work correctly.
#
# This update also create several procedures and triggers to automate several tasks:
#	- Invite new users
#	- Record changes to a bug/case
#
#################################################################################
#
# WARNING! You MUST use Amazon Aurora database engine for this version to work!!!
#
#################################################################################

# We need to make the table InnoDB to be Aurora Compatible:
	ALTER TABLE `bugs_fulltext` ENGINE=InnoDB; 

# We need to udpate the table 'ut_invitation_api_data' to make sure that the key 'mefe_invitation_id' is UNIQUE
	/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

	/* Alter table in target */
	ALTER TABLE `ut_invitation_api_data` 
		ADD UNIQUE KEY `MEFE_INVITATION_ID`(`mefe_invitation_id`) ;

	/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;

# We create a new table 'ut_notification_messages_cases' which captures the notification information about cases.

	/*!40101 SET NAMES utf8 */;

	/*!40101 SET SQL_MODE=''*/;

	/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
	/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
	/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
	/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
	/*Table structure for table `ut_notification_messages_cases` */

	DROP TABLE IF EXISTS `ut_notification_messages_cases`;

	CREATE TABLE `ut_notification_messages_cases` (
	  `notification_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Id in this table',
	  `created_datetime` DATETIME DEFAULT NULL COMMENT 'Timestamp when this was created',
	  `processed_datetime` DATETIME DEFAULT NULL COMMENT 'Timestamp when this notification was processed',
	  `unit_id` SMALLINT(6) DEFAULT NULL COMMENT 'Unit ID - a FK to the BZ table ''products''',
	  `case_id` MEDIUMINT(9) DEFAULT NULL COMMENT 'Case ID - a FK to the BZ table ''bugs''',
	  `user_id` MEDIUMINT(9) DEFAULT NULL COMMENT 'User ID - The user who needs to be notified - a FK to the BZ table ''profiles''',
	  `update_what` VARCHAR(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'The field that was updated',
	  PRIMARY KEY (`notification_id`)
	) ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

	/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
	/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
	/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
	/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

# We create triggers which update the `ut_notification_messages_cases` table 
# each time a change is made to a case

# First we drop the triggers in case they already exist

DROP TRIGGER IF EXISTS `ut_prepare_message_new_case`;
DROP TRIGGER IF EXISTS `ut_prepare_message_case_activity`;
DROP TRIGGER IF EXISTS `ut_prepare_message_new_comment`;

# We then create the trigger when a case is created
DELIMITER $$
CREATE TRIGGER `ut_prepare_message_new_case`
AFTER INSERT ON `bugs`
FOR EACH ROW
BEGIN
	SET @unit_id = NEW.`product_id`;
	SET @case_id = NEW.`bug_id`;
	SET @user_id = NEW.`reporter`;
	SET @update_what = 'New Case';
	INSERT INTO `ut_notification_messages_cases`
		(`created_datetime`
		, `unit_id`
		, `case_id`
		, `user_id`
		, `update_what`
		)
		VALUES
		(NOW()
		, @unit_id
		, @case_id
		, @user_id
		, @update_what
		)
		;
END;
$$
DELIMITER ;

# We then create the trigger when a case is updated
DELIMITER $$
CREATE TRIGGER `ut_prepare_message_case_activity`
AFTER INSERT ON `bugs_activity`
FOR EACH ROW
BEGIN
	SET @unit_id = (SELECT `product_id` FROM `bugs` WHERE `bug_id` = NEW.`bug_id`);
	SET @case_id = NEW.`bug_id`;
	SET @user_id = NEW.`who`;
	SET @update_what = (SELECT `description` FROM `fielddefs` WHERE `id` = NEW.`fieldid`);
	INSERT INTO `ut_notification_messages_cases`
		(`created_datetime`
		, `unit_id`
		, `case_id`
		, `user_id`
		, `update_what`
		)
		VALUES
		(NOW()
		, @unit_id
		, @case_id
		, @user_id
		, @update_what
		)
		;
END;
$$
DELIMITER ;

# We then create the trigger when a new message is added
DELIMITER $$
CREATE TRIGGER `ut_prepare_message_new_comment`
AFTER INSERT ON `longdescs`
FOR EACH ROW
BEGIN
	SET @unit_id = (SELECT `product_id` FROM `bugs` WHERE `bug_id` = NEW.`bug_id`);
	SET @case_id = NEW.`bug_id`;
	SET @user_id = NEW.`who`;
	SET @update_what = 'New Message';
	INSERT INTO `ut_notification_messages_cases`
		(`created_datetime`
		, `unit_id`
		, `case_id`
		, `user_id`
		, `update_what`
		)
		VALUES
		(NOW()
		, @unit_id
		, @case_id
		, @user_id
		, @update_what
		)
		;
END;
$$
DELIMITER ;

# We add a call to Lambda function - This is a test at this stage
DROP PROCEDURE IF EXISTS `lambda_notification_change_in_case`;

DELIMITER $$
CREATE PROCEDURE `lambda_notification_change_in_case` (IN ItemID VARCHAR(255)
	, IN notification_id INT(11)
	, IN created_datetime DATETIME
	, IN processed_datetime DATETIME
	, IN unit_id SMALLINT(6)
	, IN case_id MEDIUMINT(9)
	, IN user_id MEDIUMINT(9)
	, IN update_what  VARCHAR(255)
        ) LANGUAGE SQL
BEGIN






END;
$$
DELIMITER ;