#!/bin/sh

# Get the current ConfigMap name from the deployment YAML file in the GitHub repository
current_configmap=$(curl -s https://api.github.com/repos/my-org/my-repo/contents/deployment.yaml \
    | jq -r '.content' \
    | base64 -d \
    | yq -r '.spec.template.spec.volumes[]?.configMap.name')

# Construct the new ConfigMap name
new_configmap="my-configmap-$(date +%Y%m%d%H%M%S)"

# Update the contents of the deployment YAML file in the GitHub repository with the new ConfigMap name
curl -X PUT -H "Authorization: token $GITHUB_TOKEN" -H "Content-Type: application/json" \
    -d "{\"message\":\"Update deployment\",\"content\":\"$(cat deployment.yaml | sed "s/${current_configmap}/${new_configmap}/g" | base64)\",\"sha\":\"$(curl -s https://api.github.com/repos/my-org/my-repo/contents/deployment.yaml \
    | jq -r '.sha')\"}" \
    https://api.github.com/repos/my-org/my-repo/contents/deployment.yaml

# Trigger a new deployment with the updated ConfigMap name
kubectl apply -f deployment.yaml
