import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputHandler extends StatelessWidget {
  final Widget child;
  final FocusNode focusNode;
  final Function moveUp;
  final Function moveDown;
  final Function moveLeft;
  final Function moveRight;

  const InputHandler({
    super.key,
    required this.child,
    required this.focusNode,
    required this.moveUp,
    required this.moveDown,
    required this.moveLeft,
    required this.moveRight,
  });

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: focusNode,
      autofocus: true,
      onKeyEvent: (event) {
        final physicalKey = event.physicalKey;
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
