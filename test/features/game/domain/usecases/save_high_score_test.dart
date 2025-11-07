import 'package:draig_2048/features/game/domain/entities/high_score.dart';
import 'package:draig_2048/features/game/domain/repositories/game_repository.dart';
import 'package:draig_2048/features/game/domain/usecases/save_high_score.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'save_high_score_test.mocks.dart';

@GenerateMocks([GameRepository])
void main() {
  late SaveHighScoreUseCase saveHighScoreUseCase;
  late MockGameRepository mockGameRepository;

  setUp(() {
    mockGameRepository = MockGameRepository();
    saveHighScoreUseCase = SaveHighScoreUseCase(mockGameRepository);
  });

  group('SaveHighScoreUseCase', () {
    const tHighScore = HighScore(score: 100);

    test(
      'should call repository.saveHighScore with correct parameters',
      () async {
        // Arrange
        when(
          mockGameRepository.saveHighScore(tHighScore),
        ).thenAnswer((_) async => {});

        // Act
        await saveHighScoreUseCase.call(tHighScore);

        // Assert
        verify(mockGameRepository.saveHighScore(tHighScore)).called(1);
        verifyNoMoreInteractions(mockGameRepository);
      },
    );
  });
}
