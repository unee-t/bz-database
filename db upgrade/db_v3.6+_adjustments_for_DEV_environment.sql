# Because, we have different id for dummy users for each environment, we need
# To run this script for the DEV database each time the database schema is updated

# Create the view to list all the changes from the audit log when we replaced the dummy tenant with a real user
# This script uses the values for the DEV
#	- Tenant = 93
#	- Landlord = 91
#	- Contractor = 90
#	- Mgt Cny = 92
#	- Agent = 89
#
# The value for the DEV are:
#	- Tenant = 96
#	- Landlord = 94
#	- Contractor = 93
#	- Mgt Cny = 95
#	- Agent = 82
#
	DROP VIEW IF EXISTS `list_changes_new_assignee_is_real`;
	
	CREATE VIEW `list_changes_new_assignee_is_real`
	AS
		SELECT `ut_product_group`.`product_id`
			, `audit_log`.`object_id` AS `component_id`
			, `audit_log`.`removed`
			, `audit_log`.`added`
			, `audit_log`.`at_time`
			, `ut_product_group`.`role_type_id`
			FROM `audit_log`
				INNER JOIN `ut_product_group` 
				ON (`audit_log`.`object_id` = `ut_product_group`.`component_id`)
			# If we add one of the BZ user who is NOT a dummy user, then it is a REAL user
			WHERE (`class` = 'Bugzilla::Component'
				AND `field` = 'initialowner'
				AND 
				# The new initial owner is NOT the dummy tenant?
				`audit_log`.`added` <> 96
				AND 
				# The new initial owner is NOT the dummy landlord?
				`audit_log`.`added` <> 94
				AND 				
				# The new initial owner is NOT the dummy contractor?
				`audit_log`.`added` <> 93
				AND 
				# The new initial owner is NOT the dummy Mgt Cny?
				`audit_log`.`added` <> 95
				AND 
				# The new initial owner is NOT the dummy agent?
				`audit_log`.`added` <> 82
				)
			GROUP BY `audit_log`.`object_id`
				, `ut_product_group`.`role_type_id`
			ORDER BY `audit_log`.`at_time` DESC
				, `ut_product_group`.`product_id` ASC
				, `audit_log`.`object_id` ASC
			;
	