
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:_2048/features/game/domain/entities/game_board.dart';
import 'package:_2048/features/game/domain/entities/tile.dart';
import 'package:_2048/features/game/domain/repositories/game_repository.dart';
import 'package:_2048/features/game/domain/usecases/move_tiles.dart';

import 'move_tiles_test.mocks.dart';

@GenerateMocks([GameRepository])
void main() {
  late MoveTilesUseCase moveTilesUseCase;
  late MockGameRepository mockGameRepository;

  setUp(() {
    mockGameRepository = MockGameRepository();
    moveTilesUseCase = MoveTilesUseCase(mockGameRepository);
  });

  group('MoveTilesUseCase', () {
    final tGameBoard = GameBoard(tiles: [
      [Tile(id: '1', value: 2, row: 0, column: 0), ?null, ?null, ?null],
      [?null, ?null, ?null, ?null],
      [?null, ?null, ?null, ?null],
      [?null, ?null, ?null, ?null],
    ]);
    final tMovedGameBoard = GameBoard(tiles: [
      [?null, ?null, ?null, ?null],
      [Tile(id: '1', value: 2, row: 1, column: 0), ?null, ?null, ?null],
      [?null, ?null, ?null, ?null],
      [?null, ?null, ?null, ?null],
    ]);

    test('should call repository.move with correct parameters', () async {
      // Arrange
      when(mockGameRepository.move(tGameBoard, MoveDirection.down)).thenAnswer((_) async => (tMovedGameBoard, false));

      // Act
      final result = await moveTilesUseCase.call(tGameBoard, MoveDirection.down);

      // Assert
      expect(result, (tMovedGameBoard, false));
      verify(mockGameRepository.move(tGameBoard, MoveDirection.down)).called(1);
      verifyNoMoreInteractions(mockGameRepository);
    });
  });
}
