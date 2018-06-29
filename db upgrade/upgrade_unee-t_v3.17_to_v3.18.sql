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
	SET @old_schema_version = 'v3.17';
	SET @new_schema_version = 'v3.18';
#
# What is the name of this script?
	SET @this_script = 'upgrade_unee-t_v3.17_to_v3.18.sql';
#
# IMPORTANT!! make sure that the variable for the Lambda is correct for each environement
	#	- DEV/Staging: 812644853088
	#	- Prod: 192458993663
	#	- Demo: 915001051872

###############################
#
# We have everything we need
#
###############################
# This update
#
#OK	- Create the procedure `unit_enable_existing` needed so we can enable a existing unit back.
#OK   - Update the procedure `unit_disable_existing`: 
#       - Make sure we do not assume the current status of the unit
#       - Make sure we record the information 'bz_id of the user how made the change'
#   - Remove the unecessary field `assignee_user_id` from the notification `case_assigned_updated`
#OK      - in the trigger `ut_prepare_message_case_assigned_updated`
#       - in the table `ut_notification_case_assignee`
#       - in the procedure `lambda_notification_case_assignee_updated`
#   - Creates a procedure `update_bz_fielddefs` to make sure we use the correct definitions in the table `fielddefs`
#
#
				
# When are we doing this?
	SET @the_timestamp = NOW();

# Create the procedure `unit_enable_existing` needed so we can enable a existing unit back.

    DROP PROCEDURE IF EXISTS `unit_enable_existing`;

DELIMITER $$
CREATE PROCEDURE `unit_enable_existing`()
       SQL SECURITY INVOKER
BEGIN
        # This procedure needs the following variables:
        #	- @product_id
        # 	- @active_when
        #   - @bz_user_id
        #
        # This procedure will
        #	- Enable an existing unit/BZ product
        #	- Record the action of the script in the ut_log tables.
        #	- Record the chenge in the BZ `audit_log` table
        
        # We record the name of this procedure for future debugging and audit_log`
            SET @script = 'PROCEDURE - unit_disable_existing';
            SET @timestamp = NOW();

        # What is the current status of the unit?
        
            SET @current_unit_status = (SELECT `isactive` FROM `products` WHERE `id` = @product_id);

        # Make the unit active
        
            UPDATE `products`
                SET `isactive` = '1'
                WHERE `id` = @product_id
            ;
        # Record the actions of this script in the ut_log
            # Log the actions of the script.
                SET @script_log_message = CONCAT('the User #'
                                        , @bz_user_id
                                        , ' has made the Unit #'
                                        , @product_id
                                        , ' active. It IS possible to create new cases in this unit.'
                                        );
            
                INSERT INTO `ut_script_log`
                    (`datetime`
                    , `script`
                    , `log`
                    )
                    VALUES
                    (@timestamp, @script, @script_log_message)
                    ;
                # We log what we have just done into the `ut_audit_log` table
                
                SET @bzfe_table = 'products';
                
                INSERT INTO `ut_audit_log`
                    (`datetime`
                    , `bzfe_table`
                    , `bzfe_field`
                    , `previous_value`
                    , `new_value`
                    , `script`
                    , `comment`
                    )
                    VALUES
                    (@timestamp ,@bzfe_table, 'isactive', @current_unit_status, '1', @script, @script_log_message)
                    ;
            
            # Cleanup the variables for the log messages
                SET @script_log_message = NULL;
                SET @script = NULL;
                SET @timestamp = NULL;
                SET @bzfe_table = NULL;			
                
        # When we mark a unit as active, we need to record this in the `audit_log` table
                INSERT INTO `audit_log`
                (`user_id`
                , `class`
                , `object_id`
                , `field`
                , `removed`
                , `added`
                , `at_time`
                )
                VALUES
                (@bz_user_id
                , 'Bugzilla::Product'
                , @product_id
                , 'isactive'
                , @current_unit_status
                , '1'
                , @active_when
                )
                ;			
END
$$
DELIMITER ;

# Update the procedure `unit_disable_existing`
# Make sure we do not assume the current status of the unit

    DROP PROCEDURE IF EXISTS `unit_disable_existing`;

DELIMITER $$
CREATE PROCEDURE `unit_disable_existing`()
    SQL SECURITY INVOKER
BEGIN
	# This procedure needs the following variables:
	#	- @product_id
	# 	- @inactive_when
    #   - @bz_user_id
	#
	# This procedure will
	#	- Disable an existing unit/BZ product
	#	- Record the action of the script in the ut_log tables.
	#	- Record the chenge in the BZ `audit_log` table
	
	# We record the name of this procedure for future debugging and audit_log`
		SET @script = 'PROCEDURE - unit_disable_existing';
		SET @timestamp = NOW();


    # What is the current status of the unit?
        
        SET @current_unit_status = (SELECT `isactive` FROM `products` WHERE `id` = @product_id);

	# Make a unit inactive
		UPDATE `products`
			SET `isactive` = '0'
			WHERE `id` = @product_id
		;
	# Record the actions of this script in the ut_log
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the User #'
                                    , @bz_user_id
                                    , ' has made the Unit #'
									, @product_id
									, ' inactive. It is NOT possible to create new cases in this unit.'
									);
		
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(@timestamp, @script, @script_log_message)
				;
			# We log what we have just done into the `ut_audit_log` table
			
			SET @bzfe_table = 'products';
			
			INSERT INTO `ut_audit_log`
				 (`datetime`
				 , `bzfe_table`
				 , `bzfe_field`
				 , `previous_value`
				 , `new_value`
				 , `script`
				 , `comment`
				 )
				 VALUES
				 (@timestamp ,@bzfe_table, 'isactive', @current_unit_status, '0', @script, @script_log_message)
				 ;
		 
		# Cleanup the variables for the log messages
			SET @script_log_message = NULL;
			SET @script = NULL;
			SET @timestamp = NULL;
			SET @bzfe_table = NULL;
	# When we mark a unit as inactive, we need to record this in the `audit_log` table
			INSERT INTO `audit_log`
			(`user_id`
			, `class`
			, `object_id`
			, `field`
			, `removed`
			, `added`
			, `at_time`
			)
			VALUES
			(@bz_user_id
			, 'Bugzilla::Product'
			, @product_id
			, 'isactive'
			, @current_unit_status
			, '0'
			, @inactive_when
			)
			;			
END
$$
DELIMITER ;

# Alter the procedure `lambda_notification_case_assignee_updated`
# Remove the unecessary field `assignee_user_id`
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
			, '", "invitor_user_id" : "', invitor_user_id
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


# Alter the trigger `ut_prepare_message_case_assigned_updated`:
# Remove the unecessary field `assignee_user_id`

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
				)
				;
	END IF;
END;
$$
DELIMITER ;

# Alter the table `ut_notification_case_assignee`
# Remove the unecessary field `assignee_user_id`
    ALTER TABLE `ut_notification_case_assignee` 
        CHANGE `case_reporter_user_id` `case_reporter_user_id` mediumint(9)   NULL COMMENT 'User ID - BZ user id of the reporter for the case' after `invitor_user_id` , 
        DROP COLUMN `assignee_user_id` ;

# Create a procedure `update_bz_fielddefs` to make sure we use the correct definitions in the table `fielddefs`

    DROP PROCEDURE IF EXISTS `update_bz_fielddefs`;

DELIMITER $$
CREATE PROCEDURE `update_bz_fielddefs`()
       SQL SECURITY INVOKER
BEGIN

    # Update the name for the field `bug_id`
    UPDATE `fielddefs`
    SET `description` = 'Case #'
    WHERE `id` = 1;

    # Update the name for the field `classification`
    UPDATE `fielddefs`
    SET `description` = 'Unit Group'
    WHERE `id` = 3;

    # Update the name for the field `product`
    UPDATE `fielddefs`
    SET `description` = 'Unit'
    WHERE `id` = 4;

    # Update the name for the field `rep_platform`
    UPDATE `fielddefs`
    SET `description` = 'Case Category'
    WHERE `id` = 6;

    # Update the name for the field `component`
    UPDATE `fielddefs`
    SET `description` = 'Role'
    WHERE `id` = 15;

    # Update the name for the field `days_elapsed`
    UPDATE `fielddefs`
    SET `description` = 'Days since case changed'
    WHERE `id` = 59;

END
$$
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