# Add new hard drive

## Requirements

- preinstalled cluster with `3-nodes-mirror-3-dc-v2` configuration
- new hard drive /dev/vde on every server
![step0](img/step0.png)

## Steps
1. Update inventory/group_vars/ydb/all.yaml and add new hard drive into `ydb_disks` variable with new label
2. Update files/config.yaml and add new hard drive label in into `config.host_configs` section 
3. Prepare new hard disk for usage `ansible-playbook ydb_platform.ydb.prepare_drives --extra-vars "ydb_disk_prepare=ydb_disk_4"` where ydb_disk_prepare must contains new hard drive label
```
root@static-node-1:/opt/ydb# ls /dev/disk/by-partlabel/
ydb_disk_1  ydb_disk_2  ydb_disk_3  ydb_disk_4
```
4. Update config for every node  `ansible-playbook ydb_platform.ydb.update_config`
![step4](img/step4.png)
5. Check cluster health `ansible-playbook ydb_platform.ydb.healthcheck`
6. Add additional storage groups to a database `ansible-playbook ydb_platform.ydb.run_dstool --extra-vars 'cmd="group add --pool-name /Root/db:ssd --groups 1"'`
![step6](img/step6.png)
