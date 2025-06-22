import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    globals: true,
    environment: 'node',
    coverage: {
      provider: 'v8',
      reporter: ['text', 'lcov', 'html'],
      exclude: [
        'node_modules/',
        'test/',
        'scripts/',
        'src/examples/**/*.ts',
        '**/*.d.ts',
        '**/*.config.*',
        '**/coverage/**',
        '.eslintrc.js',
        'jest.config.js',
        'vitest.config.ts',
        'tsconfig.json',
        'package.json',
        'package-lock.json',
        '*.md',
        'docs/**/*',
        '.github/**/*',
        'docker-compose.yml',
        'Dockerfile*',
        'pre-development-checklist.yml',
        'IMPLEMENTATION_ROADMAP.md',
        'README.md',
      ],
      include: ['src/**/*.ts'],
      thresholds: {
        global: {
          branches: 80,
          functions: 80,
          lines: 80,
          statements: 80,
        },
      },
    },
  },
});
