import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:_2048/features/game/domain/entities/game_board.dart';
import 'package:_2048/features/game/domain/entities/high_score.dart';
import 'package:_2048/features/game/domain/repositories/game_repository.dart';
import 'package:_2048/features/game/domain/usecases/check_game_over.dart';
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
  final CheckGameOverUseCase checkGameOver;

  GameBloc({
    required this.moveTiles,
    required this.repository,
    required this.getHighScore,
    required this.saveHighScore,
    required this.checkGameOver,
  }) : super(GameInitial()) {
    on<GameStartEvent>(_onGameStarted);
    on<GameMoveEvent>(_onGameMoved);
    on<CheckGameOverEvent>(_onCheckGameOver);
    on<NewGameEvent>(_onNewGame);
  }

  AudioPool? moveAudio;
  AudioPool? mergeAudio;

  Future<void> _onGameStarted(
    GameStartEvent event,
    Emitter<GameState> emit,
  ) async {
    add(NewGameEvent());
    moveAudio = await FlameAudio.createPool(Assets.audio.move, maxPlayers: 1);
    mergeAudio = await FlameAudio.createPool(Assets.audio.merge, maxPlayers: 1);
  }

  Future<void> _onGameMoved(
    GameMoveEvent event,
    Emitter<GameState> emit,
  ) async {
    if (state is GameLoaded) {
      final currentState = state as GameLoaded;
      final currentBoard = currentState.gameBoard;
      final currentHighScore = currentState.highScore;
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

      emit(GameLoaded(newBoard, highScore: updatedHighScore));
      add(CheckGameOverEvent());
    }
  }

  Future<void> _onCheckGameOver(
    CheckGameOverEvent event,
    Emitter<GameState> emit,
  ) async {
    if (state is GameLoaded) {
      final currentState = state as GameLoaded;
      final isGameOver = await checkGameOver(currentState.gameBoard);
      if (isGameOver) {
        emit(
          GameLoaded(
            currentState.gameBoard,
            highScore: currentState.highScore,
            isGameOver: true,
          ),
        );
      }
    }
  }

  Future<void> _onNewGame(NewGameEvent event, Emitter<GameState> emit) async {
    final newBoard = await repository.newGame();
    final currentHighScore = await getHighScore();
    emit(GameLoaded(newBoard, highScore: currentHighScore.score));
  }
}
