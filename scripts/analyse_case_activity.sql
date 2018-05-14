DROP VIEW IF EXISTS `activity_prod`;

CREATE VIEW `activity_prod`
AS
SELECT
    YEAR (`ut_temp_legacy_case_activity`.`created_datetime`) AS `year`
    , MONTH (`ut_temp_legacy_case_activity`.`created_datetime`) AS `month`
    ,`ut_temp_legacy_case_activity`.`case_activity_id`
    , `ut_temp_legacy_case_activity`.`unit_id`
    , `products`.`name`
    , `ut_temp_legacy_case_activity`.case_id
    , `ut_temp_legacy_case_activity`.user_id
    , `ut_temp_legacy_case_activity`.update_what
    , `ut_temp_legacy_case_activity`.`created_datetime` AS `when`
FROM
    `ut_temp_legacy_case_activity`
    INNER JOIN `products` 
        ON (`ut_temp_legacy_case_activity`.`unit_id` = `products`.`id`)
WHERE `ut_temp_legacy_case_activity`.`created_datetime` > '2017-05-31 23:59:59'

ORDER BY `created_datetime` DESC, `unit_id` ASC
;
 