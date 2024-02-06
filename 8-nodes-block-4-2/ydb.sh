#!/bin/bash
LD_LIBRARY_PATH=/opt/ydb/lib /opt/ydb/bin/ydb --ca-file=/opt/ydb/certs/ca.crt --endpoint=grpcs://static-node-1.ydb-cluster.com:2135 "$@"
