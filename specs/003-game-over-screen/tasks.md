# Tasks for: Game Over Screen

**Feature Branch**: `003-game-over-screen`

## Phase 1: Foundational

- [ ] T001 Update `GameState` to include `isGameOver` in `lib/features/game/presentation/bloc/game_state.dart`.
- [ ] T002 Add `CheckGameOver` and `NewGame` events to `lib/features/game/presentation/bloc/game_event.dart`.

## Phase 2: User Story 1 - Game Over Notification

**Goal**: When the board is full and no more moves are possible, the game over screen is displayed with the final score.

**Independent Test**: Can be tested by setting up a board with no possible moves and verifying that the game over screen appears with the correct score.

- [ ] T003 [US1] Implement game over detection logic in `GameBloc` in `lib/features/game/presentation/bloc/game_bloc.dart`.
- [ ] T004 [US1] Dispatch `CheckGameOver` after each move in `GameBloc` in `lib/features/game/presentation/bloc/game_bloc.dart`.
- [ ] T005 [US1] Display the "Game Over" dialog in `GameScreen` in `lib/features/game/presentation/screens/game_screen.dart`.

## Phase 3: User Story 2 - Replay Game

**Goal**: From the game over screen, the player can start a new game.

**Independent Test**: Can be tested by clicking the "Play Again" button on the game over screen and verifying that a new game starts.

- [ ] T006 [US2] Implement `NewGame` event handler in `GameBloc` to reset the game state in `lib/features/game/presentation/bloc/game_bloc.dart`.
- [ ] T007 [US2] Add "Play Again" button to the "Game Over" dialog and connect it to dispatch the `NewGame` event in `lib/features/game/presentation/screens/game_screen.dart`.

## Dependencies

- User Story 2 depends on User Story 1.

## Parallel Execution

- Within each user story, tasks should be completed in order.

## Implementation Strategy

The implementation will follow an MVP approach, starting with User Story 1 to deliver the core game over functionality, followed by User Story 2 to add the replay feature.