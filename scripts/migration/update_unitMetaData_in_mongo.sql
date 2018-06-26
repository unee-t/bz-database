# For any question about this script, ask Franck.
#
# This script is used to update the Unit Meta Data in Unee-T

############################
#
# MAKE SURE YOU READ THIS! #
#
############################

# For which environemnt are you running this script?
#	- 1: DEV/Staging
#	- 2: PROD

	SET @environment = 2;

# Pre-Requisite:
#	- Import the collection `unitMetaData` from Mongo in the table `mongo_unitMetaData`
#	- Import the tables relevant to the pilot units from `misc_test_mongo_import`:
#       - `mongo_unit_data_migration`
#       - `pilot_1`
#       - `pilot_2`
#       - `pilot_3`
#       - `manually_created_units`
#
################################
#
# We have everything we need
#
################################
#
# This script will:
#	- Prepare the data for import
#	- Update the table `mongo_unitMetaData_for_import` so we can import it back into the Mongo DB

# Create a copy of the mongo table so we can do the alterations there

	DROP TABLE IF EXISTS `mongo_unitMetaData_step1`;

	CREATE TABLE `mongo_unitMetaData_step1` LIKE `mongo_unitMetaData`;

	INSERT `mongo_unitMetaData_step1` SELECT * FROM `mongo_unitMetaData`;

    UPDATE `mongo_unitMetaData_step1` SET `createdAt` = NULL;

# add the columns we need to the table `mongo_unitMetaData_step1`

	ALTER TABLE `mongo_unitMetaData_step1` 
		ADD COLUMN `ipi_id` INT(10)   NULL AFTER `bzId`
		, CHANGE `bzName` `bzName` LONGTEXT  COLLATE utf8_general_ci NULL AFTER `ipi_id` 
		;

# Update the displayName

	# Step 1:

		UPDATE `mongo_unitMetaData_step1`
			SET `displayName` = SUBSTRING_INDEX(`bzName`, ' - #', 1)
		;

	# Step 2:		
	# For each unit after BZ unit id number 264 in the DEV/Staging and in the PROD
	# we changed the way we created the unit names in BZ
	# This is so we can get the correct unit descriptions in the MEFE

		UPDATE `mongo_unitMetaData_step1`
			SET 	
			`displayName` = LEFT(`bzName`, LENGTH(`bzName`)-4)
			WHERE `bzId` > 264
		;

# We import the data for the Pilot user 1

    # Clean slate: make sure we flush all the variables we use:
        SET @pilot_user_id = NULL;
        SET @createdAt = NULL;
        SET @unit_owner_dev = NULL;
        SET @unit_owner_prod = NULL;
        SET @country = NULL;
        SET @unitType= NULL;

    # We define the pilot user id from the table `mongo_unit_data_migration`

        SET @pilot_user_id = 1;

    # We prepare the variables we need for the units for this pilot:

        SET @unit_owner_dev = (SELECT `unitOwnerIds_dev` FROM `mongo_unit_data_migration` WHERE `migration_record_id` = @pilot_user_id);
        SET @unit_owner_prod = (SELECT `unitOwnerIds_prod` FROM `mongo_unit_data_migration` WHERE `migration_record_id` = @pilot_user_id);
        SET @country = (SELECT `country` FROM `mongo_unit_data_migration` WHERE `migration_record_id` = @pilot_user_id);
        SET @unitType = (SELECT `unitType` FROM `mongo_unit_data_migration` WHERE `migration_record_id` = @pilot_user_id);

    # Update the info we need `mongo_unitMetaData_step1`:
    #	- ipi_id
    #	- address
    #	- zip
    #	- city
    # 	- country
    #	- moreInfo: we use the condo name there
    #	- Unit Type: We use the description 'Apartment/Flat'
    #	- ownerIds: we use the JSON string appropriate to the environment we are in

        UPDATE `mongo_unitMetaData_step1`
        INNER JOIN `pilot_1` 
            ON (`mongo_unitMetaData_step1`.`displayName` = `pilot_1`.`flat_id`)
            SET
            `mongo_unitMetaData_step1`.`ipi_id` = `pilot_1`.`ipi_id`
            , `mongo_unitMetaData_step1`.`city` = `pilot_1`.`city`
            , `mongo_unitMetaData_step1`.`country` = @country
            , `mongo_unitMetaData_step1`.`streetAddress` = `pilot_1`.`address`
            , `mongo_unitMetaData_step1`.`zipCode` = `pilot_1`.`zip`
            , `mongo_unitMetaData_step1`.`moreInfo` = `pilot_1`.`condo`
            , `mongo_unitMetaData_step1`.`unitType` = @unitType
            , `mongo_unitMetaData_step1`.`ownerIds` = IF(@environment = 1
                , @unit_owner_dev
                , IF(@environment= 2
                    , @unit_owner_prod
                    , 'something is wrong'
                )
            )
        ;

# Update the data for the Pilot 2 units:
    # Clean slate: make sure we flush all the variables we use:

        SET @pilot_user_id = NULL;
        SET @createdAt = NULL;
        SET @unit_owner_dev = NULL;
        SET @unit_owner_prod = NULL;
        SET @country = NULL;
        SET @unitType= NULL;

    # We define the pilot user id from the table `mongo_unit_data_migration`

        SET @pilot_user_id = 2;

    # We prepare the variables we need for the units for this pilot:

        SET @createdAt = (SELECT `createdAt` FROM `mongo_unit_data_migration` WHERE `migration_record_id` = @pilot_user_id);
        SET @unit_owner_dev = (SELECT `unitOwnerIds_dev` FROM `mongo_unit_data_migration` WHERE `migration_record_id` = @pilot_user_id);
        SET @unit_owner_prod = (SELECT `unitOwnerIds_prod` FROM `mongo_unit_data_migration` WHERE `migration_record_id` = @pilot_user_id);
        SET @country = (SELECT `country` FROM `mongo_unit_data_migration` WHERE `migration_record_id` = @pilot_user_id);
        SET @unitType = (SELECT `unitType` FROM `mongo_unit_data_migration` WHERE `migration_record_id` = @pilot_user_id);

    # Update the info we need `mongo_unitMetaData_step1`:
    #   - `createdAt`
    #	- `moreInfo`
    # 	- `unitType`
    #	- `city`
    #	- `country`
    #   - `state`
    #   - `streetAddress`
    #	- ownerIds: we use the JSON string appropriate to the environment we are in

        UPDATE `mongo_unitMetaData_step1`
        INNER JOIN `pilot_2` 
            ON (`mongo_unitMetaData_step1`.`displayName` = `pilot_2`.`unit_name`)
            SET
            `mongo_unitMetaData_step1`.`country` = @country
            , `mongo_unitMetaData_step1`.`moreInfo` = `pilot_2`.`description`
            , `mongo_unitMetaData_step1`.`ownerIds` = IF(@environment = 1
                , @unit_owner_dev
                , IF(@environment= 2
                    , @unit_owner_prod
                    , 'something is wrong'
                )
            )
        ;

# Update the data for the Pilot 3 units
    # Clean slate: make sure we flush all the variables we use:

        SET @pilot_user_id = NULL;
        SET @createdAt = NULL;
        SET @unit_owner_dev = NULL;
        SET @unit_owner_prod = NULL;
        SET @country = NULL;
        SET @unitType= NULL;

    # We define the pilot user id from the table `mongo_unit_data_migration`

        SET @pilot_user_id = 3;

    # We prepare the variables we need for the units for this pilot:

        SET @createdAt = (SELECT `createdAt` FROM `mongo_unit_data_migration` WHERE `migration_record_id` = @pilot_user_id);
        SET @unit_owner_dev = (SELECT `unitOwnerIds_dev` FROM `mongo_unit_data_migration` WHERE `migration_record_id` = @pilot_user_id);
        SET @unit_owner_prod = (SELECT `unitOwnerIds_prod` FROM `mongo_unit_data_migration` WHERE `migration_record_id` = @pilot_user_id);
        SET @country = (SELECT `country` FROM `mongo_unit_data_migration` WHERE `migration_record_id` = @pilot_user_id);
        SET @unitType = (SELECT `unitType` FROM `mongo_unit_data_migration` WHERE `migration_record_id` = @pilot_user_id);

    # Update the info we need `mongo_unitMetaData_step1`:
    #   - `createdAt`
    #	- `moreInfo`
    # 	- `unitType`
    #	- `city`
    #	- `country`
    #   - `state`
    #   - `streetAddress`
    #	- ownerIds: we use the JSON string appropriate to the environment we are in

        UPDATE `mongo_unitMetaData_step1`
        INNER JOIN `pilot_3` 
            ON (`mongo_unitMetaData_step1`.`displayName` = `pilot_3`.`displayName`)
            SET
            `mongo_unitMetaData_step1`.`createdAt` = `pilot_3`.`createdAt`
            , `mongo_unitMetaData_step1`.`moreInfo` = `pilot_3`.`moreInfo`
            , `mongo_unitMetaData_step1`.`unitType` = `pilot_3`.`unitType`
            , `mongo_unitMetaData_step1`.`city` = `pilot_3`.`city`
            , `mongo_unitMetaData_step1`.`country` = `pilot_3`.`country`
            , `mongo_unitMetaData_step1`.`state` = `pilot_3`.`state`
            , `mongo_unitMetaData_step1`.`streetAddress` = `pilot_3`.`streetAddress`
            , `mongo_unitMetaData_step1`.`ownerIds` = @unit_owner_prod
        ;

# We update the data for all the other manually created units

    # Clean slate: make sure we flush all the variables we use:
        SET @country = NULL;
        SET @unitType= NULL;
        SET @unit_owner_dev = NULL;
        SET @unit_owner_prod = NULL;
        SET @createdAt = NULL;

    # We only do this in the production environment!
    # Update the info we need `mongo_unitMetaData_step1`:
    #   - `createdAt`
    #	- `moreInfo`
    # 	- `unitType`
    #	- `city`
    #	- `country`
    #   - `state`
    #   - `streetAddress`
    #	- ownerIds: we use the JSON string appropriate to the environment we are in

        UPDATE `mongo_unitMetaData_step1`
        INNER JOIN `manually_created_units` 
            ON (`mongo_unitMetaData_step1`.`bzId` = `manually_created_units`.`bzId`)
            SET
            `mongo_unitMetaData_step1`.`createdAt` = `manually_created_units`.`createdAt`
            , `mongo_unitMetaData_step1`.`ownerIds` = `manually_created_units`.`ownerIds`
            , `mongo_unitMetaData_step1`.`moreInfo` = `manually_created_units`.`moreInfo`
            , `mongo_unitMetaData_step1`.`unitType` = `manually_created_units`.`unitType`
            , `mongo_unitMetaData_step1`.`city` = `manually_created_units`.`city`
            , `mongo_unitMetaData_step1`.`country` = `manually_created_units`.`country`
            , `mongo_unitMetaData_step1`.`displayName` = `manually_created_units`.`displayName`
            , `mongo_unitMetaData_step1`.`state` = `manually_created_units`.`state`
            , `mongo_unitMetaData_step1`.`streetAddress` = `manually_created_units`.`streetAddress`
            , `mongo_unitMetaData_step1`.`zipCode` = `manually_created_units`.`zipCode`
        ;

# We update the `createdAt` for the units where we have no information:

    # Created At

        SET @createdAt = (SELECT `createdAt` FROM `manually_created_units` WHERE `pilot_user` = 'DEFAULT_DATA');

        UPDATE `mongo_unitMetaData_step1`
            SET `createdAt` = @createdAt
            WHERE `createdAt` IS NULL
        ;

# If the `ownerIds` is NULL, then we define the `ownerIds` as the Default for Unee-T

	SET @default_owner_dev = (SELECT `ownerIds_dev` FROM `manually_created_units` WHERE `pilot_user` = 'DEFAULT_DATA');
	SET @default_owner_prod = (SELECT `ownerIds` FROM `manually_created_units` WHERE `pilot_user` = 'DEFAULT_DATA');

	UPDATE `mongo_unitMetaData_step1`
		SET `ownerIds` = IF(@environment = 1
			, @default_owner_dev
			, IF(@environment= 2
				, @default_owner_prod
				, 'something is wrong'
				)
			)
		WHERE `ownerIds` = '[  ]'
	;

# We prepare the table that we will use to import the data in Mongo:
		
	DROP TABLE IF EXISTS `mongo_unitMetaData_for_import`;
		
	CREATE TABLE `mongo_unitMetaData_for_import` 
		SELECT *
		FROM `mongo_unitMetaData`
	;

    # Make sure that we will insert only valid JSON there

        ALTER TABLE `mongo_unitMetaData_for_import` CHANGE `ownerIds` `ownerIds` JSON NOT NULL;

	# Update the table with the data we need

		UPDATE `mongo_unitMetaData_for_import`
		INNER JOIN `mongo_unitMetaData_step1` 
			ON (`mongo_unitMetaData_for_import`.`_id` = `mongo_unitMetaData_step1`.`_id`)
			SET 
            `mongo_unitMetaData_for_import`.`createdAt` = `mongo_unitMetaData_step1`.`createdAt`
            , `mongo_unitMetaData_for_import`.`ownerIds` = `mongo_unitMetaData_step1`.`ownerIds`
            , `mongo_unitMetaData_for_import`.`moreInfo` = `mongo_unitMetaData_step1`.`moreInfo`
            , `mongo_unitMetaData_for_import`.`unitType` = `mongo_unitMetaData_step1`.`unitType`
            , `mongo_unitMetaData_for_import`.`city` = `mongo_unitMetaData_step1`.`city`
            , `mongo_unitMetaData_for_import`.`country` = `mongo_unitMetaData_step1`.`country`
            , `mongo_unitMetaData_for_import`.`displayName` = `mongo_unitMetaData_step1`.`displayName`
            , `mongo_unitMetaData_for_import`.`state` = `mongo_unitMetaData_step1`.`state`
            , `mongo_unitMetaData_for_import`.`streetAddress` = `mongo_unitMetaData_step1`.`streetAddress`
            , `mongo_unitMetaData_for_import`.`zipCode` = `mongo_unitMetaData_step1`.`zipCode`
		;
		
	# We make sure that we do not have unecessary columns there:
		
		ALTER TABLE `mongo_unitMetaData_for_import` DROP COLUMN `primary_key`;