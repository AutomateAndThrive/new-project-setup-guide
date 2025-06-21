import os
import sys
import yaml
import requests

# ==============================================================================
# GitHub Issue Creation Script
#
# Description:
#   This script reads a YAML file containing a list of issues and uses the
#   GitHub API to create them in a specified repository. It is designed to
#   automate the initial setup of a project's issue tracker.
#
# Usage:
#   1. Install dependencies: `pip install PyYAML requests`
#   2. Configure the variables in the "Configuration" section below.
#   3. Set your GitHub Personal Access Token as an environment variable.
#   4. Run the script: `python create_github_issues.py`
# ==============================================================================

# --- Configuration ---
# TODO: Replace these values with your GitHub repository details.
REPO_OWNER = "YourGitHubUsername"
REPO_NAME = "your-repo-name"
# The name of the YAML file containing the issues to be created.
ISSUES_FILE_PATH = "master-task-list.yml"

# --- GitHub API Setup ---
# It is strongly recommended to set your GitHub token as an environment variable
# for security, rather than hardcoding it into the script.
#
# On macOS/Linux:
#   export GITHUB_TOKEN='your_personal_access_token'
# On Windows (PowerShell):
#   $env:GITHUB_TOKEN='your_personal_access_token'
#
GITHUB_TOKEN = os.getenv("GITHUB_TOKEN")
GITHUB_API_URL = f"https://api.github.com/repos/{REPO_OWNER}/{REPO_NAME}/issues"
HEADERS = {
    "Authorization": f"token {GITHUB_TOKEN}",
    "Accept": "application/vnd.github.v3+json",
}


def check_configuration():
    """Validates that the script has been properly configured before execution."""
    if REPO_OWNER == "YourGitHubUsername" or REPO_NAME == "your-repo-name":
        print("❌ Error: Please update the REPO_OWNER and REPO_NAME variables in the script.")
        return False

    if not GITHUB_TOKEN:
        print("❌ Error: GITHUB_TOKEN environment variable not set.")
        print("Please set your GitHub Personal Access Token as an environment variable.")
        return False

    return True


def load_issues_from_yaml(file_path):
    """Loads and parses the issue definitions from the specified YAML file."""
    try:
        with open(file_path, 'r') as file:
            # Using safe_load is recommended to prevent arbitrary code execution.
            issues = yaml.safe_load(file)
            if not issues:
                print(f"⚠️ Warning: The file '{file_path}' is empty or not formatted correctly.")
                return []
            return issues
    except FileNotFoundError:
        print(f"❌ Error: The file '{file_path}' was not found in the current directory.")
        return None
    except yaml.YAMLError as e:
        print(f"❌ Error: Could not parse YAML file '{file_path}'. Please check its format.")
        print(f"   Details: {e}")
        return None


def create_github_issue(issue_data):
    """Creates a single issue on GitHub using the provided issue data."""
    if "title" not in issue_data:
        print("⚠️ Skipping entry because it's missing a 'title'.")
        return

    # Construct the payload for the GitHub API request.
    payload = {
        "title": issue_data.get("title"),
        "body": issue_data.get("body"),
        "labels": issue_data.get("labels", []),
    }

    # Add optional fields if they exist in the YAML data.
    if issue_data.get("assignee"):
        payload["assignees"] = [issue_data.get("assignee")]
    if issue_data.get("milestone"):
        # Note: The GitHub API requires the milestone to be an integer ID, not a string title.
        # This script does not perform the lookup and will ignore the milestone field.
        # For a more advanced implementation, a pre-fetch of milestone IDs would be required.
        print(f"ℹ️ Info: Milestone '{issue_data.get('milestone')}' ignored. API requires a numeric ID.")

    try:
        response = requests.post(GITHUB_API_URL, headers=HEADERS, json=payload)
        response.raise_for_status()  # Raises an HTTPError for bad responses (4XX or 5XX)

        if response.status_code == 201:
            print(f"✅ Successfully created issue: '{payload['title']}'")
            print(f"   URL: {response.json()['html_url']}")
        else:
            print(f"⚠️ Failed to create issue '{payload['title']}' with status code: {response.status_code}")
            print(f"   Response: {response.text}")

    except requests.exceptions.RequestException as e:
        print(f"❌ Error connecting to the GitHub API for issue: '{payload['title']}'")
        print(f"   Details: {e}")


def main():
    """The main function to orchestrate the issue creation process."""
    print("--- Starting GitHub Issue Creation Script ---")

    if not check_configuration():
        sys.exit(1)

    print(f"\nLoading issues from '{ISSUES_FILE_PATH}'...")
    issues = load_issues_from_yaml(ISSUES_FILE_PATH)

    if issues is None:
        print("Could not load issues. Exiting.")
        sys.exit(1)

    if not issues:
        print("No issues found in the file to process. Exiting.")
        sys.exit(0)

    print(f"Found {len(issues)} issues to create for the repository: {REPO_OWNER}/{REPO_NAME}")

    print("\nCreating issues on GitHub...")
    for issue in issues:
        create_github_issue(issue)

    print("\n--- Script finished. ---")


if __name__ == "__main__":
    main()
