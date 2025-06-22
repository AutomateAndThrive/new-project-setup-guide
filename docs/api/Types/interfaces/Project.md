[**New Project Setup Guide API**](../../README.md)

---

[New Project Setup Guide API](../../modules.md) / [Types](../README.md) / Project

# Interface: Project

Defined in: [types/index.ts:35](https://github.com/AutomateAndThrive/new-project-setup-guide/blob/main/src/types/index.ts#L35)

Represents a project in the system

Project

## Description

Core project entity with metadata and relationships

## Extended by

- [`ProjectWithStatus`](ProjectWithStatus.md)

## Properties

### id

> **id**: `string`

Defined in: [types/index.ts:37](https://github.com/AutomateAndThrive/new-project-setup-guide/blob/main/src/types/index.ts#L37)

Unique identifier for the project

---

### name

> **name**: `string`

Defined in: [types/index.ts:39](https://github.com/AutomateAndThrive/new-project-setup-guide/blob/main/src/types/index.ts#L39)

Human-readable name of the project

---

### description

> **description**: `string`

Defined in: [types/index.ts:41](https://github.com/AutomateAndThrive/new-project-setup-guide/blob/main/src/types/index.ts#L41)

Detailed description of the project's purpose and scope

---

### owner

> **owner**: [`User`](User.md)

Defined in: [types/index.ts:43](https://github.com/AutomateAndThrive/new-project-setup-guide/blob/main/src/types/index.ts#L43)

The user who owns this project

---

### collaborators

> **collaborators**: [`User`](User.md)[]

Defined in: [types/index.ts:45](https://github.com/AutomateAndThrive/new-project-setup-guide/blob/main/src/types/index.ts#L45)

List of users who collaborate on this project

---

### createdAt

> **createdAt**: `Date`

Defined in: [types/index.ts:47](https://github.com/AutomateAndThrive/new-project-setup-guide/blob/main/src/types/index.ts#L47)

Timestamp when the project was created

---

### updatedAt

> **updatedAt**: `Date`

Defined in: [types/index.ts:49](https://github.com/AutomateAndThrive/new-project-setup-guide/blob/main/src/types/index.ts#L49)

Timestamp when the project was last modified
