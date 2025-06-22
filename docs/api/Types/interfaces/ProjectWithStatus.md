[**New Project Setup Guide API**](../../README.md)

---

[New Project Setup Guide API](../../modules.md) / [Types](../README.md) / ProjectWithStatus

# Interface: ProjectWithStatus

Defined in: [types/index.ts:67](https://github.com/AutomateAndThrive/new-project-setup-guide/blob/main/src/types/index.ts#L67)

Project with status information

ProjectWithStatus

## Description

Extends the base Project interface with status tracking

## Extends

- [`Project`](Project.md)

## Properties

### id

> **id**: `string`

Defined in: [types/index.ts:37](https://github.com/AutomateAndThrive/new-project-setup-guide/blob/main/src/types/index.ts#L37)

Unique identifier for the project

#### Inherited from

[`Project`](Project.md).[`id`](Project.md#id)

---

### name

> **name**: `string`

Defined in: [types/index.ts:39](https://github.com/AutomateAndThrive/new-project-setup-guide/blob/main/src/types/index.ts#L39)

Human-readable name of the project

#### Inherited from

[`Project`](Project.md).[`name`](Project.md#name)

---

### description

> **description**: `string`

Defined in: [types/index.ts:41](https://github.com/AutomateAndThrive/new-project-setup-guide/blob/main/src/types/index.ts#L41)

Detailed description of the project's purpose and scope

#### Inherited from

[`Project`](Project.md).[`description`](Project.md#description)

---

### owner

> **owner**: [`User`](User.md)

Defined in: [types/index.ts:43](https://github.com/AutomateAndThrive/new-project-setup-guide/blob/main/src/types/index.ts#L43)

The user who owns this project

#### Inherited from

[`Project`](Project.md).[`owner`](Project.md#owner)

---

### collaborators

> **collaborators**: [`User`](User.md)[]

Defined in: [types/index.ts:45](https://github.com/AutomateAndThrive/new-project-setup-guide/blob/main/src/types/index.ts#L45)

List of users who collaborate on this project

#### Inherited from

[`Project`](Project.md).[`collaborators`](Project.md#collaborators)

---

### createdAt

> **createdAt**: `Date`

Defined in: [types/index.ts:47](https://github.com/AutomateAndThrive/new-project-setup-guide/blob/main/src/types/index.ts#L47)

Timestamp when the project was created

#### Inherited from

[`Project`](Project.md).[`createdAt`](Project.md#createdat)

---

### updatedAt

> **updatedAt**: `Date`

Defined in: [types/index.ts:49](https://github.com/AutomateAndThrive/new-project-setup-guide/blob/main/src/types/index.ts#L49)

Timestamp when the project was last modified

#### Inherited from

[`Project`](Project.md).[`updatedAt`](Project.md#updatedat)

---

### status

> **status**: [`ProjectStatus`](../type-aliases/ProjectStatus.md)

Defined in: [types/index.ts:69](https://github.com/AutomateAndThrive/new-project-setup-guide/blob/main/src/types/index.ts#L69)

Current status of the project in its lifecycle
