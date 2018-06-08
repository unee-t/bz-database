# For any question about this script, ask Franck
#
###################################################################################
#
# WARNING! It is recommended to use Amazon Aurora database engine for this version
#
#	- for the DEV/Staging environment, make sure to run the script `db_v3.6+_adjustments_for_DEV_environment.sql` AFTER this one
#	  This is needed to make sure the values for the dummy user (bz user id)  are correct for the DEV/Staging envo
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
	SET @old_schema_version = 'v3.10';
	SET @new_schema_version = 'v3.11';
#
# What is the name of this script?
	SET @this_script = 'upgrade_unee-t_v3.10_to_v3.11.sql';
#
###############################
#
# We have everything we need
#
###############################
# This update 
#TEST NEEDED	- Alter the table `ut_invitation_api_data` to Make sure invitation type can not be NULL
#TEST NEEDED	- Alter the table `ut_log_count_closed_cases` to record the total number of case
#WIP	- Alter the procedure `update_log_count_closed_case` to make sure we also count the total number of cases
#
#

# When are we doing this?
	SET @the_timestamp = NOW();

# Alter the table `ut_invitation_api_data` to Make sure invitation type can not be NULL

	/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;


	/* Foreign Keys must be dropped in the target to ensure that requires changes can be done*/

	ALTER TABLE `ut_invitation_api_data` 
		DROP FOREIGN KEY `invitation_bz_bug_must_exist`  , 
		DROP FOREIGN KEY `invitation_bz_invitee_must_exist`  , 
		DROP FOREIGN KEY `invitation_bz_invitor_must_exist`  , 
		DROP FOREIGN KEY `invitation_bz_product_must_exist`  , 
		DROP FOREIGN KEY `invitation_invitation_type_must_exist`  ;


	/* Alter table in target */
	ALTER TABLE `ut_invitation_api_data` 
		CHANGE `invitation_type` `invitation_type` varchar(255)  COLLATE utf8_general_ci NOT NULL COMMENT 'The type of the invitation (assigned or CC)' after `bz_unit_id` ; 

	/* The foreign keys that were dropped are now re-created*/

	ALTER TABLE `ut_invitation_api_data` 
		ADD CONSTRAINT `invitation_bz_bug_must_exist` 
		FOREIGN KEY (`bz_case_id`) REFERENCES `bugs` (`bug_id`) , 
		ADD CONSTRAINT `invitation_bz_invitee_must_exist` 
		FOREIGN KEY (`bz_user_id`) REFERENCES `profiles` (`userid`) , 
		ADD CONSTRAINT `invitation_bz_invitor_must_exist` 
		FOREIGN KEY (`bzfe_invitor_user_id`) REFERENCES `profiles` (`userid`) , 
		ADD CONSTRAINT `invitation_bz_product_must_exist` 
		FOREIGN KEY (`bz_unit_id`) REFERENCES `products` (`id`) , 
		ADD CONSTRAINT `invitation_invitation_type_must_exist` 
		FOREIGN KEY (`invitation_type`) REFERENCES `ut_invitation_types` (`invitation_type`) ;

	/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;

# Alter the table `ut_log_count_closed_cases` to record the total number of case

	/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

	/* Alter table in target */
	ALTER TABLE `ut_log_count_closed_cases` 
		ADD COLUMN `count_total_cases` int(11)   NULL COMMENT 'The total number of cases in Unee-T at this time' after `count_closed_cases` ;
	/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;

# Alter the procedure `update_log_count_closed_case` to make sure we also count the total number of cases
		
	DROP PROCEDURE IF EXISTS `update_log_count_closed_case`;

DELIMITER $$
CREATE PROCEDURE update_log_count_closed_case()
SQL SECURITY INVOKER
BEGIN

	# When are we doing this?
		SET @timestamp = NOW();	

	# Flash Count the total number of CLOSED cases are the date of this query
	# Put this in a variable
		SET @count_closed_cases = (SELECT
			 COUNT(`bugs`.`bug_id`)
		FROM
			`bugs`
			INNER JOIN `bug_status`
				ON (`bugs`.`bug_status` = `bug_status`.`value`)
		WHERE `bug_status`.`is_open` = 0)
		;
		
	# Flash Count the total number of ALL cases are the date of this query
	# Put this in a variable
		SET @count_total_cases = (SELECT
			 COUNT(`bug_id`)
		FROM
			`bugs`
			) 
			;

	# We have everything: insert in the log table
		INSERT INTO `ut_log_count_closed_cases`
			(`timestamp`
			, `count_closed_cases`
			, `count_total_cases`
			)
			VALUES
			(@timestamp
			, @count_closed_cases
			, @count_total_cases
			)
			;
END $$
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