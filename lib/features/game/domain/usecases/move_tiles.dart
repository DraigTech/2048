import 'package:_2048/features/game/domain/entities/game_board.dart';
import 'package:_2048/features/game/domain/repositories/game_repository.dart';

class MoveTilesUseCase {
  final GameRepository repository;

  MoveTilesUseCase(this.repository);

  Future<(GameBoard, bool)> call(GameBoard board, MoveDirection direction) {
    return repository.move(board, direction);
  }
}
