# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is a **documentation and examples repository** - a reference library of best practices for setting up software projects. It is NOT a template to clone or a tool to run.

## Repository Structure

```
/
├── README.md              # Entry point with navigation
├── docs/                  # Documentation guides
│   ├── getting-started/   # Onboarding and setup guides
│   ├── workflows/         # Git branching, commits, CI/CD
│   ├── tooling/           # IDE setup, troubleshooting
│   └── templates/         # ADRs, checklists, decision logs
├── examples/              # Configuration examples to copy
│   ├── eslint-config/
│   ├── typescript-config/
│   ├── prettier-config/
│   ├── husky-hooks/
│   ├── github-workflows/
│   └── docker/
└── checklists/            # YAML checklists
```

## Commands

```bash
npm install          # Install prettier
npm run format       # Format all files
npm run format:check # Check formatting (used in CI)
```

## Key Files

- `docs/workflows/Project Branching Strategy.md` - Git workflow with develop as default branch
- `docs/workflows/Commit_Message_Guide.md` - Conventional commits reference
- `examples/github-workflows/ci.yml` - CI pipeline example
- `checklists/pre-development-checklist.yml` - Project setup tasks

## Notes

- This repo only has prettier for formatting markdown/yaml
- No tests, no builds, no TypeScript compilation
- The examples/ folder contains reference configs, not active configs
