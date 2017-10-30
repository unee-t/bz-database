# Script to update unee-t DB from v2.5 to v2.7

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

/*Table structure for table `ut_group_types` */

DROP TABLE IF EXISTS `ut_group_types`;

CREATE TABLE `ut_group_types` (
  `id_group_type` smallint(6) NOT NULL AUTO_INCREMENT COMMENT 'ID in this table',
  `created` datetime DEFAULT NULL COMMENT 'creation ts',
  `order` smallint(6) DEFAULT NULL COMMENT 'Order in the list',
  `is_obsolete` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'This is an obsolete record',
  `groupe_type` varchar(255) NOT NULL COMMENT 'A name for this group type',
  `bz_description` varchar(255) DEFAULT NULL COMMENT 'A short description for BZ which we use when we create the group',
  `description` text DEFAULT NULL COMMENT 'Detailed description of this group type',
  PRIMARY KEY (`id_group_type`,`groupe_type`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;

/*Data for the table `ut_group_types` */

insert  into `ut_group_types`(`id_group_type`,`created`,`order`,`is_obsolete`,`groupe_type`,`bz_description`,`description`) values 
(1,'2017-10-26 22:35:58',10,0,'creator','User has created the unit or has full delegation','The group for the user who has created the unit first and/or his representatives (agent or employee).'),
(2,'2017-10-26 22:35:58',40,0,'hide_case_from_role','Untick to hide this case from these users','These are product/unit and bug/case visibility groups. \r\nThese groups are in the table bug_group_map.'),
(3,'2017-10-26 22:35:58',50,0,'list_occupants','User is an occupant of the unit','These are also bug visibility groups but based on a different information: is the user an occupant of the unit or not?\r\nA Tenant can also be an occupant (or not)\r\nAn Owner/Landlord can also be an occupant (or not).'),
(4,'2017-10-26 22:35:58',70,0,'list_visible_stakeholder','List all the users who have a role in this unit','This is a user visibility group (step 1).\r\nAll the users in this group have a role in this unit.'),
(5,'2017-10-26 22:35:58',80,0,'see_visible_stakeholder','See all the stakeholders','This is a user visibility group (step 2).\r\nIf you are member of this group, you can see all the user in the list_stakeholder group for this unit.'),
(6,'2017-10-26 22:35:58',500,0,'r_a_case_next_step','Requestee to approve the Next Step of a case','This is a group for the list of Requestee. It is specific to each unit so we do not ask user to grant approval on a case they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to request approval for the Next Step for a case in this unit.'),
(7,'2017-10-26 22:35:58',600,0,'g_a_case_next_step','Grant approval for the Next Step of a case','This is a group for the list of Grantor. It is specific to each unit so we do not ask user to grant approval on a case they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to grant approval for the Next Step for a case in this unit.'),
(8,'2017-10-26 22:35:58',510,0,'r_a_case_solution','Requestee to approve the Solution of a case','This is a group for the list of Requestee. It is specific to each unit so we do not ask user to grant approval on a case they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to request approval for the Solution for a case in this unit.'),
(9,'2017-10-26 22:35:58',610,0,'g_a_case_solution','Grant approval for the Solution of a case','This is a group for the list of Grantor. It is specific to each unit so we do not ask user to grant approval on a case they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to grant approval for the Solution for a case in this unit.'),
(10,'2017-10-26 22:35:58',520,0,'r_a_case_budget','Requestee to approve the Budget for a case','This is a group for the list of Requestee. It is specific to each unit so we do not ask user to grant approval on a case they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to request approval for the Budget for a case in this unit.'),
(11,'2017-10-26 22:35:58',620,0,'g_a_case_budget','Grant approval for the Budget for a case','This is a group for the list of Grantor. It is specific to each unit so we do not ask user to grant approval on a case they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to grant approval for the Budget for a case in this unit.'),
(12,'2017-10-26 22:35:58',700,0,'r_a_attachment_approve','Requestee to approve the Attachment','This is a group for the list of Requestee. It is specific to each unit so we do not ask user to grant approval on an Attachment they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to request approval for an Attachment in this unit.'),
(13,'2017-10-26 22:35:58',800,0,'g_a_attachment_approve','Grant approval for the Attachment','This is a group for the list of Grantor. It is specific to each unit so we do not ask user to grant approval on an Attachment they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to grant approval for an Attachment in this unit.'),
(14,'2017-10-26 22:35:58',710,0,'r_a_attachment_ok_to_pay','Requestee to approve pay a bill','This is a group for the list of Requestee. It is specific to each unit so we do not ask user to grant approval on an Attachment they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to request approval to pay a specific bill in this unit.'),
(15,'2017-10-26 22:35:58',810,0,'g_a_attachment_ok_to_pay','Grant approval to pay a bill','This is a group for the list of Grantor. It is specific to each unit so we do not ask user to grant approval on an Attachment they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to grant approval to pay a specific bill in this unit.'),
(16,'2017-10-26 22:35:58',720,0,'r_a_attachment_is_paid','Requestee to confirm if a bill has been paid','This is a group for the list of Requestee. It is specific to each unit so we do not ask user to grant approval on an Attachment they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to confirm if a specific bill has been paid in this unit.'),
(17,'2017-10-26 22:35:58',820,0,'g_a_attachment_is_paid','Confirms if a bill has been paid','This is a group for the list of Grantor. It is specific to each unit so we do not ask user to grant approval on an Attachment they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit confirm if a specific bill has been paid in this unit.'),
(18,'2017-10-26 22:35:58',999,0,'all_r_flags','Grant approval for all flags','This is a group for the list of Requestee. It is specific to each unit so we do not ask user to grant approval on an Attachment they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit confirm if a specific bill has been paid in this unit.'),
(19,'2017-10-26 22:35:58',999,0,'all_g_all_flags','Confirms if a bill has been paid','This is a group for the list of Grantor. It is specific to each unit so we do not ask user to grant approval on an Attachment they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit confirm if a specific bill has been paid in this unit.'),
(20,'2017-10-26 22:35:58',20,0,'access_a_unit','Group to be able to create cases in a unit','This is a group that helps us grant all shared accessed and permission in bulk to a user.\r\nIf you are member of this group, you can access, grant, request and be requested to approve all the Flags for a specific unit.'),
(21,'2017-10-26 22:35:58',10000,0,'user_aggregation','Facilitate user management','This is to group user together (users working in the same company for example) so we can give them all the same permissions.'),
(22,'2017-10-29 15:53:04',30,0,'list_users_in_role','List all user in a role','All the users in the same role/component for a given unit'),
(24,'2017-10-29 16:23:29',60,0,'hide_case_from_occupant','Untick to hide a case from the occupants of the unit',NULL);

/*Table structure for table `ut_map_user_unit_details` */

DROP TABLE IF EXISTS `ut_map_user_unit_details`;

CREATE TABLE `ut_map_user_unit_details` (
  `id_user_unit` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID in this table',
  `created` datetime DEFAULT NULL COMMENT 'creation ts',
  `record_created_by` smallint(6) DEFAULT NULL COMMENT 'id of the user who created this user in the bz `profiles` table',
  `is_obsolete` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'This is an obsolete record',
  `user_id` int(11) DEFAULT NULL COMMENT 'id of the user in the MEFE',
  `bz_profile_id` mediumint(6) DEFAULT NULL COMMENT 'id of the user in the BZFE',
  `bz_unit_id` smallint(6) DEFAULT NULL COMMENT 'The id of the unit in the BZFE',
  `role_type_id` smallint(6) DEFAULT NULL COMMENT 'An id in the table ut_role_types: the role of the user for this unit',
  `is_occupant` tinyint(1) NOT NULL DEFAULT 0 COMMENT '1 (TRUE) if the user is an occupnt for this unit',
  `is_public_assignee` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 (TRUE) if the user is one of the public assignee for this unit',
  `is_see_visible_assignee` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 (TRUE) if the user can see the public assignee for this unit',
  `is_flag_requestee` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 (TRUE) if the user can be asked to approve all flags',
  `is_flag_approver` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 (TRUE) if the user can approve all flags',
  `can_create_any_sh` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 (TRUE) if the user can create any type of stakeholder',
  `can_create_same_sh` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 (TRUE) if the user can add user as similar stakeholder for that unit',
  `can_approve_user_for_flags` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 (TRUE) if the user can decide if a user can be requested to approve all flags',
  `can_decide_if_user_visible` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 (TRUE) if the user can decide if another user is visible',
  `can_decide_if_user_can_see_visible` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 (TRUE) if the user can decide if another user can see the visible users',
  `public_name` varchar(255) DEFAULT NULL COMMENT 'The user Public name',
  `more_info` text DEFAULT NULL COMMENT 'More information about this user. We display this in the component/stakeholder description for the unit',
  `comment` text DEFAULT NULL COMMENT 'Any comment',
  PRIMARY KEY (`id_user_unit`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
