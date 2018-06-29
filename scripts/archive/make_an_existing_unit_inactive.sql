# For any question about this script, ask Franck
# 
# This script will make an existing unit inactive.
#
#################################################################
#																#
# UPDATE THE BELOW VARIABLES ACCORDING TO YOUR NEEDS			#
#																#
#################################################################
#
# The unit: What is the id of the unit in the table 'ut_data_to_create_units'
	SET @product_id = 'bz_id_of_the_product_you_want_to_make_inactive'; 
#
# The time when we are making this change	
	SET @inactive_when = 'the timestamp for the audit log';
#	
# Which is the BZ user who is initiating this change?	
	SET @creator_bz_id = 'bz_user_id_of_the_user_who_makes_the_change';
#	
########################################################################
#
#	ALL THE VARIABLES WE NEED HAVE BEEN DEFINED, WE CAN RUN THE SCRIPT #
#
########################################################################


# Info about this script
	SET @script = 'make_an_existing_unit_inactive.sql';
	
# Timestamp	
	SET @timestamp = NOW();

# Make a unit inactive
	UPDATE `products`
		SET `isactive` = '0'
		WHERE `id` = @product_id
	;
	
# Record the actions of this script in the ut_log

		# Log the actions of the script.
			SET @script_log_message = CONCAT('the Unit #'
									, @product_id
									, ' is inactive. It is not possible to create new cases in this unit.'
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
				 (@timestamp ,@bzfe_table, 'isactive', '1', '0', @script, @script_log_message)
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
		(@creator_bz_id
		, 'Bugzilla::Product'
		, @product_id
		, 'isactive'
		, '1'
		, '0'
		, @inactive_when
		)
		;