# Implementation Plan: Persistent Game Modes

**Feature Branch**: `006-persistent-game-modes`
**Feature Spec**: [spec.md](./spec.md)
**Status**: Planning Complete

---

## Technical Context

-   **Project Type**: Mobile (Flutter)
-   **Primary Language**: Dart
-   **Architecture**: Clean Architecture, Feature-based Modules
-   **State Management**: `flutter_bloc` (BLoC)
-   **Database**: `drift`
-   **Dependency Injection**: `get_it`

### Affected Components

-   **Data Layer**:
    -   `lib/core/database/app_database.dart` & `tables.dart`: To define the new `GameModeSettings` table and add a `boardSize` column to the `GameStates` table.
    -   `lib/core/database/daos/`: A new `GameModeSettingsDao` will be created. The existing `GameStatesDao` will be modified.
    -   `lib/features/settings/data/repositories/settings_repository_impl.dart`: To add methods for getting/setting the active game mode.
    -   `lib/features/game/data/repositories/game_repository_impl.dart`: To modify `getGameState()` and `saveGameState()` to be aware of `boardSize`.

-   **Domain Layer**:
    -   `lib/features/settings/domain/entities/`: A new `GameMode` entity will be created.
    -   `lib/features/settings/domain/repositories/settings_repository.dart`: To update the repository interface.
    -   `lib/features/game/domain/entities/`: The `GameState` entity will be updated.

-   **Presentation Layer**:
    -   `lib/features/settings/presentation/bloc/`: `SettingsBloc`, `SettingsState`, and `SettingsEvent` will be updated to manage game mode selection.
    -   `lib/features/settings/presentation/widgets/settings_dialog.dart`: To add a UI element (e.g., `DropdownButton`) for mode selection and trigger events.
    -   `lib/features/game/presentation/bloc/`: `GameBloc` will be updated to listen for reset events from `SettingsBloc` and to load games based on the current mode.

---

## Constitution Check (Pre-Design)

-   [X] **I. Technology Stack**: The plan uses the established stack (Flutter, BLoC, Drift, get_it) correctly.
-   [X] **II. Architecture**: The plan respects the feature-based modular architecture, making changes within the `core`, `features/game`, and `features/settings` modules as appropriate.
-   [X] **III. Code Style & Quality**: All new code will adhere to the linting rules in `analysis_options.yaml`.
-   [X] **IV. Testing**: New logic in BLoCs and repositories will be covered by unit tests.

**Result**: The plan is compliant with the project constitution.

---

## Phase 0: Research

Research was conducted to confirm best practices for the required changes.

**Output**: [research.md](./research.md)

---

## Phase 1: Design & Contracts

The data model and developer quickstart guide have been generated. No remote API contracts are needed as this is a local mobile application feature.

**Outputs**:
-   **Data Model**: [data-model.md](./data-model.md)
-   **Quickstart Guide**: [quickstart.md](./quickstart.md)
-   **API Contracts**: N/A

---

## Phase 2: Implementation Tasks

The implementation will be broken down into the following sequential tasks:

1.  **Data Layer**:
    -   Task 2.1: Modify `GameStates` and add `GameModeSettings` tables in `lib/core/database/tables.dart`.
    -   Task 2.2: Create `GameModeSettingsDao` and update `GameStatesDao`.
    -   Task 2.3: Run `build_runner` to generate new database code.
    -   Task 2.4: Implement the new methods in `SettingsRepository` and `GameRepository`.

2.  **Domain Layer**:
    -   Task 2.5: Create the `GameMode` entity and update the `GameState` entity.
    -   Task 2.6: Update the `SettingsRepository` and `GameRepository` interfaces.

3.  **Presentation Layer (Settings)**:
    -   Task 2.7: Update `SettingsBloc` to manage `GameMode` state.
    -   Task 2.8: Add a `DropdownButton` to `settings_dialog.dart` for mode selection.
    -   Task 2.9: Implement the confirmation `AlertDialog` logic when changing modes mid-game.

4.  **Presentation Layer (Game)**:
    -   Task 2.10: Update `GameBloc` to handle the `GameResetEvent` from `SettingsBloc`.
    -   Task 2.11: Modify the `_onGameStarted` logic in `GameBloc` to check the saved game's `boardSize` against the current setting.

5.  **Testing**:
    -   Task 2.12: Write unit tests for the new logic in `SettingsBloc`, `GameBloc`, and the repositories.
    -   Task 2.13: Perform functional testing as described in `quickstart.md`.

---

## Constitution Check (Post-Design)

-   [X] **I. Technology Stack**: The design artifacts are consistent with the project's technology stack.
-   [X] **II. Architecture**: The data model and proposed component changes align with the established architecture.
-   [X] **III. Code Style & Quality**: The code snippets in the data model follow project style.
-   [X] **IV. Testing**: The plan includes a clear path for unit and functional testing.

**Result**: The design is compliant with the project constitution. Planning is complete.