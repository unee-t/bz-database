/* Trigger structure for table `bugs` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `ut_prepare_message_new_case` $$

CREATE TRIGGER `ut_prepare_message_new_case` AFTER INSERT ON `bugs` FOR EACH ROW 
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
END $$


DELIMITER ;

/* Trigger structure for table `bugs` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `update_the_log_of_closed_cases` $$

CREATE TRIGGER `update_the_log_of_closed_cases` AFTER UPDATE ON `bugs` FOR EACH ROW 
  BEGIN
    IF NEW.`bug_status` <> OLD.`bug_status` 
		THEN
		# Capture the new bug status
			SET @new_bug_status = NEW.`bug_status`;
			SET @old_bug_status = OLD.`bug_status`;
		
		# Check if the new bug status is open
			SET @new_is_open = (SELECT `is_open` FROM `bug_status` WHERE `value` = @new_bug_status);
			
		# Check if the old bug status is open
			SET @old_is_open = (SELECT `is_open` FROM `bug_status` WHERE `value` = @old_bug_status);
			
		# If these are different, then we need to update the log of closed cases
			IF @new_is_open != @old_is_open
				THEN
				CALL `update_log_count_closed_case`;
			END IF;
    END IF;
END $$


DELIMITER ;

/* Trigger structure for table `bugs` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `ut_prepare_message_case_assigned_updated` $$

CREATE TRIGGER `ut_prepare_message_case_assigned_updated` AFTER UPDATE ON `bugs` FOR EACH ROW 
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
END $$


DELIMITER ;

/* Trigger structure for table `bugs_activity` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `ut_prepare_message_case_activity` $$

CREATE TRIGGER `ut_prepare_message_case_activity` AFTER INSERT ON `bugs_activity` FOR EACH ROW 
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
END $$


DELIMITER ;

/* Trigger structure for table `cc` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `ut_prepare_message_case_invited` $$

CREATE TRIGGER `ut_prepare_message_case_invited` AFTER INSERT ON `cc` FOR EACH ROW 
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
END $$


DELIMITER ;

/* Trigger structure for table `component_cc` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_new_record_component_cc` $$

CREATE TRIGGER `trig_update_audit_log_new_record_component_cc` AFTER INSERT ON `component_cc` FOR EACH ROW 
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_user_id = new.user_id;
        SET @new_component_id = new.component_id;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'component_cc';
        SET @bzfe_field = 'user_id, component_id';
        SET @previous_value = NULL;
        SET @new_value = CONCAT (
                @new_user_id
                , ', '
                , @new_component_id
            )
           ;
        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_new_record_component_cc';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;

/* Trigger structure for table `component_cc` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_update_record_component_cc` $$

CREATE TRIGGER `trig_update_audit_log_update_record_component_cc` AFTER UPDATE ON `component_cc` FOR EACH ROW 
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_user_id = new.user_id;
        SET @new_component_id = new.component_id;

    # We capture the old values of each fields in dedicated variables:
        SET @old_user_id = old.user_id;
        SET @old_component_id = old.component_id;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'component_cc';
        SET @bzfe_field = 'id, name, description, isbuggroup, userregexp, isactive, icon_url';
        SET @previous_value = CONCAT (
                @old_user_id
                , ', '
                , @old_component_id
            )
           ;
        SET @new_value = CONCAT (
                @new_user_id
                , ', '
                , @new_component_id
            )
           ;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_update_record_component_cc';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;

/* Trigger structure for table `component_cc` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_delete_record_component_cc` $$

CREATE TRIGGER `trig_update_audit_log_delete_record_component_cc` AFTER DELETE ON `component_cc` FOR EACH ROW 
  BEGIN

    # We capture the old values of each fields in dedicated variables:
        SET @old_user_id = old.user_id;
        SET @old_component_id = old.component_id;
        
    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'component_cc';
        SET @bzfe_field = 'user_id, component_id';
        SET @previous_value = CONCAT (
                 @old_user_id
                , ', '
                , @old_component_id
            )
           ;
        SET @new_value = NULL;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_delete_record_component_cc';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;

/* Trigger structure for table `components` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_new_record_components` $$

CREATE TRIGGER `trig_update_audit_log_new_record_components` AFTER INSERT ON `components` FOR EACH ROW 
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_id = new.id;
        SET @new_name = new.name;
        SET @new_product_id = new.product_id;
        SET @new_initialowner = new.initialowner;
        SET @new_initialqacontact = new.initialqacontact;
        SET @new_description = new.description;
        SET @new_isactive = new.isactive;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'components';
        SET @bzfe_field = 'id, name, product_id, initialowner, initialqacontact, description, isactive';
        SET @previous_value = NULL;
        SET @new_value = CONCAT (
                @new_id
                , ', '
                , @new_name
                , ', '
                , @new_product_id
                , ', '
                , @new_initialowner
                , ', '
                , IFNULL(@new_initialqacontact, '(NULL)')
                , ', '
                , @new_description
                , ', '
                , @new_isactive
            )
           ;
        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_new_record_components';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;

/* Trigger structure for table `components` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_update_record_components` $$

CREATE TRIGGER `trig_update_audit_log_update_record_components` AFTER UPDATE ON `components` FOR EACH ROW 
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_id = new.id;
        SET @new_name = new.name;
        SET @new_product_id = new.product_id;
        SET @new_initialowner = new.initialowner;
        SET @new_initialqacontact = new.initialqacontact;
        SET @new_description = new.description;
        SET @new_isactive = new.isactive;

    # We capture the old values of each fields in dedicated variables:
        SET @old_id = old.id;
        SET @old_name = old.name;
        SET @old_product_id = old.product_id;
        SET @old_initialowner = old.initialowner;
        SET @old_initialqacontact = old.initialqacontact;
        SET @old_description = old.description;
        SET @old_isactive = old.isactive;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'components';
        SET @bzfe_field = 'id, name, product_id, initialowner, initialqacontact, description, isactive';
        SET @previous_value = CONCAT (
                @old_id
                , ', '
                , @old_name
                , ', '
                , @old_product_id
                , ', '
                , @old_initialowner
                , ', '
                , IFNULL(@old_initialqacontact, '(NULL)')
                , ', '
                , @old_description
                , ', '
                , @old_isactive
            )
           ;
        SET @new_value = CONCAT (
                @new_id
                , ', '
                , @new_name
                , ', '
                , @new_product_id
                , ', '
                , @new_initialowner
                , ', '
                , IFNULL(@new_initialqacontact, '(NULL)')
                , ', '
                , @new_description
                , ', '
                , @new_isactive
            )
           ;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_update_record_components';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;

/* Trigger structure for table `components` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_delete_record_components` $$

CREATE TRIGGER `trig_update_audit_log_delete_record_components` AFTER DELETE ON `components` FOR EACH ROW 
  BEGIN

    # We capture the old values of each fields in dedicated variables:
        SET @old_id = old.id;
        SET @old_name = old.name;
        SET @old_product_id = old.product_id;
        SET @old_initialowner = old.initialowner;
        SET @old_initialqacontact = old.initialqacontact;
        SET @old_description = old.description;
        SET @old_isactive = old.isactive;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'components';
        SET @bzfe_field = 'id, name, product_id, initialowner, initialqacontact, description, isactive';
        SET @previous_value = CONCAT (
                @old_id
                , ', '
                , @old_name
                , ', '
                , @old_product_id
                , ', '
                , @old_initialowner
                , ', '
                , IFNULL(@old_initialqacontact, '(NULL)')
                , ', '
                , @old_description
                , ', '
                , @old_isactive
            )
           ;
        SET @new_value = NULL;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_delete_record_components';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;

/* Trigger structure for table `flaginclusions` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_new_record_flaginclusions` $$

CREATE TRIGGER `trig_update_audit_log_new_record_flaginclusions` AFTER INSERT ON `flaginclusions` FOR EACH ROW 
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_type_id = new.type_id;
        SET @new_product_id = new.product_id;
        SET @new_component_id = new.component_id;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'flaginclusions';
        SET @bzfe_field = 'type_id, product_id, component_id';
        SET @previous_value = NULL;
        SET @new_value = CONCAT (
                @new_type_id
                , ', '
                , IFNULL(@new_product_id, '(NULL)')
                , ', '
                , IFNULL(@new_component_id, '(NULL)')  
            )
           ;
        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_new_record_flaginclusions';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;

/* Trigger structure for table `flaginclusions` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_update_record_flaginclusions` $$

CREATE TRIGGER `trig_update_audit_log_update_record_flaginclusions` AFTER UPDATE ON `flaginclusions` FOR EACH ROW 
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_type_id = new.type_id;
        SET @new_product_id = new.product_id;
        SET @new_component_id = new.component_id;

    # We capture the old values of each fields in dedicated variables:
        SET @old_type_id = old.type_id;
        SET @old_product_id = old.product_id;
        SET @old_component_id = old.component_id;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'flaginclusions';
        SET @bzfe_field = 'type_id, product_id, component_id';
        SET @previous_value = CONCAT (
                @old_type_id
                , ', '
                , IFNULL(@old_product_id, '(NULL)')
                , ', '
                , IFNULL(@old_component_id, '(NULL)') 
            )
           ;
        SET @new_value = CONCAT (
                @new_type_id
                , ', '
                , IFNULL(@new_product_id, '(NULL)')
                , ', '
                , IFNULL(@new_component_id, '(NULL)')     
            )
           ;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_update_record_flaginclusions';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;

/* Trigger structure for table `flaginclusions` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_delete_record_flaginclusions` $$

CREATE TRIGGER `trig_update_audit_log_delete_record_flaginclusions` AFTER DELETE ON `flaginclusions` FOR EACH ROW 
  BEGIN

    # We capture the old values of each fields in dedicated variables:
        SET @old_type_id = old.type_id;
        SET @old_product_id = old.product_id;
        SET @old_component_id = old.component_id;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'flaginclusions';
        SET @bzfe_field = 'type_id, product_id, component_id';
        SET @previous_value = CONCAT (
                @old_type_id
                , ', '
                , IFNULL(@old_product_id, '(NULL)')
                , ', '
                , IFNULL(@old_component_id, '(NULL)') 
            )
           ;
        SET @new_value = NULL;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_delete_record_flaginclusions';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;

/* Trigger structure for table `flagtypes` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_new_record_flagtypes` $$

CREATE TRIGGER `trig_update_audit_log_new_record_flagtypes` AFTER INSERT ON `flagtypes` FOR EACH ROW 
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_id = new.id;
        SET @new_name = new.name;
        SET @new_description = new.description;
        SET @new_cc_list = new.cc_list;
        SET @new_target_type = new.target_type;
        SET @new_is_active = new.is_active;
        SET @new_is_requestable = new.is_requestable;
        SET @new_is_requesteeble = new.is_requesteeble;
        SET @new_is_multiplicable = new.is_multiplicable;
        SET @new_sortkey = new.sortkey;
        SET @new_grant_group_id = new.grant_group_id;
        SET @new_request_group_id = new.request_group_id;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'flagtypes';
        SET @bzfe_field = 'id, name, description, cc_list, target_type, is_active, is_requestable, is_requesteeble, is_multiplicable, sortkey, grant_group_id, request_group_id';
        SET @previous_value = NULL;
        SET @new_value = CONCAT (
                @new_id
                , ', '
                , @new_name
                , ', '
                , @new_description
                , ', '
                , IFNULL(@new_cc_list, '(NULL)')
                , ', '
                , @new_target_type
                , ', '
                , @new_is_active
                , ', '
                , @new_is_requestable
                , ', '
                , @new_is_requesteeble
                , ', '
                , @new_is_multiplicable
                , ', '
                , @new_sortkey
                , ', '
                , IFNULL(@new_grant_group_id, '(NULL)')
                , ', '
                , IFNULL(@new_request_group_id, '(NULL)')    
            )
           ;
        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_new_record_flagtypes';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;

/* Trigger structure for table `flagtypes` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_update_record_flagtypes` $$

CREATE TRIGGER `trig_update_audit_log_update_record_flagtypes` AFTER UPDATE ON `flagtypes` FOR EACH ROW 
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_id = new.id;
        SET @new_name = new.name;
        SET @new_description = new.description;
        SET @new_cc_list = new.cc_list;
        SET @new_target_type = new.target_type;
        SET @new_is_active = new.is_active;
        SET @new_is_requestable = new.is_requestable;
        SET @new_is_requesteeble = new.is_requesteeble;
        SET @new_is_multiplicable = new.is_multiplicable;
        SET @new_sortkey = new.sortkey;
        SET @new_grant_group_id = new.grant_group_id;
        SET @new_request_group_id = new.request_group_id;

    # We capture the old values of each fields in dedicated variables:
        SET @old_id = old.id;
        SET @old_name = old.name;
        SET @old_description = old.description;
        SET @old_cc_list = old.cc_list;
        SET @old_target_type = old.target_type;
        SET @old_is_active = old.is_active;
        SET @old_is_requestable = old.is_requestable;
        SET @old_is_requesteeble = old.is_requesteeble;
        SET @old_is_multiplicable = old.is_multiplicable;
        SET @old_sortkey = old.sortkey;
        SET @old_grant_group_id = old.grant_group_id;
        SET @old_request_group_id = old.request_group_id;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'flagtypes';
        SET @bzfe_field = 'id, name, description, cc_list, target_type, is_active, is_requestable, is_requesteeble, is_multiplicable, sortkey, grant_group_id, request_group_id';
        SET @previous_value = CONCAT (
                @new_id
                , ', '
                , @new_name
                , ', '
                , @new_description
                , ', '
                , IFNULL(@new_cc_list, '(NULL)')
                , ', '
                , @new_target_type
                , ', '
                , @new_is_active
                , ', '
                , @new_is_requestable
                , ', '
                , @new_is_requesteeble
                , ', '
                , @new_is_multiplicable
                , ', '
                , @new_sortkey
                , ', '
                , IFNULL(@new_grant_group_id, '(NULL)')
                , ', '
                , IFNULL(@new_request_group_id, '(NULL)')    
            )
           ;
        SET @new_value = CONCAT (
                @old_id
                , ', '
                , @old_name
                , ', '
                , @old_description
                , ', '
                , IFNULL(@old_cc_list, '(NULL)')
                , ', '
                , @old_target_type
                , ', '
                , @old_is_active
                , ', '
                , @old_is_requestable
                , ', '
                , @old_is_requesteeble
                , ', '
                , @old_is_multiplicable
                , ', '
                , @old_sortkey
                , ', '
                , IFNULL(@old_grant_group_id, '(NULL)')
                , ', '
                , IFNULL(@old_request_group_id, '(NULL)')    
            )
           ;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_update_record_flagtypes';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;

/* Trigger structure for table `flagtypes` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_delete_record_flagtypes` $$

CREATE TRIGGER `trig_update_audit_log_delete_record_flagtypes` AFTER DELETE ON `flagtypes` FOR EACH ROW 
  BEGIN

    # We capture the old values of each fields in dedicated variables:
        SET @old_id = old.id;
        SET @old_name = old.name;
        SET @old_description = old.description;
        SET @old_cc_list = old.cc_list;
        SET @old_target_type = old.target_type;
        SET @old_is_active = old.is_active;
        SET @old_is_requestable = old.is_requestable;
        SET @old_is_requesteeble = old.is_requesteeble;
        SET @old_is_multiplicable = old.is_multiplicable;
        SET @old_sortkey = old.sortkey;
        SET @old_grant_group_id = old.grant_group_id;
        SET @old_request_group_id = old.request_group_id;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'flagtypes';
        SET @bzfe_field = 'id, name, description, cc_list, target_type, is_active, is_requestable, is_requesteeble, is_multiplicable, sortkey, grant_group_id, request_group_id';
        SET @previous_value = CONCAT (
                @old_id
                , ', '
                , @old_name
                , ', '
                , @old_description
                , ', '
                , IFNULL(@old_cc_list, '(NULL)')
                , ', '
                , @old_target_type
                , ', '
                , @old_is_active
                , ', '
                , @old_is_requestable
                , ', '
                , @old_is_requesteeble
                , ', '
                , @old_is_multiplicable
                , ', '
                , @old_sortkey
                , ', '
                , IFNULL(@old_grant_group_id, '(NULL)')
                , ', '
                , IFNULL(@old_request_group_id, '(NULL)')  
            )
           ;
        SET @new_value = NULL;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_delete_record_flagtypes';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;

/* Trigger structure for table `group_control_map` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_new_record_group_control_map` $$

CREATE TRIGGER `trig_update_audit_log_new_record_group_control_map` AFTER INSERT ON `group_control_map` FOR EACH ROW 
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_group_id = new.group_id;
        SET @new_product_id = new.product_id;
        SET @new_entry = new.entry;
        SET @new_membercontrol = new.membercontrol;
        SET @new_othercontrol = new.othercontrol;
        SET @new_canedit = new.canedit;
        SET @new_editcomponents = new.editcomponents;
        SET @new_editbugs = new.editbugs;
        SET @new_canconfirm = new.canconfirm;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'group_control_map';
        SET @bzfe_field = 'group_id, product_id, entry, membercontrol, othercontrol, canedit, editcomponents, editbugs, canconfirm';
        SET @previous_value = NULL;
        SET @new_value = CONCAT (
                @new_group_id
                , ', '
                , @new_product_id
                , ', '
                , @new_entry
                , ', '
                , @new_membercontrol
                , ', '
                , @new_othercontrol
                , ', '
                , @new_canedit
                , ', '
                , @new_editcomponents
                , ', '
                , @new_editbugs
                , ', '
                , @new_canconfirm
            )
           ;
        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_new_record_group_control_map';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;

/* Trigger structure for table `group_control_map` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_update_record_group_control_map` $$

CREATE TRIGGER `trig_update_audit_log_update_record_group_control_map` AFTER UPDATE ON `group_control_map` FOR EACH ROW 
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_group_id = new.group_id;
        SET @new_product_id = new.product_id;
        SET @new_entry = new.entry;
        SET @new_membercontrol = new.membercontrol;
        SET @new_othercontrol = new.othercontrol;
        SET @new_canedit = new.canedit;
        SET @new_editcomponents = new.editcomponents;
        SET @new_editbugs = new.editbugs;
        SET @new_canconfirm = new.canconfirm;

    # We capture the old values of each fields in dedicated variables:
        SET @old_group_id = old.group_id;
        SET @old_product_id = old.product_id;
        SET @old_entry = old.entry;
        SET @old_membercontrol = old.membercontrol;
        SET @old_othercontrol = old.othercontrol;
        SET @old_canedit = old.canedit;
        SET @old_editcomponents = old.editcomponents;
        SET @old_editbugs = old.editbugs;
        SET @old_canconfirm = old.canconfirm;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'group_control_map';
        SET @bzfe_field = 'group_id, product_id, entry, membercontrol, othercontrol, canedit, editcomponents, editbugs, canconfirm';
        SET @previous_value = CONCAT (
                @old_group_id
                , ', '
                , @old_product_id
                , ', '
                , @old_entry
                , ', '
                , @old_membercontrol
                , ', '
                , @old_othercontrol
                , ', '
                , @old_canedit
                , ', '
                , @old_editcomponents
                , ', '
                , @old_editbugs
                , ', '
                , @old_canconfirm
            )
           ;
        SET @new_value = CONCAT (
                @new_group_id
                , ', '
                , @new_product_id
                , ', '
                , @new_entry
                , ', '
                , @new_membercontrol
                , ', '
                , @new_othercontrol
                , ', '
                , @new_canedit
                , ', '
                , @new_editcomponents
                , ', '
                , @new_editbugs
                , ', '
                , @new_canconfirm
            )
           ;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_update_record_group_control_map';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;

/* Trigger structure for table `group_control_map` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_delete_record_group_control_map` $$

CREATE TRIGGER `trig_update_audit_log_delete_record_group_control_map` AFTER DELETE ON `group_control_map` FOR EACH ROW 
  BEGIN

    # We capture the old values of each fields in dedicated variables:
        SET @old_group_id = old.group_id;
        SET @old_product_id = old.product_id;
        SET @old_entry = old.entry;
        SET @old_membercontrol = old.membercontrol;
        SET @old_othercontrol = old.othercontrol;
        SET @old_canedit = old.canedit;
        SET @old_editcomponents = old.editcomponents;
        SET @old_editbugs = old.editbugs;
        SET @old_canconfirm = old.canconfirm;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'group_control_map';
        SET @bzfe_field = 'group_id, product_id, entry, membercontrol, othercontrol, canedit, editcomponents, editbugs, canconfirm';
        SET @previous_value = CONCAT (
                @old_group_id
                , ', '
                , @old_product_id
                , ', '
                , @old_entry
                , ', '
                , @old_membercontrol
                , ', '
                , @old_othercontrol
                , ', '
                , @old_canedit
                , ', '
                , @old_editcomponents
                , ', '
                , @old_editbugs
                , ', '
                , @old_canconfirm
            )
           ;
        SET @new_value = NULL;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_delete_record_group_control_map';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;

/* Trigger structure for table `group_group_map` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_new_record_group_group_map` $$

CREATE TRIGGER `trig_update_audit_log_new_record_group_group_map` AFTER INSERT ON `group_group_map` FOR EACH ROW 
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_member_id = new.member_id;
        SET @new_grantor_id = new.grantor_id;
        SET @new_grant_type = new.grant_type;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'group_group_map';
        SET @bzfe_field = 'member_id, grantor_id, grant_type';
        SET @previous_value = NULL;
        SET @new_value = CONCAT (
                @new_member_id
                , ', '
                , @new_grantor_id
                , ', '
                , @new_grant_type
            )
           ;
        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_new_record_group_group_map';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;

/* Trigger structure for table `group_group_map` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_update_record_group_group_map` $$

CREATE TRIGGER `trig_update_audit_log_update_record_group_group_map` AFTER UPDATE ON `group_group_map` FOR EACH ROW 
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_member_id = new.member_id;
        SET @new_grantor_id = new.grantor_id;
        SET @new_grant_type = new.grant_type;
        
    # We capture the old values of each fields in dedicated variables:
        SET @old_member_id = old.member_id;
        SET @old_grantor_id = old.grantor_id;
        SET @old_grant_type = old.grant_type;
        
    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'group_group_map';
        SET @bzfe_field = 'member_id, grantor_id, grant_type';
        SET @previous_value = CONCAT (
                @old_member_id
                , ', '
                , @old_grantor_id
                , ', '
                , @old_grant_type
            )
           ;
        SET @new_value = CONCAT (
                @new_member_id
                , ', '
                , @new_grantor_id
                , ', '
                , @new_grant_type
            )
           ;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_update_record_group_group_map';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;

/* Trigger structure for table `group_group_map` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_delete_record_group_group_map` $$

CREATE TRIGGER `trig_update_audit_log_delete_record_group_group_map` AFTER DELETE ON `group_group_map` FOR EACH ROW 
  BEGIN

    # We capture the old values of each fields in dedicated variables:
        SET @old_member_id = old.member_id;
        SET @old_grantor_id = old.grantor_id;
        SET @old_grant_type = old.grant_type;
        
    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'group_group_map';
        SET @bzfe_field = 'member_id, grantor_id, grant_type';
        SET @previous_value = CONCAT (
                @old_member_id
                , ', '
                , @old_grantor_id
                , ', '
                , @old_grant_type 
            )
           ;
        SET @new_value = NULL;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_delete_record_group_group_map';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;

/* Trigger structure for table `groups` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_new_record_groups` $$

CREATE TRIGGER `trig_update_audit_log_new_record_groups` AFTER INSERT ON `groups` FOR EACH ROW 
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_id = new.id;
        SET @new_name = new.name;
        SET @new_description = new.description;
        SET @new_isbuggroup = new.isbuggroup;
        SET @new_userregexp = new.userregexp;
        SET @new_isactive = new.isactive;
        SET @new_icon_url = new.icon_url;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'groups';
        SET @bzfe_field = 'id, name, description, isbuggroup, userregexp, isactive, icon_url';
        SET @previous_value = NULL;
        SET @new_value = CONCAT (
                @new_id
                , ', '
                , @new_name
                , ', '
                , @new_description
                , ', '
                , @new_isbuggroup
                , ', '
                , IFNULL(@new_userregexp, '(NULL)')
                , ', '
                , @new_isactive
                , ', '
                , IFNULL(@new_icon_url, '(NULL)')
            )
           ;
        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_new_record_groups';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;

/* Trigger structure for table `groups` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_update_record_groups` $$

CREATE TRIGGER `trig_update_audit_log_update_record_groups` AFTER UPDATE ON `groups` FOR EACH ROW 
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_id = new.id;
        SET @new_name = new.name;
        SET @new_description = new.description;
        SET @new_isbuggroup = new.isbuggroup;
        SET @new_userregexp = new.userregexp;
        SET @new_isactive = new.isactive;
        SET @new_icon_url = new.icon_url;

    # We capture the old values of each fields in dedicated variables:
        SET @old_id = old.id;
        SET @old_name = old.name;
        SET @old_description = old.description;
        SET @old_isbuggroup = old.isbuggroup;
        SET @old_userregexp = old.userregexp;
        SET @old_isactive = old.isactive;
        SET @old_icon_url = old.icon_url;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'groups';
        SET @bzfe_field = 'id, name, description, isbuggroup, userregexp, isactive, icon_url';
        SET @previous_value = CONCAT (
                @old_id
                , ', '
                , @old_name
                , ', '
                , @old_description
                , ', '
                , @old_isbuggroup
                , ', '
                , IFNULL(@old_userregexp, '(NULL)')
                , ', '
                , @old_isactive
                , ', '
                , IFNULL(@old_icon_url, '(NULL)')
            )
           ;
        SET @new_value = CONCAT (
                 @new_id
                , ', '
                , @new_name
                , ', '
                , @new_description
                , ', '
                , @new_isbuggroup
                , ', '
                , IFNULL(@new_userregexp, '(NULL)')
                , ', '
                , @new_isactive
                , ', '
                , IFNULL(@new_icon_url, '(NULL)')
            )
           ;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_update_record_groups';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;

/* Trigger structure for table `groups` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_delete_record_groups` $$

CREATE TRIGGER `trig_update_audit_log_delete_record_groups` AFTER DELETE ON `groups` FOR EACH ROW 
  BEGIN

    # We capture the old values of each fields in dedicated variables:
        SET @old_id = old.id;
        SET @old_name = old.name;
        SET @old_description = old.description;
        SET @old_isbuggroup = old.isbuggroup;
        SET @old_userregexp = old.userregexp;
        SET @old_isactive = old.isactive;
        SET @old_icon_url = old.icon_url;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'groups';
        SET @bzfe_field = 'id, name, description, isbuggroup, userregexp, isactive, icon_url';
        SET @previous_value = CONCAT (
                 @old_id
                , ', '
                , @old_name
                , ', '
                , @old_description
                , ', '
                , @old_isbuggroup
                , ', '
                , IFNULL(@old_userregexp, '(NULL)')
                , ', '
                , @old_isactive
                , ', '
                , IFNULL(@old_icon_url, '(NULL)')
            )
           ;
        SET @new_value = NULL;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_delete_record_groups';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;

/* Trigger structure for table `longdescs` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `ut_notification_classify_messages` $$

CREATE TRIGGER `ut_notification_classify_messages` AFTER INSERT ON `longdescs` FOR EACH ROW 
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
		SET @message_sanitized_1 = REPLACE(@message,'\r\n', ' ');
		SET @message_sanitized_2 = REPLACE(@message_sanitized_1,'\r', ' ');
		SET @message_sanitized_3 = REPLACE(@message_sanitized_2,'\n', ' ');
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
			(`created_datetime`
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
			(@created_datetime
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

END $$


DELIMITER ;

/* Trigger structure for table `milestones` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_new_record_milestones` $$

CREATE TRIGGER `trig_update_audit_log_new_record_milestones` AFTER INSERT ON `milestones` FOR EACH ROW 
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_id = new.id;
        SET @new_product_id = new.product_id;
        SET @new_value = new.value;
        SET @new_sortkey = new.sortkey;
        SET @new_isactive = new.isactive;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'milestones';
        SET @bzfe_field = 'id, product_id, value, sortkey, isactive';
        SET @previous_value = NULL;
        SET @new_value = CONCAT (
                @new_id
                , ', '
                , @new_product_id
                , ', '
                , @new_value
                , ', '
                , @new_sortkey
                , ', '
                , @new_isactive
            )
           ;
        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_new_record_milestones';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;

/* Trigger structure for table `milestones` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_update_record_milestones` $$

CREATE TRIGGER `trig_update_audit_log_update_record_milestones` AFTER UPDATE ON `milestones` FOR EACH ROW 
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_id = new.id;
        SET @new_product_id = new.product_id;
        SET @new_value = new.value;
        SET @new_sortkey = new.sortkey;
        SET @new_isactive = new.isactive;

    # We capture the old values of each fields in dedicated variables:
        SET @old_id = old.id;
        SET @old_product_id = old.product_id;
        SET @old_value = old.value;
        SET @old_sortkey = old.sortkey;
        SET @old_isactive = old.isactive;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'milestones';
        SET @bzfe_field = 'id, product_id, value, sortkey, isactive';
        SET @previous_value = CONCAT (
                @old_id
                , ', '
                , @old_product_id
                , ', '
                , @old_value
                , ', '
                , @old_sortkey
                , ', '
                , @old_isactive
            )
           ;
        SET @new_value = CONCAT (
                @new_id
                , ', '
                , @new_product_id
                , ', '
                , @new_value
                , ', '
                , @new_sortkey
                , ', '
                , @new_isactive
            )
           ;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_update_record_milestones';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;

/* Trigger structure for table `milestones` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_delete_record_milestones` $$

CREATE TRIGGER `trig_update_audit_log_delete_record_milestones` AFTER DELETE ON `milestones` FOR EACH ROW 
  BEGIN

    # We capture the old values of each fields in dedicated variables:
        SET @old_id = old.id;
        SET @old_product_id = old.product_id;
        SET @old_value = old.value;
        SET @old_sortkey = old.sortkey;
        SET @old_isactive = old.isactive;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'milestones';
        SET @bzfe_field = 'id, product_id, value, sortkey, isactive';
        SET @previous_value = CONCAT (
                @old_id
                , ', '
                , @old_product_id
                , ', '
                , @old_value
                , ', '
                , @old_sortkey
                , ', '
                , @old_isactive
            )
           ;
        SET @new_value = NULL;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_delete_record_milestones';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;

/* Trigger structure for table `products` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_new_record_products` $$

CREATE TRIGGER `trig_update_audit_log_new_record_products` AFTER INSERT ON `products` FOR EACH ROW 
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_name = new.name;
        SET @new_classification_id = new.classification_id;
        SET @new_description = new.description;
        SET @new_isactive = new.isactive;
        SET @new_defaultmilestone = new.defaultmilestone;
        SET @new_allows_unconfirmed = new.allows_unconfirmed;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'products';
        SET @bzfe_field = 'name, classification_id, description, isactive, defaultmilestone, allows_unconfirmed';
        SET @previous_value = NULL;
        SET @new_value = CONCAT (
                @new_name
                , ', '
                , @new_classification_id
                , ', '
                , @new_description
                , ', '
                , @new_isactive
                , ', '
                , @new_defaultmilestone
                , ', '
                , @new_allows_unconfirmed
            )
           ;
        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_new_record_products';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;

/* Trigger structure for table `products` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `update_the_log_of_enabled_units_when_unit_is_updated` $$

CREATE TRIGGER `update_the_log_of_enabled_units_when_unit_is_updated` AFTER UPDATE ON `products` FOR EACH ROW 
  BEGIN
    IF NEW.`isactive` <> OLD.`isactive` 
		THEN
		# If these are different, then we need to update the log of closed cases
			CALL `update_log_count_enabled_units`;
    END IF;
END $$


DELIMITER ;

/* Trigger structure for table `products` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_update_record_products` $$

CREATE TRIGGER `trig_update_audit_log_update_record_products` AFTER UPDATE ON `products` FOR EACH ROW 
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_name = new.name;
        SET @new_classification_id = new.classification_id;
        SET @new_description = new.description;
        SET @new_isactive = new.isactive;
        SET @new_defaultmilestone = new.defaultmilestone;
        SET @new_allows_unconfirmed = new.allows_unconfirmed;

    # We capture the old values of each fields in dedicated variables:
        SET @old_name = old.name;
        SET @old_classification_id = old.classification_id;
        SET @old_description = old.description;
        SET @old_isactive = old.isactive;
        SET @old_defaultmilestone = old.defaultmilestone;
        SET @old_allows_unconfirmed = old.allows_unconfirmed;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'products';
        SET @bzfe_field = 'name, classification_id, description, isactive, defaultmilestone, allows_unconfirmed';
        SET @previous_value = CONCAT (
                @old_name
                , ', '
                , @old_classification_id
                , ', '
                , @old_description
                , ', '
                , @old_isactive
                , ', '
                , @old_defaultmilestone
                , ', '
                , @old_allows_unconfirmed
            )
           ;
        SET @new_value = CONCAT (
                 @new_name
                , ', '
                , @new_classification_id
                , ', '
                , @new_description
                , ', '
                , @new_isactive
                , ', '
                , @new_defaultmilestone
                , ', '
                , @new_allows_unconfirmed
            )
           ;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_update_record_products';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;

/* Trigger structure for table `products` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `update_the_log_of_enabled_units_when_unit_is_deleted` $$

CREATE TRIGGER `update_the_log_of_enabled_units_when_unit_is_deleted` AFTER DELETE ON `products` FOR EACH ROW 
  BEGIN
    CALL `update_log_count_enabled_units`;
END $$


DELIMITER ;

/* Trigger structure for table `products` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_delete_record_products` $$

CREATE TRIGGER `trig_update_audit_log_delete_record_products` AFTER DELETE ON `products` FOR EACH ROW 
  BEGIN

    # We capture the old values of each fields in dedicated variables:
        SET @old_name = old.name;
        SET @old_classification_id = old.classification_id;
        SET @old_description = old.description;
        SET @old_isactive = old.isactive;
        SET @old_defaultmilestone = old.defaultmilestone;
        SET @old_allows_unconfirmed = old.allows_unconfirmed;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'products';
        SET @bzfe_field = 'name, classification_id, description, isactive, defaultmilestone, allows_unconfirmed';
        SET @previous_value = CONCAT (
                @old_name
                , ', '
                , @old_classification_id
                , ', '
                , @old_description
                , ', '
                , @old_isactive
                , ', '
                , @old_defaultmilestone
                , ', '
                , @old_allows_unconfirmed
            )
           ;
        SET @new_value = NULL;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_delete_record_products';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;

/* Trigger structure for table `user_group_map` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_new_record_user_group_map` $$

CREATE TRIGGER `trig_update_audit_log_new_record_user_group_map` AFTER INSERT ON `user_group_map` FOR EACH ROW 
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_user_id = new.user_id;
        SET @new_group_id = new.group_id;
        SET @new_isbless = new.isbless;
        SET @new_grant_type = new.grant_type;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'user_group_map';
        SET @bzfe_field = 'user_id, group_id, isbless, grant_type';
        SET @previous_value = NULL;
        SET @new_value = CONCAT (
                @new_user_id
                , ', '
                , @new_group_id
                , ', '
                , @new_isbless
                , ', '
                , @new_grant_type
            )
           ;
        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_new_record_user_group_map';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;

/* Trigger structure for table `user_group_map` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_update_record_user_group_map` $$

CREATE TRIGGER `trig_update_audit_log_update_record_user_group_map` AFTER UPDATE ON `user_group_map` FOR EACH ROW 
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_user_id = new.user_id;
        SET @new_group_id = new.group_id;
        SET @new_isbless = new.isbless;
        SET @new_grant_type = new.grant_type;

    # We capture the old values of each fields in dedicated variables:
        SET @old_user_id = old.user_id;
        SET @old_group_id = old.group_id;
        SET @old_isbless = old.isbless;
        SET @old_grant_type = old.grant_type;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'user_group_map';
        SET @bzfe_field = 'user_id, group_id, isbless, grant_type';
        SET @previous_value = CONCAT (
                @old_user_id
                , ', '
                , @old_group_id
                , ', '
                , @old_isbless
                , ', '
                , @old_grant_type
                )
                ;
        SET @new_value = CONCAT (
                @new_user_id
                , ', '
                , @new_group_id
                , ', '
                , @new_isbless
                , ', '
                , @new_grant_type
                )
                ;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_update_record_user_group_map';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;

/* Trigger structure for table `user_group_map` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_delete_record_user_group_map` $$

CREATE TRIGGER `trig_update_audit_log_delete_record_user_group_map` AFTER DELETE ON `user_group_map` FOR EACH ROW 
  BEGIN

    # We capture the old values of each fields in dedicated variables:
        SET @old_user_id = old.user_id;
        SET @old_group_id = old.group_id;
        SET @old_isbless = old.isbless;
        SET @old_grant_type = old.grant_type;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'user_group_map';
        SET @bzfe_field = 'user_id, group_id, isbless, grant_type';
        SET @previous_value = CONCAT (
                @old_user_id
                , ', '
                , @old_group_id
                , ', '
                , @old_isbless
                , ', '
                , @old_grant_type
            );
        SET @new_value = NULL;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_delete_record_user_group_map';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;

/* Trigger structure for table `ut_data_to_create_units` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_new_record_ut_data_to_create_units` $$

CREATE TRIGGER `trig_update_audit_log_new_record_ut_data_to_create_units` AFTER INSERT ON `ut_data_to_create_units` FOR EACH ROW 
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_id_unit_to_create = new.id_unit_to_create;
        SET @new_mefe_unit_id = new.mefe_unit_id;
        SET @new_mefe_creator_user_id = new.mefe_creator_user_id;
        SET @new_bzfe_creator_user_id = new.bzfe_creator_user_id;
        SET @new_classification_id = new.classification_id;
        SET @new_unit_name = new.unit_name;
        SET @new_unit_description_details = new.unit_description_details;
        SET @new_bz_created_date = new.bz_created_date;
        SET @new_comment = new.comment;
        SET @new_product_id = new.product_id;
        SET @new_deleted_datetime = new.deleted_datetime;
        SET @new_deletion_script = new.deletion_script;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'ut_data_to_create_units';
        SET @bzfe_field = 'id_unit_to_create, mefe_unit_id, mefe_creator_user_id, bzfe_creator_user_id, classification_id, unit_name, unit_description_details, bz_created_date, comment, product_id, deleted_datetime, deletion_script';
        SET @previous_value = NULL;
        SET @new_value = CONCAT (
                @new_id_unit_to_create
                , ', '
                , IFNULL(@new_mefe_unit_id, '(NULL)')
                , ', '
                , IFNULL(@new_mefe_creator_user_id, '(NULL)')
                , ', '
                , @new_bzfe_creator_user_id
                , ', '
                , @new_classification_id
                , ', '
                , @new_unit_name
                , ', '
                , IFNULL(@new_unit_description_details, '(NULL)')
                , ', '
                , IFNULL(@new_bz_created_date, '(NULL)')
                , ', '
                , IFNULL(@new_comment, '(NULL)')
                , ', '
                , IFNULL(@new_product_id, '(NULL)')
                , ', '
                , IFNULL(@new_deleted_datetime, '(NULL)')
                , ', '
                , IFNULL(@new_deletion_script, '(NULL)')
            )
           ;
        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_new_record_ut_data_to_create_units';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;

/* Trigger structure for table `ut_data_to_create_units` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_update_record_ut_data_to_create_units` $$

CREATE TRIGGER `trig_update_audit_log_update_record_ut_data_to_create_units` AFTER UPDATE ON `ut_data_to_create_units` FOR EACH ROW 
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_id_unit_to_create = new.id_unit_to_create;
        SET @new_mefe_unit_id = new.mefe_unit_id;
        SET @new_mefe_creator_user_id = new.mefe_creator_user_id;
        SET @new_bzfe_creator_user_id = new.bzfe_creator_user_id;
        SET @new_classification_id = new.classification_id;
        SET @new_unit_name = new.unit_name;
        SET @new_unit_description_details = new.unit_description_details;
        SET @new_bz_created_date = new.bz_created_date;
        SET @new_comment = new.comment;
        SET @new_product_id = new.product_id;
        SET @new_deleted_datetime = new.deleted_datetime;
        SET @new_deletion_script = new.deletion_script;
        
    # We capture the old values of each fields in dedicated variables:
        SET @old_id_unit_to_create = old.id_unit_to_create;
        SET @old_mefe_unit_id = old.mefe_unit_id;
        SET @old_mefe_creator_user_id = old.mefe_creator_user_id;
        SET @old_bzfe_creator_user_id = old.bzfe_creator_user_id;
        SET @old_classification_id = old.classification_id;
        SET @old_unit_name = old.unit_name;
        SET @old_unit_description_details = old.unit_description_details;
        SET @old_bz_created_date = old.bz_created_date;
        SET @old_comment = old.comment;
        SET @old_product_id = old.product_id;
        SET @old_deleted_datetime = old.deleted_datetime;
        SET @old_deletion_script = old.deletion_script;
        
    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'ut_data_to_create_units';
        SET @bzfe_field = 'id_unit_to_create, mefe_unit_id, mefe_creator_user_id, bzfe_creator_user_id, classification_id, unit_name, unit_description_details, bz_created_date, comment, product_id, deleted_datetime, deletion_script';
        SET @previous_value = CONCAT (
                @old_id_unit_to_create
                , ', '
                , IFNULL(@old_mefe_unit_id, '(NULL)')
                , ', '
                , IFNULL(@old_mefe_creator_user_id, '(NULL)')
                , ', '
                , @old_bzfe_creator_user_id
                , ', '
                , @old_classification_id
                , ', '
                , @old_unit_name
                , ', '
                , IFNULL(@old_unit_description_details, '(NULL)')
                , ', '
                , IFNULL(@old_bz_created_date, '(NULL)')
                , ', '
                , IFNULL(@old_comment, '(NULL)')
                , ', '
                , IFNULL(@old_product_id, '(NULL)')
                , ', '
                , IFNULL(@old_deleted_datetime, '(NULL)')
                , ', '
                , IFNULL(@old_deletion_script, '(NULL)')
            )
           ;
        SET @new_value = CONCAT (
                @new_id_unit_to_create
                , ', '
                , IFNULL(@new_mefe_unit_id, '(NULL)')
                , ', '
                , IFNULL(@new_mefe_creator_user_id, '(NULL)')
                , ', '
                , @new_bzfe_creator_user_id
                , ', '
                , @new_classification_id
                , ', '
                , @new_unit_name
                , ', '
                , IFNULL(@new_unit_description_details, '(NULL)')
                , ', '
                , IFNULL(@new_bz_created_date, '(NULL)')
                , ', '
                , IFNULL(@new_comment, '(NULL)')
                , ', '
                , IFNULL(@new_product_id, '(NULL)')
                , ', '
                , IFNULL(@new_deleted_datetime, '(NULL)')
                , ', '
                , IFNULL(@new_deletion_script, '(NULL)')
            )
           ;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_update_record_ut_data_to_create_units';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;

/* Trigger structure for table `ut_data_to_create_units` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_delete_record_ut_data_to_create_units` $$

CREATE TRIGGER `trig_update_audit_log_delete_record_ut_data_to_create_units` AFTER DELETE ON `ut_data_to_create_units` FOR EACH ROW 
  BEGIN

    # We capture the old values of each fields in dedicated variables:
        SET @old_id_unit_to_create = old.id_unit_to_create;
        SET @old_mefe_unit_id = old.mefe_unit_id;
        SET @old_mefe_creator_user_id = old.mefe_creator_user_id;
        SET @old_bzfe_creator_user_id = old.bzfe_creator_user_id;
        SET @old_classification_id = old.classification_id;
        SET @old_unit_name = old.unit_name;
        SET @old_unit_description_details = old.unit_description_details;
        SET @old_bz_created_date = old.bz_created_date;
        SET @old_comment = old.comment;
        SET @old_product_id = old.product_id;
        SET @old_deleted_datetime = old.deleted_datetime;
        SET @old_deletion_script = old.deletion_script;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'ut_data_to_create_units';
        SET @bzfe_field = 'id_unit_to_create, mefe_unit_id, mefe_creator_user_id, bzfe_creator_user_id, classification_id, unit_name, unit_description_details, bz_created_date, comment, product_id, deleted_datetime, deletion_script';
        SET @previous_value = CONCAT (
                @old_id_unit_to_create
                , ', '
                , IFNULL(@old_mefe_unit_id, '(NULL)')
                , ', '
                , IFNULL(@old_mefe_creator_user_id, '(NULL)')
                , ', '
                , @old_bzfe_creator_user_id
                , ', '
                , @old_classification_id
                , ', '
                , @old_unit_name
                , ', '
                , IFNULL(@old_unit_description_details, '(NULL)')
                , ', '
                , IFNULL(@old_bz_created_date, '(NULL)')
                , ', '
                , IFNULL(@old_comment, '(NULL)')
                , ', '
                , IFNULL(@old_product_id, '(NULL)')
                , ', '
                , IFNULL(@old_deleted_datetime, '(NULL)')
                , ', '
                , IFNULL(@old_deletion_script, '(NULL)')
            )
           ;
        SET @new_value = NULL;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_delete_record_ut_data_to_create_units';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;

/* Trigger structure for table `ut_invitation_api_data` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_new_record_ut_invitation_api_data` $$

CREATE TRIGGER `trig_update_audit_log_new_record_ut_invitation_api_data` AFTER INSERT ON `ut_invitation_api_data` FOR EACH ROW 
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_id = new.id;
        SET @new_mefe_invitation_id = new.mefe_invitation_id;
        SET @new_bzfe_invitor_user_id = new.bzfe_invitor_user_id;
        SET @new_bz_user_id = new.bz_user_id;
        SET @new_user_role_type_id = new.user_role_type_id;
        SET @new_is_occupant = new.is_occupant;
        SET @new_bz_case_id = new.bz_case_id;
        SET @new_bz_unit_id = new.bz_unit_id;
        SET @new_invitation_type = new.invitation_type;
        SET @new_is_mefe_only_user = new.is_mefe_only_user;
        SET @new_user_more = new.user_more;
        SET @new_mefe_invitor_user_id = new.mefe_invitor_user_id;
        SET @new_processed_datetime = new.processed_datetime;
        SET @new_script = new.script;
        SET @new_api_post_datetime = new.api_post_datetime;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'ut_invitation_api_data';
        SET @bzfe_field = 'id, mefe_invitation_id, bzfe_invitor_user_id, bz_user_id, user_role_type_id, is_occupant, bz_case_id, bz_unit_id, invitation_type, is_mefe_only_user, user_more, mefe_invitor_user_id, processed_datetime, script, api_post_datetime';
        SET @previous_value = NULL;
        SET @new_value = CONCAT (
                @new_id
                , ', '
                , IFNULL(@new_mefe_invitation_id, '(NULL)')
                , ', '
                , @new_bzfe_invitor_user_id
                , ', '
                , @new_bz_user_id
                , ', '
                , @new_user_role_type_id
                , ', '
                , IFNULL(@new_is_occupant, '(NULL)')
                , ', '
                , IFNULL(@new_bz_case_id, '(NULL)')
                , ', '
                , @new_bz_unit_id
                , ', '
                , @new_invitation_type
                , ', '
                , IFNULL(@new_is_mefe_only_user, '(NULL)')
                , ', '
                , IFNULL(@new_user_more, '(NULL)')
                , ', '
                , IFNULL(@new_mefe_invitor_user_id, '(NULL)')
                , ', '
                , IFNULL(@new_processed_datetime, '(NULL)')
                , ', '
                , IFNULL(@new_script, '(NULL)')
                , ', '
                , IFNULL(@new_api_post_datetime, '(NULL)')
            )
           ;
        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_new_record_ut_invitation_api_data';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;

/* Trigger structure for table `ut_invitation_api_data` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_update_record_ut_invitation_api_data` $$

CREATE TRIGGER `trig_update_audit_log_update_record_ut_invitation_api_data` AFTER UPDATE ON `ut_invitation_api_data` FOR EACH ROW 
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_id = new.id;
        SET @new_mefe_invitation_id = new.mefe_invitation_id;
        SET @new_bzfe_invitor_user_id = new.bzfe_invitor_user_id;
        SET @new_bz_user_id = new.bz_user_id;
        SET @new_user_role_type_id = new.user_role_type_id;
        SET @new_is_occupant = new.is_occupant;
        SET @new_bz_case_id = new.bz_case_id;
        SET @new_bz_unit_id = new.bz_unit_id;
        SET @new_invitation_type = new.invitation_type;
        SET @new_is_mefe_only_user = new.is_mefe_only_user;
        SET @new_user_more = new.user_more;
        SET @new_mefe_invitor_user_id = new.mefe_invitor_user_id;
        SET @new_processed_datetime = new.processed_datetime;
        SET @new_script = new.script;
        SET @new_api_post_datetime = new.api_post_datetime;
        
    # We capture the old values of each fields in dedicated variables:
        SET @old_id = old.id;
        SET @old_mefe_invitation_id = old.mefe_invitation_id;
        SET @old_bzfe_invitor_user_id = old.bzfe_invitor_user_id;
        SET @old_bz_user_id = old.bz_user_id;
        SET @old_user_role_type_id = old.user_role_type_id;
        SET @old_is_occupant = old.is_occupant;
        SET @old_bz_case_id = old.bz_case_id;
        SET @old_bz_unit_id = old.bz_unit_id;
        SET @old_invitation_type = old.invitation_type;
        SET @old_is_mefe_only_user = old.is_mefe_only_user;
        SET @old_user_more = old.user_more;
        SET @old_mefe_invitor_user_id = old.mefe_invitor_user_id;
        SET @old_processed_datetime = old.processed_datetime;
        SET @old_script = old.script;
        SET @old_api_post_datetime = old.api_post_datetime;
                
    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'ut_invitation_api_data';
        SET @bzfe_field = 'id, mefe_invitation_id, bzfe_invitor_user_id, bz_user_id, user_role_type_id, is_occupant, bz_case_id, bz_unit_id, invitation_type, is_mefe_only_user, user_more, mefe_invitor_user_id, processed_datetime, script, api_post_datetime';
        SET @previous_value = CONCAT (
                @old_id
                , ', '
                , IFNULL(@old_mefe_invitation_id, '(NULL)')
                , ', '
                , @old_bzfe_invitor_user_id
                , ', '
                , @old_bz_user_id
                , ', '
                , @old_user_role_type_id
                , ', '
                , IFNULL(@old_is_occupant, '(NULL)')
                , ', '
                , IFNULL(@old_bz_case_id, '(NULL)')
                , ', '
                , @old_bz_unit_id
                , ', '
                , @old_invitation_type
                , ', '
                , IFNULL(@old_is_mefe_only_user, '(NULL)')
                , ', '
                , IFNULL(@old_user_more, '(NULL)')
                , ', '
                , IFNULL(@old_mefe_invitor_user_id, '(NULL)')
                , ', '
                , IFNULL(@old_processed_datetime, '(NULL)')
                , ', '
                , IFNULL(@old_script, '(NULL)')
                , ', '
                , IFNULL(@old_api_post_datetime, '(NULL)')
            )
           ;
        SET @new_value = CONCAT (
                @new_id
                , ', '
                , IFNULL(@new_mefe_invitation_id, '(NULL)')
                , ', '
                , @new_bzfe_invitor_user_id
                , ', '
                , @new_bz_user_id
                , ', '
                , @new_user_role_type_id
                , ', '
                , IFNULL(@new_is_occupant, '(NULL)')
                , ', '
                , IFNULL(@new_bz_case_id, '(NULL)')
                , ', '
                , @new_bz_unit_id
                , ', '
                , @new_invitation_type
                , ', '
                , IFNULL(@new_is_mefe_only_user, '(NULL)')
                , ', '
                , IFNULL(@new_user_more, '(NULL)')
                , ', '
                , IFNULL(@new_mefe_invitor_user_id, '(NULL)')
                , ', '
                , IFNULL(@new_processed_datetime, '(NULL)')
                , ', '
                , IFNULL(@new_script, '(NULL)')
                , ', '
                , IFNULL(@new_api_post_datetime, '(NULL)')
            )
           ;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_update_record_ut_invitation_api_data';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;

/* Trigger structure for table `ut_invitation_api_data` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_delete_record_ut_invitation_api_data` $$

CREATE TRIGGER `trig_update_audit_log_delete_record_ut_invitation_api_data` AFTER DELETE ON `ut_invitation_api_data` FOR EACH ROW 
  BEGIN

    # We capture the old values of each fields in dedicated variables:
        SET @old_id = old.id;
        SET @old_mefe_invitation_id = old.mefe_invitation_id;
        SET @old_bzfe_invitor_user_id = old.bzfe_invitor_user_id;
        SET @old_bz_user_id = old.bz_user_id;
        SET @old_user_role_type_id = old.user_role_type_id;
        SET @old_is_occupant = old.is_occupant;
        SET @old_bz_case_id = old.bz_case_id;
        SET @old_bz_unit_id = old.bz_unit_id;
        SET @old_invitation_type = old.invitation_type;
        SET @old_is_mefe_only_user = old.is_mefe_only_user;
        SET @old_user_more = old.user_more;
        SET @old_mefe_invitor_user_id = old.mefe_invitor_user_id;
        SET @old_processed_datetime = old.processed_datetime;
        SET @old_script = old.script;
        SET @old_api_post_datetime = old.api_post_datetime;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'ut_invitation_api_data';
        SET @bzfe_field = 'id, mefe_invitation_id, bzfe_invitor_user_id, bz_user_id, user_role_type_id, is_occupant, bz_case_id, bz_unit_id, invitation_type, is_mefe_only_user, user_more, mefe_invitor_user_id, processed_datetime, script, api_post_datetime';
        SET @previous_value = CONCAT (
                @old_id
                , ', '
                , IFNULL(@old_mefe_invitation_id, '(NULL)')
                , ', '
                , @old_bzfe_invitor_user_id
                , ', '
                , @old_bz_user_id
                , ', '
                , @old_user_role_type_id
                , ', '
                , IFNULL(@old_is_occupant, '(NULL)')
                , ', '
                , IFNULL(@old_bz_case_id, '(NULL)')
                , ', '
                , @old_bz_unit_id
                , ', '
                , @old_invitation_type
                , ', '
                , IFNULL(@old_is_mefe_only_user, '(NULL)')
                , ', '
                , IFNULL(@old_user_more, '(NULL)')
                , ', '
                , IFNULL(@old_mefe_invitor_user_id, '(NULL)')
                , ', '
                , IFNULL(@old_processed_datetime, '(NULL)')
                , ', '
                , IFNULL(@old_script, '(NULL)')
                , ', '
                , IFNULL(@old_api_post_datetime, '(NULL)')
            )
           ;
        SET @new_value = NULL;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_delete_record_ut_invitation_api_data';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;

/* Trigger structure for table `ut_notification_message_new` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `ut_prepare_message_new_comment` $$

CREATE TRIGGER `ut_prepare_message_new_comment` AFTER INSERT ON `ut_notification_message_new` FOR EACH ROW 
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
END $$


DELIMITER ;

/* Trigger structure for table `ut_product_group` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_new_record_ut_product_group` $$

CREATE TRIGGER `trig_update_audit_log_new_record_ut_product_group` AFTER INSERT ON `ut_product_group` FOR EACH ROW 
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_product_id = new.product_id;
        SET @new_component_id = new.component_id;
        SET @new_group_id = new.group_id;
        SET @new_group_type_id = new.group_type_id;
        SET @new_role_type_id = new.role_type_id;
        SET @new_created_by_id = new.created_by_id;
        SET @new_created = new.created;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'ut_product_group';
        SET @bzfe_field = 'product_id, component_id, group_id, group_type_id, role_type_id, created_by_id, created';
        SET @previous_value = NULL;
        SET @new_value = CONCAT (
                @new_product_id
                , ', '
                , IFNULL(@new_component_id, '(NULL)')
                , ', '
                , @new_group_id
                , ', '
                , @new_group_type_id
                , ', '
                , IFNULL(@new_role_type_id, '(NULL)')
                , ', '
                , IFNULL(@new_created_by_id, '(NULL)')
                , ', '
                , IFNULL(@new_created, '(NULL)')
            )
           ;
        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_new_record_ut_product_group';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;

/* Trigger structure for table `ut_product_group` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_update_record_ut_product_group` $$

CREATE TRIGGER `trig_update_audit_log_update_record_ut_product_group` AFTER UPDATE ON `ut_product_group` FOR EACH ROW 
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_product_id = new.product_id;
        SET @new_component_id = new.component_id;
        SET @new_group_id = new.group_id;
        SET @new_group_type_id = new.group_type_id;
        SET @new_role_type_id = new.role_type_id;
        SET @new_created_by_id = new.created_by_id;
        SET @new_created = new.created;
        
    # We capture the old values of each fields in dedicated variables:
        SET @old_product_id = old.product_id;
        SET @old_component_id = old.component_id;
        SET @old_group_id = old.group_id;
        SET @old_group_type_id = old.group_type_id;
        SET @old_role_type_id = old.role_type_id;
        SET @old_created_by_id = old.created_by_id;
        SET @old_created = old.created;
        
    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'ut_product_group';
        SET @bzfe_field = 'product_id, component_id, group_id, group_type_id, role_type_id, created_by_id, created';
        SET @previous_value = CONCAT (
                @old_product_id
                , ', '
                , IFNULL(@old_component_id, '(NULL)')
                , ', '
                , @old_group_id
                , ', '
                , @old_group_type_id
                , ', '
                , IFNULL(@old_role_type_id, '(NULL)')
                , ', '
                , IFNULL(@old_created_by_id, '(NULL)')
                , ', '
                , IFNULL(@old_created, '(NULL)')
            )
           ;
        SET @new_value = CONCAT (
                @new_product_id
                , ', '
                , IFNULL(@new_component_id, '(NULL)')
                , ', '
                , @new_group_id
                , ', '
                , @new_group_type_id
                , ', '
                , IFNULL(@new_role_type_id, '(NULL)')
                , ', '
                , IFNULL(@new_created_by_id, '(NULL)')
                , ', '
                , IFNULL(@new_created, '(NULL)')
            )
           ;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_update_record_ut_product_group';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;

/* Trigger structure for table `ut_product_group` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_delete_record_ut_product_group` $$

CREATE TRIGGER `trig_update_audit_log_delete_record_ut_product_group` AFTER DELETE ON `ut_product_group` FOR EACH ROW 
  BEGIN

    # We capture the old values of each fields in dedicated variables:
        SET @old_product_id = old.product_id;
        SET @old_component_id = old.component_id;
        SET @old_group_id = old.group_id;
        SET @old_group_type_id = old.group_type_id;
        SET @old_role_type_id = old.role_type_id;
        SET @old_created_by_id = old.created_by_id;
        SET @old_created = old.created;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'ut_product_group';
        SET @bzfe_field = 'product_id, component_id, group_id, group_type_id, role_type_id, created_by_id, created';
        SET @previous_value = CONCAT (
                @old_product_id
                , ', '
                , IFNULL(@old_component_id, '(NULL)')
                , ', '
                , @old_group_id
                , ', '
                , @old_group_type_id
                , ', '
                , IFNULL(@old_role_type_id, '(NULL)')
                , ', '
                , IFNULL(@old_created_by_id, '(NULL)')
                , ', '
                , IFNULL(@old_created, '(NULL)')
            )
           ;
        SET @new_value = NULL;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_delete_record_ut_product_group';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;

/* Trigger structure for table `versions` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_new_record_versions` $$

CREATE TRIGGER `trig_update_audit_log_new_record_versions` AFTER INSERT ON `versions` FOR EACH ROW 
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_id = new.id;
        SET @new_value = new.value;
        SET @new_product_id = new.product_id;
        SET @new_isactive = new.isactive;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'versions';
        SET @bzfe_field = 'id, value, product_id, isactive';
        SET @previous_value = NULL;
        SET @new_value = CONCAT (
                @new_id
                , ', '
                , @new_value
                , ', '
                , @new_product_id
                , ', '
                , @new_isactive
            )
           ;
        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_new_record_versions';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;

/* Trigger structure for table `versions` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_update_record_versions` $$

CREATE TRIGGER `trig_update_audit_log_update_record_versions` AFTER UPDATE ON `versions` FOR EACH ROW 
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_id = new.id;
        SET @new_value = new.value;
        SET @new_product_id = new.product_id;
        SET @new_isactive = new.isactive;

    # We capture the old values of each fields in dedicated variables:
        SET @old_id = old.id;
        SET @old_value = old.value;
        SET @old_product_id = old.product_id;
        SET @old_isactive = old.isactive;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'versions';
        SET @bzfe_field = 'id, value, product_id, isactive';
        SET @previous_value = CONCAT (
                @old_id
                , ', '
                , @old_value
                , ', '
                , @old_product_id
                , ', '
                , @old_isactive
            )
           ;
        SET @new_value = CONCAT (
                @new_id
                , ', '
                , @new_value
                , ', '
                , @new_product_id
                , ', '
                , @new_isactive
            )
           ;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_update_record_versions';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;

/* Trigger structure for table `versions` */

DELIMITER $$

DROP TRIGGER IF EXISTS  `trig_update_audit_log_delete_record_versions` $$

CREATE TRIGGER `trig_update_audit_log_delete_record_versions` AFTER DELETE ON `versions` FOR EACH ROW 
  BEGIN

    # We capture the old values of each fields in dedicated variables:
        SET @old_id = old.id;
        SET @old_value = old.value;
        SET @old_product_id = old.product_id;
        SET @old_isactive = old.isactive;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'versions';
        SET @bzfe_field = 'id, value, product_id, isactive';
        SET @previous_value = CONCAT (
                @old_id
                , ', '
                , @old_value
                , ', '
                , @old_product_id
                , ', '
                , @old_isactive
            )
           ;
        SET @new_value = NULL;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_delete_record_versions';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END $$


DELIMITER ;