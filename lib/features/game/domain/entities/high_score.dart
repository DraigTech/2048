import 'package:equatable/equatable.dart';

/// Represents a high score in the game.
class HighScore extends Equatable {
  /// Creates a [HighScore] instance.
  const HighScore({required this.score});

  /// The value of the high score.
  final int score;

  @override
  List<Object?> get props => [score];
}
