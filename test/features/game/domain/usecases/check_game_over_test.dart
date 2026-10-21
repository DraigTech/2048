import 'package:draig_2048/features/game/data/repositories/game_repository_impl.dart';
import 'package:draig_2048/features/game/domain/usecases/check_game_over.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_daos.dart';
import '../../../../helpers/game_board_builder.dart';

void main() {
  late CheckGameOverUseCase useCase;

  setUp(() {
    final repository = GameRepositoryImpl(
      UnusedGameStateDao(),
      UnusedHighScoreDao(),
    );
    useCase = CheckGameOverUseCase(repository);
  });

  test('returns true for a full board without possible merges', () async {
    final board = buildBoard(
      [
        [2, 4, 8, 16],
        [4, 8, 16, 32],
        [8, 16, 32, 64],
        [16, 32, 64, 128],
      ],
    );

    expect(await useCase(board), isTrue);
  });

  test('returns false while an empty cell remains', () async {
    final board = buildBoard(
      [
        [2, 4, 8, 16],
        [4, 8, 16, 32],
        [8, 16, 32, 64],
        [16, 32, 64, 0],
      ],
    );

    expect(await useCase(board), isFalse);
  });

  test('returns false when a horizontal merge is available', () async {
    final board = buildBoard(
      [
        [2, 2, 8, 16],
        [4, 8, 16, 32],
        [8, 16, 32, 64],
        [16, 32, 64, 128],
      ],
    );

    expect(await useCase(board), isFalse);
  });

  test('returns false when a vertical merge is available', () async {
    final board = buildBoard(
      [
        [2, 4, 8, 16],
        [2, 8, 16, 32],
        [4, 16, 32, 64],
        [8, 32, 64, 128],
      ],
    );

    expect(await useCase(board), isFalse);
  });
}
