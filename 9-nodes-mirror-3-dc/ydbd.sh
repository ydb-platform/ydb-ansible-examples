#!/bin/bash
LD_LIBRARY_PATH=/opt/ydb/lib /opt/ydb/bin/ydbd --ca-file=/opt/ydb/certs/ca.crt --server=grpcs://static-node-1.ydb-cluster.com:2135 "$@"
