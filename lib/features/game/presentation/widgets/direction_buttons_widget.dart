import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:_2048/features/game/domain/repositories/game_repository.dart';
import 'package:_2048/features/game/presentation/bloc/game_bloc.dart';

class DirectionButtons extends StatelessWidget {
  const DirectionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: MoveDirection.values.map((direction) {
        return ElevatedButton(
          onPressed: () => context.read<GameBloc>().add(GameMoveEvent(direction)),
          child: Text(direction.name),
        );
      }).toList(),
    );
  }
}
