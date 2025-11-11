import 'package:draig_2048/features/game/domain/entities/game_board.dart';
import 'package:draig_2048/features/game/domain/entities/tile.dart';
import 'package:draig_2048/features/game/domain/repositories/game_repository.dart';
import 'package:draig_2048/features/game/domain/usecases/check_game_over.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'check_game_over_test.mocks.dart';

@GenerateMocks([GameRepository])
void main() {
  late CheckGameOverUseCase useCase;
  late MockGameRepository mockGameRepository;

  setUp(() {
    mockGameRepository = MockGameRepository();
    useCase = CheckGameOverUseCase(mockGameRepository);
  });

  group('CheckGameOverUseCase', () {
    test(
      'should call GameRepository.isGameOver with correct parameters',
      () async {
        // Arrange
        const gameBoard = GameBoard(
          tiles: [
            [Tile(id: '1', value: 2, row: 0, column: 0)],
          ],
        );

        when(
          mockGameRepository.isGameOver(gameBoard),
        ).thenAnswer((_) async => true);

        // Act
        final result = await useCase.call(gameBoard);

        // Assert
        expect(result, true);
        verify(mockGameRepository.isGameOver(gameBoard)).called(1);
        verifyNoMoreInteractions(mockGameRepository);
      },
    );

    test('should return the game over status from the repository', () async {
      // Arrange
      const gameBoard = GameBoard(
        tiles: [
          [Tile(id: '1', value: 2, row: 0, column: 0)],
        ],
      );

      when(
        mockGameRepository.isGameOver(gameBoard),
      ).thenAnswer((_) async => false);

      // Act
      final result = await useCase.call(gameBoard);

      // Assert
      expect(result, false);
      verify(mockGameRepository.isGameOver(gameBoard)).called(1);
      verifyNoMoreInteractions(mockGameRepository);
    });
  });
}
