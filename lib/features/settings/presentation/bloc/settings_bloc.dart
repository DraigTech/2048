import 'package:bloc/bloc.dart';
import 'package:draig_2048/features/settings/domain/entities/audio_settings.dart';
import 'package:draig_2048/features/settings/domain/entities/game_mode.dart';
import 'package:draig_2048/features/settings/domain/usecases/get_audio_settings.dart';
import 'package:draig_2048/features/settings/domain/usecases/save_audio_settings.dart';
import 'package:draig_2048/features/settings/domain/usecases/save_game_mode.dart';
import 'package:draig_2048/features/settings/domain/usecases/watch_game_mode.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

part 'settings_event.dart';
part 'settings_state.dart';

/// BLoC for managing audio settings.
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  /// Creates an instance of [SettingsBloc].
  SettingsBloc({
    required this.getAudioSettings,
    required this.saveAudioSettings,
    required this.getGameMode,
    required this.saveGameMode,
  }) : super(const SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<ToggleMusic>(_onToggleMusic);
    on<ToggleSoundEffects>(_onToggleSoundEffects);
    on<ChangeGameMode>(_onChangeGameMode);
  }

  /// Use cases for getting audio settings.
  final GetAudioSettingsUseCase getAudioSettings;

  /// Use cases for saving audio settings.
  final SaveAudioSettingsUseCase saveAudioSettings;

  /// Use case for getting game mode.
  final WatchGameModeUseCase getGameMode;

  /// Use case for saving game mode.
  final SaveGameModeUseCase saveGameMode;

  /// Handles the [LoadSettings] event.
  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    await emit.forEach(
      Rx.combineLatest2(
        getAudioSettings(),
        getGameMode(),
        (AudioSettings audioSettings, GameMode gameMode) => SettingsLoaded(
          audioSettings: audioSettings,
          gameMode: gameMode,
        ),
      ).distinct(
        (SettingsLoaded p, SettingsLoaded n) =>
            p.audioSettings.isMusicEnabled == n.audioSettings.isMusicEnabled &&
            p.audioSettings.isSoundEffectsEnabled ==
                n.audioSettings.isSoundEffectsEnabled &&
            p.gameMode.boardSize == n.gameMode.boardSize,
      ),
      onData: (SettingsLoaded settingsLoaded) => settingsLoaded,
      onError: (_, _) => const SettingsError('Failed to load settings'),
    );
  }

  /// Handles the [ToggleMusic] event.
  Future<void> _onToggleMusic(
    ToggleMusic event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      if (state is SettingsLoaded) {
        final currentSettings = (state as SettingsLoaded).audioSettings;
        final newSettings = currentSettings.copyWith(
          isMusicEnabled: event.isMusicEnabled,
        );
        await saveAudioSettings(newSettings);
      }
    } on Exception catch (_) {
      emit(const SettingsError('Failed to save music settings'));
    }
  }

  /// Handles the [ToggleSoundEffects] event.
  Future<void> _onToggleSoundEffects(
    ToggleSoundEffects event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      if (state is SettingsLoaded) {
        final currentSettings = (state as SettingsLoaded).audioSettings;
        final newSettings = currentSettings.copyWith(
          isSoundEffectsEnabled: event.isSoundEffectsEnabled,
        );
        await saveAudioSettings(newSettings);
      }
    } on Exception catch (_) {
      emit(const SettingsError('Failed to save sound effects settings'));
    }
  }

  /// Handles the [ChangeGameMode] event.
  Future<void> _onChangeGameMode(
    ChangeGameMode event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      if (state is SettingsLoaded) {
        await saveGameMode(event.gameMode);
      }
    } on Exception catch (_) {
      emit(const SettingsError('Failed to save game mode'));
    }
  }
}
