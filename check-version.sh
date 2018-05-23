#!/bin/bash

domain() {
	case $1 in
		prod) echo auroradb.unee-t.com
		;;
		*) echo auroradb.$1.unee-t.com
		;;
	esac
}

for STAGE in demo dev prod
do

ssm() {
	aws --profile uneet-$STAGE ssm get-parameters --names $1 --with-decryption --query Parameters[0].Value --output text
}

echo "# $STAGE"
echo "SELECT * from ut_db_schema_version;" | mysql -h $(domain $STAGE) -P 3306 -u bugzilla --password=$(ssm MYSQL_PASSWORD) bugzilla

done
