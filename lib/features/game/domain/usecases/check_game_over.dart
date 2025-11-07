import 'package:draig_2048/features/game/domain/entities/game_board.dart';
import 'package:draig_2048/features/game/domain/repositories/game_repository.dart';

/// A use case for checking if the game is over.
class CheckGameOverUseCase {
  /// Creates a [CheckGameOverUseCase] with the given [repository].
  CheckGameOverUseCase(this.repository);

  /// The game repository to interact with.
  final GameRepository repository;

  /// Executes the use case to check if the game is over for a given [board].
  ///
  /// Returns a [Future] that completes with `true` if the game is over,
  /// `false` otherwise.
  Future<bool> call(GameBoard board) {
    return repository.isGameOver(board);
  }
}
