# Contact Franck for any question about this script
# 
# This script inserts the demo users in unee-t v2.x
# Pre-Requisite: you have a clean blank unee-t v2.x installation
# 
# This script also give permissions and accesses to these users.
# 
# We want to give these users dummy roles and profile so that people can play with the tool in DEMO/DEV/TEST
# All these users are Stakeholders in Test Unit 1 A
#   - Leonel is the Agent for the Lanldord (Marley) She is the one who created the unit initially 
#     His `id_role_type` in the table `ut_role_types` = 5
#   - Marley is the Landlord
#     His `id_role_type` in the table `ut_role_types` = 2
#   - Michael is one of the a 2 Tenants living in this unit.
#     His `id_role_type` in the table `ut_role_types` = 1
#   - Sabrina is the other Tenant living in this unit.
#     Her `id_role_type` in the table `ut_role_types` = 1
#   - Celeste works for the Management Company Management Co, in charge of this unit.
#     Her `id_role_type` in the table `ut_role_types` = 4
#   - Jocelyn also works for the Management Company Management Co, in charge of this unit.
#     Her `id_role_type` in the table `ut_role_types` = 4
#   - Marina is the Manager of Celeste and Jocelyn at the Management Company Management Co, in charge of this unit.
#     Her `id_role_type` in the table `ut_role_types` = 4
#   - Regina is the Agent for Marley and Michael (the co-tenants).
#     Her `id_role_type` in the table `ut_role_types` = 5
#   - Marvin is a Contractor (an electrician).
#     His `id_role_type` in the table `ut_role_types` = 3
#   - Lawrence is another Contractor (Aircon Repair and Maintenance).
#     His `id_role_type` in the table `ut_role_types` = 3
#   - Anabelle has no link to this unit, she's an 'unattached' Unee-T user.
#
# We have also created a generic email address for the management company Management Co
# When a case is created for Management Co the alerts are set to management.co@example.com
# 
# This script does NOT Create
#   - Any New product/unit
#


/*Table structure for table `profiles` */
	SET FOREIGN_KEY_CHECKS = 0;
	DROP TABLE IF EXISTS `profiles`;
	CREATE TABLE `profiles` (
	  `userid` MEDIUMINT(9) NOT NULL AUTO_INCREMENT,
	  `login_name` VARCHAR(255) NOT NULL,
	  `cryptpassword` VARCHAR(128) DEFAULT NULL,
	  `realname` VARCHAR(255) NOT NULL DEFAULT '',
	  `disabledtext` MEDIUMTEXT NOT NULL,
	  `disable_mail` TINYINT(4) NOT NULL DEFAULT '0',
	  `mybugslink` TINYINT(4) NOT NULL DEFAULT '1',
	  `extern_id` VARCHAR(64) DEFAULT NULL,
	  `is_enabled` TINYINT(4) NOT NULL DEFAULT '1',
	  `last_seen_date` DATETIME DEFAULT NULL,
	  PRIMARY KEY (`userid`),
	  UNIQUE KEY `profiles_login_name_idx` (`login_name`),
	  UNIQUE KEY `profiles_extern_id_idx` (`extern_id`)
	) ENGINE=INNODB DEFAULT CHARSET=utf8;
	SET FOREIGN_KEY_CHECKS = 1;
	
/*Data for the table `profiles` */

	INSERT  INTO `profiles`(`userid`,`login_name`,`cryptpassword`,`realname`,`disabledtext`,`disable_mail`,`mybugslink`,`extern_id`,`is_enabled`,`last_seen_date`) VALUES 
	(1,'administrator@example.com','B8AgzURt,NDrX2Bt8stpgXPKsNRYaHmm0V2K1+qhfnt76oLAvN+Q{SHA-256}','Administrator','',0,1,NULL,1,NULL),
	(2,'leonel@example.com','uVkp9Jte,ts7kZpZuOcTkMAh1c4iX4IcEZTxpq0Sfr7XraiZoL+g{SHA-256}','Leonel','',0,1,NULL,1,NULL),
	(3,'marley@example.com','AMOb0L00,NlJF4wyZVyT+xWuUr3RYgDIYxMhfBJCZxvkSh5cRSVs{SHA-256}','Marley','',0,1,NULL,1,NULL),
	(4,'michael@example.com','Tp0jDQnd,kD+mf67/v/ck68nOyRTR4j7JNVpo1XzzDFSIR6U7Lps{SHA-256}','Michael','',0,1,NULL,1,NULL),
	(5,'sabrina@example.com','fjeiOOVC,vUkDbdxcfk9snn9J5Vh4r/cujX2FfOKEcBZBAOcMw3k{SHA-256}','Sabrina','',0,1,NULL,1,NULL),
	(6,'celeste@example.com','ZAU7m97y,kw6J1Bf2Hw21qELelxM3BbK+4avsmJytG/WzssHMbXE{SHA-256}','Celeste','',0,1,NULL,1,NULL),
	(7,'jocelyn@example.com','0ZprH6RJ,zXa/xkkETvkPZ988xpyQQocYYfLAIWdCLCk1wE4QXNA{SHA-256}','Jocelyn','',0,1,NULL,1,NULL),
	(8,'marina@example.com','8c2ofNwd,VpZbBAByL89ZKCI3xT7zFjZBb/X7JHW6KjtA9yY8KYo{SHA-256}','Marina','',0,1,NULL,1,NULL),
	(9,'regina@example.com','HuM6hVYF,Ev6TBPrrOm4pSu5chsr1Q6Hi6q2Tmm98IbLh7ONqtYs{SHA-256}','Regina','',0,1,NULL,1,NULL),
	(10,'marvin@example.com','6kTmgSt9,FI+tK4vrJQa8lInrRGKxmQ0JW2WpVImRk+ylhcMYGKM{SHA-256}','Marvin','',0,1,NULL,1,NULL),
	(11,'lawrence@example.com','JqPmW7RA,tJopvIAj1kbeRJ61pZUqjce1dZrGoBpnHMzycgTuTqE{SHA-256}','Lawrence','',0,1,NULL,1,NULL),
	(12,'anabelle@example.com','9bgiCNi8,32d10yq/btaTsj/awDksNPjdUDLIrGfkK+vRKWfYbQo{SHA-256}','Anabelle','',0,1,NULL,1,NULL),
	(13,'management.co@example.com','C162r0Mo,/V0m+v2cmZqU0JOjQBR8X5Q26xSgKTBs/f/Wke51oSI{SHA-256}','Management Co','',0,1,NULL,1,NULL);
	
# We know that the unit is product_id = 1 
		SET @product_id = 1;
		# Get the additional data we need
		SET @unit = (SELECT `name` FROM `products` WHERE `id`=1);
		# The group_id which grants the default privileges in the TEST product.
		SET @default_privilege_group_id = 31;


# Let's Create the Privileges for Leonel (the creator of the Unit)
#   - Leonel is the Agent for the Lanldord (Marley) She is the one who created the unit initially 
#     His `id_role_type` in the table `ut_role_types` = 5

	# We don't need to create the unit here.
	# BUT We need to Make sure that the the component for this Unit is correct
	# We also want to show the publicly visible information for Leonel.
		SET @creator_pub_name = 'Leonel - My Real Estate Agency';
		SET @stakeholder_pub_info = CONCAT(@creator_pub_name,' - Phone number: 123 456 7891. For a faster response, please message me directly in Unee-T for this unit');

		# User role: this is an id in the table `ut_role_types` for easier manipulation, update and maintenance
		SET @role_type_id = 5;

	# We Need the BZ user information for Leonel too
		SET @login_name = 'leonel@example.com';
		SET @bz_user_id = 2;

	# We have everything - Let's create the first unit for that user!
	
		# First we disable the FK check
		SET FOREIGN_KEY_CHECKS = 0;

		# Get the additional variable that we need
		SET @timestamp = NOW();
		SET @stakeholder = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=@role_type_id);
		SET @stakeholder_g_description = (SELECT `bz_description` FROM `ut_role_types` WHERE `id_role_type`=@role_type_id);

# We create a variable @visibility_explanation to facilitate development
# This variable store the text displayed next to the 'visibility' tick in a case
SET @visibility_explanation = CONCAT('Tick to HIDE this case if the user is the ',@stakeholder,' for this unit. Untick to Show this case');

		/*Data for the table `components` */
		# We insert the correct values for the component/stakeholder
		# This is a Special user: the Creator of the unit!.
		INSERT  INTO `components`
			(`id`
			,`name`
			,`product_id`
			,`initialowner`
			,`initialqacontact`
			,`description`
			,`isactive`
			) 
			VALUES 
			(NULL,@stakeholder,@product_id,@bz_user_id,@bz_user_id,CONCAT(@stakeholder_g_description, ' \r\ ', @stakeholder_pub_info),1);

		# In order to create the records in the audit table, we need to get the newly created component_id
		SET @creator_component_id = LAST_INSERT_ID();

		/*Data for the table `components` */
		# We empty the components table
		TRUNCATE `components`;
		# We insert the correct values for the component/stakeholder.
		INSERT  INTO `components`
			(`id`
			,`name`
			,`product_id`
			,`initialowner`
			,`initialqacontact`
			,`description`
			,`isactive`
			) 
			VALUES 
			(NULL,@stakeholder,@product_id,@bz_user_id,@bz_user_id,CONCAT(@stakeholder_g_description, ' \r\ ', @stakeholder_pub_info),1);

		# In order to create the records in the audit table, we need to get the newly created component_id
		SET @component_id = LAST_INSERT_ID();

		/*Data for the table `groups` */
		# We create the first group that we need to control access and visibility to this product/unit and the bugs/cases in this products/unit
		# This is the group for the unit creator and his agents
		INSERT  INTO `groups`
			(`id`
			,`name`
			,`description`
			,`isbuggroup`
			,`userregexp`
			,`isactive`
			,`icon_url`
			) 
			VALUES 
			(NULL,CONCAT (@unit,' #',@product_id,' - Creator'), CONCAT('Unit creator (or it\'s agent) for ', @unit),1,'',1,NULL);

		# In order to create the Group Control Map, we need to get the newly created group_id
		# based on this, we derive the other new group_id too.
		# until we understand how to automatically do that we set it up mannually
		SET @creator_group_id = LAST_INSERT_ID();
		SET @visibility_case_group_id = (@creator_group_id+1);
		SET @list_user_group_id = (@visibility_case_group_id+1);
		SET @see_user_group_id = (@list_user_group_id+1);
		
		/*We create the other groups that we need */

		INSERT  INTO `groups`
			(`id`
			,`name`
			,`description`
			,`isbuggroup`
			,`userregexp`
			,`isactive`
			,`icon_url`
			) 
			VALUES 
			# group to list the users who are this type of stakeholder in this unit
			(@visibility_case_group_id,CONCAT(@unit,' #',@product_id,' - ', @stakeholder,' - Created by: ',@creator_pub_name), @visibility_explanation,1,'',1,NULL),
			# group to list the users who are stakeholders in this unit
			(@list_user_group_id,CONCAT(@unit,' #',@product_id,' - list stakeholder'),'Visibility group Step 1 - list all the users which are stakeholders for this unit',1,'',0,NULL),
			# group to see the users who are stakeholders in this unit
			(@see_user_group_id,CONCAT(@unit,' #',@product_id,' - see stakeholder'),'Visibility group Step 2 - Can see all the users which are stakeholders for this unit',1,'',0,NULL);
		
		# THIS IS NOT A BZ INITIATED ACTION!
		# We insert information into the table which maps groups to products/component
		INSERT INTO `ut_product_group`
			(
			product_id
			,group_id
			,group_type_id
			,role_type_id
			,created
			)
			VALUES
			# This is the initial creation for this product/unit. We know that the group_type_id for this group is
			# 1 = Creator
			(@product_id,@creator_group_id,1,@role_type_id,@timestamp),
			# 2 = Access to case
			(@product_id,@visibility_case_group_id,2,@role_type_id,@timestamp),
			# 4 = list_stakeholder
			(@product_id,@list_user_group_id,4,@role_type_id,@timestamp),
			# 5 = see_stakeholder
			(@product_id,@see_user_group_id,5,@role_type_id,@timestamp);

		/*Data for the table `user_group_map` */
		# We add the BZ user to the groups we have just created
		INSERT  INTO `user_group_map`
			(`user_id`
			,`group_id`
			,`isbless`
			,`grant_type`
			) 
			VALUES 
			# we grant the User Access to all the default permission for the Test unit
			(@bz_user_id,@default_privilege_group_id,0,0),
			(@bz_user_id,@creator_group_id,0,0),
			(@bz_user_id,@visibility_case_group_id,0,0),
			(@bz_user_id,@list_user_group_id,0,0),
			(@bz_user_id,@see_user_group_id,0,0);

		# We need to do this AFTER we created the groups so we can get the creator_group_id
		# Group for 
		# 	- The unit creator and his agents DONE
		#	- To list the user who have a role in this unit DONE
		#	- To See the users who have a role in this unit DONE
		#	- To limit who can see a case or not on a bug/case by bug/case basis if the user is an occupant

		/*Data for the table `group_group_map` */
		INSERT  INTO `group_group_map`
			(`member_id`
			,`grantor_id`
			,`grant_type`
			) 
			VALUES 
			# We keep that for testing
			# we We DO NOT WANT THE ADMINISTRATOR (user id = 1) TO SEE AND MANAGE ALL THESE GROUPS after testing is finished... 
			(1,@creator_group_id,0),
			(1,@creator_group_id,1),
			(1,@creator_group_id,2),
			(1,@visibility_case_group_id,1),
			(1,@visibility_case_group_id,2),
			(1,@list_user_group_id,1),
			(1,@list_user_group_id,2),
			(1,@see_user_group_id,0),
			(1,@see_user_group_id,1),
			(1,@see_user_group_id,2),
			# END
			# Member_id is a group_id
			# grantor_id is a group_id
			# we probably want the initial group id to be able to do that
			# this is so that the BZ APIs work as intended
			(@creator_group_id,@creator_group_id,0),
			(@creator_group_id,@creator_group_id,1),
			(@creator_group_id,@creator_group_id,2),
			(@visibility_case_group_id,@visibility_case_group_id,0),
			(@visibility_case_group_id,@visibility_case_group_id,1),
			(@visibility_case_group_id,@visibility_case_group_id,2),
			(@list_user_group_id,@list_user_group_id,0),
			(@list_user_group_id,@list_user_group_id,1),
			(@list_user_group_id,@list_user_group_id,2),
			(@see_user_group_id,@see_user_group_id,1);

		/*Data for the table `group_control_map` */
		# This is where we decide who can access which products.
		INSERT  INTO `group_control_map`
			(`group_id`
			,`product_id`
			,`entry`
			# it is unclear which id this is: user_id? product_id? other?
			# in order to validate that we need to 
			#  1- re-create a 2nd product from scratch as the same user in the same classification
			#	if id is the same, this is NOT the product_id, it's something else
			#	DONE- membercontrol id is the SAME (2)
			#  2- re-create a 4th product from scratch as the same user in the same classification with a different default assignee.
			# 	if id is the same then this is not the default assignee, it's something else
			#	DONE- membercontrol id is the SAME (2)
			# Membercontrol refers to the access rights and permissions...
			# 0 is NA
			# 1 is SHOWN
			# 2 is DEFAULT
			# 3 is MANDATORY
			# We will revisit this once we zoom in on the permissions issues...
			,`membercontrol`
			# othercontrol refers to the access rights...
			# 0 is NA
			# 1 is SHOWN
			# 2 is DEFAULT
			# 3 is MANDATORY
			# We will revisit this once we zoom in on the permissions issues...
			,`othercontrol`
			,`canedit`
			,`editcomponents`
			,`editbugs`
			,`canconfirm`
			) 
			VALUES 
			(@creator_group_id,@product_id,1,3,3,0,1,1,1),
			(@visibility_case_group_id,@product_id,1,1,3,0,0,1,1);

		/*Data for the table `series_categories` */
		# We need to truncate this table first
		TRUNCATE `series_categories`;
		INSERT  INTO `series_categories`
			(`id`
			,`name`
			) 
			VALUES 
			(1,CONCAT(@stakeholder,'_#',@product_id)),
			(2,'-All-'),
			(3,CONCAT(@unit,'_#',@product_id));

		# We need to know the value of the other series category we need.
		SET @series_2 = (SELECT `id` FROM `series_categories` WHERE `name` = '-All-');
		SET @series_1 = (SELECT `id` FROM `series_categories` WHERE `name` = CONCAT(@stakeholder,'_#',@product_id));
		SET @series_3 = (SELECT `id` FROM `series_categories` WHERE `name` = CONCAT(@unit,'_#',@product_id));

		/*Data for the table `series` */
		# This is so that we can see historical data and how a case is evolving
		# This can only be done after the series categories have been created
	
		INSERT  INTO `series`
			(`series_id`
			,`creator`
			,`category`
			,`subcategory`
			,`name`
			,`frequency`
			,`query`
			,`is_public`
			) 
			VALUES 
			(NULL,@bz_user_id,@series_1,@series_2,'UNCONFIRMED',1,'bug_status=UNCONFIRMED&product=Test%Unit%1%A',1),
			(NULL,@bz_user_id,@series_1,@series_2,'CONFIRMED',1,'bug_status=CONFIRMED&product=Test%Unit%1%A',1),
			(NULL,@bz_user_id,@series_1,@series_2,'IN_PROGRESS',1,'bug_status=IN_PROGRESS&product=Test%Unit%1%A',1),
			(NULL,@bz_user_id,@series_1,@series_2,'REOPENED',1,'bug_status=REOPENED&product=Test%Unit%1%A',1),
			(NULL,@bz_user_id,@series_1,@series_2,'STAND BY',1,'bug_status=STAND%20BY&product=Test%Unit%1%A',1),
			(NULL,@bz_user_id,@series_1,@series_2,'RESOLVED',1,'bug_status=RESOLVED&product=Test%Unit%1%A',1),
			(NULL,@bz_user_id,@series_1,@series_2,'VERIFIED',1,'bug_status=VERIFIED&product=Test%Unit%1%A',1),
			(NULL,@bz_user_id,@series_1,@series_2,'CLOSED',1,'bug_status=CLOSED&product=Test%Unit%1%A',1),
			(NULL,@bz_user_id,@series_1,@series_2,'FIXED',1,'resolution=FIXED&product=Test%Unit%1%A',1),
			(NULL,@bz_user_id,@series_1,@series_2,'INVAL`status_workflow`ID',1,'resolution=INVAL%60status_workflow%60ID&product=Test%Unit%1%A',1),
			(NULL,@bz_user_id,@series_1,@series_2,'WONTFIX',1,'resolution=WONTFIX&product=Test%Unit%1%A',1),
			(NULL,@bz_user_id,@series_1,@series_2,'DUPLICATE',1,'resolution=DUPLICATE&product=Test%Unit%1%A',1),
			(NULL,@bz_user_id,@series_1,@series_2,'WORKSFORME',1,'resolution=WORKSFORME&product=Test%Unit%1%A',1),
			(NULL,@bz_user_id,@series_1,@series_2,'All Open',1,'bug_status=UNCONFIRMED&bug_status=CONFIRMED&bug_status=IN_PROGRESS&bug_status=REOPENED&bug_status=STAND%20BY&product=Test%Unit%1%A',1),
			(NULL,@bz_user_id,@series_1,@series_3,'All Open',1,CONCAT('field0-0-0=resolution&type0-0-0=notregexp&value0-0-0=.&product=Test%Unit%1%A&component=', @stakeholder),1),
			(NULL,@bz_user_id,@series_1,@series_3,'All Closed',1,CONCAT('field0-0-0=resolution&type0-0-0=regexp&value0-0-0=.&product=Test%Unit%1%A&component=', @stakeholder),1);

		/*Data for the table `audit_log` */
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
			(@bz_user_id,'Bugzilla::Group',@creator_group_id,'__create__',NULL,@unit,@timestamp),
			(@bz_user_id,'Bugzilla::Group',@visibility_case_group_id,'__create__',NULL,CONCAT(@unit,' #',@product_id,' - ', @stakeholder,' - Created by: ',@creator_pub_name),@timestamp),
			(@bz_user_id,'Bugzilla::Component',@component_id,'__create__',NULL,@stakeholder,@timestamp),
			(@bz_user_id,'Bugzilla::Group',@list_user_group_id,'__create__',NULL,CONCAT(@unit,' #',@product_id,' - list stakeholder'),@timestamp),
			(@bz_user_id,'Bugzilla::Group',@see_user_group_id,'__create__',NULL,CONCAT(@unit,' #',@product_id,' - see stakeholders'),@timestamp);


# Let's Create the Privileges for Marley
#   - Marley is the Landlord
#     His `id_role_type` in the table `ut_role_types` = 2

	# We don't need to create the unit here.
	# BUT We need to Make sure that the the component for this Unit is correct
	# We also want to show the publicly visible information for Leonel.

		SET @stakeholder_pub_info = 'Marley - Profile created by Leonel';

		# User role: this is an id in the table `ut_role_types` for easier manipulation, update and maintenance
		SET @role_type_id = 2;

	# We Need the BZ user information for Marley
		SET @login_name = 'marley@example.com';
		SET @bz_user_id = 3;

	# We Need the BZ user information for Leonel too
		SET @creator_login_name = 'leonel@example.com';
		SET @creator_bz_user_id = 2;

	# We have everything - Let's create the first unit for that user!
	
		# First we disable the FK check
		SET FOREIGN_KEY_CHECKS = 0;

		# Get the additional variable that we need
		SET @timestamp = NOW();
		SET @stakeholder = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=@role_type_id);
# We create a variable @visibility_explanation to facilitate development
# This variable store the text displayed next to the 'visibility' tick in a case
SET @visibility_explanation = CONCAT('Tick to HIDE this case if the user is the ',@stakeholder,' for this unit. Untick to Show this case');
		SET @stakeholder_g_description = (SELECT `bz_description` FROM `ut_role_types` WHERE `id_role_type`=@role_type_id);

		/*Data for the table `components` */
		# We insert the correct values for the component/stakeholder.
		INSERT  INTO `components`
			(`id`
			,`name`
			,`product_id`
			,`initialowner`
			,`initialqacontact`
			,`description`
			,`isactive`
			) 
			VALUES 
			(NULL,@stakeholder,@product_id,@bz_user_id,@bz_user_id,CONCAT(@stakeholder_g_description, ' \r\ ', @stakeholder_pub_info),1);

		# In order to create the records in the audit table, we need to get the newly created component_id
		SET @component_id = LAST_INSERT_ID();

		/*Data for the table `groups` */
		# We need to do this AFTER we created the groups so we can get the creator_group_id
		# Group for 
		# 	- The unit creator and his agents DONE
		#	- To list the user who have a role in this unit DONE
		#	- To See the users who have a role in this unit DONE
		#	- To limit who can see a case or not on a bug/case by bug/case basis if the user is
		# 
		# We create the first group that we need to control access and visibility to this product/unit and the bugs/cases in this products/unit
		# This is NOT the group for the creator
		# this is a group to access a unit and create cases in a unit
		# It also allows empowered user to hide cases from users in this group
		INSERT  INTO `groups`
			(`id`
			,`name`
			,`description`
			,`isbuggroup`
			,`userregexp`
			,`isactive`
			,`icon_url`
			) 
			VALUES 
			(NULL,CONCAT(@unit,' #',@product_id,' - ', @stakeholder,' - Created by: ',@creator_pub_name), @visibility_explanation,1,'',1,NULL);
		SET @visibility_case_group_id = LAST_INSERT_ID();

		# We DO NOT need to create the Groups list and see other stakeholder
		# We just need to make sure the new user is added to the correct groups
		# Group id are:
		# 	- @list_user_group_id
		#	- @see_user_group_id
		# we just need to add this user to these group!
		# other groups that we need 
		# 
		
		# THIS IS NOT A BZ INITIATED ACTION!
		# We insert information into the table which maps groups to products/component
		INSERT INTO `ut_product_group`
			(
			product_id
			,group_id
			,group_type_id
			,role_type_id
			,created
			)
			VALUES
			# We know that the group_type_id for this group is
			# 2 = Access to product and cases
			(@product_id,@visibility_case_group_id,2,@role_type_id,@timestamp)
			,# 4 = list_stakeholder
			(@product_id,@see_user_group_id,4,@role_type_id,@timestamp)
			# 5 = see_stakeholder
			,(@product_id,@see_user_group_id,5,@role_type_id,@timestamp)
			;

		/*Data for the table `user_group_map` */
		# We add the BZ user to the groups we have just created
		INSERT  INTO `user_group_map`
			(`user_id`
			,`group_id`
			,`isbless`
			,`grant_type`
			) 
			VALUES 
			# we grant the User Access to all the default permission for the Test unit
			(@bz_user_id,@default_privilege_group_id,0,0),
			# We also need this user to access the visibility group for these cases
			(@bz_user_id,@visibility_case_group_id,0,0),
			# Make the user a member of the list and see user for this unit.
			(@bz_user_id,@list_user_group_id,0,0),
			(@bz_user_id,@see_user_group_id,0,0);

		/*Data for the table `group_group_map` */
		# The only new group we have created is the group to allow/deny visibility of a case
		INSERT  INTO `group_group_map`
			(`member_id`
			,`grantor_id`
			,`grant_type`
			) 
			VALUES 
			# We keep that for testing
			# we We DO NOT WANT THE ADMINISTRATOR (user id = 1) TO SEE AND MANAGE ALL THESE GROUPS after testing is finished... 
			(1,@visibility_case_group_id,1),
			(1,@visibility_case_group_id,2),
			# END
			# Member_id is a group_id
			# grantor_id is a group_id
			# we probably want the initial group id to be able to do that
			# this is so that the BZ APIs work as intended
			(@creator_group_id,@visibility_case_group_id,0),
			(@creator_group_id,@visibility_case_group_id,1),
			(@creator_group_id,@visibility_case_group_id,2),
			# User in a group can always see the other people in this group
			(@visibility_case_group_id,@visibility_case_group_id,2);

		/*Data for the table `group_control_map` */
		# This is where we decide who can access which products.
		INSERT  INTO `group_control_map`
			(`group_id`
			,`product_id`
			,`entry`
			# it is unclear which id this is: user_id? product_id? other?
			# in order to validate that we need to 
			#  1- re-create a 2nd product from scratch as the same user in the same classification
			#	if id is the same, this is NOT the product_id, it's something else
			#	DONE- membercontrol id is the SAME (2)
			#  2- re-create a 4th product from scratch as the same user in the same classification with a different default assignee.
			# 	if id is the same then this is not the default assignee, it's something else
			#	DONE- membercontrol id is the SAME (2)
			# Membercontrol refers to the access rights and permissions...
			# 0 is NA
			# 1 is SHOWN
			# 2 is DEFAULT
			# 3 is MANDATORY
			# We will revisit this once we zoom in on the permissions issues...
			,`membercontrol`
			# othercontrol refers to the access rights...
			# 0 is NA
			# 1 is SHOWN
			# 2 is DEFAULT
			# 3 is MANDATORY
			# We will revisit this once we zoom in on the permissions issues...
			,`othercontrol`
			,`canedit`
			,`editcomponents`
			,`editbugs`
			,`canconfirm`
			) 
			VALUES 
			(@visibility_case_group_id,@product_id,1,1,3,0,0,1,1);

		/*Data for the table `series_categories` */
		# We need to truncate this table first
		INSERT  INTO `series_categories`
			(`id`
			,`name`
			) 
			VALUES 
			# We add user id so that there are no conflicts when we create several users which are identical stakeholer (ex: 2 tenants)
			(NULL,CONCAT(@stakeholder,'_P',@product_id,'_U',@bz_user_id));

		# We need to know the value of the other series category we need.
		SET @series_3 = (SELECT `id` FROM `series_categories` WHERE `name` = CONCAT(@stakeholder,'_P',@product_id,'_U',@bz_user_id));

		/*Data for the table `series` */
		# This is so that we can see historical data and how a case is evolving
		# This can only be done after the series categories have been created
	
		INSERT  INTO `series`
			(`series_id`
			,`creator`
			,`category`
			,`subcategory`
			,`name`
			,`frequency`
			,`query`
			,`is_public`
			) 
			VALUES 
			(NULL,@bz_user_id,@series_1,@series_3,'All Open',1,CONCAT('field0-0-0=resolution&type0-0-0=notregexp&value0-0-0=.&product=Test%Unit%1%A&component=', @stakeholder),1),
			(NULL,@bz_user_id,@series_1,@series_3,'All Closed',1,CONCAT('field0-0-0=resolution&type0-0-0=regexp&value0-0-0=.&product=Test%Unit%1%A&component=', @stakeholder),1);

		/*Data for the table `audit_log` */
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
			(@creator_bz_user_id,'Bugzilla::Group',@visibility_case_group_id,'__create__',NULL,CONCAT(@unit,' #',@product_id,' - ', @stakeholder,' - Created by: ',@creator_pub_name),@timestamp),
			(@creator_bz_user_id,'Bugzilla::Component',@component_id,'__create__',NULL,@stakeholder,@timestamp);


# Let's Create the Privileges for Michael
#     Michael is one of the a 2 Tenants living in this unit.
#     His `id_role_type` in the table `ut_role_types` = 1

	# We don't need to create the unit here.
	# BUT We need to Make sure that the the component for this Unit is correct
	# We also want to show the publicly visible information for Leonel.

		SET @stakeholder_pub_info = 'Michael - Profile created by Leonel';

		# User role: this is an id in the table `ut_role_types` for easier manipulation, update and maintenance
		SET @role_type_id = 1;
		
		# Michael is also an occupant!
		# we will have to create the relevant groups and permissions for him.

	# We Need the BZ user information for Marley
		SET @login_name = 'michael@example.com';
		SET @bz_user_id = 4;

	# We Need the BZ user information for Leonel too
		SET @creator_login_name = 'leonel@example.com';
		SET @creator_bz_user_id = 2;

	# We have everything - Let's create the first unit for that user!
	
		# First we disable the FK check
		SET FOREIGN_KEY_CHECKS = 0;

		# Get the additional variable that we need
		SET @timestamp = NOW();
		SET @stakeholder = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=@role_type_id);
# We create a variable @visibility_explanation to facilitate development
# This variable store the text displayed next to the 'visibility' tick in a case
SET @visibility_explanation = CONCAT('Tick to HIDE this case if the user is the ',@stakeholder,' for this unit. Untick to Show this case');
		SET @stakeholder_g_description = (SELECT `bz_description` FROM `ut_role_types` WHERE `id_role_type`=@role_type_id);

		/*Data for the table `components` */
		# We insert the correct values for the component/stakeholder.
		INSERT  INTO `components`
			(`id`
			,`name`
			,`product_id`
			,`initialowner`
			,`initialqacontact`
			,`description`
			,`isactive`
			) 
			VALUES 
			(NULL,@stakeholder,@product_id,@bz_user_id,@bz_user_id,CONCAT(@stakeholder_g_description, ' \r\ ', @stakeholder_pub_info),1);

		# In order to create the records in the audit table, we need to get the newly created component_id
		SET @component_id = LAST_INSERT_ID();

		/*Data for the table `groups` */
		# We need to do this AFTER we created the groups so we can get the creator_group_id
		# Group for 
		# 	- The unit creator and his agents DONE
		#	- To list the user who have a role in this unit DONE
		#	- To See the users who have a role in this unit DONE
		#	- To limit who can see a case or not on a bug/case by bug/case basis if the user is
		# 
		# We create the first group that we need to control access and visibility to this product/unit and the bugs/cases in this products/unit
		# This is NOT the group for the creator
		# this is a group to access a unit and create cases in a unit
		# It also allows empowered user to hide cases from users in this group

		INSERT  INTO `groups`
			(`id`
			,`name`
			,`description`
			,`isbuggroup`
			,`userregexp`
			,`isactive`
			,`icon_url`
			) 
			VALUES 
			(NULL,CONCAT(@unit,' #',@product_id,' - ', @stakeholder,' - Created by: ',@creator_pub_name), @visibility_explanation,1,'',1,NULL);
		SET @visibility_case_group_id = LAST_INSERT_ID();
		SET @show_bug_to_occupant_group_id = (@visibility_case_group_id+1);

		# We create the group to grant visibility to occupants now
		INSERT  INTO `groups`
			(`id`
			,`name`
			,`description`
			,`isbuggroup`
			,`userregexp`
			,`isactive`
			,`icon_url`
			) 
			VALUES 
			(@show_bug_to_occupant_group_id,CONCAT(@unit,' #',@product_id,' - is occupant'),'Tick to HIDE this case if the user is the Occupant for this unit. Untick to Show this case',1,'',1,NULL);

		# We DO NOT need to create the Groups list and see other stakeholder
		# We just need to make sure the new user is added to the correct groups
		# Group id are:
		# 	- @list_user_group_id
		#	- @see_user_group_id
		# we just need to add this user to these group!
		# other groups that we need 
		# 
		
		# THIS IS NOT A BZ INITIATED ACTION!
		# We insert information into the table which maps groups to products/component
		INSERT INTO `ut_product_group`
			(
			product_id
			,group_id
			,group_type_id
			,role_type_id
			,created
			)
			VALUES
			# We know that the group_type_id for this group is
			# 2 = Access to cases
			(@product_id,@visibility_case_group_id,2,@role_type_id,@timestamp)
			,# 3 = is_occupant
			(@product_id,@show_bug_to_occupant_group_id,3,@role_type_id,@timestamp)
			,# 4 = list_stakeholder
			(@product_id,@see_user_group_id,4,@role_type_id,@timestamp)
			,# 5 = see_stakeholder
			(@product_id,@see_user_group_id,5,@role_type_id,@timestamp)
			;

		/*Data for the table `user_group_map` */
		# We add the BZ user to the groups we have just created
		INSERT  INTO `user_group_map`
			(`user_id`
			,`group_id`
			,`isbless`
			,`grant_type`
			) 
			VALUES 
			# we grant the User Access to all the default permission for the Test unit
			(@bz_user_id,@default_privilege_group_id,0,0),
			# We also need this user to access the visibility group for these cases
			# As the tenant
			(@bz_user_id,@visibility_case_group_id,0,0),
			# As the occupant
			(@bz_user_id,@show_bug_to_occupant_group_id,0,0),
			# Make the user a member of the list and see user for this unit.
			(@bz_user_id,@list_user_group_id,0,0),
			(@bz_user_id,@see_user_group_id,0,0);

		/*Data for the table `group_group_map` */
		# The only new group we have created are:
		# 	- the group to allow/deny visibility of a case to stakholder Tenant
		# 	- the group to allow/deny visibility of a case to Occupant
		INSERT  INTO `group_group_map`
			(`member_id`
			,`grantor_id`
			,`grant_type`
			) 
			VALUES 
			# We keep that for testing
			# we We DO NOT WANT THE ADMINISTRATOR (user id = 1) TO SEE AND MANAGE ALL THESE GROUPS after testing is finished... 
			(1,@visibility_case_group_id,1),
			(1,@visibility_case_group_id,2),
			(1,@show_bug_to_occupant_group_id,1),
			(1,@show_bug_to_occupant_group_id,2),
			# END
			# Member_id is a group_id
			# grantor_id is a group_id
			# we probably want the initial group id to be able to do that
			# this is so that the BZ APIs work as intended
			(@creator_group_id,@visibility_case_group_id,0),
			(@creator_group_id,@visibility_case_group_id,1),
			(@creator_group_id,@visibility_case_group_id,2),
			(@creator_group_id,@show_bug_to_occupant_group_id,0),
			(@creator_group_id,@show_bug_to_occupant_group_id,1),
			(@creator_group_id,@show_bug_to_occupant_group_id,2),
			# User in a group can always see the other people in this group
			(@visibility_case_group_id,@visibility_case_group_id,2);

		/*Data for the table `group_control_map` */
		# This is where we decide who can access which products.
		INSERT  INTO `group_control_map`
			(`group_id`
			,`product_id`
			,`entry`
			# it is unclear which id this is: user_id? product_id? other?
			# in order to validate that we need to 
			#  1- re-create a 2nd product from scratch as the same user in the same classification
			#	if id is the same, this is NOT the product_id, it's something else
			#	DONE- membercontrol id is the SAME (2)
			#  2- re-create a 4th product from scratch as the same user in the same classification with a different default assignee.
			# 	if id is the same then this is not the default assignee, it's something else
			#	DONE- membercontrol id is the SAME (2)
			# Membercontrol refers to the access rights and permissions...
			# 0 is NA
			# 1 is SHOWN
			# 2 is DEFAULT
			# 3 is MANDATORY
			# We will revisit this once we zoom in on the permissions issues...
			,`membercontrol`
			# othercontrol refers to the access rights...
			# 0 is NA
			# 1 is SHOWN
			# 2 is DEFAULT
			# 3 is MANDATORY
			# We will revisit this once we zoom in on the permissions issues...
			,`othercontrol`
			,`canedit`
			,`editcomponents`
			,`editbugs`
			,`canconfirm`
			) 
			VALUES 
			# As the Tenant
			(@visibility_case_group_id,@product_id,1,1,3,0,0,1,1),
			# As the occupant
			(@show_bug_to_occupant_group_id,@product_id,1,1,3,0,0,1,1);

		/*Data for the table `series_categories` */
		# We need to truncate this table first
		INSERT  INTO `series_categories`
			(`id`
			,`name`
			) 
			VALUES 
			# We add user id so that there are no conflicts when we create several users which are identical stakeholer (ex: 2 tenants)
			(NULL,CONCAT(@stakeholder,'_P',@product_id,'_U',@bz_user_id));

		# We need to know the value of the other series category we need.
		SET @series_3 = (SELECT `id` FROM `series_categories` WHERE `name` = CONCAT(@stakeholder,'_P',@product_id,'_U',@bz_user_id));

		/*Data for the table `series` */
		# This is so that we can see historical data and how a case is evolving
		# This can only be done after the series categories have been created
	
		INSERT  INTO `series`
			(`series_id`
			,`creator`
			,`category`
			,`subcategory`
			,`name`
			,`frequency`
			,`query`
			,`is_public`
			) 
			VALUES 
			(NULL,@bz_user_id,@series_1,@series_3,'All Open',1,CONCAT('field0-0-0=resolution&type0-0-0=notregexp&value0-0-0=.&product=Test%Unit%1%A&component=', @stakeholder),1),
			(NULL,@bz_user_id,@series_1,@series_3,'All Closed',1,CONCAT('field0-0-0=resolution&type0-0-0=regexp&value0-0-0=.&product=Test%Unit%1%A&component=', @stakeholder),1);

		/*Data for the table `audit_log` */
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
			(@creator_bz_user_id,'Bugzilla::Group',@visibility_case_group_id,'__create__',NULL,CONCAT(@unit,' #',@product_id,' - ', @stakeholder,' - Created by: ',@creator_pub_name),@timestamp),
			(@creator_bz_user_id,'Bugzilla::Group',@show_bug_to_occupant_group_id,'__create__',NULL,CONCAT(@unit,' #',@product_id,' - Occupant - Created by: ',@creator_pub_name),@timestamp),
			(@creator_bz_user_id,'Bugzilla::Component',@component_id,'__create__',NULL,@stakeholder,@timestamp);


# Let's Create the Privileges for Sabrina
#   - Sabrina is the other Tenant living in this unit.
# 	Her `id_role_type` in the table `ut_role_types` = 1
# 	She is also an occupant of the unit.

	# We don't need to create the unit here.
	# BUT We need to Make sure that the the component for this Unit is correct
	# We also want to show the publicly visible information for Leonel.

		SET @stakeholder_pub_info = 'Sabrina - Profile created by Leonel';

		# User role: this is an id in the table `ut_role_types` for easier manipulation, update and maintenance
		SET @role_type_id = 1;
		# THIS IS ANOTHER TENANT IN THE SAME UNIT, WE DON'T NEED TO DO AS MUCH AS WHEN WE CREATE THE FIRST TENANT

	# We Need the BZ user information for Marley
		SET @login_name = 'sabrina@example.com';
		SET @bz_user_id = 5;

	# We Need the BZ user information for Leonel too
		SET @creator_login_name = 'leonel@example.com';
		SET @creator_bz_user_id = 2;

	# We have everything - Let's do this!
	
		# First we disable the FK check
		SET FOREIGN_KEY_CHECKS = 0;

		# Get the additional variable that we need
		SET @timestamp = NOW();
		SET @stakeholder = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=@role_type_id);
# We create a variable @visibility_explanation to facilitate development
# This variable store the text displayed next to the 'visibility' tick in a case
SET @visibility_explanation = CONCAT('Tick to HIDE this case if the user is the ',@stakeholder,' for this unit. Untick to Show this case');
		SET @stakeholder_g_description = (SELECT `bz_description` FROM `ut_role_types` WHERE `id_role_type`=@role_type_id);

		/*Data for the table `components` */
		# We insert the correct values for the component/stakeholder.
		# This is another tenant with NO generic email address
		# We DO NOT want to create a duplicate component here
		# We just need to add Sabrina in the CC list for the component we created for all tenants
		# We need to create a dedicated component for this user.
		# We can use the variable @component_id to do this: it still has the value of the component we
		# created for the first tenant.
		INSERT  INTO `component_cc`
			(`user_id`
			,`component_id`
			) 
			VALUES 
			(@bz_user_id,@component_id);
		
		# We also want to update the description of the component, now that we have 2 users there
		# We get the current description
		SET @component_description = (SELECT `description` FROM `components` WHERE `id`=@component_id);
		# We udpdate the component description
		UPDATE `components`
			SET `description` = CONCAT(@component_description,' \r\ ',@stakeholder_pub_info)
			WHERE `id` = @component_id;

		/*Data for the table `groups` */
		# We need groups to to control access and visibility to this product/unit and the bugs/cases in this products/unit
		# This is NOT the group for the creator.
		#
		# It also allows empowered user to hide cases from users in this group
		# We DO NOT NEED to create the group(s) if it exist(s).
		#
		# Sabrina is 
		#	- A Tenant
		#	- An Occupant
		#	- A stakeholder and should be able to see and be seen by all stakeholders.
		# She should be a member of both groups for tenants and occupants in that unit.
		# 
		# We can check that these group exists in the table `ut_product_group`
		# There is already a record there for
		# 	- product_id = 1 (the test product)
		#	- group_type = 2 (access to case/unit)
		#	- role_type_id = 1 (tenant)
		#
		# There is already a record there for
		# 	- product_id = 1 (the test product)
		#	- group_type = 3 (Occupant)
		#	- role_type_id = 1 (tenant)
		#
		# We DO NOT need to create the Groups list and see other stakeholder
		# We just need to make sure the new user is added to the correct groups
		# Group id are:
		# 	- @list_user_group_id
		#	- @see_user_group_id
		# we just need to add this user to these group!
		# other groups that we need 
		# 

		/*Data for the table `user_group_map` */
		# We add the BZ user to the groups he/she needs access to.
		INSERT  INTO `user_group_map`
			(`user_id`
			,`group_id`
			,`isbless`
			,`grant_type`
			) 
			VALUES 
			# we grant the User Access to all the default permission for the Test unit
			(@bz_user_id,@default_privilege_group_id,0,0),
			# We also need this user to access the visibility group for these cases
			# We also need this user to access the visibility group for these cases
			# As the tenant
			# Because the Latest value of the @visibility_case_group_id variable was for the 
			# group which grant visibility to the tenants, we can re-use this variable here.
			(@bz_user_id,@visibility_case_group_id,0,0),
			# As the occupant
			(@bz_user_id,@show_bug_to_occupant_group_id,0,0),
			# Make the user is a member of the list and see user for this unit.
			(@bz_user_id,@list_user_group_id,0,0),
			(@bz_user_id,@see_user_group_id,0,0);

		/*Data for the table `group_group_map` */
		# We have not created any new group there: this is not needed

		/*Data for the table `group_control_map` */
		# We have not created any new group there: this is not needed

		/*Data for the table `series_categories` */
		# There is no need for that - this is not a new stakeholder.

		/*Data for the table `series` */
		# There is no need for that - this is not a new stakeholder.

		/*Data for the table `audit_log` */
		# There is no need for that - what we have done is not recordable in the Audit table



# Let's Create the Privileges for Celeste
#   - Celeste works for the Management Company Management Co, in charge of this unit.
#     Her `id_role_type` in the table `ut_role_types` = 4

	# We don't need to create the unit here.
	# BUT We need to Make sure that the the component for this Unit is correct
	# We also want to show the publicly visible information for Celeste.
	# Celeste's user account has been created by her manager Marina
	# For this script we are assuming that Marina has the necessary permission to create Celeste
	# We might need to review the actual sequence as we'll need to use the BZ API for that.

		SET @stakeholder_pub_info = 'Management Co - We take best care of your unit! ';

		# User role: this is an id in the table `ut_role_types` for easier manipulation, update and maintenance
		SET @role_type_id = 4;

	# We Need the BZ user information for Marley
		SET @login_name = 'celeste@example.com';
		SET @bz_user_id = 6;

	# We Need the BZ user information for the Management Company too
	# We will NOT create the Component with default assignee as Celeste
	# We will declare the default assignee to be the generic user for the company
	# Management.co
		SET @generic_user_name = 'management.co@example.com';
		SET @generic_bz_user_id = 13;
	
		SET @creator_login_name = 'marina@example.com';
		SET @creator_pub_name = 'Team Bravo';
		SET @creator_bz_user_id = 8;

	# We have everything
	
		# First we disable the FK check
		SET FOREIGN_KEY_CHECKS = 0;

		# Get the additional variable that we need
		SET @timestamp = NOW();
		SET @stakeholder = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=@role_type_id);
# We create a variable @visibility_explanation to facilitate development
# This variable store the text displayed next to the 'visibility' tick in a case
SET @visibility_explanation = CONCAT('Tick to HIDE this case if the user is the ',@stakeholder,' for this unit. Untick to Show this case');
		SET @stakeholder_g_description = (SELECT `bz_description` FROM `ut_role_types` WHERE `id_role_type`=@role_type_id);

		/*Data for the table `components` */
		# We insert the correct values for the component/stakeholder.
		INSERT  INTO `components`
			(`id`
			,`name`
			,`product_id`
			,`initialowner`
			,`initialqacontact`
			,`description`
			,`isactive`
			) 
			VALUES 
			(NULL,@stakeholder,@product_id,@generic_bz_user_id,@generic_bz_user_id,CONCAT(@stakeholder_g_description, ' \r\ ', @stakeholder_pub_info),1);

		# In order to create the records in the audit table, we need to get the newly created component_id
		SET @component_id = LAST_INSERT_ID();

		/*Data for the table `groups` */
		# We need to do this AFTER we created the groups so we can get the creator_group_id
		# Group for 
		# 	- The unit creator and his agents DONE
		#	- To list the user who have a role in this unit DONE
		#	- To See the users who have a role in this unit DONE
		#	- To limit who can see a case or not on a bug/case by bug/case basis if the user is
		# 
		# We create the first group that we need to control access and visibility to this product/unit and the bugs/cases in this products/unit
		# This is NOT the group for the creator
		# this is a group to access a unit and create cases in a unit
		# It also allows empowered user to hide cases from users in this group
		INSERT  INTO `groups`
			(`id`
			,`name`
			,`description`
			,`isbuggroup`
			,`userregexp`
			,`isactive`
			,`icon_url`
			) 
			VALUES 
			(NULL,CONCAT(@unit,' #',@product_id,' - ', @stakeholder,' - Created by: ',@creator_pub_name), @visibility_explanation,1,'',1,NULL);
		SET @visibility_case_group_id = LAST_INSERT_ID();

		# We DO NOT need to create the Groups list and see other stakeholder
		# We just need to make sure the new user is added to the correct groups
		# Group id are:
		# 	- @list_user_group_id
		#	- @see_user_group_id
		# we just need to add this user to these group!
		# other groups that we need 
		# 
		
		# THIS IS NOT A BZ INITIATED ACTION!
		# We insert information into the table which maps groups to products/component
		INSERT INTO `ut_product_group`
			(
			product_id
			,group_id
			,group_type_id
			,role_type_id
			,created
			)
			VALUES
			# We know that the group_type_id for this group is
			# 2 = Access to product and cases
			(@product_id,@visibility_case_group_id,2,@role_type_id,@timestamp)
			,# 4 = list_stakeholder
			(@product_id,@see_user_group_id,4,@role_type_id,@timestamp)
			# 5 = see_stakeholder
			,(@product_id,@see_user_group_id,5,@role_type_id,@timestamp)
			;

		/*Data for the table `user_group_map` */
		# We add the BZ user to the groups we have just created
		INSERT  INTO `user_group_map`
			(`user_id`
			,`group_id`
			,`isbless`
			,`grant_type`
			) 
			VALUES 
			# we grant the User Celeste Access to all the default permission for the Test unit
			(@bz_user_id,@default_privilege_group_id,0,0),
			# We also need this user Celeste to access the visibility group for these cases
			(@bz_user_id,@visibility_case_group_id,0,0),
			# The individual users Celeste and Marina are NOT a member of the stakeholder list, only the generic user is.
			(@generic_bz_user_id,@list_user_group_id,0,0),
			(@generic_bz_user_id,@see_user_group_id,0,0),
			(@generic_bz_user_id,@visibility_case_group_id,0,0),
			# We also grant access to the product to Marina, Celeste's manager and the user who is creating this.
			# We grant the User Access to all the default permission for the Test unit
			(@creator_bz_user_id,@default_privilege_group_id,0,0),
			# We also need this user (Marina) to access the visibility group for these cases
			(@creator_bz_user_id,@visibility_case_group_id,0,0);

		/*Data for the table `group_group_map` */
		# The only new group we have created is the group to allow/deny visibility of a case
		INSERT  INTO `group_group_map`
			(`member_id`
			,`grantor_id`
			,`grant_type`
			) 
			VALUES 
			# We keep that for testing
			# we We DO NOT WANT THE ADMINISTRATOR (user id = 1) TO SEE AND MANAGE ALL THESE GROUPS after testing is finished... 
			(1,@visibility_case_group_id,1),
			(1,@visibility_case_group_id,2),
			# END
			# Member_id is a group_id
			# grantor_id is a group_id
			# we probably want the initial group id to be able to do that
			# this is so that the BZ APIs work as intended
			(@creator_group_id,@visibility_case_group_id,0),
			(@creator_group_id,@visibility_case_group_id,1),
			(@creator_group_id,@visibility_case_group_id,2),
			# User in a group can always see the other people in this group
			(@visibility_case_group_id,@visibility_case_group_id,2);

		/*Data for the table `group_control_map` */
		# This is where we decide who can access which products.
		INSERT  INTO `group_control_map`
			(`group_id`
			,`product_id`
			,`entry`
			# it is unclear which id this is: user_id? product_id? other?
			# in order to validate that we need to 
			#  1- re-create a 2nd product from scratch as the same user in the same classification
			#	if id is the same, this is NOT the product_id, it's something else
			#	DONE- membercontrol id is the SAME (2)
			#  2- re-create a 4th product from scratch as the same user in the same classification with a different default assignee.
			# 	if id is the same then this is not the default assignee, it's something else
			#	DONE- membercontrol id is the SAME (2)
			# Membercontrol refers to the access rights and permissions...
			# 0 is NA
			# 1 is SHOWN
			# 2 is DEFAULT
			# 3 is MANDATORY
			# We will revisit this once we zoom in on the permissions issues...
			,`membercontrol`
			# othercontrol refers to the access rights...
			# 0 is NA
			# 1 is SHOWN
			# 2 is DEFAULT
			# 3 is MANDATORY
			# We will revisit this once we zoom in on the permissions issues...
			,`othercontrol`
			,`canedit`
			,`editcomponents`
			,`editbugs`
			,`canconfirm`
			) 
			VALUES 
			(@visibility_case_group_id,@product_id,1,1,3,0,0,1,1);

		/*Data for the table `series_categories` */
		# We need to truncate this table first
		INSERT  INTO `series_categories`
			(`id`
			,`name`
			) 
			VALUES 
			# We add user id so that there are no conflicts when we create several users which are identical stakeholer (ex: 2 tenants)
			# in this case, the user we choose is Marina, the manager.
			(NULL,CONCAT(@stakeholder,'_P',@product_id,'_U',@creator_bz_user_id));

		# We need to know the value of the other series category we need.
		SET @series_3 = (SELECT `id` FROM `series_categories` WHERE `name` = CONCAT(@stakeholder,'_P',@product_id,'_U',@creator_bz_user_id));

		/*Data for the table `series` */
		# This is so that we can see historical data and how a case is evolving
		# This can only be done after the series categories have been created
	
		INSERT  INTO `series`
			(`series_id`
			,`creator`
			,`category`
			,`subcategory`
			,`name`
			,`frequency`
			,`query`
			,`is_public`
			) 
			VALUES 
			(NULL,@creator_bz_user_id,@series_1,@series_3,'All Open',1,CONCAT('field0-0-0=resolution&type0-0-0=notregexp&value0-0-0=.&product=Test%Unit%1%A&component=', @stakeholder),1),
			(NULL,@creator_bz_user_id,@series_1,@series_3,'All Closed',1,CONCAT('field0-0-0=resolution&type0-0-0=regexp&value0-0-0=.&product=Test%Unit%1%A&component=', @stakeholder),1);

		/*Data for the table `audit_log` */
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
			(@creator_bz_user_id,'Bugzilla::Group',@visibility_case_group_id,'__create__',NULL,CONCAT(@unit,' #',@product_id,' - ', @stakeholder,' - Created by: ',@creator_pub_name),@timestamp),
			(@creator_bz_user_id,'Bugzilla::Component',@component_id,'__create__',NULL,@stakeholder,@timestamp);






		# We enable the FK check back
		SET FOREIGN_KEY_CHECKS = 1;

	# Cleanup after: flush the variables
	SET @timestamp = NULL;
	SET @unit_group = NULL;
	SET @unit = NULL;
	SET @unit_pub_description = NULL;
	SET @stakeholder = NULL;
	SET @stakeholder_g_description = NULL;
	SET @stakeholder_pub_info = NULL;
	SET @login_name = NULL;
	SET @bz_user_id = NULL;
	SET @creator_login_name = NULL;
	SET @creator_bz_user_id = NULL;
	SET @creator_pub_name = NULL;
	SET @visibility_explanation = NULL;
	SET @product_id = NULL;
	SET @milestone_id = NULL;
	SET @version_id = NULL;
	SET @creator_component_id = NULL;
	SET @component_id = NULL;
	SET @creator_group_id = NULL;
	SET @show_bug_to_occupant_group_id = NULL;
	SET @generic_user_name = NULL;
	SET @generic_bz_user_id = NULL;
	SET @visibility_case_group_id = NULL;
	SET @list_user_group_id = NULL;
	SET @see_user_group_id = NULL;
	SET @series_2 = NULL;
	SET @series_1 = NULL;
	SET @series_3 = NULL;
