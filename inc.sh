#!/bin/bash

# Set the GitHub personal access token and repository details
GITHUB_TOKEN="YOUR_GITHUB_TOKEN"
ORGANIZATION="ORGANIZATION"
REPO_NAME="REPO_NAME"
FILE_PATH="path/to/file"

# Get the current file content
curl -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3.raw" -L "https://api.github.com/repos/$ORGANIZATION/$REPO_NAME/contents/$FILE_PATH" > temp_file.txt
current_content=$(<temp_file.txt)

# Increment the number inside the file
new_content=$((current_content + 1))

# Encode the new file content as base64
new_content_base64=$(echo -n "$new_content" | base64)

# Create a new commit with the updated file content
commit_message="Increment number inside file"
branch_name="main" # Or replace with your preferred branch name
commit_sha=$(curl -s -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3+json" -L "https://api.github.com/repos/$ORGANIZATION/$REPO_NAME/branches/$branch_name" | jq -r '.commit.sha')
curl -X PUT -H "Authorization: token $GITHUB_TOKEN" -H "Content-Type: application/json" -H "Accept: application/vnd.github.v3+json" -d "{\"path\":\"$FILE_PATH\",\"message\":\"$commit_message\",\"content\":\"$new_content_base64\",\"sha\":\"$commit_sha\",\"branch\":\"$branch_name\"}" "https://api.github.com/repos/$ORGANIZATION/$REPO_NAME/contents/$FILE_PATH"

# Clean up temporary files
rm temp_file.txt
