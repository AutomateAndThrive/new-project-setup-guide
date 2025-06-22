#!/bin/bash
# ==============================================================================
# Comprehensive Project Initialization Script
#
# Description:
#   This script automates the complete setup of the POD System B monorepo.
#   It creates the entire directory structure, initializes Git with the correct
#   branching strategy, and creates placeholder configuration and source files.
#
# Usage:
#   1. Save this file as `init_project.sh`.
#   2. Give it execute permissions: `chmod +x init_project.sh`
#   3. Run the script: `./init_project.sh`
# ==============================================================================

# Pixel to Profit - Project Initialization Script
# This script sets up the development environment for the Pixel to Profit MVP
# A web application that automates print-on-demand listing creation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Project configuration
PROJECT_NAME="pixel-to-profit"
PROJECT_DESCRIPTION="AI-powered print-on-demand listing automation tool"
FRONTEND_FRAMEWORK="react"
BACKEND_FRAMEWORK="node"
DATABASE="postgresql"
AI_PROVIDER="google-gemini"
API_INTEGRATION="printify"

echo -e "${BLUE}🚀 Initializing Pixel to Profit Project${NC}"
echo -e "${BLUE}=====================================${NC}"
echo -e "${YELLOW}Project:${NC} $PROJECT_NAME"
echo -e "${YELLOW}Description:${NC} $PROJECT_DESCRIPTION"
echo -e "${YELLOW}Frontend:${NC} $FRONTEND_FRAMEWORK"
echo -e "${YELLOW}Backend:${NC} $BACKEND_FRAMEWORK"
echo -e "${YELLOW}Database:${NC} $DATABASE"
echo -e "${YELLOW}AI Provider:${NC} $AI_PROVIDER"
echo -e "${YELLOW}API Integration:${NC} $API_INTEGRATION"
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
mkdir -p {frontend,backend,docs,scripts,tests,assets}

# Frontend structure (React)
mkdir -p frontend/{src/{components,pages,hooks,utils,services,types,assets},public}
mkdir -p frontend/src/components/{ui,layout,forms,upload,preview,dashboard}
mkdir -p frontend/src/pages/{home,upload,editor,preview,export}
mkdir -p frontend/src/services/{api,gemini,printify,image-processing}
mkdir -p frontend/src/types/{api,gemini,printify,ui}

# Backend structure (Node.js/Express)
mkdir -p backend/{src/{controllers,middleware,models,routes,services,utils,config},tests}
mkdir -p backend/src/services/{gemini,printify,image-processing,cache}
mkdir -p backend/src/models/{product,design,user}
mkdir -p backend/src/controllers/{design,content,product,export}

# Database structure
mkdir -p backend/{migrations,seeds}

# Documentation structure
mkdir -p docs/{api,deployment,development,user-guide}

# Create essential files
echo -e "${BLUE}📝 Creating configuration files...${NC}"

# Root level files
cat > package.json << 'EOF'
{
  "name": "pixel-to-profit",
  "version": "1.0.0",
  "description": "AI-powered print-on-demand listing automation tool",
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
  "keywords": ["print-on-demand", "etsy", "printify", "ai", "automation"],
  "author": "Your Team",
  "license": "MIT",
  "devDependencies": {
    "concurrently": "^8.2.2"
  }
}
EOF

# Frontend package.json
cat > frontend/package.json << 'EOF'
{
  "name": "pixel-to-profit-frontend",
  "version": "1.0.0",
  "private": true,
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.20.1",
    "react-dropzone": "^14.2.3",
    "axios": "^1.6.2",
    "react-query": "^3.39.3",
    "zustand": "^4.4.7",
    "tailwindcss": "^3.3.6",
    "@headlessui/react": "^1.7.17",
    "@heroicons/react": "^2.0.18",
    "react-hot-toast": "^2.4.1",
    "framer-motion": "^10.16.16",
    "react-color": "^2.19.3",
    "html2canvas": "^1.4.1"
  },
  "devDependencies": {
    "@types/react": "^18.2.45",
    "@types/react-dom": "^18.2.18",
    "@typescript-eslint/eslint-plugin": "^6.14.0",
    "@typescript-eslint/parser": "^6.14.0",
    "eslint": "^8.55.0",
    "eslint-plugin-react": "^7.33.2",
    "eslint-plugin-react-hooks": "^4.6.0",
    "typescript": "^5.3.3",
    "vite": "^5.0.8",
    "@vitejs/plugin-react": "^4.2.1"
  },
  "scripts": {
    "start": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "test": "vitest",
    "lint": "eslint src --ext .ts,.tsx",
    "lint:fix": "eslint src --ext .ts,.tsx --fix"
  }
}
EOF

# Backend package.json
cat > backend/package.json << 'EOF'
{
  "name": "pixel-to-profit-backend",
  "version": "1.0.0",
  "description": "Backend API for Pixel to Profit",
  "main": "src/index.js",
  "scripts": {
    "start": "node src/index.js",
    "dev": "nodemon src/index.js",
    "test": "jest",
    "lint": "eslint src",
    "lint:fix": "eslint src --fix",
    "db:setup": "node scripts/setup-database.js",
    "db:migrate": "node scripts/migrate.js",
    "db:seed": "node scripts/seed.js"
  },
  "dependencies": {
    "express": "^4.18.2",
    "cors": "^2.8.5",
    "helmet": "^7.1.0",
    "dotenv": "^16.3.1",
    "multer": "^1.4.5-lts.1",
    "sharp": "^0.33.1",
    "axios": "^1.6.2",
    "pg": "^8.11.3",
    "sequelize": "^6.35.2",
    "redis": "^4.6.11",
    "jsonwebtoken": "^9.0.2",
    "bcryptjs": "^2.4.3",
    "joi": "^17.11.0",
    "compression": "^1.7.4",
    "rate-limiter-flexible": "^3.0.8",
    "@google/generative-ai": "^0.2.1"
  },
  "devDependencies": {
    "nodemon": "^3.0.2",
    "jest": "^29.7.0",
    "supertest": "^6.3.3",
    "eslint": "^8.55.0",
    "eslint-config-airbnb-base": "^15.0.0",
    "eslint-plugin-import": "^2.29.0"
  }
}
EOF

# Environment configuration
cat > backend/.env.example << 'EOF'
# Server Configuration
PORT=3001
NODE_ENV=development

# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=pixel_to_profit
DB_USER=postgres
DB_PASSWORD=your_password

# Redis Configuration
REDIS_URL=redis://localhost:6379

# Google Gemini API
GEMINI_API_KEY=your_gemini_api_key

# Printify API
PRINTIFY_API_KEY=your_printify_api_key
PRINTIFY_SHOP_ID=your_shop_id

# JWT Configuration
JWT_SECRET=your_jwt_secret_key
JWT_EXPIRES_IN=24h

# File Upload Configuration
MAX_FILE_SIZE=10485760
UPLOAD_PATH=./uploads

# Rate Limiting
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100

# CORS Configuration
CORS_ORIGIN=http://localhost:3000
EOF

# Frontend environment
cat > frontend/.env.example << 'EOF'
VITE_API_BASE_URL=http://localhost:3001/api
VITE_APP_NAME=Pixel to Profit
VITE_APP_VERSION=1.0.0
EOF

# Docker configuration
cat > docker-compose.yml << 'EOF'
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
      - DB_HOST=postgres
      - REDIS_URL=redis://redis:6379
    depends_on:
      - postgres
      - redis
    volumes:
      - ./backend:/app
      - /app/node_modules
      - ./uploads:/app/uploads

  postgres:
    image: postgres:15
    environment:
      POSTGRES_DB: pixel_to_profit
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
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

# Frontend Dockerfile
cat > frontend/Dockerfile << 'EOF'
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm", "start"]
EOF

# Backend Dockerfile
cat > backend/Dockerfile << 'EOF'
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3001

CMD ["npm", "run", "dev"]
EOF

# Create README
cat > README.md << 'EOF'
# Pixel to Profit

AI-powered print-on-demand listing automation tool that helps creators generate optimized Etsy listings from their designs.

## 🚀 Quick Start

1. **Install dependencies:**
   ```bash
   npm run install:all
   ```

2. **Set up environment variables:**
   ```bash
   cp backend/.env.example backend/.env
   cp frontend/.env.example frontend/.env
   # Edit the .env files with your API keys
   ```

3. **Set up database:**
   ```bash
   npm run setup:db
   ```

4. **Start development servers:**
   ```bash
   npm run dev
   ```

## 🏗️ Project Structure

```
pixel-to-profit/
├── frontend/          # React application
├── backend/           # Node.js API server
├── docs/             # Documentation
├── scripts/          # Utility scripts
└── tests/            # Test files
```

## 🔧 Key Features

- **AI-Powered Content Generation**: Uses Google Gemini to analyze designs and generate optimized titles, tags, and descriptions
- **Printify Integration**: Pulls product data and colors from Printify API
- **Color Visualizer**: Preview designs on all available product colors
- **Export Functionality**: Copy optimized content for easy Etsy listing creation

## 📚 Documentation

- [API Documentation](./docs/api/)
- [Development Guide](./docs/development/)
- [Deployment Guide](./docs/deployment/)
- [User Guide](./docs/user-guide/)

## 🛠️ Tech Stack

- **Frontend**: React, TypeScript, Tailwind CSS, Vite
- **Backend**: Node.js, Express, PostgreSQL, Redis
- **AI**: Google Gemini API
- **APIs**: Printify API
- **Image Processing**: Sharp
- **Testing**: Jest, Vitest

## 📝 License

MIT
EOF

# Create development guide
cat > docs/development/README.md << 'EOF'
# Development Guide

## Prerequisites

- Node.js 18+
- PostgreSQL 15+
- Redis 7+
- Google Gemini API key
- Printify API key

## Setup Instructions

1. **Clone and install:**
   ```bash
   git clone <repository-url>
   cd pixel-to-profit
   npm run install:all
   ```

2. **Database setup:**
   ```bash
   # Start PostgreSQL and Redis
   docker-compose up postgres redis -d
   
   # Run database setup
   npm run setup:db
   ```

3. **Environment configuration:**
   - Copy `.env.example` files and configure your API keys
   - Ensure database connection details are correct

4. **Start development:**
   ```bash
   npm run dev
   ```

## Development Workflow

1. **Frontend**: http://localhost:3000
2. **Backend API**: http://localhost:3001
3. **Database**: localhost:5432
4. **Redis**: localhost:6379

## Key Development Commands

- `npm run dev` - Start both frontend and backend
- `npm run test` - Run all tests
- `npm run lint` - Run linting
- `npm run build` - Build for production
EOF

# Create API documentation template
cat > docs/api/README.md << 'EOF'
# API Documentation

## Base URL
`http://localhost:3001/api`

## Authentication
Most endpoints require a valid API key in the header:
```
Authorization: Bearer <your-api-key>
```

## Endpoints

### Design Upload
- `POST /designs/upload` - Upload design files
- `GET /designs/:id` - Get design details
- `DELETE /designs/:id` - Delete design

### Content Generation
- `POST /content/generate` - Generate listing content
- `PUT /content/:id` - Update generated content

### Product Data
- `GET /products` - Get available products
- `GET /products/:id/colors` - Get product colors

### Export
- `POST /export/listing` - Export listing content

## Error Responses
All errors follow this format:
```json
{
  "error": "Error message",
  "code": "ERROR_CODE",
  "timestamp": "2025-01-01T00:00:00Z"
}
```
EOF

# Create deployment guide
cat > docs/deployment/README.md << 'EOF'
# Deployment Guide

## Production Deployment

### Prerequisites
- Docker and Docker Compose
- PostgreSQL database
- Redis instance
- Google Gemini API key
- Printify API key

### Environment Variables
Set the following environment variables in production:
- `NODE_ENV=production`
- `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD`
- `REDIS_URL`
- `GEMINI_API_KEY`
- `PRINTIFY_API_KEY`
- `JWT_SECRET`

### Deployment Steps
1. Build and deploy using Docker Compose
2. Set up reverse proxy (nginx)
3. Configure SSL certificates
4. Set up monitoring and logging

## Docker Deployment
```bash
docker-compose -f docker-compose.prod.yml up -d
```
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
echo -e "   ${GREEN}cp frontend/.env.example frontend/.env${NC}"
echo ""
echo -e "${YELLOW}4.${NC} Configure your API keys in the .env files:"
echo -e "   - Google Gemini API key"
echo -e "   - Printify API key"
echo ""
echo -e "${YELLOW}5.${NC} Start the development servers:"
echo -e "   ${GREEN}npm run dev${NC}"
echo ""
echo -e "${BLUE}🎉 Your Pixel to Profit project is ready for development!${NC}"
echo ""
echo -e "${YELLOW}📚 Check the docs/ directory for detailed guides.${NC}"

exit 0
