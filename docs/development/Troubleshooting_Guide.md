# Troubleshooting Guide

This guide helps you resolve common issues that may arise when working with this project setup.

## 🚨 Quick Fixes

### **Pre-commit Hooks Not Working**

**Symptoms:**

- Commits go through even with linting errors
- No pre-commit checks running

**Solutions:**

```bash
# 1. Reinstall Husky hooks
npm run prepare

# 2. Check if hooks are executable
ls -la .husky/

# 3. If hooks aren't executable, fix permissions
chmod +x .husky/pre-commit
chmod +x .husky/commit-msg
```

### **Tests Failing Locally but Passing in CI**

**Symptoms:**

- Tests pass in GitHub Actions but fail locally
- Different behavior between environments

**Solutions:**

```bash
# 1. Clean install dependencies
rm -rf node_modules package-lock.json
npm ci

# 2. Check Node.js version matches CI
node --version  # Should be >= 18.0.0

# 3. Clear test cache
npm run test -- --clearCache
```

### **TypeScript Errors in VS Code**

**Symptoms:**

- Red squiggles in VS Code but no errors in terminal
- TypeScript language server issues

**Solutions:**

1. **Restart TypeScript Language Server:**

   - `Cmd+Shift+P` (Mac) or `Ctrl+Shift+P` (Windows/Linux)
   - Type "TypeScript: Restart TS Server"
   - Press Enter

2. **Reload VS Code Window:**

   - `Cmd+Shift+P` → "Developer: Reload Window"

3. **Check TypeScript Version:**
   ```bash
   npx tsc --version
   ```

## 🔧 Common Issues

### **ESLint Configuration Issues**

**Problem:** ESLint errors about TypeScript configuration

**Solution:**

```bash
# Check if TypeScript files are included in tsconfig.json
cat tsconfig.json

# If not, add them to the include array
```

**Problem:** ESLint can't find configuration

**Solution:**

```bash
# Check if .eslintrc.js exists
ls -la .eslintrc.js

# If missing, copy from template or reinstall
npm install
```

### **Prettier Conflicts**

**Problem:** Prettier and ESLint disagree on formatting

**Solution:**

```bash
# 1. Install eslint-config-prettier
npm install --save-dev eslint-config-prettier

# 2. Make sure it's last in your ESLint extends array
# In .eslintrc.js:
# extends: [
#   'eslint:recommended',
#   '@typescript-eslint/recommended',
#   'prettier'  // This should be last
# ]
```

### **Docker Issues**

**Problem:** Docker containers won't start

**Solution:**

```bash
# 1. Check if Docker is running
docker --version

# 2. Clean up containers and volumes
docker-compose down -v

# 3. Rebuild containers
docker-compose up --build
```

**Problem:** Port conflicts

**Solution:**

```bash
# Check what's using the port
lsof -i :3000  # or whatever port you're using

# Kill the process or change the port in docker-compose.yml
```

### **Git Issues**

**Problem:** Can't push to protected branch

**Solution:**

1. Create a feature branch: `git checkout -b feature/your-feature`
2. Make your changes and commit
3. Push the feature branch: `git push origin feature/your-feature`
4. Create a pull request

**Problem:** Commit message rejected

**Solution:**

```bash
# Use conventional commit format
git commit -m "feat: add new user authentication"

# Valid types: feat, fix, docs, style, refactor, test, chore
```

### **Coverage Issues**

**Problem:** Coverage below 80% threshold

**Solution:**

```bash
# 1. Run coverage report
npm run test:coverage

# 2. Look for uncovered files/lines
# 3. Add tests for uncovered code
# 4. Or exclude files that don't need testing in jest.config.js
```

## 🐛 Debugging

### **Enable Verbose Logging**

**For ESLint:**

```bash
npm run lint -- --debug
```

**For Prettier:**

```bash
npm run format -- --debug-check
```

**For Tests:**

```bash
npm run test -- --verbose
```

### **Check Configuration Files**

**Verify all config files exist:**

```bash
ls -la .eslintrc.js .prettierrc tsconfig.json jest.config.js vitest.config.ts
```

**Check package.json scripts:**

```bash
npm run
```

### **Environment Issues**

**Check Node.js version:**

```bash
node --version
npm --version
```

**Check global packages:**

```bash
npm list -g --depth=0
```

## 🔍 Advanced Troubleshooting

### **Performance Issues**

**Slow test execution:**

```bash
# Run tests in parallel
npm run test -- --maxWorkers=4

# Use watch mode for development
npm run test:watch
```

**Slow linting:**

```bash
# Lint only changed files
npm run lint -- --cache

# Use lint-staged (already configured)
```

### **CI/CD Issues**

**GitHub Actions failing:**

1. Check the Actions tab in GitHub
2. Look at the specific step that failed
3. Reproduce locally with the same Node.js version
4. Check if secrets are properly configured

**Dependabot issues:**

1. Check `.github/dependabot.yml` configuration
2. Ensure the repository has proper permissions
3. Check if there are any security policy restrictions

### **Security Issues**

**npm audit warnings:**

```bash
# Check for vulnerabilities
npm audit

# Fix automatically (if possible)
npm audit fix

# For major version updates
npm audit fix --force
```

## 📞 Getting Help

### **Before Asking for Help**

1. **Check this guide** for your specific issue
2. **Search existing issues** on GitHub
3. **Try the quick fixes** above
4. **Check the logs** for error messages

### **When Creating an Issue**

Include:

- **Error message** (full text)
- **Steps to reproduce**
- **Environment details** (OS, Node.js version, etc.)
- **What you've already tried**

### **Useful Commands for Debugging**

```bash
# Check system information
node --version
npm --version
git --version
docker --version

# Check project status
npm run validate
git status
npm audit

# Check configuration
cat package.json | grep -A 10 -B 10 "scripts"
cat .eslintrc.js
cat tsconfig.json
```

## 🎯 Prevention

### **Best Practices**

1. **Always run tests before committing**
2. **Use conventional commit messages**
3. **Keep dependencies updated**
4. **Follow the branching strategy**
5. **Document any custom configurations**

### **Regular Maintenance**

```bash
# Weekly: Update dependencies
npm update

# Monthly: Check for security issues
npm audit

# Quarterly: Review and update documentation
# Check if this troubleshooting guide needs updates
```

---

_This guide is maintained by the development team. If you find a solution that's not documented here, please contribute it!_
