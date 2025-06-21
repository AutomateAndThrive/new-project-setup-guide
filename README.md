# **Project Setup and Onboarding Guide**

This repository contains all the necessary scripts and documentation to initialize a new software project and onboard new developers according to professional best practices.

It provides two distinct, clear flows: one for the initial project creator and one for subsequent developers joining the project.

## **Repository Contents**

### **🚀 Automation Scripts**

These scripts automate key setup processes.

| File | Purpose |
| :---- | :---- |
| **init\_project.sh** | A shell script to be run **once** to create the entire monorepo structure from scratch. |
| **create\_github\_issues.py** | A Python script to populate the GitHub repository with initial setup tasks from a YAML file. |

### **📖 Documentation Guides**

These guides explain the project's structure, workflows, and setup procedures.

| File | Intended Audience |
| :---- | :---- |
| **Initial Project Creator's Guide.md** | Explains the one-time setup process for the project lead. |
| **New Developer Onboarding Guide.md** | The standard guide for any developer cloning the repo to get their local environment running. |
| **Project Branching Strategy.md** | Defines the mandatory Git workflow for all development. |
| **Initial Project Task List.md** | Contains the master list of tasks for bootstrapping the repository. |

### **📝 Configuration**

| File | Purpose |
| :---- | :---- |
| **master-task-list.yml** | The YAML data file used by the create\_github\_issues.py script. |

