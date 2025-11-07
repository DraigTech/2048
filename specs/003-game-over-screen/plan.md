# Implementation Plan: Game Over Screen

**Feature Branch**: `003-game-over-screen`  
**Created**: 2025-11-06  
**Status**: Draft

## Technical Context

- **Framework**: Flutter
- **Language**: Dart
- **State Management**: flutter_bloc
- **Architecture**: The implementation will follow the existing BLoC (Business Logic Component) architecture. The game's state will be managed by a `GameBloc`, which will be responsible for handling game logic and emitting states to the UI. The UI will be built with Flutter widgets and will react to state changes from the `GameBloc`.

## Constitution Check

- **Adherence to Conventions**: The plan adheres to the existing project conventions by using Flutter, Dart, and flutter_bloc, as established in the project.
- **Library Usage**: The plan uses the existing `flutter_bloc` library and does not introduce new dependencies.
- **Style and Structure**: The plan is consistent with the existing BLoC pattern and the overall project structure.

## Phase 0: Research

No research is required for this feature, as the technology stack and architecture are well-defined within the project.

## Phase 1: Design & Contracts

### Data Model

The `GameState` will be updated to include a flag indicating the game-over condition.

- **GameState**: 
  - `board`: The game board.
  - `score`: The current score.
  - `isGameOver`: A boolean flag that is `true` if the game is over, and `false` otherwise.

### Contracts

No external API contracts are required for this feature.

### Quickstart

To run the application, use the following command:

```bash
flutter run
```

## Phase 2: Implementation Tasks

### Task 1: Update GameBloc State

- **File**: `lib/features/game/presentation/bloc/game_bloc.dart`
- **Change**: Add the `isGameOver` boolean property to the `GameState` class.

### Task 2: Implement Game Over Logic

- **File**: `lib/features/game/presentation/bloc/game_bloc.dart`
- **Change**: 
  - Create a new event `CheckGameOver`.
  - In the `GameBloc`, handle the `CheckGameOver` event. This will involve checking the game board for any available moves. If no moves are available, emit a new `GameState` with `isGameOver` set to `true`.
  - After each move, dispatch the `CheckGameOver` event.

### Task 3: Display Game Over UI

- **File**: `lib/features/game/presentation/screens/game_screen.dart`
- **Change**: 
  - Wrap the main game widget in a `BlocListener` that listens to the `GameBloc`.
  - When the `GameState` has `isGameOver` set to `true`, display a dialog or an overlay.
  - The dialog will show the final score and a "Play Again" button.

### Task 4: Implement Replay Functionality

- **File**: `lib/features/game/presentation/screens/game_screen.dart` & `lib/features/game/presentation/bloc/game_bloc.dart`
- **Change**: 
  - Create a `NewGame` event in the `GameBloc`.
  - The "Play Again" button will dispatch the `NewGame` event to the `GameBloc`.
  - The `GameBloc` will handle the `NewGame` event by resetting the game board, score, and `isGameOver` flag.