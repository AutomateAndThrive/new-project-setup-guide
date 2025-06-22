# Quick Reference Guide

## 🚀 Getting Started

### Initial Setup

```bash
# Clone the repository
git clone <repository-url>
cd new-project-setup-guide

# Install dependencies
npm install

# Set up Git hooks
npm run prepare

# Validate environment
npm run validate:env
```

### First Time Setup

```bash
# Install recommended VS Code extensions
code --install-extension <extension-id>

# Configure Git (if not already done)
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## 📝 Daily Development Workflow

### Starting a New Feature

```bash
# Update develop branch
git checkout develop
git pull origin develop

# Create feature branch
git checkout -b feature/TASK-ID-description

# Start development
npm run dev
```

### Making Changes

```bash
# Make your changes
# ... edit files ...

# Stage changes
git add .

# Commit with conventional commit message
git commit -m "feat(scope): description of changes"

# Push to remote
git push origin feature/TASK-ID-description
```

### Before Creating a PR

```bash
# Run full validation locally
npm run validate

# Check coverage
npm run test:coverage

# Format code
npm run format

# Lint code
npm run lint
```

## 🔧 Common Commands

### Development

```bash
npm run dev          # Start development server
npm run build        # Build the project
npm start            # Start production server
```

### Testing

```bash
npm test             # Run Jest tests
npm run test:watch   # Run tests in watch mode
npm run test:coverage # Run tests with coverage
npm run test:vitest  # Run Vitest tests
npm run test:vitest:watch # Run Vitest in watch mode
```

### Code Quality

```bash
npm run lint         # Run ESLint
npm run lint:fix     # Fix ESLint issues
npm run format       # Format code with Prettier
npm run format:check # Check formatting
npm run validate     # Run all quality checks
```

### Docker

```bash
npm run docker:dev   # Start development environment
npm run docker:build # Build Docker image
npm run docker:clean # Clean up Docker containers
```

### CI/CD

```bash
npm run ci:full      # Run full CI pipeline locally
npm run ci:lint      # Run linting checks
npm run ci:test      # Run tests with coverage
npm run ci:build     # Run build process
npm run ci:security  # Run security checks
```

## 🐛 Troubleshooting

### Common Issues

#### "Husky hooks not working"

```bash
# Reinstall Husky
npm run prepare

# Check if hooks are installed
ls -la .git/hooks/
```

#### "Tests failing locally but passing in CI"

```bash
# Clear cache and reinstall
rm -rf node_modules package-lock.json
npm install

# Run tests in CI mode
npm run ci:test
```

#### "Coverage below 80%"

```bash
# Check coverage report
npm run test:coverage

# Add tests for uncovered code
# Focus on critical business logic
```

#### "Dependency conflicts"

```bash
# Clear npm cache
npm cache clean --force

# Remove node_modules and reinstall
rm -rf node_modules package-lock.json
npm install
```

#### "Git issues"

```bash
# Reset to clean state
git reset --hard HEAD
git clean -fd

# Update from remote
git fetch origin
git reset --hard origin/develop
```

## 📋 PR Checklist

### Before Submitting

- [ ] All tests pass (`npm test`)
- [ ] Coverage meets 80% minimum (`npm run test:coverage`)
- [ ] Code is formatted (`npm run format`)
- [ ] Linting passes (`npm run lint`)
- [ ] TypeScript compilation successful (`npm run build`)
- [ ] No console.log statements in production code
- [ ] Documentation updated if needed

### PR Description Template

```markdown
## 🎯 Description

What does this PR do?

## 🔍 Changes Made

- [ ] Change 1
- [ ] Change 2

## 🧪 Testing

How was this tested?

## 📊 Impact

- [ ] No breaking changes
- [ ] Performance impact assessed
- [ ] Security reviewed
```

## 🔐 Security Best Practices

### Before Committing

- [ ] No sensitive data in code
- [ ] No hardcoded secrets
- [ ] Input validation implemented
- [ ] Dependencies checked for vulnerabilities (`npm audit`)

### Environment Variables

```bash
# Never commit .env files
# Use .env.example for documentation
# Use CI/CD secrets for sensitive data
```

## 📝 Code Documentation Standards

### General Principles

- All public modules, classes, functions, and exported types must be documented.
- Use [JSDoc](https://jsdoc.app/) or [TSDoc](https://tsdoc.org/) for TypeScript code.
- Write clear, concise docstrings explaining the purpose, parameters, return values, and side effects.
- Document assumptions, edge cases, and error conditions.
- Keep documentation up to date with code changes.

### JSDoc/TSDoc Example

```ts
/**
 * Validates an email address.
 * @param email - The email string to validate.
 * @returns True if valid, false otherwise.
 * @throws {TypeError} If input is not a string.
 */
function validateEmail(email: string): boolean {
  // ...
}
```

### Module and File Headers

- Every module/file should start with a summary comment describing its purpose and usage.

```ts
/**
 * Utility functions for string validation and formatting.
 * Used throughout the backend for input validation.
 */
```

### API Documentation

- All API endpoints must be documented in the API reference docs.
- Use OpenAPI/Swagger comments if applicable.
- Document request/response schemas, status codes, and error cases.

### Expectations

- PRs adding new modules, functions, or APIs must include documentation.
- Outdated or missing documentation is a blocker for merge.
- Use the [Commit Message Guide](Commit_Message_Guide.md) for documenting doc changes.

## 📚 Useful Resources

### Documentation

- [Project Branching Strategy](../Project%20Branching%20Strategy.md)
- [CI/CD Guide](CI_CD_Guide.md)
- [IDE Setup Guide](IDE_SETUP.md)
- [New Developer Onboarding Guide](../New%20Developer%20Onboarding%20Guide.md)

### External Resources

- [Conventional Commits](https://www.conventionalcommits.org/)
- [ESLint Rules](https://eslint.org/docs/rules/)
- [Prettier Configuration](https://prettier.io/docs/en/configuration.html)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)

## 🆘 Getting Help

### When to Ask for Help

- Tests failing and you can't figure out why
- CI/CD pipeline issues
- Security concerns
- Performance problems
- Architecture decisions

### How to Ask for Help

1. **Search existing documentation first**
2. **Check GitHub Issues for similar problems**
3. **Create a detailed issue with:**
   - What you're trying to do
   - What's happening
   - What you've tried
   - Error messages/logs
   - Environment details

### Emergency Contacts

- **Security issues**: Contact maintainers immediately
- **Production issues**: Follow hotfix workflow
- **CI/CD problems**: Check [CI/CD Guide](CI_CD_Guide.md)

---

**Remember**: This guide is a living document. If you find something missing or incorrect, please update it!
