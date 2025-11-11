# Tasks: Save and Resume Game State

**Version**: 1.0
**Date**: 2025-11-07

This document breaks down the implementation of the "Save and Resume Game State" feature into a series of actionable, dependency-ordered tasks.

## Implementation Strategy

The implementation will be phased to ensure foundational layers are built first. The MVP (Minimum Viable Product) is the completion of Phase 3, which delivers the core user value of saving and resuming a game. Subsequent phases add related functionality.

## Phase 1: Foundational - Database Layer

**Goal**: Set up the local database table and data access object (DAO) using Drift.
**Testability**: This phase can be tested by verifying the database schema is created correctly and the DAO can be instantiated.

- [x] T001 Define the `GameStates` table in `lib/core/database/app_database.dart` as per `data-model.md`.
- [x] T002 Define the `GameStateDao` abstract class with required methods (`getLatestGameState`, `saveGameState`, `clearGameStates`) in `lib/core/database/app_database.dart`.
- [x] T003 Add the `GameStates` table and `GameStateDao` to the `@DriftDatabase` annotation in `lib/core/database/app_database.dart`.
- [x] T004 Run `dart run build_runner build --delete-conflicting-outputs` to generate the necessary Drift code.

## Phase 2: Foundational - Repository Layer

**Goal**: Create the repository to abstract data access from the business logic.
**Testability**: The repository can be unit tested by mocking the `GameStateDao`.

- [x] ~~T005 [P] Create the `GameBoard` domain entity in `lib/features/game/domain/entities/game_board.dart`.~~
- [x] T006 [P] Define the `GameRepository` interface in `lib/features/game/domain/repositories/game_repository.dart`.
- [x] T007 Implement the `GameRepositoryImpl` class in `lib/features/game/data/repositories/game_repository_impl.dart`, ensuring JSON serialization/deserialization logic for the board is included.
- [x] T008 Register `GameStateDao` and `GameRepository` with `get_it` in the main dependency injection file (e.g., `lib/core/di/injection_container.dart`).

## Phase 3: User Story 1 - Seamlessly Continue Game

**Goal**: [US1] Players can resume their game exactly where they left off.
**Testability**: The BLoC can be unit tested with a mocked `GameRepository` to verify that it loads and saves state correctly.

- [x] T009 [US1] Inject `GameRepository` into the `GameBloc` in `lib/features/game/presentation/bloc/game_bloc.dart`.
- [x] T010 [US1] In the `GameBloc`'s initial event handler, implement the logic to call `gameRepository.loadBoard()` and emit a state with the loaded data if it exists.
- [x] T011 [US1] Create `SaveGameEvent` in `lib/features/game/presentation/bloc/game_event.dart`.
- [x] T012 [US1] In `GameBloc`, create a handler `_onSaveGame` for `SaveGameEvent` that calls `repository.saveBoard()` with the current game state.
- [x] T013 [US1] In the main game UI widget (e.g., `game_page.dart`), implement `WidgetsBindingObserver` to listen for app lifecycle changes.
- [x] T014 [US1] When the app state changes to `paused`, dispatch `SaveGameEvent` to the `GameBloc`.

## Phase 4: User Story 2 - Start a New Game

**Goal**: [US2] Players can discard their progress and start a fresh game.
**Testability**: The BLoC can be unit tested to ensure the `clearBoard` method is called on the repository.

- [x] T015 [US2] In the `GameBloc`'s "New Game" event handler, add a call to `gameRepository.clearBoard()` after resetting the BLoC's state.

## Phase 5: Testing and Quality Assurance

**Goal**: Ensure the implementation is robust, bug-free, and adheres to project standards.
**Testability**: N/A (This phase is about writing tests).

- [x] T016 [P] Write unit tests for `GameRepositoryImpl` to cover all methods and edge cases (e.g., database is empty).
- [x] T017 Write unit tests for `GameBloc` to cover the new scenarios: loading, saving on pause, and clearing state.
- [x] T018 Manually review all new and modified files to ensure 100% compliance with the rules in `analysis_options.yaml`.

## Dependencies

- **Phase 2** depends on **Phase 1**.
- **Phase 3** depends on **Phase 2**.
- **Phase 4** depends on **Phase 2**.
- **Phase 5** can be worked on in parallel with other phases (TDD) or done at the end.

## Parallel Execution

- Within Phase 2, T005 and T006 can be done in parallel.
- Within Phase 5, T016 and T017 can be done in parallel.