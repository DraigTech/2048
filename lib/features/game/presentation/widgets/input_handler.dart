import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A widget that handles user input for the game,
/// including keyboard and swipe gestures.
class InputHandler extends StatelessWidget {
  /// Creates an [InputHandler] instance.
  const InputHandler({
    required this.child,
    required this.focusNode,
    required this.moveUp,
    required this.moveDown,
    required this.moveLeft,
    required this.moveRight,
    super.key,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// The focus node used to capture keyboard events.
  final FocusNode focusNode;

  /// Callback function for moving tiles upwards.
  final VoidCallback moveUp;

  /// Callback function for moving tiles downwards.
  final VoidCallback moveDown;

  /// Callback function for moving tiles to the left.
  final VoidCallback moveLeft;

  /// Callback function for moving tiles to the right.
  final VoidCallback moveRight;

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: focusNode,
      autofocus: true,
      onKeyEvent: (event) {
        final physicalKey = event.physicalKey;
        if (event is KeyDownEvent) {
          if (physicalKey == PhysicalKeyboardKey.arrowUp ||
              physicalKey == PhysicalKeyboardKey.keyW) {
            moveUp();
          } else if (physicalKey == PhysicalKeyboardKey.arrowDown ||
              physicalKey == PhysicalKeyboardKey.keyS) {
            moveDown();
          } else if (physicalKey == PhysicalKeyboardKey.arrowLeft ||
              physicalKey == PhysicalKeyboardKey.keyA) {
            moveLeft();
          } else if (physicalKey == PhysicalKeyboardKey.arrowRight ||
              physicalKey == PhysicalKeyboardKey.keyD) {
            moveRight();
          }
        }
      },
      child: GestureDetector(
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            moveUp();
          } else if (details.primaryVelocity! > 0) {
            moveDown();
          }
        },
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            moveLeft();
          } else if (details.primaryVelocity! > 0) {
            moveRight();
          }
        },
        child: child,
      ),
    );
  }
}
