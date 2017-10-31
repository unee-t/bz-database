# This script makes all the necessary changes from unee-t DB v2.7 to unee-t db v2.8
#
#
# Changelog v2.8 vs v2.7:
# 	- We add the conditional drop down in the table `cf_ipi_clust_6_claim_type`
#	- Add more records in the table `ut_group_types` (needed for visibility).
#


/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


/*Data for the table `cf_ipi_clust_6_claim_type` */

	# First we remove the existing records
		TRUNCATE `cf_ipi_clust_6_claim_type`;
		
	# We can now include the new records
		INSERT  INTO `cf_ipi_clust_6_claim_type`(`id`,`value`,`sortkey`,`isactive`,`visibility_value_id`) VALUES 
		(1,'---',500,1,NULL),
		(2,'Electrical',1005,1,2),
		(3,'Plumbing Rep',1010,1,2),
		(4,'Aircon Rep',1015,1,2),
		(5,'Furniture Rep',1020,1,2),
		(6,'Carpentry Rep',1025,1,2),
		(7,'Internet Rep',1030,1,2),
		(8,'Cable TV Rep',1035,1,2),
		(9,'Other Rep',1090,1,2),
		(10,'Aircon M',1505,1,3),
		(11,'Equipment M',1510,1,3),
		(12,'Plumbing M',1515,1,3),
		(13,'Battery repl.',1520,1,3),
		(14,'Other M',1525,1,3),
		(15,'Linens',2005,1,4),
		(16,'Textile',2010,1,4),
		(17,'Curtains',2015,1,4),
		(18,'Cleaning',2020,1,4),
		(19,'Other H',2025,1,4),
		(20,'Key',2505,1,5),
		(21,'Resident Card',2510,1,5),
		(22,'Car Transponder',2515,1,5),
		(23,'Kitchen Utensils',2520,1,5),
		(24,'Furniture D',2525,1,5),
		(25,'Safe box',2530,1,5),
		(26,'Equipment D',2535,1,5),
		(27,'Other D',2540,1,5),
		(28,'Structural Defect',3005,1,6),
		(29,'Carpentry Ren',3010,1,6),
		(30,'Parquet Polishing',3015,1,6),
		(31,'Painting',3020,1,6),
		(32,'Other Ren',3025,1,6),
		(33,'Flat Set Up',3505,1,7),
		(34,'Light Renovation',3510,1,7),
		(35,'Flat Refurbishing',3515,1,7),
		(36,'Hand Over',3520,1,7),
		(37,'Basic Check',3525,1,7),
		(38,'Store room Clearance',3530,1,7),
		(39,'Other CP',3535,1,7),
		(40,'Laundry',4005,1,8),
		(41,'Ironing',4010,1,8),
		(42,'Housekeeping',4015,1,8),
		(43,'Cable Channel',4020,1,8),
		(44,'Internet Upgrade',4025,1,8),
		(45,'Beds',4030,1,8),
		(46,'Baby Cot',4035,1,8),
		(47,'Airport Transportation',4040,1,8),
		(48,'Welcome Basket',4045,1,8),
		(49,'Dish Washing',4050,1,8),
		(50,'Other ES',4090,1,8),
		(51,'NOT SPECIFIED',4095,1,8),
		(52,'SP Services',4505,1,9),
		(53,'Gas',4510,1,9),
		(54,'Meter Reading',4515,1,9),
		(55,'Other U',4520,1,9),
		(56,'Internet O',5005,1,10),
		(57,'Cable TV O',5010,1,10),
		(58,'Viewing',5015,1,10),
		(59,'Other',5020,1,10),
		(60,'Late Check IN/OUT',4055,1,8),
		(61,'Early Check IN/OUT',4060,1,8),
		(62,'High Chair',4065,1,8),
		(63,'Equipment',1040,1,2);

/*Data for the table `ut_group_types` */

	# First we remove the existing records
		TRUNCATE `ut_group_types`;
		
	# We can now include the new records
		INSERT  INTO `ut_group_types`(`id_group_type`,`created`,`order`,`is_obsolete`,`groupe_type`,`bz_description`,`description`) VALUES 
		(1,NOW(),10,0,'creator','User has created the unit or has full delegation','The group for the user who has created the unit first and/or his representatives (agent or employee).')
		,(2,NOW(),210,0,'hide/show_case_from_role','Visible only to','These are product/unit and bug/case visibility groups. \r\nThese groups are in the table bug_group_map.')
		,(3,NOW(),310,0,'list_occupants','User is an occupant of the unit','These are also bug visibility groups but based on a different information: is the user an occupant of the unit or not?\r\nA Tenant can also be an occupant (or not)\r\nAn Owner/Landlord can also be an occupant (or not).')
		,(4,NOW(),400,0,'list_visible_stakeholder','List all the users who have a role in this unit','This is a user visibility group (step 1).\r\nAll the users in this group have a role in this unit.')
		,(5,NOW(),410,0,'see_visible_stakeholder','See all the stakeholders','This is a user visibility group (step 2).\r\nIf you are member of this group, you can see all the user in the list_stakeholder group for this unit.')
		,(6,NOW(),500,0,'r_a_case_next_step','Requestee to approve the Next Step of a case','This is a group for the list of Requestee. It is specific to each unit so we do not ask user to grant approval on a case they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to request approval for the Next Step for a case in this unit.')
		,(7,NOW(),600,0,'g_a_case_next_step','Grant approval for the Next Step of a case','This is a group for the list of Grantor. It is specific to each unit so we do not ask user to grant approval on a case they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to grant approval for the Next Step for a case in this unit.')
		,(8,NOW(),510,0,'r_a_case_solution','Requestee to approve the Solution of a case','This is a group for the list of Requestee. It is specific to each unit so we do not ask user to grant approval on a case they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to request approval for the Solution for a case in this unit.')
		,(9,NOW(),610,0,'g_a_case_solution','Grant approval for the Solution of a case','This is a group for the list of Grantor. It is specific to each unit so we do not ask user to grant approval on a case they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to grant approval for the Solution for a case in this unit.')
		,(10,NOW(),520,0,'r_a_case_budget','Requestee to approve the Budget for a case','This is a group for the list of Requestee. It is specific to each unit so we do not ask user to grant approval on a case they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to request approval for the Budget for a case in this unit.')
		,(11,NOW(),620,0,'g_a_case_budget','Grant approval for the Budget for a case','This is a group for the list of Grantor. It is specific to each unit so we do not ask user to grant approval on a case they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to grant approval for the Budget for a case in this unit.')
		,(12,NOW(),700,0,'r_a_attachment_approve','Requestee to approve the Attachment','This is a group for the list of Requestee. It is specific to each unit so we do not ask user to grant approval on an Attachment they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to request approval for an Attachment in this unit.')
		,(13,NOW(),800,0,'g_a_attachment_approve','Grant approval for the Attachment','This is a group for the list of Grantor. It is specific to each unit so we do not ask user to grant approval on an Attachment they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to grant approval for an Attachment in this unit.')
		,(14,NOW(),710,0,'r_a_attachment_ok_to_pay','Requestee to approve pay a bill','This is a group for the list of Requestee. It is specific to each unit so we do not ask user to grant approval on an Attachment they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to request approval to pay a specific bill in this unit.')
		,(15,NOW(),810,0,'g_a_attachment_ok_to_pay','Grant approval to pay a bill','This is a group for the list of Grantor. It is specific to each unit so we do not ask user to grant approval on an Attachment they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to grant approval to pay a specific bill in this unit.')
		,(16,NOW(),720,0,'r_a_attachment_is_paid','Requestee to confirm if a bill has been paid','This is a group for the list of Requestee. It is specific to each unit so we do not ask user to grant approval on an Attachment they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit to confirm if a specific bill has been paid in this unit.')
		,(17,NOW(),820,0,'g_a_attachment_is_paid','Confirms if a bill has been paid','This is a group for the list of Grantor. It is specific to each unit so we do not ask user to grant approval on an Attachment they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit confirm if a specific bill has been paid in this unit.')
		,(18,NOW(),999,0,'all_r_flags','Grant approval for all flags','This is a group for the list of Requestee. It is specific to each unit so we do not ask user to grant approval on an Attachment they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit confirm if a specific bill has been paid in this unit.')
		,(19,NOW(),999,0,'all_g_all_flags','Confirms if a bill has been paid','This is a group for the list of Grantor. It is specific to each unit so we do not ask user to grant approval on an Attachment they can\'t access.\r\nIf you are member of this group, you can Ask any user who has a role in the unit confirm if a specific bill has been paid in this unit.')
		,(20,NOW(),100,0,'Create a case','Group to be able to create cases in a unit','This is a group that helps us grant all shared accessed and permission in bulk to a user.\r\nIf you are member of this group, you can access, grant, request and be requested to approve all the Flags for a specific unit.')
		,(21,NOW(),10000,0,'user_aggregation','Facilitate user management','This is to group user together (users working in the same company for example) so we can give them all the same permissions.')
		,(22,NOW(),300,0,'list_users_in_role','List all user in a role','All the users in the same role/component for a given unit')
		,(24,NOW(),220,0,'hide/show_case_from_occupant','Untick to hide a case from the occupants of the unit',NULL)
		,(25,NOW(),110,0,'Can edit a case','User can edit a case','This is for the group that grant permission to edit a case. \r\nThis is product group. \r\na The attributes for this group in the group_access_control table are N/A, N/A')
		,(26,NOW(),120,0,'Can edit all fields in a case','Untick to hide a case from the occupants of the unit','This is for the group that grant permission to edit a case. \r\nThis is product group. \r\na The attributes for this group in the group_access_control table are N/A, N/A')
		,(27,NOW(),130,0,'Can Edit components - roles','Needed so that a user can create new users','This is for the group that grant permission to create new users. \r\nThis is product group. \r\na The attributes for this group in the group_access_control table are N/A, N/A')
		,(28,NOW(),200,0,'Case is visible to all','Untick to limit this case only to certain roles','This is for the group that limit visibility of a case by default. \r\nThis is product group. \r\na The attributes for this group in the group_access_control table are Default, N/A')
		;
	
	
	
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;