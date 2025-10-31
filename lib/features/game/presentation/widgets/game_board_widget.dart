import 'package:flutter/material.dart';
import 'package:_2048/features/game/domain/entities/game_board.dart';

class GameBoardWidget extends StatelessWidget {
  final GameBoard gameBoard;

  const GameBoardWidget({super.key, required this.gameBoard});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemCount: 16,
      itemBuilder: (context, index) {
        final row = index ~/ 4;
        final col = index % 4;
        final tileValue = gameBoard.tiles[row][col];
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: Text(
              tileValue == 0 ? '' : tileValue.toString(),
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
