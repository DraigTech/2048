import 'package:draig_2048/features/game/domain/repositories/game_repository.dart';

/// A use case that clears the game board.
class ClearBoardUseCase {
  /// Creates an instance of [ClearBoardUseCase].
  const ClearBoardUseCase(this.repository);

  /// The game repository.
  final GameRepository repository;

  /// Clears the game board.
  Future<void> call() {
    return repository.clearBoard();
  }
}
