import 'package:flutter/material.dart';
import 'package:_2048/features/game/domain/entities/game_board.dart';
import 'package:_2048/features/game/presentation/widgets/tile_widget.dart';

class GameBoardWidget extends StatelessWidget {
  final GameBoard gameBoard;

  const GameBoardWidget({super.key, required this.gameBoard});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double boardSize = screenWidth - 32;
    final double spacing = 4.0;
    final double tileSize = (boardSize - (spacing * 5)) / 4;

    List<Widget> tileWidgets = [];
    for (int row = 0; row < 4; row++) {
      for (int col = 0; col < 4; col++) {
        final tileValue = gameBoard.tiles[row][col];
        if (tileValue != 0) {
          tileWidgets.add(
            AnimatedPositioned(
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
              left: col * (tileSize + spacing),
              top: row * (tileSize + spacing),
              width: tileSize,
              height: tileSize,
              child: TileWidget(
                key: ValueKey('$row-$col-$tileValue'),
                value: tileValue,
              ),
            ),
          );
        }
      }
    }

    return Container(
      width: boardSize,
      height: boardSize,
      padding: EdgeInsets.all(spacing),
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
              ),
              itemCount: 16,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                );
              },
            ),
          ),
          ...tileWidgets,
        ],
      ),
    );
  }
}
