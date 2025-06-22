module.exports = {
  env: {
    browser: true,
    es2021: true,
    node: true,
  },
  extends: [
    'eslint:recommended',
    'plugin:@typescript-eslint/recommended',
    'plugin:import/recommended',
    'plugin:import/typescript',
    'plugin:node/recommended',
    'prettier', // Must be last to override other configs
  ],
  parser: '@typescript-eslint/parser',
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module',
    project: './tsconfig.json',
  },
  plugins: ['@typescript-eslint', 'import', 'node'],
  rules: {
    // TypeScript specific rules
    '@typescript-eslint/no-unused-vars': 'error',
    '@typescript-eslint/no-explicit-any': 'error',
    '@typescript-eslint/explicit-function-return-type': 'warn',
    '@typescript-eslint/no-non-null-assertion': 'warn',

    // Import rules
    // The following import rules are temporarily disabled for TypeScript files due to known resolver issues.
    // See: https://github.com/import-js/eslint-plugin-import/issues/2556 and related issues.
    // Remove these disables when the ecosystem catches up.
    'import/no-unresolved': 'off',
    'import/no-duplicates': 'off',
    'import/namespace': 'off',
    'import/order': 'off',

    // General rules
    'no-console': 'warn',
    'no-debugger': 'error',
    'no-alert': 'error',
    'prefer-const': 'error',
    'no-var': 'error',
    'object-shorthand': 'error',
    'prefer-template': 'error',

    // Node.js specific rules
    'node/no-unsupported-features/es-syntax': 'off', // TypeScript handles this
    'node/no-missing-import': 'off', // TypeScript handles this
  },
  settings: {
    'import/resolver': {
      typescript: {
        alwaysTryTypes: true,
        project: './tsconfig.json',
      },
    },
  },
  ignorePatterns: [
    'node_modules/',
    'dist/',
    'build/',
    '*.config.js',
    '*.config.ts',
    '.eslintrc.js',
    'scripts/*.js',
  ],
  overrides: [
    {
      files: ['*.ts', '*.tsx'],
      parserOptions: {
        project: './tsconfig.json',
      },
      rules: {
        // Disable problematic import rules for TypeScript files only
        'import/no-unresolved': 'off',
        'import/no-duplicates': 'off',
        'import/namespace': 'off',
        'import/order': 'off',
      },
    },
    {
      files: ['*.js'],
      parserOptions: {
        project: undefined,
      },
    },
  ],
};
