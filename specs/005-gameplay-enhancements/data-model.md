# Data Model: Gameplay Enhancements

**Feature**: Gameplay Enhancements
**Date**: 2025-11-12

This document defines the data entities required for the Gameplay Enhancements feature.

## 1. AudioSettings

Represents the user's persisted preferences for in-game audio. This entity will be stored locally on the user's device using the Drift database.

### Attributes

| Name                   | Type    | Description                                     | Constraints      |
| ---------------------- | ------- | ----------------------------------------------- | ---------------- |
| `id`                   | Integer | A unique identifier for the settings record.    | Primary Key      |
| `isMusicEnabled`       | Boolean | Whether the background music is enabled.        | Not Null, Default: `true` |
| `isSoundEffectsEnabled`| Boolean | Whether the sound effects (e.g., move, merge) are enabled. | Not Null, Default: `true` |

### State Transitions

The `AudioSettings` entity is created with default `true` values if it doesn't exist. Subsequently, its boolean fields are updated based on user interactions in the settings UI. There are no other complex state transitions.