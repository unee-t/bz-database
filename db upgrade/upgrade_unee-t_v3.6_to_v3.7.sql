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
# What it is the current environment?
# Environment: Which environment are you creating the unit in?
#	- 1 is for the DEV/Staging
#	- 2 is for the prod environment
#	- 3 is for the Demo environment
	SET @environment = '2';

# We create a procedure that will call the lambda function for message notification.
# IMPORTANT!! make sure that the variable for the Lambda is correct for each environement

DROP PROCEDURE IF EXISTS `lambda_notification_case_event`;
	
DELIMITER $$
CREATE PROCEDURE `lambda_notification_case_event`(
	IN notification_id int(11)
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
	CALL mysql.lambda_async(CONCAT('arn:aws:lambda:ap-southeast-1:812644853088:function:alambda_simple')
		, CONCAT ('{ '
			, '"notification_id": "', notification_id
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

#
# What are the version of the Unee-T BZ Database schema BEFORE and AFTER this update?
	SET @old_schema_version = 'v3.6';
	SET @new_schema_version = 'v3.7';
	SET @this_script = 'upgrade_unee-t_v3.6_to_v3.7.sql';
#
###############################
#
# We have everything we need
#
###############################
# This update 
#	- Create a procedure `table_to_list_dummy_user_by_environment` to create the dummy environment table
#	- Create a procedure `capture_id_dummy_user` to capture the id of the dummy user for each environment
#	- Create the procedure which will udpdate the view `list_changes_new_assignee_is_real` depending on the environment variable.
#	- We create a procedure `lambda_notification_case_event` which will call the lambda function for message notification.
#	- Update the triggers when a case is updated so that we can have the notifications working When:
#		- A new case is created
#		- Any field in a case is updated
#		- A new message is added to a case
# 	- Call the procedure udpdate the view `list_changes_new_assignee_is_real` depending on the environment variable.
#	- Update the table `ut_db_schema_version` to record the current version of the database
#

# When are we doing this?
	SET @the_timestamp = NOW();

# Create a procedure to create the dummy environment table
	
DROP PROCEDURE IF EXISTS `table_to_list_dummy_user_by_environment`;

DELIMITER $$
CREATE PROCEDURE `table_to_list_dummy_user_by_environment`()
SQL SECURITY INVOKER
BEGIN

	# We create a temporary table to record the ids of the dummy users in each environments:
		/*Table structure for table `ut_temp_dummy_users_for_roles` */
			DROP TABLE IF EXISTS `ut_temp_dummy_users_for_roles`;

			CREATE TABLE `ut_temp_dummy_users_for_roles` (
			  `environment_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Id of the environment',
			  `environment_name` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
			  `tenant_id` int(11) NOT NULL,
			  `landlord_id` int(11) NOT NULL,
			  `contractor_id` int(11) NOT NULL,
			  `mgt_cny_id` int(11) NOT NULL,
			  `agent_id` int(11) DEFAULT NULL,
			  PRIMARY KEY (`environment_id`)
			) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

		/*Data for the table `ut_temp_dummy_users_for_roles` */
			INSERT INTO `ut_temp_dummy_users_for_roles`(`environment_id`,`environment_name`,`tenant_id`,`landlord_id`,`contractor_id`,`mgt_cny_id`,`agent_id`) values 
				(1,'DEV/Staging',96,94,93,95,92),
				(2,'Prod',93,91,90,92,89),
				(3,'demo/dev',4,3,5,6,2);

END $$
DELIMITER ;
				
# Create a procedure to capture the id of the dummy user for each environment	
	
DROP PROCEDURE IF EXISTS `capture_id_dummy_user`;

DELIMITER $$
CREATE PROCEDURE `capture_id_dummy_user`()
SQL SECURITY INVOKER
BEGIN
	
	# What is the default dummy user id for this environment?
	# This procedure needs the following objects:
	#	- Table `ut_temp_dummy_users_for_roles`
	#	- @environment
	#
	# This procedure will return the following variables:
	#	- @bz_user_id_dummy_tenant
	#	- @bz_user_id_dummy_landlord
	#	- @bz_user_id_dummy_contractor
	#	- @bz_user_id_dummy_mgt_cny
	#	- @bz_user_id_dummy_agent
	
		# Get the BZ profile id of the dummy users based on the environment variable
			# Tenant 1
				SET @bz_user_id_dummy_tenant = (SELECT `tenant_id` 
											FROM `ut_temp_dummy_users_for_roles` 
											WHERE `environment_id` = @environment)
											;
				# Landlord 2
				SET @bz_user_id_dummy_landlord = (SELECT `landlord_id` 
											FROM `ut_temp_dummy_users_for_roles` 
											WHERE `environment_id` = @environment)
											;
				
			# Contractor 3
				SET @bz_user_id_dummy_contractor = (SELECT `contractor_id` 
											FROM `ut_temp_dummy_users_for_roles` 
											WHERE `environment_id` = @environment)
											;
				
			# Management company 4
				SET @bz_user_id_dummy_mgt_cny = (SELECT `mgt_cny_id` 
											FROM `ut_temp_dummy_users_for_roles` 
											WHERE `environment_id` = @environment)
											;
				
			# Agent 5
				SET @bz_user_id_dummy_agent = (SELECT `agent_id` 
											FROM `ut_temp_dummy_users_for_roles` 
											WHERE `environment_id` = @environment)
											;

END $$
DELIMITER ;	
	
# Create the procedure which will udpdate the view `list_changes_new_assignee_is_real` depending on the environment variable

DROP PROCEDURE IF EXISTS `update_list_changes_new_assignee_is_real`;

DELIMITER $$
CREATE PROCEDURE `update_list_changes_new_assignee_is_real`()
SQL SECURITY INVOKER
BEGIN

# This procedure Needs the following objects:
#	- @environment
#
			
# Create the view to list all the changes from the audit log when we replaced the dummy tenant with a real user
# This version of the script uses the values for the PROD Environment (everything except 1 or 2 this is in case the environment variabel is omitted)
#
	DROP VIEW IF EXISTS `list_changes_new_assignee_is_real`;
	
	IF @environment = '1'
		THEN
		# We are in the DEV/Staging environment
		# Create the view to list all the changes from the audit log when we replaced the dummy tenant with a real user
		# We use the values for the DEV/Staging environment (1)		
		CREATE VIEW `list_changes_new_assignee_is_real`
			AS
				SELECT `ut_product_group`.`product_id`
					, `audit_log`.`object_id` AS `component_id`
					, `audit_log`.`removed`
					, `audit_log`.`added`
					, `audit_log`.`at_time`
					, `ut_product_group`.`role_type_id`
					FROM `audit_log`
						INNER JOIN `ut_product_group` 
						ON (`audit_log`.`object_id` = `ut_product_group`.`component_id`)
					# If we add one of the BZ user who is NOT a dummy user, then it is a REAL user
					WHERE (`class` = 'Bugzilla::Component'
						AND `field` = 'initialowner'
						AND 
						# The new initial owner is NOT the dummy tenant?
						`audit_log`.`added` <> 96
						AND 
						# The new initial owner is NOT the dummy landlord?
						`audit_log`.`added` <> 94
						AND 				
						# The new initial owner is NOT the dummy contractor?
						`audit_log`.`added` <> 93
						AND 
						# The new initial owner is NOT the dummy Mgt Cny?
						`audit_log`.`added` <> 95
						AND 
						# The new initial owner is NOT the dummy agent?
						`audit_log`.`added` <> 92
						)
					GROUP BY `audit_log`.`object_id`
						, `ut_product_group`.`role_type_id`
					ORDER BY `audit_log`.`at_time` DESC
						, `ut_product_group`.`product_id` ASC
						, `audit_log`.`object_id` ASC
					;
		ELSEIF @environment = '2'
			THEN
			# We are in the Prod environment
			# Create the view to list all the changes from the audit log when we replaced the dummy tenant with a real user
			# We use the values for the Prod environment (2)
			#
			CREATE VIEW `list_changes_new_assignee_is_real`
				AS
					SELECT `ut_product_group`.`product_id`
						, `audit_log`.`object_id` AS `component_id`
						, `audit_log`.`removed`
						, `audit_log`.`added`
						, `audit_log`.`at_time`
						, `ut_product_group`.`role_type_id`
						FROM `audit_log`
							INNER JOIN `ut_product_group` 
							ON (`audit_log`.`object_id` = `ut_product_group`.`component_id`)
						# If we add one of the BZ user who is NOT a dummy user, then it is a REAL user
						WHERE (`class` = 'Bugzilla::Component'
							AND `field` = 'initialowner'
							AND 
							# The new initial owner is NOT the dummy tenant?
							`audit_log`.`added` <> 93
							AND 
							# The new initial owner is NOT the dummy landlord?
							`audit_log`.`added` <> 91
							AND 				
							# The new initial owner is NOT the dummy contractor?
							`audit_log`.`added` <> 90
							AND 
							# The new initial owner is NOT the dummy Mgt Cny?
							`audit_log`.`added` <> 92
							AND 
							# The new initial owner is NOT the dummy agent?
							`audit_log`.`added` <> 89
							)
						GROUP BY `audit_log`.`object_id`
							, `ut_product_group`.`role_type_id`
						ORDER BY `audit_log`.`at_time` DESC
							, `ut_product_group`.`product_id` ASC
							, `audit_log`.`object_id` ASC
						;
		ELSEIF @environment = '3'
			THEN
			# We are in the DEMO environment
			# Create the view to list all the changes from the audit log when we replaced the dummy tenant with a real user
			# We use the values for the DEMO Environment (3)
			#
			CREATE VIEW `list_changes_new_assignee_is_real`
				AS
					SELECT `ut_product_group`.`product_id`
						, `audit_log`.`object_id` AS `component_id`
						, `audit_log`.`removed`
						, `audit_log`.`added`
						, `audit_log`.`at_time`
						, `ut_product_group`.`role_type_id`
						FROM `audit_log`
							INNER JOIN `ut_product_group` 
							ON (`audit_log`.`object_id` = `ut_product_group`.`component_id`)
						# If we add one of the BZ user who is NOT a dummy user, then it is a REAL user
						WHERE (`class` = 'Bugzilla::Component'
							AND `field` = 'initialowner'
							AND 
							# The new initial owner is NOT the dummy tenant?
							`audit_log`.`added` <> 4
							AND 
							# The new initial owner is NOT the dummy landlord?
							`audit_log`.`added` <> 3
							AND 				
							# The new initial owner is NOT the dummy contractor?
							`audit_log`.`added` <> 5
							AND 
							# The new initial owner is NOT the dummy Mgt Cny?
							`audit_log`.`added` <> 6
							AND 
							# The new initial owner is NOT the dummy agent?
							`audit_log`.`added` <> 2
							)
						GROUP BY `audit_log`.`object_id`
							, `ut_product_group`.`role_type_id`
						ORDER BY `audit_log`.`at_time` DESC
							, `ut_product_group`.`product_id` ASC
							, `audit_log`.`object_id` ASC
						;
    END IF;
END $$
DELIMITER ;

# Create the trigger to call the lambda procedure each time a new notification is needed
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
	
	# We call the Lambda procedure to notify of the change
	CALL `lambda_notification_case_event`(@notification_id
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

# We then create the trigger when a case is updated

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
	
	# We call the Lambda procedure to notify of the change
	CALL `lambda_notification_case_event`(@notification_id
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

# We then create the trigger when a new message is added

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

	# We call the Lambda procedure to notify of the change
	CALL `lambda_notification_case_event`(@notification_id
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

#Clean up
		
	# We Delete the temp table as we do not need it anymore
		DROP TABLE IF EXISTS `ut_temp_dummy_users_for_roles`;

# We Call the procedure to update the view to list the changes in default assignees

	CALL `update_list_changes_new_assignee_is_real`;

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