# **Initial Project Creator's Guide**

### **Audience and Purpose**

This document is intended exclusively for the **Initial Project Creator** (e.g., the project lead or founding developer). Its sole purpose is to serve as the official record and explanation for the **one-time-only process** of creating a new monorepo from an empty directory.

**All subsequent developers** joining the project should disregard this guide and refer to the New Developer Onboarding Guide for setup instructions.

### **Recommended Setup Method: Automation Script**

For the initial creation of the repository, the use of the `init_project.sh` automation script is the prescribed and most efficient method. This script is designed to execute all the necessary setup procedures in a single operation, ensuring consistency and eliminating the potential for manual error.

The subsequent sections of this guide serve as a detailed, step-by-step documentation of the procedures performed by the automation script. They provide a comprehensive record of the repository's foundational structure and configuration principles.

### **Section I: Project Initialization and Version Control Configuration**

The inaugural procedure is the establishment of the principal project directory upon the local file system. Subsequently, this directory must be initialized as a Git version control repository to track all modifications.

```bash
# Creation of the root project directory.
# Replace 'your-project-name' with your actual project name
mkdir your-project-name
cd your-project-name

# Initialization of a new Git repository.
git init

# Establishment of the primary branches for the repository.
# The 'main' branch is reserved for stable, production-ready releases.
git branch -M main
# The 'develop' branch will serve as the primary integration branch for development.
git checkout -b develop
```

It is a requirement that following the initial push to the remote repository, the develop branch be designated as the default branch within the remote repository's configuration settings.

### **Section II: Core Directory Structuring**

Following initialization, the requisite top-level sub-directories for the project are created. Subsequently, a detailed internal structure is established for both the backend and frontend applications to provide a standardized foundation for development.

#### **Top-Level Directories**

```bash
# From the root of your project directory, the following commands are executed:
mkdir backend
mkdir frontend
mkdir docs
mkdir scripts
mkdir tests
mkdir assets
```

#### **Detailed Application Structure**

The automation script proceeds to create the following comprehensive directory and file structure, including necessary placeholder files to bootstrap development:

```
your-project-name/
├── backend/
│   ├── src/
│   │   ├── controllers/
│   │   ├── middleware/
│   │   ├── models/
│   │   ├── routes/
│   │   ├── services/
│   │   ├── utils/
│   │   └── config/
│   ├── migrations/
│   ├── seeds/
│   ├── tests/
│   ├── .env.example
│   └── package.json
│
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   │   ├── ui/
│   │   │   ├── layout/
│   │   │   ├── forms/
│   │   │   └── feature-specific/
│   │   ├── pages/
│   │   ├── hooks/
│   │   ├── services/
│   │   ├── types/
│   │   ├── utils/
│   │   └── assets/
│   ├── public/
│   ├── .env.example
│   └── package.json
│
├── docs/
│   ├── api/
│   ├── deployment/
│   ├── development/
│   └── user-guide/
│
├── scripts/
├── tests/
├── assets/
├── docker-compose.yml
├── package.json
└── README.md
```

### **Section III: Configuration Files**

To maintain repository integrity and provide proper project configuration, several essential files are created:

#### **.gitignore File Configuration**

A `.gitignore` file is created in the root directory to exclude extraneous artifacts from version control.

#### **Package.json Files**

- **Root package.json**: Contains project metadata and scripts for managing the monorepo
- **Backend package.json**: Contains backend dependencies and scripts
- **Frontend package.json**: Contains frontend dependencies and scripts

#### **Environment Configuration**

- **Backend .env.example**: Template for backend environment variables
- **Frontend .env.example**: Template for frontend environment variables

#### **Docker Configuration**

- **docker-compose.yml**: Container orchestration for development environment
- **Backend Dockerfile**: Container configuration for backend service
- **Frontend Dockerfile**: Container configuration for frontend service

### **Section IV: Documentation Structure**

The documentation directory is populated with essential guides and references:

- **API Documentation**: Complete API reference and examples
- **Development Guide**: Setup and development workflow instructions
- **Deployment Guide**: Production deployment procedures
- **User Guide**: End-user documentation and tutorials

### **Section V: Initial Repository Commit**

The foundational project structure, having been established, must now be committed to the repository's history. Adherence to the Conventional Commits specification for the formulation of commit messages is herewith prescribed as a standard of practice.

```bash
# Addition of all newly created files and directories to the Git staging area.
git add .

# Creation of the initial commit with a descriptive message.
git commit -m "chore: initial project structure and configuration"
```

### **Section VI: Remote Repository Configuration**

The local repository must be confederated with a remote counterpart. The procedure for this confederation involves creating a new, empty repository on a platform such as GitHub and linking it to the local repository.

```bash
# The placeholder herein must be replaced with the veridical URL of the remote repository.
git remote add origin https://github.com/YourGitHubUsername/your-project-name.git

# The 'main' and 'develop' branches are to be pushed to the remote repository.
git push -u origin main
git push -u origin develop
```

A final, critical directive: within the configuration settings of the remote GitHub repository, the default branch designation must be altered from 'main' to 'develop'.

### **Section VII: Task Management Setup**

With the successful completion of the initialization and configuration protocols, the repository is hereby deemed established. The subsequent course of action is to populate the project's issue tracker.

#### **Using the Task Creation Script**

The project includes a Python script (`create_github_issues.py`) that can automatically create GitHub issues from a YAML task list:

```bash
# Create GitHub issues from the master task list
python create_github_issues.py \
  --token YOUR_GITHUB_TOKEN \
  --repo your-project-name \
  --owner YourGitHubUsername \
  --task-file master-task-list.yml
```

#### **Manual Task Creation**

Alternatively, you can manually create issues based on the tasks defined in the `master-task-list.yml` file, following the project's branching strategy and development workflow.

### **Section VIII: Project Customization**

After the initial setup, the following customizations should be performed:

1. **Update project-specific references** in all documentation files
2. **Configure environment variables** for your specific project needs
3. **Set up API keys and external service integrations**
4. **Customize the tech stack** if different from the default
5. **Update the README.md** with project-specific information

### **Section IX: Development Environment Setup**

Once the repository is established, the development environment should be configured:

1. **Install dependencies**: `npm run install:all`
2. **Set up environment variables**: Copy `.env.example` files and configure
3. **Start development servers**: `npm run dev`
4. **Verify setup**: Ensure all services are running correctly

### **Section X: Team Onboarding**

After the initial setup is complete:

1. **Share the repository** with team members
2. **Direct new developers** to the New Developer Onboarding Guide
3. **Set up branch protection rules** as outlined in the Project Branching Strategy
4. **Configure CI/CD pipelines** for automated testing and deployment

---

**Note**: This guide is designed to be a generic template. Replace all instances of `your-project-name` with your actual project name, and customize the structure and configuration according to your specific project requirements.