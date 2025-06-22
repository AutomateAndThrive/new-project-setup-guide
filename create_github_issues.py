#!/usr/bin/env python3
"""
GitHub Issue Creator for Pixel to Profit Project
Creates GitHub issues based on the master task list for the AI-powered print-on-demand listing automation tool.
"""

import yaml
import requests
import os
import sys
from typing import Dict, List, Any
import argparse

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
    parser = argparse.ArgumentParser(description="Create GitHub issues for Pixel to Profit project")
    parser.add_argument("--token", required=True, help="GitHub personal access token")
    parser.add_argument("--repo", required=True, help="GitHub repository name")
    parser.add_argument("--owner", required=True, help="GitHub repository owner")
    parser.add_argument("--task-file", default="master-task-list.yml", help="Path to task list YAML file")
    parser.add_argument("--dry-run", action="store_true", help="Show what would be created without actually creating issues")
    
    args = parser.parse_args()
    
    # Load task list
    task_list = load_task_list(args.task_file)
    
    # Initialize GitHub issue creator
    creator = GitHubIssueCreator(args.token, args.repo, args.owner)
    
    # Track created issues
    created_issues = []
    failed_issues = []
    
    print(f"🚀 Creating GitHub issues for Pixel to Profit project...")
    print(f"Repository: {args.owner}/{args.repo}")
    print(f"Task file: {args.task_file}")
    print(f"Dry run: {args.dry_run}")
    print("-" * 50)
    
    # Process each phase
    for phase in task_list.get('phases', []):
        phase_name = phase.get('name', 'Unknown Phase')
        print(f"\n📋 Processing phase: {phase_name}")
        
        for task in phase.get('tasks', []):
            task_id = task.get('id', 'Unknown')
            title = task.get('title', 'Untitled Task')
            
            # Generate issue content
            body = generate_issue_body(task, phase_name)
            labels = get_labels_for_task(task, phase_name)
            
            # Format title with task ID
            formatted_title = f"{task_id}: {title}"
            
            if args.dry_run:
                print(f"  📝 Would create: {formatted_title}")
                print(f"     Labels: {', '.join(labels)}")
                print(f"     Body length: {len(body)} characters")
            else:
                print(f"  📝 Creating: {formatted_title}")
                
                # Create the issue
                issue = creator.create_issue(
                    title=formatted_title,
                    body=body,
                    labels=labels
                )

                if issue:
                    created_issues.append({
                        'id': task_id,
                        'title': title,
                        'url': issue['html_url'],
                        'number': issue['number']
                    })
                    print(f"     ✅ Created: #{issue['number']} - {issue['html_url']}")
                else:
                    failed_issues.append({
                        'id': task_id,
                        'title': title
                    })
                    print(f"     ❌ Failed to create issue")
    
    # Summary
    print("\n" + "=" * 50)
    print("📊 SUMMARY")
    print("=" * 50)
    
    if args.dry_run:
        total_tasks = sum(len(phase.get('tasks', [])) for phase in task_list.get('phases', []))
        print(f"Would create {total_tasks} issues")
    else:
        print(f"✅ Successfully created: {len(created_issues)} issues")
        print(f"❌ Failed to create: {len(failed_issues)} issues")
        
        if created_issues:
            print(f"\n📋 Created Issues:")
            for issue in created_issues:
                print(f"  #{issue['number']}: {issue['title']} - {issue['url']}")
        
        if failed_issues:
            print(f"\n❌ Failed Issues:")
            for issue in failed_issues:
                print(f"  {issue['id']}: {issue['title']}")

    print(f"\n🎉 Issue creation complete!")


if __name__ == "__main__":
    main()
