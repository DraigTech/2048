part of '../database.dart';

/// Data Access Object for HighScore operations.
@DriftAccessor(tables: [HighScores])
class HighScoreDao extends DatabaseAccessor<AppDatabase>
    with _$HighScoreDaoMixin {
  /// Creates an instance of [HighScoreDao].
  HighScoreDao(super.attachedDatabase);

  /// Retrieves the highest score from the database.
  Future<HighScore?> getHighScore(int boardSize) =>
      (select(highScores)
            ..where((t) => t.boardSize.equals(boardSize))
            ..limit(1))
          .getSingleOrNull();

  /// Saves or updates a high score.
  Future<void> saveHighScore(HighScoresCompanion entry) =>
      into(highScores).insert(entry, mode: InsertMode.replace);
}
