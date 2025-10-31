import 'package:equatable/equatable.dart';

class Tile extends Equatable {
  final int value;
  final int row;
  final int column;

  const Tile({required this.value, required this.row, required this.column});

  @override
  List<Object?> get props => [value, row, column];
}
