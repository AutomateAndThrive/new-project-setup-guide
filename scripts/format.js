#!/usr/bin/env node

// Simple format script that can handle file paths from lint-staged
// This is a placeholder until we add Prettier

const files = process.argv.slice(2);

if (files.length > 0) {
  console.log(`No formatting configured yet for: ${files.join(', ')}`);
} else {
  console.log('No formatting configured yet');
}

process.exit(0); 