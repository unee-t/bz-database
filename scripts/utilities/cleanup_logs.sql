# This script delete log records that are older than 3 months in the Unee-T BZ database

	DELETE FROM `ut_audit_log` 
		WHERE `datetime` < DATE_SUB(NOW(), INTERVAL 3 MONTH)
		;

	DELETE FROM `ut_script_log` 
		WHERE `datetime` < DATE_SUB(NOW(), INTERVAL 3 MONTH)
		;