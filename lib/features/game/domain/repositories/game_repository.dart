import 'package:_2048/features/game/domain/entities/game_board.dart';

abstract class GameRepository {
  Future<GameBoard> newGame();
  Future<GameBoard> move(GameBoard board, Direction direction);
}

enum Direction {
  up,
  down,
  left,
  right,
}
