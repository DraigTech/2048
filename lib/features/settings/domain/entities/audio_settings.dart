import 'package:equatable/equatable.dart';

/// Represents the user's audio settings preferences.
class AudioSettings extends Equatable {
  /// Creates an instance of [AudioSettings].
  const AudioSettings({
    required this.isMusicEnabled,
    required this.isSoundEffectsEnabled,
  });

  /// Whether the background music is enabled.
  final bool isMusicEnabled;

  /// Whether the sound effects (e.g., move, merge) are enabled.
  final bool isSoundEffectsEnabled;

  @override
  List<Object?> get props => [isMusicEnabled, isSoundEffectsEnabled];

  /// Creates a copy of this [AudioSettings] with
  /// the given fields replaced with the new values.
  AudioSettings copyWith({
    bool? isMusicEnabled,
    bool? isSoundEffectsEnabled,
  }) {
    return AudioSettings(
      isMusicEnabled: isMusicEnabled ?? this.isMusicEnabled,
      isSoundEffectsEnabled:
          isSoundEffectsEnabled ?? this.isSoundEffectsEnabled,
    );
  }
}
