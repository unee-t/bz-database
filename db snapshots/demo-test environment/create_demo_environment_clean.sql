# For any question about this script, ask Franck

# Info about this script
	SET @script = 'demo_environment_clean.sql';

# pre-requisite: 
# 	- DB v3.6+ clean has been installed (tested up to DB schema v3.17).

# Dependencies:
# This script use codes from the following scripts:
	#- chore_update_fielddefs_v2.x.sql
	#- cleanup_remove_a_unit_bzfe_v2.19.sql
	#- 2_Insert_new_unit_with_dummy_roles_in_unee-t_bzfe_v2.18.sql
	#- 3_replace_dummy_role_with_genuine_user_as_default_in_unee-t_bzfe_v2.18.sql
#
#
# If we alter these scripts, we need to alter this script accordingly too!

# This script will
	#- update the adminstrator account credentials.
	#- create 12 demo users 
	#- Only use 1 classification
	#- Remove the 'test' unit and all objects associated to that from the database
	#- create 3 units
	#- Associate the demo users to these units as such
	#	- Leonel (7)
			#- Unit 1: Agent (role 5)
			#- Unit 2: Agent (role 5)
			#- Unit 3: No Roles
	#	- Marley (8)
			#- Unit 1: Landlord (role 2)
			#- Unit 2: No Role
			#- Unit 3: Landlord (role 2) / Occupant
	#	- Michael (9)
			#- Unit 1: Management Company (role 4)
			#- Unit 2: No Role
			#- Unit 3: Management Company (role 4)
	#	- Sabrina (10)
			#- Unit 1: Management Company (role 4) - Additional user
			#- Unit 2: No Role
			#- Unit 3: Management Company (role 4) - Additional user
	#	- Celeste (11)
			#- Unit 1: No Role
			#- Unit 2: Management Company (role 4)
			#- Unit 3: No Role
	#	- Jocelyn (12)
			#- Unit 1: co Tenant (role 1)
			#- Unit 2: No Role
			#- Unit 3: No Role
	#	- Marina (13)
			#- Unit 1: co Tenant (role 1) - Additional user
			#- Unit 2: No Role
			#- Unit 3: No Role
	#	- Regina (14)
			#- Unit 1: No Role
			#- Unit 2: Landlord (role 2)
			#- Unit 3: No Role
	#	- Marvin (15)
			#- Unit 1: Contractor (role 3)
			#- Unit 2: No Role
			#- Unit 3: Contractor (role 3)
	#	- Lawrence (16)
			#- Unit 1: No Role
			#- Unit 2: Management Company (role 4) - Additional user
			#- Unit 3: No Role
	#	- Anabelle (17)
			#- Unit 1: No Role
			#- Unit 2: Contractor (role 3)
			#- Unit 3: No Role




################
#
#	We have everything we need, we do this!
#
################
	
# Timestamp	
		SET @timestamp = NOW();

# We remove the FK contraints

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

# We truncate all the Audit log and ut table that might have been previously populated:
	
	TRUNCATE `ut_audit_log`;
	TRUNCATE `ut_contractors`;
	TRUNCATE `ut_data_to_add_user_to_a_case`;
	TRUNCATE `ut_data_to_add_user_to_a_role`;
	TRUNCATE `ut_data_to_create_units`;
	TRUNCATE `ut_data_to_replace_dummy_roles`;
	TRUNCATE `ut_map_contractor_to_type`;
	TRUNCATE `ut_map_contractor_to_user`;
	TRUNCATE `ut_map_user_mefe_bzfe`;
	TRUNCATE `ut_map_user_unit_details`;
	TRUNCATE `ut_product_group`;
	TRUNCATE `ut_script_log`;

# We update the Field defs for Unee-T
	/*Table structure for table `fielddefs` */

	DROP TABLE IF EXISTS `fielddefs`;

	CREATE TABLE `fielddefs` (
	  `id` MEDIUMINT(9) NOT NULL AUTO_INCREMENT,
	  `name` VARCHAR(64) NOT NULL,
	  `type` SMALLINT(6) NOT NULL DEFAULT 0,
	  `custom` TINYINT(4) NOT NULL DEFAULT 0,
	  `description` TINYTEXT NOT NULL,
	  `long_desc` VARCHAR(255) NOT NULL DEFAULT '',
	  `mailhead` TINYINT(4) NOT NULL DEFAULT 0,
	  `sortkey` SMALLINT(6) NOT NULL,
	  `obsolete` TINYINT(4) NOT NULL DEFAULT 0,
	  `enter_bug` TINYINT(4) NOT NULL DEFAULT 0,
	  `buglist` TINYINT(4) NOT NULL DEFAULT 0,
	  `visibility_field_id` MEDIUMINT(9) DEFAULT NULL,
	  `value_field_id` MEDIUMINT(9) DEFAULT NULL,
	  `reverse_desc` TINYTEXT DEFAULT NULL,
	  `is_mandatory` TINYINT(4) NOT NULL DEFAULT 0,
	  `is_numeric` TINYINT(4) NOT NULL DEFAULT 0,
	  PRIMARY KEY (`id`),
	  UNIQUE KEY `fielddefs_name_idx` (`name`),
	  KEY `fielddefs_sortkey_idx` (`sortkey`),
	  KEY `fielddefs_value_field_id_idx` (`value_field_id`),
	  KEY `fielddefs_is_mandatory_idx` (`is_mandatory`),
	  KEY `fk_fielddefs_visibility_field_id_fielddefs_id` (`visibility_field_id`),
	  CONSTRAINT `fk_fielddefs_value_field_id_fielddefs_id` FOREIGN KEY (`value_field_id`) REFERENCES `fielddefs` (`id`) ON UPDATE CASCADE,
	  CONSTRAINT `fk_fielddefs_visibility_field_id_fielddefs_id` FOREIGN KEY (`visibility_field_id`) REFERENCES `fielddefs` (`id`) ON UPDATE CASCADE
	) ENGINE=INNODB AUTO_INCREMENT=93 DEFAULT CHARSET=utf8;

	/*Data for the table `fielddefs` */

	INSERT  INTO `fielddefs`(`id`,`name`,`type`,`custom`,`description`,`long_desc`,`mailhead`,`sortkey`,`obsolete`,`enter_bug`,`buglist`,`visibility_field_id`,`value_field_id`,`reverse_desc`,`is_mandatory`,`is_numeric`) VALUES 
	(1,'bug_id',0,0,'Case #','',1,100,0,0,1,NULL,NULL,NULL,0,1),
	(2,'short_desc',0,0,'Summary','',1,200,0,0,1,NULL,NULL,NULL,1,0),
	(3,'classification',2,0,'Unit Group','',1,300,0,0,1,NULL,NULL,NULL,0,0),
	(4,'product',2,0,'Unit','',1,400,0,0,1,NULL,NULL,NULL,1,0),
	(5,'version',0,0,'Version','',1,500,0,0,1,NULL,NULL,NULL,1,0),
	(6,'rep_platform',2,0,'Case Category','',1,600,0,0,1,NULL,NULL,NULL,0,0),
	(7,'bug_file_loc',0,0,'URL','',1,700,0,0,1,NULL,NULL,NULL,0,0),
	(8,'op_sys',2,0,'Source','',1,800,0,0,1,NULL,NULL,NULL,0,0),
	(9,'bug_status',2,0,'Status','',1,900,0,0,1,NULL,NULL,NULL,0,0),
	(10,'status_whiteboard',0,0,'Status Whiteboard','',1,1000,0,0,1,NULL,NULL,NULL,0,0),
	(11,'keywords',8,0,'Keywords','',1,1100,0,0,1,NULL,NULL,NULL,0,0),
	(12,'resolution',2,0,'Resolution','',0,1200,0,0,1,NULL,NULL,NULL,0,0),
	(13,'bug_severity',2,0,'Severity','',1,1300,0,0,1,NULL,NULL,NULL,0,0),
	(14,'priority',2,0,'Priority','',1,1400,0,0,1,NULL,NULL,NULL,0,0),
	(15,'component',2,0,'Role','',1,1500,0,0,1,NULL,NULL,NULL,1,0),
	(16,'assigned_to',0,0,'AssignedTo','',1,1600,0,0,1,NULL,NULL,NULL,0,0),
	(17,'reporter',0,0,'ReportedBy','',1,1700,0,0,1,NULL,NULL,NULL,0,0),
	(18,'qa_contact',0,0,'QAContact','',1,1800,0,0,1,NULL,NULL,NULL,0,0),
	(19,'assigned_to_realname',0,0,'AssignedToName','',0,1900,0,0,1,NULL,NULL,NULL,0,0),
	(20,'reporter_realname',0,0,'ReportedByName','',0,2000,0,0,1,NULL,NULL,NULL,0,0),
	(21,'qa_contact_realname',0,0,'QAContactName','',0,2100,0,0,1,NULL,NULL,NULL,0,0),
	(22,'cc',0,0,'CC','',1,2200,0,0,0,NULL,NULL,NULL,0,0),
	(23,'dependson',0,0,'Depends on','',1,2300,0,0,1,NULL,NULL,NULL,0,1),
	(24,'blocked',0,0,'Blocks','',1,2400,0,0,1,NULL,NULL,NULL,0,1),
	(25,'attachments.description',0,0,'Attachment description','',0,2500,0,0,0,NULL,NULL,NULL,0,0),
	(26,'attachments.filename',0,0,'Attachment filename','',0,2600,0,0,0,NULL,NULL,NULL,0,0),
	(27,'attachments.mimetype',0,0,'Attachment mime type','',0,2700,0,0,0,NULL,NULL,NULL,0,0),
	(28,'attachments.ispatch',0,0,'Attachment is patch','',0,2800,0,0,0,NULL,NULL,NULL,0,1),
	(29,'attachments.isobsolete',0,0,'Attachment is obsolete','',0,2900,0,0,0,NULL,NULL,NULL,0,1),
	(30,'attachments.isprivate',0,0,'Attachment is private','',0,3000,0,0,0,NULL,NULL,NULL,0,1),
	(31,'attachments.submitter',0,0,'Attachment creator','',0,3100,0,0,0,NULL,NULL,NULL,0,0),
	(32,'target_milestone',0,0,'Target Milestone','',1,3200,0,0,1,NULL,NULL,NULL,0,0),
	(33,'creation_ts',0,0,'Creation date','',0,3300,0,0,1,NULL,NULL,NULL,0,0),
	(34,'delta_ts',0,0,'Last changed date','',0,3400,0,0,1,NULL,NULL,NULL,0,0),
	(35,'longdesc',0,0,'Comment','',0,3500,0,0,0,NULL,NULL,NULL,0,0),
	(36,'longdescs.isprivate',0,0,'Comment is private','',0,3600,0,0,0,NULL,NULL,NULL,0,1),
	(37,'longdescs.count',0,0,'Number of Comments','',0,3700,0,0,1,NULL,NULL,NULL,0,1),
	(38,'alias',0,0,'Alias','',0,3800,0,0,1,NULL,NULL,NULL,0,0),
	(39,'everconfirmed',0,0,'Ever Confirmed','',0,3900,0,0,0,NULL,NULL,NULL,0,1),
	(40,'reporter_accessible',0,0,'Reporter Accessible','',0,4000,0,0,0,NULL,NULL,NULL,0,1),
	(41,'cclist_accessible',0,0,'CC Accessible','',0,4100,0,0,0,NULL,NULL,NULL,0,1),
	(42,'bug_group',0,0,'Group','',1,4200,0,0,0,NULL,NULL,NULL,0,0),
	(43,'estimated_time',0,0,'Estimated Hours','',1,4300,0,0,1,NULL,NULL,NULL,0,1),
	(44,'remaining_time',0,0,'Remaining Hours','',0,4400,0,0,1,NULL,NULL,NULL,0,1),
	(45,'deadline',5,0,'Deadline','',1,4500,0,0,1,NULL,NULL,NULL,0,0),
	(46,'commenter',0,0,'Commenter','',0,4600,0,0,0,NULL,NULL,NULL,0,0),
	(47,'flagtypes.name',0,0,'Flags','',0,4700,0,0,1,NULL,NULL,NULL,0,0),
	(48,'requestees.login_name',0,0,'Flag Requestee','',0,4800,0,0,0,NULL,NULL,NULL,0,0),
	(49,'setters.login_name',0,0,'Flag Setter','',0,4900,0,0,0,NULL,NULL,NULL,0,0),
	(50,'work_time',0,0,'Hours Worked','',0,5000,0,0,1,NULL,NULL,NULL,0,1),
	(51,'percentage_complete',0,0,'Percentage Complete','',0,5100,0,0,1,NULL,NULL,NULL,0,1),
	(52,'content',0,0,'Content','',0,5200,0,0,0,NULL,NULL,NULL,0,0),
	(53,'attach_data.thedata',0,0,'Attachment data','',0,5300,0,0,0,NULL,NULL,NULL,0,0),
	(54,'owner_idle_time',0,0,'Time Since Assignee Touched','',0,5400,0,0,0,NULL,NULL,NULL,0,0),
	(55,'see_also',7,0,'See Also','',0,5500,0,0,0,NULL,NULL,NULL,0,0),
	(56,'tag',8,0,'Personal Tags','',0,5600,0,0,1,NULL,NULL,NULL,0,0),
	(57,'last_visit_ts',5,0,'Last Visit','',0,5700,0,0,1,NULL,NULL,NULL,0,0),
	(58,'comment_tag',0,0,'Comment Tag','',0,5800,0,0,0,NULL,NULL,NULL,0,0),
	(59,'days_elapsed',0,0,'Days since bug changed','',0,5900,0,0,0,NULL,NULL,NULL,0,0),
	(60,'cf_ipi_clust_4_status_in_progress',2,1,'Progression','More information about the case when the status is \"IN PROGRESS\".',0,10,0,1,1,9,NULL,NULL,0,0),
	(61,'cf_ipi_clust_4_status_standby',2,1,'Stand By Cause','More information about the case when the status is \"STAND BY\"',0,20,0,0,1,9,NULL,NULL,0,0),
	(62,'cf_ipi_clust_2_room',1,1,'Room(s)','Information about the room(s) where the case is located',0,600,0,1,1,NULL,NULL,NULL,0,0),
	(63,'cf_ipi_clust_6_claim_type',2,1,'Case Type','The Case Type allows us to better organize Cases. It depends on the Case Category.',0,600,0,1,1,NULL,6,NULL,0,0),
	(64,'cf_ipi_clust_1_solution',4,1,'Solution','The CURRENT solution that we have to solve this. This could (and in many occasion WILL) change over time. It can also be empty if we don\'t know what the solution is yet. It is different from the NEXT STEP field.',0,3215,0,1,1,NULL,NULL,NULL,0,0),
	(65,'cf_ipi_clust_1_next_step',4,1,'Next Step','Detailed description of the next step for the Case ASSIGNEE. This is different from the solution and from the field action.',0,3220,0,0,1,NULL,NULL,NULL,0,0),
	(66,'cf_ipi_clust_1_next_step_date',9,1,'Next Step Date','The date when the Next Step needs to happen.',0,3225,0,0,1,NULL,NULL,NULL,0,0),
	(67,'cf_ipi_clust_3_field_action',4,1,'Action Details','Describe in details what needs to be done. This text will appear in the roadbook.',0,3245,0,0,1,NULL,NULL,NULL,0,0),
	(68,'cf_ipi_clust_3_field_action_from',5,1,'Scheduled From','The Start date for the action on the field. It is also possible to add a start time.',0,3250,0,0,1,NULL,NULL,NULL,0,0),
	(69,'cf_ipi_clust_3_field_action_until',5,1,'Scheduled Until','The End date for the action on the field. It is also possible to add an end time.',0,3255,0,0,1,NULL,NULL,NULL,0,0),
	(70,'cf_ipi_clust_3_action_type',2,1,'Action Type','What type of action do we need to do on the field?',0,3260,0,0,1,NULL,NULL,NULL,0,0),
	(71,'cf_ipi_clust_3_nber_field_visits',10,1,'Field Visits','Number of visits or trips done to diagnose and solve this case. DO NOT include the visits by the supervisors/managers for Quality Control purposes. Increases Each time there is a new visit SCHEDULED. Decrease during debrief if cancelled.',0,3205,0,0,1,NULL,NULL,NULL,0,0),
	(72,'cf_ipi_clust_3_roadbook_for',3,1,'Action For','In whose roadbook shall Field Action appear? This can change over time. It is possible to choose more than 1 person if needed.',0,3235,0,0,1,NULL,NULL,NULL,0,0),
	(73,'cf_ipi_clust_5_approved_budget',1,1,'Approved Budget','What is the budget that has been APPROVED to solve this. This can be different from the actual cost of the purchase or total cost for solving the case. This allows us to monitor how good we are when we have to estimate a budget.',0,3275,0,0,1,NULL,NULL,NULL,0,0),
	(74,'cf_ipi_clust_5_budget',1,1,'Estimated Budget','The LATEST estimate for the budget we need to fix the problem. This can change with time and might be different than the approved budget as we gather more information.',0,3265,0,0,1,NULL,NULL,NULL,0,0),
	(75,'cf_ipi_clust_8_contract_id',1,1,'Customer ID','The internal ID for the contract with the customer.',0,3270,0,0,1,NULL,NULL,NULL,0,0),
	(76,'cf_ipi_clust_9_acct_action',3,1,'Accounting Action','Detailed description of the expected action from ACCOUNTING. This is different from the solution, from the field action or the next step.',0,3300,0,0,1,92,NULL,NULL,0,0),
	(77,'cf_ipi_clust_9_inv_ll',1,1,'Invoice Amount (LL)','What is the amount of the invoice that we need to generate to the LANDLORD for this claim?',0,3305,0,0,1,92,NULL,NULL,0,0),
	(78,'cf_ipi_clust_9_inv_det_ll',1,1,'Invoice Details (LL)','Use this if there are has specific requirement on our invoice to the Landlord. Accounting will use this to prepare the invoice and explain to the Lanldord why we have invoiced/paid him that way...',0,3310,0,0,1,92,NULL,NULL,0,0),
	(79,'cf_ipi_clust_9_inv_cust',4,1,'Invoice Amount (Cust)','What is the amount of the invoice that we need to generate to the CUSTOMER for this claim?',0,3315,0,0,1,92,NULL,NULL,0,0),
	(80,'cf_ipi_clust_9_inv_det_cust',4,1,'Invoice Details (Cust)','Details about the invoice: what do we need to know about this invoice? What is the information/message that we need to send to the customer together with this invoice?',0,3320,0,0,1,92,NULL,NULL,0,0),
	(81,'cf_ipi_clust_5_spe_action_purchase_list',1,1,'Purchase List','Enter the list of things that we need to purchase. If the list is too long, attach a file to the claim with the detailed list and only summarize what we need to purchase here. IN Unee-T IT\'S EASIER TO USE APPROVED ATTACHMENTS TO DO THIS',0,9905,0,0,1,92,NULL,NULL,0,0),
	(83,'cf_ipi_clust_5_spe_approval_for',4,1,'Approval For','Explain why you require an approval. The approver will use this information to better understand the whole situtation. IN Unee-T IT\'S BETTER TO DO THIS WHEN YOU APPROVE AN ATTACHMENT',0,9910,0,0,1,92,NULL,NULL,0,0),
	(84,'cf_ipi_clust_5_spe_approval_comment',4,1,'Approval Comment','This is to explain/comment about the approval/rejection of what was requested. IN Unee-T IT\'S BETTER TO DO THIS WHEN WE APPROVE AN ATTACHMENT.',0,9915,0,0,1,92,NULL,NULL,0,0),
	(85,'cf_ipi_clust_5_spe_contractor',4,1,'Contractor ID','The name of the contractor that has been assigned to work on this case. IN Unee-T THIS HAS BEEN MOVED. THE CONTRACTOR IS A STAKEHOLDER.',0,9920,0,0,1,92,NULL,NULL,0,0),
	(87,'cf_ipi_clust_5_spe_purchase_cost',1,1,'Purchase Cost','What was the ACTUAL purchase cost for the purchase we did. This can be (and usually is) slightly different from the approved budget (but NOT higher than the approved budget).',0,9925,0,0,1,92,NULL,NULL,0,0),
	(88,'cf_ipi_clust_7_spe_bill_number',1,1,'Bill Nber','The Supplier\'s invoice number. This is so that accounting can easily find explanations about a supplier invoice if this is needed. IN Unee-T THIS HAS BEEN MOVED TO ATTACHMENTS',0,9930,0,0,1,92,NULL,NULL,0,0),
	(89,'cf_ipi_clust_7_spe_payment_type',2,1,'Payment Type','How will we pay the contractor? This is important information so that accounting can prepare the payment accordingly. This will ensure we pay our supplier as fast as possible and minimize the risk of misunderstandings.',0,9935,0,0,1,92,NULL,NULL,0,0),
	(90,'cf_ipi_clust_7_spe_contractor_payment',4,1,'Contractor Payment','Use this if the supplier has specific requirement about the payment. Accounting will use this to explain to the supplier why we have invoiced/paid him that way...',0,9940,0,0,1,92,NULL,NULL,0,0),
	(91,'cf_ipi_clust_8_spe_customer',1,1,'Customer','The name of the customer. IN Unee-T WE USE THE CUSTOMER ID INSTEAD',0,9945,0,0,1,92,NULL,NULL,0,0),
	(92,'cf_specific_for',2,1,'Field For','The name and id of the Unee-T customer that can see these fields',0,9900,0,0,1,NULL,NULL,NULL,0,0);
	
# Insert the initial demo users
	
	/*We Remove all the existing users in the installation */
		TRUNCATE `profiles`;
		
	/*Initial Data for the table `profiles` */
		INSERT  INTO `profiles`
			(`userid`
			,`login_name`
			,`cryptpassword`
			,`realname`
			,`disabledtext`
			,`disable_mail`
			,`mybugslink`
			,`extern_id`
			,`is_enabled`
			,`last_seen_date`
			) 
			VALUES 
			#(1,'administrator.demo@unee-t.com','2O1sq9Ch,nZhoZFTRzZZqXcpkp8bs1OvRiVnPIuHhaKLExSUgG/M{SHA-256}','Administrator Demo','',0,1,NULL,1,NULL),
			(1,'administrator@example.com','B8AgzURt,NDrX2Bt8stpgXPKsNRYaHmm0V2K1+qhfnt76oLAvN+Q{SHA-256}','Administrator','',0,1,NULL,1,NULL),
			(2,'temporary.agent@example.com','8IF0bErt,DWxzG95hJ7+7YGjCvCdMO+8IcCWdAW2+ojoSKnYxQYg{SHA-256}','Generic Agent','',0,1,NULL,1,NULL),
			(3,'temporary.landlord@example.com','YxnRDOJe,h1YQJqMCsMi4JItnllV5tMNJSKNXpARxD/wkyyIuhQM{SHA-256}','Generic Landlord','',0,1,NULL,1,NULL),
			(4,'temporary.tenant@example.com','lm6aQER6,H2pgJVfTP38j+7RE2rlPcekO5k1MYzMtvYRgOTQQw/M{SHA-256}','Generic Tenant','',0,1,NULL,1,NULL),
			(5,'temporary.contractor@example.com','4ri3AF6X,Hlu9YmDzumnQdn5fr4J6kKbjDe/3KxJPPhCcwkYBqe4{SHA-256}','Generic Contractor','',0,1,NULL,1,NULL),
			(6,'temporary.mgt.cny@example.com','dHGU8lRe,odrIC0TGEuEsYBAxm918zU2HWjsDHeEmMaT7mIQ5C/s{SHA-256}','Generic Management Company','',0,1,NULL,1,NULL),
			(7,'leonel@example.com','uVkp9Jte,ts7kZpZuOcTkMAh1c4iX4IcEZTxpq0Sfr7XraiZoL+g{SHA-256}','Leonel','',0,1,NULL,1,NULL),
			(8,'marley@example.com','AMOb0L00,NlJF4wyZVyT+xWuUr3RYgDIYxMhfBJCZxvkSh5cRSVs{SHA-256}','Marley','',0,1,NULL,1,NULL),
			(9,'michael@example.com','Tp0jDQnd,kD+mf67/v/ck68nOyRTR4j7JNVpo1XzzDFSIR6U7Lps{SHA-256}','Michael','',0,1,NULL,1,NULL),
			(10,'sabrina@example.com','fjeiOOVC,vUkDbdxcfk9snn9J5Vh4r/cujX2FfOKEcBZBAOcMw3k{SHA-256}','Sabrina','',0,1,NULL,1,NULL),
			(11,'celeste@example.com','ZAU7m97y,kw6J1Bf2Hw21qELelxM3BbK+4avsmJytG/WzssHMbXE{SHA-256}','Celeste','',0,1,NULL,1,NULL),
			(12,'jocelyn@example.com','0ZprH6RJ,zXa/xkkETvkPZ988xpyQQocYYfLAIWdCLCk1wE4QXNA{SHA-256}','Jocelyn','',0,1,NULL,1,NULL),
			(13,'marina@example.com','8c2ofNwd,VpZbBAByL89ZKCI3xT7zFjZBb/X7JHW6KjtA9yY8KYo{SHA-256}','Marina','',0,1,NULL,1,NULL),
			(14,'regina@example.com','HuM6hVYF,Ev6TBPrrOm4pSu5chsr1Q6Hi6q2Tmm98IbLh7ONqtYs{SHA-256}','Regina','',0,1,NULL,1,NULL),
			(15,'marvin@example.com','6kTmgSt9,FI+tK4vrJQa8lInrRGKxmQ0JW2WpVImRk+ylhcMYGKM{SHA-256}','Marvin','',0,1,NULL,1,NULL),
			(16,'lawrence@example.com','JqPmW7RA,tJopvIAj1kbeRJ61pZUqjce1dZrGoBpnHMzycgTuTqE{SHA-256}','Lawrence','',0,1,NULL,1,NULL),
			(17,'anabelle@example.com','9bgiCNi8,32d10yq/btaTsj/awDksNPjdUDLIrGfkK+vRKWfYbQo{SHA-256}','Anabelle','',0,1,NULL,1,NULL),
			(18,'management.co@example.com','C162r0Mo,/V0m+v2cmZqU0JOjQBR8X5Q26xSgKTBs/f/Wke51oSI{SHA-256}','Management Co','',0,1,NULL,1,NULL);

		#Log the actions of the script.

			SET @script_log_message = CONCAT('A new batch of #'
									, '18'
									, ' users have been created.'
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(NOW(), @script, @script_log_message)
				;
			
			SET @script_log_message = NULL;

		#We record the information about the users that we have just created
		
			INSERT INTO `ut_map_user_unit_details`
			(`created`
			,`record_created_by`
			,`user_id`
			,`bz_profile_id`
			,`public_name`
			,`comment`
			)
			VALUES
			(@timestamp, 1, 1, 1, 'Administrator', 'Created as a demo user with demo user creation script')
			,(@timestamp, 1, 2, 2, 'Generic Agent', 'Created as a demo user with demo user creation script')
			,(@timestamp, 1, 3, 3, 'Generic Landlord', 'Created as a demo user with demo user creation script')
			,(@timestamp, 1, 4, 4, 'Generic Tenant', 'Created as a demo user with demo user creation script')
			,(@timestamp, 1, 5, 5, 'Generic Contractor', 'Created as a demo user with demo user creation script')
			,(@timestamp, 1, 6, 6, 'Generic Management Company', 'Created as a demo user with demo user creation script')
			,(@timestamp, 1, 7, 7, 'Leonel', 'Created as a demo user with demo user creation script')
			,(@timestamp, 1, 8, 8, 'Marley', 'Created as a demo user with demo user creation script')
			,(@timestamp, 1, 9, 9, 'Michael', 'Created as a demo user with demo user creation script')
			,(@timestamp, 1, 10, 10, 'Sabrina', 'Created as a demo user with demo user creation script')
			,(@timestamp, 1, 11, 11, 'Celeste', 'Created as a demo user with demo user creation script')
			,(@timestamp, 1, 12, 12, 'Jocelyn', 'Created as a demo user with demo user creation script')
			,(@timestamp, 1, 13, 13, 'Marina', 'Created as a demo user with demo user creation script')
			,(@timestamp, 1, 14, 14, 'Regina', 'Created as a demo user with demo user creation script')
			,(@timestamp, 1, 15, 15, 'Marvin', 'Created as a demo user with demo user creation script')
			,(@timestamp, 1, 16, 16, 'Lawrence', 'Created as a demo user with demo user creation script')
			,(@timestamp, 1, 17, 17, 'Anabelle', 'Created as a demo user with demo user creation script')
			,(@timestamp, 1, 18, 18, 'Management Co', 'Created as a demo user with demo user creation script')
			;
		
# Remove the Test Unit from the database

	#The unit: What is the id of the unit in the table 'ut_data_to_create_units'
		SET @product_id = 1;

	# 
	# This script will alter the following tables (but NOT in that order):
	#
	#OK	- `attach_data` (bug/case related)
	#OK	- `attachments` (bug/case related)
	#OK	- `bug_cf_ipi_clust_3_roadbook_for` (bug/case related)
	#OK	- `bug_cf_ipi_clust_9_acct_action` (bug/case related)
	#OK	- `bug_group_map` (bug/case related)
	#OK	- `bug_see_also` (bug/case related)
	#OK	- `bug_tag` (bug/case AND tags related)
	#OK	- `bug_user_last_visit` (bug/case related)
	#OK	- `bugs` (bug/case related)
	#OK	- `bugs_activity` (bug/case related)
	#OK	- `bugs_aliases` (bug/case related)
	#OK	- `bugs_fulltext` (bug/case related)
	#OK	- `cc` (bug/case related)
	#OK	- `component_cc` (component/roles related)
	#OK	- `components` (component/roles related)
	#OK	- `dependencies` (bug/case related)
	#OK	- `duplicates` (bug/case related)
	#OK	- `email_bug_ignore` (bug/case related)
	#OK	- `flagexclusions` (flages related)
	#OK	- `flaginclusions` (flages related)
	#OK	- `flags` (flages related)
	#OK	- `flagtypes` (flages related)
	#OK	- `group_control_map` (Group related)
	#OK	- `group_group_map` (Group related)
	#OK	- `groups` (Group related)
	#OK	- `keywords` (bug/case related)
	#OK	- `longdescs` (bug/case related)
	#OK	- `longdescs_tags` (tags related)
	#OK	- `longdescs_tags_activity` (tags related)
	#IGNORED	- `longdescs_tags_weights` (tags related)
	#OK	- `milestones` (product/unit related)
	#OK	- `products` (product/unit related)
	#IGNORED (tricky as a tag can be associated to several product !!!)	- `tag`
	#OK	- `user_group_map`
	#OK	- `ut_data_to_add_user_to_a_case`
	#OK	- `ut_data_to_add_user_to_a_role`
	#OK	- `ut_data_to_replace_dummy_roles`
	#OK	- `ut_product_group`
	#OK	- `versions` (product/unit related)
	#WIP	- Log what has been done
	#
	# Limits of this script:
	#	- n/a


	# Flags
	# Needs bugs information
		#Delete the flags associated to the bugs associated to that product in the 'flags' table
			DELETE `flags` 
			FROM `flags`
				INNER JOIN `bugs` 
					ON (`flags`.`bug_id` = `bugs`.`bug_id`)
			WHERE (`bugs`.`product_id` = @product_id);
			
		#We need to create a temp table until we cleanup the flag inclusion, exclusions and flagtypes
		#This is needed as this is where the link flagtyp/product_id are kept...
			CREATE TEMPORARY TABLE IF NOT EXISTS `flaginclusions_temp` AS (SELECT * FROM `flaginclusions`);
			CREATE TEMPORARY TABLE IF NOT EXISTS `flagexclusions_temp` AS (SELECT * FROM `flagexclusions`);

		#Delete the flag exclusion for flags related to this product in the 'flagexclusions' table
			DELETE  
			FROM `flagexclusions`
			WHERE (`flagexclusions`.`product_id` = @product_id);

		#Delete the flag inclusion for flags related to this product in the 'flaginclusions' table
			DELETE  
			FROM `flaginclusions`
			WHERE (`flaginclusions`.`product_id` = @product_id);
		
		#Delete the falgtypes associated to this product in the table 'flagtypes'
		#Step 1
		#We use the temp table for that
			DELETE `flagtypes`
			FROM
			`flagtypes`
			INNER JOIN `flaginclusions_temp` 
			ON (`flagtypes`.`id` = `flaginclusions_temp`.`type_id`)
			WHERE (`flaginclusions_temp`.`product_id` = @product_id);
		
		#Delete the falgtypes associated to this product in the table 'flagtypes'
		#Step 2 (to be thourough...)
		#We use the temp table for that
			DELETE `flagtypes`
			FROM
			`flagtypes`
			INNER JOIN `flagexclusions_temp` 
			ON (`flagtypes`.`id` = `flagexclusions_temp`.`type_id`)
			WHERE (`flagexclusions_temp`.`product_id` = @product_id);
			
		#Cleanup: we do not need the temp tables anymore:
			DROP TABLE IF EXISTS `flaginclusions_temp`;
			DROP TABLE IF EXISTS `flagexclusions_temp`;

	# Tags
	# Needs bugs and longdescs information
			
		#The tags for longdesc
			DELETE `longdescs_tags`
			FROM
			`longdescs_tags`
				INNER JOIN `longdescs` 
					ON (`longdescs_tags`.`comment_id` = `longdescs`.`comment_id`)
				INNER JOIN `bugs` 
					ON (`longdescs`.`bug_id` = `bugs`.`bug_id`)
			WHERE (`bugs`.`product_id` = @product_id);
			
		#The activity for the tags for longdesc
			DELETE `longdescs_tags_activity`
			FROM
			`longdescs_tags_activity`
				INNER JOIN `longdescs` 
					ON (`longdescs_tags_activity`.`comment_id` = `longdescs`.`comment_id`)
				INNER JOIN `bugs` 
					ON (`longdescs`.`bug_id` = `bugs`.`bug_id`)
			WHERE (`bugs`.`product_id` = @product_id);
			
		#Delete all the records for the tags associated to the bugs associated to this unit in the 'bug_tag' table
			DELETE `bug_tag` 
			FROM `bug_tag`
				INNER JOIN `bugs` 
					ON (`bug_tag`.`bug_id` = `bugs`.`bug_id`)
			WHERE (`bugs`.`product_id` = @product_id);

	# Keywords
	# Needs bug info
		#The link between keyworddefs and bugs for bugs associated to this product
			DELETE `keywords`
			FROM
			`keywords`
				INNER JOIN `bugs` 
					ON (`keywords`.`bug_id` = `bugs`.`bug_id`)
			WHERE (`bugs`.`product_id` = @product_id);

	# The tables we use to process invitations and stuff
	# Needs bug info
		
		#Add a user to a case 'ut_data_to_add_user_to_a_case'
			DELETE `ut_data_to_add_user_to_a_case`
			FROM
				`ut_data_to_add_user_to_a_case`
				INNER JOIN `bugs` 
					ON (`ut_data_to_add_user_to_a_case`.`bz_case_id` = `bugs`.`bug_id`)
			WHERE (`bugs`.`product_id` = @product_id);
			
		#Add a user to a role in the unit 'ut_data_to_add_user_to_a_role'
			DELETE FROM `ut_data_to_add_user_to_a_role`
			WHERE `bz_unit_id` = @product_id;
		
		#Replace a dummy user with a 'real' user in a role in the unit 'ut_data_to_replace_dummy_roles'
			DELETE FROM `ut_data_to_replace_dummy_roles`
			WHERE `bz_unit_id` = @product_id;
			
	# Bug/case related info 

		#Delete the Attach data if they exist:
			DELETE `attach_data` 
			FROM `attach_data`
				INNER JOIN `attachments` 
					ON (`attach_data`.`id` = `attachments`.`attach_id`)
				INNER JOIN `bugs` 
					ON (`attachments`.`bug_id` = `bugs`.`bug_id`)
			WHERE (`bugs`.`product_id` = @product_id);

		#Delete the Attachments if they exist:
			DELETE `attachments` 
			FROM `attachments`
				INNER JOIN `bugs` 
					ON (`attachments`.`bug_id` = `bugs`.`bug_id`)
			WHERE (`bugs`.`product_id` = @product_id);

		#Delete the roadbook for info if they exist:
			DELETE `bug_cf_ipi_clust_3_roadbook_for` 
			FROM `bug_cf_ipi_clust_3_roadbook_for`
				INNER JOIN `bugs` 
					ON (`bug_cf_ipi_clust_3_roadbook_for`.`bug_id` = `bugs`.`bug_id`)
			WHERE (`bugs`.`product_id` = @product_id);
			
		#Delete the accounting action if they exist:
			DELETE `bug_cf_ipi_clust_9_acct_action` 
			FROM `bug_cf_ipi_clust_9_acct_action`
				INNER JOIN `bugs` 
					ON (`bug_cf_ipi_clust_9_acct_action`.`bug_id` = `bugs`.`bug_id`)
			WHERE (`bugs`.`product_id` = @product_id);
		
		#Delete all the records for the bugs associated to this unit in the 'bug_group_map' table
			DELETE `bug_group_map` 
			FROM `bug_group_map`
				INNER JOIN `bugs` 
					ON (`bug_group_map`.`bug_id` = `bugs`.`bug_id`)
			WHERE (`bugs`.`product_id` = @product_id);

		#Delete all the records for the bugs associated to this unit in the 'bug_group_see_also' table
		#########
		#
		#WIP - WARNING - The below query only does 1/2 the work, we also need to remove the records where a 
			#bug for this product/unit is referenced in the `value` field for this table
		#
		#########
			DELETE `bug_see_also` 
			FROM `bug_see_also`
				INNER JOIN `bugs` 
					ON (`bug_see_also`.`bug_id` = `bugs`.`bug_id`)
			WHERE (`bugs`.`product_id` = @product_id);

		#Delete all the records for the last visit of a user to the bugs associated to this unit in the 'bug_user_last_visit' table
			DELETE `bug_user_last_visit` 
			FROM `bug_user_last_visit`
				INNER JOIN `bugs` 
					ON (`bug_user_last_visit`.`bug_id` = `bugs`.`bug_id`)
			WHERE (`bugs`.`product_id` = @product_id);

		#Delete all the records for the bug activity for the bugs associated to this unit in the 'bugs_activity' table
			DELETE `bugs_activity` 
			FROM `bugs_activity`
				INNER JOIN `bugs` 
					ON (`bugs_activity`.`bug_id` = `bugs`.`bug_id`)
			WHERE (`bugs`.`product_id` = @product_id);

		#Delete all the records for the bug aliases for the bugs associated to this unit in the 'bugs_aliases' table
			DELETE `bugs_aliases` 
			FROM `bugs_aliases`
				INNER JOIN `bugs` 
					ON (`bugs_aliases`.`bug_id` = `bugs`.`bug_id`)
			WHERE (`bugs`.`product_id` = @product_id);

		#Delete all the records for the fulltext of the bugs associated to this unit in the 'bugs_fulltext' table
			DELETE `bugs_fulltext` 
			FROM `bugs_fulltext`
				INNER JOIN `bugs` 
					ON (`bugs_fulltext`.`bug_id` = `bugs`.`bug_id`)
			WHERE (`bugs`.`product_id` = @product_id);
		
		#Delete all the records of the users in CC for the bugs associated to this unit in the 'cc' table
			DELETE `cc` 
			FROM `cc`
				INNER JOIN `bugs` 
					ON (`cc`.`bug_id` = `bugs`.`bug_id`)
			WHERE (`bugs`.`product_id` = @product_id);
			
		#Delete all the dependendies for bugs associated to this unit in the 'dependencies' table
			#Step 1: blocks
			DELETE `dependencies` 
			FROM `dependencies`
				INNER JOIN `bugs` 
					ON (`dependencies`.`blocked` = `bugs`.`bug_id`)
			WHERE (`bugs`.`product_id` = @product_id);
			
		#Delete all the dependendies for bugs associated to this unit in the 'dependencies' table
			#Step 2: Depends On
			DELETE `dependencies` 
			FROM `dependencies`
				INNER JOIN `bugs` 
					ON (`dependencies`.`dependson` = `bugs`.`bug_id`)
			WHERE (`bugs`.`product_id` = @product_id);
			
		#Delete all the duplicates for bugs associated to this unit in the 'duplicates' table
			#Step 1: Dupe Of
			DELETE `duplicates` 
			FROM `duplicates`
				INNER JOIN `bugs` 
					ON (`duplicates`.`dupe_of` = `bugs`.`bug_id`)
			WHERE (`bugs`.`product_id` = @product_id);
			
		#Delete all the duplicates for bugs associated to this unit in the 'duplicates' table
			#Step 2: Dupe
			DELETE `duplicates` 
			FROM `duplicates`
				INNER JOIN `bugs` 
					ON (`duplicates`.`dupe` = `bugs`.`bug_id`)
			WHERE (`bugs`.`product_id` = @product_id);

		#Delete all the email bug ignore data for bugs associated to this unit in the 'email_bug_ignore' table
			DELETE `email_bug_ignore` 
			FROM `email_bug_ignore`
				INNER JOIN `bugs` 
					ON (`email_bug_ignore`.`bug_id` = `bugs`.`bug_id`)
			WHERE (`bugs`.`product_id` = @product_id);	

		#Delete all the longdescs for bugs associated to this unit in the 'longdescs' table
			DELETE `longdescs` 
			FROM `longdescs`
				INNER JOIN `bugs` 
					ON (`longdescs`.`bug_id` = `bugs`.`bug_id`)
			WHERE (`bugs`.`product_id` = @product_id);	
		
		#Delete all the bugs/cases associated to that product/unit
		#We need to do this LAST when we have no need for a link bug/product
			DELETE FROM `bugs`
			WHERE `product_id` = @product_id;

	# Groups
		#Delete the Group Control Map: table 'group_control_map'
			DELETE FROM `group_control_map`
			WHERE `product_id` = @product_id;
			
		#Delete the permissions for the groups associated to that product: `group_group_map` table
		#Step 1: member_id
			DELETE `group_group_map`
			FROM
			`group_group_map`
				INNER JOIN `ut_product_group` 
					ON (`group_group_map`.`member_id` = `ut_product_group`.`group_id`)
			WHERE (`ut_product_group`.`product_id` = @product_id);
		
		#Delete the permissions for the groups associated to that product: `group_group_map` table
		#Step 2: grantor_id
			DELETE `group_group_map`
			FROM
			`group_group_map`
				INNER JOIN `ut_product_group` 
					ON (`group_group_map`.`grantor_id` = `ut_product_group`.`group_id`)
			WHERE (`ut_product_group`.`product_id` = @product_id);
			
		#Delete the permissions for the users for that product in the table 'user_group_map'
			DELETE `user_group_map` 
			FROM
			`user_group_map`
				INNER JOIN `ut_product_group` 
					ON (`user_group_map`.`group_id` = `ut_product_group`.`group_id`)
			WHERE (`ut_product_group`.`product_id` = @product_id);
		
		#Delete the groups associated to this product in the table 'groups'
			DELETE `groups` 
			FROM
			`groups`
				INNER JOIN `ut_product_group` 
					ON (`groups`.`id` = `ut_product_group`.`group_id`)
			WHERE (`ut_product_group`.`product_id` = @product_id);
		
	# Components

		#Delete all the records of the user in associated to a component for that unit in the 'component_cc' table
			DELETE `component_cc` 
			FROM
			`component_cc`
			INNER JOIN `components` 
				ON (`component_cc`.`component_id` = `components`.`id`)
			WHERE (`components`.`product_id` = @product_id);

		#Delete the components associated to this product
			DELETE FROM `components`
			WHERE `product_id` = @product_id;

	# Products:
		
		#Delete the milestone
			DELETE FROM `milestones`
			WHERE `product_id` = @product_id;
		
		#Delete the version
			DELETE FROM `versions`
			WHERE `product_id` = @product_id;
		
		#Delete the product
			DELETE FROM `products`
			WHERE `id` = @product_id;
		
	# Cleanup 

		#Delete the records in the table `ut_product_group`
			DELETE FROM `ut_product_group`
				WHERE `product_id` = @product_id;

	# Log 

		#Update the table 'ut_data_to_create_units' so that we record that the unit has been deleted
			UPDATE `ut_data_to_create_units`
			SET 
				`deleted_datetime` = @timestamp
				, `deletion_script` = @script
			WHERE `product_id` = @product_id;

# We re-create the groups (and remove the groups associated to the TEST unit...)
	/*Table structure for table `groups` */
		TRUNCATE `groups`;	


	/*Data for the table `groups` */

		INSERT  INTO `groups`(`id`,`name`,`description`,`isbuggroup`,`userregexp`,`isactive`,`icon_url`) VALUES 
		(1,'admin','Administrators',0,'',1,NULL)
		,(2,'tweakparams','Can change Parameters',0,'',1,NULL)
		,(3,'editusers','Can edit or disable users',0,'',1,NULL)
		,(4,'creategroups','Can create and destroy groups',0,'',1,NULL)
		,(5,'editclassifications','Can create, destroy, and edit classifications',0,'',1,NULL)
		,(6,'editcomponents','Can create, destroy, and edit components',0,'',1,NULL)
		,(7,'editkeywords','Can create, destroy, and edit keywords',0,'',1,NULL)
		,(8,'editbugs','Can edit all bug fields',0,'',1,NULL)
		,(9,'canconfirm','Can confirm a bug or mark it a duplicate',0,'',1,NULL)
		,(10,'bz_canusewhineatothers','Can configure whine reports for other users',0,'',1,NULL)
		,(11,'bz_canusewhines','User can configure whine reports for self',0,'',1,NULL)
		,(12,'bz_sudoers','Can perform actions as other users',0,'',1,NULL)
		,(13,'bz_sudo_protect','Can not be impersonated by other users',0,'',1,NULL)
		,(14,'bz_quip_moderators','Can moderate quips',0,'',1,NULL)
		,(15,'syst_private_comment','A group to allow user to see the private comments in ALL the activities they are allowed to see. This is for Employees vs external users.',1,'',0,NULL)
		,(16,'syst_see_timetracking','A group to allow users to see the time tracking information in ALL the activities they are allowed to see.',1,'',0,NULL)
		,(17,'syst_create_shared_queries','A group for users who can create, save and share search queries.',1,'',0,NULL)
		,(18,'syst_tag_comments','A group to allow users to tag comments in ALL the activities they are allowed to see.',1,'',0,NULL)
		,(19,'syst_can_see_all_users','Group to see all the users in the installation - This is needed so that Admin can sudo',1,'',0,NULL)
		;

	# Log the actions of the script.
		SET @script_log_message = CONCAT('The table'
								, ' groups'
								, ' has been reset and initial data entered.'
								);
		
		INSERT INTO `ut_script_log`
			(`datetime`
			, `script`
			, `log`
			)
			VALUES
			(@timestamp, @script, @script_log_message)
			;
		
		SET @script_log_message = NULL;	

	TRUNCATE TABLE `ut_product_group`;
	
	# Log the actions of the script.

		SET @script_log_message = CONCAT('The table'
								, ' ut_product_group'
								, ' has been truncated - no info for product_id #1.'
								);
		
		INSERT INTO `ut_script_log`
			(`datetime`
			, `script`
			, `log`
			)
			VALUES
			(@timestamp, @script, @script_log_message)
			;
		
		SET @script_log_message = NULL;
	
	TRUNCATE TABLE `group_control_map`;

	# Log the actions of the script.

		SET @script_log_message = CONCAT('The table'
								, ' group_control_map'
								, ' has been truncated - no info for product_id #1.'
								);
		
		INSERT INTO `ut_script_log`
			(`datetime`
			, `script`
			, `log`
			)
			VALUES
			(@timestamp, @script, @script_log_message)
			;
		
		SET @script_log_message = NULL;	

	/*Data for the table `group_group_map` */
		TRUNCATE TABLE `group_group_map`;

		INSERT  INTO `group_group_map`(`member_id`,`grantor_id`,`grant_type`) VALUES 
		(1,1,0)
		,(1,1,1)
		,(1,1,2)
		,(1,2,0)
		,(1,2,1)
		,(1,2,2)
		,(1,3,0)
		,(1,3,1)
		,(1,3,2)
		,(1,4,0)
		,(1,4,1)
		,(1,4,2)
		,(1,5,0)
		,(1,5,1)
		,(1,5,2)
		,(1,6,0)
		,(1,6,1)
		,(1,6,2)
		,(1,7,0)
		,(1,7,1)
		,(1,7,2)
		,(1,8,0)
		,(1,8,1)
		,(1,8,2)
		,(1,9,0)
		,(1,9,1)
		,(1,9,2)
		,(1,10,0)
		,(1,10,1)
		,(1,10,2)
		,(1,11,0)
		,(1,11,1)
		,(1,11,2)
		,(1,12,0)
		,(1,12,1)
		,(1,12,2)
		,(1,13,0)
		,(1,13,1)
		,(1,13,2)
		,(1,14,0)
		,(1,14,1)
		,(1,14,2)
		,(1,15,0)
		,(1,15,1)
		,(1,15,2)
		,(1,16,0)
		,(1,16,1)
		,(1,16,2)
		,(1,17,0)
		,(1,17,1)
		,(1,17,2)
		,(1,18,0)
		,(1,18,1)
		,(1,18,2)
		,(1,19,0)
		,(1,19,1)
		,(1,19,2)
		#All users are supposed to be able to tag comments.
		#The users in the group 'can_tag_comments' are visible is you are in the group 'see_all_users'
		#This is needed so that admin can impersonate any user.
		,(19,18,2)
		;

	# Log the actions of the script.
		SET @script_log_message = CONCAT('The table'
								, ' group_group_map'
								, ' has been reset and initial data entered.'
								);
		
		INSERT INTO `ut_script_log`
			(`datetime`
			, `script`
			, `log`
			)
			VALUES
			(@timestamp, @script, @script_log_message)
			;
		
		SET @script_log_message = NULL;
		
# Make sure the demo user are member of the 3 system groups:
	#- 16: 'syst_see_timetracking'
	#- 17: 'syst_create_shared_queries'
	#- 18: 'syst_tag_comments'

	# For the demo we make sure that all the additional users (administrator already exists) can:
	#	- See all the time tracking information (group id 16)
	#	- Create Shared queries (group id 17)
	#	- tag comments (group id 18)
	
	/* We cleanup the user_group_map table */
	TRUNCATE `user_group_map`;

	/*Data for the table `user_group_map` */
	# The admin user is a memebr of the Admin group
	INSERT  INTO `user_group_map`
		(`user_id`
		,`group_id`
		,`isbless`
		,`grant_type`
		) 
		VALUES 
		(1,1,0,0);
	
	# More user group map permission
	INSERT  INTO `user_group_map`
		(`user_id`
		,`group_id`
		,`isbless`
		,`grant_type`
		) 
		VALUES 
		(2,16,0,0),
		(2,17,0,0),
		(2,18,0,0),
		(3,16,0,0),
		(3,17,0,0),
		(3,18,0,0),
		(4,16,0,0),
		(4,17,0,0),
		(4,18,0,0),
		(5,16,0,0),
		(5,17,0,0),
		(5,18,0,0),
		(6,16,0,0),
		(6,17,0,0),
		(6,18,0,0),
		(7,16,0,0),
		(7,17,0,0),
		(7,18,0,0),
		(8,16,0,0),
		(8,17,0,0),
		(8,18,0,0),
		(9,16,0,0),
		(9,17,0,0),
		(9,18,0,0),
		(10,16,0,0),
		(10,17,0,0),
		(10,18,0,0),
		(11,16,0,0),
		(11,17,0,0),
		(11,18,0,0),
		(12,16,0,0),
		(12,17,0,0),
		(12,18,0,0),
		(13,16,0,0),
		(13,17,0,0),
		(13,18,0,0),
		(14,16,0,0),
		(14,17,0,0),
		(14,18,0,0),
		(15,16,0,0),
		(15,17,0,0),
		(15,18,0,0),
		(16,16,0,0),
		(16,17,0,0),
		(16,18,0,0),
		(17,16,0,0),
		(17,17,0,0),
		(17,18,0,0),
		(18,16,0,0),
		(18,17,0,0),
		(18,18,0,0);

	# Log the actions of the script.

		SET @script_log_message = CONCAT('The table'
								, ' user_group_map'
								, ' has been re-initialized.'
								);
		
		INSERT INTO `ut_script_log`
			(`datetime`
			, `script`
			, `log`
			)
			VALUES
			(@timestamp, @script, @script_log_message)
			;
		
		SET @script_log_message = NULL;

/*Data for the table `classifications` */
	TRUNCATE TABLE `classifications`;

# We always insert the 1 classifications that we need.
	INSERT  INTO `classifications`(`id`,`name`,`description`,`sortkey`) VALUES 
	(2,'My Units','These are the units that you have created or where you have been invited',0)
	;

	# Log the actions of the script.

		SET @script_log_message = CONCAT('The table'
								, ' classifications'
								, ' has been reset and initial data entered.'
								);
		
		INSERT INTO `ut_script_log`
			(`datetime`
			, `script`
			, `log`
			)
			VALUES
			(@timestamp, @script, @script_log_message)
			;
		
		SET @script_log_message = NULL;

		
# We now enter the data that we will need to create the 3 products we want to have

	INSERT INTO `ut_data_to_create_units`(
		`id_unit_to_create`
		,`mefe_unit_id`
		,`mefe_creator_user_id`
		,`bzfe_creator_user_id`
		,`classification_id`
		,`unit_name`
		,`unit_description_details`
		,`bz_created_date`
		,`comment`
		,`product_id`
		,`deleted_datetime`
		,`deletion_script`
		) 
		VALUES 
	(1,'dummynefe1',NULL,1,2,'Demo - Unit 01-02 - Comp A','20 Maple Avenue - San Pedro, CA 90731 - USA','',NULL,NULL,NULL,NULL)
	,(2,'dummynefe2',NULL,1,2,'Demo - Unit 13-06 - Comp B','601 Sherwood Ave. - San Bernardino, CA 92404 - USA','',NULL,NULL,NULL,NULL)
	,(3,'dummynefe3',NULL,1,2,'Demo - Unit 07-08 - Comp B','602 Sherwood Ave. - San Bernardino, CA 92404 - USA','',NULL,NULL,NULL,NULL)
	;

	# Log the actions of the script.

		SET @script_log_message = CONCAT('The table'
								, ' ut_data_to_create_units'
								, ' has been reset and initial data entered to create the 3 demo units.'
								);
		
		INSERT INTO `ut_script_log`
			(`datetime`
			, `script`
			, `log`
			)
			VALUES
			(@timestamp, @script, @script_log_message)
			;
		
		SET @script_log_message = NULL;
	
# We use the script '2_Insert_new_unit_with_dummy_roles_in_unee-t_bzfe_v2.18' to enter the units in the DB

	# Unit 1

		#The unit: What is the id of the unit in the table 'ut_data_to_create_units'
			SET @unit_reference_for_import = 1;

		#Comment out the appropriately depending on which envo you are running this script in.
		#This is needed so that the invitation mechanism works as intended in the MEFE.
				#- Tenant 1
				SET @bz_user_id_dummy_tenant = 4;

				#- Landlord 2
				SET @bz_user_id_dummy_landlord = 3;
				
				#- Contractor 3
				SET @bz_user_id_dummy_contractor = 5;
				
				#- Management company 4
				SET @bz_user_id_dummy_mgt_cny = 6;
				
				#- Agent 5
				SET @bz_user_id_dummy_agent = 2;
			
		#The unit:

			#BZ Classification id for the unit that you want to create (default is 2)
			SET @classification_id = (SELECT `classification_id` FROM `ut_data_to_create_units` WHERE `id_unit_to_create` = @unit_reference_for_import);

			#The name and description
			SET @unit_name = (SELECT `unit_name` FROM `ut_data_to_create_units` WHERE `id_unit_to_create` = @unit_reference_for_import);
			SET @unit_description_details = (SELECT `unit_description_details` FROM `ut_data_to_create_units` WHERE `id_unit_to_create` = @unit_reference_for_import);
			SET @unit_description = @unit_description_details;
			
		#The users associated to this unit.	

			#BZ user id of the user that is creating the unit (default is 1 - Administrator).
			#For LMB migration, we use 2 (support.nobody)
			SET @creator_bz_id = (SELECT `bzfe_creator_user_id` FROM `ut_data_to_create_units` WHERE `id_unit_to_create` = @unit_reference_for_import);
			
		#Other important information that should not change:

			SET @visibility_explanation_1 = 'Visible only to ';
			SET @visibility_explanation_2 = ' for this unit.';

		#The global permission for the application
		#This should not change, it was hard coded when we created Unee-T
			#Can tag comments
				SET @can_tag_comment_group_id = 18;	
			
		#We need to create the component for ALL the roles.
		#We do that using dummy users for all the roles different from the user role.	
				#- agent -> temporary.agent.dev@unee-t.com
				#- landlord  -> temporary.landlord.dev@unee-t.com
				#- Tenant  -> temporary.tenant.dev@unee-t.com
				#- Contractor  -> temporary.contractor.dev@unee-t.com

		#We populate the additional variables that we will need for this script to work

			#For the product
				SET @product_id = 1;
				
				SET @unit = CONCAT(@unit_name, '-', @product_id);
				
				SET @unit_for_query = REPLACE(@unit,' ','%');
				
				SET @unit_for_flag = REPLACE(@unit_for_query,'%','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'-','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'!','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'@','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'#','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'$','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'%','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'^','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'&','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'*','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'(','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,')','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'+','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'=','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'<','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'>','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,':','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,';','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'"','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,',','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'.','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'?','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'/','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'\\','_');
				
				SET @unit_for_group = REPLACE(@unit_for_flag,'_','-');
				SET @unit_for_group = REPLACE(@unit_for_group,'----','-');
				SET @unit_for_group = REPLACE(@unit_for_group,'---','-');
				SET @unit_for_group = REPLACE(@unit_for_group,'--','-');
				
				SET @default_milestone = '---';

				
		# We will create all component_id for all the components/roles we need

			#For the temporary users:
				#Tenant
					SET @component_id_tenant = ((SELECT MAX(`id`) FROM `components`) + 1);
					SET @role_user_g_description_tenant = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`= 1);
					SET @user_pub_name_tenant = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_tenant);
					SET @role_user_pub_info_tenant = CONCAT(@user_pub_name_tenant
														,' - '
														, 'THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL '
														, @role_user_g_description_tenant
														, ' TO THIS UNIT'
														);
					SET @user_role_desc_tenant = @role_user_pub_info_tenant;

				#Landlord
					SET @component_id_landlord = (@component_id_tenant + 1);
					SET @role_user_g_description_landlord = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`= 2);
					SET @user_pub_name_landlord = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_landlord);
					SET @role_user_pub_info_landlord = CONCAT(@user_pub_name_landlord
														,' - '
														, 'THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL '
														, @role_user_g_description_landlord
														, ' TO THIS UNIT'
														);
					SET @user_role_desc_landlord = @role_user_pub_info_landlord;
				
				#Agent
					SET @component_id_agent = (@component_id_landlord + 1);
					SET @role_user_g_description_agent = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`= 5);
					SET @user_pub_name_agent = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_agent);
					SET @role_user_pub_info_agent = CONCAT(@user_pub_name_agent
														,' - '
														, 'THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL '
														, @role_user_g_description_agent
														, ' TO THIS UNIT'
														);
					SET @user_role_desc_agent = @role_user_pub_info_agent;
				
				#Contractor
					SET @component_id_contractor = (@component_id_agent + 1);
					SET @role_user_g_description_contractor = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`= 3);
					SET @user_pub_name_contractor = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_contractor);
					SET @role_user_pub_info_contractor = CONCAT(@user_pub_name_contractor
														,' - '
														, 'THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL '
														, @role_user_g_description_contractor
														, ' TO THIS UNIT'
														);
					SET @user_role_desc_contractor = @role_user_pub_info_contractor;
				
				#Management Company
					SET @component_id_mgt_cny = (@component_id_contractor + 1);
					SET @role_user_g_description_mgt_cny = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`= 4);
					SET @user_pub_name_mgt_cny = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_mgt_cny);
					SET @role_user_pub_info_mgt_cny = CONCAT(@user_pub_name_mgt_cny
														,' - '
														, 'THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL '
														, @role_user_g_description_mgt_cny
														, ' TO THIS UNIT'
														);
					SET @user_role_desc_mgt_cny = @role_user_pub_info_mgt_cny;

		#We now create the unit we need.
			INSERT INTO `products`
				(`id`
				,`name`
				,`classification_id`
				,`description`
				,`isactive`
				,`defaultmilestone`
				,`allows_unconfirmed`
				)
				VALUES
				(@product_id,@unit,@classification_id,@unit_description,1,@default_milestone,1);

			#Log the actions of the script.
				SET @script_log_message = CONCAT('A new unit #'
										, (SELECT IFNULL(@product_id, 'product_id is NULL'))
										, ' ('
										, (SELECT IFNULL(@unit, 'unit is NULL'))
										, ') '
										, ' has been created in the classification: '
										, (SELECT IFNULL(@classification_id, 'classification_id is NULL'))
										, '\r\The bz user #'
										, (SELECT IFNULL(@creator_bz_id, 'creator_bz_id is NULL'))
										, ' (real name: '
										, (SELECT IFNULL(@creator_pub_name, 'creator_pub_name is NULL'))
										, ') '
										, 'is the CREATOR of that unit.'
										)
										;
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(@timestamp, @script, @script_log_message)
					;
				
				SET @script_log_message = NULL;			

			INSERT INTO `milestones`
				(`id`
				,`product_id`
				,`value`
				,`sortkey`
				,`isactive`
				)
				VALUES
				(NULL,@product_id,@default_milestone,0,1);
			
			INSERT INTO `versions`
				(`id`
				,`value`
				,`product_id`
				,`isactive`
				)
				VALUES
				(NULL,@default_milestone,@product_id,1);		
					
		#We create the goups we need
			#For simplicity reason, it is better to create ALL the groups we need for all the possible roles and permissions
			#This will avoid a scenario where we need to grant permission to see occupants for instances but the group for occupants does not exist yet...
			
			#Groups common to all components/roles for this unit
				#Allow user to create a case for this unit
					SET @create_case_group_id = ((SELECT MAX(`id`) FROM `groups`) + 1);
					SET @group_name_create_case_group = (CONCAT(@unit_for_group,'-01-Can-Create-Cases'));
					SET @group_description_create_case_group = 'User can create cases for this unit.';
					
				#Allow user to create a case for this unit
					SET @can_edit_case_group_id = (@create_case_group_id + 1);
					SET @group_name_can_edit_case_group = (CONCAT(@unit_for_group,'-01-Can-Edit-Cases'));
					SET @group_description_can_edit_case_group = 'User can edit a case they have access to';
					
				#Allow user to see the cases for this unit
					SET @can_see_cases_group_id = (@can_edit_case_group_id + 1);
					SET @group_name_can_see_cases_group = (CONCAT(@unit_for_group,'-02-Case-Is-Visible-To-All'));
					SET @group_description_can_see_cases_group = 'User can see the public cases for the unit';
					
				#Allow user to edit all fields in the case for this unit regardless of his/her role
					SET @can_edit_all_field_case_group_id = (@can_see_cases_group_id + 1);
					SET @group_name_can_edit_all_field_case_group = (CONCAT(@unit_for_group,'-03-Can-Always-Edit-all-Fields'));
					SET @group_description_can_edit_all_field_case_group = 'Triage - User can edit all fields in a case they have access to, regardless of role';
					
				#Allow user to edit all the fields in a case, regardless of user role for this unit
					SET @can_edit_component_group_id = (@can_edit_all_field_case_group_id + 1);
					SET @group_name_can_edit_component_group = (CONCAT(@unit_for_group,'-04-Can-Edit-Components'));
					SET @group_description_can_edit_component_group = 'User can edit components/roles for the unit';
					
				#Allow user to see the unit in the search
					SET @can_see_unit_in_search_group_id = (@can_edit_component_group_id + 1);
					SET @group_name_can_see_unit_in_search_group = (CONCAT(@unit_for_group,'-00-Can-See-Unit-In-Search'));
					SET @group_description_can_see_unit_in_search_group = 'User can see the unit in the search panel';
					
			#The groups related to Flags
				#Allow user to  for this unit
					SET @all_g_flags_group_id = (@can_see_unit_in_search_group_id + 1);
					SET @group_name_all_g_flags_group = (CONCAT(@unit_for_group,'-05-Can-Approve-All-Flags'));
					SET @group_description_all_g_flags_group = 'User can approve all flags';
					
				#Allow user to  for this unit
					SET @all_r_flags_group_id = (@all_g_flags_group_id + 1);
					SET @group_name_all_r_flags_group = (CONCAT(@unit_for_group,'-05-Can-Request-All-Flags'));
					SET @group_description_all_r_flags_group = 'User can request a Flag to be approved';
					
				
			#The Groups that control user visibility
				#Allow user to  for this unit
					SET @list_visible_assignees_group_id = (@all_r_flags_group_id + 1);
					SET @group_name_list_visible_assignees_group = (CONCAT(@unit_for_group,'-06-List-Public-Assignee'));
					SET @group_description_list_visible_assignees_group = 'User are visible assignee(s) for this unit';
					
				#Allow user to  for this unit
					SET @see_visible_assignees_group_id = (@list_visible_assignees_group_id + 1);
					SET @group_name_see_visible_assignees_group = (CONCAT(@unit_for_group,'-06-Can-See-Public-Assignee'));
					SET @group_description_see_visible_assignees_group = 'User can see all visible assignee(s) for this unit';
					
			#Other Misc Groups
				#Allow user to  for this unit
					SET @active_stakeholder_group_id = (@see_visible_assignees_group_id + 1);
					SET @group_name_active_stakeholder_group = (CONCAT(@unit_for_group,'-07-Active-Stakeholder'));
					SET @group_description_active_stakeholder_group = 'Users who have a role in this unit as of today (WIP)';
					
				#Allow user to  for this unit
					SET @unit_creator_group_id = (@active_stakeholder_group_id + 1);
					SET @group_name_unit_creator_group = (CONCAT(@unit_for_group,'-07-Unit-Creator'));
					SET @group_description_unit_creator_group = 'User is considered to be the creator of the unit';
					
			#Groups associated to the components/roles
				#For the tenant
					#Visibility group
					SET @group_id_show_to_tenant = (@unit_creator_group_id + 1);
					SET @group_name_show_to_tenant = (CONCAT(@unit_for_group,'-02-Limit-to-Tenant'));
					SET @group_description_tenant = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 1),@visibility_explanation_2));
				
					#Is in tenant user Group
					SET @group_id_are_users_tenant = (@group_id_show_to_tenant + 1);
					SET @group_name_are_users_tenant = (CONCAT(@unit_for_group,'-06-List-Tenant'));
					SET @group_description_are_users_tenant = (CONCAT('list the tenant(s)', @unit));
					
					#Can See tenant user Group
					SET @group_id_see_users_tenant = (@group_id_are_users_tenant + 1);
					SET @group_name_see_users_tenant = (CONCAT(@unit_for_group,'-06-Can-see-Tenant'));
					SET @group_description_see_users_tenant = (CONCAT('See the list of tenant(s) for ', @unit));
			
				#For the Landlord
					#Visibility group 
					SET @group_id_show_to_landlord = (@group_id_see_users_tenant + 1);
					SET @group_name_show_to_landlord = (CONCAT(@unit_for_group,'-02-Limit-to-Landlord'));
					SET @group_description_show_to_landlord = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 2),@visibility_explanation_2));
					
					#Is in landlord user Group
					SET @group_id_are_users_landlord = (@group_id_show_to_landlord + 1);
					SET @group_name_are_users_landlord = (CONCAT(@unit_for_group,'-06-List-landlord'));
					SET @group_description_are_users_landlord = (CONCAT('list the landlord(s)', @unit));
					
					#Can See landlord user Group
					SET @group_id_see_users_landlord = (@group_id_are_users_landlord + 1);
					SET @group_name_see_users_landlord = (CONCAT(@unit_for_group,'-06-Can-see-lanldord'));
					SET @group_description_see_users_landlord = (CONCAT('See the list of lanldord(s) for ', @unit));
					
				#For the agent
					#Visibility group 
					SET @group_id_show_to_agent = (@group_id_see_users_landlord + 1);
					SET @group_name_show_to_agent = (CONCAT(@unit_for_group,'-02-Limit-to-Agent'));
					SET @group_description_show_to_agent = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 5),@visibility_explanation_2));
					
					#Is in Agent user Group
					SET @group_id_are_users_agent = (@group_id_show_to_agent + 1);
					SET @group_name_are_users_agent = (CONCAT(@unit_for_group,'-06-List-agent'));
					SET @group_description_are_users_agent = (CONCAT('list the agent(s)', @unit));
					
					#Can See Agent user Group
					SET @group_id_see_users_agent = (@group_id_are_users_agent + 1);
					SET @group_name_see_users_agent = (CONCAT(@unit_for_group,'-06-Can-see-agent'));
					SET @group_description_see_users_agent = (CONCAT('See the list of agent(s) for ', @unit));
				
				#For the contractor
					#Visibility group 
					SET @group_id_show_to_contractor = (@group_id_see_users_agent + 1);
					SET @group_name_show_to_contractor = (CONCAT(@unit_for_group,'-02-Limit-to-Contractor-Employee'));
					SET @group_description_show_to_contractor = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 3),@visibility_explanation_2));
					
					#Is in contractor user Group
					SET @group_id_are_users_contractor = (@group_id_show_to_contractor + 1);
					SET @group_name_are_users_contractor = (CONCAT(@unit_for_group,'-06-List-contractor-employee'));
					SET @group_description_are_users_contractor = (CONCAT('list the contractor employee(s)', @unit));
					
					#Can See contractor user Group
					SET @group_id_see_users_contractor = (@group_id_are_users_contractor + 1);
					SET @group_name_see_users_contractor = (CONCAT(@unit_for_group,'-06-Can-see-contractor-employee'));
					SET @group_description_see_users_contractor = (CONCAT('See the list of contractor employee(s) for ', @unit));
					
				#For the Mgt Cny
					#Visibility group
					SET @group_id_show_to_mgt_cny = (@group_id_see_users_contractor + 1);
					SET @group_name_show_to_mgt_cny = (CONCAT(@unit_for_group,'-02-Limit-to-Mgt-Cny-Employee'));
					SET @group_description_show_to_mgt_cny = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 4),@visibility_explanation_2));
					
					#Is in mgt cny user Group
					SET @group_id_are_users_mgt_cny = (@group_id_show_to_mgt_cny + 1);
					SET @group_name_are_users_mgt_cny = (CONCAT(@unit_for_group,'-06-List-Mgt-Cny-Employee'));
					SET @group_description_are_users_mgt_cny = (CONCAT('list the Mgt Cny Employee(s)', @unit));
					
					#Can See mgt cny user Group
					SET @group_id_see_users_mgt_cny = (@group_id_are_users_mgt_cny + 1);
					SET @group_name_see_users_mgt_cny = (CONCAT(@unit_for_group,'-06-Can-see-Mgt-Cny-Employee'));
					SET @group_description_see_users_mgt_cny = (CONCAT('See the list of Mgt Cny Employee(s) for ', @unit));
				
				#For the occupant
					#Visibility group
					SET @group_id_show_to_occupant = (@group_id_see_users_mgt_cny + 1);
					SET @group_name_show_to_occupant = (CONCAT(@unit_for_group,'-02-Limit-to-occupant'));
					SET @group_description_show_to_occupant = (CONCAT(@visibility_explanation_1,'Occupants'));
					
					#Is in occupant user Group
					SET @group_id_are_users_occupant = (@group_id_show_to_occupant + 1);
					SET @group_name_are_users_occupant = (CONCAT(@unit_for_group,'-06-List-occupant'));
					SET @group_description_are_users_occupant = (CONCAT('list-the-occupant(s)-', @unit));
					
					#Can See occupant user Group
					SET @group_id_see_users_occupant = (@group_id_are_users_occupant + 1);
					SET @group_name_see_users_occupant = (CONCAT(@unit_for_group,'-06-Can-see-occupant'));
					SET @group_description_see_users_occupant = (CONCAT('See the list of occupant(s) for ', @unit));
					
				#For the people invited by this user:
					#Is in invited_by user Group
					SET @group_id_are_users_invited_by = (@group_id_see_users_occupant + 1);
					SET @group_name_are_users_invited_by = (CONCAT(@unit_for_group,'-06-List-invited-by'));
					SET @group_description_are_users_invited_by = (CONCAT('list the invited_by(s)', @unit));
					
					#Can See users in invited_by user Group
					SET @group_id_see_users_invited_by = (@group_id_are_users_invited_by + 1);
					SET @group_name_see_users_invited_by = (CONCAT(@unit_for_group,'-06-Can-see-invited-by'));
					SET @group_description_see_users_invited_by = (CONCAT('See the list of invited_by(s) for ', @unit));

			#We can populate the 'groups' table now.
				INSERT INTO `groups`
					(`id`
					,`name`
					,`description`
					,`isbuggroup`
					,`userregexp`
					,`isactive`
					,`icon_url`
					) 
					VALUES 
					(@create_case_group_id,@group_name_create_case_group,@group_description_create_case_group,1,'',1,NULL)
					,(@can_edit_case_group_id,@group_name_can_edit_case_group,@group_description_can_edit_case_group,1,'',1,NULL)
					,(@can_see_cases_group_id,@group_name_can_see_cases_group,@group_description_can_see_cases_group,1,'',1,NULL)
					,(@can_edit_all_field_case_group_id,@group_name_can_edit_all_field_case_group,@group_description_can_edit_all_field_case_group,1,'',1,NULL)
					,(@can_edit_component_group_id,@group_name_can_edit_component_group,@group_description_can_edit_component_group,1,'',1,NULL)
					,(@can_see_unit_in_search_group_id,@group_name_can_see_unit_in_search_group,@group_description_can_see_unit_in_search_group,1,'',1,NULL)
					,(@all_g_flags_group_id,@group_name_all_g_flags_group,@group_description_all_g_flags_group,1,'',0,NULL)
					,(@all_r_flags_group_id,@group_name_all_r_flags_group,@group_description_all_r_flags_group,1,'',0,NULL)
					,(@list_visible_assignees_group_id,@group_name_list_visible_assignees_group,@group_description_list_visible_assignees_group,1,'',0,NULL)
					,(@see_visible_assignees_group_id,@group_name_see_visible_assignees_group,@group_description_see_visible_assignees_group,1,'',0,NULL)
					,(@active_stakeholder_group_id,@group_name_active_stakeholder_group,@group_description_active_stakeholder_group,1,'',1,NULL)
					,(@unit_creator_group_id,@group_name_unit_creator_group,@group_description_unit_creator_group,1,'',0,NULL)
					,(@group_id_show_to_tenant,@group_name_show_to_tenant,@group_description_tenant,1,'',1,NULL)
					,(@group_id_are_users_tenant,@group_name_are_users_tenant,@group_description_are_users_tenant,1,'',0,NULL)
					,(@group_id_see_users_tenant,@group_name_see_users_tenant,@group_description_see_users_tenant,1,'',0,NULL)
					,(@group_id_show_to_landlord,@group_name_show_to_landlord,@group_description_show_to_landlord,1,'',1,NULL)
					,(@group_id_are_users_landlord,@group_name_are_users_landlord,@group_description_are_users_landlord,1,'',0,NULL)
					,(@group_id_see_users_landlord,@group_name_see_users_landlord,@group_description_see_users_landlord,1,'',0,NULL)
					,(@group_id_show_to_agent,@group_name_show_to_agent,@group_description_show_to_agent,1,'',1,NULL)
					,(@group_id_are_users_agent,@group_name_are_users_agent,@group_description_are_users_agent,1,'',0,NULL)
					,(@group_id_see_users_agent,@group_name_see_users_agent,@group_description_see_users_agent,1,'',0,NULL)
					,(@group_id_show_to_contractor,@group_name_show_to_contractor,@group_description_show_to_contractor,1,'',1,NULL)
					,(@group_id_are_users_contractor,@group_name_are_users_contractor,@group_description_are_users_contractor,1,'',0,NULL)
					,(@group_id_see_users_contractor,@group_name_see_users_contractor,@group_description_see_users_contractor,1,'',0,NULL)
					,(@group_id_show_to_mgt_cny,@group_name_show_to_mgt_cny,@group_description_show_to_mgt_cny,1,'',1,NULL)
					,(@group_id_are_users_mgt_cny,@group_name_are_users_mgt_cny,@group_description_are_users_mgt_cny,1,'',0,NULL)
					,(@group_id_see_users_mgt_cny,@group_name_see_users_mgt_cny,@group_description_see_users_mgt_cny,1,'',0,NULL)
					,(@group_id_show_to_occupant,@group_name_show_to_occupant,@group_description_show_to_occupant,1,'',1,NULL)
					,(@group_id_are_users_occupant,@group_name_are_users_occupant,@group_description_are_users_occupant,1,'',0,NULL)
					,(@group_id_see_users_occupant,@group_name_see_users_occupant,@group_description_see_users_occupant,1,'',0,NULL)
					,(@group_id_are_users_invited_by,@group_name_are_users_invited_by,@group_description_are_users_invited_by,1,'',0,NULL)
					,(@group_id_see_users_invited_by,@group_name_see_users_invited_by,@group_description_see_users_invited_by,1,'',0,NULL)
					;

			#Log the actions of the script.
				SET @script_log_message = CONCAT('We have created the groups that we will need for that unit #'
										, @product_id
										, '\r\ - To grant '
										, 'case creation'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@create_case_group_id, 'create_case_group_id is NULL'))
										, '\r\ - To grant '
										, 'Edit case'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@can_edit_case_group_id, 'can_edit_case_group_id is NULL'))
										, '\r\ - To grant '
										, 'Edit all field regardless of role'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@can_edit_all_field_case_group_id, 'can_edit_all_field_case_group_id is NULL'))
										, '\r\ - To grant '
										, 'Edit Component/roles'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@can_edit_component_group_id, 'can_edit_component_group_id is NULL'))
										, '\r\ - To grant '
										, 'See unit in the Search panel'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@can_see_unit_in_search_group_id, 'can_see_unit_in_search_group_id is NULL'))
										, '\r\ - To grant '
										, 'See cases'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@can_see_cases_group_id, 'can_see_cases_group_id is NULL'))
										, '\r\ - To grant '
										, 'Request all flags'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@all_r_flags_group_id, 'all_r_flags_group_id is NULL'))
										, '\r\ - To grant '
										, 'Approve all flags'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@all_g_flags_group_id, 'all_g_flags_group_id is NULL'))
										, '\r\ - To grant '
										, 'User is publicly visible'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@list_visible_assignees_group_id, 'list_visible_assignees_group_id is NULL'))
										, '\r\ - To grant '
										, 'User can see publicly visible'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@see_visible_assignees_group_id, 'see_visible_assignees_group_id is NULL'))
										, '\r\ - To grant '
										, 'User is active Stakeholder'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@active_stakeholder_group_id, 'active_stakeholder_group_id is NULL'))
										, '\r\ - To grant '
										, 'User is the unit creator'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@unit_creator_group_id, 'unit_creator_group_id is NULL'))
										, '\r\ - Restrict permission to '
										, 'tenant'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_show_to_tenant, 'group_id_show_to_tenant is NULL'))
										, '\r\ - Group for the '
										, 'tenant'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_are_users_tenant, 'group_id_are_users_tenant is NULL'))
										, '\r\ - Group to see the users '
										, 'tenant'
										, '. Group_id: '
										, (SELECT IFNULL(@group_id_see_users_tenant, 'group_id_see_users_tenant is NULL'))
										
										, '\r\ - Restrict permission to '
										, 'landlord'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_show_to_landlord, 'group_id_show_to_landlord is NULL'))
										, '\r\ - Group for the '
										, 'landlord'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_are_users_landlord, 'group_id_are_users_landlord is NULL'))
										, '\r\ - Group to see the users'
										, 'landlord'
										, '. Group_id: '
										, (SELECT IFNULL(@group_id_see_users_landlord, 'group_id_see_users_landlord is NULL'))
										
										, '\r\ - Restrict permission to '
										, 'agent'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_show_to_agent, 'group_id_show_to_agent is NULL'))
										, '\r\ - Group for the '
										, 'agent'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_are_users_agent, 'group_id_are_users_agent is NULL'))
										, '\r\ - Group to see the users'
										, 'agent'
										, '. Group_id: '
										, (SELECT IFNULL(@group_id_see_users_agent, 'group_id_see_users_agent is NULL'))
										
										, '\r\ - Restrict permission to '
										, 'Contractor'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_show_to_contractor, 'group_id_show_to_contractor is NULL'))
										, '\r\ - Group for the '
										, 'Contractor'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_are_users_contractor, 'group_id_are_users_contractor is NULL'))
										, '\r\ - Group to see the users'
										, 'Contractor'
										, '. Group_id: '
										, (SELECT IFNULL(@group_id_see_users_contractor, 'group_id_see_users_contractor is NULL'))
										
										, '\r\ - Restrict permission to '
										, 'Management Company'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_show_to_mgt_cny, 'group_id_show_to_mgt_cny is NULL'))
										, '\r\ - Group for the users in the '
										, 'Management Company'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_are_users_mgt_cny, 'group_id_are_users_mgt_cny is NULL'))
										, '\r\ - Group to see the users in the '
										, 'Management Company'
										, '. Group_id: '
										, (SELECT IFNULL(@group_id_see_users_mgt_cny, 'group_id_see_users_mgt_cny is NULL'))
										
										, '\r\ - Restrict permission to '
										, 'occupant'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_show_to_occupant, 'group_id_show_to_occupant is NULL'))
										, '\r\ - Group for the '
										, 'occupant'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_are_users_occupant, 'group_id_are_users_occupant is NULL'))
										, '\r\ - Group to see the users '
										, 'occupant'
										, '. Group_id: '
										, (SELECT IFNULL(@group_id_see_users_occupant, 'group_id_see_users_occupant is NULL'))
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(@timestamp, @script, @script_log_message)
					;
				
				SET @script_log_message = NULL;				
					
		#We record the groups we have just created:
			#We NEED the component_id for that

			INSERT INTO `ut_product_group`
				(
				product_id
				,component_id
				,group_id
				,group_type_id
				,role_type_id
				,created_by_id
				,created
				)
				VALUES
				(@product_id,NULL,@create_case_group_id,20,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@can_edit_case_group_id,25,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@can_edit_all_field_case_group_id,26,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@can_edit_component_group_id,27,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@can_see_cases_group_id,28,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@can_see_unit_in_search_group_id,38,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@all_r_flags_group_id,18,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@all_g_flags_group_id,19,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@list_visible_assignees_group_id,4,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@see_visible_assignees_group_id,5,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@active_stakeholder_group_id,29,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@unit_creator_group_id,1,NULL,@creator_bz_id,@timestamp)
				, # Tenant (1)
				(@product_id,@component_id_tenant,@group_id_show_to_tenant,2,1,@creator_bz_id,@timestamp)
				,(@product_id,@component_id_tenant,@group_id_are_users_tenant,22,1,@creator_bz_id,@timestamp)
				,(@product_id,@component_id_tenant,@group_id_see_users_tenant,37,1,@creator_bz_id,@timestamp)
				#Landlord (2)
				,(@product_id,@component_id_landlord,@group_id_show_to_landlord,2,2,@creator_bz_id,@timestamp)
				,(@product_id,@component_id_landlord,@group_id_are_users_landlord,22,2,@creator_bz_id,@timestamp)
				,(@product_id,@component_id_landlord,@group_id_see_users_landlord,37,2,@creator_bz_id,@timestamp)
				#Agent (5)
				,(@product_id,@component_id_agent,@group_id_show_to_agent,2,5,@creator_bz_id,@timestamp)
				,(@product_id,@component_id_agent,@group_id_are_users_agent,22,5,@creator_bz_id,@timestamp)
				,(@product_id,@component_id_agent,@group_id_see_users_agent,37,5,@creator_bz_id,@timestamp)
				#contractor (3)
				,(@product_id,@component_id_contractor,@group_id_show_to_contractor,2,3,@creator_bz_id,@timestamp)
				,(@product_id,@component_id_contractor,@group_id_are_users_contractor,22,3,@creator_bz_id,@timestamp)
				,(@product_id,@component_id_contractor,@group_id_see_users_contractor,37,3,@creator_bz_id,@timestamp)
				#mgt_cny (4)
				,(@product_id,@component_id_mgt_cny,@group_id_show_to_mgt_cny,2,4,@creator_bz_id,@timestamp)
				,(@product_id,@component_id_mgt_cny,@group_id_are_users_mgt_cny,22,4,@creator_bz_id,@timestamp)
				,(@product_id,@component_id_mgt_cny,@group_id_see_users_mgt_cny,37,4,@creator_bz_id,@timestamp)
				#occupant (#)
				,(@product_id,NULL,@group_id_show_to_occupant,24,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@group_id_are_users_occupant,3,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@group_id_see_users_occupant,36,NULL,@creator_bz_id,@timestamp)
				#invited_by
				,(@product_id,NULL,@group_id_are_users_invited_by,31,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@group_id_see_users_invited_by,32,NULL,@creator_bz_id,@timestamp)
				;

		#We now Create the flagtypes and flags for this new unit (we NEEDED the group ids for that!):
			SET @flag_next_step = ((SELECT MAX(`id`) FROM `flagtypes`) + 1);
			SET @flag_solution = (@flag_next_step + 1);
			SET @flag_budget = (@flag_solution + 1);
			SET @flag_attachment = (@flag_budget + 1);
			SET @flag_ok_to_pay = (@flag_attachment + 1);
			SET @flag_is_paid = (@flag_ok_to_pay + 1);

			INSERT INTO `flagtypes`
				(`id`
				,`name`
				,`description`
				,`cc_list`
				,`target_type`
				,`is_active`
				,`is_requestable`
				,`is_requesteeble`
				,`is_multiplicable`
				,`sortkey`
				,`grant_group_id`
				,`request_group_id`
				) 
				VALUES 
				(@flag_next_step,CONCAT('Next_Step_',@unit_for_flag),'Approval for the Next Step of the case.','','b',1,1,1,1,10,@all_g_flags_group_id,@all_r_flags_group_id)
				,(@flag_solution,CONCAT('Solution_',@unit_for_flag),'Approval for the Solution of this case.','','b',1,1,1,1,20,@all_g_flags_group_id,@all_r_flags_group_id)
				,(@flag_budget,CONCAT('Budget_',@unit_for_flag),'Approval for the Budget for this case.','','b',1,1,1,1,30,@all_g_flags_group_id,@all_r_flags_group_id)
				,(@flag_attachment,CONCAT('Attachment_',@unit_for_flag),'Approval for this Attachment.','','a',1,1,1,1,10,@all_g_flags_group_id,@all_r_flags_group_id)
				,(@flag_ok_to_pay,CONCAT('OK_to_pay_',@unit_for_flag),'Approval to pay this bill.','','a',1,1,1,1,20,@all_g_flags_group_id,@all_r_flags_group_id)
				,(@flag_is_paid,CONCAT('is_paid_',@unit_for_flag),'Confirm if this bill has been paid.','','a',1,1,1,1,30,@all_g_flags_group_id,@all_r_flags_group_id)
				;
			
			INSERT INTO `flaginclusions`
				(`type_id`
				,`product_id`
				,`component_id`
				) 
				VALUES
				(@flag_next_step,@product_id,NULL)
				,(@flag_solution,@product_id,NULL)
				,(@flag_budget,@product_id,NULL)
				,(@flag_attachment,@product_id,NULL)
				,(@flag_ok_to_pay,@product_id,NULL)
				,(@flag_is_paid,@product_id,NULL)
				;

			#Log the actions of the script.
				SET @script_log_message = CONCAT('We have created the following flags which are restricted to that unit: '
										, '\r\ - Next Step (#'
										, (SELECT IFNULL(@flag_next_step, 'flag_next_step is NULL'))
										, ').'
										, '\r\ - Solution (#'
										, (SELECT IFNULL(@flag_solution, 'flag_solution is NULL'))
										, ').'
										, '\r\ - Budget (#'
										, (SELECT IFNULL(@flag_budget, 'flag_budget is NULL'))
										, ').'
										, '\r\ - Attachment (#'
										, (SELECT IFNULL(@flag_attachment, 'flag_attachment is NULL'))
										, ').'
										, '\r\ - OK to pay (#'
										, (SELECT IFNULL(@flag_ok_to_pay, 'flag_ok_to_pay is NULL'))
										, ').'
										, '\r\ - Is paid (#'
										, (SELECT IFNULL(@flag_is_paid, 'flag_is_paid is NULL'))
										, ').'
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(@timestamp, @script, @script_log_message)
					;
				
				SET @script_log_message = NULL;	
				
		#We configure the group permissions:
			#Data for the table `group_group_map`
			#We use a temporary table to do this, this is to avoid duplicate in the group_group_map table

			#DELETE the temp table if it exists
			DROP TABLE IF EXISTS `ut_group_group_map_temp`;
			
			#Re-create the temp table
			CREATE TABLE `ut_group_group_map_temp` (
			  `member_id` MEDIUMINT(9) NOT NULL,
			  `grantor_id` MEDIUMINT(9) NOT NULL,
			  `grant_type` TINYINT(4) NOT NULL DEFAULT 0
			) ENGINE=INNODB DEFAULT CHARSET=utf8;

			#Add the records that exist in the table group_group_map
			INSERT INTO `ut_group_group_map_temp`
				SELECT *
				FROM `group_group_map`;
			
			
			#Add the new records
			INSERT INTO `ut_group_group_map_temp`
				(`member_id`
				,`grantor_id`
				,`grant_type`
				) 
			##########################################################
			#Logic:
			#If you are a member of group_id XXX (ex: 1 / Admin) 
			#then you have the following permissions:
				#- 0: You are automatically a member of group ZZZ
				#- 1: You can grant access to group ZZZ
				#- 2: You can see users in group ZZZ
			##########################################################
				VALUES 
				#Admin group can grant membership to all
				(1,@create_case_group_id,1)
				,(1,@can_edit_case_group_id,1)
				,(1,@can_see_cases_group_id,1)
				,(1,@can_edit_all_field_case_group_id,1)
				,(1,@can_edit_component_group_id,1)
				,(1,@can_see_unit_in_search_group_id,1)
				,(1,@all_g_flags_group_id,1)
				,(1,@all_r_flags_group_id,1)
				,(1,@list_visible_assignees_group_id,1)
				,(1,@see_visible_assignees_group_id,1)
				,(1,@active_stakeholder_group_id,1)
				,(1,@unit_creator_group_id,1)
				,(1,@group_id_show_to_tenant,1)
				,(1,@group_id_are_users_tenant,1)
				,(1,@group_id_see_users_tenant,1)
				,(1,@group_id_show_to_landlord,1)
				,(1,@group_id_are_users_landlord,1)
				,(1,@group_id_see_users_landlord,1)
				,(1,@group_id_show_to_agent,1)
				,(1,@group_id_are_users_agent,1)
				,(1,@group_id_see_users_agent,1)
				,(1,@group_id_show_to_contractor,1)
				,(1,@group_id_are_users_contractor,1)
				,(1,@group_id_see_users_contractor,1)
				,(1,@group_id_show_to_mgt_cny,1)
				,(1,@group_id_are_users_mgt_cny,1)
				,(1,@group_id_see_users_mgt_cny,1)
				,(1,@group_id_show_to_occupant,1)
				,(1,@group_id_are_users_occupant,1)
				,(1,@group_id_see_users_occupant,1)
				,(1,@group_id_are_users_invited_by,1)
				,(1,@group_id_see_users_invited_by,1)
				
				#Admin MUST be a member of the mandatory group for this unit
				#If not it is impossible to see this product in the BZFE backend.
				,(1,@can_see_unit_in_search_group_id,0)

				#Visibility groups:
				,(@all_r_flags_group_id,@all_g_flags_group_id,2)
				,(@see_visible_assignees_group_id,@list_visible_assignees_group_id,2)
				,(@unit_creator_group_id,@unit_creator_group_id,2)
				,(@group_id_see_users_tenant,@group_id_are_users_tenant,2)
				,(@group_id_see_users_landlord,@group_id_are_users_landlord,2)
				,(@group_id_see_users_agent,@group_id_are_users_contractor,2)
				,(@group_id_see_users_mgt_cny,@group_id_are_users_mgt_cny,2)
				,(@group_id_see_users_occupant,@group_id_are_users_occupant,2)
				,(@group_id_see_users_invited_by,@group_id_are_users_invited_by,2)
				;

		#We make sure that only user in certain groups can create, edit or see cases.
			INSERT INTO `group_control_map`
				(`group_id`
				,`product_id`
				,`entry`
				,`membercontrol`
				,`othercontrol`
				,`canedit`
				,`editcomponents`
				,`editbugs`
				,`canconfirm`
				) 
				VALUES 
				(@create_case_group_id,@product_id,1,0,0,0,0,0,0)
				,(@can_edit_case_group_id,@product_id,1,0,0,1,0,0,1)
				,(@can_edit_all_field_case_group_id,@product_id,1,0,0,1,0,1,1)
				,(@can_edit_component_group_id,@product_id,0,0,0,0,1,0,0)
				,(@can_see_cases_group_id,@product_id,0,2,0,0,0,0,0)
				,(@can_see_unit_in_search_group_id,@product_id,0,3,3,0,0,0,0)
				,(@group_id_show_to_tenant,@product_id,0,2,0,0,0,0,0)
				,(@group_id_show_to_landlord,@product_id,0,2,0,0,0,0,0)
				,(@group_id_show_to_agent,@product_id,0,2,0,0,0,0,0)
				,(@group_id_show_to_contractor,@product_id,0,2,0,0,0,0,0)
				,(@group_id_show_to_mgt_cny,@product_id,0,2,0,0,0,0,0)
				,(@group_id_show_to_occupant,@product_id,0,2,0,0,0,0,0)
				;

			#Log the actions of the script.
				SET @script_log_message = CONCAT('We have updated the group control permissions for the product# '
										, @product_id
										, ': '
										, '\r\ - Create Case (#'
										, (SELECT IFNULL(@create_case_group_id, 'create_case_group_id is NULL'))
										, ').'
										, '\r\ - Edit Case (#'
										, (SELECT IFNULL(@can_edit_case_group_id, 'can_edit_case_group_id is NULL'))
										, ').'
										, '\r\ - Edit All Field (#'
										, (SELECT IFNULL(@can_edit_all_field_case_group_id, 'can_edit_all_field_case_group_id is NULL'))
										, ').'
										, '\r\ - Edit Component (#'
										, (SELECT IFNULL(@can_edit_component_group_id, 'can_edit_component_group_id is NULL'))
										, ').'
										, '\r\ - Can see case (#'
										, (SELECT IFNULL(@can_see_cases_group_id, 'flag_ok_to_pay is NULL'))
										, ').'
										, '\r\ - Can See unit in Search (#'
										, (SELECT IFNULL(@group_id_show_to_tenant, 'group_id_show_to_tenant is NULL'))
										, ').'
										, '\r\ - Show case to Tenant (#'
										, (SELECT IFNULL(@group_id_show_to_landlord, 'group_id_show_to_landlord is NULL'))
										, ').'
										, '\r\ - Show case to Landlord (#'
										, (SELECT IFNULL(@group_id_show_to_landlord, 'group_id_show_to_landlord is NULL'))
										, ').'
										, '\r\ - Show case to Agent (#'
										, (SELECT IFNULL(@group_id_show_to_agent, 'group_id_show_to_agent is NULL'))
										, ').'
										, '\r\ - Show case to Contractor (#'
										, (SELECT IFNULL(@group_id_show_to_contractor, 'group_id_show_to_contractor is NULL'))
										, ').'
										, '\r\ - Show case to Management Company (#'
										, (SELECT IFNULL(@group_id_show_to_mgt_cny, 'group_id_show_to_mgt_cny is NULL'))
										, ').'
										, '\r\ - Show case to Occupant(s) (#'
										, (SELECT IFNULL(@group_id_show_to_occupant, 'group_id_show_to_occupant is NULL'))
										, ').'
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;
				
				SET @script_log_message = NULL;

			#We have eveything, we can create the components we need:
				INSERT INTO `components`
				(`id`
				,`name`
				,`product_id`
				,`initialowner`
				,`initialqacontact`
				,`description`
				,`isactive`
				) 
				VALUES
				(@component_id_tenant,@role_user_g_description_tenant,@product_id,@bz_user_id_dummy_tenant,@bz_user_id_dummy_tenant,@user_role_desc_tenant,1)
				, (@component_id_landlord, @role_user_g_description_landlord, @product_id, @bz_user_id_dummy_landlord, @bz_user_id_dummy_landlord, @user_role_desc_landlord, 1)
				, (@component_id_agent, @role_user_g_description_agent, @product_id, @bz_user_id_dummy_agent, @bz_user_id_dummy_agent, @user_role_desc_agent, 1)
				, (@component_id_contractor, @role_user_g_description_contractor, @product_id, @bz_user_id_dummy_contractor, @bz_user_id_dummy_contractor, @user_role_desc_contractor, 1)
				, (@component_id_mgt_cny, @role_user_g_description_mgt_cny, @product_id, @bz_user_id_dummy_mgt_cny, @bz_user_id_dummy_mgt_cny, @user_role_desc_mgt_cny, 1)
				;
			

			#Log the actions of the script.
				SET @script_log_message = CONCAT('The role created for that unit with temporary users were:'
										, '\r\- '
										, (SELECT IFNULL(@role_user_g_description_tenant, 'role_user_g_description is NULL'))
										, ' (role_type_id #'
										, '1'
										, ') '
										, '\r\The user associated to this role was bz user #'
										, (SELECT IFNULL(@bz_user_id_dummy_tenant, 'bz_user_id is NULL'))
										, ' (real name: '
										, (SELECT IFNULL(@user_pub_name_tenant, 'user_pub_name is NULL'))
										, '. This user is the default assignee for this role for that unit).' 
										
										, '\r\- '
										, (SELECT IFNULL(@role_user_g_description_landlord, 'role_user_g_description is NULL'))
										, ' (role_type_id #'
										, '2'
										, ') '
										, '\r\The user associated to this role was bz user #'
										, (SELECT IFNULL(@bz_user_id_dummy_landlord, 'bz_user_id is NULL'))
										, ' (real name: '
										, (SELECT IFNULL(@user_pub_name_landlord, 'user_pub_name is NULL'))
										, '. This user is the default assignee for this role for that unit).'
										
										, '\r\- '
										, (SELECT IFNULL(@role_user_g_description_agent, 'role_user_g_description is NULL'))
										, ' (role_type_id #'
										, '5'
										, ') '
										, '\r\The user associated to this role was bz user #'
										, (SELECT IFNULL(@bz_user_id_dummy_agent, 'bz_user_id is NULL'))
										, ' (real name: '
										, (SELECT IFNULL(@user_pub_name_agent, 'user_pub_name is NULL'))
										, '. This user is the default assignee for this role for that unit).'
										
										, '\r\- '
										, (SELECT IFNULL(@role_user_g_description_contractor, 'role_user_g_description is NULL'))
										, ' (role_type_id #'
										, '3'
										, ') '
										, '\r\The user associated to this role was bz user #'
										, (SELECT IFNULL(@bz_user_id_dummy_contractor, 'bz_user_id is NULL'))
										, ' (real name: '
										, (SELECT IFNULL(@user_pub_name_contractor, 'user_pub_name is NULL'))
										, '. This user is the default assignee for this role for that unit).'

										, '\r\- '
										, (SELECT IFNULL(@role_user_g_description_mgt_cny, 'role_user_g_description is NULL'))
										, ' (role_type_id #'
										, '3'
										, ') '
										, '\r\The user associated to this role was bz user #'
										, (SELECT IFNULL(@bz_user_id_dummy_mgt_cny, 'bz_user_id is NULL'))
										, ' (real name: '
										, (SELECT IFNULL(@user_pub_name_mgt_cny, 'user_pub_name is NULL'))
										, '. This user is the default assignee for this role for that unit).'								
										)
										;
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;
				
				SET @script_log_message = NULL;	
					
			#We update the BZ logs
				INSERT INTO `audit_log`
					(`user_id`
					,`class`
					,`object_id`
					,`field`
					,`removed`
					,`added`
					,`at_time`
					) 
					VALUES 
					(@creator_bz_id, 'Bugzilla::Group', @create_case_group_id, '__create__', NULL, @group_name_create_case_group, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @can_edit_case_group_id, '__create__', NULL, @group_name_can_edit_case_group, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @can_edit_all_field_case_group_id, '__create__', NULL, @group_name_can_edit_all_field_case_group, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @can_edit_component_group_id, '__create__', NULL, @group_name_can_edit_component_group, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @can_see_cases_group_id, '__create__', NULL, @group_name_can_see_cases_group, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @can_see_unit_in_search_group_id, '__create__', NULL, @group_name_can_see_unit_in_search_group, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @all_g_flags_group_id, '__create__', NULL, @group_name_all_g_flags_group, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @all_r_flags_group_id, '__create__', NULL, @group_name_all_r_flags_group, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @list_visible_assignees_group_id, '__create__', NULL, @group_name_list_visible_assignees_group, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @see_visible_assignees_group_id, '__create__', NULL, @group_name_see_visible_assignees_group, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @active_stakeholder_group_id, '__create__', NULL, @group_name_active_stakeholder_group, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @unit_creator_group_id, '__create__', NULL, @group_name_unit_creator_group, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_tenant, '__create__', NULL, @group_name_show_to_tenant, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_tenant, '__create__', NULL, @group_name_are_users_tenant, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_tenant, '__create__', NULL, @group_name_see_users_tenant, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_landlord, '__create__', NULL, @group_name_show_to_landlord, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_landlord, '__create__', NULL, @group_name_are_users_landlord, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_landlord, '__create__', NULL, @group_name_see_users_landlord, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_agent, '__create__', NULL, @group_name_show_to_agent, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_agent, '__create__', NULL, @group_name_are_users_agent, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_agent, '__create__', NULL, @group_name_see_users_agent, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_contractor, '__create__', NULL, @group_name_show_to_contractor, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_contractor, '__create__', NULL, @group_name_are_users_contractor, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_contractor, '__create__', NULL, @group_name_see_users_contractor, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_mgt_cny, '__create__', NULL, @group_name_show_to_mgt_cny, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_mgt_cny, '__create__', NULL, @group_name_are_users_mgt_cny, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_mgt_cny, '__create__', NULL, @group_name_see_users_mgt_cny, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_occupant, '__create__', NULL, @group_name_show_to_occupant, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_occupant, '__create__', NULL, @group_name_are_users_occupant, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_occupant, '__create__', NULL, @group_name_see_users_occupant, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_invited_by, '__create__', NULL, @group_name_are_users_invited_by, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_invited_by, '__create__', NULL, @group_name_see_users_invited_by, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Component', @component_id_tenant, '__create__', NULL, @role_user_g_description_tenant, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Component', @component_id_landlord, '__create__', NULL, @role_user_g_description_landlord, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Component', @component_id_agent, '__create__', NULL, @role_user_g_description_agent, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Component', @component_id_contractor, '__create__', NULL, @role_user_g_description_contractor, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Component', @component_id_mgt_cny, '__create__', NULL, @role_user_g_description_mgt_cny, @timestamp)
					;
				
		#We now assign the permissions to the user associated to this role:		
			
			#We use a temporary table to make sure we do not have duplicates.
				
				#DELETE the temp table if it exists
				DROP TABLE IF EXISTS `ut_user_group_map_temp`;
				
				#Re-create the temp table
				CREATE TABLE `ut_user_group_map_temp` (
				  `user_id` MEDIUMINT(9) NOT NULL,
				  `group_id` MEDIUMINT(9) NOT NULL,
				  `isbless` TINYINT(4) NOT NULL DEFAULT '0',
				  `grant_type` TINYINT(4) NOT NULL DEFAULT '0'
				) ENGINE=INNODB DEFAULT CHARSET=utf8;

				#Add the records that exist in the table user_group_map
				INSERT INTO `ut_user_group_map_temp`
					SELECT *
					FROM `user_group_map`;

		#We create the permissions for the dummy user to create a case for this unit.		
			#- can tag comments: ALL user need that	
			#- can_create_new_cases
			#- can_edit_a_case
		#This is the only permission that the dummy user will have.

			#First the global permissions:
				#Can tag comments
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id_dummy_tenant,@can_tag_comment_group_id,0,0)
						, (@bz_user_id_dummy_landlord,@can_tag_comment_group_id,0,0)
						, (@bz_user_id_dummy_agent,@can_tag_comment_group_id,0,0)
						, (@bz_user_id_dummy_contractor,@can_tag_comment_group_id,0,0)
						, (@bz_user_id_dummy_mgt_cny,@can_tag_comment_group_id,0,0)
						;
						
					#Log the actions of the script.
						SET @script_log_message = CONCAT('the dummy bz users for each component: '
												, '(#'
												, @bz_user_id_dummy_tenant
												, ', #'
												, @bz_user_id_dummy_landlord
												, ', #'
												, @bz_user_id_dummy_agent
												, ', #'
												, @bz_user_id_dummy_contractor
												, ', #'
												, @bz_user_id_dummy_mgt_cny
												, ')'
												, ' CAN tag comments.'
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							(NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_tenant, @script, 'Add the BZ user id when we grant the permission to tag comments')
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_tag_comment_group_id, @script, 'Add the BZ group id when we grant the permission to tag comments')
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant tag comments permission')
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group tag comments')
							, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_landlord, @script, 'Add the BZ user id when we grant the permission to tag comments')
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_tag_comment_group_id, @script, 'Add the BZ group id when we grant the permission to tag comments')
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant tag comments permission')
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group tag comments')
							, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_agent, @script, 'Add the BZ user id when we grant the permission to tag comments')
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_tag_comment_group_id, @script, 'Add the BZ group id when we grant the permission to tag comments')
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant tag comments permission')
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group tag comments')
							, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_contractor, @script, 'Add the BZ user id when we grant the permission to tag comments')
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_tag_comment_group_id, @script, 'Add the BZ group id when we grant the permission to tag comments')
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant tag comments permission')
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group tag comments')
							, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_mgt_cny, @script, 'Add the BZ user id when we grant the permission to tag comments')
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_tag_comment_group_id, @script, 'Add the BZ group id when we grant the permission to tag comments')
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant tag comments permission')
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group tag comments')
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
			
			#Then the permissions at the unit/product level:
						
				#User can create a case:
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id_dummy_tenant, @create_case_group_id, 0, 0)
						, (@bz_user_id_dummy_landlord, @create_case_group_id, 0, 0)
						, (@bz_user_id_dummy_agent, @create_case_group_id, 0, 0)
						, (@bz_user_id_dummy_contractor, @create_case_group_id, 0, 0)
						, (@bz_user_id_dummy_mgt_cny, @create_case_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the dummy bz users for each component: '
												, '(#'
												, @bz_user_id_dummy_tenant
												, ', #'
												, @bz_user_id_dummy_landlord
												, ', #'
												, @bz_user_id_dummy_agent
												, ', #'
												, @bz_user_id_dummy_contractor
												, ', #'
												, @bz_user_id_dummy_mgt_cny
												, ')'
												, ' CAN create new cases for unit '
												, @product_id
												)
												;
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'create a new case.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							VALUES
							(NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_tenant, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission', 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_landlord, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission', 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_agent, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission', 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_contractor, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_mgt_cny, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;

			# User can Edit a case and see this unit, this is needed so the API does not thrown an error see issue #60:

				INSERT INTO `ut_user_group_map_temp`
					(`user_id`
					,`group_id`
					,`isbless`
					,`grant_type`
					) 
					VALUES 
					(@bz_user_id_dummy_tenant,@can_edit_case_group_id,0,0)
					, (@bz_user_id_dummy_landlord,@can_edit_case_group_id,0,0)
					, (@bz_user_id_dummy_agent,@can_edit_case_group_id,0,0)
					, (@bz_user_id_dummy_contractor,@can_edit_case_group_id,0,0)
					, (@bz_user_id_dummy_mgt_cny,@can_edit_case_group_id,0,0)
					, (@bz_user_id_dummy_tenant,@can_see_unit_in_search_group_id,0,0)
					, (@bz_user_id_dummy_landlord,@can_see_unit_in_search_group_id,0,0)
					, (@bz_user_id_dummy_agent,@can_see_unit_in_search_group_id,0,0)
					, (@bz_user_id_dummy_contractor,@can_see_unit_in_search_group_id,0,0)
					, (@bz_user_id_dummy_mgt_cny,@can_see_unit_in_search_group_id,0,0)
					;

				# Log the actions of the script.
					SET @script_log_message = CONCAT('the dummy bz users for each component: '
											, '(#'
											, @bz_user_id_dummy_tenant
											, ', #'
											, @bz_user_id_dummy_landlord
											, ', #'
											, @bz_user_id_dummy_agent
											, ', #'
											, @bz_user_id_dummy_contractor
											, ', #'
											, @bz_user_id_dummy_mgt_cny
											, ')'
											, ' CAN edit a cases and see the unit '
											, @product_id
											)
											;
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;

				# We log what we have just done into the `ut_audit_log` table
					
					SET @bzfe_table = 'ut_user_group_map_temp';
					SET @permission_granted = 'edit a case and see this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							(NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_tenant, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission', 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_landlord, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission', 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_agent, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission', 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_contractor, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_mgt_cny, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;			
					
		#We give the user the permission they need.
				
			#First the `group_group_map` table
			
				#We truncate the table first (to avoid duplicates)
				TRUNCATE TABLE `group_group_map`;
				
				#We insert the data we need
				#Grouping like this makes sure that we have no dupes!
				INSERT INTO `group_group_map`
				SELECT `member_id`
					, `grantor_id`
					, `grant_type`
				FROM
					`ut_group_group_map_temp`
				GROUP BY `member_id`
					, `grantor_id`
					, `grant_type`
				;

			#Then we update the `user_group_map` table
				
				#We truncate the table first (to avoid duplicates)
					TRUNCATE TABLE `user_group_map`;
					
				#We insert the data we need
					INSERT INTO `user_group_map`
					SELECT `user_id`
						, `group_id`
						, `isbless`
						, `grant_type`
					FROM
						`ut_user_group_map_temp`
					GROUP BY `user_id`
						, `group_id`
						, `isbless`
						, `grant_type`
					;

		#Update the table 'ut_data_to_create_units' so that we record that the unit has been created
			UPDATE `ut_data_to_create_units`
			SET 
				`bz_created_date` = @timestamp
				, `comment` = CONCAT ('inserted in BZ with the script \''
						, @script
						, '\'\r\ '
						, IFNULL(`comment`, '')
						)
				, `product_id` = @product_id
			WHERE `id_unit_to_create` = @unit_reference_for_import;


		#Clean up

			#We Delete the temp table as we do not need it anymore
				DROP TABLE IF EXISTS `ut_group_group_map_temp`;
				
			#We Delete the temp table as we do not need it anymore
				DROP TABLE IF EXISTS `ut_user_group_map_temp`;
	
	# Unit 2
		#The unit: What is the id of the unit in the table 'ut_data_to_create_units'
			SET @unit_reference_for_import = 2;

		#Comment out the appropriately depending on which envo you are running this script in.
		#This is needed so that the invitation mechanism works as intended in the MEFE.
				#- Tenant 1
				SET @bz_user_id_dummy_tenant = 4;

				#- Landlord 2
				SET @bz_user_id_dummy_landlord = 3;
				
				#- Contractor 3
				SET @bz_user_id_dummy_contractor = 5;
				
				#- Management company 4
				SET @bz_user_id_dummy_mgt_cny = 6;
				
				#- Agent 5
				SET @bz_user_id_dummy_agent = 2;
			
		#The unit:

			#BZ Classification id for the unit that you want to create (default is 2)
			SET @classification_id = (SELECT `classification_id` FROM `ut_data_to_create_units` WHERE `id_unit_to_create` = @unit_reference_for_import);

			#The name and description
			SET @unit_name = (SELECT `unit_name` FROM `ut_data_to_create_units` WHERE `id_unit_to_create` = @unit_reference_for_import);
			SET @unit_description_details = (SELECT `unit_description_details` FROM `ut_data_to_create_units` WHERE `id_unit_to_create` = @unit_reference_for_import);
			SET @unit_description = @unit_description_details ;
			
			
		#The users associated to this unit.	

			#BZ user id of the user that is creating the unit (default is 1 - Administrator).
			#For LMB migration, we use 2 (support.nobody)
			SET @creator_bz_id = (SELECT `bzfe_creator_user_id` FROM `ut_data_to_create_units` WHERE `id_unit_to_create` = @unit_reference_for_import);
			
		#Other important information that should not change:

			SET @visibility_explanation_1 = 'Visible only to ';
			SET @visibility_explanation_2 = ' for this unit.';

		#The global permission for the application
		#This should not change, it was hard coded when we created Unee-T
			#Can tag comments
				SET @can_tag_comment_group_id = 18;	
			
		#We need to create the component for ALL the roles.
		#We do that using dummy users for all the roles different from the user role.	
				#- agent -> temporary.agent.dev@unee-t.com
				#- landlord  -> temporary.landlord.dev@unee-t.com
				#- Tenant  -> temporary.tenant.dev@unee-t.com
				#- Contractor  -> temporary.contractor.dev@unee-t.com

		#We populate the additional variables that we will need for this script to work

			#For the product
				SET @product_id = ((SELECT MAX(`id`) FROM `products`) + 1);
				
				SET @unit = CONCAT(@unit_name, '-', @product_id);
				
				SET @unit_for_query = REPLACE(@unit,' ','%');
				
				SET @unit_for_flag = REPLACE(@unit_for_query,'%','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'-','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'!','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'@','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'#','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'$','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'%','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'^','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'&','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'*','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'(','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,')','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'+','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'=','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'<','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'>','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,':','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,';','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'"','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,',','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'.','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'?','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'/','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'\\','_');
				
				SET @unit_for_group = REPLACE(@unit_for_flag,'_','-');
				SET @unit_for_group = REPLACE(@unit_for_group,'----','-');
				SET @unit_for_group = REPLACE(@unit_for_group,'---','-');
				SET @unit_for_group = REPLACE(@unit_for_group,'--','-');
				
				SET @default_milestone = '---';

				
		# We will create all component_id for all the components/roles we need

			#For the temporary users:
				#Tenant
					SET @component_id_tenant = ((SELECT MAX(`id`) FROM `components`) + 1);
					SET @role_user_g_description_tenant = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`= 1);
					SET @user_pub_name_tenant = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_tenant);
					SET @role_user_pub_info_tenant = CONCAT(@user_pub_name_tenant
														,' - '
														, 'THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL '
														, @role_user_g_description_tenant
														, ' TO THIS UNIT'
														);
					SET @user_role_desc_tenant = @role_user_pub_info_tenant;

				#Landlord
					SET @component_id_landlord = (@component_id_tenant + 1);
					SET @role_user_g_description_landlord = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`= 2);
					SET @user_pub_name_landlord = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_landlord);
					SET @role_user_pub_info_landlord = CONCAT(@user_pub_name_landlord
														,' - '
														, 'THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL '
														, @role_user_g_description_landlord
														, ' TO THIS UNIT'
														);
					SET @user_role_desc_landlord = @role_user_pub_info_landlord;
				
				#Agent
					SET @component_id_agent = (@component_id_landlord + 1);
					SET @role_user_g_description_agent = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`= 5);
					SET @user_pub_name_agent = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_agent);
					SET @role_user_pub_info_agent = CONCAT(@user_pub_name_agent
														,' - '
														, 'THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL '
														, @role_user_g_description_agent
														, ' TO THIS UNIT'
														);
					SET @user_role_desc_agent = @role_user_pub_info_agent;
				
				#Contractor
					SET @component_id_contractor = (@component_id_agent + 1);
					SET @role_user_g_description_contractor = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`= 3);
					SET @user_pub_name_contractor = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_contractor);
					SET @role_user_pub_info_contractor = CONCAT(@user_pub_name_contractor
														,' - '
														, 'THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL '
														, @role_user_g_description_contractor
														, ' TO THIS UNIT'
														);
					SET @user_role_desc_contractor = @role_user_pub_info_contractor;
				
				#Management Company
					SET @component_id_mgt_cny = (@component_id_contractor + 1);
					SET @role_user_g_description_mgt_cny = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`= 4);
					SET @user_pub_name_mgt_cny = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_mgt_cny);
					SET @role_user_pub_info_mgt_cny = CONCAT(@user_pub_name_mgt_cny
														,' - '
														, 'THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL '
														, @role_user_g_description_mgt_cny
														, ' TO THIS UNIT'
														);
					SET @user_role_desc_mgt_cny = @role_user_pub_info_mgt_cny;

		#We now create the unit we need.
			INSERT INTO `products`
				(`id`
				,`name`
				,`classification_id`
				,`description`
				,`isactive`
				,`defaultmilestone`
				,`allows_unconfirmed`
				)
				VALUES
				(@product_id,@unit,@classification_id,@unit_description,1,@default_milestone,1);

			#Log the actions of the script.
				SET @script_log_message = CONCAT('A new unit #'
										, (SELECT IFNULL(@product_id, 'product_id is NULL'))
										, ' ('
										, (SELECT IFNULL(@unit, 'unit is NULL'))
										, ') '
										, ' has been created in the classification: '
										, (SELECT IFNULL(@classification_id, 'classification_id is NULL'))
										, '\r\The bz user #'
										, (SELECT IFNULL(@creator_bz_id, 'creator_bz_id is NULL'))
										, ' (real name: '
										, (SELECT IFNULL(@creator_pub_name, 'creator_pub_name is NULL'))
										, ') '
										, 'is the CREATOR of that unit.'
										)
										;
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(@timestamp, @script, @script_log_message)
					;
				
				SET @script_log_message = NULL;			

			INSERT INTO `milestones`
				(`id`
				,`product_id`
				,`value`
				,`sortkey`
				,`isactive`
				)
				VALUES
				(NULL,@product_id,@default_milestone,0,1);
			
			INSERT INTO `versions`
				(`id`
				,`value`
				,`product_id`
				,`isactive`
				)
				VALUES
				(NULL,@default_milestone,@product_id,1);		
					
		#We create the goups we need
			#For simplicity reason, it is better to create ALL the groups we need for all the possible roles and permissions
			#This will avoid a scenario where we need to grant permission to see occupants for instances but the group for occupants does not exist yet...
			
			#Groups common to all components/roles for this unit
				#Allow user to create a case for this unit
					SET @create_case_group_id = ((SELECT MAX(`id`) FROM `groups`) + 1);
					SET @group_name_create_case_group = (CONCAT(@unit_for_group,'-01-Can-Create-Cases'));
					SET @group_description_create_case_group = 'User can create cases for this unit.';
					
				#Allow user to create a case for this unit
					SET @can_edit_case_group_id = (@create_case_group_id + 1);
					SET @group_name_can_edit_case_group = (CONCAT(@unit_for_group,'-01-Can-Edit-Cases'));
					SET @group_description_can_edit_case_group = 'User can edit a case they have access to';
					
				#Allow user to see the cases for this unit
					SET @can_see_cases_group_id = (@can_edit_case_group_id + 1);
					SET @group_name_can_see_cases_group = (CONCAT(@unit_for_group,'-02-Case-Is-Visible-To-All'));
					SET @group_description_can_see_cases_group = 'User can see the public cases for the unit';
					
				#Allow user to edit all fields in the case for this unit regardless of his/her role
					SET @can_edit_all_field_case_group_id = (@can_see_cases_group_id + 1);
					SET @group_name_can_edit_all_field_case_group = (CONCAT(@unit_for_group,'-03-Can-Always-Edit-all-Fields'));
					SET @group_description_can_edit_all_field_case_group = 'Triage - User can edit all fields in a case they have access to, regardless of role';
					
				#Allow user to edit all the fields in a case, regardless of user role for this unit
					SET @can_edit_component_group_id = (@can_edit_all_field_case_group_id + 1);
					SET @group_name_can_edit_component_group = (CONCAT(@unit_for_group,'-04-Can-Edit-Components'));
					SET @group_description_can_edit_component_group = 'User can edit components/roles for the unit';
					
				#Allow user to see the unit in the search
					SET @can_see_unit_in_search_group_id = (@can_edit_component_group_id + 1);
					SET @group_name_can_see_unit_in_search_group = (CONCAT(@unit_for_group,'-00-Can-See-Unit-In-Search'));
					SET @group_description_can_see_unit_in_search_group = 'User can see the unit in the search panel';
					
			#The groups related to Flags
				#Allow user to  for this unit
					SET @all_g_flags_group_id = (@can_see_unit_in_search_group_id + 1);
					SET @group_name_all_g_flags_group = (CONCAT(@unit_for_group,'-05-Can-Approve-All-Flags'));
					SET @group_description_all_g_flags_group = 'User can approve all flags';
					
				#Allow user to  for this unit
					SET @all_r_flags_group_id = (@all_g_flags_group_id + 1);
					SET @group_name_all_r_flags_group = (CONCAT(@unit_for_group,'-05-Can-Request-All-Flags'));
					SET @group_description_all_r_flags_group = 'User can request a Flag to be approved';
					
				
			#The Groups that control user visibility
				#Allow user to  for this unit
					SET @list_visible_assignees_group_id = (@all_r_flags_group_id + 1);
					SET @group_name_list_visible_assignees_group = (CONCAT(@unit_for_group,'-06-List-Public-Assignee'));
					SET @group_description_list_visible_assignees_group = 'User are visible assignee(s) for this unit';
					
				#Allow user to  for this unit
					SET @see_visible_assignees_group_id = (@list_visible_assignees_group_id + 1);
					SET @group_name_see_visible_assignees_group = (CONCAT(@unit_for_group,'-06-Can-See-Public-Assignee'));
					SET @group_description_see_visible_assignees_group = 'User can see all visible assignee(s) for this unit';
					
			#Other Misc Groups
				#Allow user to  for this unit
					SET @active_stakeholder_group_id = (@see_visible_assignees_group_id + 1);
					SET @group_name_active_stakeholder_group = (CONCAT(@unit_for_group,'-07-Active-Stakeholder'));
					SET @group_description_active_stakeholder_group = 'Users who have a role in this unit as of today (WIP)';
					
				#Allow user to  for this unit
					SET @unit_creator_group_id = (@active_stakeholder_group_id + 1);
					SET @group_name_unit_creator_group = (CONCAT(@unit_for_group,'-07-Unit-Creator'));
					SET @group_description_unit_creator_group = 'User is considered to be the creator of the unit';
					
			#Groups associated to the components/roles
				#For the tenant
					#Visibility group
					SET @group_id_show_to_tenant = (@unit_creator_group_id + 1);
					SET @group_name_show_to_tenant = (CONCAT(@unit_for_group,'-02-Limit-to-Tenant'));
					SET @group_description_tenant = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 1),@visibility_explanation_2));
				
					#Is in tenant user Group
					SET @group_id_are_users_tenant = (@group_id_show_to_tenant + 1);
					SET @group_name_are_users_tenant = (CONCAT(@unit_for_group,'-06-List-Tenant'));
					SET @group_description_are_users_tenant = (CONCAT('list the tenant(s)', @unit));
					
					#Can See tenant user Group
					SET @group_id_see_users_tenant = (@group_id_are_users_tenant + 1);
					SET @group_name_see_users_tenant = (CONCAT(@unit_for_group,'-06-Can-see-Tenant'));
					SET @group_description_see_users_tenant = (CONCAT('See the list of tenant(s) for ', @unit));
			
				#For the Landlord
					#Visibility group 
					SET @group_id_show_to_landlord = (@group_id_see_users_tenant + 1);
					SET @group_name_show_to_landlord = (CONCAT(@unit_for_group,'-02-Limit-to-Landlord'));
					SET @group_description_show_to_landlord = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 2),@visibility_explanation_2));
					
					#Is in landlord user Group
					SET @group_id_are_users_landlord = (@group_id_show_to_landlord + 1);
					SET @group_name_are_users_landlord = (CONCAT(@unit_for_group,'-06-List-landlord'));
					SET @group_description_are_users_landlord = (CONCAT('list the landlord(s)', @unit));
					
					#Can See landlord user Group
					SET @group_id_see_users_landlord = (@group_id_are_users_landlord + 1);
					SET @group_name_see_users_landlord = (CONCAT(@unit_for_group,'-06-Can-see-lanldord'));
					SET @group_description_see_users_landlord = (CONCAT('See the list of lanldord(s) for ', @unit));
					
				#For the agent
					#Visibility group 
					SET @group_id_show_to_agent = (@group_id_see_users_landlord + 1);
					SET @group_name_show_to_agent = (CONCAT(@unit_for_group,'-02-Limit-to-Agent'));
					SET @group_description_show_to_agent = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 5),@visibility_explanation_2));
					
					#Is in Agent user Group
					SET @group_id_are_users_agent = (@group_id_show_to_agent + 1);
					SET @group_name_are_users_agent = (CONCAT(@unit_for_group,'-06-List-agent'));
					SET @group_description_are_users_agent = (CONCAT('list the agent(s)', @unit));
					
					#Can See Agent user Group
					SET @group_id_see_users_agent = (@group_id_are_users_agent + 1);
					SET @group_name_see_users_agent = (CONCAT(@unit_for_group,'-06-Can-see-agent'));
					SET @group_description_see_users_agent = (CONCAT('See the list of agent(s) for ', @unit));
				
				#For the contractor
					#Visibility group 
					SET @group_id_show_to_contractor = (@group_id_see_users_agent + 1);
					SET @group_name_show_to_contractor = (CONCAT(@unit_for_group,'-02-Limit-to-Contractor-Employee'));
					SET @group_description_show_to_contractor = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 3),@visibility_explanation_2));
					
					#Is in contractor user Group
					SET @group_id_are_users_contractor = (@group_id_show_to_contractor + 1);
					SET @group_name_are_users_contractor = (CONCAT(@unit_for_group,'-06-List-contractor-employee'));
					SET @group_description_are_users_contractor = (CONCAT('list the contractor employee(s)', @unit));
					
					#Can See contractor user Group
					SET @group_id_see_users_contractor = (@group_id_are_users_contractor + 1);
					SET @group_name_see_users_contractor = (CONCAT(@unit_for_group,'-06-Can-see-contractor-employee'));
					SET @group_description_see_users_contractor = (CONCAT('See the list of contractor employee(s) for ', @unit));
					
				#For the Mgt Cny
					#Visibility group
					SET @group_id_show_to_mgt_cny = (@group_id_see_users_contractor + 1);
					SET @group_name_show_to_mgt_cny = (CONCAT(@unit_for_group,'-02-Limit-to-Mgt-Cny-Employee'));
					SET @group_description_show_to_mgt_cny = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 4),@visibility_explanation_2));
					
					#Is in mgt cny user Group
					SET @group_id_are_users_mgt_cny = (@group_id_show_to_mgt_cny + 1);
					SET @group_name_are_users_mgt_cny = (CONCAT(@unit_for_group,'-06-List-Mgt-Cny-Employee'));
					SET @group_description_are_users_mgt_cny = (CONCAT('list the Mgt Cny Employee(s)', @unit));
					
					#Can See mgt cny user Group
					SET @group_id_see_users_mgt_cny = (@group_id_are_users_mgt_cny + 1);
					SET @group_name_see_users_mgt_cny = (CONCAT(@unit_for_group,'-06-Can-see-Mgt-Cny-Employee'));
					SET @group_description_see_users_mgt_cny = (CONCAT('See the list of Mgt Cny Employee(s) for ', @unit));
				
				#For the occupant
					#Visibility group
					SET @group_id_show_to_occupant = (@group_id_see_users_mgt_cny + 1);
					SET @group_name_show_to_occupant = (CONCAT(@unit_for_group,'-02-Limit-to-occupant'));
					SET @group_description_show_to_occupant = (CONCAT(@visibility_explanation_1,'Occupants'));
					
					#Is in occupant user Group
					SET @group_id_are_users_occupant = (@group_id_show_to_occupant + 1);
					SET @group_name_are_users_occupant = (CONCAT(@unit_for_group,'-06-List-occupant'));
					SET @group_description_are_users_occupant = (CONCAT('list-the-occupant(s)-', @unit));
					
					#Can See occupant user Group
					SET @group_id_see_users_occupant = (@group_id_are_users_occupant + 1);
					SET @group_name_see_users_occupant = (CONCAT(@unit_for_group,'-06-Can-see-occupant'));
					SET @group_description_see_users_occupant = (CONCAT('See the list of occupant(s) for ', @unit));
					
				#For the people invited by this user:
					#Is in invited_by user Group
					SET @group_id_are_users_invited_by = (@group_id_see_users_occupant + 1);
					SET @group_name_are_users_invited_by = (CONCAT(@unit_for_group,'-06-List-invited-by'));
					SET @group_description_are_users_invited_by = (CONCAT('list the invited_by(s)', @unit));
					
					#Can See users in invited_by user Group
					SET @group_id_see_users_invited_by = (@group_id_are_users_invited_by + 1);
					SET @group_name_see_users_invited_by = (CONCAT(@unit_for_group,'-06-Can-see-invited-by'));
					SET @group_description_see_users_invited_by = (CONCAT('See the list of invited_by(s) for ', @unit));

			#We can populate the 'groups' table now.
				INSERT INTO `groups`
					(`id`
					,`name`
					,`description`
					,`isbuggroup`
					,`userregexp`
					,`isactive`
					,`icon_url`
					) 
					VALUES 
					(@create_case_group_id,@group_name_create_case_group,@group_description_create_case_group,1,'',1,NULL)
					,(@can_edit_case_group_id,@group_name_can_edit_case_group,@group_description_can_edit_case_group,1,'',1,NULL)
					,(@can_see_cases_group_id,@group_name_can_see_cases_group,@group_description_can_see_cases_group,1,'',1,NULL)
					,(@can_edit_all_field_case_group_id,@group_name_can_edit_all_field_case_group,@group_description_can_edit_all_field_case_group,1,'',1,NULL)
					,(@can_edit_component_group_id,@group_name_can_edit_component_group,@group_description_can_edit_component_group,1,'',1,NULL)
					,(@can_see_unit_in_search_group_id,@group_name_can_see_unit_in_search_group,@group_description_can_see_unit_in_search_group,1,'',1,NULL)
					,(@all_g_flags_group_id,@group_name_all_g_flags_group,@group_description_all_g_flags_group,1,'',0,NULL)
					,(@all_r_flags_group_id,@group_name_all_r_flags_group,@group_description_all_r_flags_group,1,'',0,NULL)
					,(@list_visible_assignees_group_id,@group_name_list_visible_assignees_group,@group_description_list_visible_assignees_group,1,'',0,NULL)
					,(@see_visible_assignees_group_id,@group_name_see_visible_assignees_group,@group_description_see_visible_assignees_group,1,'',0,NULL)
					,(@active_stakeholder_group_id,@group_name_active_stakeholder_group,@group_description_active_stakeholder_group,1,'',1,NULL)
					,(@unit_creator_group_id,@group_name_unit_creator_group,@group_description_unit_creator_group,1,'',0,NULL)
					,(@group_id_show_to_tenant,@group_name_show_to_tenant,@group_description_tenant,1,'',1,NULL)
					,(@group_id_are_users_tenant,@group_name_are_users_tenant,@group_description_are_users_tenant,1,'',0,NULL)
					,(@group_id_see_users_tenant,@group_name_see_users_tenant,@group_description_see_users_tenant,1,'',0,NULL)
					,(@group_id_show_to_landlord,@group_name_show_to_landlord,@group_description_show_to_landlord,1,'',1,NULL)
					,(@group_id_are_users_landlord,@group_name_are_users_landlord,@group_description_are_users_landlord,1,'',0,NULL)
					,(@group_id_see_users_landlord,@group_name_see_users_landlord,@group_description_see_users_landlord,1,'',0,NULL)
					,(@group_id_show_to_agent,@group_name_show_to_agent,@group_description_show_to_agent,1,'',1,NULL)
					,(@group_id_are_users_agent,@group_name_are_users_agent,@group_description_are_users_agent,1,'',0,NULL)
					,(@group_id_see_users_agent,@group_name_see_users_agent,@group_description_see_users_agent,1,'',0,NULL)
					,(@group_id_show_to_contractor,@group_name_show_to_contractor,@group_description_show_to_contractor,1,'',1,NULL)
					,(@group_id_are_users_contractor,@group_name_are_users_contractor,@group_description_are_users_contractor,1,'',0,NULL)
					,(@group_id_see_users_contractor,@group_name_see_users_contractor,@group_description_see_users_contractor,1,'',0,NULL)
					,(@group_id_show_to_mgt_cny,@group_name_show_to_mgt_cny,@group_description_show_to_mgt_cny,1,'',1,NULL)
					,(@group_id_are_users_mgt_cny,@group_name_are_users_mgt_cny,@group_description_are_users_mgt_cny,1,'',0,NULL)
					,(@group_id_see_users_mgt_cny,@group_name_see_users_mgt_cny,@group_description_see_users_mgt_cny,1,'',0,NULL)
					,(@group_id_show_to_occupant,@group_name_show_to_occupant,@group_description_show_to_occupant,1,'',1,NULL)
					,(@group_id_are_users_occupant,@group_name_are_users_occupant,@group_description_are_users_occupant,1,'',0,NULL)
					,(@group_id_see_users_occupant,@group_name_see_users_occupant,@group_description_see_users_occupant,1,'',0,NULL)
					,(@group_id_are_users_invited_by,@group_name_are_users_invited_by,@group_description_are_users_invited_by,1,'',0,NULL)
					,(@group_id_see_users_invited_by,@group_name_see_users_invited_by,@group_description_see_users_invited_by,1,'',0,NULL)
					;

			#Log the actions of the script.
				SET @script_log_message = CONCAT('We have created the groups that we will need for that unit #'
										, @product_id
										, '\r\ - To grant '
										, 'case creation'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@create_case_group_id, 'create_case_group_id is NULL'))
										, '\r\ - To grant '
										, 'Edit case'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@can_edit_case_group_id, 'can_edit_case_group_id is NULL'))
										, '\r\ - To grant '
										, 'Edit all field regardless of role'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@can_edit_all_field_case_group_id, 'can_edit_all_field_case_group_id is NULL'))
										, '\r\ - To grant '
										, 'Edit Component/roles'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@can_edit_component_group_id, 'can_edit_component_group_id is NULL'))
										, '\r\ - To grant '
										, 'See unit in the Search panel'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@can_see_unit_in_search_group_id, 'can_see_unit_in_search_group_id is NULL'))
										, '\r\ - To grant '
										, 'See cases'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@can_see_cases_group_id, 'can_see_cases_group_id is NULL'))
										, '\r\ - To grant '
										, 'Request all flags'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@all_r_flags_group_id, 'all_r_flags_group_id is NULL'))
										, '\r\ - To grant '
										, 'Approve all flags'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@all_g_flags_group_id, 'all_g_flags_group_id is NULL'))
										, '\r\ - To grant '
										, 'User is publicly visible'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@list_visible_assignees_group_id, 'list_visible_assignees_group_id is NULL'))
										, '\r\ - To grant '
										, 'User can see publicly visible'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@see_visible_assignees_group_id, 'see_visible_assignees_group_id is NULL'))
										, '\r\ - To grant '
										, 'User is active Stakeholder'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@active_stakeholder_group_id, 'active_stakeholder_group_id is NULL'))
										, '\r\ - To grant '
										, 'User is the unit creator'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@unit_creator_group_id, 'unit_creator_group_id is NULL'))
										, '\r\ - Restrict permission to '
										, 'tenant'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_show_to_tenant, 'group_id_show_to_tenant is NULL'))
										, '\r\ - Group for the '
										, 'tenant'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_are_users_tenant, 'group_id_are_users_tenant is NULL'))
										, '\r\ - Group to see the users '
										, 'tenant'
										, '. Group_id: '
										, (SELECT IFNULL(@group_id_see_users_tenant, 'group_id_see_users_tenant is NULL'))
										
										, '\r\ - Restrict permission to '
										, 'landlord'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_show_to_landlord, 'group_id_show_to_landlord is NULL'))
										, '\r\ - Group for the '
										, 'landlord'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_are_users_landlord, 'group_id_are_users_landlord is NULL'))
										, '\r\ - Group to see the users'
										, 'landlord'
										, '. Group_id: '
										, (SELECT IFNULL(@group_id_see_users_landlord, 'group_id_see_users_landlord is NULL'))
										
										, '\r\ - Restrict permission to '
										, 'agent'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_show_to_agent, 'group_id_show_to_agent is NULL'))
										, '\r\ - Group for the '
										, 'agent'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_are_users_agent, 'group_id_are_users_agent is NULL'))
										, '\r\ - Group to see the users'
										, 'agent'
										, '. Group_id: '
										, (SELECT IFNULL(@group_id_see_users_agent, 'group_id_see_users_agent is NULL'))
										
										, '\r\ - Restrict permission to '
										, 'Contractor'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_show_to_contractor, 'group_id_show_to_contractor is NULL'))
										, '\r\ - Group for the '
										, 'Contractor'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_are_users_contractor, 'group_id_are_users_contractor is NULL'))
										, '\r\ - Group to see the users'
										, 'Contractor'
										, '. Group_id: '
										, (SELECT IFNULL(@group_id_see_users_contractor, 'group_id_see_users_contractor is NULL'))
										
										, '\r\ - Restrict permission to '
										, 'Management Company'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_show_to_mgt_cny, 'group_id_show_to_mgt_cny is NULL'))
										, '\r\ - Group for the users in the '
										, 'Management Company'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_are_users_mgt_cny, 'group_id_are_users_mgt_cny is NULL'))
										, '\r\ - Group to see the users in the '
										, 'Management Company'
										, '. Group_id: '
										, (SELECT IFNULL(@group_id_see_users_mgt_cny, 'group_id_see_users_mgt_cny is NULL'))
										
										, '\r\ - Restrict permission to '
										, 'occupant'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_show_to_occupant, 'group_id_show_to_occupant is NULL'))
										, '\r\ - Group for the '
										, 'occupant'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_are_users_occupant, 'group_id_are_users_occupant is NULL'))
										, '\r\ - Group to see the users '
										, 'occupant'
										, '. Group_id: '
										, (SELECT IFNULL(@group_id_see_users_occupant, 'group_id_see_users_occupant is NULL'))
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(@timestamp, @script, @script_log_message)
					;
				
				SET @script_log_message = NULL;				
					
		#We record the groups we have just created:
			#We NEED the component_id for that

			INSERT INTO `ut_product_group`
				(
				product_id
				,component_id
				,group_id
				,group_type_id
				,role_type_id
				,created_by_id
				,created
				)
				VALUES
				(@product_id,NULL,@create_case_group_id,20,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@can_edit_case_group_id,25,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@can_edit_all_field_case_group_id,26,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@can_edit_component_group_id,27,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@can_see_cases_group_id,28,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@can_see_unit_in_search_group_id,38,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@all_r_flags_group_id,18,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@all_g_flags_group_id,19,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@list_visible_assignees_group_id,4,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@see_visible_assignees_group_id,5,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@active_stakeholder_group_id,29,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@unit_creator_group_id,1,NULL,@creator_bz_id,@timestamp)
				, # Tenant (1)
				(@product_id,@component_id_tenant,@group_id_show_to_tenant,2,1,@creator_bz_id,@timestamp)
				,(@product_id,@component_id_tenant,@group_id_are_users_tenant,22,1,@creator_bz_id,@timestamp)
				,(@product_id,@component_id_tenant,@group_id_see_users_tenant,37,1,@creator_bz_id,@timestamp)
				#Landlord (2)
				,(@product_id,@component_id_landlord,@group_id_show_to_landlord,2,2,@creator_bz_id,@timestamp)
				,(@product_id,@component_id_landlord,@group_id_are_users_landlord,22,2,@creator_bz_id,@timestamp)
				,(@product_id,@component_id_landlord,@group_id_see_users_landlord,37,2,@creator_bz_id,@timestamp)
				#Agent (5)
				,(@product_id,@component_id_agent,@group_id_show_to_agent,2,5,@creator_bz_id,@timestamp)
				,(@product_id,@component_id_agent,@group_id_are_users_agent,22,5,@creator_bz_id,@timestamp)
				,(@product_id,@component_id_agent,@group_id_see_users_agent,37,5,@creator_bz_id,@timestamp)
				#contractor (3)
				,(@product_id,@component_id_contractor,@group_id_show_to_contractor,2,3,@creator_bz_id,@timestamp)
				,(@product_id,@component_id_contractor,@group_id_are_users_contractor,22,3,@creator_bz_id,@timestamp)
				,(@product_id,@component_id_contractor,@group_id_see_users_contractor,37,3,@creator_bz_id,@timestamp)
				#mgt_cny (4)
				,(@product_id,@component_id_mgt_cny,@group_id_show_to_mgt_cny,2,4,@creator_bz_id,@timestamp)
				,(@product_id,@component_id_mgt_cny,@group_id_are_users_mgt_cny,22,4,@creator_bz_id,@timestamp)
				,(@product_id,@component_id_mgt_cny,@group_id_see_users_mgt_cny,37,4,@creator_bz_id,@timestamp)
				#occupant (#)
				,(@product_id,NULL,@group_id_show_to_occupant,24,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@group_id_are_users_occupant,3,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@group_id_see_users_occupant,36,NULL,@creator_bz_id,@timestamp)
				#invited_by
				,(@product_id,NULL,@group_id_are_users_invited_by,31,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@group_id_see_users_invited_by,32,NULL,@creator_bz_id,@timestamp)
				;

		#We now Create the flagtypes and flags for this new unit (we NEEDED the group ids for that!):
			SET @flag_next_step = ((SELECT MAX(`id`) FROM `flagtypes`) + 1);
			SET @flag_solution = (@flag_next_step + 1);
			SET @flag_budget = (@flag_solution + 1);
			SET @flag_attachment = (@flag_budget + 1);
			SET @flag_ok_to_pay = (@flag_attachment + 1);
			SET @flag_is_paid = (@flag_ok_to_pay + 1);

			INSERT INTO `flagtypes`
				(`id`
				,`name`
				,`description`
				,`cc_list`
				,`target_type`
				,`is_active`
				,`is_requestable`
				,`is_requesteeble`
				,`is_multiplicable`
				,`sortkey`
				,`grant_group_id`
				,`request_group_id`
				) 
				VALUES 
				(@flag_next_step,CONCAT('Next_Step_',@unit_for_flag),'Approval for the Next Step of the case.','','b',1,1,1,1,10,@all_g_flags_group_id,@all_r_flags_group_id)
				,(@flag_solution,CONCAT('Solution_',@unit_for_flag),'Approval for the Solution of this case.','','b',1,1,1,1,20,@all_g_flags_group_id,@all_r_flags_group_id)
				,(@flag_budget,CONCAT('Budget_',@unit_for_flag),'Approval for the Budget for this case.','','b',1,1,1,1,30,@all_g_flags_group_id,@all_r_flags_group_id)
				,(@flag_attachment,CONCAT('Attachment_',@unit_for_flag),'Approval for this Attachment.','','a',1,1,1,1,10,@all_g_flags_group_id,@all_r_flags_group_id)
				,(@flag_ok_to_pay,CONCAT('OK_to_pay_',@unit_for_flag),'Approval to pay this bill.','','a',1,1,1,1,20,@all_g_flags_group_id,@all_r_flags_group_id)
				,(@flag_is_paid,CONCAT('is_paid_',@unit_for_flag),'Confirm if this bill has been paid.','','a',1,1,1,1,30,@all_g_flags_group_id,@all_r_flags_group_id)
				;
			
			INSERT INTO `flaginclusions`
				(`type_id`
				,`product_id`
				,`component_id`
				) 
				VALUES
				(@flag_next_step,@product_id,NULL)
				,(@flag_solution,@product_id,NULL)
				,(@flag_budget,@product_id,NULL)
				,(@flag_attachment,@product_id,NULL)
				,(@flag_ok_to_pay,@product_id,NULL)
				,(@flag_is_paid,@product_id,NULL)
				;

			#Log the actions of the script.
				SET @script_log_message = CONCAT('We have created the following flags which are restricted to that unit: '
										, '\r\ - Next Step (#'
										, (SELECT IFNULL(@flag_next_step, 'flag_next_step is NULL'))
										, ').'
										, '\r\ - Solution (#'
										, (SELECT IFNULL(@flag_solution, 'flag_solution is NULL'))
										, ').'
										, '\r\ - Budget (#'
										, (SELECT IFNULL(@flag_budget, 'flag_budget is NULL'))
										, ').'
										, '\r\ - Attachment (#'
										, (SELECT IFNULL(@flag_attachment, 'flag_attachment is NULL'))
										, ').'
										, '\r\ - OK to pay (#'
										, (SELECT IFNULL(@flag_ok_to_pay, 'flag_ok_to_pay is NULL'))
										, ').'
										, '\r\ - Is paid (#'
										, (SELECT IFNULL(@flag_is_paid, 'flag_is_paid is NULL'))
										, ').'
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(@timestamp, @script, @script_log_message)
					;
				
				SET @script_log_message = NULL;	
				
		#We configure the group permissions:
			#Data for the table `group_group_map`
			#We use a temporary table to do this, this is to avoid duplicate in the group_group_map table

			#DELETE the temp table if it exists
			DROP TABLE IF EXISTS `ut_group_group_map_temp`;
			
			#Re-create the temp table
			CREATE TABLE `ut_group_group_map_temp` (
			  `member_id` MEDIUMINT(9) NOT NULL,
			  `grantor_id` MEDIUMINT(9) NOT NULL,
			  `grant_type` TINYINT(4) NOT NULL DEFAULT 0
			) ENGINE=INNODB DEFAULT CHARSET=utf8;

			#Add the records that exist in the table group_group_map
			INSERT INTO `ut_group_group_map_temp`
				SELECT *
				FROM `group_group_map`;
			
			
			#Add the new records
			INSERT INTO `ut_group_group_map_temp`
				(`member_id`
				,`grantor_id`
				,`grant_type`
				) 
			##########################################################
			#Logic:
			#If you are a member of group_id XXX (ex: 1 / Admin) 
			#then you have the following permissions:
				#- 0: You are automatically a member of group ZZZ
				#- 1: You can grant access to group ZZZ
				#- 2: You can see users in group ZZZ
			##########################################################
				VALUES 
				#Admin group can grant membership to all
				(1,@create_case_group_id,1)
				,(1,@can_edit_case_group_id,1)
				,(1,@can_see_cases_group_id,1)
				,(1,@can_edit_all_field_case_group_id,1)
				,(1,@can_edit_component_group_id,1)
				,(1,@can_see_unit_in_search_group_id,1)
				,(1,@all_g_flags_group_id,1)
				,(1,@all_r_flags_group_id,1)
				,(1,@list_visible_assignees_group_id,1)
				,(1,@see_visible_assignees_group_id,1)
				,(1,@active_stakeholder_group_id,1)
				,(1,@unit_creator_group_id,1)
				,(1,@group_id_show_to_tenant,1)
				,(1,@group_id_are_users_tenant,1)
				,(1,@group_id_see_users_tenant,1)
				,(1,@group_id_show_to_landlord,1)
				,(1,@group_id_are_users_landlord,1)
				,(1,@group_id_see_users_landlord,1)
				,(1,@group_id_show_to_agent,1)
				,(1,@group_id_are_users_agent,1)
				,(1,@group_id_see_users_agent,1)
				,(1,@group_id_show_to_contractor,1)
				,(1,@group_id_are_users_contractor,1)
				,(1,@group_id_see_users_contractor,1)
				,(1,@group_id_show_to_mgt_cny,1)
				,(1,@group_id_are_users_mgt_cny,1)
				,(1,@group_id_see_users_mgt_cny,1)
				,(1,@group_id_show_to_occupant,1)
				,(1,@group_id_are_users_occupant,1)
				,(1,@group_id_see_users_occupant,1)
				,(1,@group_id_are_users_invited_by,1)
				,(1,@group_id_see_users_invited_by,1)
				
				#Admin MUST be a member of the mandatory group for this unit
				#If not it is impossible to see this product in the BZFE backend.
				,(1,@can_see_unit_in_search_group_id,0)

				#Visibility groups:
				,(@all_r_flags_group_id,@all_g_flags_group_id,2)
				,(@see_visible_assignees_group_id,@list_visible_assignees_group_id,2)
				,(@unit_creator_group_id,@unit_creator_group_id,2)
				,(@group_id_see_users_tenant,@group_id_are_users_tenant,2)
				,(@group_id_see_users_landlord,@group_id_are_users_landlord,2)
				,(@group_id_see_users_agent,@group_id_are_users_contractor,2)
				,(@group_id_see_users_mgt_cny,@group_id_are_users_mgt_cny,2)
				,(@group_id_see_users_occupant,@group_id_are_users_occupant,2)
				,(@group_id_see_users_invited_by,@group_id_are_users_invited_by,2)
				;

		#We make sure that only user in certain groups can create, edit or see cases.
			INSERT INTO `group_control_map`
				(`group_id`
				,`product_id`
				,`entry`
				,`membercontrol`
				,`othercontrol`
				,`canedit`
				,`editcomponents`
				,`editbugs`
				,`canconfirm`
				) 
				VALUES 
				(@create_case_group_id,@product_id,1,0,0,0,0,0,0)
				,(@can_edit_case_group_id,@product_id,1,0,0,1,0,0,1)
				,(@can_edit_all_field_case_group_id,@product_id,1,0,0,1,0,1,1)
				,(@can_edit_component_group_id,@product_id,0,0,0,0,1,0,0)
				,(@can_see_cases_group_id,@product_id,0,2,0,0,0,0,0)
				,(@can_see_unit_in_search_group_id,@product_id,0,3,3,0,0,0,0)
				,(@group_id_show_to_tenant,@product_id,0,2,0,0,0,0,0)
				,(@group_id_show_to_landlord,@product_id,0,2,0,0,0,0,0)
				,(@group_id_show_to_agent,@product_id,0,2,0,0,0,0,0)
				,(@group_id_show_to_contractor,@product_id,0,2,0,0,0,0,0)
				,(@group_id_show_to_mgt_cny,@product_id,0,2,0,0,0,0,0)
				,(@group_id_show_to_occupant,@product_id,0,2,0,0,0,0,0)
				;

			#Log the actions of the script.
				SET @script_log_message = CONCAT('We have updated the group control permissions for the product# '
										, @product_id
										, ': '
										, '\r\ - Create Case (#'
										, (SELECT IFNULL(@create_case_group_id, 'create_case_group_id is NULL'))
										, ').'
										, '\r\ - Edit Case (#'
										, (SELECT IFNULL(@can_edit_case_group_id, 'can_edit_case_group_id is NULL'))
										, ').'
										, '\r\ - Edit All Field (#'
										, (SELECT IFNULL(@can_edit_all_field_case_group_id, 'can_edit_all_field_case_group_id is NULL'))
										, ').'
										, '\r\ - Edit Component (#'
										, (SELECT IFNULL(@can_edit_component_group_id, 'can_edit_component_group_id is NULL'))
										, ').'
										, '\r\ - Can see case (#'
										, (SELECT IFNULL(@can_see_cases_group_id, 'flag_ok_to_pay is NULL'))
										, ').'
										, '\r\ - Can See unit in Search (#'
										, (SELECT IFNULL(@group_id_show_to_tenant, 'group_id_show_to_tenant is NULL'))
										, ').'
										, '\r\ - Show case to Tenant (#'
										, (SELECT IFNULL(@group_id_show_to_landlord, 'group_id_show_to_landlord is NULL'))
										, ').'
										, '\r\ - Show case to Landlord (#'
										, (SELECT IFNULL(@group_id_show_to_landlord, 'group_id_show_to_landlord is NULL'))
										, ').'
										, '\r\ - Show case to Agent (#'
										, (SELECT IFNULL(@group_id_show_to_agent, 'group_id_show_to_agent is NULL'))
										, ').'
										, '\r\ - Show case to Contractor (#'
										, (SELECT IFNULL(@group_id_show_to_contractor, 'group_id_show_to_contractor is NULL'))
										, ').'
										, '\r\ - Show case to Management Company (#'
										, (SELECT IFNULL(@group_id_show_to_mgt_cny, 'group_id_show_to_mgt_cny is NULL'))
										, ').'
										, '\r\ - Show case to Occupant(s) (#'
										, (SELECT IFNULL(@group_id_show_to_occupant, 'group_id_show_to_occupant is NULL'))
										, ').'
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;
				
				SET @script_log_message = NULL;

			#We have eveything, we can create the components we need:
				INSERT INTO `components`
				(`id`
				,`name`
				,`product_id`
				,`initialowner`
				,`initialqacontact`
				,`description`
				,`isactive`
				) 
				VALUES
				(@component_id_tenant,@role_user_g_description_tenant,@product_id,@bz_user_id_dummy_tenant,@bz_user_id_dummy_tenant,@user_role_desc_tenant,1)
				, (@component_id_landlord, @role_user_g_description_landlord, @product_id, @bz_user_id_dummy_landlord, @bz_user_id_dummy_landlord, @user_role_desc_landlord, 1)
				, (@component_id_agent, @role_user_g_description_agent, @product_id, @bz_user_id_dummy_agent, @bz_user_id_dummy_agent, @user_role_desc_agent, 1)
				, (@component_id_contractor, @role_user_g_description_contractor, @product_id, @bz_user_id_dummy_contractor, @bz_user_id_dummy_contractor, @user_role_desc_contractor, 1)
				, (@component_id_mgt_cny, @role_user_g_description_mgt_cny, @product_id, @bz_user_id_dummy_mgt_cny, @bz_user_id_dummy_mgt_cny, @user_role_desc_mgt_cny, 1)
				;
			

			#Log the actions of the script.
				SET @script_log_message = CONCAT('The role created for that unit with temporary users were:'
										, '\r\- '
										, (SELECT IFNULL(@role_user_g_description_tenant, 'role_user_g_description is NULL'))
										, ' (role_type_id #'
										, '1'
										, ') '
										, '\r\The user associated to this role was bz user #'
										, (SELECT IFNULL(@bz_user_id_dummy_tenant, 'bz_user_id is NULL'))
										, ' (real name: '
										, (SELECT IFNULL(@user_pub_name_tenant, 'user_pub_name is NULL'))
										, '. This user is the default assignee for this role for that unit).' 
										
										, '\r\- '
										, (SELECT IFNULL(@role_user_g_description_landlord, 'role_user_g_description is NULL'))
										, ' (role_type_id #'
										, '2'
										, ') '
										, '\r\The user associated to this role was bz user #'
										, (SELECT IFNULL(@bz_user_id_dummy_landlord, 'bz_user_id is NULL'))
										, ' (real name: '
										, (SELECT IFNULL(@user_pub_name_landlord, 'user_pub_name is NULL'))
										, '. This user is the default assignee for this role for that unit).'
										
										, '\r\- '
										, (SELECT IFNULL(@role_user_g_description_agent, 'role_user_g_description is NULL'))
										, ' (role_type_id #'
										, '5'
										, ') '
										, '\r\The user associated to this role was bz user #'
										, (SELECT IFNULL(@bz_user_id_dummy_agent, 'bz_user_id is NULL'))
										, ' (real name: '
										, (SELECT IFNULL(@user_pub_name_agent, 'user_pub_name is NULL'))
										, '. This user is the default assignee for this role for that unit).'
										
										, '\r\- '
										, (SELECT IFNULL(@role_user_g_description_contractor, 'role_user_g_description is NULL'))
										, ' (role_type_id #'
										, '3'
										, ') '
										, '\r\The user associated to this role was bz user #'
										, (SELECT IFNULL(@bz_user_id_dummy_contractor, 'bz_user_id is NULL'))
										, ' (real name: '
										, (SELECT IFNULL(@user_pub_name_contractor, 'user_pub_name is NULL'))
										, '. This user is the default assignee for this role for that unit).'

										, '\r\- '
										, (SELECT IFNULL(@role_user_g_description_mgt_cny, 'role_user_g_description is NULL'))
										, ' (role_type_id #'
										, '3'
										, ') '
										, '\r\The user associated to this role was bz user #'
										, (SELECT IFNULL(@bz_user_id_dummy_mgt_cny, 'bz_user_id is NULL'))
										, ' (real name: '
										, (SELECT IFNULL(@user_pub_name_mgt_cny, 'user_pub_name is NULL'))
										, '. This user is the default assignee for this role for that unit).'								
										)
										;
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;
				
				SET @script_log_message = NULL;	
					
			#We update the BZ logs
				INSERT INTO `audit_log`
					(`user_id`
					,`class`
					,`object_id`
					,`field`
					,`removed`
					,`added`
					,`at_time`
					) 
					VALUES 
					(@creator_bz_id, 'Bugzilla::Group', @create_case_group_id, '__create__', NULL, @group_name_create_case_group, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @can_edit_case_group_id, '__create__', NULL, @group_name_can_edit_case_group, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @can_edit_all_field_case_group_id, '__create__', NULL, @group_name_can_edit_all_field_case_group, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @can_edit_component_group_id, '__create__', NULL, @group_name_can_edit_component_group, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @can_see_cases_group_id, '__create__', NULL, @group_name_can_see_cases_group, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @can_see_unit_in_search_group_id, '__create__', NULL, @group_name_can_see_unit_in_search_group, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @all_g_flags_group_id, '__create__', NULL, @group_name_all_g_flags_group, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @all_r_flags_group_id, '__create__', NULL, @group_name_all_r_flags_group, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @list_visible_assignees_group_id, '__create__', NULL, @group_name_list_visible_assignees_group, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @see_visible_assignees_group_id, '__create__', NULL, @group_name_see_visible_assignees_group, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @active_stakeholder_group_id, '__create__', NULL, @group_name_active_stakeholder_group, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @unit_creator_group_id, '__create__', NULL, @group_name_unit_creator_group, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_tenant, '__create__', NULL, @group_name_show_to_tenant, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_tenant, '__create__', NULL, @group_name_are_users_tenant, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_tenant, '__create__', NULL, @group_name_see_users_tenant, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_landlord, '__create__', NULL, @group_name_show_to_landlord, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_landlord, '__create__', NULL, @group_name_are_users_landlord, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_landlord, '__create__', NULL, @group_name_see_users_landlord, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_agent, '__create__', NULL, @group_name_show_to_agent, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_agent, '__create__', NULL, @group_name_are_users_agent, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_agent, '__create__', NULL, @group_name_see_users_agent, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_contractor, '__create__', NULL, @group_name_show_to_contractor, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_contractor, '__create__', NULL, @group_name_are_users_contractor, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_contractor, '__create__', NULL, @group_name_see_users_contractor, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_mgt_cny, '__create__', NULL, @group_name_show_to_mgt_cny, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_mgt_cny, '__create__', NULL, @group_name_are_users_mgt_cny, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_mgt_cny, '__create__', NULL, @group_name_see_users_mgt_cny, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_occupant, '__create__', NULL, @group_name_show_to_occupant, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_occupant, '__create__', NULL, @group_name_are_users_occupant, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_occupant, '__create__', NULL, @group_name_see_users_occupant, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_invited_by, '__create__', NULL, @group_name_are_users_invited_by, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_invited_by, '__create__', NULL, @group_name_see_users_invited_by, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Component', @component_id_tenant, '__create__', NULL, @role_user_g_description_tenant, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Component', @component_id_landlord, '__create__', NULL, @role_user_g_description_landlord, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Component', @component_id_agent, '__create__', NULL, @role_user_g_description_agent, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Component', @component_id_contractor, '__create__', NULL, @role_user_g_description_contractor, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Component', @component_id_mgt_cny, '__create__', NULL, @role_user_g_description_mgt_cny, @timestamp)
					;
				
		#We now assign the permissions to the user associated to this role:		
			
			#We use a temporary table to make sure we do not have duplicates.
				
				#DELETE the temp table if it exists
				DROP TABLE IF EXISTS `ut_user_group_map_temp`;
				
				#Re-create the temp table
				CREATE TABLE `ut_user_group_map_temp` (
				  `user_id` MEDIUMINT(9) NOT NULL,
				  `group_id` MEDIUMINT(9) NOT NULL,
				  `isbless` TINYINT(4) NOT NULL DEFAULT '0',
				  `grant_type` TINYINT(4) NOT NULL DEFAULT '0'
				) ENGINE=INNODB DEFAULT CHARSET=utf8;

				#Add the records that exist in the table user_group_map
				INSERT INTO `ut_user_group_map_temp`
					SELECT *
					FROM `user_group_map`;

		#We create the permissions for the dummy user to create a case for this unit.		
			#- can tag comments: ALL user need that	
			#- can_create_new_cases
			#- can_edit_a_case
		#This is the only permission that the dummy user will have.

			#First the global permissions:
				#Can tag comments
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id_dummy_tenant,@can_tag_comment_group_id,0,0)
						, (@bz_user_id_dummy_landlord,@can_tag_comment_group_id,0,0)
						, (@bz_user_id_dummy_agent,@can_tag_comment_group_id,0,0)
						, (@bz_user_id_dummy_contractor,@can_tag_comment_group_id,0,0)
						, (@bz_user_id_dummy_mgt_cny,@can_tag_comment_group_id,0,0)
						;
						
					#Log the actions of the script.
						SET @script_log_message = CONCAT('the dummy bz users for each component: '
												, '(#'
												, @bz_user_id_dummy_tenant
												, ', #'
												, @bz_user_id_dummy_landlord
												, ', #'
												, @bz_user_id_dummy_agent
												, ', #'
												, @bz_user_id_dummy_contractor
												, ', #'
												, @bz_user_id_dummy_mgt_cny
												, ')'
												, ' CAN tag comments.'
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							(NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_tenant, @script, 'Add the BZ user id when we grant the permission to tag comments')
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_tag_comment_group_id, @script, 'Add the BZ group id when we grant the permission to tag comments')
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant tag comments permission')
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group tag comments')
							, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_landlord, @script, 'Add the BZ user id when we grant the permission to tag comments')
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_tag_comment_group_id, @script, 'Add the BZ group id when we grant the permission to tag comments')
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant tag comments permission')
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group tag comments')
							, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_agent, @script, 'Add the BZ user id when we grant the permission to tag comments')
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_tag_comment_group_id, @script, 'Add the BZ group id when we grant the permission to tag comments')
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant tag comments permission')
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group tag comments')
							, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_contractor, @script, 'Add the BZ user id when we grant the permission to tag comments')
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_tag_comment_group_id, @script, 'Add the BZ group id when we grant the permission to tag comments')
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant tag comments permission')
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group tag comments')
							, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_mgt_cny, @script, 'Add the BZ user id when we grant the permission to tag comments')
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_tag_comment_group_id, @script, 'Add the BZ group id when we grant the permission to tag comments')
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant tag comments permission')
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group tag comments')
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
			
			#Then the permissions at the unit/product level:
						
				#User can create a case:
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id_dummy_tenant, @create_case_group_id, 0, 0)
						, (@bz_user_id_dummy_landlord, @create_case_group_id, 0, 0)
						, (@bz_user_id_dummy_agent, @create_case_group_id, 0, 0)
						, (@bz_user_id_dummy_contractor, @create_case_group_id, 0, 0)
						, (@bz_user_id_dummy_mgt_cny, @create_case_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the dummy bz users for each component: '
												, '(#'
												, @bz_user_id_dummy_tenant
												, ', #'
												, @bz_user_id_dummy_landlord
												, ', #'
												, @bz_user_id_dummy_agent
												, ', #'
												, @bz_user_id_dummy_contractor
												, ', #'
												, @bz_user_id_dummy_mgt_cny
												, ')'
												, ' CAN create new cases for unit '
												, @product_id
												)
												;
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'create a new case.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							VALUES
							(NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_tenant, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission', 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_landlord, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission', 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_agent, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission', 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_contractor, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_mgt_cny, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;

			# User can Edit a case and see this unit, this is needed so the API does not thrown an error see issue #60:

				INSERT INTO `ut_user_group_map_temp`
					(`user_id`
					,`group_id`
					,`isbless`
					,`grant_type`
					) 
					VALUES 
					(@bz_user_id_dummy_tenant,@can_edit_case_group_id,0,0)
					, (@bz_user_id_dummy_landlord,@can_edit_case_group_id,0,0)
					, (@bz_user_id_dummy_agent,@can_edit_case_group_id,0,0)
					, (@bz_user_id_dummy_contractor,@can_edit_case_group_id,0,0)
					, (@bz_user_id_dummy_mgt_cny,@can_edit_case_group_id,0,0)
					, (@bz_user_id_dummy_tenant,@can_see_unit_in_search_group_id,0,0)
					, (@bz_user_id_dummy_landlord,@can_see_unit_in_search_group_id,0,0)
					, (@bz_user_id_dummy_agent,@can_see_unit_in_search_group_id,0,0)
					, (@bz_user_id_dummy_contractor,@can_see_unit_in_search_group_id,0,0)
					, (@bz_user_id_dummy_mgt_cny,@can_see_unit_in_search_group_id,0,0)
					;

				# Log the actions of the script.
					SET @script_log_message = CONCAT('the dummy bz users for each component: '
											, '(#'
											, @bz_user_id_dummy_tenant
											, ', #'
											, @bz_user_id_dummy_landlord
											, ', #'
											, @bz_user_id_dummy_agent
											, ', #'
											, @bz_user_id_dummy_contractor
											, ', #'
											, @bz_user_id_dummy_mgt_cny
											, ')'
											, ' CAN edit a cases and see the unit '
											, @product_id
											)
											;
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;

				# We log what we have just done into the `ut_audit_log` table
					
					SET @bzfe_table = 'ut_user_group_map_temp';
					SET @permission_granted = 'edit a case and see this unit.';						

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							(NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_tenant, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission', 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_landlord, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission', 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_agent, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission', 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_contractor, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_mgt_cny, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;			
					
		#We give the user the permission they need.
				
			#First the `group_group_map` table
			
				#We truncate the table first (to avoid duplicates)
				TRUNCATE TABLE `group_group_map`;
				
				#We insert the data we need
				#Grouping like this makes sure that we have no dupes!
				INSERT INTO `group_group_map`
				SELECT `member_id`
					, `grantor_id`
					, `grant_type`
				FROM
					`ut_group_group_map_temp`
				GROUP BY `member_id`
					, `grantor_id`
					, `grant_type`
				;

			#Then we update the `user_group_map` table
				
				#We truncate the table first (to avoid duplicates)
					TRUNCATE TABLE `user_group_map`;
					
				#We insert the data we need
					INSERT INTO `user_group_map`
					SELECT `user_id`
						, `group_id`
						, `isbless`
						, `grant_type`
					FROM
						`ut_user_group_map_temp`
					GROUP BY `user_id`
						, `group_id`
						, `isbless`
						, `grant_type`
					;

		#Update the table 'ut_data_to_create_units' so that we record that the unit has been created
			UPDATE `ut_data_to_create_units`
			SET 
				`bz_created_date` = @timestamp
				, `comment` = CONCAT ('inserted in BZ with the script \''
						, @script
						, '\'\r\ '
						, IFNULL(`comment`, '')
						)
				, `product_id` = @product_id
			WHERE `id_unit_to_create` = @unit_reference_for_import;


		#Clean up

			#We Delete the temp table as we do not need it anymore
				DROP TABLE IF EXISTS `ut_group_group_map_temp`;
				
			#We Delete the temp table as we do not need it anymore
				DROP TABLE IF EXISTS `ut_user_group_map_temp`;

	# Unit 3
		#The unit: What is the id of the unit in the table 'ut_data_to_create_units'
			SET @unit_reference_for_import = 3;

		#Comment out the appropriately depending on which envo you are running this script in.
		#This is needed so that the invitation mechanism works as intended in the MEFE.
				#- Tenant 1
				SET @bz_user_id_dummy_tenant = 4;

				#- Landlord 2
				SET @bz_user_id_dummy_landlord = 3;
				
				#- Contractor 3
				SET @bz_user_id_dummy_contractor = 5;
				
				#- Management company 4
				SET @bz_user_id_dummy_mgt_cny = 6;
				
				#- Agent 5
				SET @bz_user_id_dummy_agent = 2;
			
		#The unit:

			#BZ Classification id for the unit that you want to create (default is 2)
			SET @classification_id = (SELECT `classification_id` FROM `ut_data_to_create_units` WHERE `id_unit_to_create` = @unit_reference_for_import);

			#The name and description
			SET @unit_name = (SELECT `unit_name` FROM `ut_data_to_create_units` WHERE `id_unit_to_create` = @unit_reference_for_import);
			SET @unit_description_details = (SELECT `unit_description_details` FROM `ut_data_to_create_units` WHERE `id_unit_to_create` = @unit_reference_for_import);
			SET @unit_description = @unit_description_details;
			
		#The users associated to this unit.	

			#BZ user id of the user that is creating the unit (default is 1 - Administrator).
			#For LMB migration, we use 2 (support.nobody)
			SET @creator_bz_id = (SELECT `bzfe_creator_user_id` FROM `ut_data_to_create_units` WHERE `id_unit_to_create` = @unit_reference_for_import);
			
		#Other important information that should not change:

			SET @visibility_explanation_1 = 'Visible only to ';
			SET @visibility_explanation_2 = ' for this unit.';

		#The global permission for the application
		#This should not change, it was hard coded when we created Unee-T
			#Can tag comments
				SET @can_tag_comment_group_id = 18;	
			
		#We need to create the component for ALL the roles.
		#We do that using dummy users for all the roles different from the user role.	
				#- agent -> temporary.agent.dev@unee-t.com
				#- landlord  -> temporary.landlord.dev@unee-t.com
				#- Tenant  -> temporary.tenant.dev@unee-t.com
				#- Contractor  -> temporary.contractor.dev@unee-t.com

		#We populate the additional variables that we will need for this script to work

			#For the product
				SET @product_id = ((SELECT MAX(`id`) FROM `products`) + 1);
				
				SET @unit = CONCAT(@unit_name, '-', @product_id);
				
				SET @unit_for_query = REPLACE(@unit,' ','%');
				
				SET @unit_for_flag = REPLACE(@unit_for_query,'%','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'-','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'!','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'@','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'#','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'$','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'%','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'^','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'&','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'*','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'(','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,')','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'+','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'=','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'<','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'>','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,':','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,';','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'"','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,',','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'.','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'?','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'/','_');
				SET @unit_for_flag = REPLACE(@unit_for_flag,'\\','_');
				
				SET @unit_for_group = REPLACE(@unit_for_flag,'_','-');
				SET @unit_for_group = REPLACE(@unit_for_group,'----','-');
				SET @unit_for_group = REPLACE(@unit_for_group,'---','-');
				SET @unit_for_group = REPLACE(@unit_for_group,'--','-');
				
				SET @default_milestone = '---';

				
		# We will create all component_id for all the components/roles we need

			#For the temporary users:
				#Tenant
					SET @component_id_tenant = ((SELECT MAX(`id`) FROM `components`) + 1);
					SET @role_user_g_description_tenant = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`= 1);
					SET @user_pub_name_tenant = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_tenant);
					SET @role_user_pub_info_tenant = CONCAT(@user_pub_name_tenant
														,' - '
														, 'THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL '
														, @role_user_g_description_tenant
														, ' TO THIS UNIT'
														);
					SET @user_role_desc_tenant = @role_user_pub_info_tenant;

				#Landlord
					SET @component_id_landlord = (@component_id_tenant + 1);
					SET @role_user_g_description_landlord = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`= 2);
					SET @user_pub_name_landlord = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_landlord);
					SET @role_user_pub_info_landlord = CONCAT(@user_pub_name_landlord
														,' - '
														, 'THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL '
														, @role_user_g_description_landlord
														, ' TO THIS UNIT'
														);
					SET @user_role_desc_landlord = @role_user_pub_info_landlord;
				
				#Agent
					SET @component_id_agent = (@component_id_landlord + 1);
					SET @role_user_g_description_agent = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`= 5);
					SET @user_pub_name_agent = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_agent);
					SET @role_user_pub_info_agent = CONCAT(@user_pub_name_agent
														,' - '
														, 'THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL '
														, @role_user_g_description_agent
														, ' TO THIS UNIT'
														);
					SET @user_role_desc_agent = @role_user_pub_info_agent;
				
				#Contractor
					SET @component_id_contractor = (@component_id_agent + 1);
					SET @role_user_g_description_contractor = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`= 3);
					SET @user_pub_name_contractor = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_contractor);
					SET @role_user_pub_info_contractor = CONCAT(@user_pub_name_contractor
														,' - '
														, 'THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL '
														, @role_user_g_description_contractor
														, ' TO THIS UNIT'
														);
					SET @user_role_desc_contractor = @role_user_pub_info_contractor;
				
				#Management Company
					SET @component_id_mgt_cny = (@component_id_contractor + 1);
					SET @role_user_g_description_mgt_cny = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`= 4);
					SET @user_pub_name_mgt_cny = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_mgt_cny);
					SET @role_user_pub_info_mgt_cny = CONCAT(@user_pub_name_mgt_cny
														,' - '
														, 'THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL '
														, @role_user_g_description_mgt_cny
														, ' TO THIS UNIT'
														);
					SET @user_role_desc_mgt_cny = @role_user_pub_info_mgt_cny;

		#We now create the unit we need.
			INSERT INTO `products`
				(`id`
				,`name`
				,`classification_id`
				,`description`
				,`isactive`
				,`defaultmilestone`
				,`allows_unconfirmed`
				)
				VALUES
				(@product_id,@unit,@classification_id,@unit_description,1,@default_milestone,1);

			#Log the actions of the script.
				SET @script_log_message = CONCAT('A new unit #'
										, (SELECT IFNULL(@product_id, 'product_id is NULL'))
										, ' ('
										, (SELECT IFNULL(@unit, 'unit is NULL'))
										, ') '
										, ' has been created in the classification: '
										, (SELECT IFNULL(@classification_id, 'classification_id is NULL'))
										, '\r\The bz user #'
										, (SELECT IFNULL(@creator_bz_id, 'creator_bz_id is NULL'))
										, ' (real name: '
										, (SELECT IFNULL(@creator_pub_name, 'creator_pub_name is NULL'))
										, ') '
										, 'is the CREATOR of that unit.'
										)
										;
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(@timestamp, @script, @script_log_message)
					;
				
				SET @script_log_message = NULL;			

			INSERT INTO `milestones`
				(`id`
				,`product_id`
				,`value`
				,`sortkey`
				,`isactive`
				)
				VALUES
				(NULL,@product_id,@default_milestone,0,1);
			
			INSERT INTO `versions`
				(`id`
				,`value`
				,`product_id`
				,`isactive`
				)
				VALUES
				(NULL,@default_milestone,@product_id,1);		
					
		#We create the goups we need
			#For simplicity reason, it is better to create ALL the groups we need for all the possible roles and permissions
			#This will avoid a scenario where we need to grant permission to see occupants for instances but the group for occupants does not exist yet...
			
			#Groups common to all components/roles for this unit
				#Allow user to create a case for this unit
					SET @create_case_group_id = ((SELECT MAX(`id`) FROM `groups`) + 1);
					SET @group_name_create_case_group = (CONCAT(@unit_for_group,'-01-Can-Create-Cases'));
					SET @group_description_create_case_group = 'User can create cases for this unit.';
					
				#Allow user to create a case for this unit
					SET @can_edit_case_group_id = (@create_case_group_id + 1);
					SET @group_name_can_edit_case_group = (CONCAT(@unit_for_group,'-01-Can-Edit-Cases'));
					SET @group_description_can_edit_case_group = 'User can edit a case they have access to';
					
				#Allow user to see the cases for this unit
					SET @can_see_cases_group_id = (@can_edit_case_group_id + 1);
					SET @group_name_can_see_cases_group = (CONCAT(@unit_for_group,'-02-Case-Is-Visible-To-All'));
					SET @group_description_can_see_cases_group = 'User can see the public cases for the unit';
					
				#Allow user to edit all fields in the case for this unit regardless of his/her role
					SET @can_edit_all_field_case_group_id = (@can_see_cases_group_id + 1);
					SET @group_name_can_edit_all_field_case_group = (CONCAT(@unit_for_group,'-03-Can-Always-Edit-all-Fields'));
					SET @group_description_can_edit_all_field_case_group = 'Triage - User can edit all fields in a case they have access to, regardless of role';
					
				#Allow user to edit all the fields in a case, regardless of user role for this unit
					SET @can_edit_component_group_id = (@can_edit_all_field_case_group_id + 1);
					SET @group_name_can_edit_component_group = (CONCAT(@unit_for_group,'-04-Can-Edit-Components'));
					SET @group_description_can_edit_component_group = 'User can edit components/roles for the unit';
					
				#Allow user to see the unit in the search
					SET @can_see_unit_in_search_group_id = (@can_edit_component_group_id + 1);
					SET @group_name_can_see_unit_in_search_group = (CONCAT(@unit_for_group,'-00-Can-See-Unit-In-Search'));
					SET @group_description_can_see_unit_in_search_group = 'User can see the unit in the search panel';
					
			#The groups related to Flags
				#Allow user to  for this unit
					SET @all_g_flags_group_id = (@can_see_unit_in_search_group_id + 1);
					SET @group_name_all_g_flags_group = (CONCAT(@unit_for_group,'-05-Can-Approve-All-Flags'));
					SET @group_description_all_g_flags_group = 'User can approve all flags';
					
				#Allow user to  for this unit
					SET @all_r_flags_group_id = (@all_g_flags_group_id + 1);
					SET @group_name_all_r_flags_group = (CONCAT(@unit_for_group,'-05-Can-Request-All-Flags'));
					SET @group_description_all_r_flags_group = 'User can request a Flag to be approved';
					
				
			#The Groups that control user visibility
				#Allow user to  for this unit
					SET @list_visible_assignees_group_id = (@all_r_flags_group_id + 1);
					SET @group_name_list_visible_assignees_group = (CONCAT(@unit_for_group,'-06-List-Public-Assignee'));
					SET @group_description_list_visible_assignees_group = 'User are visible assignee(s) for this unit';
					
				#Allow user to  for this unit
					SET @see_visible_assignees_group_id = (@list_visible_assignees_group_id + 1);
					SET @group_name_see_visible_assignees_group = (CONCAT(@unit_for_group,'-06-Can-See-Public-Assignee'));
					SET @group_description_see_visible_assignees_group = 'User can see all visible assignee(s) for this unit';
					
			#Other Misc Groups
				#Allow user to  for this unit
					SET @active_stakeholder_group_id = (@see_visible_assignees_group_id + 1);
					SET @group_name_active_stakeholder_group = (CONCAT(@unit_for_group,'-07-Active-Stakeholder'));
					SET @group_description_active_stakeholder_group = 'Users who have a role in this unit as of today (WIP)';
					
				#Allow user to  for this unit
					SET @unit_creator_group_id = (@active_stakeholder_group_id + 1);
					SET @group_name_unit_creator_group = (CONCAT(@unit_for_group,'-07-Unit-Creator'));
					SET @group_description_unit_creator_group = 'User is considered to be the creator of the unit';
					
			#Groups associated to the components/roles
				#For the tenant
					#Visibility group
					SET @group_id_show_to_tenant = (@unit_creator_group_id + 1);
					SET @group_name_show_to_tenant = (CONCAT(@unit_for_group,'-02-Limit-to-Tenant'));
					SET @group_description_tenant = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 1),@visibility_explanation_2));
				
					#Is in tenant user Group
					SET @group_id_are_users_tenant = (@group_id_show_to_tenant + 1);
					SET @group_name_are_users_tenant = (CONCAT(@unit_for_group,'-06-List-Tenant'));
					SET @group_description_are_users_tenant = (CONCAT('list the tenant(s)', @unit));
					
					#Can See tenant user Group
					SET @group_id_see_users_tenant = (@group_id_are_users_tenant + 1);
					SET @group_name_see_users_tenant = (CONCAT(@unit_for_group,'-06-Can-see-Tenant'));
					SET @group_description_see_users_tenant = (CONCAT('See the list of tenant(s) for ', @unit));
			
				#For the Landlord
					#Visibility group 
					SET @group_id_show_to_landlord = (@group_id_see_users_tenant + 1);
					SET @group_name_show_to_landlord = (CONCAT(@unit_for_group,'-02-Limit-to-Landlord'));
					SET @group_description_show_to_landlord = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 2),@visibility_explanation_2));
					
					#Is in landlord user Group
					SET @group_id_are_users_landlord = (@group_id_show_to_landlord + 1);
					SET @group_name_are_users_landlord = (CONCAT(@unit_for_group,'-06-List-landlord'));
					SET @group_description_are_users_landlord = (CONCAT('list the landlord(s)', @unit));
					
					#Can See landlord user Group
					SET @group_id_see_users_landlord = (@group_id_are_users_landlord + 1);
					SET @group_name_see_users_landlord = (CONCAT(@unit_for_group,'-06-Can-see-lanldord'));
					SET @group_description_see_users_landlord = (CONCAT('See the list of lanldord(s) for ', @unit));
					
				#For the agent
					#Visibility group 
					SET @group_id_show_to_agent = (@group_id_see_users_landlord + 1);
					SET @group_name_show_to_agent = (CONCAT(@unit_for_group,'-02-Limit-to-Agent'));
					SET @group_description_show_to_agent = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 5),@visibility_explanation_2));
					
					#Is in Agent user Group
					SET @group_id_are_users_agent = (@group_id_show_to_agent + 1);
					SET @group_name_are_users_agent = (CONCAT(@unit_for_group,'-06-List-agent'));
					SET @group_description_are_users_agent = (CONCAT('list the agent(s)', @unit));
					
					#Can See Agent user Group
					SET @group_id_see_users_agent = (@group_id_are_users_agent + 1);
					SET @group_name_see_users_agent = (CONCAT(@unit_for_group,'-06-Can-see-agent'));
					SET @group_description_see_users_agent = (CONCAT('See the list of agent(s) for ', @unit));
				
				#For the contractor
					#Visibility group 
					SET @group_id_show_to_contractor = (@group_id_see_users_agent + 1);
					SET @group_name_show_to_contractor = (CONCAT(@unit_for_group,'-02-Limit-to-Contractor-Employee'));
					SET @group_description_show_to_contractor = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 3),@visibility_explanation_2));
					
					#Is in contractor user Group
					SET @group_id_are_users_contractor = (@group_id_show_to_contractor + 1);
					SET @group_name_are_users_contractor = (CONCAT(@unit_for_group,'-06-List-contractor-employee'));
					SET @group_description_are_users_contractor = (CONCAT('list the contractor employee(s)', @unit));
					
					#Can See contractor user Group
					SET @group_id_see_users_contractor = (@group_id_are_users_contractor + 1);
					SET @group_name_see_users_contractor = (CONCAT(@unit_for_group,'-06-Can-see-contractor-employee'));
					SET @group_description_see_users_contractor = (CONCAT('See the list of contractor employee(s) for ', @unit));
					
				#For the Mgt Cny
					#Visibility group
					SET @group_id_show_to_mgt_cny = (@group_id_see_users_contractor + 1);
					SET @group_name_show_to_mgt_cny = (CONCAT(@unit_for_group,'-02-Limit-to-Mgt-Cny-Employee'));
					SET @group_description_show_to_mgt_cny = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 4),@visibility_explanation_2));
					
					#Is in mgt cny user Group
					SET @group_id_are_users_mgt_cny = (@group_id_show_to_mgt_cny + 1);
					SET @group_name_are_users_mgt_cny = (CONCAT(@unit_for_group,'-06-List-Mgt-Cny-Employee'));
					SET @group_description_are_users_mgt_cny = (CONCAT('list the Mgt Cny Employee(s)', @unit));
					
					#Can See mgt cny user Group
					SET @group_id_see_users_mgt_cny = (@group_id_are_users_mgt_cny + 1);
					SET @group_name_see_users_mgt_cny = (CONCAT(@unit_for_group,'-06-Can-see-Mgt-Cny-Employee'));
					SET @group_description_see_users_mgt_cny = (CONCAT('See the list of Mgt Cny Employee(s) for ', @unit));
				
				#For the occupant
					#Visibility group
					SET @group_id_show_to_occupant = (@group_id_see_users_mgt_cny + 1);
					SET @group_name_show_to_occupant = (CONCAT(@unit_for_group,'-02-Limit-to-occupant'));
					SET @group_description_show_to_occupant = (CONCAT(@visibility_explanation_1,'Occupants'));
					
					#Is in occupant user Group
					SET @group_id_are_users_occupant = (@group_id_show_to_occupant + 1);
					SET @group_name_are_users_occupant = (CONCAT(@unit_for_group,'-06-List-occupant'));
					SET @group_description_are_users_occupant = (CONCAT('list-the-occupant(s)-', @unit));
					
					#Can See occupant user Group
					SET @group_id_see_users_occupant = (@group_id_are_users_occupant + 1);
					SET @group_name_see_users_occupant = (CONCAT(@unit_for_group,'-06-Can-see-occupant'));
					SET @group_description_see_users_occupant = (CONCAT('See the list of occupant(s) for ', @unit));
					
				#For the people invited by this user:
					#Is in invited_by user Group
					SET @group_id_are_users_invited_by = (@group_id_see_users_occupant + 1);
					SET @group_name_are_users_invited_by = (CONCAT(@unit_for_group,'-06-List-invited-by'));
					SET @group_description_are_users_invited_by = (CONCAT('list the invited_by(s)', @unit));
					
					#Can See users in invited_by user Group
					SET @group_id_see_users_invited_by = (@group_id_are_users_invited_by + 1);
					SET @group_name_see_users_invited_by = (CONCAT(@unit_for_group,'-06-Can-see-invited-by'));
					SET @group_description_see_users_invited_by = (CONCAT('See the list of invited_by(s) for ', @unit));

			#We can populate the 'groups' table now.
				INSERT INTO `groups`
					(`id`
					,`name`
					,`description`
					,`isbuggroup`
					,`userregexp`
					,`isactive`
					,`icon_url`
					) 
					VALUES 
					(@create_case_group_id,@group_name_create_case_group,@group_description_create_case_group,1,'',1,NULL)
					,(@can_edit_case_group_id,@group_name_can_edit_case_group,@group_description_can_edit_case_group,1,'',1,NULL)
					,(@can_see_cases_group_id,@group_name_can_see_cases_group,@group_description_can_see_cases_group,1,'',1,NULL)
					,(@can_edit_all_field_case_group_id,@group_name_can_edit_all_field_case_group,@group_description_can_edit_all_field_case_group,1,'',1,NULL)
					,(@can_edit_component_group_id,@group_name_can_edit_component_group,@group_description_can_edit_component_group,1,'',1,NULL)
					,(@can_see_unit_in_search_group_id,@group_name_can_see_unit_in_search_group,@group_description_can_see_unit_in_search_group,1,'',1,NULL)
					,(@all_g_flags_group_id,@group_name_all_g_flags_group,@group_description_all_g_flags_group,1,'',0,NULL)
					,(@all_r_flags_group_id,@group_name_all_r_flags_group,@group_description_all_r_flags_group,1,'',0,NULL)
					,(@list_visible_assignees_group_id,@group_name_list_visible_assignees_group,@group_description_list_visible_assignees_group,1,'',0,NULL)
					,(@see_visible_assignees_group_id,@group_name_see_visible_assignees_group,@group_description_see_visible_assignees_group,1,'',0,NULL)
					,(@active_stakeholder_group_id,@group_name_active_stakeholder_group,@group_description_active_stakeholder_group,1,'',1,NULL)
					,(@unit_creator_group_id,@group_name_unit_creator_group,@group_description_unit_creator_group,1,'',0,NULL)
					,(@group_id_show_to_tenant,@group_name_show_to_tenant,@group_description_tenant,1,'',1,NULL)
					,(@group_id_are_users_tenant,@group_name_are_users_tenant,@group_description_are_users_tenant,1,'',0,NULL)
					,(@group_id_see_users_tenant,@group_name_see_users_tenant,@group_description_see_users_tenant,1,'',0,NULL)
					,(@group_id_show_to_landlord,@group_name_show_to_landlord,@group_description_show_to_landlord,1,'',1,NULL)
					,(@group_id_are_users_landlord,@group_name_are_users_landlord,@group_description_are_users_landlord,1,'',0,NULL)
					,(@group_id_see_users_landlord,@group_name_see_users_landlord,@group_description_see_users_landlord,1,'',0,NULL)
					,(@group_id_show_to_agent,@group_name_show_to_agent,@group_description_show_to_agent,1,'',1,NULL)
					,(@group_id_are_users_agent,@group_name_are_users_agent,@group_description_are_users_agent,1,'',0,NULL)
					,(@group_id_see_users_agent,@group_name_see_users_agent,@group_description_see_users_agent,1,'',0,NULL)
					,(@group_id_show_to_contractor,@group_name_show_to_contractor,@group_description_show_to_contractor,1,'',1,NULL)
					,(@group_id_are_users_contractor,@group_name_are_users_contractor,@group_description_are_users_contractor,1,'',0,NULL)
					,(@group_id_see_users_contractor,@group_name_see_users_contractor,@group_description_see_users_contractor,1,'',0,NULL)
					,(@group_id_show_to_mgt_cny,@group_name_show_to_mgt_cny,@group_description_show_to_mgt_cny,1,'',1,NULL)
					,(@group_id_are_users_mgt_cny,@group_name_are_users_mgt_cny,@group_description_are_users_mgt_cny,1,'',0,NULL)
					,(@group_id_see_users_mgt_cny,@group_name_see_users_mgt_cny,@group_description_see_users_mgt_cny,1,'',0,NULL)
					,(@group_id_show_to_occupant,@group_name_show_to_occupant,@group_description_show_to_occupant,1,'',1,NULL)
					,(@group_id_are_users_occupant,@group_name_are_users_occupant,@group_description_are_users_occupant,1,'',0,NULL)
					,(@group_id_see_users_occupant,@group_name_see_users_occupant,@group_description_see_users_occupant,1,'',0,NULL)
					,(@group_id_are_users_invited_by,@group_name_are_users_invited_by,@group_description_are_users_invited_by,1,'',0,NULL)
					,(@group_id_see_users_invited_by,@group_name_see_users_invited_by,@group_description_see_users_invited_by,1,'',0,NULL)
					;

			#Log the actions of the script.
				SET @script_log_message = CONCAT('We have created the groups that we will need for that unit #'
										, @product_id
										, '\r\ - To grant '
										, 'case creation'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@create_case_group_id, 'create_case_group_id is NULL'))
										, '\r\ - To grant '
										, 'Edit case'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@can_edit_case_group_id, 'can_edit_case_group_id is NULL'))
										, '\r\ - To grant '
										, 'Edit all field regardless of role'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@can_edit_all_field_case_group_id, 'can_edit_all_field_case_group_id is NULL'))
										, '\r\ - To grant '
										, 'Edit Component/roles'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@can_edit_component_group_id, 'can_edit_component_group_id is NULL'))
										, '\r\ - To grant '
										, 'See unit in the Search panel'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@can_see_unit_in_search_group_id, 'can_see_unit_in_search_group_id is NULL'))
										, '\r\ - To grant '
										, 'See cases'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@can_see_cases_group_id, 'can_see_cases_group_id is NULL'))
										, '\r\ - To grant '
										, 'Request all flags'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@all_r_flags_group_id, 'all_r_flags_group_id is NULL'))
										, '\r\ - To grant '
										, 'Approve all flags'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@all_g_flags_group_id, 'all_g_flags_group_id is NULL'))
										, '\r\ - To grant '
										, 'User is publicly visible'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@list_visible_assignees_group_id, 'list_visible_assignees_group_id is NULL'))
										, '\r\ - To grant '
										, 'User can see publicly visible'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@see_visible_assignees_group_id, 'see_visible_assignees_group_id is NULL'))
										, '\r\ - To grant '
										, 'User is active Stakeholder'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@active_stakeholder_group_id, 'active_stakeholder_group_id is NULL'))
										, '\r\ - To grant '
										, 'User is the unit creator'
										, ' privileges. Group_id: '
										, (SELECT IFNULL(@unit_creator_group_id, 'unit_creator_group_id is NULL'))
										, '\r\ - Restrict permission to '
										, 'tenant'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_show_to_tenant, 'group_id_show_to_tenant is NULL'))
										, '\r\ - Group for the '
										, 'tenant'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_are_users_tenant, 'group_id_are_users_tenant is NULL'))
										, '\r\ - Group to see the users '
										, 'tenant'
										, '. Group_id: '
										, (SELECT IFNULL(@group_id_see_users_tenant, 'group_id_see_users_tenant is NULL'))
										
										, '\r\ - Restrict permission to '
										, 'landlord'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_show_to_landlord, 'group_id_show_to_landlord is NULL'))
										, '\r\ - Group for the '
										, 'landlord'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_are_users_landlord, 'group_id_are_users_landlord is NULL'))
										, '\r\ - Group to see the users'
										, 'landlord'
										, '. Group_id: '
										, (SELECT IFNULL(@group_id_see_users_landlord, 'group_id_see_users_landlord is NULL'))
										
										, '\r\ - Restrict permission to '
										, 'agent'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_show_to_agent, 'group_id_show_to_agent is NULL'))
										, '\r\ - Group for the '
										, 'agent'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_are_users_agent, 'group_id_are_users_agent is NULL'))
										, '\r\ - Group to see the users'
										, 'agent'
										, '. Group_id: '
										, (SELECT IFNULL(@group_id_see_users_agent, 'group_id_see_users_agent is NULL'))
										
										, '\r\ - Restrict permission to '
										, 'Contractor'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_show_to_contractor, 'group_id_show_to_contractor is NULL'))
										, '\r\ - Group for the '
										, 'Contractor'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_are_users_contractor, 'group_id_are_users_contractor is NULL'))
										, '\r\ - Group to see the users'
										, 'Contractor'
										, '. Group_id: '
										, (SELECT IFNULL(@group_id_see_users_contractor, 'group_id_see_users_contractor is NULL'))
										
										, '\r\ - Restrict permission to '
										, 'Management Company'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_show_to_mgt_cny, 'group_id_show_to_mgt_cny is NULL'))
										, '\r\ - Group for the users in the '
										, 'Management Company'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_are_users_mgt_cny, 'group_id_are_users_mgt_cny is NULL'))
										, '\r\ - Group to see the users in the '
										, 'Management Company'
										, '. Group_id: '
										, (SELECT IFNULL(@group_id_see_users_mgt_cny, 'group_id_see_users_mgt_cny is NULL'))
										
										, '\r\ - Restrict permission to '
										, 'occupant'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_show_to_occupant, 'group_id_show_to_occupant is NULL'))
										, '\r\ - Group for the '
										, 'occupant'
										, ' only. Group_id: '
										, (SELECT IFNULL(@group_id_are_users_occupant, 'group_id_are_users_occupant is NULL'))
										, '\r\ - Group to see the users '
										, 'occupant'
										, '. Group_id: '
										, (SELECT IFNULL(@group_id_see_users_occupant, 'group_id_see_users_occupant is NULL'))
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(@timestamp, @script, @script_log_message)
					;
				
				SET @script_log_message = NULL;				
					
		#We record the groups we have just created:
			#We NEED the component_id for that

			INSERT INTO `ut_product_group`
				(
				product_id
				,component_id
				,group_id
				,group_type_id
				,role_type_id
				,created_by_id
				,created
				)
				VALUES
				(@product_id,NULL,@create_case_group_id,20,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@can_edit_case_group_id,25,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@can_edit_all_field_case_group_id,26,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@can_edit_component_group_id,27,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@can_see_cases_group_id,28,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@can_see_unit_in_search_group_id,38,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@all_r_flags_group_id,18,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@all_g_flags_group_id,19,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@list_visible_assignees_group_id,4,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@see_visible_assignees_group_id,5,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@active_stakeholder_group_id,29,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@unit_creator_group_id,1,NULL,@creator_bz_id,@timestamp)
				, # Tenant (1)
				(@product_id,@component_id_tenant,@group_id_show_to_tenant,2,1,@creator_bz_id,@timestamp)
				,(@product_id,@component_id_tenant,@group_id_are_users_tenant,22,1,@creator_bz_id,@timestamp)
				,(@product_id,@component_id_tenant,@group_id_see_users_tenant,37,1,@creator_bz_id,@timestamp)
				#Landlord (2)
				,(@product_id,@component_id_landlord,@group_id_show_to_landlord,2,2,@creator_bz_id,@timestamp)
				,(@product_id,@component_id_landlord,@group_id_are_users_landlord,22,2,@creator_bz_id,@timestamp)
				,(@product_id,@component_id_landlord,@group_id_see_users_landlord,37,2,@creator_bz_id,@timestamp)
				#Agent (5)
				,(@product_id,@component_id_agent,@group_id_show_to_agent,2,5,@creator_bz_id,@timestamp)
				,(@product_id,@component_id_agent,@group_id_are_users_agent,22,5,@creator_bz_id,@timestamp)
				,(@product_id,@component_id_agent,@group_id_see_users_agent,37,5,@creator_bz_id,@timestamp)
				#contractor (3)
				,(@product_id,@component_id_contractor,@group_id_show_to_contractor,2,3,@creator_bz_id,@timestamp)
				,(@product_id,@component_id_contractor,@group_id_are_users_contractor,22,3,@creator_bz_id,@timestamp)
				,(@product_id,@component_id_contractor,@group_id_see_users_contractor,37,3,@creator_bz_id,@timestamp)
				#mgt_cny (4)
				,(@product_id,@component_id_mgt_cny,@group_id_show_to_mgt_cny,2,4,@creator_bz_id,@timestamp)
				,(@product_id,@component_id_mgt_cny,@group_id_are_users_mgt_cny,22,4,@creator_bz_id,@timestamp)
				,(@product_id,@component_id_mgt_cny,@group_id_see_users_mgt_cny,37,4,@creator_bz_id,@timestamp)
				#occupant (#)
				,(@product_id,NULL,@group_id_show_to_occupant,24,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@group_id_are_users_occupant,3,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@group_id_see_users_occupant,36,NULL,@creator_bz_id,@timestamp)
				#invited_by
				,(@product_id,NULL,@group_id_are_users_invited_by,31,NULL,@creator_bz_id,@timestamp)
				,(@product_id,NULL,@group_id_see_users_invited_by,32,NULL,@creator_bz_id,@timestamp)
				;

		#We now Create the flagtypes and flags for this new unit (we NEEDED the group ids for that!):
			SET @flag_next_step = ((SELECT MAX(`id`) FROM `flagtypes`) + 1);
			SET @flag_solution = (@flag_next_step + 1);
			SET @flag_budget = (@flag_solution + 1);
			SET @flag_attachment = (@flag_budget + 1);
			SET @flag_ok_to_pay = (@flag_attachment + 1);
			SET @flag_is_paid = (@flag_ok_to_pay + 1);

			INSERT INTO `flagtypes`
				(`id`
				,`name`
				,`description`
				,`cc_list`
				,`target_type`
				,`is_active`
				,`is_requestable`
				,`is_requesteeble`
				,`is_multiplicable`
				,`sortkey`
				,`grant_group_id`
				,`request_group_id`
				) 
				VALUES 
				(@flag_next_step,CONCAT('Next_Step_',@unit_for_flag),'Approval for the Next Step of the case.','','b',1,1,1,1,10,@all_g_flags_group_id,@all_r_flags_group_id)
				,(@flag_solution,CONCAT('Solution_',@unit_for_flag),'Approval for the Solution of this case.','','b',1,1,1,1,20,@all_g_flags_group_id,@all_r_flags_group_id)
				,(@flag_budget,CONCAT('Budget_',@unit_for_flag),'Approval for the Budget for this case.','','b',1,1,1,1,30,@all_g_flags_group_id,@all_r_flags_group_id)
				,(@flag_attachment,CONCAT('Attachment_',@unit_for_flag),'Approval for this Attachment.','','a',1,1,1,1,10,@all_g_flags_group_id,@all_r_flags_group_id)
				,(@flag_ok_to_pay,CONCAT('OK_to_pay_',@unit_for_flag),'Approval to pay this bill.','','a',1,1,1,1,20,@all_g_flags_group_id,@all_r_flags_group_id)
				,(@flag_is_paid,CONCAT('is_paid_',@unit_for_flag),'Confirm if this bill has been paid.','','a',1,1,1,1,30,@all_g_flags_group_id,@all_r_flags_group_id)
				;
			
			INSERT INTO `flaginclusions`
				(`type_id`
				,`product_id`
				,`component_id`
				) 
				VALUES
				(@flag_next_step,@product_id,NULL)
				,(@flag_solution,@product_id,NULL)
				,(@flag_budget,@product_id,NULL)
				,(@flag_attachment,@product_id,NULL)
				,(@flag_ok_to_pay,@product_id,NULL)
				,(@flag_is_paid,@product_id,NULL)
				;

			#Log the actions of the script.
				SET @script_log_message = CONCAT('We have created the following flags which are restricted to that unit: '
										, '\r\ - Next Step (#'
										, (SELECT IFNULL(@flag_next_step, 'flag_next_step is NULL'))
										, ').'
										, '\r\ - Solution (#'
										, (SELECT IFNULL(@flag_solution, 'flag_solution is NULL'))
										, ').'
										, '\r\ - Budget (#'
										, (SELECT IFNULL(@flag_budget, 'flag_budget is NULL'))
										, ').'
										, '\r\ - Attachment (#'
										, (SELECT IFNULL(@flag_attachment, 'flag_attachment is NULL'))
										, ').'
										, '\r\ - OK to pay (#'
										, (SELECT IFNULL(@flag_ok_to_pay, 'flag_ok_to_pay is NULL'))
										, ').'
										, '\r\ - Is paid (#'
										, (SELECT IFNULL(@flag_is_paid, 'flag_is_paid is NULL'))
										, ').'
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(@timestamp, @script, @script_log_message)
					;
				
				SET @script_log_message = NULL;	
				
		#We configure the group permissions:
			#Data for the table `group_group_map`
			#We use a temporary table to do this, this is to avoid duplicate in the group_group_map table

			#DELETE the temp table if it exists
			DROP TABLE IF EXISTS `ut_group_group_map_temp`;
			
			#Re-create the temp table
			CREATE TABLE `ut_group_group_map_temp` (
			  `member_id` MEDIUMINT(9) NOT NULL,
			  `grantor_id` MEDIUMINT(9) NOT NULL,
			  `grant_type` TINYINT(4) NOT NULL DEFAULT 0
			) ENGINE=INNODB DEFAULT CHARSET=utf8;

			#Add the records that exist in the table group_group_map
			INSERT INTO `ut_group_group_map_temp`
				SELECT *
				FROM `group_group_map`;
			
			
			#Add the new records
			INSERT INTO `ut_group_group_map_temp`
				(`member_id`
				,`grantor_id`
				,`grant_type`
				) 
			##########################################################
			#Logic:
			#If you are a member of group_id XXX (ex: 1 / Admin) 
			#then you have the following permissions:
				#- 0: You are automatically a member of group ZZZ
				#- 1: You can grant access to group ZZZ
				#- 2: You can see users in group ZZZ
			##########################################################
				VALUES 
				#Admin group can grant membership to all
				(1,@create_case_group_id,1)
				,(1,@can_edit_case_group_id,1)
				,(1,@can_see_cases_group_id,1)
				,(1,@can_edit_all_field_case_group_id,1)
				,(1,@can_edit_component_group_id,1)
				,(1,@can_see_unit_in_search_group_id,1)
				,(1,@all_g_flags_group_id,1)
				,(1,@all_r_flags_group_id,1)
				,(1,@list_visible_assignees_group_id,1)
				,(1,@see_visible_assignees_group_id,1)
				,(1,@active_stakeholder_group_id,1)
				,(1,@unit_creator_group_id,1)
				,(1,@group_id_show_to_tenant,1)
				,(1,@group_id_are_users_tenant,1)
				,(1,@group_id_see_users_tenant,1)
				,(1,@group_id_show_to_landlord,1)
				,(1,@group_id_are_users_landlord,1)
				,(1,@group_id_see_users_landlord,1)
				,(1,@group_id_show_to_agent,1)
				,(1,@group_id_are_users_agent,1)
				,(1,@group_id_see_users_agent,1)
				,(1,@group_id_show_to_contractor,1)
				,(1,@group_id_are_users_contractor,1)
				,(1,@group_id_see_users_contractor,1)
				,(1,@group_id_show_to_mgt_cny,1)
				,(1,@group_id_are_users_mgt_cny,1)
				,(1,@group_id_see_users_mgt_cny,1)
				,(1,@group_id_show_to_occupant,1)
				,(1,@group_id_are_users_occupant,1)
				,(1,@group_id_see_users_occupant,1)
				,(1,@group_id_are_users_invited_by,1)
				,(1,@group_id_see_users_invited_by,1)
				
				#Admin MUST be a member of the mandatory group for this unit
				#If not it is impossible to see this product in the BZFE backend.
				,(1,@can_see_unit_in_search_group_id,0)

				#Visibility groups:
				,(@all_r_flags_group_id,@all_g_flags_group_id,2)
				,(@see_visible_assignees_group_id,@list_visible_assignees_group_id,2)
				,(@unit_creator_group_id,@unit_creator_group_id,2)
				,(@group_id_see_users_tenant,@group_id_are_users_tenant,2)
				,(@group_id_see_users_landlord,@group_id_are_users_landlord,2)
				,(@group_id_see_users_agent,@group_id_are_users_contractor,2)
				,(@group_id_see_users_mgt_cny,@group_id_are_users_mgt_cny,2)
				,(@group_id_see_users_occupant,@group_id_are_users_occupant,2)
				,(@group_id_see_users_invited_by,@group_id_are_users_invited_by,2)
				;

		#We make sure that only user in certain groups can create, edit or see cases.
			INSERT INTO `group_control_map`
				(`group_id`
				,`product_id`
				,`entry`
				,`membercontrol`
				,`othercontrol`
				,`canedit`
				,`editcomponents`
				,`editbugs`
				,`canconfirm`
				) 
				VALUES 
				(@create_case_group_id,@product_id,1,0,0,0,0,0,0)
				,(@can_edit_case_group_id,@product_id,1,0,0,1,0,0,1)
				,(@can_edit_all_field_case_group_id,@product_id,1,0,0,1,0,1,1)
				,(@can_edit_component_group_id,@product_id,0,0,0,0,1,0,0)
				,(@can_see_cases_group_id,@product_id,0,2,0,0,0,0,0)
				,(@can_see_unit_in_search_group_id,@product_id,0,3,3,0,0,0,0)
				,(@group_id_show_to_tenant,@product_id,0,2,0,0,0,0,0)
				,(@group_id_show_to_landlord,@product_id,0,2,0,0,0,0,0)
				,(@group_id_show_to_agent,@product_id,0,2,0,0,0,0,0)
				,(@group_id_show_to_contractor,@product_id,0,2,0,0,0,0,0)
				,(@group_id_show_to_mgt_cny,@product_id,0,2,0,0,0,0,0)
				,(@group_id_show_to_occupant,@product_id,0,2,0,0,0,0,0)
				;

			#Log the actions of the script.
				SET @script_log_message = CONCAT('We have updated the group control permissions for the product# '
										, @product_id
										, ': '
										, '\r\ - Create Case (#'
										, (SELECT IFNULL(@create_case_group_id, 'create_case_group_id is NULL'))
										, ').'
										, '\r\ - Edit Case (#'
										, (SELECT IFNULL(@can_edit_case_group_id, 'can_edit_case_group_id is NULL'))
										, ').'
										, '\r\ - Edit All Field (#'
										, (SELECT IFNULL(@can_edit_all_field_case_group_id, 'can_edit_all_field_case_group_id is NULL'))
										, ').'
										, '\r\ - Edit Component (#'
										, (SELECT IFNULL(@can_edit_component_group_id, 'can_edit_component_group_id is NULL'))
										, ').'
										, '\r\ - Can see case (#'
										, (SELECT IFNULL(@can_see_cases_group_id, 'flag_ok_to_pay is NULL'))
										, ').'
										, '\r\ - Can See unit in Search (#'
										, (SELECT IFNULL(@group_id_show_to_tenant, 'group_id_show_to_tenant is NULL'))
										, ').'
										, '\r\ - Show case to Tenant (#'
										, (SELECT IFNULL(@group_id_show_to_landlord, 'group_id_show_to_landlord is NULL'))
										, ').'
										, '\r\ - Show case to Landlord (#'
										, (SELECT IFNULL(@group_id_show_to_landlord, 'group_id_show_to_landlord is NULL'))
										, ').'
										, '\r\ - Show case to Agent (#'
										, (SELECT IFNULL(@group_id_show_to_agent, 'group_id_show_to_agent is NULL'))
										, ').'
										, '\r\ - Show case to Contractor (#'
										, (SELECT IFNULL(@group_id_show_to_contractor, 'group_id_show_to_contractor is NULL'))
										, ').'
										, '\r\ - Show case to Management Company (#'
										, (SELECT IFNULL(@group_id_show_to_mgt_cny, 'group_id_show_to_mgt_cny is NULL'))
										, ').'
										, '\r\ - Show case to Occupant(s) (#'
										, (SELECT IFNULL(@group_id_show_to_occupant, 'group_id_show_to_occupant is NULL'))
										, ').'
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;
				
				SET @script_log_message = NULL;

			#We have eveything, we can create the components we need:
				INSERT INTO `components`
				(`id`
				,`name`
				,`product_id`
				,`initialowner`
				,`initialqacontact`
				,`description`
				,`isactive`
				) 
				VALUES
				(@component_id_tenant,@role_user_g_description_tenant,@product_id,@bz_user_id_dummy_tenant,@bz_user_id_dummy_tenant,@user_role_desc_tenant,1)
				, (@component_id_landlord, @role_user_g_description_landlord, @product_id, @bz_user_id_dummy_landlord, @bz_user_id_dummy_landlord, @user_role_desc_landlord, 1)
				, (@component_id_agent, @role_user_g_description_agent, @product_id, @bz_user_id_dummy_agent, @bz_user_id_dummy_agent, @user_role_desc_agent, 1)
				, (@component_id_contractor, @role_user_g_description_contractor, @product_id, @bz_user_id_dummy_contractor, @bz_user_id_dummy_contractor, @user_role_desc_contractor, 1)
				, (@component_id_mgt_cny, @role_user_g_description_mgt_cny, @product_id, @bz_user_id_dummy_mgt_cny, @bz_user_id_dummy_mgt_cny, @user_role_desc_mgt_cny, 1)
				;
			

			#Log the actions of the script.
				SET @script_log_message = CONCAT('The role created for that unit with temporary users were:'
										, '\r\- '
										, (SELECT IFNULL(@role_user_g_description_tenant, 'role_user_g_description is NULL'))
										, ' (role_type_id #'
										, '1'
										, ') '
										, '\r\The user associated to this role was bz user #'
										, (SELECT IFNULL(@bz_user_id_dummy_tenant, 'bz_user_id is NULL'))
										, ' (real name: '
										, (SELECT IFNULL(@user_pub_name_tenant, 'user_pub_name is NULL'))
										, '. This user is the default assignee for this role for that unit).' 
										
										, '\r\- '
										, (SELECT IFNULL(@role_user_g_description_landlord, 'role_user_g_description is NULL'))
										, ' (role_type_id #'
										, '2'
										, ') '
										, '\r\The user associated to this role was bz user #'
										, (SELECT IFNULL(@bz_user_id_dummy_landlord, 'bz_user_id is NULL'))
										, ' (real name: '
										, (SELECT IFNULL(@user_pub_name_landlord, 'user_pub_name is NULL'))
										, '. This user is the default assignee for this role for that unit).'
										
										, '\r\- '
										, (SELECT IFNULL(@role_user_g_description_agent, 'role_user_g_description is NULL'))
										, ' (role_type_id #'
										, '5'
										, ') '
										, '\r\The user associated to this role was bz user #'
										, (SELECT IFNULL(@bz_user_id_dummy_agent, 'bz_user_id is NULL'))
										, ' (real name: '
										, (SELECT IFNULL(@user_pub_name_agent, 'user_pub_name is NULL'))
										, '. This user is the default assignee for this role for that unit).'
										
										, '\r\- '
										, (SELECT IFNULL(@role_user_g_description_contractor, 'role_user_g_description is NULL'))
										, ' (role_type_id #'
										, '3'
										, ') '
										, '\r\The user associated to this role was bz user #'
										, (SELECT IFNULL(@bz_user_id_dummy_contractor, 'bz_user_id is NULL'))
										, ' (real name: '
										, (SELECT IFNULL(@user_pub_name_contractor, 'user_pub_name is NULL'))
										, '. This user is the default assignee for this role for that unit).'

										, '\r\- '
										, (SELECT IFNULL(@role_user_g_description_mgt_cny, 'role_user_g_description is NULL'))
										, ' (role_type_id #'
										, '3'
										, ') '
										, '\r\The user associated to this role was bz user #'
										, (SELECT IFNULL(@bz_user_id_dummy_mgt_cny, 'bz_user_id is NULL'))
										, ' (real name: '
										, (SELECT IFNULL(@user_pub_name_mgt_cny, 'user_pub_name is NULL'))
										, '. This user is the default assignee for this role for that unit).'								
										)
										;
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;
				
				SET @script_log_message = NULL;	
					
			#We update the BZ logs
				INSERT INTO `audit_log`
					(`user_id`
					,`class`
					,`object_id`
					,`field`
					,`removed`
					,`added`
					,`at_time`
					) 
					VALUES 
					(@creator_bz_id, 'Bugzilla::Group', @create_case_group_id, '__create__', NULL, @group_name_create_case_group, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @can_edit_case_group_id, '__create__', NULL, @group_name_can_edit_case_group, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @can_edit_all_field_case_group_id, '__create__', NULL, @group_name_can_edit_all_field_case_group, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @can_edit_component_group_id, '__create__', NULL, @group_name_can_edit_component_group, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @can_see_cases_group_id, '__create__', NULL, @group_name_can_see_cases_group, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @can_see_unit_in_search_group_id, '__create__', NULL, @group_name_can_see_unit_in_search_group, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @all_g_flags_group_id, '__create__', NULL, @group_name_all_g_flags_group, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @all_r_flags_group_id, '__create__', NULL, @group_name_all_r_flags_group, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @list_visible_assignees_group_id, '__create__', NULL, @group_name_list_visible_assignees_group, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @see_visible_assignees_group_id, '__create__', NULL, @group_name_see_visible_assignees_group, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @active_stakeholder_group_id, '__create__', NULL, @group_name_active_stakeholder_group, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @unit_creator_group_id, '__create__', NULL, @group_name_unit_creator_group, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_tenant, '__create__', NULL, @group_name_show_to_tenant, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_tenant, '__create__', NULL, @group_name_are_users_tenant, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_tenant, '__create__', NULL, @group_name_see_users_tenant, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_landlord, '__create__', NULL, @group_name_show_to_landlord, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_landlord, '__create__', NULL, @group_name_are_users_landlord, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_landlord, '__create__', NULL, @group_name_see_users_landlord, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_agent, '__create__', NULL, @group_name_show_to_agent, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_agent, '__create__', NULL, @group_name_are_users_agent, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_agent, '__create__', NULL, @group_name_see_users_agent, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_contractor, '__create__', NULL, @group_name_show_to_contractor, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_contractor, '__create__', NULL, @group_name_are_users_contractor, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_contractor, '__create__', NULL, @group_name_see_users_contractor, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_mgt_cny, '__create__', NULL, @group_name_show_to_mgt_cny, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_mgt_cny, '__create__', NULL, @group_name_are_users_mgt_cny, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_mgt_cny, '__create__', NULL, @group_name_see_users_mgt_cny, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_occupant, '__create__', NULL, @group_name_show_to_occupant, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_occupant, '__create__', NULL, @group_name_are_users_occupant, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_occupant, '__create__', NULL, @group_name_see_users_occupant, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_invited_by, '__create__', NULL, @group_name_are_users_invited_by, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_invited_by, '__create__', NULL, @group_name_see_users_invited_by, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Component', @component_id_tenant, '__create__', NULL, @role_user_g_description_tenant, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Component', @component_id_landlord, '__create__', NULL, @role_user_g_description_landlord, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Component', @component_id_agent, '__create__', NULL, @role_user_g_description_agent, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Component', @component_id_contractor, '__create__', NULL, @role_user_g_description_contractor, @timestamp)
					,(@creator_bz_id, 'Bugzilla::Component', @component_id_mgt_cny, '__create__', NULL, @role_user_g_description_mgt_cny, @timestamp)
					;
				
		#We now assign the permissions to the user associated to this role:		
			
			#We use a temporary table to make sure we do not have duplicates.
				
				#DELETE the temp table if it exists
				DROP TABLE IF EXISTS `ut_user_group_map_temp`;
				
				#Re-create the temp table
				CREATE TABLE `ut_user_group_map_temp` (
				  `user_id` MEDIUMINT(9) NOT NULL,
				  `group_id` MEDIUMINT(9) NOT NULL,
				  `isbless` TINYINT(4) NOT NULL DEFAULT '0',
				  `grant_type` TINYINT(4) NOT NULL DEFAULT '0'
				) ENGINE=INNODB DEFAULT CHARSET=utf8;

				#Add the records that exist in the table user_group_map
				INSERT INTO `ut_user_group_map_temp`
					SELECT *
					FROM `user_group_map`;

		#We create the permissions for the dummy user to create a case for this unit.		
			#- can tag comments: ALL user need that	
			#- can_create_new_cases
			#- can_edit_a_case
		#This is the only permission that the dummy user will have.

			#First the global permissions:
				#Can tag comments
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id_dummy_tenant,@can_tag_comment_group_id,0,0)
						, (@bz_user_id_dummy_landlord,@can_tag_comment_group_id,0,0)
						, (@bz_user_id_dummy_agent,@can_tag_comment_group_id,0,0)
						, (@bz_user_id_dummy_contractor,@can_tag_comment_group_id,0,0)
						, (@bz_user_id_dummy_mgt_cny,@can_tag_comment_group_id,0,0)
						;
						
					#Log the actions of the script.
						SET @script_log_message = CONCAT('the dummy bz users for each component: '
												, '(#'
												, @bz_user_id_dummy_tenant
												, ', #'
												, @bz_user_id_dummy_landlord
												, ', #'
												, @bz_user_id_dummy_agent
												, ', #'
												, @bz_user_id_dummy_contractor
												, ', #'
												, @bz_user_id_dummy_mgt_cny
												, ')'
												, ' CAN tag comments.'
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							(NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_tenant, @script, 'Add the BZ user id when we grant the permission to tag comments')
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_tag_comment_group_id, @script, 'Add the BZ group id when we grant the permission to tag comments')
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant tag comments permission')
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group tag comments')
							, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_landlord, @script, 'Add the BZ user id when we grant the permission to tag comments')
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_tag_comment_group_id, @script, 'Add the BZ group id when we grant the permission to tag comments')
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant tag comments permission')
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group tag comments')
							, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_agent, @script, 'Add the BZ user id when we grant the permission to tag comments')
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_tag_comment_group_id, @script, 'Add the BZ group id when we grant the permission to tag comments')
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant tag comments permission')
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group tag comments')
							, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_contractor, @script, 'Add the BZ user id when we grant the permission to tag comments')
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_tag_comment_group_id, @script, 'Add the BZ group id when we grant the permission to tag comments')
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant tag comments permission')
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group tag comments')
							, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_mgt_cny, @script, 'Add the BZ user id when we grant the permission to tag comments')
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_tag_comment_group_id, @script, 'Add the BZ group id when we grant the permission to tag comments')
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant tag comments permission')
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group tag comments')
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
			
			#Then the permissions at the unit/product level:
						
				#User can create a case:
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id_dummy_tenant, @create_case_group_id, 0, 0)
						, (@bz_user_id_dummy_landlord, @create_case_group_id, 0, 0)
						, (@bz_user_id_dummy_agent, @create_case_group_id, 0, 0)
						, (@bz_user_id_dummy_contractor, @create_case_group_id, 0, 0)
						, (@bz_user_id_dummy_mgt_cny, @create_case_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the dummy bz users for each component: '
												, '(#'
												, @bz_user_id_dummy_tenant
												, ', #'
												, @bz_user_id_dummy_landlord
												, ', #'
												, @bz_user_id_dummy_agent
												, ', #'
												, @bz_user_id_dummy_contractor
												, ', #'
												, @bz_user_id_dummy_mgt_cny
												, ')'
												, ' CAN create new cases for unit '
												, @product_id
												)
												;
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'create a new case.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							VALUES
							(NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_tenant, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission', 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_landlord, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission', 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_agent, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission', 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_contractor, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_mgt_cny, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;

			# User can Edit a case and see this unit, this is needed so the API does not thrown an error see issue #60:

				INSERT INTO `ut_user_group_map_temp`
					(`user_id`
					,`group_id`
					,`isbless`
					,`grant_type`
					) 
					VALUES 
					(@bz_user_id_dummy_tenant,@can_edit_case_group_id,0,0)
					, (@bz_user_id_dummy_landlord,@can_edit_case_group_id,0,0)
					, (@bz_user_id_dummy_agent,@can_edit_case_group_id,0,0)
					, (@bz_user_id_dummy_contractor,@can_edit_case_group_id,0,0)
					, (@bz_user_id_dummy_mgt_cny,@can_edit_case_group_id,0,0)
					, (@bz_user_id_dummy_tenant,@can_see_unit_in_search_group_id,0,0)
					, (@bz_user_id_dummy_landlord,@can_see_unit_in_search_group_id,0,0)
					, (@bz_user_id_dummy_agent,@can_see_unit_in_search_group_id,0,0)
					, (@bz_user_id_dummy_contractor,@can_see_unit_in_search_group_id,0,0)
					, (@bz_user_id_dummy_mgt_cny,@can_see_unit_in_search_group_id,0,0)
					;

				# Log the actions of the script.
					SET @script_log_message = CONCAT('the dummy bz users for each component: '
											, '(#'
											, @bz_user_id_dummy_tenant
											, ', #'
											, @bz_user_id_dummy_landlord
											, ', #'
											, @bz_user_id_dummy_agent
											, ', #'
											, @bz_user_id_dummy_contractor
											, ', #'
											, @bz_user_id_dummy_mgt_cny
											, ')'
											, ' CAN edit a cases and see the unit '
											, @product_id
											)
											;
					
					INSERT INTO `ut_script_log`
						(`datetime`
						, `script`
						, `log`
						)
						VALUES
						(NOW(), @script, @script_log_message)
						;

				# We log what we have just done into the `ut_audit_log` table
					
					SET @bzfe_table = 'ut_user_group_map_temp';
					SET @permission_granted = 'edit a case and see this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							(NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_tenant, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission', 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_landlord, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission', 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_agent, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission', 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_contractor, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id_dummy_mgt_cny, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, 'for the product #', @product_id))
							, (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted, 'for the product #', @product_id))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;			
					
		#We give the user the permission they need.
				
			#First the `group_group_map` table
			
				#We truncate the table first (to avoid duplicates)
				TRUNCATE TABLE `group_group_map`;
				
				#We insert the data we need
				#Grouping like this makes sure that we have no dupes!
				INSERT INTO `group_group_map`
				SELECT `member_id`
					, `grantor_id`
					, `grant_type`
				FROM
					`ut_group_group_map_temp`
				GROUP BY `member_id`
					, `grantor_id`
					, `grant_type`
				;

			#Then we update the `user_group_map` table
				
				#We truncate the table first (to avoid duplicates)
					TRUNCATE TABLE `user_group_map`;
					
				#We insert the data we need
					INSERT INTO `user_group_map`
					SELECT `user_id`
						, `group_id`
						, `isbless`
						, `grant_type`
					FROM
						`ut_user_group_map_temp`
					GROUP BY `user_id`
						, `group_id`
						, `isbless`
						, `grant_type`
					;

		#Update the table 'ut_data_to_create_units' so that we record that the unit has been created
			UPDATE `ut_data_to_create_units`
			SET 
				`bz_created_date` = @timestamp
				, `comment` = CONCAT ('inserted in BZ with the script \''
						, @script
						, '\'\r\ '
						, IFNULL(`comment`, '')
						)
				, `product_id` = @product_id
			WHERE `id_unit_to_create` = @unit_reference_for_import;


		#Clean up

			#We Delete the temp table as we do not need it anymore
				DROP TABLE IF EXISTS `ut_group_group_map_temp`;
				
			#We Delete the temp table as we do not need it anymore
				DROP TABLE IF EXISTS `ut_user_group_map_temp`;


# We have created the BZ user and the BZ units.
# We now associate the BZ users to the units
	#- Leonel (7)
	#	- Unit 1: Agent (role 5)
	#	- Unit 2: Agent (role 5)
	#	- Unit 3: No Roles
	#- Marley (8)
	#	- Unit 1: Landlord (role 2)
	#	- Unit 2: No Role
	#	- Unit 3: Landlord (role 2) / Occupant
	#- Michael (9)
	#	- Unit 1: Management Company (role 4)
	#	- Unit 2: No Role
	#	- Unit 3: Management Company (role 4)
	#- Sabrina (10)
	#	- Unit 1: Management Company (role 4) - Additional user
	#	- Unit 2: No Role
	#	- Unit 3: Management Company (role 4) - Additional user
	#- Celeste (11)
	#	- Unit 1: No Role
	#	- Unit 2: Management Company (role 4)
	#	- Unit 3: No Role
	#- Jocelyn (12)
	#	- Unit 1: co Tenant (role 1)
	#	- Unit 2: No Role
	#	- Unit 3: No Role
	#- Marina (13)
	#	- Unit 1: co Tenant (role 1) - Additional user
	#	- Unit 2: No Role
	#	- Unit 3: No Role
	#- Regina (14)
	#	- Unit 1: No Role
	#	- Unit 2: Landlord (role 2)
	#	- Unit 3: No Role
	#- Marvin (15)
	#	- Unit 1: Contractor (role 3)
	#	- Unit 2: No Role
	#	- Unit 3: Contractor (role 3)
	#- Lawrence (16)
	#	- Unit 1: No Role
	#	- Unit 2: Management Company (role 4) - Additional user
	#	- Unit 3: No Role
	#- Anabelle (17)
	#	- Unit 1: No Role
	#	- Unit 2: Contractor (role 3)
	#	- Unit 3: No Role
	#-  (18)

# Populate the table with the data to replace dummy users with actual users.
	/*Data for the table `ut_data_to_replace_dummy_roles` */

	INSERT INTO `ut_data_to_replace_dummy_roles`
		(`id`
		,`mefe_invitation_id`
		,`mefe_invitor_user_id`
		,`bzfe_invitor_user_id`
		,`bz_unit_id`,`bz_user_id`
		,`user_role_type_id`
		,`is_occupant`
		,`user_more`
		,`bz_created_date`
		,`comment`) 
		VALUES
		(1,NULL,NULL,1,1,7,5,0,'Use Unee-T for a faster reply',NULL,NULL)
		,(2,NULL,NULL,1,2,7,5,0,'Use Unee-T for a faster reply',NULL,NULL)
		,(3,NULL,NULL,1,1,8,2,0,'Use Unee-T for a faster reply',NULL,NULL)
		,(4,NULL,NULL,1,3,8,2,1,'Use Unee-T for a faster reply',NULL,NULL)
		,(5,NULL,NULL,1,1,9,4,0,'Use Unee-T for a faster reply',NULL,NULL)
		,(6,NULL,NULL,1,3,9,4,0,'Use Unee-T for a faster reply',NULL,NULL)
		,(7,NULL,NULL,1,2,11,4,0,'Use Unee-T for a faster reply',NULL,NULL)
		,(8,NULL,NULL,1,1,12,1,1,'Use Unee-T for a faster reply',NULL,NULL)
		,(9,NULL,NULL,1,2,14,2,0,'Use Unee-T for a faster reply',NULL,NULL)
		,(10,NULL,NULL,1,1,15,3,0,'Use Unee-T for a faster reply',NULL,NULL)
		,(11,NULL,NULL,1,3,15,3,0,'Use Unee-T for a faster reply',NULL,NULL)
		,(12,NULL,NULL,1,2,17,3,0,'Use Unee-T for a faster reply',NULL,NULL)
		;

# Use the data to associate the users to the units.
# We use the query 3_replace_dummy_role_with_genuine_user_as_default_in_unee-t_bzfe_v2.18.sql for that.

	# Record 1:
		#The unit: What is the id of the record that you want to use in the table 'ut_data_to_replace_dummy_roles'
			SET @reference_for_update = 1;

		#This is needed so that the invitation mechanism works as intended in the MEFE.
				#- Tenant 1
				SET @bz_user_id_dummy_tenant = 4;

				#- Landlord 2
				SET @bz_user_id_dummy_landlord = 3;
				
				#- Contractor 3
				SET @bz_user_id_dummy_contractor = 5;
				
				#- Management company 4
				SET @bz_user_id_dummy_mgt_cny = 6;
				
				#- Agent 5
				SET @bz_user_id_dummy_agent = 2;
			
		#The unit:
			
			#The name and description
				SET @product_id = (SELECT `bz_unit_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

		#The user associated to the first role in this unit.	

			#BZ user id of the user that is creating the unit (default is 1 - Administrator).
			#For LMB migration, we use 2 (support.nobody)
				SET @creator_bz_id = (SELECT `bzfe_invitor_user_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

			#BZ user id of the user that you want to associate to the unit.
				SET @bz_user_id = (SELECT `bz_user_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);
			
			#Role of the user associated to this new unit:
				#- Tenant 1
				#- Landlord 2
				#- Agent 5
				#- Contractor 3
				#- Management company 4
				SET @id_role_type = (SELECT `user_role_type_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);
				SET @role_user_more = (SELECT `user_more` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

			#Is the BZ user an occupant of the unit?
				SET @is_occupant = (SELECT `is_occupant` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

		#We need to get the component for ALL the roles for this product
		#We do that using dummy users for all the roles different from the user role.	
				#- agent -> temporary.agent.dev@unee-t.com
				#- landlord  -> temporary.landlord.dev@unee-t.com
				#- Tenant  -> temporary.tenant.dev@unee-t.com
				#- Contractor  -> temporary.contractor.dev@unee-t.com

		#The Groups to grant the global permissions for the user

			#This should not change, it was hard coded when we created Unee-T
				#See time tracking
				SET @can_see_time_tracking_group_id = 16;
				#Can create shared queries
				SET @can_create_shared_queries_group_id = 17;
				#Can tag comments
				SET @can_tag_comment_group_id = 18;		
				
		#We populate the additional variables that we will need for this script to work
			
			#For the user
				SET @role_user_g_description = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=@id_role_type);
				SET @user_pub_name = (SELECT (LEFT(`login_name`,INSTR(`login_name`,"@")-1)) FROM `profiles` WHERE `userid` = @bz_user_id);
				SET @role_user_pub_info = CONCAT(@user_pub_name
										, IF (@role_user_more = '', '', ' - ')
										, IF (@role_user_more = '', '', @role_user_more)
										)
										;
				SET @user_role_desc = (CONCAT(@role_user_g_description, ' - ',@role_user_pub_info));

			#For the creator
				SET @creator_pub_name = (SELECT `realname` FROM `profiles` WHERE `userid` = @creator_bz_id);

		#Variable needed to avoid script error - NEED TO REVISIT THAT
			SET @can_see_time_tracking = 1;
			SET @can_create_shared_queries = 1;
			SET @can_tag_comment = 1;
			SET @user_is_publicly_visible = 1;
			SET @user_can_see_publicly_visible = 1;
			SET @user_in_cc_for_cases = 0;
			SET @can_create_new_cases = 1;
			SET @can_edit_a_case = 1;
			SET @can_see_all_public_cases = 1;
			SET @can_edit_all_field_in_a_case_regardless_of_role = 1;
			SET @can_ask_to_approve = 1;
			SET @can_approve = 1;
			SET @can_create_any_stakeholder = 0;
			SET @can_create_same_stakeholder = 0;
			SET @can_approve_user_for_flag = 0;
			SET @can_decide_if_user_is_visible = 0;
			SET @can_decide_if_user_can_see_visible = 0;	

		#The user

			#We record the information about the users that we have just created
			#If this is the first time we record something for this user for this unit, we create a new record.
			#If there is already a record for THAT USER for THIS, then we are updating the information
				
				INSERT INTO `ut_map_user_unit_details`
					(`created`
					, `record_created_by`
					, `user_id`
					, `bz_profile_id`
					, `bz_unit_id`
					, `role_type_id`
					, `can_see_time_tracking`
					, `can_create_shared_queries`
					, `can_tag_comment`
					, `is_occupant`
					, `is_public_assignee`
					, `is_see_visible_assignee`
					, `is_in_cc_for_role`
					, `can_create_case`
					, `can_edit_case`
					, `can_see_case`
					, `can_edit_all_field_regardless_of_role`
					, `is_flag_requestee`
					, `is_flag_approver`
					, `can_create_any_sh`
					, `can_create_same_sh`
					, `can_approve_user_for_flags`
					, `can_decide_if_user_visible`
					, `can_decide_if_user_can_see_visible`
					, `public_name`
					, `more_info`
					, `comment`
					)
					VALUES
					(NOW()
					, @creator_bz_id
					, @bz_user_id
					, @bz_user_id
					, @product_id
					, @id_role_type
					#Global permission for the whole installation
					, @can_see_time_tracking
					, @can_create_shared_queries
					, @can_tag_comment
					#Attributes of the user
					, @is_occupant
					#User visibility
					, @user_is_publicly_visible
					, @user_can_see_publicly_visible
					#Permissions for cases for this unit.
					, @user_in_cc_for_cases
					, @can_create_new_cases
					, @can_edit_a_case
					, @can_see_all_public_cases
					, @can_edit_all_field_in_a_case_regardless_of_role
					#For the flags
					, @can_ask_to_approve
					, @can_approve
					#Permissions to create or modify other users
					, @can_create_any_stakeholder
					, @can_create_same_stakeholder
					, @can_approve_user_for_flag
					, @can_decide_if_user_is_visible
					, @can_decide_if_user_can_see_visible
					, @user_pub_name
					, @role_user_more
					, CONCAT('On '
							, NOW()
							, ': Created with the script - '
							, @script
							, '.\r\ '
							, `comment`)
					)
					ON DUPLICATE KEY UPDATE
					`created` = NOW()
					, `record_created_by` = @creator_bz_id
					, `role_type_id` = @id_role_type
					, `can_see_time_tracking` = @can_see_time_tracking
					, `can_create_shared_queries` = @can_create_shared_queries
					, `can_tag_comment` = @can_tag_comment
					, `is_occupant` = @is_occupant
					, `is_public_assignee` = @user_is_publicly_visible
					, `is_see_visible_assignee` = @user_can_see_publicly_visible
					, `is_in_cc_for_role` = @user_in_cc_for_cases
					, `can_create_case` = @can_create_new_cases
					, `can_edit_case` = @can_edit_a_case
					, `can_see_case` = @can_see_all_public_cases
					, `can_edit_all_field_regardless_of_role` = @can_edit_all_field_in_a_case_regardless_of_role
					, `is_flag_requestee` = @can_ask_to_approve
					, `is_flag_approver` = @can_approve
					, `can_create_any_sh` = @can_create_any_stakeholder
					, `can_create_same_sh` = @can_create_same_stakeholder
					, `can_approve_user_for_flags` = @can_approve_user_for_flag
					, `can_decide_if_user_visible` = @can_decide_if_user_is_visible
					, `can_decide_if_user_can_see_visible` = @can_decide_if_user_can_see_visible
					, `public_name` = @user_pub_name
					, `more_info` = CONCAT('On: ', NOW(), '.\r\Updated to ', @role_user_more, '. \r\ ', `more_info`)
					, `comment` = CONCAT('On ', NOW(), '.\r\Updated with the script - ', @script, '.\r\ ', `comment`)
				;

		#We get the information about the goups we need
			#We need to ge these from the ut_product_table_based on the product_id!
				SET @create_case_group_id =  (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 20));
				SET @can_edit_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 25));
				SET @can_see_cases_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 28));
				
				#This is needed until MEFE is able to handle more detailed permissions.
				SET @can_edit_all_field_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 26));
				
				#This is needed so that user can see the unit in the Search panel
				SET @can_see_unit_in_search_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 38));
				
				SET @list_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 4));
				SET @see_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 5));	

				SET @all_r_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 18));
				SET @all_g_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 19));
				
			#Groups created when we created the Role for this product.
				#- show_to_tenant
				#- are_users_tenant
				#- see_users_tenant
				#- show_to_landlord
				#- are_users_landlord
				#- see_users_landlord
				#- show_to_agent
				#- are_users_agent
				#- see_users_agent
				#- show_to_contractor
				#- are_users_contractor
				#- see_users_contractor
				#- show_to_mgt_cny
				#- are_users_mgt_cny
				#- see_users_mgt_cny
				#- show_to_occupant
				#- are_users_occupant
				#- see_users_occupant

				SET @group_id_show_to_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 24));
				SET @group_id_are_users_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 3));
				SET @group_id_see_users_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 36));

				SET @group_id_show_to_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 1));
				SET @group_id_are_users_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 1));
				SET @group_id_see_users_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 1));

				SET @group_id_show_to_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 2));
				SET @group_id_are_users_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 2));
				SET @group_id_see_users_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 2));

				SET @group_id_show_to_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 5));
				SET @group_id_are_users_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 5));
				SET @group_id_see_users_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 5));

				SET @group_id_show_to_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 3));
				SET @group_id_are_users_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 3));
				SET @group_id_see_users_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 3));

				SET @group_id_show_to_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 4));
				SET @group_id_are_users_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 4));
				SET @group_id_see_users_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 4));

		#We get the information about the component/roles that were created:
			
			#We get that from the product_id and dummy user id to make sure that we do not get components with a valid user
				SET @component_id_tenant = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_tenant);
				SET @component_id_landlord = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_landlord);
				SET @component_id_agent = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_agent);
				SET @component_id_contractor = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_contractor);
				SET @component_id_mgt_cny = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_mgt_cny);

			#What is the component_id for this role?
				SET @component_id_this_role = IF( @id_role_type = 1
												, @component_id_tenant
												, IF (@id_role_type = 2
													, @component_id_landlord
													, IF (@id_role_type = 3
														, @component_id_contractor
														, IF (@id_role_type = 4
															, @component_id_mgt_cny
															, IF (@id_role_type = 5
																, @component_id_agent
																, 'Something is very wrong!!'
																)
															)
														)
													)
												)
												;
													
			#We have everything, we can now update the component/role for the unit and make the user default assignee.
				#Get the old values so we can log those
				SET @old_component_initialowner = NULL;
				SET @old_component_initialowner = (SELECT `initialowner` FROM `components` WHERE `id` = @component_id_this_role);
				SET @old_component_initialqacontact = NULL;
				SET @old_component_initialqacontact = (SELECT `initialqacontact` FROM `components` WHERE `id` = @component_id_this_role);
				SET @old_component_description = NULL;
				SET @old_component_description = (SELECT `description` FROM `components` WHERE `id` = @component_id_this_role);
				
				#Update
				UPDATE `components`
				SET 
					`initialowner` = @bz_user_id
					,`initialqacontact` = @bz_user_id
					,`description` = @user_role_desc
					WHERE 
					`id` = @component_id_this_role
					;
				
			#Log the actions of the script.
				SET @script_log_message = CONCAT('The component: '
										, (SELECT IFNULL(@component_id_this_role, 'component_id_this_role is NULL'))
										, ' (for the role_type_id #'
										, (SELECT IFNULL(@id_role_type, 'id_role_type is NULL'))
										, ') has been updated.'
										, '\r\The default user now associated to this role is bz user #'
										, (SELECT IFNULL(@bz_user_id, 'bz_user_id is NULL'))
										, ' (real name: '
										, (SELECT IFNULL(@user_pub_name, 'user_pub_name is NULL'))
										, ') for the unit #' 
										, @product_id
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;
				
				SET @script_log_message = NULL;	
					
		#We update the BZ logs
			INSERT  INTO `audit_log`
				(`user_id`
				,`class`
				,`object_id`
				,`field`
				,`removed`
				,`added`
				,`at_time`
				) 
				VALUES 
				(@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'initialowner',@old_component_initialowner,@bz_user_id,@timestamp)
				, (@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'initialqacontact',@old_component_initialqacontact,@bz_user_id,@timestamp)
				, (@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'description',@old_component_description,@user_role_desc,@timestamp)
				;	
				
		#We now assign the default permissions to the user we just associated to this role:		
			
			#We use a temporary table to make sure we do not have duplicates.
				
				#DELETE the temp table if it exists
				DROP TABLE IF EXISTS `ut_user_group_map_temp`;
				
				#Re-create the temp table
				CREATE TABLE `ut_user_group_map_temp` (
				  `user_id` MEDIUMINT(9) NOT NULL,
				  `group_id` MEDIUMINT(9) NOT NULL,
				  `isbless` TINYINT(4) NOT NULL DEFAULT '0',
				  `grant_type` TINYINT(4) NOT NULL DEFAULT '0'
				) ENGINE=INNODB DEFAULT CHARSET=utf8;

				#Add all the records that exists in the table user_group_map
				INSERT INTO `ut_user_group_map_temp`
					SELECT *
					FROM `user_group_map`;

			#We need to get the id of these groups from the 'ut_product_group' table_based on the product_id
				#For the user - based on the user role:
					#Visibility group
					SET @group_id_show_to_user_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = @id_role_type));
				
					#Is in user Group for the role we just created
					SET @group_id_are_users_same_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = @id_role_type));
					
					#Can See other users in the same Group
					SET @group_id_see_users_same_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = @id_role_type));


		#The default permissions for a user assigned as default for a role are:
		#
			#- time_tracking_permission
			#- can_create_shared_queries
			#- can_tag_comment
		#
			#- can_create_new_cases
			#- can_edit_a_case
			#- can_edit_all_field_case
			#- can_see_unit_in_search
			#- can_see_all_public_cases
			#- user_is_publicly_visible
			#- user_can_see_publicly_visible
			#- can_ask_to_approve (all_r_flags_group_id)
			#- can_approve (all_g_flags_group_id)
		#
		#We create the procedures that will grant the permissions based on the variables from this script.	
		#
			#- show_to_his_role
			#- is_one_of_his_role
			#- can_see_other_in_same_role
		#
		#If applicable
			#- show_to_occupant
			#- is_occupant
			#- can_see_occupant

			#First the global permissions:
				#Can see timetracking
					INSERT  INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id,@can_see_time_tracking_group_id,0,0)
						;
						
					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN See time tracking information.'
												);
					
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						
						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to see time tracking')
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_time_tracking_group_id, @script, 'Add the BZ group id when we grant the permission to see time tracking')
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant see time tracking permission')
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group see time tracking')
							 ;
						 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
			
				#Can create shared queries
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id,@can_create_shared_queries_group_id,0,0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN create shared queries.'
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table

						SET @bzfe_table = 'ut_user_group_map_temp';

						INSERT INTO `ut_audit_log`
								 (`datetime`
								 , `bzfe_table`
								 , `bzfe_field`
								 , `previous_value`
								 , `new_value`
								 , `script`
								 , `comment`
								 )
								 VALUES
								 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to create shared queries')
								 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_create_shared_queries_group_id, @script, 'Add the BZ group id when we grant the permission to create shared queries')
								 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant create shared queries permission')
								 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group create shared queries')
								 ;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;

				#Can tag comments
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id,@can_tag_comment_group_id,0,0)
						;
						
					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN tag comments.'
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to tag comments')
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_tag_comment_group_id, @script, 'Add the BZ group id when we grant the permission to tag comments')
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant tag comments permission')
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group tag comments')
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
			
			#Then the permissions at the unit/product level:	
							
				#User can create a case:
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						#There can be cases when a user is only allowed to see existing cases but NOT create new one.
						#This is an unlikely scenario, but this is technically possible...
						(@bz_user_id, @create_case_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN create new cases for unit '
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'create a new case.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
				#User is allowed to edit cases
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_edit_case_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN edit a cases for unit '
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'edit a case in this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_edit_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
				#User can see the case in the unit even if they are not for his role
					#This allows a user to see the 'public' cases for a given unit.
					#A 'public' case can still only be seen by users in this group!
					#We might NOT want this for employees of a contractor that only need to see the cases IF the case is restricted to
					#the contractor role but NOT if the case is for anyone
					#This is an unlikely scenario, but this is technically possible (ex for technician for a contractor)...
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_see_cases_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN see all public cases for unit '
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'see all public case in this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_cases_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
				#User can edit all fields in the case regardless of his/her role
					#This is needed so until the MEFE can handle permissions.
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_edit_all_field_case_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' can edit all fields in the case regardless of his/her role for the unit#'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'Can edit all fields in the case regardless of his/her role.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_edit_all_field_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;

				#User Can see the unit in the Search panel
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_see_unit_in_search_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' can see the unit#'
												, @product_id
												, ' in the search panel.'
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'Can see the unit in the Search panel.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_unit_in_search_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
				
				#User can be visible to other users regardless of the other users roles
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @list_visible_assignees_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' is one of the visible assignee for cases for this unit.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'is one of the visible assignee for cases for this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @list_visible_assignees_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;

				#User can be visible to other users regardless of the other users roles
					#The below membership is needed so the user can see all the other users regardless of the other users roles
					#We might hide the visible users to some other user (ex: housekeepers or field person do not need to see lanlord or agent
					#They just need to see their manager)
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @see_visible_assignees_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN see the publicly visible users for the case for this unit.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = ' CAN see the publicly visible users for the case for this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @see_visible_assignees_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;				

				#user can create flags (approval requests)				
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES
						(@bz_user_id, @all_r_flags_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN ask for approval for all flags.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = ' CAN ask for approval for all flags.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @all_r_flags_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;	
						
				#user can approve all the flags
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES
						(@bz_user_id, @all_g_flags_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN approve for all flags.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = ' CAN approve for all flags.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @all_g_flags_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
			#Then the permissions that are relevant to the component/role
			#These are conditional as this depends on the role attributed to that user
				
		#We CALL ALL the procedures that we have created TO CREATE the permissions we need:
			CALL show_to_tenant;
			CALL is_tenant;
			CALL default_tenant_can_see_tenant;

			CALL show_to_landlord;
			CALL are_users_landlord;
			CALL default_landlord_see_users_landlord;

			CALL show_to_agent;
			CALL are_users_agent;
			CALL default_agent_see_users_agent;

			CALL show_to_contractor;
			CALL are_users_contractor;
			CALL default_contractor_see_users_contractor;

			CALL show_to_mgt_cny;
			CALL are_users_mgt_cny;
			CALL default_mgt_cny_see_users_mgt_cny;
			
			CALL show_to_occupant;
			CALL is_occupant;
			CALL default_occupant_can_see_occupant;
				
		#We give the user the permission they need.

			#We update the `user_group_map` table
				
				#We truncate the table first (to avoid duplicates)
					TRUNCATE TABLE `user_group_map`;
					
				#We insert the data we need
					INSERT INTO `user_group_map`
					SELECT `user_id`
						, `group_id`
						, `isbless`
						, `grant_type`
					FROM
						`ut_user_group_map_temp`
					GROUP BY `user_id`
						, `group_id`
						, `isbless`
						, `grant_type`
					;

		#Update the table 'ut_data_to_replace_dummy_roles' so that we record what we have done
			UPDATE `ut_data_to_replace_dummy_roles`
			SET 
				`bz_created_date` = @timestamp
				, `comment` = CONCAT ('inserted in BZ with the script \''
						, @script
						, '\'\r\ '
						, IFNULL(`comment`, '')
						)
			WHERE `id` = @reference_for_update;
					
		#Clean up
				
			#We Delete the temp table as we do not need it anymore
				DROP TABLE IF EXISTS `ut_user_group_map_temp`;

	# Record 2:
		#The unit: What is the id of the record that you want to use in the table 'ut_data_to_replace_dummy_roles'
			SET @reference_for_update = 2;

		#Environment: Which environment are you creatin the unit in?
			#- 1 is for the DEV/Staging
			#- 2 is for the prod environment
			SET @environment = 1;

		#This is needed so that the invitation mechanism works as intended in the MEFE.
				#- Tenant 1
				SET @bz_user_id_dummy_tenant = 4;

				#- Landlord 2
				SET @bz_user_id_dummy_landlord = 3;
				
				#- Contractor 3
				SET @bz_user_id_dummy_contractor = 5;
				
				#- Management company 4
				SET @bz_user_id_dummy_mgt_cny = 6;
				
				#- Agent 5
				SET @bz_user_id_dummy_agent = 2;
			
		#The unit:
			
			#The name and description
				SET @product_id = (SELECT `bz_unit_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

		#The user associated to the first role in this unit.	

			#BZ user id of the user that is creating the unit (default is 1 - Administrator).
			#For LMB migration, we use 2 (support.nobody)
				SET @creator_bz_id = (SELECT `bzfe_invitor_user_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

			#BZ user id of the user that you want to associate to the unit.
				SET @bz_user_id = (SELECT `bz_user_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);
			
			#Role of the user associated to this new unit:
				#- Tenant 1
				#- Landlord 2
				#- Agent 5
				#- Contractor 3
				#- Management company 4
				SET @id_role_type = (SELECT `user_role_type_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);
				SET @role_user_more = (SELECT `user_more` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

			#Is the BZ user an occupant of the unit?
				SET @is_occupant = (SELECT `is_occupant` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

		#We need to get the component for ALL the roles for this product
		#We do that using dummy users for all the roles different from the user role.	
				#- agent -> temporary.agent.dev@unee-t.com
				#- landlord  -> temporary.landlord.dev@unee-t.com
				#- Tenant  -> temporary.tenant.dev@unee-t.com
				#- Contractor  -> temporary.contractor.dev@unee-t.com

		#The Groups to grant the global permissions for the user

			#This should not change, it was hard coded when we created Unee-T
				#See time tracking
				SET @can_see_time_tracking_group_id = 16;
				#Can create shared queries
				SET @can_create_shared_queries_group_id = 17;
				#Can tag comments
				SET @can_tag_comment_group_id = 18;		
				
		#We populate the additional variables that we will need for this script to work
			
			#For the user
				SET @role_user_g_description = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=@id_role_type);
				SET @user_pub_name = (SELECT (LEFT(`login_name`,INSTR(`login_name`,"@")-1)) FROM `profiles` WHERE `userid` = @bz_user_id);
				SET @role_user_pub_info = CONCAT(@user_pub_name
										, IF (@role_user_more = '', '', ' - ')
										, IF (@role_user_more = '', '', @role_user_more)
										)
										;
				SET @user_role_desc = (CONCAT(@role_user_g_description, ' - ',@role_user_pub_info));

			#For the creator
				SET @creator_pub_name = (SELECT `realname` FROM `profiles` WHERE `userid` = @creator_bz_id);

		#Variable needed to avoid script error - NEED TO REVISIT THAT
			SET @can_see_time_tracking = 1;
			SET @can_create_shared_queries = 1;
			SET @can_tag_comment = 1;
			SET @user_is_publicly_visible = 1;
			SET @user_can_see_publicly_visible = 1;
			SET @user_in_cc_for_cases = 0;
			SET @can_create_new_cases = 1;
			SET @can_edit_a_case = 1;
			SET @can_see_all_public_cases = 1;
			SET @can_edit_all_field_in_a_case_regardless_of_role = 1;
			SET @can_ask_to_approve = 1;
			SET @can_approve = 1;
			SET @can_create_any_stakeholder = 0;
			SET @can_create_same_stakeholder = 0;
			SET @can_approve_user_for_flag = 0;
			SET @can_decide_if_user_is_visible = 0;
			SET @can_decide_if_user_can_see_visible = 0;	

		#The user

			#We record the information about the users that we have just created
			#If this is the first time we record something for this user for this unit, we create a new record.
			#If there is already a record for THAT USER for THIS, then we are updating the information
				
				INSERT INTO `ut_map_user_unit_details`
					(`created`
					, `record_created_by`
					, `user_id`
					, `bz_profile_id`
					, `bz_unit_id`
					, `role_type_id`
					, `can_see_time_tracking`
					, `can_create_shared_queries`
					, `can_tag_comment`
					, `is_occupant`
					, `is_public_assignee`
					, `is_see_visible_assignee`
					, `is_in_cc_for_role`
					, `can_create_case`
					, `can_edit_case`
					, `can_see_case`
					, `can_edit_all_field_regardless_of_role`
					, `is_flag_requestee`
					, `is_flag_approver`
					, `can_create_any_sh`
					, `can_create_same_sh`
					, `can_approve_user_for_flags`
					, `can_decide_if_user_visible`
					, `can_decide_if_user_can_see_visible`
					, `public_name`
					, `more_info`
					, `comment`
					)
					VALUES
					(NOW()
					, @creator_bz_id
					, @bz_user_id
					, @bz_user_id
					, @product_id
					, @id_role_type
					#Global permission for the whole installation
					, @can_see_time_tracking
					, @can_create_shared_queries
					, @can_tag_comment
					#Attributes of the user
					, @is_occupant
					#User visibility
					, @user_is_publicly_visible
					, @user_can_see_publicly_visible
					#Permissions for cases for this unit.
					, @user_in_cc_for_cases
					, @can_create_new_cases
					, @can_edit_a_case
					, @can_see_all_public_cases
					, @can_edit_all_field_in_a_case_regardless_of_role
					#For the flags
					, @can_ask_to_approve
					, @can_approve
					#Permissions to create or modify other users
					, @can_create_any_stakeholder
					, @can_create_same_stakeholder
					, @can_approve_user_for_flag
					, @can_decide_if_user_is_visible
					, @can_decide_if_user_can_see_visible
					, @user_pub_name
					, @role_user_more
					, CONCAT('On '
							, NOW()
							, ': Created with the script - '
							, @script
							, '.\r\ '
							, `comment`)
					)
					ON DUPLICATE KEY UPDATE
					`created` = NOW()
					, `record_created_by` = @creator_bz_id
					, `role_type_id` = @id_role_type
					, `can_see_time_tracking` = @can_see_time_tracking
					, `can_create_shared_queries` = @can_create_shared_queries
					, `can_tag_comment` = @can_tag_comment
					, `is_occupant` = @is_occupant
					, `is_public_assignee` = @user_is_publicly_visible
					, `is_see_visible_assignee` = @user_can_see_publicly_visible
					, `is_in_cc_for_role` = @user_in_cc_for_cases
					, `can_create_case` = @can_create_new_cases
					, `can_edit_case` = @can_edit_a_case
					, `can_see_case` = @can_see_all_public_cases
					, `can_edit_all_field_regardless_of_role` = @can_edit_all_field_in_a_case_regardless_of_role
					, `is_flag_requestee` = @can_ask_to_approve
					, `is_flag_approver` = @can_approve
					, `can_create_any_sh` = @can_create_any_stakeholder
					, `can_create_same_sh` = @can_create_same_stakeholder
					, `can_approve_user_for_flags` = @can_approve_user_for_flag
					, `can_decide_if_user_visible` = @can_decide_if_user_is_visible
					, `can_decide_if_user_can_see_visible` = @can_decide_if_user_can_see_visible
					, `public_name` = @user_pub_name
					, `more_info` = CONCAT('On: ', NOW(), '.\r\Updated to ', @role_user_more, '. \r\ ', `more_info`)
					, `comment` = CONCAT('On ', NOW(), '.\r\Updated with the script - ', @script, '.\r\ ', `comment`)
				;

		#We get the information about the goups we need
			#We need to ge these from the ut_product_table_based on the product_id!
				SET @create_case_group_id =  (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 20));
				SET @can_edit_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 25));
				SET @can_see_cases_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 28));
				
				#This is needed until MEFE is able to handle more detailed permissions.
				SET @can_edit_all_field_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 26));
				
				#This is needed so that user can see the unit in the Search panel
				SET @can_see_unit_in_search_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 38));
				
				SET @list_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 4));
				SET @see_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 5));	

				SET @all_r_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 18));
				SET @all_g_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 19));
				
			#Groups created when we created the Role for this product.
				#- show_to_tenant
				#- are_users_tenant
				#- see_users_tenant
				#- show_to_landlord
				#- are_users_landlord
				#- see_users_landlord
				#- show_to_agent
				#- are_users_agent
				#- see_users_agent
				#- show_to_contractor
				#- are_users_contractor
				#- see_users_contractor
				#- show_to_mgt_cny
				#- are_users_mgt_cny
				#- see_users_mgt_cny
				#- show_to_occupant
				#- are_users_occupant
				#- see_users_occupant

				SET @group_id_show_to_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 24));
				SET @group_id_are_users_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 3));
				SET @group_id_see_users_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 36));

				SET @group_id_show_to_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 1));
				SET @group_id_are_users_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 1));
				SET @group_id_see_users_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 1));

				SET @group_id_show_to_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 2));
				SET @group_id_are_users_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 2));
				SET @group_id_see_users_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 2));

				SET @group_id_show_to_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 5));
				SET @group_id_are_users_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 5));
				SET @group_id_see_users_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 5));

				SET @group_id_show_to_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 3));
				SET @group_id_are_users_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 3));
				SET @group_id_see_users_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 3));

				SET @group_id_show_to_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 4));
				SET @group_id_are_users_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 4));
				SET @group_id_see_users_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 4));

		#We get the information about the component/roles that were created:
			
			#We get that from the product_id and dummy user id to make sure that we do not get components with a valid user
				SET @component_id_tenant = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_tenant);
				SET @component_id_landlord = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_landlord);
				SET @component_id_agent = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_agent);
				SET @component_id_contractor = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_contractor);
				SET @component_id_mgt_cny = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_mgt_cny);

			#What is the component_id for this role?
				SET @component_id_this_role = IF( @id_role_type = 1
												, @component_id_tenant
												, IF (@id_role_type = 2
													, @component_id_landlord
													, IF (@id_role_type = 3
														, @component_id_contractor
														, IF (@id_role_type = 4
															, @component_id_mgt_cny
															, IF (@id_role_type = 5
																, @component_id_agent
																, 'Something is very wrong!!'
																)
															)
														)
													)
												)
												;
													
			#We have everything, we can now update the component/role for the unit and make the user default assignee.
				#Get the old values so we can log those
				SET @old_component_initialowner = NULL;
				SET @old_component_initialowner = (SELECT `initialowner` FROM `components` WHERE `id` = @component_id_this_role);
				SET @old_component_initialqacontact = NULL;
				SET @old_component_initialqacontact = (SELECT `initialqacontact` FROM `components` WHERE `id` = @component_id_this_role);
				SET @old_component_description = NULL;
				SET @old_component_description = (SELECT `description` FROM `components` WHERE `id` = @component_id_this_role);
				
				#Update
				UPDATE `components`
				SET 
					`initialowner` = @bz_user_id
					,`initialqacontact` = @bz_user_id
					,`description` = @user_role_desc
					WHERE 
					`id` = @component_id_this_role
					;
				
			#Log the actions of the script.
				SET @script_log_message = CONCAT('The component: '
										, (SELECT IFNULL(@component_id_this_role, 'component_id_this_role is NULL'))
										, ' (for the role_type_id #'
										, (SELECT IFNULL(@id_role_type, 'id_role_type is NULL'))
										, ') has been updated.'
										, '\r\The default user now associated to this role is bz user #'
										, (SELECT IFNULL(@bz_user_id, 'bz_user_id is NULL'))
										, ' (real name: '
										, (SELECT IFNULL(@user_pub_name, 'user_pub_name is NULL'))
										, ') for the unit #' 
										, @product_id
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;
				
				SET @script_log_message = NULL;	
					
		#We update the BZ logs
			INSERT  INTO `audit_log`
				(`user_id`
				,`class`
				,`object_id`
				,`field`
				,`removed`
				,`added`
				,`at_time`
				) 
				VALUES 
				(@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'initialowner',@old_component_initialowner,@bz_user_id,@timestamp)
				, (@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'initialqacontact',@old_component_initialqacontact,@bz_user_id,@timestamp)
				, (@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'description',@old_component_description,@user_role_desc,@timestamp)
				;	
				
		#We now assign the default permissions to the user we just associated to this role:		
			
			#We use a temporary table to make sure we do not have duplicates.
				
				#DELETE the temp table if it exists
				DROP TABLE IF EXISTS `ut_user_group_map_temp`;
				
				#Re-create the temp table
				CREATE TABLE `ut_user_group_map_temp` (
				  `user_id` MEDIUMINT(9) NOT NULL,
				  `group_id` MEDIUMINT(9) NOT NULL,
				  `isbless` TINYINT(4) NOT NULL DEFAULT '0',
				  `grant_type` TINYINT(4) NOT NULL DEFAULT '0'
				) ENGINE=INNODB DEFAULT CHARSET=utf8;

				#Add all the records that exists in the table user_group_map
				INSERT INTO `ut_user_group_map_temp`
					SELECT *
					FROM `user_group_map`;

			#We need to get the id of these groups from the 'ut_product_group' table_based on the product_id
				#For the user - based on the user role:
					#Visibility group
					SET @group_id_show_to_user_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = @id_role_type));
				
					#Is in user Group for the role we just created
					SET @group_id_are_users_same_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = @id_role_type));
					
					#Can See other users in the same Group
					SET @group_id_see_users_same_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = @id_role_type));


		#The default permissions for a user assigned as default for a role are:
		#
			#- time_tracking_permission
			#- can_create_shared_queries
			#- can_tag_comment
		#
			#- can_create_new_cases
			#- can_edit_a_case
			#- can_edit_all_field_case
			#- can_see_unit_in_search
			#- can_see_all_public_cases
			#- user_is_publicly_visible
			#- user_can_see_publicly_visible
			#- can_ask_to_approve (all_r_flags_group_id)
			#- can_approve (all_g_flags_group_id)
		#
		#We create the procedures that will grant the permissions based on the variables from this script.	
		#
			#- show_to_his_role
			#- is_one_of_his_role
			#- can_see_other_in_same_role
		#
		#If applicable
			#- show_to_occupant
			#- is_occupant
			#- can_see_occupant

			#First the global permissions:
				#Can see timetracking
					INSERT  INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id,@can_see_time_tracking_group_id,0,0)
						;
						
					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN See time tracking information.'
												);
					
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						
						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to see time tracking')
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_time_tracking_group_id, @script, 'Add the BZ group id when we grant the permission to see time tracking')
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant see time tracking permission')
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group see time tracking')
							 ;
						 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
			
				#Can create shared queries
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id,@can_create_shared_queries_group_id,0,0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN create shared queries.'
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table

						SET @bzfe_table = 'ut_user_group_map_temp';

						INSERT INTO `ut_audit_log`
								 (`datetime`
								 , `bzfe_table`
								 , `bzfe_field`
								 , `previous_value`
								 , `new_value`
								 , `script`
								 , `comment`
								 )
								 VALUES
								 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to create shared queries')
								 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_create_shared_queries_group_id, @script, 'Add the BZ group id when we grant the permission to create shared queries')
								 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant create shared queries permission')
								 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group create shared queries')
								 ;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;

				#Can tag comments
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id,@can_tag_comment_group_id,0,0)
						;
						
					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN tag comments.'
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to tag comments')
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_tag_comment_group_id, @script, 'Add the BZ group id when we grant the permission to tag comments')
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant tag comments permission')
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group tag comments')
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
			
			#Then the permissions at the unit/product level:	
							
				#User can create a case:
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						#There can be cases when a user is only allowed to see existing cases but NOT create new one.
						#This is an unlikely scenario, but this is technically possible...
						(@bz_user_id, @create_case_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN create new cases for unit '
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'create a new case.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
				#User is allowed to edit cases
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_edit_case_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN edit a cases for unit '
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'edit a case in this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_edit_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
				#User can see the case in the unit even if they are not for his role
					#This allows a user to see the 'public' cases for a given unit.
					#A 'public' case can still only be seen by users in this group!
					#We might NOT want this for employees of a contractor that only need to see the cases IF the case is restricted to
					#the contractor role but NOT if the case is for anyone
					#This is an unlikely scenario, but this is technically possible (ex for technician for a contractor)...
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_see_cases_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN see all public cases for unit '
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'see all public case in this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_cases_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
				#User can edit all fields in the case regardless of his/her role
					#This is needed so until the MEFE can handle permissions.
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_edit_all_field_case_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' can edit all fields in the case regardless of his/her role for the unit#'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'Can edit all fields in the case regardless of his/her role.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_edit_all_field_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;

				#User Can see the unit in the Search panel
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_see_unit_in_search_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' can see the unit#'
												, @product_id
												, ' in the search panel.'
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'Can see the unit in the Search panel.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_unit_in_search_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
				
				#User can be visible to other users regardless of the other users roles
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @list_visible_assignees_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' is one of the visible assignee for cases for this unit.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'is one of the visible assignee for cases for this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @list_visible_assignees_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;

				#User can be visible to other users regardless of the other users roles
					#The below membership is needed so the user can see all the other users regardless of the other users roles
					#We might hide the visible users to some other user (ex: housekeepers or field person do not need to see lanlord or agent
					#They just need to see their manager)
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @see_visible_assignees_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN see the publicly visible users for the case for this unit.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = ' CAN see the publicly visible users for the case for this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @see_visible_assignees_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;				

				#user can create flags (approval requests)				
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES
						(@bz_user_id, @all_r_flags_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN ask for approval for all flags.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = ' CAN ask for approval for all flags.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @all_r_flags_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;	
						
				#user can approve all the flags
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES
						(@bz_user_id, @all_g_flags_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN approve for all flags.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = ' CAN approve for all flags.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @all_g_flags_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
				
		#We CALL ALL the procedures that we have created TO CREATE the permissions we need:
			CALL show_to_tenant;
			CALL is_tenant;
			CALL default_tenant_can_see_tenant;

			CALL show_to_landlord;
			CALL are_users_landlord;
			CALL default_landlord_see_users_landlord;

			CALL show_to_agent;
			CALL are_users_agent;
			CALL default_agent_see_users_agent;

			CALL show_to_contractor;
			CALL are_users_contractor;
			CALL default_contractor_see_users_contractor;

			CALL show_to_mgt_cny;
			CALL are_users_mgt_cny;
			CALL default_mgt_cny_see_users_mgt_cny;
			
			CALL show_to_occupant;
			CALL is_occupant;
			CALL default_occupant_can_see_occupant;
				
		#We give the user the permission they need.

			#We update the `user_group_map` table
				
				#We truncate the table first (to avoid duplicates)
					TRUNCATE TABLE `user_group_map`;
					
				#We insert the data we need
					INSERT INTO `user_group_map`
					SELECT `user_id`
						, `group_id`
						, `isbless`
						, `grant_type`
					FROM
						`ut_user_group_map_temp`
					GROUP BY `user_id`
						, `group_id`
						, `isbless`
						, `grant_type`
					;

		#Update the table 'ut_data_to_replace_dummy_roles' so that we record what we have done
			UPDATE `ut_data_to_replace_dummy_roles`
			SET 
				`bz_created_date` = @timestamp
				, `comment` = CONCAT ('inserted in BZ with the script \''
						, @script
						, '\'\r\ '
						, IFNULL(`comment`, '')
						)
			WHERE `id` = @reference_for_update;
					
		#Clean up
				
			#We Delete the temp table as we do not need it anymore
				DROP TABLE IF EXISTS `ut_user_group_map_temp`;
	
	# Record 3:
		#The unit: What is the id of the record that you want to use in the table 'ut_data_to_replace_dummy_roles'
			SET @reference_for_update = 3;

		#Environment: Which environment are you creatin the unit in?
			#- 1 is for the DEV/Staging
			#- 2 is for the prod environment
			SET @environment = 1;

		#This is needed so that the invitation mechanism works as intended in the MEFE.
				#- Tenant 1
				SET @bz_user_id_dummy_tenant = 4;

				#- Landlord 2
				SET @bz_user_id_dummy_landlord = 3;
				
				#- Contractor 3
				SET @bz_user_id_dummy_contractor = 5;
				
				#- Management company 4
				SET @bz_user_id_dummy_mgt_cny = 6;
				
				#- Agent 5
				SET @bz_user_id_dummy_agent = 2;
			
		#The unit:
			
			#The name and description
				SET @product_id = (SELECT `bz_unit_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

		#The user associated to the first role in this unit.	

			#BZ user id of the user that is creating the unit (default is 1 - Administrator).
			#For LMB migration, we use 2 (support.nobody)
				SET @creator_bz_id = (SELECT `bzfe_invitor_user_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

			#BZ user id of the user that you want to associate to the unit.
				SET @bz_user_id = (SELECT `bz_user_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);
			
			#Role of the user associated to this new unit:
				#- Tenant 1
				#- Landlord 2
				#- Agent 5
				#- Contractor 3
				#- Management company 4
				SET @id_role_type = (SELECT `user_role_type_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);
				SET @role_user_more = (SELECT `user_more` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

			#Is the BZ user an occupant of the unit?
				SET @is_occupant = (SELECT `is_occupant` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

		#We need to get the component for ALL the roles for this product
		#We do that using dummy users for all the roles different from the user role.	
				#- agent -> temporary.agent.dev@unee-t.com
				#- landlord  -> temporary.landlord.dev@unee-t.com
				#- Tenant  -> temporary.tenant.dev@unee-t.com
				#- Contractor  -> temporary.contractor.dev@unee-t.com

		#The Groups to grant the global permissions for the user

			#This should not change, it was hard coded when we created Unee-T
				#See time tracking
				SET @can_see_time_tracking_group_id = 16;
				#Can create shared queries
				SET @can_create_shared_queries_group_id = 17;
				#Can tag comments
				SET @can_tag_comment_group_id = 18;		
				
		#We populate the additional variables that we will need for this script to work
			
			#For the user
				SET @role_user_g_description = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=@id_role_type);
				SET @user_pub_name = (SELECT (LEFT(`login_name`,INSTR(`login_name`,"@")-1)) FROM `profiles` WHERE `userid` = @bz_user_id);
				SET @role_user_pub_info = CONCAT(@user_pub_name
										, IF (@role_user_more = '', '', ' - ')
										, IF (@role_user_more = '', '', @role_user_more)
										)
										;
				SET @user_role_desc = (CONCAT(@role_user_g_description, ' - ',@role_user_pub_info));

			#For the creator
				SET @creator_pub_name = (SELECT `realname` FROM `profiles` WHERE `userid` = @creator_bz_id);

		#Variable needed to avoid script error - NEED TO REVISIT THAT
			SET @can_see_time_tracking = 1;
			SET @can_create_shared_queries = 1;
			SET @can_tag_comment = 1;
			SET @user_is_publicly_visible = 1;
			SET @user_can_see_publicly_visible = 1;
			SET @user_in_cc_for_cases = 0;
			SET @can_create_new_cases = 1;
			SET @can_edit_a_case = 1;
			SET @can_see_all_public_cases = 1;
			SET @can_edit_all_field_in_a_case_regardless_of_role = 1;
			SET @can_ask_to_approve = 1;
			SET @can_approve = 1;
			SET @can_create_any_stakeholder = 0;
			SET @can_create_same_stakeholder = 0;
			SET @can_approve_user_for_flag = 0;
			SET @can_decide_if_user_is_visible = 0;
			SET @can_decide_if_user_can_see_visible = 0;	

		#The user

			#We record the information about the users that we have just created
			#If this is the first time we record something for this user for this unit, we create a new record.
			#If there is already a record for THAT USER for THIS, then we are updating the information
				
				INSERT INTO `ut_map_user_unit_details`
					(`created`
					, `record_created_by`
					, `user_id`
					, `bz_profile_id`
					, `bz_unit_id`
					, `role_type_id`
					, `can_see_time_tracking`
					, `can_create_shared_queries`
					, `can_tag_comment`
					, `is_occupant`
					, `is_public_assignee`
					, `is_see_visible_assignee`
					, `is_in_cc_for_role`
					, `can_create_case`
					, `can_edit_case`
					, `can_see_case`
					, `can_edit_all_field_regardless_of_role`
					, `is_flag_requestee`
					, `is_flag_approver`
					, `can_create_any_sh`
					, `can_create_same_sh`
					, `can_approve_user_for_flags`
					, `can_decide_if_user_visible`
					, `can_decide_if_user_can_see_visible`
					, `public_name`
					, `more_info`
					, `comment`
					)
					VALUES
					(NOW()
					, @creator_bz_id
					, @bz_user_id
					, @bz_user_id
					, @product_id
					, @id_role_type
					#Global permission for the whole installation
					, @can_see_time_tracking
					, @can_create_shared_queries
					, @can_tag_comment
					#Attributes of the user
					, @is_occupant
					#User visibility
					, @user_is_publicly_visible
					, @user_can_see_publicly_visible
					#Permissions for cases for this unit.
					, @user_in_cc_for_cases
					, @can_create_new_cases
					, @can_edit_a_case
					, @can_see_all_public_cases
					, @can_edit_all_field_in_a_case_regardless_of_role
					#For the flags
					, @can_ask_to_approve
					, @can_approve
					#Permissions to create or modify other users
					, @can_create_any_stakeholder
					, @can_create_same_stakeholder
					, @can_approve_user_for_flag
					, @can_decide_if_user_is_visible
					, @can_decide_if_user_can_see_visible
					, @user_pub_name
					, @role_user_more
					, CONCAT('On '
							, NOW()
							, ': Created with the script - '
							, @script
							, '.\r\ '
							, `comment`)
					)
					ON DUPLICATE KEY UPDATE
					`created` = NOW()
					, `record_created_by` = @creator_bz_id
					, `role_type_id` = @id_role_type
					, `can_see_time_tracking` = @can_see_time_tracking
					, `can_create_shared_queries` = @can_create_shared_queries
					, `can_tag_comment` = @can_tag_comment
					, `is_occupant` = @is_occupant
					, `is_public_assignee` = @user_is_publicly_visible
					, `is_see_visible_assignee` = @user_can_see_publicly_visible
					, `is_in_cc_for_role` = @user_in_cc_for_cases
					, `can_create_case` = @can_create_new_cases
					, `can_edit_case` = @can_edit_a_case
					, `can_see_case` = @can_see_all_public_cases
					, `can_edit_all_field_regardless_of_role` = @can_edit_all_field_in_a_case_regardless_of_role
					, `is_flag_requestee` = @can_ask_to_approve
					, `is_flag_approver` = @can_approve
					, `can_create_any_sh` = @can_create_any_stakeholder
					, `can_create_same_sh` = @can_create_same_stakeholder
					, `can_approve_user_for_flags` = @can_approve_user_for_flag
					, `can_decide_if_user_visible` = @can_decide_if_user_is_visible
					, `can_decide_if_user_can_see_visible` = @can_decide_if_user_can_see_visible
					, `public_name` = @user_pub_name
					, `more_info` = CONCAT('On: ', NOW(), '.\r\Updated to ', @role_user_more, '. \r\ ', `more_info`)
					, `comment` = CONCAT('On ', NOW(), '.\r\Updated with the script - ', @script, '.\r\ ', `comment`)
				;

		#We get the information about the goups we need
			#We need to ge these from the ut_product_table_based on the product_id!
				SET @create_case_group_id =  (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 20));
				SET @can_edit_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 25));
				SET @can_see_cases_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 28));
				
				#This is needed until MEFE is able to handle more detailed permissions.
				SET @can_edit_all_field_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 26));
				
				#This is needed so that user can see the unit in the Search panel
				SET @can_see_unit_in_search_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 38));
				
				SET @list_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 4));
				SET @see_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 5));	

				SET @all_r_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 18));
				SET @all_g_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 19));
				
			#Groups created when we created the Role for this product.
				#- show_to_tenant
				#- are_users_tenant
				#- see_users_tenant
				#- show_to_landlord
				#- are_users_landlord
				#- see_users_landlord
				#- show_to_agent
				#- are_users_agent
				#- see_users_agent
				#- show_to_contractor
				#- are_users_contractor
				#- see_users_contractor
				#- show_to_mgt_cny
				#- are_users_mgt_cny
				#- see_users_mgt_cny
				#- show_to_occupant
				#- are_users_occupant
				#- see_users_occupant

				SET @group_id_show_to_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 24));
				SET @group_id_are_users_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 3));
				SET @group_id_see_users_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 36));

				SET @group_id_show_to_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 1));
				SET @group_id_are_users_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 1));
				SET @group_id_see_users_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 1));

				SET @group_id_show_to_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 2));
				SET @group_id_are_users_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 2));
				SET @group_id_see_users_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 2));

				SET @group_id_show_to_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 5));
				SET @group_id_are_users_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 5));
				SET @group_id_see_users_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 5));

				SET @group_id_show_to_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 3));
				SET @group_id_are_users_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 3));
				SET @group_id_see_users_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 3));

				SET @group_id_show_to_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 4));
				SET @group_id_are_users_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 4));
				SET @group_id_see_users_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 4));

		#We get the information about the component/roles that were created:
			
			#We get that from the product_id and dummy user id to make sure that we do not get components with a valid user
				SET @component_id_tenant = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_tenant);
				SET @component_id_landlord = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_landlord);
				SET @component_id_agent = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_agent);
				SET @component_id_contractor = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_contractor);
				SET @component_id_mgt_cny = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_mgt_cny);

			#What is the component_id for this role?
				SET @component_id_this_role = IF( @id_role_type = 1
												, @component_id_tenant
												, IF (@id_role_type = 2
													, @component_id_landlord
													, IF (@id_role_type = 3
														, @component_id_contractor
														, IF (@id_role_type = 4
															, @component_id_mgt_cny
															, IF (@id_role_type = 5
																, @component_id_agent
																, 'Something is very wrong!!'
																)
															)
														)
													)
												)
												;
													
			#We have everything, we can now update the component/role for the unit and make the user default assignee.
				#Get the old values so we can log those
				SET @old_component_initialowner = NULL;
				SET @old_component_initialowner = (SELECT `initialowner` FROM `components` WHERE `id` = @component_id_this_role);
				SET @old_component_initialqacontact = NULL;
				SET @old_component_initialqacontact = (SELECT `initialqacontact` FROM `components` WHERE `id` = @component_id_this_role);
				SET @old_component_description = NULL;
				SET @old_component_description = (SELECT `description` FROM `components` WHERE `id` = @component_id_this_role);
				
				#Update
				UPDATE `components`
				SET 
					`initialowner` = @bz_user_id
					,`initialqacontact` = @bz_user_id
					,`description` = @user_role_desc
					WHERE 
					`id` = @component_id_this_role
					;
				
			#Log the actions of the script.
				SET @script_log_message = CONCAT('The component: '
										, (SELECT IFNULL(@component_id_this_role, 'component_id_this_role is NULL'))
										, ' (for the role_type_id #'
										, (SELECT IFNULL(@id_role_type, 'id_role_type is NULL'))
										, ') has been updated.'
										, '\r\The default user now associated to this role is bz user #'
										, (SELECT IFNULL(@bz_user_id, 'bz_user_id is NULL'))
										, ' (real name: '
										, (SELECT IFNULL(@user_pub_name, 'user_pub_name is NULL'))
										, ') for the unit #' 
										, @product_id
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;
				
				SET @script_log_message = NULL;	
					
		#We update the BZ logs
			INSERT  INTO `audit_log`
				(`user_id`
				,`class`
				,`object_id`
				,`field`
				,`removed`
				,`added`
				,`at_time`
				) 
				VALUES 
				(@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'initialowner',@old_component_initialowner,@bz_user_id,@timestamp)
				, (@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'initialqacontact',@old_component_initialqacontact,@bz_user_id,@timestamp)
				, (@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'description',@old_component_description,@user_role_desc,@timestamp)
				;	
				
		#We now assign the default permissions to the user we just associated to this role:		
			
			#We use a temporary table to make sure we do not have duplicates.
				
				#DELETE the temp table if it exists
				DROP TABLE IF EXISTS `ut_user_group_map_temp`;
				
				#Re-create the temp table
				CREATE TABLE `ut_user_group_map_temp` (
				  `user_id` MEDIUMINT(9) NOT NULL,
				  `group_id` MEDIUMINT(9) NOT NULL,
				  `isbless` TINYINT(4) NOT NULL DEFAULT '0',
				  `grant_type` TINYINT(4) NOT NULL DEFAULT '0'
				) ENGINE=INNODB DEFAULT CHARSET=utf8;

				#Add all the records that exists in the table user_group_map
				INSERT INTO `ut_user_group_map_temp`
					SELECT *
					FROM `user_group_map`;

			#We need to get the id of these groups from the 'ut_product_group' table_based on the product_id
				#For the user - based on the user role:
					#Visibility group
					SET @group_id_show_to_user_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = @id_role_type));
				
					#Is in user Group for the role we just created
					SET @group_id_are_users_same_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = @id_role_type));
					
					#Can See other users in the same Group
					SET @group_id_see_users_same_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = @id_role_type));


		#The default permissions for a user assigned as default for a role are:
		#
			#- time_tracking_permission
			#- can_create_shared_queries
			#- can_tag_comment
		#
			#- can_create_new_cases
			#- can_edit_a_case
			#- can_edit_all_field_case
			#- can_see_unit_in_search
			#- can_see_all_public_cases
			#- user_is_publicly_visible
			#- user_can_see_publicly_visible
			#- can_ask_to_approve (all_r_flags_group_id)
			#- can_approve (all_g_flags_group_id)
		#
		#We create the procedures that will grant the permissions based on the variables from this script.	
		#
			#- show_to_his_role
			#- is_one_of_his_role
			#- can_see_other_in_same_role
		#
		#If applicable
			#- show_to_occupant
			#- is_occupant
			#- can_see_occupant

			#First the global permissions:
				#Can see timetracking
					INSERT  INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id,@can_see_time_tracking_group_id,0,0)
						;
						
					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN See time tracking information.'
												);
					
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						
						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to see time tracking')
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_time_tracking_group_id, @script, 'Add the BZ group id when we grant the permission to see time tracking')
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant see time tracking permission')
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group see time tracking')
							 ;
						 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
			
				#Can create shared queries
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id,@can_create_shared_queries_group_id,0,0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN create shared queries.'
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table

						SET @bzfe_table = 'ut_user_group_map_temp';

						INSERT INTO `ut_audit_log`
								 (`datetime`
								 , `bzfe_table`
								 , `bzfe_field`
								 , `previous_value`
								 , `new_value`
								 , `script`
								 , `comment`
								 )
								 VALUES
								 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to create shared queries')
								 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_create_shared_queries_group_id, @script, 'Add the BZ group id when we grant the permission to create shared queries')
								 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant create shared queries permission')
								 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group create shared queries')
								 ;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;

				#Can tag comments
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id,@can_tag_comment_group_id,0,0)
						;
						
					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN tag comments.'
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to tag comments')
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_tag_comment_group_id, @script, 'Add the BZ group id when we grant the permission to tag comments')
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant tag comments permission')
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group tag comments')
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
			
			#Then the permissions at the unit/product level:	
							
				#User can create a case:
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						#There can be cases when a user is only allowed to see existing cases but NOT create new one.
						#This is an unlikely scenario, but this is technically possible...
						(@bz_user_id, @create_case_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN create new cases for unit '
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'create a new case.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
				#User is allowed to edit cases
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_edit_case_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN edit a cases for unit '
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'edit a case in this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_edit_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
				#User can see the case in the unit even if they are not for his role
					#This allows a user to see the 'public' cases for a given unit.
					#A 'public' case can still only be seen by users in this group!
					#We might NOT want this for employees of a contractor that only need to see the cases IF the case is restricted to
					#the contractor role but NOT if the case is for anyone
					#This is an unlikely scenario, but this is technically possible (ex for technician for a contractor)...
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_see_cases_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN see all public cases for unit '
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'see all public case in this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_cases_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
				#User can edit all fields in the case regardless of his/her role
					#This is needed so until the MEFE can handle permissions.
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_edit_all_field_case_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' can edit all fields in the case regardless of his/her role for the unit#'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'Can edit all fields in the case regardless of his/her role.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_edit_all_field_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;

				#User Can see the unit in the Search panel
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_see_unit_in_search_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' can see the unit#'
												, @product_id
												, ' in the search panel.'
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'Can see the unit in the Search panel.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_unit_in_search_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
				
				#User can be visible to other users regardless of the other users roles
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @list_visible_assignees_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' is one of the visible assignee for cases for this unit.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'is one of the visible assignee for cases for this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @list_visible_assignees_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;

				#User can be visible to other users regardless of the other users roles
					#The below membership is needed so the user can see all the other users regardless of the other users roles
					#We might hide the visible users to some other user (ex: housekeepers or field person do not need to see lanlord or agent
					#They just need to see their manager)
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @see_visible_assignees_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN see the publicly visible users for the case for this unit.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = ' CAN see the publicly visible users for the case for this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @see_visible_assignees_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;				

				#user can create flags (approval requests)				
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES
						(@bz_user_id, @all_r_flags_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN ask for approval for all flags.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = ' CAN ask for approval for all flags.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @all_r_flags_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;	
						
				#user can approve all the flags
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES
						(@bz_user_id, @all_g_flags_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN approve for all flags.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = ' CAN approve for all flags.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @all_g_flags_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
			#Then the permissions that are relevant to the component/role
			#These are conditional as this depends on the role attributed to that user
							
				#User can see the cases for Tenants in the unit:
				
		#We CALL ALL the procedures that we have created TO CREATE the permissions we need:
			CALL show_to_tenant;
			CALL is_tenant;
			CALL default_tenant_can_see_tenant;

			CALL show_to_landlord;
			CALL are_users_landlord;
			CALL default_landlord_see_users_landlord;

			CALL show_to_agent;
			CALL are_users_agent;
			CALL default_agent_see_users_agent;

			CALL show_to_contractor;
			CALL are_users_contractor;
			CALL default_contractor_see_users_contractor;

			CALL show_to_mgt_cny;
			CALL are_users_mgt_cny;
			CALL default_mgt_cny_see_users_mgt_cny;
			
			CALL show_to_occupant;
			CALL is_occupant;
			CALL default_occupant_can_see_occupant;
				
		#We give the user the permission they need.

			#We update the `user_group_map` table
				
				#We truncate the table first (to avoid duplicates)
					TRUNCATE TABLE `user_group_map`;
					
				#We insert the data we need
					INSERT INTO `user_group_map`
					SELECT `user_id`
						, `group_id`
						, `isbless`
						, `grant_type`
					FROM
						`ut_user_group_map_temp`
					GROUP BY `user_id`
						, `group_id`
						, `isbless`
						, `grant_type`
					;

		#Update the table 'ut_data_to_replace_dummy_roles' so that we record what we have done
			UPDATE `ut_data_to_replace_dummy_roles`
			SET 
				`bz_created_date` = @timestamp
				, `comment` = CONCAT ('inserted in BZ with the script \''
						, @script
						, '\'\r\ '
						, IFNULL(`comment`, '')
						)
			WHERE `id` = @reference_for_update;
					
		#Clean up
				
			#We Delete the temp table as we do not need it anymore
				DROP TABLE IF EXISTS `ut_user_group_map_temp`;
	
	# Record 4:
		#The unit: What is the id of the record that you want to use in the table 'ut_data_to_replace_dummy_roles'
			SET @reference_for_update = 4;

		#Environment: Which environment are you creatin the unit in?
			#- 1 is for the DEV/Staging
			#- 2 is for the prod environment
			SET @environment = 1;

		#This is needed so that the invitation mechanism works as intended in the MEFE.
				#- Tenant 1
				SET @bz_user_id_dummy_tenant = 4;

				#- Landlord 2
				SET @bz_user_id_dummy_landlord = 3;
				
				#- Contractor 3
				SET @bz_user_id_dummy_contractor = 5;
				
				#- Management company 4
				SET @bz_user_id_dummy_mgt_cny = 6;
				
				#- Agent 5
				SET @bz_user_id_dummy_agent = 2;
			
		#The unit:
			
			#The name and description
				SET @product_id = (SELECT `bz_unit_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

		#The user associated to the first role in this unit.	

			#BZ user id of the user that is creating the unit (default is 1 - Administrator).
			#For LMB migration, we use 2 (support.nobody)
				SET @creator_bz_id = (SELECT `bzfe_invitor_user_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

			#BZ user id of the user that you want to associate to the unit.
				SET @bz_user_id = (SELECT `bz_user_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);
			
			#Role of the user associated to this new unit:
				#- Tenant 1
				#- Landlord 2
				#- Agent 5
				#- Contractor 3
				#- Management company 4
				SET @id_role_type = (SELECT `user_role_type_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);
				SET @role_user_more = (SELECT `user_more` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

			#Is the BZ user an occupant of the unit?
				SET @is_occupant = (SELECT `is_occupant` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

		#We need to get the component for ALL the roles for this product
		#We do that using dummy users for all the roles different from the user role.	
				#- agent -> temporary.agent.dev@unee-t.com
				#- landlord  -> temporary.landlord.dev@unee-t.com
				#- Tenant  -> temporary.tenant.dev@unee-t.com
				#- Contractor  -> temporary.contractor.dev@unee-t.com

		#The Groups to grant the global permissions for the user

			#This should not change, it was hard coded when we created Unee-T
				#See time tracking
				SET @can_see_time_tracking_group_id = 16;
				#Can create shared queries
				SET @can_create_shared_queries_group_id = 17;
				#Can tag comments
				SET @can_tag_comment_group_id = 18;		
				
		#We populate the additional variables that we will need for this script to work
			
			#For the user
				SET @role_user_g_description = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=@id_role_type);
				SET @user_pub_name = (SELECT (LEFT(`login_name`,INSTR(`login_name`,"@")-1)) FROM `profiles` WHERE `userid` = @bz_user_id);
				SET @role_user_pub_info = CONCAT(@user_pub_name
										, IF (@role_user_more = '', '', ' - ')
										, IF (@role_user_more = '', '', @role_user_more)
										)
										;
				SET @user_role_desc = (CONCAT(@role_user_g_description, ' - ',@role_user_pub_info));

			#For the creator
				SET @creator_pub_name = (SELECT `realname` FROM `profiles` WHERE `userid` = @creator_bz_id);

		#Variable needed to avoid script error - NEED TO REVISIT THAT
			SET @can_see_time_tracking = 1;
			SET @can_create_shared_queries = 1;
			SET @can_tag_comment = 1;
			SET @user_is_publicly_visible = 1;
			SET @user_can_see_publicly_visible = 1;
			SET @user_in_cc_for_cases = 0;
			SET @can_create_new_cases = 1;
			SET @can_edit_a_case = 1;
			SET @can_see_all_public_cases = 1;
			SET @can_edit_all_field_in_a_case_regardless_of_role = 1;
			SET @can_ask_to_approve = 1;
			SET @can_approve = 1;
			SET @can_create_any_stakeholder = 0;
			SET @can_create_same_stakeholder = 0;
			SET @can_approve_user_for_flag = 0;
			SET @can_decide_if_user_is_visible = 0;
			SET @can_decide_if_user_can_see_visible = 0;	

		#The user

			#We record the information about the users that we have just created
			#If this is the first time we record something for this user for this unit, we create a new record.
			#If there is already a record for THAT USER for THIS, then we are updating the information
				
				INSERT INTO `ut_map_user_unit_details`
					(`created`
					, `record_created_by`
					, `user_id`
					, `bz_profile_id`
					, `bz_unit_id`
					, `role_type_id`
					, `can_see_time_tracking`
					, `can_create_shared_queries`
					, `can_tag_comment`
					, `is_occupant`
					, `is_public_assignee`
					, `is_see_visible_assignee`
					, `is_in_cc_for_role`
					, `can_create_case`
					, `can_edit_case`
					, `can_see_case`
					, `can_edit_all_field_regardless_of_role`
					, `is_flag_requestee`
					, `is_flag_approver`
					, `can_create_any_sh`
					, `can_create_same_sh`
					, `can_approve_user_for_flags`
					, `can_decide_if_user_visible`
					, `can_decide_if_user_can_see_visible`
					, `public_name`
					, `more_info`
					, `comment`
					)
					VALUES
					(NOW()
					, @creator_bz_id
					, @bz_user_id
					, @bz_user_id
					, @product_id
					, @id_role_type
					#Global permission for the whole installation
					, @can_see_time_tracking
					, @can_create_shared_queries
					, @can_tag_comment
					#Attributes of the user
					, @is_occupant
					#User visibility
					, @user_is_publicly_visible
					, @user_can_see_publicly_visible
					#Permissions for cases for this unit.
					, @user_in_cc_for_cases
					, @can_create_new_cases
					, @can_edit_a_case
					, @can_see_all_public_cases
					, @can_edit_all_field_in_a_case_regardless_of_role
					#For the flags
					, @can_ask_to_approve
					, @can_approve
					#Permissions to create or modify other users
					, @can_create_any_stakeholder
					, @can_create_same_stakeholder
					, @can_approve_user_for_flag
					, @can_decide_if_user_is_visible
					, @can_decide_if_user_can_see_visible
					, @user_pub_name
					, @role_user_more
					, CONCAT('On '
							, NOW()
							, ': Created with the script - '
							, @script
							, '.\r\ '
							, `comment`)
					)
					ON DUPLICATE KEY UPDATE
					`created` = NOW()
					, `record_created_by` = @creator_bz_id
					, `role_type_id` = @id_role_type
					, `can_see_time_tracking` = @can_see_time_tracking
					, `can_create_shared_queries` = @can_create_shared_queries
					, `can_tag_comment` = @can_tag_comment
					, `is_occupant` = @is_occupant
					, `is_public_assignee` = @user_is_publicly_visible
					, `is_see_visible_assignee` = @user_can_see_publicly_visible
					, `is_in_cc_for_role` = @user_in_cc_for_cases
					, `can_create_case` = @can_create_new_cases
					, `can_edit_case` = @can_edit_a_case
					, `can_see_case` = @can_see_all_public_cases
					, `can_edit_all_field_regardless_of_role` = @can_edit_all_field_in_a_case_regardless_of_role
					, `is_flag_requestee` = @can_ask_to_approve
					, `is_flag_approver` = @can_approve
					, `can_create_any_sh` = @can_create_any_stakeholder
					, `can_create_same_sh` = @can_create_same_stakeholder
					, `can_approve_user_for_flags` = @can_approve_user_for_flag
					, `can_decide_if_user_visible` = @can_decide_if_user_is_visible
					, `can_decide_if_user_can_see_visible` = @can_decide_if_user_can_see_visible
					, `public_name` = @user_pub_name
					, `more_info` = CONCAT('On: ', NOW(), '.\r\Updated to ', @role_user_more, '. \r\ ', `more_info`)
					, `comment` = CONCAT('On ', NOW(), '.\r\Updated with the script - ', @script, '.\r\ ', `comment`)
				;

		#We get the information about the goups we need
			#We need to ge these from the ut_product_table_based on the product_id!
				SET @create_case_group_id =  (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 20));
				SET @can_edit_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 25));
				SET @can_see_cases_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 28));
				
				#This is needed until MEFE is able to handle more detailed permissions.
				SET @can_edit_all_field_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 26));
				
				#This is needed so that user can see the unit in the Search panel
				SET @can_see_unit_in_search_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 38));
				
				SET @list_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 4));
				SET @see_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 5));	

				SET @all_r_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 18));
				SET @all_g_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 19));
				
			#Groups created when we created the Role for this product.
				#- show_to_tenant
				#- are_users_tenant
				#- see_users_tenant
				#- show_to_landlord
				#- are_users_landlord
				#- see_users_landlord
				#- show_to_agent
				#- are_users_agent
				#- see_users_agent
				#- show_to_contractor
				#- are_users_contractor
				#- see_users_contractor
				#- show_to_mgt_cny
				#- are_users_mgt_cny
				#- see_users_mgt_cny
				#- show_to_occupant
				#- are_users_occupant
				#- see_users_occupant

				SET @group_id_show_to_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 24));
				SET @group_id_are_users_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 3));
				SET @group_id_see_users_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 36));

				SET @group_id_show_to_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 1));
				SET @group_id_are_users_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 1));
				SET @group_id_see_users_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 1));

				SET @group_id_show_to_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 2));
				SET @group_id_are_users_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 2));
				SET @group_id_see_users_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 2));

				SET @group_id_show_to_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 5));
				SET @group_id_are_users_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 5));
				SET @group_id_see_users_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 5));

				SET @group_id_show_to_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 3));
				SET @group_id_are_users_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 3));
				SET @group_id_see_users_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 3));

				SET @group_id_show_to_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 4));
				SET @group_id_are_users_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 4));
				SET @group_id_see_users_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 4));

		#We get the information about the component/roles that were created:
			
			#We get that from the product_id and dummy user id to make sure that we do not get components with a valid user
				SET @component_id_tenant = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_tenant);
				SET @component_id_landlord = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_landlord);
				SET @component_id_agent = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_agent);
				SET @component_id_contractor = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_contractor);
				SET @component_id_mgt_cny = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_mgt_cny);

			#What is the component_id for this role?
				SET @component_id_this_role = IF( @id_role_type = 1
												, @component_id_tenant
												, IF (@id_role_type = 2
													, @component_id_landlord
													, IF (@id_role_type = 3
														, @component_id_contractor
														, IF (@id_role_type = 4
															, @component_id_mgt_cny
															, IF (@id_role_type = 5
																, @component_id_agent
																, 'Something is very wrong!!'
																)
															)
														)
													)
												)
												;
													
			#We have everything, we can now update the component/role for the unit and make the user default assignee.
				#Get the old values so we can log those
				SET @old_component_initialowner = NULL;
				SET @old_component_initialowner = (SELECT `initialowner` FROM `components` WHERE `id` = @component_id_this_role);
				SET @old_component_initialqacontact = NULL;
				SET @old_component_initialqacontact = (SELECT `initialqacontact` FROM `components` WHERE `id` = @component_id_this_role);
				SET @old_component_description = NULL;
				SET @old_component_description = (SELECT `description` FROM `components` WHERE `id` = @component_id_this_role);
				
				#Update
				UPDATE `components`
				SET 
					`initialowner` = @bz_user_id
					,`initialqacontact` = @bz_user_id
					,`description` = @user_role_desc
					WHERE 
					`id` = @component_id_this_role
					;
				
			#Log the actions of the script.
				SET @script_log_message = CONCAT('The component: '
										, (SELECT IFNULL(@component_id_this_role, 'component_id_this_role is NULL'))
										, ' (for the role_type_id #'
										, (SELECT IFNULL(@id_role_type, 'id_role_type is NULL'))
										, ') has been updated.'
										, '\r\The default user now associated to this role is bz user #'
										, (SELECT IFNULL(@bz_user_id, 'bz_user_id is NULL'))
										, ' (real name: '
										, (SELECT IFNULL(@user_pub_name, 'user_pub_name is NULL'))
										, ') for the unit #' 
										, @product_id
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;
				
				SET @script_log_message = NULL;	
					
		#We update the BZ logs
			INSERT  INTO `audit_log`
				(`user_id`
				,`class`
				,`object_id`
				,`field`
				,`removed`
				,`added`
				,`at_time`
				) 
				VALUES 
				(@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'initialowner',@old_component_initialowner,@bz_user_id,@timestamp)
				, (@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'initialqacontact',@old_component_initialqacontact,@bz_user_id,@timestamp)
				, (@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'description',@old_component_description,@user_role_desc,@timestamp)
				;	
				
		#We now assign the default permissions to the user we just associated to this role:		
			
			#We use a temporary table to make sure we do not have duplicates.
				
				#DELETE the temp table if it exists
				DROP TABLE IF EXISTS `ut_user_group_map_temp`;
				
				#Re-create the temp table
				CREATE TABLE `ut_user_group_map_temp` (
				  `user_id` MEDIUMINT(9) NOT NULL,
				  `group_id` MEDIUMINT(9) NOT NULL,
				  `isbless` TINYINT(4) NOT NULL DEFAULT '0',
				  `grant_type` TINYINT(4) NOT NULL DEFAULT '0'
				) ENGINE=INNODB DEFAULT CHARSET=utf8;

				#Add all the records that exists in the table user_group_map
				INSERT INTO `ut_user_group_map_temp`
					SELECT *
					FROM `user_group_map`;

			#We need to get the id of these groups from the 'ut_product_group' table_based on the product_id
				#For the user - based on the user role:
					#Visibility group
					SET @group_id_show_to_user_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = @id_role_type));
				
					#Is in user Group for the role we just created
					SET @group_id_are_users_same_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = @id_role_type));
					
					#Can See other users in the same Group
					SET @group_id_see_users_same_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = @id_role_type));


		#The default permissions for a user assigned as default for a role are:
		#
			#- time_tracking_permission
			#- can_create_shared_queries
			#- can_tag_comment
		#
			#- can_create_new_cases
			#- can_edit_a_case
			#- can_edit_all_field_case
			#- can_see_unit_in_search
			#- can_see_all_public_cases
			#- user_is_publicly_visible
			#- user_can_see_publicly_visible
			#- can_ask_to_approve (all_r_flags_group_id)
			#- can_approve (all_g_flags_group_id)
		#
		#We create the procedures that will grant the permissions based on the variables from this script.	
		#
			#- show_to_his_role
			#- is_one_of_his_role
			#- can_see_other_in_same_role
		#
		#If applicable
			#- show_to_occupant
			#- is_occupant
			#- can_see_occupant

			#First the global permissions:
				#Can see timetracking
					INSERT  INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id,@can_see_time_tracking_group_id,0,0)
						;
						
					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN See time tracking information.'
												);
					
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						
						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to see time tracking')
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_time_tracking_group_id, @script, 'Add the BZ group id when we grant the permission to see time tracking')
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant see time tracking permission')
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group see time tracking')
							 ;
						 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
			
				#Can create shared queries
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id,@can_create_shared_queries_group_id,0,0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN create shared queries.'
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table

						SET @bzfe_table = 'ut_user_group_map_temp';

						INSERT INTO `ut_audit_log`
								 (`datetime`
								 , `bzfe_table`
								 , `bzfe_field`
								 , `previous_value`
								 , `new_value`
								 , `script`
								 , `comment`
								 )
								 VALUES
								 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to create shared queries')
								 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_create_shared_queries_group_id, @script, 'Add the BZ group id when we grant the permission to create shared queries')
								 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant create shared queries permission')
								 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group create shared queries')
								 ;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;

				#Can tag comments
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id,@can_tag_comment_group_id,0,0)
						;
						
					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN tag comments.'
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to tag comments')
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_tag_comment_group_id, @script, 'Add the BZ group id when we grant the permission to tag comments')
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant tag comments permission')
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group tag comments')
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
			
			#Then the permissions at the unit/product level:	
							
				#User can create a case:
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						#There can be cases when a user is only allowed to see existing cases but NOT create new one.
						#This is an unlikely scenario, but this is technically possible...
						(@bz_user_id, @create_case_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN create new cases for unit '
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'create a new case.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
				#User is allowed to edit cases
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_edit_case_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN edit a cases for unit '
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'edit a case in this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_edit_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
				#User can see the case in the unit even if they are not for his role
					#This allows a user to see the 'public' cases for a given unit.
					#A 'public' case can still only be seen by users in this group!
					#We might NOT want this for employees of a contractor that only need to see the cases IF the case is restricted to
					#the contractor role but NOT if the case is for anyone
					#This is an unlikely scenario, but this is technically possible (ex for technician for a contractor)...
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_see_cases_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN see all public cases for unit '
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'see all public case in this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_cases_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
				#User can edit all fields in the case regardless of his/her role
					#This is needed so until the MEFE can handle permissions.
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_edit_all_field_case_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' can edit all fields in the case regardless of his/her role for the unit#'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'Can edit all fields in the case regardless of his/her role.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_edit_all_field_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;

				#User Can see the unit in the Search panel
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_see_unit_in_search_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' can see the unit#'
												, @product_id
												, ' in the search panel.'
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'Can see the unit in the Search panel.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_unit_in_search_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
				
				#User can be visible to other users regardless of the other users roles
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @list_visible_assignees_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' is one of the visible assignee for cases for this unit.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'is one of the visible assignee for cases for this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @list_visible_assignees_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;

				#User can be visible to other users regardless of the other users roles
					#The below membership is needed so the user can see all the other users regardless of the other users roles
					#We might hide the visible users to some other user (ex: housekeepers or field person do not need to see lanlord or agent
					#They just need to see their manager)
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @see_visible_assignees_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN see the publicly visible users for the case for this unit.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = ' CAN see the publicly visible users for the case for this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @see_visible_assignees_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;				

				#user can create flags (approval requests)				
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES
						(@bz_user_id, @all_r_flags_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN ask for approval for all flags.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = ' CAN ask for approval for all flags.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @all_r_flags_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;	
						
				#user can approve all the flags
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES
						(@bz_user_id, @all_g_flags_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN approve for all flags.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = ' CAN approve for all flags.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @all_g_flags_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
			#Then the permissions that are relevant to the component/role
			#These are conditional as this depends on the role attributed to that user
							
				#User can see the cases for Tenants in the unit:
				
		#We CALL ALL the procedures that we have created TO CREATE the permissions we need:
			CALL show_to_tenant;
			CALL is_tenant;
			CALL default_tenant_can_see_tenant;

			CALL show_to_landlord;
			CALL are_users_landlord;
			CALL default_landlord_see_users_landlord;

			CALL show_to_agent;
			CALL are_users_agent;
			CALL default_agent_see_users_agent;

			CALL show_to_contractor;
			CALL are_users_contractor;
			CALL default_contractor_see_users_contractor;

			CALL show_to_mgt_cny;
			CALL are_users_mgt_cny;
			CALL default_mgt_cny_see_users_mgt_cny;
			
			CALL show_to_occupant;
			CALL is_occupant;
			CALL default_occupant_can_see_occupant;
				
		#We give the user the permission they need.

			#We update the `user_group_map` table
				
				#We truncate the table first (to avoid duplicates)
					TRUNCATE TABLE `user_group_map`;
					
				#We insert the data we need
					INSERT INTO `user_group_map`
					SELECT `user_id`
						, `group_id`
						, `isbless`
						, `grant_type`
					FROM
						`ut_user_group_map_temp`
					GROUP BY `user_id`
						, `group_id`
						, `isbless`
						, `grant_type`
					;

		#Update the table 'ut_data_to_replace_dummy_roles' so that we record what we have done
			UPDATE `ut_data_to_replace_dummy_roles`
			SET 
				`bz_created_date` = @timestamp
				, `comment` = CONCAT ('inserted in BZ with the script \''
						, @script
						, '\'\r\ '
						, IFNULL(`comment`, '')
						)
			WHERE `id` = @reference_for_update;
					
		#Clean up
				
			#We Delete the temp table as we do not need it anymore
				DROP TABLE IF EXISTS `ut_user_group_map_temp`;
	
	# Record 5:
		#The unit: What is the id of the record that you want to use in the table 'ut_data_to_replace_dummy_roles'
			SET @reference_for_update = 5;

		#Environment: Which environment are you creatin the unit in?
			#- 1 is for the DEV/Staging
			#- 2 is for the prod environment
			SET @environment = 1;

		#This is needed so that the invitation mechanism works as intended in the MEFE.
				#- Tenant 1
				SET @bz_user_id_dummy_tenant = 4;

				#- Landlord 2
				SET @bz_user_id_dummy_landlord = 3;
				
				#- Contractor 3
				SET @bz_user_id_dummy_contractor = 5;
				
				#- Management company 4
				SET @bz_user_id_dummy_mgt_cny = 6;
				
				#- Agent 5
				SET @bz_user_id_dummy_agent = 2;
			
		#The unit:
			
			#The name and description
				SET @product_id = (SELECT `bz_unit_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

		#The user associated to the first role in this unit.	

			#BZ user id of the user that is creating the unit (default is 1 - Administrator).
			#For LMB migration, we use 2 (support.nobody)
				SET @creator_bz_id = (SELECT `bzfe_invitor_user_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

			#BZ user id of the user that you want to associate to the unit.
				SET @bz_user_id = (SELECT `bz_user_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);
			
			#Role of the user associated to this new unit:
				#- Tenant 1
				#- Landlord 2
				#- Agent 5
				#- Contractor 3
				#- Management company 4
				SET @id_role_type = (SELECT `user_role_type_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);
				SET @role_user_more = (SELECT `user_more` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

			#Is the BZ user an occupant of the unit?
				SET @is_occupant = (SELECT `is_occupant` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

		#We need to get the component for ALL the roles for this product
		#We do that using dummy users for all the roles different from the user role.	
				#- agent -> temporary.agent.dev@unee-t.com
				#- landlord  -> temporary.landlord.dev@unee-t.com
				#- Tenant  -> temporary.tenant.dev@unee-t.com
				#- Contractor  -> temporary.contractor.dev@unee-t.com

		#The Groups to grant the global permissions for the user

			#This should not change, it was hard coded when we created Unee-T
				#See time tracking
				SET @can_see_time_tracking_group_id = 16;
				#Can create shared queries
				SET @can_create_shared_queries_group_id = 17;
				#Can tag comments
				SET @can_tag_comment_group_id = 18;		
				
		#We populate the additional variables that we will need for this script to work
			
			#For the user
				SET @role_user_g_description = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=@id_role_type);
				SET @user_pub_name = (SELECT (LEFT(`login_name`,INSTR(`login_name`,"@")-1)) FROM `profiles` WHERE `userid` = @bz_user_id);
				SET @role_user_pub_info = CONCAT(@user_pub_name
										, IF (@role_user_more = '', '', ' - ')
										, IF (@role_user_more = '', '', @role_user_more)
										)
										;
				SET @user_role_desc = (CONCAT(@role_user_g_description, ' - ',@role_user_pub_info));

			#For the creator
				SET @creator_pub_name = (SELECT `realname` FROM `profiles` WHERE `userid` = @creator_bz_id);

		#Variable needed to avoid script error - NEED TO REVISIT THAT
			SET @can_see_time_tracking = 1;
			SET @can_create_shared_queries = 1;
			SET @can_tag_comment = 1;
			SET @user_is_publicly_visible = 1;
			SET @user_can_see_publicly_visible = 1;
			SET @user_in_cc_for_cases = 0;
			SET @can_create_new_cases = 1;
			SET @can_edit_a_case = 1;
			SET @can_see_all_public_cases = 1;
			SET @can_edit_all_field_in_a_case_regardless_of_role = 1;
			SET @can_ask_to_approve = 1;
			SET @can_approve = 1;
			SET @can_create_any_stakeholder = 0;
			SET @can_create_same_stakeholder = 0;
			SET @can_approve_user_for_flag = 0;
			SET @can_decide_if_user_is_visible = 0;
			SET @can_decide_if_user_can_see_visible = 0;	

		#The user

			#We record the information about the users that we have just created
			#If this is the first time we record something for this user for this unit, we create a new record.
			#If there is already a record for THAT USER for THIS, then we are updating the information
				
				INSERT INTO `ut_map_user_unit_details`
					(`created`
					, `record_created_by`
					, `user_id`
					, `bz_profile_id`
					, `bz_unit_id`
					, `role_type_id`
					, `can_see_time_tracking`
					, `can_create_shared_queries`
					, `can_tag_comment`
					, `is_occupant`
					, `is_public_assignee`
					, `is_see_visible_assignee`
					, `is_in_cc_for_role`
					, `can_create_case`
					, `can_edit_case`
					, `can_see_case`
					, `can_edit_all_field_regardless_of_role`
					, `is_flag_requestee`
					, `is_flag_approver`
					, `can_create_any_sh`
					, `can_create_same_sh`
					, `can_approve_user_for_flags`
					, `can_decide_if_user_visible`
					, `can_decide_if_user_can_see_visible`
					, `public_name`
					, `more_info`
					, `comment`
					)
					VALUES
					(NOW()
					, @creator_bz_id
					, @bz_user_id
					, @bz_user_id
					, @product_id
					, @id_role_type
					#Global permission for the whole installation
					, @can_see_time_tracking
					, @can_create_shared_queries
					, @can_tag_comment
					#Attributes of the user
					, @is_occupant
					#User visibility
					, @user_is_publicly_visible
					, @user_can_see_publicly_visible
					#Permissions for cases for this unit.
					, @user_in_cc_for_cases
					, @can_create_new_cases
					, @can_edit_a_case
					, @can_see_all_public_cases
					, @can_edit_all_field_in_a_case_regardless_of_role
					#For the flags
					, @can_ask_to_approve
					, @can_approve
					#Permissions to create or modify other users
					, @can_create_any_stakeholder
					, @can_create_same_stakeholder
					, @can_approve_user_for_flag
					, @can_decide_if_user_is_visible
					, @can_decide_if_user_can_see_visible
					, @user_pub_name
					, @role_user_more
					, CONCAT('On '
							, NOW()
							, ': Created with the script - '
							, @script
							, '.\r\ '
							, `comment`)
					)
					ON DUPLICATE KEY UPDATE
					`created` = NOW()
					, `record_created_by` = @creator_bz_id
					, `role_type_id` = @id_role_type
					, `can_see_time_tracking` = @can_see_time_tracking
					, `can_create_shared_queries` = @can_create_shared_queries
					, `can_tag_comment` = @can_tag_comment
					, `is_occupant` = @is_occupant
					, `is_public_assignee` = @user_is_publicly_visible
					, `is_see_visible_assignee` = @user_can_see_publicly_visible
					, `is_in_cc_for_role` = @user_in_cc_for_cases
					, `can_create_case` = @can_create_new_cases
					, `can_edit_case` = @can_edit_a_case
					, `can_see_case` = @can_see_all_public_cases
					, `can_edit_all_field_regardless_of_role` = @can_edit_all_field_in_a_case_regardless_of_role
					, `is_flag_requestee` = @can_ask_to_approve
					, `is_flag_approver` = @can_approve
					, `can_create_any_sh` = @can_create_any_stakeholder
					, `can_create_same_sh` = @can_create_same_stakeholder
					, `can_approve_user_for_flags` = @can_approve_user_for_flag
					, `can_decide_if_user_visible` = @can_decide_if_user_is_visible
					, `can_decide_if_user_can_see_visible` = @can_decide_if_user_can_see_visible
					, `public_name` = @user_pub_name
					, `more_info` = CONCAT('On: ', NOW(), '.\r\Updated to ', @role_user_more, '. \r\ ', `more_info`)
					, `comment` = CONCAT('On ', NOW(), '.\r\Updated with the script - ', @script, '.\r\ ', `comment`)
				;

		#We get the information about the goups we need
			#We need to ge these from the ut_product_table_based on the product_id!
				SET @create_case_group_id =  (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 20));
				SET @can_edit_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 25));
				SET @can_see_cases_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 28));
				
				#This is needed until MEFE is able to handle more detailed permissions.
				SET @can_edit_all_field_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 26));
				
				#This is needed so that user can see the unit in the Search panel
				SET @can_see_unit_in_search_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 38));
				
				SET @list_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 4));
				SET @see_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 5));	

				SET @all_r_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 18));
				SET @all_g_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 19));
				
			#Groups created when we created the Role for this product.
				#- show_to_tenant
				#- are_users_tenant
				#- see_users_tenant
				#- show_to_landlord
				#- are_users_landlord
				#- see_users_landlord
				#- show_to_agent
				#- are_users_agent
				#- see_users_agent
				#- show_to_contractor
				#- are_users_contractor
				#- see_users_contractor
				#- show_to_mgt_cny
				#- are_users_mgt_cny
				#- see_users_mgt_cny
				#- show_to_occupant
				#- are_users_occupant
				#- see_users_occupant

				SET @group_id_show_to_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 24));
				SET @group_id_are_users_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 3));
				SET @group_id_see_users_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 36));

				SET @group_id_show_to_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 1));
				SET @group_id_are_users_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 1));
				SET @group_id_see_users_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 1));

				SET @group_id_show_to_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 2));
				SET @group_id_are_users_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 2));
				SET @group_id_see_users_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 2));

				SET @group_id_show_to_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 5));
				SET @group_id_are_users_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 5));
				SET @group_id_see_users_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 5));

				SET @group_id_show_to_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 3));
				SET @group_id_are_users_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 3));
				SET @group_id_see_users_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 3));

				SET @group_id_show_to_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 4));
				SET @group_id_are_users_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 4));
				SET @group_id_see_users_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 4));

		#We get the information about the component/roles that were created:
			
			#We get that from the product_id and dummy user id to make sure that we do not get components with a valid user
				SET @component_id_tenant = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_tenant);
				SET @component_id_landlord = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_landlord);
				SET @component_id_agent = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_agent);
				SET @component_id_contractor = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_contractor);
				SET @component_id_mgt_cny = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_mgt_cny);

			#What is the component_id for this role?
				SET @component_id_this_role = IF( @id_role_type = 1
												, @component_id_tenant
												, IF (@id_role_type = 2
													, @component_id_landlord
													, IF (@id_role_type = 3
														, @component_id_contractor
														, IF (@id_role_type = 4
															, @component_id_mgt_cny
															, IF (@id_role_type = 5
																, @component_id_agent
																, 'Something is very wrong!!'
																)
															)
														)
													)
												)
												;
													
			#We have everything, we can now update the component/role for the unit and make the user default assignee.
				#Get the old values so we can log those
				SET @old_component_initialowner = NULL;
				SET @old_component_initialowner = (SELECT `initialowner` FROM `components` WHERE `id` = @component_id_this_role);
				SET @old_component_initialqacontact = NULL;
				SET @old_component_initialqacontact = (SELECT `initialqacontact` FROM `components` WHERE `id` = @component_id_this_role);
				SET @old_component_description = NULL;
				SET @old_component_description = (SELECT `description` FROM `components` WHERE `id` = @component_id_this_role);
				
				#Update
				UPDATE `components`
				SET 
					`initialowner` = @bz_user_id
					,`initialqacontact` = @bz_user_id
					,`description` = @user_role_desc
					WHERE 
					`id` = @component_id_this_role
					;
				
			#Log the actions of the script.
				SET @script_log_message = CONCAT('The component: '
										, (SELECT IFNULL(@component_id_this_role, 'component_id_this_role is NULL'))
										, ' (for the role_type_id #'
										, (SELECT IFNULL(@id_role_type, 'id_role_type is NULL'))
										, ') has been updated.'
										, '\r\The default user now associated to this role is bz user #'
										, (SELECT IFNULL(@bz_user_id, 'bz_user_id is NULL'))
										, ' (real name: '
										, (SELECT IFNULL(@user_pub_name, 'user_pub_name is NULL'))
										, ') for the unit #' 
										, @product_id
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;
				
				SET @script_log_message = NULL;	
					
		#We update the BZ logs
			INSERT  INTO `audit_log`
				(`user_id`
				,`class`
				,`object_id`
				,`field`
				,`removed`
				,`added`
				,`at_time`
				) 
				VALUES 
				(@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'initialowner',@old_component_initialowner,@bz_user_id,@timestamp)
				, (@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'initialqacontact',@old_component_initialqacontact,@bz_user_id,@timestamp)
				, (@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'description',@old_component_description,@user_role_desc,@timestamp)
				;	
				
		#We now assign the default permissions to the user we just associated to this role:		
			
			#We use a temporary table to make sure we do not have duplicates.
				
				#DELETE the temp table if it exists
				DROP TABLE IF EXISTS `ut_user_group_map_temp`;
				
				#Re-create the temp table
				CREATE TABLE `ut_user_group_map_temp` (
				  `user_id` MEDIUMINT(9) NOT NULL,
				  `group_id` MEDIUMINT(9) NOT NULL,
				  `isbless` TINYINT(4) NOT NULL DEFAULT '0',
				  `grant_type` TINYINT(4) NOT NULL DEFAULT '0'
				) ENGINE=INNODB DEFAULT CHARSET=utf8;

				#Add all the records that exists in the table user_group_map
				INSERT INTO `ut_user_group_map_temp`
					SELECT *
					FROM `user_group_map`;

			#We need to get the id of these groups from the 'ut_product_group' table_based on the product_id
				#For the user - based on the user role:
					#Visibility group
					SET @group_id_show_to_user_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = @id_role_type));
				
					#Is in user Group for the role we just created
					SET @group_id_are_users_same_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = @id_role_type));
					
					#Can See other users in the same Group
					SET @group_id_see_users_same_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = @id_role_type));


		#The default permissions for a user assigned as default for a role are:
		#
			#- time_tracking_permission
			#- can_create_shared_queries
			#- can_tag_comment
		#
			#- can_create_new_cases
			#- can_edit_a_case
			#- can_edit_all_field_case
			#- can_see_unit_in_search
			#- can_see_all_public_cases
			#- user_is_publicly_visible
			#- user_can_see_publicly_visible
			#- can_ask_to_approve (all_r_flags_group_id)
			#- can_approve (all_g_flags_group_id)
		#
		#We create the procedures that will grant the permissions based on the variables from this script.	
		#
			#- show_to_his_role
			#- is_one_of_his_role
			#- can_see_other_in_same_role
		#
		#If applicable
			#- show_to_occupant
			#- is_occupant
			#- can_see_occupant

			#First the global permissions:
				#Can see timetracking
					INSERT  INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id,@can_see_time_tracking_group_id,0,0)
						;
						
					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN See time tracking information.'
												);
					
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						
						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to see time tracking')
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_time_tracking_group_id, @script, 'Add the BZ group id when we grant the permission to see time tracking')
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant see time tracking permission')
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group see time tracking')
							 ;
						 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
			
				#Can create shared queries
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id,@can_create_shared_queries_group_id,0,0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN create shared queries.'
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table

						SET @bzfe_table = 'ut_user_group_map_temp';

						INSERT INTO `ut_audit_log`
								 (`datetime`
								 , `bzfe_table`
								 , `bzfe_field`
								 , `previous_value`
								 , `new_value`
								 , `script`
								 , `comment`
								 )
								 VALUES
								 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to create shared queries')
								 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_create_shared_queries_group_id, @script, 'Add the BZ group id when we grant the permission to create shared queries')
								 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant create shared queries permission')
								 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group create shared queries')
								 ;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;

				#Can tag comments
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id,@can_tag_comment_group_id,0,0)
						;
						
					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN tag comments.'
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to tag comments')
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_tag_comment_group_id, @script, 'Add the BZ group id when we grant the permission to tag comments')
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant tag comments permission')
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group tag comments')
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
			
			#Then the permissions at the unit/product level:	
							
				#User can create a case:
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						#There can be cases when a user is only allowed to see existing cases but NOT create new one.
						#This is an unlikely scenario, but this is technically possible...
						(@bz_user_id, @create_case_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN create new cases for unit '
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'create a new case.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
				#User is allowed to edit cases
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_edit_case_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN edit a cases for unit '
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'edit a case in this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_edit_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
				#User can see the case in the unit even if they are not for his role
					#This allows a user to see the 'public' cases for a given unit.
					#A 'public' case can still only be seen by users in this group!
					#We might NOT want this for employees of a contractor that only need to see the cases IF the case is restricted to
					#the contractor role but NOT if the case is for anyone
					#This is an unlikely scenario, but this is technically possible (ex for technician for a contractor)...
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_see_cases_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN see all public cases for unit '
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'see all public case in this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_cases_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
				#User can edit all fields in the case regardless of his/her role
					#This is needed so until the MEFE can handle permissions.
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_edit_all_field_case_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' can edit all fields in the case regardless of his/her role for the unit#'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'Can edit all fields in the case regardless of his/her role.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_edit_all_field_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;

				#User Can see the unit in the Search panel
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_see_unit_in_search_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' can see the unit#'
												, @product_id
												, ' in the search panel.'
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'Can see the unit in the Search panel.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_unit_in_search_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
				
				#User can be visible to other users regardless of the other users roles
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @list_visible_assignees_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' is one of the visible assignee for cases for this unit.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'is one of the visible assignee for cases for this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @list_visible_assignees_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;

				#User can be visible to other users regardless of the other users roles
					#The below membership is needed so the user can see all the other users regardless of the other users roles
					#We might hide the visible users to some other user (ex: housekeepers or field person do not need to see lanlord or agent
					#They just need to see their manager)
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @see_visible_assignees_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN see the publicly visible users for the case for this unit.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = ' CAN see the publicly visible users for the case for this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @see_visible_assignees_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;				

				#user can create flags (approval requests)				
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES
						(@bz_user_id, @all_r_flags_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN ask for approval for all flags.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = ' CAN ask for approval for all flags.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @all_r_flags_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;	
						
				#user can approve all the flags
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES
						(@bz_user_id, @all_g_flags_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN approve for all flags.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = ' CAN approve for all flags.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @all_g_flags_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
			#Then the permissions that are relevant to the component/role
			#These are conditional as this depends on the role attributed to that user
							
				#User can see the cases for Tenants in the unit:
				
		#We CALL ALL the procedures that we have created TO CREATE the permissions we need:
			CALL show_to_tenant;
			CALL is_tenant;
			CALL default_tenant_can_see_tenant;

			CALL show_to_landlord;
			CALL are_users_landlord;
			CALL default_landlord_see_users_landlord;

			CALL show_to_agent;
			CALL are_users_agent;
			CALL default_agent_see_users_agent;

			CALL show_to_contractor;
			CALL are_users_contractor;
			CALL default_contractor_see_users_contractor;

			CALL show_to_mgt_cny;
			CALL are_users_mgt_cny;
			CALL default_mgt_cny_see_users_mgt_cny;
			
			CALL show_to_occupant;
			CALL is_occupant;
			CALL default_occupant_can_see_occupant;
				
		#We give the user the permission they need.

			#We update the `user_group_map` table
				
				#We truncate the table first (to avoid duplicates)
					TRUNCATE TABLE `user_group_map`;
					
				#We insert the data we need
					INSERT INTO `user_group_map`
					SELECT `user_id`
						, `group_id`
						, `isbless`
						, `grant_type`
					FROM
						`ut_user_group_map_temp`
					GROUP BY `user_id`
						, `group_id`
						, `isbless`
						, `grant_type`
					;

		#Update the table 'ut_data_to_replace_dummy_roles' so that we record what we have done
			UPDATE `ut_data_to_replace_dummy_roles`
			SET 
				`bz_created_date` = @timestamp
				, `comment` = CONCAT ('inserted in BZ with the script \''
						, @script
						, '\'\r\ '
						, IFNULL(`comment`, '')
						)
			WHERE `id` = @reference_for_update;
					
		#Clean up
				
			#We Delete the temp table as we do not need it anymore
				DROP TABLE IF EXISTS `ut_user_group_map_temp`;
	
	# Record 6:
		#The unit: What is the id of the record that you want to use in the table 'ut_data_to_replace_dummy_roles'
			SET @reference_for_update = 6;

		#Environment: Which environment are you creatin the unit in?
			#- 1 is for the DEV/Staging
			#- 2 is for the prod environment
			SET @environment = 1;

		#This is needed so that the invitation mechanism works as intended in the MEFE.
				#- Tenant 1
				SET @bz_user_id_dummy_tenant = 4;

				#- Landlord 2
				SET @bz_user_id_dummy_landlord = 3;
				
				#- Contractor 3
				SET @bz_user_id_dummy_contractor = 5;
				
				#- Management company 4
				SET @bz_user_id_dummy_mgt_cny = 6;
				
				#- Agent 5
				SET @bz_user_id_dummy_agent = 2;
			
		#The unit:
			
			#The name and description
				SET @product_id = (SELECT `bz_unit_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

		#The user associated to the first role in this unit.	

			#BZ user id of the user that is creating the unit (default is 1 - Administrator).
			#For LMB migration, we use 2 (support.nobody)
				SET @creator_bz_id = (SELECT `bzfe_invitor_user_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

			#BZ user id of the user that you want to associate to the unit.
				SET @bz_user_id = (SELECT `bz_user_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);
			
			#Role of the user associated to this new unit:
				#- Tenant 1
				#- Landlord 2
				#- Agent 5
				#- Contractor 3
				#- Management company 4
				SET @id_role_type = (SELECT `user_role_type_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);
				SET @role_user_more = (SELECT `user_more` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

			#Is the BZ user an occupant of the unit?
				SET @is_occupant = (SELECT `is_occupant` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

		#We need to get the component for ALL the roles for this product
		#We do that using dummy users for all the roles different from the user role.	
				#- agent -> temporary.agent.dev@unee-t.com
				#- landlord  -> temporary.landlord.dev@unee-t.com
				#- Tenant  -> temporary.tenant.dev@unee-t.com
				#- Contractor  -> temporary.contractor.dev@unee-t.com

		#The Groups to grant the global permissions for the user

			#This should not change, it was hard coded when we created Unee-T
				#See time tracking
				SET @can_see_time_tracking_group_id = 16;
				#Can create shared queries
				SET @can_create_shared_queries_group_id = 17;
				#Can tag comments
				SET @can_tag_comment_group_id = 18;		
				
		#We populate the additional variables that we will need for this script to work
			
			#For the user
				SET @role_user_g_description = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=@id_role_type);
				SET @user_pub_name = (SELECT (LEFT(`login_name`,INSTR(`login_name`,"@")-1)) FROM `profiles` WHERE `userid` = @bz_user_id);
				SET @role_user_pub_info = CONCAT(@user_pub_name
										, IF (@role_user_more = '', '', ' - ')
										, IF (@role_user_more = '', '', @role_user_more)
										)
										;
				SET @user_role_desc = (CONCAT(@role_user_g_description, ' - ',@role_user_pub_info));

			#For the creator
				SET @creator_pub_name = (SELECT `realname` FROM `profiles` WHERE `userid` = @creator_bz_id);

		#Variable needed to avoid script error - NEED TO REVISIT THAT
			SET @can_see_time_tracking = 1;
			SET @can_create_shared_queries = 1;
			SET @can_tag_comment = 1;
			SET @user_is_publicly_visible = 1;
			SET @user_can_see_publicly_visible = 1;
			SET @user_in_cc_for_cases = 0;
			SET @can_create_new_cases = 1;
			SET @can_edit_a_case = 1;
			SET @can_see_all_public_cases = 1;
			SET @can_edit_all_field_in_a_case_regardless_of_role = 1;
			SET @can_ask_to_approve = 1;
			SET @can_approve = 1;
			SET @can_create_any_stakeholder = 0;
			SET @can_create_same_stakeholder = 0;
			SET @can_approve_user_for_flag = 0;
			SET @can_decide_if_user_is_visible = 0;
			SET @can_decide_if_user_can_see_visible = 0;	

		#The user

			#We record the information about the users that we have just created
			#If this is the first time we record something for this user for this unit, we create a new record.
			#If there is already a record for THAT USER for THIS, then we are updating the information
				
				INSERT INTO `ut_map_user_unit_details`
					(`created`
					, `record_created_by`
					, `user_id`
					, `bz_profile_id`
					, `bz_unit_id`
					, `role_type_id`
					, `can_see_time_tracking`
					, `can_create_shared_queries`
					, `can_tag_comment`
					, `is_occupant`
					, `is_public_assignee`
					, `is_see_visible_assignee`
					, `is_in_cc_for_role`
					, `can_create_case`
					, `can_edit_case`
					, `can_see_case`
					, `can_edit_all_field_regardless_of_role`
					, `is_flag_requestee`
					, `is_flag_approver`
					, `can_create_any_sh`
					, `can_create_same_sh`
					, `can_approve_user_for_flags`
					, `can_decide_if_user_visible`
					, `can_decide_if_user_can_see_visible`
					, `public_name`
					, `more_info`
					, `comment`
					)
					VALUES
					(NOW()
					, @creator_bz_id
					, @bz_user_id
					, @bz_user_id
					, @product_id
					, @id_role_type
					#Global permission for the whole installation
					, @can_see_time_tracking
					, @can_create_shared_queries
					, @can_tag_comment
					#Attributes of the user
					, @is_occupant
					#User visibility
					, @user_is_publicly_visible
					, @user_can_see_publicly_visible
					#Permissions for cases for this unit.
					, @user_in_cc_for_cases
					, @can_create_new_cases
					, @can_edit_a_case
					, @can_see_all_public_cases
					, @can_edit_all_field_in_a_case_regardless_of_role
					#For the flags
					, @can_ask_to_approve
					, @can_approve
					#Permissions to create or modify other users
					, @can_create_any_stakeholder
					, @can_create_same_stakeholder
					, @can_approve_user_for_flag
					, @can_decide_if_user_is_visible
					, @can_decide_if_user_can_see_visible
					, @user_pub_name
					, @role_user_more
					, CONCAT('On '
							, NOW()
							, ': Created with the script - '
							, @script
							, '.\r\ '
							, `comment`)
					)
					ON DUPLICATE KEY UPDATE
					`created` = NOW()
					, `record_created_by` = @creator_bz_id
					, `role_type_id` = @id_role_type
					, `can_see_time_tracking` = @can_see_time_tracking
					, `can_create_shared_queries` = @can_create_shared_queries
					, `can_tag_comment` = @can_tag_comment
					, `is_occupant` = @is_occupant
					, `is_public_assignee` = @user_is_publicly_visible
					, `is_see_visible_assignee` = @user_can_see_publicly_visible
					, `is_in_cc_for_role` = @user_in_cc_for_cases
					, `can_create_case` = @can_create_new_cases
					, `can_edit_case` = @can_edit_a_case
					, `can_see_case` = @can_see_all_public_cases
					, `can_edit_all_field_regardless_of_role` = @can_edit_all_field_in_a_case_regardless_of_role
					, `is_flag_requestee` = @can_ask_to_approve
					, `is_flag_approver` = @can_approve
					, `can_create_any_sh` = @can_create_any_stakeholder
					, `can_create_same_sh` = @can_create_same_stakeholder
					, `can_approve_user_for_flags` = @can_approve_user_for_flag
					, `can_decide_if_user_visible` = @can_decide_if_user_is_visible
					, `can_decide_if_user_can_see_visible` = @can_decide_if_user_can_see_visible
					, `public_name` = @user_pub_name
					, `more_info` = CONCAT('On: ', NOW(), '.\r\Updated to ', @role_user_more, '. \r\ ', `more_info`)
					, `comment` = CONCAT('On ', NOW(), '.\r\Updated with the script - ', @script, '.\r\ ', `comment`)
				;

		#We get the information about the goups we need
			#We need to ge these from the ut_product_table_based on the product_id!
				SET @create_case_group_id =  (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 20));
				SET @can_edit_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 25));
				SET @can_see_cases_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 28));
				
				#This is needed until MEFE is able to handle more detailed permissions.
				SET @can_edit_all_field_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 26));
				
				#This is needed so that user can see the unit in the Search panel
				SET @can_see_unit_in_search_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 38));
				
				SET @list_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 4));
				SET @see_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 5));	

				SET @all_r_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 18));
				SET @all_g_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 19));
				
			#Groups created when we created the Role for this product.
				#- show_to_tenant
				#- are_users_tenant
				#- see_users_tenant
				#- show_to_landlord
				#- are_users_landlord
				#- see_users_landlord
				#- show_to_agent
				#- are_users_agent
				#- see_users_agent
				#- show_to_contractor
				#- are_users_contractor
				#- see_users_contractor
				#- show_to_mgt_cny
				#- are_users_mgt_cny
				#- see_users_mgt_cny
				#- show_to_occupant
				#- are_users_occupant
				#- see_users_occupant

				SET @group_id_show_to_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 24));
				SET @group_id_are_users_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 3));
				SET @group_id_see_users_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 36));

				SET @group_id_show_to_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 1));
				SET @group_id_are_users_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 1));
				SET @group_id_see_users_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 1));

				SET @group_id_show_to_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 2));
				SET @group_id_are_users_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 2));
				SET @group_id_see_users_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 2));

				SET @group_id_show_to_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 5));
				SET @group_id_are_users_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 5));
				SET @group_id_see_users_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 5));

				SET @group_id_show_to_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 3));
				SET @group_id_are_users_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 3));
				SET @group_id_see_users_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 3));

				SET @group_id_show_to_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 4));
				SET @group_id_are_users_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 4));
				SET @group_id_see_users_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 4));

		#We get the information about the component/roles that were created:
			
			#We get that from the product_id and dummy user id to make sure that we do not get components with a valid user
				SET @component_id_tenant = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_tenant);
				SET @component_id_landlord = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_landlord);
				SET @component_id_agent = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_agent);
				SET @component_id_contractor = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_contractor);
				SET @component_id_mgt_cny = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_mgt_cny);

			#What is the component_id for this role?
				SET @component_id_this_role = IF( @id_role_type = 1
												, @component_id_tenant
												, IF (@id_role_type = 2
													, @component_id_landlord
													, IF (@id_role_type = 3
														, @component_id_contractor
														, IF (@id_role_type = 4
															, @component_id_mgt_cny
															, IF (@id_role_type = 5
																, @component_id_agent
																, 'Something is very wrong!!'
																)
															)
														)
													)
												)
												;
													
			#We have everything, we can now update the component/role for the unit and make the user default assignee.
				#Get the old values so we can log those
				SET @old_component_initialowner = NULL;
				SET @old_component_initialowner = (SELECT `initialowner` FROM `components` WHERE `id` = @component_id_this_role);
				SET @old_component_initialqacontact = NULL;
				SET @old_component_initialqacontact = (SELECT `initialqacontact` FROM `components` WHERE `id` = @component_id_this_role);
				SET @old_component_description = NULL;
				SET @old_component_description = (SELECT `description` FROM `components` WHERE `id` = @component_id_this_role);
				
				#Update
				UPDATE `components`
				SET 
					`initialowner` = @bz_user_id
					,`initialqacontact` = @bz_user_id
					,`description` = @user_role_desc
					WHERE 
					`id` = @component_id_this_role
					;
				
			#Log the actions of the script.
				SET @script_log_message = CONCAT('The component: '
										, (SELECT IFNULL(@component_id_this_role, 'component_id_this_role is NULL'))
										, ' (for the role_type_id #'
										, (SELECT IFNULL(@id_role_type, 'id_role_type is NULL'))
										, ') has been updated.'
										, '\r\The default user now associated to this role is bz user #'
										, (SELECT IFNULL(@bz_user_id, 'bz_user_id is NULL'))
										, ' (real name: '
										, (SELECT IFNULL(@user_pub_name, 'user_pub_name is NULL'))
										, ') for the unit #' 
										, @product_id
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;
				
				SET @script_log_message = NULL;	
					
		#We update the BZ logs
			INSERT  INTO `audit_log`
				(`user_id`
				,`class`
				,`object_id`
				,`field`
				,`removed`
				,`added`
				,`at_time`
				) 
				VALUES 
				(@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'initialowner',@old_component_initialowner,@bz_user_id,@timestamp)
				, (@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'initialqacontact',@old_component_initialqacontact,@bz_user_id,@timestamp)
				, (@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'description',@old_component_description,@user_role_desc,@timestamp)
				;	
				
		#We now assign the default permissions to the user we just associated to this role:		
			
			#We use a temporary table to make sure we do not have duplicates.
				
				#DELETE the temp table if it exists
				DROP TABLE IF EXISTS `ut_user_group_map_temp`;
				
				#Re-create the temp table
				CREATE TABLE `ut_user_group_map_temp` (
				  `user_id` MEDIUMINT(9) NOT NULL,
				  `group_id` MEDIUMINT(9) NOT NULL,
				  `isbless` TINYINT(4) NOT NULL DEFAULT '0',
				  `grant_type` TINYINT(4) NOT NULL DEFAULT '0'
				) ENGINE=INNODB DEFAULT CHARSET=utf8;

				#Add all the records that exists in the table user_group_map
				INSERT INTO `ut_user_group_map_temp`
					SELECT *
					FROM `user_group_map`;

			#We need to get the id of these groups from the 'ut_product_group' table_based on the product_id
				#For the user - based on the user role:
					#Visibility group
					SET @group_id_show_to_user_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = @id_role_type));
				
					#Is in user Group for the role we just created
					SET @group_id_are_users_same_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = @id_role_type));
					
					#Can See other users in the same Group
					SET @group_id_see_users_same_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = @id_role_type));


		#The default permissions for a user assigned as default for a role are:
		#
			#- time_tracking_permission
			#- can_create_shared_queries
			#- can_tag_comment
		#
			#- can_create_new_cases
			#- can_edit_a_case
			#- can_edit_all_field_case
			#- can_see_unit_in_search
			#- can_see_all_public_cases
			#- user_is_publicly_visible
			#- user_can_see_publicly_visible
			#- can_ask_to_approve (all_r_flags_group_id)
			#- can_approve (all_g_flags_group_id)
		#
		#We create the procedures that will grant the permissions based on the variables from this script.	
		#
			#- show_to_his_role
			#- is_one_of_his_role
			#- can_see_other_in_same_role
		#
		#If applicable
			#- show_to_occupant
			#- is_occupant
			#- can_see_occupant

			#First the global permissions:
				#Can see timetracking
					INSERT  INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id,@can_see_time_tracking_group_id,0,0)
						;
						
					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN See time tracking information.'
												);
					
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						
						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to see time tracking')
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_time_tracking_group_id, @script, 'Add the BZ group id when we grant the permission to see time tracking')
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant see time tracking permission')
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group see time tracking')
							 ;
						 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
			
				#Can create shared queries
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id,@can_create_shared_queries_group_id,0,0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN create shared queries.'
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table

						SET @bzfe_table = 'ut_user_group_map_temp';

						INSERT INTO `ut_audit_log`
								 (`datetime`
								 , `bzfe_table`
								 , `bzfe_field`
								 , `previous_value`
								 , `new_value`
								 , `script`
								 , `comment`
								 )
								 VALUES
								 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to create shared queries')
								 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_create_shared_queries_group_id, @script, 'Add the BZ group id when we grant the permission to create shared queries')
								 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant create shared queries permission')
								 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group create shared queries')
								 ;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;

				#Can tag comments
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id,@can_tag_comment_group_id,0,0)
						;
						
					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN tag comments.'
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to tag comments')
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_tag_comment_group_id, @script, 'Add the BZ group id when we grant the permission to tag comments')
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant tag comments permission')
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group tag comments')
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
			
			#Then the permissions at the unit/product level:	
							
				#User can create a case:
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						#There can be cases when a user is only allowed to see existing cases but NOT create new one.
						#This is an unlikely scenario, but this is technically possible...
						(@bz_user_id, @create_case_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN create new cases for unit '
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'create a new case.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
				#User is allowed to edit cases
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_edit_case_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN edit a cases for unit '
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'edit a case in this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_edit_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
				#User can see the case in the unit even if they are not for his role
					#This allows a user to see the 'public' cases for a given unit.
					#A 'public' case can still only be seen by users in this group!
					#We might NOT want this for employees of a contractor that only need to see the cases IF the case is restricted to
					#the contractor role but NOT if the case is for anyone
					#This is an unlikely scenario, but this is technically possible (ex for technician for a contractor)...
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_see_cases_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN see all public cases for unit '
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'see all public case in this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_cases_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
				#User can edit all fields in the case regardless of his/her role
					#This is needed so until the MEFE can handle permissions.
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_edit_all_field_case_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' can edit all fields in the case regardless of his/her role for the unit#'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'Can edit all fields in the case regardless of his/her role.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_edit_all_field_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;

				#User Can see the unit in the Search panel
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_see_unit_in_search_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' can see the unit#'
												, @product_id
												, ' in the search panel.'
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'Can see the unit in the Search panel.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_unit_in_search_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
				
				#User can be visible to other users regardless of the other users roles
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @list_visible_assignees_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' is one of the visible assignee for cases for this unit.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'is one of the visible assignee for cases for this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @list_visible_assignees_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;

				#User can be visible to other users regardless of the other users roles
					#The below membership is needed so the user can see all the other users regardless of the other users roles
					#We might hide the visible users to some other user (ex: housekeepers or field person do not need to see lanlord or agent
					#They just need to see their manager)
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @see_visible_assignees_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN see the publicly visible users for the case for this unit.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = ' CAN see the publicly visible users for the case for this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @see_visible_assignees_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;				

				#user can create flags (approval requests)				
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES
						(@bz_user_id, @all_r_flags_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN ask for approval for all flags.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = ' CAN ask for approval for all flags.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @all_r_flags_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;	
						
				#user can approve all the flags
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES
						(@bz_user_id, @all_g_flags_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN approve for all flags.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = ' CAN approve for all flags.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @all_g_flags_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
			#Then the permissions that are relevant to the component/role
			#These are conditional as this depends on the role attributed to that user
							
				#User can see the cases for Tenants in the unit:

		#We CALL ALL the procedures that we have created TO CREATE the permissions we need:
			CALL show_to_tenant;
			CALL is_tenant;
			CALL default_tenant_can_see_tenant;

			CALL show_to_landlord;
			CALL are_users_landlord;
			CALL default_landlord_see_users_landlord;

			CALL show_to_agent;
			CALL are_users_agent;
			CALL default_agent_see_users_agent;

			CALL show_to_contractor;
			CALL are_users_contractor;
			CALL default_contractor_see_users_contractor;

			CALL show_to_mgt_cny;
			CALL are_users_mgt_cny;
			CALL default_mgt_cny_see_users_mgt_cny;
			
			CALL show_to_occupant;
			CALL is_occupant;
			CALL default_occupant_can_see_occupant;
				
		#We give the user the permission they need.

			#We update the `user_group_map` table
				
				#We truncate the table first (to avoid duplicates)
					TRUNCATE TABLE `user_group_map`;
					
				#We insert the data we need
					INSERT INTO `user_group_map`
					SELECT `user_id`
						, `group_id`
						, `isbless`
						, `grant_type`
					FROM
						`ut_user_group_map_temp`
					GROUP BY `user_id`
						, `group_id`
						, `isbless`
						, `grant_type`
					;

		#Update the table 'ut_data_to_replace_dummy_roles' so that we record what we have done
			UPDATE `ut_data_to_replace_dummy_roles`
			SET 
				`bz_created_date` = @timestamp
				, `comment` = CONCAT ('inserted in BZ with the script \''
						, @script
						, '\'\r\ '
						, IFNULL(`comment`, '')
						)
			WHERE `id` = @reference_for_update;
					
		#Clean up
				
			#We Delete the temp table as we do not need it anymore
				DROP TABLE IF EXISTS `ut_user_group_map_temp`;
	
	# Record 7:
		#The unit: What is the id of the record that you want to use in the table 'ut_data_to_replace_dummy_roles'
			SET @reference_for_update = 7;

		#Environment: Which environment are you creatin the unit in?
			#- 1 is for the DEV/Staging
			#- 2 is for the prod environment
			SET @environment = 1;

		#This is needed so that the invitation mechanism works as intended in the MEFE.
				#- Tenant 1
				SET @bz_user_id_dummy_tenant = 4;

				#- Landlord 2
				SET @bz_user_id_dummy_landlord = 3;
				
				#- Contractor 3
				SET @bz_user_id_dummy_contractor = 5;
				
				#- Management company 4
				SET @bz_user_id_dummy_mgt_cny = 6;
				
				#- Agent 5
				SET @bz_user_id_dummy_agent = 2;
			
		#The unit:
			
			#The name and description
				SET @product_id = (SELECT `bz_unit_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

		#The user associated to the first role in this unit.	

			#BZ user id of the user that is creating the unit (default is 1 - Administrator).
			#For LMB migration, we use 2 (support.nobody)
				SET @creator_bz_id = (SELECT `bzfe_invitor_user_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

			#BZ user id of the user that you want to associate to the unit.
				SET @bz_user_id = (SELECT `bz_user_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);
			
			#Role of the user associated to this new unit:
				#- Tenant 1
				#- Landlord 2
				#- Agent 5
				#- Contractor 3
				#- Management company 4
				SET @id_role_type = (SELECT `user_role_type_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);
				SET @role_user_more = (SELECT `user_more` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

			#Is the BZ user an occupant of the unit?
				SET @is_occupant = (SELECT `is_occupant` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

		#We need to get the component for ALL the roles for this product
		#We do that using dummy users for all the roles different from the user role.	
				#- agent -> temporary.agent.dev@unee-t.com
				#- landlord  -> temporary.landlord.dev@unee-t.com
				#- Tenant  -> temporary.tenant.dev@unee-t.com
				#- Contractor  -> temporary.contractor.dev@unee-t.com

		#The Groups to grant the global permissions for the user

			#This should not change, it was hard coded when we created Unee-T
				#See time tracking
				SET @can_see_time_tracking_group_id = 16;
				#Can create shared queries
				SET @can_create_shared_queries_group_id = 17;
				#Can tag comments
				SET @can_tag_comment_group_id = 18;		
				
		#We populate the additional variables that we will need for this script to work
			
			#For the user
				SET @role_user_g_description = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=@id_role_type);
				SET @user_pub_name = (SELECT (LEFT(`login_name`,INSTR(`login_name`,"@")-1)) FROM `profiles` WHERE `userid` = @bz_user_id);
				SET @role_user_pub_info = CONCAT(@user_pub_name
										, IF (@role_user_more = '', '', ' - ')
										, IF (@role_user_more = '', '', @role_user_more)
										)
										;
				SET @user_role_desc = (CONCAT(@role_user_g_description, ' - ',@role_user_pub_info));

			#For the creator
				SET @creator_pub_name = (SELECT `realname` FROM `profiles` WHERE `userid` = @creator_bz_id);

		#Variable needed to avoid script error - NEED TO REVISIT THAT
			SET @can_see_time_tracking = 1;
			SET @can_create_shared_queries = 1;
			SET @can_tag_comment = 1;
			SET @user_is_publicly_visible = 1;
			SET @user_can_see_publicly_visible = 1;
			SET @user_in_cc_for_cases = 0;
			SET @can_create_new_cases = 1;
			SET @can_edit_a_case = 1;
			SET @can_see_all_public_cases = 1;
			SET @can_edit_all_field_in_a_case_regardless_of_role = 1;
			SET @can_ask_to_approve = 1;
			SET @can_approve = 1;
			SET @can_create_any_stakeholder = 0;
			SET @can_create_same_stakeholder = 0;
			SET @can_approve_user_for_flag = 0;
			SET @can_decide_if_user_is_visible = 0;
			SET @can_decide_if_user_can_see_visible = 0;	

		#The user

			#We record the information about the users that we have just created
			#If this is the first time we record something for this user for this unit, we create a new record.
			#If there is already a record for THAT USER for THIS, then we are updating the information
				
				INSERT INTO `ut_map_user_unit_details`
					(`created`
					, `record_created_by`
					, `user_id`
					, `bz_profile_id`
					, `bz_unit_id`
					, `role_type_id`
					, `can_see_time_tracking`
					, `can_create_shared_queries`
					, `can_tag_comment`
					, `is_occupant`
					, `is_public_assignee`
					, `is_see_visible_assignee`
					, `is_in_cc_for_role`
					, `can_create_case`
					, `can_edit_case`
					, `can_see_case`
					, `can_edit_all_field_regardless_of_role`
					, `is_flag_requestee`
					, `is_flag_approver`
					, `can_create_any_sh`
					, `can_create_same_sh`
					, `can_approve_user_for_flags`
					, `can_decide_if_user_visible`
					, `can_decide_if_user_can_see_visible`
					, `public_name`
					, `more_info`
					, `comment`
					)
					VALUES
					(NOW()
					, @creator_bz_id
					, @bz_user_id
					, @bz_user_id
					, @product_id
					, @id_role_type
					#Global permission for the whole installation
					, @can_see_time_tracking
					, @can_create_shared_queries
					, @can_tag_comment
					#Attributes of the user
					, @is_occupant
					#User visibility
					, @user_is_publicly_visible
					, @user_can_see_publicly_visible
					#Permissions for cases for this unit.
					, @user_in_cc_for_cases
					, @can_create_new_cases
					, @can_edit_a_case
					, @can_see_all_public_cases
					, @can_edit_all_field_in_a_case_regardless_of_role
					#For the flags
					, @can_ask_to_approve
					, @can_approve
					#Permissions to create or modify other users
					, @can_create_any_stakeholder
					, @can_create_same_stakeholder
					, @can_approve_user_for_flag
					, @can_decide_if_user_is_visible
					, @can_decide_if_user_can_see_visible
					, @user_pub_name
					, @role_user_more
					, CONCAT('On '
							, NOW()
							, ': Created with the script - '
							, @script
							, '.\r\ '
							, `comment`)
					)
					ON DUPLICATE KEY UPDATE
					`created` = NOW()
					, `record_created_by` = @creator_bz_id
					, `role_type_id` = @id_role_type
					, `can_see_time_tracking` = @can_see_time_tracking
					, `can_create_shared_queries` = @can_create_shared_queries
					, `can_tag_comment` = @can_tag_comment
					, `is_occupant` = @is_occupant
					, `is_public_assignee` = @user_is_publicly_visible
					, `is_see_visible_assignee` = @user_can_see_publicly_visible
					, `is_in_cc_for_role` = @user_in_cc_for_cases
					, `can_create_case` = @can_create_new_cases
					, `can_edit_case` = @can_edit_a_case
					, `can_see_case` = @can_see_all_public_cases
					, `can_edit_all_field_regardless_of_role` = @can_edit_all_field_in_a_case_regardless_of_role
					, `is_flag_requestee` = @can_ask_to_approve
					, `is_flag_approver` = @can_approve
					, `can_create_any_sh` = @can_create_any_stakeholder
					, `can_create_same_sh` = @can_create_same_stakeholder
					, `can_approve_user_for_flags` = @can_approve_user_for_flag
					, `can_decide_if_user_visible` = @can_decide_if_user_is_visible
					, `can_decide_if_user_can_see_visible` = @can_decide_if_user_can_see_visible
					, `public_name` = @user_pub_name
					, `more_info` = CONCAT('On: ', NOW(), '.\r\Updated to ', @role_user_more, '. \r\ ', `more_info`)
					, `comment` = CONCAT('On ', NOW(), '.\r\Updated with the script - ', @script, '.\r\ ', `comment`)
				;

		#We get the information about the goups we need
			#We need to ge these from the ut_product_table_based on the product_id!
				SET @create_case_group_id =  (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 20));
				SET @can_edit_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 25));
				SET @can_see_cases_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 28));
				
				#This is needed until MEFE is able to handle more detailed permissions.
				SET @can_edit_all_field_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 26));
				
				#This is needed so that user can see the unit in the Search panel
				SET @can_see_unit_in_search_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 38));
				
				SET @list_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 4));
				SET @see_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 5));	

				SET @all_r_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 18));
				SET @all_g_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 19));
				
			#Groups created when we created the Role for this product.
				#- show_to_tenant
				#- are_users_tenant
				#- see_users_tenant
				#- show_to_landlord
				#- are_users_landlord
				#- see_users_landlord
				#- show_to_agent
				#- are_users_agent
				#- see_users_agent
				#- show_to_contractor
				#- are_users_contractor
				#- see_users_contractor
				#- show_to_mgt_cny
				#- are_users_mgt_cny
				#- see_users_mgt_cny
				#- show_to_occupant
				#- are_users_occupant
				#- see_users_occupant

				SET @group_id_show_to_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 24));
				SET @group_id_are_users_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 3));
				SET @group_id_see_users_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 36));

				SET @group_id_show_to_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 1));
				SET @group_id_are_users_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 1));
				SET @group_id_see_users_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 1));

				SET @group_id_show_to_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 2));
				SET @group_id_are_users_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 2));
				SET @group_id_see_users_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 2));

				SET @group_id_show_to_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 5));
				SET @group_id_are_users_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 5));
				SET @group_id_see_users_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 5));

				SET @group_id_show_to_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 3));
				SET @group_id_are_users_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 3));
				SET @group_id_see_users_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 3));

				SET @group_id_show_to_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 4));
				SET @group_id_are_users_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 4));
				SET @group_id_see_users_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 4));

		#We get the information about the component/roles that were created:
			
			#We get that from the product_id and dummy user id to make sure that we do not get components with a valid user
				SET @component_id_tenant = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_tenant);
				SET @component_id_landlord = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_landlord);
				SET @component_id_agent = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_agent);
				SET @component_id_contractor = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_contractor);
				SET @component_id_mgt_cny = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_mgt_cny);

			#What is the component_id for this role?
				SET @component_id_this_role = IF( @id_role_type = 1
												, @component_id_tenant
												, IF (@id_role_type = 2
													, @component_id_landlord
													, IF (@id_role_type = 3
														, @component_id_contractor
														, IF (@id_role_type = 4
															, @component_id_mgt_cny
															, IF (@id_role_type = 5
																, @component_id_agent
																, 'Something is very wrong!!'
																)
															)
														)
													)
												)
												;
													
			#We have everything, we can now update the component/role for the unit and make the user default assignee.
				#Get the old values so we can log those
				SET @old_component_initialowner = NULL;
				SET @old_component_initialowner = (SELECT `initialowner` FROM `components` WHERE `id` = @component_id_this_role);
				SET @old_component_initialqacontact = NULL;
				SET @old_component_initialqacontact = (SELECT `initialqacontact` FROM `components` WHERE `id` = @component_id_this_role);
				SET @old_component_description = NULL;
				SET @old_component_description = (SELECT `description` FROM `components` WHERE `id` = @component_id_this_role);
				
				#Update
				UPDATE `components`
				SET 
					`initialowner` = @bz_user_id
					,`initialqacontact` = @bz_user_id
					,`description` = @user_role_desc
					WHERE 
					`id` = @component_id_this_role
					;
				
			#Log the actions of the script.
				SET @script_log_message = CONCAT('The component: '
										, (SELECT IFNULL(@component_id_this_role, 'component_id_this_role is NULL'))
										, ' (for the role_type_id #'
										, (SELECT IFNULL(@id_role_type, 'id_role_type is NULL'))
										, ') has been updated.'
										, '\r\The default user now associated to this role is bz user #'
										, (SELECT IFNULL(@bz_user_id, 'bz_user_id is NULL'))
										, ' (real name: '
										, (SELECT IFNULL(@user_pub_name, 'user_pub_name is NULL'))
										, ') for the unit #' 
										, @product_id
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;
				
				SET @script_log_message = NULL;	
					
		#We update the BZ logs
			INSERT  INTO `audit_log`
				(`user_id`
				,`class`
				,`object_id`
				,`field`
				,`removed`
				,`added`
				,`at_time`
				) 
				VALUES 
				(@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'initialowner',@old_component_initialowner,@bz_user_id,@timestamp)
				, (@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'initialqacontact',@old_component_initialqacontact,@bz_user_id,@timestamp)
				, (@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'description',@old_component_description,@user_role_desc,@timestamp)
				;	
				
		#We now assign the default permissions to the user we just associated to this role:		
			
			#We use a temporary table to make sure we do not have duplicates.
				
				#DELETE the temp table if it exists
				DROP TABLE IF EXISTS `ut_user_group_map_temp`;
				
				#Re-create the temp table
				CREATE TABLE `ut_user_group_map_temp` (
				  `user_id` MEDIUMINT(9) NOT NULL,
				  `group_id` MEDIUMINT(9) NOT NULL,
				  `isbless` TINYINT(4) NOT NULL DEFAULT '0',
				  `grant_type` TINYINT(4) NOT NULL DEFAULT '0'
				) ENGINE=INNODB DEFAULT CHARSET=utf8;

				#Add all the records that exists in the table user_group_map
				INSERT INTO `ut_user_group_map_temp`
					SELECT *
					FROM `user_group_map`;

			#We need to get the id of these groups from the 'ut_product_group' table_based on the product_id
				#For the user - based on the user role:
					#Visibility group
					SET @group_id_show_to_user_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = @id_role_type));
				
					#Is in user Group for the role we just created
					SET @group_id_are_users_same_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = @id_role_type));
					
					#Can See other users in the same Group
					SET @group_id_see_users_same_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = @id_role_type));


		#The default permissions for a user assigned as default for a role are:
		#
			#- time_tracking_permission
			#- can_create_shared_queries
			#- can_tag_comment
		#
			#- can_create_new_cases
			#- can_edit_a_case
			#- can_edit_all_field_case
			#- can_see_unit_in_search
			#- can_see_all_public_cases
			#- user_is_publicly_visible
			#- user_can_see_publicly_visible
			#- can_ask_to_approve (all_r_flags_group_id)
			#- can_approve (all_g_flags_group_id)
		#
		#We create the procedures that will grant the permissions based on the variables from this script.	
		#
			#- show_to_his_role
			#- is_one_of_his_role
			#- can_see_other_in_same_role
		#
		#If applicable
			#- show_to_occupant
			#- is_occupant
			#- can_see_occupant

			#First the global permissions:
				#Can see timetracking
					INSERT  INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id,@can_see_time_tracking_group_id,0,0)
						;
						
					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN See time tracking information.'
												);
					
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						
						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to see time tracking')
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_time_tracking_group_id, @script, 'Add the BZ group id when we grant the permission to see time tracking')
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant see time tracking permission')
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group see time tracking')
							 ;
						 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
			
				#Can create shared queries
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id,@can_create_shared_queries_group_id,0,0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN create shared queries.'
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table

						SET @bzfe_table = 'ut_user_group_map_temp';

						INSERT INTO `ut_audit_log`
								 (`datetime`
								 , `bzfe_table`
								 , `bzfe_field`
								 , `previous_value`
								 , `new_value`
								 , `script`
								 , `comment`
								 )
								 VALUES
								 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to create shared queries')
								 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_create_shared_queries_group_id, @script, 'Add the BZ group id when we grant the permission to create shared queries')
								 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant create shared queries permission')
								 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group create shared queries')
								 ;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;

				#Can tag comments
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id,@can_tag_comment_group_id,0,0)
						;
						
					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN tag comments.'
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to tag comments')
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_tag_comment_group_id, @script, 'Add the BZ group id when we grant the permission to tag comments')
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant tag comments permission')
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group tag comments')
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
			
			#Then the permissions at the unit/product level:	
							
				#User can create a case:
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						#There can be cases when a user is only allowed to see existing cases but NOT create new one.
						#This is an unlikely scenario, but this is technically possible...
						(@bz_user_id, @create_case_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN create new cases for unit '
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'create a new case.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
				#User is allowed to edit cases
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_edit_case_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN edit a cases for unit '
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'edit a case in this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_edit_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
				#User can see the case in the unit even if they are not for his role
					#This allows a user to see the 'public' cases for a given unit.
					#A 'public' case can still only be seen by users in this group!
					#We might NOT want this for employees of a contractor that only need to see the cases IF the case is restricted to
					#the contractor role but NOT if the case is for anyone
					#This is an unlikely scenario, but this is technically possible (ex for technician for a contractor)...
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_see_cases_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN see all public cases for unit '
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'see all public case in this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_cases_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
				#User can edit all fields in the case regardless of his/her role
					#This is needed so until the MEFE can handle permissions.
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_edit_all_field_case_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' can edit all fields in the case regardless of his/her role for the unit#'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'Can edit all fields in the case regardless of his/her role.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_edit_all_field_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;

				#User Can see the unit in the Search panel
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_see_unit_in_search_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' can see the unit#'
												, @product_id
												, ' in the search panel.'
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'Can see the unit in the Search panel.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_unit_in_search_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
				
				#User can be visible to other users regardless of the other users roles
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @list_visible_assignees_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' is one of the visible assignee for cases for this unit.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'is one of the visible assignee for cases for this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @list_visible_assignees_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;

				#User can be visible to other users regardless of the other users roles
					#The below membership is needed so the user can see all the other users regardless of the other users roles
					#We might hide the visible users to some other user (ex: housekeepers or field person do not need to see lanlord or agent
					#They just need to see their manager)
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @see_visible_assignees_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN see the publicly visible users for the case for this unit.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = ' CAN see the publicly visible users for the case for this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @see_visible_assignees_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;				

				#user can create flags (approval requests)				
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES
						(@bz_user_id, @all_r_flags_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN ask for approval for all flags.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = ' CAN ask for approval for all flags.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @all_r_flags_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;	
						
				#user can approve all the flags
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES
						(@bz_user_id, @all_g_flags_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN approve for all flags.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = ' CAN approve for all flags.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @all_g_flags_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
			#Then the permissions that are relevant to the component/role
			#These are conditional as this depends on the role attributed to that user
							
				#User can see the cases for Tenants in the unit:
				
		#We CALL ALL the procedures that we have created TO CREATE the permissions we need:
			CALL show_to_tenant;
			CALL is_tenant;
			CALL default_tenant_can_see_tenant;

			CALL show_to_landlord;
			CALL are_users_landlord;
			CALL default_landlord_see_users_landlord;

			CALL show_to_agent;
			CALL are_users_agent;
			CALL default_agent_see_users_agent;

			CALL show_to_contractor;
			CALL are_users_contractor;
			CALL default_contractor_see_users_contractor;

			CALL show_to_mgt_cny;
			CALL are_users_mgt_cny;
			CALL default_mgt_cny_see_users_mgt_cny;
			
			CALL show_to_occupant;
			CALL is_occupant;
			CALL default_occupant_can_see_occupant;
				
		#We give the user the permission they need.

			#We update the `user_group_map` table
				
				#We truncate the table first (to avoid duplicates)
					TRUNCATE TABLE `user_group_map`;
					
				#We insert the data we need
					INSERT INTO `user_group_map`
					SELECT `user_id`
						, `group_id`
						, `isbless`
						, `grant_type`
					FROM
						`ut_user_group_map_temp`
					GROUP BY `user_id`
						, `group_id`
						, `isbless`
						, `grant_type`
					;

		#Update the table 'ut_data_to_replace_dummy_roles' so that we record what we have done
			UPDATE `ut_data_to_replace_dummy_roles`
			SET 
				`bz_created_date` = @timestamp
				, `comment` = CONCAT ('inserted in BZ with the script \''
						, @script
						, '\'\r\ '
						, IFNULL(`comment`, '')
						)
			WHERE `id` = @reference_for_update;
					
		#Clean up
				
			#We Delete the temp table as we do not need it anymore
				DROP TABLE IF EXISTS `ut_user_group_map_temp`;
	
	# Record 8:
		#The unit: What is the id of the record that you want to use in the table 'ut_data_to_replace_dummy_roles'
			SET @reference_for_update = 8;

		#Environment: Which environment are you creatin the unit in?
			#- 1 is for the DEV/Staging
			#- 2 is for the prod environment
			SET @environment = 1;

		#This is needed so that the invitation mechanism works as intended in the MEFE.
				#- Tenant 1
				SET @bz_user_id_dummy_tenant = 4;

				#- Landlord 2
				SET @bz_user_id_dummy_landlord = 3;
				
				#- Contractor 3
				SET @bz_user_id_dummy_contractor = 5;
				
				#- Management company 4
				SET @bz_user_id_dummy_mgt_cny = 6;
				
				#- Agent 5
				SET @bz_user_id_dummy_agent = 2;
			
		#The unit:
			
			#The name and description
				SET @product_id = (SELECT `bz_unit_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

		#The user associated to the first role in this unit.	

			#BZ user id of the user that is creating the unit (default is 1 - Administrator).
			#For LMB migration, we use 2 (support.nobody)
				SET @creator_bz_id = (SELECT `bzfe_invitor_user_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

			#BZ user id of the user that you want to associate to the unit.
				SET @bz_user_id = (SELECT `bz_user_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);
			
			#Role of the user associated to this new unit:
				#- Tenant 1
				#- Landlord 2
				#- Agent 5
				#- Contractor 3
				#- Management company 4
				SET @id_role_type = (SELECT `user_role_type_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);
				SET @role_user_more = (SELECT `user_more` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

			#Is the BZ user an occupant of the unit?
				SET @is_occupant = (SELECT `is_occupant` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

		#We need to get the component for ALL the roles for this product
		#We do that using dummy users for all the roles different from the user role.	
				#- agent -> temporary.agent.dev@unee-t.com
				#- landlord  -> temporary.landlord.dev@unee-t.com
				#- Tenant  -> temporary.tenant.dev@unee-t.com
				#- Contractor  -> temporary.contractor.dev@unee-t.com

		#The Groups to grant the global permissions for the user

			#This should not change, it was hard coded when we created Unee-T
				#See time tracking
				SET @can_see_time_tracking_group_id = 16;
				#Can create shared queries
				SET @can_create_shared_queries_group_id = 17;
				#Can tag comments
				SET @can_tag_comment_group_id = 18;		
				
		#We populate the additional variables that we will need for this script to work
			
			#For the user
				SET @role_user_g_description = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=@id_role_type);
				SET @user_pub_name = (SELECT (LEFT(`login_name`,INSTR(`login_name`,"@")-1)) FROM `profiles` WHERE `userid` = @bz_user_id);
				SET @role_user_pub_info = CONCAT(@user_pub_name
										, IF (@role_user_more = '', '', ' - ')
										, IF (@role_user_more = '', '', @role_user_more)
										)
										;
				SET @user_role_desc = (CONCAT(@role_user_g_description, ' - ',@role_user_pub_info));

			#For the creator
				SET @creator_pub_name = (SELECT `realname` FROM `profiles` WHERE `userid` = @creator_bz_id);

		#Variable needed to avoid script error - NEED TO REVISIT THAT
			SET @can_see_time_tracking = 1;
			SET @can_create_shared_queries = 1;
			SET @can_tag_comment = 1;
			SET @user_is_publicly_visible = 1;
			SET @user_can_see_publicly_visible = 1;
			SET @user_in_cc_for_cases = 0;
			SET @can_create_new_cases = 1;
			SET @can_edit_a_case = 1;
			SET @can_see_all_public_cases = 1;
			SET @can_edit_all_field_in_a_case_regardless_of_role = 1;
			SET @can_ask_to_approve = 1;
			SET @can_approve = 1;
			SET @can_create_any_stakeholder = 0;
			SET @can_create_same_stakeholder = 0;
			SET @can_approve_user_for_flag = 0;
			SET @can_decide_if_user_is_visible = 0;
			SET @can_decide_if_user_can_see_visible = 0;	

		#The user

			#We record the information about the users that we have just created
			#If this is the first time we record something for this user for this unit, we create a new record.
			#If there is already a record for THAT USER for THIS, then we are updating the information
				
				INSERT INTO `ut_map_user_unit_details`
					(`created`
					, `record_created_by`
					, `user_id`
					, `bz_profile_id`
					, `bz_unit_id`
					, `role_type_id`
					, `can_see_time_tracking`
					, `can_create_shared_queries`
					, `can_tag_comment`
					, `is_occupant`
					, `is_public_assignee`
					, `is_see_visible_assignee`
					, `is_in_cc_for_role`
					, `can_create_case`
					, `can_edit_case`
					, `can_see_case`
					, `can_edit_all_field_regardless_of_role`
					, `is_flag_requestee`
					, `is_flag_approver`
					, `can_create_any_sh`
					, `can_create_same_sh`
					, `can_approve_user_for_flags`
					, `can_decide_if_user_visible`
					, `can_decide_if_user_can_see_visible`
					, `public_name`
					, `more_info`
					, `comment`
					)
					VALUES
					(NOW()
					, @creator_bz_id
					, @bz_user_id
					, @bz_user_id
					, @product_id
					, @id_role_type
					#Global permission for the whole installation
					, @can_see_time_tracking
					, @can_create_shared_queries
					, @can_tag_comment
					#Attributes of the user
					, @is_occupant
					#User visibility
					, @user_is_publicly_visible
					, @user_can_see_publicly_visible
					#Permissions for cases for this unit.
					, @user_in_cc_for_cases
					, @can_create_new_cases
					, @can_edit_a_case
					, @can_see_all_public_cases
					, @can_edit_all_field_in_a_case_regardless_of_role
					#For the flags
					, @can_ask_to_approve
					, @can_approve
					#Permissions to create or modify other users
					, @can_create_any_stakeholder
					, @can_create_same_stakeholder
					, @can_approve_user_for_flag
					, @can_decide_if_user_is_visible
					, @can_decide_if_user_can_see_visible
					, @user_pub_name
					, @role_user_more
					, CONCAT('On '
							, NOW()
							, ': Created with the script - '
							, @script
							, '.\r\ '
							, `comment`)
					)
					ON DUPLICATE KEY UPDATE
					`created` = NOW()
					, `record_created_by` = @creator_bz_id
					, `role_type_id` = @id_role_type
					, `can_see_time_tracking` = @can_see_time_tracking
					, `can_create_shared_queries` = @can_create_shared_queries
					, `can_tag_comment` = @can_tag_comment
					, `is_occupant` = @is_occupant
					, `is_public_assignee` = @user_is_publicly_visible
					, `is_see_visible_assignee` = @user_can_see_publicly_visible
					, `is_in_cc_for_role` = @user_in_cc_for_cases
					, `can_create_case` = @can_create_new_cases
					, `can_edit_case` = @can_edit_a_case
					, `can_see_case` = @can_see_all_public_cases
					, `can_edit_all_field_regardless_of_role` = @can_edit_all_field_in_a_case_regardless_of_role
					, `is_flag_requestee` = @can_ask_to_approve
					, `is_flag_approver` = @can_approve
					, `can_create_any_sh` = @can_create_any_stakeholder
					, `can_create_same_sh` = @can_create_same_stakeholder
					, `can_approve_user_for_flags` = @can_approve_user_for_flag
					, `can_decide_if_user_visible` = @can_decide_if_user_is_visible
					, `can_decide_if_user_can_see_visible` = @can_decide_if_user_can_see_visible
					, `public_name` = @user_pub_name
					, `more_info` = CONCAT('On: ', NOW(), '.\r\Updated to ', @role_user_more, '. \r\ ', `more_info`)
					, `comment` = CONCAT('On ', NOW(), '.\r\Updated with the script - ', @script, '.\r\ ', `comment`)
				;

		#We get the information about the goups we need
			#We need to ge these from the ut_product_table_based on the product_id!
				SET @create_case_group_id =  (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 20));
				SET @can_edit_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 25));
				SET @can_see_cases_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 28));
				
				#This is needed until MEFE is able to handle more detailed permissions.
				SET @can_edit_all_field_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 26));
				
				#This is needed so that user can see the unit in the Search panel
				SET @can_see_unit_in_search_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 38));
				
				SET @list_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 4));
				SET @see_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 5));	

				SET @all_r_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 18));
				SET @all_g_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 19));
				
			#Groups created when we created the Role for this product.
				#- show_to_tenant
				#- are_users_tenant
				#- see_users_tenant
				#- show_to_landlord
				#- are_users_landlord
				#- see_users_landlord
				#- show_to_agent
				#- are_users_agent
				#- see_users_agent
				#- show_to_contractor
				#- are_users_contractor
				#- see_users_contractor
				#- show_to_mgt_cny
				#- are_users_mgt_cny
				#- see_users_mgt_cny
				#- show_to_occupant
				#- are_users_occupant
				#- see_users_occupant

				SET @group_id_show_to_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 24));
				SET @group_id_are_users_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 3));
				SET @group_id_see_users_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 36));

				SET @group_id_show_to_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 1));
				SET @group_id_are_users_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 1));
				SET @group_id_see_users_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 1));

				SET @group_id_show_to_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 2));
				SET @group_id_are_users_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 2));
				SET @group_id_see_users_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 2));

				SET @group_id_show_to_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 5));
				SET @group_id_are_users_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 5));
				SET @group_id_see_users_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 5));

				SET @group_id_show_to_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 3));
				SET @group_id_are_users_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 3));
				SET @group_id_see_users_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 3));

				SET @group_id_show_to_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 4));
				SET @group_id_are_users_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 4));
				SET @group_id_see_users_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 4));

		#We get the information about the component/roles that were created:
			
			#We get that from the product_id and dummy user id to make sure that we do not get components with a valid user
				SET @component_id_tenant = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_tenant);
				SET @component_id_landlord = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_landlord);
				SET @component_id_agent = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_agent);
				SET @component_id_contractor = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_contractor);
				SET @component_id_mgt_cny = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_mgt_cny);

			#What is the component_id for this role?
				SET @component_id_this_role = IF( @id_role_type = 1
												, @component_id_tenant
												, IF (@id_role_type = 2
													, @component_id_landlord
													, IF (@id_role_type = 3
														, @component_id_contractor
														, IF (@id_role_type = 4
															, @component_id_mgt_cny
															, IF (@id_role_type = 5
																, @component_id_agent
																, 'Something is very wrong!!'
																)
															)
														)
													)
												)
												;
													
			#We have everything, we can now update the component/role for the unit and make the user default assignee.
				#Get the old values so we can log those
				SET @old_component_initialowner = NULL;
				SET @old_component_initialowner = (SELECT `initialowner` FROM `components` WHERE `id` = @component_id_this_role);
				SET @old_component_initialqacontact = NULL;
				SET @old_component_initialqacontact = (SELECT `initialqacontact` FROM `components` WHERE `id` = @component_id_this_role);
				SET @old_component_description = NULL;
				SET @old_component_description = (SELECT `description` FROM `components` WHERE `id` = @component_id_this_role);
				
				#Update
				UPDATE `components`
				SET 
					`initialowner` = @bz_user_id
					,`initialqacontact` = @bz_user_id
					,`description` = @user_role_desc
					WHERE 
					`id` = @component_id_this_role
					;
				
			#Log the actions of the script.
				SET @script_log_message = CONCAT('The component: '
										, (SELECT IFNULL(@component_id_this_role, 'component_id_this_role is NULL'))
										, ' (for the role_type_id #'
										, (SELECT IFNULL(@id_role_type, 'id_role_type is NULL'))
										, ') has been updated.'
										, '\r\The default user now associated to this role is bz user #'
										, (SELECT IFNULL(@bz_user_id, 'bz_user_id is NULL'))
										, ' (real name: '
										, (SELECT IFNULL(@user_pub_name, 'user_pub_name is NULL'))
										, ') for the unit #' 
										, @product_id
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;
				
				SET @script_log_message = NULL;	
					
		#We update the BZ logs
			INSERT  INTO `audit_log`
				(`user_id`
				,`class`
				,`object_id`
				,`field`
				,`removed`
				,`added`
				,`at_time`
				) 
				VALUES 
				(@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'initialowner',@old_component_initialowner,@bz_user_id,@timestamp)
				, (@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'initialqacontact',@old_component_initialqacontact,@bz_user_id,@timestamp)
				, (@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'description',@old_component_description,@user_role_desc,@timestamp)
				;	
				
		#We now assign the default permissions to the user we just associated to this role:		
			
			#We use a temporary table to make sure we do not have duplicates.
				
				#DELETE the temp table if it exists
				DROP TABLE IF EXISTS `ut_user_group_map_temp`;
				
				#Re-create the temp table
				CREATE TABLE `ut_user_group_map_temp` (
				  `user_id` MEDIUMINT(9) NOT NULL,
				  `group_id` MEDIUMINT(9) NOT NULL,
				  `isbless` TINYINT(4) NOT NULL DEFAULT '0',
				  `grant_type` TINYINT(4) NOT NULL DEFAULT '0'
				) ENGINE=INNODB DEFAULT CHARSET=utf8;

				#Add all the records that exists in the table user_group_map
				INSERT INTO `ut_user_group_map_temp`
					SELECT *
					FROM `user_group_map`;

			#We need to get the id of these groups from the 'ut_product_group' table_based on the product_id
				#For the user - based on the user role:
					#Visibility group
					SET @group_id_show_to_user_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = @id_role_type));
				
					#Is in user Group for the role we just created
					SET @group_id_are_users_same_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = @id_role_type));
					
					#Can See other users in the same Group
					SET @group_id_see_users_same_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = @id_role_type));


		#The default permissions for a user assigned as default for a role are:
		#
			#- time_tracking_permission
			#- can_create_shared_queries
			#- can_tag_comment
		#
			#- can_create_new_cases
			#- can_edit_a_case
			#- can_edit_all_field_case
			#- can_see_unit_in_search
			#- can_see_all_public_cases
			#- user_is_publicly_visible
			#- user_can_see_publicly_visible
			#- can_ask_to_approve (all_r_flags_group_id)
			#- can_approve (all_g_flags_group_id)
		#
		#We create the procedures that will grant the permissions based on the variables from this script.	
		#
			#- show_to_his_role
			#- is_one_of_his_role
			#- can_see_other_in_same_role
		#
		#If applicable
			#- show_to_occupant
			#- is_occupant
			#- can_see_occupant

			#First the global permissions:
				#Can see timetracking
					INSERT  INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id,@can_see_time_tracking_group_id,0,0)
						;
						
					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN See time tracking information.'
												);
					
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						
						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to see time tracking')
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_time_tracking_group_id, @script, 'Add the BZ group id when we grant the permission to see time tracking')
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant see time tracking permission')
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group see time tracking')
							 ;
						 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
			
				#Can create shared queries
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id,@can_create_shared_queries_group_id,0,0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN create shared queries.'
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table

						SET @bzfe_table = 'ut_user_group_map_temp';

						INSERT INTO `ut_audit_log`
								 (`datetime`
								 , `bzfe_table`
								 , `bzfe_field`
								 , `previous_value`
								 , `new_value`
								 , `script`
								 , `comment`
								 )
								 VALUES
								 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to create shared queries')
								 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_create_shared_queries_group_id, @script, 'Add the BZ group id when we grant the permission to create shared queries')
								 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant create shared queries permission')
								 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group create shared queries')
								 ;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;

				#Can tag comments
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id,@can_tag_comment_group_id,0,0)
						;
						
					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN tag comments.'
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to tag comments')
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_tag_comment_group_id, @script, 'Add the BZ group id when we grant the permission to tag comments')
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant tag comments permission')
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group tag comments')
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
			
			#Then the permissions at the unit/product level:	
							
				#User can create a case:
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						#There can be cases when a user is only allowed to see existing cases but NOT create new one.
						#This is an unlikely scenario, but this is technically possible...
						(@bz_user_id, @create_case_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN create new cases for unit '
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'create a new case.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
				#User is allowed to edit cases
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_edit_case_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN edit a cases for unit '
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'edit a case in this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_edit_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
				#User can see the case in the unit even if they are not for his role
					#This allows a user to see the 'public' cases for a given unit.
					#A 'public' case can still only be seen by users in this group!
					#We might NOT want this for employees of a contractor that only need to see the cases IF the case is restricted to
					#the contractor role but NOT if the case is for anyone
					#This is an unlikely scenario, but this is technically possible (ex for technician for a contractor)...
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_see_cases_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN see all public cases for unit '
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'see all public case in this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_cases_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
				#User can edit all fields in the case regardless of his/her role
					#This is needed so until the MEFE can handle permissions.
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_edit_all_field_case_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' can edit all fields in the case regardless of his/her role for the unit#'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'Can edit all fields in the case regardless of his/her role.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_edit_all_field_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;

				#User Can see the unit in the Search panel
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_see_unit_in_search_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' can see the unit#'
												, @product_id
												, ' in the search panel.'
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'Can see the unit in the Search panel.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_unit_in_search_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
				
				#User can be visible to other users regardless of the other users roles
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @list_visible_assignees_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' is one of the visible assignee for cases for this unit.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'is one of the visible assignee for cases for this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @list_visible_assignees_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;

				#User can be visible to other users regardless of the other users roles
					#The below membership is needed so the user can see all the other users regardless of the other users roles
					#We might hide the visible users to some other user (ex: housekeepers or field person do not need to see lanlord or agent
					#They just need to see their manager)
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @see_visible_assignees_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN see the publicly visible users for the case for this unit.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = ' CAN see the publicly visible users for the case for this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @see_visible_assignees_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;				

				#user can create flags (approval requests)				
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES
						(@bz_user_id, @all_r_flags_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN ask for approval for all flags.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = ' CAN ask for approval for all flags.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @all_r_flags_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;	
						
				#user can approve all the flags
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES
						(@bz_user_id, @all_g_flags_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN approve for all flags.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = ' CAN approve for all flags.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @all_g_flags_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
			#Then the permissions that are relevant to the component/role
			#These are conditional as this depends on the role attributed to that user
							
				#User can see the cases for Tenants in the unit:
				
		#We CALL ALL the procedures that we have created TO CREATE the permissions we need:
			CALL show_to_tenant;
			CALL is_tenant;
			CALL default_tenant_can_see_tenant;

			CALL show_to_landlord;
			CALL are_users_landlord;
			CALL default_landlord_see_users_landlord;

			CALL show_to_agent;
			CALL are_users_agent;
			CALL default_agent_see_users_agent;

			CALL show_to_contractor;
			CALL are_users_contractor;
			CALL default_contractor_see_users_contractor;

			CALL show_to_mgt_cny;
			CALL are_users_mgt_cny;
			CALL default_mgt_cny_see_users_mgt_cny;
			
			CALL show_to_occupant;
			CALL is_occupant;
			CALL default_occupant_can_see_occupant;
				
		#We give the user the permission they need.

			#We update the `user_group_map` table
				
				#We truncate the table first (to avoid duplicates)
					TRUNCATE TABLE `user_group_map`;
					
				#We insert the data we need
					INSERT INTO `user_group_map`
					SELECT `user_id`
						, `group_id`
						, `isbless`
						, `grant_type`
					FROM
						`ut_user_group_map_temp`
					GROUP BY `user_id`
						, `group_id`
						, `isbless`
						, `grant_type`
					;

		#Update the table 'ut_data_to_replace_dummy_roles' so that we record what we have done
			UPDATE `ut_data_to_replace_dummy_roles`
			SET 
				`bz_created_date` = @timestamp
				, `comment` = CONCAT ('inserted in BZ with the script \''
						, @script
						, '\'\r\ '
						, IFNULL(`comment`, '')
						)
			WHERE `id` = @reference_for_update;
					
		#Clean up
				
			#We Delete the temp table as we do not need it anymore
				DROP TABLE IF EXISTS `ut_user_group_map_temp`;
	
	# Record 9:
		#The unit: What is the id of the record that you want to use in the table 'ut_data_to_replace_dummy_roles'
			SET @reference_for_update = 9;

		#Environment: Which environment are you creatin the unit in?
			#- 1 is for the DEV/Staging
			#- 2 is for the prod environment
			SET @environment = 1;

		#This is needed so that the invitation mechanism works as intended in the MEFE.
				#- Tenant 1
				SET @bz_user_id_dummy_tenant = 4;

				#- Landlord 2
				SET @bz_user_id_dummy_landlord = 3;
				
				#- Contractor 3
				SET @bz_user_id_dummy_contractor = 5;
				
				#- Management company 4
				SET @bz_user_id_dummy_mgt_cny = 6;
				
				#- Agent 5
				SET @bz_user_id_dummy_agent = 2;
			
		#The unit:
			
			#The name and description
				SET @product_id = (SELECT `bz_unit_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

		#The user associated to the first role in this unit.	

			#BZ user id of the user that is creating the unit (default is 1 - Administrator).
			#For LMB migration, we use 2 (support.nobody)
				SET @creator_bz_id = (SELECT `bzfe_invitor_user_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

			#BZ user id of the user that you want to associate to the unit.
				SET @bz_user_id = (SELECT `bz_user_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);
			
			#Role of the user associated to this new unit:
				#- Tenant 1
				#- Landlord 2
				#- Agent 5
				#- Contractor 3
				#- Management company 4
				SET @id_role_type = (SELECT `user_role_type_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);
				SET @role_user_more = (SELECT `user_more` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

			#Is the BZ user an occupant of the unit?
				SET @is_occupant = (SELECT `is_occupant` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

		#We need to get the component for ALL the roles for this product
		#We do that using dummy users for all the roles different from the user role.	
				#- agent -> temporary.agent.dev@unee-t.com
				#- landlord  -> temporary.landlord.dev@unee-t.com
				#- Tenant  -> temporary.tenant.dev@unee-t.com
				#- Contractor  -> temporary.contractor.dev@unee-t.com

		#The Groups to grant the global permissions for the user

			#This should not change, it was hard coded when we created Unee-T
				#See time tracking
				SET @can_see_time_tracking_group_id = 16;
				#Can create shared queries
				SET @can_create_shared_queries_group_id = 17;
				#Can tag comments
				SET @can_tag_comment_group_id = 18;		
				
		#We populate the additional variables that we will need for this script to work
			
			#For the user
				SET @role_user_g_description = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=@id_role_type);
				SET @user_pub_name = (SELECT (LEFT(`login_name`,INSTR(`login_name`,"@")-1)) FROM `profiles` WHERE `userid` = @bz_user_id);
				SET @role_user_pub_info = CONCAT(@user_pub_name
										, IF (@role_user_more = '', '', ' - ')
										, IF (@role_user_more = '', '', @role_user_more)
										)
										;
				SET @user_role_desc = (CONCAT(@role_user_g_description, ' - ',@role_user_pub_info));

			#For the creator
				SET @creator_pub_name = (SELECT `realname` FROM `profiles` WHERE `userid` = @creator_bz_id);

		#Variable needed to avoid script error - NEED TO REVISIT THAT
			SET @can_see_time_tracking = 1;
			SET @can_create_shared_queries = 1;
			SET @can_tag_comment = 1;
			SET @user_is_publicly_visible = 1;
			SET @user_can_see_publicly_visible = 1;
			SET @user_in_cc_for_cases = 0;
			SET @can_create_new_cases = 1;
			SET @can_edit_a_case = 1;
			SET @can_see_all_public_cases = 1;
			SET @can_edit_all_field_in_a_case_regardless_of_role = 1;
			SET @can_ask_to_approve = 1;
			SET @can_approve = 1;
			SET @can_create_any_stakeholder = 0;
			SET @can_create_same_stakeholder = 0;
			SET @can_approve_user_for_flag = 0;
			SET @can_decide_if_user_is_visible = 0;
			SET @can_decide_if_user_can_see_visible = 0;	

		#The user

			#We record the information about the users that we have just created
			#If this is the first time we record something for this user for this unit, we create a new record.
			#If there is already a record for THAT USER for THIS, then we are updating the information
				
				INSERT INTO `ut_map_user_unit_details`
					(`created`
					, `record_created_by`
					, `user_id`
					, `bz_profile_id`
					, `bz_unit_id`
					, `role_type_id`
					, `can_see_time_tracking`
					, `can_create_shared_queries`
					, `can_tag_comment`
					, `is_occupant`
					, `is_public_assignee`
					, `is_see_visible_assignee`
					, `is_in_cc_for_role`
					, `can_create_case`
					, `can_edit_case`
					, `can_see_case`
					, `can_edit_all_field_regardless_of_role`
					, `is_flag_requestee`
					, `is_flag_approver`
					, `can_create_any_sh`
					, `can_create_same_sh`
					, `can_approve_user_for_flags`
					, `can_decide_if_user_visible`
					, `can_decide_if_user_can_see_visible`
					, `public_name`
					, `more_info`
					, `comment`
					)
					VALUES
					(NOW()
					, @creator_bz_id
					, @bz_user_id
					, @bz_user_id
					, @product_id
					, @id_role_type
					#Global permission for the whole installation
					, @can_see_time_tracking
					, @can_create_shared_queries
					, @can_tag_comment
					#Attributes of the user
					, @is_occupant
					#User visibility
					, @user_is_publicly_visible
					, @user_can_see_publicly_visible
					#Permissions for cases for this unit.
					, @user_in_cc_for_cases
					, @can_create_new_cases
					, @can_edit_a_case
					, @can_see_all_public_cases
					, @can_edit_all_field_in_a_case_regardless_of_role
					#For the flags
					, @can_ask_to_approve
					, @can_approve
					#Permissions to create or modify other users
					, @can_create_any_stakeholder
					, @can_create_same_stakeholder
					, @can_approve_user_for_flag
					, @can_decide_if_user_is_visible
					, @can_decide_if_user_can_see_visible
					, @user_pub_name
					, @role_user_more
					, CONCAT('On '
							, NOW()
							, ': Created with the script - '
							, @script
							, '.\r\ '
							, `comment`)
					)
					ON DUPLICATE KEY UPDATE
					`created` = NOW()
					, `record_created_by` = @creator_bz_id
					, `role_type_id` = @id_role_type
					, `can_see_time_tracking` = @can_see_time_tracking
					, `can_create_shared_queries` = @can_create_shared_queries
					, `can_tag_comment` = @can_tag_comment
					, `is_occupant` = @is_occupant
					, `is_public_assignee` = @user_is_publicly_visible
					, `is_see_visible_assignee` = @user_can_see_publicly_visible
					, `is_in_cc_for_role` = @user_in_cc_for_cases
					, `can_create_case` = @can_create_new_cases
					, `can_edit_case` = @can_edit_a_case
					, `can_see_case` = @can_see_all_public_cases
					, `can_edit_all_field_regardless_of_role` = @can_edit_all_field_in_a_case_regardless_of_role
					, `is_flag_requestee` = @can_ask_to_approve
					, `is_flag_approver` = @can_approve
					, `can_create_any_sh` = @can_create_any_stakeholder
					, `can_create_same_sh` = @can_create_same_stakeholder
					, `can_approve_user_for_flags` = @can_approve_user_for_flag
					, `can_decide_if_user_visible` = @can_decide_if_user_is_visible
					, `can_decide_if_user_can_see_visible` = @can_decide_if_user_can_see_visible
					, `public_name` = @user_pub_name
					, `more_info` = CONCAT('On: ', NOW(), '.\r\Updated to ', @role_user_more, '. \r\ ', `more_info`)
					, `comment` = CONCAT('On ', NOW(), '.\r\Updated with the script - ', @script, '.\r\ ', `comment`)
				;

		#We get the information about the goups we need
			#We need to ge these from the ut_product_table_based on the product_id!
				SET @create_case_group_id =  (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 20));
				SET @can_edit_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 25));
				SET @can_see_cases_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 28));
				
				#This is needed until MEFE is able to handle more detailed permissions.
				SET @can_edit_all_field_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 26));
				
				#This is needed so that user can see the unit in the Search panel
				SET @can_see_unit_in_search_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 38));
				
				SET @list_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 4));
				SET @see_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 5));	

				SET @all_r_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 18));
				SET @all_g_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 19));
				
			#Groups created when we created the Role for this product.
				#- show_to_tenant
				#- are_users_tenant
				#- see_users_tenant
				#- show_to_landlord
				#- are_users_landlord
				#- see_users_landlord
				#- show_to_agent
				#- are_users_agent
				#- see_users_agent
				#- show_to_contractor
				#- are_users_contractor
				#- see_users_contractor
				#- show_to_mgt_cny
				#- are_users_mgt_cny
				#- see_users_mgt_cny
				#- show_to_occupant
				#- are_users_occupant
				#- see_users_occupant

				SET @group_id_show_to_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 24));
				SET @group_id_are_users_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 3));
				SET @group_id_see_users_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 36));

				SET @group_id_show_to_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 1));
				SET @group_id_are_users_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 1));
				SET @group_id_see_users_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 1));

				SET @group_id_show_to_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 2));
				SET @group_id_are_users_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 2));
				SET @group_id_see_users_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 2));

				SET @group_id_show_to_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 5));
				SET @group_id_are_users_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 5));
				SET @group_id_see_users_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 5));

				SET @group_id_show_to_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 3));
				SET @group_id_are_users_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 3));
				SET @group_id_see_users_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 3));

				SET @group_id_show_to_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 4));
				SET @group_id_are_users_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 4));
				SET @group_id_see_users_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 4));

		#We get the information about the component/roles that were created:
			
			#We get that from the product_id and dummy user id to make sure that we do not get components with a valid user
				SET @component_id_tenant = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_tenant);
				SET @component_id_landlord = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_landlord);
				SET @component_id_agent = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_agent);
				SET @component_id_contractor = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_contractor);
				SET @component_id_mgt_cny = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_mgt_cny);

			#What is the component_id for this role?
				SET @component_id_this_role = IF( @id_role_type = 1
												, @component_id_tenant
												, IF (@id_role_type = 2
													, @component_id_landlord
													, IF (@id_role_type = 3
														, @component_id_contractor
														, IF (@id_role_type = 4
															, @component_id_mgt_cny
															, IF (@id_role_type = 5
																, @component_id_agent
																, 'Something is very wrong!!'
																)
															)
														)
													)
												)
												;
													
			#We have everything, we can now update the component/role for the unit and make the user default assignee.
				#Get the old values so we can log those
				SET @old_component_initialowner = NULL;
				SET @old_component_initialowner = (SELECT `initialowner` FROM `components` WHERE `id` = @component_id_this_role);
				SET @old_component_initialqacontact = NULL;
				SET @old_component_initialqacontact = (SELECT `initialqacontact` FROM `components` WHERE `id` = @component_id_this_role);
				SET @old_component_description = NULL;
				SET @old_component_description = (SELECT `description` FROM `components` WHERE `id` = @component_id_this_role);
				
				#Update
				UPDATE `components`
				SET 
					`initialowner` = @bz_user_id
					,`initialqacontact` = @bz_user_id
					,`description` = @user_role_desc
					WHERE 
					`id` = @component_id_this_role
					;
				
			#Log the actions of the script.
				SET @script_log_message = CONCAT('The component: '
										, (SELECT IFNULL(@component_id_this_role, 'component_id_this_role is NULL'))
										, ' (for the role_type_id #'
										, (SELECT IFNULL(@id_role_type, 'id_role_type is NULL'))
										, ') has been updated.'
										, '\r\The default user now associated to this role is bz user #'
										, (SELECT IFNULL(@bz_user_id, 'bz_user_id is NULL'))
										, ' (real name: '
										, (SELECT IFNULL(@user_pub_name, 'user_pub_name is NULL'))
										, ') for the unit #' 
										, @product_id
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;
				
				SET @script_log_message = NULL;	
					
		#We update the BZ logs
			INSERT  INTO `audit_log`
				(`user_id`
				,`class`
				,`object_id`
				,`field`
				,`removed`
				,`added`
				,`at_time`
				) 
				VALUES 
				(@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'initialowner',@old_component_initialowner,@bz_user_id,@timestamp)
				, (@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'initialqacontact',@old_component_initialqacontact,@bz_user_id,@timestamp)
				, (@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'description',@old_component_description,@user_role_desc,@timestamp)
				;	
				
		#We now assign the default permissions to the user we just associated to this role:		
			
			#We use a temporary table to make sure we do not have duplicates.
				
				#DELETE the temp table if it exists
				DROP TABLE IF EXISTS `ut_user_group_map_temp`;
				
				#Re-create the temp table
				CREATE TABLE `ut_user_group_map_temp` (
				  `user_id` MEDIUMINT(9) NOT NULL,
				  `group_id` MEDIUMINT(9) NOT NULL,
				  `isbless` TINYINT(4) NOT NULL DEFAULT '0',
				  `grant_type` TINYINT(4) NOT NULL DEFAULT '0'
				) ENGINE=INNODB DEFAULT CHARSET=utf8;

				#Add all the records that exists in the table user_group_map
				INSERT INTO `ut_user_group_map_temp`
					SELECT *
					FROM `user_group_map`;

			#We need to get the id of these groups from the 'ut_product_group' table_based on the product_id
				#For the user - based on the user role:
					#Visibility group
					SET @group_id_show_to_user_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = @id_role_type));
				
					#Is in user Group for the role we just created
					SET @group_id_are_users_same_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = @id_role_type));
					
					#Can See other users in the same Group
					SET @group_id_see_users_same_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = @id_role_type));


		#The default permissions for a user assigned as default for a role are:
		#
			#- time_tracking_permission
			#- can_create_shared_queries
			#- can_tag_comment
		#
			#- can_create_new_cases
			#- can_edit_a_case
			#- can_edit_all_field_case
			#- can_see_unit_in_search
			#- can_see_all_public_cases
			#- user_is_publicly_visible
			#- user_can_see_publicly_visible
			#- can_ask_to_approve (all_r_flags_group_id)
			#- can_approve (all_g_flags_group_id)
		#
		#We create the procedures that will grant the permissions based on the variables from this script.	
		#
			#- show_to_his_role
			#- is_one_of_his_role
			#- can_see_other_in_same_role
		#
		#If applicable
			#- show_to_occupant
			#- is_occupant
			#- can_see_occupant

			#First the global permissions:
				#Can see timetracking
					INSERT  INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id,@can_see_time_tracking_group_id,0,0)
						;
						
					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN See time tracking information.'
												);
					
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						
						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to see time tracking')
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_time_tracking_group_id, @script, 'Add the BZ group id when we grant the permission to see time tracking')
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant see time tracking permission')
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group see time tracking')
							 ;
						 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
			
				#Can create shared queries
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id,@can_create_shared_queries_group_id,0,0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN create shared queries.'
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table

						SET @bzfe_table = 'ut_user_group_map_temp';

						INSERT INTO `ut_audit_log`
								 (`datetime`
								 , `bzfe_table`
								 , `bzfe_field`
								 , `previous_value`
								 , `new_value`
								 , `script`
								 , `comment`
								 )
								 VALUES
								 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to create shared queries')
								 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_create_shared_queries_group_id, @script, 'Add the BZ group id when we grant the permission to create shared queries')
								 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant create shared queries permission')
								 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group create shared queries')
								 ;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;

				#Can tag comments
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id,@can_tag_comment_group_id,0,0)
						;
						
					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN tag comments.'
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to tag comments')
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_tag_comment_group_id, @script, 'Add the BZ group id when we grant the permission to tag comments')
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant tag comments permission')
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group tag comments')
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
			
			#Then the permissions at the unit/product level:	
							
				#User can create a case:
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						#There can be cases when a user is only allowed to see existing cases but NOT create new one.
						#This is an unlikely scenario, but this is technically possible...
						(@bz_user_id, @create_case_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN create new cases for unit '
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'create a new case.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
				#User is allowed to edit cases
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_edit_case_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN edit a cases for unit '
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'edit a case in this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_edit_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
				#User can see the case in the unit even if they are not for his role
					#This allows a user to see the 'public' cases for a given unit.
					#A 'public' case can still only be seen by users in this group!
					#We might NOT want this for employees of a contractor that only need to see the cases IF the case is restricted to
					#the contractor role but NOT if the case is for anyone
					#This is an unlikely scenario, but this is technically possible (ex for technician for a contractor)...
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_see_cases_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN see all public cases for unit '
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'see all public case in this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_cases_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
				#User can edit all fields in the case regardless of his/her role
					#This is needed so until the MEFE can handle permissions.
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_edit_all_field_case_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' can edit all fields in the case regardless of his/her role for the unit#'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'Can edit all fields in the case regardless of his/her role.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_edit_all_field_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;

				#User Can see the unit in the Search panel
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_see_unit_in_search_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' can see the unit#'
												, @product_id
												, ' in the search panel.'
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'Can see the unit in the Search panel.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_unit_in_search_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
				
				#User can be visible to other users regardless of the other users roles
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @list_visible_assignees_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' is one of the visible assignee for cases for this unit.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'is one of the visible assignee for cases for this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @list_visible_assignees_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;

				#User can be visible to other users regardless of the other users roles
					#The below membership is needed so the user can see all the other users regardless of the other users roles
					#We might hide the visible users to some other user (ex: housekeepers or field person do not need to see lanlord or agent
					#They just need to see their manager)
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @see_visible_assignees_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN see the publicly visible users for the case for this unit.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = ' CAN see the publicly visible users for the case for this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @see_visible_assignees_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;				

				#user can create flags (approval requests)				
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES
						(@bz_user_id, @all_r_flags_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN ask for approval for all flags.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = ' CAN ask for approval for all flags.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @all_r_flags_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;	
						
				#user can approve all the flags
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES
						(@bz_user_id, @all_g_flags_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN approve for all flags.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = ' CAN approve for all flags.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @all_g_flags_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
			#Then the permissions that are relevant to the component/role
			#These are conditional as this depends on the role attributed to that user
				
		#We CALL ALL the procedures that we have created TO CREATE the permissions we need:
			CALL show_to_tenant;
			CALL is_tenant;
			CALL default_tenant_can_see_tenant;

			CALL show_to_landlord;
			CALL are_users_landlord;
			CALL default_landlord_see_users_landlord;

			CALL show_to_agent;
			CALL are_users_agent;
			CALL default_agent_see_users_agent;

			CALL show_to_contractor;
			CALL are_users_contractor;
			CALL default_contractor_see_users_contractor;

			CALL show_to_mgt_cny;
			CALL are_users_mgt_cny;
			CALL default_mgt_cny_see_users_mgt_cny;
			
			CALL show_to_occupant;
			CALL is_occupant;
			CALL default_occupant_can_see_occupant;
				
		#We give the user the permission they need.

			#We update the `user_group_map` table
				
				#We truncate the table first (to avoid duplicates)
					TRUNCATE TABLE `user_group_map`;
					
				#We insert the data we need
					INSERT INTO `user_group_map`
					SELECT `user_id`
						, `group_id`
						, `isbless`
						, `grant_type`
					FROM
						`ut_user_group_map_temp`
					GROUP BY `user_id`
						, `group_id`
						, `isbless`
						, `grant_type`
					;

		#Update the table 'ut_data_to_replace_dummy_roles' so that we record what we have done
			UPDATE `ut_data_to_replace_dummy_roles`
			SET 
				`bz_created_date` = @timestamp
				, `comment` = CONCAT ('inserted in BZ with the script \''
						, @script
						, '\'\r\ '
						, IFNULL(`comment`, '')
						)
			WHERE `id` = @reference_for_update;
					
		#Clean up
				
			#We Delete the temp table as we do not need it anymore
				DROP TABLE IF EXISTS `ut_user_group_map_temp`;
	
	# Record 10:
		#The unit: What is the id of the record that you want to use in the table 'ut_data_to_replace_dummy_roles'
			SET @reference_for_update = 10;

		#Environment: Which environment are you creatin the unit in?
			#- 1 is for the DEV/Staging
			#- 2 is for the prod environment
			SET @environment = 1;

		#This is needed so that the invitation mechanism works as intended in the MEFE.
				#- Tenant 1
				SET @bz_user_id_dummy_tenant = 4;

				#- Landlord 2
				SET @bz_user_id_dummy_landlord = 3;
				
				#- Contractor 3
				SET @bz_user_id_dummy_contractor = 5;
				
				#- Management company 4
				SET @bz_user_id_dummy_mgt_cny = 6;
				
				#- Agent 5
				SET @bz_user_id_dummy_agent = 2;
			
		#The unit:
			
			#The name and description
				SET @product_id = (SELECT `bz_unit_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

		#The user associated to the first role in this unit.	

			#BZ user id of the user that is creating the unit (default is 1 - Administrator).
			#For LMB migration, we use 2 (support.nobody)
				SET @creator_bz_id = (SELECT `bzfe_invitor_user_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

			#BZ user id of the user that you want to associate to the unit.
				SET @bz_user_id = (SELECT `bz_user_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);
			
			#Role of the user associated to this new unit:
				#- Tenant 1
				#- Landlord 2
				#- Agent 5
				#- Contractor 3
				#- Management company 4
				SET @id_role_type = (SELECT `user_role_type_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);
				SET @role_user_more = (SELECT `user_more` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

			#Is the BZ user an occupant of the unit?
				SET @is_occupant = (SELECT `is_occupant` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

		#We need to get the component for ALL the roles for this product
		#We do that using dummy users for all the roles different from the user role.	
				#- agent -> temporary.agent.dev@unee-t.com
				#- landlord  -> temporary.landlord.dev@unee-t.com
				#- Tenant  -> temporary.tenant.dev@unee-t.com
				#- Contractor  -> temporary.contractor.dev@unee-t.com

		#The Groups to grant the global permissions for the user

			#This should not change, it was hard coded when we created Unee-T
				#See time tracking
				SET @can_see_time_tracking_group_id = 16;
				#Can create shared queries
				SET @can_create_shared_queries_group_id = 17;
				#Can tag comments
				SET @can_tag_comment_group_id = 18;		
				
		#We populate the additional variables that we will need for this script to work
			
			#For the user
				SET @role_user_g_description = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=@id_role_type);
				SET @user_pub_name = (SELECT (LEFT(`login_name`,INSTR(`login_name`,"@")-1)) FROM `profiles` WHERE `userid` = @bz_user_id);
				SET @role_user_pub_info = CONCAT(@user_pub_name
										, IF (@role_user_more = '', '', ' - ')
										, IF (@role_user_more = '', '', @role_user_more)
										)
										;
				SET @user_role_desc = (CONCAT(@role_user_g_description, ' - ',@role_user_pub_info));

			#For the creator
				SET @creator_pub_name = (SELECT `realname` FROM `profiles` WHERE `userid` = @creator_bz_id);

		#Variable needed to avoid script error - NEED TO REVISIT THAT
			SET @can_see_time_tracking = 1;
			SET @can_create_shared_queries = 1;
			SET @can_tag_comment = 1;
			SET @user_is_publicly_visible = 1;
			SET @user_can_see_publicly_visible = 1;
			SET @user_in_cc_for_cases = 0;
			SET @can_create_new_cases = 1;
			SET @can_edit_a_case = 1;
			SET @can_see_all_public_cases = 1;
			SET @can_edit_all_field_in_a_case_regardless_of_role = 1;
			SET @can_ask_to_approve = 1;
			SET @can_approve = 1;
			SET @can_create_any_stakeholder = 0;
			SET @can_create_same_stakeholder = 0;
			SET @can_approve_user_for_flag = 0;
			SET @can_decide_if_user_is_visible = 0;
			SET @can_decide_if_user_can_see_visible = 0;	

		#The user

			#We record the information about the users that we have just created
			#If this is the first time we record something for this user for this unit, we create a new record.
			#If there is already a record for THAT USER for THIS, then we are updating the information
				
				INSERT INTO `ut_map_user_unit_details`
					(`created`
					, `record_created_by`
					, `user_id`
					, `bz_profile_id`
					, `bz_unit_id`
					, `role_type_id`
					, `can_see_time_tracking`
					, `can_create_shared_queries`
					, `can_tag_comment`
					, `is_occupant`
					, `is_public_assignee`
					, `is_see_visible_assignee`
					, `is_in_cc_for_role`
					, `can_create_case`
					, `can_edit_case`
					, `can_see_case`
					, `can_edit_all_field_regardless_of_role`
					, `is_flag_requestee`
					, `is_flag_approver`
					, `can_create_any_sh`
					, `can_create_same_sh`
					, `can_approve_user_for_flags`
					, `can_decide_if_user_visible`
					, `can_decide_if_user_can_see_visible`
					, `public_name`
					, `more_info`
					, `comment`
					)
					VALUES
					(NOW()
					, @creator_bz_id
					, @bz_user_id
					, @bz_user_id
					, @product_id
					, @id_role_type
					#Global permission for the whole installation
					, @can_see_time_tracking
					, @can_create_shared_queries
					, @can_tag_comment
					#Attributes of the user
					, @is_occupant
					#User visibility
					, @user_is_publicly_visible
					, @user_can_see_publicly_visible
					#Permissions for cases for this unit.
					, @user_in_cc_for_cases
					, @can_create_new_cases
					, @can_edit_a_case
					, @can_see_all_public_cases
					, @can_edit_all_field_in_a_case_regardless_of_role
					#For the flags
					, @can_ask_to_approve
					, @can_approve
					#Permissions to create or modify other users
					, @can_create_any_stakeholder
					, @can_create_same_stakeholder
					, @can_approve_user_for_flag
					, @can_decide_if_user_is_visible
					, @can_decide_if_user_can_see_visible
					, @user_pub_name
					, @role_user_more
					, CONCAT('On '
							, NOW()
							, ': Created with the script - '
							, @script
							, '.\r\ '
							, `comment`)
					)
					ON DUPLICATE KEY UPDATE
					`created` = NOW()
					, `record_created_by` = @creator_bz_id
					, `role_type_id` = @id_role_type
					, `can_see_time_tracking` = @can_see_time_tracking
					, `can_create_shared_queries` = @can_create_shared_queries
					, `can_tag_comment` = @can_tag_comment
					, `is_occupant` = @is_occupant
					, `is_public_assignee` = @user_is_publicly_visible
					, `is_see_visible_assignee` = @user_can_see_publicly_visible
					, `is_in_cc_for_role` = @user_in_cc_for_cases
					, `can_create_case` = @can_create_new_cases
					, `can_edit_case` = @can_edit_a_case
					, `can_see_case` = @can_see_all_public_cases
					, `can_edit_all_field_regardless_of_role` = @can_edit_all_field_in_a_case_regardless_of_role
					, `is_flag_requestee` = @can_ask_to_approve
					, `is_flag_approver` = @can_approve
					, `can_create_any_sh` = @can_create_any_stakeholder
					, `can_create_same_sh` = @can_create_same_stakeholder
					, `can_approve_user_for_flags` = @can_approve_user_for_flag
					, `can_decide_if_user_visible` = @can_decide_if_user_is_visible
					, `can_decide_if_user_can_see_visible` = @can_decide_if_user_can_see_visible
					, `public_name` = @user_pub_name
					, `more_info` = CONCAT('On: ', NOW(), '.\r\Updated to ', @role_user_more, '. \r\ ', `more_info`)
					, `comment` = CONCAT('On ', NOW(), '.\r\Updated with the script - ', @script, '.\r\ ', `comment`)
				;

		#We get the information about the goups we need
			#We need to ge these from the ut_product_table_based on the product_id!
				SET @create_case_group_id =  (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 20));
				SET @can_edit_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 25));
				SET @can_see_cases_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 28));
				
				#This is needed until MEFE is able to handle more detailed permissions.
				SET @can_edit_all_field_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 26));
				
				#This is needed so that user can see the unit in the Search panel
				SET @can_see_unit_in_search_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 38));
				
				SET @list_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 4));
				SET @see_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 5));	

				SET @all_r_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 18));
				SET @all_g_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 19));
				
			#Groups created when we created the Role for this product.
				#- show_to_tenant
				#- are_users_tenant
				#- see_users_tenant
				#- show_to_landlord
				#- are_users_landlord
				#- see_users_landlord
				#- show_to_agent
				#- are_users_agent
				#- see_users_agent
				#- show_to_contractor
				#- are_users_contractor
				#- see_users_contractor
				#- show_to_mgt_cny
				#- are_users_mgt_cny
				#- see_users_mgt_cny
				#- show_to_occupant
				#- are_users_occupant
				#- see_users_occupant

				SET @group_id_show_to_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 24));
				SET @group_id_are_users_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 3));
				SET @group_id_see_users_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 36));

				SET @group_id_show_to_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 1));
				SET @group_id_are_users_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 1));
				SET @group_id_see_users_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 1));

				SET @group_id_show_to_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 2));
				SET @group_id_are_users_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 2));
				SET @group_id_see_users_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 2));

				SET @group_id_show_to_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 5));
				SET @group_id_are_users_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 5));
				SET @group_id_see_users_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 5));

				SET @group_id_show_to_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 3));
				SET @group_id_are_users_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 3));
				SET @group_id_see_users_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 3));

				SET @group_id_show_to_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 4));
				SET @group_id_are_users_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 4));
				SET @group_id_see_users_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 4));

		#We get the information about the component/roles that were created:
			
			#We get that from the product_id and dummy user id to make sure that we do not get components with a valid user
				SET @component_id_tenant = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_tenant);
				SET @component_id_landlord = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_landlord);
				SET @component_id_agent = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_agent);
				SET @component_id_contractor = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_contractor);
				SET @component_id_mgt_cny = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_mgt_cny);

			#What is the component_id for this role?
				SET @component_id_this_role = IF( @id_role_type = 1
												, @component_id_tenant
												, IF (@id_role_type = 2
													, @component_id_landlord
													, IF (@id_role_type = 3
														, @component_id_contractor
														, IF (@id_role_type = 4
															, @component_id_mgt_cny
															, IF (@id_role_type = 5
																, @component_id_agent
																, 'Something is very wrong!!'
																)
															)
														)
													)
												)
												;
													
			#We have everything, we can now update the component/role for the unit and make the user default assignee.
				#Get the old values so we can log those
				SET @old_component_initialowner = NULL;
				SET @old_component_initialowner = (SELECT `initialowner` FROM `components` WHERE `id` = @component_id_this_role);
				SET @old_component_initialqacontact = NULL;
				SET @old_component_initialqacontact = (SELECT `initialqacontact` FROM `components` WHERE `id` = @component_id_this_role);
				SET @old_component_description = NULL;
				SET @old_component_description = (SELECT `description` FROM `components` WHERE `id` = @component_id_this_role);
				
				#Update
				UPDATE `components`
				SET 
					`initialowner` = @bz_user_id
					,`initialqacontact` = @bz_user_id
					,`description` = @user_role_desc
					WHERE 
					`id` = @component_id_this_role
					;
				
			#Log the actions of the script.
				SET @script_log_message = CONCAT('The component: '
										, (SELECT IFNULL(@component_id_this_role, 'component_id_this_role is NULL'))
										, ' (for the role_type_id #'
										, (SELECT IFNULL(@id_role_type, 'id_role_type is NULL'))
										, ') has been updated.'
										, '\r\The default user now associated to this role is bz user #'
										, (SELECT IFNULL(@bz_user_id, 'bz_user_id is NULL'))
										, ' (real name: '
										, (SELECT IFNULL(@user_pub_name, 'user_pub_name is NULL'))
										, ') for the unit #' 
										, @product_id
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;
				
				SET @script_log_message = NULL;	
					
		#We update the BZ logs
			INSERT  INTO `audit_log`
				(`user_id`
				,`class`
				,`object_id`
				,`field`
				,`removed`
				,`added`
				,`at_time`
				) 
				VALUES 
				(@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'initialowner',@old_component_initialowner,@bz_user_id,@timestamp)
				, (@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'initialqacontact',@old_component_initialqacontact,@bz_user_id,@timestamp)
				, (@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'description',@old_component_description,@user_role_desc,@timestamp)
				;	
				
		#We now assign the default permissions to the user we just associated to this role:		
			
			#We use a temporary table to make sure we do not have duplicates.
				
				#DELETE the temp table if it exists
				DROP TABLE IF EXISTS `ut_user_group_map_temp`;
				
				#Re-create the temp table
				CREATE TABLE `ut_user_group_map_temp` (
				  `user_id` MEDIUMINT(9) NOT NULL,
				  `group_id` MEDIUMINT(9) NOT NULL,
				  `isbless` TINYINT(4) NOT NULL DEFAULT '0',
				  `grant_type` TINYINT(4) NOT NULL DEFAULT '0'
				) ENGINE=INNODB DEFAULT CHARSET=utf8;

				#Add all the records that exists in the table user_group_map
				INSERT INTO `ut_user_group_map_temp`
					SELECT *
					FROM `user_group_map`;

			#We need to get the id of these groups from the 'ut_product_group' table_based on the product_id
				#For the user - based on the user role:
					#Visibility group
					SET @group_id_show_to_user_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = @id_role_type));
				
					#Is in user Group for the role we just created
					SET @group_id_are_users_same_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = @id_role_type));
					
					#Can See other users in the same Group
					SET @group_id_see_users_same_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = @id_role_type));


		#The default permissions for a user assigned as default for a role are:
		#
			#- time_tracking_permission
			#- can_create_shared_queries
			#- can_tag_comment
		#
			#- can_create_new_cases
			#- can_edit_a_case
			#- can_edit_all_field_case
			#- can_see_unit_in_search
			#- can_see_all_public_cases
			#- user_is_publicly_visible
			#- user_can_see_publicly_visible
			#- can_ask_to_approve (all_r_flags_group_id)
			#- can_approve (all_g_flags_group_id)
		#
		#We create the procedures that will grant the permissions based on the variables from this script.	
		#
			#- show_to_his_role
			#- is_one_of_his_role
			#- can_see_other_in_same_role
		#
		#If applicable
			#- show_to_occupant
			#- is_occupant
			#- can_see_occupant

			#First the global permissions:
				#Can see timetracking
					INSERT  INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id,@can_see_time_tracking_group_id,0,0)
						;
						
					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN See time tracking information.'
												);
					
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						
						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to see time tracking')
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_time_tracking_group_id, @script, 'Add the BZ group id when we grant the permission to see time tracking')
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant see time tracking permission')
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group see time tracking')
							 ;
						 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
			
				#Can create shared queries
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id,@can_create_shared_queries_group_id,0,0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN create shared queries.'
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table

						SET @bzfe_table = 'ut_user_group_map_temp';

						INSERT INTO `ut_audit_log`
								 (`datetime`
								 , `bzfe_table`
								 , `bzfe_field`
								 , `previous_value`
								 , `new_value`
								 , `script`
								 , `comment`
								 )
								 VALUES
								 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to create shared queries')
								 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_create_shared_queries_group_id, @script, 'Add the BZ group id when we grant the permission to create shared queries')
								 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant create shared queries permission')
								 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group create shared queries')
								 ;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;

				#Can tag comments
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id,@can_tag_comment_group_id,0,0)
						;
						
					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN tag comments.'
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to tag comments')
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_tag_comment_group_id, @script, 'Add the BZ group id when we grant the permission to tag comments')
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant tag comments permission')
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group tag comments')
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
			
			#Then the permissions at the unit/product level:	
							
				#User can create a case:
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						#There can be cases when a user is only allowed to see existing cases but NOT create new one.
						#This is an unlikely scenario, but this is technically possible...
						(@bz_user_id, @create_case_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN create new cases for unit '
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'create a new case.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
				#User is allowed to edit cases
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_edit_case_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN edit a cases for unit '
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'edit a case in this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_edit_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
				#User can see the case in the unit even if they are not for his role
					#This allows a user to see the 'public' cases for a given unit.
					#A 'public' case can still only be seen by users in this group!
					#We might NOT want this for employees of a contractor that only need to see the cases IF the case is restricted to
					#the contractor role but NOT if the case is for anyone
					#This is an unlikely scenario, but this is technically possible (ex for technician for a contractor)...
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_see_cases_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN see all public cases for unit '
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'see all public case in this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_cases_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
				#User can edit all fields in the case regardless of his/her role
					#This is needed so until the MEFE can handle permissions.
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_edit_all_field_case_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' can edit all fields in the case regardless of his/her role for the unit#'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'Can edit all fields in the case regardless of his/her role.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_edit_all_field_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;

				#User Can see the unit in the Search panel
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_see_unit_in_search_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' can see the unit#'
												, @product_id
												, ' in the search panel.'
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'Can see the unit in the Search panel.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_unit_in_search_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
				
				#User can be visible to other users regardless of the other users roles
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @list_visible_assignees_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' is one of the visible assignee for cases for this unit.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'is one of the visible assignee for cases for this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @list_visible_assignees_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;

				#User can be visible to other users regardless of the other users roles
					#The below membership is needed so the user can see all the other users regardless of the other users roles
					#We might hide the visible users to some other user (ex: housekeepers or field person do not need to see lanlord or agent
					#They just need to see their manager)
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @see_visible_assignees_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN see the publicly visible users for the case for this unit.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = ' CAN see the publicly visible users for the case for this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @see_visible_assignees_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;				

				#user can create flags (approval requests)				
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES
						(@bz_user_id, @all_r_flags_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN ask for approval for all flags.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = ' CAN ask for approval for all flags.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @all_r_flags_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;	
						
				#user can approve all the flags
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES
						(@bz_user_id, @all_g_flags_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN approve for all flags.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = ' CAN approve for all flags.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @all_g_flags_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
			#Then the permissions that are relevant to the component/role
			#These are conditional as this depends on the role attributed to that user
				
		#We CALL ALL the procedures that we have created TO CREATE the permissions we need:
			CALL show_to_tenant;
			CALL is_tenant;
			CALL default_tenant_can_see_tenant;

			CALL show_to_landlord;
			CALL are_users_landlord;
			CALL default_landlord_see_users_landlord;

			CALL show_to_agent;
			CALL are_users_agent;
			CALL default_agent_see_users_agent;

			CALL show_to_contractor;
			CALL are_users_contractor;
			CALL default_contractor_see_users_contractor;

			CALL show_to_mgt_cny;
			CALL are_users_mgt_cny;
			CALL default_mgt_cny_see_users_mgt_cny;
			
			CALL show_to_occupant;
			CALL is_occupant;
			CALL default_occupant_can_see_occupant;
				
		#We give the user the permission they need.

			#We update the `user_group_map` table
				
				#We truncate the table first (to avoid duplicates)
					TRUNCATE TABLE `user_group_map`;
					
				#We insert the data we need
					INSERT INTO `user_group_map`
					SELECT `user_id`
						, `group_id`
						, `isbless`
						, `grant_type`
					FROM
						`ut_user_group_map_temp`
					GROUP BY `user_id`
						, `group_id`
						, `isbless`
						, `grant_type`
					;

		#Update the table 'ut_data_to_replace_dummy_roles' so that we record what we have done
			UPDATE `ut_data_to_replace_dummy_roles`
			SET 
				`bz_created_date` = @timestamp
				, `comment` = CONCAT ('inserted in BZ with the script \''
						, @script
						, '\'\r\ '
						, IFNULL(`comment`, '')
						)
			WHERE `id` = @reference_for_update;
					
		#Clean up
				
			#We Delete the temp table as we do not need it anymore
				DROP TABLE IF EXISTS `ut_user_group_map_temp`;
	
	# Record 11:
		#The unit: What is the id of the record that you want to use in the table 'ut_data_to_replace_dummy_roles'
			SET @reference_for_update = 11;

		#Environment: Which environment are you creatin the unit in?
			#- 1 is for the DEV/Staging
			#- 2 is for the prod environment
			SET @environment = 1;

		#This is needed so that the invitation mechanism works as intended in the MEFE.
				#- Tenant 1
				SET @bz_user_id_dummy_tenant = 4;

				#- Landlord 2
				SET @bz_user_id_dummy_landlord = 3;
				
				#- Contractor 3
				SET @bz_user_id_dummy_contractor = 5;
				
				#- Management company 4
				SET @bz_user_id_dummy_mgt_cny = 6;
				
				#- Agent 5
				SET @bz_user_id_dummy_agent = 2;
			
		#The unit:
			
			#The name and description
				SET @product_id = (SELECT `bz_unit_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

		#The user associated to the first role in this unit.	

			#BZ user id of the user that is creating the unit (default is 1 - Administrator).
			#For LMB migration, we use 2 (support.nobody)
				SET @creator_bz_id = (SELECT `bzfe_invitor_user_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

			#BZ user id of the user that you want to associate to the unit.
				SET @bz_user_id = (SELECT `bz_user_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);
			
			#Role of the user associated to this new unit:
				#- Tenant 1
				#- Landlord 2
				#- Agent 5
				#- Contractor 3
				#- Management company 4
				SET @id_role_type = (SELECT `user_role_type_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);
				SET @role_user_more = (SELECT `user_more` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

			#Is the BZ user an occupant of the unit?
				SET @is_occupant = (SELECT `is_occupant` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

		#We need to get the component for ALL the roles for this product
		#We do that using dummy users for all the roles different from the user role.	
				#- agent -> temporary.agent.dev@unee-t.com
				#- landlord  -> temporary.landlord.dev@unee-t.com
				#- Tenant  -> temporary.tenant.dev@unee-t.com
				#- Contractor  -> temporary.contractor.dev@unee-t.com

		#The Groups to grant the global permissions for the user

			#This should not change, it was hard coded when we created Unee-T
				#See time tracking
				SET @can_see_time_tracking_group_id = 16;
				#Can create shared queries
				SET @can_create_shared_queries_group_id = 17;
				#Can tag comments
				SET @can_tag_comment_group_id = 18;		
				
		#We populate the additional variables that we will need for this script to work
			
			#For the user
				SET @role_user_g_description = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=@id_role_type);
				SET @user_pub_name = (SELECT (LEFT(`login_name`,INSTR(`login_name`,"@")-1)) FROM `profiles` WHERE `userid` = @bz_user_id);
				SET @role_user_pub_info = CONCAT(@user_pub_name
										, IF (@role_user_more = '', '', ' - ')
										, IF (@role_user_more = '', '', @role_user_more)
										)
										;
				SET @user_role_desc = (CONCAT(@role_user_g_description, ' - ',@role_user_pub_info));

			#For the creator
				SET @creator_pub_name = (SELECT `realname` FROM `profiles` WHERE `userid` = @creator_bz_id);

		#Variable needed to avoid script error - NEED TO REVISIT THAT
			SET @can_see_time_tracking = 1;
			SET @can_create_shared_queries = 1;
			SET @can_tag_comment = 1;
			SET @user_is_publicly_visible = 1;
			SET @user_can_see_publicly_visible = 1;
			SET @user_in_cc_for_cases = 0;
			SET @can_create_new_cases = 1;
			SET @can_edit_a_case = 1;
			SET @can_see_all_public_cases = 1;
			SET @can_edit_all_field_in_a_case_regardless_of_role = 1;
			SET @can_ask_to_approve = 1;
			SET @can_approve = 1;
			SET @can_create_any_stakeholder = 0;
			SET @can_create_same_stakeholder = 0;
			SET @can_approve_user_for_flag = 0;
			SET @can_decide_if_user_is_visible = 0;
			SET @can_decide_if_user_can_see_visible = 0;	

		#The user

			#We record the information about the users that we have just created
			#If this is the first time we record something for this user for this unit, we create a new record.
			#If there is already a record for THAT USER for THIS, then we are updating the information
				
				INSERT INTO `ut_map_user_unit_details`
					(`created`
					, `record_created_by`
					, `user_id`
					, `bz_profile_id`
					, `bz_unit_id`
					, `role_type_id`
					, `can_see_time_tracking`
					, `can_create_shared_queries`
					, `can_tag_comment`
					, `is_occupant`
					, `is_public_assignee`
					, `is_see_visible_assignee`
					, `is_in_cc_for_role`
					, `can_create_case`
					, `can_edit_case`
					, `can_see_case`
					, `can_edit_all_field_regardless_of_role`
					, `is_flag_requestee`
					, `is_flag_approver`
					, `can_create_any_sh`
					, `can_create_same_sh`
					, `can_approve_user_for_flags`
					, `can_decide_if_user_visible`
					, `can_decide_if_user_can_see_visible`
					, `public_name`
					, `more_info`
					, `comment`
					)
					VALUES
					(NOW()
					, @creator_bz_id
					, @bz_user_id
					, @bz_user_id
					, @product_id
					, @id_role_type
					#Global permission for the whole installation
					, @can_see_time_tracking
					, @can_create_shared_queries
					, @can_tag_comment
					#Attributes of the user
					, @is_occupant
					#User visibility
					, @user_is_publicly_visible
					, @user_can_see_publicly_visible
					#Permissions for cases for this unit.
					, @user_in_cc_for_cases
					, @can_create_new_cases
					, @can_edit_a_case
					, @can_see_all_public_cases
					, @can_edit_all_field_in_a_case_regardless_of_role
					#For the flags
					, @can_ask_to_approve
					, @can_approve
					#Permissions to create or modify other users
					, @can_create_any_stakeholder
					, @can_create_same_stakeholder
					, @can_approve_user_for_flag
					, @can_decide_if_user_is_visible
					, @can_decide_if_user_can_see_visible
					, @user_pub_name
					, @role_user_more
					, CONCAT('On '
							, NOW()
							, ': Created with the script - '
							, @script
							, '.\r\ '
							, `comment`)
					)
					ON DUPLICATE KEY UPDATE
					`created` = NOW()
					, `record_created_by` = @creator_bz_id
					, `role_type_id` = @id_role_type
					, `can_see_time_tracking` = @can_see_time_tracking
					, `can_create_shared_queries` = @can_create_shared_queries
					, `can_tag_comment` = @can_tag_comment
					, `is_occupant` = @is_occupant
					, `is_public_assignee` = @user_is_publicly_visible
					, `is_see_visible_assignee` = @user_can_see_publicly_visible
					, `is_in_cc_for_role` = @user_in_cc_for_cases
					, `can_create_case` = @can_create_new_cases
					, `can_edit_case` = @can_edit_a_case
					, `can_see_case` = @can_see_all_public_cases
					, `can_edit_all_field_regardless_of_role` = @can_edit_all_field_in_a_case_regardless_of_role
					, `is_flag_requestee` = @can_ask_to_approve
					, `is_flag_approver` = @can_approve
					, `can_create_any_sh` = @can_create_any_stakeholder
					, `can_create_same_sh` = @can_create_same_stakeholder
					, `can_approve_user_for_flags` = @can_approve_user_for_flag
					, `can_decide_if_user_visible` = @can_decide_if_user_is_visible
					, `can_decide_if_user_can_see_visible` = @can_decide_if_user_can_see_visible
					, `public_name` = @user_pub_name
					, `more_info` = CONCAT('On: ', NOW(), '.\r\Updated to ', @role_user_more, '. \r\ ', `more_info`)
					, `comment` = CONCAT('On ', NOW(), '.\r\Updated with the script - ', @script, '.\r\ ', `comment`)
				;

		#We get the information about the goups we need
			#We need to ge these from the ut_product_table_based on the product_id!
				SET @create_case_group_id =  (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 20));
				SET @can_edit_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 25));
				SET @can_see_cases_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 28));
				
				#This is needed until MEFE is able to handle more detailed permissions.
				SET @can_edit_all_field_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 26));
				
				#This is needed so that user can see the unit in the Search panel
				SET @can_see_unit_in_search_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 38));
				
				SET @list_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 4));
				SET @see_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 5));	

				SET @all_r_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 18));
				SET @all_g_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 19));
				
			#Groups created when we created the Role for this product.
				#- show_to_tenant
				#- are_users_tenant
				#- see_users_tenant
				#- show_to_landlord
				#- are_users_landlord
				#- see_users_landlord
				#- show_to_agent
				#- are_users_agent
				#- see_users_agent
				#- show_to_contractor
				#- are_users_contractor
				#- see_users_contractor
				#- show_to_mgt_cny
				#- are_users_mgt_cny
				#- see_users_mgt_cny
				#- show_to_occupant
				#- are_users_occupant
				#- see_users_occupant

				SET @group_id_show_to_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 24));
				SET @group_id_are_users_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 3));
				SET @group_id_see_users_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 36));

				SET @group_id_show_to_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 1));
				SET @group_id_are_users_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 1));
				SET @group_id_see_users_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 1));

				SET @group_id_show_to_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 2));
				SET @group_id_are_users_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 2));
				SET @group_id_see_users_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 2));

				SET @group_id_show_to_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 5));
				SET @group_id_are_users_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 5));
				SET @group_id_see_users_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 5));

				SET @group_id_show_to_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 3));
				SET @group_id_are_users_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 3));
				SET @group_id_see_users_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 3));

				SET @group_id_show_to_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 4));
				SET @group_id_are_users_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 4));
				SET @group_id_see_users_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 4));

		#We get the information about the component/roles that were created:
			
			#We get that from the product_id and dummy user id to make sure that we do not get components with a valid user
				SET @component_id_tenant = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_tenant);
				SET @component_id_landlord = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_landlord);
				SET @component_id_agent = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_agent);
				SET @component_id_contractor = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_contractor);
				SET @component_id_mgt_cny = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_mgt_cny);

			#What is the component_id for this role?
				SET @component_id_this_role = IF( @id_role_type = 1
												, @component_id_tenant
												, IF (@id_role_type = 2
													, @component_id_landlord
													, IF (@id_role_type = 3
														, @component_id_contractor
														, IF (@id_role_type = 4
															, @component_id_mgt_cny
															, IF (@id_role_type = 5
																, @component_id_agent
																, 'Something is very wrong!!'
																)
															)
														)
													)
												)
												;
													
			#We have everything, we can now update the component/role for the unit and make the user default assignee.
				#Get the old values so we can log those
				SET @old_component_initialowner = NULL;
				SET @old_component_initialowner = (SELECT `initialowner` FROM `components` WHERE `id` = @component_id_this_role);
				SET @old_component_initialqacontact = NULL;
				SET @old_component_initialqacontact = (SELECT `initialqacontact` FROM `components` WHERE `id` = @component_id_this_role);
				SET @old_component_description = NULL;
				SET @old_component_description = (SELECT `description` FROM `components` WHERE `id` = @component_id_this_role);
				
				#Update
				UPDATE `components`
				SET 
					`initialowner` = @bz_user_id
					,`initialqacontact` = @bz_user_id
					,`description` = @user_role_desc
					WHERE 
					`id` = @component_id_this_role
					;
				
			#Log the actions of the script.
				SET @script_log_message = CONCAT('The component: '
										, (SELECT IFNULL(@component_id_this_role, 'component_id_this_role is NULL'))
										, ' (for the role_type_id #'
										, (SELECT IFNULL(@id_role_type, 'id_role_type is NULL'))
										, ') has been updated.'
										, '\r\The default user now associated to this role is bz user #'
										, (SELECT IFNULL(@bz_user_id, 'bz_user_id is NULL'))
										, ' (real name: '
										, (SELECT IFNULL(@user_pub_name, 'user_pub_name is NULL'))
										, ') for the unit #' 
										, @product_id
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;
				
				SET @script_log_message = NULL;	
					
		#We update the BZ logs
			INSERT  INTO `audit_log`
				(`user_id`
				,`class`
				,`object_id`
				,`field`
				,`removed`
				,`added`
				,`at_time`
				) 
				VALUES 
				(@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'initialowner',@old_component_initialowner,@bz_user_id,@timestamp)
				, (@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'initialqacontact',@old_component_initialqacontact,@bz_user_id,@timestamp)
				, (@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'description',@old_component_description,@user_role_desc,@timestamp)
				;	
				
		#We now assign the default permissions to the user we just associated to this role:		
			
			#We use a temporary table to make sure we do not have duplicates.
				
				#DELETE the temp table if it exists
				DROP TABLE IF EXISTS `ut_user_group_map_temp`;
				
				#Re-create the temp table
				CREATE TABLE `ut_user_group_map_temp` (
				  `user_id` MEDIUMINT(9) NOT NULL,
				  `group_id` MEDIUMINT(9) NOT NULL,
				  `isbless` TINYINT(4) NOT NULL DEFAULT '0',
				  `grant_type` TINYINT(4) NOT NULL DEFAULT '0'
				) ENGINE=INNODB DEFAULT CHARSET=utf8;

				#Add all the records that exists in the table user_group_map
				INSERT INTO `ut_user_group_map_temp`
					SELECT *
					FROM `user_group_map`;

			#We need to get the id of these groups from the 'ut_product_group' table_based on the product_id
				#For the user - based on the user role:
					#Visibility group
					SET @group_id_show_to_user_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = @id_role_type));
				
					#Is in user Group for the role we just created
					SET @group_id_are_users_same_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = @id_role_type));
					
					#Can See other users in the same Group
					SET @group_id_see_users_same_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = @id_role_type));


		#The default permissions for a user assigned as default for a role are:
		#
			#- time_tracking_permission
			#- can_create_shared_queries
			#- can_tag_comment
		#
			#- can_create_new_cases
			#- can_edit_a_case
			#- can_edit_all_field_case
			#- can_see_unit_in_search
			#- can_see_all_public_cases
			#- user_is_publicly_visible
			#- user_can_see_publicly_visible
			#- can_ask_to_approve (all_r_flags_group_id)
			#- can_approve (all_g_flags_group_id)
		#
		#We create the procedures that will grant the permissions based on the variables from this script.	
		#
			#- show_to_his_role
			#- is_one_of_his_role
			#- can_see_other_in_same_role
		#
		#If applicable
			#- show_to_occupant
			#- is_occupant
			#- can_see_occupant

			#First the global permissions:
				#Can see timetracking
					INSERT  INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id,@can_see_time_tracking_group_id,0,0)
						;
						
					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN See time tracking information.'
												);
					
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						
						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to see time tracking')
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_time_tracking_group_id, @script, 'Add the BZ group id when we grant the permission to see time tracking')
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant see time tracking permission')
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group see time tracking')
							 ;
						 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
			
				#Can create shared queries
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id,@can_create_shared_queries_group_id,0,0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN create shared queries.'
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table

						SET @bzfe_table = 'ut_user_group_map_temp';

						INSERT INTO `ut_audit_log`
								 (`datetime`
								 , `bzfe_table`
								 , `bzfe_field`
								 , `previous_value`
								 , `new_value`
								 , `script`
								 , `comment`
								 )
								 VALUES
								 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to create shared queries')
								 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_create_shared_queries_group_id, @script, 'Add the BZ group id when we grant the permission to create shared queries')
								 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant create shared queries permission')
								 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group create shared queries')
								 ;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;

				#Can tag comments
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id,@can_tag_comment_group_id,0,0)
						;
						
					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN tag comments.'
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to tag comments')
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_tag_comment_group_id, @script, 'Add the BZ group id when we grant the permission to tag comments')
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant tag comments permission')
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group tag comments')
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
			
			#Then the permissions at the unit/product level:	
							
				#User can create a case:
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						#There can be cases when a user is only allowed to see existing cases but NOT create new one.
						#This is an unlikely scenario, but this is technically possible...
						(@bz_user_id, @create_case_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN create new cases for unit '
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'create a new case.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
				#User is allowed to edit cases
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_edit_case_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN edit a cases for unit '
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'edit a case in this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_edit_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
				#User can see the case in the unit even if they are not for his role
					#This allows a user to see the 'public' cases for a given unit.
					#A 'public' case can still only be seen by users in this group!
					#We might NOT want this for employees of a contractor that only need to see the cases IF the case is restricted to
					#the contractor role but NOT if the case is for anyone
					#This is an unlikely scenario, but this is technically possible (ex for technician for a contractor)...
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_see_cases_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN see all public cases for unit '
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'see all public case in this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_cases_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
				#User can edit all fields in the case regardless of his/her role
					#This is needed so until the MEFE can handle permissions.
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_edit_all_field_case_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' can edit all fields in the case regardless of his/her role for the unit#'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'Can edit all fields in the case regardless of his/her role.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_edit_all_field_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;

				#User Can see the unit in the Search panel
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_see_unit_in_search_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' can see the unit#'
												, @product_id
												, ' in the search panel.'
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'Can see the unit in the Search panel.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_unit_in_search_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
				
				#User can be visible to other users regardless of the other users roles
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @list_visible_assignees_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' is one of the visible assignee for cases for this unit.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'is one of the visible assignee for cases for this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @list_visible_assignees_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;

				#User can be visible to other users regardless of the other users roles
					#The below membership is needed so the user can see all the other users regardless of the other users roles
					#We might hide the visible users to some other user (ex: housekeepers or field person do not need to see lanlord or agent
					#They just need to see their manager)
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @see_visible_assignees_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN see the publicly visible users for the case for this unit.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = ' CAN see the publicly visible users for the case for this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @see_visible_assignees_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;				

				#user can create flags (approval requests)				
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES
						(@bz_user_id, @all_r_flags_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN ask for approval for all flags.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = ' CAN ask for approval for all flags.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @all_r_flags_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;	
						
				#user can approve all the flags
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES
						(@bz_user_id, @all_g_flags_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN approve for all flags.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = ' CAN approve for all flags.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @all_g_flags_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
			#Then the permissions that are relevant to the component/role
			#These are conditional as this depends on the role attributed to that user
				
		#We CALL ALL the procedures that we have created TO CREATE the permissions we need:
			CALL show_to_tenant;
			CALL is_tenant;
			CALL default_tenant_can_see_tenant;

			CALL show_to_landlord;
			CALL are_users_landlord;
			CALL default_landlord_see_users_landlord;

			CALL show_to_agent;
			CALL are_users_agent;
			CALL default_agent_see_users_agent;

			CALL show_to_contractor;
			CALL are_users_contractor;
			CALL default_contractor_see_users_contractor;

			CALL show_to_mgt_cny;
			CALL are_users_mgt_cny;
			CALL default_mgt_cny_see_users_mgt_cny;
			
			CALL show_to_occupant;
			CALL is_occupant;
			CALL default_occupant_can_see_occupant;
				
		#We give the user the permission they need.

			#We update the `user_group_map` table
				
				#We truncate the table first (to avoid duplicates)
					TRUNCATE TABLE `user_group_map`;
					
				#We insert the data we need
					INSERT INTO `user_group_map`
					SELECT `user_id`
						, `group_id`
						, `isbless`
						, `grant_type`
					FROM
						`ut_user_group_map_temp`
					GROUP BY `user_id`
						, `group_id`
						, `isbless`
						, `grant_type`
					;

		#Update the table 'ut_data_to_replace_dummy_roles' so that we record what we have done
			UPDATE `ut_data_to_replace_dummy_roles`
			SET 
				`bz_created_date` = @timestamp
				, `comment` = CONCAT ('inserted in BZ with the script \''
						, @script
						, '\'\r\ '
						, IFNULL(`comment`, '')
						)
			WHERE `id` = @reference_for_update;
					
		#Clean up
				
			#We Delete the temp table as we do not need it anymore
				DROP TABLE IF EXISTS `ut_user_group_map_temp`;
	
	# Record 12:
		#The unit: What is the id of the record that you want to use in the table 'ut_data_to_replace_dummy_roles'
			SET @reference_for_update = 12;

		#Environment: Which environment are you creatin the unit in?
			#- 1 is for the DEV/Staging
			#- 2 is for the prod environment
			SET @environment = 1;

		#This is needed so that the invitation mechanism works as intended in the MEFE.
				#- Tenant 1
				SET @bz_user_id_dummy_tenant = 4;

				#- Landlord 2
				SET @bz_user_id_dummy_landlord = 3;
				
				#- Contractor 3
				SET @bz_user_id_dummy_contractor = 5;
				
				#- Management company 4
				SET @bz_user_id_dummy_mgt_cny = 6;
				
				#- Agent 5
				SET @bz_user_id_dummy_agent = 2;
			
		#The unit:
			
			#The name and description
				SET @product_id = (SELECT `bz_unit_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

		#The user associated to the first role in this unit.	

			#BZ user id of the user that is creating the unit (default is 1 - Administrator).
			#For LMB migration, we use 2 (support.nobody)
				SET @creator_bz_id = (SELECT `bzfe_invitor_user_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

			#BZ user id of the user that you want to associate to the unit.
				SET @bz_user_id = (SELECT `bz_user_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);
			
			#Role of the user associated to this new unit:
				#- Tenant 1
				#- Landlord 2
				#- Agent 5
				#- Contractor 3
				#- Management company 4
				SET @id_role_type = (SELECT `user_role_type_id` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);
				SET @role_user_more = (SELECT `user_more` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

			#Is the BZ user an occupant of the unit?
				SET @is_occupant = (SELECT `is_occupant` FROM `ut_data_to_replace_dummy_roles` WHERE `id` = @reference_for_update);

		#We need to get the component for ALL the roles for this product
		#We do that using dummy users for all the roles different from the user role.	
				#- agent -> temporary.agent.dev@unee-t.com
				#- landlord  -> temporary.landlord.dev@unee-t.com
				#- Tenant  -> temporary.tenant.dev@unee-t.com
				#- Contractor  -> temporary.contractor.dev@unee-t.com

		#The Groups to grant the global permissions for the user

			#This should not change, it was hard coded when we created Unee-T
				#See time tracking
				SET @can_see_time_tracking_group_id = 16;
				#Can create shared queries
				SET @can_create_shared_queries_group_id = 17;
				#Can tag comments
				SET @can_tag_comment_group_id = 18;		
				
		#We populate the additional variables that we will need for this script to work
			
			#For the user
				SET @role_user_g_description = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=@id_role_type);
				SET @user_pub_name = (SELECT (LEFT(`login_name`,INSTR(`login_name`,"@")-1)) FROM `profiles` WHERE `userid` = @bz_user_id);
				SET @role_user_pub_info = CONCAT(@user_pub_name
										, IF (@role_user_more = '', '', ' - ')
										, IF (@role_user_more = '', '', @role_user_more)
										)
										;
				SET @user_role_desc = (CONCAT(@role_user_g_description, ' - ',@role_user_pub_info));

			#For the creator
				SET @creator_pub_name = (SELECT `realname` FROM `profiles` WHERE `userid` = @creator_bz_id);

		#Variable needed to avoid script error - NEED TO REVISIT THAT
			SET @can_see_time_tracking = 1;
			SET @can_create_shared_queries = 1;
			SET @can_tag_comment = 1;
			SET @user_is_publicly_visible = 1;
			SET @user_can_see_publicly_visible = 1;
			SET @user_in_cc_for_cases = 0;
			SET @can_create_new_cases = 1;
			SET @can_edit_a_case = 1;
			SET @can_see_all_public_cases = 1;
			SET @can_edit_all_field_in_a_case_regardless_of_role = 1;
			SET @can_ask_to_approve = 1;
			SET @can_approve = 1;
			SET @can_create_any_stakeholder = 0;
			SET @can_create_same_stakeholder = 0;
			SET @can_approve_user_for_flag = 0;
			SET @can_decide_if_user_is_visible = 0;
			SET @can_decide_if_user_can_see_visible = 0;	

		#The user

			#We record the information about the users that we have just created
			#If this is the first time we record something for this user for this unit, we create a new record.
			#If there is already a record for THAT USER for THIS, then we are updating the information
				
				INSERT INTO `ut_map_user_unit_details`
					(`created`
					, `record_created_by`
					, `user_id`
					, `bz_profile_id`
					, `bz_unit_id`
					, `role_type_id`
					, `can_see_time_tracking`
					, `can_create_shared_queries`
					, `can_tag_comment`
					, `is_occupant`
					, `is_public_assignee`
					, `is_see_visible_assignee`
					, `is_in_cc_for_role`
					, `can_create_case`
					, `can_edit_case`
					, `can_see_case`
					, `can_edit_all_field_regardless_of_role`
					, `is_flag_requestee`
					, `is_flag_approver`
					, `can_create_any_sh`
					, `can_create_same_sh`
					, `can_approve_user_for_flags`
					, `can_decide_if_user_visible`
					, `can_decide_if_user_can_see_visible`
					, `public_name`
					, `more_info`
					, `comment`
					)
					VALUES
					(NOW()
					, @creator_bz_id
					, @bz_user_id
					, @bz_user_id
					, @product_id
					, @id_role_type
					#Global permission for the whole installation
					, @can_see_time_tracking
					, @can_create_shared_queries
					, @can_tag_comment
					#Attributes of the user
					, @is_occupant
					#User visibility
					, @user_is_publicly_visible
					, @user_can_see_publicly_visible
					#Permissions for cases for this unit.
					, @user_in_cc_for_cases
					, @can_create_new_cases
					, @can_edit_a_case
					, @can_see_all_public_cases
					, @can_edit_all_field_in_a_case_regardless_of_role
					#For the flags
					, @can_ask_to_approve
					, @can_approve
					#Permissions to create or modify other users
					, @can_create_any_stakeholder
					, @can_create_same_stakeholder
					, @can_approve_user_for_flag
					, @can_decide_if_user_is_visible
					, @can_decide_if_user_can_see_visible
					, @user_pub_name
					, @role_user_more
					, CONCAT('On '
							, NOW()
							, ': Created with the script - '
							, @script
							, '.\r\ '
							, `comment`)
					)
					ON DUPLICATE KEY UPDATE
					`created` = NOW()
					, `record_created_by` = @creator_bz_id
					, `role_type_id` = @id_role_type
					, `can_see_time_tracking` = @can_see_time_tracking
					, `can_create_shared_queries` = @can_create_shared_queries
					, `can_tag_comment` = @can_tag_comment
					, `is_occupant` = @is_occupant
					, `is_public_assignee` = @user_is_publicly_visible
					, `is_see_visible_assignee` = @user_can_see_publicly_visible
					, `is_in_cc_for_role` = @user_in_cc_for_cases
					, `can_create_case` = @can_create_new_cases
					, `can_edit_case` = @can_edit_a_case
					, `can_see_case` = @can_see_all_public_cases
					, `can_edit_all_field_regardless_of_role` = @can_edit_all_field_in_a_case_regardless_of_role
					, `is_flag_requestee` = @can_ask_to_approve
					, `is_flag_approver` = @can_approve
					, `can_create_any_sh` = @can_create_any_stakeholder
					, `can_create_same_sh` = @can_create_same_stakeholder
					, `can_approve_user_for_flags` = @can_approve_user_for_flag
					, `can_decide_if_user_visible` = @can_decide_if_user_is_visible
					, `can_decide_if_user_can_see_visible` = @can_decide_if_user_can_see_visible
					, `public_name` = @user_pub_name
					, `more_info` = CONCAT('On: ', NOW(), '.\r\Updated to ', @role_user_more, '. \r\ ', `more_info`)
					, `comment` = CONCAT('On ', NOW(), '.\r\Updated with the script - ', @script, '.\r\ ', `comment`)
				;

		#We get the information about the goups we need
			#We need to ge these from the ut_product_table_based on the product_id!
				SET @create_case_group_id =  (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 20));
				SET @can_edit_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 25));
				SET @can_see_cases_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 28));
				
				#This is needed until MEFE is able to handle more detailed permissions.
				SET @can_edit_all_field_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 26));
				
				#This is needed so that user can see the unit in the Search panel
				SET @can_see_unit_in_search_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 38));
				
				SET @list_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 4));
				SET @see_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 5));	

				SET @all_r_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 18));
				SET @all_g_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 19));
				
			#Groups created when we created the Role for this product.
				#- show_to_tenant
				#- are_users_tenant
				#- see_users_tenant
				#- show_to_landlord
				#- are_users_landlord
				#- see_users_landlord
				#- show_to_agent
				#- are_users_agent
				#- see_users_agent
				#- show_to_contractor
				#- are_users_contractor
				#- see_users_contractor
				#- show_to_mgt_cny
				#- are_users_mgt_cny
				#- see_users_mgt_cny
				#- show_to_occupant
				#- are_users_occupant
				#- see_users_occupant

				SET @group_id_show_to_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 24));
				SET @group_id_are_users_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 3));
				SET @group_id_see_users_occupant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 36));

				SET @group_id_show_to_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 1));
				SET @group_id_are_users_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 1));
				SET @group_id_see_users_tenant = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 1));

				SET @group_id_show_to_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 2));
				SET @group_id_are_users_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 2));
				SET @group_id_see_users_landlord = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 2));

				SET @group_id_show_to_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 5));
				SET @group_id_are_users_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 5));
				SET @group_id_see_users_agent = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 5));

				SET @group_id_show_to_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 3));
				SET @group_id_are_users_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 3));
				SET @group_id_see_users_contractor = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 3));

				SET @group_id_show_to_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = 4));
				SET @group_id_are_users_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = 4));
				SET @group_id_see_users_mgt_cny = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = 4));

		#We get the information about the component/roles that were created:
			
			#We get that from the product_id and dummy user id to make sure that we do not get components with a valid user
				SET @component_id_tenant = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_tenant);
				SET @component_id_landlord = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_landlord);
				SET @component_id_agent = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_agent);
				SET @component_id_contractor = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_contractor);
				SET @component_id_mgt_cny = (SELECT `id` 
											FROM `components` 
											WHERE `product_id` = @product_id 
												AND `initialowner` = @bz_user_id_dummy_mgt_cny);

			#What is the component_id for this role?
				SET @component_id_this_role = IF( @id_role_type = 1
												, @component_id_tenant
												, IF (@id_role_type = 2
													, @component_id_landlord
													, IF (@id_role_type = 3
														, @component_id_contractor
														, IF (@id_role_type = 4
															, @component_id_mgt_cny
															, IF (@id_role_type = 5
																, @component_id_agent
																, 'Something is very wrong!!'
																)
															)
														)
													)
												)
												;
													
			#We have everything, we can now update the component/role for the unit and make the user default assignee.
				#Get the old values so we can log those
				SET @old_component_initialowner = NULL;
				SET @old_component_initialowner = (SELECT `initialowner` FROM `components` WHERE `id` = @component_id_this_role);
				SET @old_component_initialqacontact = NULL;
				SET @old_component_initialqacontact = (SELECT `initialqacontact` FROM `components` WHERE `id` = @component_id_this_role);
				SET @old_component_description = NULL;
				SET @old_component_description = (SELECT `description` FROM `components` WHERE `id` = @component_id_this_role);
				
				#Update
				UPDATE `components`
				SET 
					`initialowner` = @bz_user_id
					,`initialqacontact` = @bz_user_id
					,`description` = @user_role_desc
					WHERE 
					`id` = @component_id_this_role
					;
				
			#Log the actions of the script.
				SET @script_log_message = CONCAT('The component: '
										, (SELECT IFNULL(@component_id_this_role, 'component_id_this_role is NULL'))
										, ' (for the role_type_id #'
										, (SELECT IFNULL(@id_role_type, 'id_role_type is NULL'))
										, ') has been updated.'
										, '\r\The default user now associated to this role is bz user #'
										, (SELECT IFNULL(@bz_user_id, 'bz_user_id is NULL'))
										, ' (real name: '
										, (SELECT IFNULL(@user_pub_name, 'user_pub_name is NULL'))
										, ') for the unit #' 
										, @product_id
										);
				
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(NOW(), @script, @script_log_message)
					;
				
				SET @script_log_message = NULL;	
					
		#We update the BZ logs
			INSERT  INTO `audit_log`
				(`user_id`
				,`class`
				,`object_id`
				,`field`
				,`removed`
				,`added`
				,`at_time`
				) 
				VALUES 
				(@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'initialowner',@old_component_initialowner,@bz_user_id,@timestamp)
				, (@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'initialqacontact',@old_component_initialqacontact,@bz_user_id,@timestamp)
				, (@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'description',@old_component_description,@user_role_desc,@timestamp)
				;	
				
		#We now assign the default permissions to the user we just associated to this role:		
			
			#We use a temporary table to make sure we do not have duplicates.
				
				#DELETE the temp table if it exists
				DROP TABLE IF EXISTS `ut_user_group_map_temp`;
				
				#Re-create the temp table
				CREATE TABLE `ut_user_group_map_temp` (
				  `user_id` MEDIUMINT(9) NOT NULL,
				  `group_id` MEDIUMINT(9) NOT NULL,
				  `isbless` TINYINT(4) NOT NULL DEFAULT '0',
				  `grant_type` TINYINT(4) NOT NULL DEFAULT '0'
				) ENGINE=INNODB DEFAULT CHARSET=utf8;

				#Add all the records that exists in the table user_group_map
				INSERT INTO `ut_user_group_map_temp`
					SELECT *
					FROM `user_group_map`;

			#We need to get the id of these groups from the 'ut_product_group' table_based on the product_id
				#For the user - based on the user role:
					#Visibility group
					SET @group_id_show_to_user_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 2 AND `role_type_id` = @id_role_type));
				
					#Is in user Group for the role we just created
					SET @group_id_are_users_same_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 22 AND `role_type_id` = @id_role_type));
					
					#Can See other users in the same Group
					SET @group_id_see_users_same_role = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 37 AND `role_type_id` = @id_role_type));


		#The default permissions for a user assigned as default for a role are:
		#
			#- time_tracking_permission
			#- can_create_shared_queries
			#- can_tag_comment
		#
			#- can_create_new_cases
			#- can_edit_a_case
			#- can_edit_all_field_case
			#- can_see_unit_in_search
			#- can_see_all_public_cases
			#- user_is_publicly_visible
			#- user_can_see_publicly_visible
			#- can_ask_to_approve (all_r_flags_group_id)
			#- can_approve (all_g_flags_group_id)
		#
		#We create the procedures that will grant the permissions based on the variables from this script.	
		#
			#- show_to_his_role
			#- is_one_of_his_role
			#- can_see_other_in_same_role
		#
		#If applicable
			#- show_to_occupant
			#- is_occupant
			#- can_see_occupant

			#First the global permissions:
				#Can see timetracking
					INSERT  INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id,@can_see_time_tracking_group_id,0,0)
						;
						
					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN See time tracking information.'
												);
					
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						
						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to see time tracking')
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_time_tracking_group_id, @script, 'Add the BZ group id when we grant the permission to see time tracking')
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant see time tracking permission')
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group see time tracking')
							 ;
						 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
			
				#Can create shared queries
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id,@can_create_shared_queries_group_id,0,0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN create shared queries.'
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table

						SET @bzfe_table = 'ut_user_group_map_temp';

						INSERT INTO `ut_audit_log`
								 (`datetime`
								 , `bzfe_table`
								 , `bzfe_field`
								 , `previous_value`
								 , `new_value`
								 , `script`
								 , `comment`
								 )
								 VALUES
								 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to create shared queries')
								 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_create_shared_queries_group_id, @script, 'Add the BZ group id when we grant the permission to create shared queries')
								 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant create shared queries permission')
								 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group create shared queries')
								 ;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;

				#Can tag comments
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id,@can_tag_comment_group_id,0,0)
						;
						
					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN tag comments.'
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, 'Add the BZ user id when we grant the permission to tag comments')
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_tag_comment_group_id, @script, 'Add the BZ group id when we grant the permission to tag comments')
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, 'user does NOT grant tag comments permission')
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, 'user is a member of the group tag comments')
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
			
			#Then the permissions at the unit/product level:	
							
				#User can create a case:
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						#There can be cases when a user is only allowed to see existing cases but NOT create new one.
						#This is an unlikely scenario, but this is technically possible...
						(@bz_user_id, @create_case_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN create new cases for unit '
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'create a new case.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @create_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
				#User is allowed to edit cases
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_edit_case_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN edit a cases for unit '
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'edit a case in this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_edit_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
				#User can see the case in the unit even if they are not for his role
					#This allows a user to see the 'public' cases for a given unit.
					#A 'public' case can still only be seen by users in this group!
					#We might NOT want this for employees of a contractor that only need to see the cases IF the case is restricted to
					#the contractor role but NOT if the case is for anyone
					#This is an unlikely scenario, but this is technically possible (ex for technician for a contractor)...
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_see_cases_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN see all public cases for unit '
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'see all public case in this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_cases_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
				#User can edit all fields in the case regardless of his/her role
					#This is needed so until the MEFE can handle permissions.
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_edit_all_field_case_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' can edit all fields in the case regardless of his/her role for the unit#'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'Can edit all fields in the case regardless of his/her role.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_edit_all_field_case_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;

				#User Can see the unit in the Search panel
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @can_see_unit_in_search_group_id, 0, 0)	
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' can see the unit#'
												, @product_id
												, ' in the search panel.'
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'Can see the unit in the Search panel.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @can_see_unit_in_search_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
				
				#User can be visible to other users regardless of the other users roles
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @list_visible_assignees_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' is one of the visible assignee for cases for this unit.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = 'is one of the visible assignee for cases for this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @list_visible_assignees_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;

				#User can be visible to other users regardless of the other users roles
					#The below membership is needed so the user can see all the other users regardless of the other users roles
					#We might hide the visible users to some other user (ex: housekeepers or field person do not need to see lanlord or agent
					#They just need to see their manager)
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES 
						(@bz_user_id, @see_visible_assignees_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN see the publicly visible users for the case for this unit.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = ' CAN see the publicly visible users for the case for this unit.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @see_visible_assignees_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;				

				#user can create flags (approval requests)				
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES
						(@bz_user_id, @all_r_flags_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN ask for approval for all flags.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = ' CAN ask for approval for all flags.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @all_r_flags_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;	
						
				#user can approve all the flags
					INSERT INTO `ut_user_group_map_temp`
						(`user_id`
						,`group_id`
						,`isbless`
						,`grant_type`
						) 
						VALUES
						(@bz_user_id, @all_g_flags_group_id, 0, 0)
						;

					#Log the actions of the script.
						SET @script_log_message = CONCAT('the bz user #'
												, @bz_user_id
												, ' CAN approve for all flags.'
												, @product_id
												);
						
						INSERT INTO `ut_script_log`
							(`datetime`
							, `script`
							, `log`
							)
							VALUES
							(NOW(), @script, @script_log_message)
							;

					#We log what we have just done into the `ut_audit_log` table
						
						SET @bzfe_table = 'ut_user_group_map_temp';
						SET @permission_granted = ' CAN approve for all flags.';

						INSERT INTO `ut_audit_log`
							 (`datetime`
							 , `bzfe_table`
							 , `bzfe_field`
							 , `previous_value`
							 , `new_value`
							 , `script`
							 , `comment`
							 )
							 VALUES
							 (NOW() ,@bzfe_table, 'user_id', 'UNKNOWN', @bz_user_id, @script, CONCAT('Add the BZ user id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'group_id', 'UNKNOWN', @all_g_flags_group_id, @script, CONCAT('Add the BZ group id when we grant the permission to ', @permission_granted))
							 , (NOW() ,@bzfe_table, 'isbless', 'UNKNOWN', 0, @script, CONCAT('user does NOT grant ',@permission_granted, ' permission'))
							 , (NOW() ,@bzfe_table, 'grant_type', 'UNKNOWN', 0, @script, CONCAT('user is a member of the group', @permission_granted))
							;
					 
					#Cleanup the variables for the log messages
						SET @script_log_message = NULL;
						SET @bzfe_table = NULL;
						SET @permission_granted = NULL;
						
			#Then the permissions that are relevant to the component/role
			#These are conditional as this depends on the role attributed to that user
				
		#We CALL ALL the procedures that we have created TO CREATE the permissions we need:
			CALL show_to_tenant;
			CALL is_tenant;
			CALL default_tenant_can_see_tenant;

			CALL show_to_landlord;
			CALL are_users_landlord;
			CALL default_landlord_see_users_landlord;

			CALL show_to_agent;
			CALL are_users_agent;
			CALL default_agent_see_users_agent;

			CALL show_to_contractor;
			CALL are_users_contractor;
			CALL default_contractor_see_users_contractor;

			CALL show_to_mgt_cny;
			CALL are_users_mgt_cny;
			CALL default_mgt_cny_see_users_mgt_cny;
			
			CALL show_to_occupant;
			CALL is_occupant;
			CALL default_occupant_can_see_occupant;
				
		#We give the user the permission they need.

			#We update the `user_group_map` table
				
				#We truncate the table first (to avoid duplicates)
					TRUNCATE TABLE `user_group_map`;
					
				#We insert the data we need
					INSERT INTO `user_group_map`
					SELECT `user_id`
						, `group_id`
						, `isbless`
						, `grant_type`
					FROM
						`ut_user_group_map_temp`
					GROUP BY `user_id`
						, `group_id`
						, `isbless`
						, `grant_type`
					;

		#Update the table 'ut_data_to_replace_dummy_roles' so that we record what we have done
			UPDATE `ut_data_to_replace_dummy_roles`
			SET 
				`bz_created_date` = @timestamp
				, `comment` = CONCAT ('inserted in BZ with the script \''
						, @script
						, '\'\r\ '
						, IFNULL(`comment`, '')
						)
			WHERE `id` = @reference_for_update;
					
		#Clean up
				
			#We Delete the temp table as we do not need it anymore
				DROP TABLE IF EXISTS `ut_user_group_map_temp`;
	
# We have inserted:
	#- The units
	#- The default users for each role/component

# We need to create the additional users in each role/components:
	#- Sabrina (10)
	#	- Unit 1: Management Company (role 4) - Additional user
	#	- Unit 2: No Role
	#	- Unit 3: Management Company (role 4) - Additional user
	#- Marina (13)
	#	- Unit 1: co Tenant (role 1) - Additional user
	#	- Unit 2: No Role
	#	- Unit 3: No Role
	#- Lawrence (16)
	#	- Unit 1: No Role
	#	- Unit 2: Management Company (role 4) - Additional user
	#	- Unit 3: No Role

################
#
# THIS HAS TO BE DONE USING THE MEFE INVITATION PROCEDURE!
	#- Go to the MEFE as one of the users for the unit
	#- Invite the user via the MEFE
	#- Process the MEFE invitation
#
################

# WE ARE NOT CREATING ANY CASE WITH THIS SCRIPT
		
# We re-instate the FK constraints

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
		