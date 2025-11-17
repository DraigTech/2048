import 'package:draig_2048/features/settings/domain/entities/audio_settings.dart';
import 'package:draig_2048/features/settings/domain/repositories/settings_repository.dart';

/// A use case for saving audio settings.
class SaveAudioSettingsUseCase {
  /// Creates a [SaveAudioSettingsUseCase] with the given [repository].
  SaveAudioSettingsUseCase(this.repository);

  /// The settings repository to interact with.
  final SettingsRepository repository;

  /// Saves the given [audioSettings].
  Future<void> call(AudioSettings audioSettings) {
    return repository.saveAudioSettings(audioSettings);
  }
}
