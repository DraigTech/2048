# Data Model

This document outlines the data entities for the 2048 game, based on the feature specification.

## GameBoard

Represents the state of the 4x4 grid.

- **Fields**:
    - `tiles`: A 2D array (4x4) of integers representing the tile values at each position. `0` indicates an empty cell.
- **State Transitions**:
    - The board state is updated after every valid player move (swipe).
    - A new tile is added to the board after each move.

## Player

Represents the user playing the game.

- **Fields**:
    - `score`: The player's current score in the game.
    - `highScore`: The player's highest score across all games.

## Score

Represents the player's score for the current game.

- **Fields**:
    - `value`: An integer representing the current score.
- **Validation Rules**:
    - The score must be a non-negative integer.
    - The score is updated by adding the value of newly merged tiles.

## HighScore

Represents the highest score achieved by the player.

- **Fields**:
    - `value`: An integer representing the high score.
- **Validation Rules**:
    - The high score must be a non-negative integer.
    - It is only updated when a game ends with a score greater than the current high score.
- **Persistence**:
    - The high score is persisted locally on the user's device using Drift.