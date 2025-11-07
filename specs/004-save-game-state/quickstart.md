# Quickstart: Save and Resume Game State

This guide outlines the files and classes to be created or modified to implement the feature according to the technical plan.

## 1. Database Layer (Drift)

- **Action**: Create a new database table and a Data Access Object (DAO).
- **File**: `lib/core/database/app_database.dart` (Create if it doesn't exist).
- **Details**:
  - Define a `GameStates` table class extending `drift.Table`.
  - Add `board` (TextColumn) and `score` (IntColumn) fields.
  - Define a `GameStateDao` with methods: `getLatestGameState`, `saveGameState`, `clearGameStates`.
  - Add the new table and DAO to the `@DriftDatabase` annotation.

## 2. Domain Layer

- **Action**: Define the core business entity and repository interface.
- **Files**:
  - `lib/features/game/domain/entities/game_board.dart` (New)
  - `lib/features/game/domain/repositories/game_repository.dart` (New or Modify)
- **Details**:
  - Create an immutable `GameBoard` class with `tiles` and `score` fields.
  - Define the `GameRepository` interface with `loadBoard`, `saveBoard`, and `clearBoard` methods.

## 3. Data Layer

- **Action**: Implement the repository to connect the domain layer to the database.
- **File**: `lib/features/game/data/repositories/game_repository_impl.dart` (New).
- **Details**:
  - Implement the `GameRepository` interface.
  - Inject the `GameStateDao`.
  - Implement the methods, handling the serialization/deserialization of the `GameBoard` to/from the Drift data entity.

## 4. Presentation Layer (BLoC)

- **Action**: Integrate the save/load logic into the `GameBloc`.
- **File**: `lib/features/game/presentation/bloc/game_bloc.dart` (Modify).
- **Details**:
  - Inject `GameRepository`.
  - On game start, call `loadBoard()` to check for a saved state.
  - After each successful move, call `saveBoard()` with the updated state.
  - On a "New Game" event, call `clearBoard()`.

## 5. Dependency Injection

- **Action**: Register the new DAO and Repository with `get_it`.
- **File**: `lib/core/di/injection_container.dart` (or similar).
- **Details**:
  - Register `GameStateDao` and `GameRepository` for dependency injection.

## 6. Build Runner

- **Action**: Run the build runner to generate the necessary Drift code.
- **Command**: `dart run build_runner build --delete-conflicting-outputs`