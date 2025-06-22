// Simple lint script that can handle file paths from lint-staged
// This is a placeholder until we add ESLint

const files = process.argv.slice(2);

if (files.length > 0) {
  // eslint-disable-next-line no-console
  console.log(`No linting configured yet for: ${files.join(', ')}`);
} else {
  // eslint-disable-next-line no-console
  console.log('No linting configured yet');
}

// eslint-disable-next-line no-process-exit
process.exit(0); 