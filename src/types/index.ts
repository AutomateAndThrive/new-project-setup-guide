/**
 * Core type definitions for the New Project Setup Guide
 *
 * This module contains all the fundamental types used throughout the application,
 * demonstrating TypeScript strict mode and type safety best practices.
 *
 * @module Types
 */

/**
 * Represents a user in the system
 *
 * @interface User
 * @description Core user entity with essential properties for authentication and identification
 */
export interface User {
  /** Unique identifier for the user */
  id: string;
  /** Display name of the user */
  name: string;
  /** Email address used for authentication and communication */
  email: string;
  /** Timestamp when the user account was created */
  createdAt: Date;
  /** Whether the user account is currently active */
  isActive: boolean;
}

/**
 * Represents a project in the system
 *
 * @interface Project
 * @description Core project entity with metadata and relationships
 */
export interface Project {
  /** Unique identifier for the project */
  id: string;
  /** Human-readable name of the project */
  name: string;
  /** Detailed description of the project's purpose and scope */
  description: string;
  /** The user who owns this project */
  owner: User;
  /** List of users who collaborate on this project */
  collaborators: User[];
  /** Timestamp when the project was created */
  createdAt: Date;
  /** Timestamp when the project was last modified */
  updatedAt: Date;
}

/**
 * Possible states a project can be in
 *
 * @typedef {string} ProjectStatus
 * @description Enumeration of project lifecycle states
 */
export type ProjectStatus = 'draft' | 'active' | 'archived' | 'deleted';

/**
 * Project with status information
 *
 * @interface ProjectWithStatus
 * @extends {Project}
 * @description Extends the base Project interface with status tracking
 */
export interface ProjectWithStatus extends Project {
  /** Current status of the project in its lifecycle */
  status: ProjectStatus;
}

/**
 * Generic API response wrapper
 *
 * @template T - The type of data being returned
 * @typedef {Object} ApiResponse
 * @description Union type for consistent API response handling
 */
export type ApiResponse<T> =
  | { success: true; data: T }
  | { success: false; error: string; code: number };

/**
 * Generic validation function type
 *
 * @template T - The type of value to validate
 * @typedef {Function} ValidationFunction
 * @description Function signature for value validation
 */
export type ValidationFunction<T> = (value: T) => boolean;

/**
 * Generic transformation function type
 *
 * @template T - The input type
 * @template U - The output type
 * @typedef {Function} TransformFunction
 * @description Function signature for data transformation
 */
export type TransformFunction<T, U> = (value: T) => U;
