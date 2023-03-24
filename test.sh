#!/bin/sh

# Get the current value of the number from the ConfigMap file
current_value=$(curl -s https://api.github.com/repos/my-org/my-repo/contents/config.txt \
    | jq -r '.content' \
    | base64 -d \
    | awk -F= '/^number/ { print $2 }')

# Increment the number and update the ConfigMap file
new_value=$((current_value + 1))
curl -X PUT -H "Authorization: token $GITHUB_TOKEN" -H "Content-Type: application/json" \
    -d "{\"message\":\"Increment number\",\"content\":\"$(echo "number=$new_value" | base64)\",\"sha\":\"$(curl -s https://api.github.com/repos/my-org/my-repo/contents/config.txt \
    | jq -r '.sha')\"}" \
    https://api.github.com/repos/my-org/my-repo/contents/config.txt
