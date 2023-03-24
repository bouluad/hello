#!/bin/sh

# Get the current value of the number from the ConfigMap file
current_value=$(curl -s https://api.github.com/repos/my-org/my-repo/contents/config.txt \
    | jq -r '.content' \
    | base64 -d \
    | awk -F= '/^number/ { print $2 }')

# Increment the number and update the ConfigMap file
new_value=$((current_value + 1))
curl -X PUT -H "Authorization: token $GITHUB_TOKEN" -H "Content-Type: application/json" \
    -d "{\"message\":\"Update configmap\",\"content\":\"$(echo "number=$new_value\nmessage=Hello, world!" | base64)\",\"sha\":\"$(curl -s https://api.github.com/repos/my-org/my-repo/contents/config.txt \
    | jq -r '.sha')\",\"path\":\"config-${new_value}.txt\"}" \
    https://api.github.com/repos/my-org/my-repo/contents/config-${new_value}.txt

# Update the deployment to use the new ConfigMap file
kubectl patch deployment my-deployment \
    --type=json \
    -p='[{"op": "replace", "path": "/spec/template/spec/volumes/0/configMap/name", "value": "my-configmap-'$new_value'"}, \
         {"op": "replace", "path": "/spec/template/spec/containers/0/env/0/value", "value": "config-'$new_value'.txt"}]'
