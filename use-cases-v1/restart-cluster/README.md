# Restart YDB cluster

## Requirements

- preinstalled cluster with any configuration

## Restart the cluster with rolling restart:
   ```bash
   ansible-playbook ydb_platform.ydb.restart
   ```

## Restart specific host

To restart YDB on a specific host:
```bash
ansible-playbook ydb_platform.ydb.restart -l static-node-1.ydb-cluster.com
```

## Restart only specific node types

- Rolling restart for storage nodes only:
  ```bash
  ansible-playbook ydb_platform.ydb.rolling_restart_static
  ```

- Rolling restart for dynamic nodes only:
  ```bash
  ansible-playbook ydb_platform.ydb.rolling_restart_dynamic
  ```

## Rolling restart with custom serial

Control how many nodes are restarted simultaneously:
```bash
ansible-playbook ydb_platform.ydb.restart --extra-vars "ydb_restart_serial=2"
```
