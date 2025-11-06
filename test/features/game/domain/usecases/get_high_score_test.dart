
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:_2048/features/game/domain/entities/high_score.dart';
import 'package:_2048/features/game/domain/repositories/game_repository.dart';
import 'package:_2048/features/game/domain/usecases/get_high_score.dart';

import 'get_high_score_test.mocks.dart';

@GenerateMocks([GameRepository])
void main() {
  late GetHighScoreUseCase getHighScoreUseCase;
  late MockGameRepository mockGameRepository;

  setUp(() {
    mockGameRepository = MockGameRepository();
    getHighScoreUseCase = GetHighScoreUseCase(mockGameRepository);
  });

  group('GetHighScoreUseCase', () {
    final tHighScore = HighScore(score: 100);

    test('should get high score from the repository', () async {
      // Arrange
      when(mockGameRepository.getHighScore()).thenAnswer((_) async => tHighScore);

      // Act
      final result = await getHighScoreUseCase.call();

      // Assert
      expect(result, tHighScore);
      verify(mockGameRepository.getHighScore()).called(1);
      verifyNoMoreInteractions(mockGameRepository);
    });
  });
}
