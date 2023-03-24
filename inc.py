from github import Github

# Initialize PyGithub client with a GitHub personal access token
g = Github("YOUR_GITHUB_TOKEN")

# Get the repository and file objects
repo = g.get_repo("ORGANIZATION/REPO_NAME")
file_path = "path/to/file"
file = repo.get_contents(file_path)

# Increment the number inside the file
new_content = int(file.decoded_content.decode()) + 1

# Create a new commit with the updated file content
commit_message = "Increment number inside file"
branch_name = "main" # Or replace with your preferred branch name
commit_sha = repo.get_branch(branch_name).commit.sha
repo.update_file(file_path, commit_message, new_content, commit_sha, branch=branch_name)

# Push the changes to GitHub
repo.push()
