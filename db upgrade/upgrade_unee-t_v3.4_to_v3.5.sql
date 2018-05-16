# For any question about this script, ask Franck
#
###################################################################################
#
# WARNING! It is recommended to use Amazon Aurora database engine for this version
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
	SET @old_schema_version = 'v3.4';
	SET @new_schema_version = 'v3.5';
	SET @this_script = 'upgrade_unee-t_v3.4_to_v3.5.sql';
#
###############################
#
# We have everything we need
#
###############################
# This update 
#	- Creates the keywords we need to do the inspection reports
#		- inspection_report
#		- item
#		- room
#

# When are we doing this?
	SET @the_timestamp = NOW();
	
# What is the next available id in the keywords table?
	SET @ir_keyword_id = (((SELECT MAX(`id`) FROM `keyworddefs`) + 1) );
	SET @item_keyword_id = @ir_keyword_id + 1;
	SET @room_keyword_id = @item_keyword_id + 1;

# We insert the keywords we need:

	INSERT INTO `keyworddefs`
		(`id`
		,`name`
		,`description`
		) 
		VALUES 
		(@ir_keyword_id,'inspection_report','This is to identify inspection reports')
		, (@item_keyword_id,'item','This is to identify items in a unit')
		, (@room_keyword_id,'room','This is to identify rooms in a unit')
		;

	# We need to record this in the `audit_log` table
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
			(1,'Bugzilla::Keyword',@ir_keyword_id,'__create__',NULL,'inspection_report',@the_timestamp)
			, (1,'Bugzilla::Keyword',@item_keyword_id,'__create__',NULL,'item',@the_timestamp)
			, (1,'Bugzilla::Keyword',@room_keyword_id,'__create__',NULL,'room',@the_timestamp)
			;

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