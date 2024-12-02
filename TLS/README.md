# ydb-ca-nodes.txt

## Usage
This file is used by script `ydb-ca-update.sh`. Fill this file with list of your nodes and execxute script `python3 ydb-ca-update.sh`. Script will generate set of self-signed certificates for every node in the file. These certificates will be placed in folder:
`CA/certs/YYYY-MM-DD_HH-mm-SS/hostname`.
WARNING: It's possible to define serveral names (use a space as a separator) for a 
host to put in into certificate. But you have to place inventory hostname at the first position.
This hostname will be used by Ansible to find a certificate in the set of folders.

## Structure of file
\<FQDN>
\<hostname> \<FQDN>