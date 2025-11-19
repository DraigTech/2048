import 'package:draig_2048/features/settings/domain/entities/audio_settings.dart';
import 'package:draig_2048/features/settings/domain/entities/game_mode.dart';

/// Abstract repository for managing audio settings.
abstract class SettingsRepository {
  /// Retrieves the current audio settings.
  Stream<AudioSettings> getAudioSettings();

  /// Saves the provided audio settings.
  Future<void> saveAudioSettings(AudioSettings settings);

  /// Retrieves the current game mode.
  Stream<GameMode> watchGameMode();

  /// Retrieves the current game mode.
  Future<GameMode> getGameMode();

  /// Saves the provided game mode.
  Future<void> saveGameMode(GameMode gameMode);
}
