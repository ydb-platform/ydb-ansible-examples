To switch the documentation language to Russian, follow this [link](./README-RU.md).
<hr>

# Installing YDB with Ansible

The repository contains ready-to-use templates for deploying a YDB cluster on servers, considering redundancy models `mirror-3-dc` and `block-4-2`. The templates can be scaled depending on the tasks. To download the repository, use the command `git clone https://github.com/ydb-platform/ydb-ansible-examples.git`.

## Required dependencies, external files, and server requirements { #requirements }

Please note that the machine onto which the repository is downloaded must meet the following requirements:
* Python 3 version 3.10+.
* Ansible core version not lower than 2.15.2.
* Network connectivity with the servers where YDB will be installed.

The minimum number of servers required for deploying YDB is eight machines for the `block-4-2` redundancy type and nine machines for the `mirror-3-dc` redundancy type. The servers must meet the following requirements:
* 16 CPU cores.
* 16 GB RAM.
* SSD/HDD from 120 GB.
* SSH access via key.
* Local DNS zone.
* Internet access.

To connect Ansible to the servers, a pre-prepared SSH key is required, which needs to be placed in the root directory of the downloaded repository and its name specified in the `ansible_ssh_private_key_file` variable of the inventory file `50-inventory.yaml` of the selected or cloned template.

Also, the YDB current version [archive](https://ydb.tech/docs/ru/downloads/#ydb-server) needs to be uploaded to the root directory of the downloaded repository and the archive name specified in the `ydb_archive` variable of the inventory file `50-inventory.yaml`.

To run the `setup_playbook.yaml` playbook, which executes the YDB cluster deployment scenario, it is necessary to install Ansible collections `ydb_platform.ydb` and `community.general`. The collections are installed with the command `ansible-galaxy install -r requirements.yaml`. After installing the collections, you can adapt an existing template from the repository or create your own template by cloning an existing one.


## Cluster deployment templates structure { #templates }
The template directories (`8-nodes-block-4-2` and `9-nodes-mirror-3-dc`) are structured identically:
```
.
├── ansible.cfg                   # Ansible configuration file.
├── ansible_vault_password_file   # Password for the YDB root user.
├── creds                         # Environment variables defining the YDB user and password.
├── files                         # Subdirectory containing files to be uploaded to the server.
│   └── config.yaml               # YDB configuration file.
├── inventory                     # Subdirectory containing Ansible inventory files.
│   ├── 50-inventory.yaml         # Main inventory file containing hosts and vars.
│   └── 99-inventory-vault.yaml   # Encrypted inventory file containing the root user password.  
└── setup_playbook.yaml           # YDB cluster deployment playbook.
``` 
The main configuration file for the YDB deployment scenario is the `50-inventory.yaml` inventory file. It specifies:
* FQDNs of hosts where YDB will be deployed:
    ```yaml
    hosts:
        static-node-1.ydb-cluster.com:
        static-node-2.ydb-cluster.com:
        static-node-3.ydb-cluster.com:
        ...
    ```
* Cluster configuration and deployment variables:
    + `ansible_user` – the user for Ansible to connect via SSH.
    + `ansible_ssh_private_key_file` – path to the private part of the SSH key Ansible will use to connect to the servers.
    + `system_timezone` – system timezone.
    + `system_ntp_servers` – list of NTP server IPs for time synchronization on the servers.
    + `ydb_archive` – path to the YDB archive for installation on the server.
    + `ydb_config` – path to the YDB configuration file.
    + `ydb_tls_dir` – path to the directory with TLS certificates.
    + `ydb_user` – the name of the YDB user to be registered in the DBMS.
    + `ydb_cores_static` – the number of CPU cores allocated for a static node.
    + `ydb_disks`:
        - `name`: /dev/vdb – path to the block device where the database will be located.
        - `label`: ydb_disk_1 – label name to be assigned to the block device.
    + `ydb_allow_format_drives` – variable that sets the condition for formatting the attached block device.
    + `ydb_skip_data_loss_confirmation_prompt` – variable that determines the user's cancellation of the disk formatting confirmation (by default, the notification is not displayed).
    + `ydb_domain` – the domain name (YDB cluster).
    + `ydb_dbname` – the name of the database that will be automatically created after the cluster deployment.
    + `ydb_pool_kind` – the type of disk. Can be ssd or hdd.
    + `ydb_database_groups` – the number of storage groups. The variable has fixed values: seven for the `8-nodes-block-4-2` redundancy type and eight for `9-nodes-mirror-3-dc`, regardless of the number of servers.
    + `ydb_cores_dynamic` – the number of CPU cores for dynamic nodes (per server).
    + `ydb_dynnodes` – sets of dynamic node instances with an increment of the IC port offset.
    + `ydb_brokers` – list of brokers.

The other inventory file, `99-inventory-vault.yaml`, contains the password for the YDB root user in encrypted form. By default, the password is `password`. To change it, specify the new password in the following format:
```yaml
all:
  children:
    ydb:
      vars:
        ydb_password: <new password>
```
Then execute the command `ansible-vault encrypt inventory/99-inventory-vault.yaml` to encrypt the file. Specify the new password in the ansible_vault_password_file.

To generate a set of TLS certificates for encrypting traffic between cluster servers, you can use the `ydb-ca-update.sh` script, which uses the list of server FQDNs from the `ydb-ca-nodes.txt` file.

When deploying the cluster, minor modifications to the YDB configuration file, located in the subdirectory `<template folder>/files/config.yaml`, are required. The following changes need to be made:
* Specify the current set of FQDNs for the servers in the `hosts` section:
```yaml
  ...
  hosts:
  - host: static-node-1.ydb-cluster.com
    host_config_id: 1
    walle_location:
      body: 1
      data_center: 'zone-a'
      rack: '1'
  ...    
  ```  

* Update the set of `node_id` in the `blob_storage_config` section:
  ```yaml
  ...
  - fail_domains:
      - vdisk_locations:
        - node_id: static-node-1.ydb-cluster.com
          pdisk_category: SSD
          path: /dev/disk/by-partlabel/ydb_disk_1
  ...        
  ```

The other sections and settings of the configuration file remain unchanged.

## Scaling the YDB cluster { #cluster-scaling }
To adapt the ready-made templates for the required number of servers, follow these steps:
1. Create a copy of the directory with the ready example (`9-nodes-mirror-3-dc` or `8-nodes-block-4-2`).
2. Specify the FQDNs of the servers in the `TLS/ydb-ca-nodes.txt` file and run the `ydb-ca-update.sh` script to generate sets of TLS certificates.
3. Make changes to the inventory files of the template `50-inventory.yaml` and `99-inventory-vault.yaml`.
4. Make changes to the {{ ydb-short-name }} configuration file in accordance with the [instructions](#ydb-config-prepare).
5. Execute the command `ansible-playbook setup_playbook.yaml` while in the directory of the cloned template.


## Verifying cluster operation { #cluster-check }

As a result of executing the playbook, a YDB cluster will be created with a test database named `database`, a `root` user with maximum access rights will be created, and the Embedded UI will be launched on port 8765. To connect to the Embedded UI, you can set up SSH tunneling. To do this on your local machine, execute the command `ssh -L 8765:localhost:8765 -i <ssh private key> <user>@<first ydb static node ip>`. After successfully establishing the connection, you can navigate to the URL [localhost:8765](http://localhost:8765).
