import 'package:_2048/features/game/domain/entities/game_board.dart';
import 'package:_2048/features/game/domain/entities/high_score.dart';

abstract class GameRepository {
  Future<GameBoard> newGame();
  Future<(GameBoard, bool)> move(GameBoard board, Direction direction);
  Future<HighScore> getHighScore();
  Future<void> saveHighScore(HighScore highScore);
}

enum Direction {
  up,
  down,
  left,
  right,
}
