import 'package:draig_2048/features/settings/domain/entities/game_mode.dart';
import 'package:draig_2048/features/settings/domain/repositories/settings_repository.dart';

/// A use case that watches for changes in the game mode.
class WatchGameModeUseCase {
  /// Creates an instance of [WatchGameModeUseCase].
  const WatchGameModeUseCase(this._repository);

  /// The settings repository.
  final SettingsRepository _repository;

  /// Make the use case callable.
  ///
  /// Returns a [Stream] of [GameMode] which emits the current game mode
  /// whenever it changes.
  Stream<GameMode> call() {
    return _repository.watchGameMode();
  }
}
