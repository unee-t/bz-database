# IMPORTANT NOTES

## Which database?
Since v3.x of the database schema, we have created dependencies which REQUIRE you to run the BZFE of Unee-T on Amazon Aurora.
This is needed so we can create notifications in a simple and scalable way. 
See [Issue #13](https://github.com/unee-t/frontend/issues/13) for more details about that.

## Minimum requirements:

Database MUST be built upon  MySQL5.7+ or MariaDb 10.2+ so we can use the DB Engine `InnoDB` and File format `Barracuda`

## ROW format:

The Row Format MUST be `Dynamic` (preferred) or `Compressed` 

## Character Set and Collation

For maximum compatibility we use the following:
- Character Set = utf8mb4
- Collation = utf8mb4_unicode_520_ci

See [GH Issue #110](https://github.com/unee-t/bz-database/issues/110) for more context.

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
