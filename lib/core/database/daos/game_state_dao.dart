part of '../database.dart';

/// Data Access Object for GameState operations.
@DriftAccessor(tables: [GameStates])
class GameStateDao extends DatabaseAccessor<AppDatabase>
    with _$GameStateDaoMixin {
  /// Creates an instance of [GameStateDao].
  GameStateDao(super.attachedDatabase);

  /// Retrieves the most recently saved game state.
  Future<GameState?> getLatestGameState() =>
      (select(gameStates)..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .getSingleOrNull();

  /// Saves or updates the game state.
  Future<void> saveGameState(GameStatesCompanion entry) =>
      into(gameStates).insert(entry, mode: InsertMode.replace);

  /// Clears all saved game states.
  Future<void> clearGameStates() => delete(gameStates).go();
}
