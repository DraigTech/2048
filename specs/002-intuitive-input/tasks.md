# Tasks: Intuitive Input Methods

**Input**: Design documents from `/Users/hiep.nguyen/StudioProjects/2048/specs/002-intuitive-input/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, quickstart.md

**Tests**: The examples below include test tasks. Tests are OPTIONAL - only include them if explicitly requested in the feature specification.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Single project**: `lib/`, `test/` at repository root

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [ ] T001 Create the file `lib/features/game/presentation/widgets/input_handler.dart`.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

- [ ] T002 [US1] Implement `GestureDetector` in `lib/features/game/presentation/widgets/input_handler.dart` to detect swipe gestures.
- [ ] T003 [US1] In `input_handler.dart`, map swipe gestures to a new `GameMoveEvent` and dispatch it to the `GameBloc`.
- [ ] T004 [US2] Implement `RawKeyboardListener` in `lib/features/game/presentation/widgets/input_handler.dart` to listen for keyboard events.
- [ ] T005 [US2] In `input_handler.dart`, map arrow and WASD key presses to the `GameMoveEvent` and dispatch it to the `GameBloc`.
- [ ] T006 Update `lib/features/game/presentation/bloc/game_event.dart` to include a `GameMoveEvent` that takes a `MoveDirection` enum.
- [ ] T007 Update `lib/features/game/presentation/bloc/game_bloc.dart` to handle the `GameMoveEvent` and trigger the appropriate game logic.
- [ ] T008 In the widget that builds the game board, remove the on-screen button controls.
- [ ] T009 Wrap the `GameBoard` widget with the `InputHandler` widget in the main game screen.

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - Mobile Swipe Controls (Priority: P1) 🎯 MVP

**Goal**: Players can control the game using swipe gestures on mobile devices.

**Independent Test**: On a mobile device or emulator, the game is fully playable using only swipe gestures.

### Implementation for User Story 1

- [ ] T010 [US1] Verify that swipe gestures (up, down, left, right) correctly move the tiles on a mobile device or emulator.

**Checkpoint**: At this point, User Story 1 should be fully functional and testable independently

---

## Phase 4: User Story 2 - Desktop Keyboard Controls (Priority: P2)

**Goal**: Players can control the game using the keyboard on desktop and web platforms.

**Independent Test**: On a desktop or web build, the game is fully playable using the arrow and WASD keys.

### Implementation for User Story 2

- [ ] T011 [US2] Verify that arrow keys and WASD keys correctly move the tiles on a desktop or web build.

**Checkpoint**: At this point, User Stories 1 AND 2 should both work independently

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 2 (P2)**: Can start after Foundational (Phase 2) - No dependencies on other stories

### Within Each User Story

- Core implementation before integration
- Story complete before moving to next priority

### Parallel Opportunities

- Once Foundational phase completes, all user stories can start in parallel (if team capacity allows)

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
