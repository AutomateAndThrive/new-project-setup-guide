import { describe, it, expect } from 'vitest';
import { strictSum, strictGreet } from './strict-mode';

describe('strict-mode example', () => {
  it('strictSum adds two numbers', () => {
    expect(strictSum(2, 3)).toBe(5);
    expect(strictSum(-1, 1)).toBe(0);
  });

  it('strictGreet returns a greeting', () => {
    expect(strictGreet('Alice')).toBe('Hello, Alice!');
    expect(strictGreet('')).toBe('Hello, !');
  });
});
