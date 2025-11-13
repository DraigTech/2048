import 'package:draig_2048/features/settings/domain/entities/audio_settings.dart';
import 'package:draig_2048/features/settings/domain/repositories/settings_repository.dart';

/// A use case for getting audio settings.
class GetAudioSettingsUseCase {
  /// Creates a [GetAudioSettingsUseCase] with the given [repository].
  GetAudioSettingsUseCase(this.repository);

  /// The [SettingsRepository] to interact with.
  final SettingsRepository repository;

  /// Retrieves the current [AudioSettings].
  Stream<AudioSettings> call() {
    return repository.getAudioSettings();
  }
}
