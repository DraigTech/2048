import 'package:draig_2048/core/audio/audio_manager.dart';
import 'package:draig_2048/core/database/database.dart';
import 'package:draig_2048/features/game/data/repositories/game_repository_impl.dart';
import 'package:draig_2048/features/game/domain/repositories/game_repository.dart';
import 'package:draig_2048/features/game/domain/usecases/check_game_over.dart';
import 'package:draig_2048/features/game/domain/usecases/get_high_score.dart';
import 'package:draig_2048/features/game/domain/usecases/move_tiles.dart';
import 'package:draig_2048/features/game/domain/usecases/save_high_score.dart';
import 'package:draig_2048/features/game/presentation/bloc/game_bloc.dart';
import 'package:draig_2048/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:draig_2048/features/settings/domain/repositories/settings_repository.dart';
import 'package:draig_2048/features/settings/domain/usecases/get_audio_settings.dart';
import 'package:draig_2048/features/settings/domain/usecases/save_audio_settings.dart';
import 'package:draig_2048/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:get_it/get_it.dart';

/// Global instance of GetIt for dependency injection.
final GetIt getIt = GetIt.instance;

/// Configures the dependencies for the application using GetIt.
///
/// This function registers singletons, lazy singletons, and factories for
/// various services, repositories, use cases, and BLoCs.
void configureDependencies() {
  _configureDatabase();
  _configureRepositories();
  _configureUseCases();
  _configureBlocs();
  _configureServices();
}

void _configureDatabase() {
  getIt
    ..registerSingleton<AppDatabase>(AppDatabase())
    ..registerSingleton<GameStateDao>(getIt<AppDatabase>().gameStateDao)
    ..registerSingleton<HighScoreDao>(getIt<AppDatabase>().highScoreDao)
    ..registerSingleton<AudioSettingsDao>(
      getIt<AppDatabase>().audioSettingsDao,
    );
}

void _configureRepositories() {
  getIt
    ..registerLazySingleton<GameRepository>(
      () => GameRepositoryImpl(getIt(), getIt()),
    )
    ..registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(getIt()),
    );
}

void _configureUseCases() {
  getIt
    ..registerLazySingleton(() => MoveTilesUseCase(getIt()))
    ..registerLazySingleton(() => GetHighScoreUseCase(getIt()))
    ..registerLazySingleton(() => SaveHighScoreUseCase(getIt()))
    ..registerLazySingleton(() => CheckGameOverUseCase(getIt()))
    ..registerLazySingleton(() => GetAudioSettingsUseCase(getIt()))
    ..registerLazySingleton(() => SaveAudioSettingsUseCase(getIt()));
}

void _configureBlocs() {
  getIt
    ..registerFactory(
      () => GameBloc(
        audioManager: getIt(),
        moveTiles: getIt(),
        repository: getIt(),
        getHighScore: getIt(),
        saveHighScore: getIt(),
        checkGameOver: getIt(),
      ),
    )
    ..registerFactory(
      () => SettingsBloc(
        getAudioSettings: getIt(),
        saveAudioSettings: getIt(),
      ),
    );
}

void _configureServices() {
  getIt.registerSingleton<AudioManager>(
    AudioManager(getAudioSettings: getIt()),
  );
}
