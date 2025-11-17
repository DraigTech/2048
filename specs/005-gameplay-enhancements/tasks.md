---

description: "Task list for Gameplay Enhancements feature implementation"
---

# Tasks: Gameplay Enhancements

**Input**: Design documents from `/specs/005-gameplay-enhancements/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, quickstart.md

**Tests**: Tests are included as per the plan.md and quickstart.md.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Mobile**: `lib/` for Dart/Flutter code

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [x] T001 Source `background_music.mp3` and add to `assets/audio/`.
- [x] T002 Verify `pubspec.yaml` includes `assets/audio/`.
- [x] T003 Create `lib/features/settings` directory with `domain`, `data`, `presentation` subdirectories.
- [x] T004 Create `lib/features/settings/domain/entities/` and `lib/features/settings/domain/repositories/` directories.
- [x] T005 Create `lib/features/settings/data/repositories/` directory.
- [x] T006 Create `lib/features/settings/presentation/bloc/` directory.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T007 Define `AudioSettings` Drift table in `lib/core/database/tables/audio_settings.dart`.
- [x] T008 Define `AudioSettingsDao` in `lib/core/database/daos/audio_settings_dao.dart`.
- [x] T009 Update `lib/core/database/database.dart` to include `AudioSettings` table and `AudioSettingsDao`.
- [x] T010 Run `dart run build_runner build --delete-conflicting-outputs` for Drift code generation.
- [x] T011 Create `lib/features/settings/domain/entities/audio_settings.dart` for the `AudioSettings` domain entity.
- [x] T012 Create `lib/features/settings/domain/repositories/settings_repository.dart` for the `SettingsRepository` interface.
- [x] T013 Create `lib/features/settings/data/repositories/settings_repository_impl.dart` to implement `SettingsRepository` using `AudioSettingsDao`.
- [x] T014 Create `lib/core/audio/audio_manager.dart` to manage audio playback.
- [x] T015 Register `AudioSettingsDao`, `SettingsRepository` (implementation), and `AudioManager` in `lib/core/di/injection.dart`.

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - Audio Control (Priority: P1) 🎯 MVP

**Goal**: Players can control background music and sound effects, and preferences are persisted.

**Independent Test**: Launch the game, navigate to settings, toggle audio controls, and verify immediate audio changes and persistence after restart.

### Tests for User Story 1

- [x] T016 [P] [US1] Add unit tests for `SettingsBloc` in `test/features/settings/presentation/bloc/settings_bloc_test.dart`.
- [x] T017 [P] [US1] Add widget tests for settings `AlertDialog` in `test/features/settings/presentation/widgets/settings_dialog_test.dart`.

### Implementation for User Story 1

- [x] T018 [US1] Create `lib/features/settings/presentation/bloc/settings_bloc.dart` with `SettingsState` and `SettingsEvent` (LoadSettings, ToggleMusic, ToggleSoundEffects).
- [x] T019 [US1] Implement `SettingsBloc` logic to interact with `SettingsRepository` interface.
- [x] T020 [US1] Initialize `SettingsBloc` with `LoadSettings` event on app startup.
- [x] T021 [US1] Modify `lib/core/audio/audio_manager.dart` to listen to `SettingsBloc` state changes.
- [x] T022 [US1] Implement background music playback in `AudioManager` based on `isMusicEnabled`.
- [x] T023 [US1] Implement sound effects control in `AudioManager` based on `isSoundEffectsEnabled`.
- [x] T024 [US1] Add "Settings" `IconButton` to main game screen widget (e.g., `lib/features/game/presentation/screens/game_page.dart`).
- [x] T025 [US1] Implement settings `AlertDialog` (e.g., `lib/features/settings/presentation/widgets/settings_dialog.dart`) with `BlocProvider` and `BlocBuilder` for `SettingsBloc`.
- [x] T026 [US1] Add `SwitchListTile` for "Background Music" in settings dialog, dispatch `ToggleMusic` event.
- [x] T027 [US1] Add `SwitchListTile` for "Sound Effects" in settings dialog, dispatch `ToggleSoundEffects` event.

**Checkpoint**: At this point, User Story 1 should be fully functional and testable independently

---

## Phase 4: User Story 2 - Game Replay (Priority: P2)

**Goal**: Players can quickly restart the game at any point.

**Independent Test**: Start a game, make moves, tap "Replay" icon, confirm dialog, and verify board reset.

### Tests for User Story 2

- [x] T028 [P] [US2] Add unit tests for `GameBloc` `GameReset` event in `test/features/game/presentation/bloc/game_bloc_test.dart`.
- [x] T029 [P] [US2] Add widget tests for replay button and confirmation dialog in `test/features/game/presentation/screens/game_page_test.dart`.

### Implementation for User Story 2

- [x] T030 [US2] Add "Replay" `IconButton` to main game screen widget.
- [x] T031 [US2] Implement confirmation `AlertDialog` for replay button.
- [x] T032 [US2] Add `GameReset` event to `lib/features/game/presentation/bloc/game_bloc.dart`.
- [x] T033 [US2] Implement `GameReset` event handler in `GameBloc` to reset game state.
- [x] T034 [US2] Dispatch `GameReset` event from replay confirmation dialog.

**Checkpoint**: At this point, User Stories 1 AND 2 should both work independently

---

## Final Phase: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [x] T035 Run `flutter analyze` and fix any linting/analysis issues.
- [x] T036 Ensure all new code adheres to `analysis_options.yaml` rules.
- [x] T037 Verify edge cases (replay during game over, audio lifecycle management).

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - User stories can then proceed in parallel (if staffed)
  - Or sequentially in priority order (P1 → P2 → P3)
- **Polish (Final Phase)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 2 (P2)**: Can start after Foundational (Phase 2) - May integrate with US1 but should be independently testable

### Within Each User Story

- Tests (if included) MUST be written and FAIL before implementation
- Models before services
- Services before endpoints
- Core implementation before integration
- Story complete before moving to next priority

### Parallel Opportunities

- All Setup tasks marked [P] can run in parallel
- All Foundational tasks marked [P] can run in parallel (within Phase 2)
- Once Foundational phase completes, all user stories can start in parallel (if team capacity allows)
- All tests for a user story marked [P] can run in parallel
- Models within a story marked [P] can run in parallel
- Different user stories can be worked on in parallel by different team members

---

## Parallel Example: User Story 1

```bash
# Launch all tests for User Story 1 together:
Task: "Add unit tests for `SettingsBloc` in `test/features/settings/presentation/bloc/settings_bloc_test.dart`"
Task: "Add widget tests for settings `AlertDialog` in `test/features/settings/presentation/widgets/settings_dialog_test.dart`"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Test User Story 1 independently
5. Deploy/demo if ready

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add User Story 1 → Test independently → Deploy/Demo (MVP!)
3. Add User Story 2 → Test independently → Deploy/Demo
4. Each story adds value without breaking previous stories

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: User Story 1
   - Developer B: User Story 2
3. Stories complete and integrate independently

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Verify tests fail before implementing
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Avoid: vague tasks, same file conflicts, cross-story dependencies that break independence
