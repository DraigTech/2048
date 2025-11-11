# Data Model: Save and Resume Game State

**Version**: 1.0
**Date**: 2025-11-07

This document outlines the data structures required to implement the save/resume feature.

## 1. Domain Model

This is the primary entity used within the application's business logic (BLoC).

### `GameBoard`

Represents the state of the game at a given point in time.

| Field | Type | Description | Rules |
|---|---|---|---|
| `tiles` | `List<List<int>>` | A 4x4 grid representing the board. Each `int` is the value of the tile. `0` represents an empty cell. | Must be a 4x4 list. Tile values must be powers of 2. |
| `score` | `int` | The player's current score. | Must be a non-negative integer. |

## 2. Data Persistence Model (Drift)

This model is used for storing the game state in the local database.

### `GameStates` Table

| Column | Drift Type | Description | Notes |
|---|---|---|---|
| `id` | `IntColumn` | Primary Key. | Auto-incrementing. |
| `board` | `TextColumn` | A JSON string representation of the `GameBoard.tiles` field. | Serialized using `jsonEncode`. |
| `score` | `IntColumn` | The current score, corresponding to `GameBoard.score`. | |
| `createdAt` | `DateTimeColumn` | Timestamp of when the state was saved. | Used for retrieving the latest save. |