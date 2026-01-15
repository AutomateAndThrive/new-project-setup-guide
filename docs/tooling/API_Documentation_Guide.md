# API Documentation Guide

This guide covers our approach to automated API documentation generation and standards for documenting code.

## 🎯 Overview

We use **TypeDoc** to automatically generate API documentation from TypeScript source code and JSDoc comments. This ensures our documentation stays in sync with the code and provides comprehensive API references.

## 📚 Generated Documentation

### What Gets Documented

- **Public APIs**: All exported functions, classes, interfaces, and types
- **JSDoc Comments**: Detailed descriptions, parameters, return values, and examples
- **Type Information**: Full TypeScript type definitions and relationships
- **Module Structure**: Organized by categories and groups

### Documentation Location

- **Generated Docs**: `docs/api/` (automatically generated)
- **Source Comments**: Inline JSDoc in TypeScript files
- **Configuration**: `typedoc.json` in project root

## 🔧 Setup and Usage

### Installation

TypeDoc is already installed as a development dependency:

```bash
npm install --save-dev typedoc typedoc-plugin-markdown
```

### Available Scripts

```bash
# Generate static documentation
npm run docs:generate

# Generate and serve documentation locally
npm run docs:serve

# Generate and watch for changes
npm run docs:watch
```

### Configuration

The TypeDoc configuration is in `typedoc.json`:

```json
{
  "entryPoints": ["src/**/*.ts"],
  "out": "docs/api",
  "exclude": ["**/*.test.ts", "**/*.spec.ts", "**/node_modules/**"],
  "excludePrivate": true,
  "excludeProtected": true,
  "excludeExternals": true,
  "includeVersion": true,
  "theme": "default",
  "name": "New Project Setup Guide API",
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
  "includeDeclarations": false,
  "excludeNotDocumented": false,
  "excludeNotDocumentedKinds": ["Module"],
  "plugin": ["typedoc-plugin-markdown"],
  "entryDocument": "index.md",
  "hideGenerator": true,
  "cleanOutputDir": true
}
```

## ✍️ Documentation Standards

### JSDoc Comment Format

````typescript
/**
 * Brief description of what the function/class/interface does.
 *
 * Longer description if needed, explaining the purpose, usage,
 * and any important details about the implementation.
 *
 * @param paramName - Description of the parameter
 * @param options - Configuration options
 * @returns Description of what is returned
 * @throws {ErrorType} When and why this error is thrown
 * @example
 * ```typescript
 * const result = functionName('example', { option: true });
 * console.log(result); // Expected output
 * ```
 */
````

### Required Documentation

#### Functions

- **Purpose**: What the function does
- **Parameters**: Type, description, and constraints
- **Return Value**: Type and description
- **Side Effects**: Any external changes made
- **Examples**: Usage examples for complex functions

#### Classes

- **Purpose**: What the class represents
- **Constructor**: Parameters and initialization
- **Methods**: Public method documentation
- **Properties**: Public property descriptions
- **Inheritance**: Base classes and interfaces

#### Interfaces/Types

- **Purpose**: What the type represents
- **Properties**: Description of each property
- **Constraints**: Any validation or business rules
- **Usage**: How and when to use this type

### Documentation Examples

#### Function Documentation

````typescript
/**
 * Validates an email address format.
 *
 * This function uses a comprehensive regex pattern to validate email addresses,
 * checking for proper format, domain structure, and common edge cases.
 *
 * @param email - The email string to validate
 * @returns True if the email format is valid, false otherwise
 * @throws {TypeError} If the input is not a string
 *
 * @example
 * ```typescript
 * validateEmail('user@example.com'); // true
 * validateEmail('invalid-email'); // false
 * validateEmail(''); // false
 * ```
 */
export function validateEmail(email: string): boolean {
  if (typeof email !== 'string') {
    throw new TypeError('Email must be a string');
  }

  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
}
````

#### Class Documentation

````typescript
/**
 * Manages user authentication and session state.
 *
 * This class handles user login, logout, and session management.
 * It provides methods for validating credentials and managing
 * authentication tokens.
 *
 * @example
 * ```typescript
 * const auth = new AuthManager();
 * const user = await auth.login('user@example.com', 'password');
 * if (user) {
 *   console.log('Logged in as:', user.name);
 * }
 * ```
 */
export class AuthManager {
  private currentUser: User | null = null;

  /**
   * Authenticates a user with email and password.
   *
   * @param email - User's email address
   * @param password - User's password
   * @returns Promise resolving to User object if successful, null if failed
   * @throws {AuthError} If authentication service is unavailable
   */
  async login(email: string, password: string): Promise<User | null> {
    // Implementation...
  }

  /**
   * Logs out the current user and clears session data.
   */
  logout(): void {
    this.currentUser = null;
  }

  /**
   * Gets the currently authenticated user.
   *
   * @returns Current user or null if not authenticated
   */
  getCurrentUser(): User | null {
    return this.currentUser;
  }
}
````

#### Interface Documentation

```typescript
/**
 * Configuration options for API requests.
 *
 * This interface defines the standard options that can be passed
 * to API request functions for customizing behavior.
 *
 * @interface ApiOptions
 */
export interface ApiOptions {
  /** Request timeout in milliseconds */
  timeout?: number;
  /** Additional headers to include in the request */
  headers?: Record<string, string>;
  /** Whether to include authentication credentials */
  withCredentials?: boolean;
  /** Retry configuration for failed requests */
  retry?: {
    /** Number of retry attempts */
    attempts: number;
    /** Delay between retries in milliseconds */
    delay: number;
  };
}
```

## 🚀 Best Practices

### Writing Good Documentation

1. **Be Clear and Concise**
   - Use simple, direct language
   - Avoid jargon unless necessary
   - Focus on what the code does, not how it does it

2. **Include Examples**
   - Provide realistic usage examples
   - Show both simple and complex use cases
   - Include error handling examples

3. **Document Edge Cases**
   - Explain what happens with invalid input
   - Document performance considerations
   - Note any limitations or constraints

4. **Keep It Updated**
   - Update documentation when code changes
   - Remove outdated examples
   - Verify examples still work

### Common Patterns

#### Generic Functions

```typescript
/**
 * Transforms an array of items using a mapping function.
 *
 * @template T - The type of items in the input array
 * @template U - The type of items in the output array
 * @param items - Array of items to transform
 * @param mapper - Function to apply to each item
 * @returns New array with transformed items
 */
export function mapArray<T, U>(items: T[], mapper: (item: T) => U): U[] {
  return items.map(mapper);
}
```

#### Optional Parameters

```typescript
/**
 * Creates a user with optional profile information.
 *
 * @param email - User's email address (required)
 * @param name - User's display name (required)
 * @param options - Optional profile settings
 * @param options.avatar - URL to user's avatar image
 * @param options.bio - User's biography text
 * @returns Newly created user object
 */
export function createUser(
  email: string,
  name: string,
  options?: {
    avatar?: string;
    bio?: string;
  },
): User {
  // Implementation...
}
```

#### Union Types

```typescript
/**
 * Processes different types of content.
 *
 * @param content - Content to process (string, buffer, or file path)
 * @returns Processed content as string
 * @throws {Error} If content cannot be processed
 */
export function processContent(content: string | Buffer | { path: string }): string {
  // Implementation...
}
```

## 🔍 Validation and Quality

### TypeDoc Validation

TypeDoc includes built-in validation:

- **Invalid Links**: Checks for broken internal links
- **Not Exported**: Warns about undocumented exports
- **Missing Types**: Identifies incomplete type information

### Quality Checks

```bash
# Generate documentation and check for issues
npm run docs:generate

# Check for validation errors in output
# Look for warnings in the console output
```

### Common Issues

1. **Missing Documentation**
   - Export public APIs without JSDoc comments
   - Solution: Add comprehensive JSDoc documentation

2. **Broken Links**
   - References to non-existent types or functions
   - Solution: Update links or fix type references

3. **Incomplete Examples**
   - Examples that don't compile or are outdated
   - Solution: Test examples and keep them current

## 📖 Integration with CI/CD

### Automated Generation

The documentation generation can be integrated into CI/CD:

```yaml
# In .github/workflows/ci.yml
- name: Generate API Documentation
  run: npm run docs:generate
  if: github.event_name == 'push' && github.ref == 'refs/heads/main'
```

### Documentation Deployment

Generated documentation can be deployed to:

- **GitHub Pages**: For public API documentation
- **Internal Wiki**: For team reference
- **Static Site**: For custom documentation sites

## 🛠️ Customization

### Themes and Styling

TypeDoc supports custom themes and styling:

```json
{
  "theme": "custom-theme",
  "customCss": "./docs/custom.css"
}
```

### Plugin Development

Custom plugins can extend TypeDoc functionality:

```typescript
// Custom plugin example
export function load(application: Application) {
  // Custom functionality
}
```

## 📚 Resources

- [TypeDoc Documentation](https://typedoc.org/)
- [JSDoc Reference](https://jsdoc.app/)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [API Documentation Best Practices](https://swagger.io/resources/articles/documenting-your-api/)

---

**Remember**: Good API documentation is a living document that evolves with your code. Keep it updated, test your examples, and make it accessible to your team and users.
