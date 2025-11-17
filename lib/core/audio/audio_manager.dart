import 'dart:async';

import 'package:draig_2048/core/assets/assets.gen.dart';
import 'package:draig_2048/features/settings/domain/entities/audio_settings.dart';
import 'package:draig_2048/features/settings/domain/usecases/get_audio_settings.dart';
import 'package:flame_audio/flame_audio.dart';

/// Manages audio playback for background music and sound effects.
class AudioManager {
  /// Creates an instance of [AudioManager].
  AudioManager({required this.getAudioSettings}) {
    _audioSettingsStream = getAudioSettings();

    _audioSettingsStream.listen((element) {
      _isMusicEnabled = element.isMusicEnabled;
      _isSoundEffectsEnabled = element.isSoundEffectsEnabled;
      playBackgroundMusic();
    });
  }

  /// Use cases for getting audio settings.
  final GetAudioSettingsUseCase getAudioSettings;

  final Map<String, AudioPool> _audioPools = {};
  late Stream<AudioSettings> _audioSettingsStream;
  bool _isMusicEnabled = true;
  bool _isSoundEffectsEnabled = true;

  /// Plays background music based on the current [_isMusicEnabled] setting.
  ///
  /// If [_isMusicEnabled] is true, it loops the 'background_music.mp3'.
  /// Otherwise, it stops any playing background music.
  void playBackgroundMusic() {
    if (_isMusicEnabled) {
      unawaited(FlameAudio.bgm.play(Assets.audio.background));
    } else {
      unawaited(FlameAudio.bgm.stop());
    }
  }

  /// Plays a sound effect.
  ///
  /// If [_isSoundEffectsEnabled] is true, it plays the specified [fileName].
  void playSoundEffect(String fileName) {
    if (_isSoundEffectsEnabled) {
      if (!_audioPools.containsKey(fileName)) {
        unawaited(
          FlameAudio.createPool(
            fileName,
            maxPlayers: 1,
          ).then(
            (pool) => _audioPools[fileName] = pool,
          ),
        );
      }
      unawaited(_audioPools[fileName]?.start());
    }
  }

  /// Disposes the resources used by the [AudioManager].
  Future<void> dispose() async {
    await FlameAudio.bgm.stop();
  }
}
