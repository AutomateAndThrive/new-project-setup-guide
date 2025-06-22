#!/bin/bash
# ==============================================================================
# Comprehensive Project Initialization Script
#
# Description:
#   This script automates the complete setup of a new monorepo project.
#   It creates the entire directory structure, initializes Git with the correct
#   branching strategy, and creates placeholder configuration and source files.
#
# Usage:
#   Basic usage: ./init_project.sh
#   Custom usage: ./init_project.sh --name "my-project" --frontend "react" --backend "node"
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
#   --help, -h          Show this help message
# ==============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

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

# Function to show help
show_help() {
    echo -e "${BLUE}Project Initialization Script${NC}"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --name, -n          Project name (default: my-project)"
    echo "  --description, -d   Project description"
    echo "  --frontend, -f      Frontend framework (react, vue, angular, nextjs)"
    echo "  --backend, -b       Backend framework (node, python, dotnet, java)"
    echo "  --database, -db     Database (postgresql, mysql, mongodb, sqlite)"
    echo "  --deployment, -dep  Deployment (docker, kubernetes, serverless)"
    echo "  --template, -t      Project template (saas, ecommerce, api, dashboard, mobile)"
    echo "  --environment, -e   Environment (development, staging, production)"
    echo "  --interactive, -i   Interactive mode for guided setup"
    echo "  --help, -h          Show this help message"
    echo ""
}

# Function to validate tech stack choices
validate_choice() {
    local value="$1"
    local valid_options="$2"
    local option_name="$3"
    
    if [[ ! " $valid_options " =~ " $value " ]]; then
        echo -e "${RED}❌ Invalid $option_name: '$value'${NC}"
        echo -e "${YELLOW}Valid options: $valid_options${NC}"
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
            echo -e "${GREEN}✅ Applied SaaS template${NC}"
            ;;
        "ecommerce")
            PROJECT_DESCRIPTION="An e-commerce platform with product catalog, shopping cart, and payment processing"
            FRONTEND_FRAMEWORK="nextjs"
            BACKEND_FRAMEWORK="node"
            DATABASE="postgresql"
            DEPLOYMENT="docker"
            echo -e "${GREEN}✅ Applied E-commerce template${NC}"
            ;;
        "api")
            PROJECT_DESCRIPTION="A RESTful API service with comprehensive documentation and testing"
            FRONTEND_FRAMEWORK=""
            BACKEND_FRAMEWORK="node"
            DATABASE="postgresql"
            DEPLOYMENT="docker"
            echo -e "${GREEN}✅ Applied API template${NC}"
            ;;
        "dashboard")
            PROJECT_DESCRIPTION="An admin dashboard with analytics, user management, and reporting"
            FRONTEND_FRAMEWORK="react"
            BACKEND_FRAMEWORK="node"
            DATABASE="postgresql"
            DEPLOYMENT="docker"
            echo -e "${GREEN}✅ Applied Dashboard template${NC}"
            ;;
        "mobile")
            PROJECT_DESCRIPTION="A mobile app backend with user management and push notifications"
            FRONTEND_FRAMEWORK=""
            BACKEND_FRAMEWORK="node"
            DATABASE="mongodb"
            DEPLOYMENT="serverless"
            echo -e "${GREEN}✅ Applied Mobile Backend template${NC}"
            ;;
    esac
}

# Function for interactive setup
interactive_setup() {
    echo -e "${CYAN}🎯 Interactive Project Setup${NC}"
    echo -e "${CYAN}==========================${NC}"
    echo ""
    
    # Project name
    read -p "Project name [my-project]: " input_name
    PROJECT_NAME=${input_name:-"my-project"}
    
    # Project template selection
    echo -e "${YELLOW}Project templates:${NC}"
    echo "1) Custom project (choose your own tech stack)"
    echo "2) SaaS application (React + Node.js + PostgreSQL)"
    echo "3) E-commerce platform (Next.js + Node.js + PostgreSQL)"
    echo "4) API service (Node.js + PostgreSQL, no frontend)"
    echo "5) Admin dashboard (React + Node.js + PostgreSQL)"
    echo "6) Mobile backend (Node.js + MongoDB + Serverless)"
    read -p "Choose project template [1]: " template_choice
    
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
    if [ -z "$PROJECT_TEMPLATE" ] || [ "$template_choice" = "1" ]; then
        # Project description
        read -p "Project description [$PROJECT_DESCRIPTION]: " input_desc
        PROJECT_DESCRIPTION=${input_desc:-"$PROJECT_DESCRIPTION"}
        
        # Frontend framework (skip if API or mobile template)
        if [ -n "$FRONTEND_FRAMEWORK" ]; then
            echo -e "${YELLOW}Frontend frameworks:${NC}"
            echo "1) React (recommended)"
            echo "2) Vue"
            echo "3) Angular"
            echo "4) Next.js"
            read -p "Choose frontend framework [1]: " frontend_choice
            case ${frontend_choice:-1} in
                1) FRONTEND_FRAMEWORK="react" ;;
                2) FRONTEND_FRAMEWORK="vue" ;;
                3) FRONTEND_FRAMEWORK="angular" ;;
                4) FRONTEND_FRAMEWORK="nextjs" ;;
                *) FRONTEND_FRAMEWORK="react" ;;
            esac
        fi
        
        # Backend framework
        echo -e "${YELLOW}Backend frameworks:${NC}"
        echo "1) Node.js (recommended)"
        echo "2) Python/FastAPI"
        echo "3) .NET"
        echo "4) Java/Spring"
        read -p "Choose backend framework [1]: " backend_choice
        case ${backend_choice:-1} in
            1) BACKEND_FRAMEWORK="node" ;;
            2) BACKEND_FRAMEWORK="python" ;;
            3) BACKEND_FRAMEWORK="dotnet" ;;
            4) BACKEND_FRAMEWORK="java" ;;
            *) BACKEND_FRAMEWORK="node" ;;
        esac
        
        # Database
        echo -e "${YELLOW}Databases:${NC}"
        echo "1) PostgreSQL (recommended)"
        echo "2) MySQL"
        echo "3) MongoDB"
        echo "4) SQLite"
        read -p "Choose database [1]: " db_choice
        case ${db_choice:-1} in
            1) DATABASE="postgresql" ;;
            2) DATABASE="mysql" ;;
            3) DATABASE="mongodb" ;;
            4) DATABASE="sqlite" ;;
            *) DATABASE="postgresql" ;;
        esac
        
        # Deployment
        echo -e "${YELLOW}Deployment options:${NC}"
        echo "1) Docker (recommended)"
        echo "2) Kubernetes"
        echo "3) Serverless"
        read -p "Choose deployment [1]: " dep_choice
        case ${dep_choice:-1} in
            1) DEPLOYMENT="docker" ;;
            2) DEPLOYMENT="kubernetes" ;;
            3) DEPLOYMENT="serverless" ;;
            *) DEPLOYMENT="docker" ;;
        esac
        
        # Environment
        echo -e "${YELLOW}Environment:${NC}"
        echo "1) Development (local development with hot reloading)"
        echo "2) Staging (pre-production for testing)"
        echo "3) Production (production-ready configuration)"
        read -p "Choose environment [1]: " env_choice
        case ${env_choice:-1} in
            1) ENVIRONMENT="development" ;;
            2) ENVIRONMENT="staging" ;;
            3) ENVIRONMENT="production" ;;
            *) ENVIRONMENT="development" ;;
        esac
    fi
    
    echo ""
    echo -e "${GREEN}✅ Configuration complete!${NC}"
    echo ""
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
        --help|-h)
            show_help
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Unknown option: $1${NC}"
            show_help
            exit 1
            ;;
    esac
done

# Run interactive setup if requested
if [ "$INTERACTIVE_MODE" = true ]; then
    interactive_setup
fi

# Display configuration
echo -e "${BLUE}🚀 Initializing Project: $PROJECT_NAME${NC}"
echo -e "${BLUE}=====================================${NC}"
echo -e "${YELLOW}Project:${NC} $PROJECT_NAME"
echo -e "${YELLOW}Description:${NC} $PROJECT_DESCRIPTION"
echo -e "${YELLOW}Frontend:${NC} $FRONTEND_FRAMEWORK"
echo -e "${YELLOW}Backend:${NC} $BACKEND_FRAMEWORK"
echo -e "${YELLOW}Database:${NC} $DATABASE"
echo -e "${YELLOW}Deployment:${NC} $DEPLOYMENT"
echo -e "${YELLOW}Environment:${NC} $ENVIRONMENT"
echo ""

# Check if project directory already exists
if [ -d "$PROJECT_NAME" ]; then
    echo -e "${RED}❌ Project directory '$PROJECT_NAME' already exists!${NC}"
    echo -e "${YELLOW}Please remove it or choose a different name.${NC}"
  exit 1
fi

# Create project directory
echo -e "${BLUE}📁 Creating project structure...${NC}"
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# Create main project structure
mkdir -p {backend,docs,scripts,tests,assets}

# Create frontend structure only if needed
if [ -n "$FRONTEND_FRAMEWORK" ]; then
    mkdir -p frontend
    echo -e "${BLUE}📁 Creating frontend structure for $FRONTEND_FRAMEWORK...${NC}"
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
    echo -e "${BLUE}📁 Backend-only project - skipping frontend structure${NC}"
fi

# Create backend structure based on framework
echo -e "${BLUE}📁 Creating backend structure for $BACKEND_FRAMEWORK...${NC}"
case $BACKEND_FRAMEWORK in
    "node")
        mkdir -p backend/{src/{controllers,middleware,models,routes,services,utils,config},tests}
        mkdir -p backend/src/services/{api,auth,database}
        mkdir -p backend/src/models/{user,product}
        mkdir -p backend/src/controllers/{auth,user,product}
        mkdir -p backend/{migrations,seeds}
        ;;
    "python")
        mkdir -p backend/{app/{api,core,models,schemas,services,utils},tests}
        mkdir -p backend/app/api/{endpoints,dependencies}
        mkdir -p backend/app/core/{config,security}
mkdir -p backend/app/models
mkdir -p backend/app/schemas
        mkdir -p backend/app/services/{api,auth,database}
        ;;
    "dotnet")
        mkdir -p backend/{Controllers,Models,Services,Data,Configuration}
        mkdir -p backend/Controllers
        mkdir -p backend/Models
        mkdir -p backend/Services
        mkdir -p backend/Data
        mkdir -p backend/Configuration
        ;;
    "java")
        mkdir -p backend/src/main/java/{controllers,models,services,repositories,config}
        mkdir -p backend/src/main/resources
        mkdir -p backend/src/test/java
        mkdir -p backend/src/main/java/controllers
        mkdir -p backend/src/main/java/models
        mkdir -p backend/src/main/java/services
        mkdir -p backend/src/main/java/repositories
        mkdir -p backend/src/main/java/config
        ;;
esac

# Create documentation structure
mkdir -p docs/{api,deployment,development,user-guide}

# Create essential files
echo -e "${BLUE}📝 Creating configuration files...${NC}"

# Root level files - adjust scripts based on whether frontend exists
if [ -n "$FRONTEND_FRAMEWORK" ]; then
    cat > package.json << EOF
{
  "name": "$PROJECT_NAME",
  "version": "1.0.0",
  "description": "$PROJECT_DESCRIPTION",
  "main": "index.js",
  "scripts": {
    "dev": "concurrently \"npm run dev:backend\" \"npm run dev:frontend\"",
    "dev:frontend": "cd frontend && npm start",
    "dev:backend": "cd backend && npm run dev",
    "build": "cd frontend && npm run build",
    "test": "npm run test:frontend && npm run test:backend",
    "test:frontend": "cd frontend && npm test",
    "test:backend": "cd backend && npm test",
    "install:all": "npm install && cd frontend && npm install && cd ../backend && npm install",
    "setup:db": "cd backend && npm run db:setup",
    "lint": "npm run lint:frontend && npm run lint:backend",
    "lint:frontend": "cd frontend && npm run lint",
    "lint:backend": "cd backend && npm run lint"
  },
  "keywords": ["web-app", "monorepo", "$FRONTEND_FRAMEWORK", "$BACKEND_FRAMEWORK"],
  "author": "Your Team",
  "license": "MIT",
  "devDependencies": {
    "concurrently": "^8.2.2"
  }
}
EOF
else
    cat > package.json << EOF
{
  "name": "$PROJECT_NAME",
  "version": "1.0.0",
  "description": "$PROJECT_DESCRIPTION",
  "main": "index.js",
  "scripts": {
    "dev": "npm run dev:backend",
    "dev:backend": "cd backend && npm run dev",
    "test": "npm run test:backend",
    "test:backend": "cd backend && npm test",
    "install:all": "npm install && cd backend && npm install",
    "setup:db": "cd backend && npm run db:setup",
    "lint": "npm run lint:backend",
    "lint:backend": "cd backend && npm run lint"
  },
  "keywords": ["api", "backend", "$BACKEND_FRAMEWORK"],
  "author": "Your Team",
  "license": "MIT"
}
EOF
fi

# Create frontend package.json only if needed
if [ -n "$FRONTEND_FRAMEWORK" ]; then
    echo -e "${BLUE}📝 Creating frontend configuration for $FRONTEND_FRAMEWORK...${NC}"
    case $FRONTEND_FRAMEWORK in
        "react")
            cat > frontend/package.json << 'EOF'
{
  "name": "frontend",
  "version": "1.0.0",
  "private": true,
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.20.1",
    "axios": "^1.6.2",
    "tailwindcss": "^3.3.6"
  },
  "devDependencies": {
    "@types/react": "^18.2.45",
    "@types/react-dom": "^18.2.18",
    "typescript": "^5.3.3",
    "vite": "^5.0.8",
    "@vitejs/plugin-react": "^4.2.1"
  },
  "scripts": {
    "start": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "test": "vitest",
    "lint": "eslint src --ext .ts,.tsx"
  }
}
EOF
            ;;
        "vue")
            cat > frontend/package.json << 'EOF'
{
  "name": "frontend",
  "version": "1.0.0",
  "private": true,
  "dependencies": {
    "vue": "^3.3.0",
    "vue-router": "^4.2.0",
    "axios": "^1.6.2",
    "tailwindcss": "^3.3.6"
  },
  "devDependencies": {
    "@vitejs/plugin-vue": "^4.4.0",
    "typescript": "^5.3.3",
    "vite": "^5.0.8"
  },
  "scripts": {
    "start": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "test": "vitest",
    "lint": "eslint src --ext .vue,.ts"
  }
}
EOF
            ;;
        "angular")
            cat > frontend/package.json << 'EOF'
{
  "name": "frontend",
  "version": "1.0.0",
  "private": true,
  "dependencies": {
    "@angular/core": "^17.0.0",
    "@angular/common": "^17.0.0",
    "@angular/router": "^17.0.0",
    "@angular/platform-browser": "^17.0.0"
  },
  "devDependencies": {
    "@angular/cli": "^17.0.0",
    "@angular/compiler-cli": "^17.0.0",
    "typescript": "^5.3.3"
  },
  "scripts": {
    "start": "ng serve",
    "build": "ng build",
    "test": "ng test",
    "lint": "ng lint"
  }
}
EOF
            ;;
        "nextjs")
            cat > frontend/package.json << 'EOF'
{
  "name": "frontend",
  "version": "1.0.0",
  "private": true,
  "dependencies": {
    "next": "^14.0.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "axios": "^1.6.2",
    "tailwindcss": "^3.3.6"
  },
  "devDependencies": {
    "@types/node": "^20.0.0",
    "@types/react": "^18.2.45",
    "@types/react-dom": "^18.2.18",
    "typescript": "^5.3.3"
  },
  "scripts": {
    "start": "next dev",
    "build": "next build",
    "test": "jest",
    "lint": "next lint"
  }
}
EOF
            ;;
    esac
fi

# Create backend package.json based on framework
echo -e "${BLUE}📝 Creating backend configuration for $BACKEND_FRAMEWORK...${NC}"
case $BACKEND_FRAMEWORK in
    "node")
        cat > backend/package.json << 'EOF'
{
  "name": "backend",
  "version": "1.0.0",
  "description": "Backend API",
  "main": "src/index.js",
  "scripts": {
    "start": "node src/index.js",
    "dev": "nodemon src/index.js",
    "test": "jest",
    "lint": "eslint src",
    "db:setup": "./scripts/migrate.sh"
  },
  "dependencies": {
    "express": "^4.18.2",
    "cors": "^2.8.5",
    "helmet": "^7.1.0",
    "dotenv": "^16.3.1",
    "axios": "^1.6.2"
  },
  "devDependencies": {
    "nodemon": "^3.0.2",
    "jest": "^29.7.0",
    "eslint": "^8.55.0"
  },
  "keywords": ["api", "backend", "express", "nodejs"],
  "author": "Your Team",
  "license": "MIT"
}
EOF
        ;;
    "python")
        cat > backend/requirements.txt << 'EOF'
fastapi==0.104.1
uvicorn[standard]==0.24.0
sqlalchemy==2.0.23
pydantic==2.5.0
python-dotenv==1.0.0
requests==2.31.0
pytest==7.4.3
black==23.11.0
flake8==6.1.0
EOF
        ;;
    "dotnet")
        cat > backend/backend.csproj << 'EOF'
<Project Sdk="Microsoft.NET.Sdk.Web">
  <PropertyGroup>
    <TargetFramework>net8.0</TargetFramework>
    <Nullable>enable</Nullable>
    <ImplicitUsings>enable</ImplicitUsings>
  </PropertyGroup>
  <ItemGroup>
    <PackageReference Include="Microsoft.AspNetCore.OpenApi" Version="8.0.0" />
    <PackageReference Include="Swashbuckle.AspNetCore" Version="6.5.0" />
  </ItemGroup>
</Project>
EOF
        ;;
    "java")
        cat > backend/pom.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.2.0</version>
    </parent>
    <groupId>com.example</groupId>
    <artifactId>backend</artifactId>
    <version>1.0.0</version>
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
    </dependencies>
</project>
EOF
        ;;
esac

# Environment-specific configurations
echo -e "${BLUE}🔧 Setting up $ENVIRONMENT environment...${NC}"

# Create environment-specific Docker configurations
case $ENVIRONMENT in
    "development")
        # Development Docker setup
        cat > docker-compose.yml << EOF
version: '3.8'

services:
  backend:
    build: ./backend
    ports:
      - "3001:3001"
    environment:
      - NODE_ENV=development
      - PORT=3001
    volumes:
      - ./backend:/app
      - /app/node_modules
    depends_on:
      - database
    command: npm run dev

  database:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: ${PROJECT_NAME}_dev
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

volumes:
  postgres_data:
  redis_data:
EOF

        # Development environment file
        cat > backend/.env.development << EOF
# Development Environment Configuration
NODE_ENV=development
PORT=3001

# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=${PROJECT_NAME}_dev
DB_USER=postgres
DB_PASSWORD=password

# Redis Configuration
REDIS_HOST=localhost
REDIS_PORT=6379

# JWT Configuration
JWT_SECRET=dev-secret-key-change-in-production
JWT_EXPIRES_IN=24h

# CORS Configuration
CORS_ORIGIN=http://localhost:3000

# Logging
LOG_LEVEL=debug
ENABLE_DEBUG=true
EOF

        # Development frontend environment file (if frontend exists)
        if [ -n "$FRONTEND_FRAMEWORK" ]; then
            cat > frontend/.env.development << EOF
# Development Environment Configuration
VITE_API_URL=http://localhost:3001
VITE_ENVIRONMENT=development
VITE_DEBUG=true
VITE_ENABLE_LOGGING=true
EOF
        fi
        ;;

    "staging")
        # Staging Docker setup
        cat > docker-compose.staging.yml << EOF
version: '3.8'

services:
  backend:
    build: ./backend
    ports:
      - "3001:3001"
    environment:
      - NODE_ENV=staging
      - PORT=3001
    depends_on:
      - database
    restart: unless-stopped

  database:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: ${PROJECT_NAME}_staging
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: ${PROJECT_NAME}_staging_pass
    volumes:
      - postgres_staging_data:/var/lib/postgresql/data
    restart: unless-stopped

  redis:
    image: redis:7-alpine
    volumes:
      - redis_staging_data:/data
    restart: unless-stopped

volumes:
  postgres_staging_data:
  redis_staging_data:
EOF

        # Staging environment file
        cat > backend/.env.staging << EOF
# Staging Environment Configuration
NODE_ENV=staging
PORT=3001

# Database Configuration
DB_HOST=database
DB_PORT=5432
DB_NAME=${PROJECT_NAME}_staging
DB_USER=postgres
DB_PASSWORD=${PROJECT_NAME}_staging_pass

# Redis Configuration
REDIS_HOST=redis
REDIS_PORT=6379

# JWT Configuration
JWT_SECRET=staging-secret-key-change-in-production
JWT_EXPIRES_IN=24h

# CORS Configuration
CORS_ORIGIN=https://staging.${PROJECT_NAME}.com

# Logging
LOG_LEVEL=info
ENABLE_DEBUG=false
EOF

        # Staging frontend environment file (if frontend exists)
        if [ -n "$FRONTEND_FRAMEWORK" ]; then
            cat > frontend/.env.staging << EOF
# Staging Environment Configuration
VITE_API_URL=https://api-staging.${PROJECT_NAME}.com
VITE_ENVIRONMENT=staging
VITE_DEBUG=false
VITE_ENABLE_LOGGING=true
EOF
        fi
        ;;

    "production")
        # Production Docker setup
        cat > docker-compose.production.yml << EOF
version: '3.8'

services:
  backend:
    build: ./backend
    ports:
      - "3001:3001"
    environment:
      - NODE_ENV=production
      - PORT=3001
    depends_on:
      - database
    restart: always
    deploy:
      replicas: 2

  database:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: ${PROJECT_NAME}_prod
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: ${PROJECT_NAME}_prod_pass
    volumes:
      - postgres_prod_data:/var/lib/postgresql/data
    restart: always
    deploy:
      resources:
        limits:
          memory: 1G
        reservations:
          memory: 512M

  redis:
    image: redis:7-alpine
    volumes:
      - redis_prod_data:/data
    restart: always
    deploy:
      resources:
        limits:
          memory: 256M
        reservations:
          memory: 128M

volumes:
  postgres_prod_data:
  redis_prod_data:
EOF

        # Production environment file
        cat > backend/.env.production << EOF
# Production Environment Configuration
NODE_ENV=production
PORT=3001

# Database Configuration
DB_HOST=database
DB_PORT=5432
DB_NAME=${PROJECT_NAME}_prod
DB_USER=postgres
DB_PASSWORD=${PROJECT_NAME}_prod_pass

# Redis Configuration
REDIS_HOST=redis
REDIS_PORT=6379

# JWT Configuration
JWT_SECRET=CHANGE_THIS_TO_A_SECURE_SECRET
JWT_EXPIRES_IN=24h

# CORS Configuration
CORS_ORIGIN=https://${PROJECT_NAME}.com

# Logging
LOG_LEVEL=warn
ENABLE_DEBUG=false
EOF

        # Production frontend environment file (if frontend exists)
        if [ -n "$FRONTEND_FRAMEWORK" ]; then
            cat > frontend/.env.production << EOF
# Production Environment Configuration
VITE_API_URL=https://api.${PROJECT_NAME}.com
VITE_ENVIRONMENT=production
VITE_DEBUG=false
VITE_ENABLE_LOGGING=false
EOF
        fi
        ;;
esac

# Create environment-specific Dockerfile for backend
cat > backend/Dockerfile << EOF
FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy source code
COPY . .

# Create non-root user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nodejs -u 1001

# Change ownership
RUN chown -R nodejs:nodejs /app
USER nodejs

# Expose port
EXPOSE 3001

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \\
  CMD curl -f http://localhost:3001/health || exit 1

# Start the application
CMD ["npm", "start"]
EOF

# Create environment-specific scripts
cat > scripts/start-${ENVIRONMENT}.sh << EOF
#!/bin/bash
# Start script for $ENVIRONMENT environment

echo "🚀 Starting $PROJECT_NAME in $ENVIRONMENT mode..."

case "\$1" in
    "docker")
        echo "🐳 Starting with Docker Compose..."
        docker-compose -f docker-compose.${ENVIRONMENT}.yml up -d
        ;;
    "local")
        echo "💻 Starting locally..."
        cd backend
        cp .env.${ENVIRONMENT} .env
        npm install
        npm run dev &
        BACKEND_PID=\$!
        
        if [ -d "../frontend" ]; then
            cd ../frontend
            cp .env.${ENVIRONMENT} .env
            npm install
            npm run dev &
            FRONTEND_PID=\$!
            echo "Frontend PID: \$FRONTEND_PID"
        fi
        
        echo "Backend PID: \$BACKEND_PID"
        echo "Press Ctrl+C to stop all services"
        
        trap "kill \$BACKEND_PID \$FRONTEND_PID 2>/dev/null" INT
        wait
        ;;
    *)
        echo "Usage: \$0 {docker|local}"
        echo "  docker - Start with Docker Compose"
        echo "  local  - Start locally with npm"
        exit 1
        ;;
esac
EOF

chmod +x scripts/start-${ENVIRONMENT}.sh

# Create environment-specific deployment scripts
case $ENVIRONMENT in
    "development")
        # Development deployment is just local setup
        cat > scripts/deploy-dev.sh << EOF
#!/bin/bash
echo "🔧 Setting up development environment..."
echo "📦 Installing dependencies..."
npm run install:all
echo "🔐 Setting up environment variables..."
cp backend/.env.development backend/.env
if [ -d "frontend" ]; then
    cp frontend/.env.development frontend/.env
fi
echo "🗄️ Setting up database..."
cd backend && ./scripts/migrate.sh
echo "✅ Development environment ready!"
echo "🚀 Run: npm run dev"
EOF
        chmod +x scripts/deploy-dev.sh
        ;;
    
    "staging")
        # Staging deployment script
        cat > scripts/deploy-staging.sh << EOF
#!/bin/bash
echo "🚀 Deploying to staging environment..."

# Build and push Docker images
docker build -t ${PROJECT_NAME}-backend:staging ./backend
$(if [ -n "$FRONTEND_FRAMEWORK" ]; then echo "docker build -t ${PROJECT_NAME}-frontend:staging ./frontend"; fi)

# Deploy with Docker Compose
docker-compose -f docker-compose.staging.yml down
docker-compose -f docker-compose.staging.yml up -d

echo "✅ Staging deployment complete!"
echo "🌐 Backend: http://staging-api.${PROJECT_NAME}.com"
$(if [ -n "$FRONTEND_FRAMEWORK" ]; then echo "echo \"🌐 Frontend: http://staging.${PROJECT_NAME}.com\""; fi)
EOF
        chmod +x scripts/deploy-staging.sh
        ;;
    
    "production")
        # Production deployment script
        cat > scripts/deploy-production.sh << EOF
#!/bin/bash
echo "🚀 Deploying to production environment..."

# Build and push Docker images
docker build -t ${PROJECT_NAME}-backend:latest ./backend
$(if [ -n "$FRONTEND_FRAMEWORK" ]; then echo "docker build -t ${PROJECT_NAME}-frontend:latest ./frontend"; fi)

# Deploy with Docker Compose
docker-compose -f docker-compose.production.yml down
docker-compose -f docker-compose.production.yml up -d

echo "✅ Production deployment complete!"
echo "🌐 Backend: https://api.${PROJECT_NAME}.com"
$(if [ -n "$FRONTEND_FRAMEWORK" ]; then echo "echo \"🌐 Frontend: https://${PROJECT_NAME}.com\""; fi)
EOF
        chmod +x scripts/deploy-production.sh
        ;;
esac

# Create CI/CD templates
echo -e "${BLUE}🔧 Setting up CI/CD workflows...${NC}"

# Create GitHub Actions directory
mkdir -p .github/workflows

# Base workflow for all environments
cat > .github/workflows/ci.yml << EOF
name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop, staging ]
  pull_request:
    branches: [ main, develop, staging ]

env:
  NODE_VERSION: '18'
  POSTGRES_VERSION: '15'

jobs:
  lint-and-test:
    name: Lint and Test
    runs-on: ubuntu-latest
    
    services:
      postgres:
        image: postgres:\${{ env.POSTGRES_VERSION }}
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
      
      redis:
        image: redis:7-alpine
        options: >-
          --health-cmd "redis-cli ping"
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 6379:6379

    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: \${{ env.NODE_VERSION }}
        cache: 'npm'

    - name: Install dependencies
      run: |
        npm ci
        if [ -d "backend" ]; then
          cd backend && npm ci
        fi
        if [ -d "frontend" ]; then
          cd frontend && npm ci
        fi

    - name: Run linting
      run: |
        npm run lint
        if [ -d "backend" ]; then
          cd backend && npm run lint
        fi
        if [ -d "frontend" ]; then
          cd frontend && npm run lint
        fi

    - name: Run tests
      env:
        DB_HOST: localhost
        DB_PORT: 5432
        DB_NAME: test_db
        DB_USER: postgres
        DB_PASSWORD: postgres
        REDIS_HOST: localhost
        REDIS_PORT: 6379
      run: |
        npm run test
        if [ -d "backend" ]; then
          cd backend && npm run test
        fi
        if [ -d "frontend" ]; then
          cd frontend && npm run test
        fi

    - name: Build application
      run: |
        if [ -d "backend" ]; then
          cd backend && npm run build
        fi
        if [ -d "frontend" ]; then
          cd frontend && npm run build
        fi

  security-scan:
    name: Security Scan
    runs-on: ubuntu-latest
    needs: lint-and-test
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: \${{ env.NODE_VERSION }}
        cache: 'npm'

    - name: Install dependencies
      run: npm ci

    - name: Run security audit
      run: npm audit --audit-level moderate

    - name: Run SAST scan
      uses: github/codeql-action/init@v3
      with:
        languages: javascript

    - name: Perform CodeQL Analysis
      uses: github/codeql-action/analyze@v3
EOF

# Environment-specific deployment workflows
case $ENVIRONMENT in
    "development")
        cat > .github/workflows/deploy-development.yml << EOF
name: Deploy to Development

on:
  push:
    branches: [ develop ]
  pull_request:
    branches: [ develop ]

jobs:
  deploy-dev:
    name: Deploy to Development
    runs-on: ubuntu-latest
    needs: [lint-and-test, security-scan]
    environment: development
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Setup Docker Buildx
      uses: docker/setup-buildx-action@v3

    - name: Login to Container Registry
      uses: docker/login-action@v3
      with:
        registry: \${{ secrets.CONTAINER_REGISTRY }}
        username: \${{ secrets.REGISTRY_USERNAME }}
        password: \${{ secrets.REGISTRY_PASSWORD }}

    - name: Build and push backend image
      uses: docker/build-push-action@v5
      with:
        context: ./backend
        push: true
        tags: \${{ secrets.CONTAINER_REGISTRY }}/\${{ github.repository }}-backend:dev-\${{ github.sha }}
        cache-from: type=gha
        cache-to: type=gha,mode=max

$(if [ -n "$FRONTEND_FRAMEWORK" ]; then
echo "    - name: Build and push frontend image
      uses: docker/build-push-action@v5
      with:
        context: ./frontend
        push: true
        tags: \${{ secrets.CONTAINER_REGISTRY }}/\${{ github.repository }}-frontend:dev-\${{ github.sha }}
        cache-from: type=gha
        cache-to: type=gha,mode=max"
fi)

    - name: Deploy to development environment
      run: |
        echo "Deploying to development environment..."
        # Add your deployment commands here
        # Example: kubectl apply -f k8s/development/
        # or: docker-compose -f docker-compose.yml up -d
EOF
        ;;

    "staging")
        cat > .github/workflows/deploy-staging.yml << EOF
name: Deploy to Staging

on:
  push:
    branches: [ staging ]
  pull_request:
    branches: [ staging ]

jobs:
  deploy-staging:
    name: Deploy to Staging
    runs-on: ubuntu-latest
    needs: [lint-and-test, security-scan]
    environment: staging
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Setup Docker Buildx
      uses: docker/setup-buildx-action@v3

    - name: Login to Container Registry
      uses: docker/login-action@v3
      with:
        registry: \${{ secrets.CONTAINER_REGISTRY }}
        username: \${{ secrets.REGISTRY_USERNAME }}
        password: \${{ secrets.REGISTRY_PASSWORD }}

    - name: Build and push backend image
      uses: docker/build-push-action@v5
      with:
        context: ./backend
        push: true
        tags: \${{ secrets.CONTAINER_REGISTRY }}/\${{ github.repository }}-backend:staging-\${{ github.sha }}
        cache-from: type=gha
        cache-to: type=gha,mode=max

$(if [ -n "$FRONTEND_FRAMEWORK" ]; then
echo "    - name: Build and push frontend image
      uses: docker/build-push-action@v5
      with:
        context: ./frontend
        push: true
        tags: \${{ secrets.CONTAINER_REGISTRY }}/\${{ github.repository }}-frontend:staging-\${{ github.sha }}
        cache-from: type=gha
        cache-to: type=gha,mode=max"
fi)

    - name: Deploy to staging environment
      run: |
        echo "Deploying to staging environment..."
        # Add your deployment commands here
        # Example: kubectl apply -f k8s/staging/
        # or: docker-compose -f docker-compose.staging.yml up -d

    - name: Run integration tests
      run: |
        echo "Running integration tests against staging..."
        # Add integration test commands here
        # Example: npm run test:integration -- --baseUrl=https://staging.example.com
EOF
        ;;

    "production")
        cat > .github/workflows/deploy-production.yml << EOF
name: Deploy to Production

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  deploy-production:
    name: Deploy to Production
    runs-on: ubuntu-latest
    needs: [lint-and-test, security-scan]
    environment: production
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Setup Docker Buildx
      uses: docker/setup-buildx-action@v3

    - name: Login to Container Registry
      uses: docker/login-action@v3
      with:
        registry: \${{ secrets.CONTAINER_REGISTRY }}
        username: \${{ secrets.REGISTRY_USERNAME }}
        password: \${{ secrets.REGISTRY_PASSWORD }}

    - name: Build and push backend image
      uses: docker/build-push-action@v5
      with:
        context: ./backend
        push: true
        tags: |
          \${{ secrets.CONTAINER_REGISTRY }}/\${{ github.repository }}-backend:latest
          \${{ secrets.CONTAINER_REGISTRY }}/\${{ github.repository }}-backend:prod-\${{ github.sha }}
        cache-from: type=gha
        cache-to: type=gha,mode=max

$(if [ -n "$FRONTEND_FRAMEWORK" ]; then
echo "    - name: Build and push frontend image
      uses: docker/build-push-action@v5
      with:
        context: ./frontend
        push: true
        tags: |
          \${{ secrets.CONTAINER_REGISTRY }}/\${{ github.repository }}-frontend:latest
          \${{ secrets.CONTAINER_REGISTRY }}/\${{ github.repository }}-frontend:prod-\${{ github.sha }}
        cache-from: type=gha
        cache-to: type=gha,mode=max"
fi)

    - name: Deploy to production environment
      run: |
        echo "Deploying to production environment..."
        # Add your deployment commands here
        # Example: kubectl apply -f k8s/production/
        # or: docker-compose -f docker-compose.production.yml up -d

    - name: Run smoke tests
      run: |
        echo "Running smoke tests against production..."
        # Add smoke test commands here
        # Example: npm run test:smoke -- --baseUrl=https://example.com

    - name: Notify deployment success
      if: success()
      run: |
        echo "Production deployment successful!"
        # Add notification commands here (Slack, email, etc.)
EOF
        ;;
esac

# Create release workflow
cat > .github/workflows/release.yml << EOF
name: Create Release

on:
  push:
    tags:
      - 'v*'

jobs:
  create-release:
    name: Create Release
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Create Release
      uses: actions/create-release@v1
      env:
        GITHUB_TOKEN: \${{ secrets.GITHUB_TOKEN }}
      with:
        tag_name: \${{ github.ref }}
        release_name: Release \${{ github.ref }}
        draft: false
        prerelease: false

    - name: Generate changelog
      run: |
        echo "Generating changelog..."
        # Add changelog generation commands here
        # Example: npx conventional-changelog-cli -p angular -i CHANGELOG.md -s

    - name: Upload release assets
      uses: actions/upload-release-asset@v1
      env:
        GITHUB_TOKEN: \${{ secrets.GITHUB_TOKEN }}
      with:
        upload_url: \${{ steps.create-release.outputs.upload_url }}
        asset_path: ./dist/app.zip
        asset_name: app-\${{ github.ref_name }}.zip
        asset_content_type: application/zip
EOF

# Create dependency update workflow
cat > .github/workflows/dependency-update.yml << EOF
name: Dependency Updates

on:
  schedule:
    - cron: '0 2 * * 1'  # Every Monday at 2 AM
  workflow_dispatch:

jobs:
  update-dependencies:
    name: Update Dependencies
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '18'
        cache: 'npm'

    - name: Check for outdated dependencies
      run: |
        npm outdated || true
        if [ -d "backend" ]; then
          cd backend && npm outdated || true
        fi
        if [ -d "frontend" ]; then
          cd frontend && npm outdated || true
        fi

    - name: Create Pull Request
      uses: peter-evans/create-pull-request@v5
      with:
        token: \${{ secrets.GITHUB_TOKEN }}
        commit-message: 'chore: update dependencies'
        title: 'chore: update dependencies'
        body: |
          Automated dependency updates
          
          This PR updates outdated dependencies to their latest versions.
          
          Please review the changes and test thoroughly before merging.
        branch: dependency-updates
        delete-branch: true
EOF

# Create environment-specific secrets documentation
mkdir -p docs/ci-cd
cat > docs/ci-cd/README.md << EOF
# CI/CD Configuration

This project uses GitHub Actions for continuous integration and deployment.

## Workflows

### CI Pipeline (\`ci.yml\`)
- Runs on all pushes and pull requests
- Lints code and runs tests
- Performs security scans
- Builds the application

### Deployment Workflows
- **Development**: \`deploy-development.yml\` - Deploys to development environment
- **Staging**: \`deploy-staging.yml\` - Deploys to staging environment  
- **Production**: \`deploy-production.yml\` - Deploys to production environment

### Release Management
- **Release**: \`release.yml\` - Creates releases on tag push
- **Dependencies**: \`dependency-update.yml\` - Automated dependency updates

## Required Secrets

Configure these secrets in your GitHub repository settings:

### Container Registry
- \`CONTAINER_REGISTRY\` - Your container registry URL (e.g., ghcr.io)
- \`REGISTRY_USERNAME\` - Registry username
- \`REGISTRY_PASSWORD\` - Registry password/token

### Environment-Specific Secrets
- \`DEV_DEPLOY_KEY\` - SSH key for development deployment
- \`STAGING_DEPLOY_KEY\` - SSH key for staging deployment
- \`PROD_DEPLOY_KEY\` - SSH key for production deployment

### Optional Secrets
- \`SLACK_WEBHOOK_URL\` - For deployment notifications
- \`EMAIL_NOTIFICATION\` - For email notifications

## Environment Configuration

### Development
- Automatic deployment on push to \`develop\` branch
- No approval required
- Quick feedback loop

### Staging
- Automatic deployment on push to \`staging\` branch
- Integration tests run after deployment
- Manual approval may be required

### Production
- Deployment on push to \`main\` branch
- Manual approval required
- Smoke tests run after deployment
- Release notes generated

## Local Development

To test workflows locally:

\`\`\`bash
# Install act (GitHub Actions local runner)
brew install act

# Run specific workflow
act push -W .github/workflows/ci.yml

# Run with secrets
act push --secret-file .secrets
\`\`\`

## Customization

1. **Modify deployment steps** in the workflow files
2. **Add environment-specific variables** in GitHub repository settings
3. **Configure approval gates** in environment settings
4. **Add custom notifications** in the workflow steps

## Troubleshooting

- Check workflow logs in GitHub Actions tab
- Verify secrets are properly configured
- Ensure environment protection rules are set up
- Test workflows locally with \`act\`
EOF

# Create GitHub Actions configuration file
cat > .github/actions.yml << EOF
# GitHub Actions configuration
# This file can be used to configure repository-wide settings

# Enable required status checks for protected branches
required_status_checks:
  strict: true
  contexts:
    - lint-and-test
    - security-scan

# Required pull request reviews
required_pull_request_reviews:
  required_approving_review_count: 2
  dismiss_stale_reviews: true
  require_code_owner_reviews: true

# Branch protection rules
branch_protection_rules:
  - pattern: main
    required_status_checks:
      strict: true
      contexts:
        - lint-and-test
        - security-scan
    required_pull_request_reviews:
      required_approving_review_count: 2
    enforce_admins: true
    allow_force_pushes: false
    allow_deletions: false

  - pattern: staging
    required_status_checks:
      strict: true
      contexts:
        - lint-and-test
        - security-scan
    required_pull_request_reviews:
      required_approving_review_count: 1
    allow_force_pushes: false
    allow_deletions: false
EOF

# Create README - adjust based on project type and environment
if [ -n "$FRONTEND_FRAMEWORK" ]; then
    cat > README.md << EOF
# $PROJECT_NAME

$PROJECT_DESCRIPTION

## 🚀 Quick Start

1. **Install dependencies:**
   \`\`\`bash
   npm run install:all
   \`\`\`

2. **Set up environment variables:**
   \`\`\`bash
   cp backend/.env.${ENVIRONMENT} backend/.env
   cp frontend/.env.${ENVIRONMENT} frontend/.env
   \`\`\`

3. **Start development servers:**
   \`\`\`bash
   npm run dev
   \`\`\`

## 🏗️ Project Structure

\`\`\`
$PROJECT_NAME/
├── frontend/          # $FRONTEND_FRAMEWORK application
├── backend/           # $BACKEND_FRAMEWORK API server
├── docs/             # Documentation
├── scripts/          # Utility scripts
└── tests/            # Test files
\`\`\`

## 🛠️ Tech Stack

- **Frontend**: $FRONTEND_FRAMEWORK
- **Backend**: $BACKEND_FRAMEWORK
- **Database**: $DATABASE
- **Deployment**: $DEPLOYMENT
- **Environment**: $ENVIRONMENT

## 🌍 Environment Configuration

This project is configured for **$ENVIRONMENT** environment with:
- Environment-specific Docker configurations
- Environment-specific environment files (.env.${ENVIRONMENT})
- Appropriate security and debugging settings
- Deployment scripts for $ENVIRONMENT

### Environment-Specific Commands

- **Start locally**: \`./scripts/start-${ENVIRONMENT}.sh local\`
- **Start with Docker**: \`./scripts/start-${ENVIRONMENT}.sh docker\`
- **Deploy**: \`./scripts/deploy-${ENVIRONMENT}.sh\`

## 📝 License

MIT
EOF
else
    cat > README.md << EOF
# $PROJECT_NAME

$PROJECT_DESCRIPTION

## 🚀 Quick Start

1. **Install dependencies:**
   \`\`\`bash
   npm run install:all
   \`\`\`

2. **Set up environment variables:**
   \`\`\`bash
   cp backend/.env.${ENVIRONMENT} backend/.env
   \`\`\`

3. **Start development server:**
   \`\`\`bash
   npm run dev
   \`\`\`

## 🏗️ Project Structure

\`\`\`
$PROJECT_NAME/
├── backend/           # $BACKEND_FRAMEWORK API server
├── docs/             # Documentation
├── scripts/          # Utility scripts
└── tests/            # Test files
\`\`\`

## 🛠️ Tech Stack

- **Backend**: $BACKEND_FRAMEWORK
- **Database**: $DATABASE
- **Deployment**: $DEPLOYMENT
- **Environment**: $ENVIRONMENT

## 🌍 Environment Configuration

This project is configured for **$ENVIRONMENT** environment with:
- Environment-specific Docker configurations
- Environment-specific environment files (.env.${ENVIRONMENT})
- Appropriate security and debugging settings
- Deployment scripts for $ENVIRONMENT

### Environment-Specific Commands

- **Start locally**: \`./scripts/start-${ENVIRONMENT}.sh local\`
- **Start with Docker**: \`./scripts/start-${ENVIRONMENT}.sh docker\`
- **Deploy**: \`./scripts/deploy-${ENVIRONMENT}.sh\`

## 📝 License

MIT
EOF
fi

# Create development guide
cat > docs/development/README.md << EOF
# Development Guide

## Prerequisites

- Node.js 18+
- $DATABASE
- Docker (optional)

## Setup Instructions

1. **Clone and install:**
   ```bash
   git clone <repository-url>
   cd $PROJECT_NAME
   npm run install:all
   ```

2. **Environment configuration:**
   - Copy environment-specific .env files: \`cp backend/.env.${ENVIRONMENT} backend/.env\`
   - Configure your settings for $ENVIRONMENT environment
   - Ensure database connection details are correct

3. **Database setup:**
   ```bash
   # Run migrations
   cd backend
   ./scripts/migrate.sh
   ```

4. **Start development:**
   ```bash
   npm run dev
   ```

## Development Workflow
EOF

# Append dynamic workflow section
if [ -n "$FRONTEND_FRAMEWORK" ]; then
  echo "1. **Frontend**: http://localhost:3000" >> docs/development/README.md
fi
echo "1. **Backend API**: http://localhost:3001" >> docs/development/README.md
echo "2. **Database**: localhost:5432" >> docs/development/README.md
if [ "$ENVIRONMENT" = "development" ]; then
  echo "3. **Redis**: localhost:6379" >> docs/development/README.md
fi

echo "\n## Environment-Specific Features\n" >> docs/development/README.md
echo "### $ENVIRONMENT Environment" >> docs/development/README.md
case $ENVIRONMENT in
  "development")
    echo "- Hot reloading enabled" >> docs/development/README.md
    echo "- Debug mode active" >> docs/development/README.md
    echo "- Local database and Redis" >> docs/development/README.md
    echo "- Development-specific environment variables" >> docs/development/README.md
    ;;
  "staging")
    echo "- Production-like configuration" >> docs/development/README.md
    echo "- Health checks enabled" >> docs/development/README.md
    echo "- Restart policies configured" >> docs/development/README.md
    echo "- Staging-specific environment variables" >> docs/development/README.md
    ;;
  "production")
    echo "- Optimized for performance" >> docs/development/README.md
    echo "- Multiple replicas configured" >> docs/development/README.md
    echo "- Health checks and monitoring" >> docs/development/README.md
    echo "- Production security settings" >> docs/development/README.md
    echo "- Production-specific environment variables" >> docs/development/README.md
    ;;
esac

echo "\n## Key Development Commands\n" >> docs/development/README.md
echo "- \`npm run dev\` - Start $(if [ -n "$FRONTEND_FRAMEWORK" ]; then echo "both frontend and backend"; else echo "backend server"; fi)" >> docs/development/README.md
echo "- \`npm run test\` - Run all tests" >> docs/development/README.md
echo "- \`npm run lint\` - Run linting" >> docs/development/README.md
if [ -n "$FRONTEND_FRAMEWORK" ]; then
  echo "- \`npm run build\` - Build for production" >> docs/development/README.md
fi
echo "- \`cd backend && ./scripts/migrate.sh\` - Run database migrations" >> docs/development/README.md

echo "\n## Environment-Specific Commands\n" >> docs/development/README.md
echo "- \`./scripts/start-${ENVIRONMENT}.sh local\` - Start locally" >> docs/development/README.md
echo "- \`./scripts/start-${ENVIRONMENT}.sh docker\` - Start with Docker" >> docs/development/README.md
echo "- \`./scripts/deploy-${ENVIRONMENT}.sh\` - Deploy to $ENVIRONMENT" >> docs/development/README.md

echo "\n## Docker Commands\n" >> docs/development/README.md
case $ENVIRONMENT in
  "development")
    echo "- \`docker-compose up\` - Start all services" >> docs/development/README.md
    echo "- \`docker-compose up -d\` - Start in background" >> docs/development/README.md
    echo "- \`docker-compose down\` - Stop all services" >> docs/development/README.md
    ;;
  "staging")
    echo "- \`docker-compose -f docker-compose.staging.yml up -d\` - Start staging services" >> docs/development/README.md
    echo "- \`docker-compose -f docker-compose.staging.yml down\` - Stop staging services" >> docs/development/README.md
    ;;
  "production")
    echo "- \`docker-compose -f docker-compose.production.yml up -d\` - Start production services" >> docs/development/README.md
    echo "- \`docker-compose -f docker-compose.production.yml down\` - Stop production services" >> docs/development/README.md
    ;;
esac

# Database migration templates
echo -e "${BLUE}📝 Creating database migration templates...${NC}"

# Create migration directory structure
mkdir -p backend/migrations
mkdir -p backend/seeds
mkdir -p backend/scripts

# Initial migration file
cat > backend/migrations/001_initial_schema.sql << EOF
-- Initial database schema for $PROJECT_NAME
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
RETURNS TRIGGER AS \$\$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
\$\$ language 'plpgsql';

-- Add trigger to users table
CREATE TRIGGER update_users_updated_at 
    BEFORE UPDATE ON users 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();
EOF

# Seed data for development
cat > backend/seeds/001_development_data.sql << EOF
-- Development seed data for $PROJECT_NAME
-- This file is only used in development environment

-- Insert sample users
INSERT INTO users (email, password_hash, first_name, last_name) VALUES
('admin@example.com', '\$2b\$10\$example.hash.here', 'Admin', 'User'),
('user@example.com', '\$2b\$10\$example.hash.here', 'Test', 'User')
ON CONFLICT (email) DO NOTHING;
EOF

# Migration runner script
cat > backend/scripts/migrate.sh << 'EOF'
#!/bin/bash

# Database migration script
set -e

ENVIRONMENT=${NODE_ENV:-development}
DB_HOST=${DB_HOST:-localhost}
DB_PORT=${DB_PORT:-5432}
DB_NAME=${DB_NAME:-my_project_dev}
DB_USER=${DB_USER:-postgres}

echo "Running migrations for environment: $ENVIRONMENT"
echo "Database: $DB_NAME on $DB_HOST:$DB_PORT"

# Run migrations
for file in migrations/*.sql; do
    if [ -f "$file" ]; then
        echo "Running migration: $file"
        PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f "$file"
    fi
done

# Run seeds only in development
if [ "$ENVIRONMENT" = "development" ]; then
    echo "Running seed data for development..."
    for file in seeds/*.sql; do
        if [ -f "$file" ]; then
            echo "Running seed: $file"
            PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f "$file"
        fi
    done
fi

echo "Migrations completed successfully!"
EOF

chmod +x backend/scripts/migrate.sh

# Create starter application files
echo -e "${BLUE}📝 Creating starter application files...${NC}"

# Backend starter files
case $BACKEND_FRAMEWORK in
    "node")
        # Main server file
        cat > backend/src/index.js << EOF
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
  console.log(\`🚀 Server running on port \${PORT}\`);
  console.log(\`🌍 Environment: \${process.env.NODE_ENV || 'development'}\`);
  console.log(\`📊 Health check: http://localhost:\${PORT}/health\`);
});

module.exports = app;
EOF

        # Routes index
        cat > backend/src/routes/index.js << EOF
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
    message: 'Welcome to $PROJECT_NAME API',
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
        cat > backend/src/routes/auth.js << EOF
const express = require('express');
const router = express.Router();

// Login endpoint
router.post('/login', (req, res) => {
  const { email, password } = req.body;
  
  // TODO: Implement actual authentication
  if (email === 'admin@example.com' && password === 'password') {
    res.json({
      success: true,
      message: 'Login successful',
      user: { email, role: 'admin' }
    });
  } else {
    res.status(401).json({
      success: false,
      message: 'Invalid credentials'
    });
  }
});

// Register endpoint
router.post('/register', (req, res) => {
  const { email, password, firstName, lastName } = req.body;
  
  // TODO: Implement actual user registration
  res.json({
    success: true,
    message: 'User registered successfully',
    user: { email, firstName, lastName }
  });
});

// Logout endpoint
router.post('/logout', (req, res) => {
  res.json({
    success: true,
    message: 'Logout successful'
  });
});

module.exports = router;
EOF

        # User routes
        cat > backend/src/routes/users.js << EOF
const express = require('express');
const router = express.Router();

// Get all users
router.get('/', (req, res) => {
  // TODO: Implement actual user fetching from database
  const users = [
    { id: 1, email: 'admin@example.com', firstName: 'Admin', lastName: 'User' },
    { id: 2, email: 'user@example.com', firstName: 'Test', lastName: 'User' }
  ];
  
  res.json({
    success: true,
    users
  });
});

// Get user by ID
router.get('/:id', (req, res) => {
  const { id } = req.params;
  
  // TODO: Implement actual user fetching from database
  const user = { id, email: 'user@example.com', firstName: 'Test', lastName: 'User' };
  
  res.json({
    success: true,
    user
  });
});

// Update user
router.put('/:id', (req, res) => {
  const { id } = req.params;
  const { firstName, lastName, email } = req.body;
  
  // TODO: Implement actual user updating
  res.json({
    success: true,
    message: 'User updated successfully',
    user: { id, firstName, lastName, email }
  });
});

module.exports = router;
EOF

        # Database connection
        cat > backend/src/config/database.js << EOF
const { Pool } = require('pg');

const pool = new Pool({
  host: process.env.DB_HOST || 'localhost',
  port: process.env.DB_PORT || 5432,
  database: process.env.DB_NAME || '${PROJECT_NAME//-/_}_dev',
  user: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASSWORD || 'postgres',
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

        # Update backend package.json with additional dependencies
        cat > backend/package.json << EOF
{
  "name": "backend",
  "version": "1.0.0",
  "description": "$PROJECT_NAME Backend API",
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

# Frontend starter files (if frontend exists)
if [ -n "$FRONTEND_FRAMEWORK" ]; then
    case $FRONTEND_FRAMEWORK in
        "react")
            # Main React entry point
            cat > frontend/src/main.jsx << EOF
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
            cat > frontend/src/App.jsx << EOF
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
        <h1>Welcome to $PROJECT_NAME</h1>
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
            <li>Environment: $ENVIRONMENT</li>
          </ul>
        </div>
      </header>
    </div>
  )
}

export default App
EOF

            # CSS files
            cat > frontend/src/App.css << EOF
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

            cat > frontend/src/index.css << EOF
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
            cat > frontend/vite.config.js << EOF
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
            cat > frontend/index.html << EOF
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href="/vite.svg" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>$PROJECT_NAME</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.jsx"></script>
  </body>
</html>
EOF
            ;;
    esac
fi

echo -e "${GREEN}✅ Project structure created successfully!${NC}"
echo ""
echo -e "${BLUE}📋 Next Steps:${NC}"
echo -e "${YELLOW}1.${NC} Navigate to the project directory:"
echo -e "   ${GREEN}cd $PROJECT_NAME${NC}"
echo ""
echo -e "${YELLOW}2.${NC} Install all dependencies:"
echo -e "   ${GREEN}npm run install:all${NC}"
echo ""
echo -e "${YELLOW}3.${NC} Set up environment variables for $ENVIRONMENT:"
echo -e "   ${GREEN}cp backend/.env.${ENVIRONMENT} backend/.env${NC}"
if [ -n "$FRONTEND_FRAMEWORK" ]; then
    echo -e "   ${GREEN}cp frontend/.env.${ENVIRONMENT} frontend/.env${NC}"
fi
echo ""
echo -e "${YELLOW}4.${NC} Set up database:"
echo -e "   ${GREEN}cd backend && ./scripts/migrate.sh${NC}"
echo ""
echo -e "${YELLOW}5.${NC} Start the $ENVIRONMENT environment:"
echo -e "   ${GREEN}./scripts/start-${ENVIRONMENT}.sh local${NC}"
echo -e "   ${GREEN}   or${NC}"
echo -e "   ${GREEN}./scripts/start-${ENVIRONMENT}.sh docker${NC}"
echo ""
echo -e "${YELLOW}6.${NC} Configure CI/CD (optional):"
echo -e "   ${GREEN}📚 Review .github/workflows/ for GitHub Actions${NC}"
echo -e "   ${GREEN}🔐 Set up repository secrets for deployment${NC}"
echo -e "   ${GREEN}📖 Check docs/ci-cd/README.md for setup guide${NC}"
echo ""
echo -e "${YELLOW}7.${NC} (Optional) Generate documentation templates:"
echo -e "   ${GREEN}./create_docs.sh -p $PROJECT_NAME -e $ENVIRONMENT -f $FRONTEND_FRAMEWORK -b $BACKEND_FRAMEWORK -d $DATABASE${NC}"
echo ""
echo -e "${BLUE}🎉 Your $PROJECT_NAME project is ready for $ENVIRONMENT!${NC}"
echo ""
echo -e "${YELLOW}📚 Check the docs/ directory for detailed guides (if you generated documentation).${NC}"
echo -e "${YELLOW}🌍 Environment: $ENVIRONMENT configuration applied.${NC}"
echo -e "${YELLOW}🚀 Quick start: ./scripts/start-${ENVIRONMENT}.sh local${NC}"
echo -e "${YELLOW}🔧 CI/CD: GitHub Actions workflows configured for $ENVIRONMENT${NC}"

exit 0
