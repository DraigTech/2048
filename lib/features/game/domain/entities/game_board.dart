import 'package:equatable/equatable.dart';

class GameBoard extends Equatable {
  final List<List<int>> tiles;
  final int score;

  const GameBoard({required this.tiles, this.score = 0});

  @override
  List<Object?> get props => [tiles, score];
}
