# The below script needs to be run in the LMB ipi database to retrive the address we have on record
#     This prepares the table `pilot_1` so we can import the unitMetaData for the LMB units
#
    DROP TABLE IF EXISTS `pilot_1`;

    CREATE TABLE `pilot_1`
        AS 
        SELECT
            `db_all_dt_2_flats`.`system_id_flat` AS `ipi_id`
            , `db_all_dt_2_flats`.`flat_id`
            , `db_sourcing_ls_0_condo`.`id_condo`
            , `db_sourcing_ls_0_condo`.`condo`
            , `db_sourcing_dt_1_addresses`.`address`
            , `db_sourcing_dt_1_addresses`.`zip`
            , 'Singapore' AS `city`
        FROM
            `db_all_dt_2_flats`
        INNER JOIN `db_sourcing_ls_0_condo` 
            ON (`db_all_dt_2_flats`.`condo_id` = `db_sourcing_ls_0_condo`.`id_condo`)
            INNER JOIN `db_sourcing_dt_1_addresses` 
            ON (`db_all_dt_2_flats`.`condo_id` = `db_sourcing_dt_1_addresses`.`condo_id`) AND (`db_all_dt_2_flats`.`tower` = `db_sourcing_dt_1_addresses`.`tower`)
    ;