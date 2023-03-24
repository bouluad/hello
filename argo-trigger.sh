#!/bin/bash

# Set variables
ARGOCD_SERVER=<argocd-server-url>
ARGOCD_USERNAME=<argocd-username>
ARGOCD_PASSWORD=<argocd-password>
APPLICATION_NAME=<argocd-application-name>

# Get the ArgoCD API token
ARGOCD_TOKEN=$(curl -s -k -X POST "$ARGOCD_SERVER/api/v1/session" -d "username=$ARGOCD_USERNAME&password=$ARGOCD_PASSWORD" | jq -r '.token')

# Create the ArgoCD Application
curl -s -k -X POST "$ARGOCD_SERVER/api/v1/applications" -H "Authorization: Bearer $ARGOCD_TOKEN" -H "Content-Type: application/json" -d "{\"apiVersion\": \"argoproj.io/v1alpha1\",\"kind\": \"Application\",\"metadata\": {\"name\": \"$APPLICATION_NAME\",\"namespace\": \"default\"},\"spec\": {\"destination\": {\"namespace\": \"default\",\"server\": \"https://kubernetes.default.svc\"},\"project\": \"default\",\"source\": {\"path\": \".\",\"repoURL\": \"https://github.com/myorg/myrepo.git\",\"targetRevision\": \"HEAD\"}}}"

# Trigger a sync
curl -s -k -X POST "$ARGOCD_SERVER/api/v1/applications/$APPLICATION_NAME/sync" -H "Authorization: Bearer $ARGOCD_TOKEN"
