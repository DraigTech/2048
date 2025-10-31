import 'package:_2048/features/game/domain/entities/high_score.dart';
import 'package:_2048/features/game/domain/repositories/game_repository.dart';

class SaveHighScoreUseCase {
  final GameRepository repository;

  SaveHighScoreUseCase(this.repository);

  Future<void> call(HighScore highScore) {
    return repository.saveHighScore(highScore);
  }
}
