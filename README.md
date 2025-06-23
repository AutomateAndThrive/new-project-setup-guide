# **New Project Setup Guide**

[![CI/CD Pipeline](https://github.com/AutomateAndThrive/new-project-setup-guide/workflows/CI/badge.svg)](https://github.com/AutomateAndThrive/new-project-setup-guide/actions)
[![Test Coverage](https://codecov.io/gh/AutomateAndThrive/new-project-setup-guide/branch/main/graph/badge.svg)](https://codecov.io/gh/AutomateAndThrive/new-project-setup-guide)
[![Code Quality](https://img.shields.io/badge/code%20quality-A%2B-4CAF50.svg)](https://github.com/AutomateAndThrive/new-project-setup-guide)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Node.js Version](https://img.shields.io/badge/node-%3E%3D18.0.0-brightgreen.svg)](https://nodejs.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.3.3-blue.svg)](https://www.typescriptlang.org/)

<!-- CI/CD Test: This comment validates our automated quality gates -->

A comprehensive toolkit for solo developers and small teams to initialize new software projects with **enforced best practices**, automated quality gates, and complete developer onboarding documentation.

This repository provides everything you need to bootstrap a new project with proper structure, **automated enforcement**, and workflows that scale from solo development to small teams.

## **🚀 Quick Start**

### **For Solo Developers & Small Teams**

1. **Clone this repository** to use as your project setup template
2. **Run `./init_project.sh`** to create your new project structure
3. **Follow the pre-development checklist** to complete setup before development begins

### **What You Get (MVP)**

✅ **Automated Code Quality** - Pre-commit hooks, linting, formatting, and testing  
✅ **Simplified Git Workflow** - Clean branching strategy for small teams  
✅ **Development Environment** - Docker setup with hot reloading  
✅ **CI/CD Pipeline** - Essential checks and automated testing  
✅ **Documentation Standards** - Auto-generated docs and decision logs

## **🎯 Project Overview**

This setup is designed for **solo developers and small teams** who want to:

- **Start with best practices** from day one
- **Automate quality enforcement** to prevent technical debt
- **Scale gracefully** as the team grows
- **Maintain consistency** as developers come and go

### **Key Features**

- **Automated Quality Gates** - Pre-commit hooks enforce code standards
- **Simplified Git Flow** - Clean branching strategy without complexity
- **Development Environment** - Docker setup with hot reloading
- **Testing Framework** - Automated testing with coverage requirements
- **Documentation Automation** - Auto-generated API docs and decision logs

## **📋 Pre-Development Checklist**

After running `./init_project.sh`, complete these essential setup tasks:

### **Foundation Setup** (Required)

- [ ] Review generated project structure
- [ ] Configure environment variables
- [ ] Set up and test database
- [ ] Verify development environment

### **Quality Enforcement** (Required)

- [ ] Configure pre-commit hooks
- [ ] Set up automated testing
- [ ] Configure code coverage requirements
- [ ] Set up linting and formatting

### **Team Setup** (Required)

- [ ] Create development guidelines
- [ ] Set up project management
- [ ] Configure CI/CD pipeline
- [ ] Set up monitoring and logging

## **🛠️ Tech Stack**

### **Frontend**

- **React 18** with TypeScript
- **Vite** for build tooling
- **Tailwind CSS** for styling
- **React Router** for navigation
- **React Query** for data fetching
- **Zustand** for state management

### **Backend**

- **Node.js** with Express.js
- **PostgreSQL** for primary database
- **Redis** for caching
- **Sequelize** as ORM
- **JWT** for authentication

### **DevOps & Quality**

- **Docker** and Docker Compose
- **GitHub Actions** for CI/CD
- **Husky** for Git hooks
- **ESLint** and **Prettier** for code quality
- **Jest** and **Vitest** for testing

## **📁 Repository Contents**

### **Automation Scripts**

| File                            | Purpose                                                        |
| ------------------------------- | -------------------------------------------------------------- |
| `init_project.sh`               | Main script to scaffold a new project structure                |
| `create_github_issues.py`       | Script to create GitHub issues from the checklist YAML         |
| `pre-development-checklist.yml` | Checklist of setup tasks to complete before development begins |

### **Documentation Guides**

| File                                 | Intended Audience                                        |
| ------------------------------------ | -------------------------------------------------------- |
| `Initial Project Creator's Guide.md` | Step-by-step guide for the person setting up the project |
| `New Developer Onboarding Guide.md`  | Guide for new developers joining the project             |
| `Project Branching Strategy.md`      | Defines the mandatory Git workflow for all development   |

## **🔧 Customization**

All templates and guides are designed to be easily customized for your specific project needs. See the individual guide files for detailed customization instructions.

## **📚 Documentation Hub**

### **For Project Creators**

- **[Initial Project Creator's Guide](Initial%20Project%20Creator's%20Guide.md)** - Complete setup process
- **[Pre-Development Checklist](pre-development-checklist.yml)** - Essential tasks before development

### **For New Developers**

- **[New Developer Onboarding Guide](New%20Developer%20Onboarding%20Guide.md)** - Get up and running quickly
- **[Project Branching Strategy](Project%20Branching%20Strategy.md)** - Git workflow and best practices

### **Quality & Standards**

- **Automated Testing** - Jest and Vitest configuration
- **Code Quality** - ESLint, Prettier, and Husky setup
- **CI/CD Pipeline** - GitHub Actions workflows
- **Documentation Standards** - Auto-generated docs and decision logs

## **🎯 Success Metrics**

- **Zero Technical Debt** - Automated enforcement prevents accumulation
- **Consistent Code Quality** - Pre-commit hooks ensure standards
- **Fast Onboarding** - New developers productive in < 1 hour
- **Reliable Deployments** - Automated testing prevents broken releases

## **❓ Frequently Asked Questions (FAQ)**

### **General Questions**

**Q: What makes this different from other project templates?**
A: This template focuses on **enforcement over complexity**. It automatically prevents technical debt accumulation through pre-commit hooks, enforces code quality standards, and provides comprehensive documentation that actually gets used.

**Q: Is this suitable for large teams?**
A: This template is optimized for **solo developers and small teams** (1-10 developers). For larger teams, you may want to add additional governance and approval workflows.

**Q: Can I customize the tech stack?**
A: Yes! The `init_project.sh` script supports multiple frontend frameworks (React, Vue, Angular, Next.js), backend frameworks (Node.js, Python, .NET, Java), and databases (PostgreSQL, MySQL, MongoDB, SQLite).

### **Setup & Configuration**

**Q: How long does initial setup take?**
A: Running `./init_project.sh` takes about 2-3 minutes. Complete setup including environment configuration typically takes 15-30 minutes for a new developer.

**Q: What if I don't want all the enforcement tools?**
A: You can selectively disable tools by modifying the configuration files, but we recommend keeping them as they prevent common issues and maintain code quality.

**Q: How do I update the project template?**
A: Clone this repository, make your customizations, and use it as your new template. The template itself is version controlled and can be updated over time.

### **Development Workflow**

**Q: What happens if I try to commit bad code?**
A: Pre-commit hooks will automatically block the commit and show you what needs to be fixed. This includes linting errors, formatting issues, and failing tests.

**Q: How do I handle hotfixes?**
A: Follow the hotfix workflow in the Project Branching Strategy guide. Create a hotfix branch from main, make your changes, and create a PR that will be fast-tracked.

**Q: What if the CI pipeline fails?**
A: The CI pipeline will show you exactly what failed. Fix the issues locally, push your changes, and the pipeline will re-run automatically.

### **Quality & Standards**

**Q: Why is 80% test coverage required?**
A: 80% coverage provides a good balance between thorough testing and development speed. It catches most bugs while not being overly burdensome.

**Q: How do I add new dependencies?**
A: Use `npm install` as usual. Dependabot will automatically create PRs for security updates, and the CI pipeline will test compatibility.

**Q: What if I need to bypass a pre-commit hook?**
A: Use `git commit --no-verify` (not recommended) or fix the underlying issue. The hooks are there to prevent problems, not create them.

### **Troubleshooting**

**Q: Husky hooks aren't working after cloning**
A: Run `npm install` and then `npm run prepare` to set up the Git hooks properly.

**Q: Tests are failing locally but passing in CI**
A: Check that you're using the same Node.js version and that all dependencies are installed. Run `npm ci` to ensure exact dependency versions.

**Q: TypeScript errors in VS Code but not in terminal**
A: Restart the TypeScript language server in VS Code (Cmd+Shift+P → "TypeScript: Restart TS Server").

### **Getting Help**

**Q: Where can I find more detailed documentation?**
A: Check the `docs/` directory for comprehensive guides on development, API documentation, and project management.

**Q: How do I contribute to this template?**
A: Fork the repository, make your improvements, and submit a pull request. We welcome contributions that improve the developer experience.

**Q: What if I find a bug or have a feature request?**
A: Please create an issue on GitHub with a clear description of the problem or feature request.
