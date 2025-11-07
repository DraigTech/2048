import 'package:draig_2048/features/game/domain/entities/high_score.dart';
import 'package:draig_2048/features/game/domain/repositories/game_repository.dart';

/// A use case for saving the high score.
class SaveHighScoreUseCase {
  /// Creates a [SaveHighScoreUseCase] with the given [repository].
  SaveHighScoreUseCase(this.repository);

  /// The game repository to interact with.
  final GameRepository repository;

  /// Executes the use case to save the given [highScore].
  ///
  /// Returns a [Future] that completes when the high score is saved.
  Future<void> call(HighScore highScore) {
    return repository.saveHighScore(highScore);
  }
}
