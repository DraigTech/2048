import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:_2048/features/game/presentation/bloc/game_bloc.dart';
import 'package:_2048/features/game/domain/repositories/game_repository.dart';

class InputHandler extends StatelessWidget {
  final Widget child;

  const InputHandler({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKeyEvent: (event) {
        final physicalKey = event.physicalKey;
        if (physicalKey == PhysicalKeyboardKey.arrowUp ||
            physicalKey == PhysicalKeyboardKey.keyW) {
          context.read<GameBloc>().add(const GameMoveEvent(MoveDirection.up));
        } else if (physicalKey == PhysicalKeyboardKey.arrowDown ||
            physicalKey == PhysicalKeyboardKey.keyS) {
          context.read<GameBloc>().add(const GameMoveEvent(MoveDirection.down));
        } else if (physicalKey == PhysicalKeyboardKey.arrowLeft ||
            physicalKey == PhysicalKeyboardKey.keyA) {
          context.read<GameBloc>().add(const GameMoveEvent(MoveDirection.left));
        } else if (physicalKey == PhysicalKeyboardKey.arrowRight ||
            physicalKey == PhysicalKeyboardKey.keyD) {
          context.read<GameBloc>().add(
            const GameMoveEvent(MoveDirection.right),
          );
        }
      },
      child: GestureDetector(
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            context.read<GameBloc>().add(const GameMoveEvent(MoveDirection.up));
          } else if (details.primaryVelocity! > 0) {
            context.read<GameBloc>().add(
              const GameMoveEvent(MoveDirection.down),
            );
          }
        },
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            context.read<GameBloc>().add(
              const GameMoveEvent(MoveDirection.left),
            );
          } else if (details.primaryVelocity! > 0) {
            context.read<GameBloc>().add(
              const GameMoveEvent(MoveDirection.right),
            );
          }
        },
        child: child,
      ),
    );
  }
}
