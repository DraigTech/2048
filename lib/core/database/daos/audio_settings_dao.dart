part of '../database.dart';

/// Data Access Object for managing audio settings in the database.
@DriftAccessor(tables: [AudioSettings])
class AudioSettingsDao extends DatabaseAccessor<AppDatabase>
    with _$AudioSettingsDaoMixin {
  /// Creates an instance of [AudioSettingsDao].
  AudioSettingsDao(super.attachedDatabase);

  /// Retrieves the single audio settings record from the database.
  /// Returns `null` if no record exists.
  Stream<AudioSetting?> getAudioSettings() =>
      select(audioSettings).watchSingleOrNull();

  /// Inserts a new audio settings record or updates an existing one.
  Future<void> saveAudioSettings(AudioSettingsCompanion entry) =>
      into(audioSettings).insertOnConflictUpdate(entry);
}
