import 'package:draig_2048/features/game/domain/entities/game_board.dart';
import 'package:draig_2048/features/game/domain/repositories/game_repository.dart';

/// A use case that loads the game board for a given board size.
class LoadBoardUseCase {
  /// Creates an instance of [LoadBoardUseCase].
  const LoadBoardUseCase(this.repository);

  /// The game repository.
  final GameRepository repository;

  /// Loads the game board.
  Future<GameBoard?> call(int boardSize) {
    return repository.loadBoard(boardSize);
  }
}
