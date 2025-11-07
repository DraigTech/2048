import 'package:get_it/get_it.dart';
import 'package:_2048/features/game/data/datasources/local/database.dart';
import 'package:_2048/features/game/data/repositories/game_repository_impl.dart';
import 'package:_2048/features/game/domain/repositories/game_repository.dart';
import 'package:_2048/features/game/domain/usecases/check_game_over.dart';
import 'package:_2048/features/game/domain/usecases/get_high_score.dart';
import 'package:_2048/features/game/domain/usecases/move_tiles.dart';
import 'package:_2048/features/game/domain/usecases/save_high_score.dart';
import 'package:_2048/features/game/presentation/bloc/game_bloc.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  // Register database
  getIt.registerSingleton<AppDatabase>(AppDatabase());

  // Register repositories
  getIt.registerLazySingleton<GameRepository>(() => GameRepositoryImpl(getIt()));

  // Register use cases
  getIt.registerLazySingleton(() => MoveTilesUseCase(getIt()));
  getIt.registerLazySingleton(() => GetHighScoreUseCase(getIt()));
  getIt.registerLazySingleton(() => SaveHighScoreUseCase(getIt()));
  getIt.registerLazySingleton(() => CheckGameOverUseCase(getIt()));

  // Register BLoCs
  getIt.registerFactory(() => GameBloc(
        moveTiles: getIt(),
        repository: getIt(),
        getHighScore: getIt(),
        saveHighScore: getIt(),
        checkGameOver: getIt(),
      ));
}
