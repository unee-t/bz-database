#!/bin/bash

export PASSWORD=$(aws --profile uneet-dev ssm get-parameters --names unee_t_root-Password --with-decryption --query Parameters[0].Value --output text)
mysql -h auroradb.dev.unee-t.com -P 3306 -u unee_t_root --password=$PASSWORD bugzilla  < unee-t_BZDb_clean_current.sql
