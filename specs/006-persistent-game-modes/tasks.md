# Task List: Persistent Game Modes

**Purpose**: To provide a detailed, dependency-ordered checklist of tasks for implementing the Persistent Game Modes feature.

---

## Phase 1: Setup (Database Schema)

These tasks set up the foundational database changes.

- [ ] T001 Define `GameModeSettings` table and add `boardSize` column to `GameStates` table in `lib/core/database/tables/game_states.dart`.
- [ ] T002 Create `GameModeSettingsDao` in a new file: `lib/core/database/daos/game_mode_settings_dao.dart`.
- [ ] T003 Update `AppDatabase` in `lib/core/database/app_database.dart` to include the new table, DAO, and a schema version bump.
- [ ] T004 Run `dart run build_runner build --delete-conflicting-outputs` to generate the required Drift migration and data classes.

---

## Phase 2: Foundational Layer (Domain & Data Implementation)

These tasks create the necessary abstractions and data handling logic that all user stories will depend on.

- [ ] T005 Create the `GameMode` entity in `lib/features/settings/domain/entities/game_mode.dart`.
- [ ] T006 Update the `SettingsRepository` interface in `lib/features/settings/domain/repositories/settings_repository.dart` with methods to get and set the game mode.
- [ ] T007 [P] Update the `GameRepository` interface in `lib/features/game/domain/repositories/game_repository.dart` to handle `boardSize` for game state and high score methods.
- [ ] T008 Implement the new `SettingsRepository` methods in `lib/features/settings/data/repositories/settings_repository_impl.dart`.
- [ ] T009 [P] Implement the updated `GameRepository` methods in `lib/features/game/data/repositories/game_repository_impl.dart`.

---

## Phase 3: User Story 1 - Select and Persist Game Mode

**Goal**: A player can select a game mode (4x4, 5x5, 6x6) in the settings, and their choice is saved for future sessions.

**Independent Test**: Set the game mode to 5x5, restart the app, start a new game, and verify the grid is 5x5.

- [ ] T010 [US1] Update `SettingsState` and `SettingsEvent` in `lib/features/settings/presentation/bloc/settings_bloc.dart` to manage loading and changing the `GameMode`.
- [ ] T011 [US1] Implement the core logic in `SettingsBloc` at `lib/features/settings/presentation/bloc/settings_bloc.dart` to load the initial mode and save changes via the repository.
- [ ] T012 [P] [US1] Add a `DropdownButton` widget to `lib/features/settings/presentation/widgets/settings_dialog.dart` to display the available game modes and dispatch events on change.
- [ ] T013 [US1] Modify `GameBloc` in `lib/features/game/presentation/bloc/game_bloc.dart` to use the `boardSize` from the current settings when starting a new game.

---

## Phase 4: User Story 2 - Handle Mode Change During Active Game

**Goal**: A player is warned with a confirmation dialog before their active game is reset due to a mode change.

**Independent Test**: Start a game, make moves, go to settings, change the mode, and verify the confirmation dialog appears and functions correctly.

- [ ] T014 [US2] Update `SettingsBloc` in `lib/features/settings/presentation/bloc/settings_bloc.dart` to check if a game is in progress before changing the mode.
- [ ] T015 [US2] Implement the `showDialog` logic in `lib/features/settings/presentation/widgets/settings_dialog.dart` to show a confirmation `AlertDialog`.
- [ ] T016 [US2] Update `SettingsBloc` at `lib/features/settings/presentation/bloc/settings_bloc.dart` to dispatch a `GameResetEvent` upon user confirmation.
- [ ] T017 [US2] Add a handler for the `GameResetEvent` in `GameBloc` at `lib/features/game/presentation/bloc/game_bloc.dart` to reset the game state.

---

## Phase 5: User Story 3 - Track High Scores Per Mode

**Goal**: High scores are saved and displayed independently for each game mode.

**Independent Test**: Set a high score in 4x4 mode. Switch to 6x6 mode and set a different high score. Switch back to 4x4 and verify the original high score is displayed.

- [ ] T018 [US3] Update `GameStatesDao` in `lib/core/database/daos/game_states_dao.dart` to filter `watchBestScore` and other relevant queries by `boardSize`.
- [ ] T019 [US3] Ensure the `GameRepository` implementation at `lib/features/game/data/repositories/game_repository_impl.dart` passes the `boardSize` to the DAO.
- [ ] T020 [US3] Update `GameBloc` at `lib/features/game/presentation/bloc/game_bloc.dart` to correctly manage and display the high score for the currently active game mode.

---

## Phase 6: Polish & Finalization

- [ ] T021 Review all new and modified files for code quality, documentation, and adherence to the project's linting rules (`analysis_options.yaml`).
- [ ] T022 Run `flutter analyze` to identify and fix any static analysis issues.
- [ ] T023 Run `flutter test --update-goldens` to ensure all existing and new tests pass.
- [ ] T024 Perform a full manual test of all user stories and edge cases as described in `quickstart.md`.

---

## Dependencies & Parallel Execution

-   **Dependencies**: `Phase 1` -> `Phase 2` -> `Phase 3 (US1)`.
-   `Phase 4 (US2)` depends on `Phase 3 (US1)`.
-   `Phase 5 (US3)` depends on `Phase 3 (US1)`.
-   **Parallelism**:
    -   `Phase 4 (US2)` and `Phase 5 (US3)` can be implemented in parallel after `Phase 3 (US1)` is complete.
    -   Within phases, tasks marked with `[P]` can be worked on concurrently.

## Implementation Strategy

The implementation will follow an incremental, user-story-based approach.
1.  **MVP**: The Minimum Viable Product is the completion of **Phase 3 (User Story 1)**. This delivers the core functionality of selecting and persisting a game mode.
2.  **Incremental Delivery**: Subsequent phases (US2 and US3) will be implemented next, building upon the MVP to add the confirmation dialog and per-mode high score tracking.
3.  **Completion**: The feature is considered complete after all tasks, including the "Polish & Finalization" phase, are checked off.
