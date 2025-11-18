import 'package:draig_2048/features/settings/domain/entities/game_mode.dart';
import 'package:draig_2048/features/settings/domain/repositories/settings_repository.dart';

/// A use case that retrieves the current game mode.
class GetGameModeUseCase {
  /// Creates an instance of [GetGameModeUseCase].
  const GetGameModeUseCase(this._settingsRepository);

  /// The settings repository.
  final SettingsRepository _settingsRepository;

  /// Retrieves the current game mode.
  Future<GameMode> call() {
    return _settingsRepository.getGameMode();
  }
}
