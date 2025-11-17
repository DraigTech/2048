# Research: Persistent Game Modes

**Purpose**: To investigate and confirm the best practices for implementing the persistent game modes feature within the existing architecture.

---

### 1. Database Schema Changes with Drift

**Topic**: Best practices for adding a new table (`GameModeSettings`) and modifying an existing one (`GameStates`) in a Drift schema.

**Decision**:
-   A new table, `GameModeSettings`, will be created to store the user's selected mode. It will be a simple table, likely with a single entry that gets updated.
-   The existing `GameStates` table will be altered to include a `boardSize` column. This creates a link between a saved game and the mode it belongs to.
-   A new DAO, `GameModeSettingsDao`, will be created to abstract access to the new table.

**Rationale**:
-   Drift's documentation and standard database practices recommend creating new tables for new, distinct entities like game mode settings.
-   Modifying the `GameStates` table is necessary to fulfill the requirement of having separate high scores and saved games per mode. Without this link, it would be impossible to know which saved game corresponds to which mode.
-   Using a DAO is consistent with the existing data layer architecture in the project, promoting separation of concerns.
-   After defining the new table and DAO, running `dart run build_runner build --delete-conflicting-outputs` will generate the necessary schema and query code.

**Alternatives Considered**:
-   **Storing mode in `SharedPreferences`**: This is a viable alternative for simple key-value storage. However, since the game state is already in a Drift database, keeping the game mode setting within the same database ensures data consistency and allows for atomic transactions if ever needed. It centralizes data persistence logic.
-   **Adding all mode settings to the `GameStates` table**: This would denormalize the data and is less clean than creating a separate, dedicated table for settings.

---

### 2. Cross-BLoC State Management

**Topic**: Best practices for handling user-initiated state resets that affect multiple BLoCs (e.g., `SettingsBloc` triggering a reset in `GameBloc`).

**Decision**:
-   The `SettingsBloc` will handle the logic for changing the game mode.
-   When a user confirms a mode change that requires a game reset, the `SettingsBloc` will save the new setting and then add a `GameResetEvent` to the `GameBloc`.
-   To enable this, the `GameBloc` will be injected into the `SettingsBloc` as a dependency.

**Rationale**:
-   This approach maintains a clear separation of concerns. The `SettingsBloc` is responsible for settings-related actions, and the `GameBloc` is responsible for game state actions.
-   Directly adding an event to another BLoC is a common and effective pattern for communication between BLoCs when one needs to trigger a command in another. It's explicit and traceable.
-   The `GameBloc`'s loading logic (`_onGameStarted`) will be the single source of truth for deciding whether to load a saved game or start a new one, based on a comparison between the saved game's `boardSize` and the currently selected `GameMode`.

**Alternatives Considered**:
-   **Using a shared service/repository**: A service could be injected into both BLoCs to hold shared state. This can lead to a less predictable state flow and is generally discouraged in BLoC patterns in favor of explicit event passing.
-   **Streams/Callbacks**: Using a separate stream for communication adds complexity without significant benefit over the direct event-add pattern in this case.

---

### 3. User Confirmation for Destructive Actions

**Topic**: Confirm the standard implementation for a confirmation `AlertDialog` in Flutter before a destructive action.

**Decision**:
-   A standard `AlertDialog` will be displayed using `showDialog`.
-   The dialog will clearly state the consequences of the action (e.g., "Changing the mode will reset your current game. Are you sure?").
-   It will provide two `TextButton`s: "Cancel" and "Confirm" (or similar).
-   The "Confirm" button will pop the dialog and resolve the `showDialog` future with `true`, while "Cancel" will resolve it with `false` or `null`. The calling code in the UI will await this result to proceed with the action.

**Rationale**:
-   This is the standard, idiomatic way to implement confirmation dialogs in Flutter. It is recommended in the official Flutter documentation and is familiar to users.
-   It's a modal dialog, which correctly prevents any other UI interaction until the user makes a choice.

**Alternatives Considered**:
-   **Snackbar with an "Undo" action**: Less appropriate for an immediate, destructive action. A confirmation dialog forces the user to make a conscious choice *before* the action occurs.
-   **Custom dialog widget**: Unnecessary complexity. The standard `AlertDialog` is sufficient and customizable enough for this purpose.
