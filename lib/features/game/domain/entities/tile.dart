import 'package:equatable/equatable.dart';

/// Represents a single tile on the 2048 game board.
class Tile extends Equatable {
  /// Creates a [Tile] instance.
  const Tile({
    required this.id,
    required this.value,
    required this.row,
    required this.column,
  });

  /// The unique identifier for the tile.
  final String id;

  /// The numerical value displayed on the tile.
  final int value;

  /// The row index of the tile on the game board.
  final int row;

  /// The column index of the tile on the game board.
  final int column;

  /// Creates a new [Tile] instance with updated values.
  ///
  /// If [id], [value], [row], or [column] are provided, they will replace
  /// the current values. Otherwise, the existing values will be used.
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
