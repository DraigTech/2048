import 'package:flutter/material.dart';

/// A widget that displays a score.
class GameScoreWidget extends StatelessWidget {
  /// Creates a [GameScoreWidget] instance.
  const GameScoreWidget({
    required this.size,
    required this.scoreLabel,
    required this.score,
    this.fontSize = 20,
    super.key,
  });

  /// The size of the widget.
  final Size size;

  /// The font size of the score.
  final double fontSize;

  /// The label for the score.
  final String scoreLabel;

  /// The score value.
  final String score;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        color: Colors.blueGrey,
      ),
      width: size.width,
      height: size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            scoreLabel.toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: fontSize,
            ),
          ),
          Text(
            score,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
