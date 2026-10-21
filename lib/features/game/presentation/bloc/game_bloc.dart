import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:draig_2048/core/ads/ad_service.dart';
import 'package:draig_2048/core/assets/assets.gen.dart';
import 'package:draig_2048/core/audio/audio_manager.dart';
import 'package:draig_2048/features/game/domain/entities/game_board.dart';
import 'package:draig_2048/features/game/domain/entities/high_score.dart';
import 'package:draig_2048/features/game/domain/repositories/game_repository.dart';
import 'package:draig_2048/features/game/domain/usecases/check_game_over.dart';
import 'package:draig_2048/features/game/domain/usecases/clear_board.dart';
import 'package:draig_2048/features/game/domain/usecases/get_high_score.dart';
import 'package:draig_2048/features/game/domain/usecases/load_board.dart';
import 'package:draig_2048/features/game/domain/usecases/move_tiles.dart';
import 'package:draig_2048/features/game/domain/usecases/new_game.dart';
import 'package:draig_2048/features/game/domain/usecases/save_board.dart';
import 'package:draig_2048/features/game/domain/usecases/save_high_score.dart';
import 'package:draig_2048/features/settings/domain/usecases/get_game_mode.dart';
import 'package:draig_2048/features/settings/domain/usecases/watch_game_mode.dart';
import 'package:equatable/equatable.dart';

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
    required this.audioManager,
    required this.moveTiles,
    required this.getHighScore,
    required this.saveHighScore,
    required this.checkGameOver,
    required this.loadBoard,
    required this.newGame,
    required this.saveBoard,
    required this.clearBoard,
    required this.getGameMode,
    required this.watchGameMode,
    required this.adService,
  }) : super(GameInitial()) {
    on<GameStartEvent>(_onGameStarted);
    on<GameMoveEvent>(_onGameMoved);
    on<CheckGameOverEvent>(_onCheckGameOver);
    on<NewGameEvent>(_onNewGame);
    on<SaveGameEvent>(_onSaveGame);
    on<GameResetEvent>((event, emit) {
      adService.showInterstitialAd();
      add(NewGameEvent());
    });
  }

  /// Manages ads.
  final AdService adService;

  /// Audio manager for playing sound effects.
  final AudioManager audioManager;

  /// Use case for moving tiles on the game board.
  final MoveTilesUseCase moveTiles;

  /// Use case for retrieving the high score.
  final GetHighScoreUseCase getHighScore;

  /// Use case for saving the high score.
  final SaveHighScoreUseCase saveHighScore;

  /// Use case for checking if the game is over.
  final CheckGameOverUseCase checkGameOver;

  /// Use case for loading the game board.
  final LoadBoardUseCase loadBoard;

  /// Use case for creating a new game board.
  final NewGameUseCase newGame;

  /// Use case for saving the game board.
  final SaveBoardUseCase saveBoard;

  /// Use case for clearing the game board.
  final ClearBoardUseCase clearBoard;

  /// Use case for getting game mode.
  final GetGameModeUseCase getGameMode;

  /// Use case for watching game mode.
  final WatchGameModeUseCase watchGameMode;

  /// Handles the [GameStartEvent] to initialize the game and load audio assets.
  Future<void> _onGameStarted(
    GameStartEvent event,
    Emitter<GameState> emit,
  ) async {
    try {
      final currentGameMode = await getGameMode();
      final loadedBoard = await loadBoard(currentGameMode.boardSize);
      if (loadedBoard != null) {
        final currentHighScore = await getHighScore(currentGameMode.boardSize);

        emit(
          GameLoaded(
            loadedBoard,
            highScore: currentHighScore.score,
            boardSize: currentGameMode.boardSize,
          ),
        );

        watchGameMode()
            .distinct(
              (previous, current) => previous.boardSize == current.boardSize,
            )
            .listen(
              (event) => add(NewGameEvent()),
            );
      } else {
        add(NewGameEvent());
      }
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
      final (newBoard, merged) = await moveTiles(
        currentBoard,
        event.direction,
      );

      if (newBoard != currentBoard) {
        if (merged) {
          audioManager.playSoundEffect(Assets.audio.merge);
        }
        audioManager.playSoundEffect(Assets.audio.move);
      }

      var updatedHighScore = currentHighScore;
      if (newBoard.score > currentHighScore) {
        updatedHighScore = newBoard.score;
        await saveHighScore(
          HighScore(score: updatedHighScore),
          currentState.boardSize,
        );
      }

      emit(
        GameLoaded(
          newBoard,
          highScore: updatedHighScore,
          boardSize: currentState.boardSize,
        ),
      );
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
        adService.showInterstitialAd();
        emit(
          GameLoaded(
            currentState.gameBoard,
            highScore: currentState.highScore,
            isGameOver: true,
            boardSize: currentState.boardSize,
          ),
        );
      }
    }
  }

  /// Handles the [NewGameEvent] to start a fresh game.
  ///
  /// It creates a new game board and loads the current high score.
  Future<void> _onNewGame(NewGameEvent event, Emitter<GameState> emit) async {
    await clearBoard();
    final currentGameMode = await getGameMode();
    final newBoard = await newGame(currentGameMode.boardSize);
    final currentHighScore = await getHighScore(currentGameMode.boardSize);
    emit(
      GameLoaded(
        newBoard,
        highScore: currentHighScore.score,
        boardSize: currentGameMode.boardSize,
      ),
    );
  }

  /// Handles the [SaveGameEvent] to save the current game state.
  Future<void> _onSaveGame(
    SaveGameEvent event,
    Emitter<GameState> emit,
  ) async {
    if (state is GameLoaded) {
      final currentState = state as GameLoaded;
      await saveBoard(
        currentState.gameBoard,
        currentState.boardSize,
      );
    }
  }
}
