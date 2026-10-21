import 'package:draig_2048/features/game/domain/entities/game_board.dart';
import 'package:draig_2048/features/game/domain/entities/tile.dart';

GameBoard buildBoard(List<List<int>> values, {int score = 0}) {
  final tiles = <List<Tile>>[];
  for (var row = 0; row < values.length; row++) {
    final tilesInRow = <Tile>[];
    for (var column = 0; column < values[row].length; column++) {
      final value = values[row][column];
      if (value != 0) {
        tilesInRow.add(
          Tile(
            id: 'tile-$row-$column',
            value: value,
            row: row,
            column: column,
          ),
        );
      }
    }
    tiles.add(tilesInRow);
  }
  return GameBoard(tiles: tiles, score: score);
}
