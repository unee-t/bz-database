# We might need to create additional classification/Unit Group
#
# This script has been built by reverse engineering of BZ
#  1- Create a new classificaction in the back end (make sure that BZ creates groups and series for this product too.
#  2- See the results in the database
#  3- Create and refine this script...
#
# This script: 
#  - creates the classification @building based on the values in the product table from ipi
#  - update the migration table so that we record the old and new values for the product table in the migration database.
#  - DOES NOT create any product/unit
#
# Tt requires:
#  - The latest classification_id in the database
#  - A name for the classification/Unit Group (@unit_group) We use the convention UG-1 for a unit group
#  - Information about the product/Unit Group (@unit_group_description)

# Define the variables
SET @unit_group = 'UG-1';
SET @unit_group_description = 'Unit Group 1 - This is a way to group units together';


# We have everything - Do this!
	INSERT  INTO `classifications`
		(`id`
		,`name`
		,`description`
		,`sortkey`
		) 
		VALUES 
		(NULL,@unit_group,@unit_group_description,0);

# Cleanup after: flush the variables
SET @unit_group = NULL;
SET @unit_group_description = NULL;