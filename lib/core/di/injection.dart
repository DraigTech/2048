import 'package:draig_2048/features/game/data/datasources/local/database.dart';
import 'package:draig_2048/features/game/data/repositories/game_repository_impl.dart';
import 'package:draig_2048/features/game/domain/repositories/game_repository.dart';
import 'package:draig_2048/features/game/domain/usecases/check_game_over.dart';
import 'package:draig_2048/features/game/domain/usecases/get_high_score.dart';
import 'package:draig_2048/features/game/domain/usecases/move_tiles.dart';
import 'package:draig_2048/features/game/domain/usecases/save_high_score.dart';
import 'package:draig_2048/features/game/presentation/bloc/game_bloc.dart';
import 'package:get_it/get_it.dart';

/// Global instance of GetIt for dependency injection.
final GetIt getIt = GetIt.instance;

/// Configures the dependencies for the application using GetIt.
///
/// This function registers singletons, lazy singletons, and factories for
/// various services, repositories, use cases, and BLoCs.
void configureDependencies() {
  // Register database
  getIt
    ..registerSingleton<AppDatabase>(AppDatabase())
    ..registerSingleton<GameStateDao>(getIt<AppDatabase>().gameStateDao)
    ..registerSingleton<HighScoreDao>(getIt<AppDatabase>().highScoreDao)

  // Register repositories
  ..registerLazySingleton<GameRepository>(
    () => GameRepositoryImpl(getIt(), getIt()),
  )

  // Register use cases
  ..registerLazySingleton(() => MoveTilesUseCase(getIt()))
  ..registerLazySingleton(() => GetHighScoreUseCase(getIt()))
  ..registerLazySingleton(() => SaveHighScoreUseCase(getIt()))
  ..registerLazySingleton(() => CheckGameOverUseCase(getIt()))

  // Register BLoCs
  ..registerFactory(
    () => GameBloc(
      moveTiles: getIt(),
      repository: getIt(),
      getHighScore: getIt(),
      saveHighScore: getIt(),
      checkGameOver: getIt(),
    ),
  );
}
