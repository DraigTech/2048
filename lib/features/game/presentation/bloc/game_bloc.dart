import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:_2048/features/game/domain/entities/game_board.dart';
import 'package:_2048/features/game/domain/entities/high_score.dart';
import 'package:_2048/features/game/domain/repositories/game_repository.dart';
import 'package:_2048/features/game/domain/usecases/get_high_score.dart';
import 'package:_2048/features/game/domain/usecases/move_tiles.dart';
import 'package:_2048/features/game/domain/usecases/save_high_score.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final MoveTilesUseCase moveTiles;
  final GameRepository repository;
  final GetHighScoreUseCase getHighScore;
  final SaveHighScoreUseCase saveHighScore;

  GameBloc({
    required this.moveTiles,
    required this.repository,
    required this.getHighScore,
    required this.saveHighScore,
  }) : super(GameInitial()) {
    on<GameStarted>(_onGameStarted);
    on<GameMoved>(_onGameMoved);
  }

  Future<void> _onGameStarted(GameStarted event, Emitter<GameState> emit) async {
    final newBoard = await repository.newGame();
    final currentHighScore = await getHighScore();
    emit(GameLoaded(newBoard, highScore: currentHighScore.score));
  }

  Future<void> _onGameMoved(GameMoved event, Emitter<GameState> emit) async {
    if (state is GameLoaded) {
      final currentBoard = (state as GameLoaded).gameBoard;
      final currentHighScore = (state as GameLoaded).highScore;
      final newBoard = await moveTiles(currentBoard, event.direction);

      int updatedHighScore = currentHighScore;
      if (newBoard.score > currentHighScore) {
        updatedHighScore = newBoard.score;
        await saveHighScore(HighScore(score: updatedHighScore));
      }

      // TODO: Check for game over condition

      emit(GameLoaded(newBoard, highScore: updatedHighScore));
    }
  }
}
