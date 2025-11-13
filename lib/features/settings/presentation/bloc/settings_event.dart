part of 'settings_bloc.dart';

/// Abstract base class for all events in the [SettingsBloc].
abstract class SettingsEvent extends Equatable {
  /// Creates an instance of [SettingsEvent].
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

/// Event to load the audio settings.
class LoadSettings extends SettingsEvent {
  /// Creates an instance of [LoadSettings].
  const LoadSettings();
}

/// Event to toggle the background music.
class ToggleMusic extends SettingsEvent {
  /// Creates an instance of [ToggleMusic].
  const ToggleMusic({required this.isMusicEnabled});

  /// Whether the music should be enabled.
  final bool isMusicEnabled;

  @override
  List<Object> get props => [isMusicEnabled];
}

/// Event to toggle the sound effects.
class ToggleSoundEffects extends SettingsEvent {
  /// Creates an instance of [ToggleSoundEffects].
  const ToggleSoundEffects({required this.isSoundEffectsEnabled});

  /// Whether the sound effects should be enabled.
  final bool isSoundEffectsEnabled;

  @override
  List<Object> get props => [isSoundEffectsEnabled];
}
