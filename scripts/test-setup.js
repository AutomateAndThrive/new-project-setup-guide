#!/usr/bin/env node

/**
 * Comprehensive test suite for the new-project-setup-guide
 * Run this after each phase to validate the setup
 */

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

const colors = {
  green: '\x1b[32m',
  red: '\x1b[31m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  reset: '\x1b[0m',
  bold: '\x1b[1m',
};

function log(message, color = colors.reset) {
  console.log(`${color}${message}${colors.reset}`);
}

function runCommand(command, description) {
  try {
    log(`\n${colors.blue}${description}...${colors.reset}`);
    const result = execSync(command, { encoding: 'utf8', stdio: 'pipe' });
    log(`✅ ${description} - PASSED`, colors.green);
    return { success: true, output: result };
  } catch (error) {
    log(`❌ ${description} - FAILED`, colors.red);
    log(`Error: ${error.message}`, colors.red);
    return { success: false, output: error.stdout || error.stderr };
  }
}

function checkFileExists(filePath, description) {
  const exists = fs.existsSync(filePath);
  if (exists) {
    log(`✅ ${description} - EXISTS`, colors.green);
  } else {
    log(`❌ ${description} - MISSING`, colors.red);
  }
  return exists;
}

function checkPackageJsonScripts() {
  try {
    const packageJson = JSON.parse(fs.readFileSync('package.json', 'utf8'));
    const requiredScripts = ['lint', 'format', 'test-setup'];
    const missingScripts = requiredScripts.filter((script) => !packageJson.scripts[script]);

    if (missingScripts.length === 0) {
      log(`✅ Package.json scripts - ALL PRESENT`, colors.green);
      return true;
    } else {
      log(`❌ Package.json scripts - MISSING: ${missingScripts.join(', ')}`, colors.red);
      return false;
    }
  } catch (error) {
    log(`❌ Package.json scripts - ERROR READING FILE`, colors.red);
    return false;
  }
}

function testGitHooks() {
  log(`\n${colors.bold}Testing Git Hooks...${colors.reset}`);

  // Create a test file
  const testFile = 'test-hook-validation.md';
  fs.writeFileSync(testFile, '# Test file for hook validation');

  try {
    // Test pre-commit hook
    execSync('git add test-hook-validation.md', { stdio: 'pipe' });
    log(`✅ Git add - SUCCESS`, colors.green);

    // Test commit with valid message
    execSync('git commit -m "test: validate git hooks"', { stdio: 'pipe' });
    log(`✅ Valid commit - SUCCESS`, colors.green);

    // Test commit with invalid message
    try {
      execSync('git commit -m "invalid message"', { stdio: 'pipe' });
      log(`❌ Invalid commit - SHOULD HAVE FAILED`, colors.red);
      return false;
    } catch (error) {
      log(`✅ Invalid commit - CORRECTLY REJECTED`, colors.green);
    }

    // Clean up
    execSync('git reset --hard HEAD~1', { stdio: 'pipe' });

    // Remove test file if it still exists
    if (fs.existsSync(testFile)) {
      fs.unlinkSync(testFile);
    }

    return true;
  } catch (error) {
    log(`❌ Git hooks test - FAILED: ${error.message}`, colors.red);
    // Clean up test file if it exists
    if (fs.existsSync(testFile)) {
      fs.unlinkSync(testFile);
    }
    return false;
  }
}

function main() {
  log(
    `${colors.bold}🧪 NEW PROJECT SETUP GUIDE - COMPREHENSIVE TEST SUITE${colors.reset}`,
    colors.blue,
  );
  log(`Running tests for all implemented phases...\n`);

  let allTestsPassed = true;

  // Phase 1.1 Tests - Automated Code Quality Setup
  log(`${colors.bold}📋 Phase 1.1 - Automated Code Quality Setup${colors.reset}`, colors.yellow);

  // Check required files exist
  const requiredFiles = [
    { path: 'package.json', description: 'Package.json' },
    { path: '.eslintrc.js', description: 'ESLint config' },
    { path: 'tsconfig.json', description: 'TypeScript config' },
    { path: '.prettierrc', description: 'Prettier config' },
    { path: '.husky/pre-commit', description: 'Husky pre-commit hook' },
    { path: '.husky/commit-msg', description: 'Husky commit-msg hook' },
    { path: 'src/examples/strict-mode.ts', description: 'Sample TypeScript file' },
  ];

  requiredFiles.forEach((file) => {
    if (!checkFileExists(file.path, file.description)) {
      allTestsPassed = false;
    }
  });

  // Check package.json scripts
  if (!checkPackageJsonScripts()) {
    allTestsPassed = false;
  }

  // Run linting tests
  const lintResult = runCommand('npm run lint', 'ESLint validation');
  if (!lintResult.success) {
    allTestsPassed = false;
  }

  // Run formatting tests
  const formatResult = runCommand('npm run format', 'Prettier formatting');
  if (!formatResult.success) {
    allTestsPassed = false;
  }

  // Run TypeScript compilation
  const tscResult = runCommand('npx tsc --noEmit', 'TypeScript compilation');
  if (!tscResult.success) {
    allTestsPassed = false;
  }

  // Test Git hooks
  if (!testGitHooks()) {
    allTestsPassed = false;
  }

  // Summary
  log(`\n${colors.bold}📊 TEST SUMMARY${colors.reset}`, colors.blue);
  if (allTestsPassed) {
    log(`🎉 ALL TESTS PASSED! The setup is working correctly.`, colors.green);
  } else {
    log(`⚠️  SOME TESTS FAILED. Please review the errors above.`, colors.red);
  }

  log(`\n${colors.bold}Next Steps:${colors.reset}`, colors.blue);
  log(`• If all tests passed, you can proceed to the next phase`);
  log(`• If tests failed, fix the issues before continuing`);
  log(`• Run this script again after implementing each new phase`);

  process.exit(allTestsPassed ? 0 : 1);
}

if (require.main === module) {
  main();
}

module.exports = { main, runCommand, checkFileExists };
