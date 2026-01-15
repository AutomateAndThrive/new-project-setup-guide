# New Developer Onboarding Guide

Welcome to the development team! This guide will help you get up and running with our project.

## 🎯 Project Overview

**Project Name** is a web application that helps users achieve their goals. The tool provides a modern, scalable foundation for building full-stack applications.

### Key Features

- **AI-Powered Content Generation**: Uses Google Gemini to analyze designs and generate Etsy-optimized content
- **Printify Integration**: Pulls product data and colors from Printify API
- **Color Visualizer**: Preview designs on all available product colors
- **Export Functionality**: Copy optimized content for easy Etsy listing creation

### Success Metrics

- **Primary**: Reduce time from design to listing from 1-2 hours to under 15 minutes
- **Secondary**: 95%+ user adoption rate with successful content export

## 🛠️ Tech Stack

### Frontend

- **React 18** with TypeScript
- **Vite** for build tooling
- **Tailwind CSS** for styling
- **React Router** for navigation
- **React Query** for data fetching
- **Zustand** for state management
- **React Dropzone** for file uploads
- **Sharp** for image processing

### Backend

- **Node.js** with Express.js
- **PostgreSQL** for primary database
- **Redis** for caching
- **Sequelize** as ORM
- **Multer** for file uploads
- **Sharp** for image processing
- **Google Gemini API** for AI content generation
- **Printify API** for product data

### DevOps

- **Docker** and Docker Compose
- **GitHub Actions** for CI/CD
- **Jest** and **Vitest** for testing

## 🚀 Quick Start

### Prerequisites

- Node.js 18+
- Docker and Docker Compose
- Git
- Google Gemini API key
- Printify API key

### 1. Clone and Setup

```bash
# Clone the repository
git clone <repository-url>
cd pixel-to-profit

# Install all dependencies
npm run install:all
```

### 2. Environment Configuration

```bash
# Copy environment files
cp backend/.env.example backend/.env
cp frontend/.env.example frontend/.env

# Edit the .env files with your API keys
# You'll need:
# - Google Gemini API key
# - Printify API key
# - Database credentials
```

### 3. Start Development Environment

```bash
# Start database and cache services
docker-compose up postgres redis -d

# Run database setup
npm run setup:db

# Start development servers
npm run dev
```

### 4. Verify Setup

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:3001
- **Database**: localhost:5432
- **Redis**: localhost:6379

## 📁 Project Structure

```
pixel-to-profit/
├── frontend/                 # React application
│   ├── src/
│   │   ├── components/       # Reusable UI components
│   │   ├── pages/           # Page components
│   │   ├── services/        # API and external service integrations
│   │   ├── hooks/           # Custom React hooks
│   │   ├── types/           # TypeScript type definitions
│   │   └── utils/           # Utility functions
│   └── public/              # Static assets
├── backend/                  # Node.js API server
│   ├── src/
│   │   ├── controllers/     # Request handlers
│   │   ├── models/          # Database models
│   │   ├── routes/          # API route definitions
│   │   ├── services/        # Business logic and external APIs
│   │   ├── middleware/      # Express middleware
│   │   └── utils/           # Utility functions
│   ├── migrations/          # Database migrations
│   └── seeds/               # Database seed data
├── docs/                    # Project documentation
├── scripts/                 # Utility scripts
└── tests/                   # Test files
```

## 🔧 Development Workflow

### Branching Strategy

- **main**: Production-ready code
- **develop**: Integration branch for features
- **feature/\***: Individual feature development
- **hotfix/\***: Critical bug fixes

### Development Process

1. **Create feature branch** from `develop`
2. **Develop and test** your feature
3. **Write tests** for new functionality
4. **Update documentation** as needed
5. **Create pull request** to `develop`
6. **Code review** and approval
7. **Merge** and deploy

### Code Quality Standards

- **TypeScript**: Strict mode enabled
- **ESLint**: Airbnb configuration
- **Prettier**: Consistent code formatting
- **Testing**: Minimum 80% coverage
- **Commits**: Conventional commit messages

## 🗺️ Where Does My Code Go?

Understanding the flow of your code helps you make better architectural decisions and debug issues more effectively.

### Frontend Code Flow

```
User Interaction → React Component → Custom Hook → Service Layer → API Call
     ↓
State Update ← Response Processing ← Backend API ← Database/External APIs
```

#### 1. **React Components** (`frontend/src/components/`)

- **Purpose**: UI presentation and user interaction
- **Responsibility**: Handle user events, display data, manage local state
- **Example**: `DesignUploader.tsx` handles file uploads and displays progress

#### 2. **Custom Hooks** (`frontend/src/hooks/`)

- **Purpose**: Reusable logic and state management
- **Responsibility**: Data fetching, state synchronization, side effects
- **Example**: `useDesignAnalysis.ts` manages AI analysis state and API calls

#### 3. **Service Layer** (`frontend/src/services/`)

- **Purpose**: API communication and external integrations
- **Responsibility**: HTTP requests, data transformation, error handling
- **Example**: `geminiService.ts` handles all Google Gemini API interactions

#### 4. **State Management** (`frontend/src/store/`)

- **Purpose**: Global application state
- **Responsibility**: Shared data, user preferences, application state
- **Example**: `designStore.ts` manages current design and analysis results

### Backend Code Flow

```
HTTP Request → Express Router → Controller → Service → Model → Database
     ↓
HTTP Response ← Data Processing ← Business Logic ← Data Access ← Query Results
```

#### 1. **Express Routes** (`backend/src/routes/`)

- **Purpose**: Define API endpoints and request handling
- **Responsibility**: URL mapping, middleware application, request validation
- **Example**: `designRoutes.ts` defines `/api/designs` endpoints

#### 2. **Controllers** (`backend/src/controllers/`)

- **Purpose**: Handle HTTP requests and responses
- **Responsibility**: Request parsing, response formatting, error handling
- **Example**: `designController.ts` processes design upload and analysis requests

#### 3. **Services** (`backend/src/services/`)

- **Purpose**: Business logic and external API integration
- **Responsibility**: Data processing, external API calls, complex operations
- **Example**: `geminiService.ts` handles AI analysis and content generation

#### 4. **Models** (`backend/src/models/`)

- **Purpose**: Database schema and data access
- **Responsibility**: Data validation, database queries, relationships
- **Example**: `Design.ts` defines the design data structure and database operations

### Data Flow Examples

#### Design Upload Flow

```
1. User uploads design → React Component (DesignUploader)
2. File validation → Custom Hook (useFileValidation)
3. Upload to server → Service (uploadService)
4. Backend receives → Controller (designController.upload)
5. Process image → Service (imageProcessingService)
6. Store in database → Model (Design.create)
7. Return response → Controller → Service → Component
8. Update UI → State management → Component re-render
```

#### AI Analysis Flow

```
1. User requests analysis → Component (AnalysisButton)
2. Trigger analysis → Hook (useDesignAnalysis)
3. Call backend API → Service (geminiService.analyze)
4. Backend processes → Controller (designController.analyze)
5. Call Gemini API → Service (geminiService.callAPI)
6. Process response → Service (contentGenerationService)
7. Store results → Model (Analysis.create)
8. Return to frontend → Service → Hook → Component
9. Display results → Component (AnalysisResults)
```

### File Organization Guidelines

#### Where to Put New Code

| Type of Code          | Location                   | Example                                    |
| --------------------- | -------------------------- | ------------------------------------------ |
| **UI Components**     | `frontend/src/components/` | `Button.tsx`, `Modal.tsx`                  |
| **Page Components**   | `frontend/src/pages/`      | `HomePage.tsx`, `DesignPage.tsx`           |
| **Custom Hooks**      | `frontend/src/hooks/`      | `useApi.ts`, `useLocalStorage.ts`          |
| **API Services**      | `frontend/src/services/`   | `userService.ts`, `designService.ts`       |
| **Type Definitions**  | `frontend/src/types/`      | `user.types.ts`, `api.types.ts`            |
| **Utility Functions** | `frontend/src/utils/`      | `validation.ts`, `formatting.ts`           |
| **API Routes**        | `backend/src/routes/`      | `userRoutes.ts`, `designRoutes.ts`         |
| **Controllers**       | `backend/src/controllers/` | `userController.ts`, `designController.ts` |
| **Business Logic**    | `backend/src/services/`    | `userService.ts`, `analysisService.ts`     |
| **Database Models**   | `backend/src/models/`      | `User.ts`, `Design.ts`                     |
| **Middleware**        | `backend/src/middleware/`  | `auth.ts`, `validation.ts`                 |

#### Naming Conventions

- **Components**: PascalCase (`DesignUploader.tsx`)
- **Hooks**: camelCase with `use` prefix (`useDesignAnalysis.ts`)
- **Services**: camelCase with `Service` suffix (`geminiService.ts`)
- **Controllers**: camelCase with `Controller` suffix (`designController.ts`)
- **Models**: PascalCase (`Design.ts`, `User.ts`)
- **Types**: camelCase with `.types.ts` suffix (`design.types.ts`)

### Integration Points

#### Frontend ↔ Backend

- **API Endpoints**: Defined in `backend/src/routes/`
- **Data Types**: Shared in `frontend/src/types/` and `backend/src/types/`
- **Error Handling**: Consistent error responses and frontend error handling

#### External APIs

- **Google Gemini**: Handled in `backend/src/services/geminiService.ts`
- **Printify**: Handled in `backend/src/services/printifyService.ts`
- **File Storage**: Handled in `backend/src/services/storageService.ts`

#### Database

- **Models**: Defined in `backend/src/models/`
- **Migrations**: Stored in `backend/migrations/`
- **Seeds**: Stored in `backend/seeds/`

### Debugging the Flow

#### Frontend Debugging

```bash
# Check component state
console.log('Component state:', state);

# Check API calls
console.log('API response:', response);

# Check service layer
console.log('Service data:', data);
```

#### Backend Debugging

```bash
# Check request data
console.log('Request body:', req.body);

# Check service processing
console.log('Service result:', result);

# Check database queries
console.log('Database result:', dbResult);
```

#### Common Debugging Points

1. **Component State**: Check if data is properly passed down
2. **API Calls**: Verify request/response format
3. **Service Layer**: Ensure business logic is correct
4. **Database**: Confirm data is stored/retrieved properly
5. **External APIs**: Check API responses and error handling

### Performance Considerations

#### Frontend Performance

- **Component Optimization**: Use React.memo for expensive components
- **State Management**: Minimize unnecessary re-renders
- **API Caching**: Cache frequently accessed data
- **Bundle Size**: Lazy load components and routes

#### Backend Performance

- **Database Queries**: Optimize with indexes and efficient queries
- **API Caching**: Cache external API responses
- **Image Processing**: Use background jobs for heavy processing
- **Response Time**: Target < 2 seconds for API responses

### Security Flow

#### Authentication Flow

```
1. User login → Frontend service → Backend controller
2. Validate credentials → Authentication service
3. Generate JWT token → Return to frontend
4. Store token → Frontend state management
5. Include in requests → Service layer → Backend middleware
6. Validate token → Authentication middleware
7. Allow/deny access → Controller processing
```

#### Data Validation Flow

```
1. User input → Frontend validation → Service layer
2. API request → Backend validation middleware
3. Controller processing → Service layer validation
4. Database operations → Model validation
5. Response → Frontend validation → UI display
```

Understanding this flow helps you:

- **Debug issues** more effectively
- **Make architectural decisions** with confidence
- **Write better tests** that cover the entire flow
- **Optimize performance** at the right points
- **Implement security** measures properly

## 🧪 Testing

### Running Tests

```bash
# Run all tests
npm run test

# Run frontend tests only
npm run test:frontend

# Run backend tests only
npm run test:backend

# Run tests in watch mode
npm run test:watch
```

### Test Structure

- **Unit Tests**: Individual functions and components
- **Integration Tests**: API endpoints and database operations
- **E2E Tests**: Complete user workflows
- **Performance Tests**: Image processing and API response times

## 🔌 API Integrations

### Google Gemini API

- **Purpose**: AI-powered design analysis and content generation
- **Key Features**: Multimodal analysis, text generation
- **Rate Limits**: Monitor usage and implement caching
- **Error Handling**: Graceful degradation for API failures

### Printify API

- **Purpose**: Product catalog and color data
- **Key Features**: Product information, color variations
- **Caching Strategy**: Daily refresh with fallback to cached data
- **Downtime Handling**: Continue operation with last known data

## 📊 Monitoring and Debugging

### Logging

- **Backend**: Winston logger with different levels
- **Frontend**: Console logging with error tracking
- **API Calls**: Request/response logging for debugging

### Performance Monitoring

- **API Response Times**: Target < 2 seconds for content generation
- **Image Processing**: Target < 5 seconds per design
- **Database Queries**: Monitor slow queries and optimize

### Error Tracking

- **Backend Errors**: Logged to file and monitoring service
- **Frontend Errors**: Sent to error tracking service
- **API Failures**: Graceful degradation with user feedback

## 🚀 Deployment

### Development Deployment

```bash
# Build and start with Docker
docker-compose up --build

# Or run locally
npm run dev
```

### Production Deployment

```bash
# Build for production
npm run build

# Deploy with Docker Compose
docker-compose -f docker-compose.prod.yml up -d
```

## 📚 Key Documentation

- **[API Documentation](./docs/api/)**: Complete API reference
- **[Development Guide](./docs/development/)**: Detailed development instructions
- **[Deployment Guide](./docs/deployment/)**: Production deployment steps
- **[User Guide](./docs/user-guide/)**: End-user documentation

## 🎯 First Tasks for New Developers

### Week 1: Environment Setup

1. **Complete setup** following this guide
2. **Explore the codebase** and understand the architecture
3. **Run all tests** and ensure they pass
4. **Make a small change** and test the development workflow

### Week 2: Feature Development

1. **Pick a simple task** from the task list
2. **Implement the feature** following coding standards
3. **Write tests** for your implementation
4. **Create a pull request** and get code review

### Week 3: Integration

1. **Work on API integration** tasks
2. **Test with real data** from Gemini and Printify
3. **Optimize performance** where needed
4. **Document your work** for future reference

## 🤝 Team Communication

### Communication Channels

- **GitHub Issues**: Task tracking and bug reports
- **Pull Requests**: Code review and discussion
- **Team Chat**: Real-time communication
- **Documentation**: Knowledge sharing and updates

### Code Review Guidelines

- **Be constructive** and specific in feedback
- **Focus on code quality** and maintainability
- **Test thoroughly** before requesting review
- **Respond promptly** to review comments

## 🆘 Getting Help

### When You're Stuck

1. **Check documentation** first
2. **Search existing issues** for similar problems
3. **Ask in team chat** with specific details
4. **Create an issue** if it's a bug or feature request

### Useful Resources

- **React Documentation**: https://react.dev/
- **Express.js Guide**: https://expressjs.com/
- **Google Gemini API**: https://ai.google.dev/
- **Printify API**: https://printify.com/app/docs
- **Tailwind CSS**: https://tailwindcss.com/

## 🎉 Welcome to the Team!

We're excited to have you on board! This project provides a solid foundation for building modern web applications. Your contributions will help create robust, scalable software solutions.

**Remember**: Don't hesitate to ask questions, share ideas, and contribute to making this tool the best it can be!

---

_Last updated: January 2025_
_Version: 1.0.0_
