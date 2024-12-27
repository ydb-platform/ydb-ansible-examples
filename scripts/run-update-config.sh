#! /bin/sh

BACKUP_LABEL=`date '+%Y-%m-%d_%H-%M-%S'`
ansible-playbook -b  -f 20 ydb_platform.ydb.update_config --extra-vars "ydb_config_backup=${BACKUP_LABEL}"
