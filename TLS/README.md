# ydb-ca-nodes.txt

## Usage
This file is used by script `ydb-ca-update.sh`. Fill this file with list of your nodes and execxute script `python3 ydb-ca-update.sh`. Script will generate set of self-signed certificates for every node in the file. These certificates will be placed in folder:
`CA/certs/YYYY-MM-DD_HH-mm-SS/hostname`.
WARNING: It's possible to define serveral names (use a space as a separator) for a 
host to put in into certificate. But you have to place `short inventory hostname` at the first position .
This hostname will be used by Ansible to find a certificate in the set of folders.

### inventory_hostname_short

[Ansible documentation](https://docs.ansible.com/ansible/latest/reference_appendices/special_variables.html)
The short version of inventory_hostname, is the first section after splitting it via .. As an example, for the inventory_hostname of www.example.com, www would be the inventory_hostname_short This is affected by delegation, so it will reflect the ‘short name’ of the delegated host


## Structure of file
\<FQDN>
\<hostname> \<FQDN>