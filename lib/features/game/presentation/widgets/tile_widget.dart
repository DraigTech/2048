import 'package:flutter/material.dart';

/// A widget that displays a single tile on the game board.
class TileWidget extends StatelessWidget {
  /// Creates a [TileWidget] instance.
  const TileWidget({required this.value, super.key});

  /// The numerical value displayed on the tile.
  final int value;

  /// Returns the background color for a tile based on its [value].
  Color _getTileColor(int value) {
    switch (value) {
      case 0:
        return Colors.grey[300]!;
      case 2:
        return Colors.orange[100]!;
      case 4:
        return Colors.orange[200]!;
      case 8:
        return Colors.orange[300]!;
      case 16:
        return Colors.orange[400]!;
      case 32:
        return Colors.orange[500]!;
      case 64:
        return Colors.orange[600]!;
      case 128:
        return Colors.yellow[300]!;
      case 256:
        return Colors.yellow[400]!;
      case 512:
        return Colors.yellow[500]!;
      case 1024:
        return Colors.yellow[600]!;
      case 2048:
        return Colors.yellow[700]!;
      default:
        return Colors.grey[300]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 150),
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Container(
            decoration: BoxDecoration(
              color: _getTileColor(value),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                value == 0 ? '' : value.toString(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: value < 8 ? Colors.black : Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
