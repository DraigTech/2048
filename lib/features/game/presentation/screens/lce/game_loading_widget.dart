import 'package:flutter/material.dart';

/// A widget that displays a loading indicator for the game.
class GameLoadingWidget extends StatelessWidget {
  /// Creates a [GameLoadingWidget] instance.
  const GameLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
