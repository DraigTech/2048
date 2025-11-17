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
  const SettingsLoaded(this.settings);

  /// The current audio settings.
  final AudioSettings settings;

  @override
  List<Object> get props => [settings];
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
