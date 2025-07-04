import type { User, Project, ValidationFunction, TransformFunction } from '../types';

// Utility functions demonstrating TypeScript strict mode
// These functions show proper typing and error handling

/**
 * Validates if a user object has all required fields
 * Demonstrates strict null checks and type guards
 */
export const validateUser = (user: unknown): user is User => {
  if (!user || typeof user !== 'object') {
    return false;
  }

  const userObj = user as Record<string, unknown>;

  return (
    typeof userObj.id === 'string' &&
    typeof userObj.name === 'string' &&
    typeof userObj.email === 'string' &&
    userObj.createdAt instanceof Date &&
    typeof userObj.isActive === 'boolean'
  );
};

/**
 * Formats a user's display name
 * Shows proper function typing and string manipulation
 */
export const formatUserName = (user: User): string => {
  return `${user.name} (${user.email})`;
};

/**
 * Filters projects by status
 * Demonstrates array methods with proper typing
 */
export const filterProjectsByStatus = (projects: Project[]): Project[] => {
  // Placeholder for demonstration; would filter by status in a real implementation
  return projects;
};

/**
 * Creates a validation function for any type
 * Shows higher-order functions with generics
 */
export const createValidator = <T>(validationFn: ValidationFunction<T>): ValidationFunction<T> => {
  return (value: T): boolean => {
    try {
      return validationFn(value);
    } catch {
      return false;
    }
  };
};

/**
 * Transforms data with error handling
 * Demonstrates proper error handling and return types
 */
export const safeTransform = <T, U>(data: T, transformFn: TransformFunction<T, U>): U | null => {
  try {
    return transformFn(data);
  } catch (error) {
    // eslint-disable-next-line no-console
    console.error('Transform failed:', error);
    return null;
  }
};

/**
 * Generates a unique ID
 * Shows utility functions with proper return types
 */
export const generateId = (): string => {
  return `id_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
};

/**
 * Formats a date to YYYY-MM-DD format
 * Demonstrates date handling and string formatting
 */
export const formatDate = (date: Date): string => {
  if (isNaN(date.getTime())) {
    return 'Invalid Date';
  }
  return date.toISOString().split('T')[0];
};

/**
 * Validates email format using regex
 * Shows string validation and regex usage
 */
export const validateEmail = (email: string): boolean => {
  // Reject consecutive dots, leading/trailing dots in local or domain part
  if (/\.\./.test(email)) return false;
  if (/^\.|\.$|@\.|\.@/.test(email)) return false;
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
};

/**
 * Calculates percentage with proper rounding
 * Demonstrates mathematical operations and precision handling
 */
export const calculatePercentage = (value: number, total: number): number => {
  if (total === 0) return 0;
  return Math.round((value / total) * 100 * 100) / 100;
};
