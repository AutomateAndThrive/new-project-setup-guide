# IDE Setup Guide

This guide helps you configure your preferred IDE for optimal development experience with this project.

## 🎯 Universal Setup (All IDEs)

### Required Extensions/Plugins

**TypeScript Support:**

- TypeScript language support
- ESLint integration
- Prettier integration

**Git Integration:**

- Git integration
- GitLens (or equivalent)

**Testing:**

- Jest integration
- Vitest integration (if supported)

## 📝 IDE-Specific Setup

### VS Code

**Recommended Extensions:**

```json
{
  "recommendations": [
    "ms-vscode.vscode-typescript-next",
    "dbaeumer.vscode-eslint",
    "esbenp.prettier-vscode",
    "ms-vscode.vscode-jest",
    "ms-vscode.vscode-json",
    "eamodio.gitlens",
    "ms-vscode.vscode-docker"
  ]
}
```

**Settings:**

```json
{
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  },
  "typescript.preferences.importModuleSpecifier": "relative",
  "files.exclude": {
    "**/node_modules": true,
    "**/dist": true,
    "**/coverage": true
  }
}
```

### IntelliJ IDEA / WebStorm

**Plugins to Install:**

- TypeScript and JavaScript
- ESLint
- Prettier
- Jest
- Docker

**Settings:**

- Enable "Format on Save"
- Configure ESLint integration
- Set up Jest test runner

### Vim/Neovim

**Plugins (using vim-plug):**

```vim
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc-tsserver'
Plug 'neoclide/coc-eslint'
Plug 'neoclide/coc-prettier'
Plug 'vim-test/vim-test'
```

**Configuration:**

```vim
" Auto-format on save
autocmd BufWritePre *.ts,*.js,*.tsx,*.jsx :Prettier
```

### Emacs

**Packages:**

- `typescript-mode`
- `prettier-js`
- `eslintd-fix`
- `magit` (for Git)

### Sublime Text

**Packages:**

- TypeScript
- ESLint
- Prettier
- GitGutter

## 🔧 Universal Development Scripts

All IDEs can use these npm scripts:

```bash
# Development
npm run dev          # Start development server
npm run build        # Build for production
npm run start        # Start production server

# Code Quality
npm run lint         # Run ESLint
npm run lint:fix     # Fix ESLint issues
npm run format       # Format with Prettier
npm run format:check # Check formatting

# Testing
npm test             # Run Jest tests
npm run test:vitest  # Run Vitest tests
npm run test:coverage # Run tests with coverage

# Docker
npm run docker:dev   # Start development environment
npm run docker:build # Build Docker image
```

## 🚀 Quick Start

1. **Clone the repository**
2. **Install dependencies:** `npm install`
3. **Configure your IDE** using the guide above
4. **Start development:** `npm run dev`

## 🔍 Troubleshooting

### Common Issues

**ESLint not working:**

- Ensure ESLint extension is installed
- Check that `@typescript-eslint/parser` is configured
- Verify `.eslintrc.js` is in project root

**Prettier conflicts:**

- Disable conflicting formatters in your IDE
- Ensure Prettier is set as the default formatter

**TypeScript errors:**

- Check that TypeScript extension is installed
- Verify `tsconfig.json` is properly configured
- Restart your IDE after configuration changes

## 📚 Additional Resources

- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [ESLint Rules](https://eslint.org/docs/rules/)
- [Prettier Configuration](https://prettier.io/docs/en/configuration.html)
- [Jest Documentation](https://jestjs.io/docs/getting-started)
- [Vitest Documentation](https://vitest.dev/guide/)

## 🤝 Contributing

If you use a different IDE or have additional configuration tips, please contribute to this guide!
