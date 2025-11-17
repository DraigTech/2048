import 'package:draig_2048/features/settings/domain/entities/audio_settings.dart';

/// Abstract repository for managing audio settings.
abstract class SettingsRepository {
  /// Retrieves the current audio settings.
  Stream<AudioSettings> getAudioSettings();

  /// Saves the provided audio settings.
  Future<void> saveAudioSettings(AudioSettings settings);
}
