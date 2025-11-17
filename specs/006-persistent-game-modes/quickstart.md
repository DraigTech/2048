# Quickstart: Persistent Game Modes

**Purpose**: To provide a quick guide for developers to run and functionally test the persistent game modes feature.

---

### 1. Prerequisites

-   Ensure you are on the correct feature branch: `006-persistent-game-modes`.
-   Make sure all dependencies are installed by running `flutter pub get`.

---

### 2. Generate Database Code

Because the database schema has changed (a new table and a modified table), you must run the code generator.

From the root of the project, run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

This will update the Drift database code to reflect the changes in `data-model.md`.

---

### 3. Run the Application

Launch the application on an emulator, simulator, or physical device as you normally would.

---

### 4. Functional Testing Steps

#### Test Case 1: Change and Persist Game Mode

1.  Tap the **Settings** icon on the main screen.
2.  In the settings dialog, locate the **"Game Mode"** dropdown.
3.  Change the selection from the default "4x4" to **"5x5"**.
4.  Close the settings dialog.
5.  Close and completely restart the application.
6.  Start a new game by tapping **"New Game"**.
7.  **Verify**: The game board is a 5x5 grid.

#### Test Case 2: Handle Mode Change During an Active Game

1.  Start a new game (it should be 5x5 from the previous test).
2.  Make a few moves on the board.
3.  Tap the **Settings** icon.
4.  Change the "Game Mode" dropdown to **"6x6"**.
5.  **Verify**: A confirmation dialog appears, warning you that your progress will be lost.
6.  Tap **"Cancel"**.
7.  **Verify**: The dialog closes, the game mode remains "5x5", and your game is still active.
8.  Change the "Game Mode" dropdown to **"6x6"** again.
9.  Tap **"Confirm"** (or "Reset", "OK", etc.).
10. **Verify**: The dialog closes, and the game board resets to a new 6x6 grid.

#### Test Case 3: Per-Mode High Scores

1.  Play a **6x6** game and achieve a score (e.g., 2048).
2.  Go to Settings and change the mode back to **4x4** (confirming the reset).
3.  Play a **4x4** game and achieve a different score (e.g., 1024).
4.  **Verify**: The displayed high score should be 1024.
5.  Go to Settings and change the mode back to **6x6**.
6.  **Verify**: The displayed high score should now be 2048.
