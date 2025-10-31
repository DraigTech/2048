import 'package:equatable/equatable.dart';

class GameBoard extends Equatable {
  final List<List<int>> tiles;

  const GameBoard({required this.tiles});

  @override
  List<Object?> get props => [tiles];
}
