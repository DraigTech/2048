import 'package:draig_2048/features/game/domain/entities/game_board.dart';
import 'package:draig_2048/features/game/domain/repositories/game_repository.dart';

/// A use case that creates a new game board for a given board size.
class NewGameUseCase {
  /// Creates an instance of [NewGameUseCase].
  const NewGameUseCase(this.repository);

  /// The game repository.
  final GameRepository repository;

  /// Creates a new game board.
  Future<GameBoard> call(int boardSize) {
    return repository.newGame(boardSize);
  }
}
