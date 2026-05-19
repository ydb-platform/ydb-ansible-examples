# Get current cluster configuration

## Requirements

- preinstalled cluster with any configuration

## Steps

1. Run the generate_conf playbook to fetch the current cluster configuration:
   ```bash
   ansible-playbook ydb_platform.ydb.generate_conf
   ```

2. The configuration files will be saved to the `ydb_cluster_config` directory:
   - For V1 clusters:
     - `ydb_cluster_config/ydbd-config-static.yaml` - static configuration
     - `ydb_cluster_config/ydb_cluster_dynconfig.yaml` - dynamic configuration
   - For V2 clusters:
     - `ydb_cluster_config.yaml` - unified configuration file
