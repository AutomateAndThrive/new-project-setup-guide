# **Project Branching Strategy**

This document defines the branching model and development workflow for the POD System B project. Adhering to this strategy ensures a clean, predictable, and manageable codebase.

## **Branch Overview**

Our model utilizes two primary, permanent branches and two types of temporary, supporting branches.

### **Permanent Branches**

1. **main**  
   * **Purpose:** This branch represents the official, production-ready release history of the project. The code on main must always be stable and deployable.  
   * **Rule:** Direct commits to main are strictly forbidden. Code only gets to main through a formal release process by merging from the develop branch.  
   * **Tags:** Every commit on main must be tagged with a version number (e.g., v1.0.0, v1.1.0).  
2. **develop**  
   * **Purpose:** This is the primary development and integration branch. It contains the most up-to-date version of the project, including completed features that are waiting for the next release.  
   * **Rule:** This will be set as the **default branch** on GitHub. All new work begins from develop, and all feature branches are merged back into develop.  
   * **Stability:** While develop should ideally be stable, it is understood to be a work-in-progress environment. Automated tests must pass before any code is merged into develop.

### **Supporting Branches**

1. **feature/\*** (e.g., feature/file-upload, feature/api-auth)  
   * **Purpose:** Used for developing new features. This isolates the work from the main develop branch until it is complete.  
   * **Creation:** Always branch off from the latest develop.  
   * **Merging:** Once the feature is complete, tested, and reviewed, it is merged back into develop. The feature branch is then deleted.  
2. **hotfix/\*** (e.g., hotfix/critical-login-bug)  
   * **Purpose:** Used for addressing urgent bugs found in a production release on the main branch.  
   * **Creation:** Always branch off from the corresponding version tag on main.  
   * **Merging:** After the fix is complete, it must be merged into **both** main (and tagged with a new patch version, e.g., v1.0.1) and develop to ensure the fix is not lost in the next release.

## **Development Workflow Example (New Feature)**

1. **Start:** Before beginning work, ensure your local develop branch is up-to-date.  
   git checkout develop  
   git pull origin develop

2. **Create Feature Branch:** Create a new branch for your feature, branching from develop.  
   git checkout \-b feature/new-design-form

3. **Develop:** Work on the feature, making commits as needed. Run tests and quality checks frequently.  
   \# ...write code...  
   git commit \-m "feat: add form components for new design"  
   \# ...write more code...  
   git commit \-m "feat: add form validation logic"

4. **Prepare for Merge:** Once the feature is complete, ensure it is up-to-date with any changes that may have happened in develop while you were working.  
   git checkout develop  
   git pull origin develop  
   git checkout feature/new-design-form  
   git merge develop  
   \# (Resolve any merge conflicts if they exist)

5. **Final Review:** Push your feature branch to GitHub and open a Pull Request (PR) to merge feature/new-design-form into develop. This is the point where a code review would happen.  
6. **Complete Merge:** Once the PR is approved and all automated checks pass, merge the branch into develop.  
7. **Clean Up:** Delete the feature branch.  
   git branch \-d feature/new-design-form  
