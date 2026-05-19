# Stop YDB cluster

## Requirements

- preinstalled cluster with any configuration

## Stop the cluster
```bash
ansible-playbook ydb_platform.ydb.stop_cluster
```

## Start the cluster

To start the cluster after stopping, use:
```bash
ansible-playbook ydb_platform.ydb.start_cluster
```

## Stop a specific host

To stop YDB on a specific host:
```bash
ansible-playbook ydb_platform.ydb.stop_cluster -l static-node-1.ydb-cluster.com
```

## Stop only specific node types

You can stop only specific node types using tags:

- Stop only storage nodes:
  ```bash
  ansible-playbook ydb_platform.ydb.stop_cluster -t storage
  ```

- Stop only dynamic nodes:
  ```bash
  ansible-playbook ydb_platform.ydb.stop_cluster -t dynamic
  ```
