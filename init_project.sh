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

# --- Configuration ---
PROJECT_NAME="pod-system-b"
echo "🚀 Starting initialization for project: $PROJECT_NAME"

# --- Safety Check: Ensure we're not running in an existing project ---
if [ -d "$PROJECT_NAME" ]; then
  echo "❌ Error: Directory '$PROJECT_NAME' already exists. Aborting to prevent overwriting."
  exit 1
fi

# --- 1. Create Project Root and Initialize Git ---
echo "Step 1: Creating project root and initializing Git..."
mkdir "$PROJECT_NAME"
cd "$PROJECT_NAME"

git init
git branch -M main
git checkout -b develop
echo "✅ Git repository initialized with 'main' and 'develop' branches. Default is 'develop'."

# --- 2. Create Top-Level Directories ---
echo "Step 2: Creating top-level directories (backend, frontend, docs)..."
mkdir backend
mkdir frontend
docs

echo "✅ Top-level directories created."

# --- 3. Create Detailed Backend Structure ---
echo "Step 3: Building detailed backend directory structure..."
mkdir -p backend/app/models
mkdir -p backend/app/routers
mkdir -p backend/app/schemas
mkdir -p backend/tests

# Create placeholder files for the backend
touch backend/app/__init__.py
touch backend/app/main.py
touch backend/app/config.py
touch backend/app/database.py
touch backend/app/models/__init__.py
touch backend/app/routers/__init__.py
touch backend/app/schemas/__init__.py
touch backend/tests/__init__.py
touch backend/requirements.txt
touch backend/.env.example

echo "✅ Backend structure built."

# --- 4. Create Detailed Frontend Structure ---
echo "Step 4: Building detailed frontend directory structure..."
mkdir -p frontend/src/components/ui
mkdir -p frontend/src/components/feature-specific
mkdir -p frontend/src/pages
mkdir -p frontend/src/context
mkdir -p frontend/src/hooks
mkdir -p frontend/src/utils
mkdir -p frontend/src/test

# Create placeholder files for the frontend
touch frontend/src/App.jsx
touch frontend/src/main.jsx
touch frontend/src/index.css
touch frontend/src/components/ui/Button.jsx
touch frontend/src/pages/HomePage.jsx
touch frontend/src/context/AppContext.jsx

echo "✅ Frontend structure built."

# --- 5. Create Root Configuration Files ---
echo "Step 5: Creating root configuration files (.gitignore, README.md)..."

# Create .gitignore
cat > .gitignore << EOL
# --- General ---
.DS_Store
.vscode/
.idea/
*.log

# --- Python / Backend ---
backend/venv/
backend/__pycache__/
backend/.pytest_cache/
backend/.env

# --- Node.js / Frontend ---
frontend/node_modules/
frontend/dist/
frontend/.env
frontend/.env.*
frontend/coverage/
npm-debug.log*
yarn-debug.log*
yarn-error.log*
EOL

# Create root README.md
cat > README.md << EOL
# POD System B

This is the official monorepo for the Print-on-Demand (POD) System B project.

## 🚀 Project Status

- **Status:** Initial project setup complete. Ready for development.
- **Current Goal:** Begin implementation based on the defined issues.

## Directory Structure

- \`/backend\`: Contains the FastAPI application.
- \`/frontend\`: Contains the React application.
- \`/docs\`: Contains all project documentation.
EOL

echo "✅ Root configuration files created."

# --- 6. Finalization ---
echo ""
echo "🎉 Project '$PROJECT_NAME' has been successfully initialized!"
echo "Your next steps should be:"
echo "  1. Navigate into the new directory: cd $PROJECT_NAME"
echo "  2. Link to your remote GitHub repository and push."
echo "  3. Begin working on the 'Phase 1' issues to populate documentation and boilerplate."
echo ""
echo "Final project structure:"

# Display the final structure using 'tree' if available, otherwise use 'ls'
if command -v tree &> /dev/null
then
  tree -L 4
else
  echo "('tree' command not found. Showing basic listing instead.)"
  ls -R
fi

exit 0
