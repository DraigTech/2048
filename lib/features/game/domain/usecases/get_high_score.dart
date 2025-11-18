import 'package:draig_2048/features/game/domain/entities/high_score.dart';
import 'package:draig_2048/features/game/domain/repositories/game_repository.dart';

/// A use case for retrieving the high score.
class GetHighScoreUseCase {
  /// Creates a [GetHighScoreUseCase] with the given [repository].
  GetHighScoreUseCase(this.repository);

  /// The game repository to interact with.
  final GameRepository repository;

  /// Executes the use case to retrieve the high score.
  ///
  /// Returns a [Future] that completes with a [HighScore] object.
  Future<HighScore> call(int boardSize) {
    return repository.getHighScore(boardSize);
  }
}
