# Correct the format of the MEFE ids from int to varchar
# We need to do that in the following tables:
#	- `ut_data_to_create_units`
#	- `ut_data_to_replace_dummy_roles`
#	- `ut_data_to_add_user_to_a_role`
# 	- `ut_map_user_mefe_bzfe`

/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

	/* Foreign Keys must be dropped in the target to ensure that requires changes can be done*/

	ALTER TABLE `ut_data_to_add_user_to_a_role` 
		DROP FOREIGN KEY `add_user_to_a_role_bz_user_id`  , 
		DROP FOREIGN KEY `add_user_to_a_role_invitor_bz_id`  , 
		DROP FOREIGN KEY `add_user_to_a_role_product_id`  , 
		DROP FOREIGN KEY `add_user_to_a_role_role_type_id`  ;

	ALTER TABLE `ut_data_to_create_units` 
		DROP FOREIGN KEY `id_unit_classification_id`  , 
		DROP FOREIGN KEY `id_unit_creator_id`  ;

	ALTER TABLE `ut_data_to_replace_dummy_roles` 
		DROP FOREIGN KEY `replace_dummy_product_id`  , 
		DROP FOREIGN KEY `replace_dummy_role_bz_user_id`  , 
		DROP FOREIGN KEY `replace_dummy_role_invitor_bz_user_id`  , 
		DROP FOREIGN KEY `replace_dummy_role_role_type`  ;


	/* Alter table in target */
	ALTER TABLE `ut_data_to_add_user_to_a_role` 
		CHANGE `mefe_invitation_id` `mefe_invitation_id` varchar(256)  COLLATE utf8_general_ci NULL COMMENT 'The unique Id for the invitation that was generated in MEFE to do the data import' after `id` , 
		CHANGE `mefe_invitor_user_id` `mefe_invitor_user_id` varchar(256)  COLLATE utf8_general_ci NULL COMMENT 'The id of the creator of this unit in the MEFE database' after `mefe_invitation_id` ;

	/* Alter table in target */
	ALTER TABLE `ut_data_to_create_units` 
		CHANGE `mefe_id` `mefe_id` varchar(256)  COLLATE utf8_general_ci NULL COMMENT 'The id of the object in the MEFE interface where these information are coming from' after `id_unit_to_create` , 
		CHANGE `mefe_creator_user_id` `mefe_creator_user_id` varchar(256)  COLLATE utf8_general_ci NULL COMMENT 'The id of the creator of this unit in the MEFE database' after `mefe_id` , 
		CHANGE `mefe_unit_id` `mefe_unit_id` varchar(256)  COLLATE utf8_general_ci NULL COMMENT 'The id of this unit in the MEFE database' after `mefe_creator_user_id` ;

	/* Alter table in target */
	ALTER TABLE `ut_data_to_replace_dummy_roles` 
		CHANGE `mefe_invitation_id` `mefe_invitation_id` varchar(256)  COLLATE utf8_general_ci NULL COMMENT 'The unique Id for the invitation that was generated in MEFE to do the data import' after `id` , 
		CHANGE `mefe_invitor_user_id` `mefe_invitor_user_id` varchar(256)  COLLATE utf8_general_ci NULL COMMENT 'The id of the creator of this unit in the MEFE database' after `mefe_invitation_id` ;

	/* Alter table in target */
	ALTER TABLE `ut_map_user_mefe_bzfe` 
		ADD COLUMN `mefe_user_id` varchar(256)  COLLATE utf8_general_ci NULL COMMENT 'id of the user in the MEFE' after `bzfe_update_needed` , 
		CHANGE `bz_profile_id` `bz_profile_id` mediumint(6)   NULL COMMENT 'id of the user in the BZFE' after `mefe_user_id` , 
		DROP COLUMN `user_id` ; 

	/* The foreign keys that were dropped are now re-created*/

	ALTER TABLE `ut_data_to_add_user_to_a_role` 
		ADD CONSTRAINT `add_user_to_a_role_bz_user_id` 
		FOREIGN KEY (`bz_user_id`) REFERENCES `profiles` (`userid`) ON DELETE NO ACTION ON UPDATE CASCADE , 
		ADD CONSTRAINT `add_user_to_a_role_invitor_bz_id` 
		FOREIGN KEY (`bzfe_invitor_user_id`) REFERENCES `profiles` (`userid`) ON DELETE NO ACTION ON UPDATE CASCADE , 
		ADD CONSTRAINT `add_user_to_a_role_product_id` 
		FOREIGN KEY (`bz_unit_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE , 
		ADD CONSTRAINT `add_user_to_a_role_role_type_id` 
		FOREIGN KEY (`user_role_type_id`) REFERENCES `ut_role_types` (`id_role_type`) ON DELETE NO ACTION ON UPDATE CASCADE ;

	ALTER TABLE `ut_data_to_create_units` 
		ADD CONSTRAINT `id_unit_classification_id` 
		FOREIGN KEY (`classification_id`) REFERENCES `classifications` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE , 
		ADD CONSTRAINT `id_unit_creator_id` 
		FOREIGN KEY (`bzfe_creator_user_id`) REFERENCES `profiles` (`userid`) ON DELETE NO ACTION ON UPDATE CASCADE ;

	ALTER TABLE `ut_data_to_replace_dummy_roles` 
		ADD CONSTRAINT `replace_dummy_product_id` 
		FOREIGN KEY (`bz_unit_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE , 
		ADD CONSTRAINT `replace_dummy_role_bz_user_id` 
		FOREIGN KEY (`bz_user_id`) REFERENCES `profiles` (`userid`) ON DELETE NO ACTION ON UPDATE CASCADE , 
		ADD CONSTRAINT `replace_dummy_role_invitor_bz_user_id` 
		FOREIGN KEY (`bzfe_invitor_user_id`) REFERENCES `profiles` (`userid`) ON DELETE NO ACTION ON UPDATE CASCADE , 
		ADD CONSTRAINT `replace_dummy_role_role_type` 
		FOREIGN KEY (`user_role_type_id`) REFERENCES `ut_role_types` (`id_role_type`) ON DELETE NO ACTION ON UPDATE CASCADE ;

/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;