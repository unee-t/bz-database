# For any question about this script, ask Franck

#############################################
#											#
# IMPORTANT INFORMATION ABOUT THIS SCRIPT	#
#											#
#############################################
#
# Rewrtitten for BZFE Db v3.20
#
# This script invites several BZ user to a unit 
#   - Users have been manually added to the table `ut_invitation_api_data`
#   - The MEFE invitation id for thes user is like `n` Where n is a unique id for the manual invitation.
#   
#
# What this script will do:
#   - Create a temporary table `ut_temp_data_to_add_user_to_a_role` to identify all the record which need to be processed
#       - `mefe_invitation_id` is like 'manualInsert%'
#       AND
#       - `processed_datetime` is null
#   - Loop through the table `ut_temp_data_to_add_user_to_a_role`
#   - Call the Procedure `add_user_to_role_in_unit` to process the invitation for each invitation
#   - Cleanup: Delete the procedure and objects we do not need

# Info about this script

	SET @script = 'Mass_add_existing_bz_users_to_an_existing_role_in_an_existing_unit_bzfe_v3.19+.sql';

# Timestamp	

	SET @timestamp = NOW();

# We create the table which lists the invitations we need to process:
	/*Table structure for table `ut_temp_data_to_add_user_to_a_role` */
		DROP TABLE IF EXISTS `ut_temp_data_to_add_user_to_a_role`;

		CREATE TABLE `ut_temp_data_to_add_user_to_a_role` (
		  `token` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'token of the record to process',
		  `mefe_invitation_id` varchar(256) NOT NULL COMMENT 'The unique Id for the invitation that was generated manually to do the data import',
		  PRIMARY KEY (`token`)
		) ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
		
	# We populate this table with the data where there are no information
		INSERT INTO `ut_temp_data_to_add_user_to_a_role`
			(`mefe_invitation_id`
			)

		SELECT `mefe_invitation_id`
		FROM `ut_invitation_api_data`
		WHERE `processed_datetime` IS NULL
            AND `mefe_invitation_id` LIKE 'manualInsert%'
		ORDER BY `mefe_invitation_id` ASC
		;

# How many records do we need to process?

	SET @max_loops = (SELECT MAX(`token`) FROM `ut_temp_data_to_add_user_to_a_role`);

# We have all the elements we need, we can create the procedure to loop around the records to process

    DROP PROCEDURE IF EXISTS mass_add_user_to_role;

DELIMITER &&
CREATE PROCEDURE mass_add_user_to_role()
BEGIN
DECLARE number_of_loops INT DEFAULT 1;
WHILE number_of_loops < (@max_loops +1) DO

# The record that we need to process in this loop
	SET @mefe_invitation_id = (SELECT `mefe_invitation_id` 
        FROM `ut_temp_data_to_add_user_to_a_role` 
        WHERE `token` = number_of_loops
        )
        ;

    # We call the procedure to add a user to a role in a unit
    # This procedure needs the follwing variables:
    #   - @mefe_invitation_id
    #   - @environment

        CALL `add_user_to_role_in_unit`;
			
	# Increment the number of loops
			SET number_of_loops = (number_of_loops + 1);
		END WHILE;

	END&&
DELIMITER ;

# We call the procedure to do the Mass Update
    CALL `mass_add_user_to_role`;

# Clean Up: 	
    # Delete the table we do not need anymore

        DROP TABLE IF EXISTS `ut_temp_data_to_add_user_to_a_role`;

    # Drop the procedure as we will not need it on a regular basis

        DROP PROCEDURE IF EXISTS `mass_add_user_to_role`;