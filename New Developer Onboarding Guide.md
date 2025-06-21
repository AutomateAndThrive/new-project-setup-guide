# **New Developer Onboarding Guide**

Welcome to the POD System B project\! This guide will walk you through setting up your local development environment so you can start contributing.

### **Prerequisites**

Before you begin, please ensure you have the following software installed on your system:

* **Git:** For version control.  
* **Node.js:** Version 18.0 or higher.  
* **Python:** Version 3.12 or higher.

### **Step 1: Clone the Repository**

First, clone the project repository from GitHub to your local machine.

\# Clone the repository  
git clone \<your-github-repo-url\>

\# Navigate into the project directory  
cd pod-system-b

**Note:** The default branch is develop, which is exactly where you want to be to start your work.

### **Step 2: Set Up the Backend**

The backend is a Python application powered by FastAPI.

\# Navigate to the backend directory  
cd backend

\# Create a Python virtual environment  
python3.12 \-m venv venv

\# Activate the virtual environment  
\# On macOS/Linux:  
source venv/bin/activate  
\# On Windows:  
\# venv\\Scripts\\activate

\# Install the required dependencies  
pip install \-r requirements.txt

\# Configure your environment variables  
\# Copy the example file to create your own local .env file  
cp .env.example .env

\# Now, open the .env file and add your database connection string  
\# and any other required secrets.

### **Step 3: Set Up the Frontend**

The frontend is a modern React application built with Vite.

\# From the project root, navigate to the frontend directory  
cd frontend

\# Install the required npm packages  
npm install

### **Step 4: Run the Application**

To run the full application, you will need to have two separate terminal windows open simultaneously: one for the backend server and one for the frontend development server.

**In your first terminal (for the backend):**

\# Make sure you are in the backend directory with the venv activated  
cd backend  
source venv/bin/activate \# If not already active

\# Start the FastAPI server  
uvicorn app.main:app \--reload \--host 127.0.0.1 \--port 8000

You can verify the backend is running by visiting http://127.0.0.1:8000/docs in your browser.

**In your second terminal (for the frontend):**

\# Make sure you are in the frontend directory  
cd frontend

\# Start the Vite development server  
npm run dev

The frontend application will now be available at http://localhost:3000.

### **Step 5: Your First Contribution**

You are now fully set up to develop\! Your next steps should be:

1. **Read the Project Branching Strategy** document to understand our workflow.  
2. Go to the project's **Issues** tab on GitHub.  
3. Pick an unassigned issue to work on.  
4. Create a new feature branch from develop and start coding\!