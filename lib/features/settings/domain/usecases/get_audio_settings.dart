import 'package:draig_2048/features/settings/domain/entities/audio_settings.dart';
import 'package:draig_2048/features/settings/domain/repositories/settings_repository.dart';

/// A use case for getting audio settings.
class GetAudioSettingsUseCase {
  /// Creates a [GetAudioSettingsUseCase] with the given [SettingsRepository].
  GetAudioSettingsUseCase(this._repository);

  /// The [SettingsRepository] to interact with.
  final SettingsRepository _repository;

  /// Retrieves the current [AudioSettings].
  Stream<AudioSettings> call() {
    return _repository.getAudioSettings();
  }
}
