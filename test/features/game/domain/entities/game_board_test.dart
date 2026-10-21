import 'package:draig_2048/features/game/domain/entities/game_board.dart';
import 'package:draig_2048/features/game/domain/entities/tile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GameBoard', () {
    test('starts with a score of zero', () {
      const board = GameBoard(tiles: []);

      expect(board.score, 0);
    });

    test('copyWith keeps the tiles when only the score changes', () {
      const board = GameBoard(
        tiles: [
          [Tile(id: 'tile-0-0', value: 2, row: 0, column: 0)],
        ],
        score: 10,
      );

      final copy = board.copyWith(score: 20);

      expect(copy.score, 20);
      expect(copy.tiles, board.tiles);
    });

    test('copyWith keeps the score when only the tiles change', () {
      const board = GameBoard(
        tiles: [
          [Tile(id: 'tile-0-0', value: 2, row: 0, column: 0)],
        ],
        score: 10,
      );
      const newTiles = [
        [Tile(id: 'tile-1-1', value: 4, row: 1, column: 1)],
      ];

      final copy = board.copyWith(tiles: newTiles);

      expect(copy.tiles, newTiles);
      expect(copy.score, 10);
    });

    test('is equal to a board with the same tiles and score', () {
      const a = GameBoard(
        tiles: [
          [Tile(id: 'tile-0-0', value: 2, row: 0, column: 0)],
        ],
        score: 5,
      );
      const b = GameBoard(
        tiles: [
          [Tile(id: 'tile-0-0', value: 2, row: 0, column: 0)],
        ],
        score: 5,
      );
      const otherScore = GameBoard(
        tiles: [
          [Tile(id: 'tile-0-0', value: 2, row: 0, column: 0)],
        ],
        score: 6,
      );

      expect(a, b);
      expect(a, isNot(otherScore));
    });
  });
}
