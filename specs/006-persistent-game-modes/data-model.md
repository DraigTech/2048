# Data Model: Persistent Game Modes

**Purpose**: To define the data structures and database schema changes required to support persistent, selectable game modes.

---

### 1. New Table: `GameModeSettings`

This table will store the user's currently selected game mode. It is expected to contain only a single row that is updated as the user changes their preference.

**Entity Name**: `GameModeSetting`

**Drift Table Definition** (`lib/core/database/tables.dart`):

```dart
import 'package:drift/drift.dart';

@DataClassName('GameModeSetting')
class GameModeSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get boardSize => integer().withDefault(const Constant(4))();
  IntColumn get tilesToSpawn => integer().withDefault(const Constant(1))();
}
```

**Fields**:

| Field         | Type    | Constraints         | Description                                         |
|---------------|---------|---------------------|-----------------------------------------------------|
| `id`          | `Int`   | Primary Key         | The unique identifier for the setting entry.        |
| `boardSize`   | `Int`   | Not Null, Default 4 | The grid size for the game board (e.g., 4, 5, or 6). |
| `tilesToSpawn`| `Int`   | Not Null, Default 1 | The number of new tiles to add per move.            |

---

### 2. Modified Table: `GameStates`

The existing `GameStates` table will be modified to include a `boardSize` column. This links a saved game state to a specific game mode, enabling per-mode saved games and high scores.

**Entity Name**: `GameState`

**Drift Table Definition** (`lib/core/database/tables.dart`):

```dart
// Existing GameStates table with the new column
@DataClassName('GameState')
class GameStates extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get board => text()();
  IntColumn get score => integer()();
  BoolColumn get isGameOver => boolean()();
  
  // New column
  IntColumn get boardSize => integer().withDefault(const Constant(4))();
}
```

**New Field**:

| Field       | Type  | Constraints         | Description                                                  |
|-------------|-------|---------------------|--------------------------------------------------------------|
| `boardSize` | `Int` | Not Null, Default 4 | The grid size of the board when this game state was saved. |

---

### 3. Data Access Objects (DAOs)

-   A new **`GameModeSettingsDao`** will be created to provide an interface for querying and updating the `GameModeSettings` table.
-   The existing **`GameStatesDao`** will be updated to handle the new `boardSize` column, particularly for `watchGameState` and `saveGameState` methods, which will now need to filter by `boardSize`.

---

### 4. State & Entity Models

-   A **`GameMode`** entity will be created in the domain layer to represent the game mode settings, decoupled from the Drift data class.
-   The `SettingsState` in `SettingsBloc` will be updated to include the current `GameMode`.
-   The `GameState` entity in the domain layer will be updated to include `boardSize`.
