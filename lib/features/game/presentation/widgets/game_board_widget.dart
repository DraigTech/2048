import 'package:draig_2048/features/game/domain/entities/game_board.dart';
import 'package:draig_2048/features/game/presentation/widgets/tile_widget.dart';
import 'package:flutter/material.dart';

/// A widget that displays the 2048 game board.
class GameBoardWidget extends StatelessWidget {
  /// Creates a [GameBoardWidget] instance.
  const GameBoardWidget({
    required this.gameBoard,
    required this.gameBoardSize,
    super.key,
  });

  /// The current state of the game board.
  final GameBoard gameBoard;

  /// The size (width and height) of the game board.
  final double gameBoardSize;

  @override
  Widget build(BuildContext context) {
    const double spacing = 4;
    const double gridSize = 4;
    final tileSize = (gameBoardSize - spacing * (gridSize + 1)) / gridSize;

    final tileWidgets = <Widget>[];
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
      width: gameBoardSize,
      height: gameBoardSize,
      padding: const EdgeInsets.all(spacing),
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
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
                    borderRadius: BorderRadius.circular(8),
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
