import 'package:bloc/bloc.dart';
import 'package:draig_2048/features/settings/domain/entities/audio_settings.dart';
import 'package:draig_2048/features/settings/domain/usecases/get_audio_settings.dart';
import 'package:draig_2048/features/settings/domain/usecases/save_audio_settings.dart';
import 'package:equatable/equatable.dart';

part 'settings_event.dart';
part 'settings_state.dart';

/// BLoC for managing audio settings.
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  /// Creates an instance of [SettingsBloc].
  SettingsBloc({
    required this.getAudioSettings,
    required this.saveAudioSettings,
  }) : super(const SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<ToggleMusic>(_onToggleMusic);
    on<ToggleSoundEffects>(_onToggleSoundEffects);
  }

  /// Use cases for getting audio settings.
  final GetAudioSettingsUseCase getAudioSettings;

  /// Use cases for saving audio settings.
  final SaveAudioSettingsUseCase saveAudioSettings;

  /// Handles the [LoadSettings] event.
  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    await emit.forEach(
      getAudioSettings().distinct(
        (p, n) =>
            p.isMusicEnabled == n.isMusicEnabled &&
            p.isSoundEffectsEnabled == n.isSoundEffectsEnabled,
      ),
      onData: SettingsLoaded.new,
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
        final currentSettings = (state as SettingsLoaded).settings;
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
        final currentSettings = (state as SettingsLoaded).settings;
        final newSettings = currentSettings.copyWith(
          isSoundEffectsEnabled: event.isSoundEffectsEnabled,
        );
        await saveAudioSettings(newSettings);
      }
    } on Exception catch (_) {
      emit(const SettingsError('Failed to save sound effects settings'));
    }
  }
}
