# This update is to make sure that we capture some information that would be useful down the road (logs)

# In the table 'ut_data_to_create_units'
# 	- make sure we can capture the product_id once we have created the unit
#	- When this unit is deleted make sure we can record 
#		- datetime when unit was deleted
#		- script used to delete the unit (and all objects related to that unit

	/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

	/* Alter table in target */
	ALTER TABLE `ut_data_to_create_units` 
		ADD COLUMN `product_id` SMALLINT(6)   NULL COMMENT 'The id of the product in the BZ table \'products\'. Because this is a record that we will keep even AFTER we deleted the record in the BZ table, this can NOT be a FK.' AFTER `comment` , 
		ADD COLUMN `deleted_datetime` DATETIME   NULL COMMENT 'Timestamp when this was deleted in the BZ db (together with all objects related to this product/unit).' AFTER `product_id` , 
		ADD COLUMN `deletion_script` VARCHAR(500)  COLLATE utf8_general_ci NULL COMMENT 'The script used to delete this product and all objects related to this product in the BZ database' AFTER `deleted_datetime` ;

	/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;