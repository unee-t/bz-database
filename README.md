# What's in this repo:
Scripts and stuff to play and tinker with the bz database so we can build the BZFE.

To use this, you should have installed the Unee-t BZFE somewhere.

These scripts are meant to be run on the database that you use for your BZFE.
They are MariaDB scripts and should be compatible with most MariaDB and MySQL clients.

# Upgrade the BZFE database:
In the folder 'db upgrade' are the MariaDB scripts to update the database to the latest version.
Open these script to better understand the changes that were made.

# Database snapshots:
In the folder 'db snapsots' are MariaDB scripts to restore a *clean* version of the database for each version of the BZFE.

A clean version of the database has
* 1 Administrator user only
  * login: adminitrator@example.com
  * password: `administrator`.
* No other users
* No case
* All the variables needed to create a 'blank' Unee-T environment.

# Insert Demo users:
There is a script which creates several users, units and roles.
This has been created so that we can stress test the application a verify performances for various scenarii.

The script is located in the folder demo-test 'environment'.
It's a MariaDB script that should run in any compatible MariaDB client

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
Example: if you choose `iteration_number_of_users` = 2, you will have 1 + (12 * 2) = 25 users in you installation.

### Units:
The script creates at least 1 unit for each user.
**Important note:** Each unit created will be linked to more than 1 user (more on that later)
You can define the number of unit created by each user by changing the variable `number_of_units_per_user` at the top of the script.

The script will loop and create n more unit for each user.
Example: if you choose `iteration_number_of_users` = 2 and `number_of_units_per_user` = 10, the script will create 1 + 12 * 2 = 25 * 10 = 250 units.

### Roles:
For each units, we are creating several roles:
* Tenant
* Landlord
* Agent
* Contractor
  * Main contact
  * Employee 1
  * Employee 2
* Management Company
  * Generic Contact
  * Employee 1
  * Employee 2
* Occupant
  
### Assignment of roles to Units:
The script behaves as such:

#### First batch of units:
For each unit, the scrip assign one of the users created to one specific role for this unit:
* A Tenant. This Tenant is also the creator and the occupant of the unit.
* A Landlord. This Landlord is different from the tenant and is either:
  * Marley (or Marley-n if you have created n batches of users).
  * Michael (or Michael-n if you have created n batches of users).
  * Sabrina (or Sabrina-n if you have created n batches of users).
* An Agent. This Agent is different from the Tenant and is either:
  * Celeste (or Celeste-n if you have created n batches of users).
  * Jocelyn (or Jocelyn-n if you have created n batches of users).
* A contractor: This contractor has 3 employees/users:
  * Marina: 
	* An employee of the contractor.
    * The main contact for the contractor.
	* A public contact: it's visible by all the other Roles/Stakeholders (Tenant, Agent, etc...)
  * Regina: 
    * An employee of the contractor
	* A secondary contact for the contractor.
	* A private contact: it's visible only by the users that are also employees of this contractor.
  * Marvin
    * An employee of the contractor
	* A secodary contact for the contractor.
	* A private contact: it's visible only by the users that are also employees of this contractor.
* A management company: This Management company has 1 generic user and 2 employees:
  * Management Co: 
	* A generic user for the management company (not an employee)
	* Allowed to ceate other users in the Management Company role for that unit.
	* 
  * Lawrence:
	* An employee of the management company
	* A secondary contact for the management company.
	* A private contact: it's visible only by the users that are also employees of this management company.
  * Annabelle:
	* An employee of the management company
	* A secondary contact for the management company.
	* A private contact: it's visible only by the users that are also employees of this management company.

#### Every Other batch of units:
After the first batch of unit, we are creating the rest of the units if applicable.

For each unit, the scrip assign one of the users created to one specific role for this unit:
* NO Tenant. 
* NO occupant.This Tenant 
* A Landlord. This Landlord is also the creator and the occupant of the unit. It can be ANY of the users.
* An Agent. This Agent is different from the Landlord and is either:
  * Celeste (or Celeste-n if you have created n batches of users).
  * Jocelyn (or Jocelyn-n if you have created n batches of users).
* A contractor: This contractor has 3 employees/users:
  * Marina: 
	* An employee of the contractor.
    * The main contact for the contractor.
	* A public contact: it's visible by all the other Roles/Stakeholders (Tenant, Agent, etc...)
  * Regina: 
    * An employee of the contractor
	* A secondary contact for the contractor.
	* A private contact: it's visible only by the users that are also employees of this contractor.
  * Marvin
    * An employee of the contractor
	* A secodary contact for the contractor.
	* A private contact: it's visible only by the users that are also employees of this contractor.
* A management company: This Management company has 1 generic user and 2 employees:
  * Management Co: 
	* A generic user for the management company (not an employee)
	* Allowed to ceate other users in the Management Company role for that unit.
	* 
  * Lawrence:
	* An employee of the management company
	* A secondary contact for the management company.
	* A private contact: it's visible only by the users that are also employees of this management company.
  * Annabelle:
	* An employee of the management company
	* A secondary contact for the management company.
	* A private contact: it's visible only by the users that are also employees of this management company.

## Before you run this script:
Open the script and choose a value for the 2 variables:
* iteration_number_of_users: This variable allow you to users in batches of 12 users.
* number_of_units_per_user: This variable defines the minium number of units that each user will have created either 
  * As Tenant and occupant for the first unit
  * As Landlord for all the units after the first units.