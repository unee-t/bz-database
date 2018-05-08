# For any question about this script, ask Franck
#
# This update adds constraints to make sure invitations can be processed correctly
#
############################################
#
# Make sure to update the below variable(s)
#
############################################
#
# What are the version of the Unee-T BZ Database schema BEFORE and AFTER this update?
	SET @old_schema_version = 'v3.0';
	SET @new_schema_version = 'v3.1';
#
###############################
#
# We have everything we need
#
###############################
#
#
###################################################################################
#
# WARNING! It is recommended to use Amazon Aurora database engine for this version
#
###################################################################################

# We make sure that for each invitation we want to create:
#	- The invitor exists
#	- The invitee exists
#	- The product/unit exists
#	- The bug/case exists

/* Alter table in target */
	ALTER TABLE `ut_invitation_api_data` 
		ADD KEY `invitation_bz_bug_must_exist`(`bz_case_id`) , 
		ADD KEY `invitation_bz_invitee_must_exist`(`bz_user_id`) , 
		ADD KEY `invitation_bz_invitor_must_exist`(`bzfe_invitor_user_id`) , 
		ADD KEY `invitation_bz_product_must_exist`(`bz_unit_id`) ;
	ALTER TABLE `ut_invitation_api_data`
		ADD CONSTRAINT `invitation_bz_bug_must_exist` 
		FOREIGN KEY (`bz_case_id`) REFERENCES `bugs` (`bug_id`) , 
		ADD CONSTRAINT `invitation_bz_invitee_must_exist` 
		FOREIGN KEY (`bz_user_id`) REFERENCES `profiles` (`userid`) , 
		ADD CONSTRAINT `invitation_bz_invitor_must_exist` 
		FOREIGN KEY (`bzfe_invitor_user_id`) REFERENCES `profiles` (`userid`) , 
		ADD CONSTRAINT `invitation_bz_product_must_exist` 
		FOREIGN KEY (`bz_unit_id`) REFERENCES `products` (`id`) ;

	  
# We can now update the version of the database schema
	# A comment for the update
		SET @comment_update_schema_version = CONCAT (
			'Database updated from '
			, @old_schema_version
			, ' to '
			, @new_schema_version
		)
		;
		
	# Timestamp:
		SET @timestamp = NOW();
	
	# Do the update
	INSERT INTO `ut_db_schema_version`
		(`id`
		, `schema_version`
		, `update_datetime`
		, `comment`
		)
		VALUES
		( 1
		, @new_schema_version
		, @timestamp
		, @comment_update_schema_version
		)
		ON DUPLICATE KEY UPDATE
		`schema_version` = @new_schema_version
		, `update_datetime` = @timestamp
		, `comment` = @comment_update_schema_version
		;