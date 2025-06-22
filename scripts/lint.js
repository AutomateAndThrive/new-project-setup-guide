#!/usr/bin/env node

// Simple lint script that can handle file paths from lint-staged
// This is a placeholder until we add ESLint

const files = process.argv.slice(2);

if (files.length > 0) {
  console.log(`No linting configured yet for: ${files.join(', ')}`);
} else {
  console.log('No linting configured yet');
}

process.exit(0); 