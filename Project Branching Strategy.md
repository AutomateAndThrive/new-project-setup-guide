# Project Branching Strategy - Pixel to Profit

This document outlines the Git branching strategy and workflow for the Pixel to Profit project, ensuring consistent development practices across the team.

## 🎯 Overview

Our branching strategy follows a **Git Flow** approach, adapted for the specific needs of our AI-powered print-on-demand listing automation tool. This strategy ensures:

- **Stable production releases** with minimal bugs
- **Parallel development** of multiple features
- **Clear separation** between development and production code
- **Easy rollback** capabilities for critical issues
- **Continuous integration** and deployment readiness

## 🌿 Branch Structure

### Main Branches

#### `main` (Production)
- **Purpose**: Contains production-ready code
- **Source**: Merged from `develop` or `hotfix/*` branches
- **Protection**: 
  - Requires pull request reviews
  - Requires status checks to pass
  - No direct pushes allowed
- **Tagging**: Each merge to main creates a version tag (v1.0.0, v1.1.0, etc.)

#### `develop` (Integration)
- **Purpose**: Integration branch for features and bug fixes
- **Source**: Merged from `feature/*` and `bugfix/*` branches
- **Protection**: 
  - Requires pull request reviews
  - Requires tests to pass
- **Deployment**: Automatically deployed to staging environment

### Supporting Branches

#### `feature/*` (Feature Development)
- **Purpose**: Develop new features for the application
- **Source**: Created from `develop`
- **Naming**: `feature/TASK-ID-descriptive-name`
- **Examples**:
  - `feature/AI-001-design-analysis`
  - `feature/FRONTEND-004-upload-component`
  - `feature/BACKEND-005-gemini-integration`

#### `bugfix/*` (Bug Fixes)
- **Purpose**: Fix bugs found in development
- **Source**: Created from `develop`
- **Naming**: `bugfix/TASK-ID-description`
- **Examples**:
  - `bugfix/FRONTEND-upload-validation`
  - `bugfix/BACKEND-api-timeout`

#### `hotfix/*` (Critical Production Fixes)
- **Purpose**: Fix critical bugs in production
- **Source**: Created from `main`
- **Naming**: `hotfix/version-description`
- **Examples**:
  - `hotfix/v1.0.1-gemini-api-fix`
  - `hotfix/v1.0.2-upload-security`

#### `release/*` (Release Preparation)
- **Purpose**: Prepare for a new production release
- **Source**: Created from `develop`
- **Naming**: `release/version-number`
- **Examples**:
  - `release/v1.1.0`
  - `release/v1.2.0`

## 🔄 Workflow

### Feature Development Workflow

1. **Start Feature Development**
   ```bash
   # Ensure develop is up to date
   git checkout develop  
   git pull origin develop

   # Create feature branch
   git checkout -b feature/AI-001-design-analysis
   ```

2. **Develop and Commit**
   ```bash
   # Make your changes
   git add .
   git commit -m "feat(AI): implement design analysis with Gemini API"
   
   # Push to remote
   git push origin feature/AI-001-design-analysis
   ```

3. **Create Pull Request**
   - Create PR from `feature/AI-001-design-analysis` to `develop`
   - Add appropriate labels and assignees
   - Request code review
   - Ensure all tests pass

4. **Code Review and Merge**
   - Address review comments
   - Squash commits if needed
   - Merge to `develop`
   - Delete feature branch

### Bug Fix Workflow

1. **Create Bug Fix Branch**
   ```bash
   git checkout develop
   git pull origin develop
   git checkout -b bugfix/FRONTEND-upload-validation
   ```

2. **Fix and Test**
   ```bash
   # Make fixes
   git add .
   git commit -m "fix(frontend): validate file types before upload"
   
   # Push and create PR
   git push origin bugfix/FRONTEND-upload-validation
   ```

3. **Review and Merge**
   - Create PR to `develop`
   - Review and merge
   - Delete bug fix branch

### Release Workflow

1. **Create Release Branch**
   ```bash
   git checkout develop  
   git pull origin develop  
   git checkout -b release/v1.1.0
   ```

2. **Prepare Release**
   - Update version numbers
   - Update changelog
   - Final testing and bug fixes
   - Update documentation

3. **Merge to Main and Develop**
   ```bash
   # Merge to main
   git checkout main
   git merge release/v1.1.0
   git tag v1.1.0
   git push origin main --tags
   
   # Merge to develop
   git checkout develop
   git merge release/v1.1.0
   git push origin develop
   
   # Delete release branch
   git branch -d release/v1.1.0
   ```

### Hotfix Workflow

1. **Create Hotfix Branch**
   ```bash
   git checkout main
   git pull origin main
   git checkout -b hotfix/v1.0.1-critical-fix
   ```

2. **Fix Critical Issue**
   ```bash
   # Make critical fix
   git add .
   git commit -m "fix: resolve critical Gemini API timeout issue"
   
   # Push and create PR
   git push origin hotfix/v1.0.1-critical-fix
   ```

3. **Merge to Main and Develop**
   ```bash
   # Merge to main
   git checkout main
   git merge hotfix/v1.0.1-critical-fix
   git tag v1.0.1
   git push origin main --tags
   
   # Merge to develop
   git checkout develop
   git merge hotfix/v1.0.1-critical-fix
   git push origin develop
   
   # Delete hotfix branch
   git branch -d hotfix/v1.0.1-critical-fix
   ```

## 📝 Commit Message Convention

We follow the **Conventional Commits** specification:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Types
- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation changes
- **style**: Code style changes (formatting, etc.)
- **refactor**: Code refactoring
- **test**: Adding or updating tests
- **chore**: Maintenance tasks

### Examples
```bash
feat(AI): implement design analysis with Gemini API
fix(frontend): resolve upload validation issue
docs(api): update API documentation
refactor(backend): optimize database queries
test(gemini): add unit tests for image analysis
chore(deps): update dependencies
```

## 🏷️ Versioning Strategy

We follow **Semantic Versioning** (SemVer):

- **MAJOR.MINOR.PATCH**
- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

### Version Examples
- `v1.0.0`: Initial MVP release
- `v1.1.0`: Added color visualizer feature
- `v1.1.1`: Fixed upload validation bug
- `v2.0.0`: Breaking changes in API

## 🔒 Branch Protection Rules

### Main Branch
- **Require pull request reviews**: 2 approvals minimum
- **Require status checks to pass**: All CI/CD checks
- **Require branches to be up to date**: Before merging
- **Restrict pushes**: No direct pushes allowed
- **Include administrators**: Apply rules to admins too

### Develop Branch
- **Require pull request reviews**: 1 approval minimum
- **Require status checks to pass**: All tests must pass
- **Require branches to be up to date**: Before merging
- **Restrict pushes**: No direct pushes allowed

## 🚀 CI/CD Integration

### Automated Checks
- **Linting**: ESLint for frontend, ESLint for backend
- **Testing**: Jest for backend, Vitest for frontend
- **Type Checking**: TypeScript compilation
- **Build Verification**: Ensure build succeeds
- **Security Scanning**: Dependency vulnerability checks

### Deployment Pipeline
- **Feature Branches**: Deploy to feature environment
- **Develop Branch**: Deploy to staging environment
- **Main Branch**: Deploy to production environment

## 📋 Pull Request Guidelines

### Required Elements
- **Clear title**: Descriptive of the change
- **Detailed description**: What, why, and how
- **Task reference**: Link to related task/issue
- **Screenshots**: For UI changes
- **Testing notes**: How to test the changes

### Review Checklist
- [ ] Code follows project standards
- [ ] Tests are included and passing
- [ ] Documentation is updated
- [ ] No breaking changes (or documented)
- [ ] Performance impact considered
- [ ] Security implications reviewed

## 🎯 Team Collaboration

### Daily Workflow
1. **Start of day**: Pull latest changes from `develop`
2. **During development**: Commit frequently with clear messages
3. **End of day**: Push changes and create/update PRs

### Weekly Process
1. **Monday**: Review and merge completed features
2. **Wednesday**: Mid-week progress review
3. **Friday**: Prepare for next week's planning

### Release Planning
1. **Two weeks before release**: Feature freeze on `develop`
2. **One week before release**: Create release branch
3. **Release day**: Merge to main and tag

## 🆘 Troubleshooting

### Common Issues

#### Merge Conflicts
```bash
# Resolve conflicts
git status
# Edit conflicted files
git add .
git commit -m "resolve merge conflicts"
```

#### Reverting Changes
```bash
# Revert last commit
git revert HEAD

# Revert specific commit
git revert <commit-hash>
```

#### Emergency Hotfix
```bash
# Create hotfix from main
git checkout main
git checkout -b hotfix/emergency-fix
# Make fix and follow hotfix workflow
```

## 📚 Resources

- **Git Flow Documentation**: https://nvie.com/posts/a-successful-git-branching-model/
- **Conventional Commits**: https://www.conventionalcommits.org/
- **Semantic Versioning**: https://semver.org/
- **GitHub Flow**: https://guides.github.com/introduction/flow/

---

*This branching strategy is designed specifically for the Pixel to Profit project and may be updated as the project evolves.*

*Last updated: January 2025*
*Version: 1.0.0*
