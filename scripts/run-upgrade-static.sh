#! /bin/sh

ansible-playbook -b -f 20 ydb_platform.ydb.upgrade_static
