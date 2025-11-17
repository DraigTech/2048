# Feature Specification: Persistent Game Modes

**Feature Branch**: `006-persistent-game-modes`
**Created**: 2025-11-17
**Status**: Draft
**Input**: User description: "This feature enhances player engagement by offering varied and persistent difficulty levels through selectable game modes. Players seeking new challenges beyond the classic 4x4 grid can now set their preferred complexity, solving the problem of static gameplay and adding significant replay value. Users will interact with this feature in the main settings menu, where a new "Game Mode" option will allow them to choose between 4x4, 5x5, or 6x6. Crucially, if a game is in progress, changing the mode will prompt the user with a confirmation dialog, warning them that their current game will be reset. Once confirmed, this selection is saved locally and persists across sessions, becoming the default for any new game started. A successful outcome is a seamless experience where the game defaults to the user's chosen mode, correctly adjusting the number of new tiles per move (1, 2, or 3, respectively) to ensure a balanced challenge. This allows players to master distinct game modes, with high scores now being tracked independently for each mode, enhancing the sense of achievement without the inconvenience of selecting a size before every game."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Select and Persist Game Mode (Priority: P1)

As a player, I want to choose a game mode (grid size) from the settings menu so that I can play on a board that matches my desired level of challenge. I expect my choice to be saved and automatically used for all future games until I change it again.

**Why this priority**: This is the core of the feature, delivering the primary value of varied and persistent difficulty.

**Independent Test**: Can be tested by opening the app for the first time, setting a game mode (e.g., 5x5), closing and reopening the app, and starting a new game to verify it starts with a 5x5 grid.

**Acceptance Scenarios**:

1.  **Given** a fresh install of the app, **When** the user navigates to Settings, **Then** the "Game Mode" is defaulted to "4x4".
2.  **Given** the user is in the Settings menu, **When** they select the "5x5" game mode, **Then** the selection is saved as the new default.
3.  **Given** the user has previously selected "5x5" as their game mode, **When** they close and restart the application and start a new game, **Then** the game board is a 5x5 grid.

---

### User Story 2 - Handle Mode Change During Active Game (Priority: P2)

As a player, if I try to change the game mode while a game is in progress, I want to be warned that my current game will be lost and asked to confirm my choice, so that I don't accidentally lose my score.

**Why this priority**: This prevents a negative user experience (accidental data loss) and is a critical part of a smooth user journey.

**Independent Test**: Can be tested by starting a game, making a few moves, then going to settings, changing the game mode, and verifying the confirmation dialog appears and functions correctly.

**Acceptance Scenarios**:

1.  **Given** a game is in progress, **When** the user navigates to Settings and selects a different game mode, **Then** a confirmation dialog is displayed.
2.  **Given** the confirmation dialog is displayed, **When** the user cancels the action, **Then** they are returned to the settings screen, the game mode is not changed, and the current game remains active.
3.  **Given** the confirmation dialog is displayed, **When** the user confirms the action, **Then** the new game mode is saved, and the game board is reset to a new game with the selected grid size.

---

### User Story 3 - Track High Scores Per Mode (Priority: P3)

As a player, I want my high scores to be tracked separately for each game mode, so that I can track my personal best for each difficulty level and feel a sense of achievement for mastering each one.

**Why this priority**: This adds significant replay value and enhances the sense of accomplishment, directly addressing the goal of increasing player engagement.

**Independent Test**: Can be tested by playing a 4x4 game and setting a high score, then playing a 5x5 game and setting a different high score, and verifying that both scores are saved and displayed correctly for their respective modes.

**Acceptance Scenarios**:

1.  **Given** the user has no high score for the "5x5" mode, **When** they complete a "5x5" game with a score of 1024, **Then** the high score for "5x5" is recorded as 1024.
2.  **Given** the user has a high score of 2048 for the "4x4" mode, **When** they complete a "5x5" game with a score of 1024, **Then** the high score for "4x4" remains 2048 and the high score for "5x5" is 1024.

---

### Edge Cases

-   What happens if the user tries to change the mode while the app is in a game-over state? (Expected: Should behave as if a game is in progress, prompting confirmation to reset).
-   How does the system handle a corrupted or missing settings file on startup? (Expected: Should default to 4x4 mode gracefully).

## Requirements *(mandatory)*

### Functional Requirements

-   **FR-001**: The system MUST provide a "Game Mode" option in the main settings menu.
-   **FR-002**: The "Game Mode" option MUST allow users to select one of the following grid sizes: "4x4", "5x5", or "6x6".
-   **FR-003**: The system MUST save the user's selected game mode locally on their device.
-   **FR-004**: The saved game mode MUST persist across application sessions (i.e., closing and reopening the app).
-   **FR-005**: When a new game is initiated, the system MUST use the currently saved game mode to determine the grid size.
-   **FR-006**: If a user attempts to change the game mode while a game is active (not in a game-over or pre-start state), the system MUST display a confirmation dialog.
-   **FR-007**: The confirmation dialog MUST warn the user that their current game progress and score will be permanently lost.
-   **FR-008**: If the user confirms the change, the system MUST reset the current game and apply the newly selected game mode.
-   **FR-009**: The number of new tiles generated per move MUST be 1 for 4x4, 2 for 5x5, and 3 for 6x6 mode.
-   **FR-010**: The system MUST store and retrieve high scores independently for each game mode.

### Key Entities *(include if feature involves data)*

-   **GameModeSetting**: Represents the user's chosen grid size preference. Attributes: `mode` (e.g., '4x4', '5x5', '6x6').
-   **HighScore**: Represents a player's highest achieved score. Attributes: `score` (integer), `mode` (e.g., '4x4', '5x5', '6x6').

## Success Criteria *(mandatory)*

### Measurable Outcomes

-   **SC-001**: When a user starts a new game, it defaults to their last selected game mode in 100% of cases (assuming no data corruption).
-   **SC-002**: High scores are correctly recorded and displayed for the corresponding game mode in 100% of test cases.
-   **SC-003**: 99% of users who change the game mode mid-game are presented with the confirmation dialog.
-   **SC-004**: The number of new tiles generated per move correctly corresponds to the active game mode (4x4:1, 5x5:2, 6x6:3) in all instances.