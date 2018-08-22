# For any question about this script, ask Franck
#
###################################################################################
#
# WARNING! 
#	- It is MANDATORY to use Amazon Aurora database engine for this version
#
# Make sure to also update the below variable(s)
#
###################################################################################
#
# What are the version of the Unee-T BZ Database schema BEFORE and AFTER this update?
	SET @old_schema_version = 'v3.23';
	SET @new_schema_version = 'v3.24';
#
# What is the name of this script?
	SET @this_script = 'upgrade_unee-t_v3.23_to_v3.24.sql';
#
###############################
#
# We have everything we need
#
###############################
# This update
#
#   - Creates several new views to record important metrics:
#		- `count_invitation_sent_per_week`
#		- `count_invitation_sent_per_month`
#
# Makes sure we keep track of all the enabled/disabled products/units:
#   - Create a table to log how this evolves over time
#   - Create a procedure to update this table when needed
#   - Create a trigger to update the table each time a unit is created
#   - Create a trigger to update the table each time a unit is deleted
#   - Create a trigger to update the table each time a unit is enabled or disabled
#   - Create Views to retrieve aggregated information
#		- `count_units_enabled_and_total_per_week`: weekly averages
#		- `count_units_enabled_and_total_per_month`: monthly averages
				
# When are we doing this?
	SET @the_timestamp = NOW();

# Create the view `count_invitation_sent_per_week`

	DROP VIEW IF EXISTS `count_invitation_sent_per_week`;

	CREATE VIEW `count_invitation_sent_per_week`
	AS
    SELECT
        year(`processed_datetime`) AS `year`
        , month(`processed_datetime`) AS `month`
        , week(`processed_datetime`) AS `week`
        , count(`id`)  AS `invitation_sent`
    FROM `ut_invitation_api_data`
    GROUP BY YEAR(`processed_datetime`)
        , MONTH(`processed_datetime`)DESC
        , WEEK(`processed_datetime`)
    ORDER BY YEAR(`processed_datetime`)DESC
        , WEEK(`processed_datetime`)DESC
    ;

# Create the view `count_invitation_sent_per_month`

	DROP VIEW IF EXISTS `count_invitation_sent_per_month`;

	CREATE VIEW `count_invitation_sent_per_month`
	AS
    SELECT
        YEAR(`processed_datetime`) AS `year`
        , MONTH(`processed_datetime`) AS `month`
        , count(`id`)  AS `invitation_sent`
    FROM `ut_invitation_api_data`
    GROUP BY YEAR(`processed_datetime`)
        , MONTH(`processed_datetime`)
    ORDER BY YEAR(`processed_datetime`)DESC
        , MONTH(`processed_datetime`)DESC
    ;

# We need a table `ut_log_count_enabled_units` to count all the enabled and disabled product/unit.

    DROP TABLE IF EXISTS `ut_log_count_enabled_units`;

    CREATE TABLE `ut_log_count_enabled_units` (
        `id_log_enabled_units` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique id in this table',
        `timestamp` datetime DEFAULT NULL COMMENT 'The timestamp when this record was created',
        `count_enabled_units` int(11) NOT NULL COMMENT 'The number of enabled products/units at this Datetime',
        `count_total_units` int(11) NOT NULL COMMENT 'The total number of products/units at this Datetime',
        PRIMARY KEY (`id_log_enabled_units`)
        )
        ;

# We need a procedure `update_log_count_enabled_units` to update the table `ut_log_count_enabled_units`
	
	DROP PROCEDURE IF EXISTS `update_log_count_enabled_units`;

DELIMITER $$
CREATE PROCEDURE update_log_count_enabled_units()
SQL SECURITY INVOKER
BEGIN
 
	# When are we doing this?
		SET @timestamp = NOW();	

	# Flash Count the total number of Enabled unit at the date of this query
	# Put this in a variable
		SET @count_enabled_units = (SELECT
			 COUNT(`products`.`id`)
		FROM
			`products`
		WHERE `products`.`isactive` = 1)
		;
		
	# Flash Count the total number of ALL cases are the date of this query
	# Put this in a variable
		SET @count_total_units = (SELECT
			 COUNT(`products`.`id`)
		FROM
			`products`
			) 
			;

	# We have everything: insert in the log table
		INSERT INTO `ut_log_count_enabled_units`
			(`timestamp`
			, `count_enabled_units`
			, `count_total_units`
			)
			VALUES
			(@timestamp
			, @count_enabled_units
			, @count_total_units
			)
			;
END $$
DELIMITER ;

# We need a trigger `update_the_log_of_enabled_units_when_unit_is_created` to call the procedure `update_log_count_enabled_units` each time a new unit/product is created.

    DROP TRIGGER IF EXISTS `update_the_log_of_enabled_units_when_unit_is_created`;

DELIMITER $$
CREATE TRIGGER `update_the_log_of_enabled_units_when_unit_is_created`
    AFTER INSERT ON `products`
    FOR EACH ROW
  BEGIN
    CALL `update_log_count_enabled_units`;
END;
$$
DELIMITER ;

# We need a trigger `update_the_log_of_enabled_units_when_unit_is_deleted` to call the procedure `update_log_count_enabled_units` each time a new unit/product is deleted.
# This should NEVER happen in normal cirumstances: we no not delete units...

    DROP TRIGGER IF EXISTS `update_the_log_of_enabled_units_when_unit_is_deleted`;

DELIMITER $$
CREATE TRIGGER `update_the_log_of_enabled_units_when_unit_is_deleted`
    AFTER DELETE ON `products`
    FOR EACH ROW
  BEGIN
    CALL `update_log_count_enabled_units`;
END;
$$
DELIMITER ;

# We need a trigger `update_the_log_of_enabled_units_when_unit_is_updated` to call the procedure `update_log_count_enabled_units` each time a unit is enabled/disabled

    DROP TRIGGER IF EXISTS `update_the_log_of_enabled_units_when_unit_is_updated`;

DELIMITER $$
CREATE TRIGGER `update_the_log_of_enabled_units_when_unit_is_updated`
    AFTER UPDATE ON `products`
    FOR EACH ROW
  BEGIN
    IF NEW.`isactive` <> OLD.`isactive` 
		THEN
		# If these are different, then we need to update the log of closed cases
			CALL `update_log_count_enabled_units`;
    END IF;
END;
$$
DELIMITER ;

# Create the view `count_units_enabled_and_total_per_week`

	DROP VIEW IF EXISTS `count_units_enabled_and_total_per_week`;

	CREATE VIEW `count_units_enabled_and_total_per_week`
	AS
    SELECT
        year(`timestamp`) AS `year`
        , month(`timestamp`) AS `month`
        , week(`timestamp`) AS `week`
        , AVG(`count_enabled_units`)  AS `average_enabled_units`
        , AVG(`count_total_units`)  AS `average_total_units`
    FROM `ut_log_count_enabled_units`
    GROUP BY YEAR(`timestamp`)
        , MONTH(`timestamp`)
        , WEEK(`timestamp`)
    ORDER BY YEAR(`timestamp`)DESC
        , WEEK(`timestamp`)DESC
    ;

# Create the view `count_units_enabled_and_total_per_month`

	DROP VIEW IF EXISTS `count_units_enabled_and_total_per_month`;

	CREATE VIEW `count_units_enabled_and_total_per_month`
	AS
    SELECT
        YEAR(`timestamp`) AS `year`
        , MONTH(`timestamp`) AS `month`
        , AVG(`count_enabled_units`)  AS `average_enabled_units`
        , AVG(`count_total_units`)  AS `average_total_units`
    FROM `ut_log_count_enabled_units`
    GROUP BY YEAR(`timestamp`)
        , MONTH(`timestamp`)
    ORDER BY YEAR(`timestamp`)DESC
        , MONTH(`timestamp`)DESC
    ;

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