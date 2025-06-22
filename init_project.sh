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
    echo "  --interactive, -i   Interactive mode for guided setup"
    echo "  --help, -h          Show this help message"
    echo ""
    echo "Templates:"
    echo "  saas                SaaS application with auth, billing, user management"
    echo "  ecommerce           E-commerce platform with products, cart, payments"
    echo "  api                 API service with documentation and testing"
    echo "  dashboard           Admin dashboard with analytics and user management"
    echo "  mobile              Mobile app backend with push notifications"
    echo ""
    echo "Examples:"
    echo "  $0                                    # Use defaults"
    echo "  $0 --name my-app --frontend vue      # Custom project"
    echo "  $0 --template saas                   # SaaS template"
    echo "  $0 --interactive                     # Guided setup"
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
    "db:setup": "node scripts/setup-database.js"
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
  }
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

# Environment configuration
cat > backend/.env.example << EOF
# Server Configuration
PORT=3001
NODE_ENV=development

# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=${PROJECT_NAME//-/_}
DB_USER=postgres
DB_PASSWORD=your_password

# API Configuration
API_BASE_URL=http://localhost:3001/api
CORS_ORIGIN=http://localhost:3000
EOF

# Frontend environment only if frontend exists
if [ -n "$FRONTEND_FRAMEWORK" ]; then
    cat > frontend/.env.example << EOF
VITE_API_BASE_URL=http://localhost:3001/api
VITE_APP_NAME=$PROJECT_NAME
VITE_APP_VERSION=1.0.0
EOF
fi

# Docker configuration - adjust based on project type
if [ -n "$FRONTEND_FRAMEWORK" ]; then
    cat > docker-compose.yml << EOF
version: '3.8'

services:
  frontend:
    build: ./frontend
    ports:
      - "3000:3000"
    environment:
      - VITE_API_BASE_URL=http://localhost:3001/api
    depends_on:
      - backend
    volumes:
      - ./frontend:/app
      - /app/node_modules

  backend:
    build: ./backend
    ports:
      - "3001:3001"
    environment:
      - NODE_ENV=development
      - DB_HOST=database
    depends_on:
      - database
    volumes:
      - ./backend:/app
      - /app/node_modules

  database:
    image: postgres:15
    environment:
      POSTGRES_DB: ${PROJECT_NAME//-/_}
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
EOF
else
    cat > docker-compose.yml << EOF
version: '3.8'

services:
  backend:
    build: ./backend
    ports:
      - "3001:3001"
    environment:
      - NODE_ENV=development
      - DB_HOST=database
    depends_on:
      - database
    volumes:
      - ./backend:/app
      - /app/node_modules

  database:
    image: postgres:15
    environment:
      POSTGRES_DB: ${PROJECT_NAME//-/_}
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
EOF
fi

# Create README - adjust based on project type
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
   cp backend/.env.example backend/.env
   cp frontend/.env.example frontend/.env
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
   cp backend/.env.example backend/.env
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
   \`\`\`bash
   git clone <repository-url>
   cd $PROJECT_NAME
   npm run install:all
   \`\`\`

2. **Environment configuration:**
   - Copy .env.example files and configure your settings
   - Ensure database connection details are correct

3. **Start development:**
   \`\`\`bash
   npm run dev
   \`\`\`

## Development Workflow

$(if [ -n "$FRONTEND_FRAMEWORK" ]; then
    echo "1. **Frontend**: http://localhost:3000"
fi)
1. **Backend API**: http://localhost:3001
2. **Database**: localhost:5432

## Key Development Commands

- \`npm run dev\` - Start $(if [ -n "$FRONTEND_FRAMEWORK" ]; then echo "both frontend and backend"; else echo "backend server"; fi)
- \`npm run test\` - Run all tests
- \`npm run lint\` - Run linting
$(if [ -n "$FRONTEND_FRAMEWORK" ]; then echo "- \`npm run build\` - Build for production"; fi)
EOF

echo -e "${GREEN}✅ Project structure created successfully!${NC}"
echo ""
echo -e "${BLUE}📋 Next Steps:${NC}"
echo -e "${YELLOW}1.${NC} Navigate to the project directory:"
echo -e "   ${GREEN}cd $PROJECT_NAME${NC}"
echo ""
echo -e "${YELLOW}2.${NC} Install all dependencies:"
echo -e "   ${GREEN}npm run install:all${NC}"
echo ""
echo -e "${YELLOW}3.${NC} Set up environment variables:"
echo -e "   ${GREEN}cp backend/.env.example backend/.env${NC}"
$(if [ -n "$FRONTEND_FRAMEWORK" ]; then
    echo "echo -e \"   ${GREEN}cp frontend/.env.example frontend/.env${NC}\""
fi)
echo ""
echo -e "${YELLOW}4.${NC} Start the development $(if [ -n "$FRONTEND_FRAMEWORK" ]; then echo "servers"; else echo "server"; fi):"
echo -e "   ${GREEN}npm run dev${NC}"
echo ""
echo -e "${BLUE}🎉 Your $PROJECT_NAME project is ready for development!${NC}"
echo ""
echo -e "${YELLOW}📚 Check the docs/ directory for detailed guides.${NC}"

exit 0
