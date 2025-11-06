import 'package:_2048/features/game/domain/entities/high_score.dart';
import 'package:_2048/features/game/domain/repositories/game_repository.dart';

class GetHighScoreUseCase {
  final GameRepository repository;

  GetHighScoreUseCase(this.repository);

  Future<HighScore> call() {
    return repository.getHighScore();
  }
}
