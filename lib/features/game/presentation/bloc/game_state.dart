part of 'game_bloc.dart';

/// Abstract base class for all game states.
sealed class GameState extends Equatable {
  /// Creates a [GameState] instance.
  const GameState();

  @override
  List<Object> get props => [];
}

/// Initial state of the game before any game board is loaded.
class GameInitial extends GameState {}

/// State representing a loaded game with a [gameBoard], [highScore],
/// and game over status.
class GameLoaded extends GameState {
  /// Creates a [GameLoaded] state.
  const GameLoaded(
    this.gameBoard, {
    required this.highScore,
    this.isGameOver = false,
  });

  /// The current state of the game board.
  final GameBoard gameBoard;

  /// The current high score.
  final int highScore;

  /// Indicates whether the game is over.
  final bool isGameOver;

  @override
  List<Object> get props => [gameBoard, highScore, isGameOver];
}


/// State representing an error during game operations.
final class GameError extends GameState {
  /// Creates a [GameError] state.
  const GameError(this.message);

  /// The error message associated with the state.
  final String message;

  @override
  List<Object> get props => [message];
}
