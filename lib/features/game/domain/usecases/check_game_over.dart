import 'package:_2048/features/game/domain/entities/game_board.dart';
import 'package:_2048/features/game/domain/repositories/game_repository.dart';

class CheckGameOverUseCase {
  final GameRepository repository;

  CheckGameOverUseCase(this.repository);

  Future<bool> call(GameBoard board) {
    return repository.isGameOver(board);
  }
}
