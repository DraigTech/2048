part of 'settings_bloc.dart';

/// Sealed base class for all states in the [SettingsBloc].
sealed class SettingsState extends Equatable {
  /// Creates an instance of [SettingsState].
  const SettingsState();

  @override
  List<Object> get props => [];
}

/// Initial state of the [SettingsBloc].
class SettingsInitial extends SettingsState {
  /// Creates an instance of [SettingsInitial].
  const SettingsInitial();
}

/// State when the settings are successfully loaded.
class SettingsLoaded extends SettingsState {
  /// Creates an instance of [SettingsLoaded].
  const SettingsLoaded({
    required this.audioSettings,
    required this.gameMode,
  });

  /// The current audio settings.
  final AudioSettings audioSettings;

  /// The current game mode.
  final GameMode gameMode;

  @override
  List<Object> get props => [audioSettings, gameMode];
}

/// State when an error occurs while loading or saving settings.
class SettingsError extends SettingsState {
  /// Creates an instance of [SettingsError].
  const SettingsError(this.message);

  /// The error message.
  final String message;

  @override
  List<Object> get props => [message];
}
