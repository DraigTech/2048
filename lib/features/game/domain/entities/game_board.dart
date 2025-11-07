import 'package:draig_2048/features/game/domain/entities/tile.dart';
import 'package:equatable/equatable.dart';

/// Represents the state of the 2048 game board.
///
/// Contains the current arrangement of [tiles] and the player's [score].
class GameBoard extends Equatable {
  /// Creates a [GameBoard] instance.
  const GameBoard({required this.tiles, this.score = 0});

  /// A 2D list representing the tiles on the game board.
  final List<List<Tile>> tiles;

  /// The current score of the game.
  final int score;

  @override
  List<Object?> get props => [tiles, score];

  /// Creates a new [GameBoard] instance with updated values.
  ///
  /// If [tiles] or [score] are provided, they will replace the current values.
  /// Otherwise, the existing values will be used.
  GameBoard copyWith({List<List<Tile>>? tiles, int? score}) {
    return GameBoard(tiles: tiles ?? this.tiles, score: score ?? this.score);
  }
}
