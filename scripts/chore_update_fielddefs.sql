# When we run the 'checksetup.pl' script the fielddefs are updated to the default BZ value.
# This script restores the customization of the BZ values for Unee-T

# This script has been tested for BZ DB schema w 2.x to 3.x

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
/*Table structure for table `fielddefs` */

DROP TABLE IF EXISTS `fielddefs`;

CREATE TABLE `fielddefs` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `type` smallint(6) NOT NULL DEFAULT 0,
  `custom` tinyint(4) NOT NULL DEFAULT 0,
  `description` tinytext NOT NULL,
  `long_desc` varchar(255) NOT NULL DEFAULT '',
  `mailhead` tinyint(4) NOT NULL DEFAULT 0,
  `sortkey` smallint(6) NOT NULL,
  `obsolete` tinyint(4) NOT NULL DEFAULT 0,
  `enter_bug` tinyint(4) NOT NULL DEFAULT 0,
  `buglist` tinyint(4) NOT NULL DEFAULT 0,
  `visibility_field_id` mediumint(9) DEFAULT NULL,
  `value_field_id` mediumint(9) DEFAULT NULL,
  `reverse_desc` tinytext DEFAULT NULL,
  `is_mandatory` tinyint(4) NOT NULL DEFAULT 0,
  `is_numeric` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fielddefs_name_idx` (`name`),
  KEY `fielddefs_sortkey_idx` (`sortkey`),
  KEY `fielddefs_value_field_id_idx` (`value_field_id`),
  KEY `fielddefs_is_mandatory_idx` (`is_mandatory`),
  KEY `fk_fielddefs_visibility_field_id_fielddefs_id` (`visibility_field_id`),
  CONSTRAINT `fk_fielddefs_value_field_id_fielddefs_id` FOREIGN KEY (`value_field_id`) REFERENCES `fielddefs` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_fielddefs_visibility_field_id_fielddefs_id` FOREIGN KEY (`visibility_field_id`) REFERENCES `fielddefs` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=93 DEFAULT CHARSET=utf8;

/*Data for the table `fielddefs` */

insert  into `fielddefs`(`id`,`name`,`type`,`custom`,`description`,`long_desc`,`mailhead`,`sortkey`,`obsolete`,`enter_bug`,`buglist`,`visibility_field_id`,`value_field_id`,`reverse_desc`,`is_mandatory`,`is_numeric`) values 
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

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
