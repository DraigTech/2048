import 'package:draig_2048/features/game/domain/entities/game_board.dart';
import 'package:draig_2048/features/game/domain/repositories/game_repository.dart';

/// A use case that saves the game board for a given board size.
class SaveBoardUseCase {
  /// Creates an instance of [SaveBoardUseCase].
  const SaveBoardUseCase(this.repository);

  /// The game repository.
  final GameRepository repository;

  /// Saves the game board.
  Future<void> call(GameBoard board, int boardSize) {
    return repository.saveBoard(board, boardSize);
  }
}
