// Basic type definitions for the project
// This demonstrates TypeScript strict mode and type safety

export interface User {
  id: string;
  name: string;
  email: string;
  createdAt: Date;
  isActive: boolean;
}

export interface Project {
  id: string;
  name: string;
  description: string;
  owner: User;
  collaborators: User[];
  createdAt: Date;
  updatedAt: Date;
}

export type ProjectStatus = 'draft' | 'active' | 'archived' | 'deleted';

export interface ProjectWithStatus extends Project {
  status: ProjectStatus;
}

// Union types example
export type ApiResponse<T> =
  | { success: true; data: T }
  | { success: false; error: string; code: number };

// Function type definitions
export type ValidationFunction<T> = (value: T) => boolean;
export type TransformFunction<T, U> = (value: T) => U;
