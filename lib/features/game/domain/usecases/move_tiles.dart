import 'package:draig_2048/features/game/domain/entities/game_board.dart';
import 'package:draig_2048/features/game/domain/repositories/game_repository.dart';

/// A use case for moving tiles on the game board.
class MoveTilesUseCase {
  /// Creates a [MoveTilesUseCase] with the given [repository].
  MoveTilesUseCase(this.repository);

  /// The game repository to interact with.
  final GameRepository repository;

  /// Executes the use case to move tiles on the [board] in the 
  /// specified [direction].
  ///
  /// Returns a [Future] that completes with a tuple containing:
  /// - The updated [GameBoard] after the move.
  /// - A boolean indicating whether any tiles were merged during the move.
  Future<(GameBoard, bool)> call(GameBoard board, MoveDirection direction) {
    return repository.move(board, direction);
  }
}
