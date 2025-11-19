import 'package:drift/drift.dart';

/// Table definition for GameModeSettings.
@DataClassName('GameModeSetting')
class GameModeSettings extends Table {
  /// The ID of the game mode setting entry.
  IntColumn get id => integer().withDefault(const Constant(1))();

  /// The grid size for the game board (e.g., 4, 5, or 6).
  IntColumn get boardSize => integer().withDefault(const Constant(4))();

  /// The number of new tiles to add per move.
  IntColumn get tilesToSpawn => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}
