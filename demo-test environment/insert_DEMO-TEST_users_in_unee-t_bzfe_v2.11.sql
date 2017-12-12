# For any question about this script, ask Franck
#
# This script Creates demo users in the Unee-T BZFE database v2.10
#
# Pre requisite:
#	- BZFE database v2.10 for Unee-T has been created
#	- You are in a DEV or DEMO environment
#	- You have decided the following things

# How many users do you want to created
#	IMPORTANT NOTE: users are created in batch of 12 users so we can have various profiles.
#	We add 1 more user: the administrator.
#	The below variable is use to determine how many groups of 13 users you want to create:
#	- 1 = (1x12) + 1 = 13 users
#	- 2 = (2x12) + 1 = 25 users
#	- 3 = (3x12) + 1 = 37 users
#	...
#	- N = Nx13 users

SET @iteration_number_of_users = 2;

# How many product/unit you want to create for each user
SET @number_of_units_per_user = 10;

#		- How many Classification you want to create
#		 This should be rule based: we create a new classification for each group of X units
SET @number_of_units_per_classification = 25;

#		- How many role per unit/product you want to create
#
# Limits of this script:
#	- We do NOT create any bug
#
# How this works:
#	- Enter the values for the variables you need
#	- Run the script.
#
# We are creating serveral users. To see the list of users, go to the BZFE back end
#
#

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Insert the initial demo users
	
	/*We Remove all the existing users in the installation */
		TRUNCATE `profiles`;
		
	/*Data for the table `profiles` */
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

		# We record the information about the users that we have just created
		
			INSERT INTO `ut_map_user_unit_details`
			(`created`
			,`record_created_by`
			,`user_id`
			,`bz_profile_id`
			,`public_name`
			,`comment`
			)
			VALUES
			(NOW(), 1, 1, 1, 'Administrator', 'Created as a demo user with demo user creation script')
			,(NOW(), 1, 2, 2, 'Leonel', 'Created as a demo user with demo user creation script')
			,(NOW(), 1, 3, 3, 'Marley', 'Created as a demo user with demo user creation script')
			,(NOW(), 1, 4, 4, 'Michael', 'Created as a demo user with demo user creation script')
			,(NOW(), 1, 5, 5, 'Sabrina', 'Created as a demo user with demo user creation script')
			,(NOW(), 1, 6, 6, 'Celeste', 'Created as a demo user with demo user creation script')
			,(NOW(), 1, 7, 7, 'Jocelyn', 'Created as a demo user with demo user creation script')
			,(NOW(), 1, 8, 8, 'Marina', 'Created as a demo user with demo user creation script')
			,(NOW(), 1, 9, 9, 'Regina', 'Created as a demo user with demo user creation script')
			,(NOW(), 1, 10, 10, 'Marvin', 'Created as a demo user with demo user creation script')
			,(NOW(), 1, 11, 11, 'Lawrence', 'Created as a demo user with demo user creation script')
			,(NOW(), 1, 12, 12, 'Anabelle', 'Created as a demo user with demo user creation script')
			,(NOW(), 1, 13, 13, 'Management Co', 'Created as a demo user with demo user creation script')
			;
			
			
	# For the demo we make sure that all the additional users (administrator already exist) can:
	#	- See all the time tracking information (group id 16)
	#	- Create Shared queries (group id 17)
	#	- tag comments (group id 18)
	
	/* We cleanup the user_group_map table */
	TRUNCATE `user_group_map`;	

	/*Data for the table `user_group_map` */
	INSERT  INTO `user_group_map`
		(`user_id`
		,`group_id`
		,`isbless`
		,`grant_type`
		) 
		VALUES 
		(1,1,0,0);
	
	/* */
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
				(13,18,0,0);
			
			
# We insert more users based on the variable entered by the user:
DELIMITER $$
	DROP PROCEDURE IF EXISTS insert_users$$
	CREATE PROCEDURE insert_users()
		BEGIN
		DECLARE number_of_loops_user INT DEFAULT 1;
		WHILE number_of_loops_user < @iteration_number_of_users DO
			SET @additional_user_id = (number_of_loops_user + 1);
			
			SET @user_2_id = (((12 * (@additional_user_id - 1)) + 0) + @additional_user_id);
			SET @user_2_login_name = CONCAT('leonel','_',@additional_user_id,'@example.com');
			SET @user_2_real_name = CONCAT('Leonel-', @additional_user_id);
			
			SET @user_3_id = (((12 * (@additional_user_id - 1)) + 1) + @additional_user_id);
			SET @user_3_login_name = CONCAT('marley','_',@additional_user_id,'@example.com');
			SET @user_3_real_name = CONCAT('Marley-', @additional_user_id);
			
			SET @user_4_id = (((12 * (@additional_user_id-1)) + 2) + @additional_user_id);
			SET @user_4_login_name = CONCAT('michael','_',@additional_user_id,'@example.com');
			SET @user_4_real_name = CONCAT('Michael-', @additional_user_id);

			SET @user_5_id = (((12 * (@additional_user_id-1)) + 3) + @additional_user_id);
			SET @user_5_login_name = CONCAT('sabrina','_',@additional_user_id,'@example.com');
			SET @user_5_real_name = CONCAT('Sabrina-', @additional_user_id);

			SET @user_6_id = (((12 * (@additional_user_id-1)) + 4) + @additional_user_id);
			SET @user_6_login_name = CONCAT('celeste','_',@additional_user_id,'@example.com');
			SET @user_6_real_name = CONCAT('Celeste-', @additional_user_id);

			SET @user_7_id = (((12 * (@additional_user_id-1)) + 5) + @additional_user_id);
			SET @user_7_login_name = CONCAT('jocelyn','_',@additional_user_id,'@example.com');
			SET @user_7_real_name = CONCAT('Jocelyn-', @additional_user_id);
			
			SET @user_8_id = (((12 * (@additional_user_id-1)) + 6) + @additional_user_id);
			SET @user_8_login_name = CONCAT('marina','_',@additional_user_id,'@example.com');
			SET @user_8_real_name = CONCAT('Marina-', @additional_user_id);

			SET @user_9_id = (((12 * (@additional_user_id-1)) + 7) + @additional_user_id);
			SET @user_9_login_name = CONCAT('regina','_',@additional_user_id,'@example.com');
			SET @user_9_real_name = CONCAT('Regina-', @additional_user_id);

			SET @user_10_id = (((12 * (@additional_user_id-1)) + 8) + @additional_user_id);
			SET @user_10_login_name = CONCAT('marvin','_',@additional_user_id,'@example.com');
			SET @user_10_real_name = CONCAT('Marvin-', @additional_user_id);

			SET @user_11_id = (((12 * (@additional_user_id-1)) + 9) + @additional_user_id);
			SET @user_11_login_name = CONCAT('lawrence','_',@additional_user_id,'@example.com');
			SET @user_11_real_name = CONCAT('Lawrence-', @additional_user_id);

			SET @user_12_id = (((12 * (@additional_user_id-1)) + 10) + @additional_user_id);
			SET @user_12_login_name = CONCAT('anabelle','_',@additional_user_id,'@example.com');
			SET @user_12_real_name = CONCAT('Anabelle-', @additional_user_id);

			SET @user_13_id = (((12 * (@additional_user_id-1)) + 11) + @additional_user_id);
			SET @user_13_login_name = CONCAT('management.co','_',@additional_user_id,'@example.com');
			SET @user_13_real_name = CONCAT('Management-Co-', @additional_user_id);
			
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
				(@user_2_id,@user_2_login_name,'uVkp9Jte,ts7kZpZuOcTkMAh1c4iX4IcEZTxpq0Sfr7XraiZoL+g{SHA-256}',@user_2_real_name,'',0,1,NULL,1,NULL),
				(@user_3_id,@user_3_login_name,'AMOb0L00,NlJF4wyZVyT+xWuUr3RYgDIYxMhfBJCZxvkSh5cRSVs{SHA-256}',@user_3_real_name,'',0,1,NULL,1,NULL),
				(@user_4_id,@user_4_login_name,'Tp0jDQnd,kD+mf67/v/ck68nOyRTR4j7JNVpo1XzzDFSIR6U7Lps{SHA-256}',@user_4_real_name,'',0,1,NULL,1,NULL),
				(@user_5_id,@user_5_login_name,'fjeiOOVC,vUkDbdxcfk9snn9J5Vh4r/cujX2FfOKEcBZBAOcMw3k{SHA-256}',@user_5_real_name,'',0,1,NULL,1,NULL),
				(@user_6_id,@user_6_login_name,'ZAU7m97y,kw6J1Bf2Hw21qELelxM3BbK+4avsmJytG/WzssHMbXE{SHA-256}',@user_6_real_name,'',0,1,NULL,1,NULL),
				(@user_7_id,@user_7_login_name,'0ZprH6RJ,zXa/xkkETvkPZ988xpyQQocYYfLAIWdCLCk1wE4QXNA{SHA-256}',@user_7_real_name,'',0,1,NULL,1,NULL),
				(@user_8_id,@user_8_login_name,'8c2ofNwd,VpZbBAByL89ZKCI3xT7zFjZBb/X7JHW6KjtA9yY8KYo{SHA-256}',@user_8_real_name,'',0,1,NULL,1,NULL),
				(@user_9_id,@user_9_login_name,'HuM6hVYF,Ev6TBPrrOm4pSu5chsr1Q6Hi6q2Tmm98IbLh7ONqtYs{SHA-256}',@user_9_real_name,'',0,1,NULL,1,NULL),
				(@user_10_id,@user_10_login_name,'6kTmgSt9,FI+tK4vrJQa8lInrRGKxmQ0JW2WpVImRk+ylhcMYGKM{SHA-256}',@user_10_real_name,'',0,1,NULL,1,NULL),
				(@user_11_id,@user_11_login_name,'JqPmW7RA,tJopvIAj1kbeRJ61pZUqjce1dZrGoBpnHMzycgTuTqE{SHA-256}',@user_11_real_name,'',0,1,NULL,1,NULL),
				(@user_12_id,@user_12_login_name,'9bgiCNi8,32d10yq/btaTsj/awDksNPjdUDLIrGfkK+vRKWfYbQo{SHA-256}',@user_12_real_name,'',0,1,NULL,1,NULL),
				(@user_13_id,@user_13_login_name,'C162r0Mo,/V0m+v2cmZqU0JOjQBR8X5Q26xSgKTBs/f/Wke51oSI{SHA-256}',@user_13_real_name,'',0,1,NULL,1,NULL);

	# For the demo we make sure that all the additional users (administrator already exist) can:
	#	- See all the time tracking information (group id 16)
	#	- Create Shared queries (group id 17)
	#	- tag comments (group id 18)
	
			INSERT  INTO `user_group_map`
			(`user_id`
			,`group_id`
			,`isbless`
			,`grant_type`
			) 
			VALUES 
				(@user_2_id,16,0,0),
				(@user_2_id,17,0,0),
				(@user_2_id,18,0,0),
				(@user_3_id,16,0,0),
				(@user_3_id,17,0,0),
				(@user_3_id,18,0,0),
				(@user_4_id,16,0,0),
				(@user_4_id,17,0,0),
				(@user_4_id,18,0,0),
				(@user_5_id,16,0,0),
				(@user_5_id,17,0,0),
				(@user_5_id,18,0,0),
				(@user_6_id,16,0,0),
				(@user_6_id,17,0,0),
				(@user_6_id,18,0,0),
				(@user_7_id,16,0,0),
				(@user_7_id,17,0,0),
				(@user_7_id,18,0,0),
				(@user_8_id,16,0,0),
				(@user_8_id,17,0,0),
				(@user_8_id,18,0,0),
				(@user_9_id,16,0,0),
				(@user_9_id,17,0,0),
				(@user_9_id,18,0,0),
				(@user_10_id,16,0,0),
				(@user_10_id,17,0,0),
				(@user_10_id,18,0,0),
				(@user_11_id,16,0,0),
				(@user_11_id,17,0,0),
				(@user_11_id,18,0,0),
				(@user_12_id,16,0,0),
				(@user_12_id,17,0,0),
				(@user_12_id,18,0,0),
				(@user_13_id,16,0,0),
				(@user_13_id,17,0,0),
				(@user_13_id,18,0,0);


		# We record the information about the users that we have just created
		
			INSERT INTO `ut_map_user_unit_details`
			(`created`
			,`record_created_by`
			,`user_id`
			,`bz_profile_id`
			,`public_name`
			,`comment`
			)
			VALUES
			(NOW(), 1, @user_2_id, @user_2_id, @user_2_real_name, 'Created as a demo user with demo user creation script')
			,(NOW(), 1, @user_3_id, @user_3_id, @user_3_real_name, 'Created as a demo user with demo user creation script')
			,(NOW(), 1, @user_4_id, @user_4_id, @user_4_real_name, 'Created as a demo user with demo user creation script')
			,(NOW(), 1, @user_5_id, @user_5_id, @user_5_real_name, 'Created as a demo user with demo user creation script')
			,(NOW(), 1, @user_6_id, @user_6_id, @user_6_real_name, 'Created as a demo user with demo user creation script')
			,(NOW(), 1, @user_7_id, @user_7_id, @user_7_real_name, 'Created as a demo user with demo user creation script')
			,(NOW(), 1, @user_8_id, @user_8_id, @user_8_real_name, 'Created as a demo user with demo user creation script')
			,(NOW(), 1, @user_9_id, @user_9_id, @user_9_real_name, 'Created as a demo user with demo user creation script')
			,(NOW(), 1, @user_10_id, @user_10_id, @user_10_real_name, 'Created as a demo user with demo user creation script')
			,(NOW(), 1, @user_11_id, @user_11_id, @user_11_real_name, 'Created as a demo user with demo user creation script')
			,(NOW(), 1, @user_12_id, @user_12_id, @user_12_real_name, 'Created as a demo user with demo user creation script')
			,(NOW(), 1, @user_13_id, @user_13_id, @user_13_real_name, 'Created as a demo user with demo user creation script')
			;

			SET number_of_loops_user = (number_of_loops_user + 1);
		END WHILE;
	END$$
DELIMITER ;
CALL insert_users;
DROP PROCEDURE IF EXISTS insert_users;

/*Data for the table `classifications` */
	TRUNCATE TABLE `classifications`;

# We always insert the 2 classifications that we need.
	INSERT  INTO `classifications`(`id`,`name`,`description`,`sortkey`) VALUES 
	(1,'Test Units','These are TEST units that you have created or where I have been invited',0),
	(2,'My Units','These are the units that you have created or where I have been invited',0);

/* FOR NOW, WE WILL CREATE ALL THE NEW PRODUCTS IN THE 'Test Units' Classification.*/
# AS WE DEVELOP THE SCRIPT WE WILL CHANGE THAT TO CREATE A CLASSIFICATION EACH TIME WE CREATE A GROUP OF
# X UNITS
/*
#DELIMITER $$
	DROP PROCEDURE IF EXISTS insert_classification$$
	CREATE PROCEDURE insert_classification()
		BEGIN
		DECLARE ipi_product_id INT DEFAULT 2;
		WHILE ipi_product_id <= (SELECT MAX(id) FROM `ipi_products`) DO
			SET @ipi_product_id = ipi_product_id;
			SET @unit_group = CONCAT('LMB-',(SELECT `name` FROM `ipi_products` WHERE `id` = ipi_product_id));
			SET @unit_group_description = (SELECT `description` FROM `ipi_products` WHERE `id` = ipi_product_id);
			INSERT INTO `ut_classifications`
				(`id`
				,`name`
				,`description`
				)
				VALUES
				(NULL,@unit_group,@unit_group_description);
			SET @classification_id = LAST_INSERT_ID();
			INSERT  INTO `migration_to_ut_classifications`
				(`id`
				,`new_classification_id`
				,`original_product_id`
				,`name`
				,`description` 
				,`sortkey`
				) 
				VALUES 
				(NULL,@classification_id,ipi_product_id,@unit_group,@unit_group_description,0);
			SET ipi_product_id = (ipi_product_id + 1);
			SET @classification_id = NULL;
			SET @unit_group = NULL;
			SET @unit_group_description = NULL;		
		END WHILE;		
	END$$
#DELIMITER ;
CALL insert_classification;
DROP PROCEDURE IF EXISTS insert_classification;
*/


# We now create the units we need.

	/*Data for the table `products` */
		TRUNCATE TABLE `products`;

		INSERT  INTO `products`(`id`,`name`,`classification_id`,`description`,`isactive`,`defaultmilestone`,`allows_unconfirmed`) VALUES 
		(1,'Test Unit 1 A',1,'Demo unit 1.\r\nThis unit is located at:\r\nProperty A address. \r\nWe can add a few comment about the unit if needed.',1,'---',1);

	/*Data for the table `milestones` */
		TRUNCATE TABLE `milestones`;

		INSERT  INTO `milestones`(`id`,`product_id`,`value`,`sortkey`,`isactive`) VALUES 
		(1,1,'---',0,1);

	/*Data for the table `versions` */
		TRUNCATE TABLE `versions`;

		INSERT  INTO `versions`(`id`,`value`,`product_id`,`isactive`) VALUES 
		(1,'---',1,1);

	/*Data for the table `flagtypes` */
		TRUNCATE TABLE `flagtypes`;

		INSERT  INTO `flagtypes`
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
			# First the flags for the demo product
			(1,'Test_Unit_1_A_P1_Next_Step','Approval for the Next Step of the case.','','b',1,1,1,1,10,20,19)
			,(2,'Test_Unit_1_A_P1_Solution','Approval for the Solution of this case.','','b',1,1,1,1,20,22,21)
			,(3,'Test_Unit_1_A_P1_Budget','Approval for the Budget for this case.','','b',1,1,1,1,30,23,24)
			,(4,'Test_Unit_1_A_P1_Attachment','Approval for this Attachment.','','a',1,1,1,1,10,26,25)
			,(5,'Test_Unit_1_A_P1_OK_to_pay','Approval to pay this bill.','','a',1,1,1,1,20,27,28)
			,(6,'Test_Unit_1_A_P1_is_paid','Confirm if this bill has been paid.','','a',1,1,1,1,30,29,30)
			;
		

	/*Data for the table `flaginclusions` */
		TRUNCATE TABLE `flaginclusions`;

		INSERT  INTO `flaginclusions`(`type_id`,`product_id`,`component_id`) VALUES 
		(1,1,NULL),
		(2,1,NULL),
		(3,1,NULL),
		(4,1,NULL),
		(5,1,NULL),
		(6,1,NULL);


	/*Data for the table `group_group_map` */
		TRUNCATE TABLE `group_group_map`;

		insert  into `group_group_map`(`member_id`,`grantor_id`,`grant_type`) values 
		(1,1,0),
		(1,1,1),
		(1,1,2),
		(1,2,0),
		(1,2,1),
		(1,2,2),
		(1,3,0),
		(1,3,1),
		(1,3,2),
		(1,4,0),
		(1,4,1),
		(1,4,2),
		(1,5,0),
		(1,5,1),
		(1,5,2),
		(1,6,0),
		(1,6,1),
		(1,6,2),
		(1,7,0),
		(1,7,1),
		(1,7,2),
		(1,8,0),
		(1,8,1),
		(1,8,2),
		(1,9,0),
		(1,9,1),
		(1,9,2),
		(1,10,0),
		(1,10,1),
		(1,10,2),
		(1,11,0),
		(1,11,1),
		(1,11,2),
		(1,12,0),
		(1,12,1),
		(1,12,2),
		(1,13,0),
		(1,13,1),
		(1,13,2),
		(1,14,0),
		(1,14,1),
		(1,14,2),
		(1,15,0),
		(1,15,1),
		(1,15,2),
		(1,16,0),
		(1,16,1),
		(1,16,2),
		(1,17,0),
		(1,17,1),
		(1,17,2),
		(1,18,0),
		(1,18,1),
		(1,18,2),
		(1,19,0),
		(1,19,1),
		(1,19,2),
		(1,20,1),
		(1,20,2),
		(1,21,0),
		(1,21,1),
		(1,21,2),
		(1,22,1),
		(1,22,2),
		(1,23,1),
		(1,23,2),
		(1,24,1),
		(1,24,2),
		(1,25,1),
		(1,25,2),
		(1,26,0),
		(1,26,1),
		(1,26,2),
		(1,27,1),
		(1,27,2),
		(1,28,1),
		(1,28,2),
		(1,29,0),
		(1,29,1),
		(1,29,2),
		(1,30,0),
		(1,30,1),
		(1,30,2),
		(1,31,1),
		(1,31,2),
		(31,16,0),
		(31,17,0),
		(31,18,0),
		(31,19,0),
		(31,20,0),
		(31,21,0),
		(31,22,0),
		(31,23,0),
		(31,24,0),
		(31,25,0),
		(31,26,0),
		(31,27,0),
		(31,28,0),
		(31,29,0),
		(31,30,0);

	/*Table structure for table `groups` */
		TRUNCATE `groups`;	


	/*Data for the table `groups` */

		insert  into `groups`(`id`,`name`,`description`,`isbuggroup`,`userregexp`,`isactive`,`icon_url`) values 
		(1,'admin','Administrators',0,'',1,NULL),
		(2,'tweakparams','Can change Parameters',0,'',1,NULL),
		(3,'editusers','Can edit or disable users',0,'',1,NULL),
		(4,'creategroups','Can create and destroy groups',0,'',1,NULL),
		(5,'editclassifications','Can create, destroy, and edit classifications',0,'',1,NULL),
		(6,'editcomponents','Can create, destroy, and edit components',0,'',1,NULL),
		(7,'editkeywords','Can create, destroy, and edit keywords',0,'',1,NULL),
		(8,'editbugs','Can edit all bug fields',0,'',1,NULL),
		(9,'canconfirm','Can confirm a bug or mark it a duplicate',0,'',1,NULL),
		(10,'bz_canusewhineatothers','Can configure whine reports for other users',0,'',1,NULL),
		(11,'bz_canusewhines','User can configure whine reports for self',0,'',1,NULL),
		(12,'bz_sudoers','Can perform actions as other users',0,'',1,NULL),
		(13,'bz_sudo_protect','Can not be impersonated by other users',0,'',1,NULL),
		(14,'bz_quip_moderators','Can moderate quips',0,'',1,NULL),
		(15,'syst_private_comment','A group to allow user to see the private comments in ALL the activities they are allowed to see. This is for Employees vs external users.',1,'',0,NULL),
		(16,'syst_see_timetracking','A group to allow users to see the time tracking information in ALL the activities they are allowed to see.',1,'',0,NULL),
		(17,'syst_create_shared_queries','A group for users who can create, save and share search queries.',1,'',0,NULL),
		(18,'syst_tag_comments','A group to allow users to tag comments in ALL the activities they are allowed to see.',1,'',0,NULL),
		(19,'Test Unit 1 A #1-RA Next Step','Request approval for the Next step in a case',1,'',0,NULL),
		(20,'Test Unit 1 A #1-GA Next Step','Grant approval for the Next step in a case',1,'',0,NULL),
		(21,'Test Unit 1 A #1-RA Solution','Request approval for the Solution in a case',1,'',0,NULL),
		(22,'Test Unit 1 A #1-GA Solution','Grant approval for the Solution in a case',1,'',0,NULL),
		(23,'Test Unit 1 A #1-GA Budget','Request approval for the Budget in a case',1,'',0,NULL),
		(24,'Test Unit 1 A #1-RA Budget','Request approval for the Budget in a case',1,'',0,NULL),
		(25,'Test Unit 1 A #1-RA Attachment','Request approval for an Attachment in a case',1,'',0,NULL),
		(26,'Test Unit 1 A #1-GA Attachment','Grant approval for an Attachment in a case',1,'',0,NULL),
		(27,'Test Unit 1 A #1-GA OK to Pay','Grant approval to pay (for a bill/attachment)',1,'',0,NULL),
		(28,'Test Unit 1 A #1-RA OK to Pay','Request approval to pay (for a bill/attachment)',1,'',0,NULL),
		(29,'Test Unit 1 A #1-GA is Paid','Confirm that it\'s paid (for a bill/attachment)',1,'',0,NULL),
		(30,'Test Unit 1 A #1-RA is Paid','Ask if it\'s paid (for a bill/attachment)',1,'',0,NULL),
		(31,'Test Unit 1 A #1-All permissions','Access to All the groups a stakeholder needs for this unit',1,'',0,NULL);

	/*Table structure for table `product_group` */

##########
#
#	WIP
#

		TRUNCATE TABLE `ut_product_group`;

		TRUNCATE TABLE `group_control_map`;

/*		
			INSERT  INTO `group_control_map`
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
				;
*/

#
#	END WIP
#
##########
		
	# We insert the products we need	
	SET @number_of_units = (@number_of_units_per_user * @iteration_number_of_users * 12);
	SET @iteration_thru_user = 0;

DELIMITER $$
		DROP PROCEDURE IF EXISTS insert_products$$
		CREATE PROCEDURE insert_products()
		BEGIN
		DECLARE loops_products INT DEFAULT 2;
		# We have already created a TEST product 1, we add demo units on top of that one
		WHILE loops_products <= (@number_of_units + 1) DO
			SET FOREIGN_KEY_CHECKS = 0;
			SET @product_id = loops_products;

			# Each user will be associated to a product.
			
			# How many possible demo user do we have?
			SET @count_max_demo_user = (@iteration_number_of_users * 12);
			
			# For this unit/creator, which user loop is this?
			SET @user_loop_counter = CEILING(((@product_id - 1)/@count_max_demo_user));
			
			SET @creator_bz_id = (@product_id - (@iteration_number_of_users * ((@user_loop_counter - 1) * 12)));
					
##########################
#								
# This is WIP, we need to find a way to have different classifications.
#
#
			SET @classification_id = 1;
#
#
##########################
			
			SET @unit = CONCAT('Demo-Unit','-',@product_id);
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
				SET @unit_description = CONCAT('The description for Unit #',@product_id);
				SET @default_milestone = '---';
				SET @timestamp = NOW();
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
					(NULL,@unit,@classification_id,@unit_description,1,@default_milestone,1);
#				SET @product_id = LAST_INSERT_ID();
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
					(NULL,CONCAT(@unit,'-Can Create Cases'),'User can create cases for this unit.',1,'',1,NULL);
				SET @create_case_group_id = LAST_INSERT_ID();
				SET @can_edit_case_group_id = (@create_case_group_id+1);
				SET @can_edit_all_field_case_group_id = (@can_edit_case_group_id+1);
				SET @can_edit_component_group_id = (@can_edit_all_field_case_group_id+1);
				SET @can_see_cases_group_id = (@can_edit_component_group_id+1);
				SET @all_g_flags_group_id = (@can_see_cases_group_id+1);
				SET @all_r_flags_group_id = (@all_g_flags_group_id+1);
				SET @list_visible_assignees_group_id = (@all_r_flags_group_id+1);
				SET @see_visible_assignees_group_id = (@list_visible_assignees_group_id+1);
				SET @active_stakeholder_group_id = (@see_visible_assignees_group_id+1);
				SET @unit_creator_group_id = (@active_stakeholder_group_id+1)
				;
##################
# We minimize the number of group we create until we have a workaround for the login perf:
#	There will be only 1 group for flag approver and flag requester				
#				SET @g_group_next_step = (@active_stakeholder_group_id+1);
#				SET @r_group_next_step = (@g_group_next_step+1);
#				SET @g_group_solution = (@r_group_next_step+1);
#				SET @r_group_solution = (@g_group_solution+1);
#				SET @g_group_budget = (@r_group_solution+1);
#				SET @r_group_budget = (@g_group_budget+1);
#				SET @g_group_attachment = (@r_group_budget+1);
#				SET @r_group_attachment = (@g_group_attachment+1);
#				SET @g_group_OK_to_pay = (@r_group_attachment+1);
#				SET @r_group_OK_to_pay = (@g_group_OK_to_pay+1);
#				SET @g_group_is_paid = (@r_group_OK_to_pay+1);
#				SET @r_group_is_paid = (@g_group_is_paid+1);
######################


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
					(@can_edit_case_group_id,CONCAT(@unit,'-Can edit'),'user in this can edit a case they have access to',1,'',1,NULL),
					(@can_edit_all_field_case_group_id,CONCAT(@unit,'-Can edit all fields'),'user in this can edit all fields in a case they have access to, regardless of its role',1,'',1,NULL),
					(@can_edit_component_group_id,CONCAT(@unit,'-Can edit components'),'user in this can edit components/stakholders and permission for the unit',1,'',1,NULL),
					(@can_see_cases_group_id,CONCAT(@unit,'-Visible to all'),'All users in this unit can see this case for the unit',1,'',1,NULL),
					(@all_g_flags_group_id,CONCAT(@unit,'-Can approve all flags'),'user in this group are allowed to approve all flags',0,'',1,NULL),
					(@all_r_flags_group_id,CONCAT(@unit,'-Can be asked to approve all flags'),'user in this group are visible in the list of flag approver',0,'',1,NULL),
					(@list_visible_assignees_group_id,CONCAT(@unit,'-List stakeholder'),'List all the users which are visible assignee(s) for this unit',0,'',1,NULL),
					(@see_visible_assignees_group_id,CONCAT(@unit,'-See stakeholder'),'Can see all the users which are stakeholders for this unit',0,'',1,NULL),
					(@active_stakeholder_group_id,CONCAT(@unit,'-Active stakeholder'),'For users who have a role in this unit as of today',1,'',1,NULL),
					(@unit_creator_group_id,CONCAT(@unit,'-Unit Creators'),'This is the group for the unit creator',0,'',1,NULL);

##################
# Once we fix the login performance issue, we will be able to re-create these groups.
#					(@g_group_next_step,CONCAT(@unit,'-GA Next Step'),'Grant approval for the Next step in a case',0,'',1,NULL),
#					(@r_group_next_step,CONCAT(@unit,'-RA Next Step'),'Request approval for the Next step in a case',0,'',1,NULL),
#					(@g_group_solution,CONCAT(@unit,'-GA Solution'),'Grant approval for the Solution in a case',0,'',1,NULL),
#					(@r_group_solution,CONCAT(@unit,'-RA Solution'),'Request approval for the Solution in a case',0,'',1,NULL),
#					(@g_group_budget,CONCAT(@unit,'-GA Budget'),'Grant approval for the Budget in a case',0,'',1,NULL),
#					(@r_group_budget,CONCAT(@unit,'-RA Budget'),'Request approval for the Budget in a case',0,'',1,NULL),
#					(@g_group_attachment,CONCAT(@unit,'-GA Attachment'),'Grant approval for an Attachment in a case',0,'',1,NULL),
#					(@r_group_attachment,CONCAT(@unit,'-RA Attachment'),'Request approval for an Attachment in a case',0,'',1,NULL),
#					(@g_group_OK_to_pay,CONCAT(@unit,'-GA OK to Pay'),'Grant approval to pay (for a bill/attachment)',0,'',1,NULL),
#					(@r_group_OK_to_pay,CONCAT(@unit,'-RA OK to Pay'),'Request approval to pay (for a bill/attachment)',0,'',1,NULL),
#					(@g_group_is_paid,CONCAT(@unit,'-GA is Paid'),'Confirm that it\'s paid (for a bill/attachment)',0,'',1,NULL),
#					(@r_group_is_paid,CONCAT(@unit,'-RA is Paid'),'Ask if it\'s paid (for a bill/attachment)',0,'',1,NULL),
#################
				
				SET @role_type_id = NULL;
					
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
					(@product_id,NULL,@create_case_group_id,20,@role_type_id,@creator_bz_id,@timestamp),
					(@product_id,NULL,@can_edit_case_group_id,25,@role_type_id,@creator_bz_id,@timestamp),
					(@product_id,NULL,@can_edit_all_field_case_group_id,26,@role_type_id,@creator_bz_id,@timestamp),
					(@product_id,NULL,@can_edit_component_group_id,27,@role_type_id,@creator_bz_id,@timestamp),
					(@product_id,NULL,@can_see_cases_group_id,28,@role_type_id,@creator_bz_id,@timestamp),
					(@product_id,NULL,@all_r_flags_group_id,18,@role_type_id,@creator_bz_id,@timestamp),
					(@product_id,NULL,@all_g_flags_group_id,19,@role_type_id,@creator_bz_id,@timestamp),
					(@product_id,NULL,@list_visible_assignees_group_id,4,NULL,@creator_bz_id,@timestamp),
					(@product_id,NULL,@see_visible_assignees_group_id,5,NULL,@creator_bz_id,@timestamp),
					(@product_id,NULL,@active_stakeholder_group_id,29,NULL,@creator_bz_id,@timestamp),
					(@product_id,NULL,@unit_creator_group_id,1,NULL,@creator_bz_id,@timestamp)
					;
##################
# Once we fix the login performance issue, we will be able to re-create these groups.
#					(@product_id,NULL,@r_group_next_step,6,@role_type_id,@creator_bz_id,@timestamp),
#					(@product_id,NULL,@r_group_solution,8,@role_type_id,@creator_bz_id,@timestamp),
#					(@product_id,NULL,@r_group_budget,10,@role_type_id,@creator_bz_id,@timestamp),
#					(@product_id,NULL,@r_group_attachment,12,@role_type_id,@creator_bz_id,@timestamp),
#					(@product_id,NULL,@r_group_OK_to_pay,14,@role_type_id,@creator_bz_id,@timestamp),
#					(@product_id,NULL,@r_group_is_paid,16,@role_type_id,@creator_bz_id,@timestamp),
#					(@product_id,NULL,@g_group_next_step,7,@role_type_id,@creator_bz_id,@timestamp),
#					(@product_id,NULL,@g_group_solution,9,@role_type_id,@creator_bz_id,@timestamp),
#					(@product_id,NULL,@g_group_budget,11,@role_type_id,@creator_bz_id,@timestamp),
#					(@product_id,NULL,@g_group_attachment,13,@role_type_id,@creator_bz_id,@timestamp),
#					(@product_id,NULL,@g_group_OK_to_pay,15,@role_type_id,@creator_bz_id,@timestamp),
#					(@product_id,NULL,@g_group_is_paid,17,@role_type_id,@creator_bz_id,@timestamp),
#################
				INSERT  INTO `group_group_map`
					(`member_id`
					,`grantor_id`
					,`grant_type`
					) 
				##########################################################
				# Logic:
				# If you are a member of group_id XXX (ex: 1 / Admin) 
				# then you have the following permissions:
				# 	- 0: You are automatically a member of group ZZZ
				#	- 1: You can grant access to group ZZZ
				#	- 2: You can see users in group ZZZ
				##########################################################
					VALUES 
					# Admin group can grant membership to all
					(1,@create_case_group_id,1)
					,(1,@can_edit_case_group_id,1)
					,(1,@can_edit_all_field_case_group_id,1)
					,(1,@can_edit_component_group_id,1)
					,(1,@can_see_cases_group_id,1)
##################
# Once we fix the login performance issue, we will be able to re-create these groups.
#					,(1,@g_group_next_step,1)
#					,(1,@g_group_solution,1)
#					,(1,@g_group_budget,1)
#					,(1,@g_group_attachment,1)
#					,(1,@g_group_OK_to_pay,1)
#					,(1,@g_group_is_paid,1)
#					,(1,@r_group_next_step,1)
#					,(1,@r_group_solution,1)
#					,(1,@r_group_budget,1)
#					,(1,@r_group_attachment,1)
#					,(1,@r_group_OK_to_pay,1)
#					,(1,@r_group_is_paid,1)
#################
					,(1,@all_g_flags_group_id,1)
					,(1,@all_r_flags_group_id,1)
					,(1,@list_visible_assignees_group_id,1)
					,(1,@see_visible_assignees_group_id,1)
					,(1,@active_stakeholder_group_id,1)
					,(1,@unit_creator_group_id,1)
					# Visibility groups:
##################
# Once we fix the login performance issue, we will be able to re-create these groups.
#					,(@r_group_next_step,@g_group_next_step,2)
#					,(@r_group_solution,@g_group_solution,2)
#					,(@r_group_budget,@g_group_budget,2)
#					,(@r_group_attachment,@g_group_attachment,2)
#					,(@r_group_OK_to_pay,@g_group_OK_to_pay,2)
#					,(@r_group_is_paid,@g_group_is_paid,2)
#################
					,(@all_r_flags_group_id,@all_g_flags_group_id,2)
					,(@see_visible_assignees_group_id,@list_visible_assignees_group_id,2)
					,(@unit_creator_group_id,@unit_creator_group_id,2)
					;
					
				INSERT  INTO `group_control_map`
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
					;

		# We update the table 'ut_map_user_unit_details'
			UPDATE `ut_map_user_unit_details`
			SET
				`bz_unit_id` = @product_id
				,`can_decide_if_user_visible` = 1
				,`can_decide_if_user_can_see_visible` = 1
				,`can_create_any_sh` = 1
				,`can_approve_user_for_flags` = 1
				,`is_public_assignee` = 1
				,`is_see_visible_assignee` = 1
				,`is_flag_requestee` = 1
				,`is_flag_approver` = 1
				, `comment` = CONCAT(`comment`, '\r\n The user is a creator for the Demo unit-', @product_id)
			WHERE `bz_profile_id` = @creator_bz_id
			;
					
		
		# We prepare the permission for the user
		
				INSERT  INTO `ut_user_group_map_temp`
					(`user_id`
					,`group_id`
					,`isbless`
					,`grant_type`
					) 
					VALUES 
					# Creator (support.nobody@lmbhousing.com) can grant privileges to all the groups that we created
					(@creator_bz_id,@create_case_group_id,1,0),
					(@creator_bz_id,@can_edit_case_group_id,1,0),
					(@creator_bz_id,@can_edit_all_field_case_group_id,1,0),
					(@creator_bz_id,@can_edit_component_group_id,1,0),
					(@creator_bz_id,@can_see_cases_group_id,1,0),
##################
# Once we fix the login performance issue, we will be able to re-create these groups.
#					(@creator_bz_id,@g_group_next_step,1,0),
#					(@creator_bz_id,@r_group_next_step,1,0),
#					(@creator_bz_id,@g_group_solution,1,0),
#					(@creator_bz_id,@r_group_solution,1,0),
#					(@creator_bz_id,@g_group_budget,1,0),
#					(@creator_bz_id,@r_group_budget,1,0),
#					(@creator_bz_id,@g_group_attachment,1,0),
#					(@creator_bz_id,@r_group_attachment,1,0),
#					(@creator_bz_id,@g_group_OK_to_pay,1,0),
#					(@creator_bz_id,@r_group_OK_to_pay,1,0),
#					(@creator_bz_id,@g_group_is_paid,1,0),
#					(@creator_bz_id,@r_group_is_paid,1,0),
#################
					(@creator_bz_id,@all_g_flags_group_id,1,0),
					(@creator_bz_id,@all_r_flags_group_id,1,0),
					(@creator_bz_id,@list_visible_assignees_group_id,1,0),
					(@creator_bz_id,@see_visible_assignees_group_id,1,0),
					(@creator_bz_id,@active_stakeholder_group_id,1,0),
					(@creator_bz_id,@unit_creator_group_id,1,0),

					# Creator (support.nobody@lmbhousing.com) is a member of the following groups:
					(@creator_bz_id,@create_case_group_id,0,0),
					(@creator_bz_id,@can_edit_case_group_id,0,0),
					(@creator_bz_id,@can_edit_all_field_case_group_id,0,0),
					(@creator_bz_id,@can_edit_component_group_id,0,0),
					(@creator_bz_id,@can_see_cases_group_id,0,0),
##################
# Once we fix the login performance issue, we will be able to re-create these groups.
#					(@creator_bz_id,@g_group_next_step,0,0),
#					(@creator_bz_id,@r_group_next_step,0,0),
#					(@creator_bz_id,@g_group_solution,0,0),
#					(@creator_bz_id,@r_group_solution,0,0),
#					(@creator_bz_id,@g_group_budget,0,0),
#					(@creator_bz_id,@r_group_budget,0,0),
#					(@creator_bz_id,@g_group_attachment,0,0),
#					(@creator_bz_id,@r_group_attachment,0,0),
#					(@creator_bz_id,@g_group_OK_to_pay,0,0),
#					(@creator_bz_id,@r_group_OK_to_pay,0,0),
#					(@creator_bz_id,@g_group_is_paid,0,0),
#					(@creator_bz_id,@r_group_is_paid,0,0),
#################
					(@creator_bz_id,@all_g_flags_group_id,0,0),
					(@creator_bz_id,@all_r_flags_group_id,0,0),
					(@creator_bz_id,@list_visible_assignees_group_id,0,0),
					(@creator_bz_id,@see_visible_assignees_group_id,0,0),
					(@creator_bz_id,@active_stakeholder_group_id,0,0),
					(@creator_bz_id,@unit_creator_group_id,0,0);
					
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
					(NULL,CONCAT('Next_Step_',@unit),'Approval for the Next Step of the case.','','b',1,1,1,1,10,@g_group_next_step,@r_group_next_step);
				SET @flag_next_step = LAST_INSERT_ID();
				SET @flag_solution = (@flag_next_step+1);
				SET @flag_budget = (@flag_solution+1);
				SET @flag_attachment = (@flag_budget+1);
				SET @flag_ok_to_pay = (@flag_attachment+1);
				SET @flag_is_paid = (@flag_ok_to_pay+1);

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
					(@flag_solution,CONCAT('Solution_',@unit),'Approval for the Solution of this case.','','b',1,1,1,1,20,@all_g_flags_group_id,@all_r_flags_group_id)
					,(@flag_budget,CONCAT('Budget_',@unit),'Approval for the Budget for this case.','','b',1,1,1,1,30,@all_g_flags_group_id,@all_r_flags_group_id)
					,(@flag_attachment,CONCAT('Attachment_',@unit),'Approval for this Attachment.','','a',1,1,1,1,10,@all_g_flags_group_id,@all_r_flags_group_id)
					,(@flag_ok_to_pay,CONCAT('OK_to_pay_',@unit),'Approval to pay this bill.','','a',1,1,1,1,20,@all_g_flags_group_id,@all_r_flags_group_id)
					,(@flag_is_paid,CONCAT('is_paid_',@unit),'Confirm if this bill has been paid.','','a',1,1,1,1,30,@all_g_flags_group_id,@all_r_flags_group_id)
					;
				DELETE FROM `flaginclusions` WHERE `product_id` = @product_id;
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
					(@bz_user_id,'Bugzilla::Group',@create_case_group_id,'__create__',NULL,CONCAT(@unit,'-Can Create Cases'),@timestamp),
					(@bz_user_id,'Bugzilla::Group',@can_edit_case_group_id,'__create__',NULL,CONCAT(@unit,'-Can edit'),@timestamp),
					(@bz_user_id,'Bugzilla::Group',@can_edit_all_field_case_group_id,'__create__',NULL,CONCAT(@unit,'-Can edit all fields'),@timestamp),
					(@bz_user_id,'Bugzilla::Group',@can_edit_component_group_id,'__create__',NULL,CONCAT(@unit,'-Can edit components'),@timestamp),
					(@bz_user_id,'Bugzilla::Group',@can_see_cases_group_id,'__create__',NULL,CONCAT(@unit,'-Visible to all'),@timestamp),
##################
# Once we fix the login performance issue, we will be able to re-create these groups.
#					(@bz_user_id,'Bugzilla::Group',@g_group_next_step,'__create__',NULL,CONCAT(@unit,'-GA Next Step'),@timestamp),
#					(@bz_user_id,'Bugzilla::Group',@r_group_next_step,'__create__',NULL,CONCAT(@unit,'-RA Next Step'),@timestamp),
#					(@bz_user_id,'Bugzilla::Group',@g_group_solution,'__create__',NULL,CONCAT(@unit,'-GA Solution'),@timestamp),
#					(@bz_user_id,'Bugzilla::Group',@r_group_solution,'__create__',NULL,CONCAT(@unit,'-RA Solution'),@timestamp),
#					(@bz_user_id,'Bugzilla::Group',@g_group_budget,'__create__',NULL,CONCAT(@unit,'-GA Budget'),@timestamp),
#					(@bz_user_id,'Bugzilla::Group',@r_group_budget,'__create__',NULL,CONCAT(@unit,'-RA Budget'),@timestamp),
#					(@bz_user_id,'Bugzilla::Group',@g_group_attachment,'__create__',NULL,CONCAT(@unit,'-GA Attachment'),@timestamp),
#					(@bz_user_id,'Bugzilla::Group',@r_group_attachment,'__create__',NULL,CONCAT(@unit,'-RA Attachment'),@timestamp),
#					(@bz_user_id,'Bugzilla::Group',@g_group_OK_to_pay,'__create__',NULL,CONCAT(@unit,'-GA OK to Pay'),@timestamp),
#					(@bz_user_id,'Bugzilla::Group',@r_group_OK_to_pay,'__create__',NULL,CONCAT(@unit,'-RA OK to Pay'),@timestamp),
#					(@bz_user_id,'Bugzilla::Group',@g_group_is_paid,'__create__',NULL,CONCAT(@unit,'-GA is Paid'),@timestamp),
#					(@bz_user_id,'Bugzilla::Group',@r_group_is_paid,'__create__',NULL,CONCAT(@unit,'-RA is Paid'),@timestamp),
######################
					(@bz_user_id,'Bugzilla::Group',@all_g_flags_group_id,'__create__',NULL,CONCAT(@unit,'-Can approve all flags'),@timestamp),
					(@bz_user_id,'Bugzilla::Group',@all_r_flags_group_id,'__create__',NULL,CONCAT(@unit,'-Can be asked to approve'),@timestamp),
					(@bz_user_id,'Bugzilla::Group',@list_visible_assignees_group_id,'__create__',NULL,CONCAT(@unit,'-list stakeholder(s)'),@timestamp),
					(@bz_user_id,'Bugzilla::Group',@see_visible_assignees_group_id,'__create__',NULL,CONCAT(@unit,'-see stakeholder(s)'),@timestamp),
					(@bz_user_id,'Bugzilla::Group',@active_stakeholder_group_id,'__create__',NULL,CONCAT(@unit,'-Active stakeholder'),@timestamp),
					(@bz_user_id,'Bugzilla::Group',@unit_creator_group_id,'__create__',NULL,CONCAT(@unit,'-Unit Creators'),@timestamp);
				
		SET loops_products = (loops_products + 1);
		SET FOREIGN_KEY_CHECKS = 1;
		END WHILE;
	END$$
DELIMITER ;
CALL insert_products;


######################
#
# Now we insert the component/roles
#
######################

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE `components`;
TRUNCATE TABLE `series_categories`;
TRUNCATE TABLE `series`;

	/*Data for the table `components` */

	INSERT  INTO `components`(`id`,`name`,`product_id`,`initialowner`,`initialqacontact`,`description`,`isactive`) VALUES 
	(1,'Test stakeholder 1',1,1,1,'Stakholder 1 (ex: landlord), contact details, comments about how to contact the person for that unit.',1);

	/*Data for the table `series` */

	/*Data for the table `series_categories` */

	INSERT  INTO `series_categories`(`id`,`name`) VALUES 
	(2,'-All-'),
	(3,'Test_stakeholder_1'),
	(1,'Test_Unit_1_A');

###############################################################
# We do the component/roles insert in 2 batches:
#	- 1st batch of units
#		- There is a tenant for each unit.
#		- The creator is the tenant for the unit
#		- The creator is the occupant of the unit.
#	- All the batches after the 1st batch of unit
#		- The creator is the Landlord for the unit
#		- There are no tenant
#		- There are no occupant.
#
# This guarantees that 
#	- a Unee-T user is a tenant only once 
#	- a Unee-T user is an occupant in only one unit
###############################################################

# First batch of unit
# We need to define a few extra variables:
SET @landlord_counter = 0;
SET @iteration_thru_landlord = 0;
SET @agent_counter = 0;
SET @iteration_thru_agent = 0;
SET @contractor_counter = 0;
SET @iteration_thru_contractor = 0;
SET @mgt_cny_counter = 0;
SET @iteration_thru_mgt_cny = 0;

DELIMITER $$
	DROP PROCEDURE IF EXISTS insert_component$$
	CREATE PROCEDURE insert_component()
	BEGIN


# We have created (12 * @iteration_number_of_users * number_of_units_per_user) products
# The first batch of units are the 1 units that are created for each user
#
# A user will only be a tenant and an occupant in the same unit and in no other unit.
#
# For the first batch of unit
#	- The unit creator will be:
#		- The tenant
#		- The occupant
# For the all the batches of units after the first one
#	- The unit creator will be the landlord 
# 	- There will be NO Tenant
# 	- There will be NO occupant
#
# The first batch of unit starts at 2 (we exclude the demo unit)

	DECLARE loop_component INT DEFAULT 2;

# And ends at (12 * @iteration_number_of_users ) + 1

	WHILE loop_component <= (12 * @iteration_number_of_users + 1) DO

###########
#
# For futur reference, the code for the rest of the batch of products is
#DECLARE loop_component INT DEFAULT ((12 * @iteration_number_of_users) + 2);
#WHILE loop_component <= (SELECT MAX(id) FROM `products`) DO
#
###########

	SET FOREIGN_KEY_CHECKS = 0;
	SET @product_id = loop_component;
	SET @unit = (SELECT `name` FROM `products` WHERE `id`=@product_id);
	SET @unit_for_query = REPLACE(@unit,' ','%');


	# We now need to create the following 5 components for each of these products:
	#	- Tenant 1
	# 	- Landlord 2
	#	- Agent 5
	#	- Contractor 3
	#	- Management company 4
	#
	# To simplify this script, we will create only one user for each role EXCEPT for
	#	- Management Company
	#	- Contractor
	# 
	# When we created the unit we created 11 groups:
	#	- create_case_group_id
	#	- can_edit_case_group_id
	#	- can_edit_all_field_case_group_id
	#	- can_edit_component_group_id
	#	- can_see_cases_group_id
	#	- all_g_flags_group_id
	#	- all_r_flags_group_id
	#	- list_visible_assignees_group_id
	#	- see_visible_assignees_group_id
	#	- active_stakeholder_group_id
	#	- unit_creator_group_id
	#
	# We will also create the following 20 additional groups for these units:
	#	- show_to_tenant
	#	- are_users_tenant
	#	- see_users_tenant
	#	- show_to_landlord
	#	- are_users_landlord
	#	- see_users_landlord
	#	- show_to_agent
	#	- are_users_agent
	#	- see_users_agent
	#	- show_to_contractor
	#	- are_users_contractor
	#	- see_users_contractor
	#	- show_to_mgt_cny
	#	- are_users_mgt_cny
	#	- see_users_mgt_cny
	#	- show_to_occupant
	#	- are_users_occupant
	#	- see_users_occupant
	#	- are_users_invited_by
	#	- see_users_invited_by
	#
	
	# We first insert the Tenant Role:
	# The Tenant is the creator for the unit.
	SET @component_id_tenant = ((SELECT MAX(`id`) FROM `components`) + 1);
	
	SET @role_tenant_g_description = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=1);
	SET @creator_bz_id = (SELECT `created_by_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 1));
	SET @tenant_bz_id = @creator_bz_id;
	SET @creator_pub_name = (SELECT `realname` FROM `profiles` WHERE `userid` = @creator_bz_id);
	SET @creator_more = 'Placeholder for more information-Lorem ipsus dolorem';
	SET @creator_pub_info = CONCAT(@creator_pub_name,'-', @creator_more);
	
	SET @visibility_explanation_1 = 'Visible only to ';
	SET @visibility_explanation_2 = ' for this unit.';
	SET @role_tenant_pub_name = CONCAT(@component_id_tenant,'-', @unit, '-', @creator_pub_name,'-', @tenant_bz_id, '-Tenant');
	SET @role_tenant_more = @creator_more;
	SET @role_tenant_pub_info = @creator_pub_info;
	SET @tenant_role_desc = (CONCAT(@role_tenant_g_description, '\r\-',@role_tenant_pub_info));
	
	# We define the Tenant as the occupant:
	SET @occupant_bz_id = @tenant_bz_id;
	
	# We now get the bz_user_id and information for each of the other roles that we will create.
	
	# To do that we need to know:
		# The number of user we have created
		SET @total_users = (SELECT MAX(`userid`) FROM `profiles`);
		# The loop we are in
		SET @which_batch_of_user = LEAST(CEILING((@product_id-1)/(@iteration_number_of_users*12)), @iteration_number_of_users);
		# we also need to know which batch of product we are in too!
		SET @which_batch_of_product = CEIL((@product_id-1)/(12 * @number_of_units_per_user));

		# Landlord
			SET @component_id_landlord = (@component_id_tenant + 1);
			SET @role_landlord_g_description = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=2);
			
			# By convention, the Landlord user_id can only be one of the following bz_user_id:
				# 2 + (12*(@iteration_number_of_users-1))
				# OR
				# 3 + (12*(@iteration_number_of_users-1))
				# OR
				# 4 + (12*(@iteration_number_of_users-1))
			
			# How many possible LL do we have?
			SET @count_ll_batch = (@iteration_number_of_users * 3);
			
			# For this unit/creator, which LL loop is this?
			SET @landlord_loop_counter = CEILING(@creator_bz_id/@count_ll_batch);
			
			# For this unit/creator, the LL will be from which user batch?
			SET @user_batch_nber_for_ll = CEILING(@creator_bz_id/3-(@iteration_number_of_users*(@landlord_loop_counter-1)));

			# We have n landlord to choose from.
			# We are counting how many time we have gone through the loop.
			SET @iteration_thru_landlord = (@iteration_thru_landlord + 1);
			
			# If we have gone thru the 3 possible option for LL, we reset this to 1
			SET @iteration_thru_landlord = IF( @iteration_thru_landlord = 4
											, 1
											, @iteration_thru_landlord
											);
	
			SET @landlord_bz_id = IF(@iteration_thru_landlord = 1
										, (3 + ((@user_batch_nber_for_ll-1) * 12))
										,IF(@iteration_thru_landlord = 2
											,(4 + ((@user_batch_nber_for_ll-1) * 12))
											,(2 + ((@user_batch_nber_for_ll-1) * 12))
										)
									)
									;
									
			############
			# OBSOLETE
			#The below query works but is not optimal as it select a user which is different from the creator.
			#SET @landlord_bz_id = (IF(@creator_id = @total_users,2,(@creator_id-@total_users + (12 * @iteration_number_of_users) + 2)));
			###########


			# We get more information about the landlord for that unit.
			SET @role_landlord_pub_name = CONCAT(@component_id_landlord,'-', @unit, '-',(SELECT `realname` FROM `profiles` WHERE `userid` = @landlord_bz_id),'-', @landlord_bz_id,'-Landlord');
			SET @role_landlord_more = 'Placeholder for more information on Landlord-Lorem ipsus dolorem';
			SET @role_landlord_pub_info = CONCAT(@role_landlord_pub_name,'\r\n', @role_landlord_g_description,'\r\n',@role_landlord_more);
			
		# Agent
			SET @component_id_agent = (@component_id_landlord + 1);
			SET @role_agent_g_description = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 5);
		
			# By convention, the Agent user_id can only be one of the following bz_user_id:
				# 5 + (12*(@iteration_number_of_users-1))
				# OR
				# 6 + (12*(@iteration_number_of_users-1))

			# How many possible agents do we have?
			SET @count_agent_batch = (@iteration_number_of_users * 2);
			
			# For this unit/creator, which agent loop is this?
			SET @agent_loop_counter = CEILING(@creator_bz_id/@count_agent_batch);
			
			# For this unit/creator, the agent will be from which user batch?
			SET @user_batch_nber_for_agent = CEILING((@creator_bz_id/2)-(@iteration_number_of_users*(@agent_loop_counter-1)));

			# We have n agents to choose from.
			# We are counting how many time we have gone through the loop.
			SET @iteration_thru_agent = (@iteration_thru_agent + 1);
			
			# If we have gone thru the 2 possible option for agent, we reset this to 1
			SET @iteration_thru_agent = IF( @iteration_thru_agent = 3
											, 1
											, @iteration_thru_agent
											);
			
			SET @agent_bz_id = IF(@iteration_thru_agent = 1
									, (5 + ((@user_batch_nber_for_ll-1) * 12))
									, (6 + ((@user_batch_nber_for_ll-1) * 12))
									)
									;
									
			############
			# OBSOLETE
			#The below query works but is not optimal as it select a user which is different from the creator.
			#SET @agent_bz_id = (IF(@tenant_bz_id = @total_users,2,(@tenant_bz_id-@total_users + (12 * @iteration_number_of_users) + 2)));
			###########
			
			# We get more information about the agent for that unit.
			SET @role_agent_pub_name = CONCAT(@component_id_agent,'-', @unit, '-',(SELECT `realname` FROM `profiles` WHERE `userid` = @agent_bz_id),'-', @agent_bz_id,'-Agent');
			SET @role_agent_more = 'Placeholder for more information on agent-Lorem ipsus dolorem';
			SET @role_agent_pub_info = CONCAT(@role_agent_pub_name,'\r\n', @role_agent_g_description,'\r\n', @role_agent_more);
		
		# Contractor
			SET @component_id_contractor = (@component_id_agent + 1);
			SET @role_contractor_g_description = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=3);

			# By convention, 
				# The default contractor user_id is
				# 7 + (12*(@iteration_number_of_users-1))
				
				# the other contractor user_id can only be one of the following bz_user_id:
				# 8 + (12*(@iteration_number_of_users-1))
				# OR
				# 9 + (12*(@iteration_number_of_users-1))

			# How many possible contractor do we have?
			SET @count_contractor_batch = (@iteration_number_of_users * 1);
			
			# For this unit/creator, which contractor loop is this?
			SET @contractor_loop_counter = CEILING(@creator_bz_id/@count_contractor_batch);
			
			# For this unit/creator, the contractor will be from which user batch?
			SET @user_batch_nber_for_contractor = CEILING((@creator_bz_id/1)-(@iteration_number_of_users * (@contractor_loop_counter-1)));

			# We have n contractors to choose from.
			# We are counting how many time we have gone through the loop.
			SET @iteration_thru_contractor = (@iteration_thru_contractor + 1);
			
			# If we have gone thru the 1 possible option for contractor, we reset this to 1
			SET @iteration_thru_contractor = IF( @iteration_thru_contractor = 2
											, 1
											, @iteration_thru_contractor
											);
			
			# YES I know, it is possible to optimize this formula, I keep it like this to 
			#	- be consistant 
			#	- make it compatible if we need to have more than 1 option...
			SET @contractor_1_bz_id = IF(@iteration_thru_contractor = 1
									, (7 + ((@user_batch_nber_for_contractor-1) * 12))
									, (7 + ((@user_batch_nber_for_contractor-1) * 12))
									)
									;

				# We get more information about the Initial contact for the contractor for that unit.
				SET @role_contractor_pub_name = CONCAT( @component_id_contractor,'-', @unit, '-', (SELECT `realname` FROM `profiles` WHERE `userid` = @contractor_1_bz_id),'-',@contractor_1_bz_id,'-Contractor');
				SET @role_contractor_more = 'Placeholder for more information on Contractor-Lorem ipsus dolorem';
				SET @role_contractor_pub_info = CONCAT(@role_contractor_pub_name,'\r\n', @role_contractor_g_description,'\r\n', @role_contractor_more);

				# Other Employee for the Contractor Firm (These also need to go in the 'component_cc' table)
				SET @contractor_2_bz_id = (@contractor_1_bz_id + 1);
				SET @contractor_3_bz_id = (@contractor_1_bz_id + 2);
			
		# Management Company
			SET @component_id_mgt_cny = (@component_id_contractor + 1);
			SET @role_mgt_cny_g_description = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=4);
			
			# By convention, the Management Company user_id can only be one of the following bz_user_id:
				# The default Management Company user_id is
				# 13 + (12*(@iteration_number_of_users-1))
				
				# the other mgt_cny user_id can only be one of the following bz_user_id:
				# 11 + (12*(@iteration_number_of_users-1))
				# OR
				# 12 + (12*(@iteration_number_of_users-1))


			# How many possible mgt_cny do we have?
			SET @count_mgt_cny_batch = (@iteration_number_of_users * 1);
			
			# For this unit/creator, which mgt_cny loop is this?
			SET @mgt_cny_loop_counter = CEILING(@creator_bz_id/@count_mgt_cny_batch);
			
			# For this unit/creator, the mgt_cny will be from which user batch?
			SET @user_batch_nber_for_mgt_cny = CEILING((@creator_bz_id/1)-(@iteration_number_of_users * (@mgt_cny_loop_counter-1)));

			# We have n mgt_cny to choose from.
			# We are counting how many time we have gone through the loop.
			SET @iteration_thru_mgt_cny = (@iteration_thru_mgt_cny + 1);
			
			# If we have gone thru the 1 possible option for contractor, we reset this to 1
			SET @iteration_thru_mgt_cny = IF( @iteration_thru_mgt_cny = 2
											, 1
											, @iteration_thru_mgt_cny
											);
			
			# YES I know, it is possible to optimize this formula, I keep it like this to 
			#	- be consistant 
			#	- make it compatible if we need to have more than 1 option...
			SET @mgt_cny_1_bz_id = IF(@iteration_thru_mgt_cny = 1
									, (13 + ((@user_batch_nber_for_mgt_cny - 1) * 12))
									, (13 + ((@user_batch_nber_for_mgt_cny - 1) * 12))
									)
									;
					
				# We get more information about the Initial contact for the contractor for that unit.
				SET @role_mgt_cny_pub_name = CONCAT(@component_id_mgt_cny,'-', @unit, '-', (SELECT `realname` FROM `profiles` WHERE `userid` = @mgt_cny_1_bz_id),'-',@mgt_cny_1_bz_id,'-MgtCny');
				SET @role_mgt_cny_more = 'Placeholder for more information on Management Company-Lorem ipsus dolorem';
				SET @role_mgt_cny_pub_info = CONCAT(@role_mgt_cny_pub_name,'\r\n', @role_mgt_cny_g_description,'\r\n', @role_mgt_cny_more);
				
				# Other Employee for the Contractor Firm (These go in the 'component_cc' table)
				SET @mgt_cny_2_bz_id = (@mgt_cny_1_bz_id - 1);
				SET @mgt_cny_3_bz_id = (@mgt_cny_2_bz_id - 2);
				

				############
				# OBSOLETE
				# Initial contact (These go into the 'components' table)
				#SET @mgt_cny_1_bz_id = (IF(@contractor_3_bz_id = @total_users,2,(@contractor_3_bz_id-@total_users + (12 * @iteration_number_of_users) + 2)));
				#
				# Other Employee for the Contractor Firm (These go in the 'component_cc' table)
				#SET @mgt_cny_2_bz_id = (IF(@mgt_cny_1_bz_id = @total_users,2,(@mgt_cny_1_bz_id-@total_users + (12 * @iteration_number_of_users) + 2)));
				#SET @mgt_cny_3_bz_id = (IF(@mgt_cny_2_bz_id = @total_users,2,(@mgt_cny_2_bz_id-@total_users + (12 * @iteration_number_of_users) + 2)));
				############
			
	# We have everything, we can now create the rest of the components for the 1st batch of units.
	#	- Landlord
	#	- Agent
	#	- Contractor
	# 	- Mgt Cny

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
		(@component_id_tenant,@role_tenant_pub_name,@product_id,@tenant_bz_id,@tenant_bz_id,@tenant_role_desc,1)
		,(@component_id_landlord,@role_landlord_pub_name,@product_id,@landlord_bz_id,@landlord_bz_id,@role_landlord_pub_info,1)
		,(@component_id_agent,@role_agent_pub_name,@product_id,@agent_bz_id,@agent_bz_id,@role_agent_pub_info,1)
		,(@component_id_contractor,@role_contractor_pub_name,@product_id,@contractor_1_bz_id,@contractor_1_bz_id,@role_contractor_pub_info,1)
		,(@component_id_mgt_cny,@role_mgt_cny_pub_name,@product_id,@mgt_cny_1_bz_id,@mgt_cny_1_bz_id,@role_mgt_cny_pub_info,1)
		;

	# We update the table 'ut_map_user_unit_details'
		INSERT INTO `ut_map_user_unit_details`
			(`created`
			,`record_created_by`
			,`user_id`
			,`bz_profile_id`
			,`bz_unit_id`
			,`role_type_id`
			,`public_name`
			,`comment`
			)
			VALUES
			(NOW(), @creator_bz_id, @tenant_bz_id, @tenant_bz_id, @product_id, 1, @role_tenant_pub_name, 'Created with demo user creation script when we create the component')
			,(NOW(), @creator_bz_id, @landlord_bz_id, @landlord_bz_id, @product_id, 2, @role_landlord_pub_name, 'Created with demo user creation script when we create the component')
			,(NOW(), @creator_bz_id, @agent_bz_id, @agent_bz_id, @product_id, 5, @role_agent_pub_name, 'Created with demo user creation script when we create the component')
			,(NOW(), @creator_bz_id, @contractor_1_bz_id, @contractor_1_bz_id, @product_id, 3, @role_contractor_pub_name, 'Created with demo user creation script when we create the component')
			,(NOW(), @creator_bz_id, @contractor_2_bz_id, @contractor_2_bz_id, @product_id, 3, @role_contractor_pub_name, 'Created with demo user creation script when we create the component')
			,(NOW(), @creator_bz_id, @contractor_3_bz_id, @contractor_3_bz_id, @product_id, 3, @role_contractor_pub_name, 'Created with demo user creation script when we create the component')
			,(NOW(), @creator_bz_id, @mgt_cny_1_bz_id, @mgt_cny_1_bz_id, @product_id, 4, @role_mgt_cny_pub_name, 'Created with demo user creation script when we create the component')
			,(NOW(), @creator_bz_id, @mgt_cny_2_bz_id, @mgt_cny_2_bz_id, @product_id, 4,  @role_mgt_cny_pub_name, 'Created with demo user creation script when we create the component')
			,(NOW(), @creator_bz_id, @mgt_cny_3_bz_id, @mgt_cny_3_bz_id, @product_id, 4, @role_mgt_cny_pub_name, 'Created with demo user creation script when we create the component')
			;		
		
	INSERT INTO `component_cc`
		(`user_id`
		,`component_id`
		)
		VALUES
		(@contractor_2_bz_id, @component_id_contractor)
		,(@contractor_3_bz_id, @component_id_contractor)
		,(@mgt_cny_2_bz_id, @component_id_mgt_cny)
		,(@mgt_cny_3_bz_id, @component_id_mgt_cny)
		;
		
	# We now create the groups we need
		# For the tenant
			# Visibility group
			SET @group_id_show_to_tenant = ((SELECT MAX(`id`) FROM `groups`) + 1);
			SET @group_name_show_to_tenant = (CONCAT(@unit,'-',@component_id_tenant, '-Tenant'));
			SET @group_description_tenant = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 1),@visibility_explanation_2));
		
			# Is in tenant user Group
			SET @group_id_are_users_tenant = (@group_id_show_to_tenant + 1);
			SET @group_name_are_users_tenant = (CONCAT(@unit,'-',@component_id_tenant, '-List-Tenant'));
			SET @group_description_are_users_tenant = (CONCAT('list the tenant(s)', @unit));
			
			# Can See tenant user Group
			SET @group_id_see_users_tenant = (@group_id_are_users_tenant + 1);
			SET @group_name_see_users_tenant = (CONCAT(@unit,'-',@component_id_tenant,'-Can-see-Tenant'));
			SET @group_description_see_users_tenant = (CONCAT('See the list of tenant(s) for ', @unit));
	
		# For the Landlord
			# Visibility group 
			SET @group_id_show_to_landlord = (@group_id_see_users_tenant + 1);
			SET @group_name_show_to_landlord = (CONCAT(@unit,'-',@component_id_landlord,'-Landlord'));
			SET @group_description_show_to_landlord = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 2),@visibility_explanation_2));
			
			# Is in landlord user Group
			SET @group_id_are_users_landlord = (@group_id_show_to_landlord + 1);
			SET @group_name_are_users_landlord = (CONCAT(@unit,'-',@component_id_landlord,'-List-landlord'));
			SET @group_description_are_users_landlord = (CONCAT('list the landlord(s)', @unit));
			
			# Can See landlord user Group
			SET @group_id_see_users_landlord = (@group_id_are_users_landlord + 1);
			SET @group_name_see_users_landlord = (CONCAT(@unit,'-',@component_id_landlord,'-Can-see-lanldord'));
			SET @group_description_see_users_landlord = (CONCAT('See the list of lanldord(s) for ', @unit));
			
		# For the agent
			# Visibility group 
			SET @group_id_show_to_agent = (@group_id_see_users_landlord + 1);
			SET @group_name_show_to_agent = (CONCAT(@unit,'-',@component_id_agent,'-Agent'));
			SET @group_description_show_to_agent = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 5),@visibility_explanation_2));
			
			# Is in Agent user Group
			SET @group_id_are_users_agent = (@group_id_show_to_agent + 1);
			SET @group_name_are_users_agent = (CONCAT(@unit,'-',@component_id_agent,'-List-agent'));
			SET @group_description_are_users_agent = (CONCAT('list the agent(s)', @unit));
			
			# Can See Agent user Group
			SET @group_id_see_users_agent = (@group_id_are_users_agent + 1);
			SET @group_name_see_users_agent = (CONCAT(@unit,'-',@component_id_agent,'-Can-see-agent'));
			SET @group_description_see_users_agent = (CONCAT('See the list of agent(s) for ', @unit));
		
		# For the contractor
			# Visibility group 
			SET @group_id_show_to_contractor = (@group_id_see_users_agent + 1);
			SET @group_name_show_to_contractor = (CONCAT(@unit,'-',@component_id_contractor,'-Contractor-Employee'));
			SET @group_description_show_to_contractor = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 3),@visibility_explanation_2));
			
			# Is in contractor user Group
			SET @group_id_are_users_contractor = (@group_id_show_to_contractor + 1);
			SET @group_name_are_users_contractor = (CONCAT(@unit,'-',@component_id_contractor,'-List-contractor-employee'));
			SET @group_description_are_users_contractor = (CONCAT('list the contractor employee(s)', @unit));
			
			# Can See contractor user Group
			SET @group_id_see_users_contractor = (@group_id_are_users_contractor + 1);
			SET @group_name_see_users_contractor = (CONCAT(@unit,'-',@component_id_contractor,'-Can-see-contractor-employee'));
			SET @group_description_see_users_contractor = (CONCAT('See the list of contractor employee(s) for ', @unit));
			
		# For the Mgt Cny
			# Visibility group
			SET @group_id_show_to_mgt_cny = (@group_id_see_users_contractor + 1);
			SET @group_name_show_to_mgt_cny = (CONCAT(@unit,'-',@component_id_mgt_cny,'-Mgt-Cny-Employee'));
			SET @group_description_show_to_mgt_cny = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 4),@visibility_explanation_2));
			
			# Is in mgt cny user Group
			SET @group_id_are_users_mgt_cny = (@group_id_show_to_mgt_cny + 1);
			SET @group_name_are_users_mgt_cny = (CONCAT(@unit,'-',@component_id_mgt_cny,'-List-Mgt-Cny-Employee'));
			SET @group_description_are_users_mgt_cny = (CONCAT('list the Mgt Cny Employee(s)', @unit));
			
			# Can See mgt cny user Group
			SET @group_id_see_users_mgt_cny = (@group_id_are_users_mgt_cny + 1);
			SET @group_name_see_users_mgt_cny = (CONCAT(@unit,'-',@component_id_mgt_cny,'-Can-see-Mgt-Cny-Employee'));
			SET @group_description_see_users_mgt_cny = (CONCAT('See the list of Mgt Cny Employee(s) for ', @unit));
		
		# For the occupant
			# Visibility group
			SET @group_id_show_to_occupant = (@group_id_see_users_mgt_cny + 1);
			SET @group_name_show_to_occupant = (CONCAT(@unit,'-occupant'));
			SET @group_description_show_to_occupant = (CONCAT(@visibility_explanation_1,'Occupants'));
			
			# Is in contractor user Group
			SET @group_id_are_users_occupant = (@group_id_show_to_occupant + 1);
			SET @group_name_are_users_occupant = (CONCAT(@unit,'-List-occupant'));
			SET @group_description_are_users_occupant = (CONCAT('list-the-occupant(s)-', @unit));
			
			# Can See contractor user Group
			SET @group_id_see_users_occupant = (@group_id_are_users_occupant + 1);
			SET @group_name_see_users_occupant = (CONCAT(@unit,'-Can-see-occupant'));
			SET @group_description_see_users_occupant = (CONCAT('See the list of occupant(s) for ', @unit));
			
		# For the people invited by this user:
			# Is in invited_by user Group
			SET @group_id_are_users_invited_by = (@group_id_see_users_occupant + 1);
			SET @group_name_are_users_invited_by = (CONCAT(@unit,'-List-invited-by'));
			SET @group_description_are_users_invited_by = (CONCAT('list the invited_by(s)', @unit));
			
			# Can See users in invited_by user Group
			SET @group_id_see_users_invited_by = (@group_id_are_users_invited_by + 1);
			SET @group_name_see_users_invited_by = (CONCAT(@unit,'-Can-see-invited-by'));
			SET @group_description_see_users_invited_by = (CONCAT('See the list of invited_by(s) for ', @unit));

	# We have everything: we can create the groups we need!
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
			(@group_id_show_to_tenant,@group_name_show_to_tenant,@group_description_tenant,1,'',1,NULL)
			,(@group_id_are_users_tenant,@group_name_are_users_tenant,@group_description_are_users_tenant,0,'',1,NULL)
			,(@group_id_see_users_tenant,@group_name_see_users_tenant,@group_description_see_users_tenant,0,'',1,NULL)
			,(@group_id_show_to_landlord,@group_name_show_to_landlord,@group_description_show_to_landlord,1,'',1,NULL)
			,(@group_id_are_users_landlord,@group_name_are_users_landlord,@group_description_are_users_landlord,0,'',1,NULL)
			,(@group_id_see_users_landlord,@group_name_see_users_landlord,@group_description_see_users_landlord,0,'',1,NULL)
			,(@group_id_show_to_agent,@group_name_show_to_agent,@group_description_show_to_agent,1,'',1,NULL)
			,(@group_id_are_users_agent,@group_name_are_users_agent,@group_description_are_users_agent,0,'',1,NULL)
			,(@group_id_see_users_agent,@group_name_see_users_agent,@group_description_see_users_agent,0,'',1,NULL)
			,(@group_id_show_to_contractor,@group_name_show_to_contractor,@group_description_show_to_contractor,1,'',1,NULL)
			,(@group_id_are_users_contractor,@group_name_are_users_contractor,@group_description_are_users_contractor,0,'',1,NULL)
			,(@group_id_see_users_contractor,@group_name_see_users_contractor,@group_description_see_users_contractor,0,'',1,NULL)
			,(@group_id_show_to_mgt_cny,@group_name_show_to_mgt_cny,@group_description_show_to_mgt_cny,1,'',1,NULL)
			,(@group_id_are_users_mgt_cny,@group_name_are_users_mgt_cny,@group_description_are_users_mgt_cny,0,'',1,NULL)
			,(@group_id_see_users_mgt_cny,@group_name_see_users_mgt_cny,@group_description_see_users_mgt_cny,0,'',1,NULL)
			,(@group_id_show_to_occupant,@group_name_show_to_occupant,@group_description_show_to_occupant,1,'',1,NULL)
			,(@group_id_are_users_occupant,@group_name_are_users_occupant,@group_description_are_users_occupant,0,'',1,NULL)
			,(@group_id_see_users_occupant,@group_name_see_users_occupant,@group_description_see_users_occupant,0,'',1,NULL)
			,(@group_id_are_users_invited_by,@group_name_are_users_invited_by,@group_description_are_users_invited_by,0,'',1,NULL)
			,(@group_id_see_users_invited_by,@group_name_see_users_invited_by,@group_description_see_users_invited_by,0,'',1,NULL)
			;
	########################
	#
	#	This is not needed at this stage
	#
	#	SET @is_occupant = 0;
	#	SET @bz_user_id = 2;
	#	SET @user_creator_bz_user_id = 2;
	#	SET @user_is_public = 1;
	#	SET @user_can_see_public = 1; 
	#	SET @can_be_asked_to_approve = 1;
	#	SET @can_approve = 1;
	#	SET @can_create_same_stakeholder = 0;
	#	SET @can_create_any_stakeholder = 1;
	#	SET @can_approve_user_for_flag = 1;
	#	SET @can_decide_if_user_is_visible = 1;
	#	SET @can_decide_if_user_can_see_visible = 1;
	#	SET @login_name = (SELECT `login_name` FROM `profiles` WHERE `userid`=@bz_user_id);
	#	SET @stakeholder = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=@role_type_id);
	#	SET @stakeholder_g_description = (SELECT `bz_description` FROM `ut_role_types` WHERE `id_role_type`=@role_type_id);
	#	SET @visibility_explanation = CONCAT(@visibility_explanation_1,@stakeholder,@visibility_explanation_2);
	#
	########################
	

	# we capture the groups and products that we have created for future reference.
	
		SET @timestamp = NOW();
	
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
		# Tenant (1)
		(@product_id,@component_id,@group_id_show_to_tenant,2,1,@creator_bz_id,@timestamp)
		,(@product_id,@component_id,@group_id_are_users_tenant,22,1,@creator_bz_id,@timestamp)
		,(@product_id,@component_id,@group_id_see_users_tenant,5,1,@creator_bz_id,@timestamp)
		# Landlord (2)
		,(@product_id,@component_id,@group_id_show_to_landlord,2,2,@creator_bz_id,@timestamp)
		,(@product_id,@component_id,@group_id_are_users_landlord,22,2,@creator_bz_id,@timestamp)
		,(@product_id,@component_id,@group_id_see_users_landlord,5,2,@creator_bz_id,@timestamp)
		# Agent (5)
		,(@product_id,@component_id,@group_id_show_to_agent,2,5,@creator_bz_id,@timestamp)
		,(@product_id,@component_id,@group_id_are_users_agent,22,5,@creator_bz_id,@timestamp)
		,(@product_id,@component_id,@group_id_see_users_agent,5,5,@creator_bz_id,@timestamp)
		# contractor (3)
		,(@product_id,@component_id,@group_id_show_to_contractor,2,3,@creator_bz_id,@timestamp)
		,(@product_id,@component_id,@group_id_are_users_contractor,22,3,@creator_bz_id,@timestamp)
		,(@product_id,@component_id,@group_id_see_users_contractor,5,3,@creator_bz_id,@timestamp)
		# mgt_cny (4)
		,(@product_id,@component_id,@group_id_show_to_mgt_cny,2,4,@creator_bz_id,@timestamp)
		,(@product_id,@component_id,@group_id_are_users_mgt_cny,22,4,@creator_bz_id,@timestamp)
		,(@product_id,@component_id,@group_id_see_users_mgt_cny,5,4,@creator_bz_id,@timestamp)
		# occupant (#)
		,(@product_id,@component_id,@group_id_show_to_occupant,2,4,@creator_bz_id,@timestamp)
		,(@product_id,@component_id,@group_id_are_users_occupant,22,4,@creator_bz_id,@timestamp)
		,(@product_id,@component_id,@group_id_see_users_occupant,5,4,@creator_bz_id,@timestamp)
		# invited_by
		,(@product_id,@component_id,@group_id_are_users_invited_by,31,NULL,@creator_bz_id,@timestamp)
		,(@product_id,@component_id,@group_id_see_users_invited_by,32,NULL,@creator_bz_id,@timestamp)
		;

/*Data for the table `group_group_map` */

	INSERT  INTO `group_group_map`
		(`member_id`
		,`grantor_id`
		,`grant_type`
		) 
	##########################################################
	# Logic:
	# If you are a member of group_id XXX (ex: 1 / Admin) 
	# then you have the following permissions:
	# 	- 0: You are automatically a member of group ZZZ
	#	- 1: You can grant access to group ZZZ
	#	- 2: You can see users in group ZZZ
	##########################################################
		VALUES 
		# group to grant membership
		# Admin can grant membership to all.
		(1,@group_id_show_to_tenant,1)
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
		
		# Visibility groups
		,(@group_id_see_users_tenant,@group_id_are_users_tenant,2)
		,(@group_id_see_users_landlord,@group_id_are_users_landlord,2)
		,(@group_id_see_users_agent,@group_id_are_users_contractor,2)
		,(@group_id_see_users_mgt_cny,@group_id_are_users_mgt_cny,2)
		,(@group_id_see_users_occupant,@group_id_are_users_occupant,2)
		,(@group_id_see_users_invited_by,@group_id_are_users_invited_by,2)
		;

	INSERT  INTO `group_control_map`
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
		(@group_id_show_to_tenant,@product_id,0,2,0,0,0,0,0)
		,(@group_id_show_to_landlord,@product_id,0,2,0,0,0,0,0)
		,(@group_id_show_to_agent,@product_id,0,2,0,0,0,0,0)
		,(@group_id_show_to_contractor,@product_id,0,2,0,0,0,0,0)
		,(@group_id_show_to_mgt_cny,@product_id,0,2,0,0,0,0,0)
		,(@group_id_show_to_occupant,@product_id,0,2,0,0,0,0,0)
		;
	
	# We now assign the user permission for all the users we have created.
		# Groups created when we create the product
		# We need to ge these from the ut_product_table_based on the product_id!
		SET @create_case_group_id =  (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 20));
		SET @can_edit_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 25));
		SET @can_edit_all_field_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 26));
		SET @can_edit_component_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 27));
		SET @can_see_cases_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 28));
		SET @all_r_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 18));
		SET @all_g_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 19));
		SET @list_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 4));
		SET @see_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 5 AND `role_type_id` IS NULL));
		SET @active_stakeholder_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 29));
		SET @unit_creator_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 1));

	INSERT  INTO `ut_user_group_map_temp`
		(`user_id`
		,`group_id`
		,`isbless`
		,`grant_type`
		) 
		VALUES 
		# Methodology: we list all the possible groups and comment out the groups we do not need.
			
		# The Creator:
			# Can grant membership to:

				# Groups created when we create the product
				# This has been done, we we created the product, nothing to do here!
#				(@creator_bz_id, @create_case_group_id, 1, 0)
#				,(@creator_bz_id, @can_edit_case_group_id, 1, 0)
#				,(@creator_bz_id, @can_edit_all_field_case_group_id, 1, 0)
#				,(@creator_bz_id, @can_edit_component_group_id, 1, 0)
#				,(@creator_bz_id, @can_see_cases_group_id, 1, 0)
#				,(@creator_bz_id, @all_g_flags_group_id, 1, 0)
#				,(@creator_bz_id, @all_r_flags_group_id, 1, 0)
#				,(@creator_bz_id, @list_visible_assignees_group_id, 1, 0)
#				,(@creator_bz_id, @see_visible_assignees_group_id, 1, 0)
#				,(@creator_bz_id, @active_stakeholder_group_id, 1, 0)
#				,(@creator_bz_id, @unit_creator_group_id, 1, 0)

				
				# Groups created when we create the components
				# The creator can not grant any group membership just because he is the creator...
#				,(@creator_bz_id, @group_id_show_to_tenant, 1, 0)
#				,(@creator_bz_id, @group_id_are_users_tenant, 1, 0)
#				,(@creator_bz_id, @group_id_see_users_tenant, 1, 0)
#				,(@creator_bz_id, @group_id_show_to_landlord, 1, 0)
#				,(@creator_bz_id, @group_id_are_users_landlord, 1, 0)
#				,(@creator_bz_id, @group_id_see_users_landlord, 1, 0)
#				,(@creator_bz_id, @group_id_show_to_agent, 1, 0)
#				,(@creator_bz_id, @group_id_are_users_agent, 1, 0)
#				,(@creator_bz_id, @group_id_see_users_agent, 1, 0)
#				,(@creator_bz_id, @group_id_show_to_contractor, 1, 0)
#				,(@creator_bz_id, @group_id_are_users_contractor, 1, 0)
#				,(@creator_bz_id, @group_id_see_users_contractor, 1, 0)
#				,(@creator_bz_id, @group_id_show_to_mgt_cny, 1, 0)
#				,(@creator_bz_id, @group_id_are_users_mgt_cny, 1, 0)
#				,(@creator_bz_id, @group_id_see_users_mgt_cny, 1, 0)
#				,(@creator_bz_id, @group_id_show_to_occupant, 1, 0)
#				,(@creator_bz_id, @group_id_are_users_occupant, 1, 0)
#				,(@creator_bz_id, @group_id_see_users_occupant, 1, 0)
				(@creator_bz_id, @group_id_are_users_invited_by, 1, 0)
#				,(@creator_bz_id, @group_id_see_users_invited_by, 1, 0)
	
			# Is a member of:
				# Groups created when we create the product
				# This has been done, we we created the product, nothing to do here!
#				,(@creator_bz_id, @create_case_group_id, 0, 0)
#				,(@creator_bz_id, @can_edit_case_group_id, 0, 0)
#				,(@creator_bz_id, @can_edit_all_field_case_group_id, 0, 0)
#				,(@creator_bz_id, @can_edit_component_group_id, 0, 0)
#				,(@creator_bz_id, @can_see_cases_group_id, 0, 0)
#				,(@creator_bz_id, @all_g_flags_group_id, 0, 0)
#				,(@creator_bz_id, @all_r_flags_group_id, 0, 0)
#				,(@creator_bz_id, @list_visible_assignees_group_id, 0, 0)
#				,(@creator_bz_id, @see_visible_assignees_group_id, 0, 0)
#				,(@creator_bz_id, @active_stakeholder_group_id, 0, 0)
#				,(@creator_bz_id, @unit_creator_group_id, 0, 0)
			
				# Groups created when we create the components
				# The creator can see all the users except the contractors and Mgt Cny employees who are not public stakeholders.
#				,(@creator_bz_id, @group_id_show_to_tenant, 0, 0)
#				,(@creator_bz_id, @group_id_are_users_tenant, 0, 0)
				,(@creator_bz_id, @group_id_see_users_tenant, 0, 0)
#				,(@creator_bz_id, @group_id_show_to_landlord, 0, 0)
#				,(@creator_bz_id, @group_id_are_users_landlord, 0, 0)
				,(@creator_bz_id, @group_id_see_users_landlord, 0, 0)
#				,(@creator_bz_id, @group_id_show_to_agent, 0, 0)
#				,(@creator_bz_id, @group_id_are_users_agent, 0, 0)
				,(@creator_bz_id, @group_id_see_users_agent, 0, 0)
#				,(@creator_bz_id, @group_id_show_to_contractor, 0, 0)
#				,(@creator_bz_id, @group_id_are_users_contractor, 0, 0)
#				,(@creator_bz_id, @group_id_see_users_contractor, 0, 0)
#				,(@creator_bz_id, @group_id_show_to_mgt_cny, 0, 0)
#				,(@creator_bz_id, @group_id_are_users_mgt_cny, 0, 0)
#				,(@creator_bz_id, @group_id_see_users_mgt_cny, 0, 0)
#				,(@creator_bz_id, @group_id_show_to_occupant, 0, 0)
#				,(@creator_bz_id, @group_id_are_users_occupant, 0, 0)
				,(@creator_bz_id, @group_id_see_users_occupant, 0, 0)
#				,(@creator_bz_id, @group_id_are_users_invited_by, 0, 0)
#				,(@creator_bz_id, @group_id_see_users_invited_by, 0, 0)
		
		# The Tenant
			# Can grant membership to:
				# Groups created when we create the product
				,(@tenant_bz_id, @create_case_group_id, 1, 0)
				,(@tenant_bz_id, @can_edit_case_group_id, 1, 0)
				,(@tenant_bz_id, @can_edit_all_field_case_group_id, 1, 0)
				,(@tenant_bz_id, @can_edit_component_group_id, 1, 0)
				,(@tenant_bz_id, @can_see_cases_group_id, 1, 0)
				,(@tenant_bz_id, @all_g_flags_group_id, 1, 0)
				,(@tenant_bz_id, @all_r_flags_group_id, 1, 0)
				,(@tenant_bz_id, @list_visible_assignees_group_id, 1, 0)
				,(@tenant_bz_id, @see_visible_assignees_group_id, 1, 0)
				,(@tenant_bz_id, @active_stakeholder_group_id, 1, 0)
#				,(@tenant_bz_id, @unit_creator_group_id, 1, 0)
			
				# Groups created when we create the components
				,(@tenant_bz_id, @group_id_show_to_tenant, 1, 0)
				,(@tenant_bz_id, @group_id_are_users_tenant, 1, 0)
				,(@tenant_bz_id, @group_id_see_users_tenant, 1, 0)
#				,(@tenant_bz_id, @group_id_show_to_landlord, 1, 0)
#				,(@tenant_bz_id, @group_id_are_users_landlord, 1, 0)
#				,(@tenant_bz_id, @group_id_see_users_landlord, 1, 0)
#				,(@tenant_bz_id, @group_id_show_to_agent, 1, 0)
#				,(@tenant_bz_id, @group_id_are_users_agent, 1, 0)
#				,(@tenant_bz_id, @group_id_see_users_agent, 1, 0)
#				,(@tenant_bz_id, @group_id_show_to_contractor, 1, 0)
#				,(@tenant_bz_id, @group_id_are_users_contractor, 1, 0)
#				,(@tenant_bz_id, @group_id_see_users_contractor, 1, 0)
#				,(@tenant_bz_id, @group_id_show_to_mgt_cny, 1, 0)
#				,(@tenant_bz_id, @group_id_are_users_mgt_cny, 1, 0)
#				,(@tenant_bz_id, @group_id_see_users_mgt_cny, 1, 0)
#				,(@tenant_bz_id, @group_id_show_to_occupant, 1, 0)
#				,(@tenant_bz_id, @group_id_are_users_occupant, 1, 0)
#				,(@tenant_bz_id, @group_id_see_users_occupant, 1, 0)
#				,(@tenant_bz_id, @group_id_are_users_invited_by, 1, 0)
#				,(@tenant_bz_id, @group_id_see_users_invited_by, 1, 0)
	
			# Is a member of:
				# Groups created when we create the product
				,(@tenant_bz_id, @create_case_group_id, 0, 0)
				,(@tenant_bz_id, @can_edit_case_group_id, 0, 0)
#				,(@tenant_bz_id, @can_edit_all_field_case_group_id, 0, 0)
#				,(@tenant_bz_id, @can_edit_component_group_id, 0, 0)
				,(@tenant_bz_id, @can_see_cases_group_id, 0, 0)
				,(@tenant_bz_id, @all_g_flags_group_id, 0, 0)
				,(@tenant_bz_id, @all_r_flags_group_id, 0, 0)
				,(@tenant_bz_id, @list_visible_assignees_group_id, 0, 0)
				,(@tenant_bz_id, @see_visible_assignees_group_id, 0, 0)
				,(@tenant_bz_id, @active_stakeholder_group_id, 0, 0)
#				,(@tenant_bz_id, @unit_creator_group_id, 0, 0)
			
				# Groups created when we create the components
				,(@tenant_bz_id, @group_id_show_to_tenant, 0, 0)
				,(@tenant_bz_id, @group_id_are_users_tenant, 0, 0)
				,(@tenant_bz_id, @group_id_see_users_tenant, 0, 0)
#				,(@tenant_bz_id, @group_id_show_to_landlord, 0, 0)
#				,(@tenant_bz_id, @group_id_are_users_landlord, 0, 0)
#				,(@tenant_bz_id, @group_id_see_users_landlord, 0, 0)
#				,(@tenant_bz_id, @group_id_show_to_agent, 0, 0)
#				,(@tenant_bz_id, @group_id_are_users_agent, 0, 0)
#				,(@tenant_bz_id, @group_id_see_users_agent, 0, 0)
#				,(@tenant_bz_id, @group_id_show_to_contractor, 0, 0)
#				,(@tenant_bz_id, @group_id_are_users_contractor, 0, 0)
#				,(@tenant_bz_id, @group_id_see_users_contractor, 0, 0)
#				,(@tenant_bz_id, @group_id_show_to_mgt_cny, 0, 0)
#				,(@tenant_bz_id, @group_id_are_users_mgt_cny, 0, 0)
#				,(@tenant_bz_id, @group_id_see_users_mgt_cny, 0, 0)
#				,(@tenant_bz_id, @group_id_show_to_occupant, 0, 0)
#				,(@tenant_bz_id, @group_id_are_users_occupant, 0, 0)
#				,(@tenant_bz_id, @group_id_see_users_occupant, 0, 0)
				,(@tenant_bz_id, @group_id_are_users_invited_by, 0, 0)
#				,(@tenant_bz_id, @group_id_see_users_invited_by, 0, 0)

		# The Landlord
			#Can grant membership to:
				# Groups created when we create the product
				,(@landlord_bz_id, @create_case_group_id, 1, 0)
				,(@landlord_bz_id, @can_edit_case_group_id, 1, 0)
				,(@landlord_bz_id, @can_edit_all_field_case_group_id, 1, 0)
				,(@landlord_bz_id, @can_edit_component_group_id, 1, 0)
				,(@landlord_bz_id, @can_see_cases_group_id, 1, 0)
				,(@landlord_bz_id, @all_g_flags_group_id, 1, 0)
				,(@landlord_bz_id, @all_r_flags_group_id, 1, 0)
				,(@landlord_bz_id, @list_visible_assignees_group_id, 1, 0)
				,(@landlord_bz_id, @see_visible_assignees_group_id, 1, 0)
				,(@landlord_bz_id, @active_stakeholder_group_id, 1, 0)
#				,(@landlord_bz_id, @unit_creator_group_id, 1, 0)
			
				# Groups created when we create the components
#				,(@landlord_bz_id, @group_id_show_to_tenant, 1, 0)
#				,(@landlord_bz_id, @group_id_are_users_tenant, 1, 0)
#				,(@landlord_bz_id, @group_id_see_users_tenant, 1, 0)
				,(@landlord_bz_id, @group_id_show_to_landlord, 1, 0)
				,(@landlord_bz_id, @group_id_are_users_landlord, 1, 0)
				,(@landlord_bz_id, @group_id_see_users_landlord, 1, 0)
#				,(@landlord_bz_id, @group_id_show_to_agent, 1, 0)
#				,(@landlord_bz_id, @group_id_are_users_agent, 1, 0)
#				,(@landlord_bz_id, @group_id_see_users_agent, 1, 0)
#				,(@landlord_bz_id, @group_id_show_to_contractor, 1, 0)
#				,(@landlord_bz_id, @group_id_are_users_contractor, 1, 0)
#				,(@landlord_bz_id, @group_id_see_users_contractor, 1, 0)
#				,(@landlord_bz_id, @group_id_show_to_mgt_cny, 1, 0)
#				,(@landlord_bz_id, @group_id_are_users_mgt_cny, 1, 0)
#				,(@landlord_bz_id, @group_id_see_users_mgt_cny, 1, 0)
#				,(@landlord_bz_id, @group_id_show_to_occupant, 1, 0)
#				,(@landlord_bz_id, @group_id_are_users_occupant, 1, 0)
#				,(@landlord_bz_id, @group_id_see_users_occupant, 1, 0)
#				,(@landlord_bz_id, @group_id_are_users_invited_by, 1, 0)
#				,(@landlord_bz_id, @group_id_see_users_invited_by, 1, 0)
	
			# Is a member of:
				# Groups created when we create the product
				,(@landlord_bz_id, @create_case_group_id, 0, 0)
				,(@landlord_bz_id, @can_edit_case_group_id, 0, 0)
#				,(@landlord_bz_id, @can_edit_all_field_case_group_id, 0, 0)
#				,(@landlord_bz_id, @can_edit_component_group_id, 0, 0)
				,(@landlord_bz_id, @can_see_cases_group_id, 0, 0)
				,(@landlord_bz_id, @all_g_flags_group_id, 0, 0)
				,(@landlord_bz_id, @all_r_flags_group_id, 0, 0)
				,(@landlord_bz_id, @list_visible_assignees_group_id, 0, 0)
				,(@landlord_bz_id, @see_visible_assignees_group_id, 0, 0)
				,(@landlord_bz_id, @active_stakeholder_group_id, 0, 0)
#				,(@landlord_bz_id, @unit_creator_group_id, 0, 0)
			
				# Groups created when we create the components
#				,(@landlord_bz_id, @group_id_show_to_tenant, 0, 0)
#				,(@landlord_bz_id, @group_id_are_users_tenant, 0, 0)
#				,(@landlord_bz_id, @group_id_see_users_tenant, 0, 0)
				,(@landlord_bz_id, @group_id_show_to_landlord, 0, 0)
				,(@landlord_bz_id, @group_id_are_users_landlord, 0, 0)
				,(@landlord_bz_id, @group_id_see_users_landlord, 0, 0)
#				,(@landlord_bz_id, @group_id_show_to_agent, 0, 0)
#				,(@landlord_bz_id, @group_id_are_users_agent, 0, 0)
#				,(@landlord_bz_id, @group_id_see_users_agent, 0, 0)
#				,(@landlord_bz_id, @group_id_show_to_contractor, 0, 0)
#				,(@landlord_bz_id, @group_id_are_users_contractor, 0, 0)
#				,(@landlord_bz_id, @group_id_see_users_contractor, 0, 0)
#				,(@landlord_bz_id, @group_id_show_to_mgt_cny, 0, 0)
#				,(@landlord_bz_id, @group_id_are_users_mgt_cny, 0, 0)
#				,(@landlord_bz_id, @group_id_see_users_mgt_cny, 0, 0)
#				,(@landlord_bz_id, @group_id_show_to_occupant, 0, 0)
#				,(@landlord_bz_id, @group_id_are_users_occupant, 0, 0)
#				,(@landlord_bz_id, @group_id_see_users_occupant, 0, 0)
				,(@landlord_bz_id, @group_id_are_users_invited_by, 0, 0)
#				,(@landlord_bz_id, @group_id_see_users_invited_by, 0, 0)
		
		# The Agent
			# Can grant membership to:
				# Groups created when we create the product
				,(@agent_bz_id, @create_case_group_id, 1, 0)
				,(@agent_bz_id, @can_edit_case_group_id, 1, 0)
				,(@agent_bz_id, @can_edit_all_field_case_group_id, 1, 0)
				,(@agent_bz_id, @can_edit_component_group_id, 1, 0)
				,(@agent_bz_id, @can_see_cases_group_id, 1, 0)
				,(@agent_bz_id, @all_g_flags_group_id, 1, 0)
				,(@agent_bz_id, @all_r_flags_group_id, 1, 0)
				,(@agent_bz_id, @list_visible_assignees_group_id, 1, 0)
				,(@agent_bz_id, @see_visible_assignees_group_id, 1, 0)
				,(@agent_bz_id, @active_stakeholder_group_id, 1, 0)
#				,(@agent_bz_id, @unit_creator_group_id, 1, 0)
			
				# Groups created when we create the components
#				,(@agent_bz_id, @group_id_show_to_tenant, 1, 0)
#				,(@agent_bz_id, @group_id_are_users_tenant, 1, 0)
#				,(@agent_bz_id, @group_id_see_users_tenant, 1, 0)
#				,(@agent_bz_id, @group_id_show_to_landlord, 1, 0)
#				,(@agent_bz_id, @group_id_are_users_landlord, 1, 0)
#				,(@agent_bz_id, @group_id_see_users_landlord, 1, 0)
				,(@agent_bz_id, @group_id_show_to_agent, 1, 0)
				,(@agent_bz_id, @group_id_are_users_agent, 1, 0)
				,(@agent_bz_id, @group_id_see_users_agent, 1, 0)
#				,(@agent_bz_id, @group_id_show_to_contractor, 1, 0)
#				,(@agent_bz_id, @group_id_are_users_contractor, 1, 0)
#				,(@agent_bz_id, @group_id_see_users_contractor, 1, 0)
#				,(@agent_bz_id, @group_id_show_to_mgt_cny, 1, 0)
#				,(@agent_bz_id, @group_id_are_users_mgt_cny, 1, 0)
#				,(@agent_bz_id, @group_id_see_users_mgt_cny, 1, 0)
#				,(@agent_bz_id, @group_id_show_to_occupant, 1, 0)
#				,(@agent_bz_id, @group_id_are_users_occupant, 1, 0)
#				,(@agent_bz_id, @group_id_see_users_occupant, 1, 0)
#				,(@agent_bz_id, @group_id_are_users_invited_by, 1, 0)
#				,(@agent_bz_id, @group_id_see_users_invited_by, 1, 0)
	
			# Is a member of:
				# Groups created when we create the product
				,(@agent_bz_id, @create_case_group_id, 0, 0)
				,(@agent_bz_id, @can_edit_case_group_id, 0, 0)
#				,(@agent_bz_id, @can_edit_all_field_case_group_id, 0, 0)
#				,(@agent_bz_id, @can_edit_component_group_id, 0, 0)
				,(@agent_bz_id, @can_see_cases_group_id, 0, 0)
				,(@agent_bz_id, @all_g_flags_group_id, 0, 0)
				,(@agent_bz_id, @all_r_flags_group_id, 0, 0)
				,(@agent_bz_id, @list_visible_assignees_group_id, 0, 0)
				,(@agent_bz_id, @see_visible_assignees_group_id, 0, 0)
				,(@agent_bz_id, @active_stakeholder_group_id, 0, 0)
#				,(@agent_bz_id, @unit_creator_group_id, 0, 0)
			
				# Groups created when we create the components
#				,(@agent_bz_id, @group_id_show_to_tenant, 0, 0)
#				,(@agent_bz_id, @group_id_are_users_tenant, 0, 0)
#				,(@agent_bz_id, @group_id_see_users_tenant, 0, 0)
#				,(@agent_bz_id, @group_id_show_to_landlord, 0, 0)
#				,(@agent_bz_id, @group_id_are_users_landlord, 0, 0)
#				,(@agent_bz_id, @group_id_see_users_landlord, 0, 0)
				,(@agent_bz_id, @group_id_show_to_agent, 0, 0)
				,(@agent_bz_id, @group_id_are_users_agent, 0, 0)
				,(@agent_bz_id, @group_id_see_users_agent, 0, 0)
#				,(@agent_bz_id, @group_id_show_to_contractor, 0, 0)
#				,(@agent_bz_id, @group_id_are_users_contractor, 0, 0)
#				,(@agent_bz_id, @group_id_see_users_contractor, 0, 0)
#				,(@agent_bz_id, @group_id_show_to_mgt_cny, 0, 0)
#				,(@agent_bz_id, @group_id_are_users_mgt_cny, 0, 0)
#				,(@agent_bz_id, @group_id_see_users_mgt_cny, 0, 0)
#				,(@agent_bz_id, @group_id_show_to_occupant, 0, 0)
#				,(@agent_bz_id, @group_id_are_users_occupant, 0, 0)
#				,(@agent_bz_id, @group_id_see_users_occupant, 0, 0)
				,(@agent_bz_id, @group_id_are_users_invited_by, 0, 0)
#				,(@agent_bz_id, @group_id_see_users_invited_by, 0, 0)
		
		# The contractor and the contractor employees
			# The Main user (employee 1):
				# Can grant membership to:
					# Groups created when we create the product
					,(@contractor_1_bz_id, @create_case_group_id, 1, 0)
					,(@contractor_1_bz_id, @can_edit_case_group_id, 1, 0)
					,(@contractor_1_bz_id, @can_edit_all_field_case_group_id, 1, 0)
					,(@contractor_1_bz_id, @can_edit_component_group_id, 1, 0)
					,(@contractor_1_bz_id, @can_see_cases_group_id, 1, 0)
					,(@contractor_1_bz_id, @all_g_flags_group_id, 1, 0)
					,(@contractor_1_bz_id, @all_r_flags_group_id, 1, 0)
					,(@contractor_1_bz_id, @list_visible_assignees_group_id, 1, 0)
					,(@contractor_1_bz_id, @see_visible_assignees_group_id, 1, 0)
					,(@contractor_1_bz_id, @active_stakeholder_group_id, 1, 0)
#					,(@contractor_1_bz_id, @unit_creator_group_id, 1, 0)
				
					# Groups created when we create the components
#					,(@contractor_1_bz_id, @group_id_show_to_tenant, 1, 0)
#					,(@contractor_1_bz_id, @group_id_are_users_tenant, 1, 0)
#					,(@contractor_1_bz_id, @group_id_see_users_tenant, 1, 0)
#					,(@contractor_1_bz_id, @group_id_show_to_landlord, 1, 0)
#					,(@contractor_1_bz_id, @group_id_are_users_landlord, 1, 0)
#					,(@contractor_1_bz_id, @group_id_see_users_landlord, 1, 0)
#					,(@contractor_1_bz_id, @group_id_show_to_agent, 1, 0)
#					,(@contractor_1_bz_id, @group_id_are_users_agent, 1, 0)
#					,(@contractor_1_bz_id, @group_id_see_users_agent, 1, 0)
					,(@contractor_1_bz_id, @group_id_show_to_contractor, 1, 0)
					,(@contractor_1_bz_id, @group_id_are_users_contractor, 1, 0)
					,(@contractor_1_bz_id, @group_id_see_users_contractor, 1, 0)
#					,(@contractor_1_bz_id, @group_id_show_to_mgt_cny, 1, 0)
#					,(@contractor_1_bz_id, @group_id_are_users_mgt_cny, 1, 0)
#					,(@contractor_1_bz_id, @group_id_see_users_mgt_cny, 1, 0)
#					,(@contractor_1_bz_id, @group_id_show_to_occupant, 1, 0)
#					,(@contractor_1_bz_id, @group_id_are_users_occupant, 1, 0)
#					,(@contractor_1_bz_id, @group_id_see_users_occupant, 1, 0)
#					,(@contractor_1_bz_id, @group_id_are_users_invited_by, 1, 0)
#					,(@contractor_1_bz_id, @group_id_see_users_invited_by, 1, 0)
		
				# Is a member of:
					# Groups created when we create the product
					,(@contractor_1_bz_id, @create_case_group_id, 0, 0)
					,(@contractor_1_bz_id, @can_edit_case_group_id, 0, 0)
#					,(@contractor_1_bz_id, @can_edit_all_field_case_group_id, 0, 0)
#					,(@contractor_1_bz_id, @can_edit_component_group_id, 0, 0)
					,(@contractor_1_bz_id, @can_see_cases_group_id, 0, 0)
					,(@contractor_1_bz_id, @all_g_flags_group_id, 0, 0)
					,(@contractor_1_bz_id, @all_r_flags_group_id, 0, 0)
					,(@contractor_1_bz_id, @list_visible_assignees_group_id, 0, 0)
					,(@contractor_1_bz_id, @see_visible_assignees_group_id, 0, 0)
					,(@contractor_1_bz_id, @active_stakeholder_group_id, 0, 0)
#					,(@contractor_1_bz_id, @unit_creator_group_id, 0, 0)
				
					# Groups created when we create the components
#					,(@contractor_1_bz_id, @group_id_show_to_tenant, 0, 0)
#					,(@contractor_1_bz_id, @group_id_are_users_tenant, 0, 0)
#					,(@contractor_1_bz_id, @group_id_see_users_tenant, 0, 0)
#					,(@contractor_1_bz_id, @group_id_show_to_landlord, 0, 0)
#					,(@contractor_1_bz_id, @group_id_are_users_landlord, 0, 0)
#					,(@contractor_1_bz_id, @group_id_see_users_landlord, 0, 0)
#					,(@contractor_1_bz_id, @group_id_show_to_agent, 0, 0)
#					,(@contractor_1_bz_id, @group_id_are_users_agent, 0, 0)
#					,(@contractor_1_bz_id, @group_id_see_users_agent, 0, 0)
					,(@contractor_1_bz_id, @group_id_show_to_contractor, 0, 0)
					,(@contractor_1_bz_id, @group_id_are_users_contractor, 0, 0)
					,(@contractor_1_bz_id, @group_id_see_users_contractor, 0, 0)
#					,(@contractor_1_bz_id, @group_id_show_to_mgt_cny, 0, 0)
#					,(@contractor_1_bz_id, @group_id_are_users_mgt_cny, 0, 0)
#					,(@contractor_1_bz_id, @group_id_see_users_mgt_cny, 0, 0)
#					,(@contractor_1_bz_id, @group_id_show_to_occupant, 0, 0)
#					,(@contractor_1_bz_id, @group_id_are_users_occupant, 0, 0)
#					,(@contractor_1_bz_id, @group_id_see_users_occupant, 0, 0)
					,(@contractor_1_bz_id, @group_id_are_users_invited_by, 0, 0)
#					,(@contractor_1_bz_id, @group_id_see_users_invited_by, 0, 0)
					
			# Contractor Employee 2 (Visible only to Contractor-no rights to approve or ask for approval)
			
				# Can grant membership to:
					# Groups created when we create the product
#					,(@contractor_2_bz_id, @create_case_group_id, 1, 0)
#					,(@contractor_2_bz_id, @can_edit_case_group_id, 1, 0)
#					,(@contractor_2_bz_id, @can_edit_all_field_case_group_id, 1, 0)
#					,(@contractor_2_bz_id, @can_edit_component_group_id, 1, 0)
#					,(@contractor_2_bz_id, @can_see_cases_group_id, 1, 0)
#					,(@contractor_2_bz_id, @all_g_flags_group_id, 1, 0)
#					,(@contractor_2_bz_id, @all_r_flags_group_id, 1, 0)
#					,(@contractor_2_bz_id, @list_visible_assignees_group_id, 1, 0)
#					,(@contractor_2_bz_id, @see_visible_assignees_group_id, 1, 0)
#					,(@contractor_2_bz_id, @active_stakeholder_group_id, 1, 0)
#					,(@contractor_2_bz_id, @unit_creator_group_id, 1, 0)
				
					# Groups created when we create the components
#					,(@contractor_2_bz_id, @group_id_show_to_tenant, 1, 0)
#					,(@contractor_2_bz_id, @group_id_are_users_tenant, 1, 0)
#					,(@contractor_2_bz_id, @group_id_see_users_tenant, 1, 0)
#					,(@contractor_2_bz_id, @group_id_show_to_landlord, 1, 0)
#					,(@contractor_2_bz_id, @group_id_are_users_landlord, 1, 0)
#					,(@contractor_2_bz_id, @group_id_see_users_landlord, 1, 0)
#					,(@contractor_2_bz_id, @group_id_show_to_agent, 1, 0)
#					,(@contractor_2_bz_id, @group_id_are_users_agent, 1, 0)
#					,(@contractor_2_bz_id, @group_id_see_users_agent, 1, 0)
#					,(@contractor_2_bz_id, @group_id_show_to_contractor, 1, 0)
#					,(@contractor_2_bz_id, @group_id_are_users_contractor, 1, 0)
#					,(@contractor_2_bz_id, @group_id_see_users_contractor, 1, 0)
#					,(@contractor_2_bz_id, @group_id_show_to_mgt_cny, 1, 0)
#					,(@contractor_2_bz_id, @group_id_are_users_mgt_cny, 1, 0)
#					,(@contractor_2_bz_id, @group_id_see_users_mgt_cny, 1, 0)
#					,(@contractor_2_bz_id, @group_id_show_to_occupant, 1, 0)
#					,(@contractor_2_bz_id, @group_id_are_users_occupant, 1, 0)
#					,(@contractor_2_bz_id, @group_id_see_users_occupant, 1, 0)
#					,(@contractor_2_bz_id, @group_id_are_users_invited_by, 1, 0)
#					,(@contractor_2_bz_id, @group_id_see_users_invited_by, 1, 0)
		
				# Is a member of:
					# Groups created when we create the product
					,(@contractor_2_bz_id, @create_case_group_id, 0, 0)
					,(@contractor_2_bz_id, @can_edit_case_group_id, 0, 0)
#					,(@contractor_2_bz_id, @can_edit_all_field_case_group_id, 0, 0)
#					,(@contractor_2_bz_id, @can_edit_component_group_id, 0, 0)
#					,(@contractor_2_bz_id, @can_see_cases_group_id, 0, 0)
#					,(@contractor_2_bz_id, @all_g_flags_group_id, 0, 0)
					,(@contractor_2_bz_id, @all_r_flags_group_id, 0, 0)
#					,(@contractor_2_bz_id, @list_visible_assignees_group_id, 0, 0)
#					,(@contractor_2_bz_id, @see_visible_assignees_group_id, 0, 0)
#					,(@contractor_2_bz_id, @active_stakeholder_group_id, 0, 0)
#					,(@contractor_2_bz_id, @unit_creator_group_id, 0, 0)
				
					# Groups created when we create the components
#					,(@contractor_2_bz_id, @group_id_show_to_tenant, 0, 0)
#					,(@contractor_2_bz_id, @group_id_are_users_tenant, 0, 0)
#					,(@contractor_2_bz_id, @group_id_see_users_tenant, 0, 0)
#					,(@contractor_2_bz_id, @group_id_show_to_landlord, 0, 0)
#					,(@contractor_2_bz_id, @group_id_are_users_landlord, 0, 0)
#					,(@contractor_2_bz_id, @group_id_see_users_landlord, 0, 0)
#					,(@contractor_2_bz_id, @group_id_show_to_agent, 0, 0)
#					,(@contractor_2_bz_id, @group_id_are_users_agent, 0, 0)
#					,(@contractor_2_bz_id, @group_id_see_users_agent, 0, 0)
					,(@contractor_2_bz_id, @group_id_show_to_contractor, 0, 0)
					,(@contractor_2_bz_id, @group_id_are_users_contractor, 0, 0)
					,(@contractor_2_bz_id, @group_id_see_users_contractor, 0, 0)
#					,(@contractor_2_bz_id, @group_id_show_to_mgt_cny, 0, 0)
#					,(@contractor_2_bz_id, @group_id_are_users_mgt_cny, 0, 0)
#					,(@contractor_2_bz_id, @group_id_see_users_mgt_cny, 0, 0)
#					,(@contractor_2_bz_id, @group_id_show_to_occupant, 0, 0)
#					,(@contractor_2_bz_id, @group_id_are_users_occupant, 0, 0)
#					,(@contractor_2_bz_id, @group_id_see_users_occupant, 0, 0)
					,(@contractor_2_bz_id, @group_id_are_users_invited_by, 0, 0)
#					,(@contractor_2_bz_id, @group_id_see_users_invited_by, 0, 0)
			
			# Contractor Employee 3

				# Can grant membership to:
					# Groups created when we create the product
#					,(@contractor_3_bz_id, @create_case_group_id, 1, 0)
#					,(@contractor_3_bz_id, @can_edit_case_group_id, 1, 0)
#					,(@contractor_3_bz_id, @can_edit_all_field_case_group_id, 1, 0)
#					,(@contractor_3_bz_id, @can_edit_component_group_id, 1, 0)
#					,(@contractor_3_bz_id, @can_see_cases_group_id, 1, 0)
#					,(@contractor_3_bz_id, @all_g_flags_group_id, 1, 0)
#					,(@contractor_3_bz_id, @all_r_flags_group_id, 1, 0)
#					,(@contractor_3_bz_id, @list_visible_assignees_group_id, 1, 0)
#					,(@contractor_3_bz_id, @see_visible_assignees_group_id, 1, 0)
#					,(@contractor_3_bz_id, @active_stakeholder_group_id, 1, 0)
#					,(@contractor_3_bz_id, @unit_creator_group_id, 1, 0)
				
					# Groups created when we create the components
#					,(@contractor_3_bz_id, @group_id_show_to_tenant, 1, 0)
#					,(@contractor_3_bz_id, @group_id_are_users_tenant, 1, 0)
#					,(@contractor_3_bz_id, @group_id_see_users_tenant, 1, 0)
#					,(@contractor_3_bz_id, @group_id_show_to_landlord, 1, 0)
#					,(@contractor_3_bz_id, @group_id_are_users_landlord, 1, 0)
#					,(@contractor_3_bz_id, @group_id_see_users_landlord, 1, 0)
#					,(@contractor_3_bz_id, @group_id_show_to_agent, 1, 0)
#					,(@contractor_3_bz_id, @group_id_are_users_agent, 1, 0)
#					,(@contractor_3_bz_id, @group_id_see_users_agent, 1, 0)
#					,(@contractor_3_bz_id, @group_id_show_to_contractor, 1, 0)
#					,(@contractor_3_bz_id, @group_id_are_users_contractor, 1, 0)
#					,(@contractor_3_bz_id, @group_id_see_users_contractor, 1, 0)
#					,(@contractor_3_bz_id, @group_id_show_to_mgt_cny, 1, 0)
#					,(@contractor_3_bz_id, @group_id_are_users_mgt_cny, 1, 0)
#					,(@contractor_3_bz_id, @group_id_see_users_mgt_cny, 1, 0)
#					,(@contractor_3_bz_id, @group_id_show_to_occupant, 1, 0)
#					,(@contractor_3_bz_id, @group_id_are_users_occupant, 1, 0)
#					,(@contractor_3_bz_id, @group_id_see_users_occupant, 1, 0)
#					,(@contractor_3_bz_id, @group_id_are_users_invited_by, 1, 0)
#					,(@contractor_3_bz_id, @group_id_see_users_invited_by, 1, 0)
		
				# Is a member of:
					# Groups created when we create the product
					,(@contractor_3_bz_id, @create_case_group_id, 0, 0)
					,(@contractor_3_bz_id, @can_edit_case_group_id, 0, 0)
#					,(@contractor_3_bz_id, @can_edit_all_field_case_group_id, 0, 0)
#					,(@contractor_3_bz_id, @can_edit_component_group_id, 0, 0)
#					,(@contractor_3_bz_id, @can_see_cases_group_id, 0, 0)
#					,(@contractor_3_bz_id, @all_g_flags_group_id, 0, 0)
					,(@contractor_3_bz_id, @all_r_flags_group_id, 0, 0)
#					,(@contractor_3_bz_id, @list_visible_assignees_group_id, 0, 0)
#					,(@contractor_3_bz_id, @see_visible_assignees_group_id, 0, 0)
#					,(@contractor_3_bz_id, @active_stakeholder_group_id, 0, 0)
#					,(@contractor_3_bz_id, @unit_creator_group_id, 0, 0)
				
					# Groups created when we create the components
#					,(@contractor_3_bz_id, @group_id_show_to_tenant, 0, 0)
#					,(@contractor_3_bz_id, @group_id_are_users_tenant, 0, 0)
#					,(@contractor_3_bz_id, @group_id_see_users_tenant, 0, 0)
#					,(@contractor_3_bz_id, @group_id_show_to_landlord, 0, 0)
#					,(@contractor_3_bz_id, @group_id_are_users_landlord, 0, 0)
#					,(@contractor_3_bz_id, @group_id_see_users_landlord, 0, 0)
#					,(@contractor_3_bz_id, @group_id_show_to_agent, 0, 0)
#					,(@contractor_3_bz_id, @group_id_are_users_agent, 0, 0)
#					,(@contractor_3_bz_id, @group_id_see_users_agent, 0, 0)
					,(@contractor_3_bz_id, @group_id_show_to_contractor, 0, 0)
					,(@contractor_3_bz_id, @group_id_are_users_contractor, 0, 0)
					,(@contractor_3_bz_id, @group_id_see_users_contractor, 0, 0)
#					,(@contractor_3_bz_id, @group_id_show_to_mgt_cny, 0, 0)
#					,(@contractor_3_bz_id, @group_id_are_users_mgt_cny, 0, 0)
#					,(@contractor_3_bz_id, @group_id_see_users_mgt_cny, 0, 0)
#					,(@contractor_3_bz_id, @group_id_show_to_occupant, 0, 0)
#					,(@contractor_3_bz_id, @group_id_are_users_occupant, 0, 0)
#					,(@contractor_3_bz_id, @group_id_see_users_occupant, 0, 0)
					,(@contractor_3_bz_id, @group_id_are_users_invited_by, 0, 0)
#					,(@contractor_3_bz_id, @group_id_see_users_invited_by, 0, 0)
					
		# The mgt_cny and the mgt_cny employees
			# The Main user mgt_cny (Generic User):
				# Can grant membership to:
					# Groups created when we create the product
					,(@mgt_cny_1_bz_id, @create_case_group_id, 1, 0)
					,(@mgt_cny_1_bz_id, @can_edit_case_group_id, 1, 0)
					,(@mgt_cny_1_bz_id, @can_edit_all_field_case_group_id, 1, 0)
					,(@mgt_cny_1_bz_id, @can_edit_component_group_id, 1, 0)
					,(@mgt_cny_1_bz_id, @can_see_cases_group_id, 1, 0)
					,(@mgt_cny_1_bz_id, @all_g_flags_group_id, 1, 0)
					,(@mgt_cny_1_bz_id, @all_r_flags_group_id, 1, 0)
					,(@mgt_cny_1_bz_id, @list_visible_assignees_group_id, 1, 0)
					,(@mgt_cny_1_bz_id, @see_visible_assignees_group_id, 1, 0)
					,(@mgt_cny_1_bz_id, @active_stakeholder_group_id, 1, 0)
#					,(@mgt_cny_1_bz_id, @unit_creator_group_id, 1, 0)
				
					# Groups created when we create the components
#					,(@mgt_cny_1_bz_id, @group_id_show_to_tenant, 1, 0)
#					,(@mgt_cny_1_bz_id, @group_id_are_users_tenant, 1, 0)
#					,(@mgt_cny_1_bz_id, @group_id_see_users_tenant, 1, 0)
#					,(@mgt_cny_1_bz_id, @group_id_show_to_landlord, 1, 0)
#					,(@mgt_cny_1_bz_id, @group_id_are_users_landlord, 1, 0)
#					,(@mgt_cny_1_bz_id, @group_id_see_users_landlord, 1, 0)
#					,(@mgt_cny_1_bz_id, @group_id_show_to_agent, 1, 0)
#					,(@mgt_cny_1_bz_id, @group_id_are_users_agent, 1, 0)
#					,(@mgt_cny_1_bz_id, @group_id_see_users_agent, 1, 0)
					,(@mgt_cny_1_bz_id, @group_id_show_to_contractor, 1, 0)
					,(@mgt_cny_1_bz_id, @group_id_are_users_contractor, 1, 0)
					,(@mgt_cny_1_bz_id, @group_id_see_users_contractor, 1, 0)
#					,(@mgt_cny_1_bz_id, @group_id_show_to_mgt_cny, 1, 0)
#					,(@mgt_cny_1_bz_id, @group_id_are_users_mgt_cny, 1, 0)
#					,(@mgt_cny_1_bz_id, @group_id_see_users_mgt_cny, 1, 0)
#					,(@mgt_cny_1_bz_id, @group_id_show_to_occupant, 1, 0)
#					,(@mgt_cny_1_bz_id, @group_id_are_users_occupant, 1, 0)
#					,(@mgt_cny_1_bz_id, @group_id_see_users_occupant, 1, 0)
#					,(@mgt_cny_1_bz_id, @group_id_are_users_invited_by, 1, 0)
#					,(@mgt_cny_1_bz_id, @group_id_see_users_invited_by, 1, 0)
		
				# Is a member of:
					# Groups created when we create the product
					,(@mgt_cny_1_bz_id, @create_case_group_id, 0, 0)
					,(@mgt_cny_1_bz_id, @can_edit_case_group_id, 0, 0)
#					,(@mgt_cny_1_bz_id, @can_edit_all_field_case_group_id, 0, 0)
#					,(@mgt_cny_1_bz_id, @can_edit_component_group_id, 0, 0)
					,(@mgt_cny_1_bz_id, @can_see_cases_group_id, 0, 0)
					,(@mgt_cny_1_bz_id, @all_g_flags_group_id, 0, 0)
					,(@mgt_cny_1_bz_id, @all_r_flags_group_id, 0, 0)
					,(@mgt_cny_1_bz_id, @list_visible_assignees_group_id, 0, 0)
					,(@mgt_cny_1_bz_id, @see_visible_assignees_group_id, 0, 0)
					,(@mgt_cny_1_bz_id, @active_stakeholder_group_id, 0, 0)
#					,(@mgt_cny_1_bz_id, @unit_creator_group_id, 0, 0)
				
					# Groups created when we create the components
#					,(@mgt_cny_1_bz_id, @group_id_show_to_tenant, 0, 0)
#					,(@mgt_cny_1_bz_id, @group_id_are_users_tenant, 0, 0)
#					,(@mgt_cny_1_bz_id, @group_id_see_users_tenant, 0, 0)
#					,(@mgt_cny_1_bz_id, @group_id_show_to_landlord, 0, 0)
#					,(@mgt_cny_1_bz_id, @group_id_are_users_landlord, 0, 0)
#					,(@mgt_cny_1_bz_id, @group_id_see_users_landlord, 0, 0)
#					,(@mgt_cny_1_bz_id, @group_id_show_to_agent, 0, 0)
#					,(@mgt_cny_1_bz_id, @group_id_are_users_agent, 0, 0)
#					,(@mgt_cny_1_bz_id, @group_id_see_users_agent, 0, 0)
					,(@mgt_cny_1_bz_id, @group_id_show_to_contractor, 0, 0)
					,(@mgt_cny_1_bz_id, @group_id_are_users_contractor, 0, 0)
					,(@mgt_cny_1_bz_id, @group_id_see_users_contractor, 0, 0)
#					,(@mgt_cny_1_bz_id, @group_id_show_to_mgt_cny, 0, 0)
#					,(@mgt_cny_1_bz_id, @group_id_are_users_mgt_cny, 0, 0)
#					,(@mgt_cny_1_bz_id, @group_id_see_users_mgt_cny, 0, 0)
#					,(@mgt_cny_1_bz_id, @group_id_show_to_occupant, 0, 0)
#					,(@mgt_cny_1_bz_id, @group_id_are_users_occupant, 0, 0)
#					,(@mgt_cny_1_bz_id, @group_id_see_users_occupant, 0, 0)
					,(@mgt_cny_1_bz_id, @group_id_are_users_invited_by, 0, 0)
#					,(@mgt_cny_1_bz_id, @group_id_see_users_invited_by, 0, 0)
					
			# mgt_cny Employee 1 (Visible only to Contractor-no rights to approve or ask for approval)
			
				# Can grant membership to:
					# Groups created when we create the product
#					,(@mgt_cny_2_bz_id, @create_case_group_id, 1, 0)
#					,(@mgt_cny_2_bz_id, @can_edit_case_group_id, 1, 0)
#					,(@mgt_cny_2_bz_id, @can_edit_all_field_case_group_id, 1, 0)
#					,(@mgt_cny_2_bz_id, @can_edit_component_group_id, 1, 0)
#					,(@mgt_cny_2_bz_id, @can_see_cases_group_id, 1, 0)
#					,(@mgt_cny_2_bz_id, @all_g_flags_group_id, 1, 0)
#					,(@mgt_cny_2_bz_id, @all_r_flags_group_id, 1, 0)
#					,(@mgt_cny_2_bz_id, @list_visible_assignees_group_id, 1, 0)
#					,(@mgt_cny_2_bz_id, @see_visible_assignees_group_id, 1, 0)
#					,(@mgt_cny_2_bz_id, @active_stakeholder_group_id, 1, 0)
#					,(@mgt_cny_2_bz_id, @unit_creator_group_id, 1, 0)
				
					# Groups created when we create the components
#					,(@mgt_cny_2_bz_id, @group_id_show_to_tenant, 1, 0)
#					,(@mgt_cny_2_bz_id, @group_id_are_users_tenant, 1, 0)
#					,(@mgt_cny_2_bz_id, @group_id_see_users_tenant, 1, 0)
#					,(@mgt_cny_2_bz_id, @group_id_show_to_landlord, 1, 0)
#					,(@mgt_cny_2_bz_id, @group_id_are_users_landlord, 1, 0)
#					,(@mgt_cny_2_bz_id, @group_id_see_users_landlord, 1, 0)
#					,(@mgt_cny_2_bz_id, @group_id_show_to_agent, 1, 0)
#					,(@mgt_cny_2_bz_id, @group_id_are_users_agent, 1, 0)
#					,(@mgt_cny_2_bz_id, @group_id_see_users_agent, 1, 0)
#					,(@mgt_cny_2_bz_id, @group_id_show_to_contractor, 1, 0)
#					,(@mgt_cny_2_bz_id, @group_id_are_users_contractor, 1, 0)
#					,(@mgt_cny_2_bz_id, @group_id_see_users_contractor, 1, 0)
#					,(@mgt_cny_2_bz_id, @group_id_show_to_mgt_cny, 1, 0)
#					,(@mgt_cny_2_bz_id, @group_id_are_users_mgt_cny, 1, 0)
#					,(@mgt_cny_2_bz_id, @group_id_see_users_mgt_cny, 1, 0)
#					,(@mgt_cny_2_bz_id, @group_id_show_to_occupant, 1, 0)
#					,(@mgt_cny_2_bz_id, @group_id_are_users_occupant, 1, 0)
#					,(@mgt_cny_2_bz_id, @group_id_see_users_occupant, 1, 0)
#					,(@mgt_cny_2_bz_id, @group_id_are_users_invited_by, 1, 0)
#					,(@mgt_cny_2_bz_id, @group_id_see_users_invited_by, 1, 0)
		
				# Is a member of:
					# Groups created when we create the product
					,(@mgt_cny_2_bz_id, @create_case_group_id, 0, 0)
					,(@mgt_cny_2_bz_id, @can_edit_case_group_id, 0, 0)
#					,(@mgt_cny_2_bz_id, @can_edit_all_field_case_group_id, 0, 0)
#					,(@mgt_cny_2_bz_id, @can_edit_component_group_id, 0, 0)
#					,(@mgt_cny_2_bz_id, @can_see_cases_group_id, 0, 0)
#					,(@mgt_cny_2_bz_id, @all_g_flags_group_id, 0, 0)
					,(@mgt_cny_2_bz_id, @all_r_flags_group_id, 0, 0)
#					,(@mgt_cny_2_bz_id, @list_visible_assignees_group_id, 0, 0)
#					,(@mgt_cny_2_bz_id, @see_visible_assignees_group_id, 0, 0)
#					,(@mgt_cny_2_bz_id, @active_stakeholder_group_id, 0, 0)
#					,(@mgt_cny_2_bz_id, @unit_creator_group_id, 0, 0)
				
					# Groups created when we create the components
#					,(@mgt_cny_2_bz_id, @group_id_show_to_tenant, 0, 0)
#					,(@mgt_cny_2_bz_id, @group_id_are_users_tenant, 0, 0)
#					,(@mgt_cny_2_bz_id, @group_id_see_users_tenant, 0, 0)
#					,(@mgt_cny_2_bz_id, @group_id_show_to_landlord, 0, 0)
#					,(@mgt_cny_2_bz_id, @group_id_are_users_landlord, 0, 0)
#					,(@mgt_cny_2_bz_id, @group_id_see_users_landlord, 0, 0)
#					,(@mgt_cny_2_bz_id, @group_id_show_to_agent, 0, 0)
#					,(@mgt_cny_2_bz_id, @group_id_are_users_agent, 0, 0)
#					,(@mgt_cny_2_bz_id, @group_id_see_users_agent, 0, 0)
					,(@mgt_cny_2_bz_id, @group_id_show_to_contractor, 0, 0)
					,(@mgt_cny_2_bz_id, @group_id_are_users_contractor, 0, 0)
					,(@mgt_cny_2_bz_id, @group_id_see_users_contractor, 0, 0)
#					,(@mgt_cny_2_bz_id, @group_id_show_to_mgt_cny, 0, 0)
#					,(@mgt_cny_2_bz_id, @group_id_are_users_mgt_cny, 0, 0)
#					,(@mgt_cny_2_bz_id, @group_id_see_users_mgt_cny, 0, 0)
#					,(@mgt_cny_2_bz_id, @group_id_show_to_occupant, 0, 0)
#					,(@mgt_cny_2_bz_id, @group_id_are_users_occupant, 0, 0)
#					,(@mgt_cny_2_bz_id, @group_id_see_users_occupant, 0, 0)
					,(@mgt_cny_2_bz_id, @group_id_are_users_invited_by, 0, 0)
#					,(@mgt_cny_2_bz_id, @group_id_see_users_invited_by, 0, 0)
			
			# mgt_cny Employee 2

				# Can grant membership to:
					# Groups created when we create the product
#					,(@mgt_cny_3_bz_id, @create_case_group_id, 1, 0)
#					,(@mgt_cny_3_bz_id, @can_edit_case_group_id, 1, 0)
#					,(@mgt_cny_3_bz_id, @can_edit_all_field_case_group_id, 1, 0)
#					,(@mgt_cny_3_bz_id, @can_edit_component_group_id, 1, 0)
#					,(@mgt_cny_3_bz_id, @can_see_cases_group_id, 1, 0)
#					,(@mgt_cny_3_bz_id, @all_g_flags_group_id, 1, 0)
#					,(@mgt_cny_3_bz_id, @all_r_flags_group_id, 1, 0)
#					,(@mgt_cny_3_bz_id, @list_visible_assignees_group_id, 1, 0)
#					,(@mgt_cny_3_bz_id, @see_visible_assignees_group_id, 1, 0)
#					,(@mgt_cny_3_bz_id, @active_stakeholder_group_id, 1, 0)
#					,(@mgt_cny_3_bz_id, @unit_creator_group_id, 1, 0)
				
					# Groups created when we create the components
#					,(@mgt_cny_3_bz_id, @group_id_show_to_tenant, 1, 0)
#					,(@mgt_cny_3_bz_id, @group_id_are_users_tenant, 1, 0)
#					,(@mgt_cny_3_bz_id, @group_id_see_users_tenant, 1, 0)
#					,(@mgt_cny_3_bz_id, @group_id_show_to_landlord, 1, 0)
#					,(@mgt_cny_3_bz_id, @group_id_are_users_landlord, 1, 0)
#					,(@mgt_cny_3_bz_id, @group_id_see_users_landlord, 1, 0)
#					,(@mgt_cny_3_bz_id, @group_id_show_to_agent, 1, 0)
#					,(@mgt_cny_3_bz_id, @group_id_are_users_agent, 1, 0)
#					,(@mgt_cny_3_bz_id, @group_id_see_users_agent, 1, 0)
#					,(@mgt_cny_3_bz_id, @group_id_show_to_contractor, 1, 0)
#					,(@mgt_cny_3_bz_id, @group_id_are_users_contractor, 1, 0)
#					,(@mgt_cny_3_bz_id, @group_id_see_users_contractor, 1, 0)
#					,(@mgt_cny_3_bz_id, @group_id_show_to_mgt_cny, 1, 0)
#					,(@mgt_cny_3_bz_id, @group_id_are_users_mgt_cny, 1, 0)
#					,(@mgt_cny_3_bz_id, @group_id_see_users_mgt_cny, 1, 0)
#					,(@mgt_cny_3_bz_id, @group_id_show_to_occupant, 1, 0)
#					,(@mgt_cny_3_bz_id, @group_id_are_users_occupant, 1, 0)
#					,(@mgt_cny_3_bz_id, @group_id_see_users_occupant, 1, 0)
#					,(@mgt_cny_3_bz_id, @group_id_are_users_invited_by, 1, 0)
#					,(@mgt_cny_3_bz_id, @group_id_see_users_invited_by, 1, 0)
		
				# Is a member of:
					# Groups created when we create the product
					,(@mgt_cny_3_bz_id, @create_case_group_id, 0, 0)
					,(@mgt_cny_3_bz_id, @can_edit_case_group_id, 0, 0)
#					,(@mgt_cny_3_bz_id, @can_edit_all_field_case_group_id, 0, 0)
#					,(@mgt_cny_3_bz_id, @can_edit_component_group_id, 0, 0)
#					,(@mgt_cny_3_bz_id, @can_see_cases_group_id, 0, 0)
#					,(@mgt_cny_3_bz_id, @all_g_flags_group_id, 0, 0)
					,(@mgt_cny_3_bz_id, @all_r_flags_group_id, 0, 0)
#					,(@mgt_cny_3_bz_id, @list_visible_assignees_group_id, 0, 0)
#					,(@mgt_cny_3_bz_id, @see_visible_assignees_group_id, 0, 0)
#					,(@mgt_cny_3_bz_id, @active_stakeholder_group_id, 0, 0)
#					,(@mgt_cny_3_bz_id, @unit_creator_group_id, 0, 0)
				
					# Groups created when we create the components
#					,(@mgt_cny_3_bz_id, @group_id_show_to_tenant, 0, 0)
#					,(@mgt_cny_3_bz_id, @group_id_are_users_tenant, 0, 0)
#					,(@mgt_cny_3_bz_id, @group_id_see_users_tenant, 0, 0)
#					,(@mgt_cny_3_bz_id, @group_id_show_to_landlord, 0, 0)
#					,(@mgt_cny_3_bz_id, @group_id_are_users_landlord, 0, 0)
#					,(@mgt_cny_3_bz_id, @group_id_see_users_landlord, 0, 0)
#					,(@mgt_cny_3_bz_id, @group_id_show_to_agent, 0, 0)
#					,(@mgt_cny_3_bz_id, @group_id_are_users_agent, 0, 0)
#					,(@mgt_cny_3_bz_id, @group_id_see_users_agent, 0, 0)
					,(@mgt_cny_3_bz_id, @group_id_show_to_contractor, 0, 0)
					,(@mgt_cny_3_bz_id, @group_id_are_users_contractor, 0, 0)
					,(@mgt_cny_3_bz_id, @group_id_see_users_contractor, 0, 0)
#					,(@mgt_cny_3_bz_id, @group_id_show_to_mgt_cny, 0, 0)
#					,(@mgt_cny_3_bz_id, @group_id_are_users_mgt_cny, 0, 0)
#					,(@mgt_cny_3_bz_id, @group_id_see_users_mgt_cny, 0, 0)
#					,(@mgt_cny_3_bz_id, @group_id_show_to_occupant, 0, 0)
#					,(@mgt_cny_3_bz_id, @group_id_are_users_occupant, 0, 0)
#					,(@mgt_cny_3_bz_id, @group_id_see_users_occupant, 0, 0)
					,(@mgt_cny_3_bz_id, @group_id_are_users_invited_by, 0, 0)
#					,(@mgt_cny_3_bz_id, @group_id_see_users_invited_by, 0, 0)

		# The occupants
			# Can grant membership to:
				# Groups created when we create the product
				,(@occupant_bz_id, @create_case_group_id, 1, 0)
				,(@occupant_bz_id, @can_edit_case_group_id, 1, 0)
				,(@occupant_bz_id, @can_edit_all_field_case_group_id, 1, 0)
				,(@occupant_bz_id, @can_edit_component_group_id, 1, 0)
				,(@occupant_bz_id, @can_see_cases_group_id, 1, 0)
				,(@occupant_bz_id, @all_g_flags_group_id, 1, 0)
				,(@occupant_bz_id, @all_r_flags_group_id, 1, 0)
				,(@occupant_bz_id, @list_visible_assignees_group_id, 1, 0)
				,(@occupant_bz_id, @see_visible_assignees_group_id, 1, 0)
				,(@occupant_bz_id, @active_stakeholder_group_id, 1, 0)
#				,(@occupant_bz_id, @unit_creator_group_id, 1, 0)
			
				# Groups created when we create the components
#				,(@occupant_bz_id, @group_id_show_to_tenant, 1, 0)
#				,(@occupant_bz_id, @group_id_are_users_tenant, 1, 0)
#				,(@occupant_bz_id, @group_id_see_users_tenant, 1, 0)
#				,(@occupant_bz_id, @group_id_show_to_landlord, 1, 0)
#				,(@occupant_bz_id, @group_id_are_users_landlord, 1, 0)
#				,(@occupant_bz_id, @group_id_see_users_landlord, 1, 0)
#				,(@occupant_bz_id, @group_id_show_to_agent, 1, 0)
#				,(@occupant_bz_id, @group_id_are_users_agent, 1, 0)
#				,(@occupant_bz_id, @group_id_see_users_agent, 1, 0)
#				,(@occupant_bz_id, @group_id_show_to_contractor, 1, 0)
#				,(@occupant_bz_id, @group_id_are_users_contractor, 1, 0)
#				,(@occupant_bz_id, @group_id_see_users_contractor, 1, 0)
#				,(@occupant_bz_id, @group_id_show_to_mgt_cny, 1, 0)
#				,(@occupant_bz_id, @group_id_are_users_mgt_cny, 1, 0)
#				,(@occupant_bz_id, @group_id_see_users_mgt_cny, 1, 0)
				,(@occupant_bz_id, @group_id_show_to_occupant, 1, 0)
				,(@occupant_bz_id, @group_id_are_users_occupant, 1, 0)
				,(@occupant_bz_id, @group_id_see_users_occupant, 1, 0)
#				,(@occupant_bz_id, @group_id_are_users_invited_by, 1, 0)
#				,(@occupant_bz_id, @group_id_see_users_invited_by, 1, 0)
	
			# Is a member of:
				# Groups created when we create the product
				,(@occupant_bz_id, @create_case_group_id, 0, 0)
				,(@occupant_bz_id, @can_edit_case_group_id, 0, 0)
#				,(@occupant_bz_id, @can_edit_all_field_case_group_id, 0, 0)
#				,(@occupant_bz_id, @can_edit_component_group_id, 0, 0)
				,(@occupant_bz_id, @can_see_cases_group_id, 0, 0)
				,(@occupant_bz_id, @all_g_flags_group_id, 0, 0)
				,(@occupant_bz_id, @all_r_flags_group_id, 0, 0)
				,(@occupant_bz_id, @list_visible_assignees_group_id, 0, 0)
				,(@occupant_bz_id, @see_visible_assignees_group_id, 0, 0)
				,(@occupant_bz_id, @active_stakeholder_group_id, 0, 0)
#				,(@occupant_bz_id, @unit_creator_group_id, 0, 0)
			
				# Groups created when we create the components
#				,(@occupant_bz_id, @group_id_show_to_tenant, 0, 0)
#				,(@occupant_bz_id, @group_id_are_users_tenant, 0, 0)
#				,(@occupant_bz_id, @group_id_see_users_tenant, 0, 0)
#				,(@occupant_bz_id, @group_id_show_to_landlord, 0, 0)
#				,(@occupant_bz_id, @group_id_are_users_landlord, 0, 0)
#				,(@occupant_bz_id, @group_id_see_users_landlord, 0, 0)
#				,(@occupant_bz_id, @group_id_show_to_agent, 0, 0)
#				,(@occupant_bz_id, @group_id_are_users_agent, 0, 0)
#				,(@occupant_bz_id, @group_id_see_users_agent, 0, 0)
#				,(@occupant_bz_id, @group_id_show_to_contractor, 0, 0)
#				,(@occupant_bz_id, @group_id_are_users_contractor, 0, 0)
#				,(@occupant_bz_id, @group_id_see_users_contractor, 0, 0)
#				,(@occupant_bz_id, @group_id_show_to_mgt_cny, 0, 0)
#				,(@occupant_bz_id, @group_id_are_users_mgt_cny, 0, 0)
#				,(@occupant_bz_id, @group_id_see_users_mgt_cny, 0, 0)
				,(@occupant_bz_id, @group_id_show_to_occupant, 0, 0)
				,(@occupant_bz_id, @group_id_are_users_occupant, 0, 0)
				,(@occupant_bz_id, @group_id_see_users_occupant, 0, 0)
				,(@occupant_bz_id, @group_id_are_users_invited_by, 0, 0)
#				,(@occupant_bz_id, @group_id_see_users_invited_by, 0, 0)
				;

#################
#
# WIP
#
#		
#	INSERT  INTO `ut_series_categories`
#		(`id`
#		,`name`
#		) 
#		VALUES 
#		(NULL,CONCAT(@stakeholder,'_#',@product_id)),
#		(NULL,CONCAT(@unit,'_#',@product_id));
#
#	SET @series_2 = (SELECT `id` FROM `ut_series_categories` WHERE `name` = '-All-');
#	SET @series_1 = (SELECT `id` FROM `ut_series_categories` WHERE `name` = CONCAT(@stakeholder,'_#',@product_id));
#	SET @series_3 = (SELECT `id` FROM `ut_series_categories` WHERE `name` = CONCAT(@unit,'_#',@product_id));
#
#	INSERT  INTO `ut_series`
#		(`series_id`
#		,`creator`
#		,`category`
#		,`subcategory`
#		,`name`
#		,`frequency`
#		,`query`
#		,`is_public`
#		) 
#		VALUES 
#		(NULL,@bz_user_id,@series_1,@series_2,'UNCONFIRMED',1,CONCAT('bug_status=UNCONFIRMED&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_2,'CONFIRMED',1,CONCAT('bug_status=CONFIRMED&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_2,'IN_PROGRESS',1,CONCAT('bug_status=IN_PROGRESS&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_2,'REOPENED',1,CONCAT('bug_status=REOPENED&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_2,'STAND BY',1,CONCAT('bug_status=STAND%20BY&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_2,'RESOLVED',1,CONCAT('bug_status=RESOLVED&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_2,'VERIFIED',1,CONCAT('bug_status=VERIFIED&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_2,'CLOSED',1,CONCAT('bug_status=CLOSED&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_2,'FIXED',1,CONCAT('resolution=FIXED&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_2,'INVAL`status_workflow`ID',1,CONCAT('resolution=INVAL%60status_workflow%60ID&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_2,'WONTFIX',1,CONCAT('resolution=WONTFIX&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_2,'DUPLICATE',1,CONCAT('resolution=DUPLICATE&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_2,'WORKSFORME',1,CONCAT('resolution=WORKSFORME&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_2,'All Open',1,CONCAT('bug_status=UNCONFIRMED&bug_status=CONFIRMED&bug_status=IN_PROGRESS&bug_status=REOPENED&bug_status=STAND%20BY&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_3,'All Open',1,CONCAT('field0-0-0=resolution&type0-0-0=notregexp&value0-0-0=.&product=',@unit_for_query,'&component=',@stakeholder),1),
#		(NULL,@bz_user_id,@series_1,@series_3,'All Closed',1,CONCAT('field0-0-0=resolution&type0-0-0=regexp&value0-0-0=.&product=',@unit_for_query,'&component=',@stakeholder),1);
#
#	INSERT  INTO `ut_audit_log`
#		(`user_id`
#		,`class`
#		,`object_id`
#		,`field`
#		,`removed`
#		,`added`
#		,`at_time`
#		) 
#		VALUES 
#		(@bz_user_id,'Bugzilla::Component',@component_id,'__create__',NULL,@stakeholder,@timestamp),
#		(@bz_user_id,'Bugzilla::Group',@show_to_stakeholder_4_group_id,'__create__',NULL,CONCAT(@unit,' #',@product_id,'-',(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 4)),@timestamp),
#		(@bz_user_id,'Bugzilla::Group',@are_users_stakeholder_4_group_id,'__create__',NULL,CONCAT(@unit,' #',@product_id,'-List users-',(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 4)),@timestamp),
#		(@bz_user_id,'Bugzilla::Group',@see_users_stakeholder_4_group_id,'__create__',NULL,CONCAT(@unit,' #',@product_id,'-Can see who are stakeholder for comp #',@component_id),@timestamp),
#		(@bz_user_id,'Bugzilla::Group',@invited_by_group_id,'__create__',NULL,CONCAT(@unit,' #',@product_id,'-invited by user ',@creator_pub_name),@timestamp),
#		(@bz_user_id,'Bugzilla::Group',@see_invited_by_group_id,'__create__',NULL,CONCAT(@unit,' #',@product_id,'-Can see user invited by ',@creator_pub_name),@timestamp);
#
#
#####################
	
	SET loop_component= (loop_component + 1);
	SET FOREIGN_KEY_CHECKS = 1;
END WHILE;
END$$
DELIMITER ;
CALL insert_component;




###############################################################
# We do the component/roles insert in 2 batches:
#	- DONE 1st batch of units
#		- There is a tenant for each unit.
#		- The creator is the tenant for the unit
#		- The creator is the occupant of the unit.
#	- Now we do the rest of the batches after the 1st batch of unit
#		- The creator is the Landlord for the unit
#		- There are no tenant
#		- There are no occupant.
#
# This guarantees that 
#	- a Unee-T user is a tenant only once 
#	- a Unee-T user is an occupant in only one unit
###############################################################

# We need to define a few extra variables:
SET @landlord_counter = 0;
SET @iteration_thru_landlord = 0;
SET @agent_counter = 0;
SET @iteration_thru_agent = 0;
SET @contractor_counter = 0;
SET @iteration_thru_contractor = 0;
SET @mgt_cny_counter = 0;
SET @iteration_thru_mgt_cny = 0;

DELIMITER $$
	DROP PROCEDURE IF EXISTS insert_component_rest$$
	CREATE PROCEDURE insert_component_rest()
	BEGIN


# We have created (12 * @iteration_number_of_users * number_of_units_per_user) products
#
# For this all the batches of units after the first one
#	- The unit creator will be the landlord 
# 	- There will be NO Tenant
# 	- There will be NO occupant
#
# The first batch of unit starts at 12 * @iteration_number_of_users) + 2

	DECLARE loop_component_rest INT DEFAULT ((12 * @iteration_number_of_users) + 2);

# And ends at the last `products`/unit we have created

	WHILE loop_component_rest <= (SELECT MAX(id) FROM `products`) DO

	SET FOREIGN_KEY_CHECKS = 0;
	SET @product_id = loop_component_rest;
	SET @unit = (SELECT `name` FROM `products` WHERE `id`=@product_id);
	SET @unit_for_query = REPLACE(@unit,' ','%');


	# We now need to create the following 4 components for each of these products:
	# 	- Landlord 2
	#	- Agent 5
	#	- Contractor 3
	#	- Management company 4
	#
	# To simplify this script, we will create only one user for each role EXCEPT for
	#	- Management Company
	#	- Contractor
	# 
	# When we created the unit we created 11 groups:
	#	- create_case_group_id
	#	- can_edit_case_group_id
	#	- can_edit_all_field_case_group_id
	#	- can_edit_component_group_id
	#	- can_see_cases_group_id
	#	- all_g_flags_group_id
	#	- all_r_flags_group_id
	#	- list_visible_assignees_group_id
	#	- see_visible_assignees_group_id
	#	- active_stakeholder_group_id
	#	- unit_creator_group_id
	#
	# We will also create the following 20 additional groups for these units:
	#	- show_to_tenant
	#	- are_users_tenant
	#	- see_users_tenant
	#	- show_to_landlord
	#	- are_users_landlord
	#	- see_users_landlord
	#	- show_to_agent
	#	- are_users_agent
	#	- see_users_agent
	#	- show_to_contractor
	#	- are_users_contractor
	#	- see_users_contractor
	#	- show_to_mgt_cny
	#	- are_users_mgt_cny
	#	- see_users_mgt_cny
	#	- show_to_occupant
	#	- are_users_occupant
	#	- see_users_occupant
	#	- are_users_invited_by
	#	- see_users_invited_by
	#
	
	
	SET @creator_bz_id = (SELECT `created_by_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 1));
	SET @creator_pub_name = (SELECT `realname` FROM `profiles` WHERE `userid` = @creator_bz_id);
	SET @creator_more = 'Placeholder for more information-Lorem ipsus dolorem';
	SET @creator_pub_info = CONCAT(@creator_pub_name,'-', @creator_more);
	
	SET @visibility_explanation_1 = 'Visible only to ';
	SET @visibility_explanation_2 = ' for this unit.';
	SET @role_tenant_pub_name = CONCAT(@component_id_tenant,'-', @unit, '-', @creator_pub_name,'-', @tenant_bz_id, '-Tenant');
	SET @role_tenant_more = @creator_more;
	SET @role_tenant_pub_info = @creator_pub_info;
	SET @tenant_role_desc = (CONCAT(@role_tenant_g_description, '\r\-',@role_tenant_pub_info));
	
	# We now get the bz_user_id and information for each of the roles that we will create.
	
	# To do that we need to know:
		# The number of user we have created
		SET @total_users = (SELECT MAX(`userid`) FROM `profiles`);
		# The loop we are in
		SET @which_batch_of_user = LEAST(CEILING((@product_id - 1) / (@iteration_number_of_users * 12)), @iteration_number_of_users);
		# we also need to know which batch of product we are in too!
		SET @which_batch_of_product = CEIL((@product_id - 1) / (12 * @number_of_units_per_user));

		# Landlord
			SET @component_id_landlord = ((SELECT MAX(`id`) FROM `components`) + 1);
			SET @role_landlord_g_description = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=2);
			SET @landlord_bz_id = @creator_bz_id;

			
			# We get more information about the landlord for that unit.
			SET @role_landlord_pub_name = CONCAT(@component_id_landlord,'-', @unit, '-',(SELECT `realname` FROM `profiles` WHERE `userid` = @landlord_bz_id),'-', @landlord_bz_id,'-Landlord');
			SET @role_landlord_more = 'Placeholder for more information on Landlord-Lorem ipsus dolorem';
			SET @role_landlord_pub_info = CONCAT(@role_landlord_pub_name,'\r\n', @role_landlord_g_description,'\r\n',@role_landlord_more);
			
		# Agent
			SET @component_id_agent = (@component_id_landlord + 1);
			SET @role_agent_g_description = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 5);
		
			# By convention, the Agent user_id can only be one of the following bz_user_id:
				# 5 + (12*(@iteration_number_of_users-1))
				# OR
				# 6 + (12*(@iteration_number_of_users-1))

			# How many possible agents do we have?
			SET @count_agent_batch = (@iteration_number_of_users * 2);
			
			# For this unit/creator, which agent loop is this?
			SET @agent_loop_counter = CEILING(@creator_bz_id/@count_agent_batch);
			
			# For this unit/creator, the agent will be from which user batch?
			SET @user_batch_nber_for_agent = CEILING((@creator_bz_id / 2)-(@iteration_number_of_users*(@agent_loop_counter - 1)));

			# We have n agents to choose from.
			# We are counting how many time we have gone through the loop.
			SET @iteration_thru_agent = (@iteration_thru_agent + 1);
			
			# If we have gone thru the 2 possible option for agent, we reset this to 1
			SET @iteration_thru_agent = IF( @iteration_thru_agent = 3
											, 1
											, @iteration_thru_agent
											);
			
			SET @agent_bz_id = IF(@iteration_thru_agent = 1
									, (5 + ((@user_batch_nber_for_ll - 1) * 12))
									, (6 + ((@user_batch_nber_for_ll - 1) * 12))
									)
									;
			# We get more information about the agent for that unit.
			SET @role_agent_pub_name = CONCAT(@component_id_agent,'-', @unit, '-',(SELECT `realname` FROM `profiles` WHERE `userid` = @agent_bz_id),'-', @agent_bz_id,'-Agent');
			SET @role_agent_more = 'Placeholder for more information on agent-Lorem ipsus dolorem';
			SET @role_agent_pub_info = CONCAT(@role_agent_pub_name,'\r\n', @role_agent_g_description,'\r\n', @role_agent_more);
		
		# Contractor
			SET @component_id_contractor = (@component_id_agent + 1);
			SET @role_contractor_g_description = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=3);

			# By convention, 
				# The default contractor user_id is
				# 7 + (12*(@iteration_number_of_users-1))
				
				# the other contractor user_id can only be one of the following bz_user_id:
				# 8 + (12*(@iteration_number_of_users-1))
				# OR
				# 9 + (12*(@iteration_number_of_users-1))

			# How many possible contractor do we have?
			SET @count_contractor_batch = (@iteration_number_of_users * 1);
			
			# For this unit/creator, which contractor loop is this?
			SET @contractor_loop_counter = CEILING(@creator_bz_id/@count_contractor_batch);
			
			# For this unit/creator, the contractor will be from which user batch?
			SET @user_batch_nber_for_contractor = CEILING((@creator_bz_id/1)-(@iteration_number_of_users * (@contractor_loop_counter-1)));

			# We have n contractors to choose from.
			# We are counting how many time we have gone through the loop.
			SET @iteration_thru_contractor = (@iteration_thru_contractor + 1);
			
			# If we have gone thru the 1 possible option for contractor, we reset this to 1
			SET @iteration_thru_contractor = IF( @iteration_thru_contractor = 2
											, 1
											, @iteration_thru_contractor
											);
			
			# YES I know, it is possible to optimize this formula, I keep it like this to 
			#	- be consistant 
			#	- make it compatible if we need to have more than 1 option...
			SET @contractor_1_bz_id = IF(@iteration_thru_contractor = 1
									, (7 + ((@user_batch_nber_for_contractor-1) * 12))
									, (7 + ((@user_batch_nber_for_contractor-1) * 12))
									)
									;

				# We get more information about the Initial contact for the contractor for that unit.
				SET @role_contractor_pub_name = CONCAT( @component_id_contractor,'-', @unit, '-', (SELECT `realname` FROM `profiles` WHERE `userid` = @contractor_1_bz_id),'-',@contractor_1_bz_id,'-Contractor');
				SET @role_contractor_more = 'Placeholder for more information on Contractor-Lorem ipsus dolorem';
				SET @role_contractor_pub_info = CONCAT(@role_contractor_pub_name,'\r\n', @role_contractor_g_description,'\r\n', @role_contractor_more);

				# Other Employee for the Contractor Firm (These also need to go in the 'component_cc' table)
				SET @contractor_2_bz_id = (@contractor_1_bz_id + 1);
				SET @contractor_3_bz_id = (@contractor_1_bz_id + 2);
			
		# Management Company
			SET @component_id_mgt_cny = (@component_id_contractor + 1);
			SET @role_mgt_cny_g_description = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=4);
			
			# By convention, the Management Company user_id can only be one of the following bz_user_id:
				# The default Management Company user_id is
				# 13 + (12*(@iteration_number_of_users-1))
				
				# the other mgt_cny user_id can only be one of the following bz_user_id:
				# 11 + (12*(@iteration_number_of_users-1))
				# OR
				# 12 + (12*(@iteration_number_of_users-1))


			# How many possible mgt_cny do we have?
			SET @count_mgt_cny_batch = (@iteration_number_of_users * 1);
			
			# For this unit/creator, which mgt_cny loop is this?
			SET @mgt_cny_loop_counter = CEILING(@creator_bz_id/@count_mgt_cny_batch);
			
			# For this unit/creator, the mgt_cny will be from which user batch?
			SET @user_batch_nber_for_mgt_cny = CEILING((@creator_bz_id/1)-(@iteration_number_of_users * (@mgt_cny_loop_counter-1)));

			# We have n mgt_cny to choose from.
			# We are counting how many time we have gone through the loop.
			SET @iteration_thru_mgt_cny = (@iteration_thru_mgt_cny + 1);
			
			# If we have gone thru the 1 possible option for contractor, we reset this to 1
			SET @iteration_thru_mgt_cny = IF( @iteration_thru_mgt_cny = 2
											, 1
											, @iteration_thru_mgt_cny
											);
			
			# YES I know, it is possible to optimize this formula, I keep it like this to 
			#	- be consistant 
			#	- make it compatible if we need to have more than 1 option...
			SET @mgt_cny_1_bz_id = IF(@iteration_thru_mgt_cny = 1
									, (13 + ((@user_batch_nber_for_mgt_cny - 1) * 12))
									, (13 + ((@user_batch_nber_for_mgt_cny - 1) * 12))
									)
									;
					
				# We get more information about the Initial contact for the contractor for that unit.
				SET @role_mgt_cny_pub_name = CONCAT(@component_id_mgt_cny,'-', @unit, '-', (SELECT `realname` FROM `profiles` WHERE `userid` = @mgt_cny_1_bz_id),'-',@mgt_cny_1_bz_id,'-MgtCny');
				SET @role_mgt_cny_more = 'Placeholder for more information on Management Company-Lorem ipsus dolorem';
				SET @role_mgt_cny_pub_info = CONCAT(@role_mgt_cny_pub_name,'\r\n', @role_mgt_cny_g_description,'\r\n', @role_mgt_cny_more);
				
				# Other Employee for the Contractor Firm (These go in the 'component_cc' table)
				SET @mgt_cny_2_bz_id = (@mgt_cny_1_bz_id - 1);
				SET @mgt_cny_3_bz_id = (@mgt_cny_2_bz_id - 2);

				
	# We have everything, we can now create the rest of the components for the rest of the units.

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
		(@component_id_landlord,@role_landlord_pub_name,@product_id,@landlord_bz_id,@landlord_bz_id,@role_landlord_pub_info,1)
		,(@component_id_agent,@role_agent_pub_name,@product_id,@agent_bz_id,@agent_bz_id,@role_agent_pub_info,1)
		,(@component_id_contractor,@role_contractor_pub_name,@product_id,@contractor_1_bz_id,@contractor_1_bz_id,@role_contractor_pub_info,1)
		,(@component_id_mgt_cny,@role_mgt_cny_pub_name,@product_id,@mgt_cny_1_bz_id,@mgt_cny_1_bz_id,@role_mgt_cny_pub_info,1)
		;

	# We update the table 'ut_map_user_unit_details'
		INSERT INTO `ut_map_user_unit_details`
			(`created`
			,`record_created_by`
			,`user_id`
			,`bz_profile_id`
			,`bz_unit_id`
			,`role_type_id`
			,`public_name`
			,`comment`
			)
			VALUES
			(NOW(), @creator_bz_id, @landlord_bz_id, @landlord_bz_id, @product_id, 2, @role_landlord_pub_name, 'Created with demo user creation script when we create the component')
			,(NOW(), @creator_bz_id, @agent_bz_id, @agent_bz_id, @product_id, 5, @role_agent_pub_name, 'Created with demo user creation script when we create the component')
			,(NOW(), @creator_bz_id, @contractor_1_bz_id, @contractor_1_bz_id, @product_id, 3, @role_contractor_pub_name, 'Created with demo user creation script when we create the component')
			,(NOW(), @creator_bz_id, @contractor_2_bz_id, @contractor_2_bz_id, @product_id, 3, @role_contractor_pub_name, 'Created with demo user creation script when we create the component')
			,(NOW(), @creator_bz_id, @contractor_3_bz_id, @contractor_3_bz_id, @product_id, 3, @role_contractor_pub_name, 'Created with demo user creation script when we create the component')
			,(NOW(), @creator_bz_id, @mgt_cny_1_bz_id, @mgt_cny_1_bz_id, @product_id, 4, @role_mgt_cny_pub_name, 'Created with demo user creation script when we create the component')
			,(NOW(), @creator_bz_id, @mgt_cny_2_bz_id, @mgt_cny_2_bz_id, @product_id, 4,  @role_mgt_cny_pub_name, 'Created with demo user creation script when we create the component')
			,(NOW(), @creator_bz_id, @mgt_cny_3_bz_id, @mgt_cny_3_bz_id, @product_id, 4, @role_mgt_cny_pub_name, 'Created with demo user creation script when we create the component')
			;		
		
	INSERT INTO `component_cc`
		(`user_id`
		,`component_id`
		)
		VALUES
		(@contractor_2_bz_id, @component_id_contractor)
		,(@contractor_3_bz_id, @component_id_contractor)
		,(@mgt_cny_2_bz_id, @component_id_mgt_cny)
		,(@mgt_cny_3_bz_id, @component_id_mgt_cny)
		;
		
	# We now create the groups we need

		# For the Landlord
			# Visibility group 
			SET @group_id_show_to_landlord = ((SELECT MAX(`id`) FROM `groups`) + 1);
			SET @group_name_show_to_landlord = (CONCAT(@unit,'-',@component_id_landlord,'-Landlord'));
			SET @group_description_show_to_landlord = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 2),@visibility_explanation_2));
			
			# Is in landlord user Group
			SET @group_id_are_users_landlord = (@group_id_show_to_landlord + 1);
			SET @group_name_are_users_landlord = (CONCAT(@unit,'-',@component_id_landlord,'-List-landlord'));
			SET @group_description_are_users_landlord = (CONCAT('list the landlord(s)', @unit));
			
			# Can See landlord user Group
			SET @group_id_see_users_landlord = (@group_id_are_users_landlord + 1);
			SET @group_name_see_users_landlord = (CONCAT(@unit,'-',@component_id_landlord,'-Can-see-lanldord'));
			SET @group_description_see_users_landlord = (CONCAT('See the list of lanldord(s) for ', @unit));
			
		# For the agent
			# Visibility group 
			SET @group_id_show_to_agent = (@group_id_see_users_landlord + 1);
			SET @group_name_show_to_agent = (CONCAT(@unit,'-',@component_id_agent,'-Agent'));
			SET @group_description_show_to_agent = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 5),@visibility_explanation_2));
			
			# Is in Agent user Group
			SET @group_id_are_users_agent = (@group_id_show_to_agent + 1);
			SET @group_name_are_users_agent = (CONCAT(@unit,'-',@component_id_agent,'-List-agent'));
			SET @group_description_are_users_agent = (CONCAT('list the agent(s)', @unit));
			
			# Can See Agent user Group
			SET @group_id_see_users_agent = (@group_id_are_users_agent + 1);
			SET @group_name_see_users_agent = (CONCAT(@unit,'-',@component_id_agent,'-Can-see-agent'));
			SET @group_description_see_users_agent = (CONCAT('See the list of agent(s) for ', @unit));
		
		# For the contractor
			# Visibility group 
			SET @group_id_show_to_contractor = (@group_id_see_users_agent + 1);
			SET @group_name_show_to_contractor = (CONCAT(@unit,'-',@component_id_contractor,'-Contractor-Employee'));
			SET @group_description_show_to_contractor = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 3),@visibility_explanation_2));
			
			# Is in contractor user Group
			SET @group_id_are_users_contractor = (@group_id_show_to_contractor + 1);
			SET @group_name_are_users_contractor = (CONCAT(@unit,'-',@component_id_contractor,'-List-contractor-employee'));
			SET @group_description_are_users_contractor = (CONCAT('list the contractor employee(s)', @unit));
			
			# Can See contractor user Group
			SET @group_id_see_users_contractor = (@group_id_are_users_contractor + 1);
			SET @group_name_see_users_contractor = (CONCAT(@unit,'-',@component_id_contractor,'-Can-see-contractor-employee'));
			SET @group_description_see_users_contractor = (CONCAT('See the list of contractor employee(s) for ', @unit));
			
		# For the Mgt Cny
			# Visibility group
			SET @group_id_show_to_mgt_cny = (@group_id_see_users_contractor + 1);
			SET @group_name_show_to_mgt_cny = (CONCAT(@unit,'-',@component_id_mgt_cny,'-Mgt-Cny-Employee'));
			SET @group_description_show_to_mgt_cny = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 4),@visibility_explanation_2));
			
			# Is in mgt cny user Group
			SET @group_id_are_users_mgt_cny = (@group_id_show_to_mgt_cny + 1);
			SET @group_name_are_users_mgt_cny = (CONCAT(@unit,'-',@component_id_mgt_cny,'-List-Mgt-Cny-Employee'));
			SET @group_description_are_users_mgt_cny = (CONCAT('list the Mgt Cny Employee(s)', @unit));
			
			# Can See mgt cny user Group
			SET @group_id_see_users_mgt_cny = (@group_id_are_users_mgt_cny + 1);
			SET @group_name_see_users_mgt_cny = (CONCAT(@unit,'-',@component_id_mgt_cny,'-Can-see-Mgt-Cny-Employee'));
			SET @group_description_see_users_mgt_cny = (CONCAT('See the list of Mgt Cny Employee(s) for ', @unit));
			
		# For the people invited by this user:
			# Is in invited_by user Group
			SET @group_id_are_users_invited_by = (@group_id_see_users_mgt_cny + 1);
			SET @group_name_are_users_invited_by = (CONCAT(@unit,'-List-invited-by'));
			SET @group_description_are_users_invited_by = (CONCAT('list the invited_by(s)', @unit));
			
			# Can See users in invited_by user Group
			SET @group_id_see_users_invited_by = (@group_id_are_users_invited_by + 1);
			SET @group_name_see_users_invited_by = (CONCAT(@unit,'-Can-see-invited-by'));
			SET @group_description_see_users_invited_by = (CONCAT('See the list of invited_by(s) for ', @unit));

	# We have everything: we can create the groups we need!
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
			(@group_id_show_to_landlord,@group_name_show_to_landlord,@group_description_show_to_landlord,1,'',1,NULL)
			,(@group_id_are_users_landlord,@group_name_are_users_landlord,@group_description_are_users_landlord,0,'',1,NULL)
			,(@group_id_see_users_landlord,@group_name_see_users_landlord,@group_description_see_users_landlord,0,'',1,NULL)
			,(@group_id_show_to_agent,@group_name_show_to_agent,@group_description_show_to_agent,1,'',1,NULL)
			,(@group_id_are_users_agent,@group_name_are_users_agent,@group_description_are_users_agent,0,'',1,NULL)
			,(@group_id_see_users_agent,@group_name_see_users_agent,@group_description_see_users_agent,0,'',1,NULL)
			,(@group_id_show_to_contractor,@group_name_show_to_contractor,@group_description_show_to_contractor,1,'',1,NULL)
			,(@group_id_are_users_contractor,@group_name_are_users_contractor,@group_description_are_users_contractor,0,'',1,NULL)
			,(@group_id_see_users_contractor,@group_name_see_users_contractor,@group_description_see_users_contractor,0,'',1,NULL)
			,(@group_id_show_to_mgt_cny,@group_name_show_to_mgt_cny,@group_description_show_to_mgt_cny,1,'',1,NULL)
			,(@group_id_are_users_mgt_cny,@group_name_are_users_mgt_cny,@group_description_are_users_mgt_cny,0,'',1,NULL)
			,(@group_id_see_users_mgt_cny,@group_name_see_users_mgt_cny,@group_description_see_users_mgt_cny,0,'',1,NULL)
			,(@group_id_are_users_invited_by,@group_name_are_users_invited_by,@group_description_are_users_invited_by,0,'',1,NULL)
			,(@group_id_see_users_invited_by,@group_name_see_users_invited_by,@group_description_see_users_invited_by,0,'',1,NULL)
			;

	# we capture the groups and products that we have created for future reference.
	
		SET @timestamp = NOW();
	
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
		# Landlord (2)
		(@product_id,@component_id,@group_id_show_to_landlord,2,2,@creator_bz_id,@timestamp)
		,(@product_id,@component_id,@group_id_are_users_landlord,22,2,@creator_bz_id,@timestamp)
		,(@product_id,@component_id,@group_id_see_users_landlord,5,2,@creator_bz_id,@timestamp)
		# Agent (5)
		,(@product_id,@component_id,@group_id_show_to_agent,2,5,@creator_bz_id,@timestamp)
		,(@product_id,@component_id,@group_id_are_users_agent,22,5,@creator_bz_id,@timestamp)
		,(@product_id,@component_id,@group_id_see_users_agent,5,5,@creator_bz_id,@timestamp)
		# contractor (3)
		,(@product_id,@component_id,@group_id_show_to_contractor,2,3,@creator_bz_id,@timestamp)
		,(@product_id,@component_id,@group_id_are_users_contractor,22,3,@creator_bz_id,@timestamp)
		,(@product_id,@component_id,@group_id_see_users_contractor,5,3,@creator_bz_id,@timestamp)
		# mgt_cny (4)
		,(@product_id,@component_id,@group_id_show_to_mgt_cny,2,4,@creator_bz_id,@timestamp)
		,(@product_id,@component_id,@group_id_are_users_mgt_cny,22,4,@creator_bz_id,@timestamp)
		,(@product_id,@component_id,@group_id_see_users_mgt_cny,5,4,@creator_bz_id,@timestamp)
		# invited_by
		,(@product_id,@component_id,@group_id_are_users_invited_by,31,NULL,@creator_bz_id,@timestamp)
		,(@product_id,@component_id,@group_id_see_users_invited_by,32,NULL,@creator_bz_id,@timestamp)
		;

/*Data for the table `group_group_map` */

	INSERT  INTO `group_group_map`
		(`member_id`
		,`grantor_id`
		,`grant_type`
		) 
	##########################################################
	# Logic:
	# If you are a member of group_id XXX (ex: 1 / Admin) 
	# then you have the following permissions:
	# 	- 0: You are automatically a member of group ZZZ
	#	- 1: You can grant access to group ZZZ
	#	- 2: You can see users in group ZZZ
	##########################################################
		VALUES 
		# group to grant membership
		# Admin can grant membership to all.
		(1,@group_id_show_to_landlord,1)
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
		,(1,@group_id_are_users_invited_by,1)
		,(1,@group_id_see_users_invited_by,1)
		
		# Visibility groups
		,(@group_id_see_users_landlord,@group_id_are_users_landlord,2)
		,(@group_id_see_users_agent,@group_id_are_users_contractor,2)
		,(@group_id_see_users_mgt_cny,@group_id_are_users_mgt_cny,2)
		,(@group_id_see_users_invited_by,@group_id_are_users_invited_by,2)
		;

	INSERT  INTO `group_control_map`
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
		(@group_id_show_to_landlord,@product_id,0,2,0,0,0,0,0)
		,(@group_id_show_to_agent,@product_id,0,2,0,0,0,0,0)
		,(@group_id_show_to_contractor,@product_id,0,2,0,0,0,0,0)
		,(@group_id_show_to_mgt_cny,@product_id,0,2,0,0,0,0,0)
		;
	
	# We now assign the user permission for all the users we have created.
		# Groups created when we create the product
		# We need to ge these from the ut_product_table_based on the product_id!
		SET @create_case_group_id =  (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 20));
		SET @can_edit_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 25));
		SET @can_edit_all_field_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 26));
		SET @can_edit_component_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 27));
		SET @can_see_cases_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 28));
		SET @all_r_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 18));
		SET @all_g_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 19));
		SET @list_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 4));
		SET @see_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 5 AND `role_type_id` IS NULL));
		SET @active_stakeholder_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 29));
		SET @unit_creator_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 1));

	INSERT  INTO `ut_user_group_map_temp`
		(`user_id`
		,`group_id`
		,`isbless`
		,`grant_type`
		) 
		VALUES 
		# Methodology: we list all the possible groups and comment out the groups we do not need.
			
		# The Creator:
			# Can grant membership to:

				# Groups created when we create the product
				# This has been done, we we created the product, nothing to do here!
#				(@creator_bz_id, @create_case_group_id, 1, 0)
#				,(@creator_bz_id, @can_edit_case_group_id, 1, 0)
#				,(@creator_bz_id, @can_edit_all_field_case_group_id, 1, 0)
#				,(@creator_bz_id, @can_edit_component_group_id, 1, 0)
#				,(@creator_bz_id, @can_see_cases_group_id, 1, 0)
#				,(@creator_bz_id, @all_g_flags_group_id, 1, 0)
#				,(@creator_bz_id, @all_r_flags_group_id, 1, 0)
#				,(@creator_bz_id, @list_visible_assignees_group_id, 1, 0)
#				,(@creator_bz_id, @see_visible_assignees_group_id, 1, 0)
#				,(@creator_bz_id, @active_stakeholder_group_id, 1, 0)
#				,(@creator_bz_id, @unit_creator_group_id, 1, 0)

				
				# Groups created when we create the components
				# The creator can not grant any group membership just because he is the creator...
#				,(@creator_bz_id, @group_id_show_to_landlord, 1, 0)
#				,(@creator_bz_id, @group_id_are_users_landlord, 1, 0)
#				,(@creator_bz_id, @group_id_see_users_landlord, 1, 0)
#				,(@creator_bz_id, @group_id_show_to_agent, 1, 0)
#				,(@creator_bz_id, @group_id_are_users_agent, 1, 0)
#				,(@creator_bz_id, @group_id_see_users_agent, 1, 0)
#				,(@creator_bz_id, @group_id_show_to_contractor, 1, 0)
#				,(@creator_bz_id, @group_id_are_users_contractor, 1, 0)
#				,(@creator_bz_id, @group_id_see_users_contractor, 1, 0)
#				,(@creator_bz_id, @group_id_show_to_mgt_cny, 1, 0)
#				,(@creator_bz_id, @group_id_are_users_mgt_cny, 1, 0)
#				,(@creator_bz_id, @group_id_see_users_mgt_cny, 1, 0)
				(@creator_bz_id, @group_id_are_users_invited_by, 1, 0)
#				,(@creator_bz_id, @group_id_see_users_invited_by, 1, 0)
	
			# Is a member of:
				# Groups created when we create the product
				# This has been done, we we created the product, nothing to do here!
#				,(@creator_bz_id, @create_case_group_id, 0, 0)
#				,(@creator_bz_id, @can_edit_case_group_id, 0, 0)
#				,(@creator_bz_id, @can_edit_all_field_case_group_id, 0, 0)
#				,(@creator_bz_id, @can_edit_component_group_id, 0, 0)
#				,(@creator_bz_id, @can_see_cases_group_id, 0, 0)
#				,(@creator_bz_id, @all_g_flags_group_id, 0, 0)
#				,(@creator_bz_id, @all_r_flags_group_id, 0, 0)
#				,(@creator_bz_id, @list_visible_assignees_group_id, 0, 0)
#				,(@creator_bz_id, @see_visible_assignees_group_id, 0, 0)
#				,(@creator_bz_id, @active_stakeholder_group_id, 0, 0)
#				,(@creator_bz_id, @unit_creator_group_id, 0, 0)
			
				# Groups created when we create the components
				# The creator can see all the users except the contractors and Mgt Cny employees who are not public stakeholders.
#				,(@creator_bz_id, @group_id_show_to_landlord, 0, 0)
#				,(@creator_bz_id, @group_id_are_users_landlord, 0, 0)
				,(@creator_bz_id, @group_id_see_users_landlord, 0, 0)
#				,(@creator_bz_id, @group_id_show_to_agent, 0, 0)
#				,(@creator_bz_id, @group_id_are_users_agent, 0, 0)
				,(@creator_bz_id, @group_id_see_users_agent, 0, 0)
#				,(@creator_bz_id, @group_id_show_to_contractor, 0, 0)
#				,(@creator_bz_id, @group_id_are_users_contractor, 0, 0)
#				,(@creator_bz_id, @group_id_see_users_contractor, 0, 0)
#				,(@creator_bz_id, @group_id_show_to_mgt_cny, 0, 0)
#				,(@creator_bz_id, @group_id_are_users_mgt_cny, 0, 0)
#				,(@creator_bz_id, @group_id_see_users_mgt_cny, 0, 0)
#				,(@creator_bz_id, @group_id_are_users_invited_by, 0, 0)
#				,(@creator_bz_id, @group_id_see_users_invited_by, 0, 0)
		
		# The Landlord
			#Can grant membership to:
				# Groups created when we create the product
				,(@landlord_bz_id, @create_case_group_id, 1, 0)
				,(@landlord_bz_id, @can_edit_case_group_id, 1, 0)
				,(@landlord_bz_id, @can_edit_all_field_case_group_id, 1, 0)
				,(@landlord_bz_id, @can_edit_component_group_id, 1, 0)
				,(@landlord_bz_id, @can_see_cases_group_id, 1, 0)
				,(@landlord_bz_id, @all_g_flags_group_id, 1, 0)
				,(@landlord_bz_id, @all_r_flags_group_id, 1, 0)
				,(@landlord_bz_id, @list_visible_assignees_group_id, 1, 0)
				,(@landlord_bz_id, @see_visible_assignees_group_id, 1, 0)
				,(@landlord_bz_id, @active_stakeholder_group_id, 1, 0)
#				,(@landlord_bz_id, @unit_creator_group_id, 1, 0)
			
				# Groups created when we create the components
				,(@landlord_bz_id, @group_id_show_to_landlord, 1, 0)
				,(@landlord_bz_id, @group_id_are_users_landlord, 1, 0)
				,(@landlord_bz_id, @group_id_see_users_landlord, 1, 0)
#				,(@landlord_bz_id, @group_id_show_to_agent, 1, 0)
#				,(@landlord_bz_id, @group_id_are_users_agent, 1, 0)
#				,(@landlord_bz_id, @group_id_see_users_agent, 1, 0)
#				,(@landlord_bz_id, @group_id_show_to_contractor, 1, 0)
#				,(@landlord_bz_id, @group_id_are_users_contractor, 1, 0)
#				,(@landlord_bz_id, @group_id_see_users_contractor, 1, 0)
#				,(@landlord_bz_id, @group_id_show_to_mgt_cny, 1, 0)
#				,(@landlord_bz_id, @group_id_are_users_mgt_cny, 1, 0)
#				,(@landlord_bz_id, @group_id_see_users_mgt_cny, 1, 0)
#				,(@landlord_bz_id, @group_id_are_users_invited_by, 1, 0)
#				,(@landlord_bz_id, @group_id_see_users_invited_by, 1, 0)
	
			# Is a member of:
				# Groups created when we create the product
				,(@landlord_bz_id, @create_case_group_id, 0, 0)
				,(@landlord_bz_id, @can_edit_case_group_id, 0, 0)
#				,(@landlord_bz_id, @can_edit_all_field_case_group_id, 0, 0)
#				,(@landlord_bz_id, @can_edit_component_group_id, 0, 0)
				,(@landlord_bz_id, @can_see_cases_group_id, 0, 0)
				,(@landlord_bz_id, @all_g_flags_group_id, 0, 0)
				,(@landlord_bz_id, @all_r_flags_group_id, 0, 0)
				,(@landlord_bz_id, @list_visible_assignees_group_id, 0, 0)
				,(@landlord_bz_id, @see_visible_assignees_group_id, 0, 0)
				,(@landlord_bz_id, @active_stakeholder_group_id, 0, 0)
#				,(@landlord_bz_id, @unit_creator_group_id, 0, 0)
			
				# Groups created when we create the components
				,(@landlord_bz_id, @group_id_show_to_landlord, 0, 0)
				,(@landlord_bz_id, @group_id_are_users_landlord, 0, 0)
				,(@landlord_bz_id, @group_id_see_users_landlord, 0, 0)
#				,(@landlord_bz_id, @group_id_show_to_agent, 0, 0)
#				,(@landlord_bz_id, @group_id_are_users_agent, 0, 0)
#				,(@landlord_bz_id, @group_id_see_users_agent, 0, 0)
#				,(@landlord_bz_id, @group_id_show_to_contractor, 0, 0)
#				,(@landlord_bz_id, @group_id_are_users_contractor, 0, 0)
#				,(@landlord_bz_id, @group_id_see_users_contractor, 0, 0)
#				,(@landlord_bz_id, @group_id_show_to_mgt_cny, 0, 0)
#				,(@landlord_bz_id, @group_id_are_users_mgt_cny, 0, 0)
#				,(@landlord_bz_id, @group_id_see_users_mgt_cny, 0, 0)
				,(@landlord_bz_id, @group_id_are_users_invited_by, 0, 0)
#				,(@landlord_bz_id, @group_id_see_users_invited_by, 0, 0)
		
		# The Agent
			# Can grant membership to:
				# Groups created when we create the product
				,(@agent_bz_id, @create_case_group_id, 1, 0)
				,(@agent_bz_id, @can_edit_case_group_id, 1, 0)
				,(@agent_bz_id, @can_edit_all_field_case_group_id, 1, 0)
				,(@agent_bz_id, @can_edit_component_group_id, 1, 0)
				,(@agent_bz_id, @can_see_cases_group_id, 1, 0)
				,(@agent_bz_id, @all_g_flags_group_id, 1, 0)
				,(@agent_bz_id, @all_r_flags_group_id, 1, 0)
				,(@agent_bz_id, @list_visible_assignees_group_id, 1, 0)
				,(@agent_bz_id, @see_visible_assignees_group_id, 1, 0)
				,(@agent_bz_id, @active_stakeholder_group_id, 1, 0)
#				,(@agent_bz_id, @unit_creator_group_id, 1, 0)
			
				# Groups created when we create the components
#				,(@agent_bz_id, @group_id_show_to_landlord, 1, 0)
#				,(@agent_bz_id, @group_id_are_users_landlord, 1, 0)
#				,(@agent_bz_id, @group_id_see_users_landlord, 1, 0)
				,(@agent_bz_id, @group_id_show_to_agent, 1, 0)
				,(@agent_bz_id, @group_id_are_users_agent, 1, 0)
				,(@agent_bz_id, @group_id_see_users_agent, 1, 0)
#				,(@agent_bz_id, @group_id_show_to_contractor, 1, 0)
#				,(@agent_bz_id, @group_id_are_users_contractor, 1, 0)
#				,(@agent_bz_id, @group_id_see_users_contractor, 1, 0)
#				,(@agent_bz_id, @group_id_show_to_mgt_cny, 1, 0)
#				,(@agent_bz_id, @group_id_are_users_mgt_cny, 1, 0)
#				,(@agent_bz_id, @group_id_see_users_mgt_cny, 1, 0)
#				,(@agent_bz_id, @group_id_are_users_invited_by, 1, 0)
#				,(@agent_bz_id, @group_id_see_users_invited_by, 1, 0)
	
			# Is a member of:
				# Groups created when we create the product
				,(@agent_bz_id, @create_case_group_id, 0, 0)
				,(@agent_bz_id, @can_edit_case_group_id, 0, 0)
#				,(@agent_bz_id, @can_edit_all_field_case_group_id, 0, 0)
#				,(@agent_bz_id, @can_edit_component_group_id, 0, 0)
				,(@agent_bz_id, @can_see_cases_group_id, 0, 0)
				,(@agent_bz_id, @all_g_flags_group_id, 0, 0)
				,(@agent_bz_id, @all_r_flags_group_id, 0, 0)
				,(@agent_bz_id, @list_visible_assignees_group_id, 0, 0)
				,(@agent_bz_id, @see_visible_assignees_group_id, 0, 0)
				,(@agent_bz_id, @active_stakeholder_group_id, 0, 0)
#				,(@agent_bz_id, @unit_creator_group_id, 0, 0)
			
				# Groups created when we create the components
#				,(@agent_bz_id, @group_id_show_to_landlord, 0, 0)
#				,(@agent_bz_id, @group_id_are_users_landlord, 0, 0)
#				,(@agent_bz_id, @group_id_see_users_landlord, 0, 0)
				,(@agent_bz_id, @group_id_show_to_agent, 0, 0)
				,(@agent_bz_id, @group_id_are_users_agent, 0, 0)
				,(@agent_bz_id, @group_id_see_users_agent, 0, 0)
#				,(@agent_bz_id, @group_id_show_to_contractor, 0, 0)
#				,(@agent_bz_id, @group_id_are_users_contractor, 0, 0)
#				,(@agent_bz_id, @group_id_see_users_contractor, 0, 0)
#				,(@agent_bz_id, @group_id_show_to_mgt_cny, 0, 0)
#				,(@agent_bz_id, @group_id_are_users_mgt_cny, 0, 0)
#				,(@agent_bz_id, @group_id_see_users_mgt_cny, 0, 0)
				,(@agent_bz_id, @group_id_are_users_invited_by, 0, 0)
#				,(@agent_bz_id, @group_id_see_users_invited_by, 0, 0)
		
		# The contractor and the contractor employees
			# The Main user (employee 1):
				# Can grant membership to:
					# Groups created when we create the product
					,(@contractor_1_bz_id, @create_case_group_id, 1, 0)
					,(@contractor_1_bz_id, @can_edit_case_group_id, 1, 0)
					,(@contractor_1_bz_id, @can_edit_all_field_case_group_id, 1, 0)
					,(@contractor_1_bz_id, @can_edit_component_group_id, 1, 0)
					,(@contractor_1_bz_id, @can_see_cases_group_id, 1, 0)
					,(@contractor_1_bz_id, @all_g_flags_group_id, 1, 0)
					,(@contractor_1_bz_id, @all_r_flags_group_id, 1, 0)
					,(@contractor_1_bz_id, @list_visible_assignees_group_id, 1, 0)
					,(@contractor_1_bz_id, @see_visible_assignees_group_id, 1, 0)
					,(@contractor_1_bz_id, @active_stakeholder_group_id, 1, 0)
#					,(@contractor_1_bz_id, @unit_creator_group_id, 1, 0)
				
					# Groups created when we create the components
#					,(@contractor_1_bz_id, @group_id_show_to_landlord, 1, 0)
#					,(@contractor_1_bz_id, @group_id_are_users_landlord, 1, 0)
#					,(@contractor_1_bz_id, @group_id_see_users_landlord, 1, 0)
#					,(@contractor_1_bz_id, @group_id_show_to_agent, 1, 0)
#					,(@contractor_1_bz_id, @group_id_are_users_agent, 1, 0)
#					,(@contractor_1_bz_id, @group_id_see_users_agent, 1, 0)
					,(@contractor_1_bz_id, @group_id_show_to_contractor, 1, 0)
					,(@contractor_1_bz_id, @group_id_are_users_contractor, 1, 0)
					,(@contractor_1_bz_id, @group_id_see_users_contractor, 1, 0)
#					,(@contractor_1_bz_id, @group_id_show_to_mgt_cny, 1, 0)
#					,(@contractor_1_bz_id, @group_id_are_users_mgt_cny, 1, 0)
#					,(@contractor_1_bz_id, @group_id_see_users_mgt_cny, 1, 0)
#					,(@contractor_1_bz_id, @group_id_are_users_invited_by, 1, 0)
#					,(@contractor_1_bz_id, @group_id_see_users_invited_by, 1, 0)
		
				# Is a member of:
					# Groups created when we create the product
					,(@contractor_1_bz_id, @create_case_group_id, 0, 0)
					,(@contractor_1_bz_id, @can_edit_case_group_id, 0, 0)
#					,(@contractor_1_bz_id, @can_edit_all_field_case_group_id, 0, 0)
#					,(@contractor_1_bz_id, @can_edit_component_group_id, 0, 0)
					,(@contractor_1_bz_id, @can_see_cases_group_id, 0, 0)
					,(@contractor_1_bz_id, @all_g_flags_group_id, 0, 0)
					,(@contractor_1_bz_id, @all_r_flags_group_id, 0, 0)
					,(@contractor_1_bz_id, @list_visible_assignees_group_id, 0, 0)
					,(@contractor_1_bz_id, @see_visible_assignees_group_id, 0, 0)
					,(@contractor_1_bz_id, @active_stakeholder_group_id, 0, 0)
#					,(@contractor_1_bz_id, @unit_creator_group_id, 0, 0)
				
					# Groups created when we create the components
#					,(@contractor_1_bz_id, @group_id_show_to_landlord, 0, 0)
#					,(@contractor_1_bz_id, @group_id_are_users_landlord, 0, 0)
#					,(@contractor_1_bz_id, @group_id_see_users_landlord, 0, 0)
#					,(@contractor_1_bz_id, @group_id_show_to_agent, 0, 0)
#					,(@contractor_1_bz_id, @group_id_are_users_agent, 0, 0)
#					,(@contractor_1_bz_id, @group_id_see_users_agent, 0, 0)
					,(@contractor_1_bz_id, @group_id_show_to_contractor, 0, 0)
					,(@contractor_1_bz_id, @group_id_are_users_contractor, 0, 0)
					,(@contractor_1_bz_id, @group_id_see_users_contractor, 0, 0)
#					,(@contractor_1_bz_id, @group_id_show_to_mgt_cny, 0, 0)
#					,(@contractor_1_bz_id, @group_id_are_users_mgt_cny, 0, 0)
#					,(@contractor_1_bz_id, @group_id_see_users_mgt_cny, 0, 0)
					,(@contractor_1_bz_id, @group_id_are_users_invited_by, 0, 0)
#					,(@contractor_1_bz_id, @group_id_see_users_invited_by, 0, 0)
					
			# Contractor Employee 2 (Visible only to Contractor-no rights to approve or ask for approval)
			
				# Can grant membership to:
					# Groups created when we create the product
#					,(@contractor_2_bz_id, @create_case_group_id, 1, 0)
#					,(@contractor_2_bz_id, @can_edit_case_group_id, 1, 0)
#					,(@contractor_2_bz_id, @can_edit_all_field_case_group_id, 1, 0)
#					,(@contractor_2_bz_id, @can_edit_component_group_id, 1, 0)
#					,(@contractor_2_bz_id, @can_see_cases_group_id, 1, 0)
#					,(@contractor_2_bz_id, @all_g_flags_group_id, 1, 0)
#					,(@contractor_2_bz_id, @all_r_flags_group_id, 1, 0)
#					,(@contractor_2_bz_id, @list_visible_assignees_group_id, 1, 0)
#					,(@contractor_2_bz_id, @see_visible_assignees_group_id, 1, 0)
#					,(@contractor_2_bz_id, @active_stakeholder_group_id, 1, 0)
#					,(@contractor_2_bz_id, @unit_creator_group_id, 1, 0)
				
					# Groups created when we create the components
#					,(@contractor_2_bz_id, @group_id_show_to_landlord, 1, 0)
#					,(@contractor_2_bz_id, @group_id_are_users_landlord, 1, 0)
#					,(@contractor_2_bz_id, @group_id_see_users_landlord, 1, 0)
#					,(@contractor_2_bz_id, @group_id_show_to_agent, 1, 0)
#					,(@contractor_2_bz_id, @group_id_are_users_agent, 1, 0)
#					,(@contractor_2_bz_id, @group_id_see_users_agent, 1, 0)
#					,(@contractor_2_bz_id, @group_id_show_to_contractor, 1, 0)
#					,(@contractor_2_bz_id, @group_id_are_users_contractor, 1, 0)
#					,(@contractor_2_bz_id, @group_id_see_users_contractor, 1, 0)
#					,(@contractor_2_bz_id, @group_id_show_to_mgt_cny, 1, 0)
#					,(@contractor_2_bz_id, @group_id_are_users_mgt_cny, 1, 0)
#					,(@contractor_2_bz_id, @group_id_see_users_mgt_cny, 1, 0)
#					,(@contractor_2_bz_id, @group_id_are_users_invited_by, 1, 0)
#					,(@contractor_2_bz_id, @group_id_see_users_invited_by, 1, 0)
		
				# Is a member of:
					# Groups created when we create the product
					,(@contractor_2_bz_id, @create_case_group_id, 0, 0)
					,(@contractor_2_bz_id, @can_edit_case_group_id, 0, 0)
#					,(@contractor_2_bz_id, @can_edit_all_field_case_group_id, 0, 0)
#					,(@contractor_2_bz_id, @can_edit_component_group_id, 0, 0)
#					,(@contractor_2_bz_id, @can_see_cases_group_id, 0, 0)
#					,(@contractor_2_bz_id, @all_g_flags_group_id, 0, 0)
					,(@contractor_2_bz_id, @all_r_flags_group_id, 0, 0)
#					,(@contractor_2_bz_id, @list_visible_assignees_group_id, 0, 0)
#					,(@contractor_2_bz_id, @see_visible_assignees_group_id, 0, 0)
#					,(@contractor_2_bz_id, @active_stakeholder_group_id, 0, 0)
#					,(@contractor_2_bz_id, @unit_creator_group_id, 0, 0)
				
					# Groups created when we create the components
#					,(@contractor_2_bz_id, @group_id_show_to_landlord, 0, 0)
#					,(@contractor_2_bz_id, @group_id_are_users_landlord, 0, 0)
#					,(@contractor_2_bz_id, @group_id_see_users_landlord, 0, 0)
#					,(@contractor_2_bz_id, @group_id_show_to_agent, 0, 0)
#					,(@contractor_2_bz_id, @group_id_are_users_agent, 0, 0)
#					,(@contractor_2_bz_id, @group_id_see_users_agent, 0, 0)
					,(@contractor_2_bz_id, @group_id_show_to_contractor, 0, 0)
					,(@contractor_2_bz_id, @group_id_are_users_contractor, 0, 0)
					,(@contractor_2_bz_id, @group_id_see_users_contractor, 0, 0)
#					,(@contractor_2_bz_id, @group_id_show_to_mgt_cny, 0, 0)
#					,(@contractor_2_bz_id, @group_id_are_users_mgt_cny, 0, 0)
#					,(@contractor_2_bz_id, @group_id_see_users_mgt_cny, 0, 0)
					,(@contractor_2_bz_id, @group_id_are_users_invited_by, 0, 0)
#					,(@contractor_2_bz_id, @group_id_see_users_invited_by, 0, 0)
			
			# Contractor Employee 3

				# Can grant membership to:
					# Groups created when we create the product
#					,(@contractor_3_bz_id, @create_case_group_id, 1, 0)
#					,(@contractor_3_bz_id, @can_edit_case_group_id, 1, 0)
#					,(@contractor_3_bz_id, @can_edit_all_field_case_group_id, 1, 0)
#					,(@contractor_3_bz_id, @can_edit_component_group_id, 1, 0)
#					,(@contractor_3_bz_id, @can_see_cases_group_id, 1, 0)
#					,(@contractor_3_bz_id, @all_g_flags_group_id, 1, 0)
#					,(@contractor_3_bz_id, @all_r_flags_group_id, 1, 0)
#					,(@contractor_3_bz_id, @list_visible_assignees_group_id, 1, 0)
#					,(@contractor_3_bz_id, @see_visible_assignees_group_id, 1, 0)
#					,(@contractor_3_bz_id, @active_stakeholder_group_id, 1, 0)
#					,(@contractor_3_bz_id, @unit_creator_group_id, 1, 0)
				
					# Groups created when we create the components
#					,(@contractor_3_bz_id, @group_id_show_to_landlord, 1, 0)
#					,(@contractor_3_bz_id, @group_id_are_users_landlord, 1, 0)
#					,(@contractor_3_bz_id, @group_id_see_users_landlord, 1, 0)
#					,(@contractor_3_bz_id, @group_id_show_to_agent, 1, 0)
#					,(@contractor_3_bz_id, @group_id_are_users_agent, 1, 0)
#					,(@contractor_3_bz_id, @group_id_see_users_agent, 1, 0)
#					,(@contractor_3_bz_id, @group_id_show_to_contractor, 1, 0)
#					,(@contractor_3_bz_id, @group_id_are_users_contractor, 1, 0)
#					,(@contractor_3_bz_id, @group_id_see_users_contractor, 1, 0)
#					,(@contractor_3_bz_id, @group_id_show_to_mgt_cny, 1, 0)
#					,(@contractor_3_bz_id, @group_id_are_users_mgt_cny, 1, 0)
#					,(@contractor_3_bz_id, @group_id_see_users_mgt_cny, 1, 0)
#					,(@contractor_3_bz_id, @group_id_are_users_invited_by, 1, 0)
#					,(@contractor_3_bz_id, @group_id_see_users_invited_by, 1, 0)
		
				# Is a member of:
					# Groups created when we create the product
					,(@contractor_3_bz_id, @create_case_group_id, 0, 0)
					,(@contractor_3_bz_id, @can_edit_case_group_id, 0, 0)
#					,(@contractor_3_bz_id, @can_edit_all_field_case_group_id, 0, 0)
#					,(@contractor_3_bz_id, @can_edit_component_group_id, 0, 0)
#					,(@contractor_3_bz_id, @can_see_cases_group_id, 0, 0)
#					,(@contractor_3_bz_id, @all_g_flags_group_id, 0, 0)
					,(@contractor_3_bz_id, @all_r_flags_group_id, 0, 0)
#					,(@contractor_3_bz_id, @list_visible_assignees_group_id, 0, 0)
#					,(@contractor_3_bz_id, @see_visible_assignees_group_id, 0, 0)
#					,(@contractor_3_bz_id, @active_stakeholder_group_id, 0, 0)
#					,(@contractor_3_bz_id, @unit_creator_group_id, 0, 0)
				
					# Groups created when we create the components
#					,(@contractor_3_bz_id, @group_id_show_to_landlord, 0, 0)
#					,(@contractor_3_bz_id, @group_id_are_users_landlord, 0, 0)
#					,(@contractor_3_bz_id, @group_id_see_users_landlord, 0, 0)
#					,(@contractor_3_bz_id, @group_id_show_to_agent, 0, 0)
#					,(@contractor_3_bz_id, @group_id_are_users_agent, 0, 0)
#					,(@contractor_3_bz_id, @group_id_see_users_agent, 0, 0)
					,(@contractor_3_bz_id, @group_id_show_to_contractor, 0, 0)
					,(@contractor_3_bz_id, @group_id_are_users_contractor, 0, 0)
					,(@contractor_3_bz_id, @group_id_see_users_contractor, 0, 0)
#					,(@contractor_3_bz_id, @group_id_show_to_mgt_cny, 0, 0)
#					,(@contractor_3_bz_id, @group_id_are_users_mgt_cny, 0, 0)
#					,(@contractor_3_bz_id, @group_id_see_users_mgt_cny, 0, 0)
					,(@contractor_3_bz_id, @group_id_are_users_invited_by, 0, 0)
#					,(@contractor_3_bz_id, @group_id_see_users_invited_by, 0, 0)
					
		# The mgt_cny and the mgt_cny employees
			# The Main user mgt_cny (Generic User):
				# Can grant membership to:
					# Groups created when we create the product
					,(@mgt_cny_1_bz_id, @create_case_group_id, 1, 0)
					,(@mgt_cny_1_bz_id, @can_edit_case_group_id, 1, 0)
					,(@mgt_cny_1_bz_id, @can_edit_all_field_case_group_id, 1, 0)
					,(@mgt_cny_1_bz_id, @can_edit_component_group_id, 1, 0)
					,(@mgt_cny_1_bz_id, @can_see_cases_group_id, 1, 0)
					,(@mgt_cny_1_bz_id, @all_g_flags_group_id, 1, 0)
					,(@mgt_cny_1_bz_id, @all_r_flags_group_id, 1, 0)
					,(@mgt_cny_1_bz_id, @list_visible_assignees_group_id, 1, 0)
					,(@mgt_cny_1_bz_id, @see_visible_assignees_group_id, 1, 0)
					,(@mgt_cny_1_bz_id, @active_stakeholder_group_id, 1, 0)
#					,(@mgt_cny_1_bz_id, @unit_creator_group_id, 1, 0)
				
					# Groups created when we create the components
#					,(@mgt_cny_1_bz_id, @group_id_show_to_landlord, 1, 0)
#					,(@mgt_cny_1_bz_id, @group_id_are_users_landlord, 1, 0)
#					,(@mgt_cny_1_bz_id, @group_id_see_users_landlord, 1, 0)
#					,(@mgt_cny_1_bz_id, @group_id_show_to_agent, 1, 0)
#					,(@mgt_cny_1_bz_id, @group_id_are_users_agent, 1, 0)
#					,(@mgt_cny_1_bz_id, @group_id_see_users_agent, 1, 0)
					,(@mgt_cny_1_bz_id, @group_id_show_to_contractor, 1, 0)
					,(@mgt_cny_1_bz_id, @group_id_are_users_contractor, 1, 0)
					,(@mgt_cny_1_bz_id, @group_id_see_users_contractor, 1, 0)
#					,(@mgt_cny_1_bz_id, @group_id_show_to_mgt_cny, 1, 0)
#					,(@mgt_cny_1_bz_id, @group_id_are_users_mgt_cny, 1, 0)
#					,(@mgt_cny_1_bz_id, @group_id_see_users_mgt_cny, 1, 0)
#					,(@mgt_cny_1_bz_id, @group_id_are_users_invited_by, 1, 0)
#					,(@mgt_cny_1_bz_id, @group_id_see_users_invited_by, 1, 0)
		
				# Is a member of:
					# Groups created when we create the product
					,(@mgt_cny_1_bz_id, @create_case_group_id, 0, 0)
					,(@mgt_cny_1_bz_id, @can_edit_case_group_id, 0, 0)
#					,(@mgt_cny_1_bz_id, @can_edit_all_field_case_group_id, 0, 0)
#					,(@mgt_cny_1_bz_id, @can_edit_component_group_id, 0, 0)
					,(@mgt_cny_1_bz_id, @can_see_cases_group_id, 0, 0)
					,(@mgt_cny_1_bz_id, @all_g_flags_group_id, 0, 0)
					,(@mgt_cny_1_bz_id, @all_r_flags_group_id, 0, 0)
					,(@mgt_cny_1_bz_id, @list_visible_assignees_group_id, 0, 0)
					,(@mgt_cny_1_bz_id, @see_visible_assignees_group_id, 0, 0)
					,(@mgt_cny_1_bz_id, @active_stakeholder_group_id, 0, 0)
#					,(@mgt_cny_1_bz_id, @unit_creator_group_id, 0, 0)
				
					# Groups created when we create the components
#					,(@mgt_cny_1_bz_id, @group_id_show_to_landlord, 0, 0)
#					,(@mgt_cny_1_bz_id, @group_id_are_users_landlord, 0, 0)
#					,(@mgt_cny_1_bz_id, @group_id_see_users_landlord, 0, 0)
#					,(@mgt_cny_1_bz_id, @group_id_show_to_agent, 0, 0)
#					,(@mgt_cny_1_bz_id, @group_id_are_users_agent, 0, 0)
#					,(@mgt_cny_1_bz_id, @group_id_see_users_agent, 0, 0)
					,(@mgt_cny_1_bz_id, @group_id_show_to_contractor, 0, 0)
					,(@mgt_cny_1_bz_id, @group_id_are_users_contractor, 0, 0)
					,(@mgt_cny_1_bz_id, @group_id_see_users_contractor, 0, 0)
#					,(@mgt_cny_1_bz_id, @group_id_show_to_mgt_cny, 0, 0)
#					,(@mgt_cny_1_bz_id, @group_id_are_users_mgt_cny, 0, 0)
#					,(@mgt_cny_1_bz_id, @group_id_see_users_mgt_cny, 0, 0)
					,(@mgt_cny_1_bz_id, @group_id_are_users_invited_by, 0, 0)
#					,(@mgt_cny_1_bz_id, @group_id_see_users_invited_by, 0, 0)
					
			# mgt_cny Employee 1 (Visible only to Contractor-no rights to approve or ask for approval)
			
				# Can grant membership to:
					# Groups created when we create the product
#					,(@mgt_cny_2_bz_id, @create_case_group_id, 1, 0)
#					,(@mgt_cny_2_bz_id, @can_edit_case_group_id, 1, 0)
#					,(@mgt_cny_2_bz_id, @can_edit_all_field_case_group_id, 1, 0)
#					,(@mgt_cny_2_bz_id, @can_edit_component_group_id, 1, 0)
#					,(@mgt_cny_2_bz_id, @can_see_cases_group_id, 1, 0)
#					,(@mgt_cny_2_bz_id, @all_g_flags_group_id, 1, 0)
#					,(@mgt_cny_2_bz_id, @all_r_flags_group_id, 1, 0)
#					,(@mgt_cny_2_bz_id, @list_visible_assignees_group_id, 1, 0)
#					,(@mgt_cny_2_bz_id, @see_visible_assignees_group_id, 1, 0)
#					,(@mgt_cny_2_bz_id, @active_stakeholder_group_id, 1, 0)
#					,(@mgt_cny_2_bz_id, @unit_creator_group_id, 1, 0)
				
					# Groups created when we create the components
#					,(@mgt_cny_2_bz_id, @group_id_show_to_landlord, 1, 0)
#					,(@mgt_cny_2_bz_id, @group_id_are_users_landlord, 1, 0)
#					,(@mgt_cny_2_bz_id, @group_id_see_users_landlord, 1, 0)
#					,(@mgt_cny_2_bz_id, @group_id_show_to_agent, 1, 0)
#					,(@mgt_cny_2_bz_id, @group_id_are_users_agent, 1, 0)
#					,(@mgt_cny_2_bz_id, @group_id_see_users_agent, 1, 0)
#					,(@mgt_cny_2_bz_id, @group_id_show_to_contractor, 1, 0)
#					,(@mgt_cny_2_bz_id, @group_id_are_users_contractor, 1, 0)
#					,(@mgt_cny_2_bz_id, @group_id_see_users_contractor, 1, 0)
#					,(@mgt_cny_2_bz_id, @group_id_show_to_mgt_cny, 1, 0)
#					,(@mgt_cny_2_bz_id, @group_id_are_users_mgt_cny, 1, 0)
#					,(@mgt_cny_2_bz_id, @group_id_see_users_mgt_cny, 1, 0)
#					,(@mgt_cny_2_bz_id, @group_id_are_users_invited_by, 1, 0)
#					,(@mgt_cny_2_bz_id, @group_id_see_users_invited_by, 1, 0)
		
				# Is a member of:
					# Groups created when we create the product
					,(@mgt_cny_2_bz_id, @create_case_group_id, 0, 0)
					,(@mgt_cny_2_bz_id, @can_edit_case_group_id, 0, 0)
#					,(@mgt_cny_2_bz_id, @can_edit_all_field_case_group_id, 0, 0)
#					,(@mgt_cny_2_bz_id, @can_edit_component_group_id, 0, 0)
#					,(@mgt_cny_2_bz_id, @can_see_cases_group_id, 0, 0)
#					,(@mgt_cny_2_bz_id, @all_g_flags_group_id, 0, 0)
					,(@mgt_cny_2_bz_id, @all_r_flags_group_id, 0, 0)
#					,(@mgt_cny_2_bz_id, @list_visible_assignees_group_id, 0, 0)
#					,(@mgt_cny_2_bz_id, @see_visible_assignees_group_id, 0, 0)
#					,(@mgt_cny_2_bz_id, @active_stakeholder_group_id, 0, 0)
#					,(@mgt_cny_2_bz_id, @unit_creator_group_id, 0, 0)
				
					# Groups created when we create the components
#					,(@mgt_cny_2_bz_id, @group_id_show_to_landlord, 0, 0)
#					,(@mgt_cny_2_bz_id, @group_id_are_users_landlord, 0, 0)
#					,(@mgt_cny_2_bz_id, @group_id_see_users_landlord, 0, 0)
#					,(@mgt_cny_2_bz_id, @group_id_show_to_agent, 0, 0)
#					,(@mgt_cny_2_bz_id, @group_id_are_users_agent, 0, 0)
#					,(@mgt_cny_2_bz_id, @group_id_see_users_agent, 0, 0)
					,(@mgt_cny_2_bz_id, @group_id_show_to_contractor, 0, 0)
					,(@mgt_cny_2_bz_id, @group_id_are_users_contractor, 0, 0)
					,(@mgt_cny_2_bz_id, @group_id_see_users_contractor, 0, 0)
#					,(@mgt_cny_2_bz_id, @group_id_show_to_mgt_cny, 0, 0)
#					,(@mgt_cny_2_bz_id, @group_id_are_users_mgt_cny, 0, 0)
#					,(@mgt_cny_2_bz_id, @group_id_see_users_mgt_cny, 0, 0)
					,(@mgt_cny_2_bz_id, @group_id_are_users_invited_by, 0, 0)
#					,(@mgt_cny_2_bz_id, @group_id_see_users_invited_by, 0, 0)
			
			# mgt_cny Employee 2

				# Can grant membership to:
					# Groups created when we create the product
#					,(@mgt_cny_3_bz_id, @create_case_group_id, 1, 0)
#					,(@mgt_cny_3_bz_id, @can_edit_case_group_id, 1, 0)
#					,(@mgt_cny_3_bz_id, @can_edit_all_field_case_group_id, 1, 0)
#					,(@mgt_cny_3_bz_id, @can_edit_component_group_id, 1, 0)
#					,(@mgt_cny_3_bz_id, @can_see_cases_group_id, 1, 0)
#					,(@mgt_cny_3_bz_id, @all_g_flags_group_id, 1, 0)
#					,(@mgt_cny_3_bz_id, @all_r_flags_group_id, 1, 0)
#					,(@mgt_cny_3_bz_id, @list_visible_assignees_group_id, 1, 0)
#					,(@mgt_cny_3_bz_id, @see_visible_assignees_group_id, 1, 0)
#					,(@mgt_cny_3_bz_id, @active_stakeholder_group_id, 1, 0)
#					,(@mgt_cny_3_bz_id, @unit_creator_group_id, 1, 0)
				
					# Groups created when we create the components
#					,(@mgt_cny_3_bz_id, @group_id_show_to_landlord, 1, 0)
#					,(@mgt_cny_3_bz_id, @group_id_are_users_landlord, 1, 0)
#					,(@mgt_cny_3_bz_id, @group_id_see_users_landlord, 1, 0)
#					,(@mgt_cny_3_bz_id, @group_id_show_to_agent, 1, 0)
#					,(@mgt_cny_3_bz_id, @group_id_are_users_agent, 1, 0)
#					,(@mgt_cny_3_bz_id, @group_id_see_users_agent, 1, 0)
#					,(@mgt_cny_3_bz_id, @group_id_show_to_contractor, 1, 0)
#					,(@mgt_cny_3_bz_id, @group_id_are_users_contractor, 1, 0)
#					,(@mgt_cny_3_bz_id, @group_id_see_users_contractor, 1, 0)
#					,(@mgt_cny_3_bz_id, @group_id_show_to_mgt_cny, 1, 0)
#					,(@mgt_cny_3_bz_id, @group_id_are_users_mgt_cny, 1, 0)
#					,(@mgt_cny_3_bz_id, @group_id_see_users_mgt_cny, 1, 0)
#					,(@mgt_cny_3_bz_id, @group_id_are_users_invited_by, 1, 0)
#					,(@mgt_cny_3_bz_id, @group_id_see_users_invited_by, 1, 0)
		
				# Is a member of:
					# Groups created when we create the product
					,(@mgt_cny_3_bz_id, @create_case_group_id, 0, 0)
					,(@mgt_cny_3_bz_id, @can_edit_case_group_id, 0, 0)
#					,(@mgt_cny_3_bz_id, @can_edit_all_field_case_group_id, 0, 0)
#					,(@mgt_cny_3_bz_id, @can_edit_component_group_id, 0, 0)
#					,(@mgt_cny_3_bz_id, @can_see_cases_group_id, 0, 0)
#					,(@mgt_cny_3_bz_id, @all_g_flags_group_id, 0, 0)
					,(@mgt_cny_3_bz_id, @all_r_flags_group_id, 0, 0)
#					,(@mgt_cny_3_bz_id, @list_visible_assignees_group_id, 0, 0)
#					,(@mgt_cny_3_bz_id, @see_visible_assignees_group_id, 0, 0)
#					,(@mgt_cny_3_bz_id, @active_stakeholder_group_id, 0, 0)
#					,(@mgt_cny_3_bz_id, @unit_creator_group_id, 0, 0)
				
					# Groups created when we create the components
#					,(@mgt_cny_3_bz_id, @group_id_show_to_landlord, 0, 0)
#					,(@mgt_cny_3_bz_id, @group_id_are_users_landlord, 0, 0)
#					,(@mgt_cny_3_bz_id, @group_id_see_users_landlord, 0, 0)
#					,(@mgt_cny_3_bz_id, @group_id_show_to_agent, 0, 0)
#					,(@mgt_cny_3_bz_id, @group_id_are_users_agent, 0, 0)
#					,(@mgt_cny_3_bz_id, @group_id_see_users_agent, 0, 0)
					,(@mgt_cny_3_bz_id, @group_id_show_to_contractor, 0, 0)
					,(@mgt_cny_3_bz_id, @group_id_are_users_contractor, 0, 0)
					,(@mgt_cny_3_bz_id, @group_id_see_users_contractor, 0, 0)
#					,(@mgt_cny_3_bz_id, @group_id_show_to_mgt_cny, 0, 0)
#					,(@mgt_cny_3_bz_id, @group_id_are_users_mgt_cny, 0, 0)
#					,(@mgt_cny_3_bz_id, @group_id_see_users_mgt_cny, 0, 0)
					,(@mgt_cny_3_bz_id, @group_id_are_users_invited_by, 0, 0)
#					,(@mgt_cny_3_bz_id, @group_id_see_users_invited_by, 0, 0)
				;

#################
#
# WIP
#
#		
#	INSERT  INTO `ut_series_categories`
#		(`id`
#		,`name`
#		) 
#		VALUES 
#		(NULL,CONCAT(@stakeholder,'_#',@product_id)),
#		(NULL,CONCAT(@unit,'_#',@product_id));
#
#	SET @series_2 = (SELECT `id` FROM `ut_series_categories` WHERE `name` = '-All-');
#	SET @series_1 = (SELECT `id` FROM `ut_series_categories` WHERE `name` = CONCAT(@stakeholder,'_#',@product_id));
#	SET @series_3 = (SELECT `id` FROM `ut_series_categories` WHERE `name` = CONCAT(@unit,'_#',@product_id));
#
#	INSERT  INTO `ut_series`
#		(`series_id`
#		,`creator`
#		,`category`
#		,`subcategory`
#		,`name`
#		,`frequency`
#		,`query`
#		,`is_public`
#		) 
#		VALUES 
#		(NULL,@bz_user_id,@series_1,@series_2,'UNCONFIRMED',1,CONCAT('bug_status=UNCONFIRMED&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_2,'CONFIRMED',1,CONCAT('bug_status=CONFIRMED&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_2,'IN_PROGRESS',1,CONCAT('bug_status=IN_PROGRESS&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_2,'REOPENED',1,CONCAT('bug_status=REOPENED&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_2,'STAND BY',1,CONCAT('bug_status=STAND%20BY&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_2,'RESOLVED',1,CONCAT('bug_status=RESOLVED&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_2,'VERIFIED',1,CONCAT('bug_status=VERIFIED&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_2,'CLOSED',1,CONCAT('bug_status=CLOSED&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_2,'FIXED',1,CONCAT('resolution=FIXED&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_2,'INVAL`status_workflow`ID',1,CONCAT('resolution=INVAL%60status_workflow%60ID&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_2,'WONTFIX',1,CONCAT('resolution=WONTFIX&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_2,'DUPLICATE',1,CONCAT('resolution=DUPLICATE&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_2,'WORKSFORME',1,CONCAT('resolution=WORKSFORME&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_2,'All Open',1,CONCAT('bug_status=UNCONFIRMED&bug_status=CONFIRMED&bug_status=IN_PROGRESS&bug_status=REOPENED&bug_status=STAND%20BY&product=',@unit_for_query),1),
#		(NULL,@bz_user_id,@series_1,@series_3,'All Open',1,CONCAT('field0-0-0=resolution&type0-0-0=notregexp&value0-0-0=.&product=',@unit_for_query,'&component=',@stakeholder),1),
#		(NULL,@bz_user_id,@series_1,@series_3,'All Closed',1,CONCAT('field0-0-0=resolution&type0-0-0=regexp&value0-0-0=.&product=',@unit_for_query,'&component=',@stakeholder),1);
#
#	INSERT  INTO `ut_audit_log`
#		(`user_id`
#		,`class`
#		,`object_id`
#		,`field`
#		,`removed`
#		,`added`
#		,`at_time`
#		) 
#		VALUES 
#		(@bz_user_id,'Bugzilla::Component',@component_id,'__create__',NULL,@stakeholder,@timestamp),
#		(@bz_user_id,'Bugzilla::Group',@show_to_stakeholder_4_group_id,'__create__',NULL,CONCAT(@unit,' #',@product_id,'-',(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 4)),@timestamp),
#		(@bz_user_id,'Bugzilla::Group',@are_users_stakeholder_4_group_id,'__create__',NULL,CONCAT(@unit,' #',@product_id,'-List users-',(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 4)),@timestamp),
#		(@bz_user_id,'Bugzilla::Group',@see_users_stakeholder_4_group_id,'__create__',NULL,CONCAT(@unit,' #',@product_id,'-Can see who are stakeholder for comp #',@component_id),@timestamp),
#		(@bz_user_id,'Bugzilla::Group',@invited_by_group_id,'__create__',NULL,CONCAT(@unit,' #',@product_id,'-invited by user ',@creator_pub_name),@timestamp),
#		(@bz_user_id,'Bugzilla::Group',@see_invited_by_group_id,'__create__',NULL,CONCAT(@unit,' #',@product_id,'-Can see user invited by ',@creator_pub_name),@timestamp);
#
#
#####################
	
	SET loop_component_rest= (loop_component_rest + 1);
	SET FOREIGN_KEY_CHECKS = 1;
END WHILE;
END$$
DELIMITER ;
CALL insert_component_rest;

# We give the user the permission they need.
# We need to do that via an intermediaary table to make sure that we dedup the permissions

	INSERT INTO `user_group_map`
	SELECT
		`user_id`
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











/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
