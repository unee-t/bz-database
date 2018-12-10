# For any question about this script, ask Franck
#
###################################################################################
#
# WARNING! 
#	- It is MANDATORY to use Amazon Aurora database engine for this version
#
# Make sure to also update the below variable(s)
#
###################################################################################
#
# What are the version of the Unee-T BZ Database schema BEFORE and AFTER this update?
	SET @old_schema_version = 'v3.27';
	SET @new_schema_version = 'v3.28';
#
# What is the name of this script?
	SET @this_script = 'upgrade_unee-t_v3.27_to_v3.28.sql';
#
###############################
#
# We have everything we need
#
###############################
# This update
#
#   - Create a generic procedure `update_audit_log` that we use each time a record is updated for the tables
#       - `user_group_map`
#       - `products`
#       - `versions`
#       - `milestones`
#       - `components`
#       - `component_cc`
#       - `groups`
#       - `flagtypes`
#       - `flaginclusions`
#       - `group_control_map`
#       - `group_group_map`
#       - `ut_product_group`
#       - `series_categories`
#       - `series`
#       - `ut_data_to_create_units`
#       - `ut_invitation_api_data`
#
#   - Move the audit log function outside the scripts in dedicated trigger when we
#       - INSERT records in the tables
#           - `user_group_map`
#           - `products`
#           - `versions`
#           - `milestones`
#           - `components`
#           - `component_cc`
#           - `groups`
#           - `flagtypes`
#           - `flaginclusions`
#           - `group_control_map`
#           - `ut_product_group`
#           - `ut_data_to_create_units`
#           - `group_group_map`
#WIP       - `series_categories`
#WIP       - `series`
#WIP       - `ut_invitation_api_data`
#
#       - DELETE records in the tables
#           - `user_group_map`
#           - `products`
#           - `versions`
#           - `milestones`
#           - `components`
#           - `component_cc`
#           - `groups`
#           - `flagtypes`
#           - `flaginclusions`
#           - `group_control_map`
#           - `ut_product_group`
#           - `ut_data_to_create_units`
#           - `group_group_map`
#WIP       - `series_categories`
#WIP       - `series`
#WIP       - `ut_invitation_api_data`
#
#       - UPDATE records in the tables
#           - `user_group_map`
#           - `products`
#           - `versions`
#           - `milestones`
#           - `components`
#           - `component_cc`
#           - `groups`
#           - `flagtypes`
#           - `flaginclusions`
#           - `group_control_map`
#           - `ut_product_group`
#           - `ut_data_to_create_units`
#           - `group_group_map`
#WIP       - `series_categories`
#WIP       - `series`
#WIP       - `ut_invitation_api_data`
#
#   - Cleanup drop the following tables (will be replaced by temp tables)
#           - `ut_group_group_map_dedup`
#           - `ut_temp_dummy_users_for_roles`
#           - `user_group_map_dedup`
#           - `ut_group_group_map_temp`
#           - `ut_user_group_map_temp`
#
#   - Upgrade the procedure `update_permissions_invited_user`
#       - Use Temporary table to do the deduplication of records
#         This is to avoid deleting the table for all the concurrent procedures which can create a race condition
#
#   - Update the procedure `table_to_list_dummy_user_by_environment` to create the dummy environment table so it uses a temporary table
#
#   - Update the procedure `add_user_to_role_in_unit` 
#       - Make sure we do NOT call the procedure `create_temp_table_to_update_permissions`
#       - Minor improvements to the code
#
#WIP   - Upgrade the procedure `create_temp_table_to_update_group_permissions`
#     Make sure we use tenporary SQL tables.
#
#WIP   - Upgrade the procedure `create_temp_table_to_update_permissions`
#     Make sure we use tenporary SQL tables.
#
#   - Upgrade the procedure `unit_create_with_dummy_users`
#       - In the `products` table, we start by trying to predict the next available id for a record
#       - Make sure we record the actual id of each inserted record
#         (use the MySQL command LAST_INSERT_ID() after the object was created)
#           - `products`
#           - `version`
#           - `milestones`
#           - `components`
#           - `groups`
#           - `flagtypes`
#           - `series_categories`
#           - NOT NEEDED
#               - `flaginclusions` - there is no autoincrement id there.
#               - `group_control_map` - there is no autoincrement id there.
#               - `series` ---> we do not maintain a log of this (yet)
#       - Improve logs
#          - Insert one line in the table `ut_script_log` for each component created 
#            BEFORE: only 1 line for all the components (less precise)
#          - Insert one line in the table `ut_script_log` for each group created 
#            BEFORE: only 1 line for all the groups (less precise)
#          - Insert one line in the table `ut_script_log` for each flagtypes created
#            BEFORE: only 1 line for all the flagtypes (less precise)
#       - Use Temporary table to do the deduplication of records:
#           - `ut_group_group_map_dedup`
#             This is to avoid deleting the table for all the concurrent procedures which can create a race condition
#
#   - Update the procedure `remove_user_from_default_cc` to remove a user in Default CC from a given role
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#   - Update the procedure `remove_user_from_role`
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#   - Update the procedure `revoke_all_permission_for_this_user_in_this_unit`
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#   - Update the procedure `user_in_default_cc_for_cases`
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#       - Use a temporary table
#       - Create a dedicated dedup table so we do not have to truncate the table when we add records
#
#   - Update the procedure `user_is_default_assignee_for_cases`
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure `default_contractor_see_users_contractor`
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure `default_agent_see_users_agent`
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure `are_users_agent`
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure `show_to_agent`
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure `are_users_contractor`
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure `show_to_contractor`
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure `default_landlord_see_users_landlord`
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure `are_users_landlord`
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure `show_to_landlord`
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure `default_mgt_cny_see_users_mgt_cny`
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure `are_users_mgt_cny`
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure `show_to_mgt_cny`
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure `default_tenant_see_users_tenant`
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure `are_users_tenant`
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure `show_to_tenant`
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
##
#
#WIP   - Update the procedure ``
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure ``
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure ``
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure ``
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure ``
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure ``
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure ``
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure ``
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#
#WIP   - Update the procedure ``
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#

#####################
#
# Do it!
#
#####################

# When are we doing this?
	SET @the_timestamp = NOW();

# Create a procedure that will update the audit log each time a new record is created in the `user_group_map` table

    DROP PROCEDURE IF EXISTS `update_audit_log`;

DELIMITER $$
CREATE PROCEDURE `update_audit_log`()
SQL SECURITY INVOKER
BEGIN

    # This procedure need the following variables
    #   - @bzfe_table: the table that was updated
    #   - @bzfe_field: The fields that were updated
    #   - @previous_value: The previouso value for the field
    #   - @new_value: the values captured by the trigger when the new value is inserted.
    #   - @script: the script that is calling this procedure
    #   - @comment: a text to give some context ex: "this was created by a trigger xxx"
 
	# When are we doing this?
        SET @timestamp = NOW(); 

    # We update the audit_log table
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
            (@timestamp
            , @bzfe_table
            , @bzfe_field
            , @previous_value
            , @new_value
            , @script
            , @comment
            )
        ;

END $$
DELIMITER ;

# The `user_group_map` table

    # INSERT TRIGGER Create a trigger that calls the relevant procedure each time a record is added to the table `user_group_map`

    DROP TRIGGER IF EXISTS `trig_update_audit_log_new_record_user_group_map`;

DELIMITER $$
CREATE TRIGGER `trig_update_audit_log_new_record_user_group_map`
    AFTER INSERT ON `user_group_map`
    FOR EACH ROW
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_user_id = new.user_id;
        SET @new_group_id = new.group_id;
        SET @new_isbless = new.isbless;
        SET @new_grant_type = new.grant_type;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'user_group_map';
        SET @bzfe_field = 'user_id, group_id, isbless, grant_type';
        SET @previous_value = NULL;
        SET @new_value = CONCAT (
                @new_user_id
                , ', '
                , @new_group_id
                , ', '
                , @new_isbless
                , ', '
                , @new_grant_type
            )
           ;
        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_new_record_user_group_map';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END;
$$
DELIMITER ;
            
    # DELETE TRIGGER Create a trigger that calls the relevant procedure each time a record is deleted in the table `user_group_map`

    DROP TRIGGER IF EXISTS `trig_update_audit_log_delete_record_user_group_map`;

DELIMITER $$
CREATE TRIGGER `trig_update_audit_log_delete_record_user_group_map`
    AFTER DELETE ON `user_group_map`
    FOR EACH ROW
  BEGIN

    # We capture the old values of each fields in dedicated variables:
        SET @old_user_id = old.user_id;
        SET @old_group_id = old.group_id;
        SET @old_isbless = old.isbless;
        SET @old_grant_type = old.grant_type;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'user_group_map';
        SET @bzfe_field = 'user_id, group_id, isbless, grant_type';
        SET @previous_value = CONCAT (
                @old_user_id
                , ', '
                , @old_group_id
                , ', '
                , @old_isbless
                , ', '
                , @old_grant_type
            );
        SET @new_value = NULL;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_delete_record_user_group_map';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END;
$$
DELIMITER ;

    # UPDATE TRIGGER Create a trigger that calls the relevant procedure each time a record is updated in the table `user_group_map`

    DROP TRIGGER IF EXISTS `trig_update_audit_log_update_record_user_group_map`;

DELIMITER $$
CREATE TRIGGER `trig_update_audit_log_update_record_user_group_map`
    AFTER UPDATE ON `user_group_map`
    FOR EACH ROW
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_user_id = new.user_id;
        SET @new_group_id = new.group_id;
        SET @new_isbless = new.isbless;
        SET @new_grant_type = new.grant_type;

    # We capture the old values of each fields in dedicated variables:
        SET @old_user_id = old.user_id;
        SET @old_group_id = old.group_id;
        SET @old_isbless = old.isbless;
        SET @old_grant_type = old.grant_type;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'user_group_map';
        SET @bzfe_field = 'user_id, group_id, isbless, grant_type';
        SET @previous_value = CONCAT (
                @old_user_id
                , ', '
                , @old_group_id
                , ', '
                , @old_isbless
                , ', '
                , @old_grant_type
                )
                ;
        SET @new_value = CONCAT (
                @new_user_id
                , ', '
                , @new_group_id
                , ', '
                , @new_isbless
                , ', '
                , @new_grant_type
                )
                ;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_update_record_user_group_map';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END;
$$
DELIMITER ;

# The `products` table

    # INSERT TRIGGER Create a trigger that calls the relevant procedure each time a record is added to the table `products`

    DROP TRIGGER IF EXISTS `trig_update_audit_log_new_record_products`;

DELIMITER $$
CREATE TRIGGER `trig_update_audit_log_new_record_products`
    AFTER INSERT ON `products`
    FOR EACH ROW
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_name = new.name;
        SET @new_classification_id = new.classification_id;
        SET @new_description = new.description;
        SET @new_isactive = new.isactive;
        SET @new_defaultmilestone = new.defaultmilestone;
        SET @new_allows_unconfirmed = new.allows_unconfirmed;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'products';
        SET @bzfe_field = 'name, classification_id, description, isactive, defaultmilestone, allows_unconfirmed';
        SET @previous_value = NULL;
        SET @new_value = CONCAT (
                @new_name
                , ', '
                , @new_classification_id
                , ', '
                , @new_description
                , ', '
                , @new_isactive
                , ', '
                , @new_defaultmilestone
                , ', '
                , @new_allows_unconfirmed
            )
           ;
        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_new_record_products';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END;
$$
DELIMITER ;
            
    # DELETE TRIGGER Create a trigger that calls the relevant procedure each time a record is deleted in the table `products`

    DROP TRIGGER IF EXISTS `trig_update_audit_log_delete_record_products`;

DELIMITER $$
CREATE TRIGGER `trig_update_audit_log_delete_record_products`
    AFTER DELETE ON `products`
    FOR EACH ROW
  BEGIN

    # We capture the old values of each fields in dedicated variables:
        SET @old_name = old.name;
        SET @old_classification_id = old.classification_id;
        SET @old_description = old.description;
        SET @old_isactive = old.isactive;
        SET @old_defaultmilestone = old.defaultmilestone;
        SET @old_allows_unconfirmed = old.allows_unconfirmed;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'products';
        SET @bzfe_field = 'name, classification_id, description, isactive, defaultmilestone, allows_unconfirmed';
        SET @previous_value = CONCAT (
                @old_name
                , ', '
                , @old_classification_id
                , ', '
                , @old_description
                , ', '
                , @old_isactive
                , ', '
                , @old_defaultmilestone
                , ', '
                , @old_allows_unconfirmed
            )
           ;
        SET @new_value = NULL;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_delete_record_products';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END;
$$
DELIMITER ;

    # UPDATE TRIGGER Create a trigger that calls the relevant procedure each time a record is updated in the table `products`

    DROP TRIGGER IF EXISTS `trig_update_audit_log_update_record_products`;

DELIMITER $$
CREATE TRIGGER `trig_update_audit_log_update_record_products`
    AFTER UPDATE ON `products`
    FOR EACH ROW
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_name = new.name;
        SET @new_classification_id = new.classification_id;
        SET @new_description = new.description;
        SET @new_isactive = new.isactive;
        SET @new_defaultmilestone = new.defaultmilestone;
        SET @new_allows_unconfirmed = new.allows_unconfirmed;

    # We capture the old values of each fields in dedicated variables:
        SET @old_name = old.name;
        SET @old_classification_id = old.classification_id;
        SET @old_description = old.description;
        SET @old_isactive = old.isactive;
        SET @old_defaultmilestone = old.defaultmilestone;
        SET @old_allows_unconfirmed = old.allows_unconfirmed;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'products';
        SET @bzfe_field = 'name, classification_id, description, isactive, defaultmilestone, allows_unconfirmed';
        SET @previous_value = CONCAT (
                @old_name
                , ', '
                , @old_classification_id
                , ', '
                , @old_description
                , ', '
                , @old_isactive
                , ', '
                , @old_defaultmilestone
                , ', '
                , @old_allows_unconfirmed
            )
           ;
        SET @new_value = CONCAT (
                 @new_name
                , ', '
                , @new_classification_id
                , ', '
                , @new_description
                , ', '
                , @new_isactive
                , ', '
                , @new_defaultmilestone
                , ', '
                , @new_allows_unconfirmed
            )
           ;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_update_record_products';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END;
$$
DELIMITER ;

# The `versions` table

    # INSERT TRIGGER Create a trigger that calls the relevant procedure each time a record is added to the table `versions`

    DROP TRIGGER IF EXISTS `trig_update_audit_log_new_record_versions`;

DELIMITER $$
CREATE TRIGGER `trig_update_audit_log_new_record_versions`
    AFTER INSERT ON `versions`
    FOR EACH ROW
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_id = new.id;
        SET @new_value = new.value;
        SET @new_product_id = new.product_id;
        SET @new_isactive = new.isactive;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'versions';
        SET @bzfe_field = 'id, value, product_id, isactive';
        SET @previous_value = NULL;
        SET @new_value = CONCAT (
                @new_id
                , ', '
                , @new_value
                , ', '
                , @new_product_id
                , ', '
                , @new_isactive
            )
           ;
        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_new_record_versions';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END;
$$
DELIMITER ;
            
    # DELETE TRIGGER Create a trigger that calls the relevant procedure each time a record is deleted in the table `versions`

    DROP TRIGGER IF EXISTS `trig_update_audit_log_delete_record_versions`;

DELIMITER $$
CREATE TRIGGER `trig_update_audit_log_delete_record_versions`
    AFTER DELETE ON `versions`
    FOR EACH ROW
  BEGIN

    # We capture the old values of each fields in dedicated variables:
        SET @old_id = old.id;
        SET @old_value = old.value;
        SET @old_product_id = old.product_id;
        SET @old_isactive = old.isactive;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'versions';
        SET @bzfe_field = 'id, value, product_id, isactive';
        SET @previous_value = CONCAT (
                @old_id
                , ', '
                , @old_value
                , ', '
                , @old_product_id
                , ', '
                , @old_isactive
            )
           ;
        SET @new_value = NULL;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_delete_record_versions';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END;
$$
DELIMITER ;

    # UPDATE TRIGGER Create a trigger that calls the relevant procedure each time a record is updated in the table `versions`

    DROP TRIGGER IF EXISTS `trig_update_audit_log_update_record_versions`;

DELIMITER $$
CREATE TRIGGER `trig_update_audit_log_update_record_versions`
    AFTER UPDATE ON `versions`
    FOR EACH ROW
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_id = new.id;
        SET @new_value = new.value;
        SET @new_product_id = new.product_id;
        SET @new_isactive = new.isactive;

    # We capture the old values of each fields in dedicated variables:
        SET @old_id = old.id;
        SET @old_value = old.value;
        SET @old_product_id = old.product_id;
        SET @old_isactive = old.isactive;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'versions';
        SET @bzfe_field = 'id, value, product_id, isactive';
        SET @previous_value = CONCAT (
                @old_id
                , ', '
                , @old_value
                , ', '
                , @old_product_id
                , ', '
                , @old_isactive
            )
           ;
        SET @new_value = CONCAT (
                @new_id
                , ', '
                , @new_value
                , ', '
                , @new_product_id
                , ', '
                , @new_isactive
            )
           ;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_update_record_versions';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END;
$$
DELIMITER ;

# The `milestones` table

    # INSERT TRIGGER Create a trigger that calls the relevant procedure each time a record is added to the table `milestones`

    DROP TRIGGER IF EXISTS `trig_update_audit_log_new_record_milestones`;

DELIMITER $$
CREATE TRIGGER `trig_update_audit_log_new_record_milestones`
    AFTER INSERT ON `milestones`
    FOR EACH ROW
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_id = new.id;
        SET @new_product_id = new.product_id;
        SET @new_value = new.value;
        SET @new_sortkey = new.sortkey;
        SET @new_isactive = new.isactive;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'milestones';
        SET @bzfe_field = 'id, product_id, value, sortkey, isactive';
        SET @previous_value = NULL;
        SET @new_value = CONCAT (
                @new_id
                , ', '
                , @new_product_id
                , ', '
                , @new_value
                , ', '
                , @new_sortkey
                , ', '
                , @new_isactive
            )
           ;
        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_new_record_milestones';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END;
$$
DELIMITER ;
            
    # DELETE TRIGGER Create a trigger that calls the relevant procedure each time a record is deleted in the table `milestones`

    DROP TRIGGER IF EXISTS `trig_update_audit_log_delete_record_milestones`;

DELIMITER $$
CREATE TRIGGER `trig_update_audit_log_delete_record_milestones`
    AFTER DELETE ON `milestones`
    FOR EACH ROW
  BEGIN

    # We capture the old values of each fields in dedicated variables:
        SET @old_id = old.id;
        SET @old_product_id = old.product_id;
        SET @old_value = old.value;
        SET @old_sortkey = old.sortkey;
        SET @old_isactive = old.isactive;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'milestones';
        SET @bzfe_field = 'id, product_id, value, sortkey, isactive';
        SET @previous_value = CONCAT (
                @old_id
                , ', '
                , @old_product_id
                , ', '
                , @old_value
                , ', '
                , @old_sortkey
                , ', '
                , @old_isactive
            )
           ;
        SET @new_value = NULL;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_delete_record_milestones';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END;
$$
DELIMITER ;

    # UPDATE TRIGGER Create a trigger that calls the relevant procedure each time a record is updated in the table `milestones`

    DROP TRIGGER IF EXISTS `trig_update_audit_log_update_record_milestones`;

DELIMITER $$
CREATE TRIGGER `trig_update_audit_log_update_record_milestones`
    AFTER UPDATE ON `milestones`
    FOR EACH ROW
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_id = new.id;
        SET @new_product_id = new.product_id;
        SET @new_value = new.value;
        SET @new_sortkey = new.sortkey;
        SET @new_isactive = new.isactive;

    # We capture the old values of each fields in dedicated variables:
        SET @old_id = old.id;
        SET @old_product_id = old.product_id;
        SET @old_value = old.value;
        SET @old_sortkey = old.sortkey;
        SET @old_isactive = old.isactive;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'milestones';
        SET @bzfe_field = 'id, product_id, value, sortkey, isactive';
        SET @previous_value = CONCAT (
                @old_id
                , ', '
                , @old_product_id
                , ', '
                , @old_value
                , ', '
                , @old_sortkey
                , ', '
                , @old_isactive
            )
           ;
        SET @new_value = CONCAT (
                @new_id
                , ', '
                , @new_product_id
                , ', '
                , @new_value
                , ', '
                , @new_sortkey
                , ', '
                , @new_isactive
            )
           ;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_update_record_milestones';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END;
$$
DELIMITER ;

# The `components` table

    # INSERT TRIGGER Create a trigger that calls the relevant procedure each time a record is added to the table `components`

    DROP TRIGGER IF EXISTS `trig_update_audit_log_new_record_components`;

DELIMITER $$
CREATE TRIGGER `trig_update_audit_log_new_record_components`
    AFTER INSERT ON `components`
    FOR EACH ROW
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_id = new.id;
        SET @new_name = new.name;
        SET @new_product_id = new.product_id;
        SET @new_initialowner = new.initialowner;
        SET @new_initialqacontact = new.initialqacontact;
        SET @new_description = new.description;
        SET @new_isactive = new.isactive;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'components';
        SET @bzfe_field = 'id, name, product_id, initialowner, initialqacontact, description, isactive';
        SET @previous_value = NULL;
        SET @new_value = CONCAT (
                @new_id
                , ', '
                , @new_name
                , ', '
                , @new_product_id
                , ', '
                , @new_initialowner
                , ', '
                , IFNULL(@new_initialqacontact, '(NULL)')
                , ', '
                , @new_description
                , ', '
                , @new_isactive
            )
           ;
        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_new_record_components';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END;
$$
DELIMITER ;
            
    # DELETE TRIGGER Create a trigger that calls the relevant procedure each time a record is deleted in the table `components`

    DROP TRIGGER IF EXISTS `trig_update_audit_log_delete_record_components`;

DELIMITER $$
CREATE TRIGGER `trig_update_audit_log_delete_record_components`
    AFTER DELETE ON `components`
    FOR EACH ROW
  BEGIN

    # We capture the old values of each fields in dedicated variables:
        SET @old_id = old.id;
        SET @old_name = old.name;
        SET @old_product_id = old.product_id;
        SET @old_initialowner = old.initialowner;
        SET @old_initialqacontact = old.initialqacontact;
        SET @old_description = old.description;
        SET @old_isactive = old.isactive;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'components';
        SET @bzfe_field = 'id, name, product_id, initialowner, initialqacontact, description, isactive';
        SET @previous_value = CONCAT (
                @old_id
                , ', '
                , @old_name
                , ', '
                , @old_product_id
                , ', '
                , @old_initialowner
                , ', '
                , IFNULL(@old_initialqacontact, '(NULL)')
                , ', '
                , @old_description
                , ', '
                , @old_isactive
            )
           ;
        SET @new_value = NULL;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_delete_record_components';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END;
$$
DELIMITER ;

    # UPDATE TRIGGER Create a trigger that calls the relevant procedure each time a record is updated in the table `components`

    DROP TRIGGER IF EXISTS `trig_update_audit_log_update_record_components`;

DELIMITER $$
CREATE TRIGGER `trig_update_audit_log_update_record_components`
    AFTER UPDATE ON `components`
    FOR EACH ROW
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_id = new.id;
        SET @new_name = new.name;
        SET @new_product_id = new.product_id;
        SET @new_initialowner = new.initialowner;
        SET @new_initialqacontact = new.initialqacontact;
        SET @new_description = new.description;
        SET @new_isactive = new.isactive;

    # We capture the old values of each fields in dedicated variables:
        SET @old_id = old.id;
        SET @old_name = old.name;
        SET @old_product_id = old.product_id;
        SET @old_initialowner = old.initialowner;
        SET @old_initialqacontact = old.initialqacontact;
        SET @old_description = old.description;
        SET @old_isactive = old.isactive;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'components';
        SET @bzfe_field = 'id, name, product_id, initialowner, initialqacontact, description, isactive';
        SET @previous_value = CONCAT (
                @old_id
                , ', '
                , @old_name
                , ', '
                , @old_product_id
                , ', '
                , @old_initialowner
                , ', '
                , IFNULL(@old_initialqacontact, '(NULL)')
                , ', '
                , @old_description
                , ', '
                , @old_isactive
            )
           ;
        SET @new_value = CONCAT (
                @new_id
                , ', '
                , @new_name
                , ', '
                , @new_product_id
                , ', '
                , @new_initialowner
                , ', '
                , IFNULL(@new_initialqacontact, '(NULL)')
                , ', '
                , @new_description
                , ', '
                , @new_isactive
            )
           ;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_update_record_components';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END;
$$
DELIMITER ;

# The `component_cc` table

    # INSERT TRIGGER Create a trigger that calls the relevant procedure each time a record is added to the table `component_cc`

    DROP TRIGGER IF EXISTS `trig_update_audit_log_new_record_component_cc`;

DELIMITER $$
CREATE TRIGGER `trig_update_audit_log_new_record_component_cc`
    AFTER INSERT ON `component_cc`
    FOR EACH ROW
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_user_id = new.user_id;
        SET @new_component_id = new.component_id;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'component_cc';
        SET @bzfe_field = 'user_id, component_id';
        SET @previous_value = NULL;
        SET @new_value = CONCAT (
                @new_user_id
                , ', '
                , @new_component_id
            )
           ;
        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_new_record_component_cc';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END;
$$
DELIMITER ;
            
    # DELETE TRIGGER Create a trigger that calls the relevant procedure each time a record is deleted in the table `component_cc`

    DROP TRIGGER IF EXISTS `trig_update_audit_log_delete_record_component_cc`;

DELIMITER $$
CREATE TRIGGER `trig_update_audit_log_delete_record_component_cc`
    AFTER DELETE ON `component_cc`
    FOR EACH ROW
  BEGIN

    # We capture the old values of each fields in dedicated variables:
        SET @old_user_id = old.user_id;
        SET @old_component_id = old.component_id;
        
    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'component_cc';
        SET @bzfe_field = 'user_id, component_id';
        SET @previous_value = CONCAT (
                 @old_user_id
                , ', '
                , @old_component_id
            )
           ;
        SET @new_value = NULL;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_delete_record_component_cc';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END;
$$
DELIMITER ;

    # UPDATE TRIGGER Create a trigger that calls the relevant procedure each time a record is updated in the table `component_cc`

    DROP TRIGGER IF EXISTS `trig_update_audit_log_update_record_component_cc`;

DELIMITER $$
CREATE TRIGGER `trig_update_audit_log_update_record_component_cc`
    AFTER UPDATE ON `component_cc`
    FOR EACH ROW
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_user_id = new.user_id;
        SET @new_component_id = new.component_id;

    # We capture the old values of each fields in dedicated variables:
        SET @old_user_id = old.user_id;
        SET @old_component_id = old.component_id;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'component_cc';
        SET @bzfe_field = 'id, name, description, isbuggroup, userregexp, isactive, icon_url';
        SET @previous_value = CONCAT (
                @old_user_id
                , ', '
                , @old_component_id
            )
           ;
        SET @new_value = CONCAT (
                @new_user_id
                , ', '
                , @new_component_id
            )
           ;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_update_record_component_cc';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END;
$$
DELIMITER ;

# The `groups` table

    # INSERT TRIGGER Create a trigger that calls the relevant procedure each time a record is added to the table `groups`

    DROP TRIGGER IF EXISTS `trig_update_audit_log_new_record_groups`;

DELIMITER $$
CREATE TRIGGER `trig_update_audit_log_new_record_groups`
    AFTER INSERT ON `groups`
    FOR EACH ROW
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_id = new.id;
        SET @new_name = new.name;
        SET @new_description = new.description;
        SET @new_isbuggroup = new.isbuggroup;
        SET @new_userregexp = new.userregexp;
        SET @new_isactive = new.isactive;
        SET @new_icon_url = new.icon_url;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'groups';
        SET @bzfe_field = 'id, name, description, isbuggroup, userregexp, isactive, icon_url';
        SET @previous_value = NULL;
        SET @new_value = CONCAT (
                @new_id
                , ', '
                , @new_name
                , ', '
                , @new_description
                , ', '
                , @new_isbuggroup
                , ', '
                , IFNULL(@new_userregexp, '(NULL)')
                , ', '
                , @new_isactive
                , ', '
                , IFNULL(@new_icon_url, '(NULL)')
            )
           ;
        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_new_record_groups';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END;
$$
DELIMITER ;
            
    # DELETE TRIGGER Create a trigger that calls the relevant procedure each time a record is deleted in the table `groups`

    DROP TRIGGER IF EXISTS `trig_update_audit_log_delete_record_groups`;

DELIMITER $$
CREATE TRIGGER `trig_update_audit_log_delete_record_groups`
    AFTER DELETE ON `groups`
    FOR EACH ROW
  BEGIN

    # We capture the old values of each fields in dedicated variables:
        SET @old_id = old.id;
        SET @old_name = old.name;
        SET @old_description = old.description;
        SET @old_isbuggroup = old.isbuggroup;
        SET @old_userregexp = old.userregexp;
        SET @old_isactive = old.isactive;
        SET @old_icon_url = old.icon_url;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'groups';
        SET @bzfe_field = 'id, name, description, isbuggroup, userregexp, isactive, icon_url';
        SET @previous_value = CONCAT (
                 @old_id
                , ', '
                , @old_name
                , ', '
                , @old_description
                , ', '
                , @old_isbuggroup
                , ', '
                , IFNULL(@old_userregexp, '(NULL)')
                , ', '
                , @old_isactive
                , ', '
                , IFNULL(@old_icon_url, '(NULL)')
            )
           ;
        SET @new_value = NULL;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_delete_record_groups';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END;
$$
DELIMITER ;

    # UPDATE TRIGGER Create a trigger that calls the relevant procedure each time a record is updated in the table `groups`

    DROP TRIGGER IF EXISTS `trig_update_audit_log_update_record_groups`;

DELIMITER $$
CREATE TRIGGER `trig_update_audit_log_update_record_groups`
    AFTER UPDATE ON `groups`
    FOR EACH ROW
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_id = new.id;
        SET @new_name = new.name;
        SET @new_description = new.description;
        SET @new_isbuggroup = new.isbuggroup;
        SET @new_userregexp = new.userregexp;
        SET @new_isactive = new.isactive;
        SET @new_icon_url = new.icon_url;

    # We capture the old values of each fields in dedicated variables:
        SET @old_id = old.id;
        SET @old_name = old.name;
        SET @old_description = old.description;
        SET @old_isbuggroup = old.isbuggroup;
        SET @old_userregexp = old.userregexp;
        SET @old_isactive = old.isactive;
        SET @old_icon_url = old.icon_url;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'groups';
        SET @bzfe_field = 'id, name, description, isbuggroup, userregexp, isactive, icon_url';
        SET @previous_value = CONCAT (
                @old_id
                , ', '
                , @old_name
                , ', '
                , @old_description
                , ', '
                , @old_isbuggroup
                , ', '
                , IFNULL(@old_userregexp, '(NULL)')
                , ', '
                , @old_isactive
                , ', '
                , IFNULL(@old_icon_url, '(NULL)')
            )
           ;
        SET @new_value = CONCAT (
                 @new_id
                , ', '
                , @new_name
                , ', '
                , @new_description
                , ', '
                , @new_isbuggroup
                , ', '
                , IFNULL(@new_userregexp, '(NULL)')
                , ', '
                , @new_isactive
                , ', '
                , IFNULL(@new_icon_url, '(NULL)')
            )
           ;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_update_record_groups';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END;
$$
DELIMITER ;

# The `flagtypes` table

    # INSERT TRIGGER Create a trigger that calls the relevant procedure each time a record is added to the table `flagtypes`

    DROP TRIGGER IF EXISTS `trig_update_audit_log_new_record_flagtypes`;

DELIMITER $$
CREATE TRIGGER `trig_update_audit_log_new_record_flagtypes`
    AFTER INSERT ON `flagtypes`
    FOR EACH ROW
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_id = new.id;
        SET @new_name = new.name;
        SET @new_description = new.description;
        SET @new_cc_list = new.cc_list;
        SET @new_target_type = new.target_type;
        SET @new_is_active = new.is_active;
        SET @new_is_requestable = new.is_requestable;
        SET @new_is_requesteeble = new.is_requesteeble;
        SET @new_is_multiplicable = new.is_multiplicable;
        SET @new_sortkey = new.sortkey;
        SET @new_grant_group_id = new.grant_group_id;
        SET @new_request_group_id = new.request_group_id;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'flagtypes';
        SET @bzfe_field = 'id, name, description, cc_list, target_type, is_active, is_requestable, is_requesteeble, is_multiplicable, sortkey, grant_group_id, request_group_id';
        SET @previous_value = NULL;
        SET @new_value = CONCAT (
                @new_id
                , ', '
                , @new_name
                , ', '
                , @new_description
                , ', '
                , IFNULL(@new_cc_list, '(NULL)')
                , ', '
                , @new_target_type
                , ', '
                , @new_is_active
                , ', '
                , @new_is_requestable
                , ', '
                , @new_is_requesteeble
                , ', '
                , @new_is_multiplicable
                , ', '
                , @new_sortkey
                , ', '
                , IFNULL(@new_grant_group_id, '(NULL)')
                , ', '
                , IFNULL(@new_request_group_id, '(NULL)')    
            )
           ;
        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_new_record_flagtypes';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END;
$$
DELIMITER ;
            
    # DELETE TRIGGER Create a trigger that calls the relevant procedure each time a record is deleted in the table `flagtypes`

    DROP TRIGGER IF EXISTS `trig_update_audit_log_delete_record_flagtypes`;

DELIMITER $$
CREATE TRIGGER `trig_update_audit_log_delete_record_flagtypes`
    AFTER DELETE ON `flagtypes`
    FOR EACH ROW
  BEGIN

    # We capture the old values of each fields in dedicated variables:
        SET @old_id = old.id;
        SET @old_name = old.name;
        SET @old_description = old.description;
        SET @old_cc_list = old.cc_list;
        SET @old_target_type = old.target_type;
        SET @old_is_active = old.is_active;
        SET @old_is_requestable = old.is_requestable;
        SET @old_is_requesteeble = old.is_requesteeble;
        SET @old_is_multiplicable = old.is_multiplicable;
        SET @old_sortkey = old.sortkey;
        SET @old_grant_group_id = old.grant_group_id;
        SET @old_request_group_id = old.request_group_id;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'flagtypes';
        SET @bzfe_field = 'id, name, description, cc_list, target_type, is_active, is_requestable, is_requesteeble, is_multiplicable, sortkey, grant_group_id, request_group_id';
        SET @previous_value = CONCAT (
                @old_id
                , ', '
                , @old_name
                , ', '
                , @old_description
                , ', '
                , IFNULL(@old_cc_list, '(NULL)')
                , ', '
                , @old_target_type
                , ', '
                , @old_is_active
                , ', '
                , @old_is_requestable
                , ', '
                , @old_is_requesteeble
                , ', '
                , @old_is_multiplicable
                , ', '
                , @old_sortkey
                , ', '
                , IFNULL(@old_grant_group_id, '(NULL)')
                , ', '
                , IFNULL(@old_request_group_id, '(NULL)')  
            )
           ;
        SET @new_value = NULL;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_delete_record_flagtypes';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END;
$$
DELIMITER ;

    # UPDATE TRIGGER Create a trigger that calls the relevant procedure each time a record is updated in the table `flagtypes`

    DROP TRIGGER IF EXISTS `trig_update_audit_log_update_record_flagtypes`;

DELIMITER $$
CREATE TRIGGER `trig_update_audit_log_update_record_flagtypes`
    AFTER UPDATE ON `flagtypes`
    FOR EACH ROW
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_id = new.id;
        SET @new_name = new.name;
        SET @new_description = new.description;
        SET @new_cc_list = new.cc_list;
        SET @new_target_type = new.target_type;
        SET @new_is_active = new.is_active;
        SET @new_is_requestable = new.is_requestable;
        SET @new_is_requesteeble = new.is_requesteeble;
        SET @new_is_multiplicable = new.is_multiplicable;
        SET @new_sortkey = new.sortkey;
        SET @new_grant_group_id = new.grant_group_id;
        SET @new_request_group_id = new.request_group_id;

    # We capture the old values of each fields in dedicated variables:
        SET @old_id = old.id;
        SET @old_name = old.name;
        SET @old_description = old.description;
        SET @old_cc_list = old.cc_list;
        SET @old_target_type = old.target_type;
        SET @old_is_active = old.is_active;
        SET @old_is_requestable = old.is_requestable;
        SET @old_is_requesteeble = old.is_requesteeble;
        SET @old_is_multiplicable = old.is_multiplicable;
        SET @old_sortkey = old.sortkey;
        SET @old_grant_group_id = old.grant_group_id;
        SET @old_request_group_id = old.request_group_id;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'flagtypes';
        SET @bzfe_field = 'id, name, description, cc_list, target_type, is_active, is_requestable, is_requesteeble, is_multiplicable, sortkey, grant_group_id, request_group_id';
        SET @previous_value = CONCAT (
                @new_id
                , ', '
                , @new_name
                , ', '
                , @new_description
                , ', '
                , IFNULL(@new_cc_list, '(NULL)')
                , ', '
                , @new_target_type
                , ', '
                , @new_is_active
                , ', '
                , @new_is_requestable
                , ', '
                , @new_is_requesteeble
                , ', '
                , @new_is_multiplicable
                , ', '
                , @new_sortkey
                , ', '
                , IFNULL(@new_grant_group_id, '(NULL)')
                , ', '
                , IFNULL(@new_request_group_id, '(NULL)')    
            )
           ;
        SET @new_value = CONCAT (
                @old_id
                , ', '
                , @old_name
                , ', '
                , @old_description
                , ', '
                , IFNULL(@old_cc_list, '(NULL)')
                , ', '
                , @old_target_type
                , ', '
                , @old_is_active
                , ', '
                , @old_is_requestable
                , ', '
                , @old_is_requesteeble
                , ', '
                , @old_is_multiplicable
                , ', '
                , @old_sortkey
                , ', '
                , IFNULL(@old_grant_group_id, '(NULL)')
                , ', '
                , IFNULL(@old_request_group_id, '(NULL)')    
            )
           ;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_update_record_flagtypes';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END;
$$
DELIMITER ;

# The `flaginclusions` table

    # INSERT TRIGGER Create a trigger that calls the relevant procedure each time a record is added to the table `flaginclusions`

    DROP TRIGGER IF EXISTS `trig_update_audit_log_new_record_flaginclusions`;

DELIMITER $$
CREATE TRIGGER `trig_update_audit_log_new_record_flaginclusions`
    AFTER INSERT ON `flaginclusions`
    FOR EACH ROW
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_type_id = new.type_id;
        SET @new_product_id = new.product_id;
        SET @new_component_id = new.component_id;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'flaginclusions';
        SET @bzfe_field = 'type_id, product_id, component_id';
        SET @previous_value = NULL;
        SET @new_value = CONCAT (
                @new_type_id
                , ', '
                , IFNULL(@new_product_id, '(NULL)')
                , ', '
                , IFNULL(@new_component_id, '(NULL)')  
            )
           ;
        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_new_record_flaginclusions';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END;
$$
DELIMITER ;
            
    # DELETE TRIGGER Create a trigger that calls the relevant procedure each time a record is deleted in the table `flaginclusions`

    DROP TRIGGER IF EXISTS `trig_update_audit_log_delete_record_flaginclusions`;

DELIMITER $$
CREATE TRIGGER `trig_update_audit_log_delete_record_flaginclusions`
    AFTER DELETE ON `flaginclusions`
    FOR EACH ROW
  BEGIN

    # We capture the old values of each fields in dedicated variables:
        SET @old_type_id = old.type_id;
        SET @old_product_id = old.product_id;
        SET @old_component_id = old.component_id;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'flaginclusions';
        SET @bzfe_field = 'type_id, product_id, component_id';
        SET @previous_value = CONCAT (
                @old_type_id
                , ', '
                , IFNULL(@old_product_id, '(NULL)')
                , ', '
                , IFNULL(@old_component_id, '(NULL)') 
            )
           ;
        SET @new_value = NULL;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_delete_record_flaginclusions';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END;
$$
DELIMITER ;

    # UPDATE TRIGGER Create a trigger that calls the relevant procedure each time a record is updated in the table `flaginclusions`

    DROP TRIGGER IF EXISTS `trig_update_audit_log_update_record_flaginclusions`;

DELIMITER $$
CREATE TRIGGER `trig_update_audit_log_update_record_flaginclusions`
    AFTER UPDATE ON `flaginclusions`
    FOR EACH ROW
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_type_id = new.type_id;
        SET @new_product_id = new.product_id;
        SET @new_component_id = new.component_id;

    # We capture the old values of each fields in dedicated variables:
        SET @old_type_id = old.type_id;
        SET @old_product_id = old.product_id;
        SET @old_component_id = old.component_id;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'flaginclusions';
        SET @bzfe_field = 'type_id, product_id, component_id';
        SET @previous_value = CONCAT (
                @old_type_id
                , ', '
                , IFNULL(@old_product_id, '(NULL)')
                , ', '
                , IFNULL(@old_component_id, '(NULL)') 
            )
           ;
        SET @new_value = CONCAT (
                @new_type_id
                , ', '
                , IFNULL(@new_product_id, '(NULL)')
                , ', '
                , IFNULL(@new_component_id, '(NULL)')     
            )
           ;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_update_record_flaginclusions';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END;
$$
DELIMITER ;

# The `group_control_map` table

    # INSERT TRIGGER Create a trigger that calls the relevant procedure each time a record is added to the table `group_control_map`

    DROP TRIGGER IF EXISTS `trig_update_audit_log_new_record_group_control_map`;

DELIMITER $$
CREATE TRIGGER `trig_update_audit_log_new_record_group_control_map`
    AFTER INSERT ON `group_control_map`
    FOR EACH ROW
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_group_id = new.group_id;
        SET @new_product_id = new.product_id;
        SET @new_entry = new.entry;
        SET @new_membercontrol = new.membercontrol;
        SET @new_othercontrol = new.othercontrol;
        SET @new_canedit = new.canedit;
        SET @new_editcomponents = new.editcomponents;
        SET @new_editbugs = new.editbugs;
        SET @new_canconfirm = new.canconfirm;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'group_control_map';
        SET @bzfe_field = 'group_id, product_id, entry, membercontrol, othercontrol, canedit, editcomponents, editbugs, canconfirm';
        SET @previous_value = NULL;
        SET @new_value = CONCAT (
                @new_group_id
                , ', '
                , @new_product_id
                , ', '
                , @new_entry
                , ', '
                , @new_membercontrol
                , ', '
                , @new_othercontrol
                , ', '
                , @new_canedit
                , ', '
                , @new_editcomponents
                , ', '
                , @new_editbugs
                , ', '
                , @new_canconfirm
            )
           ;
        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_new_record_group_control_map';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END;
$$
DELIMITER ;
            
    # DELETE TRIGGER Create a trigger that calls the relevant procedure each time a record is deleted in the table `group_control_map`

    DROP TRIGGER IF EXISTS `trig_update_audit_log_delete_record_group_control_map`;

DELIMITER $$
CREATE TRIGGER `trig_update_audit_log_delete_record_group_control_map`
    AFTER DELETE ON `group_control_map`
    FOR EACH ROW
  BEGIN

    # We capture the old values of each fields in dedicated variables:
        SET @old_group_id = old.group_id;
        SET @old_product_id = old.product_id;
        SET @old_entry = old.entry;
        SET @old_membercontrol = old.membercontrol;
        SET @old_othercontrol = old.othercontrol;
        SET @old_canedit = old.canedit;
        SET @old_editcomponents = old.editcomponents;
        SET @old_editbugs = old.editbugs;
        SET @old_canconfirm = old.canconfirm;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'group_control_map';
        SET @bzfe_field = 'group_id, product_id, entry, membercontrol, othercontrol, canedit, editcomponents, editbugs, canconfirm';
        SET @previous_value = CONCAT (
                @old_group_id
                , ', '
                , @old_product_id
                , ', '
                , @old_entry
                , ', '
                , @old_membercontrol
                , ', '
                , @old_othercontrol
                , ', '
                , @old_canedit
                , ', '
                , @old_editcomponents
                , ', '
                , @old_editbugs
                , ', '
                , @old_canconfirm
            )
           ;
        SET @new_value = NULL;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_delete_record_group_control_map';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END;
$$
DELIMITER ;

    # UPDATE TRIGGER Create a trigger that calls the relevant procedure each time a record is updated in the table `group_control_map`

    DROP TRIGGER IF EXISTS `trig_update_audit_log_update_record_group_control_map`;

DELIMITER $$
CREATE TRIGGER `trig_update_audit_log_update_record_group_control_map`
    AFTER UPDATE ON `group_control_map`
    FOR EACH ROW
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_group_id = new.group_id;
        SET @new_product_id = new.product_id;
        SET @new_entry = new.entry;
        SET @new_membercontrol = new.membercontrol;
        SET @new_othercontrol = new.othercontrol;
        SET @new_canedit = new.canedit;
        SET @new_editcomponents = new.editcomponents;
        SET @new_editbugs = new.editbugs;
        SET @new_canconfirm = new.canconfirm;

    # We capture the old values of each fields in dedicated variables:
        SET @old_group_id = old.group_id;
        SET @old_product_id = old.product_id;
        SET @old_entry = old.entry;
        SET @old_membercontrol = old.membercontrol;
        SET @old_othercontrol = old.othercontrol;
        SET @old_canedit = old.canedit;
        SET @old_editcomponents = old.editcomponents;
        SET @old_editbugs = old.editbugs;
        SET @old_canconfirm = old.canconfirm;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'group_control_map';
        SET @bzfe_field = 'group_id, product_id, entry, membercontrol, othercontrol, canedit, editcomponents, editbugs, canconfirm';
        SET @previous_value = CONCAT (
                @old_group_id
                , ', '
                , @old_product_id
                , ', '
                , @old_entry
                , ', '
                , @old_membercontrol
                , ', '
                , @old_othercontrol
                , ', '
                , @old_canedit
                , ', '
                , @old_editcomponents
                , ', '
                , @old_editbugs
                , ', '
                , @old_canconfirm
            )
           ;
        SET @new_value = CONCAT (
                @new_group_id
                , ', '
                , @new_product_id
                , ', '
                , @new_entry
                , ', '
                , @new_membercontrol
                , ', '
                , @new_othercontrol
                , ', '
                , @new_canedit
                , ', '
                , @new_editcomponents
                , ', '
                , @new_editbugs
                , ', '
                , @new_canconfirm
            )
           ;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_update_record_group_control_map';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END;
$$
DELIMITER ;

# The `group_group_map` table

    # INSERT TRIGGER Create a trigger that calls the relevant procedure each time a record is added to the table `group_group_map`

    DROP TRIGGER IF EXISTS `trig_update_audit_log_new_record_group_group_map`;

DELIMITER $$
CREATE TRIGGER `trig_update_audit_log_new_record_group_group_map`
    AFTER INSERT ON `group_group_map`
    FOR EACH ROW
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_member_id = new.member_id;
        SET @new_grantor_id = new.grantor_id;
        SET @new_grant_type = new.grant_type;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'group_group_map';
        SET @bzfe_field = 'member_id, grantor_id, grant_type';
        SET @previous_value = NULL;
        SET @new_value = CONCAT (
                @new_member_id
                , ', '
                , @new_grantor_id
                , ', '
                , @new_grant_type
            )
           ;
        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_new_record_group_group_map';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END;
$$
DELIMITER ;
            
    # DELETE TRIGGER Create a trigger that calls the relevant procedure each time a record is deleted in the table `group_group_map`

    DROP TRIGGER IF EXISTS `trig_update_audit_log_delete_record_group_group_map`;

DELIMITER $$
CREATE TRIGGER `trig_update_audit_log_delete_record_group_group_map`
    AFTER DELETE ON `group_group_map`
    FOR EACH ROW
  BEGIN

    # We capture the old values of each fields in dedicated variables:
        SET @old_member_id = old.member_id;
        SET @old_grantor_id = old.grantor_id;
        SET @old_grant_type = old.grant_type;
        
    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'group_group_map';
        SET @bzfe_field = 'member_id, grantor_id, grant_type';
        SET @previous_value = CONCAT (
                @old_member_id
                , ', '
                , @old_grantor_id
                , ', '
                , @old_grant_type 
            )
           ;
        SET @new_value = NULL;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_delete_record_group_group_map';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END;
$$
DELIMITER ;

    # UPDATE TRIGGER Create a trigger that calls the relevant procedure each time a record is updated in the table `group_group_map`

    DROP TRIGGER IF EXISTS `trig_update_audit_log_update_record_group_group_map`;

DELIMITER $$
CREATE TRIGGER `trig_update_audit_log_update_record_group_group_map`
    AFTER UPDATE ON `group_group_map`
    FOR EACH ROW
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_member_id = new.member_id;
        SET @new_grantor_id = new.grantor_id;
        SET @new_grant_type = new.grant_type;
        
    # We capture the old values of each fields in dedicated variables:
        SET @old_member_id = old.member_id;
        SET @old_grantor_id = old.grantor_id;
        SET @old_grant_type = old.grant_type;
        
    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'group_group_map';
        SET @bzfe_field = 'member_id, grantor_id, grant_type';
        SET @previous_value = CONCAT (
                @old_member_id
                , ', '
                , @old_grantor_id
                , ', '
                , @old_grant_type
            )
           ;
        SET @new_value = CONCAT (
                @new_member_id
                , ', '
                , @new_grantor_id
                , ', '
                , @new_grant_type
            )
           ;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_update_record_group_group_map';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END;
$$
DELIMITER ;

# The `ut_product_group` table

    # INSERT TRIGGER Create a trigger that calls the relevant procedure each time a record is added to the table `ut_product_group`

    DROP TRIGGER IF EXISTS `trig_update_audit_log_new_record_ut_product_group`;

DELIMITER $$
CREATE TRIGGER `trig_update_audit_log_new_record_ut_product_group`
    AFTER INSERT ON `ut_product_group`
    FOR EACH ROW
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_product_id = new.product_id;
        SET @new_component_id = new.component_id;
        SET @new_group_id = new.group_id;
        SET @new_group_type_id = new.group_type_id;
        SET @new_role_type_id = new.role_type_id;
        SET @new_created_by_id = new.created_by_id;
        SET @new_created = new.created;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'ut_product_group';
        SET @bzfe_field = 'product_id, component_id, group_id, group_type_id, role_type_id, created_by_id, created';
        SET @previous_value = NULL;
        SET @new_value = CONCAT (
                @new_product_id
                , ', '
                , IFNULL(@new_component_id, '(NULL)')
                , ', '
                , @new_group_id
                , ', '
                , @new_group_type_id
                , ', '
                , IFNULL(@new_role_type_id, '(NULL)')
                , ', '
                , IFNULL(@new_created_by_id, '(NULL)')
                , ', '
                , IFNULL(@new_created, '(NULL)')
            )
           ;
        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_new_record_ut_product_group';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END;
$$
DELIMITER ;
            
    # DELETE TRIGGER Create a trigger that calls the relevant procedure each time a record is deleted in the table `ut_product_group`

    DROP TRIGGER IF EXISTS `trig_update_audit_log_delete_record_ut_product_group`;

DELIMITER $$
CREATE TRIGGER `trig_update_audit_log_delete_record_ut_product_group`
    AFTER DELETE ON `ut_product_group`
    FOR EACH ROW
  BEGIN

    # We capture the old values of each fields in dedicated variables:
        SET @old_product_id = old.product_id;
        SET @old_component_id = old.component_id;
        SET @old_group_id = old.group_id;
        SET @old_group_type_id = old.group_type_id;
        SET @old_role_type_id = old.role_type_id;
        SET @old_created_by_id = old.created_by_id;
        SET @old_created = old.created;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'ut_product_group';
        SET @bzfe_field = 'product_id, component_id, group_id, group_type_id, role_type_id, created_by_id, created';
        SET @previous_value = CONCAT (
                @old_product_id
                , ', '
                , IFNULL(@old_component_id, '(NULL)')
                , ', '
                , @old_group_id
                , ', '
                , @old_group_type_id
                , ', '
                , IFNULL(@old_role_type_id, '(NULL)')
                , ', '
                , IFNULL(@old_created_by_id, '(NULL)')
                , ', '
                , IFNULL(@old_created, '(NULL)')
            )
           ;
        SET @new_value = NULL;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_delete_record_ut_product_group';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END;
$$
DELIMITER ;

    # UPDATE TRIGGER Create a trigger that calls the relevant procedure each time a record is updated in the table `ut_product_group`

    DROP TRIGGER IF EXISTS `trig_update_audit_log_update_record_ut_product_group`;

DELIMITER $$
CREATE TRIGGER `trig_update_audit_log_update_record_ut_product_group`
    AFTER UPDATE ON `ut_product_group`
    FOR EACH ROW
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_product_id = new.product_id;
        SET @new_component_id = new.component_id;
        SET @new_group_id = new.group_id;
        SET @new_group_type_id = new.group_type_id;
        SET @new_role_type_id = new.role_type_id;
        SET @new_created_by_id = new.created_by_id;
        SET @new_created = new.created;
        
    # We capture the old values of each fields in dedicated variables:
        SET @old_product_id = old.product_id;
        SET @old_component_id = old.component_id;
        SET @old_group_id = old.group_id;
        SET @old_group_type_id = old.group_type_id;
        SET @old_role_type_id = old.role_type_id;
        SET @old_created_by_id = old.created_by_id;
        SET @old_created = old.created;
        
    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'ut_product_group';
        SET @bzfe_field = 'product_id, component_id, group_id, group_type_id, role_type_id, created_by_id, created';
        SET @previous_value = CONCAT (
                @old_product_id
                , ', '
                , IFNULL(@old_component_id, '(NULL)')
                , ', '
                , @old_group_id
                , ', '
                , @old_group_type_id
                , ', '
                , IFNULL(@old_role_type_id, '(NULL)')
                , ', '
                , IFNULL(@old_created_by_id, '(NULL)')
                , ', '
                , IFNULL(@old_created, '(NULL)')
            )
           ;
        SET @new_value = CONCAT (
                @new_product_id
                , ', '
                , IFNULL(@new_component_id, '(NULL)')
                , ', '
                , @new_group_id
                , ', '
                , @new_group_type_id
                , ', '
                , IFNULL(@new_role_type_id, '(NULL)')
                , ', '
                , IFNULL(@new_created_by_id, '(NULL)')
                , ', '
                , IFNULL(@new_created, '(NULL)')
            )
           ;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_update_record_ut_product_group';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END;
$$
DELIMITER ;

# The `ut_data_to_create_units` table

    # INSERT TRIGGER Create a trigger that calls the relevant procedure each time a record is added to the table `ut_data_to_create_units`

    DROP TRIGGER IF EXISTS `trig_update_audit_log_new_record_ut_data_to_create_units`;

DELIMITER $$
CREATE TRIGGER `trig_update_audit_log_new_record_ut_data_to_create_units`
    AFTER INSERT ON `ut_data_to_create_units`
    FOR EACH ROW
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_id_unit_to_create = new.id_unit_to_create;
        SET @new_mefe_unit_id = new.mefe_unit_id;
        SET @new_mefe_creator_user_id = new.mefe_creator_user_id;
        SET @new_bzfe_creator_user_id = new.bzfe_creator_user_id;
        SET @new_classification_id = new.classification_id;
        SET @new_unit_name = new.unit_name;
        SET @new_unit_description_details = new.unit_description_details;
        SET @new_bz_created_date = new.bz_created_date;
        SET @new_comment = new.comment;
        SET @new_product_id = new.product_id;
        SET @new_deleted_datetime = new.deleted_datetime;
        SET @new_deletion_script = new.deletion_script;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'ut_data_to_create_units';
        SET @bzfe_field = 'id_unit_to_create, mefe_unit_id, mefe_creator_user_id, bzfe_creator_user_id, classification_id, unit_name, unit_description_details, bz_created_date, comment, product_id, deleted_datetime, deletion_script';
        SET @previous_value = NULL;
        SET @new_value = CONCAT (
                @new_id_unit_to_create
                , ', '
                , IFNULL(@new_mefe_unit_id, '(NULL)')
                , ', '
                , IFNULL(@new_mefe_creator_user_id, '(NULL)')
                , ', '
                , @new_bzfe_creator_user_id
                , ', '
                , @new_classification_id
                , ', '
                , @new_unit_name
                , ', '
                , IFNULL(@new_unit_description_details, '(NULL)')
                , ', '
                , IFNULL(@new_bz_created_date, '(NULL)')
                , ', '
                , IFNULL(@new_comment, '(NULL)')
                , ', '
                , IFNULL(@new_product_id, '(NULL)')
                , ', '
                , IFNULL(@new_deleted_datetime, '(NULL)')
                , ', '
                , IFNULL(@new_deletion_script, '(NULL)')
            )
           ;
        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_new_record_ut_data_to_create_units';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END;
$$
DELIMITER ;
            
    # DELETE TRIGGER Create a trigger that calls the relevant procedure each time a record is deleted in the table `ut_data_to_create_units`

    DROP TRIGGER IF EXISTS `trig_update_audit_log_delete_record_ut_data_to_create_units`;

DELIMITER $$
CREATE TRIGGER `trig_update_audit_log_delete_record_ut_data_to_create_units`
    AFTER DELETE ON `ut_data_to_create_units`
    FOR EACH ROW
  BEGIN

    # We capture the old values of each fields in dedicated variables:
        SET @old_id_unit_to_create = old.id_unit_to_create;
        SET @old_mefe_unit_id = old.mefe_unit_id;
        SET @old_mefe_creator_user_id = old.mefe_creator_user_id;
        SET @old_bzfe_creator_user_id = old.bzfe_creator_user_id;
        SET @old_classification_id = old.classification_id;
        SET @old_unit_name = old.unit_name;
        SET @old_unit_description_details = old.unit_description_details;
        SET @old_bz_created_date = old.bz_created_date;
        SET @old_comment = old.comment;
        SET @old_product_id = old.product_id;
        SET @old_deleted_datetime = old.deleted_datetime;
        SET @old_deletion_script = old.deletion_script;

    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'ut_data_to_create_units';
        SET @bzfe_field = 'id_unit_to_create, mefe_unit_id, mefe_creator_user_id, bzfe_creator_user_id, classification_id, unit_name, unit_description_details, bz_created_date, comment, product_id, deleted_datetime, deletion_script';
        SET @previous_value = CONCAT (
                @old_id_unit_to_create
                , ', '
                , IFNULL(@old_mefe_unit_id, '(NULL)')
                , ', '
                , IFNULL(@old_mefe_creator_user_id, '(NULL)')
                , ', '
                , @old_bzfe_creator_user_id
                , ', '
                , @old_classification_id
                , ', '
                , @old_unit_name
                , ', '
                , IFNULL(@old_unit_description_details, '(NULL)')
                , ', '
                , IFNULL(@old_bz_created_date, '(NULL)')
                , ', '
                , IFNULL(@old_comment, '(NULL)')
                , ', '
                , IFNULL(@old_product_id, '(NULL)')
                , ', '
                , IFNULL(@old_deleted_datetime, '(NULL)')
                , ', '
                , IFNULL(@old_deletion_script, '(NULL)')
            )
           ;
        SET @new_value = NULL;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_delete_record_ut_data_to_create_units';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END;
$$
DELIMITER ;

    # UPDATE TRIGGER Create a trigger that calls the relevant procedure each time a record is updated in the table `ut_data_to_create_units`

    DROP TRIGGER IF EXISTS `trig_update_audit_log_update_record_ut_data_to_create_units`;

DELIMITER $$
CREATE TRIGGER `trig_update_audit_log_update_record_ut_data_to_create_units`
    AFTER UPDATE ON `ut_data_to_create_units`
    FOR EACH ROW
  BEGIN

    # We capture the new values of each fields in dedicated variables:
        SET @new_id_unit_to_create = new.id_unit_to_create;
        SET @new_mefe_unit_id = new.mefe_unit_id;
        SET @new_mefe_creator_user_id = new.mefe_creator_user_id;
        SET @new_bzfe_creator_user_id = new.bzfe_creator_user_id;
        SET @new_classification_id = new.classification_id;
        SET @new_unit_name = new.unit_name;
        SET @new_unit_description_details = new.unit_description_details;
        SET @new_bz_created_date = new.bz_created_date;
        SET @new_comment = new.comment;
        SET @new_product_id = new.product_id;
        SET @new_deleted_datetime = new.deleted_datetime;
        SET @new_deletion_script = new.deletion_script;
        
    # We capture the old values of each fields in dedicated variables:
        SET @old_id_unit_to_create = old.id_unit_to_create;
        SET @old_mefe_unit_id = old.mefe_unit_id;
        SET @old_mefe_creator_user_id = old.mefe_creator_user_id;
        SET @old_bzfe_creator_user_id = old.bzfe_creator_user_id;
        SET @old_classification_id = old.classification_id;
        SET @old_unit_name = old.unit_name;
        SET @old_unit_description_details = old.unit_description_details;
        SET @old_bz_created_date = old.bz_created_date;
        SET @old_comment = old.comment;
        SET @old_product_id = old.product_id;
        SET @old_deleted_datetime = old.deleted_datetime;
        SET @old_deletion_script = old.deletion_script;
        
    # We set the variable we need to update the log with relevant information:
        SET @bzfe_table = 'ut_data_to_create_units';
        SET @bzfe_field = 'id_unit_to_create, mefe_unit_id, mefe_creator_user_id, bzfe_creator_user_id, classification_id, unit_name, unit_description_details, bz_created_date, comment, product_id, deleted_datetime, deletion_script';
        SET @previous_value = CONCAT (
                @old_id_unit_to_create
                , ', '
                , IFNULL(@old_mefe_unit_id, '(NULL)')
                , ', '
                , IFNULL(@old_mefe_creator_user_id, '(NULL)')
                , ', '
                , @old_bzfe_creator_user_id
                , ', '
                , @old_classification_id
                , ', '
                , @old_unit_name
                , ', '
                , IFNULL(@old_unit_description_details, '(NULL)')
                , ', '
                , IFNULL(@old_bz_created_date, '(NULL)')
                , ', '
                , IFNULL(@old_comment, '(NULL)')
                , ', '
                , IFNULL(@old_product_id, '(NULL)')
                , ', '
                , IFNULL(@old_deleted_datetime, '(NULL)')
                , ', '
                , IFNULL(@old_deletion_script, '(NULL)')
            )
           ;
        SET @new_value = CONCAT (
                @new_id_unit_to_create
                , ', '
                , IFNULL(@new_mefe_unit_id, '(NULL)')
                , ', '
                , IFNULL(@new_mefe_creator_user_id, '(NULL)')
                , ', '
                , @new_bzfe_creator_user_id
                , ', '
                , @new_classification_id
                , ', '
                , @new_unit_name
                , ', '
                , IFNULL(@new_unit_description_details, '(NULL)')
                , ', '
                , IFNULL(@new_bz_created_date, '(NULL)')
                , ', '
                , IFNULL(@new_comment, '(NULL)')
                , ', '
                , IFNULL(@new_product_id, '(NULL)')
                , ', '
                , IFNULL(@new_deleted_datetime, '(NULL)')
                , ', '
                , IFNULL(@new_deletion_script, '(NULL)')
            )
           ;

        # The @script variable is defined by the highest level script we have - we do NOT change that
        SET @comment = 'called via the trigger trig_update_audit_log_update_record_ut_data_to_create_units';

    # We have all the variables:
        #   - @bzfe_table: the table that was updated
        #   - @bzfe_field: The fields that were updated
        #   - @previous_value: The previouso value for the field
        #   - @new_value: the values captured by the trigger when the new value is inserted.
        #   - @script: the script that is calling this procedure
        #   - @comment: a text to give some context ex: "this was created by a trigger xxx"

        CALL `update_audit_log`;

END;
$$
DELIMITER ;
















#   - Move the audit log function outside the scripts in dedicated trigger when we
#       - INSERT records in the tables
#           - `user_group_map`
#           - `products`
#           - `versions`
#           - `milestones`
#           - `components`
#           - `component_cc`
#           - `groups`
#           - `flagtypes`
#           - `flaginclusions`
#           - `group_control_map`
#           - `ut_product_group`
#WIP       - `group_group_map`
#WIP       - `series_categories`
#WIP       - `series`
#WIP       - `ut_data_to_create_units`
#WIP       - `ut_invitation_api_data`
#
#       - DELETE records in the tables
#           - `user_group_map`
#           - `products`
#           - `versions`
#           - `milestones`
#           - `components`
#           - `component_cc`
#           - `groups`
#           - `flagtypes`
#           - `flaginclusions`
#           - `group_control_map`
#           - `ut_product_group`
#WIP       - `group_group_map`
#WIP       - `series_categories`
#WIP       - `series`
#WIP       - `ut_data_to_create_units`
#WIP       - `ut_invitation_api_data`
#
#       - UPDATE records in the tables
#           - `user_group_map`
#           - `products`
#           - `versions`
#           - `milestones`
#           - `components`
#           - `component_cc`
#           - `groups`
#           - `flagtypes`
#           - `flaginclusions`
#           - `group_control_map`
#           - `ut_product_group`
#WIP       - `group_group_map`
#WIP       - `series_categories`
#WIP       - `series`
#WIP       - `ut_data_to_create_units`
#WIP       - `ut_invitation_api_data`















# Clean up
    # We drop the table in case in exist in the DB (we want to replace it with a temporary table)
	    DROP TABLE IF EXISTS `user_group_map_dedup`;

    # We drop the table in case in exist in the DB (we want to replace it with a temporary table)
	    DROP TABLE IF EXISTS `ut_group_group_map_dedup`;

    # We drop the table in case in exist in the DB (we want to replace it with a temporary table)
	    DROP TABLE IF EXISTS `ut_temp_dummy_users_for_roles`;

    # We drop the table in case in exist in the DB (we want to replace it with a temporary table)
        DROP TABLE IF EXISTS `ut_component_cc_temp`;

    # We drop the table in case in exist in the DB (we want to replace it with a temporary table)
        DROP TABLE IF EXISTS `ut_user_group_map_temp`;

    # We drop the table in case in exist in the DB (we want to replace it with a temporary table)
        DROP TABLE IF EXISTS `ut_group_group_map_temp`;

# Update the procedure `update_permissions_invited_user`
# When we update the permissions, make sure we do not delete the table `ut_user_group_map_temp`

    # Delete the procedure so we can re-create it
	DROP PROCEDURE IF EXISTS `update_permissions_invited_user`;

DELIMITER $$
CREATE PROCEDURE `update_permissions_invited_user`()
SQL SECURITY INVOKER
BEGIN

	# We update the `user_group_map` table
    #   - Create an intermediary table to deduplicate the records in the table `ut_user_group_map_temp`
    #   - If the record does NOT exists in the table then INSERT new records in the table `user_group_map`
    #   - If the record DOES exist in the table then update the new records in the table `user_group_map`
    					
    # We need the table `ut_user_group_map_temp`
        CALL `create_temp_table_to_update_permissions`;


	# We drop the deduplication table if it exists:
		DROP TEMPORARY TABLE IF EXISTS `ut_user_group_map_dedup`;

	# We create a table `ut_user_group_map_dedup` to prepare the data we need to insert
		CREATE TEMPORARY TABLE `ut_user_group_map_dedup` (
			`user_id` MEDIUMINT(9) NOT NULL,
			`group_id` MEDIUMINT(9) NOT NULL,
			`isbless` TINYINT(4) NOT NULL DEFAULT '0',
			`grant_type` TINYINT(4) NOT NULL DEFAULT '0',
			UNIQUE KEY `user_group_map_dedup_user_id_idx` (`user_id`, `group_id`, `grant_type`, `isbless`)
			)
		;
		
	# We insert the de-duplicated record in the table `user_group_map_dedup`
		INSERT INTO `ut_user_group_map_dedup`
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
        ORDER BY `user_id` ASC
            , `group_id` ASC
		;
			
	# We insert the data we need in the `user_group_map` table
		INSERT INTO `user_group_map`
		SELECT `user_id`
			, `group_id`
			, `isbless`
			, `grant_type`
		FROM
			`ut_user_group_map_dedup`
		# The below code is overkill in this context: 
		# the Unique Key Constraint makes sure that all records are unique in the table `user_group_map`
		ON DUPLICATE KEY UPDATE
			`user_id` = `ut_user_group_map_dedup`.`user_id`
			, `group_id` = `ut_user_group_map_dedup`.`group_id`
			, `isbless` = `ut_user_group_map_dedup`.`isbless`
			, `grant_type` = `ut_user_group_map_dedup`.`grant_type`
		;

	# We drop the temp table as we do not need it anymore
		DROP TEMPORARY TABLE IF EXISTS `ut_user_group_map_dedup`;

END $$
DELIMITER ;
 
# Update the procedure to create the dummy environment table so it is a temporary table

    # Drop the permanent table
    DROP TABLE IF EXISTS `ut_temp_dummy_users_for_roles`;

    # Drop the procedure so we can re-create it
    DROP PROCEDURE IF EXISTS `table_to_list_dummy_user_by_environment`;

DELIMITER $$
CREATE PROCEDURE `table_to_list_dummy_user_by_environment`()
SQL SECURITY INVOKER
BEGIN

	# We create a temporary table to record the ids of the dummy users in each environments:
		/*Table structure for table `ut_temp_dummy_users_for_roles` */
			DROP TEMPORARY TABLE IF EXISTS `ut_temp_dummy_users_for_roles`;

			CREATE TEMPORARY TABLE `ut_temp_dummy_users_for_roles` (
			  `environment_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Id of the environment',
			  `environment_name` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
			  `tenant_id` int(11) NOT NULL,
			  `landlord_id` int(11) NOT NULL,
			  `contractor_id` int(11) NOT NULL,
			  `mgt_cny_id` int(11) NOT NULL,
			  `agent_id` int(11) DEFAULT NULL,
			  PRIMARY KEY (`environment_id`)
			) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

		/*Data for the table `ut_temp_dummy_users_for_roles` */
			INSERT INTO `ut_temp_dummy_users_for_roles`(`environment_id`, `environment_name`, `tenant_id`, `landlord_id`, `contractor_id`, `mgt_cny_id`, `agent_id`) values 
				(1,'DEV/Staging', 96, 94, 93, 95, 92),
				(2,'Prod', 93, 91, 90, 92, 89),
				(3,'demo/dev', 4, 3, 5, 6, 2);

END $$
DELIMITER ;

# Update the procedure `add_user_to_role_in_unit` to invite a user to a role in a unit
#   - Make sure we DO call the procedure `create_temp_table_to_update_permissions`
#   - Minor improvements to the code

    DROP PROCEDURE IF EXISTS `add_user_to_role_in_unit`;

DELIMITER $$
CREATE PROCEDURE add_user_to_role_in_unit()
BEGIN

    # This procedure needs the following objects:
    #   - variables:
    #       - `mefe_invitation_id`
    #       - `environment`: Which environment are you creating the unit in?
    #       	- 1 is for the DEV/Staging
    #	        - 2 is for the prod environment
    #          	- 3 is for the Demo environment
    #   - tables
    #       - 'ut_user_group_map_temp'
    #
    #############################################
    #
    # IMPORTANT INFORMATION ABOUT THIS SCRIPT
    #
    #############################################
    #
    # Use this script only if the Unit EXIST in the BZFE 
    # It assumes that the unit has been created with all the necessary BZ objects and all the roles assigned to dummy users.
    #
    # Pre-requisite:
    #	- The table 'ut_invitation_api_data' has been updated 
    # 	- We know the MEFE Invitation id that we need to process.
    #	- We know the environment where this script is run
    # 
    # This script will:
    #	- Create a temp table to store the permissions we are creating
    #	- Reset things for this user for this unit:
    #		- Remove all the permissions for this user for this unit for ALL roles.
    # 	- Remove this user from the list of user in default CC for a case for this role in this unit.
    #	- Get the information needed from the table `ut_invitation_api_data`
    #		- BZ Invitor id
    #		- BZ unit id
    #		- The invited user:
    #			- BZ invited id
    #			- The role in this unit for the invited user
    #			- Is the invited user an occupant of the unit or not.
    #			- Is the user is a MEFE user only:
    #				- IF the user is a MEFE user only 
    #				  Then disable the mail sending functionality from the BZFE.
    #		- The type of invitation for this user
    #			- 'replace_default': Remove and Replace: 
    #				- Grant the permissions to the inviter user for this role for this unit
    #				and 
    #				- Remove the existing default user for this role
    #				and 
    #				- Replace the default user for this role 
    #			- 'default_cc_all': Keep existing assignee, Add invited and make invited default CC
    #				- Grant the permissions to the invited user for this role for this unit
    #				and
    #				- Keep the existing default user as default
    #				and
    #				- Make the invited user an automatic CC to all the new cases for this role for this unit
    #			- 'keep_default' Keep existing and Add invited
    #				- Grant the permissions to the inviter user for this role for this unit
    #				and 
    #				- Keep the existing default user as default
    #				and
    #				- Check if this new user is the first in this role for this unit.
    #					- If it IS the first in this role for this unit.
    #				 	  Then Replace the Default 'dummy user' for this specific role with the BZ user in CC for this role for this unit.
    #					- If it is NOT the first in this role for this unit.
    #					  Do Nothing
    #			- 'remove_user': Remove user from a role in a unit
    #				- Revoke the permissions to the user for this role for this unit
    #				and 
    #				- Check if this user is the default user for this role for this unit.
    #					- If it IS the Default user in this role for this unit.
    #				 	  Then Replace the Default user in this role for this unit with the 'dummy user' for this specific role.
    #					- If it is NOT the Default user in this role for this unit.
    #					  Do Nothing
    #			- Other or no information about the type of invitation
    #				- Grant the permissions to the inviter user for this role for this unit
    #				and
    #				- Check if this new user is the first in this role for this unit.
    #					- If it IS the first in this role for this unit.
    #				 	  Then Replace the Default 'dummy user' for this specific role with the BZ user in CC for this role for this unit.
    #					- If it is NOT the first in this role for this unit.
    #					  Do Nothing
    #	- Process the invitation accordingly.
    #	- Delete an re-create all the entries for the table `user_groups`
    #	- Log the action of the scripts that are run
    #	- Update the invitation once everything has been done
    #	- Exit with either:
    #		- an error message (there was a problem somewhere)
    #		or 
    #		- no error message (succcess)
    #
    # Limits of this script:
    #	- Unit must have all roles created with Dummy user roles.
    #
    #    
					
    # We need the table `ut_user_group_map_temp`
        CALL `create_temp_table_to_update_permissions`;
    
    #####################################################
    #					
    # We need to define all the variables we need
    #					
    #####################################################

    # We make sure that all the variable we user are set to NULL first
    # This is to avoid issue of a variable 'silently' using a value from a previous run
        SET @reference_for_update = NULL;
        SET @mefe_invitor_user_id = NULL;
        SET @product_id = NULL;
        SET @creator_bz_id = NULL;
        SET @creator_pub_name = NULL;
        SET @id_role_type = NULL;
        SET @bz_user_id = NULL;
        SET @role_user_g_description = NULL;
        SET @user_pub_name = NULL;
        SET @role_user_pub_info = NULL;
        SET @user_role_desc = NULL;
        SET @role_user_more = NULL;
        SET @user_role_type_description = NULL;
        SET @user_role_type_name = NULL;
        SET @component_id_this_role = NULL;
        SET @current_default_assignee_this_role = NULL;
        SET @bz_user_id_dummy_tenant = NULL;
        SET @bz_user_id_dummy_landlord = NULL;
        SET @bz_user_id_dummy_contractor = NULL;
        SET @bz_user_id_dummy_mgt_cny = NULL;
        SET @bz_user_id_dummy_agent = NULL;
        SET @bz_user_id_dummy_user_this_role = NULL;
        SET @is_occupant = NULL;
        SET @invitation_type = NULL;
        SET @is_mefe_only_user = NULL;
        SET @user_in_default_cc_for_cases = NULL;
        SET @replace_default_assignee = NULL;
        SET @remove_user_from_role = NULL;
        SET @can_see_time_tracking = NULL;
        SET @can_create_shared_queries = NULL;
        SET @can_tag_comment = NULL;
        SET @can_create_new_cases = NULL;
        SET @can_edit_a_case = NULL;
        SET @can_see_all_public_cases = NULL;
        SET @can_edit_all_field_in_a_case_regardless_of_role = NULL;
        SET @can_see_unit_in_search = NULL;
        SET @user_is_publicly_visible = NULL;
        SET @user_can_see_publicly_visible = NULL;
        SET @can_ask_to_approve_flags = NULL;
        SET @can_approve_all_flags = NULL;
        SET @is_current_assignee_this_role_a_dummy_user = NULL;
        SET @this_script = NULL;

    # Default values:
        
        #User Permissions in the unit:
            # Generic Permissions
                SET @can_see_time_tracking = 1;
                SET @can_create_shared_queries = 0;
                SET @can_tag_comment = 1;
            # Product/Unit specific permissions
                SET @can_create_new_cases = 1;
                SET @can_edit_a_case = 1;
                SET @can_see_all_public_cases = 1;
                SET @can_edit_all_field_in_a_case_regardless_of_role = 1;
                SET @can_see_unit_in_search = 1;
                SET @user_is_publicly_visible = 1;
                SET @user_can_see_publicly_visible = 1;
                SET @can_ask_to_approve_flags = 1;
                SET @can_approve_all_flags = 1;
        
        # Do we need to make the invitee a default CC for all new cases for this role in this unit?
            SET @user_in_default_cc_for_cases = 0;

    # Timestamp	
        SET @timestamp = NOW();

    # We define the name of this script for future reference:
        SET @this_script = 'PROCEDURE add_user_to_role_in_unit';
        
    # We create a temporary table to record the ids of the dummy users in each environments:
        CALL `table_to_list_dummy_user_by_environment`;
        
    # The reference of the record we want to update in the table `ut_invitation_api_data`
        SET @reference_for_update = (SELECT `id` FROM `ut_invitation_api_data` WHERE `mefe_invitation_id` = @mefe_invitation_id);	

    # The MEFE information:
        SET @mefe_invitor_user_id = (SELECT `mefe_invitor_user_id` FROM `ut_invitation_api_data` WHERE `id` = @reference_for_update);

    # The unit name and description
        SET @product_id = (SELECT `bz_unit_id` FROM `ut_invitation_api_data` WHERE `id` = @reference_for_update);

    # The Invitor - BZ user id of the user that has genereated the invitation.
        SET @creator_bz_id = (SELECT `bzfe_invitor_user_id` FROM `ut_invitation_api_data` WHERE `id` = @reference_for_update);

        # We populate the additional variables that we will need for this script to work:
            SET @creator_pub_name = (SELECT `realname` FROM `profiles` WHERE `userid` = @creator_bz_id);

    # Role in this unit for the invited user:
        #	- Tenant 1
        # 	- Landlord 2
        #	- Agent 5
        #	- Contractor 3
        #	- Management company 4
        SET @id_role_type = (SELECT `user_role_type_id` FROM `ut_invitation_api_data` WHERE `id` = @reference_for_update);
            
    # The user who you want to associate to this unit - BZ user id of the user that you want to associate/invite to the unit.
        SET @bz_user_id = (SELECT `bz_user_id` FROM `ut_invitation_api_data` WHERE `id` = @reference_for_update);

        # We populate the additional variables that we will need for this script to work:
            SET @role_user_g_description = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`=@id_role_type);
            SET @user_pub_name = (SELECT (LEFT(`login_name`,INSTR(`login_name`,"@")-1)) FROM `profiles` WHERE `userid` = @bz_user_id);
            SET @role_user_more = (SELECT `user_more` FROM `ut_invitation_api_data` WHERE `id` = @reference_for_update);		
            SET @role_user_pub_info = CONCAT(@user_pub_name
                                    , IF (@role_user_more = '', '', ' - ')
                                    , IF (@role_user_more = '', '', @role_user_more)
                                    )
                                    ;
            SET @user_role_desc = (CONCAT(@role_user_g_description, ' - ', @role_user_pub_info));
        
        SET @user_role_type_description = (SELECT `bz_description` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type);
        SET @user_role_type_name = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type);
        
        # We need to get the component_id for this role for this product/unit
        # We get that from the ut_product_group table.
            SET @component_id_this_role = (SELECT `component_id` 
                                        FROM `ut_product_group` 
                                        WHERE `product_id` = @product_id 
                                            AND `role_type_id` = @id_role_type
                                            AND `group_type_id` = 2)
                                            ;
                    
        # Is the current assignee for this role for this unit one of the dummy user in this environment?

            # What is the CURRENT default assignee for the role this user has been invited to?
                SET @current_default_assignee_this_role = (SELECT `initialowner` FROM `components` WHERE `id` = @component_id_this_role);

            # What is the default dummy user id for this environment?
            
                # Get the BZ profile id of the dummy users based on the environment variable
                    # Tenant 1
                        SET @bz_user_id_dummy_tenant = (SELECT `tenant_id` 
                                                    FROM `ut_temp_dummy_users_for_roles` 
                                                    WHERE `environment_id` = @environment)
                                                    ;

                    # Landlord 2
                        SET @bz_user_id_dummy_landlord = (SELECT `landlord_id` 
                                                    FROM `ut_temp_dummy_users_for_roles` 
                                                    WHERE `environment_id` = @environment)
                                                    ;
                        
                    # Contractor 3
                        SET @bz_user_id_dummy_contractor = (SELECT `contractor_id` 
                                                    FROM `ut_temp_dummy_users_for_roles` 
                                                    WHERE `environment_id` = @environment)
                                                    ;
                        
                    # Management company 4
                        SET @bz_user_id_dummy_mgt_cny = (SELECT `mgt_cny_id` 
                                                    FROM `ut_temp_dummy_users_for_roles` 
                                                    WHERE `environment_id` = @environment)
                                                    ;
                        
                    # Agent 5
                        SET @bz_user_id_dummy_agent = (SELECT `agent_id` 
                                                    FROM `ut_temp_dummy_users_for_roles` 
                                                    WHERE `environment_id` = @environment)
                                                    ;

            # What is the BZ dummy user id for this role in this script?
                SET @bz_user_id_dummy_user_this_role = IF( @id_role_type = 1
                                                , @bz_user_id_dummy_tenant
                                                , IF (@id_role_type = 2
                                                    , @bz_user_id_dummy_landlord
                                                    , IF (@id_role_type = 3
                                                        , @bz_user_id_dummy_contractor
                                                        , IF (@id_role_type = 4
                                                            , @bz_user_id_dummy_mgt_cny
                                                            , IF (@id_role_type = 5
                                                                , @bz_user_id_dummy_agent
                                                                , 'Something is very wrong!! - error on line 484'
                                                                )
                                                            )
                                                        )
                                                    )
                                                )
                                                ;

    # Is the invited user an occupant of the unit?
        SET @is_occupant = (SELECT `is_occupant` FROM `ut_invitation_api_data` WHERE `id` = @reference_for_update);
        
    # What type of invitation is this?
        SET @invitation_type = (SELECT `invitation_type` FROM `ut_invitation_api_data` WHERE `id` = @reference_for_update);
        
    # Do we need to disable the BZ email notification for this user?
        SET @is_mefe_only_user = (SELECT `is_mefe_only_user` 
                                FROM `ut_invitation_api_data` 
                                WHERE `id` = @reference_for_update)
                                ;
                                
    # User permissions:
        # These will depend on :
        #	- The invitation type
        #	- The default values currently configured
        # We NEED to have defined the variable @invitation_type FIRST!

        # Things which depends on the invitation type:
        
            # Do we need to make the invitee a default CC for all new cases for this role in this unit?
            # This depends on the type of invitation that we are creating
            #	- 1 (YES) if the invitation type is
            #		- 'default_cc_all'
            #	- 0 (NO) if the invitation type is any other invitation type
            #
                    SET @user_in_default_cc_for_cases = IF (@invitation_type = 'default_cc_all'
                        , 1
                        , 0
                        )
                        ;

            # Do we need to replace the default assignee for this role in this unit?
            # This depends on the type of invitation that we are creating
            #	- 1 (YES) if the invitation type is
            #		- 'replace_default'
            #	- 0 (NO) if the invitation type is any other invitation type
            #
                    SET @replace_default_assignee = IF (@invitation_type = 'replace_default'
                        , 1
                        , 0
                        )
                        ;
                        
            # Do we need to revoke the permission for this user for this unit?
            # This depends on the type of invitation that we are creating
            #	- 1 (YES) if the invitation type is
            #		- 'remove_user'
            #	- 0 (NO) if the invitation type is any other invitation type
            #
                    SET @remove_user_from_role = IF (@invitation_type = 'remove_user'
                        , 1
                        , 0
                        )
                        ;

    # Answer to the question "Is the current default assignee for this role one of the dummy users?"
        SET @is_current_assignee_this_role_a_dummy_user = IF( @replace_default_assignee = 1
            , 0
            , IF(@current_default_assignee_this_role = @bz_user_id_dummy_user_this_role
                , 1
                , 0
                )
            )
            ;
                                    
    #################################################################
    #
    # All the variables have been set - we can call the procedures
    #
    #################################################################
        
    # RESET: We remove the user from the list of user in default CC for this role
    # This procedure needs the following objects:
    #	- variables:
    #		- @bz_user_id : 
    #		  the BZ user id of the user
    #		- @component_id_this_role: 
    #		  The id of the role in the bz table `components`
        CALL `remove_user_from_default_cc`;

    # We are recording this for KPI measurements
    #	- Number of user per role per unit.

        # We record the information about the users that we have just created
        # If this is the first time we record something for this user for this unit, we create a new record.
        # If there is already a record for THAT USER for THIS, then we are updating the information
            
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
                (@timestamp
                , @creator_bz_id
                , @bz_user_id
                , @bz_user_id
                , @product_id
                , @id_role_type
                # Global permission for the whole installation
                , @can_see_time_tracking
                , @can_create_shared_queries
                , @can_tag_comment
                # Attributes of the user
                , @is_occupant
                # User visibility
                , @user_is_publicly_visible
                , @user_can_see_publicly_visible
                # Permissions for cases for this unit.
                , @user_in_default_cc_for_cases
                , @can_create_new_cases
                , @can_edit_a_case
                , @can_see_all_public_cases
                , @can_edit_all_field_in_a_case_regardless_of_role
                # For the flags
                , @can_ask_to_approve_flags
                , @can_approve_all_flags
                # Permissions to create or modify other users
                , 0
                , 0
                , 0
                , 0
                , 0
                , @user_pub_name
                , @role_user_more
                , CONCAT('On '
                        , @timestamp
                        , ': Created with the script - '
                        , @this_script
                        , '.\r\ '
                        , `comment`)
                )
                ON DUPLICATE KEY UPDATE
                `created` = @timestamp
                , `record_created_by` = @creator_bz_id
                , `role_type_id` = @id_role_type
                # Global permission for the whole installation
                , `can_see_time_tracking` = @can_see_time_tracking
                , `can_create_shared_queries` = @can_create_shared_queries
                , `can_tag_comment` = @can_tag_comment
                # Attributes of the user
                , `is_occupant` = @is_occupant
                # User visibility
                , `is_public_assignee` = @user_is_publicly_visible
                , `is_see_visible_assignee` = @user_can_see_publicly_visible
                # Permissions for cases for this unit.
                , `is_in_cc_for_role` = @user_in_default_cc_for_cases
                , `can_create_case` = @can_create_new_cases
                , `can_edit_case` = @can_edit_a_case
                , `can_see_case` = @can_see_all_public_cases
                , `can_edit_all_field_regardless_of_role` = @can_edit_all_field_in_a_case_regardless_of_role
                # For the flags
                , `is_flag_requestee` = @can_ask_to_approve_flags
                , `is_flag_approver` = @can_approve_all_flags
                # Permissions to create or modify other users
                , `can_create_any_sh` = 0
                , `can_create_same_sh` = 0
                , `can_approve_user_for_flags` = 0
                , `can_decide_if_user_visible` = 0
                , `can_decide_if_user_can_see_visible` = 0
                , `public_name` = @user_pub_name
                , `more_info` = CONCAT('On: '
                    , @timestamp
                    , '.\r\Updated to '
                    , @role_user_more
                    , '. \r\ '
                    , `more_info`
                    )
                , `comment` = CONCAT('On '
                    , @timestamp
                    , '.\r\Updated with the script - '
                    , @this_script
                    , '.\r\ '
                    , `comment`)
            ;

    # We always reset the permissions to the default permissions first
        # Revoke all permissions for this user in this unit
            # This procedure needs the following objects:
            #	- Variables:
            #		- @product_id
            #		- @bz_user_id
            CALL `revoke_all_permission_for_this_user_in_this_unit`;
            
        # Prepare the permissions - configure these to default:
            # Generic Permissions
                # These need the following objects:
                #	- table 'ut_user_group_map_temp'
                #	- Variables:
                #		- @bz_user_id
                    CALL `can_see_time_tracking`;
                    CALL `can_create_shared_queries`;
                    CALL `can_tag_comment`;
            # Product/Unit specific permissions
                # These need the following objects:
                #	- table 'ut_user_group_map_temp'
                #	- Variables:
                #		- @bz_user_id
                #		- @product_id
                    CALL `can_create_new_cases`;
                    CALL `can_edit_a_case`;
                    CALL `can_see_all_public_cases`;
                    CALL `can_edit_all_field_in_a_case_regardless_of_role`;
                    CALL `can_see_unit_in_search`;
                    
                    CALL `user_is_publicly_visible`;
                    CALL `user_can_see_publicly_visible`;
                    
                    CALL `can_ask_to_approve_flags`;
                    CALL `can_approve_all_flags`;
            # Role/Component specific permissions
                # These need the following objects:
                #	- table 'ut_user_group_map_temp'
                #	- Variables:
                #		- @id_role_type
                #		- @bz_user_id
                #		- @product_id
                #		- @is_occupant
                    CALL `show_to_tenant`;
                    CALL `is_tenant`;
                    CALL `default_tenant_can_see_tenant`;
                    
                    CALL `show_to_landlord`;
                    CALL `are_users_landlord`;
                    CALL `default_landlord_see_users_landlord`;
                    
                    CALL `show_to_contractor`;
                    CALL `are_users_contractor`;
                    CALL `default_contractor_see_users_contractor`;
                    
                    CALL `show_to_mgt_cny`;
                    CALL `are_users_mgt_cny`;
                    CALL `default_mgt_cny_see_users_mgt_cny`;
                    
                    CALL `show_to_agent`;
                    CALL `are_users_agent`;
                    CALL `default_agent_see_users_agent`;
                    
                    CALL `show_to_occupant`;
                    CALL `is_occupant`;
                    CALL `default_occupant_can_see_occupant`;
            
        # All the permission have been prepared, we can now update the permissions table
        #		- This NEEDS the table 'ut_user_group_map_temp'
            CALL `update_permissions_invited_user`;
        
    # Disable the BZ email notification engine if needed
    # This procedure needs the following objects:
    #	- variables:
    #		- @is_mefe_only_user
    #		- @creator_bz_id
    #		- @bz_user_id
        CALL `disable_bugmail`;
        
    # Replace the default dummy user for this role if needed
    # This procedure needs the following objects:
    #	- variables:
    #		- @is_current_assignee_this_role_a_dummy_user
    #		- @component_id_this_role
    #		- @bz_user_id
    #		- @user_role_desc
    #		- @id_role_type
    #		- @user_pub_name
    #		- @product_id
    #		- @creator_bz_id
    #		- @mefe_invitation_id
    #		- @mefe_invitor_user_id
    #		- @is_occupant
    #		- @is_mefe_only_user
    #		- @role_user_more
        CALL `update_assignee_if_dummy_user`;

    # Make the invited user default CC for all cases in this unit if needed
    # This procedure needs the following objects:
    #	- variables:
    #		- @user_in_default_cc_for_cases
    #		- @bz_user_id
    #		- @product_id
    #		- @component_id
    #		- @role_user_g_description
        # Make sure the variable we need is correctly defined
            SET @component_id = @component_id_this_role;
        
        # Run the procedure
            CALL `user_in_default_cc_for_cases`;	

    # Make the invited user the new default assignee for all cases in this role in this unit if needed
    # This procedure needs the following objects:
    #	- variables:
    #		- @replace_default_assignee
    #		- @bz_user_id
    #		- @product_id
    #		- @component_id
    #		- @role_user_g_description
        # Make sure the variable we need is correctly defined
            SET @component_id = @component_id_this_role;
        
        # Run the procedure
            CALL `user_is_default_assignee_for_cases`;

    # Remove this user from this role in this unit if needed:
    # This procedure needs the following objects
    #	- Variables:
    #		- @remove_user_from_role
    #		- @component_id_this_role
    #		- @product_id
    #		- @bz_user_id
    #		- @bz_user_id_dummy_user_this_role
    #		- @id_role_type
    #		- @user_role_desc
    #		- @user_pub_name
    #		- @creator_bz_id
        CALL `remove_user_from_role`;

    # Update the table 'ut_invitation_api_data' so we record what we have done

        # Timestamp	
            SET @timestamp = NOW();
            
        # We do the update to record that we have reached the end of the script...
            UPDATE `ut_invitation_api_data`
                SET `processed_datetime` = @timestamp
                    , `script` = @this_script
                WHERE `mefe_invitation_id` = @mefe_invitation_id
                ;

END
$$
DELIMITER ;

# Update the procedure to create a temp table to assign group permissions

    DROP PROCEDURE IF EXISTS `create_temp_table_to_update_group_permissions`;

DELIMITER $$
CREATE PROCEDURE `create_temp_table_to_update_group_permissions`()
SQL SECURITY INVOKER
BEGIN

	# DELETE the temp table if it exists
	    DROP TEMPORARY TABLE IF EXISTS `ut_group_group_map_temp`;

	# Re-create the temp table
        CREATE TEMPORARY TABLE `ut_group_group_map_temp` (
        `member_id` MEDIUMINT(9) NOT NULL
        , `grantor_id` MEDIUMINT(9) NOT NULL
        , `grant_type` TINYINT(4) NOT NULL DEFAULT 0
        )
        ;
    # Add the records that exist in the table group_group_map
        INSERT INTO `ut_group_group_map_temp`
            SELECT *
            FROM `group_group_map`
        ;

END
$$
DELIMITER ;

# Update the procedure to create a temp table to assign user permissions

    DROP PROCEDURE IF EXISTS `create_temp_table_to_update_permissions`;

DELIMITER $$
CREATE PROCEDURE `create_temp_table_to_update_permissions`()
SQL SECURITY INVOKER
BEGIN
    # We use a temporary table to make sure we do not have duplicates.
		
		# DELETE the temp table if it exists
		DROP TEMPORARY TABLE IF EXISTS `ut_user_group_map_temp`;
		
		# Re-create the temp table
		CREATE TEMPORARY TABLE `ut_user_group_map_temp` (
		  `user_id` MEDIUMINT(9) NOT NULL
		  , `group_id` MEDIUMINT(9) NOT NULL
		  , `isbless` TINYINT(4) NOT NULL DEFAULT 0
          , `grant_type` TINYINT(4) NOT NULL DEFAULT 0
		)
        ;

		# Add all the records that exists in the table user_group_map
		INSERT INTO `ut_user_group_map_temp`
			SELECT *
			FROM `user_group_map`;

END
$$
DELIMITER ;

# Update the procedure to create a unit with dummy users

    DROP PROCEDURE IF EXISTS `unit_create_with_dummy_users`;

DELIMITER $$
CREATE PROCEDURE `unit_create_with_dummy_users`()
SQL SECURITY INVOKER
BEGIN
	# This procedure needs the following objects:
    #   - variables:
	#	    - @mefe_unit_id
	#	    - @environment
    #   - Tables:
    #       - `ut_group_group_map_temp`
    #       - `ut_user_group_map_temp`
    #
    # This procedure needs the following info in the table `ut_data_to_create_units`
    #   - id_unit_to_create
    #   - mefe_unit_id
    #   - mefe_creator_user_id
    #   - bzfe_creator_user_id
    #   - classification_id
    #   - unit_name
    #   - unit_description_details
    # 
	# This procedure will create
	#	- The unit
	#	- All the objects needed by the unit
	#		- Milestone
	#		- Version
	# 		- Groups
	#		- Flagtypes
	#		- All 5 roles/components with a dummy user for the relevant environment
	#			- Tenant
	#			- Landlord
	#			- Contractor
	#			- Management Company
	#			- Agent
	#		- Assign the permission so we can do what we need
	#		- Log the group_id that we have created so we can assign permissions later
    #
    # This procedure will update the following information:
    #   -  in the table `ut_data_to_create_units`
    #       - bz_created_date
    #       - comment
    #       - product_id    
	#	- the Unee-T script log
	#	- BZ db table `audit_log`
    #
    # This procedure depends on the following procedures:
    #   - `table_to_list_dummy_user_by_environment`
    
	# What is the record that we need to use to create the objects in BZ?
		SET @unit_reference_for_import = (SELECT `id_unit_to_create` FROM `ut_data_to_create_units` WHERE `mefe_unit_id` = @mefe_unit_id);
	
	# We record the name of this procedure for future debugging and audit_log
		SET @script = 'PROCEDURE - unit_create_with_dummy_users';
		SET @timestamp = NOW();

	# We create a temporary table to record the ids of the dummy users in each environments:

        CALL `table_to_list_dummy_user_by_environment`;

    # We create the temporary tables to update the group permissions
        CALL `create_temp_table_to_update_group_permissions`;
    
    # We create the temporary tables to update the user permissions
        CALL `create_temp_table_to_update_permissions`;
			
	# Get the BZ profile id of the dummy users based on the environment variable
		# Tenant 1
			SET @bz_user_id_dummy_tenant = (SELECT `tenant_id` FROM `ut_temp_dummy_users_for_roles` WHERE `environment_id` = @environment);
		
        # Landlord 2
			SET @bz_user_id_dummy_landlord = (SELECT `landlord_id` FROM `ut_temp_dummy_users_for_roles` WHERE `environment_id` = @environment);
			
		# Contractor 3
			SET @bz_user_id_dummy_contractor = (SELECT `contractor_id` FROM `ut_temp_dummy_users_for_roles` WHERE `environment_id` = @environment);
			
		# Management company 4
			SET @bz_user_id_dummy_mgt_cny = (SELECT `mgt_cny_id` FROM `ut_temp_dummy_users_for_roles` WHERE `environment_id` = @environment);
			
		# Agent 5
			SET @bz_user_id_dummy_agent = (SELECT `agent_id` FROM `ut_temp_dummy_users_for_roles` WHERE `environment_id` = @environment);

	# The unit:
		# BZ Classification id for the unit that you want to create (default is 2)
		    SET @classification_id = (SELECT `classification_id` FROM `ut_data_to_create_units` WHERE `id_unit_to_create` = @unit_reference_for_import);
		
        # The name and description
            SET @unit_name = (SELECT `unit_name` FROM `ut_data_to_create_units` WHERE `id_unit_to_create` = @unit_reference_for_import);
            SET @unit_description_details = (SELECT `unit_description_details` FROM `ut_data_to_create_units` WHERE `id_unit_to_create` = @unit_reference_for_import);
            SET @unit_description = @unit_description_details;
		
	# The users associated to this unit.	
		# BZ user id of the user that is creating the unit (default is 1 - Administrator).
		# For LMB migration, we use 2 (support.nobody)
		    SET @creator_bz_id = (SELECT `bzfe_creator_user_id` FROM `ut_data_to_create_units` WHERE `id_unit_to_create` = @unit_reference_for_import);
		
	# Other important information that should not change:
            SET @visibility_explanation_1 = 'Visible only to ';
            SET @visibility_explanation_2 = ' for this unit.';

	# The global permission for the application

	# This should not change, it was hard coded when we created Unee-T
		# Can tag comments
			SET @can_tag_comment_group_id = 18;	
		
	# We need to create the component for ALL the roles.
	# We do that using dummy users for all the roles different from the user role.	
	#		- agent -> temporary.agent.dev@unee-t.com
	#		- landlord  -> temporary.landlord.dev@unee-t.com
	#		- Tenant  -> temporary.tenant.dev@unee-t.com
	#		- Contractor  -> temporary.contractor.dev@unee-t.com
	# We populate the additional variables that we will need for this script to work
		# For the product
        
            # We are predicting the product id to avoid name duplicates
   			    SET @predicted_product_id = ((SELECT MAX(`id`) FROM `products`) + 1);

            # We need a unique unit name
			    SET @unit_bz_name = CONCAT(@unit_name, '-', @predicted_product_id);

            # We need a default milestone for that unit
                SET @default_milestone = '---';

            # We need a default version for that unit
	    	    SET @default_version = '---';
			
	# We now create the unit we need.
		INSERT INTO `products`
			(`name`
			, `classification_id`
			, `description`
			, `isactive`
			, `defaultmilestone`
			, `allows_unconfirmed`
			)
			VALUES
			(@unit_bz_name, @classification_id, @unit_description, 1, @default_milestone, 1);
	
        # Get the actual id that was created for that unit
            SET @product_id = (SELECT LAST_INSERT_ID());

    	# Log the actions of the script.
			SET @script_log_message = CONCAT('A new unit #'
									, (SELECT IFNULL(@product_id, 'product_id is NULL'))
                                    , ' with the predicted product_id # '
                                    , @predicted_product_id
									, ' ('
									, (SELECT IFNULL(@unit_bz_name, 'unit is NULL'))
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
				(NOW(), @script, @script_log_message)
				;
			
			SET @script_log_message = NULL;

    # We can now get the real id of the unit

        SET @unit = CONCAT(@unit_bz_name, '-', @product_id);

    # We log this in the `audit_log` table
		
		INSERT INTO `audit_log` 
			(`user_id`
			, `class`
			, `object_id`
			, `field`
			, `removed`
			, `added`
			, `at_time`
			)
			VALUES
			(@creator_bz_id
			, 'Bugzilla::Product'
			, @product_id
			, '__create__'
			, NULL
			, @unit
			, @timestamp
			)
			;

    # We prepare all the names we will need

		SET @unit_for_query = REPLACE(@unit, ' ', '%');
		
		SET @unit_for_flag = REPLACE(@unit_for_query, '%', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '-', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '!', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '@', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '#', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '$', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '%', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '^', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '' , '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '&', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '*', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '(', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, ')', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '+', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '=', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '<', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '>', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, ':', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, ';', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '"', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, ',', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '.', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '?', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '/', '_');
		SET @unit_for_flag = REPLACE(@unit_for_flag, '\\','_');
		
		SET @unit_for_group = REPLACE(@unit_for_flag, '_', '-');
		SET @unit_for_group = REPLACE(@unit_for_group, '----', '-');
		SET @unit_for_group = REPLACE(@unit_for_group, '---', '-');
		SET @unit_for_group = REPLACE(@unit_for_group, '--', '-');

		# We need a version for this product
			
			# We can now insert the version there
				INSERT INTO `versions`
					(`value`
					, `product_id`
					, `isactive`
					)
					VALUES
					(@default_version, @product_id, 1)
					;

            # We get the id for the version 
                SET @version_id = (SELECT LAST_INSERT_ID());

			# We also log this in the `audit_log` table
					
						INSERT INTO `audit_log` 
							(`user_id`
							, `class`
							, `object_id`
							, `field`
							, `removed`
							, `added`
							, `at_time`
							)
							VALUES
							(@creator_bz_id
							, 'Bugzilla::Version'
							, @version_id
							, '__create__'
							, NULL
							, @default_version
							, @timestamp
							)
							;
					
		# We now create the milestone for this product.

			# We can now insert the milestone there
			INSERT INTO `milestones`
				(`product_id`
				, `value`
				, `sortkey`
				, `isactive`
				)
				VALUES
				(@product_id, @default_milestone, 0 , 1)
				;
            
            # We get the id for the milestone 
                SET @milestone_id = (SELECT LAST_INSERT_ID());
		
			# We also log this in the `audit_log` table
			
				INSERT INTO `audit_log` 
					(`user_id`
					, `class`
					, `object_id`
					, `field`
					, `removed`
					, `added`
					, `at_time`
					)
					VALUES
					(@creator_bz_id, 'Bugzilla::Milestone', @milestone_id, '__create__', NULL, @default_milestone, @timestamp)
					;

	#  We create all the components/roles we need
		# For the temporary users:
			# Tenant
				SET @role_user_g_description_tenant = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`= 1);
				SET @user_pub_name_tenant = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_tenant);
				SET @role_user_pub_info_tenant = CONCAT(@user_pub_name_tenant
													,' - '
													, 'THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL '
													, @role_user_g_description_tenant
													, ' TO THIS UNIT'
													);
				SET @user_role_desc_tenant = @role_user_pub_info_tenant;

			# Landlord
				SET @role_user_g_description_landlord = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`= 2);
				SET @user_pub_name_landlord = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_landlord);
				SET @role_user_pub_info_landlord = CONCAT(@user_pub_name_landlord
													,' - '
													, 'THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL '
													, @role_user_g_description_landlord
													, ' TO THIS UNIT'
													);
				SET @user_role_desc_landlord = @role_user_pub_info_landlord;
			
			# Agent
				SET @role_user_g_description_agent = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`= 5);
				SET @user_pub_name_agent = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_agent);
				SET @role_user_pub_info_agent = CONCAT(@user_pub_name_agent
													,' - '
													, 'THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL '
													, @role_user_g_description_agent
													, ' TO THIS UNIT'
													);
				SET @user_role_desc_agent = @role_user_pub_info_agent;
			
			# Contractor
				SET @role_user_g_description_contractor = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`= 3);
				SET @user_pub_name_contractor = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_contractor);
				SET @role_user_pub_info_contractor = CONCAT(@user_pub_name_contractor
													,' - '
													, 'THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL '
													, @role_user_g_description_contractor
													, ' TO THIS UNIT'
													);
				SET @user_role_desc_contractor = @role_user_pub_info_contractor;
			
			# Management Company
				SET @role_user_g_description_mgt_cny = (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type`= 4);
				SET @user_pub_name_mgt_cny = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_mgt_cny);
				SET @role_user_pub_info_mgt_cny = CONCAT(@user_pub_name_mgt_cny
													,' - '
													, 'THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL '
													, @role_user_g_description_mgt_cny
													, ' TO THIS UNIT'
													);
				SET @user_role_desc_mgt_cny = @role_user_pub_info_mgt_cny;

		# We have eveything, we can create the components we need:
        # We insert the component 1 by 1 to get the id for each component easily

			# Tenant (component_id_tenant)
                INSERT INTO `components`
                    (`name`
                    , `product_id`
                    , `initialowner`
                    , `initialqacontact`
                    , `description`
                    , `isactive`
                    ) 
                    VALUES
                    (@role_user_g_description_tenant
                    , @product_id
                    , @bz_user_id_dummy_tenant
                    , @bz_user_id_dummy_tenant
                    , @user_role_desc_tenant
                    , 1
                    )
                    ;

                # We get the id for the component for the tenant 
                    SET @component_id_tenant = (SELECT LAST_INSERT_ID());

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('The following component #'
                                            , @component_id_tenant
                                            , ' was created for the unit # '
                                            , @product_id
                                            , 'with temporary user as the '
                                            , 'tenant:'
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

            # Landlord (component_id_landlord)
                INSERT INTO `components`
                    (`name`
                    , `product_id`
                    , `initialowner`
                    , `initialqacontact`
                    , `description`
                    , `isactive`
                    ) 
                    VALUES
                    (@role_user_g_description_landlord
                    , @product_id
                    , @bz_user_id_dummy_landlord
                    , @bz_user_id_dummy_landlord
                    , @user_role_desc_landlord
                    , 1
                    )
                    ;

                # We get the id for the component for the Landlord
                    SET @component_id_landlord = (SELECT LAST_INSERT_ID());

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('The following component #'
                                            , @component_id_landlord
                                            , ' was created for the unit # '
                                            , @product_id
                                            , 'with temporary user as the '
                                            , 'Landlord:'
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

            # Agent (component_id_agent)
                INSERT INTO `components`
                    (`name`
                    , `product_id`
                    , `initialowner`
                    , `initialqacontact`
                    , `description`
                    , `isactive`
                    ) 
                    VALUES
                    (@role_user_g_description_agent
                    , @product_id
                    , @bz_user_id_dummy_agent
                    , @bz_user_id_dummy_agent
                    , @user_role_desc_agent
                    , 1
                    )
                    ;
            
                # We get the id for the component for the Agent
                    SET @component_id_agent = (SELECT LAST_INSERT_ID());

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('The following component #'
                                            , @component_id_agent
                                            , ' was created for the unit # '
                                            , @product_id
                                            , 'with temporary user as the '
                                            , 'Agent:'
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

            # Contractor (component_id_contractor)
                INSERT INTO `components`
                    (`name`
                    , `product_id`
                    , `initialowner`
                    , `initialqacontact`
                    , `description`
                    , `isactive`
                    ) 
                    VALUES
                    (@role_user_g_description_contractor
                    , @product_id
                    , @bz_user_id_dummy_contractor
                    , @bz_user_id_dummy_contractor
                    , @user_role_desc_contractor
                    , 1
                    )
                    ;
            
                # We get the id for the component for the Contractor
                    SET @component_id_contractor = (SELECT LAST_INSERT_ID());

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('The following component #'
                                            , @component_id_contractor
                                            , ' was created for the unit # '
                                            , @product_id
                                            , 'with temporary user as the '
                                            , 'Contractor:'
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
            
            # Management Company (component_id_mgt_cny)
                INSERT INTO `components`
                    (`name`
                    , `product_id`
                    , `initialowner`
                    , `initialqacontact`
                    , `description`
                    , `isactive`
                    ) 
                    VALUES
                    (@role_user_g_description_mgt_cny
                    , @product_id
                    , @bz_user_id_dummy_mgt_cny
                    , @bz_user_id_dummy_mgt_cny
                    , @user_role_desc_mgt_cny
                    , 1
                    )
                    ;
            
                # We get the id for the component for the Management Company 
                    SET @component_id_mgt_cny = (SELECT LAST_INSERT_ID());

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('The following component #'
                                            , @component_id_mgt_cny
                                            , ' was created for the unit # '
                                            , @product_id
                                            , 'with temporary user as the '
                                            , 'Management Company:'
                                            , '\r\- '
                                            , (SELECT IFNULL(@role_user_g_description_mgt_cny, 'role_user_g_description is NULL'))
                                            , ' (role_type_id #'
                                            , '4'
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
                    
            # We update the BZ logs
                INSERT INTO `audit_log`
                    (`user_id`
                    , `class`
                    , `object_id`
                    , `field`
                    , `removed`
                    , `added`
                    , `at_time`
                    ) 
                    VALUES 
                    (@creator_bz_id, 'Bugzilla::Component', @component_id_tenant, '__create__', NULL, @role_user_g_description_tenant, @timestamp)
                    , (@creator_bz_id, 'Bugzilla::Component', @component_id_landlord, '__create__', NULL, @role_user_g_description_landlord, @timestamp)
                    , (@creator_bz_id, 'Bugzilla::Component', @component_id_agent, '__create__', NULL, @role_user_g_description_agent, @timestamp)
                    , (@creator_bz_id, 'Bugzilla::Component', @component_id_contractor, '__create__', NULL, @role_user_g_description_contractor, @timestamp)
                    , (@creator_bz_id, 'Bugzilla::Component', @component_id_mgt_cny, '__create__', NULL, @role_user_g_description_mgt_cny, @timestamp)
                    ;

	# We create the goups we need
		# For simplicity reason, it is better to create ALL the groups we need for all the possible roles and permissions
		# This will avoid a scenario where we need to grant permission to see occupants for instances but the group for occupants does not exist yet...
		
		# We prepare the information for each group that we will use to do that
		
			# Groups common to all components/roles for this unit
				# Allow user to create a case for this unit
					SET @group_name_create_case_group = (CONCAT(@unit_for_group,'-01-Can-Create-Cases'));
					SET @group_description_create_case_group = 'User can create cases for this unit.';
					
				# Allow user to create a case for this unit
					SET @group_name_can_edit_case_group = (CONCAT(@unit_for_group,'-01-Can-Edit-Cases'));
					SET @group_description_can_edit_case_group = 'User can edit a case they have access to';
					
				# Allow user to see the cases for this unit
					SET @group_name_can_see_cases_group = (CONCAT(@unit_for_group,'-02-Case-Is-Visible-To-All'));
					SET @group_description_can_see_cases_group = 'User can see the public cases for the unit';
					
				# Allow user to edit all fields in the case for this unit regardless of his/her role
					SET @group_name_can_edit_all_field_case_group = (CONCAT(@unit_for_group,'-03-Can-Always-Edit-all-Fields'));
					SET @group_description_can_edit_all_field_case_group = 'Triage - User can edit all fields in a case they have access to, regardless of role';
					
				# Allow user to edit all the fields in a case, regardless of user role for this unit
					SET @group_name_can_edit_component_group = (CONCAT(@unit_for_group,'-04-Can-Edit-Components'));
					SET @group_description_can_edit_component_group = 'User can edit components/roles for the unit';
					
				# Allow user to see the unit in the search
					SET @group_name_can_see_unit_in_search_group = (CONCAT(@unit_for_group,'-00-Can-See-Unit-In-Search'));
					SET @group_description_can_see_unit_in_search_group = 'User can see the unit in the search panel';
					
			# The groups related to Flags
				# Allow user to  for this unit
					SET @group_name_all_g_flags_group = (CONCAT(@unit_for_group,'-05-Can-Approve-All-Flags'));
					SET @group_description_all_g_flags_group = 'User can approve all flags';
					
				# Allow user to  for this unit
					SET @group_name_all_r_flags_group = (CONCAT(@unit_for_group,'-05-Can-Request-All-Flags'));
					SET @group_description_all_r_flags_group = 'User can request a Flag to be approved';
					
				
			# The Groups that control user visibility
				# Allow user to  for this unit
					SET @group_name_list_visible_assignees_group = (CONCAT(@unit_for_group,'-06-List-Public-Assignee'));
					SET @group_description_list_visible_assignees_group = 'User are visible assignee(s) for this unit';
					
				# Allow user to  for this unit
					SET @group_name_see_visible_assignees_group = (CONCAT(@unit_for_group,'-06-Can-See-Public-Assignee'));
					SET @group_description_see_visible_assignees_group = 'User can see all visible assignee(s) for this unit';
					
			# Other Misc Groups
				# Allow user to  for this unit
					SET @group_name_active_stakeholder_group = (CONCAT(@unit_for_group,'-07-Active-Stakeholder'));
					SET @group_description_active_stakeholder_group = 'Users who have a role in this unit as of today (WIP)';
					
				# Allow user to  for this unit
					SET @group_name_unit_creator_group = (CONCAT(@unit_for_group,'-07-Unit-Creator'));
					SET @group_description_unit_creator_group = 'User is considered to be the creator of the unit';
					
			# Groups associated to the components/roles
				# For the tenant
					# Visibility group
					SET @group_name_show_to_tenant = (CONCAT(@unit_for_group,'-02-Limit-to-Tenant'));
					SET @group_description_tenant = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 1), @visibility_explanation_2));
				
					# Is in tenant user Group
					SET @group_name_are_users_tenant = (CONCAT(@unit_for_group,'-06-List-Tenant'));
					SET @group_description_are_users_tenant = (CONCAT('list the tenant(s)', @unit));
					
					# Can See tenant user Group
					SET @group_name_see_users_tenant = (CONCAT(@unit_for_group,'-06-Can-see-Tenant'));
					SET @group_description_see_users_tenant = (CONCAT('See the list of tenant(s) for ', @unit));
			
				# For the Landlord
					# Visibility group 
					SET @group_name_show_to_landlord = (CONCAT(@unit_for_group,'-02-Limit-to-Landlord'));
					SET @group_description_show_to_landlord = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 2), @visibility_explanation_2));
					
					# Is in landlord user Group
					SET @group_name_are_users_landlord = (CONCAT(@unit_for_group,'-06-List-landlord'));
					SET @group_description_are_users_landlord = (CONCAT('list the landlord(s)', @unit));
					
					# Can See landlord user Group
					SET @group_name_see_users_landlord = (CONCAT(@unit_for_group,'-06-Can-see-lanldord'));
					SET @group_description_see_users_landlord = (CONCAT('See the list of lanldord(s) for ', @unit));
					
				# For the agent
					# Visibility group 
					SET @group_name_show_to_agent = (CONCAT(@unit_for_group,'-02-Limit-to-Agent'));
					SET @group_description_show_to_agent = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 5), @visibility_explanation_2));
					
					# Is in Agent user Group
					SET @group_name_are_users_agent = (CONCAT(@unit_for_group,'-06-List-agent'));
					SET @group_description_are_users_agent = (CONCAT('list the agent(s)', @unit));
					
					# Can See Agent user Group
					SET @group_name_see_users_agent = (CONCAT(@unit_for_group,'-06-Can-see-agent'));
					SET @group_description_see_users_agent = (CONCAT('See the list of agent(s) for ', @unit));
				
				# For the contractor
					# Visibility group 
					SET @group_name_show_to_contractor = (CONCAT(@unit_for_group,'-02-Limit-to-Contractor-Employee'));
					SET @group_description_show_to_contractor = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 3), @visibility_explanation_2));
					
					# Is in contractor user Group
					SET @group_name_are_users_contractor = (CONCAT(@unit_for_group,'-06-List-contractor-employee'));
					SET @group_description_are_users_contractor = (CONCAT('list the contractor employee(s)', @unit));
					
					# Can See contractor user Group
					SET @group_name_see_users_contractor = (CONCAT(@unit_for_group,'-06-Can-see-contractor-employee'));
					SET @group_description_see_users_contractor = (CONCAT('See the list of contractor employee(s) for ', @unit));
					
				# For the Mgt Cny
					# Visibility group
					SET @group_name_show_to_mgt_cny = (CONCAT(@unit_for_group,'-02-Limit-to-Mgt-Cny-Employee'));
					SET @group_description_show_to_mgt_cny = (CONCAT(@visibility_explanation_1,(SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = 4), @visibility_explanation_2));
					
					# Is in mgt cny user Group
					SET @group_name_are_users_mgt_cny = (CONCAT(@unit_for_group,'-06-List-Mgt-Cny-Employee'));
					SET @group_description_are_users_mgt_cny = (CONCAT('list the Mgt Cny Employee(s)', @unit));
					
					# Can See mgt cny user Group
					SET @group_name_see_users_mgt_cny = (CONCAT(@unit_for_group,'-06-Can-see-Mgt-Cny-Employee'));
					SET @group_description_see_users_mgt_cny = (CONCAT('See the list of Mgt Cny Employee(s) for ', @unit));
				
				# For the occupant
					# Visibility group
					SET @group_name_show_to_occupant = (CONCAT(@unit_for_group,'-02-Limit-to-occupant'));
					SET @group_description_show_to_occupant = (CONCAT(@visibility_explanation_1,'Occupants'));
					
					# Is in occupant user Group
					SET @group_name_are_users_occupant = (CONCAT(@unit_for_group,'-06-List-occupant'));
					SET @group_description_are_users_occupant = (CONCAT('list-the-occupant(s)-', @unit));
					
					# Can See occupant user Group
					SET @group_name_see_users_occupant = (CONCAT(@unit_for_group,'-06-Can-see-occupant'));
					SET @group_description_see_users_occupant = (CONCAT('See the list of occupant(s) for ', @unit));
					
				# For the people invited by this user:
					# Is in invited_by user Group
					SET @group_name_are_users_invited_by = (CONCAT(@unit_for_group,'-06-List-invited-by'));
					SET @group_description_are_users_invited_by = (CONCAT('list the invited_by(s)', @unit));
					
					# Can See users in invited_by user Group
					SET @group_name_see_users_invited_by = (CONCAT(@unit_for_group,'-06-Can-see-invited-by'));
					SET @group_description_see_users_invited_by = (CONCAT('See the list of invited_by(s) for ', @unit));

		# We can populate the 'groups' table now.
        # We insert the groups 1 by 1 so we can get the id for each of these groups.

            # create_case_group_id
            	INSERT INTO `groups`
                    (`name`
                    , `description`
                    , `isbuggroup`
                    , `userregexp`
                    , `isactive`
                    , `icon_url`
                    ) 
                    VALUES 
                    (@group_name_create_case_group
                    , @group_description_create_case_group
                    , 1
                    , ''
                    , 1
                    , NULL
                    )
                    ;

                # Get the actual id that was created for that group
                    SET @create_case_group_id = (SELECT LAST_INSERT_ID());

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('Unit #'
                                            , @product_id
                                            , ' - To grant '
                                            , 'case creation'
                                            , ' privileges. Group_id: '
                                            , (SELECT IFNULL(@create_case_group_id, 'create_case_group_id is NULL'))
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

            # can_edit_case_group_id
            	INSERT INTO `groups`
                    (`name`
                    , `description`
                    , `isbuggroup`
                    , `userregexp`
                    , `isactive`
                    , `icon_url`
                    ) 
                    VALUES 
                    (@group_name_can_edit_case_group
                    , @group_description_can_edit_case_group
                    , 1
                    , ''
                    , 1
                    , NULL
                    )
                    ;            

                # Get the actual id that was created for that group
                    SET @can_edit_case_group_id = (SELECT LAST_INSERT_ID());

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('Unit #'
                                            , @product_id
                                            , ' - To grant '
                                            , 'Edit case'
                                            , ' privileges. Group_id: '
                                            , (SELECT IFNULL(@can_edit_case_group_id, 'can_edit_case_group_id is NULL'))
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

            # can_see_cases_group_id
            	INSERT INTO `groups`
                    (`name`
                    , `description`
                    , `isbuggroup`
                    , `userregexp`
                    , `isactive`
                    , `icon_url`
                    ) 
                    VALUES 
                    (@group_name_can_see_cases_group
                    , @group_description_can_see_cases_group
                    , 1
                    , ''
                    , 1
                    , NULL
                    )
                    ;

                # Get the actual id that was created for that group
                    SET @can_see_cases_group_id = (SELECT LAST_INSERT_ID());

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('Unit #'
                                            , @product_id
                                            , ' - To grant '
                                            , 'See cases'
                                            , ' privileges. Group_id: '
                                            , (SELECT IFNULL(@can_see_cases_group_id, 'can_see_cases_group_id is NULL'))
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

            # can_edit_all_field_case_group_id
                INSERT INTO `groups`
                    (`name`
                    , `description`
                    , `isbuggroup`
                    , `userregexp`
                    , `isactive`
                    , `icon_url`
                    ) 
                    VALUES 
                    (@group_name_can_edit_all_field_case_group
                    , @group_description_can_edit_all_field_case_group
                    , 1
                    , ''
                    , 1
                    , NULL
                    )
                    ;

                # Get the actual id that was created for that group
                    SET @can_edit_all_field_case_group_id = (SELECT LAST_INSERT_ID());

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('Unit #'
                                            , @product_id
                                            , ' - To grant '
                                            , 'Edit all field regardless of role'
                                            , ' privileges. Group_id: '
                                            , (SELECT IFNULL(@can_edit_all_field_case_group_id, 'can_edit_all_field_case_group_id is NULL'))
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

            # can_edit_component_group_id
                INSERT INTO `groups`
                    (`name`
                    , `description`
                    , `isbuggroup`
                    , `userregexp`
                    , `isactive`
                    , `icon_url`
                    ) 
                    VALUES 
                    (@group_name_can_edit_component_group
                    , @group_description_can_edit_component_group
                    , 1
                    , ''
                    , 1
                    , NULL
                    )
                    ;

                # Get the actual id that was created for that group
                    SET @can_edit_component_group_id = (SELECT LAST_INSERT_ID());

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('Unit #'
                                            , @product_id
                                            , ' - To grant '
                                            , 'Edit Component/roles'
                                            , ' privileges. Group_id: '
                                            , (SELECT IFNULL(@can_edit_component_group_id, 'can_edit_component_group_id is NULL'))
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

            # can_see_unit_in_search_group_id
                INSERT INTO `groups`
                    (`name`
                    , `description`
                    , `isbuggroup`
                    , `userregexp`
                    , `isactive`
                    , `icon_url`
                    ) 
                    VALUES 
                    (@group_name_can_see_unit_in_search_group
                    , @group_description_can_see_unit_in_search_group
                    , 1
                    , ''
                    , 1
                    , NULL
                    )
                    ;

                # Get the actual id that was created for that group
                    SET @can_see_unit_in_search_group_id = (SELECT LAST_INSERT_ID());

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('Unit #'
                                            , @product_id
                                            , ' - To grant '
                                            , 'See unit in the Search panel'
                                            , ' privileges. Group_id: '
                                            , (SELECT IFNULL(@can_see_unit_in_search_group_id, 'can_see_unit_in_search_group_id is NULL'))
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

            # all_g_flags_group_id
                INSERT INTO `groups`
                    (`name`
                    , `description`
                    , `isbuggroup`
                    , `userregexp`
                    , `isactive`
                    , `icon_url`
                    ) 
                    VALUES 
                    (@group_name_all_g_flags_group
                    , @group_description_all_g_flags_group
                    , 1
                    , ''
                    , 0
                    , NULL
                    )
                    ;

                # Get the actual id that was created for that group
                    SET @all_g_flags_group_id = (SELECT LAST_INSERT_ID());

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('Unit #'
                                            , @product_id
                                            , ' - To grant '
                                            , 'Approve all flags'
                                            , ' privileges. Group_id: '
                                            , (SELECT IFNULL(@all_g_flags_group_id, 'all_g_flags_group_id is NULL'))
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

            # all_r_flags_group_id
                INSERT INTO `groups`
                    (`name`
                    , `description`
                    , `isbuggroup`
                    , `userregexp`
                    , `isactive`
                    , `icon_url`
                    ) 
                    VALUES 
                    (@group_name_all_r_flags_group
                    , @group_description_all_r_flags_group
                    , 1
                    , ''
                    , 0
                    , NULL
                    )
                    ;

                # Get the actual id that was created for that group
                    SET @all_r_flags_group_id = (SELECT LAST_INSERT_ID());

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('Unit #'
                                            , @product_id
                                            , ' - To grant '
                                            , 'Request all flags'
                                            , ' privileges. Group_id: '
                                            , (SELECT IFNULL(@all_r_flags_group_id, 'all_r_flags_group_id is NULL'))
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

            # list_visible_assignees_group_id
                INSERT INTO `groups`
                    (`name`
                    , `description`
                    , `isbuggroup`
                    , `userregexp`
                    , `isactive`
                    , `icon_url`
                    ) 
                    VALUES 
                    (@group_name_list_visible_assignees_group
                    , @group_description_list_visible_assignees_group
                    , 1
                    , ''
                    , 0
                    , NULL
                    )
                    ;

                # Get the actual id that was created for that group
                    SET @list_visible_assignees_group_id = (SELECT LAST_INSERT_ID());

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('Unit #'
                                            , @product_id
                                            , ' - To grant '
                                            , 'User is publicly visible'
                                            , ' privileges. Group_id: '
                                            , (SELECT IFNULL(@list_visible_assignees_group_id, 'list_visible_assignees_group_id is NULL'))
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

            # see_visible_assignees_group_id
                INSERT INTO `groups`
                    (`name`
                    , `description`
                    , `isbuggroup`
                    , `userregexp`
                    , `isactive`
                    , `icon_url`
                    ) 
                    VALUES 
                    (@group_name_see_visible_assignees_group
                    , @group_description_see_visible_assignees_group
                    , 1
                    , ''
                    , 0
                    , NULL
                    )
                    ;

                # Get the actual id that was created for that group
                    SET @see_visible_assignees_group_id = (SELECT LAST_INSERT_ID());

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('Unit #'
                                            , @product_id
                                            , ' - To grant '
                                            , 'User can see publicly visible'
                                            , ' privileges. Group_id: '
                                            , (SELECT IFNULL(@see_visible_assignees_group_id, 'see_visible_assignees_group_id is NULL'))
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

            # active_stakeholder_group_id
                INSERT INTO `groups`
                    (`name`
                    , `description`
                    , `isbuggroup`
                    , `userregexp`
                    , `isactive`
                    , `icon_url`
                    ) 
                    VALUES 
                    (@group_name_active_stakeholder_group
                    , @group_description_active_stakeholder_group
                    , 1
                    , ''
                    , 1
                    , NULL
                    )
                    ;
                
                # Get the actual id that was created for that group
                    SET @active_stakeholder_group_id = (SELECT LAST_INSERT_ID());

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('Unit #'
                                            , @product_id
                                            , ' - To grant '
                                            , 'User is active Stakeholder'
                                            , ' privileges. Group_id: '
                                            , (SELECT IFNULL(@active_stakeholder_group_id, 'active_stakeholder_group_id is NULL'))
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

            # unit_creator_group_id
                INSERT INTO `groups`
                    (`name`
                    , `description`
                    , `isbuggroup`
                    , `userregexp`
                    , `isactive`
                    , `icon_url`
                    ) 
                    VALUES 
                    (@group_name_unit_creator_group
                    , @group_description_unit_creator_group
                    , 1
                    , ''
                    , 0
                    , NULL
                    )
                    ;

                # Get the actual id that was created for that group
                    SET @unit_creator_group_id = (SELECT LAST_INSERT_ID());

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('Unit #'
                                            , @product_id
                                            , ' - To grant '
                                            , 'User is the unit creator'
                                            , ' privileges. Group_id: '
                                            , (SELECT IFNULL(@unit_creator_group_id, 'unit_creator_group_id is NULL'))
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

            # group_id_show_to_tenant
                INSERT INTO `groups`
                    (`name`
                    , `description`
                    , `isbuggroup`
                    , `userregexp`
                    , `isactive`
                    , `icon_url`
                    ) 
                    VALUES 
                    (@group_name_show_to_tenant
                    , @group_description_tenant
                    , 1
                    , ''
                    , 1
                    , NULL
                    )
                    ;

                # Get the actual id that was created for that group
                    SET @group_id_show_to_tenant = (SELECT LAST_INSERT_ID());

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('Unit #'
                                            , @product_id
                                            , ' - Restrict permission to '
                                            , 'tenant'
                                            , ' only. Group_id: '
                                            , (SELECT IFNULL(@group_id_show_to_tenant, 'group_id_show_to_tenant is NULL'))
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

            # group_id_are_users_tenant
                INSERT INTO `groups`
                    (`name`
                    , `description`
                    , `isbuggroup`
                    , `userregexp`
                    , `isactive`
                    , `icon_url`
                    ) 
                    VALUES 
                    (@group_name_are_users_tenant
                    , @group_description_are_users_tenant
                    , 1
                    , ''
                    , 0
                    , NULL
                    )
                    ;

                # Get the actual id that was created for that group
                    SET @group_id_are_users_tenant = (SELECT LAST_INSERT_ID());

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('Unit #'
                                            , @product_id
                                            , ' - Group for the '
                                            , 'tenant'
                                            , ' only. Group_id: '
                                            , (SELECT IFNULL(@group_id_are_users_tenant, 'group_id_are_users_tenant is NULL'))
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

            # group_id_see_users_tenant
                INSERT INTO `groups`
                    (`name`
                    , `description`
                    , `isbuggroup`
                    , `userregexp`
                    , `isactive`
                    , `icon_url`
                    ) 
                    VALUES 
                    (@group_name_see_users_tenant
                    , @group_description_see_users_tenant
                    , 1
                    , ''
                    , 0
                    , NULL
                    )
                    ;

                # Get the actual id that was created for that group
                    SET @group_id_see_users_tenant = (SELECT LAST_INSERT_ID());

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('Unit #'
                                            , @product_id
                                            , ' - Group to see the users '
                                            , 'tenant'
                                            , '. Group_id: '
                                            , (SELECT IFNULL(@group_id_see_users_tenant, 'group_id_see_users_tenant is NULL'))
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

            # group_id_show_to_landlord
               INSERT INTO `groups`
                    (`name`
                    , `description`
                    , `isbuggroup`
                    , `userregexp`
                    , `isactive`
                    , `icon_url`
                    ) 
                    VALUES 
                    (@group_name_show_to_landlord
                    , @group_description_show_to_landlord
                    , 1
                    , ''
                    , 1
                    , NULL
                    )
                    ;

                # Get the actual id that was created for that group
                    SET @group_id_show_to_landlord = (SELECT LAST_INSERT_ID());

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('Unit #'
                                            , @product_id
                                            , ' - Restrict permission to '
                                            , 'landlord'
                                            , ' only. Group_id: '
                                            , (SELECT IFNULL(@group_id_show_to_landlord, 'group_id_show_to_landlord is NULL'))
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

            # group_id_are_users_landlord
               INSERT INTO `groups`
                    (`name`
                    , `description`
                    , `isbuggroup`
                    , `userregexp`
                    , `isactive`
                    , `icon_url`
                    ) 
                    VALUES 
                    (@group_name_are_users_landlord
                    , @group_description_are_users_landlord
                    , 1
                    , ''
                    , 0
                    , NULL
                    )
                    ;

                # Get the actual id that was created for that group
                    SET @group_id_are_users_landlord = (SELECT LAST_INSERT_ID());

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('Unit #'
                                            , @product_id
                                            , ' - Group for the '
                                            , 'landlord'
                                            , ' only. Group_id: '
                                            , (SELECT IFNULL(@group_id_are_users_landlord, 'group_id_are_users_landlord is NULL'))
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

            # group_id_see_users_landlord
                INSERT INTO `groups`
                    (`name`
                    , `description`
                    , `isbuggroup`
                    , `userregexp`
                    , `isactive`
                    , `icon_url`
                    ) 
                    VALUES 
                    (@group_name_see_users_landlord
                    , @group_description_see_users_landlord
                    , 1
                    , ''
                    , 0
                    , NULL
                    )
                    ;

                # Get the actual id that was created for that group
                    SET @group_id_see_users_landlord = (SELECT LAST_INSERT_ID());

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('Unit #'
                                            , @product_id
                                            , ' - Group to see the users'
                                            , 'landlord'
                                            , '. Group_id: '
                                            , (SELECT IFNULL(@group_id_see_users_landlord, 'group_id_see_users_landlord is NULL'))
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

            # group_id_show_to_agent
               INSERT INTO `groups`
                    (`name`
                    , `description`
                    , `isbuggroup`
                    , `userregexp`
                    , `isactive`
                    , `icon_url`
                    ) 
                    VALUES 
                    (@group_name_show_to_agent
                    , @group_description_show_to_agent
                    , 1
                    , ''
                    , 1
                    , NULL
                    )
                    ;

                # Get the actual id that was created for that group
                    SET @group_id_show_to_agent = (SELECT LAST_INSERT_ID());

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('Unit #'
                                            , @product_id
                                            , ' - Restrict permission to '
                                            , 'agent'
                                            , ' only. Group_id: '
                                            , (SELECT IFNULL(@group_id_show_to_agent, 'group_id_show_to_agent is NULL'))
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

            # group_id_are_users_agent
                INSERT INTO `groups`
                    (`name`
                    , `description`
                    , `isbuggroup`
                    , `userregexp`
                    , `isactive`
                    , `icon_url`
                    ) 
                    VALUES 
                    (@group_name_are_users_agent
                    , @group_description_are_users_agent
                    , 1
                    , ''
                    , 0
                    , NULL
                    )
                    ;

                # Get the actual id that was created for that group
                    SET @group_id_are_users_agent = (SELECT LAST_INSERT_ID());

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('Unit #'
                                            , @product_id
                                            , ' - Group for the '
                                            , 'agent'
                                            , ' only. Group_id: '
                                            , (SELECT IFNULL(@group_id_are_users_agent, 'group_id_are_users_agent is NULL'))
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

            # group_id_see_users_agent
                INSERT INTO `groups`
                    (`name`
                    , `description`
                    , `isbuggroup`
                    , `userregexp`
                    , `isactive`
                    , `icon_url`
                    ) 
                    VALUES 
                    (@group_name_see_users_agent
                    , @group_description_see_users_agent
                    , 1
                    , ''
                    , 0
                    , NULL
                    )
                    ;

                # Get the actual id that was created for that group
                    SET @group_id_see_users_agent = (SELECT LAST_INSERT_ID());

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('Unit #'
                                            , @product_id
                                            , ' - Group to see the users'
                                            , 'agent'
                                            , '. Group_id: '
                                            , (SELECT IFNULL(@group_id_see_users_agent, 'group_id_see_users_agent is NULL'))
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

            # group_id_show_to_contractor
                INSERT INTO `groups`
                    (`name`
                    , `description`
                    , `isbuggroup`
                    , `userregexp`
                    , `isactive`
                    , `icon_url`
                    ) 
                    VALUES 
                    (@group_name_show_to_contractor
                    , @group_description_show_to_contractor
                    , 1
                    , ''
                    , 1
                    , NULL
                    )
                    ;

                # Get the actual id that was created for that group
                    SET @group_id_show_to_contractor = (SELECT LAST_INSERT_ID());

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('Unit #'
                                            , @product_id
                                            , ' - Restrict permission to '
                                            , 'Contractor'
                                            , ' only. Group_id: '
                                            , (SELECT IFNULL(@group_id_show_to_contractor, 'group_id_show_to_contractor is NULL'))
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

            # group_id_are_users_contractor
                INSERT INTO `groups`
                    (`name`
                    , `description`
                    , `isbuggroup`
                    , `userregexp`
                    , `isactive`
                    , `icon_url`
                    ) 
                    VALUES 
                    (@group_name_are_users_contractor
                    , @group_description_are_users_contractor
                    , 1
                    , ''
                    , 0
                    , NULL
                    )
                    ;

                # Get the actual id that was created for that group
                    SET @group_id_are_users_contractor = (SELECT LAST_INSERT_ID());

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('Unit #'
                                            , @product_id
                                            , ' - Group for the '
                                            , 'Contractor'
                                            , ' only. Group_id: '
                                            , (SELECT IFNULL(@group_id_are_users_contractor, 'group_id_are_users_contractor is NULL'))
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

            # group_id_see_users_contractor
                INSERT INTO `groups`
                    (`name`
                    , `description`
                    , `isbuggroup`
                    , `userregexp`
                    , `isactive`
                    , `icon_url`
                    ) 
                    VALUES 
                    (@group_name_see_users_contractor
                    , @group_description_see_users_contractor
                    , 1
                    , ''
                    , 0
                    , NULL
                    )
                    ;

                # Get the actual id that was created for that group
                    SET @group_id_see_users_contractor = (SELECT LAST_INSERT_ID());

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('Unit #'
                                            , @product_id
                                            , ' - Group to see the users'
                                            , 'Contractor'
                                            , '. Group_id: '
                                            , (SELECT IFNULL(@group_id_see_users_contractor, 'group_id_see_users_contractor is NULL'))
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

            # group_id_show_to_mgt_cny
                INSERT INTO `groups`
                    (`name`
                    , `description`
                    , `isbuggroup`
                    , `userregexp`
                    , `isactive`
                    , `icon_url`
                    ) 
                    VALUES 
                    (@group_name_show_to_mgt_cny
                    , @group_description_show_to_mgt_cny
                    , 1
                    , ''
                    , 1
                    , NULL
                    )
                    ;

                # Get the actual id that was created for that group
                    SET @group_id_show_to_mgt_cny = (SELECT LAST_INSERT_ID());

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('Unit #'
                                            , @product_id
                                            , ' - Restrict permission to '
                                            , 'Management Company'
                                            , ' only. Group_id: '
                                            , (SELECT IFNULL(@group_id_show_to_mgt_cny, 'group_id_show_to_mgt_cny is NULL'))
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

            # group_id_are_users_mgt_cny
                INSERT INTO `groups`
                    (`name`
                    , `description`
                    , `isbuggroup`
                    , `userregexp`
                    , `isactive`
                    , `icon_url`
                    ) 
                    VALUES 
                    (@group_name_are_users_mgt_cny
                    , @group_description_are_users_mgt_cny
                    , 1
                    , ''
                    , 0
                    , NULL
                    )
                    ;

                # Get the actual id that was created for that group
                    SET @group_id_are_users_mgt_cny = (SELECT LAST_INSERT_ID());

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('Unit #'
                                            , @product_id
                                            , ' - Group for the users in the '
                                            , 'Management Company'
                                            , ' only. Group_id: '
                                            , (SELECT IFNULL(@group_id_are_users_mgt_cny, 'group_id_are_users_mgt_cny is NULL'))
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

            # group_id_see_users_mgt_cny
                INSERT INTO `groups`
                    (`name`
                    , `description`
                    , `isbuggroup`
                    , `userregexp`
                    , `isactive`
                    , `icon_url`
                    ) 
                    VALUES 
                    (@group_name_see_users_mgt_cny
                    , @group_description_see_users_mgt_cny
                    , 1
                    , ''
                    , 0
                    , NULL
                    )
                    ;         

                # Get the actual id that was created for that group
                    SET @group_id_see_users_mgt_cny = (SELECT LAST_INSERT_ID());   

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('Unit #'
                                            , @product_id
                                            , ' - Group to see the users in the '
                                            , 'Management Company'
                                            , '. Group_id: '
                                            , (SELECT IFNULL(@group_id_see_users_mgt_cny, 'group_id_see_users_mgt_cny is NULL'))
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

            # group_id_show_to_occupant
                INSERT INTO `groups`
                    (`name`
                    , `description`
                    , `isbuggroup`
                    , `userregexp`
                    , `isactive`
                    , `icon_url`
                    ) 
                    VALUES 
                    (@group_name_show_to_occupant
                    , @group_description_show_to_occupant
                    , 1
                    , ''
                    , 1
                    , NULL
                    )
                    ;

                # Get the actual id that was created for that group
                    SET @group_id_show_to_occupant = (SELECT LAST_INSERT_ID());   

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('Unit #'
                                            , @product_id
                                            , ' - Restrict permission to '
                                            , 'occupant'
                                            , ' only. Group_id: '
                                            , (SELECT IFNULL(@group_id_show_to_occupant, 'group_id_show_to_occupant is NULL'))
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

            # group_id_are_users_occupant
                INSERT INTO `groups`
                    (`name`
                    , `description`
                    , `isbuggroup`
                    , `userregexp`
                    , `isactive`
                    , `icon_url`
                    ) 
                    VALUES 
                    (@group_name_are_users_occupant
                    , @group_description_are_users_occupant
                    , 1
                    , ''
                    , 0
                    , NULL
                    )
                    ;

                # Get the actual id that was created for that group
                    SET @group_id_are_users_occupant = (SELECT LAST_INSERT_ID());  

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('Unit #'
                                            , @product_id
                                            , ' - Group for the '
                                            , 'occupant'
                                            , ' only. Group_id: '
                                            , (SELECT IFNULL(@group_id_are_users_occupant, 'group_id_are_users_occupant is NULL'))
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

            # group_id_see_users_occupant
                INSERT INTO `groups`
                    (`name`
                    , `description`
                    , `isbuggroup`
                    , `userregexp`
                    , `isactive`
                    , `icon_url`
                    ) 
                    VALUES 
                    (@group_name_see_users_occupant
                    , @group_description_see_users_occupant
                    , 1
                    , ''
                    , 0
                    , NULL
                    )
                    ;
                    
                # Get the actual id that was created for that group
                    SET @group_id_see_users_occupant = (SELECT LAST_INSERT_ID());

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('Unit #'
                                            , @product_id
                                            , ' - Group to see the users '
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
                        (NOW(), @script, @script_log_message)
                        ;
                    
                    SET @script_log_message = NULL;		

            # group_id_are_users_invited_by
                INSERT INTO `groups`
                    (`name`
                    , `description`
                    , `isbuggroup`
                    , `userregexp`
                    , `isactive`
                    , `icon_url`
                    ) 
                    VALUES 
                    (@group_name_are_users_invited_by
                    , @group_description_are_users_invited_by
                    , 1
                    , ''
                    , 0
                    , NULL
                    )
                    ;

                # Get the actual id that was created for that group
                    SET @group_id_are_users_invited_by = (SELECT LAST_INSERT_ID());

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('Unit #'
                                            , @product_id
                                            , ' - group of users invited by the same user'
                                            , ' . Group_id: '
                                            , (SELECT IFNULL(@group_id_are_users_invited_by, 'group_id_are_users_invited_by is NULL'))
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

            # group_id_see_users_invited_by
                INSERT INTO `groups`
                    (`name`
                    , `description`
                    , `isbuggroup`
                    , `userregexp`
                    , `isactive`
                    , `icon_url`
                    ) 
                    VALUES 
                    (@group_name_see_users_invited_by
                    , @group_description_see_users_invited_by
                    , 1
                    , ''
                    , 0
                    , NULL
                    )
                    ;

                # Get the actual id that was created for that group
                    SET @group_id_see_users_invited_by = (SELECT LAST_INSERT_ID());

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('Unit #'
                                            , @product_id
                                            , ' - Group to see the users '
                                            , 'invited by the same user'
                                            , '. Group_id: '
                                            , (SELECT IFNULL(@group_id_see_users_invited_by, 'group_id_see_users_invited_by is NULL'))
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

		# We record the groups we have just created:
		#	We NEED the component_id for that
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
				(@product_id, NULL, @create_case_group_id, 20, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @can_edit_case_group_id, 25, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @can_edit_all_field_case_group_id, 26, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @can_edit_component_group_id, 27, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @can_see_cases_group_id, 28, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @can_see_unit_in_search_group_id, 38, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @all_r_flags_group_id, 18, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @all_g_flags_group_id, 19, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @list_visible_assignees_group_id, 4, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @see_visible_assignees_group_id,5, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @active_stakeholder_group_id, 29, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @unit_creator_group_id, 1, NULL, @creator_bz_id, @timestamp)
				# Tenant (1)
				, (@product_id, @component_id_tenant, @group_id_show_to_tenant, 2, 1, @creator_bz_id, @timestamp)
				, (@product_id, @component_id_tenant, @group_id_are_users_tenant, 22, 1, @creator_bz_id, @timestamp)
				, (@product_id, @component_id_tenant, @group_id_see_users_tenant, 37, 1, @creator_bz_id, @timestamp)
				# Landlord (2)
				, (@product_id, @component_id_landlord, @group_id_show_to_landlord, 2, 2, @creator_bz_id, @timestamp)
				, (@product_id, @component_id_landlord, @group_id_are_users_landlord, 22, 2, @creator_bz_id, @timestamp)
				, (@product_id, @component_id_landlord, @group_id_see_users_landlord, 37, 2, @creator_bz_id, @timestamp)
				# Agent (5)
				, (@product_id, @component_id_agent, @group_id_show_to_agent, 2,5, @creator_bz_id, @timestamp)
				, (@product_id, @component_id_agent, @group_id_are_users_agent, 22,5, @creator_bz_id, @timestamp)
				, (@product_id, @component_id_agent, @group_id_see_users_agent, 37,5, @creator_bz_id, @timestamp)
				# contractor (3)
				, (@product_id, @component_id_contractor, @group_id_show_to_contractor, 2, 3, @creator_bz_id, @timestamp)
				, (@product_id, @component_id_contractor, @group_id_are_users_contractor, 22, 3, @creator_bz_id, @timestamp)
				, (@product_id, @component_id_contractor, @group_id_see_users_contractor, 37, 3, @creator_bz_id, @timestamp)
				# mgt_cny (4)
				, (@product_id, @component_id_mgt_cny, @group_id_show_to_mgt_cny, 2, 4, @creator_bz_id, @timestamp)
				, (@product_id, @component_id_mgt_cny, @group_id_are_users_mgt_cny, 22, 4, @creator_bz_id, @timestamp)
				, (@product_id, @component_id_mgt_cny, @group_id_see_users_mgt_cny, 37, 4, @creator_bz_id, @timestamp)
				# occupant (#)
				, (@product_id, NULL, @group_id_show_to_occupant, 24, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @group_id_are_users_occupant, 3, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @group_id_see_users_occupant, 36, NULL, @creator_bz_id, @timestamp)
				# invited_by
				, (@product_id, NULL, @group_id_are_users_invited_by, 31, NULL, @creator_bz_id, @timestamp)
				, (@product_id, NULL, @group_id_see_users_invited_by, 32, NULL, @creator_bz_id, @timestamp)
				;
				
		# We update the BZ logs
			INSERT INTO `audit_log`
				(`user_id`
				, `class`
				, `object_id`
				, `field`
				, `removed`
				, `added`
				, `at_time`
				) 
				VALUES 
				(@creator_bz_id, 'Bugzilla::Group', @create_case_group_id, '__create__', NULL, @group_name_create_case_group, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @can_edit_case_group_id, '__create__', NULL, @group_name_can_edit_case_group, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @can_edit_all_field_case_group_id, '__create__', NULL, @group_name_can_edit_all_field_case_group, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @can_edit_component_group_id, '__create__', NULL, @group_name_can_edit_component_group, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @can_see_cases_group_id, '__create__', NULL, @group_name_can_see_cases_group, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @can_see_unit_in_search_group_id, '__create__', NULL, @group_name_can_see_unit_in_search_group, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @all_g_flags_group_id, '__create__', NULL, @group_name_all_g_flags_group, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @all_r_flags_group_id, '__create__', NULL, @group_name_all_r_flags_group, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @list_visible_assignees_group_id, '__create__', NULL, @group_name_list_visible_assignees_group, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @see_visible_assignees_group_id, '__create__', NULL, @group_name_see_visible_assignees_group, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @active_stakeholder_group_id, '__create__', NULL, @group_name_active_stakeholder_group, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @unit_creator_group_id, '__create__', NULL, @group_name_unit_creator_group, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_tenant, '__create__', NULL, @group_name_show_to_tenant, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_tenant, '__create__', NULL, @group_name_are_users_tenant, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_tenant, '__create__', NULL, @group_name_see_users_tenant, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_landlord, '__create__', NULL, @group_name_show_to_landlord, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_landlord, '__create__', NULL, @group_name_are_users_landlord, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_landlord, '__create__', NULL, @group_name_see_users_landlord, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_agent, '__create__', NULL, @group_name_show_to_agent, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_agent, '__create__', NULL, @group_name_are_users_agent, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_agent, '__create__', NULL, @group_name_see_users_agent, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_contractor, '__create__', NULL, @group_name_show_to_contractor, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_contractor, '__create__', NULL, @group_name_are_users_contractor, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_contractor, '__create__', NULL, @group_name_see_users_contractor, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_mgt_cny, '__create__', NULL, @group_name_show_to_mgt_cny, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_mgt_cny, '__create__', NULL, @group_name_are_users_mgt_cny, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_mgt_cny, '__create__', NULL, @group_name_see_users_mgt_cny, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_show_to_occupant, '__create__', NULL, @group_name_show_to_occupant, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_occupant, '__create__', NULL, @group_name_are_users_occupant, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_occupant, '__create__', NULL, @group_name_see_users_occupant, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_are_users_invited_by, '__create__', NULL, @group_name_are_users_invited_by, @timestamp)
				, (@creator_bz_id, 'Bugzilla::Group', @group_id_see_users_invited_by, '__create__', NULL, @group_name_see_users_invited_by, @timestamp)
				;
			
	# We now Create the flagtypes and flags for this new unit (we NEEDED the group ids for that!):
		
		# We need to define the data we need for each flag
			SET @flag_next_step_name = CONCAT('Next_Step_', @unit_for_flag);
			SET @flag_solution_name = CONCAT('Solution_', @unit_for_flag);
			SET @flag_budget_name = CONCAT('Budget_', @unit_for_flag);
			SET @flag_attachment_name = CONCAT('Attachment_', @unit_for_flag);
			SET @flag_ok_to_pay_name = CONCAT('OK_to_pay_', @unit_for_flag);
			SET @flag_is_paid_name = CONCAT('is_paid_', @unit_for_flag);
	
        # We insert the flagtypes 1 by 1 to get the id for each component easily

		# Flagtype for next_step
			INSERT INTO `flagtypes`
				(`name`
				, `description`
				, `cc_list`
				, `target_type`
				, `is_active`
				, `is_requestable`
				, `is_requesteeble`
				, `is_multiplicable`
				, `sortkey`
				, `grant_group_id`
				, `request_group_id`
				) 
				VALUES 
				(@flag_next_step_name 
                , 'Approval for the Next Step of the case.'
                , ''
                , 'b'
                , 1
                , 1
                , 1
                , 1
                , 10
                , @all_g_flags_group_id
                , @all_r_flags_group_id
                )
                ;

                # We get the id for that flag
                    SET @flag_next_step_id = (SELECT LAST_INSERT_ID());

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('The following flag Next Step (#'
                                        , (SELECT IFNULL(@flag_next_step_id, 'flag_next_step is NULL'))
                                        , ').'
                                        , ' was created for the unit #'
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
                    
                    SET @script_log_message = NULL;	

		# We can now create the flagtypes for solution
			INSERT INTO `flagtypes`
				(`name`
				, `description`
				, `cc_list`
				, `target_type`
				, `is_active`
				, `is_requestable`
				, `is_requesteeble`
				, `is_multiplicable`
				, `sortkey`
				, `grant_group_id`
				, `request_group_id`
				) 
				VALUES 
				(@flag_solution_name 
                , 'Approval for the Solution of this case.'
                , ''
                , 'b'
                , 1
                , 1
                , 1
                , 1
                , 20
                , @all_g_flags_group_id
                , @all_r_flags_group_id
                )
                ;

                # We get the id for that flag
                    SET @flag_solution_id = (SELECT LAST_INSERT_ID());

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('The following flag Solution (#'
                                        , (SELECT IFNULL(@flag_solution_id, 'flag_solution is NULL'))
                                        , ').'
                                        , ' was created for the unit #'
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
                    
                    SET @script_log_message = NULL;	

		# We can now create the flagtypes for budget
			INSERT INTO `flagtypes`
				(`name`
				, `description`
				, `cc_list`
				, `target_type`
				, `is_active`
				, `is_requestable`
				, `is_requesteeble`
				, `is_multiplicable`
				, `sortkey`
				, `grant_group_id`
				, `request_group_id`
				) 
				VALUES 
				(@flag_budget_name 
                , 'Approval for the Budget for this case.'
                , ''
                , 'b'
                , 1
                , 1
                , 1
                , 1
                , 30
                , @all_g_flags_group_id
                , @all_r_flags_group_id
                )
                ;

                # We get the id for that flag
                    SET @flag_budget_id = (SELECT LAST_INSERT_ID());

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('The following flag Budget (#'
                                        , (SELECT IFNULL(@flag_budget_id, 'flag_budget is NULL'))
                                        , ').'
                                        , ' was created for the unit #'
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
                    
                    SET @script_log_message = NULL;	

		# We can now create the flagtypes for attachment
			INSERT INTO `flagtypes`
				(`name`
				, `description`
				, `cc_list`
				, `target_type`
				, `is_active`
				, `is_requestable`
				, `is_requesteeble`
				, `is_multiplicable`
				, `sortkey`
				, `grant_group_id`
				, `request_group_id`
				) 
				VALUES                 
                (@flag_attachment_name 
                , 'Approval for this Attachment.'
                , ''
                , 'a'
                , 1
                , 1
                , 1
                , 1
                , 10
                , @all_g_flags_group_id
                , @all_r_flags_group_id
                )
                ;

                # We get the id for that flag
                    SET @flag_attachment_id = (SELECT LAST_INSERT_ID());

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('The following flag Attachment (#'
                                        , (SELECT IFNULL(@flag_attachment_id, 'flag_attachment is NULL'))
                                        , ').'
                                        , ' was created for the unit #'
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
                    
                    SET @script_log_message = NULL;	

		# We can now create the flagtypes for ok_to_pay
			INSERT INTO `flagtypes`
				(`name`
				, `description`
				, `cc_list`
				, `target_type`
				, `is_active`
				, `is_requestable`
				, `is_requesteeble`
				, `is_multiplicable`
				, `sortkey`
				, `grant_group_id`
				, `request_group_id`
				) 
				VALUES 
                (@flag_ok_to_pay_name 
                , 'Approval to pay this bill.'
                , ''
                , 'a'
                , 1
                , 1
                , 1
                , 1
                , 20
                , @all_g_flags_group_id
                , @all_r_flags_group_id
                )
                ;

                # We get the id for that flag
                    SET @flag_ok_to_pay_id = (SELECT LAST_INSERT_ID());

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('The following flag OK to pay (#'
                                        , (SELECT IFNULL(@flag_ok_to_pay_id, 'flag_ok_to_pay is NULL'))
                                        , ').'
                                        , ' was created for the unit #'
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
                    
                    SET @script_log_message = NULL;	

		# We can now create the flagtypes for is_paid
			INSERT INTO `flagtypes`
				(`name`
				, `description`
				, `cc_list`
				, `target_type`
				, `is_active`
				, `is_requestable`
				, `is_requesteeble`
				, `is_multiplicable`
				, `sortkey`
				, `grant_group_id`
				, `request_group_id`
				) 
				VALUES 
                (@flag_is_paid_name
                , 'Confirm if this bill has been paid.'
                , ''
                , 'a'
                , 1
                , 1
                , 1
                , 1
                , 30
                , @all_g_flags_group_id
                , @all_r_flags_group_id
                )
                ;

                # We get the id for that flag
                    SET @flag_is_paid_id = (SELECT LAST_INSERT_ID());

                # Log the actions of the script.
                    SET @script_log_message = CONCAT('The following flag Is paid (#'
                                        , (SELECT IFNULL(@flag_is_paid_id, 'flag_is_paid is NULL'))
                                        , ').'
                                        , ' was created for the unit #'
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
                    
                    SET @script_log_message = NULL;	

		# We also define the flag inclusion
			INSERT INTO `flaginclusions`
				(`type_id`
				, `product_id`
				, `component_id`
				) 
				VALUES
				(@flag_next_step_id, @product_id, NULL)
				, (@flag_solution_id, @product_id, NULL)
				, (@flag_budget_id, @product_id, NULL)
				, (@flag_attachment_id, @product_id, NULL)
				, (@flag_ok_to_pay_id, @product_id, NULL)
				, (@flag_is_paid_id, @product_id, NULL)
				;

		# We update the BZ logs
			INSERT INTO `audit_log`
				(`user_id`
				, `class`
				, `object_id`
				, `field`
				, `removed`
				, `added`
				, `at_time`
				) 
				VALUES 
				(@creator_bz_id, 'Bugzilla::FlagType', @flag_next_step_id, '__create__', NULL, @flag_next_step_name, @timestamp)
				, (@creator_bz_id, 'Bugzilla::FlagType', @flag_solution_id, '__create__', NULL, @flag_solution_name, @timestamp)
				, (@creator_bz_id, 'Bugzilla::FlagType', @flag_budget_id, '__create__', NULL, @flag_budget_name, @timestamp)
				, (@creator_bz_id, 'Bugzilla::FlagType', @flag_attachment_id, '__create__', NULL, @flag_attachment_name, @timestamp)
				, (@creator_bz_id, 'Bugzilla::FlagType', @flag_ok_to_pay_id, '__create__', NULL, @flag_ok_to_pay_name, @timestamp)
				, (@creator_bz_id, 'Bugzilla::FlagType', @flag_is_paid_id, '__create__', NULL, @flag_is_paid_name, @timestamp)
				;
			
	# We configure the group permissions:
		# Data for the table `group_group_map`
        # We first insert these in the table `ut_group_group_map_temp`
        # If you need to re-create the table `ut_group_group_map_temp`, use the procedure `create_temp_table_to_update_group_permissions`

            INSERT INTO `ut_group_group_map_temp`
                (`member_id`
                , `grantor_id`
                , `grant_type`
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
                (1, @create_case_group_id, 1)
                ,(1, @can_edit_case_group_id, 1)
                ,(1, @can_see_cases_group_id, 1)
                ,(1, @can_edit_all_field_case_group_id, 1)
                ,(1, @can_edit_component_group_id, 1)
                ,(1, @can_see_unit_in_search_group_id, 1)
                ,(1, @all_g_flags_group_id, 1)
                ,(1, @all_r_flags_group_id, 1)
                ,(1, @list_visible_assignees_group_id, 1)
                ,(1, @see_visible_assignees_group_id, 1)
                ,(1, @active_stakeholder_group_id, 1)
                ,(1, @unit_creator_group_id, 1)
                ,(1, @group_id_show_to_tenant, 1)
                ,(1, @group_id_are_users_tenant, 1)
                ,(1, @group_id_see_users_tenant, 1)
                ,(1, @group_id_show_to_landlord, 1)
                ,(1, @group_id_are_users_landlord, 1)
                ,(1, @group_id_see_users_landlord, 1)
                ,(1, @group_id_show_to_agent, 1)
                ,(1, @group_id_are_users_agent, 1)
                ,(1, @group_id_see_users_agent, 1)
                ,(1, @group_id_show_to_contractor, 1)
                ,(1, @group_id_are_users_contractor, 1)
                ,(1, @group_id_see_users_contractor, 1)
                ,(1, @group_id_show_to_mgt_cny, 1)
                ,(1, @group_id_are_users_mgt_cny, 1)
                ,(1, @group_id_see_users_mgt_cny, 1)
                ,(1, @group_id_show_to_occupant, 1)
                ,(1, @group_id_are_users_occupant, 1)
                ,(1, @group_id_see_users_occupant, 1)
                ,(1, @group_id_are_users_invited_by, 1)
                ,(1, @group_id_see_users_invited_by, 1)
                
                # Admin MUST be a member of the mandatory group for this unit
                # If not it is impossible to see this product in the BZFE backend.
                ,(1, @can_see_unit_in_search_group_id,0)
                # Visibility groups:
                , (@all_r_flags_group_id, @all_g_flags_group_id, 2)
                , (@see_visible_assignees_group_id, @list_visible_assignees_group_id, 2)
                , (@unit_creator_group_id, @unit_creator_group_id, 2)
                , (@group_id_see_users_tenant, @group_id_are_users_tenant, 2)
                , (@group_id_see_users_landlord, @group_id_are_users_landlord, 2)
                , (@group_id_see_users_agent, @group_id_are_users_contractor, 2)
                , (@group_id_see_users_mgt_cny, @group_id_are_users_mgt_cny, 2)
                , (@group_id_see_users_occupant, @group_id_are_users_occupant, 2)
                , (@group_id_see_users_invited_by, @group_id_are_users_invited_by, 2)
                ;

	# We make sure that only user in certain groups can create, edit or see cases.
		INSERT INTO `group_control_map`
			(`group_id`
			, `product_id`
			, `entry`
			, `membercontrol`
			, `othercontrol`
			, `canedit`
			, `editcomponents`
			, `editbugs`
			, `canconfirm`
			) 
			VALUES 
			(@create_case_group_id, @product_id, 1, 0, 0, 0, 0, 0, 0)
			, (@can_edit_case_group_id, @product_id, 1, 0, 0, 1, 0, 0, 1)
			, (@can_edit_all_field_case_group_id, @product_id, 1, 0, 0, 1, 0, 1, 1)
			, (@can_edit_component_group_id, @product_id, 0, 0, 0, 0, 1, 0, 0)
			, (@can_see_cases_group_id, @product_id, 0, 2, 0, 0, 0, 0, 0)
			, (@can_see_unit_in_search_group_id, @product_id, 0, 3, 3, 0, 0, 0, 0)
			, (@group_id_show_to_tenant, @product_id, 0, 2, 0, 0, 0, 0, 0)
			, (@group_id_show_to_landlord, @product_id, 0, 2, 0, 0, 0, 0, 0)
			, (@group_id_show_to_agent, @product_id, 0, 2, 0, 0, 0, 0, 0)
			, (@group_id_show_to_contractor, @product_id, 0, 2, 0, 0, 0, 0, 0)
			, (@group_id_show_to_mgt_cny, @product_id, 0, 2, 0, 0, 0, 0, 0)
			, (@group_id_show_to_occupant, @product_id, 0, 2, 0, 0, 0, 0, 0)
			;

		# Log the actions of the script.
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

		# We insert the series categories that BZ needs...
				
			# What are the name for the categories
				SET @series_category_product_name = @unit_for_group;
				SET @series_category_component_tenant_name = CONCAT('Tenant - ', @product_id,'_#', @component_id_tenant);
				SET @series_category_component_landlord_name = CONCAT('Landlord - ', @product_id,'_#', @component_id_landlord);
				SET @series_category_component_contractor_name = CONCAT('Contractor - ', @product_id,'_#', @component_id_contractor);
				SET @series_category_component_mgtcny_name = CONCAT('Mgt Cny - ', @product_id,'_#', @component_id_mgt_cny);
				SET @series_category_component_agent_name = CONCAT('Agent - ', @product_id,'_#', @component_id_agent);
				
			# What are the SQL queries for these series:
				
				# We need a sanitized unit name:
					SET @unit_name_for_serie_query = REPLACE(@unit, ' ', '%20');
				
				# Product
					SET @serie_search_unconfirmed = CONCAT('bug_status=UNCONFIRMED&product=', @unit_name_for_serie_query);
					SET @serie_search_confirmed = CONCAT('bug_status=CONFIRMED&product=', @unit_name_for_serie_query);
					SET @serie_search_in_progress = CONCAT('bug_status=IN_PROGRESS&product=', @unit_name_for_serie_query);
					SET @serie_search_reopened = CONCAT('bug_status=REOPENED&product=', @unit_name_for_serie_query);
					SET @serie_search_standby = CONCAT('bug_status=STAND%20BY&product=', @unit_name_for_serie_query);
					SET @serie_search_resolved = CONCAT('bug_status=RESOLVED&product=', @unit_name_for_serie_query);
					SET @serie_search_verified = CONCAT('bug_status=VERIFIED&product=', @unit_name_for_serie_query);
					SET @serie_search_closed = CONCAT('bug_status=CLOSED&product=', @unit_name_for_serie_query);
					SET @serie_search_fixed = CONCAT('resolution=FIXED&product=', @unit_name_for_serie_query);
					SET @serie_search_invalid = CONCAT('resolution=INVALID&product=', @unit_name_for_serie_query);
					SET @serie_search_wontfix = CONCAT('resolution=WONTFIX&product=', @unit_name_for_serie_query);
					SET @serie_search_duplicate = CONCAT('resolution=DUPLICATE&product=', @unit_name_for_serie_query);
					SET @serie_search_worksforme = CONCAT('resolution=WORKSFORME&product=', @unit_name_for_serie_query);
					SET @serie_search_all_open = CONCAT('bug_status=UNCONFIRMED&bug_status=CONFIRMED&bug_status=IN_PROGRESS&bug_status=REOPENED&bug_status=STAND%20BY&product=', @unit_name_for_serie_query);
					
				# Component
				
					# We need several variables to build this
						SET @serie_search_prefix_component_open = 'field0-0-0=resolution&type0-0-0=notregexp&value0-0-0=.&product='; 
						SET @serie_search_prefix_component_closed = 'field0-0-0=resolution&type0-0-0=regexp&value0-0-0=.&product=';
				    	SET @component_name_for_serie_tenant = REPLACE(@role_user_g_description_tenant, ' ', '%20');
						SET @component_name_for_serie_landlord = REPLACE(@role_user_g_description_landlord, ' ', '%20');
						SET @component_name_for_serie_contractor = REPLACE(@role_user_g_description_contractor, ' ', '%20');
						SET @component_name_for_serie_mgtcny = REPLACE(@role_user_g_description_mgt_cny, ' ', '%20');
						SET @component_name_for_serie_agent = REPLACE(@role_user_g_description_agent, ' ', '%20');
						
					# We can now derive the query needed to build these series
					
						SET @serie_search_all_open_tenant = (CONCAT (@serie_search_prefix_component_open
							, @unit_name_for_serie_query
							, '&component='
							, @component_name_for_serie_tenant)
							);
						SET @serie_search_all_closed_tenant = (CONCAT (@serie_search_prefix_component_closed
							, @unit_name_for_serie_query
							, '&component='
							, @component_name_for_serie_tenant)
							);
						SET @serie_search_all_open_landlord = (CONCAT (@serie_search_prefix_component_open
							, @unit_name_for_serie_query
							, '&component='
							, @component_name_for_serie_landlord)
							);
						SET @serie_search_all_closed_landlord = (CONCAT (@serie_search_prefix_component_closed
							, @unit_name_for_serie_query
							, '&component='
							, @component_name_for_serie_landlord)
							);
						SET @serie_search_all_open_contractor = (CONCAT (@serie_search_prefix_component_open
							, @unit_name_for_serie_query
							, '&component='
							, @component_name_for_serie_contractor)
							);
						SET @serie_search_all_closed_contractor = (CONCAT (@serie_search_prefix_component_closed
							, @unit_name_for_serie_query
							, '&component='
							, @component_name_for_serie_contractor)
							);
						SET @serie_search_all_open_mgtcny = (CONCAT (@serie_search_prefix_component_open
							, @unit_name_for_serie_query
							, '&component='
							, @component_name_for_serie_mgtcny)
							);
						SET @serie_search_all_closed_mgtcny = (CONCAT (@serie_search_prefix_component_closed
							, @unit_name_for_serie_query
							, '&component='
							, @component_name_for_serie_mgtcny)
							);
						SET @serie_search_all_open_agent = (CONCAT (@serie_search_prefix_component_open
							, @unit_name_for_serie_query
							, '&component='
							, @component_name_for_serie_agent)
							);
						SET @serie_search_all_closed_agent = (CONCAT (@serie_search_prefix_component_closed
							, @unit_name_for_serie_query
							, '&component='
							, @component_name_for_serie_agent)
							);

		# We have eveything, we can create the series_categories we need:
        # We insert the series_categories 1 by 1 to get the id for each series_categories easily

		# We can now insert the series category product
			INSERT INTO `series_categories`
				(`name`
				) 
				VALUES 
				(@series_category_product_name)
				;

            # We get the id for the series_category 
                SET @series_category_product = (SELECT LAST_INSERT_ID());

		# We can now insert the series category component_tenant
			INSERT INTO `series_categories`
				(`name`
				) 
				VALUES 
				(@series_category_component_tenant_name)
				;

            # We get the id for the series_category 
                SET @series_category_component_tenant = (SELECT LAST_INSERT_ID());

		# We can now insert the series category component_landlord
			INSERT INTO `series_categories`
				(`name`
				) 
				VALUES 
				(@series_category_component_landlord_name)
				;

            # We get the id for the series_category 
                SET @series_category_component_landlord = (SELECT LAST_INSERT_ID());

		# We can now insert the series category component_contractor
			INSERT INTO `series_categories`
				(`name`
				) 
				VALUES 
				(@series_category_component_contractor_name)
				;

            # We get the id for the series_category 
                SET @series_category_component_contractor = (SELECT LAST_INSERT_ID());

		# We can now insert the series category component_mgtcny
			INSERT INTO `series_categories`
				(`name`
				) 
				VALUES 
				(@series_category_component_mgtcny_name)
				;

            # We get the id for the series_category 
                SET @series_category_component_mgtcny = (SELECT LAST_INSERT_ID());

		# We can now insert the series category component_agent
			INSERT INTO `series_categories`
				(`name`
				) 
				VALUES 
				(@series_category_component_agent_name)
				;

            # We get the id for the series_category 
                SET @series_category_component_agent = (SELECT LAST_INSERT_ID());

        # We do not need the series_id - we can insert in bulk here
            # Insert the series related to the product/unit
                INSERT INTO `series`
                    (`series_id`
                    , `creator`
                    , `category`
                    , `subcategory`
                    , `name`
                    , `frequency`
                    , `query`
                    , `is_public`
                    ) 
                    VALUES 
                    (NULL, @creator_bz_id, @series_category_product, 2, 'UNCONFIRMED', 1, @serie_search_unconfirmed, 1)
                    ,(NULL, @creator_bz_id, @series_category_product, 2, 'CONFIRMED', 1, @serie_search_confirmed, 1)
                    ,(NULL, @creator_bz_id, @series_category_product, 2, 'IN_PROGRESS', 1, @serie_search_in_progress, 1)
                    ,(NULL, @creator_bz_id, @series_category_product, 2, 'REOPENED', 1, @serie_search_reopened, 1)
                    ,(NULL, @creator_bz_id, @series_category_product, 2, 'STAND BY', 1, @serie_search_standby, 1)
                    ,(NULL, @creator_bz_id, @series_category_product, 2, 'RESOLVED', 1, @serie_search_resolved, 1)
                    ,(NULL, @creator_bz_id, @series_category_product, 2, 'VERIFIED', 1, @serie_search_verified, 1)
                    ,(NULL, @creator_bz_id, @series_category_product, 2, 'CLOSED', 1, @serie_search_closed, 1)
                    ,(NULL, @creator_bz_id, @series_category_product, 2, 'FIXED', 1, @serie_search_fixed, 1)
                    ,(NULL, @creator_bz_id, @series_category_product, 2, 'INVALID', 1, @serie_search_invalid, 1)
                    ,(NULL, @creator_bz_id, @series_category_product, 2, 'WONTFIX', 1, @serie_search_wontfix, 1)
                    ,(NULL, @creator_bz_id, @series_category_product, 2, 'DUPLICATE', 1, @serie_search_duplicate, 1)
                    ,(NULL, @creator_bz_id, @series_category_product, 2, 'WORKSFORME', 1, @serie_search_worksforme, 1)
                    ,(NULL, @creator_bz_id, @series_category_product, 2, 'All Open', 1, @serie_search_all_open, 1)
                    ;
                    
            # Insert the series related to the Components/roles
                INSERT INTO `series`
                    (`series_id`
                    , `creator`
                    , `category`
                    , `subcategory`
                    , `name`
                    , `frequency`
                    , `query`
                    , `is_public`
                    ) 
                    VALUES
                    # Tenant
                    (NULL, @creator_bz_id, @series_category_product, @series_category_component_tenant, 'All Open', 1, @serie_search_all_open_tenant, 1)
                    ,(NULL, @creator_bz_id, @series_category_product, @series_category_component_tenant, 'All Closed' , 1, @serie_search_all_closed_tenant, 1)
                    # Landlord
                    ,(NULL, @creator_bz_id, @series_category_product, @series_category_component_landlord, 'All Open', 1, @serie_search_all_open_landlord, 1)
                    ,(NULL, @creator_bz_id, @series_category_product, @series_category_component_landlord, 'All Closed', 1, @serie_search_all_closed_landlord, 1)
                    # Contractor
                    ,(NULL, @creator_bz_id, @series_category_product, @series_category_component_contractor, 'All Open', 1, @serie_search_all_open_contractor, 1)
                    ,(NULL, @creator_bz_id, @series_category_product, @series_category_component_contractor, 'All Closed', 1, @serie_search_all_closed_contractor, 1)
                    # Management Company
                    ,(NULL, @creator_bz_id, @series_category_product, @series_category_component_mgtcny, 'All Open', 1, @serie_search_all_open_mgtcny, 1)
                    ,(NULL, @creator_bz_id, @series_category_product, @series_category_component_mgtcny, 'All Closed', 1, @serie_search_all_closed_mgtcny, 1)
                    # Agent
                    ,(NULL, @creator_bz_id, @series_category_product, @series_category_component_agent, 'All Open', 1, @serie_search_all_open_agent, 1)
                    ,(NULL, @creator_bz_id, @series_category_product, @series_category_component_agent, 'All Closed', 1, @serie_search_all_closed_agent, 1)
                    ;

	# We now assign the permissions to each of the dummy user associated to each role:
    #   - Tenant (1)
    #     @bz_user_id_dummy_tenant
    #   - Landlord (2)
    #     @bz_user_id_dummy_landlord
    #   - Contractor (3)
    #     @bz_user_id_dummy_contractor
    #   - Management company (4)
    #     @bz_user_id_dummy_mgt_cny
    #   - Agent (5)
    #     @bz_user_id_dummy_agent
    #
    #
    # For each of the dummy users, we use the following parameters:
        SET @user_in_default_cc_for_cases = 1;
        SET @replace_default_assignee = 1;

        # Default permissions for dummy users:	
            #User Permissions in the unit:
                # Generic Permissions
                    SET @can_see_time_tracking = 0;
                    SET @can_create_shared_queries = 0;
                    SET @can_tag_comment = 0;
                # Product/Unit specific permissions
                    SET @can_create_new_cases = 1;
                    SET @can_edit_a_case = 1;
                    SET @can_see_all_public_cases = 0;
                    SET @can_edit_all_field_in_a_case_regardless_of_role = 1;
                    SET @can_see_unit_in_search = 0;
                    SET @user_is_publicly_visible = 0;
                    SET @user_can_see_publicly_visible = 0;
                    SET @can_ask_to_approve_flags = 0;
                    SET @can_approve_all_flags = 0;
 
	# We create the permissions for the dummy user to create a case for this unit.		
	#	- can tag comments: ALL user need that	
	#	- can_create_new_cases
	#	- can_edit_a_case
	# This is the only permission that the dummy user will have.
		# First the global permissions:
			# Can tag comments
				INSERT INTO `ut_user_group_map_temp`
					(`user_id`
					, `group_id`
					, `isbless`
					, `grant_type`
					) 
					VALUES 
					(@bz_user_id_dummy_tenant, @can_tag_comment_group_id, 0, 0)
					, (@bz_user_id_dummy_landlord, @can_tag_comment_group_id, 0, 0)
					, (@bz_user_id_dummy_agent, @can_tag_comment_group_id, 0, 0)
					, (@bz_user_id_dummy_contractor, @can_tag_comment_group_id, 0, 0)
					, (@bz_user_id_dummy_mgt_cny, @can_tag_comment_group_id, 0, 0)
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
		 
				# Cleanup the variables for the log messages
					SET @script_log_message = NULL;
		
		# Then the permissions at the unit/product level:
					
			# User can create a case:
				INSERT INTO `ut_user_group_map_temp`
					(`user_id`
					, `group_id`
					, `isbless`
					, `grant_type`
					) 
					VALUES 
					(@bz_user_id_dummy_tenant, @create_case_group_id, 0, 0)
					, (@bz_user_id_dummy_landlord, @create_case_group_id, 0, 0)
					, (@bz_user_id_dummy_agent, @create_case_group_id, 0, 0)
					, (@bz_user_id_dummy_contractor, @create_case_group_id, 0, 0)
					, (@bz_user_id_dummy_mgt_cny, @create_case_group_id, 0, 0)
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
 
				# Cleanup the variables for the log messages
					SET @script_log_message = NULL;

			# User can Edit a case and see this unit, this is needed so the API does not throw an error see issue #60:
				INSERT INTO `ut_user_group_map_temp`
					(`user_id`
					, `group_id`
					, `isbless`
					, `grant_type`
					) 
					VALUES 
					(@bz_user_id_dummy_tenant, @can_edit_case_group_id, 0, 0)
					, (@bz_user_id_dummy_landlord, @can_edit_case_group_id, 0, 0)
					, (@bz_user_id_dummy_agent, @can_edit_case_group_id, 0, 0)
					, (@bz_user_id_dummy_contractor, @can_edit_case_group_id, 0, 0)
					, (@bz_user_id_dummy_mgt_cny, @can_edit_case_group_id, 0, 0)
					, (@bz_user_id_dummy_tenant, @can_see_unit_in_search_group_id, 0, 0)
					, (@bz_user_id_dummy_landlord, @can_see_unit_in_search_group_id, 0, 0)
					, (@bz_user_id_dummy_agent, @can_see_unit_in_search_group_id, 0, 0)
					, (@bz_user_id_dummy_contractor, @can_see_unit_in_search_group_id, 0, 0)
					, (@bz_user_id_dummy_mgt_cny, @can_see_unit_in_search_group_id, 0, 0)
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
				 
				# Cleanup the variables for the log messages
					SET @script_log_message = NULL;

	# We give the user the permission they need.

        # We update the `group_group_map` table first
        #   - Create an intermediary table to deduplicate the records in the table `ut_group_group_map_temp`
        #   - If the record does NOT exists in the table then INSERT new records in the table `group_group_map`
        #   - If the record DOES exist in the table then update the new records in the table `group_group_map`

            # We drop the deduplication table if it exists:
                DROP TEMPORARY TABLE IF EXISTS `ut_group_group_map_dedup`;

            # We create a table `ut_group_group_map_dedup` to prepare the data we need to insert
                CREATE TEMPORARY TABLE `ut_group_group_map_dedup` (
                    `member_id` mediumint(9) NOT NULL,
                    `grantor_id` mediumint(9) NOT NULL,
                    `grant_type` tinyint(4) NOT NULL DEFAULT '0',
                    UNIQUE KEY `ut_group_group_map_dedup_member_id_idx` (`member_id`, `grantor_id`, `grant_type`),
                    KEY `fk_group_group_map_dedup_grantor_id_groups_id` (`grantor_id`),
                    KEY `group_group_map_dedup_grantor_id_grant_type_idx` (`grantor_id`, `grant_type`),
                    KEY `group_group_map_dedup_member_id_grant_type_idx` (`member_id`, `grant_type`)
                   ) 
                ;
    
            # We insert the de-duplicated record in the table `ut_group_group_map_dedup`
                INSERT INTO `ut_group_group_map_dedup`
                SELECT `member_id`
                    , `grantor_id`
                    , `grant_type`
                FROM
                    `ut_group_group_map_temp`
                GROUP BY `member_id`
                    , `grantor_id`
                    , `grant_type`
                ORDER BY `member_id` ASC
                    , `grantor_id` ASC
                ;

            # We insert the data we need in the `group_group_map` table
                INSERT INTO `group_group_map`
                SELECT `member_id`
                    , `grantor_id`
                    , `grant_type`
                FROM
                    `ut_group_group_map_dedup`
                # The below code is overkill in this context: 
                # the Unique Key Constraint makes sure that all records are unique in the table `ut_group_group_map_dedup`
                ON DUPLICATE KEY UPDATE
                    `member_id` = `ut_group_group_map_dedup`.`member_id`
                    , `grantor_id` = `ut_group_group_map_dedup`.`grantor_id`
                    , `grant_type` = `ut_group_group_map_dedup`.`grant_type`
                ;

            # We drop the temp table as we do not need it anymore
                DROP TEMPORARY TABLE IF EXISTS `ut_group_group_map_dedup`;

        # We can now update the permissions table for the users
        # This NEEDS the table 'ut_user_group_map_temp'
            CALL `update_permissions_invited_user`;

	# Update the table 'ut_data_to_create_units' so that we record that the unit has been created
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
	
END 
$$
DELIMITER ;

# Update the procedure `remove_user_from_default_cc` to remove a user in Default CC from a given role
	
	DROP PROCEDURE IF EXISTS `remove_user_from_default_cc`;

DELIMITER $$
CREATE PROCEDURE `remove_user_from_default_cc`()
SQL SECURITY INVOKER
BEGIN
	# This procedure needs the following objects
	#	- Variables:
	#		- @bz_user_id : the BZ user id of the user
	#		- @component_id_this_role: The id of the role in the bz table `components`
	#
	# We delete the record in the table that store default CC information
		DELETE
		FROM `component_cc`
			WHERE `user_id` = @bz_user_id
				AND `component_id` = @component_id_this_role
		;

	# We get the product id so we can log this properly
		SET @product_id_for_this_procedure = (SELECT `product_id` FROM `components` WHERE `id` = @component_id_this_role);

	# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - remove_user_from_default_cc';
			SET @timestamp = NOW();
				
	# Log the actions of the script.
		SET @script_log_message = CONCAT('the bz user #'
								, @bz_user_id
								, ' is NOT in Default CC for the component/role '
								, @component_id_this_role
								, ' for the product/unit '
								, @product_id_for_this_procedure
								);
				
		INSERT INTO `ut_script_log`
			(`datetime`
			, `script`
			, `log`
				)
			VALUES
			(@timestamp, @script, @script_log_message)
			;

	# Cleanup the variables for the log messages
		SET @script_log_message = NULL;
		SET @script = NULL;
		SET @product_id_for_this_procedure = NULL;
END $$
DELIMITER ;

# Update the procedure `remove_user_from_role`
	
	DROP PROCEDURE IF EXISTS `remove_user_from_role`;

DELIMITER $$
CREATE PROCEDURE `remove_user_from_role`()
SQL SECURITY INVOKER
BEGIN
	# This procedure needs the following objects
	#	- Variables:
	#		- @remove_user_from_role
	#		- @component_id_this_role
	#		- @product_id
	#		- @bz_user_id
	#		- @bz_user_id_dummy_user_this_role
	#		- @id_role_type
	# 		- @this_script
	#		- @creator_bz_id

	# We only do this if this is needed:
	IF (@remove_user_from_role = 1)
	THEN
		# The script `invite_a_user_to_a_role_in_a_unit.sql` which call this procedure, already calls: 
		# 	- `table_to_list_dummy_user_by_environment`;
		# 	- `remove_user_from_default_cc`
		# There is no need to do this again
		#
		# The script also reset the permissions for this user for this role for this unit to the default permissions.
		# We need to remove ALL the permissions for this user.
		
			# Create the table to prepare the permissions
				CALL `create_temp_table_to_update_permissions`;
				
			# Revoke all permissions for this user in this unit
				# This procedure needs the following objects:
				#	- Variables:
				#		- @product_id
				#		- @bz_user_id
				CALL `revoke_all_permission_for_this_user_in_this_unit`;
			
			# All the permission have been prepared, we can now update the permissions table
			#		- This NEEDS the table 'ut_user_group_map_temp'
				CALL `update_permissions_invited_user`;

		# Who are the initial owner and initialqa contact for this role?
												
			# Get the old values so we can 
			#	- Check if these are default user for this environment
			#	- log those
				SET @old_component_initialowner = (SELECT `initialowner`
					FROM `components` 
					WHERE `id` = @component_id_this_role)
					;
					
				SET @old_component_initialqacontact = (SELECT `initialqacontact` 
					FROM `components` 
					WHERE `id` = @component_id_this_role)
					;
					
				SET @old_component_description = (SELECT `description` 
					FROM `components` 
					WHERE `id` = @component_id_this_role)
					;
		
		# We need to check if the user we are removing is the current default user for this role for this unit.
			SET @is_user_default_assignee = IF(@old_component_initialowner = @bz_user_id
				, '1'
				, '0'
				)
				;

		# We need to check if the user we are removing is the current qa user for this role for this unit.
			SET @is_user_qa = IF(@old_component_initialqacontact = @bz_user_id
				, '1'
				, '0'
				)
				;
										
		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - remove_user_from_role';
			SET @timestamp = NOW();

		IF @is_user_default_assignee = 1
		THEN
		# We need to replace this with the default dummy user
		# The variables needed for this are
		#	- @bz_user_id_dummy_user_this_role
		# 	- @component_id_this_role
		#	- @id_role_type
		# 	- @this_script
		#	- @product_id
		#	- @creator_bz_id
		
			# We define the dummy user role description based on the variable @id_role_type
				SET @dummy_user_role_desc = IF(@id_role_type = 1
					, CONCAT('Generic '
						, (SELECT`role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
						, ' - THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL'
						, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
						, ' TO THIS UNIT'
						)
					, IF(@id_role_type = 2
						, CONCAT('Generic '
							, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
							, ' - THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL'
							, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
							, ' TO THIS UNIT'
							)
						, IF(@id_role_type = 3
							, CONCAT('Generic '
								, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
								, ' - THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL'
								, (SELECT`role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
								, ' TO THIS UNIT'
								)
							, IF(@id_role_type = 4
								, CONCAT('Generic '
									, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
									, ' - THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL'
									, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
									, ' TO THIS UNIT'
									)
								, IF(@id_role_type = 5
									, CONCAT('Generic '
										, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
										, ' - THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL'
										, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
										, ' TO THIS UNIT'
										)
									, CONCAT('error in script'
										, @this_script
										, 'line 170'
										)
									)
								)
							)
						)
					)
					;
					
			# We define the dummy user public name based on the variable @bz_user_id_dummy_user_this_role
				SET @dummy_user_pub_name = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_user_this_role);
			
			# Update the default assignee
				UPDATE `components`
				SET `initialowner` = @bz_user_id_dummy_user_this_role
					,`description` = @dummy_user_role_desc
					WHERE 
					`id` = @component_id_this_role
					;

			# Log the actions of the script.
				SET @script_log_message = CONCAT('The component: '
					, (SELECT IFNULL(@component_id_this_role, 'component_id_this_role is NULL'))
					, ' (for the role_type_id #'
					, (SELECT IFNULL(@id_role_type, 'id_role_type is NULL'))
					, ') has been updated.'
					, '\r\The default user now associated to this role is the dummy bz user #'
					, (SELECT IFNULL(@bz_user_id_dummy_user_this_role, 'bz_user_id is NULL'))
					, ' (real name: '
					, (SELECT IFNULL(@dummy_user_pub_name, 'user_pub_name is NULL'))
					, ') for the unit #' 
					, @product_id
					);
					
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
					)
					VALUES
					(@timestamp, @script, @script_log_message)
					;
						
			# We update the BZ logs
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
					(@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'initialowner',@old_component_initialowner,@bz_user_id_dummy_user_this_role,@timestamp)
					, (@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'description',@old_component_description,@dummy_user_role_desc,@timestamp)
					;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
		END IF;

		IF @is_user_qa = 1
		THEN
		# IF the user is the current qa contact: We need to replace this with the default dummy user
		# The variables needed for this are
		#	- @bz_user_id_dummy_user_this_role
		# 	- @component_id_this_role
		#	- @id_role_type
		# 	- @this_script
		#	- @product_id
		#	- @creator_bz_id

			# We define the dummy user role description based on the variable @id_role_type
				SET @dummy_user_role_desc = IF(@id_role_type = 1
					, CONCAT('Generic '
						, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
						, ' - THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL'
						, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
						, ' TO THIS UNIT'
						)
					, IF(@id_role_type = 2
						, CONCAT('Generic '
							, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
							, ' - THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL'
							, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
							, ' TO THIS UNIT'
							)
						, IF(@id_role_type = 3
							, CONCAT('Generic '
								, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
								, ' - THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL'
								, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
								, ' TO THIS UNIT'
								)
							, IF(@id_role_type = 4
								, CONCAT('Generic '
									, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
									, ' - THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL'
									, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
									, ' TO THIS UNIT'
									)
								, IF(@id_role_type = 5
									, CONCAT('Generic '
										, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
										, ' - THIS SHOULD NOT BE USED UNTIL YOU HAVE ASSOCIATED AN ACTUAL'
										, (SELECT `role_type` FROM `ut_role_types` WHERE `id_role_type` = @id_role_type)
										, ' TO THIS UNIT'
										)
									, CONCAT('error in script'
										, @this_script
										, 'line 298'
										)
									)
								)
							)
						)
					)
					;
					
			# We define the dummy user public name based on the variable @bz_user_id_dummy_user_this_role
				SET @dummy_user_pub_name = (SELECT `realname` FROM `profiles` WHERE `userid` = @bz_user_id_dummy_user_this_role);
		
			# Update the default assignee and qa contact
				UPDATE `components`
				SET 
					`initialqacontact` = @bz_user_id_dummy_user_this_role
					WHERE 
					`id` = @component_id_this_role
					;	

			# Log the actions of the script.
				SET @script_log_message = CONCAT('The component: '
					, (SELECT IFNULL(@component_id_this_role, 'component_id_this_role is NULL'))
					, ' (for the role_type_id #'
					, (SELECT IFNULL(@id_role_type, 'id_role_type is NULL'))
					, ') has been updated.'
					, '\r\The QA contact now associated to this role is the dummy bz user #'
					, (SELECT IFNULL(@bz_user_id_dummy_user_this_role, 'bz_user_id is NULL'))
					, ' (real name: '
					, (SELECT IFNULL(@dummy_user_pub_name, 'user_pub_name is NULL'))
					, ') for the unit #' 
					, @product_id
					);
					
				INSERT INTO `ut_script_log`
					(`datetime`
					, `script`
					, `log`
						)
					VALUES
					(@timestamp, @script, @script_log_message)
					;
						
			# We update the BZ logs
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
					(@creator_bz_id,'Bugzilla::Component',@component_id_this_role,'initialqacontact',@old_component_initialqacontact,@bz_user_id_dummy_user_this_role,@timestamp)
					;
				 
				# Cleanup the variables for the log messages
					SET @script_log_message = NULL;
		END IF;
		
		# Clean up the variable for the script and timestamp
			SET @script = NULL;
			SET @timestamp = NULL;
	END IF;
END $$
DELIMITER ;

# Update the procedure to revoke the permission for a given user

	DROP PROCEDURE IF EXISTS `revoke_all_permission_for_this_user_in_this_unit`;

DELIMITER $$
CREATE PROCEDURE `revoke_all_permission_for_this_user_in_this_unit`()
SQL SECURITY INVOKER
BEGIN

    # this procedure needs the following variables:
    #   - @product_id
    #   - @bz_user_id

	# We record the name of this procedure for future debugging and audit_log
		SET @script = 'PROCEDURE - revoke_all_permission_for_this_user_in_this_unit';
		SET @timestamp = NOW();

	# We need to get the group_id for this unit

		SET @can_see_time_tracking_group_id = 16;
		SET @can_create_shared_queries_group_id = 17;
		SET @can_tag_comment_group_id = 18;	
	
		SET @create_case_group_id =  (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 20));
		SET @can_edit_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 25));
		SET @can_see_cases_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 28));
	
		SET @can_edit_all_field_case_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 26));
		
		SET @can_see_unit_in_search_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 38));

		SET @list_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 4));
		SET @see_visible_assignees_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 5));	

		SET @all_r_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 18));
		SET @all_g_flags_group_id = (SELECT `group_id` FROM `ut_product_group` WHERE (`product_id` = @product_id AND `group_type_id` = 19));

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

	# We can now remove all the permissions for this unit.

		DELETE FROM `user_group_map`
			WHERE (
				(`user_id` = @bz_user_id AND `group_id` = @can_see_time_tracking_group_id)
				OR (`user_id` = @bz_user_id AND `group_id` = @can_create_shared_queries_group_id)
				OR (`user_id` = @bz_user_id AND `group_id` = @can_tag_comment_group_id)
				OR (`user_id` = @bz_user_id AND `group_id` = @create_case_group_id)
				OR (`user_id` = @bz_user_id AND `group_id` = @can_edit_case_group_id)
				OR (`user_id` = @bz_user_id AND `group_id` = @can_see_cases_group_id)
				OR (`user_id` = @bz_user_id AND `group_id` = @can_edit_all_field_case_group_id)
				OR (`user_id` = @bz_user_id AND `group_id` = @can_see_unit_in_search_group_id)
				OR (`user_id` = @bz_user_id AND `group_id` = @list_visible_assignees_group_id)
				OR (`user_id` = @bz_user_id AND `group_id` = @see_visible_assignees_group_id)
				OR (`user_id` = @bz_user_id AND `group_id` = @all_r_flags_group_id)
				OR (`user_id` = @bz_user_id AND `group_id` = @all_g_flags_group_id)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_show_to_occupant)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_are_users_occupant)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_see_users_occupant)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_show_to_tenant)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_are_users_tenant)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_see_users_tenant)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_show_to_landlord)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_are_users_landlord)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_see_users_landlord)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_show_to_agent)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_are_users_agent)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_see_users_agent)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_show_to_contractor)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_are_users_contractor)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_see_users_contractor)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_show_to_mgt_cny)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_are_users_mgt_cny)
				OR (`user_id` = @bz_user_id AND `group_id` = @group_id_see_users_mgt_cny)
				)
				;

        # We also delete from the table `ut_user_group_map_temp`
        # This is needed so we do not re-create the permissions when we invite a new user or create a new unit.

            DELETE FROM `ut_user_group_map_temp`
                WHERE (
                    (`user_id` = @bz_user_id AND `group_id` = @can_see_time_tracking_group_id)
                    OR (`user_id` = @bz_user_id AND `group_id` = @can_create_shared_queries_group_id)
                    OR (`user_id` = @bz_user_id AND `group_id` = @can_tag_comment_group_id)
                    OR (`user_id` = @bz_user_id AND `group_id` = @create_case_group_id)
                    OR (`user_id` = @bz_user_id AND `group_id` = @can_edit_case_group_id)
                    OR (`user_id` = @bz_user_id AND `group_id` = @can_see_cases_group_id)
                    OR (`user_id` = @bz_user_id AND `group_id` = @can_edit_all_field_case_group_id)
                    OR (`user_id` = @bz_user_id AND `group_id` = @can_see_unit_in_search_group_id)
                    OR (`user_id` = @bz_user_id AND `group_id` = @list_visible_assignees_group_id)
                    OR (`user_id` = @bz_user_id AND `group_id` = @see_visible_assignees_group_id)
                    OR (`user_id` = @bz_user_id AND `group_id` = @all_r_flags_group_id)
                    OR (`user_id` = @bz_user_id AND `group_id` = @all_g_flags_group_id)
                    OR (`user_id` = @bz_user_id AND `group_id` = @group_id_show_to_occupant)
                    OR (`user_id` = @bz_user_id AND `group_id` = @group_id_are_users_occupant)
                    OR (`user_id` = @bz_user_id AND `group_id` = @group_id_see_users_occupant)
                    OR (`user_id` = @bz_user_id AND `group_id` = @group_id_show_to_tenant)
                    OR (`user_id` = @bz_user_id AND `group_id` = @group_id_are_users_tenant)
                    OR (`user_id` = @bz_user_id AND `group_id` = @group_id_see_users_tenant)
                    OR (`user_id` = @bz_user_id AND `group_id` = @group_id_show_to_landlord)
                    OR (`user_id` = @bz_user_id AND `group_id` = @group_id_are_users_landlord)
                    OR (`user_id` = @bz_user_id AND `group_id` = @group_id_see_users_landlord)
                    OR (`user_id` = @bz_user_id AND `group_id` = @group_id_show_to_agent)
                    OR (`user_id` = @bz_user_id AND `group_id` = @group_id_are_users_agent)
                    OR (`user_id` = @bz_user_id AND `group_id` = @group_id_see_users_agent)
                    OR (`user_id` = @bz_user_id AND `group_id` = @group_id_show_to_contractor)
                    OR (`user_id` = @bz_user_id AND `group_id` = @group_id_are_users_contractor)
                    OR (`user_id` = @bz_user_id AND `group_id` = @group_id_see_users_contractor)
                    OR (`user_id` = @bz_user_id AND `group_id` = @group_id_show_to_mgt_cny)
                    OR (`user_id` = @bz_user_id AND `group_id` = @group_id_are_users_mgt_cny)
                    OR (`user_id` = @bz_user_id AND `group_id` = @group_id_see_users_mgt_cny)
                    )
                    ;

			# Log the actions of the script.

				SET @script_log_message = CONCAT('We have revoked all the permissions for the bz user #'
										, @bz_user_id
										, '\r\- can_see_time_tracking: 0'
										, '\r\- can_create_shared_queries: 0'
										, '\r\- can_tag_comment: 0'
										, '\r\- can_create_case: 0'
										, '\r\- can_edit_a_case: 0'
										, '\r\- can_see_cases: 0'
										, '\r\- can_edit_all_field_in_a_case_regardless_of_role: 0'
										, '\r\- can_see_unit_in_search: 0'
										, '\r\- user_can_see_publicly_visible: 0'
										, '\r\- user_is_publicly_visible: 0'
										, '\r\- can_ask_to_approve: 0'
										, '\r\- can_approve: 0'
										, '\r\- show_to_occupant: 0'
										, '\r\- are_users_occupant: 0'
										, '\r\- see_users_occupant: 0'
										, '\r\- show_to_tenant: 0'
										, '\r\- are_users_tenant: 0'
										, '\r\- see_users_tenant: 0'
										, '\r\- show_to_landlord: 0'
										, '\r\- are_users_landlord: 0'
										, '\r\- see_users_landlord: 0'
										, '\r\- show_to_agent: 0'
										, '\r\- are_users_agent: 0'
										, '\r\- see_users_agent: 0'
										, '\r\- show_to_contractor: 0'
										, '\r\- are_users_contractor: 0'
										, '\r\- see_users_contractor: 0'
										, '\r\- show_to_mgt_cny: 0'
										, '\r\- are_users_mgt_cny: 0'
										, '\r\- see_users_mgt_cny: 0'
										, '\r\For the product #'
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
				 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @script = NULL;

END $$
DELIMITER ;

# Update the procedure `user_in_default_cc_for_cases`
#       - Do not write in the table `ut_audit_log` (this is done with triggers)
#       - Use a temporary table
#       - Create a dedicated dedup table so we do not have to truncate the table when we add records

    DROP PROCEDURE IF EXISTS `user_in_default_cc_for_cases`;

DELIMITER $$
CREATE PROCEDURE `user_in_default_cc_for_cases`()
BEGIN
	IF (@user_in_default_cc_for_cases = 1)
	THEN 

		# We record the name of this procedure for future debugging and audit_log`
			SET @script = 'PROCEDURE - user_in_default_cc_for_cases';
			SET @timestamp = NOW();

		# We use a temporary table to make sure we do not have duplicates.
		
		# DELETE the temp table if it exists
		DROP TEMPORARY TABLE IF EXISTS `ut_temp_component_cc`;
		
		# Re-create the temp table
		CREATE TEMPORARY TABLE `ut_temp_component_cc` (
            `user_id` MEDIUMINT(9) NOT NULL
            , `component_id` MEDIUMINT(9) NOT NULL
		    )
            ;

		# Add the records that exist in the table component_cc
		INSERT INTO `ut_temp_component_cc`
			SELECT *
			FROM `component_cc`;

		# Add the new user rights for the product
			INSERT INTO `ut_temp_component_cc`
				(user_id
				, component_id
				)
				VALUES
				(@bz_user_id, @component_id)
				;

        # We drop the deduplication table if it exists:
            DROP TEMPORARY TABLE IF EXISTS `ut_temp_component_cc_dedup`;

        # We create a table `ut_user_group_map_dedup` to prepare the data we need to insert
            CREATE TEMPORARY TABLE `ut_temp_component_cc_dedup` (
                `user_id` MEDIUMINT(9) NOT NULL
                , `component_id` MEDIUMINT(9) NOT NULL
                , UNIQUE KEY `ut_temp_component_cc_dedup_userid_componentid` (`user_id`, `component_id`)
                )
            ;
            
        # We insert the de-duplicated record in the table `ut_temp_component_cc_dedup`
            INSERT INTO `ut_temp_component_cc_dedup`
            SELECT `user_id`
                , `component_id`
            FROM
                `ut_temp_component_cc`
            GROUP BY `user_id`
                , `component_id`
            ;

		# We insert the new records in the table `component_cc`
			INSERT INTO `component_cc`
			SELECT `user_id`
				, `component_id`
			FROM
				`ut_temp_component_cc_dedup`
			GROUP BY `user_id`
				, `component_id`
            # The below code is overkill in this context: 
            # the Unique Key Constraint makes sure that all records are unique in the table `user_group_map`
            ON DUPLICATE KEY UPDATE
                `user_id` = `ut_temp_component_cc_dedup`.`user_id`
				, `component_id` = `ut_temp_component_cc_dedup`.`component_id`
			;

        # Clean up:
            # We drop the deduplication table if it exists:
                DROP TEMPORARY TABLE IF EXISTS `ut_temp_component_cc_dedup`;
            
            # We Delete the temp table as we do not need it anymore
                DROP TEMPORARY TABLE IF EXISTS `ut_temp_component_cc`;
		
		# Log the actions of the script.
			SET @script_log_message = CONCAT('the bz user #'
									, @bz_user_id
									, ' is one of the copied assignee for the unit #'
									, @product_id
									, ' when the role '
									, @role_user_g_description
									, ' (the component #'
									, @component_id
									, ')'
									, ' is chosen'
									);
			
			INSERT INTO `ut_script_log`
				(`datetime`
				, `script`
				, `log`
				)
				VALUES
				(NOW(), @script, @script_log_message)
				;
			 
			# Cleanup the variables for the log messages
				SET @script_log_message = NULL;
				SET @script = NULL;
    END IF ;
END $$
DELIMITER ;

# Update the procedure `user_is_default_assignee_for_cases`
	
	DROP PROCEDURE IF EXISTS `user_is_default_assignee_for_cases`;

DELIMITER $$
CREATE PROCEDURE `user_is_default_assignee_for_cases`()
SQL SECURITY INVOKER
BEGIN
	# This procedure needs the following objects
	#	- Variables:
	#		- @replace_default_assignee
	#		- @component_id_this_role
	#		- @bz_user_id
	#		- @user_role_desc
	#		- @id_role_type
	#		- @user_pub_name
	#		- @product_id
	#

	# We only do this if this is needed:
	IF (@replace_default_assignee = 1)
	
	THEN

	# We record the name of this procedure for future debugging and audit_log`
		SET @script = 'PROCEDURE - user_is_default_assignee_for_cases';
		SET @timestamp = NOW();

	# change the initial owner and initialqa contact to the invited BZ user.
											
		# Get the old values so we can log those
			SET @old_component_initialowner = (SELECT `initialowner` 
										FROM `components` 
										WHERE `id` = @component_id_this_role)
										;
			SET @old_component_initialqacontact = (SELECT `initialqacontact` 
										FROM `components` 
										WHERE `id` = @component_id_this_role)
										;
			SET @old_component_description = (SELECT `description` 
										FROM `components` 
										WHERE `id` = @component_id_this_role)
										;

		# Update the default assignee and qa contact
			UPDATE `components`
			SET 
				`initialowner` = @bz_user_id
				,`initialqacontact` = @bz_user_id
				,`description` = @user_role_desc
				WHERE 
				`id` = @component_id_this_role
				;
					
	# Log the actions of the script.
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
		 
        # Cleanup the variables for the log messages
            SET @script_log_message = NULL;
            SET @script = NULL;

	# We update the BZ logs
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

	END IF;
END $$
DELIMITER ;

# We also make sure that we use the correct definition for the Unee-T fields:

    CALL `update_bz_fielddefs`; 

# We can now update the version of the database schema
	# A comment for the update
		SET @comment_update_schema_version = CONCAT (
			'Database updated from '
			, @old_schema_version
			, ' to '
			, @new_schema_version
		)
		;
	
	# We record that the table has been updated to the new version.
	INSERT INTO `ut_db_schema_version`
		(`schema_version`
		, `update_datetime`
		, `update_script`
		, `comment`
		)
		VALUES
		(@new_schema_version
		, @the_timestamp
		, @this_script
		, @comment_update_schema_version
		)
		;