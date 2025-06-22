#!/bin/zsh
# ==============================================================================
# Enhanced Project Initialization Script
#
# Description:
#   This script automates the complete setup of a new monorepo project with
#   production-ready structure and best practices built in.
#
# Features:
#   - Multiple tech stack support (React, Vue, Angular, Next.js, Node.js, Python, .NET, Java)
#   - Database integration (PostgreSQL, MySQL, MongoDB, SQLite)
#   - Deployment options (Docker, Kubernetes, Serverless)
#   - Pre-configured dev tools (ESLint, Prettier, Husky, lint-staged, Commitlint)
#   - CI/CD workflows (GitHub Actions)
#   - Environment-specific configurations
#   - Professional project templates
#
# Usage:
#   Basic usage: ./init_project_improved.sh
#   Custom usage: ./init_project_improved.sh --name "my-project" --frontend "react" --backend "node"
#   Interactive: ./init_project_improved.sh --interactive
#
# Options:
#   --name, -n          Project name (default: "my-project")
#   --description, -d   Project description
#   --frontend, -f      Frontend framework (react, vue, angular, nextjs)
#   --backend, -b       Backend framework (node, python, dotnet, java)
#   --database, -db     Database (postgresql, mysql, mongodb, sqlite)
#   --deployment, -dep  Deployment (docker, kubernetes, serverless)
#   --template, -t      Project template (saas, ecommerce, api, dashboard, mobile)
#   --environment, -e   Environment (development, staging, production)
#   --interactive, -i   Interactive mode for guided setup
#   --dry-run, -dr      Preview what will be created without actually creating
#   --verbose, -v       Verbose output for debugging
#   --help, -h          Show this help message
# ==============================================================================

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Script configuration
SCRIPT_DIR="${0:A:h}"
SCRIPT_NAME="${0:t}"
VERSION="2.0.0"

# Default configuration
PROJECT_NAME="my-project"
PROJECT_DESCRIPTION="A modern web application"
FRONTEND_FRAMEWORK="react"
BACKEND_FRAMEWORK="node"
DATABASE="postgresql"
DEPLOYMENT="docker"
PROJECT_TEMPLATE=""
ENVIRONMENT="development"
INTERACTIVE_MODE=false
DRY_RUN=false
VERBOSE=false

# Logging functions
log_info() {
    print -P "%F{blue}ℹ️  $1%f"
}

log_success() {
    print -P "%F{green}✅ $1%f"
}

log_warning() {
    print -P "%F{yellow}⚠️  $1%f"
}

log_error() {
    print -P "%F{red}❌ $1%f" >&2
}

log_verbose() {
    if [[ "$VERBOSE" == true ]]; then
        print -P "%F{cyan}🔍 $1%f"
    fi
}

# Function to show help
show_help() {
    cat << EOF
${BLUE}Enhanced Project Initialization Script v${VERSION}${NC}

${CYAN}Description:${NC}
  This script creates a complete, production-ready project structure with your chosen
  tech stack and all best practices built in. Think create-react-app or rails new,
  but for full-stack, modern, production-grade projects.

${CYAN}Usage:${NC}
  $SCRIPT_NAME [OPTIONS]

${CYAN}Options:${NC}
  --name, -n          Project name (default: my-project)
  --description, -d   Project description
  --frontend, -f      Frontend framework (react, vue, angular, nextjs)
  --backend, -b       Backend framework (node, python, dotnet, java)
  --database, -db     Database (postgresql, mysql, mongodb, sqlite)
  --deployment, -dep  Deployment (docker, kubernetes, serverless)
  --template, -t      Project template (saas, ecommerce, api, dashboard, mobile)
  --environment, -e   Environment (development, staging, production)
  --interactive, -i   Interactive mode for guided setup
  --dry-run, -dr      Preview what will be created without actually creating
  --verbose, -v       Verbose output for debugging
  --help, -h          Show this help message

${CYAN}Examples:${NC}
  # Interactive setup
  $SCRIPT_NAME --interactive

  # Quick API project
  $SCRIPT_NAME --name "my-api" --template "api"

  # Full-stack SaaS
  $SCRIPT_NAME --name "my-saas" --template "saas" --environment "development"

  # Custom stack
  $SCRIPT_NAME --name "my-app" --frontend "nextjs" --backend "python" --database "mongodb"

${CYAN}What's Included:${NC}
  • Professional project structure
  • Pre-configured dev tools (ESLint, Prettier, Husky, lint-staged)
  • Docker and CI/CD configurations
  • Environment-specific settings
  • Database migrations and seeds
  • Testing setup
  • Documentation templates
  • Development scripts

EOF
}

# Function to validate tech stack choices
validate_choice() {
    local value="$1"
    local valid_options="$2"
    local option_name="$3"
    
    if [[ ! " $valid_options " =~ " $value " ]]; then
        log_error "Invalid $option_name: '$value'"
        log_info "Valid options: $valid_options"
        exit 1
    fi
}

# Function to apply template configuration
apply_template() {
    local template="$1"
    
    case $template in
        "saas")
            PROJECT_DESCRIPTION="A SaaS application with user authentication, billing, and subscription management"
            FRONTEND_FRAMEWORK="react"
            BACKEND_FRAMEWORK="node"
            DATABASE="postgresql"
            DEPLOYMENT="docker"
            log_success "Applied SaaS template"
            ;;
        "ecommerce")
            PROJECT_DESCRIPTION="An e-commerce platform with product catalog, shopping cart, and payment processing"
            FRONTEND_FRAMEWORK="nextjs"
            BACKEND_FRAMEWORK="node"
            DATABASE="postgresql"
            DEPLOYMENT="docker"
            log_success "Applied E-commerce template"
            ;;
        "api")
            PROJECT_DESCRIPTION="A RESTful API service with comprehensive documentation and testing"
            FRONTEND_FRAMEWORK=""
            BACKEND_FRAMEWORK="node"
            DATABASE="postgresql"
            DEPLOYMENT="docker"
            log_success "Applied API template"
            ;;
        "dashboard")
            PROJECT_DESCRIPTION="An admin dashboard with analytics, user management, and reporting"
            FRONTEND_FRAMEWORK="react"
            BACKEND_FRAMEWORK="node"
            DATABASE="postgresql"
            DEPLOYMENT="docker"
            log_success "Applied Dashboard template"
            ;;
        "mobile")
            PROJECT_DESCRIPTION="A mobile app backend with user management and push notifications"
            FRONTEND_FRAMEWORK=""
            BACKEND_FRAMEWORK="node"
            DATABASE="mongodb"
            DEPLOYMENT="serverless"
            log_success "Applied Mobile Backend template"
            ;;
    esac
}

# Function for interactive setup
interactive_setup() {
    print -P "%F{cyan}🎯 Interactive Project Setup%f"
    print -P "%F{cyan}==========================%f"
    echo ""
    
    # Project name
    read "input_name?Project name [my-project]: "
    PROJECT_NAME=${input_name:-"my-project"}
    
    # Project template selection
    print -P "%F{yellow}Project templates:%f"
    echo "1) Custom project (choose your own tech stack)"
    echo "2) SaaS application (React + Node.js + PostgreSQL)"
    echo "3) E-commerce platform (Next.js + Node.js + PostgreSQL)"
    echo "4) API service (Node.js + PostgreSQL, no frontend)"
    echo "5) Admin dashboard (React + Node.js + PostgreSQL)"
    echo "6) Mobile backend (Node.js + MongoDB + Serverless)"
    read "template_choice?Choose project template [1]: "
    
    case ${template_choice:-1} in
        1) 
            PROJECT_TEMPLATE=""
            PROJECT_DESCRIPTION="A modern web application"
            ;;
        2) 
            PROJECT_TEMPLATE="saas"
            apply_template "saas"
            ;;
        3) 
            PROJECT_TEMPLATE="ecommerce"
            apply_template "ecommerce"
            ;;
        4) 
            PROJECT_TEMPLATE="api"
            apply_template "api"
            ;;
        5) 
            PROJECT_TEMPLATE="dashboard"
            apply_template "dashboard"
            ;;
        6) 
            PROJECT_TEMPLATE="mobile"
            apply_template "mobile"
            ;;
        *) 
            PROJECT_TEMPLATE=""
            PROJECT_DESCRIPTION="A modern web application"
            ;;
    esac
    
    # If custom project or template needs customization
    if [[ -z "$PROJECT_TEMPLATE" ]] || [[ "$template_choice" == "1" ]]; then
        # Project description
        read "input_desc?Project description [$PROJECT_DESCRIPTION]: "
        PROJECT_DESCRIPTION=${input_desc:-"$PROJECT_DESCRIPTION"}
        
        # Frontend framework (skip if API or mobile template)
        if [[ -n "$FRONTEND_FRAMEWORK" ]]; then
            print -P "%F{yellow}Frontend frameworks:%f"
            echo "1) React (recommended)"
            echo "2) Vue"
            echo "3) Angular"
            echo "4) Next.js"
            read "frontend_choice?Choose frontend framework [1]: "
            case ${frontend_choice:-1} in
                1) FRONTEND_FRAMEWORK="react" ;;
                2) FRONTEND_FRAMEWORK="vue" ;;
                3) FRONTEND_FRAMEWORK="angular" ;;
                4) FRONTEND_FRAMEWORK="nextjs" ;;
                *) FRONTEND_FRAMEWORK="react" ;;
            esac
        fi
        
        # Backend framework
        print -P "%F{yellow}Backend frameworks:%f"
        echo "1) Node.js (recommended)"
        echo "2) Python/FastAPI"
        echo "3) .NET"
        echo "4) Java/Spring"
        read "backend_choice?Choose backend framework [1]: "
        case ${backend_choice:-1} in
            1) BACKEND_FRAMEWORK="node" ;;
            2) BACKEND_FRAMEWORK="python" ;;
            3) BACKEND_FRAMEWORK="dotnet" ;;
            4) BACKEND_FRAMEWORK="java" ;;
            *) BACKEND_FRAMEWORK="node" ;;
        esac
        
        # Database
        print -P "%F{yellow}Databases:%f"
        echo "1) PostgreSQL (recommended)"
        echo "2) MySQL"
        echo "3) MongoDB"
        echo "4) SQLite"
        read "db_choice?Choose database [1]: "
        case ${db_choice:-1} in
            1) DATABASE="postgresql" ;;
            2) DATABASE="mysql" ;;
            3) DATABASE="mongodb" ;;
            4) DATABASE="sqlite" ;;
            *) DATABASE="postgresql" ;;
        esac
        
        # Deployment
        print -P "%F{yellow}Deployment options:%f"
        echo "1) Docker (recommended)"
        echo "2) Kubernetes"
        echo "3) Serverless"
        read "dep_choice?Choose deployment [1]: "
        case ${dep_choice:-1} in
            1) DEPLOYMENT="docker" ;;
            2) DEPLOYMENT="kubernetes" ;;
            3) DEPLOYMENT="serverless" ;;
            *) DEPLOYMENT="docker" ;;
        esac
        
        # Environment
        print -P "%F{yellow}Environment:%f"
        echo "1) Development (local development with hot reloading)"
        echo "2) Staging (pre-production for testing)"
        echo "3) Production (production-ready configuration)"
        read "env_choice?Choose environment [1]: "
        case ${env_choice:-1} in
            1) ENVIRONMENT="development" ;;
            2) ENVIRONMENT="staging" ;;
            3) ENVIRONMENT="production" ;;
            *) ENVIRONMENT="development" ;;
        esac
    fi
    
    echo ""
    log_success "Configuration complete!"
    echo ""
}

# Function to display configuration summary
show_configuration() {
    print -P "%F{blue}🚀 Project Configuration Summary%f"
    print -P "%F{blue}===============================%f"
    print -P "%F{yellow}Project:%f $PROJECT_NAME"
    print -P "%F{yellow}Description:%f $PROJECT_DESCRIPTION"
    print -P "%F{yellow}Frontend:%f ${FRONTEND_FRAMEWORK:-"None"}"
    print -P "%F{yellow}Backend:%f $BACKEND_FRAMEWORK"
    print -P "%F{yellow}Database:%f $DATABASE"
    print -P "%F{yellow}Deployment:%f $DEPLOYMENT"
    print -P "%F{yellow}Environment:%f $ENVIRONMENT"
    print -P "%F{yellow}Template:%f ${PROJECT_TEMPLATE:-"Custom"}"
    echo ""
}

# Function to create directory structure
create_directory_structure() {
    log_info "Creating project structure..."
    
    if [[ "$DRY_RUN" == true ]]; then
        log_verbose "Would create directory: $PROJECT_NAME"
        return
    fi
    
    mkdir -p "$PROJECT_NAME"
    cd "$PROJECT_NAME"
    
    # Create main project structure
    mkdir -p {backend,docs,scripts,tests,assets}
    
    # Create frontend structure only if needed
    if [[ -n "$FRONTEND_FRAMEWORK" ]]; then
        mkdir -p frontend
        log_info "Creating frontend structure for $FRONTEND_FRAMEWORK..."
        case $FRONTEND_FRAMEWORK in
            "react")
                mkdir -p frontend/{src/{components,pages,hooks,utils,services,types,assets},public}
                mkdir -p frontend/src/components/{ui,layout,forms}
                mkdir -p frontend/src/pages/{home,about,contact}
                mkdir -p frontend/src/services/{api,auth}
                mkdir -p frontend/src/types/{api,ui}
                ;;
            "vue")
                mkdir -p frontend/{src/{components,views,composables,utils,services,types,assets},public}
                mkdir -p frontend/src/components/{ui,layout,forms}
                mkdir -p frontend/src/views/{home,about,contact}
                mkdir -p frontend/src/services/{api,auth}
                mkdir -p frontend/src/types/{api,ui}
                ;;
            "angular")
                mkdir -p frontend/{src/{app/{components,pages,services,models,guards},assets,environments},public}
                mkdir -p frontend/src/app/components/{ui,layout,forms}
                mkdir -p frontend/src/app/pages/{home,about,contact}
                mkdir -p frontend/src/app/services/{api,auth}
                mkdir -p frontend/src/app/models/{api,ui}
                ;;
            "nextjs")
                mkdir -p frontend/{src/{app,components,lib,types,styles},public}
                mkdir -p frontend/src/components/{ui,layout,forms}
                mkdir -p frontend/src/lib/{api,auth}
                mkdir -p frontend/src/types/{api,ui}
                ;;
        esac
    else
        log_info "Backend-only project - skipping frontend structure"
    fi
    
    # Create backend structure based on framework
    log_info "Creating backend structure for $BACKEND_FRAMEWORK..."
    case $BACKEND_FRAMEWORK in
        "node")
            mkdir -p backend/{src/{controllers,middleware,models,routes,services,utils,config},tests}
            mkdir -p backend/src/services/{api,auth,database}
            mkdir -p backend/src/models/{user,product}
            mkdir -p backend/src/controllers/{auth,user,product}
            mkdir -p backend/{migrations,seeds,scripts}
            ;;
        "python")
            mkdir -p backend/{app/{api,core,models,schemas,services,utils},tests}
            mkdir -p backend/app/api/{v1,endpoints}
            mkdir -p backend/app/core/{config,security}
            mkdir -p backend/{migrations,scripts}
            ;;
        "dotnet")
            mkdir -p backend/{Controllers,Models,Services,Data,Configuration}
            mkdir -p backend/{Migrations,Scripts}
            ;;
        "java")
            mkdir -p backend/src/main/java/com/example/{controller,service,model,repository,config}
            mkdir -p backend/src/test/java/com/example
            mkdir -p backend/{migrations,scripts}
            ;;
    esac
    
    log_success "Project structure created successfully!"
}

# Function to create configuration files
create_configuration_files() {
    log_info "Creating configuration files..."
    
    if [[ "$DRY_RUN" == true ]]; then
        log_verbose "Would create configuration files"
        return
    fi
    
    # Create root package.json for monorepo with enhanced enforcement tools
    cat > package.json << 'EOF'
{
  "name": "'$PROJECT_NAME'",
  "version": "1.0.0",
  "description": "'$PROJECT_DESCRIPTION'",
  "private": true,
  "workspaces": [
    "frontend",
    "backend"
  ],
  "scripts": {
    "install:all": "npm install && npm run install:frontend && npm run install:backend",
    "install:frontend": "cd frontend && npm install",
    "install:backend": "cd backend && npm install",
    "dev": "concurrently \"npm run dev:backend\" \"npm run dev:frontend\"",
    "dev:frontend": "cd frontend && npm run dev",
    "dev:backend": "cd backend && npm run dev",
    "build": "npm run build:frontend && npm run build:backend",
    "build:frontend": "cd frontend && npm run build",
    "build:backend": "cd backend && npm run build",
    "test": "npm run test:frontend && npm run test:backend",
    "test:frontend": "cd frontend && npm test",
    "test:backend": "cd backend && npm test",
    "test:coverage": "npm run test:coverage:frontend && npm run test:coverage:backend",
    "test:coverage:frontend": "cd frontend && npm run test:coverage",
    "test:coverage:backend": "cd backend && npm run test:coverage",
    "test:vitest": "vitest run",
    "test:vitest:watch": "vitest",
    "test:vitest:coverage": "vitest run --coverage",
    "lint": "npm run lint:frontend && npm run lint:backend",
    "lint:frontend": "cd frontend && npm run lint",
    "lint:backend": "cd backend && npm run lint",
    "lint:fix": "npm run lint:fix:frontend && npm run lint:fix:backend",
    "lint:fix:frontend": "cd frontend && npm run lint:fix",
    "lint:fix:backend": "cd backend && npm run lint:fix",
    "format": "prettier --write \"**/*.{js,jsx,ts,tsx,json,css,md}\"",
    "format:check": "prettier --check \"**/*.{js,jsx,ts,tsx,json,css,md}\"",
    "prepare": "husky install",
    "validate": "npm run lint && npm run format:check && npm test && npm run test:vitest",
    "validate:env": "node scripts/validate-env.js",
    "ci:test": "npm run test:coverage && npm run test:vitest:coverage",
    "ci:lint": "npm run lint && npm run format:check",
    "ci:build": "npm run build",
    "ci:security": "npm audit --audit-level=moderate",
    "ci:full": "npm run ci:lint && npm run ci:test && npm run ci:build && npm run ci:security",
    "docs:generate": "typedoc",
    "docs:serve": "typedoc --serve",
    "docs:watch": "typedoc --watch"
  },
  "devDependencies": {
    "@commitlint/cli": "^18.4.3",
    "@commitlint/config-conventional": "^18.4.3",
    "@types/jest": "^30.0.0",
    "@types/node": "^20.12.12",
    "@typescript-eslint/eslint-plugin": "^6.21.0",
    "@typescript-eslint/parser": "^6.21.0",
    "@vitest/coverage-v8": "^3.2.4",
    "concurrently": "^8.2.2",
    "eslint": "^8.57.0",
    "eslint-config-prettier": "^9.1.0",
    "eslint-plugin-import": "^2.29.1",
    "eslint-plugin-node": "^11.1.0",
    "husky": "^8.0.3",
    "jest": "^30.0.2",
    "lint-staged": "^15.2.0",
    "prettier": "^3.2.5",
    "snyk": "^1.1260.0",
    "ts-jest": "^29.4.0",
    "typedoc": "^0.28.5",
    "typedoc-plugin-markdown": "^4.7.0",
    "typescript": "5.3.3",
    "vitest": "^3.2.4"
  },
  "engines": {
    "node": ">=18.0.0",
    "npm": ">=8.0.0"
  },
  "lint-staged": {
    "*.{js,jsx,ts,tsx}": [
      "npm run lint",
      "npm run format"
    ],
    "*.{md,json,yml,yaml}": [
      "npm run format"
    ]
  },
  "commitlint": {
    "extends": [
      "@commitlint/config-conventional"
    ]
  },
  "keywords": ["monorepo", "fullstack", "webapp", "enforcement", "quality-gates"],
  "author": "Your Team",
  "license": "MIT"
}
EOF

    # Create TypeScript configuration
    cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "allowJs": true,
    "skipLibCheck": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "noFallthroughCasesInSwitch": true,
    "module": "ESNext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx"
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "build", "coverage"]
}
EOF

    # Create ESLint configuration
    cat > .eslintrc.js << 'EOF'
module.exports = {
  root: true,
  env: {
    browser: true,
    es2021: true,
    node: true,
    jest: true,
  },
  extends: [
    'eslint:recommended',
    '@typescript-eslint/recommended',
    'prettier',
  ],
  parser: '@typescript-eslint/parser',
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module',
  },
  plugins: ['@typescript-eslint', 'import', 'node'],
  rules: {
    '@typescript-eslint/no-unused-vars': 'error',
    '@typescript-eslint/no-explicit-any': 'warn',
    'import/order': [
      'error',
      {
        groups: [
          'builtin',
          'external',
          'internal',
          'parent',
          'sibling',
          'index',
        ],
        'newlines-between': 'always',
        alphabetize: {
          order: 'asc',
          caseInsensitive: true,
        },
      },
    ],
    'no-console': 'warn',
    'no-debugger': 'error',
  },
  ignorePatterns: ['dist/', 'build/', 'coverage/', 'node_modules/'],
};
EOF

    # Create Prettier configuration
    cat > .prettierrc << 'EOF'
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 80,
  "tabWidth": 2,
  "useTabs": false,
  "bracketSpacing": true,
  "arrowParens": "avoid"
}
EOF

    # Create Jest configuration
    cat > jest.config.js << 'EOF'
module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  roots: ['<rootDir>/src', '<rootDir>/test'],
  testMatch: ['**/__tests__/**/*.ts', '**/?(*.)+(spec|test).ts'],
  transform: {
    '^.+\\.ts$': 'ts-jest',
  },
  collectCoverageFrom: [
    'src/**/*.ts',
    '!src/**/*.d.ts',
    '!src/**/*.test.ts',
    '!src/**/*.spec.ts',
  ],
  coverageDirectory: 'coverage',
  coverageReporters: ['text', 'lcov', 'html'],
  coverageThreshold: {
    global: {
      branches: 80,
      functions: 80,
      lines: 80,
      statements: 80,
    },
  },
  setupFilesAfterEnv: ['<rootDir>/test/setup.ts'],
};
EOF

    # Create Vitest configuration
    cat > vitest.config.ts << 'EOF'
import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    globals: true,
    environment: 'node',
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
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
EOF

    # Create TypeDoc configuration
    cat > typedoc.json << 'EOF'
{
  "entryPoints": ["src/**/*.ts"],
  "out": "docs/api",
  "exclude": ["**/*.test.ts", "**/*.spec.ts", "**/node_modules/**"],
  "excludePrivate": true,
  "excludeProtected": true,
  "excludeExternals": true,
  "includeVersion": true,
  "theme": "default",
  "name": "'$PROJECT_NAME' API",
  "readme": "README.md",
  "categorizeByGroup": true,
  "categoryOrder": ["Utilities", "Types", "Examples", "*"],
  "sort": ["source-order"],
  "searchInComments": true,
  "validation": {
    "invalidLink": true,
    "notExported": true
  },
  "gitRevision": "main",
  "gitRemote": "origin",
  "excludeNotDocumented": false,
  "excludeNotDocumentedKinds": ["Module"],
  "plugin": ["typedoc-plugin-markdown"],
  "hideGenerator": true,
  "cleanOutputDir": true
}
EOF

    # Create .gitignore
    cat > .gitignore << 'EOF'
# Dependencies
node_modules/
*/node_modules/
.pnp
.pnp.js

# Production builds
build/
dist/
*/build/
*/dist/

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local
*/env/
*/env/

# Logs
npm-debug.log*
yarn-debug.log*
yarn-error.log*
lerna-debug.log*
*.log

# Runtime data
pids
*.pid
*.seed
*.pid.lock

# Coverage directory used by tools like istanbul
coverage/
*.lcov

# nyc test coverage
.nyc_output

# Dependency directories
jspm_packages/

# Optional npm cache directory
.npm

# Optional eslint cache
.eslintcache

# Microbundle cache
.rpt2_cache/
.rts2_cache_cjs/
.rts2_cache_es/
.rts2_cache_umd/

# Optional REPL history
.node_repl_history

# Output of 'npm pack'
*.tgz

# Yarn Integrity file
.yarn-integrity

# parcel-bundler cache (https://parceljs.org/)
.cache
.parcel-cache

# Next.js build output
.next

# Nuxt.js build / generate output
.nuxt

# Gatsby files
.cache/
public

# Storybook build outputs
.out
.storybook-out

# Temporary folders
tmp/
temp/

# Editor directories and files
.vscode/
.idea/
*.swp
*.swo
*~

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Database
*.db
*.sqlite
*.sqlite3

# Docker
.dockerignore

# Kubernetes
*.kubeconfig

# Terraform
*.tfstate
*.tfstate.*
.terraform/

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
venv/
ENV/
env.bak/
venv.bak/
.pytest_cache/

# Java
*.class
*.jar
*.war
*.ear
target/
.gradle/

# .NET
bin/
obj/
*.user
*.suo
*.cache
*.pdb
*.pgc
*.pgd
*.rsp
*.sbr
*.tlb
*.tli
*.tlh
*.tmp
*.tmp_proj
*.log
*.vspscc
*.vssscc
.builds
*.pidb
*.svclog
*.scc

# IDE
.vs/
.vscode/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db
EOF

    # Create README.md
    cat > README.md << 'EOF'
# '$PROJECT_NAME'

'$PROJECT_DESCRIPTION'

## 🚀 Quick Start

### Prerequisites
- Node.js 18+ (for frontend and Node.js backend)
- Docker (for containerized deployment)
- Git

### Installation

1. **Clone and navigate to the project:**
   ```bash
   cd '$PROJECT_NAME'
   ```

2. **Install all dependencies:**
   ```bash
   npm run install:all
   ```

3. **Set up environment variables:**
   ```bash
   cp backend/.env.'$ENVIRONMENT' backend/.env
   ```
EOF

    if [[ -n "$FRONTEND_FRAMEWORK" ]]; then
        cat >> README.md << 'EOF'
   cp frontend/.env.'$ENVIRONMENT' frontend/.env
EOF
    fi

    cat >> README.md << 'EOF'

4. **Set up database:**
   ```bash
   cd backend && ./scripts/migrate.sh
   ```

5. **Start development environment:**
   ```bash
   ./scripts/start-'$ENVIRONMENT'.sh local
   ```

## 🏗️ Project Structure

```
'$PROJECT_NAME'/
├── frontend/          # Frontend application
├── backend/           # Backend API
├── docs/             # Documentation
├── scripts/          # Development scripts
├── tests/            # Integration tests
└── assets/           # Static assets
```

## 🛠️ Tech Stack

- **Frontend:** '${FRONTEND_FRAMEWORK:-"None"}'
- **Backend:** '$BACKEND_FRAMEWORK'
- **Database:** '$DATABASE'
- **Deployment:** '$DEPLOYMENT'
- **Environment:** '$ENVIRONMENT'

## 📚 Documentation

- [Development Guide](docs/development/README.md)
- [API Documentation](docs/api/README.md)
- [Deployment Guide](docs/deployment/README.md)
- [Contributing Guidelines](docs/contributing/README.md)

## 🚀 Deployment

### Local Development
```bash
./scripts/start-'$ENVIRONMENT'.sh local
```

### Docker
```bash
./scripts/start-'$ENVIRONMENT'.sh docker
```

### Production
```bash
./scripts/deploy-production.sh
```

## 🤝 Contributing

Please read [CONTRIBUTING.md](docs/contributing/README.md) for details on our code of conduct and the process for submitting pull requests.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
EOF

    log_success "Configuration files created successfully!"
}

# Function to create environment-specific files
create_environment_files() {
    log_info "Setting up $ENVIRONMENT environment..."
    
    if [[ "$DRY_RUN" == true ]]; then
        log_verbose "Would create environment files for $ENVIRONMENT"
        return
    fi
    
    # Create environment-specific Docker Compose files
    case $ENVIRONMENT in
        "development")
            cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  backend:
    build: ./backend
    ports:
      - "3001:3001"
    environment:
      - NODE_ENV=development
      - DATABASE_URL=postgresql://postgres:password@db:5432/'$PROJECT_NAME'_dev
    volumes:
      - ./backend:/app
      - /app/node_modules
    depends_on:
      - db
    command: npm run dev

  frontend:
    build: ./frontend
    ports:
      - "3000:3000"
    environment:
      - REACT_APP_API_URL=http://localhost:3001
    volumes:
      - ./frontend:/app
      - /app/node_modules
    depends_on:
      - backend
    command: npm run dev

  db:
    image: postgres:15
    environment:
      - POSTGRES_DB='$PROJECT_NAME'_dev
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=password
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
EOF
            ;;
        "staging")
            cat > docker-compose.staging.yml << 'EOF'
version: '3.8'

services:
  backend:
    build: ./backend
    ports:
      - "3001:3001"
    environment:
      - NODE_ENV=staging
      - DATABASE_URL=postgresql://postgres:password@db:5432/'$PROJECT_NAME'_staging
    depends_on:
      - db

  frontend:
    build: ./frontend
    ports:
      - "3000:3000"
    environment:
      - REACT_APP_API_URL=http://localhost:3001
    depends_on:
      - backend

  db:
    image: postgres:15
    environment:
      - POSTGRES_DB='$PROJECT_NAME'_staging
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=password
    volumes:
      - postgres_staging_data:/var/lib/postgresql/data

volumes:
  postgres_staging_data:
EOF
            ;;
        "production")
            cat > docker-compose.production.yml << 'EOF'
version: '3.8'

services:
  backend:
    build: ./backend
    ports:
      - "3001:3001"
    environment:
      - NODE_ENV=production
      - DATABASE_URL=postgresql://postgres:password@db:5432/'$PROJECT_NAME'_prod
    depends_on:
      - db
    restart: unless-stopped

  frontend:
    build: ./frontend
    ports:
      - "3000:3000"
    environment:
      - REACT_APP_API_URL=http://localhost:3001
    depends_on:
      - backend
    restart: unless-stopped

  db:
    image: postgres:15
    environment:
      - POSTGRES_DB='$PROJECT_NAME'_prod
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=password
    volumes:
      - postgres_prod_data:/var/lib/postgresql/data
    restart: unless-stopped

volumes:
  postgres_prod_data:
EOF
            ;;
    esac
    
    # Create backend environment file
    cat > backend/.env.$ENVIRONMENT << 'EOF'
# '$ENVIRONMENT' Environment Configuration
NODE_ENV='$ENVIRONMENT'
PORT=3001

# Database Configuration
DATABASE_URL=postgresql://postgres:password@localhost:5432/'$PROJECT_NAME'_'$ENVIRONMENT'

# JWT Configuration
JWT_SECRET=your-super-secret-jwt-key-change-in-production
JWT_EXPIRES_IN=24h

# CORS Configuration
CORS_ORIGIN=http://localhost:3000

# Logging
LOG_LEVEL=info

# API Configuration
API_VERSION=v1
API_PREFIX=/api

# Security
BCRYPT_ROUNDS=12
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100
EOF

    # Create frontend environment file if frontend exists
    if [[ -n "$FRONTEND_FRAMEWORK" ]]; then
        cat > frontend/.env.$ENVIRONMENT << 'EOF'
# '$ENVIRONMENT' Environment Configuration
REACT_APP_API_URL=http://localhost:3001/api
REACT_APP_ENVIRONMENT='$ENVIRONMENT'
REACT_APP_VERSION=1.0.0
EOF
    fi
    
    log_success "$ENVIRONMENT environment configured successfully!"
}

# Function to create development scripts
create_development_scripts() {
    log_info "Creating development scripts..."
    
    if [[ "$DRY_RUN" == true ]]; then
        log_verbose "Would create development scripts"
        return
    fi
    
    # Create start script for the current environment
    cat > scripts/start-$ENVIRONMENT.sh << 'EOF'
#!/bin/zsh
# Start script for '$ENVIRONMENT' environment

set -e

ENVIRONMENT="'$ENVIRONMENT'"
PROJECT_NAME="'$PROJECT_NAME'"

echo "🚀 Starting $PROJECT_NAME in $ENVIRONMENT mode..."

case "$1" in
    "local")
        echo "📦 Installing dependencies..."
        npm run install:all
        
        echo "🔧 Setting up environment..."
        cp backend/.env.$ENVIRONMENT backend/.env
EOF

    if [[ -n "$FRONTEND_FRAMEWORK" ]]; then
        cat >> scripts/start-$ENVIRONMENT.sh << 'EOF'
        cp frontend/.env.$ENVIRONMENT frontend/.env
EOF
    fi

    cat >> scripts/start-$ENVIRONMENT.sh << 'EOF'
        
        echo "🗄️  Starting database..."
        docker-compose up -d db
        
        echo "⏳ Waiting for database to be ready..."
        sleep 5
        
        echo "🔄 Running database migrations..."
        cd backend && ./scripts/migrate.sh && cd ..
        
        echo "🚀 Starting development servers..."
        npm run dev
        ;;
    "docker")
        echo "🐳 Starting with Docker Compose..."
        docker-compose up --build
        ;;
    *)
        echo "Usage: $0 {local|docker}"
        echo "  local  - Start with local dependencies"
        echo "  docker - Start with Docker Compose"
        exit 1
        ;;
esac
EOF

    chmod +x scripts/start-$ENVIRONMENT.sh
    
    # Create deployment scripts
    cat > scripts/deploy-dev.sh << 'EOF'
#!/bin/zsh
# Deploy to development environment

echo "🚀 Deploying to development environment..."
# Add your deployment logic here
EOF

    cat > scripts/deploy-staging.sh << 'EOF'
#!/bin/zsh
# Deploy to staging environment

echo "🚀 Deploying to staging environment..."
# Add your deployment logic here
EOF

    cat > scripts/deploy-production.sh << 'EOF'
#!/bin/zsh
# Deploy to production environment

echo "🚀 Deploying to production environment..."
# Add your deployment logic here
EOF

    chmod +x scripts/deploy-*.sh
    
    log_success "Development scripts created successfully!"
}

# Function to create CI/CD workflows
create_cicd_workflows() {
    log_info "Setting up CI/CD workflows..."
    
    if [[ "$DRY_RUN" == true ]]; then
        log_verbose "Would create CI/CD workflows"
        return
    fi
    
    mkdir -p .github/workflows
    
    # Create main CI workflow with enhanced quality gates
    cat > .github/workflows/ci.yml << 'EOF'
name: CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  lint:
    name: Lint & Format
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    
    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '18'
        cache: 'npm'
    
    - name: Install dependencies
      run: npm install
    
    - name: Run ESLint
      run: npm run lint
    
    - name: Check formatting
      run: npm run format:check

  test:
    name: Test & Coverage
    runs-on: ubuntu-latest
    needs: lint
    
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_PASSWORD: postgres
          POSTGRES_DB: test_db
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 5432:5432

    steps:
    - uses: actions/checkout@v4
    
    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '18'
        cache: 'npm'
    
    - name: Install dependencies
      run: npm install
    
    - name: Run Jest tests with coverage
      run: npm run test:coverage
      env:
        DATABASE_URL: postgresql://postgres:postgres@localhost:5432/test_db
    
    - name: Run Vitest tests with coverage
      run: npm run test:vitest:coverage
    
    - name: Upload coverage to Codecov
      uses: codecov/codecov-action@v3
      with:
        file: ./coverage/lcov.info
        flags: unittests
        name: codecov-umbrella
        fail_ci_if_error: true

  build:
    name: Build
    runs-on: ubuntu-latest
    needs: test
    steps:
    - uses: actions/checkout@v4
    
    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '18'
        cache: 'npm'
    
    - name: Install dependencies
      run: npm install
    
    - name: Build project
      run: npm run build

  security:
    name: Security Scan
    runs-on: ubuntu-latest
    needs: build
    steps:
    - uses: actions/checkout@v4
    
    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '18'
        cache: 'npm'
    
    - name: Install dependencies
      run: npm install
    
    - name: Run npm audit
      run: npm audit --audit-level=moderate
    
    - name: Run Snyk security scan
      uses: snyk/actions/node@master
      env:
        SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
      with:
        args: --severity-threshold=high

  docs:
    name: Generate Documentation
    runs-on: ubuntu-latest
    needs: build
    steps:
    - uses: actions/checkout@v4
    
    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '18'
        cache: 'npm'
    
    - name: Install dependencies
      run: npm install
    
    - name: Generate API documentation
      run: npm run docs:generate
    
    - name: Upload documentation artifacts
      uses: actions/upload-artifact@v3
      with:
        name: api-docs
        path: docs/api/
EOF

    # Create dependency updates workflow
    cat > .github/workflows/dependency-updates.yml << 'EOF'
name: Dependency Updates

on:
  schedule:
    # Run every Monday at 9 AM UTC
    - cron: '0 9 * * 1'
  workflow_dispatch:

jobs:
  update-dependencies:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    
    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '18'
        cache: 'npm'
    
    - name: Install dependencies
      run: npm install
    
    - name: Check for outdated packages
      run: npm outdated || true
    
    - name: Create Pull Request for updates
      uses: peter-evans/create-pull-request@v5
      with:
        token: ${{ secrets.GITHUB_TOKEN }}
        commit-message: 'chore(deps): update dependencies'
        title: 'chore(deps): update dependencies'
        body: |
          Automated dependency updates
          
          This PR updates outdated dependencies to their latest versions.
          
          Please review the changes and test thoroughly before merging.
        branch: chore/update-dependencies
        delete-branch: true
EOF

    # Create PR template
    mkdir -p .github
    cat > .github/pull_request_template.md << 'EOF'
# Pull Request

## 🎯 Description
<!-- Describe what this PR does and why it's needed -->

## 🔍 Changes Made
<!-- List the main changes in this PR -->
- [ ] Change 1
- [ ] Change 2

## 🧪 Testing
<!-- Describe how you tested these changes -->
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing completed
- [ ] Coverage meets 80% minimum

## 📊 Quality Checklist
<!-- Ensure all quality gates are met -->
- [ ] Code follows project style guidelines
- [ ] All linting checks pass
- [ ] Code is properly formatted
- [ ] No console.log statements in production code
- [ ] Documentation updated if needed
- [ ] No breaking changes (or breaking changes documented)

## 🔐 Security
<!-- Security considerations -->
- [ ] No sensitive data exposed
- [ ] Input validation implemented
- [ ] Dependencies checked for vulnerabilities

## 📝 Additional Notes
<!-- Any additional information -->

## 🎯 Related Issues
<!-- Link to related issues -->
Closes #
EOF

    # Create Dependabot configuration
    cat > .github/dependabot.yml << 'EOF'
version: 2
updates:
  # Enable version updates for npm
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
      day: "monday"
      time: "09:00"
    open-pull-requests-limit: 10
    reviewers:
      - "your-team"
    assignees:
      - "your-team"
    commit-message:
      prefix: "chore"
      prefix-development: "chore"
      include: "scope"
    labels:
      - "dependencies"
      - "automated"
    ignore:
      # Ignore major version updates for critical packages
      - dependency-name: "typescript"
        update-types: ["version-update:semver-major"]
      - dependency-name: "react"
        update-types: ["version-update:semver-major"]
EOF

    # Create branch protection configuration
    cat > .github/branch-protection.yml << 'EOF'
# Branch Protection Rules Configuration
# This file documents the branch protection rules that should be applied

## Main Branch Protection
- Require pull request reviews before merging
- Require status checks to pass before merging
- Require branches to be up to date before merging
- Include administrators in restrictions
- Restrict pushes that create files larger than 100 MB

## Required Status Checks
- lint
- test
- build
- security
- docs

## Required Reviewers
- At least 2 approving reviews for main branch
- At least 1 approving review for develop branch
- Dismiss stale PR approvals when new commits are pushed

## Restrictions
- No direct pushes to main or develop branches
- No force pushes
- No deletion of protected branches
EOF

    log_success "CI/CD workflows created successfully!"
}

# Function to create Husky hooks and enforcement setup
create_enforcement_setup() {
    log_info "Setting up enforcement tools..."
    
    if [[ "$DRY_RUN" == true ]]; then
        log_verbose "Would create enforcement setup"
        return
    fi
    
    # Create scripts directory
    mkdir -p scripts
    
    # Create environment validation script
    cat > scripts/validate-env.js << 'EOF'
#!/usr/bin/env node

/**
 * Environment validation script
 * Validates that all required environment variables are set
 */

const fs = require('fs');
const path = require('path');

const requiredEnvVars = [
  'NODE_ENV',
  'PORT',
  'DATABASE_URL',
  'JWT_SECRET'
];

function validateEnvironment() {
  console.log('🔍 Validating environment configuration...');
  
  const missingVars = [];
  
  for (const envVar of requiredEnvVars) {
    if (!process.env[envVar]) {
      missingVars.push(envVar);
    }
  }
  
  if (missingVars.length > 0) {
    console.error('❌ Missing required environment variables:');
    missingVars.forEach(varName => {
      console.error(`   - ${varName}`);
    });
    console.error('\nPlease set these variables in your .env file');
    process.exit(1);
  }
  
  console.log('✅ Environment validation passed');
}

if (require.main === module) {
  validateEnvironment();
}

module.exports = { validateEnvironment };
EOF

    chmod +x scripts/validate-env.js
    
    # Create test setup file
    cat > test/setup.ts << 'EOF'
/**
 * Test setup file
 * Configure test environment and global test utilities
 */

import '@testing-library/jest-dom';

// Global test configuration
beforeAll(() => {
  // Setup test environment
  process.env.NODE_ENV = 'test';
  process.env.DATABASE_URL = 'postgresql://test:test@localhost:5432/test_db';
});

afterAll(() => {
  // Cleanup test environment
});

// Global test utilities
global.console = {
  ...console,
  // Suppress console.log in tests unless explicitly needed
  log: jest.fn(),
  debug: jest.fn(),
  info: jest.fn(),
  warn: jest.fn(),
  error: jest.fn(),
};
EOF

    # Create VS Code settings
    mkdir -p .vscode
    cat > .vscode/settings.json << 'EOF'
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": "explicit"
  },
  "typescript.preferences.importModuleSpecifier": "relative",
  "typescript.suggest.autoImports": true,
  "typescript.updateImportsOnFileMove.enabled": "always",
  "files.exclude": {
    "**/node_modules": true,
    "**/dist": true,
    "**/build": true,
    "**/coverage": true,
    "**/.git": true
  },
  "search.exclude": {
    "**/node_modules": true,
    "**/dist": true,
    "**/build": true,
    "**/coverage": true
  },
  "files.associations": {
    "*.ts": "typescript",
    "*.tsx": "typescriptreact"
  }
}
EOF

    # Create VS Code extensions recommendations
    cat > .vscode/extensions.json << 'EOF'
{
  "recommendations": [
    "esbenp.prettier-vscode",
    "dbaeumer.vscode-eslint",
    "ms-vscode.vscode-typescript-next",
    "bradlc.vscode-tailwindcss",
    "ms-vscode.vscode-json",
    "yzhang.markdown-all-in-one",
    "ms-vscode.vscode-git-graph",
    "eamodio.gitlens",
    "ms-vscode.vscode-docker",
    "ms-azuretools.vscode-docker"
  ]
}
EOF

    log_success "Enforcement tools setup completed!"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --name|-n)
            PROJECT_NAME="$2"
            shift 2
            ;;
        --description|-d)
            PROJECT_DESCRIPTION="$2"
            shift 2
            ;;
        --frontend|-f)
            FRONTEND_FRAMEWORK="$2"
            validate_choice "$FRONTEND_FRAMEWORK" "react vue angular nextjs" "frontend framework"
            shift 2
            ;;
        --backend|-b)
            BACKEND_FRAMEWORK="$2"
            validate_choice "$BACKEND_FRAMEWORK" "node python dotnet java" "backend framework"
            shift 2
            ;;
        --database|-db)
            DATABASE="$2"
            validate_choice "$DATABASE" "postgresql mysql mongodb sqlite" "database"
            shift 2
            ;;
        --deployment|-dep)
            DEPLOYMENT="$2"
            validate_choice "$DEPLOYMENT" "docker kubernetes serverless" "deployment"
            shift 2
            ;;
        --template|-t)
            PROJECT_TEMPLATE="$2"
            validate_choice "$PROJECT_TEMPLATE" "saas ecommerce api dashboard mobile" "project template"
            apply_template "$PROJECT_TEMPLATE"
            shift 2
            ;;
        --environment|-e)
            ENVIRONMENT="$2"
            validate_choice "$ENVIRONMENT" "development staging production" "environment"
            shift 2
            ;;
        --interactive|-i)
            INTERACTIVE_MODE=true
            shift
            ;;
        --dry-run|-dr)
            DRY_RUN=true
            shift
            ;;
        --verbose|-v)
            VERBOSE=true
            shift
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
        *)
            log_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Main execution
main() {
    # Show header
    print -P "%F{blue}🚀 Enhanced Project Initialization Script v${VERSION}%f"
    print -P "%F{blue}================================================%f"
    echo ""
    
    # Run interactive setup if requested
    if [[ "$INTERACTIVE_MODE" == true ]]; then
        interactive_setup
    fi
    
    # Show configuration summary
    show_configuration
    
    # Check if project directory already exists
    if [[ -d "$PROJECT_NAME" ]] && [[ "$DRY_RUN" == false ]]; then
        log_error "Project directory '$PROJECT_NAME' already exists!"
        log_info "Please remove it or choose a different name."
        exit 1
    fi
    
    # Create project structure
    create_directory_structure
    
    # Create configuration files (includes all enforcement tools)
    create_configuration_files
    
    # Create environment-specific files
    create_environment_files
    
    # Create development scripts
    create_development_scripts
    
    # Create CI/CD workflows
    create_cicd_workflows
    
    # Create Husky hooks and enforcement setup
    create_enforcement_setup
    
    # Show final summary
    log_success "Project '$PROJECT_NAME' setup completed successfully!"
    echo ""
    print -P "%F{blue}📋 Next Steps:%f"
    print -P "%F{yellow}1.%f Navigate to the project directory:"
    print -P "   %F{green}cd $PROJECT_NAME%f"
    echo ""
    print -P "%F{yellow}2.%f Install dependencies:"
    print -P "   %F{green}npm install%f"
    echo ""
    print -P "%F{yellow}3.%f Set up Git hooks:"
    print -P "   %F{green}npm run prepare%f"
    echo ""
    print -P "%F{yellow}4.%f Start development:"
    print -P "   %F{green}npm run dev%f"
    echo ""
    print -P "%F{cyan}Happy coding! 🎉%f"
}

# Run main function
main "$@" 