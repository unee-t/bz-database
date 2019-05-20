/*View structure for view count_cases_per_users_per_month */

DROP TABLE IF EXISTS `count_cases_per_users_per_month` ;
DROP VIEW IF EXISTS `count_cases_per_users_per_month` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_cases_per_users_per_month` AS select year(`bugs`.`creation_ts`) AS `year`,month(`bugs`.`creation_ts`) AS `month`,`bugs`.`reporter` AS `reporter`,count(`bugs`.`bug_id`) AS `bugs_created` from `bugs` group by `bugs`.`reporter`,year(`bugs`.`creation_ts`),month(`bugs`.`creation_ts`) order by year(`bugs`.`creation_ts`) desc,month(`bugs`.`creation_ts`) desc,count(`bugs`.`bug_id`) desc ;

/*View structure for view count_cases_per_users_per_week */

DROP TABLE IF EXISTS `count_cases_per_users_per_week` ;
DROP VIEW IF EXISTS `count_cases_per_users_per_week` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_cases_per_users_per_week` AS select year(`bugs`.`creation_ts`) AS `year`,month(`bugs`.`creation_ts`) AS `month`,week(`bugs`.`creation_ts`,0) AS `week`,`bugs`.`reporter` AS `reporter`,count(`bugs`.`bug_id`) AS `bugs_created` from `bugs` group by `bugs`.`reporter`,year(`bugs`.`creation_ts`),month(`bugs`.`creation_ts`),week(`bugs`.`creation_ts`,0) order by year(`bugs`.`creation_ts`) desc,month(`bugs`.`creation_ts`) desc,week(`bugs`.`creation_ts`,0) desc,count(`bugs`.`bug_id`) desc ;

/*View structure for view count_cases_with_messages_per_month */

DROP TABLE IF EXISTS `count_cases_with_messages_per_month` ;
DROP VIEW IF EXISTS `count_cases_with_messages_per_month` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_cases_with_messages_per_month` AS select `count_messages_per_case_per_month`.`year` AS `year`,`count_messages_per_case_per_month`.`month` AS `month`,count(`count_messages_per_case_per_month`.`case_id`) AS `count_cases_with_messages` from `count_messages_per_case_per_month` group by `count_messages_per_case_per_month`.`month`,`count_messages_per_case_per_month`.`year` order by `count_messages_per_case_per_month`.`year` desc,`count_messages_per_case_per_month`.`month` desc ;

/*View structure for view count_cases_with_messages_per_week */

DROP TABLE IF EXISTS `count_cases_with_messages_per_week` ;
DROP VIEW IF EXISTS `count_cases_with_messages_per_week` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_cases_with_messages_per_week` AS select `count_messages_per_case_per_week`.`year` AS `year`,`count_messages_per_case_per_week`.`month` AS `month`,`count_messages_per_case_per_week`.`week` AS `week`,count(`count_messages_per_case_per_week`.`case_id`) AS `count_cases_with_messages` from `count_messages_per_case_per_week` group by `count_messages_per_case_per_week`.`year`,`count_messages_per_case_per_week`.`month`,`count_messages_per_case_per_week`.`week` order by `count_messages_per_case_per_week`.`year` desc,`count_messages_per_case_per_week`.`week` desc ;

/*View structure for view count_invitation_per_invitee_per_month */

DROP TABLE IF EXISTS `count_invitation_per_invitee_per_month` ;
DROP VIEW IF EXISTS `count_invitation_per_invitee_per_month` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_invitation_per_invitee_per_month` AS select year(`ut_invitation_api_data`.`processed_datetime`) AS `year`,month(`ut_invitation_api_data`.`processed_datetime`) AS `month`,`ut_invitation_api_data`.`bz_user_id` AS `invitee_bz_user_id`,count(`ut_invitation_api_data`.`id`) AS `invitation_sent` from `ut_invitation_api_data` group by `ut_invitation_api_data`.`bz_user_id`,month(`ut_invitation_api_data`.`processed_datetime`),year(`ut_invitation_api_data`.`processed_datetime`) order by year(`ut_invitation_api_data`.`processed_datetime`) desc,month(`ut_invitation_api_data`.`processed_datetime`) desc,count(`ut_invitation_api_data`.`id`) desc ;

/*View structure for view count_invitation_per_invitee_per_week */

DROP TABLE IF EXISTS `count_invitation_per_invitee_per_week` ;
DROP VIEW IF EXISTS `count_invitation_per_invitee_per_week` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_invitation_per_invitee_per_week` AS select year(`ut_invitation_api_data`.`processed_datetime`) AS `year`,month(`ut_invitation_api_data`.`processed_datetime`) AS `month`,week(`ut_invitation_api_data`.`processed_datetime`,0) AS `week`,`ut_invitation_api_data`.`bz_user_id` AS `invitee_bz_user_id`,count(`ut_invitation_api_data`.`id`) AS `invitation_sent` from `ut_invitation_api_data` group by `ut_invitation_api_data`.`bz_user_id`,year(`ut_invitation_api_data`.`processed_datetime`),month(`ut_invitation_api_data`.`processed_datetime`),week(`ut_invitation_api_data`.`processed_datetime`,0) order by year(`ut_invitation_api_data`.`processed_datetime`) desc,week(`ut_invitation_api_data`.`processed_datetime`,0) desc,count(`ut_invitation_api_data`.`id`) desc ;

/*View structure for view count_invitation_per_invitor_per_month */

DROP TABLE IF EXISTS `count_invitation_per_invitor_per_month` ;
DROP VIEW IF EXISTS `count_invitation_per_invitor_per_month` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_invitation_per_invitor_per_month` AS select year(`ut_invitation_api_data`.`processed_datetime`) AS `year`,month(`ut_invitation_api_data`.`processed_datetime`) AS `month`,`ut_invitation_api_data`.`bzfe_invitor_user_id` AS `invitor_bz_user_id`,count(`ut_invitation_api_data`.`id`) AS `invitation_sent` from `ut_invitation_api_data` group by `ut_invitation_api_data`.`bzfe_invitor_user_id`,month(`ut_invitation_api_data`.`processed_datetime`),year(`ut_invitation_api_data`.`processed_datetime`) order by year(`ut_invitation_api_data`.`processed_datetime`) desc,month(`ut_invitation_api_data`.`processed_datetime`) desc,count(`ut_invitation_api_data`.`id`) desc ;

/*View structure for view count_invitation_per_invitor_per_week */

DROP TABLE IF EXISTS `count_invitation_per_invitor_per_week` ;
DROP VIEW IF EXISTS `count_invitation_per_invitor_per_week` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_invitation_per_invitor_per_week` AS select year(`ut_invitation_api_data`.`processed_datetime`) AS `year`,month(`ut_invitation_api_data`.`processed_datetime`) AS `month`,week(`ut_invitation_api_data`.`processed_datetime`,0) AS `week`,`ut_invitation_api_data`.`bzfe_invitor_user_id` AS `invitor_bz_user_id`,count(`ut_invitation_api_data`.`id`) AS `invitation_sent` from `ut_invitation_api_data` group by `ut_invitation_api_data`.`bzfe_invitor_user_id`,year(`ut_invitation_api_data`.`processed_datetime`),month(`ut_invitation_api_data`.`processed_datetime`),week(`ut_invitation_api_data`.`processed_datetime`,0) order by year(`ut_invitation_api_data`.`processed_datetime`) desc,week(`ut_invitation_api_data`.`processed_datetime`,0) desc,count(`ut_invitation_api_data`.`id`) desc ;

/*View structure for view count_invitation_sent_per_month */

DROP TABLE IF EXISTS `count_invitation_sent_per_month` ;
DROP VIEW IF EXISTS `count_invitation_sent_per_month` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_invitation_sent_per_month` AS select year(`ut_invitation_api_data`.`processed_datetime`) AS `year`,month(`ut_invitation_api_data`.`processed_datetime`) AS `month`,count(`ut_invitation_api_data`.`id`) AS `invitation_sent` from `ut_invitation_api_data` group by year(`ut_invitation_api_data`.`processed_datetime`),month(`ut_invitation_api_data`.`processed_datetime`) order by year(`ut_invitation_api_data`.`processed_datetime`) desc,month(`ut_invitation_api_data`.`processed_datetime`) desc ;

/*View structure for view count_invitation_sent_per_unit_per_month */

DROP TABLE IF EXISTS `count_invitation_sent_per_unit_per_month` ;
DROP VIEW IF EXISTS `count_invitation_sent_per_unit_per_month` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_invitation_sent_per_unit_per_month` AS select year(`ut_invitation_api_data`.`processed_datetime`) AS `year`,month(`ut_invitation_api_data`.`processed_datetime`) AS `month`,`ut_invitation_api_data`.`bz_unit_id` AS `bz_unit_id`,count(`ut_invitation_api_data`.`id`) AS `invitation_sent` from `ut_invitation_api_data` group by year(`ut_invitation_api_data`.`processed_datetime`),month(`ut_invitation_api_data`.`processed_datetime`),`ut_invitation_api_data`.`bz_unit_id` order by year(`ut_invitation_api_data`.`processed_datetime`) desc,month(`ut_invitation_api_data`.`processed_datetime`) desc,count(`ut_invitation_api_data`.`id`) desc ;

/*View structure for view count_invitation_sent_per_unit_per_week */

DROP TABLE IF EXISTS `count_invitation_sent_per_unit_per_week` ;
DROP VIEW IF EXISTS `count_invitation_sent_per_unit_per_week` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_invitation_sent_per_unit_per_week` AS select year(`ut_invitation_api_data`.`processed_datetime`) AS `year`,month(`ut_invitation_api_data`.`processed_datetime`) AS `month`,week(`ut_invitation_api_data`.`processed_datetime`,0) AS `week`,`ut_invitation_api_data`.`bz_unit_id` AS `bz_unit_id`,count(`ut_invitation_api_data`.`id`) AS `invitation_sent` from `ut_invitation_api_data` group by year(`ut_invitation_api_data`.`processed_datetime`),month(`ut_invitation_api_data`.`processed_datetime`),week(`ut_invitation_api_data`.`processed_datetime`,0),`ut_invitation_api_data`.`bz_unit_id` order by year(`ut_invitation_api_data`.`processed_datetime`) desc,month(`ut_invitation_api_data`.`processed_datetime`) desc,week(`ut_invitation_api_data`.`processed_datetime`,0) desc,count(`ut_invitation_api_data`.`id`) desc ;

/*View structure for view count_invitation_sent_per_week */

DROP TABLE IF EXISTS `count_invitation_sent_per_week` ;
DROP VIEW IF EXISTS `count_invitation_sent_per_week` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_invitation_sent_per_week` AS select year(`ut_invitation_api_data`.`processed_datetime`) AS `year`,month(`ut_invitation_api_data`.`processed_datetime`) AS `month`,week(`ut_invitation_api_data`.`processed_datetime`,0) AS `week`,count(`ut_invitation_api_data`.`id`) AS `invitation_sent` from `ut_invitation_api_data` group by year(`ut_invitation_api_data`.`processed_datetime`),month(`ut_invitation_api_data`.`processed_datetime`) desc,week(`ut_invitation_api_data`.`processed_datetime`,0) order by year(`ut_invitation_api_data`.`processed_datetime`) desc,week(`ut_invitation_api_data`.`processed_datetime`,0) desc ;

/*View structure for view count_invites_per_month */

DROP TABLE IF EXISTS `count_invites_per_month` ;
DROP VIEW IF EXISTS `count_invites_per_month` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_invites_per_month` AS select `count_invites_per_unit_per_role_per_month`.`year` AS `year`,`count_invites_per_unit_per_role_per_month`.`month` AS `month`,count(`count_invites_per_unit_per_role_per_month`.`invitation_sent`) AS `count_invites` from `count_invites_per_unit_per_role_per_month` group by `count_invites_per_unit_per_role_per_month`.`month`,`count_invites_per_unit_per_role_per_month`.`year` order by `count_invites_per_unit_per_role_per_month`.`year` desc,`count_invites_per_unit_per_role_per_month`.`month` desc ;

/*View structure for view count_invites_per_role_per_month */

DROP TABLE IF EXISTS `count_invites_per_role_per_month` ;
DROP VIEW IF EXISTS `count_invites_per_role_per_month` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_invites_per_role_per_month` AS select `count_invites_per_unit_per_role_per_month`.`year` AS `year`,`count_invites_per_unit_per_role_per_month`.`month` AS `month`,`count_invites_per_unit_per_role_per_month`.`user_role_type_id` AS `user_role_type_id`,count(`count_invites_per_unit_per_role_per_month`.`invitation_sent`) AS `count_invites` from `count_invites_per_unit_per_role_per_month` group by `count_invites_per_unit_per_role_per_month`.`month`,`count_invites_per_unit_per_role_per_month`.`year`,`count_invites_per_unit_per_role_per_month`.`user_role_type_id` order by `count_invites_per_unit_per_role_per_month`.`year` desc,`count_invites_per_unit_per_role_per_month`.`month` desc,`count_invites_per_unit_per_role_per_month`.`user_role_type_id` ;

/*View structure for view count_invites_per_unit_per_month */

DROP TABLE IF EXISTS `count_invites_per_unit_per_month` ;
DROP VIEW IF EXISTS `count_invites_per_unit_per_month` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_invites_per_unit_per_month` AS select `count_invites_per_unit_per_role_per_month`.`year` AS `year`,`count_invites_per_unit_per_role_per_month`.`month` AS `month`,`count_invites_per_unit_per_role_per_month`.`bz_unit_id` AS `bz_unit_id`,count(`count_invites_per_unit_per_role_per_month`.`invitation_sent`) AS `count_invites` from `count_invites_per_unit_per_role_per_month` group by `count_invites_per_unit_per_role_per_month`.`month`,`count_invites_per_unit_per_role_per_month`.`year`,`count_invites_per_unit_per_role_per_month`.`bz_unit_id` order by `count_invites_per_unit_per_role_per_month`.`year` desc,`count_invites_per_unit_per_role_per_month`.`month` desc,`count_invites_per_unit_per_role_per_month`.`bz_unit_id` ;

/*View structure for view count_invites_per_unit_per_role_per_month */

DROP TABLE IF EXISTS `count_invites_per_unit_per_role_per_month` ;
DROP VIEW IF EXISTS `count_invites_per_unit_per_role_per_month` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_invites_per_unit_per_role_per_month` AS select year(`ut_invitation_api_data`.`processed_datetime`) AS `year`,month(`ut_invitation_api_data`.`processed_datetime`) AS `month`,`ut_invitation_api_data`.`bz_unit_id` AS `bz_unit_id`,`ut_invitation_api_data`.`user_role_type_id` AS `user_role_type_id`,count(`ut_invitation_api_data`.`id`) AS `invitation_sent` from `ut_invitation_api_data` group by `ut_invitation_api_data`.`bz_user_id`,month(`ut_invitation_api_data`.`processed_datetime`),year(`ut_invitation_api_data`.`processed_datetime`),`ut_invitation_api_data`.`bz_unit_id`,`ut_invitation_api_data`.`user_role_type_id` order by year(`ut_invitation_api_data`.`processed_datetime`) desc,month(`ut_invitation_api_data`.`processed_datetime`) desc,`ut_invitation_api_data`.`user_role_type_id`,`ut_invitation_api_data`.`bz_unit_id`,count(`ut_invitation_api_data`.`id`) desc ;

/*View structure for view count_invites_per_user_per_month */

DROP TABLE IF EXISTS `count_invites_per_user_per_month` ;
DROP VIEW IF EXISTS `count_invites_per_user_per_month` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_invites_per_user_per_month` AS select year(`ut_invitation_api_data`.`processed_datetime`) AS `year`,month(`ut_invitation_api_data`.`processed_datetime`) AS `month`,`ut_invitation_api_data`.`bzfe_invitor_user_id` AS `invitor`,count(`ut_invitation_api_data`.`id`) AS `invitation_sent` from `ut_invitation_api_data` group by year(`ut_invitation_api_data`.`processed_datetime`),month(`ut_invitation_api_data`.`processed_datetime`),`ut_invitation_api_data`.`bzfe_invitor_user_id` order by year(`ut_invitation_api_data`.`processed_datetime`) desc,month(`ut_invitation_api_data`.`processed_datetime`) desc,count(`ut_invitation_api_data`.`id`) desc ;

/*View structure for view count_invites_per_user_per_week */

DROP TABLE IF EXISTS `count_invites_per_user_per_week` ;
DROP VIEW IF EXISTS `count_invites_per_user_per_week` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_invites_per_user_per_week` AS select year(`ut_invitation_api_data`.`processed_datetime`) AS `year`,month(`ut_invitation_api_data`.`processed_datetime`) AS `month`,week(`ut_invitation_api_data`.`processed_datetime`,0) AS `week`,`ut_invitation_api_data`.`bzfe_invitor_user_id` AS `invitor`,count(`ut_invitation_api_data`.`id`) AS `invitation_sent` from `ut_invitation_api_data` group by year(`ut_invitation_api_data`.`processed_datetime`),month(`ut_invitation_api_data`.`processed_datetime`),week(`ut_invitation_api_data`.`processed_datetime`,0),`ut_invitation_api_data`.`bzfe_invitor_user_id` order by year(`ut_invitation_api_data`.`processed_datetime`) desc,month(`ut_invitation_api_data`.`processed_datetime`) desc,week(`ut_invitation_api_data`.`processed_datetime`,0) desc,count(`ut_invitation_api_data`.`id`) desc ;

/*View structure for view count_messages_per_case_per_month */

DROP TABLE IF EXISTS `count_messages_per_case_per_month` ;
DROP VIEW IF EXISTS `count_messages_per_case_per_month` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_messages_per_case_per_month` AS select year(`longdescs`.`bug_when`) AS `year`,month(`longdescs`.`bug_when`) AS `month`,`longdescs`.`bug_id` AS `case_id`,count(`longdescs`.`comment_id`) AS `count_messages` from `longdescs` group by year(`longdescs`.`bug_when`),month(`longdescs`.`bug_when`),`longdescs`.`bug_id` order by year(`longdescs`.`bug_when`) desc,month(`longdescs`.`bug_when`) desc,count(`longdescs`.`comment_id`) desc,`longdescs`.`bug_id` desc ;

/*View structure for view count_messages_per_case_per_week */

DROP TABLE IF EXISTS `count_messages_per_case_per_week` ;
DROP VIEW IF EXISTS `count_messages_per_case_per_week` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_messages_per_case_per_week` AS select year(`longdescs`.`bug_when`) AS `year`,month(`longdescs`.`bug_when`) AS `month`,week(`longdescs`.`bug_when`,0) AS `week`,`longdescs`.`bug_id` AS `case_id`,count(`longdescs`.`comment_id`) AS `count_messages` from `longdescs` group by year(`longdescs`.`bug_when`),week(`longdescs`.`bug_when`,0),`longdescs`.`bug_id` order by year(`longdescs`.`bug_when`) desc,week(`longdescs`.`bug_when`,0) desc,count(`longdescs`.`comment_id`) desc,`longdescs`.`bug_id` desc ;

/*View structure for view count_messages_per_unit_per_month */

DROP TABLE IF EXISTS `count_messages_per_unit_per_month` ;
DROP VIEW IF EXISTS `count_messages_per_unit_per_month` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_messages_per_unit_per_month` AS select year(`longdescs`.`bug_when`) AS `year`,month(`longdescs`.`bug_when`) AS `month`,`bugs`.`product_id` AS `bz_unit_id`,count(`longdescs`.`comment_id`) AS `count_messages` from (`longdescs` join `bugs` on((`longdescs`.`bug_id` = `bugs`.`bug_id`))) group by year(`longdescs`.`bug_when`),month(`longdescs`.`bug_when`),`bugs`.`product_id` order by year(`longdescs`.`bug_when`) desc,month(`longdescs`.`bug_when`) desc,count(`longdescs`.`comment_id`) desc,`bugs`.`product_id` desc ;

/*View structure for view count_messages_per_unit_per_week */

DROP TABLE IF EXISTS `count_messages_per_unit_per_week` ;
DROP VIEW IF EXISTS `count_messages_per_unit_per_week` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_messages_per_unit_per_week` AS select year(`longdescs`.`bug_when`) AS `year`,month(`longdescs`.`bug_when`) AS `month`,week(`longdescs`.`bug_when`,0) AS `week`,`bugs`.`product_id` AS `bz_unit_id`,count(`longdescs`.`comment_id`) AS `count_messages` from (`longdescs` join `bugs` on((`longdescs`.`bug_id` = `bugs`.`bug_id`))) group by year(`longdescs`.`bug_when`),week(`longdescs`.`bug_when`,0),`bugs`.`product_id` order by year(`longdescs`.`bug_when`) desc,week(`longdescs`.`bug_when`,0) desc,count(`longdescs`.`comment_id`) desc,`bugs`.`product_id` desc ;

/*View structure for view count_messages_per_users_per_month */

DROP TABLE IF EXISTS `count_messages_per_users_per_month` ;
DROP VIEW IF EXISTS `count_messages_per_users_per_month` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_messages_per_users_per_month` AS select year(`longdescs`.`bug_when`) AS `year`,month(`longdescs`.`bug_when`) AS `month`,`longdescs`.`who` AS `who`,count(`longdescs`.`comment_id`) AS `count_messages` from `longdescs` group by `longdescs`.`who`,year(`longdescs`.`bug_when`),month(`longdescs`.`bug_when`) order by year(`longdescs`.`bug_when`) desc,month(`longdescs`.`bug_when`) desc,count(`longdescs`.`comment_id`) desc ;

/*View structure for view count_messages_per_users_per_week */

DROP TABLE IF EXISTS `count_messages_per_users_per_week` ;
DROP VIEW IF EXISTS `count_messages_per_users_per_week` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_messages_per_users_per_week` AS select year(`longdescs`.`bug_when`) AS `year`,month(`longdescs`.`bug_when`) AS `month`,week(`longdescs`.`bug_when`,0) AS `week`,`longdescs`.`who` AS `who`,count(`longdescs`.`comment_id`) AS `count_messages` from `longdescs` group by `longdescs`.`who`,year(`longdescs`.`bug_when`),month(`longdescs`.`bug_when`),week(`longdescs`.`bug_when`,0) order by year(`longdescs`.`bug_when`) desc,month(`longdescs`.`bug_when`) desc,week(`longdescs`.`bug_when`,0) desc,count(`longdescs`.`comment_id`) desc ;

/*View structure for view count_new_cases_created_per_month */

DROP TABLE IF EXISTS `count_new_cases_created_per_month` ;
DROP VIEW IF EXISTS `count_new_cases_created_per_month` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_new_cases_created_per_month` AS select year(`bugs`.`creation_ts`) AS `year`,month(`bugs`.`creation_ts`) AS `month`,count(`bugs`.`bug_id`) AS `count_cases` from `bugs` group by year(`bugs`.`creation_ts`),month(`bugs`.`creation_ts`) order by `bugs`.`creation_ts` desc ;

/*View structure for view count_new_cases_created_per_week */

DROP TABLE IF EXISTS `count_new_cases_created_per_week` ;
DROP VIEW IF EXISTS `count_new_cases_created_per_week` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_new_cases_created_per_week` AS select year(`bugs`.`creation_ts`) AS `year`,month(`bugs`.`creation_ts`) AS `month`,week(`bugs`.`creation_ts`,0) AS `week`,count(`bugs`.`bug_id`) AS `count_cases_created` from `bugs` group by year(`bugs`.`creation_ts`),month(`bugs`.`creation_ts`),week(`bugs`.`creation_ts`,0) order by `bugs`.`creation_ts` desc ;

/*View structure for view count_new_geographies_created_per_month */

DROP TABLE IF EXISTS `count_new_geographies_created_per_month` ;
DROP VIEW IF EXISTS `count_new_geographies_created_per_month` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_new_geographies_created_per_month` AS select year(`audit_log`.`at_time`) AS `year`,month(`audit_log`.`at_time`) AS `month`,count(`audit_log`.`object_id`) AS `new_geography` from `audit_log` where ((`audit_log`.`class` = 'Bugzilla::Classification') and (`audit_log`.`field` = '__create__')) group by year(`audit_log`.`at_time`),month(`audit_log`.`at_time`) order by `audit_log`.`at_time` desc ;

/*View structure for view count_new_messages_created_per_month */

DROP TABLE IF EXISTS `count_new_messages_created_per_month` ;
DROP VIEW IF EXISTS `count_new_messages_created_per_month` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_new_messages_created_per_month` AS select year(`longdescs`.`bug_when`) AS `year`,month(`longdescs`.`bug_when`) AS `month`,count(`longdescs`.`comment_id`) AS `count_messages_created` from `longdescs` group by year(`longdescs`.`bug_when`),month(`longdescs`.`bug_when`) order by year(`longdescs`.`bug_when`) desc,month(`longdescs`.`bug_when`) desc ;

/*View structure for view count_new_messages_created_per_week */

DROP TABLE IF EXISTS `count_new_messages_created_per_week` ;
DROP VIEW IF EXISTS `count_new_messages_created_per_week` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_new_messages_created_per_week` AS select year(`longdescs`.`bug_when`) AS `year`,month(`longdescs`.`bug_when`) AS `month`,week(`longdescs`.`bug_when`,0) AS `week`,count(`longdescs`.`comment_id`) AS `count_messages_created` from `longdescs` group by year(`longdescs`.`bug_when`),month(`longdescs`.`bug_when`),week(`longdescs`.`bug_when`,0) order by year(`longdescs`.`bug_when`) desc,month(`longdescs`.`bug_when`) desc,week(`longdescs`.`bug_when`,0) desc ;

/*View structure for view count_new_unit_created_per_month */

DROP TABLE IF EXISTS `count_new_unit_created_per_month` ;
DROP VIEW IF EXISTS `count_new_unit_created_per_month` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_new_unit_created_per_month` AS select year(`audit_log`.`at_time`) AS `year`,month(`audit_log`.`at_time`) AS `month`,count(`audit_log`.`object_id`) AS `new_unit` from `audit_log` where ((`audit_log`.`class` = 'Bugzilla::Product') and (`audit_log`.`field` = '__create__')) group by year(`audit_log`.`at_time`),month(`audit_log`.`at_time`) order by `audit_log`.`at_time` desc ;

/*View structure for view count_new_unit_created_per_week */

DROP TABLE IF EXISTS `count_new_unit_created_per_week` ;
DROP VIEW IF EXISTS `count_new_unit_created_per_week` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_new_unit_created_per_week` AS select year(`audit_log`.`at_time`) AS `year`,month(`audit_log`.`at_time`) AS `month`,week(`audit_log`.`at_time`,0) AS `week`,count(`audit_log`.`object_id`) AS `count_new_units` from `audit_log` where ((`audit_log`.`class` = 'Bugzilla::Product') and (`audit_log`.`field` = '__create__')) group by year(`audit_log`.`at_time`),month(`audit_log`.`at_time`),week(`audit_log`.`at_time`,0) order by year(`audit_log`.`at_time`) desc,month(`audit_log`.`at_time`) desc,week(`audit_log`.`at_time`,0) desc,count(`audit_log`.`object_id`) desc ;

/*View structure for view count_new_user_created_per_month */

DROP TABLE IF EXISTS `count_new_user_created_per_month` ;
DROP VIEW IF EXISTS `count_new_user_created_per_month` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_new_user_created_per_month` AS select year(`audit_log`.`at_time`) AS `year`,month(`audit_log`.`at_time`) AS `month`,count(`audit_log`.`object_id`) AS `new_users` from `audit_log` where ((`audit_log`.`class` = 'Bugzilla::User') and (`audit_log`.`field` = '__create__')) group by year(`audit_log`.`at_time`),month(`audit_log`.`at_time`) order by `audit_log`.`at_time` desc ;

/*View structure for view count_new_user_created_per_week */

DROP TABLE IF EXISTS `count_new_user_created_per_week` ;
DROP VIEW IF EXISTS `count_new_user_created_per_week` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_new_user_created_per_week` AS select year(`audit_log`.`at_time`) AS `year`,month(`audit_log`.`at_time`) AS `month`,week(`audit_log`.`at_time`,0) AS `week`,count(`audit_log`.`object_id`) AS `new_users` from `audit_log` where ((`audit_log`.`class` = 'Bugzilla::User') and (`audit_log`.`field` = '__create__')) group by year(`audit_log`.`at_time`),week(`audit_log`.`at_time`,0) order by year(`audit_log`.`at_time`) desc,month(`audit_log`.`at_time`) desc,week(`audit_log`.`at_time`,0) desc ;

/*View structure for view count_unit_created_per_users_per_month */

DROP TABLE IF EXISTS `count_unit_created_per_users_per_month` ;
DROP VIEW IF EXISTS `count_unit_created_per_users_per_month` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_unit_created_per_users_per_month` AS select year(`audit_log`.`at_time`) AS `year`,month(`audit_log`.`at_time`) AS `month`,`audit_log`.`user_id` AS `user_id`,count(`audit_log`.`object_id`) AS `count_new_units` from `audit_log` where ((`audit_log`.`class` = 'Bugzilla::Product') and (`audit_log`.`field` = '__create__')) group by `audit_log`.`user_id`,year(`audit_log`.`at_time`),month(`audit_log`.`at_time`) order by year(`audit_log`.`at_time`) desc,month(`audit_log`.`at_time`) desc,count(`audit_log`.`object_id`) desc ;

/*View structure for view count_unit_created_per_users_per_week */

DROP TABLE IF EXISTS `count_unit_created_per_users_per_week` ;
DROP VIEW IF EXISTS `count_unit_created_per_users_per_week` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_unit_created_per_users_per_week` AS select year(`audit_log`.`at_time`) AS `year`,month(`audit_log`.`at_time`) AS `month`,week(`audit_log`.`at_time`,0) AS `week`,`audit_log`.`user_id` AS `user_id`,count(`audit_log`.`object_id`) AS `count_new_units` from `audit_log` where ((`audit_log`.`class` = 'Bugzilla::Product') and (`audit_log`.`field` = '__create__')) group by `audit_log`.`user_id`,year(`audit_log`.`at_time`),month(`audit_log`.`at_time`),week(`audit_log`.`at_time`,0) order by year(`audit_log`.`at_time`) desc,month(`audit_log`.`at_time`) desc,week(`audit_log`.`at_time`,0) desc,count(`audit_log`.`object_id`) desc ;

/*View structure for view count_units_enabled_and_total_per_month */

DROP TABLE IF EXISTS `count_units_enabled_and_total_per_month` ;
DROP VIEW IF EXISTS `count_units_enabled_and_total_per_month` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_units_enabled_and_total_per_month` AS select year(`ut_log_count_enabled_units`.`timestamp`) AS `year`,month(`ut_log_count_enabled_units`.`timestamp`) AS `month`,avg(`ut_log_count_enabled_units`.`count_enabled_units`) AS `average_enabled_units`,avg(`ut_log_count_enabled_units`.`count_total_units`) AS `average_total_units` from `ut_log_count_enabled_units` group by year(`ut_log_count_enabled_units`.`timestamp`),month(`ut_log_count_enabled_units`.`timestamp`) order by year(`ut_log_count_enabled_units`.`timestamp`) desc,month(`ut_log_count_enabled_units`.`timestamp`) desc ;

/*View structure for view count_units_enabled_and_total_per_week */

DROP TABLE IF EXISTS `count_units_enabled_and_total_per_week` ;
DROP VIEW IF EXISTS `count_units_enabled_and_total_per_week` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_units_enabled_and_total_per_week` AS select year(`ut_log_count_enabled_units`.`timestamp`) AS `year`,month(`ut_log_count_enabled_units`.`timestamp`) AS `month`,week(`ut_log_count_enabled_units`.`timestamp`,0) AS `week`,avg(`ut_log_count_enabled_units`.`count_enabled_units`) AS `average_enabled_units`,avg(`ut_log_count_enabled_units`.`count_total_units`) AS `average_total_units` from `ut_log_count_enabled_units` group by year(`ut_log_count_enabled_units`.`timestamp`),month(`ut_log_count_enabled_units`.`timestamp`),week(`ut_log_count_enabled_units`.`timestamp`,0) order by year(`ut_log_count_enabled_units`.`timestamp`) desc,week(`ut_log_count_enabled_units`.`timestamp`,0) desc ;

/*View structure for view count_units_with_invitation_sent_per_month */

DROP TABLE IF EXISTS `count_units_with_invitation_sent_per_month` ;
DROP VIEW IF EXISTS `count_units_with_invitation_sent_per_month` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_units_with_invitation_sent_per_month` AS select `count_invitation_sent_per_unit_per_month`.`year` AS `year`,`count_invitation_sent_per_unit_per_month`.`month` AS `month`,count(`count_invitation_sent_per_unit_per_month`.`bz_unit_id`) AS `count_units` from `count_invitation_sent_per_unit_per_month` group by `count_invitation_sent_per_unit_per_month`.`month`,`count_invitation_sent_per_unit_per_month`.`year` order by `count_invitation_sent_per_unit_per_month`.`year` desc,`count_invitation_sent_per_unit_per_month`.`month` desc ;

/*View structure for view count_units_with_invitation_sent_per_week */

DROP TABLE IF EXISTS `count_units_with_invitation_sent_per_week` ;
DROP VIEW IF EXISTS `count_units_with_invitation_sent_per_week` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_units_with_invitation_sent_per_week` AS select `count_invitation_sent_per_unit_per_week`.`year` AS `year`,`count_invitation_sent_per_unit_per_week`.`month` AS `month`,`count_invitation_sent_per_unit_per_week`.`week` AS `week`,count(`count_invitation_sent_per_unit_per_week`.`bz_unit_id`) AS `count_units` from `count_invitation_sent_per_unit_per_week` group by `count_invitation_sent_per_unit_per_week`.`year`,`count_invitation_sent_per_unit_per_week`.`month`,`count_invitation_sent_per_unit_per_week`.`week` order by `count_invitation_sent_per_unit_per_week`.`year` desc,`count_invitation_sent_per_unit_per_week`.`month` desc,`count_invitation_sent_per_unit_per_week`.`week` desc ;

/*View structure for view count_units_with_messages_per_month */

DROP TABLE IF EXISTS `count_units_with_messages_per_month` ;
DROP VIEW IF EXISTS `count_units_with_messages_per_month` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_units_with_messages_per_month` AS select `count_messages_per_unit_per_month`.`year` AS `year`,`count_messages_per_unit_per_month`.`month` AS `month`,count(`count_messages_per_unit_per_month`.`bz_unit_id`) AS `count_units_with_messages` from `count_messages_per_unit_per_month` group by `count_messages_per_unit_per_month`.`month`,`count_messages_per_unit_per_month`.`year` order by `count_messages_per_unit_per_month`.`year` desc,`count_messages_per_unit_per_month`.`month` desc ;

/*View structure for view count_units_with_messages_per_week */

DROP TABLE IF EXISTS `count_units_with_messages_per_week` ;
DROP VIEW IF EXISTS `count_units_with_messages_per_week` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_units_with_messages_per_week` AS select `count_messages_per_unit_per_week`.`year` AS `year`,`count_messages_per_unit_per_week`.`month` AS `month`,`count_messages_per_unit_per_week`.`week` AS `week`,count(`count_messages_per_unit_per_week`.`bz_unit_id`) AS `count_units_with_messages` from `count_messages_per_unit_per_week` group by `count_messages_per_unit_per_week`.`year`,`count_messages_per_unit_per_week`.`month`,`count_messages_per_unit_per_week`.`week` order by `count_messages_per_unit_per_week`.`year` desc,`count_messages_per_unit_per_week`.`week` desc ;

/*View structure for view count_users_who_create_case_per_month */

DROP TABLE IF EXISTS `count_users_who_create_case_per_month` ;
DROP VIEW IF EXISTS `count_users_who_create_case_per_month` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_users_who_create_case_per_month` AS select `count_cases_per_users_per_month`.`year` AS `year`,`count_cases_per_users_per_month`.`month` AS `month`,count(`count_cases_per_users_per_month`.`reporter`) AS `count_users_who_create_case` from `count_cases_per_users_per_month` group by `count_cases_per_users_per_month`.`year`,`count_cases_per_users_per_month`.`month` order by `count_cases_per_users_per_month`.`year` desc,`count_cases_per_users_per_month`.`month` desc ;

/*View structure for view count_users_who_create_case_per_week */

DROP TABLE IF EXISTS `count_users_who_create_case_per_week` ;
DROP VIEW IF EXISTS `count_users_who_create_case_per_week` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_users_who_create_case_per_week` AS select `count_cases_per_users_per_week`.`year` AS `year`,`count_cases_per_users_per_week`.`month` AS `month`,`count_cases_per_users_per_week`.`week` AS `week`,count(`count_cases_per_users_per_week`.`reporter`) AS `count_users_who_create_case` from `count_cases_per_users_per_week` group by `count_cases_per_users_per_week`.`year`,`count_cases_per_users_per_week`.`month`,`count_cases_per_users_per_week`.`week` order by `count_cases_per_users_per_week`.`year` desc,`count_cases_per_users_per_week`.`week` desc ;

/*View structure for view count_users_who_create_invites_per_month */

DROP TABLE IF EXISTS `count_users_who_create_invites_per_month` ;
DROP VIEW IF EXISTS `count_users_who_create_invites_per_month` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_users_who_create_invites_per_month` AS select `count_invites_per_user_per_week`.`year` AS `year`,`count_invites_per_user_per_week`.`month` AS `month`,count(`count_invites_per_user_per_week`.`invitor`) AS `count_users_who_created_invites` from `count_invites_per_user_per_week` group by `count_invites_per_user_per_week`.`year`,`count_invites_per_user_per_week`.`month` order by `count_invites_per_user_per_week`.`year` desc,`count_invites_per_user_per_week`.`month` desc ;

/*View structure for view count_users_who_create_invites_per_week */

DROP TABLE IF EXISTS `count_users_who_create_invites_per_week` ;
DROP VIEW IF EXISTS `count_users_who_create_invites_per_week` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_users_who_create_invites_per_week` AS select `count_invites_per_user_per_week`.`year` AS `year`,`count_invites_per_user_per_week`.`month` AS `month`,`count_invites_per_user_per_week`.`week` AS `week`,count(`count_invites_per_user_per_week`.`invitor`) AS `count_users_who_created_invites` from `count_invites_per_user_per_week` group by `count_invites_per_user_per_week`.`year`,`count_invites_per_user_per_week`.`month`,`count_invites_per_user_per_week`.`week` order by `count_invites_per_user_per_week`.`year` desc,`count_invites_per_user_per_week`.`week` desc ;

/*View structure for view count_users_who_create_units_per_month */

DROP TABLE IF EXISTS `count_users_who_create_units_per_month` ;
DROP VIEW IF EXISTS `count_users_who_create_units_per_month` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_users_who_create_units_per_month` AS select `count_unit_created_per_users_per_month`.`year` AS `year`,`count_unit_created_per_users_per_month`.`month` AS `month`,count(`count_unit_created_per_users_per_month`.`user_id`) AS `count_users_who_created_units` from `count_unit_created_per_users_per_month` group by `count_unit_created_per_users_per_month`.`year`,`count_unit_created_per_users_per_month`.`month` order by `count_unit_created_per_users_per_month`.`year` desc,`count_unit_created_per_users_per_month`.`month` desc ;

/*View structure for view count_users_who_create_units_per_week */

DROP TABLE IF EXISTS `count_users_who_create_units_per_week` ;
DROP VIEW IF EXISTS `count_users_who_create_units_per_week` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_users_who_create_units_per_week` AS select `count_unit_created_per_users_per_week`.`year` AS `year`,`count_unit_created_per_users_per_week`.`month` AS `month`,`count_unit_created_per_users_per_week`.`week` AS `week`,count(`count_unit_created_per_users_per_week`.`user_id`) AS `count_users_who_created_units` from `count_unit_created_per_users_per_week` group by `count_unit_created_per_users_per_week`.`year`,`count_unit_created_per_users_per_week`.`month`,`count_unit_created_per_users_per_week`.`week` order by `count_unit_created_per_users_per_week`.`year` desc,`count_unit_created_per_users_per_week`.`week` desc ;

/*View structure for view count_users_who_invited_someone_per_month */

DROP TABLE IF EXISTS `count_users_who_invited_someone_per_month` ;
DROP VIEW IF EXISTS `count_users_who_invited_someone_per_month` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_users_who_invited_someone_per_month` AS select `count_invitation_per_invitor_per_month`.`year` AS `year`,`count_invitation_per_invitor_per_month`.`month` AS `month`,count(`count_invitation_per_invitor_per_month`.`invitor_bz_user_id`) AS `count_invitors` from `count_invitation_per_invitor_per_month` group by `count_invitation_per_invitor_per_month`.`year`,`count_invitation_per_invitor_per_month`.`month` order by `count_invitation_per_invitor_per_month`.`year` desc,`count_invitation_per_invitor_per_month`.`month` desc ;

/*View structure for view count_users_who_invited_someone_per_week */

DROP TABLE IF EXISTS `count_users_who_invited_someone_per_week` ;
DROP VIEW IF EXISTS `count_users_who_invited_someone_per_week` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_users_who_invited_someone_per_week` AS select `count_invitation_per_invitor_per_week`.`year` AS `year`,`count_invitation_per_invitor_per_week`.`month` AS `month`,`count_invitation_per_invitor_per_week`.`week` AS `week`,count(`count_invitation_per_invitor_per_week`.`invitor_bz_user_id`) AS `count_invitors` from `count_invitation_per_invitor_per_week` group by `count_invitation_per_invitor_per_week`.`year`,`count_invitation_per_invitor_per_week`.`month`,`count_invitation_per_invitor_per_week`.`week` order by `count_invitation_per_invitor_per_week`.`year` desc,`count_invitation_per_invitor_per_week`.`week` desc ;

/*View structure for view count_users_who_sent_message_per_month */

DROP TABLE IF EXISTS `count_users_who_sent_message_per_month` ;
DROP VIEW IF EXISTS `count_users_who_sent_message_per_month` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_users_who_sent_message_per_month` AS select `count_messages_per_users_per_month`.`year` AS `year`,`count_messages_per_users_per_month`.`month` AS `month`,count(`count_messages_per_users_per_month`.`who`) AS `count_users_who_sent_messages` from `count_messages_per_users_per_month` group by `count_messages_per_users_per_month`.`year`,`count_messages_per_users_per_month`.`month` order by `count_messages_per_users_per_month`.`year` desc,`count_messages_per_users_per_month`.`month` desc ;

/*View structure for view count_users_who_sent_message_per_week */

DROP TABLE IF EXISTS `count_users_who_sent_message_per_week` ;
DROP VIEW IF EXISTS `count_users_who_sent_message_per_week` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_users_who_sent_message_per_week` AS select `count_messages_per_users_per_week`.`year` AS `year`,`count_messages_per_users_per_week`.`month` AS `month`,`count_messages_per_users_per_week`.`week` AS `week`,count(`count_messages_per_users_per_week`.`who`) AS `count_users_who_sent_messages` from `count_messages_per_users_per_week` group by `count_messages_per_users_per_week`.`year`,`count_messages_per_users_per_week`.`month`,`count_messages_per_users_per_week`.`week` order by `count_messages_per_users_per_week`.`year` desc,`count_messages_per_users_per_week`.`week` desc ;

/*View structure for view count_users_who_were_invited_per_month */

DROP TABLE IF EXISTS `count_users_who_were_invited_per_month` ;
DROP VIEW IF EXISTS `count_users_who_were_invited_per_month` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_users_who_were_invited_per_month` AS select `count_invitation_per_invitee_per_month`.`year` AS `year`,`count_invitation_per_invitee_per_month`.`month` AS `month`,count(`count_invitation_per_invitee_per_month`.`invitee_bz_user_id`) AS `count_invitees` from `count_invitation_per_invitee_per_month` group by `count_invitation_per_invitee_per_month`.`year`,`count_invitation_per_invitee_per_month`.`month` order by `count_invitation_per_invitee_per_month`.`year` desc,`count_invitation_per_invitee_per_month`.`month` desc ;

/*View structure for view count_users_who_were_invited_per_week */

DROP TABLE IF EXISTS `count_users_who_were_invited_per_week` ;
DROP VIEW IF EXISTS `count_users_who_were_invited_per_week` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `count_users_who_were_invited_per_week` AS select `count_invitation_per_invitee_per_week`.`year` AS `year`,`count_invitation_per_invitee_per_week`.`month` AS `month`,`count_invitation_per_invitee_per_week`.`week` AS `week`,count(`count_invitation_per_invitee_per_week`.`invitee_bz_user_id`) AS `count_invitees` from `count_invitation_per_invitee_per_week` group by `count_invitation_per_invitee_per_week`.`year`,`count_invitation_per_invitee_per_week`.`month`,`count_invitation_per_invitee_per_week`.`week` order by `count_invitation_per_invitee_per_week`.`year` desc,`count_invitation_per_invitee_per_week`.`week` desc ;

/*View structure for view flash_count_units_with_real_roles */

DROP TABLE IF EXISTS `flash_count_units_with_real_roles` ;
DROP VIEW IF EXISTS `flash_count_units_with_real_roles` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `flash_count_units_with_real_roles` AS select `list_components_with_real_default_assignee`.`role_type_id` AS `role_type_id`,count(`list_components_with_real_default_assignee`.`product_id`) AS `units_with_real_users`,`list_components_with_real_default_assignee`.`isactive` AS `isactive` from `list_components_with_real_default_assignee` group by `list_components_with_real_default_assignee`.`role_type_id`,`list_components_with_real_default_assignee`.`isactive` order by `list_components_with_real_default_assignee`.`isactive` desc,`list_components_with_real_default_assignee`.`role_type_id` ;

/*View structure for view flash_count_user_per_role_per_unit */

DROP TABLE IF EXISTS `flash_count_user_per_role_per_unit` ;
DROP VIEW IF EXISTS `flash_count_user_per_role_per_unit` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `flash_count_user_per_role_per_unit` AS select `ut_product_group`.`product_id` AS `product_id`,`ut_product_group`.`role_type_id` AS `role_type_id`,count(`profiles`.`userid`) AS `count_users` from ((`user_group_map` join `profiles` on((`user_group_map`.`user_id` = `profiles`.`userid`))) join `ut_product_group` on((`user_group_map`.`group_id` = `ut_product_group`.`group_id`))) where ((`ut_product_group`.`role_type_id` is not null) and (`ut_product_group`.`group_type_id` = 2) and (`user_group_map`.`isbless` = 0)) group by `ut_product_group`.`product_id`,`ut_product_group`.`role_type_id`,`user_group_map`.`group_id` ;

/*View structure for view list_changes_new_assignee_is_real */

DROP TABLE IF EXISTS `list_changes_new_assignee_is_real` ;
DROP VIEW IF EXISTS `list_changes_new_assignee_is_real` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `list_changes_new_assignee_is_real` AS select `ut_product_group`.`product_id` AS `product_id`,`audit_log`.`object_id` AS `component_id`,`audit_log`.`removed` AS `removed`,`audit_log`.`added` AS `added`,`audit_log`.`at_time` AS `at_time`,`ut_product_group`.`role_type_id` AS `role_type_id` from (`audit_log` join `ut_product_group` on((`audit_log`.`object_id` = `ut_product_group`.`component_id`))) where ((`audit_log`.`class` = 'Bugzilla::Component') and (`audit_log`.`field` = 'initialowner') and (`audit_log`.`added` <> 93) and (`audit_log`.`added` <> 91) and (`audit_log`.`added` <> 90) and (`audit_log`.`added` <> 92) and (`audit_log`.`added` <> 89)) group by `audit_log`.`object_id`,`ut_product_group`.`role_type_id` order by `audit_log`.`at_time` desc,`ut_product_group`.`product_id`,`audit_log`.`object_id` ;

/*View structure for view list_components_with_real_default_assignee */

DROP TABLE IF EXISTS `list_components_with_real_default_assignee` ;
DROP VIEW IF EXISTS `list_components_with_real_default_assignee` ;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `list_components_with_real_default_assignee` AS select `ut_product_group`.`product_id` AS `product_id`,`components`.`id` AS `component_id`,`components`.`initialowner` AS `initialowner`,`ut_product_group`.`role_type_id` AS `role_type_id`,`products`.`isactive` AS `isactive` from ((`components` join `ut_product_group` on((`components`.`id` = `ut_product_group`.`component_id`))) join `products` on((`ut_product_group`.`product_id` = `products`.`id`))) where ((`components`.`initialowner` <> 93) and (`components`.`initialowner` <> 91) and (`components`.`initialowner` <> 90) and (`components`.`initialowner` <> 92) and (`components`.`initialowner` <> 89) and (`ut_product_group`.`role_type_id` is not null)) group by `ut_product_group`.`product_id`,`components`.`id`,`ut_product_group`.`role_type_id` order by `ut_product_group`.`product_id`,`components`.`id` ;
