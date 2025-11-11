import 'package:draig_2048/features/game/domain/entities/game_board.dart';
import 'package:draig_2048/features/game/domain/entities/high_score.dart';

/// Abstract class defining the contract for game-related operations.
///
/// Implementations of this interface will provide the concrete logic for
/// managing the game state, including creating new games,
/// handling tile movements, checking game-over conditions,
/// and managing high scores.
abstract class GameRepository {
  /// Starts a new game, returning the initial [GameBoard].
  Future<GameBoard> newGame();

  /// Moves tiles on the [board] in the specified [direction].
  ///
  /// Returns a tuple containing the updated [GameBoard] and a boolean
  /// indicating whether any tiles were merged during the move.
  Future<(GameBoard, bool)> move(GameBoard board, MoveDirection direction);

  /// Checks if the game is over for the given [board].
  ///
  /// Returns `true` if the game is over, `false` otherwise.
  Future<bool> isGameOver(GameBoard board);

  /// Retrieves the highest score recorded.
  Future<HighScore> getHighScore();

  /// Saves the given [highScore].
  Future<void> saveHighScore(HighScore highScore);

  /// Loads the saved game board from persistence.
  ///
  /// Returns the saved [GameBoard] or `null` if no saved game exists.
  Future<GameBoard?> loadBoard();

  /// Saves the current [board] to persistence.
  Future<void> saveBoard(GameBoard board);

  /// Clears the saved game board from persistence.
  Future<void> clearBoard();
}

/// Represents the possible directions for moving tiles on the game board.
enum MoveDirection {
  /// Move tiles upwards.
  up,

  /// Move tiles downwards.
  down,

  /// Move tiles to the left.
  left,

  /// Move tiles to the right.
  right,
}
