# We alter the database to add an index that speeds up the login process

ALTER TABLE `group_group_map` ADD INDEX `group_group_map_grant_type_member_id` (`member_id`,`grant_type`);