import 'package:draig_2048/core/database/database.dart';
import 'package:draig_2048/features/settings/domain/entities/audio_settings.dart';
import 'package:draig_2048/features/settings/domain/entities/game_mode.dart';
import 'package:draig_2048/features/settings/domain/repositories/settings_repository.dart';
import 'package:drift/drift.dart';
import 'package:rxdart/transformers.dart';

/// Implementation of [SettingsRepository] that
/// uses [AudioSettingsDao] for data persistence.
class SettingsRepositoryImpl implements SettingsRepository {
  /// Creates an instance of [SettingsRepositoryImpl].
  SettingsRepositoryImpl(
    this._audioSettingsDao,
    this._gameModeSettingsDao,
  );

  final AudioSettingsDao _audioSettingsDao;
  final GameModeSettingsDao _gameModeSettingsDao;

  @override
  Stream<AudioSettings> getAudioSettings() {
    final audioSetting = _audioSettingsDao.getAudioSettings();
    return audioSetting.map(
      (audioSetting) => AudioSettings(
        isMusicEnabled: audioSetting?.isMusicEnabled ?? true,
        isSoundEffectsEnabled: audioSetting?.isSoundEffectsEnabled ?? true,
      ),
    );
  }

  @override
  Future<void> saveAudioSettings(AudioSettings settings) async {
    await _audioSettingsDao.saveAudioSettings(
      AudioSettingsCompanion(
        id: const Value(1),
        isMusicEnabled: Value(settings.isMusicEnabled),
        isSoundEffectsEnabled: Value(settings.isSoundEffectsEnabled),
      ),
    );
  }

  @override
  Stream<GameMode> watchGameMode() {
    final gameModeSetting = _gameModeSettingsDao.watchGameMode();
    return gameModeSetting.map(
      (gameModeSetting) => GameMode(
        boardSize: gameModeSetting?.boardSize ?? GameMode.classic.boardSize,
        tilesToSpawn:
            gameModeSetting?.tilesToSpawn ?? GameMode.classic.tilesToSpawn,
      ),
    ).startWith(
      GameMode(
        boardSize: GameMode.classic.boardSize,
        tilesToSpawn: GameMode.classic.tilesToSpawn,
      ),
    );
  }

  @override
  Future<GameMode> getGameMode() async {
    final gameMode = await _gameModeSettingsDao.getGameMode();
    return GameMode(
      boardSize: gameMode?.boardSize ?? GameMode.classic.boardSize,
      tilesToSpawn: gameMode?.tilesToSpawn ?? GameMode.classic.tilesToSpawn,
    );
  }

  @override
  Future<void> saveGameMode(GameMode gameMode) async {
    await _gameModeSettingsDao.saveGameMode(
      GameModeSettingsCompanion(
        id: const Value(1),
        boardSize: Value(gameMode.boardSize),
        tilesToSpawn: Value(gameMode.tilesToSpawn),
      ),
    );
  }
}
