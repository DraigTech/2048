import 'package:draig_2048/core/database/database.dart';
import 'package:draig_2048/features/settings/domain/entities/audio_settings.dart';
import 'package:draig_2048/features/settings/domain/repositories/settings_repository.dart';
import 'package:drift/drift.dart';

/// Implementation of [SettingsRepository] that
/// uses [AudioSettingsDao] for data persistence.
class SettingsRepositoryImpl implements SettingsRepository {
  /// Creates an instance of [SettingsRepositoryImpl].
  SettingsRepositoryImpl(this._audioSettingsDao);

  final AudioSettingsDao _audioSettingsDao;

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
}
