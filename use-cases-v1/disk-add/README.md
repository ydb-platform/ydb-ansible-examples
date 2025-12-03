# Add new hard drive

## Requirements

- preinstalled cluster with `3-nodes-mirror-3-dc` configuration
- new hard drive /dev/vde on every server

## Steps
1. Update inventory/50-inventory.yaml and add new hard drive into `ydb_disks` variable with new label
2. Update files/config.yaml and add new hard drive label in into `host_configs.drives` section 
3. Prepare new hard disk for usage `ansible-playbook ydb_platform.ydb.prepare_drives --extra-vars "ydb_disk_prepare=ydb_disk_4"` where ydb_disk_prepare must contains new hard drive label
4. Update config for every node and restart cluster `ansible-playbook ydb_platform.ydb.update_config`
5. Check cluster health `ansible-playbook ydb_platform.ydb.healthcheck`
6. Provide permission to use new drives `ansible-playbook ydb_platform.ydb.update_config --extra-vars "ydb_storage_update_config=true" --tag storage --skip-tags restart`
![step6](img/step6.png)
7. Add additional storage groups to a database `ansible-playbook ydb_platform.ydb.run_ydbd --extra-vars 'cmd="admin database /Root/database pools add ssd:1"`
![step7](img/step7.png)
