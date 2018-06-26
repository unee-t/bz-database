# This script must be run AFTER the import into the mongo collection `unitRoleData` is done

# Clean up - Get rid of all the unecessary tables 

# For `unitRoleData`

	DROP TABLE IF EXISTS `ut_mongo_migrate_unitRoleData_list_groups_direct_role_granting`;
	DROP TABLE IF EXISTS `ut_mongo_migrate_unitRoleData_list_users_roles_direct`;
	DROP TABLE IF EXISTS `ut_mongo_migrate_unitRoleData_list_groups_indirect_role_grant_L1`;
	DROP TABLE IF EXISTS `ut_mongo_migrate_unitRoleData_list_users_roles_indirect_level1`;
	DROP TABLE IF EXISTS `ut_mongo_migrate_unitRoleData_list_groups_indirect_role_grant_L2`;
	DROP TABLE IF EXISTS `ut_mongo_migrate_unitRoleData_list_users_roles_indirect_level2`;
	DROP TABLE IF EXISTS `ut_mongo_migrate_unitRoleData_list_users`;
	DROP TABLE IF EXISTS `ut_mongo_migrate_unitRoleData_list_members_step1`;
	DROP TABLE IF EXISTS `ut_mongo_migrate_unitRoleData_list_members_step2`;
	DROP TABLE IF EXISTS `ut_mongo_migrate_unitRoleData_step1`;
	DROP TABLE IF EXISTS `mongo_unitRolesData_for_import`;
	DROP TABLE IF EXISTS `mongo_unitRolesData`;
	DROP TABLE IF EXISTS `mongo_users`;

# for unit_Metadata
	DROP TABLE IF EXISTS `mongo_unit_data_migration`;
	DROP TABLE IF EXISTS `pilot_1`;
	DROP TABLE IF EXISTS `pilot_2`;
	DROP TABLE IF EXISTS `pilot_3`;
	DROP TABLE IF EXISTS `manually_created_units`;
	DROP TABLE IF EXISTS `mongo_unitMetaData`;
	DROP TABLE IF EXISTS `mongo_unitMetaData_step1`;
	DROP TABLE IF EXISTS `mongo_unitMetaData_for_import`;