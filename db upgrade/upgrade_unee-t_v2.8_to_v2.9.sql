# This script upgrade the BZFE for Unee-T from v2.8 to v2.9.
# In this upgrade we:
# 	- Add more ut_group_types
#	- Alter the table ut_product_group to include the component_id information


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
	  `is_obsolete` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'This is an obsolete record',
	  `groupe_type` VARCHAR(255) NOT NULL COMMENT 'A name for this group type',
	  `bz_description` VARCHAR(255) DEFAULT NULL COMMENT 'A short description for BZ which we use when we create the group',
	  `description` TEXT DEFAULT NULL COMMENT 'Detailed description of this group type',
	  PRIMARY KEY (`id_group_type`,`groupe_type`)
	) ENGINE=INNODB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8;

/*Data for the table `ut_group_types` */

	INSERT  INTO `ut_group_types`
		(`id_group_type`
		,`created`
		,`order`
		,`is_obsolete`
		,`groupe_type`
		,`bz_description`
		,`description`
		) 
		VALUES 
		(1,'2017-10-31 07:32:27',10,0,'creator','User has created the unit or has full delegation','The group for the user who has created the unit first and/or his representatives (agent or employee).'),
		(2,'2017-10-31 07:32:27',210,0,'hide/show_case_from_role','Visible only to','These are product/unit and bug/case visibility groups. \r\nThese groups are in the table bug_group_map.'),
		(3,'2017-10-31 07:32:27',310,0,'list_occupants','User is an occupant of the unit','These are also bug visibility groups but based on a different information: is the user an occupant of the unit or not?\r\nA Tenant can also be an occupant (or not)\r\nAn Owner/Landlord can also be an occupant (or not).'),
		(4,'2017-10-31 07:32:27',400,0,'list_visible_stakeholder','List all the users who have a role in this unit','This is a user visibility group (step 1).\r\nAll the users in this group have a role in this unit.'),
		(5,'2017-10-31 07:32:27',410,0,'see_visible_stakeholder','See all the stakeholders','This is a user visibility group (step 2).\r\nIf you are member of this group, you can see all the user in the list_stakeholder group for this unit.'),
		(6,'2017-10-31 07:32:27',500,0,'r_a_case_next_step','Requestee to approve the Next Step of a case','This is a group for the list of Requestee. It is specific to each unit so we do not ask user to grant approval on a case they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to request approval for the Next Step for a case in this unit.'),
		(7,'2017-10-31 07:32:27',600,0,'g_a_case_next_step','Grant approval for the Next Step of a case','This is a group for the list of Grantor. It is specific to each unit so we do not ask user to grant approval on a case they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to grant approval for the Next Step for a case in this unit.'),
		(8,'2017-10-31 07:32:27',510,0,'r_a_case_solution','Requestee to approve the Solution of a case','This is a group for the list of Requestee. It is specific to each unit so we do not ask user to grant approval on a case they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to request approval for the Solution for a case in this unit.'),
		(9,'2017-10-31 07:32:27',610,0,'g_a_case_solution','Grant approval for the Solution of a case','This is a group for the list of Grantor. It is specific to each unit so we do not ask user to grant approval on a case they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to grant approval for the Solution for a case in this unit.'),
		(10,'2017-10-31 07:32:27',520,0,'r_a_case_budget','Requestee to approve the Budget for a case','This is a group for the list of Requestee. It is specific to each unit so we do not ask user to grant approval on a case they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to request approval for the Budget for a case in this unit.'),
		(11,'2017-10-31 07:32:27',620,0,'g_a_case_budget','Grant approval for the Budget for a case','This is a group for the list of Grantor. It is specific to each unit so we do not ask user to grant approval on a case they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to grant approval for the Budget for a case in this unit.'),
		(12,'2017-10-31 07:32:27',700,0,'r_a_attachment_approve','Requestee to approve the Attachment','This is a group for the list of Requestee. It is specific to each unit so we do not ask user to grant approval on an Attachment they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to request approval for an Attachment in this unit.'),
		(13,'2017-10-31 07:32:27',800,0,'g_a_attachment_approve','Grant approval for the Attachment','This is a group for the list of Grantor. It is specific to each unit so we do not ask user to grant approval on an Attachment they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to grant approval for an Attachment in this unit.'),
		(14,'2017-10-31 07:32:27',710,0,'r_a_attachment_ok_to_pay','Requestee to approve pay a bill','This is a group for the list of Requestee. It is specific to each unit so we do not ask user to grant approval on an Attachment they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to request approval to pay a specific bill in this unit.'),
		(15,'2017-10-31 07:32:27',810,0,'g_a_attachment_ok_to_pay','Grant approval to pay a bill','This is a group for the list of Grantor. It is specific to each unit so we do not ask user to grant approval on an Attachment they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to grant approval to pay a specific bill in this unit.'),
		(16,'2017-10-31 07:32:27',720,0,'r_a_attachment_is_paid','Requestee to confirm if a bill has been paid','This is a group for the list of Requestee. It is specific to each unit so we do not ask user to grant approval on an Attachment they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to confirm if a specific bill has been paid in this unit.'),
		(17,'2017-10-31 07:32:27',820,0,'g_a_attachment_is_paid','Confirms if a bill has been paid','This is a group for the list of Grantor. It is specific to each unit so we do not ask user to grant approval on an Attachment they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit confirm if a specific bill has been paid in this unit.'),
		(18,'2017-10-31 07:32:27',999,0,'all_r_flags','Grant approval for all flags','This is a group for the list of Requestee. It is specific to each unit so we do not ask user to grant approval on an Attachment they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit confirm if a specific bill has been paid in this unit.'),
		(19,'2017-10-31 07:32:27',999,0,'all_g_all_flags','Confirms if a bill has been paid','This is a group for the list of Grantor. It is specific to each unit so we do not ask user to grant approval on an Attachment they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit confirm if a specific bill has been paid in this unit.'),
		(20,'2017-10-31 07:32:27',100,0,'Create a case','Group to be able to create cases in a unit','This is a group that helps us grant all shared accessed and permission in bulk to a user.\r\nIf you are member of this group, you can access, grant, request and be requested to approve all the Flags for a specific unit.'),
		(21,'2017-10-31 07:32:27',10000,0,'user_aggregation','Facilitate user management','This is to group user together (users working in the same company for example) so we can give them all the same permissions.'),
		(22,'2017-10-31 07:32:27',300,0,'list_users_in_role','List all user in a role','All the users in the same role/component for a given unit'),
		(24,'2017-10-31 07:32:27',220,0,'hide/show_case_from_occupant','Untick to hide a case from the occupants of the unit',NULL),
		(25,'2017-10-31 07:32:27',110,0,'Can edit a case','User can edit a case','This is for the group that grant permission to edit a case. \r\nThis is product group. \r\na The attributes for this group in the group_access_control table are N/A, N/A'),
		(26,'2017-10-31 07:32:27',120,0,'Can edit all fields in a case','Untick to hide a case from the occupants of the unit','This is for the group that grant permission to edit a case. \r\nThis is product group. \r\na The attributes for this group in the group_access_control table are N/A, N/A'),
		(27,'2017-10-31 07:32:27',130,0,'Can Edit components - roles','Needed so that a user can create new users','This is for the group that grant permission to create new users. \r\nThis is product group. \r\na The attributes for this group in the group_access_control table are N/A, N/A'),
		(28,'2017-10-31 07:32:27',200,0,'Case is visible to all','Untick to limit this case only to certain roles','This is for the group that limit visibility of a case by default. \r\nThis is product group. \r\na The attributes for this group in the group_access_control table are Default, N/A'),
		(29,'2017-10-31 07:32:27',420,0,'Active Stakeholder','Active Stakeholder',''),
		(30,'2017-10-31 07:32:27',0,0,'Single User Group','A group for a Single user','We use this to simplify the user_group_mapping. \r\nThis allows us to use group_group_map instead since it is easier to grant and revoke privileges with groups'),
		(31,'2017-10-31 07:32:27',20,0,'Invited by','List of users who were invited by the same user','List of users who were invited by the same user'),
		(32,'2017-10-31 07:32:27',430,0,'See all invited by','User Visibility group - for users who need to see all the users invited by a certain user','User Visibility group - for users who need to see all the users invited by a certain user');

/*Table structure for table `ut_product_group` */

	DROP TABLE IF EXISTS `ut_product_group`;

	CREATE TABLE `ut_product_group` (
	  `product_id` SMALLINT(6) NOT NULL COMMENT 'id in the table products - to identify all the groups for a product/unit',
	  `component_id` MEDIUMINT(9) DEFAULT NULL COMMENT 'id in the table components - to identify all the groups for a given component/role',
	  `group_id` MEDIUMINT(9) NOT NULL COMMENT 'id in the table groups - to map the group to the list in the table `groups`',
	  `group_type_id` SMALLINT(6) NOT NULL COMMENT 'id in the table ut_group_types - to avoid re-creating the same group for the same product again',
	  `role_type_id` SMALLINT(6) DEFAULT NULL COMMENT 'id in the table ut_role_types - to make sure all similar stakeholder in a unit are made a member of the same group',
	  `created_by_id` MEDIUMINT(9) DEFAULT NULL COMMENT 'id in the table ut_profiles',
	  `created` DATETIME DEFAULT NULL COMMENT 'creation ts'
	) ENGINE=INNODB DEFAULT CHARSET=utf8;
	
	
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


