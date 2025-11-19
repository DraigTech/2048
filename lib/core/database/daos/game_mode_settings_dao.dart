part of '../database.dart';

/// Data Access Object for managing game mode settings in the database.
@DriftAccessor(tables: [GameModeSettings])
class GameModeSettingsDao extends DatabaseAccessor<AppDatabase>
    with _$GameModeSettingsDaoMixin {
  /// Creates an instance of [GameModeSettingsDao].
  GameModeSettingsDao(super.attachedDatabase);

  /// Saves or updates the game mode settings.
  Future<void> saveGameMode(GameModeSettingsCompanion entry) =>
      into(gameModeSettings).insertOnConflictUpdate(entry);

  /// Retrieves the game mode settings.
  Future<GameModeSetting?> getGameMode() =>
      select(gameModeSettings).getSingleOrNull();

  /// Watches for changes to the game mode settings.
  Stream<GameModeSetting?> watchGameMode() =>
      select(gameModeSettings).watchSingleOrNull();
}
