import 'package:draig_2048/features/settings/domain/entities/game_mode.dart';
import 'package:draig_2048/features/settings/domain/repositories/settings_repository.dart';

/// A use case that saves the provided game mode.
class SaveGameModeUseCase {
  /// Creates an instance of [SaveGameModeUseCase].
  const SaveGameModeUseCase(this._repository);

  /// The settings repository.
  final SettingsRepository _repository;

  /// Saves the provided game mode.
  Future<void> call(GameMode gameMode) {
    return _repository.saveGameMode(gameMode);
  }
}
