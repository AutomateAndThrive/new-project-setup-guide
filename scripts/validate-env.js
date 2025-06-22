#!/usr/bin/env node

/**
 * Environment variable validation script
 * Ensures all required environment variables are present and valid
 */

const fs = require('fs');
const path = require('path');

// Define required environment variables
const REQUIRED_ENV_VARS = {
  NODE_ENV: {
    required: true,
    default: 'development',
    validate: (value) => ['development', 'production', 'test'].includes(value),
    message: 'NODE_ENV must be one of: development, production, test',
  },
  PORT: {
    required: false,
    default: '3000',
    validate: (value) => !isNaN(parseInt(value)) && parseInt(value) > 0,
    message: 'PORT must be a positive number',
  },
  DATABASE_URL: {
    required: false,
    default: 'postgresql://app_user:app_password@localhost:5432/app_dev',
    validate: (value) => value && value.length > 0,
    message: 'DATABASE_URL must be a valid database connection string',
  },
};

// Define optional environment variables with validation
const OPTIONAL_ENV_VARS = {
  LOG_LEVEL: {
    validate: (value) => ['error', 'warn', 'info', 'debug'].includes(value),
    message: 'LOG_LEVEL must be one of: error, warn, info, debug',
  },
  REDIS_URL: {
    validate: (value) => !value || value.startsWith('redis://'),
    message: 'REDIS_URL must start with redis://',
  },
};

function validateEnvVar(name, config, value) {
  // If not required and no value, use default
  if (!config.required && !value && config.default) {
    process.env[name] = config.default;
    console.log(`✅ ${name}: Using default value "${config.default}"`);
    return true;
  }

  // If required but no value
  if (config.required && !value) {
    console.error(`❌ ${name}: Required but not set`);
    return false;
  }

  // If no value and not required, skip validation
  if (!value) {
    return true;
  }

  // Validate value if validator exists
  if (config.validate && !config.validate(value)) {
    console.error(`❌ ${name}: ${config.message}`);
    return false;
  }

  console.log(`✅ ${name}: Valid`);
  return true;
}

function main() {
  console.log('🔍 Validating environment variables...\n');

  let allValid = true;

  // Validate required environment variables
  for (const [name, config] of Object.entries(REQUIRED_ENV_VARS)) {
    if (!validateEnvVar(name, config, process.env[name])) {
      allValid = false;
    }
  }

  // Validate optional environment variables
  for (const [name, config] of Object.entries(OPTIONAL_ENV_VARS)) {
    if (!validateEnvVar(name, config, process.env[name])) {
      allValid = false;
    }
  }

  // Check for .env file
  const envPath = path.join(process.cwd(), '.env');
  if (!fs.existsSync(envPath)) {
    console.log('\n📝 No .env file found. Creating .env.example...');
    createEnvExample();
  }

  console.log('\n📊 Validation Summary:');
  if (allValid) {
    console.log('✅ All environment variables are valid!');
    process.exit(0);
  } else {
    console.log('❌ Some environment variables are invalid. Please fix the issues above.');
    process.exit(1);
  }
}

function createEnvExample() {
  const exampleContent = `# Environment Variables Example
# Copy this file to .env and update the values

# Required
NODE_ENV=development
PORT=3000

# Database
DATABASE_URL=postgresql://app_user:app_password@localhost:5432/app_dev

# Optional
LOG_LEVEL=info
REDIS_URL=redis://localhost:6379

# Add your application-specific environment variables below
# API_KEY=your_api_key_here
# JWT_SECRET=your_jwt_secret_here
`;

  const examplePath = path.join(process.cwd(), '.env.example');
  fs.writeFileSync(examplePath, exampleContent);
  console.log('✅ Created .env.example file');
}

if (require.main === module) {
  main();
}

module.exports = { validateEnvVar, REQUIRED_ENV_VARS, OPTIONAL_ENV_VARS };
