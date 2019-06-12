
/* Procedure structure for procedure `update_permissions_invited_user` */

DROP PROCEDURE IF EXISTS `update_permissions_invited_user` ;

DELIMITER $$

CREATE PROCEDURE `update_permissions_invited_user`()
	SQL SECURITY INVOKER
BEGIN

	# We update the `user_group_map` table
	#	 - Create an intermediary table to deduplicate the records in the table `ut_user_group_map_temp`
	#	 - If the record does NOT exists in the table then INSERT new records in the table `user_group_map`
	#	 - If the record DOES exist in the table then update the new records in the table `user_group_map`
	#
	# We NEED the table `ut_user_group_map_temp` BUT this table should already exist. DO NO re-create it here!!!

	# We drop the deduplication table if it exists:
		DROP TEMPORARY TABLE IF EXISTS `ut_user_group_map_dedup`;

	# We create a table `ut_user_group_map_dedup` to prepare the data we need to insert
		CREATE TEMPORARY TABLE `ut_user_group_map_dedup` (
			`user_id` MEDIUMINT(9) NOT NULL
			, `group_id` MEDIUMINT(9) NOT NULL
			, `isbless` TINYINT(4) NOT NULL DEFAULT '0'
			, `grant_type` TINYINT(4) NOT NULL DEFAULT '0'
#			UNIQUE KEY `user_group_map_dedup_user_id_idx` (`user_id`, `group_id`, `grant_type`, `isbless`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci
		;
		
	# We insert the de-duplicated record in the table `user_group_map_dedup`
		INSERT INTO `ut_user_group_map_dedup`
		SELECT `user_id`
			, `group_id`
			, `isbless`
			, `grant_type`
		FROM
			`ut_user_group_map_temp`
		GROUP BY `user_id`
			, `group_id`
			, `isbless`
			, `grant_type`
		ORDER BY `user_id` ASC
			, `group_id` ASC
		;
			
	# We insert the data we need in the `user_group_map` table
		INSERT INTO `user_group_map`
		SELECT `user_id`
			, `group_id`
			, `isbless`
			, `grant_type`
		FROM
			`ut_user_group_map_dedup`
		# The below code is overkill in this context: 
		# the Unique Key Constraint makes sure that all records are unique in the table `user_group_map`
		ON DUPLICATE KEY UPDATE
			`user_id` = `ut_user_group_map_dedup`.`user_id`
			, `group_id` = `ut_user_group_map_dedup`.`group_id`
			, `isbless` = `ut_user_group_map_dedup`.`isbless`
			, `grant_type` = `ut_user_group_map_dedup`.`grant_type`
		;

	# We drop the temp table as we do not need it anymore
		DROP TEMPORARY TABLE IF EXISTS `ut_user_group_map_dedup`;

END $$
DELIMITER ;
