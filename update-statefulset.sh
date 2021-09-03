#!/bin/bash

function base_image_changed(){
    current_base_image=(kubectl get sts STS_NAME -n NAME_SPACE -o jsonpath={.spec.template.spec.containers[*].image})
    desire_base_image=$(cat pipeline-properties.json | jq -r ."base_image")
    echo $desire_base_image
    if [ "${desire_base_image}" == "$current_base_image" ]; then
        # Case nothing change
        return 1
    else 
        return 0
    fi
}

function parameters_changed(){
    # assume nothing chnge
    return 1
}

# Check if a new deploy is need ?
function need_deploy(){
    if base_image_changed && parameters_changed; then
        return 0;
    else 
        return 1;
    fi
}

# Deploy with patching the following param:
# GIT_BRANCH
# GIT_URL
# BASE_IMAGE
function update_sts(){
    echo "Start Deploy ..."
    #kubectl -n NAME_SPACE patch sts STS_NAME --type='json' -p='[{"op": "replace", "path": "/spec/template/metadata/labels/dateofcreated", "value":"REPLACE_ME_BY_DATETIME"}]'
}

function main(){
    if need_deploy; then
        update_sts
    else 
        echo "No need"
    fi
}

main $@
