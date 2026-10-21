import 'package:draig_2048/features/game/domain/entities/game_board.dart';
import 'package:draig_2048/features/game/domain/entities/tile.dart';
import 'package:draig_2048/features/game/presentation/widgets/game_board_widget.dart';
import 'package:draig_2048/features/game/presentation/widgets/tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const board = GameBoard(
    tiles: [
      [
        Tile(id: 'tile-0-0', value: 2, row: 0, column: 0),
        Tile(id: 'tile-0-1', value: 4, row: 0, column: 1),
      ],
      [Tile(id: 'tile-1-2', value: 2048, row: 1, column: 2)],
    ],
  );

  Future<void> pumpBoard(WidgetTester tester, GameBoard gameBoard) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: GameBoardWidget(
              gameBoard: gameBoard,
              gameBoardSize: 400,
              gridSize: 4,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders a widget for every tile on the board', (tester) async {
    await pumpBoard(tester, board);

    expect(find.byType(TileWidget), findsNWidgets(3));
    expect(find.text('2'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
    expect(find.text('2048'), findsOneWidget);
  });

  testWidgets('positions each tile by its row and column', (tester) async {
    await pumpBoard(tester, board);

    final first = tester.widget<AnimatedPositioned>(
      find.byKey(const ValueKey('tile-0-0')),
    );
    final second = tester.widget<AnimatedPositioned>(
      find.byKey(const ValueKey('tile-0-1')),
    );
    final third = tester.widget<AnimatedPositioned>(
      find.byKey(const ValueKey('tile-1-2')),
    );

    expect(first.left, 0);
    expect(first.top, 0);
    expect(second.top, 0);
    expect(second.left, greaterThan(first.left!));
    expect(third.top, greaterThan(first.top!));
    expect(third.left, greaterThan(second.left!));
  });

  testWidgets('renders the grid when the board has no tiles', (tester) async {
    await pumpBoard(tester, const GameBoard(tiles: [[], [], [], []]));

    expect(find.byType(TileWidget), findsNothing);
  });
}
