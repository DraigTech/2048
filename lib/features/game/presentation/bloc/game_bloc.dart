import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:draig_2048/features/game/domain/entities/game_board.dart';
import 'package:draig_2048/features/game/domain/entities/high_score.dart';
import 'package:draig_2048/features/game/domain/repositories/game_repository.dart';
import 'package:draig_2048/features/game/domain/usecases/check_game_over.dart';
import 'package:draig_2048/features/game/domain/usecases/get_high_score.dart';
import 'package:draig_2048/features/game/domain/usecases/move_tiles.dart';
import 'package:draig_2048/features/game/domain/usecases/save_high_score.dart';
import 'package:draig_2048/generated/assets.gen.dart';
import 'package:equatable/equatable.dart';
import 'package:flame_audio/flame_audio.dart';

part 'game_event.dart';
part 'game_state.dart';

/// BLoC responsible for managing the game state of 2048.
///
/// It handles game events suchs as starting a new game, moving tiles,
/// and checking for game over conditions.
class GameBloc extends Bloc<GameEvent, GameState> {
  /// Creates a [GameBloc] instance.
  ///
  /// Requires various use cases and a [GameRepository] for its operations.
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
    on<SaveGameEvent>(_onSaveGame);
  }

  /// Use case for moving tiles on the game board.
  final MoveTilesUseCase moveTiles;

  /// Repository for game-related data operations.
  final GameRepository repository;

  /// Use case for retrieving the high score.
  final GetHighScoreUseCase getHighScore;

  /// Use case for saving the high score.
  final SaveHighScoreUseCase saveHighScore;

  /// Use case for checking if the game is over.
  final CheckGameOverUseCase checkGameOver;

  AudioPool? _moveAudio;
  AudioPool? _mergeAudio;

  /// Handles the [GameStartEvent] to initialize the game and load audio assets.
  Future<void> _onGameStarted(
    GameStartEvent event,
    Emitter<GameState> emit,
  ) async {
    try {
      final loadedBoard = await repository.loadBoard();
      if (loadedBoard != null) {
        final currentHighScore = await getHighScore();
        emit(GameLoaded(loadedBoard, highScore: currentHighScore.score));
      } else {
        add(NewGameEvent());
      }
      _moveAudio = await FlameAudio.createPool(
        Assets.audio.move,
        maxPlayers: 1,
      );
      _mergeAudio = await FlameAudio.createPool(
        Assets.audio.merge,
        maxPlayers: 1,
      );
    } on Exception catch (e) {
      emit(GameError(e.toString()));
    }
  }

  /// Handles the [GameMoveEvent] to process tile movements.
  ///
  /// It updates the game board, checks for merges, plays audio,
  /// updates the high score if necessary, and then checks for game over.
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
          unawaited(_mergeAudio?.start());
        }
        unawaited(_moveAudio?.start());
      }

      var updatedHighScore = currentHighScore;
      if (newBoard.score > currentHighScore) {
        updatedHighScore = newBoard.score;
        await saveHighScore(HighScore(score: updatedHighScore));
      }

      emit(GameLoaded(newBoard, highScore: updatedHighScore));
      add(CheckGameOverEvent());
    }
  }

  /// Handles the [CheckGameOverEvent] to determine if the game has ended.
  ///
  /// If the game is over, it updates the state to reflect this.
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

  /// Handles the [NewGameEvent] to start a fresh game.
  ///
  /// It creates a new game board and loads the current high score.
  Future<void> _onNewGame(NewGameEvent event, Emitter<GameState> emit) async {
    await repository.clearBoard();
    final newBoard = await repository.newGame();
    final currentHighScore = await getHighScore();
    emit(GameLoaded(newBoard, highScore: currentHighScore.score));
  }

  /// Handles the [SaveGameEvent] to save the current game state.
  Future<void> _onSaveGame(
    SaveGameEvent event,
    Emitter<GameState> emit,
  ) async {
    if (state is GameLoaded) {
      final currentState = state as GameLoaded;
      await repository.saveBoard(currentState.gameBoard);
    }
  }
}
