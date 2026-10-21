import 'package:draig_2048/features/game/data/repositories/game_repository_impl.dart';
import 'package:draig_2048/features/game/domain/repositories/game_repository.dart';
import 'package:draig_2048/features/game/domain/usecases/move_tiles.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_daos.dart';
import '../../../../helpers/game_board_builder.dart';

void main() {
  late MoveTilesUseCase useCase;

  setUp(() {
    final repository = GameRepositoryImpl(
      UnusedGameStateDao(),
      UnusedHighScoreDao(),
    );
    useCase = MoveTilesUseCase(repository);
  });

  test('merges a pair to the left and scores the merge', () async {
    final original = buildBoard(
      [
        [2, 2, 4, 8],
        [2, 4, 8, 16],
        [4, 8, 16, 32],
        [8, 16, 32, 64],
      ],
    );

    final (updated, merged) = await useCase(original, MoveDirection.left);

    expect(merged, isTrue);
    expect(updated.score, 4);
    expect(updated.tiles[0], hasLength(4));
    expect(updated.tiles[0][0].value, 4);
    expect(updated.tiles[0][1].value, 4);
    expect(updated.tiles[0][2].value, 8);
    expect(updated.tiles[0][3].value, anyOf(2, 4));
    expect(updated.tiles[0][3].row, 0);
    expect(updated.tiles[0][3].column, 3);
    expect(updated.tiles[1], original.tiles[1]);
    expect(updated.tiles[2], original.tiles[2]);
    expect(updated.tiles[3], original.tiles[3]);
    expect(original.tiles[0][0].value, 2);
  });

  test('merges a pair to the right and scores the merge', () async {
    final original = buildBoard(
      [
        [8, 4, 2, 2],
        [2, 4, 8, 16],
        [4, 8, 16, 32],
        [16, 32, 64, 128],
      ],
    );

    final (updated, merged) = await useCase(original, MoveDirection.right);

    expect(merged, isTrue);
    expect(updated.score, 4);
    expect(updated.tiles[0], hasLength(4));
    expect(updated.tiles[0][0].value, anyOf(2, 4));
    expect(updated.tiles[0][0].row, 0);
    expect(updated.tiles[0][0].column, 0);
    expect(updated.tiles[0][1].value, 8);
    expect(updated.tiles[0][2].value, 4);
    expect(updated.tiles[0][3].value, 4);
    expect(updated.tiles[1], original.tiles[1]);
    expect(updated.tiles[2], original.tiles[2]);
    expect(updated.tiles[3], original.tiles[3]);
  });

  test('merges a pair upward and scores the merge', () async {
    final original = buildBoard(
      [
        [2, 4, 8, 16],
        [2, 8, 16, 32],
        [4, 16, 32, 64],
        [8, 32, 64, 128],
      ],
    );

    final (updated, merged) = await useCase(original, MoveDirection.up);

    expect(merged, isTrue);
    expect(updated.score, 4);
    expect(updated.tiles[0], hasLength(4));
    expect(updated.tiles[0][0].value, 4);
    expect(updated.tiles[1][0].value, 4);
    expect(updated.tiles[2][0].value, 8);
    expect(updated.tiles[0][3].value, 16);
    expect(updated.tiles[3][0].value, anyOf(2, 4));
    expect(updated.tiles[3][0].row, 3);
    expect(updated.tiles[3][0].column, 0);
  });

  test('merges a pair downward and scores the merge', () async {
    final original = buildBoard(
      [
        [8, 2, 4, 16],
        [4, 8, 16, 32],
        [2, 16, 32, 64],
        [2, 32, 64, 128],
      ],
    );

    final (updated, merged) = await useCase(original, MoveDirection.down);

    expect(merged, isTrue);
    expect(updated.score, 4);
    expect(updated.tiles[0], hasLength(4));
    expect(updated.tiles[0][0].value, anyOf(2, 4));
    expect(updated.tiles[0][0].row, 0);
    expect(updated.tiles[0][0].column, 0);
    expect(updated.tiles[1][0].value, 8);
    expect(updated.tiles[2][0].value, 4);
    expect(updated.tiles[3][0].value, 4);
    expect(updated.tiles[0][3].value, 16);
  });

  test('spawns two tiles after a merge in 5x5 mode', () async {
    final original = buildBoard(
      [
        [2, 2, 4, 4, 8],
        [2, 4, 8, 16, 32],
        [4, 8, 16, 32, 64],
        [8, 16, 32, 64, 128],
        [16, 32, 64, 128, 256],
      ],
    );

    final (updated, merged) = await useCase(original, MoveDirection.left);

    expect(merged, isTrue);
    expect(updated.score, 12);
    expect(updated.tiles[0], hasLength(5));
    expect(updated.tiles[0][0].value, 4);
    expect(updated.tiles[0][1].value, 8);
    expect(updated.tiles[0][2].value, 8);
    expect(updated.tiles[0][3].value, anyOf(2, 4));
    expect(updated.tiles[0][4].value, anyOf(2, 4));
    expect(updated.tiles[4], original.tiles[4]);
  });

  test('keeps the board unchanged when no move is possible', () async {
    final original = buildBoard(
      [
        [2, 4, 8, 16],
        [4, 8, 16, 32],
        [8, 16, 32, 64],
        [16, 32, 64, 128],
      ],
      score: 1234,
    );

    final (updated, merged) = await useCase(original, MoveDirection.left);

    expect(merged, isFalse);
    expect(updated, original);
  });
}
