#!/bin/bash
kubectl -n NAME_SPACE patch sts STS_NAME --type='json' -p='[{"op": "replace", "path": "/spec/template/metadata/labels/dateofcreated", "value":"REPLACE_ME_BY_DATETIME"}]'

kubectl -n NAME_SPACE get pods | grep Running
