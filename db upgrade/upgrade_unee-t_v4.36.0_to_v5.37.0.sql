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

# Make the Fied `Action For` Obsolete

	# Make the field obsolete

		UPDATE `fielddefs` SET `id`='72', `name`='cf_ipi_clust_3_roadbook_for', `type`='3', `custom`='1', `description`='Action For', `long_desc`='In whose roadbook shall Field Action appear? This can change over time. It is possible to choose more than 1 person if needed.', `mailhead`='0', `sortkey`='3235', `obsolete`='1', `enter_bug`='0', `buglist`='1', `visibility_field_id`=NULL, `value_field_id`=NULL, `reverse_desc`=NULL, `is_mandatory`='0', `is_numeric`='0'  WHERE (`id` = 72) ;

	# No need to record field visibility information

		DELETE FROM `field_visibility` where `field_id` = '72' and `value_id` = '2';

# Add Hmlet to the list of organization with custom fields

	INSERT INTO `cf_specific_for`(`id`, `value`, `sortkey`, `isactive`, `visibility_value_id`) VALUES ('3', 'Hmlet', '5', '1', NULL);

# Make the LMB organization obsolete

	UPDATE `cf_specific_for` SET `id`='2', `value`='LMB', `sortkey`='9999', `isactive`='0', `visibility_value_id`=NULL  WHERE (`id` = 2) ;

# Create a new series of custom fields for specific organizations

	# `cf_ut_org_specific_dd_1`
	# This is to store the legacy information from previous case types/case categories

		# Add the field to the `bugs` table

			ALTER TABLE `bugs` 
				ADD COLUMN `cf_ut_org_specific_dd_1` varchar(64) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '---' after `cf_specific_for` 
				;

		# Create the table to store the information 

			CREATE TABLE `cf_ut_org_specific_dd_1`(
				`id` smallint(6) NOT NULL auto_increment , 
				`value` varchar(64) COLLATE utf8mb4_unicode_520_ci NOT NULL  , 
				`sortkey` smallint(6) NOT NULL DEFAULT 0 , 
				`isactive` tinyint(4) NOT NULL DEFAULT 1 , 
				`visibility_value_id` smallint(6) NULL  , 
				PRIMARY KEY (`id`) , 
				UNIQUE KEY `cf_ut_org_specific_dd_1_value_idx`(`value`) , 
				KEY `cf_ut_org_specific_dd_1_visibility_value_id_idx`(`visibility_value_id`) , 
				KEY `cf_ut_org_specific_dd_1_sortkey_idx`(`sortkey`,`value`) 
			) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_unicode_520_ci';

		# Add the values we need for the table `cf_ut_org_specific_dd_1`

			INSERT INTO `cf_ut_org_specific_dd_1`
				(`id`
				,`value`
				,`sortkey`
				,`isactive`
				,`visibility_value_id`
				) 
				VALUES
					(1,'---',0,1,NULL),
					(2,'Extra Service - Early check IN/OUT',5,1,NULL),
					(3,'Extra Service - Late check IN/OUT',10,1,NULL),
					(4,'Extra Service - Dish Washing',15,1,NULL),
					(5,'Extra Service - Welcome Basket',20,1,NULL),
					(6,'Extra Service - Baby Cot',25,1,NULL),
					(7,'Extra Service - Beds',30,1,NULL),
					(8,'Extra Service - High Chair',35,1,NULL),
					(9,'Utilities - Meter Reading',100,1,NULL),
					(10,'Repair - Carpentry Rep',200,1,NULL),
					(11,'Complex Project - Store room Clearance',300,1,NULL),
					(12,'Devices - Key',400,1,NULL),
					(13,'Devices - Resident Card',405,1,NULL),
					(14,'Devices - Car Transponder',410,1,NULL),
					(15,'Devices - Kitchen Utensils',415,1,NULL),
					(16,'Devices - Furniture',420,1,NULL),
					(17,'Devices - Safe box',425,1,NULL),
					(18,'Devices - Equipment',430,1,NULL),
					(19,'Devices - Other D',435,1,NULL),
					(20,'Renovation - Structural Defect',500,1,NULL),
					(21,'Renovation - Carpentry Ren',505,1,NULL),
					(22,'Renovation - Parquet Polishing',510,1,NULL),
					(23,'Renovation - Painting',515,1,NULL),
					(24,'Renovation - Other Ren',520,1,NULL)
				;

		# Make sure we have a fielddef

			INSERT INTO `fielddefs`(`id`, `name`, `type`, `custom`, `description`, `long_desc`, `mailhead`, `sortkey`, `obsolete`, `enter_bug`, `buglist`, `visibility_field_id`, `value_field_id`, `reverse_desc`, `is_mandatory`, `is_numeric`) 
				VALUES ('93', 'cf_ut_org_specific_dd_1', '2', '1', 'Legacy Case Types', 'The case category or type that were made obsolete on 01 June 2019', '0', '6200', '0', '0', '1', '92', NULL, NULL, '0', '0')
				;

		# Make sure Field visibility is correctly set

			INSERT INTO `field_visibility`(`field_id`, `value_id`) values('93' , '3');

	# `cf_ut_org_specific_dd_2`
	# This is to store specific advanced categories that are needed by a given organization

# We disable the FK checks for that part

	SET FOREIGN_KEY_CHECKS = 0 ;

# Cleanup the orders of the custom fields

	UPDATE `fielddefs` SET `id`='91', `name`='cf_ipi_clust_8_spe_customer', `type`='1', `custom`='1', `description`='Customer', `long_desc`='The name of the customer. IN Unee-T WE USE THE CUSTOMER ID INSTEAD', `mailhead`='0', `sortkey`='6100', `obsolete`='0', `enter_bug`='0', `buglist`='1', `visibility_field_id`='92', `value_field_id`=NULL, `reverse_desc`=NULL, `is_mandatory`='0', `is_numeric`='0'  WHERE (`id` = 91) ;
	UPDATE `fielddefs` SET `id`='90', `name`='cf_ipi_clust_7_spe_contractor_payment', `type`='4', `custom`='1', `description`='Contractor Payment', `long_desc`='Use this if the supplier has specific requirement about the payment. Accounting will use this to explain to the supplier why we have invoiced/paid him that way...', `mailhead`='0', `sortkey`='6040', `obsolete`='0', `enter_bug`='0', `buglist`='1', `visibility_field_id`='92', `value_field_id`=NULL, `reverse_desc`=NULL, `is_mandatory`='0', `is_numeric`='0'  WHERE (`id` = 90) ;
	UPDATE `fielddefs` SET `id`='89', `name`='cf_ipi_clust_7_spe_payment_type', `type`='2', `custom`='1', `description`='Payment Type', `long_desc`='How will we pay the contractor? This is important information so that accounting can prepare the payment accordingly. This will ensure we pay our supplier as fast as possible and minimize the risk of misunderstandings.', `mailhead`='0', `sortkey`='6035', `obsolete`='0', `enter_bug`='0', `buglist`='1', `visibility_field_id`='92', `value_field_id`=NULL, `reverse_desc`=NULL, `is_mandatory`='0', `is_numeric`='0'  WHERE (`id` = 89) ;
	UPDATE `fielddefs` SET `id`='88', `name`='cf_ipi_clust_7_spe_bill_number', `type`='1', `custom`='1', `description`='Bill Nber', `long_desc`='The Supplier\'s invoice number. This is so that accounting can easily find explanations about a supplier invoice if this is needed. IN Unee-T THIS HAS BEEN MOVED TO ATTACHMENTS', `mailhead`='0', `sortkey`='6030', `obsolete`='0', `enter_bug`='0', `buglist`='1', `visibility_field_id`='92', `value_field_id`=NULL, `reverse_desc`=NULL, `is_mandatory`='0', `is_numeric`='0'  WHERE (`id` = 88) ;
	UPDATE `fielddefs` SET `id`='87', `name`='cf_ipi_clust_5_spe_purchase_cost', `type`='1', `custom`='1', `description`='Purchase Cost', `long_desc`='What was the ACTUAL purchase cost for the purchase we did. This can be (and usually is) slightly different from the approved budget (but NOT higher than the approved budget).', `mailhead`='0', `sortkey`='6025', `obsolete`='0', `enter_bug`='0', `buglist`='1', `visibility_field_id`='92', `value_field_id`=NULL, `reverse_desc`=NULL, `is_mandatory`='0', `is_numeric`='0'  WHERE (`id` = 87) ;
	UPDATE `fielddefs` SET `id`='85', `name`='cf_ipi_clust_5_spe_contractor', `type`='4', `custom`='1', `description`='Contractor ID', `long_desc`='The name of the contractor that has been assigned to work on this case. IN Unee-T THIS HAS BEEN MOVED. THE CONTRACTOR IS A STAKEHOLDER.', `mailhead`='0', `sortkey`='6020', `obsolete`='0', `enter_bug`='0', `buglist`='1', `visibility_field_id`='92', `value_field_id`=NULL, `reverse_desc`=NULL, `is_mandatory`='0', `is_numeric`='0'  WHERE (`id` = 85) ;
	UPDATE `fielddefs` SET `id`='84', `name`='cf_ipi_clust_5_spe_approval_comment', `type`='4', `custom`='1', `description`='Approval Comment', `long_desc`='This is to explain/comment about the approval/rejection of what was requested. IN Unee-T IT\'S BETTER TO DO THIS WHEN WE APPROVE AN ATTACHMENT.', `mailhead`='0', `sortkey`='6015', `obsolete`='0', `enter_bug`='0', `buglist`='1', `visibility_field_id`='92', `value_field_id`=NULL, `reverse_desc`=NULL, `is_mandatory`='0', `is_numeric`='0'  WHERE (`id` = 84) ;
	UPDATE `fielddefs` SET `id`='83', `name`='cf_ipi_clust_5_spe_approval_for', `type`='4', `custom`='1', `description`='Approval For', `long_desc`='Explain why you require an approval. The approver will use this information to better understand the whole situtation. IN Unee-T IT\'S BETTER TO DO THIS WHEN YOU APPROVE AN ATTACHMENT', `mailhead`='0', `sortkey`='6010', `obsolete`='0', `enter_bug`='0', `buglist`='1', `visibility_field_id`='92', `value_field_id`=NULL, `reverse_desc`=NULL, `is_mandatory`='0', `is_numeric`='0'  WHERE (`id` = 83) ;
	UPDATE `fielddefs` SET `id`='81', `name`='cf_ipi_clust_5_spe_action_purchase_list', `type`='1', `custom`='1', `description`='Purchase List', `long_desc`='Enter the list of things that we need to purchase. If the list is too long, attach a file to the claim with the detailed list and only summarize what we need to purchase here. IN Unee-T IT\'S EASIER TO USE APPROVED ATTACHMENTS TO DO THIS', `mailhead`='0', `sortkey`='6005', `obsolete`='0', `enter_bug`='0', `buglist`='1', `visibility_field_id`='92', `value_field_id`=NULL, `reverse_desc`=NULL, `is_mandatory`='0', `is_numeric`='0'  WHERE (`id` = 81) ;
	UPDATE `fielddefs` SET `id`='72', `name`='cf_ipi_clust_3_roadbook_for', `type`='3', `custom`='1', `description`='Action For', `long_desc`='In whose roadbook shall Field Action appear? This can change over time. It is possible to choose more than 1 person if needed.', `mailhead`='0', `sortkey`='3235', `obsolete`='1', `enter_bug`='0', `buglist`='1', `visibility_field_id`=NULL, `value_field_id`=NULL, `reverse_desc`=NULL, `is_mandatory`='0', `is_numeric`='0'  WHERE (`id` = 72) ;
	UPDATE `fielddefs` SET `id`='92', `name`='cf_specific_for', `type`='2', `custom`='1', `description`='Field For', `long_desc`='The name and id of the Unee-T customer that can see these fields', `mailhead`='0', `sortkey`='6000', `obsolete`='0', `enter_bug`='0', `buglist`='1', `visibility_field_id`=NULL, `value_field_id`=NULL, `reverse_desc`=NULL, `is_mandatory`='0', `is_numeric`='0'  WHERE (`id` = 92) ;

# The case categories:

	# Create the new case categories

		INSERT INTO `rep_platform`(`id`, `value`, `sortkey`, `isactive`, `visibility_value_id`) VALUES ('16', 'Structural', '30', '1', NULL);
		INSERT INTO `rep_platform`(`id`, `value`, `sortkey`, `isactive`, `visibility_value_id`) VALUES ('13', 'Electrical', '15', '1', NULL);
		INSERT INTO `rep_platform`(`id`, `value`, `sortkey`, `isactive`, `visibility_value_id`) VALUES ('12', 'Appliances/Equipment', '10', '1', NULL);
		INSERT INTO `rep_platform`(`id`, `value`, `sortkey`, `isactive`, `visibility_value_id`) VALUES ('11', 'Furnitures/Fixtures', '5', '1', NULL);
		INSERT INTO `rep_platform`(`id`, `value`, `sortkey`, `isactive`, `visibility_value_id`) VALUES ('15', 'Aircon/Heating', '25', '1', NULL);
		INSERT INTO `rep_platform`(`id`, `value`, `sortkey`, `isactive`, `visibility_value_id`) VALUES ('14', 'Plumbing', '20', '1', NULL);
		INSERT INTO `rep_platform`(`id`, `value`, `sortkey`, `isactive`, `visibility_value_id`) VALUES ('17', 'Landscape', '35', '1', NULL);

	# Update the existing case categories

		UPDATE `rep_platform` SET `id`='1', `value`='---', `sortkey`='0', `isactive`='1', `visibility_value_id`=NULL  WHERE (`id` = 1) ;
		UPDATE `rep_platform` SET `id`='2', `value`='Repair', `sortkey`='9999', `isactive`='0', `visibility_value_id`=NULL  WHERE (`id` = 2) ;
		UPDATE `rep_platform` SET `id`='3', `value`='Maintenance', `sortkey`='9999', `isactive`='0', `visibility_value_id`=NULL  WHERE (`id` = 3) ;
		UPDATE `rep_platform` SET `id`='4', `value`='Housekeeping', `sortkey`='40', `isactive`='1', `visibility_value_id`=NULL  WHERE (`id` = 4) ;
		UPDATE `rep_platform` SET `id`='5', `value`='Devices', `sortkey`='9999', `isactive`='0', `visibility_value_id`=NULL  WHERE (`id` = 5) ;
		UPDATE `rep_platform` SET `id`='6', `value`='Renovation', `sortkey`='9999', `isactive`='0', `visibility_value_id`=NULL  WHERE (`id` = 6) ;
		UPDATE `rep_platform` SET `id`='7', `value`='Projects', `sortkey`='50', `isactive`='1', `visibility_value_id`=NULL  WHERE (`id` = 7) ;
		UPDATE `rep_platform` SET `id`='8', `value`='Extra Service', `sortkey`='45', `isactive`='1', `visibility_value_id`=NULL  WHERE (`id` = 8) ;
		UPDATE `rep_platform` SET `id`='9', `value`='Utilities', `sortkey`='60', `isactive`='1', `visibility_value_id`=NULL  WHERE (`id` = 9) ;
		UPDATE `rep_platform` SET `id`='10', `value`='Other', `sortkey`='55', `isactive`='1', `visibility_value_id`=NULL  WHERE (`id` = 10) ;

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

# We capture the legacy information for the case categories and types where we have no mapping

	# For "Extra Service - Early check IN/OUT"

		UPDATE `bugs`
			SET `cf_ut_org_specific_dd_1` = 'Extra Service - Early check IN/OUT'
			WHERE `rep_platform` = 'Extra Service'
				AND `cf_ipi_clust_6_claim_type` = 'Early Check IN/OUT'
			;

	# For "Extra Service - Late check IN/OUT"

		UPDATE `bugs`
			SET `cf_ut_org_specific_dd_1` = 'Extra Service - Late check IN/OUT'
			WHERE `rep_platform` = 'Extra Service'
				AND `cf_ipi_clust_6_claim_type` = 'Late Check IN/OUT'
			;

	# For "Extra Service - Dish Washing"

		UPDATE `bugs`
			SET `cf_ut_org_specific_dd_1` = 'Extra Service - Dish Washing'
			WHERE `rep_platform` = 'Extra Service'
				AND `cf_ipi_clust_6_claim_type` = 'Dish Washing'
			;

	# For "Extra Service - Welcome Basket"

		UPDATE `bugs`
			SET `cf_ut_org_specific_dd_1` = 'Extra Service - Welcome Basket'
			WHERE `rep_platform` = 'Extra Service'
				AND `cf_ipi_clust_6_claim_type` = 'Welcome Basket'
			;

	# For "Extra Service - Baby Cot"

		UPDATE `bugs`
			SET `cf_ut_org_specific_dd_1` = 'Extra Service - Baby Cot'
			WHERE `rep_platform` = 'Extra Service'
				AND `cf_ipi_clust_6_claim_type` = 'Baby Cot'
			;

	# For "Extra Service - Beds"

		UPDATE `bugs`
			SET `cf_ut_org_specific_dd_1` = 'Extra Service - Beds'
			WHERE `rep_platform` = 'Extra Service'
				AND `cf_ipi_clust_6_claim_type` = 'Beds'
			;

	# For "Extra Service - High Chair"

		UPDATE `bugs`
			SET `cf_ut_org_specific_dd_1` = 'Extra Service - High Chair'
			WHERE `rep_platform` = 'Extra Service'
				AND `cf_ipi_clust_6_claim_type` = 'High Chair'
			;

	# For "Utilities - Meter Reading"

		UPDATE `bugs`
			SET `cf_ut_org_specific_dd_1` = 'Utilities - Meter Reading'
			WHERE `rep_platform` = 'Utilities'
				AND `cf_ipi_clust_6_claim_type` = 'Meter Reading'
			;

	# For "Repair - Carpentry Rep"

		UPDATE `bugs`
			SET `cf_ut_org_specific_dd_1` = 'Repair - Carpentry Rep'
			WHERE `rep_platform` = 'Repair'
				AND `cf_ipi_clust_6_claim_type` = 'Carpentry Rep'
			;

	# For "Complex Project - Store room Clearance"

		UPDATE `bugs`
			SET `cf_ut_org_specific_dd_1` = 'Complex Project - Store room Clearance'
			WHERE `rep_platform` = 'Complex Project'
				AND `cf_ipi_clust_6_claim_type` = 'Store room Clearance'
			;

	# For "Complex Project - Store room Clearance"

		UPDATE `bugs`
			SET `cf_ut_org_specific_dd_1` = 'Complex Project - Store room Clearance'
			WHERE `rep_platform` = 'Complex Project'
				AND `cf_ipi_clust_6_claim_type` = 'Store room Clearance'
			;

	# For "Devices - Key"

		UPDATE `bugs`
			SET `cf_ut_org_specific_dd_1` = 'Devices - Key'
			WHERE `rep_platform` = 'Devices'
				AND `cf_ipi_clust_6_claim_type` = 'Key'
			;

	# For "Devices - Resident Card"

		UPDATE `bugs`
			SET `cf_ut_org_specific_dd_1` = 'Devices - Resident Card'
			WHERE `rep_platform` = 'Devices'
				AND `cf_ipi_clust_6_claim_type` = 'Resident Card'
			;

	# For "Devices - Car Transponder"

		UPDATE `bugs`
			SET `cf_ut_org_specific_dd_1` = 'Devices - Car Transponder'
			WHERE `rep_platform` = 'Devices'
				AND `cf_ipi_clust_6_claim_type` = 'Car Transponder'
			;

	# For "Devices - Kitchen Utensils"

		UPDATE `bugs`
			SET `cf_ut_org_specific_dd_1` = 'Devices - Kitchen Utensil'
			WHERE `rep_platform` = 'Devices'
				AND `cf_ipi_clust_6_claim_type` = 'Kitchen Utensils'
			;

	# For "Devices - Furniture"

		UPDATE `bugs`
			SET `cf_ut_org_specific_dd_1` = 'Devices - Furniture'
			WHERE `rep_platform` = 'Devices'
				AND `cf_ipi_clust_6_claim_type` = 'Furniture'
			;

	# For "Devices - Safe box"

		UPDATE `bugs`
			SET `cf_ut_org_specific_dd_1` = 'Devices - Safe box'
			WHERE `rep_platform` = 'Devices'
				AND `cf_ipi_clust_6_claim_type` = 'Safe box'
			;

	# For "Devices - Equipment"

		UPDATE `bugs`
			SET `cf_ut_org_specific_dd_1` = 'Devices - Equipment'
			WHERE `rep_platform` = 'Devices'
				AND `cf_ipi_clust_6_claim_type` = 'Equipment'
			;

	# For "Devices - Other D"

		UPDATE `bugs`
			SET `cf_ut_org_specific_dd_1` = 'Devices - Other D'
			WHERE `rep_platform` = 'Devices'
				AND `cf_ipi_clust_6_claim_type` = 'Other D'
			;

	# For "Renovation - Structural Defect"

		UPDATE `bugs`
			SET `cf_ut_org_specific_dd_1` = 'Renovation - Structural Defect'
			WHERE `rep_platform` = 'Renovation'
				AND `cf_ipi_clust_6_claim_type` = 'Structural Defect'
			;

	# For "Renovation - Carpentry Ren"

		UPDATE `bugs`
			SET `cf_ut_org_specific_dd_1` = 'Renovation - Carpentry Ren'
			WHERE `rep_platform` = 'Renovation'
				AND `cf_ipi_clust_6_claim_type` = 'Carpentry Ren'
			;

	# For "Renovation - Parquet Polishing"

		UPDATE `bugs`
			SET `cf_ut_org_specific_dd_1` = 'Renovation - Parquet Polishing'
			WHERE `rep_platform` = 'Renovation'
				AND `cf_ipi_clust_6_claim_type` = 'Parquet Polishing'
			;

	# For "Renovation - Painting"

		UPDATE `bugs`
			SET `cf_ut_org_specific_dd_1` = 'Renovation - Painting'
			WHERE `rep_platform` = 'Renovation'
				AND `cf_ipi_clust_6_claim_type` = 'Painting'
			;

	# For "Renovation - Other Ren"

		UPDATE `bugs`
			SET `cf_ut_org_specific_dd_1` = 'Renovation - Other Ren'
			WHERE `rep_platform` = 'Renovation'
				AND `cf_ipi_clust_6_claim_type` = 'Other Ren'
			;

# Update the bugs so that they use the new categories and case types

	# Repair

		# Old category "Repair - Electrical"

			UPDATE `bugs`
				SET `rep_platform` := 'Electrical'
					, `cf_ipi_clust_6_claim_type` := 'Repair'
				WHERE `rep_platform` = 'Repair'
					AND `cf_ipi_clust_6_claim_type` = 'Electrical'
				;

		# Old category "Repair - Plumbing Rep"

			UPDATE `bugs`
				SET `rep_platform` := 'Plumbing'
					, `cf_ipi_clust_6_claim_type` := 'Repair'
				WHERE `rep_platform` = 'Repair'
					AND `cf_ipi_clust_6_claim_type` = 'Plumbing Rep'
				;

		# Old category "Repair - Aircon Rep"

			UPDATE `bugs`
				SET `rep_platform` := 'Aircon/Heating'
					, `cf_ipi_clust_6_claim_type` := 'Repair'
				WHERE `rep_platform` = 'Repair'
					AND `cf_ipi_clust_6_claim_type` = 'Aircon Rep'
				;

		# Old category "Repair - Furniture Rep"

			UPDATE `bugs`
				SET `rep_platform` := 'Furnitures/Fixtures'
					, `cf_ipi_clust_6_claim_type` := 'Repair'
				WHERE `rep_platform` = 'Repair'
					AND `cf_ipi_clust_6_claim_type` = 'Furniture Rep'
				;

		# Old category "Repair - Carpentry Rep"

			UPDATE `bugs`
				SET `rep_platform` := 'Furnitures/Fixtures'
					, `cf_ipi_clust_6_claim_type` := 'Repair'
				WHERE `rep_platform` = 'Repair'
					AND `cf_ipi_clust_6_claim_type` = 'Carpentry Rep'
				;

		# Old category "Repair - Internet Rep"

			UPDATE `bugs`
				SET `rep_platform` := 'Utilities'
					, `cf_ipi_clust_6_claim_type` := 'Internet'
				WHERE `rep_platform` = 'Repair'
					AND `cf_ipi_clust_6_claim_type` = 'Internet Rep'
				;

		# Old category "Repair - Cable TV Rep"

			UPDATE `bugs`
				SET `rep_platform` := 'Utilities'
					, `cf_ipi_clust_6_claim_type` := 'Cable'
				WHERE `rep_platform` = 'Repair'
					AND `cf_ipi_clust_6_claim_type` = 'Cable TV Rep'
				;

		# Old category "Repair - Equipment"

			UPDATE `bugs`
				SET `rep_platform` := 'Appliances/Equipment'
					, `cf_ipi_clust_6_claim_type` := 'Repair'
				WHERE `rep_platform` = 'Repair'
					AND `cf_ipi_clust_6_claim_type` = 'Equipment'
				;

		# Old category "Repair - Other Rep"

			UPDATE `bugs`
				SET `rep_platform` := 'Other'
					, `cf_ipi_clust_6_claim_type` := 'Repair'
				WHERE `rep_platform` = 'Repair'
					AND `cf_ipi_clust_6_claim_type` = 'Other Rep'
				;

	# Maintenance

		# Old category "Maintenance - Aircon M"

			UPDATE `bugs`
				SET `rep_platform` := 'Aircon/Heating'
					, `cf_ipi_clust_6_claim_type` := 'Maintenance'
				WHERE `rep_platform` = 'Maintenance'
					AND `cf_ipi_clust_6_claim_type` = 'Aircon M'
				;

		# Old category "Maintenance - Equipment M"

			UPDATE `bugs`
				SET `rep_platform` := 'Appliances/Equipment'
					, `cf_ipi_clust_6_claim_type` := 'Maintenance'
				WHERE `rep_platform` = 'Maintenance'
					AND `cf_ipi_clust_6_claim_type` = 'Equipment M'
				;

		# Old category "Maintenance - Plumbing M"

			UPDATE `bugs`
				SET `rep_platform` := 'Plumbing'
					, `cf_ipi_clust_6_claim_type` := 'Maintenance'
				WHERE `rep_platform` = 'Maintenance'
					AND `cf_ipi_clust_6_claim_type` = 'Plumbing M'
				;

		# Old category "Maintenance - Battery repl."

			UPDATE `bugs`
				SET `rep_platform` := 'Electrical'
					, `cf_ipi_clust_6_claim_type` := 'Maintenance'
				WHERE `rep_platform` = 'Maintenance'
					AND `cf_ipi_clust_6_claim_type` = 'Battery repl.'
				;

		# Old category "Maintenance - Other M"

			UPDATE `bugs`
				SET `rep_platform` := 'Other'
					, `cf_ipi_clust_6_claim_type` := 'Maintenance'
				WHERE `rep_platform` = 'Maintenance'
					AND `cf_ipi_clust_6_claim_type` = 'Other M'
				;

	# Housekeeping

		# Old category "Housekeeping - Linens"

			UPDATE `bugs`
				SET `rep_platform` := 'Housekeeping'
					, `cf_ipi_clust_6_claim_type` := 'Linens'
				WHERE `rep_platform` = 'Housekeeping'
					AND `cf_ipi_clust_6_claim_type` = 'Linens'
				;

		# Old category "Housekeeping - Textile"

			UPDATE `bugs`
				SET `rep_platform` := 'Housekeeping'
					, `cf_ipi_clust_6_claim_type` := 'Textile'
				WHERE `rep_platform` = 'Housekeeping'
					AND `cf_ipi_clust_6_claim_type` = 'Textile'
				;

		# Old category "Housekeeping - Curtains"

			UPDATE `bugs`
				SET `rep_platform` := 'Housekeeping'
					, `cf_ipi_clust_6_claim_type` := 'Curtains'
				WHERE `rep_platform` = 'Housekeeping'
					AND `cf_ipi_clust_6_claim_type` = 'Curtains'
				;

		# Old category "Housekeeping - Cleaning"

			UPDATE `bugs`
				SET `rep_platform` := 'Housekeeping'
					, `cf_ipi_clust_6_claim_type` := 'Cleaning'
				WHERE `rep_platform` = 'Housekeeping'
					AND `cf_ipi_clust_6_claim_type` = 'Cleaning'
				;

		# Old category "Housekeeping - Other H"

			UPDATE `bugs`
				SET `rep_platform` := 'Housekeeping'
					, `cf_ipi_clust_6_claim_type` := 'Other'
				WHERE `rep_platform` = 'Housekeeping'
					AND `cf_ipi_clust_6_claim_type` = 'Other H'
				;

	# Devices 

		# Old category "Devices - Key"

			UPDATE `bugs`
				SET `rep_platform` := 'Appliances/Equipment'
					, `cf_ipi_clust_6_claim_type` := 'Replace'
				WHERE `rep_platform` = 'Devices'
					AND `cf_ipi_clust_6_claim_type` = 'Key'
				;

		# Old category "Devices - Resident Card"

			UPDATE `bugs`
				SET `rep_platform` := 'Appliances/Equipment'
					, `cf_ipi_clust_6_claim_type` := 'Replace'
				WHERE `rep_platform` = 'Devices'
					AND `cf_ipi_clust_6_claim_type` = 'Resident Card'
				;

		# Old category "Devices - Car Transponder"

			UPDATE `bugs`
				SET `rep_platform` := 'Appliances/Equipment'
					, `cf_ipi_clust_6_claim_type` := 'Replace'
				WHERE `rep_platform` = 'Devices'
					AND `cf_ipi_clust_6_claim_type` = 'Car Transponder'
				;

		# Old category "Devices - Kitchen Utensils"

			UPDATE `bugs`
				SET `rep_platform` := 'Appliances/Equipment'
					, `cf_ipi_clust_6_claim_type` := 'Replace'
				WHERE `rep_platform` = 'Devices'
					AND `cf_ipi_clust_6_claim_type` = 'Kitchen Utensils'
				;

		# Old category "Devices - Furniture D"

			UPDATE `bugs`
				SET `rep_platform` := 'Furnitures/Fixtures'
					, `cf_ipi_clust_6_claim_type` := 'Repair'
				WHERE `rep_platform` = 'Devices'
					AND `cf_ipi_clust_6_claim_type` = 'Furniture D'
				;

		# Old category "Devices - Safe box"

			UPDATE `bugs`
				SET `rep_platform` := 'Appliances/Equipment'
					, `cf_ipi_clust_6_claim_type` := 'Repair'
				WHERE `rep_platform` = 'Devices'
					AND `cf_ipi_clust_6_claim_type` = 'Safe box'
				;

		# Old category "Devices - Equipment D"

			UPDATE `bugs`
				SET `rep_platform` := 'Appliances/Equipment'
					, `cf_ipi_clust_6_claim_type` := 'Repair'
				WHERE `rep_platform` = 'Devices'
					AND `cf_ipi_clust_6_claim_type` = 'Equipment D'
				;

		# Old category "Devices - Other D"

			UPDATE `bugs`
				SET `rep_platform` := 'Appliances/Equipment'
					, `cf_ipi_clust_6_claim_type` := 'Other'
				WHERE `rep_platform` = 'Devices'
					AND `cf_ipi_clust_6_claim_type` = 'Other D'
				;

	# Renovation 

		# Old category "Renovation - Structural Defect"

			UPDATE `bugs`
				SET `rep_platform` := 'Structural'
					, `cf_ipi_clust_6_claim_type` := 'Repair'
				WHERE `rep_platform` = 'Renovation'
					AND `cf_ipi_clust_6_claim_type` = 'Structural Defect'
				;

		# Old category "Renovation - Carpentry Ren"

			UPDATE `bugs`
				SET `rep_platform` := 'Projects'
					, `cf_ipi_clust_6_claim_type` := 'Renovation'
				WHERE `rep_platform` = 'Renovation'
					AND `cf_ipi_clust_6_claim_type` = 'Carpentry Ren'
				;

		# Old category "Renovation - Parquet Polishing"

			UPDATE `bugs`
				SET `rep_platform` := 'Projects'
					, `cf_ipi_clust_6_claim_type` := 'Renovation'
				WHERE `rep_platform` = 'Renovation'
					AND `cf_ipi_clust_6_claim_type` = 'Parquet Polishing'
				;

		# Old category "Renovation - Painting"

			UPDATE `bugs`
				SET `rep_platform` := 'Projects'
					, `cf_ipi_clust_6_claim_type` := 'Renovation'
				WHERE `rep_platform` = 'Renovation'
					AND `cf_ipi_clust_6_claim_type` = 'Painting'
				;

		# Old category "Renovation - Other Ren"

			UPDATE `bugs`
				SET `rep_platform` := 'Projects'
					, `cf_ipi_clust_6_claim_type` := 'Renovation'
				WHERE `rep_platform` = 'Renovation'
					AND `cf_ipi_clust_6_claim_type` = 'Other Ren'
				;

	# Complex Project

		# Old category "Complex Project - Flat Set Up"

			UPDATE `bugs`
				SET `rep_platform` := 'Projects'
					, `cf_ipi_clust_6_claim_type` := 'Flat Set Up'
				WHERE `rep_platform` = 'Complex Project'
					AND `cf_ipi_clust_6_claim_type` = 'Flat Set Up'
				;

		# Old category "Complex Project - Light Renovation"

			UPDATE `bugs`
				SET `rep_platform` := 'Projects'
					, `cf_ipi_clust_6_claim_type` := 'Light Renovation'
				WHERE `rep_platform` = 'Complex Project'
					AND `cf_ipi_clust_6_claim_type` = 'Light Renovation'
				;

		# Old category "Complex Project - Flat Refurbishing"

			UPDATE `bugs`
				SET `rep_platform` := 'Projects'
					, `cf_ipi_clust_6_claim_type` := 'Refurbishing'
				WHERE `rep_platform` = 'Complex Project'
					AND `cf_ipi_clust_6_claim_type` = 'Flat Refurbishing'
				;

		# Old category "Complex Project - Hand Over"

			UPDATE `bugs`
				SET `rep_platform` := 'Projects'
					, `cf_ipi_clust_6_claim_type` := 'Hand Over'
				WHERE `rep_platform` = 'Complex Project'
					AND `cf_ipi_clust_6_claim_type` = 'Hand Over'
				;

		# Old category "Complex Project - Basic Check"

			UPDATE `bugs`
				SET `rep_platform` := 'Projects'
					, `cf_ipi_clust_6_claim_type` := 'Basic Check'
				WHERE `rep_platform` = 'Complex Project'
					AND `cf_ipi_clust_6_claim_type` = 'Basic Check'
				;

		# Old category "Complex Project - Store room Clearance"

			UPDATE `bugs`
				SET `rep_platform` := 'Projects'
					, `cf_ipi_clust_6_claim_type` := 'Other'
				WHERE `rep_platform` = 'Complex Project'
					AND `cf_ipi_clust_6_claim_type` = 'Store room Clearance'
				;

		# Old category "Complex Project - Other CP"

			UPDATE `bugs`
				SET `rep_platform` := 'Projects'
					, `cf_ipi_clust_6_claim_type` := 'Other'
				WHERE `rep_platform` = 'Complex Project'
					AND `cf_ipi_clust_6_claim_type` = 'Other CP'
				;

	# Extra Service

		# Old category "Extra Service - Laundry"

			UPDATE `bugs`
				SET `rep_platform` := 'Extra Service'
					, `cf_ipi_clust_6_claim_type` := 'Laundry'
				WHERE `rep_platform` = 'Extra Service'
					AND `cf_ipi_clust_6_claim_type` = 'Laundry'
				;

		# Old category "Extra Service - Ironing"

			UPDATE `bugs`
				SET `rep_platform` := 'Extra Service'
					, `cf_ipi_clust_6_claim_type` := 'Ironing'
				WHERE `rep_platform` = 'Extra Service'
					AND `cf_ipi_clust_6_claim_type` = 'Ironing'
				;

		# Old category "Extra Service - Housekeeping"

			UPDATE `bugs`
				SET `rep_platform` := 'Extra Service'
					, `cf_ipi_clust_6_claim_type` := 'Housekeeping'
				WHERE `rep_platform` = 'Extra Service'
					AND `cf_ipi_clust_6_claim_type` = 'Housekeeping'
				;

		# Old category "Extra Service - Cable Channel"

			UPDATE `bugs`
				SET `rep_platform` := 'Extra Service'
					, `cf_ipi_clust_6_claim_type` := 'Cable Upgrade'
				WHERE `rep_platform` = 'Extra Service'
					AND `cf_ipi_clust_6_claim_type` = 'Cable Channel'
				;

		# Old category "Extra Service - Internet Upgrade"

			UPDATE `bugs`
				SET `rep_platform` := 'Extra Service'
					, `cf_ipi_clust_6_claim_type` := 'Internet Upgrade'
				WHERE `rep_platform` = 'Extra Service'
					AND `cf_ipi_clust_6_claim_type` = 'Internet Upgrade'
				;

		# Old category "Extra Service - Beds"

			UPDATE `bugs`
				SET `rep_platform` := 'Extra Service'
					, `cf_ipi_clust_6_claim_type` := 'Furnitures and Fixtures'
				WHERE `rep_platform` = 'Extra Service'
					AND `cf_ipi_clust_6_claim_type` = 'Beds'
				;

		# Old category "Extra Service - Baby Cot"

			UPDATE `bugs`
				SET `rep_platform` := 'Extra Service'
					, `cf_ipi_clust_6_claim_type` := 'Furnitures and Fixtures'
				WHERE `rep_platform` = 'Extra Service'
					AND `cf_ipi_clust_6_claim_type` = 'Baby Cot'
				;

		# Old category "Extra Service - Airport Transportation"

			UPDATE `bugs`
				SET `rep_platform` := 'Extra Service'
					, `cf_ipi_clust_6_claim_type` := 'Transportation'
				WHERE `rep_platform` = 'Extra Service'
					AND `cf_ipi_clust_6_claim_type` = 'Airport Transportation'
				;

		# Old category "Extra Service - Welcome Basket"

			UPDATE `bugs`
				SET `rep_platform` := 'Extra Service'
					, `cf_ipi_clust_6_claim_type` := 'Other'
				WHERE `rep_platform` = 'Extra Service'
					AND `cf_ipi_clust_6_claim_type` = 'Welcome Basket'
				;

		# Old category "Extra Service - Dish Washing"

			UPDATE `bugs`
				SET `rep_platform` := 'Extra Service'
					, `cf_ipi_clust_6_claim_type` := 'Other'
				WHERE `rep_platform` = 'Extra Service'
					AND `cf_ipi_clust_6_claim_type` = 'Dish Washing'
				;

		# Old category "Extra Service - Late Check IN/OUT"

			UPDATE `bugs`
				SET `rep_platform` := 'Extra Service'
					, `cf_ipi_clust_6_claim_type` := 'Early/Late'
				WHERE `rep_platform` = 'Extra Service'
					AND `cf_ipi_clust_6_claim_type` = 'Late Check IN/OUT'
				;

		# Old category "Extra Service - Early Check IN/OUT"

			UPDATE `bugs`
				SET `rep_platform` := 'Extra Service'
					, `cf_ipi_clust_6_claim_type` := 'Early/Late'
				WHERE `rep_platform` = 'Extra Service'
					AND `cf_ipi_clust_6_claim_type` = 'Early Check IN/OUT'
				;

		# Old category "Extra Service - High Chair"

			UPDATE `bugs`
				SET `rep_platform` := 'Extra Service'
					, `cf_ipi_clust_6_claim_type` := 'Furnitures and Fixtures'
				WHERE `rep_platform` = 'Extra Service'
					AND `cf_ipi_clust_6_claim_type` = 'High Chair'
				;

		# Old category "Extra Service - Other ES"

			UPDATE `bugs`
				SET `rep_platform` := 'Extra Service'
					, `cf_ipi_clust_6_claim_type` := 'Other'
				WHERE `rep_platform` = 'Extra Service'
					AND `cf_ipi_clust_6_claim_type` = 'Other ES'
				;

		# Old category "Extra Service - NOT SPECIFIED"

			UPDATE `bugs`
				SET `rep_platform` := 'Extra Service'
					, `cf_ipi_clust_6_claim_type` := 'NOT SPECIFIED'
				WHERE `rep_platform` = 'Extra Service'
					AND `cf_ipi_clust_6_claim_type` = 'NOT SPECIFIED'
				;

	# Utilities

		# Old category "Utilities - SP Services"

			UPDATE `bugs`
				SET `rep_platform` := 'Utilities'
					, `cf_ipi_clust_6_claim_type` := 'Electricity'
				WHERE `rep_platform` = 'Utilities'
					AND `cf_ipi_clust_6_claim_type` = 'SP Services'
				;

		# Old category "Utilities - Gas"

			UPDATE `bugs`
				SET `rep_platform` := 'Utilities'
					, `cf_ipi_clust_6_claim_type` := 'Gas'
				WHERE `rep_platform` = 'Utilities'
					AND `cf_ipi_clust_6_claim_type` = 'Gas'
				;

		# Old category "Utilities - Meter Reading"

			UPDATE `bugs`
				SET `rep_platform` := 'Utilities'
					, `cf_ipi_clust_6_claim_type` := 'Other'
				WHERE `rep_platform` = 'Utilities'
					AND `cf_ipi_clust_6_claim_type` = 'Meter Reading'
				;

		# Old category "Utilities - Other U"

			UPDATE `bugs`
				SET `rep_platform` := 'Utilities'
					, `cf_ipi_clust_6_claim_type` := 'Other'
				WHERE `rep_platform` = 'Utilities'
					AND `cf_ipi_clust_6_claim_type` = 'Other U'
				;

	# Other

		# Old category "Other - Internet O"

			UPDATE `bugs`
				SET `rep_platform` := 'Utilities'
					, `cf_ipi_clust_6_claim_type` := 'Internet'
				WHERE `rep_platform` = 'Other'
					AND `cf_ipi_clust_6_claim_type` = 'Internet O'
				;

		# Old category "Other - Cable TV O"

			UPDATE `bugs`
				SET `rep_platform` := 'Utilities'
					, `cf_ipi_clust_6_claim_type` := 'Cable'
				WHERE `rep_platform` = 'Other'
					AND `cf_ipi_clust_6_claim_type` = 'Cable TV O'
				;

		# Old category "Other - Viewing"

			UPDATE `bugs`
				SET `rep_platform` := 'Other'
					, `cf_ipi_clust_6_claim_type` := 'Viewing'
				WHERE `rep_platform` = 'Other'
					AND `cf_ipi_clust_6_claim_type` = 'Viewing'
				;

		# Old category "Other - Other"

			UPDATE `bugs`
				SET `rep_platform` := 'Other'
					, `cf_ipi_clust_6_claim_type` := 'Other'
				WHERE `rep_platform` = 'Other'
					AND `cf_ipi_clust_6_claim_type` = 'Other'
				;

# WE re-enable the FK checks

	SET FOREIGN_KEY_CHECKS = 1 ;

# We do NOT Update the audit logs

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