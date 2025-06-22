import type { User } from '../types';
import { validateUser, formatUserName } from '../utils/helpers';

// This file demonstrates TypeScript strict mode enforcement
// It shows examples of what strict mode prevents and how to write proper TypeScript

// ✅ GOOD: Properly typed function with explicit return type
export const createUser = (name: string, email: string): User => {
  return {
    id: `user_${Date.now()}`,
    name,
    email,
    createdAt: new Date(),
    isActive: true,
  };
};

// ✅ GOOD: Proper error handling with type guards
export const processUserData = (data: unknown): string => {
  if (validateUser(data)) {
    return formatUserName(data); // TypeScript knows data is User here
  }
  return 'Invalid user data';
};

// ✅ GOOD: Proper array typing
export const getUserNames = (users: User[]): string[] => {
  return users.map((user) => user.name);
};

// ✅ GOOD: Proper optional parameter handling
export const updateUser = (user: User, updates: Partial<User>): User => {
  return { ...user, ...updates };
};

// ❌ EXAMPLES OF WHAT STRICT MODE PREVENTS (commented out to avoid errors)

// This would cause a strict mode error:
// export const badFunction = (param) => {  // Error: Parameter 'param' implicitly has 'any' type
//   return param.someProperty;  // Error: Object is of type 'unknown'
// };

// This would cause a null check error:
// export const unsafeAccess = (user: User | null): string => {
//   return user.name;  // Error: Object is possibly 'null'
// };

// This would cause a strict function types error:
// export const badCallback = (callback: (x: string) => void) => {
//   callback(123);  // Error: Argument of type 'number' is not assignable to parameter of type 'string'
// };

// This would cause a strict bind call apply error:
// export const badMethodCall = (obj: { method: (x: string) => void }) => {
//   obj.method.call(null, 123);  // Error: Argument of type 'number' is not assignable
// };

// This would cause a strict property initialization error:
// export class BadClass {
//   private name: string;  // Error: Property 'name' has no initializer
// }

// ✅ GOOD: Proper class with strict mode compliance
export class GoodClass {
  private name: string;
  private readonly id: string;

  constructor(name: string) {
    this.name = name;
    this.id = `class_${Date.now()}`;
  }

  public getName(): string {
    return this.name;
  }

  public updateName(newName: string): void {
    this.name = newName;
  }
}

// ✅ GOOD: Proper async function typing
export const fetchUserData = async (userId: string): Promise<User | null> => {
  try {
    // Simulate API call
    const response = await fetch(`/api/users/${userId}`);
    if (!response.ok) {
      return null;
    }
    const data = await response.json();
    return validateUser(data) ? data : null;
  } catch (error) {
    console.error('Failed to fetch user:', error);
    return null;
  }
};

// ✅ GOOD: Proper generic function
export const createArray = <T>(length: number, defaultValue: T): T[] => {
  return Array.from({ length }, () => defaultValue);
};

// ✅ GOOD: Proper union type handling
export const handleApiResponse = <T>(
  response: { success: true; data: T } | { success: false; error: string },
): T | null => {
  if (response.success) {
    return response.data; // TypeScript knows this is T
  } else {
    console.error('API Error:', response.error);
    return null;
  }
};

// ✅ GOOD: Simple, type-safe functions for Vitest sample
export const strictSum = (a: number, b: number): number => a + b;
export const strictGreet = (name: string): string => `Hello, ${name}!`;
