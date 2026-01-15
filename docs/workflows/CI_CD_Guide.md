# CI/CD Pipeline Guide

## 🚀 Overview

Our CI/CD pipeline is designed to enforce quality standards automatically while keeping the development process smooth and efficient. The pipeline runs on every push and pull request, ensuring code quality before it reaches production.

## 📋 Pipeline Components

### 1. Quality Checks Job

**Purpose**: Ensures code meets quality standards before testing

**Checks**:

- Environment validation
- ESLint linting
- Prettier formatting
- TypeScript compilation

**When it runs**: Every push and PR
**Timeout**: 10 minutes

### 2. Testing & Coverage Job

**Purpose**: Validates code functionality and ensures adequate test coverage

**Checks**:

- Jest unit tests with coverage
- Vitest tests with coverage
- Coverage reporting to Codecov
- Minimum 80% coverage requirement

**When it runs**: Every push and PR
**Timeout**: 15 minutes

### 3. Security Scanning Job

**Purpose**: Identifies security vulnerabilities in dependencies and code

**Checks**:

- npm audit (moderate+ severity)
- Snyk security scanning
- Dependency vulnerability assessment

**When it runs**: Every push and PR
**Timeout**: 10 minutes

### 4. Dependency Updates Job

**Purpose**: Automatically keeps dependencies up to date

**Features**:

- Weekly automated dependency checks
- Automated PR creation for updates
- Manual trigger capability

**When it runs**: Weekly (Mondays) or manual trigger
**Timeout**: 10 minutes

### 5. Build & Package Job

**Purpose**: Creates production-ready artifacts

**Actions**:

- TypeScript compilation
- Build artifact creation
- Docker image building
- Container testing

**When it runs**: Only on main branch pushes
**Timeout**: 10 minutes

## 🎯 Quality Gates

### Required Status Checks

The following checks must pass before merging:

1. **Quality Checks** ✅
   - ESLint passes
   - Prettier formatting applied
   - TypeScript compilation successful

2. **Testing & Coverage** ✅
   - All tests pass
   - 80% minimum coverage achieved
   - Coverage reports generated

3. **Security Scanning** ✅
   - npm audit passes
   - Snyk scan passes
   - No high-severity vulnerabilities

### Branch Protection Rules

#### Main Branch

- **Required reviews**: 1 approval
- **Stale review dismissal**: Enabled
- **Linear history**: Required
- **Force pushes**: Disabled
- **Deletions**: Disabled

#### Develop Branch

- **Required reviews**: 1 approval
- **Stale review dismissal**: Enabled
- **Linear history**: Optional
- **Force pushes**: Disabled
- **Deletions**: Disabled

## 🔧 Local Development Workflow

### Pre-commit (Automatic)

Husky hooks run automatically on commit:

```bash
# These run automatically
npm run lint
npm run format
npm test
```

### Manual Validation

Before pushing, run the full validation suite:

```bash
npm run validate
```

This command runs:

- Linting
- Formatting
- TypeScript compilation
- All tests
- Coverage checks

### Environment Validation

Ensure your environment is properly configured:

```bash
npm run validate:env
```

## 🚨 Troubleshooting

### Common Issues

#### 1. Linting Failures

**Problem**: ESLint or Prettier errors
**Solution**:

```bash
npm run lint:fix
npm run format
```

#### 2. Test Failures

**Problem**: Tests failing locally or in CI
**Solution**:

```bash
npm test
npm run test:coverage
```

#### 3. Coverage Below 80%

**Problem**: Test coverage insufficient
**Solution**:

- Add tests for uncovered code
- Review coverage report: `npm run test:coverage`
- Focus on critical business logic

#### 4. Security Vulnerabilities

**Problem**: npm audit or Snyk failures
**Solution**:

```bash
npm audit fix
# For Snyk issues, review the detailed report
```

#### 5. TypeScript Compilation Errors

**Problem**: Type errors preventing build
**Solution**:

```bash
npm run build
# Fix type errors in your code
```

### CI/CD Debugging

#### Check Workflow Status

1. Go to GitHub Actions tab
2. Click on the specific workflow run
3. Review job logs for detailed error messages

#### Re-run Failed Jobs

1. Navigate to the failed workflow
2. Click "Re-run jobs" button
3. Select specific jobs to re-run

#### Local CI Simulation

Test the full CI pipeline locally:

```bash
# Install dependencies
npm ci

# Run all quality checks
npm run validate

# Run security checks
npm audit

# Build project
npm run build

# Run Docker tests
docker build -f Dockerfile.dev -t app:test .
docker run --rm app:test npm test
```

## 📊 Monitoring & Metrics

### Coverage Reports

- **Codecov**: Automatic coverage reporting
- **Local**: `npm run test:coverage`
- **Target**: 80% minimum coverage

### Security Metrics

- **npm audit**: Dependency vulnerabilities
- **Snyk**: Code and dependency security
- **Frequency**: Every PR and push

### Performance Metrics

- **Build time**: Target < 10 minutes
- **Test execution**: Target < 5 minutes
- **Pipeline reliability**: Target > 95%

## 🔄 Automated Workflows

### Dependency Updates

- **Schedule**: Weekly (Mondays 09:00 UTC)
- **Scope**: npm, GitHub Actions, Docker
- **Process**: Automated PR creation
- **Review**: Manual approval required

### Security Scanning

- **Frequency**: Every push and PR
- **Tools**: npm audit + Snyk
- **Action**: Block merge on high-severity issues

### Quality Gates

- **Enforcement**: Automatic via branch protection
- **Requirements**: All checks must pass
- **Override**: Admin approval required

## 📝 Best Practices

### For Developers

1. **Run validation locally** before pushing
2. **Write tests** for new functionality
3. **Keep dependencies updated** regularly
4. **Review security reports** promptly
5. **Follow commit conventions** strictly

### For Maintainers

1. **Monitor pipeline health** regularly
2. **Review dependency updates** weekly
3. **Address security issues** immediately
4. **Update documentation** when needed
5. **Optimize pipeline performance** continuously

## 🆘 Getting Help

### Documentation

- [Project Branching Strategy](../Project%20Branching%20Strategy.md)
- [New Developer Onboarding Guide](../New%20Developer%20Onboarding%20Guide.md)
- [IDE Setup Guide](IDE_SETUP.md)

### Support

- **Issues**: Create GitHub issue with `ci-cd` label
- **Discussions**: Use GitHub Discussions for questions
- **Emergency**: Contact maintainers directly

---

**Remember**: The CI/CD pipeline is your friend! It catches issues early and ensures code quality. If you're having trouble, the pipeline is designed to help, not hinder.
