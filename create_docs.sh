#!/bin/bash

# Documentation Generator Script
# This script creates comprehensive documentation for a project

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to show help
show_help() {
    echo -e "${BLUE}Documentation Generator${NC}"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -p, --project-name NAME    Project name (required)"
    echo "  -e, --environment ENV      Environment (development|staging|production)"
    echo "  -f, --frontend FRAMEWORK   Frontend framework (react|vue|angular|nextjs)"
    echo "  -b, --backend FRAMEWORK    Backend framework (node|python|dotnet|java)"
    echo "  -d, --database DB          Database (postgresql|mysql|mongodb)"
    echo "  -h, --help                 Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 -p my-project -e development -f react -b node -d postgresql"
    echo "  $0 --project-name my-api --environment production --backend node"
    echo ""
}

# Default values
PROJECT_NAME=""
ENVIRONMENT="development"
FRONTEND_FRAMEWORK=""
BACKEND_FRAMEWORK="node"
DATABASE="postgresql"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--project-name)
            PROJECT_NAME="$2"
            shift 2
            ;;
        -e|--environment)
            ENVIRONMENT="$2"
            shift 2
            ;;
        -f|--frontend)
            FRONTEND_FRAMEWORK="$2"
            shift 2
            ;;
        -b|--backend)
            BACKEND_FRAMEWORK="$2"
            shift 2
            ;;
        -d|--database)
            DATABASE="$2"
            shift 2
            ;;
        -h|--help)
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

# Validate required parameters
if [ -z "$PROJECT_NAME" ]; then
    echo -e "${RED}❌ Project name is required!${NC}"
    show_help
    exit 1
fi

# Validate environment
if [[ ! "$ENVIRONMENT" =~ ^(development|staging|production)$ ]]; then
    echo -e "${RED}❌ Invalid environment: $ENVIRONMENT${NC}"
    echo -e "${YELLOW}Valid options: development, staging, production${NC}"
    exit 1
fi

# Check if we're in a project directory
if [ ! -f "package.json" ]; then
    echo -e "${RED}❌ No package.json found!${NC}"
    echo -e "${YELLOW}Please run this script from your project root directory.${NC}"
    exit 1
fi

echo -e "${BLUE}📚 Creating Documentation for: $PROJECT_NAME${NC}"
echo -e "${BLUE}=====================================${NC}"
echo -e "${YELLOW}Environment:${NC} $ENVIRONMENT"
echo -e "${YELLOW}Frontend:${NC} $FRONTEND_FRAMEWORK"
echo -e "${YELLOW}Backend:${NC} $BACKEND_FRAMEWORK"
echo -e "${YELLOW}Database:${NC} $DATABASE"
echo ""

# Create documentation directory structure
echo -e "${BLUE}📁 Creating documentation structure...${NC}"
mkdir -p docs/{api,architecture,contributing,deployment,user-guide}

# API Documentation
echo -e "${BLUE}📝 Creating API documentation...${NC}"
cat > docs/api/README.md << EOF
# API Documentation

This document provides comprehensive documentation for the $PROJECT_NAME API.

## Base URL

- **Development**: http://localhost:3001/api
- **Staging**: https://staging-api.${PROJECT_NAME}.com/api
- **Production**: https://api.${PROJECT_NAME}.com/api

## Authentication

The API uses JWT (JSON Web Tokens) for authentication.

### Getting a Token

\`\`\`http
POST /auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
\`\`\`

### Using a Token

Include the token in the Authorization header:

\`\`\`http
Authorization: Bearer <your-jwt-token>
\`\`\`

## Endpoints

### Health Check

\`\`\`http
GET /health
\`\`\`

**Response:**
\`\`\`json
{
  "status": "ok",
  "timestamp": "2024-01-01T00:00:00.000Z",
  "environment": "$ENVIRONMENT",
  "version": "1.0.0"
}
\`\`\`

### Users

#### Get Current User

\`\`\`http
GET /users/me
Authorization: Bearer <token>
\`\`\`

#### Update User

\`\`\`http
PUT /users/me
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com"
}
\`\`\`

## Error Responses

All error responses follow this format:

\`\`\`json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": {
      "field": "email",
      "reason": "Invalid email format"
    }
  }
}
\`\`\`

## Rate Limiting

- **Development**: No limits
- **Staging**: 100 requests per minute
- **Production**: 1000 requests per minute

## Status Codes

- \`200\` - Success
- \`201\` - Created
- \`400\` - Bad Request
- \`401\` - Unauthorized
- \`403\` - Forbidden
- \`404\` - Not Found
- \`422\` - Validation Error
- \`500\` - Internal Server Error

## SDKs and Libraries

### JavaScript/TypeScript

\`\`\`bash
npm install @${PROJECT_NAME}/api-client
\`\`\`

\`\`\`javascript
import { ApiClient } from '@${PROJECT_NAME}/api-client';

const client = new ApiClient({
  baseUrl: 'https://api.${PROJECT_NAME}.com',
  token: 'your-jwt-token'
});

const user = await client.users.getMe();
\`\`\`

## Postman Collection

Download our Postman collection: [${PROJECT_NAME}-API.postman_collection.json](./${PROJECT_NAME}-API.postman_collection.json)

## OpenAPI Specification

View the complete OpenAPI specification: [openapi.yaml](./openapi.yaml)
EOF

# Create OpenAPI specification
cat > docs/api/openapi.yaml << EOF
openapi: 3.0.3
info:
  title: $PROJECT_NAME API
  description: API documentation for $PROJECT_NAME
  version: 1.0.0
  contact:
    name: API Support
    email: api@${PROJECT_NAME}.com
  license:
    name: MIT
    url: https://opensource.org/licenses/MIT

servers:
  - url: http://localhost:3001/api
    description: Development server
  - url: https://staging-api.${PROJECT_NAME}.com/api
    description: Staging server
  - url: https://api.${PROJECT_NAME}.com/api
    description: Production server

components:
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT

  schemas:
    User:
      type: object
      properties:
        id:
          type: string
          format: uuid
        email:
          type: string
          format: email
        name:
          type: string
        createdAt:
          type: string
          format: date-time
        updatedAt:
          type: string
          format: date-time
      required:
        - id
        - email
        - name

    Error:
      type: object
      properties:
        error:
          type: object
          properties:
            code:
              type: string
            message:
              type: string
            details:
              type: object

paths:
  /health:
    get:
      summary: Health check
      description: Check if the API is running
      responses:
        '200':
          description: API is healthy
          content:
            application/json:
              schema:
                type: object
                properties:
                  status:
                    type: string
                    example: "ok"
                  timestamp:
                    type: string
                    format: date-time
                  environment:
                    type: string
                    example: "$ENVIRONMENT"
                  version:
                    type: string
                    example: "1.0.0"

  /auth/login:
    post:
      summary: Login user
      description: Authenticate user and return JWT token
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                email:
                  type: string
                  format: email
                password:
                  type: string
                  minLength: 8
              required:
                - email
                - password
      responses:
        '200':
          description: Login successful
          content:
            application/json:
              schema:
                type: object
                properties:
                  token:
                    type: string
                  user:
                    \$ref: '#/components/schemas/User'
        '401':
          description: Invalid credentials
          content:
            application/json:
              schema:
                \$ref: '#/components/schemas/Error'

  /users/me:
    get:
      summary: Get current user
      description: Retrieve the currently authenticated user
      security:
        - bearerAuth: []
      responses:
        '200':
          description: User retrieved successfully
          content:
            application/json:
              schema:
                \$ref: '#/components/schemas/User'
        '401':
          description: Unauthorized
          content:
            application/json:
              schema:
                \$ref: '#/components/schemas/Error'

    put:
      summary: Update current user
      description: Update the currently authenticated user
      security:
        - bearerAuth: []
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                name:
                  type: string
                email:
                  type: string
                  format: email
      responses:
        '200':
          description: User updated successfully
          content:
            application/json:
              schema:
                \$ref: '#/components/schemas/User'
        '400':
          description: Invalid input
          content:
            application/json:
              schema:
                \$ref: '#/components/schemas/Error'
EOF

# Architecture Decision Records (ADRs)
echo -e "${BLUE}📝 Creating Architecture Decision Records...${NC}"
cat > docs/architecture/README.md << EOF
# Architecture Decision Records (ADRs)

This directory contains Architecture Decision Records (ADRs) for $PROJECT_NAME.

## What are ADRs?

Architecture Decision Records are short text documents that capture important architectural decisions made along with their context, consequences, and status.

## ADR Format

Each ADR follows this format:

- **Title**: A short descriptive title
- **Status**: Proposed, Accepted, Deprecated, Superseded
- **Context**: The problem being addressed
- **Decision**: The decision that was made
- **Consequences**: What becomes easier/harder due to this decision
- **Alternatives**: What other options were considered

## ADRs

- [ADR-001: Project Structure](./adr-001-project-structure.md)
- [ADR-002: Technology Stack](./adr-002-technology-stack.md)
- [ADR-003: Database Design](./adr-003-database-design.md)
- [ADR-004: API Design](./adr-004-api-design.md)
- [ADR-005: Deployment Strategy](./adr-005-deployment-strategy.md)

## Creating New ADRs

To create a new ADR:

1. Copy the template: \`cp templates/adr-template.md docs/architecture/adr-XXX-title.md\`
2. Update the content with your decision
3. Add it to this README
4. Commit the changes

## ADR Lifecycle

1. **Proposed**: Initial draft, open for discussion
2. **Accepted**: Decision has been made and approved
3. **Deprecated**: Decision is no longer relevant
4. **Superseded**: Decision has been replaced by another ADR
EOF

# Create ADR template
cat > docs/architecture/adr-template.md << EOF
# ADR-XXX: [Title]

**Date**: [YYYY-MM-DD]

**Status**: Proposed

## Context

[Describe the problem or situation that led to this decision]

## Decision

[Describe the decision that was made]

## Consequences

### Positive
- [What becomes easier or better]

### Negative
- [What becomes harder or worse]

### Neutral
- [What stays the same]

## Alternatives Considered

- [Alternative 1]: [Why it was rejected]
- [Alternative 2]: [Why it was rejected]

## References

- [Link to relevant documentation or discussions]
EOF

# Create initial ADRs
cat > docs/architecture/adr-001-project-structure.md << EOF
# ADR-001: Project Structure

**Date**: $(date +%Y-%m-%d)

**Status**: Accepted

## Context

We need a clear and scalable project structure that supports:
- Monorepo organization
- Clear separation of concerns
- Easy onboarding for new developers
- Support for multiple environments
- CI/CD integration

## Decision

We will use a monorepo structure with the following organization:

\`\`\`
$PROJECT_NAME/
├── frontend/          # Frontend application
├── backend/           # Backend API server
├── docs/             # Documentation
├── scripts/          # Utility scripts
├── tests/            # Test files
├── .github/          # GitHub Actions workflows
└── assets/           # Static assets
\`\`\`

## Consequences

### Positive
- Clear separation between frontend and backend
- Centralized documentation and scripts
- Easy to navigate and understand
- Supports both full-stack and backend-only projects
- Facilitates CI/CD integration

### Negative
- Slightly more complex than single-app structure
- Need to manage multiple package.json files

### Neutral
- Standard monorepo pattern that developers expect

## Alternatives Considered

- **Single app structure**: Rejected due to lack of separation and scalability
- **Microservices structure**: Rejected as overkill for current requirements
- **Separate repositories**: Rejected due to increased complexity in CI/CD and development workflow

## References

- [Monorepo Best Practices](https://monorepo.tools/)
- [GitHub Monorepo Guide](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-monorepo)
EOF

cat > docs/architecture/adr-002-technology-stack.md << EOF
# ADR-002: Technology Stack

**Date**: $(date +%Y-%m-%d)

**Status**: Accepted

## Context

We need to choose a technology stack that provides:
- Rapid development capabilities
- Strong ecosystem and community support
- Good performance and scalability
- Easy deployment and maintenance
- Team expertise alignment

## Decision

We will use the following technology stack:

**Frontend**: $FRONTEND_FRAMEWORK
- Modern, component-based framework
- Strong ecosystem and tooling
- Excellent developer experience

**Backend**: $BACKEND_FRAMEWORK
- Robust and scalable runtime
- Rich ecosystem of packages
- Excellent for API development

**Database**: $DATABASE
- Reliable and performant
- Strong ACID compliance
- Excellent tooling and ecosystem

## Consequences

### Positive
- Strong community support and documentation
- Excellent tooling and development experience
- Good performance characteristics
- Easy to find developers with expertise

### Negative
- Learning curve for team members new to the stack
- Potential vendor lock-in with specific tools

### Neutral
- Standard enterprise-grade stack

## Alternatives Considered

- **Python/Django**: Rejected due to slower development speed for APIs
- **Java/Spring**: Rejected due to higher complexity and slower development
- **Go**: Rejected due to smaller ecosystem for web development
- **MongoDB**: Rejected due to lack of ACID compliance for critical data

## References

- [$FRONTEND_FRAMEWORK Documentation](https://example.com)
- [$BACKEND_FRAMEWORK Documentation](https://example.com)
- [$DATABASE Documentation](https://example.com)
EOF

# Contributing Guidelines
echo -e "${BLUE}📝 Creating Contributing Guidelines...${NC}"
cat > docs/contributing/README.md << EOF
# Contributing to $PROJECT_NAME

Thank you for your interest in contributing to $PROJECT_NAME! This document provides guidelines and information for contributors.

## Getting Started

### Prerequisites

- Node.js 18+
- $DATABASE
- Git
- Docker (optional)

### Setup

1. **Fork and clone the repository**
   \`\`\`bash
   git clone https://github.com/your-username/$PROJECT_NAME.git
   cd $PROJECT_NAME
   \`\`\`

2. **Install dependencies**
   \`\`\`bash
   npm run install:all
   \`\`\`

3. **Set up environment**
   \`\`\`bash
   cp backend/.env.development backend/.env
   $(if [ -n "$FRONTEND_FRAMEWORK" ]; then echo "cp frontend/.env.development frontend/.env"; fi)
   \`\`\`

4. **Start development servers**
   \`\`\`bash
   npm run dev
   \`\`\`

## Development Workflow

### 1. Create a Feature Branch

\`\`\`bash
git checkout -b feature/your-feature-name
\`\`\`

### 2. Make Your Changes

- Write clean, well-documented code
- Follow the existing code style
- Add tests for new functionality
- Update documentation as needed

### 3. Run Tests

\`\`\`bash
npm run test
npm run lint
\`\`\`

### 4. Commit Your Changes

Use conventional commit format:

\`\`\`bash
git commit -m "feat: add user authentication"
git commit -m "fix: resolve login validation issue"
git commit -m "docs: update API documentation"
\`\`\`

### 5. Push and Create Pull Request

\`\`\`bash
git push origin feature/your-feature-name
\`\`\`

## Code Standards

### JavaScript/TypeScript

- Use ESLint and Prettier for code formatting
- Follow the existing naming conventions
- Write meaningful variable and function names
- Add JSDoc comments for public APIs

### Git Commit Messages

Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

- \`feat:\` New features
- \`fix:\` Bug fixes
- \`docs:\` Documentation changes
- \`style:\` Code style changes (formatting, etc.)
- \`refactor:\` Code refactoring
- \`test:\` Adding or updating tests
- \`chore:\` Maintenance tasks

### Pull Request Guidelines

1. **Title**: Clear, descriptive title
2. **Description**: Explain what and why, not how
3. **Related Issues**: Link to any related issues
4. **Screenshots**: Include screenshots for UI changes
5. **Tests**: Ensure all tests pass
6. **Documentation**: Update docs if needed

## Testing

### Running Tests

\`\`\`bash
# Run all tests
npm run test

# Run tests in watch mode
npm run test:watch

# Run tests with coverage
npm run test:coverage

# Run specific test file
npm run test -- --testPathPattern=user.test.js
\`\`\`

### Writing Tests

- Write tests for all new functionality
- Use descriptive test names
- Follow the AAA pattern (Arrange, Act, Assert)
- Mock external dependencies

## Documentation

### API Documentation

- Update OpenAPI specification for API changes
- Add examples for new endpoints
- Document error responses

### Code Documentation

- Add JSDoc comments for functions and classes
- Update README files for significant changes
- Create ADRs for architectural decisions

## Review Process

1. **Automated Checks**: All PRs must pass CI checks
2. **Code Review**: At least one approval required
3. **Testing**: Manual testing may be required
4. **Documentation**: Ensure docs are updated

## Getting Help

- **Issues**: Create an issue for bugs or feature requests
- **Discussions**: Use GitHub Discussions for questions
- **Slack**: Join our Slack channel for real-time help

## Code of Conduct

Please read and follow our [Code of Conduct](../CODE_OF_CONDUCT.md).

## License

By contributing to $PROJECT_NAME, you agree that your contributions will be licensed under the MIT License.
EOF

# Create Code of Conduct
echo -e "${BLUE}📝 Creating Code of Conduct...${NC}"
cat > CODE_OF_CONDUCT.md << EOF
# Code of Conduct

## Our Pledge

We as members, contributors, and leaders pledge to make participation in our
community a harassment-free experience for everyone, regardless of age, body
size, visible or invisible disability, ethnicity, sex characteristics, gender
identity and expression, level of experience, education, socio-economic status,
nationality, personal appearance, race, religion, or sexual identity
and orientation.

We pledge to act and interact in ways that contribute to an open, welcoming,
diverse, inclusive, and healthy community.

## Our Standards

Examples of behavior that contributes to a positive environment for our
community include:

* Demonstrating empathy and kindness toward other people
* Being respectful of differing opinions, viewpoints, and experiences
* Giving and gracefully accepting constructive feedback
* Accepting responsibility and apologizing to those affected by our mistakes,
  and learning from the experience
* Focusing on what is best not just for us as individuals, but for the
  overall community

Examples of unacceptable behavior include:

* The use of sexualized language or imagery, and sexual attention or
  advances of any kind
* Trolling, insulting or derogatory comments, and personal or political attacks
* Public or private harassment
* Publishing others' private information, such as a physical or email
  address, without their explicit permission
* Other conduct which could reasonably be considered inappropriate in a
  professional setting

## Enforcement Responsibilities

Community leaders are responsible for clarifying and enforcing our standards of
acceptable behavior and will take appropriate and fair corrective action in
response to any behavior that they deem inappropriate, threatening, offensive,
or harmful.

Community leaders have the right and responsibility to remove, edit, or reject
comments, commits, code, wiki edits, issues, and other contributions that are
not aligned to this Code of Conduct, and will communicate reasons for moderation
decisions when appropriate.

## Scope

This Code of Conduct applies within all community spaces, and also applies when
an individual is officially representing the community in public spaces.

## Enforcement

Instances of abusive, harassing, or otherwise unacceptable behavior may be
reported to the community leaders responsible for enforcement at
[INSERT CONTACT METHOD].

All complaints will be reviewed and investigated promptly and fairly.

All community leaders are obligated to respect the privacy and security of the
reporter of any incident.

## Enforcement Guidelines

Community leaders will follow these Community Impact Guidelines in determining
the consequences for any action they deem in violation of this Code of Conduct:

### 1. Correction

**Community Impact**: Use of inappropriate language or other behavior deemed
unprofessional or unwelcome in the community.

**Consequence**: A private, written warning from community leaders, providing
clarity around the nature of the violation and an explanation of why the
behavior was inappropriate. A public apology may be requested.

### 2. Warning

**Community Impact**: A violation through a single incident or series
of actions.

**Consequence**: A warning with consequences for continued behavior. No
interaction with the people involved, including unsolicited interaction with
those enforcing the Code of Conduct, for a specified period of time. This
includes avoiding interactions in community spaces as well as external channels
like social media. Violating these terms may lead to a temporary or
permanent ban.

### 3. Temporary Ban

**Community Impact**: A serious violation of community standards, including
sustained inappropriate behavior.

**Consequence**: A temporary ban from any sort of interaction or public
communication with the community for a specified period of time. No public or
private interaction with the people involved, including unsolicited interaction
with those enforcing the Code of Conduct, is allowed during this period.
Violating these terms may lead to a permanent ban.

### 4. Permanent Ban

**Community Impact**: Demonstrating a pattern of violation of community
standards, including sustained inappropriate behavior,  harassment of an
individual, or aggression toward or disparagement of classes of individuals.

**Consequence**: A permanent ban from any sort of public interaction within
the community.

## Attribution

This Code of Conduct is adapted from the [Contributor Covenant](https://www.contributor-covenant.org),
version 2.0, available at
https://www.contributor-covenant.org/version/2/0/code_of_conduct.html.

Community Impact Guidelines were inspired by [Mozilla's code of conduct
enforcement ladder](https://github.com/mozilla/diversity).

For answers to common questions about this code of conduct, see the FAQ at
https://www.contributor-covenant.org/faq. Translations are available at
https://www.contributor-covenant.org/translations.
EOF

# User Guide
echo -e "${BLUE}📝 Creating User Guide...${NC}"
cat > docs/user-guide/README.md << EOF
# User Guide

Welcome to the $PROJECT_NAME user guide! This guide will help you get started and make the most of our platform.

## Getting Started

### 1. Account Setup

1. **Sign Up**: Visit [${PROJECT_NAME}.com](https://${PROJECT_NAME}.com) and click "Sign Up"
2. **Verify Email**: Check your email and click the verification link
3. **Complete Profile**: Add your information and preferences

### 2. First Steps

1. **Dashboard**: Explore your personalized dashboard
2. **Settings**: Configure your account preferences
3. **Tutorial**: Complete the interactive tutorial

## Features

### Core Features

- **Feature 1**: Description of the first main feature
- **Feature 2**: Description of the second main feature
- **Feature 3**: Description of the third main feature

### Advanced Features

- **Advanced Feature 1**: Description of advanced functionality
- **Advanced Feature 2**: Description of advanced functionality

## Troubleshooting

### Common Issues

**Issue**: Can't log in
**Solution**: Reset your password using the "Forgot Password" link

**Issue**: Feature not working
**Solution**: Check if your browser is up to date and try refreshing the page

### Getting Help

- **Help Center**: Visit our [Help Center](https://help.${PROJECT_NAME}.com)
- **Support Email**: Contact us at support@${PROJECT_NAME}.com
- **Live Chat**: Available during business hours

## FAQ

**Q: How do I change my password?**
A: Go to Settings > Security > Change Password

**Q: Can I export my data?**
A: Yes, go to Settings > Data > Export

**Q: Is my data secure?**
A: Yes, we use industry-standard encryption and security practices

## Updates and Changes

Stay informed about new features and updates:

- **Release Notes**: Check our [Release Notes](https://${PROJECT_NAME}.com/releases)
- **Blog**: Read our [Blog](https://${PROJECT_NAME}.com/blog)
- **Newsletter**: Subscribe to our newsletter

## Feedback

We value your feedback! Here's how you can help us improve:

- **Feature Requests**: Submit via our feedback form
- **Bug Reports**: Use the "Report Bug" button in the app
- **User Research**: Participate in our user research sessions

## Legal

- [Terms of Service](https://${PROJECT_NAME}.com/terms)
- [Privacy Policy](https://${PROJECT_NAME}.com/privacy)
- [Cookie Policy](https://${PROJECT_NAME}.com/cookies)
EOF

# Deployment Documentation
echo -e "${BLUE}📝 Creating Deployment Guide...${NC}"
cat > docs/deployment/README.md << EOF
# Deployment Guide

This guide covers deploying $PROJECT_NAME to different environments.

## Prerequisites

- Docker and Docker Compose installed
- Access to container registry
- Environment-specific secrets configured

## Environment Overview

### Development
- **Purpose**: Local development and testing
- **URL**: http://localhost:3000 (frontend), http://localhost:3001 (backend)
- **Database**: Local PostgreSQL
- **Deployment**: Docker Compose

### Staging
- **Purpose**: Pre-production testing
- **URL**: https://staging.${PROJECT_NAME}.com
- **Database**: Staging PostgreSQL instance
- **Deployment**: Automated via GitHub Actions

### Production
- **Purpose**: Live application
- **URL**: https://${PROJECT_NAME}.com
- **Database**: Production PostgreSQL cluster
- **Deployment**: Automated via GitHub Actions with manual approval

## Local Development Deployment

### Using Docker Compose

\`\`\`bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
\`\`\`

### Manual Setup

\`\`\`bash
# Backend
cd backend
npm install
cp .env.development .env
npm run dev

# Frontend (if applicable)
cd frontend
npm install
cp .env.development .env
npm run dev
\`\`\`

## Staging Deployment

### Automated Deployment

1. **Push to staging branch**
   \`\`\`bash
   git push origin staging
   \`\`\`

2. **Monitor deployment**
   - Check GitHub Actions: https://github.com/your-org/$PROJECT_NAME/actions
   - Monitor staging environment: https://staging.${PROJECT_NAME}.com

### Manual Deployment

\`\`\`bash
# Build and deploy
./scripts/deploy-staging.sh
\`\`\`

## Production Deployment

### Automated Deployment

1. **Create release**
   \`\`\`bash
   git tag v1.0.0
   git push origin v1.0.0
   \`\`\`

2. **Merge to main**
   \`\`\`bash
   git checkout main
   git merge staging
   git push origin main
   \`\`\`

3. **Approve deployment**
   - Go to GitHub Actions
   - Review and approve the production deployment

### Manual Deployment

\`\`\`bash
# Build and deploy
./scripts/deploy-production.sh
\`\`\`

## Database Migrations

### Running Migrations

\`\`\`bash
# Development
cd backend
npm run db:migrate

# Staging/Production
npm run db:migrate:prod
\`\`\`

### Creating Migrations

\`\`\`bash
# Create new migration
npm run db:migrate:create -- --name add_user_table

# Run specific migration
npm run db:migrate:up -- --name add_user_table
\`\`\`

## Monitoring and Logs

### Application Logs

\`\`\`bash
# Docker logs
docker-compose logs -f backend
docker-compose logs -f frontend

# Kubernetes logs
kubectl logs -f deployment/$PROJECT_NAME-backend
kubectl logs -f deployment/$PROJECT_NAME-frontend
\`\`\`

### Health Checks

- **Application**: https://api.${PROJECT_NAME}.com/health
- **Database**: Check connection status in logs
- **Redis**: Check connection status in logs

## Troubleshooting

### Common Issues

**Issue**: Application won't start
**Solution**: Check environment variables and database connection

**Issue**: Database connection failed
**Solution**: Verify database credentials and network connectivity

**Issue**: Build fails
**Solution**: Check Docker build logs and dependencies

### Rollback

\`\`\`bash
# Rollback to previous version
git checkout v1.0.0
./scripts/deploy-production.sh
\`\`\`

## Security

### Secrets Management

- Store secrets in GitHub repository secrets
- Use environment-specific secret files
- Rotate secrets regularly

### SSL/TLS

- Configure SSL certificates for production
- Use HTTPS for all external communication
- Enable HSTS headers

## Performance

### Optimization

- Enable gzip compression
- Configure CDN for static assets
- Optimize database queries
- Use caching strategies

### Monitoring

- Set up application performance monitoring
- Monitor database performance
- Track error rates and response times
EOF

# Create a comprehensive project documentation index
echo -e "${BLUE}📝 Creating Documentation Index...${NC}"
cat > docs/README.md << EOF
# $PROJECT_NAME Documentation

Welcome to the comprehensive documentation for $PROJECT_NAME. This documentation is organized to help you find the information you need quickly and efficiently.

## 📚 Documentation Sections

### 🚀 Getting Started
- **[Quick Start Guide](../README.md)** - Get up and running in minutes
- **[Development Setup](development/README.md)** - Set up your development environment
- **[User Guide](user-guide/README.md)** - Learn how to use the application

### 🏗️ Architecture & Design
- **[Architecture Decision Records](architecture/README.md)** - Design decisions and rationale
- **[API Documentation](api/README.md)** - Complete API reference
- **[Database Schema](architecture/database-schema.md)** - Database design and relationships

### 👥 Contributing & Development
- **[Contributing Guidelines](contributing/README.md)** - How to contribute to the project
- **[Code Standards](contributing/code-standards.md)** - Coding conventions and best practices
- **[Testing Guide](contributing/testing.md)** - How to write and run tests

### 🚀 Deployment & Operations
- **[Deployment Guide](deployment/README.md)** - Deploy to different environments
- **[CI/CD Configuration](ci-cd/README.md)** - Continuous integration and deployment
- **[Monitoring & Logging](deployment/monitoring.md)** - Operations and monitoring

### 📖 Reference
- **[API Reference](api/openapi.yaml)** - OpenAPI specification
- **[Configuration](deployment/configuration.md)** - Environment configuration
- **[Troubleshooting](deployment/troubleshooting.md)** - Common issues and solutions

## 🔍 Quick Navigation

### For New Developers
1. Start with the [Quick Start Guide](../README.md)
2. Read the [Development Setup](development/README.md)
3. Review [Contributing Guidelines](contributing/README.md)

### For API Users
1. Check the [API Documentation](api/README.md)
2. Review the [OpenAPI Specification](api/openapi.yaml)
3. See [API Examples](api/examples.md)

### For DevOps Engineers
1. Review the [Deployment Guide](deployment/README.md)
2. Check [CI/CD Configuration](ci-cd/README.md)
3. Read [Monitoring & Logging](deployment/monitoring.md)

### For Product Managers
1. Start with the [User Guide](user-guide/README.md)
2. Review [Architecture Decisions](architecture/README.md)
3. Check [Release Notes](deployment/releases.md)

## 📝 Documentation Standards

### Writing Guidelines
- Use clear, concise language
- Include examples and code snippets
- Keep information up to date
- Use consistent formatting

### Contributing to Documentation
- Follow the [Contributing Guidelines](contributing/README.md)
- Update documentation when making code changes
- Create ADRs for architectural decisions
- Add examples for new features

## 🔗 External Resources

- **[GitHub Repository](https://github.com/your-org/$PROJECT_NAME)**
- **[Issue Tracker](https://github.com/your-org/$PROJECT_NAME/issues)**
- **[Discussions](https://github.com/your-org/$PROJECT_NAME/discussions)**
- **[Releases](https://github.com/your-org/$PROJECT_NAME/releases)**

## 📞 Support

- **Documentation Issues**: Create an issue in the repository
- **Technical Support**: Contact the development team
- **Feature Requests**: Use the issue tracker
- **General Questions**: Use GitHub Discussions

---

*Last updated: $(date +%Y-%m-%d)*
EOF

echo -e "${GREEN}✅ Documentation created successfully!${NC}"
echo ""
echo -e "${BLUE}📋 Documentation Summary:${NC}"
echo -e "${YELLOW}📖 API Documentation:${NC} docs/api/README.md"
echo -e "${YELLOW}🔧 OpenAPI Spec:${NC} docs/api/openapi.yaml"
echo -e "${YELLOW}🏗️ Architecture ADRs:${NC} docs/architecture/"
echo -e "${YELLOW}👥 Contributing Guide:${NC} docs/contributing/README.md"
echo -e "${YELLOW}📋 Code of Conduct:${NC} CODE_OF_CONDUCT.md"
echo -e "${YELLOW}👤 User Guide:${NC} docs/user-guide/README.md"
echo -e "${YELLOW}🚀 Deployment Guide:${NC} docs/deployment/README.md"
echo -e "${YELLOW}📚 Documentation Index:${NC} docs/README.md"
echo ""
echo -e "${BLUE}🎉 Your project documentation is ready!${NC}"
echo -e "${YELLOW}💡 Tip: Update the documentation with your specific project details.${NC}" 