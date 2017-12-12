# bz-database
Scripts and stuff to play and tinker with the bz database so we can build the BZ FE
To use this, you should have installed the Unee-t Bugzilla Front End somewhere.
These scripts are meant to be run on the database that you use for your BZ FE.

# Upgrade the BZFE databas:
In the folder 'db upgrade' are the MariaDB scripts to update the database to the latest version.
Open these script to better understand the changes that were made.

# Database snapshots
In the folder 'db snapsots' are MariaDB scripts to restore a *clean* version of the database for each version of the BZFE.
A clean version of the database has
* 1 Administrator user only 
** login: adminitrator@example.com
** password: administrator
* No other users
* No case
* All the variables needed to create a 'blank' Unee-T environment.

# Insert Demo users:
There is a script which creates several users, units and roles.
This has been created so that we can stress test the application a verify performances for various scenarii.

The script is located in the folder demo-test 'environment'.
It's a MariaDB script that should run in any compatible MariaDB client

## How does the script work:


## Before you run this script:
Open the script and choose a value for the 2 variables:
* @iteration_number_of_users: This variable allow you to users in batches of 12 users.
* @number_of_units_per_user: This variable defines the minium number of units that each user will have created either 
** as Tenant and occupant for the first unit
** as Landlord for all the units after the first units.