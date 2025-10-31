# Tasks: 2048 Puzzle Game

**Input**: Design documents from `/Users/hiep.nguyen/StudioProjects/2048/specs/001-2048-puzzle-game/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2)
- Include exact file paths in descriptions

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [x] T001 Create new Flutter project
- [x] T002 Add dependencies to `pubspec.yaml`: `flame`, `bloc`, `flutter_bloc`, `get_it`, `go_router`, `drift`, `path_provider`, `path`
- [x] T003 Add dev dependencies to `pubspec.yaml`: `build_runner`, `drift_dev`
- [x] T004 Run `flutter pub get`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

- [x] T005 Create project structure in `lib/` as per `plan.md`
- [x] T006 [P] Configure dependency injection in `lib/core/di/injection.dart`
- [x] T007 [P] Configure routing in `lib/core/routing/router.dart`
- [x] T008 [P] Configure localization in `lib/core/l10n/`

---

## Phase 3: User Story 1 - Core Game Loop (Priority: P1) 🎯 MVP

**Goal**: A player can start a new game, move tiles, see them merge, and the score update.

**Independent Test**: A user can play a full game until they win or lose.

### Implementation for User Story 1

- [x] T009 [US1] Define `GameBoard` and `Tile` entities in `lib/features/game/domain/entities/`
- [x] T010 [US1] Define `GameRepository` interface in `lib/features/game/domain/repositories/game_repository.dart`
- [x] T011 [US1] Implement `MoveTilesUseCase` in `lib/features/game/domain/usecases/move_tiles.dart`
- [x] T012 [US1] Implement `GameBloc` in `lib/features/game/presentation/bloc/game_bloc.dart`
- [x] T013 [US1] Create `GameBoardWidget` in `lib/features/game/presentation/widgets/game_board_widget.dart`
- [x] T014 [US1] Create `TileWidget` in `lib/features/game/presentation/widgets/tile_widget.dart`
- [x] T015 [US1] Create `GameScreen` in `lib/features/game/presentation/screens/game_screen.dart`
- [x] T016 [US1] Implement `GameRepositoryImpl` in `lib/features/game/data/repositories/game_repository_impl.dart`

---

## Phase 4: User Story 2 - High Score Tracking (Priority: P2)

**Goal**: The player's high score is saved and displayed.

**Independent Test**: A player can finish a game and see their high score update if they beat their previous record.

### Implementation for User Story 2

- [x] T017 [US2] Define `HighScore` entity in `lib/features/game/domain/entities/`
- [x] T018 [US2] Update `GameRepository` with `getHighScore` and `saveHighScore` methods in `lib/features/game/domain/repositories/game_repository.dart`
- [x] T019 [US2] Implement `GetHighScoreUseCase` and `SaveHighScoreUseCase` in `lib/features/game/domain/usecases/`
- [x] T020 [US2] Define `HighScore` table in `lib/features/game/data/datasources/local/database.dart`
- [x] T021 [US2] Implement high score logic in `GameRepositoryImpl` in `lib/features/game/data/repositories/game_repository_impl.dart`
- [x] T022 [US2] Update `GameBloc` to handle high score state in `lib/features/game/presentation/bloc/game_bloc.dart`
- [x] T023 [US2] Display the high score in `GameScreen` in `lib/features/game/presentation/screens/game_screen.dart`

---

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [x] T024 [P] Add animations for tile movements and merges
- [ ] T025 [P] Add sound effects for moves and merges
- [ ] T026 [P] Implement responsive UI for different screen sizes
- [ ] T027 [P] Add unit tests for BLoCs and UseCases

---

## Dependencies & Execution Order

- **User Story 1** is the MVP and has no dependencies on other stories.
- **User Story 2** depends on User Story 1.

## Parallel Opportunities

- Within each user story, data, domain, and presentation layers can be developed in parallel to some extent.
- Polish tasks can be worked on in parallel with feature development.