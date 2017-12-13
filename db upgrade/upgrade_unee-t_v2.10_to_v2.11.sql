# In this upgrade, we are creating a table to make it easier to create Demo users.

	/*Table structure for table `ut_user_group_map_temp` */

	DROP TABLE IF EXISTS `ut_user_group_map_temp`;

	CREATE TABLE `ut_user_group_map_temp` (
	  `user_id` mediumint(9) NOT NULL,
	  `group_id` mediumint(9) NOT NULL,
	  `isbless` tinyint(4) NOT NULL DEFAULT 0,
	  `grant_type` tinyint(4) NOT NULL DEFAULT 0
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;
