####################################################################################
#
# We MUST use at least Aurora MySQl 5.7.22+ if you want 
# to be able to use the Lambda function Unee-T depends on to work as intended
#
# Alternativey if you do NOT need to use the Lambda function, it is possible to use
#	- MySQL 5.7.22 +
#	- MariaDb 10.2.3 +
#
####################################################################################
#
# For any question about this script, ask Franck
#
###################################################################################
#
# Make sure to also update the below variable(s)
#
###################################################################################
#
# What are the version of the Unee-T BZ Database schema BEFORE and AFTER this update?
	SET @old_schema_version = 'v4.36.0';
	SET @new_schema_version = 'v5.37.0';
#
# What is the name of this script?
	SET @this_script = CONCAT ('upgrade_unee-t_', @old_schema_version, '_to_', @new_schema_version, '.sql');
#
###############################
#
# We have everything we need
#
###############################
# In this update
#	- Re-organize the Case Categories (rep_platform) and Case Sub-categories/Case types (cf_ipi_clust_6_claim_type)
#	- Migrate data for existing bugs from old case categories/case types to new case categories/case types.
#
#
#####################
#
# Do it!
#
#####################

# When are we doing this?
	SET @the_timestamp = NOW();

# The case categories:

	# Create the new case categories

		INSERT INTO `rep_platform`(`id`, `value`, `sortkey`, `isactive`, `visibility_value_id`) VALUES ('16', 'Structural', '30', '1', NULL);
		INSERT INTO `rep_platform`(`id`, `value`, `sortkey`, `isactive`, `visibility_value_id`) VALUES ('13', 'Electrical', '15', '1', NULL);
		INSERT INTO `rep_platform`(`id`, `value`, `sortkey`, `isactive`, `visibility_value_id`) VALUES ('12', 'Appliances/Equipment', '10', '1', NULL);
		INSERT INTO `rep_platform`(`id`, `value`, `sortkey`, `isactive`, `visibility_value_id`) VALUES ('11', 'Furnitures/Fixtures', '5', '1', NULL);
		INSERT INTO `rep_platform`(`id`, `value`, `sortkey`, `isactive`, `visibility_value_id`) VALUES ('15', 'Aircon/Heating', '25', '1', NULL);
		INSERT INTO `rep_platform`(`id`, `value`, `sortkey`, `isactive`, `visibility_value_id`) VALUES ('14', 'Plumbing', '20', '1', NULL);

	# Update the existing case categories

		UPDATE `rep_platform` SET `id`='7', `value`='Projects', `sortkey`='50', `isactive`='1', `visibility_value_id`=NULL  WHERE (`id` = 7) ;
		UPDATE `rep_platform` SET `id`='5', `value`='Devices', `sortkey`='9999', `isactive`='0', `visibility_value_id`=NULL  WHERE (`id` = 5) ;
		UPDATE `rep_platform` SET `id`='1', `value`='---', `sortkey`='0', `isactive`='1', `visibility_value_id`=NULL  WHERE (`id` = 1) ;
		UPDATE `rep_platform` SET `id`='10', `value`='Other', `sortkey`='55', `isactive`='1', `visibility_value_id`=NULL  WHERE (`id` = 10) ;
		UPDATE `rep_platform` SET `id`='4', `value`='Housekeeping', `sortkey`='35', `isactive`='1', `visibility_value_id`=NULL  WHERE (`id` = 4) ;
		UPDATE `rep_platform` SET `id`='3', `value`='Maintenance', `sortkey`='9999', `isactive`='0', `visibility_value_id`=NULL  WHERE (`id` = 3) ;
		UPDATE `rep_platform` SET `id`='2', `value`='Repair', `sortkey`='9999', `isactive`='0', `visibility_value_id`=NULL  WHERE (`id` = 2) ;
		UPDATE `rep_platform` SET `id`='6', `value`='Renovation', `sortkey`='9999', `isactive`='0', `visibility_value_id`=NULL  WHERE (`id` = 6) ;

# The case types:

	# Create the new case types

		INSERT INTO `cf_ipi_clust_6_claim_type`(`id`, `value`, `sortkey`, `isactive`, `visibility_value_id`) VALUES ('71', 'Extra Furnitures/Fixtures', '210', '1', '8');
		INSERT INTO `cf_ipi_clust_6_claim_type`(`id`, `value`, `sortkey`, `isactive`, `visibility_value_id`) VALUES ('69', 'Water', '310', '1', '9');
		INSERT INTO `cf_ipi_clust_6_claim_type`(`id`, `value`, `sortkey`, `isactive`, `visibility_value_id`) VALUES ('68', 'Other', '999', '1', NULL);
		INSERT INTO `cf_ipi_clust_6_claim_type`(`id`, `value`, `sortkey`, `isactive`, `visibility_value_id`) VALUES ('67', 'Security', '520', '1', '10');
		INSERT INTO `cf_ipi_clust_6_claim_type`(`id`, `value`, `sortkey`, `isactive`, `visibility_value_id`) VALUES ('66', 'Replace', '15', '1', NULL);
		INSERT INTO `cf_ipi_clust_6_claim_type`(`id`, `value`, `sortkey`, `isactive`, `visibility_value_id`) VALUES ('65', 'Maintenance', '10', '1', NULL);
		INSERT INTO `cf_ipi_clust_6_claim_type`(`id`, `value`, `sortkey`, `isactive`, `visibility_value_id`) VALUES ('64', 'Repair', '5', '1', NULL);
		INSERT INTO `cf_ipi_clust_6_claim_type`(`id`, `value`, `sortkey`, `isactive`, `visibility_value_id`) VALUES ('70', 'Renovation', '425', '1', '7');

	# Update the existing case types:

		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='9', `value`='Other Rep', `sortkey`='9999', `isactive`='0', `visibility_value_id`='2'  WHERE (`id` = 9) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='10', `value`='Aircon M', `sortkey`='9999', `isactive`='0', `visibility_value_id`='3'  WHERE (`id` = 10) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='11', `value`='Equipment M', `sortkey`='9999', `isactive`='0', `visibility_value_id`='3'  WHERE (`id` = 11) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='12', `value`='Plumbing M', `sortkey`='9999', `isactive`='0', `visibility_value_id`='3'  WHERE (`id` = 12) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='13', `value`='Battery repl.', `sortkey`='9999', `isactive`='0', `visibility_value_id`='3'  WHERE (`id` = 13) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='14', `value`='Other M', `sortkey`='9999', `isactive`='0', `visibility_value_id`='3'  WHERE (`id` = 14) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='15', `value`='Linens', `sortkey`='110', `isactive`='1', `visibility_value_id`='4'  WHERE (`id` = 15) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='16', `value`='Textile', `sortkey`='115', `isactive`='1', `visibility_value_id`='4'  WHERE (`id` = 16) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='17', `value`='Curtains', `sortkey`='120', `isactive`='1', `visibility_value_id`='4'  WHERE (`id` = 17) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='18', `value`='Cleaning', `sortkey`='105', `isactive`='1', `visibility_value_id`='4'  WHERE (`id` = 18) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='19', `value`='Other H', `sortkey`='9999', `isactive`='0', `visibility_value_id`='4'  WHERE (`id` = 19) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='20', `value`='Key', `sortkey`='9999', `isactive`='0', `visibility_value_id`='5'  WHERE (`id` = 20) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='21', `value`='Resident Card', `sortkey`='9999', `isactive`='0', `visibility_value_id`='5'  WHERE (`id` = 21) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='22', `value`='Car Transponder', `sortkey`='9999', `isactive`='0', `visibility_value_id`='5'  WHERE (`id` = 22) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='23', `value`='Kitchen Utensils', `sortkey`='9999', `isactive`='0', `visibility_value_id`='5'  WHERE (`id` = 23) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='24', `value`='Furniture D', `sortkey`='9999', `isactive`='0', `visibility_value_id`='5'  WHERE (`id` = 24) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='25', `value`='Safe box', `sortkey`='9999', `isactive`='0', `visibility_value_id`='5'  WHERE (`id` = 25) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='26', `value`='Equipment D', `sortkey`='9999', `isactive`='0', `visibility_value_id`='5'  WHERE (`id` = 26) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='27', `value`='Other D', `sortkey`='9999', `isactive`='0', `visibility_value_id`='5'  WHERE (`id` = 27) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='28', `value`='Structural Defect', `sortkey`='9999', `isactive`='0', `visibility_value_id`='6'  WHERE (`id` = 28) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='29', `value`='Carpentry Ren', `sortkey`='9999', `isactive`='0', `visibility_value_id`='6'  WHERE (`id` = 29) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='30', `value`='Parquet Polishing', `sortkey`='9999', `isactive`='0', `visibility_value_id`='6'  WHERE (`id` = 30) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='31', `value`='Painting', `sortkey`='9999', `isactive`='0', `visibility_value_id`='6'  WHERE (`id` = 31) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='32', `value`='Other Ren', `sortkey`='9999', `isactive`='0', `visibility_value_id`='6'  WHERE (`id` = 32) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='33', `value`='Set Up', `sortkey`='405', `isactive`='1', `visibility_value_id`='7'  WHERE (`id` = 33) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='34', `value`='Light Renovation', `sortkey`='420', `isactive`='1', `visibility_value_id`='7'  WHERE (`id` = 34) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='35', `value`='Refurbishing', `sortkey`='410', `isactive`='1', `visibility_value_id`='7'  WHERE (`id` = 35) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='8', `value`='Cable TV Rep', `sortkey`='9999', `isactive`='0', `visibility_value_id`='2'  WHERE (`id` = 8) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='37', `value`='Check', `sortkey`='415', `isactive`='1', `visibility_value_id`='7'  WHERE (`id` = 37) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='38', `value`='Store room Clearance', `sortkey`='9999', `isactive`='0', `visibility_value_id`='7'  WHERE (`id` = 38) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='39', `value`='Other CP', `sortkey`='9999', `isactive`='0', `visibility_value_id`='7'  WHERE (`id` = 39) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='40', `value`='Laundry', `sortkey`='225', `isactive`='1', `visibility_value_id`='8'  WHERE (`id` = 40) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='41', `value`='Ironing', `sortkey`='220', `isactive`='1', `visibility_value_id`='8'  WHERE (`id` = 41) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='42', `value`='Housekeeping', `sortkey`='215', `isactive`='1', `visibility_value_id`='8'  WHERE (`id` = 42) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='43', `value`='Cable Upgrade', `sortkey`='230', `isactive`='1', `visibility_value_id`='8'  WHERE (`id` = 43) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='44', `value`='Internet Upgrade', `sortkey`='235', `isactive`='1', `visibility_value_id`='8'  WHERE (`id` = 44) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='45', `value`='Beds', `sortkey`='9999', `isactive`='0', `visibility_value_id`='8'  WHERE (`id` = 45) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='46', `value`='Baby Cot', `sortkey`='9999', `isactive`='0', `visibility_value_id`='8'  WHERE (`id` = 46) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='47', `value`='Transportation', `sortkey`='240', `isactive`='1', `visibility_value_id`='8'  WHERE (`id` = 47) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='48', `value`='Welcome Basket', `sortkey`='9999', `isactive`='0', `visibility_value_id`='8'  WHERE (`id` = 48) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='49', `value`='Dish Washing', `sortkey`='9999', `isactive`='0', `visibility_value_id`='8'  WHERE (`id` = 49) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='50', `value`='Other ES', `sortkey`='9999', `isactive`='0', `visibility_value_id`='8'  WHERE (`id` = 50) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='51', `value`='NOT SPECIFIED', `sortkey`='200', `isactive`='1', `visibility_value_id`='8'  WHERE (`id` = 51) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='52', `value`='Electricity', `sortkey`='305', `isactive`='1', `visibility_value_id`='9'  WHERE (`id` = 52) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='53', `value`='Gas', `sortkey`='315', `isactive`='1', `visibility_value_id`='9'  WHERE (`id` = 53) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='54', `value`='Meter Reading', `sortkey`='9999', `isactive`='0', `visibility_value_id`='9'  WHERE (`id` = 54) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='55', `value`='Other U', `sortkey`='9999', `isactive`='0', `visibility_value_id`='9'  WHERE (`id` = 55) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='56', `value`='Internet', `sortkey`='320', `isactive`='1', `visibility_value_id`='9'  WHERE (`id` = 56) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='57', `value`='Cable', `sortkey`='325', `isactive`='1', `visibility_value_id`='9'  WHERE (`id` = 57) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='58', `value`='Viewing', `sortkey`='525', `isactive`='1', `visibility_value_id`='10'  WHERE (`id` = 58) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='59', `value`='Other_obsolete', `sortkey`='9999', `isactive`='0', `visibility_value_id`='10'  WHERE (`id` = 59) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='60', `value`='Early/Late', `sortkey`='245', `isactive`='1', `visibility_value_id`='8'  WHERE (`id` = 60) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='61', `value`='Early Check IN/OUT', `sortkey`='9999', `isactive`='0', `visibility_value_id`='8'  WHERE (`id` = 61) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='62', `value`='High Chair', `sortkey`='9999', `isactive`='0', `visibility_value_id`='8'  WHERE (`id` = 62) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='63', `value`='Equipment', `sortkey`='9999', `isactive`='0', `visibility_value_id`='2'  WHERE (`id` = 63) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='7', `value`='Internet Rep', `sortkey`='9999', `isactive`='0', `visibility_value_id`='2'  WHERE (`id` = 7) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='6', `value`='Carpentry Rep', `sortkey`='9999', `isactive`='0', `visibility_value_id`='2'  WHERE (`id` = 6) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='5', `value`='Furniture Rep', `sortkey`='9999', `isactive`='0', `visibility_value_id`='2'  WHERE (`id` = 5) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='4', `value`='Aircon Rep', `sortkey`='9999', `isactive`='0', `visibility_value_id`='2'  WHERE (`id` = 4) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='3', `value`='Plumbing Rep', `sortkey`='9999', `isactive`='0', `visibility_value_id`='2'  WHERE (`id` = 3) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='2', `value`='Electrical', `sortkey`='9999', `isactive`='0', `visibility_value_id`='2'  WHERE (`id` = 2) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='36', `value`='Hand Over', `sortkey`='430', `isactive`='1', `visibility_value_id`='7'  WHERE (`id` = 36) ;
		UPDATE `cf_ipi_clust_6_claim_type` SET `id`='1', `value`='---', `sortkey`='0', `isactive`='1', `visibility_value_id`=NULL  WHERE (`id` = 1) ;

# Update the bugs so that they use the new categories and case types


# Update the audit logs so that the history of the case is correct and reflects the new categories.





# We temporarily disable the auto counter for active units:

# Un-comment the below code to re-enable the trigger

/*
#DELIMITER $$
#CREATE TRIGGER `update_the_log_of_enabled_units_when_unit_is_created`
#	AFTER INSERT ON `products`
#	FOR EACH ROW
#  BEGIN
#	CALL `update_log_count_enabled_units`;
#END;
#$$
#DELIMITER ;
*/

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