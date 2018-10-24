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
	SET @old_schema_version = 'v3.24';
	SET @new_schema_version = 'v3.25';
#
# What is the name of this script?
	SET @this_script = 'upgrade_unee-t_v3.24_to_v3.25.sql';
#
###############################
#
# We have everything we need
#
###############################
# This update
#
#   - Change the methodology to update user permissions:
#     We update the procedure `update_permissions_invited_user`
#       - BEFORE: truncate table and re-populate it
#       - AFTER: never truncate: insert or update if exists
#
#   - Make sure we only delete the table `ut_user_group_map_temp` if we have records in the table `user_group_map`
#     This is to avoid a scenario where we have accidentally nuked that table ---> we have a way to recover.
#
				
# When are we doing this?
	SET @the_timestamp = NOW();

# Change the methodology to update user permissions:
#       - BEFORE: truncate table and re-populate it
#       - AFTER: never truncate: insert or update if existsWe need a procedure `update_log_count_enabled_units` to update the table `ut_log_count_enabled_units`
	
	DROP PROCEDURE IF EXISTS `update_permissions_invited_user`;

DELIMITER $$
CREATE DEFINER=`bugzilla`@`%` PROCEDURE `update_permissions_invited_user`()
SQL SECURITY INVOKER
BEGIN
	# We update the `user_group_map` table
    #   - Create an intermediary table to deduplicate the records in the table `ut_user_group_map_temp`
    #   - If the record does NOT exists in the table then INSERT new records in the table `user_group_map`
    #   - If the record DOES exist in the table then update the new records in the table `user_group_map`
    # WARNING!!
    # HOW DO WE HANDLE REVOKING PERMISSIONS???
	
	# First we disable the FK checks
		 SET NAMES utf8 ;
		 SET SQL_MODE='' ;
		 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 ;
		 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 ;
		 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' ;
		 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 ;
		
		# We truncate the table first (to avoid duplicates)
			TRUNCATE TABLE `user_group_map`;
			
		# We insert the data we need
			INSERT INTO `user_group_map`
			SELECT `user_id`
				, `group_id`
				, `isbless`
				, `grant_type`
			FROM
				`ut_user_group_map_temp`
			GROUP BY `user_id`
				, `group_id`
				, `isbless`
				, `grant_type`
			;
		# We drop the temp table as we do not need it anymore
			DROP TABLE IF EXISTS `ut_user_group_map_temp`;
			
	# We implement the FK checks again		
		 SET SQL_MODE=@OLD_SQL_MODE ;
		 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS ;
		 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS ;
		 SET SQL_NOTES=@OLD_SQL_NOTES ;	
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