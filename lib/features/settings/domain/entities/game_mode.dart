import 'package:equatable/equatable.dart';

/// A class that represents the game mode settings.
class GameMode extends Equatable {
  /// Creates a [GameMode] instance.
  const GameMode({
    required this.boardSize,
    required this.tilesToSpawn,
  });

  /// The size of the game board (e.g., 4 for a 4x4 grid).
  final int boardSize;

  /// The number of new tiles to spawn per move.
  final int tilesToSpawn;

  /// The classic 4x4 game mode.
  static const classic = GameMode(boardSize: 4, tilesToSpawn: 1);

  /// The 5x5 game mode.
  static const big = GameMode(boardSize: 5, tilesToSpawn: 2);

  /// The 6x6 game mode.
  static const bigger = GameMode(boardSize: 6, tilesToSpawn: 3);

  /// A list of all available game modes.
  static const List<GameMode> allModes = [classic, big, bigger];

  @override
  List<Object?> get props => [boardSize, tilesToSpawn];
}
