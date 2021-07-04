# For any question about this script, ask Franck
# this script is valid for the BZ database schema v3.17
#
# This script is used to simulate lambda calls in a local environment
# it will:
#	- create a specific table `ut_local_dev_lambda_calls`
#	- replace the procedures that rely on Lambda functions with procedure that will write the lambda JSON 
#	  in the table `ut_local_dev_lambda_calls` instead.
#

# Create the table `ut_local_dev_lambda_calls`

	DROP TABLE IF EXISTS `ut_local_dev_lambda_calls`;
	
	CREATE TABLE `ut_local_dev_lambda_calls`(
	`notification_type` varchar(255) COLLATE utf8_general_ci NOT NULL, 
	`json_payload` text COLLATE utf8_general_ci NULL, 
	KEY `notification_type_must_exist`(`notification_type`), 
	CONSTRAINT `notification_type_must_exist` 
	FOREIGN KEY (`notification_type`) REFERENCES `ut_notification_types` (`notification_type`) 
	) ENGINE=InnoDB DEFAULT CHARSET='utf8' COLLATE='utf8_general_ci' ROW_FORMAT=Dynamic
	;

# For local environments: replace the lambda to notify when new comment

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
	INSERT INTO `ut_local_dev_lambda_calls`
		(`notification_type`
		, `json_payload`
		)
		VALUES 
		(`case_new_message`
		, (CONCAT('arn:aws:lambda:xxxxxx')
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
		)
		;
END $$
DELIMITER ;

# For local environments: replace the lambda to notify when case assignee is updated

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
	, IN current_list_of_invitees mediumtext
	)
	LANGUAGE SQL
SQL SECURITY INVOKER
BEGIN
	INSERT INTO `ut_local_dev_lambda_calls`
		(`notification_type`
		, `json_payload`
		)
		VALUES 
		(`case_assignee_updated`
		, (CONCAT('arn:aws:lambda:xxxxxx')
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
				, '", "current_list_of_invitees" : "', current_list_of_invitees
				, '"}'
				)
			)
		)
		;
END $$
DELIMITER ;

# For local environments: replace the lambda to notify when a user is invited

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
	)
	LANGUAGE SQL
SQL SECURITY INVOKER
BEGIN
	INSERT INTO `ut_local_dev_lambda_calls`
		(`notification_type`
		, `json_payload`
		)
		VALUES 
		(`case_user_invited`
		, (CONCAT('arn:aws:lambda:xxxxxx')
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
				, '"}'
				)
			)
		)
		;
END $$
DELIMITER ;

# For local environments: replace the lambda to notify when new case is updated

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
	, IN current_list_of_invitees mediumtext
	)
	LANGUAGE SQL
SQL SECURITY INVOKER
BEGIN
	INSERT INTO `ut_local_dev_lambda_calls`
		(`notification_type`
		, `json_payload`
		)
		VALUES 
		(`case_updated`
		, (CONCAT('arn:aws:lambda:xxxxxx')
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
				, '", "current_list_of_invitees" : "', current_list_of_invitees
				, '"}'
				)
			)
		)
		;
END $$
DELIMITER ;

# For local environments: replace the lambda to notify when new case is created

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
	INSERT INTO `ut_local_dev_lambda_calls`
		(`notification_type`
		, `json_payload`
		)
		VALUES 
		(`case_new`
		, (CONCAT('arn:aws:lambda:xxxxxx')
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
		)
		;
END $$
DELIMITER ;