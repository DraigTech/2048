import 'package:equatable/equatable.dart';

class Tile extends Equatable {
  final String id;
  final int value;
  final int row;
  final int column;

  const Tile({required this.id, required this.value, required this.row, required this.column});

  Tile copyWith({
    String? id,
    int? value,
    int? row,
    int? column,
  }) {
    return Tile(
      id: id ?? this.id,
      value: value ?? this.value,
      row: row ?? this.row,
      column: column ?? this.column,
    );
  }

  @override
  List<Object?> get props => [id, value, row, column];
}
