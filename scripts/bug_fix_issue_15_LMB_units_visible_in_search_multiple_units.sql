# For any question about this script - Ask Franck
#
#############################################
#											#
# IMPORTANT INFORMATION ABOUT THIS SCRIPT	#
#											#
#############################################
#
# Built for BZFE database v2.18
#
# Use this script only if:
#	- You are running this script as a User who can create and call procedures in the database.
#	- The unit ALREADY EXISTS in the BZFE
#	- The BZ user already exist in the BZFE
#	- You HAVE used the script '2_Insert_new_unit_and_role_in_unee-t_bzfe_v2.17' to create the product (this is to make sure that all groups exist).
# 
# This script will use:
# 	- The product id
#	- Data in the table 'ut_product_group'
#
# This script will
#	- Create a group to limit who can see the unit
#	- Update the BZ log
#	- Update the list of groups in the 'ut_product_group' table
#	- Define the group control for this group
#	- Make sure that all the bugs in this product are resticted to this group
#	- Make sure admin can manage the units
#	- Make sure that the LMB users can see these products too.
#	- Log what has been done
#
# Limits of this script:
#	- DO NOT RUN THIS SCRIPT MORE THAN ONCE!
#
# The logic for this script is:
# If there is no group_type = 38 for this product, then create the group.
#
# THERE IS NO NEED FOR ANY MANUAL INPUT OF VARIABLE HERE:
# THE SCRIPT IDENTIFY THE UNITS THAT MATCH THE ABOVE CRITERIA
#
########################################################################
#
# Generic information regardless of the product
#
########################################################################

# Info about this script
	SET @script = 'bug_fix_issue_15_LMB_units_visible_in_search_multiple_units.sql';

# Timestamp	
	SET @timestamp = NOW();

# BZ user id of the user that is creating the unit 
	#	 For LMB units, we use 2 (support.nobody)
	SET @creator_bz_id = 2;

# The BZ group that you want to associat to the unit.
	# BZ user groupid of the user that you want to associate to the unit.
	# 47: access all LMB units
	SET @bz_user_group_id = 47;	

# table that we will need
	# We need to do a few things via a temporary table to make sure there are no dupes
		CREATE TEMPORARY TABLE IF NOT EXISTS `bug_group_map_temp` AS (SELECT * FROM `bug_group_map`);
		CREATE TEMPORARY TABLE IF NOT EXISTS `ut_group_group_map_temp` AS (SELECT * FROM `group_group_map`);

# We need to list the products where there is no group to restrict access to the units

	/*Table structure for table `ut_fix_15_product_to_update` */
	DROP TABLE IF EXISTS `ut_fix_15_product_to_update`;

	CREATE TABLE `ut_fix_15_product_to_update` (
	  `id_record` INT(11) NOT NULL AUTO_INCREMENT,
	  `product_id` SMALLINT(6) NOT NULL COMMENT 'The id in the ''products'' table',
	  PRIMARY KEY (`id_record`)
	) ENGINE=INNODB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
	
	# We insert all the product_id where we have no groupe_type = 38
	INSERT INTO `ut_fix_15_product_to_update`
		(`product_id`)
		SELECT `id` FROM `products` 
			WHERE `id` NOT IN (SELECT `product_id` FROM `ut_product_group` WHERE `group_type_id` = 38) 
			AND `id` != 1;
		
# Disable the FK check for the moment
			
/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;	
		
########################################################################
#
#	Create a procedure that will do the update                         #
#
########################################################################

# How many records do we need to process?
	SET @max_loops = (SELECT MAX(`id_record`) FROM `ut_fix_15_product_to_update`);

DELIMITER $$
	DROP PROCEDURE IF EXISTS insert_missing_group_see_unit$$
	CREATE PROCEDURE insert_missing_group_see_unit()
		BEGIN
		DECLARE number_of_loops INT DEFAULT 1;
		WHILE number_of_loops < (@max_loops +1) DO

	# BZ product_id for the unit
		SET @product_id = (SELECT `product_id` FROM `ut_fix_15_product_to_update` WHERE `id_record` = number_of_loops);
		
	# We need a new group for that product to allow user to see the unit in the search

		# Group Id
			SET @can_see_unit_in_search_group_id = ((SELECT MAX(`id`) FROM `groups`) + 1);
			
		# Group name:
			SET @unit = (SELECT `name` FROM `products` WHERE `id` = @product_id);
			
			SET @unit_for_query = REPLACE(@unit,' ','%');
			
			SET @unit_for_flag = REPLACE(@unit_for_query,'%','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'-','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'!','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'@','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'#','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'$','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'%','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'^','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'&','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'*','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'(','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,')','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'+','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'=','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'<','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'>','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,':','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,';','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'"','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,',','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'.','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'?','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'/','_');
			SET @unit_for_flag = REPLACE(@unit_for_flag,'\\','_');
			
			SET @unit_for_group = REPLACE(@unit_for_flag,'_','-');
			SET @unit_for_group = REPLACE(@unit_for_group,'----','-');
			SET @unit_for_group = REPLACE(@unit_for_group,'---','-');
			SET @unit_for_group = REPLACE(@unit_for_group,'--','-');
			
			SET @group_name_can_see_unit_in_search_group = (CONCAT(@unit_for_group,'-00-Can-See-Unit-In-Search'));
			
		# Group description
			SET @group_description_can_see_unit_in_search_group = 'User can see the unit in the search panel';


		# We can populate the 'groups' table now.
			INSERT INTO `groups`
				(`id`
				,`name`
				,`description`
				,`isbuggroup`
				,`userregexp`
				,`isactive`
				,`icon_url`
				) 
				VALUES 
				(@can_see_unit_in_search_group_id, @group_name_can_see_unit_in_search_group, @group_description_can_see_unit_in_search_group, 1, '', 1, NULL)
				;

		# Log the actions of the script.
			SET @script_log_message = CONCAT('We have created the groups that we will need for that unit #'
									, @product_id
									, '\r\ - To grant '
									, 'See unit in search panel'
									, ' privileges. Group_id: '
									, (SELECT IFNULL(@can_see_unit_in_search_group_id, 'can_see_unit_in_search_group_id is NULL'))
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(NOW(), @script, @script_log_message)
				;
			
			SET @script_log_message = NULL;


	# We update the BZ logs
		INSERT INTO `audit_log`
			(`user_id`
			,`class`
			,`object_id`
			,`field`
			,`removed`
			,`added`
			,`at_time`
			) 
			VALUES 
			(@creator_bz_id, 'Bugzilla::Group', @can_see_unit_in_search_group_id, '__create__', NULL, @group_name_can_see_unit_in_search_group, @timestamp)
			;
			
	# We record the groups we have just created for future reference:
		INSERT INTO `ut_product_group`
			(
			product_id
			,component_id
			,group_id
			,group_type_id
			,role_type_id
			,created_by_id
			,created
			)
			VALUES
			(@product_id,NULL,@can_see_unit_in_search_group_id,38,NULL,@creator_bz_id,@timestamp)
			;

	# We make sure that only user in this group can see the unit in the search.
		INSERT INTO `group_control_map`
			(`group_id`
			,`product_id`
			,`entry`
			,`membercontrol`
			,`othercontrol`
			,`canedit`
			,`editcomponents`
			,`editbugs`
			,`canconfirm`
			) 
			VALUES 
			(@can_see_unit_in_search_group_id,@product_id,0,3,3,0,0,0,0)
			;

		# Log the actions of the script.
			SET @script_log_message = CONCAT('We have updated the group control permissions for the product# '
									, @product_id
									, ': '
									, '\r\ - Can See unit in Search (#'
									, (SELECT IFNULL(@group_id_show_to_tenant, 'group_id_show_to_tenant is NULL'))
									, ').'
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(NOW(), @script, @script_log_message)
				;
			
			SET @script_log_message = NULL;
			
	# We limit the bug/case to this group.

		# Insert records in the temporary table
			INSERT INTO `bug_group_map_temp`
				( `bug_id`
				, `group_id`
				)
				SELECT 
				`bugs`.`bug_id`
				, @can_see_unit_in_search_group_id
				FROM `bugs`
				WHERE (`bugs`.`product_id` = @product_id)
				;
				
		# Truncate the table 
			TRUNCATE TABLE `bug_group_map`;
			
		# Populate the table with the latest records
			INSERT INTO `bug_group_map`
				SELECT 
				`bug_id`
				, `group_id`
				FROM 
					`bug_group_map_temp`
				GROUP BY `bug_id`
					, `group_id`
				; 

		# Log the actions of the script.
			
			SET @nber_of_cases = (SELECT COUNT(`bug_id`) FROM `bugs` WHERE (`product_id` = @product_id) GROUP BY `product_id`);
		
			SET @script_log_message = CONCAT('We have restricted the '
									, @nber_of_cases
									, ' cases in the product# '
									, @product_id
									, ' to the group #'
									, (SELECT IFNULL(@group_id_show_to_tenant, 'group_id_show_to_tenant is NULL'))
									)
									;
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(NOW(), @script, @script_log_message)
				;
			
			SET @script_log_message = NULL;

	# We prepare the group permissions:
		# Data for the table `group_group_map`
		# We use a temporary table to do this, this is to avoid duplicate in the group_group_map table

		# Add the new records
		INSERT INTO `ut_group_group_map_temp`
			(`member_id`
			,`grantor_id`
			,`grant_type`
			) 
		##########################################################
		# Logic:
		# If you are a member of group_id XXX (ex: 1 / Admin) 
		# then you have the following permissions:
		# 	- 0: You are automatically a member of group ZZZ
		#	- 1: You can grant access to group ZZZ
		#	- 2: You can see users in group ZZZ
		##########################################################
			VALUES 
			# Admin group can grant membership to all
			(1,@can_see_unit_in_search_group_id,1)
			
			# Admin should be able to see that unit too
			, (1,@can_see_unit_in_search_group_id,0)
			
			# We then make the user group for all LMB units a member of the new group
			, (@bz_user_group_id,@can_see_unit_in_search_group_id, 0)
			;

		
	# Increment the number of loops
			SET number_of_loops = (number_of_loops + 1);
		END WHILE;
	END$$
DELIMITER ;

# Call the procedure to update the groups.

	CALL insert_missing_group_see_unit;	
		
		
# We give the user in the group LMB All units the permission they need to access the cases and units.
		
	# Update the bug_group_map table		
		# Truncate the table 
			TRUNCATE TABLE `bug_group_map`;
			
		# Populate the table with the latest records
			INSERT INTO `bug_group_map`
				SELECT 
				`bug_id`
				, `group_id`
				FROM 
					`bug_group_map_temp`
				GROUP BY `bug_id`
					, `group_id`
				; 

	# Update the actual `group_group_map` table
	
		# We truncate the table first (to avoid duplicates)
		TRUNCATE TABLE `group_group_map`;
		
		# We insert the data we need
		# Grouping like this makes sure that we have no dupes!
		INSERT INTO `group_group_map`
		SELECT `member_id`
			, `grantor_id`
			, `grant_type`
		FROM
			`ut_group_group_map_temp`
		GROUP BY `member_id`
			, `grantor_id`
			, `grant_type`
		;
			
#Clean up
	
	# Drop the table as we do not need it anymore
		DROP TABLE IF EXISTS `bug_group_map_temp`;

	# We Delete the temp table as we do not need it anymore
		DROP TABLE IF EXISTS `ut_group_group_map_temp`;
		
	# The Table that records the products we need to update
		DROP TABLE IF EXISTS `ut_fix_15_product_to_update`;
	
	# We drop the procedure we created.
		DROP PROCEDURE IF EXISTS insert_missing_group_see_unit;
		
# We implement the FK checks again
		
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;		
	
		