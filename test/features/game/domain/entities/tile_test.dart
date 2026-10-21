import 'package:draig_2048/features/game/domain/entities/tile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Tile', () {
    test('keeps every field when copyWith receives no arguments', () {
      const tile = Tile(id: 'tile-1', value: 2, row: 0, column: 1);

      final copy = tile.copyWith();

      expect(copy, tile);
      expect(identical(copy, tile), isFalse);
    });

    test('replaces only the fields passed to copyWith', () {
      const tile = Tile(id: 'tile-1', value: 2, row: 0, column: 1);

      final copy = tile.copyWith(value: 4, row: 2);

      expect(copy.value, 4);
      expect(copy.row, 2);
      expect(copy.id, 'tile-1');
      expect(copy.column, 1);
    });

    test('is equal to a tile with the same id, value and position', () {
      const a = Tile(id: 'tile-1', value: 8, row: 3, column: 3);
      const b = Tile(id: 'tile-1', value: 8, row: 3, column: 3);

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('differs from a tile with another id or value', () {
      const a = Tile(id: 'tile-1', value: 8, row: 3, column: 3);
      final otherId = a.copyWith(id: 'tile-2');
      final otherValue = a.copyWith(value: 16);

      expect(a, isNot(otherId));
      expect(a, isNot(otherValue));
    });
  });
}
