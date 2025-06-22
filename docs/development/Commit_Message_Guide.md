# Commit Message Guide

## 🎯 Overview

We follow the **Conventional Commits** specification for consistent, readable commit messages that work well with automated tools and human readers.

## 📝 Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

## 🔤 Types

### Primary Types

| Type       | Description                           | Example                                            |
| ---------- | ------------------------------------- | -------------------------------------------------- |
| `feat`     | A new feature                         | `feat(auth): add OAuth2 login`                     |
| `fix`      | A bug fix                             | `fix(api): resolve timeout issue`                  |
| `docs`     | Documentation changes                 | `docs: update README with setup instructions`      |
| `style`    | Code style changes (formatting, etc.) | `style: format code with Prettier`                 |
| `refactor` | Code refactoring                      | `refactor(utils): extract common validation logic` |
| `perf`     | Performance improvements              | `perf(db): optimize database queries`              |
| `test`     | Adding or updating tests              | `test(auth): add unit tests for login`             |
| `chore`    | Build process or tooling changes      | `chore: update dependencies`                       |

### Special Types

| Type     | Description              | Example                                |
| -------- | ------------------------ | -------------------------------------- |
| `ci`     | CI/CD changes            | `ci: add GitHub Actions workflow`      |
| `build`  | Build system changes     | `build: update webpack configuration`  |
| `revert` | Revert a previous commit | `revert: feat(auth): add OAuth2 login` |

## 🏷️ Scopes

Scopes are optional but recommended for clarity. Use lowercase and be specific:

### Common Scopes

| Scope  | Description            | Example                            |
| ------ | ---------------------- | ---------------------------------- |
| `auth` | Authentication related | `feat(auth): add password reset`   |
| `api`  | API endpoints          | `fix(api): handle rate limiting`   |
| `ui`   | User interface         | `feat(ui): add dark mode toggle`   |
| `db`   | Database related       | `perf(db): add database indexes`   |
| `test` | Testing related        | `test(api): add integration tests` |
| `ci`   | CI/CD related          | `ci: add automated testing`        |
| `deps` | Dependencies           | `chore(deps): update React to v18` |

### Project-Specific Scopes

- `frontend` - Frontend application
- `backend` - Backend application
- `mobile` - Mobile application
- `admin` - Admin panel
- `docs` - Documentation

## ✍️ Writing Good Descriptions

### Do's ✅

- **Use imperative mood** (like giving commands)
- **Keep it under 50 characters** for the first line
- **Start with lowercase** (no capital letters)
- **Don't end with a period**
- **Be specific and descriptive**

### Don'ts ❌

- **Don't use past tense** ("added", "fixed")
- **Don't be vague** ("update", "fix stuff")
- **Don't use capital letters** at the start
- **Don't end with punctuation**

### Examples

| ✅ Good                                        | ❌ Bad                                            |
| ---------------------------------------------- | ------------------------------------------------- |
| `feat(auth): add password reset functionality` | `feat(auth): Added password reset functionality.` |
| `fix(api): resolve timeout in user endpoint`   | `fix(api): Fixed timeout issue`                   |
| `docs: update installation instructions`       | `docs: Updated installation instructions`         |
| `test(utils): add validation tests`            | `test(utils): Added some tests`                   |

## 📄 Body

Use the body for detailed explanations when the description isn't enough:

```bash
git commit -m "feat(auth): add OAuth2 login

- Integrate with Google OAuth2 provider
- Add user profile creation on first login
- Implement session management
- Add logout functionality

Closes #123"
```

### Body Guidelines

- **Separate from description** with a blank line
- **Use imperative mood** like the description
- **Explain what and why**, not how
- **Reference issues** when applicable

## 🔗 Footer

Use footers for metadata and breaking changes:

```bash
git commit -m "feat(api): change user endpoint response format

BREAKING CHANGE: The /api/users endpoint now returns user objects
instead of arrays. Update your frontend code accordingly.

Closes #456
Fixes #789"
```

### Common Footer Keywords

- `Closes #123` - Closes an issue
- `Fixes #456` - Fixes a bug
- `Relates to #789` - Related to an issue
- `BREAKING CHANGE:` - Indicates breaking changes

## 🔧 Tools

### Interactive Commit Creation

```bash
# Install Commitizen (if not already installed)
npm install -g commitizen

# Use interactive commit
git cz
```

### Validation

Our project uses **Commitlint** to validate commit messages. It will:

- ✅ Accept valid conventional commits
- ❌ Reject invalid formats
- ⚠️ Warn about common issues

### Pre-commit Hooks

Husky automatically runs commit validation before each commit:

```bash
# This will be run automatically
npm run commitlint
```

## 📋 Quick Reference

### Common Patterns

```bash
# New feature
git commit -m "feat(scope): add new functionality"

# Bug fix
git commit -m "fix(scope): resolve specific issue"

# Documentation
git commit -m "docs: update documentation"

# Code style
git commit -m "style: format code"

# Refactoring
git commit -m "refactor(scope): improve code structure"

# Performance
git commit -m "perf(scope): optimize performance"

# Testing
git commit -m "test(scope): add tests"

# Dependencies
git commit -m "chore(deps): update package versions"

# CI/CD
git commit -m "ci: add automated workflow"
```

### Breaking Changes

```bash
git commit -m "feat(api): change response format

BREAKING CHANGE: API now returns objects instead of arrays.
Update your frontend code to handle the new format."
```

### Multiple Issues

```bash
git commit -m "fix(auth): resolve login and logout issues

Closes #123
Fixes #456
Relates to #789"
```

## 🚨 Common Mistakes

### 1. Wrong Tense

```bash
# ❌ Wrong
git commit -m "feat: added new feature"

# ✅ Correct
git commit -m "feat: add new feature"
```

### 2. Too Vague

```bash
# ❌ Wrong
git commit -m "fix: fix stuff"

# ✅ Correct
git commit -m "fix(api): resolve timeout in user endpoint"
```

### 3. Missing Scope

```bash
# ❌ Less clear
git commit -m "feat: add authentication"

# ✅ More clear
git commit -m "feat(auth): add OAuth2 login"
```

### 4. Too Long Description

```bash
# ❌ Too long
git commit -m "feat: add comprehensive user authentication system with OAuth2 support"

# ✅ Better
git commit -m "feat(auth): add OAuth2 authentication system"
```

## 🎯 Best Practices

1. **Be consistent** - Use the same format every time
2. **Be specific** - Describe exactly what changed
3. **Use scopes** - Help categorize changes
4. **Keep it short** - Under 50 characters for description
5. **Use body for details** - When description isn't enough
6. **Reference issues** - Link to GitHub issues when relevant
7. **Test locally** - Run `npm run commitlint` to validate

## 📚 Resources

- [Conventional Commits Specification](https://www.conventionalcommits.org/)
- [Angular Commit Guidelines](https://github.com/angular/angular/blob/main/CONTRIBUTING.md#-commit-message-format)
- [Commitizen](https://github.com/commitizen/cz-cli)
- [Commitlint](https://github.com/conventional-changelog/commitlint)

---

**Remember**: Good commit messages help your team understand the project's history and make automated tools more effective!
