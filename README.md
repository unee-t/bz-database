# IMPORTANT NOTE
Since v3.x of the database schema, we have created dependencies which REQUIRE you to run the BZFE of Unee-T on Amazon Aurora.
This is needed so we can create notifications in a simple and scalable way. 
See [Issue #13] (https://github.com/unee-t/frontend/issues/13) for more details about that.

# Before your start:
To use this, you should have installed the Unee-t BZFE on an AWS EC2 instance ideally...
See the [README file] (https://github.com/unee-t/bugzilla-customisation/blob/master/README.md) on the [bugzilla-customization repo] (https://github.com/unee-t/bugzilla-customisation) for more details, including a step by step video of how this is done.

# What's in this repo:
Scripts and stuff to play and tinker with the bz database so we can build the BZFE.

These scripts are meant to be run on the database that you use for your BZFE.
They are compatible with the Amazon Aurora DB engine (MariaDB/MySQL).

# Upgrade the BZFE database:
In the folder 'db upgrade' are the scripts to update the database to the latest version.
Open these script to better understand the changes that were made.

# Database snapshots:
In the folder 'db snapsots' are scripts to restore a *clean* version of the database for each version of the BZFE.

A clean version of the database has
* 1 Administrator user only
  * login: adminitrator@example.com
  * password: `administrator`.
* Demo units and demo users
* No case
* All the variables needed to create a 'blank' Unee-T environment.

# Demo users:
When you use the docker image, we create Demo users and demo units as part of the build.
Details about these demo users and demo units can be found on the [documentation about the demo environment](https://documentation.unee-t.com/2018/03/01/introduction-to-the-demo-environment/)

You can restore a fresh version of the demo environment using scripts in the folder /demo-test environment

# Stress Test

There is one specific script 'insert_DEMO-TEST_users_in_unee-t_bzfe_vx.y.sql' which creates a lot of user and a lot of unit.
This is use to simulate a large Unee-T environment.
This script has NOT been updated since db v2.14 (if you want to do that, feel free to help!)

## Before you run this script:
Open the script and choose a value for the 2 variables:
* iteration_number_of_users: This variable allow you to users in batches of 12 users.
* number_of_units_per_user: This variable defines the minium number of units that each user will have created either 
  * As Tenant and occupant for the first unit
  * As Landlord for all the units after the first units.

## How does the script work:

### Users:
The administrator user is administrator@example.com. Password: `administrator`.

The script will create users in batches of 12 users (on top of the adminsitrator user)
* Each batch has the following users:
  * leonel@example.com. Password: `leonel`.
  * marley@example.com. Password: `marley`.
  * michael@example.com. Password: `michael`.
  * sabrina@example.com. Password: `sabrina`.
  * celeste@example.com. Password: `celeste`.
  * jocelyn@example.com. Password: `jocelyn`.
  * marina@example.com. Password: `marina`.
  * regina@example.com. Password: `regina`.
  * marvin@example.com. Password: `marvin`.
  * lawrence@example.com. Password: `lawrence`.
  * anabelle@example.com. Password: `anabelle`.
  * management.co@example.com. Password: `management co`.

You can choose to create n batches of users by changing the variable `iteration_number_of_users` at the top of the script.

>Example: if you choose `iteration_number_of_users` = 2, you will have 1 + (12 * 2) = 25 users in you installation.

### Units:
The script creates at least 1 unit for each user.

**Important note:** Each unit created will be linked to more than 1 user (more on that later)
You can define the number of unit created by each user by changing the variable `number_of_units_per_user` at the top of the script.

The script will loop and create n more unit for each user.
Example: if you choose `iteration_number_of_users` = 2 and `number_of_units_per_user` = 10, the script will create 1 + 12 * 2 = 25 * 10 = 250 units.
