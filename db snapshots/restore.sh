#!/bin/bash


#INSERT INTO `user_api_keys` (`user_id`, `api_key`, `description`, `revoked`, `last_used`)
#VALUES ('1', '$SECRET', NULL, '0', NULL);

export PASSWORD=$(aws --profile uneet-dev ssm get-parameters --names unee_t_root-Password --with-decryption --query Parameters[0].Value --output text)
mysql -h auroradb.dev.unee-t.com -P 3306 -u unee_t_root --password=$PASSWORD bugzilla  < unee-t_BZDb_clean_current.sql

export MYSQL_ROOT_PASSWORD=$(aws --profile uneet-dev ssm get-parameters --names MYSQL_ROOT_PASSWORD --with-decryption --query Parameters[0].Value --output text)

echo "select count(*) from user_api_keys" | mysql -h auroradb.dev.unee-t.com -P 3306 -u root --password=$MYSQL_ROOT_PASSWORD bugzilla
mysql -h auroradb.dev.unee-t.com -P 3306 -u root --password=$MYSQL_ROOT_PASSWORD bugzilla << EOF
INSERT INTO user_api_keys (user_id, api_key) VALUES (1, "$(aws --profile uneet-dev ssm get-parameters --names BUGZILLA_ADMIN_KEY --with-decryption --query Parameters[0].Value --output text)");
EOF



