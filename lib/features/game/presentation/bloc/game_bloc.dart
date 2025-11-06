import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:_2048/features/game/domain/entities/game_board.dart';
import 'package:_2048/features/game/domain/entities/high_score.dart';
import 'package:_2048/features/game/domain/repositories/game_repository.dart';
import 'package:_2048/features/game/domain/usecases/get_high_score.dart';
import 'package:_2048/features/game/domain/usecases/move_tiles.dart';
import 'package:_2048/features/game/domain/usecases/save_high_score.dart';
import 'package:_2048/generated/assets.gen.dart';

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
    on<GameStartEvent>(_onGameStarted);
    on<GameMoveEvent>(_onGameMoved);
  }

  AudioPool? moveAudio;
  AudioPool? mergeAudio;

  Future<void> _onGameStarted(
    GameStartEvent event,
    Emitter<GameState> emit,
  ) async {
    moveAudio = await FlameAudio.createPool(Assets.audio.move, maxPlayers: 2);
    mergeAudio = await FlameAudio.createPool(Assets.audio.merge, maxPlayers: 2);
    final newBoard = await repository.newGame();
    final currentHighScore = await getHighScore();
    emit(GameLoaded(newBoard, highScore: currentHighScore.score));
  }

  Future<void> _onGameMoved(GameMoveEvent event, Emitter<GameState> emit) async {
    if (state is GameLoaded) {
      final currentBoard = (state as GameLoaded).gameBoard;
      final currentHighScore = (state as GameLoaded).highScore;
      final (newBoard, merged) = await moveTiles(currentBoard, event.direction);

      if (newBoard != currentBoard) {
        if (merged) {
          mergeAudio?.start();
        }
        moveAudio?.start();
      }

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
