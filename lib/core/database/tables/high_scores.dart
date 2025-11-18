import 'package:drift/drift.dart';

/// Table definition for HighScores.
@DataClassName('HighScore')
class HighScores extends Table {
  /// The score achieved in the game.
  IntColumn get score => integer()();

  /// The board size associated with the high score.
  IntColumn get boardSize => integer()();

  @override
  Set<Column> get primaryKey => {boardSize};
}
