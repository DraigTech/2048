import 'package:flutter/material.dart';
import 'package:_2048/features/game/domain/entities/game_board.dart';
import 'package:_2048/features/game/presentation/widgets/tile_widget.dart';

class GameBoardWidget extends StatelessWidget {
  final GameBoard gameBoard;

  const GameBoardWidget({super.key, required this.gameBoard});

  @override
  Widget build(BuildContext context) {
    const double spacing = 4.0;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double boardSize = screenWidth - 32;
    final double tileSize = (boardSize - (spacing * 5)) / 4;

    List<Widget> tileWidgets = [];
    for (final rowTiles in gameBoard.tiles) {
      for (final tile in rowTiles) {
        tileWidgets.add(
          AnimatedPositioned(
            key: ValueKey(tile.id),
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
            left: tile.column * (tileSize + spacing),
            top: tile.row * (tileSize + spacing),
            width: tileSize,
            height: tileSize,
            child: TileWidget(value: tile.value),
          ),
        );
      }
    }

    return Container(
      width: boardSize,
      height: boardSize,
      padding: const EdgeInsets.all(spacing),
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
