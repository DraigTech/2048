import 'package:drift/drift.dart';

/// Represents the user's persisted preferences for in-game audio.
@DataClassName('AudioSetting')
class AudioSettings extends Table {
  /// The ID of the audio setting entry.
  IntColumn get id => integer().autoIncrement()();

  /// Whether in-game music is enabled.
  BoolColumn get isMusicEnabled =>
      boolean().withDefault(const Constant(true))();

  /// Whether in-game sound effects are enabled.
  BoolColumn get isSoundEffectsEnabled =>
      boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}
