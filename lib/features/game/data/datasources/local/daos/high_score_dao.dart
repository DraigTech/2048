part of '../database.dart';

/// Data Access Object for HighScore operations.
@DriftAccessor(tables: [HighScores])
class HighScoreDao extends DatabaseAccessor<AppDatabase>
    with _$HighScoreDaoMixin {
  /// Creates an instance of [HighScoreDao].
  HighScoreDao(super.attachedDatabase);

  /// Retrieves the highest score from the database.
  Future<HighScore?> getHighScore() =>
      (select(highScores)..orderBy([(t) => OrderingTerm.desc(t.score)]))
          .getSingleOrNull();

  /// Saves or updates a high score.
  Future<void> saveHighScore(HighScoresCompanion entry) =>
      into(highScores).insert(entry, mode: InsertMode.replace);
}
