import 'package:equatable/equatable.dart';
import 'package:_2048/features/game/domain/entities/tile.dart';

class GameBoard extends Equatable {
  final List<List<Tile>> tiles;
  final int score;

  const GameBoard({required this.tiles, this.score = 0});

  @override
  List<Object?> get props => [tiles, score];
}
