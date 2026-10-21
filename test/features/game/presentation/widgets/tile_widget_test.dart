import 'package:draig_2048/features/game/presentation/widgets/tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpTile(WidgetTester tester, int value) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TileWidget(value: value),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the tile value as text', (tester) async {
    await pumpTile(tester, 2048);

    expect(find.text('2048'), findsOneWidget);
  });

  testWidgets('shows no text for an empty tile', (tester) async {
    await pumpTile(tester, 0);

    final text = tester.widget<Text>(
      find.descendant(
        of: find.byType(TileWidget),
        matching: find.byType(Text),
      ),
    );

    expect(text.data, isEmpty);
  });

  testWidgets('picks the background color for the tile value', (tester) async {
    await pumpTile(tester, 2048);

    final container = tester.widget<Container>(
      find.descendant(
        of: find.byType(TileWidget),
        matching: find.byType(Container),
      ),
    );

    expect(
      container.decoration,
      isA<BoxDecoration>().having(
        (decoration) => decoration.color,
        'color',
        Colors.yellow[700],
      ),
    );
  });

  testWidgets('falls back to grey for an unknown tile value', (tester) async {
    await pumpTile(tester, 3);

    final container = tester.widget<Container>(
      find.descendant(
        of: find.byType(TileWidget),
        matching: find.byType(Container),
      ),
    );

    expect(
      container.decoration,
      isA<BoxDecoration>().having(
        (decoration) => decoration.color,
        'color',
        Colors.grey[300],
      ),
    );
  });

  testWidgets('uses dark text for values below eight', (tester) async {
    await pumpTile(tester, 4);

    final text = tester.widget<Text>(find.text('4'));

    expect(text.style?.color, Colors.black);
  });
}
