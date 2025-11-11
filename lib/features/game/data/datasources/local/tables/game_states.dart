import 'package:drift/drift.dart';

/// Table definition for GameStates.
@DataClassName('GameState')
class GameStates extends Table {
  /// The ID of the game state entry.
  /// Defaults to 1, ensuring a single entry for the game state.
  IntColumn get id => integer().withDefault(const Constant(1))();

  /// A JSON string representation of the game board.
  TextColumn get board => text()();

  /// The score of the game.
  IntColumn get score => integer()();

  /// The timestamp when the state was saved.
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
