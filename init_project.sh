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
    
    # Create root package.json for monorepo
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
    "lint": "npm run lint:frontend && npm run lint:backend",
    "lint:frontend": "cd frontend && npm run lint",
    "lint:backend": "cd backend && npm run lint",
    "format": "prettier --write \"**/*.{js,jsx,ts,tsx,json,css,md}\"",
    "prepare": "husky install"
  },
  "devDependencies": {
    "concurrently": "^8.2.2",
    "prettier": "^3.1.0",
    "husky": "^8.0.3",
    "lint-staged": "^15.2.0"
  },
  "lint-staged": {
    "*.{js,jsx,ts,tsx}": [
      "eslint --fix",
      "prettier --write"
    ],
    "*.{json,css,md}": [
      "prettier --write"
    ]
  },
  "keywords": ["monorepo", "fullstack", "webapp"],
  "author": "Your Team",
  "license": "MIT"
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
    
    # Create main CI workflow
    cat > .github/workflows/ci.yml << 'EOF'
name: CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    runs-on: ubuntu-latest
    
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
      run: npm run install:all
    
    - name: Run linting
      run: npm run lint
    
    - name: Run tests
      run: npm run test
      env:
        DATABASE_URL: postgresql://postgres:postgres@localhost:5432/test_db
    
    - name: Build project
      run: npm run build
EOF

    # Create deployment workflows for each environment
    cat > .github/workflows/deploy-$ENVIRONMENT.yml << 'EOF'
name: Deploy to '$ENVIRONMENT'

on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '18'
        cache: 'npm'
    
    - name: Install dependencies
      run: npm run install:all
    
    - name: Build project
      run: npm run build
    
    - name: Deploy to '$ENVIRONMENT'
      run: |
        echo "🚀 Deploying to '$ENVIRONMENT' environment..."
        # Add your deployment logic here
        # This could be deploying to AWS, GCP, Azure, etc.
EOF

    log_success "CI/CD workflows created successfully!"
}

# Function to create final summary and next steps
create_final_summary() {
    echo ""
    print -P "%F{green}🎉 Project '$PROJECT_NAME' created successfully!%f"
    echo ""
    print -P "%F{blue}📋 Next Steps:%f"
    print -P "%F{yellow}1.%f Navigate to the project directory:"
    print -P "   %F{green}cd $PROJECT_NAME%f"
    echo ""
    print -P "%F{yellow}2.%f Install all dependencies:"
    print -P "   %F{green}npm run install:all%f"
    echo ""
    print -P "%F{yellow}3.%f Set up environment variables for $ENVIRONMENT:"
    print -P "   %F{green}cp backend/.env.$ENVIRONMENT backend/.env%f"
    if [[ -n "$FRONTEND_FRAMEWORK" ]]; then
        print -P "   %F{green}cp frontend/.env.$ENVIRONMENT frontend/.env%f"
    fi
    echo ""
    print -P "%F{yellow}4.%f Set up database:"
    print -P "   %F{green}cd backend && ./scripts/migrate.sh%f"
    echo ""
    print -P "%F{yellow}5.%f Start the $ENVIRONMENT environment:"
    print -P "   %F{green}./scripts/start-$ENVIRONMENT.sh local%f"
    print -P "   %F{green}   or%f"
    print -P "   %F{green}./scripts/start-$ENVIRONMENT.sh docker%f"
    echo ""
    print -P "%F{yellow}6.%f Configure CI/CD (optional):"
    print -P "   %F{green}📚 Review .github/workflows/ for GitHub Actions%f"
    print -P "   %F{green}🔐 Set up repository secrets for deployment%f"
    echo ""
    print -P "%F{blue}🎯 Project Features:%f"
    print -P "%F{yellow}•%f Professional project structure"
    print -P "%F{yellow}•%f Pre-configured dev tools (ESLint, Prettier, Husky)"
    print -P "%F{yellow}•%f Docker and CI/CD configurations"
    print -P "%F{yellow}•%f Environment-specific settings"
    print -P "%F{yellow}•%f Database setup and migrations"
    print -P "%F{yellow}•%f Testing framework"
    print -P "%F{yellow}•%f Development scripts"
    echo ""
    print -P "%F{blue}🌍 Environment:%f $ENVIRONMENT configuration applied"
    print -P "%F{blue}🚀 Quick start:%f ./scripts/start-$ENVIRONMENT.sh local"
    print -P "%F{blue}🔧 CI/CD:%f GitHub Actions workflows configured"
    echo ""
    print -P "%F{cyan}Happy coding! 🎉%f"
}

# Function to create database migrations and seeds
create_database_files() {
    log_info "Creating database migrations and seeds..."
    
    if [[ "$DRY_RUN" == true ]]; then
        log_verbose "Would create database files"
        return
    fi
    
    # Create migration directory structure
    mkdir -p backend/migrations
    mkdir -p backend/seeds
    mkdir -p backend/scripts
    
    # Initial migration file
    cat > backend/migrations/001_initial_schema.sql << 'EOF'
-- Initial database schema for '$PROJECT_NAME'
-- Created: $(date)

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users table
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create index on email
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- Update timestamp trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Add trigger to users table
CREATE TRIGGER update_users_updated_at 
    BEFORE UPDATE ON users 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();
EOF

    # Seed data for development
    cat > backend/seeds/001_development_data.sql << 'EOF'
-- Development seed data for '$PROJECT_NAME'
-- This file is only used in development environment

-- Insert sample users
INSERT INTO users (email, password_hash, first_name, last_name) VALUES
('admin@example.com', '$2b$10$example.hash.here', 'Admin', 'User'),
('user@example.com', '$2b$10$example.hash.here', 'Test', 'User')
ON CONFLICT (email) DO NOTHING;
EOF

    # Migration runner script
    cat > backend/scripts/migrate.sh << 'EOF'
#!/bin/zsh

# Database migration script
set -e

ENVIRONMENT=${NODE_ENV:-development}
DB_HOST=${DB_HOST:-localhost}
DB_PORT=${DB_PORT:-5432}
DB_NAME=${DB_NAME:-'$PROJECT_NAME'_dev}
DB_USER=${DB_USER:-postgres}

echo "Running migrations for environment: $ENVIRONMENT"
echo "Database: $DB_NAME on $DB_HOST:$DB_PORT"

# Run migrations
for file in migrations/*.sql; do
    if [[ -f "$file" ]]; then
        echo "Running migration: $file"
        PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f "$file"
    fi
done

# Run seeds only in development
if [[ "$ENVIRONMENT" == "development" ]]; then
    echo "Running seed data for development..."
    for file in seeds/*.sql; do
        if [[ -f "$file" ]]; then
            echo "Running seed: $file"
            PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f "$file"
        fi
    done
fi

echo "Migrations completed successfully!"
EOF

    chmod +x backend/scripts/migrate.sh
    
    log_success "Database migrations and seeds created successfully!"
}

# Function to create backend starter files
create_backend_files() {
    log_info "Creating backend starter files..."
    
    if [[ "$DRY_RUN" == true ]]; then
        log_verbose "Would create backend files"
        return
    fi
    
    case $BACKEND_FRAMEWORK in
        "node")
            # Main server file
            cat > backend/src/index.js << 'EOF'
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3001;

// Middleware
app.use(helmet());
app.use(cors({
  origin: process.env.CORS_ORIGIN || 'http://localhost:3000',
  credentials: true
}));
app.use(morgan('combined'));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ 
    status: 'OK', 
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV || 'development'
  });
});

// API routes
app.use('/api', require('./routes'));

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ 
    error: 'Something went wrong!',
    message: process.env.NODE_ENV === 'development' ? err.message : 'Internal server error'
  });
});

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({ error: 'Route not found' });
});

app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
  console.log(`🌍 Environment: ${process.env.NODE_ENV || 'development'}`);
  console.log(`📊 Health check: http://localhost:${PORT}/health`);
});

module.exports = app;
EOF

            # Routes index
            cat > backend/src/routes/index.js << 'EOF'
const express = require('express');
const router = express.Router();

// Import route modules
const authRoutes = require('./auth');
const userRoutes = require('./users');

// Mount routes
router.use('/auth', authRoutes);
router.use('/users', userRoutes);

// API info endpoint
router.get('/', (req, res) => {
  res.json({
    message: 'Welcome to '$PROJECT_NAME' API',
    version: '1.0.0',
    environment: process.env.NODE_ENV || 'development',
    endpoints: {
      auth: '/api/auth',
      users: '/api/users',
      health: '/health'
    }
  });
});

module.exports = router;
EOF

            # Auth routes
            cat > backend/src/routes/auth.js << 'EOF'
const express = require('express');
const router = express.Router();

// Login endpoint
router.post('/login', (req, res) => {
  // TODO: Implement login logic
  res.json({ message: 'Login endpoint - implement authentication logic' });
});

// Register endpoint
router.post('/register', (req, res) => {
  // TODO: Implement registration logic
  res.json({ message: 'Register endpoint - implement user creation logic' });
});

// Logout endpoint
router.post('/logout', (req, res) => {
  // TODO: Implement logout logic
  res.json({ message: 'Logout endpoint - implement session cleanup' });
});

module.exports = router;
EOF

            # User routes
            cat > backend/src/routes/users.js << 'EOF'
const express = require('express');
const router = express.Router();

// Get all users
router.get('/', (req, res) => {
  // TODO: Implement user listing logic
  res.json({ message: 'Get users endpoint - implement user listing logic' });
});

// Get user by ID
router.get('/:id', (req, res) => {
  // TODO: Implement user retrieval logic
  res.json({ message: `Get user ${req.params.id} - implement user retrieval logic` });
});

// Update user
router.put('/:id', (req, res) => {
  // TODO: Implement user update logic
  res.json({ message: `Update user ${req.params.id} - implement user update logic` });
});

// Delete user
router.delete('/:id', (req, res) => {
  // TODO: Implement user deletion logic
  res.json({ message: `Delete user ${req.params.id} - implement user deletion logic` });
});

module.exports = router;
EOF

            # Database configuration
            cat > backend/src/config/database.js << 'EOF'
const { Pool } = require('pg');

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false,
  max: 20,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
});

// Test database connection
pool.on('connect', () => {
  console.log('📊 Connected to database');
});

pool.on('error', (err) => {
  console.error('❌ Database connection error:', err);
});

module.exports = pool;
EOF

            # Backend package.json
            cat > backend/package.json << 'EOF'
{
  "name": "backend",
  "version": "1.0.0",
  "description": "'$PROJECT_NAME' Backend API",
  "main": "src/index.js",
  "scripts": {
    "start": "node src/index.js",
    "dev": "nodemon src/index.js",
    "test": "jest",
    "lint": "eslint src/",
    "db:setup": "./scripts/migrate.sh"
  },
  "dependencies": {
    "express": "^4.18.2",
    "cors": "^2.8.5",
    "helmet": "^7.1.0",
    "morgan": "^1.10.0",
    "dotenv": "^16.3.1",
    "pg": "^8.11.3",
    "bcryptjs": "^2.4.3",
    "jsonwebtoken": "^9.0.2",
    "express-validator": "^7.0.1"
  },
  "devDependencies": {
    "nodemon": "^3.0.2",
    "jest": "^29.7.0",
    "eslint": "^8.55.0",
    "supertest": "^6.3.3"
  },
  "keywords": ["api", "backend", "express", "nodejs"],
  "author": "Your Team",
  "license": "MIT"
}
EOF
            ;;
    esac
    
    log_success "Backend starter files created successfully!"
}

# Function to create frontend starter files
create_frontend_files() {
    if [[ -z "$FRONTEND_FRAMEWORK" ]]; then
        return
    fi
    
    log_info "Creating frontend starter files..."
    
    if [[ "$DRY_RUN" == true ]]; then
        log_verbose "Would create frontend files"
        return
    fi
    
    case $FRONTEND_FRAMEWORK in
        "react")
            # Main React entry point
            cat > frontend/src/main.jsx << 'EOF'
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.jsx'
import './index.css'

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
)
EOF

            # Main App component
            cat > frontend/src/App.jsx << 'EOF'
import React, { useState, useEffect } from 'react'
import './App.css'

function App() {
  const [health, setHealth] = useState(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    // Test API connection
    fetch('http://localhost:3001/health')
      .then(res => res.json())
      .then(data => {
        setHealth(data)
        setLoading(false)
      })
      .catch(err => {
        console.error('API connection failed:', err)
        setLoading(false)
      })
  }, [])

  return (
    <div className="App">
      <header className="App-header">
        <h1>Welcome to '$PROJECT_NAME'</h1>
        <p>A modern web application built with React</p>
        
        {loading ? (
          <p>Connecting to API...</p>
        ) : health ? (
          <div className="api-status">
            <h3>✅ API Status: {health.status}</h3>
            <p>Environment: {health.environment}</p>
            <p>Timestamp: {new Date(health.timestamp).toLocaleString()}</p>
          </div>
        ) : (
          <div className="api-status">
            <h3>❌ API Connection Failed</h3>
            <p>Make sure the backend server is running on port 3001</p>
          </div>
        )}
        
        <div className="features">
          <h3>🚀 Features</h3>
          <ul>
            <li>React 18 with Vite</li>
            <li>Hot module replacement</li>
            <li>API integration</li>
            <li>Environment: '$ENVIRONMENT'</li>
          </ul>
        </div>
      </header>
    </div>
  )
}

export default App
EOF

            # CSS files
            cat > frontend/src/App.css << 'EOF'
.App {
  text-align: center;
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

.App-header {
  padding: 2rem;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
}

.App-header h1 {
  font-size: 3rem;
  margin-bottom: 1rem;
  text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
}

.App-header p {
  font-size: 1.2rem;
  margin-bottom: 2rem;
  opacity: 0.9;
}

.api-status {
  background: rgba(255,255,255,0.1);
  padding: 1.5rem;
  border-radius: 10px;
  margin: 1rem 0;
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255,255,255,0.2);
}

.api-status h3 {
  margin: 0 0 1rem 0;
  font-size: 1.5rem;
}

.features {
  margin-top: 2rem;
  background: rgba(255,255,255,0.1);
  padding: 1.5rem;
  border-radius: 10px;
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255,255,255,0.2);
}

.features h3 {
  margin: 0 0 1rem 0;
  font-size: 1.5rem;
}

.features ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.features li {
  padding: 0.5rem 0;
  font-size: 1.1rem;
}
EOF

            cat > frontend/src/index.css << 'EOF'
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen',
    'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue',
    sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

code {
  font-family: source-code-pro, Menlo, Monaco, Consolas, 'Courier New',
    monospace;
}
EOF

            # Vite config
            cat > frontend/vite.config.js << 'EOF'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    port: 3000,
    proxy: {
      '/api': {
        target: 'http://localhost:3001',
        changeOrigin: true,
      },
    },
  },
})
EOF

            # HTML template
            cat > frontend/index.html << 'EOF'
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href="/vite.svg" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>'$PROJECT_NAME'</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.jsx"></script>
  </body>
</html>
EOF

            # Frontend package.json
            cat > frontend/package.json << 'EOF'
{
  "name": "frontend",
  "private": true,
  "version": "0.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "lint": "eslint . --ext js,jsx --report-unused-disable-directives --max-warnings 0",
    "preview": "vite preview"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  },
  "devDependencies": {
    "@types/react": "^18.2.43",
    "@types/react-dom": "^18.2.17",
    "@vitejs/plugin-react": "^4.2.1",
    "eslint": "^8.55.0",
    "eslint-plugin-react": "^7.33.2",
    "eslint-plugin-react-hooks": "^4.6.0",
    "eslint-plugin-react-refresh": "^0.4.5",
    "vite": "^5.0.8"
  }
}
EOF
            ;;
    esac
    
    log_success "Frontend starter files created successfully!"
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
    
    # Create configuration files
    create_configuration_files
    
    # Create environment-specific files
    create_environment_files
    
    # Create database migrations and seeds
    create_database_files
    
    # Create backend starter files
    create_backend_files
    
    # Create frontend starter files
    create_frontend_files
    
    # Create development scripts
    create_development_scripts
    
    # Create CI/CD workflows
    create_cicd_workflows
    
    # Show final summary
    create_final_summary
}

# Run main function
main "$@" 