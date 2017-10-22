# Contact Franck for any question about this script
# 
# IF the user is an OCCUPANT, we create the group that will allow us to
# restrict visibility on a bug/case per bug/case basis
#
# This script: 
#  - Creates the groups we need for the product @unit
#  - For the stakeholder/component: @stakeholder (based on the role chosen by the user)
#  - Define the permissions (based on group memberships).
#
# This script requires several variables: see below
#  
#  
# These are user input (from the MEFE).
	SET @unit = 'UN-1 - CAUN-A';
	# Is this user an occupant of the unit?
	SET @is_occupant = 1;
	# User role: this is an id in the table `ut_role_types` for easier manipulation, update and maintenance
	SET @role_type_id = 1;

# We Need the BZ user information too
	SET @login_name = 'leonel@example.com';
	SET @bz_user_id = 2;
	# We need the BZ product_id for the unit too - We are going to assume that it'll be provided by the MEFE:
	SET @product_id = 2;

# The way we phrase the explanation might change - moving this to a variable for better flexibility
	SET @explanation = 'Tick to HIDE this case if the user is an occupant for this unit. Untick to Show this case';

# We have everything - Let's do this!

	#Get the additional variable that we need
	SET @timestamp = NOW();
	SET @stakeholder = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=@role_type_id);
	SET @creator_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id`=@product_id) AND `group_type_id`=1);
	
	# First we disable the FK check
	SET FOREIGN_KEY_CHECKS = 0;

	/*Data for the table `groups` */
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
		(NULL,CONCAT(@unit,' #',@product_id,' - is occupant'),@explanation,1,'',1,NULL);
	
	# Get the variable we need:
	SET @show_bug_to_occupant_group_id = LAST_INSERT_ID();

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
		# 3 = occupant
		(@product_id,@show_bug_to_occupant_group_id,3,@role_type_id,@timestamp);

	/*Data for the table `user_group_map` */
	# We add the BZ user to the relevant tables
	INSERT  INTO `user_group_map`
		(`user_id`
		,`group_id`
		,`isbless`
		,`grant_type`
		) 
		VALUES 
		(@bz_user_id,@show_bug_to_occupant_group_id,0,0);

	/*Data for the table `group_group_map` */

	INSERT  INTO `group_group_map`
		(
		`member_id`
		,`grantor_id`
		,`grant_type`
		) 
		VALUES 
		# We keep that for testing
		# we We DO NOT WANT THE ADMINISTRATOR (user id = 1) TO SEE AND MANAGE ALL THESE GROUPS after testing is finished... 
		(1,@show_bug_to_occupant_group_id,1),
		(1,@show_bug_to_occupant_group_id,2),
		# END
		# Member_id is a group_id
		# grantor_id is a group_id
		# We probably want the initial user id to be able to do that
		# This is so that the BZ APIs work as intended
		(@creator_group_id,@show_bug_to_occupant_group_id,0),
		(@creator_group_id,@show_bug_to_occupant_group_id,1),
		(@creator_group_id,@show_bug_to_occupant_group_id,2),
		# User in a group can always see the other people in this group
		(@show_bug_to_occupant_group_id,@show_bug_to_occupant_group_id,2);

	/*Data for the table `group_control_map` */
	# This is where we decide who can access which bug/case (tick/untick the visibility option in a case).
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
		(@show_bug_to_occupant_group_id,@product_id,1,1,3,0,0,1,1);

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
		(@bz_user_id,'Bugzilla::Group',@show_bug_to_occupant_group_id,'__create__',NULL,CONCAT(@unit,' #',@product_id,' - is occupant'),@timestamp);

	# We enable the FK check back
	SET FOREIGN_KEY_CHECKS = 1;

# Cleanup after: flush the variables
SET @timestamp = NULL;
SET @unit = NULL;
SET @product_id = NULL;
SET @stakeholder = NULL;
SET @login_name = NULL;
SET @bz_user_id = NULL;
SET @is_occupant = NULL;
SET @product_id = NULL;
SET @show_bug_to_occupant_group_id = NULL;
SET @explanation = NULL;