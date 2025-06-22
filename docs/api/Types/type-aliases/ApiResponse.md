[**New Project Setup Guide API**](../../README.md)

---

[New Project Setup Guide API](../../modules.md) / [Types](../README.md) / ApiResponse

# Type Alias: ApiResponse\<T\>

> **ApiResponse**\<`T`\> = \{ `success`: `true`; `data`: `T`; \} \| \{ `success`: `false`; `error`: `string`; `code`: `number`; \}

Defined in: [types/index.ts:79](https://github.com/AutomateAndThrive/new-project-setup-guide/blob/main/src/types/index.ts#L79)

Generic API response wrapper

## Type Parameters

### T

`T`

The type of data being returned

## Description

Union type for consistent API response handling
