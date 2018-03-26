# For any question about this script, ask Franck

#############################################
#											#
# IMPORTANT INFORMATION ABOUT THIS SCRIPT	#
#											#
#############################################
#
# Built for BZFE database v2.13 to v2.19
#
# Use this script only if the Classification/Group of units DOES NOT EXIST YET in the BZFE
#
# The Name for the group of unit has to be unique si it will use the Classification id as a unique identifier
#
# Classification name are varchar (64) in the BZ table
# Classification description are mediumtext in the BZ table
#
#
#################################################################
#																#
# UPDATE THE BELOW VARIABLES ACCORDING TO YOUR NEEDS			#
#																#
#################################################################

# The name 
	SET @unit_group_name = 'TEST - New Group of Units';
	
# The description
	SET @unit_group_description = 'More information about the Unit Group';

########################################################################
#
#	ALL THE VARIABLES WE NEED HAVE BEEN DEFINED, WE CAN RUN THE SCRIPT #
#
########################################################################

# Info about this script
	SET @script = '1_Insert_new_classification_in_unee-t_bzfe_v2.19.sql';

# Get the classification id for the new group of units.
	SET @classification_id = ((SELECT MAX(`id`) FROM `classifications`) + 1);
	
# Create the unique name for the group of units
	SET @unit_group = CONCAT(@unit_group_name, ' - ', @classification_id);

# Insert the data
	INSERT INTO `classifications`
		(`id`
		,`name`
		,`description`
		)
		VALUES
		(@classification_id,@unit_group,@unit_group_description);

# Log the actions of the script.

		SET @script_log_message = CONCAT('the new group of unit #'
								, @classification_id,
								' has been created.'
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