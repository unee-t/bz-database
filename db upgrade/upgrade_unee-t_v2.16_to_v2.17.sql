# This script update the BZ database from w2.16 to v2.17

# We need to drop several tables that are not needed (just in case)

	DROP TABLE IF EXISTS `cf_claim_type`;
	DROP TABLE IF EXISTS `cf_ipi_clust_5_budget_approver`;
	DROP TABLE IF EXISTS `cf_ipi_clust_7_payment_type`;
	DROP TABLE IF EXISTS `ut_bug_status`;
	DROP TABLE IF EXISTS `ut_cf_ipi_clust_3_action_type`;
	DROP TABLE IF EXISTS `ut_fielddefs`;
	DROP TABLE IF EXISTS `ut_rep_platform`;
	
# We need to make sure that all the 'ut_xxx_types' tables are correctly populated
# We added 1 group_type and 2 permission types

	/*!40101 SET NAMES utf8 */;

	/*!40101 SET SQL_MODE=''*/;

	/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
	/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
	/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
	/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
	/*Table structure for table `ut_group_types` */

	DROP TABLE IF EXISTS `ut_group_types`;

	CREATE TABLE `ut_group_types` (
	  `id_group_type` SMALLINT(6) NOT NULL AUTO_INCREMENT COMMENT 'ID in this table',
	  `created` DATETIME DEFAULT NULL COMMENT 'creation ts',
	  `order` SMALLINT(6) DEFAULT NULL COMMENT 'Order in the list',
	  `is_obsolete` TINYINT(1) NOT NULL DEFAULT '0' COMMENT 'This is an obsolete record',
	  `groupe_type` VARCHAR(255) NOT NULL COMMENT 'A name for this group type',
	  `bz_description` VARCHAR(255) DEFAULT NULL COMMENT 'A short description for BZ which we use when we create the group',
	  `description` TEXT COMMENT 'Detailed description of this group type',
	  PRIMARY KEY (`id_group_type`,`groupe_type`)
	) ENGINE=INNODB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8;

	/*Data for the table `ut_group_types` */

	INSERT  INTO `ut_group_types`(`id_group_type`,`created`,`order`,`is_obsolete`,`groupe_type`,`bz_description`,`description`) VALUES 
	(1,NOW(),50,0,'creator','User has created the unit or has full delegation','The group for the user who has created the unit first and/or his representatives (agent or employee).'),
	(2,NOW(),210,0,'hide_show_case_from_role','Visible only to','These are product/unit and bug/case visibility groups. \r\nThese groups are in the table bug_group_map.'),
	(3,NOW(),320,0,'list_occupants','User is an occupant of the unit','These are also bug visibility groups but based on a different information: is the user an occupant of the unit or not?\r\nA Tenant can also be an occupant (or not)\r\nAn Owner/Landlord can also be an occupant (or not).'),
	(4,NOW(),400,0,'list_visible_stakeholder','List all the users who have a role in this unit','This is a user visibility group (step 1).\r\nAll the users in this group have a role in this unit.'),
	(5,NOW(),410,0,'see_visible_stakeholder','See all the stakeholders','This is a user visibility group (step 2).\r\nIf you are member of this group, you can see all the user in the list_stakeholder group for this unit.'),
	(6,NOW(),500,0,'r_a_case_next_step','Requestee to approve the Next Step of a case','This is a group for the list of Requestee. It is specific to each unit so we do not ask user to grant approval on a case they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to request approval for the Next Step for a case in this unit.'),
	(7,NOW(),600,0,'g_a_case_next_step','Grant approval for the Next Step of a case','This is a group for the list of Grantor. It is specific to each unit so we do not ask user to grant approval on a case they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to grant approval for the Next Step for a case in this unit.'),
	(8,NOW(),510,0,'r_a_case_solution','Requestee to approve the Solution of a case','This is a group for the list of Requestee. It is specific to each unit so we do not ask user to grant approval on a case they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to request approval for the Solution for a case in this unit.'),
	(9,NOW(),610,0,'g_a_case_solution','Grant approval for the Solution of a case','This is a group for the list of Grantor. It is specific to each unit so we do not ask user to grant approval on a case they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to grant approval for the Solution for a case in this unit.'),
	(10,NOW(),520,0,'r_a_case_budget','Requestee to approve the Budget for a case','This is a group for the list of Requestee. It is specific to each unit so we do not ask user to grant approval on a case they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to request approval for the Budget for a case in this unit.'),
	(11,NOW(),620,0,'g_a_case_budget','Grant approval for the Budget for a case','This is a group for the list of Grantor. It is specific to each unit so we do not ask user to grant approval on a case they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to grant approval for the Budget for a case in this unit.'),
	(12,NOW(),700,0,'r_a_attachment_approve','Requestee to approve the Attachment','This is a group for the list of Requestee. It is specific to each unit so we do not ask user to grant approval on an Attachment they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to request approval for an Attachment in this unit.'),
	(13,NOW(),800,0,'g_a_attachment_approve','Grant approval for the Attachment','This is a group for the list of Grantor. It is specific to each unit so we do not ask user to grant approval on an Attachment they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to grant approval for an Attachment in this unit.'),
	(14,NOW(),710,0,'r_a_attachment_ok_to_pay','Requestee to approve pay a bill','This is a group for the list of Requestee. It is specific to each unit so we do not ask user to grant approval on an Attachment they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to request approval to pay a specific bill in this unit.'),
	(15,NOW(),810,0,'g_a_attachment_ok_to_pay','Grant approval to pay a bill','This is a group for the list of Grantor. It is specific to each unit so we do not ask user to grant approval on an Attachment they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to grant approval to pay a specific bill in this unit.'),
	(16,NOW(),720,0,'r_a_attachment_is_paid','Requestee to confirm if a bill has been paid','This is a group for the list of Requestee. It is specific to each unit so we do not ask user to grant approval on an Attachment they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to confirm if a specific bill has been paid in this unit.'),
	(17,NOW(),820,0,'g_a_attachment_is_paid','Confirms if a bill has been paid','This is a group for the list of Grantor. It is specific to each unit so we do not ask user to grant approval on an Attachment they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit confirm if a specific bill has been paid in this unit.'),
	(18,NOW(),999,0,'all_r_flags','Grant approval for all flags','This is a group for the list of Requestee. It is specific to each unit so we do not ask user to grant approval on an Attachment they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit confirm if a specific bill has been paid in this unit.'),
	(19,NOW(),999,0,'all_g_all_flags','Confirms if a bill has been paid','This is a group for the list of Grantor. It is specific to each unit so we do not ask user to grant approval on an Attachment they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit confirm if a specific bill has been paid in this unit.'),
	(20,NOW(),100,0,'create_a_case','Group to be able to create cases in a unit','This is a group that helps us grant all shared accessed and permission in bulk to a user.\r\nIf you are member of this group, you can access, grant, request and be requested to approve all the Flags for a specific unit.'),
	(21,NOW(),10000,0,'user_aggregation','Facilitate user management','This is to group user together (users working in the same company for example) so we can give them all the same permissions.'),
	(22,NOW(),300,0,'list_users_in_role','List all user in a role','All the users in the same role/component for a given unit'),
	(24,NOW(),220,0,'hide_show_case_from_occupant','Untick to hide a case from the occupants of the unit',NULL),
	(25,NOW(),110,0,'can_edit_a_case','User can edit a case','This is for the group that grant permission to edit a case. \r\nThis is product group. \r\na The attributes for this group in the group_access_control table are N/A, N/A'),
	(26,NOW(),120,0,'can_edit_all_fields_in_a_case','Untick to hide a case from the occupants of the unit','This is for the group that grant permission to edit a case. \r\nThis is product group. \r\na The attributes for this group in the group_access_control table are N/A, N/A'),
	(27,NOW(),130,0,'can_edit_components_roles','Needed so that a user can create new users','This is for the group that grant permission to create new users. \r\nThis is product group. \r\na The attributes for this group in the group_access_control table are N/A, N/A'),
	(28,NOW(),200,0,'case_is_visible_to_all','Untick to limit this case only to certain roles','This is for the group that limit visibility of a case by default. \r\nThis is product group. \r\na The attributes for this group in the group_access_control table are Default, N/A'),
	(29,NOW(),420,0,'active_stakeholder','Active Stakeholder',''),
	(30,NOW(),10,0,'single_user_roup','A group for a Single user','We use this to simplify the user_group_mapping. \r\nThis allows us to use group_group_map instead since it is easier to grant and revoke privileges with groups'),
	(31,NOW(),60,0,'invited_by','List of users who were invited by the same user','List of users who were invited by the same user'),
	(32,NOW(),430,0,'see_all_invited_by','User Visibility group - for users who need to see all the users invited by a certain user','User Visibility group - for users who need to see all the users invited by a certain user'),
	(33,NOW(),20,0,'timetracking','Can see timetracking information','Grants persmission to see timetracking information for a case.'),
	(34,NOW(),30,0,'create_shared_queries','User is allowed to share some of the queries he/she has created','User is allowed to share some of the queries he/she has created'),
	(35,NOW(),40,0,'tag_comment','User is allowed to tag comments','User in this group are allowed to tag comment.\r\nALL users should be members of this group: tags are the mechanisms to mark a comment as received, read etc.... Tags are also a way to add reactions to a comment (emoji for instance).'),
	(36,NOW(),330,0,'see_occupant','Can see the list of occupants','User in this group can see the list of occupants for a unit.'),
	(37,NOW(),310,0,'see_user_in_role','Can see the list of users for a given role','User in this group can see the list of users for a given role.'),
	(38,NOW(),140,0,'can_see_unit_in_search','Restrict visibility of a unit in the search panel','You need to be a member of this group so that the unit is listed in the Search.\r\nThis group is referenced in the group_control_map as MANDATORY/MANDATORY for a given unit.');

	/*Table structure for table `ut_permission_types` */

	DROP TABLE IF EXISTS `ut_permission_types`;

	CREATE TABLE `ut_permission_types` (
	  `id_permissin_type` SMALLINT(6) NOT NULL AUTO_INCREMENT COMMENT 'ID in this table',
	  `created` DATETIME DEFAULT NULL COMMENT 'creation ts',
	  `order` SMALLINT(6) DEFAULT NULL COMMENT 'Order in the list',
	  `is_obsolete` TINYINT(1) DEFAULT '0' COMMENT '1 if this is an obsolete value',
	  `group_type_id` SMALLINT(6) DEFAULT NULL COMMENT 'The id of the group that grant this permission - a FK to the table ut_group_types',
	  `permission_type` VARCHAR(255) NOT NULL COMMENT 'A name for this role type',
	  `permission_scope` VARCHAR(255) DEFAULT NULL COMMENT '4 possible values: GLOBAL: for all units and roles, UNIT: permission for a specific unit, ROLE: permission for a specific role in a specific unit, SPECIAL: special permission (ex: occupant)',
	  `permission_category` VARCHAR(255) DEFAULT NULL COMMENT 'Possible values: ACCESS: group_control, GRANT FLAG: permissions to grant flags, ASK FOR APPROVAL: can ask a specific user to approve a flag, ROLE: a user is in a given role,',
	  `is_bless` TINYINT(1) DEFAULT '0' COMMENT '1 if this is a permission to grant membership to a given group',
	  `bless_id` SMALLINT(6) DEFAULT NULL COMMENT 'IF this is a ''blessing'' permission - which permission can this grant',
	  `description` VARCHAR(255) DEFAULT NULL COMMENT 'A short, generic description that we include each time we create a new BZ unit.',
	  `detailed_description` TEXT COMMENT 'Detailed description of this group type',
	  PRIMARY KEY (`id_permissin_type`,`permission_type`),
	  KEY `premission_groupe_type` (`group_type_id`),
	  CONSTRAINT `premission_groupe_type` FOREIGN KEY (`group_type_id`) REFERENCES `ut_group_types` (`id_group_type`) ON DELETE CASCADE ON UPDATE CASCADE
	) ENGINE=INNODB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8;

	/*Data for the table `ut_permission_types` */

	INSERT  INTO `ut_permission_types`(`id_permissin_type`,`created`,`order`,`is_obsolete`,`group_type_id`,`permission_type`,`permission_scope`,`permission_category`,`is_bless`,`bless_id`,`description`,`detailed_description`) VALUES 
	(1,NOW(),10,0,33,'can_see_time_tracking','GLOBAL','FUNCTIONALITY',0,NULL,'The user can see the time tracking information',NULL),
	(2,NOW(),20,0,33,'can_grant_see_time_tracking','GLOBAL','FUNCTIONALITY',1,1,'The user can allow another user to see time tracking information',NULL),
	(3,NOW(),30,0,34,'can_create_shared_query','GLOBAL','FUNCTIONALITY',0,NULL,NULL,NULL),
	(4,NOW(),40,0,34,'can_grant_create_shared_query','GLOBAL','FUNCTIONALITY',1,3,NULL,NULL),
	(5,NOW(),50,0,35,'can_tag_comment','GLOBAL','FUNCTIONALITY',0,NULL,'This should be mandatory for all users: flags are allowing us to mark a comment as sent, received, read, and allow us to add emoticons for instance',NULL),
	(6,NOW(),60,0,35,'can_grant_tag_comment','GLOBAL','FUNCTIONALITY',1,5,NULL,NULL),
	(7,NOW(),70,0,3,'is_occupant','UNIT','VISIBLE USER',0,NULL,NULL,NULL),
	(8,NOW(),80,0,3,'can_grant_is_occupant','UNIT','VISIBLE USER',1,7,NULL,NULL),
	(9,NOW(),90,0,36,'can_see_occupant','UNIT','VIEW USER',0,NULL,NULL,NULL),
	(10,NOW(),100,0,36,'can_grant_see_occupant','UNIT','VIEW USER',1,9,NULL,NULL),
	(11,NOW(),110,0,20,'can_create_new_case','UNIT','ACCESS',0,NULL,NULL,NULL),
	(12,NOW(),120,0,20,'can_grant_create_new_case','UNIT','ACCESS',1,11,NULL,NULL),
	(13,NOW(),130,0,25,'can_edit_a_case','UNIT','ACCESS',0,NULL,NULL,NULL),
	(14,NOW(),140,0,25,'can_grant_edit_a_case','UNIT','ACCESS',1,13,NULL,NULL),
	(15,NOW(),150,0,28,'can_see_public_cases','UNIT','ACCESS',0,NULL,NULL,NULL),
	(16,NOW(),160,0,28,'can_grant_see_public_cases','UNIT','ACCESS',1,15,NULL,NULL),
	(17,NOW(),170,0,26,'can_edit_all_field_in_a_case_regardless_of_role','UNIT','FUNCTIONALITY',0,NULL,NULL,NULL),
	(18,NOW(),180,0,26,'can_grant_edit_all_field_in_a_case_regardless_of_role','UNIT','FUNCTIONALITY',1,17,NULL,NULL),
	(19,NOW(),190,0,4,'user_is_publicly_visible','UNIT','VISIBLE USER',0,NULL,NULL,NULL),
	(20,NOW(),200,0,4,'can_grant_user_is_publicly_visible','UNIT','VISIBLE USER',1,19,NULL,NULL),
	(21,NOW(),210,0,5,'user_can_see_publicly_visible_user','UNIT','VIEW USER',0,NULL,NULL,NULL),
	(22,NOW(),220,0,5,'can_grant_user_can_see_publicly_visible_user','UNIT','VIEW USER',1,21,NULL,NULL),
	(23,NOW(),230,0,18,'can_ask_to_approve_flag','UNIT','FLAG',0,NULL,NULL,NULL),
	(24,NOW(),240,0,18,'can_grant_can_ask_to_approve_flag','UNIT','FLAG',1,23,NULL,NULL),
	(25,NOW(),250,0,19,'can_approve_flag','UNIT','FLAG',0,NULL,NULL,NULL),
	(26,NOW(),260,0,19,'can_grant_can_approve_flag','UNIT','FLAG',1,25,NULL,NULL),
	(27,NOW(),270,0,2,'show_case_to_tenant','UNIT-ROLE','ACCESS',0,NULL,NULL,NULL),
	(28,NOW(),280,0,2,'can_grant_show_case_to_tenant','UNIT-ROLE','ACCESS',1,27,NULL,NULL),
	(29,NOW(),290,0,22,'user_is_tenant','UNIT-ROLE','VISIBLE USER',0,NULL,NULL,NULL),
	(30,NOW(),300,0,22,'can_grant_user_is_tenant','UNIT-ROLE','VISIBLE USER',1,29,NULL,NULL),
	(31,NOW(),310,0,37,'can_see_tenant','UNIT-ROLE','VIEW USER',0,NULL,NULL,NULL),
	(32,NOW(),320,0,37,'can_grant_can_see_tenant','UNIT-ROLE','VIEW USER',1,31,NULL,NULL),
	(33,NOW(),330,0,2,'show_case_to_landlord','UNIT-ROLE','ACCESS',0,NULL,NULL,NULL),
	(34,NOW(),340,0,2,'can_grant_show_case_to_landlord','UNIT-ROLE','ACCESS',1,33,NULL,NULL),
	(35,NOW(),350,0,22,'user_is_lanldord','UNIT-ROLE','VISIBLE USER',0,NULL,NULL,NULL),
	(36,NOW(),360,0,22,'can_grant_user_is_lanldord','UNIT-ROLE','VISIBLE USER',1,35,NULL,NULL),
	(37,NOW(),370,0,37,'can_see_landlord','UNIT-ROLE','VIEW USER',0,NULL,NULL,NULL),
	(38,NOW(),380,0,37,'can_grant_can_see_landlord','UNIT-ROLE','VIEW USER',1,37,NULL,NULL),
	(39,NOW(),390,0,2,'show_case_to_agent','UNIT-ROLE','ACCESS',0,NULL,NULL,NULL),
	(40,NOW(),400,0,2,'can_grant_show_case_to_agent','UNIT-ROLE','ACCESS',1,39,NULL,NULL),
	(41,NOW(),410,0,22,'user_is_agent','UNIT-ROLE','VISIBLE USER',0,NULL,NULL,NULL),
	(42,NOW(),420,0,22,'can_grant_user_is_agent','UNIT-ROLE','VISIBLE USER',1,41,NULL,NULL),
	(43,NOW(),430,0,37,'can_see_agent','UNIT-ROLE','VIEW USER',0,NULL,NULL,NULL),
	(44,NOW(),440,0,37,'can_grant_can_see_agent','UNIT-ROLE','VIEW USER',1,43,NULL,NULL),
	(45,NOW(),450,0,2,'show_case_to_contractor','UNIT-ROLE','ACCESS',0,NULL,NULL,NULL),
	(46,NOW(),460,0,2,'can_grant_show_case_to_contractor','UNIT-ROLE','ACCESS',1,45,NULL,NULL),
	(47,NOW(),470,0,22,'user_is_contractor','UNIT-ROLE','VISIBLE USER',0,NULL,NULL,NULL),
	(48,NOW(),480,0,22,'can_grant_user_is_contractor','UNIT-ROLE','VISIBLE USER',1,47,NULL,NULL),
	(49,NOW(),490,0,37,'can_see_contractor','UNIT-ROLE','VIEW USER',0,NULL,NULL,NULL),
	(50,NOW(),500,0,37,'can_grant_can_see_contractor','UNIT-ROLE','VIEW USER',1,49,NULL,NULL),
	(51,NOW(),510,0,2,'show_case_to_mgt_cny','UNIT-ROLE','ACCESS',0,NULL,NULL,NULL),
	(52,NOW(),520,0,2,'can_grant_show_case_to_mgt_cny','UNIT-ROLE','ACCESS',1,51,NULL,NULL),
	(53,NOW(),530,0,22,'user_is_mgt_cny','UNIT-ROLE','VISIBLE USER',0,NULL,NULL,NULL),
	(54,NOW(),540,0,22,'can_grant_user_is_mgt_cny','UNIT-ROLE','VISIBLE USER',1,53,NULL,NULL),
	(55,NOW(),550,0,37,'can_see_mgt_cny','UNIT-ROLE','VIEW USER',0,NULL,NULL,NULL),
	(56,NOW(),560,0,37,'can_grant_can_see_mgt_cny','UNIT-ROLE','VIEW USER',1,55,NULL,NULL),
	(57,NOW(),64,0,24,'show_case_to_occupant','UNIT','ACCESS',0,NULL,NULL,NULL),
	(58,NOW(),66,0,24,'can_grant_show_case_to_occupant','UNIT','ACCESS',1,57,NULL,NULL),
	(59,NOW(),590,0,31,'user_is_invited_by','GLOBAL','VISIBLE USER',0,NULL,NULL,NULL),
	(60,NOW(),600,0,31,'can_grant_user_is_invited_by','GLOBAL','VIEW USER',1,59,NULL,NULL),
	(61,NOW(),610,0,38,'user_can_see_that_unit_in_search','UNIT','ACCESS',0,NULL,NULL,NULL),
	(62,NOW(),620,0,38,'can_grant_see_that_unit_in_search','UNIT','ACCESS',1,61,NULL,NULL);
	/*Table structure for table `ut_role_types` */

	DROP TABLE IF EXISTS `ut_role_types`;

	CREATE TABLE `ut_role_types` (
	  `id_role_type` SMALLINT(6) NOT NULL AUTO_INCREMENT COMMENT 'ID in this table',
	  `created` DATETIME DEFAULT NULL COMMENT 'creation ts',
	  `role_type` VARCHAR(255) NOT NULL COMMENT 'A name for this role type',
	  `bz_description` VARCHAR(255) DEFAULT NULL COMMENT 'A short, generic description that we include each time we create a new BZ unit.',
	  `description` TEXT COMMENT 'Detailed description of this group type',
	  PRIMARY KEY (`id_role_type`)
	) ENGINE=INNODB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

	/*Data for the table `ut_role_types` */

	INSERT  INTO `ut_role_types`(`id_role_type`,`created`,`role_type`,`bz_description`,`description`) VALUES 
	(1,NOW(),'Tenant','The Tenant','The person or entity who signed the tenancy agreement.'),
	(2,NOW(),'Owner/Landlord','The Landlord','The person(s) or entity that are the registered owner of the property.'),
	(3,NOW(),'Contractor','A contractor','A company or a person that can or will do work in the unit (electricity, plumbing, Aircon Maintenance, Housekeeping, etc...).'),
	(4,NOW(),'Management Company','The management Company','Is in charge of day to day operations and responsible to fix things if something happens in a unit.'),
	(5,NOW(),'Agent','An agent','The user who act as either the representative for the Tenant or for the Landlord. It is possible to have 2 agents attached to the same unit.');

	/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
	/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
	/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
	/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
