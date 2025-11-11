import 'package:drift/drift.dart';

/// Table definition for HighScores.
@DataClassName('HighScore')
class HighScores extends Table {
  /// The ID of the high score entry.
  /// Defaults to 1, ensuring a single entry for the high score.
  IntColumn get id => integer().withDefault(const Constant(1))();

  /// The score achieved in the game.
  IntColumn get score => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
