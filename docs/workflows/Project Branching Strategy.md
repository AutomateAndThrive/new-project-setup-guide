# Project Branching Strategy

This document outlines the **simplified Git branching strategy** for solo developers and small teams, ensuring consistent development practices without unnecessary complexity.

## ⚠️ Important: Default Branch is develop

**Please note that this repository uses `develop` as its default and primary integration branch, not `main`. All feature branches and bug fixes should be based on `develop`, and all Pull Requests should target `develop`. The `main` branch is reserved for stable, tagged production releases only.**

## 🎯 Overview

Our branching strategy follows a **simplified Git Flow** approach, optimized for small teams and solo developers. This strategy ensures:

- **Stable production releases** with minimal bugs
- **Parallel development** of multiple features
- **Clear separation** between development and production code
- **Easy rollback** capabilities for critical issues
- **Automated quality gates** to prevent technical debt

## 🌿 Branch Structure

### Main Branches

#### `main` (Production)

- **Purpose**: Contains production-ready code
- **Source**: Merged from `develop` branch
- **Protection**:
  - Requires pull request reviews
  - Requires status checks to pass
  - No direct pushes allowed
- **Tagging**: Each merge to main creates a version tag (v1.0.0, v1.1.0, etc.)

#### `develop` (Integration) ⭐ **DEFAULT BRANCH**

- **Purpose**: Integration branch for features and bug fixes
- **Source**: Merged from `feature/*` and `bugfix/*` branches
- **Protection**:
  - Requires pull request reviews
  - Requires tests to pass
  - Requires code coverage > 80%
- **Deployment**: Automatically deployed to staging environment

### Supporting Branches

#### `feature/*` (Feature Development)

- **Purpose**: Develop new features for the application
- **Source**: Created from `develop`
- **Naming**: `feature/TASK-ID-descriptive-name`
- **Examples**:
  - `feature/AI-001-design-analysis`
  - `feature/FRONTEND-004-upload-component`
  - `feature/BACKEND-005-api-integration`

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
  - `hotfix/v1.0.1-security-fix`
  - `hotfix/v1.0.2-api-crash`

## 📊 Branch Protection Rules

| Branch     | Purpose             | PR Required? | Approvals | Status Checks | Direct Pushes |
| ---------- | ------------------- | ------------ | --------- | ------------- | ------------- |
| `main`     | Production Releases | Yes          | 2         | Required      | Not Allowed   |
| `develop`  | Feature Integration | Yes          | 1         | Required      | Not Allowed   |
| `hotfix/*` | Production Bugfixes | Yes          | 2         | Required      | Not Allowed   |

## 🔄 Visual Workflow

```mermaid
gitGraph
   commit id: "Initial"
   branch develop
   commit id: "dev-init"
   branch feature/AI-001
   commit id: "feat-1"
   commit id: "feat-2"
   checkout develop
   merge feature/AI-001 id: "merge-feat"
   checkout main
   merge develop id: "merge-release"
   tag "v1.0.0"
   checkout develop
   branch hotfix/v1.0.1
   commit id: "hotfix"
   checkout main
   merge hotfix/v1.0.1 id: "merge-hotfix-main"
   tag "v1.0.1"
   checkout develop
   merge hotfix/v1.0.1 id: "merge-hotfix-dev"
```

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

1. **Prepare Release**

   ```bash
   # Ensure develop is stable
   git checkout develop
   git pull origin develop

   # Create release commit
   git commit -m "chore: prepare release v1.1.0"
   git push origin develop
   ```

2. **Merge to Main**
   ```bash
   # Create PR from develop to main
   # After approval and merge:
   git checkout main
   git pull origin main
   git tag v1.1.0
   git push origin main --tags
   ```

### Hotfix Workflow

**⚠️ Critical: Follow this checklist exactly to avoid losing fixes**

- [ ] Create hotfix/vX.X.X branch from main
- [ ] Implement and commit the fix
- [ ] Create a Pull Request targeting main
- [ ] After approval, merge the PR into main
- [ ] Immediately create a new Git tag for the release (e.g., `git tag v1.0.1`)
- [ ] Push the tag to the remote (`git push origin --tags`)
- [ ] Immediately create a second Pull Request from the hotfix branch targeting develop
- [ ] Merge the second PR into develop to ensure the fix is not lost in the next release
- [ ] Delete the hotfix/\* branch

#### Hotfix Example

```bash
# 1. Create hotfix branch from main
git checkout main
git pull origin main
git checkout -b hotfix/v1.0.1-security-fix

# 2. Fix the issue
git add .
git commit -m "fix: resolve critical security vulnerability"

# 3. Push and create PR to main
git push origin hotfix/v1.0.1-security-fix

# 4. After merging to main, tag the release
git checkout main
git pull origin main
git tag v1.0.1
git push origin main --tags

# 5. Create PR to develop
git checkout hotfix/v1.0.1-security-fix
git push origin hotfix/v1.0.1-security-fix

# 6. After merging to develop, delete the branch
git branch -d hotfix/v1.0.1-security-fix
git push origin --delete hotfix/v1.0.1-security-fix
```

## 📝 Commit Message Convention

We follow the **Conventional Commits** specification for consistent commit messages:

### Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Types

- **feat**: A new feature
- **fix**: A bug fix
- **docs**: Documentation only changes
- **style**: Changes that do not affect the meaning of the code
- **refactor**: A code change that neither fixes a bug nor adds a feature
- **perf**: A code change that improves performance
- **test**: Adding missing tests or correcting existing tests
- **chore**: Changes to the build process or auxiliary tools

### Examples

```bash
git commit -m "feat(AI): implement design analysis with Gemini API"
git commit -m "fix(frontend): resolve upload validation issue"
git commit -m "docs: update API documentation"
git commit -m "test: add unit tests for user authentication"
git commit -m "chore: update dependencies"
```

### Tools for Conventional Commits

- **Commitizen**: Interactive commit message creation
- **Commitlint**: Validate commit messages
- **Husky**: Pre-commit hooks for enforcement

## 🔧 Automated Quality Gates

### Pre-commit Hooks

- **ESLint**: Code linting and style checking
- **Prettier**: Code formatting
- **TypeScript**: Type checking
- **Tests**: Run unit tests
- **Commitlint**: Validate commit messages

### Pull Request Requirements

- **Code Review**: At least one approval required
- **Status Checks**: All CI/CD checks must pass
- **Code Coverage**: Minimum 80% coverage required
- **Security Scan**: Automated security vulnerability check

## 🚨 Troubleshooting

### Common Issues

#### "Branch protection rules prevent pushing"

- **Solution**: Create a pull request instead of direct push
- **Prevention**: Always use feature branches and PRs

#### "Tests failing in CI but passing locally"

- **Solution**: Run `npm run test:ci` locally to match CI environment
- **Prevention**: Use Docker for consistent development environment

#### "Merge conflicts in develop"

- **Solution**: Rebase your feature branch on latest develop
- **Prevention**: Keep feature branches short-lived and up-to-date

#### "Forgot to merge hotfix to develop"

- **Solution**: Cherry-pick the hotfix commit to develop
- **Prevention**: Follow the hotfix checklist exactly

### Debugging Failed CI/CD Checks

See the [CI/CD Guide](docs/development/CI_CD_Guide.md) for detailed debugging information.

## 📚 Additional Resources

- **[Conventional Commits](https://www.conventionalcommits.org/)**: Commit message specification
- **[Git Flow](https://nvie.com/posts/a-successful-git-branching-model/)**: Original Git Flow model
- **[GitHub Flow](https://guides.github.com/introduction/flow/)**: Alternative simplified workflow

---

_This branching strategy is designed for modern software projects and may be updated as the project evolves._

_Last updated: January 2025_
_Version: 1.0.0_
