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
	SET @old_schema_version = 'v3.5';
	SET @new_schema_version = 'v3.6';
	SET @this_script = 'upgrade_unee-t_v3.5_to_v3.6.sql';
#
###############################
#
# We have everything we need
#
###############################
# This update 
#	- Creates several views to simplify the generation of KPIs and report
#		- Count the number of invitation sent per user per month
#		- Count the number of users who sent at least an invite per month
#		- Count the number of unit where at least 1 invite was sent per month
#		- Count the number of invitation sent per unit per month
#		- Count the number of unit where at least 1 invite was sent
#		- Count the number of invitation sent to an individual invitee per month
#		- Count the number of new invitee per month (an invitee appears only once if several invites have been sent to him)
#
#WIP	- Creates a table to record the current number of units with dummy roles
#
#WIP 	- Creates a trigger to populate the table each time a dummy tenant is replaced.
# 	When we replace a dummy, tenant, we insert a record in the table
# 	Each time a record is inserted there, we need to compute and record the number of units with dummy tenants.
#
#WIP		- Count the average number of component where the default assignee is NOT a dummy user
#

# When are we doing this?
	SET @the_timestamp = NOW();
	
# We create the view to Count the number of invitation sent per user per month
	CREATE VIEW `count_invites_per_user_per_month`
	AS
		SELECT
			YEAR(`api_post_datetime`) AS `year`
			, MONTH(`api_post_datetime`) AS `month`
			, `bzfe_invitor_user_id`
			, COUNT(`id`) AS `invitation_sent`
		FROM
			`ut_invitation_api_data`
		GROUP BY `bzfe_invitor_user_id`
			, MONTH(`api_post_datetime`)
			, YEAR(`api_post_datetime`)
		ORDER BY YEAR(`api_post_datetime`) DESC
			, MONTH(`api_post_datetime`) DESC
		;

# We Create the view to count the number of user who sent at least 1 invite per month

	CREATE VIEW `count_invitors_per_month`
	AS 
		SELECT 
			`year`
			, `month`
			, COUNT(`bzfe_invitor_user_id`) AS `count_invitors`
		FROM `count_invites_per_user_per_month`
		GROUP BY `month`
			, `year`
		ORDER BY `year` DESC
			, `month` DESC
		;

# We create the view to count the number of invitation sent per unit per month
	CREATE VIEW `count_invites_per_unit_per_month` 
	AS
		SELECT
			YEAR(`api_post_datetime`) AS `year`
			, MONTH(`api_post_datetime`) AS `month`
			, `bz_unit_id`
			, COUNT(`id`) AS `invitation_sent`
		FROM
			`ut_invitation_api_data`
		GROUP BY `bz_unit_id`
			, MONTH(`api_post_datetime`)
			, YEAR(`api_post_datetime`)
		ORDER BY YEAR(`api_post_datetime`) DESC
			, MONTH(`api_post_datetime`) DESC
		;

# We create the view to count the number of unit where at least 1 invite was sent
	CREATE VIEW `count_units_with_invitation_send`
	AS 
		SELECT 
			`year`
			, `month`
			, COUNT(bz_unit_id) AS `count_units`
		FROM `count_invites_per_unit_per_month`
		GROUP BY `month`
			, `year`
		ORDER BY `year` DESC
			, `month` DESC
		;

# We create the view to count the number of invitation sent to an individual invitee per month
	CREATE VIEW `count_invitation_per_invitee_per_month` 
	AS
		SELECT
			YEAR(`api_post_datetime`) AS `year`
			, MONTH(`api_post_datetime`) AS `month`
			, `bz_user_id`
			, COUNT(`id`) AS `invitation_sent`
		FROM
			`ut_invitation_api_data`
		GROUP BY `bz_user_id`
			, MONTH(`api_post_datetime`)
			, YEAR(`api_post_datetime`)
		ORDER BY YEAR(`api_post_datetime`) DESC
			, MONTH(`api_post_datetime`) DESC
			, COUNT(`id`) DESC
		;
		
# We create the view to count the number of new invitee per month 
# (an invitee appears only once if several invites have been sent to him)
	CREATE VIEW `count_invitees_per_month`
	AS 
		SELECT 
			`year`
			, `month`
			, COUNT(bz_user_id) AS `count_invitees`
		FROM `count_invitation_per_invitee_per_month`
		GROUP BY `month`
			, `year`
		ORDER BY `year` DESC
			, `month` DESC
		;

# We create the view to count the number of invitation sent to each separate role per unit per month
		
		
		
		
		
		
		
# We create the view to count the number of roles activated per unit per month
	



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